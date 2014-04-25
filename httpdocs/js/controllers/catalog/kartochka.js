$(function(){

	if ($.amountControl && $(".kartochka").length) {
		updateAmountControl();
	}

});

function updateAmountControl(){
	$(".kartochka").amountControl({
		wrapper:                 '.kartochka',
		child:                   '.kartochka__right',
		control:                 '.amount__wrapper .amount__control',

		unitname:                'товар',

		unit_state_container:    '.entry__total-container',
		unit_amount:             '.entry__total-container .total__amount',
		unit_total:              '.entry__total-container .total__price',
		unit_total_postfix:      'руб.',

		all_total:               '.kartochka__total',
		all_total_amount:        '.kartochka__total .total__amount',
		all_total_price:         '.kartochka__total .total__price',
		all_total_middle:        '.kartochka__total .total__middle',
		all_total_price_postfix: '',

		callback_total_update:   function(data){
			topBasketUpdate({
				total: data.entries,
				middle: data.middle,
				price: data.price,

				animationSpeed: 500
			});
		},
		callback_before_update:  function(data){},
		callback_after_update:  function(data){}
	});
}