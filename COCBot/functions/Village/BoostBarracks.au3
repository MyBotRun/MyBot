
; #FUNCTION# ====================================================================================================================
; Name ..........: BoostBarracks.au3
; Description ...:
; Syntax ........: BoostBarracks() , BoostSpellFactory (), BoostDarkSpellFactory()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #11
; Modified ......: ProMac ( 2015-16 ), Sardo 2015-08 , ProMac (02-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BoostBarracks()

	;Local Variables to use with this routine
	Local $ButtonX, $ButtonY
	Local $hTimer = TimerInit()
	Local $res
	Local $ImagesToUse[2] ; Boost All
	$ImagesToUse[0] = @ScriptDir & "\images\Button\BoostAllBarracks.png"
	$ImagesToUse[1] = @ScriptDir & "\images\Button\BarrackBoosted.png"
	Local $ImagesToUse1[2] ; Boost one
	$ImagesToUse1[0] = @ScriptDir & "\images\Button\BoostBarrack.png" ; This image is use to Barracks and Spells Factories
	$ImagesToUse1[1] = @ScriptDir & "\images\Button\BarrackBoosted.png"

	$ToleranceImgLoc = 0.92 ; similarity 0.00 to 1

	;	Verifying existent Variables to run this routine
	If $bTrainEnabled = False Then Return
	If $icmbQuantBoostBarracks = 0 Or $icmbBoostBarracks = 0 Then Return

	If True Then
		Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		If $iPlannedBoostBarracksHours[$hour[0]] = 0 Then
			SetLog("Boost Barracks are not Planned, Skipped..", $COLOR_GREEN)
			Return ; exit func if no planned Boost Barracks checkmarks
		EndIf
	EndIf
	If $icmbQuantBoostBarracks > $numBarracksAvaiables Then
		SetLog(" Hey Chief! I can not Boost more than: " & $numBarracksAvaiables & " Barracks .... ")
		Return
	EndIf

	;	Start the Routine
	SetLog("Boost Barracks started, checking available Barracks.", $COLOR_BLUE)
	If _Sleep($iDelaycheckArmyCamp1) Then Return

	; 	Boost All barracks with "button Boost All" : Only run if all Barracks are available,
	;	if exist one Upgrading will run the Individual Boost Barracks
	If $icmbQuantBoostBarracks = $numBarracks Then
		; Confirm the Barrack 1 position.
		If $barrackPos[0][0] = "" Then
			LocateBarrack()
			SaveConfig()
			If _Sleep($iDelayBoostBarracks2) Then Return
		EndIf
		SetLog("Boosting All Barracks", $COLOR_BLUE)
		ClickP($aAway, 1, 0, "#0157")
		If _Sleep($iDelayBoostBarracks1) Then Return
		Click($barrackPos[0][0], $barrackPos[0][1], 1, 0, "#0158")
		If _Sleep($iDelayBoostBarracks1) Then Return

		; Capture Buttom Region to detect the Buttom to click
		_CaptureRegion2(125, 610, 740, 715)
		For $i = 0 To 1
			If FileExists($ImagesToUse[$i]) Then
				$res = DllCall($hImgLib, "str", "SearchTile", "handle", $hHBitmap2, "str", $ImagesToUse[$i], "float", $ToleranceImgLoc, "str", "FV", "int", 1)
				If @error Then _logErrorDLLCall($pImgLib, @error)
				If IsArray($res) Then
					If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
					If $res[0] = "0" Then
						If $i = 1 Then SetLog("No Button found")
					ElseIf $res[0] = "-1" Then
						SetLog("DLL Error", $COLOR_RED)
					ElseIf $res[0] = "-2" Then
						SetLog("Invalid Resolution", $COLOR_RED)
					Else
						If _Sleep($iDelayBoostBarracks5) Then Return
						If $i = 0 Then
							If $DebugSetlog Then SetLog("Found the Button to Boost All")
							$expRet = StringSplit(StringSplit($res[0], "|", 2)[1], ",", 2)
							$ButtonX = 125 + Int($expRet[0])
							$ButtonY = 610 + Int($expRet[1])
							If $DebugSetlog Then SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_GREEN)
							If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
							If _Sleep($iDelayBoostBarracks1) Then Return
							If _ColorCheck(_GetPixelColor(420, 375 + $midOffsetY, True), Hex(0xD0E978, 6), 20) Then
								Click(420, 375 + $midOffsetY, 1, 0, "#0160")
								If _Sleep($iDelayBoostBarracks2) Then Return
								If _ColorCheck(_GetPixelColor(586, 267 + $midOffsetY, True), Hex(0xd80405, 6), 20) Then
									$icmbBoostBarracks = 0
									SetLog("Not enough gems", $COLOR_RED)
									ClickP($aAway, 1, 0, "#0161")
									ExitLoop
								Else
									$icmbBoostBarracks -=1
									SetLog('Boost completed. Remaining :' & $icmbBoostBarracks, $COLOR_GREEN)
								EndIf
							EndIf
							If _Sleep($iDelayBoostBarracks3) Then Return
							ClickP($aAway, 1, 0, "#0161")
							ExitLoop
						Else
							SetLog("The Barrack is already boosted!")
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	Else
		;	Boost individual barracks with "button Boost 5 gems"
		If $barrackPos[$icmbQuantBoostBarracks - 1][0] = "" Or $barrackPos[$icmbQuantBoostBarracks - 1][0] = "-1" Then
			LocateBarrack2()
			SaveConfig()
			If _Sleep($iDelayBoostBarracks2) Then Return
		EndIf
		If $DebugSetlog = 1 Then SetLog("Boosting Barracks individually", $COLOR_BLUE)
		Local $BoostedBarrack = 0
		For $i = 0 To ($numBarracks - 1)
			SetLog("Boosting Barracks nº: " & $i + 1, $COLOR_BLUE)
			ClickP($aAway, 1, 0, "#0157")
			If _Sleep($iDelayBoostBarracks1) Then Return
			Click($barrackPos[$i][0], $barrackPos[$i][1], 1, 0, "#0158")

			If _Sleep($iDelayBoostBarracks1) Then Return

			_CaptureRegion2(125, 610, 740, 715)
			For $t = 0 To 1
				If FileExists($ImagesToUse1[$t]) Then
					$res = DllCall($hImgLib, "str", "SearchTile", "handle", $hHBitmap2, "str", $ImagesToUse1[$t], "float", $ToleranceImgLoc, "str", "FV", "int", 1)
					If @error Then _logErrorDLLCall($pImgLib, @error)
					If IsArray($res) Then
						If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
						If $res[0] = "0" Then
							ClickP($aAway, 1, 0, "#0161")
							If $t = 1 Then SetLog("Barrack nº: " & $i + 1 & " Boost Button not found.", $COLOR_RED)
						ElseIf $res[0] = "-1" Then
							SetLog("DLL Error", $COLOR_RED)
						ElseIf $res[0] = "-2" Then
							SetLog("Invalid Resolution", $COLOR_RED)
						Else
							If _Sleep($iDelayBoostBarracks5) Then Return
							If $t = 0 Then
								If $DebugSetlog = 1 Then SetLog("Found the Button to Boost individual")
								$expRet = StringSplit(StringSplit($res[0], "|", 2)[1], ",", 2)
								$ButtonX = 125 + Int($expRet[0])
								$ButtonY = 610 + Int($expRet[1])
								If $DebugSetlog = 1 Then SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_GREEN)
								If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
								If _Sleep($iDelayBoostBarracks1) Then Return
								If _ColorCheck(_GetPixelColor(420, 375 + $midOffsetY, True), Hex(0xD0E978, 6), 20) Then ;Confirm Message
									Click(420, 375 + $midOffsetY, 1, 0, "#0160")
									If _Sleep($iDelayBoostBarracks2) Then Return
									If _ColorCheck(_GetPixelColor(586, 267 + $midOffsetY, True), Hex(0xd80405, 6), 20) Then ;Not enough Gem
										$icmbBoostBarracks = 0
										SetLog("Not enough gems", $COLOR_RED)
										ExitLoop (2)
									EndIf
									If Not $BoostedBarrack = ($icmbQuantBoostBarracks - 1) Then
										$BoostedBarrack += 1
										SetLog("Boost " & $BoostedBarrack & " Barrack(s) completed. Remaining :" & ($icmbQuantBoostBarracks - $BoostedBarrack) & " Barracks to Boost.", $COLOR_GREEN)
										If $BoostedBarrack >= $icmbQuantBoostBarracks Then ExitLoop (2)
									Else
										$icmbBoostBarracks -= 1
										$BoostedBarrack += 1
										SetLog("Boost " & $BoostedBarrack & " Barrack(s) completed. Remaining :" & ($icmbQuantBoostBarracks - $BoostedBarrack) & " Barracks to Boost.", $COLOR_GREEN)
										SetLog("Remaining :" & $icmbBoostBarracks - 1 & " times ", $COLOR_GREEN)
										If $BoostedBarrack >= $icmbQuantBoostBarracks Then ExitLoop (2)
									EndIf
								Else
									SetLog("Barrack nº: " & $i + 1 & " the Confirm Message not open!", $COLOR_RED)
								EndIf
								If _Sleep($iDelayBoostBarracks3) Then Return
								ClickP($aAway, 1, 0, "#0161")
								ExitLoop
							Else
								SetLog("Barrack nº: " & $i + 1 & " is already Boosted.", $COLOR_RED)
								$BoostedBarrack += 1
								ClickP($aAway, 1, 0, "#0161")
								If $BoostedBarrack = $icmbQuantBoostBarracks Then ExitLoop (2)
							EndIf
						EndIf
					Else
						SetLog("Problem with Image Search/DllCall", $COLOR_RED)
						ClickP($aAway, 1, 0, "#0161")
						SetLog("Barrack nº: " & $i + 1 & " Boost Button not found.", $COLOR_RED)
					EndIf
				EndIf
			Next
		Next
	EndIf

	If _Sleep($iDelayBoostBarracks5) Then Return
	checkMainScreen(False) ; Check for errors during function
EndFunc   ;==>BoostBarracks


Func BoostSpellFactory()

	If $bTrainEnabled = False Then Return

	;Local Variables to use with this routine
	Local $ButtonX, $ButtonY
	Local $hTimer = TimerInit()
	Local $res
	Local $ImagesToUse1[2] ; Boost one
	$ImagesToUse1[0] = @ScriptDir & "\images\Button\BoostBarrack.png" ; This image is use to Barracks and Spells Factories
	$ImagesToUse1[1] = @ScriptDir & "\images\Button\BarrackBoosted.png"
	$ToleranceImgLoc = 0.90 ; similarity 0.00 to 1

	If $icmbBoostSpellFactory > 0 And ($boostsEnabled = 1) Then
		SetLog("Boost Spell Factory...", $COLOR_BLUE)

		; Confirm the Spell Factory Position
		If $SFPos[0] = -1 Then
			LocateSpellFactory()
			SaveConfig()
			If _Sleep($iDelayBoostSpellFactory2) Then Return
		EndIf

		Click($SFPos[0], $SFPos[1], 1, 0, "#0162")
		If _Sleep($iDelayBoostSpellFactory4) Then Return

		_CaptureRegion2(125, 610, 740, 715)
		For $i = 0 To 1
			If FileExists($ImagesToUse1[$i]) Then
				$res = DllCall($hImgLib, "str", "SearchTile", "handle", $hHBitmap2, "str", $ImagesToUse1[$i], "float", $ToleranceImgLoc, "str", "FV", "int", 1)
				If @error Then _logErrorDLLCall($pImgLib, @error)
				If IsArray($res) Then
					If $DebugSetlog Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
					If $res[0] = "0" Then
						If $i = 1 Then SetLog("No Button found")
					ElseIf $res[0] = "-1" Then
						SetLog("DLL Error", $COLOR_RED)
					ElseIf $res[0] = "-2" Then
						SetLog("Invalid Resolution", $COLOR_RED)
					Else
						If _Sleep($iDelayBoostBarracks5) Then Return
						If $i = 0 Then
							If $DebugSetlog = 1 Then SetLog("Found the Button to Boost Spell Factory")
							$expRet = StringSplit(StringSplit($res[0], "|", 2)[1], ",", 2)
							$ButtonX = 125 + Int($expRet[0])
							$ButtonY = 610 + Int($expRet[1])
							If $DebugSetlog Then SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_GREEN)
							If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
							If _Sleep($iDelayBoostSpellFactory1) Then Return
							If _ColorCheck(_GetPixelColor(420, 375 + $midOffsetY, True), Hex(0xD0E978, 6), 20) Then
								Click(420, 375 + $midOffsetY, 1, 0, "#0160")
								If _Sleep($iDelayBoostSpellFactory2) Then Return
								If _ColorCheck(_GetPixelColor(586, 267 + $midOffsetY, True), Hex(0xd80405, 6), 20) Then
									$icmbBoostSpellFactory = 0
									SetLog("Not enough gems", $COLOR_RED)
									ClickP($aAway, 1, 0, "#0161")
									ExitLoop
								Else
									$cmbBoostSpellFactory -= 1
									SetLog('Boost completed. Remaining :' & $icmbBoostSpellFactory, $COLOR_GREEN)
								EndIf
							EndIf
							If _Sleep($iDelayBoostSpellFactory3) Then Return
							ClickP($aAway, 1, 0, "#0161")
							ExitLoop
						Else
							SetLog("Spell Factory is already Boosted!")
							ClickP($aAway, 1, 0, "#0161")
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	EndIf

	If _Sleep($iDelayBoostBarracks5) Then Return
	checkMainScreen(False) ; Check for errors during function

EndFunc   ;==>BoostSpellFactory


Func BoostDarkSpellFactory()

	If $bTrainEnabled = False Then Return

	;Local Variables to use with this routine
	Local $ButtonX, $ButtonY
	Local $hTimer = TimerInit()
	Local $res
	Local $ImagesToUse1[2] ; Boost one
	$ImagesToUse1[0] = @ScriptDir & "\images\Button\BoostBarrack.png" ; This image is use to Barracks and Spells Factories
	$ImagesToUse1[1] = @ScriptDir & "\images\Button\BarrackBoosted.png"
	$ToleranceImgLoc = 0.90 ; similarity 0.00 to 1


	If $icmbBoostDarkSpellFactory > 0 And ($boostsEnabled = 1) Then
		SetLog("Boost Dark Spell Factory...", $COLOR_BLUE)

		If $DSFPos[0] = -1 Then
			LocateDarkSpellFactory()
			SaveConfig()
			If _Sleep($iDelayBoostSpellFactory2) Then Return
		EndIf

		Click($DSFPos[0], $DSFPos[1], 1, 0, "#0162")
		If _Sleep($iDelayBoostSpellFactory4) Then Return


		_CaptureRegion2(125, 610, 740, 715)
		For $i = 0 To 1
			If FileExists($ImagesToUse1[$i]) Then
				$res = DllCall($hImgLib, "str", "SearchTile", "handle", $hHBitmap2, "str", $ImagesToUse1[$i], "float", $ToleranceImgLoc, "str", "FV", "int", 1)
				If @error Then _logErrorDLLCall($pImgLib, @error)
				If IsArray($res) Then
					If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
					If $res[0] = "0" Then
						If $i = 1 Then SetLog("No Button found")
					ElseIf $res[0] = "-1" Then
						SetLog("DLL Error", $COLOR_RED)
					ElseIf $res[0] = "-2" Then
						SetLog("Invalid Resolution", $COLOR_RED)
					Else
						If _Sleep($iDelayBoostBarracks5) Then Return
						If $i = 0 Then
							If $DebugSetlog Then SetLog("Found the Button to Boost Dark Spell Factory")
							$expRet = StringSplit(StringSplit($res[0], "|", 2)[1], ",", 2)
							$ButtonX = 125 + Int($expRet[0])
							$ButtonY = 610 + Int($expRet[1])
							If $DebugSetlog Then SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_GREEN)
							If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
							If _Sleep($iDelayBoostSpellFactory1) Then Return
							If _ColorCheck(_GetPixelColor(420, 375 + $midOffsetY, True), Hex(0xD0E978, 6), 20) Then
								Click(420, 375 + $midOffsetY, 1, 0, "#0160")
								If _Sleep($iDelayBoostSpellFactory2) Then Return
								If _ColorCheck(_GetPixelColor(586, 267 + $midOffsetY, True), Hex(0xd80405, 6), 20) Then
									$icmbBoostSpellFactory = 0
									SetLog("Not enough gems", $COLOR_RED)
									ClickP($aAway, 1, 0, "#0161")
									ExitLoop
								Else
									$icmbBoostSpellFactory -= 1
									SetLog('Boost completed. Remaining :' & $icmbBoostSpellFactory, $COLOR_GREEN)
								EndIf
							EndIf
							If _Sleep($iDelayBoostSpellFactory3) Then Return
							ClickP($aAway, 1, 0, "#0161")
							ExitLoop
						Else
							SetLog("Dark Spell Factory is already Boosted!")
							ClickP($aAway, 1, 0, "#0161")
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	EndIf

	If _Sleep($iDelayBoostBarracks5) Then Return
	checkMainScreen(False) ; Check for errors during function

EndFunc   ;==>BoostDarkSpellFactory
