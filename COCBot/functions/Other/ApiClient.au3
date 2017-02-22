; #FUNCTION# ====================================================================================================================
; Name ..........: MyBot.run Bot API functions
; Description ...: Register Windows Message and provides functions to communicate between bots and manage bot application
; Author ........: cosote (12-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
;                  Read/write memory: https://www.autoitscript.com/forum/topic/104117-shared-memory-variables-demo/
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $aManagedMyBotHosts[0] ; Contains array of registered MyBot.run host Window Handle and TimerHandle of last communication
GUIRegisterMsg($WM_MYBOTRUN_API_1_0, "WM_MYBOTRUN_API_1_0_CLIENT")

Func WM_MYBOTRUN_API_1_0_CLIENT($hWind, $iMsg, $wParam, $lParam)

	If $hWind <> $g_hFrmBot Then Return 0

	;SetDebugLog("API: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)

	$hWind = 0
	Switch BitAND($wParam, 0xFFFF)

		; Post Message to Manage Farm App and consume message

		Case 0x0000 ; query bot run and pause state
			$hWind = HWnd($lParam)
			$lParam = $g_hFrmBot
			$wParam += 1
			Local $wParamHi = 0
			If $g_bRunState = True Then $wParamHi += 1
			If $g_bBotPaused = True Then $wParamHi += 2
			$wParam += BitShift($wParamHi, -16)

		Case 0x0010 ; query bot detailed state
			$iMsg = $WM_MYBOTRUN_STATE_1_0
			$hWind = HWnd($lParam)
			$lParam = $g_hFrmBot
			$wParam = DllStructGetPtr($tBotState)
			DllStructSetData($tBotState, "frmBot", $g_hFrmBot)
			DllStructSetData($tBotState, "HWnD", $HWnD)
			DllStructSetData($tBotState, "RunState", $g_bRunState)
			DllStructSetData($tBotState, "TPaused", $g_bBotPaused)

		Case 0x1000 ; start bot
			$hWind = HWnd($lParam)
			$lParam = $g_hFrmBot
			$wParam += 1
			Local $wParamHi = 0
			If $g_bRunState = False Then
				$wParamHi = 1
				$wParam += BitShift($wParamHi, -16)
				_WinAPI_PostMessage($hWind, $iMsg, $wParam, $lParam)
				btnStart()
				Return
			EndIf
			$wParam += BitShift($wParamHi, -16)

		Case 0x1010 ; stop bot
			$hWind = HWnd($lParam)
			$lParam = $g_hFrmBot
			$wParam += 1
			Local $wParamHi = 0
			If $g_bRunState = True Then
				$wParamHi = 1
				btnStop()
			EndIf
			$wParam += BitShift($wParamHi, -16)

		Case 0x1020 ; resume bot
			$hWind = HWnd($lParam)
			$lParam = $g_hFrmBot
			$wParam += 1
			Local $wParamHi = 0
			If $g_bBotPaused = True And $g_bRunState = True Then
				TogglePauseImpl("ManageFarm")
				$wParamHi = 1
			EndIf
			$wParam += BitShift($wParamHi, -16)

		Case 0x1030 ; pause bot
			$hWind = HWnd($lParam)
			$lParam = $g_hFrmBot
			$wParam += 1
			Local $wParamHi = 0
			If $g_bBotPaused = False And $g_bRunState = True Then
				TogglePauseImpl("ManageFarm")
				$wParamHi = 1
			EndIf
			$wParam += BitShift($wParamHi, -16)

		Case 0x1040 ; close bot
			$hWind = HWnd($lParam)
			$lParam = $g_hFrmBot
			$wParam += 1
			Local $wParamHi = 0
			BotCloseRequest()
			$wParam += BitShift($wParamHi, -16)

	EndSwitch

	If $hWind <> 0 Then
		Local $a = GetManagedMyBotHost($hWind)
		$a[1] = TimerInit()
		_WinAPI_PostMessage($hWind, $iMsg, $wParam, $lParam)
	EndIf

	Return 1

EndFunc   ;==>WM_MYBOTRUN_API_1_0_CLIENT

Func GetManagedMyBotHost($hFrmHost = Default)

	If $hFrmHost = Default Then
		Return $aManagedMyBotHosts
	EndIf

	If IsHWnd($hFrmHost) = 0 Then Return -1

	For $i = 0 To UBound($aManagedMyBotHosts) - 1
		Local $a = $aManagedMyBotHosts[$i]
		If $a[0] = $hFrmHost Then Return $a
	Next

	ReDim $aManagedMyBotHosts[UBound($aManagedMyBotHosts) + 1]
	Local $a[2]
	$a[0] = $hFrmHost
	$aManagedMyBotHosts[$i] = $a
	SetDebugLog("New Bot Host Window Handle registered: " & $hFrmHost)
	Return $a
EndFunc   ;==>GetManagedMyBotHost

Func LaunchWatchdog()
	Local $hMutex = _Singleton($sWatchdogMutex, 1)
	If $hMutex = 0 Then
		; already running
		SetDebugLog("Watchdog already running")
		Return 0
	EndIf
	_WinAPI_CloseHandle($hMutex)
	Local $cmd = """" & @ScriptDir & "\MyBot.run.Watchdog.exe"""
	If @Compiled = 0 Then $cmd = """" & @AutoItExe & """ /AutoIt3ExecuteScript """ & @ScriptDir & "\MyBot.run.Watchdog.au3" & """"
	Local $pid = Run($cmd, @ScriptDir, @SW_HIDE)
	If $pid = 0 Then
		SetLog("Cannot launch watchdog", $COLOR_RED)
		Return 0
	EndIf
	If $g_iDebugSetlog Then
		SetDebugLog("Watchdog launched, PID = " & $pid)
	Else
		SetLog("Watchdog launched")
	EndIf
	Return $pid
EndFunc   ;==>LaunchWatchdog

Func UnregisterManagedMyBotHost()
	For $i = 0 To UBound($aManagedMyBotHosts) - 1
		Local $a = $aManagedMyBotHosts[$i]
		Local $hFrmHost = $a[0]
		$a[0] = 0
		$aManagedMyBotHosts[$i] = $a
		If IsHWnd($hFrmHost) Then
			Local $hWind = $hFrmHost
			Local $iMsg = $WM_MYBOTRUN_API_1_0
			Local $wParam = 0x1040 + 2
			Local $lParam = $g_hFrmBot
			_WinAPI_PostMessage($hWind, $iMsg, $wParam, $lParam)
			SetDebugLog("Bot Host Window Handle un-registered: " & $hFrmHost)
		EndIf
	Next
EndFunc   ;==>UnregisterManagedMyBotHost
