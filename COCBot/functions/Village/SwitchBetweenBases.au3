; #FUNCTION# ====================================================================================================================
; Name ..........: SwitchBetweenBases
; Description ...: Switches Between Normal Village and Builder Base
; Syntax ........: SwitchBetweenBases()
; Parameters ....:
; Return values .: True: Successfully switched Bases  -  False: Failed to switch Bases
; Author ........: Fliegerfaust (05-2017)
; Modified ......: GrumpyHog (08-2022), Moebius14 (07-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SwitchBetweenBases($bCheckMainScreen = True, $GoToBB = False)
	Local $sSwitchFrom, $sSwitchTo, $bIsOnBuilderBase = False, $aButtonCoords, $avBoat, $avTempArray
	Local $sTile, $sTileDir, $sRegionToSearch
	Local $bSwitched = False

	If Not $g_bRunState Then Return

	For $i = 0 To 3
		If isOnBuilderBase(True) Then
			$sSwitchFrom = "Builder Base"
			$sSwitchTo = "Normal Village"
			$bIsOnBuilderBase = True
			$sTile = "BoatBuilderBase"
			$sTileDir = $g_sImgBoatBB
			$sRegionToSearch = GetDiamondFromRect("480,40,710,250")
		Else
			$sSwitchFrom = "Normal Village"
			$sSwitchTo = "Builder Base"
			$bIsOnBuilderBase = False
			$sTile = "BoatNormalVillage"
			$sTileDir = $g_sImgBoat
			$sRegionToSearch = GetDiamondFromRect("60,430,390,630")
		EndIf

		If _Sleep(250) Then Return
		If Not $g_bRunState Then Return

		ZoomOut() ; ensure boat is visible

		SwitchToBuilderBase()

		If Not $g_bRunState Then Return

		If $bIsOnBuilderBase And $g_iTree = $eTreeOO Then $sRegionToSearch = GetDiamondFromRect("650,180,820,360")

		For $b = 0 To 9
			$avBoat = findMultiple($sTileDir, $sRegionToSearch, $sRegionToSearch, 0, 1000, 1, "objectname,objectpoints", True)
			If IsArray($avBoat) And UBound($avBoat, $UBOUND_ROWS) > 0 Then ExitLoop
			If _Sleep(250) Then Return
		Next

		If $GoToBB Then
			$g_bStayOnBuilderBase = True
		Else
			$g_bStayOnBuilderBase = False
		EndIf

		If Not IsArray($avBoat) Or UBound($avBoat, $UBOUND_ROWS) <= 0 Then
			SetLog("Couldn't find Boat on " & $sSwitchFrom, $COLOR_ERROR)
			If $g_bDebugImageSave Then SaveDebugImage("SwitchBetweenBases", False)
			If $i = 2 Then
				If $g_bStayOnBuilderBase And $sSwitchFrom = "Normal Village" Then $g_bStayOnBuilderBase = False
				If $sSwitchFrom = "Builder Base" Then
					CloseCoC(True)
					checkMainScreen(False, True)
				EndIf
			EndIf
			If $i = 3 Then Return False
		Else
			; loop through the detected images
			For $j = 0 To UBound($avBoat, $UBOUND_ROWS) - 1
				$avTempArray = $avBoat[$j]
				SetLog("Boat Search find : " & $avTempArray[0])
				$aButtonCoords = decodeSingleCoord($avTempArray[1])

				If IsArray($aButtonCoords) And UBound($aButtonCoords, $UBOUND_ROWS) = 2 Then
					SetLog("[" & $i & "] Going to " & $sSwitchTo, $COLOR_INFO)
					ClickP($aButtonCoords)
					If _Sleep($DELAYSWITCHBASES1) Then Return

					; switch can take up to 2 Seconds, check for 3 additional Seconds...
					Local $hTimerHandle = __TimerInit()
					$bSwitched = False
					While __TimerDiff($hTimerHandle) < 3000 And Not $bSwitched
						If _Sleep(250) Then Return
						If Not $g_bRunState Then Return
						ForceCaptureRegion()
						$bSwitched = isOnBuilderBase(True) <> $bIsOnBuilderBase
					WEnd

					If $bSwitched Then
						If $bCheckMainScreen Then checkMainScreen(True, Not $bIsOnBuilderBase)
						Return True
					Else
						SetLog("Failed to go to the " & $sSwitchTo, $COLOR_ERROR)
						If $i = 2 And $g_bStayOnBuilderBase And $sSwitchTo = "Builder Base" Then $g_bStayOnBuilderBase = False
					EndIf
				Else
					Setlog("[" & $i & "] SwitchBetweenBases Tile: " & $sTile, $COLOR_ERROR)
					Setlog("[" & $i & "] SwitchBetweenBases isOnBuilderBase: " & isOnBuilderBase(True), $COLOR_ERROR)
					If $bIsOnBuilderBase Then
						SetLog("Cannot find the Boat on the Coast", $COLOR_ERROR)
					Else
						SetLog("Cannot find the Boat on the Coast. Maybe it is still broken or not visible", $COLOR_ERROR)
						If $i = 2 Then $g_bStayOnBuilderBase = False
					EndIf

					If $i >= 2 Then RestartAndroidCoC() ; Need to try to restart CoC
				EndIf
			Next
		EndIf

		If _Sleep(3000) Then Return
		If Not $g_bRunState Then Return
	Next

	Return False
EndFunc   ;==>SwitchBetweenBases

Func SwitchToBuilderBase()

	If QuickMIS("BC1", $sImgTunnel, 0, 190 + $g_iMidOffsetY, $g_iGAME_WIDTH, $g_iGAME_HEIGHT) Then
		SetLog("Back To Main Builder Base", $COLOR_INFO)
		If $g_iQuickMISName = "OOTunnel" Then
			SetDebugLog("Found OOTunnel", $COLOR_INFO)
			Click($g_iQuickMISX - Random(25, 70, 1), $g_iQuickMISY + Random(0, 30, 1))
		Else
			SetDebugLog("Found BBTunnel", $COLOR_INFO)
			Click($g_iQuickMISX - Random(30, 50, 1), $g_iQuickMISY + Random(10, 40, 1))
		EndIf
		If _Sleep(2000) Then Return
		ZoomOut()
		Return True
	Else
		SetDebugLog("Failed to locate the tunnel", $COLOR_INFO)
		If $g_bDebugImageSave Then SaveDebugImage("OO2BBTunnel") ;
		Return False
	EndIf

EndFunc   ;==>SwitchToBuilderBase
