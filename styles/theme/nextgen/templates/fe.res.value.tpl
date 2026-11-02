{* Non-zero production values. Param: values (array id => amount) *}
<ul class="fe-prod">
{foreach $values as $resId => $amount}
	{if $amount != 0}
	<li class="{if $amount > 0}is-ok{else}is-short{/if}" title="{$LNG.tech.$resId}">
		<img src="{$dpath}gebaeude/{$resId}.gif" alt="{$LNG.tech.$resId}" width="18" height="18">
		{if $amount > 0}+{/if}{$amount|number}
	</li>
	{/if}
{/foreach}
</ul>
