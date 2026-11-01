<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="{$lang}" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="{$lang}" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="{$lang}" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="{$lang}" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="{$lang}" class="no-js"> <!--<![endif]-->
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	{assign var="REV" value="1.0.0.8" nocache}

	<!-- Bootstrap 5 - No IE support -->
	<link href="styles/resource/vendor/bootstrap/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC">
	<script src="styles/resource/vendor/popper/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p"></script>
	<script src="styles/resource/vendor/bootstrap/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF"></script>
	<link rel="stylesheet" href="styles/resource/vendor/bootstrap-icons/bootstrap-icons.css">


	<!-- NG Fonts -->
	<link rel="stylesheet" href="styles/theme/nextgen/css/fonts.css">
	<!-- NG Libraries -->
	<link rel="stylesheet" href="styles/theme/nextgen/css/uikit.min.css">
	<link rel="stylesheet" href="styles/theme/nextgen/css/uikit-rtl.min.css">
	<script src="styles/theme/nextgen/js/uikit.min.css"></script>
	<script src="styles/theme/nextgen/js/uikit-icons.min.css"></script>
	<!-- NG CSS -->
	<link rel="stylesheet" href="styles/theme/nextgen/css/login.css">
	<link rel="stylesheet" href="styles/theme/nextgen/css/style.css">
	<!-- Favicons  -->
	<link rel="shortcut icon" href="/styles/resource/favicon/favicon.ico" type="image/x-icon">
	<link rel="apple-touch-icon" sizes="180x180" href="/styles/resource/favicon/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/styles/resource/favicon/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/styles/resource/favicon/favicon-16x16.png">
	<link rel="manifest" href="/styles/resource/favicon/site.webmanifest">
	
	<!-- Meta  -->
	<title>{$gameName}</title>
	<meta name="keywords" content="{$gameName}, UltimateXnova, SteemNova, Steem, Browsergame, MMOSG, MMOG, Strategy, XNova, 2Moons, Space">
	<meta name="description" content="Massive Multiplayer Online Strategy Game (MMOSG). Space Browsergame with competition between Alliances. Free-to-play.">
	<!-- open graph protocol -->
	<meta property="og:title" content="{$gameName}">
	<meta property="og:type" content="website">
	<meta property="og:description" content="Massive Multiplayer Online Strategy Game (MMOSG). Space Browsergame with competition between Alliances. Free-to-play.">
	<meta property="og:image" content="styles/resource/images/meta.png">
	<!--[if lt IE 9]>
	<script src="scripts/base/html5.js"></script>
	<![endif]-->
	<script src="scripts/base/jquery.js?v={$REV}"></script>
	<script src="scripts/base/jquery.cookie.js?v={$REV}"></script>
	<script src="scripts/base/jquery.fancybox.js?v={$REV}"></script>
	<script src="scripts/login/main.js"></script>
	<script src="scripts/base/lang-pref.js?v=1"></script>
	<script>{if isset($code)}var loginError = {$code|json};{/if}</script>
	{block name="script"}{/block}
</head>
<body id="{if isset($smarty.get.page)}{$smarty.get.page|htmlspecialchars|default:'overview'}{/if}" class="{$bodyclass} login">
	<div class="login-background">
		<div class="bg-1"></div>
		<div class="bg-2"></div>
		<div class="bg-3"></div>
	</div>
	<div id="page">
