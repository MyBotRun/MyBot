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

$hGUI_ATTACK = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $frmBotEx)
;GUISetBkColor($COLOR_WHITE, $hGUI_ATTACK)

;creating subchilds first!
#include "MBR GUI Design Child Attack - Troops.au3"
#include "MBR GUI Design Child Attack - Search.au3"
#include "MBR GUI Design Child Attack - Strategies.au3"

GUISwitch($hGUI_ATTACK)

; attack tab
;============
$hGUI_ATTACK_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
$hGUI_ATTACK_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,41,"Train Army"))
; this tab will be empty because it is only used to display a child GUI
$hGUI_ATTACK_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,42,"Search && Attack"))
; this tab will be empty because it is only used to display a child GUI
$hGUI_ATTACK_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600,43,"Strategies"))
; this tab will be empty because it is only used to display a child GUI

GUICtrlCreateTabItem("")
;GUISetState()