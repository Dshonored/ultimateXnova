{block name="title" prepend}{$LNG.lm_buildings}{/block}
{block name="content"}
<div class="fe-build" data-fe-items>

	<header class="fe-toolbar">
		<div class="fe-toolbar-title">
			<h2><i class="bi bi-building"></i> {$LNG.lm_buildings}</h2>
			<span class="fe-pill"><i class="bi bi-grid-3x3"></i> {$LNG.fe_fields} {$usedField}/{$maxField}</span>
			<span class="fe-pill"><i class="bi bi-trophy"></i> {$LNG.st_points} {$userBuildPoints}</span>
		</div>
		<div class="fe-filter" role="group">
			<button type="button" data-filter="all">{$LNG.fe_show_all} <b data-count="all"></b></button>
			<button type="button" data-filter="ready">{$LNG.fe_show_ready} <b data-count="ready"></b></button>
			<button type="button" data-filter="locked">{$LNG.fe_show_locked} <b data-count="locked"></b></button>
		</div>
	</header>

	{if !empty($Queue)}
		{include file="fe.queue.tpl" queue=$Queue action="game.php?page=buildings"}
	{/if}

	<div class="fe-grid">
	{foreach $BuildInfoList as $ID => $Element}
		{$busy = ($isBusy.research && ($ID == 6 || $ID == 31)) || ($isBusy.shipyard && ($ID == 15 || $ID == 21))}
		{$maxed = $Element.maxLevel == $Element.levelToBuild}
		{$canBuild = $CanBuildElement && $RoomIsOk && $Element.buyable && $Element.technologySatisfied && !$busy && !$maxed}
		<article class="fe-item {if $canBuild}is-ready{elseif !$Element.technologySatisfied}is-locked{else}is-blocked{/if}"
			data-state="{if $canBuild}ready{elseif !$Element.technologySatisfied}locked{else}blocked{/if}">
			<button type="button" class="fe-item-img" onclick="return Dialog.info({$ID})" title="{$LNG.fe_info}">
				<img src="{$dpath}gebaeude/{$ID}.gif" alt="" width="88" height="88" loading="lazy">
				<span class="fe-item-level">{$Element.level}</span>
			</button>
			<div class="fe-item-body">
				<div class="fe-item-head">
					<h3>{$LNG.tech.{$ID}}</h3>
					<span class="fe-item-sub">{$LNG.bd_lvl} {$Element.level}{if $Element.maxLevel != 255}/{$Element.maxLevel}{/if}</span>
				</div>

				{if !$Element.technologySatisfied && !empty($Element.requeriments)}
					{include file="fe.reqs.tpl" reqs=$Element.requeriments}
				{elseif !$maxed}
					{include file="fe.cost.tpl" cost=$Element.costResources overflow=$Element.costOverflow}
					<div class="fe-item-facts">
						<span title="{$LNG.fgf_time}"><i class="bi bi-clock"></i> {pretty_time($Element.elementTime)}</span>
						{if !empty($Element.infoEnergyLong)}
						<span class="{if $Element.infoEnergyShort > 0}is-ok{else}is-short{/if}" title="{$LNG.bd_next_level} {$Element.infoEnergyLong|strip_tags}"><i class="bi bi-lightning-charge"></i> {$Element.infoEnergyShort}</span>
						{/if}
					</div>
				{/if}

				<div class="fe-item-actions">
				{if $canBuild}
					<form action="game.php?page=buildings" method="post">
						<input type="hidden" name="cmd" value="insert">
						<input type="hidden" name="building" value="{$ID}">
						<button type="submit" class="fe-btn fe-btn-primary"><i class="bi bi-arrow-up-circle"></i> {if $Element.levelToBuild == 0}{$LNG.bd_build}{else}{sprintf($LNG.fe_upgrade_to, $Element.levelToBuild + 1)}{/if}</button>
					</form>
				{else}
					<span class="fe-reason">
					{if $maxed}{$LNG.bd_maxlevel}
					{elseif $busy}{$LNG.bd_working}
					{elseif !$Element.technologySatisfied}{$LNG.fe_show_locked}
					{elseif !$RoomIsOk}{$LNG.bd_no_more_fields}
					{elseif !$CanBuildElement}{$LNG.fe_queue_full}
					{else}{$LNG.fe_missing_res}{/if}
					</span>
				{/if}

				{if $Element.level > 0}
					{if $ID == 43}<button type="button" class="fe-btn fe-btn-ghost" onclick="return Dialog.info({$ID})">{$LNG.bd_jump_gate_action}</button>{/if}
					{if ($ID == 44 && !$HaveMissiles) || $ID != 44}
					<form action="game.php?page=buildings" method="post">
						<input type="hidden" name="cmd" value="destroy">
						<input type="hidden" name="building" value="{$ID}">
						<button type="submit" class="fe-btn fe-btn-icon" data-bs-toggle="tooltip" data-bs-html="true"
							aria-label="{$LNG.bd_dismantle}"
							title="<b>{$LNG.bd_dismantle} · {$LNG.bd_lvl} {$Element.level}</b><br>{foreach $Element.destroyResources as $ResType => $ResCount}{$LNG.tech.{$ResType}}: {$ResCount|number}<br>{/foreach}{$LNG.bd_destroy_time} {$Element.destroyTime|time}"
							onclick="return confirm('{$LNG.bd_dismantle|escape:'javascript'} {$LNG.tech.{$ID}|escape:'javascript'}?')"><i class="bi bi-arrow-down-circle"></i></button>
					</form>
					{/if}
				{/if}
				</div>
			</div>
		</article>
	{/foreach}
	</div>
	<p class="fe-empty" hidden>{$LNG.fe_none_match}</p>
</div>
<script src="scripts/game/fe-items.js?v={$smarty.const.ASSET_VERSION}"></script>
{/block}
