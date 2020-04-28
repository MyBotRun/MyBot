; #FUNCTION# ====================================================================================================================
; Name ..........: Switch Account
; Description ...: This file contains the Sequence that runs all MBR Bot
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: chalicucu (6/2016), demen (4/2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; Return True or False if Switch Account is enabled and current profile in configured list
Func ProfileSwitchAccountEnabled()
	If Not $g_bChkSwitchAcc Or Not aquireSwitchAccountMutex() Then Return False
	Return SetError(0, 0, _ArraySearch($g_asProfileName, $g_sProfileCurrentName) >= 0)
EndFunc   ;==>ProfileSwitchAccountEnabled

; Return True or False if specified Profile is enabled for Switch Account and controlled by this bot instance
Func SwitchAccountEnabled($IdxOrProfilename = $g_sProfileCurrentName)
	Local $sProfile
	Local $iIdx
	If IsInt($IdxOrProfilename) Then
		$iIdx = $IdxOrProfilename
		$sProfile = $g_asProfileName[$iIdx]
	Else
		$sProfile = $IdxOrProfilename
		$iIdx = _ArraySearch($g_asProfileName, $sProfile)
	EndIf

	If Not $sProfile Or $iIdx < 0 Or Not $g_abAccountNo[$iIdx] Then
		; not in list or not enabled
		Return False
	EndIf

	; check if mutex is or can be aquired
	Return aquireProfileMutex($sProfile) <> 0
EndFunc   ;==>SwitchAccountEnabled

; retuns copy of $g_abAccountNo validated with SwitchAccountEnabled
Func AccountNoActive()
	Local $a[UBound($g_abAccountNo)]

	For $i = 0 To UBound($g_abAccountNo) - 1
		$a[$i] = SwitchAccountEnabled($i)
	Next

	Return $a
EndFunc   ;==>AccountNoActive

Func InitiateSwitchAcc() ; Checking profiles setup in Mybot, First matching CoC Acc with current profile, Reset all Timers relating to Switch Acc Mode.
	If Not ProfileSwitchAccountEnabled() Or Not $g_bInitiateSwitchAcc Then Return
	UpdateMultiStats()
	$g_iNextAccount = -1
	SetLog("Switch Account enable for " & $g_iTotalAcc + 1 & " accounts")
	SetSwitchAccLog("Initiating: " & $g_iTotalAcc + 1 & " acc", $COLOR_SUCCESS)

	If Not $g_bRunState Then Return
	;Local $iCurProfile = _GUICtrlComboBox_GetCurSel($g_hCmbProfile)
	For $i = 0 To $g_iTotalAcc
		; listing all accounts
		Local $sBotType = "Idle"
		If $g_abAccountNo[$i] Then
			If SwitchAccountEnabled($i) Then
				$sBotType = "Active"
				If $g_abDonateOnly[$i] Then $sBotType = "Donate"
				If $g_iNextAccount = -1 Then $g_iNextAccount = $i
				If $g_asProfileName[$i] = $g_sProfileCurrentName Then $g_iNextAccount = $i
			Else
				$sBotType = "Other bot"
			EndIf
		EndIf
		SetLog("  - Account [" & $i + 1 & "]: " & $g_asProfileName[$i] & " - " & $sBotType)
		SetSwitchAccLog("  - Acc. " & $i + 1 & ": " & $sBotType)

		$g_abPBActive[$i] = False
	Next
	$g_iCurAccount = $g_iNextAccount ; make sure no crash
	SwitchAccountVariablesReload("Reset")
	SetLog("Let's start with Account [" & $g_iNextAccount + 1 & "]")
	SwitchCOCAcc($g_iNextAccount)
EndFunc   ;==>InitiateSwitchAcc

Func CheckSwitchAcc()
	Local $abAccountNo = AccountNoActive()
	If Not $g_bRunState Then Return
	Local $aActiveAccount = _ArrayFindAll($abAccountNo, True)
	If UBound($aActiveAccount) <= 1 Then Return

	Local $aDonateAccount = _ArrayFindAll($g_abDonateOnly, True)
	Local $bReachAttackLimit = ($g_aiAttackedCountSwitch[$g_iCurAccount] <= $g_aiAttackedCount - 2)
	Local $bForceSwitch = $g_bForceSwitch
	Local $nMinRemainTrain, $iWaitTime
	Local $aActibePBTaccounts = _ArrayFindAll($g_abPBActive, True)

	SetLog("Start Switch Account!", $COLOR_INFO)

	; Force Switch when PBT detected
	If $g_abPBActive[$g_iCurAccount] Then $bForceSwitch = True

	If $g_iCommandStop = 0 Or $g_iCommandStop = 3 Then ; Forced to switch when in halt attack mode
		SetLog("This account is in halt attack mode, switching to another account", $COLOR_ACTION)
		SetSwitchAccLog(" - Halt Attack, Force switch")
		$bForceSwitch = True
	ElseIf $g_iCommandStop = 1 Then
		SetLog("This account is turned off, switching to another account", $COLOR_ACTION)
		SetSwitchAccLog(" - Turn idle, Force switch")
		$bForceSwitch = True
	ElseIf $g_iCommandStop = 2 Then
		SetLog("This account is out of Attack Schedule, switching to another account", $COLOR_ACTION)
		SetSwitchAccLog(" - Off Schedule, Force switch")
		$bForceSwitch = True
	ElseIf $g_bWaitForCCTroopSpell Then
		SetLog("Still waiting for CC Troops/Spells, switching to another Account", $COLOR_ACTION)
		SetSwitchAccLog(" - Waiting for CC")
		$bForceSwitch = True
	ElseIf $g_bAllBarracksUpgd Then ;Check if all barrack are upgrading, no army can be train --> Force Switch account
		SetLog("Seems all your barracks are upgrading", $COLOR_INFO)
		SetLog("No troops can be trained, let's switch account", $COLOR_INFO)
		SetSwitchAccLog(" - All Barracks Upgrading, Force switch")
		$bForceSwitch = True
	Else
		getArmyTroopTime(True, False) ; update $g_aiTimeTrain[0]

		$g_aiTimeTrain[1] = 0
		If IsWaitforSpellsActive() Then getArmySpellTime() ; update $g_aiTimeTrain[1]

		$g_aiTimeTrain[2] = 0
		If IsWaitforHeroesActive() Then CheckWaitHero() ; update $g_aiTimeTrain[2]

		ClickP($aAway, 1, 0, "#0000") ;Click Away

		$iWaitTime = _ArrayMax($g_aiTimeTrain, 1, 0, 2) ; Not check Siege Machine time: $g_aiTimeTrain[3]
		If $bReachAttackLimit And $iWaitTime <= 0 Then
			SetLog("This account has attacked twice in a row, switching to another account", $COLOR_INFO)
			SetSwitchAccLog(" - Reach attack limit: " & $g_aiAttackedCount - $g_aiAttackedCountSwitch[$g_iCurAccount])
			$bForceSwitch = True
		EndIf
	EndIf

	Local $sLogSkip = ""
	If Not $g_abDonateOnly[$g_iCurAccount] And $iWaitTime <= $g_iTrainTimeToSkip And Not $bForceSwitch Then
		If Not $g_bRunState Then Return
		If $iWaitTime > 0 Then $sLogSkip = " in " & Round($iWaitTime, 1) & " mins"
		SetLog("Army is ready" & $sLogSkip & ", skip switching account", $COLOR_INFO)
		SetSwitchAccLog(" - Army is ready" & $sLogSkip)
		SetSwitchAccLog("Stay at [" & $g_iCurAccount + 1 & "]", $COLOR_SUCCESS)
		If _Sleep(500) Then Return

	Else

		If $g_bChkSmartSwitch = True Then ; Smart switch
			SetDebugLog("-Smart Switch-")
			$nMinRemainTrain = CheckTroopTimeAllAccount($bForceSwitch)

			If $nMinRemainTrain <= 1 And Not $bForceSwitch And Not $g_bDonateLikeCrazy Then ; Active (force switch shall give priority to Donate Account)
				If $g_bDebugSetlog Then SetDebugLog("Switch to or Stay at Active Account: " & $g_iNextAccount + 1, $COLOR_DEBUG)
				$g_iDonateSwitchCounter = 0
			Else
				If $g_iDonateSwitchCounter < UBound($aDonateAccount) Then ; Donate
					$g_iNextAccount = $aDonateAccount[$g_iDonateSwitchCounter]
					$g_iDonateSwitchCounter += 1
					If $g_bDebugSetlog Then SetDebugLog("Switch to Donate Account " & $g_iNextAccount + 1 & ". $g_iDonateSwitchCounter = " & $g_iDonateSwitchCounter, $COLOR_DEBUG)
					SetSwitchAccLog(" - Donate Acc [" & $g_iNextAccount + 1 & "]")
				Else ; Active
					$g_iDonateSwitchCounter = 0
				EndIf
			EndIf
		Else ; Normal switch (continuous)
			SetDebugLog("-Normal Switch-")
			$g_iNextAccount = $g_iCurAccount + 1
			If $g_iNextAccount > $g_iTotalAcc Then $g_iNextAccount = 0
			While $abAccountNo[$g_iNextAccount] = False
				$g_iNextAccount += 1
				If $g_iNextAccount > $g_iTotalAcc Then $g_iNextAccount = 0 ; avoid idle Account
				SetDebugLog("- While Account: " & $g_asProfileName[$g_iNextAccount] & " number: " & $g_iNextAccount + 1)
			WEnd
		EndIf

		If Not $g_bRunState Then Return

		SetDebugLog("- Current Account: " & $g_asProfileName[$g_iCurAccount] & " number: " & $g_iCurAccount + 1)
		SetDebugLog("- Next Account: " & $g_asProfileName[$g_iNextAccount] & " number: " & $g_iNextAccount + 1)

		; Check if the next account is PBT and IF the remain train time is more than 2 minutes
		If $g_abPBActive[$g_iNextAccount] And _DateDiff("n", _NowCalc(), $g_asTrainTimeFinish[$g_iNextAccount]) > 2 Then
			SetLog("Account " & $g_iNextAccount + 1 & " is in a Personal Break Time!", $COLOR_INFO)
			SetSwitchAccLog(" - Account " & $g_iNextAccount + 1 & " is in PTB")
			$g_iNextAccount = $g_iNextAccount + 1
			If $g_iNextAccount > $g_iTotalAcc Then $g_iNextAccount = 0
			While $abAccountNo[$g_iNextAccount] = False
				$g_iNextAccount += 1
				If $g_iNextAccount > $g_iTotalAcc Then $g_iNextAccount = 0 ; avoid idle Account
			WEnd
		EndIf

		If UBound($aActibePBTaccounts) + UBound($aDonateAccount) = UBound($aActiveAccount) Then
			SetLog("All accounts set to Donate and/or are in PBT!", $COLOR_INFO)
			SetSwitchAccLog("All accounts in PBT/Donate:")
			; Just a Good User Log
			For $i = 0 To $g_iTotalAcc
				If $g_abDonateOnly[$i] Then SetSwitchAccLog(" - Donate Acc [" & $i + 1 & "]")
				If $g_abPBActive[$i] Then SetSwitchAccLog(" - PBT Acc [" & $i + 1 & "]")
			Next
		EndIf

		If $g_iNextAccount <> $g_iCurAccount Then
			If $g_bRequestTroopsEnable And $g_bCanRequestCC Then
				If _Sleep(1000) Then Return
				SetLog("Try Request troops before switching account", $COLOR_INFO)
				RequestCC(True)
			EndIf
			If Not IsMainPage() Then checkMainScreen()
			SwitchCOCAcc($g_iNextAccount)
		Else
			SetLog("Staying in this account")
			SetSwitchAccLog("Stay at [" & $g_iCurAccount + 1 & "]", $COLOR_SUCCESS)
		EndIf
	EndIf
	If Not $g_bRunState Then Return
	
	$g_bForceSwitch = false ; reset the need to switch
EndFunc   ;==>CheckSwitchAcc

Func SwitchCOCAcc($NextAccount)
	Local $abAccountNo = AccountNoActive()
	If $NextAccount < 0 And $NextAccount > $g_iTotalAcc Then $NextAccount = _ArraySearch(True, $abAccountNo)
	Static $iRetry = 0
	Local $bResult
	If Not $g_bRunState Then Return

	SetLog("Switching to Account [" & $NextAccount + 1 & "]")

	Local $bSharedPrefs = $g_bChkSharedPrefs And HaveSharedPrefs($g_asProfileName[$g_iNextAccount])
	If $bSharedPrefs And $g_PushedSharedPrefsProfile = $g_asProfileName[$g_iNextAccount] Then
		; shared prefs already pushed
		$bResult = True
		$bSharedPrefs = False ; don't push again
		SetLog("Profile shared_prefs already pushed")
		If Not $g_bRunState Then Return
	Else
		If Not $g_bRunState Then Return
		If IsMainPage() Then Click($aButtonSetting[0], $aButtonSetting[1], 1, 0, "Click Setting")
		If _Sleep(500) Then Return
		While 1
			If Not IsSettingPage() Then ExitLoop

			If $g_bChkGooglePlay Or $g_bChkSharedPrefs Then
				Switch SwitchCOCAcc_DisconnectConnect($bResult, $bSharedPrefs)
					Case 0
						Return
					Case -1
						ExitLoop
				EndSwitch
				Switch SwitchCOCAcc_ClickAccount($bResult, $NextAccount, $bSharedPrefs)
					Case "OK"
						; all good
						If $g_bChkSharedPrefs Then
							If $bSharedPrefs Then
								CloseCoC(False)
								$bResult = True
								ExitLoop
							Else
								SetLog($g_asProfileName[$g_iNextAccount] & " missing shared_prefs, using normal switch account", $COLOR_WARNING)
							EndIf
						EndIf
					Case "Error"
						; some problem
						ExitLoop
					Case "Exit"
						; no $g_bRunState
						Return
				EndSwitch
				Switch SwitchCOCAcc_ConfirmAccount($bResult)
					Case "OK"
						; all good
					Case "Error"
						; some problem
						ExitLoop
					Case "Exit"
						; no $g_bRunState
						Return
				EndSwitch

			ElseIf $g_bChkSuperCellID Then
				Switch SwitchCOCAcc_ConnectedSCID($bResult)
					Case "OK"
						; all good
					Case "Error"
						; some problem
						ExitLoop
					Case "Exit"
						; no $g_bRunState
						Return
				EndSwitch
				Switch SwitchCOCAcc_ClickAccountSCID($bResult, $NextAccount, 2)
					Case "OK"
						; all good
					Case "Error"
						; some problem
						ExitLoop
					Case "Exit"
						; no $g_bRunState
						Return
				EndSwitch

			EndIf
			ExitLoop
		WEnd
		If _Sleep(500) Then Return
	EndIf

	If $bResult Then
		$iRetry = 0
		$g_bReMatchAcc = False
		If Not $g_bRunState Then Return
		If Not $g_bInitiateSwitchAcc Then SwitchAccountVariablesReload("Save")
		If $g_ahTimerSinceSwitched[$g_iCurAccount] <> 0 Then
			If Not $g_bReMatchAcc Then SetSwitchAccLog(" - Acc " & $g_iCurAccount + 1 & ", online: " & Int(__TimerDiff($g_ahTimerSinceSwitched[$g_iCurAccount]) / 1000 / 60) & "m")
			SetTime(True)
			$g_aiRunTime[$g_iCurAccount] += __TimerDiff($g_ahTimerSinceSwitched[$g_iCurAccount])
			$g_ahTimerSinceSwitched[$g_iCurAccount] = 0
		EndIf

		$g_iCurAccount = $NextAccount
		SwitchAccountVariablesReload()

		$g_ahTimerSinceSwitched[$g_iCurAccount] = __TimerInit()
		$g_bInitiateSwitchAcc = False
		If $g_sProfileCurrentName <> $g_asProfileName[$g_iNextAccount] Then
			If $g_iGuiMode = 1 Then
				; normal GUI Mode
				_GUICtrlComboBox_SetCurSel($g_hCmbProfile, _GUICtrlComboBox_FindStringExact($g_hCmbProfile, $g_asProfileName[$g_iNextAccount]))
				cmbProfile()
				DisableGUI_AfterLoadNewProfile()
			Else
				; mini or headless GUI Mode
				saveConfig()
				$g_sProfileCurrentName = $g_asProfileName[$g_iNextAccount]
				LoadProfile(False)
			EndIf
		EndIf
		If $bSharedPrefs Then
			SetLog("Please wait for loading CoC")
			PushSharedPrefs()
			OpenCoC()
			waitMainScreen()
		EndIf

		If Not $g_bRunState Then Return
		SetSwitchAccLog("Switched to Acc [" & $NextAccount + 1 & "]", $COLOR_SUCCESS)

		If $g_bChkSharedPrefs Then
			; disconnect account again for saving shared_prefs
			waitMainScreen()
			If IsMainPage() Then
				Click($aButtonSetting[0], $aButtonSetting[1], 1, 0, "Click Setting")
				If _Sleep(500) Then Return
				If SwitchCOCAcc_DisconnectConnect($bResult, $g_bChkSharedPrefs) = -1 Then Return ;Return if Error happend

				Switch SwitchCOCAcc_ClickAccount($bResult, $NextAccount, $g_bChkSharedPrefs, False)
					Case "OK"
						; all good
						PullSharedPrefs()
				EndSwitch
			EndIf
		EndIf
		If Not $g_bRunState Then Return
	Else
		$iRetry += 1
		$g_bReMatchAcc = True
		SetLog("Switching account failed!", $COLOR_ERROR)
		SetSwitchAccLog("Switching to Acc " & $NextAccount + 1 & " Failed!", $COLOR_ERROR)
		If $iRetry <= 3 Then
			Local $ClickPoint = $aAway
			If $g_bChkSuperCellID Then $ClickPoint = $aCloseTabSCID
			ClickP($ClickPoint, 2, 500)
			checkMainScreen()
		Else
			$iRetry = 0
			UniversalCloseWaitOpenCoC()
		EndIf
		If Not $g_bRunState Then Return
	EndIf
	waitMainScreen()
	If Not $g_bRunState Then Return
	CheckObstacles()
	If $g_bForceSinglePBLogoff Then $g_bGForcePBTUpdate = True
	runBot()

EndFunc   ;==>SwitchCOCAcc

Func SwitchCOCAcc_DisconnectConnect(ByRef $bResult, $bDisconnectOnly = $g_bChkSharedPrefs)
	Local $sGooglePlayButtonArea = GetDiamondFromRect("50,100,800,600")
	Local $avGoogleButtonStatus, $sButtonState, $avGoogleButtonSubResult, $aiButtonPos
	If Not $g_bRunState Then Return -1

	For $i = 0 To 20 ; Checking Green Connect Button continuously in 20sec
		$avGoogleButtonStatus = findMultiple($g_sImgGoogleButtonState, $sGooglePlayButtonArea, $sGooglePlayButtonArea, 0, 1000, 1, "objectname,objectpoints", True)
		If IsArray($avGoogleButtonStatus) And UBound($avGoogleButtonStatus, 1) > 0 Then
			$avGoogleButtonSubResult = $avGoogleButtonStatus[0]
			$sButtonState = $avGoogleButtonSubResult[0]
			$aiButtonPos = StringSplit($avGoogleButtonSubResult[1], ",", $STR_NOCOUNT)
			If Not $g_bRunState Then Return -1

			If StringInStr($sButtonState, "Green", 0) Then; Google Play Disconnected
				If Not $bDisconnectOnly Then
					SetLog("   1. Click Connect & Disconnect")
					ClickP($aiButtonPos, 2, 1000)
					If _Sleep(200) Then Return -1
				Else
					SetLog("   1. Click Connected")
					ClickP($aiButtonPos, 1, 1000)
					If _Sleep(200) Then Return -1
				EndIf

				Return 1
			ElseIf StringInStr($sButtonState, "Red", 0) Then ; Google Play Connected
				If Not $bDisconnectOnly Then
					SetLog("   1. Click Disconnect")
					ClickP($aiButtonPos)
					If _Sleep(200) Then Return -1
				Else
					SetLog("Account already disconnected")
				EndIf

				Return 1
			Else ; The Unknown has happend
				SetDebugLog("Unkown Google Play Button State: " & $sButtonState, $COLOR_ERROR)
				Return -1
			EndIf
		Else ; SupercellID
			Local $aSuperCellIDConnected = decodeSingleCoord(findImage("SupercellID Connected", $g_sImgSupercellIDConnected, GetDiamondFromRect("612,161,691,216"), 1, True, Default))
			If IsArray($aSuperCellIDConnected) And UBound($aSuperCellIDConnected, 1) >= 2 Then
				SetLog("Account connected to SuperCell ID")
				;ExitLoop
				Return 1
			EndIf
		EndIf
		If $i = 20 Then
			$bResult = False
			;ExitLoop 2
			Return -1
		EndIf
		If _Sleep(900) Then Return 0
		If Not $g_bRunState Then Return 0
	Next

	Return -1
EndFunc   ;==>SwitchCOCAcc_DisconnectConnect

Func SwitchCOCAcc_ClickAccount(ByRef $bResult, $iNextAccount, $bStayDisconnected = $g_bChkSharedPrefs, $bLateDisconnectButtonCheck = True)
	FuncEnter(SwitchCOCAcc_ClickAccount)

	Local $aSearchForAccount, $aCoordinates[0][2], $aTempArray

	For $i = 0 To 20 ; Checking Account List continuously in 20sec
		If _ColorCheck(_GetPixelColor($aListAccount[0], $aListAccount[1], True), Hex($aListAccount[2], 6), $aListAccount[3]) Then ;	Grey
			If $bStayDisconnected Then
				ClickP($aAway, 1, 0, "#0000") ;Click Away
				Return FuncReturn("OK")
			EndIf
			If _Sleep(600) Then Return FuncReturn("Exit")
			If Not $g_bRunState Then Return FuncReturn("Exit")

			$aSearchForAccount = decodeMultipleCoords(findImage("AccountLocations", $g_sImgGoogleAccounts, GetDiamondFromRect("155,100,705,710"), 0, True, Default))
			If UBound($aSearchForAccount, 1) <= 0 Then
				SetLog("No GooglePlay accounts detected!", $COLOR_ERROR)
				Return FuncReturn("Error")
			ElseIf UBound($aSearchForAccount, 1) < $g_iTotalAcc + 1 Then
				SetLog("Less GooglePlay accounts detected than configured!", $COLOR_ERROR)
				SetDebugLog("Detected: " & UBound($aSearchForAccount, 1) & ", Configured: " & ($g_iTotalAcc + 1), $COLOR_DEBUG)
				Return FuncReturn("Error")
			ElseIf UBound($aSearchForAccount, 1) > $g_iTotalAcc + 1 Then
				SetLog("More GooglePlay accounts detected than configured!", $COLOR_ERROR)
				SetDebugLog("Detected: " & UBound($aSearchForAccount, 1) & ", Configured: " & ($g_iTotalAcc + 1), $COLOR_DEBUG)
				Return FuncReturn("Error")
			Else
				SetDebugLog("[GooglePlay Accounts]: " & UBound($aSearchForAccount, 1), $COLOR_DEBUG)

				For $j = 0 To UBound($aSearchForAccount) - 1
					$aTempArray = $aSearchForAccount[$j]
					_ArrayAdd($aCoordinates, $aTempArray[0] & "|" & $aTempArray[1], 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
				Next

				_ArraySort($aCoordinates, 0, 0, 0, 1) ; short by column 1 [Y]
				For $j = 0 To UBound($aCoordinates) - 1
					SetDebugLog("[" & $j & "] Account coordinates: " & $aCoordinates[$j][0] & "," & $aCoordinates[$j][1] & " named: " & $g_asProfileName[$j])
				Next

				If $iNextAccount + 1 > UBound($aCoordinates, 1) Then
					SetLog("You selected a GooglePlay undetected account!", $COLOR_ERROR)
					Return FuncReturn("Error")
				EndIf

				SetLog("   2. Click Account [" & $iNextAccount + 1 & "]")
				Click($aCoordinates[$iNextAccount][0], $aCoordinates[$iNextAccount][1], 1)
				If _Sleep(600) Then Return FuncReturn("Exit")
				Return FuncReturn("OK")
			EndIf

			If Not $g_bRunState Then Return FuncReturn("Exit")
			If _sleep(1000) Then Return FuncReturn("Exit")
			Return FuncReturn("Error")
		ElseIf (Not $bLateDisconnectButtonCheck Or $i = 6) And UBound(decodeSingleCoord(findImage("Google Play Disconnected", $g_sImgGoogleButtonState & "GooglePlayRed*", GetDiamondFromRect("50,100,800,600"), 1, True, Default)), 1) > 0 Then ; Red, double click did not work, try click Disconnect 1 more time
			If $bStayDisconnected Then
				ClickP($aAway, 1, 0, "#0000") ;Click Away
				Return FuncReturn("OK")
			EndIf
			If _Sleep(250) Then Return FuncReturn("Exit")
			If Not $g_bRunState Then Return FuncReturn("Exit")
			SetLog("   1.1. Click Disconnect again")
			Local $aiButtonDisconnect = decodeSingleCoord(findImage("Google Play Connected", $g_sImgGoogleButtonState & "GooglePlayRed*", GetDiamondFromRect("50,100,800,600"), 1, True, Default))
			If IsArray($aiButtonDisconnect) And UBound($aiButtonDisconnect, 1) >= 2 Then ClickP($aiButtonDisconnect)
			If _Sleep(600) Then Return FuncReturn("Exit")
		Else ; SupercellID
			Local $aSuperCellIDConnected = decodeSingleCoord(findImage("SupercellID Connected", $g_sImgSupercellIDConnected, GetDiamondFromRect("612,161,691,216"), 1, True, Default))
			If IsArray($aSuperCellIDConnected) And UBound($aSuperCellIDConnected, 1) >= 2 Then
				;SetLog("Account connected to SuperCell ID, cannot disconnect")
				If $bStayDisconnected Then
					ClickP($aAway, 1, 0, "#0000") ;Click Away
					Return FuncReturn("OK")
				EndIf
			EndIf
		EndIf
		If $i = 20 Then
			$bResult = False
			;ExitLoop 2
			Return FuncReturn("Error")
		EndIf
		If _Sleep(900) Then Return FuncReturn("Exit")
		If Not $g_bRunState Then Return FuncReturn("Exit")
	Next
	Return FuncReturn("") ; should never get here
EndFunc   ;==>SwitchCOCAcc_ClickAccount

Func SwitchCOCAcc_ConfirmAccount(ByRef $bResult, $iStep = 3, $bDisconnectAfterSwitch = $g_bChkSharedPrefs)
	Local $aiGooglePlayConnected
	For $i = 0 To 30 ; Checking Load Button continuously in 30sec
		If _ColorCheck(_GetPixelColor($aButtonVillageLoad[0], $aButtonVillageLoad[1], True), Hex($aButtonVillageLoad[2], 6), $aButtonVillageLoad[3]) Then ; Load Button
			If _Sleep(250) Then Return "Exit"
			If Not $g_bRunState Then Return "Exit"
			SetLog("   " & $iStep & ". Click Load button")
			Click($aButtonVillageLoad[0], $aButtonVillageLoad[1], 1, 0, "Click Load") ; Click Load

			For $j = 0 To 25 ; Checking Text Box and OKAY Button continuously in 25sec
				If _ColorCheck(_GetPixelColor($aButtonVillageOkay[0], $aButtonVillageOkay[1], True), Hex($aButtonVillageOkay[2], 6), $aButtonVillageOkay[3]) Then ; with modified texts.csv OKAY Button may be already green
					If _Sleep(250) Then Return "Exit"
					SetLog("   " & ($iStep + 1) & ". Click OKAY")
					Click($aButtonVillageOkay[0], $aButtonVillageOkay[1], 1, 0, "Click OKAY")
					SetLog("Please wait for loading CoC")
					$bResult = True
					;ExitLoop 2
					Return "OK"
				ElseIf _ColorCheck(_GetPixelColor($aTextBox[0], $aTextBox[1], True), Hex($aTextBox[2], 6), $aTextBox[3]) Then ; Pink (close icon)
					If _Sleep(250) Then Return "Exit"
					SetLog("   " & ($iStep + 1) & ". Click text box & type CONFIRM")
					Click($aTextBox[0], $aTextBox[1], 1, 0, "Click Text box")
					If _Sleep(500) Then Return "Exit"
					AndroidSendText("CONFIRM")
					ExitLoop
				EndIf
				If $j = 25 Then
					$bResult = False
					;ExitLoop 3
					Return "Error"
				EndIf
				If _Sleep(900) Then Return "Exit"
				If Not $g_bRunState Then Return "Exit"
			Next

			For $k = 0 To 10 ; Checking OKAY Button continuously in 10sec
				If _ColorCheck(_GetPixelColor($aButtonVillageOkay[0], $aButtonVillageOkay[1], True), Hex($aButtonVillageOkay[2], 6), $aButtonVillageOkay[3]) Then
					If _Sleep(250) Then Return "Exit"
					SetLog("   " & ($iStep + 2) & ". Click OKAY")
					Click($aButtonVillageOkay[0], $aButtonVillageOkay[1], 1, 0, "Click OKAY")
					SetLog("Please wait for loading CoC")
					$bResult = True
					If $bDisconnectAfterSwitch Then
						If Not checkMainScreen() Then
							SetLog("Cannot Disconnect account", $COLOR_ERROR)
							Return "Error"
						EndIf
						Click($aButtonSetting[0], $aButtonSetting[1], 1, 0, "Click Setting")
						If _Sleep(500) Then Return
						Switch SwitchCOCAcc_DisconnectConnect($bResult)
							Case 0
								Return "Exit"
							Case -1
								Return "Error"
						EndSwitch
					EndIf

					;ExitLoop 2
					Return "OK"
				EndIf
				If $k = 10 Then
					$bResult = False
					;ExitLoop 3
					Return "Error"
				EndIf
				If _Sleep(900) Then Return "Exit"
				If Not $g_bRunState Then Return "Exit"
			Next
		ElseIf UBound(decodeSingleCoord(findImage("Google Play Connected", $g_sImgGoogleButtonState & "GooglePlayGreen*", GetDiamondFromRect("50,100,800,600"), 1, True, Default)), 1) >= 2 Then
			SetLog("Already in current account")
			If $bDisconnectAfterSwitch Then
				Switch SwitchCOCAcc_DisconnectConnect($bResult)
					Case -1
						Return "Error"
					Case 0
						Return "Exit"
				EndSwitch
			EndIf
			ClickP($aAway, 2, 0, "#0167") ; Click Away
			If _Sleep(500) Then Return "Exit"
			If Not $g_bRunState Then Return "Exit"
			$bResult = True
			Return "OK"
		EndIf
		If $i = 30 Then
			$bResult = False
			;ExitLoop 2
			Return "Error"
		EndIf
		If _Sleep(900) Then Return "Exit"
		If Not $g_bRunState Then Return "Exit"
	Next
	Return "" ; should never get here
EndFunc   ;==>SwitchCOCAcc_ConfirmAccount

Func SwitchCOCAcc_ConnectedSCID(ByRef $bResult)
	For $i = 0 To 20 ; Checking Blue Reload button continuously in 20sec
		Local $aSuperCellIDReload = decodeSingleCoord(findImage("SupercellID Reload", $g_sImgSupercellIDReload, GetDiamondFromRect("563,163,612,217"), 1, True, Default))
		If IsArray($aSuperCellIDReload) And UBound($aSuperCellIDReload, 1) >= 2 Then
			Click($aSuperCellIDReload[0], $aSuperCellIDReload[1], 1, 0, "Click Reload SC_ID")
			Setlog("   1. Click Reload Supercell ID")
			If _Sleep(2500) Then Return "Exit"
			If Not $g_bRunState Then Return "Exit"
			;ExitLoop
			Return "OK"
		EndIf

		If $i = 20 Then
			$bResult = False
			;ExitLoop 2
			Return "Error"
		EndIf
		If _Sleep(900) Then Return "Exit"
		If Not $g_bRunState Then Return "Exit"
	Next
	Return "" ; should never get here
EndFunc   ;==>SwitchCOCAcc_ConnectedSCID

Func SwitchCOCAcc_ClickAccountSCID(ByRef $bResult, $NextAccount, $iStep = 2)
	Local $sAccountDiamond = GetDiamondFromRect("440,330,859,732") ; Contains iXStart, $iYStart, $iXEnd, $iYEnd
    Local $aSuperCellIDWindowsUI
	Local $iIndexSCID = 0
	Local $aSearchForAccount, $aCoordinates[0][2], $aTempArray
	If Not $g_bRunState Then Return "Exit"

	If $NextAccount >= 5 Then
		Switch $g_iTotalAcc
			Case 5
				$sAccountDiamond = GetDiamondFromRect("440,462,859,596")
			Case 6
				$sAccountDiamond = GetDiamondFromRect("440,380,859,590")
			Case 7
				$sAccountDiamond = GetDiamondFromRect("440,330,859,732")
		EndSwitch
	EndIf

	SCIDragIfNeeded($NextAccount)

	For $i = 0 To 30 ; Checking "New SuperCellID UI" continuously in 30sec
		$aSuperCellIDWindowsUI = decodeSingleCoord(findImage("SupercellID Windows", $g_sImgSupercellIDWindows, GetDiamondFromRect("440,1,859,243"), 1, True, Default))
		If _Sleep(500) Then Return "Exit"
		If IsArray($aSuperCellIDWindowsUI) And UBound($aSuperCellIDWindowsUI, 1) >= 2 Then
			$aSearchForAccount = decodeMultipleCoords(findImage("Account Locations", $g_sImgSupercellIDSlots, $sAccountDiamond, 0, True, Default))
			If _Sleep(500) Then Return "Exit"
			If Not $g_bRunState Then Return "Exit"
			If IsArray($aSearchForAccount) And UBound($aSearchForAccount) > 0 Then
				SetDebugLog("SCID Accounts: " & UBound($aSearchForAccount), $COLOR_DEBUG)

				; Correct Index for Profile if needs to drag
				If $NextAccount >= 5 Then $iIndexSCID = 5

				For $j = 0 To UBound($aSearchForAccount) - 1
					$aTempArray = $aSearchForAccount[$j]
					_ArrayAdd($aCoordinates, $aTempArray[0] & "|" & $aTempArray[1], 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
				Next

				_ArraySort($aCoordinates, 0, 0, 0, 1) ; short by column 1 [Y]

				For $j = 0 To UBound($aCoordinates) - 1
					SetDebugLog("[" & $j & "] Account coordinates: " & $aCoordinates[$j][0] & "," & $aCoordinates[$j][1] & " named: " & $g_asProfileName[$j + $iIndexSCID])
				Next

				SetLog("   " & $iStep & ". Click Account [" & $NextAccount + 1 & "] Supercell ID with Profile: " & $g_asProfileName[$NextAccount])
				Click($aCoordinates[$NextAccount - $iIndexSCID][0], $aCoordinates[$NextAccount - $iIndexSCID][1], 1)
				If _Sleep(750) Then Return "Exit"
				SetLog("   " & $iStep + 1 & ". Please wait for loading CoC!")
				$bResult = True
				Return "OK"
			EndIf
		EndIf

		If $i = 30 Then
			$bResult = False
			;ExitLoop 2
			Return "Error"
		EndIf
		If _Sleep(900) Then Return "Exit"
		If Not $g_bRunState Then Return "Exit"
	Next
	Return "" ; should never get here
EndFunc   ;==>SwitchCOCAcc_ClickAccountSCID

Func CheckWaitHero() ; get hero regen time remaining if enabled
	Local $iActiveHero
	Local $aHeroResult[$eHeroCount]
	$g_aiTimeTrain[2] = 0

	$aHeroResult = getArmyHeroTime("all")
	If UBound($aHeroResult) < $eHeroCount Then Return ; OCR error

	If _Sleep($DELAYRESPOND) Then Return
	If Not $g_bRunState Then Return
	If $aHeroResult[0] > 0 Or $aHeroResult[1] > 0 Or $aHeroResult[2] > 0 Then ; check if hero is enabled to use/wait and set wait time
		For $pTroopType = $eKing To $eChampion ; check all 3 hero
			For $pMatchMode = $DB To $g_iModeCount - 1 ; check all attack modes
				$iActiveHero = -1
				If IsUnitUsed($pMatchMode, $pTroopType) And _
						BitOR($g_aiAttackUseHeroes[$pMatchMode], $g_aiSearchHeroWaitEnable[$pMatchMode]) = $g_aiAttackUseHeroes[$pMatchMode] Then ; check if Hero enabled to wait
					$iActiveHero = $pTroopType - $eKing ; compute array offset to active hero
				EndIf
				If $iActiveHero <> -1 And $aHeroResult[$iActiveHero] > 0 Then ; valid time?
					; check exact time & existing time is less than new time
					If $g_aiTimeTrain[2] < $aHeroResult[$iActiveHero] Then
						$g_aiTimeTrain[2] = $aHeroResult[$iActiveHero] ; use exact time
					EndIf
				EndIf
			Next
			If _Sleep($DELAYRESPOND) Then Return
			If Not $g_bRunState Then Return
		Next
	EndIf

EndFunc   ;==>CheckWaitHero

Func CheckTroopTimeAllAccount($bExcludeCurrent = False) ; Return the minimum remain training time
	If Not $g_bRunState Then Return
	Local $abAccountNo = AccountNoActive()
	Local $iMinRemainTrain = 999, $iRemainTrain, $bNextAccountDefined = False
	If Not $bExcludeCurrent And Not $g_abPBActive[$g_iCurAccount] Then
		$g_asTrainTimeFinish[$g_iCurAccount] = _DateAdd("n", Number(_ArrayMax($g_aiTimeTrain, 1, 0, 2)), _NowCalc())
		SetDebugLog("Army times: Troop = " & $g_aiTimeTrain[0] & ", Spell = " & $g_aiTimeTrain[1] & ", Hero = " & $g_aiTimeTrain[2] & ", $g_asTrainTimeFinish = " & $g_asTrainTimeFinish[$g_iCurAccount])
	EndIf

	SetSwitchAccLog(" - Train times: ")

	For $i = 0 To $g_iTotalAcc
		If $bExcludeCurrent And $i = $g_iCurAccount Then ContinueLoop
		If $abAccountNo[$i] And Not $g_abDonateOnly[$i] Then ;	Only check Active profiles
			If _DateIsValid($g_asTrainTimeFinish[$i]) Then
				Local $iRemainTrain = _DateDiff("n", _NowCalc(), $g_asTrainTimeFinish[$i])
				; if remaining time is negative and stop mode, force 0 to ensure other accounts will be picked
				If $iRemainTrain < 0 And SwitchAccountVariablesReload("$g_iCommandStop", $i) <> -1 Then
					; Account was last time in halt attack mode, set time to 0
					$iRemainTrain = 0
					SetLog("Account [" & $i + 1 & "]: " & $g_asProfileName[$i] & " halt mode detected, set negative remaining time to 0")
				EndIf
				SetLog("Account [" & $i + 1 & "]: " & $g_asProfileName[$i] & "'s train time: " & $g_asTrainTimeFinish[$i] & " (" & $iRemainTrain & " minutes)")
				If $iMinRemainTrain > $iRemainTrain Then
					If Not $bNextAccountDefined Then $g_iNextAccount = $i
					$iMinRemainTrain = $iRemainTrain
				EndIf
				SetSwitchAccLog("    Acc " & $i + 1 & ": " & $iRemainTrain & "m")
			Else ; for accounts first Run
				SetLog("Account [" & $i + 1 & "]: " & $g_asProfileName[$i] & " has not been read its remain train time")
				SetSwitchAccLog("    Acc " & $i + 1 & ": Unknown")
				If Not $bNextAccountDefined Then
					$g_iNextAccount = $i
					$bNextAccountDefined = True
				EndIf
			EndIf
		EndIf
	Next

	SetDebugLog("- Min Remain Train Time is " & $iMinRemainTrain)

	Return $iMinRemainTrain

EndFunc   ;==>CheckTroopTimeAllAccount

Func DisableGUI_AfterLoadNewProfile()
	$g_bGUIControlDisabled = True
	For $i = $g_hFirstControlToHide To $g_hLastControlToHide
		If IsAlwaysEnabledControl($i) Then ContinueLoop
		;If $g_bNotifyPBEnable And $i = $g_hBtnNotifyDeleteMessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
		If BitAND(GUICtrlGetState($i), $GUI_ENABLE) Then GUICtrlSetState($i, $GUI_DISABLE)
	Next
	ControlEnable("", "", $g_hCmbGUILanguage)
	$g_bGUIControlDisabled = False
EndFunc   ;==>DisableGUI_AfterLoadNewProfile

Func aquireSwitchAccountMutex($iSwitchAccountGroup = $g_iCmbSwitchAcc, $bReturnOnlyMutex = False, $bShowMsgBox = False)
	Local $sMsg = GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Msg_SwitchAccounts_InUse", "My Bot with Switch Accounts Group %s is already in use or active.", $iSwitchAccountGroup)
	If $iSwitchAccountGroup Then
		Local $hMutex_Profile = 0
		If $g_ahMutex_SwitchAccountsGroup[0] = $iSwitchAccountGroup And $g_ahMutex_SwitchAccountsGroup[1] Then
			$hMutex_Profile = $g_ahMutex_SwitchAccountsGroup[1]
		Else
			$hMutex_Profile = CreateMutex(StringReplace($g_sProfilePath & "\SwitchAccount.0" & $iSwitchAccountGroup, "\", "-"))
			$g_ahMutex_SwitchAccountsGroup[0] = $iSwitchAccountGroup
			$g_ahMutex_SwitchAccountsGroup[1] = $hMutex_Profile
		EndIf
		;SetDebugLog("Aquire Switch Accounts Group " & $iSwitchAccountGroup & " Mutex: " & $hMutex_Profile)
		If $bReturnOnlyMutex Then
			Return $hMutex_Profile
		EndIf

		If $hMutex_Profile = 0 Then
			; mutex already in use
			SetLog($sMsg, $COLOR_ERROR)
			;SetLog($sMsg, "Cannot switch to profile " & $sProfile, $COLOR_ERROR)
			If $bShowMsgBox Then
				MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION, $MB_TOPMOST), $g_sBotTitle, $sMsg)
			EndIf
		EndIf
		Return $hMutex_Profile <> 0
	EndIf
	Return False
EndFunc   ;==>aquireSwitchAccountMutex

Func releaseSwitchAccountMutex()
	If $g_ahMutex_SwitchAccountsGroup[1] Then
		;SetDebugLog("Release Switch Accounts Group " & $g_ahMutex_SwitchAccountsGroup[0] & " Mutex: " & $g_ahMutex_SwitchAccountsGroup[1])
		ReleaseMutex($g_ahMutex_SwitchAccountsGroup[1])
		$g_ahMutex_SwitchAccountsGroup[0] = 0
		$g_ahMutex_SwitchAccountsGroup[1] = 0
		Return True
	EndIf
	Return False
EndFunc   ;==>releaseSwitchAccountMutex

; Checks if Acc Account is shown and returns true if not or sucessfully switched, clicks first account if $bSelectFirst is true
Func CheckGoogleSelectAccount($bSelectFirst = True)
	Local $bResult = False

	If _CheckPixel($aListAccount, True) Then
		SetDebugLog("Found open Google Accounts list pixel")

		; Account List check be there, validate with imgloc
		If UBound(decodeSingleCoord(FindImageInPlace("GoogleSelectAccount", $g_sImgGoogleSelectAccount, "180,400(90,300)", False))) > 1 Then
			; Google Account selection found
			SetLog("Found open Google Accounts list")

			If $g_bChkSharedPrefs Then
				SetLog("Close Google Accounts list")
				Click(90, 400) ; Close Window
				Return True
			EndIf

			Local $aiSelectGoogleEmail = decodeSingleCoord(FindImageInPlace("GoogleSelectEmail", $g_sImgGoogleSelectEmail, "220,80(400,600)", False))
			If UBound($aiSelectGoogleEmail) > 1 Then
				SetLog("   1. Click first Google Account")
				ClickP($aiSelectGoogleEmail)
				$bResult = True
				Switch SwitchCOCAcc_ConfirmAccount($bResult, 2)
					Case "OK"
						; all good
					Case "Error"
						; some problem
					Case "Exit"
						; no $g_bRunState
						Return
				EndSwitch
			Else
				SetLog("Cannot find Google Account Email", $COLOR_ERROR)
				$bResult = False
			EndIf
		Else
			SetDebugLog("Open Google Accounts list not verified")
			Click($aAway[0], $aAway[1] + 40, 1)
		EndIf
	Else
		If $g_bDebugSetlog Then SetDebugLog("CheckGoogleSelectAccount pixel color: " & _GetPixelColor($aListAccount[0], $aListAccount[1], False))
		Click($aAway[0], $aAway[1] + 40, 1)
	EndIf

	Return $bResult
EndFunc   ;==>CheckGoogleSelectAccount

; Checks if "Log in with Supercell ID" boot screen shows up and closes CoC and pushes shared_prefs to fix
Func CheckLoginWithSupercellID()

	Local $bResult = False

	; Account List check be there, validate with imgloc
	If UBound(decodeSingleCoord(FindImageInPlace("LoginWithSupercellID", $g_sImgLoginWithSupercellID, "318,678(125,30)", False))) > 1 Then
		; Google Account selection found
		SetLog("Verified Log in with Supercell ID boot screen")

		If HaveSharedPrefs($g_sProfileCurrentName) Then
			SetLog("Close CoC and push shared_prefs for Supercell ID screen")
			PushSharedPrefs()
			Return True
		Else
			If $g_bChkSuperCellID And ProfileSwitchAccountEnabled() Then ; select the correct account matching with current profile
				Local $NextAccount = 0
				$bResult = True
				For $i = 0 To $g_iTotalAcc
					If $g_abAccountNo[$i] = True And SwitchAccountEnabled($i) And $g_asProfileName[$i] = $g_sProfileCurrentName Then $NextAccount = $i
				Next

				Click($aLoginWithSupercellID[0], $aLoginWithSupercellID[1], 1, 0, "Click Log in with SC_ID")
				If _Sleep(2000) Then Return

				Switch SwitchCOCAcc_ClickAccountSCID($bResult, $NextAccount, 1)
					Case "OK"
						; all good
					Case "Error"
						; some problem
						Return
					Case "Exit"
						; no $g_bRunState
						Return
				EndSwitch
			Else
				SetLog("Cannot close Supercell ID screen, shared_prefs not pulled.", $COLOR_ERROR)
				SetLog("Please resolve Supercell ID screen manually, close CoC", $COLOR_INFO)
				SetLog("and then pull shared_prefs in tab Bot/Profiles.", $COLOR_INFO)
			EndIf
		EndIf

	Else
		SetDebugLog("Log in with Supercell ID boot screen not verified")
	EndIf

	Return $bResult
EndFunc   ;==>CheckLoginWithSupercellID

Func CheckLoginWithSupercellIDScreen()

	Local $bResult = False
	Local $aSearchForAccount, $aCoordinates[0][2], $aTempArray
	Local $acount = $g_iWhatSCIDAccount2Use

	If $g_bChkSuperCellID And ProfileSwitchAccountEnabled() Then
		$acount = $g_iCurAccount
	EndIf

	; Account List check be there, validate with imgloc
	If UBound(decodeSingleCoord(FindImageInPlace("LoginWithSupercellID", $g_sImgLoginWithSupercellID, "318,678(125,30)", False))) > 1 Then
		; Google Account selection found
		SetLog("Verified Log in with Supercell ID boot screen for login")

		Click($aLoginWithSupercellID[0], $aLoginWithSupercellID[1], 1, 0, "Click Log in with SC_ID")
		If _Sleep(2000) Then Return

		$bResult = True
		Switch SwitchCOCAcc_ClickAccountSCID($bResult, $acount, 1)
			Case "OK"
				; all good
			Case "Error"
				; some problem
				Return
			Case "Exit"
				; no $g_bRunState
				Return
		EndSwitch
	Else
		SetDebugLog("Log in with Supercell ID boot screen not verified for login")
	EndIf

EndFunc   ;==>CheckLoginWithSupercellIDScreen

Func SwitchAccountCheckProfileInUse($sNewProfile)
	; now check if profile is used in another group
	Local $sInGroups = ""
	For $g = 1 To 8
		If $g = $g_iCmbSwitchAcc Then ContinueLoop
		; find group this profile belongs to: no switch profile config is saved in config.ini on purpose!
		Local $sSwitchAccFile = $g_sProfilePath & "\SwitchAccount.0" & $g & ".ini"
		If FileExists($sSwitchAccFile) = 0 Then ContinueLoop
		Local $sProfile
		Local $bEnabled
		For $i = 1 To Int(IniRead($sSwitchAccFile, "SwitchAccount", "TotalCocAccount", 0)) + 1
			$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "Enable", "") = "1"
			If $bEnabled Then
				$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "AccountNo." & $i, "") = "1"
				If $bEnabled Then
					$sProfile = IniRead($sSwitchAccFile, "SwitchAccount", "ProfileName." & $i, "")
					If $sProfile = $sNewProfile Then
						; found profile
						If $sInGroups <> "" Then $sInGroups &= ", "
						$sInGroups &= $g
					EndIf
				EndIf
			EndIf
		Next
	Next

	If $sInGroups Then
		If StringLen($sInGroups) > 2 Then
			$sInGroups = "used in groups " & $sInGroups
		Else
			$sInGroups = "used in group " & $sInGroups
		EndIf
	EndIf

	; test if profile can be aquired
	Local $iAquired = aquireProfileMutex($sNewProfile)
	If $iAquired Then
		If $iAquired = 1 Then
			; ok, release again
			releaseProfileMutex($sNewProfile)
		EndIf

		If $sInGroups Then
			; write to log
			SetLog("Profile " & $sNewProfile & " not active, but " & $sInGroups & "!", $COLOR_ERROR)
			SetSwitchAccLog($sNewProfile & " " & $sInGroups & "!", $COLOR_ERROR)
			Return False
		EndIf

		Return True
	Else
		; write to log
		If $sInGroups Then
			SetLog("Profile " & $sNewProfile & " active and " & $sInGroups & "!", $COLOR_ERROR)
			SetSwitchAccLog($sNewProfile & " active & " & $sInGroups & "!", $COLOR_ERROR)
		Else
			SetLog("Profile " & $sNewProfile & " active in another bot instance!", $COLOR_ERROR)
			SetSwitchAccLog($sNewProfile & " active!", $COLOR_ERROR)
		EndIf
		Return False
	EndIf
EndFunc   ;==>SwitchAccountCheckProfileInUse

Func SCIDragIfNeeded($iSCIDAccount)
	If Not $g_bRunState Then Return
	If $iSCIDAccount < 5 Then Return

	ClickDrag(785, 674 + $g_iMidOffsetY, 785, 260 + $g_iMidOffsetY, 2000)
	If _Sleep(1500) Then Return
EndFunc   ;==>SCIDragIfNeeded

