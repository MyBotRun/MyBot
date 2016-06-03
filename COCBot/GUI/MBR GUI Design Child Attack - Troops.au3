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

$hGUI_ARMY = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_ATTACK)
;GUISetBkColor($COLOR_WHITE, $hGUI_ARMY)

;~ -------------------------------------------------------------
;~ Language Variables used a lot
;~ -------------------------------------------------------------

$textBoostLeft = GetTranslated(623,1, "Boosts left")

$sTxtSetPerc = GetTranslated(621,26, "Set the % of")
$sTxtSetPerc2 = GetTranslated(621,27, " to make.")
$sTxtSetPerc3 = GetTranslated(621,28, "Enter the No. of")
$sTxtSetSpell = GetTranslated(621,29, "Spells to make.")

$sTxtNone = GetTranslated(603,0, "None")


;~ -------------------------------------------------------------
;~ Troops Tab Main controls always visible
;~ -------------------------------------------------------------

;Local $x = 20, $y = 20
;	$grpRaidComp = GUICtrlCreateGroup(GetTranslated(621,19, "Army Strength"), $x - 20, $y - 20, 155, 55)
;		$y += 10
;		GUICtrlCreateIcon ($pIconLib, $eIcnBldgTarget, $x - 10, $y - 8, 24, 24)
;		$lblFullTroop = GUICtrlCreateLabel(GetTranslated(621,20, "'Full' Camps="),$x + 20, $y , -1, 17)
;		$txtFullTroop = GUICtrlCreateInput("100",  $x + 85, $y - 3, 30, 22, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
;			GUICtrlSetTip(-1, GetTranslated(621,21, "Army camps are 'Full' when reaching this %, then start attack."))
;		$lblFullTroop = GUICtrlCreateLabel("%",$x + 117, $y, -1, 17)
;			GUICtrlSetLimit(-1, 3)
;	GUICtrlCreateGroup("", -99, -99, 1, 1)


;~ -------------------------------------------------------------
;~ Troops Tab
;~ -------------------------------------------------------------

$hGUI_ARMY_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
$hGUI_ARMY_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,20,"Troops"))
Local $xStart = 0, $yStart = 0

Local $x = $xStart +  25, $y = $yStart +  80 + 25 - 60
	$grpTroopComp = GUICtrlCreateGroup(GetTranslated(621,1, "Elixir Troops"), $x - 20, $y - 20, 142, 50)
		$x -= 5
		$cmbTroopComp = GUICtrlCreateCombo("", $x - 10, $y, 130, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(621,2, "Set the type of Army composition.") & @CRLF & GetTranslated(621,3, "'Use Barrack Mode' or 'Custom Army' for manual compositions."))
			GUICtrlSetOnEvent(-1, "cmbTroopComp")
			GUICtrlSetData(-1, GetTranslated(621,4, "Preset: Archers") &"|" & GetTranslated(621,5, "Preset: Barbarians") & "|" & GetTranslated(621,6, "Preset: Goblins") & "|" & GetTranslated(621,7, "Preset: B.Arch") & "|" &  GetTranslated(621,8, "Preset: B.A.G.G.") & "|" & GetTranslated(621,9, "Preset: B.A.Giant") & "|" & GetTranslated(621,10, "Preset: B.A.Goblin")  &"|" & GetTranslated(621,11, "Preset: B.A.G.G.Wall") & "|" & GetTranslated(621,12, "Use Barrack Mode") & "|" & GetTranslated(621,13, "Custom Army"), GetTranslated(621,13, -1))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = $xStart +  25, $y = $yStart +  75 + 25
	$grpTroops = GUICtrlCreateGroup(GetTranslated(621,14, "Troops"), $x - 20, $y - 20, 142, 115)
		$x -= 5
		$icnBarb = GUICtrlCreateIcon ($pIconLib, $eIcnBarbarian, $x - 10, $y - 5, 24, 24)
		$lblBarbarians = GUICtrlCreateLabel($sTxtBarbarians, $x + 20, $y, -1, -1)
		$txtNumBarb = GUICtrlCreateInput("30", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTxtBarbarians & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentBarbarians = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
		$y += 25
		$icnArch = GUICtrlCreateIcon ($pIconLib, $eIcnArcher, $x - 10, $y - 5, 24, 24)
		$lblArchers = GUICtrlCreateLabel($sTxtArchers, $x + 20, $y, -1, -1)
		$txtNumArch = GUICtrlCreateInput("60", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTxtArchers & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentArchers = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
		$y += 25
		$icnGobl = GUICtrlCreateIcon ($pIconLib, $eIcnGoblin, $x - 10, $y - 5, 24, 24)
		$lblGoblins = GUICtrlCreateLabel($sTxtGoblins, $x + 20, $y, -1, -1)
		$txtNumGobl = GUICtrlCreateInput("10", $x + 80, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTxtGoblins & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "lblTotalCount")
		$lblPercentGoblins = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
		$y += 22
		$lblTotalTroops = GUICtrlCreateLabel(GetTranslated(621,15, "Total"), $x + 45, $y, -1, -1, $SS_RIGHT)
		$lblTotalCount = GUICtrlCreateLabel("100", $x + 80, $y, 30, 15, $SS_CENTER)
			GUICtrlSetTip(-1, GetTranslated(621,16, "The total % of Troops should equal 100%."))
			GUICtrlSetBkColor (-1, $COLOR_MONEYGREEN) ;lime, moneygreen
		$lblPercentTotal = GUICtrlCreateLabel("%", $x + 112, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = $xStart + 20, $y = $yStart +  75 + 25
	$grpBarrackMode = GUICtrlCreateGroup(GetTranslated(621,17, "Barrack Mode"), $x - 15, $y -20, 142, 117 )
		GUICtrlSetState(-1, $GUI_HIDE)
		$lblBarrack1 = GUICtrlCreateLabel("1:", $x - 5, $y + 5, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$cmbBarrack1 = GUICtrlCreateCombo("", $x + 10, $y, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(621,18, "Set the Troops to make in Barrack")
			GUICtrlSetTip(-1, $txtTip & " 1.")
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers &"|" & $sTxtDragons & "|" & $sTxtPekkas, $sTxtBarbarians)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
		$y += 2
		$lblBarrack2 = GUICtrlCreateLabel("2:", $x - 5, $y + 26, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$cmbBarrack2 = GUICtrlCreateCombo("", $x + 10, $y + 21, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip & " 2.")
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers &"|" & $sTxtDragons & "|" & $sTxtPekkas, $sTxtArchers)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
		$y += 2
		$lblBarrack3 = GUICtrlCreateLabel("3:", $x - 5, $y + 47, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$cmbBarrack3 = GUICtrlCreateCombo("", $x + 10, $y + 42, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip & " 3.")
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers &"|" & $sTxtDragons & "|" & $sTxtPekkas, $sTxtArchers)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
		$y += 2
		$lblBarrack4 = GUICtrlCreateLabel("4:", $x - 5, $y + 68, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$cmbBarrack4 = GUICtrlCreateCombo("", $x + 10, $y + 63, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip & " 4.")
			GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers &"|" & $sTxtDragons & "|" & $sTxtPekkas, $sTxtGoblins)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = $xStart +  160 + 5, $y = $yStart +  45
	$grpRaidComp = GUICtrlCreateGroup(GetTranslated(621,19, "Army Strength"), $x - 15, $y - 20, 139, 50)
		$y += 5
		GUICtrlCreateIcon ($pIconLib, $eIcnBldgTarget, $x - 10, $y - 8, 24, 24)
		$lblFullTroop = GUICtrlCreateLabel(GetTranslated(621,20, "'Full' Camps"),$x + 16, $y, 55, 17)
		$lblFullTroop2 = GUICtrlCreateLabel(ChrW(8805),$x + 75, $y, -1, 17)
		$txtFullTroop = GUICtrlCreateInput("100",  $x + 83, $y - 3, 30, 22, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(621,21, "Army camps are 'Full' when reaching this %, then start attack."))
			GUICtrlSetLimit(-1, 3)
		$lblFullTroop3 = GUICtrlCreateLabel("%",$x + 114, $y, -1, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = $xStart +  160 + 5, $y = $yStart +  75 + 25
	$grpOtherTroops = GUICtrlCreateGroup(GetTranslated(621,22, "Add. Troops"), $x - 15, $y - 20, 139, 200)
		$icnGiant = GUICtrlCreateIcon ($pIconLib, $eIcnGiant, $x - 10, $y - 5, 24, 24)
		$lblGiants = GUICtrlCreateLabel($sTxtGiants, $x + 16, $y, -1, -1)
		$txtNumGiant = GUICtrlCreateInput("4", $x + 83, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtGiants & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesGiants = GUICtrlCreateLabel("x", $x + 115, $y, -1, -1)
		$y +=25
		$icnWall = GUICtrlCreateIcon ($pIconLib, $eIcnWallBreaker, $x - 10, $y - 5, 24, 24)
		$lblWallBreakers = GUICtrlCreateLabel($sTxtWallBreakers, $x + 16, $y, -1, -1)
		$txtNumWall = GUICtrlCreateInput("4", $x + 83, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtWallBreakers & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesWallBreakers = GUICtrlCreateLabel("x", $x + 115, $y, -1, -1)
		$y +=25
		$icnBall = GUICtrlCreateIcon ($pIconLib, $eIcnBalloon, $x - 10, $y - 5, 24, 24)
		$lblBalloons = GUICtrlCreateLabel($sTxtBalloons, $x + 16, $y, -1, -1)
		$txtNumBall = GUICtrlCreateInput("0", $x + 83, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtBalloons & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesBalloons = GUICtrlCreateLabel("x", $x + 115, $y, -1, -1)
		$y +=25
		$icnWiza = GUICtrlCreateIcon ($pIconLib, $eIcnWizard, $x - 10, $y - 5, 24, 24)
		$lblWizards = GUICtrlCreateLabel($sTxtWizards, $x + 16, $y, -1, -1)
		$txtNumWiza = GUICtrlCreateInput("0", $x + 83, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtWizards & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesWizards = GUICtrlCreateLabel("x", $x + 115, $y, -1, -1)
		$y +=25
		$icnHeal = GUICtrlCreateIcon ($pIconLib, $eIcnHealer, $x - 10, $y - 5, 24, 24)
		$lblHealers = GUICtrlCreateLabel($sTxtHealers, $x + 16, $y, -1, -1)
		$txtNumHeal = GUICtrlCreateInput("0", $x + 83, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHealers & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesHealers = GUICtrlCreateLabel("x", $x + 115, $y, -1, -1)
		$y +=25
		$icnDrag = GUICtrlCreateIcon ($pIconLib, $eIcnDragon, $x - 10, $y - 5, 24, 24)
		$lblDragons = GUICtrlCreateLabel($sTxtDragons, $x + 16, $y, -1, -1)
		$txtNumDrag = GUICtrlCreateInput("0", $x + 83, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtDragons & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesDragons = GUICtrlCreateLabel("x", $x + 115, $y, -1, -1)
		$y +=25
		$icnPekk = GUICtrlCreateIcon ($pIconLib, $eIcnPekka, $x - 10, $y - 5, 24, 24)
		$lblPekka = GUICtrlCreateLabel($sTxtPekkas, $x + 16, $y, -1, -1)
		$txtNumPekk = GUICtrlCreateInput("0", $x + 83, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtPekkas & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesPekka = GUICtrlCreateLabel("x", $x + 115, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = $xStart +  160 + 148, $y = $yStart +  80 + 25 - 60
	$grpDarkTroopComp = GUICtrlCreateGroup(GetTranslated(621,23, "Dark Elixir Troops"), $x - 15, $y - 20, 140, 50)
		$cmbDarkTroopComp = GUICtrlCreateCombo("", $x - 10, $y, 125, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(621,2, -1) & @CRLF & GetTranslated(621,3, -1))
			GUICtrlSetOnEvent(-1, "cmbDarkTroopComp")
			GUICtrlSetData(-1,  GetTranslated(621,12, -1) & "|" &GetTranslated(621,13, -1) & "|" & $sTxtNone, GetTranslated(621,13, -1))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y = $yStart +  75 + 25
	$grpDarkTroops = GUICtrlCreateGroup(GetTranslated(621,24, "Add. Dark Troops"), $x - 15, $y - 20, 140, 200)
		$icnMini = GUICtrlCreateIcon ($pIconLib, $eIcnMinion, $x - 10, $y - 5, 24, 24)
		$lblMinion = GUICtrlCreateLabel($sTxtMinions, $x + 16, $y, -1, -1)
		$txtNumMini = GUICtrlCreateInput("0", $x + 84, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtMinions & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 3)
		$lblTimesMinions = GUICtrlCreateLabel("x", $x + 116, $y, -1, -1)
		$y +=25
		$icnHogs = GUICtrlCreateIcon ($pIconLib, $eIcnHogRider, $x - 10, $y - 5, 24, 24)
		$lblHogRiders = GUICtrlCreateLabel($sTxtHogRiders, $x + 16, $y, -1, -1)
		$txtNumHogs = GUICtrlCreateInput("0", $x + 84, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHogRiders & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesHogRiders = GUICtrlCreateLabel("x", $x + 116, $y, -1, -1)
		$y +=25
		$icnValk = GUICtrlCreateIcon ($pIconLib, $eIcnValkyrie, $x - 10, $y - 5, 24, 24)
		$lblValkyries = GUICtrlCreateLabel($sTxtValkyries, $x + 16, $y, -1, -1)
		$txtNumValk = GUICtrlCreateInput("0", $x + 84, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtValkyries & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesValkyries = GUICtrlCreateLabel("x", $x + 116, $y, -1, -1)
		$y +=25
		$icnGole = GUICtrlCreateIcon ($pIconLib, $eIcnGolem, $x - 10, $y - 5, 24, 24)
		$lblGolems = GUICtrlCreateLabel($sTxtGolems, $x + 16, $y, -1, -1)
		$txtNumGole = GUICtrlCreateInput("0", $x + 84, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtGolems & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesGolems = GUICtrlCreateLabel("x", $x + 116, $y, -1, -1)
		$y +=25
		$icnWitc = GUICtrlCreateIcon ($pIconLib, $eIcnWitch, $x - 10, $y - 5, 24, 24)
		$lblWitches = GUICtrlCreateLabel($sTxtWitches, $x + 16, $y, -1, -1)
		$txtNumWitc = GUICtrlCreateInput("0", $x + 84, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtWitches & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesWitches = GUICtrlCreateLabel("x", $x + 116, $y, -1, -1)
		$y +=25
		$icnLava = GUICtrlCreateIcon ($pIconLib, $eIcnLavaHound, $x - 10, $y - 5, 24, 24)
		$lblLavaHounds = GUICtrlCreateLabel($sTxtLavaHounds, $x + 16, $y, -1, -1)
		$txtNumLava = GUICtrlCreateInput("0", $x + 84, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtLavaHounds & " " & $sTxtSetPerc2)
			GUICtrlSetLimit(-1, 2)
		$lblTimesLavaHounds = GUICtrlCreateLabel("x", $x + 116, $y, -1, -1)
;		$y +=25
;		$icnBowl = GUICtrlCreateIcon ($pIconLib, $eIcnBowler, $x - 10, $y - 5, 24, 24)
;		$lblBowlers = GUICtrlCreateLabel($sTxtBowlers, $x + 16, $y, -1, -1)
;		$txtNumBowl = GUICtrlCreateInput("0", $x + 84, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
;			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtBowlers & " " & $sTxtSetPerc2)
;			GUICtrlSetLimit(-1, 2)
;		$lblTimesBowlers = GUICtrlCreateLabel("x", $x + 116, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = $yStart +  75 + 25
	$grpDarkBarrackMode = GUICtrlCreateGroup(GetTranslated(621,25, "Dark Barracks Troops"), $x - 15, $y -20, 140, 76 )
		GUICtrlSetState(-1, $GUI_HIDE)
		$lblDarkBarrack1 = GUICtrlCreateLabel("1:", $x - 5, $y + 5, -1, -1)
		GUICtrlSetState(-1, $GUI_HIDE)
		$cmbDarkBarrack1 = GUICtrlCreateCombo("", $x + 10, $y, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(621,18, -1)
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
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")

$hGUI_ARMY_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,21,"Spells"))

Local $x = $xStart + 25, $y = $yStart +  80 + 25 - 60

	$grpSpells = GUICtrlCreateGroup(GetTranslated(622,1, "Spells Composition"), $x - 20, $y - 20, 430, 335)
		$lblTotalSpell = GUICtrlCreateLabel(GetTranslated(622,2, "Spells Capacity"), $x - 20 , $y + 4, -1, -1, $SS_RIGHT)
		$txtTotalCountSpell = GUICtrlCreateCombo("", $x + 105, $y , 35, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(622,3, "Enter the No. of Spells Capacity. Set to ZERO if you don't want any Spells"))
			GUICtrlSetBkColor (-1, $COLOR_MONEYGREEN) ;lime, moneygreen
			GUICtrlSetData(-1, "0|2|4|6|7|8|9|10|11", "0")
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$y += 55
		$lblLightningIcon = GUICtrlCreateIcon ($pIconLib, $eIcnLightSpell, $x - 10, $y - 5, 24, 24)
		$lblLightningSpell = GUICtrlCreateLabel($sTxtLiSpell, $x + 18, $y, -1, -1)
		$txtNumLightningSpell = GUICtrlCreateInput("0", $x + 105, $y - 3, 30, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtLiSpell & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesLightS = GUICtrlCreateLabel("x", $x + 137, $y, -1, -1)
		$y +=25
		$lblHealIcon=GUICtrlCreateIcon ($pIconLib, $eIcnHealSpell, $x - 10, $y - 5, 24, 24)
		$lblHealSpell = GUICtrlCreateLabel($sTxtHeSpell, $x + 18, $y, -1, -1)
		$txtNumHealSpell = GUICtrlCreateInput("0", $x + 105, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHeSpell & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesHealS = GUICtrlCreateLabel("x", $x + 137, $y, -1, -1)
		$y +=25
		$lblRageIcon=GUICtrlCreateIcon ($pIconLib, $eIcnRageSpell, $x - 10, $y - 5, 24, 24)
		$lblRageSpell = GUICtrlCreateLabel($sTxtRaSpell, $x + 18, $y, -1, -1)
		$txtNumRageSpell = GUICtrlCreateInput("0", $x + 105, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtRaSpell & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesRageS = GUICtrlCreateLabel("x", $x + 137, $y, -1, -1)
		$y +=25
		$lblJumpSpellIcon=GUICtrlCreateIcon ($pIconLib, $eIcnJumpSpell, $x - 10, $y - 5, 24, 24)
		$lblJumpSpell = GUICtrlCreateLabel($sTxtJuSPell, $x + 18, $y, -1, -1)
		$txtNumJumpSpell = GUICtrlCreateInput("0", $x + 105, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtJuSPell & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesJumpS = GUICtrlCreateLabel("x", $x + 137, $y, -1, -1)
		$y +=25
		$lblFreezeIcon=GUICtrlCreateIcon ($pIconLib, $eIcnFreezeSpell, $x - 10, $y - 5, 24, 24)
		$lblFreezeSpell = GUICtrlCreateLabel($sTxtFrSpell, $x + 18, $y, -1, -1)
		$txtNumFreezeSpell = GUICtrlCreateInput("0", $x + 105, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtFrSpell & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblFreezeS = GUICtrlCreateLabel("x", $x + 137, $y, -1, -1)
		$y +=25
		$lblPoisonIcon = GUICtrlCreateIcon ($pIconLib, $eIcnPoisonSpell, $x - 10, $y - 5, 24, 24)
		$lblPoisonSpell = GUICtrlCreateLabel($sTxtPoSpell, $x + 18, $y, -1, -1)
		$txtNumPoisonSpell = GUICtrlCreateInput("0", $x + 105, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtPoSpell & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesPoisonS = GUICtrlCreateLabel("x", $x + 137, $y, -1, -1)
		$y +=25
		$lblEarthquakeIcon = GUICtrlCreateIcon ($pIconLib, $eIcnEarthquakeSpell, $x - 10, $y - 5, 24, 24)
		$lblEarthquakeSpell = GUICtrlCreateLabel($sTxtEaSpell, $x + 18, $y, -1, -1)
		$txtNumEarthSpell = GUICtrlCreateInput("0", $x + 105, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtEaSpell & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesEarthquakeS = GUICtrlCreateLabel("x", $x + 137, $y, -1, -1)
		$y +=25
		$lblHasteIcon = GUICtrlCreateIcon ($pIconLib, $eIcnHasteSpell, $x - 10, $y - 5, 24, 24)
		$lblHasteSpell = GUICtrlCreateLabel($sTxtHaSpell, $x + 18, $y, -1, -1)
		$txtNumHasteSpell = GUICtrlCreateInput("0", $x + 105, $y - 3, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHaSpell & " " & $sTxtSetSpell)
			GUICtrlSetLimit(-1, 2)
			;GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "lblTotalCountSpell")
		$lblTimesHasteS = GUICtrlCreateLabel("x", $x + 137, $y, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")

$hGUI_ARMY_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600,22,"Boost"))

Global $chkBoostBarracksHours
Global $chkBoostBarracksHours0, $chkBoostBarracksHours1, $chkBoostBarracksHours2, $chkBoostBarracksHours3, $chkBoostBarracksHours4, $chkBoostBarracksHours5
Global $chkBoostBarracksHours6, $chkBoostBarracksHours7, $chkBoostBarracksHours8, $chkBoostBarracksHours9, $chkBoostBarracksHours10, $chkBoostBarracksHours11
Global $chkBoostBarracksHours12, $chkBoostBarracksHours13, $chkBoostBarracksHours14, $chkBoostBarracksHours15, $chkBoostBarracksHours16, $chkBoostBarracksHours17
Global $chkBoostBarracksHours18, $chkBoostBarracksHours19, $chkBoostBarracksHours20, $chkBoostBarracksHours21, $chkBoostBarracksHours22, $chkBoostBarracksHours23
Global $lbBoostBarracksHours1, $lbBoostBarracksHours2, $lbBoostBarracksHours3, $lbBoostBarracksHours4, $lbBoostBarracksHours5, $lbBoostBarracksHours6
Global $lbBoostBarracksHours7, $lbBoostBarracksHours8, $lbBoostBarracksHours9, $lbBoostBarracksHours10, $lbBoostBarracksHours11, $lbBoostBarracksHours12
Global $lbBoostBarracksHoursED, $lbBoostBarracksHoursPM, $lbBoostBarracksHoursAM, $chkBoostBarracksHoursE1, $chkBoostBarracksHoursE2

Global $tabBoost, $tabBoostOptions, $grpBoosterOptions
Global $lblQuantBoostBarracks, $cmbQuantBoostBarracks, $cmbBoostBarracks
Global $lblBoostSpellFactory, $cmbBoostSpellFactory, $lblBoostDarkSpellFactory, $cmbBoostDarkSpellFactory
Global $lblBoostBarbarianKing, $cmbBoostBarbarianKing, $lblBoostArcherQueen, $cmbBoostArcherQueen
Global $lblBoostWarden, $cmbBoostWarden

Local $x = $xStart + 25, $y = $yStart +  45
	$grpBoosterBarracks = GUICtrlCreateGroup(GetTranslated(623,2, "Boost Barracks"), $x - 20, $y - 20, 430, 70)
		GUICtrlCreateIcon ($pIconLib, $eIcnBarrackBoost, $x - 10, $y - 2, 24, 24)
		$lblQuantBoostBarracks = GUICtrlCreateLabel(GetTranslated(623,3, "Num. Of Barracks to Boost"), $x + 20, $y + 4 , -1, -1)
		$txtTip = GetTranslated(623,4, "How many Barracks to boost with GEMS! Use with caution!")
			GUICtrlSetTip(-1, $txtTip)
		$cmbQuantBoostBarracks = GUICtrlCreateCombo("", $x + 200, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4", "0")
			GUICtrlSetTip(-1, $txtTip)
		$lblBoostBarracks = GUICtrlCreateLabel(GetTranslated(623,5,"Barracks") & " "&$textBoostLeft, $x + 20, $y + 27, -1, -1)
		$txtTip = GetTranslated(623,6, "Use this to boost your Barracks with GEMS! Use with caution!")
			GUICtrlSetTip(-1, $txtTip)
		$cmbBoostBarracks = GUICtrlCreateCombo("", $x + 200, $y+ 23 , 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
$y += 75
	$grpBoosterSpellFactories = GUICtrlCreateGroup(GetTranslated(623,7,"Boost Spell Factories"), $x - 20, $y - 20, 430, 70)
		GUICtrlCreateIcon ($pIconLib, $eIcnSpellFactoryBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostSpellFactory = GUICtrlCreateLabel(GetTranslated(623,8,"Spell Factory") & " "&$textBoostLeft, $x + 20, $y + 4, -1, -1)
		$txtTip = GetTranslated(623,9, "Use this to boost your Spell Factory with GEMS! Use with caution!")
			GUICtrlSetTip(-1, $txtTip)
		$cmbBoostSpellFactory = GUICtrlCreateCombo("", $x + 200, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
			GUICtrlSetTip(-1, $txtTip)
 	$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnDarkSpellBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostDarkSpellFactory = GUICtrlCreateLabel(GetTranslated(623,10,"Dark Spell Factory") & " "&$textBoostLeft, $x + 20, $y + 4, -1, -1)
		$txtTip = GetTranslated(623,11, "Use this to boost your Dark Spell Factory with GEMS! Use with caution!")
			GUICtrlSetTip(-1, $txtTip)
		$cmbBoostDarkSpellFactory = GUICtrlCreateCombo("", $x + 200, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
$y += 50
	$grpBoosterHeroes = GUICtrlCreateGroup(GetTranslated(623,12,"Boost Heroes"), $x - 20, $y - 20, 430, 95)
		GUICtrlCreateIcon ($pIconLib, $eIcnKingBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostBarbarianKing = GUICtrlCreateLabel(GetTranslated(623,13,"Barbarian King" ) & " "&$textBoostLeft, $x + 20, $y + 4, -1, -1)
 		$txtTip = GetTranslated(623,14, "Use this to boost your Barbarian King with GEMS! Use with caution!")
			GUICtrlSetTip(-1, $txtTip)
		$cmbBoostBarbarianKing = GUICtrlCreateCombo("", $x + 200, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeKing")
 	$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnQueenBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostArcherQueen = GUICtrlCreateLabel(GetTranslated(623,15,"Archer Queen") & " " &$textBoostLeft, $x + 20, $y + 4, -1, -1)
 		$txtTip = GetTranslated(623,16, "Use this to boost your Archer Queen with GEMS! Use with caution!")
 		GUICtrlSetTip(-1, $txtTip)
		$cmbBoostArcherQueen = GUICtrlCreateCombo("", $x + 200, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeQueen")
 	$y += 25
		GUICtrlCreateIcon ($pIconLib, $eIcnWardenBoost, $x - 10, $y - 2, 24, 24)
		$lblBoostWarden = GUICtrlCreateLabel(GetTranslated(623,17,"Grand Warden") & " "&$textBoostLeft, $x + 20, $y + 4, -1, -1)
 		$txtTip = GetTranslated(623,18, "Use this to boost your Grand Warden with GEMS! Use with caution!")
 		GUICtrlSetTip(-1, $txtTip)
		$cmbBoostWarden = GUICtrlCreateCombo("", $x + 200, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeWarden")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
$y += 60
	$grpBoosterSchedule = GUICtrlCreateGroup(GetTranslated(623,19,"Boost Schedule"), $x - 20, $y - 20, 430, 70)

	$lbBoostBarracksHours1 = GUICtrlCreateLabel(" 0", $x + 30, $y)
	$lbBoostBarracksHours2 = GUICtrlCreateLabel(" 1", $x + 45, $y)
	$lbBoostBarracksHours3 = GUICtrlCreateLabel(" 2", $x + 60, $y)
	$lbBoostBarracksHours4 = GUICtrlCreateLabel(" 3", $x + 75, $y)
	$lbBoostBarracksHours5 = GUICtrlCreateLabel(" 4", $x + 90, $y)
	$lbBoostBarracksHours6 = GUICtrlCreateLabel(" 5", $x + 105, $y)
	$lbBoostBarracksHours7 = GUICtrlCreateLabel(" 6", $x + 120, $y)
	$lbBoostBarracksHours8 = GUICtrlCreateLabel(" 7", $x + 135, $y)
	$lbBoostBarracksHours9 = GUICtrlCreateLabel(" 8", $x + 150, $y)
	$lbBoostBarracksHours10 = GUICtrlCreateLabel(" 9", $x + 165, $y)
	$lbBoostBarracksHours11 = GUICtrlCreateLabel("10", $x + 180, $y)
	$lbBoostBarracksHours12 = GUICtrlCreateLabel("11", $x + 195, $y)
	$lbBoostBarracksHoursED = GUICtrlCreateLabel("X", $x + 213, $y+2, 11, 11)
	$y += 15
	$chkBoostBarracksHours0 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	$chkBoostBarracksHours1 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	$chkBoostBarracksHours2 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	$chkBoostBarracksHours3 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	$chkBoostBarracksHours4 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	$chkBoostBarracksHours5 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	$chkBoostBarracksHours6 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	$chkBoostBarracksHours7 = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	$chkBoostBarracksHours8 = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	$chkBoostBarracksHours9 = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	$chkBoostBarracksHours10 = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	$chkBoostBarracksHours11 = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	$chkBoostBarracksHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
	GUICtrlSetImage(-1, $pIconLib, $eIcnGoldStar, 0)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	$txtTip = GetTranslated(603,2, "This button will clear or set the entire row of boxes")
	GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkBoostBarracksHoursE1")
	$lbBoostBarracksHoursAM = GUICtrlCreateLabel(GetTranslated(603,3, "AM"), $x + 5, $y)
	$y += 15
	$chkBoostBarracksHours12 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkBoostBarracksHours13 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkBoostBarracksHours14 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkBoostBarracksHours15 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkBoostBarracksHours16 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkBoostBarracksHours17 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkBoostBarracksHours18 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkBoostBarracksHours19 = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkBoostBarracksHours20 = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkBoostBarracksHours21 = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkBoostBarracksHours22 = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkBoostBarracksHours23 = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkBoostBarracksHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
	GUICtrlSetImage(-1, $pIconLib, $eIcnGoldStar, 0)
	GUICtrlSetState(-1, $GUI_UNCHECKED )
	$txtTip = GetTranslated(603,2, -1)
	GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkBoostBarracksHoursE2")
	$lbBoostBarracksHoursPM = GUICtrlCreateLabel(GetTranslated(603,4, "PM"), $x + 5, $y)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")