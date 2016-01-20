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
;~ End Battle
;~ -------------------------------------------------------------
$tabEndBattle = GUICtrlCreateTabItem(GetTranslated(5,1, "End Battle"))
   Local $x = 30, $y = 150
   $grpBattleOptions = GUICtrlCreateGroup(GetTranslated(5,2, "End Battle"), $x - 20, $y - 20, 450, 220)
	$y -=5
		$chkTimeStopAtk = GUICtrlCreateCheckbox(GetTranslated(5,3, "When no New loot raided within") & ":",$x, $y, -1, -1)
			$txtTip = GetTranslated(5,4, "End Battle if there is no extra loot raided within this No. of seconds.") & @CRLF & GetTranslated(5,5, "Countdown is started after all Troops and Royals are deployed in battle.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkTimeStopAtk")
			GUICtrlSetState(-1, $GUI_CHECKED)
		$txtTimeStopAtk = GUICtrlCreateInput("20", $x + 180, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
		$lblTimeStopAtk = GUICtrlCreateLabel(GetTranslated(5,6, "sec."), $x + 215, $y + 3, -1, -1)
   $y += 20
		$chkTimeStopAtk2 = GUICtrlCreateCheckbox(GetTranslated(5,3, -1) & ":",$x, $y, -1, -1)
			$txtTip = GetTranslated(5,4, -1) & @CRLF & GetTranslated(5,5, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkTimeStopAtk2")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$txtTimeStopAtk2 = GUICtrlCreateInput("5", $x + 180, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblTimeStopAtk2 = GUICtrlCreateLabel(GetTranslated(5,6, -1), $x + 215, $y + 3, -1, -1)
	$y += 21
		$lblMinRerourcesAtk2 = GUICtrlCreateLabel(GetTranslated(5,7, "And Resources are below") & ":", $x + 20 , $y + 2, -1, -1)
		$lblMinGoldStopAtk2 = GUICtrlCreateLabel("<", $x + 150 , $y + 2, -1, -1)
			$txtTip = GetTranslated(5,8, "End Battle if below this amount of Gold.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtMinGoldStopAtk2 = GUICtrlCreateInput("2000", $x + 160, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picMinGoldStopAtk2 = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 212, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)

		$lblMinElixirStopAtk2 = GUICtrlCreateLabel(", <", $x + 230, $y + 2, -1, -1)
			$txtTip = GetTranslated(5,9, "End Battle if below this amount of Elixir.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtMinElixirStopAtk2 = GUICtrlCreateInput("2000", $x + 245, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picMinElixirStopAtk2 = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 297, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)

		$lblMinDarkElixirStopAtk2 = GUICtrlCreateLabel("and <", $x + 320 , $y +2, -1, -1)
			$txtTip = GetTranslated(5,10, "End Battle if below this amount of Dark Elixir.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtMinDarkElixirStopAtk2 = GUICtrlCreateInput("50", $x + 350, $y , 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picMinDarkElixirStopAtk2 = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 392, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
	$y += 15
		$chkEndNoResources = GUICtrlCreateCheckbox(GetTranslated(5,11, "When no Resources left"), $x , $y , -1, -1)
			$txtTip = GetTranslated(5,12, "End Battle when all Gold, Elixir and Dark Elixir = 0")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 20
		$chkEndOneStar = GUICtrlCreateCheckbox(GetTranslated(5,13, "When One Star is won") & ":", $x, $y , -1, -1)
			$txtTip = GetTranslated(5,14, "Will End the Battle if 1 star is won in battle")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
		$picEndOneStar = GUICtrlCreateIcon($pIconLib, $eIcnSilverStar, $x + 145, $y + 2, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
	$y += 20
		$chkEndTwoStars = GUICtrlCreateCheckbox(GetTranslated(5,15, "When Two Stars are won") & ":", $x, $y, -1, -1)
			$txtTip = GetTranslated(5,16, "Will End the Battle if 2 stars are won in battle")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
		$picEndTwoStar = GUICtrlCreateIcon($pIconLib, $eIcnSilverStar, $x + 145, $y + 2, 16, 16)
		$picEndTwoStar2 = GUICtrlCreateIcon($pIconLib, $eIcnSilverStar, $x + 162, $y + 2, 16, 16)
	$y += 30
		GUICtrlCreateLabel(GetTranslated(5,17, "Attack Dark Elixir Side, End Battle Options") & ":", $x - 10, $y , -1, -1)
			$txtTip = GetTranslated(5,18, "Enabled by selecting DE side attack in LiveBase Deploy - Attack On: options")
			GUICtrlSetTip(-1, $txtTip)
	$y += 15
		$chkDESideEB = GUICtrlCreateCheckbox(GetTranslated(5,19, "When below") & ": <", $x , $y , -1, -1)
			$txtTip = GetTranslated(5,20, "Enables Special conditions for Dark Elixir side attack.") & @CRLF & GetTranslated(5,21, "If no additional filters are selected will end battle when below Total Dark Elixir Percent.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "chkDESideEB")
		$txtDELowEndMin = GUICtrlCreateInput("25", $x + 92, $y , 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblDELowEndMin = GUICtrlCreateLabel("%", $x + 136 , $y + 2 , -1, -1)
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 147, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
	$y += 20
		$chkDisableOtherEBO = GUICtrlCreateCheckbox(GetTranslated(5,22, "Disable Normal End Battle Options"), $x, $y, -1, -1)
			$txtTip = GetTranslated(5,23, "Disable Normal End Battle Options when DE side attack is found.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
	$y -= 20
	$x += 200
		$chkDEEndOneStar = GUICtrlCreateCheckbox(GetTranslated(5,24, "When One Star is won") & ":", $x, $y , -1, -1)
			$txtTip = GetTranslated(5,25, "Will End the Battle when below min DE and One Star is won.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnSilverStar, $x + 135, $y + 2, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
	$y += 20
		$chkDEEndBk = GUICtrlCreateCheckbox(GetTranslated(5,26, "When"), $x, $y , -1, -1)
			$txtTip = GetTranslated(5,27, "Will End the Battle when below min DE and King is weak")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnKing, $x + 50, $y + 2, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$lblDEEndBk = GUICtrlCreateLabel(GetTranslated(5,28, "is weak"), $x + 70, $y + 4, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
	$y += 20
		$chkDEEndAq = GUICtrlCreateCheckbox(GetTranslated(5,26, -1), $x, $y , -1, -1)
			$txtTip = GetTranslated(5,29, "Will End the Battle when below min DE and Queen is weak")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x + 50, $y + 2, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
		$lblDEEndAq = GUICtrlCreateLabel(GetTranslated(5,28, -1), $x + 70, $y + 4, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 30, $y = 375
	$grpLootSnapshot = GUICtrlCreateGroup(GetTranslated(5,30, "Loot Snapshot"), $x - 20, $y - 20, 450, 40)
		$y -=5
		$chkTakeLootSS = GUICtrlCreateCheckbox(GetTranslated(5,44, "Take Loot Snapshot"), $x, $y, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(5,31, "Check this if you want to save a Loot snapshot of the Village that was attacked."))
			GUICtrlSetState(-1, $GUI_CHECKED)
		$chkScreenshotLootInfo = GUICtrlCreateCheckbox(GetTranslated(5,32, "Include loot info in filename"), $x + 200 , $y , -1, -1)
			GUICtrlSetTip(-1, GetTranslated(5,33, "Include loot info in the screenshot filename"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 30, $y = 420
	$grpResources = GUICtrlCreateGroup(GetTranslated(5,34, "Share Attack Replays"), $x - 20, $y - 20, 450, 105)
		$y -=5
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkShareAttack = GUICtrlCreateCheckbox(GetTranslated(5,35, "Share a Replay in your clan's chat."), $x, $y, -1, -1)
			$TxtTip = GetTranslated(5,36, "Check this to share your battle replay in the clan chat.")
			GUICtrlSetTip(-1, $TxtTip)
			GUICtrlSetOnEvent(-1, "chkShareAttack")
		$y += 25
		$lblShareMinGold = GUICtrlCreateLabel(GetTranslated(5,37, "When Battle Loot") & ":  >", $x + 20 , $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtShareMinGold = GUICtrlCreateInput("300000", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(5,38, "Only Share Replay when the battle loot is more than this amount of Gold.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picShareLootGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 182, $y, 16, 16)
		$y += 22
		$lblShareMinElixir = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtShareMinElixir = GUICtrlCreateInput("300000", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(5,39, "Only Share Replay when the battle loot is more than this amount of Elixir.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picShareLootElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 182, $y, 16, 16)
		$y += 22
		$lblShareMinDark = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtShareMinDark = GUICtrlCreateInput("0", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(5,40, "Only Share Replay when the battle loot is more than this amount of Dark Elixir.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picShareLootDarkElixir = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 182, $y, 16, 16)
	Local $x = 240, $y = 410
		$lblShareMessage = GUICtrlCreateLabel(GetTranslated(5,41, "Use a random message from this list") &":", $x , $y -2 , -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
	    $y += 27
		$txtShareMessage = GUICtrlCreateEdit("", $x, $y - 10 , 205, 72, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetData(-1, StringFormat(GetTranslated(5,42, "Nice\r\nGood\r\nThanks \r\nWowwww")))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetTip(-1, GetTranslated(5,43, "Message to send with the Share Replay"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
