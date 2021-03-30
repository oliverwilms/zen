/// Created using the page template: Default
Class MyApp.Hello Extends %ZEN.Component.page [ Language = objectscript ]
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
</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="">
<button caption="Initiate Conversation"
        onclick="zenPage.showPopupFile();"
        title="A demonstration of launching a popup window" />
</page>
}

ClientMethod onPopupAction(
	popupName,
	action,
	value) [ Language = javascript ]
{
  //alert('User entered: ' + value);
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
}

/// To use the fileSelect dialog to view the file system on the server,
///  the current user must hold USE privileges on one of the following resources:
///  %Admin_Manage, %Admin_Operate, %Admin_Security, or %Development.
ClientMethod showPopupFile() [ Language = javascript ]
{
var pathname = '';
var showdir = '0';
zenPage.launchPopupWindow(
  '%ZEN.Dialog.fileSelect.cls?Dir=' + escape(pathname) +
  '&showdirectoryonly=' + showdir,
  'FileSelectWindow',
  'status,scrollbars,resizable,width=660,height=700');
}

}
