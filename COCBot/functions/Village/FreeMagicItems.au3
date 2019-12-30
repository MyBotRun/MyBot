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

	ClickP($aAway, 1, 0, "#0332") ;Click Away

	If Not IsMainPage() Then Return

	SetLog("Collecting Free Magic Items", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return

	; Check Trader Icon on Main Village
	
	If QuickMIS("BC1", $g_sImgTrader, 120, 160, 210, 215, True, False) Then
		SetLog("Trader available, Entering Daily Discounts", $COLOR_SUCCESS)
		Click($g_iQuickMISX + 120, $g_iQuickMISY + 160)
		If _Sleep(1500) Then Return
	Else
		SetLog("Trader unavailable", $COLOR_INFO)
		Return
	EndIf

	; Check Daily Discounts Window
	If Not QuickMIS("BC1", $g_sImgDailyDiscountWindow, 310, 175, 375, 210, True, False) Then
		ClickP($aAway, 1, 0, "#0332") ;Click Away
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
					ClickP($aAway, 2, 0, "#0332") ;Click Away
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
	ClickP($aAway, 2, 0, "#0332") ;Click Away
	If _Sleep(1000) Then Return
EndFunc   ;==>CollectFreeMagicItems
