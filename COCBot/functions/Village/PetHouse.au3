; #FUNCTION# ====================================================================================================================
; Name ..........: PetHouse
; Description ...: Upgrade Pets
; Author ........: GrumpyHog (2021-04)
; Modified ......: Moebius (09/2024)
; Remarks .......: This file is part of MyBot Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Returns True or False
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================

Func TestPetHouse()
	Local $bWasRunState = $g_bRunState
	Local $sWasPetUpgradeTime = $g_sPetUpgradeTime
	Local $bWasUpgradePetsEnable = $g_bUpgradePetsEnable
	$g_bRunState = True
	For $i = 0 To $ePetCount - 1
		$g_bUpgradePetsEnable[$i] = True
	Next
	$g_sPetUpgradeTime = ""
	Local $Result = PetHouse(True)
	$g_bRunState = $bWasRunState
	$g_sPetUpgradeTime = $sWasPetUpgradeTime
	$g_bUpgradePetsEnable = $bWasUpgradePetsEnable
	Return $Result
EndFunc   ;==>TestPetHouse

Func PetHouse($test = False)

	If Not $g_bRunState Then Return

	Local $bUpgradePets = False
	Local $iPage = 0

	If $g_iTownHallLevel < 14 Then
		Return
	EndIf

	; Check at least one pet upgrade is enabled
	For $i = 0 To $ePetCount - 1
		If $g_bUpgradePetsEnable[$i] Then
			$bUpgradePets = True
			SetDebugLog($g_asPetNames[$i] & " upgrade enabled")
		EndIf
	Next

	If Not $bUpgradePets Then Return

	If $g_aiPetHousePos[0] <= 0 Or $g_aiPetHousePos[1] <= 0 Then
		SetLog("Pet House Location unknown!", $COLOR_WARNING)
		LocatePetHouse() ; Pet House location unknown, so find it.
		If $g_aiPetHousePos[0] = 0 Or $g_aiPetHousePos[1] = 0 Then
			SetLog("Problem locating Pet House, re-locate Pet House position before proceeding", $COLOR_ERROR)
			Return False
		EndIf
	EndIf

	If PetUpgradeInProgress() Then ; see if we know about an upgrade in progress without checking the Pet House
		$g_iMinDark4PetUpgrade = 0
		Return False
	EndIf

	; Get updated village elixir and dark elixir values
	VillageReport()

	; not enought Dark Elixir to upgrade lowest Pet
	If Number($g_aiCurrentLoot[$eLootDarkElixir]) < Number($g_iMinDark4PetUpgrade) Then
		If Number($g_iMinDark4PetUpgrade) <> 999999 Then
			SetLog("Minimum DE for Pet upgrade: " & _NumberFormat($g_iMinDark4PetUpgrade, True))
		Else
			SetLog("No Pets available for upgrade.")
		EndIf
		Return
	EndIf

	;Click Pet House
	BuildingClickP($g_aiPetHousePos, "#0197")
	If _Sleep(1500) Then Return ; Wait for window to open

	Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
	If IsArray($BuildingInfo) And UBound($BuildingInfo) > 0 Then
		SetLog("Pet House is level " & $BuildingInfo[2])
	EndIf

	If Not FindPetsButton() Then Return False ; cant start because we cannot find the Pets button

	If Not IsPetHousePage() Then
		SetLog("Failed to open Pet House Window!", $COLOR_ERROR)
		Return
	EndIf

	If CheckPetUpgrade() Then Return False ; cant start if something upgrading

	Local $iPetLevelxCoordStart = 40
	Local $iPetLevelxCoordStart2 = 272
	Local $iPetSlotWidth = 182

	For $i = 0 To $ePetCount - 1
		; check if pet upgrade enabled
		If Not $g_bUpgradePetsEnable[$i] Then ContinueLoop

		Local $iPetIndex = $i
		DragPetHouse($iPetIndex, $iPage)

		Switch $g_iTownHallLevel
				Case 14
					Switch $BuildingInfo[2]
						Case 1
							$g_ePetLevels[$i] = 10
							If $i > 0 Then ContinueLoop
						Case 2
							$g_ePetLevels[$i] = 10
							If $i > 1 Then ContinueLoop
						Case 3
							If $i <= 2 Then
								$g_ePetLevels[$i] = 10
							Else
								ContinueLoop
							EndIf
						Case 4
							If $i <= 3 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i > 3 Then
								ContinueLoop
							EndIf
						Case Else
							$g_ePetLevels[$i] = 10
					EndSwitch
				Case 15
					Switch $BuildingInfo[2]
						Case 1
							$g_ePetLevels[$i] = 10
							If $i > 0 Then ContinueLoop
						Case 2
							$g_ePetLevels[$i] = 10
							If $i > 1 Then ContinueLoop
						Case 3
							If $i <= 2 Then
								$g_ePetLevels[$i] = 10
							Else
								ContinueLoop
							EndIf
						Case 4
							If $i <= 3 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i > 3 Then
								ContinueLoop
							EndIf
						Case 5
							If $i > 0 And $i <= 4 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 5 Then
								ContinueLoop
							EndIf
						Case 6
							If $i > 0 And $i <= 5 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 6 Then
								ContinueLoop
							EndIf
						Case 7
							If $i > 0 And $i <> 2 And $i <= 6 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 7 Then
								ContinueLoop
							EndIf
						Case 8
							If $i > 0 And $i <> 2 And $i <= 7 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 8 Then
								ContinueLoop
							EndIf
						Case Else
							If $i = 1 Or $i = 3 Then $g_ePetLevels[$i] = 10
					EndSwitch
				Case 16
					Switch $BuildingInfo[2]
						Case 1
							$g_ePetLevels[$i] = 10
							If $i > 0 Then ContinueLoop
						Case 2
							$g_ePetLevels[$i] = 10
							If $i > 1 Then ContinueLoop
						Case 3
							If $i <= 2 Then
								$g_ePetLevels[$i] = 10
							Else
								ContinueLoop
							EndIf
						Case 4
							If $i <= 3 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i > 3 Then
								ContinueLoop
							EndIf
						Case 5
							If $i > 0 And $i <= 4 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 5 Then
								ContinueLoop
							EndIf
						Case 6
							If $i > 0 And $i <= 5 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 6 Then
								ContinueLoop
							EndIf
						Case 7
							If $i > 0 And $i <> 2 And $i <= 6 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 7 Then
								ContinueLoop
							EndIf
						Case 8
							If $i > 0 And $i <> 2 And $i <= 7 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 8 Then
								ContinueLoop
							EndIf
						Case 9
							If $i = 3 Then $g_ePetLevels[$i] = 10
							If $i > 8 Then ContinueLoop
						Case 10
							If $i = 3 Then $g_ePetLevels[$i] = 10
							If $i > 9 Then ContinueLoop
					EndSwitch
				Case 17
					Switch $BuildingInfo[2]
						Case 1
							$g_ePetLevels[$i] = 10
							If $i > 0 Then ContinueLoop
						Case 2
							$g_ePetLevels[$i] = 10
							If $i > 1 Then ContinueLoop
						Case 3
							If $i <= 2 Then
								$g_ePetLevels[$i] = 10
							Else
								ContinueLoop
							EndIf
						Case 4
							If $i <= 3 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i > 3 Then
								ContinueLoop
							EndIf
						Case 5
							If $i > 0 And $i <= 4 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 5 Then
								ContinueLoop
							EndIf
						Case 6
							If $i > 0 And $i <= 5 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 6 Then
								ContinueLoop
							EndIf
						Case 7
							If $i > 0 And $i <> 2 And $i <= 6 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 7 Then
								ContinueLoop
							EndIf
						Case 8
							If $i > 0 And $i <> 2 And $i <= 7 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 8 Then
								ContinueLoop
							EndIf
						Case 9
							If $i = 3 Then $g_ePetLevels[$i] = 10
							If $i > 8 Then ContinueLoop
						Case 10
							If $i = 3 Then $g_ePetLevels[$i] = 10
							If $i > 9 Then ContinueLoop
					EndSwitch
			EndSwitch

		Switch $i
			Case 0 To 3
				Local $aBlackBorder = _MultiPixelSearch2($iPetLevelxCoordStart + ($i * $iPetSlotWidth), 500 + $g_iMidOffsetY, $iPetLevelxCoordStart + ($i * $iPetSlotWidth) + 15, 500 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 15)
			Case 4 To 7
				Local $aBlackBorder = _MultiPixelSearch2($iPetLevelxCoordStart + (($i - 4) * $iPetSlotWidth), 500 + $g_iMidOffsetY, $iPetLevelxCoordStart + (($i - 4) * $iPetSlotWidth) + 15, 500 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 15)
			Case 8 To 10
				Local $aBlackBorder = _MultiPixelSearch2($iPetLevelxCoordStart2 + (($i - 8) * $iPetSlotWidth), 500 + $g_iMidOffsetY, $iPetLevelxCoordStart2 + (($i - 8) * $iPetSlotWidth) + 15, 500 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 15)
		EndSwitch
		If IsArray($aBlackBorder) Then
			Local $iPetLevelxCoord = $aBlackBorder[0] + 10
		Else
			ContinueLoop
		EndIf

		; check if pet upgrade unlocked
		If _ColorCheck(_GetPixelColor($iPetLevelxCoord, 380 + $g_iMidOffsetY, True), Hex(0xC8BEAD, 6), 15) Then
			; get the Pet Level
			Local $iPetLevel = getPetsLevel($iPetLevelxCoord, 544 + $g_iMidOffsetY)
			If Not ($iPetLevel > 0 And $iPetLevel <= $g_ePetLevels[$i]) Then ;If detected level is not between 1 and 10 Or 15, To Prevent Crash
				If $g_bDebugSetLog Then SetDebugLog("Pet Level OCR Misdetection, Detected Level is : " & $iPetLevel, $COLOR_WARNING)
				ContinueLoop
			EndIf
			If $iPetLevel < $g_ePetLevels[$i] Then
				SetLog($g_asPetNames[$i] & " is at level " & $iPetLevel)
			Else
				SetLog($g_asPetNames[$i] & " is at Max level (" & $g_ePetLevels[$i] & ")")
			EndIf
			If $iPetLevel = $g_ePetLevels[$i] Then ContinueLoop
			If _Sleep($DELAYLABORATORY2) Then Return
			; get DE requirement to upgrade Pet
			Local $iDarkElixirReq = 1000 * Number($g_aiPetUpgradeCostPerLevel[$i][$iPetLevel])
			$iDarkElixirReq = Int($iDarkElixirReq - ($iDarkElixirReq * Number($g_iBuilderBoostDiscount) / 100))
			SetLog("DE Requirement: " & _NumberFormat($iDarkElixirReq, True))
			If $iDarkElixirReq < $g_aiCurrentLoot[$eLootDarkElixir] Then
				SetLog("Will now upgrade " & $g_asPetNames[$i])
				; Randomise X,Y click
				Local $iX = Random($iPetLevelxCoord + 60, $iPetLevelxCoord + 75, 1)
				Local $iY = Random(495 + $g_iMidOffsetY, 510 + $g_iMidOffsetY, 1)
				Click($iX, $iY)
				; wait for ungrade window to open
				If _Sleep(1500) Then Return
				If _ColorCheck(_GetPixelColor(570, 525 + $g_iMidOffsetY, True), Hex(0xD6F889, 6), 20) Then
					Local $RedZero = _PixelSearch(610, 548 + $g_iMidOffsetY, 650, 552 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20)
					If IsArray($RedZero) Then     ; Check for Red Zero = means not enough loot!
						SetLog("Not Enough Loot To Upgrade Pet!", $COLOR_ERROR)
						For $i = 0 To 1
							CloseWindow()
						Next
						Return False
					Else
						If $g_bDebugImageSave Then SaveDebugImage("PetHouse") ; Debug Only
						; check if this just a test
						If Not $test Then
							Click(630, 540 + $g_iMidOffsetY) ; click upgrade
							If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to close
							; Just incase the buy Gem Window pop up!
							If isGemOpen(True) Then
								SetDebugLog("Not enough DE for to upgrade: " & $g_asPetNames[$i], $COLOR_DEBUG)
								For $i = 0 To 1
									CloseWindow()
								Next
								Return False
							EndIf
							CloseWindow() ; close pet upgrade window
							; Update gui
							;==========Hide Red  Show Green Hide Gray===
							GUICtrlSetState($g_hPicPetGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicPetGreen, $GUI_SHOW)
							;===========================================
							If _Sleep($DELAYLABORATORY1) Then Return
							Local $sPetTimeOCR = getPetUpgradeTime(235, 242 + $g_iMidOffsetY)
							Local $iPetFinishTime = ConvertOCRTime("Lab Time", $sPetTimeOCR, False)
							SetDebugLog("$sPetTimeOCR: " & $sPetTimeOCR & ", $iPetFinishTime = " & $iPetFinishTime & " m")
							If $iPetFinishTime > 0 Then
								$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTime), _NowCalc())
								SetLog("Pet House will finish in " & $sPetTimeOCR & " (" & $g_sPetUpgradeTime & ")")
							EndIf
						Else
							CloseWindow() ; close pet upgrade window
						EndIf
						SetLog("Started upgrade for : " & $g_asPetNames[$i])
						If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asPetLabUpgradeTime[$g_iCurAccount] = $g_sPetUpgradeTime for instantly displaying in multi-stats
						CloseWindow()
						Return True
					EndIf
				EndIf
				SetLog("Failed to find Confirm button", $COLOR_ERROR)
			EndIf
			SetLog("Upgrade Failed - Not enough Dark Elixir", $COLOR_ERROR)
		ElseIf _ColorCheck(_GetPixelColor($iPetLevelxCoord, 380 + $g_iMidOffsetY, True), Hex(0xABABAB, 6), 20) Then
			SetLog($g_asPetNames[$i] & " is Locked")
		EndIf
	Next
	SetLog("No Pet Upgrade Possible, Check Your Settings", $COLOR_DEBUG1)
	CloseWindow()
	Return
EndFunc   ;==>PetHouse

; check the Pet House to see if a Pet is upgrading already
Func CheckPetUpgrade()
	; check for upgrade in process - look for green in finish upgrade with gems button
	If $g_bDebugSetLog Then SetLog("_GetPixelColor(805, 245): " & _GetPixelColor(085, 215 + $g_iMidOffsetY, True) & ":BED79A", $COLOR_DEBUG)
	If _ColorCheck(_GetPixelColor(805, 215 + $g_iMidOffsetY, True), Hex(0xBED79A, 6), 20) Then
		SetLog("Pet House Upgrade in progress, waiting for completion", $COLOR_INFO)
		If _Sleep($DELAYLABORATORY2) Then Return
		; upgrade in process and time not recorded so update completion time!
		Local $sPetTimeOCR = getPetUpgradeTime(235, 242 + $g_iMidOffsetY)
		Local $iPetFinishTime = ConvertOCRTime("Lab Time", $sPetTimeOCR, False)
		SetDebugLog("$sPetTimeOCR: " & $sPetTimeOCR & ", $iPetFinishTime = " & $iPetFinishTime & " m")
		If $iPetFinishTime > 0 Then
			$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTime), _NowCalc())
			If @error Then _logErrorDateAdd(@error)
			SetLog("Pet Upgrade will finish in " & $sPetTimeOCR & " (" & $g_sPetUpgradeTime & ")")
			; LabStatusGUIUpdate() ; Update GUI flag
		ElseIf $g_bDebugSetLog Then
			SetLog("PetLabUpgradeInProgress - Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
		EndIf
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asPetLabUpgradeTime[$g_iCurAccount] = $g_sPetUpgradeTime for instantly displaying in multi-stats
		CloseWindow()
		Return True
	EndIf
	Return False ; returns False if no upgrade in progress
EndFunc   ;==>CheckPetUpgrade

; checks our global variable to see if we know of something already upgrading
Func PetUpgradeInProgress()
	Local $TimeDiff ; time remaining on lab upgrade
	If $g_sPetUpgradeTime <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $g_sPetUpgradeTime) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)
	;SetDebugLog($g_avLabTroops[$g_iCmbLaboratory][0] & " Lab end time: " & $g_sLabUpgradeTime & ", DIFF= " & $TimeDiff, $COLOR_DEBUG)

	If Not $g_bRunState Then Return
	If $TimeDiff <= 0 Then
		SetLog("Checking Pet House ...", $COLOR_INFO)
	Else
		SetLog("Pet Upgrade in progress, waiting for completion", $COLOR_INFO)
		Return True
	EndIf
	Return False ; we currently do not know of any upgrades in progress
EndFunc   ;==>PetUpgradeInProgress

Func FindPetsButton()
	Local $aPetsButton = findButton("Pets", Default, 1, True)
	If IsArray($aPetsButton) And UBound($aPetsButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("PetHouse") ; Debug Only
		ClickP($aPetsButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
		Return True
	Else
		SetLog("Cannot find the Pets Button!", $COLOR_ERROR)
		CloseWindow()
		Return False
	EndIf
EndFunc   ;==>FindPetsButton

; called from main loop to get an early status for indictors in bot bottom
; run every if no upgradeing pet
Func PetGuiDisplay()

	If $g_iTownHallLevel < 14 Then
		SetLog("TH reads as Lvl " & $g_iTownHallLevel & ", has no Pet House.")
		;============Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;============================================
		Return
	EndIf

	Local Static $iLastTimeChecked[8]
	If $g_bFirstStart Then $iLastTimeChecked[$g_iCurAccount] = ""

	; Check if is a valid date and Calculated the number of minutes from remain time Lab and now
	If _DateIsValid($g_sPetUpgradeTime) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
		Local $iLabTime = _DateDiff('n', _NowCalc(), $g_sPetUpgradeTime)
		Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Pet House PetUpgradeTime: " & $g_sPetUpgradeTime & ", Pet DateCalc: " & $iLabTime)
		SetDebugLog("Pet House LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
		; A check each 6 hours [6*60 = 360] or when Lab research time finishes
		If $iLabTime > 0 And $iLastCheck <= 360 Then Return
	EndIf

	; not enough Dark Elixir for upgrade -
	If Number($g_aiCurrentLoot[$eLootDarkElixir]) < Number($g_iMinDark4PetUpgrade) And Not _DateIsValid($g_sPetUpgradeTime) Then
		If Number($g_iMinDark4PetUpgrade) <> 999999 Then
			SetLog("Current DE Storage: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
			SetLog("Minimum DE for Pet upgrade: " & _NumberFormat($g_iMinDark4PetUpgrade, True))
			Return
		Else
			If _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
				Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
				; A check each from 3 to 4 hours [3*60 = 180 to 4*60 = 240] To check if new pet is available
				Local $iDelayToCheck = Random(180, 240, 1)
				If $iLastCheck <= $iDelayToCheck Then
					SetLog("No Pets available for upgrade.")
					Return
				EndIf
			EndIf
		EndIf
	EndIf

	ClearScreen()
	If _Sleep(1500) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts

	SetLog("Checking Pet Status", $COLOR_INFO)

	;=================Section 2 Lab Gui

	; If $g_bAutoLabUpgradeEnable = True Then  ====>>>> TODO : or use this or make a checkbox on GUI
	; make sure lab is located, if not locate lab
	If $g_aiPetHousePos[0] <= 0 Or $g_aiPetHousePos[1] <= 0 Then
		SetLog("Pet House Location is unknown!", $COLOR_ERROR)
		;============Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;============================================
		Return
	EndIf

	If $g_bDebugSetLog Then SetDebugLog("Pet House (x,y): " & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1])

	BuildingClickP($g_aiPetHousePos, "#0197") ;Click Laboratory
	If _Sleep(1500) Then Return ; Wait for window to open
	; Find Research Button

	Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
	If IsArray($BuildingInfo) And UBound($BuildingInfo) > 0 Then
		SetLog("Pet House is level " & $BuildingInfo[2])
	EndIf

	Local $aPetsButton = findButton("Pets", Default, 1, True)
	If IsArray($aPetsButton) And UBound($aPetsButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("PetsUpgrade") ; Debug Only
		ClickP($aPetsButton)
		If _Sleep(1500) Then Return ; Wait for window to open
	Else
		SetLog("Cannot find the Pet House Button!", $COLOR_ERROR)
		ClearScreen()
		;===========Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;===========================================
		Return
	EndIf

	If Not IsPetHousePage() Then
		SetLog("Pet House Window did not open!", $COLOR_ERROR)
		Return
	EndIf

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	Local $IsRunning = False
	Local $IsStopped = False

	For $i = 0 To 5
		If _ColorCheck(_GetPixelColor(805, 215 + $g_iMidOffsetY, True), Hex(0xBED79A, 6), 20) Then ; Look for light green on the right in lab window.
			$IsRunning = True
			ExitLoop
		EndIf
		If _ColorCheck(_GetPixelColor(150, 270 + $g_iMidOffsetY, True), Hex(0xCFB138, 6), 20) Then ; Look for the paw in the Pet House window.
			$IsStopped = True
			ExitLoop
		EndIf
		If _Sleep(500) Then Return
	Next

	; check for upgrade in process - look for green in finish upgrade with gems button
	If $IsRunning Then ; Look for light green in upper right corner of lab window.
		SetLog("Pet House is Running", $COLOR_INFO)
		;==========Hide Red  Show Green Hide Gray===
		GUICtrlSetState($g_hPicPetGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGreen, $GUI_SHOW)
		;===========================================
		If _Sleep($DELAYLABORATORY2) Then Return
		Local $sPetTimeOCR = getPetUpgradeTime(235, 242 + $g_iMidOffsetY)
		Local $iPetFinishTime = ConvertOCRTime("Lab Time", $sPetTimeOCR, False)
		SetDebugLog("$sPetTimeOCR: " & $sPetTimeOCR & ", $iPetFinishTime = " & $iPetFinishTime & " m")
		If $iPetFinishTime > 0 Then
			$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTime), _NowCalc())
			SetLog("Pet House will finish in " & $sPetTimeOCR & " (" & $g_sPetUpgradeTime & ")")
		EndIf
		$g_iMinDark4PetUpgrade = 0
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asPetLabUpgradeTime[$g_iCurAccount] = $g_sPetUpgradeTime for instantly displaying in multi-stats
		CloseWindow()
		Return True
	ElseIf $IsStopped Then ; Look for the paw in the Pet House window.
		SetLog("Pet House has Stopped", $COLOR_INFO)
		;If $g_bNotifyTGEnable And $g_bNotifyAlertLaboratoryIdle Then NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Laboratory-Idle_Info_01", "Laboratory Idle") & "%0A" & GetTranslatedFileIni("MBR Func_Notify", "Laboratory-Idle_Info_02", "Laboratory has Stopped"))
		;========Show Red  Hide Green  Hide Gray=====
		GUICtrlSetState($g_hPicPetGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;============================================
		$g_sPetUpgradeTime = ""
		$g_iMinDark4PetUpgrade = GetMinDark4PetUpgrade($BuildingInfo[2])
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asPetLabUpgradeTime[$g_iCurAccount] = $g_sPetUpgradeTime for instantly displaying in multi-stats
		CloseWindow()
		Return
	Else
		SetLog("Unable to determine Pet House Status", $COLOR_INFO)
		;========Hide Red  Hide Green  Show Gray======
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;=============================================
		CloseWindow()
		$iLastTimeChecked[$g_iCurAccount] = ""
		Return
	EndIf

EndFunc   ;==>PetGuiDisplay

Func GetMinDark4PetUpgrade($PetHouseLevel = 0)
	Local $iPetLevelxCoordStart = 40
	Local $iPetLevelxCoordStart2 = 272
	Local $iPetSlotWidth = 182
	Local $iMinDark4PetUpgrade = 999999
	Local $iPage = 0

	For $i = 0 To $ePetCount - 1
		; check if pet upgrade enabled
		If Not $g_bUpgradePetsEnable[$i] Then ContinueLoop

		DragPetHouse($i, $iPage)

		Switch $g_iTownHallLevel
			Case 14
				Switch $PetHouseLevel
					Case 1
						$g_ePetLevels[$i] = 10
						If $i > 0 Then ContinueLoop
					Case 2
						$g_ePetLevels[$i] = 10
						If $i > 1 Then ContinueLoop
					Case 3
						If $i <= 2 Then
							$g_ePetLevels[$i] = 10
						Else
							ContinueLoop
						EndIf
					Case 4
						If $i <= 3 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i > 3 Then
							ContinueLoop
						EndIf
				EndSwitch
			Case 15
				Switch $PetHouseLevel
					Case 1
						$g_ePetLevels[$i] = 10
						If $i > 0 Then ContinueLoop
					Case 2
						$g_ePetLevels[$i] = 10
						If $i > 1 Then ContinueLoop
					Case 3
						If $i <= 2 Then
							$g_ePetLevels[$i] = 10
						Else
							ContinueLoop
						EndIf
					Case 4
						If $i <= 3 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i > 3 Then
							ContinueLoop
						EndIf
					Case 5
						If $i > 0 And $i <= 4 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 5 Then
							ContinueLoop
						EndIf
					Case 6
						If $i > 0 And $i <= 5 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 6 Then
							ContinueLoop
						EndIf
					Case 7
						If $i > 0 And $i <> 2 And $i <= 6 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 7 Then
							ContinueLoop
						EndIf
					Case 8
						If $i > 0 And $i <> 2 And $i <= 7 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 8 Then
							ContinueLoop
						EndIf
					Case Else
						If $i = 1 Or $i = 3 Then $g_ePetLevels[$i] = 10
				EndSwitch
			Case 16
				Switch $PetHouseLevel
					Case 1
						$g_ePetLevels[$i] = 10
						If $i > 0 Then ContinueLoop
					Case 2
						$g_ePetLevels[$i] = 10
						If $i > 1 Then ContinueLoop
					Case 3
						If $i <= 2 Then
							$g_ePetLevels[$i] = 10
						Else
							ContinueLoop
						EndIf
					Case 4
						If $i <= 3 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i > 3 Then
							ContinueLoop
						EndIf
					Case 5
						If $i > 0 And $i <= 4 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 5 Then
							ContinueLoop
						EndIf
					Case 6
						If $i > 0 And $i <= 5 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 6 Then
							ContinueLoop
						EndIf
					Case 7
						If $i > 0 And $i <> 2 And $i <= 6 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 7 Then
							ContinueLoop
						EndIf
					Case 8
						If $i > 0 And $i <> 2 And $i <= 7 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 8 Then
							ContinueLoop
						EndIf
					Case 9
						If $i = 3 Then $g_ePetLevels[$i] = 10
						If $i > 8 Then ContinueLoop
					Case 10
						If $i = 3 Then $g_ePetLevels[$i] = 10
						If $i > 9 Then ContinueLoop
				EndSwitch
			Case 17
				Switch $PetHouseLevel
					Case 1
						$g_ePetLevels[$i] = 10
						If $i > 0 Then ContinueLoop
					Case 2
						$g_ePetLevels[$i] = 10
						If $i > 1 Then ContinueLoop
					Case 3
						If $i <= 2 Then
							$g_ePetLevels[$i] = 10
						Else
							ContinueLoop
						EndIf
					Case 4
						If $i <= 3 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i > 3 Then
							ContinueLoop
						EndIf
					Case 5
						If $i > 0 And $i <= 4 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 5 Then
							ContinueLoop
						EndIf
					Case 6
						If $i > 0 And $i <= 5 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 6 Then
							ContinueLoop
						EndIf
					Case 7
						If $i > 0 And $i <> 2 And $i <= 6 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 7 Then
							ContinueLoop
						EndIf
					Case 8
						If $i > 0 And $i <> 2 And $i <= 7 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 8 Then
							ContinueLoop
						EndIf
					Case 9
						If $i = 3 Then $g_ePetLevels[$i] = 10
						If $i > 8 Then ContinueLoop
					Case 10
						If $i = 3 Then $g_ePetLevels[$i] = 10
						If $i > 9 Then ContinueLoop
				EndSwitch
		EndSwitch

		Switch $i
			Case 0 To 3
				Local $aBlackBorder = _MultiPixelSearch2($iPetLevelxCoordStart + ($i * $iPetSlotWidth), 500 + $g_iMidOffsetY, $iPetLevelxCoordStart + ($i * $iPetSlotWidth) + 15, 500 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 15)
			Case 4 To 7
				Local $aBlackBorder = _MultiPixelSearch2($iPetLevelxCoordStart + (($i - 4) * $iPetSlotWidth), 500 + $g_iMidOffsetY, $iPetLevelxCoordStart + (($i - 4) * $iPetSlotWidth) + 15, 500 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 15)
			Case 8 To 10
				Local $aBlackBorder = _MultiPixelSearch2($iPetLevelxCoordStart2 + (($i - 8) * $iPetSlotWidth), 500 + $g_iMidOffsetY, $iPetLevelxCoordStart2 + (($i - 8) * $iPetSlotWidth) + 15, 500 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 15)
		EndSwitch
		If IsArray($aBlackBorder) Then
			Local $iPetLevelxCoord = $aBlackBorder[0] + 10
		Else
			ContinueLoop
		EndIf

		; check if pet upgrade enabled and unlocked
		If _ColorCheck(_GetPixelColor($iPetLevelxCoord, 380 + $g_iMidOffsetY, True), Hex(0xC8BEAD, 6), 15) Then

			; get the Pet Level
			Local $iPetLevel = getPetsLevel($iPetLevelxCoord, 544 + $g_iMidOffsetY)
			If Not ($iPetLevel > 0 And $iPetLevel <= $g_ePetLevels[$i]) Then ;If detected level is not between 1 and 10 Or 15, To Prevent Crash
				If $g_bDebugSetLog Then SetDebugLog("Pet Level OCR Misdetection, Detected Level is : " & $iPetLevel, $COLOR_WARNING)
				ContinueLoop
			EndIf

			If $iPetLevel < $g_ePetLevels[$i] Then
				SetLog($g_asPetNames[$i] & " is at level " & $iPetLevel)
			Else
				SetLog($g_asPetNames[$i] & " is at Max level (" & $g_ePetLevels[$i] & ")")
			EndIf
			If $iPetLevel = $g_ePetLevels[$i] Then ContinueLoop

			If _Sleep($DELAYLABORATORY2) Then Return

			; get DE requirement to upgrade Pet
			Local $iDarkElixirReq = (1000 * Number($g_aiPetUpgradeCostPerLevel[$i][$iPetLevel]))
			$iDarkElixirReq = Int($iDarkElixirReq - ($iDarkElixirReq * Number($g_iBuilderBoostDiscount) / 100))

			SetLog("DE Requirement: " & _NumberFormat($iDarkElixirReq, True))

			If $iDarkElixirReq < $iMinDark4PetUpgrade Then
				$iMinDark4PetUpgrade = $iDarkElixirReq
				SetLog("New Min Dark: " & _NumberFormat($iMinDark4PetUpgrade, True))
			EndIf
		ElseIf _ColorCheck(_GetPixelColor($iPetLevelxCoord, 380 + $g_iMidOffsetY, True), Hex(0xB7B7B7, 6), 15) Then
			SetLog($g_asPetNames[$i] & " is Locked")
		EndIf
	Next

	Return $iMinDark4PetUpgrade
EndFunc   ;==>GetMinDark4PetUpgrade

Func DragPetHouse($iPetIndex, ByRef $iPage)
	Local $iY1
	Local $iY2
	Local $iPageTarget
	Local $bLoop = 0

	Switch $iPetIndex
		Case 0 To 3
			$iPageTarget = 0
		Case 4 To 7
			$iPageTarget = 1
		Case 8 To 10
			$iPageTarget = 2
	EndSwitch

	While 1

		If $iPage = $iPageTarget Then ExitLoop

		Local $iYPoint = Random(500 + $g_iMidOffsetY, 530 + $g_iMidOffsetY, 1)

		If $iPage < $iPageTarget Then
			If $iPage = 0 Then
				ClickDrag(770, $iYPoint, 190, $iYPoint, 300)
				SetDebugLog("Moving from page 0 to 1")
			Else
				ClickDrag(590, $iYPoint, 190, $iYPoint, 300)
				SetDebugLog("Moving from page 1 to 2")
			EndIf
			If _Sleep(Random(1800, 2500, 1)) Then Return
			$iPage += 1
		EndIf

		If $iPage > $iPageTarget Then
			If $iPage = 2 Then
				ClickDrag(170, $iYPoint, 560, $iYPoint, 300)
				SetDebugLog("Moving from page 2 to 1")
			Else
				ClickDrag(60, $iYPoint, 660, $iYPoint, 300)
				SetDebugLog("Moving from page 1 to 0")
			EndIf
			If _Sleep(Random(1800, 2500, 1)) Then Return
			$iPage -= 1
		EndIf

		$bLoop += 1
		If $bLoop = 10 Then ExitLoop

	WEnd

EndFunc   ;==>DragPetHouse
