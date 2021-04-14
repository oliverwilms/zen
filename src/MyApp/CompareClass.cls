Class MyApp.CompareClass Extends %Persistent [ StorageStrategy = NewStorage1 ]
{

Index NewIndex1 On (CompareId, ClassName) [ IdKey, Unique ];

Property CompareId As %Integer;

Property ClassName As %String;

Property StatusText As %String;

Storage NewStorage1
{
<SQLMap name="Map1">
<Data name="StatusText">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CompareFiles</Global>
<Subscript name="1">
<Expression>{CompareId}</Expression>
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
<StreamLocation>^MyApp.CompareClassS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
