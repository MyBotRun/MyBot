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

Global $cmbScriptNameDB, $lblNotesScriptAB

$hGUI_DEADBASE_ATTACK_SCRIPTED = GUICreate("", $_GUI_MAIN_WIDTH - 195, $_GUI_MAIN_HEIGHT - 344, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_DEADBASE)
;GUISetBkColor($COLOR_WHITE, $hGUI_DEADBASE_ATTACK_SCRIPTED)

Local $x = 25, $y = 20
	$grpAttackCSVDB = GUICtrlCreateGroup(GetTranslated(607,1,"Deploy"), $x - 20, $y - 20, 278, 306)
;	 $x -= 15
		$chkmakeIMGCSVDB = GUICtrlCreateCheckbox(GetTranslated(607,2, "IMG"), $x + 150, $y, -1, -1)
			$txtTip = GetTranslated(607,3, "Make IMG with extra info in Profile -> Temp Folder")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetTip(-1, $txtTip)
		$y +=15
		$cmbScriptNameDB=GUICtrlCreateCombo("", $x, $y, 185, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(607,4, "Choose the script; You can edit/add new scripts located in folder: 'CSV/Attack'")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "cmbScriptNameDB")
		$picreloadScriptsDB = GUICtrlCreateIcon($pIconLib, $eIcnReload, $x + 192, $y + 2, 16, 16)
			$txtTip =  GetTranslated(607,5, "Reload Script Files")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, 'UpdateComboScriptNameDB') ; Run this function when the secondary GUI [X] is clicked
		$y +=25
		$lblNotesScriptDB =  GUICtrlCreateLabel("", $x, $y + 5, 180, 118)
			PopulateComboScriptsFilesDB() ; populate
		$picreloadScripts = GUICtrlCreateIcon($pIconLib, $eIcnEdit, $x + 192, $y + 2, 16, 16)
			$txtTip =  GetTranslated(607,6, "Show/Edit current Attack Script")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "EditScriptDB")
		$y +=25
		$picnewScriptsDB = GUICtrlCreateIcon($pIconLib, $eIcnAddcvs, $x + 192, $y + 2, 16, 16)
			$txtTip =  GetTranslated(607,7, "Create a new Attack Script")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "NewScriptDB")
		$y +=25
		$picduplicateScriptsDB = GUICtrlCreateIcon($pIconLib, $eIcnCopy, $x + 192, $y + 2, 16, 16)
			$txtTip =  GetTranslated(607,8, "Copy current Attack Script to a new name")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "DuplicateScriptDB")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

;GUISetState()

;------------------------------------------------------------------------------------------
;----- populate list of script and assign the default value if no exist profile -----------
UpdateComboScriptNameDB()
Local $tempindex = _GUICtrlComboBox_FindStringExact($cmbScriptNameDB, $scmbDBScriptName)
If $tempindex = -1 Then $tempindex = 0
_GUICtrlComboBox_SetCurSel($cmbScriptNameDB, $tempindex)
;------------------------------------------------------------------------------------------
