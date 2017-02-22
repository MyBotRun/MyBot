; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Upgrade" tab under the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_UPGRADE = 0, $g_hGUI_UPGRADE_TAB = 0, $g_hGUI_UPGRADE_TAB_ITEM1 = 0, $g_hGUI_UPGRADE_TAB_ITEM2 = 0, $g_hGUI_UPGRADE_TAB_ITEM3 = 0, _
	   $g_hGUI_UPGRADE_TAB_ITEM4 = 0

; Lab
Global $g_hChkAutoLabUpgrades = 0, $g_hCmbLaboratory = 0, $g_hLblNextUpgrade = 0, $g_hBtnResetLabUpgradeTime = 0, $g_hPicLabUpgrade = 0

; Heroes
Global $g_hChkUpgradeKing = 0, $g_hChkUpgradeQueen = 0, $g_hChkUpgradeWarden = 0, $g_hPicChkKingSleepWait = 0, $g_hPicChkQueenSleepWait = 0, $g_hPicChkWardenSleepWait = 0

; Buildings
Global $g_hChkUpgrade[$g_iUpgradeSlots] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hPicUpgradeStatus[$g_iUpgradeSlots] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hTxtUpgradeName[$g_iUpgradeSlots] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hTxtUpgradeLevel[$g_iUpgradeSlots] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hPicUpgradeType[$g_iUpgradeSlots] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hTxtUpgradeValue[$g_iUpgradeSlots] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hTxtUpgradeTime[$g_iUpgradeSlots] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hTxtUpgradeEndTime[$g_iUpgradeSlots] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hChkUpgradeRepeat[$g_iUpgradeSlots] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hTxtUpgrMinGold = 0, $g_hTxtUpgrMinElixir = 0, $g_hTxtUpgrMinDark = 0

; Walls
Global $g_hChkWalls = 0, $g_hTxtWallMinGold = 0, $g_hTxtWallMinElixir = 0, $g_hRdoUseGold = 0, $g_hRdoUseElixir = 0, $g_hRdoUseElixirGold = 0, $g_hChkSaveWallBldr = 0, _
	   $g_hCmbWalls = 4
Global $g_hLblWallCost = 0, $g_hBtnFindWalls = 0
Global $g_ahWallsCurrentCount[13] = [-1,-1,-1,-1,0,0,0,0,0,0,0,0,0] ; elements 0 to 3 are not referenced
Global $g_ahPicWallsLevel[13] = [-1,-1,-1,-1,0,0,0,0,0,0,0,0,0] ; elements 0 to 3 are not referenced


Func CreateVillageUpgrade()
   $g_hGUI_UPGRADE = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_VILLAGE)
   ;GUISetBkColor($COLOR_WHITE, $g_hGUI_UPGRADE)

   GUISwitch($g_hGUI_UPGRADE)
   $g_hGUI_UPGRADE_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
   $g_hGUI_UPGRADE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,14,"Laboratory"))
   CreateLaboratorySubTab()
   $g_hGUI_UPGRADE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,15,"Heroes"))
   CreateHeroesSubTab()
   $g_hGUI_UPGRADE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600,16,"Buildings"))
   CreateBuildingsSubTab()
   $g_hGUI_UPGRADE_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslated(600,17,"Walls"))
   CreateWallsSubTab()
   GUICtrlCreateTabItem("")
EndFunc

Func CreateLaboratorySubTab()
    Local $sTxtNames = GetTranslated(603,0, "None") & "|" & GetTranslated(604,1, "Barbarians") & "|" & GetTranslated(604,2, "Archers") & "|" & _
					   GetTranslated(604,3, "Giants") & "|" & GetTranslated(604,4, "Goblins") & "|" & GetTranslated(604,5, "Wall Breakers") & "|" & _
					   GetTranslated(604,7, "Balloons") & "|" & GetTranslated(604,8, "Wizards") & "|" & GetTranslated(604,9, "Healers") & "|" & _
					   GetTranslated(604,10, "Dragons") & "|" & GetTranslated(604,11, "Pekkas") & "|" &  GetTranslated(604,20, "Baby Dragons") & "|" & _
					   GetTranslated(604,21, "Miners") & "|" & _
					   GetTranslated(605,1, "Lightning Spell") & "|" & GetTranslated(605,2, "Healing Spell") & "|" & GetTranslated(605,3, "Rage Spell") & "|" & _
					   GetTranslated(605,4, "Jump Spell") & "|" & GetTranslated(605,5, "Freeze Spell") & "|" &  GetTranslated(605,12, "Clone Spell")& "|" & _
					   GetTranslated(605,6, "Poison Spell") & "|" & GetTranslated(605,7, "EarthQuake Spell") & "|" & GetTranslated(605,8, "Haste Spell") & "|" &  _
					   GetTranslated(605,13, "Skeleton Spell") & "|" & _
					   GetTranslated(604,13, "Minions") & "|" & GetTranslated(604,14, "Hog Riders") & "|" & GetTranslated(604,15, "Valkyries") & "|" & _
					   GetTranslated(604,16, "Golems") & "|" & GetTranslated(604,17, "Witches") & "|" & GetTranslated(604,18, "Lava Hounds") & "|" & _
					   GetTranslated(604, 19, "Bowlers")

 	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslated(614,1, "Laboratory"), $x - 20, $y - 20, 430, 334)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnLaboratory, $x, $y, 64, 64)
		$g_hChkAutoLabUpgrades = GUICtrlCreateCheckbox(GetTranslated(614,2, "Auto Laboratory Upgrades"), $x + 80, $y + 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(614,3, "Check box to enable automatically starting Upgrades in laboratory"))
			GUICtrlSetOnEvent(-1, "chkLab")
		$g_hLblNextUpgrade = GUICtrlCreateLabel(GetTranslated(614,4, "Next one") & ":", $x + 80, $y + 38, 50, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hCmbLaboratory = GUICtrlCreateCombo("", $x + 135, $y + 35, 140, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtNames, GetTranslated(603,0, "None"))
			_GUICtrlSetTip(-1, GetTranslated(614,5, "Select the troop type to upgrade with this pull down menu") & @CRLF & _
							   GetTranslated(614,6, "The troop icon will appear on the right.") & @CRLF & _
							   GetTranslated(614,7, "Any Dark Spell/Troop have priority over Upg Heroes!"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbLab")
		; Red button, will show on upgrade in progress. Temp unhide here and in Func ChkLab() if GUI needs editing.
		$g_hBtnResetLabUpgradeTime = GUICtrlCreateButton("", $x + 120 + 172, $y + 36, 18, 18, BitOR($BS_PUSHLIKE,$BS_DEFPUSHBUTTON))
			GUICtrlSetBkColor(-1, $COLOR_ERROR)
			;GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnRedLight)
			_GUICtrlSetTip(-1, GetTranslated(614,8, "Visible Red button means that laboratory upgrade in process") & @CRLF & _
							   GetTranslated(614,9, "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
							   GetTranslated(614,10, "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
							   GetTranslated(614,11, "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
							   GetTranslated(614,12, "Caution - Unnecessary timer reset will force constant checks for lab status"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE) ; comment this line out to edit GUI
			GUICtrlSetOnEvent(-1, "ResetLabUpgradeTime")
		$g_hPicLabUpgrade = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlank, $x + 330, $y, 64, 64)
			GUICtrlSetState(-1, $GUI_HIDE)
   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

Func CreateHeroesSubTab()
    Local $sTxtTip = ""
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslated(615,1, "Upgrade Heroes Continuously"), $x - 20, $y - 20, 430, 334)
		GUICtrlCreateLabel(GetTranslated(615,2, "Auto upgrading of your Heroes"), $x - 10, $y, -1, -1)

		$y += 20
		$g_hChkUpgradeKing = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
			$sTxtTip = GetTranslated(615,3, "Enable upgrading of your King when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & _
					   GetTranslated(615,4, "You can manually locate your Kings Altar on Misc Tab") & @CRLF & _
					   GetTranslated(615,5, "Verify your Resume Bot Dark Elixir value at Misc Tab vs Saving Min. Dark Elixir here!") & @CRLF & _
					   GetTranslated(615,11, "Enabled with TownHall 7 and higher")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeKing")
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnKingUpgr, $x + 18, $y, 64, 64)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicChkKingSleepWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingKing, $x + 18, $y, 64, 64)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1,$GUI_HIDE)

		$x += 95
		$g_hChkUpgradeQueen = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
			$sTxtTip = GetTranslated(615,6, "Enable upgrading of your Queen when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & _
					   GetTranslated(615,7, "You can manually locate your Queens Altar on Misc Tab") & @CRLF & _
					   GetTranslated(615,5, -1) & @CRLF & GetTranslated(615,12, "Enabled with TownHall 9 and higher")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeQueen")
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueenUpgr, $x + 18, $y, 64, 64)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicChkQueenSleepWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingQueen, $x + 18, $y, 64, 64)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1,$GUI_HIDE)

		$x += 95
		$g_hChkUpgradeWarden = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
			$sTxtTip = GetTranslated(615,8, "Enable upgrading of your Warden when you have enough Elixir (Saving Min. Elixir)") & @CRLF & _
					  GetTranslated(615,9, "You can manually locate your Wardens Altar on Misc Tab") & @CRLF & _
					  GetTranslated(615,5, -1) & @CRLF & GetTranslated(615,13, "Enabled with TownHall 11")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkUpgradeWarden")
			GUICtrlSetColor ( -1, $COLOR_ERROR )
			GUICtrlCreateIcon($g_sLibIconPath, $eIcnWardenUpgr, $x + 18, $y, 64, 64)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicChkWardenSleepWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingWarden, $x + 18, $y, 64, 64)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1,$GUI_HIDE)
	  GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

Func CreateBuildingsSubTab()
   Local $sTxtShowType = GetTranslated(616,29, "This shows type of upgrade, click to show location")
   Local $sTxtStatus = GetTranslated(616,30, "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed")
   Local $sTxtShowName = GetTranslated(616, 31, "This box is updated with unit name after upgrades are checked")
   Local $sTxtShowLevel = GetTranslated(616, 32, "This unit box is updated with unit level after upgrades are checked")
   Local $sTxtShowCost = GetTranslated(616, 33, "This upgrade cost box is updated after upgrades are checked")
   Local $sTxtShowTime = GetTranslated(616, 34, "This box is updated with time length of upgrade after upgrades are checked")
   Local $sTxtChkRepeat = GetTranslated(616, 35, "Check box to Enable Upgrade to repeat continuously")
   Local $sTxtShowEndTime = GetTranslated(616, 36, "This box is updated with estimate end time of upgrade after upgrades are checked")
   Local $sTxtCheckBox = GetTranslated(616,27, "Check box to Enable Upgrade")
   Local $sTxtAfterUsing = GetTranslated(616,28, "after using Locate Upgrades button")

   Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslated(616,1, "Buildings or Heroes"), $x - 20, $y - 20, 430, 30 + ($g_iUpgradeSlots * 22))
	$x -= 7
   ; table header
	$y -= 7
		GUICtrlCreateLabel(GetTranslated(616,2,"Unit Name"), $x+71, $y, 70, 18)
		GUICtrlCreateLabel(GetTranslated(616,3,"Lvl"), $x+153, $y, 40, 18)
		GUICtrlCreateLabel(GetTranslated(616,4,"Type"), $x+173, $y, 50, 18)
		GUICtrlCreateLabel(GetTranslated(616,5,"Cost"), $x+219, $y, 50, 18)
		GUICtrlCreateLabel(GetTranslated(616,6,"Time"), $x+270, $y, 50, 18)
		GUICtrlCreateLabel(GetTranslated(616,7,"Rep."), $x+392, $y, 50, 18)
		GUICtrlCreateLabel(GetTranslated(616,37,"Estimate End"), $x+314, $y, 70, 18)
	$y+=13

   ; Create upgrade GUI slots 0 to $g_iUpgradeSlots
   ; Can add more slots with $g_iUpgradeSlots value in Global variables file, 6 is minimum and max limit is 15 before GUI is too long.
	For $i = 0 To $g_iUpgradeSlots - 1
		$g_hPicUpgradeStatus[$i]= GUICtrlCreateIcon($g_sLibIconPath, $eIcnTroops, $x - 10, $y+1, 14, 14)
			_GUICtrlSetTip(-1, $sTxtStatus)
		$g_hChkUpgrade[$i] = GUICtrlCreateCheckbox($i+1 &":", $x + 5, $y+1, 34, 15)
			_GUICtrlSetTip(-1,  $sTxtCheckBox & " #" & $i+1 & " " & $sTxtAfterUsing)
;			GUICtrlSetFont(-1, 8)
			GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$g_hTxtUpgradeName[$i] = GUICtrlCreateInput("", $x+40, $y, 107, 17,BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
;			GUICtrlSetFont(-1, 8)
			_GUICtrlSetTip(-1, $sTxtShowName)
		$g_hTxtUpgradeLevel[$i] = GUICtrlCreateInput("", $x+150, $y, 23, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
;			GUICtrlSetFont(-1, 8)
			_GUICtrlSetTip(-1, $sTxtShowLevel)
		$g_hPicUpgradeType[$i]= GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlank,$x+178, $y+1, 15, 15)
			_GUICtrlSetTip(-1, $sTxtShowType)
			GUICtrlSetOnEvent(-1, "picUpgradeTypeLocation")
		$g_hTxtUpgradeValue[$i] = GUICtrlCreateInput("", $x+197, $y, 65, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
;			GUICtrlSetFont(-1, 8)
			_GUICtrlSetTip(-1, $sTxtShowCost)
		$g_hTxtUpgradeTime[$i] = GUICtrlCreateInput("", $x+266, $y, 35, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
;			GUICtrlSetFont(-1, 8)
			_GUICtrlSetTip(-1, $sTxtShowTime)
		$g_hTxtUpgradeEndTime[$i] = GUICtrlCreateInput("", $x+305, $y, 85, 17, BitOR($ES_LEFT, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
			GUICtrlSetFont(-1, 7)
			_GUICtrlSetTip(-1, $sTxtShowEndTime)
		$g_hChkUpgradeRepeat[$i] = GUICtrlCreateCheckbox("", $x + 395, $y+1, 15, 15)
;			GUICtrlSetFont(-1, 8)
			_GUICtrlSetTip(-1, $sTxtChkRepeat)
			GUICtrlSetOnEvent(-1, "btnchkbxRepeat")

		$y += 22
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x += 5
	$y += 8
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnGold, $x - 15, $y, 15, 15)
		GUICtrlCreateLabel(GetTranslated(616,14, "Min. Gold")&":", $x + 5, $y + 3, -1, -1)
		$g_hTxtUpgrMinGold = GUICtrlCreateInput("250000", $x + 55, $y, 61, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(616,15, "Save this much Gold after the upgrade completes.") & @CRLF & GetTranslated(616,16, "Set this value as needed to save for searching, or wall upgrades."))
			GUICtrlSetLimit(-1, 7)
	$y += 18
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnElixir, $x - 15, $y, 15, 15)
		GUICtrlCreateLabel(GetTranslated(616,17, "Min. Elixir") & ":", $x + 5, $y + 3, -1, -1)
		$g_hTxtUpgrMinElixir = GUICtrlCreateInput("250000", $x + 55, $y, 61, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(616,18, "Save this much Elixir after the upgrade completes") & @CRLF & GetTranslated(616,19, "Set this value as needed to save for making troops or wall upgrades."))
			GUICtrlSetLimit(-1, 7)
	$x -= 15
	$y -= 8
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnDark, $x + 140, $y, 15, 15)
		GUICtrlCreateLabel(GetTranslated(616,20, "Min. Dark") & ":", $x + 160, $y + 3, -1, -1)
		$g_hTxtUpgrMinDark = GUICtrlCreateInput("3000", $x + 210, $y, 61, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(616,21, "Save this amount of Dark Elixir after the upgrade completes.") & @CRLF & GetTranslated(616,22, "Set this value higher if you want make war troops."))
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y -= 8

   ; Locate/reset buttons
   GUICtrlCreateButton(GetTranslated(616,8, "Locate Upgrades"), $x + 290, $y - 4, 120, 18, BitOR($BS_MULTILINE, $BS_VCENTER))
	  _GUICtrlSetTip(-1, GetTranslated(616,9, "Push button to locate and record information on building/Hero upgrades") & @CRLF & _
						 GetTranslated(616,10, "Any upgrades with repeat enabled are skipped and can not be located again"))
	  GUICtrlSetOnEvent(-1, "btnLocateUpgrades")
   GUICtrlCreateButton(GetTranslated(616,11, "Reset Upgrades"), $x + 290, $y + 16, 120, 18, BitOR($BS_MULTILINE, $BS_VCENTER))
	  _GUICtrlSetTip(-1, GetTranslated(616,12, "Push button to reset & remove upgrade information") & @CRLF & _
						 GetTranslated(616,13, "If repeat box is checked, data will not be reset"))
	  GUICtrlSetOnEvent(-1, "btnResetUpgrade")
EndFunc

Func CreateWallsSubTab()
   Local $x = 25, $y = 45
   GUICtrlCreateGroup(GetTranslated(617,1, "Walls"), $x - 20, $y - 20, 430, 120)
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnWall, $x - 12, $y - 6, 24, 24)
		$g_hChkWalls = GUICtrlCreateCheckbox(GetTranslated(617,2, "Auto Wall Upgrade"), $x + 18, $y-2, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(617,3, "Check this to upgrade Walls if there are enough resources."))
			GUICtrlSetState(-1, $GUI_ENABLE)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkWalls")
#CS		$sldMaxNbWall = GUICtrlCreateSlider( $x + 135, $y, 85 , 24, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
			_GUICtrlSetTip(-1, GetTranslated(617,4, "No. of Positions to test and find walls. Higher is better but slower."))
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 8, 1)
			GUICtrlSetData(-1, 4)
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
#CE			;GUICtrlSetOnEvent(-1, "SlidemaxNbWall")
		$g_hBtnFindWalls = GUICtrlCreateButton(GetTranslated(617,5, "TEST"), $x + 150, $y +26 , 45, -1)
			_GUICtrlSetTip(-1, GetTranslated(617,6, "Click here to test the Wall Detection."))
			GUICtrlSetOnEvent(-1, "btnWalls")
			If $g_bBtnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
		$g_hRdoUseGold = GUICtrlCreateRadio(GetTranslated(617,7, "Use Gold"), $x + 25, $y + 16, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(617,8, "Use only Gold for Walls.") & @CRLF & GetTranslated(617,9, "Available at all Wall levels."))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hRdoUseElixir = GUICtrlCreateRadio(GetTranslated(617,10, "Use Elixir"), $x + 25, $y + 34, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(617,11, "Use only Elixir for Walls.") & @CRLF & GetTranslated(617,12, "Available only at Wall levels upgradeable with Elixir."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hRdoUseElixirGold = GUICtrlCreateRadio(GetTranslated(617,13, "Try Elixir first, Gold second"), $x + 25, $y + 52, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(617,14, "Try to use Elixir first. If not enough Elixir try to use Gold second for Walls.") & @CRLF & GetTranslated(617,12, -1))
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnBuilder, $x - 12, $y + 72, 20, 20)
		$g_hChkSaveWallBldr = GUICtrlCreateCheckbox(GetTranslated(617,15, "Save ONE builder for Walls"), $x+18, $y + 72, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(617,16, "Check this to reserve 1 builder exclusively for walls and") & @CRLF & _
							   GetTranslated(617,17, "reduce the available builder by 1 for other upgrades"))
			GUICtrlSetState(-1, $GUI_ENABLE)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkSaveWallBldr")

		$x += 225
		GUICtrlCreateLabel(GetTranslated(617,18, "Search for Walls level") & ":", $x, $y+2, -1, -1)
		$g_hCmbWalls = GUICtrlCreateCombo("", $x + 110, $y, 61, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL), $WS_EX_RIGHT)
			_GUICtrlSetTip(-1, GetTranslated(617,19, "Search for Walls of this level and try to upgrade them one by one."))
			GUICtrlSetData(-1, "4   |5   |6   |7   |8   |9   |10   |11   ", "4   ")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbWalls")
		GUICtrlCreateLabel(GetTranslated(617,20, "Next Wall level costs") &":", $x,  $y + 25, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(617,21, "Use this value as an indicator.") & @CRLF & _
							   GetTranslated(617,22, "The value will update if you select an other wall level."))
		$g_hLblWallCost = GUICtrlCreateLabel("30 000", $x + 110, $y + 25, 50, -1, $SS_RIGHT)

		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnGold, $x, $y + 47, 16, 16)
		GUICtrlCreateLabel(GetTranslated(617,23, "Min. Gold to save"), $x + 20, $y + 47, -1, -1)
		$g_hTxtWallMinGold = GUICtrlCreateInput("250000", $x + 110, $y + 45, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(617,24, "Save this much Gold after the wall upgrade completes,") & @CRLF & _
							   GetTranslated(617,25, "Set this value to save Gold for other upgrades, or searching."))
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y +=2
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnElixir, $x, $y + 67, 16, 16)
		GUICtrlCreateLabel(GetTranslated(617,32, "Min. Elixir to save"), $x + 20, $y + 70, -1, -1)
		$g_hTxtWallMinElixir = GUICtrlCreateInput("250000", $x + 110, $y + 65, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(617,27, "Save this much Elixir after the wall upgrade completes,") & @CRLF & _
							   GetTranslated(617,28, "Set this value to save Elixir for other upgrades or troop making."))
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 25, $y = 170
	GUICtrlCreateGroup(Gettranslated(617,29, "Walls counter"), $x - 20, $y - 20, 430, 100)
		$x -= 3
		$g_ahWallsCurrentCount[4] = GUICtrlCreateInput("0", $x - 10, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 4 "&GetTranslated(617,31, "you have."))
		$g_ahPicWallsLevel[4] = GUICtrlCreateIcon($g_sLibIconPath, $eWall04, $x + 17, $y-2, 24, 24)
		$x += 80
		$g_ahWallsCurrentCount[5] = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 5 "&GetTranslated(617,31, "you have."))
		$g_ahPicWallsLevel[5] = GUICtrlCreateIcon($g_sLibIconPath, $eWall05, $x+27, $y-2, 24, 24)
		$x += 80
		$g_ahWallsCurrentCount[6] = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 6 "&GetTranslated(617,31, "you have."))
		$g_ahPicWallsLevel[6] = GUICtrlCreateIcon($g_sLibIconPath, $eWall06, $x+27, $y-2, 24, 24)
		$x += 80
		$g_ahWallsCurrentCount[7] = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 7 "&GetTranslated(617,31, "you have."))
		$g_ahPicWallsLevel[7] = GUICtrlCreateIcon($g_sLibIconPath, $eWall07, $x+27, $y-2, 24, 24)
		$x += 80
		$g_ahWallsCurrentCount[8] = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 8 "&GetTranslated(617,31, "you have."))
		$g_ahPicWallsLevel[8] = GUICtrlCreateIcon($g_sLibIconPath, $eWall08, $x+27, $y-2, 24, 24)
		Local $x = 25
		$x -= 3
		$x += 10
		$y += 40
		$g_ahWallsCurrentCount[9] = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 9 "&GetTranslated(617,31, "you have."))
		$g_ahPicWallsLevel[9] = GUICtrlCreateIcon($g_sLibIconPath, $eWall09, $x+27, $y-2, 24, 24)
		$x += 80
		$g_ahWallsCurrentCount[10] = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 10 "&GetTranslated(617,31, "you have."))
		$g_ahPicWallsLevel[10] = GUICtrlCreateIcon($g_sLibIconPath, $eWall10, $x+27, $y-2, 24, 24)
		$x += 80
		$g_ahWallsCurrentCount[11] = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 11 "&GetTranslated(617,31, "you have."))
		$g_ahPicWallsLevel[11] = GUICtrlCreateIcon($g_sLibIconPath, $eWall11, $x+27, $y-2, 24, 24)
		$x += 80
		$g_ahWallsCurrentCount[12] = GUICtrlCreateInput("0", $x, $y , 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(617,30, "Input number of Walls level")&" 12 "&GetTranslated(617,31, "you have."))
		$g_ahPicWallsLevel[12] = GUICtrlCreateIcon($g_sLibIconPath, $eWall12, $x+27, $y-2, 24, 24)
   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc