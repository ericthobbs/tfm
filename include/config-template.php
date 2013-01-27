<?php
//Configuration file for Trivial Fleet Manager

//
// Database and Admin
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

//admin username password -- change this!
//any user with this name and password will get full admin rights
define('ADMIN_USERNAME','admin');
define('ADMIN_PASSWORD',"%$^^@#%^FDFDGGJKLDSGHJGHsdfhsas95620dskl.,.@$^&*$256i359592d");

//availible themes
define('THEMES_MAPPING','themes.json');

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

define('IMAGES_FILE','images.json');

//
//Hosted 3rd Party apis
//

//you may adjust these to whatever cdn you would like to use or to a local path if you so prefer
define('JQUERY_JS','http://code.jquery.com/jquery-1.9.0.js');
define('JQUERYUI_JS','http://code.jquery.com/ui/1.10.0/jquery-ui.js');
define('JQUERYCSS_THEMEDIR','http://code.jquery.com/ui/1.10.0/themes');

define('CCPSHIPVIEWER_URL','http://web.ccpgamescdn.com/shipviewer/ccp.shipviewer-0.989.min.js');
define('CCPMAPVIEWER_URL','http://web.ccpgamescdn.com/starmap/ccp.starmap-0.9843.min.js');
define('CCPMAPTHREEJS_URL','http://web.ccpgamescdn.com/common/three.r44.js');

?>