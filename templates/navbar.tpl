<div class="navbar navbar-fixed-top">
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
				{if !isset($smarty.session.authenticated)}
					<a href="login.php">Login</a>
				{else}
					<a href="login.php?logout">Logout</a>
				{/if}
            </p>
            <ul class="nav">
				{if isset($smarty.session.pilot)}
					<li><a href="index.php?clear">Clear Session</a></li>
				{else}
					<li><a href="create_fleet.php">Create Fleet</a></li>					
				{/if}
            </ul>
			{include file='themeselector.tpl' themes=$themes}
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>