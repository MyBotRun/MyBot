
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyHeroCount
; Description ...: Obtains count of heroes available from Training - Army Overview window
; Syntax ........: getArmyHeroCount()
; Parameters ....:
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......: MonkeyHunter (06-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmyHeroCount($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $debugsetlogTrain = 1 Then SETLOG("Begin getArmyTHeroCount:", $COLOR_PURPLE)

	If $bOpenArmyWindow = False And IsTrainPage() = False Then ; check for train page
		SetError(1)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		If openArmyOverview() = False Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($iDelaycheckArmyCamp5) Then Return
	EndIf

	$iHeroAvailable = $HERO_NOHERO ; Reset hero available data
	$bFullArmyHero = False
	Local $debugArmyHeroCount = 0 ; local debug flag

	; Detection by OCR
	Local $sResult
	Local Const $HeroSlots[3][2] = [[464, 446], [526, 446], [588, 446]] ; Location of hero status check tile
	Local $sMessage = ""

	For $i = 0 To UBound($HeroSlots) - 1
		$sResult = getHeroStatus($HeroSlots[$i][0], $HeroSlots[$i][1]) ; OCR slot for information
		If $sResult <> "" Then ; we found something, figure out what?
			Select
				Case StringInStr($sResult, "king", $STR_NOCASESENSEBASIC)
					Setlog(" - Barbarian King available")
					$iHeroAvailable = BitOR($iHeroAvailable, $HERO_KING)
				Case StringInStr($sResult, "queen", $STR_NOCASESENSEBASIC)
					Setlog(" - Archer Queen available")
					$iHeroAvailable = BitOR($iHeroAvailable, $HERO_QUEEN)
				Case StringInStr($sResult, "warden", $STR_NOCASESENSEBASIC)
					Setlog(" - Grand Warden available")
					$iHeroAvailable = BitOR($iHeroAvailable, $HERO_WARDEN)
				Case StringInStr($sResult, "heal", $STR_NOCASESENSEBASIC)
					If $debugsetlogTrain = 1 Or $debugArmyHeroCount = 1 Then
						Switch $i
							Case 0
								$sMessage = "-Barbarian King"
							Case 1
								$sMessage = "-Archer Queen"
							Case 2
								$sMessage = "-Grand Warden"
							Case Else
								$sMessage = "-Very Bad Monkey Needs"
						EndSwitch
						SetLog("Hero slot#" & $i + 1 & $sMessage & " Healing", $COLOR_PURPLE)
					EndIf
				Case StringInStr($sResult, "upgrade", $STR_NOCASESENSEBASIC)
					If $debugsetlogTrain = 1 Or $debugArmyHeroCount = 1 Then
						Switch $i
							Case 0
								$sMessage = "-Barbarian King"
							Case 1
								$sMessage = "-Archer Queen"
							Case 2
								$sMessage = "-Grand Warden"
							Case Else
								$sMessage = "-Need to Get Monkey"
						EndSwitch
						SetLog("Hero slot#" & $i + 1 & $sMessage & " Upgrade in Process", $COLOR_PURPLE)
					EndIf
				Case StringInStr($sResult, "none", $STR_NOCASESENSEBASIC)
					If $debugsetlogTrain = 1 Or $debugArmyHeroCount = 1 Then SetLog("Hero slot#" & $i + 1 & " Empty, stop count", $COLOR_PURPLE)
					ExitLoop ; when we find empty slots, done looking for heroes
				Case Else
					SetLog("Hero slot#" & $i + 1 & " bad OCR string returned!", $COLOR_RED)
			EndSelect
		Else
			SetLog("Hero slot#" & $i + 1 & " status read problem!", $COLOR_RED)
		EndIf
	Next

	If BitAND($iHeroWait[$DB], $iHeroAvailable) > 0 Or BitAND($iHeroWait[$LB], $iHeroAvailable) > 0 Or _
			($iHeroWait[$DB] = $HERO_NOHERO And $iHeroWait[$LB] = $HERO_NOHERO) Then
		$bFullArmyHero = True
		If $debugsetlogTrain = 1 Or $debugArmyHeroCount = 1 Then SetLog("$bFullArmyHero= " & $bFullArmyHero, $COLOR_PURPLE)
	EndIf

	If $debugsetlogTrain = 1 Or $debugArmyHeroCount = 1 Then SetLog("Hero Status K|Q|W : " & BitAND($iHeroAvailable, $HERO_KING) & "|" & BitAND($iHeroAvailable, $HERO_QUEEN) & "|" & BitAND($iHeroAvailable, $HERO_WARDEN), $COLOR_PURPLE)

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

EndFunc   ;==>getArmyHeroCount
