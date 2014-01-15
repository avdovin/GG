$(function(){

	// contacts send
	$("body").on("click", ".contacts__form .form__send", function(e){
		var $parent  = $(this).closest(".contacts__form"),
			$loading = $parent.find(".form__loading"),
			$wrapper = $parent.find(".form__wrapper"),
			$error   = $parent.find(".form__error");

		$.ajax({
			url: '/feedback',
			type: 'POST',
			dataType: 'json',
			beforeSend: function(){
				$loading.fadeIn();
			},
			data: $(this).closest('form').serialize(),
		})
		.done(function(data ) {
			if( Object.keys(data.errors).length ){
				addFormErrors($error.closest('form'), data.errors, $error)
			} else {
				$error.hide();
				var old_height = $wrapper.height(),
				new_height = 0;
				$wrapper.html($success.html());
				new_height = $wrapper.height();
				$wrapper.height(old_height).animate({height: new_height});

				$("#popup-register .popup-close").click(function(){
					location.reload();
				})
			}
		})
		.always(function() {
			$loading.fadeOut();
		});
		e.preventDefault();
	});
});