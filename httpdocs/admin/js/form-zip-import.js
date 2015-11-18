jQuery(document).on('click', '#zipimport_run_btn', function(){
  run_zipimport( $(this) );
  return false;
});

function toogle_zipimport_progress(on_import) {
  if (jQuery("#zipimport_progress").is(':hidden') || typeof(on_import) != 'undefined') {
    jQuery("#zipimport_fields").hide();
    jQuery("#zipimport_progress").show();
    jQuery("#zipimport_progress_change_btn").html('Форма загрузки');
    jQuery("#zipimport_run_btn").hide();
  } else {
    jQuery("#zipimport_fields").show();
    jQuery("#zipimport_progress").hide();
    jQuery("#zipimport_progress_change_btn").html('Статистика загрузки');
    jQuery("#zipimport_run_btn").show();
  }
  return false;
}

window.gg__zip_import_current = 0;
window.gg__zip_import_total = 0;

function run_zipimport( $runBtn ) {

  var loading_text = 'Обработка изображений';
  var loading_node = jQuery("#loading-progress-msg");
  var params = jQuery("#zipimport_form").serialize();
  jQuery("#zipimport_progress_items").html('');
  jQuery("#zipimport_current").html('0');
  jQuery("#zipimport_total").html('0');
  jQuery("#zipimport_run_btn").hide();

  controller_url = $runBtn.data('conroller-url');

  jQuery.ajax({
    url: controller_url+'?do=zipimport_save',
    beforeSend: function() {
      jQuery('#loading-progress').show().removeClass('loaded');
      loading_node.html(loading_text);

      window.gg__zip_import_current = 0;
      window.gg__zip_import_total = 0;

      toogle_zipimport_progress(1);
    },
    success: function(data) {
      window.gg__zip_import_total = data.count;
      jQuery("#zipimport_total").html(data.count);
      jQuery("#zipimport_progress_items").html(data.html);

      run_zipimport_nodes(controller_url);
    },
    error: function(data) {
      alert('Ошибка загрузки арихива, повторите попытку позже ...');
    },
    complete: function() {

    },
    data: params
  });

}

function run_zipimport_nodes(controller_url) {
  jQuery('#zipimport_progress_items div.loading:first').each(function() {
    var _this = this;
    var params = jQuery('#zipimport_form').serialize();
    params += '&filename=' + jQuery(_this).attr('filename')

    jQuery.ajax({
      url: controller_url+'?do=zipimport_save_pict',
      beforeSend: function() {},
      success: function(data) {
        window.gg__zip_import_current++;

        jQuery("#zipimport_current").html(window.gg__zip_import_current);
        jQuery("div.pic", _this).append("<img src='" + data.src + "'/>");
        console.log(window.gg__zip_import_current);
        console.log(window.gg__zip_import_total);
        var procent = Math.ceil(window.gg__zip_import_current / window.gg__zip_import_total * 100);

        jQuery('#loading-progress-percent').html(procent + ' % ');
      },
      error: function(data) {
        jQuery(_this).addClass('zipimport_progress_error')
      },
      complete: function() {
        jQuery(_this).removeClass('loading');

        if (jQuery('#zipimport_progress_items div.loading').length) {
          run_zipimport_nodes(controller_url);
        } else {

          jQuery('#loading-progress').addClass('loaded');
          jQuery('#loading-progress-msg').html('Обработка завершена');
        }
      },
      data: params
    });
  });
}
