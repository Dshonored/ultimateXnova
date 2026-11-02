{block name="title" prepend}{$LNG.lm_research}{/block}
{block name="content"}
<div class="fe-build" data-fe-items>

	<header class="fe-toolbar">
		<div class="fe-toolbar-title">
			<h2><i class="bi bi-lightbulb"></i> {$LNG.lm_research}</h2>
			<span class="fe-pill"><i class="bi bi-trophy"></i> {$LNG.st_points} {$userTechPoints}</span>
		</div>
		<div class="fe-filter" role="group">
			<button type="button" data-filter="all">{$LNG.fe_show_all} <b data-count="all"></b></button>
			<button type="button" data-filter="ready">{$LNG.fe_show_ready} <b data-count="ready"></b></button>
			<button type="button" data-filter="locked">{$LNG.fe_show_locked} <b data-count="locked"></b></button>
		</div>
	</header>

	{if $IsLabinBuild}
		<div class="fe-notice"><i class="bi bi-cone-striped"></i> {$LNG.fe_lab_busy}</div>
	{/if}

	{if !empty($Queue)}
		{include file="fe.queue.tpl" queue=$Queue action="game.php?page=research"}
	{/if}

	<div class="fe-grid">
	{foreach $ResearchList as $ID => $Element}
		{$maxed = $Element.maxLevel == $Element.levelToBuild}
		{$canBuild = !$IsLabinBuild && !$IsFullQueue && $Element.buyable && $Element.technologySatisfied && !$maxed}
		<article class="fe-item {if $canBuild}is-ready{elseif !$Element.technologySatisfied}is-locked{else}is-blocked{/if}"
			data-state="{if $canBuild}ready{elseif !$Element.technologySatisfied}locked{else}blocked{/if}">
			<button type="button" class="fe-item-img" onclick="return Dialog.info({$ID})" title="{$LNG.fe_info}">
				<img src="{$dpath}gebaeude/{$ID}.gif" alt="" width="88" height="88" loading="lazy">
				<span class="fe-item-level">{$Element.level}</span>
			</button>
			<div class="fe-item-body">
				<button type="button" class="fe-info" onclick="return Dialog.info({$ID})" title="{$LNG.fe_info_button}" aria-label="{$LNG.fe_info_button}: {$LNG.tech.{$ID}}"><i class="bi bi-info-lg"></i></button>
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
					<form action="game.php?page=research" method="post">
						<input type="hidden" name="cmd" value="insert">
						<input type="hidden" name="tech" value="{$ID}">
						<button type="submit" class="fe-btn fe-btn-primary"><i class="bi bi-arrow-up-circle"></i> {sprintf($LNG.fe_research_to, $Element.levelToBuild + 1)}</button>
					</form>
				{else}
					<span class="fe-reason">
					{if $maxed}{$LNG.bd_maxlevel}
					{elseif !$Element.technologySatisfied}{$LNG.fe_show_locked}
					{elseif $IsLabinBuild}{$LNG.fe_busy}
					{elseif $IsFullQueue}{$LNG.fe_queue_full}
					{else}{$LNG.fe_missing_res}{/if}
					</span>
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
