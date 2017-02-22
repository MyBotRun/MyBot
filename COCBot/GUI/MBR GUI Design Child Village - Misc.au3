; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Misc" tab under the "Village" tab
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

;$hGUI_Settings = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_VILLAGE)
;GUISetBkColor($COLOR_WHITE, $hGUI_Settings)

Global $g_hChkBotStop = 0, $g_hCmbBotCommand = 0, $g_hCmbBotCond = 0, $g_hCmbHoursStop = 0
Global $g_hTxtRestartGold = 0, $g_hTxtRestartElixir = 0, $g_hTxtRestartDark = 0
Global $g_hChkTrap = 1, $g_hChkCollect = 1, $g_hChkTombstones = 1, $g_hChkCleanYard = 0, $g_hChkGemsBox = 0
Global $g_hBtnLocateSpellfactory = 0, $g_hBtnLocateDarkSpellFactory = 0
Global $g_hBtnLocateKingAltar = 0, $g_hBtnLocateQueenAltar = 0, $g_hBtnLocateWardenAltar = 0, $g_hBtnLocateLaboratory = 0, $g_hBtnResetBuilding = 0

Func CreateVillageMisc()
   Local $sTxtTip = ""
   Local $x = 15, $y = 45
   GUICtrlCreateGroup(GetTranslated(610,1, "Halt Attack"), $x - 10, $y - 20, 440, 100)
		$g_hChkBotStop = GUICtrlCreateCheckbox("", $x - 5, $y, 16, 16)
			$sTxtTip = GetTranslated(610,2, "Use these options to set when the bot will stop attacking.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkBotStop")

		$g_hCmbBotCommand = GUICtrlCreateCombo("", $x + 20, $y - 3, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, GetTranslated(610,3, "Halt Attack") & "|" & GetTranslated(610,4, "Stop Bot") & "|" & GetTranslated(610,5, "Close Bot") & "|" & GetTranslated(610,6, "Close CoC+Bot") & "|" & GetTranslated(610,7, "Shutdown PC") & "|" & GetTranslated(610,8, "Sleep PC") & "|" & GetTranslated(610,9, "Reboot PC"), GetTranslated(610,3, -1))
			GUICtrlSetState (-1, $GUI_DISABLE)
		GUICtrlCreateLabel(GetTranslated(610,10, "When..."), $x + 128, $y, 45, 17)

		$g_hCmbBotCond = GUICtrlCreateCombo("", $x + 175, $y - 3, 160, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, GetTranslated(610,11, "G and E Full and Max.Trophy") & "|" & GetTranslated(610,12, "(G and E) Full or Max.Trophy") & "|" & GetTranslated(610,13, "(G or E) Full and Max.Trophy") & "|" & _
			GetTranslated(610,14, "G or E Full or Max.Trophy") & "|" & GetTranslated(610,15, "Gold and Elixir Full") & "|" & GetTranslated(610,16, "Gold or Elixir Full") & "|" & GetTranslated(610,17, "Gold Full and Max.Trophy") & "|" & _
			GetTranslated(610,18, "Elixir Full and Max.Trophy") & "|" & GetTranslated(610,19, "Gold Full or Max.Trophy") & "|" & GetTranslated(610,20, "Elixir Full or Max.Trophy") & "|" & GetTranslated(610,21, "Gold Full") & "|" & _
			GetTranslated(610,22, "Elixir Full") & "|" & GetTranslated(610,23, "Reach Max. Trophy") & "|" & GetTranslated(610,24, "Dark Elixir Full") & "|" & GetTranslated(610,25, "All Storage (G+E+DE) Full") & "|" & _
			GetTranslated(610,26, "Bot running for...") & "|" & GetTranslated(610,27, "Now (Train/Donate Only)") & "|" & _
			GetTranslated(610,28, "Now (Donate Only)") & "|" & GetTranslated(610,29, "Now (Only stay online)") & "|" & GetTranslated(610,30, "W/Shield (Train/Donate Only)") & "|" & GetTranslated(610,31, "W/Shield (Donate Only)") & "|" & _
			GetTranslated(610,32, "W/Shield (Only stay online)"), GetTranslated(610,27, -1))
			GUICtrlSetOnEvent(-1, "cmbBotCond")
			GUICtrlSetState (-1, $GUI_DISABLE)

		$g_hCmbHoursStop = GUICtrlCreateCombo("", $x + 340, $y - 3, 80, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $sTxtTip)
			Local $sTxtHours = GetTranslated(603,14, "Hours")
			GUICtrlSetData(-1, "-|1 " & GetTranslated(603,15, "Hour") & "|2 " & $sTxtHours & "|3 " & $sTxtHours & "|4 " & $sTxtHours & "|5 " & $sTxtHours & "|6 " & $sTxtHours & "|7 " & $sTxtHours & "|8 " & $sTxtHours & "|9 " & $sTxtHours & "|10 " & $sTxtHours & "|11 " & $sTxtHours & "|12 " & $sTxtHours& "|13 " & $sTxtHours & "|14 " & $sTxtHours & "|15 " & $sTxtHours & "|16 " & $sTxtHours & "|17 " & $sTxtHours & "|18 " & $sTxtHours & "|19 " & $sTxtHours & "|20 " & $sTxtHours & "|21 " & $sTxtHours & "|22 " & $sTxtHours & "|23 " & $sTxtHours & "|24 " & $sTxtHours, "-")
			GUICtrlSetState (-1, $GUI_DISABLE)

	  $y += 25
		GUICtrlCreateLabel(GetTranslated(610,35, "The bot will Halt automatically when you run out of Resources. It will resume when reaching these minimal values."), $x + 20, $y, 400, 25, $BS_MULTILINE)

	  $y += 30
		GUICtrlCreateLabel(GetTranslated(610,36, "Resume Attack") & ":", $x + 20, $y + 2, 80, -1)

	  $x += 90
		GUICtrlCreateLabel(ChrW(8805), $x + 22, $y + 2, -1, -1)
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnGold, $x + 84, $y, 16, 16)
		$g_hTxtRestartGold = GUICtrlCreateInput("10000", $x + 32, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(610,37, "Minimum Gold value for the bot to resume attacking after halting because of low gold."))
			GUICtrlSetLimit(-1, 7)

	  $x += 90
		GUICtrlCreateLabel(ChrW(8805), $x + 22, $y + 2, -1, -1)
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnElixir, $x + 84, $y, 16, 16)
		$g_hTxtRestartElixir = GUICtrlCreateInput("25000", $x + 32, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(610,38, "Minimum Elixir value for the bot to resume attacking after halting because of low elixir."))
			GUICtrlSetLimit(-1, 7)

	  $x += 90
		GUICtrlCreateLabel(ChrW(8805), $x + 22, $y + 2, -1, -1)
		GUICtrlCreateIcon ($g_sLibIconPath, $eIcnDark, $x + 84, $y, 16, 16)
		$g_hTxtRestartDark = GUICtrlCreateInput("500", $x + 32, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslated(610,39, "Minimum Dark Elixir value for the bot to resume attacking after halting because of low dark elixir."))
			GUICtrlSetLimit(-1, 6)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   Local $x = 15, $y = 150
   GUICtrlCreateGroup(GetTranslated(610,40, "Rearm, Collect, Clear"), $x -10, $y - 20 , 440, 190)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrap, $x + 7, $y, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnXbow, $x + 32, $y, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnInferno, $x + 57, $y, 24, 24)
		$g_hChkTrap = GUICtrlCreateCheckbox(GetTranslated(610,41, "Rearm Traps && Reload Xbows and Infernos"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(610,42, "Check this to automatically Rearm Traps, Reload Xbows and Infernos (if any) in your Village."))

	  $y += 35
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x - 5, $y, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 45, $y, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnLootCart, $x + 70, $y, 24, 24)
		$g_hChkCollect = GUICtrlCreateCheckbox(GetTranslated(610,43, "Collect Resources && Loot Cart"), $x + 100, $y + 4, -1, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(610,44, "Check this to automatically collect the Village's Resources") & @CRLF & _
							   GetTranslated(610,45, "from Gold Mines, Elixir Collectors and Dark Elixir Drills.") & @CRLF & _
							   GetTranslated(610,46, "This will also search for a Loot Cart in your village and collect it."))
			GUICtrlSetState(-1, $GUI_CHECKED)

	  $y += 35
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTombstone, $x + 32 , $y, 24, 24)
		$g_hChkTombstones = GUICtrlCreateCheckbox(GetTranslated(610,47, "Clear Tombstones"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(610,48, "Check this to automatically clear tombstones after enemy attack."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	  $y += 35
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnTree, $x + 20, $y, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnBark, $x + 45, $y, 24, 24)
		$g_hChkCleanYard = GUICtrlCreateCheckbox(GetTranslated(610,49, "Remove Obstacles"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(610,50, "Check this to automatically clear Yard from Trees, Trunks, etc."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	  $y += 35
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGembox, $x + 32, $y, 24, 24)
		$g_hChkGemsBox = GUICtrlCreateCheckbox(GetTranslated(610,51, "Remove GemBox"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(610,52, "Check this to automatically clear GemBox."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)

   GUICtrlCreateGroup("", -99, -99, 1, 1)


   Local $x = 20, $y = 345
   GUICtrlCreateGroup(GetTranslated(610,53, "Locate Manually"), $x - 15, $y - 20, 440, 65)
		Local $sTxtRelocate = GetTranslated(610,55, "Relocate your") & " "
		$X -= 11
		$y += 0
		GUICtrlCreateButton(GetTranslated(610,54, "Townhall"), $x, $y, 36, 36, $BS_ICON)
			GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnTH11, 1)
			_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslated(610,54, -1))
			GUICtrlSetOnEvent(-1, "btnLocateTownHall")

		$x += 38
		GUICtrlCreateButton(GetTranslated(610,56, "Clan Castle"), $x, $y, 36, 36, $BS_ICON)
			GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnCC, 1)
			_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslated(610,56, -1))
			GUICtrlSetOnEvent(-1, "btnLocateClanCastle")

;~ 		$x += 38
;~ 		GUICtrlCreateButton(GetTranslated(610,57, "A.C."), $x, $y, 36, 36, $BS_ICON)
;~ 			GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnCamp, 1)
;~ 			_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslated(610,58, "Army Camp"))
;~ 			GUICtrlSetOnEvent(-1, "btnLocateArmyCamp")

;~ 		$x += 38
;~ 		GUICtrlCreateButton(GetTranslated(610,59, "Bar."), $x, $y, 36, 36, $BS_ICON)
;~ 			GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBarrack, 1)
;~ 			_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslated(610,60, "Barrack"))
;~ 			GUICtrlSetOnEvent(-1, "btnLocateBarracks")

;~ 		$x += 38
;~ 		$g_hBtnLocateSpellfactory = GUICtrlCreateButton(GetTranslated(610,61, "S.F."), $x, $y, 36, 36, $BS_ICON)
;~ 			GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnSpellFactory, 1)
;~ 			_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslated(610,62, "Spell Factory"))
;~ 			GUICtrlSetOnEvent(-1, "btnLocateSpellfactory")

;~ 		$x += 38
;~ 		$g_hBtnLocateDarkSpellFactory = GUICtrlCreateButton(GetTranslated(610,63, "D.S.F."), $x, $y, 36, 36, $BS_ICON)
;~ 			GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnDarkSpellFactory, 1)
;~ 			_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslated(610,64, "Dark Spell Factory"))
;~ 			GUICtrlSetOnEvent(-1, "btnLocateDarkSpellfactory")

		$x += 38
		$g_hBtnLocateKingAltar = GUICtrlCreateButton(GetTranslated(610,65, "King"), $x, $y, 36, 36, $BS_ICON)
			GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnKingBoostLocate)
			_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslated(610,66, "Barbarian King Altar"))
			GUICtrlSetOnEvent(-1, "btnLocateKingAltar")

	    $x += 38
		$g_hBtnLocateQueenAltar = GUICtrlCreateButton(GetTranslated(610,67, "Queen"), $x, $y, 36, 36, $BS_ICON)
			GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnQueenBoostLocate)
			_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslated(610,68, "Archer Queen Altar"))
			GUICtrlSetOnEvent(-1, "btnLocateQueenAltar")

		$x += 38
		$g_hBtnLocateWardenAltar = GUICtrlCreateButton(GetTranslated(610,69, "Grand Warden"), $x, $y, 36, 36, $BS_ICON)
			GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnWardenBoostLocate)
			_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslated(610,70, "Grand Warden Altar"))
			GUICtrlSetOnEvent(-1, "btnLocateWardenAltar")

		$x += 38
		$g_hBtnLocateLaboratory = GUICtrlCreateButton(GetTranslated(610,71, "Lab."), $x, $y, 36, 36, $BS_ICON)
			GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnLaboratory)
			_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslated(610,72, "Laboratory"))
			GUICtrlSetOnEvent(-1, "btnLab")

		$x += 205
		GUICtrlCreateButton(GetTranslated(610,73, "Reset."), $x, $y, 36, 36, $BS_ICON)
			GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBldgX)
			_GUICtrlSetTip(-1, GetTranslated(610,74, "Click here to reset all building locations,") & @CRLF & _
							   GetTranslated(610,75, "when you have changed your village layout."))
			GUICtrlSetOnEvent(-1, "btnResetBuilding")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
