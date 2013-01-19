<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
{config_load file='application.conf'}
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<title>{$smarty.config.GenericPageTitle} - {$fleet.fleet_name}</title>
	<link rel="stylesheet" href="css/core.css" type="text/css"/>
	<link rel="stylesheet" href="css/{$smarty.const.THEME}" type="text/css"/>
	<link rel="stylesheet" href="{$smarty.const.JQUERYUI_CSS}" type="text/css"/>
	<script type="text/javascript" src="{$smarty.const.JQUERY_JS}"></script>
	<script type="text/javascript" src="{$smarty.const.JQUERYUI_JS}"></script>
	
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
	<form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
		Pilot Name(Required): <input type="text" value="{$charname}" name="name" value="{$charname}"
		{if $igb}readonly="readonly"{/if}/><br/>
		{* Password (if required): <input type="text" name="password" disabled="disabled" value="{$pass}" /><br/> *}
		Ship DNA (Required): <input type="text" name="dna" value="{$dna}" /><br/>
		<input type="hidden" value="{$fleet_id}" name="fleet" />
		<input type="submit" value="Join!" name="dojoinfleet" />
	</form>
	{include file='footer.tpl'}
</body>
</html>
