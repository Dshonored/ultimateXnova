{block name="title" prepend}{$LNG.siteTitleLostPassword}{/block}
{block name="content"}
<div style="max-width:360px;" class="box-border login-container dark-blur-bg box-shadow-large mx-auto">
	<h1 class="login-heading">{$LNG.siteTitleLostPassword}</h1>
	{if $mailEnabled}
	<p class="fs-6 my-2">{$LNG.passwordInfoEmail}</p>
	<form action="index.php?page=lostPassword" method="post" class="d-flex flex-column">
		<input type="hidden" name="mode" value="send">
		<input type="hidden" name="csrfToken" value="{$csrfToken|escape}">
		<label class="fs-6 text-start" for="mail">{$LNG.passwordMail}</label>
		<input class="form-control fs-6 my-2 w-100" type="email" name="mail" id="mail" autocomplete="email" required autofocus>
		<button class="hover-bg-color-grey btn bg-dark text-white w-100 my-2" type="submit">{$LNG.passwordSubmit}</button>
	</form>
	{else}
	<p class="fs-6 my-2">{$LNG.passwordMailNotConfigured}</p>
	{/if}
	<a class="fs-6 d-block my-2" href="index.php">{$LNG.passwordBackToLogin}</a>
</div>
{/block}
