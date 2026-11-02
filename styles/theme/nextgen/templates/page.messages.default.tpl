{block name="title" prepend}{$LNG.lm_messages}{/block}
{block name="content"}
<div class="fe-build fe-msgs">
	<header class="fe-toolbar">
		<div class="fe-toolbar-title">
			<h2><i class="bi bi-envelope"></i> {$LNG.lm_messages}</h2>
			<span id="loading" class="fe-pill" style="display:none;">{$LNG.loading}</span>
		</div>
	</header>

	<nav class="fe-msg-cats">
	{foreach $CategoryList as $CategoryID => $CategoryRow}
		<a class="fe-msg-cat {if $CategoryID == $MessID}is-active{/if}" href="game.php?page=messages&amp;category={$CategoryID}">
			<span class="fe-msg-dot" style="background:{$CategoryRow.color}"></span>
			<span class="fe-msg-cat-name">{$LNG.mg_type.{$CategoryID}}</span>
			<span class="fe-msg-count {if $CategoryRow.unread > 0}has-unread{/if}"><b id="unread_{$CategoryID}">{$CategoryRow.unread}</b>/<span data-total-number="{$CategoryRow.total}" id="total_{$CategoryID}">{$CategoryRow.total}</span></span>
		</a>
	{/foreach}
	</nav>

	<form action="game.php?page=messages" method="post" id="fe-msg-form">
		<input type="hidden" name="mode" value="action">
		<input type="hidden" name="ajax" value="1">
		<input type="hidden" name="messcat" value="{$MessID}">
		<input type="hidden" name="side" value="{$messagePage}">

		{if $MessID != 999 && !empty($MessageList)}
		<div class="fe-msg-bulk">
			<label class="fe-squeue-all"><input type="checkbox" data-msg-all> {$LNG.fe_select_all}</label>
			<select name="actionTop" aria-label="{$LNG.mg_action}">
				<option value="readmarked">{$LNG.mg_read_marked}</option>
				<option value="readtypeall">{$LNG.mg_read_type_all}</option>
				<option value="readall">{$LNG.mg_read_all}</option>
				<option value="deletemarked">{$LNG.mg_delete_marked}</option>
				<option value="deleteunmarked">{$LNG.mg_delete_unmarked}</option>
				<option value="deletetypeall">{$LNG.mg_delete_type_all}</option>
				<option value="deleteall">{$LNG.mg_delete_all}</option>
			</select>
			<input class="fe-btn fe-btn-ghost" value="{$LNG.mg_confirm}" type="submit" name="submitTop">
		</div>
		{/if}

		{include file="fe.pager.tpl" current=$messagePage max=$maxPage base="game.php?page=messages&amp;category={$MessID}&amp;side="}

		<div class="fe-msg-list" id="messagestable">
		{foreach $MessageList as $Message}
			{$isUnread = $MessID != 999 && $Message.unread == 1}
			<details class="fe-msg message_{$Message.id} {if $isUnread}is-unread{/if}" id="message_{$Message.id}" {if $isUnread || $Message@first}open{/if}>
				<summary>
					{if $MessID != 999}
					<input class="fe-msg-check" name="messageID[{$Message.id}]" value="1" type="checkbox" aria-label="{$LNG.mg_action}" onclick="event.stopPropagation()">
					{/if}
					<span class="fe-msg-head">
						<strong>{$Message.subject}</strong>
						<span>{$Message.from} · {$Message.time}</span>
					</span>
					<span class="fe-sys-icons">
						{if $Message.type == 1 && $MessID != 999}
						<a class="fe-btn fe-btn-icon" href="#" onclick="event.stopPropagation();return Dialog.PM({$Message.sender}, Message.CreateAnswer('{$Message.subject|escape:'javascript'}'));" title="{$LNG.mg_answer_to} {strip_tags($Message.from)}"><i class="bi bi-reply"></i></a>
						{/if}
						{if $MessID != 999}
						<a class="fe-btn fe-btn-icon fe-msg-del" href="#" onclick="event.preventDefault();event.stopPropagation();Message.deleteMessage({$Message.id}, {$Message.type});" title="{$LNG.fe_delete}" aria-label="{$LNG.fe_delete}"><i class="bi bi-trash3"></i></a>
						{/if}
						<i class="bi bi-chevron-down fe-sys-chev"></i>
					</span>
				</summary>
				<div class="fe-msg-body">{$Message.text}</div>
			</details>
		{foreachelse}
			<p class="fe-empty">{$LNG.fe_no_messages}</p>
		{/foreach}
		</div>

		{include file="fe.pager.tpl" current=$messagePage max=$maxPage base="game.php?page=messages&amp;category={$MessID}&amp;side="}
	</form>
</div>
<script>
(function () {
	var all = document.querySelector('[data-msg-all]');
	if (!all) return;
	all.addEventListener('change', function () {
		document.querySelectorAll('.fe-msg-check').forEach(function (box) { box.checked = all.checked; });
	});
})();
</script>
{/block}
