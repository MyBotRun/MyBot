; #FUNCTION# ====================================================================================================================
; Name ..........: _GUICtrlSetTip
; Description ...: Replacement for GUICtrlSetTip because doesn't create a tool tip control everytime
; Syntax ........:
; Parameters ....: See GUICtrlSetTip
; Return values .: See _GUIToolTip_AddTool
; Author ........: Cosote (July-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $hToolTip = 0

Func _GUICtrlSetTip($controlID, $tiptext, $title = Default, $icon = Default, $options = Default)
	;Return GUICtrlSetTip($controlID, $tiptext, $title, $icon, $options)
	If $hToolTip = 0 Then
		SetDebugLog("_GUICtrlSetTip: Missing $hToolTip!", $COLOR_RED)
		Return False
	EndIf
	Local $hCtrl = GUICtrlGetHandle($controlID)
	Return _GUIToolTip_AddTool($hToolTip, 0, $tiptext, $hCtrl)
EndFunc   ;==>_GUICtrlSetTip

Func _GUICtrlGetControlID($hCtrl = -1)
    Local $aRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", ($hCtrl = -1 ? GUICtrlGetHandle(-1) : $hCtrl))
    Return (IsArray($aRet) ? $aRet[0] : -1)
EndFunc   ;==>_GUICtrlGetControlID

