; #FUNCTION# ====================================================================================================================
; Name ..........: UpgradeBM
; Description ...: Upgrade Battle Machine - based on UpgradeHeroes
; Author ........: GrumpyHog (2022-01)
; Modified ......: Moebius14 (2023-07)
; Remarks .......: This file is part of MyBot Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Returns True or False
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================

Func BattleMachineUpgrade($test = False)

	Local $aHeroLevel = 0

	If Not $test Then
		If Not $g_bBattleMachineUpgrade Then Return

		; Master Builder is not available return
		If $g_iFreeBuilderCountBB = 0 Then
			SetDebugLog("No Master Builder available! [" & $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB & "]", $COLOR_INFO)
			Return False
		EndIf
	EndIf

	SetLog("Upgrade Battle Machine")

	If Not LocateBattleMachine() Then Return False

	;Get Battle Machine info and Level
	Local $sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)

	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)

		If @error Then SetError(0, 0, 0)
		Sleep(100)
		$CountGetInfo += 1
		If $CountGetInfo >= 50 Then Return
	WEnd
	If $g_bDebugSetlog Then SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
	If @error Then Return SetError(0, 0, 0)
	If $sInfo[0] > 1 Or $sInfo[0] = "" Then
		If StringInStr($sInfo[1], "Mach") = 0 Then
			SetLog("Bad Battle Machine location", $COLOR_ACTION)
			Return
		Else
			If $sInfo[2] <> "" Then
				$aHeroLevel = Number($sInfo[2]) ; grab hero level from building info array
				SetLog("Your Battle Machine level read as: " & $aHeroLevel, $COLOR_SUCCESS)
				If $aHeroLevel = $g_iMaxBattleMachineLevel Then ; max hero
					SetLog("Your Battle Machine is at max level, cannot upgrade anymore!", $COLOR_INFO)
					$g_bBattleMachineUpgrade = False ; turn Off the Battle Machine upgrade
					GUICtrlSetState($g_hChkBattleMachineUpgrade, $GUI_UNCHECKED)
					ClickAway()
					Return
				EndIf
				$g_CombinedMachineLevel = $g_CurrentBattleMachineLevel + $g_CurrentBattleCopterLevel
				If $g_CombinedMachineLevel >= $g_MaxCombinedMachineLevel Then ; Enough For BoB Control level 5
					SetLog("Your combined machine level is enough !", $COLOR_INFO)
					$g_bBattleMachineUpgrade = False ; turn Off the Battle Machine upgrade
					$g_bBattleCopterUpgrade = False ; turn Off the Battle Copter upgrade
					GUICtrlSetState($g_hChkBattleMachineUpgrade, $GUI_UNCHECKED)
					GUICtrlSetState($g_hChkBattleCopterUpgrade, $GUI_UNCHECKED)
					$g_CombinedMachineLevel = 0 ; If user wants to continue upgrade despite the combined level
					ClickAway()
					Return
				EndIf
			Else
				SetLog("Your Battle Machine Level was not found!", $COLOR_INFO)
				ClickAway()
				Return
			EndIf
		EndIf
	Else
		SetLog("Bad Battle Machine OCR", $COLOR_ERROR)
		ClickAway()
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	If $g_aiCurrentLootBB[$eLootElixirBB] < ($g_afBattleMachineUpgCost[$aHeroLevel] * 1000000) Then
		SetLog("Battle Machine Upg failed, require " & ($g_afBattleMachineUpgCost[$aHeroLevel] * 1000000) & " elixir!", $COLOR_INFO)
		ClickAway()
		Return
	EndIf

	Local $aUpgradeButton = findButton("Upgrade", Default, 1, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2 Then
		If _Sleep($DELAYUPGRADEHERO2) Then Return
		ClickP($aUpgradeButton)
		If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open

		Local $sImgBattleMachineUpgradeWindow = @ScriptDir & "\imgxml\Windows\BattleMachineUpgradeWindow*"
		Local $sSearchArea = "160,180,230,250"

		; check for storage full window
		If IsWindowOpen($sImgBattleMachineUpgradeWindow, 0, 0, GetDiamondFromRect($sSearchArea)) Then
			Local $aWhiteZeros = decodeSingleCoord(findImage("UpgradeWhiteZero", $g_sImgUpgradeWhiteZero, GetDiamondFromRect("625,560,790,625"), 1, True, Default))
			If IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2 Then
				ClickP($aWhiteZeros, 1, 0) ; Click upgrade buttton
				If _Sleep($DELAYUPGRADEHERO1) Then Return

				; Just incase the buy Gem Window pop up!
				If isGemOpen(True) Then
					SetLog("Battle Machine Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
					ClickAway()
					Return False
				EndIf

				SetLog("Battle Machine Upgrade complete", $COLOR_SUCCESS)
				$g_iFreeBuilderCountBB -= 1
				If _Sleep($DELAYUPGRADEHERO2) Then Return ; Wait for window to close
			Else
				SetLog("Battle Machine Upgrade Fail!", $COLOR_ERROR)
				If $g_bDebugImageSave Then SaveDebugImage("UpgradeBMBtn2")
				ClickAway()
				Return
			EndIf
		Else
			SetLog("Upgrade Battle Machine window open fail", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Upgrade Battle Machine error finding button", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeBMBtn1")
	EndIf

	ClickAway()
EndFunc   ;==>BattleMachineUpgrade

; based on LocateStarLab
Func LocateBattleMachine()
	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\BattleMachine\"
	; Zoomout before locating
	ZoomOut()

	CollectBuilderBase()
	If _Sleep($DELAYRUNBOT3) Then Return

	If $g_aiBattleMachinePos[0] > 0 And $g_aiBattleMachinePos[1] > 0 Then
		BuildingClickP($g_aiBattleMachinePos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; Get building name and level with OCR

		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "Machine") = True Then ; we found the Battle Machine
				SetLog("Battle Machine located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)
				$g_CurrentBattleMachineLevel = $aResult[2]
				Return True
			Else
				ClickAway()
				SetDebugLog("Stored Battle Machine Position is not valid.", $COLOR_ERROR)
				SetDebugLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				SetDebugLog("Village position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
				ConvertToVillagePos($g_aiBattleMachinePos[0], $g_aiBattleMachinePos[1])
				SetDebugLog("Real position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
				$g_aiBattleMachinePos[0] = -1
				$g_aiBattleMachinePos[1] = -1
			EndIf
		Else
			ClickAway()
			SetDebugLog("Stored Battle Machine Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiBattleMachinePos[0], $g_aiBattleMachinePos[1])
			SetDebugLog("Real position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
			$g_aiBattleMachinePos[0] = -1
			$g_aiBattleMachinePos[1] = -1
		EndIf
	EndIf

	SetLog("Looking for Battle Machine...", $COLOR_ACTION)

	Local $sCocDiamond = "FV"
	Local $sRedLines = $sCocDiamond
	Local $iMinLevel = 0
	Local $iMaxLevel = 1000
	Local $iMaxReturnPoints = 1
	Local $sReturnProps = "objectname,objectpoints"
	Local $bForceCapture = True

	; DETECTION IMGLOC
	Local $aResult = findMultiple($sImgDir, $sCocDiamond, $sRedLines, $iMinLevel, $iMaxLevel, $iMaxReturnPoints, $sReturnProps, $bForceCapture)
	If IsArray($aResult) And UBound($aResult) > 0 Then ; we have an array with data of images found
		For $i = 0 To UBound($aResult) - 1
			If _Sleep(50) Then Return ; just in case on PAUSE
			If Not $g_bRunState Then Return ; Stop Button
			SetDebugLog(_ArrayToString($aResult[$i]))
			Local $aTEMP = $aResult[$i]
			Local $sObjectname = String($aTEMP[0])
			SetDebugLog("Image name: " & String($aTEMP[0]), $COLOR_INFO)
			Local $aObjectpoints = $aTEMP[1] ; number of  objects returned
			SetDebugLog("Object points: " & String($aTEMP[1]), $COLOR_INFO)
			If StringInStr($aObjectpoints, "|") Then
				$aObjectpoints = StringReplace($aObjectpoints, "||", "|")
				Local $sString = StringRight($aObjectpoints, 1)
				If $sString = "|" Then $aObjectpoints = StringTrimRight($aObjectpoints, 1)
				Local $tempObbjs = StringSplit($aObjectpoints, "|", $STR_NOCOUNT) ; several detected points
				For $j = 0 To UBound($tempObbjs) - 1
					; Test the coordinates
					Local $tempObbj = StringSplit($tempObbjs[$j], ",", $STR_NOCOUNT) ;  will be a string : 708,360
					If UBound($tempObbj) = 2 Then
						$g_aiBattleMachinePos[0] = Number($tempObbj[0]) ;+ 9
						$g_aiBattleMachinePos[1] = Number($tempObbj[1]) ;+ 15
						ConvertFromVillagePos($g_aiBattleMachinePos[0], $g_aiBattleMachinePos[1])
						ExitLoop 2
					EndIf
				Next
			Else
				; Test the coordinate
				Local $tempObbj = StringSplit($aObjectpoints, ",", $STR_NOCOUNT) ;  will be a string : 708,360
				If UBound($tempObbj) = 2 Then
					$g_aiBattleMachinePos[0] = Number($tempObbj[0]) ;+ 9
					$g_aiBattleMachinePos[1] = Number($tempObbj[1]) ;+ 15
					ConvertFromVillagePos($g_aiBattleMachinePos[0], $g_aiBattleMachinePos[1])
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf

	If $g_aiBattleMachinePos[0] > 0 And $g_aiBattleMachinePos[1] > 0 Then
		BuildingClickP($g_aiBattleMachinePos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; Get building name and level with OCR

		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "Machine") = True Then ; we found the Battle Machine
				SetLog("Battle Machine located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)
				$g_CurrentBattleMachineLevel = $aResult[2]
				Return True
			Else
				ClickAway()
				SetDebugLog("Found Battle Machine Position is not valid.", $COLOR_ERROR)
				SetDebugLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				SetDebugLog("Village position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
				ConvertToVillagePos($g_aiBattleMachinePos[0], $g_aiBattleMachinePos[1])
				SetDebugLog("Real position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
				$g_aiBattleMachinePos[0] = -1
				$g_aiBattleMachinePos[1] = -1
			EndIf
		Else
			ClickAway()
			SetDebugLog("Found Battle Machine Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiBattleMachinePos[0], $g_aiBattleMachinePos[1])
			SetDebugLog("Real position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
			$g_aiBattleMachinePos[0] = -1
			$g_aiBattleMachinePos[1] = -1
		EndIf
	EndIf

	SetLog("Can not find Battle Machine.", $COLOR_ERROR)
	ClickAway()
	Return False
EndFunc   ;==>LocateBattleMachine

Func DeleteBattleMachineCoord()
	SetLog("Deleting Coordinates of Battle Machine.", $COLOR_OLIVE)
	$g_aiBattleMachinePos[0] = -1
	$g_aiBattleMachinePos[1] = -1
	IniWrite($g_sProfileBuildingPath, "other", "BattleMachinePosX", $g_aiBattleMachinePos[0])
	IniWrite($g_sProfileBuildingPath, "other", "BattleMachinePosY", $g_aiBattleMachinePos[1])
	$g_bBattleMachineUpgrade = False ; turn Off the Battle Machine upgrade
	GUICtrlSetState($g_hChkBattleMachineUpgrade, $GUI_UNCHECKED)
EndFunc   ;==>DeleteBattleMachineCoord
