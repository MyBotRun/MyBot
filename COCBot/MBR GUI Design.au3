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

#include "Functions\other\AppUserModelId.au3"
#include "Functions\GUI\_GUICtrlSetTip.au3"

Global Const $TCM_SETITEM = 0x1306

Global Const $_GUI_MAIN_WIDTH = 470
Global Const $_GUI_MAIN_HEIGHT = 650
Global Const $_GUI_MAIN_TOP = 5
Global Const $_GUI_BOTTOM_HEIGHT = 135
Global Const $_GUI_CHILD_LEFT = 10
Global Const $_GUI_CHILD_TOP = 110 + $_GUI_MAIN_TOP

Global $hImageList = 0

;~ ------------------------------------------------------
;~ Main GUI
;~ ------------------------------------------------------
SplashStep(GetTranslated(500, 23, "Loading Main GUI..."))
$frmBot = GUICreate($sBotTitle, $_GUI_MAIN_WIDTH, $_GUI_MAIN_HEIGHT + $_GUI_MAIN_TOP, $frmBotPosX, $frmBotPosY, BitOr($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS))
; group multiple bot windows using _WindowAppId
_WindowAppId($frmBot, "MyBot.run")
GUISetIcon($pIconLib, $eIcnGUI)
TraySetIcon($pIconLib, $eIcnGUI)
TraySetToolTip($sBotTitle)

; Need $frmBotEx for embedding Android
$frmBotEx = GUICreate("", $_GUI_MAIN_WIDTH, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP, 0, 0, BitOR($WS_CHILD, $WS_TABSTOP), $WS_EX_TOPMOST, $frmBot)
GUICtrlCreateLabel("", 0, 0, $_GUI_MAIN_WIDTH, 5)
GUICtrlSetBkColor(-1, $COLOR_WHITE)
$frmBot_MAIN_PIC = GUICtrlCreatePic(@ScriptDir & "\Images\logo.jpg", 0, $_GUI_MAIN_TOP, $_GUI_MAIN_WIDTH, 80)
$hToolTip = _GUIToolTip_Create($frmBot) ; tool tips for URL links etc
_GUIToolTip_SetMaxTipWidth($hToolTip, $_GUI_MAIN_WIDTH) ; support multiple lines

GUISwitch($frmBot)

$frmBotBottom = GUICreate("", $_GUI_MAIN_WIDTH, $_GUI_BOTTOM_HEIGHT, 0, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP, BitOR($WS_CHILD, $WS_TABSTOP), $WS_EX_TOPMOST, $frmBot)
$frmBotBottomCtrlState = 0
;$frmBotEmbeddedRecorder = GUICreate("", 32, 32, 0, 0, $WS_CHILD, -1, $frmBot) ; Android Recorder of mouse clicks and moves
$frmBotEmbeddedShield = GUICreate("", 32, 32, 0, 0, BitOR($WS_CHILD, $WS_TABSTOP), BitOR($WS_EX_TOPMOST, ($AndroidShieldPreWin8 ? $WS_EX_TRANSPARENT : 0)), $frmBot) ; Android Shield for mouse
$frmBotEmbeddedGarphics = GUICreate("", 32, 32, 0, 0, $WS_CHILD, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST), $frmBot)
GUISwitch($frmBotEmbeddedShield)
$frmBotEmbeddedShieldInput = GUICtrlCreateInput("", 0, 0, -1, -1, $WS_TABSTOP)
GUICtrlSetState($frmBotEmbeddedShieldInput, $GUI_HIDE)

;~ ------------------------------------------------------
;~ Header Menu
;~ ------------------------------------------------------

GUISwitch($frmBot)
;$idMENU_DONATE = GUICtrlCreateMenu("&" & GetTranslated(601,18,"Paypal Donate?"))
;_GUICtrlMenu_SetItemType(_GUICtrlMenu_GetMenu($frmBot), 0, $MFT_RIGHTJUSTIFY) ; move to right
;$idMENU_DONATE_SUPPORT = GUICtrlCreateMenuItem(GetTranslated(601,19,"Support the development"), $idMENU_DONATE)
;GUICtrlSetOnEvent(-1, "")

;~ ------------------------------------------------------
;~ GUI Bottom
;~ ------------------------------------------------------
SplashStep(GetTranslated(500, 24, "Loading GUI Bottom..."))
GUISwitch($frmBotBottom)
#include "GUI\MBR GUI Design Bottom.au3"
GUISwitch($frmBotEx)

;~ ------------------------------------------------------
;~ GUI Child Files
;~ ------------------------------------------------------
SplashStep(GetTranslated(500, 25, "Loading General tab..."))
#include "GUI\MBR GUI Design Child General.au3" ; includes '$FirstControlToHide" on GUI
SplashStep(GetTranslated(500, 26, "Loading Village tab..."))
#include "GUI\MBR GUI Design Child Village.au3"
SplashStep(GetTranslated(500, 27, "Loading Attack tab..."))
#include "GUI\MBR GUI Design Child Attack.au3"
SplashStep(GetTranslated(500, 28, "Loading Bot tab..."))
#include "GUI\MBR GUI Design Child Bot.au3"
;GUISetState()
GUISwitch($frmBotEx)
$tabMain = GUICtrlCreateTab(5, 85 + $_GUI_MAIN_TOP, $_GUI_MAIN_WIDTH - 9, $_GUI_MAIN_HEIGHT - 225); , $TCS_MULTILINE)
GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
$tabGeneral = GUICtrlCreateTabItem(GetTranslated(600,1, "Log"))
$tabVillage = GUICtrlCreateTabItem(GetTranslated(600,2, "Village")) ; Village
$tabAttack = GUICtrlCreateTabItem(GetTranslated(600,3,"Attack Plan"))
$tabBot = GUICtrlCreateTabItem(GetTranslated(600,4,"Bot"))

;~ -------------------------------------------------------------
;~ About Us Tab
;~ -------------------------------------------------------------
SplashStep(GetTranslated(500, 29, "Loading About Us tab..."))
$tabAboutUs = GUICtrlCreateTabItem(GetTranslated(600,5, "About Us"))
Local $x = 30, $y = 150 + $_GUI_MAIN_TOP
	$grpCredits = GUICtrlCreateGroup("Credits", $x - 20, $y - 20, 450, 375)
		$lblCreditsBckGrnd = GUICtrlCreateLabel("", $x - 20, $y - 20, 450, 375)  ; adds fixed white background for entire tab, if using "Labels"
		GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$txtCredits = "My Bot is brought to you by a worldwide team of open source"  & @CRLF & _
						"programmers and a vibrant community of forum members!"
		$lblCredits1 = GUICtrlCreateLabel($txtCredits, $x - 5, $y - 5, 400, 35)
			GUICtrlSetFont(-1, 10, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_NAVY)
		$y += 38
		$txtCredits = "Please visit our web forums:"
		$lblCredits2 = GUICtrlCreateLabel($txtCredits, $x+20, $y, 180, 30)
			GUICtrlSetFont(-1, 9.5, $FW_BOLD)
		$labelMyBotURL = GUICtrlCreateLabel("https://mybot.run/forums", $x + 198, $y, 150, 20)
			GUICtrlSetFont(-1, 9.5, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_BLUE)
		$y += 27
		$lblCredits3 = GUICtrlCreateLabel("Credits belong to following programmers for donating their time:", $x - 5, $y , 420, 20)
			GUICtrlSetFont(-1,10, $FW_BOLD)
		$y += 20
		$txtCredits =	"Active developers: "  &  @CRLF & _
						"Boju, Cosote, Hervidero, Kaganus, MonkeyHunter, Sardo, Trlopes, Zengzeng" & @CRLF & @CRLF & _
                        "Retired developers: "  &  @CRLF & _
						"Antidote, AtoZ, Barracoda, Didipe, Dinobot, DixonHill, DkEd, GkevinOD, HungLe, Knowjack, LunaEclipse, ProMac, Safar46, Saviart, TheMaster1st, and others"
		$lbltxtCredits1 = GUICtrlCreateLabel($txtCredits, $x+5, $y, 410,120, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT),0)
			GUICtrlSetFont(-1,9, $FW_MEDIUM)
;			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$y += 125
		$txtCredits = "Special thanks to all contributing forum members helping " & @CRLF & "to make this software better! "
		$lbltxtCredits2 = GUICtrlCreateLabel($txtCredits, $x+5, $y, 390,30, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $ES_CENTER),0)
			GUICtrlSetFont(-1,9, $FW_MEDIUM)
		$y += 44
		$txtCredits =	"The latest release of 'My Bot' can be found at:"
		$lbltxtNewVer = GUICtrlCreateLabel($txtCredits, $x - 5, $y, 400,15, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT),0)
			GUICtrlSetFont(-1, 10, $FW_BOLD)
;			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$y += 18
		$labelForumURL = GUICtrlCreateLabel("https://mybot.run/forums/index.php?/forum/4-official-releases/", $x+25, $y, 450, 20)
			GUICtrlSetFont(-1, 9.5, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_BLUE)
		$y = 445
		$txtWarn =	"By running this program, the user accepts all responsibility that arises from the use of this software."  & @CRLF & _
						"This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even " & @CRLF & _
						"the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General " & @CRLF & _
						"Public License for more details. The license can be found in the main code folder location."  & @CRLF & _
						"Copyright (C) 2015-2016 MyBot.run"
		$lbltxtWarn1 = GUICtrlCreateLabel($txtWarn, $x - 5, $y, 410, 56, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT, $ES_CENTER),0)
			GUICtrlSetColor(-1, 0x000053)
;			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetFont(-1, 6, $FW_BOLD)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")

;~ -------------------------------------------------------------
;~ GUI init
;~ -------------------------------------------------------------

SplashStep(GetTranslated(500, 30, "Initializing GUI..."))
#Region ; Bind Icon images to all Tabs in all GUI windows (main and children)
Bind_ImageList($tabMain)
Bind_ImageList($hGUI_VILLAGE_TAB)
Bind_ImageList($hGUI_ARMY_TAB)
Bind_ImageList($hGUI_DONATE_TAB)
Bind_ImageList($hGUI_UPGRADE_TAB)
Bind_ImageList($hGUI_NOTIFY_TAB)
Bind_ImageList($hGUI_ATTACK_TAB)
Bind_ImageList($hGUI_SEARCH_TAB)
Bind_ImageList($hGUI_DEADBASE_TAB)
Bind_ImageList($hGUI_ACTIVEBASE_TAB)
Bind_ImageList($hGUI_AttackOption_TAB)
Bind_ImageList($hGUI_THSNIPE_TAB)
Bind_ImageList($hGUI_BOT_TAB)
Bind_ImageList($hGUI_STRATEGIES_TAB)
Bind_ImageList($hGUI_STATS_TAB)
#EndRegion ; Bind Icon images to all Tabs in all GUI windows (main and children)

#Region ; Show GUI and activate Tab LOG
GUICtrlSetState($hGUI_LOG, $GUI_SHOW)
#EndRegion ; Show GUI and activate Tab LOG

;~ -------------------------------------------------------------
;~ Show bot
;~ -------------------------------------------------------------

cmbLog()

If IsHWnd($hSplash) Then GUIDelete($hSplash) ; Delete the splash screen since we don't need it anymore
If Not $NoFocusTampering Then
	; normal
	GUISetState(@SW_SHOW, $frmBot)
Else
	GUISetState(@SW_SHOW, $frmBot)
	;GUISetState(@SW_SHOWNOACTIVATE, $frmBot)
	;Local $lCurExStyle = _WinAPI_GetWindowLong($frmBot, $GWL_EXSTYLE)
	;_WinAPI_SetWindowLong($HWnd, $GWL_EXSTYLE, BitOR($lCurExStyle, $WS_EX_TOPMOST))
	;_WinAPI_SetWindowLong($HWnd, $GWL_EXSTYLE, $lCurExStyle)
EndIf

GUISetState(@SW_SHOWNOACTIVATE, $frmBotEx)
GUISetState(@SW_SHOWNOACTIVATE, $frmBotBottom)
GUISwitch($frmBotEx)
$frmBotMinimized = False

$frmBotPosInit = WinGetPos($frmBot)
ReDim $frmBotPosInit[7]
$frmBotPosInit[4] = _WinAPI_GetClientWidth($frmBot)
$frmBotPosInit[5] = _WinAPI_GetClientHeight($frmBot)
$frmBotPosInit[6] = ControlGetPos($frmBot, "", $frmBotEx)[3]

;~ -------------------------------------------------------------
;~ Bottom status bar
;~ -------------------------------------------------------------

$statLog = _GUICtrlStatusBar_Create($frmBotBottom)
_ArrayConcatenate($G, $y)
_GUICtrlStatusBar_SetSimple($statLog)
_GUICtrlStatusBar_SetText($statLog, "Status : Idle")
$tiShow = TrayCreateItem(GetTranslated(500,31,"Show bot"))
TrayItemSetOnEvent($tiShow, "tiShow")
$tiHide = TrayCreateItem(GetTranslated(500,32, "Hide when minimized"))
TrayItemSetOnEvent($tiHide, "tiHide")
TrayCreateItem("")
$tiDonate = TrayCreateItem(GetTranslated(500,33, "Support Development"))
TrayItemSetOnEvent($tiDonate, "tiDonate")
$tiAbout = TrayCreateItem(GetTranslated(500,34, "About"))
TrayItemSetOnEvent($tiAbout, "tiAbout")
TrayCreateItem("")
$tiExit = TrayCreateItem(GetTranslated(500,35, "Exit"))
TrayItemSetOnEvent($tiExit, "tiExit")

;~ -------------------------------------------------------------
