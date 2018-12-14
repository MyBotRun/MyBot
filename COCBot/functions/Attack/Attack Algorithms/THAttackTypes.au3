; #FUNCTION# ==========================================================
; Name ..........: THAttackTypes
; Description ...: This file contens the TH attacks
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: AtoZ (2015)
; Modified ......: Barracoda (07-2015), TheMaster1st (10-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ================================================================

Func SwitchAttackTHType()
	$g_bTHSnipeUsedKing = False
	$g_bTHSnipeUsedQueen = False
	AttackTHParseCSV()
EndFunc   ;==>SwitchAttackTHType

Func AttackTHParseCSV($test = False)
	If $g_bDebugSetlog Then SetDebugLog("AttackTHParseCSV start", $COLOR_DEBUG)
	Local $f, $line, $acommand, $command

	Local $attackCSVtoUse = ""
	Switch $g_iMatchMode
		Case $TS
			$attackCSVtoUse = $g_sAtkTSType
		Case $LB
			$attackCSVtoUse = $g_iTHSnipeBeforeScript[$LB]
		Case $DB
			If $g_bDuringMilkingAttack = True Then
				$attackCSVtoUse = $g_sMilkFarmAlgorithmTh
			Else
				$attackCSVtoUse = $g_iTHSnipeBeforeScript[$DB]
			EndIf
	EndSwitch



	If FileExists($g_sTHSnipeAttacksPath & "\" & $attackCSVtoUse & ".csv") Then
		$f = FileOpen($g_sTHSnipeAttacksPath & "\" & $attackCSVtoUse & ".csv", 0)
		If $g_bDebugSetlog Then SetDebugLog("Use algorithm " & $attackCSVtoUse & ".csv", $COLOR_DEBUG)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			;SetLog("line content: " & $line)
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), 2)
				;   $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell
				Select
					Case $command = "TROOP" Or $command = ""
						;SetLog("<<<<discard line>>>>")
					Case $command = "TEXT"
						If $g_bDebugSetlog Then SetDebugLog(">> SETLOG(""" & $acommand[8] & """)")

						SetLog($acommand[8], $COLOR_INFO)

					Case StringInStr(StringUpper("-Barb-Arch-Giant-Gobl-Wall-Ball-Wiza-Heal-Drag-Pekk-BabyD-Mine-EDrag-Mini-Hogs-Valk-Gole-Witc-Lava-Bowl-IceG"), "-" & $command & "-") > 0
						If $g_bDebugSetlog Then SetDebugLog(">> AttackTHGrid($e" & $command & ", Random (" & Int($acommand[2]) & "," & Int($acommand[3]) & ",1), Random(" & Int($acommand[4]) & "," & Int($acommand[5]) & ",1), Random(" & Int($acommand[6]) & "," & Int($acommand[7]) & ",1) )")

						Local $iNbOfSpots
						If Int($acommand[2]) = Int($acommand[3]) Then
							$iNbOfSpots = Int($acommand[2])
						Else
							$iNbOfSpots = Random(Int($acommand[2]), Int($acommand[3]), 1)
						EndIf

						Local $iAtEachSpot
						If Int($acommand[4]) = Int($acommand[5]) Then
							$iAtEachSpot = Int($acommand[4])
						Else
							$iAtEachSpot = Random(Int($acommand[4]), Int($acommand[5]), 1)
						EndIf

						Local $Sleep
						If Int($acommand[6]) = Int($acommand[7]) Then
							$Sleep = Int($acommand[6])
						Else
							$Sleep = Random(Int($acommand[6]), Int($acommand[7]), 1)
						EndIf

						AttackTHGrid(Eval("e" & $command), $iNbOfSpots, $iAtEachSpot, $Sleep, 0)

					Case $command = "WAIT"
						If $g_bDebugSetlog Then SetDebugLog(">> GoldElixirChangeThSnipes(" & Int($acommand[7]) & ") ")

						If CheckOneStar(Int($acommand[7]) / 2000) Then ExitLoop ; Use seconds not ms , Half of time to check One start and the other halft for check the Resources
						If GoldElixirChangeThSnipes(Int($acommand[7]) / 2000) Then ExitLoop ; Correct the Function GoldElixirChangeThSnipes uses seconds not ms

					Case StringInStr(StringUpper("-King-Queen-Castle-"), "-" & $command & "-") > 0
						If $g_bDebugSetlog Then SetDebugLog(">> AttackTHGrid($e" & $command & ")")

						AttackTHGrid(Eval("e" & $command))

					Case StringInStr(StringUpper("-HSpell-RSpell-LSpell-JSpell-FSpell-PSpell-ESpell-HaSpell"), "-" & $command & "-") > 0
						If $g_bDebugSetlog Then SetDebugLog(">> SpellTHGrid($e" & $command & ")")

						SpellTHGrid(Eval("e" & $command))

					Case StringInStr(StringUpper("-LSpell-"), "-" & $command & "-") > 0
						If $g_bDebugSetlog Then SetDebugLog(">> CastSpell($e" & $command & ",$g_iTHx, $g_iTHy)")

						CastSpell(Eval("e" & $command), $g_iTHx, $g_iTHy)

					Case Else
						SetLog("attack row bad, discard: " & $line, $COLOR_ERROR)
				EndSelect
				If $acommand[8] <> "" And $command <> "TEXT" And $command <> "TROOP" Then
					If $g_bDebugSetlog Then SetDebugLog(">> SETLOG(""" & $acommand[8] & """)")
					SETLOG($acommand[8], $COLOR_INFO)
				EndIf
			Else
				If StringStripWS($acommand[1], 2) <> "" Then SetLog("attack row error, discard: " & $line, $COLOR_ERROR)
			EndIf
			If $g_bDebugSetlog Then SetDebugLog(">> CheckOneStar()")
			If CheckOneStar() Then ExitLoop
		WEnd
		FileClose($f)
	Else
		SetLog("Cannot found THSnipe attack file " & $g_sTHSnipeAttacksPath & "\" & $attackCSVtoUse & ".csv", $COLOR_ERROR)
	EndIf

EndFunc   ;==>AttackTHParseCSV

