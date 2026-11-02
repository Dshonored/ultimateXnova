/* Sticky header (friends-edition, AGPL-3.0): shrink after scrolling and publish the
   header height as --fe-header-h so the sticky sidebar sits right below it. */
(function () {
	var root = document.documentElement;
	var header = document.querySelector('.fe-header');
	if (!header) return;

	function measure() {
		var sticky = getComputedStyle(header).position === 'sticky';
		root.style.setProperty('--fe-header-h', (sticky ? header.offsetHeight : 0) + 'px');
	}
	var ticking = false;
	function onScroll() {
		if (ticking) return;
		ticking = true;
		requestAnimationFrame(function () {
			// hysteresis so the bar does not flicker around the threshold
			var y = window.scrollY;
			if (y > 60) root.classList.add('fe-compact');
			else if (y < 20) root.classList.remove('fe-compact');
			ticking = false;
		});
	}
	window.addEventListener('scroll', onScroll, { passive: true });
	window.addEventListener('resize', measure);
	if (window.ResizeObserver) new ResizeObserver(measure).observe(header);
	onScroll();
	measure();
})();
