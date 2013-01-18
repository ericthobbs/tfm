<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
{config_load file='application.conf'}
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<title>{$smarty.config.GenericPageTitle}</title>
	<link rel="stylesheet" href="css/style.css" type="text/css"/>
</head>
<body>
Trivial Fleet Manager requires that the IGB trust this page. 
Click <a href="javascript:CCPEVE.requestTrust('{$trusturl}');">here</a> to trust. 
After seting the site to trusted, you must refresh the page. 
Click <a href="javascript:window.location.reload(true);">here</a> to refresh.
{include file='footer.tpl'}
</body>
</html>
