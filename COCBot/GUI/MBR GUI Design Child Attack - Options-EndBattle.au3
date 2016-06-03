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


Local $x = 20, $y = 45
Global $hReplayShareGUI, $txtShareMinGold, $txtShareMinElixir, $txtShareMinDark, $txtShareMessage
	$grpReplayShare = GUICtrlCreateGroup(GetTranslated(633,1,"Share Replay"), $x-15, $y-20, 420, 204)
		$chkShareAttack = GUICtrlCreateCheckbox(GetTranslated(633,2, "Share Replays in your clan's chat."), $x, $y-7, -1, -1)
			$TxtTip = GetTranslated(633,3, "Check this to share your battle replay in the clan chat.")
			GUICtrlSetTip(-1, $TxtTip)
			GUICtrlSetOnEvent(-1, "chkShareAttack")
	$x -= 15
	$y -= 2
		$y -=5
		$y += 25
		$lblShareMinGold = GUICtrlCreateLabel(GetTranslated(633,4, "When Loot Gained") & ":>", $x + 20 , $y, -1, -1)
		$txtShareMinGold = GUICtrlCreateInput("300000", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(633,5, "Only Share Replay when the battle loot is more than this amount of Gold.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picShareLootGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 182, $y, 16, 16)
		$y += 22
		$lblShareMinElixir = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
		$txtShareMinElixir = GUICtrlCreateInput("300000", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(633,6, "Only Share Replay when the battle loot is more than this amount of Elixir.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picShareLootElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 182, $y, 16, 16)
		$y += 22
		$lblShareMinDark = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
		$txtShareMinDark = GUICtrlCreateInput("0", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(633,7, "Only Share Replay when the battle loot is more than this amount of Dark Elixir.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
		$picShareLootDarkElixir = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 182, $y, 16, 16)
		$y += 25
		$x += 5
		$lblShareMessage = GUICtrlCreateLabel(GetTranslated(633,8, "Use a random message from this list") &":", $x , $y -2 , -1, -1)
	    $y += 27
		$txtShareMessage = GUICtrlCreateEdit("", $x, $y - 10 , 205, 72, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetData(-1, StringFormat(GetTranslated(633,9, "Nice\r\nGood\r\nThanks \r\nWowwww")))
			GUICtrlSetTip(-1, GetTranslated(633,10, "Message to send with the Share Replay"))

	$x = 20
	$y+=100
	$grpTakeLootSS = GUICtrlCreateGroup(GetTranslated(633,11,"Take Loot Snapshot"), $x-15, $y-20, 420, 67)
		$chkTakeLootSS = GUICtrlCreateCheckbox(GetTranslated(633,11, -1), $x, $y, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(633,12, "Check this if you want to save a Loot snapshot of the Village that was attacked."))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkTakeLootSS")
	  $y += 18
		$chkScreenshotLootInfo = GUICtrlCreateCheckbox(GetTranslated(633,13, "Include loot info in filename"), $x  , $y , -1, -1)
			GUICtrlSetTip(-1, GetTranslated(633,14, "Include loot info in the screenshot filename"))
			GUICtrlSetState(-1,$GUI_DISABLE)
