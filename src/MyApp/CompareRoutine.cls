Class MyApp.CompareRoutine Extends %Persistent [ StorageStrategy = NewStorage1 ]
{

Index NewIndex1 On (CompareId, Routine) [ IdKey, Unique ];

Property CompareId As %Integer;

Property Routine As %String;

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
<Expression>-2</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Routine"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Routine}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^MyApp.CompareRoutineS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
