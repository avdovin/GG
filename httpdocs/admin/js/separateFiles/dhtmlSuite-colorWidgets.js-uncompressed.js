if(!window.DHTMLSuite)var DHTMLSuite=new Object();/************************************************************************************************************
*	DHTML window scripts
*
*	Created:			January, 27th, 2006
*	@class Purpose of class:	Color palette
*
*	Css files used by this script:
*
*	Demos of this class:		demo-color-window-1.html
*
* 	Update log:
*
************************************************************************************************************/
/**
* @constructor
* @class 	This class simply creates a color palette
* @version 1.0
* @param colorProperties-associative array of palette properties, possible keys: width, callbackOnColorClick
* @author	Alf Magne Kalleland(www.dhtmlgoodies.com)
*
*	css file used for this widget: color-widget.css
*	Demo: (<a href="../../demos/demo-color-window-1.html" target="_blank">demo 1</a>)
**/

DHTMLSuite.colorPalette=function(propertyArray){
	var divElement;
	var layoutCSS;
	var colors;
	var colorHelper;
	var width;
	var callbackOnColorClick;
	var objectIndex;
	var currentColor;

	try{
	this.colorHelper=new DHTMLSuite.colorUtil();
	}catch(e){
	alert('You need to include dhtmlSuite-colorUtil.js');
	}
	this.layoutCSS='color-palette.css';
	this.colors=new Array();
	this.currentColor=new Object();

	if(propertyArray)this.__setInitProps(propertyArray);

	try{
	if(!standardObjectsCreated)DHTMLSuite.createStandardObjects();	
// This line starts all the init methods
	}catch(e){
	alert('You need to include the dhtmlSuite-common.js file');
	}
	this.objectIndex=DHTMLSuite.variableStorage.arrayDSObjects.length;
	DHTMLSuite.variableStorage.arrayDSObjects[this.objectIndex]=this;
}

DHTMLSuite.colorPalette.prototype =
{
	
// {{{ setCallbackOnColorClick()
	/**
	*Specify callback function executed when user clicks on a color. A callback function cal also be specified in the constructor.
	 *
	*@public
	 */
	setCallbackOnColorClick:function(functionName){
	this.callbackOnColorClick=functionName;
	}
	
// }}}
	,
	
// {{{ __setInitProps()
	/**
	*Save initial palette properties sent to the constructor
	 *
	*@private
	 */
	__setInitProps:function(propertyArray){
	if(propertyArray.width){
		propertyArray.width=propertyArray.width+'';
		if(propertyArray.width.match(/^[^0-9]*?$/)){
		propertyArray.width=propertyArray.width+'px';
		}
		this.width=propertyArray.width;
	}
	if(propertyArray.callbackOnColorClick)this.callbackOnColorClick=propertyArray.callbackOnColorClick;
	}
	
// }}}
	,
	
// {{{ addAllWebColors()
	/**
	*Add all 216 web colors to the palette.
	 *
	*@public
	 */
	addAllWebColors:function(){
	var colors=this.colorHelper.getAllWebColors();
	for(var no=0;no<colors.length;no++){
		this.colors[this.colors.length]=['#'+colors[no],'#'+colors[no]];

	}

	}
	
// }}}
	,
	
// {{{ addAllNamedColors()
	/**
	*Add all named colors to the palette
	 *
	*@public
	 */
	addAllNamedColors:function(){
	var colors=this.colorHelper.getAllNamedColors();
	for(var no=0;no<colors.length;no++){
		this.colors[this.colors.length]=['#'+colors[no][1],colors[no][0]];
	}

	}
	
// }}}
	,
	
// {{{ addGrayScaleColors()
	/**
	*Add gray scale colors to the palette
	 *
	 *	@param Int numberOfColors-Number of colors to add
	 *	@param Int rangeFrom-Optional parameter between 0 and 255(default is 0)
	 *	@param Int rangeTo-Optional parameter between 0 and 255 ( default is 255)
	*@public
	 */
	addGrayScaleColors:function(numberOfColors,rangeFrom,rangeTo){
	if(!numberOfColors)numberOfColors=16;
	if(!rangeFrom)rangeFrom=0;
	if(!rangeTo)rangeTo=255;
	if(rangeFrom>rangeTo){
		var tmpRange=rangeFrom;
		rangeFrom=rangeTo;
		rangeTo=tmpRange;
	}
	var step=(rangeTo-rangeFrom)/ numberOfColors;
	for(var no=rangeFrom;no<=rangeTo;no+=step){
		var color=this.colorHelper.baseConverter(Math.round(no),10,16)+'';
		while(color.length<2)color='0'+color;
		this.colors[this.colors.length]=['#'+color+color+color,'#'+color+color+color];
	}
	}
	
// }}}
	,
	
// {{{ addColor()
	/**
	*Add a single color to the palette
	 *
	 *	@param String color-Rgb code of color, example. #FF0000
	 *	@param String name-Name of color (optional parameter)
	 *
	*@public
	 */
	addColor:function(color,name){
	if(!name)name=color;
	this.colors[this.colors.length]=[color,name];
	}
	
// }}}
	,
	
// {{{ setLayoutCss()
	/**
	*Specify name of css file.
	 *
	 *	@param String cssFileName-Name of css file. path will be the config path+this name.(DHTMLSuite.configObj.cssPath)
	 *
	 *
	*@public
	 */
	setLayoutCss:function(cssFileName){
	this.layoutCSS=cssFileName;
	}
	
// }}}
	,
	
// {{{ getDivElement()
	/**
	*Returns a reference to the div element for this widget.
	 *
	 *	@return Object DivElement-Reference to div element.
	 *
	 *
	*@public
	 */
	getDivElement:function(){
	return this.divElement;
	}
	
// }}}
	,
	
// {{{ init()
	/**
	*Initializes the widget. Call this method after all colors has been added to the palette.
	 *
	 *
	*@public
	 */
	init:function(){
	DHTMLSuite.commonObj.loadCSS(this.layoutCSS);
	this.__createMainDivEl();
	this.__createColorDivs();
	}
	
// }}}
	,
	
// {{{ __createMainDivEl()
	/**
	*Create main div element for the widget.
	 *
	*@private
	 */
	__createMainDivEl:function(){
	this.divElement=document.createElement('DIV');
	this.divElement.className='DHTMLSuite_colorPalette';
	if(this.width){
		this.divElement.style.width=this.width;
	}
	}
	
// }}}
	,
	
// {{{ __createColorDivs()
	/**
	*Create small color divs for the widget.
	 *
	*@private
	 */
	__createColorDivs:function(){
	var ind=this.objectIndex;
	for(var no=0;no<this.colors.length;no++){
		var div=document.createElement('DIV');
		div.className='DHTMLSuite_colorPaletteColor';
		div.setAttribute('rgb',this.colors[no][0]);
		try{
		div.style.backgroundColor=this.colors[no][0];
		}catch(e){
		div.style.display='none';
		}
		div.onclick=function(e){ DHTMLSuite.variableStorage.arrayDSObjects[ind].__clickOnColor(e); };
		DHTMLSuite.commonObj.__addEventEl(div)
		div.title=this.colors[no][1];
		this.divElement.appendChild(div);

	}
	var clearDiv=document.createElement('DIV');
	clearDiv.style.clear='both';
	this.divElement.appendChild(clearDiv);
	}
	
// }}}
	,
	
// {{{ __clickOnColor()
	/**
	*Called when users clicks on a color
	 *	@param Event e-Event object-used to get a reference to the clicked color div.
	 *
	*@private
	 */
	__clickOnColor:function(e){
	if(document.all)e=event;
	var src=DHTMLSuite.commonObj.getSrcElement(e);

	this.currentColor.rgb=src.getAttribute('rgb');
	if(!this.currentColor.rgb)this.currentColor.rgb=src.rgb;
	this.currentColor.name=src.title;
	this.__handleCallback('colorClick');

	}
	
// }}}
	,
	
// {{{ __handleCallback()
	/**
	*Handle call back actions.
	 *	@param String Action-Callback action to execute
	 *
	*@private
	 */
	__handleCallback:function(action){
	var callbackString='';
	switch(action){
		case "colorClick":
		if(this.callbackOnColorClick)callbackString=this.callbackOnColorClick;
		break;

	}

	if(callbackString){
		callbackString=callbackString+'({ rgb:this.currentColor.rgb, name:this.currentColor.name})';
		eval(callbackString);
	}
	}
}

/**
* @constructor
* @class This is a color slider class
* @version 1.0
* @param Array properties-Possible keys:
*
*
*	css file used for this widget: color-widget.css
*	Demo: (<a href="../../demos/demo-color-window-1.html" target="_blank">demo 1</a>)
* @author	Alf Magne Kalleland(www.dhtmlgoodies.com)
**/

DHTMLSuite.colorSlider=function(propertyArray){
	var divElement;
	var layoutCSS;
	var colorHelper;	
// Object of class DHTMLSuite.colorUtil

	var currentRgb;
	var currentRed;
	var currentGreen;
	var currentBlue;
	var objectIndex;
	var frmFieldRed;
	var frmFieldGreen;
	var frmFieldBlue;
	var callbackOnChangeRgb;

	this.currentRgb='FF0000';
	this.currentRed=255;
	this.currentBlue=0;
	this.currentGreen=0;

	this.currentRedHex='FF';
	this.currentGreenHex='00';
	this.currentBlueHex='00';

	this.layoutCSS='color-slider.css';
	try{
	if(!standardObjectsCreated)DHTMLSuite.createStandardObjects();	
// This line starts all the init methods
	}catch(e){
	alert('You need to include the dhtmlSuite-common.js file');
	}

	try{
	this.colorHelper=new DHTMLSuite.colorUtil();
	}catch(e){
	alert('You need to include dhtmlSuite-colorUtil.js');
	}

	this.objectIndex=DHTMLSuite.variableStorage.arrayDSObjects.length;
	DHTMLSuite.variableStorage.arrayDSObjects[this.objectIndex]=this;

	if(propertyArray)this.__setInitProps(propertyArray);
}

DHTMLSuite.colorSlider.prototype =
{
	
// {{{ __setInitProps()
	/**
	*Handle call back actions.
	*@param Array props-Array of properties
	 *
	*@private
	 */
	__setInitProps:function(props){
	if(props.callbackOnChangeRgb)this.callbackOnChangeRgb=props.callbackOnChangeRgb;
	}
	
// }}}
	,
	
// {{{ init()
	/**
	*Initializes the script
	 *
	*@public
	 */
	init:function(){
	DHTMLSuite.commonObj.loadCSS(this.layoutCSS);
	this.__createMainDivEl();
	this.__createDivPreview();
	this.__createSliderDiv();
	this.__createColorDiv();
	this.__setPreviewDivBgColor();
	}
	
// }}}
	,
	
// {{{ setRgbColor()
	/**
	*Set new rgb code
	 *
	 *	@param String rgbCode-New RGB code in the format RRGGBB
	 *
	*@public
	 */
	setRgbColor:function(rgbCode){
	rgbCode=rgbCode+'';
	rgbCode=rgbCode.replace(/[^0-9A-F]/gi,'');
	if(rgbCode.length!=6)return false;
	this.currentRgb=rgbCode;
	this.__setParamsFromCurrentRgb();
	try{
		this.__updateSliderHandles();
		this.__updateFormFields();
		this.__setPreviewDivBgColor();
	}catch(e){
		
// Widget not yet initialized by the init()method
	}
	}
	
// }}}
	,
	
// {{{ getDivElement()
	/**
	*Return a reference to the main div element for this widget. you can use appendChild()to append it to an element on your web page.
	 *	example: document.body.appendChild(colorSlider.getDivElement()).
	 *
	 *	@return Object divElement-Reference to div element for this widget
	 *
	*@public
	 */
	getDivElement:function(){
	return this.divElement;
	}
	
// }}}
	,
	
// {{{ __createMainDivEl()
	/**
	*Create main div element for the widget. This is the top most parent div.
	 *
	*@private
	 */
	__createMainDivEl:function(){
	this.divElement=document.createElement('DIV');
	this.divElement.className='DHTMLSuite_colorSlider';
	}
	
// }}}
	,
	
// {{{ __createDivPreview()
	/**
	*Create color preview div.
	 *
	*@private
	 */
	__createDivPreview:function(){
	var div=document.createElement('DIV');
	div.className='DHTMLSuite_colorSliderPreviewParent';
	this.divPreview=document.createElement('DIV');
	this.divPreview.className='DHTMLSuite_colorSliderPreview';
	div.appendChild(this.divPreview);
	this.divElement.appendChild(div);
	}
	
// }}}
	,
	
// {{{ __createSliderDiv()
	/**
	*Create divs for the sliders.
	 *
	*@private
	 */
	__createSliderDiv:function(){
	var ind=this.objectIndex;

	var div=document.createElement('DIV');
	div.className='DHTMLSuite_colorSliderSliderParent';
	this.divElement.appendChild(div);

	
// Red slider
	var divRed=document.createElement('DIV');
	divRed.className='DHTMLSuite_colorSliderSliderColorRow';
	div.appendChild(divRed);

	var labelDiv=document.createElement('DIV');
	labelDiv.className='DHTMLSuite_colorSliderSliderLabelDiv';
	labelDiv.innerHTML='R';
	divRed.appendChild(labelDiv);

	var sliderDiv=document.createElement('DIV');
	sliderDiv.className='DHTMLSuite_colorSliderSlider';
	divRed.appendChild(sliderDiv);
	try{
		var sliderObj=new DHTMLSuite.slider();
	}catch(e){
		alert('Error-you need to include dhtmlSuite-slider.js');
	}
	sliderObj.setSliderTarget(sliderDiv);
	sliderObj.setSliderWidth(240);
	sliderObj.setOnChangeEvent('DHTMLSuite.variableStorage.arrayDSObjects['+ind+'].__receiveRedFromSlider');
	sliderObj.setSliderName('red');
	sliderObj.setInitialValue(this.currentRed);
	sliderObj.setSliderMaxValue(255);
	sliderObj.init();
	this.sliderObjRed=sliderObj;

	var inputDiv=document.createElement('DIV');
	inputDiv.className='DHTMLSuite_colorSliderSliderInputDiv';
	this.frmFieldRed=document.createElement('INPUT');
	this.frmFieldRed.value=this.currentRed;
	this.frmFieldRed.maxLength=3;
	inputDiv.appendChild(this.frmFieldRed);
	divRed.appendChild(inputDiv);
	this.frmFieldRed.onchange=function(e){ DHTMLSuite.variableStorage.arrayDSObjects[ind].__receiveRedFromForm(e); };
	DHTMLSuite.commonObj.__addEventEl(this.frmFieldRed);

	
// Green slider
	var divGreen=document.createElement('DIV');
	divGreen.className='DHTMLSuite_colorSliderSliderColorRow';
	div.appendChild(divGreen);

	var labelDiv=document.createElement('DIV');
	labelDiv.className='DHTMLSuite_colorSliderSliderLabelDiv';
	labelDiv.innerHTML='G';
	divGreen.appendChild(labelDiv);

	var sliderDiv=document.createElement('DIV');
	sliderDiv.className='DHTMLSuite_colorSliderSlider';
	divGreen.appendChild(sliderDiv);

	var sliderObj=new DHTMLSuite.slider();
	sliderObj.setSliderTarget(sliderDiv);
	sliderObj.setSliderWidth(240);
	sliderObj.setOnChangeEvent('DHTMLSuite.variableStorage.arrayDSObjects['+ind+'].__receiveGreenFromSlider');
	sliderObj.setSliderName('green');
	sliderObj.setInitialValue(this.currentGreen);
	sliderObj.setSliderMaxValue(255);
	sliderObj.init();
	this.sliderObjGreen=sliderObj;

	var inputDiv=document.createElement('DIV');
	inputDiv.className='DHTMLSuite_colorSliderSliderInputDiv';
	this.frmFieldGreen=document.createElement('INPUT');
	this.frmFieldGreen.value=this.currentGreen;
	this.frmFieldGreen.maxLength=3;
	inputDiv.appendChild(this.frmFieldGreen);
	divGreen.appendChild(inputDiv);
	this.frmFieldGreen.onchange=function(e){ DHTMLSuite.variableStorage.arrayDSObjects[ind].__receiveGreenFromForm(e); };
	DHTMLSuite.commonObj.__addEventEl(this.frmFieldGreen);

	
// Blue slider
	var divBlue=document.createElement('DIV');
	divBlue.className='DHTMLSuite_colorSliderSliderColorRow';
	div.appendChild(divBlue);

	var labelDiv=document.createElement('DIV');
	labelDiv.className='DHTMLSuite_colorSliderSliderLabelDiv';
	labelDiv.innerHTML='B';
	divBlue.appendChild(labelDiv);

	var sliderDiv=document.createElement('DIV');
	sliderDiv.className='DHTMLSuite_colorSliderSlider';
	divBlue.appendChild(sliderDiv);

	var sliderObj=new DHTMLSuite.slider();
	sliderObj.setSliderTarget(sliderDiv);
	sliderObj.setSliderWidth(240);
	sliderObj.setOnChangeEvent('DHTMLSuite.variableStorage.arrayDSObjects['+ind+'].__receiveBlueFromSlider');
	sliderObj.setSliderName('blue');
	sliderObj.setInitialValue(this.currentBlue);
	sliderObj.setSliderMaxValue(255);
	sliderObj.init();
	this.sliderObjBlue=sliderObj;

	var inputDiv=document.createElement('DIV');
	inputDiv.className='DHTMLSuite_colorSliderSliderInputDiv';
	this.frmFieldBlue=document.createElement('INPUT');
	this.frmFieldBlue.value=this.currentBlue;
	this.frmFieldBlue.maxLength=3;
	this.frmFieldBlue.onchange=function(e){ DHTMLSuite.variableStorage.arrayDSObjects[ind].__receiveBlueFromForm(e); };
	DHTMLSuite.commonObj.__addEventEl(this.frmFieldBlue);
	inputDiv.appendChild(this.frmFieldBlue);
	divBlue.appendChild(inputDiv);

	}
	
// }}}
	,
	
// {{{ __getValidatedFormVar()
	/**
	*Return form variable(red,green or blue)from event
	 *
	 *	@param Event e-Reference to the Event object.
	*@private
	 */
	__getValidatedFormVar:function(e){
	var src=DHTMLSuite.commonObj.getSrcElement(e);
	var val=src.value;
	val=val.replace(/[^0-9]/gi,'');
	if(!val)val=0;
	val=val/1;
	if(val<0)val=0;
	if(val>255)val=255;
	return val;
	}
	,
	
// {{{ __receiveRedFromForm()
	/**
	*Receive color from the red text input.
	 *	@param Event e-Reference to the Event object
	 *
	*@private
	 */
	__receiveRedFromForm:function(e){
	if(document.all)e=event;
	this.currentRed=this.__getValidatedFormVar(e);
	this.currentRedHex=this.colorHelper.baseConverter(this.currentRed,10,16)+'';
	while(this.currentRedHex.length<2)this.currentRedHex='0'+this.currentRedHex;
	this.currentRgb=this.currentRedHex+this.currentGreenHex+this.currentBlueHex;
	this.__updateSliderHandles();
	this.__updateFormFields();
	this.__setPreviewDivBgColor();
	}
	
// }}}
	,
	
// {{{ __receiveGreenFromForm()
	/**
	*Receive color from the green text input.
	 *
	*@private
	 */
	__receiveGreenFromForm:function(e){
	if(document.all)e=event;
	this.currentGreen=this.__getValidatedFormVar(e);
	this.currentGreenHex=this.colorHelper.baseConverter(this.currentGreen,10,16)+'';
	while(this.currentGreenHex.length<2)this.currentGreenHex='0'+this.currentGreenHex;
	this.currentRgb=this.currentRedHex+this.currentGreenHex+this.currentBlueHex;
	this.__updateSliderHandles();
	this.__updateFormFields();
	this.__setPreviewDivBgColor();
	}
	
// }}}
	,
	
// {{{ __receiveBlueFromForm()
	/**
	*Receive blue color from form.
	 *
	*@private
	 */
	__receiveBlueFromForm:function(e){
	if(document.all)e=event;
	this.currentBlue=this.__getValidatedFormVar(e);
	this.currentBlueHex=this.colorHelper.baseConverter(this.currentBlue,10,16)+'';
	while(this.currentBlueHex.length<2)this.currentBlueHex='0'+this.currentBlueHex;
	this.currentRgb=this.currentRedHex+this.currentGreenHex+this.currentBlueHex;
	this.__updateSliderHandles();
	this.__updateFormFields();
	this.__setPreviewDivBgColor();
	}
	
// }}}
	,
	
// {{{ __createColorDiv()
	/**
	*Create color div at the bottom, the div users can click on in order to select a color.
	 *
	*@private
	 */
	__createColorDiv:function(){
	var ind=this.objectIndex;
	var div=document.createElement('DIV');
	div.className='DHTMLSuite_colorSliderRgbBgParent';
	this.divElement.appendChild(div);
	this.colorDiv=document.createElement('DIV');
	this.colorDiv.className='DHTMLSuite_colorSliderRgbBg';
	div.appendChild(this.colorDiv);
	DHTMLSuite.commonObj.addEvent(this.colorDiv,'click',function(e){ DHTMLSuite.variableStorage.arrayDSObjects[ind].__clickOnRgbBg(e); });
	}
	
// }}}
	,
	
// {{{ __setPreviewDivBgColor()
	/**
	*Update the background color of the preview div..
	 *
	*@private
	 */
	__setPreviewDivBgColor:function(){
	try{
		this.divPreview.style.backgroundColor='#'+this.currentRgb;
		this.__handleCallback('rgbChange');
	}catch(e){
		alert(this.currentRgb);
	}
	}
	
// }}}
	,
	
// {{{ __setParamsFromCurrentRgb()
	/**
	*Save properties by parsing rgbCode
	 *
	*@private
	 */
	__setParamsFromCurrentRgb:function(){
	this.currentRedHex=this.currentRgb.substr(0,2);
	this.currentGreenHex=this.currentRgb.substr(2,2);
	this.currentBlueHex=this.currentRgb.substr(4,2);
	this.currentRed=this.colorHelper.baseConverter(this.currentRedHex,16,10);
	this.currentGreen=this.colorHelper.baseConverter(this.currentGreenHex,16,10);
	this.currentBlue=this.colorHelper.baseConverter(this.currentBlueHex,16,10);
	}
	
// }}}
	,
	
// {{{ __clickOnRgbBg()
	/**
	*Click event on the color gradient at the bottom.
	 *	@param Object e-reference to the Event object.
	 *
	*@private
	 */
	__clickOnRgbBg:function(e){
	var left=DHTMLSuite.commonObj.getLeftPos(this.colorDiv);
	var top=DHTMLSuite.commonObj.getTopPos(this.colorDiv);
	if(document.all)e=event;

	var width=350;
	var height=20;
	var y=e.clientY-top;
	var x=e.clientX-left-1;
	if(e.layerX){ 
// For those browsers who supports layerX, example: Firefox.
		x=e.layerX;
		y=e.layerY;
	}
	if(y>height)y=height;
	if(x<=350){
		this.currentRgb=this.__getHorizColor(y*width+x-1, width, height);
		this.__setParamsFromCurrentRgb();
	}else{
		this.currentRgb='000000';
		this.currentRedHex='00';
		this.currentGreenHex='00';
		this.currentBlueHex='00';
		this.currentRed=0;
		this.currentGreen=0;
		this.currentBlue=0;
	}
	this.__updateSliderHandles();
	this.__updateFormFields();
	this.__setPreviewDivBgColor();
	}
	
// }}}
	,
	
// {{{ __updateSliderHandles()
	/**
	* Users has clicked on color bar at the bottom or changed the values of the inputs->Update position of sliders.
	 *
	*@private
	 */
	__updateSliderHandles:function(){
	this.sliderObjRed.setSliderValue(this.currentRed);
	this.sliderObjGreen.setSliderValue(this.currentGreen);
	this.sliderObjBlue.setSliderValue(this.currentBlue);
	}
	
// }}}
	,
	
// {{{ __updateFormFields()
	/**
	* Update values of form fields
	 *
	*@private
	 */
	__updateFormFields:function(){
	this.frmFieldRed.value=this.currentRed;
	this.frmFieldGreen.value=this.currentGreen;
	this.frmFieldBlue.value=this.currentBlue;
	}
	
// }}}
	,
	
// {{{ __receiveRedFromSlider()
	/**
	* Receive red color from slider
	 *	@param Integer value-New red value(0-255)
	 *
	*@private
	 */
	__receiveRedFromSlider:function(value){
	this.frmFieldRed.value=value;
	this.currentRed=value;
	this.currentRedHex=this.colorHelper.baseConverter(value,10,16)+'';
	if(this.currentRedHex.length==1)this.currentRedHex='0'+this.currentRedHex;
	this.currentRgb=this.currentRedHex+this.currentGreenHex+this.currentBlueHex;
	this.__setPreviewDivBgColor();
	}
	
// }}}
	,
	
// {{{ __receiveGreenFromSlider()
	/**
	* Receive green color from slider
	 *	@param Integer value-New green value(0-255)
	 *
	*@private
	 */
	__receiveGreenFromSlider:function(value){
	this.frmFieldGreen.value=value;
	this.currentGreen=value;
	this.currentGreenHex=this.colorHelper.baseConverter(value,10,16)+'';
	if(this.currentGreenHex.length==1)this.currentGreenHex='0'+this.currentGreenHex;
	this.currentRgb=this.currentRedHex+this.currentGreenHex+this.currentBlueHex;
	this.__setPreviewDivBgColor();
	}
	
// }}}
	,
	
// {{{ __receiveBlueFromSlider()
	/**
	* Receive blue color from slider
	 *	@param Integer value-New green value(0-255)
	 *
	*@private
	 */
	__receiveBlueFromSlider:function(value){
	this.frmFieldBlue.value=value;
	this.currentBlue=value;
	this.currentBlueHex=this.colorHelper.baseConverter(value,10,16)+'';
	if(this.currentBlueHex.length==1)this.currentBlueHex='0'+this.currentBlueHex;
	this.currentRgb=this.currentRedHex+this.currentGreenHex+this.currentBlueHex;
	this.__setPreviewDivBgColor();
	}
	
// }}}
	,
	
// {{{ ____getHorizColor()
	/**
	 /* This function is from the great article at http:
//www.webreference.com/programming/javascript/mk/column3/index.html
	 *
	* Click events on color bar -> this method returns the correct color based on where the mouse was on the bar
	 *
	 *	@param Integer i-Combination of x and y position on the bar
	 *	@param Integer width-Width of bar
	 *	@param Integer height-Height of bar
	 *
	*@private
	 */
	__getHorizColor:function (i, width, height){
	var sWidth=(width)/7;	 
// "section" width
	var C=i%width;		  
// column
	var R=Math.floor(i/(sWidth*7)); 
// row
	var c=i%sWidth;		 
// column in current group
	var r, g, b, h;

	var l=(255/sWidth)*c;		
// color percentage

	if(C>=sWidth*6){
		r=g=b=255-l;
	} else {
		h=255-l;
		r=C<sWidth?255:C<sWidth*2?h:C<sWidth*4?0:C<sWidth*5?l:255;
		g=C<sWidth?l:C<sWidth*3?255:C<sWidth*4?h:0;
		b=C<sWidth*2?0:C<sWidth*3?l:C<sWidth*5?255:h;
		if(R<(height/2)){
		var base=255-(255*2/height)*R;
		r=base+(r*R*2/height);
		g=base+(g*R*2/height);
		b=base+(b*R*2/height);
		}else if(R>(height/2)){
		var base=(height-R)/(height/2);
		r=r*base;
		g=g*base;
		b=b*base;
		}
	}
	var red=this.colorHelper.baseConverter(r,10,16)+'';
	if(red.length=='1')red='0'+red;
	var green=this.colorHelper.baseConverter(g,10,16)+'';
	if(green.length=='1')green='0'+green;
	var blue=this.colorHelper.baseConverter(b,10,16)+'';
	if(blue.length=='1')blue='0'+blue;
	return red+green+blue;

	}
	
// }}}
	,
	
// {{{ __handleCallback()
	/**
	* Handle callback
	 *	@param String action-Action to execute
	 *
	*@private
	 */
	__handleCallback:function(action){
	var callbackString='';
	switch(action){
		case "rgbChange":
		if(this.callbackOnChangeRgb)callbackString=this.callbackOnChangeRgb;
		break;
	}
	if(callbackString){
		var rgb=this.currentRgb.toUpperCase();
		callbackString=callbackString+'({ rgb:"#'+rgb+'",name:"#'+rgb+'"})';
		return eval(callbackString);
	}
	}
}
