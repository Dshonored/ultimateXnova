<div class="fe-drawer-backdrop" data-menu-close></div>
<div class="dark-blur-bg box-border box-shadow-large main-menu-container" id="main-menu-container">
  <div class="fe-drawer-head">
    <strong>{$LNG.fe_menu}</strong>
    <button type="button" class="fe-drawer-close" data-menu-close aria-label="{$LNG.fe_close}"><i class="bi bi-x-lg"></i></button>
  </div>
  {if $AllPlanets}
  <div class="fe-drawer-more">
    <span class="fe-drawer-title">{$LNG.fe_planets}</span>
    <ul class="fe-planets">
      {foreach $AllPlanets as $PlanetRow}
      <li>
        <a class="fe-planet {if $PlanetRow.selected}is-current{/if}" href="game.php?page={$page}&amp;cp={$PlanetRow.id}">
          <img src="{$dpath}planeten/{$PlanetRow.image}.jpg" alt="" width="40" height="40" loading="lazy">
          <span><strong>{$PlanetRow.name}</strong><small>[{$PlanetRow.galaxy}:{$PlanetRow.system}:{$PlanetRow.planet}]</small></span>
          {if $PlanetRow.selected}<i class="bi bi-check-lg"></i>{/if}
        </a>
        {if isset($PlanetRow.moonInfo)}
        {foreach $PlanetRow.moonInfo as $MoonRow}
        <a class="fe-planet fe-moon {if $MoonRow.selected}is-current{/if}" href="game.php?page={$page}&amp;cp={$MoonRow.id}">
          <img src="{$dpath}planeten/{$MoonRow.image}_small.webp" alt="" width="28" height="28" loading="lazy">
          <span><strong>{$MoonRow.name}</strong></span>
          {if $MoonRow.selected}<i class="bi bi-check-lg"></i>{/if}
        </a>
        {/foreach}
        {/if}
      </li>
      {/foreach}
    </ul>
    {if $hasMultiUniverseAccounts}
    <ul class="main-menu">
      {foreach $mu_unis as $universe_id => $universe_name}
      <li><a href="game.php?page=overview&amp;switch_universe={$universe_id}"><i class="bi bi-globe2"></i><span>{$universe_name}</span></a></li>
      {/foreach}
    </ul>
    {/if}
  </div>
  {/if}
  <div class="fe-drawer-more fe-drawer-title-only"><span class="fe-drawer-title">{$LNG.fe_game}</span></div>
  <ul class="main-menu">
      <li>
        <a class="{if $page == 'overview'}menuActive{/if}" href="game.php?page=overview"><i class="bi bi-house-door"></i><span>{$LNG.lm_overview}</span></a>
      </li>
      {if isModuleAvailable($smarty.const.MODULE_BUILDING)}
      <li>
        <a class="{if $page == 'buildings'}menuActive{/if}" href="game.php?page=buildings"><i class="bi bi-building"></i><span>{$LNG.lm_buildings}</span></a>
      </li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_SHIPYARD_FLEET)}
      <li>
        <a class="{if $page == 'shipyard' && $mode == 'fleet'}menuActive{/if}" href="game.php?page=shipyard&amp;mode=fleet"><i class="bi bi-rocket-takeoff"></i><span>{$LNG.lm_shipshard}</span></a>
      </li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_SHIPYARD_DEFENSIVE)}
      <li>
        <a class="{if $page == 'shipyard' && $mode == 'defense'}menuActive{/if}" href="game.php?page=shipyard&amp;mode=defense"><i class="bi bi-shield-shaded"></i><span>{$LNG.lm_defenses}</span></a>
      </li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_RESEARCH)}
      <li>
        <a class="{if $page == 'research'}menuActive{/if}" href="game.php?page=research"><i class="bi bi-lightbulb"></i><span>{$LNG.lm_research}</span></a>
      </li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_TRADER)}
      <li>
        <a class="{if $page == 'fleetTable' || $page == 'fleetStep1' || $page == 'fleetStep2'}menuActive{/if}" href="game.php?page=fleetTable"><i class="bi bi-send"></i><span>{$LNG.lm_fleet}</span></a>
      </li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_GALAXY)}
      <li>
        <a class="{if $page == 'galaxy'}menuActive{/if}" href="game.php?page=galaxy"><i class="bi bi-stars"></i><span>{$LNG.lm_galaxy}</span></a>
      </li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_IMPERIUM)}
      <li>
        <a class="{if $page == 'imperium'}menuActive{/if}" href="game.php?page=imperium"><i class="bi bi-grid-3x3-gap"></i><span>{$LNG.lm_empire}</span></a>
      </li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_TECHTREE)}
      <li>
        <a class="{if $page == 'techtree'}menuActive{/if}" href="game.php?page=techtree"><i class="bi bi-diagram-3"></i><span>{$LNG.lm_technology}</span></a>
      </li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_RESSOURCE_LIST)}
      <li>
        <a class="{if $page == 'resources'}menuActive{/if}" href="game.php?page=resources"><i class="bi bi-box-seam"></i><span>{$LNG.lm_resources}</span></a>
      </li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_OFFICIER) || isModuleAvailable($smarty.const.MODULE_DMEXTRAS)}
      <li>
        <a class="{if $page == 'officier'}menuActive{/if}" href="game.php?page=officier"><i class="bi bi-person-badge"></i><span>{$LNG.lm_officiers}</span></a>
      </li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_TRADER)}
      <li>
        <a class="{if $page == 'trader'}menuActive{/if}" href="game.php?page=trader"><i class="bi bi-arrow-left-right"></i><span>{$LNG.lm_trader}</span></a>
      </li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_FLEET_TRADER)}
      <li>
        <a class="{if $page == 'fleetDealer'}menuActive{/if}" href="game.php?page=fleetDealer"><i class="bi bi-cart3"></i><span>{$LNG.lm_fleettrader}</span></a>
      </li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_ALLIANCE)}
      <li>
        <a class="{if $page == 'alliance'}menuActive{/if}" href="game.php?page=alliance"><i class="bi bi-flag"></i><span>{$LNG.lm_alliance}</span></a>
      </li>
      {/if}
      {if $authlevel > 0}
      <li>
        <a class="blur-bg-danger" href="./admin.php"><i class="bi bi-shield-lock"></i><span>{$LNG.lm_administration}</span></a>
      </li>
      {/if}
  </ul>
  <div class="fe-drawer-more">
    <span class="fe-drawer-title">{$LNG.fe_account}</span>
    <ul class="main-menu">
      {if isModuleAvailable($smarty.const.MODULE_MESSAGES)}
      <li><a class="{if $page == 'messages'}menuActive{/if}" href="game.php?page=messages"><i class="bi bi-envelope"></i><span>{$LNG.lm_messages}</span>{nocache}{if $new_message > 0}<b class="fe-menu-badge">{$new_message}</b>{/if}{/nocache}</a></li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_BUDDYLIST)}
      <li><a class="{if $page == 'buddyList'}menuActive{/if}" href="game.php?page=buddyList"><i class="bi bi-people"></i><span>{$LNG.lm_buddylist}</span></a></li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_NOTICE)}
      <li><a href="javascript:OpenPopup('?page=notes', 'notes', 720, 300);"><i class="bi bi-journal-check"></i><span>{$LNG.lm_notes}</span></a></li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_STATISTICS)}
      <li><a class="{if $page == 'statistics'}menuActive{/if}" href="game.php?page=statistics"><i class="bi bi-graph-up-arrow"></i><span>{$LNG.lm_statistics}</span></a></li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_SEARCH)}
      <li><a class="{if $page == 'search'}menuActive{/if}" href="game.php?page=search"><i class="bi bi-search"></i><span>{$LNG.lm_search}</span></a></li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_SUPPORT)}
      <li><a class="{if $page == 'ticket'}menuActive{/if}" href="game.php?page=ticket"><i class="bi bi-info-circle"></i><span>{$LNG.lm_support}</span></a></li>
      {/if}
      <li><a class="{if $page == 'settings'}menuActive{/if}" href="game.php?page=settings"><i class="bi bi-gear"></i><span>{$LNG.lm_options}</span></a></li>
    </ul>
  </div>
  <div class="fe-drawer-more">
    <span class="fe-drawer-title">{$LNG.fe_more}</span>
    <ul class="main-menu">
      {if isModuleAvailable($smarty.const.MODULE_RECORDS)}
      <li><a href="game.php?page=records"><i class="bi bi-award"></i><span>{$LNG.lm_records}</span></a></li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_BATTLEHALL)}
      <li><a href="game.php?page=battleHall"><i class="bi bi-trophy"></i><span>{$LNG.lm_topkb}</span></a></li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_SIMULATOR)}
      <li><a href="game.php?page=battleSimulator"><i class="bi bi-calculator"></i><span>{$LNG.lm_battlesim}</span></a></li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_CHAT)}
      <li><a href="game.php?page=chat"><i class="bi bi-chat-dots"></i><span>{$LNG.lm_chat}</span></a></li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_FORUM) && !empty($hasBoard)}
      <li><a href="game.php?page=board" target="forum"><i class="bi bi-chat-square-text"></i><span>{$LNG.lm_forums}</span></a></li>
      {/if}
      {if isModuleAvailable($smarty.const.MODULE_BANLIST)}
      <li><a href="game.php?page=banList"><i class="bi bi-slash-circle"></i><span>{$LNG.lm_banned}</span></a></li>
      {/if}
      <li><a href="index.php?page=rules" target="rules"><i class="bi bi-book"></i><span>{$LNG.lm_rules}</span></a></li>
    </ul>
    {if isModuleAvailable($smarty.const.MODULE_SERVER_INFO)}
    <dl class="fe-drawer-info">
      <div><dt>{$LNG.si_game_speed}</dt><dd>{$game_speed}</dd></div>
      <div><dt>{$LNG.si_fleet_speed}</dt><dd>{$fleet_speed}</dd></div>
      <div><dt>{$LNG.si_production_speed}</dt><dd>{$production_speed}</dd></div>
      <div><dt>{$LNG.si_storage_multiplier}</dt><dd>{$storage_multiplier}</dd></div>
    </dl>
    {/if}
  </div>
  <div class="fe-drawer-more">
    {if count($languages) > 1}
    <span class="fe-drawer-title">{$LNG.fe_language}</span>
    <div class="fe-langs">
      {foreach $languages as $langKey => $langName}
      <a class="fe-lang {if $langKey == $lang}is-current{/if}" href="#" data-set-lang="{$langKey}" hreflang="{$langKey}"><img src="styles/theme/nextgen/img/lang/{$langKey}.svg" alt="" width="22"><span>{$langName}</span></a>
      {/foreach}
    </div>
    {/if}
    <ul class="main-menu fe-menu-logout">
      <li><a href="game.php?page=logout"><i class="bi bi-box-arrow-right"></i><span>{$LNG.lm_logout}</span></a></li>
    </ul>
  </div>
  <div class="toggle-menu-button-container">
    <button type="button" class="toggle-menu-button dark-blur-bg" aria-label="Menu" onclick="toggleMainMenu()">
      <span class="toggle-menu-button-icon"><img src="styles/theme/nextgen/img/menu-button.svg" alt=""></span>
    </button>
  </div>
  <script>
    (function () {
      var nav = document.getElementById('main-navigation');
      var phone = window.matchMedia('(max-width: 959px)');

      // Desktop: the collapse arrow, remembered for the session
      var stored = null;
      try { stored = sessionStorage.getItem('menuHidden'); } catch (e) {}
      if (stored === 'true' && !phone.matches) {
        nav.classList.add('main-menu-hidden');
      }
      window.toggleMainMenu = function () {
        var hidden = nav.classList.toggle('main-menu-hidden');
        try { sessionStorage.setItem('menuHidden', hidden); } catch (e) {}
      };

      // Phone / tablet: full menu behind the hamburger
      var panel = document.getElementById('main-menu-container');
      var burger = document.getElementById('fe-burger');
      if (!burger) return;

      function setOpen(open, restoreFocus) {
        nav.classList.toggle('is-open', open);
        document.documentElement.classList.toggle('fe-menu-open', open);
        burger.setAttribute('aria-expanded', open ? 'true' : 'false');
        if (open) {
          panel.scrollTop = 0;
          panel.querySelector('.fe-drawer-close').focus();
        } else if (restoreFocus) {
          burger.focus();
        }
      }
      burger.addEventListener('click', function () { setOpen(!nav.classList.contains('is-open'), false); });
      nav.addEventListener('click', function (event) {
        if (event.target.closest('[data-menu-close]')) setOpen(false, true);
      });
      document.addEventListener('keydown', function (event) {
        if (!nav.classList.contains('is-open')) return;
        if (event.key === 'Escape') { setOpen(false, true); return; }
        if (event.key !== 'Tab') return;
        // keep keyboard focus inside the open menu
        var items = panel.querySelectorAll('a[href], button:not(.toggle-menu-button)');
        var first = items[0], last = items[items.length - 1];
        if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
        else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
      });
      phone.addEventListener('change', function (event) { if (!event.matches) setOpen(false, false); });
      // coming back with the browser's back button must not show it still open
      window.addEventListener('pageshow', function () { setOpen(false, false); });
    })();
  </script>
</div>
