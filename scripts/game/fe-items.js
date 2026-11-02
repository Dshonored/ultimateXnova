/*
 * Build / research / shipyard cards (friends-edition, AGPL-3.0).
 * - Filter chips (all / available / locked). The URL (?show=) is the single source of truth,
 *   so a refresh or a shared link keeps the same view.
 * - Shipyard: quantity steppers + one "build selected" bar that submits every chosen ship at once.
 */
(function () {
	var root = document.querySelector('[data-fe-items]');
	if (!root) return;

	var items = Array.prototype.slice.call(root.querySelectorAll('.fe-item'));
	var chips = Array.prototype.slice.call(root.querySelectorAll('[data-filter]'));
	var empty = root.querySelector('.fe-empty');
	var FILTERS = ['all', 'ready', 'locked'];

	function currentFilter() {
		var value = new URLSearchParams(location.search).get('show');
		return FILTERS.indexOf(value) === -1 ? 'all' : value;
	}

	function matches(item, filter) {
		var state = item.getAttribute('data-state');
		if (filter === 'ready') return state === 'ready';
		if (filter === 'locked') return state === 'locked';
		return true;
	}

	function render() {
		var filter = currentFilter();
		var shown = 0;
		items.forEach(function (item) {
			var visible = matches(item, filter);
			item.hidden = !visible;
			if (visible) shown++;
		});
		chips.forEach(function (chip) {
			chip.setAttribute('aria-pressed', chip.getAttribute('data-filter') === filter ? 'true' : 'false');
		});
		if (empty) empty.hidden = shown !== 0;
	}

	FILTERS.forEach(function (filter) {
		var badge = root.querySelector('[data-count="' + filter + '"]');
		if (badge) badge.textContent = items.filter(function (i) { return matches(i, filter); }).length;
	});

	chips.forEach(function (chip) {
		chip.addEventListener('click', function () {
			var url = new URL(location.href);
			var filter = chip.getAttribute('data-filter');
			if (filter === 'all') url.searchParams.delete('show'); else url.searchParams.set('show', filter);
			history.replaceState(null, '', url);
			render();
		});
	});

	render();

	// ---- shipyard quantities ----
	var form = document.getElementById('fe-shipyard-form');
	if (!form) return;
	var bar = form.querySelector('.fe-submitbar');
	var counter = form.querySelector('[data-selected-count]');
	var inputs = Array.prototype.slice.call(form.querySelectorAll('.fe-stepper input'));

	function clamp(input, value) {
		var max = parseFloat(input.max);
		value = Math.floor(Number(value) || 0);
		if (value < 0) value = 0;
		if (!isNaN(max) && value > max) value = max;
		return value;
	}

	function update() {
		var total = 0;
		inputs.forEach(function (input) {
			var value = clamp(input, input.value);
			total += value;
			input.closest('.fe-item').classList.toggle('is-selected', value > 0);
		});
		counter.textContent = total.toLocaleString();
		bar.hidden = total === 0;
	}

	form.addEventListener('click', function (event) {
		var step = event.target.closest('[data-step]');
		if (step) {
			var input = step.closest('.fe-stepper').querySelector('input');
			var how = step.getAttribute('data-step');
			input.value = how === 'max' ? clamp(input, input.max) : clamp(input, Number(input.value) + Number(how));
			update();
			return;
		}
		if (event.target.closest('[data-clear]')) {
			inputs.forEach(function (input) { input.value = 0; });
			update();
		}
	});

	inputs.forEach(function (input) {
		input.addEventListener('input', update);
		input.addEventListener('blur', function () { input.value = clamp(input, input.value); update(); });
		input.addEventListener('focus', function () { if (input.value === '0') input.select(); });
	});

	update();
})();
