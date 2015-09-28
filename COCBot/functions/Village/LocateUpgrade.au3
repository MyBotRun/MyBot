; #FUNCTION# ====================================================================================================================
; Name ..........: LocateUpgrade.au3
; Description ...: Finds and determines cost of upgrades
; Syntax ........: LocateOneUpgrade($inum) = $inum is building array index [0-3]
; Parameters ....:
; Return values .:
; Author ........: KnowJack (April-2015)
; Modified ......: KnowJack (June-2015) edited for V3.X bot and SC updates
;				   Sardo 2015-08
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func LocateUpgrades()
	ControlGetPos($Title, "", "[CLASS:BlueStacksApp; INSTANCE:1]")  ;Check For valid BS position
	If @error = 1 Then  ; If not found, BS is not open so exit politely
		Setlog("BlueStacks in not open", $COLOR_RED)
		SetError(1)
		Return
	EndIf
	If $hLogFileHandle = "" Then CreateLogFile()
	If $hAttackLogFileHandle = "" Then CreateAttackLogFile()
	Setlog("Upgrade Buildings and Auto Wall Upgrade Can Not Use same Loot Type!", $COLOR_GREEN)
	Local $MsgBox, $stext
	Local $icount = 0
	While 1
		_CaptureRegion(0, 0, 860, 2)
		If _GetPixelColor(1, 1) <> Hex(0x000000, 6) And _GetPixelColor(850, 1) <> Hex(0x000000, 6) Then ; Check for zoomout in case user tried to zoom in.
			SetLog("Locate Oops, prep screen 1st", $COLOR_BLUE)
			ZoomOut()
			Collect()
		EndIf
		For $icount = 0 To 5
			$stext = "Click 'Locate Building' button then click on your Building/Hero to upgrade." & @CRLF & @CRLF & "Click 'Finished' button when done locating all upgrades." & @CRLF & @CRLF & "Click on Cancel to exit finding buildings." & @CRLF & @CRLF
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 10, "Comic Sans MS", 500)
			$MsgBox = _ExtMsgBox(0, "Locate Building|Finished|Cancel", "Locate Upgrades", $stext, 0, $frmBot)
			Switch $MsgBox
				Case 1 ; YES! we want to find a building.
					$aUpgrades[$icount][0] = FindPos()[0]
					$aUpgrades[$icount][1] = FindPos()[1]
					If _Sleep(500) Then Return
					If isInsideDiamondXY($aUpgrades[$icount][0], $aUpgrades[$icount][1]) Then ; Check value to make sure its valid.
						GUICtrlSetImage($picUpgradeStatus[$icount], $pIconLib, $eIcnYellowLight) ; Set GUI Status to Yellow showing ready for upgrade
					Else
						Setlog("Bad location recorded, location skipped?", $COLOR_RED)
						ContinueLoop ; Whoops, here we go again...
					EndIf
				Case 2 ; No! we are done!
					If $icount = 0 Then ; if no upgrades located, reset all values and return
						Setlog("Locate Upgrade Cancelled", $COLOR_FUCHSIA)
						btnResetUpgrade()
						Return False
					EndIf
					ExitLoop
				Case 3 ; cancel all upgrades
					Setlog("Locate Upgrade Cancelled", $COLOR_FUCHSIA)
					btnResetUpgrade()
					Return False
				Case Else
					Setlog("Impossible value from Msgbox, you have been a bad programmer!", $COLOR_PURPLE)
			EndSwitch
			ClickP($aAway, 1,0,"#0210") ;Click Away to close windows
		Next
		ExitLoop
	WEnd

	CheckUpgrades()

EndFunc   ;==>LocateUpgrades

Func CheckUpgrades() ; Valdiate and determine the cost and type of the upgrade and change GUI boxes/pics to match
	Local $MsgBox
	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = "Keep Mouse OUT of BlueStacks Window While I Check Your Upgrades, Thanks!!"
	$MsgBox = _ExtMsgBox(48, "OK", "Notice!", $stext, 15, $frmBot)
	If _Sleep($iDelayCheckUpgrades1) Then Return
	If $MsgBox <> 1 Then
		Setlog("Something weird happened in getting upgrade values, try again", $COLOR_RED)
		Return False
	EndIf
	For $iz = 0 To 5
		If $aUpgrades[$iz][0] <= 0 Or $aUpgrades[$iz][1] <= 0 Then
			GUICtrlSetImage($picUpgradeStatus[$iz], $pIconLib, $eIcnRedLight) ; change indicator back to red showing location invalid
			GUICtrlSetState($chkbxUpgrade[$iz], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
			ContinueLoop
		EndIf
		If UpgradeValue($iz) = False Then
			If $debugSetlog = 1 Then Setlog("Locate Upgrade #" & $iz + 1 & " Value Error, try again", $COLOR_RED)
			GUICtrlSetImage($picUpgradeStatus[$iz], $pIconLib, $eIcnRedLight) ; change indicator back to red showing location invalid
			GUICtrlSetData($txtUpgradeX[$iz], "") ; Set GUI X Position to empty
			GUICtrlSetData($txtUpgradeY[$iz], "") ; Set GUI Y Position to empty
			GUICtrlSetData($txtUpgradeValue[$iz], "") ; Clear Upgrade value in GUI
			GUICtrlSetImage($picUpgradeType[$iz], $pIconLib, $eIcnBlank)
			ContinueLoop
		EndIf
		Switch $aUpgrades[$iz][3] ;Set GUI Upgrade Type to match $aUpgrades variable
			Case "Gold"
				GUICtrlSetImage($picUpgradeType[$iz], $pIconLib, $eIcnGold) ; 24
			Case "Elixir"
				GUICtrlSetImage($picUpgradeType[$iz], $pIconLib, $eIcnElixir) ; 15
			Case "Dark"
				GUICtrlSetImage($picUpgradeType[$iz], $pIconLib, $eIcnDark) ; 11
			Case Else
				GUICtrlSetImage($picUpgradeType[$iz], $pIconLib, $eIcnBlank)
		EndSwitch
		GUICtrlSetData($txtUpgradeValue[$iz], _NumberFormat($aUpgrades[$iz][2])) ; Show Upgrade value in GUI
		GUICtrlSetState($chkWalls, $GUI_UNCHECKED) ; Turn off upgrade walls
		GUICtrlSetData($txtUpgradeX[$iz], $aUpgrades[$iz][0]) ; Set GUI X Position to match $aUpgrades variable
		GUICtrlSetData($txtUpgradeY[$iz], $aUpgrades[$iz][1]) ; Set GUI Y Position to match $aUpgrades variable
	Next
EndFunc   ;==>CheckUpgrades

Func UpgradeValue($inum) ;function to find the value and type of the upgrade.
	Local $inputbox, $iLoot
	Local $bOopsFlag = False
	If $aUpgrades[$inum][0] <= 0 Or $aUpgrades[$inum][1] <= 0 Then Return False
	$aUpgrades[$inum][2] = 0 ; Clear previous upgrade value if run before
	$aUpgrades[$inum][3] = "" ; Clear previous loot type if run before
	ClickP($aAway, 1,0,"#0211") ;Click Away to close windows
	SetLog("-$Upgrade #" & $inum + 1 & " Location =  " & "(" & $aUpgrades[$inum][0] & "," & $aUpgrades[$inum][1] & ")", $COLOR_TEAL) ;Debug
	If _Sleep($iDelayUpgradeValue1) Then Return
	Click($aUpgrades[$inum][0], $aUpgrades[$inum][1],1,0,"#0212") ;Select upgrade trained
	If _Sleep($iDelayUpgradeValue2) Then Return

	If $bOopsFlag = True Then DebugImageSave("ButtonView")

	Local $offColors[3][3] = [[0xD6714B, 47, 37], [0xF0E850, 70, 0], [0xF4F8F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel gold, 4th pixel edge of button
	Global $ButtonPixel = _MultiPixelSearch(240, 563, 670, 620, 1, 1, Hex(0xF3F3F1, 6), $offColors, 30) ; first gray/white pixel of button
	If $debugSetlog = 1 And IsArray($ButtonPixel) Then
		Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
		Setlog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 47, $ButtonPixel[1] + 37, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 70, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_PURPLE)
	EndIf

	If IsArray($ButtonPixel) = 0 Then ; If its not normal gold upgrade, then try to find elixir upgrade button
		Local $offColors[3][3] = [[0xBC5B31, 38, 32], [0xF84CF9, 72, 0], [0xF5F9F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel pink, 4th pixel edge of button
		Global $ButtonPixel = _MultiPixelSearch(240, 563, 670, 620, 1, 1, Hex(0xF4F7F2, 6), $offColors, 30) ; first gray/white pixel of button
		If $debugSetlog = 1 And IsArray($ButtonPixel) Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 38, $ButtonPixel[1] + 32, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 70, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_PURPLE)
		EndIf
	EndIf

	If IsArray($ButtonPixel) = 0 Then ; If its not upgrade, then try to find Hero upgrade button
		Local $offColors[3][3] = [[0x9B4C28, 41, 23], [0x040009, 72, 0], [0xF5F9F2, 79, 0]] ; 2nd pixel brown hammer, 3rd pixel black, 4th pixel edge of button
		Global $ButtonPixel = _MultiPixelSearch(240, 563, 670, 620, 1, 1, Hex(0xF6F9F3, 6), $offColors, 25) ; first gray/white pixel of button4
		If $debugSetlog = 1 And IsArray($ButtonPixel) Then
			Setlog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_PURPLE) ;Debug
			Setlog("Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 41, $ButtonPixel[1] + 23, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 72, $ButtonPixel[1], True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 79, $ButtonPixel[1], True), $COLOR_PURPLE)
		EndIf
	EndIf

	If IsArray($ButtonPixel) Then
		Click($ButtonPixel[0] + 20, $ButtonPixel[1] + 20,1,0,"#0213") ; Click Upgrade Button
		If _Sleep($iDelayUpgradeValue3) Then Return

		If $bOopsFlag = True Then DebugImageSave("UpgradeView")
		_CaptureRegion()

		Select ;Ensure the right upgrade window is open!
			Case _ColorCheck(_GetPixelColor(685, 150), Hex(0xE0080B, 6), 20) ; Check if the building Upgrade window is open
				If _ColorCheck(_GetPixelColor(351, 485), Hex(0xE0403D, 6), 20) Then ; Check if upgrade requires upgrade to TH and can not be completed
					Setlog("Selection #" & $inum + 1 & " upgrade not available, need TH upgrade - Skipped!", $COLOR_MAROON)
					$aUpgrades[$inum][0] = -1 ; Clear upgrade location value as it is invalid
					$aUpgrades[$inum][1] = -1 ; Clear upgrade location value as it  is invalid
					$aUpgrades[$inum][2] = 0 ; Clear upgrade value as it is invalid
					$aUpgrades[$inum][3] = "" ; Clear upgrade type as it  is invalid
					ClickP($aAway, 2,0,"#0214") ;Click Away
					Return False
				EndIf
				If _ColorCheck(_GetPixelColor(487, 479), Hex(0xF0E950, 6), 20) Then $aUpgrades[$inum][3] = "Gold" ;Check if Gold required and update type
				If _ColorCheck(_GetPixelColor(490, 475), Hex(0xF031DD, 6), 20) Then $aUpgrades[$inum][3] = "Elixir" ;Check if Elixir required and update type
				$aUpgrades[$inum][2] = Number(getResourcesBonus(384, 474)) ; Try to read white text.
				If $aUpgrades[$inum][2] = "" Then $aUpgrades[$inum][2] = Number(getUpgradeResource(384, 474)) ;read RED upgrade text
				If $aUpgrades[$inum][2] = "" Then $bOopsFlag = True ; set error flag for user to set value if not repeat upgrade

			Case _ColorCheck(_GetPixelColor(715, 147), Hex(0xE0080A, 6), 20) ; Check if the Hero Upgrade window is open
				If _ColorCheck(_GetPixelColor(400, 485), Hex(0xE0403D, 6), 20) Then ; Check if upgrade requires upgrade to TH and can not be completed
					Setlog("Selection #" & $inum + 1 & " upgrade not available, need TH upgrade - Skipped!", $COLOR_RED)
					$aUpgrades[$inum][0] = -1 ; Clear upgrade location value as it is invalid
					$aUpgrades[$inum][1] = -1 ; Clear upgrade location value as it  is invalid
					$aUpgrades[$inum][2] = 0 ; Clear upgrade value as it is invalid
					$aUpgrades[$inum][3] = "" ; Clear upgrade type as it  is invalid
					ClickP($aAway, 2,0,"#0215") ;Click Away
					Return False
				EndIf
				If _ColorCheck(_GetPixelColor(575, 498), Hex(0x000000, 6), 20) Then $aUpgrades[$inum][3] = "Dark" ; Check if DE required and update type
				$aUpgrades[$inum][2] = Number(getResourcesBonus(487, 478)) ; Try to read white text.
				If $aUpgrades[$inum][2] = "" Then $aUpgrades[$inum][2] = Number(getUpgradeResource(487, 478)) ;read RED upgrade text
				If $aUpgrades[$inum][2] = "" Then $bOopsFlag = True ; set error flag for user to set value

			Case Else
				If isGemOpen(True) Then ClickP($aAway, 2,0,"#0216")
				Setlog("Selected Upgrade Window Opening Error, try again", $COLOR_RED)
				$aUpgrades[$inum][0] = -1 ; Clear upgrade location value as it is invalid
				$aUpgrades[$inum][1] = -1 ; Clear upgrade location value as it  is invalid
				$aUpgrades[$inum][2] = 0 ; Clear upgrade value as it is invalid
				$aUpgrades[$inum][3] = "" ; Clear upgrade type as it  is invalid
				ClickP($aAway, 2,0,"#0217") ;Click Away
				Return False

		EndSelect

		; Failsafe fix for upgrade value read problems if needed.
		If $aUpgrades[$inum][3] <> "" And $bOopsFlag = True Then ;check if upgrade type value to not waste time and for text read oops flag
			$iLoot = $aUpgrades[$inum][2]
			If $iLoot = "" Then $iLoot = 8000000
			Local $aBotLoc = WinGetPos($frmbot)
			$inputbox = InputBox("Text Read Error", "Enter the cost of the upgrade", $iLoot, "", -1, -1, $aBotLoc[0] + 125, $aBotLoc[1] + 225, -1, $frmbot)
			If @error Then Return False
			$aUpgrades[$inum][2] = Int($inputbox)
			Setlog("User input value = " & $aUpgrades[$inum][2], $COLOR_PURPLE)
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
			$stext = "Save copy of upgrade image for developer analysis?"
			$MsgBox = _ExtMsgBox(48, "YES|NO", "Notice!", $stext, 60, $frmBot)
			If $MsgBox = 1 Then DebugImageSave("UpgradeReadError_")
		EndIf
		If $aUpgrades[$inum][3] = "" And $bOopsFlag = True Then
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 10, "Comic Sans MS", 500)
			$inputbox = _ExtMsgBox(0, "   GOLD   |  ELIXIR  |DARK ELIXIR", "Need User Help", "Select Upgrade Type:", 0, $frmBot)
			If $debugSetlog = 1 Then Setlog(" _MsgBox returned = " & $inputbox, $COLOR_PURPLE)
			Switch $inputbox
				Case 1
					$aUpgrades[$inum][3] = "Gold"
				Case 2
					$aUpgrades[$inum][3] = "Elixir"
				Case 3
					$aUpgrades[$inum][3] = "Dark"
				Case Else
					SetLog("Silly programmer made an error!", $COLOR_MAROON)
					$aUpgrades[$inum][3] = "HaHa"
			EndSwitch
			Setlog("User selected type = " & $aUpgrades[$inum][3], $COLOR_PURPLE)
		EndIf
		If $aUpgrades[$inum][2] = "" Or $aUpgrades[$inum][3] = "" Then ;report loot error if exists
			Setlog("Error finding loot info " & $inum & ", Loot = " & $aUpgrades[$inum][2] & ", Type= " & $aUpgrades[$inum][3], $COLOR_RED)
			$aUpgrades[$inum][0] = -1 ; Clear upgrade location value as it is invalid
			$aUpgrades[$inum][1] = -1 ; Clear upgrade location value as it  is invalid
			ClickP($aAway, 2,0,"#0218") ;Click Away
			Return False
		EndIf
		Setlog("UpgradeValue = " & _NumberFormat($aUpgrades[$inum][2]) & " " & $aUpgrades[$inum][3], $COLOR_BLUE) ; debug & document cost of upgrade
	Else
		;Setlog("Upgrade selection fail", $COLOR_RED)
		$aUpgrades[$inum][0] = -1 ; Clear upgrade location value as it is invalid
		$aUpgrades[$inum][1] = -1 ; Clear upgrade location value as it  is invalid
		ClickP($aAway, 2,0,"#0219") ;Click Away
		Return False

	EndIf
	ClickP($aAway, 2,0,"#0220") ;Click Away
	Return True

EndFunc   ;==>UpgradeValue


Func DebugImageSave($TxtName = "Unknown")

	; Debug Code to save images before zapping for later review, time stamped to align with logfile!
	SetLog("Taking snapshot for later review", $COLOR_GREEN) ;Debug purposes only :)
	$Date = @MDAY & "." & @MON & "." & @YEAR
	$Time = @HOUR & "." & @MIN & "." & @SEC
	_CaptureRegion()
	_GDIPlus_ImageSaveToFile($hBitmap, $dirloots & $TxtName & $Date & " at " & $Time & ".png")
	If _Sleep($iDelayDebugImageSave1) Then Return

EndFunc   ;==>DebugImageSave

