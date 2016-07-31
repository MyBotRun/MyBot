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
    If $HWnD <> 0 And ($AndroidBackgroundLaunched = True Or AndroidControlAvailable()) Then
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

		AndroidShield("Initiate", True)
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

	Local $AdjustScreenIfNecessarry = True
	WinGetAndroidHandle()
	Local $BSsize = getAndroidPos()

	If IsArray($BSsize) Then ; Is Android Client Control available?

		Local $BSx = $BSsize[2]
		Local $BSy = $BSsize[3]

		SetDebugLog("InitiateLayout: " & $title & " Android-ClientSize: " & $BSx & " x " & $BSy, $COLOR_BLUE)

		If Not CheckScreenAndroid($BSx, $BSy) Then ; Is Client size now correct?
			If $AdjustScreenIfNecessarry = True Then
				Local $MsgRet = $IDOK
				;If _Sleep(3000) Then Return False
				;Local $MsgRet = MsgBox(BitOR($MB_OKCANCEL, $MB_SYSTEMMODAL), "Change the resolution and restart " & $Android & "?", _
				;	"Click OK to adjust the screen size of " & $Android & " and restart the emulator." & @CRLF & _
				;	"If your " & $Android & " really has the correct size (" & $DEFAULT_WIDTH & " x " & $DEFAULT_HEIGHT & "), click CANCEL." & @CRLF & _
				;	"(Automatically Cancel in 15 Seconds)", 15)

				If $MsgRet = $IDOK Then
					Return RebootAndroidSetScreen() ; recursive call!
					;Return "RebootAndroidSetScreen()"
				EndIf
			Else
				SetLog("Cannot use " & $Android & ".", $COLOR_RED)
				SetLog("Please set its screen size manually to " & $AndroidClientWidth & " x " & $AndroidClientHeight, $COLOR_RED)
				btnStop()
				Return False
			EndIf
		EndIf

		DisposeWindows()
		Return True

	EndIf

	Return False

EndFunc   ;==>InitiateLayout

Func chkBackground()
	If GUICtrlRead($chkBackground) = $GUI_CHECKED Then
		$ichkBackground = 1
		updateBtnHideState($GUI_ENABLE)
	Else
		$ichkBackground = 0
		updateBtnHideState($GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBackground

Func IsStopped()
	If $RunState Then Return False
	If $Restart Then Return True
	Return False
EndFunc   ;==>IsStopped

Func btnStart()
	; decide when to run
	EnableControls($frmBotBottom, False, $frmBotBottomCtrlState)
	Local $RunNow = $BotAction <> $eBotNoAction
	If $RunNow Then
		BotStart()
	Else
		$BotAction = $eBotStart
	EndIf
EndFunc   ;==>btnStart

Func btnStop()
	; always invoked in MyBot.run.au3!
	EnableControls($frmBotBottom, False, $frmBotBottomCtrlState)
	$RunState = False ; Exit BotStart()
	$BotAction = $eBotStop
EndFunc   ;==>btnStop

Func btnSearchMode()
	; decide when to run
	EnableControls($frmBotBottom, False, $frmBotBottomCtrlState)
	Local $RunNow = $BotAction <> $eBotNoAction
	If $RunNow Then
		BotSearchMode()
	Else
		$BotAction = $eBotSearchMode
	EndIf
EndFunc   ;==>btnSearchMode

Func btnPause($RunNow = True)
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
	If $Hide = True And $HWnD <> 0 And $AndroidEmbedded = False Then
		SetDebugLog("Hide " & $Android & " Window after restart")
		Return WinMove2($HWnD, "", -32000, -32000)
	EndIf
	Return 0
EndFunc   ;==>reHide

Func updateBtnHideState($newState = $GUI_ENABLE)
	Local $hideState = GUICtrlGetState($btnHide)
	Local $newHideState = ($AndroidEmbedded = True ? $GUI_DISABLE : $newState)
	If $hideState <> $newHideState Then GUICtrlSetState($btnHide, $newHideState)
EndFunc	  ;==>updateBtnHideState

Func btnHide()
	ResumeAndroid()
	WinGetAndroidHandle() ; updates android position
	WinGetPos($HWnD)
	If @error <> 0 Then Return SetError(0, 0, 0)

	If $Hide = False Then
		GUICtrlSetData($btnHide, GetTranslated(602, 26, "Show"))
		Local $a = WinGetPos($HWnD)
		WinMove2($HWnD, "", -32000, -32000)
		$Hide = True
	Else
		GUICtrlSetData($btnHide, GetTranslated(602, 11, "Hide"))

		WinMove2($HWnD, "", $AndroidPosX, $AndroidPosY)
		WinActivate($HWnD)
		$Hide = False
	EndIf
EndFunc   ;==>btnHide

Func updateBtnEmbed()
	If IsDeclared("btnEmbed") = $DECLARED_UNKNOWN Then Return False
	UpdateFrmBotStyle()
	Local $state = GUICtrlGetState($btnEmbed)
	If $HWnD = 0 Or $AndroidBackgroundLaunched = True Or $AndroidEmbed = False Then
		If $state <> $GUI_DISABLE Then GUICtrlSetState($btnEmbed, $GUI_DISABLE)
		Return False
	EndIf

	Local $text = GUICtrlRead($btnEmbed)
	Local $newText
	If $AndroidEmbedded = True Then
		$newText = GetTranslated(602, 28, "Undock")
	Else
		$newText = GetTranslated(602, 27, "Dock")
	EndIf
	If $text <> $newText Then GUICtrlSetData($btnEmbed, $newText)
	If $state <> $GUI_ENABLE Then GUICtrlSetState($btnEmbed, $GUI_ENABLE)
	; also update hide button
	updateBtnHideState()
	Return True
EndFunc   ;==>updateBtnEmbed

Func btnEmbed()
	ResumeAndroid()
	WinGetAndroidHandle()
	WinGetPos($HWnD)
	If @error <> 0 Then Return SetError(0, 0, 0)
	AndroidEmbed(Not $AndroidEmbedded)
EndFunc   ;==>btnHide

Func btnMakeScreenshot()
	If $RunState Then $iMakeScreenshotNow = True
EndFunc   ;==>btnMakeScreenshot

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
	If IsWeakBaseActive($DB) Or IsWeakBaseActive($LB) Then
		$weakBaseValues = IsWeakBase()
	EndIf
	For $i = 0 To $iModeCount - 2
		If IsWeakBaseActive($i) Then
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

Func EnableGuiControls($OptimizedRedraw = True)
	Return ToggleGuiControls(True, $OptimizedRedraw)
EndFunc   ;==>EnableGuiControls

Func DisableGuiControls($OptimizedRedraw = True)
	Return ToggleGuiControls(False, $OptimizedRedraw)
EndFunc   ;==>DisableGuiControls

Func ToggleGuiControls($Enable, $OptimizedRedraw = True)
	If $OptimizedRedraw = True Then SetRedrawBotWindow(False)
	If $Enable = False Then
		SetDebugLog("Disable GUI Controls")
	Else
		SetDebugLog("Enable GUI Controls")
	EndIf
	$GUIControl_Disabled = True
	For $i = $FirstControlToHide To $LastControlToHide
		If IsTab($i) Or IsAlwaysEnabledControl($i) Then ContinueLoop
		If $PushBulletEnabled And $i = $btnDeletePBmessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
		If $i = $btnMakeScreenshot Then ContinueLoop ; exclude
		If $i = $divider Then ContinueLoop ; exclude divider
		If $Enable = False Then
			; Save state of all controls on tabs
			$iPrevState[$i] = GUICtrlGetState($i)
			GUICtrlSetState($i, $GUI_DISABLE)
		Else
			; Restore previous state of controls
			GUICtrlSetState($i, $iPrevState[$i])
		EndIf
	Next
	$GUIControl_Disabled = False
	If $OptimizedRedraw = True Then SetRedrawBotWindow(True)
EndFunc   ;==>ToggleGuiControls