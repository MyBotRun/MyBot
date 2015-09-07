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
;~ Troops Tab
;~ -------------------------------------------------------------
$tabTroops = GUICtrlCreateTabItem("Troops")
	Local $x = 30, $y = 150
	$grpTroopComp = GUICtrlCreateGroup("Army Composition", $x - 20, $y - 20, 222, 55)
		$cmbTroopComp = GUICtrlCreateCombo("", $x - 5, $y, 190, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Set the type of Army composition." & @CRLF & "'Use Barracks Mode' or 'Custom Army' is for manual compositions.")
			GUICtrlSetOnEvent(-1, "cmbTroopComp")
			GUICtrlSetData(-1, "Preset: Archers|Preset: Barbarians|Preset: Goblins|Preset: B.Arch|Preset: B.A.G.G.|Preset: B.A.Giant|Preset: B.A.Goblin|Preset: B.A.G.G.Wall|Use Barrack Mode|Custom Army", "Custom Army")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x += 227
	$grpBarrackMode = GUICtrlCreateGroup("Barrack Mode", $x - 20, $y -20, 223, 75)
		$lblBarrack1 = GUICtrlCreateLabel("1:", $x - 5, $y + 5, -1, -1)
		$cmbBarrack1 = GUICtrlCreateCombo("", $x + 10, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Set the Troops to make in Barrack 1.")
			GUICtrlSetData(-1, "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas", "Barbarians") ; "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas"
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 2
		$lblBarrack2 = GUICtrlCreateLabel("2:", $x - 5, $y + 26, -1, -1)
		$cmbBarrack2 = GUICtrlCreateCombo("", $x + 10, $y + 21, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Set the Troops to make in Barrack 2.")
			GUICtrlSetData(-1, "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas", "Archers") ; "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas"
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y -= 2
		$lblBarrack3 = GUICtrlCreateLabel("3:", $x + 100, $y + 5, -1, -1)
		$cmbBarrack3 = GUICtrlCreateCombo("", $x + 115, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Set the Troops to make in Barrack 3.")
			GUICtrlSetData(-1, "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas", "Archers") ; "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas"
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 2
		$lblBarrack4 = GUICtrlCreateLabel("4:", $x + 100, $y + 26, -1, -1)
		$cmbBarrack4 = GUICtrlCreateCombo("", $x + 115, $y + 21, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Set the Troops to make in Barrack 4.")
			GUICtrlSetData(-1, "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas", "Goblins") ; "Barbarians|Archers|Giants|Goblins|WallBreakers|Balloons|Wizards|Healers|Dragons|Pekkas"
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y = 230
	$grpBoosterOptions = GUICtrlCreateGroup("Boost Options", $x - 20, $y - 20, 223, 95)
	$y -= 5
		GUICtrlCreateIcon ($pIconLib, $eIcnTroops, $x, $y + 2, 16, 16)
	$lblFullTroop = GUICtrlCreateLabel("Raid when Troops reach:",$x + 25, $y + 5, -1, 17)
	$txtFullTroop = GUICtrlCreateInput("100",  $x + 150, $y, 35, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetTip(-1, "Enter percentage")
		GUICtrlSetLimit(-1, 3)
	$lblFullTroop = GUICtrlCreateLabel("%",$x + 188, $y + 5, -1, 17)
	$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnBarrackBoost, $x, $y + 2, 16, 16)
	$lblBoostBarracks = GUICtrlCreateLabel("Barracks Boosts left:", $x + 25, $y + 5, -1, -1)
		$txtTip = "Use this to boost your Barracks with GEMS! Use with caution!"
		GUICtrlSetTip(-1, $txtTip)
	$cmbBoostBarracks = GUICtrlCreateCombo("", $x + 150, $y, 35, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "0|1|2|3|4|5", "0")
		GUICtrlSetTip(-1, $txtTip)
	$y += 25
	GUICtrlCreateIcon ($pIconLib, $eIcnSpellFactoryBoost, $x, $y + 2, 16, 16)
	$lblBoostSpellFactory = GUICtrlCreateLabel("Spell Factory Boosts left:", $x + 25, $y + 5, -1, -1)
		$txtTip = "Use this to boost your Spell Factory with GEMS! Use with caution!"
		GUICtrlSetTip(-1, $txtTip)
	$cmbBoostSpellFactory = GUICtrlCreateCombo("", $x + 150, $y, 35, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "0|1|2|3|4|5", "0")
		GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 210
	$grpTroops = GUICtrlCreateGroup("Troops", $x - 20, $y - 20, 222, 115)
		$y +=5
		GUICtrlCreateIcon ($pIconLib, $eIcnBarbarian, $x - 5, $y - 5, 24, 24)
		$lblBarbarians = GUICtrlCreateLabel("Barbarians:", $x + 25, $y, -1, -1)
		$txtNumBarb = GUICtrlCreateInput("30", $x + 130, $y - 5, 55, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Set the % of Barbarians to make.")
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentBarbarians = GUICtrlCreateLabel("%", $x + 188, $y, -1, -1)
		$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnArcher, $x - 5, $y - 5, 24, 24)
		$lblArchers = GUICtrlCreateLabel("Archers:", $x + 25, $y, -1, -1)
		$txtNumArch = GUICtrlCreateInput("60", $x + 130, $y - 5, 55, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Set the % of Archers to make.")
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentArchers = GUICtrlCreateLabel("%", $x + 188, $y, -1, -1)
		$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnGoblin, $x - 5, $y - 5, 24, 24)
		$lblGoblins = GUICtrlCreateLabel("Goblins:", $x + 25, $y, -1, -1)
		$txtNumGobl = GUICtrlCreateInput("10", $x + 130, $y - 5, 55, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Set the % of Goblins to make.")
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentGoblins = GUICtrlCreateLabel("%", $x + 188, $y, -1, -1)
		$y += 25
		$lblTotal = GUICtrlCreateLabel("Total:", $x + 95, $y - 5, -1, -1, $SS_RIGHT)
		$lblTotalCount = GUICtrlCreateLabel("100", $x + 130, $y - 5, 55, 15, $SS_CENTER)
			GUICtrlSetBkColor (-1, $COLOR_MONEYGREEN) ;lime, moneygreen
		$lblPercentTotal = GUICtrlCreateLabel("%", $x + 188, $y - 5, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 330
	$grpOtherTroops = GUICtrlCreateGroup("Add. Troops", $x - 20, $y - 20, 222, 195)
		GUICtrlCreateIcon ($pIconLib, $eIcnGiant, $x - 5, $y - 5, 24, 24)
		$lblGiants = GUICtrlCreateLabel("No. of Giants:", $x + 25, $y, -1, -1)
		$txtNumGiant = GUICtrlCreateInput("4", $x + 130, $y - 5, 55, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Giants to make.")
			GUICtrlSetLimit(-1, 2)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnWallBreaker, $x - 5, $y - 5, 24, 24)
		$lblWallBreakers = GUICtrlCreateLabel("No. of Wall Breakers:", $x + 25, $y, -1, -1)
		$txtNumWall = GUICtrlCreateInput("4", $x + 130, $y - 5, 55, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Wall Breakers to make.")
			GUICtrlSetLimit(-1, 3)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnBalloon, $x - 5, $y - 5, 24, 24)
		$lblBalloons = GUICtrlCreateLabel("No. of Balloons:", $x + 25, $y, -1, -1)
		$txtNumBall = GUICtrlCreateInput("0", $x + 130, $y - 5, 55, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Balloons to make.")
			GUICtrlSetLimit(-1, 3)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnWizard, $x - 5, $y - 5, 24, 24)
		$lblWizards = GUICtrlCreateLabel("No. of Wizards:", $x + 25, $y, -1, -1)
		$txtNumWiza = GUICtrlCreateInput("0", $x + 130, $y - 5, 55, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Wizards to make.")
			GUICtrlSetLimit(-1, 3)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnHealer, $x - 5, $y - 5, 24, 24)
		$lblHealers = GUICtrlCreateLabel("No. of Healers:", $x + 25, $y, -1, -1)
		$txtNumHeal = GUICtrlCreateInput("0", $x + 130, $y - 5, 55, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Healers to make.")
			GUICtrlSetLimit(-1, 3)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnDragon, $x - 5, $y - 5, 24, 24)
		$lblDragons = GUICtrlCreateLabel("No. of Dragons:", $x + 25, $y, -1, -1)
		$txtNumDrag = GUICtrlCreateInput("0", $x + 130, $y - 5, 55, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Dragons to make.")
			GUICtrlSetLimit(-1, 3)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnPekka, $x - 5, $y - 5, 24, 24)
		$lblPekka = GUICtrlCreateLabel("No. of P.E.K.K.A.:", $x + 25, $y, -1, -1)
		$txtNumPekk = GUICtrlCreateInput("0", $x + 130, $y - 5, 55, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of P.E.K.K.A. to make.")
			GUICtrlSetLimit(-1, 3)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x +=  227
	$y = 330
	$grpDarkTroops = GUICtrlCreateGroup("Add. Dark Troops", $x - 20, $y - 20, 223, 195)
		GUICtrlCreateIcon ($pIconLib, $eIcnMinion, $x - 5, $y - 5, 24, 24)
		$lblMinion = GUICtrlCreateLabel("No. of Minions:", $x + 25, $y, -1, -1)
		$txtNumMini = GUICtrlCreateInput("0", $x + 130, $y - 5, 55, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Minions to make.")
			GUICtrlSetLimit(-1, 3)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnHogRider, $x - 5, $y - 5, 24, 24)
		$lblHogRiders = GUICtrlCreateLabel("No. of Hog Riders:", $x + 25, $y, -1, -1)
		$txtNumHogs = GUICtrlCreateInput("0", $x + 130, $y - 5, 55, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Hog Riders to make.")
			GUICtrlSetLimit(-1, 2)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnValkyrie, $x - 5, $y - 5, 24, 24)
		$lblValkyries = GUICtrlCreateLabel("No. of Valkyries:", $x + 25, $y, -1, -1)
		$txtNumValk = GUICtrlCreateInput("0", $x + 130, $y - 5, 55, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Valkyries to make.")
			GUICtrlSetLimit(-1, 2)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnGolem, $x - 5, $y - 5, 24, 24)
		$lblGolems = GUICtrlCreateLabel("No. of Golems:", $x + 25, $y, -1, -1)
		$txtNumGole = GUICtrlCreateInput("0", $x + 130, $y - 5, 55, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Golems to make.")
			GUICtrlSetLimit(-1, 2)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnWitch, $x - 5, $y - 5, 24, 24)
		$lblWitches = GUICtrlCreateLabel("No. of Witches:", $x + 25, $y, -1, -1)
		$txtNumWitc = GUICtrlCreateInput("0", $x + 130, $y - 5, 55, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Witches to make.")
			GUICtrlSetLimit(-1, 2)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnLavaHound, $x - 5, $y - 5, 24, 24)
		$lblLavaHounds = GUICtrlCreateLabel("No. of Lava Hounds:", $x + 25, $y, -1, -1)
		$txtNumLava = GUICtrlCreateInput("0", $x + 130, $y - 5, 55, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, "Enter the No. of Lava Hounds to make.")
			GUICtrlSetLimit(-1, 2)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
