; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Stats" tab under the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), kaganus (2015), Boju (2016), TheRevenor (2016), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_STATS = 0, $g_hGUI_STATS_TAB = 0, $g_hGUI_STATS_TAB_ITEM1 = 0, $g_hGUI_STATS_TAB_ITEM2 = 0, $g_hGUI_STATS_TAB_ITEM3 = 0, $g_hGUI_STATS_TAB_ITEM4 = 0, $g_hGUI_STATS_TAB_ITEM5 = 0
Global $btnResetStats = 0

; Gain
Global $g_ahPicTHLevels[17], $g_hLblTHLevels = 0
Global $g_ahPicLeague[$eLeagueCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0], $g_hLblLeague = 0
Global $g_ahLblStatsStartedWith[$eLootCount] = [0, 0, 0, 0], $g_ahLblStatsGainPerHour[$eLootCount] = [0, 0, 0, 0]
Global $g_ahLblStatsTotalGain[$eLootCount] = [0, 0, 0, 0], $g_ahLblStatsLastAttack[$eLootCount] = [0, 0, 0, 0]
Global $g_ahLblStatsBonusLast[$eLootCount] = [0, 0, 0, 0], $g_ahLblStatsTop[$eLootCount] = [0, 0, 0, 0]
Global $g_hPicResultDEStart = 0, $g_hLblStatsSZRev1 = 0, $g_hLblStatsSZRev2 = 0, $g_hPicHourlyStatsDark = 0, $g_hPicDarkLoot = 0, $g_hPicDarkLastAttack = 0

; Misc
Global $g_hLblResultRuntime = 0, $g_hLblNbrOfOoS = 0, $g_hLblResultVillagesAttacked = 0, $g_hLblResultVillagesSkipped = 0, $g_hLblResultTrophiesDropped = 0
Global $g_hLblSearchCost = 0, $g_hLblTrainCostElixir = 0, $g_hLblTrainCostDElixir = 0, $g_hLblTrainCostGold = 0, $g_hLblGoldFromMines = 0, $g_hLblElixirFromCollectors = 0, $g_hLblDElixirFromDrills = 0
Global $g_hLblWallGoldMake = 0, $g_hLblWallElixirMake = 0, $g_hLblNbrOfBuildingUpgGold = 0, $g_hLblNbrOfBuildingUpgElixir = 0, $g_hLblNbrOfBuildingUpgDElixir = 0, $g_hLblNbrOfHeroUpg = 0, $g_hLblNbrOfWardenUpg = 0
Global $g_hLblWallUpgCostGold = 0, $g_hLblWallUpgCostElixir = 0, $g_hLblBuildingUpgCostGold = 0, $g_hLblBuildingUpgCostElixir = 0, $g_hLblBuildingUpgCostDElixir = 0, $g_hLblHeroUpgCost = 0, $g_hLblWardenUpgCost = 0

; Attacks
Global $g_hLblAttacked[$g_iModeCount] = [0, 0, 0], $g_hLblTotalGoldGain[$g_iModeCount] = [0, 0, 0], $g_hLblTotalElixirGain[$g_iModeCount] = [0, 0, 0], _
	   $g_hLblTotalDElixirGain[$g_iModeCount] = [0, 0, 0], $g_hLblTotalTrophyGain[$g_iModeCount] = [0, 0, 0], $g_hLblNbrOfTSSuccess = 0, $g_hLblNbrOfTSFailed = 0
Global $g_hLblNbrOfDetectedMines[$g_iModeCount] = [0, 0, 0], $g_hLblNbrOfDetectedCollectors[$g_iModeCount] = [0, 0, 0], _
	   $g_hLblNbrOfDetectedDrills[$g_iModeCount] = [0, 0, 0], $g_hLblSmartZap = 0, $g_hLblSmartLightningUsed = 0, $g_hLblSmartEarthQuakeUsed = 0

; Donations
Global $g_hLblDonTroop[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hLblDonSpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hLblDonSiegel[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0, 0]
Global $g_hLblTotalTroopsQ = 0, $g_hLblTotalTroopsXP = 0, $g_hLblTotalSiegesQ = 0, $g_hLblTotalSiegesXP = 0, $g_hLblTotalSpellsQ = 0, $g_hLblTotalSpellsXP = 0

; Multi Stats
Global $g_ahGrpVillageAcc[8], $g_ahGrpDefaultAcc[8], $g_ahGrpReportAcc[8], $g_ahGrpStatsAcc[8], $g_ahGrpStats2Acc[8]
Global $g_ahLblResultGoldNowAcc[8], $g_ahPicResultGoldNowAcc[8], $g_ahLblResultTrophyNowAcc[8], $g_ahPicResultTrophyNowAcc[8]
Global $g_ahPic2ResultGoldNowAcc[8], $g_ahPic2ResultElixirNowAcc[8], $g_ahPic2ResultDENowAcc[8]
Global $g_ahLblResultElixirNowAcc[8], $g_ahPicResultElixirNowAcc[8], $g_ahLblResultBuilderNowAcc[8], $g_ahPicResultBuilderNowAcc[8]
Global $g_ahLblResultDENowAcc[8], $g_ahPicResultDENowAcc[8], $g_ahLblResultGemNowAcc[8], $g_ahPicResultGemNowAcc[8]
Global $g_ahLblHourlyStatsGoldAcc[8], $g_ahLblResultRuntimeNowAcc[8], $g_ahPicResultRuntimeNowAcc[8]
Global $g_ahLblHourlyStatsElixirAcc[8], $g_ahLblResultAttacked[8], $g_ahPicResultAttacked[8]
Global $g_ahLblHourlyStatsDarkAcc[8], $g_ahLblResultSkipped[8], $g_ahPicResultSkipped[8]
Global $g_ahPicArrowLeft[8], $g_ahPicArrowRight[8]
Global $g_ahPicResultGoldTemp[8], $g_ahPicResultElixirTemp[8], $g_ahPicResultDETemp[8], $g_ahLblVillageReportTemp[8], $g_ahGrpTempAcc[8]
Global $g_ahLblTroopTime[8], $g_ahPicTroopTime[8], $g_ahLblTroopTimeRep[8], $g_ahPicTroopTimeRep[8]
Global $g_ahLblLabTime[8], $g_ahPicLabTime[8], $g_ahLbLPetTime[8], $g_ahPicPetTime[8], $g_ahLbLStarLabTime[8], $g_ahPicStarLabTime[8]
Global $g_ahLbLLootCCGold[8], $g_ahPicResultCCGold[8], $g_ahLbLLootCCMedal[8], $g_ahPicResultCCMedal[8], $g_ahLblResultBBuilderNowAcc[8]
Global $g_ahLbLLootBB[8][3], $g_ahPicResultLootBBGold[8], $g_ahPicResultLootBBElix[8], $g_ahPicResultLootBBTr[8],$g_ahPicResultBBuilderNowAcc[8]
Global $g_ahLblTrophiesCC[8], $g_ahPicTrophiesCC[8]

Func CreateBotStats()

	;GUISetBkColor($COLOR_WHITE, $g_hGUI_STATS)
	GUISwitch($g_hGUI_STATS)
	$g_hGUI_STATS_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$btnResetStats = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "BtnResetStats", "Reset Stats"), 375, 0, 60, 20)
		GUICtrlSetOnEvent(-1, "btnResetStats")
		GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hGUI_STATS_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05_STab_01", "Gain"))
		CreateGainSubTab()
	$g_hGUI_STATS_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05_STab_02", "Misc"))
		CreateMiscSubTab()
	$g_hGUI_STATS_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05_STab_03", "Attacks"))
		CreateAttacksSubTab()
	$g_hGUI_STATS_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05_STab_04", "Donations"))
		CreateDonationsSubTab()
	$g_hGUI_STATS_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05_STab_05", "Multi Stats"))
		CreateMultiStatsSubTab()
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateBotStats

#Region Gain SubTab
Func CreateGainSubTab()
	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	Local $x = $xStart, $y = $yStart
	GUICtrlCreatePic(@ScriptDir & "\images\Stats\Stats001.jpg", $x - 18, $y - 20, 426, 80)

	$x = $xStart + 276
	$y = $yStart - 14
	;Boju Display TH Level in Stats
	$g_ahPicTHLevels[4] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV04, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[5] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV05, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[6] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV06, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[7] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV07, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[8] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV08, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[9] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV09, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[10] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV10, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[11] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV11, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[12] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV12, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[13] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV13, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[14] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV14, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[15] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV15, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[16] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV16, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "LblTownhall", "TownHall"), $x - 11, $y, -1, -1, $SS_CENTER)

	;-->Display TH Level in Stats
	$g_hLblTHLevels = GUICtrlCreateLabel("", $x + 38, $y + 53, 17, 17, $SS_CENTER)
	GUICtrlSetFont($g_hLblTHLevels, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 340
	$y = $yStart - 14
	;Display League in Stats ==>
	$g_ahPicLeague[$eLeagueUnranked] = _GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_SHOW)
	$g_ahPicLeague[$eLeagueBronze] = _GUICtrlCreateIcon($g_sLibIconPath, $eBronze, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueSilver] = _GUICtrlCreateIcon($g_sLibIconPath, $eSilver, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueGold] = _GUICtrlCreateIcon($g_sLibIconPath, $eGold, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueCrystal] = _GUICtrlCreateIcon($g_sLibIconPath, $eCrystal, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueMaster] = _GUICtrlCreateIcon($g_sLibIconPath, $eMaster, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueChampion] = _GUICtrlCreateIcon($g_sLibIconPath, $eLChampion, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueTitan] = _GUICtrlCreateIcon($g_sLibIconPath, $eTitan, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueLegend] = _GUICtrlCreateIcon($g_sLibIconPath, $eLegend, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLeague", "League"), $x + 3, $y, -1, -1, $SS_CENTER)

	;-->Display League Level in Stats
	$g_hLblLeague = GUICtrlCreateLabel("", $x + 43, $y + 53, 17, 17, $SS_CENTER)
	GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 100
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStats", "Stats"), $x - 20, $y - 32, 87, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblGold", "Gold"), $x - 18 + 85, $y - 32, 95, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblElixir", "Elixir"), $x - 18 + (60 * 3), $y - 32, 75, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDarkE", "DarkE"), $x - 23 + (65 * 4), $y - 32, 90, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTrophy", "Trophy"), $x - 23 + (70 * 5), $y - 32, 75, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStartedWith", "Started with") & ":", $x - 15, $y - 11, -1, -1)
	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsStartedWith_Info_01", "The amount of Gold you had when the bot started.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsStartedWith[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsStartedWith_Info_02", "The amount of Elixir you had when the bot started.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsStartedWith[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hPicResultDEStart = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsStartedWith_Info_03", "The amount of Dark Elixir you had when the bot started.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsStartedWith[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsStartedWith_Info_04", "The amount of Trophies you had when the bot started.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsStartedWith[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 125
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblGainPerHour", "Gain per Hour") & ":", $x - 15, $y - 11, -1, -1)

	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsGainPerHour_Info_01", "Gold gain per hour")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsGainPerHour[$eLootGold] = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsGainPerHour_Info_02", "Elixir gain per hour")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsGainPerHour[$eLootElixir] = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hPicHourlyStatsDark = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsGainPerHour_Info_03", "Dark Elixir gain per hour")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsGainPerHour[$eLootDarkElixir] = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsGainPerHour_Info_04", "Trophy gain per hour")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsGainPerHour[$eLootTrophy] = GUICtrlCreateLabel("0/h", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 150
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTotalGain", "Total Gain") & ":", $x - 15, $y - 11, -1, -1)
	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_01", "The total amount of Gold you gained or lost while the Bot is running.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_02", "(This includes manual spending of resources on upgrade of buildings)")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTotalGain[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_03", "The total amount of Elixir you gained or lost while the Bot is running.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_02", "(This includes manual spending of resources on upgrade of buildings)")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTotalGain[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hPicDarkLoot = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_04", "The total amount of Dark Elixir you gained or lost while the Bot is running.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_02", "(This includes manual spending of resources on upgrade of buildings)")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTotalGain[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_05", "The amount of Trophies you gained or lost while the Bot is running.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTotalGain[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 195
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLastAttack", "Last Attack") & ":", $x - 15, $y - 11, -1, -1)
	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsLastAttack_Info_01", "The amount of Gold you gained on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsLastAttack[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsLastAttack_Info_02", "The amount of Elixir you gained on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsLastAttack[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hPicDarkLastAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsLastAttack_Info_03", "The amount of Dark Elixir you gained on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsLastAttack[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsLastAttack_Info_04", "The amount of Trophies you gained or lost on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsLastAttack[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 220
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLeagueBonus", "League Bonus") & ":", $x - 15, $y - 11, -1, -1)
	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsBonusLast_Info_01", "The amount of Bonus Gold you gained on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsBonusLast[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsBonusLast_Info_02", "The amount of Bonus Elixir you gained on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsBonusLast[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsBonusLast_Info_03", "The amount of Bonus Dark Elixir you gained on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsBonusLast[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 265
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTopLoot", "Top Loot") & ":", $x - 15, $y - 11, -1, -1)

	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTop_Info_01", "Top Gold gained")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTop[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTop_Info_02", "Top Elixir gained")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTop[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTop_Info_03", "Top Dark gained")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTop[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTop_Info_04", "Top Trophy gained")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTop[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateGainSubTab
#EndRegion Gain SubTab

#Region Misc SubTab
Func CreateMiscSubTab()
	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	Local $x = $xStart + 3, $y = $yStart + 20
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblRun", "Run"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblCost-Collect", "Cost && Collect"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x -= 10
	$y -= 10
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblRuntime_Info_01", "The total Running Time of the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblRuntime", "Runtime") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblResultRuntime = GUICtrlCreateLabel("00:00:00", $x + 35, $y + 2, 150, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnRecycle, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblNbr-of-OoS_Info_01", "The number of Out of Sync error occurred")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblNbr-of-OoS", "Nbr of OoS") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblNbrOfOoS = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblAttacked_Info_01", "The No. of Villages that were attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblAttacked", "Attacked") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblResultVillagesAttacked = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgX, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblSkipped_Info_01", "The No. of Villages that were skipped during search by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblSkipped", "Skipped") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblResultVillagesSkipped = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDropped_Info_01", "The amount of Trophies dropped by the Bot due to Trophy Settings (on Misc Tab).")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDropped", "Dropped") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblResultTrophiesDropped = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 25
	$y += 5
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMagnifier, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblSearch-Cost_Info_01", "Search cost for skipping villages in gold")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblSearch-Cost", "Search Cost") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblSearchCost = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblGold-collected_Info_01", "Gold gained by collecting mines")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblGold-collected", "Gold collected") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblGoldFromMines = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblElixir-collected_Info_01", "Elixir gained by collecting collectors")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblElixir-collected", "Elixir collected") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblElixirFromCollectors = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDElixir-collected_Info_01", "Dark Elixir gained by collecting drills")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDElixir-collected", "DElixir collected") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblDElixirFromDrills = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 5
	$y = $yStart + 185
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblUpgrades-Made", "Upgrades Made"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblUpgrade-Costs", "Upgrade Costs"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xD4D4D4)

	$x -= 10
	$y -= 10
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallGold, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-by-Gold_Info_01", "The No. of Walls upgraded by Gold.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblUpg-by-Gold", "Upg. by Gold") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblWallGoldMake = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallElixir, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-by-Elixir_Info_01", "The No. of Walls upgraded by Elixir.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblUpg-by-Elixir", "Upg. by Elixir") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblWallElixirMake = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgGold, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBuilUpg-by-Gold_Info_01", "The number of buildings upgraded using gold")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblUpg-by-Gold", "Upg. by Gold") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblNbrOfBuildingUpgGold = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgElixir, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBuilUpg-by-Elixir_Info_01", "The number of buildings upgraded using elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblUpg-by-Elixir", "Upg. by Elixir") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblNbrOfBuildingUpgElixir = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMonolith, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBuilUpg-by-Dark_Info_01", "The number of buildings upgraded using dark elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblUpg-by-DElixir", "Upg. by DElixir") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblNbrOfBuildingUpgDElixir = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHeroes, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblHeroesUpg_Info_01", "The number of dark heroes upgraded")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblHeroesUpg", "Dark Hero Upgrade") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblNbrOfHeroUpg = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWardenUpgr, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWardenUpg_Info_01", "The number of Grand Warden upgraded")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWardenUpg", "Warden Upgrade") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblNbrOfWardenUpg = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 185
	$y -= 10
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallGold, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-Cost-by-Gold_Info_01", "The cost of gold used by bot while upgrading walls")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-Cost-by-Gold", "Upg. Cost Gold") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblWallUpgCostGold = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallElixir, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-Cost-by-Elixir_Info_01", "The cost of elixir used by bot while upgrading walls")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-Cost-by-Elixir", "Upg. Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblWallUpgCostElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgGold, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBuilUpg-Cost-by-Gold_Info_01", "The cost of gold used by bot while upgrading buildings")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-Cost-by-Gold", "Upg. Cost Gold") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblBuildingUpgCostGold = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgElixir, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBuilUpg-Cost-by-Elixir_Info_01", "The cost of elixir used by bot while upgrading buildings")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-Cost-by-Elixir", "Upg. Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblBuildingUpgCostElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMonolith, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBuilUpg-Cost-by-DElixir_Info_01", "The cost of dark elixir used by bot while upgrading buildings")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWallUpg-Cost-by-DElixir", "Upg. Cost DElixir") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblBuildingUpgCostDElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHeroes, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblheroesUpg-Cost_Info_01", "The cost of dark elixir used by bot while upgrading dark heroes")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblheroesUpg-Cost", "Upg. Cost DElixir") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblHeroUpgCost = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWardenUpgr, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWardenUpg-Cost_Info_01", "The cost of elixir used by bot while upgrading Grand Warden")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblWardenUpg-Cost", "Upg. Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblWardenUpgCost = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$x -= 20
	$y -= 85
	GUICtrlCreateLabel("", $x + 28, $y - 180, 5, 280)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateMiscSubTab
#EndRegion Misc SubTab

#Region Attacks SubTab
Func CreateAttacksSubTab()
	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	Local $x = $xStart + 3, $y = $yStart + 20
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base", "Dead Base"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base", "Live Base"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel("", $x + 187, $y - 32, 5, 300)
	GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x -= 10
	$y -= 10
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base_Info_01", "The No. of Dead Base that were attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBase-Attacked", "Attacked") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblAttacked[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Gold_Info_01", "The amount of Gold gained from Dead Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", "gain") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalGoldGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Elixir_Info_01", "The amount of Elixir gained from Dead Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Dark_Info_01", "The amount of Dark Elixir gained from Dead Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalDElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Trophies_Info_01", "The amount of Trophies gained from Dead Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalTrophyGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$x += 30
	$y += 25
	$g_hLblNbrOfDetectedMines[$DB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 20, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
	$g_hLblNbrOfDetectedCollectors[$DB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 20, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
	$g_hLblNbrOfDetectedDrills[$DB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 20, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 79, $y - 4, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 25
	$y -= 15
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base_Info_01", "The No. of Live Base that were attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBase-Attacked", "Attacked") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblAttacked[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Gold_Info_01", "The amount of Gold gained from Live Bases attacked by the Bot")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalGoldGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Elixir_Info_01", "The amount of Elixir gained from Live Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Dark_Info_01", "The amount of Dark Elixir gained from Live Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalDElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Trophy_Info_01", "The amount of Trophy gained from Live Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalTrophyGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$x += 62
	$y += 25
	$g_hLblNbrOfDetectedMines[$LB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 20, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
	$g_hLblNbrOfDetectedCollectors[$LB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 20, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
	$g_hLblNbrOfDetectedDrills[$LB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 20, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 79, $y - 4, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)


	$x = $xStart + 5
	$y = $yStart + 165

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTH-Bully", "TH Bully"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	$g_hLblStatsSZRev2 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSZRev2", "Smart Zap"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x -= 10
	$y -= 10
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTH-Bully_Info_01", "The No. of TH Bully bases that were attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBase-Attacked", "Attacked") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblAttacked[$TB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTH-Bully-Gain-Gold_Info_01", "The amount of Gold gained from TH Bully bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalGoldGain[$TB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTH-Bully-Gain-Elixir_Info_01", "The amount of Elixir gained from TH Bully bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalElixirGain[$TB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTH-Bully-Gain-Dark_Info_01", "The amount of Dark Elixir gained from TH Bully bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalDElixirGain[$TB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTH-Bully-Gain-Trophy_Info_01", "The amount of Trophy gained from TH Bully bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalTrophyGain[$TB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$x += 30
	$y += 25
	$g_hLblNbrOfDetectedMines[$TB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 18, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
	$g_hLblNbrOfDetectedCollectors[$TB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 18, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
	$g_hLblNbrOfDetectedDrills[$TB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 18, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 79, $y - 4, 16, 16)

	$x = $xStart + 180
	$y = $yStart + 165
	$y -= 10
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x + 22, $y, 16, 16)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartLightningUsed_Info_01", "The amount of Lightning Spells used to zap"))
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSZRev2-Used", "Used") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartLightningUsed_Info_01", -1))
	$g_hLblSmartLightningUsed = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartLightningUsed_Info_01", -1))
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthQuakeSpell, $x + 22, $y, 16, 16)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartEarthQuakeUsed_Info_01", "The amount of Earthquake Spells used to zap"))
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSZRev2-Used", -1) & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartEarthQuakeUsed_Info_01", -1))
	$g_hLblSmartEarthQuakeUsed = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartEarthQuakeUsed_Info_01", -1))
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 22, $y, 18, 18)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartZap_Info_01", "The amount of Dark Elixir won while zapping"))
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartZap_Info_01", -1))
	$g_hLblSmartZap = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartZap_Info_01", -1))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttacksSubTab
#EndRegion Attacks SubTab

#Region Donations SubTab
Func CreateDonationsSubTab()
	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 40
	Local $x = $xStart, $y = $yStart + 20
	Local $xOffset = 54
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDon-AllTroops", "All Troops"), $x - 20, $y - 32, 431, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	$x = 5
	$y -= 12
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarbarian, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopBarbarian] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWizard, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopWizard] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElectroDragon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopElectroDragon] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHogRider, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopHogRider] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnIceGolem, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopIceGolem] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSneakyGoblin, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopSneakyGoblin] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperMinion, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopSuperMinion] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperHogRider, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopSuperHogRider] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x = 5
	$y += 28
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnArcher, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopArcher] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealer, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopHealer] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnYeti, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopYeti] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnValkyrie, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopValkyrie] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHeadhunter, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopHeadhunter] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperWallBreaker, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopSuperWallBreaker] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperValkyrie, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopSuperValkyrie] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x = 5
	$y += 28
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGiant, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopGiant] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDragon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopDragon] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDragonRider, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopDragonRider] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGolem, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopGolem] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnAppWard, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopAppWard] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnRocketBalloon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopRocketBalloon] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperWitch, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopSuperWitch] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x = 5
	$y += 28
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoblin, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopGoblin] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPekka, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopPekka] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElectroTitan, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopElectroTitan] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWitch, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopWitch] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperBarbarian, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopSuperBarbarian] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperWizard, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopSuperWizard] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnIceHound, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopIceHound] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x = 5
	$y += 28
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallBreaker, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopWallBreaker] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMinion, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopMinion] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnRootRider, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopRootRider] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLavaHound, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopLavaHound] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperArcher, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopSuperArcher] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperDragon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopSuperDragon] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperBowler, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopSuperBowler] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x = 5
	$y += 28
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBalloon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopBalloon] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMiner, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopMiner] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBabyDragon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopBabyDragon] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBowler, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopBowler] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperGiant, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopSuperGiant] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnInfernoDragon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopInfernoDragon] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperMiner, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonTroop[$eTroopSuperMiner] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 208
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonTotal", "Total Donated") & ":", $x - 20, $y - 32, 217, 15)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hLblTotalTroopsQ = GUICtrlCreateLabel("0", $x + 105, $y - 32, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonTotalXP", "Total XP") & ":", $x - 18 + 212, $y - 32, 216, 15)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hLblTotalTroopsXP = GUICtrlCreateLabel("0", $x + 320, $y - 32, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 231
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDon-Sieges", "Sieges"), $x - 20, $y - 32, 430, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x += 5
	$y -= 12

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallW, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeWallWrecker] = GUICtrlCreateLabel("0", $x + 3, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleB, $x + 47, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 75, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeBattleBlimp] = GUICtrlCreateLabel("0", $x + 60, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnStoneS, $x + 104, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 132, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeStoneSlammer] = GUICtrlCreateLabel("0", $x + 117, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSiegeB, $x + 161, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 189, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeBarracks] = GUICtrlCreateLabel("0", $x + 174, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLogL, $x + 218, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 246, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeLogLauncher] = GUICtrlCreateLabel("0", $x + 231, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnFlameF, $x + 275, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 303, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeFlameFlinger] = GUICtrlCreateLabel("0", $x + 288, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleD, $x + 332, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 360, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeBattleDrill] = GUICtrlCreateLabel("0", $x + 345, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x = $xStart
	$y = $yStart + 279
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonTotal", "Total Donated") & ":", $x - 20, $y - 32, 217, 15)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hLblTotalSiegesQ = GUICtrlCreateLabel("0", $x + 105, $y - 32, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonTotalXP", "Total XP") & ":", $x - 18 + 212, $y - 32, 216, 15)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hLblTotalSiegesXP = GUICtrlCreateLabel("0", $x + 320, $y - 32, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 302
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonElixir-Spells", "Elixir Spells"), $x - 20, $y - 32, 217, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonDark-Spells", "Dark Elixir Spells"), $x - 18 + 212, $y - 32, 216, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x -= 10
	$y -= 12

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellLightning] = GUICtrlCreateLabel("0", $x + 3, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x + 47, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 75, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellHeal] = GUICtrlCreateLabel("0", $x + 60, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x + 104, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 132, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellRage] = GUICtrlCreateLabel("0", $x + 117, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x + 161, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 189, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellJump] = GUICtrlCreateLabel("0", $x + 174, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellFreeze] = GUICtrlCreateLabel("0", $x + 3, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCloneSpell, $x + 47, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 75, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellClone] = GUICtrlCreateLabel("0", $x + 60, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnInvisibilitySpell, $x + 104, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 132, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellInvisibility] = GUICtrlCreateLabel("0", $x + 117, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnRecallSpell, $x + 161, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 189, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellRecall] = GUICtrlCreateLabel("0", $x + 174, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 238
	$y = $yStart + 290

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellPoison] = GUICtrlCreateLabel("0", $x + 3, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthQuakeSpell, $x + 47, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 75, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellEarthquake] = GUICtrlCreateLabel("0", $x + 60, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x + 104, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 132, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellHaste] = GUICtrlCreateLabel("0", $x + 117, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSkeletonSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellSkeleton] = GUICtrlCreateLabel("0", $x + 3, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBatSpell, $x + 47, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 75, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellBat] = GUICtrlCreateLabel("0", $x + 60, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnOvergrowthSpell, $x + 104, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 132, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellOvergrowth] = GUICtrlCreateLabel("0", $x + 117, $y + 4, 40, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x = $xStart
	$y = $yStart + 378
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonTotal", "Total Donated") & ":", $x - 20, $y - 32, 217, 15)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hLblTotalSpellsQ = GUICtrlCreateLabel("0", $x + 105, $y - 32, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonTotalXP", "Total XP") & ":", $x - 18 + 212, $y - 32, 216, 15)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hLblTotalSpellsXP = GUICtrlCreateLabel("0", $x + 320, $y - 32, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 302

	GUICtrlCreateLabel("", $x + 213, $y - 32, 5, 76)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateDonationsSubTab
#EndRegion Donations SubTab

#Region MultiStats SubTab
Func CreateMultiStatsSubTab()

	For $i = 0 To 7
		Local $x = 25
		Local $y = 27

		Local $i_X = Mod($i, 2), $i_Y = Int($i / 2)
		Local $delY = 17, $delY2 = 95, $delX = 90, $delX2 = 215

		$g_ahGrpVillageAcc[$i] = GUICtrlCreateGroup("", $x - 3 + $i_X * $delX2, $y + $i_Y * $delY2, 180, 90)

		; Village report (resource & info)
		$g_ahLblResultGoldNowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicResultGoldNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 75 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)
		$g_ahPic2ResultGoldNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 75 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)
		$g_ahLblResultTrophyNowAcc[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultTrophyNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 60 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)

		$g_ahLblResultElixirNowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicResultElixirNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 75 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
		$g_ahPic2ResultElixirNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 75 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
		$g_ahLblResultBuilderNowAcc[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultBuilderNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilder, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 16, 14)

		$g_ahLblResultDENowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicResultDENowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 75 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 16)
		$g_ahPic2ResultDENowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 75 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 16)
		$g_ahLblResultGemNowAcc[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultGemNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGem, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 14)

		$g_ahLblLabTime[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicLabTime[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnLabUpgrade, $x + 75 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 16, 16)

		$g_ahLbLPetTime[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicPetTime[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetHouse, $x + 75 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 16, 16)

		$g_ahPicArrowLeft[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowLeft, $x - 20 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
		Local $sTxtTip = GetTranslatedFileIni("MBR GUI Design Bottom", "GrpVillage_Info_01", "Switch between village info and stats")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetOnEvent(-1, "SwitchVillageInfo")

		$g_ahPicArrowRight[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowRight, $x + 180 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetOnEvent(-1, "SwitchVillageInfo2")

		; Statistics & Runtime
		$g_ahLblHourlyStatsGoldAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahLblResultRuntimeNowAcc[$i] = GUICtrlCreateLabel("00:00:00", $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultRuntimeNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x + 60 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)

		$g_ahLblHourlyStatsElixirAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahLblResultAttacked[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultAttacked[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 14)

		$g_ahLblHourlyStatsDarkAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahLblResultSkipped[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultSkipped[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgX, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 14)

		$g_ahLblTroopTime[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicTroopTime[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrain, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 15, 14)
		$g_ahLblTroopTimeRep[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicTroopTimeRep[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrain, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 15, 14)

		;Third page
		$g_ahLbLLootBB[$i][$eLootGoldBB] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicResultLootBBGold[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBGold, $x + 75 + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 15, 15)

		$g_ahLbLLootBB[$i][$eLootElixirBB] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicResultLootBBElix[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBElix, $x + 75 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 15, 15)

		$g_ahLbLLootBB[$i][$eLootTrophyBB] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicResultLootBBTr[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBTrophy, $x + 75 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 15, 15)

		$g_ahLbLLootCCGold[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultCCGold[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalGold, $x + 60 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2 - 1, 16, 16)

		$g_ahLbLLootCCMedal[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 2, 55, 17, $SS_RIGHT)
		$g_ahPicResultCCMedal[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalMedal, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)

		$g_ahLbLStarLabTime[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicStarLabTime[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnStarLaboratory, $x + 75 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 15, 16)

		$g_ahLblTrophiesCC[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 2, 55, 17, $SS_RIGHT)
		$g_ahPicTrophiesCC[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalTrophy, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 17, 17)

		$g_ahLblResultBBuilderNowAcc[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultBBuilderNowAcc[$i] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilder, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 15, 14)

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		$g_ahGrpDefaultAcc[$i] = $g_ahGrpVillageAcc[$i] & "#" & $g_ahPicArrowLeft[$i] & "#" & $g_ahPicArrowRight[$i]
		$g_ahGrpReportAcc[$i] = $g_ahLblResultGoldNowAcc[$i] & "#" & $g_ahLblResultTrophyNowAcc[$i] & "#" & $g_ahPicResultTrophyNowAcc[$i] & "#" & _
				$g_ahPicResultGoldNowAcc[$i] & "#" & $g_ahPicResultElixirNowAcc[$i] & "#" & $g_ahPicResultDENowAcc[$i] & "#" & _
				$g_ahLblResultElixirNowAcc[$i] & "#" & $g_ahLblResultBuilderNowAcc[$i] & "#" & $g_ahPicResultBuilderNowAcc[$i] & "#" & _
				$g_ahLblResultDENowAcc[$i] & "#" & $g_ahLblResultGemNowAcc[$i] & "#" & $g_ahPicResultGemNowAcc[$i] & "#" & $g_ahLblLabTime[$i] & "#" & $g_ahPicLabTime[$i] & "#" & _
				$g_ahLblTroopTime[$i] & "#" & $g_ahPicTroopTime[$i]
		$g_ahGrpStatsAcc[$i] = $g_ahLblHourlyStatsGoldAcc[$i] & "#" & $g_ahLblResultRuntimeNowAcc[$i] & "#" & $g_ahPicResultRuntimeNowAcc[$i] & "#" & _
				$g_ahPic2ResultGoldNowAcc[$i] & "#" & $g_ahPic2ResultElixirNowAcc[$i] & "#" & $g_ahPic2ResultDENowAcc[$i] & "#" & _
				$g_ahLblHourlyStatsElixirAcc[$i] & "#" & $g_ahLblResultAttacked[$i] & "#" & $g_ahPicResultAttacked[$i] & "#" & _
				$g_ahLblHourlyStatsDarkAcc[$i] & "#" & $g_ahLblResultSkipped[$i] & "#" & $g_ahPicResultSkipped[$i] & "#" & $g_ahLbLPetTime[$i] & "#" & $g_ahPicPetTime[$i] & "#" & _
				$g_ahLblTroopTimeRep[$i] & "#" & $g_ahPicTroopTimeRep[$i]
		$g_ahGrpStats2Acc[$i] = $g_ahLbLLootCCGold[$i] & "#" & $g_ahPicResultCCGold[$i] & "#" & $g_ahLbLLootBB[$i][$eLootGoldBB] & "#" & $g_ahPicResultLootBBGold[$i] & "#" & _
				$g_ahLbLLootBB[$i][$eLootElixirBB] & "#" & $g_ahPicResultLootBBElix[$i] & "#" & $g_ahLbLLootBB[$i][$eLootTrophyBB] & "#" & $g_ahPicResultLootBBTr[$i] & "#" & _
				$g_ahLbLLootCCMedal[$i] & "#" & $g_ahPicResultCCMedal[$i] & "#" & $g_ahLbLStarLabTime[$i] & "#" & $g_ahPicStarLabTime[$i] & "#" & _
				$g_ahLblTrophiesCC[$i] & "#" & $g_ahPicTrophiesCC[$i] & "#" & $g_ahLblResultBBuilderNowAcc[$i] & "#" & $g_ahPicResultBBuilderNowAcc[$i]

		GUICtrlCreateGroup("", -99, -99, 1, 1)

		_GUI_Value_STATE("HIDE", $g_ahGrpDefaultAcc[$i] & "#" & $g_ahGrpReportAcc[$i] & "#" & $g_ahGrpStatsAcc[$i] & "#" & $g_ahGrpStats2Acc[$i])

	Next
EndFunc   ;==>CreateMultiStatsSubTab
#EndRegion MultiStats SubTab