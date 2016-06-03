; #FUNCTION# ====================================================================================================================
; Name ..........: CloseDroid4X
; Description ...: Forces Droid4X processes to close, and watches processes and services to make sure it has stopped
; Syntax ........: CloseDroid4X()
; Parameters ....: None
; Return values .: @error = 1 if failure
; Author ........: cosote
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CloseDroid4X()

	Local $iIndex, $bOops = False, $process_killed
	Local $aServiceList[0] = [] ; ["BstHdAndroidSv", "BstHdLogRotatorSvc", "BstHdUpdaterSvc", "bthserv"]

	SetLog("Stopping Droid4X...", $COLOR_BLUE)

	$bOops = KillDroid4XProcess()

	SetLog("Please wait for full Droid4X shutdown...", $COLOR_GREEN)

	If _Sleep(1000) Then Return ; wait a bit

	For $iIndex = 0 To UBound($aServiceList) - 1
		ServiceStop($aServiceList[$iIndex])
		If @error Then
			$bOops = True
			If $debugsetlog = 1 Then Setlog($aServiceList[$iIndex] & " errored trying to stop", $COLOR_MAROON)
		EndIf
	Next
	If $bOops Then
		If $debugsetlog = 1 Then Setlog("Service Stop issues, Stopping Droid4X 2nd time", $COLOR_MAROON)
		KillDroid4XProcess()
		If _SleepStatus(5000) Then Return
	EndIf

	; also stop virtualbox instance
	LaunchConsole($__VBoxManage_Path, "controlvm " & $AndroidInstance & " poweroff", $process_killed)
	If _SleepStatus(3000) Then Return

	If $debugsetlog = 1 And $bOops Then
		SetLog("Droid4X Kill Failed to stop service", $COLOR_RED)
	ElseIf Not $bOops Then
		SetLog("Droid4X stopped successfully", $COLOR_GREEN)
	EndIf

	RemoveGhostTrayIcons($Title) ; Remove ghost icon if left behind due forced taskkill

	If $bOops Then
		SetError(1, @extended, -1)
	EndIf

EndFunc   ;==>CloseDroid4X

Func KillDroid4XProcess()
	#cs
		Local $iIndex, $iCount, $bOops = False
		Local $aFileNames[2][2] = [['Droid4X.exe', 0], ['adb.exe', 0]]

		For $iIndex = 0 To UBound($aFileNames) - 1
		$iCount = 0
		While ProcessExists($aFileNames[$iIndex][0]) And $iCount < 3
		$aFileNames[$iIndex][1] = ProcessExists($aFileNames[$iIndex][0]) ; Find the PID for each file name that is running
		If $debugsetlog = 1 Then Setlog($aFileNames[$iIndex][0] & " PID = " & $aFileNames[$iIndex][1], $COLOR_PURPLE)
		If $aFileNames[$iIndex][1] > 0 Then ; If it is running, then kill it
		ShellExecute(@WindowsDir & "\System32\taskkill.exe", " -pid " & $aFileNames[$iIndex][1], "", Default, @SW_HIDE)
		If _Sleep(5000) Then Return ; Give OS time to work
		EndIf
		If ProcessExists($aFileNames[$iIndex][1]) Then ; If it is still running, then force kill it
		If $debugsetlog = 1 Then Setlog($aFileNames[$iIndex][0] & " 1st Kill failed, trying again", $COLOR_PURPLE)
		ShellExecute(@WindowsDir & "\System32\taskkill.exe", "-f -t -pid " & $aFileNames[$iIndex][1], "", Default, @SW_HIDE)
		If _Sleep(5000) Then Return ; Give OS time to work
		EndIf
		$iCount += 1
		WEnd
		If ProcessExists($aFileNames[$iIndex][0]) Then
		$bOops = True
		EndIf
		Next

		Return $bOops
	#ce
	; kill only my instances
	Local $pid = WinGetProcess(WinGetAndroidHandle())
	If $pid <> -1 Then
		If ProcessClose($pid) = 0 Then
			ShellExecute(@WindowsDir & "\System32\taskkill.exe", "-f -t -pid " & $pid, "", Default, @SW_HIDE)
		EndIf
	EndIf
	If ProcessExists($AndroidAdbPid) Then
		If ProcessClose($AndroidAdbPid) = 0 Then
			ShellExecute(@WindowsDir & "\System32\taskkill.exe", "-f -t -pid " & $AndroidAdbPid, "", Default, @SW_HIDE)
		EndIf
	EndIf

EndFunc   ;==>KillDroid4XProcess


