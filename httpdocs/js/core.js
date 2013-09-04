$(document).ready(function(){

    // popup settings
    $("html").data("width", $("html").width());

    $("body").on("click", ".popup-close", function(){
        togglePopup($(this).closest(".popup").attr("id"));
        return false;
    });

    $(document).keyup(function(e) {
        if (e.keyCode == 27) {
            togglePopup($(".popup:visible").attr("id"));
        }
    });
    //

    // callback
//    togglePopup('popup-callback');
    //

    // disable link if its state is 'current'
    // auto toggle 'current'
    // data-noautocurrent="true" on link to disable auto 'current' toggle
    $("body").on("click", "a", function(e){
        var $parent = $(this).parent(),
            regexp  = new RegExp( "^(.+)_current$", "i");

        // check if parent is only one of class
        var parentBlockClass = $parent[0].className.split(/\s+/), parentBlockClass = parentBlockClass[0],
            thisBlockClass   = $(this)[0].className.split(/\s+/), thisBlockClass   = thisBlockClass[0],
            flagNotSingle    = true;

        if (!parentBlockClass.length || ($("."+parentBlockClass+":visible").length == 1 && $("."+thisBlockClass+":visible").length == 1)) {
            flagNotSingle = false;
        }
        //

        // check if parent is '.content'
        var flagNotContent = true;
        if ($(this).closest(".content").length > 0) {
            //flagNotContent = false;
            //console.log("Link is in 'content', auto 'current' toggle off");
        }

        // check if one of parents are '.noautocurrent'
        var flagNoAutoCurrent = false;
        if ($(this).closest(".noautocurrent").length > 0) {
            flagNoAutoCurrent = true;
            console.log("Autocurrent is toggled off for this container");
        }

        if (regexp.test($(this)[0].className) || (regexp.test($parent[0].className) && flagNotSingle)) {
            console.log("Link state is 'current', aborting");
            return false;
        }

        // auto "current" toggle
        // current element have data-current="true"
        if (!$(this).data("noautocurrent") && flagNotSingle && flagNotContent && !flagNoAutoCurrent) {
            // parent loop (toggle currents for parent)
            var parentClasses  = $parent[0].className.split(/\s+/),
                parentCurrents = [];

            if ($("."+parentBlockClass+":visible").length > 1) { // only if parent are not only one
                for (var i = 0, k = parentClasses.length; i < 1; i++) {
                    $("."+parentClasses[i]+"_current").removeClass(parentClasses[i]+"_current").data("current", false);
                    parentCurrents.push(parentClasses[i]+"_current");
                }

                for (var i = 0, k = parentCurrents.length; i < k; i++) {
                    $parent.addClass(parentCurrents[i]).data("current", true);
                }
            }

            // child loop (toggle currents for child)
            var childClasses  = $(this)[0].className.split(/\s+/),
                childCurrents = [];

            for (var i = 0, k = childClasses.length; i < 1; i++) {
                $("."+childClasses[i]+"_current").removeClass(childClasses[i]+"_current").data("current", false);
                childCurrents.push(childClasses[i]+"_current");
            }

            for (var i = 0, k = childCurrents.length; i < k; i++) {
                $(this).addClass(childCurrents[i]).data("current", true);
            }
        }
        //

        // prevent default if href is # or empty
        var href = $(this).attr("href");
        if (href == '#' || href == '') {
            e.preventDefault();
        }
        //
    });
    //

    // catalog slider prev/next
    $("body").on("click", ".slider__controls", function(){
        var $slider      = $(".catalog .catalog__slider"),
            $container   = $(".catalog .catalog__slider .slider__container"),
            entryWidth   = $container.find(".slider__entry").outerWidth(),
            offsetLeft   = parseInt($container.css("left"), 10) || 0,
            totalEntries = $container.find(".slider__entry").length,
            inView       = parseInt(parseInt($(".catalog .catalog__slider .slider__wrapper").width(), 10)/entryWidth),
            direction    = $(this).is(".slider__controls_prev") ? -1 : 1;

        if ($slider.data("sliding") || (direction < 0 && offsetLeft >= 0) || (direction > 0 && offsetLeft <= -(totalEntries-inView)*entryWidth)) {
            return false;
        }

        $slider.data("sliding", true);

        $container.animate({"left": offsetLeft - (direction*entryWidth)}, function(){
            offsetLeft = parseInt($container.css("left"), 10);

            if (offsetLeft == 0 || offsetLeft == -(totalEntries-inView)*entryWidth) {
                if (direction < 0) {
                    $slider.find(".slider__controls_prev").addClass("slider__controls_disabled");
                } else if (direction > 0) {
                    $slider.find(".slider__controls_next").addClass("slider__controls_disabled");
                }
            } else {
                $slider.find(".slider__controls_prev").removeClass("slider__controls_disabled");
                $slider.find(".slider__controls_next").removeClass("slider__controls_disabled");
            }

            $slider.data("sliding", false);
        });

        return false;
    })
    //

    // order form
    $("body").on("click", ".preorder__retail-container .retail__group", function(){
        $(".preorder__retail-container").animate({"margin-top": -1*parseInt($(".preorder__retail-container").height(), 10)});
        return false;
    });

    $("body").on("click", ".preorder__wholesale-container .wholesale__back", function(){
        $(".preorder__retail-container").animate({"margin-top": 0});
        return false;
    });

    $("body").on("click", ".preorder__retail-container .retail__buy", function(){
        $(".order__container").animate({"margin-left": -$(".catalog__order").outerWidth()});
        return false;
    });

    $("body").on("click", ".preorder__wholesale-container .wholesale__buy", function(){
        $(".order__container").animate({"margin-left": -$(".catalog__order").outerWidth()});
        return false;
    });

    $("body").on("click", ".order__form .form__back", function(){
        $(".order__container").animate({"margin-left": 0});
        return false;
    });

    if ($(".field__input_phone").length) $(".field__input_phone").mask('+7 (000) 000-00-00');

    $("body").on("click", ".order__form .form__buy", function(){
        var errors = false;

        $(".form__container .form__field_required").each(function(){
            var value = $(this).find(".field__input").val();
            if (!value) {
                $(this).find(".field__input").addClass("field__input_error");
                $(this).find(".field__title ins").show();
                errors = true;
            }
        });

        if (!errors) {

            $(".order__container").animate({"margin-left": -2*$(".catalog__order").outerWidth()});

        }

        return false;
    });

    $("body").on("keyup", ".form__container .form__field_required input", function(){
        $(this).removeClass("field__input_error");
        $(this).closest(".form__field_required").find(".field__title ins").hide();
    });

    $("body").on("click", ".catalog__order .order__result .result__back" ,function(){
        $(".order__container").animate({"margin-left": -$(".catalog__order").outerWidth()});
        return false;
    });
    //

    // mainpage gallery
    if ($.galleryCarousel) $(".banners__block").galleryCarousel({dots: true, autostop: true, fade: 1000, interval: 5000});
    //

    // gallery prettyPhoto
    if ($.prettyPhoto) $(".gallery-list__entry a[rel^='prettyPhoto']").prettyPhoto({social_tools: ''});

    updateAmountControl();

});

function togglePopup(id) {
    if (typeof id == 'undefined') {
        togglePopup($(".popup:visible").attr("id"));
        return false;
    }

    if ($("#"+id).is(":visible")) {
        $("html").css("overflow", "auto");
        $(".wrapper").css("padding-right", 0);
        $("#"+id).hide();
    } else {
        $("html").css("overflow", "hidden");
        $(".wrapper").css("padding-right", $("html").width() - $("html").data("width"));
        $("#"+id).show();
    }

    return false;
}

function updateAmountControl() {
    $(".amount").each(function(){
        $(this).find("ins").remove().end().append('<ins class="plus">+</ins>').append('<ins class="minus">–</ins>');
    });

    $(".amount ins").click(function(){
        var $holder = $(this).parent(),
            $parents= $holder.data("parent"),
            $parent = $holder.closest($holder.data("parent")),
            result  = $holder.data("result"),
            overall = $holder.data("overall"),
            $input  = $holder.find("input"),
            amount  = parseInt($input.val(), 10),
            total   = 0;

        var newamount = $(this).is(".plus") ? amount+1 : amount-1;

        if (newamount < 0) return false;

        $input.val(newamount);

        //if ($(result, $parent).length) {
        $(result, $parent).html(formatNumberWithSpaces(newamount*$(result, $parent).data("price"))+$(result, $parent).data("postfix"));
        $(result, $parent).data("value", newamount*$(result, $parent).data("price"));
        //}

        //if ($(overall).length) {
        $($parents).each(function(i){
            var $result = $(this).find(result);
            log($result.data("value"));
            total += $result.data("value");
        });
        $(overall).html(formatNumberWithSpaces(total)+$(overall).data("postfix"));
        //}

//        var price = parseInt($(this).closest(".korzina-entry").find(".c4").data("price"), 10);
//            price = price ? price : parseInt($(this).closest(".kartochka-summary").find(".itogo").data("price"), 10);
//
//        var input = $(this).closest("div").find("input");
//        var amount = parseInt(input.val());
//        if (!amount) amount = 0;
//        var newamount = $(this).is(".plus") ? amount+1 : amount-1;
//        if (newamount < 0) return false;
//        $(this).parent("div").find("input").val(newamount);
//
//        var totalPriceLabel = $(this).closest(".korzina-entry").find(".c4 p");
//            totalPriceLabel = totalPriceLabel.length > 0 ? totalPriceLabel : $(this).closest(".kartochka-summary").find(".itogo");
//        if (newamount > 0) {
//            if ($(this).closest(".kartochka-summary").find(".itogo").length > 0) {
//                totalPriceLabel.html("Итого: <span>"+price+" x "+newamount+" = "+price*newamount+" руб.</span>");
//            } else {
//                totalPriceLabel.html(price+" x "+newamount+" = "+price*newamount+" руб.");
//            }
//        } else {
//            totalPriceLabel.html("выберите количество");
//        }
    });
}

function formatNumberWithSpaces(num) {
    if (!num) return 0;
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
}

function mphone(v) {
    var r = v.replace(/\D/g,"");
    r = r.replace(/^0/,"");
    if (r.length > 10) {
        // 11+ digits. Format as 5+4.
        r = r.replace(/^(\d\d)(\d{5})(\d{4}).*/,"(0XX$1) $2-$3");
    }
    else if (r.length > 5) {
        // 6..10 digits. Format as 4+4
        r = r.replace(/^(\d\d)(\d{4})(\d{0,4}).*/,"(0XX$1) $2-$3");
    }
    else if (r.length > 2) {
        // 3..5 digits. Add (0XX..)
        r = r.replace(/^(\d\d)(\d{0,5})/,"(0XX$1) $2");
    }
    else {
        // 0..2 digits. Just add (0XX
        r = r.replace(/^(\d*)/, "(0XX$1");
    }
    return r;
}

var log = function(msg){
    console.log(msg);
};

var myMap,
    myPlacemark;

function YMapsInit(args){
    myMap = new ymaps.Map ( "Gmap", {
        center: [args.lat, args.lng],
        zoom: 14
    });

    myPlacemark = new ymaps.Placemark([args.lat, args.lng], {
        hintContent: args.hintContent
    });

    myMap.geoObjects.add(myPlacemark);
}
//

