; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttackBB
; Description ...: This file controls attacking preperation of the builders base
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Chilly-Chill (04-2019)
; Modified ......: Moebius14 (07-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckBBGoldStorageFull($SetLog = True)
	Local $aBBGoldFull[4] = [661, 35, 0xE7C00D, 10]
	If _Sleep(500) Then Return
	If _CheckPixel($aBBGoldFull, True, Default, "BB Gold Full") Then
		If $SetLog Then SetLog("BB Gold Full")
		Return True
	EndIf
	Return False
EndFunc   ;==>CheckBBGoldStorageFull

Func CheckBBElixirStorageFull($SetLog = True)
	Local $aBBElixirFull[4] = [661, 85, 0x7945C5, 10]
	If _Sleep(500) Then Return
	If _CheckPixel($aBBElixirFull, True, Default, "BB Elixir Full") Then
		If $SetLog Then SetLog("BB Elixir Full")
		Return True
	EndIf
	Return False
EndFunc   ;==>CheckBBElixirStorageFull

Func PrepareAttackBB($AttackCount = 0)

	If $g_bChkForceBBAttackOnClanGames And $g_bIsBBevent Then
		Setlog("Running Challenge is BB Challenge : " & $CurrentActiveChallenge, $COLOR_ACTION)
		SetLog("Force BB Attack on Clan Games Enabled", $COLOR_DEBUG2)
		SetLog("Attack, No Matter What !!", $COLOR_DEBUG2)
		CheckLootAvail()
		CheckBBGoldStorageFull()
		CheckBBElixirStorageFull()
		If $AttackCount = 0 Then CheckForSlots()
		If Not ClickAttack() Then Return False
		If _Sleep(1500) Then Return
		CheckArmyReady()
		CheckMachReady()
		Return True
	EndIf

	If Not $g_bRunState Then Return ; Stop Button

	If $g_bChkBBTrophyRange Then
		If ($g_aiCurrentLootBB[$eLootTrophyBB] > $g_iTxtBBTrophyUpperLimit Or $g_aiCurrentLootBB[$eLootTrophyBB] < $g_iTxtBBTrophyLowerLimit) Then
			SetLog("Trophies out of range.")
			SetDebugLog("Current Trophies: " & $g_aiCurrentLootBB[$eLootTrophyBB] & " Lower Limit: " & $g_iTxtBBTrophyLowerLimit & " Upper Limit: " & $g_iTxtBBTrophyUpperLimit)
			If _Sleep(1500) Then Return
			Return False
		EndIf
	EndIf

	If $g_bChkBBAttIfLootAvail Then
		If Not CheckLootAvail() Then
			If _Sleep(1500) Then Return
			ClickAway()
			Return False
		EndIf
	EndIf

	If $g_bChkBBHaltOnGoldFull Then
		If CheckBBGoldStorageFull() Then
			If _Sleep(1500) Then Return
			Return False
		EndIf
	EndIf

	If $g_bChkBBHaltOnElixirFull Then
		If CheckBBElixirStorageFull() Then
			If _Sleep(1500) Then Return
			Return False
		EndIf
	EndIf

	If $AttackCount = 0 Then CheckForSlots()

	If Not ClickAttack() Then Return False
	If _Sleep(1000) Then Return

	If Not CheckArmyReady() Then
		If _Sleep(1500) Then Return
		ClickAway()
		Return False
	EndIf

	$g_bBBMachineReady = CheckMachReady()
	If $g_bChkBBWaitForMachine And Not $g_bBBMachineReady Then
		SetLog("Battle Machine is not ready.")
		If _Sleep(1500) Then Return
		ClickAway()
		Return False
	EndIf

	Return True ; returns true if all checks succeed
EndFunc   ;==>PrepareAttackBB

Func CheckLootAvail($SetLog = True)
	Local $bRet = False, $iRemainStars = 0, $iMaxStars = 0
	Local $sStars = getOcrAndCapture("coc-BBAttackAvail", 40, 568 + $g_iBottomOffsetY, 50, 20)

	If $g_bDebugSetLog Then SetLog("Stars: " & $sStars, $COLOR_DEBUG2)
	If $sStars <> "" And StringInStr($sStars, "#") Then
		Local $aStars = StringSplit($sStars, "#", $STR_NOCOUNT)
		If IsArray($aStars) Then
			$iRemainStars = $aStars[0]
			$iMaxStars = $aStars[1]
		EndIf
		If Number($iRemainStars) <= Number($iMaxStars) Then
			If $SetLog Then SetLog("Remaining Stars : " & $iRemainStars & "/" & $iMaxStars, $COLOR_INFO)
			$bRet = True
		Else
			SetLog("All attacks used")
		EndIf
	EndIf
	Return $bRet
EndFunc   ;==>CheckLootAvail

Func CheckMachReady()
	Local $bRet = False
	If QuickMis("BC1", $g_sImgBBMachReady, 125, 275 + $g_iMidOffsetY, 180, 325 + $g_iMidOffsetY) Then
		$bRet = True
		SetLog("Battle Machine ready.")
	EndIf
	Return $bRet
EndFunc   ;==>CheckMachReady

Func CheckArmyReady()
	Local $i = 0
	Local $bReady = True, $bNeedTrain = False, $bTraining = False

	If _ColorCheck(_GetPixelColor(123, 245 + $g_iMidOffsetY, True), Hex(0xE84E52, 6), 20) Then
		SetLog("Army is not Ready", $COLOR_DEBUG)
		$bNeedTrain = True ;need train, so will train cannon cart
		$bReady = False
	EndIf

	If Not $bReady And $bNeedTrain Then
		SetLog("Train to Fill Army", $COLOR_INFO)
		ClickAway()
		If _Sleep(2000) Then Return
		ClickP($aArmyTrainButton, 1, 0, "BB Train Button")

		If _Sleep(1000) Then Return ; wait for window
		For $i = 1 To 5
			SetLog("Waiting for Army Window #" & $i, $COLOR_ACTION)
			If _Sleep(500) Then Return
			If QuickMis("BC1", $g_sImgGeneralCloseButton, 790, 120 + $g_iMidOffsetY, 835, 165 + $g_iMidOffsetY) Then ExitLoop
		Next

		Local $Camp = QuickMIS("CNX", $g_sImgFillCamp, 45, 210 + $g_iMidOffsetY, 800, 250 + $g_iMidOffsetY)
		For $i = 1 To UBound($Camp)
			If QuickMIS("BC1", $g_sImgFillTrain, 45, 390 + $g_iMidOffsetY, 800, 550 + $g_iMidOffsetY) Then
				Setlog("Fill ArmyCamp with : " & $g_iQuickMISName, $COLOR_DEBUG)
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(500) Then Return
			EndIf
		Next

		$Camp = QuickMIS("CNX", $g_sImgFillCamp, 45, 210 + $g_iMidOffsetY, 800, 250 + $g_iMidOffsetY)
		If UBound($Camp) > 0 Then
			$bReady = False
		Else
			$bReady = True
		EndIf

		ClickAway("Left")
		If _Sleep(1000) Then Return ; wait for window close
		ClickAttack()
	EndIf

	If Not $bReady Then
		SetLog("Army is not ready.")
	Else
		SetLog("Army is ready.")
	EndIf
	Return $bReady
EndFunc   ;==>CheckArmyReady

Func CheckForSlots()
	ClickP($aArmyTrainButton, 1, 0, "BB Train Button")
	If _Sleep(1000) Then Return
	Local $aDetectedSlots = QuickMIS("CNX", $g_sImgDirBBTroops, 45, 220 + $g_iMidOffsetY, 608, 310 + $g_iMidOffsetY)
	If IsArray($aDetectedSlots) And UBound($aDetectedSlots) > 0 Then
		If UBound($aDetectedSlots) < 5 Then
			$iStartSlotMem = 27
		Else
			$iStartSlotMem = 21
		EndIf
	Else
		$iStartSlotMem = 21
	EndIf
	Local $aDetectedSlotsR = QuickMIS("CNX", $g_sImgDirBBTroops, 608, 220 + $g_iMidOffsetY, 815, 310 + $g_iMidOffsetY)
	If IsArray($aDetectedSlotsR) And UBound($aDetectedSlotsR) > 0 Then
		If UBound($aDetectedSlots) + UBound($aDetectedSlotsR) < 5 Then
			$iStartSlotMem2 = 27
		Else
			$iStartSlotMem2 = 21
		EndIf
	Else
		$iStartSlotMem2 = $iStartSlotMem
	EndIf
	SetDebugLog("Total Troop Slots Detected : " & UBound($aDetectedSlots) + UBound($aDetectedSlotsR), $COLOR_DEBUG2)
	If _Sleep(1000) Then Return
	ClickAway("Left")
	If _Sleep(1000) Then Return ; wait for window close
EndFunc   ;==>CheckForSlots

Func ClickAttack()
	Local $sSearchDiamond = GetDiamondFromRect2(10, 560 + $g_iBottomOffsetY, 115, 660 + $g_iBottomOffsetY)
	Local $aCoords = decodeSingleCoord(findImage("ClickAttack", $g_sImgBBAttackButton, $sSearchDiamond, 1, True)) ; bottom
	Local $bRet = False

	If IsArray($aCoords) And UBound($aCoords) = 2 Then
		SetDebugLog(String($aCoords[0]) & " " & String($aCoords[1]))
		PureClick($aCoords[0], $aCoords[1]) ; Click Attack Button
		$bRet = True
	Else
		SetLog("Can not find button for Builders Base Attack button", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugDiamondImage("ClickAttack", $sSearchDiamond)
	EndIf

	Return $bRet
EndFunc   ;==>ClickAttack

Func ReturnHomeDropTrophyBB($bOnlySurender = False)
	SetLog("Returning Home", $COLOR_SUCCESS)

	For $i = 1 To 15
		Select
			Case IsBBAttackPage() = True
				Click(65, 540 + $g_iMidOffsetY) ;click surrender
				If _Sleep(1000) Then Return
			Case QuickMIS("BC1", $g_sImgBBReturnHome, 380, 510 + $g_iMidOffsetY, 480, 570 + $g_iMidOffsetY) = True
				If $bOnlySurender Then
					Return True
				EndIf
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(3000) Then Return
			Case QuickMIS("BC1", $g_sImgBBAttackBonus, 360, 450 + $g_iMidOffsetY, 500, 510 + $g_iMidOffsetY) = True
				SetLog("Congrats Chief, Stars Bonus Awarded", $COLOR_INFO)
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(2000) Then Return
				Return True
			Case isOnBuilderBase() = True
				Return True
			Case IsOKCancelPage() = True
				ClickOkay("BB Attack Surrender") ; Click Okay to Confirm surrender
				If _Sleep(1000) Then Return
		EndSelect
		If _Sleep(500) Then Return
	Next

	Return True
EndFunc   ;==>ReturnHomeDropTrophyBB
