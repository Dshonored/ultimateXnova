{block name="title" prepend}{$LNG.lm_overview}{/block}
{block name="content"}
{$fieldsPct = min(100, round($planet_field_current / max($planet_field_max, 1) * 100))}
<div class="fe-build fe-ov">

	<section class="fe-ov-hero">
		<a class="fe-ov-planet" href="game.php?page=overview&amp;cp={$planet_id}">
			<img src="{$dpath}planeten/{$planetimage}.jpg" width="150" height="150" alt="{$planetname}">
		</a>
		<div class="fe-ov-main">
			<span class="fe-queue-label">{$LNG["type_planet_{$planet_type}"]}</span>
			<h2>
				{$planetname}
				<button type="button" class="fe-info" onclick="return Dialog.PlanetAction();" title="{$LNG.ov_planetmenu}" aria-label="{$LNG.ov_planetmenu}"><i class="bi bi-pencil"></i></button>
			</h2>
			<p class="fe-ov-owner">
				<i class="bi bi-person"></i> {$username}
				<a href="game.php?page=galaxy&amp;galaxy={$galaxy}&amp;system={$system}"><i class="bi bi-geo-alt"></i> [{$galaxy}:{$system}:{$planet}]</a>
			</p>

			<div class="fe-ov-fields" title="{$LNG.ov_developed_fields} / {$LNG.ov_max_developed_fields}">
				<div class="fe-ov-fields-head">
					<span>{$LNG.fe_fields}</span>
					<b>{$planet_field_current} / {$planet_field_max}</b>
				</div>
				<span class="fe-squeue-bar"><span style="width:{$fieldsPct}%"></span></span>
			</div>

			{if $Moon}
			<a class="fe-ov-moon" href="game.php?page=overview&amp;cp={$Moon.id}">
				<img src="{$dpath}planeten/{$Moon.image}.jpg" width="36" height="36" alt="">
				<span>{$Moon.name} <small>({$LNG.fcm_moon})</small></span>
			</a>
			{/if}
		</div>
	</section>

	<section class="fe-ov-stats">
		<div class="fe-stat"><i class="bi bi-trophy"></i><span>{$LNG.ov_points}</span><b>{$rankInfo}</b></div>
		<div class="fe-stat"><i class="bi bi-thermometer-half"></i><span>{$LNG.ov_temperature}</span><b>{$planet_temp_min}{$LNG.ov_temp_unit} {$LNG.ov_to} {$planet_temp_max}{$LNG.ov_temp_unit}</b></div>
		<div class="fe-stat"><i class="bi bi-rulers"></i><span>{$LNG.ov_diameter}</span><b>{$planet_diameter} {$LNG.ov_distance_unit}</b></div>
		<div class="fe-stat"><i class="bi bi-people"></i><span>{$LNG.ov_players}</span><b>{$usersOnline}</b></div>
		<div class="fe-stat"><i class="bi bi-send"></i><span>{$LNG.ov_moving_fleets}</span><b>{$fleetsOnline}</b></div>
		{if !empty($AdminsOnline)}
		<div class="fe-stat"><i class="bi bi-shield-check"></i><span>{$LNG.ov_admins_online}</span>
			<b>{foreach $AdminsOnline as $ID => $Name}{if !$Name@first}, {/if}<a href="#" onclick="return Dialog.PM({$ID})">{$Name}</a>{/foreach}</b>
		</div>
		{/if}
	</section>

	<section class="fe-ov-activity">
		{include file="fe.job.tpl" job=$buildInfo.buildings icon="building" label=$LNG.lm_buildings url="game.php?page=buildings"}
		{include file="fe.job.tpl" job=$buildInfo.tech icon="lightbulb" label=$LNG.lm_research url="game.php?page=research"}
		{include file="fe.job.tpl" job=$buildInfo.fleet icon="rocket-takeoff" label=$LNG.lm_shipshard url="game.php?page=shipyard&amp;mode=fleet"}
	</section>
</div>
{/block}
