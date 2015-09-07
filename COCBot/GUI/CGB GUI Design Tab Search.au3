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
;~ Search Tab
;~ -------------------------------------------------------------

$tabSearch = GUICtrlCreateTabItem("Search")
	Local $x = 30, $y = 150
	$grpSearchMode = GUICtrlCreateGroup("Search Mode", $x - 20, $y - 20, 225, 55)
		$cmbSearchMode = GUICtrlCreateCombo("", $x , $y, 190, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = "Only Deadbases: full collectors. Most loot outside of village." & @CRLF & _
						"Only LiveBases: full storages. Most loot inside of village." & @CRLF & "Dual Mode: Search for both, whatever comes first is attacked."
			GUICtrlSetData(-1, "Only DeadBases|Only LiveBases|Both DeadBases and LiveBases", "Only DeadBases")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "cmbSearchMode")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 260
	$grpAlert = GUICtrlCreateGroup("Alert", $x - 20, $y - 20, 220, 55)
		$chkAlertSearch = GUICtrlCreateCheckbox("Alert me when a Base is found.", $x, $y, -1, -1, $BS_MULTILINE)
			GUICtrlSetTip(-1, "Check this if you want an Audio alarm & a Balloon Tip when a Base to attack is found.")
			GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 210
	$grpDeadBaseConditions = GUICtrlCreateGroup("DeadBase Conditions", $x - 20, $y - 20, 225, 255)
		$chkDBEnableAfter = GUICtrlCreateCheckbox("Delay Start:", $x, $y, -1, -1)
			$txtTip = "Search for a Dead Base after this No. of searches, start searching for Live Bases first.."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkDBEnableAfter")
			GUICtrlSetState(-1, $GUI_HIDE)
		$txtDBEnableAfter = GUICtrlCreateInput("150", $x + 80, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "No. of searches to wait before activating this mode."
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetTip(-1, $txtTip)
			_GUICtrlEdit_SetReadOnly(-1, True)
			GUICtrlSetState(-1, $GUI_HIDE)
		$lblDBEnableAfter = GUICtrlCreateLabel("search(es).", $x + 132, $y + 4, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$y += 21
		$cmbDBMeetGE = GUICtrlCreateCombo("", $x , $y + 10, 65, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = "Search for a base that meets the values set for Gold And/Or/Plus Elixir." & @CRLF & "AND: Both conditions must meet, Gold and Elixir." & @CRLF & "OR: One condition must meet, Gold or Elixir." & @CRLF & "+ (PLUS): Total amount of Gold + Elixir must meet."
			GUICtrlSetData(-1, "G And E|G Or E|G + E", "G And E")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "cmbDBGoldElixir")
		$txtDBMinGold = GUICtrlCreateInput("80000", $x + 80, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Set the Min. amount of Gold to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picDBMinGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 131, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$txtDBMinElixir = GUICtrlCreateInput("80000", $x + 80, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Set the Min. amount of Elixir to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picDBMinElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 131, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$y -= 11
		$txtDBMinGoldPlusElixir = GUICtrlCreateInput("160000", $x + 80, $y, 50, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Set the Min. amount of Gold + Elixir to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState (-1, $GUI_HIDE)
		$picDBMinGPEGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 131, $y + 1, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$lblDBMinGPE = GUICtrlCreateLabel("+", $x + 147, $y + 1, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$picDBMinGPEElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 153, $y + 1, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$y += 31
		$chkDBMeetDE = GUICtrlCreateCheckbox("Dark Elixir", $x , $y, -1, -1)
			$txtTip = "Search for a base that meets the value set for Min. Dark Elixir."
			GUICtrlSetOnEvent(-1, "chkDBMeetDE")
			GUICtrlSetTip(-1, $txtTip)
		$txtDBMinDarkElixir = GUICtrlCreateInput("0", $x + 80, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Set the Min. amount of Dark Elixir to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
			_GUICtrlEdit_SetReadOnly(-1, True)
		$picDBMinDarkElixir = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 131, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$chkDBMeetTrophy = GUICtrlCreateCheckbox("Trophies", $x, $y, -1, -1)
			$txtTip = "Search for a base that meets the value set for Min. Trophies."
			GUICtrlSetOnEvent(-1, "chkDBMeetTrophy")
			GUICtrlSetTip(-1, $txtTip)
		$txtDBMinTrophy = GUICtrlCreateInput("0", $x + 80, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Set the Min. amount of Trophies to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			_GUICtrlEdit_SetReadOnly(-1, True)
			GUICtrlSetLimit(-1, 2)
		$picDBMinTrophies = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 131, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$chkDBMeetTH = GUICtrlCreateCheckbox("Townhall", $x, $y, -1, -1)
			$txtTip = "Search for a base that meets the value set for Max. Townhall Level."
			GUICtrlSetOnEvent(-1, "chkDBMeetTH")
			GUICtrlSetTip(-1, $txtTip)
		$cmbDBTH = GUICtrlCreateCombo("", $x + 80, $y - 1, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = "Set the Max. level of the Townhall to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetData(-1, "4-6|7|8|9|10", "4-6")
		$picDBMaxTH1 = GUICtrlCreateIcon($pIconLib, $eIcnTH1, $x + 131, $y - 3, 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$lblDBMaxTH = GUICtrlCreateLabel("-", $x + 156, $y + 1, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
		$picDBMaxTH10 = GUICtrlCreateIcon($pIconLib, $eIcnTH10, $x + 160, $y - 3, 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$chkDBMeetTHO = GUICtrlCreateCheckbox("Townhall Outside", $x, $y, -1, -1)
			$txtTip = "Search for a base that has an exposed Townhall. (Outside of Walls)"
			GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$chkDBWeakBase = GUICtrlCreateCheckbox("WeakBase", $x, $y, -1, -1)
			$txtTip = "Search for a base that has low defences."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkDBWeakBase")
		$cmbDBWeakMortar = GUICtrlCreateCombo("", $x + 80, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = "Set the Max. level of the Mortar to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 5")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picDBWeakMortar = GUICtrlCreateIcon($pIconLib, $eIcnMortar, $x + 131, $y - 3, 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$y +=23
		$cmbDBWeakWizTower = GUICtrlCreateCombo("", $x + 80, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = "Set the Max. level of the Wizard Tower to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 4")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picDBWeakWizTower = GUICtrlCreateIcon($pIconLib, $eIcnWizTower, $x + 131, $y - 2, 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$y += 30
		$chkDBMeetOne = GUICtrlCreateCheckbox("Meet One Then Attack", $x, $y, -1, -1)
			$txtTip = "Just meet only ONE of the above conditions, then Attack."
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 260, $y = 210
	$grpLiveBaseConditions = GUICtrlCreateGroup("LiveBase Conditions", $x - 20, $y - 20, 220, 255)
		$chkABEnableAfter = GUICtrlCreateCheckbox("Delay Start:", $x, $y, -1, -1)
			$txtTip = "Search for a Live Base after this No. of searches, start searching for Dead Bases first.."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABEnableAfter")
			GUICtrlSetState(-1, $GUI_HIDE)
		$txtABEnableAfter = GUICtrlCreateInput("150", $x + 80, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "No. of searches to wait before activating this mode."
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetTip(-1, $txtTip)
			_GUICtrlEdit_SetReadOnly(-1, True)
			GUICtrlSetState(-1, $GUI_HIDE)
		$lblABEnableAfter = GUICtrlCreateLabel("search(es).", $x + 132, $y + 4, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$y += 21
		$cmbABMeetGE = GUICtrlCreateCombo("", $x , $y + 10, 65, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = "Search for a base that meets the values set for Min. Gold, Elixir."
			GUICtrlSetData(-1, "G And E|G Or E|G + E", "G + E")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "cmbABGoldElixir")
		$txtABMinGold = GUICtrlCreateInput("80000", $x + 80, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Set the Min. amount of Gold to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState (-1, $GUI_HIDE)
		$picABMinGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 131, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$y += 21
		$txtABMinElixir = GUICtrlCreateInput("80000", $x + 80, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Set the Min. amount of Elixir to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState (-1, $GUI_HIDE)
		$picABMinElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 131, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$y -= 11
		$txtABMinGoldPlusElixir = GUICtrlCreateInput("160000", $x + 80, $y, 50, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Set the Min. amount of Gold + Elixir to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picABMinGPEGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 131, $y + 1, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$lblABMinGPE = GUICtrlCreateLabel("+", $x + 147, $y + 1, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
		$picABMinGPEElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 153, $y + 1, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$y += 31
		$chkABMeetDE = GUICtrlCreateCheckbox("Dark Elixir", $x , $y, -1, -1)
			$txtTip = "Search for a base that meets the value set for Min. Dark Elixir."
			GUICtrlSetOnEvent(-1, "chkABMeetDE")
			GUICtrlSetTip(-1, $txtTip)
		$txtABMinDarkElixir = GUICtrlCreateInput("0", $x + 80, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Set the Min. amount of Dark Elixir to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
			_GUICtrlEdit_SetReadOnly(-1, True)
		$picABMinDarkElixir = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 131, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$chkABMeetTrophy = GUICtrlCreateCheckbox("Trophies", $x, $y, -1, -1)
			$txtTip = "Search for a base that meets the value set for Min. Trophies."
			GUICtrlSetOnEvent(-1, "chkABMeetTrophy")
			GUICtrlSetTip(-1, $txtTip)
		$txtABMinTrophy = GUICtrlCreateInput("0", $x + 80, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Set the Min. amount of Trophies to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			_GUICtrlEdit_SetReadOnly(-1, True)
			GUICtrlSetLimit(-1, 2)
		$picABMinTrophies = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 131, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$chkABMeetTH = GUICtrlCreateCheckbox("Townhall", $x, $y, -1, -1)
			$txtTip = "Search for a base that meets the value set for Max. Townhall Level."
			GUICtrlSetOnEvent(-1, "chkABMeetTH")
			GUICtrlSetTip(-1, $txtTip)
		$cmbABTH = GUICtrlCreateCombo("", $x + 80, $y - 1, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = "Set the Max. level of the Townhall to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetData(-1, "4-6|7|8|9|10", "4-6")
		$picABMaxTH1 = GUICtrlCreateIcon($pIconLib, $eIcnTH1, $x + 131, $y - 3, 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$lblABMaxTH = GUICtrlCreateLabel("-", $x + 156, $y + 1, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
		$picABMaxTH10 = GUICtrlCreateIcon($pIconLib, $eIcnTH10, $x + 160, $y - 3, 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$chkABMeetTHO = GUICtrlCreateCheckbox("Townhall Outside", $x, $y, -1, -1)
			$txtTip = "Search for a base that has an exposed Townhall. (Outside of Walls)"
			GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$chkABWeakBase = GUICtrlCreateCheckbox("WeakBase", $x, $y, -1, -1)
			$txtTip = "Search for a base that has low defences."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$cmbABWeakMortar = GUICtrlCreateCombo("", $x + 80, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = "Set the Max. level of the Mortar to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 5")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picABWeakMortar = GUICtrlCreateIcon($pIconLib, $eIcnMortar, $x + 131, $y - 3, 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$y +=23
		$cmbABWeakWizTower = GUICtrlCreateCombo("", $x + 80, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = "Set the Max. level of the Wizard Tower to search for on a village to attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 4")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picABWeakWizTower = GUICtrlCreateIcon($pIconLib, $eIcnWizTower, $x + 131, $y - 2, 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$y += 30
		$chkABMeetOne = GUICtrlCreateCheckbox("Meet One Then Attack", $x, $y, -1, -1)
			$txtTip = "Just meet only ONE of the above conditions, then Attack."
			GUICtrlSetTip(-1, $txtTip)
		For $i = $cmbABMeetGE To $chkABMeetOne
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 470
	$grpSearchReduction = GUICtrlCreateGroup("Search Reduction", $x - 20, $y - 20, 450, 55)
		$chkSearchReduction = GUICtrlCreateCheckbox("Lower Aim, Every:", $x , $y, -1, -1)
			$txtTip = "Check this if you want the search values to automatically be lowered after a certain amount of searches."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkSearchReduction")
		$txtSearchReduceCount = GUICtrlCreateInput("20", $x + 105, $y + 2, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Enter the No. of searches to wait before each reduction occures."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
		$lblSearchReduceCount = GUICtrlCreateLabel("search(es).", $x + 145, $y + 3, -1, -1)
		$x += 210
		$y -= 9
		$lblSearchReduceGold = GUICtrlCreateLabel("-", $x, $y + 3, -1, 17)
			$txtTip = "Lower value for Gold by this amount on each step."
			GUICtrlSetTip(-1, $txtTip)
		$txtSearchReduceGold = GUICtrlCreateInput("2000", $x + 5, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
		$picSearchReduceGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 46, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$lblSearchReduceElixir = GUICtrlCreateLabel("-", $x, $y + 3, -1, 17)
			$txtTip = "Lower value for Elixir by this amount on each step."
			GUICtrlSetTip(-1, $txtTip)
		$txtSearchReduceElixir = GUICtrlCreateInput("2000", $x + 5, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
		$picSearchReduceElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 46, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$x += 70
		$y -= 10
		$lblSearchReduceGoldPlusElixir = GUICtrlCreateLabel("-", $x, $y + 3, -1, 17)
			$txtTip = "Lower total sum for G+E by this amount on each step."
			GUICtrlSetTip(-1, $txtTip)
		$txtSearchReduceGoldPlusElixir = GUICtrlCreateInput("4000", $x + 5, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
		$picSearchReduceGPEGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 46, $y + 1, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$lblSearchReduceGPE = GUICtrlCreateLabel("+", $x + 62, $y + 1, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
		$picSearchReduceGPEElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 68, $y + 1, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$x += 90
		$y -= 11
		$lblSearchReduceDark = GUICtrlCreateLabel("-", $x, $y + 3, -1, 17)
			$txtTip = "Lower value for Dark Elixir by this amount on each step."
			GUICtrlSetTip(-1, $txtTip)
		$txtSearchReduceDark = GUICtrlCreateInput("100", $x + 5, $y, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
		$picSearchReduceDark = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 41, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$lblSearchReduceTrophy = GUICtrlCreateLabel("-", $x, $y + 3, -1, 17)
			$txtTip = "Lower value for Trophies by this amount on each step."
			GUICtrlSetTip(-1, $txtTip)
		$txtSearchReduceTrophy = GUICtrlCreateInput("2", $x + 5, $y, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 1)
		$picSearchReduceTrophy = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 41, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
