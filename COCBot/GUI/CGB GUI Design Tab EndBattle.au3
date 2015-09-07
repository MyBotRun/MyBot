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
;~ End Battle
;~ -------------------------------------------------------------
$tabEndBattle = GUICtrlCreateTabItem("End Battle")
   Local $x = 30, $y = 150
	$grpBattleOptions = GUICtrlCreateGroup("End Battle", $x - 20, $y - 20, 450, 170)
		$chkTimeStopAtk = GUICtrlCreateCheckbox("When no New loot raided within:",$x, $y, -1, -1)
			$txtTip = "End Battle if there is no extra loot raided within this No. of seconds." & @CRLF & "Countdown is started after all Troops and Royals are deployed in battle."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkTimeStopAtk")
			GUICtrlSetState(-1, $GUI_CHECKED)
		$txtTimeStopAtk = GUICtrlCreateInput("20", $x + 180, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			;GUICtrlSetData(-1, 10) ; default value
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
		$lblTimeStopAtk = GUICtrlCreateLabel("sec.", $x + 215, $y + 3, -1, -1)
   $y += 25
		$chkTimeStopAtk2 = GUICtrlCreateCheckbox("When no New loot raided within:",$x, $y, -1, -1)
			$txtTip = "End Battle if there is no extra loot raided within this No. of seconds." & @CRLF & "Countdown is started after all Troops and Royals are deployed in battle."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkTimeStopAtk2")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$txtTimeStopAtk2 = GUICtrlCreateInput("5", $x + 180, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblTimeStopAtk2 = GUICtrlCreateLabel("sec.", $x + 215, $y + 3, -1, -1)
	$y += 21
		$lblMinRerourcesAtk2 = GUICtrlCreateLabel("And Resources are below:", $x + 20 , $y + 2, -1, -1)
		$lblMinGoldStopAtk2 = GUICtrlCreateLabel("<", $x + 150 , $y + 2, -1, -1)
			$txtTip = "End Battle if below this amount of Gold."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtMinGoldStopAtk2 = GUICtrlCreateInput("2000", $x + 160, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picMinGoldStopAtk2 = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 212, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)

		$lblMinElixirStopAtk2 = GUICtrlCreateLabel(", <", $x + 230, $y + 2, -1, -1)
			$txtTip = "End Battle if below this amount of Elixir."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtMinElixirStopAtk2 = GUICtrlCreateInput("2000", $x + 245, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picMinElixirStopAtk2 = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 297, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)

		$lblMinDarkElixirStopAtk2 = GUICtrlCreateLabel("and <", $x + 320 , $y +2, -1, -1)
			$txtTip = "End Battle if below this amount of Dark Elixir."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtMinDarkElixirStopAtk2 = GUICtrlCreateInput("50", $x + 350, $y , 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picMinDarkElixirStopAtk2 = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 392, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
	$y += 20
		$chkEndNoResources = GUICtrlCreateCheckbox("When no Resources left", $x , $y , -1, -1)
			$txtTip = "End Battle when all Gold, Elixir and Dark Elixir = 0"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 30
		$chkEndOneStar = GUICtrlCreateCheckbox("When One Star is won:", $x, $y , -1, -1)
			$txtTip = "Will End the Battle if 1 star is won in battle"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
		$picEndOneStar = GUICtrlCreateIcon($pIconLib, $eIcnSilverStar, $x + 145, $y + 2, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
	$y += 20
		$chkEndTwoStars = GUICtrlCreateCheckbox("When Two Stars are won:", $x, $y, -1, -1)
			$txtTip = "Will End the Battle if 2 stars are won in battle"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
		$picEndTwoStar = GUICtrlCreateIcon($pIconLib, $eIcnSilverStar, $x + 145, $y + 2, 16, 16)
		$picEndTwoStar2 = GUICtrlCreateIcon($pIconLib, $eIcnSilverStar, $x + 162, $y + 2, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 325
	$grpLootSnapshot = GUICtrlCreateGroup("Loot Snapshot", $x - 20, $y - 20, 450, 50)
		$chkTakeLootSS = GUICtrlCreateCheckbox("Take Loot Snapshot", $x, $y, -1, -1)
			GUICtrlSetTip(-1, "Check this if you want to save a Loot snapshot of the Village that was attacked.")
			GUICtrlSetState(-1, $GUI_CHECKED)
		$chkScreenshotLootInfo = GUICtrlCreateCheckbox("Include loot info in filename", $x + 200 , $y , -1, -1)
			GUICtrlSetTip(-1, "Include loot info in the screenshot filename")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 30, $y = 380
	$grpResources = GUICtrlCreateGroup("Share Attack Replays", $x - 20, $y - 20, 450, 145)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkShareAttack = GUICtrlCreateCheckbox("Share a Replay in your clan's chat.", $x, $y, -1, -1)
			$TxtTip = "Check this to share your battle replay in the clan chat."
			GUICtrlSetTip(-1, $TxtTip)
			GUICtrlSetOnEvent(-1, "chkShareAttack")
		$y += 30
		$lblShareMinGold = GUICtrlCreateLabel("When Battle Loot:  >", $x + 20 , $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtShareMinGold = GUICtrlCreateInput("300000", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Only Share Replay when the battle loot is more than this amount of Gold."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picShareLootGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 182, $y, 16, 16)
		$y += 22
		$lblShareMinElixir = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtShareMinElixir = GUICtrlCreateInput("300000", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Only Share Replay when the battle loot is more than this amount of Elixir."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picShareLootElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 182, $y, 16, 16)
		$y += 22
		$lblShareMinDark = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtShareMinDark = GUICtrlCreateInput("0", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = "Only Share Replay when the battle loot is more than this amount of Dark Elixir."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picShareLootDarkElixir = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 182, $y, 16, 16)
	Local $x = 240, $y = 380
		$lblShareMessage = GUICtrlCreateLabel("Use a random message from this list:", $x , $y -2 , -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
	    $y += 27
		$txtShareMessage = GUICtrlCreateEdit("", $x, $y - 10 , 205, 80, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetData(-1, StringFormat("Nice\r\nGood\r\nThanks \r\nWowwww"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetTip(-1, "Message to send with the Share Replay")
	    $y += 73
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
