{* Cost list for a build card. Params: cost (array id => amount), overflow (array id => still missing) *}
<ul class="fe-cost">
{foreach $cost as $RessID => $RessAmount}
	{$missing = $overflow[$RessID]|default:0}
	<li class="{if $missing > 0}is-short{else}is-ok{/if}" title="{$LNG.tech.$RessID}{if $missing > 0} · {$LNG.bd_remaining}: {$missing|number}{/if}">
		<img src="{$dpath}gebaeude/{$RessID}.{if $RessID >= 600 && $RessID <= 699}jpg{else}gif{/if}" alt="{$LNG.tech.$RessID}" width="18" height="18">
		<span class="fe-cost-amount">{$RessAmount|number}</span>
		{if $missing > 0}<span class="fe-cost-missing">−{shortly_number($missing)}</span>{/if}
	</li>
{/foreach}
</ul>
