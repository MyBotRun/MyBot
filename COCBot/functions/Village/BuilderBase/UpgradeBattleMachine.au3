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

Func chkUpgradeBattleMachine()
	$g_bBattleMachineUpgrade = (GUICtrlRead($g_hChkBattleMachineUpgrade) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>chkUpgradeBattleMachine

Func BattleMachineUpgrade($test = False, $bFinishNow = False)

	SetLog("Upgrade Battle Machine")
	Local $aHeroLevel = 0

	If Not $test Then
		If Not $g_bBattleMachineUpgrade Then Return

		; Master Builder is not available return
		If $g_iFreeBuilderCountBB = 0 Then
			SetLog("No Master Builder available! [" & $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB & "]", $COLOR_INFO)
			Return False
		EndIf
	EndIf

	;ClickAway()

	If Not LocateBattleMachine() Then Return False

#cs
	; use ImgLoc to find Battle Machine
	Local $aiBattleMachinePos = ImgLocateBattleMachine()

	If _Sleep($DELAYUPGRADEHERO2) Then Return

	If Not IsArray($aiBattleMachinePos) Or UBound($aiBattleMachinePos, $UBOUND_ROWS) < 2 Then
		SetLog("Can't locate Battle Machine!", $COLOR_WARNING)
		Return False
	EndIf

	; Click Battle Machine Altar
	ClickP($aiBattleMachinePos)

	If _Sleep($DELAYUPGRADEHERO2) Then Return
#ce

	;Get Battle Machine info and Level
	Local $sInfo = BuildingInfo(242, 490 + $g_iBottomOffsetY)

	If @error Then SetError(0, 0, 0)
	Local $CountGetInfo = 0
	While IsArray($sInfo) = False
		$sInfo = BuildingInfo(242, 490 + $g_iBottomOffsetY)

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
					Return
				EndIf
			Else
				SetLog("Your Battle Machine Level was not found!", $COLOR_INFO)
				Return
			EndIf
		EndIf
	Else
		SetLog("Bad Battle Machine OCR", $COLOR_ERROR)
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	;##### Get updated village elixir and dark elixir values
	#cs
	If _CheckPixel($aVillageHasDarkElixir, $g_bCapturePixel) Then ; check if the village have a Dark Elixir Storage
		$g_aiCurrentLoot[$eLootDarkElixir] = Number(getResourcesMainScreen(728, 123))
		If $g_bDebugSetlog Then SetDebugLog("Updating village values [D]: " & $g_aiCurrentLoot[$eLootDarkElixir], $COLOR_DEBUG)
	Else
		If $g_bDebugSetlog Then SetDebugLog("getResourcesMainScreen didn't get the DE value", $COLOR_DEBUG)
	EndIf
	#ce

	If $g_aiCurrentLootBB[$eLootElixirBB] < ($g_afBattleMachineUpgCost[$aHeroLevel] * 1000000) Then
		SetLog("Battle Machine Upg failed, require " & ($g_afBattleMachineUpgCost[$aHeroLevel] * 1000000) & " elixir!", $COLOR_INFO)
		Return
	EndIf

	Local $aUpgradeButton = findButton("Upgrade", Default, 1, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2 Then
		If _Sleep($DELAYUPGRADEHERO2) Then Return
		ClickP($aUpgradeButton)
		If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open


		Local $sImgBattleMachineUpgradeWindow =  @ScriptDir & "\imgxml\Windows\BattleMachineUpgradeWindow*"
		Local $sSearchArea = "120,175,405,485"

		; check for storage full window
		If IsWindowOpen($sImgBattleMachineUpgradeWindow, 0, 0, GetDiamondFromRect($sSearchArea)) Then
			Local $aWhiteZeros = decodeSingleCoord(findImage("UpgradeWhiteZero" ,$g_sImgUpgradeWhiteZero, GetDiamondFromRect("408,519,747,606"), 1, True, Default))
			If IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2 Then
				ClickP($aWhiteZeros, 1, 0) ; Click upgrade buttton
				;ClickAway()
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

	If $bFinishNow Then FinishNow()

	ClickAway()
EndFunc   ;==>BattleMachineUpgrade

; Image Search for Battle Machine
Func ImgLocateBattleMachine()
	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\BattleMachine\"

	Local $sSearchArea = "FV"
	Local $avBattleMachine = findMultiple($sImgDir, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", True)

	If Not IsArray($avBattleMachine) Or UBound($avBattleMachine, $UBOUND_ROWS) <= 0 Then
		SetLog("Couldn't find Battle Machine in night village", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("ImgLocateBattleMachine", False)
		Return False
	EndIf

	Local $avBattleMachineRes, $aiBattleMachineCoords

	; loop thro the detected images
	For $i = 0 To UBound($avBattleMachine, $UBOUND_ROWS) - 1
		$avBattleMachineRes = $avBattleMachine[$i]
		$aiBattleMachineCoords = decodeSingleCoord($avBattleMachineRes[1])
		If IsArray($aiBattleMachineCoords) And UBound($aiBattleMachineCoords, $UBOUND_ROWS) > 1 Then
			;$g_aiBattleMachinePos[0] = $aiBattleMachineCoords[0]
			;$g_aiBattleMachinePos[1] = $aiBattleMachineCoords[1]
			SetLog("Battle Machine: " & $avBattleMachineRes[0] & " found at: (" & $aiBattleMachineCoords[0] & "," & $aiBattleMachineCoords[1] & ")")
			Return $aiBattleMachineCoords
		EndIf
	Next

	Return False
EndFunc

; based on LocateStarLab
Func LocateBattleMachine()
	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\BattleMachine\"
	; Zoomout before locating
	ZoomOut()

	If $g_aiBattleMachinePos[0] > 0 And $g_aiBattleMachinePos[1] > 0 Then
		BuildingClickP($g_aiBattleMachinePos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(242, 490 + $g_iBottomOffsetY) ; Get building name and level with OCR

		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "Machine") = True Then ; we found the Battle Machine
				SetLog("Battle Machine located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)
				Return True
			Else
				ClickAway()
				SetDebugLog("Stored Battle Machine Position is not valid.", $COLOR_ERROR)
				SetDebugLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				SetDebugLog("Village position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
				ConvertToVillagePos($g_aiBattleMachinePos[0],$g_aiBattleMachinePos[1])
				SetDebugLog("Real position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
				$g_aiBattleMachinePos[0] = -1
				$g_aiBattleMachinePos[1] = -1
			EndIf
		Else
			ClickAway()
			SetDebugLog("Stored Battle Machine Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiBattleMachinePos[0],$g_aiBattleMachinePos[1])
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
						ConvertFromVillagePos($g_aiBattleMachinePos[0],$g_aiBattleMachinePos[1])
						ExitLoop 2
					EndIf
				Next
			Else
				; Test the coordinate
				Local $tempObbj = StringSplit($aObjectpoints, ",", $STR_NOCOUNT) ;  will be a string : 708,360
				If UBound($tempObbj) = 2 Then
					$g_aiBattleMachinePos[0] = Number($tempObbj[0]) ;+ 9
					$g_aiBattleMachinePos[1] = Number($tempObbj[1]) ;+ 15
					ConvertFromVillagePos($g_aiBattleMachinePos[0],$g_aiBattleMachinePos[1])
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf

	If $g_aiBattleMachinePos[0] > 0 And $g_aiBattleMachinePos[1] > 0 Then
		BuildingClickP($g_aiBattleMachinePos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(242, 490 + $g_iBottomOffsetY) ; Get building name and level with OCR

		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "Machine") = True Then ; we found the Battle Machine
				SetLog("Battle Machine located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)
				Return True
			Else
				ClickAway()
				SetDebugLog("Found Battle Machine Position is not valid.", $COLOR_ERROR)
				SetDebugLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				SetDebugLog("Village position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
				ConvertToVillagePos($g_aiBattleMachinePos[0],$g_aiBattleMachinePos[1])
				SetDebugLog("Real position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
				$g_aiBattleMachinePos[0] = -1
				$g_aiBattleMachinePos[1] = -1
			EndIf
		Else
			ClickAway()
			SetDebugLog("Found Battle Machine Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiBattleMachinePos[0],$g_aiBattleMachinePos[1])
			SetDebugLog("Real position: " & $g_aiBattleMachinePos[0] & ", " & $g_aiBattleMachinePos[1], $COLOR_DEBUG, True)
			$g_aiBattleMachinePos[0] = -1
			$g_aiBattleMachinePos[1] = -1
		EndIf
	EndIf

	SetLog("Can not find Battle Machine.", $COLOR_ERROR)
	Return False
EndFunc   ;==>LocateBattleMachine()
