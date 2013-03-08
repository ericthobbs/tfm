<!DOCTYPE html>
{config_load file='application.conf'}
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta charset="UTF-8" />
	<title>{$smarty.config.GenericPageTitle} - {$fleet.fleet_name}</title>
	<link rel="stylesheet" href="{$basepath}/css/core.css" type="text/css"/>
	<link rel="stylesheet" href="{$basepath}/css/style-light.css" type="text/css"/>
	{include file='jquery.tpl'}
	{include file='bootstrap.tpl'}
</head>
<body>
	{include file='navbar.tpl'}
	<div class="container-fluid">
	{if !empty($errors)}
		<div class="alert alert-error" style="padding: 0 .7em;">
				<span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
				<strong>Task(s) Failed, Errors:</strong>
				<ul>
					{foreach from=$errors item=error}
						<li>{$error}</li>
					{/foreach}
				</ul>
		</div>			
	{/if}
	{if isset($fleet)}
	Joining fleet: {$fleet.fleet_name} commanded by {$fleet.fc_name} created on {$fleet.creation_time|date_format:"%A, %B %e, %Y"}
	{else}
	Select another fleet to continue!
	{/if}
	<div class="form">
	<form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
		<fieldset>
			<legend>Pilot Information</legend>
		<label class="control-label" for="name">Pilot Name (Required)</label>
		<input id="name" type="text" value="{$charname}" name="name" required="required" aria-required="true"
		{if $igb}readonly="readonly"{/if}/><br/>
		{* Password (if required): <input type="text" name="password" disabled="disabled" value="{$pass}" /><br/> *}
		<label>Ship DNA (Required):</label>
		<input type="text" name="dna" value="{$dna}" required="required" aria-required="true"/>
		<a href="doc/shipdna.html" target="_blank" title="how do I find my ship dna?">
			<img src="img/Icons/items/{$icons.help[0]}" width="24" title="Help" alt="question mark" /></a><br/>
		
		<input type="hidden" value="{$fleet_id}" name="fleet" />
		<button class="btn btn-primary" type="submit" name="dojoinfleet">Join!</button>
		</fieldset>
	</form>
	</div>
	</div>
	{include file='footer.tpl'}
</body>
</html>
