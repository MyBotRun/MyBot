; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_VILLAGE = 0

#include "MBR GUI Design Child Village - Misc.au3"
#include "MBR GUI Design Child Village - Donate.au3"
#include "MBR GUI Design Child Village - Upgrade.au3"
#include "MBR GUI Design Child Village - Achievements.au3"
#include "MBR GUI Design Child Village - Notify.au3"

Global $g_hGUI_VILLAGE_TAB = 0, $g_hGUI_VILLAGE_TAB_ITEM1 = 0, $g_hGUI_VILLAGE_TAB_ITEM2 = 0, $g_hGUI_VILLAGE_TAB_ITEM3 = 0, _
	   $g_hGUI_VILLAGE_TAB_ITEM4 = 0, $g_hGUI_VILLAGE_TAB_ITEM5 = 0

Func CreateVillageTab()
   $g_hGUI_VILLAGE = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)
   ;GUISetBkColor($COLOR_WHITE, $g_hGUI_VILLAGE)

   CreateVillageDonate()
   CreateVillageUpgrade()
   CreateVillageNotify()

   GUISwitch($g_hGUI_VILLAGE)
   $g_hGUI_VILLAGE_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
   $g_hGUI_VILLAGE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,6,"Misc"))
   CreateVillageMisc()
   $g_hGUI_VILLAGE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,7,"Req. && Donate"))
   $g_hGUI_VILLAGE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600,8,"Upgrade"))
   $g_hGUI_VILLAGE_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslated(600,9,"Achievements"))
   CreateVillageAchievements()
   $g_hGUI_VILLAGE_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslated(600,10,"Notify"))
   GUICtrlCreateTabItem("")
EndFunc
