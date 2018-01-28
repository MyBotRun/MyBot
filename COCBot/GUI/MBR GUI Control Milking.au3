; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Milking
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkAtkGoldMines()
	If GUICtrlRead($g_hChkAtkGoldMines) = $GUI_CHECKED Then
		GUICtrlSetState($g_hCmbAtkGoldMinesLevel, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbAtkGoldMinesLevel, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAtkGoldMines

Func chkAtkDarkDrills()
	If GUICtrlRead($g_hChkAtkDarkDrills) = $GUI_CHECKED Then
		GUICtrlSetState($g_hCmbAtkDarkDrillsLevel, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbAtkDarkDrillsLevel, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAtkDarkDrills

Func chkAttackMinesifGold()
	If GUICtrlRead($g_hChkAttackMinesIfGold) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtAttackMinesIfGold, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtAttackMinesIfGold, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAttackMinesifGold

Func chkAttackMinesifelixir()
	If GUICtrlRead($g_hChkAttackMinesIfElixir) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtAttackMinesIfElixir, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtAttackMinesIfElixir, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAttackMinesifelixir

Func chkAttackMinesifdarkElixir()
	If GUICtrlRead($g_hChkAttackMinesIfDarkElixir) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtAttackMinesIfDarkElixir, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtAttackMinesIfDarkElixir, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkAttackMinesifdarkElixir

Func chkMilkFarmForcetolerance()

	If GUICtrlRead($g_hChkMilkFarmForceTolerance) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtMilkFarmForceToleranceNormal, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtMilkFarmForceToleranceBoosted, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtMilkFarmForceToleranceDestroyed, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtMilkFarmForceToleranceNormal, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtMilkFarmForceToleranceBoosted, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtMilkFarmForceToleranceDestroyed, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkMilkFarmForcetolerance

Func chkMilkAfterAttackTHSnipe()
	If GUICtrlRead($g_hChkMilkAfterAttackTHSnipe) = $GUI_CHECKED Then
		For $i = $g_hGrpSnipeOutsideTHAtEnd To $g_hGrpDeploy - 1
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $g_hGrpSnipeOutsideTHAtEnd To $g_hGrpDeploy - 1
			If $i <> $g_hChkMilkAfterAttackTHSnipe Then GUICtrlSetState($i, $GUI_DISABLE)
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
	$FileSearch = FileFindFirstFile($g_sCSVAttacksPath & "\*.csv")
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
	_GUICtrlComboBox_ResetContent($g_hCmbMilkingCSVScriptName)
	;set combo box
	GUICtrlSetData($g_hCmbMilkingCSVScriptName, $output)

	_GUICtrlComboBox_SetCurSel($g_hCmbMilkingCSVScriptName, _GUICtrlComboBox_FindStringExact($g_hCmbMilkingCSVScriptName, ""))
	GUICtrlSetData($g_hLblMilkingCSVNotesScript, "")
EndFunc   ;==>PopulateComboMilkingCSVScriptsFiles

Func PopulateCmbMilkSnipeAlgorithm()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($g_sTHSnipeAttacksPath & "\*.csv")
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
	_GUICtrlComboBox_ResetContent($g_hCmbMilkSnipeAlgorithm)
	;set combo box
	GUICtrlSetData($g_hCmbMilkSnipeAlgorithm, $output)
EndFunc   ;==>PopulateCmbMilkSnipeAlgorithm
