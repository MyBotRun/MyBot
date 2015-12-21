;
; #FUNCTION# ====================================================================================================================
; Name ..........: SendAdbCommand
; Description ...:
; Syntax ........: SendAdbCommand()
; Parameters ....:
; Return values .:
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkMainscreen, isProblemAffect
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SendAdbCommand($cmd)
	Local $process_killed

	Local $data = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " " & $cmd, $process_killed)

EndFunc