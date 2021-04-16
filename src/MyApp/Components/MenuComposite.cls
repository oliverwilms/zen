/// MyApp.Components.MenuComposite
Class MyApp.Components.MenuComposite Extends %ZEN.Component.composite [ Language = objectscript ]
{

/// This is the XML namespace for this component.
Parameter NAMESPACE = "http://www.intersystems.com/MyApp";

/// This Style block contains component-specific CSS style definitions.
XData Style
{
<style type="text/css">
.title {
	background: #C5D6D6;
	color: black;
	font-size: 1.5em;
	font-weight: bold;
	padding: 5px;
	border-bottom: 1px solid black;
	text-align: center;
}
a.menuItem {
	font-size: 0.9em;
	color: black;
}
a.menuItemDisabled {
	font-size: 0.9em;
	color: black;
}
</style>
}

/// Contents of this composite component.
XData Contents [ XMLNamespace = "http://www.intersystems.com/MyApp" ]
{
<composite>
<html id="title" enclosingClass="title">Code Compare</html>
<hmenu width="100%">
<menuItem id="m1" caption="Home" link="MyApp.Hello.cls" help="Go to Home page" />
<menuItem id="m2" caption="Compare" link="javascript:zenPage.compare();" help="Go to Compare page" />
<menuItem id="m3" caption="Details" link="javascript:zenPage.details();" help="Go to Details page" />
</hmenu>
</composite>
}

}
