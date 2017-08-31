; #FUNCTION# ====================================================================================================================
; Name ..........: SwitchBetweenBases
; Description ...: Switches Between Normal Village and Builder Base
; Syntax ........: SwitchBetweenBases()
; Parameters ....:
; Return values .: True: Successfully switched Bases  -  False: Failed to switch Bases
; Author ........: Fliegerfaust (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SwitchBetweenBases($bCheckMainScreen = True)
	Local $sSwitchFrom, $sSwitchTo, $sBack = "", $bIsOnBuilderBase = False, $aButtonCoords
	Local $sTile, $sTilePath, $sRegionToSearch

	If Not $g_bRunState Then Return

	If isOnBuilderIsland(True) Then
		$sSwitchFrom = "Builder Base"
		$sSwitchTo = "Normal Village"
		$sBack = " back"
		$bIsOnBuilderBase = True
		$sTile = "BoatBuilderBase_0_89.xml"
		$sRegionToSearch = "487,44,708,242"
	Else
		$sSwitchFrom = "Normal Village"
		$sSwitchTo = "Builder Base"
		$bIsOnBuilderBase = False
		$sTile = "BoatNormalVillage_0_89.xml"
		$sRegionToSearch = "66,432,388,627"
	EndIf

	ZoomOut() ; ensure bot is visible
	$aButtonCoords = decodeSingleCoord(findImageInPlace($sTile, @ScriptDir & "\imgxml\Boat\" & $sTile,  $sRegionToSearch))
	If UBound($aButtonCoords) > 1 Then
		SetLog("Going to " & $sSwitchTo, $COLOR_INFO)
		ClickP($aButtonCoords)
		If _Sleep($DELAYSWITCHBASES1) Then Return

		; switch can take up to 2 Seconds, check for 3 additional Seconds...
		Local $hTimerHandle = __TimerInit()
		Local $bSwitched = False
		While __TimerDiff($hTimerHandle) < 3000 And Not $bSwitched
			_Sleep(250)
			ForceCaptureRegion()
			$bSwitched = isOnBuilderIsland(True) <> $bIsOnBuilderBase
		WEnd
		
		If $bSwitched Then
			SetLog("Successfully went" & $sBack & " to the " & $sSwitchTo & "!", $COLOR_SUCCESS)
			If $bCheckMainScreen = True Then checkMainScreen(True, Not $bIsOnBuilderBase)
			Return True
		Else
			SetLog("Failed to go" & $sBack & " to the " & $sSwitchTo & "!", $COLOR_ERROR)
		EndIf
	Else
		If $bIsOnBuilderBase Then
			SetLog("Cannot find the Boat on the Coast!", $COLOR_ERROR)
		Else
			SetLog("Cannot find the Boat on the Coast! Maybe it is still broken or not visible?", $COLOR_ERROR)
		EndIf
	EndIf

	Return False
EndFunc   ;==>SwitchBetweenBases
