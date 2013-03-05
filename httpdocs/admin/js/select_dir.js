function init_select_dir(key_tree) {
  treeObj[key_tree] = new JSDragDropTree();
  
  treeObj[key_tree].setTreeId('tree_' + key_tree);
  treeObj[key_tree].setMaximumDepth(7);
  treeObj[key_tree].setATag(key_tree);
  treeObj[key_tree].setMessageMaximumDepthReached('Maximum depth reached');
  treeObj[key_tree].initTree();

  treeObj[key_tree].showHideNode(false,"node_"+key_tree+"0");
}

function click_node(div, url, key_tree) {
    var e = document.getElementById(div);
    if (e) {tree_ld_content(div, url, 1);}
//    if (e) {ld_content(div, url, 1, 1);}
}
function set_folder(id, name, index, lkey) {
    document.getElementById(id).innerHTML = name;
    document.getElementById(lkey).value = index;
}
