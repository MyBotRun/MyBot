; #FUNCTION# ====================================================================================================================
; Name ..........: VillageReport
; Description ...: This function will report the village free and total builders, gold, elixir, dark elixir and gems.
;                  It will also update the statistics to the GUI.
; Syntax ........: VillageReport()
; Parameters ....: None
; Return values .: None
; Author ........: Hervidero (2015-feb-10)
; Modified ......: Safar46 (2015), Hervidero (2015, KnowJack - added statistics bypasss (June-2015) , ProMac (2015)
;                  Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func VillageReport($bBypass = False, $bSuppressLog = False)
	PureClickP($aAway, 1, 0, "#0319") ;Click Away
	If _Sleep($iDelayVillageReport1) Then Return

	Switch $bBypass
		Case False
			If Not $bSuppressLog Then SetLog("Village Report", $COLOR_BLUE)
		Case True
			If Not $bSuppressLog Then SetLog("Updating Village Resource Values", $COLOR_BLUE)
		Case Else
			If Not $bSuppressLog Then SetLog("Village Report Error, You have been a BAD programmer!", $COLOR_RED)
	EndSwitch

	Local $aGetBuilders = StringSplit(getBuilders($aBuildersDigits[0], $aBuildersDigits[1]), "#", $STR_NOCOUNT)
	$iFreeBuilderCount = $aGetBuilders[0]
	$iTotalBuilderCount = $aGetBuilders[1]
	If Not $bSuppressLog Then Setlog("No. of Free/Total Builders: " & $iFreeBuilderCount & "/" & $iTotalBuilderCount, $COLOR_GREEN)

	$iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
	If Not $bSuppressLog Then Setlog(" [T]: " & _NumberFormat($iTrophyCurrent), $COLOR_GREEN)

	If _ColorCheck(_GetPixelColor(812, 141, True), Hex(0x000000, 6), 10) Then ; check if the village have a Dark Elixir Storage
		$iGoldCurrent = getResourcesMainScreen(696, 23)
		$iElixirCurrent = getResourcesMainScreen(696, 74)
		$iDarkCurrent =  getResourcesMainScreen(728, 123)
		$iGemAmount = getResourcesMainScreen(740, 171)
		If Not $bSuppressLog Then SetLog(" [G]: " & _NumberFormat($iGoldCurrent) & " [E]: " & _NumberFormat($iElixirCurrent) & " [D]: " & _NumberFormat($iDarkCurrent) & " [GEM]: " & _NumberFormat($iGemAmount), $COLOR_GREEN)
	Else
		$iGoldCurrent = getResourcesMainScreen(701, 23)
		$iElixirCurrent = getResourcesMainScreen(701, 74)
		$iGemAmount = getResourcesMainScreen(719, 123)
		If Not $bSuppressLog Then SetLog(" [G]: " & _NumberFormat($iGoldCurrent) & " [E]: " & _NumberFormat($iElixirCurrent) & " [GEM]: " & _NumberFormat($iGemAmount), $COLOR_GREEN)
	EndIf
	If $bBypass = False Then ; update stats
		UpdateStats()
	EndIf

	Local $i = 0
	While _ColorCheck(_GetPixelColor(819, 39, True), Hex(0xF8FCFF, 6), 20) = True ; wait for Builder/shop to close
		$i += 1
		If _Sleep($iDelayVillageReport1) Then Return
		If $i >= 20 Then ExitLoop
	WEnd

EndFunc   ;==>VillageReport
