; #FUNCTION# ====================================================================================================================
; Name ..........: TrainIt
; Description ...: validates and sends click in barrack window to actually train troops
; Syntax ........: TrainIt($troopKind[, $howMuch = 1[, $iSleep = 400]])
; Parameters ....: $troopKind           - name of troop to train
;                  $howMuch             - [optional] how many to train Default is 1.
;                  $iSleep              - [optional] delay value after click. Default is 400.
; Return values .: None
; Author ........:
; Modified ......: KnowJack(July 2015), MonkeyHunter (05-2016), ProMac (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: GetTrainPos, GetFullName, GetGemName
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func TrainIt($troopKind, $howMuch = 1, $iSleep = 400)
	If $debugsetlogTrain = 1 Then SetLog("Func TrainIt " & $troopKind & " " & $howMuch & " " & $iSleep, $COLOR_DEBUG)
	Local $bDark = False

	Local $pos = GetTrainPos($troopKind)

	If IsArray($pos) And $pos[0] <> -1 Then
		If _ColorCheck(_GetPixelColor($pos[0], $pos[1], $bCapturePixel), Hex($pos[2], 6), $pos[3]) = True Then
			Local $GemName = GetGemName($troopKind)
			If IsArray($GemName) Then
				Local $FullName = GetFullName($troopKind)
				If IsArray($FullName) Then
					Local $RNDName = GetRNDName($troopKind)
					If IsArray($RNDName) Then
						TrainClickP($pos, $howMuch, $isldTrainITDelay, $FullName, $GemName, "#0266", $RNDName)
						If _Sleep($iSleep) Then Return False
						If $OutOfElixir = 1 Then
							For $i = 0 To UBound($TroopName) - 1
								If Eval("e" & $TroopName[$i]) = $troopKind Then
									$bDark = True
									Setlog("Not enough Dark Elixir to train position " & $troopKind & " troops!", $COLOR_ERROR)
									ExitLoop
								EndIf
							Next
							If Not $bDark Then Setlog("Not enough Elixir to train position " & $troopKind & " troops!", $COLOR_ERROR)
							Setlog("Switching to Halt Attack, Stay Online Mode...", $COLOR_ERROR)
							$ichkBotStop = 1 ; set halt attack variable
							$icmbBotCond = 18 ; set stay online
							If Not ($fullarmy = True) Then $Restart = True ;If the army camp is full, If yes then use it to refill storages
							Return ; We are out of Elixir stop training.
						EndIf
						Return True
					Else
						Setlog("TrainIt position " & $troopKind & " - RNDName did not return array?", $COLOR_ERROR)
					EndIf
				Else
					Setlog("TrainIt " & NameOfTroop($troopKind) & " - FullName did not return array?", $COLOR_ERROR)
				EndIf
			Else
				Setlog("TrainIt " & NameOfTroop($troopKind) & " - GemName did not return array?", $COLOR_ERROR)
			EndIf
		Else
			Local $badPixelColor = _GetPixelColor($pos[0], $pos[1], $bCapturePixel)
			If $debugsetlogTrain Then Setlog ( "Positon X: " & $pos[0] & "| Y : " & $pos[1] & " |Color get: " & $badPixelColor & " | Need: " & $pos[2])
			If StringMid($badPixelColor, 1, 2) = StringMid($badPixelColor, 3, 2) And StringMid($badPixelColor, 1, 2) = StringMid($badPixelColor, 5, 2) Then
				; Pixel is gray, so queue is full -> nothing to inform the user about
				Setlog("Troop " & NameOfTroop($troopKind) & " is not available due to full queue", $COLOR_DEBUG)
			Else
				Setlog("Bad pixel check on troop position " & NameOfTroop($troopKind), $COLOR_ERROR)
				If $debugsetlogTrain = 1 Then Setlog("Train Pixel Color: " & $badPixelColor, $COLOR_DEBUG)
			EndIf
		EndIf
	Else
		Setlog("Impossible happened? TrainIt troop position " & NameOfTroop($troopKind) & " did not return array", $COLOR_ERROR)
	EndIf
EndFunc   ;==>TrainIt

;
; Support functions to TrainIt that take troop name and generate the proper variable name
;


; This a IMPORTANT function , on first Train loop will update the $Train'troops' Global variables
; Assigning the correct positions slot x and y on Train window , checking if available to train or not present

Func GetTrainPos($troopKind)
	If $debugsetlogTrain = 1 Then SetLog("Func GetTrainPos " & $troopKind, $COLOR_DEBUG)
	Local $TemVar, $directory, $Filter, $ImageToUse, $IsTroop, $IsSpell

	; Get the Image path to search
	For $i = 0 To UBound($TroopName) - 1
		If Eval("e" & $TroopName[$i]) = $troopKind Then
			$TemVar = Eval("Train" & $TroopName[$i])
			If $TemVar[0] = -1 Then
				$directory = @ScriptDir & "\imgxml\Train\Train_Train\"
				$Filter = String($TroopName[$i]) & "*"
				$ImageToUse = _FileListToArray($directory, $Filter, $FLTA_FILES, True)
				If $debugsetlogTrain Then setlog("$ImageToUse Troops: " & $ImageToUse[1])
				$IsTroop = GetVariable($ImageToUse[1], $troopKind)
				Assign("Train" & $TroopName[$i], $IsTroop)
				Return $IsTroop
			Else
				Return $TemVar
			EndIf
		EndIf
	Next

	For $i = 0 To UBound($SpellName) - 1
		If Eval("e" & $SpellName[$i]) = $troopKind Then
			$TemVar = Eval("Train" & $SpellName[$i])
			If $TemVar[0] = -1 Then
				$directory = @ScriptDir & "\imgxml\Train\Spell_Train\"
				$Filter = String($SpellName[$i]) & "*"
				$ImageToUse = _FileListToArray($directory, $Filter, $FLTA_FILES, True)
				If $debugsetlogTrain Then setlog("$ImageToUse Spell: " & $ImageToUse[1])
				$IsSpell = GetVariable($ImageToUse[1], $troopKind)
				Assign("Train" & $SpellName[$i], $IsSpell)
				Return $IsSpell
			Else
				Return $TemVar
			EndIf
		EndIf
	Next

	Return 0
EndFunc   ;==>GetTrainPos

; This a IMPORTANT function , on first Train loop will update the $Full'troops' Global variables
; Assigning the correct positions slot of if [i] symbol on Train window , checking if is blue ( available to train) or gray (disable to train)
Func GetFullName($troopKind)
	If $debugsetlogTrain = 1 Then SetLog("Func GetFullName " & $troopKind, $COLOR_DEBUG)

	Local $slotTemp[4] = [-1, -1, -1, -1]
	Local $text = "Normal"

	For $i = 0 To UBound($TroopName) - 1
		If Eval("e" & $TroopName[$i]) = $troopKind Then
			Local $Vartemp = Eval("Full" & $TroopName[$i])
			If $Vartemp[0] = -1 Then
				If IsDarkTroop($TroopName[$i]) Then $text = "Dark"
				If $debugsetlogTrain = 1 Then Setlog("Troop Name: "& NameOfTroop(Eval("e" & $TroopName[$i])))
				Local $slotTemp = GetFullNameSlot(Eval("Train" & $TroopName[$i]), $text)
				Assign("Full" & $TroopName[$i], $slotTemp)
				Return $slotTemp
			Else
				Return Eval("Full" & $TroopName[$i])
			EndIf
		EndIf
	Next

	For $i = 0 To UBound($SpellName) - 1
		If Eval("e" & $SpellName[$i]) = $troopKind Then
			Local $Vartemp = Eval("Full" & $SpellName[$i])
			If $Vartemp[0] = -1 Then
				Local $slotTemp = GetFullNameSlot(Eval("Train" & $SpellName[$i]), "Spell")
				Assign("Full" & $SpellName[$i], $slotTemp)
				Return $slotTemp
			Else
				Return Eval("Full" & $SpellName[$i])
			EndIf
		EndIf
	Next
	SetLog("Don't know how to find the troop " & NameOfTroop($troopKind) & " yet")
	Return $slotTemp
EndFunc   ;==>GetFullName


Func GetGemName($troopKind)
	If $debugsetlogTrain = 1 Then SetLog("Func GetGemName " & $troopKind, $COLOR_DEBUG)
	For $i = 0 To UBound($TroopName) - 1
		If Eval("e" & $TroopName[$i]) = $troopKind Then
			Return Eval("Gem" & $TroopName[$i])
		EndIf
	Next
	For $i = 0 To UBound($SpellName) - 1
		If Eval("e" & $SpellName[$i]) = $troopKind Then
			Return Eval("Gem" & $SpellName[$i])
		EndIf
	Next
	SetLog("Don't know how to find the troop " & NameOfTroop($troopKind) & " yet")
	Return 0
EndFunc   ;==>GetGemName

Func GetRNDName($troopKind)
	If $debugsetlogTrain = 1 Then SetLog("Func GetRNDName " & $troopKind, $COLOR_DEBUG)
	For $i = 0 To UBound($TroopName) - 1
		If Eval("e" & $TroopName[$i]) = $troopKind Then
			Return Eval("Train" & $TroopName[$i] & "RND")
		EndIf
	Next
	For $i = 0 To UBound($SpellName) - 1
		If Eval("e" & $SpellName[$i]) = $troopKind Then
			Return Eval("Train" & $SpellName[$i] & "RND")
		EndIf
	Next
	SetLog("Don't know how to find the troop " & $troopKind & " yet")
	Return 0
EndFunc   ;==>GetRNDName


; Function to use on GetTrainPos() , proceeds with imgloc on train window
Func GetVariable($ImageToUse, $troopKind)

	Local $FinalVariable[4] = [-1, -1, -1, -1]
	; Capture the screen for comparison
	_CaptureRegion2(25, 375, 840, 548)

	Local $res = DllCall($hImgLib, "str", "FindTile", "handle", $hHBitmap2, "str", $ImageToUse, "str", "FV", "int", 1)

	If @error Then _logErrorDLLCall($pImgLib, @error)
	If IsArray($res) Then
		If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_ERROR)
		If $res[0] = "0" Then
			; failed to find a train icon on the field
			SetLog("No " & NameOfTroop($troopKind) & " Icon found!", $COLOR_ERROR)
		ElseIf $res[0] = "-1" Then
			SetLog("DLL Error", $COLOR_ERROR)
		ElseIf $res[0] = "-2" Then
			SetLog("Invalid Resolution", $COLOR_ERROR)
		Else
			If $debugsetlogTrain Then Setlog("String: " & $res[0])
			Local $expRet = StringSplit($res[0], "|", $STR_NOCOUNT)
			Local $posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
			Local $ButtonX = 25 + Int($posPoint[0])
			Local $ButtonY = 375 + Int($posPoint[1])
			Local $Colorcheck = "0x" & _GetPixelColor($ButtonX, $ButtonY, $bCapturePixel)
			Local $Tolerance = 40
			Local $FinalVariable[4] = [$ButtonX, $ButtonY, $Colorcheck, $Tolerance]
			SetLog(" - " & NameOfTroop($troopKind) & " Icon found!", $COLOR_SUCCESS)
			If $debugsetlogTrain Then SetLog("Found: [" & $ButtonX & "," & $ButtonY & "]", $COLOR_SUCCESS)
			If $debugsetlogTrain Then SetLog("Color check: " & $Colorcheck, $COLOR_SUCCESS)
			If $debugsetlogTrain Then SetLog("$Tolerance: " & $Tolerance, $COLOR_SUCCESS)
			Return $FinalVariable
		EndIf
	Else
		SetLog("Don't know how to train the troop " & NameOfTroop($troopKind) & " yet")
	EndIf
	Return $FinalVariable
EndFunc   ;==>GetVariable


; Function to use on GetFullName() , returns slot and correct [i] symbols position on train window
Func GetFullNameSlot($TrainPos, $Name)

	Local $SlotH, $SlotV
	If $debugsetlogTrain Then Setlog("$TrainPos[0]: " & $TrainPos[0])
	If $debugsetlogTrain Then Setlog("$TrainPos[1]: " & $TrainPos[1])
	If $debugsetlogTrain Then Setlog("$Name" & $Name)

	If $Name = "Spell" Then
		If UBound($TrainPos) < 2 Then Setlog("Issue on $TrainPos!!!")
		Switch $TrainPos[0]
			Case $TrainPos[0] < 101 ; 1 Column
				$SlotH = 101
			Case $TrainPos[0] > 105 And $TrainPos[0] < 199 ; 2 Column
				$SlotH = 199
			Case $TrainPos[0] > 203 And $TrainPos[0] < 297 ; 3 Column
				$SlotH = 297
			Case $TrainPos[0] > 302 And $TrainPos[0] < 395 ; 4 Column
				$SlotH = 395
			Case $TrainPos[0] > 400 And $TrainPos[0] < 498 ; 5 Column
				$SlotH = 498
			Case $TrainPos[0] > 498 And $TrainPos[0] < 597 ; 6 Column
				$SlotH = 597
			Case Else
				If _ColorCheck(_GetPixelColor($TrainPos[0], $TrainPos[1], True), Hex(0xd3d3cb, 6), 5) Then
					Setlog(" »» This slot is empty!! | Spells", $COLOR_ERROR)
				EndIf
		EndSwitch
		Switch  $TrainPos[1]
			Case $TrainPos[1] < 445
				$SlotV = 387 ; First ROW
			Case $TrainPos[1] > 445 And $TrainPos[1] < 550 ; Second ROW
				$SlotV = 488
		EndSwitch
		Local $ToReturn[4] = [$SlotH, $SlotV, 0x9d9d9d, 35] ; Gray [i] icon
		If $debugsetlogTrain Then SetLog(" » GetFullNameSlot Spell Icon found!", $COLOR_SUCCESS)
		If $debugsetlogTrain Then SetLog("Full Train Found: [" & $SlotH & "," & $SlotV & "]", $COLOR_SUCCESS)
		Return $ToReturn
	EndIf

	If $Name = "Normal" Then
		If UBound($TrainPos) < 2 Then Setlog("Issue on $TrainPos!!!")
		Switch $TrainPos[0]
			Case $TrainPos[0] < 101 ; 1 Column
				$SlotH = 101
			Case $TrainPos[0] > 105 And $TrainPos[0] < 199 ; 2 Column
				$SlotH = 199
			Case $TrainPos[0] > 199 And $TrainPos[0] < 297 ; 3 Column
				$SlotH = 297
			Case $TrainPos[0] > 297 And $TrainPos[0] < 395 ; 4 Column
				$SlotH = 395
			Case $TrainPos[0] > 395 And $TrainPos[0] < 494 ; 5 Column
				$SlotH = 494
			Case $TrainPos[0] > 494 And $TrainPos[0] < 592 ; 6 Column
				$SlotH = 592
			Case $TrainPos[0] > 592 And $TrainPos[0] < 690 ; 7 Column
				$SlotH = 690
			Case Else
				If _ColorCheck(_GetPixelColor($TrainPos[0], $TrainPos[1], True), Hex(0xd3d3cb, 6), 5) Then
					Setlog(" »» This slot is empty!! | Normal Troop", $COLOR_ERROR)
				EndIf
		EndSwitch
		Switch  $TrainPos[1]
			Case $TrainPos[1] < 445
				$SlotV = 387 ; First ROW
			Case $TrainPos[1] > 445 And $TrainPos[1] < 550 ; Second ROW
				$SlotV = 488
		EndSwitch
		Local $ToReturn[4] = [$SlotH, $SlotV, 0x9f9f9f, 35] ; Gray [i] icon
		If $debugsetlogTrain Then SetLog(" » GetFullNameSlot Normal Icon found!", $COLOR_SUCCESS)
		If $debugsetlogTrain Then SetLog("Full Train Found: [" & $SlotH & "," & $SlotV & "]", $COLOR_SUCCESS)
		Return $ToReturn
	EndIf

	If $Name = "Dark" Then
		If UBound($TrainPos) < 2 Then Setlog("Issue on $TrainPos!!!")
		Switch $TrainPos[0]
			Case $TrainPos[0] > 440 And $TrainPos[0] < 517
				$SlotH = 517
			Case $TrainPos[0] > 517 And $TrainPos[0] < 615
				$SlotH = 615
			Case $TrainPos[0] > 615 And $TrainPos[0] < 714
				$SlotH = 714
			Case $TrainPos[0] > 714 And $TrainPos[0] < 812
				$SlotH = 812
			Case Else
				If _ColorCheck(_GetPixelColor($TrainPos[0], $TrainPos[1], True), Hex(0xd3d3cb, 6), 5) Then
					Setlog(" »» This slot is empty!! | Dark Troop", $COLOR_ERROR)
				EndIf
		EndSwitch
		Switch  $TrainPos[1]
			Case $TrainPos[1] < 445
				$SlotV = 397	; First ROW
			Case $TrainPos[1] > 445 And $TrainPos[1] < 550 ; Second ROW
				$SlotV = 498
		EndSwitch
		Local $ToReturn[4] = [$SlotH, $SlotV, 0x9f9f9f, 35] ; Gray [i] icon
		If $debugsetlogTrain Then SetLog(" » GetFullNameSlot Dark Icon found!", $COLOR_SUCCESS)
		If $debugsetlogTrain Then SetLog("Full Train Found: [" & $SlotH & "," & $SlotV & "]", $COLOR_SUCCESS)
		Return $ToReturn
	EndIf

EndFunc   ;==>GetFullNameSlot
