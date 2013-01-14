<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<title>Trivial Fleet Manager</title>
	<link rel="stylesheet" href="css/style.css" type="text/css"/>
</head>
<body onload="CCPEVE.requestTrust('{$trusturl}');">
	{if !empty($charname)}
	    Welcome {$charname} of {$corpname}. You are currently located in {$solarsystem} of {$region}.
        <hr/>
	{/if}
        Please select an option below:<br/>
        <form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
            <input type="submit" name="create" value="Create Fleet" /><br/>
            {if is_array($fleets) && count($fleets) > 0}
                Join Fleet: 
                <select name="fleet">
                    {foreach from=$fleets item=i}
						{if $i.public == true}
                        <option value="{$i['fleet_id']}">{$i['fleet_name']} (Commanded by {$i['fc_name']})
							{if $i[4] !== null}
								 *Requires Password*
							{/if}
						</option>
						{/if}
                    {/foreach}
					
                </select>
		<input type="submit" name="join" value="join" /><br/>
            {/if}
        </form>
        {include file='footer.tpl'}
</body>
</html>
