$(function(){

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
			$error.hide();
			$parent.find(".popup__title").text("Спасибо за заказ!");
			$wrapper.find(".order__container").hide();
			$wrapper.find(".order__ok").show();
			new_height = $wrapper.height();
			$wrapper.height(old_height).animate({height: new_height});

			// if error
//			$error.html("Текст ошибки").show();
//			new_height = $wrapper.height();
//			$wrapper.height(old_height).animate({height: new_height});
		});

		e.preventDefault();
	});

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
				topBasketUpdate({
					total: data.entries,
					middle: data.middle,
					price: data.price,

					animationSpeed: 500
				});
			},
			callback_before_update:  function(){},
			callback_after_update:  function(data){
				if (!data.entries) {
					$(".korzina__empty").fadeIn();
					$(".korzina__form").hide();
				} else {
					$(".korzina__empty").hide();
					$(".korzina__form").show();
				}
			}
		});
	}

	// korzina delete row
	$("body").on("click", ".korzina .korzina__entry .button_del", function(){
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

			// some ajax
			// if ok
			fadeOut();
			deleteRow();

		});

	});

	// korzina clear
	$("body").on("click", ".korzina .korzina__clear", function(){
		$(".korzina .korzina__entry .button_del").click();
	});

});
