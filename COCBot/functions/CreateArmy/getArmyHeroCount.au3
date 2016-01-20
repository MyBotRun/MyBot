
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

	If IsTrainPage() = False And $bOpenArmyWindow = False Then ; check for train page
		SetError(1)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		openArmyOverview()
		If _Sleep($iDelaycheckArmyCamp5) Then Return
	EndIf

	$BarbarianKingAvailable = 0 ; reset Gobal variables
	$ArcherQueenAvailable = 0
	$GrandWardenAvailable = 0

	If Not _ColorCheck(_GetPixelColor(428, 447 + $midOffsetY, True), Hex(0xd0cfc5, 6), 10) Then
		; Slot 1
		If _ColorCheck(_GetPixelColor(426, 447 + $midOffsetY, True), Hex(0xf6bc20, 6), 15) Then
			Setlog(" - Grand Warden available")
			$GrandWardenAvailable = 1
		EndIf
		If _ColorCheck(_GetPixelColor(426, 447 + $midOffsetY, True), Hex(0x812612, 6), 15) Then
			Setlog(" - Archer Queen available")
			$ArcherQueenAvailable = 1
		EndIf
		If _ColorCheck(_GetPixelColor(428, 447 + $midOffsetY, True), Hex(0x4e3d33, 6), 15) Then
			Setlog(" - Barbarian King available")
			$BarbarianKingAvailable = 1
		EndIf
		; Slot 2
		If _ColorCheck(_GetPixelColor(490, 447 + $midOffsetY, True), Hex(0xf2bb1f, 6), 15) Then
			Setlog(" - Grand Warden available")
			$GrandWardenAvailable = 1
		EndIf
		If _ColorCheck(_GetPixelColor(490, 447 + $midOffsetY, True), Hex(0xa81c08, 6), 15) Then
			Setlog(" - Archer Queen available")
			$ArcherQueenAvailable = 1
		EndIf
		; Slot 3
		If _ColorCheck(_GetPixelColor(558, 447 + $midOffsetY, True), Hex(0xfecc1d, 6), 15) Then
			Setlog(" - Grand Warden available")
			$GrandWardenAvailable = 1
		EndIf
	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

EndFunc   ;==>getArmyHeroCount
