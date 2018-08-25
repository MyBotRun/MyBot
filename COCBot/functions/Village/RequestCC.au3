; #FUNCTION# ====================================================================================================================
; Name ..........: RequestCC
; Description ...:
; Syntax ........: RequestCC()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: Sardo(06-2015), KnowJack(10-2015), Sardo (08-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func RequestCC($ClickPAtEnd = True, $specifyText = "")

	If Not $g_bRequestTroopsEnable Or Not $g_bCanRequestCC Or Not $g_bDonationEnabled Then
		Return
	EndIf

	If $g_bRequestTroopsEnable Then
		Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		If $g_abRequestCCHours[$hour[0]] = False Then
			SetLog("Request Clan Castle troops not planned, Skipped..", $COLOR_ACTION)
			Return ; exit func if no planned donate checkmarks
		EndIf
	EndIf

	SetLog("Requesting Clan Castle Troops", $COLOR_INFO)

	;open army overview
	If IsMainPage(1) Then
		If Not $g_bUseRandomClick Then
			Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0334")
		Else
			ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
		EndIf
	EndIf

	If _Sleep($DELAYREQUESTCC1) Then Return

	checkAttackDisable($g_iTaBChkIdle) ; Early Take-A-Break detection

	;wait to see army overview
	Local $iCount = 0
	While IsTrainPage(False, 2) = False
		If _Sleep($DELAYREQUESTCC1) Then ExitLoop
		$iCount += 1
		If $iCount > 5 Then
			If $g_bDebugSetlog Then SetDebugLog("RequestCC Army Window issue!", $COLOR_DEBUG)
			ExitLoop ; wait 6*500ms = 3 seconds max
		EndIf
	WEnd

	If $ClickPAtEnd Then
		getArmyCCSpellCapacity(False, False, False, False)
		CheckCCArmy()
	EndIf

	Local $color1 = _GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1] + 20, True) ; Gray/Green color at 20px below Letter "R"
	Local $color2 = _GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True) ; White/Green color at Letter "R"

	If _ColorCheck($color1, Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5]) Then
		;clan full or not in clan
		SetLog("Your Clan Castle is already full or you are not in a clan.")
		$g_bCanRequestCC = False
	ElseIf _ColorCheck($color1, Hex($aRequestTroopsAO[3], 6), $aRequestTroopsAO[5]) Then
		If _ColorCheck($color2, Hex($aRequestTroopsAO[4], 6), $aRequestTroopsAO[5]) Then
			;can make a request
			Local $bNeedRequest = False
			If Not $g_abRequestType[0] And Not $g_abRequestType[1] And Not $g_abRequestType[2] Then
				SetDebugLog("Request for Specific CC is not enable")
				$bNeedRequest = True
			ElseIf Not $ClickPAtEnd Then
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
				Local $x = _makerequest()
			EndIf

		Else
			;request has already been made
			SetLog("Request has already been made")
		EndIf
	Else
		;no button request found
		SetLog("Cannot detect button request troops.")
		SetLog("The Pixel on " & $aRequestTroopsAO[0] & "-" & $aRequestTroopsAO[1] & " was: " & $color1, $COLOR_ERROR)
	EndIf

	;exit from army overview
	If _Sleep($DELAYREQUESTCC1) Then Return
	If $ClickPAtEnd Then ClickP($aAway, 2, 0, "#0335")

EndFunc   ;==>RequestCC

Func _makerequest()
	;click button request troops
	Click($aRequestTroopsAO[0], $aRequestTroopsAO[1], 1, 0, "0336") ;Select text for request

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
			If $g_bChkBackgroundMode = False And $g_bNoFocusTampering = False Then ControlFocus($g_hAndroidWindow, "", "")
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
	If Not $g_abRequestType[$CCType] And ($g_abRequestType[0] Or $g_abRequestType[1] Or $g_abRequestType[2]) Then
		If $g_bDebugSetlog Then SetLog($sLog[$CCType] & " not cared about.")
		Return True
	Else
		If _ColorCheck(_GetPixelColor($aCheckCCNotFull[$CCType], 470, True), Hex(0xDC363A , 6), 30) Then ; red symbol
			SetDebugLog("Found CC " & $sLog[$CCType] & " not full")
			If $aiRequestCountCC[$CCType] = 0 or $aiRequestCountCC[$CCType] >= 40 - $CCType * 38 Then
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
	If Not $g_abRequestType[0] And Not $g_abRequestType[1] Then Return
	Local $bNeedRemoveTroop = False, $bNeedRemoveSpell = False

	; CC troops
	Local $aToRemove[5] = [0, 0, 0, 0, 0] ; 5 cc troop slots
	If $g_abRequestType[0] And _ArrayMin($g_aiClanCastleTroopWaitType) < $eTroopCount Then ; avoid 3 slots are set = "any"
		For $i = 0 To 2
			If $g_aiClanCastleTroopWaitQty[$i] = 0 And $g_aiClanCastleTroopWaitType[$i] < $eTroopCount Then $g_aiCCTroopsExpected[$g_aiClanCastleTroopWaitType[$i]] = 40 ; expect troop type only. Do not care about qty
		Next
		SetDebugLog("Getting current available troops in Clan Castle.")
		Local $aTroopWSlot = getArmyCCTroops(False, False, False, True, True, True) ; X-Coord, Troops name index, Quantity
		If IsArray($aTroopWSlot) Then
			For $i = 0 To $eTroopCount - 1
				Local $iUnwanted = $g_aiCurrentCCTroops[$i] - $g_aiCCTroopsExpected[$i]
				If $g_aiCurrentCCTroops[$i] > 0 Then SetDebugLog("Expecting " & $g_asTroopNames[$i] & ": " & $g_aiCCTroopsExpected[$i] & "x. Received: " & $g_aiCurrentCCTroops[$i])
				If $iUnwanted > 0 Then
					For $j = 0 To UBound($aTroopWSlot) - 1
						If $j > 4 Then ExitLoop
						If $aTroopWSlot[$j][1] = $i Then
							$aToRemove[$j] = _Min($aTroopWSlot[$j][2], $iUnwanted)
							$iUnwanted -= $aToRemove[$j]
							SetDebugLog(" - To remove: " & $g_asTroopNames[$i] & " " & $aToRemove[$j] & "x from Slot: " & $j)
						EndIf
					Next
					$bNeedRemoveTroop = True
				EndIf
			Next
		EndIf
	EndIf

	; CC Spells
	Local $sCurCCSpell1 = "", $sCurCCSpell2 = "", $aShouldRemove[2] = [0, 0]
	Local $bCCSpellFull = False

	If Not $g_bRunState Then Return
	If $g_abRequestType[1] And $g_iClanCastleSpellsWaitFirst > 0 And $g_iCurrentCCSpells = $g_iTotalCCSpells And $g_iTotalCCSpells > 0 Then
		If $g_bDebugSetlog Then SetLog("Getting current available spell in Clan Castle.")
		; Imgloc Detection
		If $g_iTotalCCSpells >= 1 Then $sCurCCSpell1 = GetCurCCSpell(1)
		If $g_iTotalCCSpells >= 2 Then $sCurCCSpell2 = GetCurCCSpell(2)

		; Compare the detection with the GUI selection
		$aShouldRemove = CompareCCSpellWithGUI($sCurCCSpell1, $sCurCCSpell2, $g_iTotalCCSpells)

		; Debug
		If $g_iTotalCCSpells >= 2 Then
			If $g_bDebugSetlog Then SetLog("Slot 1 to remove: " & $aShouldRemove[0])
			If $g_bDebugSetlog Then SetLog("Slot 2 to remove: " & $aShouldRemove[1])
		ElseIf $g_iTotalCCSpells = 1 Then
			If $g_bDebugSetlog Then SetLog("Slot 1 to remove: " & $aShouldRemove[0])
		EndIf

		If $aShouldRemove[0] > 0 Or $aShouldRemove[1] > 0 Then $bNeedRemoveSpell = True
	EndIf

	; Removing CC Troops & Spells
	If $bNeedRemoveTroop Or $bNeedRemoveSpell Then
		SetLog("Removing unexpected" & ($bNeedRemoveTroop ? ($bNeedRemoveSpell ? " troops & spells:" : " troops:") : " spells:"))
		If $bNeedRemoveTroop Then
			For $i = 0 To $eTroopCount - 1
				Local $iUnwanted = $g_aiCurrentCCTroops[$i] - $g_aiCCTroopsExpected[$i]
				If $iUnwanted > 0 Then SetLog(" - " & $iUnwanted & "x " & ($iUnwanted > 1 ? $g_asTroopNamesPlural[$i] : $g_asTroopNames[$i]))
			Next
		EndIf
		If $aShouldRemove[0] > 0 And IsArray($sCurCCSpell1) Then SetLog(" - " & $aShouldRemove[0] & "x " & GetTroopName(Eval("e" & $sCurCCSpell1[0][0])) & " spell")
		If $aShouldRemove[1] > 0 And IsArray($sCurCCSpell2) Then SetLog(" - " & $aShouldRemove[1] & "x " & GetTroopName(Eval("e" & $sCurCCSpell2[0][0])) & " spell")
		RemoveCastleArmy($aToRemove, $aShouldRemove)
		If _Sleep(1000) Then Return
	EndIf
EndFunc   ;==>CheckCCArmy

Func RemoveCastleArmy($Troops, $Spells)

	If _ArrayMax($Troops) = 0 And $Spells[0] = 0 And $Spells[1] = 0 Then Return

	; Click 'Edit Army'
	If Not _ColorCheck(_GetPixelColor(806, 516, True), Hex(0xCEEF76, 6), 25) Then ; If no 'Edit Army' Button found in army tab to edit troops
		SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_WARNING)
		Return False ; Exit function
	EndIf

	Click(Random(715, 825, 1), Random(507, 545, 1)) ; Click on Edit Army Button
	If Not $g_bRunState Then Return

	If _Sleep(500) Then Return

	; Click remove Troops
	Local $aTroopPos[2] = [72, 575]
	If _ArrayMax($Troops) > 0 Then
		For $i = 0 To UBound($Troops) - 1
			If $Troops[$i] > 0 Then
				$aTroopPos[0] = 72 * ($i + 1)
				ClickRemoveTroop($aTroopPos, $Troops[$i], $g_iTrainClickDelay) ; Click on Remove button as much as needed
			EndIf
		Next
	EndIf

	; Click remove Spells
	Local $pos[2] = [515, 575], $pos2[2] = [585, 575]

	If $Spells[0] > 0 Then
		ClickRemoveTroop($pos, $Spells[0], $g_iTrainClickDelay) ; Click on Remove button as much as needed
	EndIf
	If $Spells[1] > 0 Then
		ClickRemoveTroop($pos2, $Spells[1], $g_iTrainClickDelay)
	EndIf

	If _Sleep(400) Then Return

	; Click Okay & confirm
	Local $counter = 0
	While Not _ColorCheck(_GetPixelColor(806, 567, True), Hex(0xCEEF76, 6), 25) ; If no 'Okay' button found in army tab to save changes
		If _Sleep(200) Then Return
		$counter += 1
		If $counter <= 5 Then ContinueLoop
		SetLog("Cannot find/verify 'Okay' Button in Army tab", $COLOR_WARNING)
		ClickP($aAway, 2, 0, "#0346") ; Click Away, Necessary! due to possible errors/changes
		If _Sleep(400) Then OpenArmyOverview(True, "RemoveCastleSpell()") ; Open Army Window AGAIN
		Return False ; Exit Function
	WEnd

	Click(Random(720, 815, 1), Random(558, 589, 1)) ; Click on 'Okay' button to save changes

	If _Sleep(400) Then Return

	$counter = 0
	While Not _ColorCheck(_GetPixelColor(508, 428, True), Hex(0xFFFFFF, 6), 30) ; If no 'Okay' button found to verify that we accept the changes
		If _Sleep(200) Then Return
		$counter += 1
		If $counter <= 5 Then ContinueLoop
		SetLog("Cannot find/verify 'Okay #2' Button in Army tab", $COLOR_WARNING)
		ClickP($aAway, 2, 0, "#0346") ;Click Away
		Return False ; Exit function
	WEnd

	Click(Random(445, 583, 1), Random(402, 455, 1)) ; Click on 'Okay' button to Save changes... Last button

	SetLog("Clan Castle Troops/Spells Removed", $COLOR_SUCCESS)
	If _Sleep(200) Then Return
	Return True
EndFunc   ;==>RemoveCastleArmy

Func CompareCCSpellWithGUI($CCSpell1, $CCSpell2, $CastleCapacity)

	; $CCSpells are an array with the Detected Spell :
	; $CCSpell1[0][0] = Name , [0][1] = X , [0][2] = Y , [0][3] = Quantities
	; $CCSpell2[0][0] = Name , [0][1] = X , [0][2] = Y , [0][3] = Quantities , IS "" if was not detected or is not necessary

	If $g_bDebugSetlog Then ; Just For debug
		For $i = 0 To UBound($CCSpell1, $UBOUND_COLUMNS) - 1
			SetLog("$CCSpell1[0][" & $i & "]: " & $CCSpell1[0][$i])
		Next
		If $CCSpell2 <> "" And $CastleCapacity = 2 And $CCSpell1[0][3] < 2 Then ; IF the Castle is = 2 and the previous Spell quantity was only 1
			For $i = 0 To UBound($CCSpell2, $UBOUND_COLUMNS) - 1
				SetLog("$CCSpell2[0][" & $i & "]: " & $CCSpell2[0][$i])
			Next
		EndIf
	EndIf

	If Not $g_bRunState Then Return
	If _Sleep(100) Then Return

	Local $sCCSpell, $sCCSpell2, $aShouldRemove[2] = [0, 0]

	If $CastleCapacity = 0 Or $CastleCapacity = "" Then Return $aShouldRemove

	Switch $g_iClanCastleSpellsWaitFirst
		Case 0
			$sCCSpell = "Any"
		Case 1
			$sCCSpell = "LSpell"
		Case 2
			$sCCSpell = "HSpell"
		Case 3
			$sCCSpell = "RSpell"
		Case 4
			$sCCSpell = "JSpell"
		Case 5
			$sCCSpell = "FSpell"
		Case 6
			$sCCSpell = "PSpell"
		Case 7
			$sCCSpell = "ESpell"
		Case 8
			$sCCSpell = "HaSpell"
		Case 9
			$sCCSpell = "SkSpell"
	EndSwitch

	Switch $g_iClanCastleSpellsWaitSecond
		Case 0
			$sCCSpell2 = "Any"
		Case 1
			$sCCSpell2 = "FSpell"
		Case 2
			$sCCSpell2 = "PSpell"
		Case 3
			$sCCSpell2 = "ESpell"
		Case 4
			$sCCSpell2 = "HaSpell"
		Case 5
			$sCCSpell2 = "SkSpell"
	EndSwitch

	If $g_bDebugSetlog Then SetLog("$sCCSpell: " & $sCCSpell & ", $sCCSpell2: " & $sCCSpell2)
	Switch $CCSpell1[0][3] ; Switch through all possible results

		Case 1 ; One Spell on Slot 1

			If $sCCSpell <> "Any" Then
				If $sCCSpell <> $CCSpell1[0][0] Then ; First Spell not in Slot 1
					If $g_bDebugSetlog Then SetLog("First Spell not in Slot 1")
					If $CastleCapacity = 2 And $g_iClanCastleSpellsWaitFirst > 4 Then
						If $sCCSpell <> $CCSpell2[0][0] Then ; First Spell not in Slot 2, so check Second Spell
							If $g_bDebugSetlog Then SetLog("First Spell not in Slot 2")
							If $sCCSpell2 <> "Any" Then
								If $sCCSpell2 <> $CCSpell1[0][0] Then ; Second Spell not in Slot 1, so remove this one
									If $g_bDebugSetlog Then SetLog("Second Spell not in Slot 1")
									$aShouldRemove[0] = $CCSpell1[0][3]
									If $sCCSpell2 <> $CCSpell2[0][0] Then ; Second Spell not in Slot 2, so remove this one
										If $g_bDebugSetlog Then SetLog("Second Spell not in Slot 2")
										$aShouldRemove[1] = $CCSpell2[0][3]
									Else
										If $g_bDebugSetlog Then SetLog("Second Spell in Slot 2")
									EndIf
								Else
									If $g_bDebugSetlog Then SetLog("Second Spell in Slot 1")
								EndIf
							Else
								$aShouldRemove[1] = $CCSpell2[0][3] ; When "Any" as Second Spell, just remove one Spell
							EndIf
						Else
							If $g_bDebugSetlog Then SetLog("First Spell in Slot 2") ; Second Spell not in Slot 1, so remove this one
							If $sCCSpell2 <> $CCSpell1[0][0] And $sCCSpell2 <> "Any" Then
								If $g_bDebugSetlog Then SetLog("Second Spell not in Slot 1")
								$aShouldRemove[0] = $CCSpell1[0][3]
							Else
								If $g_bDebugSetlog Then SetLog("Second Spell in Slot 1")
							EndIf
						EndIf
					Else
						$aShouldRemove[0] = $CCSpell1[0][3]
					EndIf
				Else
					If $g_bDebugSetlog Then SetLog("First Spell in Slot 1")
					If $CastleCapacity = 2 And $g_iClanCastleSpellsWaitFirst > 4 Then
						If $sCCSpell2 <> $CCSpell2[0][0] And $sCCSpell2 <> "Any" Then ; Second Spell not in Slot 2
							If $g_bDebugSetlog Then SetLog("Second Spell not in Slot 2")
							$aShouldRemove[1] = $CCSpell2[0][3]
						Else
							If $g_bDebugSetlog Then SetLog("Second Spell in Slot 2")
						EndIf
					EndIf
				EndIf
			EndIf

		Case 2 ; Two Spells on Slot 1

			If $sCCSpell <> "Any" Then
				If $g_iClanCastleSpellsWaitFirst < 5 And $g_iClanCastleSpellsWaitFirst > 0 Then ; Should be a 2 Space Spell not a 1 Space Spell
					$aShouldRemove[0] = $CCSpell1[0][3]
				ElseIf ($sCCSpell <> $CCSpell1[0][0]) And ($sCCSpell2 <> $CCSpell1[0][0] And $sCCSpell2 <> "Any") Then
					$aShouldRemove[0] = $CCSpell1[0][3]
				ElseIf ($sCCSpell <> $CCSpell1[0][0]) Or ($sCCSpell2 <> $CCSpell1[0][0] And $sCCSpell2 <> "Any") Then
					$aShouldRemove[0] = 1
				EndIf
			EndIf

		Case Else ; Mistakes were made?
			Return $aShouldRemove
	EndSwitch

	Return $aShouldRemove

EndFunc   ;==>CompareCCSpellWithGUI

Func GetCurCCSpell($iSpellSlot = 1)
	If Not $g_bRunState Then Return
	Local $x1 = 451, $x2 = 575, $y1 = 500, $y2 = 585

	If $iSpellSlot = 1 Then
		;Nothing
	ElseIf $iSpellSlot = 2 Then
		$x1 = 530
		$x2 = 605
	Else
		If $g_bDebugSetlog Then SetDebugLog("GetCurCCSpell() called with the wrong argument!", $COLOR_ERROR)
		Return
	EndIf

	Local $res = SearchArmy($g_sImgArmyOverviewSpells, $x1, $y1, $x2, $y2, "CCSpells", True)

	If ValidateSearchArmyResult($res) Then
		For $i = 0 To UBound($res) - 1
			SetLog(" - " & $g_asSpellNames[TroopIndexLookup($res[$i][0], "GetCurCCSpell") - $eLSpell], $COLOR_SUCCESS)
		Next
		Return $res
	EndIf

	Return ""
EndFunc   ;==>GetCurCCSpell
