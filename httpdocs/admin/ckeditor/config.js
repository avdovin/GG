/**
 * @license Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here.
	// For the complete reference:
	// http://docs.ckeditor.com/#!/api/CKEDITOR.config
	config.language = 'ru';

	config.filebrowserImageBrowseUrl = '/admin/filemanager/elfinder.html?mode=image';
	//config.filebrowserBrowseUrl = '/admin/texts/body?do=link';
	config.filebrowserBrowseUrl = '/admin/filemanager/elfinder.html?mode=file';
	config.filebrowserFlashBrowseUrl = '/admin/filemanager/elfinder.html?mode=flash';

	config.filebrowserImageWindowWidth = '1200';
	config.filebrowserImageWindowHeight = '700';
	
	config.filebrowserWindowWidth = '1200';
	config.filebrowserWindowHeight = '700';

	config.contentsCss = '/admin/ckeditor/contentstyle/content.css';
	config.bodyClass = 'body';
	
	config.stylesSet = [];
	
	config.stylesSet = 'content_styles:/admin/ckeditor/contentstyle/ckeditor_styles.js';
				
	// The toolbar groups arrangement, optimized for two toolbar rows.
	config.toolbarGroups = [
	    { name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
	    { name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
	    { name: 'links' },
	    { name: 'insert' },
	    { name: 'forms' },
	    { name: 'tools' },
	    { name: 'document',    groups: [ 'mode', 'document', 'doctools' ] },
	    { name: 'others' },
	    '/',
	    { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
	    { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align' ] },
	    { name: 'styles' },
	    { name: 'colors' },
	    { name: 'about' }
	];

	config.toolbar = 'Basic';
	config.toolbar_Basic =
		[
		['Source','Preview','-'],
	       ['Cut','Copy','Paste','PasteText','PasteFromWord','-'],
		['Undo','Redo','-','Replace','-','SelectAll','RemoveFormat'],
		['Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', 'Unlink','-','Maximize']
	];

	config.toolbar = 'Full';
	config.toolbar_Full =
	[
		//{ name: 'document', items : [ 'Source','NewPage','DocProps','Preview','Print','Templates' ] },
		{ name: 'document', items : [ 'Source','Preview','Print' ] },
		{ name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','Undo','Redo' ] },
		{ name: 'editing', items : [ 'Find','Replace','SelectAll' ] },
		{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','RemoveFormat','NumberedList','BulletedList'] },
		
		'/',
		
		{ name: 'paragraph', items : [ 'JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' ] },
		
		{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
		{ name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule','SpecialChar','PageBreak' ] },
		//'/',
		{ name: 'styles', items : [ 'Format' ] },
		{ name: 'colors', items : [ 'TextColor','BGColor' ] },
		{ name: 'tools', items : [ 'Maximize' ] },
		{ name: 'About', items : [ 'About' ] }
	];

	
		
	// Remove some buttons, provided by the standard plugins, which we don't
	// need to have in the Standard(s) toolbar.
	//config.removeButtons = 'Underline,Subscript,Superscript';
};
