; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), Boju (11-2016)
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

$textBoostLeft = GetTranslated(623, 1, "Boosts left")

$sTxtSetPerc = GetTranslated(621, 26, "Enter the No. of")
$sTxtSetPerc2 = GetTranslated(621, 27, " to make.")
$sTxtSetPerc3 = GetTranslated(621, 28, "Enter the No. of")
$sTxtSetSpell = GetTranslated(621, 29, "Spells to make.")

$sTxtNone = GetTranslated(603, 0, "None")


;~ -------------------------------------------------------------
;~ Troops Tab Main controls always visible
;~ -------------------------------------------------------------


;~ -------------------------------------------------------------
;~ Troops Tab
;~ -------------------------------------------------------------

$hGUI_ARMY_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))

$hGUI_ARMY_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600, 52, "Troops/Spells"))
Local $xStart = 0, $yStart = 0
Local $x = $xStart
Local $y = $yStart + 8
	$hChk_UseQTrain = GUICtrlCreateCheckbox(GetTranslated(621, 34, "Use Quick Train"), $x + 15, $y + 19, -1, 15)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "chkUseQTrain")
	$hRadio_Army1 = GUICtrlCreateRadio(GetTranslated(621, 37, "Army 1"), $x + 120, $y + 20, 50, 15)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$hRadio_Army2 = GUICtrlCreateRadio(GetTranslated(621, 38, "Army 2"), $x + 180, $y + 20, 50, 15)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$hRadio_Army3 = GUICtrlCreateRadio(GetTranslated(621, 39, "Army 3"), $x + 240, $y + 20, 50, 15)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$LblRemovecamp = GUICtrlCreateLabel(GetTranslated(621, 41, "Remove Army"), $x + 335, $y + 20, -1, 15, $SS_LEFT)
	$icnRemovecamp = GUICtrlCreateIcon($pIconLib, $eIcnResetButton, $x + 405, $y + 17, 24, 24)
	GUICtrlSetOnEvent(-1, "Removecamp")

Local $x = 10
Local $y = 45
$grpTrainTroopsGUI = GUICtrlCreateGroup(GetTranslated(1000, 1, "Train Troops"), $x, $y, 418, 195)

Local $x = 30
$y += 20
	; Barbarians
	$icnBarb = GUICtrlCreateIcon($pIconLib, $eIcnBarbarian, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, "Level") & " " & $sTxtBarbarians & ":" & @CRLF & GetTranslated(621,40, "Mouse Left Click to Up level" & @CRLF & "Shift + Mouse Left Click to Down level"))
	GUICtrlSetOnEvent(-1, "LevBarb")
	$txtLevBarb = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumBarb = GUICtrlCreateInput("58", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtBarbarians & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "lblTotalCountBarb")

$x += 38
	; Giants
	$icnGiant = GUICtrlCreateIcon($pIconLib, $eIcnGiant, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtGiants & ":" & @CRLF & GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevGiant")
	$txtLevGiant = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumGiant = GUICtrlCreateInput("4", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtGiants & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountGiant")

$x += 38
	; WallBreakers
	$icnWall = GUICtrlCreateIcon($pIconLib, $eIcnWallBreaker, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtWallBreakers & ":" & @CRLF & GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevWall")
	$txtLevWall = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumWall = GUICtrlCreateInput("4", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtWallBreakers & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "lblTotalCountWall")

$x += 38
	; Wizards
	$icnWiza = GUICtrlCreateIcon($pIconLib, $eIcnWizard, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtWizards & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevWiza")
	$txtLevWiza = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumWiza = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtWizards & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountWiza")

$x += 38
	; Dragon
	$icnDrag = GUICtrlCreateIcon($pIconLib, $eIcnDragon, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtDragons & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevDrag")
	$txtLevDrag = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumDrag = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtDragons & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountDrag")

$x += 38
	; BDragon
	$icnBabyD = GUICtrlCreateIcon($pIconLib, $eIcnBabyDragon, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtBabyDragons & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevBabyD")
	$txtLevBabyD = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumBabyD = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtBabyDragons & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountBabyD")

$x += 45
	; Minioons
	$icnMini = GUICtrlCreateIcon($pIconLib, $eIcnMinion, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtMinions & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevMini")
	$txtLevMini = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumMini = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtMinions & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "lblTotalCountMini")

$x += 38
	; Valkyries
	$icnValk = GUICtrlCreateIcon($pIconLib, $eIcnValkyrie, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtValkyries & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevValk")
	$txtLevValk = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumValk = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtValkyries & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountValk")

$x += 38
	; Witches
	$icnWitc = GUICtrlCreateIcon($pIconLib, $eIcnWitch, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtWitches & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevWitc")
	$txtLevWitc = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumWitc = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtWitches & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountWitc")

$x += 38
	; Bowlers
	$icnBowl = GUICtrlCreateIcon($pIconLib, $eIcnBowler, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtBowlers & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevBowl")
	$txtLevBowl = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumBowl = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtBowlers & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountBowl")

; Next Row
$x = 30
$y += 60

	; Archers
	$icnArch = GUICtrlCreateIcon($pIconLib, $eIcnArcher, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtArchers & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevArch")
	$txtLevArch = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumArch = GUICtrlCreateInput("115", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtArchers & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "lblTotalCountArch")

$x += 38
	; Goblins
	$icnGobl = GUICtrlCreateIcon($pIconLib, $eIcnGoblin, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtGoblins & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevGobl")
	$txtLevGobl = GUICtrlCreateLabel("1", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumGobl = GUICtrlCreateInput("19", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc & " " & $sTxtGoblins & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 3)
	GUICtrlSetOnEvent(-1, "lblTotalCountGobl")

$x += 38
	; Balloons
	$icnBall = GUICtrlCreateIcon($pIconLib, $eIcnBalloon, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtBalloons & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevBall")
	$txtLevBall = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumBall = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtBalloons & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountBall")

$x += 38
	; Healers
	$icnHeal = GUICtrlCreateIcon($pIconLib, $eIcnHealer, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtHealers & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevHeal")
	$txtLevHeal = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumHeal = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHealers & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountHeal")

$x += 38
	; Pekkas
	$icnPekk = GUICtrlCreateIcon($pIconLib, $eIcnPekka, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtPekkas & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevPekk")
	$txtLevPekk = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumPekk = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtPekkas & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountPekk")

$x += 38
	; Miners
	$icnMine = GUICtrlCreateIcon($pIconLib, $eIcnMiner, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1,  GetTranslated(603,39, -1) & " " & $sTxtMiners & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevMine")
	$txtLevMine = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumMine = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtMiners & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountMine")

$x += 45
	; Hogs
	$icnHogs = GUICtrlCreateIcon($pIconLib, $eIcnHogRider, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtHogRiders & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevHogs")
	$txtLevHogs = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumHogs = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHogRiders & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountHogs")

$x += 38
	; Golems
	$icnGole = GUICtrlCreateIcon($pIconLib, $eIcnGolem, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtGolems & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevGole")
	$txtLevGole = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumGole = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtGolems & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountGole")

$x += 38
	; Lavas
	$icnLava = GUICtrlCreateIcon($pIconLib, $eIcnLavaHound, $x, $y - 5, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtLavaHounds & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevLava")
	$txtLevLava = GUICtrlCreateLabel("0", $x + 2, $y + 14, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumLava = GUICtrlCreateInput("0", $x + 1, $y + 29, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtLavaHounds & " " & $sTxtSetPerc2)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountLava")

Local $x = 30
$y += 66
	GUICtrlCreateIcon($pIconLib, $eIcnCamp, $x - 10, $y - 15, 24, 24)
	$lblFullTroop = GUICtrlCreateLabel(GetTranslated(621, 20, "'Full' Camps"), $x + 16, $y - 7, 55, 17)
	$lblFullTroop2 = GUICtrlCreateLabel(ChrW(8805), $x + 75, $y - 7, -1, 17)
	$txtFullTroop = GUICtrlCreateInput("100", $x + 83, $y - 10, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetOnEvent(-1, "SetComboTroopComp")
	_GUICtrlSetTip(-1, GetTranslated(621, 21, "Army camps are 'Full' when reaching this %, then start attack."))
	GUICtrlSetLimit(-1, 3)
	$lblFullTroop3 = GUICtrlCreateLabel("%", $x + 114, $y - 7, -1, 17)

$x += 180
$Y -= 23
	$lblTotalCountCamp = GUICtrlCreateLabel(" 0s", $x - 13, $y + 15, 72, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	$icnTPSCamp = GUICtrlCreateIcon($pIconLib, $eIcnSpellsCost, $x - 33, $y + 10, 24, 24)
	$lblElixirCostCamp = GUICtrlCreateLabel(" 0", $x + 65, $y + 15, 77, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	$icnElixirCamp = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 63, $y + 14, 16, 16)
	$lblDarkCostCamp = GUICtrlCreateLabel(" 0", $x + 148, $y + 15, 62, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	$icnDarkCamp = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 146, $y + 14, 16, 16)

$x -= 195
$Y += 35
	$chkTotalCampForced = GUICtrlCreateCheckbox(GetTranslated(636, 46, "Force Total Army Camp") & ":", $x + 3, $y, -1, -1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "chkTotalCampForced")
	_GUICtrlSetTip(-1, GetTranslated(636, 47, "If not detected set army camp values (instead ask)"))
	$txtTotalCampForced = GUICtrlCreateInput("220", $x + 137, $y + 3, 30, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetOnEvent(-1, "SetComboTroopComp")
	GUICtrlSetLimit(-1, 3)

	$caltotaltroops = GUICtrlCreateProgress($x, $y + 22, 407, 10)
	$lbltotalprogress = GUICtrlCreateLabel("", $x, $y + 22, 407, 10)
	GUICtrlSetBkColor(-1, $COLOR_RED)
	GUICtrlSetState(-1, BitOR($GUI_DISABLE, $GUI_HIDE))

$x += 38
	$lblTotalTroops = GUICtrlCreateLabel(GetTranslated(621, 15, "Total"), $x + 295, $y + 7, -1, -1, $SS_RIGHT)
	$lblCountTotal = GUICtrlCreateLabel(0, $x + 330, $y + 5, 30, 15, $SS_CENTER)
	_GUICtrlSetTip(-1, GetTranslated(621, 16, "The total Units of Troops should equal Total Army Camps."))
	GUICtrlSetBkColor(-1, $COLOR_MONEYGREEN) ;lime, moneygreen
	$lblPercentTotal = GUICtrlCreateLabel("x", $x + 364, $y + 7, -1, -1)

GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 10
Local $y = 240
	$grpBrewSpells = GUICtrlCreateGroup(GetTranslated(1000, 2, "Brew Spells"), $x, $y, 418, 123)
	$x += 20
	$y += 17
	$lblTotalSpell = GUICtrlCreateLabel(GetTranslated(622, 2, "Spell Capacity") & " :", $x - 15, $y, -1, -1, $SS_RIGHT)
	$txtTotalCountSpell = GUICtrlCreateCombo("", $x + 80, $y - 3, 35, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslated(622, 3, "Enter the No. of Spells Capacity. Set to ZERO if you don't want any Spells"))
	GUICtrlSetBkColor(-1, $COLOR_MONEYGREEN) ;lime, moneygreen
	GUICtrlSetData(-1, "0|2|4|6|7|8|9|10|11", "0")
	GUICtrlSetOnEvent(-1, "lblTotalCountSpell")

$y += 13
	$lblLSpellIcon = GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtLiSpell & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevLSpell")
	$txtLevLSpell = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumLSpell = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtLiSpell & " " & $sTxtSetSpell)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountLSpell")

$x += 38
	$lblHSpellIcon = GUICtrlCreateIcon($pIconLib, $eIcnHealSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtHeSpell & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevHSpell")
	$txtLevHSpell = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumHSpell = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHeSpell & " " & $sTxtSetSpell)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountHSpell")

$x += 38
	$lblRSpellIcon = GUICtrlCreateIcon($pIconLib, $eIcnRageSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtRaSpell & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevRSpell")
	$txtLevRSpell = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumRSpell = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtRaSpell & " " & $sTxtSetSpell)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountRSpell")

$x += 38
	$lblJSpellIcon = GUICtrlCreateIcon($pIconLib, $eIcnJumpSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtJuSPell & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevJSpell")
	$txtLevJSpell = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumJSpell = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtJuSPell & " " & $sTxtSetSpell)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountJSpell")

$x += 38
	$lblFSpellIcon = GUICtrlCreateIcon($pIconLib, $eIcnFreezeSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtFrSpell & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevFSpell")
	$txtLevFSpell = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumFSpell = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtFrSpell & " " & $sTxtSetSpell)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountFSpell")

$x += 38
	$lblCSpellIcon = GUICtrlCreateIcon($pIconLib, $eIcnCloneSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtClSpell & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevCSpell")
	$txtLevCSpell = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumCSpell = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtClSpell & " " & $sTxtSetSpell)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountCSpell")

$x += 45
	$lblPSpellIcon = GUICtrlCreateIcon($pIconLib, $eIcnPoisonSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtPoSpell & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevPSpell")
	$txtLevPSpell = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumPSpell = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtPoSpell & " " & $sTxtSetSpell)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountPSpell")

$x += 38
	$lblESpellIcon = GUICtrlCreateIcon($pIconLib, $eIcnEarthquakeSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtEaSpell & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevESpell")
	$txtLevESpell = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumESpell = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtEaSpell & " " & $sTxtSetSpell)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountESpell")

$x += 38
	$lblHaSpellIcon = GUICtrlCreateIcon($pIconLib, $eIcnHasteSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtHaSpell & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevHaSpell")
	$txtLevHaSpell = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumHaSpell = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtHaSpell & " " & $sTxtSetSpell)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountHaSpell")

$x += 38
	$lblSeSpellIcon = GUICtrlCreateIcon($pIconLib, $eIcnSkeletonSpell, $x, $y + 10, 32, 32)
	_GUICtrlSetTip(-1, GetTranslated(603,39, -1) & " " & $sTxtSkSpell & ":" & @CRLF &  GetTranslated(621,40, -1))
	GUICtrlSetOnEvent(-1, "LevSkSpell")
	$txtLevSkSpell = GUICtrlCreateLabel("0", $x + 2, $y + 29, 6, 11)
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 7, 400)
	$txtNumSkSpell = GUICtrlCreateInput("0", $x + 1, $y + 44, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, $sTxtSetPerc3 & " " & $sTxtSkSpell & " " & $sTxtSetSpell)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "lblTotalCountSkSpell")

$y += 56
Local $x = 17
	$chkForceBrewBeforeAttack = GUICtrlCreateCheckbox(GetTranslated(621, 42, "Force Brew Spells"), $x, $y + 12, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)

Local $x = 210
	$lblTotalCountSpell = GUICtrlCreateLabel(" 0s", $x - 13, $y + 15, 72, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	$icnTPSSpell = GUICtrlCreateIcon($pIconLib, $eIcnSpellsCost, $x - 33, $y + 10, 24, 24)
	$lblElixirCostSpell = GUICtrlCreateLabel(" 0", $x + 65, $y + 15, 77, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	$icnElixirSpell = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 63, $y + 14, 16, 16)
	$lblDarkCostSpell = GUICtrlCreateLabel(" 0", $x + 148, $y + 15, 62, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, $COLOR_GRAY)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	$icnDarkSpell = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 146, $y + 14, 16, 16)
GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 10
Local $y = 330

$hGUI_ARMY_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600, 22, "Boost"))

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

Global $lblQuantBoostDarkBarracks, $cmbQuantBoostDarkBarracks, $cmbBoostDarkBarracks ; DARK Barrackses

Global $lblBoostSpellFactory, $cmbBoostSpellFactory, $lblBoostDarkSpellFactory, $cmbBoostDarkSpellFactory
Global $lblBoostBarbarianKing, $cmbBoostBarbarianKing, $lblBoostArcherQueen, $cmbBoostArcherQueen
Global $lblBoostWarden, $cmbBoostWarden

Local $x = $xStart + 25, $y = $yStart + 45

	$grpBoosterBarracks = GUICtrlCreateGroup(GetTranslated(623, 2, "Boost Barracks"), $x - 20, $y - 20, 430, 60)
	GUICtrlCreateIcon($pIconLib, $eIcnBarrackBoost, $x - 10, $y + 5, 24, 24)
	GUICtrlCreateIcon($pIconLib, $eIcnDarkBarrackBoost, $x + 19, $y + 5, 24, 24)
	$lblBoostBarracks = GUICtrlCreateLabel(GetTranslated(623, 5, "Barracks") & " " & $textBoostLeft, $x + 20 + 29, $y + 4 + 7, -1, -1)
	$txtTip = GetTranslated(623, 6, "Use this to boost your Barracks with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $txtTip)
	$cmbBoostBarracks = GUICtrlCreateCombo("", $x + 140 + 45, $y + 7, 40, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
	_GUICtrlSetTip(-1, $txtTip)
	;######################## hidden... Not Needed After Oct Update #########################
	$lblQuantBoostBarracks = GUICtrlCreateLabel(GetTranslated(623, 3, "Num. Of Barracks to Boost"), $x + 20, $y + 4, -1, -1)
	$txtTip = GetTranslated(623, 4, "How many Barracks to boost with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$cmbQuantBoostBarracks = GUICtrlCreateCombo("", $x + 160, $y, 37, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4", "0")
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)
	;########################## START DARK Barrackses ##########################
	;$icDarkBarrack = GUICtrlCreateIcon($pIconLib, $eIcnDarkBarrackBoost, $x + 207, $y - 2, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$lblQuantBoostDarkBarracks = GUICtrlCreateLabel("Dark Barracks to Boost", $x + 237, $y + 4, -1, -1)
	$txtTip = "How many Dark Barracks to boost with GEMS! Use with caution!"
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$cmbQuantBoostDarkBarracks = GUICtrlCreateCombo("", $x + 365, $y, 37, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2", "0")
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	;########################## START DARK Barrackses ##########################
	$lblBoostDarkBarracks = GUICtrlCreateLabel("Dark Barracks" & " " & $textBoostLeft, $x + 237, $y + 27, -1, -1)
	GUICtrlSetState(-1, $GUI_HIDE)
	$txtTip = "Use this to boost your Dark Barracks with GEMS! Use with caution!"
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$cmbBoostDarkBarracks = GUICtrlCreateCombo("", $x + 365, $y + 23, 37, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)
	;########################## END DARK Barrackses ##########################
GUICtrlCreateGroup("", -99, -99, 1, 1)

$y += 65
	$grpBoosterSpellFactories = GUICtrlCreateGroup(GetTranslated(623, 7, "Boost Spell Factories"), $x - 20, $y - 20, 430, 50)
	GUICtrlCreateIcon($pIconLib, $eIcnSpellFactoryBoost, $x - 10, $y - 2, 24, 24)
	GUICtrlCreateIcon($pIconLib, $eIcnDarkSpellBoost, $x + 19, $y - 2, 24, 24)
	$lblBoostSpellFactory = GUICtrlCreateLabel(GetTranslated(623, 8, "Spell Factory") & " " & $textBoostLeft, $x + 20 + 29, $y + 4, -1, -1)
	$txtTip = GetTranslated(623, 9, "Use this to boost your Spell Factory with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $txtTip)
	$cmbBoostSpellFactory = GUICtrlCreateCombo("", $x + 185, $y, 40, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
	_GUICtrlSetTip(-1, $txtTip)

$y += 25
	GUICtrlCreateIcon($pIconLib, $eIcnDarkSpellBoost, $x - 10, $y - 2, 24, 24)
	GUICtrlSetState(-1, $GUI_HIDE)
	$lblBoostDarkSpellFactory = GUICtrlCreateLabel(GetTranslated(623, 10, "Dark Spell Factory") & " " & $textBoostLeft, $x + 20, $y + 4, -1, -1)
	$txtTip = GetTranslated(623, 11, "Use this to boost your Dark Spell Factory with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$cmbBoostDarkSpellFactory = GUICtrlCreateCombo("", $x + 200, $y, 30, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$y += 30
	$grpBoosterHeroes = GUICtrlCreateGroup(GetTranslated(623, 12, "Boost Heroes"), $x - 20, $y - 20, 430, 95)
	GUICtrlCreateIcon($pIconLib, $eIcnKingBoost, $x - 10, $y - 2, 24, 24)
	$lblBoostBarbarianKing = GUICtrlCreateLabel(GetTranslated(623, 13, "Barbarian King") & " " & $textBoostLeft, $x + 20, $y + 4, -1, -1)
	$txtTip = GetTranslated(623, 14, "Use this to boost your Barbarian King with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $txtTip)
	$cmbBoostBarbarianKing = GUICtrlCreateCombo("", $x + 185, $y, 40, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeKing")

$y += 25
	GUICtrlCreateIcon($pIconLib, $eIcnQueenBoost, $x - 10, $y - 2, 24, 24)
	$lblBoostArcherQueen = GUICtrlCreateLabel(GetTranslated(623, 15, "Archer Queen") & " " & $textBoostLeft, $x + 20, $y + 4, -1, -1)
	$txtTip = GetTranslated(623, 16, "Use this to boost your Archer Queen with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $txtTip)
	$cmbBoostArcherQueen = GUICtrlCreateCombo("", $x + 185, $y, 40, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeQueen")

$y += 25
	GUICtrlCreateIcon($pIconLib, $eIcnWardenBoost, $x - 10, $y - 2, 24, 24)
	$lblBoostWarden = GUICtrlCreateLabel(GetTranslated(623, 17, "Grand Warden") & " " & $textBoostLeft, $x + 20, $y + 4, -1, -1)
	$txtTip = GetTranslated(623, 18, "Use this to boost your Grand Warden with GEMS! Use with caution!")
	_GUICtrlSetTip(-1, $txtTip)
	$cmbBoostWarden = GUICtrlCreateCombo("", $x + 185, $y, 40, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12", "0")
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeWarden")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$y += 50
	$grpBoosterSchedule = GUICtrlCreateGroup(GetTranslated(623, 19, "Boost Schedule"), $x - 20, $y - 20, 430, 70)

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
	$lbBoostBarracksHoursED = GUICtrlCreateLabel("X", $x + 213, $y + 2, 11, 11)

$y += 15
	$chkBoostBarracksHours0 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours1 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours2 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours3 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours4 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours5 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours6 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours7 = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours8 = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours9 = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours10 = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours11 = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
	GUICtrlSetImage(-1, $pIconLib, $eIcnGoldStar, 0)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	$txtTip = GetTranslated(603, 2, "This button will clear or set the entire row of boxes")
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkBoostBarracksHoursE1")
	$lbBoostBarracksHoursAM = GUICtrlCreateLabel(GetTranslated(603, 3, "AM"), $x + 5, $y)

$y += 15
	$chkBoostBarracksHours12 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours13 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours14 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours15 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours16 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours17 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours18 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours19 = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours20 = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours21 = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours22 = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHours23 = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkBoostBarracksHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
	GUICtrlSetImage(-1, $pIconLib, $eIcnGoldStar, 0)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	$txtTip = GetTranslated(603, 2, -1)
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkBoostBarracksHoursE2")
	$lbBoostBarracksHoursPM = GUICtrlCreateLabel(GetTranslated(603, 4, "PM"), $x + 5, $y)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")


$hGUI_ARMY_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600, 54, "Train Order"))
;~ $x = $xStart + 182
$x = $xStart + 25
$y = $yStart + 45
	$grpTrainOrder = GUICtrlCreateGroup(GetTranslated(641, 25, "Training Order"), $x - 20, $y - 20, 271, 335)
	$chkTroopOrder = GUICtrlCreateCheckbox(GetTranslated(641, 26, "Custom Order"), $x - 5, $y, -1, -1)
	$txtTip = GetTranslated(641, 27, "Enable to select a custom troop training order") & @CRLF & _
			GetTranslated(641, 28, "Changing train order can be useful with CSV scripted attack armies!")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkTroopOrder2")

Local $sComboData = ""
; Do Not Use translated names here or ChangeTroopTrainOrder() code breaks
;Local $aTroopOrderList[] = ["", $sTxtBarbarians, $sTxtArchers, $sTxtGiants, $sTxtGoblins, $sTxtWallBreakers, $sTxtBalloons, $sTxtWizards, $sTxtHealers, $sTxtDragons, $sTxtPekkas, $sTxtBabyDragons, $sTxtMiners, $sTxtMinions, $sTxtHogRiders, $sTxtValkyries, $sTxtGolems, $sTxtWitches, $sTxtLavaHounds, $sTxtBowlers]
Local $aTroopOrderList[] = ["", "Barbarians", "Archers", "Giants", "Goblins", "Wall Breakers", "Balloons", "Wizards", "Healers", "Dragons", "Pekkas", "Baby Dragons", "Miners", "Minions", "Hog Riders", "Valkyries", "Golems", "Witches", "Lava Hounds", "Bowlers"]

; Create translated list of Troops for combo box
For $j = 0 To UBound($aTroopOrderList) - 1
	$sComboData &= $aTroopOrderList[$j] & "|"
Next

Local $txtTroopOrder = GetTranslated(641, 29, "Enter sequence order for training of troop #")

; Create ComboBox(es) for selection of troop training order
$y += 23
For $z = 0 To UBound($aTroopOrderList) - 2
	If $z < 12 Then
		$lblTroopOrder[$z] = GUICtrlCreateLabel($z + 1 & ":", $x - 16, $y + 2, -1, 18)
		$cmbTroopOrder[$z] = GUICtrlCreateCombo("", $x, $y, 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetOnEvent(-1, "GUITrainOrder")
		GUICtrlSetData(-1, $sComboData, "")
		_GUICtrlSetTip(-1, $txtTroopOrder & $z + 1)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$ImgTroopOrder[$z] = GUICtrlCreateIcon($pIconLib, $eIcnOptions, $x + 96, $y + 1, 18, 18)
		$y += 22 ; move down to next combobox location
	Else
		If $z = 12 Then
			$x += 128
			$y = $yStart + 45 + 23
		EndIf
		$lblTroopOrder[$z] = GUICtrlCreateLabel($z + 1 & ":", $x - 13, $y + 2, -1, 18)
		$cmbTroopOrder[$z] = GUICtrlCreateCombo("", $x + 4, $y, 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetOnEvent(-1, "GUITrainOrder")
		GUICtrlSetData(-1, $sComboData, "")
		_GUICtrlSetTip(-1, $txtTroopOrder & $z + 1)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$ImgTroopOrder[$z] = GUICtrlCreateIcon($pIconLib, $eIcnOptions, $x + 100, $y + 1, 18, 18)
		$y += 22 ; move down to next combobox location
	EndIf
Next

$x = $xStart + 25
$y = $yStart + 45 + 291
	; Create push button to set training order once completed
	$btnTroopOrderSet = GUICtrlCreateButton(GetTranslated(641, 30, "Apply New Order"), $x, $y, 222, 20)
	$txtTip = GetTranslated(641, 31, "Push button when finished selecting custom troop training order") & @CRLF & _
			GetTranslated(641, 32, "Icon changes color based on status: Red= Not Set, Green = Order Set")
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "btnTroopOrderSet")
	$ImgTroopOrderSet = GUICtrlCreateIcon($pIconLib, $eIcnSilverStar, $x + 226, $y + 2, 18, 18)

;Add custom dark troop train order soon
$x += 128
$y = $yStart + 45
	$chkDarkTroopOrder = GUICtrlCreateCheckbox(GetTranslated(641, 33, "Custom Dark Order"), $x - 5, $y, -1, -1)
	$txtTip = GetTranslated(641, 34, "Enable to select a custom dark troop training order") & @CRLF & _
			GetTranslated(641, 28, "Changing train order can be useful with CSV scripted attack armies!")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, $txtTip)
	;GUICtrlSetOnEvent(-1, "chkDarkTroopOrder2")
	GUICtrlSetState(-1, $GUI_HIDE)

Local $sComboData = ""
; Do Not Use translated names here or ChangeDarkTroopTrainOrder()code breaks
Local $aDarkTroopOrderList[8] = ["", "Minions", "Hog Riders", "Valkyries", "Golems", "Witches", "Lava Hounds", "Bowlers"]

; Create translated list of Troops for combo box
For $j = 0 To UBound($aDarkTroopOrderList) - 1
	$sComboData &= $aDarkTroopOrderList[$j] & "|"
Next

; Create ComboBox(es) for selection of dark troop training order
$y += 23
For $z = 0 To UBound($aDarkTroopOrderList) - 2
	$cmbDarkTroopOrder[$z] = GUICtrlCreateCombo("", $x + 4, $y, 92, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	;GUICtrlSetOnEvent(-1, "GUITrainDarkOrder")
	GUICtrlSetData(-1, $sComboData, "")
	_GUICtrlSetTip(-1, $txtTroopOrder & $z + 1)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)
	$ImgDarkTroopOrder[$z] = GUICtrlCreateIcon($pIconLib, $eIcnOptions, $x + 98, $y + 1, 18, 18)
	GUICtrlSetState(-1, $GUI_HIDE)
	$y += 22 ; move down to next combobox location
Next

$y = $yStart + 45 + 184
	; Create push button to set training order once completed
	$btnDarkTroopOrderSet = GUICtrlCreateButton(GetTranslated(641, 30, "Apply New Order"), $x + 2, $y, 92, 20)
	$txtTip = GetTranslated(641, 31, "Push button when finished selecting custom troop training order") & @CRLF & _
			GetTranslated(641, 32, "Icon changes color based on status: Red= Not Set, Green = Order Set")
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, $txtTip)
	;GUICtrlSetOnEvent(-1, "btnDarkTroopOrderSet")
	GUICtrlSetState(-1, $GUI_HIDE)
	$ImgDarkTroopOrderSet = GUICtrlCreateIcon($pIconLib, $eIcnSilverStar, $x + 98, $y + 1, 18, 18)
	GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlCreateGroup("", -99, -99, 1, 1)


$hGUI_ARMY_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslated(641, 1, "Options"))
$x = $xStart + 25
$y = $yStart + 45
	$grpCloseWaitTrain = GUICtrlCreateGroup(GetTranslated(641, 2, "Training Idle Time"), $x - 20, $y - 20, 151, 266)
	$chkCloseWaitEnable = GUICtrlCreateCheckbox(GetTranslated(641, 3, "Close While Training"), $x - 12, $y, 140, -1)
	$txtTip = GetTranslated(641, 4, "Option will exit CoC game for time required to complete TROOP training when SHIELD IS ACTIVE") & @CRLF & _
			GetTranslated(641, 5, "Close for Spell creation will be enabled when 'Wait for Spells' is selected on Search tabs") & @CRLF & _
			GetTranslated(641, 6, "Close for Hero healing will be enabled when 'Wait for Heroes' is enabled on Search tabs")
	GUICtrlSetState(-1, $GUI_CHECKED)
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkCloseWaitEnable")

$y += 28
	$chkCloseWaitTrain = GUICtrlCreateCheckbox(GetTranslated(641, 7, "Without Shield"), $x + 18, $y + 1, 110, -1)
	$txtTip = GetTranslated(641, 8, "Option will ALWAYS close CoC for idle training time and when NO SHIELD IS ACTIVE!") & @CRLF & _
			GetTranslated(641, 9, "Note - You can be attacked and lose trophies when this option is enabled!")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkCloseWaitTrain")
	$picCloseWaitTrain = GUICtrlCreateIcon($pIconLib, $eIcnNoShield, $x - 13, $y, 24, 24)
	_GUICtrlSetTip(-1, $txtTip)

$y += 28
	$btnCloseWaitStop = GUICtrlCreateCheckbox(GetTranslated(641, 13, "Close Emulator"), $x + 18, $y + 1, 110, -1)
	$txtTip = GetTranslated(641, 14, "Option will close Android Emulator completely when selected") & @CRLF & _
			GetTranslated(641, 15, "Adding this option may increase offline time slightly due to variable times required for startup")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "btnCloseWaitStop")
	$picCloseWaitStop = GUICtrlCreateIcon($pIconLib, $eIcnRecycle, $x - 13, $y + 13, 24, 24)
	_GUICtrlSetTip(-1, $txtTip)

$y += 28
	$btnCloseWaitStopRandom = GUICtrlCreateCheckbox(GetTranslated(641, 10, "Random Close"), $x + 18, $y + 1, 110, -1)
	$txtTip = GetTranslated(641, 11, "Option will Randomly choose between time out, close CoC, or Close emulator when selected") & @CRLF & _
			GetTranslated(641, 15, "Adding this option may increase offline time slightly due to variable times required for startup")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "btnCloseWaitStopRandom")

$y += 28
	$btnCloseWaitExact = GUICtrlCreateRadio(GetTranslated(641, 16, "Exact Time"), $x + 18, $y + 1, 110, -1)
	$txtTip = GetTranslated(641, 17, "Select to wait exact time required for troops to complete training")
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "btnCloseWaitRandom")
	$picCloseWaitExact = GUICtrlCreateIcon($pIconLib, $eIcnHourGlass, $x - 13, $y + 13, 24, 24)
	$txtTip = GetTranslated(641, 18, "Select how much time to wait when feature enables")
	_GUICtrlSetTip(-1, $txtTip)

$y += 24
	$btnCloseWaitRandom = GUICtrlCreateRadio(GetTranslated(641, 19, "Random Time"), $x + 18, $y + 1, 110, -1)
	$txtTip = GetTranslated(641, 20, "Select to ADD a random extra wait time like human who forgets to clash")
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "btnCloseWaitRandom")

$y += 28
	$cmbCloseWaitRdmPercent = GUICtrlCreateCombo("", $x + 36, $y, 40, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	$txtTip = GetTranslated(641, 21, "Enter maximum percentage of additional time to be used creating random wait times,") & @CRLF & _
			GetTranslated(641, 22, "Bot will compute a random wait time between exact time needed, and") & @CRLF & _
			GetTranslated(641, 23, "maximum random percent entered to appear more human like")
	GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15", "10")
	_GUICtrlSetTip(-1, $txtTip)
	$lblCloseWaitRdmPercent = GUICtrlCreateLabel("%", $x + 84, $y + 3, -1, -1)
	_GUICtrlSetTip(-1, $txtTip)

$y += 28
	$lblCloseWaitingTroops = GUICtrlCreateLabel(GetTranslated(641, 41, "Minimum Time To Close") & ": ", $x - 12, $y, -1, -1)
	$txtTip = GetTranslated(641, 42, "Will be close CoC If train time troops >= (Minimum time required to close)" & @CRLF & _
			"Just stay in the main screen if train time troops < (Minimum time required to close)")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkCloseWaitEnable")

$y += 22
	$lblSymbolWaiting = GUICtrlCreateLabel(">", $x + 26, $y + 3, -1, -1)
	$txtTip = GetTranslated(641, 43, "Enter number Minimum time to close in minutes for close CoC which you want, Default Is (2)")
	_GUICtrlSetTip(-1, $txtTip)
	$cmbMinimumTimeClose = GUICtrlCreateCombo("", $x + 36, $y, 40, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "2|3|4|5|6|7|8|9|10", "2")
	_GUICtrlSetTip(-1, $txtTip)
	$lblWaitingInMinutes = GUICtrlCreateLabel(GetTranslated(603, 10, -1), $x + 84, $y + 3, -1, -1)
	_GUICtrlSetTip(-1, $txtTip)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$y += 53
	$grpTiming = GUICtrlCreateGroup(GetTranslated(636, 30, "Train Click Timing"), $x - 20, $y - 20, 151, 60)
	$lbltxtTrainITDelay = GUICtrlCreateLabel(GetTranslated(636, 32, "delay"), $x - 10, $y, 37, 30)
	$txtTip = GetTranslated(636, 33, "Increase the delay if your PC is slow or to create human like training click speed")
	_GUICtrlSetTip(-1, $txtTip)
	$lbltxtTrainITDelayTime = GUICtrlCreateLabel("40 ms", $x - 10, $y + 15, 37, 30)
	_GUICtrlSetTip(-1, $txtTip)
	$sldTrainITDelay = GUICtrlCreateSlider($x + 30, $y, 90, 25, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
	_GUICtrlSetTip(-1, GetTranslated(636, 33, -1))
	_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
	_GUICtrlSlider_SetTicFreq(-100, 100)
	GUICtrlSetLimit(-1, 500, 1) ; change max/min value
	GUICtrlSetData(-1, 40) ; default value
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlSetOnEvent(-1, "sldTrainITDelay")

$x = $xStart + 25 + 151 + 5
$y = $yStart + 45
    $grpAddDelayIdlePhase = GUICtrlCreateGroup(GetTranslated(641,35, "Training Add Random Delay"), $x - 20, $y - 20, 173, 81)
$y += 15
	$chkAddDelayIdlePhaseEnable = GUICtrlCreateCheckbox(GetTranslated(641, 36, "Add Random Delay"),$x + 18, $y - 11, 130, -1)
	$txtTip = GetTranslated(641, 37, "Add random delay between two calls of train army.")& @CRLF & _
	GetTranslated(641, 38, "This option reduces the calls to the training window  humanizing the bot spacing calls each time with a causal interval chosen between the minimum and maximum values indicated below.")
	GUICtrlSetState(-1, $GUI_CHECKED)
	_GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkAddDelayIdlePhaseEnable")
	$picAddDelayIdlePhaseEnable = GUICtrlCreateIcon($pIconLib, $eIcnDelay, $x - 13, $y - 13, 24, 24)
	_GUICtrlSetTip(-1, $txtTip)

$x += 18
$y += 18
	$lbltxtAddDelayIdlePhaseBetween = GUICtrlCreateLabel(GetTranslated(641, 39, "Between"), $x-12, $y, 50, 30)
	;GUICtrlSetState(-1,$GUI_DISABLE)
	$txtAddDelayIdlePhaseTimeMin = GUICtrlCreateInput($iAddIdleTimeMin, $x + 32, $y-2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	;GUICtrlSetState(-1,$GUI_DISABLE)
	GUICtrlSetLimit(-1, 999)
	$lbltxtAddDelayIdlePhaseAnd = GUICtrlCreateLabel(GetTranslated(641, 40, "And"), $x+61, $y, 20, 30)
	$txtAddDelayIdlePhaseTimeMax = GUICtrlCreateInput($iAddIdleTimeMax, $x + 82, $y-2, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	;GUICtrlSetState(-1,$GUI_DISABLE)
	GUICtrlSetLimit(-1, 999)
	$lbltxtAddDelayIdlePhaseSec = GUICtrlCreateLabel(GetTranslated(603, 6, "sec."), $x+110, $y, 20, 30)
	;GUICtrlSetState(-1,$GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
