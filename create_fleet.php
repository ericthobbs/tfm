<?php

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

    //if the pilot is in a fleet, redirect to the fleet page
    if (pilotIsInFleet($dbh))
    {
        header("Location: fleet.php");
        exit;
    } 
    else
    {
	if(isset($_REQUEST["docreatefleet"]))
	{
	    $fc = $_REQUEST["fc"];
	    $name = $_REQUEST["name"];
	    $pass = $_REQUEST["password"];
	    $dna = $_REQUEST["dna"];
		$motd = $_REQUEST["motd"];
		$dna_raw = $dna;
	    $private = $_REQUEST["private"];
	    
	    $errors = array();
	    
	    if($private == true)
			array_push($errors, "Fleets cannot be private in this version");
	    
	    if(!empty($pass))
			array_push($errors, "Fleets cannot be password protected yet");
	    
	    if(empty($fc))
			array_push($errors, "FC cannot be empty");
	    
	    if(empty($name))
			array_push($errors, "Fleet name cannot be blank");
	    
	    if(empty($dna))
			array_push($errors, "FC must have a ship");
	    
	    if( ($shipId = isShipDNA($dna,$dbh) ) === false && isTypeAShip($shipId,$dbh))
			array_push($errors,"FC did not pass a valid ship dna string");
	    else 
		{
			$dna = parseShipDNA($dna);
		}
		
	    if( (count($errors) < 1))
	    {
			$result = createFleet($name,$motd,$pass,$fc,$dna_raw,$dbh);
		
			if($result === true)
			{
				header("Location: fleet.php");
				exit;
			}

			$errors = array_merge($errors,$result);
		}
	}

	$smarty->assign("password",$pass);
	$smarty->assign("fc",$fc);
	$smarty->assign("private",$private);
	$smarty->assign("name",$name);
	$smarty->assign("dna",$dna_raw);
	$smarty->assign("motd",$motd);
	
	//pass the variables to the template
	$smarty->assign("charname", $_SERVER['HTTP_EVE_CHARNAME']);
	$smarty->assign("corpname", $_SERVER['HTTP_EVE_CORPNAME']);
	$smarty->assign("solarsystem", $_SERVER['HTTP_EVE_SOLARSYSTEMNAME']);
	$smarty->assign("region", $_SERVER['HTTP_EVE_REGIONNAME']); 
	$smarty->assign("charid", $_SERVER['HTTP_EVE_CHARID']);
	
	$smarty->assign("errors",$errors);
	$smarty->display("create.tpl");
    }
}
catch (Exception $e)
{
    $smarty->assign("exception", $e);
    $smarty->display("whoops.tpl");
    exit;
}

//Create the fleet by inserting the information into the database
// returns true if successful, array of errors on error.
function createFleet($name,$motd,$password,$fc,$dna,PDO $dbh)
{
    
    $characterId = getCharacterIdFromName($fc,$dbh);
    
	if($characterId === false)
		return array("Invalid character name or api error");

	/*
	$tidy = new Tidy();
	$tidy->parseString($motd);
	$tidy->cleanRepair();
 
	$motd_clean = $tidy;	
	*/
	$motd_clean = $motd;
    $dbh->beginTransaction();
    
    $fleets_stmt = $dbh->prepare("INSERT INTO fleets(name,fc,password,motd) VALUES(:name,:fc,:password,:motd);");
    if(!$fleets_stmt->execute( array( ':name' => $name, ':fc' => $characterId, ':password' => $password, ':motd' => $motd_clean ) ))
    {
		$error = $fleets_stmt->errorInfo();
		$dbh->rollback();
		
		return array("failed to add fleet to the database: " . $error[2]);
    }
    $lastInsertId = $dbh->lastInsertId();
    
    $ships_stmt = $dbh->prepare("INSERT INTO ships(fleet,owner,dna) VALUES(:fleet,:owner,:dna);");
    if(!$ships_stmt->execute( array( ':fleet' => $lastInsertId, ':owner' => $characterId, ':dna' => $dna ) ))
    {
		$error = $fleets_stmt->errorInfo();
		$dbh->rollBack();
		return array("failed to add ship to database:" . $error[2]);
    }
    
    if(!$dbh->commit())
	{
		$error = $dbh->errorInfo();
		return array("failed to commit changes to the database: " . $error[2]);
	}
    
    $_SESSION["fleet"] = $lastInsertId;
    $_SESSION["pilot"] = $characterId;
	$_SESSION["is_fc"] = $lastInsertId;
    
    return true;
}

?>