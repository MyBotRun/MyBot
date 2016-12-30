; #FUNCTION# ====================================================================================================================
; Name ..........: FindAButton.au3
; Description ...: Find a specific button; Grouped non-generic functions
; Syntax ........: None
; Parameters ....:
; Return values .: None
; Author ........: MMHK (11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func FindExitButton($sButtonName)
	Local $aCoor
	Local $sDirectory = "exitbutton-bundle"
	Local $sReturnProps = "objectpoints"
	Local $result = ""
	Local $aPosXY = ""

	$aCoor = StringSplit(GetButtonRectangle($sButtonName), ",", $STR_NOCOUNT)
	_CaptureRegion2($aCoor[0], $aCoor[1], $aCoor[2], $aCoor[3])
	$result = findMultiple($sDirectory ,"FV" ,"FV", 0, 0, 1 , $sReturnProps, False)

	If IsArray($result) then
		$aPosXY = StringSplit(($result[0])[0], ",", $STR_NOCOUNT)
		$aPosXY[0] += $aCoor[0]
		$aPosXY[1] += $aCoor[1]
		If $DebugSetlog = 1 Then Setlog("FindExitButton: " & $sButtonName & " Button X|Y = " & $aPosXY[0] & "|" & $aPosXY[1], $COLOR_DEBUG)
		Return $aPosXY
	EndIf

	If $DebugSetlog = 1 Then SetLog("FindExitButton: " & $sButtonName & " NOT Found" , $COLOR_DEBUG)
	Return $aPosXY
EndFunc   ;==>FindExitButton

Func FindAdsXButton()
	Local $sCoor
	Local $sDirectory = "adsxbutton-bundle"
	Local $sReturnProps = "objectpoints"
	Local $result = ""
	Local $aPosXY = ""

	$sCoor = GetDiamondFromRect(GetButtonRectangle("AdsX"))
	$result = findMultiple($sDirectory, $sCoor, "FV", 0, 0, 1, $sReturnProps, False)

	If IsArray($result) then
		$aPosXY = StringSplit(($result[0])[0], ",", $STR_NOCOUNT)
		If $DebugSetlog = 1 Then Setlog("FindAdsXButton: " & $AndroidGameDistributor & " AdsX Button X|Y = " & $aPosXY[0] & "|" & $aPosXY[1], $COLOR_DEBUG)
		Return $aPosXY
	EndIf

	If $DebugSetlog = 1 Then Setlog("FindAdsXButton: " & $AndroidGameDistributor & " NOT Found", $COLOR_DEBUG)
	Return $aPosXY
EndFunc   ;==>FindAdsXButton

Func GetButtonRectangle($sButtonName)
	Local $btnRectangle = "0,0," & $DEFAULT_WIDTH & "," & $DEFAULT_HEIGHT

	Switch $sButtonName
		Case "Kunlun", "Huawei", "Kaopu", "Microvirt", "Yeshen"
			$btnRectangle = GetDummyRectangle("345,394", 10)
		Case "Qihoo"
			$btnRectangle = GetDummyRectangle("302,456", 10)
		Case "Baidu"
			$btnRectangle = GetDummyRectangle("464,426", 10)
		Case "OPPO"
			$btnRectangle = GetDummyRectangle("476,412", 10)
		Case "Anzhi"
			$btnRectangle = GetDummyRectangle("328,371", 10)
		Case "Lenovo"
			$btnRectangle = GetDummyRectangle("477,476", 10)
		Case "Aiyouxi"
			$btnRectangle = GetDummyRectangle("468,392", 10)
		Case "9game"
			$btnRectangle = "349,352,369,436" ; 359,362 -- 359,406 + offset 10 + Y 20 counter the moving button
		Case "VIVO", "Xiaomi"
			$btnRectangle = GetDummyRectangle("353,387", 10)
		Case "Guopan"
			$btnRectangle = GetDummyRectangle("409,440", 10)
		Case "AdsX"
			$btnRectangle = ($DEFAULT_WIDTH / 2) & ",0," & $DEFAULT_WIDTH & "," & ($DEFAULT_HEIGHT / 2) ; upper right area of screen
		Case Else
			$btnRectangle = "0,0," & $DEFAULT_WIDTH & "," & $DEFAULT_HEIGHT ; use full image to locate button
	EndSwitch

	Return $btnRectangle
EndFunc   ;==>GetButtonRectangle
