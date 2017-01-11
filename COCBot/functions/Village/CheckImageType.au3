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
EndFunc   ;==>CheckImageType
