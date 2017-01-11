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
$grpDebug = GUICtrlCreateGroup(GetTranslated(636, 34, "Debug"), $x - 20, $y - 20, 440, 360)
$chkDebugClick = GUICtrlCreateCheckbox(GetTranslated(636, 40, "Click"), $x, $y - 5, -1, -1)
_GUICtrlSetTip(-1, GetTranslated(636, 35, "Debug: Write the clicked (x,y) coordinates to the log."))
$y += 20
$chkDebugSetlog = GUICtrlCreateCheckbox(GetTranslated(636, 41, "Messages"), $x, $y - 5, -1, -1)
_GUICtrlSetTip(-1, GetTranslated(636, 36, "Debug: Enables debug SetLog messages in code for Troubleshooting."))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 20
$chkDebugOcr = GUICtrlCreateCheckbox(GetTranslated(636, 42, "OCR"), $x, $y - 5, -1, -1)
_GUICtrlSetTip(-1, GetTranslated(636, 37, "Debug: Enables Saving OCR images for troubleshooting."))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 20
$chkDebugImageSave = GUICtrlCreateCheckbox(GetTranslated(636, 43, "Images"), $x, $y - 5, -1, -1)
_GUICtrlSetTip(-1, GetTranslated(636, 38, "Debug: Enables Saving images for troubleshooting."))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 20
$chkdebugBuildingPos = GUICtrlCreateCheckbox(GetTranslated(636, 44, "Buildings"), $x, $y - 5, -1, -1)
_GUICtrlSetTip(-1, GetTranslated(636, 39, "Debug: Enables showing positions of buildings in log."))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 20
$chkdebugTrain = GUICtrlCreateCheckbox(GetTranslated(636, 73, "Training"), $x, $y - 5, -1, -1)
_GUICtrlSetTip(-1, GetTranslated(636, 74, "Debug: Enables showing debug during training."))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 20
$chkdebugOCRDonate = GUICtrlCreateCheckbox(GetTranslated(636, 91, "Online debug donations"), $x, $y - 5, -1, -1)
_GUICtrlSetTip(-1, GetTranslated(636, 92, "Debug: make ocr of donations and simulate only donate but no donate any troop"))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 20
$chkdebugAttackCSV = GUICtrlCreateCheckbox(GetTranslated(636, 106, "Attack CSV"), $x, $y - 5, -1, -1)
_GUICtrlSetTip(-1, GetTranslated(636, 107, "Debug: Generates special CSV parse log files"))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 20
$chkmakeIMGCSV = GUICtrlCreateCheckbox(GetTranslated(636, 108, "Attack CSV Image"), $x, $y - 5, -1, -1)
_GUICtrlSetTip(-1, GetTranslated(636, 109, "Debug: Enables saving clean and location marked up images of bases attacked by CSV scripts"))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 20
$chkDebugDisableZoomout = GUICtrlCreateCheckbox(GetTranslated(636, 112, "Disable Zoomout"), $x, $y - 5, -1, -1)
_GUICtrlSetTip(-1, GetTranslated(636, 113, "Debug: Disables zoomout of village."))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 20
$chkDebugDisableVillageCentering = GUICtrlCreateCheckbox(GetTranslated(636, 114, "Disable Village Centering"), $x, $y - 5, -1, -1)
_GUICtrlSetTip(-1, GetTranslated(636, 115, "Debug: Disables centering of village."))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 20
$chkDebugDeadbaseImage = GUICtrlCreateCheckbox(GetTranslated(636, 116, "Deadbase Image save"), $x, $y - 5, -1, -1)
_GUICtrlSetTip(-1, GetTranslated(636, 117, "Debug: Saves images of skipped deadbase villages."))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetState(-1, $GUI_HIDE)
$y += 20
$chkDebugSmartZap = GUICtrlCreateCheckbox(GetTranslated(638, 23,"Debug SmartZap"), $x, $y -5, -1, -1)
$txtTip = GetTranslated(638, 24, "Use this to debug SmartZap")
_GUICtrlSetTip(-1, $txtTip)

Local $x = 300
$y = 52
Local $yNext = 30
$btnTestTrain = GUICtrlCreateButton(GetTranslated(636, 88, "Test Train"), $x, $y, 140, 25)
$y += $yNext

$btnTestDonateCC = GUICtrlCreateButton(GetTranslated(636, 89, "Test Donate"), $x, $y, 140, 25)
$y += $yNext

$btnTestRequestCC = GUICtrlCreateButton(GetTranslated(636, 110, "Test Request"), $x, $y, 140, 25)
$y += $yNext

$btnTestAttackBar = GUICtrlCreateButton(GetTranslated(636, 90, "Test Attack Bar"), $x, $y, 140, 25)
$y += $yNext

$btnTestClickDrag = GUICtrlCreateButton(GetTranslated(636, 102, "Test Click Drag (scrolling)"), $x, $y, 140, 25)
$y += $yNext

$btnTestImage = GUICtrlCreateButton(GetTranslated(636, 103, "Test Image"), $x, $y, 140, 25)
$y += $yNext

$btnTestVillageSize = GUICtrlCreateButton(GetTranslated(636, 111, "Test Village Size"), $x, $y, 140, 25)
$y += $yNext

$btnTestDeadBase = GUICtrlCreateButton(GetTranslated(636, 120, "Test Dead Base"), $x, $y, 140, 25)
$y += $yNext

$btnTestTHimgloc = GUICtrlCreateButton("imgloc TH", $x, $y, 140, 25)
$y += $yNext

$btnTestTrainsimgloc = GUICtrlCreateButton("New Train Test", $x, $y, 140, 25)
$y += $yNext

$btnTestQuickTrainsimgloc = GUICtrlCreateButton("Quick Train Test", $x, $y, 140, 25)

; now go up again
$x -= 145

$txtTestFindButton = GUICtrlCreateInput("BoostOne", $x - 90, $y + 3, 85, 20)
$btnTestFindButton = GUICtrlCreateButton(GetTranslated(636, 118, "Test Find Button"), $x, $y, 140, 25)
$y -= $yNext

$btnTestDeadBaseFolder = GUICtrlCreateButton(GetTranslated(636, 116, "Test Dead Base Folder"), $x, $y, 140, 25)
$btnTestCleanYard = GUICtrlCreateButton(GetTranslated(636, 119, "Test Clean Yard"), $x - 145, $y, 140, 25)
$y -= $yNext

$btnTestAttackCSV = GUICtrlCreateButton(GetTranslated(636, 121, "Test Attack CSV"), $x, $y, 140, 25)
$y -= $yNext

$btnTestimglocTroopBar = GUICtrlCreateButton("IMGLOC ATTACKBAR", $x, $y, 140, 25)
$y -= $yNext

$btnTestConfigSave = GUICtrlCreateButton("Config Save", $x + 20, $y, 120, 25)
$y -= $yNext
$btnTestConfigApply = GUICtrlCreateButton("Config Apply", $x + 20, $y, 120, 25)
$y -= $yNext
$btnTestConfigRead = GUICtrlCreateButton("Config Read", $x + 20, $y, 120, 25)
$y -= $yNext
GUICtrlCreateGroup("", -99, -99, 1, 1)

