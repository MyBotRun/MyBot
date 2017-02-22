; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Bot Android
; Description ...: This file creates the "Android" tab under the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hCmbCOCDistributors

Func CreateBotAndroid()
   Local $x = 25, $y = 45
   GUICtrlCreateGroup(GetTranslated(643,1, "Distributors"), $x - 20, $y - 20, 210, 47)
	   $y -=2
	   $g_hCmbCOCDistributors = GUICtrlCreateCombo("", $x - 8 , $y, 185, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	   _GUICtrlSetTip(-1, GetTranslated(643,2, "Allow bot to launch COC based on the distribution chosen"))
	   LoadCOCDistributorsComboBox()
	   SetCurSelCmbCOCDistributors()
	   GUICtrlSetOnEvent(-1, "cmbCOCDistributors")
   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
