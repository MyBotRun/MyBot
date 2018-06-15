; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Scripted Attack" tab under the "Attack" tab under the "ActiveBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hGUI_ACTIVEBASE_ATTACK_SCRIPTED = 0
Global $g_hCmbScriptNameAB = 0, $g_hCmbScriptRedlineImplAB = 0, $g_hCmbScriptDroplineAB = 0
Global $g_hLblNotesScriptAB = 0 , $g_hbtnAttNow

Func CreateAttackSearchActiveBaseScripted()
	$g_hGUI_ACTIVEBASE_ATTACK_SCRIPTED = _GUICreate("", $_GUI_MAIN_WIDTH - 195, $g_iSizeHGrpTab4, 150, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_ACTIVEBASE)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_ACTIVEBASE_ATTACK_SCRIPTED)

	Local $x = 25, $y = 20
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "Group_01",  -1), $x - 20, $y - 20, 270, $g_iSizeHGrpTab4)

	$y += 15
		$g_hCmbScriptNameAB = GUICtrlCreateCombo("", $x , $y, 200, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "CmbScriptName", -1))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "cmbScriptNameAB")
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnReload, $x + 210, $y + 2, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "IconReload_Info_01", -1))
			GUICtrlSetOnEvent(-1, 'UpdateComboScriptNameAB') ; Run this function when the secondary GUI [X] is clicked

	$y += 25
		$g_hLblNotesScriptAB =  GUICtrlCreateLabel("", $x, $y + 5, 200, 180)
		$g_hCmbScriptRedlineImplAB = GUICtrlCreateCombo("", $x, $y + 195, 230, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "CmbScriptRedlineImpl", "ImgLoc Raw Redline (default)|ImgLoc Redline Drop Points|Original Redline|External Edges"))
			_GUICtrlComboBox_SetCurSel(-1, $g_aiAttackScrRedlineRoutine[$LB])
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "CmbScriptRedlineImpl_Info_01", "Choose the Redline implementation. ImgLoc Redline is default and best."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "cmbScriptRedlineImplAB")
		$g_hCmbScriptDroplineAB = GUICtrlCreateCombo("", $x, $y + 220, 230, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "CmbScriptDropline", "Drop line fix outer corner|Drop line fist Redline point|Full Drop line fix outer corner|Full Drop line fist Redline point|No Drop line"))
			_GUICtrlComboBox_SetCurSel(-1, $g_aiAttackScrDroplineEdge[$LB])
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "CmbScriptDropline_Info_01", "Choose the drop line edges. Default is outer corner and safer. First Redline point can improve attack."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "cmbScriptDroplineAB")

		$g_hbtnAttNow = GUICtrlCreateButton("Attack Now", $x + 70, $y + 250, 91, 25)
			;GUISetState(@SW_SHOW)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "btnAttNow_Info_01", "Attack now Button Which it will make CSV Makers/testers life Easy. You should be in Attack Screen"))
			GUICtrlSetOnEvent(-1, "AttackNow")
			GUICtrlSetState(-1, $GUI_HIDE)

		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnEdit, $x + 210, $y + 2, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "IconShow-Edit_Info_01", -1))
			GUICtrlSetOnEvent(-1, "EditScriptAB")

	$y += 25
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnAddcvs, $x + 210, $y + 2, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "IconCreate_Info_01", -1))
			GUICtrlSetOnEvent(-1, "NewScriptAB")

	$y += 25
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCopy, $x + 210, $y + 2, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "IconCopy_Info_01", -1))
			GUICtrlSetOnEvent(-1, "DuplicateScriptAB")

	$y += 25
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrain, $x + 210, $y + 2, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "IconApply_Info_01", -1))
			GUICtrlSetOnEvent(-1, "ApplyScriptAB")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	;------------------------------------------------------------------------------------------
	;----- populate list of script and assign the default value if no exist profile -----------
	UpdateComboScriptNameAB()
	Local $tempindex = _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameAB, $g_sAttackScrScriptName[$LB])
	If $tempindex = -1 Then $tempindex = 0
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameAB, $tempindex)
	;------------------------------------------------------------------------------------------

EndFunc   ;==>CreateAttackSearchActiveBaseScripted
