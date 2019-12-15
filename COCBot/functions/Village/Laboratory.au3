; #FUNCTION# ====================================================================================================================
; Name ..........: Laboratory
; Description ...:
; Syntax ........: Laboratory()
; Parameters ....:
; Return values .: None
; Author ........: summoner
; Modified ......: KnowJack (06/2015), Sardo (08/2015), Monkeyhunter(04/2016), MMHK(06/2018), Chilly-Chill (12/2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func TestLaboratory()
	Local $bWasRunState = $g_bRunState
	Local $sWasLabUpgradeTime = $g_sLabUpgradeTime
	Local $sWasLabUpgradeEnable = $g_bAutoLabUpgradeEnable
	$g_bRunState = True
	$g_bAutoLabUpgradeEnable = True
	$g_sLabUpgradeTime = ""
	Local $Result = Laboratory(True)
	$g_bRunState = $bWasRunState
	$g_sLabUpgradeTime = $sWasLabUpgradeTime
	$g_bAutoLabUpgradeEnable = $sWasLabUpgradeEnable
	Return $Result
EndFunc

Func Laboratory($debug=False)

	Local $TimeDiff ; time remaining on lab upgrade
	Local $iSlotWidth = 94, $iDistBetweenSlots = 12, $iYMidPoint = 472; use for logic to upgrade troops.. good for generic-ness
	Local $iPicsPerPage = 12, $iPages = 4 ; use to know exactly which page the users choice is on
	Local $sLabWindow = "99,122,760,616", $sLabTroopsSection = "115,363,750,577"
	Local $sLabWindowDiam = GetDiamondFromRect($sLabWindow), $sLabTroopsSectionDiam = GetDiamondFromRect($sLabTroopsSection) ; easy to change search areas

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

 	If ChkUpgradeInProgress() Then Return False ; see if we know about an upgrade in progress without checking the lab

	; Get updated village elixir and dark elixir values
	VillageReport()

	;Click Laboratory
	BuildingClickP($g_aiLaboratoryPos, "#0197")
	If _Sleep($DELAYLABORATORY3) Then Return ; Wait for window to open

	If Not FindResearchButton() Then Return False ; cant start becuase we cannot find the research button

	If ChkLabUpgradeInProgress() Then Return False ; cant start if something upgrading

	; Lab upgrade is not in progress and not upgreading, so we need to start an upgrade.
	Local $iCurPage = 1
	Local $sCostResult

	; user made a specific choice of lab upgrade
	If $g_iCmbLaboratory <> 0 Then
		Local $iPage = Ceiling($g_iCmbLaboratory / $iPicsPerPage) ; page # of user choice
		While($iCurPage < $iPage) ; go directly to the needed page
			LabNextPage($iCurPage, $iPages, $iYMidPoint) ; go to next page of upgrades
			$iCurPage += 1 ; Next page
			If _Sleep(2000) Then Return
		WEnd

		; get cost and coords from image slot
		Local $iSlotsToTheRight = Ceiling(( $g_iCmbLaboratory - 12*($iPage-1) ) / 2); we only want to know how many to the right we are, 1-12 counting top to bottom... ex. Page 1) barb = 1, arch = 2 giant = 3 etc...
		Local $aCoords[2] ; coords to actually click slot
		If $iPage = $iPages Then ; we are on last page... so we are looking at only 1 extra colummn which we did on the click drag... this will need to be fixed as more columns of troops are added to page 4
			If Mod($g_iCmbLaboratory, 2) = 0 Then ; we are on second row
				$sCostResult = getLabUpgrdResourceWht( Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iSlotsToTheRight-1 + 5)*($iSlotWidth + $iDistBetweenSlots),  $iYMidPoint + 76) ; +5 columns we need to complete page 4.. so change this as more columns are added after SiegeB col
				$aCoords[0] = Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iSlotsToTheRight-1 + 5)*($iSlotWidth + $iDistBetweenSlots) + 48; add [48,-30] to Coords to be looking in middle of image now... slightly right and up
				$aCoords[1] = $iYMidPoint + 76 - 30
			Else ; first row
				$sCostResult = getLabUpgrdResourceWht( Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iSlotsToTheRight-1 + 5)*($iSlotWidth + $iDistBetweenSlots),  Int(StringSplit($sLabTroopsSection, ",")[2]) + 76); +5 columns we need to complete page 4.. so change this as more columns are added after SiegeB col
				$aCoords[0] = Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iSlotsToTheRight-1 + 5)*($iSlotWidth + $iDistBetweenSlots) + 48; add [48,30] to Coords to be looking in middle of image now
				$aCoords[1] = Int(StringSplit($sLabTroopsSection, ",")[2]) + 76 - 30
			EndIf
		Else ; we are not on last page... so we are looking at only 1 extra colummn which we did on the click drag... this will need to be fixed as more columns of troops are added to page 4
			If Mod($g_iCmbLaboratory, 2) = 0 Then ; we are on second row
				$sCostResult = getLabUpgrdResourceWht( Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iSlotsToTheRight-1)*($iSlotWidth + $iDistBetweenSlots),  $iYMidPoint + 76)
				$aCoords[0] = Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iSlotsToTheRight-1)*($iSlotWidth + $iDistBetweenSlots) + 48; add [48,-30] to Coords to be looking in middle of image now... slightly right and up
				$aCoords[1] = $iYMidPoint + 76 - 30
			Else ; first row
				$sCostResult = getLabUpgrdResourceWht( Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iSlotsToTheRight-1)*($iSlotWidth + $iDistBetweenSlots),  Int(StringSplit($sLabTroopsSection, ",")[2]) + 76)
				$aCoords[0] = Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iSlotsToTheRight-1)*($iSlotWidth + $iDistBetweenSlots) + 48; add [48,30] to Coords to be looking in middle of image now
				$aCoords[1] = Int(StringSplit($sLabTroopsSection, ",")[2]) + 76 - 30
			EndIf
		EndIf

		If $sCostResult = "" Then ; not enough resources
			SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][3] & " - Not enough Resources. We will try again later.", $COLOR_INFO)
			If $g_bDebugSetlog Then SetDebugLog("Coords: (" & $aCoords[0] & "," & $aCoords[1] & ")")
		ElseIf StringSplit($sCostResult, "1")[0] = StringLen($sCostResult)+1 Then ; max level... all ones returned from ocr
			SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][3] & " - Max Level. Please choose another upgrade.", $COLOR_INFO)
			If $g_bDebugSetlog Then SetDebugLog("Coords: (" & $aCoords[0] & "," & $aCoords[1] & ")")
		Else
			Return LaboratoryUpgrade($g_avLabTroops[$g_iCmbLaboratory][3], $aCoords, $sCostResult, $debug) ; return whether or not we successfully upgraded
		EndIf
		If _Sleep($DELAYLABORATORY2) Then Return
		ClickP($aAway, 2, 0, "#0204")

	Else ; users choice is any upgrade
		While($iCurPage < $iPages)
			local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
			If UBound($aPageUpgrades, 1) >= 1 Then ; if we found any troops
				For $i = 0 To UBound($aPageUpgrades, 1) - 1 ; Loop through found upgrades
					Local $aTempTroopArray = $aPageUpgrades[$i] ; Declare Array to Temp Array

					; find image slot that we found so that we can read the cost to see if we can upgrade it... slots read 1-12 top to bottom so barb = 1, arch = 2, giant = 3, etc...
					Local $iCurSlotOnPage, $iCurSlotsToTheRight
					Local $aCoords = decodeSingleCoord($aTempTroopArray[1])
					$iCurSlotsToTheRight = Ceiling( ( Int($aCoords[0]) - Int(StringSplit($sLabTroopsSection, ",")[1]) ) / ($iSlotWidth + $iDistBetweenSlots) )
					If Int($aCoords[1]) < $iYMidPoint Then ; first row
						$iCurSlotOnPage = 2*$iCurSlotsToTheRight - 1
						$sCostResult = getLabUpgrdResourceWht( Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iCurSlotsToTheRight-1)*($iSlotWidth + $iDistBetweenSlots),  Int(StringSplit($sLabTroopsSection, ",")[2]) + 76)
					Else; second row
						$iCurSlotOnPage = 2*$iCurSlotsToTheRight
						$sCostResult = getLabUpgrdResourceWht( Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iCurSlotsToTheRight-1)*($iSlotWidth + $iDistBetweenSlots),  $iYMidPoint + 76)
					EndIf

					If $sCostResult = "" Then ; not enough resources
						If $g_bDebugSetlog Then SetDebugLog("Lab Upgrade " & $aTempTroopArray[0] & " - Not enough Resources")
					ElseIf StringSplit($sCostResult, "1")[0] = StringLen($sCostResult)+1 Then ; max level... all ones returned from ocr
							If $g_bDebugSetlog Then SetDebugLog("Lab Upgrade " & $aTempTroopArray[0] & " - Max Level")
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
		ClickP($aAway, 2, 0, "#0204")
	EndIf

	Return False ; No upgrade started
EndFunc

; start a given upgrade
Func LaboratoryUpgrade($name, $aCoords, $sCostResult, $debug = False)
	SetLog("Selected upgrade: " & $name & " Cost: " & $sCostResult, $COLOR_INFO)
	ClickP($aCoords) ; click troop
	If _Sleep(2000) Then Return

	If Not(SetLabUpgradeTime($name)) Then
		ClickP($aAway, 2, $DELAYLABUPGRADE3, "#0360")
		Return False ; couldnt set time to upgrade started
	EndIf
	If _Sleep($DELAYLABUPGRADE1) Then Return

	LabStatusGUIUpdate()
	If $debug = True Then ; if debugging, do not actually click it
		SetLog("[debug mode] - Start Upgrade, Click (" & 660 & "," & 520 + $g_iMidOffsetY & ")", $COLOR_ACTION)
		ClickP($aAway, 2, 0, "#0204")
		Return True ; return true as if we really started an upgrade
	Else
		Click(660, 520 + $g_iMidOffsetY, 1, 0, "#0202") ; Everything is good - Click the upgrade button
		If isGemOpen(True) = False Then ; check for gem window
			; check for green button to use gems to finish upgrade, checking if upgrade actually started
			If Not (_ColorCheck(_GetPixelColor(625, 218 + $g_iMidOffsetY, True), Hex(0x6fbd1f, 6), 15) Or _ColorCheck(_GetPixelColor(660, 218 + $g_iMidOffsetY, True), Hex(0x6fbd1f, 6), 15)) Then
				SetLog("Something went wrong with " & $name & " Upgrade, try again.", $COLOR_ERROR)
				ClickP($aAway, 2, $DELAYLABUPGRADE3, "#0360")
				Return False
			EndIf

			; success
			SetLog("Upgrade " & $name & " in your laboratory started with success...", $COLOR_SUCCESS)
			PushMsg("LabSuccess")
			If _Sleep($DELAYLABUPGRADE2) Then Return
			ClickP($aAway, 2, 0, "#0204")
			Return True ; upgrade started
		Else
			SetLog("Oops, Gems required for " & $name & " Upgrade, try again.", $COLOR_ERROR)
			Return False
		EndIf
	EndIf
EndFunc

; get the time for the selected upgrade
Func SetLabUpgradeTime($sTrooopName)
	Local $Result = getLabUpgradeTime(581, 495) ; Try to read white text showing time for upgrade
	Local $iLabFinishTime = ConvertOCRTime("Lab Time", $Result, False)
	SetLog($sTrooopName & " Upgrade OCR Time = " & $Result & ", $iLabFinishTime = " & $iLabFinishTime & " m", $COLOR_INFO)
	Local $StartTime = _NowCalc() ; what is date:time now
	If $g_bDebugSetlog Then SetDebugLog($sTrooopName & " Upgrade Started @ " & $StartTime, $COLOR_SUCCESS)
	If $iLabFinishTime > 0 Then
		$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), $StartTime)
		SetLog($sTrooopName & " Upgrade Finishes @ " & $Result & " (" & $g_sLabUpgradeTime & ")", $COLOR_SUCCESS)
	Else
		SetLog("Error processing upgrade time required, try again!", $COLOR_WARNING)
		Return False
	EndIf
	Return True ; success
EndFunc

; if we are on last page, smaller clickdrag... for future dev: this is whatever is enough distance to move 6 off to the left and have the next page similarily aligned
Func LabNextPage($iCurPage, $iPages, $iYMidPoint)
	If $iCurPage >= $iPages Then Return ; nothing left to scroll
	If $iCurPage = $iPages-1 Then ; last page
		ClickDrag(720, $iYMidPoint, 600, $iYMidPoint)
	Else
		ClickDrag(720, $iYMidPoint, 85, $iYMidPoint)
	EndIf
EndFunc

; check the lab to see if something is upgrading in the lab already
Func ChkLabUpgradeInProgress()
	; check for upgrade in process - look for green in finish upgrade with gems button
	If $g_bDebugSetlog Then SetLog("_GetPixelColor(730, 200): " & _GetPixelColor(730, 200, True) & ":A2CB6C", $COLOR_DEBUG)
	If _ColorCheck(_GetPixelColor(730, 200, True), Hex(0xA2CB6C, 6), 20) Then
		SetLog("Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		If _Sleep($DELAYLABORATORY2) Then Return
		; upgrade in process and time not recorded so update completion time!
		Local $sLabTimeOCR = getRemainTLaboratory(270, 257)
		Local $iLabFinishTime = ConvertOCRTime("Lab Time", $sLabTimeOCR, False)
		SetDebugLog("$sLabTimeOCR: " & $sLabTimeOCR & ", $iLabFinishTime = " & $iLabFinishTime & " m")
		If $iLabFinishTime > 0 Then
			$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), _NowCalc())
			If @error Then _logErrorDateAdd(@error)
			SetLog("Research will finish in " & $sLabTimeOCR & " (" & $g_sLabUpgradeTime & ")")
			LabStatusGUIUpdate() ; Update GUI flag
		ElseIf $g_bDebugSetlog Then
			SetLog("Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
		EndIf
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0328")
		Return True
	EndIf
	Return False ; returns False if no upgrade in progress
EndFunc

; checks our global variable to see if we know of something already upgrading
Func ChkUpgradeInProgress()
	Local $TimeDiff ; time remaining on lab upgrade
	If $g_sLabUpgradeTime <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $g_sLabUpgradeTime) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)
	If $g_bDebugSetlog Then SetDebugLog($g_avLabTroops[$g_iCmbLaboratory][3] & " Lab end time: " & $g_sLabUpgradeTime & ", DIFF= " & $TimeDiff, $COLOR_DEBUG)

	If Not $g_bRunState Then Return
	If $TimeDiff <= 0 Then
		SetLog("Checking Troop Upgrade in Laboratory ...", $COLOR_INFO)
	Else
		SetLog("Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		Return True
	EndIf
	Return False ; we currently do not know of any upgrades in progress
EndFunc

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
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0199")
		Return False
	EndIf
EndFunc