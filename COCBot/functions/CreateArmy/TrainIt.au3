; #FUNCTION# ====================================================================================================================
; Name ..........: TrainIt
; Description ...: validates and sends click in barrack window to actually train troops
; Syntax ........: TrainIt($troopKind[, $howMuch = 1[, $iSleep = 400]])
; Parameters ....: $troopKind           - name of troop to train
;                  $howMuch             - [optional] how many to train Default is 1.
;                  $iSleep              - [optional] delay value after click. Default is 400.
; Return values .: None
; Author ........:
; Modified ......: KnowJack(July 2015), MonkeyHunter (05-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: GetTrainPos, GetFullName, GetGemName
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func TrainIt($troopKind, $howMuch = 1, $iSleep = 400)
	If $debugsetlogTrain = 1 Then SetLog("Func TrainIt " & $troopKind & " " & $howMuch & " " & $iSleep, $COLOR_PURPLE)
	Local $bDark = False
	_CaptureRegion()
	Local $pos = GetTrainPos($troopKind)
	If IsArray($pos) Then
		If _CheckPixel($pos, $bNoCapturePixel) Then
			Local $GemName = GetGemName($troopKind)
			If IsArray($GemName) Then
				Local $FullName = GetFullName($troopKind)
				If IsArray($FullName) Then
					Local $RNDName = GetRNDName($troopKind)
					If IsArray($RNDName) Then
						TrainClickP($pos, $howMuch, $isldTrainITDelay, $FullName, $GemName, "#0266", $RNDName)
						If _Sleep($iSleep) Then Return False
						If $OutOfElixir = 1 Then
							For $i = 0 To UBound($TroopDarkName) - 1
								If Eval("e" & $TroopDarkName[$i]) = $troopKind Then
									$bDark = True
									Setlog("Not enough Dark Elixir to train position " & $troopKind & " troops!", $COLOR_RED)
									ExitLoop
								EndIf
							Next
							If Not $bDark Then Setlog("Not enough Elixir to train position " & $troopKind & " troops!", $COLOR_RED)
							Setlog("Switching to Halt Attack, Stay Online Mode...", $COLOR_RED)
							$ichkBotStop = 1 ; set halt attack variable
							$icmbBotCond = 18; set stay online
							If Not ($fullarmy = True) Then $Restart = True ;If the army camp is full, If yes then use it to refill storages
							Return ; We are out of Elixir stop training.
						EndIf
						Return True
					Else
						Setlog("TrainIt position " & $troopKind & " - RNDName did not return array?", $COLOR_RED)
					EndIf
				Else
					Setlog("TrainIt " & NameOfTroop($troopKind) & " - FullName did not return array?", $COLOR_RED)
				EndIf
			Else
				Setlog("TrainIt " & NameOfTroop($troopKind) & " - GemName did not return array?", $COLOR_RED)
			EndIf
		Else
			Local $badPixelColor = _GetPixelColor($pos[0], $pos[1], $bNoCapturePixel)
			If StringMid($badPixelColor, 1, 2) = StringMid($badPixelColor, 3, 2) And StringMid($badPixelColor, 1, 2) = StringMid($badPixelColor, 5, 2) Then
				; Pixel is gray, so queue is full -> nothing to inform the user about
				If $debugsetlogTrain = 1 Then Setlog("Troop " & NameOfTroop($troopKind) & " is not available due to full queue", $COLOR_PURPLE)
			Else
				Setlog("Bad pixel check on troop position " & NameOfTroop($troopKind), $COLOR_RED)
				If $debugsetlogTrain = 1 Then Setlog("Train Pixel Color: " & $badPixelColor, $COLOR_PURPLE)
			EndIf
		EndIf
	Else
		Setlog("Impossible happened? TrainIt troop position " & NameOfTroop($troopKind) & " did not return array", $COLOR_RED)
	EndIf
EndFunc   ;==>TrainIt

;
; Support functions to TrainIt that take troop name and generate the proper variable name
;

Func GetTrainPos($troopKind)
	If $debugsetlogTrain = 1 Then SetLog("Func GetTrainPos " & $troopKind, $COLOR_PURPLE)
	For $i = 0 To UBound($TroopName) - 1
		If Eval("e" & $TroopName[$i]) = $troopKind Then
			Return Eval("Train" & $TroopName[$i])
		EndIf
	Next
	For $i = 0 To UBound($TroopDarkName) - 1
		If Eval("e" & $TroopDarkName[$i]) = $troopKind Then
			Return Eval("Train" & $TroopDarkName[$i])
		EndIf
	Next
	SetLog("Don't know how to train the troop " & NameOfTroop($troopKind) & " yet")
	Return 0
EndFunc   ;==>GetTrainPos

Func GetFullName($troopKind)
	If $debugsetlogTrain = 1 Then SetLog("Func GetFullName " & $troopKind, $COLOR_PURPLE)
	For $i = 0 To UBound($TroopName) - 1
		If Eval("e" & $TroopName[$i]) = $troopKind Then
			Return Eval("Full" & $TroopName[$i])
		EndIf
	Next
	For $i = 0 To UBound($TroopDarkName) - 1
		If Eval("e" & $TroopDarkName[$i]) = $troopKind Then
			Return Eval("Full" & $TroopDarkName[$i])
		EndIf
	Next
	SetLog("Don't know how to find the troop " & NameOfTroop($troopKind) & " yet")
	Return 0
EndFunc   ;==>GetFullName

Func GetGemName($troopKind)
	If $debugsetlogTrain = 1 Then SetLog("Func GetGemName " & $troopKind, $COLOR_PURPLE)
	For $i = 0 To UBound($TroopName) - 1
		If Eval("e" & $TroopName[$i]) = $troopKind Then
			Return Eval("Gem" & $TroopName[$i])
		EndIf
	Next
	For $i = 0 To UBound($TroopDarkName) - 1
		If Eval("e" & $TroopDarkName[$i]) = $troopKind Then
			Return Eval("Gem" & $TroopDarkName[$i])
		EndIf
	Next
	SetLog("Don't know how to find the troop " & NameOfTroop($troopKind) & " yet")
	Return 0
EndFunc   ;==>GetGemName

Func GetRNDName($troopKind)
	If $debugsetlogTrain = 1 Then SetLog("Func GetRNDName " & $troopKind, $COLOR_PURPLE)
	For $i = 0 To UBound($TroopName) - 1
		If Eval("e" & $TroopName[$i]) = $troopKind Then
			Return Eval("Train" & $TroopName[$i] & "RND")
		EndIf
	Next
	For $i = 0 To UBound($TroopDarkName) - 1
		If Eval("e" & $TroopDarkName[$i]) = $troopKind Then
			Return Eval("Train" & $TroopDarkName[$i] & "RND")
		EndIf
	Next
	SetLog("Don't know how to find the troop " & $troopKind & " yet")
	Return 0
EndFunc   ;==>GetRNDName