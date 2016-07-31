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
Local $y_bottom = 0 ; 515
Local $x = 15, $y = $y_bottom + 10
$grpButtons = GUICtrlCreateGroup("https://mybot.run " & GetTranslated(602,0, "- freeware bot -"), $x - 5, $y - 10, 190, 108)
	$btnStart = GUICtrlCreateButton(GetTranslated(602,1, "Start Bot"), $x, $y + 2 +5, 90, 40-5)
		GUICtrlSetOnEvent(-1, "btnStart")
		IF $btnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
	    GUICtrlSetState(-1, $GUI_DISABLE)
	$btnStop = GUICtrlCreateButton(GetTranslated(602,2, "Stop Bot"), -1, -1, 90, 40-5)
		;GUICtrlSetOnEvent(-1, "btnStop")
		IF $btnColor then GUICtrlSetBkColor(-1, 0xDB4D4D)
		GUICtrlSetState(-1, $GUI_HIDE)
 	$btnPause = GUICtrlCreateButton(GetTranslated(602,3, "Pause"), $x + 90, -1, 90, 40-5)
		$txtTip = GetTranslated(602,4, "Use this to PAUSE all actions of the bot until you Resume.")
		_GUICtrlSetTip(-1, $txtTip)
		;GUICtrlSetOnEvent(-1, "btnPause")
 		IF $btnColor then GUICtrlSetBkColor(-1,  0xFFA500)
		GUICtrlSetState(-1, $GUI_HIDE)
	$btnResume = GUICtrlCreateButton(GetTranslated(602,5, "Resume"), -1, -1, 90, 40-5)
 		$txtTip = GetTranslated(602,6, "Use this to RESUME a paused Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		;GUICtrlSetOnEvent(-1, "btnResume")
		IF $btnColor then GUICtrlSetBkColor(-1,  0xFFA500)
		GUICtrlSetState(-1, $GUI_HIDE)
	$btnSearchMode = GUICtrlCreateButton(GetTranslated(602,7, "Search Mode"), -1, -1, 90, 40-5)
		$txtTip = GetTranslated(602,8, "Does not attack. Searches for a Village that meets conditions.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "btnSearchMode")
		IF $btnColor then GUICtrlSetBkColor(-1,  0xFFA500)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$btnMakeScreenshot = GUICtrlCreateButton(GetTranslated(602,9, "Photo"), $x , $y + 45, 40, -1)
		$txtTip = GetTranslated(602,10, "Click here to take a snaphot of your village and save it to a file.")
		_GUICtrlSetTip(-1, $txtTip)
		;GUICtrlSetOnEvent(-1, "btnMakeScreenshot")
		IF $btnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
	$btnHide = GUICtrlCreateButton(GetTranslated(602,11, "Hide"), $x + 40, $y + 45, 50, -1)
		$txtTip = GetTranslated(602,12, "Use this to move the Android Window out of sight.") & @CRLF & GetTranslated(602,13, "(Not minimized, but hidden)")
		_GUICtrlSetTip(-1, $txtTip)
		;GUICtrlSetOnEvent(-1, "btnHide")
		IF $btnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$btnEmbed = GUICtrlCreateButton(GetTranslated(602,27, "Dock"), $x + 90, $y + 45, 90, -1)
		$txtTip = GetTranslated(602,29, "Use this to embed the Android Window into Bot.")
		_GUICtrlSetTip(-1, $txtTip)
		IF $btnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$chkBackground = GUICtrlCreateCheckbox(GetTranslated(602,14, "Background Mode"), $x + 1, $y + 72, 180, 24)
		$txtTip = GetTranslated(602,16, "Check this to ENABLE the Background Mode of the Bot.") & @CRLF & GetTranslated(602,17, "With this you can also hide the Android Emulator window out of sight.")
		GUICtrlSetFont(-1, 7)
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkBackground")
		GUICtrlSetState(-1, (($AndroidAdbScreencap = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))
	$lblDonate = GUICtrlCreateLabel(GetTranslated(601,19,"Support the development"), $x + 224, $y + 80, 220, 24, $SS_RIGHT)
		GUICtrlSetCursor(-1, 0) ; https://www.autoitscript.com/autoit3/docs/functions/MouseGetCursor.htm
		GUICtrlSetFont(-1, 8.5, $FW_BOLD) ;, $GUI_FONTITALIC + $GUI_FONTUNDER)
		$txtTip = GetTranslated(601,18,"Paypal Donate?")
		_GUICtrlSetTip(-1, $txtTip)
	$btnAttackNowDB = GUICtrlCreateButton(GetTranslated(602,18, "DB Attack!"), $x + 190, $y - 4, 60, -1)
		;GUICtrlSetOnEvent(-1, "btnAttackNowDB")
		GUICtrlSetState(-1, $GUI_HIDE)
	$btnAttackNowLB = GUICtrlCreateButton(GetTranslated(602,19, "LB Attack!"), $x + 190, $y + 23, 60, -1)
		;GUICtrlSetOnEvent(-1, "btnAttackNowLB")
		GUICtrlSetState(-1, $GUI_HIDE)
	$btnAttackNowTS = GUICtrlCreateButton(GetTranslated(602,20, "TH Snipe!"), $x + 190, $y + 50, 60, -1)
		;GUICtrlSetOnEvent(-1, "btnAttackNowTS")
		GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlCreateGroup("", -99, -99, 1, 1)

If $AndroidAdbScreencap = True Then chkBackground() ; update background mode GUI

$pic2arrow = GUICtrlCreatePic(@ScriptDir & "\Images\2arrow.jpg", $x + 187, $y + 10, 50, 45)
;	GUICtrlSetOnEvent(-1, "arrows")

$lblVersion = GUICtrlCreateLabel($sBotVersion, 205, $y + 60, 60, 17, $SS_CENTER)
	GUICtrlSetColor(-1, $COLOR_MEDGRAY)

$arrowleft = GUICtrlCreatePic(@ScriptDir & "\Images\triangle_left.bmp", $x + 247, $y + 30, 8, 14)
   $txtTip = GetTranslated(602,25, "Switch between village info and stats")
   _GUICtrlSetTip(-1, $txtTip)
   ;GUICtrlSetOnEvent(-1, "btnVillageStat")
$arrowright = GUICtrlCreatePic(@ScriptDir & "\Images\triangle_right.bmp", $x + 247 + 198, $y + 30, 8, 14)
   _GUICtrlSetTip(-1, $txtTip)
   ;GUICtrlSetOnEvent(-1, "btnVillageStat")

;~ Village
Local $x = 290, $y = $y_bottom + 20
$grpVillage = GUICtrlCreateGroup(GetTranslated(603,32, "Village"), $x - 20, $y - 20, 190, 85)
	$lblResultGoldNow = GUICtrlCreateLabel("", $x - 5, $y + 2, 60, 15, $SS_RIGHT)
	$lblResultGoldHourNow = GUICtrlCreateLabel("", $x, $y + 2, 50, 15, $SS_RIGHT)
		GUICtrlSetState(-1, $GUI_HIDE)
	$picResultGoldNow = GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x + 60, $y, 16, 16)
		GUICtrlSetState(-1, $GUI_HIDE)
	$picResultGoldTemp = GUICtrlCreateIcon ($pIconLib, $eIcnGold, $x - 5, $y, 16, 16)
	$lblResultElixirNow = GUICtrlCreateLabel("", $x - 5, $y + 22, 60, 15, $SS_RIGHT)
	$lblResultElixirHourNow = GUICtrlCreateLabel("", $x, $y + 22, 50, 15, $SS_RIGHT)
		GUICtrlSetState(-1, $GUI_HIDE)
	$picResultElixirNow = GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x + 60, $y + 20, 16, 16)
		GUICtrlSetState(-1, $GUI_HIDE)
	$picResultElixirTemp = GUICtrlCreateIcon ($pIconLib, $eIcnElixir, $x - 5, $y + 20, 16, 16)
	$lblResultDENow = GUICtrlCreateLabel("", $x, $y + 42, 55, 15, $SS_RIGHT)
	$lblResultDEHourNow = GUICtrlCreateLabel("", $x - 5, $y + 42, 55, 15, $SS_RIGHT)
		GUICtrlSetState(-1, $GUI_HIDE)
	$picResultDENow = GUICtrlCreateIcon ($pIconLib, $eIcnDark, $x + 60, $y + 40, 16, 16)
		GUICtrlSetState(-1, $GUI_HIDE)
	$picResultDETemp = GUICtrlCreateIcon ($pIconLib, $eIcnDark, $x - 5, $y + 40, 16, 16)

	$x += 80
	;trophy / runtime
	$lblResultTrophyNow = GUICtrlCreateLabel("", $x, $y + 2, 55, 15, $SS_RIGHT)
	$picResultTrophyNow = GUICtrlCreateIcon ($pIconLib, $eIcnTrophy, $x + 59, $y , 16, 16)
	$lblResultRuntimeNow = GUICtrlCreateLabel("00:00:00", $x, $y + 2, 50, 15, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	$picResultRuntimeNow = GUICtrlCreateIcon($pIconLib, $eIcnHourGlass, $x +57, $y, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	;builders/attacked
	$lblResultBuilderNow = GUICtrlCreateLabel("", $x, $y + 22, 55, 15, $SS_RIGHT)
	$picResultBuilderNow = GUICtrlCreateIcon ($pIconLib, $eIcnBuilder, $x + 59, $y + 20, 16, 16)
	$lblResultAttackedHourNow = GUICtrlCreateLabel("0", $x, $y + 22, 50, 15, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	$picResultAttackedHourNow = GUICtrlCreateIcon($pIconLib, $eIcnBldgTarget, $x +59, $y + 20, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	;gems/skipped
	$lblResultGemNow = GUICtrlCreateLabel("", $x - 5, $y + 42, 60, 15, $SS_RIGHT)
	$picResultGemNow = GUICtrlCreateIcon ($pIconLib, $eIcnGem, $x + 59, $y + 40, 16, 16)
	$lblResultSkippedHourNow = GUICtrlCreateLabel("0", $x, $y + 42, 50, 15, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	$picResultSkippedHourNow = GUICtrlCreateIcon ($pIconLib, $eIcnBldgX, $x + 59, $y + 40, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)

	$x = 290
	$lblVillageReportTemp = GUICtrlCreateLabel(GetTranslated(602,22, "Village Report") & @CRLF & GetTranslated(602,23, "will appear here") & @CRLF & GetTranslated(602,24, "on first run."), $x + 27, $y + 5, 100, 45, BITOR($SS_CENTER, $BS_MULTILINE))


 	$btnTestVillage = GUICtrlCreateButton("TEST BUTTON", $x + 25 , $y + 54, 100, 18)
 		GUICtrlSetOnEvent(-1, "ButtonBoost")
		GUICtrlSetState(-1, $GUI_HIDE)

GUICtrlCreateGroup("", -99, -99, 1, 1)

