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

Local $x = 10, $y = 45
	$grpDBEndBattle = GUICtrlCreateGroup(GetTranslated(606,1, "Exit Battle"),  $x - 5, $y - 20, 420, 305)
	$y -=5
		$chkDBTimeStopAtk = GUICtrlCreateCheckbox(GetTranslated(606,2, "When no New loot") ,$x, $y, -1, -1)
			$txtTip = GetTranslated(606,3, "End Battle if there is no extra loot raided within this No. of seconds.") & @CRLF & GetTranslated(606,4, "Countdown is started after all Troops and Royals are deployed in battle.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkDBTimeStopAtk")
			GUICtrlSetState(-1, $GUI_CHECKED)
    $y +=20
		$lblDBTimeStopAtka = GUICtrlCreateLabel(GetTranslated(606,5, "raided within")& ":", $x + 16, $y + 3, -1, -1)
		$txtDBTimeStopAtk = GUICtrlCreateInput("20", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
		$lblDBTimeStopAtk = GUICtrlCreateLabel(GetTranslated(603,6, "sec."), $x + 120, $y + 3, -1, -1)
   $y += 20
		$chkDBTimeStopAtk2 = GUICtrlCreateCheckbox(GetTranslated(606,2, -1) ,$x, $y, -1, -1)
			$txtTip = GetTranslated(606,3, -1) & @CRLF & GetTranslated(606,4, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkDBTimeStopAtk2")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
   $y += 20
		$lblDBTimeStopAtk2a = GUICtrlCreateLabel(GetTranslated(606,5, -1)& ":", $x + 16, $y + 3, -1, -1)
		$txtDBTimeStopAtk2 = GUICtrlCreateInput("5", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblDBTimeStopAtk2 = GUICtrlCreateLabel(GetTranslated(603,6, -1), $x + 120, $y + 3, -1, -1)
	$y += 21
		$lblDBMinRerourcesAtk2 = GUICtrlCreateLabel(GetTranslated(606,7, "And Resources are below") & ":", $x + 16 , $y + 2, -1, -1)
			$txtTip = GetTranslated(606,8, "End Battle if below this amount of Gold.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 21
		$txtDBMinGoldStopAtk2 = GUICtrlCreateInput("2000", $x + 65, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picDBMinGoldStopAtk2 = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 117, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
   $y += 21
		$txtDBMinElixirStopAtk2 = GUICtrlCreateInput("2000", $x + 65, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picDBMinElixirStopAtk2 = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 117, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
   $y += 21
		$txtDBMinDarkElixirStopAtk2 = GUICtrlCreateInput("50", $x + 65, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picDBMinDarkElixirStopAtk2 = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 117, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
	$y += 21
		$chkDBEndNoResources = GUICtrlCreateCheckbox(GetTranslated(606,9, "When no Resources left"), $x , $y , -1, -1)
			$txtTip = GetTranslated(606,10, "End Battle when all Gold, Elixir and Dark Elixir = 0")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 21
		$chkDBEndOneStar = GUICtrlCreateCheckbox(GetTranslated(606,11, "When One Star is won") , $x, $y , -1, -1)
			$txtTip = GetTranslated(606,12, "Will End the Battle if 1 star is won in battle")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 21
		$chkDBEndTwoStars = GUICtrlCreateCheckbox(GetTranslated(606,13, "When Two Stars are won") , $x, $y, -1, -1)
			$txtTip = GetTranslated(606,14, "Will End the Battle if 2 stars are won in battle")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
