/// MyApp.Application
Class MyApp.Application Extends %ZEN.application [ Language = objectscript ]
{

/// This is the name of this application.
Parameter APPLICATIONNAME;

/// This is the URL of the main starting page of this application.
Parameter HOMEPAGE = "MyApp.Hello.cls";

/// This Style block contains application-wide CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

}
