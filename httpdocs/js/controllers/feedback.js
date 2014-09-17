$(function(){
    GG.attachForm(".contacts__form", ".contacts__form .form__send");
    ymaps.ready( YMapsInit );
});


// Yandex Maps
if (typeof ymaps != 'undefined') {
    ymaps.ready(YMapsInit);
}

var myMap,
    myPlacemark;

function YMapsInit(){
    myMap = new ymaps.Map("Gmap", {
        center: [59.936026,30.318344],
        zoom: 14
    });

    myPlacemark = new ymaps.Placemark([59.936026,30.318344], {
        hintContent: 'Невский проспект, 15'
    });

    myMap.geoObjects.add(myPlacemark);
}
//