{block name="title" prepend}{$LNG.lm_empire}{/block}
{block name="content"}
<div class="fe-build fe-empire is-compact" id="fe-empire">
	<header class="fe-toolbar">
		<div class="fe-toolbar-title">
			<h2><i class="bi bi-grid-3x3-gap"></i> {$LNG.lv_imperium_title}</h2>
		</div>
		<label class="fe-squeue-all"><input type="checkbox" id="fe-emp-zero" checked> {$LNG.fe_hide_empty}</label>
	</header>

	<div class="fe-emp-scroll" tabindex="0">
	<table class="fe-emp">
		<thead>
			<tr>
				<th scope="col" class="fe-emp-corner">{$LNG.lv_planet}</th>
				<th scope="col" class="fe-emp-total">{$LNG.lv_total}</th>
				{foreach $planetList.image as $planetID => $image}
				<th scope="col">
					<a href="game.php?page=overview&amp;cp={$planetID}"><img width="56" height="56" src="{$dpath}planeten/{$image}.jpg" alt=""><span>{$planetList.name[$planetID]}</span></a>
					<a class="fe-emp-coords" href="game.php?page=galaxy&amp;galaxy={$planetList.coords[$planetID].galaxy}&amp;system={$planetList.coords[$planetID].system}">[{$planetList.coords[$planetID].galaxy}:{$planetList.coords[$planetID].system}:{$planetList.coords[$planetID].planet}]</a>
					<small>{$LNG.lv_fields} {$planetList.field[$planetID].current}/{$planetList.field[$planetID].max}</small>
				</th>
				{/foreach}
			</tr>
		</thead>
		<tbody>
			<tr class="fe-emp-section"><th colspan="{$colspan}">{$LNG.lv_resources}</th></tr>
			{foreach $planetList.resource as $elementID => $resourceArray}
			{$hasRate = isset($planetList.resourcePerHour[$elementID])}
			<tr>
				<th scope="row"><button type="button" onclick="return Dialog.info({$elementID})"><img src="{$dpath}gebaeude/{$elementID}.gif" alt="" width="22" height="22" loading="lazy"><span>{$LNG.tech.$elementID}</span></button></th>
				<td class="fe-emp-total">{array_sum($resourceArray)|number}{if $hasRate}<small class="is-ok">+{array_sum($planetList.resourcePerHour[$elementID])|number}/h</small>{/if}</td>
				{foreach $resourceArray as $planetID => $resource}
				<td>{$resource|number}{if $hasRate && $planetList.planet_type[$planetID] == 1}<small class="is-ok">+{$planetList.resourcePerHour[$elementID][$planetID]|number}/h</small>{/if}</td>
				{/foreach}
			</tr>
			{/foreach}

			{include file="fe.empire.rows.tpl" title=$LNG.lv_buildings rows=$planetList.build colspan=$colspan}

			<tr class="fe-emp-section"><th colspan="{$colspan}">{$LNG.lv_technology}</th></tr>
			{foreach $planetList.tech as $elementID => $tech}
			<tr class="{if $tech == 0}is-zero{/if}">
				<th scope="row"><button type="button" onclick="return Dialog.info({$elementID})"><img src="{$dpath}gebaeude/{$elementID}.gif" alt="" width="22" height="22" loading="lazy"><span>{$LNG.tech.$elementID}</span></button></th>
				<td class="fe-emp-total">{$tech|number}</td>
				<td colspan="{$colspan - 2}" class="is-none">{$LNG.fe_emp_all_planets}</td>
			</tr>
			{/foreach}

			{include file="fe.empire.rows.tpl" title=$LNG.lv_ships rows=$planetList.fleet colspan=$colspan}
			{include file="fe.empire.rows.tpl" title=$LNG.lv_defenses rows=$planetList.defense colspan=$colspan}
			{include file="fe.empire.rows.tpl" title=$LNG.tech.500 rows=$planetList.missiles colspan=$colspan}
		</tbody>
	</table>
	</div>
</div>
<script>
(function () {
	var root = document.getElementById('fe-empire');
	var box = document.getElementById('fe-emp-zero');
	var params = new URLSearchParams(location.search);
	box.checked = params.get('empty') !== '1';
	function apply() { root.classList.toggle('is-compact', box.checked); }
	box.addEventListener('change', function () {
		var url = new URL(location.href);
		if (box.checked) url.searchParams.delete('empty'); else url.searchParams.set('empty', '1');
		history.replaceState(null, '', url);
		apply();
	});
	apply();
})();
</script>
{/block}
