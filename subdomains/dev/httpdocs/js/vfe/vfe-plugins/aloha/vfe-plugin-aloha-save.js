Aloha.ready(function() {
	Aloha.require( ['aloha', 'aloha/jquery'], function( Aloha, jQuery) {

		// save all changes after leaving an editable
		Aloha.bind('aloha-editable-deactivated', function(){
			var content = Aloha.activeEditable.getContents();
			var contentId = Aloha.activeEditable.obj[0].id;

			// textarea handling -- html id is "xy" and will be "xy-aloha" for the aloha editable
			if ( contentId.match(/-aloha$/gi) ) {
				contentId = contentId.replace( /-aloha/gi, '' );
			}

			if (confirm("Сохранить изменения?")) {

				var request = jQuery.ajax({
					url: "/admin/vfe-text-save",
					type: "POST",
					data: {
						content : content,
						id : $("#"+contentId).data("vfe-textid")
					},
					dataType: "html"
				});

				request.done(function(msg) {
					var json;
					if (msg.substr(0,1) == '{') {
						json = jQuery.parseJSON(msg);
						if (json.error) vfe.showMessage("Ошибка", json.error, true);
					} else {
						vfe.showMessage("Сохранение", msg);	
					}
				});

				request.error(function(jqXHR, textStatus) {
					vfe.showMessage("Ошибка", textStatus, true);
				});

			}
		});

	});
});