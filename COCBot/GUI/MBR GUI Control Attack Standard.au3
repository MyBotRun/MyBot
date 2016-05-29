; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Attack Standard
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func chkRandomSpeedAtkAB()
	If GUICtrlRead($chkRandomSpeedAtkAB) = $GUI_CHECKED Then
		;$iChkABRandomSpeedAtk = 1
		GUICtrlSetState($cmbUnitDelayAB, $GUI_DISABLE)
		GUICtrlSetState($cmbWaveDelayAB, $GUI_DISABLE)
	Else
		;$iChkABRandomSpeedAtk = 0
		GUICtrlSetState($cmbUnitDelayAB, $GUI_ENABLE)
		GUICtrlSetState($cmbWaveDelayAB, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkRandomSpeedAtkAB

Func chkSmartAttackRedAreaAB()
	If GUICtrlRead($chkSmartAttackRedAreaAB) = $GUI_CHECKED Then
		$iChkRedArea[$LB] = 1
		For $i = $lblSmartDeployAB To $picAttackNearDarkElixirDrillAB
			GUICtrlSetState($i, $GUI_SHOW)
		Next
	Else
		$iChkRedArea[$LB] = 0
		For $i = $lblSmartDeployAB To $picAttackNearDarkElixirDrillAB
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf
EndFunc   ;==>chkSmartAttackRedAreaAB
Func chkRandomSpeedAtkDB()
	If GUICtrlRead($chkRandomSpeedAtkDB) = $GUI_CHECKED Then
		;$iChkDBRandomSpeedAtk = 1
		GUICtrlSetState($cmbUnitDelayDB, $GUI_DISABLE)
		GUICtrlSetState($cmbWaveDelayDB, $GUI_DISABLE)
	Else
		;$iChkDBRandomSpeedAtk = 0
		GUICtrlSetState($cmbUnitDelayDB, $GUI_ENABLE)
		GUICtrlSetState($cmbWaveDelayDB, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkRandomSpeedAtkDB

Func chkSmartAttackRedAreaDB()
	If GUICtrlRead($chkSmartAttackRedAreaDB) = $GUI_CHECKED Then
		$iChkRedArea[$LB] = 1
		For $i = $lblSmartDeployDB To $picAttackNearDarkElixirDrillDB
			GUICtrlSetState($i, $GUI_SHOW)
		Next
	Else
		$iChkRedArea[$LB] = 0
		For $i = $lblSmartDeployDB To $picAttackNearDarkElixirDrillDB
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf
EndFunc   ;==>chkSmartAttackRedAreaDB
