Class MyApp.Class Extends (%Persistent, %ZEN.DataModel.Adaptor) [ StorageStrategy = NewStorage1 ]
{

Index ClassIdIndex On (FileId, ClassName) [ IdKey, Unique ];

Property FileId As %Integer;

Property ClassName As %String;

Storage NewStorage1
{
<SQLMap name="Map1">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^ImportFile</Global>
<Subscript name="1">
<Expression>{FileId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>-1</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Class"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ClassName}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^MyApp.ClassS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
