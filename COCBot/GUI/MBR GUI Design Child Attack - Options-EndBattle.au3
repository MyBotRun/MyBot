; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "End Battle" tab under the "Options" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hChkShareAttack = 0, $g_hLblShareMinLoot = 0, $g_hTxtShareMinGold = 0, $g_hTxtShareMinElixir = 0, $g_hTxtShareMinDark = 0, $g_hTxtShareMessage = 0, _
	   $g_hChkTakeLootSS = 0, $g_hChkScreenshotLootInfo = 0

Global $g_hLblShareMinGold = 0, $g_hLblShareMinElixir = 0,  $g_hLblShareMinDark = 0

Func CreateAttackSearchOptionsEndBattle()
   Local $x = 20, $y = 45

	   GUICtrlCreateGroup(GetTranslated(633,1,"Share Replay"), $x-15, $y-20, 420, 204)
		   $g_hChkShareAttack = GUICtrlCreateCheckbox(GetTranslated(633,2, "Share Replays in your clan's chat."), $x, $y-7, -1, -1)
			   _GUICtrlSetTip(-1, GetTranslated(633,3, "Check this to share your battle replay in the clan chat."))
			   GUICtrlSetOnEvent(-1, "chkShareAttack")

	   $x -= 15
	   $y -= 2
		   $y -=5
		   $y += 25
		   $g_hLblShareMinLoot = GUICtrlCreateLabel(GetTranslated(633,4, "When Loot Gained") & ":", $x + 20 , $y, -1, -1)
			   GUICtrlSetState(-1, $GUI_DISABLE)
		   $g_hLblShareMinGold = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
			   GUICtrlSetState(-1, $GUI_DISABLE)
		   $g_hTxtShareMinGold = GUICtrlCreateInput("300000", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   _GUICtrlSetTip(-1, GetTranslated(633,5, "Only Share Replay when the battle loot is more than this amount of Gold."))
			   GUICtrlSetLimit(-1, 6)
			   GUICtrlSetState(-1, $GUI_DISABLE)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 182, $y, 16, 16)

		   $y += 22
		   $g_hLblShareMinElixir = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
		       GUICtrlSetState(-1, $GUI_DISABLE)
		   $g_hTxtShareMinElixir = GUICtrlCreateInput("300000", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   _GUICtrlSetTip(-1, GetTranslated(633,6, "Only Share Replay when the battle loot is more than this amount of Elixir."))
			   GUICtrlSetState(-1, $GUI_DISABLE)
			   GUICtrlSetLimit(-1, 6)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 182, $y, 16, 16)

		   $y += 22
		   $g_hLblShareMinDark = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
			   GUICtrlSetState(-1, $GUI_DISABLE)
		   $g_hTxtShareMinDark = GUICtrlCreateInput("0", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			   _GUICtrlSetTip(-1, GetTranslated(633,7, "Only Share Replay when the battle loot is more than this amount of Dark Elixir."))
			   GUICtrlSetState(-1, $GUI_DISABLE)
			   GUICtrlSetLimit(-1, 5)
		   GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 182, $y, 16, 16)

		   $y += 25
		   $x += 5
		   GUICtrlCreateLabel(GetTranslated(633,8, "Use a random message from this list") &":", $x , $y -2 , -1, -1)
				GUICtrlSetState(-1, $GUI_DISABLE)

		   $y += 27
		   $g_hTxtShareMessage = GUICtrlCreateEdit("", $x, $y - 10 , 205, 72, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			   GUICtrlSetData(-1, StringFormat(GetTranslated(633,9, "Nice\r\nGood\r\nThanks \r\nWowwww")))
			   _GUICtrlSetTip(-1, GetTranslated(633,10, "Message to send with the Share Replay"))
			   GUICtrlSetState(-1, $GUI_DISABLE)

	   $x = 20
	   $y+=100
	   GUICtrlCreateGroup(GetTranslated(633,11,"Take Loot Snapshot"), $x-15, $y-20, 420, 67)
		   $g_hChkTakeLootSS = GUICtrlCreateCheckbox(GetTranslated(633,11, -1), $x, $y, -1, -1)
			   _GUICtrlSetTip(-1, GetTranslated(633,12, "Check this if you want to save a Loot snapshot of the Village that was attacked."))
			   GUICtrlSetState(-1, $GUI_UNCHECKED)
			   GUICtrlSetOnEvent(-1, "chkTakeLootSS")

		 $y += 18
		   $g_hChkScreenshotLootInfo = GUICtrlCreateCheckbox(GetTranslated(633,13, "Include loot info in filename"), $x  , $y , -1, -1)
			   _GUICtrlSetTip(-1, GetTranslated(633,14, "Include loot info in the screenshot filename"))
			   GUICtrlSetState(-1,$GUI_DISABLE)

EndFunc
