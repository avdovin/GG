(function( $ ){ 
	$.fn.multiList = function(options) {
		var options = $.extend({
      		timeOut: 2000,
      		animateTime: 1000,
      		opacity: 0.5
    	}, options);

		return $(this).each(function() {
			var container = $(this);
			
			var 
			if(typeof requestUrl == 'undefined' || requestUrl == '') requestUrl = '/admin/main/body';
			
			this.options = args.options;
			this.razdel = args.razdel;
			this.requestUrl = args.requestUrl;
			this.lfield = args.lfield;
			this.controller = args.controller;
			this.inputnode = node;
			this.timer = null;
			
			
			//this.outFromId =  
			
			this.clearInterval = function(){
				if(this.timer) clearTimeout(this.timer);
			}
		});
})(jQuery);

function multiList(args){
	var opt = {
		lfield	: null,
		outId   : null,
		nodeId  : null,
		options : {
			draggable : false,
		},
		controller : 'main',
		razdel : null,
		lfield : null,
		requestUrl : '/admin/main/body'
	};
	
	args = jQuery.extend(opt, args);
	var node = jQuery(args.node);
	
	if(!node.length){
		console.log ("multiList: node '+"+node+"' not found");
		return false;
	}
		
	if(typeof requestUrl == 'undefined' || requestUrl == '') requestUrl = '/admin/main/body';
	
	this.options = args.options;
	this.razdel = args.razdel;
	this.requestUrl = args.requestUrl;
	this.lfield = args.lfield;
	this.controller = args.controller;
	this.inputnode = node;
	this.timer = null;
	
	
	//this.outFromId =  
	
	this.clearInterval = function(){
		if(this.timer) clearTimeout(this.timer);
	}
}

multiList.prototype.get = function(){
	this.node.focus();
	if (this.timer) {
		this.clearInterval();
	}
	
	var node = this;
	setTimeout(function(){ node._start_get }, 1000);	
};

multiList.prototype._start_get = function(){
	var value = this.node.val();
	pattern_item = new RegExp("fromselect", "g");
	
};
