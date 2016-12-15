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

$hGUI_SEARCH = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_ATTACK)
;GUISetBkColor($COLOR_WHITE, $hGUI_SEARCH)
; ---
; Note:
; $x, $y=4, $y=6 are used as a dummy here to placehold the controls, the final position of the $x,$y coordinates is dynamically set by use of Func TabSearch() in MBR GUI Control file.
; This is done to be able to use translation of the tabitem names.
Local $x = 82
; ---
$DBcheck = GUICtrlCreateCheckbox("", $x, 6, 13, 13)
			GUICtrlSetState(-1,$GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "DBcheck")
$ABcheck = GUICtrlCreateCheckbox("", $x + 100, 4, 13, 13)
			GUICtrlSetState(-1,$GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "Abcheck")
$TScheck = GUICtrlCreateCheckbox("", $x + 190, 4, 13, 13)
			GUICtrlSetState(-1,$GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "TScheck")
$Bullycheck = GUICtrlCreateCheckbox("", $x + 260, 4, 13, 13)
			GUICtrlSetState(-1,$GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "Bullycheck")

;creating subchilds first!
#include "MBR GUI Design Child Attack - Deadbase.au3"
#include "MBR GUI Design Child Attack - Activebase.au3"
#include "MBR GUI Design Child Attack - THSnipe.au3"
#include "MBR GUI Design Child Attack - Options.au3"
#include "MBR GUI Design Child Attack - TH Bully.au3"
GUISwitch($hGUI_SEARCH)

; SEARCH tab
;============
$hGUI_SEARCH_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
$hGUI_SEARCH_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,23,"DeadBase") & "    ") ; MUST add 4 spaces to make room for the Checkmark box!
; this tab will be empty because it is only used to display a child GUI
; below controls are only shown when the strategy is disabled and the child gui will be hidden.
	$lblDBdisabled = GUICtrlCreateLabel(GetTranslated(600,49,"Note: This Strategy is disabled, tick the checkmark on the") & " " & GetTranslated(600, 23, -1) & " " & GetTranslated(600,50,"tab to enable it!"), 20, 30, $_GUI_MAIN_WIDTH - 40, -1)
	GUICtrlSetState(-1, $GUI_HIDE)

$hGUI_SEARCH_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,24,"ActiveBase") & "    ")
; this tab will be empty because it is only used to display a child GUI
; below controls are only shown when the strategy is disabled and the child gui will be hidden.
	$lblABdisabled = GUICtrlCreateLabel(GetTranslated(600,49, -1) & " " & GetTranslated(600, 24, -1) & " " & GetTranslated(600,50, -1), 20, 30, $_GUI_MAIN_WIDTH - 40, -1)
	GUICtrlSetState(-1, $GUI_HIDE)

$hGUI_SEARCH_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600,25,"TH Snipe") & "    ")
; this tab will be empty because it is only used to display a child GUI
; below controls are only shown when the strategy is disabled and the child gui will be hidden.
	$lblTSdisabled = GUICtrlCreateLabel(GetTranslated(600,49, -1) & " " & GetTranslated(600, 25, -1) & " " & GetTranslated(600,50, -1), 20, 30, $_GUI_MAIN_WIDTH - 40, -1)
	GUICtrlSetState(-1, $GUI_HIDE)

$hGUI_SEARCH_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslated(600,26,"Bully") & "    ")
; this tab will be empty because it is only used to display a child GUI
	$lblBullydisabled = GUICtrlCreateLabel(GetTranslated(600,49, -1) & " " & GetTranslated(600, 26, -1) & " " & GetTranslated(600,50, -1), 20, 30, $_GUI_MAIN_WIDTH - 40, -1)
	GUICtrlSetState(-1, $GUI_HIDE)
$hGUI_SEARCH_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslated(600,27,"Options"))
; this tab will be empty because it is only used to display a child GUI

GUICtrlCreateTabItem("")
;GUISetState()