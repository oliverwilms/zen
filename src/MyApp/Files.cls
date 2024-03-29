Class MyApp.Files Extends (%Persistent, %ZEN.DataModel.Adaptor) [ StorageStrategy = NewStorage1 ]
{

Index FileIdIndex On FileId [ IdKey, Unique ];

Property FileId As %Integer;

Property FilePN As %String;

ClassMethod AnalyzeFile(pFile As %String = "") As %Status
{
	Set tSC = $$$OK
	If (pFile = "") Quit tSC
	Write "Analyze ",$Get(^ImportFile(pFile)),!
	Kill ^ImportFile(pFile,-1)
	Kill ^ImportFile(pFile,-2)
	Set q = """"
	Set tLine = 0
	For {
		Set tLine = $Order(^ImportFile(pFile,tLine),1,input)
		If (tLine = "") Quit
		Write tLine,input,!
		If input?1"<Class name=".E {
			Set tClassName = $Piece(input,"=",2)
			Set tClassName = $Piece(tClassName,">",1)
			If ($Extract(tClassName,1) = q) Set tClassName = $Extract(tClassName,2,*)
			If ($Extract(tClassName,*) = ">") Set tClassName = $Extract(tClassName,1,*-1)
			If ($Extract(tClassName,*) = q) Set tClassName = $Extract(tClassName,1,*-1)
			Set ^ImportFile(pFile,-1,"Class",tClassName) = tLine
		}
		If input?1"<Routine name=".E {
			Set tRoutineName = $Piece(input,"=",2)
			Set tRoutineName = $Piece(tRoutineName," type",1)
			If ($Extract(tRoutineName,1) = q) Set tRoutineName = $Extract(tRoutineName,2,*)
			If ($Extract(tRoutineName,*) = q) Set tRoutineName = $Extract(tRoutineName,1,*-1)
			Set tType = $Piece(input,"=",3)
			Set tType = $Piece(tType," timestamp",1)
			If ($Extract(tType,1) = q) Set tType = $Extract(tType,2,*)
			If ($Extract(tType,*) = q) Set tType = $Extract(tType,1,*-1)
			Set tRoutine = tRoutineName_"."_tType
			Set ^ImportFile(pFile,-2,"Routine",tRoutine) = tLine
		}
	}
	Quit $$$OK
}

/// Is this a line to ignore?
ClassMethod AnalyzeLine(pLine As %String = "") As %String
{
	Set tReturn = ""
	If (pLine = "") Quit tReturn
	If pLine?1"<Language>cache".E Quit tReturn
	If pLine?1"<Language>objectscript".E Quit tReturn
	If pLine?1"<TimeChanged>".E Quit tReturn
	If pLine?1"<TimeCreated>".E Quit tReturn
	If pLine?1"<Type>%Library.CacheSerialState".E Quit tReturn
	If pLine?1"<Type>%Library.CacheStorage".E Quit tReturn
	If pLine?1"<Type>%Storage.Persistent".E Quit tReturn
	If pLine?1"<Type>%Storage.Serial".E Quit tReturn
	If pLine?1"on "4N1"-"2N1"-"2N1" at "2N1":"2N1":"2N1"."3N1" [".E Quit tReturn
	If pLine?1"by user "1.E1"</Description>" Quit tReturn
	Quit pLine
}

ClassMethod CompareFiles(
	pFile1 As %String = "",
	pFile2 As %String = "") As %Status
{
	Set tSC = $$$OK
	If (pFile1 = "") Quit tSC
	If (pFile2 = "") Quit tSC
	If (pFile1 = pFile2) Quit tSC
	Write "Compare ",$Get(^ImportFile(pFile1))," and ",$Get(^ImportFile(pFile2)),!
	Set tCompare = $Increment(^CompareFiles)
	Set ^CompareFiles(tCompare) = $Horolog
	Set ^CompareFiles(tCompare,"File1") = pFile1
	Set ^CompareFiles(tCompare,"File2") = pFile2
	Set diffCount = 0
	Set tClassName = ""
	For {
		Set tClassName = $Order(^ImportFile(pFile1,-1,"Class",tClassName))
		If (tClassName = "") Quit
		Set tData = $Data(^ImportFile(pFile2,-1,"Class",tClassName))
		If (tData = 0) {
			Write "Class ",tClassName," does not exist in ",$Get(^ImportFile(pFile2)),!
			Set ^CompareFiles(tCompare,-1,"Class",tClassName) = "-2^Class "_tClassName_" does not exist in "_$Get(^ImportFile(pFile2))
			If $Increment(diffCount)
			Continue
		}
		Set tSC = ..CompareCode(pFile1,pFile2,"Class",tClassName)
		Set ^CompareFiles(tCompare,-1,"Class",tClassName) = tSC
		If $$$ISERR(tSC) {
			Write "Diff found in ",tClassName,!
			If $Increment(diffCount)
		}
	}
	For {
		Set tClassName = $Order(^ImportFile(pFile2,-1,"Class",tClassName))
		If (tClassName = "") Quit
		Set tData = $Data(^ImportFile(pFile1,-1,"Class",tClassName))
		If (tData = 0) {
			Write "Class ",tClassName," does not exist in ",$Get(^ImportFile(pFile1)),!
			Set ^CompareFiles(tCompare,-1,"Class",tClassName) = "-1^Class "_tClassName_" does not exist in "_$Get(^ImportFile(pFile1))
			If $Increment(diffCount)
		}
	}
	Set tRoutine = ""
	For {
		Set tRoutine = $Order(^ImportFile(pFile1,-2,"Routine",tRoutine))
		If (tRoutine = "") Quit
		Set tData = $Data(^ImportFile(pFile2,-2,"Routine",tRoutine))
		If (tData = 0) {
			Write "Routine ",tRoutine," does not exist in ",$Get(^ImportFile(pFile2)),!
			Set ^CompareFiles(tCompare,-2,"Routine",tRoutine) = "-2^Routine "_tRoutine_" does not exist in "_$Get(^ImportFile(pFile2))
			If $Increment(diffCount)
		}
	}
	For {
		Set tRoutine = $Order(^ImportFile(pFile2,-2,"Routine",tRoutine))
		If (tRoutine = "") Quit
		Set tData = $Data(^ImportFile(pFile1,-2,"Routine",tRoutine))
		If (tData = 0) {
			Write "Routine ",tRoutine," does not exist in ",$Get(^ImportFile(pFile1)),!
			Set ^CompareFiles(tCompare,-2,"Routine",tRoutine) = "-1^Routine "_tRoutine_" does not exist in "_$Get(^ImportFile(pFile1))
			If $Increment(diffCount)
		}
	}
	Write diffCount," difference(s) found",!
	Set ^CompareFiles(tCompare) = $Get(^CompareFiles(tCompare))_"^"_$Horolog_"^"_diffCount
	Quit $$$OK
}

ClassMethod CompareCode(
	pFile1 As %String = "4",
	pFile2 As %String = "5",
	pWhat As %String = "Class",
	pWhich1 As %String = "HS.Local.VA.eSCM.DMLSS.Complex.CCS.CCRCC1Sequence") As %Status
{
	Set flagStorage1 = 0
	Set flagStorage2 = 0
	Set tIndex = 0
	Set tLineDiff = 0
	Set tSC = $$$OK
	If (pFile1 = "") Quit tSC
	If (pFile2 = "") Quit tSC
	If (pFile1 = pFile2) Quit tSC
	If (pWhat = "") Quit tSC
	If (pWhich1 = "") Quit tSC
	If pWhat = "Class" Set tIndex = -1
	Set tLine1 = $Get(^ImportFile(pFile1,tIndex,pWhat,pWhich1))
	If (tLine1 < 1) Quit tSC
	If ($Get(pWhich2) = "") Set pWhich2 = pWhich1
	Set tLine2 = $Get(^ImportFile(pFile2,tIndex,pWhat,pWhich2))
	For {
		If tLineDiff {
			Set diffIndex1 = tLine1
			Set diffIndex2 = tLine2
			Set diffLine1 = input1
			Set diffLine2 = input2
		}
		For {
			Set tLine1 = $Order(^ImportFile(pFile1,tLine1),1,input1)
			If (tLine1 = "") Quit
			If (flagStorage1 = 0),($Extract(input1,1,8) = "<Storage") {
				Set flagStorage1 = 1  // Skip <Storage
				Continue
			}
			If (flagStorage1 = 1) {
				If ($Extract(input1,1,9) = "</Storage") {
					Set flagStorage1 = 0  // Skip <Storage
				}
				Continue
			}
			Set input1 = ..AnalyzeLine(input1)  // Set to empty to ignore this line
			If (input1 = "") Continue  // Skip, ignore empty lines
			Quit
		}
		For {
			Set tLine2 = $Order(^ImportFile(pFile2,tLine2),1,input2)
			If (tLine2 = "") Quit
			If (flagStorage2 = 0),($Extract(input2,1,8) = "<Storage") {
				Set flagStorage2 = 1  // Skip <Storage
				Continue
			}
			If (flagStorage2 = 1) {
				If ($Extract(input2,1,9) = "</Storage") {
					Set flagStorage2 = 0  // Skip <Storage
				}
				Continue
			}
			Set input2 = ..AnalyzeLine(input2)  // Set to empty to ignore this line
			If (input2 = "") Continue  // Skip, ignore empty lines
			Quit
		}
		If tLineDiff {
			If ($Extract(diffLine1,1,6) = "<Code>"),($Extract(diffLine2,*-6,*) = input1),($Extract(diffLine2,1,*-7) = diffLine1) {
				Set tLine2 = diffIndex2
				Set tLineDiff = 0
				Continue
			}
			If (input1 = diffLine2) {
				Set tSC = $$$ERROR($$$GeneralError,"ADD line at line "_diffIndex1)
				Write diffIndex1,": ",diffLine1,!
			} ElseIf (input2 = diffLine1) {
				Set tSC = $$$ERROR($$$GeneralError,"ADD line at line "_diffIndex2)
				Write diffIndex2,": ",diffLine2,!
			} Else {
				Set tSC = $$$ERROR($$$GeneralError,"Diff found at line "_diffIndex1)
				Write diffIndex1,": ",diffLine1,!
				Write diffIndex2,": ",diffLine2,!
			}
			Quit
		}
		If (input1 = "</Class>"),(input2 = "</Class>") Quit
		If (input1 = input2) Continue
		Set tLineDiff = 1
	}
	Quit tSC
}

Storage NewStorage1
{
<SQLMap name="Map1">
<Data name="FilePN">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ImportFile</Global>
<Subscript name="1">
<Expression>{FileId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^MyApp.FileS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
