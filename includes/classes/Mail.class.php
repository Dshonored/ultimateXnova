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

/**
 * Outgoing mail via the Resend HTTP API (https://resend.com/docs/api-reference/emails/send-email).
 *
 * Replaces the bundled PHPMailer 5.x. Configuration comes from the environment only,
 * so the API key never lives in the database or the admin panel:
 *   RESEND_API_KEY  re_...                     (required)
 *   MAIL_FROM       noreply@your-domain.com    (required, must be on a domain verified in Resend)
 *   MAIL_FROM_NAME  display name               (optional, defaults to the game name)
 */
class Mail
{
	const API_URL = 'https://api.resend.com/emails';

	static public function isConfigured()
	{
		return self::env('RESEND_API_KEY') !== '' && filter_var(self::env('MAIL_FROM'), FILTER_VALIDATE_EMAIL) !== false;
	}

	/**
	 * @param string $mailTarget      recipient address
	 * @param string $mailTargetName  recipient display name
	 * @param string $mailSubject
	 * @param string $mailContent     plain text body (legacy templates are plain text)
	 * @return bool true when Resend accepted the message
	 */
	static public function send($mailTarget, $mailTargetName, $mailSubject, $mailContent)
	{
		return self::deliver($mailTarget, $mailTargetName, $mailSubject, $mailContent, false);
	}

	/**
	 * @param array  $mailTargets  [address => ['username' => ..., 'body' => optional html]]
	 */
	static public function multiSend($mailTargets, $mailSubject, $mailContent = NULL)
	{
		$sent = 0;
		foreach ($mailTargets as $address => $data)
		{
			$content = isset($data['body']) ? $data['body'] : $mailContent;
			if (self::deliver($address, $data['username'], $mailSubject, $content, true)) {
				$sent++;
			}
		}
		return $sent;
	}

	static private function deliver($to, $toName, $subject, $content, $isHtml)
	{
		if (!self::isConfigured()) {
			error_log('[Mail] RESEND_API_KEY / MAIL_FROM not configured, mail to '.$to.' dropped');
			return false;
		}
		if (filter_var($to, FILTER_VALIDATE_EMAIL) === false) {
			return false;
		}

		$fromName = self::env('MAIL_FROM_NAME');
		if ($fromName === '') {
			$fromName = Config::get()->game_name;
		}

		$payload = array(
			'from'    => self::formatAddress(self::env('MAIL_FROM'), $fromName),
			'to'      => array(self::formatAddress($to, $toName)),
			'subject' => self::stripHeaderChars($subject),
		);
		if ($isHtml) {
			$payload['html'] = $content;
			$payload['text'] = trim(html_entity_decode(strip_tags($content), ENT_QUOTES, 'UTF-8'));
		} else {
			$payload['text'] = $content;
		}

		$ch = curl_init(self::API_URL);
		curl_setopt_array($ch, array(
			CURLOPT_POST           => true,
			CURLOPT_RETURNTRANSFER => true,
			CURLOPT_TIMEOUT        => 10,
			CURLOPT_HTTPHEADER     => array(
				'Authorization: Bearer '.self::env('RESEND_API_KEY'),
				'Content-Type: application/json',
			),
			CURLOPT_POSTFIELDS     => json_encode($payload, JSON_UNESCAPED_UNICODE),
		));
		$response = curl_exec($ch);
		$status   = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
		$error    = curl_error($ch);

		if ($status < 200 || $status >= 300) {
			error_log('[Mail] Resend rejected mail to '.$to.': HTTP '.$status.' '.($error !== '' ? $error : substr((string) $response, 0, 300)));
			return false;
		}
		return true;
	}

	/** Public base URL for links in e-mails (APP_URL). Never trust the Host header for these. */
	static public function appUrl()
	{
		$url = self::env('APP_URL');
		if ($url === '') {
			error_log('[Mail] APP_URL is not set, falling back to HTTP_PATH');
			return HTTP_PATH;
		}
		return rtrim($url, '/').'/';
	}

	static private function formatAddress($address, $name)
	{
		$name = trim(str_replace(array('"', '<', '>'), '', self::stripHeaderChars((string) $name)));
		return $name === '' ? $address : '"'.$name.'" <'.$address.'>';
	}

	static private function stripHeaderChars($value)
	{
		return str_replace(array("\r", "\n"), ' ', $value);
	}

	static private function env($key)
	{
		$value = getenv($key);
		return $value === false ? '' : trim($value);
	}
}
