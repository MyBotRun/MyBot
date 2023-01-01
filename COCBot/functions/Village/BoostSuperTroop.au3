; #FUNCTION# ====================================================================================================================
; Name ..........: Boost a troop to super troop
; Description ...:
; Syntax ........: BoostSuperTroop()
; Parameters ....:
; Return values .:
; Author ........: xbebenk (08/2021)
; Modified ......: Moebius14 (12/2022)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BoostSuperTroop($bTest = False)

	If Not $g_bSuperTroopsEnable Then
		Return False
	EndIf

	If $g_iCommandStop = 0 Or $g_iCommandStop = 3 Then ;halt attack.. do not boost now
		If $g_bSkipBoostSuperTroopOnHalt Then
			SetLog("BoostSuperTroop() skipped, account on halt attack mode", $COLOR_DEBUG)
			Return False
		EndIf
	EndIf

	For $i = 0 To 1
		Local $iPicsPerRow = 4, $picswidth = 125, $picspad = 18
		Local $curRow = 1, $columnStart = 150, $iColumnY1 = 311, $iColumnY2 = 465

		If $g_iCmbSuperTroops[$i] > 0 Then
			If OpenBarrel() Then
				If _Sleep(1000) Then Return
				Local $sTroopName = GetSTroopName($g_iCmbSuperTroops[$i] - 1)
				SetLog("Trying to boost " & $sTroopName, $COLOR_INFO)

				Local $iColumnX = $columnStart
				Select
					Case $g_iCmbSuperTroops[$i] = 2 Or $g_iCmbSuperTroops[$i] = 6 Or $g_iCmbSuperTroops[$i] = 10 Or $g_iCmbSuperTroops[$i] = 14 ;second column
						$iColumnX = $columnStart + (1 * ($picswidth + $picspad))
					Case $g_iCmbSuperTroops[$i] = 3 Or $g_iCmbSuperTroops[$i] = 7 Or $g_iCmbSuperTroops[$i] = 11 Or $g_iCmbSuperTroops[$i] = 15 ;third column
						$iColumnX = $columnStart + (2 * ($picswidth + $picspad))
					Case $g_iCmbSuperTroops[$i] = 4 Or $g_iCmbSuperTroops[$i] = 8 Or $g_iCmbSuperTroops[$i] = 12 ;fourth column
						$iColumnX = $columnStart + (3 * ($picswidth + $picspad))
				EndSelect
				
				Local $iRow = Ceiling($g_iCmbSuperTroops[$i] / $iPicsPerRow) ; get row Stroop
				StroopNextPage($iRow) ; go directly to the needed Row
				
				If $iRow = 4 Then ; for last row, we cannot scroll it to middle page
					$iColumnY1 = 388
					$iColumnY2 = 550
				EndIf

				If QuickMIS("BC1", $g_sImgBoostTroopsClock, $iColumnX, $iColumnY1, $iColumnX + $picswidth, $iColumnY2, True, False) Then ;find pics Clock on spesific row / column (if clock found = troops already boosted)
					SetLog($sTroopName & ", Troops Already boosted", $COLOR_INFO)
					SetDebugLog("Found Clock Image", $COLOR_DEBUG)
					ClickAway()
				Else
					If _Sleep(1500) Then Return
					SetDebugLog("Clock Image Not Found", $COLOR_DEBUG)
					SetLog($sTroopName & ", Currently is not boosted", $COLOR_INFO)
					If FindStroopIcons($g_iCmbSuperTroops[$i], $iColumnX, $iColumnY1, $iColumnX + $picswidth, $iColumnY2) Then
						If QuickMIS("BC1", $g_sImgBoostTroopsIcons, $iColumnX, $iColumnY1, $iColumnX + $picswidth, $iColumnY2, True, False) Then ;find pics of Stroop on spesific row / column
							Click($g_iQuickMISX, $g_iQuickMISY, 1)
							If _Sleep(1000) Then Return
							If $g_bSuperTroopsBoostUsePotionFirst Then
								Setlog("Using Super Potion...", $COLOR_INFO)
								If QuickMIS("BC1", $g_sImgBoostTroopsPotion, 400, 530, 580, 600, True, False) Then ;find image of Super Potion
									Click($g_iQuickMISX, $g_iQuickMISY, 1)
									If _Sleep(1000) Then Return
									If QuickMIS("BC1", $g_sImgBoostTroopsPotion, 330, 430, 520, 510, True, False) Then ;find image of Super Potion again (confirm upgrade)
										;do click boost
										If $bTest Then
											CancelBoost("Using Potion")
											ContinueLoop
										EndIf
										Click($g_iQuickMISX, $g_iQuickMISY, 1)
										Setlog("Using Potion, Successfully Boost " & $sTroopName, $COLOR_SUCCESS)
										ClickAway()
									Else
										Setlog("Could not find Potion button for final upgrade " & $sTroopName, $COLOR_ERROR)
										ClickAway()
										ClickAway()
									EndIf
								Else ;try to use dark elixir because potion not found
									Setlog("Cannot Find Potion, Using Dark Elixir...", $COLOR_INFO)
									If QuickMIS("BC1", $g_sImgBoostTroopsButtons, 600, 530, 750, 600, True, False) Then ;find image of dark elixir button
										Click($g_iQuickMISX, $g_iQuickMISY, 1)
										If _Sleep(1000) Then Return
										If QuickMIS("BC1", $g_sImgBoostTroopsButtons, 320, 430, 550, 510, True, False) Then ;find image of dark elixir button again (confirm upgrade)
											;do click boost
											If $bTest Then
												CancelBoost("Using Dark Elixir")
												ContinueLoop
											EndIf
											Click($g_iQuickMISX, $g_iQuickMISY, 1)
											Setlog("Using Dark Elixir, Successfully Boost " & $sTroopName, $COLOR_SUCCESS)
											ClickAway()
										Else
											Setlog("Could not find dark elixir button for final upgrade " & $sTroopName, $COLOR_ERROR)
											ClickAway()
											ClickAway()
										EndIf
									Else
										Setlog("Could not find dark elixir button for upgrade " & $sTroopName, $COLOR_ERROR)
										ClickAway()
									EndIf
								EndIf
							Else
								Setlog("Using Dark Elixir...", $COLOR_INFO)
								If QuickMIS("BC1", $g_sImgBoostTroopsButtons, 600, 530, 750, 600, True, False) Then ;find image of dark elixir button
									Click($g_iQuickMISX, $g_iQuickMISY, 1)
									If _Sleep(1000) Then Return
									If QuickMIS("BC1", $g_sImgBoostTroopsButtons, 320, 430, 550, 510, True, False) Then ;find image of dark elixir button again (confirm upgrade)
										;do click boost
										If $bTest Then
											CancelBoost("Using Dark Elixir")
											ContinueLoop
										EndIf
										Click($g_iQuickMISX, $g_iQuickMISY, 1)
										Setlog("Successfully Boost " & $sTroopName, $COLOR_SUCCESS)
										ClickAway()
									Else
										Setlog("Could not find dark elixir button for final upgrade " & $sTroopName, $COLOR_ERROR)
										ClickAway()
										ClickAway()
									EndIf
								Else
									Setlog("Could not find dark elixir button for upgrade " & $sTroopName, $COLOR_ERROR)
									ClickAway()
								EndIf
							EndIf
						Else
							Setlog("Cannot find " & $sTroopName & ", Troop Not Unlocked yet?", $COLOR_ERROR)
							ClickAway()
						EndIf
					Else
						SetLog("Double Check Image for Icon " & $sTroopName & " Not Found", $COLOR_ERROR)
						SetLog("Troop Not Unlocked yet?", $COLOR_ERROR)
					EndIf
				EndIf
			EndIf ;open barrel
		EndIf
		If _Sleep(1000) Then Return
		$curRow = 1
	Next
	ClickAway()
	Return False
EndFunc   ;==>BoostSuperTroop

Func OpenBarrel()
	ClickAway()
	Local $iSTCount = 0, $bOpenBarrel = True
	If QuickMIS("BC1", $g_sImgBoostTroopsBarrel, 0, 0, 220, 235, True, False) Then
		; Check if is already boosted.
		Local $aiSearchArray[4] = [$g_iQuickMISX - 16, $g_iQuickMISY - 31, $g_iQuickMISX - 3, $g_iQuickMISY - 10]
		Local $aSearchForProgress = decodeMultipleCoords(findImage("SuperTroopProgress", $g_sImgSTProgress, GetDiamondFromRect($aiSearchArray), 0, True, Default))
		
		If IsArray($aSearchForProgress) And UBound($aSearchForProgress, 1) > 0 Then
		
			If UBound($aSearchForProgress, 1) = $iMaxSupersTroop Then ;When 2 troops already boosted.
				SetLog("Max Number of Troops Already boosted", $COLOR_INFO)
				$g_bMaxNbrSTroops[$g_iCurAccount] = True
				Return False
			EndIf
			
			If $g_bMaxNbrSTroops[$g_iCurAccount] Then $g_bCheckBarrel[$g_iCurAccount] = True ;When 2 Troops Boosted at start, then 1 ends -> Check.
		
			; Reset
			$iSTCount = 0
			For $i = 0 To 1
				If $g_iCmbSuperTroops[$i] > 0 Then $iSTCount += 1
			Next
			If $iSTCount = UBound($aSearchForProgress, 1) Then
				If $g_bCheckBarrel[$g_iCurAccount] Then ; First Start Or when 2 troops at start the 1 ends.
					$bOpenBarrel = True
					$g_bCheckBarrel[$g_iCurAccount] = False
				Else	
					SetLog("Troops Already boosted", $COLOR_INFO)
					$bOpenBarrel = False
				EndIf
			Else
				$bOpenBarrel = True ;Open in other cases.
			EndIf
		EndIf
		
		If $bOpenBarrel Then
			SetLog("Found Barrel at " & $g_iQuickMISX & "," & $g_iQuickMISY, $COLOR_SUCCESS1)
			Click($g_iQuickMISX, $g_iQuickMISY, 1)
			Return True
		EndIf
	Else
		SetLog("Couldn't Find Super Troop Barrel", $COLOR_ERROR)
		ClickAway()
	EndIf
	Return False

EndFunc   ;==>OpenBarrel

Func StroopNextPage($iRow)
	Local $iXMidPoint = 425
	SetDebugLog("Goto Row: " & $iRow, $COLOR_DEBUG)
	For $i = 1 To $iRow - 1
		ClickDrag($iXMidPoint, 280, $iXMidPoint, 95, 500)
		If _Sleep(1000) Then Return
	Next
EndFunc   ;==>StroopNextPage

Func GetSTroopName(Const $iIndex)
	Return $g_asSuperTroopNames[$iIndex]
EndFunc   ;==>GetSTroopName

Func FindStroopIcons($iIndex, $iColumnX, $iColumnY1, $iColumnX1, $iColumnY2)

	Local $FullTemp
	$FullTemp = SearchImgloc($g_sImgBoostTroopsIcons, $iColumnX, $iColumnY1, $iColumnX1, $iColumnY2)
	SetDebugLog("Troop SearchImgloc returned:" & $FullTemp[0] & ".", $COLOR_DEBUG)
	SetLog("Trying to find" & "[" & $iIndex & "] " & GetSTroopName($iIndex - 1), $COLOR_DEBUG)
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
	SetLog("Emulate Click(" & $g_iQuickMISX & "," & $g_iQuickMISY & ") -- Cancelling", $COLOR_DEBUG)
	ClickAway()
	ClickAway()
	ClickAway()
	If _Sleep(1000) Then Return
EndFunc   ;==>CancelBoost








