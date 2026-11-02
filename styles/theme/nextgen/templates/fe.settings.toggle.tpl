{* Switch row. Params: name, label, checked, hint (optional) *}
<label class="fe-toggle">
	<span>{$label}{if !empty($hint)}<small>{$hint}</small>{/if}</span>
	<input name="{$name}" type="checkbox" value="1" {if $checked}checked{/if}>
	<i aria-hidden="true"></i>
</label>
