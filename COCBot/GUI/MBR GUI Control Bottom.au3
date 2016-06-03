; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), KnowJack(July 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func Initiate()
	WinGetAndroidHandle()
	If $HWnD <> 0 And IsArray(ControlGetPos($HWnD, $AppPaneName, $AppClassInstance)) Then
		;WinActivate($HWnD)
		SetLog(_PadStringCenter(" " & $sBotTitle & " Powered by MyBot.run ", 50, "~"), $COLOR_PURPLE)
		SetLog($Compiled & " running on " & @OSVersion & " " & @OSServicePack & " " & @OSArch)
		If Not $bSearchMode Then
			SetLog(_PadStringCenter(" Bot Start ", 50, "="), $COLOR_GREEN)
		Else
			SetLog(_PadStringCenter(" Search Mode Start ", 50, "="), $COLOR_GREEN)
		EndIf
		SetLog(_PadStringCenter("  Current Profile: " & $sCurrProfile & " ", 73, "-"), $COLOR_BLUE)
		If $DebugSetlog = 1 Or $DebugOcr = 1 Or $debugRedArea = 1 Or $DevMode = 1 Or $debugImageSave = 1 Or $debugBuildingPos = 1 Or $debugOCRdonate = 1 Then
			SetLog(_PadStringCenter(" Warning Debug Mode Enabled! Setlog: " & $DebugSetlog & " OCR: " & $DebugOcr & " RedArea: " & $debugRedArea & " ImageSave: " & $debugImageSave & " BuildingPos: " & $debugBuildingPos & " OCRDonate: " & $debugOCRdonate, 55, "-"), $COLOR_RED)
		EndIf

		$AttackNow = False
		$FirstStart = True
		$Checkrearm = True

		If $iDeleteAllPBPushes = 1 Then _DeletePush()

		If Not $bSearchMode Then
			$sTimer = TimerInit()
		EndIf

		AndroidBotStartEvent() ; signal android that bot is now running
		If Not $RunState Then Return

		;		$RunState = True

		If Not $bSearchMode Then
			AdlibRegister("SetTime", 1000)
			If $restarted = 1 Then
				$restarted = 0
				IniWrite($config, "general", "Restarted", 0)
				PushMsg("Restarted")
			EndIf
		EndIf
		If Not $RunState Then Return

		checkMainScreen()
		If Not $RunState Then Return

		ZoomOut()
		If Not $RunState Then Return

		If Not $bSearchMode Then
			BotDetectFirstTime()
			If Not $RunState Then Return

			If $ichklanguageFirst = 0 And $ichklanguage = 1 Then $ichklanguageFirst = TestLanguage()
			If Not $RunState Then Return

			runBot()
		EndIf
	Else
		SetLog("Not in Game!", $COLOR_RED)
		;		$RunState = True
		btnStop()
	EndIf
EndFunc   ;==>Initiate

Func InitiateLayout()

	WinGetAndroidHandle()
	Local $BSsize = getAndroidPos()

	If IsArray($BSsize) Then ; Is Android Client Control available?

		Local $BSx = $BSsize[2]
		Local $BSy = $BSsize[3]

		SetDebugLog("InitiateLayout: " & $title & " Android-ClientSize: " & $BSx & " x " & $BSy, $COLOR_BLUE)

		If Not CheckScreenAndroid($BSx, $BSy) Then ; Is Client size now correct?
			Local $MsgRet = $IDOK
			;If _Sleep(3000) Then Return False
			;Local $MsgRet = MsgBox(BitOR($MB_OKCANCEL, $MB_SYSTEMMODAL), "Change the resolution and restart " & $Android & "?", _
			;	"Click OK to adjust the screen size of " & $Android & " and restart the emulator." & @CRLF & _
			;	"If your " & $Android & " really has the correct size (" & $DEFAULT_WIDTH & " x " & $DEFAULT_HEIGHT & "), click CANCEL." & @CRLF & _
			;	"(Automatically Cancel in 15 Seconds)", 15)

			If $MsgRet = $IDOK Then
				RebootAndroidSetScreen() ; recursive call!
				btnStop()
				Return True
			EndIf
		EndIf

		DisposeWindows()

	EndIf

	Return False

EndFunc   ;==>InitiateLayout

Func chkBackground()
	If GUICtrlRead($chkBackground) = $GUI_CHECKED Then
		$ichkBackground = 1
		GUICtrlSetState($btnHide, $GUI_ENABLE)
	Else
		$ichkBackground = 0
		GUICtrlSetState($btnHide, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBackground

Func IsStopped()
	If $RunState Then Return False
	If $Restart Then Return True
	Return False
EndFunc   ;==>IsStopped

Func btnStart()
	ResumeAndroid()
	If $RunState = False Then
		;GUICtrlSetState($chkBackground, $GUI_DISABLE) ; will be disbaled after check if Android supports Background Mode
		GUICtrlSetState($btnStart, $GUI_HIDE)
		GUICtrlSetState($btnStop, $GUI_SHOW)
		GUICtrlSetState($btnPause, $GUI_SHOW)
		GUICtrlSetState($btnResume, $GUI_HIDE)
		GUICtrlSetState($btnSearchMode, $GUI_HIDE)
		;GUICtrlSetState($btnMakeScreenshot, $GUI_DISABLE)
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
		GUICtrlSetState($chkBackground, $GUI_DISABLE)
		SetDebugLog("Disable GUI Controls")

		$GUIControl_Disabled = True
		For $i = $FirstControlToHide To $LastControlToHide ; Save state of all controls on tabs
			If IsTab($i) Or IsDebugControl($i) Then ContinueLoop
			If $PushBulletEnabled And $i = $btnDeletePBmessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
			If $i = $btnMakeScreenshot Then ContinueLoop ; exclude
			If $i = $divider Then ContinueLoop ; exclude divider
			$iPrevState[$i] = GUICtrlGetState($i)
 			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		$GUIControl_Disabled = False

		$RunState = True
		SetRedrawBotWindow(True)

	    Local $hWin = $HWnD
		SetDebugLog("btnStart: Current Android Window Handle: " & WinGetAndroidHandle())
		If $HWnD <> 0 Then ;Is Android open?
			Local $hWndActive = $HWnD
			; check if window can be activated
			If $NoFocusTampering = False Then
				Local $hTimer = TimerInit()
				$hWndActive = -1
				Local $activeHWnD = WinGetHandle("")
				While TimerDiff($hTimer) < 1000 And $hWndActive <> $HWnD And Not _Sleep(100)
					$hWndActive = WinActivate($HWnD) ; ensure bot has window focus
				WEnd
				WinActivate($activeHWnD) ; restore current active window
			EndIf
			If Not $RunState Then Return
		    If IsArray(ControlGetPos($HWnD, $AppPaneName, $AppClassInstance)) And $hWndActive = $HWnD  Then ; Really?
				If Not InitiateLayout() Then
					Initiate()
				EndIf
			Else
				; Not really
				SetLog("Current " & $Android & " Window not supported by MyBot", $COLOR_RED)
			   RebootAndroid(False)
			EndIf
		Else ; If Android is not open, then wait for it to open
			If $hWin = 0 Then
			   OpenAndroid(False)
			Else
			   RebootAndroid(False)
			EndIf
			;If @error Then GUICtrlSetState($btnStart, $GUI_DISABLE)  ; Disable start button, force bot close/open by user.
		EndIf

	EndIf

EndFunc   ;==>btnStart

Func btnStop()
	ResumeAndroid()
	If $RunState Then ; Or BitOr(GUICtrlGetState($btnStop), $GUI_SHOW) Then ; $btnStop check added for strange $RunState inconsistencies

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

		;$FirstStart = true

		SetDebugLog("Enable GUI Controls")
		SetRedrawBotWindow(False)

		$GUIControl_Disabled = True
		For $i = $FirstControlToHide To $LastControlToHide ; Restore previous state of controls
			If IsTab($i) Or IsDebugControl($i) Then ContinueLoop
			If $PushBulletEnabled And $i = $btnDeletePBmessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
			If $i = $btnMakeScreenshot Then ContinueLoop ; exclude
			If $i = $divider Then ContinueLoop ; exclude divider
			GUICtrlSetState($i, $iPrevState[$i])
		Next
		$GUIControl_Disabled = False

		$RunState = False
		AndroidBotStopEvent() ; signal android that bot is now stopping

		_BlockInputEx(0, "", "", $HWnD)
		SetLog(_PadStringCenter(" Bot Stop ", 50, "="), $COLOR_ORANGE)
		SetRedrawBotWindow(True) ; must be here at bottom, after SetLog, so Log refreshes. You could also use SetRedrawBotWindow(True, False) and let the events handle the refresh.
		If Not $bSearchMode Then
			If Not $TPaused Then $iTimePassed += Int(TimerDiff($sTimer))
			AdlibUnRegister("SetTime")
			$Restart = True
			FileClose($hLogFileHandle)
			$hLogFileHandle = ""
			FileClose($hAttackLogFileHandle)
			$hAttackLogFileHandle = ""
		Else
			$bSearchMode = False
		EndIf
	EndIf
EndFunc   ;==>btnStop

Func btnPause()
	;Send("{PAUSE}")
	TogglePause()
EndFunc   ;==>btnPause

Func btnResume()
	;Send("{PAUSE}")
	TogglePause()
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

;~ Hide Android Window again without overwriting $botPos[0] and [1]
Func reHide()
	WinGetAndroidHandle()
	If $Hide = True And $HWnD <> 0 Then
		SetDebugLog("Hide " & $Android & " Window after restart")
		Return WinMove2($HWnD, "", -32000, -32000)
	EndIf
	Return 0
EndFunc   ;==>reHide

Func btnHide()
	ResumeAndroid()
	WinGetAndroidHandle()
	WinGetPos($HWnD)
	If @error <> 0 Then Return SetError(0, 0, 0)

	If $Hide = False Then
		GUICtrlSetData($btnHide, GetTranslated(602, 25, "Show"))
		Local $a = WinGetPos($HWnD)
		$botPos[0] = $a[0]
		$botPos[1] = $a[1]
		WinMove2($HWnD, "", -32000, -32000)
		$Hide = True
	Else
		GUICtrlSetData($btnHide, GetTranslated(602, 11, "Hide"))

		If $botPos[0] = -32000 Then
			WinMove2($HWnD, "", 0, 0)
		Else
			WinMove2($HWnD, "", $botPos[0], $botPos[1])
			WinActivate($HWnD)
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
EndFunc   ;==>btnSearchMode

Func GetFont()
	Local $i, $sText = "", $DefaultFont
	$DefaultFont = __EMB_GetDefaultFont()
	For $i = 0 To UBound($DefaultFont) - 1
		$sText &= " $DefaultFont[" & $i & "]= " & $DefaultFont[$i] & ", "
	Next
	Setlog($sText, $COLOR_PURPLE)
EndFunc   ;==>GetFont



Func btnAnalyzeVillage()
	$debugBuildingPos = 1
	$debugDeadBaseImage = 1
	SETLOG("DEADBASE CHECK..................")
	$dbBase = checkDeadBase()
	SETLOG("TOWNHALL CHECK..................")
	$searchTH = checkTownhallADV2()
	SETLOG("TOWNHALL C# CHECK...............")
	THSearch()
	SETLOG("MINE CHECK C#...................")
	$PixelMine = GetLocationMine()
	SetLog("[" & UBound($PixelMine) & "] Gold Mines")
	SETLOG("ELIXIR CHECK C#.................")
	$PixelElixir = GetLocationElixir()
	SetLog("[" & UBound($PixelElixir) & "] Elixir Collectors")
	SETLOG("DARK ELIXIR CHECK C#............")
	$PixelDarkElixir = GetLocationDarkElixir()
	SetLog("[" & UBound($PixelDarkElixir) & "] Dark Elixir Drill/s")
	SETLOG("DARK ELIXIR STORAGE CHECK C#....")
	$BuildingToLoc = GetLocationDarkElixirStorage
	SetLog("[" & UBound($BuildingToLoc) & "] Dark Elixir Storage")
	For $i = 0 To UBound($BuildingToLoc) - 1
		$pixel = $BuildingToLoc[$i]
		If $DebugSetlog = 1 Then SetLog("- Dark Elixir Storage " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_PURPLE)
	Next
	SETLOG("LOCATE BARRACKS C#..............")
	Local $PixelBarrackHere = GetLocationItem("getLocationBarrack")
	SetLog("Total No. of Barracks: " & UBound($PixelBarrackHere), $COLOR_PURPLE)
	For $i = 0 To UBound($PixelBarrackHere) - 1
		$pixel = $PixelBarrackHere[$i]
		If $DebugSetlog = 1 Then SetLog("- Barrack " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_PURPLE)
	Next
	SETLOG("LOCATE BARRACKS C#..............")
	Local $PixelDarkBarrackHere = GetLocationItem("getLocationDarkBarrack")
	SetLog("Total No. of Dark Barracks: " & UBound($PixelBarrackHere), $COLOR_PURPLE)
	For $i = 0 To UBound($PixelDarkBarrackHere) - 1
		$pixel = $PixelDarkBarrackHere[$i]
		If $DebugSetlog = 1 Then SetLog("- Dark Barrack " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_PURPLE)
	Next
	SetLog("WEAK BASE C#.....................", $COLOR_TEAL)
	; Weak Base Detection modified by LunaEclipse
	Local $weakBaseValues
	If $iChkWeakBase[$DB] = 1 Or $iChkWeakBase[$LB] = 1 Then
		$weakBaseValues = IsWeakBase()
	EndIf
	For $i = 0 To $iModeCount - 2
		If $iChkWeakBase[$i] = 1 Then
			If getIsWeak($weakBaseValues, $i) Then
				SetLog(StringUpper($sModeText[$i]) & " IS A WEAK BASE: TRUE", $COLOR_PURPLE)
			Else
				SetLog(StringUpper($sModeText[$i]) & " IS A WEAK BASE: FALSE", $COLOR_PURPLE)
			EndIf

			SetLog("Time taken: " & $weakBaseValues[5][0] & " " & $weakBaseValues[5][1], $COLOR_PURPLE)
		EndIf
	Next
	Setlog("--------------------------------------------------------------", $COLOR_TEAL)
	$debugBuildingPos = 0
	$debugDeadBaseImage = 0
EndFunc   ;==>btnAnalyzeVillage

Func btnVillageStat()
	GUICtrlSetState($lblVillageReportTemp, $GUI_HIDE)

	If GUICtrlGetState($lblResultGoldNow) = $GUI_ENABLE + $GUI_SHOW Then
		;hide normal values
		GUICtrlSetState($lblResultGoldNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultElixirNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultDENow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultGemNow, $GUI_ENABLE + $GUI_HIDE)
		;show stats values
		GUICtrlSetState($lblResultGoldHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultElixirHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultDEHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultRuntimeNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultAttackedHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultSkippedHourNow, $GUI_ENABLE + $GUI_SHOW)
		; hide normal pics
		GUICtrlSetState($picResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($picResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($picResultGemNow, $GUI_ENABLE + $GUI_HIDE)
		;show stats pics
		GUICtrlSetState($picResultRuntimeNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($picResultAttackedHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($picResultSkippedHourNow, $GUI_ENABLE + $GUI_SHOW)
	Else
		;show normal values
		GUICtrlSetState($lblResultGoldNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultElixirNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultDENow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultTrophyNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultBuilderNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultGemNow, $GUI_ENABLE + $GUI_SHOW)
		;hide stats values
		GUICtrlSetState($lblResultGoldHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultElixirHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultDEHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultRuntimeNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultAttackedHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultSkippedHourNow, $GUI_ENABLE + $GUI_HIDE)
		; show normal pics
		GUICtrlSetState($picResultTrophyNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($picResultBuilderNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($picResultGemNow, $GUI_ENABLE + $GUI_SHOW)
		;hide stats pics
		GUICtrlSetState($picResultRuntimeNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($picResultAttackedHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($picResultSkippedHourNow, $GUI_ENABLE + $GUI_HIDE)
	EndIf

EndFunc   ;==>btnVillageStat

Func btnTestDeadBase()
	Local $test = 0
	LoadTHImage()
	LoadElixirImage()
	LoadElixirImage75Percent()
	LoadElixirImage50Percent()
	Zoomout()
	If $debugBuildingPos = 0 Then
		$test = 1
		$debugBuildingPos = 1
	EndIf
	SETLOG("DEADBASE CHECK..................")
	$dbBase = checkDeadBase()
	SETLOG("TOWNHALL CHECK..................")
	$searchTH = checkTownhallADV2()
	If $test = 1 Then $debugBuildingPos = 0
EndFunc   ;==>btnTestDeadBase

Func btnTestDonate()
	$RunState = True
	SETLOG("DONATE TEST..................START")
	ZoomOut()
	saveconfig()
	readconfig()
	applyconfig()
	DonateCC()
	SETLOG("DONATE TEST..................STOP")
	$RunState = False
EndFunc   ;==>btnTestDonate

Func btnTestButtons()

	$RunState = True
	Local $ButtonX, $ButtonY
	Local $hTimer = TimerInit()
	Local $res
	Local $ImagesToUse[3]
	$ImagesToUse[0] = @ScriptDir & "\images\Button\Traps.png"
	$ImagesToUse[1] = @ScriptDir & "\images\Button\Xbow.png"
	$ImagesToUse[2] = @ScriptDir & "\images\Button\Inferno.png"
	Local $x = 1
	Local $y = 1
	Local $w = 615
	Local $h = 105

	$ToleranceImgLoc = 0.950

	SETLOG("SearchTile TEST..................START")
	;;;;;; Use the Polygon to a rectangle or Square search zone ;;;;;;;;;;
	$SearchArea = String($x & "|" & $y & "|" & $w & "|" & $h) ; x|y|Width|Height
	; form a polygon " top(x,y) | Right (w,y) | Bottom(w,h) | Left(x,h) "
	Local $AreaInRectangle = String($x + 1 & "," & $y + 1 & "|" & $w - 1 & "," & $y + 1 & "|" & $w - 1 & "," & $h - 1 & "|" & $x + 1 & "," & $h - 1)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	_CaptureRegion(125, 610, 740, 715)
	For $i = 0 To 2
		If FileExists($ImagesToUse[$i]) Then
			$res = DllCall($pImgLib, "str", "SearchTile", "handle", $hHBitmap2, "str", $ImagesToUse[$i], "float", $ToleranceImgLoc, "str", $SearchArea, "str", $AreaInRectangle)
			If @error Then _logErrorDLLCall($pImgLib, @error)
			If IsArray($res) Then
				If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
				If $res[0] = "0" Then
					; failed to find a loot cart on the field
					SetLog("No Button found")
				ElseIf $res[0] = "-1" Then
					SetLog("DLL Error", $COLOR_RED)
				ElseIf $res[0] = "-2" Then
					SetLog("Invalid Resolution", $COLOR_RED)
				Else
					$expRet = StringSplit($res[0], "|", 2)
					$ButtonX = 125 + Int($expRet[1])
					$ButtonY = 610 + Int($expRet[2])
					SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_GREEN)
					;If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
					If _Sleep(200) Then Return
					;Click(515, 400, 1, 0, "#0226")
					If _Sleep(200) Then Return
					If isGemOpen(True) = True Then
						Setlog("Not enough loot to rearm traps.....", $COLOR_RED)
						Click(585, 252, 1, 0, "#0227") ; Click close gem window "X"
						If _Sleep(200) Then Return
					Else
						If $i = 0 Then SetLog("Rearmed Trap(s)", $COLOR_GREEN)
						If $i = 1 Then SetLog("Reloaded XBow(s)", $COLOR_GREEN)
						If $i = 2 Then SetLog("Reloaded Inferno(s)", $COLOR_GREEN)
						If _Sleep(200) Then Return
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
	SETLOG("SearchTile TEST..................STOP")

	Local $hTimer = TimerInit()
	SETLOG("MBRSearchImage TEST..................STOP")

	For $i = 0 To 2
		If FileExists($ImagesToUse[$i]) Then
			_CaptureRegion2(125, 610, 740, 715)
			$res = DllCall($pImgLib, "str", "MBRSearchImage", "handle", $hHBitmap2, "str", $ImagesToUse[$i], "float", $ToleranceImgLoc)
			If @error Then _logErrorDLLCall($pImgLib, @error)
			If IsArray($res) Then
				If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
				If $res[0] = "0" Then
					; failed to find a loot cart on the field
					SetLog("No Button found")
				ElseIf $res[0] = "-1" Then
					SetLog("DLL Error", $COLOR_RED)
				ElseIf $res[0] = "-2" Then
					SetLog("Invalid Resolution", $COLOR_RED)
				Else
					$expRet = StringSplit($res[0], "|", 2)
					$ButtonX = 125 + Int($expRet[1])
					$ButtonY = 610 + Int($expRet[2])
					SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_GREEN)
					;If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
					If _Sleep(200) Then Return
					;Click(515, 400, 1, 0, "#0226")
					If _Sleep(200) Then Return
					If isGemOpen(True) = True Then
						Setlog("Not enough loot to rearm traps.....", $COLOR_RED)
						Click(585, 252, 1, 0, "#0227") ; Click close gem window "X"
						If _Sleep(200) Then Return
					Else
						If $i = 0 Then SetLog("Rearmed Trap(s)", $COLOR_GREEN)
						If $i = 1 Then SetLog("Reloaded XBow(s)", $COLOR_GREEN)
						If $i = 2 Then SetLog("Reloaded Inferno(s)", $COLOR_GREEN)
						If _Sleep(200) Then Return
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
	SETLOG("MBRSearchImage TEST..................STOP")
	$RunState = False

EndFunc   ;==>btnTestButtons

Func ButtonBoost()

	$RunState = True
	Local $ButtonX, $ButtonY
	Local $hTimer = TimerInit()
	Local $res
	Local $ImagesToUse[2]
	$ImagesToUse[0] = @ScriptDir & "\images\Button\BoostBarrack.png"
	$ImagesToUse[1] = @ScriptDir & "\images\Button\BarrackBoosted.png"
	$ToleranceImgLoc = 0.90
	SETLOG("MBRSearchImage TEST..................STARTED")
	_CaptureRegion2(125, 610, 740, 715)
	For $i = 0 To 1
		If FileExists($ImagesToUse[$i]) Then
			$res = DllCall($pImgLib, "str", "MBRSearchImage", "handle", $hHBitmap2, "str", $ImagesToUse[$i], "float", $ToleranceImgLoc)
			If @error Then _logErrorDLLCall($pImgLib, @error)
			If IsArray($res) Then
				If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_RED)
				If $res[0] = "0" Then
					; failed to find a loot cart on the field
					If $i = 1 Then SetLog("No Button found")
				ElseIf $res[0] = "-1" Then
					SetLog("DLL Error", $COLOR_RED)
				ElseIf $res[0] = "-2" Then
					SetLog("Invalid Resolution", $COLOR_RED)
				Else
					If _Sleep(200) Then Return
					If $i = 0 Then
						SetLog("Found the Button to Boost individual")
						$expRet = StringSplit($res[0], "|", 2)
						$ButtonX = 125 + Int($expRet[1])
						$ButtonY = 610 + Int($expRet[2])
						SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_GREEN)
						;If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
						ExitLoop
					Else
						SetLog("The Barrack is already boosted!")
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
	SETLOG("MBRSearchImage TEST..................STOP")
	$RunState = False

EndFunc


Func arrows()
	getArmyHeroCount()
EndFunc
