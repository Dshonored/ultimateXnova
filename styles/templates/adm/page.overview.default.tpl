{block name="content"}

	<h1 class="fs-4 text-white">{$LNG.ow_title}</h1>
	<table class="table table-dark table-striped table-sm fs-12 w-50 my-5 mx-auto" style="border:2px {if empty($Messages)}lime{else}red{/if} solid;text-align:center;font-weight:bold;">
		<tr>
			<td class="transparent">{foreach item=Message from=$Messages}
					<span style="color:red">{$Message}</span><br>
					{foreachelse}{$LNG.ow_none}{/foreach}
			</td>
		</tr>
	</table>
	<table class="table table-dark table-striped table-sm fs-12 w-50 my-5 mx-auto">
		<tr>
			<th colspan="2">{$LNG.ow_overview}</th>
		</tr>
		<tr>
			<td style="height:50px" colspan="2">{$LNG.ow_welcome_text}</td>
		</tr>
		<tr>
			<th colspan="2">License</th>
		</tr>
		<tr>
			<td colspan="2" class="text-start fw-normal">
				Based on 2Moons (Jan-Otto Kröpke and contributors), SteemNova and ultimateXnova.
				Free software under the GNU Affero General Public License v3; it comes with ABSOLUTELY NO WARRANTY.
				Full copyright notices are kept in the source files and in LICENSE.
				Source code of this server: <a href="{$smarty.const.SOURCE_CODE_URL}" target="_blank" rel="noopener">{$smarty.const.SOURCE_CODE_URL}</a>
			</td>
		</tr>
	</table>

{/block}
