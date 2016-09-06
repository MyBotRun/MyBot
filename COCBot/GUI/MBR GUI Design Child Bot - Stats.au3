; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), kaganus (2015), Boju (2016)
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
	$grpResourceOnStart = GUICtrlCreateGroup(GetTranslated(632, 2, "Started with"), $x - 20, $y - 20, 90, 118)
			;Boju Display TH Level in Stats
		$THLevels = GUICtrlCreateLabel(GetTranslated(632,0, "TH Level:"), $x - 20, $y + 3, 55, 17, $SS_RIGHT)
			$THLevels04 = GUICtrlCreateIcon(@ScriptDir & "\images\TH\Levels\HdV04.ico",-1, $x + 42, $y - 2, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$THLevels05 = GUICtrlCreateIcon(@ScriptDir & "\images\TH\Levels\HdV05.ico",-1, $x + 42, $y - 2, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$THLevels06 = GUICtrlCreateIcon(@ScriptDir & "\images\TH\Levels\HdV06.ico",-1, $x + 42, $y - 2, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$THLevels07 = GUICtrlCreateIcon(@ScriptDir & "\images\TH\Levels\HdV07.ico",-1, $x + 42, $y - 2, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$THLevels08 = GUICtrlCreateIcon(@ScriptDir & "\images\TH\Levels\HdV08.ico",-1, $x + 42, $y - 2, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$THLevels09 = GUICtrlCreateIcon(@ScriptDir & "\images\TH\Levels\HdV09.ico",-1, $x + 42, $y - 2, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$THLevels10 = GUICtrlCreateIcon(@ScriptDir & "\images\TH\Levels\HdV10.ico",-1, $x + 42, $y - 2, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			$THLevels11 = GUICtrlCreateIcon(@ScriptDir & "\images\TH\Levels\HdV11.ico",-1, $x + 42, $y - 2, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
			;-->Display TH Level in Stats
		$y += 25
		$lblResultStatsTemp = GUICtrlCreateLabel(GetTranslated(632, 3, "Report") & @CRLF & GetTranslated(632, 4, "will appear") & @CRLF & GetTranslated(632, 5, "here on") & @CRLF & GetTranslated(632, 6, "first run."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))

		$picResultGoldStart = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 50, $y, 16, 16)
			$lblResultGoldStart = GUICtrlCreateLabel("", $x - 15, $y + 2, 60, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632, 7, "The amount of Gold you had when the bot started.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$picResultElixirStart = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 50, $y, 16, 16)
			$lblResultElixirStart = GUICtrlCreateLabel("", $x - 15, $y + 2, 60, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632, 8, "The amount of Elixir you had when the bot started.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$picResultDEStart = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 50, $y, 16, 16)
			$lblResultDEStart = GUICtrlCreateLabel("", $x - 10, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632, 9, "The amount of Dark Elixir you had when the bot started.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$picResultTrophyStart = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 50, $y, 16, 16)
			$lblResultTrophyStart = GUICtrlCreateLabel("", $x - 10, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632, 10, "The amount of Trophies you had when the bot started.")
			_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 95
	$y = $yStart + 23
	$grpTotalLoot = GUICtrlCreateGroup(GetTranslated(632,20, "Total Gain"), $x - 20, $y - 15, 90, 90)
		$lblTotalLootTemp = GUICtrlCreateLabel(GetTranslated(632,3, "Report") & @CRLF & GetTranslated(632,99, "will update") & @CRLF & GetTranslated(632,97, "here after") & @CRLF & GetTranslated(632,98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))

		$picGoldLoot = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 50, $y, 16, 16)
			$lblGoldLoot = GUICtrlCreateLabel("", $x - 15, $y + 2, 60, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,21, "The total amount of Gold you gained or lost while the Bot is running.") & @CRLF & GetTranslated(632,22, "(This includes manual spending of resources on upgrade of buildings)")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$picElixirLoot = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 50, $y, 16, 16)
			$lblElixirLoot = GUICtrlCreateLabel("", $x - 15, $y + 2, 60, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,23, "The total amount of Elixir you gained or lost while the Bot is running.") & @CRLF & GetTranslated(632,22, "(This includes manual spending of resources on upgrade of buildings)")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$picDarkLoot = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 50, $y, 16, 16)
			$lblDarkLoot = GUICtrlCreateLabel("", $x - 15, $y + 2, 60, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,24, "The total amount of Dark Elixir you gained or lost while the Bot is running.") & @CRLF & GetTranslated(632,22, "(This includes manual spending of resources on upgrade of buildings)")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$picTrophyLoot = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 50, $y, 16, 16)
			$lblTrophyLoot = GUICtrlCreateLabel("", $x - 15, $y + 2, 60, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,25, "The amount of Trophies you gained or lost while the Bot is running.")
			_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + (95 * 2)
	$y = $yStart + 23
	$grpHourlyStats = GUICtrlCreateGroup(GetTranslated(632,26, "Gain per Hour"), $x - 20, $y - 15, 80, 90)
		$lblHourlyStatsTemp = GUICtrlCreateLabel(GetTranslated(632,3, "Report") & @CRLF & GetTranslated(632,99, "will update") & @CRLF & GetTranslated(632,97, "here after") & @CRLF & GetTranslated(632,98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))

		$picHourlyStatsGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 40, $y, 16, 16)
			$lblHourlyStatsGold = GUICtrlCreateLabel("", $x - 20, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,27, "Gold gain per hour")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$picHourlyStatsElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 40, $y, 16, 16)
			$lblHourlyStatsElixir = GUICtrlCreateLabel("", $x - 20, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,28, "Elixir gain per hour")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$picHourlyStatsDark = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 40, $y, 16, 16)
			$lblHourlyStatsDark = GUICtrlCreateLabel("", $x - 20, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,29, "Dark Elixir gain per hour")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$picHourlyStatsTrophy = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 40, $y, 16, 16)
			$lblHourlyStatsTrophy = GUICtrlCreateLabel("", $x - 20, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,30, "Trophy gain per hour")
			_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)


	$x = $xStart
	$y = $yStart + 118

	$grpLastAttack1 = GUICtrlCreateGroup(GetTranslated(632,102,"Last Attack"), $x - 20, $y - 15, 270, 115)
	$x = $xStart + 10
	$y = $yStart + 118 +20
	   $grpLastAttack = GUICtrlCreateGroup(GetTranslated(632, 11, "Gain"), $x - 20, $y - 15, 85, 90)
		   $lblLastAttackTemp = GUICtrlCreateLabel(GetTranslated(632, 3, "Report") & @CRLF & GetTranslated(632, 4, "will appear") & @CRLF & GetTranslated(632, 97, "here after") & @CRLF & GetTranslated(632, 98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
			   GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 45, $y, 16, 16)
			   $lblGoldLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
			   $txtTip = GetTranslated(632, 12, "The amount of Gold you gained on the last attack.")
			   _GUICtrlSetTip(-1, $txtTip)
		   $y += 17
		   GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 45, $y, 16, 16)
			   $lblElixirLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
			   $txtTip = GetTranslated(632, 13, "The amount of Elixir you gained on the last attack.")
			   _GUICtrlSetTip(-1, $txtTip)
		   $y += 17
		   $picDarkLastAttack = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 45, $y, 16, 16)
			   $lblDarkLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
			   $txtTip = GetTranslated(632,14, "The amount of Dark Elixir you gained on the last attack.")
			   _GUICtrlSetTip(-1, $txtTip)
		   $y += 17
		   GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 45, $y, 16, 16)
			   $lblTrophyLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
			   $txtTip = GetTranslated(632,15, "The amount of Trophies you gained or lost on the last attack.")
			   _GUICtrlSetTip(-1, $txtTip)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart +10 + 90
	   $y = $yStart + 118 +20
	   $grpLastAttackBonus = GUICtrlCreateGroup(GetTranslated(632,16, "League Bonus"), $x - 20, $y - 15, 85, 90)
		   $lblLastAttackBonusTemp = GUICtrlCreateLabel(GetTranslated(632,3, "Report") & @CRLF & GetTranslated(632,99, "will update") & @CRLF & GetTranslated(632,97, "here after") & @CRLF & GetTranslated(632,98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
			   GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 45, $y, 16, 16)
			   $lblGoldBonusLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
			   $txtTip = GetTranslated(632,17, "The amount of Bonus Gold you gained on the last attack.")
			   _GUICtrlSetTip(-1, $txtTip)
		   $y += 17
			   GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 45, $y, 16, 16)
			   $lblElixirBonusLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
			   $txtTip = GetTranslated(632,18, "The amount of Bonus Elixir you gained on the last attack.")
			   _GUICtrlSetTip(-1, $txtTip)
		   $y += 17
			   $picDarkBonusLastAttack = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 45, $y, 16, 16)
			   $lblDarkBonusLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
			   $txtTip = GetTranslated(632,19, "The amount of Bonus Dark Elixir you gained on the last attack.")
			   _GUICtrlSetTip(-1, $txtTip)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)
	   $x = $xStart +10 + 165
	   $y = $yStart + 118 +20
		;Display League in Stats ==>
		$grpLeague = GUICtrlCreateGroup(GetTranslated(632,106, "League"), $x - 5, $y - 15, 70, 90)
			$y += 1
			$UnrankedLeague = GUICtrlCreateIcon(@ScriptDir & "\images\League\Unranked.ico",-1, $x - 2, $y - 2, 64, 64)
			GUICtrlSetState(-1,$GUI_SHOW)
			$BronzeLeague = GUICtrlCreateIcon(@ScriptDir & "\images\League\Bronze.ico",-1, $x - 2, $y - 2, 64, 64)
			GUICtrlSetState(-1,$GUI_HIDE)
			$SilverLeague = GUICtrlCreateIcon(@ScriptDir & "\images\League\Silver.ico",-1, $x - 2, $y - 2, 64, 64)
			GUICtrlSetState(-1,$GUI_HIDE)
			$GoldLeague = GUICtrlCreateIcon(@ScriptDir & "\images\League\Gold.ico",-1, $x - 2, $y - 2, 64, 64)
			GUICtrlSetState(-1,$GUI_HIDE)
			$CrystalLeague = GUICtrlCreateIcon(@ScriptDir & "\images\League\Crystal.ico",-1, $x - 2, $y - 2, 64, 64)
			GUICtrlSetState(-1,$GUI_HIDE)
			$MasterLeague = GUICtrlCreateIcon(@ScriptDir & "\images\League\Master.ico",-1, $x - 2, $y - 2, 64, 64)
			GUICtrlSetState(-1,$GUI_HIDE)
			$ChampionLeague = GUICtrlCreateIcon(@ScriptDir & "\images\League\Champion.ico",-1, $x - 2, $y - 2, 64, 64)
			GUICtrlSetState(-1,$GUI_HIDE)
			$TitanLeague = GUICtrlCreateIcon(@ScriptDir & "\images\League\Titan.ico",-1, $x - 2, $y - 2, 64, 64)
			GUICtrlSetState(-1,$GUI_HIDE)
			$LegendLeague = GUICtrlCreateIcon(@ScriptDir & "\images\League\Legend.ico",-1, $x - 2, $y - 2, 64, 64)
			GUICtrlSetState(-1,$GUI_HIDE)

			$lblLeague = GUICtrlCreateLabel("", $x + 20, $y + 50, 64, 64, $SS_CENTER)
			GUICtrlSetFont($lblLeague, 12, $FW_BOLD)
			GUICtrlSetColor($lblLeague, $COLOR_BLACK)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		;==> Display League in Stats
	GUICtrlCreateGroup("", -99, -99, 1, 1)
;-->TAB Gain

;TAB Misc
$hGUI_STATS_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,39,"Misc"))
	Local $xStart = 25, $yStart = 45
	$x = $xStart
	$y = $yStart
	$y += 5
	$grpStatsMisc = GUICtrlCreateGroup(GetTranslated(632,32, "Stats: Misc"), $x - 20, $y - 20, 428, 330)
		$x += 5
		$y += 20
		$GroupRun = GUICtrlCreateGroup(GetTranslated(632, 105, "Run:"), $x - 20, $y - 20, 416, 133)
		$y -= 2
		GUICtrlCreateIcon($pIconLib, $eIcnHourGlass, $x - 10, $y, 16, 16)
		$lblruntime = GUICtrlCreateLabel(GetTranslated(632,47, "Runtime") & ":", $x + 13, $y + 2, -1, 17)
		$lblresultruntime = GUICtrlCreateLabel("00:00:00", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,48, "The total Running Time of the Bot.")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnRecycle, $x - 10, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,57, "Nbr of OoS") & ":", $x + 13, $y + 2, -1, 17)
		$lblNbrOfOoS = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,58, "The number of Out of Sync error occurred")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnBldgTarget, $x - 10, $y, 16, 16)
		$lblvillagesattacked = GUICtrlCreateLabel(GetTranslated(632,33, "Attacked") & ":", $x + 13, $y + 2, -1, 17)
		$lblresultvillagesattacked = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,34, "The No. of Villages that were attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnBldgX, $x - 10, $y, 16, 16)
		$lblvillagesskipped = GUICtrlCreateLabel(GetTranslated(632,35, "Skipped")&":", $x + 13, $y + 2, -1, 17)
		$lblresultvillagesskipped = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,36, "The No. of Villages that were skipped during search by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 10, $y, 16, 16)
		$lbltrophiesdropped = GUICtrlCreateLabel(GetTranslated(632,45, "Dropped") & ":", $x + 13, $y + 2, -1, 17)
		$lblresulttrophiesdropped = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,46, "The amount of Trophies dropped by the Bot due to Trophy Settings (on Misc Tab).")
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 5
	$y = $yStart + 165
	$GroupNumUpg = GUICtrlCreateGroup(GetTranslated(632, 103, "Upgrades Made"), $x - 20, $y - 20, 135, 118)
		$y -= 2
		GUICtrlCreateIcon($pIconLib, $eIcnWallGold, $x - 10, $y, 16, 16)
		$lblwallbygold = GUICtrlCreateLabel(GetTranslated(632,37, "Upg. by Gold") &":", $x + 8, $y + 2, -1, 17)
		$lblWallgoldmake = GUICtrlCreateLabel("0", $x + 40, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,38, "The No. of Walls upgraded by Gold.")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnWallElixir, $x - 10, $y, 16, 16)
		$lblwallbyelixir = GUICtrlCreateLabel(GetTranslated(632,39, "Upg. by Elixir") &":", $x + 8, $y + 2, -1, 17)
		$lblWallelixirmake = GUICtrlCreateLabel("0", $x + 40, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,40, "The No. of Walls upgraded by Elixir.")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnBldgGold, $x - 10, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,37, "Upg. by Gold") & ":", $x + 8, $y + 2, -1, 17)
		$lblNbrOfBuildingUpgGold = GUICtrlCreateLabel("0", $x + 40, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,41, "The number of buildings upgraded using gold")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnBldgElixir, $x - 10, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,39, "Upg. by Elixir") & ":", $x + 8, $y + 2, -1, 17)
		$lblNbrOfBuildingUpgElixir = GUICtrlCreateLabel("0", $x + 40, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,42, "The number of buildings upgraded using elixir")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnHeroes, $x - 10, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,43, "Hero Upgrade") & ":", $x + 8, $y + 2, -1, 17)
		$lblNbrOfHeroUpg = GUICtrlCreateLabel("0", $x + 40, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,44, "The number of heroes upgraded")
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 150
	$y = $yStart + 165
	$GroupNumUpg = GUICtrlCreateGroup(GetTranslated(632, 104, "Upgrade Costs"), $x - 20, $y - 20, 165, 118)
		$x -= 10
		$y -= 2
		GUICtrlCreateIcon($pIconLib, $eIcnWallGold, $x - 5, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,49, "Upg. Cost Gold") & ":", $x + 13, $y + 2, -1, 17)
		$lblWallUpgCostGold = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,50, "The cost of gold used by bot while upgrading walls")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnWallElixir, $x - 5, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,51, "Upg. Cost Elixir") & ":", $x + 13, $y + 2, -1, 17)
		$lblWallUpgCostElixir = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,52, "The cost of elixir used by bot while upgrading walls")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnBldgGold, $x - 5, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,49, "Upg. Cost Gold") & ":", $x + 13, $y + 2, -1, 17)
		$lblBuildingUpgCostGold = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,53, "The cost of gold used by bot while upgrading buildings")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnBldgElixir, $x - 5, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,51, "Upg. Cost Elixir") & ":", $x + 13, $y + 2, -1, 17)
		$lblBuildingUpgCostElixir = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,54, "The cost of elixir used by bot while upgrading buildings")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnHeroes, $x - 5, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,55, "Upg. Cost DElixir") & ":", $x + 13, $y + 2, -1, 17)
		$lblHeroUpgCost = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,56, "The cost of dark elixir used by bot while upgrading heroes")
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 215
	$y = $yStart + 25
	;$GroupMisc2 = GUICtrlCreateGroup("", $x + 17 , $y - 20, 170, 133)
		$y -= 2
		GUICtrlCreateIcon($pIconLib, $eIcnMagnifier, $x + 27, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,59, "Search Cost") & ":", $x + 45, $y + 2, -1, 17)
		$lblSearchCost = GUICtrlCreateLabel("0", $x + 115, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,60, "Search cost for skipping villages in gold")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnArcher, $x + 27, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,61, "Train Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
		$lblTrainCostElixir = GUICtrlCreateLabel("0", $x + 115, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,62, "Elixir spent for training Barrack Troops")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnMinion, $x + 27, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,63, "Train Cost DElixir") & ":", $x + 45, $y + 2, -1, 17)
		$lblTrainCostDElixir = GUICtrlCreateLabel("0", $x + 115, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,64, "Dark Elixir spent for training Dark Barrack Troops")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 27, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,65, "Gold collected")&":", $x + 45, $y + 2, -1, 17)
		$lblGoldFromMines = GUICtrlCreateLabel("0", $x + 115, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,66, "Gold gained by collecting mines")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 27, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,67, "Elixir collected") & ":", $x + 45, $y + 2, -1, 17)
		$lblElixirFromCollectors = GUICtrlCreateLabel("0", $x + 115, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,68, "Elixir gained by collecting collectors")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 27, $y, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,69, "DElixir collected") & ":", $x + 45, $y + 2, -1, 17)
		$lblDElixirFromDrills = GUICtrlCreateLabel("0", $x + 115, $y + 2, 60, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,70, "Dark Elixir gained by collecting drills")
		_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
;--> TAB Misc

;TAB Attacks
$hGUI_STATS_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600,40,"Attacks"))
	Local $xStart = 25, $yStart = 45
	$x = $xStart
	$y = $yStart
	$grpStatsDB = GUICtrlCreateGroup(GetTranslated(632,71, "Dead Base"), $x - 20, $y - 20, 111, 120)
		GUICtrlCreateLabel(GetTranslated(632,72, "Attacked") & ":", $x - 15, $y - 2, -1, 17)
		$lblAttacked[$DB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,73, "The No. of Dead Base that were attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)

		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x - 15, $y - 4, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
		$lblTotalGoldGain[$DB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,75, "The amount of Gold gained from Dead Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x - 15, $y - 4, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
		$lblTotalElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,75, -1)
		_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x - 15, $y - 4, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
		$lblTotalDElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,100, "The amount of Dark Elixir gained from Dead Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 15, $y - 4, 16, 16)
		GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
		$lblTotalTrophyGain[$DB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
		$txtTip = GetTranslated(632,76, "The amount of Elixir gained from Dead Bases attacked by the Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$lblNbrOfDetectedMines[$DB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 18, 17, $SS_RIGHT)
		GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 1, $y - 4, 16, 16)
		$lblNbrOfDetectedCollectors[$DB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 18, 17, $SS_RIGHT)
		GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 37, $y - 4, 16, 16)
		$lblNbrOfDetectedDrills[$DB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 18, 17, $SS_RIGHT)
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 73, $y - 4, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 116
	$y = $yStart
	$grpStatsLB = GUICtrlCreateGroup(GetTranslated(632,78, "Live Base"), $x - 20, $y - 20, 111, 120)
		GUICtrlCreateLabel(GetTranslated(632,72, "Attacked") & ":", $x - 15, $y - 2, -1, 17)
			$lblAttacked[$LB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,79, "The No. of Live Base that were attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x - 15, $y - 4, 16, 16)
			GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
			$lblTotalGoldGain[$LB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,80, "The amount of Gold gained from Live Bases attacked by the Bot")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x - 15, $y - 4, 16, 16)
			GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
			$lblTotalElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,81, "The amount of Elixir gained from Live Bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x - 15, $y - 4, 16, 16)
			GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
			$lblTotalDElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,82, "The amount of Dark Elixir gained from Live Bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 15, $y - 4, 16, 16)
			GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
			$lblTotalTrophyGain[$LB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,83, "The amount of Trophy gained from Live Bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$lblNbrOfDetectedMines[$LB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 18, 17, $SS_RIGHT)
			GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 1, $y - 4, 16, 16)
		$lblNbrOfDetectedCollectors[$LB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 18, 17, $SS_RIGHT)
			GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 37, $y - 4, 16, 16)
		$lblNbrOfDetectedDrills[$LB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 18, 17, $SS_RIGHT)
			GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 73, $y - 4, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 135
	$grpStatsTS = GUICtrlCreateGroup(GetTranslated(632,90, "TH Snipe"), $x - 20, $y - 20, 111, 120)
		GUICtrlCreateLabel(GetTranslated(632,72, "Attacked") & ":", $x - 15, $y - 2, -1, 17)
			$lblAttacked[$TS] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,101,"The No. of TH Snipes attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x - 15, $y - 4, 16, 16)
			GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
			$lblTotalGoldGain[$TS] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,91, "The amount of Gold gained from TH Snipe bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x - 15, $y - 4, 16, 16)
			GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
			$lblTotalElixirGain[$TS] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,92, "The amount of Elixir gained from TH Snipe bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x - 15, $y - 4, 16, 16)
			GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
			$lblTotalDElixirGain[$TS] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,93, "The amount of Dark Elixir gained from TH Snipe bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 15, $y - 4, 16, 16)
			GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
			$lblTotalTrophyGain[$TS] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,94, "The amount of Trophy gained from TH Snipe bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnGreenLight, $x - 15, $y - 4, 16, 16)
			;GUICtrlCreateLabel("Success:", $x - 15, $y - 2, -1, 17)
			$lblNbrOfTSSuccess = GUICtrlCreateLabel("0", $x + 8, $y - 2, 25, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,95, "The number of successful TH Snipes")
			_GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x + 35, $y - 4, 16, 16)
			;GUICtrlCreateLabel("Fail:", $x + 50, $y - 2, -1, 17)
			$lblNbrOfTSFailed = GUICtrlCreateLabel("0", $x + 58, $y - 2, 25, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,96, "The number of failed TH Snipe attempt")
			_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 116
	$y = $yStart + 135
	$grpStatsTB = GUICtrlCreateGroup(GetTranslated(632,84, "TH Bully"), $x - 20, $y - 20, 111, 120)
		GUICtrlCreateLabel(GetTranslated(632,72, "Attacked") & ":", $x - 15, $y - 2, -1, 17)
			$lblAttacked[$TB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,85, "The No. of TH Bully bases that were attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x - 15, $y - 4, 16, 16)
			GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
			$lblTotalGoldGain[$TB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,86, "The amount of Gold gained from TH Bully bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x - 15, $y - 4, 16, 16)
			GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
			$lblTotalElixirGain[$TB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,87, "The amount of Elixir gained from TH Bully bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x - 15, $y - 4, 16, 16)
			GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
			$lblTotalDElixirGain[$TB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,88, "The amount of Dark Elixir gained from TH Bully bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 15, $y - 4, 16, 16)
			GUICtrlCreateLabel(GetTranslated(632,74, -1) & ":", $x + 3, $y - 2, -1, 17)
			$lblTotalTrophyGain[$TB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
			$txtTip = GetTranslated(632,89, "The amount of Trophy gained from TH Bully bases attacked by the Bot.")
			_GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$lblNbrOfDetectedMines[$TB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 18, 17, $SS_RIGHT)
			GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 1, $y - 4, 16, 16)
		$lblNbrOfDetectedCollectors[$TB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 18, 17, $SS_RIGHT)
			GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 37, $y - 4, 16, 16)
		$lblNbrOfDetectedDrills[$TB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 18, 17, $SS_RIGHT)
			GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 73, $y - 4, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

;--> TAB Attacks
GUICtrlCreateTabItem("")
;GUISetState()