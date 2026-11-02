{* One activity slot on the overview. Params: job (array|false), icon, label, url *}
<a class="fe-job {if $job}is-busy{else}is-free{/if}" href="{$url}">
	<span class="fe-job-head"><i class="bi bi-{$icon}"></i> {$label}</span>
	{if $job}
		<span class="fe-job-body">
			<img src="{$dpath}gebaeude/{$job.id}.gif" alt="" width="48" height="48">
			<span>
				<strong>{$LNG.tech[$job.id]} <small>({$job.level})</small></strong>
				<span class="timer" data-time="{$job.timeleft}">{$job.starttime}</span>
			</span>
		</span>
	{else}
		<span class="fe-job-free"><i class="bi bi-plus-circle"></i> {$LNG.ov_free}</span>
	{/if}
</a>
