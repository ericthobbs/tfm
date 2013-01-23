//Create the fixed size popup window
function CreateShipPopup(shipid)
{
	var LeftPosition = (screen.width) ? (screen.width-640)/2 : 0;
	var TopPosition = (screen.height) ? (screen.height-480)/2 : 0;
	var settings='height=480,width=640,top='+TopPosition+',left='+LeftPosition+
		',scrollbars=no,toolbar=no,resizeable=no,status=no,menubar=no,location=no,directories=no';
	
	var popupWindow = window.open("popup.php?shipid="+shipid,"Ship Viewer",settings);
	return popupWindow;
}

function CreateMapPopup()
{
	var LeftPosition = (screen.width) ? (screen.width-640)/2 : 0;
	var TopPosition = (screen.height) ? (screen.height-480)/2 : 0;
	var settings='height=480,width=640,top='+TopPosition+',left='+LeftPosition+
		',scrollbars=no,toolbar=no,resizeable=no,status=no,menubar=no,location=no,directories=no';
	
	var popupWindow = window.open("popup.php?starmap=kills","Ship Viewer",settings);
	return popupWindow;
}