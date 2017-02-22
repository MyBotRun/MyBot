; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Tab SmartZap
; Description ...: This file creates the "SmartZap" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(February, 2016)
; Modified ......: TheRevenor (November, 2016), TheRevenor (Desember, 2017), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

;Global $g_hGUI_NEWSMARTZAP = 0
Global $g_hChkSmartLightSpell = 0, $g_hChkSmartEQSpell = 0, $g_hChkNoobZap = 0, $g_hChkSmartZapDB = 0, $g_hChkSmartZapSaveHeroes = 0, _
	   $g_hTxtSmartMinDark = 0, $g_hTxtSmartExpectedDE = 0, $g_hChkDebugSmartZap = 0

Global $g_hLblSmartUseLSpell = 0, $g_hLblSmartUseEQSpell = 0,  $g_hLblSmartZap = 0, $g_hLblNoobZap = 0, $g_hLblSmartLightningUsed = 0, $g_hLblSmartEarthQuakeUsed = 0

Func CreateAttackNewSmartZap()

   Local $x = 25, $y = 45
	   GUICtrlCreateGroup(GetTranslated(638, 1, "SmartZap/NoobZap"), $x - 20, $y - 20, 420, 175)
		   GUICtrlCreateLabel(GetTranslated(638, 2, "Use This Spell to Zap Dark Drills"), $x + 20, $y, -1, -1)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnNewSmartZap, $x - 10, $y, 25, 25)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x + 45, $y + 20, 25, 25)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthQuakeSpell, $x + 125, $y + 20, 25, 25)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x - 10, $y + 90, 25, 25)

	   $y += 50
		   $g_hLblSmartUseLSpell = GUICtrlCreateLabel(GetTranslated(638, 3, "Use LSpells"), $x + 27, $y + 15, -1, -1)
			   GUICtrlSetOnEvent(-1, "chkSmartLightSpell")
			   GUICtrlSetState(-1,$GUI_HIDE)
		   $g_hChkSmartLightSpell = GUICtrlCreateCheckbox(" ", $x + 51, $y -3, 16, 16)
			   _GUICtrlSetTip(-1, GetTranslated(638, 4, "Check this to drop Lightning Spells on top of Dark Elixir Drills.") & @CRLF & @CRLF & _
								  GetTranslated(638, 5, "Remember to go to the tab 'troops' and put the maximum capacity") & @CRLF & _
								  GetTranslated(638, 6, "of your spell factory and the number of spells so that the bot can function perfectly."))
			   GUICtrlSetOnEvent(-1, "chkSmartLightSpell")
			   GUICtrlSetState(-1, $GUI_UNCHECKED)
		   $g_hLblSmartUseEQSpell = GUICtrlCreateLabel(GetTranslated(638, 7, "Use EQSpell"), $x + 105, $y + 15, -1, -1)
			   GUICtrlSetOnEvent(-1, "chkEarthQuakeZap")
			   GUICtrlSetState(-1,$GUI_HIDE)
		   $g_hChkSmartEQSpell = GUICtrlCreateCheckbox(" ", $x + 131, $y -3, 16, 16)
			   _GUICtrlSetTip(-1, GetTranslated(638, 8, "Check this to drop EarthQuake Castle Spell on any Dark Elixir Drill"))
			   GUICtrlSetOnEvent(-1, "chkEarthQuakeZap")
			   GUICtrlSetState(-1, $GUI_UNCHECKED)
		   $g_hChkNoobZap = GUICtrlCreateCheckbox(GetTranslated(638, 9, "Use NoobZap"), $x + 20 + 2, $y + 35, -1, -1)
			   _GUICtrlSetTip(-1, GetTranslated(638, 10, "Check this to drop lightning spells on any Dark Elixir Drills"))
			   GUICtrlSetOnEvent(-1, "chkNoobZap")
			   GUICtrlSetState(-1, $GUI_UNCHECKED)
		   $g_hChkSmartZapDB = GUICtrlCreateCheckbox(GetTranslated(638, 11, "Only Zap Drills in Dead Bases"), $x + 20 + 2, $y + 55, -1, -1)
			   _GUICtrlSetTip(-1, GetTranslated(638, 12, "This will only SmartZap a Dead Base (Recommended)"))
			   GUICtrlSetOnEvent(-1, "chkSmartZapDB")
			   GUICtrlSetState(-1, $GUI_CHECKED)
			   GUICtrlSetState(-1, $GUI_DISABLE)
		   $g_hChkSmartZapSaveHeroes = GUICtrlCreateCheckbox(GetTranslated(638, 13, "TH Snipe Not Zap if Heroes Deployed"), $x + 20 + 2, $y + 75, -1, -1)
			   _GUICtrlSetTip(-1, GetTranslated(638, 14, "This will stop SmartZap from zapping a base on a Town Hall Snipe if your Heroes were deployed"))
			   GUICtrlSetOnEvent(-1, "chkSmartZapSaveHeroes")
			   GUICtrlSetState(-1, $GUI_CHECKED)
			   GUICtrlSetState(-1, $GUI_DISABLE)

	   $y -= 55
			   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 200 + 9, $y + 11, 24, 24)
			   GUICtrlCreateGroup("", $x + 199, $y - 1, 192, 106)
		   $g_hLblSmartZap = GUICtrlCreateLabel(GetTranslated(638, 15, "Min. amount of Dark Elixir") & ":", $x + 160 + 79, $y + 12, -1, -1)
		   $g_hTxtSmartMinDark = GUICtrlCreateInput("350", $x + 289, $y + 32, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   _GUICtrlSetTip(-1, GetTranslated(638, 16, "Set the Value of the minimum amount of Dark Elixir in the Drills"))
			   GUICtrlSetLimit(-1, 3)
			   GUICtrlSetOnEvent(-1, "txtMinDark")
			   GUICtrlSetState(-1, $GUI_DISABLE)
			   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 200 + 9, $y + 57, 24, 24)
		   $g_hLblNoobZap = GUICtrlCreateLabel(GetTranslated(638, 17, "Expected gain of Dark Drills") & ":", $x + 160 + 79, $y + 58, -1, -1)
		   $g_hTxtSmartExpectedDE = GUICtrlCreateInput("320", $x + 289, $y + 78, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   _GUICtrlSetTip(-1, GetTranslated(638, 18, "Set value for expected gain every dark drill") & @CRLF & _
								  GetTranslated(638, 19, "NoobZap will be stopped if the last zap gained less DE than expected"))
			   GUICtrlSetLimit(-1, 3)
			   GUICtrlSetOnEvent(-1, "txtExpectedDE")
			   GUICtrlSetState(-1, $GUI_DISABLE)
	   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
