// Krasarf

$(function(){



		// mainpage gallery
		if ($.galleryCarousel) $(".banners__block").galleryCarousel({effect: 'slide', autostart: false, dots: true, autostop: true, throughdots: true});
		//

		// gallery prettyPhoto
		if ($.prettyPhoto) $(".gallery-list__entry a[rel^='prettyPhoto']").prettyPhoto({social_tools: ''});

		// red first word
		$(".showcase__title, .content h1, .content h2, .content h3, .popup .popup__title, .contacts__title, .recall__form .form__title, table caption").each(function(){
				var words = $(this).html().split(" ");
				if (words.length > 0 && words[0].length > 3) {
						words[0] = '<span class="red">'+words[0]+'</span>';
				}
				$(this).html(words.join(" "));
		});

		// menu pay order form
		$("body").on("click", ".menu__order .order__pay", function(){
				$(".order__form").fadeIn();
		});

		$("body").on("click", ".order__form .form__close", function(){
				$(".order__form").fadeOut();
		});

		if ($(".order__form .form__input").length) $(".order__form .form__input").mask('000-000000');
		//

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
						$error.hide();
						$parent.find(".popup__title").text("Спасибо!");
						$wrapper.find(".order__container").hide();
						$wrapper.find(".order__ok").show();
						new_height = $wrapper.height();
						$wrapper.height(old_height).animate({height: new_height});

						// if error
//            $error.html("Какая-то ошибка.").show();
//            new_height = $wrapper.height();
//            $wrapper.height(old_height).animate({height: new_height});
				});

				e.preventDefault();
		});

		// callback send
		$("body").on("click", "#popup-callback .callback__submit", function(e){
		  var $parent  = $(this).closest(".popup"),
		    $loading = $parent.find(".popup__loading"),
		    $wrapper = $parent.find(".callback__wrapper"),
		    $error   = $parent.find(".form__error");

		    $.ajax({
		      url: '/callback',
		      type: 'post',
		      data: $parent.find('form').serialize(),
		      beforeSend: function(){
		        $loading.fadeIn();
		      }
		    })
		    .done(function (data) {
		        if( Object.keys(data.errors).length ){
		          $error.html( buildServerErrorsString(data.errors) ).show();
		        } else {
		          $error.hide();

		        var old_height = $wrapper.height(),
		            new_height = 0;

		          $wrapper.html(data.message_success);
		          new_height = $wrapper.height();
		          $wrapper.height(old_height).animate({height: new_height});
		        }
		    })
		    .always(function(){
		        $loading.fadeOut();
		    });

		    e.preventDefault();
		});

		// catalog price slider
		if (jQuery.fn.slider && $(".measurement__block_price .block__slider").length > 0) {
				var $slider = $(".measurement__block_price .block__slider");

				$slider.slider({
						range: true,
						min: 0,
						max: 6000,
						values: [1000,5000],
						create: function(event,ui){
								var $from = $(".measurement__block_price .block__inputs input[name=price_from]"),
										$to   = $(".measurement__block_price .block__inputs input[name=price_to]");

								$(".measurement__block_price .block__slider").slider("option", "values", [parseInt($from.val()),parseInt($to.val())]);
						},
						slide: function(event,ui){
								var $from = $(".measurement__block_price .block__inputs input[name=price_from]"),
										$to   = $(".measurement__block_price .block__inputs input[name=price_to]");

								$from.val(ui.values[ 0 ]);
								$to.val(ui.values[ 1 ]);
						},
						change: function (event,ui){
								var $from = $(".measurement__block_price .block__inputs input[name=price_from]"),
										$to   = $(".measurement__block_price .block__inputs input[name=price_to]");

								setTimeout(function(){
										$from.val(ui.values[ 0 ]);
								}, 1);

								setTimeout(function(){
										$to.val(ui.values[ 1 ]);
								}, 1);
						}
				});

				$(".measurement__block_price .block__inputs input[name=price_from]").keyup(function(e){
						var amount    = $(this).val() || 0
								newamount = '';

						if (e.which != 13) {
								if (amount) newamount = amount.replace(/\D/g,"") || 0;
								$(this).val(newamount || '');
						}
				}).keypress(function(e){
						var amount = $(this).val(),
								to     = parseInt($(".measurement__block_price .block__inputs input[name=price_to]").val());

						if (e.which == 13) {
								if (amount > to) {
										var i = amount;
										amount = to;
										to = i;
								}
								$(".measurement__block_price .block__slider").slider("option", "values", [amount,to]);
						}
				});

				$(".measurement__block_price .block__inputs input[name=price_to]").keyup(function(e){
						var amount    = $(this).val() || 0,
								newamount = '';

						if (e.which != 13) {
								if (amount) newamount = amount.replace(/\D/g,"") || 0;
								$(this).val(newamount || '');
						}
				}).keypress(function(e){
						var amount = $(this).val(),
								from     = parseInt($(".measurement__block_price .block__inputs input[name=price_from]").val());

						if (e.which == 13) {
								if (amount < from) {
										var i = amount;
										amount = from;
										from = i;
								}
								$(".measurement__block_price .block__slider").slider("option", "values", [from,amount]);
						}
				});
		};
		//


		// catalog size slider
		if (jQuery.fn.slider && $(".measurement__block_size .block__slider").length > 0) {
				var $slider = $(".measurement__block_size .block__slider"),
						$labels = $(".measurement__block_size .block__slider-labels"),
						sizes   = $slider.data("sizes");

				// create sizes labels
				$labels.find("tr").html(''), $labels = $labels.find("tr");

				for (var i = 0, k = sizes.length; i < k; i++) {
						var size = sizes[i];

						if (size < 10) size = "<ins>0</ins>"+size;

						$labels.append("<td>"+size+"</td>");
				}
				//

				$(".measurement__block_size .block__slider").slider({
						range: true,
						min: 0,
						max: sizes.length-1,
						values: [6,14],
						create: function(event,ui){
								var $from = $(".measurement__block_size .block__inputs input[name=size_from]"),
										$to   = $(".measurement__block_size .block__inputs input[name=size_to]");

								var from  = sizes.indexOf(parseInt($from.val())),
										to    = sizes.indexOf(parseInt($to.val()));

								setTimeout(function(){
										$(".measurement__block_size .block__slider").slider("option", "values", [from,to]);
								}, 1);
						},
						slide: function(event,ui){
								var $from = $(".measurement__block_size .block__inputs input[name=size_from]"),
										$to   = $(".measurement__block_size .block__inputs input[name=size_to]");

								var from  = sizes[ui.values[ 0 ]],
										to    = sizes[ui.values[ 1 ]];

								$from.val(from);
								$to.val(to);
						},
						change: function (event,ui){
								var $from = $(".measurement__block_size .block__inputs input[name=size_from]"),
										$to   = $(".measurement__block_size .block__inputs input[name=size_to]");

								var from  = sizes[ui.values[ 0 ]],
										to    = sizes[ui.values[ 1 ]];

								setTimeout(function(){
										$from.val(from);
								}, 1);

								setTimeout(function(){
										$to.val(to);
								}, 1);
						}
				});

				$(".measurement__block_size .block__inputs input[name=size_from]").keyup(function(e){
						var amount    = $(this).val() || 0,
								newamount = '';

						if (e.which != 13) {
								if (amount) newamount = amount.replace(/\D/g,"") || 0;
								$(this).val(newamount || '');
						}
				}).keypress(function(e){
						var amount = $(this).val(),
								to     = parseInt($(".measurement__block_size .block__inputs input[name=size_to]").val());

						if (e.which == 13) {
								if (amount > to) {
										var i = amount;
										amount = to;
										to = i;
								}

								if (sizes.indexOf(parseInt(amount) == -1)) {
										amount = getClosestValues(sizes,amount)[0];
								}

								amount = sizes.indexOf(parseInt(amount)),
										to = sizes.indexOf(parseInt(to));

								$(".measurement__block_size .block__slider").slider("option", "values", [amount,to]);
						}

						function getClosestValues(a, x) {
								var lo, hi;
								for (var i = a.length; i--;) {
										if (a[i] <= x && (lo === undefined || lo < a[i])) lo = a[i];
										if (a[i] >= x && (hi === undefined || hi > a[i])) hi = a[i];
								};
								return [lo, hi];
						}
				});

				$(".measurement__block_size .block__inputs input[name=size_to]").keyup(function(e){
						var amount    = $(this).val() || 0,
								newamount = '';

						if (e.which != 13) {
								if (amount) newamount = amount.replace(/\D/g,"") || 0;
								$(this).val(newamount || '');
						}
				}).keypress(function(e){
						var amount = $(this).val(),
								from     = parseInt($(".measurement__block_size .block__inputs input[name=size_from]").val());

						if (e.which == 13) {
								if (amount < from) {
										var i = amount;
										amount = from;
										from = i;
								}

								if (sizes.indexOf(parseInt(amount) == -1)) {
										amount = getClosestValues(sizes,amount)[1];
								}

								amount = sizes.indexOf(parseInt(amount)),
									from = sizes.indexOf(parseInt(from));

								$(".measurement__block_size .block__slider").slider("option", "values", [from,amount]);
						}

						function getClosestValues(a, x) {
								var lo, hi;
								for (var i = a.length; i--;) {
										if (a[i] <= x && (lo === undefined || lo < a[i])) lo = a[i];
										if (a[i] >= x && (hi === undefined || hi > a[i])) hi = a[i];
								};
								return [lo, hi];
						}
				});
		};
		//

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
						callback_after_update:  function(){}
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
		//

		// korzina delete row
		$("body").on("click", ".korzina .korzina__entry .filters__reset", function(){
				$(this).closest(".korzina__entry").animate(
						{height: 0, opacity: 0, margin: 0, padding: 0, left: -1000},
						function(){
								$(this).remove();
								$(".korzina .korzina__list").amountControl('updateAmount');
						}
				);
		});

		// korzina clear
		$("body").on("click", ".korzina .korzina__clear", function(){
				$("html, body").animate({scrollTop: 0});
//        $(".korzina .korzina__list .korzina__entry").animate({height: 0, opacity: 0}, 1000, function(){
//            $(this).remove();
//        });
				$(".korzina .korzina__list .korzina__entry").remove();

//        setTimeout(function(){$(".korzina .korzina__list").amountControl('updateAmount')}, 1000);
				$(".korzina .korzina__list").amountControl('updateAmount');
		});


		// only numbers
//    $(".filters__measurement .block__inputs input").keyup(function(){
//        var amount    = $(this).val() || 0,
//            newamount = '';
//
//        if (amount) newamount = amount.replace(/\D/g,"");
//
//        $(this).val(newamount || amount || '');
//    });

		// url parser
		$("body").on("click", "a", function(e){
				var href = $(this).attr("href");
				switch (href) {
						case '/form/callback':
								togglePopup("popup-callback");
								e.preventDefault();
								break;
						case '/form/manufacturer':
								togglePopup("popup-manufacturer");
								e.preventDefault();
								break;
				}
		});

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