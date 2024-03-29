Class MyApp.REST Extends %CSP.REST
{

Parameter UseSession As Integer = 1;

Parameter HandleCorsRequest = 1;

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/debug" Method="GET" Call="GetDebug" />
<Route Url="/debug" Method="POST" Call="PostDebug" />
<Route Url="/debug/:debug" Method="POST" Call="PostDebug" />
<Route Url="/debug/:debug/:index" Method="POST" Call="PostDebug" />
<Route Url="/click/:what/:which" Method="POST" Call="DebugClick" />
<Route Url="/sql/:query" Method="POST" Call="PostSQL" />
</Routes>
}

ClassMethod DebugTEST(strMessage As %String = "") As %Status
{
	Set ^TESTunit($I(^TESTunit)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : "_strMessage
	Quit $$$OK
}

ClassMethod StatusToText(pStatus As %Status) As %String
{
	Set tReturn = $System.Status.GetOneErrorText(pStatus)
	Quit tReturn
}

ClassMethod DebugStatus(pStatus As %Status) As %Status
{
	Set tStatus = ..StatusToText(pStatus)
	Quit ..DebugTEST(tStatus)
}

ClassMethod DebugClick(
	pDebug As %String = "",
	pIndex As %String = -1) As %Status
{
	Set tSC = $$$OK
	Try {
		Do ..DebugTEST("MyApp.REST - DebugClick")
		Do ..DebugTEST("pDebug = "_pDebug)
		Do ..DebugTEST("pIndex = "_pIndex)
		Set tIncrement = $Increment(^restAllDEBUG)
		Set ^restAllDEBUG(tIncrement) = pDebug_","_ pIndex
	} Catch {
		Set tSC = $$$ERROR($$$GeneralError,"Error")
	}
	Quit tSC
}

ClassMethod GetDebug() As %Status
{
	Do ..DebugTEST("MyApp.REST - GetDebug")
	Set tBaseLogId = 0
	Set tBaseLogId = 1 + tBaseLogId
	Do ..DebugTEST("tBaseLogId = "_tBaseLogId)
	Set data = {}
	Set data.BaseLogId = tBaseLogId
	Write data.%ToJSON()
	Quit $$$OK
}

ClassMethod PostDebug(
	pDebug As %String = "",
	pIndex As %String = -1) As %Status
{
	Do ..DebugTEST("MyApp.REST - PostDebug")
	Do ..DebugTEST("pDebug = "_pDebug)
	Do ..DebugTEST("pIndex = "_pIndex)
	Set tIncrement = $Increment(^RichesDEBUG)
	#dim tContent As %CSP.BinaryStream
	Set tContent = %request.Content
	Set pDebug = tContent.Read(.tLen,.tSC)
	Do ..DebugTEST("pDebug = "_pDebug)
	If ($Extract(pDebug,*) = $Char(13)) Set pDebug = $Extract(pDebug,1,*-1)
	Set ^RichesDEBUG(pIndex,tIncrement) = pIndex_","_ pDebug
	Set tSC = ..ReadFile(pDebug)
	Quit $$$OK
}

/// Insert into Riches.Transact (Account,TranDate,Merchant,Category,AmountDebit,AmountCredit) values ('Chase Better Banking Checking','1-3-2021','Aldi','Groceries','51.41','')
/// %Message = Field 'Riches.Transact.AmountCredit' (value <EMPTY STRING>) failed validation
/// 				Field 'Riches.Transact.TranDate' (value '1-3-2021') failed validation
ClassMethod PostSQL(
	pQuery As %String = "",
	pIndex As %String = -1) As %Status
{
	Do ..DebugTEST("MyApp.REST - PostSQL")
	Do ..DebugTEST("pQuery = "_pQuery)
	Do ..DebugTEST("pIndex = "_pIndex)
	Set tSC = ..TestQuery(pQuery,.pQuery)
	Do ..DebugTEST("TestQuery = "_pQuery)
	Set tStatement = ##class(%SQL.Statement).%New()
	Set tSC = tStatement.%Prepare(pQuery)
	If $$$ISERR(tSC) {
		Do ..DebugStatus(tSC)
		Write "%Prepare failed:"
		Do $System.Status.DisplayError(tSC) QUIT
	} Else {
		#Dim rset As %SQL.StatementResult
		// Execute the current statement and return the result. The result of the execute is always the return value.
		// Success/Failure information is reported in the result object as %SQLCODE, %Message, %ROWCOUNT, and/or %ROWID.
		Set rset = tStatement.%Execute()
		Do ..DebugTEST("%SQLCODE = "_rset.%SQLCODE)
		Do ..DebugTEST("%Message = "_rset.%Message)
		Do ..DebugTEST("%ROWID = "_rset.%ROWID)
	}
	Quit tSC
}

ClassMethod ReadFile(pFile As %String = "") As %Status
{
	Set tSC = $$$OK
	If (pFile = "") Quit tSC
	Set tIncrement = $Increment(^ImportFile)
	Set ^ImportFile(tIncrement) = pFile
	Set timeout = 300
	Open pFile:("R"):timeout  // read
	If ($TEST = 0) {
		Set tSC = $$$ERROR($$$GeneralError,"Unable to open "_pFile)
		Quit tSC
	}
	Try {
		Use pFile
		For {
			Read input
			Set tLine = $Increment(^ImportFile(tIncrement,0))
			Set ^ImportFile(tIncrement,tLine) = input
		}
		Close pFile
	} Catch {
		Close pFile
	}
	JOB ##class(MyApp.Files).AnalyzeFile(tIncrement)
	Quit $$$OK
}

ClassMethod TestQuery(
	pQuery As %String = "",
	Output pQuery2 As %String) As %Status
{
	Do ..DebugTEST("MyApp.REST - TestQuery")
	Do ..DebugTEST("pQuery = "_pQuery)
	Set tCOMMAND = $ZCONVERT($Piece(pQuery," ",1),"U")
	Do ..DebugTEST("tCOMMAND = "_tCOMMAND)
	Set tPIECE2 = $ZCONVERT($Piece(pQuery," ",2),"U")
	Do ..DebugTEST("tPIECE2 = "_tPIECE2)
	If (tCOMMAND = "INSERT"),(tPIECE2 = "INTO") {
		Set tTable = $Piece(pQuery," ",3)
		Do ..DebugTEST("tTable = "_tTable)
		Set tPiece4 = $Piece(pQuery," ",4)
		Do ..DebugTEST("tPiece4 = "_tPiece4)
		Set tPIECE5 = $ZCONVERT($Piece(pQuery," ",5),"U")
		Do ..DebugTEST("tPIECE5 = "_tPIECE5)
		If (tPIECE5 = "VALUES") {
			Set tColumns = tPiece4
			Do ..DebugTEST("tColumns = "_tColumns)
			Set tCOLUMNS = $ZCONVERT(tColumns,"U")
			Do ..DebugTEST("tCOLUMNS = "_tCOLUMNS)
			Set tParValues = $Piece(pQuery," ",6,999)
			If ($Extract(tParValues,1) = "("),($Extract(tParValues,*) = ")") {
				Set tValues = $Extract(tParValues,2,*-1)
			}
			Set tValues = $Get(tValues,tParValues)
			Do ..DebugTEST("tValues = "_$Get(tValues,tParValues))
			If (tCOLUMNS [ "DATE") {
				Set tLength = $Length(tColumns,",")
				Do ..DebugTEST("tLength = "_tLength)
				For ii = 1:1:tLength {
					Do ..DebugTEST("ii = "_ii)
					Set tCNAME = $Piece(tCOLUMNS,",",ii)
					If (tCNAME [ "AMOUNT") {
						Set tValue = $Piece(tValues,",",ii)
						Do ..DebugTEST("tValue = "_tValue)
						Set tSC = ..UnQuote(tValue,.tAValue)
						If ($Get(tAValue) = "") {
							Set tAmount = 0
							Do ..DebugTEST("tAmount = "_$Get(tAmount))
							Set $Piece(tValues,",",ii) = $Get(tAmount)
							Do ..DebugTEST("tValues = "_tValues)
						}
					}
					If (tCNAME [ "DATE") {
						Set tValue = $Piece(tValues,",",ii)
						Do ..DebugTEST("tValue = "_tValue)
						Set tSC = ..UnQuote(tValue,.tDValue)
						If ($Get(tDValue) ? 1.N1"-"1.N1"-"1.N) {
							Set tDate = $ZDATEH(tDValue,8)
							Do ..DebugTEST("tDate = "_$Get(tDate))
							Set $Piece(tValues,",",ii) = $Get(tDate)
							Do ..DebugTEST("tValues = "_tValues)
						}
					}
				}
				Set tParValues = "("_$Get(tValues,tParValues)_")"
				Set $Piece(pQuery," ",6,999) = tParValues
				Do ..DebugTEST("pQuery = "_pQuery)
			}
		}
	}
	Set pQuery2 = pQuery
	Do ..DebugTEST("pQuery2 = "_pQuery)
	Quit $$$OK
}

ClassMethod UnQuote(
	pQuote As %String = "",
	Output pUnQuote As %String) As %Status
{
	If ($Extract(pQuote,1) = "'"),($Extract(pQuote,*) = "'") {
		Set pUnQuote = $Extract(pQuote,2,*-1)
		Quit $$$OK
	}
	Quit $$$OK
}

}
