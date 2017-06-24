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

Global $g_hCmbCOCDistributors = 0, $g_hCmbSuspendAndroid = 0, $g_hChkAndroidAdbClickDragScript = 0

Func CreateBotAndroid()
   Local $x = 25, $y = 45, $w = 210, $h = 50
   GUICtrlCreateGroup(GetTranslatedFileIni("MBR Distributors", "Group_01", "Distributors"), $x - 20, $y - 20, $w, $h) ; $g_iSizeWGrpTab2, $g_iSizeHGrpTab2
	   $y -=2
	   $g_hCmbCOCDistributors = GUICtrlCreateCombo("", $x - 8 , $y, 185, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	   _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Distributors", "CmbCOCDistributors_Info_01", "Allow bot to launch COC based on the distribution chosen"))
	   LoadCOCDistributorsComboBox()
	   SetCurSelCmbCOCDistributors()
	   GUICtrlSetOnEvent(-1, "cmbCOCDistributors")
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $y += $h + 5
   $w = $g_iSizeWGrpTab2 - 2

   GUICtrlCreateGroup(GetTranslatedFileIni("Android", "Android_Options", "Android Options"), $x - 20, $y - 20, $w, $h)
	   ;$y -=2
	   $g_hChkAndroidAdbClickDragScript = GUICtrlCreateCheckbox(GetTranslatedFileIni("Android", "ChkAdbClickDragScript", "Use script for accurate Click && Drag"), $x, $y, -1, -1)
	   _GUICtrlSetTip(-1, GetTranslatedFileIni("Android", "ChkAdbClickDragScript_Info", "Use Android specific script file for Click & Drag.\r\nIf unchecked use more compatible 'input swipe'."))
	   GUICtrlSetState(-1, (($g_bAndroidAdbClickDragScript) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   $y += $h + 5
   $w = $g_iSizeWGrpTab2 - 2

   GUICtrlCreateGroup(GetTranslatedFileIni("MBR Distributors", "Group_02", "Advanced Android Options"), $x - 20, $y - 20, $w, $h)
	   $y -=2
	   GUICtrlCreateLabel(GetTranslatedFileIni("MBR Distributors", "LblAdvanced_Android_Options", "Suspend/Resume Android"), $x - 8, $y + 5, 180, 22, $SS_RIGHT)
	   $g_hCmbSuspendAndroid = GUICtrlCreateCombo("", $x - 8 + 180 + 5, $y, 200, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	   GUICtrlSetData(-1, GetTranslatedFileIni("MBR Distributors", "CmbSuspendAndroid_Item_01", "Disabled|Only during Search/Attack|For every Image processing call"))
	   _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Distributors", "CmbSuspendAndroid_Info_01", 'Specify if Android will be suspended for brief time only during search and attack or\r\nfor every ImgLoc/Image processing call. If you experience more frequent network issues\r\ntry to use "Only during Search/Attack" option or disable this feature.'))
	   _GUICtrlComboBox_SetCurSel(-1, AndroidSuspendFlagsToIndex($g_iAndroidSuspendModeFlags))
	   GUICtrlSetOnEvent(-1, "cmbSuspendAndroid")
   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
