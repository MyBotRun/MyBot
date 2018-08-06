; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Standard Attack" tab under the "Attack" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: ProMac(07-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_DEADBASE_ATTACK_SMARTFARM = 0

Global $g_hCmbStandardUnitDelayDB1 , $g_hCmbStandardWaveDelayDB1 , $g_hChkRandomSpeedAtkDB1
Global $g_hTxtInsidePercentage = 0 , $g_hTxtOutsidePercentage = 0 , $g_hChkDebugSmartFarm = 0

Func CreateAttackSearchDeadBaseSmartFarm()

	$g_hGUI_DEADBASE_ATTACK_SMARTFARM = _GUICreate("", $_GUI_MAIN_WIDTH - 195, $g_iSizeHGrpTab4, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DEADBASE)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_DEADBASE_ATTACK_STANDARD)

	Local $sTxtTip = ""
	Local $x = 35, $y = 20
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Group_01", "Options"), $x - 20, $y - 20, 270, $g_iSizeHGrpTab4)

		$y += 25
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Lbl-CmbStandardUnitDelay", "Delay Unit") & ":", $x, $y + 5, -1, -1)
				$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Lbl-CmbStandardUnitDelay_Info_01", "This delays the deployment of troops, 1 (fast) = like a Bot, 10 (slow) = Like a Human.") & @CRLF & _
						   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Lbl-CmbStandardUnitDelay_Info_02", "Random will make bot more varied and closer to a person.")
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hCmbStandardUnitDelayDB1 = GUICtrlCreateCombo("", $x + 55, $y, 36, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "4")
				GUICtrlSetOnEvent(-1, "chkSpeedAtkDB")
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "Lbl-CmbStandardWaveDelay_Info_01", "Wave") & ":", $x + 100, $y + 5, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)
			$g_hCmbStandardWaveDelayDB1 = GUICtrlCreateCombo("", $x + 140, $y, 36, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "4")
				GUICtrlSetOnEvent(-1, "chkSpeedAtkDB")

		$y += 22
			$g_hChkRandomSpeedAtkDB1 = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Smart Farm", "ChkRandomSpeedAtk", "Randomize delay for Units && Waves"), $x, $y, -1, -1)
				_GUICtrlSetTip(-1, $sTxtTip)
				GUICtrlSetOnEvent(-1, "chkRandomSpeedAtkDB")

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