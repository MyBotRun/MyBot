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
$hGUI_BotOptions = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_BOT)
;GUISetBkColor($COLOR_WHITE, $hGUI_BotOptions)

GUISwitch($hGUI_BotOptions)
Local $x = 20, $y = 95
$grpOnLoadBot = GUICtrlCreateGroup(GetTranslated(636,2, "When Bot Loads"), $x - 20, $y - 20, 210, 100)
	$y -= 4
	$chkVersion = GUICtrlCreateCheckbox(GetTranslated(636,3, "Check for Updates"), $x, $y, -1, -1)
		$txtTip = GetTranslated(636,4, "Check if you are running the latest version of the bot.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
	$y += 20
	$chkDeleteLogs = GUICtrlCreateCheckbox(GetTranslated(636,5, "Delete Log Files")& ":", $x, $y, -1, -1)
		$txtTip = GetTranslated(636,6, "Delete log files older than this specified No. of days.")
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkDeleteLogs")
	$txtDeleteLogsDays = GUICtrlCreateInput("2", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
	$lblDeleteLogsDays = GUICtrlCreateLabel(GetTranslated(636,7, "days"), $x + 150, $y + 4, 27, 15)
	$y += 20
	$chkDeleteTemp = GUICtrlCreateCheckbox(GetTranslated(636,8, "Delete Temp Files") & ":", $x, $y, -1, -1)
		$txtTip = GetTranslated(636,9, "Delete temp files older than this specified No. of days.")
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkDeleteTemp")
	$txtDeleteTempDays = GUICtrlCreateInput("2", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
	$lblDeleteTempDays = GUICtrlCreateLabel(GetTranslated(636,7, "days"), $x + 150, $y + 4, 27, 15)
	$y += 20
	$chkDeleteLoots = GUICtrlCreateCheckbox(GetTranslated(636,10, "Delete Loot Images"), $x, $y, -1, -1)
		$txtTip = GetTranslated(636,11, "Delete loot image files older than this specified No. of days.")
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkDeleteLoots")
	$txtDeleteLootsDays = GUICtrlCreateInput("2", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
	$lblDeleteLootsDays = GUICtrlCreateLabel(GetTranslated(636,7, "days"), $x + 150, $y + 4, 27, 15)
GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 20
	$y += 50
$grpOnStartBot = GUICtrlCreateGroup(GetTranslated(636,12, "When Bot Starts"), $x - 20, $y - 20, 210, 112)
	$y -= 5
	$chkAutostart = GUICtrlCreateCheckbox(GetTranslated(636,13, "Auto START after") & ":", $x, $y, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(636,58, "Auto START the Bot after this No. of seconds."))
		GUICtrlSetOnEvent(-1, "chkAutostart")
	$txtAutostartDelay = GUICtrlCreateInput("10", $x + 120, $y + 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetFont(-1, 8)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$lblAutostartSeconds = GUICtrlCreateLabel(GetTranslated(603,6, "sec."), $x + 150, $y + 4, 27, 18)
	$y += 22
	$chkLanguage = GUICtrlCreateCheckbox(GetTranslated(636,15, "Check Game Language (EN)"), $x, $y, -1, -1)
		GUICtrlSetTip(-1, GetTranslated(636,16, "Check if the Game is set to the correct language (Must be set to English)."))
		GUICtrlSetState(-1, $GUI_CHECKED)
	$y += 22
	$chkDisposeWindows = GUICtrlCreateCheckbox(GetTranslated(636,17, "Auto Align"), $x, $y, -1, -1)
		$txtTip = GetTranslated(636,18, "Reposition/Align Android Emulator and BOT windows on the screen.")
		GUICtrlSetOnEvent(-1, "chkDisposeWindows")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
	$lblOffset = GUICtrlCreateLabel(GetTranslated(636,19, "Offset") & ":", $x + 85, $y + 4, -1, -1)
	$txtWAOffsetx = GUICtrlCreateInput("10", $x + 120, $y + 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(636,20, "Offset horizontal pixels between Android Emulator and BOT windows.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
	$txtWAOffsety= GUICtrlCreateInput("0", $x + 150, $y + 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(636,21, "Offset vertical pixels between Android Emulator and BOT windows.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 2)
		GUICtrlSetFont(-1, 8)
	$y += 23
	$cmbDisposeWindowsCond = GUICtrlCreateCombo("", $x, $y, 175, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, GetTranslated(636,22, "0,0: Android Emulator-Bot") & "|" & GetTranslated(636,23, "0,0: Bot-Android Emulator") & "|" & GetTranslated(636,24, "SNAP: Bot TopRight to Android") &"|" & GetTranslated(636,25, "SNAP: Bot TopLeft to Android") & "|" & GetTranslated(636,26, "SNAP: Bot BottomRight to Android") & "|" & GetTranslated(636,27, "SNAP: Bot BottomLeft to Android") , GetTranslated(636,24, "SNAP: Bot TopRight to Android"))
		$txtTip &= @CRLF & GetTranslated(636,28, "0,0: Reposition Android Emulator screen to position 0,0 on windows desktop and align Bot window right or left to it.") & @CRLF & GetTranslated(636,29, "SNAP: Only reorder windows, Align Bot window to Android Emulator window at Top Right, Top Left, Bottom Right or Bottom Left.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 20
	$y += 50
$grpVSDelay = GUICtrlCreateGroup(GetTranslated(636,75, "Village Search Delay"), $x - 20, $y - 20, 210, 72)
	$txtTip = GetTranslated(636,76, "Use this slider to change the time to wait between Next clicks when searching for a Village to Attack.") & @CRLF & GetTranslated(636,77, "This might compensate for Out of Sync errors on some PC's.") & @CRLF & GetTranslated(636,78, "NO GUARANTEES! This will not always have the same results!")
	$lblVSDelay0 = GUICtrlCreateLabel(GetTranslated(603,9, -1), $x-14, $y-2, 19, 15, $SS_RIGHT)
		GUICtrlSetTip(-1, $txtTip)
	$lblVSDelay = GUICtrlCreateLabel("0", $x+7, $y-2, 12, 15, $SS_RIGHT)
		GUICtrlSetTip(-1, $txtTip)
	$lbltxtVSDelay = GUICtrlCreateLabel(GetTranslated(603,8, "seconds"), $x + 23, $y-2, -1, -1)
	$sldVSDelay = GUICtrlCreateSlider($x + 70, $y - 4, 99, 25, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
		GUICtrlSetTip(-1, $txtTip)
		_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
		_GUICtrlSlider_SetTicFreq(-1, 1)
		GUICtrlSetLimit(-1, 10, 0) ; change max/min value
		GUICtrlSetData(-1, 1) ; default value
		GUICtrlSetOnEvent(-1, "sldVSDelay")
	$y += 25
	$lblMaxVSDelay0 = GUICtrlCreateLabel(GetTranslated(636,80, "Max"), $x-12, $y-2, 19, 15, $SS_RIGHT)
		$txtTip = GetTranslated(636,81, "Enable random village search delay value by setting") & @CRLF & GetTranslated(636,82, "bottom Max slide value higher than the top minimum slide")
		GUICtrlSetTip(-1, $txtTip)
	$lblMaxVSDelay = GUICtrlCreateLabel("0", $x+7, $y-2, 12, 15, $SS_RIGHT)
		GUICtrlSetTip(-1, $txtTip)
	$lbltxtMaxVSDelay = GUICtrlCreateLabel(GetTranslated(603,8, -1), $x + 23, $y-2, 45, -1)
	$sldMaxVSDelay = GUICtrlCreateSlider($x + 70, $y - 4, 114, 25, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
		GUICtrlSetTip(-1, $txtTip)
		_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
		_GUICtrlSlider_SetTicFreq(-1, 1)
		GUICtrlSetLimit(-1, 12, 0) ; change max/min value
		GUICtrlSetData(-1, 4) ; default value
		GUICtrlSetOnEvent(-1, "sldMaxVSDelay")
GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 234, $y = 25
$grpLanguages = GUICtrlCreateGroup(GetTranslated(636,83, "GUI Language"), $x - 20, $y - 20, 225, 45)
	$y -=2
	$cmbLanguage = GUICtrlCreateCombo("", $x - 3 , $y, 185, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	$txtTip = GetTranslated(636,84, "Use this to switch to a different GUI language")
	GUICtrlSetTip(-1, $txtTip)

	LoadLanguagesComboBox() ; full combo box languages reading from languages folders

	GUICtrlSetData(-1, "English", "English") ;default set english language
	GUICtrlSetOnEvent(-1, "cmbLanguage")
GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 69
$grpPhotoExpert = GUICtrlCreateGroup(GetTranslated(636,55, "Photo Screenshot Options"), $x - 20, $y - 17, 225, 59)
	$chkScreenshotType = GUICtrlCreateCheckbox(GetTranslated(636,56, "Make in PNG format"), $x, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkScreenshotType")
	$y += 19
	$chkScreenshotHideName = GUICtrlCreateCheckbox(GetTranslated(636,57, "Hide Village and Clan Castle Name"), $x, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "chkScreenshotHideName")
GUICtrlCreateGroup("", -99, -99, 1, 1)

   $y +=52
$grpTiming = GUICtrlCreateGroup(GetTranslated(636,30, "Timing"), $x - 20, $y - 20, 225, 55)
	$lblTrainDelay = GUICtrlCreateLabel(GetTranslated(636,31, "Train Troops") & ":", $x, $y, -1, -1)
	$lbltxtTrainITDelay = GUICtrlCreateLabel(GetTranslated(636,32, "delay"), $x + 65, $y - 5, 37, 30)
		GUICtrlSetTip(-1, GetTranslated(636,33, "Increase the delay if your PC is slow"))
	$sldTrainITDelay = GUICtrlCreateSlider($x + 105, $y - 5, 70, 25, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
		GUICtrlSetTip(-1, GetTranslated(636,33, "Increase the delay if your PC is slow"))
		_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
		_GUICtrlSlider_SetTicFreq(-100, 100)
		GUICtrlSetLimit(-1, 500, 1) ; change max/min value
		GUICtrlSetData(-1, 10) ; default value
		GUICtrlSetOnEvent(-1, "sldTrainITDelay")
GUICtrlCreateGroup("", -99, -99, 1, 1)
#CS
	$y +=72
	$grpGUIStyle = GUICtrlCreateGroup(GetTranslated(636,67, "GUI Style"), $x - 20, $y - 20, 220, 50)
		$cmbGUIstyle = GUICtrlCreateCombo("", $x + 15, $y, 160, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1,GetTranslated(636,68,"rectangles") & "|" & GetTranslated(636,69,"frames"),GetTranslated(636,64,-1) )
			$txtTip &= "GUI Style"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "cmbGUIstyle")
#CE
	$y +=60
	$grpTimeWakeUp = GUICtrlCreateGroup(GetTranslated(636,85, "Remote Device"), $x - 20, $y - 20 , 225, 42)
		$y -= 5
		$lblTimeWakeUp = GUICtrlCreateLabel(GetTranslated(636,86, "When 'Another Device' wait") & ":", $x - 10, $y + 2, -1, -1)
		$txtTip = GetTranslated(636,87, "Enter the time to wait (in seconds) before the Bot reconnects when another device took control.")
			GUICtrlSetTip(-1, $txtTip)
		$txtTimeWakeUp = GUICtrlCreateInput("240", $x + 127, $y - 1, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
		$lblTimeWakeUpSec = GUICtrlCreateLabel(GetTranslated(603,6, "sec."), $x + 165, $y + 2, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y+= 55
	$grpOtherExpert = GUICtrlCreateGroup(GetTranslated(636,45, "Other Options"), $x - 20, $y - 20, 225, 90)
	$chkSinglePBTForced = GUICtrlCreateCheckbox(GetTranslated(636,61, "Force Single PB logoff"), $x-5, $y, -1, -1)
		GUICtrlSetOnEvent(-1, "chkSinglePBTForced")
		GUICtrlSetTip(-1, GetTranslated(636,62, "This forces bot to exit CoC only one time prior to normal start of PB"))
	$txtSinglePBTimeForced = GUICtrlCreateInput("18", $x + 130, $y-1, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetTip(-1, GetTranslated(636,63, "Type in number of minutes to keep CoC closed. Set to 15 minimum to reset PB timer!"))
		GUICtrlSetOnEvent(-1, "txtSinglePBTimeForced")
		GUICtrlSetLimit(-1, 3)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$lblSinglePBTimeForced = GUICtrlCreateLabel( GetTranslated(603,9, "Min"), $x+162, $y+2, 27, 15)
	$y += 20
	$lblPBTimeForcedExit = GUICtrlCreateLabel( GetTranslated(636,65, "Subtract time for early PB exit"), $x-10, $y+3)
		$txtTip = GetTranslated(636,66, "Type in number of minutes to quit CoC early! Setting below 10 minutes may not function!")
		GUICtrlSetTip(-1, $txtTip)
	$txtPBTimeForcedExit = GUICtrlCreateInput("16", $x + 130, $y, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "txtSinglePBTimeForced")
		GUICtrlSetLimit(-1, 3)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$lblPBTimeForcedExit1 = GUICtrlCreateLabel( GetTranslated(603,9, -1), $x+162, $y+1, 27, 15)
	$x = 234
	$y +=30
	$chkTotalCampForced = GUICtrlCreateCheckbox(GetTranslated(636,46, "Force Total Army Camp")&":", $x-5, $y-5, -1, -1)
		GUICtrlSetOnEvent(-1, "chkTotalCampForced")
		GUICtrlSetTip(-1, GetTranslated(636,47, "If not detected set army camp values (instead ask)"))
	$txtTotalCampForced = GUICtrlCreateInput("200", $x + 130, $y - 5, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetLimit(-1, 3)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
