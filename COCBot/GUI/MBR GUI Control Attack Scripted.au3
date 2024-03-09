; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Attack Scripted
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: CodeSlinger69 (2017), MMHK (01-2008)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func PopulateComboScriptsFilesDB()
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
	_GUICtrlComboBox_ResetContent($g_hCmbScriptNameDB)
	;set combo box
	GUICtrlSetData($g_hCmbScriptNameDB, $output)
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameDB, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameDB, ""))
	GUICtrlSetData($g_hLblNotesScriptDB, "")
EndFunc   ;==>PopulateComboScriptsFilesDB

Func PopulateComboScriptsFilesAB()
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
	_GUICtrlComboBox_ResetContent($g_hCmbScriptNameAB)
	;set combo box
	GUICtrlSetData($g_hCmbScriptNameAB, $output)
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameAB, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameAB, ""))
	GUICtrlSetData($g_hLblNotesScriptAB, "")
EndFunc   ;==>PopulateComboScriptsFilesAB


Func cmbScriptNameDB()

	Local $tempvect1 = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameDB)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameDB) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t

	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		$f = FileOpen($g_sCSVAttacksPath & "\" & $filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			$tempvect = StringSplit($line, "|", 2)
			If UBound($tempvect) >= 2 Then
				If StringStripWS(StringUpper($tempvect[0]), 2) = "NOTE" Then $result &= $tempvect[1] & @CRLF
			EndIf
		WEnd
		FileClose($f)

	EndIf
	GUICtrlSetData($g_hLblNotesScriptDB, $result)

EndFunc   ;==>cmbScriptNameDB

Func cmbScriptNameAB()

	Local $tempvect1 = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameAB)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameAB) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t

	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		$f = FileOpen($g_sCSVAttacksPath & "\" & $filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			$tempvect = StringSplit($line, "|", 2)
			If UBound($tempvect) >= 2 Then
				If StringStripWS(StringUpper($tempvect[0]), 2) = "NOTE" Then $result &= $tempvect[1] & @CRLF
			EndIf
		WEnd
		FileClose($f)

	EndIf
	GUICtrlSetData($g_hLblNotesScriptAB, $result)

EndFunc   ;==>cmbScriptNameAB


Func UpdateComboScriptNameDB()
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameDB)
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbScriptNameDB, $indexofscript, $scriptname)
	PopulateComboScriptsFilesDB()
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameDB, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameDB, $scriptname))
	cmbScriptNameDB()
EndFunc   ;==>UpdateComboScriptNameDB

Func UpdateComboScriptNameAB()
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameAB)
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbScriptNameAB, $indexofscript, $scriptname)
	PopulateComboScriptsFilesAB()
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameAB, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameAB, $scriptname))
	cmbScriptNameAB()
EndFunc   ;==>UpdateComboScriptNameAB


Func EditScriptDB()
	Local $tempvect1 = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameDB)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameDB) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t
	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		ShellExecute("notepad.exe", $g_sCSVAttacksPath & "\" & $filename & ".csv")
	EndIf
EndFunc   ;==>EditScriptDB

Func EditScriptAB()
	Local $tempvect1 = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameAB)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameAB) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t
	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		ShellExecute("notepad.exe", $g_sCSVAttacksPath & "\" & $filename & ".csv")
	EndIf
EndFunc   ;==>EditScriptAB


Func AttackCSVAssignDefaultScriptName()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($g_sCSVAttacksPath & "\*.csv")
	Dim $output = ""
	$NewFile = FileFindNextFile($FileSearch)
	If @error Then $output = ""
	$output = StringLeft($NewFile, StringLen($NewFile) - 4)
	FileClose($FileSearch)
	;remove last |
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameDB, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameDB, $output))
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameAB, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameAB, $output))

	cmbScriptNameDB()
	cmbScriptNameAB()
EndFunc   ;==>AttackCSVAssignDefaultScriptName

;Parse this first on load of bot, needed outside the function to update current language.ini file. Used on Func NewABScript() and NewDBScript()
Local $temp1 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Create", "Create New Script File"), $temp2 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_0", "New Script Filename")
Local $temp3 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_File-exists", "File exists, please input a new name"), $temp4 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Error", "An error occurred when creating the file.")
Local $temp1 = 0, $temp2 = 0, $temp3 = 0, $temp4 = 0 ; empty temp vars

Func NewScriptDB()
	Local $filenameScript = InputBox(GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Create", -1), GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_0", -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_File-exists", -1))
		Else
			Local $hFileOpen = FileOpen($g_sCSVAttacksPath & "\" & $filenameScript & ".csv", $FO_APPEND)
			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Error", -1))
				Return False
			Else
				FileClose($hFileOpen)
				$g_sAttackScrScriptName[$DB] = $filenameScript
				UpdateComboScriptNameDB()
				UpdateComboScriptNameAB()
			EndIf
		EndIf
	EndIf
EndFunc   ;==>NewScriptDB

Func NewScriptAB()
	Local $filenameScript = InputBox(GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Create", -1), GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_0", -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_File-exists", -1))
		Else
			Local $hFileOpen = FileOpen($g_sCSVAttacksPath & "\" & $filenameScript & ".csv", $FO_APPEND)
			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Error", -1))
				Return False
			Else
				FileClose($hFileOpen)
				$g_sAttackScrScriptName[$LB] = $filenameScript
				UpdateComboScriptNameAB()
				UpdateComboScriptNameDB()

			EndIf
		EndIf
	EndIf
EndFunc   ;==>NewScriptAB


;Parse this first on load of bot, needed outside the function to update current language.ini file. Used on Func DuplicateABScript() and DuplicateDBScript()
Local $temp1 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_0", "Copy to New Script File"), $temp2 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_1", "Copy"), $temp3 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_1", "to New Script Filename")
Local $temp1 = 0, $temp2 = 0, $temp3 = 0 ; empty temp vars

Func DuplicateScriptDB()
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameDB)
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbScriptNameDB, $indexofscript, $scriptname)
	$g_sAttackScrScriptName[$DB] = $scriptname
	Local $filenameScript = InputBox(GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_0", -1), GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_1", -1) & ": <" & $g_sAttackScrScriptName[$DB] & ">" & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_1", -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_File-exists", -1))
		Else
			Local $hFileOpen = FileCopy($g_sCSVAttacksPath & "\" & $g_sAttackScrScriptName[$DB] & ".csv", $g_sCSVAttacksPath & "\" & $filenameScript & ".csv")

			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Error", -1))
				Return False
			Else
				FileClose($hFileOpen)
				$g_sAttackScrScriptName[$DB] = $filenameScript
				UpdateComboScriptNameDB()
				UpdateComboScriptNameAB()

			EndIf
		EndIf
	EndIf
EndFunc   ;==>DuplicateScriptDB

Func DuplicateScriptAB()
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameAB)
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbScriptNameAB, $indexofscript, $scriptname)
	$g_sAttackScrScriptName[$LB] = $scriptname
	Local $filenameScript = InputBox(GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_0", -1), GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_1", -1) & ": <" & $g_sAttackScrScriptName[$LB] & ">" & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_1", -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_File-exists", -1))
		Else
			Local $hFileOpen = FileCopy($g_sCSVAttacksPath & "\" & $g_sAttackScrScriptName[$LB] & ".csv", $g_sCSVAttacksPath & "\" & $filenameScript & ".csv")

			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Error", -1))
				Return False
			Else
				FileClose($hFileOpen)
				$g_sAttackScrScriptName[$LB] = $filenameScript
				UpdateComboScriptNameAB()
				UpdateComboScriptNameDB()
			EndIf
		EndIf
	EndIf
EndFunc   ;==>DuplicateScriptAB

Func ApplyScriptDB()
	Local $iApply = 0
	Local $iApplySieges = 0
	Local $iSlot = 0
	Local $aiCSVTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aiCSVSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $sCSVCCSpl[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $ToIgnore[$eSpellCount] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
	Local $aiCSVSieges[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0, 0]
	Local $aiCSVHeros[$eHeroCount][2] = [[0, 0], [0, 0], [0, 0], [0, 0]]
	Local $aiCSVWardenMode = -1
	Local $iCSVRedlineRoutineItem = 0, $iCSVDroplineEdgeItem = 0
	Local $sCSVCCReq = ""
	Local $aTemp = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameDB)
	Local $sFilename = $aTemp[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameDB) + 1]

	SetLog("CSV settings apply starts: " & $sFilename, $COLOR_INFO)
	$iApply = ParseAttackCSV_Settings_variables($aiCSVTroops, $aiCSVSpells, $aiCSVSieges, $aiCSVHeros, $aiCSVWardenMode, $iCSVRedlineRoutineItem, $iCSVDroplineEdgeItem, $sCSVCCReq, $sCSVCCSpl, $sFilename)
	If Not $iApply Then
		SetLog("CSV settings apply failed", $COLOR_ERROR)
		Return
	EndIf

	$iApply = 0
	For $i = 0 To UBound($aiCSVTroops) - 1
		If $aiCSVTroops[$i] > 0 Then $iApply += 1
	Next
	For $i = 0 To UBound($aiCSVSpells) - 1
		If $aiCSVSpells[$i] > 0 Then $iApply += 1
	Next
	For $i = 0 To UBound($aiCSVSieges) - 1
		If $aiCSVSieges[$i] > 0 Then $iApply += 1
		If $aiCSVSieges[$i] > 0 Then $iApplySieges += 1
	Next
	If $iApply > 0 Then
		$g_aiArmyCustomTroops = $aiCSVTroops
		$g_aiArmyCustomSpells = $aiCSVSpells
		$g_aiArmyCompSiegeMachines = $aiCSVSieges
		ApplyConfig_600_52_2("Read")
		SetComboTroopComp() ; GUI refresh
		lblTotalCountSpell()
		lblTotalCountSiege()
		SetLog("CSV Train settings applied", $COLOR_SUCCESS)
	EndIf
			
	If IsArray($aiCSVSieges) And $iApplySieges > 0 Then
		Local $aMachine = _ArrayMaxIndex($aiCSVSieges)
		_GUICtrlComboBox_SetCurSel($g_hCmbDBSiege, $aMachine + 1)
		GUICtrlSetState($g_hChkDBDropCC, $GUI_CHECKED)
		GUICtrlSetState($g_hCmbDBSiege, $GUI_ENABLE)
		SetLog("CSV 'Sieges' settings applied", $COLOR_SUCCESS)
	EndIf

	$iApply = 0
	For $i = 0 To UBound($aiCSVHeros) - 1
		If $aiCSVHeros[$i][0] > 0 Then $iApply += 1
	Next
	If $iApply > 0 Then
		For $h = 0 To UBound($aiCSVHeros) - 1
			If $aiCSVHeros[$h][0] > 0 Then
				Switch $h
					Case $eHeroBarbarianKing
						$g_iActivateKing = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateKing = $aiCSVHeros[$h][1]
					Case $eHeroArcherQueen
						$g_iActivateQueen = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateQueen = $aiCSVHeros[$h][1]
					Case $eHeroGrandWarden
						$g_iActivateWarden = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateWarden = $aiCSVHeros[$h][1]
					Case $eHeroRoyalChampion
						$g_iActivateChampion = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateChampion = $aiCSVHeros[$h][1]
				EndSwitch
			EndIf
		Next
		radHerosApply()
		SetLog("CSV Hero Ability settings applied", $COLOR_SUCCESS)

		GUICtrlSetState($g_hChkDBKingAttack, $aiCSVHeros[$eHeroBarbarianKing][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkDBKingAttack))
		GUICtrlSetState($g_hChkDBQueenAttack, $aiCSVHeros[$eHeroArcherQueen][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkDBQueenAttack))
		GUICtrlSetState($g_hChkDBWardenAttack, $aiCSVHeros[$eHeroGrandWarden][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkDBWardenAttack))
		chkDBWardenAttack()
		GUICtrlSetState($g_hChkDBChampionAttack, $aiCSVHeros[$eHeroRoyalChampion][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkDBChampionAttack))
		SetLog("CSV 'Attack with' Hero settings applied", $COLOR_SUCCESS)
	EndIf
	
	If $aiCSVWardenMode >= 0 And $aiCSVWardenMode < 3 Then;	0 = Ground / 1 = Air / 2 = Default
		_GUICtrlComboBox_SetCurSel($g_hCmbDBWardenMode, $aiCSVWardenMode)
		SetLog("CSV 'Warden Mode' settings applied", $COLOR_SUCCESS)
	Else
		If $aiCSVWardenMode <> -1 Then SetLog("CSV 'Warden Mode' settings out of bounds", $COLOR_ERROR)
	EndIf
	
	If $sCSVCCReq <> "" Then
		GUICtrlSetState($g_hChkDBDropCC, $GUI_CHECKED)
		SetLog("CSV 'Attack with' CC settings applied", $COLOR_SUCCESS)
	EndIf

	$iApply = 0
	Local $ahChkDBSpell = StringSplit($g_aGroupAttackDBSpell, "#", 2)
	If IsArray($ahChkDBSpell) Then
		For $i = 0 To UBound($ahChkDBSpell) - 1
			GUICtrlSetState($ahChkDBSpell[$i], $aiCSVSpells[$i] > 0 ? $GUI_CHECKED : $GUI_UNCHECKED)
			If $sCSVCCSpl[$i] = 1 Then GUICtrlSetState($ahChkDBSpell[$i], $GUI_CHECKED)
			If $aiCSVSpells[$i] > 0 Then $iApply += 1
		Next
		If $iApply > 0 Then SetLog("CSV 'Attack with' Spell settings applied", $COLOR_SUCCESS)
	EndIf
	
	For $t = 0 To UBound($sCSVCCSpl) - 1
		If $sCSVCCSpl[$t] = 1 Then $iSlot += 1
	Next
	If $iSlot > 0 Then
		GUICtrlSetState($g_hChkRequestType_Spells, $GUI_CHECKED)
		For $x = 0 To UBound($g_ahCmbClanCastleSpell) - 1
			_GUICtrlComboBox_SetCurSel($g_ahCmbClanCastleSpell[$x], 0);Reset To Any
		Next
		chkRequestCountCC()
	EndIf
	For $i = 0 To UBound($g_ahCmbClanCastleSpell) - 1
		If $i > $iSlot - 1 Then ExitLoop
		For $z = 0 To UBound($sCSVCCSpl) - 1
			If $sCSVCCSpl[$z] = 1 And $z <> $ToIgnore[$z] Then
				_GUICtrlComboBox_SetCurSel($g_ahCmbClanCastleSpell[$i], $z+1)
				If $ToIgnore[$z] = -1 Then $ToIgnore[$z] = $z
				ExitLoop
			EndIf
		Next
	Next

	If $iCSVRedlineRoutineItem > 0 And $iCSVRedlineRoutineItem <= _GUICtrlComboBox_GetCount($g_hCmbScriptRedlineImplDB) + 1 Then
		_GUICtrlComboBox_SetCurSel($g_hCmbScriptRedlineImplDB, $iCSVRedlineRoutineItem - 1)
		cmbScriptRedlineImplDB()
		SetLog("CSV Red Line settings applied", $COLOR_SUCCESS)
	Else
		If $iCSVRedlineRoutineItem <> 0 Then SetLog("CSV Red Line settings out of bounds", $COLOR_ERROR)
	EndIf
	If $iCSVDroplineEdgeItem > 0 And $iCSVDroplineEdgeItem <= _GUICtrlComboBox_GetCount($g_hCmbScriptDroplineDB) + 1 Then
		_GUICtrlComboBox_SetCurSel($g_hCmbScriptDroplineDB, $iCSVDroplineEdgeItem - 1)
		cmbScriptDroplineDB()
		SetLog("CSV Drop Line settings applied", $COLOR_SUCCESS)
	Else
		If $iCSVDroplineEdgeItem <> 0 Then SetLog("CSV Drop Line settings out of bounds", $COLOR_ERROR)
	EndIf

	If $sCSVCCReq <> "" Then
		$g_bRequestTroopsEnable = True
		$g_sRequestTroopsText = $sCSVCCReq
		ApplyConfig_600_11("Read")
		SetLog("CSV CC Request settings applied", $COLOR_SUCCESS)
	EndIf
EndFunc   ;==>ApplyScriptDB

Func ApplyScriptAB()
	Local $iApply = 0
	Local $iApplySieges = 0
	Local $iSlot = 0
	Local $aiCSVTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aiCSVSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0]
	Local $sCSVCCSpl[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0]
	Local $ToIgnore[$eSpellCount] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
	Local $aiCSVSieges[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0, 0]
	Local $aiCSVHeros[$eHeroCount][2] = [[0, 0], [0, 0], [0, 0], [0, 0]]
	Local $aiCSVWardenMode = -1
	Local $iCSVRedlineRoutineItem = 0, $iCSVDroplineEdgeItem = 0
	Local $sCSVCCReq = ""
	Local $aTemp = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameAB)
	Local $sFilename = $aTemp[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameAB) + 1]

	SetLog("CSV settings apply starts: " & $sFilename, $COLOR_INFO)
	$iApply = ParseAttackCSV_Settings_variables($aiCSVTroops, $aiCSVSpells, $aiCSVSieges, $aiCSVHeros, $aiCSVWardenMode, $iCSVRedlineRoutineItem, $iCSVDroplineEdgeItem, $sCSVCCReq, $sCSVCCSpl, $sFilename)
	If Not $iApply Then
		SetLog("CSV settings apply failed", $COLOR_ERROR)
		Return
	EndIf

	$iApply = 0
	For $i = 0 To UBound($aiCSVTroops) - 1
		If $aiCSVTroops[$i] > 0 Then $iApply += 1
	Next
	For $i = 0 To UBound($aiCSVSpells) - 1
		If $aiCSVSpells[$i] > 0 Then $iApply += 1
	Next
	For $i = 0 To UBound($aiCSVSieges) - 1
		If $aiCSVSieges[$i] > 0 Then $iApply += 1
		If $aiCSVSieges[$i] > 0 Then $iApplySieges += 1
	Next
	If $iApply > 0 Then
		$g_aiArmyCustomTroops = $aiCSVTroops
		$g_aiArmyCustomSpells = $aiCSVSpells
		$g_aiArmyCompSiegeMachines = $aiCSVSieges
		ApplyConfig_600_52_2("Read")
		SetComboTroopComp() ; GUI refresh
		lblTotalCountSpell()
		lblTotalCountSiege()
		SetLog("CSV Train settings applied", $COLOR_SUCCESS)
	EndIf

	If IsArray($aiCSVSieges) And $iApplySieges > 0 Then
		Local $aMachine = _ArrayMaxIndex($aiCSVSieges, 0, 1)
		_GUICtrlComboBox_SetCurSel($g_hCmbABSiege, $aMachine + 1)
		GUICtrlSetState($g_hChkABDropCC, $GUI_CHECKED)
		GUICtrlSetState($g_hCmbABSiege, $GUI_ENABLE)
		SetLog("CSV 'Sieges' settings applied", $COLOR_SUCCESS)
	EndIf

	$iApply = 0
	For $i = 0 To UBound($aiCSVHeros) - 1
		If $aiCSVHeros[$i][0] > 0 Then $iApply += 1
	Next
	If $iApply > 0 Then
		For $h = 0 To UBound($aiCSVHeros) - 1
			If $aiCSVHeros[$h][0] > 0 Then
				Switch $h
					Case $eHeroBarbarianKing
						$g_iActivateKing = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateKing = $aiCSVHeros[$h][1]
					Case $eHeroArcherQueen
						$g_iActivateQueen = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateQueen = $aiCSVHeros[$h][1]
					Case $eHeroGrandWarden
						$g_iActivateWarden = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateWarden = $aiCSVHeros[$h][1]
					Case $eHeroRoyalChampion
						$g_iActivateChampion = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateChampion = $aiCSVHeros[$h][1]
				EndSwitch
			EndIf
		Next
		radHerosApply()
		SetLog("CSV Hero Ability settings applied", $COLOR_SUCCESS)

		GUICtrlSetState($g_hChkABKingAttack, $aiCSVHeros[$eHeroBarbarianKing][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkABKingAttack))
		GUICtrlSetState($g_hChkABQueenAttack, $aiCSVHeros[$eHeroArcherQueen][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkABQueenAttack))
		GUICtrlSetState($g_hChkABWardenAttack, $aiCSVHeros[$eHeroGrandWarden][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkABWardenAttack))
		chkABWardenAttack()
		GUICtrlSetState($g_hChkABChampionAttack, $aiCSVHeros[$eHeroRoyalChampion][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkABChampionAttack))
		SetLog("CSV 'Attack with' Hero settings applied", $COLOR_SUCCESS)
	EndIf
	
	If $aiCSVWardenMode >= 0 And $aiCSVWardenMode < 3 Then;	0 = Ground / 1 = Air / 2 = Default
		_GUICtrlComboBox_SetCurSel($g_hCmbABWardenMode, $aiCSVWardenMode)
		SetLog("CSV 'Warden Mode' settings applied", $COLOR_SUCCESS)
	Else
		If $aiCSVWardenMode <> -1 Then SetLog("CSV 'Warden Mode' settings out of bounds", $COLOR_ERROR)
	EndIf

	If $sCSVCCReq <> "" Then
		GUICtrlSetState($g_hChkABDropCC, $GUI_CHECKED)
		SetLog("CSV 'Attack with' CC settings applied", $COLOR_SUCCESS)
	EndIf

	$iApply = 0
	Local $ahChkABSpell = StringSplit($GroupAttackABSpell, "#", 2)
	If IsArray($ahChkABSpell) Then
		For $i = 0 To UBound($ahChkABSpell) - 1
			GUICtrlSetState($ahChkABSpell[$i], $aiCSVSpells[$i] > 0 ? $GUI_CHECKED : $GUI_UNCHECKED)
			If $sCSVCCSpl[$i] = 1 Then GUICtrlSetState($ahChkABSpell[$i], $GUI_CHECKED)
			If $aiCSVSpells[$i] > 0 Then $iApply += 1
		Next
		If $iApply > 0 Then SetLog("CSV 'Attack with' Spell settings applied", $COLOR_SUCCESS)
	EndIf
	
	For $t = 0 To UBound($sCSVCCSpl) - 1
		If $sCSVCCSpl[$t] = 1 Then $iSlot += 1
	Next
	If $iSlot > 0 Then
		GUICtrlSetState($g_hChkRequestType_Spells, $GUI_CHECKED)
		For $x = 0 To UBound($g_ahCmbClanCastleSpell) - 1
			_GUICtrlComboBox_SetCurSel($g_ahCmbClanCastleSpell[$x], 0);Reset To Any
		Next
		chkRequestCountCC()
	EndIf
	For $i = 0 To UBound($g_ahCmbClanCastleSpell) - 1
		If $i > $iSlot - 1 Then ExitLoop
		For $z = 0 To UBound($sCSVCCSpl) - 1
			If $sCSVCCSpl[$z] = 1 And $z <> $ToIgnore[$z] Then
				_GUICtrlComboBox_SetCurSel($g_ahCmbClanCastleSpell[$i], $z+1)
				If $ToIgnore[$z] = -1 Then $ToIgnore[$z] = $z
				ExitLoop
			EndIf
		Next
	Next

	If $iCSVRedlineRoutineItem > 0 And $iCSVRedlineRoutineItem <= _GUICtrlComboBox_GetCount($g_hCmbScriptRedlineImplAB) + 1 Then
		_GUICtrlComboBox_SetCurSel($g_hCmbScriptRedlineImplAB, $iCSVRedlineRoutineItem - 1)
		cmbScriptRedlineImplAB()
		SetLog("CSV Red Line settings applied", $COLOR_SUCCESS)
	Else
		If $iCSVRedlineRoutineItem <> 0 Then SetLog("CSV Red Line settings out of bounds", $COLOR_ERROR)
	EndIf
	If $iCSVDroplineEdgeItem > 0 And $iCSVDroplineEdgeItem <= _GUICtrlComboBox_GetCount($g_hCmbScriptDroplineAB) + 1 Then
		_GUICtrlComboBox_SetCurSel($g_hCmbScriptDroplineAB, $iCSVDroplineEdgeItem - 1)
		cmbScriptDroplineAB()
		SetLog("CSV Drop Line settings applied", $COLOR_SUCCESS)
	Else
		If $iCSVDroplineEdgeItem <> 0 Then SetLog("CSV Drop Line settings out of bounds", $COLOR_ERROR)
	EndIf

	If $sCSVCCReq <> "" Then
		$g_bRequestTroopsEnable = True
		$g_sRequestTroopsText = $sCSVCCReq
		ApplyConfig_600_11("Read")
		SetLog("CSV CC Request settings applied", $COLOR_SUCCESS)
	EndIf
EndFunc   ;==>ApplyScriptAB

Func cmbScriptRedlineImplDB()
	$g_aiAttackScrRedlineRoutine[$DB] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptRedlineImplDB)
    If $g_aiAttackScrRedlineRoutine[$DB] = 3 then
        GUICtrlSetState($g_hCmbScriptDroplineDB, $GUI_HIDE)
        $g_aiAttackScrDroplineEdge[$DB] = $DROPLINE_FULL_EDGE_FIXED
    Else
        GUICtrlSetState($g_hCmbScriptDroplineDB, $GUI_SHOW)
    Endif
EndFunc   ;==>cmbScriptRedlineImplDB

Func cmbScriptRedlineImplAB()
	$g_aiAttackScrRedlineRoutine[$LB] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptRedlineImplAB)
    If $g_aiAttackScrRedlineRoutine[$LB] = 3 then
        GUICtrlSetState($g_hCmbScriptDroplineAB, $GUI_HIDE)
        $g_aiAttackScrDroplineEdge[$LB] = $DROPLINE_FULL_EDGE_FIXED
    Else
        GUICtrlSetState($g_hCmbScriptDroplineAB, $GUI_SHOW)
    EndIf
EndFunc   ;==>cmbScriptRedlineImplAB

Func cmbScriptDroplineDB()
	$g_aiAttackScrDroplineEdge[$DB] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptDroplineDB)
EndFunc   ;==>cmbScriptDroplineDB

Func cmbScriptDroplineAB()
	$g_aiAttackScrDroplineEdge[$LB] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptDroplineAB)
EndFunc   ;==>cmbScriptDroplineAB

Func AttackNow()
	Local $tempbRunState = $g_bRunState
	Local $tempSieges = $g_aiCurrentSiegeMachines
	$g_aiCurrentSiegeMachines[$eSiegeWallWrecker] = 1
	$g_aiCurrentSiegeMachines[$eSiegeBattleBlimp] = 1
	$g_aiCurrentSiegeMachines[$eSiegeStoneSlammer] = 1
	$g_aiCurrentSiegeMachines[$eSiegeBarracks] = 1
	$g_aiCurrentSiegeMachines[$eSiegeLogLauncher] = 1
	$g_aiCurrentSiegeMachines[$eSiegeFlameFlinger] = 1
	$g_aiCurrentSiegeMachines[$eSiegeBattleDrill] = 1
	$g_aiAttackAlgorithm[$LB] = 1										; Select Scripted Attack
	$g_sAttackScrScriptName[$LB] = GuiCtrlRead($g_hCmbScriptNameAB)		; Select Scripted Attack File From The Combo Box, Cos it wasn't refreshing until pressing Start button
	$g_iMatchMode = $LB													; Select Live Base As Attack Type
	$g_bRunState = True

	_GUICtrlTab_ClickTab($g_hTabMain, 0)

	; cleanup some vars used by imgloc just in case. usend in TH and DeadBase ( imgloc functions)
	ResetTHsearch()

	_ObjDeleteKey($g_oBldgAttackInfo, "") ; Remove all keys from building dictionary

	; reset village measures
	setVillageOffset(0, 0, 1)
	ConvertInternalExternArea()

	; only one capture here, very important for consistent debug images, zombies, redline calc etc.
	ForceCaptureRegion()
	_CaptureRegion2()

	If Not CheckZoomOut("AttackNow", True, False) Then SaveDebugImage("VillageSearchMeasureFailed", False)

	PrepareAttack($g_iMatchMode)										;

	If _Sleep(1000) Then Return

	Attack()			; Fire xD

	For $i = 0 to 10
		CheckHeroesHealth()

		If _Sleep(100) Then Return

	Next

	; Reset hero variables
	$g_bCheckKingPower = False
	$g_bCheckQueenPower = False
	$g_bCheckWardenPower = False
	$g_bCheckChampionPower = False
	$g_bDropKing = False
	$g_bDropQueen = False
	$g_bDropWarden = False
	$g_bDropChampion = False
	$g_aHeroesTimerActivation[$eHeroBarbarianKing] = 0
	$g_aHeroesTimerActivation[$eHeroArcherQueen] = 0
	$g_aHeroesTimerActivation[$eHeroGrandWarden] = 0
	$g_aHeroesTimerActivation[$eHeroRoyalChampion] = 0

	_ObjDeleteKey($g_oBldgAttackInfo, "") ; Remove all keys from building dictionary

	$g_aiCurrentSiegeMachines = $tempSieges
	$g_bRunState = $tempbRunState
	
	SetLog("AttackNow completed!")
EndFunc   ;==>AttackNow
