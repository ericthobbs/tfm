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
$protocol = strpos(strtolower($_SERVER['SERVER_PROTOCOL']),'https') === FALSE ? 'http' : 'https';
$smarty->assign('basepath',$protocol."://".$_SERVER['SERVER_NAME'] . dirname($_SERVER['REQUEST_URI']));

//If not trusted, then exit early to avoid doing work we don't need.
if (!isTrusted() && REQUIRE_TRUST) 
{
    $smarty->display("notrust.tpl");
    exit;
}

try 
{
    $dbh = connectToDatabase();

	if(isset($_REQUEST["data"]))
	{
		if(strtolower($_REQUEST["data"]) == "systeminfo" && isset($_REQUEST["systemname"]) )
		{
			$sysname = $_REQUEST["systemname"];
			if(!isValidSystemName($sysname,$dbh));
			{
				print json_encode( array( "success" => false, "Message" => "Invalid System Name" ) );
				exit;
			}
			
		}
		exit;
	}
	
	if(isset($_REQUEST["shipid"]))
	{
		$shipname = getItemTypeName($_REQUEST["shipid"], $dbh);
		
		if(!isTypeAShip($_REQUEST["shipid"],$dbh))
			header("Ship ID is invalid",true,400);
		
		$smarty->assign("shipviewer_shipname",$shipname);
		$smarty->display("shipviewerpopup.tpl");
		
	}else if (isset($_REQUEST["starmap"]))
	{
		$smarty->assign("maptype",$_REQUEST["starmap"]);
		if(isset($_REQUEST["system"]))
		{
			if(!isValidSystemName($_REQUEST["system"],$dbh))
			{
				header("System is invalid",true,400);
				exit;				
			}
			$smarty->assign("systemname",$_REQUEST["system"]);
		}
		
		$smarty->display("mapviewerpopup.tpl");
	}
	else 
	{
		header("Invalid Request",true,500);
		exit;
	}
	
	
}
catch (Exception $e)
{
    $smarty->assign("exception", $e);
    $smarty->display("whoops.tpl");
    exit;
}

// checks if the string passed is a valid system name
function isValidSystemName($systemname, PDO $dbh)
{
	$query = "select count(1) from mapSolarSystems where solarSystemName = :sysname;";
	$stmt = $dbh->prepare($query);
	$stmt->execute( array( ":sysname" => $systemname ) );
	$result = $stmt->fetchColumn();
	return true;
}

function getSystemInformation($systemname, PDO $dbh)
{
	$query = "SELECT mapSolarSystems.solarSystemName, mapSolarSystems.x, mapSolarSystems.y, mapSolarSystems.z, 
				luminosity, border, fringe, corridor, hub, international, regional, constellation, 
				security, mapSolarSystems.radius, securityClass, mapRegions.regionName, 
				mapConstellations.constellationName, invTypes.typeName as SunName
			FROM mapSolarSystems
			JOIN mapRegions ON mapSolarSystems.regionID = mapRegions.regionID
			JOIN mapConstellations ON mapSolarSystems.constellationID = mapConstellations.constellationID
			JOIN invTypes ON mapSolarSystems.sunTypeID = invTypes.typeID
			WHERE solarSystemName = :sysname";
	$stmt = $dbh->prepare($query);
	$stmt->execute( array( ":sysname" => $systemname ) );
}