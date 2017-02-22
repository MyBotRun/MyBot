; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Scripted Attack" tab under the "Attack" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hGUI_DEADBASE_ATTACK_SCRIPTED = 0
Global $g_hCmbScriptNameDB = 0, $g_hCmbScriptRedlineImplDB = 0, $g_hCmbScriptDroplineDB = 0
Global $g_hLblNotesScriptDB = 0

Func CreateAttackSearchDeadBaseScripted()
   $g_hGUI_DEADBASE_ATTACK_SCRIPTED = GUICreate("", $_GUI_MAIN_WIDTH - 195, $_GUI_MAIN_HEIGHT - 344, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_DEADBASE)
   ;GUISetBkColor($COLOR_WHITE, $g_hGUI_DEADBASE_ATTACK_SCRIPTED)

   Local $x = 25, $y = 20
	   GUICtrlCreateGroup(GetTranslated(607,1,"Deploy"), $x - 20, $y - 20, 270, 306)
   ;	 $x -= 15
   ;		$chkmakeIMGCSVDB = GUICtrlCreateCheckbox(GetTranslated(607,2, "IMG"), $x + 150, $y, -1, -1)
   ;			$txtTip = GetTranslated(607,3, "Make IMG with extra info in Profile -> Temp Folder")
   ;			GUICtrlSetState(-1, $GUI_UNCHECKED)
   ;			GUICtrlSetState(-1, $GUI_HIDE)
   ;			_GUICtrlSetTip(-1, $txtTip)

		   $y +=15
		   $g_hCmbScriptNameDB = GUICtrlCreateCombo("", $x, $y, 200, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   _GUICtrlSetTip(-1, GetTranslated(607,4, "Choose the script; You can edit/add new scripts located in folder: 'CSV/Attack'"))
			   GUICtrlSetState(-1, $GUI_UNCHECKED)
			   GUICtrlSetOnEvent(-1, "cmbScriptNameDB")
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnReload, $x + 210, $y + 2, 16, 16)
			   _GUICtrlSetTip(-1, GetTranslated(607,5, "Reload Script Files"))
			   GUICtrlSetOnEvent(-1, 'UpdateComboScriptNameDB') ; Run this function when the secondary GUI [X] is clicked

		   $y +=25
		   $g_hLblNotesScriptDB =  GUICtrlCreateLabel("", $x, $y + 5, 200, 180)
		   $g_hCmbScriptRedlineImplDB = GUICtrlCreateCombo("", $x, $y + 195, 230, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
               GUICtrlSetData(-1, GetTranslated(607,9, "ImgLoc Raw Redline (default)|ImgLoc Redline Drop Points|Original Redline|External Edges"))
			   _GUICtrlComboBox_SetCurSel(-1, $g_aiAttackScrRedlineRoutine[$DB])
			   _GUICtrlSetTip(-1, GetTranslated(607,10, "Choose the Redline implementation. ImgLoc Redline is default and best."))
			   GUICtrlSetState(-1, $GUI_UNCHECKED)
			   GUICtrlSetOnEvent(-1, "cmbScriptRedlineImplDB")
		   $g_hCmbScriptDroplineDB = GUICtrlCreateCombo("", $x, $y + 220, 230, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			   GUICtrlSetData(-1, GetTranslated(607,11, "Drop line fix outer corner|Drop line fist Redline point|Full Drop line fix outer corner|Full Drop line fist Redline point|No Drop line"))
			   _GUICtrlComboBox_SetCurSel(-1, $g_aiAttackScrDroplineEdge[$DB])
			   _GUICtrlSetTip(-1, GetTranslated(607,12, "Choose the drop line edges. Default is outer corner and safer. First Redline point can improve attack."))
			   GUICtrlSetState(-1, $GUI_UNCHECKED)
			   GUICtrlSetOnEvent(-1, "cmbScriptDroplineDB")
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnEdit, $x + 210, $y + 2, 16, 16)
			   _GUICtrlSetTip(-1, GetTranslated(607,6, "Show/Edit current Attack Script"))
			   GUICtrlSetOnEvent(-1, "EditScriptDB")

		   $y +=25
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnAddcvs, $x + 210, $y + 2, 16, 16)
			   _GUICtrlSetTip(-1, GetTranslated(607,7, "Create a new Attack Script"))
			   GUICtrlSetOnEvent(-1, "NewScriptDB")

		   $y +=25
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnCopy, $x + 210, $y + 2, 16, 16)
			   _GUICtrlSetTip(-1, GetTranslated(607,8, "Copy current Attack Script to a new name"))
			   GUICtrlSetOnEvent(-1, "DuplicateScriptDB")
	   GUICtrlCreateGroup("", -99, -99, 1, 1)

   ;GUISetState()

   ;------------------------------------------------------------------------------------------
   ;----- populate list of script and assign the default value if no exist profile -----------
   UpdateComboScriptNameDB()
   Local $tempindex = _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameDB, $g_sAttackScrScriptName[$DB])
   If $tempindex = -1 Then $tempindex = 0
   _GUICtrlComboBox_SetCurSel($g_hCmbScriptNameDB, $tempindex)
   ;------------------------------------------------------------------------------------------
EndFunc
