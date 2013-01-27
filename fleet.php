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
$smarty->debugging = SMARTY_DEBUG;

//If not trusted, then exit early to avoid doing work we don't need.
$smarty->assign('igb',isTrusted());
$protocol = strpos(strtolower($_SERVER['SERVER_PROTOCOL']),'https') === FALSE ? 'http' : 'https';
$smarty->assign('basepath',$protocol."://".$_SERVER['SERVER_NAME'] . dirname($_SERVER['REQUEST_URI']));

$icons_array = json_decode(file_get_contents(IMAGES_FILE),true);
$smarty->assign("icons", $icons_array["system-icons"]);

if (!isTrusted() && REQUIRE_TRUST) 
{
    $smarty->display("notrust.tpl");
    exit;
}

try 
{
    $dbh = connectToDatabase();

    if (!pilotIsInFleet($dbh))
    {
		ClearSessionAndReturnToIndex();
    } 
    else
    {
		//pass the variables to the template
		$smarty->assign("charname", $_SERVER['HTTP_EVE_CHARNAME']);
		$smarty->assign("corpname", $_SERVER['HTTP_EVE_CORPNAME']);
		$smarty->assign("solarsystem", $_SERVER['HTTP_EVE_SOLARSYSTEMNAME']);
		$smarty->assign("region", $_SERVER['HTTP_EVE_REGIONNAME']); 
		$smarty->assign("charid", $_SERVER['HTTP_EVE_CHARID']);
		
		$fleet = getFleetInfo($_SESSION["fleet"],$dbh);
		$error_msg = array();
		
		if(isset($_REQUEST["remove_pilot"]))
		{
			if($_REQUEST["remove_pilot"] == $_SESSION["pilot"])
			{
				if(!removePilot($_REQUEST["remove_pilot"], $fleet["fleet_id"], $dbh))
				{
						array_push($error_msg,"Remove pilot failed! :(");
				}
				else
				{
					ClearSessionAndReturnToIndex();
				}
			}
			else if($_SESSION["pilot"] == $fleet["fc"])
			{
				if(!removePilot($_REQUEST["remove_pilot"], $fleet["fleet_id"], $dbh))
				{
						array_push($error_msg,"Remove pilot failed! :(");
				}
			}
		}

		if(isset($_REQUEST["make_fc"]))
		{
			array_push($error_msg,"function not implemented, yet!");
		}		
		
		if(isset($_REQUEST["delete_fleet"]))
		{
			if($_SESSION["pilot"] == $fleet["fc"])
			{
				$smarty->assign("show_confirm",true);
				$smarty->assign("verification", rand(1,999));
			}
			else
			{
				array_push($error_msg,"Only the FC may delete a fleet.");
			}
		}
		
		if(isset($_REQUEST["update_fleet"]))
		{
			if($_SESSION["pilot"] != $fleet["fc"])
				array_push($error_msg,"Only the FC may update a fleet.");
			
				$name = $_REQUEST["fleet_name"];
				$motd = $_REQUEST["fleet_motd"];
				$password = $_REQUEST["fleet_password"];
				$public = $_REQUEST["fleet_public"];
				
				if(!empty($name))
				{
					if(!updateFleetInfo($fleet["fleet_id"],$name,$motd,$public,$dbh))
						array_push($error_msg,"Failed to update fleet information.");
					else
					{
						header("Location: fleet.php");
					}
				}
				else
				{
					array_push($error_msg,"fleet name cannot be blank.");
				}
		}
		
		if(isset($_REQUEST["delete_confirmed"]))
		{
			if($_SESSION["pilot"] != $fleet["fc"])
				array_push($error_msg,"Only the FC may delete a fleet.");
			else
			{
				if($_REQUEST["confirm"] != $_REQUEST["verification"])
				{
					array_push($error_msg,"invalid verification code. Try Again!");
					$smarty->assign("show_confirm",true);
					$smarty->assign("verification", rand(1,999));					
				}
				else
				{
					if(!deleteFleet($fleet["fleet_id"],$dbh))
						array_push($error_msg,"failed to delete the fleet! :(");
					else
					{
						header("Location: fleet.php");
						exit;
					}
				}
			}
		}
		
		if(isset($_REQUEST["fitting"]))
		{
			if(!isShipDNA($_REQUEST["fitting"], $dbh))
			{
				array_push($error_msg,"invalid fitting");
			}
			else
			{
				$ships_stmt = $dbh->prepare("REPLACE into ships(`fleet`,`owner`,`dna`) values(:fleet, :owner, :dna)");
				if(!$ships_stmt->execute( array( ':fleet' => $fleet["fleet_id"], ':owner' => $_SESSION["pilot"], 
												':dna' => $_REQUEST["fitting"] ) ))
					array_push($error_msg,"failed to update fitting");
			}
		}
		
		$ships = getShipsInFleet($_SESSION["fleet"],$dbh);
		
		
		$pilots = array();
		$totals = array();
		$shiptypes = getShipGroups($dbh);
		
		$mapping = json_decode(file_get_contents(MAPPINGS_FILE),true);
		$module_icons = array();
		foreach($ships as $ship)
		{
			$entry = array();
			
			$dna = parseShipDNA($ship['dna']);
			$entry['pilot'] = $ship['pilot_name'];
			$entry['pilot_id'] = $ship['owner'];
			$entry['ship_name'] = $dna["name"];
			$entry['ship_dna'] = $dna["dna"];
			$entry['modules'] = array();
			$entry['ship_type'] = getItemTypeName($dna["dna"],$dbh);
			$entry['ship_typeid'] = isShipDNA($dna["dna"],$dbh);
			$entry['ship_groupid'] = getShipGroupId($entry['ship_typeid'],$dbh);
			
			if(array_key_exists($entry['ship_groupid'], $shiptypes))
				$shiptypes[$entry['ship_groupid']]["count"] += 1;
			
			//calc number of modules
			foreach($dna["modules"] as $mixed)
			{
				$module = getTypeAndQuantity($mixed);
				
				if($module === false)
					continue;
				
				foreach($mapping as $key => $types)
				{
					if(isModuleOfType($types["ids"], $module["typeID"], $dbh))
					{			
						$entry["modules"][$key] += $module["count"];
						$totals[$key] += $module["count"];
						
						if($key == "skirmlinks" || $key == "seigelinks" ||
							$key == "infolinks" || $key == "armorlinks" ||
							$key == "mininglinks" )
						{
							$entry["ganglinks"] += $module["count"];
							$totals["ganglinks"] += $module["count"];
							$module_icons["ganglinks"] = $types["image"];
						}
					}
					
					$module_icons[$key] = $types["image"];
				}
			}
			
			array_push($pilots,$entry);
			
		}
		
		foreach($shiptypes as $st => $data)
		{
			if($data["count"] < 1)
				unset($shiptypes[$st]);
		}
		
		$smarty->assign("shiptypes",$shiptypes);
		$smarty->assign("module_icons",$module_icons);
		$smarty->assign("fleet",$fleet);
		$smarty->assign("error_msg",$error_msg);
		$smarty->assign("ships",$pilots);
		$smarty->assign("totals",$totals);
		$smarty->display("fleet.tpl");
    }
}
catch (Exception $e)
{
    $smarty->assign("exception", $e);
    $smarty->display("whoops.tpl");
    exit;
}

//removes the selected pilot from the selected fleet.
//returns true on success, false on failure
function removePilot($pilot_id,$fleet_id, PDO $dbh)
{
	$query = "DELETE FROM ships WHERE owner = :pilot and fleet = :fleet";
	$stmt = $dbh->prepare($query);
	if(!$stmt->execute( array( ":pilot" => $pilot_id , ":fleet" => $fleet_id ) ))
			return false;
	else
	{
		if ($stmt->rowCount() > 0)
			return true;
		else
			return false;
	}
}

function promoteToFC($pilot_id,$fleet_id, PDO $dbh)
{
	$query = "UPDATE fleets SET fc = :fc WHERE id = :id";
	$stmt = $dbh->prepare($query);
	if($stmt->execute( array(":fc" => $pilot_id, ":id" => $fleet_id) ) )
	{
		return true;
	}
	else
		return false;
}

function deleteFleet($fleet_id, PDO $dbh)
{
	$query = "DELETE FROM fleets WHERE id = :id;";
	$stmt = $dbh->prepare($query);
	if($stmt->execute( array( ":id" => $fleet_id ) ))
		ClearSessionAndReturnToIndex();
	else
		return false; 
}

function updateFleetInfo($fleet_id,$name,$motd,$public,PDO $dbh)
{
	$query = "UPDATE fleets SET name = :name, motd = :motd, public = :public WHERE id = :id";
	$stmt = $dbh->prepare($query);
	if(!$stmt->execute( array( ":name" => $name, ":motd" => $motd, ":public" => $public, ":id" => $fleet_id ) ))
		return false;
	
	if ($stmt->rowCount() > 0)
		return true;
	else
		return false;
}

function getShipGroups(PDO $dbh)
{
	$query = "SELECT groupName,groupID FROM invGroups WHERE categoryID = :shipscategory AND published = 1 ORDER by categoryID ASC;";
	$stmt = $dbh->prepare($query);
	if(!$stmt->execute( array( ":shipscategory" => SHIP_CATEGORY ) ))
		return false;
	
	$return = array();
	
	$result = $stmt->fetchAll(PDO::FETCH_ASSOC);
	
	foreach($result as $row)
	{
		$return[$row["groupID"]] = array( "groupName" => $row["groupName"], "count" => 0 );
	}
	
	return $return;
}

function getShipGroupId($typeid,PDO $dbh)
{
	$query = "SELECT groupID from invTypes WHERE typeID = :typeid";
	$stmt = $dbh->prepare($query);
	
	if( !$stmt->execute( array( ":typeid" => $typeid ) ) )
		return false;
	
	//lazy -- fixme
	return $stmt->fetchColumn();
}