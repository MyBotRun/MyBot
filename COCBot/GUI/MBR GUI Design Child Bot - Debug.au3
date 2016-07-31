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
;$hGUI_BotDebug = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_BOT)
;GUISwitch($hGUI_BotDebug)

Local $x = 25, $y = 45
$grpDebug = GUICtrlCreateGroup(GetTranslated(636,34, "Debug"), $x - 20, $y - 20, 440, 360)
	$chkDebugClick = GUICtrlCreateCheckbox(GetTranslated(636,40, "Click"), $x, $y-5, -1, -1)
		_GUICtrlSetTip(-1, GetTranslated(636,35, "Debug: Write the clicked (x,y) coordinates to the log."))
	$y += 20
	$chkDebugSetlog = GUICtrlCreateCheckbox(GetTranslated(636,41, "Messages"), $x  , $y-5, -1, -1)
		_GUICtrlSetTip(-1, GetTranslated(636,36, "Debug: Enables debug SetLog messages in code for Troubleshooting."))
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetState(-1, $GUI_HIDE)
	$y += 20
	$chkDebugOcr = GUICtrlCreateCheckbox(GetTranslated(636,42, "OCR"), $x , $y-5, -1, -1)
		_GUICtrlSetTip(-1, GetTranslated(636,37, "Debug: Enables Saving OCR images for troubleshooting."))
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetState(-1, $GUI_HIDE)
	$y += 20
	$chkDebugImageSave = GUICtrlCreateCheckbox(GetTranslated(636,43, "Images"), $x , $y-5, -1, -1)
		_GUICtrlSetTip(-1, GetTranslated(636,38, "Debug: Enables Saving images for troubleshooting."))
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetState(-1, $GUI_HIDE)
	$y += 20
	$chkdebugBuildingPos = GUICtrlCreateCheckbox(GetTranslated(636,44, "Buildings"), $x  , $y-5, -1, -1)
		_GUICtrlSetTip(-1, GetTranslated(636,39, "Debug: Enables showing positions of buildings in log."))
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetState(-1, $GUI_HIDE)
	$y += 20
	$chkdebugTrain = GUICtrlCreateCheckbox(GetTranslated(636,73, "Training"), $x , $y-5, -1, -1)
		_GUICtrlSetTip(-1, GetTranslated(636,74, "Debug: Enables showing debug during training."))
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetState(-1, $GUI_HIDE)
	$y += 20
	$chkdebugOCRDonate = GUICtrlCreateCheckbox(GetTranslated(636,91, "Online debug donations"), $x , $y-5, -1, -1)
		_GUICtrlSetTip(-1, GetTranslated(636,92, "Debug: make ocr of donations and simulate only donate but no donate any troop"))
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetState(-1, $GUI_HIDE)

Local $x = 305
$y = 45
	$btnTestTrain = GUICtrlCreateButton(GetTranslated(636,88, "Test Train"), $x  , $y , 120, 30)

	$y += 50

	$btnTestDonateCC = GUICtrlCreateButton(GetTranslated(636,89, "Test Donate"), $x  , $y , 120, 30)

	$y += 50

	$btnTestAttackBar = GUICtrlCreateButton(GetTranslated(636,90, "Test Attack Bar"), $x  , $y , 120, 30)

GUICtrlCreateGroup("", -99, -99, 1, 1)

