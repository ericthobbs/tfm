<!DOCTYPE html>
{config_load file='application.conf'}
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta charset="UTF-8" />
	<title>{$smarty.config.GenericPageTitle}</title>
	<link rel="stylesheet" href="css/core.css" type="text/css"/>
	<link rel="stylesheet" href="css/style-light.css" type="text/css"/>
	{include file='jquery.tpl'}
	{include file='bootstrap.tpl'}
</head>
<body>
	{include file='navbar.tpl'}
<a href="https://github.com/ericthobbs/tfm">
	<img style="position: absolute; top: 1; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png" alt="Fork me on GitHub"/></a>	
    <div class="container-fluid">
      <div class="row-fluid">
        <div class="span3">
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="nav-header">Active Fleets</li>
			  {foreach from=$fleets item=i}
					<li><a href="join_fleet.php?join_fleet={$i.fleet_id}"
						   title="Commanded by: {$i.fc_name}">{$i.fleet_name|truncate:24:"...":true}</a></li>
			  {foreachelse}
					<li><a href="create_fleet.php">No fleets, create one now</a></li>
			  {/foreach}
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
        <div class="span9">
          <div class="hero-unit">
            <h1>{#GenericPageTitle#}</h1>
            <p>{#GenericPageTitle#} is a tool designed to help FCs and fleet bosses manage large fleets.</p>
			<p>{#GenericPageTitle#} is currently undergoing rapid development.</p>
          </div>
        </div><!--/span-->
      </div><!--/row-->
	{include file='footer.tpl'}
    </div><!--/.fluid-container-->	
</body>
</html>
