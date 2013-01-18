<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
{config_load file='application.conf'}
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<title>{$smarty.config.GenericPageTitle}</title>
	<link rel="stylesheet" href="css/style.css" type="text/css"/>
</head>
<body onload="CCPEVE.requestTrust('{$trusturl}');">
{if is_array($errors)}
    The Following errors prevented the fleet from being created. Correct them and try again.
    <span style="color:red;">
	<ul>
	    {foreach from=$errors item=i}
		<li>{$i}</li>
	    {/foreach}
	</ul><hr/></span>
{/if}
Fleet Information:<br/>
<form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
    Fleet Name (Required): <input type="text" name="name" value="{$charname|default:'Pilot'}'s fleet" /><br/>
	Fleet MOTD (Optional): <textarea name="motd">{$motd}</textarea> <br/>
    FC (Required): <input type="text" name="fc" value="{$charname}" /><br/>
    {* Password (Optional): <input type="text" name="password" disabled="disabled" value="{$pass}" /><br/> *}
    Ship DNA (Required): <input type="text" name="dna" value="{$dna}" /><br/>
    {* Make private: <input type="checkbox" name="private" disabled="disabled" value="{$private}" /><br/> *}
    <input type="submit" value="Create!" name="docreatefleet" />
    Fleets and their ships automatically expire after 24 hours after creation!
</form>
{include file='footer.tpl'}
</body>
</html>
