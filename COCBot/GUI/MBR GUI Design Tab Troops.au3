; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
;~ Language Variables used a lot
;~ -------------------------------------------------------------

$sTxtBarbarians = GetTranslated(1,17, "Barbarians")
$sTxtArchers = GetTranslated(1,18, "Archers")
$sTxtGiants = GetTranslated(1,19, "Giants")
$sTxtGoblins = GetTranslated(1,20, "Goblins")
$sTxtWallBreakers = GetTranslated(1,21, "Wall Breakers")
$sTxtWallBreakersShort = GetTranslated(1,46, "W.Breakers")

$sTxtBalloons = GetTranslated(1,22, "Balloons")
$sTxtWizards = GetTranslated(1,23, "Wizards")
$sTxtHealers = GetTranslated(1,24, "Healers")
$sTxtDragons = GetTranslated(1,25, "Dragons")
$sTxtPekkas = GetTranslated(1,26, "Pekkas")
$sTxtPekkasLong = GetTranslated(1,63, "P.E.K.K.A.s")

$sTxtMinions = GetTranslated(1,48, "Minions")
$sTxtHogRiders = GetTranslated(1,49, "Hog Riders")
$sTxtValkyries = GetTranslated(1,50, "Valkyries")
$sTxtGolems = GetTranslated(1,51, "Golems")
$sTxtWitches = GetTranslated(1,52, "Witches")
$sTxtLavaHounds = GetTranslated(1,53, "Lava Hounds")

$textBoostLeft = GetTranslated(1,33, "Boosts left")

$sTxtSetPerc = GetTranslated(1,40, "Set the % of")
$sTxtSetPerc2 = GetTranslated(1,41, " to make.")
$sTxtSetPerc3 = GetTranslated(1,45, "Enter the No. of")
$sTxtSetSpell = GetTranslated(1,55, "Spells to make.")

$sTxtLightning = GetTranslated(1,56, "Lightning")
$sTxtHeal = GetTranslated(1,57, "Heal")
$sTxtRage = GetTranslated(1,58, "Rage")
$sTxtJump = GetTranslated(1,65, "Jump")
$sTxtFreeze = GetTranslated(1,66, "Freeze")
$sTxtPoison = GetTranslated(1,59, "Poison")
$sTxtEarth = GetTranslated(1,67, "EarthQuake")
$sTxtHaste = GetTranslated(1,60, "Haste")

$sTxtNone = GetTranslated(1,70, "None")

;~ -------------------------------------------------------------
;~ Troops Tab
;~ -------------------------------------------------------------
$tabTroops = GUICtrlCreateTabItem(GetTranslated(1,1, "Troops"))
	Local $x = 30, $y = 150
	$grpTroopComp = GUICtrlCreateGroup(GetTranslated(1,2, "Elixir Troops"), $x - 20, $y - 20, 145, 55)
		$cmbTroopComp = GUICtrlCreateCombo("", $x - 10, $y, 125, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(1,3, "Set the type of Army composition.") & @CRLF & GetTranslated(1,4, "'Use Barrack Mode' or 'Custom Army' for manual compositions."))
			GUICtrlSetOnEvent(-1, "cmbTroopComp")
			GUICtrlSetData(-1, GetTranslated(1,5, "Preset: Archers") &"|" & GetTranslated(1,6, "Preset: Barbarians") & "|" & GetTranslated(1,7, "Preset: Goblins") & "|" & GetTranslated(1,8, "Preset: B.Arch") & "|" &  GetTranslated(1,9, "Preset: B.A.G.G.") & "|" & GetTranslated(1,10, "Preset: B.A.Giant") & "|" & GetTranslated(1,11, "Preset: B.A.Goblin")  &"|" & GetTranslated(1,12, "Preset: B.A.G.G.Wall") & "|" & GetTranslated(1,13, "Use Barrack Mode") & "|" & GetTranslated(1,14, "Custom Army"), GetTranslated(1,14, "Custom Army"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$x = 180
	$grpDarkTroopComp = GUICtrlCreateGroup(GetTranslated(1,68, "Dark Elixir Troops"), $x - 20, $y - 20, 145, 55)
		$cmbDarkTroopComp = GUICtrlCreateCombo("", $x - 10, $y, 125, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(1,3, "Set the type of Army composition.") & @CRLF & GetTranslated(1,4, "'Use Barrack Mode' or 'Custom Army' for manual compositions."))
			GUICtrlSetOnEvent(-1, "cmbDarkTroopComp")
			GUICtrlSetData(-1,  GetTranslated(1,13, "Use Barrack Mode") & "|" &GetTranslated(1,14, "Custom Army") & "|" & $sTxtNone, GetTranslated(1,14, "Custom Army"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$x = 30
	$x += 150
	$y = 150

	$y =379
	$grpRaidComp = GUICtrlCreateGroup(GetTranslated(1,27, "Army Strength"), $x - 20, $y - 15, 150, 52)
		$y += 10
		GUICtrlCreateIcon ($pIconLib, $eIcnBldgTarget, $x - 10, $y - 8, 24, 24)
		$lblFullTroop = GUICtrlCreateLabel(GetTranslated(1,28, "'Full' Camps="),$x + 20, $y , -1, 17)
		$txtFullTroop = GUICtrlCreateInput("100",  $x + 85, $y - 3, 30, 22, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(1,29, "Army camps are 'Full' when reaching this %, then start attack."))
		$lblFullTroop = GUICtrlCreateLabel("%",$x + 117, $y, -1, 17)
			GUICtrlSetLimit(-1, 3)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y = 150
	$x +=155
	$grpSpells = GUICtrlCreateGroup(GetTranslated(1,54, "Spells"), $x - 20, $y - 20, 145, 175)
		$lblLightningIcon = GUICtrlCreateIcon ($pIconLib, $eIcnLightSpell, $x - 10, $y - 5, 24, 24)
		GUICtrlSetState(-1, $GUI_HIDE)
		$lblLightningSpell = GUICtrlCreateLabel($sTxtLightning & ":", $x + 18, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$txtNumLightningSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtLightning & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesLightS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnHealSpell, $x - 10, $y - 5, 24, 24)
		GUICtrlSetState(-1, $GUI_HIDE)
		$lblHealSpell = GUICtrlCreateLabel($sTxtHeal & ":", $x + 18, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$txtNumHealSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHeal & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesHealS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnRageSpell, $x - 10, $y - 5, 24, 24)
		GUICtrlSetState(-1, $GUI_HIDE)
		$lblRageSpell = GUICtrlCreateLabel($sTxtRage & ":", $x + 18, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$txtNumRageSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtRage & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesRageS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnJumpSpell, $x - 10, $y - 5, 24, 24)
		GUICtrlSetState(-1, $GUI_HIDE)
		$lblJumpSpell = GUICtrlCreateLabel($sTxtJump &":", $x + 18, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$txtNumJumpSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtJump & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesJumpS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnFreezeSpell, $x - 10, $y - 5, 24, 24)
		GUICtrlSetState(-1, $GUI_HIDE)
		$lblFreezeSpell = GUICtrlCreateLabel($sTxtFreeze & ":", $x + 18, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$txtNumFreezeSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtFreeze & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblFreezeS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

		$y +=25
		$btnDarkElixirSpell = GUICtrlCreateButton(GetTranslated(1,71,"Dark Elixir Spells"), $x - 2, $y, 110, 24)
			IF $btnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetOnEvent(-1, "btnHideElixir")
		$btnElixirSpell = GUICtrlCreateButton(GetTranslated(1,72,"Elixir Spells"), $x - 2, $y, 110, 24)
			IF $btnColor then GUICtrlSetBkColor(-1, 0xDB4D4D)
			GUICtrlSetState(-1, $GUI_SHOW)
			GUICtrlSetOnEvent(-1, "btnHideDarkElixir")

		$y = 150
	$grpDarkSpells = GUICtrlCreateGroup(GetTranslated(1,54, "Spells"), $x - 20, $y - 20, 145, 175)
		$lblPoisonIcon = GUICtrlCreateIcon ($pIconLib, $eIcnPoisonSpell, $x - 10, $y - 5, 24, 24)
		$lblPoisonSpell = GUICtrlCreateLabel($sTxtPoison & ":", $x + 18, $y, -1, -1)
		$txtNumPoisonSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtPoison & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesPoisonS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnEarthquakeSpell, $x - 10, $y - 5, 24, 24)
		$lblEarthquakeSpell = GUICtrlCreateLabel($sTxtEarth & ":", $x + 18, $y, -1, -1)
		$txtNumEarthSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtEarth & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesEarthquakeS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnHasteSpell, $x - 10, $y - 5, 24, 24)
		$lblHasteSpell = GUICtrlCreateLabel($sTxtHaste & ":", $x + 18, $y, -1, -1)
		$txtNumHasteSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHaste & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesHasteS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		$lblTotal = GUICtrlCreateLabel(GetTranslated(1,61, "Spells Capacity") & ":", $x - 20 , $y + 4, -1, -1, $SS_RIGHT)
		$txtTotalCountSpell = GUICtrlCreateCombo("", $x + 80, $y , 35, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(1,62, "Enter the No. of Spells Capacity. Set to ZERO if you don´t want any Spells"))
			GUICtrlSetBkColor (-1, $COLOR_MONEYGREEN) ;lime, moneygreen
			GUICtrlSetData(-1, "0|2|4|6|7|8|9|10|11", "0")
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 210
	$grpBarrackMode = GUICtrlCreateGroup(GetTranslated(1,15, "Barrack Mode"), $x - 20, $y -20, 145, 117)
		GUICtrlSetState(-1, $GUI_HIDE)
		$lblBarrack1 = GUICtrlCreateLabel("1:", $x - 5, $y + 5, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$cmbBarrack1 = GUICtrlCreateCombo("", $x + 10, $y, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(1,16, "Set the Troops to make in Barrack")
			GUICtrlSetTip(-1, $txtTip & " 1.")
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers &"|" & $sTxtDragons & "|" & $sTxtPekkas, $sTxtBarbarians)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
		$y += 2
		$lblBarrack2 = GUICtrlCreateLabel("2:", $x - 5, $y + 26, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$cmbBarrack2 = GUICtrlCreateCombo("", $x + 10, $y + 21, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip & " 2.")
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers &"|" & $sTxtDragons & "|" & $sTxtPekkas, $sTxtArchers)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
		$y += 2
		$lblBarrack3 = GUICtrlCreateLabel("3:", $x - 5, $y + 47, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$cmbBarrack3 = GUICtrlCreateCombo("", $x + 10, $y + 42, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip & " 3.")
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers &"|" & $sTxtDragons & "|" & $sTxtPekkas, $sTxtArchers)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
		$y += 2
		$lblBarrack4 = GUICtrlCreateLabel("4:", $x - 5, $y + 68, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$cmbBarrack4 = GUICtrlCreateCombo("", $x + 10, $y + 63, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip & " 4.")
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers &"|" & $sTxtDragons & "|" & $sTxtPekkas, $sTxtGoblins)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y -= 6
	$grpTroops = GUICtrlCreateGroup(GetTranslated(1,39, "Troops"), $x - 20, $y - 20, 145, 115)
		$y += 2
		$icnBarb = GUICtrlCreateIcon ($pIconLib, $eIcnBarbarian, $x - 10, $y - 5, 24, 24)
		$lblBarbarians = GUICtrlCreateLabel($sTxtBarbarians & ":", $x + 20, $y, -1, -1)
		$txtNumBarb = GUICtrlCreateInput("30", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTxtBarbarians & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentBarbarians = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
		$y += 25
		$icnArch = GUICtrlCreateIcon ($pIconLib, $eIcnArcher, $x - 10, $y - 5, 24, 24)
		$lblArchers = GUICtrlCreateLabel($sTxtArchers & ":", $x + 20, $y, -1, -1)
		$txtNumArch = GUICtrlCreateInput("60", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTxtArchers & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentArchers = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
		$y += 25
		$icnGobl = GUICtrlCreateIcon ($pIconLib, $eIcnGoblin, $x - 10, $y - 5, 24, 24)
		$lblGoblins = GUICtrlCreateLabel($sTxtGoblins & ":", $x + 20, $y, -1, -1)
		$txtNumGobl = GUICtrlCreateInput("10", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTxtGoblins & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentGoblins = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
		$y += 22
		$lblTotal = GUICtrlCreateLabel(GetTranslated(1,42, "Total") & ":", $x + 45, $y, -1, -1, $SS_RIGHT)
		$lblTotalCount = GUICtrlCreateLabel("100", $x + 80, $y, 30, 15, $SS_CENTER)
			GUICtrlSetTip(-1, GetTranslated(1,43, "The total % of Troops should equal 100%."))
			GUICtrlSetBkColor (-1, $COLOR_MONEYGREEN) ;lime, moneygreen
		$lblPercentTotal = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 330
	$grpOtherTroops = GUICtrlCreateGroup(GetTranslated(1,44, "Add. Troops"), $x - 20, $y - 20, 145, 195)
		$icnGiant = GUICtrlCreateIcon ($pIconLib, $eIcnGiant, $x - 10, $y - 5, 24, 24)
		$lblGiants = GUICtrlCreateLabel($sTxtGiants & ":", $x + 20, $y, -1, -1)
		$txtNumGiant = GUICtrlCreateInput("4", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtGiants & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesGiants = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		$icnWall = GUICtrlCreateIcon ($pIconLib, $eIcnWallBreaker, $x - 10, $y - 5, 24, 24)
		$lblWallBreakers = GUICtrlCreateLabel($sTxtWallBreakersShort & ":", $x + 20, $y, -1, -1)
		$txtNumWall = GUICtrlCreateInput("4", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtWallBreakers & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesWallBreakers = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		$icnBall = GUICtrlCreateIcon ($pIconLib, $eIcnBalloon, $x - 10, $y - 5, 24, 24)
		$lblBalloons = GUICtrlCreateLabel($sTxtBalloons & ":", $x + 20, $y, -1, -1)
		$txtNumBall = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtBalloons & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesBalloons = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		$icnWiza = GUICtrlCreateIcon ($pIconLib, $eIcnWizard, $x - 10, $y - 5, 24, 24)
		$lblWizards = GUICtrlCreateLabel($sTxtWizards & ":", $x + 20, $y, -1, -1)
		$txtNumWiza = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtWizards & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesWizards = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		$icnHeal = GUICtrlCreateIcon ($pIconLib, $eIcnHealer, $x - 10, $y - 5, 24, 24)
		$lblHealers = GUICtrlCreateLabel($sTxtHealers & ":", $x + 20, $y, -1, -1)
		$txtNumHeal = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHealers & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesHealers = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		$icnDrag = GUICtrlCreateIcon ($pIconLib, $eIcnDragon, $x - 10, $y - 5, 24, 24)
		$lblDragons = GUICtrlCreateLabel($sTxtDragons & ":", $x + 20, $y, -1, -1)
		$txtNumDrag = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtDragons & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesDragons = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		$icnPekk = GUICtrlCreateIcon ($pIconLib, $eIcnPekka, $x - 10, $y - 5, 24, 24)
		$lblPekka = GUICtrlCreateLabel($sTxtPekkasLong & ":", $x + 20, $y, -1, -1)
		$txtNumPekk = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtPekkas & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesPekka = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 180
	$y = 210
	$grpDarkTroops = GUICtrlCreateGroup(GetTranslated(1,47, "Add. Dark Troops"), $x - 20, $y - 20, 150, 170)
		$icnMini = GUICtrlCreateIcon ($pIconLib, $eIcnMinion, $x - 10, $y - 5, 24, 24)
		$lblMinion = GUICtrlCreateLabel($sTxtMinions & ":", $x + 18, $y, -1, -1)
		$txtNumMini = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtMinions & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesMinions = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		$icnHogs = GUICtrlCreateIcon ($pIconLib, $eIcnHogRider, $x - 10, $y - 5, 24, 24)
		$lblHogRiders = GUICtrlCreateLabel($sTxtHogRiders & ":", $x + 18, $y, -1, -1)
		$txtNumHogs = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHogRiders & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesHogRiders = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		$icnValk = GUICtrlCreateIcon ($pIconLib, $eIcnValkyrie, $x - 10, $y - 5, 24, 24)
		$lblValkyries = GUICtrlCreateLabel($sTxtValkyries & ":", $x + 18, $y, -1, -1)
		$txtNumValk = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtValkyries & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesValkyries = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		$icnGole = GUICtrlCreateIcon ($pIconLib, $eIcnGolem, $x - 10, $y - 5, 24, 24)
		$lblGolems = GUICtrlCreateLabel($sTxtGolems & ":", $x + 18, $y, -1, -1)
		$txtNumGole = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtGolems & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesGolems = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		$icnWitc = GUICtrlCreateIcon ($pIconLib, $eIcnWitch, $x - 10, $y - 5, 24, 24)
		$lblWitches = GUICtrlCreateLabel($sTxtWitches & ":", $x + 18, $y, -1, -1)
		$txtNumWitc = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtWitches & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesWitches = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		$icnLava = GUICtrlCreateIcon ($pIconLib, $eIcnLavaHound, $x - 10, $y - 5, 24, 24)
		$lblLavaHounds = GUICtrlCreateLabel($sTxtLavaHounds & ":", $x + 18, $y, -1, -1)
		$txtNumLava = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtLavaHounds & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesLavaHounds = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 210
	$grpDarkBarrackMode = GUICtrlCreateGroup(GetTranslated(1,69, "Dark Barracks Troops"), $x - 20, $y -20, 145, 76)
		GUICtrlSetState(-1, $GUI_HIDE)
		$lblDarkBarrack1 = GUICtrlCreateLabel("1:", $x - 5, $y + 5, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$cmbDarkBarrack1 = GUICtrlCreateCombo("", $x + 10, $y, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(1,16, "Set the Troops to make in Barrack")
			GUICtrlSetTip(-1, $txtTip & " 1.")
			GUICtrlSetData(-1, $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds & "|" & $sTxtNone, $sTxtMinions)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
		$y += 2
		$lblDarkBarrack2 = GUICtrlCreateLabel("2:", $x - 5, $y + 26, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$cmbDarkBarrack2 = GUICtrlCreateCombo("", $x + 10, $y + 21, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip & " 2.")
			GUICtrlSetData(-1, $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds & "|" & $sTxtNone, $sTxtMinions)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
		$y += 2
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$x += 155
	$y = 330




	$grpBoosterOptions = GUICtrlCreateGroup(GetTranslated(1,30, "Boost Options"), $x - 20, $y - 20, 145, 195)
		$y -= 5
		GUICtrlCreateIcon ($pIconLib, $eIcnBarrackBoost, $x - 10, $y + 8, 24, 24)
		$lblQuantBoostBarracks = GUICtrlCreateLabel(GetTranslated(1,31, "Barracks") & ":", $x + 20, $y + 4 , -1, -1)
		$txtTip = GetTranslated(1,32, "How many Barracks to boost with GEMS! Use with caution!")
			GUICtrlSetTip(-1, $txtTip)
		$cmbQuantBoostBarracks = GUICtrlCreateCombo("", $x + 85, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4", "0")
			GUICtrlSetTip(-1, $txtTip)
		$lblBoostBarracks = GUICtrlCreateLabel($textBoostLeft & ":", $x + 20, $y + 27, -1, -1)
		$txtTip = GetTranslated(1,34, "Use this to boost your Barracks with GEMS! Use with caution!")
			GUICtrlSetTip(-1, $txtTip)
		$cmbBoostBarracks = GUICtrlCreateCombo("", $x + 85, $y+ 23 , 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
			GUICtrlSetTip(-1, $txtTip)
	$y += 50
		GUICtrlCreateIcon ($pIconLib, $eIcnSpellFactoryBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostSpellFactory = GUICtrlCreateLabel($textBoostLeft & ":", $x + 20, $y + 4, -1, -1)
		$txtTip = GetTranslated(1,35, "Use this to boost your Spell Factory with GEMS! Use with caution!")
			GUICtrlSetTip(-1, $txtTip)
		$cmbBoostSpellFactory = GUICtrlCreateCombo("", $x + 85, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
			GUICtrlSetTip(-1, $txtTip)
 	$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnDarkSpellBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostDarkSpellFactory = GUICtrlCreateLabel($textBoostLeft & ":", $x + 20, $y + 4, -1, -1)
		$txtTip = GetTranslated(1,36, "Use this to boost your Dark Spell Factory with GEMS! Use with caution!")
			GUICtrlSetTip(-1, $txtTip)
		$cmbBoostDarkSpellFactory = GUICtrlCreateCombo("", $x + 85, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
			GUICtrlSetTip(-1, $txtTip)
 	$y += 30
		GUICtrlCreateIcon ($pIconLib, $eIcnKingBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostBarbarianKing = GUICtrlCreateLabel($textBoostLeft & ":", $x + 20, $y + 4, -1, -1)
 		$txtTip = GetTranslated(1,37, "Use this to boost your Barbarian King with GEMS! Use with caution!")
			GUICtrlSetTip(-1, $txtTip)
		$cmbBoostBarbarianKing = GUICtrlCreateCombo("", $x + 85, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeKing")
 	$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnQueenBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostArcherQueen = GUICtrlCreateLabel($textBoostLeft & ":", $x + 20, $y + 4, -1, -1)
 		$txtTip = GetTranslated(1,38, "Use this to boost your Archer Queen with GEMS! Use with caution!")
 		GUICtrlSetTip(-1, $txtTip)
		$cmbBoostArcherQueen = GUICtrlCreateCombo("", $x + 85, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeQueen")
 	$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnWardenBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostWarden = GUICtrlCreateLabel($textBoostLeft & ":", $x + 20, $y + 4, -1, -1)
 		$txtTip = GetTranslated(1,64, "Use this to boost your Grand Warden with GEMS! Use with caution!")
 		GUICtrlSetTip(-1, $txtTip)
		$cmbBoostWarden = GUICtrlCreateCombo("", $x + 85, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeWarden")
 	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")