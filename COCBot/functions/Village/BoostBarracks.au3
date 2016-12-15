
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
	$ImagesToUse[0] = @ScriptDir & "\imgxml\boostbarracks\BoostAllBarracks_0_92.xml"
	$ImagesToUse[1] = @ScriptDir & "\imgxml\boostbarracks\BarrackBoosted_0_92.xml"
	Local $ImagesToUse1[2] ; Boost one
	$ImagesToUse1[0] = @ScriptDir & "\imgxml\boostbarracks\BoostBarrack_0_92.xml" ; This image is use to Barracks and Spells Factories
	$ImagesToUse1[1] = @ScriptDir & "\imgxml\boostbarracks\BarrackBoosted_0_92.xml"

	;$ToleranceImgLoc = 0.92 ; similarity 0.00 to 1 - not needed with findtile where tolerance is in filename

	;	Verifying existent Variables to run this routine
	If $bTrainEnabled = False Then Return
	If $icmbQuantBoostBarracks = 0 Or $icmbBoostBarracks = 0 Then Return

	If True Then
		Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		If $iPlannedBoostBarracksHours[$hour[0]] = 0 Then
			SetLog("Boost Barracks are not Planned, Skipped..", $COLOR_SUCCESS)
			Return ; exit func if no planned Boost Barracks checkmarks
		EndIf
	EndIf
	If $icmbQuantBoostBarracks > $numBarracksAvaiables Then
		SetLog(" Hey Chief! I can not Boost more than: " & $numBarracksAvaiables & " Barracks .... ")
		Return
	EndIf

	;	Start the Routine
	SetLog("Boost Barracks started, checking available Barracks.", $COLOR_INFO)
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
		SetLog("Boosting All Barracks", $COLOR_INFO)
		ClickP($aAway, 1, 0, "#0157")
		If _Sleep($iDelayBoostBarracks1) Then Return
		Click($barrackPos[0][0], $barrackPos[0][1], 1, 0, "#0158")
		If _Sleep($iDelayBoostBarracks1) Then Return

		; Capture Buttom Region to detect the Buttom to click
		_CaptureRegion2(125, 610, 740, 715)
		For $i = 0 To 1
			If FileExists($ImagesToUse[$i]) Then
				$res = DllCall($hImgLib, "str", "FindTile", "handle", $hHBitmap2, "str", $ImagesToUse[$i],  "str", "FV", "int", 1)
				If @error Then _logErrorDLLCall($pImgLib, @error)
				If IsArray($res) Then
					If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_ERROR)
					If $res[0] = "0" Then
						If $i = 1 Then SetLog("No Button found")
					ElseIf $res[0] = "-1" Then
						SetLog("DLL Error", $COLOR_ERROR)
					ElseIf $res[0] = "-2" Then
						SetLog("Invalid Resolution", $COLOR_ERROR)
					Else
						If _Sleep($iDelayBoostBarracks5) Then Return
						If $i = 0 Then
							If $DebugSetlog Then SetLog("Found the Button to Boost All")
							$expRet = StringSplit(StringSplit($res[0], "|", 2)[1], ",", 2)
							$ButtonX = 125 + Int($expRet[0])
							$ButtonY = 610 + Int($expRet[1])
							If $DebugSetlog Then SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_SUCCESS)
							If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
							If _Sleep($iDelayBoostBarracks1) Then Return
							If _ColorCheck(_GetPixelColor(420, 375 + $midOffsetY, True), Hex(0xD0E978, 6), 20) Then
								Click(420, 375 + $midOffsetY, 1, 0, "#0160")
								If _Sleep($iDelayBoostBarracks2) Then Return
								If _ColorCheck(_GetPixelColor(586, 267 + $midOffsetY, True), Hex(0xd80405, 6), 20) Then
									$icmbBoostBarracks = 0
									SetLog("Not enough gems", $COLOR_ERROR)
									ClickP($aAway, 1, 0, "#0161")
									ExitLoop
								Else
									$icmbBoostBarracks -=1
									SetLog('Boost completed. Remaining :' & $icmbBoostBarracks, $COLOR_SUCCESS)
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
		If $DebugSetlog = 1 Then SetLog("Boosting Barracks individually", $COLOR_INFO)
		Local $BoostedBarrack = 0
		For $i = 0 To ($numBarracks - 1)
			SetLog("Boosting Barracks nº: " & $i + 1, $COLOR_INFO)
			ClickP($aAway, 1, 0, "#0157")
			If _Sleep($iDelayBoostBarracks1) Then Return
			Click($barrackPos[$i][0], $barrackPos[$i][1], 1, 0, "#0158")

			If _Sleep($iDelayBoostBarracks1) Then Return

			_CaptureRegion2(125, 610, 740, 715)
			For $t = 0 To 1
				If FileExists($ImagesToUse1[$t]) Then
					$res = DllCall($hImgLib, "str", "FindTile", "handle", $hHBitmap2, "str", $ImagesToUse1[$t],  "str", "FV", "int", 1)
					If @error Then _logErrorDLLCall($pImgLib, @error)
					If IsArray($res) Then
						If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_ERROR)
						If $res[0] = "0" Then
							ClickP($aAway, 1, 0, "#0161")
							If $t = 1 Then SetLog("Barrack nº: " & $i + 1 & " Boost Button not found.", $COLOR_ERROR)
						ElseIf $res[0] = "-1" Then
							SetLog("DLL Error", $COLOR_ERROR)
						ElseIf $res[0] = "-2" Then
							SetLog("Invalid Resolution", $COLOR_ERROR)
						Else
							If _Sleep($iDelayBoostBarracks5) Then Return
							If $t = 0 Then
								If $DebugSetlog = 1 Then SetLog("Found the Button to Boost individual")
								$expRet = StringSplit(StringSplit($res[0], "|", 2)[1], ",", 2)
								$ButtonX = 125 + Int($expRet[0])
								$ButtonY = 610 + Int($expRet[1])
								If $DebugSetlog = 1 Then SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_SUCCESS)
								If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
								If _Sleep($iDelayBoostBarracks1) Then Return
								If _ColorCheck(_GetPixelColor(420, 375 + $midOffsetY, True), Hex(0xD0E978, 6), 20) Then ;Confirm Message
									Click(420, 375 + $midOffsetY, 1, 0, "#0160")
									If _Sleep($iDelayBoostBarracks2) Then Return
									If _ColorCheck(_GetPixelColor(586, 267 + $midOffsetY, True), Hex(0xd80405, 6), 20) Then ;Not enough Gem
										$icmbBoostBarracks = 0
										SetLog("Not enough gems", $COLOR_ERROR)
										ExitLoop (2)
									EndIf
									If Not $BoostedBarrack = ($icmbQuantBoostBarracks - 1) Then
										$BoostedBarrack += 1
										SetLog("Boost " & $BoostedBarrack & " Barrack(s) completed. Remaining :" & ($icmbQuantBoostBarracks - $BoostedBarrack) & " Barracks to Boost.", $COLOR_SUCCESS)
										If $BoostedBarrack >= $icmbQuantBoostBarracks Then ExitLoop (2)
									Else
										$icmbBoostBarracks -= 1
										$BoostedBarrack += 1
										SetLog("Boost " & $BoostedBarrack & " Barrack(s) completed. Remaining :" & ($icmbQuantBoostBarracks - $BoostedBarrack) & " Barracks to Boost.", $COLOR_SUCCESS)
										SetLog("Remaining :" & $icmbBoostBarracks - 1 & " times ", $COLOR_SUCCESS)
										If $BoostedBarrack >= $icmbQuantBoostBarracks Then ExitLoop (2)
									EndIf
								Else
									SetLog("Barrack nº: " & $i + 1 & " the Confirm Message not open!", $COLOR_ERROR)
								EndIf
								If _Sleep($iDelayBoostBarracks3) Then Return
								ClickP($aAway, 1, 0, "#0161")
								ExitLoop
							Else
								SetLog("Barrack nº: " & $i + 1 & " is already Boosted.", $COLOR_ERROR)
								$BoostedBarrack += 1
								ClickP($aAway, 1, 0, "#0161")
								If $BoostedBarrack = $icmbQuantBoostBarracks Then ExitLoop (2)
							EndIf
						EndIf
					Else
						SetLog("Problem with Image Search/DllCall", $COLOR_ERROR)
						ClickP($aAway, 1, 0, "#0161")
						SetLog("Barrack nº: " & $i + 1 & " Boost Button not found.", $COLOR_ERROR)
					EndIf
				EndIf
			Next
		Next
	EndIf

	If _Sleep($iDelayBoostBarracks5) Then Return
	checkMainScreen(False) ; Check for errors during function
EndFunc   ;==>BoostBarracks

Func BoostBarracks2()

	Local $aPos[2] = [$barrackPos[0][0], $barrackPos[0][1]]

	; Verifying existent Variables to run this routine
	If AllowBoosting("Barracks", $icmbBoostBarracks) = False Then Return

	; Confirm the Barrack 1 position.
	SetLog("Boost Barracks...", $COLOR_INFO)
	If $aPos[0] = "" Or $aPos[0] = -1 Then
		LocateOneBarrack()
		SaveConfig()
		If _Sleep($iDelayBoostBarracks2) Then Return
		Local $aPos[2] = [$barrackPos[0][0], $barrackPos[0][1]]
	EndIf

	BoostStructure("Barracks", "Barracks", $aPos, $icmbBoostBarracks, $cmbBoostBarracks)

	If _Sleep($iDelayBoostBarracks5) Then Return
	checkMainScreen(False) ; Check for errors during function

EndFunc   ;==>BoostBarracks2

Func BoostSpellFactory()

	Local $aPos = $SFPos

	; Verifying existent Variables to run this routine
	If AllowBoosting("Spell Factory", $icmbBoostSpellFactory) = False Then Return

	; Confirm the position.
	SetLog("Boost Spell Factory...", $COLOR_INFO)
	If $aPos[0] = "" Or $aPos[0] = -1 Then
		LocateSpellFactory()
		SaveConfig()
		If _Sleep($iDelayBoostHeroes4) Then Return
		$aPos = $SFPos
	EndIf

	BoostStructure("Spell Factory", "Spell", $aPos, $icmbBoostSpellFactory, $cmbBoostSpellFactory)

	If _Sleep($iDelayBoostBarracks5) Then Return
	checkMainScreen(False) ; Check for errors during function

EndFunc   ;==>BoostSpellFactory


Func BoostDarkSpellFactory()

	Local $aPos = $DSFPos

	; Verifying existent Variables to run this routine
	If AllowBoosting("Dark Spell Factory", $icmbBoostDarkSpellFactory) = False Then Return

	; Confirm the position.
	SetLog("Boost Dark Spell Factory...", $COLOR_INFO)
	If $aPos[0] = "" Or $aPos[0] = -1 Then
		LocateDarkSpellFactory()
		SaveConfig()
		If _Sleep($iDelayBoostHeroes4) Then Return
		$aPos = $DSFPos
	EndIf

	BoostStructure("Dark Spell Factory", "Spell", $aPos, $icmbBoostDarkSpellFactory, $cmbBoostDarkSpellFactory)

	If _Sleep($iDelayBoostBarracks5) Then Return
	checkMainScreen(False) ; Check for errors during function

EndFunc   ;==>BoostDarkSpellFactory
