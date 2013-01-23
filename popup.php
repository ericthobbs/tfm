<?php
header("Content-Type: application/xhtml+xml");
session_start();
require_once('include/config.php');
require_once('include/functions.php');
require_once('libs/Smarty/libs/Smarty.class.php');

$smarty = new Smarty();

//Init Smarty
$smarty->setTemplateDir( dirname(__FILE__) . "/templates" );
$smarty->setCompileDir(  dirname(__FILE__) . "/smarty/templates_c" );
$smarty->setConfigDir(   dirname(__FILE__) . "/smarty/configs" );
$smarty->setCacheDir(    dirname(__FILE__) . "/smarty/cache" );

if(!isTrusted())
	$smarty->debugging = SMARTY_DEBUG;

$smarty->assign('igb',isTrusted());
$smarty->assign('trusturl',"http://".$_SERVER['SERVER_NAME'] . dirname($_SERVER['REQUEST_URI']));

//If not trusted, then exit early to avoid doing work we don't need.
if (!isTrusted() && REQUIRE_TRUST) 
{
    $smarty->display("notrust.tpl");
    exit;
}

try 
{
    $dbh = connectToDatabase();

	if(isset($_REQUEST["shipid"]))
	{
		$shipname = getItemTypeName($_REQUEST["shipid"], $dbh);
		
		if(!isTypeAShip($_REQUEST["shipid"],$dbh))
			header("Ship ID is invalid",true,400);
		
		$smarty->assign("shipviewer_shipname",$shipname);
		$smarty->display("shipviewerpopup.tpl");
		
	}else if (isset($_REQUEST["starmap"]))
	{
		$smarty->display("mapviewerpopup.tpl");
	}
	else 
	{
		header("Ship ID Not Sent",true,500);
		exit;
	}
	
	
}
catch (Exception $e)
{
    $smarty->assign("exception", $e);
    $smarty->display("whoops.tpl");
    exit;
}