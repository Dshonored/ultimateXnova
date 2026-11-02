{block name="title" prepend}{$LNG.lm_fleet}{/block}
{block name="content"}
<div class="fe-build fe-fleet">

	<header class="fe-toolbar">
		<div class="fe-toolbar-title">
			<h2><i class="bi bi-send"></i> {$LNG.lm_fleet}</h2>
			<span class="fe-pill"><i class="bi bi-diagram-3"></i> {$LNG.fl_fleets} {$activeFleetSlots}/{$maxFleetSlots}</span>
			<span class="fe-pill"><i class="bi bi-compass"></i> {$LNG.fl_expeditions} {$activeExpedition}/{$maxExpedition}</span>
		</div>
	</header>

	{if !empty($FlyingFleetList)}
	<h3 class="fe-section-title">{$LNG.fe_fl_active}</h3>
	<ul class="fe-flights">
	{foreach name=FlyingFleets item=FlyingFleetRow from=$FlyingFleetList}
		<li class="fe-flight {if $FlyingFleetRow.state == 1}is-return{/if}">
			<div class="fe-flight-main">
				<strong>{$LNG["type_mission_{$FlyingFleetRow.mission}"]}</strong>
				<span class="fe-flight-state" title="{if $FlyingFleetRow.state == 1}{$LNG.fl_returning}{else}{$LNG.fl_onway}{/if}"><i class="bi bi-{if $FlyingFleetRow.state == 1}arrow-return-left{else}arrow-right{/if}"></i> {if $FlyingFleetRow.state == 1}{$LNG.fl_returning}{else}{$LNG.fl_onway}{/if}</span>
			</div>
			<div class="fe-flight-route">
				<a href="game.php?page=galaxy&amp;galaxy={$FlyingFleetRow.startGalaxy}&amp;system={$FlyingFleetRow.startSystem}">[{$FlyingFleetRow.startGalaxy}:{$FlyingFleetRow.startSystem}:{$FlyingFleetRow.startPlanet}]</a>
				<i class="bi bi-arrow-right"></i>
				<a href="game.php?page=galaxy&amp;galaxy={$FlyingFleetRow.endGalaxy}&amp;system={$FlyingFleetRow.endSystem}">[{$FlyingFleetRow.endGalaxy}:{$FlyingFleetRow.endSystem}:{$FlyingFleetRow.endPlanet}]</a>
			</div>
			<div class="fe-flight-meta">
				<span title="{foreach $FlyingFleetRow.FleetList as $shipID => $shipCount}{$LNG.tech.{$shipID}}: {$shipCount}&#10;{/foreach}"><i class="bi bi-rocket-takeoff"></i> {$FlyingFleetRow.amount}</span>
				<span title="{$LNG['tech'][901]}: {$FlyingFleetRow.metal} · {$LNG['tech'][902]}: {$FlyingFleetRow.crystal} · {$LNG['tech'][903]}: {$FlyingFleetRow.deuterium}"><i class="bi bi-box-seam"></i> {$FlyingFleetRow.metal} / {$FlyingFleetRow.crystal} / {$FlyingFleetRow.deuterium}</span>
			</div>
			<div class="fe-flight-time">
				<b id="fleettime_{$smarty.foreach.FlyingFleets.iteration}" class="fleets" data-fleet-end-time="{$FlyingFleetRow.returntime}" data-fleet-time="{$FlyingFleetRow.resttime}">{pretty_fly_time({$FlyingFleetRow.resttime})}</b>
				<small>{$LNG.fl_arrival}: {if $FlyingFleetRow.mission == 4 && $FlyingFleetRow.state == 0}{$FlyingFleetRow.startTime}{else}{$FlyingFleetRow.endTime}{/if}</small>
			</div>
			<div class="fe-flight-actions">
			{if !$isVacation && $FlyingFleetRow.state != 1 && $FlyingFleetRow.no_returnable != 1}
				<form action="game.php?page=fleetTable&amp;action=sendfleetback" method="post">
					<input name="fleetID" value="{$FlyingFleetRow.id}" type="hidden">
					<button class="fe-btn fe-btn-ghost" type="submit"><i class="bi bi-arrow-return-left"></i> {$LNG.fl_send_back}</button>
				</form>
				{if $FlyingFleetRow.mission == 1}
				<form action="game.php?page=fleetTable&amp;action=acs" method="post">
					<input name="fleetID" value="{$FlyingFleetRow.id}" type="hidden">
					<button class="fe-btn fe-btn-ghost" type="submit">{$LNG.fl_acs}</button>
				</form>
				{/if}
			{/if}
			</div>
		</li>
	{/foreach}
	</ul>
	{/if}

	{if $maxFleetSlots == $activeFleetSlots}
	<div class="fe-notice"><i class="bi bi-exclamation-triangle"></i> {$LNG.fl_no_more_slots}</div>
	{/if}

	{if !empty($acsData)}
	{include file="shared.fleetTable.acsTable.tpl"}
	{/if}

	{include file="fe.fleet.steps.tpl" step=1}

	<form action="?page=fleetStep1" method="post" id="fe-fleet-form">
		<input type="hidden" name="galaxy" value="{$targetGalaxy}">
		<input type="hidden" name="system" value="{$targetSystem}">
		<input type="hidden" name="planet" value="{$targetPlanet}">
		<input type="hidden" name="type" value="{$targetType}">
		<input type="hidden" name="target_mission" value="{$targetMission}">

		{if count($FleetsOnPlanet) == 0}
			<p class="fe-empty">{$LNG.fl_no_ships}</p>
		{else}
		<div class="fe-fleet-tools">
			<button type="button" class="fe-btn fe-btn-ghost" onclick="maxShips()">{$LNG.fl_select_all_ships}</button>
			<button type="button" class="fe-btn fe-btn-ghost" onclick="noShips()">{$LNG.fl_remove_all_ships}</button>
		</div>
		<div class="fe-grid">
		{foreach $FleetsOnPlanet as $FleetRow}
			<article class="fe-item fe-ship {if $FleetRow.speed != 0}is-ready{else}is-blocked{/if}">
				<button type="button" class="fe-item-img" onclick="return Dialog.info({$FleetRow.id})" title="{$LNG.fe_info}">
					<img src="{$dpath}gebaeude/{$FleetRow.id}.gif" alt="" width="64" height="64" loading="lazy">
				</button>
				<div class="fe-item-body">
					<div class="fe-item-head">
						<h3>{$LNG.tech.{$FleetRow.id}}</h3>
						<span class="fe-item-sub">{$LNG.fe_have} <span id="ship{$FleetRow.id}_value">{$FleetRow.count}</span>{if $FleetRow.speed != 0} · <i class="bi bi-speedometer2"></i> {$FleetRow.speed|number}{/if}</span>
					</div>
					{if $FleetRow.speed != 0}
					<div class="fe-stepper">
						<input type="number" inputmode="numeric" min="0" max="{$FleetRow.count}" name="ship{$FleetRow.id}" id="ship{$FleetRow.id}_input" value="0" aria-label="{$LNG.tech.{$FleetRow.id}}">
						<button type="button" class="fe-btn fe-btn-ghost" onclick="maxShip('ship{$FleetRow.id}')">{$LNG.fl_max}</button>
					</div>
					{/if}
				</div>
			</article>
		{/foreach}
		</div>
		{if $maxFleetSlots != $activeFleetSlots}
		<div class="fe-submitbar">
			<span><b data-fleet-total>0</b> <i class="bi bi-rocket-takeoff"></i></span>
			<button type="submit" class="fe-btn fe-btn-primary" data-fleet-continue disabled>{$LNG.fl_continue} <i class="bi bi-arrow-right"></i></button>
		</div>
		{/if}
		{/if}
	</form>

	<h3 class="fe-section-title">{$LNG.fl_bonus}</h3>
	<ul class="fe-bonus fe-bonus-wide">
		<li>+{$bonusAttack}% {$LNG.fl_bonus_attack}</li>
		<li>+{$bonusDefensive}% {$LNG.fl_bonus_defensive}</li>
		<li>+{$bonusShield}% {$LNG.fl_bonus_shield}</li>
		<li>+{$bonusCombustion}% {$LNG.tech.115}</li>
		<li>+{$bonusImpulse}% {$LNG.tech.117}</li>
		<li>+{$bonusHyperspace}% {$LNG.tech.118}</li>
	</ul>
</div>
<script src="scripts/game/fleetTable.js"></script>
<script src="scripts/game/fe-fleet.js?v={$smarty.const.ASSET_VERSION}"></script>
{/block}
