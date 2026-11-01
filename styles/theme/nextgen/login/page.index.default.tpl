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

	<!-- <h1 class="fs-3 my-4 w-100">{sprintf($LNG.loginWelcome, $gameName)}</h1>
	<p style="max-width:600px;" class="fs-6 my-2 w-100 mx-auto">{sprintf($LNG.loginServerDesc, $gameName)}</p>-->
	<div style="max-width:300px;" class="box-border description-container dark-blur-bg box-shadow-large">
		{sprintf($LNG.loginServerDesc, $gameName)}
		<a class="hover-bg-color-grey btn btn-block w-100 bg-dark text-white my-2 fs-6" href="index.php?page=register">{$LNG.buttonRegister}</a>
	</div>
	<div style="max-width:300px;" class="box-border login-container dark-blur-bg box-shadow-large">

				<h1 class="login-heading">{$LNG.loginHeader}</h1>
				<form id="login" action="" method="post" onsubmit="loginSubmit('{$recaptchaEnable}', '{$use_recaptcha_on_login}'); return false;">
					<input id="csrfToken" type="hidden" name="csrfToken" value="{$csrfToken}">
					<input id="rememberedEmail" type="hidden" name="rememberedEmail" value="{$rememberedEmail}">
					<input id="rememberedTokenSelector" type="hidden" name="rememberedTokenSelector" value="{$rememberedTokenSelector}">
					<input id="rememberedTokenValidator" type="hidden" name="rememberedTokenValidator" value="{$rememberedTokenValidator}">
					<div class="d-flex flex-column form-group">
						
						{if $isMultiUniverse}
						<select class="form-select my-2 w-100" name="uni" id="universe" >
							{foreach $universeSelect as $universeID => $currentUniverse}
								<option class="fs-6" {if $currentUniverse == $rememberedUniverseID}selected{/if} value="{$universeID}">{$currentUniverse}</option>
							{/foreach}
						</select>
						{else}
							{foreach $universeSelect as $universeID => $currentUniverse}
								<input type="hidden" name="uni" value="{$universeID}">
							{/foreach}
						{/if}
						
						<input class="form-control fs-6 my-2 w-100" id="userEmail" type="email" autocomplete="email" name="userEmail" placeholder="{$LNG.login_email}" value="{if !empty($rememberedEmail) && $rememberedEmail}{$rememberedEmail}{/if}">
						<input class="form-control fs-6 my-2 w-100" id="password" type="password" autocomplete="current-password" name="password" placeholder="{$LNG.loginPassword}" value="{if $rememberedPassword}password{/if}">
						{if $recaptchaEnable && $use_recaptcha_on_login}
								<div style="overflow:hidden;" class="g-recaptcha form-group w-100 fs-6 my-2 mx-auto d-flex justify-content-start" data-sitekey="{$recaptchaPublicKey}"></div>
						{/if}

						<div class="form-group d-flex align-items-center justify-content-start my-2">
							<input id="remember_me" type="checkbox" name="remember_me" {if $rememberedPassword}checked{/if} value="">
							<label for="remember_me" class="fs-6 px-2">{$LNG.loginRememberMe}</label>
						</div>

						<button id="loginButton" class="hover-bg-color-grey btn bg-dark text-white w-100" type="submit">{$LNG.loginButton}</button>

					</div>

				</form>

				<div id="codeStep" class="d-none"><form class="d-flex flex-column" onsubmit="codeSubmit(); return false;">
					<p id="codeStepInfo" class="fs-6 my-2"></p>
					<label class="fs-6 text-start" for="loginCode">{$LNG.login_code_label}</label>
					<input class="form-control fs-4 my-2 w-100 text-center login-code-input" id="loginCode" name="code" type="text" inputmode="numeric" pattern="[0-9]*" maxlength="6" autocomplete="one-time-code" placeholder="000000" required>
					<button id="codeButton" class="hover-bg-color-grey btn bg-dark text-white w-100 my-2" type="submit">{$LNG.login_code_button}</button>
					<a class="fs-6 text-center" href="index.php">{$LNG.login_code_back}</a>
				</form></div>
				{if $facebookEnable}
					<a href="#" data-href="index.php?page=externalAuth&method=facebook" class="fb_login">
						<img src="styles/resource/images/facebook/fb-connect-large.png" alt="">
					</a>
				{/if}

				<!-- <a class="hover-bg-color-grey btn btn-block w-100 bg-dark text-white my-2 fs-6" href="index.php?page=register">{$LNG.buttonRegister}</a>
				
				<span class="fs-6">{$loginInfo}</span>
-->
				<a class="d-block text-center fs-6 my-2" href="index.php?page=lostPassword">{$LNG.buttonLostPassword}</a>

	</div>

{/block}

{if $recaptchaEnable && $use_recaptcha_on_login}
	{block name="script" append}
		<script type="text/javascript" src="https://www.google.com/recaptcha/api.js?hl={$lang}"></script>
	{/block}

	{block name="script" append}
		<script type="text/javascript" src="./scripts/base/avoid_submit_on_refresh.js"></script>
	{/block}

{/if}
