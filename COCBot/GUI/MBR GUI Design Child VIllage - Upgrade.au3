; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

$hGUI_UPGRADE = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_VILLAGE)
;GUISetBkColor($COLOR_WHITE, $hGUI_UPGRADE)

$hGUI_UPGRADE_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
$hGUI_UPGRADE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,14,"Laboratory"))

Global $chkLab, $cmbLaboratory, $chkUpgradeKing, $chkUpgradeQueen, $chkUpgradeWarden, $chkbxUpgrade, $chkbxUpgrade, $txtUpgradeX, $txtUpgradeY,$txtUpgradeValue
Global $icnLabUpgrade, $btnResetLabUpgradeTime
Global $txtUpgrMinGold, $txtUpgrMinElixir, $lblNextUpgrade

;~ -------------------------------------------------------------
;~ Language Variables used a lot
;~ -------------------------------------------------------------

$sTxtNothing = GetTranslated(603,0, "None")

$sTxtNames = $sTxtNothing & "|" & $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & _
	$sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" &  $sTxtBDragons & "|" &  $sTxtMiners & "|" & _
	$sTxtLiSpell & "|" & $sTxtHeSpell & "|" & $sTxtRaSpell & "|" & $sTxtJuSPell & "|" & $sTxtFrSpell & "|" &  $sTxtClSpell& "|" & $sTxtPoSpell & "|" & _
	$sTxtEaSpell & "|" & $sTxtHaSpell & "|" &  $sTxtSkSpell & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds & "|" & $sTxtBowlers

;$sTxtUpgrade = GetTranslated(8,43, "Upgrade")
$sTxtCheckBox = GetTranslated(616,27, "Check box to Enable Upgrade")
$sTxtAfterUsing = GetTranslated(616,28, "after using Locate Upgrades button")
;$sTxtXPos = GetTranslated(8,46, "XPos")
;$sTxtYPos = GetTranslated(8,47, "YPos")
$sTxtShowType = GetTranslated(616,29, "This shows type of upgrade, click to show location")
$sTxtStatus = GetTranslated(616,30, "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed")
$sTxtShowName = GetTranslated(616, 31, "This box is updated with unit name after upgrades are checked")
$sTxtShowLevel = GetTranslated(616, 32, "This unit box is updated with unit level after upgrades are checked")
$sTxtShowCost = GetTranslated(616, 33, "This upgrade cost box is updated after upgrades are checked")
$sTxtShowTime = GetTranslated(616, 34, "This box is updated with time length of upgrade after upgrades are checked")
$sTxtChkRepeat = GetTranslated(616, 35, "Check box to Enable Upgrade to repeat continuously")

	Local $x = 25, $y = 45
	$Laboratory = GUICtrlCreateGroup(GetTranslated(614,1, "Laboratory"), $x - 20, $y - 20, 430, 334)
		GUICtrlCreateIcon($pIconLib, $eIcnLaboratory, $x, $y, 64, 64)
		$chkLab = GUICtrlCreateCheckbox(GetTranslated(614,2, "Auto Laboratory Upgrades"), $x + 80, $y + 5, -1, -1)
			$txtTip = GetTranslated(614,3, "Check box to enable automatically starting Upgrades in laboratory")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkLab")
		$lblNextUpgrade = GUICtrlCreateLabel(GetTranslated(614,4, "Next one") & ":", $x + 80, $y + 38, 50, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$cmbLaboratory = GUICtrlCreateCombo("", $x + 135, $y + 35, 140, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtNames, GetTranslated(603,0, "None"))
			$txtTip = GetTranslated(614,5, "Select the troop type to upgrade with this pull down menu") & @CRLF & _
				GetTranslated(614,6, "The troop icon will appear on the right.") & @CRLF & GetTranslated(614,7, "Any Dark Spell/Troop have priority over Upg Heroes!")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbLab")
; Red button, will show on upgrade in progress. Temp unhide here and in Func ChkLab() if GUI needs editing.
		$btnResetLabUpgradeTime = GUICtrlCreateButton("", $x + 120 + 172, $y + 36, 18, 18, BitOR($BS_PUSHLIKE,$BS_DEFPUSHBUTTON))
			GUICtrlSetBkColor(-1, $COLOR_RED)
			;GUICtrlSetImage(-1, $pIconLib, $eIcnRedLight)
			$txtTip = GetTranslated(614,8, "Visible Red button means that laboratory upgrade in process") & @CRLF & _
			GetTranslated(614,9, "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
			GetTranslated(614,10, "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
			GetTranslated(614,11, "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
			GetTranslated(614,12, "Caution - Unnecessary timer reset will force constant checks for lab status")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE) ; comment this line out to edit GUI
			GUICtrlSetOnEvent(-1, "ResetLabUpgradeTime")
		$icnLabUpgrade = GUICtrlCreateIcon($pIconLib, $eIcnBlank, $x + 330, $y, 64, 64)
			GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")

$hGUI_UPGRADE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,15,"Heroes"))
	Local $x = 25, $y = 45
	$grpHeroes = GUICtrlCreateGroup(GetTranslated(615,1, "Upgrade Heroes Continuously"), $x - 20, $y - 20, 430, 334)
		$lblUpgradeHeroes = GUICtrlCreateLabel(GetTranslated(615,2, "Auto upgrading of your Heroes"), $x - 10, $y, -1, -1)
		$y += 20
		$chkUpgradeKing = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
			$txtTip = GetTranslated(615,3, "Enable upgrading of your King when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & GetTranslated(615,4, "You can manually locate your Kings Altar on Misc Tab") & @CRLF & _
			GetTranslated(615,5, "Verify your Resume Bot Dark Elixir value at Misc Tab vs Saving Min. Dark Elixir here!") & @CRLF & GetTranslated(615,11, "Enabled with TownHall 7 and higher")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeKing")
		GUICtrlCreateIcon($pIconLib, $eIcnKingUpgr, $x + 18, $y, 64, 64)
			GUICtrlSetTip(-1, $txtTip)
		$IMGchkKingSleepWait=GUICtrlCreateIcon($pIconLib, $eIcnSleepingKing, $x + 18, $y, 64, 64)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1,$GUI_HIDE)
		$x += 95
		$chkUpgradeQueen = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
			$txtTip = GetTranslated(615,6, "Enable upgrading of your Queen when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & GetTranslated(615,7, "You can manually locate your Queens Altar on Misc Tab") & @CRLF & _
			GetTranslated(615,5, -1) & @CRLF & GetTranslated(615,12, "Enabled with TownHall 9 and higher")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeQueen")
		GUICtrlCreateIcon($pIconLib, $eIcnQueenUpgr, $x + 18, $y, 64, 64)
			GUICtrlSetTip(-1, $txtTip)
		$IMGchkQueenSleepWait=GUICtrlCreateIcon($pIconLib, $eIcnSleepingQueen, $x + 18, $y, 64, 64)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1,$GUI_HIDE)
		$x += 95
		$chkUpgradeWarden = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
			$txtTip = GetTranslated(615,8, "Enable upgrading of your Warden when you have enough Elixir (Saving Min. Elixir)") & @CRLF & GetTranslated(615,9, "You can manually locate your Wardens Altar on Misc Tab") & @CRLF & _
			GetTranslated(615,5, -1) & @CRLF & GetTranslated(615,13, "Enabled with TownHall 11")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeWarden")
			GUICtrlSetColor ( -1, $COLOR_RED )
			GUICtrlCreateIcon($pIconLib, $eIcnWardenUpgr, $x + 18, $y, 64, 64)
			GUICtrlSetTip(-1, $txtTip)
		$IMGchkWardenSleepWait=GUICtrlCreateIcon($pIconLib, $eIcnSleepingWarden, $x + 18, $y, 64, 64)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1,$GUI_HIDE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")

$hGUI_UPGRADE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600,16,"Buildings"))
	Local $x = 25, $y = 45
	$grpUpgrade = GUICtrlCreateGroup(GetTranslated(616,1, "Buildings or Heroes"), $x - 20, $y - 15, 430, 30 + ($iUpgradeSlots * 22))
	$x -= 7
; table header
	$y -= 3
		$lblUpgradeUp1 = GUICtrlCreateLabel(GetTranslated(616,2,"Unit Name"), $x+74, $y, 70, 18)
		$lblUpgradeUp2 = GUICtrlCreateLabel(GetTranslated(616,3,"Lvl"), $x+160, $y, 40, 18)
		$lblUpgradeUp3 = GUICtrlCreateLabel(GetTranslated(616,4,"Type"), $x+178, $y, 50, 18)
		$lblUpgradeUp4 = GUICtrlCreateLabel(GetTranslated(616,5,"Cost"), $x+229, $y, 50, 18)
		$lblUpgradeUp5 = GUICtrlCreateLabel(GetTranslated(616,6,"Time"), $x+282, $y, 50, 18)
		$lblUpgradeUp6 = GUICtrlCreateLabel(GetTranslated(616,7,"Repeat"), $x+310, $y, 50, 18)

	$y+=16
; Locate/reset buttons
		$btnLocateUpgrade = GUICtrlCreateButton(GetTranslated(616,8, "Locate Upgrades"), $x+347, $y+1, 67, 60, BitOR($BS_MULTILINE, $BS_VCENTER))
			$txtTip = GetTranslated(616,9, "Push button to locate and record information on building/Hero upgrades") & @CRLF & _
						GetTranslated(616,10, "Any upgrades with repeat enabled are skipped and can not be located again")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnLocateUpgrades")
		$btnResetUpgrade = GUICtrlCreateButton(GetTranslated(616,11, "Reset Upgrades"), $x+347, $y+68, 67, 60, BitOR($BS_MULTILINE, $BS_VCENTER))
			$txtTip = GetTranslated(616,12, "Push button to reset & remove upgrade information") & @CRLF & _
						GetTranslated(616,13, "If repeat box is checked, data will not be reset")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnResetUpgrade")
; Create upgrade GUI slots 0 to $iUpgradeSlots
; Can add more slots with $iUpgradeSlots value in Global variables file, 6 is minimum and max limit is 15 before GUI is too long.
	For $i = 0 To $iUpgradeSlots - 1
		$picUpgradeStatus[$i]= GUICtrlCreateIcon($pIconLib, $eIcnTroops, $x - 10, $y+1, 14, 14)
			GUICtrlSetTip(-1, $sTxtStatus)
		$chkbxUpgrade[$i] = GUICtrlCreateCheckbox($i+1 &":", $x + 7, $y+1, 34, 15)
			GUICtrlSetTip(-1,  $sTxtCheckBox & " #" & $i+1 & " " & $sTxtAfterUsing)
;			GUICtrlSetFont(-1, 8)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$txtUpgradeName[$i] = GUICtrlCreateInput("", $x+42, $y, 111, 17,BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
;			GUICtrlSetFont(-1, 8)
			GUICtrlSetTip(-1, $sTxtShowName)
		$txtUpgradeLevel[$i] = GUICtrlCreateInput("", $x+156, $y, 22, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
;			GUICtrlSetFont(-1, 8)
			GUICtrlSetTip(-1, $sTxtShowLevel)
		$picUpgradeType[$i]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+184, $y+1, 15, 15)
			GUICtrlSetTip(-1, $sTxtShowType)
			GUICtrlSetOnEvent(-1, "picUpgradeTypeLocation")
		$txtUpgradeValue[$i] = GUICtrlCreateInput("", $x+205, $y, 70, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
;			GUICtrlSetFont(-1, 8)
			GUICtrlSetTip(-1, $sTxtShowCost)
		$txtUpgradeTime[$i] = GUICtrlCreateInput("", $x+278, $y, 34, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
;			GUICtrlSetFont(-1, 8)
			GUICtrlSetTip(-1, $sTxtShowTime)
		$chkUpgrdeRepeat[$i] = GUICtrlCreateCheckbox("", $x + 323, $y+1, 15, 15)
;			GUICtrlSetFont(-1, 8)
			GUICtrlSetTip(-1, $sTxtChkRepeat)
			GUICtrlSetOnEvent(-1, "btnchkbxRepeat")
		$y += 22
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x += 5
	$y += 10
		GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x - 15, $y, 15, 15)
		$UpgrMinGold = GUICtrlCreateLabel(GetTranslated(616,14, "Min. Gold")&":", $x + 5, $y + 3, -1, -1)
		$txtUpgrMinGold = GUICtrlCreateInput("250000", $x + 55, $y, 61, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(616,15, "Save this much Gold after the upgrade completes.") & @CRLF & GetTranslated(616,16, "Set this value as needed to save for searching, or wall upgrades."))
			GUICtrlSetLimit(-1, 7)
	$x -= 15
		GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x + 140, $y, 15, 15)
		$UpgrMinElixir = GUICtrlCreateLabel(GetTranslated(616,17, "Min. Elixir") & ":", $x + 160, $y + 3, -1, -1)
		$txtUpgrMinElixir = GUICtrlCreateInput("250000", $x + 210, $y, 61, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(616,18, "Save this much Elixir after the upgrade completes") & @CRLF & GetTranslated(616,19, "Set this value as needed to save for making troops or wall upgrades."))
			GUICtrlSetLimit(-1, 7)
	$x -= 5
		GUICtrlCreateIcon ($pIconLib, $eIcnDark, $x + 285, $y, 15, 15)
		$UpgrMinDark = GUICtrlCreateLabel(GetTranslated(616,20, "Min. Dark") & ":", $x + 305, $y + 3, -1, -1)
		$txtUpgrMinDark= GUICtrlCreateInput("3000", $x + 360, $y, 61, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(616,21, "Save this amount of Dark Elixir after the upgrade completes.") & @CRLF & GetTranslated(616,22, "Set this value higher if you want make war troops."))
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")

$hGUI_UPGRADE_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslated(600,17,"Walls"))

Global $chkWalls
Global $txtWall04ST, $txtWall05ST, $txtWall06ST, $txtWall07ST, $txtWall08ST, $txtWall09ST, $txtWall10ST, $txtWall11ST
Global $Wall04ST, $Wall05ST, $Wall06ST, $Wall07ST, $Wall08ST, $Wall09ST, $Wall10ST, $Wall11ST
Global $sldMaxNbWall
Global $lblWallCost, $cmbWalls, $UseGold, $UseElixir, $UseElixirGold, $txtWallMinGold, $txtWallMinElixir

	Local $x = 25, $y = 45
		$grpWalls = GUICtrlCreateGroup(GetTranslated(617,1, "Walls"), $x - 20, $y - 20, 430, 120)
		GUICtrlCreateIcon ($pIconLib, $eIcnWall, $x - 12, $y - 6, 24, 24)
		$chkWalls = GUICtrlCreateCheckbox(GetTranslated(617,2, "Auto Wall Upgrade"), $x + 18, $y-2, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(617,3, "Check this to upgrade Walls if there are enough resources."))
			GUICtrlSetState(-1, $GUI_ENABLE)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkWalls")
			_ArrayConcatenate($G, $B)
		$sldMaxNbWall = GUICtrlCreateSlider( $x + 135, $y, 85 , 24, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
			GUICtrlSetTip(-1, GetTranslated(617,4, "No. of Positions to test and find walls. Higher is better but slower."))
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 8, 1)
			GUICtrlSetData(-1, 4)
			;GUICtrlSetOnEvent(-1, "SlidemaxNbWall")
		$btnFindWalls = GUICtrlCreateButton(GetTranslated(617,5, "TEST"), $x + 150, $y +26 , 45, -1)
			$txtTip = GetTranslated(617,6, "Click here to test the Wall Detection.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnWalls")
			IF $btnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
		$UseGold = GUICtrlCreateRadio(GetTranslated(617,7, "Use Gold"), $x + 25, $y + 16, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(617,8, "Use only Gold for Walls.") & @CRLF & GetTranslated(617,9, "Available at all Wall levels."))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$UseElixir = GUICtrlCreateRadio(GetTranslated(617,10, "Use Elixir"), $x + 25, $y + 34, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(617,11, "Use only Elixir for Walls.") & @CRLF & GetTranslated(617,12, "Available only at Wall levels upgradeable with Elixir."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$UseElixirGold = GUICtrlCreateRadio(GetTranslated(617,13, "Try Elixir first, Gold second"), $x + 25, $y + 52, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(617,14, "Try to use Elixir first. If not enough Elixir try to use Gold second for Walls.") & @CRLF & GetTranslated(617,12, -1))
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon ($pIconLib, $eIcnBuilder, $x - 12, $y + 72, 20, 20)
		$chkSaveWallBldr = GUICtrlCreateCheckbox(GetTranslated(617,15, "Save ONE builder for Walls"), $x+18, $y + 72, -1, -1)
			$TxtTip = GetTranslated(617,16, "Check this to reserve 1 builder exclusively for walls and") & @CRLF &GetTranslated(617,17, "reduce the available builder by 1 for other upgrades")
			GUICtrlSetTip(-1, $TxtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkSaveWallBldr")
		$x += 225
		$lblWalls = GUICtrlCreateLabel(GetTranslated(617,18, "Search for Walls level") & ":", $x, $y+2, -1, -1)
		$cmbWalls = GUICtrlCreateCombo("", $x + 110, $y, 61, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL), $WS_EX_RIGHT)
			GUICtrlSetTip(-1, GetTranslated(617,19, "Search for Walls of this level and try to upgrade them one by one."))
			GUICtrlSetData(-1, "4   |5   |6   |7   |8   |9   |10   ", "4   ")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbWalls")
			_ArrayConcatenate($G, $C)
		$lblTxtWallCost = GUICtrlCreateLabel(GetTranslated(617,20, "Next Wall level costs") &":", $x,  $y + 25, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(617,21, "Use this value as an indicator.") &@CRLF & GetTranslated(617,22, "The value will update if you select an other wall level."))
		$lblWallCost = GUICtrlCreateLabel("30 000", $x + 110, $y + 25, 50, -1, $SS_RIGHT)
			GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x, $y + 47, 16, 16)
		$WallMinGold = GUICtrlCreateLabel(GetTranslated(617,23, "Min. Gold to save"), $x + 20, $y + 47, -1, -1)
		$txtWallMinGold = GUICtrlCreateInput("250000", $x + 110, $y + 45, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(617,24, "Save this much Gold after the wall upgrade completes,") & @CRLF & GetTranslated(617,25, "Set this value to save Gold for other upgrades, or searching."))
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y +=2
		GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x, $y + 67, 16, 16)
		$WallMinElixir = GUICtrlCreateLabel(GetTranslated(617,32, "Min. Elixir to save"), $x + 20, $y + 70, -1, -1)
		$txtWallMinElixir = GUICtrlCreateInput("250000", $x + 110, $y + 65, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(617,27, "Save this much Elixir after the wall upgrade completes,") & @CRLF & GetTranslated(617,28, "Set this value to save Elixir for other upgrades or troop making."))
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 25, $y = 170
	$grpUpgrWalls = GUICtrlCreateGroup(Gettranslated(617,29, "Walls counter"), $x - 20, $y - 20, 430, 60)
		; Load PNG image
		;_GDIPlus_StartUp()
		$x -= 3
		$txtWall04ST = GUICtrlCreateInput("0", $x - 10, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 4 "&GetTranslated(617,31, "you have."))
		$Wall04ST = GUICtrlCreateIcon(@ScriptDir & "\Images\Walls\04.ico",-1, $x + 17, $y-2, 24, 24)
		$x = 70
		$txtWall05ST = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 5 "&GetTranslated(617,31, "you have."))
		$Wall05ST = GUICtrlCreateIcon(@ScriptDir & "\Images\Walls\05.ico",-1, $x+27, $y-2, 24, 24)
		$x = +130
		$txtWall06ST = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 6 "&GetTranslated(617,31, "you have."))
		$Wall06ST = GUICtrlCreateIcon(@ScriptDir & "\Images\Walls\06.ico",-1, $x+27, $y-2, 24, 24)
		$x = +180
		$txtWall07ST = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 7 "&GetTranslated(617,31, "you have."))
		$Wall07ST = GUICtrlCreateIcon(@ScriptDir & "\Images\Walls\07.ico",-1, $x+27, $y-2, 24, 24)
		$x = +230
		$txtWall08ST = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 8 "&GetTranslated(617,31, "you have."))
		$Wall08ST = GUICtrlCreateIcon(@ScriptDir & "\Images\Walls\08.ico",-1, $x+27, $y-2, 24, 24)
		$x = +280
		$txtWall09ST = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 9 "&GetTranslated(617,31, "you have."))
		$Wall09ST = GUICtrlCreateIcon(@ScriptDir & "\Images\Walls\09.ico",-1, $x+27, $y-2, 24, 24)
		$x = +330
		$txtWall10ST = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 10 "&GetTranslated(617,31, "you have."))
		$Wall10ST = GUICtrlCreateIcon(@ScriptDir & "\Images\Walls\10.ico",-1, $x+27, $y-2, 24, 24)
		$x = +380
		$txtWall11ST = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 11 "&GetTranslated(617,31, "you have."))
		$Wall11ST = GUICtrlCreateIcon(@ScriptDir & "\Images\Walls\11.ico",-1, $x+27, $y-2, 24, 24)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")

;GUISetState()
