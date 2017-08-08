
; #FUNCTION# ====================================================================================================================
; Name ..........: checkObstacles
; Description ...: Checks whether something is blocking the pixel for mainscreen and tries to unblock
; Syntax ........: checkObstacles()
; Parameters ....:
; Return values .: Returns True when there is something blocking
; Author ........: Hungle (2014)
; Modified ......: KnowJack (2015), Sardo (08-2015), TheMaster1st(10-2015), MonkeyHunter (08-2016), MMHK (12-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func checkObstacles($bBuilderBase = False) ;Checks if something is in the way for mainscreen
	Static $checkObstaclesActive = False

	If TestCapture() = False And WinGetAndroidHandle() = 0 Then
		; Android not available
		Return True
	EndIf

	; prevent recursion
	If $checkObstaclesActive = True Then Return True
	Local $wasForce = OcrForceCaptureRegion(False)
	$checkObstaclesActive = True
	Local $Result = _checkObstacles($bBuilderBase)
	OcrForceCaptureRegion($wasForce)
	$checkObstaclesActive = False
	Return $Result
EndFunc   ;==>checkObstacles

Func _checkObstacles($bBuilderBase = False) ;Checks if something is in the way for mainscreen
	Local $msg, $x, $y, $Result
	$g_bMinorObstacle = False

	_CaptureRegions()

	If checkObstacles_Network() Then Return True
	Local $bIsOnBuilderIsland = _CheckPixel($aIsOnBuilderIsland, $g_bNoCapturePixel)
	If $bBuilderBase = False And $bIsOnBuilderIsland = True Then
		SetLog("Detected Builder Base, trying to switch back to Main Village")
		If SwitchBetweenBases(False) Then
			$g_bMinorObstacle = True
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			Return False
		EndIf
	EndIf

	If $g_sAndroidGameDistributor <> $g_sGoogle Then ; close an ads window for non google apks
		Local $aXButton = FindAdsXButton()
		If IsArray($aXButton) Then
			SetDebugLog("checkObstacles: Found " & $g_sAndroidGameDistributor & " ADS X button to close")
			PureClickP($aXButton)
			$g_bMinorObstacle = True
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			Return False
		EndIf
	EndIf

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Detect All Reload Button errors => 1- Another device, 2- Take a break, 3- Connection lost or error, 4- Out of sync, 5- Inactive, 6- Maintenance
	Local $aMessage = _PixelSearch($aIsReloadError[0], $aIsReloadError[1], $aIsReloadError[0] + 3, $aIsReloadError[1] + 11, Hex($aIsReloadError[2], 6), $aIsReloadError[3], $g_bNoCapturePixel)
	If IsArray($aMessage) Then
		If $g_iDebugSetlog = 1 Then SetLog("(Inactive=" & _GetPixelColor($aIsInactive[0], $aIsInactive[1]) & ")(DC=" & _GetPixelColor($aIsConnectLost[0], $aIsConnectLost[1]) & ")(OoS=" & _GetPixelColor($aIsCheckOOS[0], $aIsCheckOOS[1]) & ")", $COLOR_DEBUG)
		If $g_iDebugSetlog = 1 Then SetLog("(Maintenance=" & _GetPixelColor($aIsMaintenance[0], $aIsMaintenance[1]) & ")(RateCoC=" & ")", $COLOR_DEBUG)
		If $g_iDebugSetlog = 1 Then SetLog("33B5E5=>true, 282828=>false", $COLOR_DEBUG)
		;;;;;;;##### 1- Another device #####;;;;;;;
		$Result = getOcrMaintenanceTime(184, 325 + $g_iMidOffsetY, "Another Device OCR:") ; OCR text to find Another device message
		If StringInStr($Result, "device", $STR_NOCASESENSEBASIC) Or _
				UBound(decodeSingleCoord(FindImageInPlace("Device", $g_sAnotherDevice, "220,330,300,390", False))) > 1 Then
			If TestCapture() Then Return "Another Device has connected"
			If $g_iAnotherDeviceWaitTime > 3600 Then
				SetLog("Another Device has connected, waiting " & Floor(Floor($g_iAnotherDeviceWaitTime / 60) / 60) & " hours " & Floor(Mod(Floor($g_iAnotherDeviceWaitTime / 60), 60)) & " minutes " & Floor(Mod($g_iAnotherDeviceWaitTime, 60)) & " seconds", $COLOR_ERROR)
				PushMsg("AnotherDevice3600")
			ElseIf $g_iAnotherDeviceWaitTime > 60 Then
				SetLog("Another Device has connected, waiting " & Floor(Mod(Floor($g_iAnotherDeviceWaitTime / 60), 60)) & " minutes " & Floor(Mod($g_iAnotherDeviceWaitTime, 60)) & " seconds", $COLOR_ERROR)
				PushMsg("AnotherDevice60")
			Else
				SetLog("Another Device has connected, waiting " & Floor(Mod($g_iAnotherDeviceWaitTime, 60)) & " seconds", $COLOR_ERROR)
				PushMsg("AnotherDevice")
			EndIf
			If _SleepStatus($g_iAnotherDeviceWaitTime * 1000) Then Return ; Wait as long as user setting in GUI, default 120 seconds
			checkObstacles_ReloadCoC($aReloadButton, "#0127")
			If $g_bForceSinglePBLogoff Then $g_bGForcePBTUpdate = True
			checkObstacles_ResetSearch()
			Return True
		EndIf
		;;;;;;;##### 2- Take a break #####;;;;;;;

		If UBound(decodeSingleCoord(FindImageInPlace("Break", $g_sPersonalBreak, "165,287,335,325", False))) > 1 Then ; used for all 3 different break messages
			SetLog("Village must take a break, wait ...", $COLOR_ERROR)
			PushMsg("TakeBreak")
			If _SleepStatus($DELAYCHECKOBSTACLES4) Then Return ; 2 Minutes
			checkObstacles_ReloadCoC($aReloadButton, "#0128") ;Click on reload button
			If $g_bForceSinglePBLogoff Then $g_bGForcePBTUpdate = True
			checkObstacles_ResetSearch()
			Return True
		EndIf
		;;;;;;;##### Connection Lost & OoS & Inactive & Maintenance #####;;;;;;;
		Select
			Case _CheckPixel($aIsInactive, $g_bNoCapturePixel) ; Inactive only
				SetLog("Village was Inactive, Reloading CoC...", $COLOR_ERROR)
				If $g_bForceSinglePBLogoff Then $g_bGForcePBTUpdate = True
			Case _CheckPixel($aIsConnectLost, $g_bNoCapturePixel) ; Connection Lost
				;  Add check for banned account :(
				$Result = getOcrMaintenanceTime(171, 358 + $g_iMidOffsetY, "Check Obstacles OCR 'policy at super'=") ; OCR text for "policy at super"
				If StringInStr($Result, "policy", $STR_NOCASESENSEBASIC) Then
					$msg = "Sorry but account has been banned, Bot must stop!!"
					BanMsgBox()
					Return checkObstacles_StopBot($msg)
				EndIf
				$Result = getOcrMaintenanceTime(171, 337 + $g_iMidOffsetY, "Check Obstacles OCR 'prohibited 3rd'= ") ; OCR text for "prohibited 3rd party"
				If StringInStr($Result, "3rd", $STR_NOCASESENSEBASIC) Then
					$msg = "Sorry but account has been banned, Bot must stop!!"
					BanMsgBox()
					Return checkObstacles_StopBot($msg) ; stop bot
				EndIf
				SetLog("Connection lost, Reloading CoC...", $COLOR_ERROR)
			Case _CheckPixel($aIsCheckOOS, $g_bNoCapturePixel) ; Check OoS
				SetLog("Out of Sync Error, Reloading CoC...", $COLOR_ERROR)
			Case _CheckPixel($aIsMaintenance, $g_bNoCapturePixel) ; Check Maintenance
				$Result = getOcrMaintenanceTime(171, 345 + $g_iMidOffsetY, "Check Obstacles OCR Maintenance Break=") ; OCR text to find wait time
				Local $iMaintenanceWaitTime = 0
				Select
					Case $Result = ""
						$iMaintenanceWaitTime = $DELAYCHECKOBSTACLES4 ; Wait 2 min
					Case StringInStr($Result, "few", $STR_NOCASESENSEBASIC)
						$iMaintenanceWaitTime = $DELAYCHECKOBSTACLES4 ; Wait 2 min
					Case StringInStr($Result, "10", $STR_NOCASESENSEBASIC)
						$iMaintenanceWaitTime = $DELAYCHECKOBSTACLES6 ; Wait 5 min
					Case StringInStr($Result, "15", $STR_NOCASESENSEBASIC)
						$iMaintenanceWaitTime = $DELAYCHECKOBSTACLES6 ; Wait 5 min
					Case StringInStr($Result, "20", $STR_NOCASESENSEBASIC)
						$iMaintenanceWaitTime = $DELAYCHECKOBSTACLES7 ; Wait 10 min
					Case StringInStr($Result, "30", $STR_NOCASESENSEBASIC)
						$iMaintenanceWaitTime = $DELAYCHECKOBSTACLES8 ; Wait 15 min
					Case StringInStr($Result, "45", $STR_NOCASESENSEBASIC)
						$iMaintenanceWaitTime = $DELAYCHECKOBSTACLES9 ; Wait 20 min
					Case StringInStr($Result, "hour", $STR_NOCASESENSEBASIC)
						$iMaintenanceWaitTime = $DELAYCHECKOBSTACLES10 ; Wait 30 min
					Case Else
						$iMaintenanceWaitTime = $DELAYCHECKOBSTACLES4 ; Wait 2 min
						SetLog("Error reading Maintenance Break time?", $COLOR_ERROR)
				EndSelect
				SetLog("Maintenance Break, waiting: " & $iMaintenanceWaitTime / 60000 & " minutes....", $COLOR_ERROR)
				If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertMaintenance = True Then NotifyPushToBoth("Maintenance Break, waiting: " & $iMaintenanceWaitTime / 60000 & " minutes....")
				If $g_bForceSinglePBLogoff Then $g_bGForcePBTUpdate = True
				If _SleepStatus($iMaintenanceWaitTime) Then Return
				checkObstacles_ResetSearch()
			Case Else
				;  Add check for game update and Rate CoC error messages
				If $g_iDebugImageSave = 1 Then DebugImageSave("ChkObstaclesReloadMsg_") ; debug only
				$Result = getOcrRateCoc(228, 390 + $g_iMidOffsetY, "Check Obstacles getOCRRateCoC= ")
				If StringInStr($Result, "never", $STR_NOCASESENSEBASIC) Or UBound(decodeSingleCoord(FindImageInPlace("RateNever", $g_sAppRateNever, "228,420,273,448", False))) > 1 Then
					SetLog("Clash feedback window found, permanently closed!", $COLOR_ERROR)
					PureClick(248, 408 + $g_iMidOffsetY, 1, 0, "#9999") ; Click on never to close window and stop reappear. Never=248,408 & Later=429,408
					$g_bMinorObstacle = True
					Return True
				EndIf
				$Result = getOcrMaintenanceTime(171, 325 + $g_iMidOffsetY, "Check Obstacles OCR 'Good News!'=") ; OCR text for "Good News!"
				If StringInStr($Result, "new", $STR_NOCASESENSEBASIC) Then
					$msg = "Game Update is required, Bot must stop!!"
					Return checkObstacles_StopBot($msg) ; stop bot
				ElseIf StringInStr($Result, "rate", $STR_NOCASESENSEBASIC) Then ; back up check for rate CoC reload window
					SetLog("Clash feedback window found, permanently closed!", $COLOR_ERROR)
					PureClick(248, 408 + $g_iMidOffsetY, 1, 0, "#9999") ; Click on never to close window and stop reappear. Never=248,408 & Later=429,408
					$g_bMinorObstacle = True
					Return True
				EndIf
				;  Add check for banned account :(
				$Result = getOcrMaintenanceTime(171, 358 + $g_iMidOffsetY, "Check Obstacles OCR 'policy at super'=") ; OCR text for "policy at super"
				If StringInStr($Result, "policy", $STR_NOCASESENSEBASIC) Then
					$msg = "Sorry but account has been banned, Bot must stop!!"
					BanMsgBox()
					Return checkObstacles_StopBot($msg) ; stop bot
				EndIf
				$Result = getOcrMaintenanceTime(171, 337 + $g_iMidOffsetY, "Check Obstacles OCR 'prohibited 3rd'= ") ; OCR text for "prohibited 3rd party"
				If StringInStr($Result, "3rd", $STR_NOCASESENSEBASIC) Then
					$msg = "Sorry but account has been banned, Bot must stop!!"
					BanMsgBox()
					Return checkObstacles_StopBot($msg) ; stop bot
				EndIf
				SetLog("Warning: Can not find type of Reload error message", $COLOR_ERROR)
		EndSelect
		Return checkObstacles_ReloadCoC($aReloadButton, "#0131") ; Click for out of sync or inactivity or connection lost or maintenance
	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	If TestCapture() = 0 And GetAndroidProcessPID() = 0 Then
		; CoC not running
		Return checkObstacles_ReloadCoC()
	EndIf
	Local $bHasTopBlackBar = _ColorCheck(_GetPixelColor(10, 3), Hex(0x000000, 6), 1) And _ColorCheck(_GetPixelColor(300, 6), Hex(0x000000, 6), 1) And _ColorCheck(_GetPixelColor(600, 9), Hex(0x000000, 6), 1)
	If _ColorCheck(_GetPixelColor(235, 209 + $g_iMidOffsetY), Hex(0x9E3826, 6), 20) Then
		SetDebugLog("checkObstacles: Found Window to close")
		PureClick(429, 493 + $g_iMidOffsetY, 1, 0, "#0132") ;See if village was attacked, clicks Okay
		$g_abNotNeedAllTime[0] = True
		$g_abNotNeedAllTime[1] = True
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf
	If Not $bHasTopBlackBar And _CheckPixel($aIsMainGrayed, $g_bNoCapturePixel) Then
		SetDebugLog("checkObstacles: Found gray Window to close")
		PureClickP($aAway, 1, 0, "#0133") ;Click away If things are open
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf
	If _ColorCheck(_GetPixelColor(792, 39), Hex(0xDC0408, 6), 20) Then
		SetDebugLog("checkObstacles: Found Window with Close Button to close")
		PureClick(792, 39, 1, 0, "#0134") ;Clicks X
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf
	If _CheckPixel($aCancelFight, $g_bNoCapturePixel) Or _CheckPixel($aCancelFight2, $g_bNoCapturePixel) Then
		SetDebugLog("checkObstacles: Found Cancel Fight to close")
		PureClickP($aCancelFight, 1, 0, "#0135") ;Clicks X
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf
	If _CheckPixel($aChatTab, $g_bNoCapturePixel) Then
		SetDebugLog("checkObstacles: Found Chat Tab to close")
		PureClickP($aChatTab, 1, 0, "#0136") ;Clicks chat tab
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	If _CheckPixel($aEndFightSceneBtn, $g_bNoCapturePixel) Then
		SetDebugLog("checkObstacles: Found End Fight Scene to close")
		PureClickP($aEndFightSceneBtn, 1, 0, "#0137") ;If in that victory or defeat scene
		Return True
	EndIf
	If _CheckPixel($aSurrenderButton, $g_bNoCapturePixel) Then
		SetDebugLog("checkObstacles: Found End Battle to close")
		ReturnHome(False, False) ;If End battle is available
		Return True
	EndIf
	If _CheckPixel($aNoCloudsAttack, $g_bNoCapturePixel) Then ; Prevent drop of troops while searching
		$aMessage = _PixelSearch(23, 566 + $g_iBottomOffsetY, 36, 580 + $g_iBottomOffsetY, Hex(0xF4F7E3, 6), 10)
		If IsArray($aMessage) Then
			SetDebugLog("checkObstacles: Found Return Home button")
			; If _ColorCheck(_GetPixelColor(67,  602 + $g_iBottomOffsetY), Hex(0xDCCCA9, 6), 10) = False Then  ; add double check?
			PureClick(67, 602 + $g_iBottomOffsetY, 1, 0, "#0138") ;Check if Return Home button available
			If _Sleep($DELAYCHECKOBSTACLES2) Then Return
			Return True
		EndIf
	EndIf
	If IsPostDefenseSummaryPage() Then
		$aMessage = _PixelSearch(23, 566 + $g_iBottomOffsetY, 36, 580 + $g_iBottomOffsetY, Hex(0xE0E1CE, 6), 10)
		If IsArray($aMessage) Then
			SetDebugLog("checkObstacles: Found Post Defense Summary to close")
			PureClick(67, 602 + $g_iBottomOffsetY, 1, 0, "#0138") ;Check if Return Home button available
			If _Sleep($DELAYCHECKOBSTACLES2) Then Return
			Return True
		EndIf
	EndIf

	Local $CSFoundCoords = decodeSingleCoord(FindImageInPlace("CocStopped", $g_sCocStopped, "250,358,618,432", False))
	If UBound($CSFoundCoords) > 1 Then
		SetLog("CoC Has Stopped Error .....", $COLOR_ERROR)
		If TestCapture() Then Return "CoC Has Stopped Error ....."
		PushMsg("CoCError")
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		;PureClick(250 + $x, 328 + $g_iMidOffsetY + $y, 1, 0, "#0129");Check for "CoC has stopped error, looking for OK message" on screen
		PureClick($CSFoundCoords[0], $CSFoundCoords[1], 1, 0, "#0129") ;Check for "CoC has stopped error, looking for OK message" on screen
		If _Sleep($DELAYCHECKOBSTACLES2) Then Return
		Return checkObstacles_ReloadCoC()
	EndIf

	If $bHasTopBlackBar Then
		; if black bar at top, e.g. in Android home screen, restart CoC
		SetDebugLog("checkObstacles: Found Android Screen")
	EndIf
	Return False
EndFunc   ;==>_checkObstacles

; It's more stable to restart CoC app than click the message restarting the game
Func checkObstacles_ReloadCoC($point = $aAway, $debugtxt = "")
	;PureClickP($point, 1, 0, $debugtxt)
	If TestCapture() Then Return "Reload CoC"
	OcrForceCaptureRegion(True)
	CloseCoC(True)
	If _Sleep($DELAYCHECKOBSTACLES3) Then Return
	Return True
EndFunc   ;==>checkObstacles_ReloadCoC

Func checkObstacles_StopBot($msg)
	SetLog($msg, $COLOR_ERROR)
	If ($g_bNotifyPBEnable = True Or $g_bNotifyTGEnable = True) And $g_bNotifyAlertMaintenance = True Then NotifyPushToBoth($msg)
	If TestCapture() Then Return $msg
	OcrForceCaptureRegion(True)
	Btnstop() ; stop bot
	Return True
EndFunc   ;==>checkObstacles_StopBot

Func checkObstacles_ResetSearch()
	; reset fast restart flags to ensure base is rearmed after error event that has base offline for long duration, like PB or Maintenance
	$g_bIsClientSyncError = False
	$g_bIsSearchLimit = False
	$g_abNotNeedAllTime[0] = True
	$g_abNotNeedAllTime[1] = True
	$g_bRestart = True ; signal all calling functions to return to runbot
EndFunc   ;==>checkObstacles_ResetSearch

Func BanMsgBox()
	Local $MsgBox
	Local $stext = "Sorry, your account is banned!!" & @CRLF & "Bot will stop now..."
	While 1
		PushMsg("BAN")
		_ExtMsgBoxSet(4, 1, 0x004080, 0xFFFF00, 20, "Comic Sans MS", 600)
		$MsgBox = _ExtMsgBox(48, "Ok", "Banned", $stext, 1)
		If $MsgBox = 1 Then Return
		_ExtMsgBoxSet(4, 1, 0xFFFF00, 0x004080, 20, "Comic Sans MS", 600)
		$MsgBox = _ExtMsgBox(48, "Ok", "Banned", $stext, 1)
		If $MsgBox = 1 Then Return
	WEnd
EndFunc   ;==>BanMsgBox

Func checkObstacles_Network($bForceCapture = False, $bReloadCoC = True)
	Static $hCocReconnectingTimer = 0 ; TimerHandle of first CoC reconnecting animation

	If UBound(decodeSingleCoord(FindImageInPlace("CocReconnecting", $g_sCocReconnecting, "420,355,440,375", $bForceCapture))) > 1 Then
		If $hCocReconnectingTimer = 0 Then
			SetLog("Network Connection lost...", $COLOR_ERROR)
			$hCocReconnectingTimer = __TimerInit()
		ElseIf __TimerDiff($hCocReconnectingTimer) > $g_iCoCReconnectingTimeout Then
			SetLog("Network Connection really lost, Reloading CoC...", $COLOR_ERROR)
			$hCocReconnectingTimer = 0
			If $bReloadCoC = True Then Return checkObstacles_ReloadCoC()
			Return True
		Else
			SetLog("Network Connection lost, waiting...", $COLOR_ERROR)
		EndIf
	Else
		$hCocReconnectingTimer = 0
	EndIf

	Return False
EndFunc   ;==>checkObstacles_Network
