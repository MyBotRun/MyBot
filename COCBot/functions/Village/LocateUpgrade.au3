; #FUNCTION# ====================================================================================================================
; Name ..........: LocateUpgrade.au3
; Description ...: Finds and determines cost of upgrades
; Syntax ........: LocateOneUpgrade($inum) = $inum is building array index [0-3]
; Parameters ....:
; Return values .:
; Author ........: KnowJack (April-2015)
; Modified ......: KnowJack (Jun/Aug-2015),Sardo 2015-08,Monkeyhunter(2106-2)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func LocateUpgrades()

	WinGetAndroidHandle()

	If $HWnD <> 0 And $g_bAndroidBackgroundLaunched = True Then ; Android is running in background mode, so restart Android
		Setlog("Reboot " & $g_sAndroidEmulator & " for Window access", $COLOR_ERROR)
		RebootAndroid(True)
	EndIf

	If $HWnD = 0 Then ; If not found, Android is not open so exit politely
		Setlog($g_sAndroidEmulator & " is not open", $COLOR_ERROR)
		SetError(1)
		Return
	EndIf

	AndroidToFront()

	Local $wasDown = AndroidShieldForcedDown()
	AndroidShield("LocateUpgrades") ; Update shield status due to manual $g_bRunState

;	Setlog("Upgrade Buildings and Auto Wall Upgrade Can Not Use same Loot Type!", $COLOR_SUCCESS)  = disabled due v7.0 skipwallupgrade code
	Local $MsgBox, $stext
	Local $icount = 0
	Local $hGraphic = 0
	Local $bInitGraphics = True
	While 1
		_CaptureRegion(0, 0, $g_iDEFAULT_WIDTH, 2)
		If _GetPixelColor(1, 1) <> Hex(0x000000, 6) Or _GetPixelColor(850, 1) <> Hex(0x000000, 6) Then ; Check for zoomout in case user tried to zoom in.
			SetLog("Locate Oops, prep screen 1st", $COLOR_INFO)
			ZoomOut()
			$bDisableBreakCheck = True ; stop early PB log off when locating upgrades
			Collect()
			$bDisableBreakCheck = False ; restore flag
		EndIf
		$bDisableBreakCheck = True ; stop early PB log off when locating upgrades
		Collect() ; must collect or clicking on collectors will fail 1st time
		$bDisableBreakCheck = False ; restore flag

		If $bInitGraphics Then
			$bInitGraphics = False
			$hGraphic = AndroidGraphicsGdiBegin()
			If $hGraphic <> 0 Then
				Local $hPen = AndroidGraphicsGdiAddObject("Pen", _GDIPlus_PenCreate(0xFFFFFF00, 2))
				SetDebugLog("LocateUpgrades: $hGraphic=" & $hGraphic & ", $hPen=" & $hPen)

				For $icount = 0 To UBound($g_avBuildingUpgrades, 1) - 1
					If $hGraphic <> 0 And $g_avBuildingUpgrades[$icount][0] > 0 And $g_avBuildingUpgrades[$icount][0] > 0 Then
						Local $xUpgrade = $g_avBuildingUpgrades[$icount][0]
						Local $yUpgrade = $g_avBuildingUpgrades[$icount][1]
						ConvertToVillagePos($xUpgrade, $yUpgrade)
						Local $bMarkerDrawn = _GDIPlus_GraphicsDrawEllipse($hGraphic, $xUpgrade - 10, $yUpgrade - 10, 20, 20, $hPen)
						AndroidGraphicsGdiUpdate()
						SetDebugLog("Existing Updgrade #" & $icount & " found at " & $g_avBuildingUpgrades[$icount][0] & "/" & $g_avBuildingUpgrades[$icount][1] & ", marker drawn: " & $bMarkerDrawn)
					EndIf
				Next
			EndIf
		EndIf

		For $icount = 0 To UBound($g_avBuildingUpgrades, 1) - 1
			If $g_abUpgradeRepeatEnable[$icount] = True And (GUICtrlRead($g_hTxtUpgradeName[$icount]) <> "") Then ; check for repeat upgrade
				GUICtrlSetImage($g_hPicUpgradeStatus[$icount], $g_sLibIconPath, $eIcnYellowLight) ; Set GUI Status to Yellow showing ready for upgrade
				GUICtrlSetState($g_hChkUpgrade[$icount], $GUI_CHECKED) ; Change upgrade selection box to checked again
				ContinueLoop
			EndIf
			AndroidShieldForceDown(True, True)
			$stext = GetTranslated(640, 51, "Click 'Locate Building' button then click on your Building/Hero to upgrade.") & @CRLF & @CRLF & GetTranslated(640, 52, "Click 'Finished' button when done locating all upgrades.") & @CRLF & @CRLF & GetTranslated(640, 53, "Click on Cancel to exit finding buildings.") & @CRLF & @CRLF
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 10, "Comic Sans MS", 500)
			$MsgBox = _ExtMsgBox(0, GetTranslated(640, 54, "Locate Building|Finished|Cancel"), GetTranslated(640, 55, "Locate Upgrades"), $stext, 0, $g_hFrmBot)
			Switch $MsgBox
				Case 1 ; YES! we want to find a building.
					Local $aPos = FindPos()
					$g_avBuildingUpgrades[$icount][0] = $aPos[0]
					$g_avBuildingUpgrades[$icount][1] = $aPos[1]
					If isInsideDiamondXY($g_avBuildingUpgrades[$icount][0], $g_avBuildingUpgrades[$icount][1]) Then ; Check value to make sure its valid.
						Local $bMarkerDrawn = False
						If $hGraphic <> 0 Then
							Local $xUpgrade = $g_avBuildingUpgrades[$icount][0]
							Local $yUpgrade = $g_avBuildingUpgrades[$icount][1]
							ConvertToVillagePos($xUpgrade, $yUpgrade)
							$bMarkerDrawn = _GDIPlus_GraphicsDrawEllipse($hGraphic, $xUpgrade - 10, $yUpgrade - 10, 20, 20, $hPen)
							AndroidGraphicsGdiUpdate()
						EndIf
						SetDebugLog("Updgrade #" & $icount & " added at " & $g_avBuildingUpgrades[$icount][0] & "/" & $g_avBuildingUpgrades[$icount][1] & ", marker drawn: " & $bMarkerDrawn)
						GUICtrlSetImage($g_hPicUpgradeStatus[$icount], $g_sLibIconPath, $eIcnYellowLight) ; Set GUI Status to Yellow showing ready for upgrade
						$g_aiPicUpgradeStatus[$icount] = $eIcnYellowLight
						_Sleep(750)
					Else
						Setlog("Bad location recorded, location skipped?", $COLOR_ERROR)
						$g_avBuildingUpgrades[$icount][0] = -1
						$g_avBuildingUpgrades[$icount][1] = -1
						ContinueLoop ; Whoops, here we go again...
					EndIf
				Case 2 ; No! we are done!
					If $icount = 0 Then ; if no upgrades located, reset all values and return
						Setlog("Locate Upgrade Cancelled", $COLOR_WARNING)
						btnResetUpgrade()
						AndroidGraphicsGdiEnd()
						AndroidShieldForceDown($wasDown)
						Return False
					EndIf
					ExitLoop
				Case 3 ; cancel all upgrades
					Setlog("Locate Upgrade Cancelled", $COLOR_WARNING)
					btnResetUpgrade()
					AndroidGraphicsGdiEnd()
					AndroidShieldForceDown($wasDown)
					Return False
				Case Else
					Setlog("Impossible value (" & $MsgBox & ") from Msgbox, you have been a bad programmer!", $COLOR_DEBUG)
			EndSwitch

			ClickP($aAway, 1, 0, "#0210") ;Click Away to close windows

		Next
		ExitLoop
	WEnd

	AndroidGraphicsGdiEnd()
	AndroidShieldForceDown($wasDown)

	CheckUpgrades()

EndFunc   ;==>LocateUpgrades

Func CheckUpgrades() ; Valdiate and determine the cost and type of the upgrade and change GUI boxes/pics to match
	If AndroidShielded() = False Then
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		Local $stext = GetTranslated(640, 38, "Keep Mouse OUT of Android Emulator Window While I Check Your Upgrades, Thanks!!")
		Local $MsgBox = _ExtMsgBox(48, GetTranslated(640, 36, "OK"), GetTranslated(640, 37, "Notice"), $stext, 15, $g_hFrmBot)
		If _Sleep($iDelayCheckUpgrades1) Then Return
		If $MsgBox <> 1 Then
			Setlog("Something weird happened in getting upgrade values, try again", $COLOR_ERROR)
			Return False
		EndIf
	EndIf
	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If isInsideDiamondXY($g_avBuildingUpgrades[$iz][0], $g_avBuildingUpgrades[$iz][1]) = False Then ; check for location off grass.
			GUICtrlSetImage($g_hPicUpgradeStatus[$iz], $g_sLibIconPath, $eIcnRedLight) ; change indicator back to red showing location invalid
			GUICtrlSetState($g_hChkUpgrade[$iz], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
			If $g_abUpgradeRepeatEnable[$iz] = True Then GUICtrlSetState($g_hChkUpgradeRepeat[$iz], $GUI_UNCHECKED) ; Change repeat selection box to unchecked
			ContinueLoop
		EndIf

		If UpgradeValue($iz) = False Then ; Get the upgrade cost, name, level, and time
			If $g_abUpgradeRepeatEnable[$iz] = True And $g_avBuildingUpgrades[$iz][4] <> "" Then ContinueLoop ; If repeat is checked and bldg has name, then get value later.
			Setlog("Locate Upgrade #" & $iz + 1 & " Value Error, try again", $COLOR_ERROR)
			GUICtrlSetImage($g_hPicUpgradeStatus[$iz], $g_sLibIconPath, $eIcnRedLight) ; change indicator back to red showing location invalid
			GUICtrlSetData($g_hTxtUpgradeName[$iz], "") ; Clear GUI Name
			GUICtrlSetData($g_hTxtUpgradeLevel[$iz], "") ; Clear GUI Level
			GUICtrlSetData($g_hTxtUpgradeValue[$iz], "") ; Clear Upgrade value in GUI
			GUICtrlSetData($g_hTxtUpgradeTime[$iz], "") ; Clear Upgrade time in GUI
			GUICtrlSetData($g_hTxtUpgradeEndTime[$iz], "") ; Clear Upgrade End time in GUI
			GUICtrlSetImage($g_hPicUpgradeType[$iz], $g_sLibIconPath, $eIcnBlank)
			If $g_abUpgradeRepeatEnable[$iz] = True Then GUICtrlSetState($g_hChkUpgradeRepeat[$iz], $GUI_UNCHECKED) ; Change repeat selection box to unchecked
			ContinueLoop
		EndIf
;		GUICtrlSetState($g_hChkWalls, $GUI_UNCHECKED) ; Turn off upgrade walls since we have buidlings to upgrade  = disabled due v7.0 skipwallupgrade code
	Next
	; Add duplicate check?

EndFunc   ;==>CheckUpgrades

Func UpgradeValue($inum, $bRepeat = False) ;function to find the value and type of the upgrade.
	Local $inputbox, $iLoot, $aString, $aResult
	Local $bOopsFlag = False

	If $bRepeat = True Or $g_abUpgradeRepeatEnable[$inum] = True Then ; check for upgrade in process when continiously upgrading
		ClickP($aAway, 1, 0, "#0999") ;Click Away to close windows
		If _Sleep($iDelayUpgradeValue1) Then Return
		BuildingClick($g_avBuildingUpgrades[$inum][0], $g_avBuildingUpgrades[$inum][1]) ;Select upgrade trained
		If _Sleep($iDelayUpgradeValue4) Then Return
		If $bOopsFlag = True Then DebugImageSave("ButtonView")
		; check if upgrading collector type building, and reselect in case previous click only collect resource
		If StringInStr($g_avBuildingUpgrades[$inum][4], "collect", $STR_NOCASESENSEBASIC) Or _
				StringInStr($g_avBuildingUpgrades[$inum][4], "mine", $STR_NOCASESENSEBASIC) Or _
				StringInStr($g_avBuildingUpgrades[$inum][4], "drill", $STR_NOCASESENSEBASIC) Then
			ClickP($aAway, 1, 0, "#0999") ;Click away to deselect collector if was not full, and collected with previous click
			If _Sleep($iDelayUpgradeValue1) Then Return
			BuildingClick($g_avBuildingUpgrades[$inum][0], $g_avBuildingUpgrades[$inum][1]) ;Select collector upgrade trained
			If _Sleep($iDelayUpgradeValue4) Then Return
		EndIf
		; check for upgrade in process
		Local $offColors[3][3] = [[0x000000, 44, 17], [0xE07740, 69, 31], [0xF2F7F1, 81, 0]] ; 2nd pixel black broken hammer, 3rd pixel lt brown handle, 4th pixel white edge of button
		Global $ButtonPixel = _MultiPixelSearch(284, 572, 570, 615, 1, 1, Hex(0x000000, 6), $offColors, 25) ; first pixel blackon side of button
		If $g_iDebugSetlog = 1 Then Setlog("Pixel Color #1: " & _GetPixelColor(389, 572, True) & ", #2: " & _GetPixelColor(433, 589, True) & ", #3: " & _GetPixelColor(458, 603, True) & ", #4: " & _GetPixelColor(470, 572, True), $COLOR_DEBUG)
		If IsArray($ButtonPixel) Then
			If $g_iDebugSetlog = 1 Or $bOopsFlag = True Then
				Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
				Setlog("Pixel Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 44, $ButtonPixel[1] + 17, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 69, $ButtonPixel[1] + 31, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 81, $ButtonPixel[1], True), $COLOR_DEBUG)
			EndIf
			Setlog("Selection #" & $inum + 1 & " Upgrade in process - Skipped!", $COLOR_WARNING)
			ClickP($aAway, 1, 0, "#0999") ;Click Away to close windows
			Return False
		EndIf
	Else ; If upgrade not in process
		If $g_avBuildingUpgrades[$inum][0] <= 0 Or $g_avBuildingUpgrades[$inum][1] <= 0 Then Return False
		$g_avBuildingUpgrades[$inum][2] = 0 ; Clear previous upgrade value if run before
		GUICtrlSetData($g_hTxtUpgradeValue[$inum], "") ; Clear Upgrade value in GUI
		$g_avBuildingUpgrades[$inum][3] = "" ; Clear previous loot type if run before
		GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnBlank)
		$g_avBuildingUpgrades[$inum][4] = "" ; Clear upgrade name if run before
		GUICtrlSetData($g_hTxtUpgradeName[$inum], "") ; Set GUI name to match $g_avBuildingUpgrades variable
		$g_avBuildingUpgrades[$inum][5] = "" ; Clear upgrade level if run before
		GUICtrlSetData($g_hTxtUpgradeLevel[$inum], "") ; Set GUI level to match $g_avBuildingUpgrades variable
		$g_avBuildingUpgrades[$inum][6] = "" ; Clear upgrade time if run before
		GUICtrlSetData($g_hTxtUpgradeTime[$inum], "") ; Set GUI time to match $g_avBuildingUpgrades variable
		$g_avBuildingUpgrades[$inum][7] = "" ; Clear upgrade end date/time if run before
		GUICtrlSetData($g_hTxtUpgradeEndTime[$inum], "") ; Set GUI time to match $g_avBuildingUpgrades variable
		ClickP($aAway, 1, 0, "#0211") ;Click Away to close windows
		SetLog("-$Upgrade #" & $inum + 1 & " Location =  " & "(" & $g_avBuildingUpgrades[$inum][0] & "," & $g_avBuildingUpgrades[$inum][1] & ")", $COLOR_DEBUG1) ;Debug
		If _Sleep($iDelayUpgradeValue1) Then Return
		BuildingClick($g_avBuildingUpgrades[$inum][0], $g_avBuildingUpgrades[$inum][1], "#0212") ;Select upgrade trained
		If _Sleep($iDelayUpgradeValue2) Then Return
		If $bOopsFlag = True Then DebugImageSave("ButtonView")
	EndIf

	If $bOopsFlag = True And $g_iDebugImageSave = 1 Then DebugImageSave("ButtonView")

	$aResult = BuildingInfo(242, 520 + $g_iBottomOffsetY)
	If $aResult[0] > 0 Then
		$g_avBuildingUpgrades[$inum][4] = $aResult[1] ; Store bldg name
		GUICtrlSetData($g_hTxtUpgradeName[$inum], $g_avBuildingUpgrades[$inum][4]) ; Set GUI name to match $g_avBuildingUpgrades variable
		If $aResult[0] > 1 Then
			$g_avBuildingUpgrades[$inum][5] = $aResult[2] ; Sotre bdlg level
			GUICtrlSetData($g_hTxtUpgradeLevel[$inum], $g_avBuildingUpgrades[$inum][5]) ; Set GUI level to match $g_avBuildingUpgrades variable
		Else
			Setlog("Error: Level for Upgrade not found?", $COLOR_ERROR)
		EndIf
	Else
		Setlog("Error: Name & Level for Upgrade not found?", $COLOR_ERROR)
	EndIf
	Setlog("Upgrade Name = " & $g_avBuildingUpgrades[$inum][4] & ", Level = " & $g_avBuildingUpgrades[$inum][5], $COLOR_INFO) ;Debug

	; check for normal gold upgrade
	Local $offColors[3][3] = [[0xD6714B, 47, 37], [0xF0E850, 70, 0], [0xF4F8F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel gold, 4th pixel edge of button
	Global $ButtonPixel = _MultiPixelSearch(240, 563 + $g_iBottomOffsetY, 670, 620 + $g_iBottomOffsetY, 1, 1, Hex(0xF3F3F1, 6), $offColors, 30) ; first gray/white pixel of button
	If $g_iDebugSetlog = 1 And IsArray($ButtonPixel) Then
		Setlog("GoldButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
		Setlog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 47, $ButtonPixel[1] + 37, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 70, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_DEBUG)
	EndIf

	If IsArray($ButtonPixel) = 0 Then ; If its not normal gold upgrade, then try to find elixir upgrade button
		Local $offColors[3][3] = [[0xBC5B31, 38, 32], [0xF84CF9, 72, 0], [0xF5F9F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel pink, 4th pixel edge of button
		Global $ButtonPixel = _MultiPixelSearch(240, 563 + $g_iBottomOffsetY, 670, 620 + $g_iBottomOffsetY, 1, 1, Hex(0xF4F7F2, 6), $offColors, 30) ; first gray/white pixel of button
		If $g_iDebugSetlog = 1 And IsArray($ButtonPixel) Then
			Setlog("ElixirButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
			Setlog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 38, $ButtonPixel[1] + 32, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 70, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_DEBUG)
		EndIf
	EndIf

	If IsArray($ButtonPixel) = 0 Then ; If its not regular upgrade, then try to find Hero upgrade button
		Local $offColors[3][3] = [[0xE07B50, 41, 23], [0x282020, 72, 0], [0xF4F5F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel black, 4th pixel edge of button
		Global $ButtonPixel = _MultiPixelSearch(240, 563 + $g_iBottomOffsetY, 670, 620 + $g_iBottomOffsetY, 1, 1, Hex(0xF5F6F2, 6), $offColors, 25) ; first gray/white pixel of button4
		If $g_iDebugSetlog = 1 And IsArray($ButtonPixel) Then
			Setlog("HeroButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
			Setlog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 41, $ButtonPixel[1] + 23, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 72, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_DEBUG)
		EndIf
	EndIf

	If IsArray($ButtonPixel) Then
		If $g_iDebugSetlog = 1 Or $bOopsFlag = True Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
			Setlog("#1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 41, $ButtonPixel[1] + 23, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 70, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_DEBUG)
		EndIf

		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20, 1, 0, "#0213") ; Click Upgrade Button
		If _Sleep($iDelayUpgradeValue3) Then Return

		If $bOopsFlag = True And $g_iDebugImageSave = 1 Then DebugImageSave("UpgradeView")

		_CaptureRegion()
		Select ;Ensure the right upgrade window is open!
			Case _ColorCheck(_GetPixelColor(677, 150 + $g_iMidOffsetY), Hex(0xE00408, 6), 20) ; Check if the building Upgrade window is open
				If _ColorCheck(_GetPixelColor(351, 485 + $g_iMidOffsetY), Hex(0xE0403D, 6), 20) Then ; Check if upgrade requires upgrade to TH and can not be completed
					If $g_abUpgradeRepeatEnable[$inum] = True Then
						Setlog("Selection #" & $inum + 1 & " can not repeat upgrade, need TH upgrade - Skipped!", $COLOR_ERROR)
						$g_abUpgradeRepeatEnable[$inum] = False
						GUICtrlSetState($g_hChkUpgradeRepeat[$inum], $GUI_UNCHECKED) ; Change repeat selection box to unchecked
					Else
						Setlog("Selection #" & $inum + 1 & " upgrade not available, need TH upgrade - Skipped!", $COLOR_ERROR)
					EndIf
					ClearUpgradeInfo($inum) ; clear upgrade information
					GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnRedLight)
					GUICtrlSetImage($g_hPicUpgradeStatus[$inum], $g_sLibIconPath, $eIcnTroops) ; change to needs trained indicator
					$g_abBuildingUpgradeEnable[$inum] = False
					GUICtrlSetState($g_hChkUpgrade[$inum], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
					$g_avBuildingUpgrades[$inum][7] = "" ; Clear upgrade end date/time if run before
					GUICtrlSetData($g_hTxtUpgradeEndTime[$inum], "") ; Set GUI time to match $g_avBuildingUpgrades variable
					ClickP($aAway, 1, 0, "#0214") ;Click Away
					Return False
				EndIf

				If _ColorCheck(_GetPixelColor(477, 490 + $g_iMidOffsetY), Hex(0xF0E850, 6), 20) Then $g_avBuildingUpgrades[$inum][3] = "Gold" ;Check if Gold required and update type
				If _ColorCheck(_GetPixelColor(483, 486 + $g_iMidOffsetY), Hex(0xF030D8, 6), 20) Then $g_avBuildingUpgrades[$inum][3] = "Elixir" ;Check if Elixir required and update type

				$g_avBuildingUpgrades[$inum][2] = Number(getResourcesBonus(366, 487 + $g_iMidOffsetY)) ; Try to read white text.
				If $g_avBuildingUpgrades[$inum][2] = "" Then $g_avBuildingUpgrades[$inum][2] = Number(getUpgradeResource(366, 487 + $g_iMidOffsetY)) ;read RED upgrade text
				If $g_avBuildingUpgrades[$inum][2] = "" And $g_abUpgradeRepeatEnable[$inum] = False Then $bOopsFlag = True ; set error flag for user to set value if not repeat upgrade

				$g_avBuildingUpgrades[$inum][6] = getBldgUpgradeTime(196, 304 + $g_iMidOffsetY); Try to read white text showing time for upgrade
				Setlog("Upgrade #" & $inum + 1 & " Time = " & $g_avBuildingUpgrades[$inum][6], $COLOR_INFO)
				If  $g_avBuildingUpgrades[$inum][6]  <> "" Then $g_avBuildingUpgrades[$inum][7] = ""  ; Clear old upgrade end time

			Case _ColorCheck(_GetPixelColor(719, 118 + $g_iMidOffsetY), Hex(0xDF0408, 6), 20) ; Check if the Hero Upgrade window is open
				If _ColorCheck(_GetPixelColor(400, 485 + $g_iMidOffsetY), Hex(0xE0403D, 6), 20) Then ; Check if upgrade requires upgrade to TH and can not be completed
					If $g_abUpgradeRepeatEnable[$inum] = True Then
						Setlog("Selection #" & $inum + 1 & " can not repeat upgrade, need TH upgrade - Skipped!", $COLOR_ERROR)
						$g_abUpgradeRepeatEnable[$inum] = False
						GUICtrlSetState($g_hChkUpgradeRepeat[$inum], $GUI_UNCHECKED) ; Change repeat selection box to unchecked
					Else
						Setlog("Selection #" & $inum + 1 & " upgrade not available, need TH upgrade - Skipped!", $COLOR_ERROR)
					EndIf
					ClearUpgradeInfo($inum) ; clear upgrade information
					GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnRedLight)
					GUICtrlSetImage($g_hPicUpgradeStatus[$inum], $g_sLibIconPath, $eIcnTroops) ; change to needs trained indicator
					$g_abBuildingUpgradeEnable[$inum] = False
					GUICtrlSetState($g_hChkUpgrade[$inum], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
					$g_avBuildingUpgrades[$inum][7] = "" ; Clear upgrade end date/time if run before
					GUICtrlSetData($g_hTxtUpgradeEndTime[$inum], "") ; Set GUI time to match $g_avBuildingUpgrades variable
					ClickP($aAway, 1, 0, "#0215") ;Click Away
					Return False
				EndIf
				If _ColorCheck(_GetPixelColor(703, 535 + $g_iMidOffsetY), Hex(0x000000, 6), 20) Then $g_avBuildingUpgrades[$inum][3] = "Dark" ; Check if DE required and update type
				$g_avBuildingUpgrades[$inum][2] = Number(getResourcesBonus(598, 519 + $g_iMidOffsetY)) ; Try to read white text.
				If $g_avBuildingUpgrades[$inum][2] = "" Then $g_avBuildingUpgrades[$inum][2] = Number(getUpgradeResource(598, 519 + $g_iMidOffsetY)) ;read RED upgrade text
				If $g_avBuildingUpgrades[$inum][2] = "" And $g_abUpgradeRepeatEnable[$inum] = False Then $bOopsFlag = True ; set error flag for user to set value
				$g_avBuildingUpgrades[$inum][6] = getHeroUpgradeTime(464, 527 + $g_iMidOffsetY) ; Try to read white text showing time for upgrade
				Setlog("Upgrade #" & $inum + 1 & " Time = " & $g_avBuildingUpgrades[$inum][6], $COLOR_INFO)
				If  $g_avBuildingUpgrades[$inum][6]  <> "" Then $g_avBuildingUpgrades[$inum][7] = ""  ; Clear old upgrade end time

			Case Else
				If isGemOpen(True) Then ClickP($aAway, 1, 0, "#0216")
				Setlog("Selected Upgrade Window Opening Error, try again", $COLOR_ERROR)
				ClearUpgradeInfo($inum) ; clear upgrade information
				ClickP($aAway, 1, 0, "#0217") ;Click Away
				Return False

		EndSelect

		If StringInStr($g_avBuildingUpgrades[$inum][4],"Warden") > 0 then $g_avBuildingUpgrades[$inum][3] = "Elixir"

		; Failsafe fix for upgrade value read problems if needed.
		If $g_avBuildingUpgrades[$inum][3] <> "" And $bOopsFlag = True And $bRepeat = False Then ;check if upgrade type value to not waste time and for text read oops flag
			$iLoot = $g_avBuildingUpgrades[$inum][2]
			If $iLoot = "" Then $iLoot = 8000000
			Local $aBotLoc = WinGetPos($g_hFrmBot)

			$inputbox = InputBox(GetTranslated(640, 56, "Text Read Error"), GetTranslated(640, 57, "Enter the cost of the upgrade"), $iLoot, "", -1, -1, $aBotLoc[0] + 125, $aBotLoc[1] + 225, -1, $g_hFrmBot)
			If @error Then
				Setlog("InputBox error, data reset. Try again", $COLOR_ERROR)
				ClearUpgradeInfo($inum) ; clear upgrade information
				Return False
			EndIf
			$g_avBuildingUpgrades[$inum][2] = Int($inputbox)
			Setlog("User input value = " & $g_avBuildingUpgrades[$inum][2], $COLOR_DEBUG)
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
			Local $stext = GetTranslated(640, 58, "Save copy of upgrade image for developer analysis ?")
			Local $MsgBox = _ExtMsgBox(48, GetTranslated(640, 59, "YES|NO"), GetTranslated(640, 37, "Notice"), $stext, 60, $g_hFrmBot)
			If $MsgBox = 1 And $g_iDebugImageSave = 1 Then DebugImageSave("UpgradeReadError_")
		EndIf
		If $g_avBuildingUpgrades[$inum][3] = "" And $bOopsFlag = True And $bRepeat = False Then
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 10, "Comic Sans MS", 500)
			$inputbox = _ExtMsgBox(0, GetTranslated(640, 60, "   GOLD   |  ELIXIR  |DARK ELIXIR"), GetTranslated(640, 61, "Need User Help"), GetTranslated(640, 62, "Select Upgrade Type:"), 0, $g_hFrmBot)
			If $g_iDebugSetlog = 1 Then Setlog(" _MsgBox returned = " & $inputbox, $COLOR_DEBUG)
			Switch $inputbox
				Case 1
					$g_avBuildingUpgrades[$inum][3] = "Gold"
				Case 2
					$g_avBuildingUpgrades[$inum][3] = "Elixir"
				Case 3
					$g_avBuildingUpgrades[$inum][3] = "Dark"
				Case Else
					SetLog("Silly programmer made an error!", $COLOR_WARNING)
					$g_avBuildingUpgrades[$inum][3] = "HaHa"
			EndSwitch
			Setlog("User selected type = " & $g_avBuildingUpgrades[$inum][3], $COLOR_DEBUG)
		EndIf
		If $g_avBuildingUpgrades[$inum][2] = "" Or $g_avBuildingUpgrades[$inum][3] = "" And $g_abUpgradeRepeatEnable[$inum] = False Then ;report loot error if exists
			Setlog("Error finding loot info " & $inum & ", Loot = " & $g_avBuildingUpgrades[$inum][2] & ", Type= " & $g_avBuildingUpgrades[$inum][3], $COLOR_ERROR)
			$g_avBuildingUpgrades[$inum][0] = -1 ; Clear upgrade location value as it is invalid
			$g_avBuildingUpgrades[$inum][1] = -1 ; Clear upgrade location value as it  is invalid
			ClickP($aAway, 2, 0, "#0218") ;Click Away
			Return False
		EndIf
		Setlog("Upgrade #" & $inum + 1 & " Value = " & _NumberFormat($g_avBuildingUpgrades[$inum][2]) & " " & $g_avBuildingUpgrades[$inum][3], $COLOR_INFO) ; debug & document cost of upgrade
	Else
		If $g_abUpgradeRepeatEnable[$inum] = False Then
			Setlog("Upgrade selection problem - data cleared, please try again", $COLOR_ERROR)
			ClearUpgradeInfo($inum)
		ElseIf $g_abUpgradeRepeatEnable[$inum] = True Then
			Setlog("Repeat upgrade problem - will retry value update later", $COLOR_ERROR)
		EndIf
		ClickP($aAway, 2, 0, "#0219") ;Click Away
		Return False
	EndIf

	ClickP($aAway, 2, 200, "#0220") ;Click Away

	; Update GUI with new values
	Switch $g_avBuildingUpgrades[$inum][3] ;Set GUI Upgrade Type to match $g_avBuildingUpgrades variable
		Case "Gold"
			GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnGold) ; 24
		Case "Elixir"
			GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnElixir) ; 15
		Case "Dark"
			GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnDark) ; 11
		Case Else
			GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnBlank)
	EndSwitch
	GUICtrlSetData($g_hTxtUpgradeValue[$inum], _NumberFormat($g_avBuildingUpgrades[$inum][2])) ; Show Upgrade value in GUI
	GUICtrlSetData($g_hTxtUpgradeTime[$inum], StringStripWS($g_avBuildingUpgrades[$inum][6], $STR_STRIPALL)) ; Set GUI time to match $g_avBuildingUpgrades variable
	GUICtrlSetData($g_hTxtUpgradeEndTime[$inum], $g_avBuildingUpgrades[$inum][7]) ; Set GUI time to match $g_avBuildingUpgrades variable

	Return True

EndFunc   ;==>UpgradeValue


Func ClearUpgradeInfo($inum)
	; quick function to reset the $g_avBuildingUpgrades array for one upgrade
	$g_aiPicUpgradeStatus[$inum] = $eIcnTroops
	$g_avBuildingUpgrades[$inum][0] = -1 ; Clear upgrade location value as it is invalid
	$g_avBuildingUpgrades[$inum][1] = -1 ; Clear upgrade location value as it is invalid
	$g_avBuildingUpgrades[$inum][2] = 0 ; Clear upgrade value as it is invalid
	$g_avBuildingUpgrades[$inum][3] = "" ; Clear upgrade type as it is invalid
	$g_avBuildingUpgrades[$inum][4] = "" ; Clear upgrade name as it is invalid
	$g_avBuildingUpgrades[$inum][5] = "" ; Clear upgrade level as it is invalid
	$g_avBuildingUpgrades[$inum][6] = "" ; Clear upgrade time as it is invalid
	$g_avBuildingUpgrades[$inum][7] = "" ; Clear upgrade end date/time as it is invalid
EndFunc   ;==>ClearUpgradeInfo
