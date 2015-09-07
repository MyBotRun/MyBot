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
; Attack Basics Tab
;~ -------------------------------------------------------------

$tabAttack = GUICtrlCreateTabItem("Attack")
	Local $x = 30, $y = 150
	$grpDeadBaseDeploy = GUICtrlCreateGroup("DeadBase Deploy", $x - 20, $y - 20, 225, 295);95)
		$lblDBDeploy = GUICtrlCreateLabel("Attack on:", $x, $y + 5, -1, -1)
		$cmbDBDeploy = GUICtrlCreateCombo("", $x + 55, $y, 120, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Attack on a single side, penetrates through base" & @CRLF & "Attack on two sides, penetrates through base" & @CRLF & "Attack on three sides, gets outer and some inside of base" & @CRLF & "Attack on all sides equally, gets most of outer base", "Select the No. of sides to attack on.")
			GUICtrlSetData(-1, "one side|two sides|three sides|all sides equally", "all sides equally")
		$y += 25
		$lblDBSelectTroop=GUICtrlCreateLabel("Troops:",$x, $y + 5, -1 , -1)
		$cmbDBSelectTroop=GUICtrlCreateCombo("", $x + 55, $y, 120, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Use All Troops|Use Barracks|Barb Only|Arch Only|B+A|B+Gob|A+Gob|B+A+Gi|B+A+Gob+Gi|B+A+Hog Rider|B+A+Minion", "Use All Troops")
		$y += 25
		$lblDBUnitDelay = GUICtrlCreateLabel("Delay Unit:", $x, $y + 5, -1, -1)
			$txtTip = "This delays the deployment of troops, 1 (fast) = like a Bot, 10 (slow) = Like a Human." & @CRLF & "Random will make bot more varied and closer to a person."
			GUICtrlSetTip(-1, $txtTip)
		$cmbDBUnitDelay = GUICtrlCreateCombo("", $x + 55, $y, 36, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "5")
		$lblDBWaveDelay = GUICtrlCreateLabel("Wave:", $x + 105, $y + 5, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
		$cmbDBWaveDelay = GUICtrlCreateCombo("", $x + 140, $y, 36, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "5")
		$y += 22
		$chkDBRandomSpeedAtk = GUICtrlCreateCheckbox("Randomize delay for Units && Waves", $x, $y, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkDBRandomSpeedAtk")
	$y = 250
		$chkDBSmartAttackRedArea = GUICtrlCreateCheckbox("Use Smart Attack: Near Red Line.", $x, $y, -1, -1)
			$txtTip = "Use Smart Attack to detect the outer 'Red Line' of the village to attack. And drop your troops close to it."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBSmartAttackRedArea")
		$y += 22
		$lblDBSmartDeploy = GUICtrlCreateLabel("Drop Type:", $x, $y + 5, -1, -1)
			$txtTip = "Select the Deploy Mode for the waves of Troops." & @CRLF & _
				"Type 1: Drop a single wave of troops on each side then switch troops, OR" & @CRLF & _
				"Type 2: Drop a full wave of all troops (e.g. giants, barbs and archers) on each side then switch sides."
			GUICtrlSetTip(-1, $txtTip)
		$cmbDBSmartDeploy = GUICtrlCreateCombo("", $x + 55, $y, 120, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Sides, then Troops|Troops, then Sides", "Sides, then Troops")
			GUICtrlSetTip(-1, $txtTip)
		$y += 26
		$chkDbAttackNearGoldMine = GUICtrlCreateCheckbox("Mine", $x + 20, $y, 17, 17)
			$txtTip = "Drop troops near Gold Mines"
			GUICtrlSetTip(-1, $txtTip)
		$picDBAttackNearGoldMine = GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 40 , $y - 3 , 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$x += 75
		$chkDBAttackNearElixirCollector = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = "Drop troops near Elixir Collectors"
			GUICtrlSetTip(-1, $txtTip)
		$picDBAttackNearElixirCollector = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20 , $y - 3 , 24, 24)
			GUICtrlSetTip(-1, $txtTip)
 		$x += 55
  		$chkDBAttackNearDarkElixirDrill = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = "Drop troops near Dark Elixir Drills"
 			GUICtrlSetTip(-1, $txtTip)
		$picDBAttackNearDarkElixirDrill = GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 20 , $y - 3, 24, 24)
 			GUICtrlSetTip(-1, $txtTip)
	Local $x = 30, $y = 335
		GUICtrlCreateIcon($pIconLib, $eIcnKing, $x , $y, 24, 24)
		$chkDBKingAttack = GUICtrlCreateCheckbox("Use King", $x + 35, $y, -1, -1)
			$txtTip = "Use your King when Attacking a DeadBase."
			GUICtrlSetTip(-1, $txtTip)
		$y += 27
		GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x, $y, 24, 24)
		$chkDBQueenAttack = GUICtrlCreateCheckbox("Use Queen", $x + 35, $y, -1, -1)
			$txtTip = "Use your Queen when Attacking a DeadBase."
			GUICtrlSetTip(-1, $txtTip)
		$y += 27
		GUICtrlCreateIcon($pIconLib, $eIcnCC, $x, $y, 24, 24)
		$chkDBDropCC = GUICtrlCreateCheckbox("Drop in Battle", $x + 35, $y, -1, -1)
			GUICtrlSetTip(-1, "Drop your Clan Castle in battle if it contains troops.")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 260, $y = 150
	$grpLiveBaseDeploy = GUICtrlCreateGroup("LiveBase Deploy", $x - 20, $y - 20, 220, 295);95)
		$lblABDeploy = GUICtrlCreateLabel("Attack on:", $x, $y + 5, -1, -1)
		$cmbABDeploy = GUICtrlCreateCombo("", $x + 55, $y, 120, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Attack on a single side, penetrates through base" & @CRLF & "Attack on two sides, penetrates through base" & @CRLF & "Attack on three sides, gets outer and some inside of base" & @CRLF & "Attack on all sides equally, gets most of outer base", "Select the No. of sides to attack on.")
			GUICtrlSetData(-1, "one side|two sides|three sides|all sides equally", "all sides equally")
		$y += 25
		$lblABSelectTroop=GUICtrlCreateLabel("Troops:",$x, $y + 5, -1 , -1)
		$cmbABSelectTroop=GUICtrlCreateCombo("", $x + 55, $y, 120, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Use All Troops|Use Barracks|Barb Only|Arch Only|B+A|B+Gob|A+Gob|B+A+Gi|B+A+Gob+Gi|B+A+Hog Rider|B+A+Minion", "Use All Troops")
		$y += 25
		$lblABUnitDelay = GUICtrlCreateLabel("Delay Unit:", $x, $y + 5, -1, -1)
			$txtTip = "This delays the deployment of troops, 1 (fast) = like a Bot, 10 (slow) = Like a Human." & @CRLF & "Random will make bot more varied and closer to a person."
			GUICtrlSetTip(-1, $txtTip)
		$cmbABUnitDelay = GUICtrlCreateCombo("", $x + 55, $y, 36, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "5")
		$lblABWaveDelay = GUICtrlCreateLabel("Wave:", $x + 105, $y + 5, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
		$cmbABWaveDelay = GUICtrlCreateCombo("", $x + 140, $y, 36, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "5")
		$y += 22
		$chkABRandomSpeedAtk = GUICtrlCreateCheckbox("Randomize delay for Units && Waves", $x, $y, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABRandomSpeedAtk")
	$y = 250
		$chkABSmartAttackRedArea = GUICtrlCreateCheckbox("Use Smart Attack: Near Red Line.", $x, $y, -1, -1)
			$txtTip = "Use Smart Attack to detect the outer 'Red Line' of the village to attack. And drop your troops close to it."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkABSmartAttackRedArea")
		$y += 22
		$lblABSmartDeploy = GUICtrlCreateLabel("Drop Type:", $x, $y + 5, -1, -1)
			$txtTip = "Select the Deploy Mode for the waves of Troops." & @CRLF & _
				"Type 1: Drop a single wave of troops on each side then switch troops, OR" & @CRLF & _
				"Type 2: Drop a full wave of all troops (e.g. giants, barbs and archers) on each side then switch sides."
			GUICtrlSetTip(-1, $txtTip)
		$cmbABSmartDeploy = GUICtrlCreateCombo("", $x + 55, $y, 120, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Sides, then Troops|Troops, then Sides", "Sides, then Troops")
			GUICtrlSetTip(-1, $txtTip)
		$y += 26
		$chkABAttackNearGoldMine = GUICtrlCreateCheckbox("", $x + 20, $y, 17, 17)
			$txtTip = "Drop troops near Gold Mines"
			GUICtrlSetTip(-1, $txtTip)
		$picABAttackNearGoldMine = GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 40 , $y - 3 , 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$x += 75
		$chkABAttackNearElixirCollector = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = "Drop troops near Elixir Collectors"
			GUICtrlSetTip(-1, $txtTip)
		$picABAttackNearElixirCollector = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20 , $y - 3 , 24, 24)
			GUICtrlSetTip(-1, $txtTip)
 		$x += 55
  		$chkABAttackNearDarkElixirDrill = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = "Drop troops near Dark Elixir Drills"
 			GUICtrlSetTip(-1, $txtTip)
		$picABAttackNearDarkElixirDrill = GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 20 , $y - 3, 24, 24)
 			GUICtrlSetTip(-1, $txtTip)
	$x -= 70
	$y = 335
		GUICtrlCreateIcon($pIconLib, $eIcnKing, $x, $y, 24, 24)
		$chkABKingAttack = GUICtrlCreateCheckbox("Use King", $x + 35, $y, -1, -1)
			$txtTip = "Use your King when Attacking a LiveBase."
			GUICtrlSetTip(-1, $txtTip)
		$y += 27
		GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x, $y, 24, 24)
		$chkABQueenAttack = GUICtrlCreateCheckbox("Use Queen", $x + 35, $y, -1, -1)
			$txtTip = "Use your Queen when Attacking a LiveBase."
			GUICtrlSetTip(-1, $txtTip)
		$y += 27
		GUICtrlCreateIcon($pIconLib, $eIcnCC, $x, $y, 24, 24)
		$chkABDropCC = GUICtrlCreateCheckbox("Drop in Battle", $x + 35, $y, -1, -1)
			GUICtrlSetTip(-1, "Drop your Clan Castle in battle if it contains troops.")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 200, $y = 345
	$grpClanCastleBal = GUICtrlCreateGroup("ClanCastle Balance", $x - 20, $y - 20, 110, 100)
		GUICtrlCreateLabel("", $x - 18, $y - 7, 106, 85) ; fake label to hide group border from DB and LB setting groups
		GUICtrlSetBkColor (-1, $COLOR_WHITE)
		GUICtrlSetState (-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnCC, $x + 25, $y - 5, 24, 24)
		$y += 21
		$chkUseCCBalanced = GUICtrlCreateCheckbox("Balance D/R", $x - 5, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetTip(-1, "Drop your Clan Castle only if your donated/received ratio is greater than D/R ratio below.")
			GUICtrlSetOnEvent(-1, "chkBalanceDR")
		$y += 25
		$cmbCCDonated = GUICtrlCreateCombo("",  $x - 5, $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Donated quotient")
			GUICtrlSetData(-1, "1|2|3|4|5", "1")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbBalanceDR")
		$lblDRRatio = GUICtrlCreateLabel("/", $x + 31, $y + 5, -1, -1)
			$txtTip = "Wanted donated / received ratio" & @CRLF & "1/1 means donated = received, 1/2 means donated = half the received etc."
			GUICtrlSetTip(-1, $txtTip)
		$cmbCCReceived = GUICtrlCreateCombo("", $x + 44, $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Received quotient")
			GUICtrlSetData(-1, "1|2|3|4|5", "1")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbBalanceDR")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 450
	$grpRoyalAbilities = GUICtrlCreateGroup("Hero Abilities", $x - 20, $y - 20, 450, 75)
		GUICtrlCreatePic (@ScriptDir & "\Icons\KingAbility.jpg", $x, $y - 3, 30, 47)
		GUICtrlCreatePic (@ScriptDir & "\Icons\QueenAbility.jpg", $x + 30, $y - 3, 30, 47)
		$x += 75
		$radManAbilities = GUICtrlCreateRadio("Timed activation of Hero Abilities after:", $x, $y + 3, -1, -1)
			$txtTip = "Activate the Ability on a timer." & @CRLF & "Both Heroes are activated at the same time."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
		$radAutoAbilities = GUICtrlCreateRadio("Auto activate Hero Abilities when they become weak (red zone).", $x, $y + 25, -1, -1)
		$txtTip = "Activate the Ability when the Hero becomes weak." & @CRLF & "King and Queen are checked and activated individually."
		GUICtrlSetTip(-1, $txtTip)
		$txtManAbilities = GUICtrlCreateInput("9", $x + 200, $y + 2, 30, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Set the time in seconds for Timed Activation of Hero Abilities."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
		$lblRoyalAbilitiesSec = GUICtrlCreateLabel("sec.", $x + 235, $y + 7, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
