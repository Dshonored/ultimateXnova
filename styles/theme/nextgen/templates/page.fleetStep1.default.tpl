{block name="title" prepend}{$LNG.lm_fleet}{/block}
{block name="content"}
<div class="fe-build fe-fleet">
{include file="fe.fleet.steps.tpl" step=2}
<form action="game.php?page=fleetStep2" method="post" onsubmit="return CheckTarget()" id="form">
	<input type="hidden" name="token" value="{$token}">
	<input type="hidden" name="fleet_group" value="0">
	<input type="hidden" name="target_mission" value="{$mission}">

	<section class="fe-panel">
		<div class="fe-target">
			<label><span>{$LNG.fe_fl_galaxy}</span><input type="text" inputmode="numeric" id="galaxy" name="galaxy" maxlength="2" onkeyup="updateVars()" value="{$galaxy}"></label>
			<label><span>{$LNG.fe_fl_system}</span><input type="text" inputmode="numeric" id="system" name="system" maxlength="3" onkeyup="updateVars()" value="{$system}"></label>
			<label><span>{$LNG.fe_fl_planet}</span><input type="text" inputmode="numeric" id="planet" name="planet" maxlength="2" onkeyup="updateVars()" value="{$planet}"></label>
			<label class="fe-target-wide"><span>{$LNG.fe_fl_type}</span><select id="type" name="type" onchange="updateVars()">{html_options options=$typeSelect selected=$type}</select></label>
			<label class="fe-target-wide"><span>{$LNG.fl_fleet_speed} (%)</span><select id="speed" name="speed" onChange="updateVars(false)">{html_options options=$speedSelect}</select></label>
		</div>
		<dl class="fe-facts">
			<div><dt>{$LNG.fl_distance}</dt><dd id="distance">-</dd></div>
			<div><dt>{$LNG.fl_flying_time}</dt><dd id="duration">-</dd></div>
			<div><dt>{$LNG.fl_flying_arrival}</dt><dd id="arrival">-</dd></div>
			<div><dt>{$LNG.fl_flying_return}</dt><dd id="return">-</dd></div>
			<div><dt>{$LNG.fl_fuel_consumption}</dt><dd id="consumption">-</dd></div>
			<div><dt>{$LNG.fl_max_speed}</dt><dd id="maxspeed">-</dd></div>
			<div><dt>{$LNG.fl_cargo_capacity}</dt><dd id="storage">-</dd></div>
		</dl>
	</section>

	<h3 class="fe-section-title">{$LNG.fe_fl_quick}</h3>
	<div class="fe-chips">
		<a class="fe-chip" href="javascript:setTarget({$galaxy},{$system},16,1);updateVars();"><i class="bi bi-compass"></i> {$LNG.type_mission_15} [{$galaxy}:{$system}:16]</a>
		<a class="fe-chip" href="javascript:setTarget({$galaxy},{$system},17,1);updateVars();"><i class="bi bi-shop"></i> {$LNG.type_mission_16} [{$galaxy}:{$system}:17]</a>
		{foreach $colonyList as $ColonyRow}
		<a class="fe-chip" href="javascript:setTarget({$ColonyRow.galaxy},{$ColonyRow.system},{$ColonyRow.planet},{$ColonyRow.type});updateVars();"><i class="bi bi-{if $ColonyRow.type == 3}moon{else}globe2{/if}"></i> {$ColonyRow.name}{if $ColonyRow.type == 3}{$LNG.fl_moon_shortcut}{/if} [{$ColonyRow.galaxy}:{$ColonyRow.system}:{$ColonyRow.planet}]</a>
		{/foreach}
		{if $ACSList}
		{foreach $ACSList as $ACSRow}
		<a class="fe-chip" href="javascript:setACSTarget({$ACSRow.galaxy},{$ACSRow.system},{$ACSRow.planet},{$ACSRow.planet_type},{$ACSRow.id});"><i class="bi bi-people"></i> {$ACSRow.name} [{$ACSRow.galaxy}:{$ACSRow.system}:{$ACSRow.planet}]</a>
		{/foreach}
		{/if}
	</div>

	{if isModuleAvailable($smarty.const.MODULE_SHORTCUTS)}
	<table class="table table-gow table-sm fs-12">
		<tr style="height:20px;">
			<th class="text-center" colspan="{$themeSettings.SHORTCUT_ROWS_ON_FLEET1}">{$LNG.fl_shortcut} (<a href="#" onclick="EditShortcuts();return false" class="shortcut-link-edit shortcut-link">{$LNG.fl_shortcut_edition}</a><a href="#" onclick="SaveShortcuts();return false" class="shortcut-edit">{$LNG.fl_shortcut_save}</a>)</th>
		</tr>

		{foreach $shortcutList as $shortcutID => $shortcutRow}
			{if ($shortcutRow@iteration % $themeSettings.SHORTCUT_ROWS_ON_FLEET1) === 1}<tr style="height:20px;" class="shortcut-row">{/if}
			<td style="width:{100 / $themeSettings.SHORTCUT_ROWS_ON_FLEET1}%" class="shortcut-colum shortcut-isset">
				<div class="shortcut-link">
					<a href="javascript:setTarget({$shortcutRow.galaxy},{$shortcutRow.system},{$shortcutRow.planet},{$shortcutRow.type});updateVars();">{$shortcutRow.name}{if $shortcutRow.type == 1}{$LNG.fl_planet_shortcut}{elseif $shortcutRow.type == 2}{$LNG.fl_debris_shortcut}{elseif $shortcutRow.type == 3}{$LNG.fl_moon_shortcut}{/if} [{$shortcutRow.galaxy}:{$shortcutRow.system}:{$shortcutRow.planet}]</a>
				</div>
				<div class="shortcut-edit">
					<input type="text" class="shortcut-input" name="shortcut[{$shortcutID}][name]" value="{$shortcutRow.name}">
					<div class="shortcut-delete" title="{$LNG.fl_dlte_shortcut}">x</div>
				</div>
				<div class="shortcut-edit">
					<input type="text" class="shortcut-input" name="shortcut[{$shortcutID}][galaxy]" value="{$shortcutRow.galaxy}" size="3" maxlength="2">:<input type="text" class="shortcut-input" name="shortcut[{$shortcutID}][system]" value="{$shortcutRow.system}" size="3" maxlength="3">:<input type="text" class="shortcut-input" name="shortcut[{$shortcutID}][planet]" value="{$shortcutRow.planet}" size="3" maxlength="2">
					<select class="shortcut-input" name="shortcut[{$shortcutID}][type]">
						{html_options selected=$shortcutRow.type options=$typeSelect}
					</select>
				</div>
			</td>
			{if $shortcutRow@last && ($shortcutRow@iteration % $themeSettings.SHORTCUT_ROWS_ON_FLEET1) !== 0}
			{$to = $themeSettings.SHORTCUT_ROWS_ON_FLEET1 - ($shortcutRow@iteration % $themeSettings.SHORTCUT_ROWS_ON_FLEET1)}
			{for $foo=1 to $to}
			<td class="shortcut-colum" style="width:{100 / $themeSettings.SHORTCUT_ROWS_ON_FLEET1}%">&nbsp;</td>
			{/for}
			{/if}
			{if ($shortcutRow@iteration % $themeSettings.SHORTCUT_ROWS_ON_FLEET1) === 0}</tr>{/if}
		{foreachelse}
		<tr style="height:20px;" class="shortcut-none">
			<td colspan="{$themeSettings.SHORTCUT_ROWS_ON_FLEET1}">{$LNG.fl_no_shortcuts}</td>
		</tr>
		{/foreach}
		<tr style="height:20px;" class="shortcut-edit shortcut-new">
			<td>
				<div class="shortcut-link">

				</div>
				<div class="shortcut-edit">
					<input type="text" class="shortcut-input" name="shortcut[][name]" placeholder="{$LNG.fl_shortcut_name}">
					<div class="shortcut-delete" title="{$LNG.fl_dlte_shortcut}">x</div>
				</div>
				<div class="shortcut-edit">
					<input type="text" class="shortcut-input" name="shortcut[][galaxy]" value="" size="3" maxlength="2" placeholder="G" pattern="[0-9]*">:<input type="text" class="shortcut-input" name="shortcut[][system]" value="" size="3" maxlength="3" placeholder="S" pattern="[0-9]*">:<input type="text" class="shortcut-input" name="shortcut[][planet]" value="" size="3" maxlength="2" placeholder="P" pattern="[0-9]*">
					<select class="shortcut-input" name="shortcut[][type]">
						{html_options options=$typeSelect}
					</select>
				</div>
			</td>
		</tr>
		<tr style="height:20px;" class="shortcut-edit">
			<td colspan="{$themeSettings.SHORTCUT_ROWS_ON_FLEET1}">
				<a href="#" onclick="AddShortcuts();return false">{$LNG.fl_shortcut_add}</a>
			</td>
		</tr>
	</table>
	{/if}

	<div class="fe-submitbar">
		<button type="submit" class="fe-btn fe-btn-primary">{$LNG.fl_continue} <i class="bi bi-arrow-right"></i></button>
	</div>
</form>
</div>
<script type="text/javascript">
data			= {$fleetdata|json};
shortCutRows	= {$themeSettings.SHORTCUT_ROWS_ON_FLEET1};
fl_no_shortcuts	= '{$LNG.fl_no_shortcuts}';
</script>
{/block}
