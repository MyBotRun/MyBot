
; #FUNCTION# ====================================================================================================================
; Name ..........: CheckOverviewFullArmy
; Description ...: Checks if the army is full on the training overview screen
; Syntax ........: CheckOverviewFullArmy([$bOpenArmyWindow = False])
; Parameters ....: $bOpenArmyWindow  = Bool value true if train overview window needs to be opened
;				 : $bCloseArmyWindow = Bool value, true if train overview window needs to be closed
; Return values .: None
; Author ........: KnowJack (July 2015)
; Modified ......: MonkeyHunter (2016-3)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckOverviewFullArmy($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	;;;;;; Checks for full army using the green sign in army overview window ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;; Will only get full army when the maximum capacity of your camps are reached regardless of the full army percentage you input in GUI ;;;;;;;;;
	;;;;;; Use this only in halt attack mode and if an error happened in reading army current number Or Max capacity ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	If $bOpenArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0346") ;Click Away
		If _Sleep($iDelayCheckFullArmy1) Then Return
		If $iUseRandomClick = 0 then
			Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0347") ; Click Button Army Overview
		Else
			ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
		EndIF
		If _Sleep($iDelayCheckFullArmy2) Then Return
		Local $j = 0
		While Not _ColorCheck(_GetPixelColor($btnpos[0][0], $btnpos[0][1], True), Hex(0xE8E8E0, 6), 20)
			If $debugsetlogTrain = 1 Then Setlog("OverView TabColor=" & _GetPixelColor($btnpos[0][0], $btnpos[0][1], True), $COLOR_PURPLE)
			If _Sleep($iDelayCheckFullArmy1) Then Return ; wait for Train Window to be ready.
			$j += 1
			If $j > 15 Then ExitLoop
		WEnd
		If $j > 15 Then
			SetLog("Training Overview Window didn't open", $COLOR_RED)
			Return
		EndIf
	EndIf

	If _sleep($iDelayCheckFullArmy2) Then Return
	Local $Pixel = _CheckPixel($aIsCampFull, True) And _ColorCheck(_GetPixelColor(128, 176, True), Hex(0x90C030, 6), 20)
	If Not $Pixel Then
		If _sleep($iDelayCheckFullArmy2) Then Return
		$Pixel = _CheckPixel($aIsCampFull, True) And _ColorCheck(_GetPixelColor(128, 176, True), Hex(0x90C030, 6), 20)
	EndIf

	If $debugsetlogTrain = 1 Then Setlog("Checking Overview for full army [!] " & $Pixel & ", " & _GetPixelColor(128, 176, True), $COLOR_PURPLE)
	If $Pixel Then
		$fullArmy = True
	EndIf

	$canRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])
	If $debugSetlog = 1 Then Setlog("Can Request CC: " & $canRequestCC, $COLOR_PURPLE)

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0348") ;Click Away
		If _Sleep($iDelayCheckFullArmy3) Then Return
	EndIf

EndFunc   ;==>CheckOverviewFullArmy

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; #FUNCTION# ====================================================================================================================
; Name ..........: CheckFullBarrack
; Description ...: Checks for Full Barrack when Training window is open to one of the barracks tabs
; Syntax ........: CheckFullBarrack()
; Parameters ....: None
; Return values .: None
; Author ........: The Master
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckFullBarrack()

	;;;;;;; Dont use this to check for full army it just means the barrack has stopped ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;	It could be that the remaining space is lower than the the Housing Space of troop being trained and thats why The barrack has stopped not full army ;;;;;;;;;
	;;;;;;; Calling this function will not change the $fullarmy Variable it will only return true if barrack Has Stopped Training ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	If _sleep(200) Then Return
	Local $Pixel = _CheckPixel($aBarrackFull, True)
	If $debugsetlogTrain = 1 Then Setlog("Check Barrack Full color : " & _GetPixelColor($aBarrackFull[0], $aBarrackFull[1], True) & " Expected if Full : " & Hex($aBarrackFull[2], 6), $COLOR_PURPLE)
	If $debugsetlogTrain = 1 Then Setlog("Checking for Full Normal or Dark Barrack [!]" & $Pixel, $COLOR_PURPLE)

	If $Pixel Then
		Return True ; The Barrack Has Stopped
	Else
		Return False ; The Barrack Has not Stopped
	EndIf

EndFunc   ;==>CheckFullBarrack
