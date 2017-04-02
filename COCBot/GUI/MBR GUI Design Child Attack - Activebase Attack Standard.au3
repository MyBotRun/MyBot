; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Standard Attack" tab under the "Attack" tab under the "ActiveBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hGUI_ACTIVEBASE_ATTACK_STANDARD = 0
Global $g_hCmbStandardDropOrderAB = 0, $g_hCmbStandardDropSidesAB = 0, $g_hCmbStandardUnitDelayAB = 0, $g_hCmbStandardWaveDelayAB = 0, $g_hChkRandomSpeedAtkAB = 0, $g_hChkSmartAttackRedAreaAB = 0, _
	   $g_hCmbSmartDeployAB = 0, $g_hChkAttackNearGoldMineAB = 0, $g_hChkAttackNearElixirCollectorAB = 0, $g_hChkAttackNearDarkElixirDrillAB = 0

Global $g_hLblSmartDeployAB = 0, $g_hPicAttackNearDarkElixirDrillAB = 0

Func CreateAttackSearchActiveBaseStandard()

   $g_hGUI_ACTIVEBASE_ATTACK_STANDARD = _GUICreate("", $_GUI_MAIN_WIDTH - 195, $g_iSizeHGrpTab4, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_ACTIVEBASE)
   ;GUISetBkColor($COLOR_WHITE, $g_hGUI_ACTIVEBASE_ATTACK_STANDARD)

   Local $sTxtTip = ""
   Local $x = 25, $y = 20

   GUICtrlCreateGroup(GetTranslated(608,1, -1), $x - 20, $y - 20, 270, $g_iSizeHGrpTab4)
   ;$x -= 15
	  GUICtrlCreateLabel(GetTranslated(608,2, -1),$x, $y, 143,18,$SS_LEFT)
   $y += 15
	   $g_hCmbStandardDropOrderAB = GUICtrlCreateCombo("", $x, $y, 150, Default, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   GUICtrlSetData(-1, GetTranslated(608,25, -1)&"|Barch/BAM/BAG|GiBarch", GetTranslated(608,25, -1))
			   _GUICtrlSetTip(-1, GetTranslated(608,33, -1)&@CRLF&GetTranslated(608,34, -1))
	   $y += 25
	   ;95)
		   GUICtrlCreateLabel(GetTranslated(608,3, "Attack on")&":", $x, $y + 5, -1, -1)
		   $g_hCmbStandardDropSidesAB = GUICtrlCreateCombo("", $x + 55, $y, 120, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   _GUICtrlSetTip(-1, GetTranslated(608,4, -1) & @CRLF & GetTranslated(608,5, -1) & @CRLF & GetTranslated(608,6, -1) & @CRLF & _
								  GetTranslated(608,29, "Attack on the single side closest to the Dark Elixir Storage") & @CRLF & _
								  GetTranslated(608,30, "Attack on the single side closest to the Townhall"), GetTranslated(608,7, -1))
			   GUICtrlSetData(-1, GetTranslated(608,8, -1) & "|" & GetTranslated(608,9, -1) & "|" & GetTranslated(608,10, -1) & "|" & _
							      GetTranslated(608,11, -1) & "|" & GetTranslated(608,31, "DE Side Attack") & "|" & GetTranslated(608,32, "TH Side Attack"), _
								  GetTranslated(608,11, -1))
			   ;GUICtrlSetOnEvent(-1, "chkDESideEB")

		   $y += 25
		   GUICtrlCreateLabel(GetTranslated(608,12, -1) & ":", $x, $y + 5, -1, -1)
			   $sTxtTip = GetTranslated(608,13, -1) & @CRLF & GetTranslated(608,14, -1)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hCmbStandardUnitDelayAB = GUICtrlCreateCombo("", $x + 55, $y, 36, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "4")
		   GUICtrlCreateLabel(GetTranslated(608,15, -1) & ":", $x + 100, $y + 5, -1, -1)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hCmbStandardWaveDelayAB = GUICtrlCreateCombo("", $x + 140, $y, 36, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "4")

		   $y += 22
		   $g_hChkRandomSpeedAtkAB = GUICtrlCreateCheckbox(GetTranslated(608,16, -1), $x, $y, -1, -1)
			   _GUICtrlSetTip(-1, $sTxtTip)
			   GUICtrlSetOnEvent(-1, "chkRandomSpeedAtkAB")

		   $y +=22
		   $g_hChkSmartAttackRedAreaAB = GUICtrlCreateCheckbox(GetTranslated(608,17, -1), $x, $y, -1, -1)
			   _GUICtrlSetTip(-1, GetTranslated(608,18, -1))
			   GUICtrlSetState(-1, $GUI_CHECKED)
			   GUICtrlSetOnEvent(-1, "chkSmartAttackRedAreaAB")

		   $y += 22
		   $g_hLblSmartDeployAB = GUICtrlCreateLabel(GetTranslated(608,19, -1) & ":", $x, $y + 5, -1, -1)
			   $sTxtTip = GetTranslated(608,20, -1) & @CRLF & GetTranslated(608,21, -1) & @CRLF & GetTranslated(608,22, -1)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hCmbSmartDeployAB = GUICtrlCreateCombo("", $x + 55, $y, 120, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   GUICtrlSetData(-1, GetTranslated(608,23, -1) & "|" & GetTranslated(608,24, -1) , GetTranslated(608,23, -1))
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $y += 26
		   $g_hChkAttackNearGoldMineAB = GUICtrlCreateCheckbox("", $x + 20, $y, 17, 17)
			   $sTxtTip = GetTranslated(608,26, -1)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 40 , $y - 3 , 24, 24)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $x += 75
		   $g_hChkAttackNearElixirCollectorAB = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			   $sTxtTip = GetTranslated(608,27, -1)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20 , $y - 3 , 24, 24)
			   _GUICtrlSetTip(-1, $sTxtTip)

		   $x += 55
		   $g_hChkAttackNearDarkElixirDrillAB = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			   $sTxtTip = GetTranslated(608,28, -1)
			   _GUICtrlSetTip(-1, $sTxtTip)
		   $g_hPicAttackNearDarkElixirDrillAB = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 20 , $y - 3, 24, 24)
			   _GUICtrlSetTip(-1, $sTxtTip)

   ;GUISetState()
EndFunc
