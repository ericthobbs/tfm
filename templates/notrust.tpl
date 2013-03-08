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
<body onload="javascript:CCPEVE.requestTrust('{$baseurl}');">
	<div class="container">
Trivial Fleet Manager requires that the IGB trust this page. 
Click <a href="javascript:CCPEVE.requestTrust('{$basepath}');">here</a> to trust. 
After seting the site to trusted, you must refresh the page. 
Click <a href="javascript:window.location.reload(true);">here</a> to refresh.
{include file='footer.tpl'}
	</div>
</body>
</html>
