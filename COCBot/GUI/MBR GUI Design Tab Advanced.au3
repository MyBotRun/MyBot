; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), Promac (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
;~ Attack Advanced Tab
;~ -------------------------------------------------------------
 $tabAttackAdv = GUICtrlCreateTabItem("Attack Adv.")
	Local $x = 30, $y = 150
	$grpAtkOptions = GUICtrlCreateGroup("Attack Options", $x - 20, $y - 20, 450, 85)
		$y -=5
		$chkAttackNow = GUICtrlCreateCheckbox("Attack Now! option.", $x-10, $y, -1, -1)
			$txtTip = "Check this if you want the option to have an 'Attack Now!' button next to" & @CRLF & _
				"the Start and Pause buttons to bypass the dead base or all base search values." & @CRLF & _
				"The Attack Now! button will only appear when searching for villages to Attack."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkAttackNow")
		$y +=22
		$lblAttackNow = GUICtrlCreateLabel("Add:", $x - 10, $y + 4, -1, -1, $SS_RIGHT)
			$txtTip = "Add this amount of reaction time to slow down the search."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$cmbAttackNowDelay = GUICtrlCreateCombo("", $x + 20, $y + 1, 35, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "5|4|3|2|1","3") ; default value 3
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblAttackNowSec = GUICtrlCreateLabel("sec. delay", $x + 57, $y + 4, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y +=22
		$chkAttackTH = GUICtrlCreateCheckbox("Attack Townhall Outside", $x-10, $y, -1, -1)
			GUICtrlSetTip(-1, "Check this to Attack an exposed Townhall first. (Townhall outside of Walls)" & @CRLF & "TIP: Also tick 'Meet Townhall Outside' on the Search tab if you only want to search for bases with exposed Townhalls.")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 240
    $grpTHSnipeAttackCombo = GUICtrlCreateGroup("TH Snipe Attack Combo", $x - 20, $y - 20, 225, 285)
		$y -= 5
		$chkTrophyMode = GUICtrlCreateCheckbox("Enable TH Snipe Combo", $x-10, $y, -1, -1)
			$txtTip = "Adds the TH Snipe combination to the current search settings. (Example: Deadbase OR TH Snipe)"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSnipeMode")
		$y+= 25
		$lblTHadd = GUICtrlCreateLabel( "Add:", $x -10, $y+5, -1, 17, $SS_RIGHT)
		    $txtTip = "Enter how many 'Grass' 1x1 tiles the TH may be from the Base edges to be seen as a TH Outside." & @CRLF & "Ex: (0) tiles; TH must be exactly at the edge. (4) tiles: TH may be 4 tiles farther from edges and closer to the center of the village." & @CRLF & "If the TH is farther away then the No. of tiles set, the base will be skipped."
			GUICtrlSetTip(-1, $txtTip)
		$lblTHaddtiles = GUICtrlCreateLabel( "tile(s) from Base Edges", $x + 57, $y+5, -1, 17)
		    GUICtrlSetTip(-1, $txtTip)
		$txtTHaddtiles = GUICtrlCreateInput("2", $x + 20, $y, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y+= 30
		$lblAttackTHType = GUICtrlCreateLabel("Attack TH Type:", $x - 8 , $y + 5 , -1, 17, $SS_RIGHT)
		$cmbAttackTHType = GUICtrlCreateCombo("",  $x + 80, $y, 120, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Attack: SmartBarch|Attack: Bam|Attack: eXtreme|Attack: GBarch|Attack: Custom", "Attack: GBarch")
            $txtTip = "SMARTBARCH • Barbs/Archers" & @CRLF & "BAM • Barbs/Archers/Minions" & @CRLF & "EXTREME • Use All troops" & @CRLF & "GBARCH • Giants/Barbs/Archers"& @CRLF & "CUSTOM • Make your own strategy!"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
        $y +=25
		$lblAttackBottomType = GUICtrlCreateLabel("If TH is at bottom:", $x -15 , $y + 5, -1, 17, $SS_RIGHT)
		$cmbAttackbottomType = GUICtrlCreateCombo("",  $x + 80, $y, 120, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Deploy: Zoomed In|Deploy: On Sides", "Deploy: On Sides")
			$txtTip = "Select your strategy to deploy troops when the TH is detected on the Bottom of the screen!" & @CRLF & "Zoomed in • Zoom in first, then Attack from bottom." & @CRLF & "On Sides • Try to get the TH from the left and right without zooming in, your troops may pick another target!"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 30
		GUICtrlCreateIcon($pIconLib, $eIcnKing, $x - 16 , $y, 24, 24)
		$chkUseKingTH = GUICtrlCreateCheckbox("Use King", $x + 12 , $y+1, -1, -1)
			$txtTip = "Use King when Attacking TH Snipe" & @CRLF & "Will be deployed in First wave"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x + 102 , $y, 24, 24)
		$chkUseLSpellsTH = GUICtrlCreateCheckbox("Use LSpell", $x + 130 , $y+1, -1, -1)
			$txtTip = "Use Lighting spells when Attacking TH Snipe" & @CRLF & "Will be deployed in Third wave"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 27
		GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x - 16 , $y, 24, 24)
		$chkUseQueenTH = GUICtrlCreateCheckbox("Use Queen", $x + 12 , $y+1, -1, -1)
			$txtTip = "Use Queen when Attacking TH Snipe" & @CRLF & "Will be deployed in First wave"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnRageSpell, $x + 102 , $y, 24, 24)
		$chkUseRSpellsTH = GUICtrlCreateCheckbox("Use RSpell", $x + 130 , $y+1, -1, -1)
			$txtTip = "Use Rage spells when Attacking TH Snipe" & @CRLF & "Will be deployed in Third wave"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 27
		GUICtrlCreateIcon($pIconLib, $eIcnCC, $x - 16, $y, 24, 24)
		$chkUseClastleTH = GUICtrlCreateCheckbox("Drop in Battle", $x + 12 , $y+1, -1, -1)
			$txtTip = "Use Clan Castle when Attacking TH Snipe" & @CRLF & "Will be deployed in Second wave"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnHealSpell, $x + 102 , $y, 24, 24)
		$chkUseHSpellsTH = GUICtrlCreateCheckbox("Use HSpell", $x + 130 , $y+1, -1, -1)
			$txtTip = "Use Heal spells when Attacking TH Snipe" & @CRLF & "Will be deployed in Second wave"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
    GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 260, $y = 240
	$grpBullyAtkCombo = GUICtrlCreateGroup("Bully Attack Combo", $x - 20, $y - 20, 220, 110)
	    $y -= 5
		$x -= 10
		$chkBullyMode = GUICtrlCreateCheckbox("TH Bully.  After:", $x, $y, -1, -1)
			$txtTip = "Adds the TH Bully combo to the current search settings. (Example: Deadbase OR TH Bully)" & @CRLF & _
				"TH Bully: Attacks a lower townhall level after the specified No. of searches."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkBullyMode")
		$txtATBullyMode = GUICtrlCreateInput("150", $x + 95, $y, 35, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "TH Bully: No. of searches to wait before activating."
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblATBullyMode = GUICtrlCreateLabel("search(es).", $x + 135, $y + 5, -1, -1)
		$y +=25
		$lblATBullyMode = GUICtrlCreateLabel("Max TH level:", $x + 10, $y + 3, -1, -1, $SS_RIGHT)
		$cmbYourTH = GUICtrlCreateCombo("", $x + 95, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = "TH Bully: Max. Townhall level to bully."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "4-6|7|8|9|10", "4-6")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 24
		GUICtrlCreateLabel("When found, Attack with settings from:", $x + 10, $y, -1, -1, $SS_RIGHT)
		$y += 14
		$radUseDBAttack = GUICtrlCreateRadio("DeadBase Atk.", $x + 20, $y, -1, -1)
			GUICtrlSetTip(-1, "Use Dead Base attack settings when attacking a TH Bully match.")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$radUseLBAttack = GUICtrlCreateRadio("LiveBase Atk.", $x + 115, $y, -1, -1)
			GUICtrlSetTip(-1, "Use Live Base attack settings when attacking a TH Bully match.")
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 260, $y = 355
	$grpDefenseFarming = GUICtrlCreateGroup("Defense Farming", $x - 20, $y - 20, 220, 170)
		$chkUnbreakable = GUICtrlCreateCheckbox("Enable Unbreakable Mode", $x, $y, -1, -1)
			$TxtTip = "Enable farming Defense Wins for Unbreakable achievement." ;& @CRLF & "TIP: Set your trophy range on the Misc Tab to '600 - 800' for best results. WARNING: Doing so will DROP you Trophies!"
			GUICtrlSetTip(-1, $TxtTip)
			GUICtrlSetOnEvent(-1, "chkUnbreakable")
		$y += 23
		$lblUnbreakable1 = GUICtrlCreateLabel("Wait Time:", $x + 20 , $y + 3, -1, -1, $SS_RIGHT)
		$txtUnbreakable = GUICtrlCreateInput("5", $x + 80, $y, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$TxtTip = "Set the amount of time to stop CoC and wait for enemy attacks to gain defense wins. (1-99 minutes)"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblUnbreakable2 = GUICtrlCreateLabel("Minutes", $x + 113, $y+3, -1, -1)
		$y += 28
		$lblUnBreakableFarm = GUICtrlCreateLabel("Farm Min.", $x + 25 , $y, -1, -1)
		$lblUnBreakableSave = GUICtrlCreateLabel("Save Min.", $x + 115 , $y, -1, -1)
		$y += 16
		$txtUnBrkMinGold = GUICtrlCreateInput("50000", $x + 20, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Amount of Gold that stops Defense farming, switches to normal farming if below." & @CRLF & "Set this value to amount of Gold you need for searching or upgrades.")
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 80, $y + 2, 16, 16)
		$txtUnBrkMaxGold = GUICtrlCreateInput("600000", $x + 110, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Amount of Gold in Storage Required to Enable Defense Farming." & @CRLF & "Input amount of Gold you need to attract enemy or for upgrades.")
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 170, $y + 2, 16, 16)
		$y += 26
		$txtUnBrkMinElixir = GUICtrlCreateInput("50000", $x + 20, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Amount of Elixir that stops Defense farming, switches to normal farming if below." & @CRLF & "Set this value to amount of Elixir you need for making troops or upgrades.")
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 80, $y, 16, 16)
		$txtUnBrkMaxElixir = GUICtrlCreateInput("600000", $x + 110, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Amount of Elixir in Storage Required to Enable Defense Farming." & @CRLF & "Input amount of Elixir you need to attract enemy or for upgrades.")
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 170, $y, 16, 16)
		$y += 24
		$txtUnBrkMinDark = GUICtrlCreateInput("5000", $x + 20, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Amount of Dark Elixir that stops Defense farming, switches to normal farming if below." & @CRLF & "Set this value to amount of Dark Elixir you need for making troops or upgrades.")
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 80, $y, 16, 16)
		$txtUnBrkMaxDark = GUICtrlCreateInput("6000", $x + 110, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, "Amount of Dark Elixir in Storage Required to Enable Defense Farming." & @CRLF & "Input amount of Dark Elixir you need to attract enemy or for upgrades.")
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 170, $y, 16, 16)
    GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateTabItem("")
