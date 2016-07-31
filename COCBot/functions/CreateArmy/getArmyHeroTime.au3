
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyHeroTime
; Description ...: Obtains time reamining for Heros Training - Army Overview window
; Syntax ........: getArmyHeroTime($iHeroEnum = $eKing, $bReturnTimeArray = False, $bOpenArmyWindow = False, $bCloseArmyWindow = False)
; Parameters ....: $iHeroEnum = enum value for hero to check, or text "all" to check all heroes
;					  : $bOpenArmyWindow  = Bool value true if train overview window needs to be opened
;					  : $bCloseArmyWindow = Bool value, true if train overview window needs to be closed
; Return values .: MonkeyHunter (05/06-2016)
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmyHeroTime($HeroType, $bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("Begin getArmyHeroTime:", $COLOR_PURPLE)

	; validate hero troop type input, must be hero enum value or "all"
	If $HeroType <> $eKing And $HeroType <> $eQueen And $HeroType <> $eWarden And StringInStr($HeroType, "all", $STR_NOCASESENSEBASIC) = 0 Then
		Setlog("getHeroTime slipped on banana, get doctor, tell him: " & $HeroType, $COLOR_RED)
		SetError(1)
		Return
	EndIf

	If $bOpenArmyWindow = False And IsTrainPage() = False Then ; check for train page and open window if needed
		SetError(2)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		If openArmyOverview() = False Then
			SetError(3)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($iDelaycheckArmyCamp5) Then Return
	EndIf

	Local $iRemainTrainHeroTimer = 0
	Local $sResult
	Local $iResultHeroes[3] = ["", "", ""] ; array to hold all remaining regen time read via OCR
	Local Const $HeroSlots[3][2] = [[464, 446], [526, 446], [588, 446]] ; Location of hero status check tile

	; Constant Array with OCR find location: [X pos, Y Pos, Text Name, Global enum value]
	Local Const $aHeroRemainData[3][4] = [[443, 504, "King", $eKing], [504, 504, "Queen", $eQueen], [565, 504, "Warden", $eWarden]]

	For $index = 0 To UBound($aHeroRemainData) - 1 ;cycle through all 3 slots and hero types

		; check if OCR required
		If StringInStr($HeroType, "all", $STR_NOCASESENSEBASIC) = 0 And $HeroType <> $aHeroRemainData[$index][3] Then ContinueLoop

		; Check if slot has healing hero
		$sResult = getHeroStatus($HeroSlots[$index][0], $HeroSlots[$index][1]) ; OCR slot for status information
		If $sResult <> "" Then ; we found something
			If StringInStr($sResult, "heal", $STR_NOCASESENSEBASIC) = 0 Then
				If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then
					SetLog("Hero slot#" & $index + 1 & " status: " & $sResult & " :skip time read", $COLOR_PURPLE)
				EndIf
				ContinueLoop ; if do not find hero healing, then do not read time
			Else
				If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("Hero slot#" & $index + 1 & " status: " & $sResult, $COLOR_PURPLE)
			EndIf
		Else
			SetLog("Hero slot#" & $index + 1 & " Status read problem!", $COLOR_RED)
		EndIf

		$sResult = getRemainTHero($aHeroRemainData[$index][0], $aHeroRemainData[$index][1]) ;Get Hero training time via OCR.

		If $sResult <> "" Then
			Select
				Case StringInStr($sResult, "m", $STR_NOCASESENSEBASIC) ; find minutes?
					$sResultHeroTime = StringTrimRight($sResult, 1) ; removing the "m"
					$iResultHeroes[$index] = Number($sResultHeroTime)
				Case StringInStr($sResult, "s", $STR_NOCASESENSEBASIC) ; find seconds?
					$sResultHeroTime = StringTrimRight($sResult, 1) ; removing the "s"
					$iResultHeroes[$index] = Number($sResultHeroTime) / 60 ; convert to minute
				Case Else
					SetLog("Bad read of remaining " & $aHeroRemainData[$index][2] & " train time: " & $sResult, $COLOR_RED)
			EndSelect
			If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("Remaining " & $aHeroRemainData[$index][2] & " train time: " & StringFormat("%.2f", $iResultHeroes[$index]), $COLOR_PURPLE)

			If $HeroType = $aHeroRemainData[$index][3] Then ; if only one hero requested, then set return value and exit loop
				$iRemainTrainHeroTimer = Number($sResultHeroTime)
				ExitLoop
			EndIf
		Else ; empty OCR value
			If $HeroType = $aHeroRemainData[$index][3] Then ; only one hero value?
				SetLog("Can not read remaining " & $aHeroRemainData[$index][2] & " train time", $COLOR_RED)
			Else
				; reading all heros, need to find if hero is active/wait to determine how to log message?
				For $pMatchMode = $DB To $iMatchMode - 1 ; check all attack modes
					If IsSpecialTroopToBeUsed($pMatchMode, $aHeroRemainData[$index][3]) And _
							BitAND($iHeroAttack[$pMatchMode], $iHeroWait[$pMatchMode]) = $iHeroWait[$pMatchMode] Then ; check if Hero enabled to wait
						SetLog("Can not read remaining " & $aHeroRemainData[$index][2] & " train time", $COLOR_RED)
						ExitLoop
					Else
						If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("Bad read remain " & $aHeroRemainData[$index][2] & " train time, but not enabled", $COLOR_PURPLE)
					EndIf
				Next
			EndIf
		EndIf
	Next

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

	; Determine proper return value
	If $HeroType = $eKing Or $HeroType = $eQueen Or $HeroType = $eWarden Then
		Return $iRemainTrainHeroTimer ; return one requested hero value
	ElseIf StringInStr($HeroType, "all", $STR_NOCASESENSEBASIC) > 0 Then
		; calling function needs to check if heroattack enabled & herowait enabled for attack mode used!
		Return $iResultHeroes ; return array of with each hero regen time value
	EndIf

EndFunc   ;==>getArmyHeroTime
