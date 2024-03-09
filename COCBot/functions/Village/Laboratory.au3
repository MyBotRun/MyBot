; #FUNCTION# ====================================================================================================================
; Name ..........: Laboratory
; Description ...:
; Syntax ........: Laboratory()
; Parameters ....:
; Return values .: None
; Author ........: summoner
; Modified ......: KnowJack (06/2015), Sardo (08/2015), Monkeyhunter(04/2016), MMHK(06/2018), Chilly-Chill (12/2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Local $iSlotWidth = 108, $iDistBetweenSlots = 14 ; use for logic to upgrade troops.. good for generic-ness
Local $iYMidPoint = 480 ;Space between rows in lab screen.  CHANGE ONLY WITH EXTREME CAUTION.
Local $iPicsPerPage = 12, $iPages = 4 ; used to know exactly which page the users choice is on
Local $sLabTroopsSection = "70,365,795,600"
Local $sLabTroopsSectionDiam = GetDiamondFromRect($sLabTroopsSection)

Func TestLaboratory()
	Local $bWasRunState = $g_bRunState
	Local $sWasLabUpgradeTime = $g_sLabUpgradeTime
	Local $sWasLabUpgradeEnable = $g_bAutoLabUpgradeEnable
	$g_bRunState = True
	$g_bAutoLabUpgradeEnable = True
	$g_sLabUpgradeTime = ""
	$g_bSilentSetDebugLog = False
	Local $Result = Laboratory(True)
	$g_bRunState = $bWasRunState
	$g_sLabUpgradeTime = $sWasLabUpgradeTime
	$g_bAutoLabUpgradeEnable = $sWasLabUpgradeEnable
	Return $Result
EndFunc   ;==>TestLaboratory

Func Laboratory($debug = False)

	If Not $g_bAutoLabUpgradeEnable Then Return ; Lab upgrade not enabled.

	If $g_iTownHallLevel < 3 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Lab.", $COLOR_ERROR)
		Return
	EndIf

	If $g_aiLaboratoryPos[0] = 0 Or $g_aiLaboratoryPos[1] = 0 Then
		SetLog("Laboratory Location unknown!", $COLOR_WARNING)
		LocateLab() ; Lab location unknown, so find it.
		If $g_aiLaboratoryPos[0] = 0 Or $g_aiLaboratoryPos[1] = 0 Then
			SetLog("Problem locating Laboratory, re-locate laboratory position before proceeding", $COLOR_ERROR)
			Return False
		EndIf
	EndIf

	If ChkUpgradeInProgress() Then Return False  ; see if we know about an upgrade in progress without checking the lab

	; Get updated village elixir and dark elixir values
	VillageReport()

	If UBound(decodeSingleCoord(FindImageInPlace2("GobBuilder", $g_sImgGobBuilder, 240, 0, 450, 60, True))) > 1 Then
		$GobBuilderPresent = True
		$GobBuilderOffsetRunning = 355
	Else
		$GobBuilderPresent = False
		$GobBuilderOffsetRunning = 0
	EndIf

	;Click Laboratory
	BuildingClickP($g_aiLaboratoryPos, "#0197")
	If _Sleep($DELAYLABORATORY5) Then Return ; Wait for window to open

	If Not FindResearchButton() Then Return False ; cant start because we cannot find the research button

	If ChkLabUpgradeInProgress() Then
		CloseWindow()
		Return False ; cant start if something upgrading
	EndIf

	; Lab upgrade is not in progress and not upgreading, so we need to start an upgrade.
	Local $iCurPage = 1
	Local $sCostResult
	Global $bUserChoice = False

	; user made a specific choice of lab upgrade
	If $g_iCmbLaboratory <> 0 Then
		SetDebugLog("User picked to upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0])
		Local $iPage = Ceiling($g_iCmbLaboratory / $iPicsPerPage) ; page # of user choice
		While ($iCurPage < $iPage) ; go directly to the needed page
			LabNextPage($iCurPage, $iPages, $iYMidPoint) ; go to next page of upgrades
			$iCurPage += 1 ; Next page
			If _Sleep(2000) Then Return
		WEnd
		SetDebugLog("On page " & $iCurPage & " of " & $iPages)
		; Get coords of upgrade the user wants
		Local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
		Local $aCoords, $bUpgradeFound = False
		If UBound($aPageUpgrades, 1) >= 1 Then ; if we found any troops
			For $i = 0 To UBound($aPageUpgrades, 1) - 1 ; Loop through found upgrades
				Local $aTempTroopArray = $aPageUpgrades[$i] ; Declare Array to Temp Array

				If $aTempTroopArray[0] = $g_avLabTroops[$g_iCmbLaboratory][2] Then ; if this is the file we want
					$aCoords = decodeSingleCoord($aTempTroopArray[1])
					$bUpgradeFound = True
					$bUserChoice = True
					ExitLoop
				EndIf
				If _Sleep($DELAYLABORATORY2) Then Return
			Next
		EndIf

		If Not $bUpgradeFound Then
			SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0] & " - Not available.", $COLOR_INFO)
			Return False
		EndIf

		$sCostResult = GetLabCostResult($aCoords) ; get cost of the upgrade

		If $sCostResult = "" Then ; not enough resources
			SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0] & " - Not enough Resources." & @CRLF & "We will try again later.", $COLOR_INFO)
			SetDebugLog("Coords: (" & $aCoords[0] & "," & $aCoords[1] & ")")
		ElseIf StringSplit($sCostResult, "1")[0] = StringLen($sCostResult) + 1 Or StringSplit($sCostResult, "1")[1] = "0" Then ; max level if all ones returned from ocr or if the first letter is a 0.
			SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0] & " - Max Level. Choose another upgrade.", $COLOR_INFO)
			SetDebugLog("Coords: (" & $aCoords[0] & "," & $aCoords[1] & ")")
		Else
			Return LaboratoryUpgrade($g_avLabTroops[$g_iCmbLaboratory][0], $aCoords, $sCostResult, $debug) ; return whether or not we successfully upgraded
		EndIf
		If _Sleep($DELAYLABORATORY2) Then Return
		;ClickAway()
		CloseWindow()

	Else ; users choice is any upgrade
		While ($iCurPage <= $iPages)
			SetDebugLog("User picked any upgrade.")
			Local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
			If UBound($aPageUpgrades, 1) >= 1 Then ; if we found any troops
				SetDebugLog("Found " & UBound($aPageUpgrades, 1) & " possible on this page #" & $iCurPage)
				For $i = 0 To UBound($aPageUpgrades, 1) - 1 ; Loop through found upgrades
					Local $aTempTroopArray = $aPageUpgrades[$i] ; Declare Array to Temp Array

					; find image slot that we found so that we can read the cost to see if we can upgrade it... slots read 1-12 top to bottom so barb = 1, arch = 2, giant = 3, etc...
					Local $aCoords = decodeSingleCoord($aTempTroopArray[1])
					$sCostResult = GetLabCostResult($aCoords) ; get cost of the current upgrade option

					If $sCostResult = "" Then ; not enough resources
						SetDebugLog("Lab Upgrade " & $aTempTroopArray[0] & " - Not enough Resources")
					ElseIf StringSplit($sCostResult, "1")[0] = StringLen($sCostResult) + 1 Or StringSplit($sCostResult, "1")[1] = "0" Then ; max level if all ones returned from ocr or if the first letter is a 0.
						SetDebugLog("Lab Upgrade " & $aTempTroopArray[0] & " - Max Level")
					Else
						Return LaboratoryUpgrade($aTempTroopArray[0], $aCoords, $sCostResult, $debug) ; return whether or not we successfully upgraded
					EndIf
					If _Sleep($DELAYLABORATORY2) Then Return
				Next
			EndIf

			LabNextPage($iCurPage, $iPages, $iYMidPoint) ; go to next page of upgrades
			$iCurPage += 1 ; Next page
			If _Sleep($DELAYLABORATORY2) Then Return
		WEnd

		; If We got to here without returning, then nothing available for upgrade
		SetLog("Nothing available for upgrade at the moment, try again later.")
		;ClickAway()
		CloseWindow()
	EndIf

	Return False ; No upgrade started
EndFunc   ;==>Laboratory

; start a given upgrade
Func LaboratoryUpgrade($name, $aCoords, $sCostResult, $debug = False)
	SetLog("Selected upgrade: " & $name & " Cost: " & _NumberFormat($sCostResult, True), $COLOR_INFO)
	ClickP($aCoords) ; click troop
	If _Sleep(2000) Then Return

	If Not (SetLabUpgradeTime($name)) Then
		SetDebugLog("Couldn't read upgrade time.  Continue anyway.", $COLOR_ERROR)
	EndIf
	If _Sleep($DELAYLABUPGRADE1) Then Return

	LabStatusGUIUpdate()
	If $debug = True Then ; if debugging, do not actually click it
		SetLog("[debug mode] - Start Upgrade, Click (" & 630 & "," & 565 + $g_iMidOffsetY & ")", $COLOR_ACTION)
		CloseWindow()
		Return True ; return true as if we really started an upgrade
	Else
		Click(630, 545 + $g_iMidOffsetY, 1, 0, "#0202") ; Everything is good - Click the upgrade button
		If isGemOpen(True) = False Then ; check for gem window
			; success
			SetLog("Upgrade " & $name & " in your laboratory started with success...", $COLOR_SUCCESS)
			;If doing a user specific upgrade, set to "any" for next time.
			;Bad if user wanted to upgrade it multiple levels.
			If $bUserChoice Then
				SetLog("Clearing user's upgrade choice.", $COLOR_INFO)
				;HArchH Set the global that gets saved to building.ini
				$g_iCmbLaboratory = 0 ;Set global
				_GUICtrlComboBox_SetCurSel($g_hCmbLaboratory, $g_iCmbLaboratory) ;Apply to the GUI in case it gets saved again.
				_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibIconPath, $g_avLabTroops[$g_iCmbLaboratory][1]) ; Set the corresponding image.
				SaveBuildingConfig() ;Try to save for the future.
			EndIf
			If _Sleep(350) Then Return
			ClickAway()
			If _Sleep(1000) Then Return
			PushMsg("LabSuccess")
			ChkLabUpgradeInProgress($name)
			If _Sleep($DELAYLABUPGRADE2) Then Return
			CloseWindow()
			Return True ; upgrade started
		Else
			SetLog("Oops, Gems required for " & $name & " Upgrade, try again.", $COLOR_ERROR)
			Return False
		EndIf
	EndIf
EndFunc   ;==>LaboratoryUpgrade

; get the time for the selected upgrade
Func SetLabUpgradeTime($sTrooopName)
	Local $Result = getLabUpgradeTime2(730, 544 + $g_iMidOffsetY) ; Try to read white text showing time for upgrade
	Local $iLabFinishTime = ConvertOCRTime("Lab Time", $Result, False)
	SetDebugLog($sTrooopName & " Upgrade OCR Time = " & $Result & ", $iLabFinishTime = " & $iLabFinishTime & " m", $COLOR_INFO)
	Local $StartTime = _NowCalc() ; what is date:time now
	SetDebugLog($sTrooopName & " Upgrade Started @ " & $StartTime, $COLOR_SUCCESS)
	If $iLabFinishTime > 0 Then
		$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), $StartTime)
		SetLog($sTrooopName & " Upgrade Finishes @ " & $Result & " (" & $g_sLabUpgradeTime & ")", $COLOR_SUCCESS)
		$g_iLaboratoryElixirCost = 0
		$g_iLaboratoryDElixirCost = 0
	Else
		SetLog("Error processing upgrade time required, try again!", $COLOR_WARNING)
		Return False
	EndIf
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
	Return True ; success
EndFunc   ;==>SetLabUpgradeTime

; get the cost of an upgrade based on its coords
; find image slot that we found so that we can read the cost to see if we can upgrade it... slots read 1-12 top to bottom so barb = 1, arch = 2, giant = 3, etc...
Func GetLabCostResult($aCoords)
	SetDebugLog("Getting lab cost.")
	SetDebugLog("$iYMidPoint=" & $iYMidPoint)
	Local $iCurSlotOnPage, $iCurSlotsToTheRight, $sCostResult
	$iCurSlotsToTheRight = Ceiling((Int($aCoords[0]) - Int(StringSplit($sLabTroopsSection, ",")[1])) / ($iSlotWidth + $iDistBetweenSlots))
	If Int($aCoords[1]) < $iYMidPoint Then ; first row
		SetDebugLog("First row.")
		$iCurSlotOnPage = 2 * $iCurSlotsToTheRight - 1
		SetDebugLog("$iCurSlotOnPage=" & $iCurSlotOnPage)
		$sCostResult = getLabUpgrdResourceWhtNew(Int(StringSplit($sLabTroopsSection, ",")[1]) + ($iCurSlotsToTheRight - 1) * ($iSlotWidth + $iDistBetweenSlots) + 4, 420 + $g_iMidOffsetY)
		If $sCostResult = "" Then
			Local $XCoord = Int(StringSplit($sLabTroopsSection, ",")[1]) + ($iCurSlotsToTheRight - 1) * ($iSlotWidth + $iDistBetweenSlots) + 4
			Local $YCoord = 420 + $g_iMidOffsetY
			If QuickMIS("BC1", $g_sImgElixirDrop, $XCoord + 77, $YCoord - 4, $XCoord + 110, $YCoord + 18) Then
				Local $g_iLaboratoryElixirCostOld = $g_iLaboratoryElixirCost
				Local $g_iLaboratoryElixirCostNew = getLabUpgrdResourceRed($XCoord, $YCoord)
				If $g_iLaboratoryElixirCostNew <= $g_iLaboratoryElixirCostOld Or $g_iLaboratoryElixirCostOld = 0 Then $g_iLaboratoryElixirCost = $g_iLaboratoryElixirCostNew
			Else
				Local $g_iLaboratoryDElixirCostOld = $g_iLaboratoryDElixirCost
				Local $g_iLaboratoryDElixirCostNew = getLabUpgrdResourceRed($XCoord, $YCoord)
				If $g_iLaboratoryDElixirCostNew <= $g_iLaboratoryDElixirCostOld Or $g_iLaboratoryDElixirCostOld = 0 Then $g_iLaboratoryDElixirCost = $g_iLaboratoryDElixirCostNew
			EndIf
		EndIf
	Else ; second row
		SetDebugLog("Second row.")
		$iCurSlotOnPage = 2 * $iCurSlotsToTheRight
		SetDebugLog("$iCurSlotOnPage=" & $iCurSlotOnPage)
		$sCostResult = getLabUpgrdResourceWhtNew(Int(StringSplit($sLabTroopsSection, ",")[1]) + ($iCurSlotsToTheRight - 1) * ($iSlotWidth + $iDistBetweenSlots) + 4, 543 + $g_iMidOffsetY)
		If $sCostResult = "" Then
			Local $XCoord = Int(StringSplit($sLabTroopsSection, ",")[1]) + ($iCurSlotsToTheRight - 1) * ($iSlotWidth + $iDistBetweenSlots) + 4
			Local $YCoord = 543 + $g_iMidOffsetY
			If QuickMIS("BC1", $g_sImgElixirDrop, $XCoord + 77, $YCoord - 4, $XCoord + 110, $YCoord + 18) Then
				Local $g_iLaboratoryElixirCostOld = $g_iLaboratoryElixirCost
				Local $g_iLaboratoryElixirCostNew = getLabUpgrdResourceRed($XCoord, $YCoord)
				If $g_iLaboratoryElixirCostNew <= $g_iLaboratoryElixirCostOld Or $g_iLaboratoryElixirCostOld = 0 Then $g_iLaboratoryElixirCost = $g_iLaboratoryElixirCostNew
			Else
				Local $g_iLaboratoryDElixirCostOld = $g_iLaboratoryDElixirCost
				Local $g_iLaboratoryDElixirCostNew = getLabUpgrdResourceRed($XCoord, $YCoord)
				If $g_iLaboratoryDElixirCostNew <= $g_iLaboratoryDElixirCostOld Or $g_iLaboratoryDElixirCostOld = 0 Then $g_iLaboratoryDElixirCost = $g_iLaboratoryDElixirCostNew
			EndIf
		EndIf
	EndIf
	SetDebugLog("Cost found is " & $sCostResult)
	Return $sCostResult
EndFunc   ;==>GetLabCostResult

; "-50" to avoid the white triangle.
Func LabNextPage($iCurPage, $iPages, $iYMidPoint)
	If $iCurPage >= $iPages Then Return ; nothing left to scroll
	SetDebugLog("Drag to next full page.")
	ClickDrag(720, $iYMidPoint - 50, 83, $iYMidPoint, 300)
EndFunc   ;==>LabNextPage

; check the lab to see if something is upgrading in the lab already
Func ChkLabUpgradeInProgress($name = "")
	; check for upgrade in process - look for green in finish upgrade with gems button
	SetDebugLog("_GetPixelColor(X, Y): " & _GetPixelColor(775 - $GobBuilderOffsetRunning, 135 + $g_iMidOffsetY, True) & ":A1CA6B", $COLOR_DEBUG)
	If _ColorCheck(_GetPixelColor(775 - $GobBuilderOffsetRunning, 135 + $g_iMidOffsetY, True), Hex(0xA1CA6B, 6), 20) Then ; Look for light green in upper right corner of lab window.
		SetLog("Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		If _Sleep($DELAYLABORATORY2) Then Return
		; upgrade in process and time not recorded so update completion time!
		If $GobBuilderPresent Then
			Local $sLabTimeOCR = getRemainTLaboratoryGob(210, 190 + $g_iMidOffsetY)
		Else
			Local $sLabTimeOCR = getRemainTLaboratory2(250, 210 + $g_iMidOffsetY)
		EndIf
		Local $iLabFinishTime = ConvertOCRTime("Lab Time", $sLabTimeOCR, False) + 1
		SetDebugLog("$sLabTimeOCR: " & $sLabTimeOCR & ", $iLabFinishTime = " & $iLabFinishTime & " m")
		If $iLabFinishTime > 0 Then
			$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), _NowCalc())
			If @error Then _logErrorDateAdd(@error)
			SetLog("Research will finish in " & $sLabTimeOCR & " (" & $g_sLabUpgradeTime & ")")
			$g_iLaboratoryElixirCost = 0
			$g_iLaboratoryDElixirCost = 0
			LabStatusGUIUpdate() ; Update GUI flag
		ElseIf $g_bDebugSetlog Then
			SetLog("Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
		EndIf
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
		Return True
	EndIf
	Return False ; returns False if no upgrade in progress
EndFunc   ;==>ChkLabUpgradeInProgress

; checks our global variable to see if we know of something already upgrading
Func ChkUpgradeInProgress()
	Local $TimeDiff ; time remaining on lab upgrade
	If $g_sLabUpgradeTime <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $g_sLabUpgradeTime) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)
	SetDebugLog($g_avLabTroops[$g_iCmbLaboratory][0] & " Lab end time: " & $g_sLabUpgradeTime & ", DIFF= " & $TimeDiff, $COLOR_DEBUG)

	If Not $g_bRunState Then Return
	If $TimeDiff <= 0 Then
		SetLog("Checking Troop Upgrade in Laboratory ...", $COLOR_INFO)
	Else
		SetLog("Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		$g_iLaboratoryElixirCost = 0
		$g_iLaboratoryDElixirCost = 0
		Return True
	EndIf
	Return False ; we currently do not know of any upgrades in progress
EndFunc   ;==>ChkUpgradeInProgress

; Find Research Button
Func FindResearchButton()
	Local $aResearchButton = findButton("Research", Default, 1, True)
	If IsArray($aResearchButton) And UBound($aResearchButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("LabUpgrade") ; Debug Only
		ClickP($aResearchButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
		Return True
	Else
		SetLog("Cannot find the Laboratory Research Button!", $COLOR_ERROR)
		ClickAway()
		Return False
	EndIf
EndFunc   ;==>FindResearchButton
