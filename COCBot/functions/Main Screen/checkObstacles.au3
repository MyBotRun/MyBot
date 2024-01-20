; #FUNCTION# ====================================================================================================================
; Name ..........: checkObstacles
; Description ...: Checks whether something is blocking the pixel for mainscreen and tries to unblock
; Syntax ........: checkObstacles()
; Parameters ....:
; Return values .: Returns True when there is something blocking
; Author ........: Hungle (2014)
; Modified ......: KnowJack (2015), Sardo (08-2015), TheMaster1st(10-2015), MonkeyHunter (08-2016), MMHK (12-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func checkObstacles($bBuilderBase = Default) ;Checks if something is in the way for mainscreen
	FuncEnter(checkObstacles)
	If $bBuilderBase = Default Then $bBuilderBase = $g_bStayOnBuilderBase
	Static $iRecursive = 0

	If UBound(decodeSingleCoord(FindImageInPlace2("Update", $g_sImgCOCUpdate, 220, 165 + $g_iMidOffsetY, 350, 260 + $g_iMidOffsetY, True))) > 1 Or _
			UBound(decodeSingleCoord(FindImageInPlace2("UpdateNew", $g_sImgCOCUpdate, 350, 370 + $g_iMidOffsetY, 510, 450 + $g_iMidOffsetY, True))) > 1 Then ; COC Minor Update
		SetLog("Chief, we have COC Update!", $COLOR_INFO)
		ClickAway()
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
	EndIf

	If Not TestCapture() And WinGetAndroidHandle() = 0 Then
		; Android not available
		Return FuncReturn(True)
	ElseIf TestCapture() = 0 And GetAndroidProcessPID() = 0 Then
		; CoC not running
		Return checkObstacles_ReloadCoC() ; just start CoC (but first close it!)
	EndIf
	Local $wasForce = OcrForceCaptureRegion(False)
	$iRecursive += 1
	Local $Result = _checkObstacles($bBuilderBase, $iRecursive > 5)
	OcrForceCaptureRegion($wasForce)
	$iRecursive -= 1
	Return FuncReturn($Result)
EndFunc   ;==>checkObstacles

Func _checkObstacles($bBuilderBase = False, $bRecursive = False) ;Checks if something is in the way for mainscreen
	Local $msg, $x, $y, $Result
	$g_bMinorObstacle = False
	Local $aMessage
	Local $b_Switch = False

	_CaptureRegions()

	If Not $bRecursive Then
		If checkObstacles_Network() Then Return True
		If checkObstacles_GfxError() Then Return True
	EndIf

	If _ColorCheck(_GetPixelColor(810, 185 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0x892B1F, 6), 20) Then
		SetDebugLog("checkObstacles: Found Window to close")
		PureClick(440, 510 + $g_iMidOffsetY, 1, 0, "#0132") ;See if village was attacked or upgrades finished : Click Okay
		$g_abNotNeedAllTime[0] = True
		$g_abNotNeedAllTime[1] = True
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf

	Local $bIsOnBuilderBase = isOnBuilderBase()
	Local $bIsOnMainVillage = isOnMainVillage()
	If $bIsOnBuilderBase Or $bIsOnMainVillage Then
		Select
			Case $bBuilderBase And Not $bIsOnBuilderBase And $bIsOnMainVillage
				SetLog("Detected Main Village, trying to switch back to Builder Base")
				$b_Switch = True
			Case Not $bBuilderBase And $bIsOnBuilderBase And Not $bIsOnMainVillage
				SetLog("Detected Builder Base, trying to switch back to Main Village")
				$b_Switch = True
		EndSelect
		If $b_Switch Then
			If SwitchBetweenBases(True, $bBuilderBase) Then
				$g_bMinorObstacle = True
				If _Sleep($DELAYCHECKOBSTACLES1) Then Return
				Return False
			EndIf
		EndIf
	EndIf

	If UBound(decodeSingleCoord(FindImageInPlace2("Error", $g_sImgError, 630, 270 + $g_iMidOffsetY, 632, 290 + $g_iMidOffsetY, False))) > 1 Then

		;  Add check for banned account :(
		$Result = getOcrReloadMessage(171, 358 + $g_iMidOffsetY, "Check Obstacles OCR 'policy at super'=") ; OCR text for "policy at super"
		If StringInStr($Result, "policy", $STR_NOCASESENSEBASIC) Then
			$msg = "Sorry but account has been banned, Bot must stop!"
			BanMsgBox()
			Return checkObstacles_StopBot($msg) ; stop bot
		EndIf
		$Result = getOcrReloadMessage(171, 337 + $g_iMidOffsetY, "Check Obstacles OCR 'prohibited 3rd'= ") ; OCR text for "prohibited 3rd party"
		If StringInStr($Result, "3rd", $STR_NOCASESENSEBASIC) Then
			$msg = "Sorry but account has been banned, Bot must stop!"
			BanMsgBox()
			Return checkObstacles_StopBot($msg) ; stop bot
		EndIf

		If TestCapture() Then Return "Village is out of sync or inactivity or connection lost"

		;;;;;;;;;;;;;;;;;;;; Connection Lost & Error & OOS & Inactivity ;;;;;;;;;;;;;;;;;;;;
		Return CheckAllObstacles($g_bDebugImageSave, 0, 3, $bRecursive)
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	EndIf

	;;;;;;;;;;;;;;;;;;;; Google Play Or COC Error ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	If CheckAllObstacles($g_bDebugImageSave, 4, 5, $bRecursive) Then Return True
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	If UBound(decodeSingleCoord(FindImageInPlace2("Maintenance", $g_sImgMaintenance, 250, 40, 500, 100 + $g_iMidOffsetY, False))) > 1 Then ; Maintenance Break
		$Result = getOcrMaintenanceTime(285, 581 + $g_iMidOffsetY, "Check Obstacles OCR Maintenance Break=") ; OCR text to find wait time
		Local $iMaintenanceWaitTime = 0
		Local $avTime = StringRegExp($Result, "([\d]+)[Mm]|(soon)|([\d]+[Hh])", $STR_REGEXPARRAYMATCH)
		If UBound($avTime, 1) = 1 And Not @error Then
			If UBound($avTime, 1) = 3 Then
				$iMaintenanceWaitTime = $DELAYCHECKOBSTACLES10
			Else
				$iMaintenanceWaitTime = Int($avTime[0]) * 60000
				If $iMaintenanceWaitTime > $DELAYCHECKOBSTACLES10 Then $iMaintenanceWaitTime = $DELAYCHECKOBSTACLES10
			EndIf
		Else
			$iMaintenanceWaitTime = $DELAYCHECKOBSTACLES4 ; Wait 2 min
			$Result = getOcrMaintenanceTime(82, 581 + $g_iMidOffsetY, "Check Obstacles OCR Maintenance Break=")
			If StringInStr($Result, "soon", $STR_NOCASESENSEBASIC) Then
				SetLog("End Of Maintenance Break : Soon!, Waiting 2 Minutes", $COLOR_SUCCESS1)
			Else
				If @error Then SetLog("Error reading Maintenance Break time?", $COLOR_ERROR)
			EndIf
		EndIf
		SetLog("Maintenance Break, waiting: " & $iMaintenanceWaitTime / 60000 & " minutes", $COLOR_ERROR)
		If $g_bNotifyTGEnable And $g_bNotifyAlertMaintenance = True Then NotifyPushToTelegram("Maintenance Break, waiting: " & $iMaintenanceWaitTime / 60000 & " minutes....")
		If _SleepStatus($iMaintenanceWaitTime) Then Return
		If ClickB("ReloadButton") Then SetLog("Trying to reload game after maintenance break", $COLOR_INFO)
		checkObstacles_ResetSearch()
	EndIf

	If UBound(decodeSingleCoord(FindImageInPlace2("CCResults", $g_sImgClanCapitalResults, 210, 130 + $g_iMidOffsetY, 320, 240 + $g_iMidOffsetY, False))) > 1 Then ; Clan Capital Results
		If _ColorCheck(_GetPixelColor(232, 312 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0xFFFFFF, 6), 10) And _ColorCheck(_GetPixelColor(664, 242 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0xFFFFFF, 6), 10) Then
			$g_bMinorObstacle = True
			CloseWindow()
			Return False
		EndIf
	EndIf

	Local $bHasTopBlackBar = _ColorCheck(_GetPixelColor(10, 3, $g_bCapturePixel), Hex(0x000000, 6), 1) And _ColorCheck(_GetPixelColor(300, 6, $g_bCapturePixel), Hex(0x000000, 6), 1) And _
			_ColorCheck(_GetPixelColor(600, 9, $g_bCapturePixel), Hex(0x000000, 6), 1)
	If Not $bHasTopBlackBar And _CheckPixel($aIsMainGrayed, $g_bCapturePixel) Then
		SetDebugLog("checkObstacles: Found gray Window to close")
		PureClickP($aAway, 1, 0, "#0133") ;Click away If things are open
		If _Sleep(1000) Then Return
		If _CheckPixel($aIsMain, $g_bCapturePixel) Then
			$g_bMinorObstacle = True
			If _Sleep($DELAYCHECKOBSTACLES1) Then Return
			Return False
		Else
			If _CheckPixel($aIsMainGrayed, $g_bCapturePixel) Then
				SetDebugLog("checkObstacles: Still found gray Window to close, trying to close again")
				Local $bLoop = 0
				While 1
					PureClickP($aAway, 1, 0, "#0133") ;Click away If things are open
					If _Sleep(1500) Then ExitLoop
					If _CheckPixel($aIsMain, $g_bCapturePixel) Then ExitLoop
					$bLoop += 1
					If $bLoop = 10 Then ExitLoop
				WEnd
			EndIf
		EndIf
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf
	If Not $bHasTopBlackBar And _CheckPixel($aIsBuilderBaseGrayed, $g_bCapturePixel) Then
		SetLog("checkObstacles: Found Builder Base gray Window to close")
		ClickAway("Left")
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf
	If _ColorCheck(_GetPixelColor(792, 39, $g_bCapturePixel), Hex(0xDC0408, 6), 20) Then
		SetDebugLog("checkObstacles: Found Window with Close Button to close")
		PureClick(792, 39, 1, 0, "#0134") ;Clicks X
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf
	If _CheckPixel($aCancelFight, $g_bCapturePixel) Or _CheckPixel($aCancelFight2, $g_bCapturePixel) Then
		SetDebugLog("checkObstacles: Found Cancel Fight to close")
		PureClickP($aCancelFight, 1, 0, "#0135") ;Clicks X
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf
	If _CheckPixel($aChatTab, $g_bCapturePixel) And _CheckPixel($aChatTab2, $g_bCapturePixel) And _CheckPixel($aChatTab3, $g_bCapturePixel) Then
		SetDebugLog("checkObstacles: Found Chat Tab to close")
		PureClickP($aChatTab, 1, 0, "#0136") ;Clicks chat tab
		$g_bMinorObstacle = True
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		Return False
	EndIf
	If _CheckPixel($aEndFightSceneBtn, $g_bCapturePixel) Then
		SetDebugLog("checkObstacles: Found End Fight Scene to close")
		PureClickP($aEndFightSceneBtn, 1, 0, "#0137") ;If in that victory or defeat scene
		Return True
	EndIf
	If _CheckPixel($aSurrenderButton, $g_bCapturePixel) Then
		SetDebugLog("checkObstacles: Found End Battle to close")
		ReturnHome(False, False) ;If End battle is available
		Return True
	EndIf
	If _CheckPixel($aNoCloudsAttack, $g_bCapturePixel) Then ; Prevent drop of troops while searching
		$aMessage = _PixelSearch(23, 566 + $g_iBottomOffsetY, 36, 580 + $g_iBottomOffsetY, Hex(0xF4F7E3, 6), 10, True)
		If IsArray($aMessage) Then
			SetDebugLog("checkObstacles: Found Return Home button")
			PureClick(67, 602 + $g_iBottomOffsetY, 1, 0, "#0138") ;Check if Return Home button available
			If _Sleep($DELAYCHECKOBSTACLES2) Then Return
			Return True
		EndIf
	EndIf
	If IsPostDefenseSummaryPage() Then
		$aMessage = _PixelSearch(23, 566 + $g_iBottomOffsetY, 36, 580 + $g_iBottomOffsetY, Hex(0xEBECDB, 6), 10, True)
		If IsArray($aMessage) Then
			SetDebugLog("checkObstacles: Found Post Defense Summary to close")
			PureClick(62, 607 + $g_iBottomOffsetY, 1, 0, "#0138") ;Check if Return Home button available
			If _Sleep($DELAYCHECKOBSTACLES2) Then Return
			Return True
		EndIf
	EndIf

	Local $CSFoundCoords = decodeSingleCoord(FindImageInPlace2("CocStopped", $g_sImgCocStopped, 250, 328 + $g_iMidOffsetY, 618, 402 + $g_iMidOffsetY, True))
	If UBound($CSFoundCoords) > 1 Then
		SetLog("CoC Has Stopped Error .....", $COLOR_ERROR)
		If TestCapture() Then Return "CoC Has Stopped Error ....."
		PushMsg("CoCError")
		If _Sleep($DELAYCHECKOBSTACLES1) Then Return
		PureClick($CSFoundCoords[0], $CSFoundCoords[1], 1, 0, "#0129") ;Check for "CoC has stopped error, looking for OK message" on screen
		If _Sleep($DELAYCHECKOBSTACLES2) Then Return
		Return checkObstacles_ReloadCoC($bRecursive)
	EndIf

	If $bHasTopBlackBar Then
		; if black bar at top, e.g. in Android home screen, restart CoC
		SetDebugLog("checkObstacles: Found Black Android Screen")
	EndIf

	If CheckLoginWithSupercellIDScreen() Then Return True

	Return False
EndFunc   ;==>_checkObstacles

; It's more easy to restart CoC app than click the message restarting the game :/
Func checkObstacles_ReloadCoC($bRecursive = False)
	If TestCapture() Then Return "Reload CoC"
	ForceCaptureRegion(True)
	OcrForceCaptureRegion(True)

	If ProfileSwitchAccountEnabled() And $g_bChkSharedPrefs And HaveSharedPrefs() Then
		PushSharedPrefs()
		If Not $bRecursive Then OpenCoC()
		Return True
	EndIf

	If Not $bRecursive Then CloseCoC(True)

	If _Sleep($DELAYCHECKOBSTACLES3) Then Return
	Return True
EndFunc   ;==>checkObstacles_ReloadCoC

; It's more easy to restart Emu than click the message restarting the game :/
Func checkObstacles_RebootAndroid($IsGfx = True, $IsNetwork = False, $IsErrorWindow = False)
	If TestCapture() Then Return "Reboot Android"
	ForceCaptureRegion(True)
	OcrForceCaptureRegion(True)
	$g_bGfxError = $IsGfx
	$g_bNetworkError = $IsNetwork
	$g_bErrorWindow = $IsErrorWindow
	CheckAndroidReboot()
	Return True
EndFunc   ;==>checkObstacles_RebootAndroid

Func checkObstacles_StopBot($msg)
	SetLog($msg, $COLOR_ERROR)
	If TestCapture() Then Return $msg
	If $g_bNotifyTGEnable And $g_bNotifyAlertMaintenance Then NotifyPushToTelegram($msg)
	OcrForceCaptureRegion(True)
	Btnstop() ; stop bot
	Return True
EndFunc   ;==>checkObstacles_StopBot

Func checkObstacles_ResetSearch()
	; reset fast restart flags to ensure base is rearmed after error event that has base offline for long duration, like Maintenance
	$g_bIsClientSyncError = False
	$g_bIsSearchLimit = False
	$g_abNotNeedAllTime[0] = True
	$g_abNotNeedAllTime[1] = True
	$g_bRestart = True ; signal all calling functions to return to runbot
EndFunc   ;==>checkObstacles_ResetSearch

Func BanMsgBox()
	Local $MsgBox
	Local $stext = "Sorry, your account is banned!!" & @CRLF & "Bot will stop now..."
	If TestCapture() Then Return $stext
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

	If UBound(decodeSingleCoord(FindImageInPlace2("CocReconnecting", $g_sImgCocReconnecting, 420, 325 + $g_iMidOffsetY, 440, 345 + $g_iMidOffsetY, False))) > 1 Then
		If $hCocReconnectingTimer = 0 Then
			SetLog("Network Connection lost...", $COLOR_ERROR)
			$hCocReconnectingTimer = __TimerInit()
		ElseIf __TimerDiff($hCocReconnectingTimer) > $g_iCoCReconnectingTimeout Then
			SetLog("Network Connection really lost, Reloading Android...", $COLOR_ERROR)
			$hCocReconnectingTimer = 0
			If $bReloadCoC = True Then Return checkObstacles_RebootAndroid(False, True, False)
			Return True
		Else
			SetLog("Network Connection lost, waiting...", $COLOR_ERROR)
		EndIf
	Else
		$hCocReconnectingTimer = 0
	EndIf

	Return False
EndFunc   ;==>checkObstacles_Network

Func checkObstacles_GfxError($bForceCapture = False, $bRebootAndroid = True)
	Local $aResult = decodeMultipleCoords(FindImage("GfxError", $g_sImgGfxError, "ECD", 100, $bForceCapture), 100, 100)
	If UBound($aResult) >= 8 Then
		SetLog(UBound($aResult) & " Gfx Errors detected, Reloading Android...", $COLOR_ERROR)
		; Save debug image
		SaveDebugImage("GfxError", False)
		If $bRebootAndroid Then Return checkObstacles_RebootAndroid(True, False, False)
		Return True
	EndIf

	Return False
EndFunc   ;==>checkObstacles_GfxError

Func ClashOfMagicAdvert($bDebugImageSave = $g_bDebugImageSave)
	; Initial Timer
	Local $hTimer = TimerInit()

	SetDebugLog("Searching for Clash Of Magic Advert ...", $COLOR_DEBUG)

	Local $aiClashOfMagicAdvert = decodeSingleCoord(FindImageInPlace2("ClashOfMagicAdvert", $sImgClashOfMagicAdvert, 820, 10, 850, 35, False))

	If $bDebugImageSave Then SaveDebugRectImage("ClashOfMagicAdvert", "820,10,850,35")

	If IsArray($aiClashOfMagicAdvert) And UBound($aiClashOfMagicAdvert, 1) = 2 Then
		SetLog("Detected Clash Of Magic Advert! (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)

		If _Sleep(500) Then Return

		ClickP($aiClashOfMagicAdvert)

		Return True
	EndIf

	SetDebugLog("No Clash Of Magic Advert found! (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)

	Return False
EndFunc   ;==>ClashOfMagicAdvert

Func CheckAllObstacles($bDebugImageSave = $g_bDebugImageSave, $MinType = 0, $MaxType = 5, $bRecursive = False)

	Local $bRet = False, $Ref
	Local $aiIsAnotherDevice = False

	;;;;;;;;;;;;;;;;;;;;;;;;; Obstacle Types ;;;;;;;;;;;;;;;;;;;;;;;;;
	;; 0 : Connection Lost, Error, Another Device, Inactivity Or Login Failed Then Click "Try Again" Or "Reload" Or "Reload Game"
	;; 1 : Error! (Out of Sync)/OOS Then Click on "Reload Game"
	;; 2 : Rate Clash Of Clans Then click On "Never"
	;; 3 : Important Notice Then Click On "OK"
	;; 4 : Google Play Services Has Stopped Then Click on "OK"
	;; 5 : Clash Of Clan isn't responding Then Reboot Emulator
	;; 6 : Another Device Connected Then Wait $g_iAnotherDeviceWaitTime Then Click on "Reload"

	Local $aiObstacleType[7][7] = [["", "Detected Connection Lost!", $sImgConnectionLost, 170, 260, 400, 320], _
			["", "Detected Out Of Sync!", $sImgOos, 330, 310, 460, 350], _
			["", "Detected Rate Game!", $sImgRateGame, 170, 260, 400, 320], _
			["", "Detected Important Notice!", $sImgNotice, 170, 250, 400, 300], _
			["", "Detected Google Play Services Has Stopped!", $sImgGPServices, 280, 300, 410, 340], _
			["", "Detected COC isn't Responding!!", $sImgClashNotResponding, 210, 240, 360, 310], _
			["", "Detected Another Device Connected!!", $sImgDevice, 220, 300, 360, 360]]

	Local $aiButtonType[4][6] = [["", $sImgReloadBtn, 170, 365, 330, 420], _
			["", $sImgNeverBtn, 540, 365, 700, 420], _
			["", $sImgOKBtn, 170, 370, 270, 430], _
			["", $sImgOKBtn, 630, 355, 700, 385]]

	; Initial Timer
	Local $hTimer = TimerInit()

	For $i = $MinType To $MaxType

		$aiObstacleType[$i][0] = decodeSingleCoord(FindImageInPlace2("ErrorType", $aiObstacleType[$i][2], $aiObstacleType[$i][3], $aiObstacleType[$i][4] + _
				$g_iMidOffsetY, $aiObstacleType[$i][5], $aiObstacleType[$i][6] + $g_iMidOffsetY, False))

		If IsArray($aiObstacleType[$i][0]) And UBound($aiObstacleType[$i][0], 1) = 2 Then

			SetLog($aiObstacleType[$i][1] & " (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)

			If $i = 0 Then
				$aiObstacleType[6][0] = decodeSingleCoord(FindImageInPlace2("Device", $aiObstacleType[6][2], $aiObstacleType[6][3], $aiObstacleType[6][4] + _
						$g_iMidOffsetY, $aiObstacleType[6][5], $aiObstacleType[6][6] + $g_iMidOffsetY, False))
				If IsArray($aiObstacleType[6][0]) And UBound($aiObstacleType[6][0], 1) = 2 Then
					SetLog($aiObstacleType[6][1] & " (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
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
					$aiIsAnotherDevice = True
				EndIf
			ElseIf $i = 5 Then ;Clash Of Clan isn't responding Then Reboot Emulator
				checkObstacles_RebootAndroid(False, False, True)
				$bRet = True
				ExitLoop
			EndIf

			If _Sleep(100) Then Return

			SetDebugLog("Searching for Button ...", $COLOR_INFO)

			; Find OK, Reload, Try Again, Never, No Thanks buttons

			Switch $i
				;; 0 : Connection Lost, Error, Another Device, Inactivity Or Login Failed Then Click "Try Again" Or "Reload" Or "Reload Game"
				;; 1 : Error! (Out of Sync)/OOS Then Click on "Reload Game"
				Case 0 To 1
					$Ref = 0
					;; 2 : Rate Clash Of Clans Then click On "Never"
				Case 2
					$Ref = 1
					;; 3 : Important Notice Then Click On "OK"
				Case 3
					$Ref = 2
					;; 4 : Google Play Services Has Stopped Then Click on "OK"
				Case 4
					$Ref = 3
			EndSwitch

			$aiButtonType[$Ref][0] = decodeSingleCoord(FindImageInPlace2("Button", $aiButtonType[$Ref][1], $aiButtonType[$Ref][2], $aiButtonType[$Ref][3] + _
					$g_iMidOffsetY, $aiButtonType[$Ref][4], $aiButtonType[$Ref][5] + $g_iMidOffsetY, False))

			If IsArray($aiButtonType[$Ref][0]) And UBound($aiButtonType[$Ref][0], 1) = 2 Then

				If _Sleep(100) Then Return
				SetDebugLog("Found button....", $COLOR_SUCCESS1)
				SetDebugLog("Click Coords : " & ($aiButtonType[$Ref][0])[0] & "," & ($aiButtonType[$Ref][0])[1], $COLOR_ERROR)
				PureClickP($aiButtonType[$Ref][0])
				If _Sleep($DELAYCHECKOBSTACLES1) Then Return

				If $i = 0 And $aiIsAnotherDevice Then
					checkObstacles_ResetSearch()
				ElseIf $i > 1 Then ; > 1 : Error! (Out of Sync)/OOS Then Click on "Reload Game"
					$g_bMinorObstacle = True
					ExitLoop
				EndIf

			Else
				If $bDebugImageSave Then SaveDebugImage("CheckObstacles")
				SetDebugLog("Failed to find Button", $COLOR_DEBUG)

				If $i = 4 Then ; 4 : Google Play Services Has Stopped And "OK" Button Not Found
					checkObstacles_RebootAndroid(False, False, True)
				Else
					checkObstacles_ReloadCoC($bRecursive)
				EndIf

			EndIf

			$bRet = True
			ExitLoop

		Else

			If $i = 3 Then
				SetLog("Warning: Cannot find type of Reload error message", $COLOR_ERROR)
				If $bDebugImageSave Then SaveDebugImage("CheckObstacles")
				checkObstacles_ReloadCoC($bRecursive)
				$bRet = True
			EndIf

		EndIf

	Next

	SetDebugLog("No Obstacle Window found! (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_DEBUG)

	Return $bRet

EndFunc   ;==>CheckAllObstacles
