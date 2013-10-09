$("body").on("click", ".contacts__form .form__send", function(e){
  var $parent  = $(this).closest(".contacts__form"),
    $loading = $parent.find(".form__loading"),
    $wrapper = $parent.find(".form__wrapper"),
    $error   = $parent.find(".form__error");

    $.ajax({
      url: '/feedback',
      type: 'post',
      data: $parent.find('form').serialize(),
      beforeSend: function(){
        $loading.fadeIn();
      }
    })
    .done(function (data) {
        if(data.errors){
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

// Yandex Maps
$(function(){

  if (typeof ymaps != 'undefined') {
      ymaps.ready(YMapsInit);
  }

  var myMap,
      myPlacemark;

  function YMapsInit(){
      myMap = new ymaps.Map ("Gmap", {
          center: [59.936026,30.318344],
          zoom: 14
      });

      myMap.controls
          .add('zoomControl')
          .add('typeSelector')
          .add('mapTools');

      myPlacemark = new ymaps.Placemark([59.936026,30.318344], {
          hintContent: 'Невский проспект, 15'
      });

      myMap.geoObjects.add(myPlacemark);
  }

})
//