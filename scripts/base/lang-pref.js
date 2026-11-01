/*
 * Language preference (friends-edition, AGPL-3.0).
 *
 * The player's choice lives in localStorage ("lang"). The server renders pages in PHP and
 * cannot read localStorage, so the choice is mirrored into a "lang" cookie that PHP reads.
 * If the cookie gets lost (cleared, expired, new subdomain) but localStorage still has a
 * choice, the cookie is restored and the page reloads once in the right language.
 */
(function () {
	var KEY = 'lang';
	var ONE_YEAR = 60 * 60 * 24 * 365;

	function readStore() {
		try { return localStorage.getItem(KEY); } catch (e) { return null; }
	}
	function writeStore(value) {
		try { localStorage.setItem(KEY, value); } catch (e) {}
	}
	function readCookie() {
		var m = document.cookie.match(/(?:^|;\s*)lang=([a-z]{2})(?:;|$)/);
		return m ? m[1] : null;
	}
	function writeCookie(value) {
		document.cookie = KEY + '=' + value + '; path=/; max-age=' + ONE_YEAR + '; SameSite=Lax' +
			(location.protocol === 'https:' ? '; Secure' : '');
	}
	function isValid(value) {
		return typeof value === 'string' && /^[a-z]{2}$/.test(value);
	}

	window.setGameLanguage = function (value) {
		if (!isValid(value)) return;
		writeStore(value);
		writeCookie(value);
		location.reload();
	};

	var stored = readStore();
	var cookie = readCookie();

	if (isValid(stored) && stored !== cookie) {
		writeCookie(stored);
		// Reload once so PHP renders in the stored language; guard against loops.
		var guard = 'langSynced:' + stored;
		var alreadyTried = false;
		try { alreadyTried = sessionStorage.getItem(guard) === '1'; sessionStorage.setItem(guard, '1'); } catch (e) { alreadyTried = true; }
		if (!alreadyTried) location.reload();
	} else if (!isValid(stored) && isValid(cookie)) {
		writeStore(cookie);
	}

	document.addEventListener('click', function (event) {
		var link = event.target.closest ? event.target.closest('[data-set-lang]') : null;
		if (!link) return;
		event.preventDefault();
		window.setGameLanguage(link.getAttribute('data-set-lang'));
	});
})();
