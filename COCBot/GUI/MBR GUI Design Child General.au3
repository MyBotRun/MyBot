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

;~ -------------------------------------------------------------
;~ This dummy is used in btnStart and btnStop to disable/enable all labels, text, buttons etc. on all tabs.
;~ -------------------------------------------------------------
Global $FirstControlToHide = GUICtrlCreateDummy()
;~ -------------------------------------------------------------

;~ -------------------------------------------------------
;~ General Child GUI
;~ -------------------------------------------------------

Local $i
Local $x = 0, $y = 0

Local $activeHWnD = WinGetHandle("") ; RichEdit Controls tamper with active window

; Creates the LOG child window that is implemented into the main GUI
$hGUI_LOG = GUICreate("", $_GUI_MAIN_WIDTH - 20, $_GUI_MAIN_HEIGHT - 255, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, 0), -1, $frmBotEx)
;GUISetBkColor($COLOR_WHITE, $hGUI_LOG)

$txtLog = _GUICtrlRichEdit_Create($hGUI_LOG, _PadStringCenter(" " & GetTranslated(601,2, "BOT LOG") & " ", 71, "="), 0, 0, 20, 20, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, 8912), $WS_EX_STATICEDGE)
	_GUICtrlRichEdit_SetFont($txtLog, 6, "Lucida Console")
	_GUICtrlRichEdit_AppendTextColor($txtLog, "" & @CRLF, _ColorConvert($Color_Black))
	_ArrayConcatenate($G, $A)
	;add existing Log
	For $i = 0 To UBound($aTxtLogInitText) - 1
	   SetLog($aTxtLogInitText[$i][0], $aTxtLogInitText[$i][1], $aTxtLogInitText[$i][2], $aTxtLogInitText[$i][3], $aTxtLogInitText[$i][4], $aTxtLogInitText[$i][5])
	Next
	Redim $aTxtLogInitText[0][6]
$divider = GUICtrlCreateLabel("", 0, 0, 20, 20, $SS_SUNKEN + $SS_BLACKRECT)
	GUICtrlSetCursor(-1, 11)
	;GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKLEFT)
	$txtAtkLog = _GUICtrlRichEdit_Create($hGUI_LOG, "", 0, 0, 20, 20, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, 8912), $WS_EX_STATICEDGE)

WinActivate($activeHWnD) ; restore current active window

$y = 370
	$lblLog = GUICtrlCreateLabel(GetTranslated(601,3, "Log Style")&":", $x, $y + 5, -1, -1)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	$cmbLog = GUICtrlCreateCombo("", $x + 50, $y, 180, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$txtTip = GetTranslated(601,4, "Use these options to set the Log type.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetData(-1, GetTranslated(601,5, "Use Divider to Resize Both Logs") &"|" &GetTranslated(601,6, "Bot and Attack Log Same Size") &"|" &GetTranslated(601,7, "Large Bot Log, Small Attack Log") &"|" &GetTranslated(601,8, "Small Bot Log, Large Attack Log") &"|" &GetTranslated(601,9, "Full Bot Log, Hide Attack Log") & "|" & GetTranslated(601,10, "Hide Bot Log, Full Attack Log") , GetTranslated(601,5, "Use Divider to Resize Both Logs"))
		GUICtrlSetOnEvent(-1, "cmbLog")
	$btnAtkLogClear = GUICtrlCreateButton(GetTranslated(601,11, "Clear Atk. Log"), $x + 270, $y - 1, 80, 23)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$txtTip = GetTranslated(601,12, "Use this to clear the Attack Log.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "btnAtkLogClear")
		IF $btnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)
	$btnAtkLogCopyClipboard = GUICtrlCreateButton(GetTranslated(601,13, "Copy to Clipboard"), $x + 350, $y - 1, 100, 23)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$txtTip = GetTranslated(601,14, "Use this to copy the Attack Log to the Clipboard (CTRL+C)")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "btnAtkLogCopyClipboard")
		IF $btnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

;GUICtrlCreateTabItem("")
;GUISetState()
