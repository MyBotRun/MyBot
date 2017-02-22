; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "ActiveBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_ACTIVEBASE = 0

#include "MBR GUI Design Child Attack - Activebase Attack Standard.au3"
#include "MBR GUI Design Child Attack - Activebase Attack Scripted.au3"
#include "MBR GUI Design Child Attack - Activebase-Search.au3"
#include "MBR GUI Design Child Attack - Activebase-Attack.au3"
#include "MBR GUI Design Child Attack - Activebase-EndBattle.au3"

Global $g_hGUI_ACTIVEBASE_TAB = 0, $g_hGUI_ACTIVEBASE_TAB_ITEM1 = 0, $g_hGUI_ACTIVEBASE_TAB_ITEM2 = 0, $g_hGUI_ACTIVEBASE_TAB_ITEM3 = 0

Func CreateAttackSearchActiveBase()

   $g_hGUI_ACTIVEBASE = GUICreate("", $_GUI_MAIN_WIDTH - 40, $_GUI_MAIN_HEIGHT - 315, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_SEARCH)
   ;GUISetBkColor($COLOR_WHITE, $g_hGUI_ACTIVEBASE)

   ;creating subchilds first!
   CreateAttackSearchActiveBaseStandard()
   CreateAttackSearchActiveBaseScripted()
   GUISwitch($g_hGUI_ACTIVEBASE)

   $g_hGUI_ACTIVEBASE_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 40, $_GUI_MAIN_HEIGHT - 315, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
   $g_hGUI_ACTIVEBASE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,28,"Search"))
   CreateAttackSearchActiveBaseSearch()

   $g_hGUI_ACTIVEBASE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,29,"Attack"))
   CreateAttackSearchActiveBaseAttack()

   $g_hGUI_ACTIVEBASE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600,30,"End Battle"))
   CreateAttackSearchActiveBaseEndBattle()

   ;GUISetState()
EndFunc

