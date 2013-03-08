<!DOCTYPE html>
{config_load file='application.conf'}
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta charset="UTF-8" />
	<title>{$smarty.config.GenericPageTitle}</title>
	<link rel="stylesheet" href="{$basepath}/css/core.css" type="text/css"/>
	<link rel="stylesheet" href="{$basepath}/css/style-light.css" type="text/css"/>
	{include file='jquery.tpl'}
	{include file='bootstrap.tpl'}
</head>
<body>
	{include file='navbar.tpl'}
	
    <div class="container-fluid">
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
		<div class="{if $error_name}control-group error{/if}">
			<label class="control-label" for="name">Fleet Name</label>
			<input id="name" type="text" name="name" value="{$charname|default:'Pilot'}'s fleet" required="required" aria-required="true"/><br/>
		</div>
		<div class="{if $error_motd}control-group error{/if}">
			<label class="control-label" for="motd">Fleet MOTD</label>
			<input id="motd" type="text" name="motd" value="{$motd}" placeholder="Message of the day" /><br/>
		</div>
		<div class="{if $error_fc}control-group error{/if}">
			<label class="control-label" for="fc">Fleet Commander</label>
			<input id="fc" type="text" name="fc" value="{$charname}" required="required" aria-required="true" /><br/>
		</div>
		<div class="{if $error_password}control-group error{/if}">
		{* Password (Optional): <input type="text" name="password" disabled="disabled" value="{$pass}" /><br/> *}
		</div>
		<div class="{if $error_dna}control-group error{/if}">
			<label class="control-label" for="dna">Ship DNA</label>
			<input id="dna" type="text" name="dna" value="{$dna}" required="required" aria-required="true" />
				<a href="doc/shipdna.html" target="_blank" title="how do I find my ship dna?">
					<img src="img/Icons/items/{$icons.help[0]}" width="24" title="Help" alt="question mark"/></a><br/>
		</div>
    {* Make private: <input type="checkbox" name="private" disabled="disabled" value="{$private}" /><br/> *}
    <button class="btn btn-primary" type="submit" name="docreatefleet">Create!</button>
	</fieldset>
</form>
</div>
</div> <!-- /container -->
{include file='footer.tpl'}
</body>
</html>
