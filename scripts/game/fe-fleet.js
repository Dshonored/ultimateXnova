/* Fleet ship picker (friends-edition, AGPL-3.0): live total, clamps, continue only with ships selected. */
(function () {
	var form = document.getElementById('fe-fleet-form');
	if (!form) return;
	var total = form.querySelector('[data-fleet-total]');
	var next = form.querySelector('[data-fleet-continue]');
	var inputs = Array.prototype.slice.call(form.querySelectorAll('input[name^="ship"]'));

	function update() {
		var sum = 0;
		inputs.forEach(function (input) {
			var value = Math.max(0, Math.floor(Number(input.value) || 0));
			sum += value;
			input.closest('.fe-item').classList.toggle('is-selected', value > 0);
		});
		if (total) total.textContent = sum.toLocaleString();
		if (next) next.disabled = sum === 0;
	}
	form.addEventListener('input', update);
	// maxShip()/maxShips()/noShips() set the values from their inline onclick, which runs first
	form.addEventListener('click', function () { window.setTimeout(update, 0); });
	update();
})();
