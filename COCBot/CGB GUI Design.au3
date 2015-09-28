; #FUNCTION# ====================================================================================================================
; Name ..........: CGB GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015)
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Link ..........: www.gamebot.org
; Example .......: No
; ===============================================================================================================================

;~ ------------------------------------------------------
;~ Main GUI
;~ ------------------------------------------------------
$frmBot = GUICreate($sBotTitle, 470, 650)
	GUISetIcon($pIconLib, $eIcnGUI)
	TraySetIcon($pIconLib, $eIcnGUI)
$tabMain = GUICtrlCreateTab(5, 85, 461, 425, $TCS_MULTILINE)
	GUICtrlSetOnEvent(-1, "tabMain")
	GUICtrlCreatePic (@ScriptDir & "\Icons\logo.jpg", 0, 0, 470, 80)

;~ ------------------------------------------------------
;~ Header Menu
;~ ------------------------------------------------------


$DonateMenu = GUICtrlCreateMenu("&Paypal Donate?")
$DonateConfig = GUICtrlCreateMenuItem("Support the development", $DonateMenu)
GUICtrlSetOnEvent(-1, "")

;~ ------------------------------------------------------
;~ Tab Files
;~ ------------------------------------------------------
#include "GUI\CGB GUI Design Bottom.au3"
#include "GUI\CGB GUI Design Tab General.au3" ; includes '$FirstControlToHide" on GUI
#include "GUI\CGB GUI Design Tab Troops.au3"
#include "GUI\CGB GUI Design Tab Search.au3"
#include "GUI\CGB GUI Design Tab Attack.au3"
#include "GUI\CGB GUI Design Tab Advanced.au3"
#include "GUI\CGB GUI Design Tab EndBattle.au3"
#include "GUI\CGB GUI Design Tab Donate.au3"
#include "GUI\CGB GUI Design Tab Misc.au3"
#include "GUI\CGB GUI Design Tab Upgrade.au3"
#include "GUI\CGB GUI Design Tab Notify.au3"
#include "GUI\CGB GUI Design Tab Expert.au3"
#include "GUI\CGB GUI Design Tab Stats.au3" ; includes '$LastControlToHide" on GUI

;~ -------------------------------------------------------------
;~ About Us Tab
;~ -------------------------------------------------------------
$tabAboutUs = GUICtrlCreateTabItem("About Us")
Local $x = 30, $y = 150
	$grpCredits = GUICtrlCreateGroup("Credits", $x - 20, $y - 20, 450, 375)
		$txtCredits = "Clash Game Bot is brought to you by a worldwide team of open source"  & @CRLF & _
						"programmers and a vibrant community of forum members!"
		$lblCredits1 = GUICtrlCreateLabel($txtCredits, $x - 5, $y, 400, 50)
			GUICtrlSetFont(-1, 9, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_NAVY)
		$y += 35
		$txtCredits = "Please visit our web forums:"
		$lblCredits2 = GUICtrlCreateLabel($txtCredits, $x - 5, $y, -1, -1)
		$y += 20
		$labelGameBotURL = GUICtrlCreateLabel("https://GameBot.org", $x - 5, $y, 150, 20)
			GUICtrlSetFont(-1, 8.5, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_BLUE)
		$y += 25
		$lblCredits3 = GUICtrlCreateLabel("Credits go to the following coders for donating their time:", $x - 5, $y , 400, 20)
			GUICtrlSetFont(-1, 8.5, $FW_BOLD)
		$y += 20
		$txtCredits =	"Antidote, AtoZ, Didipe, Dinobot, DixonHill, DkEd, Envyus, GkevinOD, Hervidero,"  & @CRLF & _
                        "HungLe, kaganus, KnowJack, ProMac, Safar46, Sardo, Saviart and others"  & @CRLF & _
						"" & @CRLF & _
						"And to all forum members contributing to make this great software!" & @CRLF & _
						"" & @CRLF & _
						"The latest release of the 'Clash Game Bot' can be found at:"
		$lbltxtCredits = GUICtrlCreateEdit($txtCredits, $x - 5, $y, 400, 80, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $ES_READONLY, $SS_LEFT),0)
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		$y += 85
		$labelForumURL = GUICtrlCreateLabel("https://GameBot.org/latest", $x - 5, $y, 450, 20)
			GUICtrlSetFont(-1, 8.5, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_BLUE)
		$y += 100
		$txtWarn =	"By running this program, the user accepts all responsibility that arises from the use of this software."  & @CRLF & _
						"This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even " & @CRLF & _
						"the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General " & @CRLF & _
						"Public License for more details. The license can be found in the main code folder location."  & @CRLF & _
						"Copyright (C) 2015 GameBot.org"
		$lbltxtWarn = GUICtrlCreateEdit($txtWarn, $x - 5, $y, 410, 56, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $ES_READONLY, $SS_LEFT, $ES_CENTER),0)
			GUICtrlSetColor(-1, 0x000053)
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetFont(-1, 6, $FW_BOLD)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")

;~ -------------------------------------------------------------
;~ Bottom status bar
;~ -------------------------------------------------------------
GUISetState(@SW_SHOW)

$statLog = _GUICtrlStatusBar_Create($frmBot)
_ArrayConcatenate($G, $y)
_GUICtrlStatusBar_SetSimple($statLog)
_GUICtrlStatusBar_SetText($statLog, "Status : Idle")
$tiAbout = TrayCreateItem("About")
TrayCreateItem("")
$tiExit = TrayCreateItem("Exit")

;~ -------------------------------------------------------------
