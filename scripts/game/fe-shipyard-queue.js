/*
 * Shipyard queue (friends-edition, AGPL-3.0).
 * One row per queued order with a checkbox: pick the orders to cancel, the button says how many.
 * The first row counts down to the next finished unit. When an order is completed the page reloads,
 * so the row indexes (sent as auftr[]) always match the server queue.
 */
(function () {
	var root = document.querySelector('[data-fe-squeue]');
	if (!root) return;

	var cfg = window.feShipyardQueue || {};
	var form = root.querySelector('[data-fe-squeue-form]');
	var rows = Array.prototype.slice.call(root.querySelectorAll('.fe-squeue-row'));
	var boxes = Array.prototype.slice.call(root.querySelectorAll('input[name="auftr[]"]'));
	var all = root.querySelector('[data-select-all]');
	var button = root.querySelector('[data-cancel-selected]');
	var picked = root.querySelector('[data-picked]');
	var totalEl = root.querySelector('[data-total-left]');

	function fmt(seconds) {
		seconds = Math.max(0, Math.round(seconds));
		if (typeof window.GetRestTimeFormat === 'function') return window.GetRestTimeFormat(seconds);
		var h = Math.floor(seconds / 3600), m = Math.floor(seconds % 3600 / 60), s = seconds % 60;
		return (h ? h + 'h ' : '') + (h || m ? m + 'm ' : '') + s + 's';
	}

	// ---- selection ----
	function syncSelection() {
		var n = 0;
		boxes.forEach(function (box) {
			box.closest('.fe-squeue-row').classList.toggle('is-picked', box.checked);
			if (box.checked) n++;
		});
		picked.textContent = n;
		button.disabled = n === 0;
		if (all) {
			all.checked = n === boxes.length;
			all.indeterminate = n > 0 && n < boxes.length;
		}
	}
	boxes.forEach(function (box) { box.addEventListener('change', syncSelection); });
	if (all) all.addEventListener('change', function () {
		boxes.forEach(function (box) { box.checked = all.checked; });
		syncSelection();
	});
	form.addEventListener('submit', function (event) {
		var n = boxes.filter(function (b) { return b.checked; }).length;
		if (n === 0 || (cfg.confirmText && !window.confirm(cfg.confirmText.replace('%s', n)))) {
			event.preventDefault();
		}
	});
	syncSelection();

	// ---- live countdown for the order in progress ----
	var current = rows[0];
	if (!current) return;
	var unit = Number(current.getAttribute('data-unit')) || 0;
	var left = Number(current.getAttribute('data-count')) || 0;
	var leftEl = current.querySelector('[data-left]');
	var nextEl = current.querySelector('[data-next-unit]');
	var barEl = current.querySelector('[data-unit-bar]');
	var waiting = rows.slice(1).reduce(function (sum, row) {
		return sum + Number(row.getAttribute('data-unit')) * Number(row.getAttribute('data-count'));
	}, 0);
	var start = Date.now();
	var elapsed0 = Number(cfg.elapsed) || 0; // seconds already spent on the current unit

	function tick() {
		var spent = elapsed0 + (Date.now() - start) / 1000;
		var done = unit > 0 ? Math.floor(spent / unit) : left;
		var remainingUnits = left - done;
		if (remainingUnits <= 0) {
			window.clearInterval(timer);
			window.setTimeout(function () { location.href = location.href; }, 800);
			remainingUnits = 0;
		}
		var inUnit = unit > 0 ? spent - done * unit : 0;
		leftEl.textContent = remainingUnits.toLocaleString();
		nextEl.textContent = fmt(unit - inUnit);
		barEl.style.width = (unit > 0 ? Math.min(100, inUnit / unit * 100) : 100) + '%';
		if (totalEl) totalEl.textContent = fmt(Math.max(0, remainingUnits * unit - inUnit) + waiting);
	}
	var timer = window.setInterval(tick, 1000);
	tick();
})();
