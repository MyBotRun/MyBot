; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_ATTACK = 0

#include "MBR GUI Design Child Attack - Troops.au3"
#include "MBR GUI Design Child Attack - Search.au3"
#include "MBR GUI Design Child Attack - Strategies.au3"

Global $g_hGUI_ATTACK_TAB = 0, $g_hGUI_ATTACK_TAB_ITEM1 = 0, $g_hGUI_ATTACK_TAB_ITEM2 = 0, $g_hGUI_ATTACK_TAB_ITEM3 = 0

Func CreateAttackTab()
   $g_hGUI_ATTACK = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)
   ;GUISetBkColor($COLOR_WHITE, $g_hGUI_ATTACK)

   CreateAttackTroops()
   CreateAttackSearch()
   CreateAttackStrategies()

   GUISwitch($g_hGUI_ATTACK)
   $g_hGUI_ATTACK_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
   $g_hGUI_ATTACK_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01", "Train Army"))
   $g_hGUI_ATTACK_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02", "Search && Attack"))
   $g_hGUI_ATTACK_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_03", "Strategies"))
   GUICtrlCreateTabItem("")
EndFunc
