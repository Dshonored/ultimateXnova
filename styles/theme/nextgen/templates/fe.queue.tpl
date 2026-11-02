{* Build/research queue. Params: queue (array), action (form URL). Keeps #progressbar/#time for buildlist.js/research.js *}
<section class="fe-queue" aria-label="{$LNG.fe_queue_now}">
{foreach $queue as $List}
	{$ID = $List.element}
	{if $List@first}
	<div class="fe-queue-now">
		<button type="button" class="fe-queue-img" onclick="return Dialog.info({$ID})" title="{$LNG.fe_info}">
			<img src="{$dpath}gebaeude/{$ID}.gif" alt="" width="64" height="64">
		</button>
		<div class="fe-queue-body">
			<div class="fe-queue-head">
				<span class="fe-queue-label">{$LNG.fe_queue_now}</span>
				<strong>{$LNG.tech.{$ID}} · {$LNG.bd_lvl} {$List.level}</strong>
			</div>
			<div id="progressbar" class="fe-progress" data-time="{$List.resttime}"></div>
			<div class="fe-queue-times">
				<span><i class="bi bi-hourglass-split"></i> <span id="time" data-time="{$List.time}"></span></span>
				<span><i class="bi bi-flag"></i> {$List.display}</span>
			</div>
		</div>
		<form action="{$action}" method="post">
			<input type="hidden" name="cmd" value="cancel">
			<button type="submit" class="fe-btn fe-btn-ghost fe-btn-danger" title="{$LNG.bd_cancel}"><i class="bi bi-x-lg"></i> <span>{$LNG.bd_cancel}</span></button>
		</form>
	</div>
	{if $List@total > 1}<div class="fe-queue-next"><span class="fe-queue-label">{$LNG.fe_queue_next}</span>{/if}
	{else}
		<div class="fe-queue-chip onlist" title="{$LNG.tech.{$ID}} · {$List.display}">
			<img src="{$dpath}gebaeude/{$ID}.gif" alt="" width="32" height="32">
			<span>{$LNG.tech.{$ID}} <b>{$List.level}</b></span>
			<form action="{$action}" method="post">
				<input type="hidden" name="listid" value="{$List@iteration}">
				<input type="hidden" name="cmd" value="remove">
				<button type="submit" class="fe-chip-x" title="{$LNG.bd_cancel}" aria-label="{$LNG.bd_cancel}"><i class="bi bi-x"></i></button>
			</form>
		</div>
	{/if}
	{if $List@last && $List@total > 1}</div>{/if}
{/foreach}
</section>
