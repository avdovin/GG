/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	config.language = 'ru';
	// config.uiColor = '#AADC6E';
	config.skin = 'v2';

	config.filebrowserImageBrowseUrl = '/admin/filemanager/elfinder.html?mode=image';
	//config.filebrowserBrowseUrl = '/admin/texts/body?do=link';
	config.filebrowserBrowseUrl = '/admin/filemanager/elfinder.html?mode=file';
	config.filebrowserFlashBrowseUrl = '/admin/filemanager/elfinder.html?mode=flash';
	
	config.startupShowBorders = false;
	config.startupFocus = false;
	
	config.filebrowserImageWindowWidth = '1200';
	config.filebrowserImageWindowHeight = '700';
	
	config.filebrowserWindowWidth = '1200';
	config.filebrowserWindowHeight = '700';
	
	config.contentsCss = '/admin/ckeditor/contentstyle/content.css';
	config.bodyClass = 'body';
	
	config.stylesSet = [];
	
	config.stylesSet = 'content_styles:/admin/ckeditor/contentstyle/ckeditor_styles.js';
	
	//config.extraPlugins = 'stylesheetparser';
	//config.contentsCss = '/css/ckeditor.css';
	//config.stylesheetParser_skipSelectors = /(^(body|div)\.|^\.)/i;
	
	config.toolbar = 'Full';
	
	config.toolbar_Full =
	[
		{ name: 'document', items : [ 'Source','NewPage','DocProps','Preview','Print','Templates' ] },
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
		{ name: 'tools', items : [ 'Maximize', 'ShowBlocks','About' ] }
	];

	config.toolbar = 'Basic';
	config.toolbar_Basic =
		[
		['Source','Preview','-'],
	       ['Cut','Copy','Paste','PasteText','PasteFromWord','-'],
		['Undo','Redo','-','Replace','-','SelectAll','RemoveFormat'],
		['Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', 'Unlink','-','Maximize']
		];
};

