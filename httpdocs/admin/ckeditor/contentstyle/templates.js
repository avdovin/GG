CKEDITOR.addTemplates("default", {
	imagesPath: CKEDITOR.getUrl(CKEDITOR.plugins.getPath("templates")+"templates/images/"),
	templates: 	[
		{
			title:"Текст с картинкой",
			image:"template1.gif",
			description:"Основное изображение с заголовком и текстом, которые окружают изображения.",
			html:'\
				<img src=" " alt="" style="margin-right: 10px" height="100" width="100" align="left" />\
				<p>Текст</p>'
		},
		{
			title:"Текст в 2 колонки",
			image:"template2.gif",
			description:"Шаблон с 2-мя колонками текста",
			html: ' \
				<div class="col col_left col_nosidebg" style="width:450px">\
					Текст 1\
				</div>\
				<div class="col col_right" style="width: 450px;background: none;box-shadow: none">\
				 	Текст 2 \
				</div> \
				<div style="clear: both"></div> \
			'
		}
		]
	});
