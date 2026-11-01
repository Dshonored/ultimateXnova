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

class HTTP {

	static public function redirectTo($URL, $external = false)
	{
		if($external)
		{
			self::sendHeader('Location', $URL);
		}
		else
		{
			self::sendHeader('Location', HTTP_PATH.$URL);
		}
		exit;
	}

	static public function sendHeader($name, $value = NULL)
	{
		header($name.(!is_null($value) ? ': '.$value : ''));
	}

	static public function redirectToUniverse($universe)
	{
		HTTP::redirectTo(PROTOCOL.HTTP_HOST.HTTP_BASE."uni".$universe."/".HTTP_FILE, true);
	}

	static public function sendCookie($name, $value = "", $toTime = NULL)
	{
		setcookie($name, (string) $value, array(
			'expires'	=> (int) $toTime,
			'path'		=> '/',
			'secure'	=> HTTPS,
			'httponly'	=> true,
			'samesite'	=> 'Lax',
		));
	}

	/**
	 * Is the direct peer a private/loopback address (docker network, local reverse proxy, tunnel)?
	 * Only then forwarded-for headers are believed.
	 */
	static public function isTrustedProxy()
	{
		if (empty($_SERVER['REMOTE_ADDR']) || filter_var($_SERVER['REMOTE_ADDR'], FILTER_VALIDATE_IP) === false) {
			return false;
		}

		return filter_var($_SERVER['REMOTE_ADDR'], FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE) === false;
	}

	/**
	 * Central CSRF guard (Fetch Metadata + Origin/Referer). The templates carry no per-form token,
	 * so we reject every request the browser itself marks as cross-site.
	 * - POST/PUT/DELETE...: any cross-site request is rejected.
	 * - GET: top-level navigations from other sites are only allowed for read-only landing pages.
	 */
	static public function guardCrossSite(array $safeGetPages = array('overview', 'raport'))
	{
		$method	= isset($_SERVER['REQUEST_METHOD']) ? strtoupper($_SERVER['REQUEST_METHOD']) : 'GET';

		$crossSite	= false;
		if (isset($_SERVER['HTTP_SEC_FETCH_SITE'])) {
			$crossSite	= !in_array($_SERVER['HTTP_SEC_FETCH_SITE'], array('same-origin', 'same-site', 'none'), true);
		} else {
			$source	= '';
			if (!empty($_SERVER['HTTP_ORIGIN']) && $_SERVER['HTTP_ORIGIN'] !== 'null') {
				$source	= $_SERVER['HTTP_ORIGIN'];
			} elseif (!empty($_SERVER['HTTP_ORIGIN'])) {
				$crossSite	= true;
			} elseif (!empty($_SERVER['HTTP_REFERER'])) {
				$source	= $_SERVER['HTTP_REFERER'];
			}

			if ($source !== '') {
				$sourceHost	= parse_url($source, PHP_URL_HOST);
				$sourcePort	= parse_url($source, PHP_URL_PORT);
				if ($sourcePort) {
					$sourceHost	.= ':'.$sourcePort;
				}
				$crossSite	= $sourceHost === null || strcasecmp($sourceHost, HTTP_HOST) !== 0;
			}
		}

		if (!$crossSite) {
			return;
		}

		if (($method === 'GET' || $method === 'HEAD')) {
			$page	= isset($_GET['page']) && is_string($_GET['page']) ? $_GET['page'] : 'overview';
			$mode	= isset($_GET['mode']) && is_string($_GET['mode']) ? $_GET['mode'] : 'show';
			// only plain landing links: no extra parameters that could trigger an action
			$plainQuery	= count(array_diff(array_keys($_GET), array('page', 'mode', 'raport', 'uni', 'lang'))) === 0;
			if (in_array($page, $safeGetPages, true) && $mode === 'show' && $plainQuery) {
				return;
			}
		}

		self::sendHeader('HTTP/1.1 403 Forbidden');
		exit('Cross-site request blocked.');
	}

	static public function _GP($name, $default, $multibyte = false, $highnum = false)
	{
		if(!isset($_REQUEST[$name]))
		{
			return $default;
		}

		if(is_float($default) || $highnum)
		{
			return (float) $_REQUEST[$name];
		}

		if(is_int($default))
		{
			return (int) $_REQUEST[$name];
		}

		if(is_string($default))
		{
			return self::_quote($_REQUEST[$name], $multibyte);
		}

		if(is_array($default) && is_array($_REQUEST[$name]))
		{
			return self::_quoteArray($_REQUEST[$name], $multibyte, !empty($default) && $default[0] === 0);
		}

		return $default;
	}

	private static function _quoteArray($var, $multibyte, $onlyNumbers = false)
	{
		$data	= array();
		foreach($var as $key => $value)
		{
			if(is_array($value))
			{
				$data[$key]	= self::_quoteArray($value, $multibyte);
			}
			elseif($onlyNumbers)
			{
				$data[$key]	= (int) $value;
			}
			else
			{
				$data[$key]	= self::_quote($value, $multibyte);
			}
		}

		return $data;
	}

	private static function _quote($var, $multibyte)
	{
		if (!is_scalar($var)) {
			return '';
		}

		$var	= (string) $var;
		$var	= str_replace(array("\r\n", "\r", "\0"), array("\n", "\n", ''), $var);
		$var	= htmlspecialchars($var, ENT_QUOTES, 'UTF-8');
		$var	= trim($var);

		if ($multibyte) {
			if (!preg_match('/^./u', $var))
			{
				$var = '';
			}
		}
		else
		{
			$var = preg_replace('/[\x80-\xFF]/', '?', $var); // no multibyte, allow only ASCII (0-127)
		}

		return $var;
	}
}
