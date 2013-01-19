<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
{config_load file='application.conf'}
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<title>{$smarty.config.GenericPageTitle}</title>
	<link rel="stylesheet" href="css/core.css" type="text/css"/>
	<link rel="stylesheet" href="css/{$smarty.const.THEME}" type="text/css"/>
	<link rel="stylesheet" href="{$smarty.const.JQUERYUI_CSS}" type="text/css"/>
	<script type="text/javascript" src="{$smarty.const.JQUERY_JS}"></script>
	<script type="text/javascript" src="{$smarty.const.JQUERYUI_JS}"></script>
</head>
<body>
	<div class="ui-widgit">
		<div class="ui-state-highlight ui-corner-all" style="padding: 0 .7em;">
			<p>
				<span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
				<strong>Notice:</strong>
				{$smarty.config.GenericPageTitle} is activly being developed and as such you may run into bugs/defects from time to time.
			</p>
		</div>
	</div>
	
	{if !empty($charname)}
	    Welcome {$charname} of {$corpname}. You are currently located in {$solarsystem} of {$region}.
        <hr/>
	{/if}
        Trivial Fleet Manager Active Fleet Listing:<br/>
        <form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
            {if is_array($fleets) && count($fleets) > 0}
				<table class="gridtable">
					<tr>
						<th>Fleet Name</th>
						<th>Fleet Commander</th>
						<th>Requires Password</th>
						<th>Created On</th>
						<th>Action</th>
					</tr>
					{foreach from=$fleets item=i}
					<tr>
						<td>{$i.fleet_name}</td>
						<td>{$i.fc_name}</td>
						<td>{if $i.password != null}Yes{else}No{/if}</td>
						<td>{$i.creation_time|date_format}</td>
						<td><a href="join_fleet.php?join_fleet={$i.fleet_id}">Join Now</a></td>
					</tr>
					{/foreach}
				</table>
            {/if}
			or you may <a href="create_fleet.php">Create a new fleet</a> if none of the current fleets meet your needs!<br/>
        </form>
        {include file='footer.tpl'}
</body>
</html>
