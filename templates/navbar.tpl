    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="index.php">{#GenericPageTitle#}</a>
		  <div class="nav-collapse collapse">
            <p class="navbar-text pull-right">
              <a href="#">Login</a>
            </p>
            <ul class="nav">
              <li {* class="active" *}><a href="index.php?clear">Home</a></li>
              <li><a href="create_fleet.php">Create Fleet</a></li>
            </ul>
			{include file='themeselector.tpl' themes=$themes}
          </div><!--/.nav-collapse -->
		 
        </div>
      </div>
    </div>