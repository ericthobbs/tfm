<!DOCTYPE html>
{config_load file='application.conf'}
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta charset="UTF-8" />
	<title>{$smarty.config.GenericPageTitle}</title>
	<link rel="stylesheet" href="{$baseurl}/css/core.css" type="text/css"/>
	<link rel="stylesheet" href="{$baseurl}/css/style-light.css" type="text/css"/>
	{include file='jquery.tpl'}
	{include file='bootstrap.tpl'}
</head>
<body>
Whoops, An error as occured. The error is {$exception}
{include file='footer.tpl'}
</body>
</html>
