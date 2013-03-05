function editcodeinit(textarea_id, syntax, div, frm) { // инициализация подсветки синтаксиса
	if (CodeEA[textarea_id] && editAreas[textarea_id] && document.getElementById("frame_"+textarea_id)) {
		editAreaLoader.delete_instance(textarea_id);
		delete CodeEA[textarea_id];
		enableSubmit(frm);
	} else {
		editAreaLoader.win = "loaded";
		editAreaLoader.init({
			id: textarea_id	// id of the textarea to transform		
			,start_highlight: true	// if start with highlight
			,allow_resize: "both"
			,allow_toggle: false
			,language: "en"
			,syntax: syntax	
			,toolbar: "search, go_to_line, |, undo, redo, |, select_font, |, syntax_selection, |, change_smooth_selection, highlight, reset_highlight, |, help"
			,syntax_selection_allow: "css,html,js,xml,sql"
			,show_line_colors: true
		});

	   CodeEA[textarea_id] = true;
	   disableSubmit(frm);
	}
}
function enableSubmit(frm)  { document.getElementById(id_block_submit[frm]).disabled = false; document.getElementById('dop' + id_block_submit[frm]).disabled = false; }
function disableSubmit(frm) { document.getElementById(id_block_submit[frm]).disabled = true; document.getElementById('dop' + id_block_submit[frm]).disabled = true; }
