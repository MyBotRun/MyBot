; #FUNCTION# ====================================================================================================================
; Name ..........: Boost a troop to super troop
; Description ...:
; Syntax ........: BoostSuperTroop()
; Parameters ....:
; Return values .:
; Author ........: xbebenk (08/2021)
; Modified ......: Moebius14 (10/2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BoostSuperTroop($bTest = False)

	Local $bRet = False

	If Not $g_bSuperTroopsEnable Then Return $bRet

	If $g_iCommandStop = 0 Or $g_iCommandStop = 3 Then ;halt attack.. do not boost now
		If $g_bSkipBoostSuperTroopOnHalt Then
			SetLog("BoostSuperTroop() skipped, account on halt attack mode", $COLOR_DEBUG)
			Return $bRet
		EndIf
	EndIf

	If OpenBarrel($bTest) Then
		Local $iRow = 1

		For $i = 0 To 1

			If Not $g_bRunState Then Return

			Local $iPicsPerRow = 4, $picswidth = 160, $picspad = 18
			Local $columnStart = 80, $iColumnY1 = 305 + $g_iMidOffsetY, $iColumnY2 = 465 + $g_iMidOffsetY

			If $g_iCmbSuperTroops[$i] > 0 Then

				If _Sleep(1000) Then Return
				Local $sTroopName = GetSTroopName($g_iCmbSuperTroops[$i] - 1)
				SetLog("Trying to boost " & $sTroopName, $COLOR_INFO)

				Local $iColumnX = $columnStart
				Select
					Case $g_iCmbSuperTroops[$i] = 2 Or $g_iCmbSuperTroops[$i] = 6 Or $g_iCmbSuperTroops[$i] = 10 Or $g_iCmbSuperTroops[$i] = 14 ;second column
						$iColumnX = $columnStart + (1 * ($picswidth + $picspad))
					Case $g_iCmbSuperTroops[$i] = 3 Or $g_iCmbSuperTroops[$i] = 7 Or $g_iCmbSuperTroops[$i] = 11 Or $g_iCmbSuperTroops[$i] = 15 ;third column
						$iColumnX = $columnStart + (2 * ($picswidth + $picspad))
					Case $g_iCmbSuperTroops[$i] = 4 Or $g_iCmbSuperTroops[$i] = 8 Or $g_iCmbSuperTroops[$i] = 12 Or $g_iCmbSuperTroops[$i] = 16 ;fourth column
						$iColumnX = $columnStart + (3 * ($picswidth + $picspad))
				EndSelect

				Local $iRowTarget = Ceiling($g_iCmbSuperTroops[$i] / $iPicsPerRow) ; get row Stroop
				SetDebugLog("$iRowTarget = " & $iRowTarget & " , $iRow = " & $iRow, $COLOR_DEBUG)
				StroopNextPage($iRowTarget, $iRow) ; go to the needed Row
				If _Sleep(1500) Then Return

				If $iRow = 4 Then ; for last row, we cannot scroll it to middle page
					$iColumnY1 = 400 + $g_iMidOffsetY
					$iColumnY2 = 560 + $g_iMidOffsetY
				EndIf

				If QuickMIS("BC1", $g_sImgBoostTroopsClock, $iColumnX, $iColumnY1, $iColumnX + $picswidth, $iColumnY2, True, False) Then ;find pics Clock on spesific row / column (if clock found = troops already boosted)
					SetLog($sTroopName & ", Troops Already boosted", $COLOR_INFO)
					SetDebugLog("Found Clock Image", $COLOR_DEBUG)
				Else
					SetDebugLog("Clock Image Not Found", $COLOR_DEBUG)
					SetLog($sTroopName & ", Currently is not boosted", $COLOR_INFO)
					If FindStroopIcons($g_iCmbSuperTroops[$i], $iColumnX, $iColumnY1, $iColumnX + $picswidth, $iColumnY2) Then
						If QuickMIS("BC1", $g_sImgBoostTroopsIcons, $iColumnX, $iColumnY1, $iColumnX + $picswidth, $iColumnY2, True, False) Then ;find pics of Stroop on spesific row / column
							Click($g_iQuickMISX, $g_iQuickMISY, 1)
							If _Sleep(1500) Then Return
							If $g_bSuperTroopsBoostUsePotionFirst Then
								Setlog("Using Super Potion...", $COLOR_INFO)
								If QuickMIS("BC1", $g_sImgBoostTroopsPotion, 500, 530 + $g_iMidOffsetY, 535, 570 + $g_iMidOffsetY, True, False) Then ;find image of Super Potion
									Click($g_iQuickMISX - 50, $g_iQuickMISY - 10, 1)
									If _Sleep(1500) Then Return
									If Not isGemOpen(True) Then
										If QuickMIS("BC1", $g_sImgBoostTroopsPotion, 430, 440 + $g_iMidOffsetY, 500, 500 + $g_iMidOffsetY, True, False) Then ;find image of Super Potion button again (confirm upgrade)
											;Click boost
											If $bTest Then
												CancelBoost("Using Potion")
											Else
												Click($g_iQuickMISX - 40, $g_iQuickMISY, 1)
												Setlog("Using Potion, Successfully Boost " & $sTroopName, $COLOR_SUCCESS)
												$bRet = True
											EndIf
										Else
											Setlog("Could not find Potion button for final upgrade " & $sTroopName, $COLOR_ERROR)
											CloseWindow()
										EndIf
									EndIf
								Else ;try to use dark elixir because potion not found
									If _Sleep(1500) Then Return
									Setlog("Cannot Find Potion, Using Dark Elixir...", $COLOR_INFO)
									If QuickMIS("BC1", $g_sImgBoostTroopsButtons, 670, 530 + $g_iMidOffsetY, 700, 570 + $g_iMidOffsetY) Then ;find image of dark elixir button
										Click($g_iQuickMISX - 55, $g_iQuickMISY, 1)
										If _Sleep(1500) Then Return
										If Not isGemOpen(True) Then
											If QuickMIS("BC1", $g_sImgBoostTroopsButtons, 470, 450 + $g_iMidOffsetY, 515, 495 + $g_iMidOffsetY) Then ;find image of dark elixir button again (confirm upgrade)
												;Click boost
												If $bTest Then
													CancelBoost("Using Dark Elixir")
												Else
													Click($g_iQuickMISX - 70, $g_iQuickMISY, 1)
													Setlog("Using Dark Elixir, Successfully Boost " & $sTroopName, $COLOR_SUCCESS)
													$bRet = True
												EndIf
											Else
												Setlog("Could not find dark elixir button for final upgrade " & $sTroopName, $COLOR_ERROR)
												CloseWindow()
											EndIf
										Else
											SetLog("Not Enough Dark Elixir To Boost Super Troop", $COLOR_ERROR)
											If _Sleep(1500) Then Return
										EndIf
									Else
										Setlog("Could not find dark elixir button for upgrade " & $sTroopName, $COLOR_ERROR)
									EndIf
								EndIf
							Else
								Setlog("Using Dark Elixir...", $COLOR_INFO)
								If QuickMIS("BC1", $g_sImgBoostTroopsButtons, 670, 530 + $g_iMidOffsetY, 700, 570 + $g_iMidOffsetY) Then ;find image of dark elixir button
									Click($g_iQuickMISX - 55, $g_iQuickMISY, 1)
									If _Sleep(1500) Then Return
									If Not isGemOpen(True) Then
										If QuickMIS("BC1", $g_sImgBoostTroopsButtons, 470, 450 + $g_iMidOffsetY, 515, 495 + $g_iMidOffsetY) Then ;find image of dark elixir button again (confirm upgrade)
											;Click boost
											If $bTest Then
												CancelBoost("Using Dark Elixir")
											Else
												Click($g_iQuickMISX - 70, $g_iQuickMISY, 1)
												Setlog("Successfully Boost " & $sTroopName, $COLOR_SUCCESS)
												$bRet = True
											EndIf
										Else
											Setlog("Could not find dark elixir button for final upgrade " & $sTroopName, $COLOR_ERROR)
											CloseWindow()
										EndIf
									Else
										SetLog("Not Enough Dark Elixir To Boost Super Troop", $COLOR_ERROR)
										If _Sleep(1500) Then Return
									EndIf
								Else
									Setlog("Could not find dark elixir button for upgrade " & $sTroopName, $COLOR_ERROR)
								EndIf
							EndIf
						Else
							Setlog("Cannot find " & $sTroopName & ", Troop Not Unlocked yet?", $COLOR_ERROR)
						EndIf
					Else
						SetLog("Double Check Image for Icon " & $sTroopName & " Not Found", $COLOR_ERROR)
						SetLog("Troop Not Unlocked yet?", $COLOR_ERROR)
					EndIf
				EndIf
			EndIf
		Next
		If _Sleep(1500) Then Return
		CloseWindow()
	EndIf ;open barrel
	Return $bRet
EndFunc   ;==>BoostSuperTroop

Func OpenBarrel($bTest = False)

	If QuickMIS("BC1", $g_sImgBoostTroopsBarrel, 30, 90 + $g_iMidOffsetY, 180, 240 + $g_iMidOffsetY) Then

		Local $aSearchForProgress = 0
		Local $iSTCount = 0, $bOpenBarrel = True, $bRet = False
		Local $aiSearchNoBoost[4] = [$g_iQuickMISX - 10, $g_iQuickMISY - 10, $g_iQuickMISX + 25, $g_iQuickMISY + 35]
		Local $aiSearchArrayLower[4] = [$g_iQuickMISX - 7, $g_iQuickMISY - 25, $g_iQuickMISX + 20, $g_iQuickMISY - 18]
		Local $aiSearchArrayUpper[4] = [$g_iQuickMISX - 7, $g_iQuickMISY - 39, $g_iQuickMISX + 20, $g_iQuickMISY - 32]
		Local $aiSearchArrayThird[4] = [$g_iQuickMISX - 7, $g_iQuickMISY - 53, $g_iQuickMISX + 20, $g_iQuickMISY - 46]
		Local $BarrelStoppedLoop = 0

		For $i = 0 To 5 ; To Detect Stopped Barrel even with animation.
			If QuickMIS("BC1", $g_sImgBarrelStopped, $aiSearchNoBoost[0], $aiSearchNoBoost[1], $aiSearchNoBoost[2], $aiSearchNoBoost[3]) Then $BarrelStoppedLoop += 1
			If $BarrelStoppedLoop > 0 Then ExitLoop
			If _Sleep(200) Then Return
		Next

		If $BarrelStoppedLoop > 0 Then
			SetLog("No Troop Currently Boosted", $COLOR_INFO)
		Else
			If WaitforPixel($aiSearchArrayLower[0], $aiSearchArrayLower[1], $aiSearchArrayLower[2], $aiSearchArrayLower[3], "E6E8DD", 25, 2) Then $aSearchForProgress += 1
			If WaitforPixel($aiSearchArrayUpper[0], $aiSearchArrayUpper[1], $aiSearchArrayUpper[2], $aiSearchArrayUpper[3], "E6E8DD", 25, 2) Then $aSearchForProgress += 1
			If WaitforPixel($aiSearchArrayThird[0], $aiSearchArrayThird[1], $aiSearchArrayThird[2], $aiSearchArrayThird[3], "E6E8DD", 25, 2) Then $aSearchForProgress += 1
		EndIf

		SetDebugLog("Progress Bar Found : " & $aSearchForProgress, $COLOR_DEBUG)
		If $bTest Then SetLog("Progress Bar Found : " & $aSearchForProgress, $COLOR_DEBUG)

		If Number($aSearchForProgress) > 0 Then

			If Number($aSearchForProgress) >= $iMaxSupersTroop Then ;When 2 troops already boosted. (3 while an event ?)
				SetLog("Max Number Of Troops Already Boosted", $COLOR_INFO)
				If Not $bTest Then Return False
			EndIf

			; Reset
			$iSTCount = 0
			For $i = 0 To 1
				If $g_iCmbSuperTroops[$i] > 0 Then $iSTCount += 1
			Next

			If $iSTCount = Number($aSearchForProgress) Then
				If $g_bFirstStartBarrel Then ;First Start to check if the selected troop <> boosted troop
					$bOpenBarrel = True
					$g_bFirstStartBarrel = 0
				Else
					SetLog("Troop Already boosted", $COLOR_INFO)
					$bOpenBarrel = False
				EndIf
			Else
				$bOpenBarrel = True ;Open in other cases.
			EndIf
		EndIf

		If $bTest Then $bOpenBarrel = True

		If $bOpenBarrel Then
			SetLog("Found Barrel !", $COLOR_SUCCESS1)
			SetDebugLog("At " & $g_iQuickMISX & "," & $g_iQuickMISY, $COLOR_DEBUG)
			Click($g_iQuickMISX, $g_iQuickMISY, 1)
			If _Sleep(1000) Then Return
			For $i = 1 To 10
				If QuickMIS("BC1", $g_sImgBoostTroopsWindow, 380, 85 + $g_iMidOffsetY, 480, 180 + $g_iMidOffsetY, True, False) Then
					SetDebugLog("Detected SuperTroops Window Image At " & $g_iQuickMISX & "," & $g_iQuickMISY, $COLOR_DEBUG)
					$bRet = True
					ExitLoop
				EndIf
				If _Sleep(200) Then Return
			Next
			If $bRet Then
				Return True
			Else
				SetLog("Couldn't find Super Troop Window", $COLOR_ERROR)
				ClickAway()
			EndIf
		EndIf
	Else
		SetLog("Couldn't Find Super Troop Barrel", $COLOR_ERROR)
		ClickAway()
	EndIf
	Return False

EndFunc   ;==>OpenBarrel

Func StroopNextPage($iRowTarget, ByRef $iRow)
	Local $iXMidPoint

	While 1

		$iXMidPoint = Random(360, 520, 1)

		If $iRow < $iRowTarget Then
			ClickDrag($iXMidPoint, 480 + $g_iMidOffsetY, $iXMidPoint, 300 + $g_iMidOffsetY, 500)
			$iRow += 1
		EndIf

		If $iRow > $iRowTarget Then
			If $iRow = 4 Then
				ClickDrag($iXMidPoint, 350 + $g_iMidOffsetY, $iXMidPoint, 450 + $g_iMidOffsetY, 500)
			Else
				ClickDrag($iXMidPoint, 255 + $g_iMidOffsetY, $iXMidPoint, 430 + $g_iMidOffsetY, 500)
			EndIf
			$iRow -= 1
		EndIf

		If $iRow = $iRowTarget Then ExitLoop

		If _Sleep(1000) Then Return

	WEnd

EndFunc   ;==>StroopNextPage

Func GetSTroopName(Const $iIndex)
	Return $g_asSuperTroopNames[$iIndex]
EndFunc   ;==>GetSTroopName

Func FindStroopIcons($iIndex, $iColumnX, $iColumnY1, $iColumnX1, $iColumnY2)
	Local $FullTemp
	$FullTemp = SearchImgloc($g_sImgBoostTroopsIcons, $iColumnX, $iColumnY1, $iColumnX1, $iColumnY2)
	SetDebugLog("Troop SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)
	SetLog("Trying to find " & GetSTroopName($iIndex - 1), $COLOR_DEBUG)
	If StringInStr($FullTemp[0] & " ", "empty") > 0 Then Return

	If $FullTemp[0] <> "" Then
		Local $iFoundTroopIndex = TroopIndexLookup($FullTemp[0])
		For $i = $eTroopBarbarian To $eTroopCount - 1
			If $iFoundTroopIndex = $i Then
				SetDebugLog("Detected " & "[" & $iFoundTroopIndex & "] " & $g_asTroopNames[$i], $COLOR_DEBUG)
				If $g_asTroopNames[$i] = GetSTroopName($iIndex - 1) Then Return True
				ExitLoop
			EndIf
			If $i = $eTroopCount - 1 Then ; detection failed
				SetDebugLog("Troop Troop Detection Failed", $COLOR_DEBUG)
			EndIf
		Next
	EndIf
	Return False
EndFunc   ;==>FindStroopIcons

Func CancelBoost($aMessage = "")
	SetLog($aMessage & ", Test = True", $COLOR_DEBUG)
	SetLog(" -- Cancelling", $COLOR_DEBUG)
	CloseWindow()
EndFunc   ;==>CancelBoost
