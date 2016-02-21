
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyHeroCount
; Description ...: Obtains count of heroes available from Training - Army Overview window
; Syntax ........: getArmyHeroCount()
; Parameters ....:
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmyHeroCount($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $debugSetlog = 1 Then SETLOG("Begin getArmyTHeroCount:", $COLOR_PURPLE)

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

	$iHeroAvailable = $HERO_NOHERO  ; Reset hero available data
	$bFullArmyHero = False

	If Not _ColorCheck(_GetPixelColor(428, 447 + $midOffsetY, True), Hex(0xd0cfc5, 6), 10) Then
		; Slot 1
		If _ColorCheck(_GetPixelColor(426, 447 + $midOffsetY, True), Hex(0xf6bc20, 6), 15) Then
			Setlog(" - Grand Warden available")
			$iHeroAvailable = BitOR($iHeroAvailable, $HERO_WARDEN)
		EndIf
		If _ColorCheck(_GetPixelColor(426, 447 + $midOffsetY, True), Hex(0x812612, 6), 15) Then
			Setlog(" - Archer Queen available")
			$iHeroAvailable = BitOR($iHeroAvailable, $HERO_QUEEN)
		EndIf
		If _ColorCheck(_GetPixelColor(428, 447 + $midOffsetY, True), Hex(0x4e3d33, 6), 15) Then
			Setlog(" - Barbarian King available")
			$iHeroAvailable = BitOR($iHeroAvailable, $HERO_KING)
		EndIf
		; Slot 2
		If _ColorCheck(_GetPixelColor(490, 447 + $midOffsetY, True), Hex(0xf2bb1f, 6), 15) Then
			Setlog(" - Grand Warden available")
			$iHeroAvailable = BitOR($iHeroAvailable, $HERO_WARDEN)
		EndIf
		If _ColorCheck(_GetPixelColor(490, 447 + $midOffsetY, True), Hex(0xa81c08, 6), 15) Then
			Setlog(" - Archer Queen available")
			$iHeroAvailable = BitOR($iHeroAvailable, $HERO_QUEEN)
		EndIf
		; Slot 3
		If _ColorCheck(_GetPixelColor(558, 447 + $midOffsetY, True), Hex(0xfecc1d, 6), 15) Then
			Setlog(" - Grand Warden available")
			$iHeroAvailable = BitOR($iHeroAvailable, $HERO_WARDEN)
		EndIf
	EndIf

	If BitAND($iHeroWait[$DB], $iHeroAvailable) > 0 Or BitAND($iHeroWait[$LB], $iHeroAvailable) > 0 Or _
		($iHeroWait[$DB] = $HERO_NOHERO And $iHeroWait[$DB] = $HERO_NOHERO) Then
		$bFullArmyHero = True
		If $DebugSetlog = 1 Then SetLog("$bFullArmyHero= " & $bFullArmyHero, $COLOR_PURPLE)
	EndIf

	If $DebugSetlog = 1 Then SetLog("Hero Status K|Q|W : " & BitAND($iHeroAvailable, $HERO_KING) & "|" & BitAND($iHeroAvailable, $HERO_QUEEN) & "|" & BitAND($iHeroAvailable, $HERO_WARDEN), $COLOR_PURPLE)

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

EndFunc   ;==>getArmyHeroCount
