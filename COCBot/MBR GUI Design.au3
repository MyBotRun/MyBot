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

Global Const $TCM_SETITEM = 0x1306

Global Const $_GUI_MAIN_WIDTH = 470
Global Const $_GUI_MAIN_HEIGHT = 650
Global Const $_GUI_CHILD_LEFT = 10
Global Const $_GUI_CHILD_TOP = 110

Global $hImageList = 0

;~ ------------------------------------------------------
;~ Main GUI
;~ ------------------------------------------------------

$frmBot = GUICreate($sBotTitle, $_GUI_MAIN_WIDTH, $_GUI_MAIN_HEIGHT)
; group multiple bot windows using _WindowAppId
_WindowAppId($frmBot, "MyBot.run")
GUISetIcon($pIconLib, $eIcnGUI)
TraySetIcon($pIconLib, $eIcnGUI)
TraySetToolTip($sBotTitle)
$frmBot_MAIN_PIC = GUICtrlCreatePic(@ScriptDir & "\Images\logo.jpg", 0, 0, $_GUI_MAIN_WIDTH, 80)
$hToolTip = _GUIToolTip_Create($frmBot) ; tool tips for URL links etc

;~ ------------------------------------------------------
;~ Header Menu
;~ ------------------------------------------------------

$idMENU_DONATE = GUICtrlCreateMenu("&" & GetTranslated(601,18,"Paypal Donate?"))
$idMENU_DONATE_SUPPORT = GUICtrlCreateMenuItem(GetTranslated(601,19,"Support the development"), $idMENU_DONATE)
GUICtrlSetOnEvent(-1, "")
;$idMENU_OPTIONS = GUICtrlCreateMenu("&Options")
;GUICtrlSetOnEvent(-1, "")
;$idMENU_ABOUT = GUICtrlCreateMenu("&About Us")
;GUICtrlSetOnEvent(-1, "")

;~ ------------------------------------------------------
;~ GUI Bottom
;~ ------------------------------------------------------
#include "GUI\MBR GUI Design Bottom.au3"


;~ ------------------------------------------------------
;~ GUI Child Files
;~ ------------------------------------------------------
#include "GUI\MBR GUI Design Child General.au3" ; includes '$FirstControlToHide" on GUI
#include "GUI\MBR GUI Design Child Village.au3"
#include "GUI\MBR GUI Design Child Attack.au3"
#include "GUI\MBR GUI Design Child Bot.au3"
;GUISetState()
GUISwitch($frmBot)
$tabMain = GUICtrlCreateTab(5, 85, $_GUI_MAIN_WIDTH - 9, $_GUI_MAIN_HEIGHT - 225); , $TCS_MULTILINE)
$tabGeneral = GUICtrlCreateTabItem(GetTranslated(600,1, "Log"))
$tabVillage = GUICtrlCreateTabItem(GetTranslated(600,2, "Village")) ; Village
$tabAttack = GUICtrlCreateTabItem(GetTranslated(600,3,"Attack Plan"))
$tabBot = GUICtrlCreateTabItem(GetTranslated(600,4,"Bot"))

;~ -------------------------------------------------------------
;~ About Us Tab
;~ -------------------------------------------------------------
$tabAboutUs = GUICtrlCreateTabItem(GetTranslated(600,5, "About Us"))
Local $x = 30, $y = 150
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
		$y += 25
		$txtCredits =	"Active developers: "  &  @CRLF & _
						"Boju, Cosote, Hervidero, Kaganus, LunaEclipse, MonkeyHunter, ProMac, Sardo, Trlopes, Zengzeng" & @CRLF & @CRLF & _
                        "Retired developers: "  &  @CRLF & _
						"Antidote, AtoZ, Barracoda, Didipe, Dinobot, DixonHill, DkEd, GkevinOD, HungLe, Knowjack, Safar46, Saviart, TheMaster1st, and others"
		$lbltxtCredits1 = GUICtrlCreateLabel($txtCredits, $x+5, $y, 410,110, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT),0)
			GUICtrlSetFont(-1,9, $FW_MEDIUM)
;			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$y += 110
		$txtCredits = "Special thanks to all contributing forum members helping " & @CRLF & "to make this software better! "
		$lbltxtCredits2 = GUICtrlCreateLabel($txtCredits, $x+5, $y, 390,30, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $ES_CENTER),0)
			GUICtrlSetFont(-1,9, $FW_MEDIUM)
		$y += 45
		$txtCredits =	"The latest release of 'My Bot' can be found at:"
		$lbltxtNewVer = GUICtrlCreateLabel($txtCredits, $x - 5, $y, 400,15, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT),0)
			GUICtrlSetFont(-1, 10, $FW_BOLD)
;			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$y += 20
		$labelForumURL = GUICtrlCreateLabel("https://mybot.run/forums/index.php?/forum/4-official-releases/", $x+25, $y, 450, 20)
			GUICtrlSetFont(-1, 9.5, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_BLUE)
		$y = 440
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
;~ Bottom status bar
;~ -------------------------------------------------------------
GUISetState(@SW_SHOW)
$frmBotMinimized = False

$statLog = _GUICtrlStatusBar_Create($frmBot)
_ArrayConcatenate($G, $y)
_GUICtrlStatusBar_SetSimple($statLog)
_GUICtrlStatusBar_SetText($statLog, "Status : Idle")
$tiAbout = TrayCreateItem("About")
TrayCreateItem("")
$tiExit = TrayCreateItem("Exit")

; Create profile if specified by command line parameter does not exist
If $sCurrProfile <> "<No Profiles>" And Not FileExists($sProfilePath & "\" & $sCurrProfile) Then
	createProfile()
	setupProfileComboBox()
	selectProfile()
ElseIf $sCurrProfile = "<No Profiles>" Then ; Create profile if there are no profiles
	setupProfile()
	setupProfileComboBox()
	selectProfile()
EndIf
;~ -------------------------------------------------------------
