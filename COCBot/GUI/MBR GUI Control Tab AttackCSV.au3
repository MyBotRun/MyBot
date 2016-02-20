; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control tab AttackCSV
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func chkBalanceDRCSV()
	If GUICtrlRead($chkUseCCBalancedCSV) = $GUI_CHECKED Then
		GUICtrlSetState($cmbCCDonatedCSV, $GUI_ENABLE)
		GUICtrlSetState($cmbCCReceivedCSV, $GUI_ENABLE)
	Else
		GUICtrlSetState($cmbCCDonatedCSV, $GUI_DISABLE)
		GUICtrlSetState($cmbCCReceivedCSV, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBalanceDRCSV

Func cmbBalanceDRCSV()
	If _GUICtrlComboBox_GetCurSel($cmbCCDonatedCSV) = _GUICtrlComboBox_GetCurSel($cmbCCReceivedCSV) Then
		_GUICtrlComboBox_SetCurSel($cmbCCDonatedCSV, 0)
		_GUICtrlComboBox_SetCurSel($cmbCCReceivedCSV, 0)
	EndIf
EndFunc   ;==>cmbBalanceDRCSV

Func chkUseAttackDBCSV()
	For $i = $grpDeadBaseDeploy To $chkDBDropCC
		If GUICtrlRead($chkUseAttackDBCSV) = $GUI_CHECKED Then
			GUICtrlSetState($i, $GUI_DISABLE)
		Else
			GUICtrlSetState($i, $GUI_ENABLE)
		EndIf
	Next
	chkDBSmartAttackRedArea()
;~ 	IF GUICtrlRead($chkUseAttackDBCSV) = $GUI_CHECKED and GUICtrlRead($chkUseAttackDBCSV) = $GUI_CHECKED Then
;~ 		For $i=$grpClanCastleBal To $cmbCCReceived
;~ 			GUICtrlSetState($i, $GUI_DISABLE)
;~ 		Next
;~ 		For $i=$grpRoyalAbilities To $lblWardenAbilitiesSec
;~ 			GUICtrlSetState($i, $GUI_DISABLE)
;~ 		Next
;~ 	Else
;~ 		For $i= $grpClanCastleBal To $cmbCCReceived
;~ 			GUICtrlSetState($i, $GUI_ENABLE )
;~ 		Next
;~ 		chkBalanceDR()
;~ 		For $i=$grpRoyalAbilities To $lblWardenAbilitiesSec
;~ 			GUICtrlSetState($i, $GUI_ENABLE)
;~ 		Next
;~ 	EndIf
EndFunc   ;==>chkUseAttackDBCSV

Func chkUseAttackABCSV()
	For $i = $grpLiveBaseDeploy To $chkABDropCC
		If GUICtrlRead($chkUseAttackABCSV) = $GUI_CHECKED Then
			GUICtrlSetState($i, $GUI_DISABLE)
		Else
			GUICtrlSetState($i, $GUI_ENABLE)
		EndIf
	Next
	chkABSmartAttackRedArea()
	cmbABDeploy()
;~ 	IF GUICtrlRead($chkUseAttackDBCSV) = $GUI_CHECKED and GUICtrlRead($chkUseAttackDBCSV) = $GUI_CHECKED Then
;~ 		For $i=$grpClanCastleBal To $cmbCCReceived
;~ 			GUICtrlSetState($i, $GUI_DISABLE)
;~ 		Next
;~ 		For $i=$grpRoyalAbilities To $lblWardenAbilitiesSec
;~ 			GUICtrlSetState($i, $GUI_DISABLE)
;~ 		Next
;~ 	Else
;~ 		For $i= $grpClanCastleBal To $cmbCCReceived
;~ 			GUICtrlSetState($i, $GUI_ENABLE )
;~ 		Next
;~ 		chkBalanceDR()
;~ 		For $i=$grpRoyalAbilities To $lblWardenAbilitiesSec
;~ 			GUICtrlSetState($i, $GUI_ENABLE)
;~ 		Next
;~ 	EndIf
EndFunc   ;==>chkUseAttackABCSV


Func PopulateDBComboScriptsFiles()
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
	_GUICtrlComboBox_ResetContent($cmbDBScriptName)
	;set combo box
	GUICtrlSetData($cmbDBScriptName, $output)

	_GUICtrlComboBox_SetCurSel($cmbDBScriptName, _GUICtrlComboBox_FindStringExact($cmbDBScriptName, ""))
	GUICtrlSetData($lblNotesDBScript, "")
EndFunc   ;==>PopulateDBComboScriptsFiles


Func PopulateABComboScriptsFiles()
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
	_GUICtrlComboBox_ResetContent($cmbABScriptName)
	;set combo box
	GUICtrlSetData($cmbABScriptName, $output)

	_GUICtrlComboBox_SetCurSel($cmbABScriptName, _GUICtrlComboBox_FindStringExact($cmbABScriptName, ""))
	GUICtrlSetData($lblNotesABScript, "")

EndFunc   ;==>PopulateABComboScriptsFiles


Func cmbDBScriptName()

	Local $tempvect1 = _GUICtrlComboBox_GetListArray($cmbDBScriptName)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($cmbDBScriptName) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t

	$scmbDBScriptName = $filename

	If FileExists($dirAttacksCSV & "\" & $filename & ".csv") Then
		$f = FileOpen($dirAttacksCSV & "\" & $filename & ".csv", 0)
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
	GUICtrlSetData($lblNotesDBScript, $result)
EndFunc   ;==>cmbDBScriptName

Func cmbABScriptName()

	Local $tempvect1 = _GUICtrlComboBox_GetListArray($cmbABScriptName)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($cmbABScriptName) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t

	$scmbABScriptName = $filename

	If FileExists($dirAttacksCSV & "\" & $filename & ".csv") Then
		$f = FileOpen($dirAttacksCSV & "\" & $filename & ".csv", 0)
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
	GUICtrlSetData($lblNotesABScript, $result)
EndFunc   ;==>cmbABScriptName

Func UpdateComboScriptName()
	PopulateDBComboScriptsFiles()
	_GUICtrlComboBox_SetCurSel($cmbDBScriptName, _GUICtrlComboBox_FindStringExact($cmbDBScriptName, $scmbDBScriptName))
	cmbDBScriptName()
	PopulateABComboScriptsFiles() ; recreate combo box values
	_GUICtrlComboBox_SetCurSel($cmbABScriptName, _GUICtrlComboBox_FindStringExact($cmbABScriptName, $scmbABScriptName))
	cmbABScriptName()
EndFunc   ;==>UpdateComboScriptName

Func EditDBScript()
	Local $tempvect1 = _GUICtrlComboBox_GetListArray($cmbDBScriptName)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($cmbDBScriptName) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t
	If FileExists($dirAttacksCSV & "\" & $filename & ".csv") Then
		ShellExecute("notepad.exe", $dirAttacksCSV & "\" & $filename & ".csv")
	EndIf
EndFunc   ;==>EditDBScript

Func EditABScript()
	Local $tempvect1 = _GUICtrlComboBox_GetListArray($cmbABScriptName)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($cmbABScriptName) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t
	If FileExists($dirAttacksCSV & "\" & $filename & ".csv") Then
		ShellExecute("notepad.exe", $dirAttacksCSV & "\" & $filename & ".csv")
	EndIf
EndFunc   ;==>EditABScript

Func AttackCSVAssignDefaultScriptName()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($dirAttacksCSV & "\*.csv")
	Dim $output = ""
	$NewFile = FileFindNextFile($FileSearch)
	If @error Then $output = ""
	$output = StringLeft($NewFile, StringLen($NewFile) - 4)
	FileClose($FileSearch)
	;remove last |
	_GUICtrlComboBox_SetCurSel($cmbDBScriptName, _GUICtrlComboBox_FindStringExact($cmbDBScriptName, $output))
	_GUICtrlComboBox_SetCurSel($cmbABScriptName, _GUICtrlComboBox_FindStringExact($cmbDBScriptName, $output))
	cmbDBScriptName()
	cmbABScriptName()
EndFunc   ;==>AttackCSVAssignDefaultScriptName

;Parse this first on load of bot, needed outside the function to update current language.ini file. Used on Func NewABScript() and NewDBScript()
Local $temp1 = GetTranslated(14, 47, "Create New Script File"), $temp2 = GetTranslated(14, 48, "New Script Filename")
Local $temp3 = GetTranslated(14, 49, "File exists, please input a new name"), $temp4 = GetTranslated(14, 50, "An error occurred when creating the file.")
Local $temp1 = 0, $temp2 = 0, $temp3 = 0, $temp4 = 0 ; empty temp vars

Func NewDBScript()
	Local $filenameScript = InputBox(GetTranslated(14, 47, -1), GetTranslated(14, 48, -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($dirAttacksCSV & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslated(14, 49, -1))
		Else
			Local $hFileOpen = FileOpen($dirAttacksCSV & "\" & $filenameScript & ".csv", $FO_APPEND)
			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslated(14, 50, -1))
				Return False
			Else
				FileClose($hFileOpen)
				$scmbDBScriptName = $filenameScript
				UpdateComboScriptName()

			EndIf
		EndIf
	EndIf
EndFunc   ;==>NewDBScript

Func NewABScript()
	Local $filenameScript = InputBox(GetTranslated(14, 47, -1), GetTranslated(14, 48, -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($dirAttacksCSV & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslated(14, 49, -1))
		Else
			Local $hFileOpen = FileOpen($dirAttacksCSV & "\" & $filenameScript & ".csv", $FO_APPEND)
			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslated(14, 50, -1))
				Return False
			Else
				FileClose($hFileOpen)
				$scmbABScriptName = $filenameScript
				UpdateComboScriptName()

			EndIf
		EndIf
	EndIf
EndFunc   ;==>NewABScript

;Parse this first on load of bot, needed outside the function to update current language.ini file. Used on Func DuplicateABScript() and DuplicateDBScript()
Local $temp1 = GetTranslated(14, 51, "Copy to New Script File"), $temp2 = GetTranslated(14, 52, "Copy"), $temp3 = GetTranslated(14, 53, "to New Script Filename")
Local $temp1 = 0, $temp2 = 0, $temp3 = 0 ; empty temp vars

Func DuplicateABScript()
	Local $filenameScript = InputBox(GetTranslated(14, 51, -1), GetTranslated(14, 52, -1) & ": <" & $scmbABScriptName & ">" & @CRLF & GetTranslated(14, 53, -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($dirAttacksCSV & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslated(14, 49, -1))
		Else
			Local $hFileOpen = FileCopy($dirAttacksCSV & "\" & $scmbABScriptName & ".csv", $dirAttacksCSV & "\" & $filenameScript & ".csv")

			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslated(14, 50, -1))
				Return False
			Else
				FileClose($hFileOpen)
				$scmbABScriptName = $filenameScript
				UpdateComboScriptName()
			EndIf
		EndIf
	EndIf
EndFunc   ;==>DuplicateABScript

Func DuplicateDBScript()
	Local $filenameScript = InputBox(GetTranslated(14, 51, -1), GetTranslated(14, 52, -1) & ": <" & $scmbDBScriptName & ">" & @CRLF & GetTranslated(14, 53, -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($dirAttacksCSV & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslated(14, 49, -1))
		Else
			Local $hFileOpen = FileCopy($dirAttacksCSV & "\" & $scmbDBScriptName & ".csv", $dirAttacksCSV & "\" & $filenameScript & ".csv")

			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslated(14, 50, -1))
				Return False
			Else
				FileClose($hFileOpen)
				$scmbDBScriptName = $filenameScript
				UpdateComboScriptName()
			EndIf
		EndIf
	EndIf
EndFunc   ;==>DuplicateDBScript
