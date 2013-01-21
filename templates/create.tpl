<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
{config_load file='application.conf'}
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<title>{$smarty.config.GenericPageTitle}</title>
	<link rel="stylesheet" href="css/core.css" type="text/css"/>
	<link rel="stylesheet" href="css/style-light.css" type="text/css"/>
	{include file='jquery.tpl'}
	{include file='bootstrap.tpl'}
</head>
<body>
	{include file='navbar.tpl'}
	
    <div class="container">
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
	<div class="ui-widgit">
		<div class="ui-state-highlight ui-corner-all" style="padding: 0 .7em;">
			<p>
				<span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
				<strong>Notice:</strong>
				Fleets and their ships automatically expire 24 hours after creation!
			</p>
		</div>
	</div>
	
	<div class="form">
<form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
	<fieldset>
		<legend>Fleet Information</legend>
		<label>Fleet Name</label>
		<input type="text" name="name" value="{$charname|default:'Pilot'}'s fleet" /><br/>
		<label>Fleet MOTD</label>
		<input type="text" name="motd" value="{$motd}"><br/>
		<label>Fleet Commander</label>
		<input type="text" name="fc" value="{$charname}" /><br/>
    {* Password (Optional): <input type="text" name="password" disabled="disabled" value="{$pass}" /><br/> *}
		<label>Ship DNA</label>
		<input type="text" name="dna" value="{$dna}" />
		<a href="doc/shipdna.html" target="_blank" title="how do I find my ship dna?">
			<img src="img/Icons/items/{$icons.help[0]}" width="24" title="Help"/></a><br/>
    {* Make private: <input type="checkbox" name="private" disabled="disabled" value="{$private}" /><br/> *}
    <button class="btn btn-primary" type="submit" name="docreatefleet">Create!</button>
	</fieldset>
</form>
</div>
{include file='footer.tpl'}
    </div> <!-- /container -->
</body>
</html>
