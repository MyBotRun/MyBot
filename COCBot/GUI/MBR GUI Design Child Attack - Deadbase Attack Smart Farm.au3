; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Standard Attack" tab under the "Attack" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: ProMac(07-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_DEADBASE_ATTACK_SMARTFARM = 0

Global $g_hTxtInsidePercentage = 0 , $g_hTxtOutsidePercentage = 0 , $g_hChkDebugSmartFarm = 0

Func CreateAttackSearchDeadBaseSmartFarm()

	$g_hGUI_DEADBASE_ATTACK_SMARTFARM = _GUICreate("", $_GUI_MAIN_WIDTH - 195, $g_iSizeHGrpTab4, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DEADBASE)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_DEADBASE_ATTACK_STANDARD)

	Local $sTxtTip = ""
	Local $x = 35, $y = 20
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Group_01", "Options"), $x - 20, $y - 20, 270, $g_iSizeHGrpTab4)

		$y += 40
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Lbl-TxtInsidePercentage", "Inside resources") & ":", $x, $y + 2, -1, -1)
			$g_hTxtInsidePercentage = GUICtrlCreateInput("65" , $x + 90, $y , 25 , -1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "txt-TxtInsidePercentage", "Percentage to force attack in one side only"))
			GUICtrlCreateLabel("%" , $x + 117 , $y + 3)
		$y += 22
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Lbl-TxtOutsidePercentage", "Outside resources") & ":", $x, $y + 2, -1, -1)
			$g_hTxtOutsidePercentage = GUICtrlCreateInput("80" , $x + 90 , $y , 25 , -1)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "txt-TxtOutsidePercentage", "Percentage to force attack in 4 sides"))
			GUICtrlCreateLabel("%" , $x + 117 , $y + 3)
		$y += 40
		$x = 98
			$g_hBtnCustomDropOrderDB = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnCustomDropOrder", "Drop Order"), $x, $y, 85, 25)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnCustomDropOrder_Info_01", "Select Custom Troops Dropping Order"))
				GUICtrlSetOnEvent(-1, "CustomDropOrder")
		$x = 35
			$g_hChkDebugSmartFarm = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "ChkDebugSmartFarm", "Debug Smart Farm"), $x, $y + 100, -1, -1)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchDeadBaseStandard