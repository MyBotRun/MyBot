;#FUNCTION# ====================================================================================================================
; Name ..........: RestartBot
; Description ...: Restart the bot
; Syntax ........: RestartBot([$bCloseAndroid, [$bAutostart]])
; Parameters ....: $bCloseAndroid    - [Optional] Default True closed Android
;                  $bAutostart       - [optional] Default True autostart bot (run state)
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: Cosote (Feb-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func RestartBot($bCloseAndroid = True, $bAutostart = True)
	SetDebugLog("Restart " & $g_sBotTitle)
	Local $sCmdLine = ProcessGetCommandLine(@AutoItPID)
	If @error <> 0 Then
		SetLog("Cannot prepare to restart " & $g_sBotTitle & ", error code " & @error, $COLOR_RED)
		Return SetError(1, 0, False)
	EndIf

	If $bAutostart = True Then
		IniWrite($g_sProfileConfigPath, "general", "Restarted", 1)
	EndIf

	; add restart option (if not already there)
	If StringInStr($sCmdLine, " /restart") = 0 Then
		$sCmdLine &= " /restart"
	EndIf

	If $bCloseAndroid = True Then
		CloseAndroid("RestartBot")
		_Sleep(1000)
	EndIf
	; Restart My Bot
	Local $pid = Run("cmd.exe /c start """" " & $sCmdLine, $g_sWorkingDir, @SW_HIDE) ; cmd.exe only used to support launch like "..\AutoIt3\autoit3.exe" from console
	If @error = 0 Then
		SetLog("Restarting " & $g_sBotTitle)
		; Wait 1 Minute to get closed
		_SleepStatus(60 * 1000)
		Return True
	Else
		SetLog("Cannot restart " & $g_sBotTitle, $COLOR_RED)
	EndIf

	Return SetError(2, 0, False)
EndFunc   ;==>_Restart
