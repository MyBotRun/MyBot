; #FUNCTION# ====================================================================================================================
; Name ..........: GetListPixel($listPixel), GetListPixel2($listPixel), GetLocationItem($functionName)
; Description ...: Pixel and Locate Image functions
; Author ........: HungLe (april-2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetListPixel($listPixel)
	Local $listPixelSideStr = StringSplit($listPixel, "|")
	If ($listPixelSideStr[0] > 1) Then
		Local $listPixelSide[UBound($listPixelSideStr) - 1]
		For $i = 0 To UBound($listPixelSide) - 1
			Local $pixelStr = StringSplit($listPixelSideStr[$i + 1], "-")
			If ($pixelStr[0] > 1) Then
				Local $pixel[2] = [$pixelStr[1], $pixelStr[2]]
				$listPixelSide[$i] = $pixel
			EndIf
		Next
		Return $listPixelSide
	Else
		If StringInStr($listPixel, "-") > 0 Then
			Local $pixelStrHere = StringSplit($listPixel, "-")
			Local $pixelHere[2] = [$pixelStrHere[1], $pixelStrHere[2]]
			Local $listPixelHere[1]
			$listPixelHere[0] = $pixelHere
			Return $listPixelHere
		EndIf
		Return -1;
	EndIf
EndFunc   ;==>GetListPixel


Func GetLocationItem($functionName)
	If $debugSetLog = 1 Or $debugBuildingPos = 1 Then
		Local $hTimer = TimerInit()
		Setlog("GetLocationItem(" & $functionName & ")", $COLOR_PURPLE)
	EndIf
	$resultHere = DllCall($hFuncLib, "str", $functionName, "ptr", $hHBitmap2)
	If UBound($resultHere) > 0 Then
		If $debugBuildingPos = 1 Then Setlog("#*# " & $functionName & ": " & $resultHere[0] & "calc in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
		Return GetListPixel($resultHere[0])
	Else
		If $debugBuildingPos = 1 Then Setlog("#*# " & $functionName & ": NONE calc in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
	EndIf
EndFunc   ;==>GetLocationItem
