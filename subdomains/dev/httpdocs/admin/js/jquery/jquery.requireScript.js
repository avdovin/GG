/**
 * Script loader plugin 1.2.1
 *
 * Copyright (c) 2009 Filatov Dmitry (alpha@zforms.ru)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 */

(function($) {

//var scripts = [];

function loadScript(url, callback, context) {

	var script = loadedFiles[url] || (loadedFiles[url] = {
		loaded    : false,
		callbacks : []
	});

	if(script.loaded) {
		return callback.apply(context);
	}

	script.callbacks.push({
		fn      : callback,
		context : context
	});

	if(script.callbacks.length == 1) {
		$.ajax({
			type     : 'GET',
			url      : url,
			dataType : 'script',
			cache    : true,
			success  : function() {
				script.loaded = true;
				$.each(script.callbacks, function() {
					this.fn.apply(this.context);
				});
				script.callbacks.length = 0;
			}
		});
	}

}

$.requireScript = function(url, callback, context, options) {

	if(typeof options === 'undefined' && context && context.hasOwnProperty('parallel')) {
		options = context;
		context = window;
	}

	options = $.extend({ parallel : true }, options);

	if(!$.isArray(url)) {
		return loadScript(url, callback, context);
	}

	var counter = 0;

	// parallel loading
	if(options.parallel) {
		return $.each(url, function() {
			loadScript(this, function() {
				if(++counter == url.length) {
					callback.apply(context);
				}
			});
		});
	}

	// sequential loading
	(function() {
		if(counter == url.length) {
			return callback.apply(context);
		}
		loadScript(url[counter++], arguments.callee);
	})();

};

$.requireScript.registerLoaded = function(url) {
	$.each($.makeArray(url), function() {
		(loadedFiles[url] || (loadedFiles[url] = {})).loaded = true;
	});
};

})(jQuery);