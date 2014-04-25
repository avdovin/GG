var $popupIteminfo = $("#popup-kartochka");


$(function(){

	$(document).on('click', '.list__entry a', function(){
		get_iteminfo( $(this).closest('.list__entry').data('item-id') );

		return false;
	});

	$(document).on('click', '.thumbs__list a', function(){
		var myInstance = $('.cloudzoom').data('CloudZoom');
		myInstance.loadImage($(this).attr('href'), $(this).data('cloudzoom'));

		return false;
	});

	$(document).on('click', '.kartochka__colors a', function(){
		$(".kartochka__colors a").removeClass('colors__entry_current');
		$(this).addClass('colors__entry_current');

		return false;
	});

	$(document).on('click', '.button_basket', function(){
		//kartochka__basket_remove
		var _this = $(this);
		var itemId = _this.attr('data-item-id');
		var delFlag = _this.hasClass('kartochka__basket_remove') ? true : false;

		if( !$(".colors-"+itemId+" a.colors__entry_current").length){
			GG.notify_warning("Пожалуйста, выберите цвет товара");
			return false;
		}

		addItem({
			delFlag: delFlag,
			items: [{
				id: itemId,
				count: $("input[name=count-"+itemId+"]").val(),
				color: $(".colors-"+itemId+" a.colors__entry_current").data('color-id'),
				size: $("input[name=count-"+itemId+"]").attr('data-size')
			}],
			onSuccess: function(){
				if(delFlag){
					_this.removeClass('kartochka__basket_remove').addClass('kartochka__basket_add');
					_this.text('Добавить в корзину');

					GG.notify_delete("Изменения успешно внесены в корзину. <a href='/catalog/basket'>Оформить заказ?</a>");
				} else {
					_this.removeClass('kartochka__basket_add').addClass('kartochka__basket_remove');
					_this.text('Удалить из корзины');

					GG.notify_add("Вы можете перейти к корзине что бы незамедлительно <a href='/catalog/basket'>оформить заказ</a>");
				}
			}
		});
		return false;
	});

	get_items();
});

var get_items_progress = 0;
function get_items(options){
	options = jQuery.extend({
		onSuccess: function(data){
			set_items_list(data);
		},
		beforeSend: function(){
			if(typeof item_id == 'undefined' && typeof add_to_list == 'undefined') set_items_list();
		},
		send_params: [],
		async: true,
		url : typeof(url) != 'undefined' ? url : "/catalog/ajax/list_items",
		page : 1 //typeof page != 'undefined' ? page : 1

	}, options);


	var filter = get_filter();
	filter['page'] = options.page;
	var return_status = false;

	$.ajax({
		url: options.url,
		async: options.async,
		beforeSend: function(){
			options.beforeSend();
			get_items_progress = 1;
		},

		success: function(data){
			options.onSuccess(data);
			return_status = true;
		},

		error: function(data){
			//alert('Ошибка получения товаров..');
		},
		complete: function(){
			$("#loader").hide();
			setTimeout(function(){ get_items_progress = 0}, 500);
			//if(typeof(current_element_id) !== 'undefined' && typeof extend_options.add != 'undefined') window.location = '/catalog/'+catalog;
		},
		data: filter
	});

	return return_status;
}

function iteminfo_body(item_id){
	var item_loading = $(".iteminfo--body");

	var $item = $(".slider__entry[data-item-id="+item_id+"]");
	var parent = $item.parents('li');

	$(".slider__entry").removeClass('active');
	$item.addClass('active');

	$.ajax({
		url: "/catalog/ajax/iteminfo/body/"+item_id,
		type: 'get',
		dataType: 'html',
		beforeSend: function(){
			item_loading.html('').addClass('catalog_loading');

		$(".slider__entry[data-item-id]").removeClass('slider__entry_current');
		$(".slider__entry[data-item-id="+item_id+"]").addClass('slider__entry_current');
		},

		success: function(data){
			item_loading.removeClass('catalog_loading').html(data);


		},
		complete: function(){
			item_loading.removeClass('catalog_loading');

			updateAmountControl();
		},
		error: function(jqXHR, textStatus, errorThrown){
		},
		data: {}
	});
}


function iteminfo_set_items_list(data){
	$(".slider__container").removeClass('loading').html(data);
	$(".slider__entry[data-item-id="+item_id+"]").addClass('slider__entry_current');
}

function set_items_list(data){
	if(typeof data != 'undefined'){
		$("#catalog-list-inner").removeClass('loading-items').html(data);

	} else{
		$("#catalog-list-inner").addClass('loading-items');//.html('');
	}
}

function get_filter(){
	var filter = {};

	if( $(".menu__list .submenu__entry_current").length ){
		filter['category_id'] = $(".menu__list .submenu__entry_current a").data('category-id');
	}
	else if( $(".menu__list .list__entry_current").length ){
		filter['category_id'] = $(".menu__list .list__entry_current a.entry__link").data('category-id');
	}


	return filter;
}

function get_iteminfo(item_id){
	$.ajax({
		url: '/catalog/iteminfo/'+item_id+'/body',
		beforeSend: function(){
			GG.togglePopup("popup-kartochka");
			$popupIteminfo.find('.kartochka__loading').show();
		},

		success: function(data){
			$popupIteminfo.find('.iteminfo-inner').html(data);

			var nextId = 0,
				prevId = 0,
				next_page = 0,
				prev_page = 0;


			updateAmountControl();

			refreshCloudzoom();

			var itemName = $(".list__entry[data-item-id='"+item_id+"'] .info__title").text();
			History.pushState({}, itemName, location.protocol + '//' + location.host + '/catalog/iteminfo/'+item_id);
		},

		error: function(data){
		},
		complete: function(){
			$popupIteminfo.find('.kartochka__loading').hide();
		}
	});
}

function refreshCloudzoom(){
	var myInstance = $('.cloudzoom').data('CloudZoom');
	if (typeof myInstance != 'undefined' && myInstance) myInstance.destroy();
	CloudZoom.quickStart();
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

		topBasketUpdate({total: data.count_formated, middle: $(".korzina .korzina__list").amountControl('sklonyator', {amount: data.count_formated, text: 'товар'}), price: data.price_formated + ' руб.'});
		// if(data.basket_header){
		// 	$(settings.basketHeader).html(data.basket_header);
		// }
	})
	.fail(function() {
		settings.onFail(settings);
	})
	.always(function() {
		settings.onComplete(settings);
	});

	return jqxhr;
}



// header basket update
function topBasketUpdate(data) {

	if (typeof data.total == 'undefined' || typeof data.price == 'undefined') throw "There are no text and/or price to update.";

	if (typeof data.middle == 'undefined') data.middle = '';

	var $basket			  = $(".header__basket"),
		$basketContainers	= $basket.find(".basket__container"),
		$basketContainerOld  = $basketContainers.filter(":visible").clone(),
		$basketContainerNew  = typeof data.total != 'undefined' && data.total == 0 ? $basketContainers.filter(".empty").clone() : $basketContainers.filter(".full").clone(),
		animationSpeed	   = data.animationSpeed || 500;

	if ($basketContainers.filter('.original').length) {

		var $clone = $basketContainers.filter('.clone');
		if ($clone.length) {
			$clone.find(".basket__total").html(data.price);
			$clone.find(".basket__count").html(data.total);
			$clone.find(".basket__unit").html(data.middle);
		}

		return false;
	}

	if ($basketContainerOld.is(".empty") && data.total == 0) {
		return false;
	}

	if ($basketContainerOld.is(".full") && data.total == 0) {
		$basketContainerOld.hide();
		$basketContainers.find(".empty").show();
		return false;
	}

	// super picture animation
	var bigimage = $(".kartochka .kartochka__left .cloudzoom").attr("src"),
		$image   = $("<img/>", {'src': bigimage, 'class': 'floatpic'});

	$image.prependTo($(".kartochka .kartochka__left")).animate({"z-index": 100000, "top": -500, "left": 200, "opacity": 0, "width": "1%", "height": "1%"}, 500, function(){$(this).remove()});
	//

	$basketContainers.hide();
	$basketContainerOld.appendTo($basket).show();
	$basketContainerNew.appendTo($basket).show();

	$basketContainerOld.addClass("original").removeClass("clone");
	$basketContainerNew.addClass("clone").removeClass("original");

	$basketContainerOld.
		css("background", data.background || 'transparent').
		animate(
		{"top": 100, "opacity": 0},
		animationSpeed,
		function(){
			$(this).remove();
		}
	);

	$basketContainerNew.
		css("opacity", 0).
		css("display", "block").
		css("z-index", 10).
		css("top", -50).
		css("background", "").
		appendTo($basket).
		find(".basket__total").html(data.price).
		end().
		find(".basket__count").html(data.total).
		end().
		find(".basket__unit").html(data.middle).
		end().
		animate({"top": 25, "opacity": 1}, animationSpeed/2, function(){
			$(this).removeClass("clone");

			if (typeof data.total != 'undefined' && data.total == 0) {
				$basketContainers.filter(".empty:hidden").remove();
			} else {
				$basketContainers.filter(".full:hidden").remove();
			}
		});

}
