; #FUNCTION# ====================================================================================================================
; Name ..........: Collect Free Magic Items from trader
; Description ...:
; Syntax ........: CollectFreeMagicItems()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018)
; Modified ......: Moebius14 (09-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
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
	If Not OpenTraderWindow() Then Return

	If Not $g_bRunState Then Return

	$iLastTimeChecked[$g_iCurAccount] = @MDAY

	Local $aOcrPositions[3][2] = [[275, 357], [480, 357], [685, 357]]
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
				If WaitforPixel($aOcrPositions[$i][0] + 25, $aOcrPositions[$i][1] - 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] - 25, "AD590D", 15, 1) Then
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
	Local $aOcrPositions[3][2] = [[275, 357], [480, 357], [685, 357]]
	Local $aClickFreeItemPositions[3][2] = [[305, 280], [512, 280], [723, 280]]
	Local $aResults[0][3]

	For $i = 0 To UBound($aOcrPositions) - 1

		Local $Read = getOcrAndCapture("coc-freemagicitems", $aOcrPositions[$i][0], $aOcrPositions[$i][1], 60, 25, True)
		If $Read = "FREE" Then
			If WaitforPixel($aOcrPositions[$i][0] + 25, $aOcrPositions[$i][1] - 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] - 25, "AD590D", 15, 1) Then
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

Func OpenTraderWindow()
	Local $Found = False
	For $i = 1 To 5
		If QuickMIS("BC1", $g_sImgTrader, 90, 100 + $g_iMidOffsetY, 210, 210 + $g_iMidOffsetY) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(1500) Then Return
			$Found = True
			ExitLoop
		EndIf
		If _Sleep(1000) Then Return
	Next
	If Not $Found Then
		SetLog("Trader unavailable", $COLOR_INFO)
		SetLog("Bot will recheck next loop", $COLOR_OLIVE)
		Return False
	Else
		Local $aIsWeekyDealsOpen[4] = [40, 0, 0x8DC11D, 20]
		If _CheckPixel($aReceivedTroopsWeeklyDeals, True) Then ; Found the "You have received" Message on Screen, wait till its gone.
			SetDebugLog("Detected Clan Castle Message Blocking Gems Button. Waiting until it's gone", $COLOR_INFO)
			_CaptureRegion2()
			Local $Safetyexit = 0
			While _CheckPixel($aReceivedTroopsWeeklyDeals, True)
				If _Sleep($DELAYTRAIN1) Then Return
				$Safetyexit += 1
				If $Safetyexit > 60 Then ExitLoop  ;If waiting longer than 1 min, something is wrong
			WEnd
		EndIf
		Local $aTabButton = findButton("WeeklyDeals", Default, 1, True)
		If IsArray($aTabButton) And UBound($aTabButton, 1) = 2 Then
			$aIsWeekyDealsOpen[1] = $aTabButton[1]
			If Not _CheckPixel($aIsWeekyDealsOpen, True) Then 
				ClickP($aTabButton)
				If Not _WaitForCheckPixel($aIsWeekyDealsOpen, True) Then
					SetLog("Error : Cannot open Gems Menu. Pixel to check did not appear", $COLOR_ERROR)
					CloseWindow()
					Return FuncReturn(SetError(1, 0, False), $g_bDebugSetlog)
				EndIf
			EndIf
		Else
			SetDebugLog("Error when opening Gems Menu: $aTabButton is no valid Array", $COLOR_ERROR)
			CloseWindow()
			Return FuncReturn(SetError(1, 0, False), $g_bDebugSetlog)
		EndIf
	EndIf

	Local $aiDailyDiscount = decodeSingleCoord(findImage("DailyDiscount", $g_sImgDailyDiscountWindow, GetDiamondFromRect("420,105,510,155"), 1, True, Default))
	If Not IsArray($aiDailyDiscount) Or UBound($aiDailyDiscount, 1) < 1 Then
		CloseWindow()
		Return False
	EndIf

	Return True
EndFunc   ;==>OpenTraderWindow
