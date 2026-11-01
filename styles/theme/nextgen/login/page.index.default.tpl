{block name="title" prepend}{$LNG.siteTitleIndex}{/block}
{block name="content"}

<script type="text/javascript">
// this is the id of the form
function loginSubmit(activeRecaptcha,use_recaptcha_on_login){
			var recaptchaResponse = false;


			if (activeRecaptcha == 1 && use_recaptcha_on_login == 1) {
				recaptchaResponse = grecaptcha.getResponse();
			}

	    $.ajax({
	        type: "POST",
	        url: 'index.php?page=login&mode=validate&ajax=1',
	        data: {
						userEmail: $("#userEmail").val(),
						password: $("#password").val(),
						g_recaptcha_response: recaptchaResponse,
						csrfToken: $('#csrfToken').val(),
						remember_me : $('#remember_me').is(':checked'),
						universe : $('#universe option:selected').val(),
						rememberedTokenValidator : $('#rememberedTokenValidator').val(),
						rememberedTokenSelector : $('#rememberedTokenSelector').val(),
						rememberedEmail : $('#rememberedEmail').val(),
					},
	        success: function(data)
	        {
						var dataParsed = jQuery.parseJSON(data);
						$('.alert').remove();

						if (dataParsed.status == 'fail') {
							if (activeRecaptcha == 1 && use_recaptcha_on_login == 1) {
								grecaptcha.reset();
							}

							$.each( dataParsed, function( typeError, errorText ) {

								if (typeError == 'status') {
									return;
								}
								$('#loginButton').before("<span class='alert alert-danger fs-6 py-1 my-1'>"+ errorText +"</span>")

							});

		        }else if (dataParsed.status == 'code') {
							$('#login').addClass('d-none');
							$('#codeStep').removeClass('d-none');
							$('#codeStepInfo').text(dataParsed.message);
							$('#loginCode').val('').trigger('focus');
		        }else if (dataParsed.status == 'redirect') {
							location.href = "game.php";
		        }

					}

	    });


}




function codeSubmit(){
	$.ajax({
		type: "POST",
		url: 'index.php?page=login&mode=verifyCode&ajax=1',
		data: { code: $('#loginCode').val(), csrfToken: $('#csrfToken').val() },
		success: function(data) {
			var res = jQuery.parseJSON(data);
			$('#codeStep .alert').remove();
			if (res.status == 'redirect') {
				location.href = "game.php";
				return;
			}
			$('#codeButton').before($("<span class='alert alert-danger fs-6 py-1 my-1'></span>").text(res.message));
			if (res.status == 'fail') {
				setTimeout(function(){ location.reload(); }, 2500);
			}
		}
	});
}
</script>

<div class="login-stage">
	<div class="login-card dark-blur-bg box-shadow-large">

		<header class="login-card-header">
			<h1 class="login-card-title">{$LNG.loginHeader}</h1>
			<p class="login-card-subtitle">{$LNG.loginTagline}</p>
		</header>

		<form id="login" class="login-form" action="" method="post" onsubmit="loginSubmit('{$recaptchaEnable}', '{$use_recaptcha_on_login}'); return false;">
			<input id="csrfToken" type="hidden" name="csrfToken" value="{$csrfToken|escape}">
			<input id="rememberedEmail" type="hidden" name="rememberedEmail" value="{$rememberedEmail|escape}">
			<input id="rememberedTokenSelector" type="hidden" name="rememberedTokenSelector" value="{$rememberedTokenSelector|escape}">
			<input id="rememberedTokenValidator" type="hidden" name="rememberedTokenValidator" value="{$rememberedTokenValidator|escape}">

			{if $isMultiUniverse}
			<select class="login-input" name="uni" id="universe">
				{foreach $universeSelect as $universeID => $currentUniverse}
					<option {if $currentUniverse == $rememberedUniverseID}selected{/if} value="{$universeID}">{$currentUniverse}</option>
				{/foreach}
			</select>
			{else}
				{foreach $universeSelect as $universeID => $currentUniverse}
					<input type="hidden" name="uni" value="{$universeID}">
				{/foreach}
			{/if}

			<label class="login-label" for="userEmail">{$LNG.login_email}</label>
			<input class="login-input" id="userEmail" type="email" autocomplete="email" name="userEmail" required autofocus value="{if !empty($rememberedEmail)}{$rememberedEmail|escape}{/if}">

			<label class="login-label" for="password">{$LNG.loginPassword}</label>
			<input class="login-input" id="password" type="password" autocomplete="current-password" name="password" required value="{if $rememberedPassword}password{/if}">

			{if $recaptchaEnable && $use_recaptcha_on_login}
				<div class="g-recaptcha" data-sitekey="{$recaptchaPublicKey}"></div>
			{/if}

			<div class="login-row">
				<label class="login-check" for="remember_me">
					<input id="remember_me" type="checkbox" name="remember_me" {if $rememberedPassword}checked{/if} value="">
					<span>{$LNG.loginRememberMe}</span>
				</label>
				<a class="login-link" href="index.php?page=lostPassword">{$LNG.buttonLostPassword}</a>
			</div>

			<button id="loginButton" class="login-button" type="submit">{$LNG.loginButton}</button>
		</form>

		<div id="codeStep" class="d-none">
			<form class="login-form" onsubmit="codeSubmit(); return false;">
				<p id="codeStepInfo" class="login-card-subtitle"></p>
				<label class="login-label" for="loginCode">{$LNG.login_code_label}</label>
				<input class="login-input login-code-input" id="loginCode" name="code" type="text" inputmode="numeric" pattern="[0-9]*" maxlength="6" autocomplete="one-time-code" placeholder="000000" required>
				<button id="codeButton" class="login-button" type="submit">{$LNG.login_code_button}</button>
				<a class="login-link text-center" href="index.php">{$LNG.login_code_back}</a>
			</form>
		</div>

		{if $facebookEnable}
			<a href="#" data-href="index.php?page=externalAuth&method=facebook" class="fb_login">
				<img src="styles/resource/images/facebook/fb-connect-large.png" alt="">
			</a>
		{/if}

		<footer class="login-card-footer">
			<span>{$LNG.loginNoAccount}</span>
			<a class="login-link" href="index.php?page=register">{$LNG.siteTitleRegister}</a>
		</footer>
	</div>
</div>

{/block}

{block name="script" append}
{if $recaptchaEnable && $use_recaptcha_on_login}
	<script type="text/javascript" src="https://www.google.com/recaptcha/api.js?hl={$lang}"></script>
	<script type="text/javascript" src="./scripts/base/avoid_submit_on_refresh.js"></script>
{/if}
{/block}
