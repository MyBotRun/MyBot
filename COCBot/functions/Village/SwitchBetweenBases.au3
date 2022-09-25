; #FUNCTION# ====================================================================================================================
; Name ..........: SwitchBetweenBases
; Description ...: Switches Between Normal Village and Builder Base
; Syntax ........: SwitchBetweenBases()
; Parameters ....:
; Return values .: True: Successfully switched Bases  -  False: Failed to switch Bases
; Author ........: Fliegerfaust (05-2017)
; Modified ......: GrumpyHog (08-2022)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SwitchBetweenBases($bCheckMainScreen = True)
	Local $sSwitchFrom, $sSwitchTo, $bIsOnBuilderBase = False, $aButtonCoords, $avBoat, $avTempArray
	Local $sTile, $sTileDir, $sRegionToSearch
	Local $bSwitched = False

	If Not $g_bRunState Then Return

	For $i = 0 To 2
		If isOnBuilderBase(True) Then
			$sSwitchFrom = "Builder Base"
			$sSwitchTo = "Normal Village"
			$bIsOnBuilderBase = True
			$sTile = "BoatBuilderBase"
			$sTileDir = $g_sImgBoatBB
			$sRegionToSearch = GetDiamondFromRect("487,44,708,242")
		Else
			$sSwitchFrom = "Normal Village"
			$sSwitchTo = "Builder Base"
			$bIsOnBuilderBase = False
			$sTile = "BoatNormalVillage"
			$sTileDir = $g_sImgBoat
			$sRegionToSearch = GetDiamondFromRect("66,432,388,627")
		EndIf

		If _sleep(250) Then Return
		If Not $g_bRunState Then Return

		ZoomOut() ; ensure boat is visible
		If Not $g_bRunState Then Return

		$avBoat = findMultiple($sTileDir, $sRegionToSearch, $sRegionToSearch, 0, 1000, 1, "objectname,objectpoints", True)

		If Not IsArray($avBoat) Or UBound($avBoat, $UBOUND_ROWS) <= 0 Then
			SetLog("Couldn't find Boat on " & $sSwitchFrom, $COLOR_ERROR)
			If $g_bDebugImageSave Then SaveDebugImage("SwitchBetweenBases", False)
			Return False
		Else
			; loop thro the detected images
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
					EndIf
				Else
					Setlog("[" & $i & "] SwitchBetweenBases Tile: " & $sTile, $COLOR_ERROR)
					Setlog("[" & $i & "] SwitchBetweenBases isOnBuilderBase: " & isOnBuilderBase(True), $COLOR_ERROR)
					If $bIsOnBuilderBase Then
						SetLog("Cannot find the Boat on the Coast", $COLOR_ERROR)
					Else
						SetLog("Cannot find the Boat on the Coast. Maybe it is still broken or not visible", $COLOR_ERROR)
					EndIf

					If $i >= 1 Then RestartAndroidCoC() ; Need to try to restart CoC
				EndIf
			Next
		EndIf

		If _Sleep(3000) Then Return
		If Not $g_bRunState Then Return
	Next

	Return False
EndFunc   ;==>SwitchBetweenBases
