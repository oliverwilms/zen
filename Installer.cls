Class App.Installer
{

XData setup
{
<Manifest>
  <Default Name="SourceDir" Value="#{$system.Process.CurrentDirectory()}src"/>
  <Default Name="Namespace" Value="IRISAPP"/>

  <Namespace Name="${Namespace}" Code="${Namespace}" Data="${Namespace}" Create="yes" Ensemble="no">
    <Configuration>
      <Database Name="${Namespace}" Dir="/voldata/irisdb/irisapp" Create="yes" MountRequired="true" Resource="%DB_IRISAPP" PublicPermissions="" MountAtStartup="true"/>
    </Configuration>
    <Import File="${SourceDir}" Flags="ck" Recurse="1"/>
  </Namespace>

  <If Condition='(##class(Security.Applications).Exists("/irisapp")=0)'>
    <Log Text="Creating web application /irisapp" Level="0"/>
    <RunInstall Class="App.Installer" Method="CreateWebApp"/>
  </If>
  <If Condition='(##class(Security.Applications).Exists("/riches")=0)'>
    <Log Text="Creating web application /riches" Level="0"/>
    <RunInstall Class="App.Installer" Method="CreateWebAppModel"/>
  </If>
  <If Condition='(##class(Security.Applications).Exists("/restAll")=0)'>
    <Log Text="Creating web application /restAll" Level="0"/>
    <RunInstall Class="App.Installer" Method="CreateWebAppREST"/>
  </If>
  <User Username="_SYSTEM" PasswordVar="Password" Roles="%All" Enabled="true"/>
</Manifest>
}

ClassMethod CreateWebApp(pVars, pLogLevel, tInstaller) As %Status
{
  If $IsObject($Get(tInstaller)) {
    Set Namespace = tInstaller.Evaluate("${Namespace}")
    Do tInstaller.PushNS("%SYS")
  }
  Do ##class(Security.System).GetInstallationSecuritySetting(.security)
  If (security="None") {
    Set cspProperties("AutheEnabled") = $$$AutheUnauthenticated
  } Else {
    Set cspProperties("AutheEnabled") = $$$AutheCache // Password
  }
  Set cspName = "/irisapp"
  Set cspProperties("NameSpace") = $Get(Namespace,"IRISAPP")
  Set cspProperties("Enabled") = 1
  Set cspProperties("AutheEnabled") = $$$AutheUnauthenticated + $$$AutheCache
  Set cspProperties("DeepSeeEnabled") = 1
  Set cspProperties("iKnowEnabled") = 0
  Set cspProperties("Path") = "/opt/irisapp/csp"
  Set cspProperties("Resource") = ""
  Set cspProperties("ServeFiles") = 1
  Set tSC = ##class(Security.Applications).Create(cspName,.cspProperties)
  If $IsObject($Get(tInstaller)) {
    Do tInstaller.PopNS()
  }
  If $$$ISERR(tSC) Throw ##class(%Installer.Exception).CreateFromStatus(tSC)
  Quit $$$OK
}

ClassMethod CreateWebAppModel(pVars, pLogLevel, tInstaller) As %Status
{
  If $Data(tInstaller) {
    Set Namespace = tInstaller.Evaluate("${Namespace}")
    Do tInstaller.PushNS("%SYS")
  }
  Do ##class(Security.System).GetInstallationSecuritySetting(.security)
  If (security="None") {
    Set cspProperties("AutheEnabled") = $$$AutheUnauthenticated
  } Else {
    Set cspProperties("AutheEnabled") = $$$AutheCache // Password
  }
  Set cspName = "/riches"
  Set cspProperties("NameSpace") = $Get(Namespace,"IRISAPP")
  Set cspProperties("Enabled") = 1
  Set cspProperties("AutheEnabled") = $$$AutheUnauthenticated + $$$AutheCache
  Set cspProperties("DeepSeeEnabled") = 1
  Set cspProperties("iKnowEnabled") = 0
  Set cspProperties("DispatchClass") = "Riches.Model.CategoryREST"
  Set cspProperties("Resource") = ""
  Set cspProperties("ServeFiles") = 1
  Set tSC = ##class(Security.Applications).Create(cspName,.cspProperties)
  If $Data(tInstaller) {
    Do tInstaller.PopNS()
  }
  If $$$ISERR(tSC) Throw ##class(%Installer.Exception).CreateFromStatus(tSC)
  Quit $$$OK
}

ClassMethod CreateWebAppREST(pVars, pLogLevel, tInstaller) As %Status
{
  Set Namespace = tInstaller.Evaluate("${Namespace}")
  Do tInstaller.PushNS("%SYS")
  Do ##class(Security.System).GetInstallationSecuritySetting(.security)
  If (security="None") {
    Set cspProperties("AutheEnabled") = $$$AutheUnauthenticated
  } Else {
    Set cspProperties("AutheEnabled") = $$$AutheCache // Password
  }
  Set cspName = "/restAll"
  Set cspProperties("NameSpace") = $Get(Namespace,"IRISAPP")
  Set cspProperties("Enabled") = 1
  Set cspProperties("AutheEnabled") = $$$AutheUnauthenticated + $$$AutheCache
  Set cspProperties("DeepSeeEnabled") = 1
  Set cspProperties("iKnowEnabled") = 0
 #; Set cspProperties("DispatchClass") = "Riches.REST"
  Set cspProperties("DispatchClass") = "MyApp.REST"
  set cspProperties("MatchRoles") = ":%DB_IRISAPP"  // To allow unauthenticated access, you must give the web application the %DB_IRISAPP role
  Set cspProperties("Resource") = ""
  Set cspProperties("ServeFiles") = 1
  Set tSC = ##class(Security.Applications).Create(cspName,.cspProperties)
  Do tInstaller.PopNS()
  If $$$ISERR(tSC) Throw ##class(%Installer.Exception).CreateFromStatus(tSC)
  Quit $$$OK
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}
ClassMethod ConfigIRIS(ByRef pVars, pLogLevel As %String = "", tInstaller) As %Status
{
	Set pVars("Password") = "abc123"
	Set tSC = ..setup(.pVars)
	If (tSC '= $$$OK) {
		Write "Setup failed.",!
		Write $system.Status.GetOneErrorText(tSC),!
	}
	Quit tSC
}
}
