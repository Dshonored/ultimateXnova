{block name="title" prepend}{$LNG.lm_resources}{/block}
{block name="content"}
<div class="fe-build fe-res">
	<header class="fe-toolbar">
		<div class="fe-toolbar-title">
			<h2><i class="bi bi-box-seam"></i> {$header}</h2>
		</div>
	</header>

	<section class="fe-res-tiles">
		{foreach $resourceTiles as $tile}
		<article class="fe-res-tile">
			<button type="button" class="fe-res-tile-head" onclick="return Dialog.info({$tile.id})" title="{$LNG.fe_info}">
				<img src="{$dpath}gebaeude/{$tile.id}.gif" alt="" width="28" height="28">
				<span>{$LNG.tech[$tile.id]}</span>
			</button>
			<b class="fe-res-net {if $tile.net > 0}is-ok{elseif $tile.net < 0}is-short{/if}">{if $tile.net > 0}+{/if}{$tile.net|number}<small>/h</small></b>
			<dl>
				<div><dt>{$LNG.rs_daily}</dt><dd>{$tile.daily|number}</dd></div>
				<div><dt>{$LNG.rs_weekly}</dt><dd>{$tile.weekly|number}</dd></div>
				{if $tile.storage !== null}<div><dt>{$LNG.rs_storage_capacity}</dt><dd>{$tile.storage}</dd></div>{/if}
			</dl>
		</article>
		{/foreach}
	</section>

	<form action="?page=resources" method="post" id="fe-res-form">
		<input type="hidden" name="mode" value="send">
		<h3 class="fe-section-title">{$LNG.fe_res_producers}</h3>
		<div class="fe-grid">
		{foreach $productionList as $productionID => $productionRow}
			<article class="fe-item fe-producer">
				<button type="button" class="fe-item-img" onclick="return Dialog.info({$productionID})" title="{$LNG.fe_info}">
					<img src="{$dpath}gebaeude/{$productionID}.{if $productionID >= 600 && $productionID <= 699}jpg{else}gif{/if}" alt="" width="64" height="64" loading="lazy">
					<span class="fe-item-level">{$productionRow.elementLevel}</span>
				</button>
				<div class="fe-item-body">
					<div class="fe-item-head">
						<h3>{$LNG.tech.$productionID}</h3>
						<span class="fe-item-sub">{if $productionID > 200}{$LNG.rs_amount}{else}{$LNG.rs_lvl}{/if} {$productionRow.elementLevel}</span>
					</div>
					{include file="fe.res.value.tpl" values=$productionRow.production}
					<label class="fe-prod-level">
						<span>{$LNG.fe_res_power}</span>
						{html_options name="prod[{$productionID}]" options=$prodSelector selected=$productionRow.prodLevel onchange="this.form.submit()"}
					</label>
				</div>
			</article>
		{/foreach}
		</div>
		<noscript><button type="submit" class="fe-btn fe-btn-primary">{$LNG.rs_calculate}</button></noscript>
	</form>

	<h3 class="fe-section-title">{$LNG.fe_res_breakdown}</h3>
	<div class="fe-res-extra">
		<div class="fe-panel">
			<strong>{$LNG.rs_basic_income}</strong>
			{include file="fe.res.value.tpl" values=$basicProduction}
		</div>
		<div class="fe-panel">
			<strong>{$LNG.rs_ress_bonus}</strong>
			{include file="fe.res.value.tpl" values=$bonusProduction}
		</div>
	</div>
</div>
{/block}
