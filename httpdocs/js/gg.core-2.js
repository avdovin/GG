//    FUNCTIONS
//	  GG.togglePopup(id)
//	  GG.addClass(obj, class)		// non-jQuery
//	  GG.removeClass(obj, class) 	// non-jQuery
//	  GG.setCookie(obj, class) 		// non-jQuery
//	  GG.getCookie(obj, class) 		// non-jQuery
//	  GG.delCookie(obj, class) 		// non-jQuery

//	  GG.isEmpty(obj) 				// check exist object keys
//	  GG.setUrlQs(qsArray, title)   // set data in url query string
//
//	  GG.isMobile // non-jQuery, see function

var GG = function(){
	var $self = this;

	$self.version = '2.22';

	$self.debug = function(arg){
		if (typeof arg != 'undefined') {
			$self.DEBUG = arg ? true : false;
		} else {
			return $self.DEBUG;
		}

		return $self.DEBUG;
	};

	$self.init = function(options){
		if (typeof $self.INIT != 'undefined') return this;

		var settings = {
			local: false,
			debug: false,
			setcurrent: false,
			optimize: false
		}

		if (options) {
			for (var option in options) {
				if (options.hasOwnProperty(option)) {
					settings[option] = options[option];
				}
			}
		}

		$self.DEBUG = settings.debug ? true : false;
		$self.LOCAL = settings.local ? true : false;

		if (settings.setcurrent) $self.setCurrent();
		if (settings.autocurrent) $self.startAutoCurrentToggler();
		if (settings.optimize) $self.optimize();

		if (typeof settings.afterLoad == 'function') {
			$self.afterLoad = options.afterLoad;
			$(document).ready(function(){
				$self.afterLoad();
			})
		}

		$self.INIT  = true;

		// GG options getter
		$self.options = function(key){
			return settings[key] || null;
		}

		return this;
	};

	$self.log = function(msg){
		if($self.DEBUG && window.console && window.console.log){
			window.console.log('DEBUG:', msg);
		}
	};

	$self.isEmpty = function(obj){
		return Object.keys(obj).length === 0;
	}

	$self.historyBackupUrl = function(){
		window._history_backup_url = location.protocol + '//' + location.host + location.pathname + window.location.search;
		window._history_backup_title = document.title;
	}

	$self.historyRestoreUrl = function(){
		var title = window._history_backup_title ? window._history_backup_title : document.title;
		var url = window._history_backup_url ? window._history_backup_url : location.protocol + '//' + location.host + location.pathname + window.location.search;
		if (typeof History.pushState != 'undefined') History.pushState({}, title, url);
	}

	$self.setUrlQs = function(qsArray, title) {
		if (!History) return false;
		if (typeof title == 'undefined') title = document.title;

		var pairs = [];
		var filter = jQuery.extend({}, qsArray);
		for (var key in filter)
			if (filter.hasOwnProperty(key))
				pairs.push(encodeURIComponent(key) + '=' + encodeURIComponent(filter[key]));

		History.pushState(filter, title, location.protocol + '//' + location.host + location.pathname + '?'+pairs.join('&'));
	};

	$self.attachForm = function(formWrapper, handle, options) {
		if (typeof formWrapper == 'undefined' || !$(formWrapper).length ) return false;

		var $parent  = $(formWrapper),
			$form 	 = $parent.find('form'),
			$loading = $parent.find(".form__loading"),
			$wrapper = $parent.find(".form__wrapper"),
			$error   = $parent.find(".form__error");
		var defaults = {
			type: $form.attr('method'),
			url: $form.attr('action'),
			data: $form.serialize(),
			beforeSend: function(){
				$loading.fadeIn();
			},
			beforeSubmit: function(){},
			onDone: function($wrapper, $error, data){
				$error.hide();

				var old_height = $wrapper.height(),
					new_height = 0;

				$wrapper.html(data.message_success);
				new_height = $wrapper.height();
				$wrapper.height(old_height).animate({height: new_height});
			}
		};

		var settings = $.extend(defaults, options);

		if (!$(formWrapper).data("formAttached")) {
			$(document).on("click", handle, function(){
				settings.beforeSubmit();
				settings.data = $form.serialize();

				$.ajax(settings).done(function(data) {
					if ($self.LOCAL) { // этот блок нужен для отладки ajax-запроса на машине без сервера
						var data = {
							message_success: '<h3>Запрос выполнен (локаль)<br/>DEBUG MODE ON</h3>'
						}
						settings.onDone($wrapper, $error, data);
					} else {
						if(!$self.isEmpty(data.errors || {})){
							var errors  = data.errors;
							var errorText = '';

							$error.html("<ul></ul>");

							$parent.find("*").removeClass("field__input_error").removeClass("error");

							for (var error in errors) {
								if (errors.hasOwnProperty(error)) {
									// add classes
									$parent.find("input[name="+error+"], textarea[name="+error+"], select[name="+error+"]").closest("label").addClass("error").end().addClass("field__input_error").addClass("error");

									// fill errors container
									$("<li/>").html(errors[error]).appendTo($error.find("ul"));
								}
							}

							$error.show();
						} else {
							settings.onDone($wrapper, $error, data);
						}
					}
				}).always(function(){
					$loading.fadeOut();
				}).fail(function(jqXHR, textStatus, errorThrown) {
					if ($self.LOCAL) { // этот блок нужен для отладки ajax-запроса на машине без сервера
						var old_height = $wrapper.height(),
							new_height = 0;

						$wrapper.html("<h3>Запрос выполнен (локаль)<br/>DEBUG MODE ON</h3>");
						new_height = $wrapper.height();
						$wrapper.height(old_height).animate({height: new_height});
					} else {
						$error.html(jqXHR.statusText).show();
					}
				});

				return false;
			});

			$self.log("Form ["+formWrapper+"] attached.");
		} else {
			$self.log("Form ["+formWrapper+"] already attached, skipping.");
		}

		$(formWrapper).data("formAttached", 1);
	};

	$self.setCurrent = function(element) {
		if (typeof getElementsByClass == 'undefined') {
			if(document.getElementsByClassName) {
				getElementsByClass = function(classList, node) {
					return (node || document).getElementsByClassName(classList);
				}
			} else {
				getElementsByClass = function(classList, node) {
					var node	   = node || document,
						list	   = node.getElementsByTagName('*'),
						length	 = list.length,
						classArray = classList.split(/\s+/),
						classes	= classArray.length,
						result	 = [], i,j;

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
			if (element.className.split(/\s+/)[0] != 'current') $self.addClass(element, element.className.split(/\s+/)[0]+'_current');
			if (element.className.split(/\s+/).length > 1) $self.removeClass(element, 'current');
		} else {
			var currents = Array.prototype.slice.call(getElementsByClass('current'));
			for (var i = 0, k = currents.length; i < k; i++) {
				if (typeof currents[i] != 'undefined') {
					if (currents[i].className.split(/\s+/)[0] != 'current') $self.addClass(currents[i], currents[i].className.split(/\s+/)[0]+'_current');
					if (currents[i].className.split(/\s+/).length > 1) $self.removeClass(currents[i], 'current');
				}
			}
		}
	};

	$self.startAutoCurrentToggler = function(element) {
		$(function(){
			if (typeof element == 'undefined') element = $("body");

			if (!$self.TOGGLE) $self.TOGGLE = true;

			element.on("mouseup", "a", function(e){
				var $parent  = $(this).parent(),
					$wrapper = $parent.parent(),
					regexp   = new RegExp( "^(.+)_current$", "i");

				if ($(this).data("dispatch") && $($(this).data("dispatch")).length > 0) {
					$parent  = $(this).closest($(this).data("dispatch")),
					$wrapper = $parent.parent();
				}

				// check if parent is only one of class
				var parentBlockClass = $parent[0].className.split(/\s+/), parentBlockClass = parentBlockClass[0],
					thisBlockClass   = $(this)[0].className.split(/\s+/), thisBlockClass   = thisBlockClass[0],
					flagNotSingle	= true;

				// if (!thisBlockClass || !parentBlockClass.length || ($("."+parentBlockClass+":visible").length == 1 && $("."+parentBlockClass+" ."+thisBlockClass+":visible").length == 1)) {
				if (!thisBlockClass || (parentBlockClass.length && $("."+parentBlockClass+":visible").length == 1 && $("."+parentBlockClass+" ."+thisBlockClass+":visible").length == 1)) {
					flagNotSingle = false;
				}
				//

				// check if parent is '.content'
				var flagNotContent = true;
				//if ($(this).closest(".content").length > 0) {
				//flagNotContent = false;
				//console.log("Link is in 'content', auto 'current' toggle off");
				//}

				// check if one of parents are '.noautocurrent'
				var flagNoAutoCurrent = false;
				if ($(this).closest(".noautocurrent").length > 0) {
					flagNoAutoCurrent = true;
					$self.log("."+$(this).closest(".nouncurrent")[0].className.split(/\s+/)[0] + ": Autocurrent is toggled off for this container");
				}

				// check if one of parents are '.nouncurrent'
				var flagNoUnCurrent = false;
				if ($(this).closest(".nouncurrent").length > 0) {
					flagNoUnCurrent = true;
					$self.log("."+$(this).closest(".nouncurrent")[0].className.split(/\s+/)[0] + ": Uncurrent is toggled off for this container");
				}

				// check if toggle is turned on
				var flagToggleCurrent = false;
				if ($(this).closest(".togglecurrent").length > 0) {
					flagToggleCurrent = true;
				}

				var flagIsCurrent = false;
				if (regexp.test($(this)[0].className) || (regexp.test($parent[0].className) && flagNotSingle)) {
					flagIsCurrent = true;

					if (!flagToggleCurrent) {
						$self.log("Link state is 'current', aborting");

						// let other handles know
						var $me = $(this);
						$me.data("breakEvent", 1);

						var removeAbort = function(){
							$me.data("breakEvent", 0);
						}

						setTimeout(removeAbort, 100);
						//

						return false;
					}
				}

				// auto "current" toggle
				// current element getting data-current="true"
				if (!$(this).data("noautocurrent") && flagNotSingle && flagNotContent && (typeof flagNoAutoCurrent != 'undefined' && !flagNoAutoCurrent || typeof flagNoAutoCurrent == 'undefined')) {

					// toggle currents for parent
					var parentFirstClass  = $parent[0].className.split(/\s+/)[0],
						parentCurrents = [];

					if (parentBlockClass.length && $("."+parentBlockClass+":visible").length > 1 && $(this).closest("."+parentFirstClass).parent().find("."+parentBlockClass).length > 1) { // only if parent are not only one
						if (!flagNoUnCurrent) $wrapper.find("."+parentFirstClass+"_current").removeClass(parentFirstClass+"_current").data("current", false);

						if (flagNoUnCurrent && flagIsCurrent && flagToggleCurrent) {
							$(this).closest("."+parentFirstClass+"_current").removeClass(parentFirstClass+"_current").data("current", false);
						}

						if (!flagToggleCurrent || !flagIsCurrent) {
							parentCurrents.push(parentFirstClass+"_current");

							for (var i = 0, k = parentCurrents.length; i < k; i++) {
								$parent.addClass(parentCurrents[i]).data("current", true);
							}
						}
					}

					// child loop (toggle currents for child)
					var childFirstClass  = $(this)[0].className.split(/\s+/)[0],
						childCurrents	= [],
						parent		   = parentBlockClass.length ? $(this).parent().parent() : $(this).parent();

					if ($(this).data("dispatch") && $($(this).data("dispatch")).length > 0) {
						parent  = $(this).closest($(this).data("dispatch"));
					}

					if (!flagNoUnCurrent) $("."+childFirstClass+"_current", parent).removeClass(childFirstClass+"_current").data("current", false);

					if (flagNoUnCurrent && flagIsCurrent && flagToggleCurrent) {
						$("."+childFirstClass+"_current", parent).removeClass(parentFirstClass+"_current").data("current", false);
					}

					if (!$(this).data("dispatch") && (!flagToggleCurrent || !flagIsCurrent)) {
						childCurrents.push(childFirstClass+"_current");

						for (var i = 0, k = childCurrents.length; i < k; i++) {
							$(this).addClass(childCurrents[i]).data("current", true);
						}
					}
				}
			});

			// prevent default if href is # or empty
			element.on("click", "a", function(e){
				var href = $(this).attr("href");
				if (href == '#' || href == '') {
					e.preventDefault();
				}
			});
			//
		});
	};

	// popup
	$(function(){
		$("html").data("width", $("html").width());

		$("body").on("click", ".popup .popup-close, .popup .popup__close", function(){
			$self.historyRestoreUrl();
			$self.togglePopup($(this).closest(".popup").attr("id"));
			return false;
		});

		$(document).keyup(function(e) {
			if (e.keyCode == 27) {
				$self.togglePopup();
			} else if (e.keyCode == 37) {
				$(".popup:visible").find(".popup__prev:visible").click();
			} else if (e.keyCode == 39) {
				$(".popup:visible").find(".popup__next:visible").click();
			}
		});

		// disable scrolling of BODY (instead of POPUP) on mobiles
		var touchStartEvent;
		$("body").on("touchstart", ".popup", function(e){
			touchStartEvent = e;
		}).on("touchmove", ".popup", function(e){
				if ((e.originalEvent.pageY > touchStartEvent.originalEvent.pageY && this.scrollTop == 0) ||
					(e.originalEvent.pageY < touchStartEvent.originalEvent.pageY && this.scrollTop + this.offsetHeight >= this.scrollHeight))
					e.preventDefault();
			});
	});

	$self.togglePopup = function(id) {

		// hide visible popups if no ID specified
		if (typeof id == 'undefined') {
			$(".popup:visible").each(function(){
				$self.togglePopup($(this).attr("id"));
			});
			return;
		}

		// do nothing if element not exist
		if (!$("#"+id).length) return;

		// hide popup
		if ($("#"+id).is(":visible")) {
			if (!$("#"+id).is("table")) { // if not table toggle overflow
				$("html").css("overflow", "");

				var togglePopupSettings = $self.options("togglePopup");

				if (togglePopupSettings && togglePopupSettings.elements.length > 0) {
					for (var i = 0, k = togglePopupSettings.elements.length; i < k; i++) {
						if (typeof togglePopupSettings.attr == 'undefined') {
							$(togglePopupSettings.elements[i]).css("padding-right", "");
						} else {
							if (typeof togglePopupSettings.attr == 'string') {
								$(togglePopupSettings.elements[i]).css(togglePopupSettings.attr, "");
							} else if (typeof togglePopupSettings.attr == 'object' && togglePopupSettings.attr.length == togglePopupSettings.elements.length) {
								$(togglePopupSettings.elements[i]).css(togglePopupSettings.attr[i], "");
							} else {
								$(togglePopupSettings.elements[i]).css("padding-right", "");
							}
						}
					}
				} else {
					$(".wrapper").css("padding-right", "");
				}

			}

			$("#"+id).hide(); // no animation here!

			$(".topbar").css("z-index", "");

			// show popup
		} else {
			if (!$("#"+id).is("table")) { // if not table toggle overflow
				$("html").css("overflow", "hidden");

				var togglePopupSettings = $self.options("togglePopup");

				if (togglePopupSettings && togglePopupSettings.elements.length > 0) {
					for (var i = 0, k = togglePopupSettings.elements.length; i < k; i++) {
						if (typeof togglePopupSettings.attr == 'undefined') {
							$(togglePopupSettings.elements[i]).css("padding-right", $("html").width() - $("html").data("width"));
						} else {
							if (typeof togglePopupSettings.attr == 'string') {
								$(togglePopupSettings.elements[i]).css(togglePopupSettings.attr, $("html").width() - $("html").data("width"));
							} else if (typeof togglePopupSettings.attr == 'object' && togglePopupSettings.attr.length == togglePopupSettings.elements.length) {
								$(togglePopupSettings.elements[i]).css(togglePopupSettings.attr[i], $("html").width() - $("html").data("width"));
							} else {
								$(togglePopupSettings.elements[i]).css("padding-right", $("html").width() - $("html").data("width"));
							}
						}
					}
				} else {
					$(".wrapper").css("padding-right", $("html").width() - $("html").data("width"));
				}

			} else {
				if (typeof jQuery.fn.mousewheel != 'undefined') $("#"+id).mousewheel(function(){
					return;
				});
			}

			$("#"+id).show(); // no animation here!

			$(".topbar").css("z-index", 1000);
		}
	}
	//

	// optimizer
	// thansforms html to string for elements with .optimize, when not in view
	$self.optimize = function(){
		$(function(){
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
		})
	};

	// $self.notify = function(text, title, options){
	// 	if (typeof title == 'undefined') title = 'Товар добавлен в корзину';

	// 	var stackContainer, messageWrap, messageBox, messageBody, messageTextBox, messagePicture, image;

	// 	options = $.extend({
	// 		lifeTime: 		4000,
	// 		click: 			undefined,
	// 		icon: 			'add'
	// 	}, options);

	// 	// находим контейнер с сообщениями, если его нет, тогда создаём
	// 	stackContainer = $('#notifier-box');
	// 	if (!stackContainer.length) {
	// 		stackContainer = $('<div>', {id: 'notifier-box'}).prependTo(document.body);
	// 	}

	// 	// создаём элементы вертски контейнера сообщения
	// 	messageWrap    = $('<div>',  {'class': 'message-wrap', 'css': { 'display': 'none'}});
	// 	messageBox     = $('<div>',  {'class': 'message-box'});
	// 	messageHeader  = $('<div>',  {'class': 'message-header', 'text': title});
	// 	messageBody    = $('<div>',  {'class': 'message-body'});
	// 	messageTextBox = $('<span>', {'html': text});

	// 	closeButton = $('<a>', {
	// 		'class': 'message-close',
	// 		href: 'javascript:void(0);',
	// 		title: 'Закрыть',
	// 		click: function() {
	// 			$(this).parent().parent().fadeOut(300, function() {
	// 				$(this).remove();
	// 			});
	// 		}
	// 	});

	// 	// теперь расположим все на свои места
	// 	messageWrap.appendTo(stackContainer).fadeIn();
	// 	messageBox.appendTo(messageWrap);
	// 	closeButton.appendTo(messageBox);
	// 	messageHeader.appendTo(messageBox);
	// 	messageBody.appendTo(messageBox);

	// 	messagePicture = $('<div>', {'class': 'thumb'});

	// 	var notifyIcon = options.icon;
	// 	if(notifyIcon){
	// 		image = $('<img>', {
	// 			src: 	'/img/core/notify/notify_'+notifyIcon+'.png',
	// 			widht: 	48,
	// 			height: 48
	// 		});
	// 	}
	// 	messagePicture.appendTo(messageBody);
	// 	image.appendTo(messagePicture);

	// 	messageTextBox.appendTo(messageBody);

	// 	// если время жизни уведомления больше 0, ставим таймер
	// 	if (options.lifeTime > 0) {
	// 		setTimeout(function() {
	// 			$(messageWrap).fadeOut(300, function() {
	// 				$(this).remove();
	// 			});
	// 		}, options.lifeTime);
	// 	}

	// 	// если установлен колбек
	// 	if (options.click != undefined) {
	// 		messageWrap.click(function(e) {
	// 			if (!jQuery(e.target).is('.message-close')) {
	// 				options.click.call(this);
	// 			}
	// 		});
	// 	}

	// 	return this;
	// };
	// $self.notify_warning = function(text, title, options){
	// 	if (typeof title == 'undefined') title = 'Уведомление';
	// 	options = $.extend({
	// 		icon : 'warning'
	// 	}, options);

	// 	$self.Notify(text, title, options);
	// };
	// $self.notify_add = function(text, title, options){
	// 	if (typeof title == 'undefined') title = 'Товар добавлен в корзину';
	// 	options = $.extend({
	// 		icon : 'add'
	// 	}, options);
	// 	$self.Notify(text, title, options);
	// };
	// $self.notify_delete = function(text, title, options){
	// 	if (typeof title == 'undefined') title = 'Изменения в корзине';
	// 	options = $.extend({
	// 		icon : 'delete'
	// 	}, options);
	// 	$self.Notify(text, title, options);
	// };

	// new version of Notifier
	$self.Notify = function(){
		var params = {};

		if (typeof arguments[0] == 'object') { // if object {} - new version
			params = {
				title:   arguments[0].title   || '',
				text:    arguments[0].text    || '',
				options: arguments[0].options || {},
			};
		} else if (typeof arguments[0] == 'string' && (!arguments[1] || typeof arguments[1] == 'string' || typeof arguments[1] == 'object')) { // combo

			switch (typeof arguments[1]) {
				case 'string':
					params.text = arguments[1];

					if (arguments[2] && typeof arguments[2] == 'string') {
						params.title = arguments[2];
					}

					if (arguments[3] && typeof arguments[3] == 'object') {
						params.options = arguments[3];
					}

					break;

				case 'object':
					params = $.extend(params, arguments[1]);
					break;

				case 'undefined':
					break;
			}

			switch (arguments[0]) {
				case 'add':
					$self.log('Notify: add');

					if (!params.title) params.title = 'Товар добавлен в корзину';
					params.options = $.extend(params.options, {icon : 'add'});

					break;
				case 'delete':
					$self.log('Notify: delete');

					if (!params.title) params.title = 'Изменения в корзине';
					params.options = $.extend(params.options, {icon : 'delete'});

					break;
				case 'warning':
					$self.log('Notify: warning');

					if (!params.title) params.title = 'Уведомление';
					params.options = $.extend(params.options, {icon : 'warning'});

					break;
				case 'notify_add':
					$self.log('Notify: add');

					if (!params.title) params.title = 'Товар добавлен в корзину';
					params.options = $.extend(params.options, {icon : 'add'});

					break;
				case 'notify_delete':
					$self.log('Notify: delete');

					if (!params.title) params.title = 'Изменения в корзине';
					params.options = $.extend(params.options, {icon : 'delete'});

					break;
				case 'notify_warning':
					$self.log('Notify: warning');

					if (!params.title) params.title = 'Уведомление';
					params.options = $.extend(params.options, {icon : 'warning'});

					break;

				default:
					$self.log('Notify: warning');
					params.text  = arguments[0];
					params.title = arguments[1];

					break;
			}
		} else if (arguments[1]) { // old version, deprecated
			params = {
				text:    arguments[0] || '',
				title:   arguments[1] || '',
				options: arguments[2] || {},
			};
		}

		if (!params.title) params.title = 'Товар добавлен в корзину';

		var stackContainer, messageWrap, messageBox, messageBody, messageTextBox, messagePicture, image;

		params.options = $.extend({
			lifeTime: 		4000,
			click: 			undefined,
			icon: 			'add'
		}, params.options);

		// находим контейнер с сообщениями, если его нет, тогда создаём
		stackContainer = $('#notifier-box');
		if (!stackContainer.length) {
			stackContainer = $('<div>', {id: 'notifier-box'}).prependTo(document.body);
		}

		// создаём элементы вертски контейнера сообщения
		messageWrap    = $('<div>',  {'class': 'message-wrap', 'css': { 'display': 'none'}});
		messageBox     = $('<div>',  {'class': 'message-box'});
		messageHeader  = $('<div>',  {'class': 'message-header', 'text': params.title});
		messageBody    = $('<div>',  {'class': 'message-body'});
		messageTextBox = $('<span>', {'html': params.text});

		closeButton = $('<a>', {
			'class': 'message-close',
			href: 'javascript:void(0);',
			title: 'Закрыть',
			click: function() {
				$(this).parent().parent().fadeOut(300, function() {
					$(this).remove();
				});
			}
		});

		// теперь расположим все на свои места
		messageWrap.appendTo(stackContainer).fadeIn();
		messageBox.appendTo(messageWrap);
		closeButton.appendTo(messageBox);
		messageHeader.appendTo(messageBox);
		messageBody.appendTo(messageBox);

		messagePicture = $('<div>', {'class': 'thumb'});

		var notifyIcon = params.options.icon;
		if(notifyIcon){
			image = $('<img>', {
				src: 	'http://s3-eu-west-1.amazonaws.com/ifrogcdn/img/core/notify/notify_'+notifyIcon+'.png',
				widht: 	48,
				height: 48
			});
		}
		messagePicture.appendTo(messageBody);
		image.appendTo(messagePicture);

		messageTextBox.appendTo(messageBody);

		// если время жизни уведомления больше 0, ставим таймер
		if (params.options.lifeTime > 0) {
			setTimeout(function() {
				$(messageWrap).fadeOut(300, function() {
					$(this).remove();
				});
			}, params.options.lifeTime);
		}

		// если установлен колбек
		if (params.options.click != undefined) {
			messageWrap.click(function(e) {
				if (!jQuery(e.target).is('.message-close')) {
					params.options.click.call(this);
				}
			});
		}
	};

	// deprecated in 3.0
	$self.notify         = $self.Notify;
	$self.notify_add     = function(){$self.Notify('add', {text: arguments[0], title: arguments[1], options: arguments[2]})};
	$self.notify_delete  = function(){$self.Notify('delete', {text: arguments[0], title: arguments[1], options: arguments[2]})};
	$self.notify_warning = function(){$self.Notify('warning', {text: arguments[0], title: arguments[1], options: arguments[2]})};
	//

	$self.addClass = function(o, c){
		var re = new RegExp("(^|\\s)" + c + "(\\s|$)", "g")
		if (re.test(o.className)) return;
		o.className = (o.className + " " + c).replace(/\s+/g, " ").replace(/(^ | $)/g, "");
	};

	$self.removeClass = function(o, c){
		var re = new RegExp("(^|\\s)" + c + "(\\s|$)", "g");
		o.className = o.className.replace(re, "$1").replace(/\s+/g, " ").replace(/(^ | $)/g, "");
	};

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
	};

	$self.setCookie = function(name, value, expires, path, domain, secure) {
		document.cookie = name + "=" + escape(value) +
			((expires) ? "; expires=" + expires : "") +
			((path) ? "; path=" + path : "") +
			((domain) ? "; domain=" + domain : "") +
			((secure) ? "; secure" : "");
	};

	$self.delCookie = function(name) {
		//document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
		setCookie(name, '', 'Thu, 01 Jan 1970 00:00:01 GMT', '/');
	};


	if (typeof String.prototype.trimLeft !== "function") {
		String.prototype.trimLeft = function() {
			return this.replace(/^\s+/, "");
		};
	};

	if (typeof String.prototype.trimRight !== "function") {
		String.prototype.trimRight = function() {
			return this.replace(/\s+$/, "");
		};
	};

	if (typeof Array.prototype.map !== "function") {
		Array.prototype.map = function(callback, thisArg) {
			for (var i=0, n=this.length, a=[]; i<n; i++) {
				if (i in this) a[i] = callback.call(thisArg, this[i]);
			}
			return a;
		};
	};

	$self.getCookies = function() {
		var c = document.cookie, v = 0, cookies = {};
		if (document.cookie.match(/^\s*\$Version=(?:"1"|1);\s*(.*)/)) {
			c = RegExp.$1;
			v = 1;
		}
		if (v === 0) {
			c.split(/[,;]/).map(function(cookie) {
				var parts = cookie.split(/=/, 2),
					name = decodeURIComponent(parts[0].trimLeft()),
					value = parts.length > 1 ? decodeURIComponent(parts[1].trimRight()) : null;
				cookies[name] = value;
			});
		} else {
			c.match(/(?:^|\s+)([!#$%&'*+\-.0-9A-Z^`a-z|~]+)=([!#$%&'*+\-.0-9A-Z^`a-z|~]*|"(?:[\x20-\x7E\x80\xFF]|\\[\x00-\x7F])*")(?=\s*[,;]|$)/g).map(function($0, $1) {
				var name = $0,
					value = $1.charAt(0) === '"'
						? $1.substr(1, -1).replace(/\\(.)/g, "$1")
						: $1;
				cookies[name] = value;
			});
		}
		return cookies;
	};

	$self.getCookie = function(name) {
		return getCookies()[name];
	};

	$self.isMobile = {
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
			return ($self.isMobile.Android() || $self.isMobile.BlackBerry() || $self.isMobile.iOS() || $self.isMobile.Windows());
		}
	};

	jQuery.fn.getPath = function () {
		if (this.length != 1) throw 'Requires one element.';

		var path, node = this;
		while (node.length) {
			var realNode = node[0], name = realNode.localName;
			if (!name) break;
			name = name.toLowerCase();

			var parent = node.parent();

			var siblings = parent.children(name);
			if (siblings.length > 1) {
				name += ':eq(' + siblings.index(realNode) + ')';
			}

			path = name + (path ? '>' + path : '');
			node = parent;
		}

		return path;
	};

};
