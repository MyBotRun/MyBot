; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
; Attack Basics Tab
;~ -------------------------------------------------------------

$tabAttackCSV = GUICtrlCreateTabItem(GetTranslated(14,1, "Attack Scripted"))
	Local $x = 30, $y = 150
	$grpDeadBaseDeployCSV = GUICtrlCreateGroup(GetTranslated(14,2, "DeadBase Deploy"), $x - 20, $y - 20, 225, 315);95)

	    $chkmakeIMGCSV = GUICtrlCreateCheckbox(GetTranslated(14,17, "IMG"), $x+150, $y-22, -1, -1)
			$txtTip = GetTranslated(14,18, "Make IMG with extra info in Profile -> Temp Folder")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetTip(-1, $txtTip)

		$chkUseAttackDBCSV = GUICtrlCreateCheckbox(GetTranslated(14,3, "Use Scripted attack for Dead Bases"), $x, $y, -1, -1)
			$txtTip = GetTranslated(14,4, "Use scripted attack for dead bases, this disable standard attack")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkUseAttackDBCSV")
		$y +=25
			$cmbDBScriptName=GUICtrlCreateCombo("", $x-10 , $y, 185, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(14,5, "Choose the script; You can edit/add new script placed in folder 'Attack-Script'")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "cmbDBScriptName")

			GUICtrlCreateIcon($pIconLib, $eIcnGreenLight, $x +182, $y +2, 16, 16)
			$txtTip =  GetTranslated(14,6, "Update combo box Script Files")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "UpdateComboScriptName")
		$y +=25
			$lblNotesDBScript =  GUICtrlCreateLabel("", $x, $y + 5, 180, 118)
			PopulateDBComboScriptsFiles() ; populate
			GUICtrlCreateIcon($pIconLib, $eIcnGreenLight, $x +182, $y +2, 16, 16)
			$txtTip =  GetTranslated(14,15, "Show/Edit Attack Script Commands")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "EditDBScript")

	Local $x = 30, $y = 330
		$lblUseInBattleDBCSV = GUICtrlCreateLabel(GetTranslated(14,7, "Use in battle") & ":", $x, $y + 5, -1, -1)
	    GUICtrlCreateGraphic($x ,$y, 190,1,$SS_BLACKRECT)
		$y +=27
			GUICtrlCreateIcon($pIconLib, $eIcnKing, $x , $y, 24, 24)
			$txtTip = GetTranslated(14,8, "Use your King when Attacking...")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBKingAttackCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x += 50
		GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x, $y, 24, 24)
			$txtTip = GetTranslated(14,9, "Use your Queen when Attacking...")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBQueenAttackCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
		GUICtrlCreateIcon($pIconLib, $eIcnWarden, $x, $y, 24, 24)
			$txtTip = GetTranslated(14,10, "Use your Warden when Attacking...")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBWardenAttackCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
			GUICtrlCreateIcon($pIconLib, $eIcnCC, $x, $y, 24, 24)
			$txtTip =GetTranslated(14,11, "Drop your Clan Castle in battle if it contains troops.")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBDropCCCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$y += 27
		$x -= 150
		GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(14,39, "Use your Light Spells when Attacking...")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBLightSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
		GUICtrlCreateIcon($pIconLib, $eIcnHealSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(14,40, "Use your Healing Spells when Attacking...")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBHealSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
		GUICtrlCreateIcon($pIconLib, $eIcnRageSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(14,41, "Use your Rage Spells when Attacking...")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBRageSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
			GUICtrlCreateIcon($pIconLib, $eIcnJumpSpell , $x, $y, 24, 24)
			$txtTip =GetTranslated(14,42, "Use your Jump Spells when Attacking...")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBJumpSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$y += 27
		$x -= 150
		GUICtrlCreateIcon($pIconLib, $eIcnFreezeSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(14,43, "Use your Freeze Spells when Attacking...")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBFreezeSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
		GUICtrlCreateIcon($pIconLib, $eIcnPoisonSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(14,44, "Use your Poison Spells when Attacking...")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBPoisonSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
		GUICtrlCreateIcon($pIconLib, $eIcnEarthquakeSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(14,45, "Use your Earthquake Spells when Attacking...")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBEarthquakeSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
			GUICtrlCreateIcon($pIconLib, $eIcnHasteSpell, $x, $y, 24, 24)
			$txtTip =GetTranslated(14,46, "Use your Haste Spells when Attacking...")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBHasteSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 260, $y = 150
	$grpLiveBaseDeployCSV = GUICtrlCreateGroup(GetTranslated(14,12, "LiveBase Deploy"), $x - 20, $y - 20, 220, 315);95)


		$chkUseAttackABCSV = GUICtrlCreateCheckbox(GetTranslated(14,13, "Use Scripted attack for Live Bases"), $x, $y, -1, -1)
			$txtTip = GetTranslated(14,14, "Use scripted attack for live bases, this disable standard attack")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkUseAttackABCSV")
		$y +=25
			$cmbABScriptName=GUICtrlCreateCombo("", $x -10 , $y, 185, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(14,5, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "cmbABScriptName")

			GUICtrlCreateIcon($pIconLib, $eIcnGreenLight, $x +182, $y +2, 16, 16)
			$txtTip =  GetTranslated(14,6, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "UpdateComboScriptName")
		$y +=25
			$lblNotesABScript =  GUICtrlCreateLabel("", $x, $y + 5, 180, 118)
			PopulateABComboScriptsFiles() ; populate
			AttackCSVAssignDefaultScriptName();
			GUICtrlCreateIcon($pIconLib, $eIcnGreenLight, $x +182, $y +2, 16, 16)
			$txtTip =  GetTranslated(14,15, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "EditABScript")



	$x += 65
	$y = 330
		$lblABUseInBattleCSV = GUICtrlCreateLabel(GetTranslated(14,7, -1) & ":", $x -70, $y + 5, -1, -1)
		GUICtrlCreateGraphic($x -70,$y, 190,1,$SS_BLACKRECT)
	    $x -= 70
		$y +=27
		GUICtrlCreateIcon($pIconLib, $eIcnKing, $x, $y, 24, 24)
			$txtTip = GetTranslated(14,8, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABKingAttackCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x += 50
		GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x, $y, 24, 24)
			$txtTip = GetTranslated(14,9, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABQueenAttackCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x += 50
		GUICtrlCreateIcon($pIconLib, $eIcnWarden, $x, $y, 24, 24)
			$txtTip = GetTranslated(14,10, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABWardenAttackCSV = GUICtrlCreateCheckbox("", $x + 30, $y,17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x += 50
		GUICtrlCreateIcon($pIconLib, $eIcnCC, $x, $y, 24, 24)
		$chkABDropCCCSV= GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, GetTranslated(14,11, -1))
		$y += 27
		$x -= 150
		GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(14,39, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABLightSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
		GUICtrlCreateIcon($pIconLib, $eIcnHealSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(14,40, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABHealSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
		GUICtrlCreateIcon($pIconLib, $eIcnRageSpell, $x, $y, 24, 24)
			$txtTip = GetTranslated(14,41, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABRageSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
			GUICtrlCreateIcon($pIconLib, $eIcnJumpSpell , $x, $y, 24, 24)
			$txtTip =GetTranslated(14,42, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABJumpSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$y += 27
		$x -= 150
		GUICtrlCreateIcon($pIconLib, $eIcnFreezeSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(14,43, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABFreezeSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
		GUICtrlCreateIcon($pIconLib, $eIcnPoisonSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(14,44, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABPoisonSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
		GUICtrlCreateIcon($pIconLib, $eIcnEarthquakeSpell , $x, $y, 24, 24)
			$txtTip = GetTranslated(14,45, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABEarthquakeSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x +=50
			GUICtrlCreateIcon($pIconLib, $eIcnHasteSpell, $x, $y, 24, 24)
			$txtTip =GetTranslated(14,46, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABHasteSpellCSV = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)



	Local $x = 30, $y = 470
	$grpRoyalAbilitiesCSV = GUICtrlCreateGroup(GetTranslated(14,28, "Hero Abilities"), $x - 20, $y - 20, 225, 55)
		GUICtrlCreateIcon($pIconLib, $eIcnKingAbility, $x-15, $y-4, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnQueenAbility, $x+ 10, $y-4, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnWardenAbility, $x+ 35, $y -4, 24, 24)

		$x += 65
		$y -= 8
		$radAutoAbilitiesCSV = GUICtrlCreateRadio(GetTranslated(14,31, "Auto activate (red zone)"), $x, $y-4 , -1, -1)
		$txtTip = GetTranslated(14,32, "Activate the Ability when the Hero becomes weak.") & @CRLF & GetTranslated(14,33, "Heroes are checked and activated individually.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$Y += 15
		$radManAbilitiesCSV = GUICtrlCreateRadio(GetTranslated(14,29, "Timed after") & ":", $x , $y , -1, -1)
			$txtTip = GetTranslated(14,56, "Activate the Ability on a timer.") & @CRLF & GetTranslated(14,30, "All Heroes are activated at the same time.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)

		$txtManAbilitiesCSV = GUICtrlCreateInput("9", $x + 80, $y+1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(14,34, "Set the time in seconds for Timed Activation of Hero Abilities.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
		$lblRoyalAbilitiesSecCSV = GUICtrlCreateLabel(GetTranslated(14,35, "sec."), $x + 115, $y + 4, -1, -1)
		$y += 40
		$chkUseWardenAbilityCSV = GUICtrlCreateCheckbox(GetTranslated(14,36, "Timed activation of Warden Ability after") & ":", $x, $y, -1, -1)
			$txtTip = GetTranslated(14,37, "Use the ability of the Grand Warden on a timer.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED+$GUI_DISABLE+$GUI_HIDE)
			GUICtrlSetColor (-1,$COLOR_RED)
		$txtWardenAbilityCSV = GUICtrlCreateInput("25", $x + 260, $y, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(14,38, "Set the time in seconds for Timed Activation of Grand Warden Ability.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE+$GUI_HIDE)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetColor (-1,$COLOR_RED)
		$lblWardenAbilitiesSecCSV = GUICtrlCreateLabel(GetTranslated(14,7, -1), $x + 293, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE+$GUI_HIDE)
			GUICtrlSetColor (-1,$COLOR_RED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 260, $y = 470
	$grpClanCastleBalCSV = GUICtrlCreateGroup(GetTranslated(14,22, "ClanCastle Balance"), $x - 20, $y - 20, 220, 55)
		GUICtrlCreateIcon($pIconLib, $eIcnCC, $x -10 , $y - 5, 24, 24)
		$y -= 4
		$chkUseCCBalancedCSV = GUICtrlCreateCheckbox(GetTranslated(14,23,"Balance D/R" ), $x +20, $y+2, -1, -1)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetTip(-1, GetTranslated(14,24, "Drop your Clan Castle only if your donated/received ratio is greater than D/R ratio below."))
			GUICtrlSetOnEvent(-1, "chkBalanceDRCSV")
	   $x +=80
	   $y +=2
		$cmbCCDonatedCSV = GUICtrlCreateCombo("",  $x + 40 , $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(14,25, "Donated ratio"))
			GUICtrlSetData(-1, "1|2|3|4|5", "1")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbBalanceDRCSV")
		$lblDRRatioCSV = GUICtrlCreateLabel("/", $x + 76, $y + 5, -1, -1)
			$txtTip = GetTranslated(14,26, "Wanted donated / received ratio") & @CRLF & GetTranslated(14,52, "1/1 means donated = received, 1/2 means donated = half the received etc.")
			GUICtrlSetTip(-1, $txtTip)
		$cmbCCReceivedCSV = GUICtrlCreateCombo("", $x +84, $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(14,27, "Received ratio"))
			GUICtrlSetData(-1, "1|2|3|4|5", "1")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbBalanceDRCSV")
	GUICtrlCreateGroup("", -99, -99, 1, 1)



GUICtrlCreateTabItem("")
