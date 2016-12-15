; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Milking
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
Func chkAtkGoldMines()
	If GUICtrlRead($chkAtkGoldMines) = $GUI_CHECKED Then
		GUICtrlSetState($cmbAtkGoldMinesLevel, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbAtkGoldMinesLevel, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAtkGoldMines
Func chkAtkDarkDrills()
	If GUICtrlRead($chkAtkDarkDrills) = $GUI_CHECKED Then
		GUICtrlSetState($cmbAtkDarkDrillsLevel, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbAtkDarkDrillsLevel, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAtkDarkDrills
Func chkAttackMinesifGold()
	If GUICtrlRead($chkAttackMinesifGold) = $GUI_CHECKED Then
		GUICtrlSetState($txtAttackMinesIfGold, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtAttackMinesIfGold, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAttackMinesifGold
Func chkAttackMinesifelixir()
	If GUICtrlRead($chkAttackMinesifElixir) = $GUI_CHECKED Then
		GUICtrlSetState($txtAttackMinesIfelixir, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtAttackMinesIfelixir, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAttackMinesifelixir
Func chkAttackMinesifdarkElixir()
	If GUICtrlRead($chkAttackMinesifDarkElixir) = $GUI_CHECKED Then
		GUICtrlSetState($txtAttackMinesIfdarkElixir, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtAttackMinesIfdarkElixir, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAttackMinesifdarkElixir

Func chkMilkFarmForcetolerance()

	If GUICtrlRead($chkMilkFarmForcetolerance) = $GUI_CHECKED Then
		GUICtrlSetState($txtMilkFarmForcetolerancenormal, $GUI_ENABLE)
		GUICtrlSetState($txtMilkFarmForcetoleranceboosted, $GUI_ENABLE)
		GUICtrlSetState($txtMilkFarmForcetolerancedestroyed, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtMilkFarmForcetolerancenormal, $GUI_DISABLE)
		GUICtrlSetState($txtMilkFarmForcetoleranceboosted, $GUI_DISABLE)
		GUICtrlSetState($txtMilkFarmForcetolerancedestroyed, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkMilkFarmForcetolerance

Func chkMilkAfterAttackTHSnipe()
	If GUICtrlRead($chkMilkAfterAttackTHSnipe) = $GUI_CHECKED Then
		For $i = $grpSnipeOutsideTHAtEnd To $grpDeploy - 1
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $grpSnipeOutsideTHAtEnd To $grpDeploy - 1
			If $i <> $chkMilkAfterAttackTHSnipe Then GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkMilkAfterAttackTHSnipe

;~ Func chkMilkAfterAttackStandard()
;~ 	If GuiCtrlRead($chkMilkAfterAttackStandard) =    $GUI_CHECKED Then
;~ 			For $i = $grpDeploy to $lblx-1
;~ 				GUICtrlSetState($i, $GUI_Enable)
;~ 			Next
;~ 	Else
;~ 			For $i = $grpDeploy to $lblx-1
;~ 				If $i <>   $chkMilkAfterAttackStandard Then GUICtrlSetState($i, $GUI_DISABLE)
;~ 			Next
;~ 	EndIf
;~ EndFunc

Func PopulateComboMilkingCSVScriptsFiles()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($dirAttacksCSV & "\*.csv")
	Dim $output = ""
	While True
		$NewFile = FileFindNextFile($FileSearch)
		If @error Then ExitLoop
		$output = $output & StringLeft($NewFile, StringLen($NewFile) - 4) & "|"
	WEnd
	FileClose($FileSearch)
	;remove last |
	$output = StringLeft($output, StringLen($output) - 1)
	;reset combo box
	_GUICtrlComboBox_ResetContent($cmbMilkingCSVScriptName)
	;set combo box
	GUICtrlSetData($cmbMilkingCSVScriptName, $output)

	_GUICtrlComboBox_SetCurSel($cmbMilkingCSVScriptName, _GUICtrlComboBox_FindStringExact($cmbMilkingCSVScriptName, ""))
	GUICtrlSetData($lblMilkingCSVNotesScript, "")
EndFunc   ;==>PopulateComboMilkingCSVScriptsFiles

Func PopulateCmbMilkSnipeAlgorithm()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($dirTHSnipesAttacks & "\*.csv")
	Dim $output = ""
	While True
		$NewFile = FileFindNextFile($FileSearch)
		If @error Then ExitLoop
		$output = $output & StringLeft($NewFile, StringLen($NewFile) - 4) & "|"
	WEnd
	FileClose($FileSearch)
	;remove last |
	$output = StringLeft($output, StringLen($output) - 1)
	;reset combo box
	_GUICtrlComboBox_ResetContent($cmbMilkSnipeAlgorithm)
	;set combo box
	GUICtrlSetData($cmbMilkSnipeAlgorithm, $output)
EndFunc   ;==>PopulateCmbMilkSnipeAlgorithm
