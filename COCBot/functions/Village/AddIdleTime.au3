; #FUNCTION# ====================================================================================================================
; Name ..........: AddIdleTime.au3
; Description ...: Increases the waiting time in the idle phase during training
; Syntax ........: AddIdleTime()
; Parameters ....:
; Return values .: None
; Author ........: Sardo (09/2016)
; Modified ......: Boju (11/2016), MMHK (02/2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func AddIdleTime()
	If Not $g_bTrainAddRandomDelayEnable Then Return

	Local $iTimeToWait = Random(_Min($g_iTrainAddRandomDelayMin, $g_iTrainAddRandomDelayMax), _Max($g_iTrainAddRandomDelayMin, $g_iTrainAddRandomDelayMax), 1)
	SetLog("Waiting, Add random delay of " & $iTimeToWait & " seconds", $COLOR_INFO)

	If _SleepStatus($iTimeToWait * 1000) Then Return
	_GUICtrlStatusBar_SetTextEx($g_hStatusBar, "")
EndFunc   ;==>AddIdleTime
