/*** Zen Module: MyApp_Components ***/

self._zenClassIdx['http://www.intersystems.com/MyApp/MenuComposite'] = 'MyApp_Components_MenuComposite';
self.MyApp_Components_MenuComposite = function(index,id) {
	if (index>=0) {MyApp_Components_MenuComposite__init(this,index,id);}
}

self.MyApp_Components_MenuComposite__init = function(o,index,id) {
	('undefined' == typeof _ZEN_Component_composite__init) ?zenMaster._ZEN_Component_composite__init(o,index,id):_ZEN_Component_composite__init(o,index,id);
}
function MyApp_Components_MenuComposite_serialize(set,s)
{
	var o = this;s[0]='4096323540';s[1]=o.index;s[2]=o.id;s[3]=o.name;s[4]=set.addObject(o.parent,'parent');s[5]=set.addObject(o.composite,'composite');s[6]=o.align;s[7]=o.aux;s[8]=o.cellAlign;s[9]=o.cellSize;s[10]=o.cellStyle;s[11]=o.cellVAlign;s[12]=set.serializeList(o,o.children,true,'children');s[13]=(o.childrenCreated?1:0);s[14]=o.containerStyle;s[15]=(o.disabled?1:0);s[16]=(o.dragEnabled?1:0);s[17]=(o.dropEnabled?1:0);s[18]=(o.dynamic?1:0);s[19]=o.enclosingClass;s[20]=o.enclosingStyle;s[21]=o.error;s[22]=o.groupClass;s[23]=o.groupStyle;s[24]=o.height;s[25]=(o.hidden?1:0);s[26]=o.hint;s[27]=o.hintClass;s[28]=o.hintStyle;s[29]=o.label;s[30]=o.labelClass;s[31]=o.labelDisabledClass;s[32]=o.labelPosition;s[33]=o.labelStyle;s[34]=o.layout;s[35]=o.onafterdrag;s[36]=o.onbeforedrag;s[37]=o.onclick;s[38]=o.ondrag;s[39]=o.ondrop;s[40]=o.onhide;s[41]=o.onrefresh;s[42]=o.onshow;s[43]=o.onupdate;s[44]=o.overlayMode;s[45]=o.renderFlag;s[46]=(o.showLabel?1:0);s[47]=o.slice;s[48]=o.title;s[49]=o.tuple;s[50]=o.valign;s[51]=(o.visible?1:0);s[52]=o.width;
}
function MyApp_Components_MenuComposite_getSettings(s)
{
	s['name'] = 'string';
	this.invokeSuper('getSettings',arguments);
}

self.MyApp_Components_MenuComposite_ReallyRefreshContents = function() {
	zenInstanceMethod(this,'ReallyRefreshContents','','',arguments);
}
self.MyApp_Components_MenuComposite__Loader = function() {
	zenLoadClass('_ZEN_Component_composite');
	MyApp_Components_MenuComposite.prototype = zenCreate('_ZEN_Component_composite',-1);
	var p = MyApp_Components_MenuComposite.prototype;
	if (null==p) {return;}
	p.constructor = MyApp_Components_MenuComposite;
	p.superClass = ('undefined' == typeof _ZEN_Component_composite) ? zenMaster._ZEN_Component_composite.prototype:_ZEN_Component_composite.prototype;
	p.__ZENcomponent = true;
	p._serverClass = 'MyApp.Components.MenuComposite';
	p._type = 'MenuComposite';
	p.serialize = MyApp_Components_MenuComposite_serialize;
	p.getSettings = MyApp_Components_MenuComposite_getSettings;
	p.ReallyRefreshContents = MyApp_Components_MenuComposite_ReallyRefreshContents;
}
/* EOF */
