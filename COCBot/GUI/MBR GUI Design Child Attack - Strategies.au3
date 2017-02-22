; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Strategies" tab under the "Attack Plan" tab
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

Global $g_hGUI_STRATEGIES = 0
Global $g_hGUI_STRATEGIES_TAB = 0, $g_hGUI_STRATEGIES_TAB_ITEM1 = 0, $g_hGUI_STRATEGIES_TAB_ITEM2 = 0

Global $g_hCmbPresetList = 0, $g_hTxtPresetMessage = 0, $g_hLblLoadPresetMessage = 0, $g_hBtnGUIPresetLoadConf = 0, $g_hChkDeleteConf = 0, $g_hBtnGUIPresetDeleteConf = 0, _
	   $g_hBtnStrategyFolder = 0, $g_hTxtPresetSaveFilename = 0, $g_hTxtSavePresetMessage = 0, $g_hBtnGUIPresetSaveConf = 0

Func CreateAttackStrategies()

   $g_hGUI_STRATEGIES = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_ATTACK)
   ;GUISetBkColor($COLOR_WHITE, $g_hGUI_STRATEGIES)

   GUISwitch($g_hGUI_STRATEGIES)

   Local $xStart = 5, $yStart = 25
   $g_hGUI_STRATEGIES_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
   $g_hGUI_STRATEGIES_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,33,"Load Strategy"))
		 Local $x = $xStart, $y = $yStart

		 $g_hCmbPresetList = GUICtrlCreateCombo("",$x,$y,200,300,$WS_VSCROLL)
		 GUICtrlSetOnEvent(-1, "PresetLoadConfigInfo")
		 $x +=205
		 $g_hTxtPresetMessage = GUICtrlCreateEdit("", $x, $y , 225, 250, BitOR($ES_WANTRETURN, $ES_AUTOVSCROLL))
		 GuiCtrlSetState(-1, $GUI_HIDE)

		 Local $loadmessage = GetTranslated(627,1,"LOAD PRECONFIGURED SETTINGS.\n\n- Load ALL Train Army Tab Settings\n- Load ALL Search && Attack Tab Settings\n\n- EXCEPT: Share Replay Settings\n- EXCEPT: Take Loot Snapshot Settings\n- EXCEPT: Gem Boost Settings")
		 $g_hLblLoadPresetMessage = GUICtrlCreateLabel(StringReplace($loadmessage, "\n", @crlf ) ,$x+15, $y+25,400)
		 $x +=5
		 $y +=255
		 $g_hBtnGUIPresetLoadConf = GUICtrlCreateButton(GetTranslated(627,2,"Load Configuration"), $x , $y, 130, 20)
		 GUICtrlSetOnEvent(-1, "PresetLoadConf")
		 GuiCtrlSetState(-1, $GUI_HIDE)
		 $x +=145
		 $g_hChkDeleteConf = GUICtrlCreateCheckbox("", $x, $y + 2, 15, 15)
		 GUICtrlSetOnEvent(-1, "chkCheckDeleteConf")
		 GuiCtrlSetState(-1, $GUI_HIDE)
		 $g_hBtnGUIPresetDeleteConf = GUICtrlCreateButton(GetTranslated(627,3,"Delete"), $x + 15 , $y, 60, 20)
		 GUICtrlSetOnEvent(-1, "PresetDeleteConf")
		 GuiCtrlSetState(-1, $GUI_HIDE+$gui_DISABLE)


   $g_hBtnStrategyFolder = GUICtrlCreateButton(GetTranslated(627,4, "Open Strategy folder"),$xStart + 40 , $y+ 40 , 120, 30)
		 GUICtrlSetOnEvent(-1, "btnStrategyFolder")



   $g_hGUI_STRATEGIES_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,34,"Save Strategy"))
		 $x = $xStart
		 $y = $yStart
		 GUICtrlCreateLabel(GetTranslated(628,1,"Strategy file name") & ":" ,$x,$y+4,200,25, $SS_RIGHT)

		 $x += 205
		 $g_hTxtPresetSaveFilename = GUICtrlCreateInput("strategy " &  @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & "." & @MIN & "." & @SEC,$x,$y,200,25)

		 $x = $xStart
		 $y +=30
		 GUICtrlCreateLabel(GetTranslated(628,2,"Notes") & ":" ,$x,$y+4,200,25,  $SS_RIGHT)
		 Local $savemessage = GetTranslated(628,3,"SAVE SETTINGS\n--------------------------------------\nSave ALL:\n- Train Army Tab Settings\n- Search && Attack Tab Settings\n\nExcept:\n- Share Replay Settings\n- Take Loot Snapshot Settings\n- Gem Boost Settings\n--------------------------------------")
		 GUICtrlCreateLabel(StringReplace($savemessage, "\n", @crlf ) ,$x+15, $y+4+25,280)

		 $x +=205
		 $g_hTxtSavePresetMessage = GUICtrlCreateEdit("", $x, $y , 223, 230, BitOR($ES_WANTRETURN, $ES_AUTOVSCROLL))
		 $y += 235
		 $g_hBtnGUIPresetSaveConf = GUICtrlCreateButton(GetTranslated(628,4,"Save Configuration"), $x+13 , $y, 200, 20)
		 GUICtrlSetOnEvent(-1, "PresetSaveConf")

   GUICtrlCreateTabItem("")
   ;GUISetState()
EndFunc
