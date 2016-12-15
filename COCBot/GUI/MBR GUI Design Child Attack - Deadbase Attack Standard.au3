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

$hGUI_DEADBASE_ATTACK_STANDARD = GUICreate("", $_GUI_MAIN_WIDTH - 195, $_GUI_MAIN_HEIGHT - 344, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_DEADBASE)
;GUISetBkColor($COLOR_WHITE, $hGUI_DEADBASE_ATTACK_STANDARD)

Local $x = 25, $y = 20
	$grpDeployDB = GUICtrlCreateGroup(GetTranslated(608,1,"Deploy"), $x - 20, $y - 20, 270, 306)
;	$x -= 15
		$lblDBmode = GUICtrlCreateLabel(GetTranslated(608,2,"Troop Drop Order"),$x, $y, 143,18,$SS_LEFT)
	$y += 15
		$cmbStandardAlgorithmDB = GUICtrlCreateCombo("", $x, $y, 150, Default, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(608,25,"Default(All Troops)")&"|Barch/BAM/BAG|GiBarch", GetTranslated(608,25, -1))
			_GUICtrlSetTip(-1, GetTranslated(608,33,"Select a preset troop drop order.")&@CRLF&GetTranslated(608,34,"Each option deploys troops in a different order and in different waves")&@CRLF&GetTranslated(608,35,"Only the troops selected in the ""Only drop these troops"" option will be dropped"))
	$y += 25
		$lblDeployDB = GUICtrlCreateLabel(GetTranslated(608,3, "Attack on")&":", $x, $y + 5, -1, -1)
		$cmbDeployDB = GUICtrlCreateCombo("", $x + 55, $y, 120, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslated(608,4, "Attack on a single side, penetrates through base") & @CRLF & GetTranslated(608,5, "Attack on two sides, penetrates through base") & @CRLF & GetTranslated(608,6, "Attack on three sides, gets outer and some inside of base"), GetTranslated(608,7,"Select the No. of sides to attack on."))
			GUICtrlSetData(-1, GetTranslated(608,8, "one side") & "|" & GetTranslated(608,9, "two sides") & "|" & GetTranslated(608,10, "three sides") &"|" & GetTranslated(608,11,"all sides equally" ), GetTranslated(608,11, -1))
		$y += 25
		$lblUnitDelayDB = GUICtrlCreateLabel(GetTranslated(608,12, "Delay Unit") & ":", $x, $y + 5, -1, -1)
			$txtTip = GetTranslated(608,13, "This delays the deployment of troops, 1 (fast) = like a Bot, 10 (slow) = Like a Human.") & @CRLF & GetTranslated(608,14, "Random will make bot more varied and closer to a person.")
			_GUICtrlSetTip(-1, $txtTip)
		$cmbUnitDelayDB = GUICtrlCreateCombo("", $x + 55, $y, 36, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "4")
		$lblWaveDelayDB = GUICtrlCreateLabel(GetTranslated(608,15, "Wave") & ":", $x + 100, $y + 5, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$cmbWaveDelayDB = GUICtrlCreateCombo("", $x + 140, $y, 36, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "4")
		$y += 22
		$chkRandomSpeedAtkDB = GUICtrlCreateCheckbox(GetTranslated(608,16, "Randomize delay for Units && Waves"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkRandomSpeedAtkDB")
	$y +=22
		$chkSmartAttackRedAreaDB = GUICtrlCreateCheckbox(GetTranslated(608,17, "Use Smart Attack: Near Red Line."), $x, $y, -1, -1)
			$txtTip = GetTranslated(608,18, "Use Smart Attack to detect the outer 'Red Line' of the village to attack. And drop your troops close to it.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkSmartAttackRedAreaDB")
		$y += 22
		$lblSmartDeployDB = GUICtrlCreateLabel(GetTranslated(608,19, "Drop Type") & ":", $x, $y + 5, -1, -1)
			$txtTip = GetTranslated(608,20, "Select the Deploy Mode for the waves of Troops.") & @CRLF & GetTranslated(608,21, "Type 1: Drop a single wave of troops on each side then switch troops, OR") & @CRLF & GetTranslated(608,22, "Type 2: Drop a full wave of all troops (e.g. giants, barbs and archers) on each side then switch sides.")
			_GUICtrlSetTip(-1, $txtTip)
		$cmbSmartDeployDB = GUICtrlCreateCombo("", $x + 55, $y, 120, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslated(608,23, "Sides, then Troops") & "|" & GetTranslated(608,24, "Troops, then Sides") , GetTranslated(608,23, -1))
			_GUICtrlSetTip(-1, $txtTip)
		$y += 26
		$chkAttackNearGoldMineDB = GUICtrlCreateCheckbox("", $x + 20, $y, 17, 17)
			$txtTip = GetTranslated(608,26, "Drop troops near Gold Mines")
			_GUICtrlSetTip(-1, $txtTip)
		$picAttackNearGoldMineDB = GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 40 , $y - 3 , 24, 24)
			_GUICtrlSetTip(-1, $txtTip)
		$x += 75
		$chkAttackNearElixirCollectorDB = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = GetTranslated(608,27, "Drop troops near Elixir Collectors")
			_GUICtrlSetTip(-1, $txtTip)
		$picAttackNearElixirCollectorDB = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20 , $y - 3 , 24, 24)
			_GUICtrlSetTip(-1, $txtTip)
 		$x += 55
  		$chkAttackNearDarkElixirDrillDB = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = GetTranslated(608,28, "Drop troops near Dark Elixir Drills")
 			_GUICtrlSetTip(-1, $txtTip)
		$picAttackNearDarkElixirDrillDB = GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 20 , $y - 3, 24, 24)
 			_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

;GUISetState()
