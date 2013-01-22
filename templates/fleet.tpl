<!DOCTYPE html>
{config_load file='application.conf'}
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta charset="UTF-8" />
	<title>{$smarty.config.GenericPageTitle} - {$fleet.fleet_name}</title>
	<link rel="stylesheet" href="css/core.css" type="text/css"/>
	<link rel="stylesheet" href="css/style-light.css" type="text/css"/>
	{include file='jquery.tpl'}
	{include file='bootstrap.tpl'}
	<script type="text/javascript">
	{literal}
		$(document).ready(function()
		{
			$("#options").accordion({collapsible: true, heightStyle: "content"});			
		});
	{/literal}
	</script>
</head>
<body>
	{include file='navbar.tpl'}
	<div class="container-fluid">
	{if !empty($error_msg)}
		<div class="ui-widget">
		<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
			<p>
				<span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
				<strong>Task(s) Failed, Errors:</strong>
				<ul>
					{foreach from=$error_msg item=error}
						<li>{$error}</li>
					{/foreach}
				</ul>
			</p>
		</div>
		</div>
	{/if}
	{if $show_confirm}
		<div class="ui-widget">
		<div class="ui-state-highlight ui-corner-all" style="padding: 0 .7em;">
			<p>
				<span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
				Confirmation required, please enter the verification code of '{$verification}' to proceed with this non-reversable action.<br/>
			<form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
				<input class="input-small" type="text" name="confirm" size="4" />
				<input type="hidden" name="verification" value="{$verification}" />&#160;
				<button class="btn btn-danger" type="submit" name="delete_confirmed">Confirm</button>
			</form>
			</p>
		</div>
		</div>
	{/if}
	<strong>Fleet Message of the Day:</strong>
	<div class="well well-small">
		<p>{$fleet.motd|default:'None Specified'}</p>
	</div>
	<span style="font-size: small;">Direct link: <a href="join_fleet.php?join_fleet={$fleet.fleet_id}">in-game link for chat</a></span>
	<table class="gridtable" border="0">
		<tr>
			<th><img src="img/Icons/items/{$icons.vitruvian[0]}" title="Pilot"/></th>
			<th><img src="img/Icons/items/{$icons.ship[0]}" title="Ship (Ship name)"/></th>
			<!-- Remote Assistance Modules -->
			<th><img src="img/Icons/items/{$module_icons.armor}" title="Remote Armor"/></th>
			<th><img src="img/Icons/items/{$module_icons.shield}" title="Remote Shield"/></th>
			<th><img src="img/Icons/items/{$module_icons.capacitor}" title="Remote Capacitor"/></th>
			<!-- Propulsion Modules -->
			<th><img src="img/Icons/items/{$module_icons.scrambler}" title="Warp Scrambler"/></th>
			<th><img src="img/Icons/items/{$module_icons.disruptor}" title="Warp Disruptor"/></th>
			<th><img src="img/Icons/items/{$module_icons.webifier}" title="Stasis Webifier"/></th>
			<!-- Cap Warfare -->
			<th><img src="img/Icons/items/{$module_icons.energyneut}" title="Energy Neut"/></th>
			<th><img src="img/Icons/items/{$module_icons.energyvampire}" title="Energy Vampire"/></th>
			<!-- Ewar -->
			<th><img src="img/Icons/items/{$module_icons.trackingdisruptor}" title="Tracks"/></th>
			<th><img src="img/Icons/items/{$module_icons.sensordampening}" title="Sensor Damps"/></th>
			<th><img src="img/Icons/items/{$module_icons.targetpainting}" title="Target Painter"/></th>
			<th><img src="img/Icons/items/{$module_icons.spherelauncher}" title="Interdiction Probe Launcher"/></th>
			<!-- ECM -->
			<th><img src="img/Icons/items/{$module_icons.magnetometricecm}" title="ECM - Gallente"/></th>
			<th><img src="img/Icons/items/{$module_icons.gravimetricecm}" title="ECM - Caldari"/></th>
			<th><img src="img/Icons/items/{$module_icons.ladarecm}" title="ECM - Minmatar"/></th>
			<th><img src="img/Icons/items/{$module_icons.radarecm}" title="ECM - Amarr"/></th>
			<th><img src="img/Icons/items/{$module_icons.multispececm}" title="ECM - Multispec"/></th>
			<!-- misc -->
			<th><img src="img/Icons/items/{$module_icons.shipscanner}" title="Ship Scanner"/></th>
			<th><img src="img/Icons/items/{$module_icons.cynosuralfield}" title="Cynosural Field Generator"/></th>
			<th><img src="img/Icons/items/53_64_16.png" title="Gang Links"/></th>
			<th><img src="img/Icons/items/{$icons.settings[0]}" title="Settings"/></th>
		</tr>
		{foreach from=$ships item=i name=row}
		<tr class="{if $smarty.foreach.row.index is odd}odd{/if} {if $smarty.session.pilot == $i.pilot_id}active{/if} {if $i.pilot_id == $fleet.fc}fc{/if}">
			<td>
				{if $igb}<a href="javascript:CCPEVE.showInfo(1377,{$i.pilot_id});">{$i.pilot|default:'Unknown'}</a>
				{else}
					{$i.pilot|default:'Unknown'}
				{/if}
			</td>
			<td>
				{if $igb}<a href="javascript:CCPEVE.showInfo({$i.ship_typeid});">{$i.ship_type}</a>{else}{$i.ship_type|default:'Unknown'}{/if}
				({if $igb}<a href="javascript:CCPEVE.showFitting('{$i.ship_dna}');">
					{$i.ship_name|default:'Unknown'}</a>
				{else}
					{$i.ship_name|default:'Unknown'}
				{/if})
			</td>
			<!-- remote assistance -->
			<td>{$i.modules.armor|default:'0'}</td>
			<td>{$i.modules.shield|default:'0'}</td>
			<td>{$i.modules.capacitor|default:'0'}</td>
			<!-- anti-propulsion modules -->
			<td>{$i.modules.scrambler|default:'0'}</td>
			<td>{$i.modules.disruptor|default:'0'}</td>
			<td>{$i.modules.webifier|default:'0'}</td>
			<!-- cap warfare -->
			<td>{$i.modules.energyneut|default:'0'}</td>
			<td>{$i.modules.energyvampire|default:'0'}</td>
			<!-- Ewar -->
			<td>{$i.modules.trackingdisruptor|default:'0'}</td>
			<td>{$i.modules.sensordampening|default:'0'}</td>
			<td>{$i.modules.targetpainting|default:'0'}</td>
			<td>{$i.modules.spherelauncher|default:'0'}</td>
			<!-- ECM -->
			<td>{$i.modules.magnetometricecm|default:'0'}</td>
			<td>{$i.modules.gravimetricecm|default:'0'}</td>
			<td>{$i.modules.ladarecm|default:'0'}</td>
			<td>{$i.modules.radarecm|default:'0'}</td>
			<td>{$i.modules.multispececm|default:'0'}</td>
			<!-- misc -->
			<td>{$i.modules.shipscanner|default:'0'}</td>
			<td>{$i.modules.cynosuralfield|default:'0'}</td>
			<td>{$i.modules.ganglinks|default:'0'}</td>
			<!-- pilot/fc options -->
			<td>
				{if $smarty.session.pilot == $i.pilot_id || $fleet.fc == $smarty.session.pilot}
				<a href="{$smarty.server.PHP_SELF}?remove_pilot={$i.pilot_id}" title="Remove pilot from fleet">
					<img src="img/Icons/items/{$icons.redx[0]}" width="16" alt="Remove pilot from fleet"/></a>
				{/if}
				{if $fleet.fc == $smarty.session.pilot}
				<a href="{$smarty.server.PHP_SELF}?make_fc={$i.pilot_id}" title="Promote pilot to FC">
					<img src="img/Icons/items/{$icons.fleet[0]}" width="16" alt="Promote pilot to FC"/></a>
				{/if}
			</td>
		</tr>
		{/foreach}
		<!-- totals -->
		<tr class="border-off">
			<th>&#8212;</th>
			<th>&#8212;</th>
			<!-- remote assistance -->
			<th>{$totals.armor|default:'0'}</th>
			<th>{$totals.shield|default:'0'}</th>
			<th>{$totals.capacitor|default:'0'}</th>
			<!-- anti-propulsion modules -->
			<th>{$totals.scrambler|default:'0'}</th>
			<th>{$totals.disruptor|default:'0'}</th>
			<th>{$totals.webifier|default:'0'}</th>
			<!-- cap warfare -->
			<th>{$totals.energyneut|default:'0'}</th>
			<th>{$totals.energyvampire|default:'0'}</th>
			<!-- Ewar -->
			<th>{$totals.trackingdisruptor|default:'0'}</th>
			<th>{$totals.sensordampening|default:'0'}</th>
			<th>{$totals.targetpainting|default:'0'}</th>
			<th>{$totals.spherelauncher|default:'0'}</th>
			<!-- ECM -->
			<th>{$totals.magnetometricecm|default:'0'}</th>
			<th>{$totals.gravimetricecm|default:'0'}</th>
			<th>{$totals.ladarecm|default:'0'}</th>
			<th>{$totals.radarecm|default:'0'}</th>
			<th>{$totals.multispececm|default:'0'}</th>
			<!-- misc -->
			<th>{$totals.shipscanner|default:'0'}</th>
			<th>{$totals.cynosuralfield|default:'0'}</th>
			<th>{$totals.ganglinks|default:'0'}</th>
			<th>&#8212;</th>
		</tr>
		<tr>
			<th><img src="img/Icons/items/{$icons.vitruvian[0]}" title="Pilot"/></th>
			<th><img src="img/Icons/items/{$icons.ship[0]}" title="Ship Name (Type/Fitting)"/></th>
			<!-- Remote Assistance Modules -->
			<th><img src="img/Icons/items/{$module_icons.armor}" title="Remote Armor"/></th>
			<th><img src="img/Icons/items/{$module_icons.shield}" title="Remote Shield"/></th>
			<th><img src="img/Icons/items/{$module_icons.capacitor}" title="Remote Capacitor"/></th>
			<!-- Propulsion Modules -->
			<th><img src="img/Icons/items/{$module_icons.scrambler}" title="Warp Scrambler"/></th>
			<th><img src="img/Icons/items/{$module_icons.disruptor}" title="Warp Disruptor"/></th>
			<th><img src="img/Icons/items/{$module_icons.webifier}" title="Stasis Webifier"/></th>
			<!-- Cap Warfare -->
			<th><img src="img/Icons/items/{$module_icons.energyneut}" title="Energy Neut"/></th>
			<th><img src="img/Icons/items/{$module_icons.energyvampire}" title="Energy Vampire"/></th>
			<!-- Ewar -->
			<th><img src="img/Icons/items/{$module_icons.trackingdisruptor}" title="Tracks"/></th>
			<th><img src="img/Icons/items/{$module_icons.sensordampening}" title="Sensor Damps"/></th>
			<th><img src="img/Icons/items/{$module_icons.targetpainting}" title="Target Painter"/></th>
			<th><img src="img/Icons/items/{$module_icons.spherelauncher}" title="Interdiction Probe Launcher"/></th>
			<!-- ECM -->
			<th><img src="img/Icons/items/{$module_icons.magnetometricecm}" title="ECM - Gallente"/></th>
			<th><img src="img/Icons/items/{$module_icons.gravimetricecm}" title="ECM - Caldari"/></th>
			<th><img src="img/Icons/items/{$module_icons.ladarecm}" title="ECM - Minmatar"/></th>
			<th><img src="img/Icons/items/{$module_icons.radarecm}" title="ECM - Amarr"/></th>
			<th><img src="img/Icons/items/{$module_icons.multispececm}" title="ECM - Multispec"/></th>
			<!-- misc -->
			<th><img src="img/Icons/items/{$module_icons.shipscanner}" title="Ship Scanner"/></th>
			<th><img src="img/Icons/items/{$module_icons.cynosuralfield}" title="Cynosural Field Generator"/></th>
			<th><img src="img/Icons/items/53_64_16.png" title="Gang Links"/></th>
			<th><img src="img/Icons/items/{$icons.settings[0]}" title="Settings"/></th>
		</tr>			
	</table>
		<!-- <a href="index.php?clear" style="font-size: small;">clear session data</a> -->
		<div id="options">
			<h3>Update Ship</h3>
			<div>
				<form class="form" name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
					<label for="fitting">New Fitting</label> <input type="text" name="fitting" />&#160;
					<button class="btn btn-info" type="submit" name="update_fitting">Update</button>
				</form>
			</div>
			{if $fleet.fc == $smarty.session.pilot}
			<h3>Update Fleet Information</h3>
			<div>
				<div class="form">
					<form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
						<label for="fleet_name">Fleet Name</label> <input type="text" name="fleet_name" value="{$fleet.fleet_name}" /><br/>
						<label for="fleet_motd" title="Message of the Day">Fleet MOTD</label> <textarea name="fleet_motd">{$fleet.motd|escape}</textarea><br/>
						<label for="fleet_password" title="Optional Password">Join Password</label> <input type="text" name="fleet_password" value="{$fleet.password}" /><br/>
						<label for="fleet_public" title="Display Fleet on main page">Display Fleet</label> 
						<input type="checkbox" name="fleet_public" title="{$smarty.server.fleet_password}" checked="{if $fleet.public == true}checked{/if}" /><br/>
						<button class="btn btn-success" type="submit" name="update_fleet">Update</button>
				</form>
				</div>
			</div>
		{if $fleet.fc == $smarty.session.pilot}
			<h3>Disband Fleet</h3>
			<div>
				<form action="{$smarty.server.PHP_SELF}?delete_fleet={$fleet.fleet_id}" method="post">
					<button class="btn btn-warning" type="submit"><img style="width: 16px;" src="img/Icons/items/{$icons.warning[0]}" alt="Warning"/> Delete fleet &#187;</button>
					<br/>Notice: This action will delete the fleet and any attached ships from it. This action cannot be undone once done.
				</form>
			</div>
		{/if}					
			{/if}
		</div>
	</div> <!-- container -->
	{include file='footer.tpl'}	
</body>
</html>
