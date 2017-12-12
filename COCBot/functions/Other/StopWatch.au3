; #FUNCTION# ====================================================================================================================
; Name ..........: StopWatchStart, StopWatchStopLog, StopWatchLevel, StopWatchReturn
; Description ...: Logs step execution times
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Cosote, 12-2017
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: StopWatchStart("myFunction") [...] StopWatchStopLog() on early exist use StopWatchReturn($iInitialLevel)
; ===============================================================================================================================

Global $g_oStopWatches = ObjCreate("Scripting.Dictionary")
If Not IsDeclared("g_bDebugFuncTime") Then Global $g_bDebugFuncTime = False

Func StopWatchStart($sTag)
	StopWatchStopPushTag($sTag)
	$g_oStopWatches($sTag) = __TimerInit()
EndFunc

Func StopWatchLevel()
	Local $iLevel = $g_oStopWatches("__CURRENT_TAG_LEVEL__")
	If IsNumber($iLevel) = 0 Then $iLevel = 0
	Return $iLevel
EndFunc

Func StopWatchStopPushTag($sTag)
	Local $iLevel = StopWatchLevel()
	$g_oStopWatches("__CURRENT_TAG__" & $iLevel) = $sTag
	$g_oStopWatches("__CURRENT_TAG_LEVEL__") = $iLevel + 1
	Return $iLevel
EndFunc

Func StopWatchStopPopTag($iNewLevel = Default)
	Local $iLevel = StopWatchLevel() - 1
	$g_oStopWatches("__CURRENT_TAG_LEVEL__") = $iLevel
	Return $g_oStopWatches("__CURRENT_TAG__" & $iLevel)
EndFunc

Func StopWatchStopLog($sTag = Default, $iNewLevel = Default, $bLog = True)
	Local $sTagLevel = StopWatchStopPopTag()
	If $sTag = Default Then
		$sTag = $sTagLevel
	ElseIf $sTag <> $sTagLevel Then
		SetLog("StopWatch Level mismatch: " & $sTag & " <> " & $sTagLevel, $COLOR_ERROR)
	EndIf
	Local $hTimer = $g_oStopWatches($sTag)
	$g_oStopWatches.Remove($sTag)
	SetLog($sTag & " Execution-time: " & __TimerDiff($hTimer))
	If $iNewLevel <> Default Then
		While StopWatchLevel() > $iNewLevel
			StopWatchStopLog(Default, Default, $bLog)
		WEnd
	EndIf
EndFunc

Func StopWatchReturn($iNewLevel, $bLog = $g_bDebugFuncTime)
	Local $iCurLevel = StopWatchLevel()
	If $iNewLevel <> $iCurLevel Then StopWatchStopLog(Default, $iNewLevel, $bLog)
EndFunc