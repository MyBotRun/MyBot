; #FUNCTION# ====================================================================================================================
; Name ..........: MyBot.run Bot API functions
; Description ...: Register Windows Message and provides functions to communicate between bots and manage bot application
; Author ........: cosote (12-2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
;                  Read/write memory: https://www.autoitscript.com/forum/topic/104117-shared-memory-variables-demo/
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_ahManagedMyBotDetails[0] ; Contains array of MemoryHandleArray - frmBot - Timer Handle of last response - Command line of bot - Bot Window Title - RunState - TPaused - Verify count
GUIRegisterMsg($WM_MYBOTRUN_API_1_0, "WM_MYBOTRUN_API_1_0_HOST")
GUIRegisterMsg($WM_MYBOTRUN_STATE_1_0, "WM_MYBOTRUN_STATE_1_0")

Func WM_MYBOTRUN_API_1_0_HOST($hWind, $iMsg, $wParam, $lParam)

	;SetDebugLog("API: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam)

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

Func GetManagedMyBotDetails($hFrmBot = Default, $_RunState = Default, $_TPaused = Default, $iVerifyCount = 2)

	If $hFrmBot = Default Then Return $g_ahManagedMyBotDetails

	If IsHWnd($hFrmBot) = 0 Then Return -1
	Local $pid = WinGetProcess($hFrmBot)
	Local $g_sAndroidTitle = WinGetTitle($hFrmBot)
	If $pid = -1 Then SetLog("Process not found for Window Handle: " & $hFrmBot)

	For $i = 0 To UBound($g_ahManagedMyBotDetails) - 1
		If $i > UBound($g_ahManagedMyBotDetails) - 1 Then ExitLoop ; array could have been reduced in size
		Local $a = $g_ahManagedMyBotDetails[$i]
		If $a[0] = $hFrmBot Then
			$a[1] = __TimerInit()
			If $_RunState <> Default Then $a[4] = $_RunState
			If $_TPaused <> Default Then $a[5] = $_TPaused
			$a[6] = $iVerifyCount ; verify count bot is really crashed (used to compensate computer sleep etc.)
			$g_ahManagedMyBotDetails[$i] = $a
			SetDebugLog("Bot Window state received: " & GetManagedMyBotInfoString($a))
			Return $a
		EndIf
		If $a[3] = $g_sAndroidTitle Then
			SetDebugLog("Remove registered Bot Window Handle " & $a[0] & ", as new instance detected")
			_ArrayDelete($g_ahManagedMyBotDetails, $i)
			$i -= 1
		EndIf
	Next

	ReDim $g_ahManagedMyBotDetails[UBound($g_ahManagedMyBotDetails) + 1]
	Local $a[7]
	; Register new bot
	$a[0] = $hFrmBot
	$a[1] = __TimerInit()
	$a[2] = ProcessGetCommandLine($pid)
	$a[3] = $g_sAndroidTitle
	$a[4] = $_RunState
	$a[5] = $_TPaused
	$a[6] = $iVerifyCount ; verify count bot is really crashed (used to compensate computer sleep etc.)
	If $a[1] = -1 Then SetLog("Command line not found for Window Handle/PID: " & $hFrmBot & "/" & $pid)
	$g_ahManagedMyBotDetails[$i] = $a
	SetDebugLog("New Bot Window Handle registered: " & GetManagedMyBotInfoString($a))
	Return $a
EndFunc   ;==>GetManagedMyBotDetails

Func GetManagedMyBotInfoString(ByRef $a)

	If UBound($a) < 7 Then Return "unknown"
	Return $a[0] & ", " & $a[2] & ", " & $a[3] & ", " & ($a[4] ? "running" : "not running") & ", " & ($a[5] ? "paused" : "not paused")

EndFunc   ;==>GetManagedMyBotInfoString

Func UnregisterManagedMyBotClient($hFrmBot)

	SetDebugLog("Try to un-register Bot Window Handle: " & $hFrmBot)

	For $i = 0 To UBound($g_ahManagedMyBotDetails) - 1
		Local $a = $g_ahManagedMyBotDetails[$i]
		If $a[0] = $hFrmBot Then
			_ArrayDelete($g_ahManagedMyBotDetails, $i)
			Local $Result = 1
			If IsHWnd($hFrmBot) Then
				SetDebugLog("Bot Window Handle un-registered: " & $hFrmBot)
			Else
				SetDebugLog("Inaccessible Bot Window Handle un-registered: " & $hFrmBot)
				$Result = -1
			EndIf
			If $bCloseWhenAllBotsUnregistered = True And UBound($g_ahManagedMyBotDetails) = 0 Then
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
	For $i = 0 To UBound($g_ahManagedMyBotDetails) - 1
		Local $a = $g_ahManagedMyBotDetails[$i]
		If __TimerDiff($a[1]) > $iTimeout Then
			If $a[6] > 0 Then
				; not verified inresponsive, decrease counter
				$a[6] -= 1
				; update array
				$g_ahManagedMyBotDetails[$i] = $a
				ContinueLoop
			EndIf
			_ArrayDelete($g_ahManagedMyBotDetails, $i)
			; check if bot has been already restarted manually
			Local $cmd = $a[2]
			Local $g_sAndroidTitle = $a[3]
			For $j = 0 To UBound($g_ahManagedMyBotDetails) - 1
				$a = $g_ahManagedMyBotDetails[$j]
				If $a[3] = $g_sAndroidTitle Then
					SetDebugLog("Bot already restarted, window title: " & $g_sAndroidTitle)
					Return WinGetProcess($a[0])
				EndIf
			Next
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

Func GetActiveMyBotCount($iTimeout)

	Local $iCount = 0
	For $i = 0 To UBound($g_ahManagedMyBotDetails) - 1
		Local $a = $g_ahManagedMyBotDetails[$i]
		If __TimerDiff($a[1]) <= $iTimeout Then
			$iCount += 1
		Else
			SetDebugLog("Bot not responding with Window Handle: " & $a[0])
		EndIf
	Next

	Return $iCount
EndFunc   ;==>GetActiveMyBotCount
