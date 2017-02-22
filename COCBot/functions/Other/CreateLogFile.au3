; #FUNCTION# ====================================================================================================================
; Name ..........: CreateLogFile
; Description ...:
; Syntax ........: CreateLogFile()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CreateLogFile()
	If $g_hLogFile <> 0 Then
	   FileClose($g_hLogFile)
	   $g_hLogFile = 0
    EndIf

	$g_sLogFileName = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "." & @MIN & "." & @SEC & ".log"
	Local $sLogPath = $g_sProfileLogsPath & $g_sLogFileName
	$g_hLogFile = FileOpen($sLogPath, $FO_APPEND)
EndFunc   ;==>CreateLogFile

; #FUNCTION# ====================================================================================================================
; Name ..........: CreateAttackLogFile
; Description ...:
; Syntax ........: CreateAttackLogFile()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CreateAttackLogFile()
	If $g_hAttackLogFile <> 0 Then
	   FileClose($g_hAttackLogFile)
	   $g_hAttackLogFile = 0
    EndIf

	Local $sAttackLogFName = "AttackLog" & "-" & @YEAR & "-" & @MON & ".log"
	Local $sAttackLogPath = $g_sProfileLogsPath & $sAttackLogFName
	$g_hAttackLogFile = FileOpen($sAttackLogPath, $FO_APPEND)
EndFunc   ;==>CreateAttackLogFile