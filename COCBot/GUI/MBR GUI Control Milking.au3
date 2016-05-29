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

Func applyMilkingConfig()

	;1. elixir Collectors Minimum Level
	If UBound($MilkFarmElixirParam) = 9 Then
		For $i = 0 To UBound($MilkFarmElixirParam) - 1
			_GUICtrlComboBox_SetCurSel(Eval("cmbMilkLvl" & $i + 4), $MilkFarmElixirParam[$i] + 1)
		Next
	Else
		For $i = 0 To 9 - 1
			_GUICtrlComboBox_SetCurSel(Eval("cmbMilkLvl" & $i + 4), 0)
		Next
	EndIf

	;2 If Elixir Collectors Found, Then
	If $MilkFarmLocateElixir = 1 Then
		GUICtrlSetState($chkAtkElixirExtractors, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAtkElixirExtractors, $GUI_UNCHECKED)
	EndIf

	If $MilkFarmLocateMine = 1 Then
		GUICtrlSetState($chkAtkGoldMines, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAtkGoldMines, $GUI_UNCHECKED)
	EndIf

	_GUICtrlComboBox_SetCurSel($cmbAtkGoldMinesLevel, $MilkFarmMineParam - 1)

	If $MilkFarmLocateDrill = 1 Then
		GUICtrlSetState($chkAtkDarkDrills, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAtkDarkDrills, $GUI_UNCHECKED)
	EndIf

	_GUICtrlComboBox_SetCurSel($cmbAtkDarkDrillsLevel, $MilkFarmAttackDarkDrills - 1)

	;3 Only attack If
	_GUICtrlComboBox_SetCurSel($cmbRedlineResDistance, $MilkFarmResMaxTilesFromBorder)

	If $MilkFarmAttackElixirExtractors = 1 Then
		GUICtrlSetState($chkAttackMinesifElixir, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAttackMinesifElixir, $GUI_UNCHECKED)
	EndIf
	If $MilkFarmAttackGoldMines = 1 Then
		GUICtrlSetState($chkAttackMinesifGold, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAttackMinesifGold, $GUI_UNCHECKED)
	EndIf
	If $MilkFarmAttackDarkDrills = 1 Then
		GUICtrlSetState($chkAttackMinesifDarkElixir, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAttackMinesifDarkElixir, $GUI_UNCHECKED)
	EndIf
	GUICtrlSetData($txtAttackMinesIfGold, $MilkFarmLimitGold)
	GUICtrlSetData($txtAttackMinesifElixir, $MilkFarmLimitElixir)
	GUICtrlSetData($txtAttackMinesifDarkElixir, $MilkFarmLimitDark)
	chkAttackMinesifGold()
	chkAttackMinesifelixir()
	chkAttackMinesifdarkElixir()


	GUICtrlSetData($txtLowerXWave, $MilkFarmTroopForWaveMin)
	GUICtrlSetData($txtUpperXWave, $MilkFarmTroopForWaveMax)
	GUICtrlSetData($txtMaxWaves, $MilkFarmTroopMaxWaves)
	GUICtrlSetData($txtLowerDelayWaves, $MilkFarmDelayFromWavesMin)
	GUICtrlSetData($txtUpperDelayWaves, $MilkFarmDelayFromWavesMax)



	GUICtrlSetData($txtMaxTilesMilk, $MilkFarmTHMaxTilesFromBorder)

	PopulateCmbMilkSnipeAlgorithm()
	_GUICtrlComboBox_SetCurSel($cmbMilkSnipeAlgorithm, _GUICtrlComboBox_FindStringExact($cmbMilkSnipeAlgorithm, $MilkFarmAlgorithmTh))

	If $MilkFarmSnipeEvenIfNoExtractorsFound = 1 Then
		GUICtrlSetState($chkSnipeIfNoElixir, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkSnipeIfNoElixir, $GUI_UNCHECKED)
	EndIf


	If $DevMode = 1 Then
		GUICtrlSetState($grpMilkingDebug, $GUI_SHOW)
		GUICtrlSetState($chkMilkingDebugIMG, $GUI_SHOW)
		GUICtrlSetState($chkMilkingDebugVillage, $GUI_SHOW)
		GUICtrlSetState($chkMilkingVillageDebugIMG, $GUI_SHOW)
		GUICtrlSetState($chkMilkingDebugFullSearch, $GUI_SHOW)


		If $debugresourcesoffset = 1 Then
			GUICtrlSetState($chkMilkingDebugIMG, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkMilkingDebugIMG, $GUI_UNCHECKED)
		EndIf

		If $debugMilkingIMGmake = 1 Then
			GUICtrlSetState($chkMilkingDebugVillage, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkMilkingDebugVillage, $GUI_UNCHECKED)
		EndIf

		If $continuesearchelixirdebug = 1 Then
			GUICtrlSetState($chkMilkingDebugFullSearch, $GUI_CHECKED)
		Else
			GUICtrlSetState($chkMilkingDebugFullSearch, $GUI_UNCHECKED)
		EndIf


	EndIf

	If $MilkFarmForcetolerance = 1 Then
		GUICtrlSetState($chkMilkFarmForcetolerance, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkMilkFarmForcetolerance, $GUI_UNCHECKED)
	EndIf
	chkMilkFarmForcetolerance()
	GUICtrlSetData($txtMilkFarmForcetolerancenormal, $MilkFarmForcetolerancenormal)
	GUICtrlSetData($txtMilkFarmForcetoleranceboosted, $MilkFarmForcetoleranceboosted)
	GUICtrlSetData($txtMilkFarmForcetolerancedestroyed, $MilkFarmForcetolerancedestroyed)
	;MsgBox("","", "apply " & $MilkFarmForcetolerancenormal & " " & $MilkFarmForcetoleranceboosted & " " & $MilkFarmForcetolerancedestroyed)

	If $MilkAttackType = 1 Then
		_GUICtrlComboBox_SetCurSel($cmbMilkAttackType, 1)
	Else
		_GUICtrlComboBox_SetCurSel($cmbMilkAttackType, 0)
	EndIf

	If $MilkingAttackCheckStructureDestroyedBeforeAttack = 1 Then
		_GUICtrlComboBox_SetCurSel($chkStructureDestroyedBeforeAttack, 1)
	Else
		_GUICtrlComboBox_SetCurSel($chkStructureDestroyedBeforeAttack, 0)
	EndIf

	If $MilkingAttackCheckStructureDestroyedAfterAttack = 1 Then
		_GUICtrlComboBox_SetCurSel($chkStructureDestroyedAfterAttack, 1)
	Else
		_GUICtrlComboBox_SetCurSel($chkStructureDestroyedAfterAttack, 0)
	EndIf

	If $MilkingAttackDropGoblinAlgorithm = 1 Then
		_GUICtrlComboBox_SetCurSel($cmbMilkingAttackDropGoblinAlgorithm, 1)
	Else
		_GUICtrlComboBox_SetCurSel($cmbMilkingAttackDropGoblinAlgorithm, 0)
	EndIf

	_GUICtrlComboBox_SetCurSel($cmbStructureOrder, $MilkingAttackStructureOrder)

	If $MilkAttackAfterTHSnipe = 1 Then
		GUICtrlSetState($chkMilkAfterAttackTHSnipe, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkMilkAfterAttackTHSnipe, $GUI_UNCHECKED)
	EndIf
	chkMilkAfterAttackTHSnipe()

	If $MilkAttackAfterScriptedAtk = 1 Then
		GUICtrlSetState($chkMilkAfterAttackScripted, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkMilkAfterAttackScripted, $GUI_UNCHECKED)
	EndIf
	;chkMilkAfterAttackStandard()
	PopulateComboMilkingCSVScriptsFiles()

	Local $tempindex = _GUICtrlComboBox_FindStringExact($cmbMilkingCSVScriptName, $MilkAttackCSVscript)
	If $tempindex = -1 Then
		$tempindex = 0
		Setlog("Previous saved Scripted Attack not found (deleted, renamed?)", $color_red)
		Setlog("Automatically setted a default script, please check your config", $color_red)
	EndIf
	_GUICtrlComboBox_SetCurSel($cmbMilkingCSVScriptName, $tempindex)

EndFunc   ;==>applyMilkingConfig

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
