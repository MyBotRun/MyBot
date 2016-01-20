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
;~ General Tab
;~ -------------------------------------------------------

$tabGeneral = GUICtrlCreateTabItem(GetTranslated(0,1, "Log"))
Local $x = 30, $y = 150, $w = 450, $h = 170, $i
	$txtLog = _GUICtrlRichEdit_Create($frmBot, _PadStringCenter(" " & GetTranslated(0,2, "BOT LOG") & " ", 71, "="), $x - 20, $y - 20, $w, $h + 85, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, 8912), $WS_EX_STATICEDGE)
	_GUICtrlRichEdit_SetFont($txtLog, 6, "Lucida Console")
	_GUICtrlRichEdit_AppendTextColor($txtLog, "" & @CRLF, _ColorConvert($Color_Black))
		_ArrayConcatenate($G, $A)
	;add existing Log
	For $i = 0 To UBound($aTxtLogInitText) - 1
	   SetLog($aTxtLogInitText[$i][0], $aTxtLogInitText[$i][1], $aTxtLogInitText[$i][2], $aTxtLogInitText[$i][3], $aTxtLogInitText[$i][4], $aTxtLogInitText[$i][5])
	Next
	Redim $aTxtLogInitText[0][6]
	$y += $h + 85
	$iDividerHeight = 4
	$divider = GUICtrlCreateLabel("", $x - 20, $y - 20, $w, $iDividerHeight, $SS_SUNKEN + $SS_BLACKRECT)
	GUICtrlSetCursor(-1, 11)
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKLEFT)
	$y += $iDividerHeight
	$txtAtkLog = _GUICtrlRichEdit_Create($frmBot, "", $x - 20, $y - 20, $w, $h - 85, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, 8912), $WS_EX_STATICEDGE)
	$y = 480
	$lblLog = GUICtrlCreateLabel(GetTranslated(0,3, "Log Style")&":", $x - 20, $y + 5, -1, -1)
	$cmbLog = GUICtrlCreateCombo("", $x + 30, $y, 180, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		$txtTip = GetTranslated(0,4, "Use these options to set the Log type.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetData(-1, GetTranslated(0,5, "Use Divider to Resize Both Logs") &"|" &GetTranslated(0,6, "Bot and Attack Log Same Size") &"|" &GetTranslated(0,7, "Large Bot Log, Small Attack Log") &"|" &GetTranslated(0,8, "Small Bot Log, Large Attack Log") &"|" &GetTranslated(0,9, "Full Bot Log, Hide Attack Log") & "|" & GetTranslated(0,10, "Hide Bot Log, Full Attack Log") , GetTranslated(0,5, "Use Divider to Resize Both Logs"))
		GUICtrlSetOnEvent(-1, "cmbLog")
	$btnAtkLogClear = GUICtrlCreateButton(GetTranslated(0,11, "Clear Atk. Log"), $x + 240, $y - 1, 80, 23)
		$txtTip = GetTranslated(0,12, "Use this to clear the Attack Log.")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "btnAtkLogClear")
		IF $btnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)
	$btnAtkLogCopyClipboard = GUICtrlCreateButton(GetTranslated(0,13, "Copy to Clipboard"), $x + 320, $y - 1, 100, 23)
		$txtTip = GetTranslated(0,14, "Use this to copy the Attack Log to the Clipboard (CTRL+C)")
		GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "btnAtkLogCopyClipboard")
		IF $btnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
