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
	If IsMainPage(5) Then
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

	Local $color1 = _GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1] + 20, True) ; Gray/Green color at 20px below Letter "R"
	Local $color2 = _GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True) ; White/Green color at Letter "R"

	If _ColorCheck($color1, Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5]) Then
		;clan full or not in clan
		SetLog("Your Clan Castle is already full or you are not in a clan.")
		$g_bCanRequestCC = False
	ElseIf _ColorCheck($color1, Hex($aRequestTroopsAO[3], 6), $aRequestTroopsAO[5]) Then
		If _ColorCheck($color2, Hex($aRequestTroopsAO[4], 6), $aRequestTroopsAO[5]) Then
			;can make a request
			; Request Type - Demen
			Local $bNeedRequest = False, $aCheckCCNotFull[3] = [24, 455, 631], $sLog[3] = ["Troop", "Spell", "Siege Machine"]
			If Not $g_abRequestType[0] And Not $g_abRequestType[1] And Not $g_abRequestType[2] Then
				SetDebugLog("Request for Specific CC is not enable")
				$bNeedRequest = True
			Else
				Local $aiRequestCountCC[3] = [Number($g_iRequestCountCCTroop), Number($g_iRequestCountCCSpell), 0]
				For $i = 0 To 2
					If $g_abRequestType[$i] Then
						If _ColorCheck(_GetPixelColor($aCheckCCNotFull[$i], 470, True), Hex(0xDC363A , 6), 30) Then ; red symbol
							SetDebugLog("Found CC " & $sLog[$i] & " not full")
							If $aiRequestCountCC[$i] = 0 or $aiRequestCountCC[$i] >= 40 - $i * 38 Then
								$bNeedRequest = True
							Else 
								Local $sCCReceived = getOcrAndCapture("coc-ms", 289 + $i * 183, 468, 60, 16, True, False, True) ; read CC (troops 0/40 or spells 0/2)
								SetDebugLog("Read CC " & ($i = 0 ? "Troops: " : "Spells: ") & $sCCReceived)
								Local $aCCReceived = StringSplit($sCCReceived, "#", $STR_NOCOUNT) ; split the trained troop number from the total troop number
								If IsArray($aCCReceived) Then
									If Number($aCCReceived[0]) < $aiRequestCountCC[$i] Then $bNeedRequest = True
									If Not $bNeedRequest Or $g_bDebugSetlog Then SetLog("Already received " & Number($aCCReceived[0]) & ($i = 0 ? " CC Troops." : " CC Spells."))
								EndIf
							EndIf
						Else
							SetLog("CC " & $sLog[$i] & " is full" & ($i > 0 ? " or not available." : "."))
						EndIf
						If $bNeedRequest Then ExitLoop
					Else
						SetDebugLog("RequestType does not care about " & $sLog[$i])
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
