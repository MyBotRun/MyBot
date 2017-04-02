; #FUNCTION# ====================================================================================================================
; Name ..........: ParseAttackCSV_Read_SIDE_variables
; Description ...:
; Syntax ........: ParseAttackCSV_Read_SIDE_variables()
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ParseAttackCSV_Read_SIDE_variables()

	$g_bCSVLocateMine = False
	$g_bCSVLocateElixir = False
	$g_bCSVLocateDrill = False
	$g_bCSVLocateStorageGold = False
	$g_bCSVLocateStorageElixir = False
	$g_bCSVLocateStorageDarkElixir = False
	$g_bCSVLocateStorageTownHall = False
	$g_bCSVLocateEagle = False
	; $g_bCSVLocateInferno = False
	; $g_bCSVLocateXBow = False
	; $g_bCSVLocateWizTower = False
	; $g_bCSVLocateMortar = False
	; $g_bCSVLocateAirDefense = False
	; $g_bCSVLocateGemBox = False

	If $g_iMatchMode = $DB Then
		Local $filename = $g_sAttackScrScriptName[$DB]
	Else
		Local $filename = $g_sAttackScrScriptName[$LB]
	EndIf

	Local $f, $line, $acommand, $command
	Local $value1, $value2, $value3, $value4, $value5, $value6, $value7, $value8, $value9
	Local $bForceSideExist = False

	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		$f = FileOpen($g_sCSVAttacksPath & "\" & $filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), $STR_STRIPTRAILING)
				If $command <> "SIDE" And $command <> "SIDEB" Then ContinueLoop
				$value1 = StringStripWS(StringUpper($acommand[2]), $STR_STRIPTRAILING)
				$value2 = StringStripWS(StringUpper($acommand[3]), $STR_STRIPTRAILING)
				$value3 = StringStripWS(StringUpper($acommand[4]), $STR_STRIPTRAILING)
				$value4 = StringStripWS(StringUpper($acommand[5]), $STR_STRIPTRAILING)
				$value5 = StringStripWS(StringUpper($acommand[6]), $STR_STRIPTRAILING)
				$value6 = StringStripWS(StringUpper($acommand[7]), $STR_STRIPTRAILING)
				$value7 = StringStripWS(StringUpper($acommand[8]), $STR_STRIPTRAILING)
				$value8 = StringStripWS(StringUpper($acommand[9]), $STR_STRIPTRAILING)
				$value9 = StringStripWS(StringUpper($acommand[10]), $STR_STRIPTRAILING)


				If $command = "SIDE" Then
					;forced side
					If StringUpper($value8) = "TOP-LEFT" Or StringUpper($value8) = "TOP-RIGHT" Or StringUpper($value8) = "BOTTOM-LEFT" Or StringUpper($value8) = "BOTTOM-RIGHT" Then
						;keep original values
						$bForceSideExist = True
					Else
						;if this line uses a building, then it must be detected
						If Int($value1) > 0 Then $g_bCSVLocateMine = True
						If Int($value2) > 0 Then $g_bCSVLocateElixir = True
						If Int($value3) > 0 Then $g_bCSVLocateDrill = True
						If Int($value4) > 0 Then $g_bCSVLocateStorageGold = True
						If Int($value5) > 0 Then $g_bCSVLocateStorageElixir = True
						If Int($value6) > 0 Then $g_bCSVLocateStorageDarkElixir = True
						If Int($value7) > 0 Then $g_bCSVLocateStorageTownHall = True
						; $value8 = Forced Side value
					EndIf
				EndIf

				If $command = "SIDEB" And $bForceSideExist = False Then
					If Int($value1) > 0 Then $g_bCSVLocateEagle = True
					;	If Int($value2) > 0 Then $g_bCSVLocateInferno = True
					;	If Int($value3) > 0 Then $g_bCSVLocateXBow = True
					;	If Int($value4) > 0 Then $g_bCSVLocateWizTower = True
					;	If Int($value5) > 0 Then $g_bCSVLocateMortar = True
					;	If Int($value6) > 0 Then $g_bCSVLocateAirDefense = True
					;	If Int($value7) > 0 Then $g_bCSVLocateGemBox = True
					;	If Int($value8) > 0 Then $g_bCSVLocateGemBox = True
				EndIf

			EndIf
		WEnd
		FileClose($f)
	Else
		SetLog("Cannot find attack file " & $g_sCSVAttacksPath & "\" & $filename & ".csv", $COLOR_ERROR)
	EndIf
EndFunc   ;==>ParseAttackCSV_Read_SIDE_variables
