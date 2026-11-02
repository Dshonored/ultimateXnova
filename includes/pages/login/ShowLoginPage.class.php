<?php

/**
*  ultimateXnova
*  based on 2moons by Jan-Otto Kröpke 2009-2016
 *
 * For the full copyright and license information, please view the LICENSE
 *
 * @package ultimateXnova
 * @author Jan-Otto Kröpke <slaver7@gmail.com>
 * @copyright 2009 Lucky
 * @copyright 2016 Jan-Otto Kröpke <slaver7@gmail.com>
 * @copyright 2022 Koray Karakuş <koraykarakus@yahoo.com>
 * @copyright 2024 Pfahli (https://github.com/Pfahli)
 * @licence MIT
 * @version 1.8.x Koray Karakuş <koraykarakus@yahoo.com>
 * @link https://github.com/ultimateXnova/ultimateXnova
 */


require_once 'includes/classes/LoginThrottle.class.php';
require_once 'includes/classes/LoginCode.class.php';

class ShowLoginPage extends AbstractLoginPage
{
	public static $requireModule = 0;

	function __construct()
	{
		parent::__construct();
	}

	function generateRememberMeToken($universe){

    $selector = bin2hex(random_bytes(16));
    $validator = bin2hex(random_bytes(32));

		return array(
			'selector' => $selector,
			'validator' => $validator,
			'full' => $universe . ':' . $selector . ':' . $validator
		);

	}



	function validate(){
		global $config, $LNG;

		$db = Database::get();

		$userEmail = trim(HTTP::_GP('userEmail', '', true));
		$password = HTTP::_GP('password', '', true);
		$csrfToken = HTTP::_GP('csrfToken','',true);
		$remember_me = HTTP::_GP('remember_me', 'false');
		$rememberedTokenValidator = HTTP::_GP('rememberedTokenValidator', '');
		$rememberedTokenSelector = HTTP::_GP('rememberedTokenSelector', '');
		$rememberedEmail = HTTP::_GP('rememberedEmail','');
		$universe = HTTP::_GP('universe', Universe::current());
		if (!in_array((int) $universe, Universe::availableUniverses())) {
			$universe = Universe::current();
		}

		$error = array();
		$loginData = false;

		if (!isset($_COOKIE['csrfToken']) || !is_string($csrfToken) || $csrfToken === '' || !hash_equals((string) $_COOKIE['csrfToken'], $csrfToken)) {
			$error[] = "csrf attack";
		}

		// Brute force protection: per IP and per e-mail
		if (LoginThrottle::isBlocked($userEmail)) {
			$error[] = $LNG['login_error_throttled'];
			$error['status'] = "fail";
			$this->sendJSON($error);
		}

		if (empty($userEmail)) {
			$error[] = $LNG['login_error_1'];
		}

		if (empty($password)) {
			$error[] = $LNG['login_error_2'];
		}

		if (!empty($password) && !empty($userEmail)) {
			// Login is by e-mail only (the username is just the in-game name)
			$sql = "SELECT id, password, email FROM %%USERS%% WHERE email = :email AND universe = :universe;";
			$loginData = $db->selectSingle($sql, array(
				':email'	=> $userEmail,
				':universe'	=> $universe,
			));
		}

		$usesRememberToken = !empty($rememberedTokenValidator) && !empty($rememberedTokenSelector)
			&& $rememberedEmail === $userEmail && $password === 'password';

		if (!empty($password) && !empty($userEmail)) {
			if (!$usesRememberToken) {
				// Same error for "unknown user" and "wrong password" to avoid account enumeration.
				// password_verify still runs against a dummy hash so timing does not leak either.
				$hash = $loginData ? $loginData['password'] : '$2y$10$usesomesillystringforsaltDummyHashToKeepTimingConstant..';
				if (!password_verify($password, $hash) || !$loginData) {
					$error[] = $LNG['login_error_invalid'];
				}
			} else {
				$sql = "SELECT * FROM %%REMEMBER_ME%% WHERE selector = :selector;";
				$rememberedTokenInfo = $db->selectSingle($sql,array(
					':selector' => $rememberedTokenSelector,
				));

				if (!$rememberedTokenInfo || !$loginData
					|| (int) $rememberedTokenInfo['expiration_date'] < TIMESTAMP
					|| (int) $rememberedTokenInfo['user_id'] !== (int) $loginData['id']
					|| !password_verify($rememberedTokenValidator, $rememberedTokenInfo['hashed_validator'])) {
					$error[] = $LNG['login_error_invalid'];
				}
			}
		}

		if ($config->capaktiv === '1' && $config->use_recaptcha_on_login)
		{
      require('includes/libs/reCAPTCHA/src/autoload.php');

      $recaptcha = new \ReCaptcha\ReCaptcha($config->capprivate);
      $resp = $recaptcha->verify(HTTP::_GP('g_recaptcha_response', ''), Session::getClientIp());
      if (!$resp->isSuccess())
      {
          $error[]	= $LNG['login_error_4'];
      }
		}



		if (empty($error))
		{
			LoginThrottle::clear($userEmail);

			// Password (or remember-me token) is correct. The e-mail code is only asked once a
			// month per account (or on a device/account that never proved it owns the inbox).
			if ($usesRememberToken
				|| LoginCode::isAccountVerified((int) $loginData['id'])
				|| LoginCode::isTrustedDevice((int) $loginData['id'])) {
				$this->completeLogin((int) $loginData['id'], $universe, $remember_me);
			}

			if (!Mail::isConfigured() && !LoginCode::devLogEnabled()) {
				$error[] = $LNG['login_code_mail_missing'];
				$error['status'] = "fail";
				$this->sendJSON($error);
			}

			LoginCode::start((int) $loginData['id'], $loginData['email'], $universe, $remember_me === 'true');

			$this->sendJSON(array(
				'status'  => 'code',
				'message' => $LNG['login_code_sent'],
			));
		}
		else
		{
			LoginThrottle::recordFailure($userEmail);
			$error['status'] = "fail";
			$this->sendJSON($error);
		}
	}

	/**
	 * Second step: the 6-digit code that was e-mailed after a correct password.
	 */
	function verifyCode()
	{
		global $LNG;

		$csrfToken = HTTP::_GP('csrfToken', '', true);
		if (!isset($_COOKIE['csrfToken']) || $csrfToken === '' || !hash_equals((string) $_COOKIE['csrfToken'], $csrfToken)) {
			$this->sendJSON(array('status' => 'fail', 'csrf attack'));
		}

		$result = LoginCode::verify(HTTP::_GP('code', '', true));

		if ($result['ok']) {
			LoginCode::trustDevice($result['userId']);
			LoginCode::markAccountVerified($result['userId']);
			$this->completeLogin($result['userId'], $result['universe'], $result['remember'] ? 'true' : 'false');
		}

		$messages = array(
			'expired'  => $LNG['login_code_expired'],
			'too_many' => $LNG['login_code_too_many'],
			'wrong'    => $LNG['login_code_wrong'],
		);
		$this->sendJSON(array(
			'status'  => $result['reason'] === 'wrong' ? 'code_wrong' : 'fail',
			'message' => isset($messages[$result['reason']]) ? $messages[$result['reason']] : $LNG['login_code_expired'],
		));
	}

	private function completeLogin($userId, $universe, $remember_me)
	{
		$db = Database::get();

		$session	= Session::create();
		$session->userId		= (int) $userId;
		$session->adminAccess	= 0;
		$session->save();

		// Always drop old remember-me tokens; issue a fresh one if asked.
		$db->delete("DELETE FROM %%REMEMBER_ME%% WHERE user_id = :userId;", array(
			':userId' => (int) $userId
		));

		if ($remember_me == 'true') {
			$rememberMeToken = $this->generateRememberMeToken($universe);
			HTTP::sendCookie('remember_me', $rememberMeToken['full'], TIMESTAMP + 60 * 60 * 24 * 30);

			$sql = "INSERT INTO %%REMEMBER_ME%% (`selector`,`hashed_validator`, `expiration_date`, `user_id`,`universe`)
			VALUES (:selector,:hashed_validator,:expiration_date,:user_id,:universe);";
			$db->insert($sql, array(
				':selector'         => $rememberMeToken['selector'],
				':hashed_validator' => password_hash($rememberMeToken['validator'], PASSWORD_DEFAULT),
				':expiration_date'  => TIMESTAMP + 60 * 60 * 24 * 30,
				':user_id'          => (int) $userId,
				':universe'         => $universe
			));
		}

		$this->sendJSON(array('status' => 'redirect'));
	}
}
