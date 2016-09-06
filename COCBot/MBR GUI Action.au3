; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Action
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: cosote (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BotStart()
	ResumeAndroid()

	$RunState = True
	$TogglePauseAllowed = True

	EnableControls($frmBotBottom, False, $frmBotBottomCtrlState)
	;$FirstAttack = 0

	$bTrainEnabled = True
	$bDonationEnabled = True
	$MeetCondStop = False
	$Is_ClientSyncError = False
	$bDisableBreakCheck = False ; reset flag to check for early warning message when bot start/restart in case user stopped in middle
	$bDisableDropTrophy = False ; Reset Disabled Drop Trophy because the user has no Tier 1 or 2 Troops

	If Not $bSearchMode Then
		CreateLogFile()
		CreateAttackLogFile()
		If $FirstRun = -1 Then $FirstRun = 1
	EndIf
	_GUICtrlEdit_SetText($txtLog, _PadStringCenter(" BOT LOG ", 71, "="))
	_GUICtrlRichEdit_SetFont($txtLog, 6, "Lucida Console")
	_GUICtrlRichEdit_AppendTextColor($txtLog, "" & @CRLF, _ColorConvert($Color_Black))

	SaveConfig()
	readConfig()
	applyConfig(False) ; bot window redraw stays disabled!

	If BitAND($AndroidSupportFeature, 1 + 2) = 0 And $ichkBackground = 1 Then
		GUICtrlSetState($chkBackground, $GUI_UNCHECKED)
		chkBackground() ; Invoke Event manually
		SetLog("Background Mode not supported for " & $Android & " and has been disabled", $COLOR_RED)
	EndIf

	DisableGuiControls()

	EnableControls($frmBotBottom, Default, $frmBotBottomCtrlState)
	GUICtrlSetState($btnStart, $GUI_HIDE)
	GUICtrlSetState($btnStop, $GUI_SHOW)
	GUICtrlSetState($btnPause, $GUI_SHOW)
	GUICtrlSetState($btnResume, $GUI_HIDE)
	GUICtrlSetState($btnSearchMode, $GUI_HIDE)
	GUICtrlSetState($chkBackground, $GUI_DISABLE)

	Local $Result = False
	Local $hWin = $HWnD
	SetDebugLog("btnStart: Current Android Window Handle: " & WinGetAndroidHandle())
	If $HWnD = 0 Then
		If $hWin = 0 Then
			$Result = OpenAndroid(False)
		Else
			$Result = RebootAndroid(False)
		EndIf
	EndIf
	If $HWnD <> 0 Then ;Is Android open?
		If Not $RunState Then Return
		If $AndroidBackgroundLaunched = True Or AndroidControlAvailable() Then ; Really?
			If Not $Result Then
				$Result = InitiateLayout()
			EndIf
		Else
			; Not really
			SetLog("Current " & $Android & " Window not supported by MyBot", $COLOR_RED)
			$Result = RebootAndroid(False)
		EndIf
		If Not $RunState Then Return
		Local $hWndActive = $HWnD
		; check if window can be activated
		If $NoFocusTampering = False And $AndroidBackgroundLaunched = False And $AndroidEmbedded = False Then
			Local $hTimer = TimerInit()
			$hWndActive = -1
			Local $activeHWnD = WinGetHandle("")
			While TimerDiff($hTimer) < 1000 And $hWndActive <> $HWnD And Not _Sleep(100)
				$hWndActive = WinActivate($HWnD) ; ensure bot has window focus
			WEnd
			WinActivate($activeHWnD) ; restore current active window
		EndIf
		If Not $RunState Then Return
		If $hWndActive = $HWnD And ($AndroidBackgroundLaunched = True Or AndroidControlAvailable())  Then ; Really?
			Initiate() ; Initiate and run bot
		Else
			SetLog("Cannot use " & $Android & ", please check log", $COLOR_RED)
			btnStop()
		EndIf
	Else
		SetLog("Cannot start " & $Android & ", please check log", $COLOR_RED)
		btnStop()
	EndIf
EndFunc   ;==>BotStart

Func BotStop()
	ResumeAndroid()

	$RunState = False
	$TPaused = False
	$TogglePauseAllowed = True

	;WinSetState($frmBotBottom, "", @SW_DISABLE)
	Local $aCtrlState
	EnableControls($frmBotBottom, False, $frmBotBottomCtrlState)
	;$FirstStart = true

	EnableGuiControls()

	AndroidBotStopEvent() ; signal android that bot is now stopping
	AndroidShield("btnStop", Default)

	EnableControls($frmBotBottom, Default, $frmBotBottomCtrlState)

	GUICtrlSetState($chkBackground, $GUI_ENABLE)
	GUICtrlSetState($btnStart, $GUI_SHOW)
	GUICtrlSetState($btnStop, $GUI_HIDE)
	GUICtrlSetState($btnPause, $GUI_HIDE)
	GUICtrlSetState($btnResume, $GUI_HIDE)
	If $iTownHallLevel > 2 Then GUICtrlSetState($btnSearchMode, $GUI_ENABLE)
	GUICtrlSetState($btnSearchMode, $GUI_SHOW)
	;GUICtrlSetState($btnMakeScreenshot, $GUI_ENABLE)

	; hide attack buttons if show
	GUICtrlSetState($btnAttackNowDB, $GUI_HIDE)
	GUICtrlSetState($btnAttackNowLB, $GUI_HIDE)
	GUICtrlSetState($btnAttackNowTS, $GUI_HIDE)
	GUICtrlSetState($pic2arrow, $GUI_SHOW)
	GUICtrlSetState($lblVersion, $GUI_SHOW)

	;_BlockInputEx(0, "", "", $HWnD)
	SetLog(_PadStringCenter(" Bot Stop ", 50, "="), $COLOR_ORANGE)
	If Not $bSearchMode Then
		If Not $TPaused Then $iTimePassed += Int(TimerDiff($sTimer))
		;AdlibUnRegister("SetTime")
		$Restart = True
		FileClose($hLogFileHandle)
		$hLogFileHandle = ""
		FileClose($hAttackLogFileHandle)
		$hAttackLogFileHandle = ""
	Else
		$bSearchMode = False
	EndIf
EndFunc   ;==>BotStop

Func BotSearchMode()
	$bSearchMode = True
	$Restart = False
	$Is_ClientSyncError = False
	If $FirstRun = 1 Then $FirstRun = -1
	btnStart()
	checkMainScreen(False)
	If _Sleep(100) Then Return
	$iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1]) ; get OCR to read current Village Trophies
	If _Sleep(100) Then Return
	getArmyCapacity(True, True)
	If _Sleep(100) Then Return
	PrepareSearch()
	If _Sleep(1000) Then Return
	VillageSearch()
	If _Sleep(100) Then Return
	btnStop()
EndFunc   ;==>BotSearchMode
