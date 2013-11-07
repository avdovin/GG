$(function(){
	// устанавливаем бренд из сессии
	if( $(".manufacturer__list .current").length ){
		$catalogFilters.find('.filters__manufacturer_selected .manufacturer__dialog').text( $(".manufacturer__list .current").text() );
		$catalogFilters.find('.filters__manufacturer_selected .filters__reset').show();
	}

	$("body").on('click', '.sizes__list a', function(){
		$(".iteminfo-basket-block").show();

		return false;
	});

	$(".filters__reset").click(function(){
		$(this).closest('.measurement__block').find('.block__slider').slider("option", "values", [0, 9999999]);
	})

	$catalogItemsInner.on('click', '.list__entry a',function(){
		togglePopup("popup-kartochka");
		get_iteminfo( $(this).closest('.list__entry').attr('data-item-id') );

		return false;
	});

	$(".catalog__sorting a").click(function(){
		$(this).toggleClass('desc');

		get_items({page: 1});
	});

	$catalogFilters.find('.filters__actions a').click(function(){
		get_items({page: 1});
	})

	$catalogFilters.find('.season__list a').click(function(){
		get_items({page: 1});
	})

	$(".manufacturer__list a").click(function(){
		$(".manufacturer__list a").removeClass('current');
		$catalogFilters.find('.filters__manufacturer_selected .manufacturer__dialog').text( $(this).addClass('current').text() );

		$catalogFilters.find('.filters__manufacturer_selected .filters__reset').fadeIn();

		togglePopup("popup-manufacturer");

		get_items({page: 1});
	})

	$catalogFilters.find('.filters__manufacturer_selected .filters__reset').click(function(){
		$(".manufacturer__list a").removeClass('current');
		$catalogFilters.find('.filters__manufacturer_selected .manufacturer__dialog').text('Все производители');
		$(this).fadeOut();

		get_items({page: 1});
	})

});

function init_price_slider(params) {

	if (jQuery.fn.slider && params.slider.length > 0) {

		params.input.from.val(params.values[0]);
		params.input.to.val(params.values[1]);

		params.label.from.html(params.min+" "+params.postfix);
		params.label.mid.html(parseInt((params.min+params.max)/2)+" "+params.postfix);
		params.label.to.html(params.max+" "+params.postfix);

		var $slider = params.slider;

		$slider.slider({
			range: true,
			min: params.min,
			max: params.max,
			values: params.values,
			create: function(event,ui){
				var $from = params.input.from,
					$to   = params.input.to;

				$slider.slider("option", "values", [parseInt($from.val()),parseInt($to.val())]);
			},
			slide: function(event,ui){
				var $from = params.input.from,
					$to   = params.input.to;

				$from.val(ui.values[ 0 ]);
				$to.val(ui.values[ 1 ]);
			},
			change: function (event,ui){
				var $from = params.input.from,
					$to   = params.input.to;

				setTimeout(function(){
					$from.val(ui.values[ 0 ]);
				}, 1);

				setTimeout(function(){
					$to.val(ui.values[ 1 ]);
				}, 1);
			}
		});

		params.input.from.keyup(function(e){
			var amount    = $(this).val() || 0
			newamount = '';

			if (e.which != 13) {
				if (amount) newamount = amount.replace(/\D/g,"") || 0;
				$(this).val(newamount || '');
			}
		}).keypress(function(e){
			var amount = $(this).val(),
				to     = parseInt(params.input.to.val());

			if (e.which == 13) {
				if (amount > to) {
					var i = amount;
					amount = to;
					to = i;
				}
				$slider.slider("option", "values", [amount,to]);
			}
		});

		params.input.to.keyup(function(e){
			var amount    = $(this).val() || 0,
				newamount = '';

			if (e.which != 13) {
				if (amount) newamount = amount.replace(/\D/g,"") || 0;
				$(this).val(newamount || '');
			}
		}).keypress(function(e){
			var amount = $(this).val(),
				from     = parseInt(params.input.from.val());

			if (e.which == 13) {
				if (amount < from) {
					var i = amount;
					amount = from;
					from = i;
				}
				$slider.slider("option", "values", [from,amount]);
			}
		});
	}
}

function init_size_slider(params) {

	if (jQuery.fn.slider && params.slider.length > 0) {
		var $slider = params.slider,
			$labels = params.labels,
			sizes   = params.sizes;

		// set sizes to inputs
		params.input.from.val(params.sizes[params.values[0]]);
		params.input.to.val(params.sizes[params.values[1]]);

		// create sizes labels
		$labels.find("tr").html(''), $labels = $labels.find("tr");

		for (var i = 0, k = sizes.length; i < k; i++) {
			var size = sizes[i];

			if (size < 10) size = "<ins>0</ins>"+size;

			$labels.append("<td>"+size+"</td>");
		}
		//

		$slider.slider({
			range: true,
			min: 0,
			max: sizes.length-1,
			values: params.values,
			create: function(event,ui){
				var $from = params.input.from,
					$to   = params.input.to;

				var from  = sizes.indexOf(parseInt($from.val())),
					to    = sizes.indexOf(parseInt($to.val()));

				setTimeout(function(){
					$slider.slider("option", "values", [from,to]);
				}, 1);
			},
			slide: function(event,ui){
				var $from = params.input.from,
					$to   = params.input.to;

				var from  = sizes[ui.values[ 0 ]],
					to    = sizes[ui.values[ 1 ]];

				$from.val(from);
				$to.val(to);
			},
			change: function (event,ui){
				var $from = params.input.from,
					$to   = params.input.to;

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

		params.input.from.keyup(function(e){
			var amount    = $(this).val() || 0,
				newamount = '';

			if (e.which != 13) {
				if (amount) newamount = amount.replace(/\D/g,"") || 0;
				$(this).val(newamount || '');
			}
		}).keypress(function(e){
			var amount = $(this).val(),
				to     = parseInt(params.input.to.val());

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

				$slider.slider("option", "values", [amount,to]);
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

		params.input.to.keyup(function(e){
			var amount    = $(this).val() || 0,
				newamount = '';

			if (e.which != 13) {
				if (amount) newamount = amount.replace(/\D/g,"") || 0;
				$(this).val(newamount || '');
			}
		}).keypress(function(e){
			var amount = $(this).val(),
				from     = parseInt(params.input.from.val());

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

				$slider.slider("option", "values", [from,amount]);
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
}

