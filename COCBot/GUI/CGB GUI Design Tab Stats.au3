; #FUNCTION# ====================================================================================================================
; Name ..........: CGB GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015)
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
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
$tabStats = GUICtrlCreateTabItem("Stats")
Local $x = 30, $y = 150
	$grpResourceOnStart = GUICtrlCreateGroup("Stats: Started with", $x - 20, $y - 20, 110, 105)
		$lblResultStatsTemp = GUICtrlCreateLabel("Report" & @CRLF & "will appear" & @CRLF & "here on" & @CRLF & "first run.", $x - 5, $y + 5, 100, 65, BITOR($SS_LEFT, $BS_MULTILINE))
		GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x + 60, $y, 16, 16)
		$lblResultGoldStart = GUICtrlCreateLabel("", $x, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = "The amount of Gold you had when the bot started."
			GUICtrlSetTip(-1, $txtTip)
		$y +=20
		GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x + 60, $y, 16, 16)
		$lblResultElixirStart = GUICtrlCreateLabel("", $x, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = "The amount of Elixir you had when the bot started."
			GUICtrlSetTip(-1, $txtTip)
		$y +=20
		$picResultDEStart = GUICtrlCreateIcon ($pIconLib, $eIcnDark, $x + 60, $y, 16, 16)
		$lblResultDEStart = GUICtrlCreateLabel("", $x, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = "The amount of Dark Elixir you had when the bot started."
			GUICtrlSetTip(-1, $txtTip)
		$y +=20
		GUICtrlCreateIcon ($pIconLib, $eIcnTrophy, $x + 60, $y, 16, 16)
		$lblResultTrophyStart = GUICtrlCreateLabel("", $x, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = "The amount of Trophies you had when the bot started."
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 145
	$y = 150
	$grpLastAttack = GUICtrlCreateGroup("Stats: Last Attack", $x - 20, $y - 20, 110, 105)
		$lblLastAttackTemp = GUICtrlCreateLabel("Report" & @CRLF & "will update" & @CRLF & "here after" & @CRLF & "each attack.", $x - 5, $y + 5, 100, 65, BITOR($SS_LEFT, $BS_MULTILINE))
		GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x + 60, $y, 16, 16)
		$lblGoldLastAttack = GUICtrlCreateLabel("", $x, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = "The amount of Gold you gained on the last attack."
			GUICtrlSetTip(-1, $txtTip)
		$y +=20
		GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x + 60, $y, 16, 16)
		$lblElixirLastAttack = GUICtrlCreateLabel("", $x, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = "The amount of Elixir you gained on the last attack."
			GUICtrlSetTip(-1, $txtTip)
		$y +=20
		$picDarkLastAttack = GUICtrlCreateIcon ($pIconLib, $eIcnDark, $x + 60, $y, 16, 16)
		$lblDarkLastAttack = GUICtrlCreateLabel("", $x, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = "The amount of Dark Elixir you gained on the last attack."
			GUICtrlSetTip(-1, $txtTip)
		$y +=20
		GUICtrlCreateIcon ($pIconLib, $eIcnTrophy, $x + 60, $y, 16, 16)
		$lblTrophyLastAttack = GUICtrlCreateLabel("", $x, $y + 2, 55, 17, $SS_RIGHT)
			$txtTip = "The amount of Trophies you gained or lost on the last attack."
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 260
	$y = 150
    $grpTotalLoot = GUICtrlCreateGroup("Stats: Total Loot", $x - 20, $y - 20, 150, 105)
		$lblTotalLootTemp = GUICtrlCreateLabel("Report" & @CRLF & "will update" & @CRLF & "here after" & @CRLF & "each attack.", $x - 5, $y + 5, 100, 65, BITOR($SS_LEFT, $BS_MULTILINE))
		GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x + 100, $y, 16, 16)
		$lblGoldLoot =  GUICtrlCreateLabel("", $x - 30, $y + 2, 120, 17, $SS_RIGHT)
			$txtTip = "The total amount of Gold you gained or lost while the Bot is running." & @CRLF & "(This includes manual spending of resources on upgrade of buildings)"
			GUICtrlSetTip(-1, $txtTip)
		$y +=20
		GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x + 100, $y, 16, 16)
		$lblElixirLoot =  GUICtrlCreateLabel("", $x - 30, $y + 2, 120, 17, $SS_RIGHT)
			$txtTip = "The total amount of Elixir you gained or lost while the Bot is running." & @CRLF & "(This includes manual spending of resources on upgrade of buildings)"
			GUICtrlSetTip(-1, $txtTip)
		$y +=20
		$picDarkLoot = GUICtrlCreateIcon ($pIconLib, $eIcnDark, $x + 100, $y, 16, 16)
        $lblDarkLoot =  GUICtrlCreateLabel("", $x - 30, $y + 2, 120, 17, $SS_RIGHT)
			$txtTip = "The total amount of Dark Elixir you gained or lost while the Bot is running." & @CRLF & "(This includes manual spending of resources on upgrade of buildings)"
			GUICtrlSetTip(-1, $txtTip)
		$y +=20
		GUICtrlCreateIcon ($pIconLib, $eIcnTrophy, $x + 100, $y, 16, 16)
		$lblTrophyLoot = GUICtrlCreateLabel("", $x - 30, $y + 2, 120, 17, $SS_RIGHT)
			$txtTip = "The amount of Trophies you gained or lost while the Bot is running."
			GUICtrlSetTip(-1, $txtTip)
    GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 395
	$y = 135
	$btnMoreStats = GUICtrlCreateButton ("More Stats", $x, $y, 60,21)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$y +=25
	$btnExportCSV = GUICtrlCreateButton ("Export CSV", $x, $y, 60,21)
		GUICtrlSetState(-1, $GUI_DISABLE)
#cs    $y +=25
    $btnLoots = GUICtrlCreateButton ("Loots", $x, $y, 60,21)
        GUICtrlSetOnEvent(-1, "btnLoots")
    $y +=25
    $btnLogs = GUICtrlCreateButton ("Logs", $x, $y, 60,21)
        GUICtrlSetOnEvent(-1, "btnLogs")
#ce

	$x = 30
	$y = 260
	$grpStatsMisc = GUICtrlCreateGroup("Stats: Misc", $x - 20, $y - 20, 450, 60)
		$y -=2
		GUICtrlCreateIcon ($pIconLib, $eIcnTH1, $x - 10, $y + 7, 24, 24)
		GUICtrlCreateIcon ($pIconLib, $eIcnTH10, $x + 16, $y + 7, 24, 24)
        $lblvillagesattacked = GUICtrlCreateLabel("Attacked:", $x + 45, $y + 2, -1, 17)
        $lblresultvillagesattacked = GUICtrlCreateLabel("0", $x + 65, $y + 2, 60, 17, $SS_RIGHT)
			$txtTip = "The No. of Villages that were attacked by the Bot."
			GUICtrlSetTip(-1, $txtTip)
		$y += 17
        $lblvillagesskipped = GUICtrlCreateLabel("Skipped:", $x + 45, $y + 2, -1, 17)
        $lblresultvillagesskipped = GUICtrlCreateLabel("0", $x + 65, $y + 2, 60, 17, $SS_RIGHT)
			$txtTip = "The No. of Villages that were skipped during search by the Bot."
			GUICtrlSetTip(-1, $txtTip)
		$x = 185
		$y = 258
		GUICtrlCreateIcon ($pIconLib, $eIcnTrophy, $x, $y, 16, 16)
        $lbltrophiesdropped = GUICtrlCreateLabel("Dropped:", $x + 20, $y + 2, -1, 17)
        $lblresulttrophiesdropped = GUICtrlCreateLabel("0", $x + 80, $y + 2, 30, 17, $SS_RIGHT)
			$txtTip = "The amount of Trophies dropped by the Bot due to Trophy Settings (on Misc Tab)."
			GUICtrlSetTip(-1, $txtTip)
        $y += 17
        GUICtrlCreateIcon ($pIconLib, $eIcnHourGlass, $x, $y, 16, 16)
        $lblruntime = GUICtrlCreateLabel("Runtime:", $x + 20, $y + 2, -1, 17)
        $lblresultruntime = GUICtrlCreateLabel("00:00:00", $x + 50, $y + 2, 60, 17, $SS_RIGHT)
			$txtTip = "The total Running Time of the Bot."
			GUICtrlSetTip(-1, $txtTip)
		$x = 330
		$y = 258
		GUICtrlCreateIcon ($pIconLib, $eIcnWall, $x - 7, $y + 7, 24, 24)
        $lblwallbygold = GUICtrlCreateLabel("Upg. by Gold:", $x + 20, $y + 2, -1, 17)
		$lblWallgoldmake =  GUICtrlCreateLabel("0", $x + 55, $y + 2, 60, 17, $SS_RIGHT)
			$txtTip = "The No. of Walls upgraded by Gold."
			GUICtrlSetTip(-1, $txtTip)
		$y += 17
		$lblwallbyelixir = GUICtrlCreateLabel("Upg. by Elixir:", $x + 20, $y + 2, -1, 17)
		$lblWallelixirmake =  GUICtrlCreateLabel("0", $x + 55, $y + 2, 60, 17, $SS_RIGHT)
			$txtTip = "The No. of Walls upgraded by Elixir."
			GUICtrlSetTip(-1, $txtTip)
        ;$lbloutofsync = GUICtrlCreateLabel("Out Of Sync :", 260, 263, 100, 17) ; another stats next post
        ;$lblresultoutofsync = GUICtrlCreateLabel("0", 380, 263, 60, 17, $SS_RIGHT) ; another stats next post
	GUICtrlCreateGroup("", -99, -99, 1, 1)
