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

Func GetListPixel($listPixel, $sDelim = "-", $sName = "")
	If $sName <> "" Then debugAttackCSV("GetListPixel for " & $sName & ": " & $listPixel)
	Local $listPixelSideStr = StringSplit($listPixel, "|")
	If ($listPixelSideStr[0] > 1) Then
		Local $listPixelSide[UBound($listPixelSideStr) - 1]
		For $i = 0 To UBound($listPixelSide) - 1
			Local $pixel = GetPixel($listPixelSideStr[$i + 1], $sDelim)
			If UBound($pixel) > 1 Then
				$listPixelSide[$i] = $pixel
			EndIf
		Next
		Return $listPixelSide
	Else
		If StringInStr($listPixel, $sDelim) > 0 Then
			Local $pixel = GetPixel($listPixel, $sDelim)
			Local $listPixelHere = [$pixel]
			Return $listPixelHere
		EndIf
		Return -1 ;
	EndIf
EndFunc   ;==>GetListPixel

Func GetPixel($sPixel, $sDelim = "-")
	Local $pixel = StringSplit($sPixel, $sDelim, $STR_NOCOUNT)
	If UBound($pixel) < 2 Then Return $pixel
	$pixel[0] = Int($pixel[0])
	$pixel[1] = Int($pixel[1])
	Return $pixel
EndFunc   ;==>GetPixel

Func GetPixelDistance(Const ByRef $Pixel0, Const ByRef $Pixel1)
	Local $a = $Pixel0[0] - $Pixel1[0]
	Local $b = $Pixel0[1] - $Pixel1[1]
	Local $d = Sqrt($a * $a + $b * $b)
	Return $d
EndFunc   ;==>GetPixelDistance

Func GetLocationItem($functionName)
	If $debugSetLog = 1 Or $debugBuildingPos = 1 Then
		Local $hTimer = TimerInit()
		Setlog("GetLocationItem(" & $functionName & ")", $COLOR_DEBUG)
	EndIf
	$resultHere = DllCall($hFuncLib, "str", $functionName, "ptr", $hHBitmap2)
	If UBound($resultHere) > 0 Then
		If $debugBuildingPos = 1 Then Setlog("#*# " & $functionName & ": " & $resultHere[0] & "calc in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_DEBUG1)
		Return GetListPixel($resultHere[0])
	Else
		If $debugBuildingPos = 1 Then Setlog("#*# " & $functionName & ": NONE calc in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_DEBUG1)
	EndIf
EndFunc   ;==>GetLocationItem
