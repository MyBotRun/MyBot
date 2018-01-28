; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "TH Snipe" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_THSNIPE = 0

#include "MBR GUI Design Child Attack - THSnipe-Search.au3"
#include "MBR GUI Design Child Attack - THSnipe-Attack.au3"
#include "MBR GUI Design Child Attack - THSnipe-EndBattle.au3"

Global $g_hGUI_THSNIPE_TAB = 0, $g_hGUI_THSNIPE_TAB_ITEM1 = 0,  $g_hGUI_THSNIPE_TAB_ITEM2 = 0,  $g_hGUI_THSNIPE_TAB_ITEM3 = 0

Func CreateAttackSearchTHSnipe()
	$g_hGUI_THSNIPE = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_SEARCH)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_THSNIPE)

	;creating subchilds first!
	GUISwitch($g_hGUI_THSNIPE)
	$g_hGUI_THSNIPE_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_THSNIPE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_0X_STab_01", -1))
		CreateAttackSearchTHSnipeSearch()
	$g_hGUI_THSNIPE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_0X_STab_02", -1))
		CreateAttackSearchTHSnipeAttack()
	$g_hGUI_THSNIPE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_0X_STab_03", -1))
		CreateAttackSearchTHSnipeEndBattle()
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateAttackSearchTHSnipe
