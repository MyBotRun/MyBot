; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Action
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: cosote (2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BotStart()
	ResumeAndroid()
	CalCostCamp()
	CalCostSpell()

	$g_bRunState = True
	$g_bTogglePauseAllowed = True
	$g_bSkipFirstZoomout = False
	$Is_SearchLimit = False
	$Is_ClientSyncError = False

	EnableControls($g_hFrmBotBottom, False, $g_aFrmBotBottomCtrlState)
	;$g_iFirstAttack = 0

	$bTrainEnabled = True
	$bDonationEnabled = True
	$g_bMeetCondStop = False
	$Is_ClientSyncError = False
	$bDisableBreakCheck = False ; reset flag to check for early warning message when bot start/restart in case user stopped in middle
	$bDisableDropTrophy = False ; Reset Disabled Drop Trophy because the user has no Tier 1 or 2 Troops

	If Not $bSearchMode Then
		CreateLogFile()
		CreateAttackLogFile()
		If $g_iFirstRun = -1 Then $g_iFirstRun = 1
	EndIf
	_GUICtrlEdit_SetText($g_hTxtLog, _PadStringCenter(" BOT LOG ", 71, "="))
	_GUICtrlRichEdit_SetFont($g_hTxtLog, 6, "Lucida Console")
	_GUICtrlRichEdit_AppendTextColor($g_hTxtLog, "" & @CRLF, _ColorConvert($Color_Black))

	SaveConfig()
	readConfig()
	applyConfig(False) ; bot window redraw stays disabled!

	;Reset Telegram message
	NotifyGetLastMessageFromTelegram()

	If BitAND($g_iAndroidSupportFeature, 1 + 2) = 0 And $g_bChkBackgroundMode = True Then
		GUICtrlSetState($g_hChkBackgroundMode, $GUI_UNCHECKED)
		chkBackground() ; Invoke Event manually
		SetLog("Background Mode not supported for " & $g_sAndroidEmulator & " and has been disabled", $COLOR_ERROR)
	EndIf

	GUICtrlSetState($g_hBtnStart, $GUI_HIDE)
	GUICtrlSetState($g_hBtnStop, $GUI_SHOW)
	GUICtrlSetState($g_hBtnPause, $GUI_SHOW)
	GUICtrlSetState($g_hBtnResume, $GUI_HIDE)
	GUICtrlSetState($g_hBtnSearchMode, $GUI_HIDE)
	GUICtrlSetState($g_hChkBackgroundMode, $GUI_DISABLE)
	EnableControls($g_hFrmBotBottom, Default, $g_aFrmBotBottomCtrlState)

	DisableGuiControls()

	SetRedrawBotWindow(True, Default, Default, Default, "BotStart")

	Local $Result = False
	If WinGetAndroidHandle() = 0 Then
		$Result = OpenAndroid(False)
	EndIf
	SetDebugLog("Android Window Handle: " & WinGetAndroidHandle())
	If $HWnD <> 0 Then ;Is Android open?
		If Not $g_bRunState Then Return
		If $g_bAndroidBackgroundLaunched = True Or AndroidControlAvailable() Then ; Really?
			If Not $Result Then
				$Result = InitiateLayout()
			EndIf
		Else
			; Not really
			SetLog("Current " & $g_sAndroidEmulator & " Window not supported by MyBot", $COLOR_ERROR)
			$Result = RebootAndroid(False)
		EndIf
		If Not $g_bRunState Then Return
		Local $hWndActive = $HWnD
		; check if window can be activated
		If $g_bNoFocusTampering = False And $g_bAndroidBackgroundLaunched = False And $g_bAndroidEmbedded = False Then
			Local $hTimer = TimerInit()
			$hWndActive = -1
			Local $activeHWnD = WinGetHandle("")
			While TimerDiff($hTimer) < 1000 And $hWndActive <> $HWnD And Not _Sleep(100)
				$hWndActive = WinActivate($HWnD) ; ensure bot has window focus
			WEnd
			WinActivate($activeHWnD) ; restore current active window
		EndIf
		If Not $g_bRunState Then Return
		If $hWndActive = $HWnD And ($g_bAndroidBackgroundLaunched = True Or AndroidControlAvailable())  Then ; Really?
			Initiate() ; Initiate and run bot
		Else
			SetLog("Cannot use " & $g_sAndroidEmulator & ", please check log", $COLOR_ERROR)
			btnStop()
		EndIf
	Else
		SetLog("Cannot start " & $g_sAndroidEmulator & ", please check log", $COLOR_ERROR)
		btnStop()
	EndIf
EndFunc   ;==>BotStart

Func BotStop()
	ResumeAndroid()

	$g_bRunState = False
	$g_bBotPaused = False
	$g_bTogglePauseAllowed = True

	;WinSetState($g_hFrmBotBottom, "", @SW_DISABLE)
	Local $aCtrlState
	EnableControls($g_hFrmBotBottom, False, $g_aFrmBotBottomCtrlState)
	;$g_bFirstStart = true

	EnableGuiControls()

	DistributorsBotStopEvent()
	AndroidBotStopEvent() ; signal android that bot is now stopping
	AndroidShield("btnStop", Default)

	EnableControls($g_hFrmBotBottom, Default, $g_aFrmBotBottomCtrlState)

	GUICtrlSetState($g_hChkBackgroundMode, $GUI_ENABLE)
	GUICtrlSetState($g_hBtnStart, $GUI_SHOW)
	GUICtrlSetState($g_hBtnStop, $GUI_HIDE)
	GUICtrlSetState($g_hBtnPause, $GUI_HIDE)
	GUICtrlSetState($g_hBtnResume, $GUI_HIDE)
	If $iTownHallLevel > 2 Then GUICtrlSetState($g_hBtnSearchMode, $GUI_ENABLE)
	GUICtrlSetState($g_hBtnSearchMode, $GUI_SHOW)
	;GUICtrlSetState($g_hBtnMakeScreenshot, $GUI_ENABLE)

	; hide attack buttons if show
	GUICtrlSetState($g_hBtnAttackNowDB, $GUI_HIDE)
	GUICtrlSetState($g_hBtnAttackNowLB, $GUI_HIDE)
	GUICtrlSetState($g_hBtnAttackNowTS, $GUI_HIDE)
	GUICtrlSetState($g_hPicTwoArrowShield, $GUI_SHOW)
	GUICtrlSetState($g_hLblVersion, $GUI_SHOW)

	;_BlockInputEx(0, "", "", $HWnD)
	SetLog(_PadStringCenter(" Bot Stop ", 50, "="), $COLOR_ACTION)
	If Not $bSearchMode Then
		If Not $g_bBotPaused Then $g_iTimePassed += Int(TimerDiff($g_hTimerSinceStarted))
		;AdlibUnRegister("SetTime")
		$g_bRestart = True

	   If $g_hLogFile <> 0 Then
		  FileClose($g_hLogFile)
		  $g_hLogFile = 0
	   EndIf

	   If $g_hAttackLogFile <> 0 Then
		  FileClose($g_hAttackLogFile)
		  $g_hAttackLogFile = 0
	   EndIf
	Else
		$bSearchMode = False
	EndIf
EndFunc   ;==>BotStop

Func BotSearchMode()
	$bSearchMode = True
	$g_bRestart = False
	$Is_ClientSyncError = False
	If $g_iFirstRun = 1 Then $g_iFirstRun = -1
	btnStart()
	checkMainScreen(False)
	If _Sleep(100) Then Return
	$iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1]) ; get OCR to read current Village Trophies
	If _Sleep(100) Then Return
	CheckArmySpellCastel()
	ClickP($aAway, 2, 0, "") ;Click Away
	If _Sleep(100) Then Return
	If (IsSearchModeActive($DB) And checkCollectors(True, False)) Or IsSearchModeActive($LB) Or IsSearchModeActive($TS) Then
		If _Sleep(100) Then Return
		PrepareSearch()
		If _Sleep(1000) Then Return
		VillageSearch()
		If _Sleep(100) Then Return
	Else
		Setlog("Your Army is not prepared, check the Attack/train options")
	EndIf
	btnStop()
EndFunc   ;==>BotSearchMode
