; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Preset
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

Func PopulatePresetComboBox()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($sPreset & "\*.ini")
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
	_GUICtrlComboBox_ResetContent($cmbPresetList)
	;set combo box
	GUICtrlSetData($cmbPresetList, $output)

EndFunc   ;==>PopulatePresetComboBox

Func PresetLoadConfigInfo()
	Local $inputfilename = $sPreset & "\" & GUICtrlRead($cmbPresetList) & ".ini"
	Local $message = IniRead($inputfilename, "Preset", "info", "")
	If StringInStr($message, "\n") > 0 Then
		GUICtrlSetData($txtPresetMessage, StringReplace($message, "\n", @CRLF))
	Else
		GUICtrlSetData($txtPresetMessage, $message)
	EndIf

	GUICtrlSetState($lblLoadPresetMessage, $GUI_HIDE)
	GUICtrlSetState($txtPresetMessage, $GUI_SHOW)
	GUICtrlSetState($btnGUIPresetLoadConf, $GUI_SHOW)
	GUICtrlSetState($btnGUIPresetDeleteConf, $GUI_SHOW + $GUI_DISABLE)
	GUICtrlSetState($chkCheckDeleteConf, $GUI_UNCHECKED)
	GUICtrlSetState($chkCheckDeleteConf, $GUI_SHOW)

EndFunc   ;==>PresetLoadConfigInfo

Func PresetLoadConf()
	Local $filename = GUICtrlRead($cmbPresetList)
	$SecondaryInputFile = $sPreset & "\" & $filename & ".ini"
;~ 	CloseGUIPreset()
	SaveConfig()
	readConfig()
	applyConfig(False) ; bot window redraw stays disabled!
	_GUICtrlTab_ClickTab($tabMain, 0)
	SetRedrawBotWindow(True) ; enable redraw again, applyConfig(False) keeps it disabled
	Setlog("Config " & $filename & " LOADED!", $COLOR_GREEN)
	$SecondaryInputFile = ""
EndFunc   ;==>PresetLoadConf


Func PresetSaveConf()

	;1 remove .ini from filename
	Local $filename = GUICtrlRead($txtPresetSaveFilename)
	If StringRight($filename, 4) = ".ini" Then
		$filename = StringLeft($filename, StringLen($filename) - 4)
		GUICtrlSetData($txtPresetSaveFilename, $filename)
	EndIf

	;2 check illegal caracter and replace
	If StringRegExp($filename, '\\|/|:|\*|\?|\"|\<|\>|\|') Then GUICtrlSetData($txtPresetSaveFilename, StringRegExpReplace($filename, '\\|/|:|\*|\?|\"|\<|\>|\|', "_"))

	;3 check if file allready exists
	If FileExists($sPreset & "\" & $filename & ".ini") Then
		Local $i = 2
		While $i > 0
			If FileExists($sPreset & "\" & $filename & " (" & $i & ").ini") Then
				$i += 1
			Else
				$filename = $filename & " (" & $i & ")"
				GUICtrlSetData($txtPresetSaveFilename, $filename)
				$i = 0
			EndIf
		WEnd
	EndIf

	;4 save config
	Local $msg = StringReplace(GUICtrlRead($txtSavePresetMessage), @CRLF, "\n")
	$SecondaryOutputFile = $sPreset & "\" & $filename & ".ini"
	IniWrite($SecondaryOutputFile, "preset", "info", $msg)
;~ 	CloseGUIPreset()
	saveConfig()
	readconfig()
	applyConfig()
	_GUICtrlTab_ClickTab($tabMain, 0)
	Setlog("Config " & $filename & " SAVED!", $COLOR_GREEN)
	$SecondaryOutputFile = ""

EndFunc   ;==>PresetSaveConf

Func PresetDeleteConf()
	Local $button = MsgBox($MB_ICONWARNING + $MB_OKCANCEL, GetTranslated(640, 70, "Delete Configuration"), GetTranslated(640, 71, 'Are you sure you want to delete the configuration ?') & GUICtrlRead($cmbPresetList) & '"?' & @CRLF & _
			"This cannot be undone.")
	If $button = $IDOK Then
		FileDelete($sPreset & "\" & GUICtrlRead($cmbPresetList) & ".ini")
;~ 		applyPreset()
		saveconfig()
		readconfig()
		applyConfig()
	EndIf
EndFunc   ;==>PresetDeleteConf

Func chkCheckDeleteConf()
	If GUICtrlRead($chkCheckDeleteConf) = $GUI_CHECKED Then
		GUICtrlSetState($btnGUIPresetDeleteConf, $GUI_ENABLE)
	Else
		GUICtrlSetState($btnGUIPresetDeleteConf, $GUI_DISABLE)
	EndIf

EndFunc   ;==>chkCheckDeleteConf
;==================================================================


Func MakeSavePresetMessage()
	Local $message = ""

	$message &= "NOTES:" & @CRLF & @CRLF


	If $iChkTrophyRange = 1 Then $message &= "TROPHIES RANGE: " & $itxtdropTrophy & " - " & $itxtMaxTrophy & @CRLF & @CRLF
	$message &= "TRAIN ARMY SETTINGS:" & @CRLF
	If $iCmbTroopComp = 8 Then
		;$message &="- Elixir Troops: Barracks" & @CRLF
		$message &= "- Barracks: "
		Local $troopelixirname = StringSplit($sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas, "|", 2)
		For $i = 1 To 4
			$message &= $troopelixirname[$barrackTroop[$i - 1]]
			If $i < 4 Then $message &= ", "
		Next
		$message &= @CRLF
	Else
		$message &= "- Elixir Troops: Custom" & @CRLF
		For $i = 0 To UBound($TroopName) - 1
			If Eval($TroopName[$i] & "Comp") > 0 Then
				$message &= "  " & $TroopName[$i] & " " & Eval($TroopName[$i] & "Comp")
				If $TroopName[$i] = "Arch" Or $TroopName[$i] = "Barb" Or $TroopName[$i] = "Gobl" Then $message &= "%"
				If Mod($i + 1, 4) = 0 Then $message &= @CRLF
			EndIf
		Next
		$message &= @CRLF
	EndIf
	Switch $icmbDarkTroopComp
		Case "0"
			$message &= "- Dark Elixir Troops: Barracks: "
			$message &= (($darkBarrackTroop[0] < UBound($darkBarrackTroop)) ? ($TroopDarkName[$darkBarrackTroop[0]]) : ("None"))
			$message &= "," & (($darkBarrackTroop[1] < UBound($darkBarrackTroop)) ? ($TroopDarkName[$darkBarrackTroop[1]]) : ("None"))
			$message &= @CRLF
		Case "1"
			$message &= "- Dark Elixir Troops: Custom" & @CRLF
			Local $troopDarkelixirname = StringSplit($sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds & "|" & $sTxtNone, "|", 2)
			For $i = 0 To UBound($TroopDarkName) - 1
				;$Message &= $TroopDarkName[$i] & "£ " & Eval( $TroopDarkName[$i] & "Comp")
				If Eval($TroopDarkName[$i] & "Comp") > 0 Then
					$message &= "  " & $TroopDarkName[$i] & " " & Eval($TroopDarkName[$i] & "Comp")
					If Mod($i + 1, 4) = 0 Then $message &= @CRLF
				EndIf
			Next
			$message &= @CRLF

		Case "2"
			$message &= "- Dark Elixir Troops: None" & @CRLF
	EndSwitch

	$message &= "SEARCH SETTINGS:" & @CRLF
	For $i = $DB To $TS
		If IsSearchModeActive($i, True) Then
			Switch $i
				Case $DB
					$message &= "- DB search: "
				Case $LB
					$message &= "- AS search: "
				Case $TS
					$message &= "- TH search: "
			EndSwitch
			If $iEnableSearchSearches[$i] = 1 Then $message &= " " & "s. " & $iEnableAfterCount[$i] & "-" & $iEnableBeforeCount[$i]
			If $iEnableSearchTropies[$i] = 1 Then $message &= "  " & "t. " & $iEnableAfterTropies[$i] & "-" & $iEnableBeforeTropies[$i]
			If $iEnableSearchCamps[$i] = 1 Then $message &= " " & "c. >" & $iEnableAfterArmyCamps[$i] & "%"
			$message &= @CRLF
			Switch $i
				Case $DB
					$message &= "- DB filter: "
				Case $LB
					$message &= "- AS filter: "
				Case $TS
					$message &= "- TH filter: "
			EndSwitch
			Switch $iCmbMeetGE[$i]
				Case 0
					$message &= " G >= " & $iMinGold[$i]
					$message &= " & "
					$message &= " E >= " & $iMinElixir[$i] & "  "
				Case 1
					$message &= " G >= " & $iMinGold[$i]
					$message &= " or "
					$message &= " E >= " & $iMinElixir[$i] & "  "
				Case 2
					$message &= " G+E >= " & $iMinGoldPlusElixir[$i] & "  "
			EndSwitch
			If $iChkMeetDE[$i] = 1 Then $message &= " D >= " & $iMinDark[$i] & "  "
			If $iChkMeetTrophy[$i] = 1 Then $message &= " TR >= " & $iMinTrophy[$i] & "  "
			If $iChkMeetTH[$i] = 1 Then $message &= " TH >= " & $iCmbTH[$i] + 6 & "  "
			If $iChkMeetTHO[$i] = 1 Then $message &= " THO" & "  "
			If $iChkWeakBase[$i] = 1 Then $message &= " WB" & "  "
			If $iChkMeetOne[$i] = 1 Then $message &= " MeetOne" & "  "
			$message &= @CRLF
		EndIf
	Next



	$message &= @CRLF & "ATTACK SETTINGS:" & @CRLF
	For $i = $DB To $TS
		If IsSearchModeActive($i, True) Then
			Switch $i
				Case $DB
					$message &= "- DB: "
				Case $LB
					$message &= "- AS: "
				Case $TS
					$message &= "- TH: "
			EndSwitch
			If $i = $DB Or $i = $LB Then
				Switch $iAtkAlgorithm[$i]
					Case "0"
						$message &= "Standard Attack > "
					Case "1"
						$message &= "Scripted Attack > "
					Case "2"
						$message &= "Milking Attack   " & @CRLF
				EndSwitch
			EndIf
			If $i = $TS Then $message &= $scmbAttackTHType & @CRLF

			If ($i = $DB Or $i = $LB) And $iAtkAlgorithm[$i] = 0 Then
				Local $tmp = StringSplit("one side|two sides|three sides|four sides|DE side|TH side", "|", 2)
				$message &= $tmp[$iChkDeploySettings[$i]] & @CRLF
			EndIf
		EndIf
	Next


	$message &= @CRLF & "END BATTLE SETTINGS:" & @CRLF
	For $i = $DB To $TS
		If IsSearchModeActive($i, True) Then
			Switch $i
				Case $DB
					$message &= "- DB: "
				Case $LB
					$message &= "- AS: "
				Case $TS
					$message &= "- TH: "
			EndSwitch
			If $iChkTimeStopAtk[$i] = 1 Then $message &= "wait " & $sTimeStopAtk[$i] & "  "
			If $iChkTimeStopAtk2[$i] = 1 Then $message &= "wait " & $sTimeStopAtk2[$i] & " ->(" & $stxtMinGoldStopAtk2[$i] & "," & $stxtMinElixirStopAtk2[$i] & "," & $stxtMinDarkElixirStopAtk2[$i] & ")  "
			If $ichkEndNoResources[$i] = 1 Then $message &= "nores "
			If $ichkEndOneStar[$i] = 1 Then $message &= "1star  "
			If $ichkEndTwoStars[$i] = 1 Then $message &= "2stars  "

		EndIf
		$message &= @CRLF
	Next


	GUICtrlSetData($txtSavePresetMessage, $message)
EndFunc   ;==>MakeSavePresetMessage

Func btnStrategyFolder()
	ShellExecute("explorer",$sPreset)
EndFunc
