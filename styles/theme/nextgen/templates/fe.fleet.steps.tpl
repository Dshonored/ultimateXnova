{* Fleet wizard progress. Param: step (1-3) *}
<ol class="fe-steps">
	<li class="{if $step == 1}is-now{elseif $step > 1}is-done{/if}"><span>1</span> {$LNG.fe_fl_step1}</li>
	<li class="{if $step == 2}is-now{elseif $step > 2}is-done{/if}"><span>2</span> {$LNG.fe_fl_step2}</li>
	<li class="{if $step == 3}is-now{/if}"><span>3</span> {$LNG.fe_fl_step3}</li>
</ol>
