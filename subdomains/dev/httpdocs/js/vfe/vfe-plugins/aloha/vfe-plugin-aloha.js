// Название:      VFE Aloha Plugin
// Версия:        1.0

(function() {

	var $ = {
	    onInit:			function(){

	    					vfe.Dummies.each(function(){
						        if (jQuery(this).data("vfe-textid")) jQuery(this).parent().addClass("aloha").data("vfe-textid", jQuery(this).data("vfe-textid")).end().remove();
						    });

						    vfe.editableContent	= jQuery(".aloha");

	    					if (vfe.editableContent.length > 0) {

		    					var fileref=document.createElement('script');
						  		fileref.setAttribute("type","text/javascript");
						  		fileref.setAttribute("src", vfe.Homepath+"vfe-plugins/aloha/aloha/lib/aloha.js");
						  		fileref.setAttribute("data-aloha-plugins","common/format,common/table,common/list,common/link,common/highlighteditables");
						  		fileref.onreadystatechange = function() {
							    	if (this.readyState == 'complete') {
							      		loadScripts();
							    	}
							   	}
							   	fileref.onload = loadScripts;
							   	document.getElementsByTagName("head")[0].appendChild(fileref);	

					    	}

					    	function loadScripts() {
				    			var fileref=document.createElement('script');
						  		fileref.setAttribute("type","text/javascript");
						  		fileref.setAttribute("src", vfe.Homepath+"vfe-plugins/aloha/vfe-plugin-aloha-save.js");
						  		document.getElementsByTagName("head")[0].appendChild(fileref);	


						  		fileref=document.createElement('link');
						  		fileref.setAttribute("type","text/css");
						  		fileref.setAttribute("rel","stylesheet");
						  		fileref.setAttribute("href", vfe.Homepath+"vfe-plugins/aloha/aloha/css/aloha.css");
						  		document.getElementsByTagName("head")[0].appendChild(fileref);	

						  		if (vfe.settings.panelEditable == 1) $.onEditOn();
					    	}

	    				},
		onEditOn:		function(){
							if (typeof Aloha != "undefined") Aloha.jQuery(vfe.editableContent).aloha();
							jQuery(".aloha-sidebar-bar").show();
						},
		onEditOff:		function(){
							if (typeof Aloha != "undefined") Aloha.jQuery(vfe.editableContent).mahalo();
							jQuery(".aloha-sidebar-bar").hide();
	                		jQuery(".aloha-editable-highlight").removeClass("aloha-editable-highlight");
						}
	};

	vfe.registerPlugin($);

}());