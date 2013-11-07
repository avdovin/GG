var 	get_items_progress = 0,
		$catalogItemsInner = $("#catalog-items-inner"),
		$catalogLoading = $(".catalog__list .catalog__loading");
		$catalogFilters = $(".catalog .catalog__filters"),
		$popupIteminfo = $("#popup-kartochka");

$(function(){



	get_items();
})

function get_filter(){
	var filter = {};

	if( $("#category-left-menu .current").length ){
		filter['id_category'] = $("#category-left-menu .current a").attr('data-category-id');
	}

	if( $catalogFilters.find('.filters__actions .actions__entry_current').length ){
		filter[ $catalogFilters.find('.filters__actions .actions__entry_current').attr('data-lkey') ] = $catalogFilters.find('.filters__actions .actions__entry_current').attr('data-value');
	}

	if( $catalogFilters.find('.season__list .list__entry_current').length ){
		filter[ $catalogFilters.find('.season__list .list__entry_current a').attr('data-lkey') ] = $catalogFilters.find('.season__list .list__entry_current a').attr('data-value');
	}

	if( $(".catalog__sorting .block__option_current a").length ){
		filter[ 'sort_field' ] = $(".catalog__sorting .block__option_current a").data('lkey');
		filter[ 'sort_dir' ] = $(".catalog__sorting .block__option_current a").hasClass('desc') ? 'desc' : 'asc';
	}



	filter[ 'id_brand' ] = $(".manufacturer__list .current").length ? $(".manufacturer__list .current").attr('data-value') : 0;

	//filter['size_from'] = $("#catalog-filters-sizes-from").val();
	// if ($( "#catalog-filter-sizes-slider" ).length > 0) {
	// 			filter['size_from'] = $( "#catalog-filter-sizes-slider" ).slider( "values", 0 );
	// 	} else {
	// 			filter['size_from'] = $("#catalog-filters-sizes-from").val();
	// 	}

	// //filter['size_to'] = $("#catalog-filters-sizes-to").val();
	// if ($( "#catalog-filter-sizes-slider" ).length > 0) {
	// 	filter['size_to'] = $( "#catalog-filter-sizes-slider" ).slider( "values", 1 );
	// } else {
	// 	filter['size_to'] = $("#catalog-filters-sizes-to").val();
	// }

	// if($("#catalog-filters-season li a.current").length) filter['season'] = $("#catalog-filters-season li a.current").attr('set') || 0;
	// if($(".filter-type.current").length) filter['filter_type'] = $(".filter-type.current").attr('set');

	// filter['price_from'] = $("#catalog-filters-price-from").val();
	// filter['price_to'] = $("#catalog-filters-price-to").val();

	// filter['id_brand'] = $("#manufactor-container li span.checked").length ? $("#manufactor-container li span.checked").attr('brand_id') : 0;

	// if($("#catalog-sorting .sort.current").length) filter['sort'] = $("#catalog-sorting .sort.current").attr('sort');
	// if($("#catalog-sorting .sort.current").length) filter['sortorder'] = filter['sort'] == 1 ? $("#catalog-sorting .sort.current").attr('order') : '';

	// if(filter['season'] > 0 || filter['filter_type'] > 1 || filter['id_brand'] || filter['sort'] ){
	// 	$("#catalog-reset").show();
	// } else {
	// 	$("#catalog-reset").hide();
	// }

	var pairs = [];
	for (var key in filter)
		if (filter.hasOwnProperty(key))
			if (filter[key]) pairs.push(encodeURIComponent(key) + '=' + encodeURIComponent(filter[key]));

	//History.pushState(filter, document.title, location.protocol + '//' + location.host + location.pathname + '?'+pairs.join('&'));


	if(typeof category_id != 'undefined') filter['category_id'] = category_id;
	return filter;
}

function get_items(settings){

	if(get_items_progress==1) return false;

	var settings = jQuery.extend({
		onSuccess: function(data, settings){
			set_items_list(data, settings.add);
		},
		onBefore: function(settings){
			if(typeof index == 'undefined' && typeof add_to_list == 'undefined') set_items_list();
		},
		onComplete: function(settings){},
		onFail: function(settings){},
		update_items_count: 1,
		url : "/catalog/ajax/items",
		send_params: [],
		async: true,
		add : typeof add_to_list ? true : false,
		page : 1 //typeof page != 'undefined' ? page : 1
	}, settings);

	if(!settings.add && !settings['send_params'].offset_off){
		page = 1;
		$("#catalog-items-inner").css('height', '');
		//$('html, body').animate({scrollTop:490}, 'fast');
	}

	if(typeof(current_element_id) !== 'undefined'){
		settings.url = '/catalog/ajax/iteminfo/items';
		settings.success = function(data){
			iteminfo_set_items_list(data);
		};
	}

	var filter = get_filter();
	filter['page'] = settings.page;

	filter = jQuery.extend(filter, settings.send_params);
	if(typeof settings.slider_off != 'undefined') filter['price'] = 1;


	var jqxhr = $.ajax({
		url: settings.url,
		dataType: 'json',
		//type: 'GET',
		async: settings.async,
		beforeSend: function( xhr ) {
			settings.onBefore(settings);
			get_items_progress = 1;
		},
		data: filter
	})
	.done(function( data ) {
		if(typeof total_page != 'undefined') total_page = data.total_page;
		settings.onSuccess(data, settings.add);

		//if(typeof settings.slider_off == 'undefined' && typeof data != 'undefined' && typeof(current_element_id) == 'undefined') set_slider_prices_values(data.price_min, data.price_max);

		if(data.offset_off && !settings.add){
			//var offset = (890 * (filter['page']-1)) + 455;
			var offset = (890 * (filter['page']-1)) + 535;
			$('html, body').animate({scrollTop:offset}, 'fast');
		}

		if(typeof build_nav != 'undefined'){
			build_nav();

			get_items_progress = 0;

			if ($("#catalog-items-inner").height() - $(window).height() <= $(window).scrollTop() + 550) {
				if(total_page != 1 && page < total_page){
					page = page + 1;
					get_items({
						page: page,
						slider_off: 1,
						beforeSend: function(){},
						url: "/catalog/ajax/items"
					});
				}
			}

		}
	})
	.fail(function() {
		settings.onFail(settings);
	})
	.always(function() {
		settings.onComplete(settings);

		get_items_progress = 0;
	});
	return jqxhr;
}


function set_items_list(data, add){
	if(typeof add == 'undefined') add = false;

	if(typeof data != 'undefined' && typeof data.html != 'undefined'){
		if(add) {
			$catalogItemsInner.append(data.html);
		} else {
			$catalogItemsInner.html(data.html);
		}
		$catalogLoading.fadeOut();

	} else if(!add){
		$catalogLoading.show();
		$catalogItemsInner.addClass('loading-items').html('');
	}
}

function get_iteminfo(item_id){

	$.ajax({
		url: '/catalog/ajax/iteminfo_body/'+item_id,
		beforeSend: function(){
			$popupIteminfo.find('.kartochka__loading').show();
		},

		success: function(data){
			$popupIteminfo.find('#iteminfo-inner').html(data);

			var nextId = 0,
				prevId = 0,
				next_page = 0,
				prev_page = 0;


			$("#popup-iteminfo .kartochka-next").unbind('click').hide();

			// if( $("#catalog-list-inner .catalog-list-entry[data-item-id="+item_id+"]").next().is('.catalog-list-entry') ){
			// 	nextId = $("#catalog-list-inner .catalog-list-entry[data-item-id="+item_id+"]").next().attr('data-item-id');

			// 	set_next_iteminfo_nav(nextId)

			// } else if( $("#pagenav a.current").next().length ){
			// 	if( $("#pagenav a.current").next().length ){
			// 		next_page = $("#pagenav a.current").next().text();
			// 		set_next_iteminfo_nav(0, next_page );
			// 	}
			// }

			// $("#popup-iteminfo .kartochka-prev").unbind('click').hide();
			// if( $("#catalog-list-inner .catalog-list-entry[data-item-id="+item_id+"]").prev().is('.catalog-list-entry') ){
			// 	prevId = $("#catalog-list-inner .catalog-list-entry[data-item-id="+item_id+"]").prev().attr('data-item-id');
			// 	set_prev_iteminfo_nav(prevId);

			// } else if(  $("#pagenav a.current").prev().length ){
			// 	if( $("#pagenav a.current").prev().length ){
			// 		prev_page = $("#pagenav a.current").prev().text();
			// 		set_prev_iteminfo_nav(0, prev_page );
			// 	}

			// }

			updateAmountControl();

			var myInstance = $('.cloudzoom').data('CloudZoom');
			if (typeof myInstance != 'undefined') myInstance.destroy();
			CloudZoom.quickStart();

			//History.pushState({}, "", location.protocol + '//' + location.host + '/catalog/iteminfo/'+item_id);
		},

		error: function(data){
		},
		complete: function(){
			$popupIteminfo.find('.kartochka__loading').hide();
		}
	});
}

function addItem(settings) {
	var settings = jQuery.extend({
		async: true,
		url: '/catalog/ajax/update_basket_items',
		basketHeader: '.header__basket',					// jQuery селектор контейнера корзины в шапке
		items: {},											// Массив товаров
		delFlag: false,										// Флаг удаления товара
		updateFlag: false,									// Флаг обновления товара
		onSuccess: function(data, settings){
		},
		onBefore: function(settings){},
		onComplete: function(settings){},
		onFail: function(settings){}
	}, settings);

	var data = {
		items: JSON.stringify( settings.items ),
		delFlag: settings.delFlag,
	};
	delete settings.items;
	//debugLog("addItem: " + settings);

	var jqxhr = $.ajax({
		url: settings.url,
		dataType: 'json',
		type: 'POST',
		async: settings.async,
		beforeSend: function( xhr ) {
			settings.onBefore(settings);
		},
		data: data
	})
	.done(function(data) {
		settings.onSuccess(data, settings);

		if(data.basket_header){
			$(settings.basketHeader).html(data.basket_header);
		}
	})
	.fail(function() {
		settings.onFail(settings);
	})
	.always(function() {
		settings.onComplete(settings);
	});

	return jqxhr;
}





function updateAmountControl(){
	if ($.amountControl && $(".kartochka").length && $(".kartochka:visible")) {
			$(".kartochka").amountControl({
					wrapper:                 '.kartochka',
					child:                   '.kartochka__right',
					control:                 '.kartochka__amount .amount__control',

					unitname:                'товар',

					unit_state_container:    '.kartochka__total',
					unit_amount:             '.kartochka__total .total__amount',
					unit_total:              '.kartochka__total .total__price',
					unit_total_postfix:      'руб.',

					callback_total_update:   function(data){},
					callback_before_update:  function(){},
					callback_after_update:  function(){}
			});
	}

	if ($.amountControl && $(".korzina .korzina__list").length) {
			$(".korzina .korzina__list").amountControl({
					wrapper:                 '.korzina__list',
					child:                   '.korzina__entry',
					control:                 '.entry__amount-container .amount__control',

					unitname:                'товар',

					unit_state_container:    '.entry__total-container',
					unit_amount:             '.entry__total-container .total__amount',
					unit_total:              '.entry__total-container .total__price',
					unit_total_postfix:      'руб.',

					all_total:               '.korzina__zakaz .zakaz__total',
					all_total_amount:        '.korzina__zakaz .total__items',
					all_total_price:         '.korzina__zakaz .total__price',
					all_total_middle:        '.korzina__zakaz .total__middle',
					all_total_price_postfix: 'руб.',

					callback_total_update:   function(data){
							topBasketUpdate({
									total: data.total,
									middle: data.middle,
									price: data.price+' руб.',

									animationSpeed: 500,
//                    background: '#ed1c24'
							});
					},
					callback_before_update:  function(){},
					callback_after_update:  function(data){
							if (!data.entries) {
									$(".korzina .korzina__clear").hide();
									$(".korzina__empty").slideDown();
							} else {
									$(".korzina .korzina__clear").show();
									$(".korzina__empty").slideUp();
							}

							if (!data.total) {
									$(".korzina__comment").hide();
							} else {
									$(".korzina__comment").show();
							}

							if (!data.total || !data.entries) {
									$(".korzina .korzina__zakaz").hide();
									$(".korzina .korzina__order").hide();
							} else {
									$(".korzina .korzina__zakaz").show();
									$(".korzina .korzina__order").show();
							}
					}
			});
	}
}

function changePic(img) {
	var myInstance = $(".cloudzoom").attr('src', img).data('CloudZoom');
	myInstance.destroy();
	CloudZoom.quickStart();
}

//