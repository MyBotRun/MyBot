; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), kaganus (2015), Boju (2016), TheRevenor (2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
;~ This dummy is used in btnStart and btnStop to disable/enable all labels, text, buttons etc. on all tabs.
;~ -------------------------------------------------------------
Global $LastControlToHide = GUICtrlCreateDummy()
Global $iPrevState[$LastControlToHide + 1]
;~ -------------------------------------------------------------

;GUISetBkColor($COLOR_WHITE, $hGUI_STATS)

GUISwitch($hGUI_STATS)
;~ -------------------------------------------------------------
;~ Stats Tab
;~ -------------------------------------------------------------
$hGUI_STATS_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
Local $x = 375, $y = 0
$btnResetStats = GUICtrlCreateButton(GetTranslated(632,31, "Reset Stats"), $x, $y, 60, 20)
GUICtrlSetOnEvent(-1, "btnResetStats")
GUICtrlSetState(-1, $GUI_DISABLE)

;TAB Gain
$hGUI_STATS_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,38,"Gain"))
	Local $xStart = 25, $yStart = 45
	$x = $xStart
	$y = $yStart
		$PicStats = GUICtrlCreatePic(@ScriptDir & "\images\Stats\Stats001.jpg", $x - 18, $y - 20, 426, 80)

	$x = $xStart + 276
	$y = $yStart - 14
		;Boju Display TH Level in Stats
		;$THLevels = GUICtrlCreateGroup(GetTranslated(632,0, "TownHall"), $x - 15, $y - 15, 70, 90)
		$THLevels04 = GUICtrlCreateIcon($pIconLib, $eHdV04, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$THLevels05 = GUICtrlCreateIcon($pIconLib, $eHdV05, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$THLevels06 = GUICtrlCreateIcon($pIconLib, $eHdV06, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$THLevels07 = GUICtrlCreateIcon($pIconLib, $eHdV07, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$THLevels08 = GUICtrlCreateIcon($pIconLib, $eHdV08, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$THLevels09 = GUICtrlCreateIcon($pIconLib, $eHdV09, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$THLevels10 = GUICtrlCreateIcon($pIconLib, $eHdV10, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)
		$THLevels11 = GUICtrlCreateIcon($pIconLib, $eHdV11, $x - 11, $y + 15, 52, 52)
		GUICtrlSetState(-1,$GUI_HIDE)

		$txtTHLevels = GUICtrlCreateLabel(GetTranslated(632,0, "TownHall"), $x - 11, $y, -1, -1, $SS_CENTER)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)

		;-->Display TH Level in Stats
		$lblTHLevels = GUICtrlCreateLabel("", $x + 38, $y + 53, 17, 17, $SS_CENTER)
		GUICtrlSetFont($lblTHLevels, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 340
	$y = $yStart - 14
	;Display League in Stats ==>
	;$grpLeague = GUICtrlCreateGroup(GetTranslated(632,106, "League"), $x - 5, $y - 15, 70, 90)
		$UnrankedLeague = GUICtrlCreateIcon($pIconLib, $eUnranked, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_SHOW)
		$BronzeLeague = GUICtrlCreateIcon($pIconLib, $eBronze, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$SilverLeague = GUICtrlCreateIcon($pIconLib, $eSilver, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$GoldLeague = GUICtrlCreateIcon($pIconLib, $eGold, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$CrystalLeague = GUICtrlCreateIcon($pIconLib, $eCrystal, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$MasterLeague = GUICtrlCreateIcon($pIconLib, $eMaster, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$ChampionLeague = GUICtrlCreateIcon($pIconLib, $eChampion, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$TitanLeague = GUICtrlCreateIcon($pIconLib, $eTitan, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)
		$LegendLeague = GUICtrlCreateIcon($pIconLib, $eLegend, $x - 2, $y - 5 + 15, 56, 56)
		GUICtrlSetState(-1,$GUI_HIDE)

		$txtLeague = GUICtrlCreateLabel(GetTranslated(632,106, "League"), $x + 3, $y, -1, -1, $SS_CENTER)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)

		;-->Display League Level in Stats
		$lblLeague = GUICtrlCreateLabel("", $x + 43, $y + 53, 17, 17, $SS_CENTER)
		GUICtrlSetFont($lblLeague, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor($lblLeague, $COLOR_BLACK)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 100
		$lblStatsRev = GUICtrlCreateLabel(GetTranslated(632, 107, "Stats"), $x - 20, $y - 32, 87, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xA8A8A8)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$lblGoldRev = GUICtrlCreateLabel(GetTranslated(632, 108, "Gold"), $x - 18 + 85, $y - 32, 95, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xA8A8A8)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$lblElixirRev = GUICtrlCreateLabel(GetTranslated(632, 109, "Elixir"), $x - 18 + (60 * 3), $y - 32, 75, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xA8A8A8)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$lblDarkRev = GUICtrlCreateLabel(GetTranslated(632, 110, "DarkE"), $x - 23 + (65 * 4), $y - 32, 90, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xA8A8A8)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$lblTrophyRev = GUICtrlCreateLabel(GetTranslated(632, 111, "Trophy"), $x - 23 + (70 * 5), $y - 32, 75, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xA8A8A8)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)

		$grpResourceOnStart = GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		$lblResourceOnStart = GUICtrlCreateLabel(GetTranslated(632, 2, "Started with") & ":", $x - 15, $y - 11, - 1, - 1)
		;$lblResultStatsTemp = GUICtrlCreateLabel(GetTranslated(632, 3, "Report") & @CRLF & GetTranslated(632, 4, "will appear") & @CRLF & GetTranslated(632, 5, "here on") & @CRLF & GetTranslated(632, 6, "first run."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
	$x += 85
		$picResultGoldStart = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632, 7, "The amount of Gold you had when the bot started.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblResultGoldStart = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblResultGoldStart, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor($lblResultGoldStart, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 85
		$picResultElixirStart = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632, 8, "The amount of Elixir you had when the bot started.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblResultElixirStart = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblResultElixirStart, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 85
		$picResultDEStart = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632, 9, "The amount of Dark Elixir you had when the bot started.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblResultDEStart = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblResultDEStart, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 75
		$picResultTrophyStart = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632, 10, "The amount of Trophies you had when the bot started.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblResultTrophyStart = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
		GUICtrlSetFont($lblResultTrophyStart, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 125
		$grpHourlyStats = GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		$lblHourlyStats = GUICtrlCreateLabel(GetTranslated(632,26, "Gain per Hour") & ":", $x - 15, $y - 11, - 1, - 1)
		;$lblHourlyStatsTemp = GUICtrlCreateLabel(GetTranslated(632,3, "Report") & @CRLF & GetTranslated(632,99, "will update") & @CRLF & GetTranslated(632,97, "here after") & @CRLF & GetTranslated(632,98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
	$x += 85
		$picHourlyStatsGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632,27, "Gold gain per hour")
		_GUICtrlSetTip(-1, $txtTip)
		$lblHourlyStatsGold = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblHourlyStatsGold, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 85
		$picHourlyStatsElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632,28, "Elixir gain per hour")
		_GUICtrlSetTip(-1, $txtTip)
		$lblHourlyStatsElixir = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblHourlyStatsElixir, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 85
		$picHourlyStatsDark = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632,29, "Dark Elixir gain per hour")
		_GUICtrlSetTip(-1, $txtTip)
		$lblHourlyStatsDark = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblHourlyStatsDark, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor($lblHourlyStatsDark, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 75
		$picHourlyStatsTrophy = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632,30, "Trophy gain per hour")
		_GUICtrlSetTip(-1, $txtTip)
		$lblHourlyStatsTrophy = GUICtrlCreateLabel("0/h", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
		GUICtrlSetFont($lblHourlyStatsTrophy, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 150
		$grpTotalLoot = GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		$lblTotalLoot = GUICtrlCreateLabel(GetTranslated(632,20, "Total Gain") & ":", $x - 15, $y - 11, - 1, - 1)
		;$lblTotalLootTemp = GUICtrlCreateLabel(GetTranslated(632,3, "Report") & @CRLF & GetTranslated(632,99, "will update") & @CRLF & GetTranslated(632,97, "here after") & @CRLF & GetTranslated(632,98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
	$x += 85
		$picGoldLoot = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632,21, "The total amount of Gold you gained or lost while the Bot is running.") & @CRLF & GetTranslated(632,22, "(This includes manual spending of resources on upgrade of buildings)")
		_GUICtrlSetTip(-1, $txtTip)
		$lblGoldLoot = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblGoldLoot, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 85
		$picElixirLoot = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632,23, "The total amount of Elixir you gained or lost while the Bot is running.") & @CRLF & GetTranslated(632,22, "(This includes manual spending of resources on upgrade of buildings)")
		_GUICtrlSetTip(-1, $txtTip)
		$lblElixirLoot = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblElixirLoot, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 85
		$picDarkLoot = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632,24, "The total amount of Dark Elixir you gained or lost while the Bot is running.") & @CRLF & GetTranslated(632,22, "(This includes manual spending of resources on upgrade of buildings)")
		_GUICtrlSetTip(-1, $txtTip)
		$lblDarkLoot = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblDarkLoot, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 75
		$picTrophyLoot = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632,25, "The amount of Trophies you gained or lost while the Bot is running.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblTrophyLoot = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
		GUICtrlSetFont($lblTrophyLoot, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 195
		$grpLastAttack = GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		$lblLastAttack = GUICtrlCreateLabel(GetTranslated(632,102,"Last Attack") & ":", $x - 15, $y - 11, - 1, - 1)
		;$lblLastAttackTemp = GUICtrlCreateLabel(GetTranslated(632, 3, "Report") & @CRLF & GetTranslated(632, 4, "will appear") & @CRLF & GetTranslated(632, 97, "here after") & @CRLF & GetTranslated(632, 98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
	$x += 85
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632, 12, "The amount of Gold you gained on the last attack.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblGoldLastAttack = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblGoldLastAttack, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 85
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632, 13, "The amount of Elixir you gained on the last attack.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblElixirLastAttack = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblElixirLastAttack, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 85
		$picDarkLastAttack = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632,14, "The amount of Dark Elixir you gained on the last attack.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblDarkLastAttack = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblDarkLastAttack, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 75
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632,15, "The amount of Trophies you gained or lost on the last attack.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblTrophyLastAttack = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
		GUICtrlSetFont($lblTrophyLastAttack, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 220
		$grpLastAttackBonus = GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		$lblLastAttackBonus = GUICtrlCreateLabel(GetTranslated(632,16, "League Bonus") & ":", $x - 15, $y - 11, - 1, - 1)
		;$lblLastAttackBonusTemp = GUICtrlCreateLabel(GetTranslated(632,3, "Report") & @CRLF & GetTranslated(632,99, "will update") & @CRLF & GetTranslated(632,97, "here after") & @CRLF & GetTranslated(632,98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
	$x += 85
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632,17, "The amount of Bonus Gold you gained on the last attack.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblGoldBonusLastAttack = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblGoldBonusLastAttack, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 85
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632,18, "The amount of Bonus Elixir you gained on the last attack.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblElixirBonusLastAttack = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblElixirBonusLastAttack, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 85
		$picDarkBonusLastAttack = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632,19, "The amount of Bonus Dark Elixir you gained on the last attack.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblDarkBonusLastAttack = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lblDarkBonusLastAttack, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

 	$x = $xStart + 3
	$y = $yStart + 265
		$grpMods = GUICtrlCreateGroup("", $x - 20, $y - 20, 422, 28)
		$lblMods = GUICtrlCreateLabel(GetTranslated(632, 112, "Top Loot") & ":", $x - 15, $y - 11, - 1, - 1)

	$x += 85
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632, 113, "Top Gold gained")
		_GUICtrlSetTip(-1, $txtTip)
		$lbltopgoldloot = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lbltopgoldloot, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)

	$x += 85
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632, 114, "Top Elixir gained")
		_GUICtrlSetTip(-1, $txtTip)
		$lbltopelixirloot = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lbltopelixirloot, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)

	$x += 85
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632, 115, "Top Dark gained")
		_GUICtrlSetTip(-1, $txtTip)
		$lbltopdarkloot = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
		GUICtrlSetFont($lbltopdarkloot, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)

	$x += 75
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
		$txtTip = GetTranslated(632, 116, "Top Trophy gained")
		_GUICtrlSetTip(-1, $txtTip)
		$lbltopTrophyloot = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
		GUICtrlSetFont($lbltopTrophyloot, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

;-->TAB Gain

;TAB Misc
$hGUI_STATS_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,39,"Misc"))
	Local $xStart = 25, $yStart = 45
	$x = $xStart + 3
	$y = $yStart + 20
		$lblRunRev = GUICtrlCreateLabel(GetTranslated(632, 105, "Run"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xA8A8A8)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$lblStatsMiscRev = GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xA8A8A8)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$lblCostandCollectRev = GUICtrlCreateLabel(GetTranslated(632, 117, "Cost && Collect"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xA8A8A8)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
	$x -= 10
	$y -= 10
		GUICtrlCreateIcon($pIconLib, $eIcnHourGlass, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,48, "The total Running Time of the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblruntime = GUICtrlCreateLabel(GetTranslated(632,47, "Runtime") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblresultruntime = GUICtrlCreateLabel("00:00:00", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnRecycle, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,58, "The number of Out of Sync error occurred")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,57, "Nbr of OoS") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblNbrOfOoS = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnBldgTarget, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,34, "The No. of Villages that were attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblvillagesattacked = GUICtrlCreateLabel(GetTranslated(632,33, "Attacked") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblresultvillagesattacked = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnBldgX, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,36, "The No. of Villages that were skipped during search by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblvillagesskipped = GUICtrlCreateLabel(GetTranslated(632,35, "Skipped")& ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblresultvillagesskipped = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,46, "The amount of Trophies dropped by the Bot due to Trophy Settings (on Misc Tab).")
		_GUICtrlSetTip(-1, $txtTip)
		$lbltrophiesdropped = GUICtrlCreateLabel(GetTranslated(632,45, "Dropped") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblresulttrophiesdropped = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 25
	$y -= 15
		GUICtrlCreateIcon($pIconLib, $eIcnMagnifier, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,60, "Search cost for skipping villages in gold")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,59, "Search Cost") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblSearchCost = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnArcher, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,62, "Elixir spent for training Barrack Troops")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,61, "Train Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTrainCostElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnMinion, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,64, "Dark Elixir spent for training Dark Barrack Troops")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,63, "Train Cost DElixir") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTrainCostDElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,66, "Gold gained by collecting mines")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,65, "Gold collected") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblGoldFromMines = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,68, "Elixir gained by collecting collectors")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,67, "Elixir collected") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblElixirFromCollectors = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,70, "Dark Elixir gained by collecting drills")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,69, "DElixir collected") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblDElixirFromDrills = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 5
	$y = $yStart + 165
		$lblRunRev = GUICtrlCreateLabel(GetTranslated(632, 103, "Upgrades Made"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$lblStatsMiscRev = GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$lblCostandCollectRev = GUICtrlCreateLabel(GetTranslated(632, 104, "Upgrade Costs"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
	$x -= 10
	$y -= 10
		GUICtrlCreateIcon($pIconLib, $eIcnWallGold, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,38, "The No. of Walls upgraded by Gold.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblwallbygold = GUICtrlCreateLabel(GetTranslated(632,37, "Upg. by Gold") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblWallgoldmake = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnWallElixir, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,40, "The No. of Walls upgraded by Elixir.")
		_GUICtrlSetTip(-1, $txtTip)
		$lblwallbyelixir = GUICtrlCreateLabel(GetTranslated(632,39, "Upg. by Elixir") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblWallelixirmake = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnBldgGold, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,41, "The number of buildings upgraded using gold")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,37, "Upg. by Gold") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblNbrOfBuildingUpgGold = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnBldgElixir, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,42, "The number of buildings upgraded using elixir")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,39, "Upg. by Elixir") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblNbrOfBuildingUpgElixir = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnHeroes, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,44, "The number of heroes upgraded")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,43, "Hero Upgrade") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblNbrOfHeroUpg = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 165
	$y -= 10
		GUICtrlCreateIcon($pIconLib, $eIcnWallGold, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,50, "The cost of gold used by bot while upgrading walls")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,49, "Upg. Cost Gold") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblWallUpgCostGold = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnWallElixir, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,52, "The cost of elixir used by bot while upgrading walls")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,51, "Upg. Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblWallUpgCostElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnBldgGold, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,53, "The cost of gold used by bot while upgrading buildings")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,49, "Upg. Cost Gold") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblBuildingUpgCostGold = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnBldgElixir, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,54, "The cost of elixir used by bot while upgrading buildings")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,51, "Upg. Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblBuildingUpgCostElixir = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnHeroes, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,56, "The cost of dark elixir used by bot while upgrading heroes")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,55, "Upg. Cost DElixir") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblHeroUpgCost = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x -= 20
	$y -= 85
		$lblRev1 = GUICtrlCreateLabel("", $x + 28, $y - 160, 5, 300)
		GUICtrlSetBkColor(-1, 0xA8A8A8)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

;--> TAB Misc
;TAB Attacks
$hGUI_STATS_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600,40,"Attacks"))
	Local $xStart = 25, $yStart = 45
	$x = $xStart + 3
	$y = $yStart + 20
		$lblStatsDB = GUICtrlCreateLabel(GetTranslated(632,71, "Dead Base"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xA8A8A8)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$lblStatsAttackRev = GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xA8A8A8)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$lblCostandCollectRev = GUICtrlCreateLabel(GetTranslated(632,78, "Live Base"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xA8A8A8)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
	$x -= 10
	$y -= 10
		GUICtrlCreateIcon($pIconLib, $eIcnBldgTarget, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,73, "The No. of Dead Base that were attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,72, "Attacked") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblAttacked[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,75, "The amount of Gold gained from Dead Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, "gain") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalGoldGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,75, -1)
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,100, "The amount of Dark Elixir gained from Dead Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalDElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,76, "The amount of Elixir gained from Dead Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalTrophyGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 30
	$y += 25
		$lblNbrOfDetectedMines[$DB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 20, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
		$lblNbrOfDetectedCollectors[$DB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 20, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
		$lblNbrOfDetectedDrills[$DB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 20, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 79, $y - 4, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 25
	$y -= 15
		GUICtrlCreateIcon($pIconLib, $eIcnBldgTarget, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,79, "The No. of Live Base that were attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,72, "Attacked") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblAttacked[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,80, "The amount of Gold gained from Live Bases attacked by the Bot")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalGoldGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,81, "The amount of Elixir gained from Live Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,82, "The amount of Dark Elixir gained from Live Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalDElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,83, "The amount of Trophy gained from Live Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalTrophyGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 62
	$y += 25
		$lblNbrOfDetectedMines[$LB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 20, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
		$lblNbrOfDetectedCollectors[$LB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 20, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
			GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
		$lblNbrOfDetectedDrills[$LB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 20, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 79, $y - 4, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 5
	$y = $yStart + 165
		$lblStatsTSRev = GUICtrlCreateLabel(GetTranslated(632,90, "TH Snipe"), $x - 20, $y - 32, 187, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$lblStatsTSRev = GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$lblStatsTBRev = GUICtrlCreateLabel(GetTranslated(632,84, "TH Bully"), $x - 18 + 212, $y - 32, 207, 17, $SS_CENTER)
		GUICtrlSetBkColor(-1, 0xC3C3C3)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
	$x -= 10
	$y -= 10
		GUICtrlCreateIcon($pIconLib, $eIcnBldgTarget, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,101,"The No. of TH Snipes attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,72, "Attacked") & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblAttacked[$TS] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,91, "The amount of Gold gained from TH Snipe bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalGoldGain[$TS] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,92, "The amount of Elixir gained from TH Snipe bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalElixirGain[$TS] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,93, "The amount of Dark Elixir gained from TH Snipe bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalDElixirGain[$TS] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 10, $y, 16, 16)
		$txtTip = GetTranslated(632,94, "The amount of Trophy gained from TH Snipe bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 13, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalTrophyGain[$TS] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 25
	$y += 25
		GUICtrlCreateIcon($pIconLib, $eIcnGreenLight, $x - 15, $y - 4, 16, 16)
		$txtTip = GetTranslated(632,95, "The number of successful TH Snipes")
		_GUICtrlSetTip(-1, $txtTip)
		;GUICtrlCreateLabel("Success:", $x - 15, $y - 2, -1, 17)
		$lblNbrOfTSSuccess = GUICtrlCreateLabel("0", $x + 13, $y - 2, 25, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 50
		GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x + 35, $y - 4, 16, 16)
		$txtTip = GetTranslated(632,96, "The number of failed TH Snipe attempt")
		_GUICtrlSetTip(-1, $txtTip)
		;GUICtrlCreateLabel("Fail:", $x + 50, $y - 2, -1, 17)
		$lblNbrOfTSFailed = GUICtrlCreateLabel("0", $x + 63, $y - 2, 25, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 165
	$y -= 10
		GUICtrlCreateIcon($pIconLib, $eIcnBldgTarget, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,85, "The No. of TH Bully bases that were attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,72, "Attacked") & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblAttacked[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,86, "The amount of Gold gained from TH Bully bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalGoldGain[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,87, "The amount of Elixir gained from TH Bully bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalElixirGain[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,88, "The amount of Dark Elixir gained from TH Bully bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalDElixirGain[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		$txtTip = GetTranslated(632,88, "The amount of Dark Elixir gained from TH Bully bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
	$y += 20
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 22, $y, 16, 16)
		$txtTip = GetTranslated(632,89, "The amount of Trophy gained from TH Bully bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 45, $y + 2, -1, 17)
		_GUICtrlSetTip(-1, $txtTip)
		$lblTotalTrophyGain[$TB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		_GUICtrlSetTip(-1, $txtTip)
	$x += 64
	$y += 25
		$lblNbrOfDetectedMines[$TB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 18, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
		$lblNbrOfDetectedCollectors[$TB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 18, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
		$lblNbrOfDetectedDrills[$TB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 18, 17, $SS_RIGHT)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 79, $y - 4, 16, 16)
	$x -= 124
	$y -= 110
		$lblRev1 = GUICtrlCreateLabel("", $x + 28, $y - 160, 5, 300)
		GUICtrlSetBkColor(-1, 0xA8A8A8)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

;--> TAB Attacks

GUICtrlCreateTabItem("")
;GUISetState()