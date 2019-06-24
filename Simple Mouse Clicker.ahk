#NoEnv
#NoTrayIcon
#SingleInstance ignore
SendMode Input
SetWorkingDir %A_ScriptDir%

ScriptName := "Simple Mouse Clicker"
ScriptVersion := "1.1.0.0"
CopyrightNotice := "Copyright (c) 2019 Chaohe Shi"

ConfigDir := A_AppData . "\" . ScriptName
ConfigFile := ConfigDir . "\" . ScriptName . ".ini"

; set script texts
TEXT_ClickInterval := "Click Interval"
TEXT_Hours := "Hours"
TEXT_Minutes := "Minutes"
TEXT_Seconds := "Seconds"
TEXT_MilliSeconds := "MilliSeconds"

TEXT_MouseAction := "Mouse Action"
TEXT_Button := "Button"
TEXT_Action := "Action"
TEXT_PrimaryButton := "Primary Button"
TEXT_SecondaryButton := "Secondary Button"
TEXT_SingleClick := "Single Click"
TEXT_DoubleClick := "Double Click"

TEXT_HotKey := "Hot Key"
TEXT_Start := "Start"
TEXT_Stop := "Stop"

; retrieve scipt settings
IniRead, Hours, %ConfigFile%, ClickInterval, Hours, 0
IniRead, Minutes, %ConfigFile%, ClickInterval, Minutes, 0
IniRead, Seconds, %ConfigFile%, ClickInterval, Seconds, 1
IniRead, MilliSeconds, %ConfigFile%, ClickInterval, MilliSeconds, 0

IniRead, MouseButton, %ConfigFile%, MouseAction, MouseButton, 1
IniRead, ClickAction, %ConfigFile%, MouseAction, ClickAction, 1

IniRead, HotkeyStart, %ConfigFile%, HotKey, HotkeyStart, F5
IniRead, HotkeyStop, %ConfigFile%, HotKey, HotkeyStop, F6

CurrentHotkeyStart := HotkeyStart
CurrentHotkeyStop := HotkeyStop

if (CurrentHotkeyStart != "")
{
	Hotkey, %CurrentHotkeyStart%, ButtonStart, On
}
if (CurrentHotkeyStop != "")
{
	Hotkey, %CurrentHotkeyStop%, ButtonStop, On
}

Gui, New, +AlwaysOnTop +HwndGuiHwnd, %ScriptName%
Gui, %GuiHwnd%:Default

Gui, Add, Tab3, , %TEXT_ClickInterval%|%TEXT_MouseAction%|%TEXT_HotKey%

Gui, Tab, 1

Gui, Add, Text, Section, %TEXT_Hours%
Gui, Add, Edit, Number Limit2 w50
Gui, Add, UpDown, vUpDownHour Range0-24, %Hours%

Gui, Add, Text, Section ys, %TEXT_Minutes%
Gui, Add, Edit, Number Limit2 w50
Gui, Add, UpDown, vUpDownMinute Range0-59, %Minutes%

Gui, Add, Text, Section ys, %TEXT_Seconds%
Gui, Add, Edit, Number Limit2 w50
Gui, Add, UpDown, vUpDownSecond Range0-59, %Seconds%

Gui, Add, Text, Section ys, %TEXT_MilliSeconds%
Gui, Add, Edit, Number Limit3 w50
Gui, Add, UpDown, vUpDownMilliSecond Range0-999, %MilliSeconds%

Gui, Tab, 2

Gui, Add, Text, Section, %TEXT_Button%
Gui, Add, Text, , %TEXT_Action%
Gui, Add, DropDownList, AltSubmit Choose%MouseButton% ys vChoiceButton, %TEXT_PrimaryButton%|%TEXT_SecondaryButton%
Gui, Add, DropDownList, AltSubmit Choose%ClickAction% vChoiceAction, %TEXT_SingleClick%|%TEXT_DoubleClick%

Gui, Tab, 3

Gui, Add, Text, Section, %TEXT_Start%
Gui, Add, Text, , %TEXT_Stop%
Gui, Add, Hotkey, Limit1 ys vHotkeyStart gHotkeyStart, %CurrentHotkeyStart%
Gui, Add, Hotkey, Limit1 vHotkeyStop gHotkeyStop, %CurrentHotkeyStop%

Gui, Tab

Gui, Add, Button, Default w75 h23 vButtonStart gButtonStart, %TEXT_Start%
GuiControl, Focus, ButtonStart

Gui, Add, Button, x+m w75 h23 vButtonStop gButtonStop, %TEXT_Stop%
GuiControl, Disable, ButtonStop

Gui, Show

Return ; end of the auto-execute section

ButtonStart:
GuiControlGet, IsEnabled, %GuiHwnd%:Enabled, ButtonStart ; check if the start button is enabled
if (IsEnabled)
{
	GuiControl, %GuiHwnd%:Disable, ButtonStart
	Gui, %GuiHwnd%:Submit, NoHide
	Gui, Minimize
	if (UpDownHour || UpDownMinute || UpDownSecond || UpDownMilliSecond) ; if click interval is not 0
	{
		SetTimer, % "Click" . (ChoiceButton == 2 ? "SecondaryButton" : "PrimaryButton"), % UpDownHour*3600000+UpDownMinute*60000+UpDownSecond*1000+UpDownMilliSecond
	}
	GuiControl, %GuiHwnd%:+Default, ButtonStop
	GuiControl, %GuiHwnd%:Enable, ButtonStop
}
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

HotkeyStart:
if (CurrentHotkeyStart != "")
{
	Hotkey, %CurrentHotkeyStart%, ButtonStart, Off
}
if (StrLen(StrSplit(HotkeyStart, A_Space, "^!+")[1]) > 0) ; if entered a valid hotkey
{
	CurrentHotkeyStart := HotkeyStart
	Hotkey, %CurrentHotkeyStart%, ButtonStart, On
}
Return

HotkeyStop:
if (CurrentHotkeyStop != "")
{
	Hotkey, %CurrentHotkeyStop%, ButtonStop, Off
}
if (StrLen(StrSplit(HotkeyStop, A_Space, "^!+")[1]) > 0) ; if entered a valid hotkey
{
	CurrentHotkeyStop := HotkeyStop
	Hotkey, %CurrentHotkeyStop%, ButtonStop, On
}
Return

GuiClose:
Gui, %GuiHwnd%:Submit
if (!InStr(FileExist(ConfigDir), "D"))
{
	FileCreateDir, %ConfigDir%
}
IniWrite, %UpDownHour%, %ConfigFile%, ClickInterval, Hours
IniWrite, %UpDownMinute%, %ConfigFile%, ClickInterval, Minutes
IniWrite, %UpDownSecond%, %ConfigFile%, ClickInterval, Seconds
IniWrite, %UpDownMilliSecond%, %ConfigFile%, ClickInterval, MilliSeconds

IniWrite, %ChoiceButton%, %ConfigFile%, MouseAction, MouseButton
IniWrite, %ChoiceAction%, %ConfigFile%, MouseAction, ClickAction

IniWrite, %HotkeyStart%, %ConfigFile%, HotKey, HotkeyStart
IniWrite, %HotkeyStop%, %ConfigFile%, HotKey, HotkeyStop
ExitApp
