; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Req. & Donate" tab under the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: MonkeyHunter (07-2016), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_DONATE = 0, $g_hGUI_DONATE_TAB = 0, $g_hGUI_DONATE_TAB_ITEM1 = 0, $g_hGUI_DONATE_TAB_ITEM2 = 0, $g_hGUI_DONATE_TAB_ITEM3 = 0

; Request
Global $g_hChkRequestTroopsEnable = 0, $g_hTxtRequestCC = 0, $g_ahChkRequestCCHours[24] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hChkRequestCCHoursE1 = 0, $g_hChkRequestCCHoursE2 = 0
Global $g_hGrpRequestCC = 0, $g_ahLblRequestCCHours0 = 0, $g_hLblRequestCCHoursAM = 0, $g_hLblRequestCCHoursPM = 0

; Donate
Global $g_hChkExtraAlphabets = 0, $g_hChkExtraChinese = 0, $g_hChkExtraKorean = 0
Global $g_ahChkDonateTroop[$eTroopCount+$g_iCustomDonateConfigs] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_ahChkDonateAllTroop[$eTroopCount+$g_iCustomDonateConfigs] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_ahTxtDonateTroop[$eTroopCount+$g_iCustomDonateConfigs] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_ahTxtBlacklistTroop[$eTroopCount+$g_iCustomDonateConfigs] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_ahGrpDonateTroop[$eTroopCount+$g_iCustomDonateConfigs] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_ahLblDonateTroop[$eTroopCount+$g_iCustomDonateConfigs] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_ahBtnDonateTroop[$eTroopCount+$g_iCustomDonateConfigs] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

Global $g_ahChkDonateSpell[$eSpellCount] = [0,0,0,0,0,-1,0,0,0,0]  ; element $eSpellClone (5) is unused
Global $g_ahChkDonateAllSpell[$eSpellCount] = [0,0,0,0,0,-1,0,0,0,0]  ; element $eSpellClone (5) is unused
Global $g_ahTxtDonateSpell[$eSpellCount] = [0,0,0,0,0,-1,0,0,0,0]  ; element $eSpellClone (5) is unused
Global $g_ahTxtBlacklistSpell[$eSpellCount] = [0,0,0,0,0,-1,0,0,0,0]  ; element $eSpellClone (5) is unused
Global $g_ahGrpDonateSpell[$eSpellCount] = [0,0,0,0,0,-1,0,0,0,0]  ; element $eSpellClone (5) is unused
Global $g_ahLblDonateSpell[$eSpellCount] = [0,0,0,0,0,-1,0,0,0,0]  ; element $eSpellClone (5) is unused
Global $g_ahBtnDonateSpell[$eSpellCount] = [0,0,0,0,0,-1,0,0,0,0]  ; element $eSpellClone (5) is unused

Global $g_ahCmbDonateCustomA[3] = [0,0,0], $g_ahTxtDonateCustomA[3] = [0,0,0], $g_ahPicDonateCustomA[3] = [0,0,0]
Global $g_ahCmbDonateCustomB[3] = [0,0,0], $g_ahTxtDonateCustomB[3] = [0,0,0], $g_ahPicDonateCustomB[3] = [0,0,0]

Global $g_hLblDonateTroopTBD1 = 0, $g_hLblDonateTroopTBD2 = 0, $g_hLblDonateTroopTBD3 = 0, _
	   $g_hLblDonateTroopCustomC = 0, $g_hLblDonateTroopCustomD = 0, $g_hLblDonateTroopCustomF = 0, $g_hLblDonateTroopCustomG = 0, $g_hLblDonateTroopCustomH = 0, _
	   $g_hLblDonateTroopCustomI = 0, $g_hLblDonateTroopCustomJ = 0, $g_hLblDonateSpellTBD1 = 0

Global $g_hGrpDonateGeneralBlacklist = 0, $g_hTxtGeneralBlacklist = 0
Global $lblBtnCustomE = 0

; Schedule
Global $g_hChkDonateHoursEnable = 0, $g_ahChkDonateHours[24] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
Global $g_hCmbFilterDonationsCC = 0, $g_hChkSkipDonateNearFullTroopsEnable = 0
Global $g_hLblDonateHours1 = 0, $g_hLblDonateHoursPM = 0
Global $g_hLblSkipDonateNearFullTroopsText = 0, $g_hTxtSkipDonateNearFullTroopsPercentage = 0, $g_hLblSkipDonateNearFullTroopsText1 = 0

Global $g_hGrpDonateCC = 0, $g_ahChkDonateHoursE1 = 0, $g_ahChkDonateHoursE2 = 0

Global $g_hGUI_RequestCC = 0, $g_hGUI_DONATECC = 0, $g_hGUI_ScheduleCC = 0
Global $g_hGrpDonate = 0, $g_hChkDonate = 1, $g_hLblDonateDisabled = 0, $g_hLblScheduleDisabled = 0

Func CreateVillageDonate()
   $g_hGUI_DONATE = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_VILLAGE)
   ;GUISetBkColor($COLOR_WHITE, $g_hGUI_DONATE)
	Local $x = 82
	$g_hChkDonate = GUICtrlCreateCheckbox("", $x + 131, 6, 13, 13)
		GUICtrlSetState(-1,$GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "Doncheck")
		CreateRequestSubTab()
		CreateDonateSubTab()
		CreateScheduleSubTab()
	GUISwitch($g_hGUI_DONATE)

	$g_hGUI_DONATE_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_DONATE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,11,"Request Troops"))
	$g_hGUI_DONATE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,12,"Donate Troops") & "    ")
	$g_hLblDonateDisabled = GUICtrlCreateLabel(GetTranslated(612, 1, "Note: Donate is disabled, tick the checkmark on the") & " " & GetTranslated(600, 12, -1) & " " & GetTranslated(600, 50, -1), 5, 30, 430, 374)
		GUICtrlSetState(-1, $GUI_HIDE)
	$g_hGUI_DONATE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600,13,"Schedule Donations"))
 	$g_hLblScheduleDisabled = GUICtrlCreateLabel(GetTranslated(612, 1, -1) & " " & GetTranslated(600, 12, -1) & " " & GetTranslated(600, 50, -1), 5, 30, 430, 374)
		GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlCreateTabItem("")
EndFunc

#Region CreateRequestSubTab
Func CreateRequestSubTab()
	Local $xStart = 25, $yStart = 45
	$g_hGUI_RequestCC = GUICreate("", $_GUI_MAIN_WIDTH - 30 - 10, $_GUI_MAIN_HEIGHT - 255 - 30 - 30, $xStart - 20, $yStart - 20, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DONATE)
	GUISetBkColor($COLOR_WHITE)
	Local $xStart = 20, $yStart = 20
	Local $x = $xStart
	Local $y = $yStart
	$g_hGrpRequestCC = GUICtrlCreateGroup(GetTranslated(611,1, "Clan Castle Troops"), $x - 20, $y - 20, 430, 375)
		$y += 10
		$x += 10
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnCCRequest, $x - 5, $y, 64, 64, $BS_ICON)
		$g_hChkRequestTroopsEnable = GUICtrlCreateCheckbox(GetTranslated(611,2, "Request Troops / Spells"), $x+40+30, $y-6)
			GUICtrlSetOnEvent(-1, "chkRequestCCHours")
		$g_hTxtRequestCC = GUICtrlCreateInput(GetTranslated(611,3, "Anything please"), $x +40+30 , $y + 15, 214, 20,  BitOR($SS_CENTER, $ES_AUTOHSCROLL))
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslated(611,4, "This text is used on your request for troops in the Clan chat."))

		$x += 29 + 30
		$y += 60
		GUICtrlCreateLabel(GetTranslated(603,30,"Only during these hours of day"), $x + 30, $y, 300, 20, $BS_MULTILINE)

		$x += 30
		$y += 25
		$g_ahLblRequestCCHours0 = GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel("X", $x + 213, $y+2, 11, 11)
		GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 15
		$g_ahChkRequestCCHours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_hChkRequestCCHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		   GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		   GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
		   _GUICtrlSetTip(-1, GetTranslated(603,2, "This button will clear or set the entire row of boxes"))
		   GUICtrlSetOnEvent(-1, "chkRequestCCHoursE1")
		$g_hLblRequestCCHoursAM = GUICtrlCreateLabel(GetTranslated(603,3, "AM"), $x + 5, $y)
		GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 15
		$g_ahChkRequestCCHours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_ahChkRequestCCHours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
		$g_hChkRequestCCHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		   GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		   GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
		   _GUICtrlSetTip(-1, GetTranslated(603,2, -1))
		   GUICtrlSetOnEvent(-1, "chkRequestCCHoursE2")
		$g_hLblRequestCCHoursPM = GUICtrlCreateLabel(GetTranslated(603,4, "PM"), $x + 5, $y)
		 GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
#EndRegion

#Region CreateDonateSubTab
Func CreateDonateSubTab()
	Local $xStart = 25, $yStart = 45
	$g_hGUI_DONATECC = GUICreate("", $_GUI_MAIN_WIDTH - 30 - 10, $_GUI_MAIN_HEIGHT - 255 - 30 - 30, $xStart - 20, $yStart - 20, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DONATE)
	GUISetBkColor($COLOR_WHITE)
	Local $xStart = 20, $yStart = 20
  ;~ -------------------------------------------------------------
   ;~ Language Variables used a lot
   ;~ -------------------------------------------------------------

   Local $sTxtBlacklist1 = GetTranslated(612,23, "Blacklist")
   Local $sDonateTxtCustomA = GetTranslated(612,24, "Custom Troops")
   Local $sDonateTxtCustomB = GetTranslated(612,24, -1)

   Local $sTxtNothing = GetTranslated(603,1, "Nothing")

   Local $sTxtDonate = GetTranslated(612,27, "Donate")
   Local $sTxtDonateTip = GetTranslated(612,28, "Check this to donate")
   Local $sTxtDonateAll = GetTranslated(612,29, "Donate to All")
   Local $sTxtIgnoreAll = GetTranslated(612,31, "This will also ignore ALL keywords.")
   Local $sTxtKeywords = GetTranslated(612,32, "Keywords for donating")
   Local $sTxtKeywordsNo = GetTranslated(612,33, "Do NOT donate to these keywords")
   Local $sTxtKeywordsNoTip = GetTranslated(612,34, "Blacklist for donating")
   Local $sTxtDonateTipTroop = GetTranslated(612,81, "if keywords match the Chat Request.")
   Local $sTxtDonateTipAll = GetTranslated(612,82, "to ALL Chat Requests.")

   Local $sTxtBarbarians = GetTranslated(604,1, "Barbarians")
   Local $sTxtArchers = GetTranslated(604,2, "Archers")
   Local $sTxtGiants = GetTranslated(604,3, "Giants")
   Local $sTxtGoblins = GetTranslated(604,4, "Goblins")
   Local $sTxtWallBreakers = GetTranslated(604,5, "Wall Breakers")
   Local $sTxtBalloons = GetTranslated(604,7, "Balloons")
   Local $sTxtWizards = GetTranslated(604,8, "Wizards")
   Local $sTxtHealers = GetTranslated(604,9, "Healers")
   Local $sTxtDragons = GetTranslated(604,10, "Dragons")
   Local $sTxtPekkas = GetTranslated(604,11, "Pekkas")
   Local $sTxtMinions = GetTranslated(604,13, "Minions")
   Local $sTxtHogRiders = GetTranslated(604,14, "Hog Riders")
   Local $sTxtValkyries = GetTranslated(604,15, "Valkyries")
   Local $sTxtGolems = GetTranslated(604,16, "Golems")
   Local $sTxtWitches = GetTranslated(604,17, "Witches")
   Local $sTxtLavaHounds = GetTranslated(604,18, "Lava Hounds")
   Local $sTxtBowlers = GetTranslated(604, 19, "Bowlers")
   Local $sTxtBabyDragons = GetTranslated(604,20, "Baby Dragons")
   Local $sTxtMiners = GetTranslated(604,21, "Miners")

   Local $sTxtLightningSpells = GetTranslated(605,15,"Lightning")
   Local $sTxtHealSpells = GetTranslated(605,16,"Heal")
   Local $sTxtRageSpells = GetTranslated(605,17,"Rage")
   Local $sTxtJumpSpells = GetTranslated(605,18,"Jump")
   Local $sTxtFreezeSpells = GetTranslated(605,19,"Freeze")
   Local $sTxtPoisonSpells = GetTranslated(605,9, "Poison")
   Local $sTxtEarthquakeSpells = GetTranslated(605,10, "EarthQuake")
   Local $sTxtHasteSpells = GetTranslated(605,11, "Haste")
   Local $sTxtSkeletonSpells = GetTranslated(605,14, "Skeleton")

	Local $x = $xStart
	Local $y = $yStart
   Local $Offx = 38
   GUICtrlCreateGroup(GetTranslated(612,22, "Donate Troops Selection Menu"), $x - 20, $y - 20, 430, 185)
		$x = $xStart - 18
		  $g_ahLblDonateTroop[$eTroopBarbarian] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopBarbarian] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBarbarian, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopArcher] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopArcher] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnArcher, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopGiant] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopGiant] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGiant, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopGoblin] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopGoblin] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoblin, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopWallBreaker] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopWallBreaker] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnWallBreaker, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopBalloon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopBalloon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBalloon, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")

	  $x += $Offx
	  $x += 4
		  $g_ahLblDonateTroop[$eTroopMinion] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopMinion] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnMinion, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopHogRider] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopHogRider] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnHogRider, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopValkyrie] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopValkyrie] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnValkyrie, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopGolem] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopGolem] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnGolem, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopWitch] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopWitch] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnWitch, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")

		$x = $xStart - 18
	  $y += 40
		  $g_ahLblDonateTroop[$eTroopWizard] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopWizard] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnWizard, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopHealer] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopHealer] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnHealer, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopDragon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopDragon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDragon, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopPekka] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopPekka] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnPekka, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopBabyDragon] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopBabyDragon] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnBabyDragon, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopMiner] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopMiner] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnMiner, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")

	  $x += $Offx
	  $x += 4
		  $g_ahLblDonateTroop[$eTroopLavaHound] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopLavaHound] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnLavaHound, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_ahLblDonateTroop[$eTroopBowler] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eTroopBowler] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnBowler, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")

	  $x += $Offx
		  $g_hLblDonateTroopTBD1 = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetState(-1, $GUI_DISABLE)
	  ;		GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnTroops, 0)
	  ;		GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_hLblDonateTroopTBD2 = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetState(-1, $GUI_DISABLE)
	  ;		GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnTroops, 0)
	  ;		GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  $g_hLblDonateTroopTBD3 = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetState(-1, $GUI_DISABLE)
	  ;		GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnTroops, 0)
	  ;		GUICtrlSetOnEvent(-1, "btnDonateTroop")

		$x = $xStart - 18
	  $y += 40
		  $g_ahLblDonateSpell[$eSpellLightning] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateSpell[$eSpellLightning] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnLightSpell, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateSpell")
	  $x += $Offx
		  $g_ahLblDonateSpell[$eSpellHeal] = GUICtrlCreateLabel("", $x , $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateSpell[$eSpellHeal] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnHealSpell, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateSpell")
	  $x += $Offx
		  $g_ahLblDonateSpell[$eSpellRage] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateSpell[$eSpellRage] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnRageSpell, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateSpell")
	  $x += $Offx
		  $g_ahLblDonateSpell[$eSpellJump] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateSpell[$eSpellJump] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnJumpSpell, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateSpell")
	  $x += $Offx
		  $g_ahLblDonateSpell[$eSpellFreeze] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateSpell[$eSpellFreeze] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnFreezeSpell, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateSpell")
	  $x += $Offx
	  ; Button Not Active - future expansion?
		  $lblBtnCustomE = GUICtrlCreateLabel("", $x + 2, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetState(-1, $GUI_DISABLE)
	  ;		GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnTroops, 0)
	  ;		GUICtrlSetOnEvent(-1, "btnDonateCustomE")

	  $x += 4
	  $x += $Offx
		  $g_ahLblDonateSpell[$eSpellPoison] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateSpell[$eSpellPoison] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnPoisonSpell, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateSpell")
	  $x += $Offx
		  $g_ahLblDonateSpell[$eSpellEarthquake] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateSpell[$eSpellEarthquake] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnEarthQuakeSpell, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateSpell")
	  $x += $Offx
		  $g_ahLblDonateSpell[$eSpellHaste] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateSpell[$eSpellHaste] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnHasteSpell, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateSpell")
	  $x += $Offx
		  $g_ahLblDonateSpell[$eSpellSkeleton] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateSpell[$eSpellSkeleton] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnSkeletonSpell, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateSpell")
	   $x += $Offx
			  ; Button Not Active - future expansion?
		  $g_hLblDonateSpellTBD1 = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetState(-1, $GUI_DISABLE)
	  ;		GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnTroops, 0)
	  ;		GUICtrlSetOnEvent(-1, "btnDonateNameOfSpell")

		$x = $xStart - 18
	  $y += 40
		  GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_DISABLE)
			  ;GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnDonBlacklist, 1)
			  ;GUICtrlSetOnEvent(-1, "btnDonateBlacklist")
	  $x += $Offx
	  ; Button Not Active - future expansion?
		  $g_hLblDonateTroopCustomF = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetState(-1, $GUI_DISABLE)
	  ;		GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnTroops, 0)
	  ;		GUICtrlSetOnEvent(-1, "btnDonateCustomF")
	  $x += $Offx
		  ; Button Not Active - future expansion?
		  $g_hLblDonateTroopCustomG = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_DISABLE)
			 ; GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnDonCustom, 1)
			  ;GUICtrlSetOnEvent(-1, "btnDonateCustomG")
	  $x += $Offx
		  ; Button Not Active - future expansion?
		  $g_hLblDonateTroopCustomH = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_DISABLE)
			  ;GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnDonCustomB, 1)
			  ;GUICtrlSetOnEvent(-1, "btnDonateCustomH")
	  $x += $Offx
	  ; Button Not Active - future expansion?
		  $g_hLblDonateTroopCustomI = GUICtrlCreateLabel("", $x , $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetState(-1, $GUI_DISABLE)
	  ;		GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnTroops, 0)
	  ;		GUICtrlSetOnEvent(-1, "btnDonateCustomI")
	  $x += $Offx
	  ; Button Not Active - future expansion?
		  $g_hLblDonateTroopCustomJ = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		   GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetState(-1, $GUI_DISABLE)
	  ;		GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnTroops, 0)
	  ;		GUICtrlSetOnEvent(-1, "btnDonateCustomJ")

	  $x += 4
	   $x += $Offx
		  ;;; Custom Combination Donate by ChiefM3, edit my MonkeyHunter
		  $g_ahLblDonateTroop[$eCustomA] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)
		  $g_ahBtnDonateTroop[$eCustomA] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnDonCustom, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")
	  $x += $Offx
		  ;;; Custom Combination Donate #2 added by MonkeyHunter
		  $g_ahLblDonateTroop[$eCustomB] = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)

		  $g_ahBtnDonateTroop[$eCustomB] = GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnDonCustomB, 1)
			  GUICtrlSetOnEvent(-1, "btnDonateTroop")

	  $x += $Offx
	  ; Button Not Active - future expansion?
		  $g_hLblDonateTroopCustomC = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)

		  GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetState(-1, $GUI_DISABLE)
	  ;		GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnTroops, 0)
	  ;		GUICtrlSetOnEvent(-1, "btnDonateCustomC")

	  $x += $Offx
	  ; Button Not Active - future expansion?
		  $g_hLblDonateTroopCustomD = GUICtrlCreateLabel("", $x, $y - 2, $Offx + 2, $Offx + 2)
			  GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			  GUICtrlSetState(-1, $GUI_DISABLE)

		  GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
			  GUICtrlSetState(-1, $GUI_DISABLE)
	  ;		GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnTroops, 0)
	  ;		GUICtrlSetOnEvent(-1, "btnDonateCustomD")
      $x += $Offx
	   GUICtrlCreateButton("", $x + 2, $y, $Offx - 2, $Offx - 2, $BS_ICON)
		   GUICtrlSetImage (-1, $g_sLibIconPath, $eIcnDonBlacklist, 1)
		   GUICtrlSetOnEvent(-1, "btnDonateBlacklist")

	   Local $Offy = $yStart + 185
	   $x = $xStart
	   $y = $yStart + 185
	   GUICtrlCreateLabel(GetTranslated(612,115, "Extra Alphabet Recognitions:"), $x - 15, $y + 153, -1, -1)
	   $g_hChkExtraAlphabets = GUICtrlCreateCheckbox(GetTranslated(612,25, "Cyrillic"), $x + 127 , $y + 149, -1, -1)
	   _GUICtrlSetTip(-1, GetTranslated(612,26, "Check this to enable the Cyrillic Alphabet."))
	   $g_hChkExtraChinese = GUICtrlCreateCheckbox(GetTranslated(612,103, "Chinese"), $x + 221, $y + 149, -1, -1)
	   _GUICtrlSetTip(-1, GetTranslated(612,104, "Check this to enable the Chinese Alphabet."))
	   $g_hChkExtraKorean = GUICtrlCreateCheckbox(GetTranslated(612,116, "Korean"), $x + 315, $y + 149, -1, -1)
	   _GUICtrlSetTip(-1, GetTranslated(612,117, "Check this to enable the Korean Alphabet."))
    GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_ahGrpDonateTroop[$eTroopBarbarian] = GUICtrlCreateGroup($sTxtBarbarians, $x - 20, $y - 20, 430, 169)
		$x -= 10
		$y -= 4
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBarbarian, $x + 215, $y, 64, 64, $BS_ICON)
		$g_ahChkDonateTroop[$eTroopBarbarian] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBarbarians, $x + 285, $y + 10, -1, -1)
			_GUICtrlSetTip(-1,  $sTxtDonateTip & " " & $sTxtBarbarians & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopBarbarian] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			_GUICtrlSetTip(-1,  $sTxtDonateTip & " " & $sTxtBarbarians & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBarbarians & ":", $x - 5, $y + 5, -1, -1)
		$g_ahTxtDonateTroop[$eTroopBarbarian] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,35, "barbarians\r\nbarb")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBarbarians)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
		$g_ahTxtBlacklistTroop[$eTroopBarbarian] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,36, "no barbarians\r\nno barb\r\nbarbarians no\r\nbarb no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBarbarians)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopArcher] = GUICtrlCreateGroup($sTxtArchers, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonArcher, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopArcher] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtArchers, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtArchers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopArcher] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtArchers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtArchers & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopArcher] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,37, "archers\r\narch")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtArchers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopArcher] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,38, "no archers\r\nno arch\r\narchers no\r\narch no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtArchers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopGiant] = GUICtrlCreateGroup($sTxtGiants, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonGiant, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopGiant] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtGiants, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGiants & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopGiant] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGiants & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtGiants & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopGiant] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,39, "giants\r\ngiant\r\nany\r\nreinforcement")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtGiants)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopGiant] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,40, "no giants\r\ngiants no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtGiants)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopGoblin] = GUICtrlCreateGroup($sTxtGoblins, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonGoblin, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopGoblin] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtGoblins, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGoblins & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopGoblin] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGoblins & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtGoblins & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopGoblin] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,41, "goblins\r\ngoblin")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtGoblins)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopGoblin] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,42, "no goblins\r\ngoblins no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtGoblins)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopWallBreaker] = GUICtrlCreateGroup($sTxtWallBreakers, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWallBreaker, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopWallBreaker] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtWallBreakers, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWallBreakers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopWallBreaker] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWallBreakers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtWallBreakers & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopWallBreaker] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,43, "wall breakers\r\nbreaker")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtWallBreakers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopWallBreaker] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,44, "no wall breakers\r\nwall breakers no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtWallBreakers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopBalloon] = GUICtrlCreateGroup($sTxtBalloons, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBalloon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopBalloon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBalloons, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBalloons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopBalloon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBalloons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBalloons & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopBalloon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,45, "balloons\r\nballoon")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBalloons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopBalloon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,46, "no balloon\r\nballoons no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBalloons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopWizard] = GUICtrlCreateGroup($sTxtWizards, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWizard, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopWizard] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtWizards, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWizards & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopWizard] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWizards & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtWizards & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopWizard] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,47, "wizards\r\nwizard\r\nwiz")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtWizards)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopWizard] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,48, "no wizards\r\nwizards no\r\nno wizard\r\nwizard no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtWizards)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopHealer] = GUICtrlCreateGroup($sTxtHealers, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonHealer, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopHealer] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtHealers, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHealers & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopHealer] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHealers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtHealers & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopHealer] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,49, "healer")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtHealers)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopHealer] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,50, "no healer\r\nhealer no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtHealers)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopDragon] = GUICtrlCreateGroup($sTxtDragons, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonDragon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopDragon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtDragons, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtDragons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopDragon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtDragons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtDragons & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopDragon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,51, "dragon")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtDragons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopDragon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,52, "no dragon\r\ndragon no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtDragons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopPekka] = GUICtrlCreateGroup($sTxtPekkas, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonPekka, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopPekka] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtPekkas, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtPekkas & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopPekka] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtPekkas & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtPekkas & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopPekka] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,53, "PEKKA\r\npekka")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtPekkas)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopPekka] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,54, "no PEKKA\r\npekka no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtPekkas)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopBabyDragon] = GUICtrlCreateGroup($sTxtBabyDragons, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBabyDragon, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopBabyDragon] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBabyDragons, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBabyDragons & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopBabyDragon] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBabyDragons & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBabyDragons & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopBabyDragon] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,95, "baby dragon\r\nbaby")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBabyDragons)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopBabyDragon] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,96, "no baby dragon\r\nbaby dragon no\r\nno baby\r\nbaby no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBabyDragons)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateTroop[$eTroopMiner] = GUICtrlCreateGroup($sTxtMiners, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonMiner, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateTroop[$eTroopMiner] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtMiners, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtMiners & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateTroop")
		$g_ahChkDonateAllTroop[$eTroopMiner] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtMiners & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtMiners & ":", $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateTroop[$eTroopMiner] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,97, "miner|mine")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtMiners)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistTroop[$eTroopMiner] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,98, "no miner\r\nminer no\r\nno mine\r\nmine no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtMiners)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellLightning] = GUICtrlCreateGroup($sTxtLightningSpells, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellLightning] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtLightningSpells, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtLightningSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellLightning] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtLightningSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtLightningSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellLightning] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,105, "lightning")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtLightningSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellLightning] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,106, "no lightning\r\nlightning no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtLightningSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellHeal] = GUICtrlCreateGroup($sTxtHealSpells, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellHeal] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtHealSpells, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHealSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellHeal] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHealSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		 GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtHealSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellHeal] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,107, "heal")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtHealSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellHeal] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,108, "no heal\r\nheal no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtHealSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellRage] = GUICtrlCreateGroup($sTxtRageSpells, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellRage] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtRageSpells, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtRageSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellRage] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtRageSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtRageSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellRage] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,109, "rage")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtRageSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellRage] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,110, "no rage\r\nrage no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtRageSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellJump] = GUICtrlCreateGroup($sTxtJumpSpells, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellJump] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtJumpSpells, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtJumpSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellJump] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtJumpSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtJumpSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellJump] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,111, "jump")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtJumpSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellJump] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,112, "no jump\r\njump no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtJumpSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $Offy
	$g_ahGrpDonateSpell[$eSpellFreeze] = GUICtrlCreateGroup($sTxtFreezeSpells, $x - 20, $y - 20, 430, 169)
	$x -= 10
	$y -= 4
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x + 215, $y, 64, 64, $BS_ICON)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahChkDonateSpell[$eSpellFreeze] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtFreezeSpells, $x + 285, $y + 10, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtFreezeSpells & " " & $sTxtDonateTipTroop)
			GUICtrlSetOnEvent(-1, "chkDonateSpell")
		$g_ahChkDonateAllSpell[$eSpellFreeze] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtFreezeSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtFreezeSpells & ":" , $x - 5, $y + 5, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtDonateSpell[$eSpellFreeze] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,113, "freeze")))
			_GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtFreezeSpells)
		GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahTxtBlacklistSpell[$eSpellFreeze] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetBkColor ( -1, 0x505050)
			GUICtrlSetColor ( -1, $COLOR_WHITE)
			GUICtrlSetData(-1, StringFormat(GetTranslated(612,114, "no freeze\r\nfreeze no")))
			_GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtFreezeSpells)
	GUICtrlCreateGroup("", -99, -99, 1, 1)



	   $x = $xStart
	   $y = $Offy
	   $g_ahGrpDonateTroop[$eTroopMinion] = GUICtrlCreateGroup($sTxtMinions, $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 4
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonMinion, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahChkDonateTroop[$eTroopMinion] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtMinions, $x + 285, $y + 10, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtMinions & " " & $sTxtDonateTipTroop)
			   GUICtrlSetOnEvent(-1, "chkDonateTroop")
		   $g_ahChkDonateAllTroop[$eTroopMinion] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtMinions & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			   GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		   GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtMinions & ":", $x - 5, $y + 5, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateTroop[$eTroopMinion] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,55, "minions\r\nminion")))
			   _GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtMinions)
		   GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtBlacklistTroop[$eTroopMinion] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,56, "no minions\r\nminions no\r\nno minion\r\nminion no")))
			   _GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtMinions)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart
	   $y = $Offy
	   $g_ahGrpDonateTroop[$eTroopHogRider] = GUICtrlCreateGroup($sTxtHogRiders, $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 4
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonHogRider, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahChkDonateTroop[$eTroopHogRider] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtHogRiders, $x + 285, $y + 10, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHogRiders & " " & $sTxtDonateTipTroop)
			   GUICtrlSetOnEvent(-1, "chkDonateTroop")
		   $g_ahChkDonateAllTroop[$eTroopHogRider] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " &  $sTxtHogRiders & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			   GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		   GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtHogRiders & ":", $x - 5, $y + 5, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateTroop[$eTroopHogRider] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,57, "hogriders\r\nhogs\r\nhog")))
			   _GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtHogRiders)
		   GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtBlacklistTroop[$eTroopHogRider] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,58, "no hogs\r\nhog no")))
			   _GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtHogRiders)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart
	   $y = $Offy
	   $g_ahGrpDonateTroop[$eTroopValkyrie] = GUICtrlCreateGroup($sTxtValkyries, $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 4
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonValkyrie, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahChkDonateTroop[$eTroopValkyrie] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtValkyries, $x + 285, $y + 10, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtValkyries & " " & $sTxtDonateTipTroop)
			   GUICtrlSetOnEvent(-1, "chkDonateTroop")
		   $g_ahChkDonateAllTroop[$eTroopValkyrie] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtValkyries & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			   GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		   GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtValkyries & ":", $x - 5, $y + 5, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateTroop[$eTroopValkyrie] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,59, "valkyries\r\nvalkyrie\r\nvalk")))
			   _GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtValkyries)
		   GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtBlacklistTroop[$eTroopValkyrie] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,60, "no valkyries\r\nvalkyries no\r\nno valk\r\nvalk no")))
			   _GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtValkyries)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart
	   $y = $Offy
	   $g_ahGrpDonateTroop[$eTroopGolem] = GUICtrlCreateGroup($sTxtGolems, $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 4
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonGolem, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahChkDonateTroop[$eTroopGolem] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtGolems, $x + 285, $y + 10, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGolems & " " & $sTxtDonateTipTroop)
			   GUICtrlSetOnEvent(-1, "chkDonateTroop")
		   $g_ahChkDonateAllTroop[$eTroopGolem] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtGolems & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			   GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		   GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtGolems & ":", $x - 5, $y + 5, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateTroop[$eTroopGolem] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,61, "golem")))
			   _GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtGolems)
		   GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtBlacklistTroop[$eTroopGolem] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,62, "no golem\r\ngolem no")))
			   _GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtGolems)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart
	   $y = $Offy
	   $g_ahGrpDonateTroop[$eTroopWitch] = GUICtrlCreateGroup($sTxtWitches, $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 4
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWitch, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahChkDonateTroop[$eTroopWitch] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtWitches, $x + 285, $y + 10, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWitches & " " & $sTxtDonateTipTroop)
			   GUICtrlSetOnEvent(-1, "chkDonateTroop")
		   $g_ahChkDonateAllTroop[$eTroopWitch] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtWitches & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			   GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		   GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtWitches & ":", $x - 5, $y + 5, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateTroop[$eTroopWitch] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,63, "witches\r\nwitch")))
			   _GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtWitches)
		   GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtBlacklistTroop[$eTroopWitch] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,64, "no witches\r\nwitch no")))
			   _GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtWitches)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart
	   $y = $Offy
	   $g_ahGrpDonateTroop[$eTroopLavaHound] = GUICtrlCreateGroup($sTxtLavaHounds, $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 4
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonLavaHound, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahChkDonateTroop[$eTroopLavaHound] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtLavaHounds, $x + 285, $y + 10, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtLavaHounds & " " & $sTxtDonateTipTroop)
			   GUICtrlSetOnEvent(-1, "chkDonateTroop")
		   $g_ahChkDonateAllTroop[$eTroopLavaHound] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtLavaHounds & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			   GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		   GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtLavaHounds & ":" , $x - 5, $y + 5, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateTroop[$eTroopLavaHound] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,65, "lavahound\r\nlava\r\nhound")))
			   _GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtLavaHounds)
		   GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtBlacklistTroop[$eTroopLavaHound] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,66, "no lavahound\r\nlava no\r\nhound no")))
			   _GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtLavaHounds)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart
	   $y = $Offy
	   $g_ahGrpDonateTroop[$eTroopBowler] = GUICtrlCreateGroup($sTxtBowlers, $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 4
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBowler, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahChkDonateTroop[$eTroopBowler] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtBowlers, $x + 285, $y + 10, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBowlers & " " & $sTxtDonateTipTroop)
			   GUICtrlSetOnEvent(-1, "chkDonateTroop")
		   $g_ahChkDonateAllTroop[$eTroopBowler] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtBowlers & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			   GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		   GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtBowlers & ":" , $x - 5, $y + 5, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateTroop[$eTroopBowler] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,93, "bowler\r\nbowlers\r\nbowl")))
			   _GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtBowlers)
		   GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtBlacklistTroop[$eTroopBowler] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,94, "no bowler\r\nbowl no")))
			   _GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtBowlers)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart
	   $y = $Offy
	   $g_ahGrpDonateSpell[$eSpellPoison] = GUICtrlCreateGroup($sTxtPoisonSpells, $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 4
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonPoisonSpell, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahChkDonateSpell[$eSpellPoison] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtPoisonSpells, $x + 285, $y + 10, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtPoisonSpells & " " & $sTxtDonateTipTroop)
			   GUICtrlSetOnEvent(-1, "chkDonateSpell")
		   $g_ahChkDonateAllSpell[$eSpellPoison] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtPoisonSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			   GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		   GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtPoisonSpells & ":" , $x - 5, $y + 5, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateSpell[$eSpellPoison] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,87, "poison")))
			   _GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtPoisonSpells)
		   GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtBlacklistSpell[$eSpellPoison] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,88, "no poison\r\npoison no")))
			   _GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtPoisonSpells)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart
	   $y = $Offy
	   $g_ahGrpDonateSpell[$eSpellEarthquake] = GUICtrlCreateGroup($sTxtEarthQuakeSpells, $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 4
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonEarthQuakeSpell, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahChkDonateSpell[$eSpellEarthquake] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtEarthQuakeSpells, $x + 285, $y + 10, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtEarthQuakeSpells & " " & $sTxtDonateTipTroop)
			   GUICtrlSetOnEvent(-1, "chkDonateSpell")
		   $g_ahChkDonateAllSpell[$eSpellEarthquake] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtEarthQuakeSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			   GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		   GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtEarthQuakeSpells & ":" , $x - 5, $y + 5, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateSpell[$eSpellEarthquake] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,89, "earthquake\r\nquake")))
			   _GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtEarthQuakeSpells)
		   GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtBlacklistSpell[$eSpellEarthquake] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,90, "no earthquake\r\nquake no")))
			   _GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtEarthQuakeSpells)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart
	   $y = $Offy
	   $g_ahGrpDonateSpell[$eSpellHaste] = GUICtrlCreateGroup($sTxtHasteSpells, $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 4
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonHasteSpell, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahChkDonateSpell[$eSpellHaste] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtHasteSpells, $x + 285, $y + 10, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHasteSpells & " " & $sTxtDonateTipTroop)
			   GUICtrlSetOnEvent(-1, "chkDonateSpell")
		   $g_ahChkDonateAllSpell[$eSpellHaste] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtHasteSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			   GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		   GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtHasteSpells & ":" , $x - 5, $y + 5, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateSpell[$eSpellHaste] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,91, "haste")))
			   _GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtHasteSpells)
		   GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtBlacklistSpell[$eSpellHaste] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,92, "no haste\r\nhaste no")))
			   _GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtHasteSpells)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart
	   $y = $Offy
	   $g_ahGrpDonateSpell[$eSpellSkeleton] = GUICtrlCreateGroup($sTxtSkeletonSpells, $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 4
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonSkeletonSpell, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahChkDonateSpell[$eSpellSkeleton] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sTxtSkeletonSpells, $x + 285, $y + 10, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSkeletonSpells & " " & $sTxtDonateTipTroop)
			   GUICtrlSetOnEvent(-1, "chkDonateSpell")
		   $g_ahChkDonateAllSpell[$eSpellSkeleton] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sTxtSkeletonSpells & " " & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			   GUICtrlSetOnEvent(-1, "chkDonateAllSpell")
		   GUICtrlCreateLabel($sTxtKeywords & " " & $sTxtSkeletonSpells & ":" , $x - 5, $y + 5, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateSpell[$eSpellSkeleton] = GUICtrlCreateEdit("", $x - 5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,99, "skeleton|skel")))
			   _GUICtrlSetTip(-1, $sTxtKeywords & " " & $sTxtSkeletonSpells)
		   GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 70, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtBlacklistSpell[$eSpellSkeleton] = GUICtrlCreateEdit("", $x + 215, $y + 85, 200, 60, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,100, "no skeleton\r\nskeleton no\r\nno skel")))
			   _GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sTxtSkeletonSpells)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart
	   $y = $Offy
	  ;;; Custom Combination Donate by ChiefM3, edit by Hervidero
	   $g_ahGrpDonateTroop[$eCustomA] = GUICtrlCreateGroup($sDonateTxtCustomA, $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 2
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonCustom, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahChkDonateTroop[$eCustomA] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sDonateTxtCustomA, $x + 285, $y + 10, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomA & " " & $sTxtDonateTipTroop)
			   GUICtrlSetOnEvent(-1, "chkDonateTroop")
		   $g_ahChkDonateAllTroop[$eCustomA] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomA & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			   GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		   GUICtrlCreateLabel($sTxtKeywords & " " & $sDonateTxtCustomA & ":", $x - 5, $y + 80, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateTroop[$eCustomA] = GUICtrlCreateEdit("", $x - 5, $y + 95, 205, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,71, "ground support\r\nground")))
			   _GUICtrlSetTip(-1, $sTxtKeywords & " " & $sDonateTxtCustomA)

		   GUICtrlCreateLabel(GetTranslated(612,72, "1st") & ":", $x, $y + 4, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahPicDonateCustomA[0] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonWizard, $x + 25, $y, 24, 24)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahCmbDonateCustomA[0] = GUICtrlCreateCombo("", $x + 60, $y, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds & "|" & $sTxtBowlers & "|" & $sTxtNothing, $sTxtWizards)
			   GUICtrlSetOnEvent(-1, "cmbDonateCustomA")
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateCustomA[0] = GUICtrlCreateInput("2", $x + 165, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   GUICtrlSetLimit(-1, 1)
			   GUICtrlSetState(-1, $GUI_HIDE)

		   GUICtrlCreateLabel(GetTranslated(612,73, "2nd") & ":", $x, $y + 29, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahPicDonateCustomA[1] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonArcher, $x + 25, $y + 25, 24, 24)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahCmbDonateCustomA[1] = GUICtrlCreateCombo("", $x + 60, $y + 25, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds & "|" & $sTxtBowlers & "|" & $sTxtNothing, $sTxtArchers)
			   GUICtrlSetOnEvent(-1, "cmbDonateCustomA")
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateCustomA[1] = GUICtrlCreateInput("3", $x + 165, $y + 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   GUICtrlSetLimit(-1, 1)
			   GUICtrlSetState(-1, $GUI_HIDE)

		   GUICtrlCreateLabel(GetTranslated(612,74, "3rd") & ":", $x, $y + 54, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahPicDonateCustomA[2] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBarbarian, $x + 25, $y + 50, 24, 24)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahCmbDonateCustomA[2] = GUICtrlCreateCombo("", $x + 60, $y + 50, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds & "|" & $sTxtBowlers & "|" & $sTxtNothing, $sTxtBarbarians)
			   GUICtrlSetOnEvent(-1, "cmbDonateCustomA")
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateCustomA[2] = GUICtrlCreateInput("1", $x + 165, $y + 50, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   GUICtrlSetLimit(-1, 1)
			   GUICtrlSetState(-1, $GUI_HIDE)

		   GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 80, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtBlacklistTroop[$eCustomA] = GUICtrlCreateEdit("", $x + 215, $y + 95, 200, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,76, "no ground\r\nground no\r\nonly")))
			   _GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sDonateTxtCustomA)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart
	   $y = $Offy
   ;;; Custom Combination Donate added by MonkeyHunter
	   $g_ahGrpDonateTroop[$eCustomB] = GUICtrlCreateGroup($sDonateTxtCustomB, $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 2
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonCustomB, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahChkDonateTroop[$eCustomB] = GUICtrlCreateCheckbox($sTxtDonate & " " & $sDonateTxtCustomB, $x + 285, $y + 10, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomB & " " & $sTxtDonateTipTroop)
			   GUICtrlSetOnEvent(-1, "chkDonateTroop")
		   $g_ahChkDonateAllTroop[$eCustomB] = GUICtrlCreateCheckbox($sTxtDonateAll, $x + 285, $y + 30, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
			   _GUICtrlSetTip(-1, $sTxtDonateTip & " " & $sDonateTxtCustomB & $sTxtDonateTipAll & @CRLF & $sTxtIgnoreAll)
			   GUICtrlSetOnEvent(-1, "chkDonateAllTroop")
		   GUICtrlCreateLabel($sTxtKeywords & " " & $sDonateTxtCustomB & ":", $x - 5, $y + 80, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateTroop[$eCustomB] = GUICtrlCreateEdit("", $x - 5, $y + 95, 205, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,101, "air support\r\nany air")))
			   _GUICtrlSetTip(-1, $sTxtKeywords & " " & $sDonateTxtCustomB)

		   GUICtrlCreateLabel(GetTranslated(612,72, "1st") & ":", $x, $y + 4, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahPicDonateCustomB[0] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBabyDragon, $x + 25, $y, 24, 24)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahCmbDonateCustomB[0] = GUICtrlCreateCombo("", $x + 60, $y, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds & "|" & $sTxtBowlers & "|" & $sTxtNothing, $sTxtBabyDragons)
			   GUICtrlSetOnEvent(-1, "cmbDonateCustomB")
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateCustomB[0] = GUICtrlCreateInput("1", $x + 165, $y, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   GUICtrlSetLimit(-1, 1)
			   GUICtrlSetState(-1, $GUI_HIDE)

		   GUICtrlCreateLabel(GetTranslated(612,73, "2nd") & ":", $x, $y + 29, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahPicDonateCustomB[1] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBalloon, $x + 25, $y + 25, 24, 24)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahCmbDonateCustomB[1] = GUICtrlCreateCombo("", $x + 60, $y + 25, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds & "|" & $sTxtBowlers & "|" & $sTxtNothing, $sTxtBalloons)
			   GUICtrlSetOnEvent(-1, "cmbDonateCustomB")
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateCustomB[1] = GUICtrlCreateInput("3", $x + 165, $y + 25, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   GUICtrlSetLimit(-1, 1)
			   GUICtrlSetState(-1, $GUI_HIDE)

		   GUICtrlCreateLabel(GetTranslated(612,74, "3rd") & ":", $x, $y + 54, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahPicDonateCustomB[2] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonMinion, $x + 25, $y + 50, 24, 24)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahCmbDonateCustomB[2] = GUICtrlCreateCombo("", $x + 60, $y + 50, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   GUICtrlSetData(-1, $sTxtBarbarians & "|" & $sTxtArchers & "|" & $sTxtGiants & "|" & $sTxtGoblins & "|" & $sTxtWallBreakers & "|" & $sTxtBalloons & "|" & $sTxtWizards & "|" & $sTxtHealers & "|" & $sTxtDragons & "|" & $sTxtPekkas & "|" & $sTxtBabyDragons & "|" & $sTxtMiners & "|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds & "|" & $sTxtBowlers & "|" & $sTxtNothing, $sTxtMinions)
			   GUICtrlSetOnEvent(-1, "cmbDonateCustomB")
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtDonateCustomB[2] = GUICtrlCreateInput("5", $x + 165, $y + 50, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   GUICtrlSetLimit(-1, 1)
			   GUICtrlSetState(-1, $GUI_HIDE)

		   GUICtrlCreateLabel($sTxtKeywordsNo & ":", $x + 215, $y + 80, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_ahTxtBlacklistTroop[$eCustomB] = GUICtrlCreateEdit("", $x + 215, $y + 95, 200, 50, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,102, "no air\r\nair no\r\nonly\r\njust")))
			   _GUICtrlSetTip(-1, $sTxtKeywordsNoTip & " " & $sDonateTxtCustomB)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   $x = $xStart
	   $y = $Offy
	   $g_hGrpDonateGeneralBlacklist = GUICtrlCreateGroup(GetTranslated(612,78, "General Blacklist"), $x - 20, $y - 20, 430, 169)
	   $x -= 10
	   $y -= 4
		   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDonBlacklist, $x + 215, $y, 64, 64, $BS_ICON)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   GUICtrlCreateLabel(GetTranslated(612,77, "Do NOT donate to any of these keywords") & ":", $x - 5, $y + 5, -1, -1)
			   GUICtrlSetState(-1, $GUI_HIDE)
		   $g_hTxtGeneralBlacklist = GUICtrlCreateEdit("", $x -5, $y + 20, 205, 125, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetState(-1, $GUI_HIDE)
			   GUICtrlSetBkColor ( -1, 0x505050)
			   GUICtrlSetColor ( -1, $COLOR_WHITE)
			   GUICtrlSetData(-1, StringFormat(GetTranslated(612,79, "clan war\r\nwar\r\ncw")))
			   _GUICtrlSetTip(-1, GetTranslated(612,80, "General Blacklist for donation requests"))
	   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
#EndRegion

#Region CreateScheduleSubTab
Func CreateScheduleSubTab()
	Local $xStart = 25, $yStart = 45
	$g_hGUI_ScheduleCC = GUICreate("", $_GUI_MAIN_WIDTH - 30 - 10, $_GUI_MAIN_HEIGHT - 255 - 30 - 30, $xStart - 20, $yStart - 20, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DONATE)
	GUISetBkColor($COLOR_WHITE)
	Local $xStart = 20, $yStart = 20
	Local $x = $xStart
	Local $y = $yStart
	$g_hGrpDonateCC = GUICtrlCreateGroup(GetTranslated(613,1,"Donate Schedule"), $x - 20, $y - 20, 430, 120)
	   $y += 10
	   $x += 10
	   GUICtrlCreateIcon($g_sLibIconPath, $eIcnCCDonate, $x - 5, $y, 64, 60, $BS_ICON)

	   $g_hChkDonateHoursEnable = GUICtrlCreateCheckbox(GetTranslated(603,30, -1), $x +40+ 30, $y-6)
	   GUICtrlSetOnEvent(-1, "chkDonateHours")

	   $y += 20
	   $x += 90
	   $g_hLblDonateHours1 = GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateLabel("X", $x + 213, $y+2, 11, 11)
	   GUICtrlSetState(-1, $GUI_DISABLE)

	   $y += 15
	   $g_ahChkDonateHours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		  GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
		  _GUICtrlSetTip(-1, GetTranslated(603,2, -1))
		  GUICtrlSetOnEvent(-1, "chkDonateHoursE1")
	   GUICtrlCreateLabel(GetTranslated(603,3, -1), $x + 5, $y)
	   GUICtrlSetState(-1, $GUI_DISABLE)

	   $y += 15
	   $g_ahChkDonateHours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	   GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	   $g_ahChkDonateHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		  GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		  GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
		  _GUICtrlSetTip(-1, GetTranslated(603,2, -1))
		  GUICtrlSetOnEvent(-1, "chkDonateHoursE2")
	   $g_hLblDonateHoursPM = GUICtrlCreateLabel(GetTranslated(603,4, -1), $x + 5, $y)
	   GUICtrlSetState(-1, $GUI_DISABLE)
	   $y += 16
    GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 130
	GUICtrlCreateGroup(GetTranslated(613,2,"Donation Clan Mates Filter"), $x - 20, $y - 20, 430, 155)
		$y += 10
		GUICtrlCreateLabel(GetTranslated(613, 8,"Using this option you can choose to donate to all members of your team (No Filter), donate only to certain friends (White List) or give everyone except a few members of your team (Black List)"), $x , $y - 10, 380, 40, $BS_MULTILINE)
		$y += 35

		$g_hCmbFilterDonationsCC = GUICtrlCreateCombo("", $x, $y, 300, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(613,4, "No Filter, donate at all Clan Mates") & "|" & GetTranslated(613,5, "No Filter but collect Clan Mates Images") & "|" & GetTranslated(613,6, "Donate only at Clan Mates in White List" ) & "|" & GetTranslated(613,7, "Donate at all Except at Clan Mates in Black List") , GetTranslated(613,4,-1))
			GUICtrlSetOnEvent(-1, "cmbABAlgorithm")

		$y += 35
		GUICtrlCreateLabel(GetTranslated(613, 10,"Images of Clan Mates are captured and stored in main folder, move to appropriate folder (White or Black List)"), $x , $y - 10, 380, 30, $BS_MULTILINE)
		$y += 20

		GUICtrlCreateButton(GetTranslated(613, 9,"Open Clan Mates Image Folder"), $x + 2, $y, 300, 20,-1)
			;GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDonBarbarian, 1)
			GUICtrlSetOnEvent(-1, "btnFilterDonationsCC")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

   $y += 60
   GUICtrlCreateGroup(GetTranslated(613,15,"Skip donation near full troops"), $x - 20, $y - 20, 430, 45)

	  $g_hChkSkipDonateNearFullTroopsEnable = GUICtrlCreateCheckbox(GetTranslated(613,13,"Skip donation near full troops"), $x, $y-4)
			GUICtrlSetState(-1, $GUI_CHECKED )
			GUICtrlSetOnEvent(-1, "chkskipDonateNearFulLTroopsEnable")

	  $x += 180
		 $g_hLblSkipDonateNearFullTroopsText =  GUICtrlCreateLabel(GetTranslated(613,14,"if troops army camps are greater than"), $x, $y)
	  $x += 110
		 $g_hTxtSkipDonateNearFullTroopsPercentage = GUICtrlCreateInput("90", $x +40+30 , $y -2 , 20, 20,  BitOR($SS_CENTER, $ES_AUTOHSCROLL))
		 GUICtrlSetLimit(-1,2)
	  $x += 95
		 $g_hLblSkipDonateNearFullTroopsText1 =  GUICtrlCreateLabel("%", $x, $y)

   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
#EndRegion
