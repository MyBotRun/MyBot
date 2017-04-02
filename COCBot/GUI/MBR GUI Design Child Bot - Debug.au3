; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file This file creates the "Debug" tab under the "Bot" tab
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

;$hGUI_BotDebug = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_BOT)
;GUISwitch($hGUI_BotDebug)

Global $g_hChkDebugClick = 0, $g_hChkDebugSetlog = 0, $g_hChkDebugOCR = 0, $g_hChkDebugImageSave = 0, $g_hChkdebugBuildingPos = 0, $g_hChkdebugTrain = 0, $g_hChkDebugOCRDonate = 0
Global $g_hChkdebugAttackCSV = 0, $g_hChkMakeIMGCSV = 0, $g_hChkDebugDisableZoomout = 0, $g_hChkDebugDisableVillageCentering = 0, $g_hChkDebugDeadbaseImage = 0

Global $g_hBtnTestTrain = 0, $g_hBtnTestDonateCC = 0, $g_hBtnTestRequestCC = 0, $g_hBtnTestSendText = 0, $g_hBtnTestAttackBar = 0, $g_hBtnTestClickDrag = 0, $g_hBtnTestImage = 0
Global $g_hBtnTestVillageSize = 0, $g_hBtnTestDeadBase = 0, $g_hBtnTestTHimgloc = 0, $g_hBtnTestTrainsimgloc = 0, $g_hBtnTestQuickTrainsimgloc = 0, $g_hTxtTestFindButton = 0
Global $g_hBtnTestFindButton = 0, $g_hBtnTestDeadBaseFolder = 0, $g_hBtnTestCleanYard = 0, $g_hBtnTestAttackCSV = 0, $g_hBtnTestimglocTroopBar = 0
Global $g_hBtnTestConfigSave = 0, $g_hBtnTestConfigApply = 0, $g_hBtnTestConfigRead = 0, $g_hBtnTestOcrMemory = 0

Func CreateBotDebug()
   Local $x = 25, $y = 45
   GUICtrlCreateGroup(GetTranslated(636, 34, "Debug"), $x - 20, $y - 20, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2)
	  $g_hChkDebugClick = GUICtrlCreateCheckbox(GetTranslated(636, 40, "Click"), $x, $y - 5, -1, -1)
	  _GUICtrlSetTip(-1, GetTranslated(636, 35, "Debug: Write the clicked (x,y) coordinates to the log."))
	  $y += 20
	  $g_hChkDebugSetlog = GUICtrlCreateCheckbox(GetTranslated(636, 41, "Messages"), $x, $y - 5, -1, -1)
	  _GUICtrlSetTip(-1, GetTranslated(636, 36, "Debug: Enables debug SetLog messages in code for Troubleshooting."))
	  GUICtrlSetState(-1, $GUI_DISABLE)
	  GUICtrlSetState(-1, $GUI_HIDE)
	  $y += 20
	  $g_hChkDebugOCR = GUICtrlCreateCheckbox(GetTranslated(636, 42, "OCR"), $x, $y - 5, -1, -1)
	  _GUICtrlSetTip(-1, GetTranslated(636, 37, "Debug: Enables Saving OCR images for troubleshooting."))
	  GUICtrlSetState(-1, $GUI_DISABLE)
	  GUICtrlSetState(-1, $GUI_HIDE)
	  $y += 20
	  $g_hChkDebugImageSave = GUICtrlCreateCheckbox(GetTranslated(636, 43, "Images"), $x, $y - 5, -1, -1)
	  _GUICtrlSetTip(-1, GetTranslated(636, 38, "Debug: Enables Saving images for troubleshooting."))
	  GUICtrlSetState(-1, $GUI_DISABLE)
	  GUICtrlSetState(-1, $GUI_HIDE)
	  $y += 20
	  $g_hChkdebugBuildingPos = GUICtrlCreateCheckbox(GetTranslated(636, 44, "Buildings"), $x, $y - 5, -1, -1)
	  _GUICtrlSetTip(-1, GetTranslated(636, 39, "Debug: Enables showing positions of buildings in log."))
	  GUICtrlSetState(-1, $GUI_DISABLE)
	  GUICtrlSetState(-1, $GUI_HIDE)
	  $y += 20
	  $g_hChkdebugTrain = GUICtrlCreateCheckbox(GetTranslated(636, 73, "Training"), $x, $y - 5, -1, -1)
	  _GUICtrlSetTip(-1, GetTranslated(636, 74, "Debug: Enables showing debug during training."))
	  GUICtrlSetState(-1, $GUI_DISABLE)
	  GUICtrlSetState(-1, $GUI_HIDE)
	  $y += 20
	  $g_hChkDebugOCRDonate = GUICtrlCreateCheckbox(GetTranslated(636, 91, "Online debug donations"), $x, $y - 5, -1, -1)
	  _GUICtrlSetTip(-1, GetTranslated(636, 92, "Debug: make ocr of donations and simulate only donate but no donate any troop"))
	  GUICtrlSetState(-1, $GUI_DISABLE)
	  GUICtrlSetState(-1, $GUI_HIDE)
	  $y += 20
	  $g_hChkdebugAttackCSV = GUICtrlCreateCheckbox(GetTranslated(636, 106, "Attack CSV"), $x, $y - 5, -1, -1)
	  _GUICtrlSetTip(-1, GetTranslated(636, 107, "Debug: Generates special CSV parse log files"))
	  GUICtrlSetState(-1, $GUI_DISABLE)
	  GUICtrlSetState(-1, $GUI_HIDE)
	  $y += 20
	  $g_hChkMakeIMGCSV = GUICtrlCreateCheckbox(GetTranslated(636, 108, "Attack CSV Image"), $x, $y - 5, -1, -1)
	  _GUICtrlSetTip(-1, GetTranslated(636, 109, "Debug: Enables saving clean and location marked up images of bases attacked by CSV scripts"))
	  GUICtrlSetState(-1, $GUI_DISABLE)
	  GUICtrlSetState(-1, $GUI_HIDE)
	  $y += 20
	  $g_hChkDebugDisableZoomout = GUICtrlCreateCheckbox(GetTranslated(636, 112, "Disable Zoomout"), $x, $y - 5, -1, -1)
	  _GUICtrlSetTip(-1, GetTranslated(636, 113, "Debug: Disables zoomout of village."))
	  GUICtrlSetState(-1, $GUI_DISABLE)
	  GUICtrlSetState(-1, $GUI_HIDE)
	  $y += 20
	  $g_hChkDebugDisableVillageCentering = GUICtrlCreateCheckbox(GetTranslated(636, 114, "Disable Village Centering"), $x, $y - 5, -1, -1)
	  _GUICtrlSetTip(-1, GetTranslated(636, 115, "Debug: Disables centering of village."))
	  GUICtrlSetState(-1, $GUI_DISABLE)
	  GUICtrlSetState(-1, $GUI_HIDE)
	  $y += 20
	  $g_hChkDebugDeadbaseImage = GUICtrlCreateCheckbox(GetTranslated(636, 116, "Deadbase Image save"), $x, $y - 5, -1, -1)
	  _GUICtrlSetTip(-1, GetTranslated(636, 117, "Debug: Saves images of skipped deadbase villages."))
	  GUICtrlSetState(-1, $GUI_DISABLE)
	  GUICtrlSetState(-1, $GUI_HIDE)
	  $y += 20
	   $g_hChkDebugSmartZap = GUICtrlCreateCheckbox(GetTranslated(638, 23, "Debug SmartZap"), $x, $y - 5, -1, -1)
	   _GUICtrlSetTip(-1, GetTranslated(638, 24, "Use it to debug SmartZap"))

	  Local $x = 300
	  $y = 52
	  Local $yNext = 30
	  $g_hBtnTestTrain = GUICtrlCreateButton(GetTranslated(636, 88, "Test Train"), $x, $y, 140, 25)
	  $y += $yNext

	  $g_hBtnTestDonateCC = GUICtrlCreateButton(GetTranslated(636, 89, "Test Donate"), $x, $y, 140, 25)
	  $y += $yNext

	  $g_hBtnTestRequestCC = GUICtrlCreateButton(GetTranslated(636, 110, "Test Request"), $x, $y, 140, 25)
	  $y += $yNext

	  $g_hBtnTestAttackBar = GUICtrlCreateButton(GetTranslated(636, 90, "Test Attack Bar"), $x, $y, 140, 25)
	  $y += $yNext

	  $g_hBtnTestClickDrag = GUICtrlCreateButton(GetTranslated(636, 102, "Test Click Drag (scrolling)"), $x, $y, 140, 25)
	  $y += $yNext

	  $g_hBtnTestImage = GUICtrlCreateButton(GetTranslated(636, 103, "Test Image"), $x, $y, 140, 25)
	  $y += $yNext

	  $g_hBtnTestVillageSize = GUICtrlCreateButton(GetTranslated(636, 111, "Test Village Size"), $x, $y, 140, 25)
	  $y += $yNext

	  $g_hBtnTestDeadBase = GUICtrlCreateButton(GetTranslated(636, 120, "Test Dead Base"), $x, $y, 140, 25)
	  $y += $yNext

	  $g_hBtnTestTHimgloc = GUICtrlCreateButton("imgloc TH", $x, $y, 140, 25)
	  $y += $yNext

	  $g_hBtnTestTrainsimgloc = GUICtrlCreateButton("New Train Test", $x, $y, 140, 25)
	  $y += $yNext

	  $g_hBtnTestQuickTrainsimgloc = GUICtrlCreateButton("Quick Train Test", $x, $y, 140, 25)

	  $y += $yNext
	  $g_hBtnTestOcrMemory = GUICtrlCreateButton("OCR Memory Test", $x, $y, 140, 25)


	  ; now go up again
	  $x -= 145

	  $g_hTxtTestFindButton = GUICtrlCreateInput("BoostOne", $x - 90, $y + 3, 85, 20)
	  $g_hBtnTestFindButton = GUICtrlCreateButton(GetTranslated(636, 118, "Test Find Button"), $x, $y, 140, 25)
	  $y -= $yNext

	  $g_hBtnTestDeadBaseFolder = GUICtrlCreateButton(GetTranslated(636, 116, "Test Dead Base Folder"), $x, $y, 140, 25)
	  $g_hBtnTestCleanYard = GUICtrlCreateButton(GetTranslated(636, 119, "Test Clean Yard"), $x - 145, $y, 140, 25)
	  $y -= $yNext

	  $g_hBtnTestAttackCSV = GUICtrlCreateButton(GetTranslated(636, 121, "Test Attack CSV"), $x, $y, 140, 25)
	  $y -= $yNext

	  $g_hBtnTestimglocTroopBar = GUICtrlCreateButton("IMGLOC ATTACKBAR", $x, $y, 140, 25)
	  $y -= $yNext

	  $g_hBtnTestConfigSave = GUICtrlCreateButton("Config Save", $x + 20, $y, 120, 25)
	  $y -= $yNext
	  $g_hBtnTestConfigApply = GUICtrlCreateButton("Config Apply", $x + 20, $y, 120, 25)
	  $y -= $yNext
	  $g_hBtnTestConfigRead = GUICtrlCreateButton("Config Read", $x + 20, $y, 120, 25)
	  $y -= $yNext

	  $g_hBtnTestSendText = GUICtrlCreateButton("Send Text", $x + 20, $y, 120, 25)
	  $y -= $yNext
   GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

