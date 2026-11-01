<?php

/**
 * Small brute-force limiter for the login and password-reset forms.
 *
 * Counts failures per client IP and per submitted identifier (e-mail) inside a sliding
 * window. State lives in cache/throttle as tiny JSON files, which is plenty for a private
 * server and needs no schema change.
 *
 * Part of ultimateXnova (AGPL-3.0). See LICENSE.
 */
class LoginThrottle
{
	const WINDOW_SECONDS = 900;   // 15 minutes
	const MAX_PER_IP     = 20;
	const MAX_PER_ID     = 8;

	static public function isBlocked($identifier)
	{
		return self::count('ip:'.Session::getClientIp()) >= self::MAX_PER_IP
			|| ($identifier !== '' && self::count('id:'.mb_strtolower($identifier)) >= self::MAX_PER_ID);
	}

	static public function recordFailure($identifier)
	{
		self::push('ip:'.Session::getClientIp());
		if ($identifier !== '') {
			self::push('id:'.mb_strtolower($identifier));
		}
	}

	static public function clear($identifier)
	{
		if ($identifier !== '') {
			@unlink(self::file('id:'.mb_strtolower($identifier)));
		}
	}

	static private function count($key)
	{
		return count(self::read(self::file($key)));
	}

	static private function push($key)
	{
		$file = self::file($key);
		$fp = @fopen($file, 'c+');
		if ($fp === false) {
			return;
		}
		flock($fp, LOCK_EX);
		$hits = self::filter(json_decode(stream_get_contents($fp), true));
		$hits[] = TIMESTAMP;
		ftruncate($fp, 0);
		rewind($fp);
		fwrite($fp, json_encode($hits));
		flock($fp, LOCK_UN);
		fclose($fp);
	}

	static private function read($file)
	{
		if (!is_file($file)) {
			return array();
		}
		return self::filter(json_decode((string) @file_get_contents($file), true));
	}

	static private function filter($hits)
	{
		if (!is_array($hits)) {
			return array();
		}
		$since = TIMESTAMP - self::WINDOW_SECONDS;
		return array_values(array_filter($hits, function ($t) use ($since) {
			return is_int($t) && $t > $since;
		}));
	}

	static private function file($key)
	{
		$dir = ROOT_PATH.'cache/throttle';
		if (!is_dir($dir)) {
			@mkdir($dir, 0770, true);
		}
		return $dir.'/'.hash('sha256', $key).'.json';
	}
}
