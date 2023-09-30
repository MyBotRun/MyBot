; #FUNCTION# ====================================================================================================================
; Name ..........: Collect Free Magic Items from trader
; Description ...:
; Syntax ........: CollectFreeMagicItems()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018)
; Modified ......: Moebius14 (09-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2023
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

	Local $aOcrPositions[3][2] = [[270, 350], [480, 350], [690, 350]]
	Local $ItemPosition = ""
	Local $Collected = 0
	Local $aResults = GetFreeMagic()
	Local $aGem[3]

	For $t = 0 To UBound($aResults) - 1
		$aGem[$t] = $aResults[$t][0]
	Next
	For $i = 0 To UBound($aResults) - 1
		$ItemPosition = $i + 1
		If Not $bTest Then
			If $aResults[$i][0] = "FREE" Then
				Click($aResults[$i][1], $aResults[$i][2])
				If _Sleep(Random(3000, 4000, 1)) Then Return
				If isGemOpen(True) Then
					SetLog("Free Magic Item Collect Fail! Gem Window popped up!", $COLOR_ERROR)
				EndIf
				SetLog("Free Magic Item Detected On Slot #" & $ItemPosition & "", $COLOR_INFO)
				If WaitforPixel($aOcrPositions[$i][0] + 25, $aOcrPositions[$i][1] - 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] - 25, "AD590D", 10, 1) Then
					SetLog("Free Magic Item Collected On Slot #" & $ItemPosition & "", $COLOR_SUCCESS)
					$aGem[$i] = "Collected"
					If _Sleep(1500) Then Return
					$Collected += 1
				EndIf
			ElseIf $aResults[$i][0] = "FreeFull" Then
				SetLog("Free Magic Item Detected On Slot #" & $ItemPosition & "", $COLOR_INFO)
				SetLog("But Item Can't be Collected, Stock is Full", $COLOR_INFO)
				$aGem[$i] = "Full"
			ElseIf $aResults[$i][0] = "Full" Then
				$aGem[$i] = "Full"
			ElseIf $aResults[$i][0] = "SoldOut" Then
				SetLog("Free Magic Item Detected On Slot #" & $ItemPosition & "", $COLOR_INFO)
				SetLog("But Item Out Of Stock", $COLOR_INFO)
				$aGem[$i] = "Sold Out"
				If _Sleep(Random(2000, 4000, 1)) Then Return
			EndIf
		EndIf
		If Not $g_bRunState Then Return
	Next

	If Not $Collected Then
		SetLog("Nothing free to collect!", $COLOR_INFO)
	EndIf
	SetLog("Daily Discounts: " & $aGem[0] & " | " & $aGem[1] & " | " & $aGem[2])

	ClickAway()
	If _Sleep(1000) Then Return
EndFunc   ;==>CollectFreeMagicItems

Func GetFreeMagic()
	Local $aOcrPositions[3][2] = [[270, 350], [480, 350], [690, 350]]
	Local $aClickFreeItemPositions[3][2] = [[305, 280], [512, 280], [723, 280]]
	Local $aResults[0][3]

	For $i = 0 To UBound($aOcrPositions) - 1

		Local $Read = getOcrAndCapture("coc-freemagicitems", $aOcrPositions[$i][0], $aOcrPositions[$i][1], 60, 25, True)
		If $Read = "FREE" Then
			If WaitforPixel($aOcrPositions[$i][0] + 25, $aOcrPositions[$i][1] - 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] - 25, "AD590D", 10, 1) Then
				$Read = "SoldOut"
			EndIf
			If WaitforPixel($aOcrPositions[$i][0] + 33, $aOcrPositions[$i][1] + 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] + 31, "969696", 10, 1) Then
				$Read = "FreeFull"
			EndIf
		EndIf
		If $Read = "" Then $Read = "N/A"
		If Number($Read) > 10 Then
			$Read = $Read & " Gems"
			If WaitforPixel($aOcrPositions[$i][0] + 33, $aOcrPositions[$i][1] + 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] + 31, "b4b4b4", 10, 1) Then
				$Read = "Full"
			EndIf
		EndIf
		_ArrayAdd($aResults, $Read & "|" & $aClickFreeItemPositions[$i][0] & "|" & $aClickFreeItemPositions[$i][1])
	Next
	Return $aResults
EndFunc   ;==>GetFreeMagic
