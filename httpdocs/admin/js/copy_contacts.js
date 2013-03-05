function copy_contacts(key) {
	table_a = document.getElementById("anketka_"+key);
	allanchor = table_a.getElementsByTagName("a").length;
	for(i = 0; i < allanchor; i++) {
		if (table_a.getElementsByTagName("a")[i].className == "pseudolink "+key) {
			eval(table_a.getElementsByTagName("a")[i].getAttribute("onclick"));
		}
	}
}

function save_contacts(key, replaceme, url, company) {
	ajaxIndex = key;
    ajaxform[ajaxIndex] = new sack();
	ajaxform[ajaxIndex].setVar("action", "save");
	ajaxform[ajaxIndex].setVar("index", company);

	table_a = document.getElementById("anketka_"+key);
	allanchor = table_a.getElementsByTagName("a").length;
	for(i = 0; i < allanchor; i++) {
		if (table_a.getElementsByTagName("a")[i].className == "pseudolink "+key) {
			name = table_a.getElementsByTagName("a")[i].getAttribute("lkey");
			name = name.replace(/\d+/, "");
			if (document.getElementById(name) && (document.getElementById(name).type == "select" || document.getElementById(name).type == "select-one")) {
				ajaxform[ajaxIndex].setVar(name, document.getElementById(name).options[document.getElementById(name).selectedIndex].value);
			} else {
				ajaxform[ajaxIndex].setVar(name, document.getElementById(table_a.getElementsByTagName("a")[i].getAttribute("lkey")).value);
			}
		}
	}
	
    ajaxform[ajaxIndex].requestFile = "/cgi-bin/company_a.cgi";
    ajaxform[ajaxIndex].method = "post";
	ajaxform[ajaxIndex].onError = function()   { whenError(ajaxIndex);}
	ajaxform[ajaxIndex].onFail  = function()   { whenError(ajaxIndex);}
   	ajaxform[ajaxIndex].onLoading = function() { whenLoading(ajaxIndex);}
   	ajaxform[ajaxIndex].onLoaded  = function() { whenLoaded(ajaxIndex);}
   	ajaxform[ajaxIndex].onInteractive = function() { whenInteractive(ajaxIndex);}

    ajaxform[ajaxIndex].onCompletion = function() { ld_content(replaceme, url, 0, 1) };
    ajaxform[ajaxIndex].runAJAX();
}
