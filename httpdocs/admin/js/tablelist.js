function selectAllcheckbox() { // выделение/снятие выделения в таблице все элементы
  var elem = document.getElementsByTagName("input");
  for(var i = 0; i < elem.length; i++) {
    class_name = document.getElementsByTagName("input")[i].className;
    class_id   = class_name.split(' ');
    if ((class_id[0] == "listchb")) {
      document.getElementsByTagName("input")[i].checked = document.getElementById("listallchb").checked;
      markup_tr(class_id[1], class_id[2]);
    }
  }
}

function sendAllchecked(divId, url, flag) { // удаление всех отмеченных элементов списка
  var elem = document.getElementsByTagName("input");
  var listindex = "";
  for(var i = 0; i < elem.length; i++) {
    class_name = document.getElementsByTagName("input")[i].className;
    class_id   = class_name.split(' ');
    if ((class_id[0] == "listchb") && document.getElementsByTagName("input")[i].checked) {
      listindex += "," + class_id[1];
    }
  }
  url += "&listindex=" + listindex;
  if (flag == 'delete' && confirm('Удалить отмеченные записи?')) ld_content(divId, url, 0);
  else { if (flag != 'delete') ld_content(divId, url, 0); }
}

function clear_list_filter(url, replaceme, params){
  var out = url + '_list_filter';
  ajaxform[out] = new sack();
  ajaxform[out].requestFile = url;
  ajaxform[out].method = "POST";
  ajaxform[out].setVar("do", "filter_clear");

  for(var field in params){
    ajaxform[out].setVar(field , params[field]);
  }
  ajaxform[out].setVar("replaceme", replaceme);

  ajaxform[out].onCompletion = function() {
    var qs = '';
    for(var field in params){
      qs = '&'+field+'='+params[field];
    }

    ld_content(replaceme, url+'?do=list_container&replaceme='+replaceme+qs, '', 1)
  }
  ajaxform[out].runAJAX();
}

function set_list_filter(url, replaceme, params){
  var out = url + '_list_filter';
  ajaxform[out] = new sack();
  ajaxform[out].requestFile = url;
  ajaxform[out].method = "POST";
  ajaxform[out].setVar("do", "filter_save");

  for(var field in params){
    ajaxform[out].setVar(field , params[field]);
  }
  ajaxform[out].setVar("replaceme", replaceme);

  ajaxform[out].onCompletion = function() {
    var qs = '';
    for(var field in params){
      qs = '&'+field+'='+params[field];
    }

    ld_content(replaceme, url+'?do=list_container&replaceme='+replaceme+qs, '', 1)
  }
  ajaxform[out].runAJAX();
}

function init_tablelist(id) {
  alltabl = document.getElementsByTagName("table").length;
  for(var i = 0; i < alltabl; i++) {
    element_table = document.getElementsByTagName("table")[i];
    if (element_table.className == "tablelist" && element_table.id == id) {
      var Trclass = "odd";
      alltr = element_table.getElementsByTagName("tr").length;
      var script_link = element_table.getAttribute("script_link");
      var script_replaceme = element_table.getAttribute("script_replaceme");
      var script_param = element_table.getAttribute("script_param");

      for(j = 0; j < alltr; j++) {
        element = element_table.getElementsByTagName("tr")[j];
        if (element.className != "header" && element.className != "tempo") {
          if (Trclass == "odd") { Trclass = "even"; } else { Trclass = "odd"; }
          element.className = Trclass;
          var class_tr = element.className;
          element.classold = class_tr;
          // element.onmouseout = function() {
          //   if (this.className == 'selectmarked' || this.className == 'marked') {
          //     this.className = 'marked'
          //   } else {
          //     this.className = this.classold;
          //   }
          // }
          // element.onmouseover = function() {
          //   if (this.className == 'marked') {
          //     this.className = 'selectmarked'
          //   } else { this.className = 'select' }
          // }
          alltd = element.getElementsByTagName("td").length;
          for(t = 0; t < alltd; t++) {
            index = element.id.split('r')[1];

            element_td = element.getElementsByTagName("td")[t];
            if (!element_td.getElementsByTagName("label")[0] && element_td.className != 'button16') {
              element_td.ondblclick = function() {
                indx = this.parentNode.id.split('r')[1];
                openPage('center', script_replaceme + indx, script_link + '?do=info&index=' + indx +'&replaceme=' + script_replaceme + indx + script_param, 'info','info');
              }
            }

            if (element_td.className == "lchb") { // чекбокс для групповых операций
              var chb = document.createElement('INPUT');
              chb.type='checkbox';
              chb.className = 'listchb ' + index + ' ' + Trclass;
              chb.onclick = function() {
                array = this.className.split(' ');
                markup_tr(array[1], array[2]);
              }
              chb.id = "listchb" + index;
              element_td.appendChild(chb);
            }
            if (element_td.className == "qview") { // Быстрый просмотр
              var formInfo = document.createElement('SPAN');
              formInfo.className = "formInfo";
              element_td.appendChild(formInfo);
              var fI_a = document.createElement('A');
              fI_a.name = "Быстрый просмотр";
              fI_a.id = "view" + index;
              fI_a.className = "jTip";
              fI_a.href_link = script_link + "?index=" + index + "&width=400&do=quick_view&" + script_param;
              fI_a.onclick = function() { doNothing(); }
              fI_a.onmouseout = function() { jQuery('#JT').remove();}
              fI_a.onmouseover = function(event) { JT_show(event, this.href_link,this.id,this.name); }
              formInfo.appendChild(fI_a);
              fI_img = document.createElement('IMG');
              fI_img.src = "/admin/img/icons/flat/qview.png";
              fI_img.border = 0;
              fI_a.appendChild(fI_img);
            }
            if (element_td.className == "button16") { // кнопка
              alldiv = element_td.getElementsByTagName("div").length;
              for(d = 0; d < alldiv; d++) {
                element_div = element_td.getElementsByTagName("div")[d];
                if (element_div.className) {
                  action = element_div.className;
                  var a = document.createElement('a');
                  a.href =  '#';
                  a.dataset.action = action;
                  a.dataset.index = index;

                  if(action == 'delete'){
                    var confirm_msg = 'Вы действительно хотите удалить запись?';
                    a.alt = confirm_msg;
                    a.title = 'Удалить запись';
                    a.onclick = function() {
                      var data = this.dataset;
                      if (confirm(this.alt)) openPage('center', script_replaceme + data.index, script_link + '?do=' + data.action + '&index=' + data.index +'&replaceme=' + script_replaceme + data.index + script_param, 'info','info');
                    }
                  }
                  else if(action == 'send' ){
                    var confirm_msg = 'Вы действительно хотите разослать?';
                    a.alt = confirm_msg;
                    a.title = 'Разослать';
                    a.onclick = function() {
                      var data = this.dataset;
                      if (confirm(this.alt)) openPage('center', script_replaceme + data.index, script_link + '?do=' + data.action + '&index=' + data.index +'&replaceme=' + script_replaceme + data.index + script_param, 'info','info');
                    }
                  }
                  else if(action == 'print' ){
                    a.title = 'Печать';
                    a.onclick = function() {
                      var data = this.dataset;
                      displayMessage(script_link + '?do=' + data.action + '&index=' + data.index + script_param, 400, 350, 3)
//                        loadfile(script_link + '?action=' + array[0] + '&index=' + array[1]);
                    }
                  }
                  else if(action == 'link_to' ){
                    a.title = 'Перейти';
                    a.onclick = function(e) {
                      var data = this.dataset;

                      var $a = jQuery("#tr"+data.index).find(".button16 .link_to a"),
                          src = $a.css("background-image");
                      if (window.openURLtimer) {
                        $a.css("background-image", "url(/admin/img/preloader_16x16.png)");

                        jQuery.ajax({
                          url: script_link + '?do=' + data.action + '&index=' + data.index
                        }).done(function(data){
                          $a.css("background-image", src);
                          if (data) {
                            prompt("URL страницы", data);
                          }
                        });

                        clearTimeout(window.openURLtimer);
                        window.openURLtimer = null;
                        e.preventDefault();
                        return false;
                      }

                      window.openURLtimer = setTimeout(function() { open_url(script_link + '?do=' + data.action + '&index=' + data.index); window.openURLtimer = null; }, 250);
                    }
                  }
                  else if(action == 'upload' ){
                    a.title = 'Скачать';
                    a.onclick = function(){

                      var data = this.dataset;
                      open_url(script_link + '?do=' + data.index + '&index=' + data.index);
                    }
                  }
                  else if(action == 'edit' ){
                    a.title = 'Редактировать';
                    a.onclick = function() {
                      var data = this.dataset;
                      openPage('center', script_replaceme + data.index, script_link + '?do=' + data.action + '&index=' + data.index + '&replaceme=' + script_replaceme + data.index + script_param, 'info','info');
                    }
                  }
                  else if(action == 'text' ){
                    a.title = 'Редактировать текст';
                    a.onclick = function() {
                      var data = this.dataset;
                      openPage('center', script_replaceme + data.index, script_link + '?do=' + data.action + '&index=' + data.index + '&replaceme=' + script_replaceme + data.index + script_param, 'info','info');
                    }
                  } else {
                    a.title = 'Текст';
                    a.onclick = function() {
                      var data = this.dataset;
                      openPage('center', script_replaceme + data.index, script_link + '?do=' + data.action + '&index=' + data.index + '&replaceme=' + script_replaceme + data.index + script_param, 'info','info');
                    }
                  }
                  element_div.appendChild(a);
                }
              }
            }
          }
        }
      }
      if (element_table.getAttribute("qedit") == 1) setTimeout("init_qedit('" + id + "')", 1000);
    }
  }


}

function init_qedit_doptable(id) {
  alltabl = document.getElementsByTagName("table").length;
  for(var i = 0; i < alltabl; i++) {
    element_table = document.getElementsByTagName("table")[i];
    if (element_table.className == "DHTMLSuite_tableWidget" && element_table.id == id) {
      alltr = element_table.getElementsByTagName("tr").length;

      var script_link = element_table.getAttribute("script_link");
      var script_replaceme = element_table.getAttribute("script_replaceme");
      var script_param = element_table.getAttribute("script_param");

      textEditObj[id] = new DHTMLSuite.textEdit();
      textEditObj[id].setServersideFile(script_link + '?do=save_qedit&' + script_param);

      for(j = 0; j < alltr; j++) {
        element = element_table.getElementsByTagName("tr")[j];
        if (element.className != "header") {
          alltd = element.getElementsByTagName("td").length;
          for(t = 0; t < alltd; t++) {
            element_td = element.getElementsByTagName("td")[t];
            if (element_td.getElementsByTagName("label")[0]) {
              lbl = element_td.getElementsByTagName("label")[0].id;
              elm = element_td.getElementsByTagName("div")[0].id;
              if (element_td.getElementsByTagName("label")[0].className == "list") {
                textEditObj[id].addElement( { labelId: lbl, elementId: elm, listModel: listModel[elm.split('__')[1]] } );
              } else {
                textEditObj[id].addElement( { labelId: lbl, elementId: elm } );
              }
            }
          }
        }
      }
      if(textEditObj[id]) textEditObj[id].init();
    }
  }
}

function init_qedit(id) {
  alltabl = document.getElementsByTagName("table").length;
  for(var i = 0; i < alltabl; i++) {
    element_table = document.getElementsByTagName("table")[i];
    if (element_table.className == "tablelist" && element_table.id == id) {
      alltr = element_table.getElementsByTagName("tr").length;
      var script_link = element_table.getAttribute("script_link");
      var script_replaceme = element_table.getAttribute("script_replaceme");
      var script_param = element_table.getAttribute("script_param");

      textEditObj[id] = new DHTMLSuite.textEdit();
      textEditObj[id].setServersideFile(script_link + '?do=save_qedit&' + script_param);

      for(j = 0; j < alltr; j++) {
        element = element_table.getElementsByTagName("tr")[j];
        if (element.className != "header") {
          alltd = element.getElementsByTagName("td").length;
          for(t = 0; t < alltd; t++) {
            element_td = element.getElementsByTagName("td")[t];
            if (element_td.getElementsByTagName("label")[0]) {
              lbl = element_td.getElementsByTagName("label")[0].id;
              elm = element_td.getElementsByTagName("div")[0].id;
              if (element_td.getElementsByTagName("label")[0].className == "list") {
                textEditObj[id].addElement( { labelId: lbl, elementId: elm, listModel: listModel[elm.split('__')[1]] } );
              } else {
                textEditObj[id].addElement( { labelId: lbl, elementId: elm } );
              }
            }
          }
        }
      }
      if(textEditObj[id]) textEditObj[id].init();
    }
  }
}

function init_qedit_info(id) {
  var $table = jQuery("table.tablelist").filter("#quickEditI"+id);
  if($table.length){
    var script_link = $table.attr("script_link");
    var script_param = $table.attr("script_param");

    textEditObj[id] = new DHTMLSuite.textEdit();
    textEditObj[id].setServersideFile(script_link + '?do=save_qedit_i&' + script_param);

    $table.find('td.read label').each(function(){
      var $label = $(this);
      var $div = $(this).closest('td').find('div');

      var label_id = $label.attr('id');
      var div_id = $div.attr('id');

      if($label.hasClass("list")){
        var lkey = div_id.split('__')[1]
        // if (!listModel[lkey]) {
          listModel[lkey] = new DHTMLSuite.listModel();
          listModel[lkey].createFromMarkupSelect('datasource_' + lkey);
        // }
        textEditObj[id].addElement( { labelId: label_id, elementId: div_id, listModel: listModel[lkey] } );
      } else{
        textEditObj[id].addElement( { labelId: label_id, elementId: div_id } );
      }
    })

    if(textEditObj[id]) textEditObj[id].init();
  }
}

function load_data(divId, url) {

  var ajaxIndex = 'table' + divId; //ajaxform.length;
  if (ajaxIndex && document.getElementById('quickEdit' + divId)) {
    ajaxform[ajaxIndex] = new sack();
    ajaxform[ajaxIndex].requestFile = url;
    ajaxform[ajaxIndex].onError = function()   {whenError(ajaxIndex);}
    ajaxform[ajaxIndex].onFail  = function()   {whenError(ajaxIndex);}
      ajaxform[ajaxIndex].onLoading = function() {whenLoading(ajaxIndex);}
      ajaxform[ajaxIndex].onLoaded  = function() {whenLoaded(ajaxIndex);}
      ajaxform[ajaxIndex].onInteractive = function() {whenInteractive(ajaxIndex);}
    ajaxform[ajaxIndex].onCompletion  = function() { parse_data_to_table(divId, ajaxIndex) };
    ajaxform[ajaxIndex].runAJAX();    // Execute AJAX function
  }
}

function parse_data_to_table(id, ajaxIndex) {
  if (document.getElementById(ajaxIndex)) document.getElementById(ajaxIndex).style.display = "none";
  else return 0;
  if (ajaxform[ajaxIndex] && !ajaxform[ajaxIndex].response || !ajaxform[ajaxIndex]) {return 0;}

  data = ajaxform[ajaxIndex].response;
  var data =jQuery.parseJSON(data);


  var element_table = jQuery("#quickEdit"+id);
  if(element_table){
    var element_body = jQuery("tbody:first", element_table);
    var element_header = jQuery("tr:last", element_body);

    var lkeys = data.lkeys;
    var vals = data.data;
    var buttons_key = data.buttons_key;
    var settings = data.settings;
    var qedit = element_table.attr('qedit') && element_table.attr('qedit')==1 ? 1 : 0;

    for(var i=0; i<vals.length; i++){
      var td_str = vals[i];

      tr = document.createElement('TR');
      jQuery(tr).data('index', td_str['ID']);

      jQuery(tr).attr('id',  'tr'+td_str['ID']);
      var td = document.createElement('TD');
      jQuery(td).addClass("lchb");
      jQuery(tr).append(td);

      if(settings.qview){
        var td = document.createElement('TD');
        jQuery(td).addClass("qview");
        jQuery(tr).append(td);
      }

      for(var lkeyindex=0; lkeyindex<lkeys.length; lkeyindex++) {
        var lkey_name = lkeys[lkeyindex].lkey;
        var lkey_type = lkeys[lkeyindex].type;

        var td = document.createElement('TD');

        if( lkey_type=='float' || lkey_type=='decimal' ){
          td_str[lkey_name] = Number( td_str[lkey_name] ).toFixed(2);
        }

        if(qedit && (lkey_type=='s' || lkey_type=='float' || lkey_type=='decimal'  || lkey_type=='d' || lkey_type=='tlist' || lkey_type=='list' || lkey_type=='chb')){

          if(lkeys[lkeyindex].qedit){
            var label = document.createElement('LABEL');

            if (lkey_type=='list' || lkey_type=='tlist' || lkey_type=='chb') {
              jQuery(label).addClass("list");
              // if (!listModel[lkey_name]) {
                listModel[lkey_name] = new DHTMLSuite.listModel();
                listModel[lkey_name].createFromMarkupSelect('datasource_'+lkey_name);
              // }
            }

            jQuery(td).append(label);
            div = document.createElement('DIV');
            jQuery(div).attr('id',  td_str['ID']+"__"+lkey_name).html( td_str[lkey_name] );

            jQuery(label).attr('id',  "label"+td_str['ID']+"__"+lkey_name).append(div);

            jQuery(td).append(label);

          } else{
            jQuery(td).html( td_str[lkey_name] );
          }

        } else if(lkey_type=='pict' || lkey_type=='file'){

          var ext = (/[.]/.exec(td_str[lkey_name])) ? /[^.]+$/.exec(td_str[lkey_name]) : undefined;
          var valid_ext = new Array('jpg','png','gif','jpeg');

          if(ext && ext == 'swf'){
            var swf_width = 64;
              swf_height = 64;

            if(td_str['width'] && td_str['height']){
              var k = td_str['width'] / swf_width;
              swf_height = parseInt(td_str['height'] / k)
            }

            var swf = document.createElement('OBJECT');
            swf.setAttribute("width", swf_width);
            swf.setAttribute("height", swf_height);
            swf.setAttribute("codebase", "http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0");
            swf.setAttribute("classid", "clsid:d27cdb6e-ae6d-11cf-96b8-444553540000");

            param = document.createElement('PARAM');
            param.name  = "allowScriptAccess";
            param.value = "sameDomain";
            swf.appendChild(param);

            param = document.createElement('PARAM');
            param.name  = "movie";
            param.value = td_str[lkey_name];
            swf.appendChild(param);

            param = document.createElement('PARAM');
            param.name  = "quality";
            param.value = "high";
            swf.appendChild(param);

            param = document.createElement('PARAM');
            param.name  = "bgcolor";
            param.value = "#ffffff";
            swf.appendChild(param);

            param = document.createElement('EMBED');
            param.setAttribute("pluginspage", "http://www.macromedia.com/go/getflashplayer");
            param.setAttribute("type", "application/x-shockwave-flash");
            param.setAttribute("allowscriptaccess", "sameDomain");
            param.setAttribute("bgcolor", "#ffffff");
            param.setAttribute("quality", "high");
            param.setAttribute("width", swf_width);
            param.setAttribute("height", swf_height);
            param.src = td_str[lkey_name];
            swf.appendChild(param);

            jQuery(td).append(swf);
            jQuery(td).css("text-align", 'center');
          }
          else if(ext && valid_ext.indexOf(ext[0].toLowerCase()) != -1 && lkey_type == 'pict') {
            var img = new Image();
            img.src =  td_str[lkey_name] == '/admin/img/no_img.png' ? td_str[lkey_name] : td_str[lkey_name]+"?"+Math.random();
            jQuery(img).css('width', '64px');
            jQuery(img).css('height', '64px');
            jQuery(td).append(img);
            jQuery(td).css("text-align", 'center');
          }
          else {
            jQuery(td).html( td_str[lkey_name] );
          }

        } else if(lkey_type=='date' && td_str[lkey_name]){
          var parts = td_str[lkey_name].split('-');
          jQuery(td).text( parts[2]+'.'+parts[1]+'.'+parts[0] );

        } else if(lkey_type=='videolink'){
    			if(qedit && lkeys[lkeyindex].qedit){
    				var label = document.createElement('LABEL');

    				jQuery(td).append(label);
    				div = document.createElement('DIV');
    				jQuery(div).attr('id',  td_str['ID']+"__"+lkey_name).html( td_str[lkey_name] );

    				jQuery(label).attr('id',  "label"+td_str['ID']+"__"+lkey_name).append(div);

    				jQuery(td).append(label);
    			} else{
    				if(td_str[lkey_name]){
    					jQuery(td).html('<a href="https://www.youtube.com/watch?v='+td_str[lkey_name]+'" target="_blank"><img width="116" src="http://img.youtube.com/vi/'+td_str[lkey_name]+'/hqdefault.jpg" /></a>');
    				} else{
    					var img = new Image();
    					img.src = '/admin/img/no_img.png';
    					jQuery(img).css('width', '64px');
    					jQuery(img).css('height', '64px');
    					jQuery(td).append(img);
    					jQuery(td).css("text-align", 'center');
    				}
    			}
    		} else{
          jQuery(td).html( td_str[lkey_name] );

        }
        jQuery(tr).append(td);
      };

      for(var j=0; j<buttons_key.length; j++) {
        var td = document.createElement('TD');
        td.className = "button16";
        var div = document.createElement('DIV');
        div.className = buttons_key[j].lkey;
        if(buttons_key[j].confirm) div.setAttribute("confirm", buttons_key[j].confirm);

        td.appendChild(div);
        tr.appendChild(td);
      };

      jQuery(tr).insertBefore(element_header);
    };
  }

  document.getElementById(ajaxIndex).innerHTML = "";

  init_tablelist('quickEdit' + id);
}
function init_restore_buttons(replaceme){
  var $table = $("table[mode=changes]"),
    script_replaceme = $table.attr('script_replaceme');
    script_link = $table.attr('script_link');
    script_param = $table.attr('script_param');

  $table.find('.delete_change,.restore_change').each(function(i,v){
    var $button = $(this).find('a');
    $button.bind('click',function(){
      var data = $(this).data();
      do_submit_link(script_replaceme, script_replaceme, '/admin/'+data.controller+'/body?do='+data.action+'&change_index='+data.index+'&index='+data.itemId+'&replaceme='+script_replaceme);
    });
  });
}
