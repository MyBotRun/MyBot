; auto start script by Sm0kE
; edited: 2015-06 sardo - parametrized $ichkAutoStartDelay
; edited: 2015-07 sardo - insert into a function
Func AutoStart()
	If $ichkAutoStart = 1 OR $restarted = 1 Then
		SetLog("Bot Auto Starting in " & $ichkAutoStartDelay & " seconds", $COLOR_RED)
		sleep($ichkAutoStartDelay*1000)
		ControlClick($sBotTitle, "Start Bot", "[CLASS:Button; TEXT:Start Bot]", "left", "1")
	EndIf
EndFunc

