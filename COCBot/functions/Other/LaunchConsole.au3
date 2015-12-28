; #FUNCTION# ====================================================================================================================
; Name ..........: LaunchConsole
; Description ...: Runs console application and returns output of STDIN and STDOUT
; Syntax ........:
; Parameters ....: $cmd, $param, ByRef $process_killed, $timeout = 0
; Return values .: None
; Author ........: Cosote (2015-12)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func LaunchConsole($cmd, $param, ByRef $process_killed, $timeout = 0)

   Local $data, $pid, $hTimer

   If StringLen($param) > 0 Then $cmd &= " " & $param

   $hTimer = TimerInit()
   $process_killed = False

   If $debugSetlog = 1 Then Setlog("Func LaunchConsole: " & $cmd, $COLOR_PURPLE) ; Debug Run
   $pid = Run($cmd, "", @SW_HIDE, $STDERR_MERGED)
   If $debugSetlog = 1 Then Setlog("Func LaunchConsole: command launched", $COLOR_PURPLE)
   If $pid = 0 Then
	  SetLog("Launch faild: " & $cmd, $COLOR_RED)
	  Return
   EndIf

   $data = ""
   ; Wait here if no timeout defined
   If $timeout < 1 Then
	  ProcessWaitClose($pid)
	  $data &= StdoutRead($pid)
	  $data &= StderrRead($pid)
   Else
	  While True
		 _StatusUpdateTime($hTimer)
		 If $debugSetlog = 1 Then Setlog("Func LaunchConsole: StdoutRead...", $COLOR_PURPLE)
		 $data &= StdoutRead($pid)
		 If @error Then ExitLoop
		 $data &= StderrRead($pid)
		 If _Sleep(1000) Or ($timeout > 0 And TimerDiff($hTimer) > $timeout) Then
			ExitLoop
		 EndIf
		 If $debugSetlog = 1 Then Setlog("Func LaunchConsole: StdoutRead loop", $COLOR_PURPLE)
	  WEnd
   EndIf

   If ProcessExists($pid) Then
	 If ProcessClose($pid) = 1 Then
		If $debugSetlog = 1 Then SetLog("Process killed: " & $cmd, $COLOR_RED)
		$process_killed = True
	 EndIf
   EndIf
   ProcessWaitClose($pid)
   StdioClose($pid)
   If $debugSetlog = 1 Then Setlog("Func LaunchConsole Output: " & $data, $COLOR_PURPLE) ; Debug Run Output
   Return $data
EndFunc   ;==>LaunchConsole

; Special version of ProcessExists that checks process based on full process image path AND parameters
; Supports also PID as $sCommandLine parameter
Func ProcessExists2($sCommandLine, $strComputer=".")

  If IsNumber($sCommandLine) Then Return ProcessExists($sCommandLine) ; Be compatible with ProcessExists

  Local $oWMI=ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2") ; ""
  SetDebugLog("ObjGet(""winmgmts:\\" & $strComputer & "\root\cimv2"")")
  If @error <> 0 Then
	 SetDebugLog("Cannot create ObjGet(""winmgmts:\\" & $strComputer & "\root\cimv2")
	 Return 0
  EndIf

  ; Win32_Process: https://msdn.microsoft.com/en-us/library/windows/desktop/aa394372(v=vs.85).aspx
  Local $query = "Select * from Win32_Process where CommandLine like ""%" & StringReplace($sCommandLine,"\","\\") & "%"""
  SetDebugLog("WMI Query: " & $query)
  Local $oProcessColl = $oWMI.ExecQuery($query)
  Local $Process, $PID = 0, $i = 0

  For $Process In $oProcessColl
	$PID = $Process.Handle
	;ExitLoop
	$i += 1
  Next
  SetDebugLog("Found " & $i & " process(es) with " & $sCommandLine)
  If $PID = 0 Then
	 SetDebugLog("Process by CommandLine not found: " & $sCommandLine)
  Else
	 SetDebugLog("Found Process " & $PID & " by CommandLine: " & $sCommandLine)
  EndIf

  Return $PID
EndFunc ;==>ProcessExists2