{block name="title" prepend}{$LNG.siteTitleRegister}{/block}
{block name="content"}

<script>
	function registerSubmit(activeRecaptcha, use_recaptcha_on_register,referralID){
		var recaptchaResponse = false;

		if (activeRecaptcha == 1 && use_recaptcha_on_register == 1) {
			recaptchaResponse = grecaptcha.getResponse();
		}


		$.ajax({
				type: "POST",
				url: 'index.php?page=register&mode=send&ajax=1',
				data: {
					userName: $("#username").val(),
					password: $("#password").val(),
					email: $("#email").val(),
					secretQuestion: $("#secretQuestion").val(),
					secretQuestionAnswer: $('#secretQuestionAnswer').val(),
					rules: $('#rules').is(':checked'),
					referralID : $('#referralID').val(),
					g_recaptcha_response: recaptchaResponse,
					csrfToken: $('#csrfToken').val(),
				},
				success: function(data)
				{
					var dataParsed = jQuery.parseJSON(data);

					$('.alert').remove();

					if (dataParsed.status == 'fail') {
						if (activeRecaptcha == 1 && use_recaptcha_on_register == 1) {
							grecaptcha.reset();
						}

						$.each( dataParsed, function( typeError, errorText ) {

							if (typeError == 'status') {
								return;
							}

							$('#registerButton').before("<span class='alert alert-danger fs-6 py-1 my-1'>"+ errorText +"</span>")
						});

					}else if (dataParsed.status == 'success') {
						$('#registerButton').before("<span class='alert alert-success fs-6 py-1 my-1'>"+ dataParsed.successMessage +"</span>")
					}else if (dataParsed.status == 'redirect') {
						location.href = dataParsed.url;
					}

				}

		});

	}
</script>
<div class="login-stage">
	<div class="login-card login-card-wide dark-blur-bg box-shadow-large">
		<header class="login-card-header">
			<h1 class="login-card-title">{$LNG.siteTitleRegister}</h1>
			<p class="login-card-subtitle">{$LNG.loginTagline}</p>
		</header>

		<form id="registerForm" class="login-form" method="post" action="index.php?page=register" onsubmit="registerSubmit('{$recaptchaEnable}', '{$use_recaptcha_on_register}', '{$referralData.id|escape}'); return false;">
			<input id="csrfToken" type="hidden" name="csrfToken" value="{$csrfToken|escape}">
			<input type="hidden" value="send" name="mode">
			<input type="hidden" value="{$externalAuth.account|escape}" name="externalAuth[account]">
			<input type="hidden" value="{$externalAuth.method|escape}" name="externalAuth[method]">
			<input id="referralID" type="hidden" value="{$referralData.id|escape}" name="referralID">

			{if $isMultiUniverse}
			<label class="login-label" for="universe">{$LNG.universe}</label>
			<select class="login-input" name="uni" id="universe">{html_options options=$universeSelect selected=$UNI}</select>
			{else}
			<input type="hidden" name="uni" value="{$UNI}">
			{/if}

			<label class="login-label" for="username">{$LNG.registerUsername}</label>
			<input class="login-input" type="text" name="username" id="username" maxlength="32" autocomplete="username" required autofocus>
			<p class="login-hint">{$LNG.registerUsernameDesc}</p>

			<label class="login-label" for="email">{$LNG.registerEmail}</label>
			<input class="login-input" type="email" name="email" id="email" autocomplete="email" required>
			<p class="login-hint">{$LNG.registerEmailDesc}</p>

			<label class="login-label" for="password">{$LNG.registerPassword}</label>
			<input class="login-input" type="password" name="password" id="password" minlength="8" autocomplete="new-password" required>
			<p class="login-hint">{$registerPasswordDesc}</p>

			<label class="login-label" for="secretQuestion">{$LNG.registerSecretQuestionText}</label>
			<select class="login-input" id="secretQuestion" name="secretQuestion">
				{foreach $LNG.registerSecretQuestionArray as $id => $currentQuestion}
				<option value="{$id}">{$currentQuestion}</option>
				{/foreach}
			</select>

			<label class="login-label" for="secretQuestionAnswer">{$LNG.registerSecretQuestionAnswerText}</label>
			<input class="login-input" id="secretQuestionAnswer" type="text" name="secretQuestionAnswer" autocomplete="off">

			{if !empty($referralData.name)}
			<p class="login-hint">{$LNG.registerReferral}: <strong>{$referralData.name|escape}</strong></p>
			{/if}

			{if $recaptchaEnable && $use_recaptcha_on_register}
			<div class="g-recaptcha" data-sitekey="{$recaptchaPublicKey}"></div>
			{/if}

			<label class="login-check login-rules" for="rules">
				<input type="checkbox" name="rules" id="rules" value="" required>
				<span>{$registerRulesDesc}</span>
			</label>

			<button id="registerButton" class="login-button" type="submit">{$LNG.buttonRegister}</button>
		</form>

		<footer class="login-card-footer">
			<a class="login-link" href="index.php">{$LNG.passwordBackToLogin}</a>
		</footer>
	</div>
</div>
{/block}
{block name="script" append}
<link rel="stylesheet" type="text/css" href="styles/resource/css/login/register.css?v={$REV}">
{if $recaptchaEnable && $use_recaptcha_on_register}
<script type="text/javascript" src="https://www.google.com/recaptcha/api.js?hl={$lang}"></script>
{/if}
<script type="text/javascript" src="scripts/login/register.js"></script>
{/block}

{block name="script" append}
<script type="text/javascript" src="./scripts/base/avoid_submit_on_refresh.js"></script>
{/block}
