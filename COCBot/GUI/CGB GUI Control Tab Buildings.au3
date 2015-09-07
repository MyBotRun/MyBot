; #FUNCTION# ====================================================================================================================
; Name ..........: CGB GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func btnLocateUpgrades()
	$RunState = True
	While 1
		LocateUpgrades()
		ExitLoop
	WEnd
	$RunState = False
EndFunc   ;==>btnLocateUpgrades

Func btnchkbxUpgrade()
	For $i = 0 To 11
		If GUICtrlRead($chkbxUpgrade[$i]) = $GUI_CHECKED Then
			$ichkbxUpgrade[$i] = 1
		Else
			$ichkbxUpgrade[$i] = 0
		EndIf
	Next
EndFunc   ;==>btnchkbxUpgrade

Func btnResetUpgrade()
	; Reset Condition $aUpgrades[4][4] = [[-1, -1, -1, ""], [-1, -1, -1, ""], [-1, -1, -1, ""], [-1, -1, -1, ""]]
	For $i = 0 To 11
		$aUpgrades[$i][3] = "" ;Clear Upgrade Type
		GUICtrlSetData($txtUpgradeX[$i], "") ; Clear GUI X position
		GUICtrlSetData($txtUpgradeY[$i], "") ; Clear GUI Y position
		GUICtrlSetData($txtUpgradeValue[$i], "") ; Clear Upgrade value in GUI
		GUICtrlSetImage($picUpgradeType[$i], $pIconLib, $eIcnBlank) ; change GUI upgrade image to blank
		$ipicUpgradeStatus[$i] =  $eIcnRedLight
		GUICtrlSetImage($picUpgradeStatus[$i], $pIconLib, $ipicUpgradeStatus[$i]) ; Change GUI upgrade status to not ready
		GUICtrlSetState($chkbxUpgrade[$i], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
		For $j = 0 To 2
			$aUpgrades[$i][$j] = -1 ; clear location and loot value in $aUpgrades variable
		Next
	Next
EndFunc   ;==>btnResetUpgrade

