; #FUNCTION# ====================================================================================================================
; Name ..........: CheckImageType()
; Description ...: Detects what Image Type (Normal/Snow)Theme is on your village and sets the $g_iDetectedImageType used for deadbase and Townhall detection.
; Author ........: Hervidero (2015-12)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Assign the Village Theme detected to $g_iDetectedImageType
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: CheckImageType ()
; ===============================================================================================================================
#include-once

Func CheckImageType()
	SetLog("Detecting your Village Theme", $COLOR_INFO)

	ClickP($aAway, 2, 20, "#0467") ;Click Away

	If _Sleep($DELAYCHECKIMAGETYPE1) Then Return
	If Not IsMainPage() Then ClickP($aAway, 2, 20, "#0467") ;Click Away Again

	Local $x = 150
	Local $y = 150
	Local $x1 = $x + 50
	Local $y1 = $y + 50

	Local $directory = @ScriptDir & "\imgxml\SnowTheme"
	Local $temp = SearchImgloc($directory, $x, $y, $x1, $y1)

	If IsArray($temp) Then
		If StringInStr($temp[0], "Snow") > 0 Then
			$g_iDetectedImageType = 1 ;Snow Theme
			SetLog("Snow Theme detected")
		Else
			$g_iDetectedImageType = 0 ; Normal Theme
			SetLog("Normal Theme detected")
		EndIf
	Else
		$g_iDetectedImageType = 0 ; Normal Theme
		SetLog("Normal Theme detected", $COLOR_ERROR)
	EndIf

EndFunc   ;==>CheckImageType
