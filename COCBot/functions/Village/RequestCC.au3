; #FUNCTION# ====================================================================================================================
; Name ..........: RequestCC
; Description ...:
; Syntax ........: RequestCC()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: Sardo(06-2015), KnowJack(10-2015), Sardo (08-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func RequestCC($bClickPAtEnd = True, $sText = "")

	If Not $g_bRequestTroopsEnable Or Not $g_bDonationEnabled Then
		Return
	EndIf

	If Not $g_bRunState Then Return

	If $g_bRequestTroopsEnable Then
		Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		If Not $g_abRequestCCHours[$hour[0]] Then
			SetLog("Request Clan Castle troops not planned, Skipped..", $COLOR_ACTION)
			Return ; exit func if no planned donate checkmarks
		EndIf
	EndIf

	;open army overview
	If $sText <> "IsFullClanCastle" And Not OpenArmyOverview(True, "RequestCC()") Then Return

	If _Sleep($DELAYREQUESTCC1) Then Return
	SetLog("Requesting Clan Castle reinforcements", $COLOR_INFO)
	If $bClickPAtEnd Then CheckCCArmy()

	If Not $g_bRunState Then Return
	If _Sleep(1000) Then Return

	Local $sSearchDiamond = GetDiamondFromRect("673,553,740,583")
	Local Static $aRequestButtonPos[2] = [-1, -1]

	Local $aRequestButton = findMultiple($g_sImgRequestCCButton, $sSearchDiamond, $sSearchDiamond, 0, 1000, 1, "objectname,objectpoints", True)
	If Not IsArray($aRequestButton) Then
		SetLog("Error in RequestCC(): $aRequestButton is no Array")
		If $g_bDebugImageSave Then SaveDebugImage("RequestButtonStateError")
		Return
	EndIf

	If Not $g_bRunState Then Return

	If UBound($aRequestButton, 1) >= 1 Then
		Local $sButtonState
		Local $aRequestButtonSubResult = $aRequestButton[0]
		$sButtonState = $aRequestButtonSubResult[0]
		If $aRequestButtonPos[0] = -1 Then
			$aRequestButtonPos = StringSplit($aRequestButtonSubResult[1], ",", $STR_NOCOUNT)
		EndIf

		If StringInStr($sButtonState, "Available", 0) > 0 Then
			Local $bNeedRequest = False
			If Not $g_abRequestType[0] And Not $g_abRequestType[1] And Not $g_abRequestType[2] Then
				SetDebugLog("Request for Specific CC is not enable")
				$bNeedRequest = True
			ElseIf Not $bClickPAtEnd Then
				$bNeedRequest = True
			Else
				For $i = 0 To 2
					If Not IsFullClanCastleType($i) Then
						$bNeedRequest = True
						ExitLoop
					EndIf
				Next
			EndIf

			If $bNeedRequest Then
				If Not $g_bRunState Then Return
				Local $x = _makerequest($aRequestButtonPos)
			EndIf
		ElseIf StringInStr($sButtonState, "Already", 0) > 0 Then
			SetLog("Clan Castle Request has already been made", $COLOR_INFO)
		ElseIf StringInStr($sButtonState, "Full", 0) > 0 Then
			SetLog("Clan Castle is full or not available", $COLOR_INFO)
		Else
			SetDebugLog("Error in RequestCC(): Couldn't detect Request Button State", $COLOR_ERROR)
		EndIf
	Else
		SetDebugLog("Error in RequestCC(): $aRequestButton did not return a Button State", $COLOR_ERROR)
	EndIf

	;exit from army overview
	If _Sleep($DELAYREQUESTCC1) Then Return
	If $bClickPAtEnd Then ClickAway()

EndFunc   ;==>RequestCC

Func _makerequest($aRequestButtonPos)
	Local $sSendButtonArea = GetDiamondFromRect("220,150,650,650")

	ClickP($aRequestButtonPos, 1, 0, "0336") ;click button request troops

	If _Sleep(250) Then Return
	isGemOpen(True)
	If _Sleep(500) Then Return

	If Not IsWindowOpen($g_sImgSendRequestButton, 20, 100, $sSendButtonArea) Then
		SetLog("Request has already been made, or request window not available", $COLOR_ERROR)
		ClickAway()
		If _Sleep($DELAYMAKEREQUEST2) Then Return
	Else
		If $g_sRequestTroopsText <> "" Then
			If Not $g_bChkBackgroundMode And Not $g_bNoFocusTampering Then ControlFocus($g_hAndroidWindow, "", "")
			; fix for Android send text bug sending symbols like ``"
			AndroidSendText($g_sRequestTroopsText, True)
			Click(Int($g_avWindowCoordinates[0]), Int($g_avWindowCoordinates[1] - 100), 1, 0, "#0254")
			If _Sleep($DELAYMAKEREQUEST2) Then Return
			If SendText($g_sRequestTroopsText) = 0 Then
				SetLog(" Request text entry failed, try again", $COLOR_ERROR)
				Return
			EndIf
		EndIf
		If _Sleep($DELAYMAKEREQUEST2) Then Return ; wait time for text request to complete

		If Not IsWindowOpen($g_sImgSendRequestButton, 20, 100, $sSendButtonArea) Then
			SetDebugLog("Send request button not found", $COLOR_DEBUG)
			CheckMainScreen(False) ;emergency exit
		EndIf

		If Not $g_bChkBackgroundMode And Not $g_bNoFocusTampering Then ControlFocus($g_hAndroidWindow, "", "") ; make sure Android has window focus
		ClickP($g_avWindowCoordinates, 1, 100, "#0256")
		$g_bCanRequestCC = False
	EndIf

EndFunc   ;==>_makerequest

Func IsFullClanCastleType($CCType = 0) ; Troops = 0, Spells = 1, Siege Machine = 2
	Local $aCheckCCNotFull[3] = [78, 449, 601], $sLog[3] = ["Troop", "Spell", "Siege Machine"]
	Local $aiRequestCountCC[3] = [Number($g_iRequestCountCCTroop), Number($g_iRequestCountCCSpell), 0]
	Local $bIsCCRequestTypeNotUsed = Not ($g_abRequestType[0] Or $g_abRequestType[1] Or $g_abRequestType[2])
	If $CCType <> 0 And $bIsCCRequestTypeNotUsed Then ; Continue reading CC status if all 3 items are unchecked, but only if not troop
		If $g_bDebugSetlog Then SetLog($sLog[$CCType] & " not cared about, only checking troops.")
		Return True
	Else
		Local $aRedPixel = _PixelSearch($aCheckCCNotFull[$CCType], 433 + $g_iMidOffsetY, $aCheckCCNotFull[$CCType] + 3, 435 + $g_iMidOffsetY, Hex(0xEA5054, 6), 30, True) ; red symbol
		If IsArray($aRedPixel) Then
			If Not $g_abRequestType[$CCType] And Not $bIsCCRequestTypeNotUsed And $CCType <> 0 Then
				; Don't care about the CC limit configured in setting
				SetDebugLog("Found CC " & $sLog[$CCType] & " not full, but check is disabled")
				Return True
			EndIf
			SetDebugLog("Found CC " & $sLog[$CCType] & " not full")

			; avoid total expected troops / spells is less than expected CC q'ty.
			Local $iTotalExpectedTroop = 0, $iTotalExpectedSpell = 0
			For $i = 0 To $eTroopCount - 1
				$iTotalExpectedTroop += $g_aiCCTroopsExpected[$i] * $g_aiTroopSpace[$i]
				If $i <= $eSpellCount - 1 Then $iTotalExpectedSpell += $g_aiCCSpellsExpected[$i] * $g_aiSpellSpace[$i]
			Next
			If $aiRequestCountCC[0] > $iTotalExpectedTroop And $iTotalExpectedTroop > 0 Then $aiRequestCountCC[0] = $iTotalExpectedTroop
			If $aiRequestCountCC[1] > $iTotalExpectedSpell And $iTotalExpectedSpell > 0 Then $aiRequestCountCC[1] = $iTotalExpectedSpell

			If $aiRequestCountCC[$CCType] = 0 Or $aiRequestCountCC[$CCType] >= 40 - $CCType * 38 Then
				Return False
			Else
				If $CCType < 2 Then
					Local $sCCReceived = getOcrAndCapture("coc-camps", 307 + $CCType * 158, 428 + $g_iMidOffsetY, 60, 16, True, False, True) ; read CC (troops x/40 or spells x/2)
				Else
					Local $sCCReceived = getOcrAndCapture("coc-camps", 617, 428 + $g_iMidOffsetY, 28, 16, True, False, True) ; read CC (Siege x/1)
				EndIf
				SetDebugLog("Read CC " & $sLog[$CCType] & "s: " & $sCCReceived)
				Local $aCCReceived = StringSplit($sCCReceived, "#", $STR_NOCOUNT) ; split the trained troop number from the total troop number
				If IsArray($aCCReceived) Then
					If $g_bDebugSetlog Then SetLog("Already received " & Number($aCCReceived[0]) & " CC " & $sLog[$CCType] & (Number($aCCReceived[0]) <= 1 ? "." : "s."))
					If Number($aCCReceived[0]) >= $aiRequestCountCC[$CCType] Then
						SetLog("CC " & $sLog[$CCType] & " is sufficient as required (" & Number($aCCReceived[0]) & "/" & $aiRequestCountCC[$CCType] & ")")
						Return True
					EndIf
				EndIf
			EndIf
		Else
			SetLog("CC " & $sLog[$CCType] & " is full" & ($CCType > 0 ? " or not available." : "."))
			Return True
		EndIf
	EndIf
EndFunc   ;==>IsFullClanCastleType

Func IsFullClanCastle()
	Local $bNeedRequest = False
	If Not $g_bRunState Then Return

	If Not $g_abSearchCastleWaitEnable[$DB] And Not $g_abSearchCastleWaitEnable[$LB] Then
		Return True
	EndIf

	If ($g_abAttackTypeEnable[$DB] And $g_abSearchCastleWaitEnable[$DB]) Or ($g_abAttackTypeEnable[$LB] And $g_abSearchCastleWaitEnable[$LB]) Then
		CheckCCArmy()
		For $i = 0 To 2
			If Not IsFullClanCastleType($i) Then
				$bNeedRequest = True
				ExitLoop
			EndIf
		Next
		If $bNeedRequest Then
			$g_bCanRequestCC = True
			RequestCC(False, "IsFullClanCastle")
			Return False
		EndIf
	EndIf
	Return True
EndFunc   ;==>IsFullClanCastle

Func CheckCCArmy()
	If Not $g_bRunState Then Return

	Local $bSkipTroop = Not $g_abRequestType[0] Or _ArrayMin($g_aiClanCastleTroopWaitType) = 0 ; All 3 troop comboboxes are set = "any"
	Local $bSkipSpell = Not $g_abRequestType[1] Or _ArrayMin($g_aiClanCastleSpellWaitType) = 0 ; All 3 spell comboboxes are set = "any"
	Local $bSkipSiege = Not $g_abRequestType[2] Or _ArrayMin($g_aiClanCastleSiegeWaitType) = 0 ; All 2 siege comboboxes are set = "any"
	Local $bOneSlotSpell = False

	If $bSkipTroop And $bSkipSpell And $bSkipSiege Then Return

	Local $bNeedRemove = False, $aToRemove[8][2] ; 5 troop slots + 2 spell slots + 1 siege slot [X_Coord, Q'ty]
	Local $aTroopWSlot, $aSpellWSlot

	For $i = 0 To 2
		If $g_aiClanCastleTroopWaitQty[$i] = 0 And $g_aiClanCastleTroopWaitType[$i] > 0 Then $g_aiCCTroopsExpected[$g_aiClanCastleTroopWaitType[$i] - 1] = 40 ; expect troop type only. Do not care about qty
	Next

	SetLog("Getting current army in Clan Castle...")

	If Not $g_bRunState Then Return

	If Not $bSkipTroop Then $aTroopWSlot = getArmyCCTroops(False, False, False, True, True, True) ; X-Coord, Troop name index, Quantity
	If Not $bSkipSpell Then $aSpellWSlot = getArmyCCSpells(False, False, False, True, True, True) ; X-Coord, Spell name index, Quantity
	If Not $bSkipSiege Then getArmyCCSiegeMachines() ; getting value of $g_aiCurrentCCSiegeMachines

	; CC troops
	If IsArray($aTroopWSlot) Then
		For $i = 0 To $eTroopCount - 1
			Local $iUnwanted = $g_aiCurrentCCTroops[$i] - $g_aiCCTroopsExpected[$i]
			If $g_aiCurrentCCTroops[$i] > 0 Then SetDebugLog("Expecting " & $g_asTroopNames[$i] & ": " & $g_aiCCTroopsExpected[$i] & "x. Received: " & $g_aiCurrentCCTroops[$i])
			If $iUnwanted > 0 Then
				If Not $bNeedRemove Then
					SetLog("Removing unexpected CC army:")
					$bNeedRemove = True
				EndIf
				For $j = 0 To UBound($aTroopWSlot) - 1
					If $j > 4 Then ExitLoop
					If $aTroopWSlot[$j][1] = $i Then
						$aToRemove[$j][0] = $aTroopWSlot[$j][0]
						$aToRemove[$j][1] = _Min($aTroopWSlot[$j][2], $iUnwanted)
						$iUnwanted -= $aToRemove[$j][1]
						SetLog(" - " & $aToRemove[$j][1] & "x " & ($aToRemove[$j][1] > 1 ? $g_asTroopNamesPlural[$i] : $g_asTroopNames[$i]) & ($g_bDebugSetlog ? (", at slot " & $j & ", x" & $aToRemove[$j][0] + 35) : ""))
					EndIf
				Next
			EndIf
		Next
	EndIf

	; CC spells
	If IsArray($aSpellWSlot) Then
		Local $sCCSpells = getOcrAndCapture("coc-camps", 465, 428 + $g_iMidOffsetY, 60, 16, True, False, True)
		Local $aCCSpells = StringSplit($sCCSpells, "#", $STR_NOCOUNT)
		If IsArray($aCCSpells) Then
			If Number($aCCSpells[1]) = 1 Then $bOneSlotSpell = True
		EndIf
		For $i = 0 To $eSpellCount - 1
			Local $iUnwanted = $g_aiCurrentCCSpells[$i] - $g_aiCCSpellsExpected[$i]
			If $g_aiCurrentCCSpells[$i] > 0 Then SetDebugLog("Expecting " & $g_asSpellNames[$i] & ": " & $g_aiCCSpellsExpected[$i] & "x. Received: " & $g_aiCurrentCCSpells[$i])
			If $iUnwanted > 0 Then
				If Not $bNeedRemove Then
					SetLog("Removing unexpected CC spells/siege machine:")
					$bNeedRemove = True
				EndIf
				For $j = 0 To UBound($aSpellWSlot) - 1
					If $j > 1 Then ExitLoop
					If $aSpellWSlot[$j][1] = $i Then
						$aToRemove[$j + 5][0] = $aSpellWSlot[$j][0]
						$aToRemove[$j + 5][1] = _Min($aSpellWSlot[$j][2], $iUnwanted)
						$iUnwanted -= $aToRemove[$j + 5][1]
						SetLog(" - " & $aToRemove[$j + 5][1] & "x " & $g_asSpellNames[$i] & ($aToRemove[$j + 5][1] > 1 ? " spells" : " spell") & ($g_bDebugSetlog ? (", at slot " & $j + 5 & ", x" & $aToRemove[$j + 5][0] + 35) : ""))
					EndIf
				Next
			EndIf
		Next
	EndIf

	; CC siege machine
	If Not $bSkipSiege Then
		For $i = 0 To $eSiegeMachineCount - 1
			If $g_aiCurrentCCSiegeMachines[$i] > 0 Then SetDebugLog("Expecting " & $g_asSiegeMachineNames[$i] & ": " & $g_aiCCSiegeExpected[$i] & "x. Received: " & $g_aiCurrentCCSiegeMachines[$i])
			If $g_aiCurrentCCSiegeMachines[$i] > $g_aiCCSiegeExpected[$i] Then
				If Not $bNeedRemove Then
					SetLog("Removing unexpected CC siege machine:")
					$bNeedRemove = True
				EndIf
				$aToRemove[7][1] = 1
				SetLog(" - " & $aToRemove[7][1] & "x " & $g_asSiegeMachineNames[$i])
				ExitLoop
			EndIf
		Next
	EndIf

	; Removing CC Troops, Spells & Siege Machine
	If $bNeedRemove Then
		RemoveCastleArmy($aToRemove, $bOneSlotSpell)
		If _Sleep(1000) Then Return
	EndIf
EndFunc   ;==>CheckCCArmy

Func RemoveCastleArmy($aToRemove, $bOneSlotSpell = False)

	If _ArrayMax($aToRemove, 0, -1, -1, 1) = 0 Then Return

	; Click 'Edit Army'
	If Not _CheckPixel($aButtonEditArmy, True) Then ; If no 'Edit Army' Button found in army tab to edit troops
		SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_WARNING)
		Return False ; Exit function
	EndIf

	ClickP($aButtonEditArmy, 1) ; Click Edit Army Button
	If Not $g_bRunState Then Return

	If _Sleep(500) Then Return

	; Click remove Troops & Spells
	Local $aPos[2] = [129, 518 + $g_iMidOffsetY]
	For $i = 0 To UBound($aToRemove) - 1
		If $aToRemove[$i][1] > 0 Then
			Switch $i
				Case 0 To 4
					$aPos[0] = $aToRemove[$i][0] + 44
				Case 5
					$aPos[0] = 499 ; x-coordinate of first Spell slot
					If $bOneSlotSpell Then $aPos[0] = 533 ; x-coordinate of Single Spell slot
				Case 6
					$aPos[0] = 563 ; x-coordinate of second Spell slot
				Case 7
					$aPos[0] = 649 ; x-coordinate of Siege machine slot
			EndSwitch
			SetDebugLog(" - Click at slot " & $i & ". (" & $aPos[0] & ") x " & $aToRemove[$i][1])
			ClickRemoveTroop($aPos, $aToRemove[$i][1], $g_iTrainClickDelay) ; Click on Remove button as much as needed
		EndIf
	Next

	If _Sleep(400) Then Return

	; Click Okay & confirm
	Local $counter = 0
	While Not _CheckPixel($aButtonRemoveTroopsOK1, True) ; If no 'Okay' button found in army tab to save changes
		If _Sleep(200) Then Return
		$counter += 1
		If $counter <= 5 Then ContinueLoop
		SetLog("Cannot find/verify 'Okay' Button in Army tab", $COLOR_WARNING)
		ClickAway()
		If _Sleep(400) Then OpenArmyOverview(True, "RemoveCastleSpell()") ; Open Army Window AGAIN
		Return False ; Exit Function
	WEnd

	ClickP($aButtonRemoveTroopsOK1, 1) ; Click on 'Okay' button to save changes

	If _Sleep(400) Then Return

	$counter = 0
	While Not _CheckPixel($aButtonRemoveTroopsOK2, True) ; If no 'Okay' button found to verify that we accept the changes
		If _Sleep(200) Then Return
		$counter += 1
		If $counter <= 5 Then ContinueLoop
		SetLog("Cannot find/verify 'Okay #2' Button in Army tab", $COLOR_WARNING)
		ClickAway()
		Return False ; Exit function
	WEnd

	ClickP($aButtonRemoveTroopsOK2, 1) ; Click on 'Okay' button to Save changes... Last button

	SetLog("Clan Castle army removed", $COLOR_SUCCESS)
	If _Sleep(200) Then Return
	Return True
EndFunc   ;==>RemoveCastleArmy
