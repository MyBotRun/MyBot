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

$tabUpgrades = GUICtrlCreateTabItem("Buildings")
	
	Local $x = 30, $y = 150
	$grpUpgrade = GUICtrlCreateGroup("Buildings or Heroes", $x - 20, $y - 20, 450, 360)
		
		$btnLocateUpgrade = GUICtrlCreateButton("Locate Upgrades", $x+330, $y-1, 95, 40, BitOR($BS_MULTILINE, $BS_VCENTER))
			$txtTip = "Push button to locate and record information on building/Hero upgrades"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnLocateUpgrades")
		$btnResetUpgrade = GUICtrlCreateButton("Reset Upgrades", $x+330, $y+45, 95, 40, BitOR($BS_MULTILINE, $BS_VCENTER))
			$txtTip = "Push button to reset & remove all located upgrades"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnResetUpgrade")
		
		$picUpgradeStatus[0]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x - 15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		 $chkbxUpgrade[0] = GUICtrlCreateCheckbox(" Upgrade #1:", $x + 5, $y + 1, 85, 17)
			$txtTip = "Check box to Enable Upgrade #1 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		 $lblUpgrade0PosX = GUICtrlCreateLabel("XPos: ", $x+98, $y+3, 38, 18)
			$txtUpgradeX[0] = GUICtrlCreateInput("", $x+128, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade0PosY = GUICtrlCreateLabel("YPos: ", $x+195, $y+3, 38, 18)
			$txtUpgradeY[0] = GUICtrlCreateInput("", $x+161, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[0]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+233, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[0] = GUICtrlCreateInput("", $x+251, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		
		$y+=22
		$picUpgradeStatus[1]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x-15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[1] = GUICtrlCreateCheckbox(" Upgrade #2:", $x + 5, $y + 1, 85, 17)
			$txtTip = "Check box to Enable Upgrade #2 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade1PosX = GUICtrlCreateLabel("XPos: ", $x+98, $y+3, 38, 18)
			$txtUpgradeX[1] = GUICtrlCreateInput("", $x+128, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade1PosY = GUICtrlCreateLabel("YPos: ", $x+195, $y+3, 38, 18)
			$txtUpgradeY[1] = GUICtrlCreateInput("", $x+161, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[1]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+233, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[1] = GUICtrlCreateInput("", $x+251, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[2]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x - 15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[2] = GUICtrlCreateCheckbox(" Upgrade #3:", $x + 5, $y + 1, 85, 17)
			$txtTip = "Check box to Enable Upgrade #3 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade2PosX = GUICtrlCreateLabel("XPos: ", $x+98, $y+3, 38, 18)
			$txtUpgradeX[2] = GUICtrlCreateInput("", $x+128, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade2PosY = GUICtrlCreateLabel("YPos: ", $x+195, $y+3, 38, 18)
			$txtUpgradeY[2] = GUICtrlCreateInput("", $x+161, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[2]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+233, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[2] = GUICtrlCreateInput("", $x+251, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[3]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight,$x-15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[3] = GUICtrlCreateCheckbox(" Upgrade #4:", $x + 5, $y + 1, 85, 17)
			$txtTip = "Check box to Enable Upgrade #4 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade3PosX = GUICtrlCreateLabel("XPos: ", $x+98, $y+3, 38, 18)
			 $txtUpgradeX[3] = GUICtrlCreateInput("", $x+128, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade3PosY = GUICtrlCreateLabel("YPos: ", $x+195, $y+3, 38, 18)
			 $txtUpgradeY[3] = GUICtrlCreateInput("", $x+161, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[3]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+233, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[3] = GUICtrlCreateInput("", $x+251, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[4]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight,$x-15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[4] = GUICtrlCreateCheckbox(" Upgrade #5:", $x + 5, $y + 1, 85, 17)
			$txtTip = "Check box to Enable Upgrade #5 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade4PosX = GUICtrlCreateLabel("XPos: ", $x+98, $y+3, 38, 18)
			 $txtUpgradeX[4] = GUICtrlCreateInput("", $x+128, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade4PosY = GUICtrlCreateLabel("YPos: ", $x+195, $y+3, 38, 18)
			 $txtUpgradeY[4] = GUICtrlCreateInput("", $x+161, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[4]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+233, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[4] = GUICtrlCreateInput("", $x+251, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[5]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight,$x-15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[5] = GUICtrlCreateCheckbox(" Upgrade #6:", $x + 5, $y + 1, 85, 17)
			$txtTip = "Check box to Enable Upgrade #6 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade5PosX = GUICtrlCreateLabel("XPos: ", $x+98, $y+3, 38, 18)
			 $txtUpgradeX[5] = GUICtrlCreateInput("", $x+128, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade5PosY = GUICtrlCreateLabel("YPos: ", $x+195, $y+3, 38, 18)
			 $txtUpgradeY[5] = GUICtrlCreateInput("", $x+161, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[5]= GUICtrlCreateIcon($pIconLib, $eIcnBlank, $x+233, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[5] = GUICtrlCreateInput("", $x+251, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[6]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x - 15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		 $chkbxUpgrade[6] = GUICtrlCreateCheckbox(" Upgrade #7:", $x + 5, $y + 1, 85, 17)
			$txtTip = "Check box to Enable Upgrade #7 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		 $lblUpgrade0PosX = GUICtrlCreateLabel("XPos: ", $x+98, $y+3, 38, 18)
			$txtUpgradeX[6] = GUICtrlCreateInput("", $x+128, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade0PosY = GUICtrlCreateLabel("YPos: ", $x+195, $y+3, 38, 18)
			$txtUpgradeY[6] = GUICtrlCreateInput("", $x+161, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[6]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+233, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[6] = GUICtrlCreateInput("", $x+251, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		
		$y+=22
		$picUpgradeStatus[7]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x-15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[7] = GUICtrlCreateCheckbox(" Upgrade #8:", $x + 5, $y + 1, 85, 17)
			$txtTip = "Check box to Enable Upgrade #8 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade1PosX = GUICtrlCreateLabel("XPos: ", $x+98, $y+3, 38, 18)
			$txtUpgradeX[7] = GUICtrlCreateInput("", $x+128, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade1PosY = GUICtrlCreateLabel("YPos: ", $x+195, $y+3, 38, 18)
			$txtUpgradeY[7] = GUICtrlCreateInput("", $x+161, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[7]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+233, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[7] = GUICtrlCreateInput("", $x+251, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[8]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight, $x - 15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[8] = GUICtrlCreateCheckbox(" Upgrade #9:", $x + 5, $y + 1, 85, 17)
			$txtTip = "Check box to Enable Upgrade #9 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade2PosX = GUICtrlCreateLabel("XPos: ", $x+98, $y+3, 38, 18)
			$txtUpgradeX[8] = GUICtrlCreateInput("", $x+128, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade2PosY = GUICtrlCreateLabel("YPos: ", $x+195, $y+3, 38, 18)
			$txtUpgradeY[8] = GUICtrlCreateInput("", $x+161, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[8]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+233, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[8] = GUICtrlCreateInput("", $x+251, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[9]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight,$x-15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[9] = GUICtrlCreateCheckbox(" Upgrade #10:", $x + 5, $y + 1, 85, 17)
			$txtTip = "Check box to Enable Upgrade #10 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade3PosX = GUICtrlCreateLabel("XPos: ", $x+98, $y+3, 38, 18)
			 $txtUpgradeX[9] = GUICtrlCreateInput("", $x+128, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade3PosY = GUICtrlCreateLabel("YPos: ", $x+195, $y+3, 38, 18)
			 $txtUpgradeY[9] = GUICtrlCreateInput("", $x+161, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[9]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+233, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[9] = GUICtrlCreateInput("", $x+251, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[10]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight,$x-15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[10] = GUICtrlCreateCheckbox(" Upgrade #11:", $x + 5, $y + 1, 85, 17)
			$txtTip = "Check box to Enable Upgrade #11 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade4PosX = GUICtrlCreateLabel("XPos: ", $x+98, $y+3, 38, 18)
			 $txtUpgradeX[10] = GUICtrlCreateInput("", $x+128, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade4PosY = GUICtrlCreateLabel("YPos: ", $x+195, $y+3, 38, 18)
			 $txtUpgradeY[10] = GUICtrlCreateInput("", $x+161, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[10]= GUICtrlCreateIcon($pIconLib, $eIcnBlank,$x+233, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[10] = GUICtrlCreateInput("", $x+251, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))

		$y+=22
		$picUpgradeStatus[11]= GUICtrlCreateIcon($pIconLib, $eIcnRedLight,$x-15, $y + 1, 16, 16)
			$txtTip = "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed"
			GUICtrlSetTip(-1, $txtTip)
		$chkbxUpgrade[11] = GUICtrlCreateCheckbox(" Upgrade #12:", $x + 5, $y + 1, 85, 17)
			$txtTip = "Check box to Enable Upgrade #12 after using Locate Upgrades button"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$lblUpgrade5PosX = GUICtrlCreateLabel("XPos: ", $x+98, $y+3, 38, 18)
			 $txtUpgradeX[11] = GUICtrlCreateInput("", $x+128, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$lblUpgrade5PosY = GUICtrlCreateLabel("YPos: ", $x+195, $y+3, 38, 18)
			 $txtUpgradeY[11] = GUICtrlCreateInput("", $x+161, $y-1, 31, 20, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		$picUpgradeType[11]= GUICtrlCreateIcon($pIconLib, $eIcnBlank, $x+233, $y, 16, 16)
			$txtTip = "This shows type of upgrade"
			GUICtrlSetTip(-1, $txtTip)
		$txtUpgradeValue[11] = GUICtrlCreateInput("", $x+251, $y-1, 65, 18, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
	
		
		
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
	GUICtrlCreateTabItem("")
