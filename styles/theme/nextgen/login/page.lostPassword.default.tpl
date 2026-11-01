{block name="title" prepend}{$LNG.siteTitleLostPassword}{/block}
{block name="content"}
<div class="login-stage">
	<div class="login-card dark-blur-bg box-shadow-large">
		<header class="login-card-header">
			<h1 class="login-card-title">{$LNG.siteTitleLostPassword}</h1>
			<p class="login-card-subtitle">{if $mailEnabled}{$LNG.passwordInfoEmail}{else}{$LNG.passwordMailNotConfigured}{/if}</p>
		</header>
		{if $mailEnabled}
		<form action="index.php?page=lostPassword" method="post" class="login-form">
			<input type="hidden" name="mode" value="send">
			<input type="hidden" name="csrfToken" value="{$csrfToken|escape}">
			<label class="login-label" for="mail">{$LNG.passwordMail}</label>
			<input class="login-input" type="email" name="mail" id="mail" autocomplete="email" required autofocus>
			<button class="login-button" type="submit">{$LNG.passwordSubmit}</button>
		</form>
		{/if}
		<footer class="login-card-footer">
			<a class="login-link" href="index.php">{$LNG.passwordBackToLogin}</a>
		</footer>
	</div>
</div>
{/block}
