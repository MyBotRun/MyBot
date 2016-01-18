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
; Misc Tab
;~ -------------------------------------------------------------
$tabMisc = GUICtrlCreateTabItem(GetTranslated(7,1, "Misc"))
Local $x = 30, $y = 150
	$grpControls = GUICtrlCreateGroup(GetTranslated(7,2, "Halt Attack"), $x - 20, $y - 20, 450, 50)
		$chkBotStop = GUICtrlCreateCheckbox("", $x - 5, $y, 16, 16)
			$txtTip = GetTranslated(7,3, "Use these options to set when the bot will stop attacking.")
			GUICtrlSetTip(-1, $txtTip)
		$cmbBotCommand = GUICtrlCreateCombo("", $x + 20, $y - 3, 90, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, GetTranslated(7,4, "Halt Attack") & "|" & GetTranslated(7,5, "Shutdown PC") & "|" & GetTranslated(7,6, "Sleep PC") & "|" & GetTranslated(7,7, "Reboot PC"), GetTranslated(7,4, -1))
		$lblBotCond = GUICtrlCreateLabel(GetTranslated(7,88, "When..."), $x + 125, $y, 45, 17)
		$cmbBotCond = GUICtrlCreateCombo("", $x + 175, $y - 3, 160, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, GetTranslated(7,8, "G and E Full and Max.Trophy") & "|" & GetTranslated(7,9, "(G and E) Full or Max.Trophy") & "|" & GetTranslated(7,10, "(G or E) Full and Max.Trophy") & "|" & GetTranslated(7,11, "G or E Full or Max.Trophy") & "|" & GetTranslated(7,12, "Gold and Elixir Full") & "|" & GetTranslated(7,13, "Gold or Elixir Full") & "|" & GetTranslated(7,14, "Gold Full and Max.Trophy") & "|" & GetTranslated(7,15, "Elixir Full and Max.Trophy") & "|" & GetTranslated(7,16, "Gold Full or Max.Trophy") & "|" & GetTranslated(7,17, "Elixir Full or Max.Trophy") & "|" & GetTranslated(7,18, "Gold Full") & "|" & GetTranslated(7,19, "Elixir Full") & "|" & GetTranslated(7,20, "Reach Max. Trophy") & "|" & GetTranslated(7,21, "Bot running for...") & "|" & GetTranslated(7,89, "Now (Train/Donate Only)") & "|" & GetTranslated(7,22, "Now (Donate Only)") & "|" & GetTranslated(7,23, "Now (Only stay online)") , GetTranslated(7,89, -1))
			GUICtrlSetOnEvent(-1, "cmbBotCond")
		$cmbHoursStop = GUICtrlCreateCombo("", $x + 335, $y - 3, 80, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			$sTxtHours = GetTranslated(7,25, "Hours")
			GUICtrlSetData(-1, "-|1 " & GetTranslated(7,24, "Hour") & "|2 " & $sTxtHours & "|3 " & $sTxtHours & "|4 " & $sTxtHours & "|5 " & $sTxtHours & "|6 " & $sTxtHours & "|7 " & $sTxtHours & "|8 " & $sTxtHours & "|9 " & $sTxtHours & "|10 " & $sTxtHours & "|11 " & $sTxtHours & "|12 " & $sTxtHours& "|13 " & $sTxtHours & "|14 " & $sTxtHours & "|15 " & $sTxtHours & "|16 " & $sTxtHours & "|17 " & $sTxtHours & "|18 " & $sTxtHours & "|19 " & $sTxtHours & "|20 " & $sTxtHours & "|21 " & $sTxtHours & "|22 " & $sTxtHours & "|23 " & $sTxtHours & "|24 " & $sTxtHours, "-")
			GUICtrlSetState (-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 30, $y = 205
	$grpProfiles = GUICtrlCreateGroup(GetTranslated(7,26, "Switch Profiles"), $x - 20, $y - 20, 225, 45)
		$y -=5
		;$lblProfile = GUICtrlCreateLabel(GetTranslated(7,27, "Current Profile") & ":", $x, $y, -1, -1)
		;$y += 15
		$cmbProfile = GUICtrlCreateCombo("01", $x - 3, $y, 40, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$txtTip = GetTranslated(7,28, "Use this to switch to a different profile")& @CRLF & GetTranslated(7,29, "Your profiles can be found in") & ": " & @CRLF & $sProfilePath
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetData(-1, "02|03|04|05|06", "01")
		GUICtrlSetOnEvent(-1, "cmbProfile")
		$txtVillageName = GUICtrlCreateInput(GetTranslated(7,30, "MyVillage"), $x + 47, $y, 130, 20, BitOR($SS_CENTER, $ES_AUTOHSCROLL))
		GUICtrlSetLimit (-1, 100, 0)
		GUICtrlSetFont(-1, 9, 400, 1)
		GUICtrlSetTip(-1, GetTranslated(7,31, "Your village/profile's name"))
		GUICtrlSetOnEvent(-1, "txtVillageName")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 260, $y = 205
	$grpLanguages = GUICtrlCreateGroup(GetTranslated(7,32, "GUI Language"), $x - 20, $y - 20, 220, 45)
		$y -=5
		$cmbLanguage = GUICtrlCreateCombo("", $x - 3 , $y, 185, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$txtTip = GetTranslated(7,33, "Use this to switch to a different GUI language")
		GUICtrlSetTip(-1, $txtTip)

		LoadLanguagesComboBox() ; full combo box languages reading from languages folders

		GUICtrlSetData(-1, "English", "English") ;default set english language
		GUICtrlSetOnEvent(-1, "cmbLanguage")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 30, $y = 253
	$grpMisc = GUICtrlCreateGroup(GetTranslated(7,90, "Rearm, Collect, Clear"), $x -20, $y - 20 , 225, 115)
	;$grpTraps = GUICtrlCreateGroup(GetTranslated(7,91, "Traps, X-bows && Infernos"), $x -20, $y - 20 , 225, 55)
		GUICtrlCreateIcon($pIconLib, $eIcnTrap, $x - 5, $y, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnXbow, $x + 20, $y, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnInferno, $x + 45, $y, 24, 24)
		$chkTrap = GUICtrlCreateCheckbox(GetTranslated(7,34, "Rearm && Reload"), $x + 75, $y + 2, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(7,35, "Check this to automatically Rearm Traps, Reload Xbows and Infernos (if any) in your Village."))
			GUICtrlSetOnEvent(-1, "chkTrap")
			_ArrayConcatenate($G, $D)
	;GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y += 28
	;Local $x = 30, $y = 335
	;$grpCollect = GUICtrlCreateGroup(GetTranslated(7,92, "Collecting Resources"), $x - 20, $y - 20 , 225, 60)
		GUICtrlCreateIcon($pIconLib, $eIcnMine, $x - 5, $y, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20, $y, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 45, $y, 24, 24)
		$chkCollect = GUICtrlCreateCheckbox(GetTranslated(7,36, "Collect Resources"), $x + 75, $y + 2, -1, -1)
			$txtTip = GetTranslated(7,37, "Check this to automatically collect the Village's Resources") & @CRLF & GetTranslated(7,38, "from Gold Mines, Elixir Collectors and Dark Elixir Drills.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
	;GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y += 28
	;Local $x = 30, $y = 400
	;$grpTombstones = GUICtrlCreateGroup(GetTranslated(7,93, "Clear Tombstones"), $x - 20, $y - 20 , 225, 55)
		GUICtrlCreateIcon($pIconLib, $eIcnTombstone, $x + 20, $y, 24, 24)
		$chkTombstones = GUICtrlCreateCheckbox(GetTranslated(7,39, "Clear Tombstones"), $x + 75, $y + 2, -1, -1)
			$txtTip = GetTranslated(7,40, "Check this to automatically clear tombstones after enemy attack.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 371
	$grpRestartMins = GUICtrlCreateGroup(GetTranslated(7,41, "Resume Bot"), $x - 20, $y - 20 , 225, 89)
		$lblRestartMins = GUICtrlCreateLabel(GetTranslated(7,42, "Resume when reaching these minimal values, if Halted due to low resources."), $x, $y, 110, 50, $BS_MULTILINE)
		$y -= 7
		$lblRestartGold = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
		GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x + 175, $y, 16, 16)
		$txtRestartGold = GUICtrlCreateInput("10000", $x + 120, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(7,43, "Minimum Gold value for the bot to resume attacking after halting because of low gold.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 7)
		$y += 22
		$lblRestartElixir = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
		GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x + 175, $y, 16, 16)
		$txtRestartElixir = GUICtrlCreateInput("25000", $x + 120, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(7,44, "Minimum Elixir value for the bot to resume attacking after halting because of low elixir.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 7)
		$y += 22
		$lblRestartDark = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
		GUICtrlCreateIcon ($pIconLib, $eIcnDark, $x + 175, $y, 16, 16)
		$txtRestartDark = GUICtrlCreateInput("500", $x + 120, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(7,45, "Minimum Dark Elixir value for the bot to resume attacking after halting because of low dark elixir.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 260, $y = 253
	$grpTrophy = GUICtrlCreateGroup(GetTranslated(7,46, "Trophy Settings"), $x - 20, $y - 20, 220, 88)
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 12, $y + 17, 24, 24)
		$lblTrophyRange = GUICtrlCreateLabel(GetTranslated(7,47, "Trophy range") & ":", $x + 20, $y, -1, -1)
		$txtdropTrophy = GUICtrlCreateInput("5000", $x + 110, $y - 5, 35, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(7,48, "MIN: The Bot will drop trophies until below this value.")
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetTip(-1, $txtTip)
		$lblDash = GUICtrlCreateLabel(" - ", $x + 148, $y, -1, -1)
		$txtMaxTrophy = GUICtrlCreateInput("5000", $x + 160, $y - 5, 35, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(7,49, "MAX: The Bot will drop trophies if your trophy count is greater than this value.")
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetTip(-1, $txtTip)
		$y += 18
		$x += 20
		$chkTrophyHeroes = GUICtrlCreateCheckbox(GetTranslated(7,50, "Use Heroes"), $x, $y, -1, -1)
			$txtTip = GetTranslated(7,51, "Use Heroes to drop Trophies if Heroes are available.")
			GUICtrlSetTip(-1, $txtTip)
		$chkTrophyAtkDead = GUICtrlCreateCheckbox(GetTranslated(7,52, "Atk Dead Bases"), $x + 80, $y, -1, -1)
			$txtTip = GetTranslated(7,53, "Attack a Deadbase found on the first search while dropping Trophies.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkTrophyAtkDead")
		$y += 24
		$x += 10
		$lblDTArmyMin = GUICtrlCreateLabel(GetTranslated(7,96, "Drop Trophy Army Min") & ":", $x - 10, $y + 2, -1, -1)
		$txtTip = GetTranslated(7,97, "Enter the percent of full army required for dead base attack before starting trophy drop.")
			GUICtrlSetTip(-1, $txtTip)
		$txtDTArmyMin = GUICtrlCreateInput("70", $x + 100, $y - 1, 27, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState (-1, $GUI_DISABLE)
		$lblDTArmypercent = GUICtrlCreateLabel(GetTranslated(7,98, "%"), $x + 130, $y + 2, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 260, $y = 343
	$grpTimeWakeUp = GUICtrlCreateGroup(GetTranslated(7,54, "Remote Device"), $x - 20, $y - 20 , 220, 42)
		$y -= 5
		$lblTimeWakeUp = GUICtrlCreateLabel(GetTranslated(7,55, "When 'Another Device' wait") & ":", $x - 10, $y + 2, -1, -1)
		$txtTip = GetTranslated(7,56, "Enter the time to wait (in seconds) before the Bot reconnects when another device took control.")
			GUICtrlSetTip(-1, $txtTip)
		$txtTimeWakeUp = GUICtrlCreateInput("120", $x + 127, $y - 1, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
		$lblTimeWakeUpSec = GUICtrlCreateLabel(GetTranslated(7,57, "sec."), $x + 165, $y + 2, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 260, $y = 388
	$grpVSDelay = GUICtrlCreateGroup(GetTranslated(7,58, "Village Search Delay"), $x - 20, $y - 20, 220, 72)
		$txtTip = GetTranslated(7,59, "Use this slider to change the time to wait between Next clicks when searching for a Village to Attack.") & @CRLF & GetTranslated(7,60, "This might compensate for Out of Sync errors on some PC's.") & @CRLF & GetTranslated(7,61, "NO GUARANTEES! This will not always have the same results!")
		$lblVSDelay0 = GUICtrlCreateLabel(GetTranslated(7,62, "Min"), $x-25, $y-2, 30, 15, $SS_RIGHT)
			GUICtrlSetTip(-1, $txtTip)
		$lblVSDelay = GUICtrlCreateLabel("0", $x+7, $y-2, 12, 15, $SS_RIGHT)
			GUICtrlSetTip(-1, $txtTip)
		$lbltxtVSDelay = GUICtrlCreateLabel(GetTranslated(7,63, "seconds"), $x + 23, $y-2, -1, -1)
		$sldVSDelay = GUICtrlCreateSlider($x + 62, $y - 4, 118, 25, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 10, 0) ; change max/min value
			GUICtrlSetData(-1, 0) ; default value
			GUICtrlSetOnEvent(-1, "sldVSDelay")
		$y += 25
		$lblMaxVSDelay0 = GUICtrlCreateLabel(GetTranslated(7,64, "Max"), $x-23, $y-2, 30, 15, $SS_RIGHT)
			$txtTip = GetTranslated(7,65, "Enable random village search delay value by setting") & @CRLF & GetTranslated(7,66, "bottom Max slide value higher than the top minimum slide")
			GUICtrlSetTip(-1, $txtTip)
		$lblMaxVSDelay = GUICtrlCreateLabel("0", $x+7, $y-2, 12, 15, $SS_RIGHT)
			GUICtrlSetTip(-1, $txtTip)
		$lbltxtMaxVSDelay = GUICtrlCreateLabel(GetTranslated(7,63, -1), $x + 23, $y-2, 45, -1)
		$sldMaxVSDelay = GUICtrlCreateSlider($x + 62, $y - 4, 137, 25, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 12, 0) ; change max/min value
			GUICtrlSetData(-1, 0) ; default value
			GUICtrlSetOnEvent(-1, "sldMaxVSDelay")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 462
	$grpLocateBuildings = GUICtrlCreateGroup(GetTranslated(7,67, "Locate Manually"), $x - 20, $y - 20, 450, 65)
		$btnLocateTownHall = GUICtrlCreateButton(GetTranslated(7,68, "Townhall"), $x - 10, $y, 40, 40, $BS_ICON)
			GUICtrlSetImage(-1, $pIconLib, $eIcnTH10, 1)
			$sTxtRelocate = GetTranslated(7,69, "Relocate your")
			$txtTip =  $sTxtRelocate & " " & GetTranslated(7,68, -1)
			GUICtrlSetTip(-1, $txtTip)
			;GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetOnEvent(-1, "btnLocateTownHall")
		$btnLocateClanCastle = GUICtrlCreateButton(GetTranslated(7,70, "Clan Castle"), $x + 30, $y, 40, 40, $BS_ICON)
			GUICtrlSetOnEvent(-1, "btnLocateClanCastle")
			GUICtrlSetImage(-1, $pIconLib, $eIcnCC, 1)
			$txtTip = $sTxtRelocate & " " & GetTranslated(7,70, -1)
			GUICtrlSetTip(-1, $txtTip)
		$btnLocateArmyCamp = GUICtrlCreateButton(GetTranslated(7,71, "A.C."), $x + 70, $y, 40, 40, $BS_ICON)
			GUICtrlSetOnEvent(-1, "btnLocateArmyCamp")
			GUICtrlSetImage(-1, $pIconLib, $eIcnCamp, 1)
			$txtTip = $sTxtRelocate & " " & GetTranslated(7,72, "Army Camp")
			GUICtrlSetTip(-1, $txtTip)
		$btnLocateBarracks = GUICtrlCreateButton(GetTranslated(7,73, "Bar."), $x + 110, $y, 40, 40, $BS_ICON)
			GUICtrlSetOnEvent(-1, "btnLocateBarracks")
			GUICtrlSetImage(-1, $pIconLib, $eIcnBarrack, 1)
			$txtTip = $sTxtRelocate & " " & GetTranslated(7,74, "Barrack")
			GUICtrlSetTip(-1, $txtTip)
	    $btnLocateSpellFactory = GUICtrlCreateButton(GetTranslated(7,75, "S.F."), $x + 150, $y, 40, 40, $BS_ICON)
			GUICtrlSetOnEvent(-1, "btnLocateSpellfactory")
			GUICtrlSetImage(-1, $pIconLib, $eIcnSpellFactory, 1)
			$txtTip = $sTxtRelocate & " " & GetTranslated(7,76, "Spell Factory")
			GUICtrlSetTip(-1, $txtTip)
			_ArrayConcatenate($G, $T)
		 $btnLocateSpellFactory = GUICtrlCreateButton(GetTranslated(7,77, "D.S.F."), $x + 190, $y, 40, 40, $BS_ICON)
			GUICtrlSetOnEvent(-1, "btnLocateDarkSpellfactory")
			GUICtrlSetImage(-1, $pIconLib, $eIcnDarkSpellFactory, 1)
			$txtTip = $sTxtRelocate & " " & GetTranslated(7,78, "Dark Spell Factory")
			GUICtrlSetTip(-1, $txtTip)
			_ArrayConcatenate($G, $T)
		$btnLocateKingAltar = GUICtrlCreateButton(GetTranslated(7,79, "King"), $x + 230, $y, 40, 40, $BS_ICON)
			GUICtrlSetImage(-1, $pIconLib, $eIcnKingBoostLocate)
			$txtTip = $sTxtRelocate & " " & GetTranslated(7,80, "Barbarian King Altar")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnLocateKingAltar")
		$btnLocateQueenAltar = GUICtrlCreateButton(GetTranslated(7,81, "Queen"), $x + 270, $y, 40, 40, $BS_ICON)
			GUICtrlSetImage(-1, $pIconLib, $eIcnQueenBoostLocate)
			$txtTip = $sTxtRelocate & " " & GetTranslated(7,82, "Archer Queen Altar")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnLocateQueenAltar")
		$btnLocateWardenAltar = GUICtrlCreateButton(GetTranslated(7,94, "Grand Warden"), $x + 310, $y, 40, 40, $BS_ICON)
			GUICtrlSetImage(-1, $pIconLib, $eIcnWardenBoostLocate)
			$txtTip = $sTxtRelocate & " " & GetTranslated(7,95, "Grand Warden Altar")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnLocateWardenAltar")
		$btnLocateLaboratory = GUICtrlCreateButton(GetTranslated(7,83, "Lab."), $x + 350, $y, 40, 40, $BS_ICON)
			GUICtrlSetImage(-1, $pIconLib, $eIcnLaboratory)
			$txtTip = $sTxtRelocate & " " & GetTranslated(7,84, "Laboratory")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnLab")
		$btnResetBuilding = GUICtrlCreateButton(GetTranslated(7,85, "Reset."), $x + 390, $y, 40, 40, $BS_ICON)
			GUICtrlSetImage(-1, $pIconLib, $eIcnBldgX)
			$txtTip = GetTranslated(7,86, "Click here to reset all building locations,") & @CRLF & GetTranslated(7,87, "when you have changed your village layout.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnResetBuilding")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
