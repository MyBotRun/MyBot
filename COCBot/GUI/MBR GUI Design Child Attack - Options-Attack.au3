; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Local $x = 25, $y = 135

	$grpRoyalAbilitiesCSV = GUICtrlCreateGroup(GetTranslated(634,1, "Hero Abilities"), $x - 20, $y - 20, 420, 60)
		GUICtrlCreateIcon($pIconLib, $eIcnKingAbility, $x-15, $y-4, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnQueenAbility, $x+ 10, $y-4, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnWardenAbility, $x+ 35, $y -4, 24, 24)

		$x += 65
		$y -= 8
		$radAutoAbilities = GUICtrlCreateRadio(GetTranslated(634,2, "Auto activate (red zone)"), $x, $y-4 , -1, -1)
		$txtTip = GetTranslated(634,3, "Activate the Ability when the Hero becomes weak.") & @CRLF & GetTranslated(634,4, "Heroes are checked and activated individually.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$Y += 15
		$radManAbilities = GUICtrlCreateRadio(GetTranslated(634,5, "Timed after") & ":", $x , $y , -1, -1)
			$txtTip = GetTranslated(634,6, "Activate the Ability on a timer.") & @CRLF & GetTranslated(634,7, "All Heroes are activated at the same time.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)

		$txtManAbilities = GUICtrlCreateInput("9", $x + 80, $y+3, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(634,8, "Set the time in seconds for Timed Activation of Hero Abilities.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
		$lblRoyalAbilitiesSec = GUICtrlCreateLabel(GetTranslated(603,6, "sec."), $x + 115, $y + 4, -1, -1)
		$y += 40
		$chkUseWardenAbility = GUICtrlCreateCheckbox(GetTranslated(634,9, "Timed activation of Warden Ability after") & ":", $x, $y, -1, -1)
			$txtTip = GetTranslated(634,10, "Use the ability of the Grand Warden on a timer.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED+$GUI_DISABLE+$GUI_HIDE)
			GUICtrlSetColor (-1,$COLOR_RED)
		$txtWardenAbility = GUICtrlCreateInput("25", $x + 260, $y, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(634,11, "Set the time in seconds for Timed Activation of Grand Warden Ability.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE+$GUI_HIDE)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetColor (-1,$COLOR_RED)
		$lblWardenAbilitiesSec = GUICtrlCreateLabel(GetTranslated(603,6, -1), $x + 293, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE+$GUI_HIDE)
			GUICtrlSetColor (-1,$COLOR_RED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 25, $y = 50
Global $chkattackHours0, $chkattackHours1, $chkattackHours2, $chkattackHours3, $chkattackHours4, $chkattackHours5
Global $chkattackHours6, $chkattackHours7, $chkattackHours8, $chkattackHours9, $chkattackHours10, $chkattackHours11
Global $chkattackHours12, $chkattackHours13, $chkattackHours14, $chkattackHours15, $chkattackHours16, $chkattackHours17
Global $chkattackHours18, $chkattackHours19, $chkattackHours20, $chkattackHours21, $chkattackHours22, $chkattackHours23
Global $lbattackHours1, $lbattackHours2, $lbattackHours3, $lbattackHours4, $lbattackHours5, $lbattackHours6
Global $lbattackHours7, $lbattackHours8, $lbattackHours9, $lbattackHours10, $lbattackHours11, $lbattackHours12
Global $lbattackHoursED, $lbattackHoursPM, $lbattackHoursAM, $chkattackHoursE1, $chkattackHoursE2
Global $chkAttackWeekdays1, $chkAttackWeekdays2, $chkAttackWeekdays3, $chkAttackWeekdays4, $chkAttackWeekdays5, $chkAttackWeekdays6, $chkAttackWeekdays0


	$grpAttHSched = GUICtrlCreateGroup(GetTranslated(603,30, "Only during these hours of day"), $x - 20, $y - 20, 420, 80)
		$x -= 23
		$lbattackHours1 = GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
		$lbattackHours2 = GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
		$lbattackHours3 = GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
		$lbattackHours4 = GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
		$lbattackHours5 = GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
		$lbattackHours6 = GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
		$lbattackHours7 = GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
		$lbattackHours8 = GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
		$lbattackHours9 = GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
		$lbattackHours10 = GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
		$lbattackHours11 = GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
		$lbattackHours12 = GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
		$lbattackHoursED = GUICtrlCreateLabel("X", $x + 213, $y+2, 11, 11)
		$y += 15
		$chkattackHours0 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours1 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours2 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours3 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours4 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours5 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours6 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours7 = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours8 = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours9 = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours10 = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours11 = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		GUICtrlSetImage(-1, $pIconLib, $eIcnGoldStar, 0)
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		$txtTip = GetTranslated(603,2, "This button will clear or set the entire row of boxes")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkattackHoursE1")
		$lbattackHoursAM = GUICtrlCreateLabel(GetTranslated(603,3, "AM"), $x + 10, $y)
		$y += 15
		$chkattackHours12 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours13 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours14 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours15 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours16 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours17 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours18 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours19 = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours20 = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours21 = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours22 = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHours23 = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		GUICtrlSetState(-1, $GUI_CHECKED )
		$chkattackHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		GUICtrlSetImage(-1, $pIconLib, $eIcnGoldStar, 0)
		GUICtrlSetState(-1, $GUI_UNCHECKED )
		$txtTip = GetTranslated(603,2, -1)
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkattackHoursE2")
		$lbattackHoursPM = GUICtrlCreateLabel(GetTranslated(603,4, "PM"), $x + 10, $y)

	Local $x = 257 , $y = 42
	$grpAttDSched = GUICtrlCreateGroup(GetTranslated(603,31, "Only during these day of week"), $x - 10, $y, 166, 55)
	$x -= 12
	$y += 17
	$lbAttackWeekdays1 = GUICtrlCreateLabel(GetTranslated(603,16, "Su"), $x + 30, $y, 13, 15)
	GUICtrlSetTip(-1, GetTranslated(603,17, "Sunday"))
	$lbAttackWeekdays2 = GUICtrlCreateLabel(GetTranslated(603,18, "Mo"), $x + 44, $y, 13, 15)
	GUICtrlSetTip(-1, GetTranslated(603,19, "Monday"))
	$lbAttackWeekdays3 = GUICtrlCreateLabel(GetTranslated(603,20, "Tu"), $x + 59, $y, 13, 15)
	GUICtrlSetTip(-1, GetTranslated(603,21, "Tuesday"))
	$lbAttackWeekdays4 = GUICtrlCreateLabel(GetTranslated(603,22, "We"), $x + 73, $y, 13, 15)
	GUICtrlSetTip(-1, GetTranslated(603,23, "Wednesday"))
	$lbAttackWeekdays5 = GUICtrlCreateLabel(GetTranslated(603,24, "Th"), $x + 90, $y, 13, 15)
	GUICtrlSetTip(-1, GetTranslated(603,25, "Thursday"))
	$lbAttackWeekdays6 = GUICtrlCreateLabel(GetTranslated(603,26, "Fr"), $x + 106, $y, 13, 15)
	GUICtrlSetTip(-1, GetTranslated(603,27, "Friday"))
	$lbAttackWeekdays7 = GUICtrlCreateLabel(GetTranslated(603,28, "Sa"), $x + 120, $y, 13, 15)
	GUICtrlSetTip(-1, GetTranslated(603,29, "Saturday"))
	$y += 13
	$chkAttackWeekdays0 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkAttackWeekdays1 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkAttackWeekdays2 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkAttackWeekdays3 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkAttackWeekdays4 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkAttackWeekdays5 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$chkAttackWeekdays6 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 25, $y = 205
	$grpClanCastleBal = GUICtrlCreateGroup(GetTranslated(634,12, "ClanCastle"), $x - 20, $y - 20, 420, 113)
		GUICtrlCreateIcon($pIconLib, $eIcnCC, $x -10 , $y - 5, 24, 24)
		$y -= 4
		$chkUseCCBalanced = GUICtrlCreateCheckbox(GetTranslated(634,13,"Balance D/R" ), $x +20, $y+2, -1, -1)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetTip(-1, GetTranslated(634,14, "Drop your Clan Castle only if your donated/received ratio is greater than D/R ratio below."))
			GUICtrlSetOnEvent(-1, "chkBalanceDR")
	   $x +=80
	   $y +=2
		$cmbCCDonated = GUICtrlCreateCombo("",  $x + 40 , $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(634,15, "Donated ratio"))
			GUICtrlSetData(-1, "1|2|3|4|5", "1")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbBalanceDR")
		$lblDRRatio = GUICtrlCreateLabel("/", $x + 76, $y + 5, -1, -1)
			$txtTip = GetTranslated(634,16, "Wanted donated / received ratio") & @CRLF & GetTranslated(634,17, "1/1 means donated = received, 1/2 means donated = half the received etc.")
			GUICtrlSetTip(-1, $txtTip)
		$cmbCCReceived = GUICtrlCreateCombo("", $x +84, $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(634,18, "Received ratio"))
			GUICtrlSetData(-1, "1|2|3|4|5", "1")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbBalanceDR")



 	$y += 26
	$x = 25
 	$lblDropCCHours = GUICtrlCreateLabel(GetTranslated(603,30, -1), $x+4, $y)

	$y += 14
	$x -=23
	$lbDropCCHours1 = GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
	$lbDropCCHours2 = GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
	$lbDropCCHours3 = GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
	$lbDropCCHours4 = GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
	$lbDropCCHours5 = GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
	$lbDropCCHours6 = GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
	$lbDropCCHours7 = GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
	$lbDropCCHours8 = GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
	$lbDropCCHours9 = GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
	$lbDropCCHours10 = GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
	$lbDropCCHours11 = GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
	$lbDropCCHours12 = GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
	$lbDropCCHoursED = GUICtrlCreateLabel("X", $x + 213, $y+2, 11, 11)
	$y += 15
	$chkDropCCHours0 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours1 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours2 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours3 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours4 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours5 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours6 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours7 = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours8 = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours9 = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours10 = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours11 = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
	GUICtrlSetImage(-1, $pIconLib, $eIcnGoldStar, 0)
	GUICtrlSetState(-1, $GUI_UNCHECKED )
	$txtTip = GetTranslated(603,2, -1)
	GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkDropCCHoursE1")
	$lbDropCCHoursAM = GUICtrlCreateLabel(GetTranslated(603,3, -1), $x + 10, $y)
	$y += 15
	$chkDropCCHours12 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours13 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours14 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours15 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours16 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours17 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours18 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours19 = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours20 = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours21 = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours22 = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHours23 = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED )
	$chkDropCCHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
	GUICtrlSetImage(-1, $pIconLib, $eIcnGoldStar, 0)
	GUICtrlSetState(-1, $GUI_UNCHECKED )
	$txtTip = GetTranslated(603,2, -1)
	GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkDropCCHoursE2")
	$lbDropCCHoursPM = GUICtrlCreateLabel(GetTranslated(603,4, -1), $x + 10, $y)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

