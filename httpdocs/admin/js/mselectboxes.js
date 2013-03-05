	var fromBoxArray = new Array();
	var toBoxArray = new Array();
	var selectBoxIndex = 0;
	var arrayOfItemsToSelect = new Array();
	
	
	function moveSingleElement() {
		var selectBoxIndex = this.parentNode.parentNode.id.replace(/[^\d]/g,'');
		var tmpFromBox;
		var tmpToBox;
		if(this.tagName.toLowerCase()=='select'){			
			tmpFromBox = this;
			if(tmpFromBox==fromBoxArray[selectBoxIndex])tmpToBox = toBoxArray[selectBoxIndex]; else tmpToBox = fromBoxArray[selectBoxIndex];
		}else{
		
			if(this.value.indexOf('>')>=0){
				tmpFromBox = fromBoxArray[selectBoxIndex];
				tmpToBox = toBoxArray[selectBoxIndex];
				var box_sel = 1;
			}else{
				tmpFromBox = toBoxArray[selectBoxIndex];
				tmpToBox = fromBoxArray[selectBoxIndex];	
				var box_sel = 0;
			}
		}
		
		for(var no=0;no<tmpFromBox.options.length;no++){
			if(tmpFromBox.options[no].selected){
				tmpFromBox.options[no].selected = false;
				tmpToBox.options[tmpToBox.options.length] = new Option(tmpFromBox.options[no].text,tmpFromBox.options[no].value);
				
				for(var no2=no;no2<(tmpFromBox.options.length-1);no2++){
					tmpFromBox.options[no2].value = tmpFromBox.options[no2+1].value;
					tmpFromBox.options[no2].text = tmpFromBox.options[no2+1].text;
					tmpFromBox.options[no2].selected = tmpFromBox.options[no2+1].selected;
				}
				no = no -1;
				tmpFromBox.options.length = tmpFromBox.options.length-1;
											
			}			
		}
		
		
		var tmpTextArray = new Array();
		for(var no=0;no<tmpFromBox.options.length;no++){
			tmpTextArray.push(tmpFromBox.options[no].text + '___' + tmpFromBox.options[no].value);			
		}
		tmpTextArray.sort();
		var tmpTextArray2 = new Array();
		for(var no=0;no<tmpToBox.options.length;no++){
			tmpTextArray2.push(tmpToBox.options[no].text + '___' + tmpToBox.options[no].value);			
		}		
		tmpTextArray2.sort();
		
		for(var no=0;no<tmpTextArray.length;no++){
			var items = tmpTextArray[no].split('___');
			tmpFromBox.options[no] = new Option(items[0],items[1]);
			
		}		
		
		for(var no=0;no<tmpTextArray2.length;no++){
			var items = tmpTextArray2[no].split('___');
			tmpToBox.options[no] = new Option(items[0],items[1]);
			if (box_sel) tmpToBox.options[no].selected = true;
		}
	}
	
	function sortAllElement(boxRef, box_sel)
	{
		var tmpTextArray2 = new Array();
		for(var no=0;no<boxRef.options.length;no++){
			tmpTextArray2.push(boxRef.options[no].text + '___' + boxRef.options[no].value);			
		}		
		tmpTextArray2.sort();		
		for(var no=0;no<tmpTextArray2.length;no++){
			var items = tmpTextArray2[no].split('___');
			boxRef.options[no] = new Option(items[0],items[1]);			
			if (box_sel) boxRef.options[no].selected = true;
		}		
		
	}
	function moveAllElements()
	{
		var selectBoxIndex = this.parentNode.parentNode.id.replace(/[^\d]/g,'');
		var tmpFromBox;
		var tmpToBox;		
		if(this.value.indexOf('>')>=0){
			tmpFromBox = fromBoxArray[selectBoxIndex];
			tmpToBox = toBoxArray[selectBoxIndex];			
			var box_sel = 1;
		}else{
			tmpFromBox = toBoxArray[selectBoxIndex];
			tmpToBox = fromBoxArray[selectBoxIndex];	
			var box_sel = 0;
		}
		
		for(var no=0;no<tmpFromBox.options.length;no++){
			tmpToBox.options[tmpToBox.options.length] = new Option(tmpFromBox.options[no].text,tmpFromBox.options[no].value);
		}	
		
		tmpFromBox.options.length=0;
		sortAllElement(tmpToBox, box_sel);
		
	}
	
	
	/* This function highlights options in the "to-boxes". It is needed if the values should be remembered after submit. Call this function onsubmit for your form */
	function multipleSelectOnSubmit()
	{
		for(var no=0;no<arrayOfItemsToSelect.length;no++){
			var obj = arrayOfItemsToSelect[no];
			for(var no2=0;no2<obj.options.length;no2++){
				obj.options[no2].selected = true;
			}
		}
		
	}
	
	function createMovableOptions(fromBox,toBox,totalWidth,totalHeight,labelLeft,labelRight) {
		fromObj = document.getElementById(fromBox);
		toObj = document.getElementById(toBox);

		arrayOfItemsToSelect[arrayOfItemsToSelect.length] = toObj;
		
		fromObj.ondblclick = moveSingleElement;
		toObj.ondblclick = moveSingleElement;
		
		fromBoxArray.push(fromObj);
		toBoxArray.push(toObj);
		
		var parentEl = fromObj.parentNode;
		var parentDiv = document.createElement('DIV');
		parentDiv.className='multipleSelectBoxControl';
		parentDiv.id = 'selectBoxGroup' + selectBoxIndex;
		parentDiv.style.width = '100%';
		parentEl.insertBefore(parentDiv,fromObj);
		
		var subDiv = document.createElement('DIV');
		if (totalWidth) {
			subDiv.style.width = '45%';
			subDiv.style.cssText = "width:45%;margin-right:10px;float:left";
			fromObj.style.width = '100%';
		} else {
			subDiv.style.width = '90%';
			subDiv.style.cssText = "width:90%;margin-right:10px";
			fromObj.style.width = '100%';
		}
		fromObj.style.height = 130 + 'px';
		subDiv.style.styleFloat = "left";

		var label = document.createElement('SPAN');
		label.innerHTML = labelLeft;
		subDiv.appendChild(label);
		subDiv.appendChild(document.createElement('BR'));
		
		subDiv.appendChild(fromObj);
		subDiv.className = 'multipleSelectBoxDiv';
		parentDiv.appendChild(subDiv);
		
		var buttonDiv = document.createElement('DIV');
		buttonDiv.style.verticalAlign = 'middle';
		if (totalHeight) buttonDiv.style.paddingTop = (totalHeight/2) - 50 + 'px';
		buttonDiv.style.width = '30px';
		buttonDiv.style.textAlign = 'center';
		buttonDiv.style.styleFloat = "left";
		if (totalWidth) {
			buttonDiv.style.cssText = "width:30px;margin-right:0px;margin-top:25px;font-family: Verdana, Arial, sans-serif;float:left";
		} else {
			buttonDiv.style.cssText = "width:30px;margin-right:0px;margin-top:25px;margin-bottom:25px;font-family: Verdana, Arial, sans-serif";
		}
		buttonDiv.className='multipleButtonBox';
		parentDiv.appendChild(buttonDiv);
		
		var buttonRight = document.createElement('INPUT');
		buttonRight.type='button';
		buttonRight.value = '>';
		buttonRight.style.width = '25px';
		buttonRight.className = "submit";
		buttonDiv.appendChild(buttonRight);	
		buttonRight.onclick = moveSingleElement;
		buttonDiv.appendChild(document.createElement('BR'));
		
		var buttonAllRight = document.createElement('INPUT');
		buttonAllRight.style.marginTop='3px';
		buttonAllRight.type='button';
		buttonAllRight.value = '>>';
		buttonAllRight.style.width = '25px';
		buttonAllRight.className = "submit";
		buttonAllRight.onclick = moveAllElements;
		buttonDiv.appendChild(buttonAllRight);		
		buttonDiv.appendChild(document.createElement('BR'));
		
		var buttonLeft = document.createElement('INPUT');
		buttonLeft.style.marginTop='7px';
		buttonLeft.type='button';
		buttonLeft.value = '<';
		buttonLeft.style.width = '25px';
		buttonLeft.className = "submit";
		buttonLeft.onclick = moveSingleElement;
		buttonDiv.appendChild(buttonLeft);
		buttonDiv.appendChild(document.createElement('BR'));
		
		var buttonAllLeft = document.createElement('INPUT');
		buttonAllLeft.style.marginTop='3px';
		buttonAllLeft.type='button';
		buttonAllLeft.value = '<<';
		buttonAllLeft.style.width = '25px';
		buttonAllLeft.className = "submit";
		buttonAllLeft.onclick = moveAllElements;
		buttonDiv.appendChild(buttonAllLeft);
		if (totalWidth) {
			buttonDiv.style.styleFloat = "left";
		}

		subDiv = document.createElement('DIV');
		if (totalWidth) {
			subDiv.style.width = '45%';
			toObj.style.width = '100%';
			subDiv.style.cssText = "width:45%;float:right";
		} else {
			subDiv.style.width = '90%';
			toObj.style.width = '90%';
			subDiv.style.cssText = "width:100%";
		}
		toObj.style.height = 130 + 'px';
		subDiv.style.styleFloat = "left";

		var label = document.createElement('SPAN');
		label.innerHTML = labelRight;
		subDiv.appendChild(label);
		subDiv.appendChild(document.createElement('BR'));
				
		subDiv.appendChild(toObj);
		parentDiv.appendChild(subDiv);		

		selectBoxIndex++;
	}
	
