{block name="title" prepend}{$LNG.lm_galaxy}{/block}
{block name="content"}
<div class="fe-build fe-galaxy">

	<form action="?page=galaxy" method="post" id="galaxy_form" class="fe-sys-nav">
		<input type="hidden" id="auto" value="dr">
		<div class="fe-sys-pick">
			<span>{$LNG.gl_galaxy}</span>
			<input class="fe-btn fe-btn-icon" type="button" name="galaxyLeft" value="&lt;" onclick="galaxy_submit('galaxyLeft')" aria-label="-1">
			<input type="text" inputmode="numeric" name="galaxy" value="{$galaxy}" maxlength="3" tabindex="1" aria-label="{$LNG.gl_galaxy}">
			<input class="fe-btn fe-btn-icon" type="button" name="galaxyRight" value="&gt;" onclick="galaxy_submit('galaxyRight')" aria-label="+1">
		</div>
		<div class="fe-sys-pick">
			<span>{$LNG.gl_solar_system}</span>
			<input class="fe-btn fe-btn-icon" type="button" name="systemLeft" value="&lt;" onclick="galaxy_submit('systemLeft')" aria-label="-1">
			<input type="text" inputmode="numeric" name="system" value="{$system}" maxlength="3" tabindex="2" aria-label="{$LNG.gl_solar_system}">
			<input class="fe-btn fe-btn-icon" type="button" name="systemRight" value="&gt;" onclick="galaxy_submit('systemRight')" aria-label="+1">
		</div>
		<input class="fe-btn fe-btn-primary" id="galaxySubmit" type="submit" value="{$LNG.gl_show}">
	</form>

	<div class="fe-sys-stats">
		<span class="fe-pill"><i class="bi bi-eye"></i> <span id="elementID210">{$spyprobes|number}</span> {$LNG.gl_avaible_spyprobes}</span>
		<span class="fe-pill"><i class="bi bi-recycle"></i> <span id="elementID209">{$recyclers|number}</span> {$LNG.gl_avaible_recyclers}</span>
		<span class="fe-pill"><i class="bi bi-rocket"></i> <span id="missiles">{$currentmip|number}</span> {$LNG.gl_avaible_missiles}</span>
		<span class="fe-pill"><i class="bi bi-send"></i> <span id="slots">{$maxfleetcount}</span>/{$fleetmax} {$LNG.gl_fleets}</span>
		<span class="fe-pill">{$planetcount}</span>
	</div>

	<table class="fe-sys-status"><tr style="display:none;" id="fleetstatusrow"><th colspan="8">{$LNG.cff_fleet_target}</th></tr></table>

	{if $action == 'sendMissle'}
	<form action="?page=fleetMissile" method="post" class="fe-panel fe-missile">
		<input type="hidden" name="galaxy" value="{$galaxy}">
		<input type="hidden" name="system" value="{$system}">
		<input type="hidden" name="planet" value="{$planet}">
		<input type="hidden" name="type" value="{$type}">
		<strong>{$LNG.gl_missil_launch} [{$galaxy}:{$system}:{$planet}]</strong>
		<label>{$missile_count} <input type="text" inputmode="numeric" name="SendMI" maxlength="7"></label>
		<label>{$LNG.gl_objective} {html_options name=Target options=$missileSelector}</label>
		<button type="submit" class="fe-btn fe-btn-primary">{$LNG.gl_missil_launch_action}</button>
	</form>
	{/if}

	<h3 class="fe-section-title">{$LNG.gl_solar_system} {$galaxy}:{$system}</h3>
	<div class="fe-sys">
	{for $planet=1 to $max_planets}
		{if !isset($GalaxyRows[$planet])}
		<a class="fe-sys-empty" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&amp;target_mission=7">
			<span class="fe-sys-pos">{$planet}</span>
			<span>{$LNG.type_mission_7} <i class="bi bi-plus-circle"></i></span>
		</a>
		{elseif $GalaxyRows[$planet] === false}
		<div class="fe-sys-empty is-destroyed">
			<span class="fe-sys-pos">{$planet}</span>
			<span>{$LNG.gl_planet_destroyed}</span>
		</div>
		{else}
		{$currentPlanet = $GalaxyRows[$planet]}
		<details class="fe-sys-row {if $currentPlanet.ownPlanet}is-own{/if}">
			<summary>
				<span class="fe-sys-pos">{$planet}</span>
				<img class="fe-sys-img" src="{$dpath}planeten/{$currentPlanet.planet.image}.jpg" width="40" height="40" alt="">
				<span class="fe-sys-name">
					<strong>{$currentPlanet.planet.name} <small>{$currentPlanet.lastActivity}</small></strong>
					<span>
						<span class="{foreach $currentPlanet.user.class as $class}{if !$class@first} {/if}galaxy-username-{$class}{/foreach} galaxy-username">{$currentPlanet.user.username}</span>
						{foreach $currentPlanet.user.class as $class}<span class="galaxy-short-{$class} galaxy-short">{$ShortStatus.$class}</span>{/foreach}
						{if $currentPlanet.alliance}<span class="{foreach $currentPlanet.alliance.class as $class}{if !$class@first} {/if}galaxy-alliance-{$class}{/foreach} galaxy-alliance">[{$currentPlanet.alliance.tag}]</span>{/if}
					</span>
				</span>
				<span class="fe-sys-icons">
					{if $currentPlanet.moon}<img src="{$dpath}planeten/mond.jpg" width="22" height="22" alt="{$LNG.gl_moon}" title="{$LNG.gl_moon}: {$currentPlanet.moon.name}">{/if}
					{if $currentPlanet.debris}<img src="{$dpath}planeten/debris.jpg" width="22" height="22" alt="{$LNG.gl_debris}" title="{$LNG.gl_debris}: {$currentPlanet.debris.metal|number} / {$currentPlanet.debris.crystal|number}">{/if}
					{if $currentPlanet.action && $currentPlanet.action.esp}<button type="button" class="fe-btn fe-btn-icon" title="{$LNG.gl_spy}" aria-label="{$LNG.gl_spy}" onclick="event.preventDefault();doit(6,{$currentPlanet.planet.id})"><i class="bi bi-eye"></i></button>{/if}
					{if $currentPlanet.action && $currentPlanet.action.message}<button type="button" class="fe-btn fe-btn-icon" title="{$LNG.write_message}" aria-label="{$LNG.write_message}" onclick="event.preventDefault();return Dialog.PM({$currentPlanet.user.id})"><i class="bi bi-envelope"></i></button>{/if}
					<i class="bi bi-chevron-down fe-sys-chev"></i>
				</span>
			</summary>
			<div class="fe-sys-actions">
				{if $userAuthLevel == 3}<p class="fe-hint">user ID: {$currentPlanet.user.id} · planet ID: {$currentPlanet.planet.id}{if $currentPlanet.moon} · moon ID: {$currentPlanet.moon.id}{/if}</p>{/if}

				<div class="fe-sys-group">
					<span class="fe-queue-label">{$LNG.gl_planet}</span>
					<div class="fe-chips">
						{if $currentPlanet.missions.1}<a class="fe-chip" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&amp;target_mission=1">{$LNG.type_mission_1}</a>{/if}
						{if $currentPlanet.missions.3}<a class="fe-chip" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&amp;target_mission=3">{$LNG.type_mission_3}</a>{/if}
						{if $currentPlanet.missions.4}<a class="fe-chip" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&amp;target_mission=4">{$LNG.type_mission_4}</a>{/if}
						{if $currentPlanet.missions.5}<a class="fe-chip" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&amp;target_mission=5">{$LNG.type_mission_5}</a>{/if}
						{if $currentPlanet.missions.6}<button type="button" class="fe-chip" onclick="doit(6,{$currentPlanet.planet.id})">{$LNG.type_mission_6}</button>{/if}
						<a class="fe-chip" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1&amp;target_mission=17">{$LNG.type_mission_17}</a>
						{if $currentPlanet.missions.10}<a class="fe-chip" href="?page=galaxy&amp;action=sendMissle&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;type=1">{$LNG.type_mission_10}</a>{/if}
						{if $currentPlanet.planet.phalanx}<button type="button" class="fe-chip" onclick="OpenPopup('?page=phalanx&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=1','',640,510)">{$LNG.gl_phalanx}</button>{/if}
					</div>
				</div>

				{if $currentPlanet.moon}
				<div class="fe-sys-group">
					<span class="fe-queue-label">{$LNG.gl_moon} {$currentPlanet.moon.name} · {$LNG.gl_diameter} {$currentPlanet.moon.diameter|number} · {$LNG.gl_temperature} {$currentPlanet.moon.temp_min}</span>
					<div class="fe-chips">
						{if $currentPlanet.missions.1}<a class="fe-chip" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=3&amp;target_mission=1">{$LNG.type_mission_1}</a>{/if}
						{if $currentPlanet.missions.3}<a class="fe-chip" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=3&amp;target_mission=3">{$LNG.type_mission_3}</a>{/if}
						{if $currentPlanet.missions.4}<a class="fe-chip" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=3&amp;target_mission=4">{$LNG.type_mission_4}</a>{/if}
						{if $currentPlanet.missions.5}<a class="fe-chip" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=3&amp;target_mission=5">{$LNG.type_mission_5}</a>{/if}
						{if $currentPlanet.missions.6}<button type="button" class="fe-chip" onclick="doit(6,{$currentPlanet.moon.id})">{$LNG.type_mission_6}</button>{/if}
						{if $currentPlanet.missions.9}<a class="fe-chip" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;planettype=3&amp;target_mission=9">{$LNG.type_mission_9}</a>{/if}
						{if $currentPlanet.missions.10}<a class="fe-chip" href="?page=galaxy&amp;action=sendMissle&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$planet}&amp;type=3">{$LNG.type_mission_10}</a>{/if}
					</div>
				</div>
				{/if}

				{if $currentPlanet.debris}
				<div class="fe-sys-group">
					<span class="fe-queue-label">{$LNG.gl_debris_field} · {$LNG.tech.901} {$currentPlanet.debris.metal|number} · {$LNG.tech.902} {$currentPlanet.debris.crystal|number}</span>
					{if $currentPlanet.missions.8 && $recyclers > 0}
					<div class="fe-chips"><button type="button" class="fe-chip" onclick="doit(8,{$currentPlanet.planet.id})"><i class="bi bi-recycle"></i> {$LNG.type_mission_8}</button></div>
					{/if}
				</div>
				{/if}

				<div class="fe-sys-group">
					<span class="fe-queue-label">{$currentPlanet.user.playerrank}</span>
					<div class="fe-chips">
						{if !$currentPlanet.ownPlanet}
						<button type="button" class="fe-chip" onclick="return Dialog.Playercard({$currentPlanet.user.id})">{$LNG.gl_playercard}</button>
						{if $currentPlanet.action && $currentPlanet.action.buddy}<button type="button" class="fe-chip" onclick="return Dialog.Buddy({$currentPlanet.user.id})">{$LNG.gl_buddy_request}</button>{/if}
						{/if}
						<a class="fe-chip" href="?page=statistics&amp;who=1&amp;start={$currentPlanet.user.rank}">{$LNG.gl_see_on_stats}</a>
					</div>
				</div>

				{if $currentPlanet.alliance}
				<div class="fe-sys-group">
					<span class="fe-queue-label">{$LNG.gl_alliance} {$currentPlanet.alliance.name} {$currentPlanet.alliance.member}</span>
					<div class="fe-chips">
						<a class="fe-chip" href="?page=alliance&amp;mode=info&amp;id={$currentPlanet.alliance.id}">{$LNG.gl_alliance_page}</a>
						<a class="fe-chip" href="?page=statistics&amp;start={$currentPlanet.alliance.rank}&amp;who=2">{$LNG.gl_see_on_stats}</a>
					</div>
				</div>
				{/if}
			</div>
		</details>
		{/if}
	{/for}
		<a class="fe-sys-empty" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$max_planets + 1}&amp;planettype=1&amp;target_mission=15">
			<span class="fe-sys-pos">{$max_planets + 1}</span><span><i class="bi bi-compass"></i> {$LNG.gl_out_space}</span>
		</a>
		<a class="fe-sys-empty" href="?page=fleetTable&amp;galaxy={$galaxy}&amp;system={$system}&amp;planet={$max_planets + 2}&amp;planettype=1&amp;target_mission=16">
			<span class="fe-sys-pos">{$max_planets + 2}</span><span><i class="bi bi-shop"></i> {$LNG.gl_trade_space}</span>
		</a>
	</div>

	<details class="fe-legend">
		<summary>{$LNG.gl_legend}</summary>
		<ul>
			<li><span class="galaxy-short-strong galaxy-short">{$LNG.gl_short_strong}</span> {$LNG.gl_strong_player}</li>
			<li><span class="galaxy-short-noob galaxy-short">{$LNG.gl_short_newbie}</span> {$LNG.gl_week_player}</li>
			<li><span class="galaxy-short-vacation galaxy-short">{$LNG.gl_short_vacation}</span> {$LNG.gl_vacation}</li>
			<li><span class="galaxy-short-banned galaxy-short">{$LNG.gl_short_ban}</span> {$LNG.gl_banned}</li>
			<li><span class="galaxy-short-inactive galaxy-short">{$LNG.gl_short_inactive}</span> {$LNG.gl_inactive_seven}</li>
			<li><span class="galaxy-short-longinactive galaxy-short">{$LNG.gl_short_long_inactive}</span> {$LNG.gl_inactive_twentyeight}</li>
		</ul>
	</details>
</div>
<script type="text/javascript">
	status_ok		= '{$LNG.gl_ajax_status_ok}';
	status_fail		= '{$LNG.gl_ajax_status_fail}';
	MaxFleetSetting = {$settings_fleetactions};
</script>
{/block}
