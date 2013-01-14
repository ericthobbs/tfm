<?php
//Configuration file for Trivial Fleet Manager

//
// Database
//

//Database host name
define('DB_HOST','');

//Database user name
define('DB_USER','');

//Database password
define('DB_PASS','');

//Database to use
//should be the name of the database or the path to the filename
define('DB_NAME','');

//Database providers
//Set Only one to true
define('DB_MYSQL',FALSE);

//SQL lite support is untested -- the database.sql script will need to be tweaked.
//support for additional drivers can be implemented by tweaking the connectToDatabase function in include\functions.php
//the database should already exist and point to an existing file!
define('DB_SQLITE',FALSE);

//
// Smarty
//

//set to true to display the smarty debug console.
define('SMARTY_DEBUG',FALSE);

//
// IGB Trust
//

//Set to true to require the use of the IGB and to require that the IGB session be trusted
define('REQUIRE_TRUST',TRUE);

//
// Pheal (API Support library)
//

//Cache directory for pheal api calls -- needs to be an absolute path
//for example: /home/user/.pheal/
define('PHEAL_CATCHDIR','');

//api server to use to make api calls (must end with a forward slash
define('PHEAL_APIBASE','https://api.eveonline.com/');

//certificate validation
define('PHEAL_VERIFYPEER',TRUE);


//
// SDE Value constants (don't change unless the SDE changes)
//

//from invCategories for ships
define('SHIP_CATEGORY', 6);

//module mappings file -- keep this up to date!
//each typeID in this file represents the root of an parent item tree
define('MAPPINGS_FILE','mapping.json');

?>