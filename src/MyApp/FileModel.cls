Class MyApp.FileModel Extends %ZEN.DataModel.ObjectDataModel
{

Property FileId As %Integer;

Property FilePN As %String;

ClassMethod %OnDeleteSource(pID As %String) As %Status
{
	Quit ##class(MyApp.Files).%DeleteId(pID)
}

Method %OnLoadModel(pSource As MyApp.Files) As %Status
{
    Set ..FileId = pSource.FileId
    Set ..FilePN = pSource.FilePN
    Quit $$$OK
}

Method %OnNewSource(Output pSC As %Status = {$$$OK}) As %RegisteredObject
{
	Quit ##class(MyApp.Files).%New()
}

Method %OnOpenSource(pID As %String) As %RegisteredObject
{
	Quit ##class(MyApp.Files).%OpenId(pID)
}

Method %OnSaveSource(pSource As MyApp.Files) As %Status
{
	Set tSC = pSource.%Save()
	Set ..%id = pSource.%Id()
	Quit tSC
}

Method %OnStoreModel(pSource As MyApp.Files) As %Status
{
    Set pSource.FileId = ..FileId
    Set pSource.FilePN = ..FilePN
    Quit pSource.%Save()
}

}
