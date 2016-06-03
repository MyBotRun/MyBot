
; #FUNCTION# ====================================================================================================================
; Name ..........: CloseBS
; Description ...:  Forces BS processes to close, and watches BS processes and services to make sure it has stopped
; Syntax ........: CloseBS()
; Parameters ....: None
; Return values .: @error = 1 if failure
; Author ........: The Master1 (From CGB Forums Aug2015)
; Modified ......: KnowJack (August 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CloseBS() ; @deprecated, use CloseAndroid()
	CloseAndroid()
EndFunc   ;==>CloseBS

Func CloseBlueStacks()
	Local $iIndex, $bOops = False
	Local $aServiceList[4] = ["BstHdAndroidSv", "BstHdLogRotatorSvc", "BstHdUpdaterSvc", "bthserv"]

	SetLog("Stopping BlueStacks ....", $COLOR_BLUE)

	If Not InitAndroid() Then Return

	RunWait($__BlueStacks_Path & "HD-Quit.exe")
	If @error <> 0 Then
		SetLog($Android & " failed to quit", $COLOR_RED)
		;SetError(1, @extended, -1)
		;Return False
	EndIf

	If _Sleep(2000) Then Return ; wait a bit

	; Check if HD-FrontEnd.exe terminated
	$bOops = ProcessExists("HD-Frontend.exe") <> 0

	If $bOops Then
		$bOops = False
		SetDebugLog("Failed to terminate HD-Frontend.exe with HD-Quit.exe, fallback to taskkill", $COLOR_RED)
		KillBSProcess()
		If _Sleep(1000) Then Return ; wait a bit

		SetLog("Please wait for full BS shutdown....", $COLOR_GREEN)

		For $iIndex = 0 To UBound($aServiceList) - 1
			ServiceStop($aServiceList[$iIndex])
			If @error Then
				$bOops = True
				If $debugsetlog = 1 Then Setlog($aServiceList[$iIndex] & "errored trying to stop", $COLOR_MAROON)
			EndIf
		Next
		If $bOops Then
			If $debugsetlog = 1 Then Setlog("Service Stop issues, Stopping BS 2nd time", $COLOR_MAROON)
			KillBSProcess()
			If _SleepStatus(5000) Then Return
		EndIf
	EndIf


	If $debugsetlog = 1 And $bOops Then
		SetLog("BS Kill Failed to stop service", $COLOR_RED)
	ElseIf Not $bOops Then
		SetLog("BS stopped successfully", $COLOR_GREEN)
	EndIf

	RemoveGhostTrayIcons("BlueStacks") ; Remove ghost BS icon if left behind due forced taskkill

	If $bOops Then
		SetError(1, @extended, -1)
	EndIf

EndFunc   ;==>CloseBlueStacks

Func CloseBlueStacks2()

	Local $bOops = False

	SetLog("Stopping " & $Android & "....", $COLOR_BLUE)

	If Not InitAndroid() Then Return

	RunWait($__BlueStacks_Path & "HD-Quit.exe")
	If @error <> 0 Then
		SetLog($Android & " failed to quit", $COLOR_RED)
		;SetError(1, @extended, -1)
		;Return False
	EndIf

	If _Sleep(2000) Then Return ; wait a bit

	; Check if HD-FrontEnd.exe terminated
	$bOops = ProcessExists2($AndroidProgramPath) <> 0

	If $debugsetlog = 1 And $bOops Then
		SetLog($Android & " failed to quit all processes", $COLOR_RED)
	ElseIf Not $bOops Then
		SetLog($Android & " stopped successfully", $COLOR_GREEN)
	EndIf

	;RemoveGhostTrayIcons("BlueStacks Agent Online")  ; Remove ghost BS icon if left behind due forced taskkill, early BS2 version
	RemoveGhostTrayIcons("App Player Online") ; Remove ghost BS icon if left behind due forced taskkill

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
		If $debugsetlog = 1 Then Setlog($aBS_FileNames[$iIndex][0] & " PID = " & $aBS_FileNames[$iIndex][1], $COLOR_PURPLE)
		If $aBS_FileNames[$iIndex][1] > 0 Then ; If it is running, then kill it
			ShellExecute(@WindowsDir & "\System32\taskkill.exe", " -t -pid " & $aBS_FileNames[$iIndex][1], "", Default, @SW_HIDE)
			If _Sleep(1000) Then Return ; Give OS time to work
		EndIf
		If ProcessExists($aBS_FileNames[$iIndex][1]) Then ; If it is still running, then force kill it
			If $debugsetlog = 1 Then Setlog($aBS_FileNames[$iIndex][0] & " 1st Kill failed, trying again", $COLOR_PURPLE)
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
		Setlog("net stop service failed on " & $sServiceName & ", Result= " & $Result, $COLOR_RED)
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
		$Result = StringInStr($data, "stopped")
		$bFailed = StringInStr($data, "failed")
		;		If $debugsetlog = 1 Then
		;			SetLog($sServiceName & " stop status= " & $Result, $COLOR_PURPLE)
		;			SetLog("StdOutRead= " & $data, $COLOR_PURPLE)
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
	If $debugsetlog = 1 And $svcWaitIterations > 15 Then
		SetLog("Failed to stop service " & $sServiceName, $COLOR_RED)
	Else
		If $debugsetlog = 1 Then SetLog($sServiceName & "Service stopped successfully", $COLOR_GREEN)
	EndIf
EndFunc   ;==>ServiceStop

Func CloseUnsupportedBlueStacks2()
	If IsArray(ControlGetPos("Bluestacks App Player", "", "")) Then ; $AndroidAppConfig[1][4]
		; Offical "Bluestacks App Player" v2.0 not supported because it changes the Android Screen!!!
		SetLog("MyBot doesn't work with " & $Android & " App Player", $COLOR_RED)
		SetLog("Please let MyBot start " & $Android & " automatically", $COLOR_BLUE)
		RebootBlueStacks2SetScreen(False)
		Return True
	EndIf
	Return False
EndFunc   ;==>CloseUnsupportedBlueStacks2


