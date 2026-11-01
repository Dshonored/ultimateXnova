</div>
<footer class="dark-blur-bg footer-container box-shadow-large">
<a class="fs-6 m-0 px-2 text-white-50" href="{$smarty.const.SOURCE_CODE_URL}" target="_blank" rel="noopener" title="AGPL-3.0">Source</a>

</footer>
</div>
<div id="dialog" style="display:none;"></div>
<script>
var LoginConfig = {
    'isMultiUniverse': {$isMultiUniverse|json},
	'unisWildcast': {$unisWildcast|json},
	'referralEnable' : {$referralEnable|json},
	'basePath' : {$basepath|json}
};
</script>

</body>
</html>
