; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Tab SmartZap
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(February, 2016)
; Modified ......: TheRevenor(November, 2016), TheRevenor(Desember, 2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Local $x = 25, $y = 45
	$grpStatsMisc = GUICtrlCreateGroup(GetTranslated(638, 1, "SmartZap/NoobZap"), $x - 20, $y - 20, 420, 180)
		GUICtrlCreateLabel(GetTranslated(638, 2, "Use This Spell to Zap Dark Drills"), $x + 20, $y, -1, -1)
		GUICtrlCreateIcon($pIconLib, $eIcnNewSmartZap, $x - 10, $y, 25, 25)
		GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x + 45, $y + 20, 25, 25)
		GUICtrlCreateIcon($pIconLib, $eIcnEarthQuakeSpell, $x + 125, $y + 20, 25, 25)
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x - 10, $y + 90, 25, 25)
	$y += 50
		$lblLSpell = GUICtrlCreateLabel(GetTranslated(638, 3, "Use LSpells"), $x + 27, $y + 15, -1, -1)
		GUICtrlSetOnEvent(-1, "chkSmartLightSpell")
		$chkSmartLightSpell = GUICtrlCreateCheckbox(" ", $x + 51, $y -3, 16, 16)
		$txtTip = GetTranslated(638, 4, "Check this to drop Lightning Spells on top of Dark Elixir Drills.") & @CRLF & @CRLF & _
				GetTranslated(638, 5, "Remember to go to the tab 'troops' and put the maximum capacity") & @CRLF & _
				GetTranslated(638, 6, "of your spell factory and the number of spells so that the bot can function perfectly.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartLightSpell")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$lblEQZap = GUICtrlCreateLabel(GetTranslated(638, 7, "Use EQSpell"), $x + 105, $y + 15, -1, -1)
		GUICtrlSetOnEvent(-1, "chkEarthQuakeZap")
		$chkEarthQuakeZap = GUICtrlCreateCheckbox(" ", $x + 131, $y -3, 16, 16)
		$txtTip = GetTranslated(638, 8, "Check this to drop EarthQuake Castle Spell on any Dark Elixir Drill")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkEarthQuakeZap")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$chkNoobZap = GUICtrlCreateCheckbox(GetTranslated(638, 9, "Use NoobZap"), $x + 20 + 2, $y + 35, -1, -1)
			$txtTip = GetTranslated(638, 10, "Check this to drop lightning spells on any Dark Elixir Drills")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkNoobZap")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$chkSmartZapDB = GUICtrlCreateCheckbox(GetTranslated(638, 11, "Only Zap Drills in Dead Bases"), $x + 20 + 2, $y + 55, -1, -1)
		$txtTip = GetTranslated(638, 12, "This will only SmartZap a Dead Base (Recommended)")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartZapDB")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkSmartZapSaveHeroes = GUICtrlCreateCheckbox(GetTranslated(638, 13, "TH Snipe Not Zap if Heroes Deployed"), $x + 20 + 2, $y + 75, -1, -1)
		$txtTip = GetTranslated(638, 14, "This will stop SmartZap from zapping a base on a Town Hall Snipe if your Heroes were deployed")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartZapSaveHeroes")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
	$y -= 55
	GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 200 + 9, $y + 11, 24, 24)
	$grpNewSmartZap = GUICtrlCreateGroup("", $x + 199, $y - 1, 192, 106)
		$lblSmartZap = GUICtrlCreateLabel(GetTranslated(638, 15, "Min. amount of Dark Elixir") & ":", $x + 160 + 79, $y + 12, -1, -1)
		$txtMinDark = GUICtrlCreateInput("350", $x + 289, $y + 32, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(638, 16, "Set the Value of the minimum amount of Dark Elixir in the Drills")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "txtMinDark")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 200 + 9, $y + 57, 24, 24)
		$lblNoobZap = GUICtrlCreateLabel(GetTranslated(638, 17, "Expected gain of Dark Drills") & ":", $x + 160 + 79, $y + 58, -1, -1)
		$txtExpectedDE = GUICtrlCreateInput("320", $x + 289, $y + 78, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(638, 18, "Set value for expected gain every dark drill") & @CRLF & _
				GetTranslated(638, 19, "NoobZap will be stopped if the last zap gained less DE than expected")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "txtExpectedDE")
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
