; #FUNCTION# ====================================================================================================================
; Name ..........: UpgradeBM
; Description ...: Upgrade Battle Machine - based on UpgradeHeroes
; Author ........: GrumpyHog (2022-01)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015-2022
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Returns True or False
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================
Local $g_afDoubleCannonUpgCost[9] = [20, 50, 80, 300, 900, 1400, 2200, 3200, 4200]
Local $g_afArcherTowerUpgCost[9] = [12, 30, 60, 250, 800, 1200, 2000, 2800, 3600]
Local $g_afMultiMortarUpgCost[9] = [600, 700, 800, 1000, 1200, 1600, 2500, 3500, 4500]
Local $g_afMegaTeslaUpgCost[9] = [3000, 3100, 3200, 3300, 3400, 3600, 3800, 4000, 4800]

Func DoubleCannonUpgrade($test = False)

	SetLog("Upgrade Double Cannon")
	Local $aDoubleCannonLevel = 0

	If Not $test Then
		If Not $g_bDoubleCannonUpgrade Then Return

		; Master Builder is not available return
		If $g_iFreeBuilderCountBB = 0 Then
			SetLog("No Master Builder available! [" & $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB & "]", $COLOR_INFO)
			Return False
		EndIf
	EndIf

	ClickAway()
	SetLog("Saved Coord :" & $g_aiDoubleCannonPos[0] & ", " & $g_aiDoubleCannonPos[1], $COLOR_INFO)
	If _Sleep($DELAYUPGRADEHERO2) Then Return
	BuildingClickP($g_aiDoubleCannonPos) ;Click DoubleCannon Altar
	If _Sleep($DELAYUPGRADEHERO2) Then Return

	;Get Double Cannon info and Level
	Local $sInfo = BuildingInfo(242, 492 + $g_iBottomOffsetY)

	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 492 + $g_iBottomOffsetY)

		If @error Then SetError(0, 0, 0)
		Sleep(100)
		$CountGetInfo += 1
		If $CountGetInfo >= 50 Then Return
	WEnd
	If $g_bDebugSetlog Then SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
	If @error Then Return SetError(0, 0, 0)
	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "uble") = 0 Then
			SetLog("Bad Double Cannon location", $COLOR_ACTION)
			Return
		Else
			If $sInfo[2] <> "" Then
				$aDoubleCannonLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Your Double Cannon level read as: " & $aDoubleCannonLevel, $COLOR_SUCCESS)
				If $aDoubleCannonLevel >= 4 Then ; OTTO
					SetLog("Your Double Cannon is at level needed for OTTO upgrade!", $COLOR_INFO)
					$g_bDoubleCannonUpgrade = False ; turn Off the Double Cannon upgrade
					GUICtrlSetState($g_hChkDoubleCannonUpgrade, $GUI_UNCHECKED)						
					Return
				EndIf
			Else
				SetLog("Your Double Cannon Level was not found!", $COLOR_INFO)
				Return
			EndIf
		EndIf
	Else
		SetLog("Bad Double Cannon OCR", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	If $g_aiCurrentLootBB[$eLootGoldBB] < ($g_afDoubleCannonUpgCost[$aDoubleCannonLevel] * 1000) Then
		SetLog("Double Cannon Upg failed, require " & ($g_afDoubleCannonUpgCost[$aDoubleCannonLevel] * 1000) & " builder gold!", $COLOR_INFO)
		Return
	EndIf

	Local $aUpgradeButton = findButton("Upgrade", Default, 1, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2 Then
		If _Sleep($DELAYUPGRADEHERO2) Then Return
		ClickP($aUpgradeButton)
		If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open


		Local $sImgBBUpgradeWindow =  @ScriptDir & "\imgxml\Windows\BBUpgradeWindow*"
		Local $sSearchArea = "275,160,550,190"

		; check for storage full window
		If IsWindowOpen($sImgBBUpgradeWindow, 0, 0, GetDiamondFromRect($sSearchArea)) Then
			Local $aWhiteZeros = decodeSingleCoord(findImage("UpgradeWhiteZero" ,$g_sImgUpgradeWhiteZero, GetDiamondFromRect("408,519,747,606"), 1, True, Default))
			If IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2 Then
				ClickP($aWhiteZeros, 1, 0) ; Click upgrade buttton
				;ClickAway()
				If _Sleep($DELAYUPGRADEHERO1) Then Return

				; Just incase the buy Gem Window pop up!
				If isGemOpen(True) Then
					SetLog("Double Cannon Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
					ClickAway()
					Return False
				EndIf

				SetLog("Double Cannon Upgrade complete", $COLOR_SUCCESS)
				$g_iFreeBuilderCountBB -= 1
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
			Else
				SetLog("Double Cannon Upgrade Fail!", $COLOR_ERROR)
				If $g_bDebugImageSave Then SaveDebugImage("UpgradeDoubleCannon2")
				ClickAway()
				Return
			EndIf
		Else
			SetLog("Upgrade Double Cannon window open fail", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Upgrade Double Cannon error finding button", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDoubleCannon1")
	EndIf

	ClickAway()
EndFunc   ;==>DoubleCannonUpgrade


Func ArcherTowerUpgrade($test = False)

	SetLog("Upgrade Archer Tower")
	Local $aArcherTowerLevel = 0

	If Not $test Then
		If Not $g_bArcherTowerUpgrade Then Return

		; Master Builder is not available return
		If $g_iFreeBuilderCountBB = 0 Then
			SetLog("No Master Builder available! [" & $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB & "]", $COLOR_INFO)
			Return False
		EndIf
	EndIf

	ClickAway()
	SetLog("Saved Coord :" & $g_aiArcherTowerPos[0] & ", " & $g_aiArcherTowerPos[1], $COLOR_INFO)
	If _Sleep($DELAYUPGRADEHERO2) Then Return
	BuildingClickP($g_aiArcherTowerPos) ;Click ArcherTower Altar
	If _Sleep($DELAYUPGRADEHERO2) Then Return

	;Get Archer Tower info and Level
	Local $sInfo = BuildingInfo(242, 492 + $g_iBottomOffsetY)

	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 492 + $g_iBottomOffsetY)

		If @error Then SetError(0, 0, 0)
		Sleep(100)
		$CountGetInfo += 1
		If $CountGetInfo >= 50 Then Return
	WEnd
	If $g_bDebugSetlog Then SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
	If @error Then Return SetError(0, 0, 0)
	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Archer") = 0 Then
			SetLog("Bad Archer Tower location", $COLOR_ACTION)
			Return
		Else
			If $sInfo[2] <> "" Then
				$aArcherTowerLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Archer Tower level read as: " & $aArcherTowerLevel, $COLOR_SUCCESS)
				If $aArcherTowerLevel >= 6 Then ; OTTO
					SetLog("Your Archer Tower is at level needed for OTTO upgrade!", $COLOR_INFO)
					$g_bArcherTowerUpgrade = False ; turn Off the Archer Tower upgrade
					GUICtrlSetState($g_hChkArcherTowerUpgrade, $GUI_UNCHECKED)						
					Return
				EndIf
			Else
				SetLog("Archer Tower Level was not found!", $COLOR_INFO)
				Return
			EndIf
		EndIf
	Else
		SetLog("Bad Archer Tower OCR", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	If $g_aiCurrentLootBB[$eLootGoldBB] < ($g_afArcherTowerUpgCost[$aArcherTowerLevel] * 1000) Then
		SetLog("Archer Tower Upg failed, require " & ($g_afArcherTowerUpgCost[$aArcherTowerLevel] * 1000) & " builder gold!", $COLOR_INFO)
		Return
	EndIf

	Local $aUpgradeButton = findButton("Upgrade", Default, 1, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2 Then
		If _Sleep($DELAYUPGRADEHERO2) Then Return
		ClickP($aUpgradeButton)
		If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open


		Local $sImgBBUpgradeWindow =  @ScriptDir & "\imgxml\Windows\BBUpgradeWindow*"
		Local $sSearchArea = "275,160,550,190"

		; check for storage full window
		If IsWindowOpen($sImgBBUpgradeWindow, 0, 0, GetDiamondFromRect($sSearchArea)) Then
			Local $aWhiteZeros = decodeSingleCoord(findImage("UpgradeWhiteZero" ,$g_sImgUpgradeWhiteZero, GetDiamondFromRect("408,519,747,606"), 1, True, Default))
			If IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2 Then
				ClickP($aWhiteZeros, 1, 0) ; Click upgrade buttton
				;ClickAway()
				If _Sleep($DELAYUPGRADEHERO1) Then Return

				; Just incase the buy Gem Window pop up!
				If isGemOpen(True) Then
					SetLog("Archer Tower Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
					ClickAway()
					Return False
				EndIf

				SetLog("Archer Tower Upgrade complete", $COLOR_SUCCESS)
				$g_iFreeBuilderCountBB -= 1
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
			Else
				SetLog("Archer Tower Upgrade Fail!", $COLOR_ERROR)
				If $g_bDebugImageSave Then SaveDebugImage("UpgradeArcherTower2")
				ClickAway()
				Return
			EndIf
		Else
			SetLog("Upgrade Archer Tower window open fail", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Upgrade Archer Tower error finding button", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeArcherTower1")
	EndIf

	ClickAway()
EndFunc   ;==>ArcherTowerUpgrade



Func MultiMortarUpgrade($test = False)

	SetLog("Upgrade Multi Mortar")
	Local $aMultiMortarLevel = 0

	If Not $test Then
		If Not $g_bMultiMortarUpgrade Then Return

		; Master Builder is not available return
		If $g_iFreeBuilderCountBB = 0 Then
			SetLog("No Master Builder available! [" & $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB & "]", $COLOR_INFO)
			Return False
		EndIf
	EndIf

	ClickAway()
	SetLog("Saved Coord :" & $g_aiMultiMortarPos[0] & ", " & $g_aiMultiMortarPos[1], $COLOR_INFO)
	If _Sleep($DELAYUPGRADEHERO2) Then Return
	BuildingClickP($g_aiMultiMortarPos) ;Click MultiMortar Altar
	If _Sleep($DELAYUPGRADEHERO2) Then Return

	;Get Multi Mortar info and Level
	Local $sInfo = BuildingInfo(242, 492 + $g_iBottomOffsetY)

	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 492 + $g_iBottomOffsetY)

		If @error Then SetError(0, 0, 0)
		Sleep(100)
		$CountGetInfo += 1
		If $CountGetInfo >= 50 Then Return
	WEnd
	If $g_bDebugSetlog Then SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
	If @error Then Return SetError(0, 0, 0)
	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Multi") = 0 Then
			SetLog("Bad Multi Mortar location", $COLOR_ACTION)
			Return
		Else
			If $sInfo[2] <> "" Then
				$aMultiMortarLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Multi Mortar level read as: " & $aMultiMortarLevel, $COLOR_SUCCESS)
				If $aMultiMortarLevel >= 8 Then ; OTTO
					SetLog("Your Multi Mortar is at level needed for OTTO upgrade!", $COLOR_INFO)
					$g_bMultiMortarUpgrade = False ; turn Off the Multi Mortar upgrade
					GUICtrlSetState($g_hChkMultiMortarUpgrade, $GUI_UNCHECKED)
					Return
				EndIf
			Else
				SetLog("Multi Mortar Level was not found!", $COLOR_INFO)
				Return
			EndIf
		EndIf
	Else
		SetLog("Bad Multi Mortar OCR", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	If $g_aiCurrentLootBB[$eLootGoldBB] < ($g_afMultiMortarUpgCost[$aMultiMortarLevel] * 1000) Then
		SetLog("Multi Mortar Upg failed, require " & ($g_afMultiMortarUpgCost[$aMultiMortarLevel] * 1000) & " builder gold!", $COLOR_INFO)
		Return
	EndIf

	Local $aUpgradeButton = findButton("Upgrade", Default, 1, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2 Then
		If _Sleep($DELAYUPGRADEHERO2) Then Return
		ClickP($aUpgradeButton)
		If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open


		Local $sImgBBUpgradeWindow =  @ScriptDir & "\imgxml\Windows\BBUpgradeWindow*"
		Local $sSearchArea = "275,160,550,190"

		; check for storage full window
		If IsWindowOpen($sImgBBUpgradeWindow, 0, 0, GetDiamondFromRect($sSearchArea)) Then
			Local $aWhiteZeros = decodeSingleCoord(findImage("UpgradeWhiteZero" ,$g_sImgUpgradeWhiteZero, GetDiamondFromRect("408,519,747,606"), 1, True, Default))
			If IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2 Then
				ClickP($aWhiteZeros, 1, 0) ; Click upgrade buttton
				;ClickAway()
				If _Sleep($DELAYUPGRADEHERO1) Then Return

				; Just incase the buy Gem Window pop up!
				If isGemOpen(True) Then
					SetLog("Multi Mortar Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
					ClickAway()
					Return False
				EndIf

				SetLog("Multi Mortar Upgrade complete", $COLOR_SUCCESS)
				$g_iFreeBuilderCountBB -= 1
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
			Else
				SetLog("Multi Mortar Upgrade Fail!", $COLOR_ERROR)
				If $g_bDebugImageSave Then SaveDebugImage("UpgradeMultiMortar2")
				ClickAway()
				Return
			EndIf
		Else
			SetLog("Upgrade Multi Mortar window open fail", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Upgrade Multi Mortar error finding button", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeMultiMortar1")
	EndIf

	ClickAway()
EndFunc   ;==>MultiMortarUpgrade


Func MegaTeslaUpgrade($test = False)

	SetLog("Upgrade Mega Tesla")
	Local $aMegaTeslaLevel = 0

	If Not $test Then
		If Not $g_bMegaTeslaUpgrade Then Return

		; Master Builder is not available return
		If $g_iFreeBuilderCountBB = 0 Then
			SetLog("No Master Builder available! [" & $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB & "]", $COLOR_INFO)
			Return False
		EndIf
	EndIf

	ClickAway()
	SetLog("Saved Coord :" & $g_aiMegaTeslaPos[0] & ", " & $g_aiMegaTeslaPos[1], $COLOR_INFO)
	If _Sleep($DELAYUPGRADEHERO2) Then Return
	BuildingClickP($g_aiMegaTeslaPos) ;Click MegaTesla Altar
	If _Sleep($DELAYUPGRADEHERO2) Then Return

	;Get Mega Tesla info and Level
	Local $sInfo = BuildingInfo(242, 492 + $g_iBottomOffsetY)

	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 492 + $g_iBottomOffsetY)

		If @error Then SetError(0, 0, 0)
		Sleep(100)
		$CountGetInfo += 1
		If $CountGetInfo >= 50 Then Return
	WEnd
	If $g_bDebugSetlog Then SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
	If @error Then Return SetError(0, 0, 0)
	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Mega") = 0 Then
			SetLog("Bad Mega Tesla location", $COLOR_ACTION)
			Return
		Else
			If $sInfo[2] <> "" Then
				$aMegaTeslaLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Mega Tesla level read as: " & $aMegaTeslaLevel, $COLOR_SUCCESS)
				If $aMegaTeslaLevel >= 9 Then ; OTTO
					SetLog("Your Mega Tesla is at level needed for OTTO upgrade!", $COLOR_INFO)
					$g_bMegaTeslaUpgrade = False ; turn Off the Mega Tesla upgrade
					GUICtrlSetState($g_hChkMegaTeslaUpgrade, $GUI_UNCHECKED)
					Return
				EndIf
			Else
				SetLog("Mega Tesla Level was not found!", $COLOR_INFO)
				Return
			EndIf
		EndIf
	Else
		SetLog("Bad Mega Tesla OCR", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	If $g_aiCurrentLootBB[$eLootGoldBB] < ($g_afMegaTeslaUpgCost[$aMegaTeslaLevel] * 1000) Then
		SetLog("Mega Tesla Upg failed, require " & ($g_afMegaTeslaUpgCost[$aMegaTeslaLevel] * 1000) & " builder gold!", $COLOR_INFO)
		Return
	EndIf

	Local $aUpgradeButton = findButton("Upgrade", Default, 1, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2 Then
		If _Sleep($DELAYUPGRADEHERO2) Then Return
		ClickP($aUpgradeButton)
		If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open


		Local $sImgBBUpgradeWindow =  @ScriptDir & "\imgxml\Windows\BBUpgradeWindow*"
		Local $sSearchArea = "275,160,550,190"

		; check for storage full window
		If IsWindowOpen($sImgBBUpgradeWindow, 0, 0, GetDiamondFromRect($sSearchArea)) Then
			Local $aWhiteZeros = decodeSingleCoord(findImage("UpgradeWhiteZero" ,$g_sImgUpgradeWhiteZero, GetDiamondFromRect("408,519,747,606"), 1, True, Default))
			If IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2 Then
				ClickP($aWhiteZeros, 1, 0) ; Click upgrade buttton
				;ClickAway()
				If _Sleep($DELAYUPGRADEHERO1) Then Return

				; Just incase the buy Gem Window pop up!
				If isGemOpen(True) Then
					SetLog("Mega Tesla Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
					ClickAway()
					Return False
				EndIf

				SetLog("Mega Tesla Upgrade complete", $COLOR_SUCCESS)
				$g_iFreeBuilderCountBB -= 1
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
			Else
				SetLog("Mega Tesla Upgrade Fail!", $COLOR_ERROR)
				If $g_bDebugImageSave Then SaveDebugImage("UpgradeMegaTesla2")
				ClickAway()
				Return
			EndIf
		Else
			SetLog("Upgrade Mega Tesla window open fail", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Upgrade Mega Tesla error finding button", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeMegaTesla1")
	EndIf

	ClickAway()
EndFunc   ;==>MegaTeslaUpgrade

Func OttoBuildingUpgrades($bTest = False, $bFinishNow = False)

	; Master Builder is not available return
	If $g_iFreeBuilderCountBB = 0 Then
		SetLog("No Master Builder available for Otto upgrades !", $COLOR_INFO)
		Return False
	EndIf

	If $g_bBattleMachineUpgrade Then
		BattleMachineUpgrade($bTest, $bFinishNow)
		If _Sleep($DELAYRUNBOT3) Then Return
		If Not $bTest Then 
			If checkObstacles() Then Return
		EndIf
		If $g_bRestart = True Then Return
	EndIf

	If $g_bDoubleCannonUpgrade Then
		DoubleCannonUpgrade()
		If _Sleep($DELAYRUNBOT3) Then Return
		If Not $bTest Then 
			If checkObstacles() Then Return
		EndIf
		If $g_bRestart = True Then Return
	EndIf

	If $g_bArcherTowerUpgrade Then
		ArcherTowerUpgrade()
		If _Sleep($DELAYRUNBOT3) Then Return
		If Not $bTest Then 
			If checkObstacles() Then Return
		EndIf
		If $g_bRestart = True Then Return
	EndIf

	If $g_bMultiMortarUpgrade Then
		MultiMortarUpgrade()
		If _Sleep($DELAYRUNBOT3) Then Return
		If Not $bTest Then 
			If checkObstacles() Then Return
		EndIf
		If $g_bRestart = True Then Return
	EndIf

	If $g_bMegaTeslaUpgrade Then MegaTeslaUpgrade()

	Return
EndFunc



