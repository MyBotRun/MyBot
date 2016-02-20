; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), kaganus (2015)
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

;~ -------------------------------------------------------------
;~ Stats Tab
;~ -------------------------------------------------------------
$tabStats = GUICtrlCreateTabItem(GetTranslated(11, 1, "Stats"))
Local $x = 30, $y = 145
$grpResourceOnStart = GUICtrlCreateGroup(GetTranslated(11, 2, "Started with"), $x - 20, $y - 15, 90, 90)
$lblResultStatsTemp = GUICtrlCreateLabel(GetTranslated(11, 3, "Report") & @CRLF & GetTranslated(11, 4, "will appear") & @CRLF & GetTranslated(11, 5, "here on") & @CRLF & GetTranslated(11, 6, "first run."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 50, $y, 16, 16)
$lblResultGoldStart = GUICtrlCreateLabel("", $x - 15, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11, 7, "The amount of Gold you had when the bot started.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 50, $y, 16, 16)
$lblResultElixirStart = GUICtrlCreateLabel("", $x - 15, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11, 8, "The amount of Elixir you had when the bot started.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
$picResultDEStart = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 50, $y, 16, 16)
$lblResultDEStart = GUICtrlCreateLabel("", $x - 10, $y + 2, 55, 17, $SS_RIGHT)
$txtTip = GetTranslated(11, 9, "The amount of Dark Elixir you had when the bot started.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 50, $y, 16, 16)
$lblResultTrophyStart = GUICtrlCreateLabel("", $x - 10, $y + 2, 55, 17, $SS_RIGHT)
$txtTip = GetTranslated(11, 10, "The amount of Trophies you had when the bot started.")
GUICtrlSetTip(-1, $txtTip)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$x = 125
$y = 145
$grpLastAttack = GUICtrlCreateGroup(GetTranslated(11, 11, "Last Attack"), $x - 20, $y - 15, 85, 90)
$lblLastAttackTemp = GUICtrlCreateLabel(GetTranslated(11, 3, "Report") & @CRLF & GetTranslated(11, 4, "will appear") & @CRLF & GetTranslated(11, 97, "here after") & @CRLF & GetTranslated(11, 98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 45, $y, 16, 16)
$lblGoldLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
$txtTip = GetTranslated(11, 12, "The amount of Gold you gained on the last attack.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 45, $y, 16, 16)
$lblElixirLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
$txtTip = GetTranslated(11, 13, "The amount of Elixir you gained on the last attack.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
$picDarkLastAttack = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 45, $y, 16, 16)
$lblDarkLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,14, "The amount of Dark Elixir you gained on the last attack.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 45, $y, 16, 16)
$lblTrophyLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,15, "The amount of Trophies you gained or lost on the last attack.")
GUICtrlSetTip(-1, $txtTip)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$x = 215
$y = 145
$grpLastAttackBonus = GUICtrlCreateGroup(GetTranslated(11,16, "League Bonus"), $x - 20, $y - 15, 85, 90)
$lblLastAttackBonusTemp = GUICtrlCreateLabel(GetTranslated(11,3, "Report") & @CRLF & GetTranslated(11,99, "will update") & @CRLF & GetTranslated(11,97, "here after") & @CRLF & GetTranslated(11,98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 45, $y, 16, 16)
$lblGoldBonusLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,17, "The amount of Bonus Gold you gained on the last attack.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 45, $y, 16, 16)
$lblElixirBonusLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,18, "The amount of Bonus Elixir you gained on the last attack.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
$picDarkBonusLastAttack = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 45, $y, 16, 16)
$lblDarkBonusLastAttack = GUICtrlCreateLabel("", $x - 15, $y + 2, 55, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,19, "The amount of Bonus Dark Elixir you gained on the last attack.")
GUICtrlSetTip(-1, $txtTip)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$x = 305
$y = 145
$grpTotalLoot = GUICtrlCreateGroup(GetTranslated(11,20, "Total Gain"), $x - 20, $y - 15, 90, 90)
$lblTotalLootTemp = GUICtrlCreateLabel(GetTranslated(11,3, "Report") & @CRLF & GetTranslated(11,99, "will update") & @CRLF & GetTranslated(11,97, "here after") & @CRLF & GetTranslated(11,98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 50, $y, 16, 16)
$lblGoldLoot = GUICtrlCreateLabel("", $x - 15, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,21, "The total amount of Gold you gained or lost while the Bot is running.") & @CRLF & GetTranslated(11,22, "(This includes manual spending of resources on upgrade of buildings)")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 50, $y, 16, 16)
$lblElixirLoot = GUICtrlCreateLabel("", $x - 15, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,23, "The total amount of Elixir you gained or lost while the Bot is running.") & @CRLF & GetTranslated(11,22, "(This includes manual spending of resources on upgrade of buildings)")
GUICtrlSetTip(-1, $txtTip)
$y += 17
$picDarkLoot = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 50, $y, 16, 16)
$lblDarkLoot = GUICtrlCreateLabel("", $x - 15, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,24, "The total amount of Dark Elixir you gained or lost while the Bot is running.") & @CRLF & GetTranslated(11,22, "(This includes manual spending of resources on upgrade of buildings)")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 50, $y, 16, 16)
$lblTrophyLoot = GUICtrlCreateLabel("", $x - 15, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,25, "The amount of Trophies you gained or lost while the Bot is running.")
GUICtrlSetTip(-1, $txtTip)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$x = 400
$y = 145
$grpHourlyStats = GUICtrlCreateGroup(GetTranslated(11,26, "Gain per Hour"), $x - 20, $y - 15, 80, 90)
$lblHourlyStatsTemp = GUICtrlCreateLabel(GetTranslated(11,3, "Report") & @CRLF & GetTranslated(11,99, "will update") & @CRLF & GetTranslated(11,97, "here after") & @CRLF & GetTranslated(11,98, "each attack."), $x - 15, $y + 5, 100, 65, BitOR($SS_LEFT, $BS_MULTILINE))
GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 40, $y, 16, 16)
$lblHourlyStatsGold = GUICtrlCreateLabel("", $x - 20, $y + 2, 55, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,27, "Gold gain per hour")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 40, $y, 16, 16)
$lblHourlyStatsElixir = GUICtrlCreateLabel("", $x - 20, $y + 2, 55, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,28, "Elixir gain per hour")
GUICtrlSetTip(-1, $txtTip)
$y += 17
$picHourlyStatsDark = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 40, $y, 16, 16)
$lblHourlyStatsDark = GUICtrlCreateLabel("", $x - 20, $y + 2, 55, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,29, "Dark Elixir gain per hour")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 40, $y, 16, 16)
$lblHourlyStatsTrophy = GUICtrlCreateLabel("", $x - 20, $y + 2, 55, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,30, "Trophy gain per hour")
GUICtrlSetTip(-1, $txtTip)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$x = 400
$y = 220
$btnResetStats = GUICtrlCreateButton(GetTranslated(11,31, "Reset Stats"), $x + 1, $y + 3, 60, 20)
GUICtrlSetOnEvent(-1, "btnResetStats")
GUICtrlSetState(-1, $GUI_DISABLE)

$x = 30
$y = 260
$grpStatsMisc = GUICtrlCreateGroup(GetTranslated(11,32, "Stats: Misc"), $x - 20, $y - 20, 450, 140)
$y -= 2
$x = 25
GUICtrlCreateIcon($pIconLib, $eIcnBldgTarget, $x - 10, $y, 16, 16)
$lblvillagesattacked = GUICtrlCreateLabel(GetTranslated(11,33, "Attacked") & ":", $x + 8, $y + 2, -1, 17)
$lblresultvillagesattacked = GUICtrlCreateLabel("0", $x + 40, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,34, "The No. of Villages that were attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnBldgX, $x - 10, $y, 16, 16)
$lblvillagesskipped = GUICtrlCreateLabel(GetTranslated(11,35, "Skipped")&":", $x + 8, $y + 2, -1, 17)
$lblresultvillagesskipped = GUICtrlCreateLabel("0", $x + 40, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,36, "The No. of Villages that were skipped during search by the Bot.")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnWallGold, $x - 10, $y, 16, 16)
$lblwallbygold = GUICtrlCreateLabel(GetTranslated(11,37, "Upg. by Gold") &":", $x + 8, $y + 2, -1, 17)
$lblWallgoldmake = GUICtrlCreateLabel("0", $x + 40, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,38, "The No. of Walls upgraded by Gold.")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnWallElixir, $x - 10, $y, 16, 16)
$lblwallbyelixir = GUICtrlCreateLabel(GetTranslated(11,39, "Upg. by Elixir") &":", $x + 8, $y + 2, -1, 17)
$lblWallelixirmake = GUICtrlCreateLabel("0", $x + 40, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,40, "The No. of Walls upgraded by Elixir.")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnBldgGold, $x - 10, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,37, "Upg. by Gold") & ":", $x + 8, $y + 2, -1, 17)
$lblNbrOfBuildingUpgGold = GUICtrlCreateLabel("0", $x + 40, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,41, "The number of buildings upgraded using gold")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnBldgElixir, $x - 10, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,39, "Upg. by Elixir") & ":", $x + 8, $y + 2, -1, 17)
$lblNbrOfBuildingUpgElixir = GUICtrlCreateLabel("0", $x + 40, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,42, "The number of buildings upgraded using elixir")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnHeroes, $x - 10, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,43, "Hero Upgrade") & ":", $x + 8, $y + 2, -1, 17)
$lblNbrOfHeroUpg = GUICtrlCreateLabel("0", $x + 40, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,44, "The number of heroes upgraded")
GUICtrlSetTip(-1, $txtTip)

$x = 146
$y = 258
GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 5, $y, 16, 16)
$lbltrophiesdropped = GUICtrlCreateLabel(GetTranslated(11,45, "Dropped") & ":", $x + 13, $y + 2, -1, 17)
$lblresulttrophiesdropped = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,46, "The amount of Trophies dropped by the Bot due to Trophy Settings (on Misc Tab).")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnHourGlass, $x - 5, $y, 16, 16)
$lblruntime = GUICtrlCreateLabel(GetTranslated(11,47, "Runtime") & ":", $x + 13, $y + 2, -1, 17)
$lblresultruntime = GUICtrlCreateLabel("00:00:00", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,48, "The total Running Time of the Bot.")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnWallGold, $x - 5, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,49, "Upg. Cost Gold") & ":", $x + 13, $y + 2, -1, 17)
$lblWallUpgCostGold = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,50, "The cost of gold used by bot while upgrading walls")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnWallElixir, $x - 5, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,51, "Upg. Cost Elixir") & ":", $x + 13, $y + 2, -1, 17)
$lblWallUpgCostElixir = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,52, "The cost of elixir used by bot while upgrading walls")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnBldgGold, $x - 5, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,49, "Upg. Cost Gold") & ":", $x + 13, $y + 2, -1, 17)
$lblBuildingUpgCostGold = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,53, "The cost of gold used by bot while upgrading buildings")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnBldgElixir, $x - 5, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,51, "Upg. Cost Elixir") & ":", $x + 13, $y + 2, -1, 17)
$lblBuildingUpgCostElixir = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,54, "The cost of elixir used by bot while upgrading buildings")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnHeroes, $x - 5, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,55, "Upg. Cost DElixir") & ":", $x + 13, $y + 2, -1, 17)
$lblHeroUpgCost = GUICtrlCreateLabel("0", $x + 85, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,56, "The cost of dark elixir used by bot while upgrading heroes")
GUICtrlSetTip(-1, $txtTip)

$x = 280
$y = 258

GUICtrlCreateIcon($pIconLib, $eIcnRecycle, $x + 27, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,57, "Nbr of OoS") & ":", $x + 45, $y + 2, -1, 17)
$lblNbrOfOoS = GUICtrlCreateLabel("0", $x + 115, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,58, "The number of Out of Sync error occurred")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnMagnifier, $x + 27, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,59, "Search Cost") & ":", $x + 45, $y + 2, -1, 17)
$lblSearchCost = GUICtrlCreateLabel("0", $x + 115, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,60, "Search cost for skipping villages in gold")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnArcher, $x + 27, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,61, "Train Cost Elixir") & ":", $x + 45, $y + 2, -1, 17)
$lblTrainCostElixir = GUICtrlCreateLabel("0", $x + 115, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,62, "Elixir spent for training Barrack Troops")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnMinion, $x + 27, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,63, "Train Cost DElixir") & ":", $x + 45, $y + 2, -1, 17)
$lblTrainCostDElixir = GUICtrlCreateLabel("0", $x + 115, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,64, "Dark Elixir spent for training Dark Barrack Troops")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 27, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,65, "Gold collected")&":", $x + 45, $y + 2, -1, 17)
$lblGoldFromMines = GUICtrlCreateLabel("0", $x + 115, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,66, "Gold gained by collecting mines")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 27, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,67, "Elixir collected") & ":", $x + 45, $y + 2, -1, 17)
$lblElixirFromCollectors = GUICtrlCreateLabel("0", $x + 115, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,68, "Elixir gained by collecting collectors")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 27, $y, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,69, "DElixir collected") & ":", $x + 45, $y + 2, -1, 17)
$lblDElixirFromDrills = GUICtrlCreateLabel("0", $x + 115, $y + 2, 60, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,70, "Dark Elixir gained by collecting drills")
GUICtrlSetTip(-1, $txtTip)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$x = 30
$y = 405
$grpStatsDB = GUICtrlCreateGroup(GetTranslated(11,71, "Dead Base"), $x - 20, $y - 20, 111, 120)
GUICtrlCreateLabel(GetTranslated(11,72, "Attacked") & ":", $x - 15, $y - 2, -1, 17)
$lblAttacked[$DB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,73, "The No. of Dead Base that were attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnGold, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalGoldGain[$DB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,75, "The amount of Gold gained from Dead Bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,75, "The amount of Gold gained from Dead Bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnDark, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalDElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,100, "The amount of Dark Elixir gained from Dead Bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalTrophyGain[$DB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,76, "The amount of Elixir gained from Dead Bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
$lblNbrOfDetectedMines[$DB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 18, 17, $SS_RIGHT)
GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 1, $y - 4, 16, 16)
$lblNbrOfDetectedCollectors[$DB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 18, 17, $SS_RIGHT)
GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 37, $y - 4, 16, 16)
$lblNbrOfDetectedDrills[$DB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 18, 17, $SS_RIGHT)
GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 73, $y - 4, 16, 16)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$x += 108 + 5
$y = 405
$grpStatsLB = GUICtrlCreateGroup(GetTranslated(11,78, "Live Base"), $x - 20, $y - 20, 111, 120)
GUICtrlCreateLabel(GetTranslated(11,72, "Attacked") & ":", $x - 15, $y - 2, -1, 17)
$lblAttacked[$LB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,79, "The No. of Live Base that were attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnGold, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalGoldGain[$LB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,80, "The amount of Gold gained from Live Bases attacked by the Bot")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,81, "The amount of Elixir gained from Live Bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnDark, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalDElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,82, "The amount of Dark Elixir gained from Live Bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalTrophyGain[$LB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,83, "The amount of Trophy gained from Live Bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
$lblNbrOfDetectedMines[$LB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 18, 17, $SS_RIGHT)
GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 1, $y - 4, 16, 16)
$lblNbrOfDetectedCollectors[$LB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 18, 17, $SS_RIGHT)
GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 37, $y - 4, 16, 16)
$lblNbrOfDetectedDrills[$LB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 18, 17, $SS_RIGHT)
GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 73, $y - 4, 16, 16)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$x += 108 + 5
$y = 405
$grpStatsTB = GUICtrlCreateGroup(GetTranslated(11,84, "TH Bully"), $x - 20, $y - 20, 111, 120)
GUICtrlCreateLabel(GetTranslated(11,72, "Attacked") & ":", $x - 15, $y - 2, -1, 17)
$lblAttacked[$TB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,85, "The No. of TH Bully bases that were attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnGold, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalGoldGain[$TB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,86, "The amount of Gold gained from TH Bully bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalElixirGain[$TB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,87, "The amount of Elixir gained from TH Bully bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnDark, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalDElixirGain[$TB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,88, "The amount of Dark Elixir gained from TH Bully bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalTrophyGain[$TB] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,89, "The amount of Trophy gained from TH Bully bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
$lblNbrOfDetectedMines[$TB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 18, 17, $SS_RIGHT)
GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 1, $y - 4, 16, 16)
$lblNbrOfDetectedCollectors[$TB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 18, 17, $SS_RIGHT)
GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 37, $y - 4, 16, 16)
$lblNbrOfDetectedDrills[$TB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 18, 17, $SS_RIGHT)
GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 73, $y - 4, 16, 16)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$x += 108 + 5
$y = 405
$grpStatsTS = GUICtrlCreateGroup(GetTranslated(11,90, "TH Snipe"), $x - 20, $y - 20, 111, 120)
GUICtrlCreateLabel(GetTranslated(11,72, "Attacked") & ":", $x - 15, $y - 2, -1, 17)
$lblAttacked[$TS] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,101,"The No. of TH Snipes attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)

$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnGold, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalGoldGain[$TS] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,91, "The amount of Gold gained from TH Snipe bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalElixirGain[$TS] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,92, "The amount of Elixir gained from TH Snipe bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnDark, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalDElixirGain[$TS] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,93, "The amount of Dark Elixir gained from TH Snipe bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 15, $y - 4, 16, 16)
GUICtrlCreateLabel(GetTranslated(11,74, "gain") & ":", $x + 3, $y - 2, -1, 17)
$lblTotalTrophyGain[$TS] = GUICtrlCreateLabel("0", $x + 2, $y - 2, 80, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,94, "The amount of Trophy gained from TH Snipe bases attacked by the Bot.")
GUICtrlSetTip(-1, $txtTip)
$y += 17
GUICtrlCreateIcon($pIconLib, $eIcnGreenLight, $x - 15, $y - 4, 16, 16)
;GUICtrlCreateLabel("Success:", $x - 15, $y - 2, -1, 17)
$lblNbrOfTSSuccess = GUICtrlCreateLabel("0", $x + 8, $y - 2, 25, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,95, "The number of successful TH Snipes")
GUICtrlSetTip(-1, $txtTip)
GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x + 35, $y - 4, 16, 16)
;GUICtrlCreateLabel("Fail:", $x + 50, $y - 2, -1, 17)
$lblNbrOfTSFailed = GUICtrlCreateLabel("0", $x + 58, $y - 2, 25, 17, $SS_RIGHT)
$txtTip = GetTranslated(11,96, "The number of failed TH Snipe attempt")
GUICtrlSetTip(-1, $txtTip)
GUICtrlCreateGroup("", -99, -99, 1, 1)
