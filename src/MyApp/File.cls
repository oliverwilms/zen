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

}
