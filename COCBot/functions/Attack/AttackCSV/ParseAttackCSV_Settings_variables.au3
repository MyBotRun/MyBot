; #FUNCTION# ====================================================================================================================
; Name ..........: ParseAttackCSV_Settings_variables
; Description ...: Parse CSV settings and update byref var
; Syntax ........: ParseAttackCSV_Settings_variables(ByRef $aiCSVTroops, ByRef $aiCSVSpells, ByRef $aiCSVHeros, , ByRef $aiWardenMode, ByRef $iCSVRedlineRoutineItem, ByRef $iCSVDroplineEdgeItem, ByRef $sCSVCCReq, $sFilename)
; Parameters ....:
; Return values .: Success: 1
;				   Failure: 0
; Author ........: MMHK (01-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ParseAttackCSV_Settings_variables(ByRef $aiCSVTroops, ByRef $aiCSVSpells, ByRef $aiCSVSieges, ByRef $aiCSVHeros, ByRef $aiCSVWardenMode, _
		ByRef $iCSVRedlineRoutineItem, ByRef $iCSVDroplineEdgeItem, ByRef $sCSVCCReq, ByRef $sCSVCCSpl, $sFilename)
	If $g_bDebugAttackCSV Then SetLog("ParseAttackCSV_Settings_variables()", $COLOR_DEBUG)

	Local $asCommand
	If FileExists($g_sCSVAttacksPath & "\" & $sFilename & ".csv") Then
		Local $asLine = FileReadToArray($g_sCSVAttacksPath & "\" & $sFilename & ".csv")
		If @error Then
			SetLog("Attack CSV script not found: " & $g_sCSVAttacksPath & "\" & $sFilename & ".csv", $COLOR_ERROR)
			Return
		EndIf

		Local $sLine
		Local $iTHCol = 0, $iTH = 0
		Local $iTroopIndex, $iCCSpellIndex, $iFlexTroopIndex = 999
		Local $iCommandCol = 1, $iTroopNameCol = 2, $iFlexCol = 3, $iTHBeginCol = 4
		Local $iHeroRadioItemTotal = 3, $iHeroTimedLimit = 99

		For $iLine = 0 To UBound($asLine) - 1
			$sLine = $asLine[$iLine]
			$asCommand = StringSplit($sLine, "|")
			If $asCommand[0] >= 8 Then
				$asCommand[$iCommandCol] = StringStripWS(StringUpper($asCommand[$iCommandCol]), $STR_STRIPTRAILING)
				If Not StringRegExp($asCommand[$iCommandCol], "(TRAIN)|(WMODE)|(REDLN)|(DRPLN)|(CCREQ)|(CCSPL)|(BOOST)", $STR_REGEXPMATCH) Then ContinueLoop

				If $iTHCol = 0 Then ; select a command column TH based on camp space or skip all commands
					If $g_bDebugAttackCSV Then SetLog("Camp Total Space: " & $g_iTotalCampSpace, $COLOR_DEBUG)
					If $g_bDebugAttackCSV Then SetLog("Spell Total Space: " & $g_iTotalSpellValue, $COLOR_DEBUG)
					If $g_iTotalCampSpace = 0 Then
						SetLog("Has to run bot once first to get correct total camp space", $COLOR_ERROR)
						Return
					EndIf
					If $g_iTotalSpellValue = 0 Then
						SetLog("Has to set spell capacity first", $COLOR_ERROR)
						Return
					EndIf
					Switch $g_iTotalCampSpace
						Case $g_iMaxCapTroopTH[15] + 5 To $g_iMaxCapTroopTH[16]    ; TH16
							$iTHCol = $iTHBeginCol + 10
							$iTH = 16
						Case $g_iMaxCapTroopTH[14] + 5 To $g_iMaxCapTroopTH[15]    ; TH15
							$iTHCol = $iTHBeginCol + 9
							$iTH = 15
						Case $g_iMaxCapTroopTH[13] + 5 To $g_iMaxCapTroopTH[14]    ; TH14
							$iTHCol = $iTHBeginCol + 8
							$iTH = 14
						Case $g_iMaxCapTroopTH[12] + 5 To $g_iMaxCapTroopTH[13]    ; TH13
							$iTHCol = $iTHBeginCol + 7
							$iTH = 13
						Case $g_iMaxCapTroopTH[11] + 5 To $g_iMaxCapTroopTH[12]    ; TH12
							$iTHCol = $iTHBeginCol + 6
							$iTH = 12
						Case $g_iMaxCapTroopTH[10] + 5 To $g_iMaxCapTroopTH[11]    ; TH11
							$iTHCol = $iTHBeginCol + 5
							$iTH = 11
						Case $g_iMaxCapTroopTH[9] + 5 To $g_iMaxCapTroopTH[10]    ; TH10
							$iTHCol = $iTHBeginCol + 4
							$iTH = 10
						Case $g_iMaxCapTroopTH[8] + 5 To $g_iMaxCapTroopTH[9]    ; TH9
							$iTHCol = $iTHBeginCol + 3
							$iTH = 9
						Case $g_iMaxCapTroopTH[6] + 5 To $g_iMaxCapTroopTH[8]    ; TH7/8
							Switch $g_iTotalSpellValue
								Case $g_iMaxCapSpellTH[7] + 1 To $g_iMaxCapSpellTH[8]    ; TH8
									$iTHCol = $iTHBeginCol + 2
									$iTH = 8
								Case $g_iMaxCapSpellTH[6] + 1 To $g_iMaxCapSpellTH[7]    ; TH7
									$iTHCol = $iTHBeginCol + 1
									$iTH = 7
								Case Else
									SetLog("Invalid spell size ( <" & $g_iMaxCapSpellTH[6] + 1 & " or >" & $g_iMaxCapSpellTH[8] & " ): " & $g_iTotalSpellValue & " for CSV", $COLOR_ERROR)
									Return
							EndSwitch
						Case $g_iMaxCapTroopTH[5] + 5 To $g_iMaxCapTroopTH[6]    ; TH6
							$iTHCol = $iTHBeginCol
							$iTH = 6
						Case Else
							SetLog("Invalid camp size ( <" & $g_iMaxCapTroopTH[5] + 5 & " or >" & $g_iMaxCapTroopTH[11] & " ): " & $g_iTotalCampSpace & " for CSV", $COLOR_ERROR)
							Return
					EndSwitch
				EndIf

				If $g_bDebugAttackCSV Then SetLog("Line: " & $iLine + 1 & " Command: " & $asCommand[$iCommandCol] & ($iTHCol >= $iTHBeginCol ? " Column: " & $iTHCol & " TH" & $iTH : ""), $COLOR_DEBUG)
				For $i = 2 To (UBound($asCommand) - 1)
					$asCommand[$i] = StringStripWS($asCommand[$i], $STR_STRIPTRAILING)
				Next
				Switch $asCommand[$iCommandCol]
					Case "TRAIN"
						$iTroopIndex = TroopIndexLookup($asCommand[$iTroopNameCol], "ParseAttackCSV_Settings_variables")
						If $iTroopIndex = -1 Then
							SetLog("CSV troop name '" & $asCommand[$iTroopNameCol] & "' is unrecognized - Line: " & $iLine + 1, $COLOR_ERROR)
							ContinueLoop ; discard TRAIN commands due to the invalid troop name
						EndIf
						If Int($asCommand[$iTHCol]) <= 0 Then
							If $asCommand[$iTHCol] <> "0" Then SetLog("CSV troop amount/setting '" & $asCommand[$iTHCol] & "' is unrecognized - Line: " & $iLine + 1, $COLOR_ERROR)
							ContinueLoop ; discard TRAIN commands due to the invalid troop amount/setting ex. int(chars)=0, negative #. "0" won't get alerted
						EndIf
						Switch $iTroopIndex
							Case $eBarb To $eAppWard
								$aiCSVTroops[$iTroopIndex] = Int($asCommand[$iTHCol])
								If Int($asCommand[$iFlexCol]) > 0 Then $iFlexTroopIndex = $iTroopIndex
							Case $eLSpell To $eOgSpell
								$aiCSVSpells[$iTroopIndex - $eLSpell] = Int($asCommand[$iTHCol])
							Case $eWallW To $eBattleD
								$aiCSVSieges[$iTroopIndex - $eWallW] = Int($asCommand[$iTHCol])
							Case $eKing To $eChampion
								Local $iHeroRadioItem = Int(StringLeft($asCommand[$iTHCol], 1))
								Local $iHeroTimed = Int(StringTrimLeft($asCommand[$iTHCol], 1))
								If $iHeroRadioItem <= 0 Or $iHeroRadioItem > $iHeroRadioItemTotal Or $iHeroTimed < 0 Or $iHeroTimed > $iHeroTimedLimit Then
									SetLog("CSV hero ability setting '" & $asCommand[$iTHCol] & "' is unrecognized - Line: " & $iLine + 1, $COLOR_ERROR)
									ContinueLoop ; discard TRAIN commands due to prefix 0 or exceed # of radios
								EndIf
								$aiCSVHeros[$iTroopIndex - $eKing][0] = $iHeroRadioItem
								$aiCSVHeros[$iTroopIndex - $eKing][1] = $iHeroTimed * 1000
						EndSwitch
						If $g_bDebugAttackCSV Then SetLog("Train " & $asCommand[$iTHCol] & "x " & $asCommand[$iTroopNameCol], $COLOR_DEBUG)
					Case "WMODE"
						$aiCSVWardenMode = Int($asCommand[$iTHCol])
						If $g_bDebugAttackCSV Then SetLog("Warden Mode : " & $aiCSVWardenMode, $COLOR_DEBUG)
					Case "REDLN"
						$iCSVRedlineRoutineItem = Int($asCommand[$iTHCol])
						If $g_bDebugAttackCSV Then SetLog("Redline ComboBox #" & ($iCSVRedlineRoutineItem > 0 ? $iCSVRedlineRoutineItem : "None"), $COLOR_DEBUG)
					Case "DRPLN"
						$iCSVDroplineEdgeItem = Int($asCommand[$iTHCol])
						If $g_bDebugAttackCSV Then SetLog("Dropline ComboBox #" & ($iCSVDroplineEdgeItem > 0 ? $iCSVDroplineEdgeItem : "None"), $COLOR_DEBUG)
					Case "CCREQ"
						$sCSVCCReq = $asCommand[$iTHCol]
						If $g_bDebugAttackCSV Then SetLog("CC Request: " & $sCSVCCReq, $COLOR_DEBUG)
					Case "CCSPL"
						$iCCSpellIndex = TroopIndexLookup($asCommand[$iTroopNameCol], "ParseAttackCSV_Settings_variables")
						If $iCCSpellIndex = -1 Then
							SetLog("CSV spell name '" & $asCommand[$iTroopNameCol] & "' is unrecognized - Line: " & $iLine + 1, $COLOR_ERROR)
							ContinueLoop ; discard TRAIN commands due to the invalid troop name
						EndIf
						If Int($asCommand[$iTHCol]) <= 0 Or Int($asCommand[$iTHCol]) > 1 Then
							If $asCommand[$iTHCol] <> "0" Then SetLog("CSV CC Spell amount/setting '" & $asCommand[$iTHCol] & "' is unrecognized - Line: " & $iLine + 1, $COLOR_ERROR)
							ContinueLoop ; discard CC Spell commands due to the invalid troop amount/setting ex. int(chars)=0, negative #. "0" won't get alerted
						EndIf
						$sCSVCCSpl[$iCCSpellIndex - $eLSpell] = Int($asCommand[$iTHCol])
						If $g_bDebugAttackCSV Then SetLog("CC Spell " & $asCommand[$iTHCol] & "x " & $asCommand[$iTroopNameCol], $COLOR_DEBUG)
				EndSwitch
			EndIf
		Next
		If $iTHCol >= $iTHBeginCol Then
			Local $iCSVTotalCapTroops = 0, $bTotalInRange = False
			For $i = 0 To UBound($aiCSVTroops) - 1
				$iCSVTotalCapTroops += $aiCSVTroops[$i] * $g_aiTroopSpace[$i]
			Next
			If $g_bDebugAttackCSV Then SetLog("CSV troop total: " & $iCSVTotalCapTroops, $COLOR_DEBUG)
			If $iCSVTotalCapTroops > 0 Then
				If $iTH = 8 Then ; TH8 	; check if csv has right troops total within the range of the TH level
					If $iCSVTotalCapTroops > $g_iMaxCapTroopTH[$iTH - 2] And $iCSVTotalCapTroops <= $g_iMaxCapTroopTH[$iTH] Then $bTotalInRange = True
				Else
					If $iCSVTotalCapTroops > $g_iMaxCapTroopTH[$iTH - 1] And $iCSVTotalCapTroops <= $g_iMaxCapTroopTH[$iTH] Then $bTotalInRange = True
				EndIf
				If $bTotalInRange Then     ;if total not equal to user camp space, reduce/add troops amount based on flexible flag if possible
					If $iCSVTotalCapTroops <> $g_iTotalCampSpace Then
						Local $iDiff = $iCSVTotalCapTroops - $g_iTotalCampSpace
						If $g_bDebugAttackCSV Then SetLog("Camp Total Space: " & $g_iTotalCampSpace, $COLOR_DEBUG)
						If $g_bDebugAttackCSV Then SetLog("Difference: " & $iDiff, $COLOR_DEBUG)
						If $g_bDebugAttackCSV Then SetLog("Flexible Index: " & $iFlexTroopIndex, $COLOR_DEBUG)
						If $iFlexTroopIndex <> 999 And Mod($iDiff, $g_aiTroopSpace[$iFlexTroopIndex]) = 0 Then
							Local $iCSVTroopAmount = $aiCSVTroops[$iFlexTroopIndex]
							$aiCSVTroops[$iFlexTroopIndex] -= $iDiff / $g_aiTroopSpace[$iFlexTroopIndex]
							SetLog("Adjust CSV Train Troop - " & GetTroopName($iFlexTroopIndex) & " amount from " & $iCSVTroopAmount & " to " & $aiCSVTroops[$iFlexTroopIndex], $COLOR_SUCCESS)
						Else
							SetLog("CSV Troop Total does not equal to Camp Total Space,", $COLOR_ERROR)
							SetLog("adjust train settings manually", $COLOR_ERROR)
							For $i = 0 To UBound($aiCSVTroops) - 1 ; set troop amount to all 0
								$aiCSVTroops[$i] = 0
							Next
						EndIf
					EndIf
				Else
					SetLog("CSV troops total: " & $iCSVTotalCapTroops & " for TH" & $iTH & " is out of range", $COLOR_ERROR)
					For $i = 0 To UBound($aiCSVTroops) - 1 ; set troop amount to all 0
						$aiCSVTroops[$i] = 0
					Next
				EndIf
			EndIf
		EndIf
	Else
		SetLog("Cannot find attack file " & $g_sCSVAttacksPath & "\" & $sFilename & ".csv", $COLOR_ERROR)
		Return
	EndIf
	Return 1
EndFunc   ;==>ParseAttackCSV_Settings_variables
