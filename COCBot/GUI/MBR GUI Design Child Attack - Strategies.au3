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

Global $txtPresetSaveFilename, $txtSavePresetMessage, $lblLoadPresetMessage,$btnGUIPresetDeleteConf, $chkCheckDeleteConf
Global $cmbPresetList, $txtPresetMessage,$btnGUIPresetLoadConf,  $lblLoadPresetMessage,$btnGUIPresetDeleteConf, $chkCheckDeleteConf

$hGUI_STRATEGIES = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_ATTACK)
;GUISetBkColor($COLOR_WHITE, $hGUI_STRATEGIES)

GUISwitch($hGUI_STRATEGIES)

Local $xStart = 5, $yStart = 25
$hGUI_STRATEGIES_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
$hGUI_STRATEGIES_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslated(600,33,"Load Strategy"))
	  $x = $xStart
	  $y = $yStart

	  $cmbPresetList = GUICtrlCreateCombo("",$x,$y,200,300,$WS_VSCROLL)
	  GUICtrlSetOnEvent(-1, "PresetLoadConfigInfo")
	  $x +=205
	  $txtPresetMessage = GUICtrlCreateEdit("", $x, $y , 225, 250, BitOR($ES_WANTRETURN, $ES_AUTOVSCROLL))
	  GuiCtrlSetState(-1, $GUI_HIDE)

      Local $loadmessage = GetTranslated(627,1,"LOAD PRECONFIGURED SETTINGS.\n\n- Load ALL Train Army Tab Settings\n- Load ALL Search && Attack Tab Settings\n\n- EXCEPT: Share Replay Settings\n- EXCEPT: Take Loot Snapshot Settings\n- EXCEPT: Gem Boost Settings")
	  $lblLoadPresetMessage = GUICtrlCreateLabel(StringReplace($loadmessage, "\n", @crlf ) ,$x+15, $y+25,400)
	  $x +=5
	  $y +=255
  	  $btnGUIPresetLoadConf = GUICtrlCreateButton(GetTranslated(627,2,"Load Configuration"), $x , $y, 130, 20)
	  GUICtrlSetOnEvent(-1, "PresetLoadConf")
	  GuiCtrlSetState(-1, $GUI_HIDE)
	  $x +=145
	  $chkCheckDeleteConf = GUICtrlCreateCheckbox("", $x, $y + 2, 15, 15)
	  GUICtrlSetOnEvent(-1, "chkCheckDeleteConf")
	  GuiCtrlSetState(-1, $GUI_HIDE)
  	  $btnGUIPresetDeleteConf = GUICtrlCreateButton(GetTranslated(627,3,"Delete"), $x + 15 , $y, 60, 20)
	  GUICtrlSetOnEvent(-1, "PresetDeleteConf")
	  GuiCtrlSetState(-1, $GUI_HIDE+$gui_DISABLE)


$btnStrategyFolder = GUICtrlCreateButton(GetTranslated(627,4, "Open Strategy folder"),$xStart + 40 , $y+ 40 , 120, 30)
	  GUICtrlSetOnEvent(-1, "btnStrategyFolder")



$hGUI_STRATEGIES_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,34,"Save Strategy"))
	  $x = $xStart
	  $y = $yStart
	  $lblPresetSaveFilename = GUICtrlCreateLabel(GetTranslated(628,1,"Strategy file name") & ":" ,$x,$y+4,200,25, $SS_RIGHT)
	  $x += 205
	  $txtPresetSaveFilename = GUICtrlCreateInput("strategy " &  @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & "." & @MIN & "." & @SEC,$x,$y,200,25)
	  $x = $xStart
	  $y +=30
	  $lblPresetSaveMessage =  GUICtrlCreateLabel(GetTranslated(628,2,"Notes") & ":" ,$x,$y+4,200,25,  $SS_RIGHT)
      Local $savemessage = GetTranslated(628,3,"SAVE SETTINGS\n--------------------------------------\nSave ALL:\n- Train Army Tab Settings\n- Search && Attack Tab Settings\n\nExcept:\n- Share Replay Settings\n- Take Loot Snapshot Settings\n- Gem Boost Settings\n--------------------------------------")
	  $lblSavePresetMessage = GUICtrlCreateLabel(StringReplace($savemessage, "\n", @crlf ) ,$x+15, $y+4+25,280)

	  $x +=205
	  $txtSavePresetMessage = GUICtrlCreateEdit("", $x, $y , 223, 230, BitOR($ES_WANTRETURN, $ES_AUTOVSCROLL))
	  $y += 235
  	  $btnGUIPresetSaveConf = GUICtrlCreateButton(GetTranslated(628,4,"Save Configuration"), $x+13 , $y, 200, 20)
	  GUICtrlSetOnEvent(-1, "PresetSaveConf")

GUICtrlCreateTabItem("")
;GUISetState()