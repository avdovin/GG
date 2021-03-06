function JT_init() {
	$("a.jTip").click(function(){return false});
}

function JT_hide() {
	if($('#JT')) $('#JT').remove();
}

function JT_show(e,url,linkId,title){
	if (navigator.userAgent.indexOf("MSIE") != -1) e = event;
	if (title == false) title = "&nbsp;";
	var de = document.documentElement;
	var w = self.innerWidth || (de&&de.clientWidth) || document.body.clientWidth;
	var hasArea = w - getAbsoluteLeft(linkId);
	var clickElementy; 
	var clickElementx;

	if (navigator.userAgent.indexOf ("MSIE") == -1) { clickElementy = Math.ceil(e.screenY - (e.screenY - e.pageY)) - 3; }
	else { clickElementy = Math.ceil(e.screenY - window.screenTop) - 3; }

	var queryString = url.replace(/^[^\?]+\??/,'');
	var params = parseQuery( queryString );
	if (params['width'] === undefined) { params['width'] = 250 };
	if (params['link'] !== undefined) {
		   $('#' + linkId).bind('click',function(){ window.location = params['link'] });
		   $('#' + linkId).css('cursor','pointer');
	}
	
	if (hasArea>((params['width']*1)+75)) {
		if($("body")) $("body").append("<div id='JT' style='width:"+params['width']*1+"px'><div id='JT_arrow_left'></div><div id='JT_close_left'>"+title+"</div><div id='JT_copy'><div class='JT_loader'><div></div></div>");//right side
	} else {
		if($("body")) $("body").append("<div id='JT' style='width:"+params['width']*1+"px'><div id='JT_arrow_right' style='left:"+((params['width']*1)+1)+"px'></div><div id='JT_close_right'>"+title+"</div><div id='JT_copy'><div class='JT_loader'><div></div></div>");//left side
	}
	
	if (navigator.userAgent.indexOf ("MSIE") == -1) { clickElementx = Math.ceil(e.screenX - (e.screenX - e.pageX) + 20); }
	else { clickElementx = Math.ceil(e.screenX - window.screenLeft + 20); }

	if($('#JT')) {
	  $('#JT').css({left: clickElementx+"px", top: clickElementy+"px"});
	  $('#JT').show();
	  $('#JT_copy').load(url);
    }
}

function getElementWidth(objectId) {
	x = document.getElementById(objectId);
	return x.offsetWidth;
}

function getAbsoluteLeft(objectId) {
	// Get an object left position from the upper left viewport corner
	o = document.getElementById(objectId)
	oLeft = o.offsetLeft            // Get left position from the parent object
	while(o.offsetParent!=null) {   // Parse the parent hierarchy up to the document element
		oParent = o.offsetParent    // Get parent object reference
		oLeft += oParent.offsetLeft // Add parent left position
		o = oParent
	}
	return oLeft
}

function getAbsoluteTop(objectId) {
	// Get an object top position from the upper left viewport corner
	o = document.getElementById(objectId)
	oTop = o.offsetTop            // Get top position from the parent object
	while(o.offsetParent!=null) { // Parse the parent hierarchy up to the document element
		oParent = o.offsetParent  // Get parent object reference
		oTop += oParent.offsetTop // Add parent top position
		o = oParent
	}
	return oTop
}

function parseQuery ( query ) {
   var Params = new Object ();
   if ( ! query ) return Params; // return empty object
   var Pairs = query.split(/[;&]/);
   for ( var i = 0; i < Pairs.length; i++ ) {
      var KeyVal = Pairs[i].split('=');
      if ( ! KeyVal || KeyVal.length != 2 ) continue;
      var key = unescape( KeyVal[0] );
      var val = unescape( KeyVal[1] );
      val = val.replace(/\+/g, ' ');
      Params[key] = val;
   }
   return Params;
}

function blockEvents(evt) {
		   if (evt.target) {
              evt.preventDefault();
           } else {
              evt.returnValue = false;
           }
}