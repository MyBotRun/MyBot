
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyHeroTime
; Description ...: Obtains time reamining for Heros Training - Army Overview window
; Syntax ........: getArmyHeroTime($iHeroEnum = $eKing, $bReturnTimeArray = False, $bOpenArmyWindow = False, $bCloseArmyWindow = False)
; Parameters ....: $iHeroEnum = enum value for hero to check, or text "all" to check all heroes
;					  : $bOpenArmyWindow  = Bool value, true if train overview window needs to be opened
;					  : $bCloseArmyWindow = Bool value, true if train overview window needs to be closed
;                     : $bForceReadTime   = Bool value, true if updrade remaining time should be read
; Return values .:
; Author ........: MonkeyHunter (05/06-2016)
; Modified ......: MR.ViPER (24-12-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmyHeroTime($HeroType = "all", $bOpenArmyWindow = False, $bCloseArmyWindow = False, $bForceReadTime = False)

	If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then Setlog("Begin getArmyHeroTime:", $COLOR_DEBUG1)

	; validate hero troop type input, must be hero enum value or "all"
	If $HeroType <> $eKing And $HeroType <> $eQueen And $HeroType <> $eWarden And StringInStr($HeroType, "all", $STR_NOCASESENSEBASIC) = 0 Then
		Setlog("getHeroTime slipped on banana, get doctor, tell him: " & $HeroType, $COLOR_ERROR)
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

	;If $iTownHallLevel < 7 then Return
	If $bHaveAnyHero = -1 Then
		; The variable to see if the village have any hero is not set yet
		; check if the village have any hero
		Local $rImgSearch = Not (StringInStr(FindImageInPlace("HaveAnyHero", @ScriptDir & "\imgxml\trainwindow\HeroSlots\NoHero_1_95.xml", "620,400,675,430", True), ","))
		If $g_iDebugSetlog = 1 Then SetLog("Setting $bHaveAnyHero Value To: " & $rImgSearch, $COLOR_DEBUG)
		If $rImgSearch = True Then
			$bHaveAnyHero = 1
		Else
			$bHaveAnyHero = 0
			Return	; There're no heroes to check, Return
		EndIf
	ElseIf $bHaveAnyHero = 0 Then
		If $g_iDebugSetlog = 1 Then SetLog("$bHaveAnyHero = 0", $COLOR_DEBUG)
		Return	; There're no heroes to check, Return
	EndIf

	Local $iRemainTrainHeroTimer = 0
	Local $i
	Local $sResult
	Local $iResultHeroes[3] = [0, 0, 0] ; array to hold all remaining regen time read via OCR
	Local Const $HeroSlots[3][2] = [[464, 446], [526, 446], [588, 446]] ; Location of hero status check tile
	Local $tmpUpgradingHeroes[3] = [ $eHeroNone, $eHeroNone, $eHeroNone ]
	If StringInStr($HeroType, "all", $STR_NOCASESENSEBASIC) > 0 Then
		$iHeroUpgrading[0] = 0
		$iHeroUpgrading[1] = 0
		$iHeroUpgrading[2] = 0
	EndIf

	; Constant Array with OCR find location: [X pos, Y Pos, Text Name, Global enum value]
	Local Const $aHeroRemainData[3][4] = [[620, 414, "King", $eKing], [690, 414, "Queen", $eQueen], [765, 414, "Warden", $eWarden]]

	For $index = 0 To UBound($aHeroRemainData) - 1 ;cycle through all 3 slots and hero types

		; check if OCR required
		If StringInStr($HeroType, "all", $STR_NOCASESENSEBASIC) = 0 And $HeroType <> $aHeroRemainData[$index][3] Then ContinueLoop

		; Check if slot has healing hero
		$sResult = ArmyHeroStatus($index) ; OCR slot for status information
		If $g_iDebugSetlog = 1 or $g_iDebugSetlogTrain = 1 Then SetLog($aHeroRemainData[$index][2] & " Status: " & $sResult, $COLOR_DEBUG)
		If $sResult <> "" Then ; we found something
			If StringInStr($sResult, "upgrade", $STR_NOCASESENSEBASIC) <> 0 Then
				Switch $index
					Case 0
						$tmpUpgradingHeroes[$index] = $eHeroKing
					Case 1
						$tmpUpgradingHeroes[$index] = $eHeroQueen
					Case 2
						$tmpUpgradingHeroes[$index] = $eHeroWarden
				EndSwitch
				$iHeroUpgrading[$index] = 1
			EndIf
			If $bForceReadTime = False And StringInStr($sResult, "heal", $STR_NOCASESENSEBASIC) = 0 or StringInStr($sResult, "none", $STR_NOCASESENSEBASIC) <> 0 Then
				If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then
					SetLog("Hero slot#" & $index + 1 & " status: " & $sResult & " :skip time read", $COLOR_DEBUG)
				EndIf
				ContinueLoop ; if do not find hero healing, then do not read time
			Else
				If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SetLog("Hero slot#" & $index + 1 & " status: " & $sResult, $COLOR_DEBUG)
			EndIf
		Else
			SetLog("Hero slot#" & $index + 1 & " Status read problem!", $COLOR_ERROR)
		EndIf

		$sResult = getRemainTHero($aHeroRemainData[$index][0], $aHeroRemainData[$index][1]) ;Get Hero training time via OCR.
		If $g_iDebugSetlog = 1 Then SetLog("OCR|Remain Hero Regen Time = " & $sResult, $COLOR_DEBUG)
		If $sResult <> "" Then
			Local $sResultHeroTime = 0
			Select
				Case StringInStr($sResult, "m", $STR_NOCASESENSEBASIC) >= 1 ; find minutes?
					$sResultHeroTime = StringTrimRight($sResult, 1) ; removing the "m"
					$iResultHeroes[$index] = Number($sResultHeroTime)
				Case StringInStr($sResult, "s", $STR_NOCASESENSEBASIC) >= 1 ; find seconds?
					$sResultHeroTime = StringTrimRight($sResult, 1) ; removing the "s"
					$iResultHeroes[$index] = Number($sResultHeroTime) / 60 ; convert to minute
				Case Else
					SetLog("Bad read of remaining " & $aHeroRemainData[$index][2] & " heal time: " & $sResult, $COLOR_RED)
			EndSelect
			If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SetLog("Remaining " & $aHeroRemainData[$index][2] & " heal time: " & StringFormat("%.2f", $iResultHeroes[$index]), $COLOR_DEBUG) ;Debug

			If $HeroType = $aHeroRemainData[$index][3] Then ; if only one hero requested, then set return value and exit loop
				$iRemainTrainHeroTimer = Number($sResultHeroTime)
				ExitLoop
			EndIf
		Else ; empty OCR value
			If $HeroType = $aHeroRemainData[$index][3] Then ; only one hero value?
				SetLog("Can not read remaining " & $aHeroRemainData[$index][2] & " heal time", $COLOR_RED)
			Else
				; reading all heros, need to find if hero is active/wait to determine how to log message?
				For $pMatchMode = $DB To $g_iMatchMode - 1 ; check all attack modes
					If IsSpecialTroopToBeUsed($pMatchMode, $aHeroRemainData[$index][3]) And _
							BitAND($g_aiAttackUseHeroes[$pMatchMode], $g_aiSearchHeroWaitEnable[$pMatchMode]) = $g_aiSearchHeroWaitEnable[$pMatchMode] Then ; check if Hero enabled to wait
						SetLog("Can not read remaining " & $aHeroRemainData[$index][2] & " heal time", $COLOR_RED)
						ExitLoop
					Else
						If $g_iDebugSetlogTrain = 1 Or $g_iDebugSetlog = 1 Then SetLog("Bad read remain " & $aHeroRemainData[$index][2] & " heal time, but not enabled", $COLOR_DEBUG) ;Debug
					EndIf
				Next
			EndIf
		EndIf
	Next

	If StringInStr($HeroType, "all", $STR_NOCASESENSEBASIC) > 0 Then $iHeroUpgradingBit = BitOR($tmpUpgradingHeroes[0], $tmpUpgradingHeroes[1], $tmpUpgradingHeroes[2])

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
