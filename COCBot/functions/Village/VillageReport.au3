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
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func VillageReport($bBypass = False)
	PureClickP($aAway, 1, 0, "#0319") ;Click Away
	If _Sleep($iDelayVillageReport1) Then Return

	Switch $bBypass
		Case False
			SetLog("Village Report", $COLOR_BLUE)
		Case True
			SetLog("Updating Village Resource Values", $COLOR_BLUE)
		Case Else
			SetLog("Village Report Error, You have been a BAD programmer!", $COLOR_RED)
	EndSwitch

	Local $aGetBuilders = StringSplit(getBuilders($aBuildersDigits[0], $aBuildersDigits[1]), "#", $STR_NOCOUNT)
	$FreeBuilder = $aGetBuilders[0]
	$TotalBuilders = $aGetBuilders[1]
	Setlog("No. of Free/Total Builders: " & $FreeBuilder & "/" & $TotalBuilders, $COLOR_GREEN)

	$TrophyCount = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
	Setlog(" [T]: " & _NumberFormat($TrophyCount), $COLOR_GREEN)

	If _ColorCheck(_GetPixelColor(812, 141, True), Hex(0x000000, 6), 10) Then ; check if the village have a Dark Elixir Storage
		$GoldCount = getResourcesMainScreen(710, 23)
		$ElixirCount = getResourcesMainScreen(710, 74)
		$DarkCount = getResourcesMainScreen(731, 123)
		$GemCount = getResourcesMainScreen(740, 171)
		SetLog(" [G]: " & _NumberFormat($GoldCount) & " [E]: " & _NumberFormat($ElixirCount) & " [D]: " & _NumberFormat($DarkCount) & " [GEM]: " & _NumberFormat($GemCount), $COLOR_GREEN)
	Else
		$GoldCount = getResourcesMainScreen(710, 23)
		$ElixirCount = getResourcesMainScreen(710, 74)
		$GemCount = getResourcesMainScreen(719, 123)
		SetLog(" [G]: " & _NumberFormat($GoldCount) & " [E]: " & _NumberFormat($ElixirCount) & " [GEM]: " & _NumberFormat($GemCount), $COLOR_GREEN)
	EndIf
	If $bBypass = False Then ; update stats
		Switch $FirstAttack
			Case 2
				ReportLastTotal()
				ReportCurrent()
			Case 1
				;			GUICtrlSetState($lblLastAttackTemp, $GUI_HIDE)
				GUICtrlSetState($lblTotalLootTemp, $GUI_HIDE)
				ReportLastTotal()
				ReportCurrent()
				$FirstAttack = 2
			Case 0
				ReportStart()
				ReportCurrent()
				$FirstAttack = 1
		EndSwitch
	EndIf

	Local $i = 0
	While _ColorCheck(_GetPixelColor(819, 39, True), Hex(0xF8FCFF, 6), 20) = True ; wait for Builder/shop to close
		$i += 1
		If _Sleep($iDelayVillageReport1) Then Return
		If $i >= 20 Then ExitLoop
	WEnd

EndFunc   ;==>VillageReport

Func ReportStart() ; stats at Start

	$GoldStart = $GoldCount
	$ElixirStart = $ElixirCount
	$DarkStart = $DarkCount
	$TrophyStart = $TrophyCount

	GUICtrlSetState($lblResultStatsTemp, $GUI_HIDE)
	GUICtrlSetState($lblVillageReportTemp, $GUI_HIDE)
	GUICtrlSetState($picResultGoldTemp, $GUI_HIDE)
	GUICtrlSetState($picResultElixirTemp, $GUI_HIDE)
	GUICtrlSetState($picResultDETemp, $GUI_HIDE)

	GUICtrlSetState($lblResultGoldNow, $GUI_SHOW)
	GUICtrlSetState($picResultGoldNow, $GUI_SHOW)
	GUICtrlSetData($lblResultGoldStart, _NumberFormat($GoldCount))

	GUICtrlSetState($lblResultElixirNow, $GUI_SHOW)
	GUICtrlSetState($picResultElixirNow, $GUI_SHOW)
	GUICtrlSetData($lblResultElixirStart, _NumberFormat($ElixirCount))

	If $DarkCount <> "" Then
		GUICtrlSetData($lblResultDEStart, _NumberFormat($DarkCount))
		GUICtrlSetState($lblResultDeNow, $GUI_SHOW)
		GUICtrlSetState($picResultDeNow, $GUI_SHOW)
	Else
		GUICtrlSetState($picResultDEStart, $GUI_HIDE)
		GUICtrlSetState($picDarkLoot, $GUI_HIDE)
		GUICtrlSetState($picDarkLastAttack, $GUI_HIDE)
	EndIf

	GUICtrlSetData($lblResultTrophyStart, _NumberFormat($TrophyCount))
	GUICtrlSetState($lblResultTrophyNow, $GUI_SHOW)
	GUICtrlSetState($lblResultBuilderNow, $GUI_SHOW)
	GUICtrlSetState($lblResultGemNow, $GUI_SHOW)

EndFunc   ;==>ReportStart

Func ReportCurrent()

	$GoldVillage = $GoldCount
	$ElixirVillage = $ElixirCount
	$DarkVillage = $DarkCount
	$TrophyVillage = $TrophyCount

	GUICtrlSetData($lblResultGoldNow, _NumberFormat($GoldCount))
	GUICtrlSetData($lblResultElixirNow, _NumberFormat($ElixirCount))

	If $DarkCount <> "" Then
		GUICtrlSetData($lblResultDeNow, _NumberFormat($DarkCount))
	EndIf

	GUICtrlSetData($lblResultTrophyNow, _NumberFormat($TrophyCount))
	GUICtrlSetData($lblResultBuilderNow, $FreeBuilder & "/" & $TotalBuilders)
	GUICtrlSetData($lblResultGemNow, _NumberFormat($GemCount))

EndFunc   ;==>ReportCurrent

Func ReportLastTotal()

	;last attack
	;	$GoldLast = $GoldCount - $GoldVillage
	;	$ElixirLast = $ElixirCount - $ElixirVillage
	;	$DarkLast = $DarkCount - $DarkVillage
	;	$TrophyLast = $TrophyCount - $TrophyVillage


	;	GUICtrlSetData($lblGoldLastAttack, _NumberFormat($GoldLast))
	;	GUICtrlSetData($lblElixirLastAttack, _NumberFormat($ElixirLast))
	;	If $DarkStart <> "" Then
	;		GUICtrlSetData($lblDarkLastAttack, _NumberFormat($DarkLast))
	;	EndIf
	;	GUICtrlSetData($lblTrophyLastAttack, _NumberFormat($TrophyLast))

	;total stats
	$CostGoldWall = $WallGoldMake * $WallCost
	$CostElixirWall = $WallElixirMake * $WallCost

	$iGoldLoot = $CostGoldUpgrades + $GoldCount + $CostGoldWall - $GoldStart
	$iElixirLoot = $CostElixirUpgrades + $ElixirCount + $CostElixirWall - $ElixirStart
	$iDarkLoot = $CostDElixirUpgrades + $DarkCount - $DarkStart
	$iTrophyLoot = $TrophyCount - $TrophyStart

	GUICtrlSetData($lblGoldLoot, _NumberFormat($iGoldLoot))
	GUICtrlSetData($lblElixirLoot, _NumberFormat($iElixirLoot))
	If $DarkStart <> "" Then
		GUICtrlSetData($lblDarkLoot, _NumberFormat($iDarkLoot))
	EndIf
	GUICtrlSetData($lblTrophyLoot, _NumberFormat($iTrophyLoot))

EndFunc   ;==>ReportLastTotal
