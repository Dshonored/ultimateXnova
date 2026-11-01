<header>
	<div class="dark-blur-bg menu-container box-shadow-large">
		<div class="uk-container">
		<nav id="navbar" class="uk-navbar">
			<div class="uk-navbar-left"><a href="index.php"><img class="logo" src="styles/resource/images/ultimatexnova.svg" alt="{$gameName}"/></a></div>
			<div class="uk-navbar-right">
				<ul class="uk-navbar-nav d-none d-md-flex">
					<li class="menu-item">
						<a class="uk-preserve-width {if $page == 'index' || $page == ''}uk-active{/if}" href="index.php?page=index">{$LNG.siteTitleIndex}</a>
					</li>
					<li class="menu-item">
						<a class="uk-preserve-width {if $page == 'register'}uk-active{/if}" href="index.php?page=register">{$LNG.siteTitleRegister}</a>
					</li>
					<li class="menu-item">
						<a class="uk-preserve-width {if $page == 'rules'}uk-active{/if}" href="index.php?page=rules">{$LNG.siteTitleRules}</a>
					</li>
				</ul>

				<i class="bi bi-list d-flex d-md-none px-3 text-white fs-2 menu_icon" data-bs-toggle="offcanvas" data-bs-target="#phoneMenu"></i>

				{if count($languages) > 1}
				<div class="dropdown">
					<button style="height:32px;" class="btn btn-secondary dropdown-toggle px-2 menu-item d-flex align-items-center gap-2" type="button" id="langMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
						<img src="styles/theme/nextgen/img/lang/{$lang}.svg" class="lang-flag" alt=""> {$LNG.languageSelect}
					</button>
					<ul class="dropdown-menu dropdown-menu-end flex-column bg-dark p-0" aria-labelledby="langMenuButton">
						{foreach $languages as $langKey => $langName}
						<li class="d-flex w-100">
							<a class="text-decoration-none hover-bg-color-grey menu-item w-100 px-2 {if $langKey == $lang}fw-bold{/if}" href="#" data-set-lang="{$langKey}" hreflang="{$langKey}">
								<img src="styles/theme/nextgen/img/lang/{$langKey}.svg" class="lang-flag" alt="">
								<span>{$langName}</span>
							</a>
						</li>
						{/foreach}
					</ul>
				</div>
				{/if}
			</div>
		</nav>
		</div>
	</div>

	<div class="offcanvas offcanvas-start dark-blur-bg box-shadow" id="phoneMenu">
		<div class="offcanvas-header">
			<span class="offcanvas-title fs-2">{$gameName}</span>
			<button type="button" class="btn-close btn-close-white" aria-label="Close" data-bs-dismiss="offcanvas"></button>
		</div>
		<div class="offcanvas-body p-0">
			<ul style="list-style:none;" class="main-menu p-0 m-0">
				<li class="menu-item"><a class="fs-6 w-100 text-decoration-none py-2 {if $page == 'index'}active{/if}" href="index.php?page=index">{$LNG.siteTitleIndex}</a></li>
				<li class="menu-item"><a class="fs-6 w-100 text-decoration-none py-2 {if $page == 'register'}active{/if}" href="index.php?page=register">{$LNG.siteTitleRegister}</a></li>
				<li class="menu-item"><a class="fs-6 w-100 text-decoration-none py-2 {if $page == 'rules'}active{/if}" href="index.php?page=rules">{$LNG.siteTitleRules}</a></li>
			</ul>
		</div>
	</div>
</header>
