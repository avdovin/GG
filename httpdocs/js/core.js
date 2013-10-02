(function(){
  if( document.cookie.indexOf('device_pixel_ratio') == -1
      && 'devicePixelRatio' in window
      && window.devicePixelRatio > 1 ){

    document.cookie = 'device_pixel_ratio=' + window.devicePixelRatio + ';';
    window.location.reload();
  }
})();

