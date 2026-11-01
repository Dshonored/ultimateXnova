{block name="title" prepend}{$LNG.siteTitleLostPassword}{/block}
{block name="content"}
<div style="max-width:360px;" class="box-border login-container dark-blur-bg box-shadow-large mx-auto">
	<h1 class="login-heading">{$LNG.passwordChooseNew}</h1>
	<form action="index.php?page=lostPassword&amp;mode=reset" method="post" class="d-flex flex-column">
		<input type="hidden" name="csrfToken" value="{$csrfToken|escape}">
		<input type="hidden" name="u" value="{$resetUser|intval}">
		<input type="hidden" name="k" value="{$resetToken|escape}">
		<label class="fs-6 text-start" for="password">{$LNG.registerPassword}</label>
		<input class="form-control fs-6 my-2 w-100" type="password" name="password" id="password" minlength="{$minPassword}" autocomplete="new-password" required autofocus>
		<label class="fs-6 text-start" for="passwordReplay">{$LNG.registerPasswordReplay}</label>
		<input class="form-control fs-6 my-2 w-100" type="password" name="passwordReplay" id="passwordReplay" minlength="{$minPassword}" autocomplete="new-password" required>
		<button class="hover-bg-color-grey btn bg-dark text-white w-100 my-2" type="submit">{$LNG.passwordSave}</button>
	</form>
</div>
{/block}
