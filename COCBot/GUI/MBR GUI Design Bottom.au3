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

;~ ------------------------------------------------------
;~ Lower part visible on all Tabs
;~ ------------------------------------------------------
;Local $btnColor = True
Local $btnColor = False

;~ Buttons
Local $x = 15, $y = 525
$grpButtons = GUICtrlCreateGroup("https://mybot.run" & GetTranslated(13,26, "- freeware bot -"), $x - 5, $y - 10, 190, 85)
	$btnStart = GUICtrlCreateButton(GetTranslated(13,1, "Start Bot"), $x, $y + 2 +5, 90, 40-5)
		GUICtrlSetOnEvent(-1, "btnStart")
		IF $btnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
	    GUICtrlSetState(-1, $GUI_DISABLE)
	$btnStop = GUICtrlCreateButton(GetTranslated(13,2, "Stop Bot"), -1, -1, 90, 40-5)
		;GUICtrlSetOnEvent(-1, "btnStop")
		IF $btnColor then GUICtrlSetBkColor(-1, 0xDB4D4D)
		GUICtrlSetState(-1, $GUI_HIDE)
 	$btnPause = GUICtrlCreateButton(GetTranslated(13,3, "Pause"), $x + 90, -1, 90, 40-5)
		$txtTip = GetTranslated(13,4, "Use this to PAUSE all actions of the bot until you Resume.")
		GUICtrlSetTip(-1, $txtTip)
		;GUICtrlSetOnEvent(-1, "btnPause")
 		IF $btnColor then GUICtrlSetBkColor(-1,  0xFFA500)
		GUICtrlSetState(-1, $GUI_HIDE)
	$btnResume = GUICtrlCreateButton(GetTranslated(13,5, "Resume"), -1, -1, 90, 40-5)
 		$txtTip = GetTranslated(13,6, "Use this to RESUME a paused Bot.")
		GUICtrlSetTip(-1, $txtTip)
		;GUICtrlSetOnEvent(-1, "btnResume")
		IF $btnColor then GUICtrlSetBkColor(-1,  0xFFA500)
		GUICtrlSetState(-1, $GUI_HIDE)
	$btnSearchMode = GUICtrlCreateButton(GetTranslated(13,7, "Search Mode"), -1, -1, 90, 40-5)
		$txtTip = GetTranslated(13,8, "Does not attack. Searches for a Village that meets conditions.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "btnSearchMode")
		IF $btnColor then GUICtrlSetBkColor(-1,  0xFFA500)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$btnMakeScreenshot = GUICtrlCreateButton(GetTranslated(13,9, "Photo"), $x , $y + 45, 40, -1)
		$txtTip = GetTranslated(13,10, "Click here to take a snaphot of your village and save it to a file.")
		GUICtrlSetTip(-1, $txtTip)
		;GUICtrlSetOnEvent(-1, "btnMakeScreenshot")
		IF $btnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
	$btnHide = GUICtrlCreateButton(GetTranslated(13,11, "Hide"), $x + 40, $y + 45, 50, -1)
		$txtTip = GetTranslated(13,12, "Use this to move the Android Window out of sight.") & @CRLF & GetTranslated(13,13, "(Not minimized, but hidden)")
		GUICtrlSetTip(-1, $txtTip)
		;GUICtrlSetOnEvent(-1, "btnHide")
		IF $btnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$chkBackground = GUICtrlCreateCheckbox(GetTranslated(13,14, "Background") & @CRLF & GetTranslated(13,15, "Mode"), $x + 100, $y + 48, 70, 20, BITOR($BS_MULTILINE, $BS_CENTER))
		$txtTip = GetTranslated(13,16, "Check this to ENABLE the Background Mode of the Bot.") & @CRLF & GetTranslated(13,17, "With this you can also hide the BlueStacks window out of sight.")
		GUICtrlSetFont(-1, 7)
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkBackground")
		GUICtrlSetState(-1, $GUI_UNCHECKED)
	$btnAttackNowDB = GUICtrlCreateButton(GetTranslated(13,18, "DB Attack!"), $x + 190, $y - 4, 60, -1)
		;GUICtrlSetOnEvent(-1, "btnAttackNowDB")
		GUICtrlSetState(-1, $GUI_HIDE)
	$btnAttackNowLB = GUICtrlCreateButton(GetTranslated(13,19, "LB Attack!"), $x + 190, $y + 23, 60, -1)
		;GUICtrlSetOnEvent(-1, "btnAttackNowLB")
		GUICtrlSetState(-1, $GUI_HIDE)
	$btnAttackNowTS = GUICtrlCreateButton(GetTranslated(13,20, "TH Snipe!"), $x + 190, $y + 50, 60, -1)
		;GUICtrlSetOnEvent(-1, "btnAttackNowTS")
		GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$pic2arrow = GUICtrlCreatePic(@ScriptDir & "\Images\2arrow.jpg", $x + 187, $y + 10, 50, 45)
GUICtrlSetOnEvent(-1, "btnVillageStat")
$lblVersion = GUICtrlCreateLabel($sBotVersion, 205, $y + 60, 60, 17, $SS_CENTER)
	GUICtrlSetColor(-1, $COLOR_MEDGRAY)

;~ Village
Local $x = 290, $y = 535
$grpVillage = GUICtrlCreateGroup(GetTranslated(13,21, "Village"), $x - 20, $y - 20, 190, 85)
	$lblResultGoldNow = GUICtrlCreateLabel("", $x, $y + 2, 50, 15, $SS_RIGHT)
	$lblResultGoldHourNow = GUICtrlCreateLabel("", $x, $y + 2, 50, 15, $SS_RIGHT)
		GUICtrlSetState(-1, $GUI_HIDE)
	$picResultGoldNow = GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x + 60, $y, 16, 16)
		GUICtrlSetState(-1, $GUI_HIDE)
	$picResultGoldTemp = GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x - 5, $y, 16, 16)
	$lblResultElixirNow = GUICtrlCreateLabel("", $x, $y + 22, 50, 15, $SS_RIGHT)
	$lblResultElixirHourNow = GUICtrlCreateLabel("", $x, $y + 22, 50, 15, $SS_RIGHT)
		GUICtrlSetState(-1, $GUI_HIDE)
	$picResultElixirNow = GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x + 60, $y + 20, 16, 16)
		GUICtrlSetState(-1, $GUI_HIDE)
	$picResultElixirTemp = GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x - 5, $y + 20, 16, 16)
	$lblResultDENow = GUICtrlCreateLabel("", $x, $y + 42, 50, 15, $SS_RIGHT)
	$lblResultDEHourNow = GUICtrlCreateLabel("", $x, $y + 42, 50, 15, $SS_RIGHT)
		GUICtrlSetState(-1, $GUI_HIDE)
	$picResultDENow = GUICtrlCreateIcon ($pIconLib, $eIcnDark, $x + 60, $y + 40, 16, 16)
		GUICtrlSetState(-1, $GUI_HIDE)
	$picResultDETemp = GUICtrlCreateIcon ($pIconLib, $eIcnDark, $x - 5, $y + 40, 16, 16)

	$x += 80
	;trophy / runtime
	$lblResultTrophyNow = GUICtrlCreateLabel("", $x, $y + 2, 50, 15, $SS_RIGHT)
	$picResultTrophyNow = GUICtrlCreateIcon ($pIconLib, $eIcnTrophy, $x + 59, $y , 16, 16)
	$lblResultRuntimeNow = GUICtrlCreateLabel("00:00:00", $x, $y + 2, 50, 15, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	$picResultRuntimeNow = GUICtrlCreateIcon($pIconLib, $eIcnHourGlass, $x +57, $y, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	;builders/attacked
	$lblResultBuilderNow = GUICtrlCreateLabel("", $x, $y + 22, 50, 15, $SS_RIGHT)
	$picResultBuilderNow = GUICtrlCreateIcon ($pIconLib, $eIcnBuilder, $x + 59, $y + 20, 16, 16)
	$lblResultAttackedHourNow = GUICtrlCreateLabel("0", $x, $y + 22, 50, 15, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	$picResultAttackedHourNow = GUICtrlCreateIcon($pIconLib, $eIcnBldgTarget, $x +59, $y + 20, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	;gems/skipped
	$lblResultGemNow = GUICtrlCreateLabel("", $x, $y + 42, 50, 15, $SS_RIGHT)
	$picResultGemNow = GUICtrlCreateIcon ($pIconLib, $eIcnGem, $x + 59, $y + 40, 16, 16)
	$lblResultSkippedHourNow = GUICtrlCreateLabel("0", $x, $y + 42, 50, 15, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	$picResultSkippedHourNow = GUICtrlCreateIcon ($pIconLib, $eIcnBldgX, $x + 59, $y + 40, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)

	$x = 290
	$lblVillageReportTemp = GUICtrlCreateLabel(GetTranslated(13,22, "Village Report") & @CRLF & GetTranslated(13,23, "will appear here") & @CRLF & GetTranslated(13,24, "on first run."), $x + 27, $y + 5, 100, 45, BITOR($SS_CENTER, $BS_MULTILINE))

 	$btnTestVillage = GUICtrlCreateButton("TEST BUTTON", $x + 90 , $y -25, -1, -1)
 		GUICtrlSetOnEvent(-1, "btnTestDonate")
		GUICtrlSetState(-1, $GUI_HIDE)


GUICtrlCreateGroup("", -99, -99, 1, 1)

