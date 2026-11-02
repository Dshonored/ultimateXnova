{block name="title" prepend}{if $mode == "defense"}{$LNG.lm_defenses}{else}{$LNG.lm_shipshard}{/if}{/block}
{block name="content"}
<script src="./scripts/base/avoid_submit_on_refresh.js" type="text/javascript"></script>
<div class="fe-build" data-fe-items>

	<header class="fe-toolbar">
		<div class="fe-toolbar-title">
			<h2>{if $mode == "defense"}<i class="bi bi-shield"></i> {$LNG.lm_defenses}{else}<i class="bi bi-rocket-takeoff"></i> {$LNG.lm_shipshard}{/if}</h2>
			<span class="fe-pill"><i class="bi bi-trophy"></i> {$LNG.st_points} {if $mode == "fleet"}{$userFleetPoints}{else}{$userDefensePoints}{/if}</span>
		</div>
		<div class="fe-filter" role="group">
			<button type="button" data-filter="all">{$LNG.fe_show_all} <b data-count="all"></b></button>
			<button type="button" data-filter="ready">{$LNG.fe_show_ready} <b data-count="ready"></b></button>
			<button type="button" data-filter="locked">{$LNG.fe_show_locked} <b data-count="locked"></b></button>
		</div>
	</header>

	{if !$NotBuilding}
		<div class="fe-notice" id="infobox"><i class="bi bi-cone-striped"></i> {$LNG.bd_building_shipyard}</div>
	{/if}

	{if !empty($BuildList)}
	<section class="fe-queue fe-queue-shipyard" data-fe-squeue>
		<form action="game.php?page=shipyard&amp;mode={$mode}" method="post" data-fe-squeue-form>
			<input type="hidden" name="action" value="delete">
			<div class="fe-squeue-top">
				<span class="fe-queue-label">{$LNG.fe_queue_now}</span>
				<span class="fe-queue-times"><i class="bi bi-hourglass-split"></i> {$LNG.fe_queue_total} <b data-total-left>{$BuildList.pretty_time_b_hangar}</b></span>
			</div>
			<ul class="fe-squeue">
			{foreach $BuildList.Queue as $qIndex => $q}
				<li class="fe-squeue-row{if $q@first} is-current{/if}" data-index="{$qIndex}" data-unit="{$q[2]}" data-count="{$q[1]}">
					<label class="fe-squeue-pick">
						<input type="checkbox" name="auftr[]" value="{$qIndex}" aria-label="{$LNG.bd_cancel} {$q[0]}">
						<img src="{$dpath}gebaeude/{$q[3]}.gif" alt="" width="40" height="40">
						<span class="fe-squeue-name">
							<strong>{$q[0]}</strong>
							<small>{if $q@first}{$LNG.fe_queue_building}{else}{$LNG.fe_queue_waiting} · #{$q@iteration}{/if}</small>
						</span>
					</label>
					<span class="fe-squeue-count">× <b data-left>{$q[1]|number}</b></span>
					<span class="fe-squeue-time">
						{if $q@first}
							<span class="fe-squeue-next"><i class="bi bi-stopwatch"></i> <span data-next-unit></span></span>
							<span class="fe-squeue-bar"><span data-unit-bar></span></span>
						{else}
							<i class="bi bi-clock"></i> {pretty_time($q[2] * $q[1])}
						{/if}
					</span>
				</li>
			{/foreach}
			</ul>
			<div class="fe-squeue-actions">
				<label class="fe-squeue-all"><input type="checkbox" data-select-all> {$LNG.fe_select_all}</label>
				<p class="fe-hint">{$LNG.bd_cancel_warning}</p>
				<button type="submit" class="fe-btn fe-btn-ghost fe-btn-danger" data-cancel-selected disabled>
					<i class="bi bi-x-lg"></i> {$LNG.fe_cancel_selected} (<span data-picked>0</span>)
				</button>
			</div>
		</form>
	</section>
	{/if}

	<form action="game.php?page=shipyard&amp;mode={$mode}" method="post" id="fe-shipyard-form">
	<div class="fe-grid">
	{foreach $elementList as $ID => $Element}
		{$canBuild = $NotBuilding && $Element.buyable && !$Element.AlreadyBuild && $Element.technologySatisfied}
		<article class="fe-item {if $canBuild}is-ready{elseif !$Element.technologySatisfied}is-locked{else}is-blocked{/if}"
			data-state="{if $canBuild}ready{elseif !$Element.technologySatisfied}locked{else}blocked{/if}">
			<button type="button" class="fe-item-img" onclick="return Dialog.info({$ID})" title="{$LNG.fe_info}">
				<img src="{$dpath}gebaeude/{$ID}.gif" alt="" width="88" height="88" loading="lazy">
				<span class="fe-item-level">{shortly_number($Element.available)}</span>
			</button>
			<div class="fe-item-body">
				<button type="button" class="fe-info" onclick="return Dialog.info({$ID})" title="{$LNG.fe_info_button}" aria-label="{$LNG.fe_info_button}: {$LNG.tech.{$ID}}"><i class="bi bi-info-lg"></i></button>
				<div class="fe-item-head">
					<h3>{$LNG.tech.{$ID}}</h3>
					<span class="fe-item-sub">{$LNG.fe_have} {$Element.available|number}</span>
				</div>

				{if !$Element.technologySatisfied && !empty($Element.requeriments)}
					{include file="fe.reqs.tpl" reqs=$Element.requeriments}
				{else}
					{include file="fe.cost.tpl" cost=$Element.costResources overflow=$Element.costOverflow}
					<div class="fe-item-facts">
						<span title="{$LNG.fgf_time}"><i class="bi bi-clock"></i> {pretty_time($Element.elementTime)}</span>
						{if $ID == 212}<span class="is-ok"><i class="bi bi-lightning-charge"></i> +{$SolarEnergy}</span>{/if}
						{if $canBuild}<span><i class="bi bi-check2-circle"></i> {$LNG.fe_can_build} {$Element.maxBuildable|number}</span>{/if}
					</div>
				{/if}

				<div class="fe-item-actions">
				{if $Element.AlreadyBuild}
					<span class="fe-reason">{$LNG.bd_protection_shield_only_one}</span>
				{elseif $canBuild}
					<div class="fe-stepper" data-max="{$Element.maxBuildable}">
						<button type="button" class="fe-btn fe-btn-icon" data-step="-1" aria-label="−1"><i class="bi bi-dash"></i></button>
						<input type="number" inputmode="numeric" min="0" max="{$Element.maxBuildable}" name="fmenge[{$ID}]" value="0" aria-label="{$LNG.tech.{$ID}}">
						<button type="button" class="fe-btn fe-btn-icon" data-step="1" aria-label="+1"><i class="bi bi-plus"></i></button>
						<button type="button" class="fe-btn fe-btn-ghost" data-step="max">{$LNG.bd_max_ships}</button>
					</div>
				{else}
					<span class="fe-reason">{if !$Element.technologySatisfied}{$LNG.fe_show_locked}{elseif !$NotBuilding}{$LNG.fe_busy}{else}{$LNG.fe_missing_res}{/if}</span>
				{/if}
				</div>
			</div>
		</article>
	{/foreach}
	</div>
	<p class="fe-empty" hidden>{$LNG.fe_none_match}</p>

	<div class="fe-submitbar" hidden>
		<span><b data-selected-count>0</b> × <i class="bi bi-box-seam"></i></span>
		<button type="button" class="fe-btn fe-btn-ghost" data-clear>{$LNG.fe_clear}</button>
		<button type="submit" class="fe-btn fe-btn-primary"><i class="bi bi-hammer"></i> {$LNG.fe_build_selected}</button>
	</div>
	</form>
</div>

{if !empty($BuildList)}
<script>
window.feShipyardQueue = {
	elapsed: {$BuildList.b_hangar_id_plus|json},
	confirmText: {$LNG.fe_cancel_confirm|json}
};
</script>
<script src="scripts/game/fe-shipyard-queue.js?v={$smarty.const.ASSET_VERSION}"></script>
{/if}
<script src="scripts/game/fe-items.js?v={$smarty.const.ASSET_VERSION}"></script>
{/block}
