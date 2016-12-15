; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Tab SmartZap
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(February, 2016)
; Modified ......: DocOC (25-10-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
$hGUI_NewSmartZap = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_ATTACK)
GUISetBkColor($COLOR_WHITE, $hGUI_NewSmartZap)
GUISwitch($hGUI_NewSmartZap)

; ============================================================================
; ====================== SmartZap - Added by DocOC team ======================
; ============================================================================
Local $x = 20, $y = 25
	$grpStatsMisc = GUICtrlCreateGroup("SmartZap", $x - 20, $y - 20, 437, 218)
		GUICtrlCreateIcon($pIconLib, $eIcnNewSmartZap, $x - 10, $y + 5, 25, 25)
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x - 10, $y + 42, 25, 25)
		$chkSmartLightSpell = GUICtrlCreateCheckbox("Use Lightning Spells to Zap Drills", $x + 20 + 2, $y + 5, -1, -1)
		$txtTip = "Check this to drop Lightning Spells on top of Dark Elixir Drills." & @CRLF & @CRLF & _
				"Remember to go to the tab 'troops' and put the maximum capacity " & @CRLF & _
				"of your spell factory and the number of spells so that the bot " & @CRLF & _
				"can function perfectly."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartLightSpell")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$chkNoobZap = GUICtrlCreateCheckbox("Use NoobZap to Zap any Dark Drills", $x + 20 + 2, $y + 30, -1, -1)
			$txtTip = "Check this to drop lightning spells on any Dark Elixir Drills," & @CRLF & @CRLF & _
					  "__If You Do Not Like SmartZap, This Is The Right Choice.__"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkNoobZap")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$chkSmartZapDB = GUICtrlCreateCheckbox("Only Zap Drills in Dead Bases", $x + 20 + 2, $y + 55, -1, -1)
		$txtTip = "It is recommended you only zap drills in dead bases as most of the " & @CRLF & _
				"Dark Elixir in a live base will be in the storage."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartZapDB")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 220 + 9, $y + 11, 24, 24)
	$grpNewSmartZap = GUICtrlCreateGroup("", $x + 219, $y - 1, 192, 106)
		$lblSmartZap = GUICtrlCreateLabel("Min. amount of Dark Elixir:", $x + 180 + 79, $y + 12, -1, -1)
		$txtMinDark = GUICtrlCreateInput("250", $x + 309, $y + 32, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = "The value here depends a lot on what level your Town Hall is, " & @CRLF & _
				"and what level drills you most often see."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "txtMinDark")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 220 + 9, $y + 57, 24, 24)
		$lblNoobZap = GUICtrlCreateLabel("Expected gain of Dark Drills:", $x + 180 + 79, $y + 58, -1, -1)
		$txtExpectedDE = GUICtrlCreateInput("95", $x + 309, $y + 78, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = "Set value for expected gain every dark drill" & @CRLF & _
				"NoobZap will be stop if, last zap gained less DE then expected"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "txtExpectedDE")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkSmartZapSaveHeroes = GUICtrlCreateCheckbox("TH snipe NoZap if Heroes Deployed", $x + 20 + 2, $y + 80, -1, -1)
		$txtTip = "This will stop SmartZap from zapping a base on a Town Hall Snipe " & @CRLF & _
				"if your heroes were deployed. " & @CRLF & @CRLF & _
				"This protects their health so they will be ready for battle sooner!"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartZapSaveHeroes")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picSmartZap = GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x - 10, $y + 112, 25, 25)
		$lblLightningUsed = GUICtrlCreateLabel("0", $x + 20, $y + 110, 396, 30, $SS_CENTER)
			GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
			GUICtrlSetBkColor (-1, 0xbfdfff)
			$txtTip = "Amount of used spells."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlCreateIcon($pIconLib, $eIcnDarkElixirStorage, $x - 12, $y + 150, 30, 30)
		$lblSmartZap = GUICtrlCreateLabel("0", $x + 20, $y + 150, 396, 30, $SS_CENTER)
			GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
			GUICtrlSetBkColor (-1, 0xbfdfff)
			$txtTip = "Number of dark elixir zapped during the attack with lightning."
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
; ============================================================================
; ====================== SmartZap - Added by DocOC team ======================
; ============================================================================
