/// Created using the page template: Default
Class MyApp.Hello Extends %ZEN.Component.page [ DependsOn = MyApp.Components.MenuComposite ]
{

/// Class name of application this page belongs to.
Parameter APPLICATION = "MyApp.Application";

/// Displayed name of this page.
Parameter PAGENAME;

/// Domain used for localization.
Parameter DOMAIN;

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">

/*fieldSet styles*/
.fieldset{
     background: #FFFFFF;
     border: solid 5px #C5D6D6;
     color: #000000;
     font-size: 1em;
     font-family: arial;
}
/*text control styles*/
.text
{  
    font-size: .8em;
    font-family: arial;
    color: #000000;
    background-color: #ffffff;
    padding: 2px;
    border: solid 1px grey;
    margin-right: 0px;
    margin-bottom: 0px;
    height: 25px;
}
/*dataCombo styles*/
.comboboxInput  {
    font-size: .8em;
    font-family: arial;
    color: #000000;  
    padding: 2px;
    border: solid 1px grey;
    margin-right: 0px;
    margin-bottom: 0px;
    height: 20px;
 }         

</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="Code Compare" xmlns:MyApp="http://www.intersystems.com/MyApp">
<MyApp:MenuComposite width="100%"/>
<hgroup width="100%">
<fieldSet id="fieldSet1" hidden="false" legend="File1">
<form id="form1" controllerId="file1" layout="horizontal" cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;">
<text label="File:" dataBinding="FilePN" id="FilePN1" name="FilePN1" size="60"/>
<button caption="Browse first file" onclick="zenPage.showPopupFile(1);" title="A demonstration of launching a popup window" />
</form>
</fieldSet>
<fieldSet id="fieldSet2" hidden="false" legend="File2">
<form id="form2" controllerId="file2" layout="horizontal" cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;">
<text label="File:" dataBinding="FilePN" id="FilePN2" name="FilePN2" size="60"/>
<button caption="Browse second file" onclick="zenPage.showPopupFile(2);" title="A demonstration of launching a popup window" />
</form>
</fieldSet>
</hgroup>

<vgroup width="50%">
<html id="title">Table of files:</html>
<dataController id="file1" modelClass="MyApp.FileModel" modelId=""/>
<dataController id="file2" modelClass="MyApp.FileModel" modelId=""/>
<dynaForm id="dform1" controllerId="file1"  hidden="true"/>
<button caption="New" hidden="true" onclick="zenPage.newFile1();" />
<button caption="Save" hidden="true" onclick="zenPage.saveFile1();" />
<tablePane id="files" sql="SELECT FileId,FilePN FROM MyApp.Files">
<column colName="FileId" hidden="true"/>
<column header="Choose" link="javascript:zenPage.showForm(1,'#(%query.FileId)#');" linkCaption="File1" width="5%" />
<column header="Choose" link="javascript:zenPage.showForm(2,'#(%query.FileId)#');" linkCaption="File2" width="5%" />
</tablePane>
</vgroup>
</page>
}

/// Create a new instance of the controller object
ClientMethod newFile1() [ Language = javascript ]
{
	var controller = zenPage.getComponentById('file1');
	controller.createNewObject();
}

ClientMethod onPopupAction(
	popupName,
	action,
	value) [ Language = javascript ]
{
	//alert(popupName);
  //var escape = item.replace(/\//g, '-');  // fix slashes in dates
  var escape1 = encodeURI(value);
  //alert(escape1);
  var escape2 = encodeURIComponent(value);  // fix % and more
  //alert(escape2);
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      //document.getElementById("div_debug").innerHTML += this.responseText;
    }
    if (this.readyState == 4 && this.status != 200) {
      //document.getElementById("div_debug").innerHTML += this.responseText;
    }
  };
  xhttp.open("POST", "/restAll/debug", true);
  //xhttp.open("POST", "/restapi/debug/" + escape + '/' + index, true, "_SYSTEM", "SYS");
  xhttp.send(value);
  if (popupName == 'FileSelectWindow1') {
  }
  	var table=zenPage.getComponentById('files');
	//refresh data in files table
	table.executeQuery();
}

/// Save the current instance of the controller object
ClientMethod saveFile1() [ Language = javascript ]
{
	var form = zenPage.getComponentById('form1');
	form.save();
	var table = zenPage.getComponentById('files');
	table.executeQuery();
}

ClientMethod showForm(
	form,
	file) [ Language = javascript ]
{
	var controller = zenPage.getComponentById('file' + form);
	controller.setProperty('modelId',file);
	var formGroup = zenPage.getComponentById('fieldSet' + form);
	formGroup.setProperty('hidden',false);
}

/// To use the fileSelect dialog to view the file system on the server,
///  the current user must hold USE privileges on one of the following resources:
///  %Admin_Manage, %Admin_Operate, %Admin_Security, or %Development.
ClientMethod showPopupFile(param) [ Language = javascript ]
{
	var pathname = '';
	var showdir = '0';
	zenPage.launchPopupWindow(
  '%ZEN.Dialog.fileSelect.cls?Dir=' + escape(pathname) +
  '&showdirectoryonly=' + showdir,
  'FileSelectWindow' + param,
  'status,scrollbars,resizable,width=660,height=700');
}

}
