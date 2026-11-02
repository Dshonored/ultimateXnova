{block name="title" prepend}{$LNG.lm_officiers}{/block}
{block name="content"}
<div class="fe-build">

	<header class="fe-toolbar">
		<div class="fe-toolbar-title">
			<h2><i class="bi bi-person-badge"></i> {$LNG.lm_officiers}</h2>
		</div>
	</header>

	{if $officierList}
	<h3 class="fe-section-title">{$LNG.of_offi}</h3>
	<div class="fe-grid">
	{foreach $officierList as $ID => $Element}
		{$maxed = $Element.maxLevel <= $Element.level}
		<article class="fe-item {if !$maxed && $Element.buyable}is-ready{else}is-blocked{/if}">
			<button type="button" class="fe-item-img" onclick="return Dialog.info({$ID})" title="{$LNG.fe_info}">
				<img src="{$dpath}gebaeude/{$ID}.jpg" alt="" width="88" height="88" loading="lazy">
				<span class="fe-item-level">{$Element.level}</span>
			</button>
			<div class="fe-item-body">
				<button type="button" class="fe-info" onclick="return Dialog.info({$ID})" title="{$LNG.fe_info_button}" aria-label="{$LNG.fe_info_button}: {$LNG.tech.{$ID}}"><i class="bi bi-info-lg"></i></button>
				<div class="fe-item-head">
					<h3>{$LNG.tech.{$ID}}</h3>
					<span class="fe-item-sub">{$LNG.bd_lvl} {$Element.level}/{$Element.maxLevel}</span>
				</div>
				{if !empty($Element.elementBonus)}
				<ul class="fe-bonus">
					{foreach $Element.elementBonus as $BonusName => $Bonus}
					<li>{if $Bonus[0] < 0}−{else}+{/if}{if $Bonus[1] == 0}{abs($Bonus[0] * 100)}%{else}{floatval(abs($Bonus[0]))}{/if} {$LNG.bonus.$BonusName}</li>
					{/foreach}
				</ul>
				{/if}
				{if !$maxed}
					{include file="fe.cost.tpl" cost=$Element.costResources overflow=$Element.costOverflow}
				{/if}
				<div class="fe-item-actions">
				{if $maxed}
					<span class="fe-reason">{$LNG.bd_maxlevel}</span>
				{elseif $Element.buyable}
					<form action="game.php?page=officier" method="post">
						<input type="hidden" name="id" value="{$ID}">
						<button type="submit" class="fe-btn fe-btn-primary"><i class="bi bi-person-plus"></i> {sprintf($LNG.fe_of_hire, $Element.level + 1)}</button>
					</form>
				{else}
					<span class="fe-reason">{$LNG.fe_missing_res}</span>
				{/if}
				</div>
			</div>
		</article>
	{/foreach}
	</div>
	{/if}

	{if !empty($darkmatterList)}
	<h3 class="fe-section-title">{$of_dm_trade}</h3>
	<div class="fe-grid">
	{foreach $darkmatterList as $ID => $Element}
		{$active = $Element.timeLeft > 0}
		<article class="fe-item {if $active}is-active{elseif $Element.buyable}is-ready{else}is-blocked{/if}">
			<button type="button" class="fe-item-img" onclick="return Dialog.info({$ID})" title="{$LNG.fe_info}">
				<img src="{$dpath}gebaeude/{$ID}.gif" alt="" width="88" height="88" loading="lazy">
			</button>
			<div class="fe-item-body">
				<button type="button" class="fe-info" onclick="return Dialog.info({$ID})" title="{$LNG.fe_info_button}" aria-label="{$LNG.fe_info_button}: {$LNG.tech.{$ID}}"><i class="bi bi-info-lg"></i></button>
				<div class="fe-item-head">
					<h3>{$LNG.tech.{$ID}}</h3>
					{if $active}
					<span class="fe-item-sub fe-active"><i class="bi bi-lightning-charge-fill"></i> {$LNG.of_active} · <span id="time_{$ID}">{$Element.timeLeft|time}</span></span>
					{else}
					<span class="fe-item-sub">{$LNG.of_still} {$Element.time|time}</span>
					{/if}
				</div>
				{if !empty($Element.elementBonus)}
				<ul class="fe-bonus">
					{foreach $Element.elementBonus as $BonusName => $Bonus}
					<li>{if $Bonus[0] < 0}−{else}+{/if}{if $Bonus[1] == 0}{abs($Bonus[0] * 100)}%{else}{floatval(abs($Bonus[0]))}{/if} {$LNG.bonus.$BonusName}</li>
					{/foreach}
				</ul>
				{/if}
				{include file="fe.cost.tpl" cost=$Element.costResources overflow=$Element.costOverflow}
				<div class="fe-item-actions">
				{if $Element.buyable}
					<form action="game.php?page=officier" method="post">
						<input type="hidden" name="id" value="{$ID}">
						<button type="submit" class="fe-btn fe-btn-primary"><i class="bi bi-{if $active}plus-circle{else}play-circle{/if}"></i> {if $active}{$LNG.fe_of_extend}{else}{$LNG.fe_of_activate}{/if} · {$Element.time|time}</button>
					</form>
				{else}
					<span class="fe-reason">{$LNG.fe_missing_res}</span>
				{/if}
				</div>
			</div>
		</article>
	{/foreach}
	</div>
	{/if}
</div>
<script src="scripts/game/officier.js"></script>
{/block}
