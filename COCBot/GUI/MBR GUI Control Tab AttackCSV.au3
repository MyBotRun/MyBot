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
	For $i = $grpDeadBaseDeploy to $chkDBDropCC
		If GUICtrlRead($chkUseAttackDBCSV) = $GUI_CHECKED  Then
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
EndFunc

Func chkUseAttackABCSV()
	For $i = $grpLiveBaseDeploy to $chkABDropCC
		If GUICtrlRead($chkUseAttackABCSV) = $GUI_CHECKED  Then
			GUICtrlSetState($i, $GUI_DISABLE)
		Else
			GUICtrlSetState($i, $GUI_ENABLE)
		EndIf
	Next
	chkABSmartAttackRedArea()
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
EndFunc


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
	GUICtrlSetData($lblNotesDBScript,"")

EndFunc


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
	GUICtrlSetData($lblNotesABScript,"")

EndFunc


Func cmbDBScriptName()

 	Local $tempvect1 = _GUICtrlComboBox_GetListArray($cmbDBScriptName)
 	Local $filename =  $tempvect1[_GUICtrlComboBox_GetCurSel($cmbDBScriptName) + 1]
	Local $f ,$result = ""
	Local $tempvect, $line, $t

	$scmbDBScriptName = $filename

 	If FileExists($dirAttacksCSV & "\" &$filename & ".csv") Then
		$f = FileOpen($dirAttacksCSV & "\" &$filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			$tempVect = StringSplit($line, "|",2)
			if Ubound($tempVect)>=2 Then
				if StringStripWS(StringUpper( $tempvect[0] ),2)   = "NOTE" Then $result &= $tempvect[1]&  @CRLF
			EndIf
		WEnd
		FileClose($f)

	EndIf
	GUICtrlSetData($lblNotesDBScript,$result)
EndFunc

Func cmbABScriptName()

 	Local $tempvect1 = _GUICtrlComboBox_GetListArray($cmbABScriptName)
 	Local $filename =  $tempvect1[_GUICtrlComboBox_GetCurSel($cmbABScriptName) + 1]
	Local $f ,$result = ""
	Local $tempvect, $line, $t

	$scmbABScriptName = $filename

 	If FileExists($dirAttacksCSV & "\" &$filename & ".csv") Then
		$f = FileOpen($dirAttacksCSV & "\" &$filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			$tempVect = StringSplit($line, "|",2)
			if Ubound($tempVect)>=2 Then
				if StringStripWS(StringUpper( $tempvect[0] ),2)   = "NOTE" Then $result &= $tempvect[1]&  @CRLF
			EndIf
		WEnd
		FileClose($f)

	EndIf
	GUICtrlSetData($lblNotesABScript,$result)
EndFunc

Func UpdateComboScriptName()
     PopulateDBComboScriptsFiles()
   	_GUICtrlComboBox_SetCurSel($cmbDBScriptName, _GUICtrlComboBox_FindStringExact($cmbDBScriptName, $scmbDBScriptName))
	cmbDBScriptName()
	PopulateABComboScriptsFiles() ; recreate combo box values
	_GUICtrlComboBox_SetCurSel($cmbABScriptName, _GUICtrlComboBox_FindStringExact($cmbABScriptName, $scmbABScriptName))
	cmbABScriptName()
 EndFunc

Func EditDBScript()
 	Local $tempvect1 = _GUICtrlComboBox_GetListArray($cmbDBScriptName)
 	Local $filename =  $tempvect1[_GUICtrlComboBox_GetCurSel($cmbDBScriptName) + 1]
	Local $f ,$result = ""
	Local $tempvect, $line, $t
 	If FileExists($dirAttacksCSV & "\" &$filename & ".csv") Then
	  ShellExecute("notepad.exe",  $dirAttacksCSV & "\" &$filename & ".csv")
    EndIf
 EndFunc

 Func EditABScript()
 	Local $tempvect1 = _GUICtrlComboBox_GetListArray($cmbABScriptName)
 	Local $filename =  $tempvect1[_GUICtrlComboBox_GetCurSel($cmbABScriptName) + 1]
	Local $f ,$result = ""
	Local $tempvect, $line, $t
 	If FileExists($dirAttacksCSV & "\" &$filename & ".csv") Then
	  ShellExecute("notepad.exe",  $dirAttacksCSV & "\" &$filename & ".csv")
    EndIf
 EndFunc

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
EndFunc