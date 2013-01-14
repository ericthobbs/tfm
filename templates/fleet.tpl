<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<title>Trivial Fleet Manager</title>
	<link rel="stylesheet" href="css/style.css" type="text/css"/>
</head>
<body onload="CCPEVE.requestTrust('{$trusturl}');">
	{if !empty($error_msg)}
		Task(s) Failed, Errors:
		<div style="color: red;">
			<ul>
			{foreach from=$error_msg item=error}
				<li>{$error}</li>
			{/foreach}
			</ul>
		</div>
	{/if}
	{if $show_confirm}
		<div>
			Confirmation required, please enter the verification code of '{$verification}' to proceed with this non-reversable action.<br/>
			<form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
				<input type="text" name="confirm" /><br/>
				<input type="hidden" name="verification" value="{$verification}" />
				<input type="submit" name="delete_confirmed" value="Delete the fleet"/>
			</form>
		</div>
	{/if}
	Direct join Link: <a href="join_fleet.php?join_fleet={$fleet.fleet_id}">in-game link for chat</a>
	<table class="gridtable" border="0">
		<tr>
			<th><img src="img/icon02_16.png" width="32" title="Pilot"/></th>
			<th><img src="img/icon09_05.png" width="32" title="Ship (Ship name)"/></th>
			<!-- Remote Assistance Modules -->
			<th><img src="img/icon01_11.png" width="32" title="Remote Armor"/></th>
			<th><img src="img/icon01_16.png" width="32" title="Remote Shield"/></th>
			<th><img src="img/icon01_02.png" width="32" title="Remote Capacitor"/></th>
			<!-- Propulsion Modules -->
			<th><img src="img/76_64_1.png" width="32" title="Warp Scrambler"/></th><!-- wrong icon -->
			<th><img src="img/icon03_07.png" width="32" title="Warp Disruptor"/></th>
			<th><img src="img/icon12_06.png" width="32" title="Stasis Webifier"/></th>
			<!-- Cap Warfare -->
			<th><img src="img/icon12_04.png" width="32" title="Energy Neut"/></th>
			<th><img src="img/icon01_03.png" width="32" title="Energy Vampire"/></th>
			<!-- Ewar -->
			<th><img src="img/icon05_07.png" width="32" title="Tracks"/></th>
			<th><img src="img/icon04_11.png" width="32" title="Sensor Damps"/></th>
			<th><img src="img/icon56_01.png" width="32" title="Target Painter"/></th>
			<th><img src="img/icon56_08.png" width="32" title="Interdiction Probe Launcher"/></th>
			<!-- ECM -->
			<th><img src="img/icon63_14.png" width="32" title="ECM - Gallente"/></th>
			<th><img src="img/icon63_13.png" width="32" title="ECM - Caldari"/></th>
			<th><img src="img/icon63_15.png" width="32" title="ECM - Minmatar"/></th>
			<th><img src="img/icon63_16.png" width="32" title="ECM - Amarr"/></th>
			<th><img src="img/icon63_16.png" width="32" title="ECM - Multispec"/></th>
			<!-- misc -->
			<th><img src="img/icon03_10.png" width="32" title="Ship Scanner"/></th>
			<th><img src="img/25_64_4.png" width="32" title="Cynosural Field Generator"/></th>
			<th><img src="img/icon09_05.png" width="32" title="Gang Links"/></th>
			<th>CPNL</th>
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
			<td>{$i.modules.ganglinks|default:'N/A'}</td>
			<!-- pilot/fc options -->
			<td>
				{if $smarty.session.pilot == $i.pilot_id || $fleet.fc == $smarty.session.pilot}
				<a href="{$smarty.server.PHP_SELF}?remove_pilot={$i.pilot_id}" title="Remove pilot from fleet">
					<img src="img/Delete-icon.png" width="16" alt="Remove pilot from fleet"/></a>
				{/if}
				{if $fleet.fc == $smarty.session.pilot}
				<a href="{$smarty.server.PHP_SELF}?make_fc={$i.pilot_id}" title="Promote pilot to FC">
					<img src="img/Gear-icon.png" width="16" alt="Promote pilot to FC"/></a>
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
			<th>{$totals.ganglinks|default:'N/A'}</th>
			<th>CPNL</th>
		</tr>
		<tr>
			<th><img src="img/icon02_16.png" width="32" title="Pilot"/></th>
			<th><img src="img/icon09_05.png" width="32" title="Ship (Ship name)"/></th>
			<!-- Remote Assistance Modules -->
			<th><img src="img/icon01_11.png" width="32" title="Remote Armor"/></th>
			<th><img src="img/icon01_16.png" width="32" title="Remote Shield"/></th>
			<th><img src="img/icon01_02.png" width="32" title="Remote Capacitor"/></th>
			<!-- Propulsion Modules -->
			<th><img src="img/icon03_07.png" width="32" title="Warp Scrambler"/></th><!-- wrong icon -->
			<th><img src="img/icon03_07.png" width="32" title="Warp Disruptor"/></th>
			<th><img src="img/icon12_06.png" width="32" title="Stasis Webifier"/></th>
			<!-- Cap Warfare -->
			<th><img src="img/icon12_04.png" width="32" title="Energy Neut"/></th>
			<th><img src="img/icon01_03.png" width="32" title="Energy Vampire"/></th>
			<!-- Ewar -->
			<th><img src="img/icon05_07.png" width="32" title="Tracks"/></th>
			<th><img src="img/icon04_11.png" width="32" title="Sensor Damps"/></th>
			<th><img src="img/icon56_01.png" width="32" title="Target Painter"/></th>
			<th><img src="img/icon56_08.png" width="32" title="Interdiction Probe Launcher"/></th>
			<!-- ECM -->
			<th><img src="img/icon63_14.png" width="32" title="ECM - Gallente"/></th>
			<th><img src="img/icon63_13.png" width="32" title="ECM - Caldari"/></th>
			<th><img src="img/icon63_15.png" width="32" title="ECM - Minmatar"/></th>
			<th><img src="img/icon63_13.png" width="32" title="ECM - Amarr"/></th>
			<th><img src="img/icon63_16.png" width="32" title="ECM - Multispec"/></th>
			<!-- misc -->
			<th><img src="img/icon03_10.png" width="32" title="Ship Scanner"/></th>
			<th><img src="img/icon09_05.png" width="32" title="Cynosural Field Generator"/></th>
			<th><img src="img/icon09_05.png" width="32" title="Gang Links"/></th>
			<th>CPNL</th>
		</tr>			
	</table>
		<!-- <a href="index.php?clear" style="font-size: small;">clear session data</a> -->
		{if $fleet.fc == $smarty.session.pilot}
			<a href="{$smarty.server.PHP_SELF}?delete_fleet={$fleet.fleet_id}">delete fleet</a>
		{/if}<br/>
		<div>
			<form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
			Update Ship/Fitting: 
			<input type="text" name="fitting" />
			<input type="submit" name="update_fitting" value="Update" />
			</form>
		</div>
	{include file='footer.tpl'}
</body>
</html>
