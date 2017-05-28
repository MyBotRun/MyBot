; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), KnowJack(July 2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_aFrmBotBottomCtrlState, $g_hFrmBotEmbeddedShield = 0, $g_hFrmBotEmbeddedMouse = 0, $g_hFrmBotEmbeddedGraphics = 0

Func Initiate()
	Static $bCheckLanguageFirst = False
	WinGetAndroidHandle()
	If $g_hAndroidWindow <> 0 And ($g_bAndroidBackgroundLaunched = True Or AndroidControlAvailable()) Then
		SetLogCentered(" " & $g_sBotTitle & " Powered by MyBot.run ", "~", $COLOR_DEBUG)

		Local $Compiled = @ScriptName & (@Compiled ? " Executable" : " Script")
		SetLog($Compiled & " running on " & @OSVersion & " " & @OSServicePack & " " & @OSArch)
		If Not $g_bSearchMode Then
			SetLogCentered(" Bot Start ", Default, $COLOR_SUCCESS)
		Else
			SetLogCentered(" Search Mode Start ", Default, $COLOR_SUCCESS)
		EndIf
		SetLogCentered("  Current Profile: " & $g_sProfileCurrentName & " ", "-", $COLOR_INFO)
		If $g_iDebugSetlog = 1 Or $g_iDebugOcr = 1 Or $g_iDebugRedArea = 1 Or $g_bDevMode = True Or $g_iDebugImageSave = 1 Or $g_iDebugBuildingPos = 1 Or $g_iDebugOCRdonate = 1 Or $g_iDebugAttackCSV = 1 Then
			SetLogCentered(" Warning Debug Mode Enabled! ", "-", $COLOR_ERROR)
			SetLog("      Setlog : " & $g_iDebugSetlog, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("         OCR : " & $g_iDebugOcr, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("     RedArea : " & $g_iDebugRedArea, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("   ImageSave : " & $g_iDebugImageSave, $COLOR_ERROR, "Lucida Console", 8)
			SetLog(" BuildingPos : " & $g_iDebugBuildingPos, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("   OCRDonate : " & $g_iDebugOCRdonate, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("   AttackCSV : " & $g_iDebugAttackCSV, $COLOR_ERROR, "Lucida Console", 8)
			SetLogCentered(" Warning Debug Mode Enabled! ", "-", $COLOR_ERROR)
		EndIf

		$g_bFirstStart = True

		If $g_bNotifyDeleteAllPushesOnStart = True Then _DeletePush()

		If Not $g_bSearchMode Then
			$g_hTimerSinceStarted = __TimerInit()
		EndIf

		AndroidBotStartEvent() ; signal android that bot is now running
		If Not $g_bRunState Then Return

		;		$g_bRunState = True

		If Not $g_bSearchMode Then
			;AdlibRegister("SetTime", 1000)
			If $g_bRestarted = True Then
				$g_bRestarted = False
				IniWrite($g_sProfileConfigPath, "general", "Restarted", 0)
				PushMsg("Restarted")
			EndIf
		EndIf
		If Not $g_bRunState Then Return

		AndroidShield("Initiate", True)
		checkMainScreen()
		If Not $g_bRunState Then Return

		ZoomOut()
		If Not $g_bRunState Then Return

		If Not $g_bSearchMode Then
			BotDetectFirstTime()
			If Not $g_bRunState Then Return

			If $bCheckLanguageFirst = False And $g_bCheckGameLanguage Then
				TestLanguage()
				$bCheckLanguageFirst = True
			EndIf
			If Not $g_bRunState Then Return

			runBot()
		EndIf
	Else
		SetLog("Not in Game!", $COLOR_ERROR)
		;		$g_bRunState = True
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

		SetDebugLog("InitiateLayout: " & $g_sAndroidTitle & " Android-ClientSize: " & $BSx & " x " & $BSy, $COLOR_INFO)

		If Not CheckScreenAndroid($BSx, $BSy) Then ; Is Client size now correct?
			If $AdjustScreenIfNecessarry = True Then
				Local $MsgRet = $IDOK
				;If _Sleep(3000) Then Return False
				;Local $MsgRet = MsgBox(BitOR($MB_OKCANCEL, $MB_SYSTEMMODAL), "Change the resolution and restart " & $g_sAndroidEmulator & "?", _
				;	"Click OK to adjust the screen size of " & $g_sAndroidEmulator & " and restart the emulator." & @CRLF & _
				;	"If your " & $g_sAndroidEmulator & " really has the correct size (" & $g_iDEFAULT_WIDTH & " x " & $g_iDEFAULT_HEIGHT & "), click CANCEL." & @CRLF & _
				;	"(Automatically Cancel in 15 Seconds)", 15)

				If $MsgRet = $IDOK Then
					Return RebootAndroidSetScreen() ; recursive call!
					;Return "RebootAndroidSetScreen()"
				EndIf
			Else
				SetLog("Cannot use " & $g_sAndroidEmulator & ".", $COLOR_ERROR)
				SetLog("Please set its screen size manually to " & $g_iAndroidClientWidth & " x " & $g_iAndroidClientHeight, $COLOR_ERROR)
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
	If GUICtrlRead($g_hChkBackgroundMode) = $GUI_CHECKED Then
		$g_bChkBackgroundMode = True
		updateBtnHideState($GUI_ENABLE)
	Else
		$g_bChkBackgroundMode = False
		updateBtnHideState($GUI_DISABLE)
	EndIf
	If CheckDpiAwareness() Then
		; DPI awareness changed
	EndIf
EndFunc   ;==>chkBackground

Func IsStopped()
	If $g_bRunState Then Return False
	If $g_bRestart Then Return True
	Return False
EndFunc   ;==>IsStopped

Func btnStart()
	; decide when to run
	EnableControls($g_hFrmBotBottom, False, $g_aFrmBotBottomCtrlState)
	Local $RunNow = $g_iBotAction <> $eBotNoAction
	If $RunNow Then
		BotStart()
	Else
		$g_iBotAction = $eBotStart
	EndIf
	$g_iActualTrainSkip = 0
EndFunc   ;==>btnStart

Func btnStop()
	If $g_bRunState Then
		; always invoked in MyBot.run.au3!
		EnableControls($g_hFrmBotBottom, False, $g_aFrmBotBottomCtrlState)
		$g_bRunState = False ; Exit BotStart()
		$g_iBotAction = $eBotStop
		ReduceBotMemory()
	EndIf
EndFunc   ;==>btnStop

Func btnSearchMode()
	; decide when to run
	EnableControls($g_hFrmBotBottom, False, $g_aFrmBotBottomCtrlState)
	Local $RunNow = $g_iBotAction <> $eBotNoAction
	If $RunNow Then
		BotSearchMode()
	Else
		$g_iBotAction = $eBotSearchMode
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
	If $g_bRunState Then
		$g_bBtnAttackNowPressed = True
		$g_iMatchMode = $DB
	EndIf
EndFunc   ;==>btnAttackNowDB

Func btnAttackNowLB()
	If $g_bRunState Then
		$g_bBtnAttackNowPressed = True
		$g_iMatchMode = $LB
	EndIf
EndFunc   ;==>btnAttackNowLB

Func btnAttackNowTS()
	If $g_bRunState Then
		$g_bBtnAttackNowPressed = True
		$g_iMatchMode = $TS
	EndIf
EndFunc   ;==>btnAttackNowTS

;~ Hide Android Window again without overwriting $botPos[0] and [1]
Func reHide()
	WinGetAndroidHandle()
	If $g_bIsHidden = True And $g_hAndroidWindow <> 0 And $g_bAndroidEmbedded = False Then
		SetDebugLog("Hide " & $g_sAndroidEmulator & " Window after restart")
		Return WinMove($g_hAndroidWindow, "", -32000, -32000)
	EndIf
	Return 0
EndFunc   ;==>reHide

Func updateBtnHideState($newState = $GUI_ENABLE)
	Local $hideState = GUICtrlGetState($g_hBtnHide)
	Local $newHideState = ($g_bAndroidEmbedded = True ? $GUI_DISABLE : $newState)
	If $hideState <> $newHideState Then GUICtrlSetState($g_hBtnHide, $newHideState)
EndFunc   ;==>updateBtnHideState

Func btnHide()
	If $g_bIsHidden = False Then
		GUICtrlSetData($g_hBtnHide, GetTranslatedFileIni("MBR GUI Control Bottom", "Func_btnHide_False", "Show"))
		HideAndroidWindow(True)
		$g_bIsHidden = True
	ElseIf $g_bIsHidden = True Then
		GUICtrlSetData($g_hBtnHide, GetTranslatedFileIni("MBR GUI Control Bottom", "Func_btnHide_True", "Hide"))
		HideAndroidWindow(False)
		$g_bIsHidden = False
	EndIf
EndFunc   ;==>btnHide

Func updateBtnEmbed()
	If $g_hBtnEmbed = 0 Then Return False
	UpdateFrmBotStyle()
	Local $state = GUICtrlGetState($g_hBtnEmbed)
	If $g_hAndroidWindow = 0 Or $g_bAndroidBackgroundLaunched = True Or $g_bAndroidEmbed = False Then
		If $state <> $GUI_DISABLE Then GUICtrlSetState($g_hBtnEmbed, $GUI_DISABLE)
		Return False
	EndIf

	Local $text = GUICtrlRead($g_hBtnEmbed)
	Local $newText
	If $g_bAndroidEmbedded = True Then
		$newText = GetTranslatedFileIni("MBR GUI Control Bottom", "Func_AndroidEmbedded_False", "Undock")
	Else
		$newText = GetTranslatedFileIni("MBR GUI Control Bottom", "Func_AndroidEmbedded_True", "Dock")
	EndIf
	If $text <> $newText Then GUICtrlSetData($g_hBtnEmbed, $newText)
	If $state <> $GUI_ENABLE Then GUICtrlSetState($g_hBtnEmbed, $GUI_ENABLE)
	; also update hide button
	updateBtnHideState()
	Return True
EndFunc   ;==>updateBtnEmbed

Func btnEmbed()
	ResumeAndroid()
	WinGetAndroidHandle()
	WinGetPos($g_hAndroidWindow)
	If @error <> 0 Then Return SetError(0, 0, 0)
	AndroidEmbed(Not $g_bAndroidEmbedded)
EndFunc   ;==>btnEmbed

Func btnMakeScreenshot()
	If $g_bRunState Then $g_bMakeScreenshotNow = True
EndFunc   ;==>btnMakeScreenshot

Func GetFont()
	Local $i, $sText = "", $DefaultFont
	$DefaultFont = __EMB_GetDefaultFont()
	For $i = 0 To UBound($DefaultFont) - 1
		$sText &= " $DefaultFont[" & $i & "]= " & $DefaultFont[$i] & ", "
	Next
	Setlog($sText, $COLOR_DEBUG)
EndFunc   ;==>GetFont



Func btnAnalyzeVillage()
	$g_iDebugBuildingPos = 1
	$g_iDebugDeadBaseImage = 1
	SETLOG("DEADBASE CHECK..................")
	checkDeadBase()

	SETLOG("TOWNHALL CHECK imgloc..................")
	$g_iSearchTH = imgloccheckTownhallADV2()

	SETLOG("TOWNHALL C# CHECK. IMGLOC..............")
	imglocTHSearch()

	SETLOG("MINE CHECK C#...................")
	$g_aiPixelMine = GetLocationMine()
	SetLog("[" & UBound($g_aiPixelMine) & "] Gold Mines")
	SETLOG("ELIXIR CHECK C#.................")
	$g_aiPixelElixir = GetLocationElixir()
	SetLog("[" & UBound($g_aiPixelElixir) & "] Elixir Collectors")

	SETLOG("DARK ELIXIR CHECK C#............")
	$g_aiPixelDarkElixir = GetLocationDarkElixir()
	SetLog("[" & UBound($g_aiPixelDarkElixir) & "] Dark Elixir Drill/s")

	SETLOG("DARK ELIXIR STORAGE CHECK C#....")
	$g_iBuildingToLoc = GetLocationDarkElixirStorage
	SetLog("[" & UBound($g_iBuildingToLoc) & "] Dark Elixir Storage")
	For $i = 0 To UBound($g_iBuildingToLoc) - 1
		Local $pixel = $g_iBuildingToLoc[$i]
		If $g_iDebugSetlog = 1 Then SetLog("- Dark Elixir Storage " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_DEBUG)
	Next

	SETLOG("LOCATE BARRACKS C#..............")
	Local $PixelBarrackHere = GetLocationItem("getLocationBarrack")
	SetLog("Total No. of Barracks: " & UBound($PixelBarrackHere), $COLOR_DEBUG)
	For $i = 0 To UBound($PixelBarrackHere) - 1
		Local $pixel = $PixelBarrackHere[$i]
		If $g_iDebugSetlog = 1 Then SetLog("- Barrack " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_DEBUG)
	Next

	SETLOG("LOCATE BARRACKS C#..............")
	Local $PixelDarkBarrackHere = GetLocationItem("getLocationDarkBarrack")
	SetLog("Total No. of Dark Barracks: " & UBound($PixelBarrackHere), $COLOR_DEBUG)
	For $i = 0 To UBound($PixelDarkBarrackHere) - 1
		Local $pixel = $PixelDarkBarrackHere[$i]
		If $g_iDebugSetlog = 1 Then SetLog("- Dark Barrack " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_DEBUG)
    Next

	SetLog("WEAK BASE C#.....................", $COLOR_DEBUG1)
	; Weak Base Detection modified by LunaEclipse
	Local $weakBaseValues
	If IsWeakBaseActive($DB) Or IsWeakBaseActive($LB) Then
		$weakBaseValues = IsWeakBase()
	EndIf
	For $i = 0 To $g_iModeCount - 2
		If IsWeakBaseActive($i) Then
			If getIsWeak($weakBaseValues, $i) Then
				SetLog(StringUpper($g_asModeText[$i]) & " IS A WEAK BASE: TRUE", $COLOR_DEBUG)
			Else
				SetLog(StringUpper($g_asModeText[$i]) & " IS A WEAK BASE: FALSE", $COLOR_DEBUG)
			EndIf

			SetLog("Time taken: " & $weakBaseValues[5][0] & " " & $weakBaseValues[5][1], $COLOR_DEBUG)
		EndIf
    Next

	Setlog("--------------------------------------------------------------", $COLOR_DEBUG1)
	$g_iDebugBuildingPos = 0
	$g_iDebugDeadBaseImage = 0
EndFunc   ;==>btnAnalyzeVillage

Func btnVillageStat($source = "")

	If $g_iFirstRun = 0 And $g_bRunState = True And $g_bBotPaused = False Then SetTime(True)

	If GUICtrlGetState($g_hLblResultGoldNow) = $GUI_ENABLE + $GUI_SHOW Then
		;hide normal values
		GUICtrlSetState($g_hLblResultGoldNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultElixirNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultDENow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultGemNow, $GUI_ENABLE + $GUI_HIDE)
		;show stats values
		GUICtrlSetState($g_hLblResultGoldHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultElixirHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultDEHourNow, $GUI_ENABLE + $GUI_SHOW)
		If $g_iFirstRun = 0 Or $source = "UpdateStats" Then
			GUICtrlSetState($g_hLblResultRuntimeNow, $GUI_ENABLE + $GUI_SHOW)
			GUICtrlSetState($g_hLblResultAttackedHourNow, $GUI_ENABLE + $GUI_SHOW)
			GUICtrlSetState($g_hLblResultSkippedHourNow, $GUI_ENABLE + $GUI_SHOW)
		EndIf
		; hide normal pics
		GUICtrlSetState($g_hPicResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hPicResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hPicResultGemNow, $GUI_ENABLE + $GUI_HIDE)
		;show stats pics
		GUICtrlSetState($g_hPicResultRuntimeNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hPicResultAttackedHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hPicResultSkippedHourNow, $GUI_ENABLE + $GUI_SHOW)
	Else
		;show normal values
		GUICtrlSetState($g_hLblResultGoldNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultElixirNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultDENow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultTrophyNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultBuilderNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultGemNow, $GUI_ENABLE + $GUI_SHOW)
		;hide stats values
		GUICtrlSetState($g_hLblResultGoldHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultElixirHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultDEHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultRuntimeNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultAttackedHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultSkippedHourNow, $GUI_ENABLE + $GUI_HIDE)
		; show normal pics
		GUICtrlSetState($g_hPicResultTrophyNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hPicResultBuilderNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hPicResultGemNow, $GUI_ENABLE + $GUI_SHOW)
		;hide stats pics
		GUICtrlSetState($g_hPicResultRuntimeNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hPicResultAttackedHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hPicResultSkippedHourNow, $GUI_ENABLE + $GUI_HIDE)
	EndIf

EndFunc   ;==>btnVillageStat

Func btnTestDonate()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	SETLOG("DONATE TEST..................START")
	ZoomOut()
	saveconfig()
	readconfig()
	applyconfig()
	DonateCC()
	SETLOG("DONATE TEST..................STOP")
	$g_bRunState = $wasRunState
EndFunc   ;==>btnTestDonate

Func btnTestButtons()

	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	Local $ButtonX, $ButtonY
	Local $hTimer = __TimerInit()
	Local $res
	Local $ImagesToUse[3]
	$ImagesToUse[0] = @ScriptDir & "\imgxml\rearm\Traps_0_90.xml"
	$ImagesToUse[1] = @ScriptDir & "\imgxml\rearm\Xbow_0_90.xml"
	$ImagesToUse[2] = @ScriptDir & "\imgxml\rearm\Inferno_0_90.xml"
	Local $x = 1
	Local $y = 1
	Local $w = 615
	Local $h = 105

	$g_fToleranceImgLoc = 0.950

	SETLOG("SearchTile TEST..................START")
	;;;;;; Use the Polygon to a rectangle or Square search zone ;;;;;;;;;;
	Local $SearchArea = String($x & "|" & $y & "|" & $w & "|" & $h) ; x|y|Width|Height
	; form a polygon " top(x,y) | Right (w,y) | Bottom(w,h) | Left(x,h) "
	Local $AreaInRectangle = String($x + 1 & "," & $y + 1 & "|" & $w - 1 & "," & $y + 1 & "|" & $w - 1 & "," & $h - 1 & "|" & $x + 1 & "," & $h - 1)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	_CaptureRegion(125, 610, 740, 715)

	For $i = 0 To 2
		If FileExists($ImagesToUse[$i]) Then
			$res = DllCall($g_hLibImgLoc, "str", "FindTile", "handle", $g_hHBitmap2, "str", $ImagesToUse[$i], "str", $SearchArea, "str", $AreaInRectangle)
			If @error Then _logErrorDLLCall($g_sLibImgLocPath, @error)
			If IsArray($res) Then
				If $g_iDebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_ERROR)
				If $res[0] = "0" Then
					; failed to find a loot cart on the field
					SetLog("No Button found")
				ElseIf $res[0] = "-1" Then
					SetLog("DLL Error", $COLOR_ERROR)
				ElseIf $res[0] = "-2" Then
					SetLog("Invalid Resolution", $COLOR_ERROR)
				Else
					Local $expRet = StringSplit($res[0], "|", 2)
					$ButtonX = 125 + Int($expRet[1])
					$ButtonY = 610 + Int($expRet[2])
					SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_SUCCESS)
					;If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
					_Sleep(200)
					;Click(515, 400, 1, 0, "#0226")
					_Sleep(200)
					If isGemOpen(True) = True Then
						Setlog("Not enough loot to rearm traps.....", $COLOR_ERROR)
						Click(585, 252, 1, 0, "#0227") ; Click close gem window "X"
						_Sleep(200)
					Else
						If $i = 0 Then SetLog("Rearmed Trap(s)", $COLOR_SUCCESS)
						If $i = 1 Then SetLog("Reloaded XBow(s)", $COLOR_SUCCESS)
						If $i = 2 Then SetLog("Reloaded Inferno(s)", $COLOR_SUCCESS)
						_Sleep(200)
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	SetLog("  - Calculated  in: " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_DEBUG1)
	SETLOG("SearchTile TEST..................STOP")

	Local $hTimer = __TimerInit()
	SETLOG("MBRSearchImage TEST..................STOP")

	For $i = 0 To 2
		If FileExists($ImagesToUse[$i]) Then
			_CaptureRegion2(125, 610, 740, 715)
			$res = DllCall($g_hLibImgLoc, "str", "FindTile", "handle", $g_hHBitmap2, "str", $ImagesToUse[$i], "str", "FV", "int", 1)
			If @error Then _logErrorDLLCall($g_sLibImgLocPath, @error)
			If IsArray($res) Then
				If $g_iDebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_ERROR)
				If $res[0] = "0" Then
					; failed to find a loot cart on the field
					SetLog("No Button found")
				ElseIf $res[0] = "-1" Then
					SetLog("DLL Error", $COLOR_ERROR)
				ElseIf $res[0] = "-2" Then
					SetLog("Invalid Resolution", $COLOR_ERROR)
				Else
					$expRet = StringSplit($res[0], "|", 2)
					$ButtonX = 125 + Int($expRet[1])
					$ButtonY = 610 + Int($expRet[2])
					SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_SUCCESS)
					;If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
					_Sleep(200)
					;Click(515, 400, 1, 0, "#0226")
					_Sleep(200)
					If isGemOpen(True) = True Then
						Setlog("Not enough loot to rearm traps.....", $COLOR_ERROR)
						Click(585, 252, 1, 0, "#0227") ; Click close gem window "X"
						_Sleep(200)
					Else
						If $i = 0 Then SetLog("Rearmed Trap(s)", $COLOR_SUCCESS)
						If $i = 1 Then SetLog("Reloaded XBow(s)", $COLOR_SUCCESS)
						If $i = 2 Then SetLog("Reloaded Inferno(s)", $COLOR_SUCCESS)
						_Sleep(200)
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	SetLog("  - Calculated  in: " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_DEBUG1)

	SETLOG("MBRSearchImage TEST..................STOP")
	$g_bRunState = $wasRunState

EndFunc   ;==>btnTestButtons

Func ButtonBoost()

	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	Local $ButtonX, $ButtonY
	Local $hTimer = __TimerInit()
	Local $res
	Local $ImagesToUse[2]
	$ImagesToUse[0] = @ScriptDir & "\imgxml\boostbarracks\BoostBarrack_0_92.xml"
	$ImagesToUse[1] = @ScriptDir & "\imgxml\boostbarracks\BarrackBoosted_0_92.xml"
	$g_fToleranceImgLoc = 0.90
	SETLOG("MBRSearchImage TEST..................STARTED")
	_CaptureRegion2(125, 610, 740, 715)
	For $i = 0 To 1
		If FileExists($ImagesToUse[$i]) Then
			$res = DllCall($g_hLibImgLoc, "str", "FindTile", "handle", $g_hHBitmap2, "str", $ImagesToUse[$i], "str", "FV", "int", 1)
			If @error Then _logErrorDLLCall($g_sLibImgLocPath, @error)
			If IsArray($res) Then
				If $g_iDebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_ERROR)
				If $res[0] = "0" Then
					; failed to find a loot cart on the field
					If $i = 1 Then SetLog("No Button found")
				ElseIf $res[0] = "-1" Then
					SetLog("DLL Error", $COLOR_ERROR)
				ElseIf $res[0] = "-2" Then
					SetLog("Invalid Resolution", $COLOR_ERROR)
				Else
					_Sleep(200)
					If $i = 0 Then
						SetLog("Found the Button to Boost individual")
						Local $expRet = StringSplit($res[0], "|", 2)
						$ButtonX = 125 + Int($expRet[1])
						$ButtonY = 610 + Int($expRet[2])
						SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_SUCCESS)
						;If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
						ExitLoop
					Else
						SetLog("The Barrack is already boosted!")
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	SetLog("  - Calculated  in: " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_DEBUG1)
	SETLOG("MBRSearchImage TEST..................STOP")
	$g_bRunState = $wasRunState

EndFunc   ;==>ButtonBoost

Func arrows()
	getArmyHeroCount()
EndFunc   ;==>arrows

Func EnableGuiControls($OptimizedRedraw = True)
	Return ToggleGuiControls(True, $OptimizedRedraw)
EndFunc   ;==>EnableGuiControls

Func DisableGuiControls($OptimizedRedraw = True)
	Return ToggleGuiControls(False, $OptimizedRedraw)
EndFunc   ;==>DisableGuiControls

Func ToggleGuiControls($Enable, $OptimizedRedraw = True)
	If $OptimizedRedraw = True Then Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "ToggleGuiControls")
	If $Enable = False Then
		SetDebugLog("Disable GUI Controls")
	Else
		SetDebugLog("Enable GUI Controls")
	EndIf
	$g_bGUIControlDisabled = True
	For $i = $g_hFirstControlToHide To $g_hLastControlToHide
		If IsAlwaysEnabledControl($i) Then ContinueLoop
		If $g_bNotifyPBEnable And $i = $g_hBtnNotifyDeleteMessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
		If $Enable = False Then
			; Save state of all controls on tabs
			$g_aiControlPrevState[$i] = BitAND(GUICtrlGetState($i), $GUI_ENABLE)
			If $g_aiControlPrevState[$i] Then GUICtrlSetState($i, $GUI_DISABLE)
		Else
			; Restore previous state of controls
			If $g_aiControlPrevState[$i] Then GUICtrlSetState($i, $g_aiControlPrevState[$i])
		EndIf
	Next
	If $Enable = False Then
		ControlDisable("", "", $g_hCmbGUILanguage)
	Else
		ControlEnable("", "", $g_hCmbGUILanguage)
	EndIf
	$g_bGUIControlDisabled = False
	If $OptimizedRedraw = True Then SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "ToggleGuiControls")
EndFunc   ;==>ToggleGuiControls
