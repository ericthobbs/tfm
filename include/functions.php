<?php
// Common functions

//returns true or false if the website is trusted by the in-game browser
//if the browser is not the IGB, then the function returns false.
function isTrusted()
{
    //check if we are the running in the igb
    $ingame = strpos($_SERVER["HTTP_USER_AGENT"], "EVE-IGB");
    if(!$ingame)
        return false;

    $trust = $_SERVER["HTTP_EVE_TRUSTED"];

    if(strtolower($trust) === "yes")
        return true;
    else
        return false;
}

//Connect to the database
function connectToDatabase()
{   
    if(DB_MYSQL)
    {
        //Assemble connection string for mysql
        $connection_string = sprintf("mysql:host=%s;dbname=%s",DB_HOST,DB_NAME);
        $db = new PDO($connection_string,DB_USER,DB_PASS);
    }
    else if(DB_SQLITE)
    {
        $connection_string = sprintf("sqlite:%s",DB_NAME);
        $db = new PDO($connection_string);
    }
    
	//throw exceptions upon error
	$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    
    return $db;
}

//check if the pilot is in a fleet
//this function will restore the pilots last session data if possible.
function pilotIsInFleet(PDO $db)
{
    if(isset($_SESSION["fleet"]))
        return true;

	/*
	//check if the player is part of an active fleet
	if(isset($_SERVER["HTTP_EVE_CHARID"]))
	{
		$fleets = getAllValidFleets($db);
		foreach($fleets as $row)
		{
			$stmt = $db->prepare("SELECT fleet,owner from ships WHERE fleet = ? and owner = ?");
			if(!$stmt->execute( array($row['id'],$_SERVER['HTTP_EVE_CHARID']) ))
				return false;
			$results = $stmt->fetchAll(PDO::FETCH_ASSOC);
			$_SESSION["fleet"] = $results['fleet'];
			return true;
		}
	}
	 */
    return false;
}

//get all valid fleets
function getAllValidFleets($dbh)
{
    $query="SELECT fleets.id as fleet_id, fleets.name as fleet_name,fc,creation_time,password,public,motd,options,enabled,pilots.name as fc_name
			FROM fleets JOIN pilots ON pilots.id=fleets.fc
			WHERE creation_time >=date_sub(NOW(), INTERVAL 1 DAY) AND enabled = 1 ORDER by creation_time DESC;";
    $statement = $dbh->prepare($query);
    $statement->execute();
    return $statement->fetchAll(PDO::FETCH_ASSOC);
}

//returns an array of results containg the ships in the fleet
function getShipsInFleet($fleet, PDO $db)
{
	$query="SELECT owner,dna,pilots.name as pilot_name 
			FROM ships INNER JOIN pilots ON ships.owner=pilots.id 
			WHERE fleet = :id;";
	$stmt = $db->prepare($query);
	$stmt->execute( array(':id' => $fleet) );
	return $stmt->fetchAll(PDO::FETCH_ASSOC);
}	

//returns the selected fleet information
function getFleetInfo($fleet, PDO $db)
{
	$query="SELECT fleets.id as fleet_id, fleets.name as fleet_name,fc,creation_time,password,public,motd,enabled, pilots.name as fc_name
			FROM fleets JOIN pilots ON pilots.id=fleets.fc WHERE fleets.id = :id";
	$stmt = $db->prepare($query);
	$stmt->execute( array(':id' => $fleet) );
	return $stmt->fetch(PDO::FETCH_ASSOC);
}

//Checks if the first element of the dna string is a valid item id.
//if it is, then its most likely a ship and it returns the typeId.
//if not, returns false
//TODO: Check if the typeId is really a ship!
function isShipDNA($dna,PDO $dbh)
{
			$start = $dna;

			$shipdna = preg_replace("/>/","&gt",preg_replace("/</","&lt",$start));
			$shipdna = preg_replace("/\\\'/","",$shipdna);
			$shipdna = preg_replace("/'/","",$shipdna);
			$shipdna = preg_replace("/[^:]*$/","",$shipdna);
			$shipdna = preg_replace("/.*?fitting:/","",$shipdna);
			$shipdna = preg_replace("/^:/","",$shipdna);
			$shipdna = explode(":",$shipdna);

			$ship = preg_replace('@<[\/\!]*?[^<>]*?>@si','',$start);
			$ship = preg_replace("/\\\'/","",$ship);
			$ship = preg_replace("/'/","",$ship);
			$ship = preg_replace('/^[^>]*. /','',$ship);
			
			if( empty($ship) || empty($shipdna) )
			    return false;
			
			$typeId = $shipdna[0];
			$statement = $dbh->prepare("SELECT count(1) from invTypes WHERE typeId = ?");
			$statement->execute( array( $typeId) );
			
			if($statement->fetchColumn() != 1)
			    return false;
			return $typeId;
}

//parse a chat line/dna string into is component parts
// return[0](dna)     = ship dna string
// return[1](name)    = ship name
// return[2](modules) = array of typeids and quantities in 'typeID;quantity' format
//note: function assumes it is a valid ship dna string -- see isShipDNA to check if it is
function parseShipDNA($_dna)
{
			//TODO: replace this voodoo with actual code
			$start = $_dna;

			$dna = preg_replace("/>/","&gt",preg_replace("/</","&lt",$start));
			$dna = preg_replace("/\\\'/","",$dna);
			$dna = preg_replace("/'/","",$dna);
			$dna = preg_replace("/[^:]*$/","",$dna);
			$dna = preg_replace("/.*?fitting:/","",$dna);
			$dna = preg_replace("/^:/","",$dna);
			$rdna = explode(":",$dna);

			$ship = preg_replace('@<[\/\!]*?[^<>]*?>@si','',$start);
			$ship = preg_replace("/\\\'/","",$ship);
			$ship = preg_replace("/'/","",$ship);
			$ship = preg_replace('/^[^>]*. /','',$ship);
			
			return array( 'dna' => $dna, 'name' => $ship, 'modules' => $rdna );
}

//check if a given typeid belongs to a ship.
//returns true if it does or false upon failure
function isTypeAShip($typeId, PDO $dbh)
{
	$stmt = $dbh->prepare("SELECT invTypes.typeID, invTypes.typeName, marketGroupID,invGroups.categoryID, invCategories.categoryName
							from invTypes 
							JOIN invGroups ON invTypes.groupID=invGroups.groupID 
							JOIN invCategories ON invGroups.categoryID=invCategories.categoryID
							WHERE typeID = :typeid and invTypes.published = 1;");
	if(!$stmt->execute( array(':typeid' => $typeId) ))
		return false;
	
	$result = $stmt->fetch(PDO::FETCH_ASSOC);
	
	if($result['categoryID'] == SHIP_CATEGORY)
		return true;
	
	return false;
}

//convert an items typeID to its typeName
function getItemTypeName($typeID, PDO $dbh)
{
	$query = "SELECT typeName from invTypes WHERE typeID = ?;";
	$stmt = $dbh->prepare($query);
	if(!$stmt->execute( array($typeID) ))
		return false;
	$result = $stmt->fetch(PDO::FETCH_ASSOC);
	return $result["typeName"];
}

//Translate character name to ID.
//returns the characterID if possible or false upon failure
function getCharacterIdFromName($name,PDO $dbh)
{
	if(empty($name))
		return false;
	
    $stmt = $dbh->prepare("SELECT id FROM pilots WHERE name = ?");
    if( !$stmt->execute( array( $name ) ) )
	    return false;
    
    $results = $stmt->fetchAll();
    if(count($results) > 0 )
		return $results[0]["id"];
    
    //id is not in the database, so fetch it from the api server and store it in the database
    require_once("libs/pheal/Pheal.php");
    spl_autoload_register("Pheal::classload");
    PhealConfig::getInstance()->cache = new PhealFileCache(PHEAL_CATCHDIR);
	PhealConfig::getInstance()->http_ssl_verifypeer = PHEAL_VERIFYPEER;
	PhealConfig::getInstance()->api_base = PHEAL_APIBASE;
    $pheal = new Pheal();
    $pheal->scope = "eve";
	
	try
	{
	
		$result = $pheal->CharacterID(array("names" => $name));
	
		if($result->characters[0]->characterID == 0)
			return false;
	
    $pilot_stmt = $dbh->prepare("INSERT INTO pilots(id,name) VALUES(:id,:name);");
    if(!$pilot_stmt->execute( array( ':id' => $result->characters[0]->characterID, ':name' => $name ) ))
    {
		return false;
    }
    
	return $result->characters[0]->characterID;
	
	}
	catch(PhealConnectionException $e)
	{
		return false;
	}
}

//splits a string if it contains a semi-colon (used in ship dna).
//returns false if the string is empty or if it does not contain a semi-colon
//returns an array containing two elements, the first 'typeID' containing the typeID
//and the second 'count' containg the count
function getTypeAndQuantity($mixedtypeandquantity)
{
	if(empty($mixedtypeandquantity))
		return false;
	
	if(strstr($mixedtypeandquantity,';') === false)
		return false;
	
	$array = explode(";",$mixedtypeandquantity);
	
	return array("typeID" => $array[0], "count" => $array[1]);
}

//returns true or false if the $moduleID parameter is a child element of one of the elements
//of the parentTypeID array as indicated by the database
function isModuleOfType(array $parentTypeID,$moduleID,PDO $dbh)
{
	foreach($parentTypeID as $ptype)
	{
		if($ptype == $moduleID)
			return true;
		
		$query = "SELECT count(1) FROM invMetaTypes WHERE parentTypeID = :ptype AND typeID = :module";
		$stmt = $dbh->prepare($query);
		if(!$stmt->execute( array( ":ptype" => $ptype, ":module" => $moduleID ) ))
			return false;
		
		return ($stmt->fetchColumn() > 0 ? true : false );
	}
	return false;
}

// clears the session data and returns the user to the index page
function ClearSessionAndReturnToIndex()
{
	session_unset();
	session_destroy();
	header("Location: index.php");
	exit;	
}

?>