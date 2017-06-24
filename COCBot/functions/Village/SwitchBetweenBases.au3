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

Func SwitchBetweenBases()
	Local $sSwitchTo, $bIsOnBuilderBase = False, $aButtonCoords
	Local $sTile, $sTilePath, $sRegionToSearch

	If Not $g_bRunState Then Return

	If isOnBuilderIsland(True) Then
		$sSwitchTo = "Normal Village"
		$bIsOnBuilderBase = True
		$sTile = "BoatBuilderBase_0_89.xml"
		$sRegionToSearch = "487,44,708,242"
	Else
		$sSwitchTo = "Builder Base"
		$bIsOnBuilderBase = False
		$sTile = "BoatNormalVillage_0_89.xml"
		$sRegionToSearch = "66,432,388,627"
	EndIf

	$aButtonCoords = decodeSingleCoord(findImageInPlace($sTile, @ScriptDir & "\imgxml\Boat\" & $sTile,  $sRegionToSearch))
	If UBound($aButtonCoords) > 1 Then
		SetLog("Going to " & $sSwitchTo, $COLOR_INFO)
		ClickP($aButtonCoords)
		If _Sleep($DELAYSWITCHBASES1) Then Return

		If $bIsOnBuilderBase Then
			If _Sleep($DELAYSWITCHBASES2) Then Return

			If isOnBuilderIsland(True) Then
				SetLog("Failed to go back to the normal Village!", $COLOR_ERROR)
			Else
				SetLog("Successfully went back to the normal Village!", $COLOR_SUCCESS)
				checkMainScreen(True, False)
				Return True
			EndIf
		Else
			If Not isOnBuilderIsland(True) Then
				SetLog("Failed to go to the Builder Base!", $COLOR_ERROR)
			Else
				SetLog("Successfully went to the Builder Base!", $COLOR_SUCCESS)
				checkMainScreen(True, True)
				Return True
			EndIf
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
