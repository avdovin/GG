var l = function(word){
  if(typeof LANG_DICT == 'undefined') return false;

  return LANG_DICT[word] ? LANG_DICT[word] : word
}

function addScript( src ) {
  var s = document.createElement( 'script' );
  s.setAttribute( 'src', src );
  document.body.appendChild( s );
}