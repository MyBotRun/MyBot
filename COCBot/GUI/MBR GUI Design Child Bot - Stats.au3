; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Stats" tab under the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), kaganus (2015), Boju (2016), TheRevenor (2016), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_STATS = 0, $g_hGUI_STATS_TAB = 0, $g_hGUI_STATS_TAB_ITEM1 = 0, $g_hGUI_STATS_TAB_ITEM2 = 0, $g_hGUI_STATS_TAB_ITEM3 = 0, $g_hGUI_STATS_TAB_ITEM4 = 0
Global $btnResetStats = 0

; Gain
Global $g_ahPicTHLevels[12], $g_hLblTHLevels = 0
Global $g_ahPicLeague[$eLeagueCount] = [0,0,0,0,0,0,0,0,0], $g_hLblLeague = 0
Global $g_ahLblStatsStartedWith[$eLootCount] = [0,0,0,0], $g_ahLblStatsGainPerHour[$eLootCount] = [0,0,0,0]
Global $g_ahLblStatsTotalGain[$eLootCount] = [0,0,0,0], $g_ahLblStatsLastAttack[$eLootCount] = [0,0,0,0]
Global $g_ahLblStatsBonusLast[$eLootCount] = [0,0,0,0], $g_ahLblStatsTop[$eLootCount] = [0,0,0,0]
Global $g_hPicResultDEStart = 0, $g_hLblStatsSZRev1 = 0, $g_hLblStatsSZRev2 = 0, $g_hPicHourlyStatsDark = 0, $g_hPicDarkLoot = 0, $g_hPicDarkLastAttack = 0

; Misc
Global $g_hLblResultRuntime = 0, $g_hLblNbrOfOoS = 0, $g_hLblResultVillagesAttacked = 0, $g_hLblResultVillagesSkipped = 0, $g_hLblResultTrophiesDropped = 0
Global $g_hLblSearchCost = 0, $g_hLblTrainCostElixir = 0, $g_hLblTrainCostDElixir = 0, $g_hLblGoldFromMines = 0, $g_hLblElixirFromCollectors = 0, $g_hLblDElixirFromDrills = 0
Global $g_hLblWallGoldMake = 0, $g_hLblWallElixirMake = 0, $g_hLblNbrOfBuildingUpgGold = 0, $g_hLblNbrOfBuildingUpgElixir = 0, $g_hLblNbrOfHeroUpg = 0
Global $g_hLblWallUpgCostGold = 0, $g_hLblWallUpgCostElixir = 0, $g_hLblBuildingUpgCostGold = 0, $g_hLblBuildingUpgCostElixir = 0, $g_hLblHeroUpgCost = 0

; Attacks
Global $g_hLblAttacked[$g_iModeCount + 3] = [0,0,0,0,0,0], $g_hLblTotalGoldGain[$g_iModeCount + 3] = [0,0,0,0,0,0], $g_hLblTotalElixirGain[$g_iModeCount + 3] = [0,0,0,0,0,0], _
	   $g_hLblTotalDElixirGain[$g_iModeCount + 3] = [0,0,0,0,0,0], $g_hLblTotalTrophyGain[$g_iModeCount + 3] = [0,0,0,0,0,0], $g_hLblNbrOfTSSuccess = 0, $g_hLblNbrOfTSFailed = 0
Global $g_hLblNbrOfDetectedMines[$g_iModeCount + 3] = [0,0,0,0,0,0], $g_hLblNbrOfDetectedCollectors[$g_iModeCount + 3] = [0,0,0,0,0,0], _
	   $g_hLblNbrOfDetectedDrills[$g_iModeCount + 3] = [0,0,0,0,0,0], $g_hLblSmartZap = 0, $g_hLblSmartLightningUsed = 0, $g_hLblSmartEarthQuakeUsed = 0

; Donations
Global $g_hLblDonTroop[$eTroopCount] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hLblDonSpell[$eSpellCount] = [0,0,0,0,0,0,0,0,0,0]
Global $g_hLblTotalTroopsQ = 0, $g_hLblTotalTroopsXP = 0, $g_hLblTotalSpellsQ = 0, $g_hLblTotalSpellsXP = 0

Func CreateBotStats()
   ;GUISetBkColor($COLOR_WHITE, $g_hGUI_STATS)

   GUISwitch($g_hGUI_STATS)
   $g_hGUI_STATS_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
   $btnResetStats = GUICtrlCreateButton(GetTranslated(632,31, "Reset Stats"), 375, 0, 60, 20)
	  GUICtrlSetOnEvent(-1, "btnResetStats")
	  GUICtrlSetState(-1, $GUI_DISABLE)
   $g_hGUI_STATS_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,38,"Gain"))
   CreateGainSubTab()
   $g_hGUI_STATS_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,39,"Misc"))
   CreateMiscSubTab()
   $g_hGUI_STATS_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600,40,"Attacks"))
   CreateAttacksSubTab()
   $g_hGUI_STATS_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslated(600, 55,"Donations"))
   CreateDonationsSubTab()
   GUICtrlCreateTabItem("")
EndFunc

#Region Gain SubTab
Func CreateGainSubTab()
	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	Local $x = $xStart, $y = $yStart
		GUICtrlCreatePic(@ScriptDir & "\images\Stats\Stats001.jpg", $x - 18, $y - 20, 426, 80)

	$x = $xStart + 276
	$y = $yStart - 14
	;Boju Display TH Level in Stats
	;$g_ahPicTHLevels = GUICtrlCreateGroup(GetTranslated(632,0, "TownHall"), $x - 15, $y - 15, 70, 90)
		$g_ahPicTHLevels[4] = GUICtrlCreateIcon($g_sLibIconPath, $eHdV04, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicTHLevels[5] = GUICtrlCreateIcon($g_sLibIconPath, $eHdV05, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicTHLevels[6] = GUICtrlCreateIcon($g_sLibIconPath, $eHdV06, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicTHLevels[7] = GUICtrlCreateIcon($g_sLibIconPath, $eHdV07, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicTHLevels[8] = GUICtrlCreateIcon($g_sLibIconPath, $eHdV08, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicTHLevels[9] = GUICtrlCreateIcon($g_sLibIconPath, $eHdV09, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicTHLevels[10] = GUICtrlCreateIcon($g_sLibIconPath, $eHdV10, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicTHLevels[11] = GUICtrlCreateIcon($g_sLibIconPath, $eHdV11, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)

		GUICtrlCreateLabel(GetTranslated(632,0, "TownHall"), $x - 11, $y, -1, -1, $SS_CENTER)

		;-->Display TH Level in Stats
		$g_hLblTHLevels = GUICtrlCreateLabel("", $x + 38, $y + 53, 17, 17, $SS_CENTER)
		GUICtrlSetFont($g_hLblTHLevels, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 340
	$y = $yStart - 14
	;Display League in Stats ==>
	;$grpLeague = GUICtrlCreateGroup(GetTranslated(632,106, "League"), $x - 5, $y - 15, 70, 90)
		$g_ahPicLeague[$eLeagueUnranked] = GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_SHOW)
		$g_ahPicLeague[$eLeagueBronze] = GUICtrlCreateIcon($g_sLibIconPath, $eBronze, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicLeague[$eLeagueSilver] = GUICtrlCreateIcon($g_sLibIconPath, $eSilver, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicLeague[$eLeagueGold] = GUICtrlCreateIcon($g_sLibIconPath, $eGold, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicLeague[$eLeagueCrystal] = GUICtrlCreateIcon($g_sLibIconPath, $eCrystal, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicLeague[$eLeagueMaster] = GUICtrlCreateIcon($g_sLibIconPath, $eMaster, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicLeague[$eLeagueChampion] = GUICtrlCreateIcon($g_sLibIconPath, $eChampion, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicLeague[$eLeagueTitan] = GUICtrlCreateIcon($g_sLibIconPath, $eTitan, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$g_ahPicLeague[$eLeagueLegend] = GUICtrlCreateIcon($g_sLibIconPath, $eLegend, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)

		GUICtrlCreateLabel(GetTranslated(632,106, "League"), $x + 3, $y, -1, -1, $SS_CENTER)

		;-->Display League Level in Stats
		$g_hLblLeague = GUICtrlCreateLabel("", $x + 43, $y + 53, 17, 17, $SS_CENTER)
		GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 100
		GUICtrlCreateLabel(GetTranslated(632, 107, "Stats"), $x - 20, $y - 32, 87, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslated(632, 108, "Gold"), $x - 18 + 85, $y - 32, 95, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslated(632, 109, "Elixir"), $x - 18 + (60 * 3), $y - 32, 75, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslated(632, 110, "DarkE"), $x - 23 + (65 * 4), $y - 32, 90, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslated(632, 111, "Trophy"), $x - 23 + (70 * 5), $y - 32, 75, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)

	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		GUICtrlCreateLabel(GetTranslated(632, 2, "Started with") & ":", $x - 15, $y - 11, - 1, - 1)
		;GUICtrlCreateLabel(GetTranslated(632, 3, "Report") & @CRLF & GetTranslated(632, 4, "will appear") & @CRLF & GetTranslated(632, 5, "here on") & @CRLF & GetTranslated(632, 6, "first run."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))

	$x += 85
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632, 7, "The amount of Gold you had when the bot started.")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsStartedWith[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632, 8, "The amount of Elixir you had when the bot started.")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsStartedWith[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		$g_hPicResultDEStart = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632, 9, "The amount of Dark Elixir you had when the bot started.")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsStartedWith[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632, 10, "The amount of Trophies you had when the bot started.")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsStartedWith[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 125
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		GUICtrlCreateLabel(GetTranslated(632,26, "Gain per Hour") & ":", $x - 15, $y - 11, - 1, - 1)
		;$lblHourlyStatsTemp = GUICtrlCreateLabel(GetTranslated(632,3, "Report") & @CRLF & GetTranslated(632,99, "will update") & @CRLF & GetTranslated(632,97, "here after") & @CRLF & GetTranslated(632,98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))

	$x += 85
		 GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632,27, "Gold gain per hour")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsGainPerHour[$eLootGold] = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632,28, "Elixir gain per hour")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsGainPerHour[$eLootElixir] = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		$g_hPicHourlyStatsDark = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632,29, "Dark Elixir gain per hour")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsGainPerHour[$eLootDarkElixir] = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632,30, "Trophy gain per hour")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsGainPerHour[$eLootTrophy] = GUICtrlCreateLabel("0/h", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 150
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		GUICtrlCreateLabel(GetTranslated(632,20, "Total Gain") & ":", $x - 15, $y - 11, - 1, - 1)
		;$lblTotalLootTemp = GUICtrlCreateLabel(GetTranslated(632,3, "Report") & @CRLF & GetTranslated(632,99, "will update") & @CRLF & GetTranslated(632,97, "here after") & @CRLF & GetTranslated(632,98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
	$x += 85
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632,21, "The total amount of Gold you gained or lost while the Bot is running.") & @CRLF & _
				   GetTranslated(632,22, "(This includes manual spending of resources on upgrade of buildings)")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTotalGain[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632,23, "The total amount of Elixir you gained or lost while the Bot is running.") & @CRLF & _
				   GetTranslated(632,22, "(This includes manual spending of resources on upgrade of buildings)")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTotalGain[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		$g_hPicDarkLoot = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632,24, "The total amount of Dark Elixir you gained or lost while the Bot is running.") & @CRLF & _
				   GetTranslated(632,22, "(This includes manual spending of resources on upgrade of buildings)")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTotalGain[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632,25, "The amount of Trophies you gained or lost while the Bot is running.")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTotalGain[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 195
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		GUICtrlCreateLabel(GetTranslated(632,102,"Last Attack") & ":", $x - 15, $y - 11, - 1, - 1)
		;$lblLastAttackTemp = GUICtrlCreateLabel(GetTranslated(632, 3, "Report") & @CRLF & _
		 ;									    GetTranslated(632, 4, "will appear") & @CRLF & _
		 ;										GetTranslated(632, 97, "here after") & @CRLF & _
		 ;										GetTranslated(632, 98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
	$x += 85
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632, 12, "The amount of Gold you gained on the last attack.")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsLastAttack[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632, 13, "The amount of Elixir you gained on the last attack.")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsLastAttack[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

   $x += 85
		$g_hPicDarkLastAttack = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632,14, "The amount of Dark Elixir you gained on the last attack.")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsLastAttack[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

   $x += 75
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632,15, "The amount of Trophies you gained or lost on the last attack.")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsLastAttack[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 220
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		GUICtrlCreateLabel(GetTranslated(632,16, "League Bonus") & ":", $x - 15, $y - 11, - 1, - 1)
		;$lblLastAttackBonusTemp = GUICtrlCreateLabel(GetTranslated(632,3, "Report") & @CRLF & GetTranslated(632,99, "will update") & @CRLF & GetTranslated(632,97, "here after") & @CRLF & GetTranslated(632,98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
	$x += 85
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632,17, "The amount of Bonus Gold you gained on the last attack.")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsBonusLast[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632,18, "The amount of Bonus Elixir you gained on the last attack.")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsBonusLast[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632,19, "The amount of Bonus Dark Elixir you gained on the last attack.")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsBonusLast[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 265
	GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		GUICtrlCreateLabel(GetTranslated(632, 112, "Top Loot") & ":", $x - 15, $y - 11, - 1, - 1)

	$x += 85
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632, 113, "Top Gold gained")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTop[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632, 114, "Top Elixir gained")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTop[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632, 115, "Top Dark gained")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTop[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
		$sTxtTip = GetTranslated(632, 116, "Top Trophy gained")
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahLblStatsTop[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
#EndRegion

#Region Misc SubTab
Func CreateMiscSubTab()
	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	Local $x = $xStart + 3, $y = $yStart + 20
		GUICtrlCreateLabel(GetTranslated(632, 105, "Run"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslated(632, 117, "Cost && Collect"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x -= 10
	$y -= 10
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,48, "The total Running Time of the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,47, "Runtime") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblResultRuntime = GUICtrlCreateLabel("00:00:00", $x + 35, $y + 2, 150, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnRecycle, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,58, "The number of Out of Sync error occurred")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,57, "Nbr of OoS") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblNbrOfOoS = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,34, "The No. of Villages that were attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,33, "Attacked") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblResultVillagesAttacked = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgX, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,36, "The No. of Villages that were skipped during search by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,35, "Skipped")& ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblResultVillagesSkipped = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,46, "The amount of Trophies dropped by the Bot due to Trophy Settings (on Misc Tab).")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,45, "Dropped") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblResultTrophiesDropped = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 25
	$y -= 15
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnMagnifier, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,60, "Search cost for skipping villages in gold")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,59, "Search Cost") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblSearchCost = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnArcher, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,62, "Elixir spent for training Barrack Troops")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,61, "Train Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTrainCostElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnMinion, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,64, "Dark Elixir spent for training Dark Barrack Troops")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,63, "Train Cost DElixir") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTrainCostDElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,66, "Gold gained by collecting mines")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,65, "Gold collected") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblGoldFromMines = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,68, "Elixir gained by collecting collectors")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,67, "Elixir collected") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblElixirFromCollectors = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,70, "Dark Elixir gained by collecting drills")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,69, "DElixir collected") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblDElixirFromDrills = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 5
	$y = $yStart + 165
		GUICtrlCreateLabel(GetTranslated(632, 103, "Upgrades Made"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xD4D4D4)
		GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xD4D4D4)
		GUICtrlCreateLabel(GetTranslated(632, 104, "Upgrade Costs"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xD4D4D4)

	$x -= 10
	$y -= 10
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallGold, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,38, "The No. of Walls upgraded by Gold.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,37, "Upg. by Gold") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblWallGoldMake = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallElixir, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,40, "The No. of Walls upgraded by Elixir.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,39, "Upg. by Elixir") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblWallElixirMake = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgGold, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,41, "The number of buildings upgraded using gold")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,37, "Upg. by Gold") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblNbrOfBuildingUpgGold = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgElixir, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,42, "The number of buildings upgraded using elixir")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,39, "Upg. by Elixir") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblNbrOfBuildingUpgElixir = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnHeroes, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,44, "The number of heroes upgraded")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,43, "Hero Upgrade") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblNbrOfHeroUpg = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 165
	$y -= 10
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallGold, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,50, "The cost of gold used by bot while upgrading walls")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,49, "Upg. Cost Gold") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblWallUpgCostGold = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallElixir, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,52, "The cost of elixir used by bot while upgrading walls")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,51, "Upg. Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblWallUpgCostElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgGold, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,53, "The cost of gold used by bot while upgrading buildings")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,49, "Upg. Cost Gold") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblBuildingUpgCostGold = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgElixir, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,54, "The cost of elixir used by bot while upgrading buildings")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,51, "Upg. Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblBuildingUpgCostElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnHeroes, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,56, "The cost of dark elixir used by bot while upgrading heroes")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,55, "Upg. Cost DElixir") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblHeroUpgCost = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$x -= 20
	$y -= 85
		GUICtrlCreateLabel("", $x + 28, $y - 160, 5, 300)
		GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
#EndRegion

#Region Attacks SubTab
Func CreateAttacksSubTab()
	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	Local $x = $xStart + 3, $y = $yStart + 20
		GUICtrlCreateLabel(GetTranslated(632,71, "Dead Base"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslated(632,78, "Live Base"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x -= 10
	$y -= 10
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,73, "The No. of Dead Base that were attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,72, "Attacked") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblAttacked[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,75, "The amount of Gold gained from Dead Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, "gain") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalGoldGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,76, "The amount of Elixir gained from Dead Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,100, "The amount of Dark Elixir gained from Dead Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalDElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,77, "The amount of Trophies gained from Dead Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
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
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
		$g_hLblNbrOfDetectedCollectors[$DB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 20, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
		$g_hLblNbrOfDetectedDrills[$DB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 20, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 79, $y - 4, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 25
	$y -= 15
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,79, "The No. of Live Base that were attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,72, "Attacked") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblAttacked[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,80, "The amount of Gold gained from Live Bases attacked by the Bot")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalGoldGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,81, "The amount of Elixir gained from Live Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,82, "The amount of Dark Elixir gained from Live Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalDElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,83, "The amount of Trophy gained from Live Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
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
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
		$g_hLblNbrOfDetectedCollectors[$LB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 20, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
			GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
		$g_hLblNbrOfDetectedDrills[$LB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 20, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 79, $y - 4, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 5
	$y = $yStart + 165
		GUICtrlCreateLabel(GetTranslated(632,90, "TH Snipe"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xD4D4D4)
		GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xD4D4D4)
		GUICtrlCreateLabel(GetTranslated(632,84, "TH Bully"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xD4D4D4)

	$x -= 10
	$y -= 10
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,101,"The No. of TH Snipes attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,72, "Attacked") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblAttacked[$TS] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,91, "The amount of Gold gained from TH Snipe bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalGoldGain[$TS] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,92, "The amount of Elixir gained from TH Snipe bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalElixirGain[$TS] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,93, "The amount of Dark Elixir gained from TH Snipe bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalDElixirGain[$TS] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x - 10, $y, 16, 16)
		$sTxtTip = GetTranslated(632,94, "The amount of Trophy gained from TH Snipe bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalTrophyGain[$TS] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$x += 25
	$y += 25
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenLight, $x - 15, $y - 4, 16, 16)
		$sTxtTip = GetTranslated(632,95, "The number of successful TH Snipes")
		_GUICtrlSetTip(-1, $sTxtTip)
		;GUICtrlCreateLabel("Success:", $x - 15, $y - 2, -1, 17)
		$g_hLblNbrOfTSSuccess = GUICtrlCreateLabel("0", $x + 13, $y - 2, 25, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$x += 50
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedLight, $x + 35, $y - 4, 16, 16)
		$sTxtTip = GetTranslated(632,96, "The number of failed TH Snipe attempt")
		_GUICtrlSetTip(-1, $sTxtTip)
		;GUICtrlCreateLabel("Fail:", $x + 50, $y - 2, -1, 17)
		$g_hLblNbrOfTSFailed = GUICtrlCreateLabel("0", $x + 63, $y - 2, 25, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 165
	$y -= 10
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,85, "The No. of TH Bully bases that were attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,72, "Attacked") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblAttacked[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,86, "The amount of Gold gained from TH Bully bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalGoldGain[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,87, "The amount of Elixir gained from TH Bully bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalElixirGain[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,88, "The amount of Dark Elixir gained from TH Bully bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalDElixirGain[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$sTxtTip = GetTranslated(632,88, "The amount of Dark Elixir gained from TH Bully bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 22, $y, 16, 16)
		$sTxtTip = GetTranslated(632,89, "The amount of Trophy gained from TH Bully bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblTotalTrophyGain[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)
	$x += 64
	$y += 25
		$g_hLblNbrOfDetectedMines[$TB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 18, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
		$g_hLblNbrOfDetectedCollectors[$TB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 18, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
		$g_hLblNbrOfDetectedDrills[$TB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 18, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 79, $y - 4, 16, 16)
	$x -= 124
	$y -= 110
		GUICtrlCreateLabel("", $x + 28, $y - 160, 5, 300)
		GUICtrlSetBkColor(-1, 0xC3C3C3)

    $x = $xStart + 5
    $y = $yStart + 310
        $g_hLblStatsSZRev1 = GUICtrlCreateLabel("", $x - 20, $y - 32, 420, 17, $SS_CENTER)
        GUICtrlSetBkColor(-1, 0xD4D4D4)
		$g_hLblStatsSZRev2 = GUICtrlCreateLabel(GetTranslated(632,122, "Smart Zap"), $x + 155, $y - 32, 60, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xD4D4D4)
    $x -= 10
    $y -= 10
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x - 10, $y, 16, 16)
        _GUICtrlSetTip(-1, GetTranslated(632,125, "The amount of Lightning Spells used to zap"))
        GUICtrlCreateLabel(GetTranslated(632,123, "Used") & ":", $x + 13, $y + 2, -1, 17)
        _GUICtrlSetTip(-1, GetTranslated(632,125, -1))
        $g_hLblSmartLightningUsed = GUICtrlCreateLabel("0", $x + 45, $y + 2, 70, 17, $SS_RIGHT)
        GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
        GUICtrlSetColor(-1, $COLOR_BLACK)
        _GUICtrlSetTip(-1, GetTranslated(632,125, -1))
    $x += 145
        GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthQuakeSpell, $x - 10, $y, 16, 16)
        _GUICtrlSetTip(-1, GetTranslated(632,126, "The amount of Earthquake Spells used to zap"))
        GUICtrlCreateLabel(GetTranslated(632,123, -1) & ":", $x + 13, $y + 2, -1, 17)
        _GUICtrlSetTip(-1, GetTranslated(632,126, -1))
        $g_hLblSmartEarthQuakeUsed = GUICtrlCreateLabel("0", $x + 45, $y + 2, 70, 17, $SS_RIGHT)
        GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
        GUICtrlSetColor(-1, $COLOR_BLACK)
        _GUICtrlSetTip(-1, GetTranslated(632,126, -1))
    $x += 145
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x - 10, $y -1, 18, 18)
        _GUICtrlSetTip(-1, GetTranslated(632,124,"The amount of Dark Elixir won while zapping"))
        GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
        _GUICtrlSetTip(-1, GetTranslated(632,124, -1))
        $g_hLblSmartZap = GUICtrlCreateLabel("0", $x + 45, $y + 2, 70, 17, $SS_RIGHT)
        GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
        GUICtrlSetColor(-1, $COLOR_BLACK)
        _GUICtrlSetTip(-1, GetTranslated(632,124, -1))
    GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
#EndRegion

#Region Donations SubTab
Func CreateDonationsSubTab()
	#cs
   Local $x = 5, $y = 28, $z = 33

   GUICtrlCreateGroup(GetTranslated(632,118,"Troops"), $x, $y, 427, 220, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))

   $x -= 25
   $y += 20
   $z += 20

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarbarian, $x + 60, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopBarbarian] = GUICtrlCreateLabel("0", $x + 25, $z, 30, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnArcher, $x + 130, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopArcher] = GUICtrlCreateLabel("0", $x + 90, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnGiant, $x + 200, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopGiant] = GUICtrlCreateLabel("0", $x + 160, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoblin, $x + 270, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopGoblin] = GUICtrlCreateLabel("0", $x + 230, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallBreaker, $x + 340, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopWallBreaker] = GUICtrlCreateLabel("0", $x + 300, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnBalloon, $x + 410, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopBalloon] = GUICtrlCreateLabel("0", $x + 370, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

   $y += 35
   $z += 35

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnWizard, $x + 60, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopWizard] = GUICtrlCreateLabel("0", $x + 25, $z, 30, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealer, $x + 130, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopHealer] = GUICtrlCreateLabel("0", $x + 90, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDragon, $x + 200, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopDragon] = GUICtrlCreateLabel("0", $x + 160, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnPekka, $x + 270, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopPekka] = GUICtrlCreateLabel("0", $x + 230, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnBabyDragon, $x + 340, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopBabyDragon] = GUICtrlCreateLabel("0", $x + 300, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnMiner, $x + 410, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopMiner] = GUICtrlCreateLabel("0", $x + 370, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

   $y += 50
   $z += 50

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnMinion, $x + 60, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopMinion] = GUICtrlCreateLabel("0", $x + 25, $z, 30, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnHogRider, $x + 130, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopHogRider] = GUICtrlCreateLabel("0", $x + 90, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnValkyrie, $x + 200, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopValkyrie] = GUICtrlCreateLabel("0", $x + 160, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnGolem, $x + 270, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopGolem] = GUICtrlCreateLabel("0", $x + 230, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnWitch, $x + 340, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopWitch] = GUICtrlCreateLabel("0", $x + 300, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnLavaHound, $x +410, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopLavaHound] = GUICtrlCreateLabel("0", $x + 370, $z, 35, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

   $y += 35
   $z += 35

	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnBowler, $x + 60, $y, 32, 32)
	   $g_hLblDonTroop[$eTroopBowler] = GUICtrlCreateLabel("0", $x + 25, $z, 30, 20, $SS_RIGHT)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

   $x += 26
   $y += 45

	   $g_hLblTotalTroopsQ = GUICtrlCreateLabel(GetTranslated(632,120,"Total Donated") & " : 0", $x + 5, $y, 230, 20, $SS_CENTER)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	   GUICtrlSetColor(-1, $COLOR_BLACK)
	   GUICtrlSetBkColor(-1, 0xA8A8A8)

	   $g_hLblTotalTroopsXP = GUICtrlCreateLabel(GetTranslated(632,121,"XP Won") & " : 0", $x + 240, $y, 180, 20, $SS_CENTER)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	   GUICtrlSetColor(-1, $COLOR_BLACK)
	   GUICtrlSetBkColor(-1, 0xA8A8A8)

   GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 5, $y = 250, $z = 263

 GUICtrlCreateGroup(GetTranslated(632,119,"Spells"), $x, $y, 427, 150, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER))

$x -= 25
$y += 20
$z += 20

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x + 60, $y, 32, 32)
	$g_hLblDonSpell[$eSpellLightning] = GUICtrlCreateLabel("0", $x + 25, $z, 30, 20, $SS_RIGHT)
	GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x + 130, $y, 32, 32)
	$g_hLblDonSpell[$eSpellHeal] = GUICtrlCreateLabel("0", $x + 90, $z, 35, 20, $SS_RIGHT)
	GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x + 200, $y, 32, 32)
	$g_hLblDonSpell[$eSpellRage] = GUICtrlCreateLabel("0", $x + 160, $z, 35, 20, $SS_RIGHT)
	GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x + 270, $y, 32, 32)
	$g_hLblDonSpell[$eSpellJump] = GUICtrlCreateLabel("0", $x + 230, $z, 35, 20, $SS_RIGHT)
	GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x + 340, $y, 32, 32)
	$g_hLblDonSpell[$eSpellFreeze] = GUICtrlCreateLabel("0", $x + 300, $z, 35, 20, $SS_RIGHT)
	GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

$y += 50
$z += 50

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell, $x + 60, $y, 32, 32)
	$g_hLblDonSpell[$eSpellPoison] = GUICtrlCreateLabel("0", $x + 25, $z, 30, 20, $SS_RIGHT)
	GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x + 130, $y, 32, 32)
	$g_hLblDonSpell[$eSpellHaste] = GUICtrlCreateLabel("0", $x + 90, $z, 35, 20, $SS_RIGHT)
	GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell, $x + 200, $y, 32, 32)
	$g_hLblDonSpell[$eSpellEarthquake] = GUICtrlCreateLabel("0", $x + 160, $z, 35, 20, $SS_RIGHT)
	GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnSkeletonSpell, $x + 270, $y, 32, 32)
	$g_hLblDonSpell[$eSpellSkeleton] = GUICtrlCreateLabel("0", $x + 230, $z, 35, 20, $SS_RIGHT)
	GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)


$x += 26
$y += 45

	   $g_hLblTotalSpellsQ = GUICtrlCreateLabel(GetTranslated(632,120,"Total Donated") & " : 0", $x + 5, $y, 230, 20, $SS_CENTER)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	   GUICtrlSetColor(-1, $COLOR_BLACK)
	   GUICtrlSetBkColor(-1, 0xA8A8A8)

	   $g_hLblTotalSpellsXP = GUICtrlCreateLabel(GetTranslated(632,121,"XP Won") & " : 0", $x + 240, $y, 180, 20, $SS_CENTER)
	   GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	   GUICtrlSetColor(-1, $COLOR_BLACK)
	   GUICtrlSetBkColor(-1, 0xA8A8A8)

   GUICtrlCreateGroup("", -99, -99, 1, 1)
   #ce
   	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	Local $x = $xStart + 3, $y = $yStart + 20
		GUICtrlCreateLabel(GetTranslated(632,127,"Elixir Troops"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslated(632,128,"Dark Elixir Troops"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x -= 10
	$y -= 10
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarbarian, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopBarbarian] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnWizard, $x + 95, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 122, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopWizard] = GUICtrlCreateLabel("0", $x + 115, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnArcher, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopArcher] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealer, $x + 95, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 122, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopHealer] = GUICtrlCreateLabel("0", $x + 115, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGiant, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopGiant] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDragon, $x + 95, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 122, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopDragon] = GUICtrlCreateLabel("0", $x + 115, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoblin, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopGoblin] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnPekka, $x + 95, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 122, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopPekka] = GUICtrlCreateLabel("0", $x + 115, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallBreaker, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopWallBreaker] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBabyDragon, $x + 95, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 122, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopBabyDragon] = GUICtrlCreateLabel("0", $x + 115, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBalloon, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopBalloon] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnMiner, $x + 95, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 122, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopMiner] = GUICtrlCreateLabel("0", $x + 115, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)


	$x = $xStart + 212
	$y = $yStart + 25
	$y -= 15
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnMinion, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopMinion] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBowler, $x + 95, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 122, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopBowler] = GUICtrlCreateLabel("0", $x + 115, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnHogRider, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopHogRider] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)


	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnValkyrie, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopValkyrie] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGolem, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopGolem] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)


	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnWitch, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopWitch] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)


	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnLavaHound, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonTroop[$eTroopLavaHound] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x = $xStart + 3
	$y = $yStart + 210

		GUICtrlCreateLabel(GetTranslated(632,120,"Total Donated") & ":", $x - 20, $y - 32, 187, 17)
		   GUICtrlSetBkColor(-1, 0xD4D4D4)
		GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xD4D4D4)
		$g_hLblTotalTroopsQ = GUICtrlCreateLabel("0", $x + 105, $y - 32, 70, 17, $SS_RIGHT)
			GUICtrlSetBkColor(-1, 0xD4D4D4)
		GUICtrlCreateLabel(GetTranslated(632,121,"Total XP") & ":", $x - 18 + 212, $y - 32, 207, 17)
		   GUICtrlSetBkColor(-1, 0xD4D4D4)
		$g_hLblTotalTroopsXP = GUICtrlCreateLabel("0", $x + 320, $y - 32, 70, 17, $SS_RIGHT)
			GUICtrlSetBkColor(-1, 0xD4D4D4)


	$x = $xStart + 3
	$y = $yStart + 235
		GUICtrlCreateLabel(GetTranslated(632,129, "Elixir Spells"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel(GetTranslated(632,130, "Dark Elixir Spells"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x -= 10
	$y -= 10
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonSpell[$eSpellLightning] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x + 95, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 122, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonSpell[$eSpellFreeze] = GUICtrlCreateLabel("0", $x + 115, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonSpell[$eSpellHeal] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)


	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonSpell[$eSpellRage] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonSpell[$eSpellJump] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)


	$x = $xStart + 210
	$y = $yStart + 235
	$y -= 10

		GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonSpell[$eSpellPoison] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthQuakeSpell, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonSpell[$eSpellEarthquake] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)


	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonSpell[$eSpellHaste] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnSkeletonSpell, $x - 10, $y, 24, 24)
		$sTxtTip = ""
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, 17)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$g_hLblDonSpell[$eSpellSkeleton] = GUICtrlCreateLabel("0", $x + 15, $y + 4, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $sTxtTip)

	$x = $xStart + 5
	$y = $yStart + 370
		GUICtrlCreateLabel(GetTranslated(632,120,"Total Donated") & ":", $x - 20, $y - 32, 187, 17)
		   GUICtrlSetBkColor(-1, 0xD4D4D4)
		GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
		   GUICtrlSetBkColor(-1, 0xD4D4D4)
		$g_hLblTotalSpellsQ = GUICtrlCreateLabel("0", $x + 105, $y - 32, 70, 17, $SS_RIGHT)
			GUICtrlSetBkColor(-1, 0xD4D4D4)
		GUICtrlCreateLabel(GetTranslated(632,121,"Total XP") & ":", $x - 18 + 212, $y - 32, 207, 17)
		   GUICtrlSetBkColor(-1, 0xD4D4D4)
		$g_hLblTotalSpellsXP = GUICtrlCreateLabel("0", $x + 320, $y - 32, 70, 17, $SS_RIGHT)
			GUICtrlSetBkColor(-1, 0xD4D4D4)


	$x += 155
	$y -= 250
		GUICtrlCreateLabel("", $x + 28, $y - 130, 5, 188)
		GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlCreateLabel("", $x + 28, $y + 90, 5, 128)
		GUICtrlSetBkColor(-1, 0xC3C3C3)

EndFunc
#EndRegion
