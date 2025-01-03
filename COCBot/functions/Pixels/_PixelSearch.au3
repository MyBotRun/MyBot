
; #FUNCTION# ====================================================================================================================
; Name ..........: _PixelSearch
; Description ...: PixelSearch a certain region, works for memory BMP
; Syntax ........: _PixelSearch($iLeft, $iTop, $iRight, $iBottom, $sColor, $iColorVariation)
; Parameters ....: $iLeft               - an integer value.
;                  $iTop                - an integer value.
;                  $iRight              - an integer value.
;                  $iBottom             - an integer value.
;                  $sColor              - an string value with hex color to search
;                  $iColorVariation     - an integer value.
;                  $bNeedCapture        - [optional] a boolean flag to get new screen capture, when False full screen must have been captured wuth _CaptureRegion() !!!
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _PixelSearch($iLeft, $iTop, $iRight, $iBottom, $sColor, $iColorVariation, $bNeedCapture = True)
	Local $x1, $x2, $y1, $y2
	If $bNeedCapture = True Then
		_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
		$x1 = $iRight - $iLeft
		$x2 = 0
		$y1 = 0
		$y2 = $iBottom - $iTop
	Else
		$x1 = $iRight
		$x2 = $iLeft
		$y1 = $iTop
		$y2 = $iBottom
	EndIf
	For $x = $x1 To $x2 Step -1
		For $y = $y1 To $y2
			If _ColorCheck(_GetPixelColor($x, $y), $sColor, $iColorVariation) Then
				Local $Pos[2] = [$iLeft + $x - $x2, $iTop + $y - $y1]
				Return $Pos
			EndIf
		Next
	Next
	Return 0
EndFunc   ;==>_PixelSearch

Func WaitForClanMessage($bType, $bTopCoords = 0, $bBottomCoords = 0)
	Switch $bType
		Case "DonatedTroops"
			If IsArray(_PixelSearch($aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1], $aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1] + $aReceivedTroopsOCR[4], Hex($aReceivedTroopsOCR[2], 6), $aReceivedTroopsOCR[3], True)) Then
				SetDebugLog("Detected Clan Castle Message Blocking Troop Count. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1], $aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1] + $aReceivedTroopsOCR[4], Hex($aReceivedTroopsOCR[2], 6), $aReceivedTroopsOCR[3], True))
					If _Sleep($DELAYRUNBOT1) Then Return
					$Safetyexit += 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
				If _Sleep($DELAYRUNBOT1) Then Return
			EndIf
		Case "TrainTabs"
			If IsArray(_PixelSearch($aReceivedTroopsDouble[0], $aReceivedTroopsDouble[1], $aReceivedTroopsDouble[0], $aReceivedTroopsDouble[1] + $aReceivedTroopsDouble[4], Hex($aReceivedTroopsDouble[2], 6), $aReceivedTroopsDouble[3], True)) Or _
					IsArray(_PixelSearch($aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1], $aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1] + $aReceivedTroopsOCR[4], Hex($aReceivedTroopsOCR[2], 6), $aReceivedTroopsOCR[3], True)) Then
				SetDebugLog("Detected Clan Castle Message Blocking Troop Count. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroopsDouble[0], $aReceivedTroopsDouble[1], $aReceivedTroopsDouble[0], $aReceivedTroopsDouble[1] + $aReceivedTroopsDouble[4], Hex($aReceivedTroopsDouble[2], 6), $aReceivedTroopsDouble[3], True)) Or _
						IsArray(_PixelSearch($aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1], $aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1] + $aReceivedTroopsOCR[4], Hex($aReceivedTroopsOCR[2], 6), $aReceivedTroopsOCR[3], True))
					If _Sleep($DELAYRUNBOT1) Then Return
					$Safetyexit += 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
				If _Sleep($DELAYRUNBOT1) Then Return
			EndIf
		Case "ArmyOverview"
			If IsArray(_PixelSearch($aReceivedTroops[0], $aReceivedTroops[1], $aReceivedTroops[0], $aReceivedTroops[1] + $aReceivedTroops[4], Hex($aReceivedTroops[2], 6), $aReceivedTroops[3], True)) Or _
					IsArray(_PixelSearch($aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1], $aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1] + $aReceivedTroopsOCR[4], Hex($aReceivedTroopsOCR[2], 6), $aReceivedTroopsOCR[3], True)) Then
				SetDebugLog("Detected Clan Castle Message Blocking Troop Images. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroops[0], $aReceivedTroops[1], $aReceivedTroops[0], $aReceivedTroops[1] + $aReceivedTroops[4], Hex($aReceivedTroops[2], 6), $aReceivedTroops[3], True)) Or _
						IsArray(_PixelSearch($aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1], $aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1] + $aReceivedTroopsOCR[4], Hex($aReceivedTroopsOCR[2], 6), $aReceivedTroopsOCR[3], True))
					If _Sleep($DELAYRUNBOT1) Then Return
					$Safetyexit += 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
				If _Sleep($DELAYRUNBOT1) Then Return
			EndIf
		Case "SuperTroops"
			If IsArray(_PixelSearch($aBoostTroopsWindow[0], $aBoostTroopsWindow[1], $aBoostTroopsWindow[0], $aBoostTroopsWindow[1] + $aBoostTroopsWindow[4], Hex($aBoostTroopsWindow[2], 6), $aBoostTroopsWindow[3], True)) Then
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aBoostTroopsWindow[0], $aBoostTroopsWindow[1], $aBoostTroopsWindow[0], $aBoostTroopsWindow[1] + $aBoostTroopsWindow[4], Hex($aBoostTroopsWindow[2], 6), $aBoostTroopsWindow[3], True))
					If _Sleep($DELAYRUNBOT1) Then Return
					$Safetyexit += 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
				If _Sleep($DELAYRUNBOT1) Then Return
			EndIf
		Case "WeeklyDeals"
			If IsArray(_PixelSearch($aReceivedTroopsWeeklyDeals[0], $aReceivedTroopsWeeklyDeals[1], $aReceivedTroopsWeeklyDeals[0], $aReceivedTroopsWeeklyDeals[1] + $aReceivedTroopsWeeklyDeals[4], Hex($aReceivedTroopsWeeklyDeals[2], 6), $aReceivedTroopsWeeklyDeals[3], True)) Then
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroopsWeeklyDeals[0], $aReceivedTroopsWeeklyDeals[1], $aReceivedTroopsWeeklyDeals[0], $aReceivedTroopsWeeklyDeals[1] + $aReceivedTroopsWeeklyDeals[4], Hex($aReceivedTroopsWeeklyDeals[2], 6), $aReceivedTroopsWeeklyDeals[3], True))
					If _Sleep($DELAYRUNBOT1) Then Return
					$Safetyexit += 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
			EndIf
		Case "Treasury"
			If IsArray(_PixelSearch($aReceivedTroopsTreasury[0], $aReceivedTroopsTreasury[1], $aReceivedTroopsTreasury[0], $aReceivedTroopsTreasury[1] + $aReceivedTroopsTreasury[4], Hex($aReceivedTroopsTreasury[2], 6), $aReceivedTroopsTreasury[3], True)) Then
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroopsTreasury[0], $aReceivedTroopsTreasury[1], $aReceivedTroopsTreasury[0], $aReceivedTroopsTreasury[1] + $aReceivedTroopsTreasury[4], Hex($aReceivedTroopsTreasury[2], 6), $aReceivedTroopsTreasury[3], True))
					If _Sleep($DELAYRUNBOT1) Then Return
					$Safetyexit += 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
				If _Sleep($DELAYRUNBOT1) Then Return
			EndIf
		Case "Tabs"
			If IsArray(_PixelSearch($aReceivedTroopsTab[0], $aReceivedTroopsTab[1], $aReceivedTroopsTab[0], $aReceivedTroopsTab[1] + $aReceivedTroopsTab[4], Hex($aReceivedTroopsTab[2], 6), $aReceivedTroopsTab[3], True)) Then
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroopsTab[0], $aReceivedTroopsTab[1], $aReceivedTroopsTab[0], $aReceivedTroopsTab[1] + $aReceivedTroopsTab[4], Hex($aReceivedTroopsTab[2], 6), $aReceivedTroopsTab[3], True))
					If _Sleep($DELAYRUNBOT1) Then Return
					$Safetyexit += 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
				If _Sleep($DELAYRUNBOT1) Then Return
			EndIf
		Case "BuildersApprenticeTop"
			If IsArray(_PixelSearch($aBuidersAppWindowTop[0], $aBuidersAppWindowTop[1], $aBuidersAppWindowTop[0], $aBuidersAppWindowTop[1] + $aBuidersAppWindowTop[4], Hex($aBuidersAppWindowTop[2], 6), $aBuidersAppWindowTop[3], True)) Then
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aBuidersAppWindowTop[0], $aBuidersAppWindowTop[1], $aBuidersAppWindowTop[0], $aBuidersAppWindowTop[1] + $aBuidersAppWindowTop[4], Hex($aBuidersAppWindowTop[2], 6), $aBuidersAppWindowTop[3], True))
					If _Sleep($DELAYRUNBOT1) Then Return
					$Safetyexit += 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
			EndIf
		Case "BuildersApprenticeMid"
			If IsArray(_PixelSearch($aBuidersAppWindowMid[0], $aBuidersAppWindowMid[1], $aBuidersAppWindowMid[0], $aBuidersAppWindowMid[1] + $aBuidersAppWindowMid[4], Hex($aBuidersAppWindowMid[2], 6), $aBuidersAppWindowMid[3], True)) Then
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aBuidersAppWindowMid[0], $aBuidersAppWindowMid[1], $aBuidersAppWindowMid[0], $aBuidersAppWindowMid[1] + $aBuidersAppWindowMid[4], Hex($aBuidersAppWindowMid[2], 6), $aBuidersAppWindowMid[3], True))
					If _Sleep($DELAYRUNBOT1) Then Return
					$Safetyexit += 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
				If _Sleep($DELAYRUNBOT1) Then Return
			EndIf
		Case "BuildersApprenticeConfirm"
			If IsArray(_PixelSearch($aBuidersAppWindowConfirm[0], $aBuidersAppWindowConfirm[1], $aBuidersAppWindowConfirm[0], $aBuidersAppWindowConfirm[1] + $aBuidersAppWindowConfirm[4], Hex($aBuidersAppWindowConfirm[2], 6), $aBuidersAppWindowConfirm[3], True)) Then
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aBuidersAppWindowConfirm[0], $aBuidersAppWindowConfirm[1], $aBuidersAppWindowConfirm[0], $aBuidersAppWindowConfirm[1] + $aBuidersAppWindowConfirm[4], Hex($aBuidersAppWindowConfirm[2], 6), $aBuidersAppWindowConfirm[3], True))
					If _Sleep($DELAYRUNBOT1) Then Return
					$Safetyexit += 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
				If _Sleep($DELAYRUNBOT1) Then Return
			EndIf
		Case "ClanGames"
			If $bBottomCoords > 0 Then $aReceivedTroopsCG[4] = Abs($bBottomCoords - $aReceivedTroopsCG[1])
			If IsArray(_PixelSearch($aReceivedTroopsCG[0], $aReceivedTroopsCG[1], $aReceivedTroopsCG[0], $aReceivedTroopsCG[1] + $aReceivedTroopsCG[4], Hex($aReceivedTroopsCG[2], 6), $aReceivedTroopsCG[3], True)) Then
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroopsCG[0], $aReceivedTroopsCG[1], $aReceivedTroopsCG[0], $aReceivedTroopsCG[1] + $aReceivedTroopsCG[4], Hex($aReceivedTroopsCG[2], 6), $aReceivedTroopsCG[3], True))
					If _Sleep($DELAYRUNBOT1) Then Return
					$Safetyexit += 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
				If _Sleep($DELAYRUNBOT1) Then Return
			EndIf
		Case "Donate"
			Local $aReceivedTroopsDonate[5] = [333, 100, 0xFFFFFF, 15, 215]
			If $bTopCoords > 90 Then $aReceivedTroopsDonate[1] = $bTopCoords
			If $bTopCoords > 340 Then Return
			Select
				Case $bTopCoords > 90 And $bBottomCoords = 0
					$aReceivedTroopsDonate[4] = Abs($aReceivedTroopsDonate[4] - ($bTopCoords - 100))
				Case $bTopCoords = 0 And $bBottomCoords > 90
					$aReceivedTroopsDonate[4] = Abs($bBottomCoords - $aReceivedTroopsDonate[1])
				Case $bTopCoords > 90 And $bBottomCoords > 90
					$aReceivedTroopsDonate[4] = $bBottomCoords - $bTopCoords
			EndSelect
			Local $bArrayToSearch = _PixelSearch($aReceivedTroopsDonate[0], $aReceivedTroopsDonate[1], $aReceivedTroopsDonate[0], $aReceivedTroopsDonate[1] + $aReceivedTroopsDonate[4], Hex($aReceivedTroopsDonate[2], 6), $aReceivedTroopsDonate[3], True)
			If IsArray($bArrayToSearch) Then
				If _ColorCheck(_GetPixelColor($bArrayToSearch[0], $bArrayToSearch[1] - 15, True), Hex(0x95C334, 6), 20) And _ColorCheck(_GetPixelColor($bArrayToSearch[0], $bArrayToSearch[1] + 15, True), Hex(0x95C334, 6), 20) Then
					If _Sleep($DELAYRUNBOT1) Then Return
					Return
				EndIf
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroopsDonate[0], $aReceivedTroopsDonate[1], $aReceivedTroopsDonate[0], $aReceivedTroopsDonate[1] + $aReceivedTroopsDonate[4], Hex($aReceivedTroopsDonate[2], 6), $aReceivedTroopsDonate[3], True))
					If _Sleep($DELAYRUNBOT1) Then Return
					If _ColorCheck(_GetPixelColor($bArrayToSearch[0], $bArrayToSearch[1] - 15, True), Hex(0x95C334, 6), 20) And _ColorCheck(_GetPixelColor($bArrayToSearch[0], $bArrayToSearch[1] + 15, True), Hex(0x95C334, 6), 20) Then ExitLoop
					$Safetyexit += 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
				If _Sleep($DELAYRUNBOT1) Then Return
			EndIf
		Case Else
			Return
	EndSwitch
EndFunc   ;==>WaitForClanMessage
