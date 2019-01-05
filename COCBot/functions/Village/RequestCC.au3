; #FUNCTION# ====================================================================================================================
; Name ..........: RequestCC
; Description ...:
; Syntax ........: RequestCC()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: Sardo(06-2015), KnowJack(10-2015), Sardo (08-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func RequestCC($bClickPAtEnd = True, $sText = "")

	If Not $g_bRequestTroopsEnable Or Not $g_bDonationEnabled Then
		Return
	EndIf

	If $g_bRequestTroopsEnable Then
		Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		If $g_abRequestCCHours[$hour[0]] = False Then
			SetLog("Request Clan Castle troops not planned, Skipped..", $COLOR_ACTION)
			Return ; exit func if no planned donate checkmarks
		EndIf
	EndIf

	;open army overview
	If $sText <> "IsFullClanCastle" And Not OpenArmyOverview(True, "RequestCC()") Then Return

	If _Sleep($DELAYREQUESTCC1) Then Return
	SetLog("Requesting Clan Castle reinforcements", $COLOR_INFO)
	checkAttackDisable($g_iTaBChkIdle) ; Early Take-A-Break detection
	If $bClickPAtEnd Then CheckCCArmy()

	Local $sSearchDiamond = GetDiamondFromRect("600,430,850,620")
	Local Static $aRequestButtonPos[2] = [-1, -1]

	Local $aRequestButton = findMultiple($g_sImgRequestCCButton, $sSearchDiamond, $sSearchDiamond, 0, 1000, 1, "objectname,objectpoints", True)
	If Not IsArray($aRequestButton) Then
		SetLog("Error in RequestCC(): $aRequestButton is no Array")
		Return
	EndIf

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
				Local $x = _makerequest($aRequestButtonPos)
			EndIf
		ElseIf StringInStr($sButtonState, "Already", 0) > 0 Then
			SetLog("Clan Castle Request has already been made", $COLOR_INFO)
		ElseIf StringInStr($sButtonState, "Full", 0) > 0 Then
			SetLog("Clan Castle is full or not available", $COLOR_INFO)
		Else
			SetLog("Error in RequestCC(): Couldn't detect Request Button State", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Error in RequestCC(): $aRequestButton did not return a Button State", $COLOR_ERROR)
	EndIf

	;exit from army overview
	If _Sleep($DELAYREQUESTCC1) Then Return
	If $bClickPAtEnd Then ClickP($aAway, 2, 0, "#0335")

EndFunc   ;==>RequestCC

Func _makerequest($aButtonPosition)
	;click button request troops
	ClickP($aButtonPosition, 1, 0, "0336") ;Select text for request

	;wait window
	Local $iCount = 0
	While Not ( _ColorCheck(_GetPixelColor($aCancRequestCCBtn[0], $aCancRequestCCBtn[1], True), Hex($aCancRequestCCBtn[2], 6), $aCancRequestCCBtn[3]))
		If _Sleep($DELAYMAKEREQUEST1) Then ExitLoop
		$iCount += 1
		If $g_bDebugSetlog Then SetDebugLog("$icount2 = " & $iCount & ", " & _GetPixelColor($aCancRequestCCBtn[0], $aCancRequestCCBtn[1], True), $COLOR_DEBUG)
		If $iCount > 20 Then ExitLoop ; wait 21*500ms = 10.5 seconds max
	WEnd
	If $iCount > 20 Then
		SetLog("Request has already been made, or request window not available", $COLOR_ERROR)
		ClickP($aAway, 2, 0, "#0257")
		If _Sleep($DELAYMAKEREQUEST2) Then Return
	Else
		If $g_sRequestTroopsText <> "" Then
			If Not $g_bChkBackgroundMode And Not $g_bNoFocusTampering Then ControlFocus($g_hAndroidWindow, "", "")
			; fix for Android send text bug sending symbols like ``"
			AndroidSendText($g_sRequestTroopsText, True)
			Click($atxtRequestCCBtn[0], $atxtRequestCCBtn[1], 1, 0, "#0254") ;Select text for request $atxtRequestCCBtn[2] = [430, 140]
			_Sleep($DELAYMAKEREQUEST2)
			If SendText($g_sRequestTroopsText) = 0 Then
				SetLog(" Request text entry failed, try again", $COLOR_ERROR)
				Return
			EndIf
		EndIf
		If _Sleep($DELAYMAKEREQUEST2) Then Return ; wait time for text request to complete
		$iCount = 0
		While Not _ColorCheck(_GetPixelColor($aSendRequestCCBtn[0], $aSendRequestCCBtn[1], True), Hex(0x5fac10, 6), 20)
			If _Sleep($DELAYMAKEREQUEST1) Then ExitLoop
			$iCount += 1
			If $g_bDebugSetlog Then SetDebugLog("$icount3 = " & $iCount & ", " & _GetPixelColor($aSendRequestCCBtn[0], $aSendRequestCCBtn[1], True), $COLOR_DEBUG)
			If $iCount > 25 Then ExitLoop ; wait 26*500ms = 13 seconds max
		WEnd
		If $iCount > 25 Then
			If $g_bDebugSetlog Then SetDebugLog("Send request button not found", $COLOR_DEBUG)
			CheckMainScreen(False) ;emergency exit
		EndIf
		If $g_bChkBackgroundMode = False And $g_bNoFocusTampering = False Then ControlFocus($g_hAndroidWindow, "", "") ; make sure Android has window focus
		Click($aSendRequestCCBtn[0], $aSendRequestCCBtn[1], 1, 100, "#0256") ; click send button
		$g_bCanRequestCC = False
	EndIf

EndFunc   ;==>_makerequest

Func IsFullClanCastleType($CCType = 0) ; Troops = 0, Spells = 1, Siege Machine = 2
	Local $aCheckCCNotFull[3] = [24, 455, 631], $sLog[3] = ["Troop", "Spell", "Siege Machine"]
	Local $aiRequestCountCC[3] = [Number($g_iRequestCountCCTroop), Number($g_iRequestCountCCSpell), 0]
	Local $bCheckOnlyTroop = $g_abRequestType[0] = False And $g_abRequestType[1] = False And $g_abRequestType[2] = False
	If Not $g_abRequestType[$CCType] And ($g_abRequestType[0] Or $g_abRequestType[1] Or $g_abRequestType[2] Or ($bCheckOnlyTroop And $CCType <> 0)) Then
		If $g_bDebugSetlog Then SetLog($sLog[$CCType] & " not cared about.")
		Return True
	Else
		If _ColorCheck(_GetPixelColor($aCheckCCNotFull[$CCType], 470, True), Hex(0xDC363A, 6), 30) Then ; red symbol
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
				Local $sCCReceived = getOcrAndCapture("coc-ms", 289 + $CCType * 183, 468, 60, 16, True, False, True) ; read CC (troops 0/40 or spells 0/2)
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

	Local $bSkipTroop = Not $g_abRequestType[0] Or _ArrayMin($g_aiClanCastleTroopWaitType) = $eTroopCount ; All 3 troop comboboxes are set = "any"
	Local $bSkipSpell = Not $g_abRequestType[1] Or _ArrayMin($g_aiClanCastleSpellWaitType) = $eSpellCount ; All 3 spell comboboxes are set = "any"
	Local $bSkipSiege = Not $g_abRequestType[2] Or _ArrayMin($g_aiClanCastleSiegeWaitType) = $eSiegeMachineCount ; All 2 siege comboboxes are set = "any"

	If $bSkipTroop And $bSkipSpell And $bSkipSiege Then Return

	Local $bNeedRemove = False, $aToRemove[8][2] ; 5 troop slots + 2 spell slots + 1 siege slot [X_Coord, Q'ty]
	Local $aTroopWSlot, $aSpellWSlot

	For $i = 0 To 2
		If $g_aiClanCastleTroopWaitQty[$i] = 0 And $g_aiClanCastleTroopWaitType[$i] < $eTroopCount Then $g_aiCCTroopsExpected[$g_aiClanCastleTroopWaitType[$i]] = 40 ; expect troop type only. Do not care about qty
	Next

	SetLog("Getting current army in Clan Castle...")

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
		RemoveCastleArmy($aToRemove)
		If _Sleep(1000) Then Return
	EndIf
EndFunc   ;==>CheckCCArmy

Func RemoveCastleArmy($aToRemove)

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
	Local $aPos[2] = [35, 575]
	For $i = 0 To UBound($aToRemove) - 1
		If $aToRemove[$i][1] > 0 Then
			$aPos[0] = $aToRemove[$i][0] + 35
			If $i = 7 Then $aPos[0] = 685 ; x-coordinate of Siege machine slot
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
		ClickP($aAway, 2, 0, "#0346") ; Click Away, Necessary! due to possible errors/changes
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
		ClickP($aAway, 2, 0, "#0346") ;Click Away
		Return False ; Exit function
	WEnd

	ClickP($aButtonRemoveTroopsOK2, 1) ; Click on 'Okay' button to Save changes... Last button

	SetLog("Clan Castle army removed", $COLOR_SUCCESS)
	If _Sleep(200) Then Return
	Return True
EndFunc   ;==>RemoveCastleArmy
