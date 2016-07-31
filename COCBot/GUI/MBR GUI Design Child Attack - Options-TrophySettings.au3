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


Local $x = 25, $y = 45



	$grpTrophy = GUICtrlCreateGroup(GetTranslated(609,1, "Trophy Settings"), $x - 20, $y - 20, 420, 305)
		$x += 25
		$y += 25
		GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x - 15, $y, 64, 64, $BS_ICON)
		$x += 50
		$chkTrophyRange = GUICtrlCreateCheckbox(GetTranslated(609,2, "Trophy range") & ":",$x + 20, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkTrophyRange")
		$txtdropTrophy = GUICtrlCreateInput("5000", $x + 110, $y, 35, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(609,3, "MIN: The Bot will drop trophies until below this value.")
			GUICtrlSetLimit(-1, 4)
			_GUICtrlSetTip(-1, $txtTip)
			GuiCtrlSetState(-1,$GUI_DISABLE)
		$lblDash = GUICtrlCreateLabel(GetTranslated(603,13, "-"), $x + 148, $y + 4, -1, -1)
		$txtMaxTrophy = GUICtrlCreateInput("5000", $x + 155, $y, 35, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(609,4, "MAX: The Bot will drop trophies if your trophy count is greater than this value.")
			GUICtrlSetLimit(-1, 4)
			_GUICtrlSetTip(-1, $txtTip)
			GuiCtrlSetState(-1,$GUI_DISABLE)
		$y += 24
		$x += 20
		$chkTrophyHeroes = GUICtrlCreateCheckbox(GetTranslated(609,5, "Use Heroes To Drop Trophies"), $x, $y, -1, -1)
			$txtTip = GetTranslated(609,6, "Use Heroes to drop Trophies if Heroes are available.")
			_GUICtrlSetTip(-1, $txtTip)
			GuiCtrlSetState(-1,$GUI_DISABLE)
		$y += 20
		$chkTrophyAtkDead = GUICtrlCreateCheckbox(GetTranslated(609,7, "Attack Dead Bases During Drop"), $x  , $y +2, -1, -1)
			$txtTip = GetTranslated(609,8, "Attack a Deadbase found on the first search while dropping Trophies.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkTrophyAtkDead")
			GuiCtrlSetState(-1,$GUI_DISABLE)
		$y += 24
		;$x += 10
		$lblDTArmyMin = GUICtrlCreateLabel(GetTranslated(609,9, "Wait until Army") & " " & ChrW(8805), $x + 10, $y + 6, 120, -1, $SS_RIGHT)
		$txtTip = GetTranslated(609,10, "Enter the percent of full army required for dead base attack before starting trophy drop.")
			_GUICtrlSetTip(-1, $txtTip)
		$txtDTArmyMin = GUICtrlCreateInput("70", $x + 135, $y +2, 27, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState (-1, $GUI_DISABLE)
		$lblDTArmypercent = GUICtrlCreateLabel(GetTranslated(603,12, "%"), $x + 165, $y +6, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
