; #FUNCTION# ====================================================================================================================
; Name ..........: Collect Free Magic Items from trader
; Description ...:
; Syntax ........: CollectFreeMagicItems()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CollectFreeMagicItems($bTest = False)
	If Not $g_bChkCollectFreeMagicItems Or Not $g_bRunState Then Return

	Local Static $iLastTimeChecked[8] = [0, 0, 0, 0, 0, 0, 0, 0]
	If $iLastTimeChecked[$g_iCurAccount] = @MDAY And Not $bTest Then Return

	ClickAway()

	If Not IsMainPage() Then Return

	SetLog("Collecting Free Magic Items", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return

	; Check Trader Icon on Main Village

	Local $sSearchArea = GetDiamondFromRect("120,160,210,215")
	Local $avTraderIcon = findMultiple($g_sImgTrader, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectpoints", True)

	If IsArray($avTraderIcon) And UBound($avTraderIcon) > 0 Then
		Local $asTempArray = $avTraderIcon[0]
		Local $aiCoords = decodeSingleCoord($asTempArray[0])
		SetLog("Trader available, Entering Daily Discounts", $COLOR_SUCCESS)
		ClickP($aiCoords)
		If _Sleep(1500) Then Return
	Else
		SetLog("Trader unavailable", $COLOR_INFO)
		Return
	EndIf

	Local $aiDailyDiscount = decodeSingleCoord(findImage("DailyDiscount", $g_sImgDailyDiscountWindow, GetDiamondFromRect("310,175,375,210"), 1, True, Default))
	If Not IsArray($aiDailyDiscount) Or UBound($aiDailyDiscount, 1) < 1 Then
		ClickAway()
		Return
	EndIf

	If Not $g_bRunState Then Return

	$iLastTimeChecked[$g_iCurAccount] = @MDAY

	Local $aSoldOut[4] = [255, 290, 0xAD5C0D, 10]
	If _CheckPixel($aSoldOut, True, Default, "CollectFreeMagicItems") Then
		SetLog("Free Item Sold Out!", $COLOR_INFO)
		If _Sleep(100) Then Return
		Click(755, 160) ; Click Close Window Button
		If _Sleep(100) Then Return
		Return
	EndIf

	Local $Collected = False
	Local $aResults = GetFreeMagic()
	Local $aGem[3]

	For $i = 0 To UBound($aResults) - 1
		$aGem[$i] = $aResults[$i][0]
	Next

	For $t = 0 To UBound($aResults) - 1
		If $aResults[$t][0] = "FREE" Then
			If Not $bTest Then
				Click($aResults[$t][1], $aResults[$t][2])
			Else
				SetLog("Should click on [" & $aResults[$t][1] & "," & $aResults[$t][2] & "]", $COLOR_ERROR)
			EndIf
			SetLog("Free Magic Item detected", $COLOR_INFO)
			If _Sleep(1000) Then Return
			$Collected = True
			ExitLoop
		EndIf
	Next

	If Not $Collected Then
		SetLog("Nothing free to collect!", $COLOR_INFO)
	EndIf
	SetLog("Daily Discounts: " & $aGem[0] & " | " & $aGem[1] & " | " & $aGem[2])

	ClickAway()
	If _Sleep(1000) Then Return
EndFunc   ;==>CollectFreeMagicItems

Func GetFreeMagic()
	Local $aOcrPositions[3][2] = [[285, 345], [465, 345], [635, 345]]
	Local $aClickFreeItemPositions[3][2] = [[320, 285], [500, 285], [680, 285]]
	Local $aResults[0][3]

	For $i = 0 To UBound($aOcrPositions) - 1

		Local $Read = getOcrAndCapture("coc-freemagicitems", $aOcrPositions[$i][0], $aOcrPositions[$i][1], 200, 25, True)
		If $Read = "FREE" Then
			If WaitforPixel($aOcrPositions[$i][0] - 10, $aOcrPositions[$i][1], $aOcrPositions[$i][0] - 9, $aOcrPositions[$i][1] + 1, "A3A3A3", 10, 1) Then
				$Read = "N/A"
			EndIf
		EndIf
		If $Read = "" Then $Read = "N/A"
		If Number($Read) > 10 Then
			$Read = $Read & " Gems"
		EndIf
		_ArrayAdd($aResults, $Read & "|" & $aClickFreeItemPositions[$i][0] & "|" & $aClickFreeItemPositions[$i][1])
	Next
	Return $aResults
EndFunc
