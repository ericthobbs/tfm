<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
{config_load file='application.conf'}
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<title>{$smarty.config.GenericPageTitle}</title>
	<link rel="stylesheet" href="css/style.css" type="text/css"/>
</head>
<body onload="CCPEVE.requestTrust('{$trusturl}');">
	{if !empty($errors)}
		Task(s) Failed, Errors:
		<div style="color: red;">
			<ul>
			{foreach from=$errors item=error}
				<li>{$error}</li>
			{/foreach}
			</ul>
		</div>
	{/if}
	Joining fleet: {$fleet.fleet_name} commanded by {$fleet.fc_name} created on {$fleet.creation_time|date_format:"%A, %B %e, %Y"}
	<form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
		Pilot Name(Required): <input type="text" value="{$charname}" name="name" value="{$charname}"
		{if $igb}readonly="readonly"{/if}/><br/>
		Password (if required): <input type="text" name="password" disabled="disabled" value="{$pass}" /><br/>
		Ship DNA (Required): <input type="text" name="dna" value="{$dna}" /><br/>
		<input type="hidden" value="{$fleet_id}" name="fleet" />
		<input type="submit" value="Join!" name="dojoinfleet" />
	</form>
	{include file='footer.tpl'}
</body>
</html>
