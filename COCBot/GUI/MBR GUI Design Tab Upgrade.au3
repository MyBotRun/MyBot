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

$sTxtNothing = GetTranslated(8,4, "None")
$sTxtBarbarians = GetTranslated(8,5, "Barbarian")
$sTxtArchers = GetTranslated(8,6, "Archer")
$sTxtGiants = GetTranslated(8,7, "Giant")
$sTxtGoblins = GetTranslated(8,8, "Goblin")
$sTxtWallBreakers = GetTranslated(8,9, "Wall Breaker")
$sTxtBalloons = GetTranslated(8,10, "Balloon")
$sTxtWizards = GetTranslated(8,11, "Wizard")
$sTxtHealers = GetTranslated(8,12, "Healer")
$sTxtDragons = GetTranslated(8,13, "Dragon")
$sTxtPekkas = GetTranslated(8,14, "Pekka")

$sTxtLiSpell = GetTranslated(8,15, "Lightning Spell")
$sTxtHeSpell = GetTranslated(8,16, "Healing Spell")
$sTxtRaSpell = GetTranslated(8,17, "Rage Spell")
$sTxtJuSPell = GetTranslated(8,18, "Jump Spell")
$sTxtFrSpell = GetTranslated(8,19, "Freeze Spell")
$sTxtPoSpell = GetTranslated(8,20, "Poison Spell")
$sTxtEaSpell = GetTranslated(8,21, "EarthQuake Spell")
$sTxtHaSpell = GetTranslated(8,22, "Haste Spell")

$sTxtMinions = GetTranslated(8,23, "Minion")
$sTxtHogRiders = GetTranslated(8,24, "Hog Rider")
$sTxtValkyries = GetTranslated(8,25, "Valkyrie")
$sTxtGolems = GetTranslated(8,26, "Golem")
$sTxtWitches = GetTranslated(8,27, "Witch")
$sTxtLavaHounds = GetTranslated(8,28, "Lava Hound")

$sTxtNames = $sTxtNothing & "|" & $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" &  $sTxtLiSpell & "|" & $sTxtHeSpell & "|" & $sTxtRaSpell & "|" & $sTxtJuSPell & "|" & $sTxtFrSpell & "|" & $sTxtPoSpell & "|" & $sTxtEaSpell & "|" & $sTxtHaSpell & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds

$sTxtUpgrade = GetTranslated(8,43, "Upgrade")
$sTxtCheckBox = GetTranslated(8,44, "Check box to Enable Upgrade")
$sTxtAfterUsing = GetTranslated(8,45, "after using Locate Upgrades button")
$sTxtXPos = GetTranslated(8,46, "XPos")
$sTxtYPos =GetTranslated(8,47, "YPos")
$sTxtShowType = GetTranslated(8,48, "This shows type of upgrade")
$sTxtStatus = GetTranslated(8,53, "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed")

;~ -------------------------------------------------------------
; Upgrades Tab
;~ -------------------------------------------------------------

$tabUpgrades = GUICtrlCreateTabItem(GetTranslated(8,1, "Upgrade"))
Local $x = 30, $y = 150
	$Laboratory = GUICtrlCreateGroup(GetTranslated(8,89, "Laboratory"), $x - 20, $y - 20, 270, 70)
		GUICtrlCreateIcon($pIconLib, $eIcnLaboratory, $x, $y, 32, 32)
		$chkLab = GUICtrlCreateCheckbox(GetTranslated(8,2, "Auto Laboratory Upgrades"), $x + 40, $y - 5 , -1, -1)
			$txtTip = GetTranslated(8,3, "Check box to enable automatically starting Upgrades in laboratory")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkLab")
		$lblNextUpgrade = GUICtrlCreateLabel(GetTranslated(8,29, "Next") & ":", $x + 40 , $y + 21, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$cmbLaboratory = GUICtrlCreateCombo("", $x + 73, $y + 18, 108, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtNames, GetTranslated(8,4, "None"))
			$txtTip = GetTranslated(8,30, "Select the troop type to upgrade with this pull down menu") & @CRLF & GetTranslated(8,31, "The troop icon will appear on the left.") & @CRLF & GetTranslated(8,32, "Any Dark Spell/Troop have priority over Upg Heroes!")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbLab")
		$icnLabUpgrade = GUICtrlCreateIcon($pIconLib, $eIcnLaboratory, $x + 198, $y, 32, 32)
			GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 305, $y = 150
	$grpHeroes = GUICtrlCreateGroup(GetTranslated(8,33, "Upgrade Heroes Continuously"), $x - 20, $y - 20, 175, 70)
		$lblUpgradeHeroes = GUICtrlCreateLabel(GetTranslated(8,93, "Auto upgrading of your Heroes"), $x - 10, $y, -1, -1)
		$y += 20
		$chkUpgradeKing = GUICtrlCreateCheckbox("", $x - 10, $y + 7, 17, 17)
			$txtTip = GetTranslated(8,35, "Enable upgrading of your King when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & GetTranslated(8,36, "You can manually locate your Kings Altar on Misc Tab") & @CRLF & GetTranslated(8,37, "Verify your Resume Bot Dark Elixir value at Misc Tab vs Saving Min. Dark Elixir here!")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeKing")
		GUICtrlCreateIcon($pIconLib, $eIcnKingUpgr, $x + 7, $y, 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$x += 55
		$chkUpgradeQueen = GUICtrlCreateCheckbox("", $x - 10, $y + 7, 17, 17)
			$txtTip = GetTranslated(8,39, "Enable upgrading of your Queen when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & GetTranslated(8,40, "You can manually locate your Queens Altar on Misc Tab") & @CRLF & GetTranslated(8,41, "Verify your Resume Bot Dark Elixir value at Misc Tab vs Saving Min. Dark Elixir here!")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeQueen")
		GUICtrlCreateIcon($pIconLib, $eIcnQueenUpgr, $x + 7, $y, 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$x += 55
		$chkUpgradeWarden = GUICtrlCreateCheckbox("", $x - 10, $y + 7, 17, 17)
			$txtTip = GetTranslated(8,94, "Enable upgrading of your Warden when you have enough Elixir (Saving Min. Elixir)") & @CRLF & GetTranslated(8,95, "You can manually locate your Wardens Altar on Misc Tab") & @CRLF & GetTranslated(8,96, "Verify your Resume Bot Elixir value at Misc Tab vs Saving Min. Elixir here!")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeWarden")
			GUICtrlSetColor ( -1, $COLOR_RED )
			GUICtrlCreateIcon($pIconLib, $eIcnWardenUpgr, $x + 7, $y, 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 215
	$grpUpgrade = GUICtrlCreateGroup(GetTranslated(8,42, "Buildings or Heroes"), $x - 20, $y - 15, 450, 180)
		$picUpgradeStatus[0]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x - 15, $y + 1, 16, 16)
			$txtTip = $sTxtStatus
			GUICtrlSetTip(-1, $txtTip)
		 $chkbxUpgrade[0] = GUICtrlCreateCheckbox(" " & $sTxtUpgrade & " #1:", $x + 5, $y + 1, 87, 17)
			$txtTip = $sTxtCheckBox & " #1 " & $sTxtAfterUsing
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		 $lblUpgrade0PosX = GUICtrlCreateLabel($sTxtXPos & ": ", $x+95, $y+3, 38, 18)
			$txtUpgradeX[0] = GUICtrlCreateInput("", $x+125, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade0PosY = GUICtrlCreateLabel($sTxtYPos & ": ", $x+192, $y+3, 38, 18)
			$txtUpgradeY[0] = GUICtrlCreateInput("", $x+158, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[0]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+230, $y, 16, 16)
			$txtTip = $sTxtShowType
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[0] = GUICtrlCreateInput("", $x+248, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$btnLocateUpgrade = GUICtrlCreateButton(GetTranslated(8,49, "Locate Upgrades"), $x+330, $y-1, 95, 60, BitOR($BS_MULTILINE, $BS_VCENTER))
			$txtTip = GetTranslated(8,50, "Push button to locate and record information on building/Hero upgrades")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnLocateUpgrades")
		$btnResetUpgrade = GUICtrlCreateButton(GetTranslated(8,51, "Reset Upgrades"), $x+330, $y+65, 95, 60, BitOR($BS_MULTILINE, $BS_VCENTER))
			$txtTip = GetTranslated(8,52, "Push button to reset & remove all located upgrades")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnResetUpgrade")

		$y+=22
		$picUpgradeStatus[1]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x-15, $y + 1, 16, 16)
			$txtTip = $sTxtStatus
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[1] = GUICtrlCreateCheckbox(" " & $sTxtUpgrade & " #2:", $x + 5, $y + 1, 87, 17)
			$txtTip = $sTxtCheckBox & " #2 " & $sTxtAfterUsing
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade1PosX = GUICtrlCreateLabel($sTxtXPos & ": ", $x+95, $y+3, 38, 18)
			$txtUpgradeX[1] = GUICtrlCreateInput("", $x+125, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade1PosY = GUICtrlCreateLabel($sTxtYPos & ": ", $x+192, $y+3, 38, 18)
			$txtUpgradeY[1] = GUICtrlCreateInput("", $x+158, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[1]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+230, $y, 16, 16)
			$txtTip = $sTxtShowType
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[1] = GUICtrlCreateInput("", $x+248, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[2]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x - 15, $y + 1, 16, 16)
			$txtTip = $sTxtStatus
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[2] = GUICtrlCreateCheckbox(" " & $sTxtUpgrade & " #3:", $x + 5, $y + 1, 87, 17)
			$txtTip = $sTxtCheckBox & " #3 " & $sTxtAfterUsing
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade2PosX = GUICtrlCreateLabel($sTxtXPos & ": ", $x+95, $y+3, 38, 18)
			$txtUpgradeX[2] = GUICtrlCreateInput("", $x+125, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade2PosY = GUICtrlCreateLabel($sTxtYPos & ": ", $x+192, $y+3, 38, 18)
			$txtUpgradeY[2] = GUICtrlCreateInput("", $x+158, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[2]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+230, $y, 16, 16)
			$txtTip = $sTxtShowType
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[2] = GUICtrlCreateInput("", $x+248, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[3]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight,$x-15, $y + 1, 16, 16)
			$txtTip = $sTxtStatus
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[3] = GUICtrlCreateCheckbox(" " & $sTxtUpgrade & " #4:", $x + 5, $y + 1, 87, 17)
			$txtTip = $sTxtCheckBox & " #4 " & $sTxtAfterUsing
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade3PosX = GUICtrlCreateLabel($sTxtXPos & ": ", $x+95, $y+3, 38, 18)
			 $txtUpgradeX[3] = GUICtrlCreateInput("", $x+125, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade3PosY = GUICtrlCreateLabel($sTxtYPos & ": ", $x+192, $y+3, 38, 18)
			 $txtUpgradeY[3] = GUICtrlCreateInput("", $x+158, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[3]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+230, $y, 16, 16)
			$txtTip = $sTxtShowType
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[3] = GUICtrlCreateInput("", $x+248, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[4]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight,$x-15, $y + 1, 16, 16)
			$txtTip = $sTxtStatus
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[4] = GUICtrlCreateCheckbox(" " & $sTxtUpgrade & " #5:", $x + 5, $y + 1, 87, 17)
			$txtTip = $sTxtCheckBox & " #5 " & $sTxtAfterUsing
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade4PosX = GUICtrlCreateLabel($sTxtXPos & ": ", $x+95, $y+3, 38, 18)
			 $txtUpgradeX[4] = GUICtrlCreateInput("", $x+125, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade4PosY = GUICtrlCreateLabel($sTxtYPos & ": ", $x+192, $y+3, 38, 18)
			 $txtUpgradeY[4] = GUICtrlCreateInput("", $x+158, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[4]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+230, $y, 16, 16)
			$txtTip = $sTxtShowType
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[4] = GUICtrlCreateInput("", $x+248, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[5]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight,$x-15, $y + 1, 16, 16)
			$txtTip = $sTxtStatus
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[5] = GUICtrlCreateCheckbox(" " & $sTxtUpgrade & " #6:", $x + 5, $y + 1, 87, 17)
			$txtTip = $sTxtCheckBox & " #6 " & $sTxtAfterUsing
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade5PosX = GUICtrlCreateLabel($sTxtXPos & ": ", $x+95, $y+3, 38, 18)
			 $txtUpgradeX[5] = GUICtrlCreateInput("", $x+125, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade5PosY = GUICtrlCreateLabel($sTxtYPos & ": ", $x+192, $y+3, 38, 18)
			 $txtUpgradeY[5] = GUICtrlCreateInput("", $x+158, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[5]= GUICtrlCreateIcon($pIconLib, $eIcnBlank, $x+230, $y, 16, 16)
			$txtTip = $sTxtShowType
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[5] = GUICtrlCreateInput("", $x+248, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=27
		GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x - 15, $y, 16, 16)
		$UpgrMinGold = GUICtrlCreateLabel(GetTranslated(8,54, "Min. Gold")&":", $x + 5, $y + 3, -1, -1)
		$txtUpgrMinGold = GUICtrlCreateInput("250000", $x + 60, $y - 2, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(8,55, "Save this much Gold after the upgrade completes.") & @CRLF & GetTranslated(8,56, "Set this value as needed to save for searching, or wall upgrades."))
			GUICtrlSetLimit(-1, 7)
		GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x + 140, $y, 16, 16)
		$UpgrMinElixir = GUICtrlCreateLabel(GetTranslated(8,57, "Min. Elixir") & ":", $x + 160, $y + 3, -1, -1)
		$txtUpgrMinElixir = GUICtrlCreateInput("250000", $x + 210, $y - 2, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(8,58, "Save this much Elixir after the upgrade completes") & @CRLF & GetTranslated(8,59, "Set this value as needed to save for making troops or wall upgrades."))
			GUICtrlSetLimit(-1, 7)
		GUICtrlCreateIcon ($pIconLib, $eIcnDark, $x + 285, $y, 16, 16)
		$UpgrMinDark = GUICtrlCreateLabel(GetTranslated(8,60, "Min. Dark") & ":", $x + 305, $y + 3, -1, -1)
		$txtUpgrMinDark= GUICtrlCreateInput("3000", $x + 360, $y - 2, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(8,61, "Save this amount of Dark Elixir after the upgrade completes.") & @CRLF & GetTranslated(8,62, "Set this value higher if you want make war troops."))
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 405
		$grpWalls = GUICtrlCreateGroup(GetTranslated(8,63, "Walls"), $x - 20, $y - 20, 450, 120)
		GUICtrlCreateIcon ($pIconLib, $eIcnWall, $x - 12, $y - 6, 24, 24)
		$chkWalls = GUICtrlCreateCheckbox(GetTranslated(8,64, "Auto Wall Upgrade"), $x + 18, $y-2, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(8,65, "Check this to upgrade Walls if there are enough resources."))
			GUICtrlSetState(-1, $GUI_ENABLE)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkWalls")
			_ArrayConcatenate($G, $B)
		$sldMaxNbWall = GUICtrlCreateSlider( $x + 135, $y, 85 , 24, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
			GUICtrlSetTip(-1, GetTranslated(8,90, "No. of Positions to test and find walls. Higher is better but slower."))
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 8, 1)
			GUICtrlSetData(-1, 4)
			;GUICtrlSetOnEvent(-1, "SlidemaxNbWall")
		$btnFindWalls = GUICtrlCreateButton(GetTranslated(8,91, "TEST"), $x + 90, $y +26 , 45, -1)
			$txtTip = GetTranslated(8,92, "Click here to test the Wall Detection.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnWalls")
			IF $btnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
		$UseGold = GUICtrlCreateRadio(GetTranslated(8,66, "Use Gold"), $x + 25, $y + 16, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(8,67, "Use only Gold for Walls.") & @CRLF & GetTranslated(8,68, "Available at all Wall levels."))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$UseElixir = GUICtrlCreateRadio(GetTranslated(8,69, "Use Elixir"), $x + 25, $y + 34, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(8,70, "Use only Elixir for Walls.") & @CRLF & GetTranslated(8,71, "Available only at Wall levels upgradeable with Elixir."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$UseElixirGold = GUICtrlCreateRadio(GetTranslated(8,72, "Try Elixir first, Gold second"), $x + 25, $y + 52, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(8,73, "Try to use Elixir first. If not enough Elixir try to use Gold second for Walls.") & @CRLF & GetTranslated(8,74, "Available only at Wall levels upgradeable with Elixir."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon ($pIconLib, $eIcnBuilder, $x - 12, $y + 72, 20, 20)
		$chkSaveWallBldr = GUICtrlCreateCheckbox(GetTranslated(8,75, "Save ONE builder for Walls"), $x+18, $y + 72, -1, -1)
			$TxtTip = GetTranslated(8,76, "Check this to reserve 1 builder exclusively for walls and") & @CRLF &GetTranslated(8,77, "reduce the available builder by 1 for other upgrades")
			GUICtrlSetTip(-1, $TxtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkSaveWallBldr")
		$x += 240
		$lblWalls = GUICtrlCreateLabel(GetTranslated(8,78, "Search for Walls level") & ":", $x, $y+2, -1, -1)
		$cmbWalls = GUICtrlCreateCombo("", $x + 110, $y, 61, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL), $WS_EX_RIGHT)
			GUICtrlSetTip(-1, GetTranslated(8,79, "Search for Walls of this level and try to upgrade them one by one."))
			GUICtrlSetData(-1, "4   |5   |6   |7   |8   |9   |10   ", "4   ")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbWalls")
			_ArrayConcatenate($G, $C)
		$lblTxtWallCost = GUICtrlCreateLabel(GetTranslated(8,80, "Next Wall level costs") &":", $x,  $y + 25, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(8,81, "Use this value as an indicator.") &@CRLF & GetTranslated(8,82, "The value will update if you select an other wall level."))
		$lblWallCost = GUICtrlCreateLabel("30 000", $x + 110, $y + 25, 50, -1, $SS_RIGHT)
			GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x, $y + 47, 16, 16)
		$WallMinGold = GUICtrlCreateLabel(GetTranslated(8,83, "Min. Gold to save"), $x + 20, $y + 47, -1, -1)
		$txtWallMinGold = GUICtrlCreateInput("250000", $x + 110, $y + 45, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(8,84, "Save this much Gold after the wall upgrade completes,") & @CRLF & GetTranslated(8,85, "Set this value to save Gold for other upgrades, or searching."))
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y +=2
		GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x, $y + 67, 16, 16)
		$WallMinElixir = GUICtrlCreateLabel(GetTranslated(8,86, "Min. Elixir to save"), $x + 20, $y + 70, -1, -1)
		$txtWallMinElixir = GUICtrlCreateInput("250000", $x + 110, $y + 65, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(8,87, "Save this much Elixir after the wall upgrade completes,") & @CRLF & GetTranslated(8,88, "Set this value to save Elixir for other upgrades or troop making."))
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")
