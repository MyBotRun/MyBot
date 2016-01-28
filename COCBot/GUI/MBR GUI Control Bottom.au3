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
	If $HWnD <> 0 And IsArray(ControlGetPos($Title, $AppPaneName, $AppClassInstance)) Then
		;WinActivate($Title)
		SetLog(_PadStringCenter(" " & $sBotTitle & " Powered by MyBot.run ", 50, "~"), $COLOR_PURPLE)
		SetLog($Compiled & " running on " & @OSVersion & " " & @OSServicePack & " " & @OSArch)
		If Not $bSearchMode Then
			SetLog(_PadStringCenter(" Bot Start ", 50, "="), $COLOR_GREEN)
		Else
			SetLog(_PadStringCenter(" Search Mode Start ", 50, "="), $COLOR_GREEN)
		EndIf
		SetLog(_PadStringCenter("  Current Profile: " & $sCurrProfile & " ", 73, "-"), $COLOR_BLUE)
		If $DebugSetlog = 1 Or $DebugOcr = 1 Or $debugRedArea = 1 Or $DevMode = 1 or $debugImageSave = 1 or $debugBuildingPos = 1 Then
			SetLog(_PadStringCenter(" Warning Debug Mode Enabled! Setlog: " & $DebugSetlog &" OCR: "& $DebugOcr & " RedArea: " & $debugRedArea & " ImageSave: " & $debugImageSave & " BuildingPos: " & $debugBuildingPos, 55, "-"), $COLOR_RED)
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

	  DisableBS($HWnD, $SC_MINIMIZE)
	  DisableBS($HWnD, $SC_MAXIMIZE)
	  ;DisableBS($HWnD, $SC_CLOSE) ; don't tamper with the close button

;		$RunState = True
;	 If $iDisposeWindows = 1 Then
;		 Switch $icmbDisposeWindowsPos
;			 Case 0
;				 WindowsArrange("BS-BOT",  $iWAOffsetX, $iWAOffsetY)
;			 Case 1
;				 WindowsArrange("BOT-BS",  $iWAOffsetX, $iWAOffsetY)
;			 Case 2
;				 WindowsArrange("SNAP-TR", $iWAOffsetX, $iWAOffsetY)
;			 Case 3
;				 WindowsArrange("SNAP-TL", $iWAOffsetX, $iWAOffsetY)
;			 Case 4
;				 WindowsArrange("SNAP-BR", $iWAOffsetX, $iWAOffsetY)
;			 Case 5
;				 WindowsArrange("SNAP-BL", $iWAOffsetX, $iWAOffsetY)
;		 EndSwitch
;	 EndIf
		DisposeWindows()

   EndIf

   Return False

EndFunc

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

Func IsStopped()
   If $RunState Then Return False
   If $Restart Then Return True
   Return False
EndFunc

Func btnStart()
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
		$bDisableBreakCheck = False  ; reset flag to check for early warning message when bot start/restart in case user stopped in middle
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

	    If Not $AndroidSupportsBackgroundMode And $ichkBackground = 1 Then
		   GUICtrlSetState($chkBackground, $GUI_UNCHECKED)
		   chkBackground() ; Invoke Event manually
		   SetLog("Background Mode not supported for " & $Android & " and has been disabled", $COLOR_RED)
	    EndIf
		GUICtrlSetState($chkBackground, $GUI_DISABLE)

		For $i = $FirstControlToHide To $LastControlToHide ; Save state of all controls on tabs
			If $i = $tabGeneral Or $i = $tabSearch Or $i = $tabAttack Or $i = $tabAttackAdv Or $i = $tabDonate Or $i = $tabTroops Or $i = $tabMisc Or $i = $tabNotify Or $i = $tabUpgrades Or $i = $tabEndBattle Or $i = $tabExpert or $i= $tabAttackCSV Then ContinueLoop ; exclude tabs
			If $pEnabled And $i = $btnDeletePBmessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
			If $i = $btnMakeScreenshot Then ContinueLoop ; exclude
			If $i = $divider Then ContinueLoop ; exclude divider
			$iPrevState[$i] = GUICtrlGetState($i)
		Next
		For $i = $FirstControlToHide To $LastControlToHide ; Disable all controls in 1 go on all tabs
			If $i = $tabGeneral Or $i = $tabSearch Or $i = $tabAttack Or $i = $tabAttackAdv Or $i = $tabDonate Or $i = $tabTroops Or $i = $tabMisc Or $i = $tabNotify Or $i = $tabUpgrades Or $i = $tabEndBattle Or $i = $tabExpert or $i=$tabAttackCSV Then ContinueLoop ; exclude tabs
			If $pEnabled And $i = $btnDeletePBmessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
			If $i = $btnMakeScreenshot Then ContinueLoop ; exclude
			If $i = $divider Then ContinueLoop ; exclude divider
			GUICtrlSetState($i, $GUI_DISABLE)
		Next

		$RunState = True
	    SetRedrawBotWindow(True)

	    WinGetAndroidHandle()
		If $HWnD <> 0 Then  ;Is Android open?
			; check if window can be activated
			Local $hTimer = TimerInit(), $hWndActive = -1
			While TimerDiff($hTimer) < 1000 And $hWndActive <> $HWnD And Not _Sleep(100)
			   $hWndActive = WinActivate($HWnD) ; ensure bot has window focus
			WEnd

			If Not $RunState Then Return
		    If IsArray(ControlGetPos($Title, $AppPaneName, $AppClassInstance)) And $hWndActive = $HWnD  Then ; Really?
			   If Not InitiateLayout() Then
				  Initiate()
			   EndIf
			Else
			   ; Not really
			   SetLog("Current " & $Android & " Window not supported by MyBot", $COLOR_RED)
			   RebootAndroid()
			EndIf
		Else  ; If Android is not open, then wait for it to open
			OpenAndroid()
			;If @error Then GUICtrlSetState($btnStart, $GUI_DISABLE)  ; Disable start button, force bot close/open by user.
	    EndIf

	EndIf
EndFunc   ;==>btnStart

Func btnStop()
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
		EnableBS($HWnD, $SC_MINIMIZE)
		EnableBS($HWnD, $SC_MAXIMIZE)
		;EnableBS($HWnD, $SC_CLOSE) ; no need to re-enable close button

		SetRedrawBotWindow(False)

		For $i = $FirstControlToHide To $LastControlToHide ; Restore previous state of controls
			If $i = $tabGeneral Or $i = $tabSearch Or $i = $tabAttack Or $i = $tabAttackAdv Or $i = $tabDonate Or $i = $tabTroops Or $i = $tabMisc Or $i = $tabNotify Or $i = $tabEndBattle Or $i = $tabExpert Then ContinueLoop ; exclude tabs
			If $pEnabled And $i = $btnDeletePBmessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
			If $i = $btnMakeScreenshot Then ContinueLoop ; exclude
			If $i = $divider Then ContinueLoop ; exclude divider
			GUICtrlSetState($i, $iPrevState[$i])
		Next

		AndroidBotStopEvent() ; signal android that bot is now stoppting
		$RunState = False

		_BlockInputEx(0, "", "", $HWnD)
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
		SetLog(_PadStringCenter(" Bot Stop ", 50, "="), $COLOR_ORANGE)
		SetRedrawBotWindow(True) ; must be here at bottom, after SetLog, so Log refreshes. You could also use SetRedrawBotWindow(True, False) and let the events handle the refresh.

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

Func btnHide()

	WinGetPos($Title)
	If @error <> 0 Then Return SetError(0,0,0)

	If $Hide = False Then
		GUICtrlSetData($btnHide, GetTranslated(13,25, "Show"))
		$botPos[0] = WinGetPos($Title)[0]
		$botPos[1] = WinGetPos($Title)[1]
		WinMove2($Title, "", -32000, -32000)
		$Hide = True
	Else
		GUICtrlSetData($btnHide, GetTranslated(13,11, "Hide"))

		If $botPos[0] = -32000 Then
			WinMove2($Title, "", 0, 0)
		Else
			WinMove2($Title, "", $botPos[0], $botPos[1])
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

Func btnWalls()
	$RunState = True
		Zoomout()
	$icmbWalls = _GUICtrlComboBox_GetCurSel($cmbWalls)
	;$debugWalls = 1
	If CheckWall() then Setlog ("Hei Chef! We found the Wall!")
	;$debugWalls = 0
	$RunState = False
 EndFunc

 Func btnAnalyzeVillage()
	$debugBuildingPos= 1
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
		If $debugSetlog = 1 Then SetLog("- Dark Elixir Storage " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_PURPLE)
    Next
	SETLOG("LOCATE BARRACKS C#..............")
	Local $PixelBarrackHere = GetLocationItem("getLocationBarrack")
	SetLog("Total No. of Barracks: " & UBound($PixelBarrackHere), $COLOR_PURPLE)
	For $i = 0 To UBound($PixelBarrackHere) - 1
		$pixel = $PixelBarrackHere[$i]
		If $debugSetlog = 1 Then SetLog("- Barrack " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_PURPLE)
	Next
	SETLOG("LOCATE BARRACKS C#..............")
	Local $PixelDarkBarrackHere = GetLocationItem("getLocationDarkBarrack")
	SetLog("Total No. of Dark Barracks: " & UBound($PixelBarrackHere), $COLOR_PURPLE)
	For $i = 0 To UBound($PixelDarkBarrackHere) - 1
		$pixel = $PixelDarkBarrackHere[$i]
		If $debugSetlog = 1 Then SetLog("- Dark Barrack " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_PURPLE)
    Next
	SETLOG("WEAK BASE C#.....................")
	SetLog("DEAD BASE IS A WEAK BASE: " & IsWeakBase($DB) , $COLOR_PURPLE)
	SetLog("LIVE BASE IS A WEAK BASE: " & IsWeakBase($LB) , $COLOR_PURPLE)
    Setlog("--------------------------------------------------------------", $COLOR_TEAL)
	$debugBuildingPos = 0
	$debugDeadBaseImage = 0
;~ 	$hBitmapFirst = _CaptureRegion2(0, 630, 859, 730)
;~ 	Local $result = DllCall($hFuncLib, "str", "searchIdentifyTroop", "ptr", $hBitmapFirst)
;~ 	If $debugSetlog = 1 Then Setlog("DLL Troopsbar list: " & $result[0], $COLOR_PURPLE)
;~ 	Local $aTroopDataList = StringSplit($result[0], "#")
;~ 	Local $aTemp[12][3]
;~ 	If $result[0] <> "" Then
;~ 		For $i = 1 To $aTroopDataList[0]
;~ 			Local $troopData = StringSplit($aTroopDataList[$i], "|", $STR_NOCOUNT)
;~ 			Local $xCoord = Number(StringSplit($troopData[1], "-", $STR_NOCOUNT)[0])
;~ 			Local $slotIndex = GetSlotIndexFromXPos($xCoord)
;~ 			$aTemp[$slotIndex][1] = Number($troopData[2])
;~ 			Switch $troopData[0]
;~ 				Case "Barbarian"
;~ 					$aTemp[$slotIndex][0] = $eBarb
;~ 				Case "Archer"
;~ 					$aTemp[$slotIndex][0] = $eArch
;~ 				Case "Giant"
;~ 					$aTemp[$slotIndex][0] = $eGiant
;~ 				Case "Goblin"
;~ 					$aTemp[$slotIndex][0] = $eGobl
;~ 				Case "WallBreaker"
;~ 					$aTemp[$slotIndex][0] = $eWall
;~ 				Case "Balloon"
;~ 					$aTemp[$slotIndex][0] = $eBall
;~ 				Case "Wizard"
;~ 					$aTemp[$slotIndex][0] = $eWiza
;~ 				Case "Healer"
;~ 					$aTemp[$slotIndex][0] = $eHeal
;~ 				Case "Dragon"
;~ 					$aTemp[$slotIndex][0] = $eDrag
;~ 				Case "Pekka"
;~ 					$aTemp[$slotIndex][0] = $ePekk
;~ 				Case "Minion"
;~ 					$aTemp[$slotIndex][0] = $eMini
;~ 				Case "HogRider"
;~ 					$aTemp[$slotIndex][0] = $eHogs
;~ 				Case "Valkyrie"
;~ 					$aTemp[$slotIndex][0] = $eValk
;~ 				Case "Golem"
;~ 					$aTemp[$slotIndex][0] = $eGole
;~ 				Case "Witch"
;~ 					$aTemp[$slotIndex][0] = $eWitc
;~ 				Case "LavaHound"
;~ 					$aTemp[$slotIndex][0] = $eLava
;~ 				Case "King"
;~ 					$aTemp[$slotIndex][0] = $eKing
;~ 				Case "Queen"
;~ 					$aTemp[$slotIndex][0] = $eQueen
;~ 				Case "LightSpell"
;~ 					$aTemp[$slotIndex][0] = $eLSpell
;~ 				Case "HealSpell"
;~ 					$aTemp[$slotIndex][0] = $eHSpell
;~ 				Case "RageSpell"
;~ 					$aTemp[$slotIndex][0] = $eRSpell
;~ 				Case "JumpSpell"
;~ 					$aTemp[$slotIndex][0] = $eJSpell
;~ 				Case "FreezeSpell"
;~ 					$aTemp[$slotIndex][0] = $eFSpell
;~ 				Case "PoisonSpell"
;~ 					$aTemp[$slotIndex][0] = $ePSpell
;~ 				Case "EarthquakeSpell"
;~ 					$aTemp[$slotIndex][0] = $eESpell
;~ 				Case "HasteSpell"
;~ 					$aTemp[$slotIndex][0] = $eHaSpell
;~ 				Case "Castle"
;~ 					$aTemp[$slotIndex][0] = $eCastle
;~ 				Case "Warden"
;~ 					$aTemp[$slotIndex][0] = $eWarden
;~ 			EndSwitch
;~ 		Next
;~ 	EndIf
;~ 	For $i = 0 To UBound($aTemp) - 1
;~ 		If $aTemp[$i][0] = "" And $aTemp[$i][1] = "" Then
;~ 			$atkTroops[$i][0] = -1
;~ 			$atkTroops[$i][1] = 0
;~ 		Else
;~ 			$troopKind = $aTemp[$i][0]
;~ 			$atkTroops[$i][0] = $troopKind
;~ 			If $troopKind = -1 Then
;~ 				$atkTroops[$i][1] = 0
;~ 			ElseIf ($troopKind = $eKing) Or ($troopKind = $eQueen) Or ($troopKind = $eCastle) Or ($troopKind = $eWarden) Then
;~ 				$atkTroops[$i][1] = ""
;~ 			Else
;~ 				$atkTroops[$i][1] = $aTemp[$i][1]
;~ 			EndIf
;~ 			If $troopKind <> -1 Then SetLog("-" & NameOfTroop($atkTroops[$i][0]) & " " & $atkTroops[$i][1], $COLOR_GREEN)
;~ 		EndIf
;~ 	Next
 EndFunc
 Func btnVillageStat()
		 GUICtrlSetState( $lblVillageReportTemp , $GUI_HIDE)

		 If GUICtrlGetState($lblResultGoldNow) = $GUI_ENABLE + $GUI_SHOW Then
			 ;hide normal values
			 GUICtrlSetState( $lblResultGoldNow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $lblResultElixirNow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $lblResultDENow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $lblResultTrophyNow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $lblResultBuilderNow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $lblResultGemNow , $GUI_ENABLE +$GUI_HIDE)
			 ;show stats values
			 GUICtrlSetState( $lblResultGoldHourNow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $lblResultElixirHourNow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $lblResultDEHourNow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $lblResultRuntimeNow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $lblResultAttackedHourNow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $lblResultSkippedHourNow , $GUI_ENABLE +$GUI_SHOW)
			; hide normal pics
			 GUICtrlSetState( $picResultTrophyNow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $picResultBuilderNow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $picResultGemNow , $GUI_ENABLE +$GUI_HIDE)
			 ;show stats pics
			 GUICtrlSetState( $picResultRuntimeNow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $picResultAttackedHourNow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $picResultSkippedHourNow , $GUI_ENABLE +$GUI_SHOW)
		 Else
			 ;show normal values
			 GUICtrlSetState( $lblResultGoldNow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $lblResultElixirNow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $lblResultDENow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $lblResultTrophyNow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $lblResultBuilderNow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $lblResultGemNow , $GUI_ENABLE +$GUI_SHOW)
			 ;hide stats values
			 GUICtrlSetState( $lblResultGoldHourNow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $lblResultElixirHourNow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $lblResultDEHourNow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $lblResultRuntimeNow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $lblResultAttackedHourNow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $lblResultSkippedHourNow , $GUI_ENABLE +$GUI_HIDE)
			; show normal pics
			 GUICtrlSetState( $picResultTrophyNow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $picResultBuilderNow , $GUI_ENABLE +$GUI_SHOW)
			 GUICtrlSetState( $picResultGemNow , $GUI_ENABLE +$GUI_SHOW)
			 ;hide stats pics
			 GUICtrlSetState( $picResultRuntimeNow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $picResultAttackedHourNow , $GUI_ENABLE +$GUI_HIDE)
			 GUICtrlSetState( $picResultSkippedHourNow , $GUI_ENABLE +$GUI_HIDE)
		EndIf

EndFunc

Func btnTestDeadBase()
	local $test = 0
	LoadTHImage()
	LoadElixirImage()
	LoadElixirImage75Percent()
	LoadElixirImage50Percent()
	Zoomout()
	if $debugBuildingPos = 0 Then
		$test =1
		$debugBuildingPos=1
	EndIf
		SETLOG("DEADBASE CHECK..................")
		$dbBase = checkDeadBase()
		SETLOG("TOWNHALL CHECK..................")
		$searchTH = checkTownhallADV2()
	If $test = 1 Then $debugBuildingPos=0
EndFunc

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
EndFunc