{block name="title" prepend}{$LNG.siteTitleLostPassword}{/block}
{block name="content"}
<div class="login-stage">
	<div class="login-card dark-blur-bg box-shadow-large">
		<header class="login-card-header">
			<h1 class="login-card-title">{$LNG.passwordChooseNew}</h1>
		</header>
		<form action="index.php?page=lostPassword&amp;mode=reset" method="post" class="login-form">
			<input type="hidden" name="csrfToken" value="{$csrfToken|escape}">
			<input type="hidden" name="u" value="{$resetUser|intval}">
			<input type="hidden" name="k" value="{$resetToken|escape}">
			<label class="login-label" for="password">{$LNG.registerPassword}</label>
			<input class="login-input" type="password" name="password" id="password" minlength="{$minPassword}" autocomplete="new-password" required autofocus>
			<label class="login-label" for="passwordReplay">{$LNG.registerPasswordReplay}</label>
			<input class="login-input" type="password" name="passwordReplay" id="passwordReplay" minlength="{$minPassword}" autocomplete="new-password" required>
			<button class="login-button" type="submit">{$LNG.passwordSave}</button>
		</form>
	</div>
</div>
{/block}
