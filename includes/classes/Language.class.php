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

class Language implements ArrayAccess {
    private $container = array();
    private $language = array();
    static private $allLanguages = array();

	static function getAllowedLangs($OnlyKey = true)
	{
		if(empty(self::$allLanguages))
		{
			$cache	= Cache::get();
			$cache->add('language', 'LanguageBuildCache');
			self::$allLanguages = $cache->getData('language');
		}

		if($OnlyKey)
		{
			return array_keys(self::$allLanguages);
		}
		else
		{
			return self::$allLanguages;
		}
	}

	/**
	 * friends-edition: the language is a visitor choice, not an account setting.
	 * Priority: ?lang= (also stored) > "lang" cookie (mirrored from localStorage by
	 * scripts/base/lang-pref.js) > browser Accept-Language > DEFAULT_LANG (Spanish). Used for login AND in-game pages.
	 */
	static public function requestedLanguage()
	{
		$allowed = self::getAllowedLangs();

		if (isset($_GET['lang']) && is_string($_GET['lang']) && in_array($_GET['lang'], $allowed, true)) {
			HTTP::sendCookie('lang', $_GET['lang'], TIMESTAMP + 31536000);
			return $_GET['lang'];
		}
		if (isset($_COOKIE['lang']) && is_string($_COOKIE['lang']) && in_array($_COOKIE['lang'], $allowed, true)) {
			return $_COOKIE['lang'];
		}
		// No choice yet: follow the browser (Accept-Language, by preference order)
		if (!empty($_SERVER['HTTP_ACCEPT_LANGUAGE'])) {
			$ranked = array();
			foreach (explode(',', $_SERVER['HTTP_ACCEPT_LANGUAGE']) as $i => $part) {
				if (!preg_match('/^\s*([a-z]{1,8})(?:-[a-z0-9]{1,8})*\s*(?:;\s*q=([01](?:\.\d{1,3})?))?\s*$/i', $part, $m)) {
					continue;
				}
				$q = isset($m[2]) ? (float) $m[2] : 1.0;
				$ranked[] = array(strtolower($m[1]), $q, $i);
			}
			usort($ranked, function ($a, $b) { return $b[1] <=> $a[1] ?: $a[2] <=> $b[2]; });
			foreach ($ranked as $entry) {
				if ($entry[1] > 0 && in_array($entry[0], $allowed, true)) {
					return $entry[0];
				}
			}
		}
		return in_array(DEFAULT_LANG, $allowed, true) ? DEFAULT_LANG : 'en';
	}

	public function getUserAgentLanguage()
	{
		$language = self::requestedLanguage();
		$this->setLanguage($language);
		return $language;
	}

    public function __construct($language = NULL)
	{
		$this->setLanguage($language);
    }

    public function setLanguage($language)
	{
		if(!is_null($language) && in_array($language, self::getAllowedLangs()))
		{
			$this->language = $language;
		}
		elseif(MODE !== 'INSTALL')
		{
			$this->language	= Config::get()->lang;
		}
		else
		{
			$this->language	= DEFAULT_LANG;
		}
    }

    public function addData($data) {
		$this->container = array_replace_recursive($this->container, $data);
    }

	public function getLanguage()
	{
		return $this->language;
	}

	public function getTemplate($templateName)
	{
		if(file_exists('language/'.$this->getLanguage().'/templates/'.$templateName.'.txt'))
		{
			return file_get_contents('language/'.$this->getLanguage().'/templates/'.$templateName.'.txt');
		}
		else
		{
			return '### Template "'.$templateName.'" on language "'.$this->getLanguage().'" not found! ###';
		}
	}


	public function includeData($files)
	{
		// Fixed BOM problems.
		ob_start();
		$LNG	= array();

		//FALLBACK
		$path	= 'language/en/';
        foreach($files as $file) {
			$filePath	= $path.$file.'.php';
			if(file_exists($filePath))
			{
				require $filePath;
			}
		}

		$DEFAULT = $LNG;

		// Get current client language
		$path	= 'language/'.$this->getLanguage().'/';
		foreach ($files as $file) {
			$filePath	= $path . $file . '.php';
			if (file_exists($filePath)) {
				require $filePath;
			}
		}

		// Build missing language data from English to client language
		foreach ($DEFAULT as $TextKey => $TextData) {
			if (is_array($TextData)) {
				foreach ($TextData as $Element => $ElementText) {
					if (array_key_exists($Element, $LNG[$TextKey])) continue;
					$LNG[$TextKey][$Element] = $ElementText;
				}
			}
		}

		ob_end_clean();

		$this->addData($LNG);
	}

	/** ArrayAccess Functions **/

    public function offsetSet(mixed $offset,mixed $value) : void {
        if (is_null($offset)) {
            $this->container[] = $value;
        } else {
            $this->container[$offset] = $value;
        }
    }

    public function offsetExists(mixed $offset) : bool {
        return isset($this->container[$offset]);
    }

    public function offsetUnset(mixed $offset) : void {
        unset($this->container[$offset]);
    }

    public function offsetGet(mixed $offset) : mixed {
        return isset($this->container[$offset]) ? $this->container[$offset] : $offset;
    }
}
