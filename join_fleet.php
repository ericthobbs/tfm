<?php

session_start();
require_once('include/config.php');
require_once('include/functions.php');
require_once('libs/Smarty/libs/Smarty.class.php');

if(isset($_REQUEST['clear']))
{
	session_unset();
	session_destroy();
	header("Location: index.php");
	exit;
}

$smarty = new Smarty();

//Init Smarty
$smarty->setTemplateDir( dirname(__FILE__) . "/templates" );
$smarty->setCompileDir(  dirname(__FILE__) . "/smarty/templates_c" );
$smarty->setConfigDir(   dirname(__FILE__) . "/smarty/configs" );
$smarty->setCacheDir(    dirname(__FILE__) . "/smarty/cache" );

if(!isTrusted())
	$smarty->debugging = SMARTY_DEBUG;

$smarty->assign("igb",isTrusted());
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
	$errors = array();

    //if the pilot is in a fleet, redirect to the fleet page
    if (pilotIsInFleet($dbh))
    {
        header("Location: fleet.php");
        exit;
    } 
    else
    {
		
		//pilot submitted the form
		if(isset($_REQUEST["dojoinfleet"]))
		{
			$smarty->assign("fleet_id",$_REQUEST["fleet"]);
			
			$smarty->assign("password",$_REQUEST["password"]);
			
			$fleet = getFleetInfo($_REQUEST["fleet"],$dbh);
			
			if($fleet["password"] !== null && $_REQUEST["password"] != $fleet["password"])
			{
				array_push($errors, "Invalid password");
			}
			
			if(($pilot_id = getCharacterIdFromName($_REQUEST["name"], $dbh)) == false)
			{
				array_push($errors, "Invalid pilot name.");
			}
			
			if(!isShipDNA($_REQUEST["dna"], $dbh))
			{
				array_push($errors, "Invalid Ship DNA string.");
			}
			
			if(empty($errors))
			{
				if(!joinFleet($_REQUEST["fleet"],$pilot_id,$_REQUEST["dna"],$_REQUEST["password"],$dbh))
					array_push($errors, "Failed to join fleet.");
				else
				{
					$_SESSION["fleet"] = $_REQUEST["fleet"];
					$_SESSION["pilot"] = $pilot_id;
					$_SESSION["is_fc"] = false;
					header("Location: fleet.php");
					exit;
				}
			}
		}
		else
		{
			if(isset($_REQUEST["join_fleet"]))
				$fleet_id = $_REQUEST["join_fleet"];		
			else if(isset($_SESSION["join_fleet"]))
				$fleet_id = $_SESSION["join_fleet"];
		
			if(array_key_exists('join_fleet',$_SESSION))
				unset($_SESSION['join_fleet']);
		
			$smarty->assign("fleet_id",$fleet_id);
			
	        if(!empty($fleet_id))
		    {
				$fleet = getFleetInfo($fleet_id, $dbh);
				if( empty($fleet) )
				{
					array_push($errors,"Invalid fleet id.");
				}
				else
				{
					if(isset($_SERVER["HTTP_EVE_CHARID"]))
					{
						if(isPlayerInFleet($_SERVER["HTTP_EVE_CHARID"],$fleet_id,$dbh))
						{
							$_SESSION["pilot"] = $_SERVER["HTTP_EVE_CHARID"];
							$_SESSION["fleet"] = $fleet_id;
							header("Location: fleet.php");
							exit;
						}
					}	
				}
		    }
			else
			{
				session_unset();
				session_destroy();
				header("Location: index.php");
				exit;
			}
			
		}

		//pass the variables to the template
		$smarty->assign("charname", $_SERVER['HTTP_EVE_CHARNAME']);
		$smarty->assign("corpname", $_SERVER['HTTP_EVE_CORPNAME']);
		$smarty->assign("solarsystem", $_SERVER['HTTP_EVE_SOLARSYSTEMNAME']);
		$smarty->assign("region", $_SERVER['HTTP_EVE_REGIONNAME']); 
		$smarty->assign("charid", $_SERVER['HTTP_EVE_CHARID']);
        
		$smarty->assign("fleet",  getFleetInfo($smarty->getVariable("fleet_id"), $dbh));
		$smarty->assign("errors",$errors);
		$smarty->display("join.tpl");
    }
}
catch (Exception $e)
{
    $smarty->assign("exception", $e);
    $smarty->display("whoops.tpl");
    exit;
}

function joinFleet($fleet_id, $pilot_id, $dna, $password, PDO $dbh)
{
	$ships_stmt = $dbh->prepare("REPLACE into ships(`fleet`,`owner`,`dna`) values(:fleet, :owner, :dna)");
    if(!$ships_stmt->execute( array( ':fleet' => $fleet_id, ':owner' => $pilot_id, ':dna' => $dna ) ))
    {
		return array("Failed to add pilot to fleet");
    }
    
    $_SESSION["fleet"] = $fleet_id;
    $_SESSION["pilot"] = $pilot_id;
    
    return true;
}

function isPlayerInFleet($charid,$fleetid, PDO $dbh)
{
	$query = "SELECT COUNT(1) FROM ships WHERE fleet = :fleetid AND owner = :charid;";
	$stmt = $dbh->prepare($query);
	if(!$stmt->execute( array(':fleetid' => $fleetid , ':charid' => $charid ) ))
		return false;
	
	return ($stmt->fetchColumn() > 0 ? true : false );
}

?>