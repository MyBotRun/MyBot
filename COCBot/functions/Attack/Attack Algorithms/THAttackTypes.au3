; #FUNCTION# ==========================================================
; Name ..........: THAttackTypes
; Description ...: This file contens the TH attacks
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: AtoZ (2015)
; Modified ......: Barracoda (July 2015), TheMaster 2015-10
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ================================================================

Func SwitchAttackTHType()
	$THusedKing = 0
	$THusedQueen = 0
	AttackTHParseCSV()
EndFunc   ;==>SwitchAttackTHType

Func AttackTHParseCSV($test = False)
	If $debugsetlog = 1 Then Setlog("AttackTHParseCSV start", $COLOR_PURPLE)
	Local $f, $line, $acommand, $command

	Local $attackCSVtoUse = ""
	Switch $iMatchMode
		Case $TS
			$attackCSVtoUse = $scmbAttackTHType
		Case $LB
			$attackCSVtoUse = $THSnipeBeforeLBScript
		Case $DB
			If $duringMilkingAttack = 1 Then
				$attackCSVtoUse = $MilkFarmAlgorithmTh
			Else
				$attackCSVtoUse = $THSnipeBeforeDBScript
			EndIf
	EndSwitch



	If FileExists($dirTHSnipesAttacks & "\" & $attackCSVtoUse & ".csv") Then
		$f = FileOpen($dirTHSnipesAttacks & "\" & $attackCSVtoUse & ".csv", 0)
		If $debugsetlog=1 Then Setlog("Use algorithm " & $attackCSVtoUse &".csv",$COLOR_PURPLE)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			;Setlog("line content: " & $line)
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), 2)
				;   $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell
				Select
					Case $command = "TROOP" Or $command = ""
						;Setlog("<<<<discard line>>>>")
					Case $command = "TEXT"
						If $debugsetlog = 1 Then Setlog(">> SETLOG(""" & $acommand[8] & """)")

						SetLog($acommand[8], $COLOR_BLUE)

					Case StringInStr(StringUpper("-Barb-Arch-Giant-Gobl-Wall-Ball-Wiza-Heal-Drag-Pekk-BabyD-Mine-Mini-Hogs-Valk-Gole-Witc-Lava-Bowl"), "-" & $command & "-") > 0
						If $debugsetlog = 1 Then Setlog(">> AttackTHGrid($e" & $command & ", Random (" & Int($acommand[2]) & "," & Int($acommand[3]) & ",1), Random(" & Int($acommand[4]) & "," & Int($acommand[5]) & ",1), Random(" & Int($acommand[6]) & "," & Int($acommand[7]) & ",1) )")

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
						If $debugsetlog = 1 Then Setlog(">> GoldElixirChangeThSnipes(" & Int($acommand[7]) & ") ")

						If CheckOneStar(Int($acommand[7]) / 2000) Then ExitLoop ; Use seconds not ms , Half of time to check One start and the other halft for check the Resources
						If GoldElixirChangeThSnipes(Int($acommand[7]) / 2000) Then ExitLoop ; Correct the Function GoldElixirChangeThSnipes uses seconds not ms

					Case StringInStr(StringUpper("-King-Queen-Castle-"), "-" & $command & "-") > 0
						If $debugsetlog = 1 Then Setlog(">> AttackTHGrid($e" & $command & ")")

						AttackTHGrid(Eval("e" & $command))

					Case StringInStr(StringUpper("-HSpell-RSpell-LSpell-JSpell-FSpell-PSpell-ESpell-HaSpell"), "-" & $command & "-") > 0
						If $debugsetlog = 1 Then Setlog(">> SpellTHGrid($e" & $command & ")")

						SpellTHGrid(Eval("e" & $command))

					Case StringInStr(StringUpper("-LSpell-"), "-" & $command & "-") > 0
						If $debugsetlog = 1 Then Setlog(">> CastSpell($e" & $command & ",$THx, $THy)")

						CastSpell(Eval("e" & $command), $THx, $THy)

					Case Else
						Setlog("attack row bad, discard: " & $line, $COLOR_RED)
				EndSelect
				If $acommand[8] <> "" And $command <> "TEXT" And $command <> "TROOP" Then
					If $debugsetlog = 1 Then Setlog(">> SETLOG(""" & $acommand[8] & """)")
					SETLOG($acommand[8], $COLOR_BLUE)
				EndIf
			Else
				If StringStripWS($acommand[1], 2) <> "" Then Setlog("attack row error, discard: " & $line, $COLOR_RED)
			EndIf
			If $debugsetlog = 1 Then Setlog(">> CheckOneStar()")
			If CheckOneStar() Then ExitLoop
		WEnd
		FileClose($f)
	Else
		SetLog("Cannot found THSnipe attack file " & $dirTHSnipesAttacks & "\" & $attackCSVtoUse & ".csv", $color_red)
	EndIf

EndFunc   ;==>AttackTHParseCSV

