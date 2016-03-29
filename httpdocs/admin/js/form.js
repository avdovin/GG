window.__formsCalendars = [];

function editFormInit(form){
  var $form = jQuery("#" + form);
  forms_set_calendars($form);
}

function modalFormInit(form){
  var $form = jQuery('.DHTMLSuite_modalDialog_contentDiv');
  forms_set_calendars($form)
}

function forms_set_calendars($form){
  $form.find('a.calendar').each(function(){
    var _this = $(this);
    var inputId = _this.data('input-id');

    if(typeof window.__formsCalendars[ inputId ] == 'object' ){
      window.__formsCalendars[ inputId ].destroy();
    }
    if(_this.hasClass('calendar-date')){
      var picker = new Pikaday({
        field: document.getElementById( inputId ),
        trigger: document.getElementById( _this.attr('id') ),
        format: 'YYYY-MM-DD',
        showTime: false,
        use24hour: true,
        bound: true,
        i18n: {
          previousMonth : 'Предыдущий месяц',
          nextMonth     : 'Следующий месяц',
          months        : ['Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
          weekdays      : ['Воскресенье','Понедельник','Вторник','Среда','Четверг','Пятница','Суббота'],
          weekdaysShort : ['Вс','Пн','Вт','Ср','Чт','Пт','Сб']
        }
       });
      window.__formsCalendars[ inputId ] = picker;
    }
    else if(_this.hasClass('calendar-datetime')){
      var picker = new Pikaday({
        field: document.getElementById( inputId ),
        trigger: document.getElementById( _this.attr('id') ),
        format: 'YYYY-MM-DD HH:mm',
        showTime: true,
        use24hour: true,
        bound: true,
        i18n: {
          previousMonth : 'Предыдущий месяц',
          nextMonth     : 'Следующий месяц',
          months        : ['Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
          weekdays      : ['Воскресенье','Понедельник','Вторник','Среда','Четверг','Пятница','Суббота'],
          weekdaysShort : ['Вс','Пн','Вт','Ср','Чт','Пт','Сб']
        },
      });
      window.__formsCalendars[ inputId ] = picker;
    }
  });

  //set_humanize_datetime();
}
