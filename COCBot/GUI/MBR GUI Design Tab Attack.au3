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
; Attack Basics Tab
;~ -------------------------------------------------------------

$tabAttack = GUICtrlCreateTabItem(GetTranslated(3,1, "Attack"))
	Local $x = 30, $y = 150
	$grpDeadBaseDeploy = GUICtrlCreateGroup(GetTranslated(3,2, "DeadBase Deploy"), $x - 20, $y - 20, 225, 295);95)
		$lblDBDeploy = GUICtrlCreateLabel(GetTranslated(3,3, "Attack on")&":", $x, $y + 5, -1, -1)
		$cmbDBDeploy = GUICtrlCreateCombo("", $x + 55, $y, 120, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(3,4, "Attack on a single side, penetrates through base") & @CRLF & GetTranslated(3,5, "Attack on two sides, penetrates through base") & @CRLF & GetTranslated(3,6, "Attack on three sides, gets outer and some inside of base"), GetTranslated(3,7,"Select the No. of sides to attack on."))
			GUICtrlSetData(-1, GetTranslated(3,8, "one side") & "|" & GetTranslated(3,9, "two sides") & "|" & GetTranslated(3,10, "three sides") &"|" & GetTranslated(3,11,"all sides equally" ), GetTranslated(3,11, "all sides equally"))
		$y += 25
		$lblDBSelectTroop=GUICtrlCreateLabel(GetTranslated(3,12, "Troops") & ":",$x, $y + 5, -1 , -1)
		$cmbDBSelectTroop=GUICtrlCreateCombo("", $x + 55, $y, 120, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(3,13, "Use All Troops") &"|"&GetTranslated(3,14, "Use Barracks")&"|"&GetTranslated(3,15, "Barb Only")&"|" & GetTranslated(3,16, "Arch Only") &"|"&GetTranslated(3,17, "B+A")&"|"&GetTranslated(3,18, "B+Gob")&"|"&GetTranslated(3,19, "A+Gob")&"|"&GetTranslated(3,20, "B+A+Gi")&"|"&GetTranslated(3,21, "B+A+Gob+Gi")&"|"&GetTranslated(3,22, "B+A+Hog Rider")&"|"&GetTranslated(3,23, "B+A+Minion") , GetTranslated(3,13, "Use All Troops"))
		$y += 25
		$lblDBUnitDelay = GUICtrlCreateLabel(GetTranslated(3,24, "Delay Unit") & ":", $x, $y + 5, -1, -1)
			$txtTip = GetTranslated(3,25, "This delays the deployment of troops, 1 (fast) = like a Bot, 10 (slow) = Like a Human.") & @CRLF & GetTranslated(3,26, "Random will make bot more varied and closer to a person.")
			GUICtrlSetTip(-1, $txtTip)
		$cmbDBUnitDelay = GUICtrlCreateCombo("", $x + 55, $y, 36, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "5")
		$lblDBWaveDelay = GUICtrlCreateLabel(GetTranslated(3,27, "Wave") & ":", $x + 100, $y + 5, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
		$cmbDBWaveDelay = GUICtrlCreateCombo("", $x + 140, $y, 36, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "5")
		$y += 22
		$chkDBRandomSpeedAtk = GUICtrlCreateCheckbox(GetTranslated(3,28, "Randomize delay for Units & Waves"), $x, $y, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkDBRandomSpeedAtk")
	$y = 250
		$chkDBSmartAttackRedArea = GUICtrlCreateCheckbox(GetTranslated(3,29, "Use Smart Attack: Near Red Line."), $x, $y, -1, -1)
			$txtTip = GetTranslated(3,30, "Use Smart Attack to detect the outer 'Red Line' of the village to attack. And drop your troops close to it.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkDBSmartAttackRedArea")
		$y += 22
		$lblDBSmartDeploy = GUICtrlCreateLabel(GetTranslated(3,31, "Drop Type") & ":", $x, $y + 5, -1, -1)
			$txtTip = GetTranslated(3,32, "Select the Deploy Mode for the waves of Troops.") & @CRLF & GetTranslated(3,33, "Type 1: Drop a single wave of troops on each side then switch troops, OR") & @CRLF & GetTranslated(3,34, "Type 2: Drop a full wave of all troops (e.g. giants, barbs and archers) on each side then switch sides.")
			GUICtrlSetTip(-1, $txtTip)
		$cmbDBSmartDeploy = GUICtrlCreateCombo("", $x + 55, $y, 120, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(3,35, "Sides, then Troops") & "|" & GetTranslated(3,36, "Troops, then Sides") , GetTranslated(3,35, "Sides, then Troops"))
			GUICtrlSetTip(-1, $txtTip)
		$y += 26
		$chkDbAttackNearGoldMine = GUICtrlCreateCheckbox("", $x + 20, $y, 17, 17)
			$txtTip = GetTranslated(3,37, "Drop troops near Gold Mines")
			GUICtrlSetTip(-1, $txtTip)
		$picDBAttackNearGoldMine = GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 40 , $y - 3 , 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$x += 75
		$chkDBAttackNearElixirCollector = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = GetTranslated(3,38, "Drop troops near Elixir Collectors")
			GUICtrlSetTip(-1, $txtTip)
		$picDBAttackNearElixirCollector = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20 , $y - 3 , 24, 24)
			GUICtrlSetTip(-1, $txtTip)
 		$x += 55
  		$chkDBAttackNearDarkElixirDrill = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = GetTranslated(3,39, "Drop troops near Dark Elixir Drills")
 			GUICtrlSetTip(-1, $txtTip)
		$picDBAttackNearDarkElixirDrill = GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 20 , $y - 3, 24, 24)
 			GUICtrlSetTip(-1, $txtTip)
	Local $x = 30, $y = 335
		$lblUseInBattleDB = GUICtrlCreateLabel(GetTranslated(3,68, "Use in battle") & ":", $x, $y + 5, -1, -1)
		$y +=27
			GUICtrlCreateIcon($pIconLib, $eIcnKing, $x , $y, 24, 24)
			$txtTip = GetTranslated(3,41, "Use your King when Attacking..")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBKingAttack = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x += 50
		GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x, $y, 24, 24)
			$txtTip = GetTranslated(3,43, "Use your Queen when Attacking..")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBQueenAttack = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x -=50
		$y += 27
		GUICtrlCreateIcon($pIconLib, $eIcnWarden, $x, $y, 24, 24)
			$txtTip = GetTranslated(3,69, "Use your Warden when Attacking..")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBWardenAttack = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x += 50
			GUICtrlCreateIcon($pIconLib, $eIcnCC, $x, $y, 24, 24)
			$txtTip =GetTranslated(3,45, "Drop your Clan Castle in battle if it contains troops.")
			GUICtrlSetTip(-1, $txtTip)
		$chkDBDropCC = GUICtrlCreateCheckbox( "", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 260, $y = 150
	$grpLiveBaseDeploy = GUICtrlCreateGroup(GetTranslated(3,46, "LiveBase Deploy"), $x - 20, $y - 20, 220, 295);95)
		$lblABDeploy = GUICtrlCreateLabel(GetTranslated(3,3, -1) & ":", $x, $y + 5, -1, -1)
		$cmbABDeploy = GUICtrlCreateCombo("", $x + 55, $y, 120, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(3,4, -1) & @CRLF & GetTranslated(3,5, -1) & @CRLF & GetTranslated(3,6, -1) & @CRLF & GetTranslated(3,63, -1) & @CRLF & GetTranslated(3,64, "Attack on the single side closest to the Dark Elixir Storage") & @CRLF & GetTranslated(3,65, "Attack on the single side closest to the Townhall"), GetTranslated(3,7, -1))
			GUICtrlSetData(-1, GetTranslated(3,8, -1) & "|" & GetTranslated(3,9, -1) & "|" & GetTranslated(3,10, -1) & "|" & GetTranslated(3,11, -1) & "|" & GetTranslated(3,66, "DE Side Attack") & "|" & GetTranslated(3,67, "TH Side Attack"), GetTranslated(3,11, -1))
			GUICtrlSetOnEvent(-1, "chkDESideEB")
		$y += 25
		$lblABSelectTroop=GUICtrlCreateLabel(GetTranslated(3,12, -1) & ":",$x, $y + 5, -1 , -1)
		$cmbABSelectTroop=GUICtrlCreateCombo("", $x + 55, $y, 120, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(3,13, -1) & "|" & GetTranslated(3,14, -1)&"|"&GetTranslated(3,15, -1)&"|" & GetTranslated(3,16, -1) & "|" & GetTranslated(3,17, -1) & "|" & GetTranslated(3,18, -1) & "|" & GetTranslated(3,19, -1) & "|" & GetTranslated(3,20, -1) & "|" & GetTranslated(3,21, -1) & "|" & GetTranslated(3,22, -1) & "|" & GetTranslated(3,23, -1) , GetTranslated(3,13, -1))
		$y += 25
		$lblABUnitDelay = GUICtrlCreateLabel(GetTranslated(3,24, "Delay Unit") & ":", $x, $y + 5, -1, -1)
			$txtTip = GetTranslated(3,25, -1) & @CRLF & GetTranslated(3,26, -1)
			GUICtrlSetTip(-1, $txtTip)
		$cmbABUnitDelay = GUICtrlCreateCombo("", $x + 55, $y, 36, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "5")
		$lblABWaveDelay = GUICtrlCreateLabel(GetTranslated(3,27, -1) & ":", $x + 100, $y + 5, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
		$cmbABWaveDelay = GUICtrlCreateCombo("", $x + 140, $y, 36, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "5")
		$y += 22
		$chkABRandomSpeedAtk = GUICtrlCreateCheckbox(GetTranslated(3,28, -1), $x, $y, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABRandomSpeedAtk")
	$y = 250
		$chkABSmartAttackRedArea = GUICtrlCreateCheckbox(GetTranslated(3,29, -1), $x, $y, -1, -1)
			$txtTip = GetTranslated(3,30, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkABSmartAttackRedArea")
		$y += 22
		$lblABSmartDeploy = GUICtrlCreateLabel(GetTranslated(3,31, -1), $x, $y + 5, -1, -1)
			$txtTip = GetTranslated(3,32, -1)& @CRLF & GetTranslated(3,33, -1) & @CRLF & GetTranslated(3,34, -1)
			GUICtrlSetTip(-1, $txtTip)
		$cmbABSmartDeploy = GUICtrlCreateCombo("", $x + 55, $y, 120, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(3,35, -1) & "|" & GetTranslated(3,36, -1), GetTranslated(3,35, -1))
			GUICtrlSetTip(-1, $txtTip)
		$y += 26
		$chkABAttackNearGoldMine = GUICtrlCreateCheckbox("", $x + 20, $y, 17, 17)
			$txtTip = GetTranslated(3,37, -1)
			GUICtrlSetTip(-1, $txtTip)
		$picABAttackNearGoldMine = GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 40 , $y - 3 , 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$x += 75
		$chkABAttackNearElixirCollector = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = GetTranslated(3,38, -1)
			GUICtrlSetTip(-1, $txtTip)
		$picABAttackNearElixirCollector = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20 , $y - 3 , 24, 24)
			GUICtrlSetTip(-1, $txtTip)
 		$x += 55
  		$chkABAttackNearDarkElixirDrill = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = GetTranslated(3,39, -1)
 			GUICtrlSetTip(-1, $txtTip)
		$picABAttackNearDarkElixirDrill = GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 20 , $y - 3, 24, 24)
 			GUICtrlSetTip(-1, $txtTip)
	$x -= 70
	$y = 335
		$lblUseInBattleDB = GUICtrlCreateLabel(GetTranslated(3,68, -1) & ":", $x, $y + 5, -1, -1)
		$y +=27
		GUICtrlCreateIcon($pIconLib, $eIcnKing, $x, $y, 24, 24)
			$txtTip = GetTranslated(3,41, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABKingAttack = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x += 50
		GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x, $y, 24, 24)
			$txtTip = GetTranslated(3,43, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABQueenAttack = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$y += 27
		$x -= 50
		GUICtrlCreateIcon($pIconLib, $eIcnWarden, $x, $y, 24, 24)
			$txtTip = GetTranslated(3,69, -1)
			GUICtrlSetTip(-1, $txtTip)
		$chkABWardenAttack = GUICtrlCreateCheckbox("", $x + 30, $y,17, 17)
			GUICtrlSetTip(-1, $txtTip)
		$x += 50
		GUICtrlCreateIcon($pIconLib, $eIcnCC, $x, $y, 24, 24)
		$chkABDropCC = GUICtrlCreateCheckbox("", $x + 30, $y, 17, 17)
			GUICtrlSetTip(-1, GetTranslated(3,45, -1))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 200, $y = 345
	$grpClanCastleBal = GUICtrlCreateGroup(GetTranslated(3,47, "ClanCastle Balance"), $x - 20, $y - 20, 110, 100)
		GUICtrlCreateLabel("", $x - 18, $y - 7, 106, 85) ; fake label to hide group border from DB and LB setting groups
		GUICtrlSetBkColor (-1, $COLOR_WHITE)
		GUICtrlSetState (-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnCC, $x + 25, $y - 5, 24, 24)
		$y += 21
		$chkUseCCBalanced = GUICtrlCreateCheckbox(GetTranslated(3,48, "Balance D/R"), $x - 5, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetTip(-1, GetTranslated(3,49, "Drop your Clan Castle only if your donated/received ratio is greater than D/R ratio below."))
			GUICtrlSetOnEvent(-1, "chkBalanceDR")
		$y += 25
		$cmbCCDonated = GUICtrlCreateCombo("",  $x - 5, $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(3,50, "Donated ratio"))
			GUICtrlSetData(-1, "1|2|3|4|5", "1")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbBalanceDR")
		$lblDRRatio = GUICtrlCreateLabel("/", $x + 31, $y + 5, -1, -1)
			$txtTip = GetTranslated(3,51, "Wanted donated / received ratio") & @CRLF & GetTranslated(3,52, "1/1 means donated = received, 1/2 means donated = half the received etc.")
			GUICtrlSetTip(-1, $txtTip)
		$cmbCCReceived = GUICtrlCreateCombo("", $x + 44, $y, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, GetTranslated(3,53, "Received ratio"))
			GUICtrlSetData(-1, "1|2|3|4|5", "1")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbBalanceDR")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 450
	$grpRoyalAbilities = GUICtrlCreateGroup(GetTranslated(3,54, "Hero Abilities"), $x - 20, $y - 20, 450, 75)
		;GUICtrlCreatePic (@ScriptDir & "\Icons\KingAbility.jpg", $x, $y - 3, 30, 47)
		;GUICtrlCreatePic (@ScriptDir & "\Icons\QueenAbility.jpg", $x + 30, $y - 3, 30, 47)
		;GUICtrlCreatePic (@ScriptDir & "\Icons\QueenAbility.jpg", $x + 60, $y - 3, 30, 47) ;change with Warden Icon
		GUICtrlCreateIcon($pIconLib, $eIcnKingAbility, $x, $y-2, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnQueenAbility, $x+ 30, $y-2, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnWardenAbility, $x+ 15, $y + 25, 24, 24)

		$x += 60
		$y -= 8
		$radManAbilities = GUICtrlCreateRadio(GetTranslated(3,55, "Timed activation of Heroes Abilities after") & ":", $x, $y -1, -1, -1)
			$txtTip = GetTranslated(3,56, "Activate the Ability on a timer.") & @CRLF & GetTranslated(3,57, "All Heroes are activated at the same time.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$radAutoAbilities = GUICtrlCreateRadio(GetTranslated(3,58, "Auto activate Heroes when they become weak (red zone)."), $x, $y + 17, -1, -1)
		$txtTip = GetTranslated(3,59, "Activate the Ability when the Hero becomes weak.") & @CRLF & GetTranslated(3,60, "Heroes are checked and activated individually.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$txtManAbilities = GUICtrlCreateInput("9", $x + 260, $y, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(3,61, "Set the time in seconds for Timed Activation of Hero Abilities.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
		$lblRoyalAbilitiesSec = GUICtrlCreateLabel(GetTranslated(3,62, "sec."), $x + 295, $y + 3, -1, -1)
		$y += 40
		$chkUseWardenAbility = GUICtrlCreateCheckbox(GetTranslated(3,70, "Timed activation of Warden Ability after") & ":", $x, $y, -1, -1)
			$txtTip = GetTranslated(3,71, "Use the ability of the Grand Warden on a timer.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED+$GUI_DISABLE+$GUI_HIDE)
			GUICtrlSetColor (-1,$COLOR_RED)
		$txtWardenAbility = GUICtrlCreateInput("25", $x + 260, $y, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(3,72, "Set the time in seconds for Timed Activation of Grand Warden Ability.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE+$GUI_HIDE)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetColor (-1,$COLOR_RED)
		$lblWardenAbilitiesSec = GUICtrlCreateLabel(GetTranslated(3,62, -1), $x + 293, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE+$GUI_HIDE)
			GUICtrlSetColor (-1,$COLOR_RED)


	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
