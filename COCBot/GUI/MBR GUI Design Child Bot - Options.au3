; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Options" tab under the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

;$hGUI_BotOptions = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_BOT)
;GUISwitch($hGUI_BotOptions)

Global $g_hCmbGUILanguage = 0
Global $g_hChkDisableSplash = 0, $g_hChkForMBRUpdates = 0, $g_hChkDeleteLogs = 0, $g_hTxtDeleteLogsDays = 0, $g_hChkDeleteTemp = 0, $g_hTxtDeleteTempDays = 0, _
	   $g_hChkDeleteLoots = 0, $g_hTxtDeleteLootsDays = 0
Global $g_hChkAutostart = 0, $g_hTxtAutostartDelay = 0, $g_hChkCheckGameLanguage = 0, $g_hChkAutoAlign = 0, $g_hTxtAlignOffsetX = 0, $g_hTxtAlignOffsetY = 0, _
	   $g_hCmbAlignmentOptions = 0
Global $g_hChkUpdatingWhenMinimized = 0, $g_hChkHideWhenMinimized = 0, $g_hChkUseRandomClick = 0, $g_hChkScreenshotType = 0, $g_hChkScreenshotHideName = 0, _
	   $g_hTxtTimeAnotherDevice = 0
Global $g_hChkSinglePBTForced = 0, $g_hTxtSinglePBTimeForced = 0, $g_hTxtPBTimeForcedExit = 0, $g_hChkFixClanCastle = 0, $g_hChkAutoResume = 0, $g_hTxtAutoResumeTime = 0

Func CreateBotOptions()

   Local $sTxtTip = ""
   Local $x = 25, $y = 45
   GUICtrlCreateGroup(GetTranslated(636,83, "GUI Language"), $x - 20, $y - 20, 210, 47)
	   $y -=2
	   $g_hCmbGUILanguage = _GUICtrlComboBoxEx_Create($g_hGUI_BOT,"",$x - 8, $y, 185, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	   _GUICtrlSetTip(_GUICtrlComboBoxEx_GetComboControl($g_hCmbGUILanguage), GetTranslated(636,84, "Use this to switch to a different GUI language"), Default, Default, Default, False)

	   LoadLanguagesComboBox() ; full combo box languages reading from languages folders

   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $y += 54
   GUICtrlCreateGroup(GetTranslated(636,2, "When Bot Loads"), $x - 20, $y - 20, 210, 120)
	   $y -= 4
	   $g_hChkDisableSplash = GUICtrlCreateCheckbox(GetTranslated(636,100, "Disable Splash Screen"), $x, $y, -1, -1)
		   _GUICtrlSetTip(-1, GetTranslated(636,101, "Disables the splash screen on startup."))
		   GUICtrlSetState(-1, $GUI_UNCHECKED)

	   $y += 20
	   $g_hChkForMBRUpdates = GUICtrlCreateCheckbox(GetTranslated(636,3, "Check for Updates"), $x, $y, -1, -1)
		   _GUICtrlSetTip(-1, GetTranslated(636,4, "Check if you are running the latest version of the bot."))
		   GUICtrlSetState(-1, $GUI_CHECKED)

	   $y += 20
	   $g_hChkDeleteLogs = GUICtrlCreateCheckbox(GetTranslated(636,5, "Delete Log Files")& ":", $x, $y, -1, -1)
		   $sTxtTip = GetTranslated(636,6, "Delete log files older than this specified No. of days.")
		   GUICtrlSetState(-1, $GUI_CHECKED)
		   _GUICtrlSetTip(-1, $sTxtTip)
		   GUICtrlSetOnEvent(-1, "chkDeleteLogs")
	   $g_hTxtDeleteLogsDays = GUICtrlCreateInput("2", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		   _GUICtrlSetTip(-1, $sTxtTip)
		   GUICtrlSetLimit(-1, 2)
		   GUICtrlSetFont(-1, 8)
	   GUICtrlCreateLabel(GetTranslated(636,7, "days"), $x + 150, $y + 4, 27, 15)

	   $y += 20
	   $g_hChkDeleteTemp = GUICtrlCreateCheckbox(GetTranslated(636,8, "Delete Temp Files") & ":", $x, $y, -1, -1)
		   GUICtrlSetState(-1, $GUI_CHECKED)
		   _GUICtrlSetTip(-1, GetTranslated(636,9, "Delete temp files older than this specified No. of days."))
		   GUICtrlSetOnEvent(-1, "chkDeleteTemp")
	   $g_hTxtDeleteTempDays = GUICtrlCreateInput("2", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		   _GUICtrlSetTip(-1, $sTxtTip)
		   GUICtrlSetLimit(-1, 2)
		   GUICtrlSetFont(-1, 8)
	   GUICtrlCreateLabel(GetTranslated(636,7, "days"), $x + 150, $y + 4, 27, 15)

	   $y += 20
	   $g_hChkDeleteLoots = GUICtrlCreateCheckbox(GetTranslated(636,10, "Delete Loot Images"), $x, $y, -1, -1)
		   $sTxtTip = GetTranslated(636,11, "Delete loot image files older than this specified No. of days.")
		   GUICtrlSetState(-1, $GUI_CHECKED)
		   _GUICtrlSetTip(-1, $sTxtTip)
		   GUICtrlSetOnEvent(-1, "chkDeleteLoots")
	   $g_hTxtDeleteLootsDays = GUICtrlCreateInput("2", $x + 120, $y + 2, 25, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		   _GUICtrlSetTip(-1, $sTxtTip)
		   GUICtrlSetLimit(-1, 2)
		   GUICtrlSetFont(-1, 8)
	   GUICtrlCreateLabel(GetTranslated(636,7, "days"), $x + 150, $y + 4, 27, 15)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $y += 48
   GUICtrlCreateGroup(GetTranslated(636,12, "When Bot Starts"), $x - 20, $y - 20, 210, 112)
	   $y -= 5
	   $g_hChkAutostart = GUICtrlCreateCheckbox(GetTranslated(636,13, "Auto START after") & ":", $x, $y, -1, -1)
		   _GUICtrlSetTip(-1, GetTranslated(636,58, "Auto START the Bot after this No. of seconds."))
		   GUICtrlSetOnEvent(-1, "chkAutostart")
	   $g_hTxtAutostartDelay = GUICtrlCreateInput("10", $x + 120, $y + 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		   GUICtrlSetFont(-1, 8)
		   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel(GetTranslated(603,6, "sec."), $x + 150, $y + 4, 27, 18)

	   $y += 22
	   $g_hChkCheckGameLanguage = GUICtrlCreateCheckbox(GetTranslated(636,15, "Check Game Language (EN)"), $x, $y, -1, -1)
		   _GUICtrlSetTip(-1, GetTranslated(636,16, "Check if the Game is set to the correct language (Must be set to English)."))
		   GUICtrlSetState(-1, $GUI_CHECKED)

	   $y += 22
	   $g_hChkAutoAlign = GUICtrlCreateCheckbox(GetTranslated(636,17, "Auto Align"), $x, $y, -1, -1)
		   $sTxtTip = GetTranslated(636,18, "Reposition/Align Android Emulator and BOT windows on the screen.")
		   GUICtrlSetOnEvent(-1, "chkDisposeWindows")
		   _GUICtrlSetTip(-1, $sTxtTip)
		   GUICtrlSetLimit(-1, 2)
	   GUICtrlCreateLabel(GetTranslated(636,19, "Offset") & ":", $x + 85, $y + 4, -1, -1)
	   $g_hTxtAlignOffsetX = GUICtrlCreateInput("10", $x + 120, $y + 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		   $sTxtTip = GetTranslated(636,20, "Offset horizontal pixels between Android Emulator and BOT windows.")
		   _GUICtrlSetTip(-1, $sTxtTip)
		   GUICtrlSetLimit(-1, 2)
		   GUICtrlSetFont(-1, 8)
	   $g_hTxtAlignOffsetY= GUICtrlCreateInput("0", $x + 150, $y + 2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		   $sTxtTip = GetTranslated(636,21, "Offset vertical pixels between Android Emulator and BOT windows.")
		   _GUICtrlSetTip(-1, $sTxtTip)
		   GUICtrlSetLimit(-1, 2)
		   GUICtrlSetFont(-1, 8)

	   $y += 23
	   $g_hCmbAlignmentOptions = GUICtrlCreateCombo("", $x, $y, 175, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		   GUICtrlSetData(-1, GetTranslated(636,22, "0,0: Android Emulator-Bot") & "|" & _
							  GetTranslated(636,23, "0,0: Bot-Android Emulator") & "|" & _
							  GetTranslated(636,24, "SNAP: Bot TopRight to Android") &"|" & _
							  GetTranslated(636,25, "SNAP: Bot TopLeft to Android") & "|" & _
							  GetTranslated(636,26, "SNAP: Bot BottomRight to Android") & "|" & _
							  GetTranslated(636,27, "SNAP: Bot BottomLeft to Android") & "|" & _
							  GetTranslated(636,95, "DOCK: Android into Bot"), _
							  GetTranslated(636,24, "SNAP: Bot TopRight to Android"))
		   _GUICtrlSetTip(-1, GetTranslated(636,28, "0,0: Reposition Android Emulator screen to position 0,0 on windows desktop and align Bot window right or left to it.") & @CRLF & _
							  GetTranslated(636,29, "SNAP: Only reorder windows, Align Bot window to Android Emulator window at Top Right, Top Left, Bottom Right or Bottom Left.\r\n" & _
												    "DOCK: Integrate Android Screen into bot window."))
		   GUICtrlSetState(-1, $GUI_DISABLE)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   Local $x = 240, $y = 45
   GUICtrlCreateGroup(GetTranslated(636,93, "Advanced"), $x - 20, $y - 20, 225, 102)
	   $g_hChkUpdatingWhenMinimized = GUICtrlCreateCheckbox(GetTranslated(636,96, "Updating when minimized"), $x, $y, -1, -1)
		   GUICtrlSetState(-1, $GUI_DISABLE) ; must be always enabled
		   GUICtrlSetOnEvent(-1, "chkUpdatingWhenMinimized")
		   _GUICtrlSetTip(-1, GetTranslated(636,97, "Enable different minimize routine for bot window.\r\nWhen bot is minimized, screen updates are shown in taskbar preview."))
	   $y += 19
	   $g_hChkHideWhenMinimized = GUICtrlCreateCheckbox(GetTranslated(636,98, "Hide when minimized"), $x, $y, -1, -1)
		   GUICtrlSetOnEvent(-1, "chkHideWhenMinimized")
		   _GUICtrlSetTip(-1, GetTranslated(636,99, "Hide bot window in taskbar when minimized.\r\nUse trayicon 'Show bot' to display bot window again."))
		$y += 19
		$g_hChkAutoResume = GUICtrlCreateCheckbox(GetTranslated(636, 122, "Auto resume Bot after"), $x, $y + 2, -1, -1)
			_GUICtrlSetTip(-1,GetTranslated(636, 123, "This will auto resume your bot after x minutes"))
			GUICtrlSetOnEvent(-1, "chkAutoResume")
		$g_hTxtAutoResumeTime = GUICtrlCreateInput("5",$x + 132, $y + 5, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlCreateLabel( GetTranslated(603,10, -1), $x+167, $y+5, 27, 15)
		$y += 19
	   $g_hChkUseRandomClick = GUICtrlCreateCheckbox(GetTranslated(636,94, "Random Click"), $x, $y, -1, -1)
		   GUICtrlSetOnEvent(-1, "chkUseRandomClick")
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $y += 47
   GUICtrlCreateGroup(GetTranslated(636,55, "Photo Screenshot Options"), $x - 20, $y - 17, 225, 60)
	   $g_hChkScreenshotType = GUICtrlCreateCheckbox(GetTranslated(636,56, "Make in PNG format"), $x, $y, -1, -1)
		   GUICtrlSetState(-1, $GUI_CHECKED)
		   GUICtrlSetOnEvent(-1, "chkScreenshotType")
	   $y += 19
	   $g_hChkScreenshotHideName = GUICtrlCreateCheckbox(GetTranslated(636,57, "Hide Village and Clan Castle Name"), $x, $y, -1, -1)
		   GUICtrlSetState(-1, $GUI_CHECKED)
		   GUICtrlSetOnEvent(-1, "chkScreenshotHideName")
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $y +=48
   GUICtrlCreateGroup(GetTranslated(636,85, "Remote Device"), $x - 20, $y - 20 , 225, 42)
	   $y -= 5
	   GUICtrlCreateLabel(GetTranslated(636,86, "When 'Another Device' wait") & ":", $x - 10, $y + 2, -1, -1)
	   $sTxtTip = GetTranslated(636,87, "Enter the time to wait (in Minutes) before the Bot reconnects when another device took control.")
		   _GUICtrlSetTip(-1, $sTxtTip)
	   $g_hTxtTimeAnotherDevice = GUICtrlCreateInput("2", $x + 127, $y - 1, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		   _GUICtrlSetTip(-1, $sTxtTip)
		   GUICtrlSetLimit(-1, 3)
	   GUICtrlCreateLabel(GetTranslated(603,10, "min."), $x + 165, $y + 2, -1, -1)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $y+= 51
   GUICtrlCreateGroup(GetTranslated(636,45, "Other Options"), $x - 20, $y - 20, 225, 85)
	  $g_hChkSinglePBTForced = GUICtrlCreateCheckbox(GetTranslated(636,61, "Force Single PB logoff"), $x-5, $y, -1, -1)
		  GUICtrlSetOnEvent(-1, "chkSinglePBTForced")
		  _GUICtrlSetTip(-1, GetTranslated(636,62, "This forces bot to exit CoC only one time prior to normal start of PB"))
	  $g_hTxtSinglePBTimeForced = GUICtrlCreateInput("18", $x + 130, $y-1, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		  _GUICtrlSetTip(-1, GetTranslated(636,63, "Type in number of minutes to keep CoC closed. Set to 15 minimum to reset PB timer!"))
		  GUICtrlSetOnEvent(-1, "txtSinglePBTimeForced")
		  GUICtrlSetLimit(-1, 3)
		  GUICtrlSetState(-1, $GUI_DISABLE)
	  GUICtrlCreateLabel( GetTranslated(603,10, -1), $x+162, $y+2, 27, 15)

	  $y += 20
	  GUICtrlCreateLabel( GetTranslated(636,65, "Subtract time for early PB exit"), $x-10, $y+3)
		  $sTxtTip = GetTranslated(636,66, "Type in number of minutes to quit CoC early! Setting below 10 minutes may not function!")
		  _GUICtrlSetTip(-1, $sTxtTip)
	  $g_hTxtPBTimeForcedExit = GUICtrlCreateInput("16", $x + 130, $y, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		  _GUICtrlSetTip(-1, $sTxtTip)
		  GUICtrlSetOnEvent(-1, "txtSinglePBTimeForced")
		  GUICtrlSetLimit(-1, 3)
		  GUICtrlSetState(-1, $GUI_DISABLE)
	  GUICtrlCreateLabel( GetTranslated(603,10, -1), $x+162, $y+1, 27, 15)

	  $y +=20
	  $g_hChkFixClanCastle = GUICtrlCreateCheckbox(GetTranslated(636,104, "Force Clan Castle Detection"), $x-5, $y + 2, -1, -1)
		  _GUICtrlSetTip(-1, GetTranslated(636,105, "If clan Castle it is undetected and it is NOT placed in the last slot, force bot to consider the undetected slot as Clan Castle"))
		  GUICtrlSetState(-1, $GUI_UNCHECKED)

   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
