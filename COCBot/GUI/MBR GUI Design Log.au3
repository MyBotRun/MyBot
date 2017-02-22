; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Log" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_LOG = 0
Global $g_hTxtLog = 0, $g_hDivider = 0, $g_hTxtAtkLog = 0
Global $g_hCmbLogDividerOption, $g_hBtnAtkLogClear, $g_hBtnAtkLogCopyClipboard

Func CreateLogTab()
   Local $i
   Local $x = 0, $y = 0

   Local $activeHWnD = WinGetHandle("") ; RichEdit Controls tamper with active window

   $g_hGUI_LOG = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, 0), -1, $g_hFrmBotEx)
   ;GUISetBkColor($COLOR_WHITE, $g_hGUI_LOG)

   $g_hTxtLog = _GUICtrlRichEdit_Create($g_hGUI_LOG, _PadStringCenter(" " & GetTranslated(601,2, "BOT LOG") & " ", 71, "="), 0, 0, 20, 20, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, 8908), $WS_EX_STATICEDGE)
	   _GUICtrlRichEdit_SetFont($g_hTxtLog, 6, "Lucida Console")
	   _GUICtrlRichEdit_AppendTextColor($g_hTxtLog, "" & @CRLF, _ColorConvert($Color_Black))

   $g_hDivider = GUICtrlCreateLabel("", 0, 0, 20, 20, $SS_SUNKEN + $SS_BLACKRECT)
	   GUICtrlSetCursor(-1, 11)
	   ;GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKLEFT)

   $g_hTxtAtkLog = _GUICtrlRichEdit_Create($g_hGUI_LOG, "", 0, 0, 20, 20, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, 8908), $WS_EX_STATICEDGE)

   WinActivate($activeHWnD) ; restore current active window

   $y = 410
   GUICtrlCreateLabel(GetTranslated(601,3, "Log Style")&":", $x, $y + 5, -1, -1)
	  GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

   $g_hCmbLogDividerOption = GUICtrlCreateCombo("", $x + 50, $y, 180, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	  GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	  _GUICtrlSetTip(-1, GetTranslated(601,4, "Use these options to set the Log type."))
	  GUICtrlSetData(-1, GetTranslated(601,5, "Use Divider to Resize Both Logs") &"|" &GetTranslated(601,6, "Bot and Attack Log Same Size") &"|" &GetTranslated(601,7, "Large Bot Log, Small Attack Log") &"|" &GetTranslated(601,8, "Small Bot Log, Large Attack Log") &"|" &GetTranslated(601,9, "Full Bot Log, Hide Attack Log") & "|" & GetTranslated(601,10, "Hide Bot Log, Full Attack Log") , GetTranslated(601,5, "Use Divider to Resize Both Logs"))
	  GUICtrlSetOnEvent(-1, "cmbLog")

   $g_hBtnAtkLogClear = GUICtrlCreateButton(GetTranslated(601,11, "Clear Atk. Log"), $x + 270, $y - 1, 80, 23)
	  GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	  _GUICtrlSetTip(-1, GetTranslated(601,12, "Use this to clear the Attack Log."))
	  GUICtrlSetOnEvent(-1, "btnAtkLogClear")
	  If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)

   $g_hBtnAtkLogCopyClipboard = GUICtrlCreateButton(GetTranslated(601,13, "Copy to Clipboard"), $x + 350, $y - 1, 100, 23)
	  GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	  _GUICtrlSetTip(-1, GetTranslated(601,14, "Use this to copy the Attack Log to the Clipboard (CTRL+C)"))
	  GUICtrlSetOnEvent(-1, "btnAtkLogCopyClipboard")
	  If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)

EndFunc
