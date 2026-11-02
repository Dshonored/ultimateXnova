{* Empire matrix section. Params: title, rows (element id => [planet id => amount]), colspan *}
<tr class="fe-emp-section"><th colspan="{$colspan}">{$title}</th></tr>
{foreach $rows as $elementID => $amounts}
	{$rowTotal = array_sum($amounts)}
	<tr class="{if $rowTotal == 0}is-zero{/if}">
		<th scope="row"><button type="button" onclick="return Dialog.info({$elementID})"><img src="{$dpath}gebaeude/{$elementID}.{if $elementID >= 600 && $elementID <= 699}jpg{else}gif{/if}" alt="" width="22" height="22" loading="lazy"><span>{$LNG.tech.$elementID}</span></button></th>
		<td class="fe-emp-total">{$rowTotal|number}</td>
		{foreach $amounts as $planetID => $amount}
		<td class="{if $amount == 0}is-none{/if}">{$amount|number}</td>
		{/foreach}
	</tr>
{/foreach}
