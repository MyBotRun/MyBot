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
$sTxtPoison = GetTranslated(1,59, "Poison")
$sTxtHaste = GetTranslated(1,60, "Haste")

;~ -------------------------------------------------------------
;~ Troops Tab
;~ -------------------------------------------------------------
$tabTroops = GUICtrlCreateTabItem(GetTranslated(1,1, "Troops"))
	Local $x = 30, $y = 150
	$grpTroopComp = GUICtrlCreateGroup(GetTranslated(1,2, "Army Composition"), $x - 20, $y - 20, 145, 55)
		$cmbTroopComp = GUICtrlCreateCombo("", $x - 10, $y, 125, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(1,3, "Set the type of Army composition.") & @CRLF & GetTranslated(1,4, "'Use Barrack Mode' or 'Custom Army' for manual compositions."))
			GUICtrlSetOnEvent(-1, "cmbTroopComp")
			GUICtrlSetData(-1, GetTranslated(1,5, "Preset: Archers") &"|" & GetTranslated(1,6, "Preset: Barbarians") & "|" & GetTranslated(1,7, "Preset: Goblins") & "|" & GetTranslated(1,8, "Preset: B.Arch") & "|" &  GetTranslated(1,9, "Preset: B.A.G.G.") & "|" & GetTranslated(1,10, "Preset: B.A.Giant") & "|" & GetTranslated(1,11, "Preset: B.A.Goblin")  &"|" & GetTranslated(1,12, "Preset: B.A.G.G.Wall") & "|" & GetTranslated(1,13, "Use Barrack Mode") & "|" & GetTranslated(1,14, "Custom Army"), GetTranslated(1,14, "Custom Army"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x += 150
	$grpBarrackMode = GUICtrlCreateGroup(GetTranslated(1,15, "Barrack Mode"), $x - 20, $y -20, 150, 123)
		$lblBarrack1 = GUICtrlCreateLabel("1:", $x - 5, $y + 5, -1, -1)
		$cmbBarrack1 = GUICtrlCreateCombo("", $x + 10, $y, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(1,16, "Set the Troops to make in Barrack")
			GUICtrlSetTip(-1, $txtTip & " 1.")
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers &"|" & $sTxtDragons & "|" & $sTxtPekkas, $sTxtBarbarians)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 2
		$lblBarrack2 = GUICtrlCreateLabel("2:", $x - 5, $y + 26, -1, -1)
		$cmbBarrack2 = GUICtrlCreateCombo("", $x + 10, $y + 21, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip & " 2.")
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers &"|" & $sTxtDragons & "|" & $sTxtPekkas, $sTxtArchers)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 2
		$lblBarrack3 = GUICtrlCreateLabel("3:", $x - 5, $y + 47, -1, -1)
		$cmbBarrack3 = GUICtrlCreateCombo("", $x + 10, $y + 42, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip & " 3.")
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers &"|" & $sTxtDragons & "|" & $sTxtPekkas, $sTxtArchers)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 2
		$lblBarrack4 = GUICtrlCreateLabel("4:", $x - 5, $y + 68, -1, -1)
		$cmbBarrack4 = GUICtrlCreateCombo("", $x + 10, $y + 63, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip & " 4.")
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers &"|" & $sTxtDragons & "|" & $sTxtPekkas, $sTxtGoblins)
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 112
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
		GUICtrlCreateIcon ($pIconLib, $eIcnLightSpell, $x - 10, $y - 5, 24, 24)
		$lblLightningSpell = GUICtrlCreateLabel($sTxtLightning & ":", $x + 20, $y, -1, -1)
		$txtNumLightningSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtLightning & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState($txtNumLightningSpell, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesLightS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnHealSpell, $x - 10, $y - 5, 24, 24)
		$lblHealSpell = GUICtrlCreateLabel($sTxtHeal & ":", $x + 20, $y, -1, -1)
		$txtNumHealSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHeal & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState($txtNumHealSpell, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesHealS = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnRageSpell, $x - 10, $y - 5, 24, 24)
		$lblRageSpell = GUICtrlCreateLabel($sTxtRage & ":", $x + 20, $y, -1, -1)
		$txtNumRageSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtRage & " " & $sTxtSetSpell)
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
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnPoisonSpell, $x - 10, $y - 5, 24, 24)
		$lblPoisonSpell = GUICtrlCreateLabel($sTxtPoison & ":", $x + 20, $y, -1, -1)
		$txtNumPoisonSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtPoison & " " & $sTxtSetSpell)
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
		$lblHasteSpell = GUICtrlCreateLabel($sTxtHaste & ":", $x + 20, $y, -1, -1)
		$txtNumHasteSpell = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHaste & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState($txtNumHasteSpell, $GUI_DISABLE)
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
	$grpTroops = GUICtrlCreateGroup(GetTranslated(1,39, "Troops"), $x - 20, $y - 20, 145, 115)
		$y += 2
		GUICtrlCreateIcon ($pIconLib, $eIcnBarbarian, $x - 10, $y - 5, 24, 24)
		$lblBarbarians = GUICtrlCreateLabel($sTxtBarbarians & ":", $x + 20, $y, -1, -1)
		$txtNumBarb = GUICtrlCreateInput("30", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTxtBarbarians & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentBarbarians = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
		$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnArcher, $x - 10, $y - 5, 24, 24)
		$lblArchers = GUICtrlCreateLabel($sTxtArchers & ":", $x + 20, $y, -1, -1)
		$txtNumArch = GUICtrlCreateInput("60", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTxtArchers & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentArchers = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
		$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnGoblin, $x - 10, $y - 5, 24, 24)
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
		GUICtrlCreateIcon ($pIconLib, $eIcnGiant, $x - 10, $y - 5, 24, 24)
		$lblGiants = GUICtrlCreateLabel($sTxtGiants & ":", $x + 20, $y, -1, -1)
		$txtNumGiant = GUICtrlCreateInput("4", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtGiants & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesGiants = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnWallBreaker, $x - 10, $y - 5, 24, 24)
		$lblWallBreakers = GUICtrlCreateLabel($sTxtWallBreakersShort & ":", $x + 20, $y, -1, -1)
		$txtNumWall = GUICtrlCreateInput("4", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtWallBreakers & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesWallBreakers = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnBalloon, $x - 10, $y - 5, 24, 24)
		$lblBalloons = GUICtrlCreateLabel($sTxtBalloons & ":", $x + 20, $y, -1, -1)
		$txtNumBall = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtBalloons & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesBalloons = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnWizard, $x - 10, $y - 5, 24, 24)
		$lblWizards = GUICtrlCreateLabel($sTxtWizards & ":", $x + 20, $y, -1, -1)
		$txtNumWiza = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtWizards & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesWizards = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnHealer, $x - 10, $y - 5, 24, 24)
		$lblHealers = GUICtrlCreateLabel($sTxtHealers & ":", $x + 20, $y, -1, -1)
		$txtNumHeal = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHealers & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesHealers = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnDragon, $x - 10, $y - 5, 24, 24)
		$lblDragons = GUICtrlCreateLabel($sTxtDragons & ":", $x + 20, $y, -1, -1)
		$txtNumDrag = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtDragons & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesDragons = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnPekka, $x - 10, $y - 5, 24, 24)
		$lblPekka = GUICtrlCreateLabel($sTxtPekkasLong & ":", $x + 20, $y, -1, -1)
		$txtNumPekk = GUICtrlCreateInput("0", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtPekkas & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesPekka = GUICtrlCreateLabel("x", $x + 112, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x += 150
	$y = 330
	$grpDarkTroops = GUICtrlCreateGroup(GetTranslated(1,47, "Add. Dark Troops"), $x - 20, $y - 20, 150, 195)
		GUICtrlCreateIcon ($pIconLib, $eIcnMinion, $x - 10, $y - 5, 24, 24)
		$lblMinion = GUICtrlCreateLabel($sTxtMinions & ":", $x + 18, $y, -1, -1)
		$txtNumMini = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtMinions & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesMinions = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnHogRider, $x - 10, $y - 5, 24, 24)
		$lblHogRiders = GUICtrlCreateLabel($sTxtHogRiders & ":", $x + 18, $y, -1, -1)
		$txtNumHogs = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHogRiders & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesHogRiders = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnValkyrie, $x - 10, $y - 5, 24, 24)
		$lblValkyries = GUICtrlCreateLabel($sTxtValkyries & ":", $x + 18, $y, -1, -1)
		$txtNumValk = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtValkyries & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesValkyries = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnGolem, $x - 10, $y - 5, 24, 24)
		$lblGolems = GUICtrlCreateLabel($sTxtGolems & ":", $x + 18, $y, -1, -1)
		$txtNumGole = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtGolems & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesGolems = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnWitch, $x - 10, $y - 5, 24, 24)
		$lblWitches = GUICtrlCreateLabel($sTxtWitches & ":", $x + 18, $y, -1, -1)
		$txtNumWitc = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtWitches & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesWitches = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
		$y +=25
		GUICtrlCreateIcon ($pIconLib, $eIcnLavaHound, $x - 10, $y - 5, 24, 24)
		$lblLavaHounds = GUICtrlCreateLabel($sTxtLavaHounds & ":", $x + 18, $y, -1, -1)
		$txtNumLava = GUICtrlCreateInput("0", $x + 85, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtLavaHounds & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesLavaHounds = GUICtrlCreateLabel("x", $x + 117, $y, -1, -1)
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