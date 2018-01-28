; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Bot Android
; Description ...: This file creates the "Android" tab under the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hCmbCOCDistributors = 0, $g_hCmbAndroidBackgroundMode = 0, $g_hCmbSuspendAndroid = 0, $g_hChkAndroidAdbClickDragScript = 0, $g_hBtnAndroidAdbShell = 0, $g_hBtnAndroidHome = 0, $g_hBtnAndroidBack = 0, _
	$g_hTxtAndroidRebootHours = 0, $g_hChkAndroidCloseWithBot = 0

Func CreateBotAndroid()

	Local $x = 25, $y = 45, $y2, $w = 240, $h = 50, $sTxtTip
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR Distributors", "Group_01", "Distributors"), $x - 20, $y - 20, $w, $h) ; $g_iSizeWGrpTab2, $g_iSizeHGrpTab2
	$y -= 2
		$g_hCmbCOCDistributors = GUICtrlCreateCombo("", $x - 8, $y, $w - 25, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Distributors", "CmbCOCDistributors_Info_01", "Allow bot to launch COC based on the distribution chosen"))
			GUICtrlSetOnEvent(-1, "cmbCOCDistributors")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += $h + 5
	$y2 = $y
	$w = $g_iSizeWGrpTab2 - 2
	$h = 121
	GUICtrlCreateGroup(GetTranslatedFileIni("Android", "Android_Options", "Android Options"), $x - 20, $y - 20, $w, $h)
	;$y -= 2
		GUICtrlCreateLabel(GetTranslatedFileIni("Android", "LblBackgroundMode", "Screencapture Background Mode"), $x - 8, $y + 5, 180, 22, $SS_RIGHT)
		$g_hCmbAndroidBackgroundMode = GUICtrlCreateCombo("", $x - 8 + 180 + 5, $y, 200, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("Android", "CmbBackgroundMode", "Default|Use WinAPI (need Android DirectX)|Use ADB screencap"))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("Android", "CmbBackgroundMode_Info", 'Control how the Android screenshot is taken in background mode.\nDefault chooses WinAPI or screencap based on Android Emulator.\nInfo: WinAPI is faster than screencap, but screencap always works,\neven if screen is off (we call that the "True Background Mode")!'))
			_GUICtrlComboBox_SetCurSel(-1, $g_iAndroidBackgroundMode)
			GUICtrlSetOnEvent(-1, "cmbAndroidBackgroundMode")
	$y += 25
		$g_hChkAndroidAdbClickDragScript = GUICtrlCreateCheckbox(GetTranslatedFileIni("Android", "ChkAdbClickDragScript", "Use script for accurate Click && Drag"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("Android", "ChkAdbClickDragScript_Info", "Use Android specific script file for Click & Drag.\r\nIf unchecked use more compatible 'input swipe'."))
			GUICtrlSetState(-1, (($g_bAndroidAdbClickDragScript) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))

	$y += 25
		$g_hChkAndroidCloseWithBot = GUICtrlCreateCheckbox(GetTranslatedFileIni("Android", "ChkAndroidCloseWithBot", "Close Android with bot"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("Android", "ChkAndroidCloseWithBot_Info", "Close also Android Emulator when bot exists."))
			GUICtrlSetState(-1, (($g_bAndroidCloseWithBot) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))

	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("Android", "LblAndroidRebootHours", "Reboot Android in") & ":", $x + 17, $y + 2, -1, -1)
			$sTxtTip = GetTranslatedFileIni("Android", "LblAndroidRebootHours_Info", "Enter hours when Android will be automatically rebooted after specified run-time.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtAndroidRebootHours = GUICtrlCreateInput($g_iAndroidRebootHours, $x + 177, $y + 1, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 4)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "hrs", -1), $x + 212, $y + 2, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y = $y2 + $h + 5
	$w = $g_iSizeWGrpTab2 - 2
	$h = 50
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR Distributors", "Group_02", "Advanced Android Options"), $x - 20, $y - 20, $w, $h)
	$y -= 2
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Distributors", "LblAdvanced_Android_Options", "Suspend/Resume Android"), $x - 8, $y + 5, 180, 22, $SS_RIGHT)
		$g_hCmbSuspendAndroid = GUICtrlCreateCombo("", $x - 8 + 180 + 5, $y, 200, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR Distributors", "CmbSuspendAndroid_Item_01", "Disabled|Only during Search/Attack|For every Image processing call"))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Distributors", "CmbSuspendAndroid_Info_01", 'Specify if Android will be suspended for brief time only during search and attack or\r\nfor every ImgLoc/Image processing call. If you experience more frequent network issues\r\ntry to use "Only during Search/Attack" option or disable this feature.'))
			_GUICtrlComboBox_SetCurSel(-1, AndroidSuspendFlagsToIndex($g_iAndroidSuspendModeFlags))
			GUICtrlSetOnEvent(-1, "cmbSuspendAndroid")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += $h + 5
	$y2 = $y
	$w = 240
	$h = 80
	GUICtrlCreateGroup(GetTranslatedFileIni("Android Control", "Group_03", "Android Control"), $x - 20, $y - 20, $w, $h)
	$y -= 2
		$g_hBtnAndroidAdbShell = GUICtrlCreateButton(GetTranslatedFileIni("Android Control", "BtnAndroidAdbShell", "Start ADB Shell in new Console Window"), $x - 8, $y, 220, 25)
			GUICtrlSetOnEvent(-1, "OpenAdbShell")
	$y += 30
		$g_hBtnAndroidHome = GUICtrlCreateButton(GetTranslatedFileIni("Android Control", "BtnAndroidHome", "Send Home"), $x - 8, $y, 105, 25)
			GUICtrlSetOnEvent(-1, "AndroidHomeButton")
		$g_hBtnAndroidBack = GUICtrlCreateButton(GetTranslatedFileIni("Android Control", "BtnAndroidBack", "Send Back"), $x - 8 + 115, $y, 105, 25)
			GUICtrlSetOnEvent(-1, "AndroidBackButton")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	;$x = 25 + $g_iSizeWGrpTab2 - 2 - 10 - $w
	$x = 25 + 240 + 10 + 30
	$y = $y2
	$w = 125
	$h = 80
	GUICtrlCreateGroup(GetTranslatedFileIni("Android Control", "Group_04", "Install Play Store Apps"), $x - 20, $y - 20, $w, $h)
	$y -= 2
		GUICtrlCreateButton(GetTranslatedFileIni("Android Control", "BtnPlayStoreGame", "Clash of Clans"), $x - 8, $y, 100, 25)
			GUICtrlSetOnEvent(-1, "OpenPlayStoreGame")
	$y += 30
		GUICtrlCreateButton(GetTranslatedFileIni("Android Control", "BtnPlayStoreNovaLauncher", "Nova Launcher"), $x - 8, $y, 100, 25)
			GUICtrlSetOnEvent(-1, "OpenPlayStoreNovaLauncher")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 130
	$x -= 60
		GUICtrlCreateLabel("Command line Help ?", $x - 20, $y - 20, 220, 24, $SS_RIGHT)
			GUICtrlSetOnEvent(-1, "ShowCommandLineHelp")
			GUICtrlSetCursor(-1, 0)
			GUICtrlSetFont(-1, 8.5, $FW_BOLD)
			_GUICtrlSetTip(-1, "Click here to get help about command line and option for MyBot.run!")
			GUICtrlSetColor(-1, $COLOR_NAVY)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateBotAndroid
