; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Search" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; Start search if
Global $g_hChkDBActivateSearches = 0, $g_hTxtDBSearchesMin = 0, $g_hTxtDBSearchesMax = 0  ; Search count limit
Global $g_hChkDBActivateTropies = 0, $g_hTxtDBTropiesMin = 0, $g_hTxtDBTropiesMax = 0  ; Trophy limit
Global $g_hChkDBActivateCamps = 0, $g_hTxtDBArmyCamps = 0 ; Camp limit
Global $g_hChkDBKingWait = 0, $g_hChkDBQueenWait = 0, $g_hChkDBWardenWait = 0
Global $g_hChkDBSpellsWait = 0, $g_hChkDBWaitForCastleSpell = 0, $g_hCmbDBWaitForCastleSpell = 0, $g_hCmbDBWaitForCastleSpell = 0,$g_hCmbDBWaitForCastleSpell2 = 0, $g_hTxtDBWaitForCastleSpell = 0, $g_hChkDBWaitForCastleTroops = 0

Global $g_hLblDBSearches = 0, $g_hLblDBTropies = 0, $g_hLblDBArmyCamps = 0
Global $g_hPicDBHeroesWait = 0, $g_hTxtDBHeroesWait = 0, $g_hPicDBKingWait = 0, $g_hPicDBKingSleepWait = 0, $g_hPicDBQueenWait = 0, $g_hPicDBQueenSleepWait = 0, _
	   $g_hPicDBWardenWait = 0, $g_hPicDBWardenSleepWait = 0
Global $g_hPicDBLightSpellWait = 0, $g_hPicDBHealSpellWait = 0, $g_hPicDBRageSpellWait = 0, $g_hPicDBJumpSpellWait = 0, $g_hPicDBFreezeSpellWait = 0, _
	   $g_hPicDBPoisonSpellWait = 0, $g_hPicDBEarthquakeSpellWait = 0, $g_hPicDBHasteSpellWait = 0

; Filters
Global $g_hCmbDBMeetGE = 0, $g_hTxtDBMinGold = 0, $g_hTxtDBMinElixir = 0, $g_hTxtDBMinGoldPlusElixir = 0
Global $g_hChkDBMeetDE = 0, $g_hTxtDBMinDarkElixir = 0
Global $g_hChkDBMeetTrophy = 0, $g_hTxtDBMinTrophy = 0
Global $g_hChkDBMeetTH = 0, $g_hCmbDBTH = 0, $g_hChkDBMeetTHO = 0

Global $g_hGrpDBFilter = 0, $g_hPicDBMinGold = 0, $g_hPicDBMinElixir = 0, $g_hPicDBMinGPEGold = 0, $g_hPicDBMinDarkElixir = 0, $g_hPicDBMinTrophies = 0, $g_hPicDBMaxTH10 = 0

Func CreateAttackSearchDeadBaseSearch()
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
	   GUICtrlCreateGroup(GetTranslated(625,0, "Start Search IF"), $x - 20, $y - 20, 190, 305)
		   $x -= 15
		   $g_hChkDBActivateSearches = GUICtrlCreateCheckbox(GetTranslated(625,1,"Search"), $x, $y, 68, 18)
			   _GUICtrlSetTip(-1, GetTranslated(625,68, "Note - enables SEARCH range for this attack type ONLY.") & @CRLF & _
								  GetTranslated(625,69, "Setting will not set search limit to restart search process!"))
			   GUICtrlSetState(-1,$GUI_CHECKED)
			   GUICtrlSetOnEvent(-1, "chkDBActivateSearches")
		   $g_hTxtDBSearchesMin = GUICtrlCreateInput("1", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   _GUICtrlSetTip(-1, GetTranslated(625,2, "Set the Min. number of searches to activate this attack option") & @CRLF & @CRLF & _
								  GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,69, -1))
			   GUICtrlSetLimit(-1, 6)
		   $g_hLblDBSearches = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
		   $g_hTxtDBSearchesMax = GUICtrlCreateInput("9999", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER)) ;ChrW(8734)
			   _GUICtrlSetTip(-1, GetTranslated(625,3, "Set the Max number of searches to activate this attack option") & @CRLF & @CRLF & _
								  GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,69,-1))
			   GUICtrlSetLimit(-1, 6)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnMagnifier, $x + 163, $y + 1, 16, 16)

	   $y += 21
		   $g_hChkDBActivateTropies = GUICtrlCreateCheckbox(GetTranslated(625,4,"Trophies"), $x, $y, 68, 18)
			   _GUICtrlSetTip(-1, GetTranslated(625,68, -1) & @CRLF & _
								  GetTranslated(625,70,"This option will NOT adjust tropies to stay in range entered!"))
			   GUICtrlSetOnEvent(-1, "chkDBActivateTropies")
		   $g_hTxtDBTropiesMin = GUICtrlCreateInput("0", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   GUICtrlSetState(-1,$GUI_DISABLE)
			   _GUICtrlSetTip(-1, GetTranslated(625,5, "Set the Min. number of tropies where this attack will be used") & @CRLF & @CRLF & _
								  GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,70,-1))
			   GUICtrlSetLimit(-1, 6)
		   $g_hLblDBTropies = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
			   GUICtrlSetState(-1,$GUI_DISABLE)
		   $g_hTxtDBTropiesMax = GUICtrlCreateInput("6000", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   GUICtrlSetState(-1,$GUI_DISABLE)
			   _GUICtrlSetTip(-1, GetTranslated(625,6, "Set the Max number of tropies where this attack will be used") & @CRLF & @CRLF & _
								  GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,70, -1))
			   GUICtrlSetLimit(-1, 6)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 163, $y + 1, 16, 16)

	   $y +=21
		   $g_hChkDBActivateCamps = GUICtrlCreateCheckbox(GetTranslated(625,7, "Army Camps"), $x, $y, 110, 18)
			   $sTxtTip = GetTranslated(625,8, "Set the % Army camps required to enable this attack option while searching")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetOnEvent(-1, "chkDBActivateCamps")
		   $g_hLblDBArmyCamps = GUICtrlCreateLabel(ChrW(8805), $x + 113 - 1, $y + 2, -1, -1)
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetState(-1,$GUI_DISABLE)
		   $g_hTxtDBArmyCamps = GUICtrlCreateInput("80", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetState(-1,$GUI_DISABLE)
			   GUICtrlSetLimit(-1, 6)
		   GUICtrlCreateLabel("%", $x + 163 + 3, $y + 4, -1, -1)
			   GUICtrlSetState(-1,$GUI_DISABLE)

	   $y +=23
		   $g_hPicDBHeroesWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x - 1, $y + 3, 16, 16)
		   $g_hTxtDBHeroesWait = GUICtrlCreateLabel(GetTranslated(625,9,"Wait for Heroes to be Ready") & ":", $x + 20, $y + 4, 180, 18)

	   $y += 20
	   $x += 20
		   $g_hChkDBKingWait = GUICtrlCreateCheckbox("", $x, $y + 55, 16, 16)
			   Local $sTxtKingWait = GetTranslated(625,50, "Wait for Hero option disabled when continuous Upgrade Hero selected!")
			   $sTxtTip = GetTranslated(625,10, "Wait for King to be ready before attacking...") & @CRLF & $sTxtKingWait & @CRLF & _
						  GetTranslated(625,65, "Enabled with TownHall 7 and higher")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetOnEvent(-1, "chkDBKingWait")
		   $g_hPicDBKingWait=GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x - 18, $y + 4, 48, 48)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hPicDBKingSleepWait=GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingKing, $x - 18, $y + 4, 48, 48)
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetState(-1,$GUI_HIDE)

	   $x += 55
		   $g_hChkDBQueenWait = GUICtrlCreateCheckbox("", $x, $y + 55, 16, 16)
			   $sTxtTip = GetTranslated(625,12, "Wait for Queen to be ready before attacking...") & @CRLF & $sTxtKingWait & @CRLF & _
						  GetTranslated(625,66, "Enabled with TownHall 9 and higher")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetOnEvent(-1, "chkDBQueenWait")
		   $g_hPicDBQueenWait=GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x - 18, $y + 4, 48, 48)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hPicDBQueenSleepWait=GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingQueen, $x - 18, $y + 4, 48, 48)
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetState(-1,$GUI_HIDE)

	   $x += 55
		   $g_hChkDBWardenWait = GUICtrlCreateCheckbox("", $x, $y + 55, 16, 16)
			   $sTxtTip = GetTranslated(625,13, "Wait for Warden to be ready before attacking...") & @CRLF & $sTxtKingWait & @CRLF & _
						  GetTranslated(625,67, "Enabled with TownHall 11")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetOnEvent(-1, "chkDBWardenWait")
		   $g_hPicDBWardenWait=GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x - 18, $y + 4, 48, 48)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hPicDBWardenSleepWait=GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingWarden, $x - 18, $y + 4, 48, 48)
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetState(-1,$GUI_HIDE)

	   $y += 80
	   $x = 8
		 $g_hPicDBLightSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x, $y, 22, 22)
		 $g_hPicDBHealSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x+23, $y, 22, 22)
		 $g_hPicDBRageSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x+46, $y, 22, 22)
		 $g_hPicDBJumpSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell , $x+69, $y, 22, 22)
		 $g_hPicDBFreezeSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell , $x+92, $y, 22, 22)
		 $g_hPicDBPoisonSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell , $x+115, $y, 22, 22)
		 $g_hPicDBEarthquakeSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthquakeSpell , $x+138, $y, 22, 22)
		 $g_hPicDBHasteSpellWait = GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x+161, $y, 22, 22)

	   $y += 22
	   $x = 10
		   $g_hChkDBSpellsWait = GUICtrlCreateCheckbox(GetTranslated(625,71, "Wait for Spells to be Ready"), $x, $y, -1, -1)
			   _GUICtrlSetTip(-1, GetTranslated(625,72, "Stop searching for this attack type when Spells are not ready") & @CRLF & _
								  GetTranslated(625,73, "Warning: Do not enable unless you have spell factory or bot will not attack!"))
			   GUICtrlSetOnEvent(-1, "chkDBSpellsWait")


		   $g_hChkDBWaitForCastleSpell = GUICtrlCreateCheckbox(GetTranslated(625,74, "Wait to get Castle Spell"), $x, $y + 25, -1, -1)
			   _GUICtrlSetTip(-1, GetTranslated(625,75, "Wait until Someone Donate you an Spell"))
			   GUICtrlSetOnEvent(-1, "chkDBWaitForCCSpell")

			$g_hCmbDBWaitForCastleSpell = GUICtrlCreateCombo(GetTranslated(625,76, "Any"), $x, $y + 50, 70, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtLightningSpells & "|" & $sTxtHealSpells & "|" & $sTxtRageSpells & "|" & $sTxtJumpSpells & "|" & $sTxtFreezeSpells & "|" & $sTxtPoisonSpells & "|" & $sTxtEarthquakeSpells & "|" & $sTxtHasteSpells & "|" & $sTxtSkeletonSpells)
				_GUICtrlSetTip(-1, GetTranslated(625,77, -1))
				GUICtrlSetOnEvent(-1, "cmbDBWaitForCCSpell")
			$g_hTxtDBWaitForCastleSpell = GUICtrlCreateLabel(GetTranslated(641, 40, "And"), $x + 80, $y + 53, -1, -1)
			$g_hCmbDBWaitForCastleSpell2 = GUICtrlCreateCombo(GetTranslated(625,76, "Any"),$x + 110, $y + 50, 70, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, $sTxtPoisonSpells & "|" & $sTxtEarthquakeSpells & "|" & $sTxtHasteSpells & "|" & $sTxtSkeletonSpells)
				_GUICtrlSetTip(-1, GetTranslated(625,75, -1))

		   $g_hChkDBWaitForCastleTroops = GUICtrlCreateCheckbox(GetTranslated(625,78, "Wait for Castle troops to be full"), $x, $y + 75, -1, -1)
			   _GUICtrlSetTip(-1, GetTranslated(625,79, "Wait until your Clan Castle be Full"))
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

	   Local $x = 220, $y = 45
	   $g_hGrpDBFilter = GUICtrlCreateGroup(GetTranslated(625,14, "Filters"), $x - 20, $y - 20, 225, 305)
		   $x -= 15
		   $g_hCmbDBMeetGE = GUICtrlCreateCombo("", $x , $y + 10, 65, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   GUICtrlSetData(-1, GetTranslated(625,19, "G And E") &"|" & GetTranslated(625,20, "G Or E") & "|" & GetTranslated(625,21, "G + E"), GetTranslated(625,19, -1))
			   _GUICtrlSetTip(-1, GetTranslated(625,15, "Search for a base that meets the values set for Gold And/Or/Plus Elixir.") & @CRLF & _
								  GetTranslated(625,16, "AND: Both conditions must meet, Gold and Elixir.") & @CRLF & _
								  GetTranslated(625,17, "OR: One condition must meet, Gold or Elixir.") & @CRLF & _
								  GetTranslated(625,18, "+ (PLUS): Total amount of Gold + Elixir must meet."))
			   GUICtrlSetOnEvent(-1, "cmbDBGoldElixir")
		   $g_hTxtDBMinGold = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   $sTxtTip = GetTranslated(625,23, "Set the Min. amount of Gold to search for on a village to attack.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetLimit(-1, 6)
		   $g_hPicDBMinGold = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 140, $y, 16, 16)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y += 21
		   $g_hTxtDBMinElixir = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   $sTxtTip = GetTranslated(625,24, "Set the Min. amount of Elixir to search for on a village to attack.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetLimit(-1, 6)
		   $g_hPicDBMinElixir = GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 140, $y, 16, 16)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y -= 11
		   $g_hTxtDBMinGoldPlusElixir = GUICtrlCreateInput("160000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   $sTxtTip = GetTranslated(625,25, "Set the Min. amount of Gold + Elixir to search for on a village to attack.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetLimit(-1, 6)
			   GUICtrlSetState (-1, $GUI_HIDE)
		   $g_hPicDBMinGPEGold = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldElixir, $x + 140, $y + 1, 16, 16)
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetState (-1, $GUI_HIDE)

		   $y += 34
		   $g_hChkDBMeetDE = GUICtrlCreateCheckbox(GetTranslated(625,26, "Dark Elixir"), $x , $y, -1, -1)
			   GUICtrlSetOnEvent(-1, "chkDBMeetDE")
			   _GUICtrlSetTip(-1, GetTranslated(625,27, "Search for a base that meets the value set for Min. Dark Elixir."))
		   $g_hTxtDBMinDarkElixir = GUICtrlCreateInput("0", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   $sTxtTip = GetTranslated(625,28, "Set the Min. amount of Dark Elixir to search for on a village to attack.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetLimit(-1, 5)
			   _GUICtrlEdit_SetReadOnly(-1, True)
		   $g_hPicDBMinDarkElixir = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 140, $y, 16, 16)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y += 24
		   $g_hChkDBMeetTrophy = GUICtrlCreateCheckbox(GetTranslated(625,4, -1), $x, $y, -1, -1)
			   GUICtrlSetOnEvent(-1, "chkDBMeetTrophy")
			   _GUICtrlSetTip(-1, GetTranslated(625,29, "Search for a base that meets the value set for Min. Trophies."))
		   $g_hTxtDBMinTrophy = GUICtrlCreateInput("0", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   $sTxtTip = GetTranslated(625,30, "Set the Min. amount of Trophies to search for on a village to attack.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   _GUICtrlEdit_SetReadOnly(-1, True)
			   GUICtrlSetLimit(-1, 2)
		   $g_hPicDBMinTrophies = GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 140, $y, 16, 16)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y += 24
		   $g_hChkDBMeetTH = GUICtrlCreateCheckbox(GetTranslated(625,31, "Townhall"), $x, $y, -1, -1)
			   GUICtrlSetOnEvent(-1, "chkDBMeetTH")
			   _GUICtrlSetTip(-1, GetTranslated(625,32, "Search for a base that meets the value set for Max. Townhall Level."))
		   $g_hCmbDBTH = GUICtrlCreateCombo("", $x + 85, $y - 1, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   $sTxtTip = GetTranslated(625,33, "Set the Max. level of the Townhall to search for on a village to attack.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetState(-1, $GUI_DISABLE)
			   GUICtrlSetData(-1, "4-6|7|8|9|10|11", "4-6")
		   $g_hPicDBMaxTH10 = GUICtrlCreateIcon($g_sLibIconPath, $eIcnTH10, $x + 140, $y - 3, 24, 24)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y += 24
		   $g_hChkDBMeetTHO = GUICtrlCreateCheckbox(GetTranslated(625,34, "Townhall Outside"), $x, $y, -1, -1)
			   _GUICtrlSetTip(-1, GetTranslated(625,35, "Search for a base that has an exposed Townhall. (Outside of Walls)"))
		   $y += 24

	   GUICtrlCreateGroup(GetTranslated(625,80, "Weak base | max defenses"), $x, $y, 215, 100)
		  $x += 5
		  $y += 20
		  Local $xStartColumn = $x, $yStartColumn = $y
		   $g_ahChkMaxMortar[$DB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			   _GUICtrlSetTip(-1, GetTranslated(625,59, "Search for a base that has Mortar below this level."))
			   GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		   $g_ahCmbWeakMortar[$DB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   $sTxtTip = GetTranslated(625,38, "Set the Max. level of the Mortar to search for on a village to attack.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 5")
			   GUICtrlSetState(-1, $GUI_DISABLE)
		   $g_ahPicWeakMortar[$DB] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnMortar, $x + 75, $y - 2, 24, 24)
			   _GUICtrlSetTip(-1, $sTxtTip)

		  $y +=24
		   $g_ahChkMaxWizTower[$DB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			   _GUICtrlSetTip(-1, GetTranslated(625,60, "Search for a base that has Wizard Tower below this level"))
			   GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		   $g_ahCmbWeakWizTower[$DB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   $sTxtTip = GetTranslated(625,39, "Set the Max. level of the Wizard Tower to search for on a village to attack.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8|Lvl 9", "Lvl 4")
			   GUICtrlSetState(-1, $GUI_DISABLE)
		   $g_ahPicWeakWizTower[$DB] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnWizTower, $x + 75, $y - 2, 24, 24)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y +=24
		   $g_ahChkMaxAirDefense[$DB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			   _GUICtrlSetTip(-1, GetTranslated(625,64, "Search for a base that has Air Defense below this level"))
			   GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		   $g_ahCmbWeakAirDefense[$DB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   $sTxtTip = GetTranslated(625,81, "Set the Max. level of the Air Defense to search for on a village to attack.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 7")
			   GUICtrlSetState(-1, $GUI_DISABLE)
		   $g_ahPicWeakAirDefense[$DB] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnAirdefense, $x + 75, $y - 2, 24, 24)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $x = $xStartColumn + 104
		   $y = $yStartColumn
		   $g_ahChkMaxXBow[$DB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			   _GUICtrlSetTip(-1, GetTranslated(625,61, "Search for a base that has X-Bow below this level"))
			   GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		   $g_ahCmbWeakXBow[$DB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   $sTxtTip = GetTranslated(625,51, "Set the Max. level of the X-Bow to search for on a village to attack.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4", "Lvl 2")
			   GUICtrlSetState(-1, $GUI_DISABLE)
		   $g_ahPicWeakXBow[$DB] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnXBow3, $x + 75, $y - 2, 24, 24)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y +=24
		   $g_ahChkMaxInferno[$DB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			   _GUICtrlSetTip(-1, GetTranslated(625,62, "Search for a base that has Inferno below this level"))
			   GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		   $g_ahCmbWeakInferno[$DB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   $sTxtTip = GetTranslated(625,52, "Set the Max. level of the Inferno Tower to search for on a village to attack.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3", "Lvl 2")
			   GUICtrlSetState(-1, $GUI_DISABLE)
		   $g_ahPicWeakInferno[$DB] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnInferno4, $x + 75, $y - 2, 24, 24)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y +=24
		   $g_ahChkMaxEagle[$DB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			   _GUICtrlSetTip(-1, GetTranslated(625,63, "Search for a base that has Eagle Artillery below this level"))
			   GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		   $g_ahCmbWeakEagle[$DB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   $sTxtTip = GetTranslated(625,53, "Set the Max. level of the Eagle Artillery to search for on a village to attack.")
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetData(-1, "-|Lvl 1|Lvl 2", "Lvl 1")
			   GUICtrlSetState(-1, $GUI_DISABLE)
		   $g_ahPicWeakEagle[$DB] = GUICtrlCreateIcon($g_sLibIconPath, $eIcnEagleArt, $x + 75, $y - 2, 24, 24)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y += 44
		   $x = $xStartColumn
		   $g_ahChkMeetOne[$DB] = GUICtrlCreateCheckbox(GetTranslated(625,40, "Meet One Then Attack"), $x, $y, -1, -1)
			   _GUICtrlSetTip(-1, GetTranslated(625,41, "Just meet only ONE of the above conditions, then Attack."))
	   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
