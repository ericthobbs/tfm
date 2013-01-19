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
	<script type="text/javascript">
	{literal}
		$(document).ready(function()
		{
			$("button").button();
			$("#options").accordion({collapsible: true, heightStyle: "content"});			
		});
		
	{/literal}
	</script>
</head>
<body>
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
				<input type="text" name="confirm" />
				<input type="hidden" name="verification" value="{$verification}" />
				<button type="submit" name="delete_confirmed">Delete the fleet</button>
			</form>
			</p>
		</div>
		</div>
	{/if}
	Fleet Message of the Day:<br/>
	<div class="fleetmessage" style="border: 2px solid lightgray; margin: 5px; padding: 3px;">{$fleet.motd|default:'None Specified'}</div><br/>
	<span style="font-size: small;">Direct link: <a href="join_fleet.php?join_fleet={$fleet.fleet_id}">in-game link for chat</a></span>
	<table class="gridtable" border="0">
		<tr>
			<th><img src="img/Icons/items/{$icons.vitruvian[0]}" width="32" title="Pilot"/></th>
			<th><img src="img/Icons/items/{$icons.ship[0]}" width="32" title="Ship (Ship name)"/></th>
			<!-- Remote Assistance Modules -->
			<th><img src="img/Icons/items/{$module_icons.armor}" width="32" title="Remote Armor"/></th>
			<th><img src="img/Icons/items/{$module_icons.shield}" width="32" title="Remote Shield"/></th>
			<th><img src="img/Icons/items/{$module_icons.capacitor}" width="32" title="Remote Capacitor"/></th>
			<!-- Propulsion Modules -->
			<th><img src="img/Icons/items/{$module_icons.scrambler}" width="32" title="Warp Scrambler"/></th>
			<th><img src="img/Icons/items/{$module_icons.disruptor}" width="32" title="Warp Disruptor"/></th>
			<th><img src="img/Icons/items/{$module_icons.webifier}" width="32" title="Stasis Webifier"/></th>
			<!-- Cap Warfare -->
			<th><img src="img/Icons/items/{$module_icons.energyneut}" width="32" title="Energy Neut"/></th>
			<th><img src="img/Icons/items/{$module_icons.energyvampire}" width="32" title="Energy Vampire"/></th>
			<!-- Ewar -->
			<th><img src="img/Icons/items/{$module_icons.trackingdisruptor}" width="32" title="Tracks"/></th>
			<th><img src="img/Icons/items/{$module_icons.sensordampening}" width="32" title="Sensor Damps"/></th>
			<th><img src="img/Icons/items/{$module_icons.targetpainting}" width="32" title="Target Painter"/></th>
			<th><img src="img/Icons/items/{$module_icons.spherelauncher}" width="32" title="Interdiction Probe Launcher"/></th>
			<!-- ECM -->
			<th><img src="img/Icons/items/{$module_icons.magnetometricecm}" width="32" title="ECM - Gallente"/></th>
			<th><img src="img/Icons/items/{$module_icons.gravimetricecm}" width="32" title="ECM - Caldari"/></th>
			<th><img src="img/Icons/items/{$module_icons.ladarecm}" width="32" title="ECM - Minmatar"/></th>
			<th><img src="img/Icons/items/{$module_icons.radarecm}" width="32" title="ECM - Amarr"/></th>
			<th><img src="img/Icons/items/{$module_icons.multispececm}" width="32" title="ECM - Multispec"/></th>
			<!-- misc -->
			<th><img src="img/Icons/items/{$module_icons.shipscanner}" width="32" title="Ship Scanner"/></th>
			<th><img src="img/Icons/items/{$module_icons.cynosuralfield}" width="32" title="Cynosural Field Generator"/></th>
			<th><img src="img/Icons/items/53_64_16.png" width="32" title="Gang Links"/></th>
			<th><img src="img/Icons/items/{$icons.settings[0]}" width="32" title="Settings"/></th>
		</tr>
		{foreach from=$ships item=i}
		<tr>
			<td>{if $igb}<a href="javascript:CCPEVE.showInfo(1377,{$i.pilot_id});">{$i.pilot|default:'Unknown'}</a>
				{else}
					{$i.pilot|default:'Unknown'}
				{/if}</td>
			<td>{if $igb}<a href="javascript:CCPEVE.showFitting('{$i.ship_dna}');">
					{$i.ship_name|default:'Unknown'}</a>
				{else}
					{$i.ship_name|default:'Unknown'}
				{/if}(&nbsp;{if $igb}<a href="javascript:CCPEVE.showInfo({$i.ship_typeid});">{$i.ship_type}</a>{else}{$i.ship_type|default:'Unknown'}{/if}&nbsp;)</td>
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
		<tr>
			<th>&mdash;</th>
			<th>&mdash;</th>
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
			<th>&mdash;</th>
		</tr>
		<tr>
			<th><img src="img/Icons/items/{$icons.vitruvian[0]}" width="32" title="Pilot"/></th>
			<th><img src="img/Icons/items/{$icons.ship[0]}" width="32" title="Ship Name (Type/Fitting)"/></th>
			<!-- Remote Assistance Modules -->
			<th><img src="img/Icons/items/{$module_icons.armor}" width="32" title="Remote Armor"/></th>
			<th><img src="img/Icons/items/{$module_icons.shield}" width="32" title="Remote Shield"/></th>
			<th><img src="img/Icons/items/{$module_icons.capacitor}" width="32" title="Remote Capacitor"/></th>
			<!-- Propulsion Modules -->
			<th><img src="img/Icons/items/{$module_icons.scrambler}" width="32" title="Warp Scrambler"/></th>
			<th><img src="img/Icons/items/{$module_icons.disruptor}" width="32" title="Warp Disruptor"/></th>
			<th><img src="img/Icons/items/{$module_icons.webifier}" width="32" title="Stasis Webifier"/></th>
			<!-- Cap Warfare -->
			<th><img src="img/Icons/items/{$module_icons.energyneut}" width="32" title="Energy Neut"/></th>
			<th><img src="img/Icons/items/{$module_icons.energyvampire}" width="32" title="Energy Vampire"/></th>
			<!-- Ewar -->
			<th><img src="img/Icons/items/{$module_icons.trackingdisruptor}" width="32" title="Tracks"/></th>
			<th><img src="img/Icons/items/{$module_icons.sensordampening}" width="32" title="Sensor Damps"/></th>
			<th><img src="img/Icons/items/{$module_icons.targetpainting}" width="32" title="Target Painter"/></th>
			<th><img src="img/Icons/items/{$module_icons.spherelauncher}" width="32" title="Interdiction Probe Launcher"/></th>
			<!-- ECM -->
			<th><img src="img/Icons/items/{$module_icons.magnetometricecm}" width="32" title="ECM - Gallente"/></th>
			<th><img src="img/Icons/items/{$module_icons.gravimetricecm}" width="32" title="ECM - Caldari"/></th>
			<th><img src="img/Icons/items/{$module_icons.ladarecm}" width="32" title="ECM - Minmatar"/></th>
			<th><img src="img/Icons/items/{$module_icons.radarecm}" width="32" title="ECM - Amarr"/></th>
			<th><img src="img/Icons/items/{$module_icons.multispececm}" width="32" title="ECM - Multispec"/></th>
			<!-- misc -->
			<th><img src="img/Icons/items/{$module_icons.shipscanner}" width="32" title="Ship Scanner"/></th>
			<th><img src="img/Icons/items/{$module_icons.cynosuralfield}" width="32" title="Cynosural Field Generator"/></th>
			<th><img src="img/Icons/items/53_64_16.png" width="32" title="Gang Links"/></th>
			<th><img src="img/Icons/items/{$icons.settings[0]}" width="32" title="Settings"/></th>
		</tr>			
	</table>
		<!-- <a href="index.php?clear" style="font-size: small;">clear session data</a> -->
		<div id="options">
			<h3>Update Ship</h3>
			<div>
				<form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
					<label for="fitting">New Fitting:</label> <input type="text" name="fitting" />
					<button type="submit" name="update_fitting">Update</button>
				</form>
			</div>
			{if $fleet.fc == $smarty.session.pilot}
			<h3>Update Fleet Information</h3>
			<div>
				<form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
					<label for="fleet_name">Fleet Name</label> <input type="text" name="fleet_name" value="{$fleet.fleet_name}" /><br/>
					<label for="fleet_motd" title="Message of the Day">Fleet MOTD</label> <textarea name="fleet_motd">{$fleet.motd|escape}</textarea><br/>
					<label for="fleet_password" title="Optional Password">Join Password</label> <input type="text" name="fleet_password" value="{$fleet.password}" /><br/>
					<label for="fleet_public" title="Display Fleet on main page">Display Fleet</label> 
					<input type="checkbox" name="fleet_public" title="{$smarty.server.fleet_password}" checked="{if $fleet.public == true}checked{/if}" /><br/>
					<button type="submit" name="update_fleet">Update</button>
				</form>
			</div>
		{if $fleet.fc == $smarty.session.pilot}
			<h3>Disband Fleet</h3>
			<div>
				<form action="{$smarty.server.PHP_SELF}?delete_fleet={$fleet.fleet_id}" method="post">
					<button type="submit" style="line-height: 16px;"><img src="img/Icons/items/{$icons.warning[0]}" width="16" alt="Warning"/> Delete fleet</button>
					<br/>Notice: This action will delete the fleet and any attached ships from it. This action cannot be undone once done.
				</form>
			</div>
		{/if}					
			{/if}
		</div>
	{include file='footer.tpl'}
</body>
</html>
