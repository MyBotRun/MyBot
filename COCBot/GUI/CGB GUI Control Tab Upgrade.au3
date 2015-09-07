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

Func chkWalls()
	If GUICtrlRead($chkWalls) = $GUI_CHECKED Then
		$ichkWalls = 1
		GUICtrlSetState($UseGold, $GUI_ENABLE)
		;		GUICtrlSetState($UseElixir, $GUI_ENABLE)
		;		GUICtrlSetState($UseElixirGold, $GUI_ENABLE)
		GUICtrlSetState($cmbWalls, $GUI_ENABLE)
		GUICtrlSetState($txtWallMinGold, $GUI_ENABLE)
		;		GUICtrlSetState($txtWallMinElixir, $GUI_ENABLE)

		cmbWalls()
	Else
		$ichkWalls = 0
		GUICtrlSetState($UseGold, $GUI_DISABLE)
		GUICtrlSetState($UseElixir, $GUI_DISABLE)
		GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
		GUICtrlSetState($cmbWalls, $GUI_DISABLE)
		GUICtrlSetState($txtWallMinGold, $GUI_DISABLE)
		GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)

	EndIf
EndFunc   ;==>chkWalls

Func chkSaveWallBldr()
	If GUICtrlRead($chkSaveWallBldr) = $GUI_CHECKED Then
		$iSaveWallBldr = 1
	Else
		$iSaveWallBldr = 0
	EndIf
EndFunc   ;==>chkSaveWallBldr

Func cmbWalls()
	Switch _GUICtrlComboBox_GetCurSel($cmbWalls)
		Case 0
			$WallCost = 30000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
			GUICtrlSetState($UseGold, $GUI_CHECKED)
			GUICtrlSetState($UseElixir, $GUI_DISABLE)
			GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
		Case 1
			$WallCost = 75000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
			GUICtrlSetState($UseGold, $GUI_CHECKED)
			GUICtrlSetState($UseElixir, $GUI_DISABLE)
			GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
		Case 2
			$WallCost = 200000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
			GUICtrlSetState($UseGold, $GUI_CHECKED)
			GUICtrlSetState($UseElixir, $GUI_DISABLE)
			GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
		Case 3
			$WallCost = 500000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
			GUICtrlSetState($UseGold, $GUI_CHECKED)
			GUICtrlSetState($UseElixir, $GUI_DISABLE)
			GUICtrlSetState($UseElixirGold, $GUI_DISABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_DISABLE)
		Case 4
			$WallCost = 1000000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
			GUICtrlSetState($UseElixir, $GUI_ENABLE)
			GUICtrlSetState($UseElixirGold, $GUI_ENABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_ENABLE)
		Case 5
			$WallCost = 3000000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
			GUICtrlSetState($UseElixir, $GUI_ENABLE)
			GUICtrlSetState($UseElixirGold, $GUI_ENABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_ENABLE)
		Case 6
			$WallCost = 4000000
			GUICtrlSetData($lblWallCost, StringRegExpReplace($WallCost, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 "))
			GUICtrlSetState($UseElixir, $GUI_ENABLE)
			GUICtrlSetState($UseElixirGold, $GUI_ENABLE)
			GUICtrlSetState($txtWallMinElixir, $GUI_ENABLE)
	EndSwitch
EndFunc   ;==>cmbWalls

Func chkLab()
	If GUICtrlRead($chkLab) = $GUI_CHECKED Then
		$ichkLab = 1
		GUICtrlSetState($icnLabUpgrade, $GUI_SHOW)
		GUICtrlSetState($lblNextUpgrade, $GUI_ENABLE)
		GUICtrlSetState($cmbLaboratory, $GUI_ENABLE)
		GUICtrlSetState($btnLocateLaboratory, $GUI_SHOW)
		GUICtrlSetImage($icnLabUpgrade, $pIconLib, $aLabTroops[$icmbLaboratory][4])
	Else
		$ichkLab = 0
		GUICtrlSetState($icnLabUpgrade, $GUI_HIDE)
		GUICtrlSetState($lblNextUpgrade, $GUI_DISABLE)
		GUICtrlSetState($cmbLaboratory, $GUI_DISABLE)
		GUICtrlSetState($btnLocateLaboratory, $GUI_HIDE)
		GUICtrlSetImage($icnLabUpgrade, $pIconLib, $aLabTroops[0][4])
	EndIf
EndFunc   ;==>chkLab

Func cmbLab()
	$icmbLaboratory = _GUICtrlComboBox_GetCurSel($cmbLaboratory)
	GUICtrlSetImage($icnLabUpgrade, $pIconLib, $aLabTroops[$icmbLaboratory][4])
EndFunc   ;==>cmbLab


Func ichkUpgradeKing()
	If GUICtrlRead($chkUpgradeKing) = $GUI_CHECKED Then
		$ichkUpgradeKing = 1
	Else
		$ichkUpgradeKing = 0
	EndIf
EndFunc 

Func ichkUpgradeQueen()
	If GUICtrlRead($chkUpgradeQueen) = $GUI_CHECKED Then
		$ichkUpgradeQueen = 1
	Else
		$ichkUpgradeQueen = 0
	EndIf
EndFunc 
