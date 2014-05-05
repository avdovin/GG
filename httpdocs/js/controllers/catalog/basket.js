window._updateBasketInterval = null;

$(function(){
	$(document).on('click', '.korzina__clear', function(){
		if( !confirm('Вы уверены что хотите удалить все товары из корзины?') ) return false;
	})

	$(document).on('click', '.korzina__order', function(){
		$("textarea[name=comment]").val( $("textarea[name=order-comment]").val() );
		GG.togglePopup("popup-order");
		return false;
	});

	GG.attachForm("#popup-order", "#popup-order .order__submit", {
		onDone : function($wrapper, $error){
	 		var old_height = $wrapper.height(),
				new_height = 0;

			$error.hide();
			$wrapper.find(".popup__title").text("Спасибо за заказ!");
			$wrapper.find(".order__container").hide();
			$wrapper.find(".order__ok").show();
			new_height = $wrapper.height();
			$wrapper.height(old_height).animate({height: new_height});

			$("#popup-order .popup-close").unbind('click');

	 		$("body").on("click", ".popup-close", function(){
	 			togglePopup($(this).closest(".popup").attr("id"));
	 			window.location.href='/';
	 			return false;
	 		});
		}
	});

	// $("body").on("click", "#popup-order .order__submit", function(e){
	// 	var $parent  = $(this).closest(".popup"),
	// 		$loading = $parent.find(".popup__loading"),
	// 		$wrapper = $parent.find(".order__wrapper"),
	// 		$error   = $wrapper.find(".popup-error");

	// 	$loading.fadeIn(1000, function(){
	// 		var old_height = $wrapper.height(),
	// 			new_height = 0;

	// 		$(this).fadeOut();

			// // if ok
			// $.ajax({
			// 	url: '/catalog/ajax/order/checkout',
			// 	dataType: 'json',
			// 	type: 'POST',
			// 	beforeSend: function( xhr ) {
			// 	},
			// 	data: $wrapper.serialize()
			// })
			// .done(function(data) {
			// 	if( Object.keys(data.errors).length ){
			// 		addFormErrors($wrapper, data.errors);

			// 	} else {
			// 		$error.hide();
			// 		$parent.find(".popup__title").text("Спасибо за заказ!");
			// 		$wrapper.find(".order__container").hide();
			// 		$wrapper.find(".order__ok").show();
			// 		new_height = $wrapper.height();
			// 		$wrapper.height(old_height).animate({height: new_height});

			// 		$("#popup-order .popup-close").unbind('click');

			// 		window.yaParams = {
			// 		  order_id: data.order_id,
			// 		  order_price: data.price,
			// 		  currency: "RUR",
			// 		  exchange_rate: 1,
			// 		  goods: []
			// 		};
			// 		for(var i = 0; i < data.goods.length; i++){
			// 			yaParams.goods.push({
			// 				id: data.goods[i].id_item,
			// 				name: data.goods[i].name,
			// 				price: data.goods[i].price,
			// 				quantity: data.goods[i].count,
			// 			});
			// 		}

			// 		//console.log( yaParams );
			// 		//yaCounter21680044.reachGoal('BUY', window.yaParams||{ });

			// 		$("body").on("click", ".popup-close", function(){
			// 			togglePopup($(this).closest(".popup").attr("id"));
			// 			window.location.href='/';
			// 			return false;
			// 		});
			// 	}
			// })
			// .fail(function() {
			// 	$error.html(buildServerErrorsString( {misc: 'Системная ошибка, повторите попытку позже'} ));
			// });

			// if error
//			$error.html("Текст ошибки").show();
//			new_height = $wrapper.height();
//			$wrapper.height(old_height).animate({height: new_height});
	// 	});

	// 	e.preventDefault();
	// });

	if ($.amountControl && $(".korzina__list").length) {
		$(".korzina__list").amountControl({
			wrapper:                 '.korzina__list',
			child:                   '.korzina__entry',
			control:                 '.entry__amount-container .amount__control',

			unitname:                'товар',

			unit_state_container:    '.entry__total-container',
			unit_amount:             '.entry__total-container .total__amount',
			unit_total:              '.entry__total-container .total__price',
			unit_total_postfix:      '',

			all_total:               '.zakaz__total',
			all_total_amount:        '.zakaz__total .total__items123',
			all_total_entries:       '.zakaz__total .total__items',
			all_total_price:         '.zakaz__total .total__price',
			all_total_middle:        '.zakaz__total .total__middle',
			all_total_price_postfix: '',

			callback_total_update:   function(data){
				// topBasketUpdate({
				// 	total: data.entries,
				// 	middle: data.middle,
				// 	price: data.price,

				// 	animationSpeed: 500
				// });
			},
			callback_before_update:  function(){
				clearTimeout(window._updateBasketInterval);
			},
			callback_after_update:  function(data){
				if (!data.entries) {
					$(".korzina__empty").fadeIn();
					$(".korzina__form").hide();
				} else {
					$(".korzina__empty").hide();
					$(".korzina__form").show();
				}


				window._updateBasketInterval = setTimeout(function(){
					var items = [];
					$(".korzina__entry input").each(function(){
						items.push({
							id : $(this).data('item-id'),
							count : $(this).val(),
							color : $(this).data('color-id'),
						});
					});

					addItem({
						delFlag: 0,
						items: items,
						onSuccess: function(){
							GG.notify_warning("Изменения успешно внесены в корзину");
						}
					});
				}, 1000);
			}
		});
	}

	// korzina delete row
	$("body").on("click", ".korzina .korzina__entry .button_del", function(){
		var $entry   = $(this).closest(".korzina__entry"),
			$loading = $entry.find(".entry__loading");
			itemId 	 = $(this).data('item-id');

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
	$("body").on("click", ".korzina .korzina__clear", function(){
		$(".korzina .korzina__entry .button_del").click();
	});

});