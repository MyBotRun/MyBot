; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;$hGUI_BotOptions = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_BOT)
;GUISwitch($hGUI_BotOptions)

Local $x = 25, $y = 45
$grpLanguages = GUICtrlCreateGroup(GetTranslated(636,83, "GUI Language"), $x - 20, $y - 20, 210, 47)
	$y -=2
	$cmbLanguage = GUICtrlCreateCombo("", $x - 8 , $y, 185, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	$txtTip = GetTranslated(636,84, "Use this to switch to a different GUI language")
	_GUICtrlSetTip(-1, $txtTip)

	LoadLanguagesComboBox() ; full combo box languages reading from languages folders

	GUICtrlSetData(-1, "English", "English") ;default set english language
	GUICtrlSetOnEvent(-1, "cmbLanguage")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$y += 54
$grpOnLoadBot = GUICtrlCreateGroup(GetTranslated(636,2, "When Bot Loads"), $x - 20, $y - 20, 210, 120)
	$y -= 4
    $chkDisableSplash = GUICtrlCreateCheckbox(GetTranslated(636,100, "Disable Splash Screen"), $x, $y, -1, -1)
        $txtTip = GetTranslated(636,101, "Disables the splash screen on startup.")
        GUICtrlSetTip(-1, $txtTip)
        GUICtrlSetState(-1, $GUI_UNCHECKED)
    $y += 20
	$chkVersion = GUICtrlCreateCheckbox(GetTranslated(636,3, "Check for Updates"), $x, $y, -1, -1)
		$txtTip = GetTranslated(636,4, "Check if you are running the latest version of the bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
	$y += 20
	$chkDeleteLogs = GUICtrlCreateCheckbox(GetTranslated(636,5, "Delete Log Files")& ":", $x, $y, -1, -1)
		$txtTip = GetTranslated(636,6, "Delete log files older than this specified No. of days.")
		GUICtrlSetState(-1, $GUI_CHECKED)
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkDeleteLogs")
	$txtDeleteLogsDays = GUICtrlCreateInput("2", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
	$lblDeleteLogsDays = GUICtrlCreateLabel(GetTranslated(636,7, "days"), $x + 150, $y + 4, 27, 15)
	$y += 20
	$chkDeleteTemp = GUICtrlCreateCheckbox(GetTranslated(636,8, "Delete Temp Files") & ":", $x, $y, -1, -1)
		$txtTip = GetTranslated(636,9, "Delete temp files older than this specified No. of days.")
		GUICtrlSetState(-1, $GUI_CHECKED)
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkDeleteTemp")
	$txtDeleteTempDays = GUICtrlCreateInput("2", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
	$lblDeleteTempDays = GUICtrlCreateLabel(GetTranslated(636,7, "days"), $x + 150, $y + 4, 27, 15)
	$y += 20
	$chkDeleteLoots = GUICtrlCreateCheckbox(GetTranslated(636,10, "Delete Loot Images"), $x, $y, -1, -1)
		$txtTip = GetTranslated(636,11, "Delete loot image files older than this specified No. of days.")
		GUICtrlSetState(-1, $GUI_CHECKED)
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkDeleteLoots")
	$txtDeleteLootsDays = GUICtrlCreateInput("2", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
	$lblDeleteLootsDays = GUICtrlCreateLabel(GetTranslated(636,7, "days"), $x + 150, $y + 4, 27, 15)
GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 48
$grpOnStartBot = GUICtrlCreateGroup(GetTranslated(636,12, "When Bot Starts"), $x - 20, $y - 20, 210, 112)
	$y -= 5
	$chkAutostart = GUICtrlCreateCheckbox(GetTranslated(636,13, "Auto START after") & ":", $x, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslated(636,58, "Auto START the Bot after this No. of seconds."))
		GUICtrlSetOnEvent(-1, "chkAutostart")
	$txtAutostartDelay = GUICtrlCreateInput("10", $x + 120, $y + 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetFont(-1, 8)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$lblAutostartSeconds = GUICtrlCreateLabel(GetTranslated(603,6, "sec."), $x + 150, $y + 4, 27, 18)
	$y += 22
	$chkLanguage = GUICtrlCreateCheckbox(GetTranslated(636,15, "Check Game Language (EN)"), $x, $y, -1, -1)
		_GUICtrlSetTip(-1, GetTranslated(636,16, "Check if the Game is set to the correct language (Must be set to English)."))
		GUICtrlSetState(-1, $GUI_CHECKED)
	$y += 22
	$chkDisposeWindows = GUICtrlCreateCheckbox(GetTranslated(636,17, "Auto Align"), $x, $y, -1, -1)
		$txtTip = GetTranslated(636,18, "Reposition/Align Android Emulator and BOT windows on the screen.")
		GUICtrlSetOnEvent(-1, "chkDisposeWindows")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
	$lblOffset = GUICtrlCreateLabel(GetTranslated(636,19, "Offset") & ":", $x + 85, $y + 4, -1, -1)
	$txtWAOffsetx = GUICtrlCreateInput("10", $x + 120, $y + 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(636,20, "Offset horizontal pixels between Android Emulator and BOT windows.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
	$txtWAOffsety= GUICtrlCreateInput("0", $x + 150, $y + 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(636,21, "Offset vertical pixels between Android Emulator and BOT windows.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
	$y += 23
	$cmbDisposeWindowsCond = GUICtrlCreateCombo("", $x, $y, 175, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, GetTranslated(636,22, "0,0: Android Emulator-Bot") & "|" & _
						   GetTranslated(636,23, "0,0: Bot-Android Emulator") & "|" & _
						   GetTranslated(636,24, "SNAP: Bot TopRight to Android") &"|" & _
						   GetTranslated(636,25, "SNAP: Bot TopLeft to Android") & "|" & _
						   GetTranslated(636,26, "SNAP: Bot BottomRight to Android") & "|" & _
						   GetTranslated(636,27, "SNAP: Bot BottomLeft to Android") & "|" & _
						   GetTranslated(636,95, "DOCK: Android into Bot"), _
						   GetTranslated(636,24, "SNAP: Bot TopRight to Android"))
		$txtTip &= @CRLF & GetTranslated(636,28, "0,0: Reposition Android Emulator screen to position 0,0 on windows desktop and align Bot window right or left to it.") & @CRLF & _
						   GetTranslated(636,29, "SNAP: Only reorder windows, Align Bot window to Android Emulator window at Top Right, Top Left, Bottom Right or Bottom Left.\r\n" & _
												 "DOCK: Integrate Android Screen into bot window.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)


Local $x = 240, $y = 45
$grpAdvanced = GUICtrlCreateGroup(GetTranslated(636,93, "Advanced"), $x - 20, $y - 20, 225, 82)
	$chkUpdatingWhenMinimized = GUICtrlCreateCheckbox(GetTranslated(636,96, "Updating when minimized"), $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkUpdatingWhenMinimized")
		_GUICtrlSetTip(-1, GetTranslated(636,97, "Enable different minimize routine for bot window.\r\nWhen bot is minimized, screen updates are shown in taskbar preview."))
	$y += 19
	$chkHideWhenMinimized = GUICtrlCreateCheckbox(GetTranslated(636,98, "Hide when minimized"), $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkHideWhenMinimized")
		_GUICtrlSetTip(-1, GetTranslated(636,99, "Hide bot window in taskbar when minimized.\r\nUse trayicon 'Show bot' to display bot window again."))
	$y += 19
	$chkUseRandomClick = GUICtrlCreateCheckbox(GetTranslated(636,94, "Random Click"), $x, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkUseRandomClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y += 47
$grpPhotoExpert = GUICtrlCreateGroup(GetTranslated(636,55, "Photo Screenshot Options"), $x - 20, $y - 17, 225, 60)
	$chkScreenshotType = GUICtrlCreateCheckbox(GetTranslated(636,56, "Make in PNG format"), $x, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkScreenshotType")
	$y += 19
	$chkScreenshotHideName = GUICtrlCreateCheckbox(GetTranslated(636,57, "Hide Village and Clan Castle Name"), $x, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkScreenshotHideName")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$y +=48
$grpTimeWakeUp = GUICtrlCreateGroup(GetTranslated(636,85, "Remote Device"), $x - 20, $y - 20 , 225, 42)
	$y -= 5
	$lblTimeWakeUp = GUICtrlCreateLabel(GetTranslated(636,86, "When 'Another Device' wait") & ":", $x - 10, $y + 2, -1, -1)
	$txtTip = GetTranslated(636,87, "Enter the time to wait (in seconds) before the Bot reconnects when another device took control.")
		_GUICtrlSetTip(-1, $txtTip)
	$txtTimeWakeUp = GUICtrlCreateInput("240", $x + 127, $y - 1, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 3)
	$lblTimeWakeUpSec = GUICtrlCreateLabel(GetTranslated(603,6, "sec."), $x + 165, $y + 2, -1, -1)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$y+= 51
$grpOtherExpert = GUICtrlCreateGroup(GetTranslated(636,45, "Other Options"), $x - 20, $y - 20, 225, 90)
$chkSinglePBTForced = GUICtrlCreateCheckbox(GetTranslated(636,61, "Force Single PB logoff"), $x-5, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkSinglePBTForced")
	_GUICtrlSetTip(-1, GetTranslated(636,62, "This forces bot to exit CoC only one time prior to normal start of PB"))
$txtSinglePBTimeForced = GUICtrlCreateInput("18", $x + 130, $y-1, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslated(636,63, "Type in number of minutes to keep CoC closed. Set to 15 minimum to reset PB timer!"))
	GUICtrlSetOnEvent(-1, "txtSinglePBTimeForced")
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetState(-1, $GUI_DISABLE)
$lblSinglePBTimeForced = GUICtrlCreateLabel( GetTranslated(603,9, "Min"), $x+162, $y+2, 27, 15)
$y += 20
$lblPBTimeForcedExit = GUICtrlCreateLabel( GetTranslated(636,65, "Subtract time for early PB exit"), $x-10, $y+3)
	$txtTip = GetTranslated(636,66, "Type in number of minutes to quit CoC early! Setting below 10 minutes may not function!")
	_GUICtrlSetTip(-1, $txtTip)
$txtPBTimeForcedExit = GUICtrlCreateInput("16", $x + 130, $y, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "txtSinglePBTimeForced")
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetState(-1, $GUI_DISABLE)
$lblPBTimeForcedExit1 = GUICtrlCreateLabel( GetTranslated(603,9, -1), $x+162, $y+1, 27, 15)

$y +=30
$chkTotalCampForced = GUICtrlCreateCheckbox(GetTranslated(636,46, "Force Total Army Camp")&":", $x-5, $y-5, -1, -1)
	GUICtrlSetOnEvent(-1, "chkTotalCampForced")
	_GUICtrlSetTip(-1, GetTranslated(636,47, "If not detected set army camp values (instead ask)"))
$txtTotalCampForced = GUICtrlCreateInput("200", $x + 130, $y - 5, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
