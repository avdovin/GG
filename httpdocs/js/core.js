(function(){
  if( document.cookie.indexOf('device_pixel_ratio') == -1
      && 'devicePixelRatio' in window
      && window.devicePixelRatio > 1 ){

    document.cookie = 'device_pixel_ratio=' + window.devicePixelRatio + ';';
    window.location.reload();
  }
})();

(function($) {
    $.jnotify = function(options) {
      if(typeof title == 'undefined') title = 'Товар добавлен в корзину';
        var stackContainer, messageWrap, messageBox, messageBody, messageTextBox, messagePicture, image;

        options = $.extend({
            lifeTime: 4000,
            click:  undefined,
            icon:   undefined,
            action: '',
            text: ''
        }, options);

        var text = options.text;

        // находим контейнер с сообщениями, если его нет, тогда создаём
        stackContainer = $('#notifier-box');
        if (!stackContainer.length) {
            stackContainer = $('<div>', {id: 'notifier-box'}).prependTo(document.body);
        }

        // создаём элементы вертски контейнера сообщения
        messageWrap = $('<div>', {
            'class': 'message-wrap',
            css: {
                display: 'none'
            }
        });

        messageBox = $('<div>', {
            'class': 'message-box'
        });

        messageBody = $('<div>', {
            'class': 'message-body'
        });

        messageTextBox = $('<span>', {
            html: text
        });

    closeButton = $('<a>', {
      'class': 'message-close',
      href: 'javascript:void(0);',
      title: 'Закрыть',
      click: function() {
        $(this).parent().parent().fadeOut(300, function() {
          $(this).remove();
        });
      }
    });

        // теперь расположим все на свои места
        messageWrap.appendTo(stackContainer).fadeIn();
        messageBox.appendTo(messageWrap);
        closeButton.appendTo(messageBox);
        messageBody.appendTo(messageBox);

        messagePicture = $('<div>', {
      'class': 'thumb'
    });
    if(typeof(options.action) != 'undefined'){
      image = $('<img>', {
        src: options.action == 'add' ? '/img/basket_notify.png' : '/img/basket_delete_notify.png'
      });

    } else {
      image = $('<img>', {
        src: '/img/notify_info.png'
      });
    }
    image.appendTo(messagePicture);

        messagePicture.appendTo(messageBody);

        messageTextBox.appendTo(messageBody);

        // если время жизни уведомления больше 0, ставим таймер
        if (options.lifeTime > 0) {
            setTimeout(function() {
                $(messageWrap).fadeOut(300, function() {
                    $(this).remove();
                });
            }, options.lifeTime);
        }

        // если установлен колбек
        if (options.click != undefined) {
            messageWrap.click(function(e) {
                if (!jQuery(e.target).is('.message-close')) {
                    options.click.call(this);
                }
            });
        }

        return this;
    }
})(jQuery);

// возвращает cookie если есть или undefined
function getCookie(name) {
  var matches = document.cookie.match(new RegExp(
     "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
  ))
  return matches ? decodeURIComponent(matches[1]) : undefined
}

// уcтанавливает cookie
function setCookie(name, value, props) {
  props = props || {}
  var exp = props.expires
  if (typeof exp == "number" && exp) {
    var d = new Date()
    d.setTime(d.getTime() + exp*1000)
    exp = props.expires = d
  }
  if(exp && exp.toUTCString) { props.expires = exp.toUTCString() }

  value = encodeURIComponent(value)
  var updatedCookie = name + "=" + value
  for(var propName in props){
    updatedCookie += "; " + propName
    var propValue = props[propName]
    if(propValue !== true){ updatedCookie += "=" + propValue }
  }
  document.cookie = updatedCookie
}

// удаляет cookie
function deleteCookie(name) {
  setCookie(name, null, { expires: -1 })
}

String.prototype.truncate = function(){
  var re = this.match(/^.{0,25}[\S]*/);
  var l = re[0].length;
  var re = re[0].replace(/\s$/,'');
  if(l < this.length)
    re = re + "&hellip;";
  return re;
}