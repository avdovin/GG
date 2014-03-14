// jQuery Amount Control
// Author: Nikita K., nikita.ak.85@gmail.com
// Version: 1.1, 24.09.2013

(function($){

	$.amountControl = {version: '1.1'};

	var methods = {
		init: function(params){

			var defaults = {

			};
			var options = $.extend(defaults, params);

			if (!defaults.child || !defaults.control || !defaults.unitname) throw('Children/controls/units not specified');

			if (!defaults.unit_amount || !defaults.unit_total) {
				throw('Check input values');
			}

			if (!defaults.all_total_amount || !defaults.all_total_price) {
				console.log('Some settings not specified');
			}

			return this.each(function(){

				var $wrapper	= $(this),
					$wrapperid  = $wrapper.attr("id"),
					$entries	= $wrapper.find(options.child),
					$data	   = $wrapper.data('amountControl');

				if (!$wrapperid) { // create random id
					$wrapper.attr("id", "gc" + (new Date()).getTime() + Math.floor(Math.random()*100));
					$wrapperid = $wrapper.attr("id");
				}

				if (!$data) {
					$wrapper.data('amountControl', options).addClass('amountControl');
					$data = options;
				}

				methods.updateAmount.call($wrapper, true);

				$entries.each(function(i){
					methods.setControl.call($wrapper, this);
				})

				$wrapper.data('amountControl', $data);

			});

		},
		setControl: function(){
			var $wrapper   = this,
				$wrapperid = $wrapper.attr("id"),
				$data	  = $wrapper.data('amountControl'),
				$entry	 = arguments[0],
				$input	 = $($entry).find($data.control).find("input");

			// clear
			$($entry).find($data.control).find("ins").remove();

			// create
			$($entry).find($data.control)
				.append('<ins class="plus">+</ins>')
				.append('<ins class="minus">–</ins>');

			var $ins = $($entry).find($data.control).find("ins");

			// disable
			if ($input.val() == $input.data("min")) {
				$ins.filter(".minus").addClass("disabled");
			}
			if ($input.val() == $input.data("max")) {
				$ins.filter(".plus").addClass("disabled");
			}
			if ($input.val() > $input.data("min") && $input.val() < $input.data("max")) {
				$ins.filter(".minus").removeClass("disabled");
				$ins.filter(".plus").removeClass("disabled");
			}

			// events
			$input.keyup(function(){
				var $entry	= $(this).closest($data.child),
					amount	= $(this).val() || 0,
					newamount = 0;

				amount ? newamount = amount.replace(/\D/g,"") : 0;

				methods.setAmount.call($entry, $wrapper, newamount);
			});

			$ins.click(function(){
				var $entry	= $(this).closest($data.child),
					amount	= $(this).parent().find("input").val() || 0,
					newamount = $(this).is(".plus") ? parseInt(amount)+1 : parseInt(amount)-1;

				if (newamount < 0) return false;

				methods.setAmount.call($entry, $wrapper, newamount);
			});
		},
		setAmount: function(){
			var $entry	 = this,
				$entrydata = $entry.data('amountcontrol') || $entry.attr('data-amountcontrol'),
				$wrapper   = arguments[0],
				newamount  = arguments[1],
				$data	  = $wrapper.data('amountControl'),
				$input	 = $entry.find($data.control).find("input"),
				$wrapper   = $entry.closest($data.wrapper); // !!! some magic here

			if (newamount <= $input.data("min")) {
				$entry.find($data.control).find(".minus").addClass("disabled");
			} else if (newamount >= $input.data("max")) {
				$entry.find($data.control).find(".plus").addClass("disabled");
			} else if (newamount > $input.data("min") || newamount < $input.data("max")) {
				$entry.find($data.control).find(".minus").removeClass("disabled");
				$entry.find($data.control).find(".plus").removeClass("disabled");
			}

			if (newamount < $input.data("min") || newamount > $input.data("max")) {
				return false;
			}

			$input.val(newamount);

			$entrydata.amount = newamount;
			$entrydata.total  = $entrydata.amount * $entrydata.price;

			$entry.data('amountcontrol', $entrydata);

			methods.updateAmount.call($wrapper);
		},
		updateAmount: function(){
			var $wrapper	 = this,
				$wrapperid   = $wrapper.attr("id"),
				$data		= $wrapper.data('amountControl'),
				callbackFlag = arguments[0];

			var all_total_amount = 0,
				all_total_price  = 0;

			if (typeof $data.callback_before_update != 'undefined') {
				$data.callback_before_update({
					total: all_total_amount
				});
			}

			$wrapper.find($data.child).each(function(){
				var $entry	 = $(this),
					$entrydata = $(this).data('amountcontrol'),
					$control   = $entry.find($data.control);

				if (typeof $entrydata == 'undefined') throw "No data in child entry: "+(i+1);

				// show/hide
				if (!parseInt($entrydata.amount)) {
					$entry.find($data.unit_state_container).fadeOut();
				} else {
					$entry.find($data.unit_state_container).fadeIn();
				}

				// update input
				$entry.find($data.control).find("input").val($entrydata.amount);

				// update label
				$entry.find($data.unit_amount).html($entrydata.amount);
				$entry.find($data.unit_total).html(formatNumberWithSpaces($entrydata.price*$entrydata.amount));
				if ($data.unit_total_postfix) $entry.find($data.unit_total).html($entry.find($data.unit_total).html()+' '+$data.unit_total_postfix);

				all_total_amount += parseInt($entrydata.amount);
				all_total_price  += $entrydata.amount * $entrydata.price;
			});

			// update overall
			$($data.all_total_amount).html(all_total_amount);
			$($data.all_total_price).html(formatNumberWithSpaces(all_total_price));
			if ($data.all_total_price_postfix) $($data.all_total_price).html($($data.all_total_price).html()+' '+$data.all_total_price_postfix);

			if ($data.unitname) {
				//var lastDigit = Math.floor(all_total_amount / (Math.pow(10, 0)) % 10);

				$($data.all_total_middle).html(methods.sklonyator({amount: all_total_amount, text: $data.unitname}));

				if (all_total_amount == 0) {
					$($data.all_total).fadeOut()
				} else {
					$($data.all_total).fadeIn();
				}

			}

			if (typeof $data.callback_total_update != 'undefined') {
				if (callbackFlag) return false;
				$data.callback_total_update({
					total: all_total_amount,
					price: formatNumberWithSpaces(all_total_price),
					middle: $($data.all_total_middle).html()
				});
			}

			if (typeof $data.callback_after_update != 'undefined') {
				$data.callback_after_update({
					total: all_total_amount,
					entries: $wrapper.find($data.child).length
				});
			}

			function formatNumberWithSpaces(num) {
				if (!num) return 0;
				return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
			}
		},
		sklonyator: function(){
			var $data = arguments[0],
				skloneniya = ['', 'а', 'ов'],
				value = '';

			if (typeof $data == 'undefined' || typeof $data.amount == 'undefined' || typeof $data.text == 'undefined') throw 'No data!';

			var lastDigit = Math.floor($data.amount / (Math.pow(10, 0)) % 10);

			if (lastDigit == 0) {
				value = $data.text+skloneniya[2];
			} else if (lastDigit == 1 && ($data.amount > 20 || $data.amount < 10)) {
				value = $data.text;
			} else if (lastDigit >= 2 && lastDigit <= 4 && ($data.amount > 20 || $data.amount < 10)) {
				value = $data.text+skloneniya[1];
			} else if ($data.amount > 10 && $data.amount <= 20) {
				value = $data.text+skloneniya[2];
			} else {
				value = $data.text+skloneniya[2];
			}

			return value;
		}
	}

	$.fn.amountControl = function( method ) {

		if ( methods[method] ) {
			return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
		} else if ( typeof method === 'object' || ! method ) {
			return methods.init.apply( this, arguments );
		} else {
			$.error( 'Method ' +  method + ' does not exist on jQuery.amountControl' );
		}

	};

})(jQuery);