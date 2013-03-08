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
	<div class="form">
		<form name="option" action="{$smarty.server.PHP_SELF|escape}" method="post">
			<fieldset>
				<legend>Login</legend>
				<div class="{if $error_username}control-group error{/if}">
					<label class="control-label" for="username">Username</label>
					<input id="username" type="text" name="username" value="{$username}" placeholder="Character Name" required="required" aria-required="true"/><br/>
				</div>
				<div class="{if $error_password}control-group error{/if}">
					<label class="control-label" for="password">Password</label>
					<input id="password" type="password" name="password" value="{$password}" placeholder="Password" required="required" aria-required="true" /><br/>
				</div>
			<button class="btn btn-primary" type="submit" name="dologin">Login</button>
	</fieldset>
</form>
</div>
</div> <!-- /container -->
{include file='footer.tpl'}
</body>
</html>
