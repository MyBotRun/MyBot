; #FUNCTION# ====================================================================================================================
; Name ..........: MyBot.run Bot API functions
; Description ...: Register Windows Message and provides functions to communicate between bots and manage bot application
; Author ........: cosote (12-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
;                  Read/write memory: https://www.autoitscript.com/forum/topic/104117-shared-memory-variables-demo/
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $aManagedMyBotDetails[0] ; Contains array of MemoryHandleArray - frmBot - Timer Handle of last response - Command line of bot - HWnD - RunState - TPaused
GUIRegisterMsg($WM_MYBOTRUN_API_1_0, "WM_MYBOTRUN_API_1_0_HOST")
GUIRegisterMsg($WM_MYBOTRUN_STATE_1_0, "WM_MYBOTRUN_STATE_1_0")

Func WM_MYBOTRUN_API_1_0_HOST($hWind, $iMsg, $wParam, $lParam)

	SetDebugLog("API: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam)

	$hWind = 0
	Switch BitAND($wParam, 0xFFFF)

		; Post Message to Manage Farm App and consume message

		Case 0x0000 + 1
			Local $_frmBot = HWnd($lParam)
			Local $wParamHi = BitShift($wParam, 16)
			Local $_RunState = BitAND($wParamHi, 1) > 0
			Local $_TPaused = BitAND($wParamHi, 2) > 0
			GetManagedMyBotDetails($_frmBot, $_RunState, $_TPaused)

		Case 0x1040 + 2
			; unregister bot
			Local $_frmBot = $lParam
			Local $wParamHi = BitShift($wParam, 16)
			UnregisterManagedMyBotClient($_frmBot)

	EndSwitch

	If $hWind <> 0 Then
		_WinAPI_PostMessage($hWind, $iMsg, $wParam, $lParam)
	EndIf

EndFunc   ;==>WM_MYBOTRUN_API_1_0_HOST

Func WM_MYBOTRUN_STATE_1_0($hWind, $iMsg, $wParam, $lParam)

	SetDebugLog("STATE: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam)

EndFunc   ;==>WM_MYBOTRUN_STATE_1_0

Func GetManagedMyBotDetails($hFrmBot = Default, $_RunState = Default, $_TPaused = Default)

	If $hFrmBot = Default Then Return $aManagedMyBotDetails

	If IsHWnd($hFrmBot) = 0 Then Return -1
	Local $pid = WinGetProcess($hFrmBot)
	If $pid = -1 Then SetLog("Process not found for Window Handle: " & $hFrmBot)

	For $i = 0 To UBound($aManagedMyBotDetails) - 1
		Local $a = $aManagedMyBotDetails[$i]
		If $a[0] = $hFrmBot Then
			$a[1] = TimerInit()
			If $_RunState <> Default Then $a[4] = $_RunState
			If $_TPaused <> Default Then $a[5] = $_TPaused
			$aManagedMyBotDetails[$i] = $a
			Return $a
		EndIf
	Next

	ReDim $aManagedMyBotDetails[UBound($aManagedMyBotDetails) + 1]
	Local $a[6]

	$a[0] = $hFrmBot
	$a[1] = TimerInit()
	$a[2] = ProcessGetCommandLine($pid)
	;$a[3] = $HWnD ; not yet supported
	$a[4] = $_RunState
	$a[5] = $_TPaused
	If $a[1] = -1 Then SetLog("Command line not found for Window Handle/PID: " & $hFrmBot & "/" & $pid)
	$aManagedMyBotDetails[$i] = $a
	SetDebugLog("New Bot Window Handle registered: " & $hFrmBot)
	Return $a
EndFunc   ;==>GetManagedMyBotDetails

Func UnregisterManagedMyBotClient($hFrmBot)

	SetDebugLog("Try to un-register Bot Window Handle: " & $hFrmBot)

	For $i = 0 To UBound($aManagedMyBotDetails) - 1
		Local $a = $aManagedMyBotDetails[$i]
		If $a[0] = $hFrmBot Then
			_ArrayDelete($aManagedMyBotDetails, $i)
			Local $Result = 1
			If IsHWnd($hFrmBot) Then
				SetDebugLog("Bot Window Handle un-registered: " & $hFrmBot)
			Else
				SetDebugLog("Inaccessible Bot Window Handle un-registered: " & $hFrmBot)
				$Result = -1
			EndIf
			If $bCloseWhenAllBotsUnregistered = True And UBound($aManagedMyBotDetails) = 0 Then
				SetLog("Closing " & $sBotTitle & "as all bots closed")
				Exit (1)
			EndIf
			Return $Result
		EndIf
	Next

	SetDebugLog("Bot Window Handle not un-registered: " & $hFrmBot, $COLOR_RED)

	Return 0

EndFunc   ;==>UnregisterManagedMyBotClient

Func CheckManagedMyBot($iTimeout)

	; Launch crashed bot again
	For $i = 0 To UBound($aManagedMyBotDetails) - 1
		Local $a = $aManagedMyBotDetails[$i]
		If TimerDiff($a[1]) > $iTimeout Then
			_ArrayDelete($aManagedMyBotDetails, $i)
			Local $cmd = $a[2]
			If StringInStr($cmd, " /restart") = 0 Then $cmd &= " /restart"
			If $a[4] Then
				; bot was started, autostart again
				If StringInStr($cmd, " /autostart") = 0 Then $cmd &= " /autostart"
			EndIf
			SetDebugLog("Restarting bot: " & $cmd)
			Return Run($cmd)
		EndIf
	Next

	Return 0
EndFunc   ;==>CheckManagedMyBot
