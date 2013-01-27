<?php
// Common functions

/**
 * Check if the browser session is trusted by the client
 * @return boolean true if the user-agent is the igb and it is trusted
 */
function isTrusted()
{
    //check if we are the running in the igb
	if(!isIGB())
		return false;

    $trust = $_SERVER["HTTP_EVE_TRUSTED"];

    if(strtolower($trust) === "yes")
        return true;
    else
        return false;
}

/**
 * Check if the user is using the In-game browser to view the site
 * 
 * @return boolean true if the user-agent is the IGB
 */
function isIGB()
{
    $ingame = strpos($_SERVER["HTTP_USER_AGENT"], "EVE-IGB");
    if(!$ingame)
        return false;
	return true;
}

/**
 * Connects to the database
 * 
 * @return \PDO
 */
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

/**
 * Check if the pilot is in a fleet
 * 
 * @param PDO $db the database handle
 * @return boolean true if the pilot is in a fleet
 */
function pilotIsInFleet(PDO $db)
{
    if(isset($_SESSION["fleet"]))
        return true;

    return false;
}

/**
 * Get all valid fleets
 * 
 * Valid fleets are fleets that are enabled and less then 24 hours old.
 * 
 * @param type $dbh handle to the database
 * @return type 
 */
function getAllValidFleets($dbh)
{
    $query="SELECT fleets.id as fleet_id, fleets.name as fleet_name,fc,creation_time,password,public,motd,options,enabled,pilots.name as fc_name
			FROM fleets JOIN pilots ON pilots.id=fleets.fc
			WHERE creation_time >=date_sub(NOW(), INTERVAL 1 DAY) AND enabled = 1 ORDER by creation_time DESC;";
    $statement = $dbh->prepare($query);
    $statement->execute();
    return $statement->fetchAll(PDO::FETCH_ASSOC);
}

//

/**
 * Gets every ship that belongs to the fleet
 * @param type $fleet_id id of the fleet to query
 * @param PDO $db valid database handle
 * @return type
 */
function getShipsInFleet($fleet_id, PDO $db)
{
	$query="SELECT owner,dna,pilots.name as pilot_name 
			FROM ships INNER JOIN pilots ON ships.owner=pilots.id 
			WHERE fleet = :id ORDER BY REVERSE(SUBSTRING(pilots.name, LOCATE(' ', pilots.name) +1)) ";
	$stmt = $db->prepare($query);
	$stmt->execute( array(':id' => $fleet_id) );
	return $stmt->fetchAll(PDO::FETCH_ASSOC);
}	

/**
 * Retrieve information about the selected fleet
 * @param type $fleet_id id of the fleet to query
 * @param PDO $db handle to the database
 * @return type
 */
function getFleetInfo($fleet_id, PDO $db)
{
	$query="SELECT fleets.id as fleet_id, fleets.name as fleet_name,fc,creation_time,password,public,motd,enabled, pilots.name as fc_name
			FROM fleets JOIN pilots ON pilots.id=fleets.fc WHERE fleets.id = :id";
	$stmt = $db->prepare($query);
	$stmt->execute( array(':id' => $fleet_id) );
	return $stmt->fetch(PDO::FETCH_ASSOC);
}

/**
 * Check if the string is a valid ship dna string/url
 * 
 * @todo Check if the typeId is really a ship
 * @param type $dna 
 * @param PDO $dbh
 * @return boolean false on failure or the ship typeId if it is a type
 */
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



/**
 * parses a chat line/dna string into is component parts
 * 
 * note: function assumes it is a valid ship dna string -- see isShipDNA to check if it is
 * @param type $_dna
 * @return type [0](dna) = ship dna string, [1](name) = ship name, [2](modules) = array of typeids and quantities in 'typeID;quantity' format
 */
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

/**
 * Check if a typeId belongs to an item that is in the ships category
 * @param type $typeId typeid of the item in question
 * @param PDO $dbh handle to the database
 * @return boolean true if the item is a ship, false if not
 */
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

/**
 * Retrieve the items name from its id
 * @param type $typeID typeid to query
 * @param PDO $dbh
 * @return string 
 */
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
				
		$rval = ($stmt->fetchColumn() > 0 ? true : false );
		if($rval)
			return true;
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

function getThemeList()
{
	$themes = json_decode(file_get_contents(THEMES_MAPPING),true);

	return $themes;
}

?>