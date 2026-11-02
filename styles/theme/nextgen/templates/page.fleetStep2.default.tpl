{block name="title" prepend}{$LNG.lm_fleet}{/block}
{block name="content"}
<div class="fe-build fe-fleet">
{include file="fe.fleet.steps.tpl" step=3}
<form action="game.php?page=fleetStep3" method="post">
	<input type="hidden" name="token" value="{$token}">

	<div class="fe-target-title"><i class="bi bi-geo-alt"></i> [{$galaxy}:{$system}:{$planet}] · {$LNG["type_planet_{$type}"]}</div>

	<h3 class="fe-section-title">{$LNG.fl_mission}</h3>
	<div class="fe-missions">
	{foreach $MissionSelector as $MissionID}
		<label class="fe-mission">
			<input id="radio_{$MissionID}" type="radio" name="mission" value="{$MissionID}" {if $mission == $MissionID || $MissionID@total == 1}checked="checked"{/if}>
			<span>
				<strong>{$LNG["type_mission_{$MissionID}"]}</strong>
				{if $MissionID == 17}<small>{$LNG.fl_transfer_alert_message}</small>{/if}
				{if $MissionID == 15}<small>{$LNG.fl_expedition_alert_message}</small>{/if}
				{if $MissionID == 11}<small>{$fl_dm_alert_message}</small>{/if}
			</span>
		</label>
	{/foreach}
	</div>

	<h3 class="fe-section-title">{$LNG.fl_resources}</h3>
	<section class="fe-panel">
		<div class="fe-cargo">
			<label><span>{$LNG.tech.901}</span><input name="metal" inputmode="numeric" onchange="calculateTransportCapacity();" oninput="calculateTransportCapacity();" type="text"><button type="button" class="fe-btn fe-btn-ghost" onclick="maxResource('metal')">{$LNG.fl_max}</button></label>
			<label><span>{$LNG.tech.902}</span><input name="crystal" inputmode="numeric" onchange="calculateTransportCapacity();" oninput="calculateTransportCapacity();" type="text"><button type="button" class="fe-btn fe-btn-ghost" onclick="maxResource('crystal')">{$LNG.fl_max}</button></label>
			<label><span>{$LNG.tech.903}</span><input name="deuterium" inputmode="numeric" onchange="calculateTransportCapacity();" oninput="calculateTransportCapacity();" type="text"><button type="button" class="fe-btn fe-btn-ghost" onclick="maxResource('deuterium')">{$LNG.fl_max}</button></label>
		</div>
		<div class="fe-cargo-foot">
			<button type="button" class="fe-btn fe-btn-ghost" onclick="maxResources()">{$LNG.fl_all_resources}</button>
			<span>{$LNG.fl_resources_left}: <b id="remainingresources">-</b></span>
			<span>{$LNG.fl_fuel_consumption}: <b id="consumption" class="consumption">{$consumption}</b></span>
		</div>
	</section>

		{if $Exchange}
		<h3 class="fe-section-title">{$LNG.fl_exchange}</h3>
		<section class="fe-panel">
				<table class="table table-gow table-sm">
				<tr class="no-border">
					<td >
						<select name="resEx">
							<option value="1">{$LNG.tech.901}</option>
							<option value="2">{$LNG.tech.902}</option>
							<option value="3">{$LNG.tech.903}</option>
						</select>
					</td>
					<td>
						<input name="exchange" size="10" type="text">
					</td>
				</tr>
				<tr class="no-border">
					<td>
						{$LNG.fl_visibility}
					</td>
					<td>
						<select name="visibility">
							<option value="2" selected>{$LNG.fl_visibility_no_enemies}</option>
							<option value="1">{$LNG.fl_visibility_alliance}</option>
							<option value="0">{$LNG.fl_visibility_all}</option>
						</select>
					</td>
				</tr>
				<tr class="no-border">
					<td>
						{$LNG.fl_market_type}
					</td>
					<td>
						<select name="markettype">
							<option value="0" selected>{$LNG.fl_mt_resources}</option>
							<option value="1">{$LNG.fl_mt_fleet}</option>
						</select>
					</td>
				</tr>
			</table>
			<!--
			Max flight time (0 = unlimited):
			<input name="maxFlightTime" size="10" type="text" value="0"> hours<br/>
			-->
		</section>
		{/if}

		{if $StaySelector}
		<h3 class="fe-section-title">{$LNG.fl_hold_time}</h3>
		<section class="fe-panel fe-stay">
			{html_options name=staytime options=$StaySelector} {$LNG.fl_hours}
		</section>
		{/if}

	<div class="fe-submitbar">
		<button type="submit" class="fe-btn fe-btn-primary"><i class="bi bi-send"></i> {$LNG.fl_continue}</button>
	</div>
</form>
</div>
<script type="text/javascript">
data	= {$fleetdata|json};
</script>
{/block}
