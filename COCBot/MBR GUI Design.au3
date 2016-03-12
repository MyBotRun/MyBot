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
;~ Main GUI
;~ ------------------------------------------------------
$frmBot = GUICreate($sBotTitle, 470, 650)
	GUISetIcon($pIconLib, $eIcnGUI)
	TraySetIcon($pIconLib, $eIcnGUI)
$tabMain = GUICtrlCreateTab(5, 85, 461, 425, $TCS_MULTILINE)
	;GUICtrlSetOnEvent(-1, "tabMain") ; moved to Func GUIControl()
	GUICtrlCreatePic (@ScriptDir & "\Images\logo.jpg", 0, 0, 470, 80)

;~ ------------------------------------------------------
;~ Header Menu
;~ ------------------------------------------------------

$DonateMenu = GUICtrlCreateMenu("&Paypal Donate?")
$DonateConfig = GUICtrlCreateMenuItem("Support the development", $DonateMenu)
GUICtrlSetOnEvent(-1, "")

;~ ------------------------------------------------------
;~ Tab Files
;~ ------------------------------------------------------
#include "GUI\MBR GUI Design Bottom.au3"
#include "GUI\MBR GUI Design Tab General.au3" ; includes '$FirstControlToHide" on GUI
#include "GUI\MBR GUI Design Tab Troops.au3"
#include "GUI\MBR GUI Design Tab Search.au3"
#include "GUI\MBR GUI Design Tab Attack.au3"
#include "GUI\MBR GUI Design Tab AttackCSV.au3"
#include "GUI\MBR GUI Design Tab Advanced.au3"
#include "GUI\MBR GUI Design Tab EndBattle.au3"
#include "GUI\MBR GUI Design Tab Donate.au3"
#include "GUI\MBR GUI Design Tab Misc.au3"
#include "GUI\MBR GUI Design Tab Upgrade.au3"
#include "GUI\MBR GUI Design Tab Notify.au3"
#include "GUI\MBR GUI Design Tab Expert.au3"
#include "GUI\MBR GUI Design Tab Stats.au3" ; includes '$LastControlToHide" on GUI
#include "GUI\MBR GUI Design Collectors.au3"
#include "GUI\MBR GUI Design Milking.au3"
;~ -------------------------------------------------------------
;~ About Us Tab
;~ -------------------------------------------------------------
$tabAboutUs = GUICtrlCreateTabItem(GetTranslated(12,1, "About Us"))
Local $x = 30, $y = 150
	$grpCredits = GUICtrlCreateGroup("Credits", $x - 20, $y - 20, 450, 375)
		$lblBckGrnd = GUICtrlCreateLabel("", $x - 20, $y - 20, 450, 375)  ; adds fixed white background for entire tab, if using "Labels"
		GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$txtCredits = "My Bot is brought to you by a worldwide team of open source"  & @CRLF & _
						"programmers and a vibrant community of forum members!"
		$lblCredits1 = GUICtrlCreateLabel($txtCredits, $x - 5, $y - 5, 400, 30)
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
						"Cosote, Hervidero, Kaganus, MonkeyHunter, ProMac, Sardo, Zengzeng"  &  @CRLF & @CRLF & _
                        "Developers no longer active: "  &  @CRLF & _
						"Antidote, AtoZ, Barracoda, Didipe, Dinobot, DixonHill, DkEd, GkevinOD, HungLe, Knowjack, Safar46, Saviart, TheMaster1st, and others"
		$lbltxtCredits1 = GUICtrlCreateLabel($txtCredits, $x+5, $y, 410,95, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT),0)
			GUICtrlSetFont(-1,9, $FW_MEDIUM)
;			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$y += 100
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
