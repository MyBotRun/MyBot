; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Collectors" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hChkDBDisableCollectorsFilter = 0, $g_hChkSupercharge = 0
Global $g_hCmbMinCollectorMatches = 0, $g_hSldCollectorTolerance = 0, $g_hLblCollectorWarning = 0

Func CreateAttackSearchDeadBaseCollectors()
	Local $x = 10, $y = 45
	Local $sTxtTip = ""

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "Group_01", "Collectors"), $x - 5, $y - 20, $g_iSizeWGrpTab4, 115)

	$y += 15
	$g_hChkDBDisableCollectorsFilter = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDisableCollectorsFilter", "Disable Collector Filter"), $x + 20, $y + 15, -1, 18)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "chkDBDisableCollectorsFilter")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "ChkDisableCollectorsFilter_Info_01", "Disable Collector Filter CHANGES DeadBase into another ActiveBase search"))

	$g_hChkSupercharge = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "chkSupercharge", "Look For Supercharge Collectors"), $x + 202, $y, -1, 18)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "chkSupercharge_Info_01", "Also look for Supercharge collectors") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "chkSupercharge_Info_02", "Will slightly increase collector detection time") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "chkSupercharge_Info_03", "Will Be Useful From TH14"))

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblMinCollectorMatches", "Collectors required"), $x + 202, $y + 30, -1, -1)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "CmbMinCollectorMatches_Info_01", 'Select how many collectors are needed to consider village "dead"')
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hCmbMinCollectorMatches = GUICtrlCreateCombo("", $x + 305, $y + 26, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetData(-1, "1|2|3|4|5|6|7", "3")
	GUICtrlSetOnEvent(-1, "cmbMinCollectorMatches")

	$y += 25
	GUICtrlCreateLabel("-15" & _PadStringCenter(GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "LblCollectorTolerance", "Tolerance"), 66, " ") & "15", $x, $y)
	;If $g_bDevMode = False Then
	GUICtrlSetState(-1, $GUI_HIDE)
	;EndIf

	$y += 15
	$g_hSldCollectorTolerance = GUICtrlCreateSlider($x, $y, 250, 20, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "SldCollectorTolerance_Info_01", "Use this slider to adjust the tolerance of ALL images.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "SldCollectorTolerance_Info_02", "If you want to adjust individual images, you must edit the files.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Deadbase-Collectors", "SldCollectorTolerance_Info_03", "WARNING: Do not change this setting unless you know what you are doing. Set it to 0 if you're not sure."))
	_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
	_GUICtrlSlider_SetTicFreq(-1, 1)
	GUICtrlSetLimit(-1, 15, -15)         ; change max/min value
	GUICtrlSetData(-1, 0)         ; default value
	GUICtrlSetOnEvent(-1, "sldCollectorTolerance")
	;If $g_bDevMode = False Then
	GUICtrlSetState(-1, $GUI_HIDE)
	;EndIf

	$y += 25
	$g_hLblCollectorWarning = GUICtrlCreateLabel("Warning: no collecters are selected. The bot will never find a dead base.", $x, $y, 255, 30)
	GUICtrlSetFont(-1, 10, $FW_BOLD)
	GUICtrlSetColor(-1, $COLOR_ERROR)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchDeadBaseCollectors
