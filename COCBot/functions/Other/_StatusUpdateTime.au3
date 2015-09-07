; #FUNCTION# ====================================================================================================================
; Name ..........: StatusUpdateTime
; Description ...: simple timer display function, displays time passed since handle declared in status bar, Give the user feedback the bot is waiting for something
; Syntax ........: StatusUpdateTime($hTimer)
; Parameters ....: $hTimer              - timer handle provided by Timerinit()
; Return values .: None
; Author ........: KnowJack (Aug2015)
; Modified ......:
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
;
Func _StatusUpdateTime($hTimer)
	$iCurTime = TimerDiff($hTimer)
	$iMinCalc = Int($iCurTime / (60 * 1000))
	$iSecCalc = Int(($iCurTime - ($iMinCalc * 60 * 1000))/1000)
	$sString = "Wait Time = " & StringFormat("%02u" & ":" & "%02u", $iMinCalc, $iSecCalc)
	_GUICtrlStatusBar_SetText($statLog, " Status: " & $sString)
EndFunc