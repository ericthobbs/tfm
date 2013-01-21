<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
{config_load file='application.conf'}
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<title>{$smarty.config.GenericPageTitle} - {$fleet.fleet_name}</title>
	<link rel="stylesheet" href="css/core.css" type="text/css"/>
	<link rel="stylesheet" href="css/style-light.css" type="text/css"/>
	{include file='jquery.tpl'}
	{include file='bootstrap.tpl'}
	<script type="text/javascript">
	{literal}
		$(document).ready(function()
		{
			$("button").button();		
		});
	{/literal}
	</script>	
</head>
<body>
	{if !empty($errors)}
		<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
			<p>
				<span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
				<strong>Task(s) Failed, Errors:</strong>
				<ul>
					{foreach from=$errors item=error}
						<li>{$error}</li>
					{/foreach}
				</ul>
			</p>
		</div>			
	{/if}
	Joining fleet: {$fleet.fleet_name} commanded by {$fleet.fc_name} created on {$fleet.creation_time|date_format:"%A, %B %e, %Y"}
	<div class="form">
	<form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
		<fieldset>
			<legend>Pilot Information</legend>
		<label>Pilot Name (Required)</label>
		<input type="text" value="{$charname}" name="name" value="{$charname}"
		{if $igb}readonly="readonly"{/if}/><br/>
		{* Password (if required): <input type="text" name="password" disabled="disabled" value="{$pass}" /><br/> *}
		<label>Ship DNA (Required):</label>
		<input type="text" name="dna" value="{$dna}" />
		<a href="doc/shipdna.html" target="_blank" title="how do I find my ship dna?">
			<img src="img/Icons/items/{$icons.help[0]}" width="24" title="Help"/></a><br/>
		
		<input type="hidden" value="{$fleet_id}" name="fleet" />
		<button type="submit" name="dojoinfleet">Join!</button>
		</fieldset>
	</form>
	</div>
	{include file='footer.tpl'}
</body>
</html>
