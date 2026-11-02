{block name="title" prepend}{$LNG.lm_fleet}{/block}
{block name="content"}
<div class="fe-build fe-fleet">
	<div class="fe-success"><i class="bi bi-check-circle-fill"></i> {$LNG.fl_fleet_sended}</div>
	<section class="fe-panel">
		<dl class="fe-facts">
			<div><dt>{$LNG.fl_mission}</dt><dd>{$LNG["type_mission_{$targetMission}"]}</dd></div>
			<div><dt>{$LNG.fl_from}</dt><dd>{$from}</dd></div>
			<div><dt>{$LNG.fl_destiny}</dt><dd>{$destination}</dd></div>
			<div><dt>{$LNG.fl_distance}</dt><dd>{$distance|number}</dd></div>
			<div><dt>{$LNG.fl_fleet_speed}</dt><dd>{$MaxFleetSpeed|number}</dd></div>
			<div><dt>{$LNG.fl_fuel_consumption}</dt><dd>{$consumption|number}</dd></div>
			<div><dt>{$LNG.fl_arrival_time}</dt><dd>{$fleetStartTime}</dd></div>
			<div><dt>{$LNG.fl_return_time}</dt><dd>{$fleetEndTime}</dd></div>
		</dl>
	</section>
	<h3 class="fe-section-title">{$LNG.fl_fleet}</h3>
	<ul class="fe-bonus fe-bonus-wide fe-shiplist">
	{foreach $FleetList as $ShipID => $ShipCount}
		<li>{$ShipCount|number} × {$LNG.tech.{$ShipID}}</li>
	{/foreach}
	</ul>
	<div class="fe-fleet-tools"><a class="fe-btn fe-btn-primary" href="game.php?page=fleetTable"><i class="bi bi-send"></i> {$LNG.lm_fleet}</a></div>
</div>
{/block}
