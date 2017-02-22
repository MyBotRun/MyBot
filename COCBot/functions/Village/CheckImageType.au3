; #FUNCTION# ====================================================================================================================
; Name ..........: CheckImageType()
; Description ...: Detects what Image Type (Normal/Snow)Theme is on your village and sets the $iDetectedImageType used for deadbase and Townhall detection.
; Author ........: Hervidero (2015-12)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Assign the Village Theme detected to $iDetectedImageType
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: CheckImageType ()
; ===============================================================================================================================
#include-once

Func CheckImageType()
	Setlog("Detecting your Village Theme", $COLOR_INFO)

	ClickP($aAway, 2, 20, "#0467") ;Click Away

	If _Sleep($iDelayImageType1) Then Return
	If Not IsMainPage() Then ClickP($aAway, 2, 20, "#0467") ;Click Away Again

	Local $x = 200
	Local $y = 130
	Local $x1 = $x + 60
	Local $y1 = $y + 80

	Local $directory = @ScriptDir & "\imgxml\SnowTheme"
	Local $temp = SearchImgloc($directory, $x, $y, $x1, $y1)

	If IsArray($temp) then
		If StringInStr($temp[0], "Snow") > 0 Then
			$iDetectedImageType = 1 ;Snow Theme
			Setlog("Snow Theme detected")
		Else
			$iDetectedImageType = 0 ; Normal Theme
			Setlog("Normal Theme detected")
		EndIf
	Else
		$iDetectedImageType = 0 ; Normal Theme
		Setlog("Normal Theme detected", $COLOR_RED)
	EndIf

;~ 	If _ColorCheck(_GetPixelColor($aImageTypeN1[0], $aImageTypeN1[1], True), Hex($aImageTypeN1[2], 6), $aImageTypeN1[3]) And _
;~ 			_ColorCheck(_GetPixelColor($aImageTypeN2[0], $aImageTypeN2[1], True), Hex($aImageTypeN2[2], 6), $aImageTypeN2[3]) Then
;~ 		$iDetectedImageType = 0; Normal Theme
;~ 		Setlog("Normal Theme detected")
;~ 	ElseIf _ColorCheck(_GetPixelColor($aImageTypeS1[0], $aImageTypeS1[1], True), Hex($aImageTypeS1[2], 6), $aImageTypeS1[3]) And _
;~ 			_ColorCheck(_GetPixelColor($aImageTypeS2[0], $aImageTypeS2[1], True), Hex($aImageTypeS2[2], 6), $aImageTypeS2[3]) Then
;~ 		$iDetectedImageType = 1;Snow Theme
;~ 		Setlog("Snow Theme detected")
;~ 	Else
;~ 		$iDetectedImageType = 0; Default to Normal Theme
;~ 		Setlog("Default Theme detected")
;~ 	EndIf

;~ 	readCollectorConfig();initialize collector fullness variables before loading images

EndFunc   ;==>CheckImageType
