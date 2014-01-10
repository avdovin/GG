// core.js
var DEBUG_MODE = true;
var debugLog = function(message){
	if(DEBUG_MODE && window.console && window.console.log) {
		window.console.log('DEBUG:', message);
	}
}

$.GG = {
	core: {
		version: 1.12
	}
};

function setFilterInUrl(filter, title){
	if(typeof(title) == 'undefined') title = document.title;

	var pairs = [];
	var filter = jQuery.extend({}, filter);
	for (var key in filter)
		if (filter.hasOwnProperty(key))
			pairs.push(encodeURIComponent(key) + '=' + encodeURIComponent(filter[key]));

	History.pushState(filter, title, location.protocol + '//' + location.host + location.pathname + '?'+pairs.join('&'));
}


function addFormErrors($form, errors, $errors){
	var errstr = buildErrorStr(errors);

	if(typeof($errors) == 'undefined') $errors = $form.find('.popup-error');

	$errors.html(errstr).show();
	$form.find("[name]").removeClass('error');
	for(var key in errors){
		if( $form.find("[name='"+key+"']").length ) $form.find("[name='"+key+"']").addClass('error');
	}
}

function buildErrorStr(arr){
	var str = '';
	for(var key in arr){
		str += '<li>'+arr[key]+'</li>';
	}

	return '<ul>'+str+'<li>';
}

function buildServerErrorsString(arr){
	var str = '';
	for(var key in arr){
		str += '<li>'+arr[key]+'</li>';
	}

	return '<ul>'+str+'<li>';
}

(function(){
	// toggle "current" state for all elements with ".current" class if no element specified,
	// to add ".current" class and toggle "current" state for one element, just do: setCurrent(DOMelement);
	// example: setCurrent($(this)[0]);
	setCurrent();
})();

$(function(){

	// popup settings
	$("html").data("width", $("html").width());

	$("body").on("click", ".popup-close", function(){
		togglePopup($(this).closest(".popup").attr("id"));
		return false;
	});

	$(document).keyup(function(e) {
		if (e.keyCode == 27) {
			var $popups = $(".popup:visible");
			if ($popups.length == 1) togglePopup($popups.attr("id"));
		}
	});
	//

	// phone mask
	if (typeof jQuery.fn.mask != 'undefined' && $(".field__input_phone").length) $(".field__input_phone").mask('+7 (000) 000-00-00');
	//

	// disable link if its state is 'current'
	// auto toggle 'current'
	// data-noautocurrent="true" on link to disable auto 'current' toggle
	$("body").on("mouseup touchend", "a", function(e){
		var $parent  = $(this).parent(),
			$wrapper = $parent.parent(),
			regexp   = new RegExp( "^(.+)_current$", "i");

		// check if parent is only one of class
		var parentBlockClass = $parent[0].className.split(/\s+/), parentBlockClass = parentBlockClass[0],
			thisBlockClass   = $(this)[0].className.split(/\s+/), thisBlockClass   = thisBlockClass[0],
			flagNotSingle    = true;

		if (!thisBlockClass || !parentBlockClass.length || ($("."+parentBlockClass+":visible").length == 1 && $("."+thisBlockClass+":visible").length == 1)) {
			flagNotSingle = false;
		}
		//

		// check if parent is '.content'
		var flagNotContent = true;
		if ($(this).closest(".content").length > 0) {
			//flagNotContent = false;
			//console.log("Link is in 'content', auto 'current' toggle off");
		}

		// check if one of parents are '.noautocurrent'
		var flagNoAutoCurrent = false;
		if ($(this).closest(".noautocurrent").length > 0) {
			flagNoAutoCurrent = true;
			console.log("Autocurrent is toggled off for this container");
		}

		if (regexp.test($(this)[0].className) || (regexp.test($parent[0].className) && flagNotSingle)) {
			console.log("Link state is 'current', aborting");
			return false;
		}

		// auto "current" toggle
		// current element getting data-current="true"
		if (!$(this).data("noautocurrent") && flagNotSingle && flagNotContent && (typeof flagNoAutoCurrent != 'undefined' && !flagNoAutoCurrent || typeof flagNoAutoCurrent == 'undefined')) {
			// parent loop (toggle currents for parent)
			var parentClasses  = $parent[0].className.split(/\s+/),
				parentCurrents = [];

			if ($("."+parentBlockClass+":visible").length > 1) { // only if parent are not only one
				for (var i = 0, k = parentClasses.length; i < 1; i++) {
					$wrapper.find("."+parentClasses[i]+"_current").removeClass(parentClasses[i]+"_current").data("current", false);
					parentCurrents.push(parentClasses[i]+"_current");
				}

				for (var i = 0, k = parentCurrents.length; i < k; i++) {
					$parent.addClass(parentCurrents[i]).data("current", true);
				}
			}

			// child loop (toggle currents for child)
			var childClasses  = $(this)[0].className.split(/\s+/),
				childCurrents = [];

			for (var i = 0, k = childClasses.length; i < 1; i++) {
				$("."+childClasses[i]+"_current").removeClass(childClasses[i]+"_current").data("current", false);
				childCurrents.push(childClasses[i]+"_current");
			}

			for (var i = 0, k = childCurrents.length; i < k; i++) {
				$(this).addClass(childCurrents[i]).data("current", true);
			}
		}
	});
	//

	// prevent default if href is # or empty
	$("body").on("click", "a", function(e){
		var href = $(this).attr("href");
		if (href == '#' || href == '') {
			e.preventDefault();
		}

	});
	//

	// kartochka cloudZoom start
	if (typeof CloudZoom != 'undefined' && $(".cloudzoom").is(":visible")) CloudZoom.quickStart();

	// menu hover
	$(".menu .menu__entry").hover(
		function(){
			$(this).addClass("hover");
		},
		function(){
			$(this).removeClass("hover");
		}
	);

	// disable scrolling of BODY (instead of POPUP) on mobiles
	var touchStartEvent;
	$("body").on("touchstart", ".popup", function(e){
		touchStartEvent = e;
	}).on("touchmove", ".popup", function(e){
		if ((e.originalEvent.pageY > touchStartEvent.originalEvent.pageY && this.scrollTop == 0) ||
			(e.originalEvent.pageY < touchStartEvent.originalEvent.pageY && this.scrollTop + this.offsetHeight >= this.scrollHeight))
			e.preventDefault();
	});

	// optimizer
	// thansforms html to string for elements with .optimize, when not in view
	var $optimize = $(".optimize");
	$(window).on("scroll resize", function(){
		var height = $(window).height(),
			scroll = $(window).scrollTop();

		$optimize.each(function(){
			if ($(this).offset().top + $(this).height() < scroll || $(this).offset().top > height + scroll) {
				if (!$(this).data("html")) $(this).data("html", $(this).html()).html('&nbsp;');
			} else {
				$(this).html($(this).data("html")).removeData("html");
			}
		})
	});

});

function togglePopup(id) {
	// hide visible popups if no ID specified
	if (typeof id == 'undefined') {
		togglePopup($(".popup:visible").attr("id"));
		return false;
	}

	// do nothing if element not exist
	if (!$("#"+id).length) return false;

	// hide popup
	if ($("#"+id).is(":visible")) {
		if (!$("#"+id).is("table")) { // if not table toggle overflow
			$("html").css("overflow", "auto");
			$(".wrapper").css("padding-right", 0);
		}

		$("#"+id).hide(); // no animation here!

		$(".topbar").css("z-index", "");

	// show popup
	} else {
		if (!$("#"+id).is("table")) { // if not table toggle overflow
			$("html").css("overflow", "hidden");
			$(".wrapper").css("padding-right", $("html").width() - $("html").data("width"));
		} else {
			if (typeof jQuery.fn.mousewheel != 'undefined') $("#"+id).mousewheel(function(){
				return false;
			});
		}

		$("#"+id).show(); // no animation here!

		$(".topbar").css("z-index", 1000);
	}

	return false;
}

var log = function(msg){
	console.log(msg);
};

function setCurrent(element) {
	if (typeof getElementsByClass == 'undefined') {
		if(document.getElementsByClassName) {
			getElementsByClass = function(classList, node) {
				return (node || document).getElementsByClassName(classList);
			}
		} else {
			getElementsByClass = function(classList, node) {
				var node       = node || document,
					list       = node.getElementsByTagName('*'),
					length     = list.length,
					classArray = classList.split(/\s+/),
					classes    = classArray.length,
					result     = [], i,j;

				for(i = 0; i < length; i++) {
					for(j = 0; j < classes; j++)  {
						if(list[i].className.search('\\b' + classArray[j] + '\\b') != -1) {
							result.push(list[i]);
							break;
						}
					}
				}

				return result;
			}
		}
	}

	if (typeof element != 'undefined') {
		if (element.className.split(/\s+/)[0] != 'current') addClass(element, element.className.split(/\s+/)[0]+'_current');
		if (element.className.split(/\s+/).length > 1) removeClass(element, 'current');
	} else {
		var currents = Array.prototype.slice.call(getElementsByClass('current'));
		for (var i = 0, k = currents.length; i < k; i++) {
			if (typeof currents[i] != 'undefined') {
				if (currents[i].className.split(/\s+/)[0] != 'current') addClass(currents[i], currents[i].className.split(/\s+/)[0]+'_current');
				if (currents[i].className.split(/\s+/).length > 1) removeClass(currents[i], 'current');
			}
		}
	}
}

function addClass(o, c){
	var re = new RegExp("(^|\\s)" + c + "(\\s|$)", "g")
	if (re.test(o.className)) return;
	o.className = (o.className + " " + c).replace(/\s+/g, " ").replace(/(^ | $)/g, "");
}

function removeClass(o, c){
	var re = new RegExp("(^|\\s)" + c + "(\\s|$)", "g");
	o.className = o.className.replace(re, "$1").replace(/\s+/g, " ").replace(/(^ | $)/g, "");
}

if (!Array.prototype.indexOf) {
	Array.prototype.indexOf = function (obj, fromIndex) {
		if (fromIndex == null) {
			fromIndex = 0;
		} else if (fromIndex < 0) {
			fromIndex = Math.max(0, this.length + fromIndex);
		}
		for (var i = fromIndex, j = this.length; i < j; i++) {
			if (this[i] === obj)
				return i;
		}
		return -1;
	};
}

var isMobile = {
	Android: function() {
		return navigator.userAgent.match(/Android/i) ? true : false;
	},
	BlackBerry: function() {
		return navigator.userAgent.match(/BlackBerry/i) ? true : false;
	},
	iOS: function() {
		return navigator.userAgent.match(/iPhone|iPad|iPod/i) ? true : false;
	},
	Windows: function() {
		return navigator.userAgent.match(/IEMobile/i) ? true : false;
	},
	any: function() {
		return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Windows());
	}
};