
; #FUNCTION# ====================================================================================================================
; Name ..........: GetDPI_Ratio
; Description ...: Returns the current user DPI setting for display.
; Syntax ........: GetDPI_Ratio()
; Parameters ....: None
; Return values .: Ratio of DPI to standard 96 DPI display
; Author ........: Spiff59 (AutoIt Forums posted 9/23/2013)
; Modified ......: KnowJack
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: None
; Link ..........: https://www.autoitscript.com/forum/topic/154885-autoit-and-dpi-awareness/
; Example .......: No
; ===============================================================================================================================

Global $iDPI_Ratio = 1

Func GetDPI_Ratio()
	Local $hWnd = 0
	Local $hDC = DllCall("user32.dll", "long", "GetDC", "long", $hWnd)
	If @error Then Return SetError(1, @extended, 0)
	Local $aRet = DllCall("gdi32.dll", "long", "GetDeviceCaps", "long", $hDC[0], "long", 90)
	If @error Then Return SetError(2, @extended, 0)
	$hDC = DllCall("user32.dll", "long", "ReleaseDC", "long", $hWnd, "long", $hDC)
	If @error Then Return SetError(3, @extended, 0)
	If $aRet[0] = 0 Then $aRet[0] = 96
	Return $aRet[0] / 96
EndFunc   ;==>GetDPI_Ratio


; #FUNCTION# ====================================================================================================================
; Name ..........: GUISetFont_DPI
; Description ...: Automaticaly adjust GUI font size for User DPI setting
; Syntax ........: GUISetFont_DPI($isize[, $iweight = ""[, $iattribute = ""[, $sfontname = ""]]])
; Parameters ....: $isize               - an integer value.
;                  $iweight             - [optional] an integer value. Default is "".
;                  $iattribute          - [optional] an integer value. Default is "".
;                  $sfontname           - [optional] a string value. Default is "".
; Return values .: None
; Author ........: Spiff59 (AutoIt Forums posted 9/23/2013)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: None
; Link ..........: https://github.com/MyBotRun/MyBot/wiki https://www.autoitscript.com/forum/topic/154885-autoit-and-dpi-awareness/
; Example .......: N
; ===============================================================================================================================

Func GUISetFont_DPI($isize, $iweight = "", $iattribute = "", $sfontname = "")
	GUISetFont($isize / $iDPI_Ratio, $iweight, $iattribute, $sfontname)
EndFunc   ;==>GUISetFont_DPI



Func SetDPI()
	; This uses undocumented dll function from MS and does work reliably in all OS so it was removed from main bot code
	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
	$stext = "My Bot needs to change your DPI settinng to continue!" & @CRLF & @CRLF & _
			"You will be required to reboot your PC when done" & @CRLF & @CRLF & "Please close other programs and save you work NOW!" & @CRLF & @CRLF & _
			"Hit OK to change settings and reboot, or cancel to exit bot"
	$MsgBox = _ExtMsgBox(0, GetTranslated(640,1,"Ok|Cancel"), GetTranslated(640,2,"Display Settings Error"), $stext, 120, $frmBot)
	If $MsgBox = 1 Then
		; DLLCALL to change the DPI setting, requires the DPI to be in string format
		; Requires the system to be restarted to take effect.
		Local $aRet = DllCall("syssetup.dll", "int", "SetupChangeFontSize", "int_ptr", 0, "wstr", "96")
		If @error Then Return SetError(2, @extended, 0)
		If $aRet = 0 Then
			Setlog("Your Display DPI has been changed!!  Must logoff or restart to complete the chamge!", $COLOR_MAROON)
			_Sleep(5000) ; dont use if .. then here!
			Shutdown($SD_REBOOT)
		Else
			Setlog("Your DPI has not been changed due some unknown error, Return= " & $aRet, $COLOR_MAROON)
		EndIf
	EndIf
EndFunc   ;==>SetDPI

