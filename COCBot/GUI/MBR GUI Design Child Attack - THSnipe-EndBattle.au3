; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "End Battle" tab under the "TH Snipe" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hChkTSActivateCamps2 = 0, $g_hTxtTSArmyCamps2 = 0
Global $g_hGrpTSEndBattle = 0, $g_hLblTSArmyCamps2 = 0

Func CreateAttackSearchTHSnipeEndBattle()

	Local $x = 10, $y = 45
	$g_hGrpTSEndBattle = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "Group_01", -1), $x - 5, $y - 20, $g_iSizeWGrpTab4, $g_iSizeHGrpTab4)
	;Apply to switch Attack Standard after THSnipe End ==>
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "LblSwitch_DB_Attack_at_END", "Switch DB Attack at END") & ":", $x, $y, 143, 18, $SS_LEFT)
	$y += 15
		;chk camps
		$g_hChkTSActivateCamps2 = GUICtrlCreateCheckbox("", $x + 2, $y + 3, 16, 16)
			GUICtrlSetOnEvent(-1, "chkTSActivateCamps2")

		;Army camps %
		$g_hLblTSArmyCamps2 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "LblCamps", "Camps") & " >=", $x + 20, $y + 4, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hTxtTSArmyCamps2 = GUICtrlCreateInput("50", $x + 75, $y, 35, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - EndBattle", "TxtArmyCamps2_Info_01", "Set the % Army camps before activate this option"))
			GUICtrlSetLimit(-1, 6)

		;camps %
		GUICtrlCreateLabel("%", $x + 115, $y + 4, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 26
	;==> Apply to switch Attack Standard after THSnipe End

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchTHSnipeEndBattle
