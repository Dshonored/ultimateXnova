{block name="title" prepend}{$LNG.fcm_info}{/block}
{block name="content"}
<div class="login-stage">
	<div class="login-card dark-blur-bg box-shadow-large">
		<header class="login-card-header">
			<h1 class="login-card-title">{$LNG.fcm_info}</h1>
		</header>
		{if isset($message)}<p class="login-message">{$message}</p>{/if}
		{if !empty($redirectButtons)}
		<div class="login-message-actions">
			{foreach $redirectButtons as $button}
			{if is_array($button) && isset($button.label)}
			<a class="login-button" href="{$button.url}">{$button.label}</a>
			{/if}
			{/foreach}
		</div>
		{/if}
	</div>
</div>
{/block}
