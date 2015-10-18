; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
;~ Troops Tab
;~ -------------------------------------------------------------
$tabTroops = GUICtrlCreateTabItem("Troops")
	Local $x = 30, $y = 150
	$grpTroopComp = GUICtrlCreateGroup("Army Composition", $x - 20, $y - 20, 145, 55)
		$cmbTroopComp = GUICtrlCreateCombo("", $x - 10, $y, 125, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Set the type of Army composition." & @CRLF & "'Use Barrack Mode' or 'Custom Army' for manual compositions.")
			GUICtrlSetOnEvent(-1, "cmbTroopComp")
			GUICtrlSetData(-1, "Preset: Archers|Preset: Barbarians|Preset: Goblins|Preset: B.Arch|Preset: B.A.G.G.|Preset: B.A.Giant|Preset: B.A.Goblin|Preset: B.A.G.G.Wall|Use Barrack Mode|Custom Army", "Custom Army")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x += 150
	$grpBarrackMode = GUICtrlCreateGroup("Barrack Mode", $x - 20, $y -20, 150, 123)
		$lblBarrack1 = GUICtrlCreateLabel("1:", $x - 5, $y + 5, -1, -1)
		$cmbBarrack1 = GUICtrlCreateCombo("", $x + 10, $y, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Set the Troops to make in Barrack 1.")
			GUICtrlSetData(-1, "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas", "Barbarians") ; "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas"
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 2
		$lblBarrack2 = GUICtrlCreateLabel("2:", $x - 5, $y + 26, -1, -1)
		$cmbBarrack2 = GUICtrlCreateCombo("", $x + 10, $y + 21, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Set the Troops to make in Barrack 2.")
			GUICtrlSetData(-1, "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas", "Archers") ; "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas"
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 2
		$lblBarrack3 = GUICtrlCreateLabel("3:", $x - 5, $y + 47, -1, -1)
		$cmbBarrack3 = GUICtrlCreateCombo("", $x + 10, $y + 42, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Set the Troops to make in Barrack 3.")
			GUICtrlSetData(-1, "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas", "Archers") ; "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas"
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 2
		$lblBarrack4 = GUICtrlCreateLabel("4:", $x - 5, $y + 68, -1, -1)
		$cmbBarrack4 = GUICtrlCreateCombo("", $x + 10, $y + 63, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Set the Troops to make in Barrack 4.")
			GUICtrlSetData(-1, "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas", "Goblins") ; "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas"
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 112
	$grpRaidComp = GUICtrlCreateGroup("Army Strength", $x - 20, $y - 15, 150, 52)
		$y += 10
		GUICtrlCreateIcon ($pIconLib, $eIcnBldgTarget, $x - 10, $y - 8, 24, 24)
		$lblFullTroop = GUICtrlCreateLabel("'Full' Camps=",$x + 20, $y , -1, 17)
		$txtFullTroop = GUICtrlCreateInput("99",  $x + 85, $y - 3, 30, 22, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Army camps are 'Full' when reaching this %, then start attack.")
		$lblFullTroop = GUICtrlCreateLabel("%",$x + 117, $y, -1, 17)
			GUICtrlSetLimit(-1, 3)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y = 150
	$x +=155
	$grpBoosterOptions = GUICtrlCreateGroup("Boost Options", $x - 20, $y - 20, 145, 175)
		$y -= 5
		GUICtrlCreateIcon ($pIconLib, $eIcnBarrackBoost, $x - 10, $y + 8, 24, 24)
		$lblQuantBoostBarracks = GUICtrlCreateLabel("Barracks:", $x + 20, $y + 4 , -1, -1)
		$txtTip = "How many Barracks to boost with GEMS! Use with caution!"
			GUICtrlSetTip(-1, $txtTip)
		$cmbQuantBoostBarracks = GUICtrlCreateCombo("", $x + 80, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4", "0")
			GUICtrlSetTip(-1, $txtTip)
		$lblBoostBarracks = GUICtrlCreateLabel("Boosts left:", $x + 20, $y + 27, -1, -1)
		$txtTip = "Use this to boost your Barracks with GEMS! Use with caution!"
			GUICtrlSetTip(-1, $txtTip)
		$cmbBoostBarracks = GUICtrlCreateCombo("", $x + 80, $y+ 23 , 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6", "0")
			GUICtrlSetTip(-1, $txtTip)
	$y += 50
		GUICtrlCreateIcon ($pIconLib, $eIcnSpellFactoryBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostSpellFactory = GUICtrlCreateLabel("Boosts left:", $x + 20, $y + 4, -1, -1)
		$txtTip = "Use this to boost your Spell Factory with GEMS! Use with caution!"
			GUICtrlSetTip(-1, $txtTip)
		$cmbBoostSpellFactory = GUICtrlCreateCombo("", $x + 80, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6", "0")
			GUICtrlSetTip(-1, $txtTip)
 	$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnDarkSpellBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostDarkSpellFactory = GUICtrlCreateLabel("Boosts left:", $x + 20, $y + 4, -1, -1)
		$txtTip = "Use this to boost your Dark Spell Factory with GEMS! Use with caution!"
			GUICtrlSetTip(-1, $txtTip)
		$cmbBoostDarkSpellFactory = GUICtrlCreateCombo("", $x + 80, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6", "0")
			GUICtrlSetTip(-1, $txtTip)
 	$y += 30
		GUICtrlCreateIcon ($pIconLib, $eIcnKingBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostBarbarianKing = GUICtrlCreateLabel("Boosts left:", $x + 20, $y + 4, -1, -1)
 		$txtTip = "Use this to boost your Barbarian King with GEMS! Use with caution!"
			GUICtrlSetTip(-1, $txtTip)
		$cmbBoostBarbarianKing = GUICtrlCreateCombo("", $x + 80, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6", "0")
			GUICtrlSetTip(-1, $txtTip)
 	$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnQueenBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostArcherQueen = GUICtrlCreateLabel("Boosts left:", $x + 20, $y + 4, -1, -1)
 		$txtTip = "Use this to boost your Archer Queen with GEMS! Use with caution!"
 		GUICtrlSetTip(-1, $txtTip)
		$cmbBoostArcherQueen = GUICtrlCreateCombo("", $x + 80, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6", "0")
			GUICtrlSetTip(-1, $txtTip)
 	GUICtrlCreateGroup("", -99, -99, 1, 1)


	Local $x = 30, $y = 210
	$grpTroops = GUICtrlCreateGroup("Troops", $x - 20, $y - 20, 145, 115)
		$y += 2
		GUICtrlCreateIcon ($pIconLib, $eIcnBarbarian, $x - 10, $y - 5, 24, 24)
		$lblBarbarians = GUICtrlCreateLabel("Barbarians:", $x + 20, $y, -1, -1)
		$txtNumBarb = GUICtrlCreateInput("30", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Set the % of Barbarians to make.")
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentBarbarians = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
		$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnArcher, $x - 10, $y - 5, 24, 24)
		$lblArchers = GUICtrlCreateLabel("Archers:", $x + 20, $y, -1, -1)
		$txtNumArch = GUICtrlCreateInput("60", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Set the % of Archers to make.")
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentArchers = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
		$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnGoblin, $x - 10, $y - 5, 24, 24)
		$lblGoblins = GUICtrlCreateLabel("Goblins:", $x + 20, $y, -1, -1)
		$txtNumGobl = GUICtrlCreateInput("10", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Set the % of Goblins to make.")
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentGoblins = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
		$y += 22
		$lblTotal = GUICtrlCreateLabel("Total:", $x + 45, $y, -1, -1, $SS_RIGHT)
		$lblTotalCount = GUICtrlCreateLabel("100", $x + 80, $y, 30, 15, $SS_CENTER)
			GUICtrlSetTip(-1, "The total % of Troops should equal 100%.")
			GUICtrlSetBkColor (-1, $COLOR_MONEYGREEN) ;lime, moneygreen
		$lblPercentTotal = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 330
	$grpOtherTroops = GUICtrlCreateGroup("Add. Troops", $x - 20, $y - 20, 145, 195)
		GUICtrlCreateIcon ($pIconLib, $eIcnGiant, $x - 10, $y - 5, 24, 24)
		$lblGiants = GUICtrlCreateLabel("Giants:", $x + 20, $y, -1, -1)
		$txtNumGiant = GUICtrlCreateInput("4", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Giants to make.")
			GUICtrlSetLimit(-1, 2)
		$lblTimesGiants = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnWallBreaker, $x - 10, $y - 5, 24, 24)
		$lblWallBreakers = GUICtrlCreateLabel("W.Breakers:", $x + 20, $y, -1, -1)
		$txtNumWall = GUICtrlCreateInput("4", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Wall Breakers to make.")
			GUICtrlSetLimit(-1, 3)
		$lblTimesWallBreakers = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnBalloon, $x - 10, $y - 5, 24, 24)
		$lblBalloons = GUICtrlCreateLabel("Balloons:", $x + 20, $y, -1, -1)
		$txtNumBall = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Balloons to make.")
			GUICtrlSetLimit(-1, 3)
		$lblTimesBalloons = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnWizard, $x - 10, $y - 5, 24, 24)
		$lblWizards = GUICtrlCreateLabel("Wizards:", $x + 20, $y, -1, -1)
		$txtNumWiza = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Wizards to make.")
			GUICtrlSetLimit(-1, 3)
		$lblTimesWallWizards = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnHealer, $x - 10, $y - 5, 24, 24)
		$lblHealers = GUICtrlCreateLabel("Healers:", $x + 20, $y, -1, -1)
		$txtNumHeal = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Healers to make.")
			GUICtrlSetLimit(-1, 3)
		$lblTimesHealers = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnDragon, $x - 10, $y - 5, 24, 24)
		$lblDragons = GUICtrlCreateLabel("Dragons:", $x + 20, $y, -1, -1)
		$txtNumDrag = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Dragons to make.")
			GUICtrlSetLimit(-1, 3)
		$lblTimesDragons = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnPekka, $x - 10, $y - 5, 24, 24)
		$lblPekka = GUICtrlCreateLabel("P.E.K.K.A.s:", $x + 20, $y, -1, -1)
		$txtNumPekk = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of P.E.K.K.A.s to make.")
			GUICtrlSetLimit(-1, 3)
		$lblTimesPekka = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x += 150
	$y = 330
	$grpDarkTroops = GUICtrlCreateGroup("Add. Dark Troops", $x - 20, $y - 20, 150, 195)
		GUICtrlCreateIcon ($pIconLib, $eIcnMinion, $x - 10, $y - 5, 24, 24)
		$lblMinion = GUICtrlCreateLabel("Minions:", $x + 18, $y, -1, -1)
		$txtNumMini = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Minions to make.")
			GUICtrlSetLimit(-1, 3)
		$lblTimesMinions = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnHogRider, $x - 10, $y - 5, 24, 24)
		$lblHogRiders = GUICtrlCreateLabel("Hog Riders:", $x + 18, $y, -1, -1)
		$txtNumHogs = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Hog Riders to make.")
			GUICtrlSetLimit(-1, 2)
		$lblTimesHogRiders = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnValkyrie, $x - 10, $y - 5, 24, 24)
		$lblValkyries = GUICtrlCreateLabel("Valkyries:", $x + 18, $y, -1, -1)
		$txtNumValk = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Valkyries to make.")
			GUICtrlSetLimit(-1, 2)
		$lblTimesValkyries = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnGolem, $x - 10, $y - 5, 24, 24)
		$lblGolems = GUICtrlCreateLabel("Golems:", $x + 18, $y, -1, -1)
		$txtNumGole = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Golems to make.")
			GUICtrlSetLimit(-1, 2)
		$lblTimesGolems = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnWitch, $x - 10, $y - 5, 24, 24)
		$lblWitches = GUICtrlCreateLabel("Witches:", $x + 18, $y, -1, -1)
		$txtNumWitc = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Witches to make.")
			GUICtrlSetLimit(-1, 2)
		$lblTimesWitches = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnLavaHound, $x - 10, $y - 5, 24, 24)
		$lblLavaHounds = GUICtrlCreateLabel("Lava Hounds:", $x + 18, $y, -1, -1)
		$txtNumLava = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Lava Hounds to make.")
			GUICtrlSetLimit(-1, 2)
		$lblTimesLavaHounds = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x += 155
	$y = 330
	$grpSpells = GUICtrlCreateGroup("Spells", $x - 20, $y - 20, 145, 195)
		GUICtrlCreateIcon ($pIconLib, $eIcnLightSpell, $x - 10, $y - 5, 24, 24)
		$lblLightningSpell = GUICtrlCreateLabel("Lightning:", $x + 20, $y, -1, -1)
		$txtNumLightningSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Lightning Spells to make.")
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState($txtNumLightningSpell, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesLightS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnHealSpell, $x - 10, $y - 5, 24, 24)
		$lblHealSpell = GUICtrlCreateLabel("Heal:", $x + 20, $y, -1, -1)
		$txtNumHealSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Heal Spells to make.")
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState($txtNumHealSpell, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesHealS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnRageSpell, $x - 10, $y - 5, 24, 24)
		$lblRageSpell = GUICtrlCreateLabel("Rage:", $x + 20, $y, -1, -1)
		$txtNumRageSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Rage Spells to make.")
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState($txtNumRageSpell, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesRageS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
#cs		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnJumpSpell, $x - 10, $y - 5, 24, 24)
		$lblJumpSpell = GUICtrlCreateLabel("Jump:", $x + 20, $y, -1, -1)
		$txtNumJumpS = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Jump Spells to make.")
			GUICtrlSetLimit(-1, 2)
		$lblTimesJumpS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnFreezeSpell, $x - 10, $y - 5, 24, 24)
		$lblFreezeSpell = GUICtrlCreateLabel("Freeze:", $x + 20, $y, -1, -1)
		$txtFreezeS = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Freeze Spells to make.")
			GUICtrlSetLimit(-1, 2)
#ce		$lblFreezeS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=50
		GUICtrlCreateIcon ($pIconLib, $eIcnPoisonSpell, $x - 10, $y - 5, 24, 24)
		$lblPoisonSpell = GUICtrlCreateLabel("Poison:", $x + 20, $y, -1, -1)
		$txtNumPoisonSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Poison Spells to make.")
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState($txtNumPoisonSpell, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesPoisonS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
#cs		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnEarthquakeSpell, $x - 10, $y - 5, 24, 24)
		$lblEarthquakeSpell = GUICtrlCreateLabel("Earthquake:", $x + 20, $y, -1, -1)
		$txtNumEarthquakeS = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Poison Spells to make.")
			GUICtrlSetLimit(-1, 2)
#ce		$lblTimesEarthquakeS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnHasteSpell, $x - 10, $y - 5, 24, 24)
		$lblHasteSpell = GUICtrlCreateLabel("Haste:", $x + 20, $y, -1, -1)
		$txtNumHasteSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Haste Spells to make.")
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState($txtNumHasteSpell, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesHasteS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)

		$y +=25
		$lblTotal = GUICtrlCreateLabel("Spells Capacity:", $x - 20 , $y + 4, -1, -1, $SS_RIGHT)
		$txtTotalCountSpell = GUICtrlCreateCombo("", $x + 80, $y , 35, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Enter the No. of Spells Capacity. Set to ZERO if you don´t want any Spells")
			GUICtrlSetBkColor (-1, $COLOR_MONEYGREEN) ;lime, moneygreen
			GUICtrlSetData(-1, "0|2|4|6|7|8|9|10|11", "0")
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
	GUICtrlCreateGroup("", -99, -99, 1, 1)


GUICtrlCreateTabItem("")
