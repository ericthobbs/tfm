===Directions===

1) Run sql commands from the database.sql file
2) copy include/config-template.php to include/config.php
2) edit include/config.php to match your settings.
3) update mapping.json if there have been changes to the modules in the SDE
4) copy the required eve icons from the eve image export to img/Icons/items/
5) Populate the database with the following tables from the eve static data export:
	invTypes, invGroups, invCategories, invMetaTypes

===Change Log===

1/13/2013: Version 1
	- Initial release
1/17/2013: Version 1.01
	- minor fixes and changes
	- removed the images from the repo
	- Added the ability to set a message of the day for the fleet.
	- Increased the length of the fleet name to 64
1/21/2012: Version 1.02
	- Changed layout to use bootstrap
	- minor bugfixes

===Requirements===

*) PHP 5.3+
*) MySQL
*) PHP PDO Extension

===License===

Code is licensed under the GPL v2