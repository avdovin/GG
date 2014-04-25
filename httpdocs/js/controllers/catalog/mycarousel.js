$(function(){
	if (typeof jQuery.fn.jcarousel != 'undefined'){
		$('#mycarousel').jcarousel({
			size: mycarousel_itemList.length,
			itemLoadCallback: {onBeforeAnimation: mycarousel_itemLoadCallback}
		});
	}
})

// mycarousel
var mycarousel_itemList = [
	{url: "img/kartochka_items_93x93.jpg", title: "Item1"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item2"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item3"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item4"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item5"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item6"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item7"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item8"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item9"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item10"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item11"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item12"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item13"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item14"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item15"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item16"},
	{url: "img/kartochka_items_93x93.jpg", title: "Item17"}
];

function mycarousel_itemLoadCallback(carousel, state)
{
	for (var i = carousel.first; i <= carousel.last; i++) {
		if (carousel.has(i)) {
			continue;
		}

		if (i > mycarousel_itemList.length) {
			break;
		}

		carousel.add(i, mycarousel_getItemHTML(mycarousel_itemList[i-1]));
	}
};

/**
 * Item html creation helper.
 */
function mycarousel_getItemHTML(item)
{
	return '<a href="#"><img src="' + item.url + '" alt="' + item.url + '" /></a>';
};

