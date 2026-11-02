{block name="title" prepend}{$LNG.lm_options}{/block}
{block name="content"}
<form action="game.php?page=settings" method="post" class="fe-build fe-settings">
	<input type="hidden" name="mode" value="send">

	<header class="fe-toolbar">
		<div class="fe-toolbar-title"><h2><i class="bi bi-gear"></i> {$LNG.lm_options}</h2></div>
	</header>

	{if $userAuthlevel > 0}
	<h3 class="fe-section-title">{$LNG.op_admin_title_options}</h3>
	<section class="fe-panel">
		{include file="fe.settings.toggle.tpl" name="adminprotection" label=$LNG.op_admin_planets_protection checked=($adminProtection > 0)}
	</section>
	{/if}

	{if $isMultiUniverse}
	<h3 class="fe-section-title">{$LNG.multiUniverse}</h3>
	<section class="fe-panel">
		<p class="fe-hint">{$newUniMsg}</p>
		<p class="fe-hint">{$LNG.multiUniverseDescription}</p>
		<div class="fe-chips">
		{foreach $availableUniverses as $universeID => $universeName}
			<a href="game.php?page=settings&amp;startinuni={$universeID}" class="fe-chip">{$LNG.startInMultiUniverse} {$universeName}</a>
		{/foreach}
		</div>
	</section>
	{/if}

	<h3 class="fe-section-title">{$LNG.op_user_data}</h3>
	<section class="fe-panel fe-form">
		<label><span>{$LNG.op_username}</span>
			{if $changeNickTime < 0}<input name="username" value="{$username}" type="text" autocomplete="username">{else}<b>{$username}</b>{/if}
		</label>
		<label><span>{$LNG.op_email_adress}<small>{$LNG.op_email_adress_descrip}</small></span><input name="email" maxlength="64" value="{$email}" type="email" autocomplete="email"></label>
		<label><span>{$LNG.op_permanent_email_adress}</span><b>{$permaEmail}</b></label>
		<label><span>{$LNG.op_old_pass}</span><input name="password" type="password" autocomplete="current-password"></label>
		<label><span>{$LNG.op_new_pass}</span><input name="newpassword" maxlength="40" type="password" autocomplete="new-password"></label>
		<label><span>{$LNG.op_repeat_new_pass}</span><input name="newpassword2" maxlength="40" type="password" autocomplete="new-password"></label>
	</section>

	<h3 class="fe-section-title">{$LNG.op_general_settings}</h3>
	<section class="fe-panel fe-form">
		<label><span>{$LNG.op_timezone}</span>{html_options name=timezone options=$Selectors.timezones selected=$timezone}</label>
		<label><span>{$LNG.op_sort_planets_by}</span>{html_options name=planetSort options=$Selectors.Sort selected=$planetSort}</label>
		<label><span>{$LNG.op_sort_kind}</span>{html_options name=planetOrder options=$Selectors.SortUpDown selected=$planetOrder}</label>
		{if $let_users_change_theme}
		<label><span>{$LNG.op_skin_example}</span>
			<select name="user_theme">
				<option {if $theme == 'nextgen'}selected{/if} value="nextgen">NextGen</option>
				<option {if $theme == 'nova'}selected{/if} value="nova">Nova</option>
				<option {if $theme == 'gow'}selected{/if} value="gow">Galaxy of Wars</option>
				<option {if $theme == 'EpicBlueXIII'}selected{/if} value="EpicBlueXIII">Epic Blue</option>
				<option {if $theme == 'office'}selected{/if} value="office">Office</option>
			</select>
		</label>
		{/if}
		{include file="fe.settings.toggle.tpl" name="queueMessages" label=$LNG.op_active_build_messages checked=($queueMessages == 1)}
		{include file="fe.settings.toggle.tpl" name="spyMessagesMode" label=$LNG.op_active_spy_messages_mode checked=($spyMessagesMode == 1)}
		{include file="fe.settings.toggle.tpl" name="blockPM" label=$LNG.op_block_pm checked=($blockPM == 1)}
	</section>

	<h3 class="fe-section-title">{$LNG.op_background_image}</h3>
	<section class="fe-panel">
		<div class="settings_bg_img-container tm-grid-expand uk-grid-column-small uk-grid">
				<div class="settings_bg_img_select uk-width-1-4@m">
					<label for="mars">
						<input id="mars" type="radio" name="user_background_image" value="mars" {if $bg_img == 'mars'}checked{/if}>
						<img src="styles/theme/nextgen/img/background/mars.webp" alt="Orange Mars">
					</label>
				</div>

				<div class="settings_bg_img_select uk-width-1-4@m">
					<label for="light_green">
						<input id="light_green" type="radio" name="user_background_image" value="light_green" {if $bg_img == 'light_green'}checked{/if}>
						<img src="styles/theme/nextgen/img/background/light_green.webp" alt="Green Canyon">
					</label>
				</div>

				<div class="settings_bg_img_select uk-width-1-4@m">
					<label for="intense_blue">
						<input id="intense_blue" type="radio" name="user_background_image" value="intense_blue" {if $bg_img == 'intense_blue'}checked{/if}>
						<img src="styles/theme/nextgen/img/background/intense_blue.webp" alt="Blue Nightsky">
					</label>
				</div>

				<div class="settings_bg_img_select uk-width-1-4@m">
					<label for="dark_blue">
						<input id="dark_blue" type="radio" name="user_background_image" value="dark_blue" {if $bg_img == 'dark_blue'}checked{/if}>
						<img src="styles/theme/nextgen/img/background/dark_blue.webp" alt="Dark Horizon">
					</label>
				</div>

				<div class="settings_bg_img_select uk-width-1-4@m">
					<label for="mountains">
						<input id="mountains" type="radio" name="user_background_image" value="mountains" {if $bg_img == 'mountains'}checked{/if}>
						<img src="styles/theme/nextgen/img/background/mountains.webp" alt="Foggy Mountains">
					</label>
				</div>

				<div class="settings_bg_img_select uk-width-1-4@m">
					<label for="orbit">
						<input id="orbit" type="radio" name="user_background_image" value="orbit" {if $bg_img == 'orbit'}checked{/if}>
						<img src="styles/theme/nextgen/img/background/orbit.webp" alt="Orbit">
					</label>
				</div>

				<div class="settings_bg_img_select uk-width-1-4@m">
					<label for="supernova">
						<input id="supernova" type="radio" name="user_background_image" value="supernova" {if $bg_img == 'supernova'}checked{/if}>
						<img src="styles/theme/nextgen/img/background/supernova.webp" alt="Supernova">
					</label>
				</div>

				<div class="settings_bg_img_select uk-width-1-4@m">
					<label for="spaceport">
						<input id="spaceport" type="radio" name="user_background_image" value="spaceport" {if $bg_img == 'spaceport'}checked{/if}>
						<img src="styles/theme/nextgen/img/background/spaceport.webp" alt="Spaceport">
					</label>
				</div>
			</div>
	</section>

	<h3 class="fe-section-title">{$LNG.op_galaxy_settings}</h3>
	<section class="fe-panel fe-form">
		<label><span>{$LNG.op_spy_probes_number}<small>{$LNG.op_spy_probes_number_descrip}</small></span><input name="spycount" value="{$spycount}" type="number" min="1" inputmode="numeric"></label>
		<label><span>{$LNG.op_max_fleets_messages}</span><input name="fleetactions" maxlength="2" value="{$fleetActions}" type="number" min="1" inputmode="numeric"></label>
		{include file="fe.settings.toggle.tpl" name="galaxySpy" label=$LNG.op_spy checked=($galaxySpy == 1)}
		{include file="fe.settings.toggle.tpl" name="galaxyMessage" label=$LNG.op_write_message checked=($galaxyMessage == 1)}
		{include file="fe.settings.toggle.tpl" name="galaxyBuddyList" label=$LNG.op_add_to_buddy_list checked=($galaxyBuddyList == 1)}
		{include file="fe.settings.toggle.tpl" name="galaxyMissle" label=$LNG.op_missile_attack checked=($galaxyMissle == 1)}
	</section>

	<h3 class="fe-section-title">{$LNG.op_vacation_delete_mode}</h3>
	<section class="fe-panel fe-danger">
		{include file="fe.settings.toggle.tpl" name="vacation" label=$LNG.op_activate_vacation_mode hint=$LNG.op_activate_vacation_mode_descrip checked=false}
		{include file="fe.settings.toggle.tpl" name="delete" label=$LNG.op_dlte_account hint=$LNG.op_dlte_account_descrip checked=($delete > 0)}
	</section>

	{if isModuleAvailable($smarty.const.MODULE_BANNER)}
	<h3 class="fe-section-title">{$LNG.ov_userbanner}</h3>
	<section class="fe-panel fe-form">
		<img class="fe-banner" src="userpic.php?id={$userid}" alt="" id="userpic">
		<label><span>HTML</span><input type="text" readonly value='<a href="{$SELF_URL}{if $ref_active}index.php?ref={$userid}{/if}"><img src="{$SELF_URL}userpic.php?id={$userid}"></a>'></label>
		<label><span>BBCode</span><input type="text" readonly value="[url={$SELF_URL}{if $ref_active}index.php?ref={$userid}{/if}][img]{$SELF_URL}userpic.php?id={$userid}[/img][/url]"></label>
	</section>
	{/if}

	<div class="fe-submitbar">
		<button type="submit" class="fe-btn fe-btn-primary"><i class="bi bi-check2"></i> {$LNG.op_save_changes}</button>
	</div>
</form>
{/block}
