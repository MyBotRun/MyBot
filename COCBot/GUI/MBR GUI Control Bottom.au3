; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), KnowJack(July 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func Initiate()

	If IsArray(ControlGetPos($Title, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")) Then
		Local $BSsize = [ControlGetPos($Title, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")[2], ControlGetPos($Title, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")[3]]
		Local $fullScreenRegistryData = RegRead($REGISTRY_KEY_DIRECTORY, "FullScreen")
		Local $guestHeightRegistryData = RegRead($REGISTRY_KEY_DIRECTORY, "GuestHeight")
		Local $guestWidthRegistryData = RegRead($REGISTRY_KEY_DIRECTORY, "GuestWidth")
		Local $windowHeightRegistryData = RegRead($REGISTRY_KEY_DIRECTORY, "WindowHeight")
		Local $windowWidthRegistryData = RegRead($REGISTRY_KEY_DIRECTORY, "WindowWidth")
		Local $BSx = ($BSsize[0] > $BSsize[1]) ? $BSsize[0] : $BSsize[1]
		Local $BSy = ($BSsize[0] > $BSsize[1]) ? $BSsize[1] : $BSsize[0]
;		$RunState = True
	    DisposeWindows()
		If $BSx <> 860 Or $BSy <> 720 Then
			RegWrite($REGISTRY_KEY_DIRECTORY, "FullScreen", "REG_DWORD", "0")
			RegWrite($REGISTRY_KEY_DIRECTORY, "GuestHeight", "REG_DWORD", $DEFAULT_HEIGHT)
			RegWrite($REGISTRY_KEY_DIRECTORY, "GuestWidth", "REG_DWORD", $DEFAULT_WIDTH)
			RegWrite($REGISTRY_KEY_DIRECTORY, "WindowHeight", "REG_DWORD", $DEFAULT_HEIGHT)
			RegWrite($REGISTRY_KEY_DIRECTORY, "WindowWidth", "REG_DWORD", $DEFAULT_WIDTH)
			SetLog("Please restart your computer for the applied changes to take effect.", $COLOR_ORANGE)
			If _Sleep(3000) Then Return
			$MsgRet = MsgBox(BitOR($MB_OKCANCEL, $MB_SYSTEMMODAL), "Restart Computer", "Restart your computer for the applied changes to take effect." & @CRLF & "If your BlueStacks is the correct size  (860 x 720), click OK.", 10)
			If $MsgRet <> $IDOK Then
				btnStop()
				Return
			EndIf
		EndIf

		WinActivate($Title)
		SetLog(_PadStringCenter(" " & $sBotTitle & " Powered by MyBot.run ", 50, "~"), $COLOR_PURPLE)
		SetLog($Compiled & " running on " & @OSVersion & " " & @OSServicePack & " " & @OSArch)
		If Not $bSearchMode Then
			SetLog(_PadStringCenter(" Bot Start ", 50, "="), $COLOR_GREEN)
		Else
			SetLog(_PadStringCenter(" Search Mode Start ", 50, "="), $COLOR_GREEN)
		EndIf
		SetLog(_PadStringCenter("  Current Profile: " & $sCurrProfile & " ", 73, "-"), $COLOR_BLUE)
		If $DebugSetlog = 1 Or $DebugOcr = 1 Or $debugRedArea = 1 Or $DevMode = 1 Then
			SetLog(_PadStringCenter(" Warning Debug Mode Enabled! Setlog: " & $DebugSetlog &" OCR: "& $DebugOcr & " RedArea: " & $debugRedArea & " ", 55, "-"), $COLOR_RED)
		EndIf

		$AttackNow = False
		$FirstStart = True
		$Checkrearm = True

		If $iDeleteAllPushes = 1 Then
			_DeletePush($PushToken)
			SetLog("Delete all previous PushBullet messages...", $COLOR_BLUE)
		EndIf

		If Not $bSearchMode Then
			$sTimer = TimerInit()
		EndIf

;		$RunState = True
		For $i = $FirstControlToHide To $LastControlToHide ; Save state of all controls on tabs
			If $i = $tabGeneral Or $i = $tabSearch Or $i = $tabAttack Or $i = $tabAttackAdv Or $i = $tabDonate Or $i = $tabTroops Or $i = $tabMisc Or $i = $tabNotify Or $i = $tabUpgrades Or $i = $tabEndBattle Or $i = $tabExpert Then ContinueLoop ; exclude tabs
			If $pEnabled And $i = $btnDeletePBmessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
			If $i = $btnMakeScreenshot Then ContinueLoop ; exclude
			If $i = $divider Then ContinueLoop ; exclude divider
			$iPrevState[$i] = GUICtrlGetState($i)
		Next
		For $i = $FirstControlToHide To $LastControlToHide ; Disable all controls in 1 go on all tabs
			If $i = $tabGeneral Or $i = $tabSearch Or $i = $tabAttack Or $i = $tabAttackAdv Or $i = $tabDonate Or $i = $tabTroops Or $i = $tabMisc Or $i = $tabNotify Or $i = $tabUpgrades Or $i = $tabEndBattle Or $i = $tabExpert Then ContinueLoop ; exclude tabs
			If $pEnabled And $i = $btnDeletePBmessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
			If $i = $btnMakeScreenshot Then ContinueLoop ; exclude
			If $i = $divider Then ContinueLoop ; exclude divider
			GUICtrlSetState($i, $GUI_DISABLE)
		Next

		GUICtrlSetState($chkBackground, $GUI_DISABLE)
		GUICtrlSetState($btnStart, $GUI_HIDE)
		GUICtrlSetState($btnStop, $GUI_SHOW)
		GUICtrlSetState($btnPause, $GUI_SHOW)
		GUICtrlSetState($btnResume, $GUI_HIDE)
		GUICtrlSetState($btnSearchMode, $GUI_HIDE)
		;GUICtrlSetState($btnMakeScreenshot, $GUI_DISABLE)


		If Not $bSearchMode Then
			AdlibRegister("SetTime", 1000)
			If $restarted = 1 Then
				$restarted = 0
				IniWrite($config, "general", "Restarted", 0)
				PushMsg("Restarted")
			EndIf
		EndIf
		checkMainScreen()
		ZoomOut()

		If Not $bSearchMode Then
			BotDetectFirstTime()
			If $ichklanguageFirst = 0 And $ichklanguage = 1 Then $ichklanguageFirst = TestLanguage()

			runBot()
		EndIf
	Else
		SetLog("Not in Game!", $COLOR_RED)
;		$RunState = True
		btnStop()
	EndIf
EndFunc   ;==>Initiate

Func DisableBS($HWnD, $iButton)
	ConsoleWrite('+ Window Handle: ' & $HWnD & @CRLF)
	$hSysMenu = _GUICtrlMenu_GetSystemMenu($HWnD, 0)
	_GUICtrlMenu_RemoveMenu($hSysMenu, $iButton, False)
	_GUICtrlMenu_DrawMenuBar($HWnD)
EndFunc   ;==>DisableBS

Func EnableBS($HWnD, $iButton)
	ConsoleWrite('+ Window Handle: ' & $HWnD & @CRLF)
	$hSysMenu = _GUICtrlMenu_GetSystemMenu($HWnD, 1)
	_GUICtrlMenu_RemoveMenu($hSysMenu, $iButton, False)
	_GUICtrlMenu_DrawMenuBar($HWnD)
EndFunc   ;==>EnableBS

Func chkBackground()
	If GUICtrlRead($chkBackground) = $GUI_CHECKED Then
		$ichkBackground = 1
		GUICtrlSetState($btnHide, $GUI_ENABLE)
	Else
		$ichkBackground = 0
		GUICtrlSetState($btnHide, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBackground

Func btnStart()
	If $RunState = False Then
		$RunState = True
		GUICtrlSetState($btnStart, $GUI_HIDE)
		GUICtrlSetState($btnStop, $GUI_SHOW)
		GUICtrlSetState($btnPause, $GUI_SHOW)
		GUICtrlSetState($btnSearchMode, $GUI_HIDE)
		;GUICtrlSetState($btnMakeScreenshot, $GUI_DISABLE)
		;$FirstAttack = 0

		$bTrainEnabled = True
		$bDonationEnabled = True
		$MeetCondStop = False

		If Not $bSearchMode Then
			CreateLogFile()
			CreateAttackLogFile()
			If $FirstRun = -1 Then $FirstRun = 1
		EndIf

		SaveConfig()
		readConfig()
		applyConfig()
		_GUICtrlEdit_SetText($txtLog, _PadStringCenter(" BOT LOG ", 71, "="))
		_GUICtrlRichEdit_SetFont($txtLog, 6, "Lucida Console")
		_GUICtrlRichEdit_AppendTextColor($txtLog, "" & @CRLF, _ColorConvert($Color_Black))

		If WinExists($Title) Then  ;Is BlueSatcks open?
			DisableBS($HWnD, $SC_MINIMIZE)
			DisableBS($HWnD, $SC_CLOSE)
			Initiate()
		Else  ; If BlueStacks is not open, then wait for it to open
			OpenBS()
			If @error Then GUICtrlSetState($btnStart, $GUI_DISABLE)  ; Disable start button, force bot close/open by user.
		EndIf
	EndIf
EndFunc   ;==>btnStart

Func btnStop()
	If $RunState Then
		$RunState = False
		;$FirstStart = true
		EnableBS($HWnD, $SC_MINIMIZE)
		EnableBS($HWnD, $SC_CLOSE)
		For $i = $FirstControlToHide To $LastControlToHide ; Restore previous state of controls
			If $i = $tabGeneral Or $i = $tabSearch Or $i = $tabAttack Or $i = $tabAttackAdv Or $i = $tabDonate Or $i = $tabTroops Or $i = $tabMisc Or $i = $tabNotify Or $i = $tabEndBattle Or $i = $tabExpert Then ContinueLoop ; exclude tabs
			If $pEnabled And $i = $btnDeletePBmessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
			If $i = $btnMakeScreenshot Then ContinueLoop ; exclude
			If $i = $divider Then ContinueLoop ; exclude divider
			GUICtrlSetState($i, $iPrevState[$i])
		Next

		GUICtrlSetState($chkBackground, $GUI_ENABLE)
		GUICtrlSetState($btnStart, $GUI_SHOW)
		GUICtrlSetState($btnStop, $GUI_HIDE)
		GUICtrlSetState($btnPause, $GUI_HIDE)
		GUICtrlSetState($btnResume, $GUI_HIDE)
		GUICtrlSetState($btnSearchMode, $GUI_SHOW)
		;GUICtrlSetState($btnMakeScreenshot, $GUI_ENABLE)


		; hide attack buttons if show
		GUICtrlSetState($btnAttackNowDB, $GUI_HIDE)
		GUICtrlSetState($btnAttackNowLB, $GUI_HIDE)
		GUICtrlSetState($btnAttackNowTS, $GUI_HIDE)
		GUICtrlSetState($pic2arrow, $GUI_SHOW)
		GUICtrlSetState($lblVersion, $GUI_SHOW)

		_BlockInputEx(0, "", "", $HWnD)
		If Not $bSearchMode Then
			If Not $TPaused Then $iTimePassed += Int(TimerDiff($sTimer))
			AdlibUnRegister("SetTime")
			$Restart = True
			FileClose($hLogFileHandle)
			FileClose($hAttackLogFileHandle)
		Else
			$bSearchMode = False
		EndIf
		SetLog(_PadStringCenter(" Bot Stop ", 50, "="), $COLOR_ORANGE)
	EndIf
EndFunc   ;==>btnStop

Func btnPause()
	Send("{PAUSE}")
EndFunc   ;==>btnPause

Func btnResume()

	Send("{PAUSE}")
EndFunc   ;==>btnResume

Func btnAttackNowDB()
	If $RunState Then
		$bBtnAttackNowPressed = True
		$iMatchMode = $DB
	EndIf
EndFunc   ;==>btnAttackNowDB

Func btnAttackNowLB()
	If $RunState Then
		$bBtnAttackNowPressed = True
		$iMatchMode = $LB
	EndIf
EndFunc   ;==>btnAttackNowLB

Func btnAttackNowTS()
	If $RunState Then
		$bBtnAttackNowPressed = True
		$iMatchMode = $TS
	EndIf
EndFunc   ;==>btnAttackNowTS

Func btnHide()

	WinGetPos($Title)
	If @error <> 0 Then Return SetError(0,0,0)

	If $Hide = False Then
		GUICtrlSetData($btnHide, "Show BS")
		$botPos[0] = WinGetPos($Title)[0]
		$botPos[1] = WinGetPos($Title)[1]
		WinMove($Title, "", -32000, -32000)
		$Hide = True
	Else
		GUICtrlSetData($btnHide, "Hide BS")

		If $botPos[0] = -32000 Then
			WinMove($Title, "", 0, 0)
		Else
			WinMove($Title, "", $botPos[0], $botPos[1])
			WinActivate($Title)
		EndIf
		$Hide = False
	EndIf
EndFunc   ;==>btnHide

Func btnMakeScreenshot()
	If $RunState Then $iMakeScreenshotNow = True
EndFunc   ;==>btnMakeScreenshot

Func btnSearchMode()
	$bSearchMode = True
	$Restart = False
	$Is_ClientSyncError = False
	If $FirstRun = 1 Then $FirstRun = -1
	btnStart()
	If _Sleep(100) Then Return
	PrepareSearch()
	If _Sleep(1000) Then Return
	VillageSearch()
	If _Sleep(100) Then Return
	btnStop()
EndFunc   ;==>btnSearchMode

Func GetFont()
	Local $i, $sText = "", $DefaultFont
		$DefaultFont = __EMB_GetDefaultFont()
		For $i = 0 To UBound($DefaultFont) - 1
			$sText &= " $DefaultFont[" & $i & "]= " & $DefaultFont[$i] & ", "
		Next
		Setlog($sText,$COLOR_PURPLE)
EndFunc
