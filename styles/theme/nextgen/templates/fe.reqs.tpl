{* Missing requirements for a locked card. Param: reqs (array of requireID/neededLevel/currentLevel) *}
<div class="fe-reqs">
	<span class="fe-reqs-title"><i class="bi bi-lock"></i> {$LNG.fe_requires}</span>
	<ul>
	{foreach $reqs as $req}
		<li class="{if $req.currentLevel >= $req.neededLevel}is-ok{else}is-short{/if}">
			<img src="{$dpath}gebaeude/{$req.requireID}.gif" alt="" width="20" height="20">
			<span>{$LNG.tech.{$req.requireID}}</span>
			<b>{$req.currentLevel}/{$req.neededLevel}</b>
		</li>
	{/foreach}
	</ul>
</div>
