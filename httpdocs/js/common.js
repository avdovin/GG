// INIT GG
if (typeof GG != 'undefined') {
	GG = new GG();
	GG.init({
		local: true,
		debug: true,        // включить режим debug (вывод через log(), а так же другие возможности)
		setcurrent: true,   // включить автоматическое преобразование .current -> .first__class_current
		autocurrent: true,  // автоматический включатор текущего элемента типа .some_class_current

		// этот callback вызывается каждый раз после загрузки страницы (в т.ч. при переходе с помощью ajax)
		afterLoad: function(){

			// mainpage gallery
			if ($.galleryCarousel) $(".top__banners").galleryCarousel(
				{
					effect: "slide",
					dots: true,
					cb: {
						before: function(){
							$(".top__texts .texts__entry:visible").fadeOut(1000);
						},
						after: function(current, next){
							$(".top__texts .texts__entry_"+next)
								.stop()
								.fadeIn(500)
								.find(".entry__title")
								.css("left", "-100%")
								.animate({left: 0})
								.end()
								.find(".entry__text")
								.css("right", "-100%")
								.animate({right: 0});
						}
					}}
			);
			//if ($.galleryCarousel) $(".top__texts").galleryCarousel({effect: "slide"});
			//

			// gallery prettyPhoto
			if ($.prettyPhoto) $("a[rel^='prettyPhoto']").prettyPhoto({social_tools: ''});

			// phone mask
			if (typeof jQuery.fn.mask != 'undefined' && $(".field__input_phone").length) $(".field__input_phone").mask('+7 (000) 000-00-00');
			//

			// kartochka cloudZoom start
			if (typeof CloudZoom != 'undefined' && $(".cloudzoom").is(":visible")) CloudZoom.quickStart();

			$(".menu .menu__entry").hover(
				function(){
					$(this).addClass("hover");
				},
				function(){
					$(this).removeClass("hover");
				}
			);

		}
	});
}

// custom code
$(function(){



});