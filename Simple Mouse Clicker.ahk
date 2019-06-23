#NoEnv
#NoTrayIcon
#SingleInstance ignore
SendMode Input
SetWorkingDir %A_ScriptDir%

ScriptName := "Simple Mouse Clicker"
ScriptVersion := "1.0.0.0"
CopyrightNotice := "Copyright (c) 2019 Chaohe Shi"

Gui, New, +AlwaysOnTop +HwndGuiHwnd, Simple Mouse Clicker
Gui, %GuiHwnd%:Default

Gui, Add, Tab3, , Click Interval|Mouse Action

Gui, Tab, 1

Gui, Add, Text, Section, Hours
Gui, Add, Edit, Number Limit2 w50
Gui, Add, UpDown, vUpDownHour Range0-24, 0

Gui, Add, Text, Section ys, Minutes
Gui, Add, Edit, Number Limit2 w50
Gui, Add, UpDown, vUpDownMinute Range0-59, 0

Gui, Add, Text, Section ys, Seconds
Gui, Add, Edit, Number Limit2 w50
Gui, Add, UpDown, vUpDownSecond Range0-59, 1

Gui, Add, Text, Section ys, MilliSeconds
Gui, Add, Edit, Number Limit3 w50
Gui, Add, UpDown, vUpDownMilliSecond Range0-999, 0

Gui, Tab, 2

Gui, Add, Text, Section, Mouse
Gui, Add, Text, , Action
Gui, Add, DropDownList, AltSubmit Choose1 ys vChoiceMouse, Primary Button|Secondary Button
Gui, Add, DropDownList, AltSubmit Choose1 vChoiceAction, Single Click|Double Click

Gui, Tab

Gui, Add, Button, Default w75 h23 vButtonStart gButtonStart, Start
GuiControl, Focus, ButtonStart

Gui, Add, Button, x+m w75 h23 vButtonStop gButtonStop, Stop
GuiControl, Disable, ButtonStop

Gui, Show

Return ; end of the auto-execute section

ButtonStart:
GuiControl, %GuiHwnd%:Disable, ButtonStart
Gui, %GuiHwnd%:Submit, NoHide
Gui, Minimize
SetTimer, % "Click" . (ChoiceMouse == 2 ? "SecondaryButton" : "PrimaryButton"), % UpDownHour*3600000+UpDownMinute*60000+UpDownSecond*1000+UpDownMilliSecond
GuiControl, %GuiHwnd%:+Default, ButtonStop
GuiControl, %GuiHwnd%:Enable, ButtonStop
Return

ButtonStop:
GuiControl, %GuiHwnd%:Disable, ButtonStop
SetTimer, ClickPrimaryButton, Off
SetTimer, ClickSecondaryButton, Off
GuiControl, %GuiHwnd%:+Default, ButtonStart
GuiControl, %GuiHwnd%:Enable, ButtonStart
Return

ClickPrimaryButton:
Click, %ChoiceAction%
Return

ClickSecondaryButton:
Click, %ChoiceAction%, Right
Return

GuiClose:
ExitApp
