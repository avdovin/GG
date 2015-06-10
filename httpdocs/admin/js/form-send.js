var ajaxform = [],
	ajaxrezerv = [],
	ajaxObjects = [],
	treeObj = [],
	modalObj = [],
	CodeEA = [],
	loadedFiles = [],
	settime = [],
	settime_sel = [],
	stloading = [],
	formValObj = [],
	formObj = [],
	lstobj = [],
	lstobjhelp = [],
	id_block_submit = [],
	textEditObj = [],
	listModel = [],
	rand = 1,
	quick_view_div = '',
	initExpandedNodes = '',
	newAliases = [];

var buttonsObj = {
	'button': [],
	'topmenu': []
};

var panels = {
	'west': [],
	'east': [],
	'center': []
};

var cp = {
	'west': 0,
	'east': 0,
	'center': 0
};

var DEBUG_MODE = true;
var log = function(message) {
	if(DEBUG_MODE && window.console && window.console.log) {
		window.console.log('DEBUG:', message);
	}
}

jQuery( document ).ready(function() {
	jQuery('body').on('click', 'a', function(e){
	  if( jQuery(this).attr('href') === '#' ) e.preventDefault();
	})
})


tooltipObj = new DHTMLSuite.dynamicTooltip(); // Create ONE tooltip object.
window.onerror = doNothing;


function whenLoading(replaceme) {
	if(!replaceme) replaceme = "replaceme";
	console.log( replaceme );
	console.log( document.getElementById(replaceme) );
	if(document.getElementById(replaceme)) {
		e = document.getElementById(replaceme);
		e.innerHTML = "<span style='background:#ffffaa;width:145px;padding:3px' id='" + replaceme + "_temp'>" + "Данные передаются" + "</span>";
	}

	stloading[replaceme] = 1000;
	setTimeout(function() {
		whenLoading_sch(replaceme);
	}, 1000);
}

function whenLoading_sch(replaceme) {
	if(typeof stloading[replaceme] == 'number') {
		if(document.getElementById(replaceme + "_temp")) {
			e = document.getElementById(replaceme + "_temp");
			str = e.innerHTML + ".";
			e.innerHTML = str;
		}
		stloading[replaceme] += 1000;
		if(stloading[replaceme] <= 150000) {
			setTimeout(function() {
				whenLoading_sch(replaceme);
			}, 1000);
		} else {
			delete stloading[replaceme];
			whenError(replaceme);
		}
	}
}

function whenLoaded(replaceme) {
	if(!replaceme) replaceme = "replaceme";
	if(document.getElementById(replaceme)) {
		e = document.getElementById(replaceme);
		e.innerHTML = "<span style='background:lightgreen;width:130px;padding:3px'>" + "Данные переданы" + "</span>";
	}
	delete stloading[replaceme];
}

function whenInteractive(replaceme) {
	if(!replaceme) replaceme = "replaceme";
	if(document.getElementById(replaceme)) {
		e = document.getElementById(replaceme);
		e.innerHTML = "<span style='background:#CCE4D0;width:180px;padding:3px'>" + "Идет получение информации" + "</span>";
	}
}

function whenError(replaceme) {
	if(!replaceme) replaceme = "replaceme";
	if(document.getElementById(replaceme)) {
		e = document.getElementById(replaceme);
		e.innerHTML = "<span style='background:red;color:white'>" + http_error_codes_humanize(ajaxform[replaceme].responseStatus[0]) + "</span>";
		setTimeout("whenError_return('" + replaceme + "')", 2000);
		//console.log(ajaxform[replaceme].responseStatus[0]);
	}

  function http_error_codes_humanize(code){
  	var str = '';

  	switch(code){
  		case 404 :
  			str = 'Не найдено';
  			break;
  		case 500 :
  			str = 'Внутренняя ошибка сервера';
  			break;
  		case 403 :
  			str = 'Доступ запрещен';
  			break;
  		case 503 :
  			str = 'Сервис недоступен';
  			break;
  		case 504 :
  			str = 'Шлюз не отвечает';
  			break;
  		default :
  			str = 'Неопределенная ошибка';
  	}
  	return str+' ('+code+')';
  }
}


function whenError_return(replaceme) {
	if(document.getElementById(replaceme)) {
		e = document.getElementById(replaceme);
		if(ajaxrezerv[replaceme]) {
			e.innerHTML = ajaxrezerv[replaceme];
			delete ajaxrezerv[replaceme];
		} else e.innerHTML = "";
	}
}



function trimString(sInString) {
	sInString = sInString.replace(/^\s+/g, "");
	return sInString.replace(/\s+$/g, "");
}

function isValidJSON(src) {
	var filtered = src;
	if(typeof(filtered) == 'undefined') return false;
	filtered = filtered.replace(/\\["\\\/bfnrtu]/g, '@');
	filtered = filtered.replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']');
	filtered = filtered.replace(/(?:^|:|,)(?:\s*\[)+/g, '');

	return(/^[\],:{}\s]*$/.test(filtered));
};

var Content_scripts = new Array();

function get_content_scripts(_source) {
	var source = _source;
	if(typeof source == 'undefined') return '';
	// Strip out tags
	while(source.indexOf("<script") > -1 || source.indexOf("</script") > -1) {
		var s = source.indexOf("<script");
		var s_e = source.indexOf(">", s);
		var e = source.indexOf("</script", s);
		var e_e = source.indexOf(">", e);

		// Add to scripts array
		Content_scripts.push(source.substring(s_e + 1, e));
		// Strip from source
		source = source.substring(0, s) + source.substring(e_e + 1);
	}
	// Return the cleaned source
	return source;
}

function run_content_scripts() {
	// Loop through every script collected and eval it
	for(var i = 0; i < Content_scripts.length; i++) {
		try {
			eval(Content_scripts[i]);
		} catch(ex) {
			// do what you want here when a script fails
		}
	}
	Content_scripts = [];
}

function FromServer(ajaxIndex, replaceme, outer) {
	if(typeof(ajaxform[ajaxIndex]) == 'undefined') return false;
	var response = {
		content: "",
		items: []
	};


	var contentType = ajaxform[ajaxIndex].xmlhttp.getResponseHeader("Content-Type");

	if(/application\/json[;\s\S]*/.test(contentType)) {
		response = jQuery.parseJSON(ajaxform[ajaxIndex].response);
	} else {
		response['content'] = ajaxform[ajaxIndex].response;
	}

	if(response['content'] == 'LOGOUT') {
		return loadfile("/admin");
	}

	if(response['content'] != 'ERROR') {
		var value_text = '';
		if(response) value_text = get_content_scripts(response['content']);

		if(!value_text) return '';

		if(document.getElementById(replaceme) && (value_text.indexOf("<div id='" + replaceme + "'") != -1 || value_text.indexOf("<div id=\"" + replaceme + "\"") != -1)) {
			outer = 1;
		}
		delete ajaxform[ajaxIndex];
		delete ajaxrezerv[replaceme];

		if(outer) {
			setOuterHTML(replaceme, value_text);
		} else {
			if(document.getElementById(replaceme)) {
				document.getElementById(replaceme).innerHTML = value_text;
			} else {
				return false;
			}
		}
	} else {
		if(document.getElementById(replaceme)) {
			document.getElementById(replaceme).innerHTML = ajaxrezerv[replaceme];
			delete ajaxform[ajaxIndex];
			delete ajaxrezerv[replaceme];
		} else {
			return false;
		}
	}

	var items = response['items'];
	var length = items.length;
	for(var i = 0; i < length; i++) {
		parse_json(items[i]);
	}

	// Запускаем скрипты из принятого ответа
	run_content_scripts();
}

var topMenuLoaded = 0;

function load_topMenu() {
	if(topMenuLoaded == 0) {
		load_json('menuTop', '/admin/main/menu_top');
		topMenuLoaded = 1;
	}
}

function parse_json(item) {
	var type = item['type'];

	if(type == 'addcontent') {
		if(!item['refresh']) item['refresh'] = 0;
		paneSplitter.addContent(item['position'], new DHTMLSuite.paneSplitterContentModel({
			id: item['id'],
			contentUrl: item['contenturl'],
			title: item['pantitle'],
			tabTitle: item['tabtitle'],
			refreshAfterSeconds: item['refresh']
		}));
		panels[item['position']][cp[item['position']]] = item['id'];
		cp[item['position']]++;
	}
	if(type == 'collapsepane') {
		if(item['status'] == 1) paneSplitter.collapsePane(item['position']);
	}
	if(type == 'expandPane') paneSplitter.expandPane(item['position']);
	if(type == 'showpane') paneSplitter.showPane(item['position']);
	if(type == 'hidepane') paneSplitter.hidePane(item['position']);
	if(type == 'deletecontent') paneSplitter.deleteContentById(item['id']);
	if(type == 'showcontent') paneSplitter.showContent(item['id']);
	if(type == 'topmenu') def_top_menu(item['display']);
	if(type == 'loadcontent') ld_content(item['divid'], item['url']);
	if(type == 'loadjson') load_json(item['divid'], item['url']);
	if(type == 'addseparator') menuButton[item['menubarkey']].addSeparator();

	if(type == 'menubardelall') {
		for(var i = 0; i <= buttonsObj[item['menubarkey']].length; i++) {
			if(buttonsObj[item['menubarkey']][i]) {
				menuBar[item['menubarkey']].deleteMenuItems(buttonsObj[item['menubarkey']][i], true);
				buttonsObj[item['menubarkey']][i] = false;
			}
		}
		document.getElementById("innerDiv2").innerHTML = "";
	}
	if(type == 'menubarset') {
		menuButton[item['menubarkey']] = new DHTMLSuite.menuModel();
		menuBar[item['menubarkey']] = new DHTMLSuite.menuBar();
	}
	if(type == 'menubarinit') {
		menuButton[item['menubarkey']].init();
		menuBar[item['menubarkey']].addMenuItems(menuButton[item['menubarkey']]);
		menuBar[item['menubarkey']].setTarget('innerDiv2');
		menuBar[item['menubarkey']].init();
	}
	if(type == 'additembutton') {
		menuButton[item['menubarkey']].addItem(item['id'], item['itemtext'], item['itemicon'], item['url'], '', item['helptext'], item['jsfunction'], 'sub', '');
		buttonsObj[item['menubarkey']][item['id']] = item['id'];
	}
	if(type == 'closeallpane') {
		for(var i = 0; i <= panels[item['position']].length; i++) {
			if(panels[item['position']][i] != "undefine") paneSplitter.deleteContentById(panels[item['position']][i]);
		}
		cp[item['position']] = 0;
	}

	if(type == 'eval') {
		try {
			eval(item['value']);
		} catch(ex) {}
	}
	if(type == 'settitle' && item['title']) {
		paneSplitter.setContentTitle(item['id'], item['title']);
		paneSplitter.showContent(item['id']);
	}
	if(type == 'settabtitle') {
		paneSplitter.setContentTabTitle(item['id'], item['title']);
		paneSplitter.showContent(item['id']);
	}
}

function FromServer_json(ajaxIndex, replaceme) {

	if(!ajaxform[ajaxIndex].response) {
		return 0;
	}

	var response = jQuery.parseJSON(ajaxform[ajaxIndex].response);

	delete ajaxform[ajaxIndex];
	delete ajaxrezerv[replaceme];

	var items = response['items'];
	for(var i = 0; i < items.length; i++) {
		parse_json(items[i]);
	}
}


// function FromServer_text(ajaxIndex, replaceme, outer) {
// var itemsCreated = new Array();
//
// if (!ajaxform[ajaxIndex].response) {return 0;}
// var value_text = ajaxform[ajaxIndex].response;
//
// delete ajaxform[ajaxIndex];
// delete ajaxrezerv[replaceme];
//
// var e = document.getElementById(replaceme);
// if (outer) e.outerHTML = value_text;
// else e.innerHTML = value_text;
// }

function ld_content(divId, url, outer, loading_msg) {
	var ajaxIndex = divId; //ajaxform.length;

	if(document.getElementById(divId) && ajaxIndex) {
		ajaxrezerv[ajaxIndex] = document.getElementById(divId).innerHTML;
		ajaxform[ajaxIndex] = new sack();
		ajaxform[ajaxIndex].requestFile = url;

		if(loading_msg){
			loading_layout_show();
			ajaxform[ajaxIndex].onInteractive = function() {
				loading_layout_hide();
			}
			ajaxform[ajaxIndex].onError = function() {
				loading_layout_hide();
			}
		}
		else {
			ajaxform[ajaxIndex].onError = function() {
				whenError(ajaxIndex);
			}
			ajaxform[ajaxIndex].onFail = function() {
				whenError(ajaxIndex);
			}
			ajaxform[ajaxIndex].onLoading = function() {
				whenLoading(ajaxIndex);
			}
			ajaxform[ajaxIndex].onLoaded = function() {
				whenLoaded(ajaxIndex);
			}
			ajaxform[ajaxIndex].onInteractive = function() {
				whenInteractive(ajaxIndex);
			}
		}
		ajaxform[ajaxIndex].onCompletion = function() {
			FromServer(ajaxIndex, divId, outer)
		};
		ajaxform[ajaxIndex].runAJAX(); // Execute AJAX function
	}
}

function load_json(divId, url, msg) {
	var ajaxIndex = divId; //ajaxform.length;
	if(document.getElementById(divId)) {
		ajaxrezerv[ajaxIndex] = document.getElementById(divId).innerHTML;

		ajaxform[ajaxIndex] = new sack();
		ajaxform[ajaxIndex].requestFile = url;
		if(!msg) {
			ajaxform[ajaxIndex].onError = function() {
				whenError(ajaxIndex);
			}
			ajaxform[ajaxIndex].onFail = function() {
				whenError(ajaxIndex);
			}
			ajaxform[ajaxIndex].onLoading = function() {
				whenLoading(ajaxIndex);
			}
			ajaxform[ajaxIndex].onLoaded = function() {
				whenLoaded(ajaxIndex);
			}
			ajaxform[ajaxIndex].onInteractive = function() {
				whenInteractive(ajaxIndex);
			}
		}
		ajaxform[ajaxIndex].onCompletion = function() {
			FromServer_json(ajaxIndex, divId);
		};
		ajaxform[ajaxIndex].runAJAX(); // Execute AJAX function
	}
}

//function load_text(divId, url, outer, msg) {
//	console.log(load_text);
//	var ajaxIndex = divId; //ajaxform.length;
//
//	if (document.getElementById(divId)) {
//		ajaxrezerv[ajaxIndex] = document.getElementById(divId).innerHTML;
//
//		ajaxform[ajaxIndex] = new sack();
//		ajaxform[ajaxIndex].requestFile = url;
//		if (!msg) {
//			ajaxform[ajaxIndex].onError = function()   {whenError(ajaxIndex);}
//			ajaxform[ajaxIndex].onFail  = function()   {whenError(ajaxIndex);}
//	    	ajaxform[ajaxIndex].onLoading = function() {whenLoading(ajaxIndex);}
//	    	ajaxform[ajaxIndex].onLoaded  = function() {whenLoaded(ajaxIndex);}
//	    	ajaxform[ajaxIndex].onInteractive = function() {whenInteractive(ajaxIndex);}
//		}
//		ajaxform[ajaxIndex].onCompletion  = function() { FromServer_text(ajaxIndex, divId, outer) };
//		ajaxform[ajaxIndex].runAJAX();		// Execute AJAX function
//	}
//}

function openPage(position, id, contentUrl, title, tabTitle, closable) { // Открытие новой вкладки
	var item = new Array();

	item['id'] = id;
	item['position'] = position;
	item['title'] = title;
	item['tabTitle'] = tabTitle;
	item['closable'] = closable;
	if(!item['title']) {
		item['title'] = " ";
	}

	panels[item['position']][cp[item['position']]] = item['id'];
	cp[item['position']]++;


	item['contentUrl'] = "/admin/nothing";
	if(!paneSplitter.addContent(position, new DHTMLSuite.paneSplitterContentModel(item))) {
		paneSplitter.deleteContentById(item['id']);
		paneSplitter.addContent(position, new DHTMLSuite.paneSplitterContentModel(item));
	}

	setTimeout(function() {
		ld_content(item['id'], contentUrl);
	}, 600);
	paneSplitter.showContent(id);
}

function def_top_menu(view) {
	document.getElementById('header').style.display = view;
}

function open_url(url) {
	window.open(url);
}

function saveComplete(index) {
	alert(ajaxObjects[index].response);
}

function do_submit_link(form, ajaxIndex, program) {
	do_submit(document.getElementById(form), ajaxIndex, program);
}

function do_submit(form, ajaxIndex, program, msg) {
	if(typeof stloading[ajaxIndex] == 'number') {
		alert('Данные передаются ..');
		return false;
	}

	loading_layout_show();
	var formel = form.length;
	ajaxform[ajaxIndex] = new sack();
	ajaxrezerv[ajaxIndex] = document.getElementById(ajaxIndex).innerHTML;

	for(var i = 0; i < formel; i++) {
		if((form.elements[i].name) && (form.elements[i].name.indexOf("fromselect", 0) == -1)) {
			if(form.elements[i].multiple) {
				var options_sel = "";
				for(j = 0; j < form.elements[i].length; j++) {
					if(form.elements[i].options[j].selected) options_sel += "," + form.elements[i].options[j].value
				}
				ajaxform[ajaxIndex].setVar(form.elements[i].name, options_sel)
			} else {
				if(form.elements[i].type == "checkbox") {
					if(form.elements[i].checked) {
						if(typeof(ajaxform[ajaxIndex].vars[form.elements[i].name]) == 'object') {
							ajaxform[ajaxIndex].vars[form.elements[i].name][0] += ',' + form.elements[i].value;
						} else {
							ajaxform[ajaxIndex].vars[form.elements[i].name] = Array(form.elements[i].value, false);
						}
					} else if(typeof(ajaxform[ajaxIndex].vars[form.elements[i].name]) == 'undefined') {
						ajaxform[ajaxIndex].setVar(form.elements[i].name, 0);
					}

				} else {
					if(form.elements[i].type == "textarea") {
						if(form.elements[i].className == 'template' && CODEMIRROR[form.elements[i].id]) {
							ajaxform[ajaxIndex].setVar(form.elements[i].name, CODEMIRROR[form.elements[i].id].getValue());
							//CODEMIRROR[form.elements[i].id].save();
							//CODEMIRROR[form.elements[i].id].toTextArea();
							delete CODEMIRROR[form.elements[i].id];

							//if (CKEDITOR.instances[form.elements[i].id]) {
						} else if(CKEDITOR.instances[form.elements[i].id]) {
							ajaxform[ajaxIndex].setVar(form.elements[i].name, CKEDITOR.instances[form.elements[i].id].getData());

						} else {
							ajaxform[ajaxIndex].setVar(form.elements[i].name, form.elements[i].value);
						}
					} else {
						if(form.elements[i].type == "radio") {
							if(form.elements[i].checked) ajaxform[ajaxIndex].setVar(form.elements[i].name, form.elements[i].value);
						} else {
							ajaxform[ajaxIndex].setVar(form.elements[i].name, form.elements[i].value);
						}
					}
				}
			}
		}
		if(form.elements[i].name.indexOf("fromselect", 0) > -1) {
			var f = form.elements[i].name.substring(10, form.elements[i].name.length);
			for(var ii = 0; ii < formel; ii++) {
				if(form.elements[ii].name == f) {
					options_sel = "";
					for(j = 0; j < form.elements[ii].length; j++) {
						options_sel += "," + form.elements[ii].options[j].value
					}
					ajaxform[ajaxIndex].setVar(form.elements[ii].name, options_sel);
					form.elements[ii].name = "";
				}
			}
		}
	}
	ajaxform[ajaxIndex].requestFile = program;
	ajaxform[ajaxIndex].method = form.method;
	if(!msg) {
		ajaxform[ajaxIndex].onError = function() {
			whenError(ajaxIndex);
			loading_layout_hide();
		}
		ajaxform[ajaxIndex].onFail = function() {
			whenError(ajaxIndex);
			loading_layout_hide();
		}
		ajaxform[ajaxIndex].onLoading = function() {
			whenLoading(ajaxIndex);
		}
		ajaxform[ajaxIndex].onLoaded = function() {
			whenLoaded(ajaxIndex);
		}
		ajaxform[ajaxIndex].onInteractive = function() {
			whenInteractive(ajaxIndex);
		}
	}
	ajaxform[ajaxIndex].onCompletion = function() {
		FromServer(ajaxIndex, ajaxIndex, 0);
		loading_layout_hide();
	};
	ajaxform[ajaxIndex].runAJAX();

	if(navigator.userAgent.indexOf("Opera") != -1) {
		return false;
	}
}

// -> Работа со списками (поиск по подстроке, множественные списки


function getMultilist(sel, out, key_program, razdel_index, lfield, request_url) {
	getList(sel, "fromselect" + out, key_program, razdel_index, lfield, request_url, 1);
}

function multiblock_toogle(replaceme) {

	if(!jQuery('#multisearchblock'+replaceme).length ) return false;


	if( !jQuery('#multisearchblock'+replaceme).is(':visible') ){
		jQuery('#multisearchblock'+replaceme).show();
		jQuery('#multisearchblock_on'+replaceme).hide();
		jQuery('#multisearchblock_off'+replaceme).show();

		if(jQuery(".helptext-"+replaceme).length) jQuery(".helptext-"+replaceme).hide();
	}
	else {
		jQuery('#multisearchblock'+replaceme).hide();
		jQuery('#multisearchblock_on'+replaceme).show();
		jQuery('#multisearchblock_off'+replaceme).hide();

		if(jQuery(".helptext-"+replaceme).length) jQuery(".helptext-"+replaceme).show();
	}

}

function multiblock_on(multisearchblock) {
	console.log('multiblock_on deprecated');
	if(document.getElementById("multisearchblock" + multisearchblock)) {
		document.getElementById("multisearchblock" + multisearchblock).style.display = "block";
		document.getElementById("multisearchblock_off" + multisearchblock).style.display = "block";
		document.getElementById("multisearchblock_on" + multisearchblock).style.display = "none";
	}
}

function multiblock_off(multisearchblock) {
	console.log('multiblock_off deprecated');
	if(document.getElementById("multisearchblock" + multisearchblock)) {
		document.getElementById("multisearchblock" + multisearchblock).style.display = "none";
		document.getElementById("multisearchblock_on" + multisearchblock).style.display = "block";
		document.getElementById("multisearchblock_off" + multisearchblock).style.display = "none";
	}
}

function getList(sel, out, key_program, razdel_index, lfield, request_url, multi) {
	sel.focus();
	if(settime[out]) {
		clearTimeout(settime[out]);
		delete settime[out];
		delete settime_sel[out];
	}
	settime[out] = setTimeout(function() {
		getList_start(out, key_program, razdel_index, lfield, request_url, multi);
	}, 1000);
	settime_sel[out] = sel;
}

function getList_start(out, key_program, razdel_index, lfield, request_url, multi) {
	sel = settime_sel[out];
	Code = sel.value;

	if(typeof request_url == 'undefined' || request_url == '') request_url = '/admin/main/body';
	// get current selected items
	pattern_item = new RegExp("fromselect", "g");
	var out_temp = out.replace(pattern_item, '');
	var selected_vals_arr = [];
	var selected_vals = '';
	if(jQuery("#" + out_temp + " option").length) {
		jQuery("#" + out_temp + " option").each(function() {
			selected_vals_arr.push(jQuery(this).val())
		});
		selected_vals = selected_vals_arr.join(',');
	}
	if(typeof multi == 'undefined') multi = 0;

	lstobjhelp[out] = '/admin/' + key_program + '/body?do=quick_view&list_table=' + jQuery(sel).data('list-table');

	if(razdel_index) {
		razind = razdel_index.split(':');
		key_razdel = razind[0];
		index = razind[1];
	}
	if(Code) {
		if(document.getElementById('ok_' + out)) document.getElementById('ok_' + out).innerHTML = "<span style='background-color:#ff6666;width:45px;padding:3px'>загрузка...</span>";
		ajaxform[out] = new sack();
		ajaxform[out].requestFile = request_url;
		ajaxform[out].method = "GET";
		ajaxform[out].setVar("do", "lists_select");
		ajaxform[out].setVar("lfield", lfield);
		ajaxform[out].setVar("multi", multi);
		ajaxform[out].setVar(lfield, selected_vals);
		if(index) ajaxform[out].setVar("index", index);
		if(key_razdel) ajaxform[out].setVar("key_razdel", key_razdel);
		ajaxform[out].setVar("key_program", key_program);
		ajaxform[out].setVar("keystring", Code);

		ajaxform[out].onCompletion = function() {
			createList(out);
		}
		ajaxform[out].runAJAX();
	}
}

function getListOther(prefix, lkey, rules, controller) {
	if(rules) {
		var ind = document.getElementById(prefix + lkey).options[document.getElementById(prefix + lkey).selectedIndex].value;
		var all_rules = rules.split('|');
		if(all_rules.length > 1) {
			for(ii = 0; ii < all_rules.length; ii++) {
				setTimeout("getListOther('" + prefix + lkey + "', '" + all_rules[ii] + "', '" + key_program + "')", 1000 * (ii + 1));
			}
		} else {
			var rules_arr = rules.split(':');
			name = rules_arr[0];
			if(document.getElementById(prefix + name)) {
				var ind_nf = document.getElementById(prefix + name).options[document.getElementById(prefix + name).selectedIndex].value;

				if(document.getElementById('ok_' + prefix + name)) document.getElementById('ok_' + prefix + name).innerHTML = "<span style='background-color:#ff6666;width:45px;padding:3px'>загрузка...</span>";
				ajaxform[name] = new sack();
				ajaxform[name].requestFile = '/admin/main/body';
				ajaxform[name].method = "POST";
				ajaxform[name].setVar("do", "lists_select");
				ajaxform[name].setVar("lfield", name);
				ajaxform[name].setVar("controller", controller);
				ajaxform[name].setVar("rules", rules_arr[1]);
				ajaxform[name].setVar("replaceme", prefix);
				ajaxform[name].setVar("index", ind);
				ajaxform[name].setVar(rules_arr[0], ind_nf);

				ajaxform[name].onCompletion = function() {
					createList(prefix, name);
				}
				ajaxform[name].runAJAX();
			}
		}
	}
}

function createList(prefix, out) {
	if(typeof(out) == 'undefined' && prefix) {
		out = prefix;
		prefix = '';
	}
	lstobj[out] = document.getElementById(prefix + out);
	if(lstobj[out].type == "select" || lstobj[out].type == "select-multiple" || lstobj[out].type == "select-one") lstobj[out].options.length = 0;

	eval(ajaxform[out].response);

	if(lstobjhelp[out]) {
		if(navigator.userAgent.indexOf("MSIE") == -1) {
			pattern_item = new RegExp("fromselect", "g");
			out_temp = out.replace(pattern_item, '');
			for(i = 0; i < lstobj[out].options.length; i++) {
				lstobj[out].options[i].id_tmp = out_temp;
				lstobj[out].options[i].link = lstobjhelp[out] + "&index=" + lstobj[out].options[i].value;
				lstobj[out].options[i].onclick = alert_index;
			}
		} else {
			elm = document.getElementById(out);
			document.getElementById(out).onclick = alertindex;
		}
	}

	if(document.getElementById('ok_' + prefix + out)) {
		if(settime_sel[out]) settime_sel[out].focus();
		setTimeout("clear_createList('" + prefix + out + "');", 4000);
	}
}

function alertindex() {
	pattern_item = new RegExp("fromselect", "g");
	out = this.id
	out_temp = out.replace(pattern_item, '');
	if(document.getElementById("helpmultilist" + out_temp) && document.getElementById("helpmultilist" + out_temp).style.display == "block") {
		document.getElementById("helpmultilist" + out_temp).style.overflow = "scroll";
		link = lstobjhelp[out] + "&index=" + lstobj[out].options[lstobj[out].selectedIndex].value;
		ld_content("helpmultilist" + out_temp, link);
	}
}

var alert_index = function() {
		out_temp = this.id_tmp;
		if(document.getElementById("helpmultilist" + out_temp) && document.getElementById("helpmultilist" + out_temp).style.display == "block") {
			document.getElementById("helpmultilist" + out_temp).style.overflow = "scroll";
			ld_content("helpmultilist" + out_temp, this.link);
		}
	}

function show_quick_view(out, url, wpx, hpx) {
	ld_content(out + "quick_view_div", url, 0);
}

function clear_createList(out) {
	if(document.getElementById('ok_' + out)) {
		document.getElementById('ok_' + out).innerHTML = "";
	}
}

function multilist_init(form) {
	multiSel = new Array();
	forma = document.getElementById(form);
	var formel = forma.length;
	var elem = new Array();
	for(var i = 0; i < formel; i++) {
		cl = forma.elements[i].className;
		clarr = cl.split(' ');
		if(clarr[0] == "fromselect") {
			if(!clarr[2]) clarr[2] = "";
			if(!multiSel[clarr[2]]) {
				forma.elements[i].className = "menu";
				if(forma.elements[i].type == "hidden") {
					createMovableOptions("fromselect" + clarr[1] + clarr[2], clarr[1] + clarr[2], 400, 150, 'Доступные значения:', 'Выбранные значения:');
				} else {
					createMovableOptions("fromselect" + clarr[1] + clarr[2], clarr[1] + clarr[2], 400, 150, 'Доступные значения:', 'Выбранные значения:');
				}
				multiSel[clarr[1]] = 1;
				formel = forma.length;
			}
		}
	}
}
// <- Работа со списками (поиск по подстроке, множественные списки

function displayMessage(url, w, h, level) {
	today = new Date();
	rand = rand + 1;
	ts = today.getTime() + rand;
	url = url + "&rndval=" + ts;
	index = level;

	if(!modalObj[index]){
		modalObj[index] = new DHTMLSuite.modalMessage();
	}
	modalObj[index].setShadowOffset(5); // Large shadow
	modalObj[index].setSource(url);
	modalObj[index].setCssClassMessageBox(false);
	modalObj[index].setSize(w, h);
	modalObj[index].setShadowDivVisible(true); // Enable shadow for these boxes
	modalObj[index].setWaitImage('/loading_128.gif');
	modalObj[index].display();
}

function closeMessage(index) {
	if(modalObj[index]) modalObj[index].close();
}

function inittabs(index, tabs, tabsclose) {
	if(document.getElementById('DHTMLSuite_tabView' + index)) {
		var tabViewObj = new DHTMLSuite.tabView();
		tabViewObj.setParentId('DHTMLSuite_tabView' + index);
		tabViewObj.setTabTitles(tabs);
		tabViewObj.setCloseButtons(tabsclose);
		tabViewObj.setIndexActiveTab(0);
		tabViewObj.setWidth('95%');
		tabViewObj.setHeight('80%');
		tabViewObj.init();
		document.getElementById('DHTMLSuite_tabView' + index).style.display = "block";
	} else {
		setTimeout("inittabs('" + index + "', '" + tabs + "', '" + tabsclose + "')", 100);
	}
}

function init_tableWidget() {
	alltabl = document.getElementsByTagName("table").length;
	for(var i = 0; i < alltabl; i++) {
		if(document.getElementsByTagName("table")[i].className == "doptable") {
			document.getElementsByTagName("table")[i].className = "";
			var tableWidgetObj = new DHTMLSuite.tableWidget();
			tblWidget_width = "99%";
			tblWidget_height = "100%";
			tableWidgetObj.setTableId(document.getElementsByTagName("table")[i].id);
			if(document.getElementsByTagName("table")[i].width) tblWidget_width = document.getElementsByTagName("table")[i].width;
			tableWidgetObj.setTableWidth(tblWidget_width);
			if(document.getElementsByTagName("table")[i].height) tblWidget_height = document.getElementsByTagName("table")[i].height;
			tableWidgetObj.setTableHeight(tblWidget_height);
			tparam = document.getElementsByTagName("table")[i].id + "param";
			eval(document.getElementById(tparam).innerHTML);
			tableWidgetObj.init();
			var ascending = "";
			if(document.getElementsByTagName("table")[i].getAttribute("ascending")) {
				ascending = document.getElementsByTagName("table")[i].getAttribute("ascending");
			}
			if(document.getElementsByTagName("table")[i].getAttribute("sorttable")) tableWidgetObj.sortTableByColumn(document.getElementsByTagName("table")[i].getAttribute("sorttable"), ascending);
			else tableWidgetObj.sortTableByColumn(0, ascending);

			//if(jQuery.browser.mozilla) setTimeout("ff_init_tableWidget();", 1500);
			if (navigator.userAgent.indexOf("Firefox") != -1) setTimeout("ff_init_tableWidget();", 1500);
		}
	}
}

function ff_init_tableWidget() {
	alltabl = document.getElementsByTagName("tbody").length;
	for(var i = 0; i < alltabl; i++) {
		if(document.getElementsByTagName("tbody")[i].className == "DHTMLSuite_scrollingContent" && !document.getElementsByTagName("tbody")[i].getAttribute("noresize")) {
			document.getElementsByTagName("tbody")[i].setAttribute("noresize", true);
			h = document.getElementsByTagName("tbody")[i].style.height;
			pattern_item = new RegExp("px", "g");
			h = h.replace(pattern_item, '');
			t = (h * 1) + 20;
			if(t == 20) {
				t = 200;
			}
			document.getElementsByTagName("tbody")[i].style.height = t + "px";
			if(document.getElementsByTagName("tbody")[i].style.height == "0px") {
				document.getElementsByTagName("tbody")[i].style.height = "100%";
			}
		}
	}
}

function addOption(name, text, val) {
	alltabl = document.getElementsByTagName("select").length;
	for(var i = 0; i < alltabl; i++) {
		lst = document.getElementsByTagName("select")[i];
		if(lst.name == name) {
			var all_elem;
			all_elem = lst.length;
			lst.length = all_elem + 1;
			lst.options[all_elem].text = text;
			lst.options[all_elem].value = val;
			lst.options[all_elem].selected = true;
		}
	}
}


function editor_init(form) {
	var count = 0;
	jQuery("#" + form + " textarea.html").each(function() {
		var id = jQuery(this).attr('id');
		var toolbar = jQuery(this).attr('cktoolbar');
		if(!toolbar) toolbar = 'Full';

		var instance = CKEDITOR.instances[id];

		if(instance) {
			//CKEDITOR.remove(instance);
			//instance.destroy();
		}
		if(count == 0) loading_layout_show('ckeditor');
		count = 1;
		delete CKEDITOR.instances[ id ];

		CKEDITOR.replace(id, {
			toolbar: toolbar,
			//resize_enabled: false,
			startupFocus: false,
			removePlugins: 'resize',
		});

		CKEDITOR.instances[id].on('afterCommandExec', function(e) {
			if(e.data.name == 'maximize') {
				var Node = jQuery(this);
				if(typeof Node.data('max') == 'undefined') {
					Node.data({
						'state_east': paneSplitter.getState('east'),
						'state_west': paneSplitter.getState('west')
					});
					paneSplitter.collapsePane('east');
					paneSplitter.collapsePane('west');

					jQuery(this).data('max', true);
				} else {
					var data = Node.data();
					if(data['state_east'] && data['state_east'] == 'expanded') paneSplitter.expandPane('east');
					if(data['state_west'] && data['state_west'] == 'expanded') paneSplitter.expandPane('west');

					jQuery(this).removeData('max');
				}
			}
		});
	});
	if(count == 1) {
		CKEDITOR.on('instanceReady', function(e) {
			loading_layout_hide('ckeditor');
		});
	}

	return true;

	//setTimeout("submitOK()", 1500);
}

function submitOK(subm) {
	if(document.getElementById(subm)) document.getElementById(subm).disabled = false;
	loading_layout_hide();
}

function ldScript(target, src) {
	var node = target.createElement("script");
	node.src = src;
	target.getElementsByTagName("head").item(0).appendChild(node);
	node = null;
}

function loadfile(url) {
	window.location.href = url;
}

function doNothing() {
	return false;
}

function markup_tr(id, classid) {
	if(document.getElementById("listchb" + id) && document.getElementById("listchb" + id).checked) {
		document.getElementById("tr" + id).className = 'marked'
	} else {
		document.getElementById("tr" + id).className = classid
	}
}

// function tr_select_over(obj_tr) {
// 	if(obj_tr.className == 'marked') {
// 		obj_tr.className = 'selectmarked'
// 	} else {
// 		obj_tr.className = 'select'
// 	}
// }

// function tr_select_out(obj_tr, classid) {
// 	if(obj_tr.className == 'selectmarked' || obj_tr.className == 'marked') {
// 		obj_tr.className = 'marked'
// 	} else {
// 		obj_tr.className = classid
// 	}
// }

function openNewWin(Wx, Hx, program, actions, lkey) {
	Wx += 20;
	Ws = screen.width;
	Hx += 20;
	Hs = screen.height;
	Tx = (Hs - Hx) / 2;
	Lx = (Ws - Wx) / 2;
	strFeatures = "Top=" + Tx + ",Left=" + Lx + ",Height=" + Hx + ",Width=" + Wx + ",status=no,toolbar=no,menubar=no,location=no,scrollbars=yes";
	LinkO = program + "?" + actions;
	window.open(LinkO, lkey, strFeatures)
}


function open_fullversions() {
	var width = window.screen.width - 10;
	var heigth = window.screen.height - 60;

	strFeatures = "Top=0,Left=0,Height=" + heigth + ",Width=" + width + ",status=no,toolbar=no,menubar=no,location=no,scrollbars=yes";
	LinkO = "/admin/";
	window.open(LinkO, '', strFeatures);
}

loading_layout = [];

function loading_layout_show(key) {
	if(key == 'undefined') key = 'default';
	loading_layout[key] = 1;
	jQuery("#loading-layout").fadeIn('fast');
}

function loading_layout_hide(key) {
	if(key == 'undefined') key = 'default';
	delete loading_layout[key];

	if(loading_layout.length == 0) jQuery("#loading-layout").fadeOut('fast');
}


function load_scripts(extend_settings) {
	var settings = jQuery.extend({
		success: function() {},
		error: function() {},
		beforeSend: function() {},
		loading_key: 'default',
		scripts: []
	}, extend_settings);

	loading_layout_show(settings.loading_key);

	var promises = [];
	var scripts = settings['scripts'];
	var length = scripts.length;
	if(length == 0) return false;

	settings.beforeSend();

	yepnope({
		load: scripts,
	  	complete: function () {
			for(var i = 0; i < length; i++) {
				var url = scripts[i];
				loadedFiles[url] = true;
			}
			settings.success();

	    	loading_layout_hide(settings.loading_key);
	    }
	});
}


function load_script(url) {
	if(loadedFiles[url]) return;

	try {
		script = document.createElement("script");
		script.type = "text/javascript";
		script.src = url;
		head = document.getElementsByTagName("head");
		head[0].appendChild(script);
	} catch(e) {
		document.write('<sc' + 'ript language="javascript" type="text/javascript" charset="utf-8" src="' + url + '"></sc' + 'ript>');
	}
	loadedFiles[url] = true;
}

function load_css(url) {
	if(loadedFiles[url]) return;
	try {
		var lt = document.createElement('LINK');
		lt.href = url;
		lt.rel = 'stylesheet';
		lt.media = 'screen';
		lt.type = 'text/css';

		document.getElementsByTagName('HEAD')[0].appendChild(lt);
	} catch(e) {
		document.write('<li' + 'nk rel="stylesheet" href="' + url + ' type="text/css""></li' + 'nk>');
	}
	loadedFiles[url] = true;
}

function setOuterHTML(ElementID, txt) {
	var someElement = document.getElementById(ElementID);

	//работает для IE, но не работает для Firefox.
	if(someElement.outerHTML) {
		someElement.outerHTML = txt;
	}

	//работает для Firefox, но не работает для IE.
	else {
		var range = document.createRange();
		range.setStartBefore(someElement);
		var docFrag = range.createContextualFragment(txt);
		someElement.parentNode.replaceChild(docFrag, someElement);
	}
}

function setFocus(f) {
	f.focus();
}

function show_help(e, help) {
	if(!document.getElementById("help_view_div")) {
		help_view_div = document.createElement('DIV');
		help_view_div.className = 'help_view_div';
		help_view_div.id = 'help_view_div';
		document.body.appendChild(help_view_div);
	}
	if(document.getElementById("help_view_div")) {
		if(navigator.userAgent.indexOf("MSIE") == -1) {
			help_view_div.style.top = Math.ceil(e.screenY - (e.screenY - e.pageY) + 30) + "px";
		} else {
			help_view_div.style.top = Math.ceil(e.screenY - window.screenTop + 20) + "px";
		}

		if(navigator.userAgent.indexOf("MSIE") == -1) {
			help_view_div.style.left = Math.ceil(e.screenX - (e.screenX - e.pageX) + 20) + "px";
		} else {
			help_view_div.style.left = Math.ceil(e.screenX - window.screenLeft + 20) + "px";
		}
	}

	document.getElementById("help_view_div").innerHTML = help;
	help_view_div.style.display = 'block';
}

function hide_help() {
	help_view_div.style.display = 'none';
}

function getCookies(name) {
	var start = document.cookie.indexOf(name + "=");
	var len = start + name.length + 1;
	if((!start) && (name != document.cookie.substring(0, name.length))) return null;
	if(start == -1) return null;
	var end = document.cookie.indexOf(";", len);
	if(end == -1) end = document.cookie.length;
	return document.cookie.substring(len, end);
}

//var myWindow;
//var favorit_win = 0;
//function favWindow_init() {
//	if (favorit_win == 0) {
//		var windowModel = new DHTMLSuite.windowModel();
//		windowModel.createWindowModelFromMarkUp('flyWindow');
//		myWindow = new DHTMLSuite.windowWidget();
//		myWindow.addWindowModel(windowModel);
//		myWindow.init();
//		favorit_win = 1;
//	} else {
//		myWindow.show();
//	}
//}


function close_modal_win(prefix, replaceme) {
	delete id_block_submit[prefix + replaceme];
	delete formValObj[prefix + replaceme];
	delete formObj[prefix + replaceme];
	setOuterHTML('replaceme_' + prefix + replaceme, '');
	closeMessage(4);
}

function uniqueAlias(node_selector){
	var form = jQuery("#"+node_selector).parents("form");
	if(jQuery("input[name=alias]", form).length && jQuery("input[name=alias]", form).attr('readonly') == undefined) {
		newAliases[node_selector] = true;

		if( $('#'+node_selector)[0].value ){
			newAliases[node_selector] = false;
		}

		jQuery("input[name=alias]", form).change(function() { this._changed = true; });
		jQuery("#"+node_selector).keyup(function() {
	        var e = jQuery("input[name=alias]", form)[0];
	        if (!e._changed && newAliases[node_selector]) {
	            e.value = URLify(this.value, 64);
	            e.click();
	        }
		})
	}
}

function toggleFiltersBtn(element, div){
	if(document.getElementById(div).style.display == "none") {
		document.getElementById(div).style.display = "block";
		$(element).text( $(element).text().replace(/показать/,"скрыть") );
	} else {
		document.getElementById(div).style.display = "none";
		$(element).text( $(element).text().replace(/скрыть/,"показать") );
	}
}

function swich_visible(div) {
	if(document.getElementById(div).style.display == "none") {
		document.getElementById(div).style.display = "block";
	} else {
		document.getElementById(div).style.display = "none";
	}
}

var CODEMIRROR = new Array();

function isFullScreen(cm) {
	return /\bCodeMirror-fullscreen\b/.test(cm.getWrapperElement().className);
}
function winHeight() {
      return window.innerHeight || (document.documentElement || document.body).clientHeight;
}
function toggleFullscreenEditing(id, cm) {
	var container = jQuery('#' + id).parents("td:first");
	var editorDiv = jQuery('.CodeMirror-scroll', container);
	var wrap = cm.getWrapperElement();

	if(!isFullScreen(cm) && jQuery("#DHTMLSuite_pane_center").length) {
		editorDiv.data({
			'state_east': paneSplitter.getState('east'),
			'state_west': paneSplitter.getState('west')
		});

		paneSplitter.collapsePane('east');
		paneSplitter.collapsePane('west');
		//paneSplitter.collapsePane('east');
		toggleFullscreenEditing.beforeFullscreen = {
			height: editorDiv.height(),
			width: editorDiv.width()
		}

		//editorDiv.parents("div.CodeMirror:first").css({
		//	position: 'static'
		//});
		//editorDiv.addClass('fullscreen');

		wrap.className += " CodeMirror-fullscreen";
        wrap.style.height = winHeight() + "px";
        document.documentElement.style.overflow = "hidden";


		//var width = jQuery("#DHTMLSuite_pane_center").css('width');
		//var height = jQuery("#DHTMLSuite_pane_center").css('height');
		//editorDiv.height(height);
		//editorDiv.width(width);
		//CODEMIRROR[id].refresh();
	} else {
		var data = editorDiv.data();
		if(data['state_east'] && data['state_east'] == 'expanded') paneSplitter.expandPane('east');
		if(data['state_west'] && data['state_west'] == 'expanded') paneSplitter.expandPane('west');

		wrap.className = wrap.className.replace(" CodeMirror-fullscreen", "");
        wrap.style.height = "";
        document.documentElement.style.overflow = "";
		//editorDiv.parents("div.CodeMirror:first").css({
		//	position: 'relative'
		//});
		//editorDiv.removeClass('fullscreen');

		//editorDiv.height(toggleFullscreenEditing.beforeFullscreen.height);
		//editorDiv.width(toggleFullscreenEditing.beforeFullscreen.width);
		//CODEMIRROR[id].refresh();
	}
	cm.refresh();
}

function defineTempleteMode() {
	if(typeof(CodeMirror) != 'undefined') {
		CodeMirror.defineMode("mojotemplates", function(config) {
			return CodeMirror.multiplexingMode(
			CodeMirror.getMode(config, 'text/html'), {
				open: '<%',
				close: '%>',
				mode: CodeMirror.getMode(config, 'text/x-perl'),
				delimStyle: 'delimit'
			});
		});
	}
}

function set_route_alias(form) {
	if(jQuery('#' + form).length && jQuery('#' + form).find('input[name=alias]').length) {
		var alias = '';
		var layout = '';
		var $alias = jQuery('#' + form).find('input[name=alias]');
		var $layout = jQuery('#' + form).find('select[name=layout]');
		var $url_for = jQuery('#' + form).find('select[name=url_for]');

		if(typeof $alias.data('backup-alias') == 'undefined') {
			alias = $alias.val();
			layout = $layout.text();
			$alias.data('backup-alias', alias);
			$layout.data('backup', layout);
		} else {
			alias = $alias.data('backup-alias');
			layout = $layout.data('backup');
		}

		if($url_for.val() && $url_for.find('option:selected').data('alias')) {

			alias = $url_for.find('option:selected').data('alias');
			$alias.val(alias).attr('readonly', true).click();
		} else {

			$alias.val(alias).attr('readonly', false).click();
		}

		if($url_for.val() && $url_for.find('option:selected').data('layout')) {

			layout = $url_for.find('option:selected').data('layout');

			$layout.find('option:contains("'+layout+'")').attr('selected', true);
			$layout.attr('disabled', true);
		} else {

			$layout.find('option:contains("'+layout+'")').attr('selected', true);
			$layout.attr('disabled', false);
		}

	}
}

function restart_fcgi(){
	$.ajax({
		url: '/admin/main/body',
		data: {do: 'restart_fcgi'},
		timeout: 2000,
		beforeSend: function(){
			$("form[name=form-restart-fcgi] input[type=button]").val('Сбрасываю ...');
		}
	})
	.always(function() {
		$("form[name=form-restart-hypnotoad] input[type=submit]").val('Сбросить кэш');
		do_submit(document.getElementById('form-restart-fcgi'), 'user_info', '/admin/main/body');
	});
	return false;
}

function restart_hypnotoad(){
	$.ajax({
		url: '/admin/main/body',
		data: {do: 'restart_hypnotoad'},
		timeout: 2000,
		beforeSend: function(){
			$("form[name=form-restart-hypnotoad] input[type=button]").val('Сбрасываю ...');
		}
	})
	.always(function() {
		$("form[name=form-restart-hypnotoad] input[type=submit]").val('Сбросить кэш');
		do_submit(document.getElementById('form-restart-hypnotoad'), 'user_info', '/admin/main/body');
	});
	return false;
}
//function hidden_quick_view() { quick_view_div.style.display='none'; }
