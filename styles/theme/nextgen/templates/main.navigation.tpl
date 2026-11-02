<div class="dark-blur-bg box-border box-shadow-large main-menu-container" id="main-menu-container">
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
  <div class="toggle-menu-button-container">
    <button type="button" class="toggle-menu-button dark-blur-bg" aria-label="Menu" onclick="toggleMainMenu()">
      <span class="toggle-menu-button-icon"><img src="styles/theme/nextgen/img/menu-button.svg" alt=""></span>
    </button>
  </div>
  <script>
    (function () {
      var nav = document.getElementById('main-navigation');
      var stored = null;
      try { stored = sessionStorage.getItem('menuHidden'); } catch (e) {}
      if (stored === 'true' || (stored === null && window.innerWidth < 960)) {
        nav.classList.add('main-menu-hidden');
      }
      if (window.innerWidth < 960) {
        var active = nav.querySelector('.menuActive');
        var strip = nav.querySelector('.main-menu');
        if (active && strip) {
          var item = active.parentNode;
          strip.scrollLeft = item.offsetLeft - (strip.clientWidth - item.offsetWidth) / 2;
        }
      }
      window.toggleMainMenu = function () {
        var hidden = nav.classList.toggle('main-menu-hidden');
        try { sessionStorage.setItem('menuHidden', hidden); } catch (e) {}
      };
    })();
  </script>
</div>
