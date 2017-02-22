; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Search" tab under the "ActiveBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

; Start search if
Global $g_hChkABActivateSearches = 0, $g_hTxtABSearchesMin = 0, $g_hTxtABSearchesMax = 0  ; Search count limit
Global $g_hChkABActivateTropies = 0, $g_hTxtABTropiesMin = 0, $g_hTxtABTropiesMax = 0  ; Trophy limit
Global $g_hChkABActivateCamps = 0, $g_hTxtABArmyCamps = 0 ; Camp limit
Global $g_hChkABKingWait = 0, $g_hChkABQueenWait = 0, $g_hChkABWardenWait = 0
Global $g_hChkABSpellsWait = 0, $g_hChkABWaitForCastleSpell = 0, $g_hCmbABWaitForCastleSpell = 0,$g_hCmbABWaitForCastleSpell2 = 0, $g_hTxtABWaitForCastleSpell = 0, $g_hChkABWaitForCastleTroops = 0

Global $g_hLblABSearches = 0, $g_hLblABTropies = 0, $g_hLblABArmyCamps = 0
Global $g_hPicABHeroesWait = 0, $g_hTxtABHeroesWait = 0, $g_hPicABKingWait = 0, $g_hPicABKingSleepWait = 0, $g_hPicABQueenWait = 0, $g_hPicABQueenSleepWait = 0, _
	   $g_hPicABWardenWait = 0, $g_hPicABWardenSleepWait = 0
Global $g_hPicABLightSpellWait = 0, $g_hPicABHealSpellWait = 0, $g_hPicABRageSpellWait = 0, $g_hPicABJumpSpellWait = 0, $g_hPicABFreezeSpellWait = 0, _
	   $g_hPicABPoisonSpellWait = 0, $g_hPicABEarthquakeSpellWait = 0, $g_hPicABHasteSpellWait = 0

; Filters
Global $g_hCmbABMeetGE = 0, $g_hTxtABMinGold = 0, $g_hTxtABMinElixir = 0, $g_hTxtABMinGoldPlusElixir = 0
Global $g_hChkABMeetDE = 0, $g_hTxtABMinDarkElixir = 0
Global $g_hChkABMeetTrophy = 0, $g_hTxtABMinTrophy = 0
Global $g_hChkABMeetTH = 0, $g_hCmbABTH = 0, $g_hChkABMeetTHO = 0

Global $g_hGrpABFilter = 0, $g_hPicABMinGold = 0, $g_hPicABMinElixir = 0, $g_hPicABMinGPEGold = 0, $g_hPicABMinDarkElixir = 0, $g_hPicABMinTrophies = 0, $g_hPicABMaxTH10 = 0

Func CreateAttackSearchActiveBaseSearch()
   Local $sTxtLightningSpells = GetTranslated(605,15,"Lightning")
   Local $sTxtHealSpells = GetTranslated(605,16,"Heal")
   Local $sTxtRageSpells = GetTranslated(605,17,"Rage")
   Local $sTxtJumpSpells = GetTranslated(605,18,"Jump")
   Local $sTxtFreezeSpells = GetTranslated(605,19,"Freeze")
   Local $sTxtPoisonSpells = GetTranslated(605,9, "Poison")
   Local $sTxtEarthquakeSpells = GetTranslated(605,10, "EarthQuake")
   Local $sTxtHasteSpells = GetTranslated(605,11, "Haste")
   Local $sTxtSkeletonSpells = GetTranslated(605,14, "Skeleton")

   Local $sTxtTip = ""
   Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslated(625,0, -1), $x - 20, $y - 20, 190, 305)
		$x -= 15
		$g_hChkABActivateSearches = GUICtrlCreateCheckbox(GetTranslated(625,1, -1), $x, $y, 68, 18)
			_GUICtrlSetTip(-1, GetTranslated(625,68, -1) & @CRLF & _
							   GetTranslated(625,69, -1))
			GUICtrlSetState(-1,$GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkABActivateSearches")
		$g_hTxtABSearchesMin = GUICtrlCreateInput("1", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(625,2, -1) & @CRLF & @CRLF & _
							   GetTranslated(625,68, -1) & @CRLF & _
							   GetTranslated(625,69, -1))
			GUICtrlSetLimit(-1, 6)
		$g_hLblABSearches = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
		$g_hTxtABSearchesMax = GUICtrlCreateInput("9999", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER)) ;ChrW(8734)
			_GUICtrlSetTip(-1, GetTranslated(625,3, -1) & @CRLF & @CRLF & _
							   GetTranslated(625,68, -1) & @CRLF & _
							   GetTranslated(625,69,-1))
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnMagnifier, $x + 163, $y + 1, 16, 16)

    $y +=21
		$g_hChkABActivateTropies = GUICtrlCreateCheckbox(GetTranslated(625,4, -1), $x, $y, 68, 18)
			_GUICtrlSetTip(-1, GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,70,-1))
			GUICtrlSetOnEvent(-1, "chkABActivateTropies")
		$g_hTxtABTropiesMin = GUICtrlCreateInput("0", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1,$GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslated(625,5, -1) & @CRLF & @CRLF & _
							   GetTranslated(625,68, -1) & @CRLF & _
							   GetTranslated(625,70,-1))
			GUICtrlSetLimit(-1, 6)
		$g_hLblABTropies = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
			GUICtrlSetState(-1,$GUI_DISABLE)
		$g_hTxtABTropiesMax = GUICtrlCreateInput("6000", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1,$GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslated(625,6, -1) & @CRLF & @CRLF & GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,70,-1))
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 163, $y + 1, 16, 16)

	$y +=21
		$g_hChkABActivateCamps = GUICtrlCreateCheckbox(GetTranslated(625,7, -1), $x, $y, 110, 18)
			$sTxtTip = GetTranslated(625,8, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkABActivateCamps")
		$g_hLblABArmyCamps = GUICtrlCreateLabel(ChrW(8805), $x + 113 - 1, $y + 2, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1,$GUI_DISABLE)
		$g_hTxtABArmyCamps = GUICtrlCreateInput("100", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1,$GUI_DISABLE)
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateLabel("%", $x + 163 + 3, $y + 4, -1, -1)
			GUICtrlSetState(-1,$GUI_DISABLE)

	$y +=23
		$g_hPicABHeroesWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x - 1, $y + 3, 16, 16)
		$g_hTxtABHeroesWait = GUICtrlCreateLabel(GetTranslated(625,9, -1) & ":", $x + 20, $y + 4, 180, 18)

	$y += 20
	$x += 20
		$g_hChkABKingWait = GUICtrlCreateCheckbox("", $x , $y + 55, 16, 16)
 			$sTxtTip = GetTranslated(625,10, -1) & @CRLF & GetTranslated(625, 50, -1) & @CRLF & GetTranslated(625, 65, -1)
 			_GUICtrlSetTip(-1, $sTxtTip)
 			GUICtrlSetOnEvent(-1, "chkABKingWait")
		$g_hPicABKingWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x - 18, $y + 4, 48, 48)
 			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicABKingSleepWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingKing, $x - 18, $y + 4, 48, 48)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1,$GUI_HIDE)

	$x += 55
		$g_hChkABQueenWait = GUICtrlCreateCheckbox("", $x , $y + 55, 16, 16)
 			$sTxtTip = GetTranslated(625,12, -1) & @CRLF & GetTranslated(625, 50, -1) & @CRLF & GetTranslated(625, 66, -1)
 			_GUICtrlSetTip(-1, $sTxtTip)
 			GUICtrlSetOnEvent(-1, "chkABQueenWait")
 		$g_hPicABQueenWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x - 18, $y + 4, 48, 48)
 			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicABQueenSleepWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingQueen, $x - 18, $y + 4, 48, 48)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1,$GUI_HIDE)

	$x += 55
 		$g_hChkABWardenWait = GUICtrlCreateCheckbox("", $x , $y + 55, 16, 16)
 			$sTxtTip = GetTranslated(625,13, -1) & @CRLF & GetTranslated(625, 50, -1) & @CRLF & GetTranslated(625, 67, -1)
 			_GUICtrlSetTip(-1, $sTxtTip)
 			GUICtrlSetOnEvent(-1, "chkABWardenWait")
 		$g_hPicABWardenWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x - 18, $y + 4, 48, 48)
 			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicABWardenSleepWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingWarden, $x - 18, $y + 4, 48, 48)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1,$GUI_HIDE)

	$y += 80
	$x = 8
	  $g_hPicABLightSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x, $y, 22, 22)
	  $g_hPicABHealSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x+23, $y, 22, 22)
	  $g_hPicABRageSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x+46, $y, 22, 22)
	  $g_hPicABJumpSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell , $x+69, $y, 22, 22)
	  $g_hPicABFreezeSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell , $x+92, $y, 22, 22)
	  $g_hPicABPoisonSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell , $x+115, $y, 22, 22)
	  $g_hPicABEarthquakeSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell , $x+138, $y, 22, 22)
	  $g_hPicABHasteSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x+161, $y, 22, 22)

	$y += 22
	$x = 10
	$x = 10
	    $g_hChkABSpellsWait = GUICtrlCreateCheckbox(GetTranslated(625,71, -1), $x, $y, -1, -1)
 			_GUICtrlSetTip(-1, GetTranslated(625,72, -1) & @CRLF & _
							   GetTranslated(625,73, -1))
 			GUICtrlSetOnEvent(-1, "chkABSpellsWait")

		$g_hChkABWaitForCastleSpell = GUICtrlCreateCheckbox(GetTranslated(625,74, -1), $x, $y + 25, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(625,75, -1))
			GUICtrlSetOnEvent(-1, "chkABWaitForCCSpell")

		$g_hCmbABWaitForCastleSpell = GUICtrlCreateCombo(GetTranslated(625,76, "Any"), $x, $y + 50, 70, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtLightningSpells & "|" & $sTxtHealSpells & "|" & $sTxtRageSpells & "|" & $sTxtJumpSpells & "|" & $sTxtFreezeSpells & "|" & $sTxtPoisonSpells & "|" & $sTxtEarthquakeSpells & "|" & $sTxtHasteSpells & "|" & $sTxtSkeletonSpells)
			_GUICtrlSetTip(-1, GetTranslated(625,77, -1))
			GUICtrlSetOnEvent(-1, "cmbABWaitForCCSpell")
		$g_hTxtABWaitForCastleSpell = GUICtrlCreateLabel(GetTranslated(641, 40, "And"), $x + 80, $y + 53, -1, -1)
		$g_hCmbABWaitForCastleSpell2 = GUICtrlCreateCombo(GetTranslated(625,76, "Any"),$x + 110, $y + 50, 70, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sTxtPoisonSpells & "|" & $sTxtEarthquakeSpells & "|" & $sTxtHasteSpells & "|" & $sTxtSkeletonSpells)
			_GUICtrlSetTip(-1, GetTranslated(625,75, -1))

		$g_hChkABWaitForCastleTroops = GUICtrlCreateCheckbox(GetTranslated(625,78, -1), $x, $y + 75, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(625,79, -1))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

    Local $x = 220, $y = 45
	$g_hGrpABFilter = GUICtrlCreateGroup(GetTranslated(625,14, -1), $x - 20, $y - 20, 225, 305)
		$x -= 15
		$g_hCmbABMeetGE = GUICtrlCreateCombo("", $x , $y + 10, 65, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(625,19, -1) &"|" & GetTranslated(625,20, -1) & "|" & GetTranslated(625,21, -1), GetTranslated(625,19, -1))
			_GUICtrlSetTip(-1, GetTranslated(625,15, -1) & @CRLF & _
							   GetTranslated(625,16, -1) & @CRLF & _
							   GetTranslated(625,17, -1) & @CRLF & _
							   GetTranslated(625,18, -1))
			GUICtrlSetOnEvent(-1, "cmbABGoldElixir")
		$g_hTxtABMinGold = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslated(625,23, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 6)
		$g_hPicABMinGold = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y += 21
		$g_hTxtABMinElixir = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslated(625,24, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 6)
		$g_hPicABMinElixir = GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	    $y -= 11
		$g_hTxtABMinGoldPlusElixir = GUICtrlCreateInput("160000", $x + 85, $y, 50, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslated(625,25, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState (-1, $GUI_HIDE)
 		$g_hPicABMinGPEGold = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldElixir, $x + 137, $y + 1, 16, 16)
 			_GUICtrlSetTip(-1, $sTxtTip)
 			GUICtrlSetState (-1, $GUI_HIDE)

		$y += 34
		$g_hChkABMeetDE = GUICtrlCreateCheckbox(GetTranslated(625,26, -1), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkABMeetDE")
			_GUICtrlSetTip(-1, GetTranslated(625,27, -1))
		$g_hTxtABMinDarkElixir = GUICtrlCreateInput("0", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslated(625,28, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 5)
			_GUICtrlEdit_SetReadOnly(-1, True)
		$g_hPicABMinDarkElixir = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y += 24
		$g_hChkABMeetTrophy = GUICtrlCreateCheckbox(GetTranslated(625,4, -1), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkABMeetTrophy")
			_GUICtrlSetTip(-1, GetTranslated(625,29, -1))
		$g_hTxtABMinTrophy = GUICtrlCreateInput("0", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslated(625,30, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			_GUICtrlEdit_SetReadOnly(-1, True)
			GUICtrlSetLimit(-1, 2)
		$g_hPicABMinTrophies = GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y += 24
		$g_hChkABMeetTH = GUICtrlCreateCheckbox(GetTranslated(625,31, -1), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkABMeetTH")
			_GUICtrlSetTip(-1, GetTranslated(625,32, -1))
		$g_hCmbABTH = GUICtrlCreateCombo("", $x + 85, $y - 1, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslated(625,33, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetData(-1, "4-6|7|8|9|10|11", "4-6")
		$g_hPicABMaxTH10 = GUICtrlCreateIcon($g_sLibIconPath, $eIcnTH10, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y += 24
		$g_hChkABMeetTHO = GUICtrlCreateCheckbox(GetTranslated(625,34, -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(625,35, -1))
		$y += 24

		GUICtrlCreateGroup(GetTranslated(625,80, -1), $x, $y, 215, 100)
		$x += 5
		$y += 20
		Local $xStartColumn = $x, $yStartColumn = $y
		$g_ahChkMaxMortar[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslated(625,59, -1))
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$g_ahCmbWeakMortar[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslated(625,38, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 5")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakMortar[$LB] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnMortar, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y +=24
		$g_ahChkMaxWizTower[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslated(625,60, -1))
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$g_ahCmbWeakWizTower[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslated(625,39, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8|Lvl 9", "Lvl 4")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakWizTower[$LB] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnWizTower, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y += 24
		$g_ahChkMaxAirDefense[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslated(625,64, -1))
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$g_ahCmbWeakAirDefense[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslated(625,81, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 7")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakAirDefense[$LB] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnAirdefense, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

		$x = $xStartColumn + 104
		$y = $yStartColumn
		$g_ahChkMaxXBow[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslated(625,61, -1))
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$g_ahCmbWeakXBow[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslated(625,51, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4", "Lvl 2")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakXBow[$LB] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnXBow3, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y +=24
		$g_ahChkMaxInferno[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslated(625,62, -1))
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$g_ahCmbWeakInferno[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslated(625,52, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3", "Lvl 2")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakInferno[$LB] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnInferno4, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y +=24
		$g_ahChkMaxEagle[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslated(625,63, -1))
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$g_ahCmbWeakEagle[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslated(625,53, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2", "Lvl 1")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakEagle[$LB] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnEagleArt, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

		$y += 44
		$x = $xStartColumn
		$g_ahChkMeetOne[$LB] = GUICtrlCreateCheckbox(GetTranslated(625,40, -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(625,41, -1))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

 EndFunc
