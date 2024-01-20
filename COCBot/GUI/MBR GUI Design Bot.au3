; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_BOT = 0, $g_hGUI_LOG_SA = 0

#include "MBR GUI Design Child Bot - Options.au3"
#include "MBR GUI Design Child Bot - Android.au3"
#include "MBR GUI Design Child Bot - Debug.au3"
#include "MBR GUI Design Child Bot - Profiles.au3"
#include "MBR GUI Design Child Bot - Stats.au3"

Global $g_hGUI_BOT_TAB = 0, $g_hGUI_BOT_TAB_ITEM1 = 0, $g_hGUI_BOT_TAB_ITEM2 = 0, $g_hGUI_BOT_TAB_ITEM3 = 0, $g_hGUI_BOT_TAB_ITEM4 = 0, $g_hGUI_BOT_TAB_ITEM5 = 0
Global $g_hTxtSALog = 0

Func CreateBotTab()
	$g_hGUI_BOT = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_BOT)

	$g_hGUI_LOG_SA = _GUICreate("", 205, 200, 235, 225, BitOR($WS_CHILD, 0), -1, $g_hGUI_BOT)

	$g_hGUI_STATS = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_BOT)

	GUISwitch($g_hGUI_BOT)
	$g_hGUI_BOT_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_BOT_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_01", "Options"))
		CreateBotOptions()
	$g_hGUI_BOT_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_02", "Android"))
		CreateBotAndroid()
	$g_hGUI_BOT_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_03", "Debug"))
		CreateBotDebug()
	$g_hGUI_BOT_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_04", "Profiles"))
		CreateBotProfiles()
	$g_hGUI_BOT_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05", "Stats"))
	; This dummy is used in btnStart and btnStop to disable/enable all labels, text, buttons etc. on all tabs.
	$g_hLastControlToHide = GUICtrlCreateDummy()
	ReDim $g_aiControlPrevState[$g_hLastControlToHide + 1]
		CreateBotStats()

	CreateBotSwitchAccLog()
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateBotTab

Func CreateBotSwitchAccLog()

	Local $x = 0, $y = 0
	Local $activeHWnD1 = WinGetHandle("") ; RichEdit Controls tamper with active window
	$g_hTxtSALog = _GUICtrlRichEdit_Create($g_hGUI_LOG_SA, "", $x, $y, 205, 200, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $WS_HSCROLL, $ES_UPPERCASE, $ES_AUTOHSCROLL, $ES_AUTOVSCROLL, $ES_NUMBER, 0x200), $WS_EX_STATICEDGE)
	WinActivate($activeHWnD1) ; restore current active window

EndFunc   ;==>CreateBotSwitchAccLog
