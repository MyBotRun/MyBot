; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $chkVersion, $chkDeleteLogs, $chkDeleteTemp, $chkDeleteLoots
Global $chkAutostart, $txtAutostartDelay, $chkLanguage,$chkDisposeWindows, $txtWAOffsetx, $txtWAOffsety, $cmbDisposeWindowsCond
Global $chkDebugClick, $chkDebugSetlog, $chkDebugOcr, $chkDebugImageSave, $chkdebugBuildingPos, $chkdebugTrain, $chkdebugOCRDonate
Global $chkTotalCampForced, $txtTotalCampForced
Global $txtDeleteLogsDays, $txtDeleteTempDays, $txtDeleteLootsDays, $cmbLanguage, $chkScreenshotType, $chkScreenshotHideName
Global $sldVSDelay, $sldMaxVSDelay, $lblVSDelay, $lblMaxVSDelay, $lbltxtVSDelay, $lbltxtMaxVSDelay
Global $sldTrainITDelay ,  $lbltxtTrainITDelay, $chkAlertSearch
Global $chkSinglePBTForced, $txtSinglePBTimeForced, $txtPBTimeForcedExit

$hGUI_BOT = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $frmBot)
;GUISetBkColor($COLOR_WHITE, $hGUI_BOT)

#include "MBR GUI Design Child Bot - Options.au3"
#include "MBR GUI Design Child Bot - Debug.au3"
#include "MBR GUI Design Child Bot - Profiles.au3"
#include "MBR GUI Design Child Bot - Stats.au3"

GUISwitch($hGUI_BOT)

$hGUI_BOT_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
$hGUI_BOT_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,35,"Options"))
; this tab will be empty because it is only used to display a child GUI
$hGUI_BOT_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslated(600,51,"Debug"))
; this tab will be empty because it is only used to display a child GUI
$hGUI_BOT_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,36,"Profiles"))
; this tab will be empty because it is only used to display a child GUI
$hGUI_BOT_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslated(600,37, "Stats"))
; this tab will be empty because it is only used to display a child GUI
GUICtrlCreateTabItem("")