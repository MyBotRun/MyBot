; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func chkGlobalChatEnable()
	If GUICtrlRead($chkGlobalChatEnable) = $GUI_CHECKED Then
		$ichkGlobalChatEnable = 1
	Else
		$ichkGlobalChatEnable = 0
	EndIf
EndFunc   ;==>chkGlobalChatEnable

Func chkClanChatEnable()
	If GUICtrlRead($chkClanChatEnable) = $GUI_CHECKED Then
		$ichkClanChatEnable = 1
	Else
		$ichkClanChatEnable = 0
	EndIf
EndFunc   ;==>chkClanChatEnable
