{*
<form class="navbar-form pull-right" action="{$smarty.server.PHP_SELF|escape}" method="post">
	<select class="span2" id="themeselector" name="selected_theme" title="Change Theme">
		{foreach from=$themes item=i key=k}
			<option value={$k} title="{$i.desc}">{$k}</option>
		{/foreach}
	</select>
	<button id="themechangebtn" class="btn" name="change_theme" type="submit">Change Theme</button>
</form>
<script type="text/javascript">
	{literal}
		$(document).ready(function()
		{
			//$("#themechangebtn").button();	
		});
	{/literal}	
</script>
*}