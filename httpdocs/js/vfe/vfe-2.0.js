// Название:      Visual Front-end Editor
// Версия:        2.0
// Дата:          19.07.2012
// Кодинг:        Nikita Korobochkin
// Зависимости:   jQuery 1.7.2

var vfe = (function() {

    var $ = {

    	Homepath:	'/js/vfe/',
    	Cssfile:	'vfe-2.0.css',

    	Wrapper:	'html',					// Обертка сайта
    	Panel:		'vfe-panel',			// Идентификатор и объект верхней панели
    	Float:		'vfe-float',			// Идентификатор и объект плавающей панели редактирования
    	Dummies:	'.vfe-dummy',			// Класс для системных тегов, описывающих редактируемые поля
    	Message:	'vfe-msg',				// Идентификатор и объект всплывающих сообщений
    	Css:		'vfe-css',				// Идентификатор и объект редактора стилей

    	//Content:			'',
		//Content_source:		{},

    	user:		{
    					name:				getCookie("admin_login")
    				},

		settings:	{
						panelEditable:		getCookie("vfe-panel-editable") ? getCookie("vfe-panel-editable") : 0,
						panelVisibility:	getCookie("vfe-panel-visibility") ? getCookie("vfe-panel-visibility") : 1
					},

    	// Кнопки верхней панели
    	buttons:	{
    					ifrog: {
    						id:		"vfe-panel-ifrog",
    						href:	"http://www.ifrog.ru",
    						target:	"_blank"
    					},
    					admin: {
    						id:		"vfe-panel-admin",
    						href:	"/admin",
    						target:	"_blank",
    						title:	"Панель управления"
    					},
    					vfe: {
    						id:		"vfe-panel-wfe",
    						href:	"#",
    						title:	"Режим редактирования"
    					},/*
    					css: {
    						id:		"vfe-panel-css",
    						href:	"#",
    						title:	"Редактировать стили"
    					},*/
    					hide: {
    						id:		"vfe-panel-hide",
    						href:	"#",
    						title:	"Скрывать панель"
    					}
    				},

		// Кнопки плавающей панели
		float:		[
						{ 
							name:	"save",
							id:		"vfe-float-save",
							href:	"#",
							title:	"Сохранить изменения"
						},
						{
							name:	"cancel",
							id:		"vfe-float-cancel",
							href:	"#",
							title:	"Отменить изменения"
						},
						{
							name:	"undo",
							id:		"vfe-float-undo",
							href:	"#",
							title:	"Вернуть предыдущее состояние"
						},
						{
							name:	"redo",
							id:		"vfe-float-redo",
							href:	"#",
							title:	"Перейти к следующему состоянию"
						}
					],

		onEditOn:			[],	// Обработчики
		onEditOff:			[],	// событий
		onBeforeBlockInit:	[],	// для 
		onBlockMouseClick:	[], // модулей
		onBeforeCancel:		[], // 

		// Модули
		loadPlugins:		[],
		loadedPlugins:		[],
		plugins:			{
								functions:	{},
								sys:		{}
							}

    }; 


    $.Wrapper = jQuery($.Wrapper);
    $.Dummies = jQuery($.Dummies);

    var panelAnimation;
    var messageAnimation;


    // Публичные функции

    // Инициализация, построение
    $.init = function (options) {
    	if (options) jQuery.extend( $, options );

    	// Загружаем файл с основными стилями
    	var fileref = document.createElement('link');
  		fileref.setAttribute("type","text/css");
  		fileref.setAttribute("rel","stylesheet");
  		fileref.setAttribute("href", $.Homepath+$.Cssfile);
  		document.getElementsByTagName("head")[0].appendChild(fileref);	

    	// Верхняя панель
    	$.Panel = jQuery("<div/>", {id: $.Panel}).appendTo("body");

    	// Добавляем кнопки в панель
    	for (var button in $.buttons) {
			if ($.buttons.hasOwnProperty(button)) {
				$.buttons[button] = jQuery("<a/>", $.buttons[button]).appendTo(jQuery($.Panel)).html($.buttons[button].title);    
			}
    	}

    	// Убираем редактирование стилей если не root
    	//if ($.user.name != 'root') $.buttons.css.remove();

    	// Кнопка логаута
    	$.buttons.logout = jQuery("<div/>", {id: "vfe-panel-logout"}).appendTo(jQuery($.Panel)).html('Вы зашли под <b>'+$.user.name+'</b> <a href="#" title="Выход"></a>');

    	// Выводим верхнюю панель
    	if ($.settings.panelVisibility == 1) {
	        $.Wrapper.animate({"margin-top": 28});
	        $.Panel.animate({"top": 0});
	    } else {
	        $.Wrapper.animate({"margin-top": 4});
	        $.Panel.css("top", -24).addClass("hidden");
    	}

    	// Генерируем редактируемые блоки
	    $.Dummies.each(function(){
	        if (jQuery(this).data("vfe-template")) jQuery(this).parent().addClass("vfe").attr("data-vfe-template", jQuery(this).data("vfe-template")).attr("data-vfe-revisions", jQuery(this).data("vfe-revisions")).attr("data-vfe-revision", jQuery(this).data("vfe-revision")).attr("data-vfe-plugins", jQuery(this).data("vfe-plugins")).end().remove();
	        if (jQuery(this).data("vfe-textid")) jQuery(this).parent().addClass("ck").attr("data-vfe-textid", jQuery(this).data("vfe-textid")).end().remove();
	    });

	    $.editableBlocks		= jQuery(".vfe");
	    $.contentEditableBlocks	= jQuery(".ck");

    	// Плавающая панель
    	$.Float = jQuery("<div/>", {id: $.Float}).appendTo("body");

    	// Добавляем кнопки в панель
    	$.floatButtons = {};
    	for (var i = 0, k = $.float.length; i < k; i++) {
    		$.floatButtons[$.float[i].name] = $.float[i];
    		delete $.floatButtons[$.float[i].name].name;
    	}
    	$.float = $.floatButtons; 
    	for (var button in $.float) {
    		$.float[button] = jQuery("<a/>", $.float[button]).appendTo(jQuery($.Float)).addClass("disabled");  
    	} 
    	$.floatButtons = jQuery("a", jQuery($.Float));

    	// Анимация загрузки
    	$.float.loading = jQuery("<ins/>", {id: "vfe-float-loading"}).appendTo(jQuery($.Float));

    	// Css-редактор


    	// Блок нотификаций
    	$.Message = jQuery("<div/>", {id: $.Message}).appendTo("body").html('<span></span><p></p><a href="#"></a>');
    	$.Message.hover(
    		function(){
    			clearTimeout(messageAnimation);
    		},
    		function(){
				messageAnimation = setTimeout("vfe.hideMessage();", 5000);
    		}
    	);
    	jQuery("a", $.Message).click(function(){$.hideMessage(); return false;});


    	// Анимация панели (только когда выбрано Скрывать панель)   
	    $.Panel.hover(
	        function(){
	            if (jQuery(this).is(".hidden")) {
	                $.Panel.animate({"top": 0});
	                clearTimeout(panelAnimation);
	            }
	        },function(){
	            if (jQuery(this).is(".hidden")) {
	                panelAnimation = setTimeout('vfe.Panel.animate({"top": -24});', 2000);   
	            }
	        }
	    );

	    // Кнопка Скрывать панель
	    $.buttons.hide.click(function(){
	        $.Panel.toggleClass("hidden");
	        if ($.Panel.is(".hidden")) {
	            $.Wrapper.animate({"margin-top": 4});
	            setCookie("vfe-panel-visibility",-1,365);
	        } else {
	            $.Wrapper.animate({"margin-top": 28});
	            setCookie("vfe-panel-visibility",1,365);
	        }
	        return false;
	    });

	    // Вкл/выкл режима редактирования
	    $.buttons.vfe.click(function(){
	        if (!jQuery(this).is(".current")) {
	            $.editOn();
	            $.editableBlocks.attr("contenteditable", "true");
	            $.contentEditableBlocks.attr("contenteditable", "true");
	            if (typeof CKEDITOR != 'undefined') {
	            	CKEDITOR.inline( document.getElementById( 'editablecontent' ), {
			            on: {
			                blur: function(event) {

			                    if (confirm("Сохранить изменения?")) {

									var request = jQuery.ajax({
										url: "/admin/vfe-text-save",
										type: "POST",
										data: {
											content : event.editor.getData(),
											id : jQuery("#editablecontent").data("vfe-textid")
										},
										dataType: "html"
									});

									request.done(function(msg) {
										var json;
										if (msg.substr(0,1) == '{') {
											json = jQuery.parseJSON(msg);
											if (json.error) vfe.showMessage("Ошибка", json.error, true);
										} else {
											vfe.showMessage("Сохранение", msg);	
										}
									});

									request.error(function(jqXHR, textStatus) {
										vfe.showMessage("Ошибка", textStatus, true);
									});

								}
			                }
			            }
			        });
	            }
	            if (getCookie("vfe-panel-editable") != 1) setCookie("vfe-panel-editable",1,365);
	        } else {
	            $.editOff();
	            $.editableBlocks.removeAttr("contenteditable");
	            $.contentEditableBlocks.removeAttr("contenteditable");
	            if (typeof CKEDITOR != 'undefined') {
	            	for(k in CKEDITOR.instances){
			            var instance = CKEDITOR.instances[k];
		            	instance.destroy();
		        	}
		        }
	            if (typeof $.Content_source != "undefined") $.Content_source.html($.Content);
	            $.Float.fadeOut();
	            setCookie("vfe-panel-editable",-1,365);
	        }
	        jQuery(this).toggleClass("current");
	        return false;
	    });
	    
	    if ($.settings.panelEditable == 1) {
	        $.buttons.vfe.trigger("click");        
	    }

	    //$.Css = jQuery("<div/>", {id: "vfe-css"}).appendTo("body").html('<pre id="vfe-css-container" contenteditable="true"></pre>');

	    // Редактирование стилей
	    /*$.buttons.css.click(function(){
	        if (!jQuery(this).is(".current")) {

	            jQuery.ajax({
	                url: "/admin/vfe-css-read",
	                type: 'post',
	                beforeSend: function(){
	                },
	                success: function(data){
	                    if(data.error){
	                        $.showMessage("Ошибка", data.error, true);
	                    } else{
	                        jQuery("pre", $.Css).html(data.content);
	                    }
	                },
	                error: function(data){
	                },
	                complete: function(){
	                }
	            });
	            
	            $.Css.fadeIn();

	        } else {

	            $.Css.fadeOut(function(){jQuery("pre", $.Css).html('')});

	        }
	        jQuery(this).toggleClass("current");
	        return false;
	    });*/

	    // Логаут
	    $.buttons.logout.click(function(){
	        jQuery.ajax({
	    		url: "/admin/logout",
	    		type: 'post',
	      		beforeSend: function(){
	    		},
	       		success: function(data){
	                $.buttons.vfe.addClass("current").trigger("click"); // Принудительно отключаем режим редактирования
	       		    $.Wrapper.animate({"margin-top": 0});
	                $.Panel.slideUp(); 
            		$.showMessage("Выход", "Вы успешно вышли из панели управления.", true); 
	       		},
	       		error: function(data){
	       			$.showMessage("Ошибка", "Невозможно выполнить запрос. Ошибка на стороне сервера.", true);  	
	       		},
	       		complete: function(){
	    		}
	    	});
	        return false;  
	    });

	    // Редактируемый блок и плавающая панель
	    $.editableBlocks.mousedown(function(){
	        if (!jQuery(this).attr("contenteditable")) return false;

	        if (typeof $.Content_source == 'undefined') {
	            $.Content_source = jQuery(this);
	            $.Content = jQuery(this).html();
	        } else if (jQuery(this).data("vfe-template") != $.Content_source.data("vfe-template")) {
	        	$.Content_source.removeClass("vfe-editing");
	        	$.Content_source.html($.Content).data("vfe-revision", parseInt($.Content_source.data("vfe-revisions"))+1).blur();
	        	$.Wrapper.removeClass("vfe-hideoutlines");
	            $.Content_source.html($.Content);
	            $.Content_source = jQuery(this);
	            $.Content = $.Content_source.html();
	        }

	        $.beforeBlockInit();

	        var offset = jQuery(this).offset();
	        var _offset = offset.top - 25 - ((parseInt(getCookie("vfe-panel-visibility")) > 0 ? 1 : 0)*28) > 0 ? offset.top - 25 : offset.top + jQuery(this).height() + 5; 
	        $.Float.animate({top: _offset, left: offset.left}, 100).fadeIn();
	    }).keyup(function(e){
	    	if (!jQuery(this).attr("contenteditable")) return false;

	        var offset = jQuery(this).offset();
	        var _offset = offset.top - 25 - ((parseInt(getCookie("vfe-panel-visibility")) > 0 ? 1 : 0)*28) > 0 ? offset.top - 25 : offset.top + jQuery(this).height() + 5; 
	        $.Float.animate({top: _offset, left: offset.left}, 100);
	        if ($.Content != $.Content_source.html()) {
	        	$.float.save.removeClass("disabled");
	        	$.float.cancel.removeClass("disabled");
	        }
	    }).mouseup(function(){
	    	if (!jQuery(this).attr("contenteditable")) return false;

	    	$.blockMouseClick();
	    });

	    // Кнопка сохранить
	    $.float.save.click(function(){
	    
	        if (jQuery(this).is(".disabled") || $.Float.is(".disabled")) return false;

	        jQuery.ajax({
	    		url: "/admin/vfe-save",
	    		type: 'post',
	      		beforeSend: function(){
	      			toggleLoading();
	      			$.beforeCancel();
	    		},
	       		success: function(data){
	       		    toggleLoading();
    				if(data.error){
                        $.showMessage("Ошибка", data.error, true);  
    				} else{
        				$.Content = $.Content_source.html();
        				$.Content_source.data("vfe-revisions", parseInt(data.revisions)).data("vfe-revision", (parseInt(data.revisions)+1));
                        updateAllInstances(); 				// Обновление контента одинаковых шаблонов на одной странице
        				$.float.cancel.trigger("click");	// Имитация нажатия кнопки "Отмена" (для скрытия плавающей панели)
        				$.showMessage("Сохранение", "Информация успешно сохранена.");  
    				}
	       		},
	       		error: function(data){
	       			$.showMessage("Ошибка", "Невозможно выполнить запрос. Ошибка на стороне сервера.", true);  
	       		},
	       		complete: function(){
	    		},
	       		data: {
	                template: $.Content_source.data("vfe-template"),
	                content:  $.Content_source.html()   
	            }
	    	});
	        
	        return false;  
	        
	    });

		// Кнопка предыдущее состояние
	    $.float.undo.click(function(){
	    
	        if (jQuery(this).is(".disabled") || $.Float.is(".disabled")) return false;
	    
	        jQuery.ajax({
	    		url: "/admin/vfe-undo",
	    		type: 'post',
	      		beforeSend: function(){
	      			toggleLoading();
	    		},
	       		success: function(data){
	       		    toggleLoading();
					if(data.error){
						$.showMessage("Ошибка", data.error, true);
	                    if (data.error_val == 1001) $.float.undo.addClass("disabled"); 	  
					} else{
						$.Content_source.html(data.content);
						$.Content_source.data("vfe-revision", data.revision);
						$.float.save.removeClass("disabled");
						$.float.cancel.removeClass("disabled");
						
	                    if (data.revision == 1) {
	                        $.float.undo.addClass("disabled");
	                    } else {
	                        $.float.undo.removeClass("disabled");
	                    } 
	                    if (data.revision < parseInt($.Content_source.data("vfe-revisions"))) $.float.redo.removeClass("disabled");
	                    $.showMessage("Ревизия", "Состояние на <b>"+data.datetime+"</b> ("+data.revision+"/"+$.Content_source.data("vfe-revisions")+") загружено успешно.");  
					}
	   			},
	       		error: function(data){
	       			$.showMessage("Ошибка", "Невозможно выполнить запрос. Ошибка на стороне сервера.", true);  
	       		},
	       		complete: function(){
	    		},
	       		data: {
	                template: $.Content_source.data("vfe-template"),
	                revision: $.Content_source.data("vfe-revision")
	            }
	    	});
	    	
	    	return false;
	        
	    }); 

		// Кнопка следующее состояние
	    $.float.redo.click(function(){
	    
	        if (jQuery(this).is(".disabled") || $.Float.is(".disabled")) return false;
	    
	        jQuery.ajax({
	    		url: "/admin/vfe-redo",
	    		type: 'post',
	      		beforeSend: function(){
	      			toggleLoading();
	    		},
	       		success: function(data){
	       		    toggleLoading();
					if(data.error){
						$.showMessage("Ошибка", data.error, true);
	                    if (data.error_val == 1001) {
	                    	$.Content_source.data("vfe-revision", data.revisions); 
	                    	$.float.redo.addClass("disabled");
	                    }	  
					} else{
						$.Content_source.html(data.content);
						$.Content_source.data("vfe-revision", data.revision);
						$.float.save.removeClass("disabled");
						$.float.cancel.removeClass("disabled");
						
	                    if (data.revision == data.revisions) {
	                        $.float.redo.addClass("disabled");
	                    } else {
	                        $.float.redo.removeClass("disabled");
	                    } 
	                    $.showMessage("Ревизия", "Состояние на <b>"+data.datetime+"</b> ("+data.revision+"/"+$.Content_source.data("vfe-revisions")+") загружено успешно.");  
					}
					if (data.revision > 1) $.float.undo.removeClass("disabled");
	   			},
	       		error: function(data){
	       			$.showMessage("Ошибка", "Невозможно выполнить запрос. Ошибка на стороне сервера.", true);  
	       		},
	       		complete: function(){
	    		},
	       		data: {
	                template: $.Content_source.data("vfe-template"),
	                revision: $.Content_source.data("vfe-revision")
	            }
	    	});
	    	
	    	return false;
	        
	    }); 


	    // Кнопка отменить
	    $.float.cancel.click(function(){
	        if (jQuery(this).is(".disabled") || $.Float.is(".disabled")) return false;
	        $.Wrapper.removeClass("vfe-hideoutlines");
	        $.Content_source.html($.Content).removeClass("vfe-editing").blur();
	        $.Content = undefined;
	        $.Content_source = undefined;
	        $.Float.hide(); 
	        return false;
	    });

	    jQuery(document).keyup(function(e){
	    	if (jQuery(".vfe-editing").length > 0 && e.keyCode == 27) {
	            $.float.cancel.trigger("click");
	            return false;
	        } 
	    });



	    // Список указанных модулей для загрузки
	    jQuery("script").each(function(){
	    	var _modules = [];
	    	if (jQuery(this).data("vfe-plugins")) {
	    		_modules = jQuery(this).data("vfe-plugins").split(',');
		    	for (var i = 0, k = _modules.length; i < k; i++) $.loadPlugins.push(_modules[i]);
			    return false;
			}
	    });

	    // Подгрузка модулей
	    for (var i = 0, k = $.loadPlugins.length; i < k; i++) {
	    	var fileref=document.createElement('script');
	  		fileref.setAttribute("type","text/javascript");
	  		fileref.setAttribute("src", $.Homepath+"vfe-plugins/"+$.loadPlugins[i]+"/vfe-plugin-"+$.loadPlugins[i]+".js");
	  		document.getElementsByTagName("head")[0].appendChild(fileref);	

	  		fileref=document.createElement('link');
	  		fileref.setAttribute("type","text/css");
	  		fileref.setAttribute("rel","stylesheet");
	  		fileref.setAttribute("href", $.Homepath+"vfe-plugins/"+$.loadPlugins[i]+"/vfe-plugin-"+$.loadPlugins[i]+".css");
	  		document.getElementsByTagName("head")[0].appendChild(fileref);	
	    }

    }

    // Инициализация плагина (вызывается из плагина)
    $.registerPlugin = function(obj) {
    	
    	$.plugins.sys[obj.object] = {};
    	for (var func in obj.moduleFunctions) {
    		if (obj.moduleFunctions.hasOwnProperty(func)) {
    			$.plugins.functions[func] = obj.moduleFunctions[func];
    		}
    	}

    	if (typeof obj.onEditOn != "undefined")				$.onEditOn.push(obj.onEditOn);
    	if (typeof obj.onEditOff != "undefined")			$.onEditOff.push(obj.onEditOff);
    	if (typeof obj.onBeforeBlockInit != "undefined")	$.onBeforeBlockInit.push(obj.onBeforeBlockInit);
    	if (typeof obj.onBlockMouseClick != "undefined")	$.onBlockMouseClick.push(obj.onBlockMouseClick);
    	if (typeof obj.onBeforeCancel != "undefined")		$.onBeforeCancel.push(obj.onBeforeCancel);

    	// Добавляем кнопки в панель
    	if (typeof obj.moduleButtons != "undefined") {
	    	$.floatButtons = {};
	    	for (var i = 0, k = obj.moduleButtons.length; i < k; i++) {
	    		$.loadedPlugins.push(obj.moduleButtons[i].name);
	    		$.floatButtons[obj.moduleButtons[i].name] = obj.moduleButtons[i];
	    		delete $.floatButtons[obj.moduleButtons[i].name].name;
	    	}
    	
	    	var _mainFunction = obj.mainFunction;
	    	for (var button in $.floatButtons) {
	    		if ($.floatButtons.hasOwnProperty(button)) {
		    		$.float[button] = jQuery("<a/>", $.floatButtons[button]).appendTo(jQuery($.Float)).addClass("disabled").click(function(){_mainFunction(jQuery(this)); return false;});  
		    	}
	    	} 
	    }

    	if (typeof obj.onInit != "undefined") obj.onInit();

    	$.floatButtons = jQuery("a", jQuery($.Float));

    }

    // Включение режима редактирования
    $.editOn = function() {

    	// Обработчики плагинов
    	for (var i = 0, k = $.onEditOn.length; i < k; i++) {
			$.onEditOn[i]();	
		}
    }

    // Выключение режима редактирования
    $.editOff = function() {

    	// Обработчики плагинов
    	for (var i = 0, k = $.onEditOff.length; i < k; i++) {
			$.onEditOff[i]();	
		}
    }

    // Перед иницилизацией редактируемого блока (при нажатии мышкой)
    $.beforeBlockInit = function() {

		// Сброс кнопок плавающей панели
    	for (var button in $.float) {
    		if ($.float.hasOwnProperty(button)) {
				$.float[button].addClass("disabled");  
			}		
    	}

    	if ($.Content != $.Content_source.html()) {
        	$.float.save.removeClass("disabled");
        	$.float.cancel.removeClass("disabled");
        }

    	for (var i = 0, k = $.loadedPlugins.length; i < k; i++) {
    		jQuery("#vfe-float-"+$.loadedPlugins[i]).hide();
    	}

    	// Настройка кнопок плавающей панели
		var revision = $.Content_source.data("vfe-revision") ? $.Content_source.data("vfe-revision") : -1;
    	$.float.cancel.removeClass("disabled");
    	if ($.Content_source.data("vfe-revisions") && revision > 0) $.float.undo.removeClass("disabled");
    	$.Content_source.addClass("vfe-editing");
    	$.Wrapper.addClass("vfe-hideoutlines");

    	if ($.Content_source.data("vfe-plugins")) {
    		var _plugins = $.Content_source.data("vfe-plugins").split(',');
    		for (var i = 0, k = _plugins.length; i < k; i++) {
	    		if (jQuery.inArray(_plugins[i], $.loadedPlugins) > -1) jQuery("#vfe-float-"+_plugins[i]).show(); 
	    	}
    	}

    	// Обработчики плагинов
		for (var i = 0, k = $.onBeforeBlockInit.length; i < k; i++) {
			$.onBeforeBlockInit[i]();	
		}
    }

    // Нажатие мышки на инициализированном блоке
    $.blockMouseClick = function() {

    	// Обработчики плагинов
    	for (var i = 0, k = $.onBlockMouseClick.length; i < k; i++) {
			$.onBlockMouseClick[i]();	
		}
    }

    // Перед сбросом (отменой)
    $.beforeCancel = function() {

    	// Обработчики плагинов
		for (var i = 0, k = $.onBeforeCancel.length; i < k; i++) {
			$.onBeforeCancel[i]();	
		}
    }

    $.getBlockPlugins = function() {
    	if (typeof $.Content_source != "undefined") {
	    	var _plugins = $.Content_source.data("vfe-plugins").split(',');
	    	return _plugins;
    	}
    }

    $.showMessage = function(title, text, error) {

	    $.hideMessage(true);

	    if (error) $.Message.addClass("error");

	    $.Message.animate({bottom: '20px', opacity: 1});

	    jQuery("span", $.Message).html(title);
	    jQuery("p", $.Message).html(text);

	    messageAnimation = setTimeout("vfe.hideMessage();", 5000);

	}

	$.hideMessage = function(quick) {

		clearTimeout(messageAnimation);

	    if (quick) {
	        $.Message.removeClass("error");
	        $.Message.css("bottom", -100).css("opacity", 0);
	    } else {
	        $.Message.animate({opacity: 0}, function(){
	            jQuery(this).css("bottom", -100).removeClass("error");
	        });
	    };  

	}


    // Приватные функции

    function toggleLoading() { 
    	$.float.loading.appendTo($.Float); // Передвигаем в самый конец списка кнопок

        if ($.float.loading.css("display") == "none") {
            $.Float.toggleClass("disabled");
            $.float.loading.show();
            $.floatButtons.find(":visible").fadeTo(200, 0.25);    
        } else {
            $.Float.toggleClass("disabled");
            $.float.loading.hide();
            $.floatButtons.find(":visible").fadeTo(200, 0.8);
        }        
    }

	function updateAllInstances() {
	    $.editableBlocks.each(function(){
	        if (jQuery(this).data("vfe-template") == $.Content_source.data("vfe-template")) jQuery(this).html($.Content_source.html());
	    });
	}

    function getCookie(c_name) {
	    var i,x,y,ARRcookies=document.cookie.split(";");
	    for (i=0;i<ARRcookies.length;i++) {
	        x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
	        y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
	        x=x.replace(/^\s+|\s+$/g,"");
	        if (x==c_name) {
	            return unescape(y);
	        }
	    }
	}

    function setCookie(c_name,value,exdays) {
	    var exdate=new Date();
	    exdate.setDate(exdate.getDate() + exdays);
	    var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
	    document.cookie=c_name + "=" + c_value + "; path=/";
	}

	function deleteCookie(c_name,path,domain) {
	   if (getCookie(c_name))
	   document.cookie=c_name+"="+((path) ? ";path="+path:"/")+((domain)?";domain="+domain:"")+";expires=Thu, 01 Jan 1970 00:00:01 GMT";
	}

	$.init();

    return $;

}(vfe));