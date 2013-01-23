<div id="shipviewer" style="width: 640px; height: 480px;"></div>
<script type="text/javascript" src="{$smarty.const.CCPSHIPVIEWER_URL}"></script>
<script>
	var elemt = document.getElementById("shipviewer");
        var sv = new CCPShipViewer({
            parentElementId: 'shipviewer',
            height: 480,
            width: 640,
            assetsPath: 'http://web.ccpgamescdn.com/shipviewer/assets/',
            quality: 0,
            boosterGain: 0.6,
            showOverlay: true,
            defaultShip: '{$shipviewer_shipname|default:'Ishtar'}',
            onLoaded: function() {
			/*
                universe.shipViewerListShips(sv, 'Absolution');
                if (Modernizr.history) universe.shipviewerHistoryManager(sv, 'Absolution');
			*/
            },
            afterShipChanged: function(shipdata) {
			/*
                universe.setSelectedShip(shipdata);
			*/
            }
        });
</script>