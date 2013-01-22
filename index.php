<?php
header("Content-Type: application/xhtml+xml");
session_start();
require_once('include/config.php');
require_once('include/functions.php');
require_once('libs/Smarty/libs/Smarty.class.php');

if(isset($_REQUEST['clear']))
	ClearSessionAndReturnToIndex();

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
    //connect to db
    $dbh = connectToDatabase();

    //if the pilot is in a fleet, redirect to the fleet page
    if (pilotIsInFleet($dbh))
    {
        header("Location: fleet.php");
        exit;
    } 
    else
    {
        //if the pilot wants to create a fleet, redirect to the create page
        if ($_REQUEST["create"])
        {
            header("Location: create_fleet.php");
            exit;
        }

        if ($_REQUEST["join"])
        {
            if (isset($_REQUEST["fleet"]))
            {
                //save the pilots choice to a session variable
                //that will be cleared by the join fleet script.
                $_SESSION["join_fleet"] = $_REQUEST["fleet"];
                header("Location: join_fleet.php");
                exit;
            }
        }

	//pass the variables to the template
	$smarty->assign("charname", $_SERVER['HTTP_EVE_CHARNAME']);
	$smarty->assign("corpname", $_SERVER['HTTP_EVE_CORPNAME']);
	$smarty->assign("solarsystem", $_SERVER['HTTP_EVE_SOLARSYSTEMNAME']);
	$smarty->assign("region", $_SERVER['HTTP_EVE_REGIONNAME']); 
	$smarty->assign("charid", $_SERVER['HTTP_EVE_CHARID']);
        
	$fleets = getAllValidFleets($dbh);
	$has_public = false;
	
	foreach($fleets as $f)
	{
		if($f["public"] == true)
		{
			$has_public = true;
			break;
		}
	}
	
	if($has_public)
		$smarty->assign("fleets",$fleets );
	
	$smarty->display("index.tpl");
    }
}
catch (Exception $e)
{
    $smarty->assign("exception", $e);
    $smarty->display("whoops.tpl");
    exit;
}