; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "About Us" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: CodeSlinger69 (2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_ABOUT = 0
Global $g_hLblCreditsBckGrnd = 0, $g_hLblMyBotURL = 0, $g_hLblForumURL = 0

Func CreateAboutTab()
   $g_hGUI_ABOUT = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)
   GUISetBkColor($COLOR_WHITE,$g_hGUI_ABOUT)

   Local $sText = ""
   Local $x = 18, $y = 15 + $_GUI_MAIN_TOP
	 ;$g_hLblCreditsBckGrnd = GUICtrlCreateLabel("", $x - 20, $y - 20, 454, 380)  ; adds fixed white background for entire tab, if using "Labels"
	 ;GUICtrlSetBkColor(-1, $COLOR_WHITE)
	 $sText = "My Bot is brought to you by a worldwide team of open source"  & @CRLF & _
					 "programmers and a vibrant community of forum members!"
	 GUICtrlCreateLabel($sText, $x + 8, $y - 10, 400, 35, $SS_CENTER)
		 GUICtrlSetFont(-1, 10, $FW_BOLD, Default, "Arial")
		 GUICtrlSetColor(-1, $COLOR_NAVY)

	 $y += 30
	 $sText = "Please visit our web forums:"
	 GUICtrlCreateLabel($sText, $x + 44, $y, 180, 30, $SS_CENTER)
		 GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
	 $g_hLblMyBotURL = GUICtrlCreateLabel("https://mybot.run/forums", $x + 223, $y, 150, 20)
		 GUICtrlSetCursor(-1, 0)
		 GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
		 GUICtrlSetColor(-1, $COLOR_INFO)

	 $y += 22
	 GUICtrlCreateLabel("Credits belong to following programmers for donating their time:", $x - 5, $y, 420, 20)
		 GUICtrlSetFont(-1, 10, $FW_BOLD, Default, "Arial")

	 $y += 30
	 $sText = "Active developers: "
	 GUICtrlCreateLabel($sText, $x - 5, $y, 410, 20, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT),0)
		 GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
		 GUICtrlSetColor(-1, $COLOR_NAVY)
	 $sText = "Boju, Codeslinger69, Cosote, Ezeck0001, Fliegerfaust, Hervidero, IceCube, MMHK, MonkeyHunter, MR.ViPeR, ProMac, Sardo, TheRevenor, Trlopes, Zengzeng"
	 GUICtrlCreateLabel($sText, $x + 5, $y + 15, 410, 50, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT),0)
		 GUICtrlSetFont(-1,9, $FW_MEDIUM, Default, "Arial")

	 $y += 75
	 $sText =	"Inactive developers: "
	 GUICtrlCreateLabel($sText, $x - 5, $y, 410, 20, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
		 GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
		 GUICtrlSetColor(-1, $COLOR_NAVY)
	 $sText = "Kaganus"
	 GUICtrlCreateLabel($sText, $x + 5, $y + 15, 410, 20, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
		 GUICtrlSetFont(-1, 9, $FW_MEDIUM, Default, "Arial")
	 $y += 45

	 $sText =	"Retired developers: "
	 GUICtrlCreateLabel($sText, $x - 5, $y, 410, 20, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
		 GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
		 GUICtrlSetColor(-1, $COLOR_NAVY)
	 $sText = "Antidote, AtoZ, Barracoda, Didipe, Dinobot, DixonHill, DkEd, GkevinOD, HungLe, KnowJack, LunaEclipse, Safar46, Saviart, TheMaster1st, and others"
	 GUICtrlCreateLabel($sText, $x + 5, $y + 15, 410, 50, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
		 GUICtrlSetFont(-1, 9, $FW_MEDIUM, Default, "Arial")

	 $y += 76
	 $sText = "Special thanks to all contributing forum members helping to make this" & @CRLF & "software better! And a special note to: @KevinM our server admin!"
	 GUICtrlCreateLabel($sText, $x + 14, $y, 390, 30, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $ES_CENTER), 0)
		 GUICtrlSetFont(-1, 9, $FW_MEDIUM, Default, "Arial")

	 $y += 40
	 $sText =	"The latest release of 'My Bot' can be found at:"
	 GUICtrlCreateLabel($sText, $x - 5, $y, 400, 15, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
		 GUICtrlSetFont(-1, 10, $FW_BOLD, Default, "Arial")

	 $y += 18
	 $g_hLblForumURL = GUICtrlCreateLabel("https://mybot.run/forums/index.php?/forum/4-official-releases/", $x + 25, $y, 450, 20)
		 GUICtrlSetCursor(-1, 0)
		 GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
		 GUICtrlSetColor(-1, $COLOR_INFO)

	 $y = 380
	 $sText =	"By running this program, the user accepts all responsibility that arises from the use of this software."  & @CRLF & _
			   "This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even " & @CRLF & _
			   "the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General " & @CRLF & _
			   "Public License for more details. The license can be found in the main code folder location."  & @CRLF & _
			   "Copyright (C) 2015-2017 MyBot.run"
	 GUICtrlCreateLabel($sText, $x + 1, $y, 415, 56, BITOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT, $ES_CENTER), 0)
		 GUICtrlSetColor(-1, 0x000053)
		 GUICtrlSetFont(-1, 6.5, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
EndFunc
