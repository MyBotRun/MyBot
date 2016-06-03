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
	$grpABEndBattle = GUICtrlCreateGroup(GetTranslated(606,1, -1),  $x - 5, $y - 20, 155, 305)
	$y -=5
		$chkABTimeStopAtk = GUICtrlCreateCheckbox(GetTranslated(606,2, -1) ,$x, $y, -1, -1)
			$txtTip = GetTranslated(606,3, -1) & @CRLF & GetTranslated(606,4, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABTimeStopAtk")
			GUICtrlSetState(-1, $GUI_CHECKED)
    $y +=20
		$lblABTimeStopAtka = GUICtrlCreateLabel(GetTranslated(606,5, -1)& ":", $x + 16, $y + 3, -1, -1)
		$txtABTimeStopAtk = GUICtrlCreateInput("20", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
		$lblABTimeStopAtk = GUICtrlCreateLabel(GetTranslated(603,6, -1), $x + 120, $y + 3, -1, -1)
   $y += 20
		$chkABTimeStopAtk2 = GUICtrlCreateCheckbox(GetTranslated(606,2, -1) ,$x, $y, -1, -1)
			$txtTip = GetTranslated(606,3, -1) & @CRLF & GetTranslated(606,4, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABTimeStopAtk2")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
   $y += 20
		$lblABTimeStopAtk2a = GUICtrlCreateLabel(GetTranslated(606,5, -1)& ":", $x + 16, $y + 3, -1, -1)
		$txtABTimeStopAtk2 = GUICtrlCreateInput("5", $x + 85, $y + 1, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblABTimeStopAtk2 = GUICtrlCreateLabel(GetTranslated(603,6, -1), $x + 120, $y + 3, -1, -1)
	$y += 21
		$lblABMinRerourcesAtk2 = GUICtrlCreateLabel(GetTranslated(606,7, -1) & ":", $x + 16 , $y + 2, -1, -1)
			$txtTip = GetTranslated(606,8, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 21
		$txtABMinGoldStopAtk2 = GUICtrlCreateInput("2000", $x + 65, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picABMinGoldStopAtk2 = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 117, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
   $y += 21
		$txtABMinElixirStopAtk2 = GUICtrlCreateInput("2000", $x + 65, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picABMinElixirStopAtk2 = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 117, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
   $y += 21
		$txtABMinDarkElixirStopAtk2 = GUICtrlCreateInput("50", $x + 65, $y , 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picABMinDarkElixirStopAtk2 = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 117, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
	$y += 21
		$chkABEndNoResources = GUICtrlCreateCheckbox(GetTranslated(606,9, -1), $x , $y , -1, -1)
			$txtTip = GetTranslated(606,10, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 21
		$chkABEndOneStar = GUICtrlCreateCheckbox(GetTranslated(606,11, -1) , $x, $y , -1, -1)
			$txtTip = GetTranslated(606,12, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
	$y += 21
		$chkABEndTwoStars = GUICtrlCreateCheckbox(GetTranslated(606,13,-1) , $x, $y, -1, -1)
			$txtTip = GetTranslated(606,14, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 185, $y = 45
Global $grpDEside , $chkDESideEB ,$txtDELowEndMin  , $lblDELowEndMin , $chkDisableOtherEBO , $chkDEEndOneStar , $chkDEEndBk ,$lblDEEndBk  ,$chkDEEndAq  , $lblDEEndAq

		$grpDEside = GUICtrlCreateGroup(GetTranslated(606,15,"DE side End Battle options"), $x - 20, $y - 20, 259, 305)
			GUICtrlCreateLabel(GetTranslated(606,16, "Attack Dark Elixir Side, End Battle Options") & ":", $x - 10, $y , -1, -1)
				$txtTip = GetTranslated(606,17, "Enabled by selecting DE side attack in LiveBase Deploy - Attack On: options")
				GUICtrlSetTip(-1, $txtTip)
		$y += 15
		$x -= 10
			$chkDESideEB = GUICtrlCreateCheckbox(GetTranslated(606,18, "When below") & ":", $x , $y , -1, -1)
				$txtTip = GetTranslated(606,19, "Enables Special conditions for Dark Elixir side attack.") & @CRLF & GetTranslated(606,20, "If no additional filters are selected will end battle when below Total Dark Elixir Percent.")
				GUICtrlSetTip(-1, $txtTip)
				GUICtrlSetOnEvent(-1, "chkDESideEB")
			$txtDELowEndMin = GUICtrlCreateInput("25", $x + 92, $y , 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				GUICtrlSetTip(-1, $txtTip)
				GUICtrlSetLimit(-1, 2)
				GUICtrlSetState(-1, $GUI_DISABLE)
			$lblDELowEndMin = GUICtrlCreateLabel("%", $x + 136 , $y + 2 , -1, -1)
			GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 147, $y, 16, 16)
				GUICtrlSetTip(-1, $txtTip)
		$y += 20
			$chkDisableOtherEBO = GUICtrlCreateCheckbox(GetTranslated(606,21, "Disable Normal End Battle Options"), $x, $y, -1, -1)
				$txtTip = GetTranslated(606,22, "Disable Normal End Battle Options when DE side attack is found.")
				GUICtrlSetTip(-1, $txtTip)
				GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 20
			$chkDEEndOneStar = GUICtrlCreateCheckbox(GetTranslated(606,11, -1) & ":", $x, $y , -1, -1)
				$txtTip = GetTranslated(606,23, "Will End the Battle when below min DE and One Star is won.")
				GUICtrlSetTip(-1, $txtTip)
				GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlCreateIcon($pIconLib, $eIcnSilverStar, $x + 135, $y + 2, 16, 16)
				GUICtrlSetTip(-1, $txtTip)
		$y += 20
			$chkDEEndBk = GUICtrlCreateCheckbox(GetTranslated(606,24, "When"), $x, $y , -1, -1)
				$txtTip = GetTranslated(606,25, "Will End the Battle when below min DE and King is weak")
				GUICtrlSetTip(-1, $txtTip)
				GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlCreateIcon($pIconLib, $eIcnKing, $x + 50, $y + 2, 16, 16)
				GUICtrlSetTip(-1, $txtTip)
			$lblDEEndBk = GUICtrlCreateLabel(GetTranslated(606,26, "is weak"), $x + 70, $y + 4, -1, -1)
				GUICtrlSetTip(-1, $txtTip)
		$y += 20
			$chkDEEndAq = GUICtrlCreateCheckbox(GetTranslated(606,24, -1), $x, $y , -1, -1)
				$txtTip = GetTranslated(606,27, "Will End the Battle when below min DE and Queen is weak")
				GUICtrlSetTip(-1, $txtTip)
				GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x + 50, $y + 2, 16, 16)
				GUICtrlSetTip(-1, $txtTip)
			$lblDEEndAq = GUICtrlCreateLabel(GetTranslated(606,26, -1), $x + 70, $y + 4, -1, -1)
				GUICtrlSetTip(-1, $txtTip)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

