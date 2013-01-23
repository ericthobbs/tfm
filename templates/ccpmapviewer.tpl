<script type="text/javascript" src="{$smarty.const.CCPMAPVIEWER_URL}"></script>
<script type="text/javascript" src="http://web.ccpgamescdn.com/common/three.r44.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></script>
<div id="starmap"></div>
<script>
 {
            var webAPI = "http://www.eveonline.com/webapi";
            var sm = new CCPStarmap({
                views: [
{
 adapterFunc: ["adapterSecurity"]
}
],
                defaultView: 0,
                parentElementId: 'starmap',
                height: 618,
                displayMenu: false,
                displayPopup: false,
                /* onSystemSelected: universe.starmapOnSystemSelected,
                onSystemDeselected: universe.starmapOnSystemDeselected, */
                onLoaded: function() {
                    //universe.starmapSelectPrespecifiedSystem(sm)
                }
            });
            //universe.initFullscreenButton(sm);
        }	
</script>