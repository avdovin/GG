$(function(){
	$("body").on('click', '.sizes__list a', function(){
		$(".iteminfo-basket-block").show().find("input").attr('data-size', $(this).attr('data-value') );

		return false;
	});

	$("body").on("click", ".korzina .korzina__order", function(){
		$("#popup-order textarea[name=comment]").val( $("textarea[name=basketcomment]").val() );
		togglePopup('popup-order');
	});

	$("body").on("click", "#popup-order .order__container .order__back", function(){
		togglePopup();
	});


	// order send
	$("body").on("click", "#popup-order .order__submit", function(e){
		var $parent  = $(this).closest(".popup"),
			$loading = $parent.find(".popup__loading"),
			$wrapper = $parent.find(".order__wrapper"),
			$error   = $wrapper.find(".popup-error");

		$loading.fadeIn(1000, function(){
			var old_height = $wrapper.height(),
				new_height = 0;

			$(this).fadeOut();

			// if ok
			$.ajax({
				url: '/catalog/ajax/order/checkout',
				dataType: 'json',
				type: 'POST',
				beforeSend: function( xhr ) {
				},
				data: $wrapper.serialize()
			})
			.done(function(data) {
				if( Object.keys(data.errors).length ){
					addFormErrors($wrapper, data.errors);

				} else {
					$error.hide();
					$parent.find(".popup__title").text("Спасибо!");
					$wrapper.find(".order__container").hide();
					$wrapper.find(".order__ok").show();
					new_height = $wrapper.height();
					$wrapper.height(old_height).animate({height: new_height});
				}
			})
			.fail(function() {
				$error.html(buildServerErrorsString( {misc: 'Системная ошибка, повторите попытку позже'} ));
			});

			// if error
//            $error.html("Какая-то ошибка.").show();
//            new_height = $wrapper.height();
//            $wrapper.height(old_height).animate({height: new_height});
		});

		e.preventDefault();
	});

	$("body").on('click', '.korzina__clear', function(){
		if( !confirm('Вы уверены что хотите удалить все товары из корзины?') ) return false;
	})

	$("body").on('click', '.kartochka__basket', function(){
		//kartochka__basket_remove
		var _this = $(this);
		var itemId = _this.attr('data-item_id');
		var delFlag = _this.hasClass('kartochka__basket_remove') ? true : false;

		addItem({
			delFlag: delFlag,
			items: [{
				id: itemId,
				count: $("input[name=count-"+itemId+"]").val(),
				size: $("input[name=count-"+itemId+"]").attr('data-size')
			}],
			onSuccess: function(){
				if(delFlag){
					_this.removeClass('kartochka__basket_remove').addClass('kartochka__basket_add');
					_this.find('.basket__label').text('Добавить в корзину');
				} else {
					_this.removeClass('kartochka__basket_add').addClass('kartochka__basket_remove');
					_this.find('.basket__label').text('Удалить из корзины');
				}
			}
		});
		return false;
	});

	// amountControl
	// .amountControl('updateAmount'); - функция обновления общей суммы в корзине (в случае динамического удаления одного из товаров)
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
			callback_after_update:   function(){}
		});
	}
	//

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
					$(".korzina__empty").show();
				} else {
					$(".korzina .korzina__clear").show();
					$(".korzina__empty").hide();
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

	// korzina delete row
	$("body").on("click", ".korzina .korzina__entry .filters__reset", function(){
		if( !confirm('Вы уверены что хотите удалить товар - '+$(this).attr('data-label') +' ?' ) ) return false;
		var itemId = $(this).attr('data-item-id');

		var $entry   = $(this).closest(".korzina__entry"),
			$loading = $entry.find(".entry__loading");

		$loading.fadeIn(function(){
			var fadeOut = function(){
				$loading.fadeOut();
			}
			var deleteRow = function(){
				$entry.animate(
					{height: 0, opacity: 0, margin: 0, padding: 0, left: -1000},
					function(){
						$(this).remove();
						$(".korzina .korzina__list").amountControl('updateAmount');
					}
				);
			}
			addItem({
				delFlag: true,
				items: [{
					id: itemId,
				}],
				onSuccess: function(data){
					fadeOut();
					deleteRow();
				}
			});

		});
	});

	// korzina clear
	// $("body").on("click", ".korzina .korzina__clear", function(){
	// 	var $loading = $(".korzina .korzina__loading");

	// 	$loading.fadeIn(function(){
	// 		$(this).hide();
	// 		$("html, body").animate({scrollTop: 0});
	// 		$(".korzina .korzina__list .korzina__entry").remove();
	// 		$(".korzina .korzina__list").amountControl('updateAmount');
	// 	});
	// });

});

// header basket update
function topBasketUpdate(data) {

	if (typeof data.total == 'undefined' || typeof data.price == 'undefined') throw "There are no text and/or price to update.";

	if (typeof data.middle == 'undefined') data.middle = '';

	var $basket              = $(".header__basket"),
		$basketContainers    = $basket.find(".basket__container"),
		$basketContainerOld  = $basketContainers.filter(":visible").clone(),
		$basketContainerNew  = typeof data.total != 'undefined' && data.total == 0 ? $basketContainers.filter(".empty").clone() : $basketContainers.filter(".full").clone(),
		animationSpeed       = data.animationSpeed || 500;

	if ($basketContainers.filter('.original').length) {

		var $clone = $basketContainers.filter('.clone');
		if ($clone.length) {
			$clone.find(".basket__total").html(data.price);
			$clone.find(".basket__link").html(data.total +' '+ data.middle);
		}

		return false;
	}

	if ($basketContainerOld.is(".empty") && data.total == 0) {
		return false;
	}

	// super picture animation
	var bigimage = $(".kartochka .kartochka__left .cloudzoom").attr("src"),
		$image   = $("<img/>", {'src': bigimage, 'class': 'floatpic'});

	$image.prependTo($(".kartochka .kartochka__left")).animate({"z-index": 100000, "top": -500, "left": 700, "opacity": 0, "width": "1%", "height": "1%"}, 500, function(){$(this).remove()});
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
		find(".basket__link").html(data.total +' '+ data.middle).
		end().
		animate({"top": 20, "opacity": 1}, animationSpeed/2, function(){
//            $(this).removeClass("clone");

			if (typeof data.total != 'undefined' && data.total == 0) {
				$basketContainers.filter(".empty:hidden").remove();
			} else {
				$basketContainers.filter(".full:hidden").remove();
			}
		});

}