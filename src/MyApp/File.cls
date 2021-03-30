Class MyApp.File
{

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

ClassMethod CompareFiles(
	pFile1 As %String = "",
	pFile2 As %String = "") As %Status
{
	Set tSC = $$$OK
	If (pFile1 = "") Quit tSC
	If (pFile2 = "") Quit tSC
	If (pFile1 = pFile2) Quit tSC
	Write "Compare ",$Get(^ImportFile(pFile1))," and ",$Get(^ImportFile(pFile2)),!
	Set tClassName = ""
	For {
		Set tClassName = $Order(^ImportFile(pFile1,-1,"Class",tClassName))
		If (tClassName = "") Quit
		Set tData = $Data(^ImportFile(pFile2,-1,"Class",tClassName))
		If (tData = 0) {
			Write "Class ",tClassName," does not exist in ",$Get(^ImportFile(pFile2)),!
			Continue
		}
		Set tSC = ..CompareCode(pFile1,pFile2,"Class",tClassName)
		If $$$ISERR(tSC) {
			Write "Diff found in ",tClassName,!
		}
	}
	For {
		Set tClassName = $Order(^ImportFile(pFile2,-1,"Class",tClassName))
		If (tClassName = "") Quit
		Set tData = $Data(^ImportFile(pFile1,-1,"Class",tClassName))
		If (tData = 0) {
			Write "Class ",tClassName," does not exist in ",$Get(^ImportFile(pFile1)),!
		}
	}
	Set tRoutine = ""
	For {
		Set tRoutine = $Order(^ImportFile(pFile1,-2,"Routine",tRoutine))
		If (tRoutine = "") Quit
		Set tData = $Data(^ImportFile(pFile2,-2,"Routine",tRoutine))
		If (tData = 0) {
			Write "Routine ",tRoutine," does not exist in ",$Get(^ImportFile(pFile2)),!
		}
	}
	For {
		Set tRoutine = $Order(^ImportFile(pFile2,-2,"Routine",tRoutine))
		If (tRoutine = "") Quit
		Set tData = $Data(^ImportFile(pFile1,-2,"Routine",tRoutine))
		If (tData = 0) {
			Write "Routine ",tRoutine," does not exist in ",$Get(^ImportFile(pFile1)),!
		}
	}
	Quit $$$OK
}

ClassMethod CompareCode(
	pFile1 As %String = "1",
	pFile2 As %String = "2",
	pWhat As %String = "Class",
	pWhich1 As %String = "HS.Local.VA.eSCM.Common.DocumentIDTable") As %Status
{
	Set tIndex = 0
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
	Set tLine2 = $Get(^ImportFile(pFile2,tIndex,pWhat,pWhich1))
	For {
		Set tLine1 = $Order(^ImportFile(pFile1,tLine1),1,input1)
		Set tLine2 = $Order(^ImportFile(pFile2,tLine2),1,input2)
		If (input1 = "</Class>"),(input2 = "</Class>") Quit
		If (input1 = input2) Continue
		If input1?1"<Language>cache".E Continue
		If input1?1"<Language>objectscript".E Continue
		If input1?1"<TimeChanged>".E Continue
		If input1?1"<TimeCreated>".E Continue
		If input1?1"<Type>%Library.CacheSerialState".E Continue
		If input1?1"<Type>%Library.CacheStorage".E Continue
		If input1?1"<Type>%Storage.Persistent".E Continue
		If input1?1"<Type>%Storage.Serial".E Continue
		If input1?1"on "4N1"-"2N1"-"2N1" at "2N1":"2N1":"2N1"."3N1" [".E Continue
		If input1?1"by user "1.E1"</Description>" Continue
		Write tLine1,": ",input1,!
		Write tLine2,": ",input2,!
		Set tSC = $$$ERROR($$$GeneralError,"Diff found at line "_tLine1)
		Quit
	}
	Quit tSC
}

}
