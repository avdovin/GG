// Название:      VFE Link Plugin
// Версия:        1.0

(function() {

	var $ = {
		object: 'pluginLink',
		moduleButtons: [
		    {
				name:	"link",
				id:		"vfe-float-link",
				href:	"#",
				title:	"Вставить ссылку"
		    },
		    {
				name:	"unlink",
				id:		"vfe-float-unlink",
				href:	"#",
				title:	"Удалить ссылку"
		    }
	    ],
	    onInit:			function(){},
	    mainFunction:	function(me){
	    					var _this = me;

	    					if (jQuery(_this).is(".disabled") || vfe.Float.is(".disabled")) return false;

	    					if (jQuery(_this).is("#vfe-float-link")) { 
						        var value = (typeof vfe.plugins.sys.pluginLink != "undefined") ? vfe.plugins.sys.pluginLink.attr("href") : '';
						        var href = prompt("URL:", value); 
						   		if (href) {
							        if (value) {
							        	vfe.plugins.sys.pluginLink.attr("href", href);
							        } else  {
							        	vfe.plugins.functions.replaceSelectionWithHtml('<a href="'+href+'">'+vfe.plugins.functions.getSelectionHtml()+'</a>');	
							        } 
							        vfe.float.save.removeClass("disabled");
							        vfe.float.link.addClass("disabled");
							        vfe.float.unlink.addClass("disabled");

							        // update links if new
							        $.onBeforeBlockInit();
						    	}
					    	} else if (jQuery(_this).is("#vfe-float-unlink")) {
						   		if (vfe.plugins.sys.pluginLink) {
						   			var ahtml = vfe.plugins.sys.pluginLink.html();
						   			vfe.plugins.sys.pluginLink.after(ahtml);
						   			vfe.plugins.sys.pluginLink.remove();
						   			vfe.plugins.sys.pluginLink = undefined;
							        vfe.float.save.removeClass("disabled");
						   			vfe.float.link.addClass("disabled");
							        vfe.float.unlink.addClass("disabled");
						    	}
					    	}

					    	return false;
	    				},
	    
	    onBeforeBlockInit: function(){
	    	if (jQuery.inArray("link", vfe.loadedPlugins) > -1 && jQuery.inArray("link", vfe.getBlockPlugins()) > -1) {
				jQuery("a", vfe.Content_source).click(function(){
					vfe.plugins.sys.pluginLink = jQuery(this);
					vfe.float.link.removeClass("disabled");
					vfe.float.unlink.removeClass("disabled");
				});
	    	}
	    },
	    onBlockMouseClick: function(){
	    	if (jQuery.inArray("link", vfe.loadedPlugins) > -1 && jQuery.inArray("link", vfe.getBlockPlugins()) > -1) {
		    	if ((typeof window.getSelection != "undefined" && window.getSelection() != '') || (typeof document.selection != "undefined" && document.selection.type == "Text" && document.selection.createRange().htmlText != '')) {
		            vfe.float.link.removeClass("disabled");
		            vfe.plugins.sys.pluginLink = undefined;
		        } else {
		            vfe.float.link.addClass("disabled");
		            vfe.float.unlink.addClass("disabled");
		        }
	    	}
	    },
	    onBeforeCancel: function(){
	    	if (jQuery.inArray("link", vfe.loadedPlugins) > -1 && jQuery.inArray("link", vfe.getBlockPlugins()) > -1) {
				vfe.plugins.sys.pluginLink = undefined;
	    	}
	    },

	    moduleFunctions: {
	    	getSelectionHtml: function() {
			    var html = "";
			    if (typeof window.getSelection != "undefined") {
			        var sel = window.getSelection();
			        if (sel.rangeCount) {
			            var container = document.createElement("div");
			            for (var i = 0, len = sel.rangeCount; i < len; ++i) {
			                container.appendChild(sel.getRangeAt(i).cloneContents());
			            }
			            html = container.innerHTML;
			        }
			    } else if (typeof document.selection != "undefined") {
			        if (document.selection.type == "Text") {
			            html = document.selection.createRange().htmlText;
			        }
			    }
			    return html;
			},
			replaceSelectionWithHtml: function(html) {
			    var range, html;
			    if (window.getSelection && window.getSelection().getRangeAt) {
			        range = window.getSelection().getRangeAt(0);
			        range.deleteContents();
			        var div = document.createElement("div");
			        div.innerHTML = html;
			        var frag = document.createDocumentFragment(), child;
			        while ( (child = div.firstChild) ) {
			            frag.appendChild(child);
			        }
			        range.insertNode(frag);
			    } else if (document.selection && document.selection.createRange) {
			        range = document.selection.createRange();
			        html = (node.nodeType == 3) ? node.data : node.outerHTML;
			        range.pasteHTML(html);
			    }
			}
	    }
	};

	vfe.registerPlugin($);

}());