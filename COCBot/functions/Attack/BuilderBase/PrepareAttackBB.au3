; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttackBB
; Description ...: This file controls attacking preperation of the builders base
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Chilly-Chill (04-2019)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;Global $g_bBBGoldFull = False
;Global $g_bBBElixirFull = False

Func CheckBBGoldStorageFull()
	Local $aBBGoldFull[4] = [710, 35, 0xDAB300, 10]

	SetLog("Gold   : 0x" & _GetPixelColor(710, 35, True))

	If _Sleep(500) Then Return
	
	If _CheckPixel($aBBGoldFull, True, Default, "BB Gold Full") Then
		SetLog("BB Gold Full")
		Return True
	EndIf

	Return False
EndFunc

Func CheckBBElixirStorageFull()
	Local $aBBElixirFull[4] = [710, 65, 0xB31AB3, 10]
	
	SetLog("Elixir : 0x" & _GetPixelColor(710, 65, True))
	
	If _Sleep(500) Then Return
	
	If _CheckPixel($aBBElixirFull, True, Default, "BB Elixir Full") Then
		SetLog("BB Elixir Full")
		Return True
	EndIf

	Return False
EndFunc

Func PrepareAttackBB($bClanGames = False)
	SetLog("Clan Games : " & $bClanGames)

	If Not CheckArmyReady() Then
		_Sleep(1500)		
		ClickAway()
		Return False
	EndIf

	$g_bBBMachineReady = CheckMachReady()
	
	If Not $bClanGames Then

		If $g_bChkBBTrophyRange Then
			If ($g_aiCurrentLootBB[$eLootTrophyBB] > $g_iTxtBBTrophyUpperLimit or $g_aiCurrentLootBB[$eLootTrophyBB] < $g_iTxtBBTrophyLowerLimit) Then
				SetLog("Trophies out of range.")
				SetDebugLog("Current Trophies: " & $g_aiCurrentLootBB[$eLootTrophyBB] & " Lower Limit: " & $g_iTxtBBTrophyLowerLimit & " Upper Limit: " & $g_iTxtBBTrophyUpperLimit)
				_Sleep(1500)
				Return False
			EndIf
		EndIf

		If $g_bChkBBAttIfLootAvail Then
			If Not CheckLootAvail() Then
				_Sleep(1500)
				ClickAway()
				Return False
			EndIf
		EndIf

		If $g_bChkBBHaltOnGoldFull Then
			If CheckBBGoldStorageFull() Then
				_Sleep(1500)
				Return False
			EndIf
		EndIf
		
		If $g_bChkBBHaltOnElixirFull Then
			If CheckBBElixirStorageFull() Then
				_Sleep(1500)
				Return False
			EndIf
		EndIf

		If $g_bChkBBWaitForMachine And Not $g_bBBMachineReady Then
			SetLog("Battle Machine is not ready.")
			_Sleep(1500)
			ClickAway()
			Return False
		EndIf

	EndIf
	
	Return True ; returns true if all checks succeed
EndFunc


Func CheckLootAvail()
	;local $aCoords = decodeSingleCoord(findImage("BBLootAvail_bmp", $g_sImgBBLootAvail, GetDiamondFromRect("210,622,658,721"), 1, True))
	local $bRet = False
	Local $sSearchDiamond = GetDiamondFromRect2(210, 592 + $g_iMidOffsetY, 658, 691 + $g_iMidOffsetY)
	Local $aCoords = decodeSingleCoord(findImage("BBLootAvail_bmp", $g_sImgBBLootAvail, $sSearchDiamond, 1, True))


	If Not $g_bRunState Then Return ; Stop Button
	
	If IsArray($aCoords) And UBound($aCoords) = 2 Then
		$bRet = True
		SetLog("Loot is Available.")
	Else
		SetLog("No loot available.")
		If $g_bDebugImageSave Then SaveDebugDiamondImage("CheckLootAvail", $sSearchDiamond)
	EndIf

	Return $bRet
EndFunc

Func CheckMachReady()
	;local $aCoords = decodeSingleCoord(findImage("BBMachReady_bmp", $g_sImgBBMachReady, GetDiamondFromRect("113,388,170,448"), 1, True))
	local $bRet = False
	Local $sSearchDiamond = GetDiamondFromRect2(113, 358 + $g_iMidOffsetY, 170, 418 + $g_iMidOffsetY)
	Local $aCoords = decodeSingleCoord(findImage("BBMachReady_bmp", $g_sImgBBMachReady, $sSearchDiamond, 1, True))

	If Not $g_bRunState Then Return ; Stop Button
	
	If IsArray($aCoords) And UBound($aCoords) = 2 Then
		$bRet = True
		SetLog("Battle Machine ready.")
	Else
		If $g_bDebugImageSave Then SaveDebugDiamondImage("CheckMachReady", $sSearchDiamond)
	EndIf

	Return $bRet
EndFunc

Func CheckArmyReady()
	local $i = 0
	local $bReady = True, $bNeedTrain = False, $bTraining = False
	;local $sSearchDiamond = GetDiamondFromRect("114,384,190,450") ; start of trained troops bar untill a bit after the 'r' "in Your Troops"
	Local $sSearchDiamond = GetDiamondFromRect2(114, 354 + $g_iMidOffsetY, 190, 420 + $g_iMidOffsetY) ; start of trained troops bar untill a bit after the 'r' "in Your Troops"


	If Not $g_bRunState Then Return ; Stop Button
	
	If _Sleep($DELAYCHECKFULLARMY2) Then Return False ; wait for window
	While $i < 6 And $bReady ; wait for fight preview window
		local $aNeedTrainCoords = decodeSingleCoord(findImage("NeedTrainBB", $g_sImgBBNeedTrainTroops, $sSearchDiamond, 1, True))
		local $aTroopsTrainingCoords = decodeSingleCoord(findImage("TroopsTrainingBB", $g_sImgBBTroopsTraining, $sSearchDiamond, 1, False)) ; shouldnt need to capture again as it is the same diamond

		If IsArray($aNeedTrainCoords) And UBound($aNeedTrainCoords) = 2 Then
			$bReady = False
			$bNeedTrain = True
		EndIf
		If IsArray($aTroopsTrainingCoords) And UBound($aTroopsTrainingCoords) = 2 Then
			$bReady = False
			$bTraining = True
		EndIf

		$i += 1
	WEnd
	
	If Not $g_bRunState Then Return ; Stop Button
		
	If Not $bReady Then
		SetLog("Army is not ready.")
		If $bTraining Then SetLog("Troops are training.")
		If $bNeedTrain Then SetLog("Troops need to be trained in the training tab.")
		If $g_bDebugImageSave Then SaveDebugImage("FindIfArmyReadyBB")
	Else
		SetLog("Army is ready.")
	EndIf

	Return $bReady
EndFunc
