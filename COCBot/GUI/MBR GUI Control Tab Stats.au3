; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), kaganus (August 2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func btnLoots()
	Run("Explorer.exe " & $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Loots")
EndFunc   ;==>btnLoots

Func btnLogs()
	Run("Explorer.exe " & $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Logs")
EndFunc   ;==>btnLogs

Func btnResetStats()
	ResetStats()
EndFunc   ;==>btnResetStats
