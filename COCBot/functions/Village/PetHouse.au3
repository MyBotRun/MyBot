; #FUNCTION# ====================================================================================================================
; Name ..........: PetHouse
; Description ...: Upgrade Pets
; Author ........: GrumpyHog (2021-04)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015-2021
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
	For $i = 0 to $ePetCount - 1
		$g_bUpgradePetsEnable[$i] = True
	Next
	$g_sPetUpgradeTime = ""
	Local $Result = PetHouse(True)
	$g_bRunState = $bWasRunState
	$g_sPetUpgradeTime = $sWasPetUpgradeTime
	$g_bUpgradePetsEnable = $bWasUpgradePetsEnable
	Return $Result
EndFunc

Func PetHouse($test = False)
	Local $bUpgradePets = False

   If $g_iTownHallLevel < 14 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Pet House.", $COLOR_ERROR)
		Return
	EndIf

	; Check at least one pet upgrade is enable
	For $i = 0 to $ePetCount - 1
		If $g_bUpgradePetsEnable[$i] Then
			$bUpgradePets = True
			SetLog($g_asPetNames[$i] & " upgrade enabled");
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

 	If PetUpgradeInProgress() Then Return False ; see if we know about an upgrade in progress without checking the Pet House

	; Get updated village elixir and dark elixir values
	VillageReport()

	; not enought Dark Elixir to upgrade lowest Pet
	If $g_aiCurrentLoot[$eLootDarkElixir] < $g_iMinDark4PetUpgrade Then
		SetLog("Current DE Storage: " & $g_aiCurrentLoot[$eLootDarkElixir])
		SetLog("Minumum DE for upgrade: " & $g_iMinDark4PetUpgrade)
		Return
	EndIf

	;Click Pet House
	BuildingClickP($g_aiPetHousePos, "#0197")
	If _Sleep(1500) Then Return ; Wait for window to open

	If Not FindPetsButton() Then Return False ; cant start becuase we cannot find the Pets button

	If Not IsPetHousePage() Then
		SetLog("Failed to open Pet House Window!", $COLOR_ERROR)
		Return
	EndIf

	If CheckPetUpgrade() Then Return False ; cant start if something upgrading

	; Pet upgrade is not in progress and not upgreading, so we need to start an upgrade.
	Local $iPetUnlockedxCoord[4] = [190, 345, 500, 655]
	Local $iPetLevelxCoord[4] = [134, 288, 443, 598]


	For $i = 0 to $ePetCount - 1
		; check if pet upgrade enabled and unlocked ; c3b6a5 nox c1b7a5 memu?
		If $g_bUpgradePetsEnable[$i] And _ColorCheck(_GetPixelColor($iPetUnlockedxCoord[$i], 415, True), Hex(0xc3b6a5, 6), 20) Then

			; get the Pet Level
			Local $iPetLevel = getTroopsSpellsLevel($iPetLevelxCoord[$i], 533)
			SetLog($g_asPetNames[$i] & " is at level " & $iPetLevel)

			If _Sleep($DELAYLABORATORY2) Then Return

			; get DE requirement to upgrade Pet
			Local $iDarkElixirReq = 1000 * number($g_aiPetUpgradeCostPerLevel[$i][$iPetLevel])

			SetLog("DE Requirement: " & $iDarkElixirReq)

			If $iDarkElixirReq < $g_aiCurrentLoot[$eLootDarkElixir] Then
				SetLog("Will now upgrade " & $g_asPetNames[$i])

			   ; Randomise X,Y click
				Local $iX = Random($iPetUnlockedxCoord[$i]-10, $iPetUnlockedxCoord[$i]+10, 1)
				Local $iY = Random(500, 520, 1)
				Click($iX, $iY)

			   ; wait for ungrade window to open
				If _Sleep(1500) Then Return

			   ; use image search to find Upgrade Button
				Local $aUpgradePetButton = findButton("UpgradePet", Default, 1, True)

			   ; check button found
			   If IsArray($aUpgradePetButton) And UBound($aUpgradePetButton, 1) = 2 Then
					If $g_bDebugImageSave Then SaveDebugImage("PetHouse") ; Debug Only

					; check if this just a test
					If Not $test Then
						ClickP($aUpgradePetButton) ; click upgrade and window close

						If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to close

						; Just incase the buy Gem Window pop up!
						If isGemOpen(True) Then
							SetDebugLog("Not enough DE for to upgrade: " & $g_asPetNames[$i], $COLOR_DEBUG)
							ClickAway()
							Return False
						EndIf

						; Update gui
						;==========Hide Red  Show Green Hide Gray===
						GUICtrlSetState($g_hPicPetGray, $GUI_HIDE)
						GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
						GUICtrlSetState($g_hPicPetGreen, $GUI_SHOW)
						;===========================================
						If _Sleep($DELAYLABORATORY2) Then Return
						Local $sPetTimeOCR = getRemainTLaboratory(274, 286)
						Local $iPetFinishTime = ConvertOCRTime("Lab Time", $sPetTimeOCR, False)
						SetDebugLog("$sPetTimeOCR: " & $sPetTimeOCR & ", $iPetFinishTime = " & $iPetFinishTime & " m")
						If $iPetFinishTime > 0 Then
							$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTime), _NowCalc())
							SetLog("Pet House will finish in " & $sPetTimeOCR & " (" & $g_sPetUpgradeTime & ")")
						EndIf

					Else
						ClickAway() ; close pet upgrade window
					EndIf

					SetLog("Started upgrade for: " & $g_asPetNames[$i])
					ClickAway() ; close pet house window
					Return True
				Else
					SetLog("Failed to find the Pets button!", $COLOR_ERROR)
					ClickAway()
					Return False
				EndIf
			   SetLog("Failed to find Upgrade button", $COLOR_ERROR)
			EndIf
			SetLog("Upgrade Failed - Not enough Dark Elixir", $COLOR_ERROR)
		 EndIf
	Next

	SetLog("Pet upgrade failed, check your settings", $COLOR_ERROR)

	Return
EndFunc

; check the Pet House to see if a Pet is upgrading already
Func CheckPetUpgrade()
	; check for upgrade in process - look for green in finish upgrade with gems button
	If $g_bDebugSetlog Then SetLog("_GetPixelColor(730, 200): " & _GetPixelColor(730, 200, True) & ":E5FD94", $COLOR_DEBUG)
	If _ColorCheck(_GetPixelColor(695, 265, True), Hex(0xE5FD94, 6), 20) Then
		SetLog("Pet House Upgrade in progress, waiting for completion", $COLOR_INFO)
		If _Sleep($DELAYLABORATORY2) Then Return
		; upgrade in process and time not recorded so update completion time!
		Local $sPetTimeOCR = getRemainTLaboratory(274, 286)
		Local $iPetFinishTime = ConvertOCRTime("Lab Time", $sPetTimeOCR, False)
		SetDebugLog("$sPetTimeOCR: " & $sPetTimeOCR & ", $iPetFinishTime = " & $iPetFinishTime & " m")
		If $iPetFinishTime > 0 Then
			$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTime), _NowCalc())
			If @error Then _logErrorDateAdd(@error)
			SetLog("Pet Upgrade will finish in " & $sPetTimeOCR & " (" & $g_sPetUpgradeTime & ")")
			; LabStatusGUIUpdate() ; Update GUI flag
		ElseIf $g_bDebugSetlog Then
			SetLog("PetLabUpgradeInProgress - Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
		EndIf
		ClickAway()
		Return True
	EndIf
	Return False ; returns False if no upgrade in progress
EndFunc

; checks our global variable to see if we know of something already upgrading
Func PetUpgradeInProgress()
	Local $TimeDiff ; time remaining on lab upgrade
	If $g_sPetUpgradeTime <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $g_sPetUpgradeTime) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)
	;If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$g_iCmbLaboratory][0] & " Lab end time: " & $g_sLabUpgradeTime & ", DIFF= " & $TimeDiff, $COLOR_DEBUG)

	If Not $g_bRunState Then Return
	If $TimeDiff <= 0 Then
		SetLog("Checking Pet House ...", $COLOR_INFO)
	Else
		SetLog("Pet Upgrade in progress, waiting for completion", $COLOR_INFO)
		Return True
	EndIf
	Return False ; we currently do not know of any upgrades in progress
EndFunc

Func FindPetsButton()
	Local $aPetsButton = findButton("Pets", Default, 1, True)
	If IsArray($aPetsButton) And UBound($aPetsButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("PetHouse") ; Debug Only
		ClickP($aPetsButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
		Return True
	Else
		SetLog("Cannot find the Pets Button!", $COLOR_ERROR)
		ClickAway()
		Return False
	EndIf
EndFunc

; called from main loop to get an early status for indictors in bot bottom
; run every if no upgradeing pet
Func PetGuiDisplay()

	Local Static $iLastTimeChecked[8]
	If $g_bFirstStart Then $iLastTimeChecked[$g_iCurAccount] = ""

	; Check if is a valid date and Calculated the number of minutes from remain time Lab and now
	If _DateIsValid($g_sPetUpgradeTime) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
		Local $iLabTime = _DateDiff('n', _NowCalc(), $g_sPetUpgradeTime)
		Local $iLastCheck =_DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Pet House PetUpgradeTime: " & $g_sPetUpgradeTime & ", Pet DateCalc: " & $iLabTime)
		SetDebugLog("Pet House LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
		; A check each 6 hours [6*60 = 360] or when Lab research time finishes
		If $iLabTime > 0 And $iLastCheck <= 360 Then Return
	EndIf


	;If  $g_aiCurrentLoot[$eLootDarkElixir] < $g_iMinDark4PetUpgrade Then Return

	; not enough Dark Elixir for upgrade -
	If $g_aiCurrentLoot[$eLootDarkElixir] < $g_iMinDark4PetUpgrade Then
		SetLog("Current DE Storage: " & $g_aiCurrentLoot[$eLootDarkElixir])
		SetLog("Minumum DE for upgrade: " & $g_iMinDark4PetUpgrade)
		Return
	EndIf

	;CLOSE ARMY WINDOW
	;ClickAway()

	If _Sleep(1500) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts

	If $g_iTownHallLevel < 14 Then
		SetDebugLog("TH reads as Lvl " & $g_iTownHallLevel & ", has no Pet House.")
		;============Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;============================================
		Return
	EndIf

	Setlog("Checking Pet Status", $COLOR_INFO)

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

	SetLog("Pet House (x,y): " & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1])

	BuildingClickP($g_aiPetHousePos, "#0197") ;Click Laboratory
	If _Sleep(1500) Then Return ; Wait for window to open
	; Find Research Button

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	Local $aPetsButton = findButton("Pets", Default, 1, True)
	If IsArray($aPetsButton) And UBound($aPetsButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("PetsUpgrade") ; Debug Only
		ClickP($aPetsButton)
		If _Sleep(1500) Then Return ; Wait for window to open
	Else
		SetLog("Cannot find the Pet House Button!", $COLOR_ERROR)
		ClickAway()
		;CloseWindow("ClosePetHouse")
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

	$g_iMinDark4PetUpgrade = GetMinDark4PetUpgrade()

	; check for upgrade in process - look for green in finish upgrade with gems button
	If _ColorCheck(_GetPixelColor(695, 265, True), Hex(0xE5FD94, 6), 20) Then ; Look for light green in upper right corner of lab window.
		SetLog("Pet House is Running", $COLOR_INFO)
		;==========Hide Red  Show Green Hide Gray===
		GUICtrlSetState($g_hPicPetGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGreen, $GUI_SHOW)
		;===========================================
		If _Sleep($DELAYLABORATORY2) Then Return
		Local $sPetTimeOCR = getRemainTLaboratory(274, 286)
		Local $iPetFinishTime = ConvertOCRTime("Lab Time", $sPetTimeOCR, False)
		SetDebugLog("$sPetTimeOCR: " & $sPetTimeOCR & ", $iPetFinishTime = " & $iPetFinishTime & " m")
		If $iPetFinishTime > 0 Then
			$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTime), _NowCalc())
			SetLog("Pet House will finish in " & $sPetTimeOCR & " (" & $g_sPetUpgradeTime & ")")
		EndIf
		;CloseWindow("CloseLab")
		ClickAway()
		;If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
			Return True
	ElseIf _ColorCheck(_GetPixelColor(260, 260, True), Hex(0xCCB43B, 6), 20) Then ; Look for the paw in the Pet House window.
			SetLog("Pet House has Stopped", $COLOR_INFO)
		;If $g_bNotifyTGEnable And $g_bNotifyAlertLaboratoryIdle Then NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Laboratory-Idle_Info_01", "Laboratory Idle") & "%0A" & GetTranslatedFileIni("MBR Func_Notify", "Laboratory-Idle_Info_02", "Laboratory has Stopped"))
		;CloseWindow("CloseLab")
		ClickAway()
		;========Show Red  Hide Green  Hide Gray=====
		GUICtrlSetState($g_hPicPetGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;============================================
		;CloseWindow("CloseLab")
		ClickAway()
		$g_sPetUpgradeTime = ""
		;If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
		Return
	Else
		SetLog("Unable to determine Pet House Status", $COLOR_INFO)
		;CloseWindow("CloseLab")
		ClickAway()
		;========Hide Red  Hide Green  Show Gray======
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;=============================================
		Return
	EndIf

EndFunc   ;==>PetGuiDisplay

Func GetMinDark4PetUpgrade()
	Local $iPetUnlockedxCoord[4] = [190, 345, 500, 655]
	Local $iPetLevelxCoord[4] = [134, 288, 443, 598]
	Local $iMinDark4PetUpgrade = 999999

	For $i = 0 to $ePetCount - 1
		; check if pet upgrade enabled and unlocked ; c3b6a5 nox c1b7a5 memu?
		If _ColorCheck(_GetPixelColor($iPetUnlockedxCoord[$i], 415, True), Hex(0xc3b6a5, 6), 20) Then

			; get the Pet Level
			Local $iPetLevel = getTroopsSpellsLevel($iPetLevelxCoord[$i], 533)
			SetLog($g_asPetNames[$i] & " is at level " & $iPetLevel)

			If _Sleep($DELAYLABORATORY2) Then Return

			; get DE requirement to upgrade Pet
			Local $iDarkElixirReq = 1000 * number($g_aiPetUpgradeCostPerLevel[$i][$iPetLevel])

			SetLog("DE Requirement: " & $iDarkElixirReq)

			If $iDarkElixirReq < $iMinDark4PetUpgrade Then
				$iMinDark4PetUpgrade = $iDarkElixirReq
				SetLog("New Min Dark: " & $iMinDark4PetUpgrade)
			EndIf
		EndIf
	Next

	Return $iMinDark4PetUpgrade
EndFunc