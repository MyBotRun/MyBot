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
	Local $aOcrPositions[3][2] = [[200, 439], [390, 439], [580, 439]]
	Local $aResults[3] = ["", "", ""]

	$iLastTimeChecked[$g_iCurAccount] = @MDAY

	For $i = 0 To 2
		$aResults[$i] = getOcrAndCapture("coc-freemagicitems", $aOcrPositions[$i][0], $aOcrPositions[$i][1], 80, 25, True)
		; 5D79C5 ; >Blue Background price
		If $aResults[$i] <> "" Then
			If Not $bTest Then
				If $aResults[$i] = "FREE" Then
					Click($aOcrPositions[$i][0], $aOcrPositions[$i][1], 2, 500)
					SetLog("Free Magic Item detected", $COLOR_INFO)
					ClickAway()
					If _Sleep(1000) Then Return
					Return
				Else
					If _ColorCheck(_GetPixelColor($aOcrPositions[$i][0], $aOcrPositions[$i][1] + 5, True), Hex(0x5D79C5, 6), 5) Then
						$aResults[$i] = $aResults[$i] & " Gems"
					Else
						$aResults[$i] = Int($aResults[$i]) > 0 ? "No Space In Castle" : "Collected"
					EndIf
				EndIf
			EndIf
		ElseIf $aResults[$i] = "" Then
			$aResults[$i] = "N/A"
		EndIf

		If Not $g_bRunState Then Return
	Next

	SetLog("Daily Discounts: " & $aResults[0] & " | " & $aResults[1] & " | " & $aResults[2])
	SetLog("Nothing free to collect!", $COLOR_INFO)
	ClickAway()
	If _Sleep(1000) Then Return
EndFunc   ;==>CollectFreeMagicItems
