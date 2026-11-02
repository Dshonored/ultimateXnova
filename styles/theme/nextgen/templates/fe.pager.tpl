{* Pagination. Params: current, max, base (URL ending in a query, page number is appended) *}
{if $max > 1}
<nav class="fe-pager" aria-label="{$LNG.mg_page}">
	{if $current > 1}<a href="{$base}{$current - 1}" aria-label="-1"><i class="bi bi-chevron-left"></i></a>{/if}
	{for $site=1 to $max}
		{if $site == $current}
		<span aria-current="page">{$site}</span>
		{elseif $site == 1 || $site == $max || ($site > $current - 3 && $site < $current + 3)}
		<a href="{$base}{$site}">{$site}</a>
		{elseif $site == $current - 3 || $site == $current + 3}
		<em>…</em>
		{/if}
	{/for}
	{if $current < $max}<a href="{$base}{$current + 1}" aria-label="+1"><i class="bi bi-chevron-right"></i></a>{/if}
</nav>
{/if}
