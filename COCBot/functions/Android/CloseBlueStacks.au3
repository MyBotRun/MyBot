
; #FUNCTION# ====================================================================================================================
; Name ..........: CloseBS
; Description ...:  Forces BS processes to close, and watches BS processes and services to make sure it has stopped
; Syntax ........: CloseBS()
; Parameters ....: None
; Return values .: @error = 1 if failure
; Author ........: The Master1 (From CGB Forums Aug2015)
; Modified ......: KnowJack (August 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CloseBlueStacks()
	Local $iIndex, $bOops = False
	Local $aServiceList[4] = ["BstHdAndroidSv", "BstHdLogRotatorSvc", "BstHdUpdaterSvc", "bthserv"]

	If Not InitAndroid() Then Return

	RunWait($__BlueStacks_Path & "HD-Quit.exe")
	If @error <> 0 Then
		SetLog($g_sAndroidEmulator & " failed to quit", $COLOR_ERROR)
		;SetError(1, @extended, -1)
		;Return False
	EndIf

	If _Sleep(2000) Then Return ; wait a bit

	; Check if HD-FrontEnd.exe terminated
	$bOops = ProcessExists("HD-Frontend.exe") <> 0

	If $bOops Then
		$bOops = False
		SetDebugLog("Failed to terminate HD-Frontend.exe with HD-Quit.exe, fallback to taskkill", $COLOR_ERROR)
		KillBSProcess()
		If _Sleep(1000) Then Return ; wait a bit

		SetLog("Please wait for full BS shutdown....", $COLOR_SUCCESS)

		For $iIndex = 0 To UBound($aServiceList) - 1
			ServiceStop($aServiceList[$iIndex])
			If @error Then
				$bOops = True
				If $g_iDebugSetlog = 1 Then Setlog($aServiceList[$iIndex] & "errored trying to stop", $COLOR_WARNING)
			EndIf
		Next
		If $bOops Then
			If $g_iDebugSetlog = 1 Then Setlog("Service Stop issues, Stopping BS 2nd time", $COLOR_WARNING)
			KillBSProcess()
			If _SleepStatus(5000) Then Return
		EndIf
	EndIf


	If $g_iDebugSetlog = 1 And $bOops Then
		SetLog("BS Kill Failed to stop service", $COLOR_ERROR)
	EndIf

	If $bOops Then
		SetError(1, @extended, -1)
	EndIf

EndFunc   ;==>CloseBlueStacks

Func CloseBlueStacks2()

	Local $bOops = False

	If Not InitAndroid() Then Return

	RunWait($__BlueStacks_Path & "HD-Quit.exe")
	If @error <> 0 Then
		SetLog($g_sAndroidEmulator & " failed to quit", $COLOR_ERROR)
		;SetError(1, @extended, -1)
		;Return False
	EndIf

	If _Sleep(2000) Then Return ; wait a bit

	If $bOops Then
		SetError(1, @extended, -1)
	EndIf

EndFunc   ;==>CloseBlueStacks2

Func KillBSProcess()

	Local $iIndex
	Local $aBS_FileNames[8][2] = [['HD-Agent.exe', 0], ['HD-BlockDevice.exe', 0], ['HD-Frontend.exe', 0], _
			['HD-Network.exe', 0], ['HD-Service.exe', 0], ['HD-SharedFolder.exe', 0], ['HD-UpdaterService.exe', 0], ['HD-Adb.exe', 0]]

	For $iIndex = 0 To UBound($aBS_FileNames) - 1
		$aBS_FileNames[$iIndex][1] = ProcessExists($aBS_FileNames[$iIndex][0]) ; Find the PID for each BS file name that is running
		If $g_iDebugSetlog = 1 Then Setlog($aBS_FileNames[$iIndex][0] & " PID = " & $aBS_FileNames[$iIndex][1], $COLOR_DEBUG)
		If $aBS_FileNames[$iIndex][1] > 0 Then ; If it is running, then kill it
			ShellExecute(@WindowsDir & "\System32\taskkill.exe", " -t -pid " & $aBS_FileNames[$iIndex][1], "", Default, @SW_HIDE)
			If _Sleep(1000) Then Return ; Give OS time to work
		EndIf
		If ProcessExists($aBS_FileNames[$iIndex][1]) Then ; If it is still running, then force kill it
			If $g_iDebugSetlog = 1 Then Setlog($aBS_FileNames[$iIndex][0] & " 1st Kill failed, trying again", $COLOR_DEBUG)
			ShellExecute(@WindowsDir & "\System32\taskkill.exe", "-f -t -pid " & $aBS_FileNames[$iIndex][1], "", Default, @SW_HIDE)
			If _Sleep(500) Then Return ; Give OS time to work
		EndIf
	Next

EndFunc   ;==>KillBSProcess


Func ServiceStop($sServiceName)

	Local $ServiceRunning, $svcWaitIterations, $data, $pid, $hTimer, $bFailed, $Result

	$hTimer = TimerInit()

	$Result = RunWait(@ComSpec & " /c " & 'net stop ' & $sServiceName, "", @SW_HIDE)
	If @error Then
		Setlog("net stop service failed on " & $sServiceName & ", Result= " & $Result, $COLOR_ERROR)
		SetError(1, @extended, -1)
		Return
	EndIf

	$ServiceRunning = True
	$svcWaitIterations = 0

	While $ServiceRunning ; check if service is stopped yet
		_StatusUpdateTime($hTimer, "BS Service Stop")
		$data = ""
		$pid = Run(@WindowsDir & '\System32\sc.exe query ' & $sServiceName, '', @SW_HIDE, 2)
		Do
			$data &= StdoutRead($pid)
		Until @error
		StdioClose($pid)
		$Result = StringInStr($data, "stopped")
		$bFailed = StringInStr($data, "failed")
		;		If $g_iDebugSetlog = 1 Then
		;			SetLog($sServiceName & " stop status= " & $Result, $COLOR_DEBUG)
		;			SetLog("StdOutRead= " & $data, $COLOR_DEBUG)
		;		EndIf
		If $Result Then
			$ServiceRunning = False
		EndIf
		$svcWaitIterations = $svcWaitIterations + 1
		If $svcWaitIterations > 15 Or $bFailed Then ; If trouble reading service stopped, abort
			SetError(1, @extended, -1)
			$ServiceRunning = False
		EndIf
		If _Sleep(1000) Then Return ; Loop delay check for close every 1 second
	WEnd
	If $g_iDebugSetlog = 1 And $svcWaitIterations > 15 Then
		SetLog("Failed to stop service " & $sServiceName, $COLOR_ERROR)
	Else
		If $g_iDebugSetlog = 1 Then SetLog($sServiceName & "Service stopped successfully", $COLOR_SUCCESS)
	EndIf
EndFunc   ;==>ServiceStop

Func CloseUnsupportedBlueStacks2()
	Local $WinTitleMatchMode = Opt("WinTitleMatchMode", -3) ; in recent 2.3.x can be also "BlueStacks App Player"
	If IsArray(ControlGetPos("Bluestacks App Player", "", "")) Then ; $g_avAndroidAppConfig[1][4]
		Opt("WinTitleMatchMode", $WinTitleMatchMode)
		; Offical "Bluestacks App Player" v2.0 not supported because it changes the Android Screen!!!
		SetLog("MyBot doesn't work with " & $g_sAndroidEmulator & " App Player", $COLOR_ERROR)
		SetLog("Please let MyBot start " & $g_sAndroidEmulator & " automatically", $COLOR_INFO)
		RebootBlueStacks2SetScreen(False)
		Return True
	EndIf
	Opt("WinTitleMatchMode", $WinTitleMatchMode)
	Return False
EndFunc   ;==>CloseUnsupportedBlueStacks2


