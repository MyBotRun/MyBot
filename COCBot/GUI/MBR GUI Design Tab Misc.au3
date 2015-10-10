; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
; Misc Tab
;~ -------------------------------------------------------------
$tabMisc = GUICtrlCreateTabItem("Misc")
Local $x = 30, $y = 150
	$grpControls = GUICtrlCreateGroup("Halt Attack", $x - 20, $y - 20, 450, 50)
		$chkBotStop = GUICtrlCreateCheckbox("", $x - 5, $y, 16, 16)
			$txtTip = "Use these options to set when the bot will stop attacking."
			GUICtrlSetTip(-1, $txtTip)
		$cmbBotCommand = GUICtrlCreateCombo("", $x + 20, $y - 3, 90, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "Halt Attack|Shutdown PC|Sleep PC|Reboot PC", "Halt Attack")
		$lblBotCond = GUICtrlCreateLabel("When...", $x + 125, $y, 45, 17)
		$cmbBotCond = GUICtrlCreateCombo("", $x + 175, $y - 3, 160, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "G and E Full and Max.Trophy|(G and E) Full or Max.Trophy|(G or E) Full and Max.Trophy|G or E Full or Max.Trophy|Gold and Elixir Full|Gold or Elixir Full|Gold Full and Max.Trophy|Elixir Full and Max.Trophy|Gold Full or Max.Trophy|Elixir Full or Max.Trophy|Gold Full|Elixir Full|Reach Max. Trophy|Bot running for...|Now (Train/Donate Only)|Now (Donate Only)|Now (Only stay online)", "Now (Train/Donate Only)")
			GUICtrlSetOnEvent(-1, "cmbBotCond")
		$cmbHoursStop = GUICtrlCreateCombo("", $x + 335, $y - 3, 80, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "-|1 Hour|2 Hours|3 Hours|4 Hours|5 Hours|6 Hours|7 Hours|8 Hours|9 Hours|10 Hours|11 Hours|12 Hours|13 Hours|14 Hours|15 Hours|16 Hours|17 Hours|18 Hours|19 Hours|20 Hours|21 Hours|22 Hours|23 Hours|24 Hours", "-")
			GUICtrlSetState (-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 30, $y = 205
	$grpControls = GUICtrlCreateGroup("Profiles", $x - 20, $y - 20, 450, 55)
		$lblProfile = GUICtrlCreateLabel("Current Profile:", $x, $y, -1, -1)
		$cmbProfile = GUICtrlCreateCombo("01", $x + 75, $y - 5, 40, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$txtTip = "Use this to switch to a different profile. Default: 01" & @CRLF & "Your profiles/configs can be found in:" & @CRLF &  $sProfilePath
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetData(-1, "02|03|04|05|06", "01")
		GUICtrlSetOnEvent(-1, "cmbProfile")
		$txtVillageName = GUICtrlCreateInput("MyVillage", $x + 120, $y - 4, 130, 18, BitOR($SS_CENTER, $ES_AUTOHSCROLL))
		GUICtrlSetLimit (-1, 100, 0)
		GUICtrlSetFont(-1, 9, 400, 1)
		GUICtrlSetTip(-1, "Your village/profile's name")
		GUICtrlSetOnEvent(-1, "txtVillageName")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 265
	$grpMisc = GUICtrlCreateGroup("Rearm, Collect, Clear", $x -20, $y - 20 , 225, 100)
	;$grpTraps = GUICtrlCreateGroup("Traps, X-bows && Infernos", $x -20, $y - 20 , 225, 55)
		GUICtrlCreateIcon($pIconLib, $eIcnTrap, $x - 5, $y, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnXbow, $x + 20, $y, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnInferno, $x + 45, $y, 24, 24)
		$chkTrap = GUICtrlCreateCheckbox("Rearm && Reload", $x + 75, $y + 2, -1, -1)
			GUICtrlSetTip(-1, "Check this to automatically Rearm Traps, Reload Xbows and Infernos (if any) in your Village.")
			GUICtrlSetOnEvent(-1, "chkTrap")
			_ArrayConcatenate($G, $D)
	;GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y += 25
	;Local $x = 30, $y = 335
	;$grpCollect = GUICtrlCreateGroup("Collecting Resources", $x - 20, $y - 20 , 225, 60)
		GUICtrlCreateIcon($pIconLib, $eIcnMine, $x - 5, $y, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20, $y, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 45, $y, 24, 24)
		$chkCollect = GUICtrlCreateCheckbox("Collect Resources", $x + 75, $y + 2, -1, -1)
			$txtTip = "Check this to automatically collect the Village's Resources" & @CRLF & " from Gold Mines, Elixir Collectors and Dark Elixir Drills."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
	;GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y += 25
	;Local $x = 30, $y = 400
	;$grpTombstones = GUICtrlCreateGroup("Clear Tombstones", $x - 20, $y - 20 , 225, 55)
		GUICtrlCreateIcon($pIconLib, $eIcnTombstone, $x + 20, $y, 24, 24)
		$chkTombstones = GUICtrlCreateCheckbox("Clear Tombstones", $x + 75, $y + 2, -1, -1)
			$txtTip = "Check this to automatically clear tombstones after enemy attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 375
	$grpRestartMins = GUICtrlCreateGroup("Resume Bot", $x - 20, $y - 20 , 225, 85)
		$lblRestartMins = GUICtrlCreateLabel("Resume when reaching these minimal values, if Halted due to low resources.", $x, $y, 110, 50, $BS_MULTILINE)
		$y -= 7
		$lblRestartGold = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
		GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x + 175, $y, 16, 16)
		$txtRestartGold = GUICtrlCreateInput("10000", $x + 120, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Minimum Gold value for the bot to resume attacking after halting because of low gold."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 7)
		$y += 20
		$lblRestartElixir = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
		GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x + 175, $y, 16, 16)
		$txtRestartElixir = GUICtrlCreateInput("25000", $x + 120, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Minimum Elixir value for the bot to resume attacking after halting because of low elixir."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 7)
		$y += 20
		$lblRestartDark = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
		GUICtrlCreateIcon ($pIconLib, $eIcnDark, $x + 175, $y, 16, 16)
		$txtRestartDark = GUICtrlCreateInput("500", $x + 120, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Minimum Dark Elixir value for the bot to resume attacking after halting because of low dark elixir."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 260, $y = 265
	$grpTrophy = GUICtrlCreateGroup("Trophy Settings", $x - 20, $y - 20, 220, 65)
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 10, $y + 5, 24, 24)
		$lblTrophyRange = GUICtrlCreateLabel("Trophy range:", $x + 20, $y, -1, -1)
		$txtdropTrophy = GUICtrlCreateInput("5000", $x + 110, $y - 5, 35, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "MIN: The Bot will drop trophies until below this value."
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetTip(-1, $txtTip)
		$lblDash = GUICtrlCreateLabel(" - ", $x + 148, $y, -1, -1)
		$txtMaxTrophy = GUICtrlCreateInput("5000", $x + 160, $y - 5, 35, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "MAX: The Bot will drop trophies if your trophy count is greater than this value."
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetTip(-1, $txtTip)
		$chkTrophyHeroes = GUICtrlCreateCheckbox("Use Heroes", $x + 20, $y + 20, -1, -1)
			$txtTip = "Use Heroes to drop Trophies if Heroes are available."
			GUICtrlSetTip(-1, $txtTip)
		$chkTrophyAtkDead = GUICtrlCreateCheckbox("Atk Dead Bases", $x + 100, $y + 20, -1, -1)
			$txtTip = "Attack a Deadbase found on the first search while dropping Trophies."
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 260, $y = 335
	$grpTimeWakeUp = GUICtrlCreateGroup("Remote Device", $x - 20, $y - 20 , 220, 50)
		$lblTimeWakeUp = GUICtrlCreateLabel("When 'Another Device' wait:", $x, $y + 2, -1, -1)
		$txtTip = "Enter the time to wait (in seconds) before the Bot reconnects when another device took control."
			GUICtrlSetTip(-1, $txtTip)
		$txtTimeWakeUp = GUICtrlCreateInput("120", $x + 138, $y - 1, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
		$lblTimeWakeUpSec = GUICtrlCreateLabel("sec.", $x + 175, $y + 2, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 260, $y = 388
	$grpVSDelay = GUICtrlCreateGroup("Village Search Delay ", $x - 20, $y - 20, 220, 72)
		$txtTip = "Use this slider to change the time to wait between Next clicks when searching for a Village to Attack." & @CRLF & "This might compensate for Out of Sync errors on some PC's." & @CRLF & "NO GUARANTEES! This will not always have the same results!"
		$lblVSDelay0 = GUICtrlCreateLabel("Min", $x-25, $y-2, 30, 15, $SS_RIGHT)
			GUICtrlSetTip(-1, $txtTip)
		$lblVSDelay = GUICtrlCreateLabel("0", $x+7, $y-2, 12, 15, $SS_RIGHT)
			GUICtrlSetTip(-1, $txtTip)
		$lbltxtVSDelay = GUICtrlCreateLabel("seconds", $x + 23, $y-2, -1, -1)
		$sldVSDelay = GUICtrlCreateSlider($x + 62, $y - 4, 118, 25, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1, 1)
			GUICtrlSetLimit(-1, 10, 0) ; change max/min value
			GUICtrlSetData(-1, 0) ; default value
			GUICtrlSetOnEvent(-1, "sldVSDelay")
		$y += 25
		$lblMaxVSDelay0 = GUICtrlCreateLabel("Max", $x-23, $y-2, 30, 15, $SS_RIGHT)
			$txtTip = "Enable random village search delay value by setting" &@CRLF&"bottom Max slide value higher than the top minimum slide"
			GUICtrlSetTip(-1, $txtTip)
		$lblMaxVSDelay = GUICtrlCreateLabel("0", $x+7, $y-2, 12, 15, $SS_RIGHT)
			GUICtrlSetTip(-1, $txtTip)
		$lbltxtMaxVSDelay = GUICtrlCreateLabel("seconds", $x + 23, $y-2, 45, -1)
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
	$grpLocateBuildings = GUICtrlCreateGroup("Locate Manually", $x - 20, $y - 20, 450, 65)
		$btnLocateTownHall = GUICtrlCreateButton("Townhall", $x - 10, $y, 40, 40, $BS_ICON)
			GUICtrlSetImage(-1, $pIconLib, $eIcnTH10, 1)
			$txtTip = "Relocate your Townhall."
			GUICtrlSetTip(-1, $txtTip)
			;GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetOnEvent(-1, "btnLocateTownHall")
		$btnLocateClanCastle = GUICtrlCreateButton("Clan Castle", $x + 30, $y, 40, 40, $BS_ICON)
			GUICtrlSetOnEvent(-1, "btnLocateClanCastle")
			GUICtrlSetImage(-1, $pIconLib, $eIcnCC, 1)
			$txtTip = "Relocate your Clan Castle."
			GUICtrlSetTip(-1, $txtTip)
		$btnLocateArmyCamp = GUICtrlCreateButton("A.C.", $x + 70, $y, 40, 40, $BS_ICON)
			GUICtrlSetOnEvent(-1, "btnLocateArmyCamp")
			GUICtrlSetImage(-1, $pIconLib, $eIcnCamp, 1)
			$txtTip = "Relocate your Army Camp."
			GUICtrlSetTip(-1, $txtTip)
		$btnLocateBarracks = GUICtrlCreateButton("Bar.", $x + 110, $y, 40, 40, $BS_ICON)
			GUICtrlSetOnEvent(-1, "btnLocateBarracks")
			GUICtrlSetImage(-1, $pIconLib, $eIcnBarrack, 1)
			$txtTip = "Relocate your Barrack."
			GUICtrlSetTip(-1, $txtTip)
	    $btnLocateSpellFactory = GUICtrlCreateButton("S.F.", $x + 150, $y, 40, 40, $BS_ICON)
			GUICtrlSetOnEvent(-1, "btnLocateSpellfactory")
			GUICtrlSetImage(-1, $pIconLib, $eIcnSpellFactory, 1)
			$txtTip = "Relocate your Spell Factory."
			GUICtrlSetTip(-1, $txtTip)
			_ArrayConcatenate($G, $T)
		 $btnLocateSpellFactory = GUICtrlCreateButton("D.S.F.", $x + 190, $y, 40, 40, $BS_ICON)
			GUICtrlSetOnEvent(-1, "btnLocateDarkSpellfactory")
			GUICtrlSetImage(-1, $pIconLib, $eIcnDarkSpellFactory, 1)
			$txtTip = "Relocate your Dark Spell Factory."
			GUICtrlSetTip(-1, $txtTip)
			_ArrayConcatenate($G, $T)
		$btnLocateLaboratory = GUICtrlCreateButton("King", $x + 230, $y, 40, 40, $BS_ICON)
			GUICtrlSetImage(-1, $pIconLib, $eIcnKingBoostLocate)
			$txtTip = "Relocate your Barbarian King Altar"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnLocateKingAltar")
		$btnLocateLaboratory = GUICtrlCreateButton("Queen", $x + 270, $y, 40, 40, $BS_ICON)
			GUICtrlSetImage(-1, $pIconLib, $eIcnQueenBoostLocate)
			$txtTip = "Relocate your Archer Queen Altar"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnLocateQueenAltar")
		$btnLocateLaboratory = GUICtrlCreateButton("Lab.", $x + 310, $y, 40, 40, $BS_ICON)
			GUICtrlSetImage(-1, $pIconLib, $eIcnLaboratory)
			$txtTip = "Relocate your Laboratory."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnLab")
		$btnResetBuilding = GUICtrlCreateButton("Reset.", $x + 380, $y, 40, 40, $BS_ICON)
			GUICtrlSetImage(-1, $pIconLib, $eIcnBldgX)
			$txtTip = "Click here it reset all building locations," & @CRLF & "like when you have changed base layout"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnResetBuilding")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
