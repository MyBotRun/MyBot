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
; Upgrades Tab
;~ -------------------------------------------------------------

$tabUpgrades = GUICtrlCreateTabItem("Upgrade")
Local $x = 30, $y = 150
	$Laboratory = GUICtrlCreateGroup("Laboratory", $x - 20, $y - 20, 450, 65)
		GUICtrlCreateIcon($pIconLib, $eIcnLaboratory, $x, $y, 32, 32)
		$chkLab = GUICtrlCreateCheckbox("Auto Laboratory Upgrades", $x + 40, $y + 8, -1, -1)
			$txtTip = "Check box to enable automatically starting Upgrades in laboratory"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkLab")
		Local $sNames = "None|Barbarian|Archer|Giant|Goblin|Wall Breaker|Balloon|Wizard|Healer|Dragon|Pekka|Lightning Spell|Healing Spell|Rage Spell|Jump Spell|Freeze Spell|Poison Spell|EarthQuake Spell|Haste Spell|Minion|Hog Rider|Valkyrie|Golem|Witch|Lava Hound"
		$lblNextUpgrade = GUICtrlCreateLabel("Next do:", $x + 205, $y + 12, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$cmbLaboratory = GUICtrlCreateCombo("", $x + 250, $y + 8, 125, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sNames, $aLabTroops[0][3])
			$txtTip = "Select the troop type to upgrade with this pull down menu" & @CRLF & "The troop icon will appear on the left."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbLab")
		$icnLabUpgrade = GUICtrlCreateIcon($pIconLib, $eIcnLaboratory, $x + 380, $y, 32, 32)
			GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	Local $x = 260, $y = 150

	Local $x = 30, $y = 215
	$grpUpgrade = GUICtrlCreateGroup("Buildings or Heroes", $x - 20, $y - 15, 450, 180)
		$picUpgradeStatus[0]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x - 15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		 $chkbxUpgrade[0] = GUICtrlCreateCheckbox(" Upgrade #1:", $x + 5, $y + 1, 80, 17)
			$txtTip = "Check box to Enable Upgrade #1 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		 $lblUpgrade0PosX = GUICtrlCreateLabel("XPos: ", $x+95, $y+3, 38, 18)
			$txtUpgradeX[0] = GUICtrlCreateInput("", $x+125, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade0PosY = GUICtrlCreateLabel("YPos: ", $x+192, $y+3, 38, 18)
			$txtUpgradeY[0] = GUICtrlCreateInput("", $x+158, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[0]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+230, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[0] = GUICtrlCreateInput("", $x+248, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$btnLocateUpgrade = GUICtrlCreateButton("Locate Upgrades", $x+330, $y-1, 95, 60, BitOR($BS_MULTILINE, $BS_VCENTER))
			$txtTip = "Push button to locate and record information on building/Hero upgrades"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnLocateUpgrades")
		$btnResetUpgrade = GUICtrlCreateButton("Reset Upgrades", $x+330, $y+65, 95, 60, BitOR($BS_MULTILINE, $BS_VCENTER))
			$txtTip = "Push button to reset & remove all located upgrades"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnResetUpgrade")

		$y+=22
		$picUpgradeStatus[1]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x-15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[1] = GUICtrlCreateCheckbox(" Upgrade #2:", $x + 5, $y + 1, 80, 17)
			$txtTip = "Check box to Enable Upgrade #2 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade1PosX = GUICtrlCreateLabel("XPos: ", $x+95, $y+3, 38, 18)
			$txtUpgradeX[1] = GUICtrlCreateInput("", $x+125, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade1PosY = GUICtrlCreateLabel("YPos: ", $x+192, $y+3, 38, 18)
			$txtUpgradeY[1] = GUICtrlCreateInput("", $x+158, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[1]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+230, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[1] = GUICtrlCreateInput("", $x+248, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[2]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x - 15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[2] = GUICtrlCreateCheckbox(" Upgrade #3:", $x + 5, $y + 1, 80, 17)
			$txtTip = "Check box to Enable Upgrade #3 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade2PosX = GUICtrlCreateLabel("XPos: ", $x+95, $y+3, 38, 18)
			$txtUpgradeX[2] = GUICtrlCreateInput("", $x+125, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade2PosY = GUICtrlCreateLabel("YPos: ", $x+192, $y+3, 38, 18)
			$txtUpgradeY[2] = GUICtrlCreateInput("", $x+158, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[2]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+230, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[2] = GUICtrlCreateInput("", $x+248, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[3]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight,$x-15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[3] = GUICtrlCreateCheckbox(" Upgrade #4:", $x + 5, $y + 1, 80, 17)
			$txtTip = "Check box to Enable Upgrade #4 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade3PosX = GUICtrlCreateLabel("XPos: ", $x+95, $y+3, 38, 18)
			 $txtUpgradeX[3] = GUICtrlCreateInput("", $x+125, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade3PosY = GUICtrlCreateLabel("YPos: ", $x+192, $y+3, 38, 18)
			 $txtUpgradeY[3] = GUICtrlCreateInput("", $x+158, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[3]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+230, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[3] = GUICtrlCreateInput("", $x+248, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[4]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight,$x-15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[4] = GUICtrlCreateCheckbox(" Upgrade #5:", $x + 5, $y + 1, 80, 17)
			$txtTip = "Check box to Enable Upgrade #5 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade4PosX = GUICtrlCreateLabel("XPos: ", $x+95, $y+3, 38, 18)
			 $txtUpgradeX[4] = GUICtrlCreateInput("", $x+125, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade4PosY = GUICtrlCreateLabel("YPos: ", $x+192, $y+3, 38, 18)
			 $txtUpgradeY[4] = GUICtrlCreateInput("", $x+158, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[4]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+230, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[4] = GUICtrlCreateInput("", $x+248, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[5]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight,$x-15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[5] = GUICtrlCreateCheckbox(" Upgrade #6:", $x + 5, $y + 1, 80, 17)
			$txtTip = "Check box to Enable Upgrade #6 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade5PosX = GUICtrlCreateLabel("XPos: ", $x+95, $y+3, 38, 18)
			 $txtUpgradeX[5] = GUICtrlCreateInput("", $x+125, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade5PosY = GUICtrlCreateLabel("YPos: ", $x+192, $y+3, 38, 18)
			 $txtUpgradeY[5] = GUICtrlCreateInput("", $x+158, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[5]= GUICtrlCreateIcon($pIconLib, $eIcnBlank, $x+230, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[5] = GUICtrlCreateInput("", $x+248, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=27
		GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x - 15, $y, 16, 16)
		$UpgrMinGold = GUICtrlCreateLabel("Min. Gold:", $x + 5, $y + 3, -1, -1)
		$txtUpgrMinGold = GUICtrlCreateInput("250000", $x + 60, $y - 2, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Save this much Gold after the upgrade completes." & @CRLF & "Set this value as needed to save for searching, or wall upgrades.")
			GUICtrlSetLimit(-1, 7)
		GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x + 140, $y, 16, 16)
		$UpgrMinElixir = GUICtrlCreateLabel("Min. Elixir:", $x + 160, $y + 3, -1, -1)
		$txtUpgrMinElixir = GUICtrlCreateInput("250000", $x + 210, $y - 2, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Save this much Elixir after the upgrade completes" & @CRLF & "Set this value as needed to save for making troops or wall upgrades.")
			GUICtrlSetLimit(-1, 7)
		GUICtrlCreateIcon ($pIconLib, $eIcnDark, $x + 285, $y, 16, 16)
		$UpgrMinDark = GUICtrlCreateLabel("Min. Dark:", $x + 305, $y + 3, -1, -1)
		$txtUpgrMinDark= GUICtrlCreateInput("3000", $x + 360, $y - 2, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Save this amount of Dark Elixir after the upgrade completes." & @CRLF & "Set this value higher if you want make war troops.")
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 405
		$grpWalls = GUICtrlCreateGroup("Walls", $x - 20, $y - 20, 450, 120)
		GUICtrlCreateIcon ($pIconLib, $eIcnWall, $x - 12, $y - 6, 24, 24)
		$chkWalls = GUICtrlCreateCheckbox("Auto Wall Upgrade", $x + 18, $y-2, -1, -1)
			GUICtrlSetTip(-1, "Check this to upgrade Walls if there are enough resources.")
			GUICtrlSetState(-1, $GUI_ENABLE)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkWalls")
			_ArrayConcatenate($G, $B)
		$UseGold = GUICtrlCreateRadio("Use Gold", $x + 35, $y + 16, -1, -1)
			GUICtrlSetTip(-1, "Use only Gold for Walls." & @CRLF & "Available at all Wall levels.")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$UseElixir = GUICtrlCreateRadio("Use Elixir", $x + 35, $y + 34, -1, -1)
			GUICtrlSetTip(-1, "Use only Elixir for Walls." & @CRLF & "Available only at Wall levels upgradeable with Elixir.")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$UseElixirGold = GUICtrlCreateRadio("Try Elixir first, Gold second", $x + 35, $y + 52, -1, -1)
			GUICtrlSetTip(-1, "Try to use Elixir first. If not enough Elixir try to use Gold second for Walls." & @CRLF & "Available only at Wall levels upgradeable with Elixir.")
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon ($pIconLib, $eIcnBuilder, $x - 12, $y + 72, 20, 20)
		$chkSaveWallBldr = GUICtrlCreateCheckbox("Save ONE builder for Walls", $x+18, $y + 72, -1, -1)
			$TxtTip = "Check this to reserve 1 builder exclusively for walls and" & @CRLF _
				& "reduce the available builder by 1 for other upgrades"
			GUICtrlSetTip(-1, $TxtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkSaveWallBldr")
		$x += 220
		$lblWalls = GUICtrlCreateLabel("Search for Walls level:", $x, $y+2, -1, -1)
		$cmbWalls = GUICtrlCreateCombo("", $x + 110, $y, 61, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL), $WS_EX_RIGHT)
			GUICtrlSetTip(-1, "Search for Walls of this level and try to upgrade them one by one.")
			GUICtrlSetData(-1, "4   |5   |6   |7   |8   |9   |10   ", "4   ")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbWalls")
			_ArrayConcatenate($G, $C)
		$lblTxtWallCost = GUICtrlCreateLabel("Next Wall level costs:", $x,  $y + 25, -1, -1)
			GUICtrlSetTip(-1, "Use this value as an indicator." &@CRLF & "The value will update if you select an other wall level.")
		$lblWallCost = GUICtrlCreateLabel("30 000", $x + 110, $y + 25, 50, -1, $SS_RIGHT)
			GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x, $y + 47, 16, 16)
		$WallMinGold = GUICtrlCreateLabel("Min. Gold to save:", $x + 20, $y + 47, -1, -1)
		$txtWallMinGold = GUICtrlCreateInput("250000", $x + 110, $y + 45, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Save this much Gold after the wall upgrade completes," & @CRLF & "Set this value to save Gold for other upgrades, or searching.")
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y +=2
		GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x, $y + 67, 16, 16)
		$WallMinElixir = GUICtrlCreateLabel("Min. Elixir to save:", $x + 20, $y + 70, -1, -1)
		$txtWallMinElixir = GUICtrlCreateInput("250000", $x + 110, $y + 65, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Save this much Elixir after the wall upgrade completes," & @CRLF & "Set this value to save Elixir for other upgrades or troop making.")
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateTabItem("")
