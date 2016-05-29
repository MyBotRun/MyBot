; #FUNCTION# ====================================================================================================================
; Name ..........: CheckImageType()
; Description ...: Detects what Image Type (Normal/Snow)Theme is on your village and sets the $iDetectedImageType used for deadbase and Townhall detection.
; Author ........: Hervidero (2015-12)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Assign the Village Theme detected to $iDetectedImageType
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: CheckImageType ()
; ===============================================================================================================================

Func CheckImageType()
	Setlog("Detecting your Village Theme", $COLOR_BLUE)

	ClickP($aAway, 2, 20, "#0467") ;Click Away

	If _Sleep($iDelayImageType1) Then Return
	If Not IsMainPage() Then ClickP($aAway, 2, 20, "#0467") ;Click Away Again

	If _ColorCheck(_GetPixelColor($aImageTypeN1[0], $aImageTypeN1[1], True), Hex($aImageTypeN1[2], 6), $aImageTypeN1[3]) And _
			_ColorCheck(_GetPixelColor($aImageTypeN2[0], $aImageTypeN2[1], True), Hex($aImageTypeN2[2], 6), $aImageTypeN2[3]) Then
		$iDetectedImageType = 0; Normal Theme
		Setlog("Normal Theme detected")
	ElseIf _ColorCheck(_GetPixelColor($aImageTypeS1[0], $aImageTypeS1[1], True), Hex($aImageTypeS1[2], 6), $aImageTypeS1[3]) And _
			_ColorCheck(_GetPixelColor($aImageTypeS2[0], $aImageTypeS2[1], True), Hex($aImageTypeS2[2], 6), $aImageTypeS2[3]) Then
		$iDetectedImageType = 1;Snow Theme
		Setlog("Snow Theme detected")
	Else
		$iDetectedImageType = 0; Default to Normal Theme
		Setlog("Default Theme detected")
	EndIf

;~ 	readCollectorConfig();initialize collector fullness variables before loading images

	LoadTHImage() ; Load TH images
	LoadElixirImage() ; Load Elixir images
	LoadElixirImage75Percent(); Load Elixir images full at 75%
	LoadElixirImage50Percent(); Load Elixir images full at 50%

EndFunc   ;==>CheckImageType
