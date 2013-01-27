<script type="text/javascript" src="{$smarty.const.CCPMAPVIEWER_URL}"></script>
<script type="text/javascript" src="{$smarty.const.CCPMAPTHREEJS_URL}"></script>
<script type="text/javascript" src="{$smarty.const.JQUERY_JS}"></script>
<div id="starmap"></div>
<script>
 {
            var webAPI = "http://www.eveonline.com/webapi";
            var sm = new CCPStarmap({
                views: [
{
			adapterFunc: ["adapterSecurity"]
			//dataSource: [webAPI+"/jsonp/jumps/last30days"],
            //adapterFunc: ["adapterJumpsMonth"] 
}
],
                defaultView: 0,
                parentElementId: 'starmap',
                height: 640,
                displayMenu: false,
                displayPopup: false,
                onSystemSelected: function(obj) { 
					console.dir(obj); 
				},
                onSystemDeselected: function(obj)
				{
					console.dir(obj);
				},
                onLoaded: function() 
				{
                    sm.selectSystem("{$systemname|default:'RF-GGF'}");
                }
            });
            //universe.initFullscreenButton(sm);
        }	
</script>