; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Attack Standard
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkSmartAttackRedAreaAB()
	If GUICtrlRead($g_hChkSmartAttackRedAreaAB) = $GUI_CHECKED Then
		$g_abAttackStdSmartAttack[$LB] = 1
		For $i = $g_hLblSmartDeployAB To $g_hPicAttackNearDarkElixirDrillAB
			GUICtrlSetState($i, $GUI_SHOW)
		Next
	Else
		$g_abAttackStdSmartAttack[$LB] = 0
		For $i = $g_hLblSmartDeployAB To $g_hPicAttackNearDarkElixirDrillAB
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf
EndFunc   ;==>chkSmartAttackRedAreaAB

Func chkSmartAttackRedAreaDB()
	If GUICtrlRead($g_hChkSmartAttackRedAreaDB) = $GUI_CHECKED Then
		$g_abAttackStdSmartAttack[$DB] = 1
		For $i = $g_hLblSmartDeployDB To $g_hPicAttackNearDarkElixirDrillDB
			GUICtrlSetState($i, $GUI_SHOW)
		Next
	Else
		$g_abAttackStdSmartAttack[$DB] = 0
		For $i = $g_hLblSmartDeployDB To $g_hPicAttackNearDarkElixirDrillDB
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf
EndFunc   ;==>chkSmartAttackRedAreaDB
