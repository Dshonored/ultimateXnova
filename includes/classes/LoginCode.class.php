<?php

/**
 * E-mailed one-time login codes (second login step) and trusted devices.
 *
 * After a correct password the player gets a 6-digit code by e-mail. Because the code
 * only ever goes to the account's address, an account with a fake e-mail cannot log in.
 *
 * - codes: 10 minutes, max 5 tries, single use; only a hash is stored (cache/logincodes)
 * - the pending login is bound to this browser through an HttpOnly cookie
 * - a valid code (or the registration link) verifies the ACCOUNT for 30 days: during that
 *   month no code is asked on any device. The record is HMAC-signed over the password hash,
 *   so a password change forces a new code right away.
 * - the browser is also trusted for 30 days with an HMAC-signed cookie (same password binding)
 *
 * Environment:
 *   APP_SECRET          long random string (required, signs trusted-device cookies)
 *   LOGIN_CODE_DEV_LOG  "1" writes codes to the PHP error log (local development only!)
 *
 * Part of ultimateXnova (AGPL-3.0). See LICENSE.
 */
class LoginCode
{
	const CODE_TTL       = 600;              // 10 minutes
	const MAX_ATTEMPTS   = 5;
	const TRUST_DAYS     = 30;
	const VERIFY_DAYS    = 30;             // e-mail code at most once a month per account
	const CHALLENGE_COOKIE = 'login_challenge';
	const TRUST_COOKIE     = 'trusted_device';

	static public function devLogEnabled()
	{
		return getenv('LOGIN_CODE_DEV_LOG') === '1';
	}

	/** Create a challenge, mail the code and bind it to this browser. */
	static public function start($userId, $email, $universe, $remember)
	{
		global $LNG;

		$challengeId = bin2hex(random_bytes(32));
		$code = str_pad((string) random_int(0, 999999), 6, '0', STR_PAD_LEFT);

		self::write($challengeId, array(
			'userId'   => (int) $userId,
			'universe' => (int) $universe,
			'remember' => (bool) $remember,
			'codeHash' => hash_hmac('sha256', $code, self::secret()),
			'expires'  => TIMESTAMP + self::CODE_TTL,
			'attempts' => 0,
		));
		self::setCookie(self::CHALLENGE_COOKIE, $challengeId, TIMESTAMP + self::CODE_TTL);

		$user = Database::get()->selectSingle("SELECT username FROM %%USERS%% WHERE id = :id;", array(':id' => (int) $userId));
		$gameName = Config::get($universe)->game_name;

		if (self::devLogEnabled()) {
			error_log('[LoginCode] DEV code for user '.(int) $userId.': '.$code);
		}

		if (Mail::isConfigured()) {
			Mail::send(
				$email,
				$user ? $user['username'] : '',
				sprintf($LNG['login_code_mail_subject'], $code, $gameName),
				sprintf($LNG['login_code_mail_body'], $user ? $user['username'] : '', $code, $gameName)
			);
		}
	}

	/**
	 * @return array ['ok' => bool, 'reason' => 'expired'|'too_many'|'wrong'|null, 'userId', 'universe', 'remember']
	 */
	static public function verify($code)
	{
		$fail = function ($reason) { return array('ok' => false, 'reason' => $reason); };

		$challengeId = isset($_COOKIE[self::CHALLENGE_COOKIE]) ? (string) $_COOKIE[self::CHALLENGE_COOKIE] : '';
		if (!preg_match('/^[a-f0-9]{64}$/', $challengeId)) {
			return $fail('expired');
		}

		$file = self::file($challengeId);
		$fp = @fopen($file, 'r+');
		if ($fp === false) {
			return $fail('expired');
		}
		flock($fp, LOCK_EX);
		$data = json_decode(stream_get_contents($fp), true);

		$finish = function ($result, $delete) use ($fp, $file) {
			flock($fp, LOCK_UN);
			fclose($fp);
			if ($delete) {
				@unlink($file);
				LoginCode::clearChallengeCookie();
			}
			return $result;
		};

		if (!is_array($data) || $data['expires'] < TIMESTAMP) {
			return $finish($fail('expired'), true);
		}
		if ($data['attempts'] >= self::MAX_ATTEMPTS) {
			return $finish($fail('too_many'), true);
		}

		$code = preg_replace('/\D/', '', (string) $code);
		if (strlen($code) !== 6 || !hash_equals($data['codeHash'], hash_hmac('sha256', $code, self::secret()))) {
			$data['attempts']++;
			ftruncate($fp, 0);
			rewind($fp);
			fwrite($fp, json_encode($data));
			return $finish($fail($data['attempts'] >= self::MAX_ATTEMPTS ? 'too_many' : 'wrong'), $data['attempts'] >= self::MAX_ATTEMPTS);
		}

		return $finish(array(
			'ok'       => true,
			'reason'   => null,
			'userId'   => (int) $data['userId'],
			'universe' => (int) $data['universe'],
			'remember' => (bool) $data['remember'],
		), true);
	}

	static public function trustDevice($userId)
	{
		$expires = TIMESTAMP + self::TRUST_DAYS * 86400;
		$value = (int) $userId.'.'.$expires.'.'.self::signature($userId, $expires);
		self::setCookie(self::TRUST_COOKIE, $value, $expires);
	}

	static public function isTrustedDevice($userId)
	{
		if (empty($_COOKIE[self::TRUST_COOKIE])) {
			return false;
		}
		$parts = explode('.', (string) $_COOKIE[self::TRUST_COOKIE]);
		if (count($parts) !== 3 || (int) $parts[0] !== (int) $userId || (int) $parts[1] < TIMESTAMP) {
			return false;
		}
		return hash_equals(self::signature($userId, (int) $parts[1]), $parts[2]);
	}

	/** The account proved it owns its inbox: no more codes for VERIFY_DAYS, on any device. */
	static public function markAccountVerified($userId)
	{
		$verifiedAt = TIMESTAMP;
		file_put_contents(self::verifiedFile($userId), json_encode(array(
			'verifiedAt' => $verifiedAt,
			'sig'        => self::signature($userId, $verifiedAt),
		)), LOCK_EX);
	}

	static public function isAccountVerified($userId)
	{
		$data = @json_decode((string) @file_get_contents(self::verifiedFile($userId)), true);
		if (!is_array($data) || !isset($data['verifiedAt'], $data['sig'])) {
			return false;
		}
		if ((int) $data['verifiedAt'] + self::VERIFY_DAYS * 86400 < TIMESTAMP) {
			return false;
		}
		return hash_equals(self::signature($userId, (int) $data['verifiedAt']), (string) $data['sig']);
	}

	static public function clearChallengeCookie()
	{
		self::setCookie(self::CHALLENGE_COOKIE, '', TIMESTAMP - 3600);
	}

	/** Signature covers the password hash: changing the password revokes all trusted devices. */
	static private function signature($userId, $expires)
	{
		$hash = Database::get()->selectSingle("SELECT password FROM %%USERS%% WHERE id = :id;", array(':id' => (int) $userId), 'password');
		return hash_hmac('sha256', (int) $userId.'|'.(int) $expires.'|'.(string) $hash, self::secret());
	}

	static private function secret()
	{
		$secret = getenv('APP_SECRET');
		if ($secret === false || strlen(trim($secret)) < 32) {
			throw new Exception('APP_SECRET must be set to at least 32 random characters');
		}
		return trim($secret);
	}

	static private function setCookie($name, $value, $expires)
	{
		setcookie($name, $value, array(
			'expires'  => $expires,
			'path'     => '/',
			'secure'   => !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off',
			'httponly' => true,
			'samesite' => 'Lax',
		));
	}

	static private function write($challengeId, $data)
	{
		self::gc();
		file_put_contents(self::file($challengeId), json_encode($data), LOCK_EX);
	}

	static private function file($challengeId)
	{
		$dir = ROOT_PATH.'cache/logincodes';
		if (!is_dir($dir)) {
			@mkdir($dir, 0770, true);
		}
		return $dir.'/'.hash('sha256', $challengeId).'.json';
	}

	static private function verifiedFile($userId)
	{
		$dir = ROOT_PATH.'cache/loginverified';
		if (!is_dir($dir)) {
			@mkdir($dir, 0770, true);
		}
		return $dir.'/'.(int) $userId.'.json';
	}

	/** Remove stale challenge files now and then. */
	static private function gc()
	{
		if (random_int(1, 20) !== 1) {
			return;
		}
		foreach ((array) glob(ROOT_PATH.'cache/logincodes/*.json') as $f) {
			if (is_file($f) && filemtime($f) < TIMESTAMP - self::CODE_TTL) {
				@unlink($f);
			}
		}
	}
}
