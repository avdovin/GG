$("body").on("click", ".recall__form .form__send", function(e){
  var $parent  = $(this).closest(".recall__form"),
    $loading = $parent.find(".form__loading"),
    $wrapper = $parent.find(".form__wrapper"),
    $error   = $parent.find(".form__error");

    $.ajax({
      url: '/recall',
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