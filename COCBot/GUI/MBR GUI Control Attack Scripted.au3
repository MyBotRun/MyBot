; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Attack Scripted
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
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
Local $temp1 = GetTranslated(635, 1, "Create New Script File"), $temp2 = GetTranslated(635, 2, "New Script Filename")
Local $temp3 = GetTranslated(635, 3, "File exists, please input a new name"), $temp4 = GetTranslated(635, 4, "An error occurred when creating the file.")
Local $temp1 = 0, $temp2 = 0, $temp3 = 0, $temp4 = 0 ; empty temp vars

Func NewScriptDB()
	Local $filenameScript = InputBox(GetTranslated(635, 1, -1), GetTranslated(635, 2, -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslated(635, 3, -1))
		Else
			Local $hFileOpen = FileOpen($g_sCSVAttacksPath & "\" & $filenameScript & ".csv", $FO_APPEND)
			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslated(635, 4, -1))
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
	Local $filenameScript = InputBox(GetTranslated(635, 1, -1), GetTranslated(635, 2, -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslated(635, 3, -1))
		Else
			Local $hFileOpen = FileOpen($g_sCSVAttacksPath & "\" & $filenameScript & ".csv", $FO_APPEND)
			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslated(635, 4, -1))
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
Local $temp1 = GetTranslated(635, 5, "Copy to New Script File"), $temp2 = GetTranslated(635, 6, "Copy"), $temp3 = GetTranslated(635, 7, "to New Script Filename")
Local $temp1 = 0, $temp2 = 0, $temp3 = 0 ; empty temp vars

Func DuplicateScriptDB()
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameDB)
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbScriptNameDB, $indexofscript, $scriptname)
	$g_sAttackScrScriptName[$DB] = $scriptname
	Local $filenameScript = InputBox(GetTranslated(635, 5, -1), GetTranslated(635, 6, -1) & ": <" & $g_sAttackScrScriptName[$DB] & ">" & @CRLF & GetTranslated(635, 7, -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslated(635, 3, -1))
		Else
			Local $hFileOpen = FileCopy($g_sCSVAttacksPath & "\" & $g_sAttackScrScriptName[$DB] & ".csv", $g_sCSVAttacksPath & "\" & $filenameScript & ".csv")

			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslated(635, 4, -1))
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
	Local $filenameScript = InputBox(GetTranslated(635, 5, -1), GetTranslated(635, 6, -1) & ": <" & $g_sAttackScrScriptName[$LB] & ">" & @CRLF & GetTranslated(635, 7, -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslated(635, 3, -1))
		Else
			Local $hFileOpen = FileCopy($g_sCSVAttacksPath & "\" & $g_sAttackScrScriptName[$LB] & ".csv", $g_sCSVAttacksPath & "\" & $filenameScript & ".csv")

			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslated(635, 4, -1))
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
