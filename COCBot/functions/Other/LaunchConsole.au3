; #FUNCTION# ====================================================================================================================
; Name ..........: LaunchConsole
; Description ...: Runs console application and returns output of STDIN and STDOUT
; Syntax ........:
; Parameters ....: $cmd, $param, ByRef $process_killed, $timeout = 0
; Return values .: None
; Author ........: Cosote (2015-12)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
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
; Supports also PID as $ProgramPath parameter
; $CompareMode = 0 Path with parameter is compared (" ", '"' and "'" removed!)
; $CompareMode = 1 Any Command Line containing path and parameter is used
Func ProcessExists2($ProgramPath, $ProgramParameter = "", $CompareMode = 0, $strComputer = ".")

  If IsNumber($ProgramPath) Then Return ProcessExists($ProgramPath) ; Be compatible with ProcessExists

  Local $oWMI=ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2") ; ""
  SetDebugLog("ObjGet(""winmgmts:\\" & $strComputer & "\root\cimv2"")")
  If @error <> 0 Then
	 SetDebugLog("Cannot create ObjGet(""winmgmts:\\" & $strComputer & "\root\cimv2")
	 Return 0
  EndIf

  ; Win32_Process: https://msdn.microsoft.com/en-us/library/windows/desktop/aa394372(v=vs.85).aspx
  Local $commandLine = ($ProgramPath <> "" ? ('"' & $ProgramPath & '"' & ($ProgramParameter = "" ? "" : " " & $ProgramParameter)) : "")
  Local $commandLineCompare = StringReplace(StringReplace(StringReplace($commandLine, " ", ""), '"', ""), "'", "")
  Local $query = "Select * from Win32_Process where CommandLine like ""%" & StringReplace($ProgramPath,"\","\\") & "%"""
  SetDebugLog("WMI Query: " & $query)
  Local $oProcessColl = $oWMI.ExecQuery($query)
  Local $Process, $PID = 0, $i = 0

  For $Process In $oProcessColl
    SetDebugLog($Process.Handle & " = " & $Process.CommandLine)
	If $PID = 0 Then
	   If ($CompareMode = 0 And $commandLineCompare = StringReplace(StringReplace(StringReplace($Process.CommandLine, " ", ""), '"', ""), "'", "")) Or $CompareMode = 1 Then
		 $PID = $Process.Handle
		 ;ExitLoop
	   EndIf
    EndIf
	$i += 1
  Next
  If $PID = 0 Then
	 SetDebugLog("Process by CommandLine not found: " & $ProgramPath & ($ProgramParameter = "" ? "" : " " & $ProgramParameter))
  Else
     SetDebugLog("Found Process " & $PID & " by CommandLine: " & $ProgramPath & ($ProgramParameter = "" ? "" : " " & $ProgramParameter))
  EndIf

  Return $PID
EndFunc ;==>ProcessExists2

; Special version of ProcessExists2 that returns Array of all processes found
Func ProcessesExist($ProgramPath, $ProgramParameter = "", $CompareMode = 0, $strComputer=".")

  If IsNumber($ProgramPath) Then
	 Local $a[1] = [ProcessExists($ProgramPath)] ; Be compatible with ProcessExists
     Return $a
  EndIf
  Local $oWMI=ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2") ; ""
  SetDebugLog("ObjGet(""winmgmts:\\" & $strComputer & "\root\cimv2"")")
  If @error <> 0 Then
	 SetDebugLog("Cannot create ObjGet(""winmgmts:\\" & $strComputer & "\root\cimv2")
	 Local $a[0]
	 Return $a
  EndIf

  ; Win32_Process: https://msdn.microsoft.com/en-us/library/windows/desktop/aa394372(v=vs.85).aspx
  Local $commandLine = ($ProgramPath <> "" ? ('"' & $ProgramPath & '"' & ($ProgramParameter = "" ? "" : " " & $ProgramParameter)) : "")
  Local $commandLineCompare = StringReplace(StringReplace(StringReplace($commandLine, " ", ""), '"', ""), "'", "")
  Local $query = "Select * from Win32_Process where CommandLine like ""%" & StringReplace($ProgramPath,"\","\\") & "%"""
  SetDebugLog("WMI Query: " & $query)
  Local $oProcessColl = $oWMI.ExecQuery($query)
  Local $Process, $PID = 0, $i = 0
  Local $PIDs[0]

  For $Process In $oProcessColl
    SetDebugLog($Process.Handle & " = " & $Process.CommandLine)
	If ($CompareMode = 0 And $commandLineCompare = StringReplace(StringReplace(StringReplace($Process.CommandLine, " ", ""), '"', ""), "'", "")) Or $CompareMode = 1 Then
	   ReDim $PIDs[$i + 1]
	   $PIDs[$i] = $Process.Handle
	   $i += 1
    EndIf
  Next
  If $i = 0 Then
	 SetDebugLog("No process found by CommandLine: " & $ProgramPath & ($ProgramParameter = "" ? "" : " " & $ProgramParameter))
  Else
     SetDebugLog("Found " & $i & " process(es) with " & $ProgramPath & ($ProgramParameter = "" ? "" : " " & $ProgramParameter))
  EndIf

  Return $PIDs
EndFunc ;==>ProcessesExist

; Get complete Command Line by PID
Func ProcessGetCommandLine($PID, $strComputer = ".")

  If Not IsNumber($PID) Then Return SetError(2, 0, -1)

  Local $oWMI=ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2") ; ""
  SetDebugLog("ObjGet(""winmgmts:\\" & $strComputer & "\root\cimv2"")")
  If @error <> 0 Then
	 SetDebugLog("Cannot create ObjGet(""winmgmts:\\" & $strComputer & "\root\cimv2")
	 Return SetError(3, 0, -1)
  EndIf

  ; Win32_Process: https://msdn.microsoft.com/en-us/library/windows/desktop/aa394372(v=vs.85).aspx
  Local $commandLine
  Local $query = "Select * from Win32_Process where Handle = " & $PID
  SetDebugLog("WMI Query: " & $query)
  Local $oProcessColl = $oWMI.ExecQuery($query)
  Local $Process, $i = 0

  For $Process In $oProcessColl
    SetDebugLog($Process.Handle & " = " & $Process.CommandLine)
	SetError(0, 0, 0)
	Return $Process.CommandLine
  Next
  SetDebugLog("Process not found with PID " & $PID)
  Return SetError(1, 0, -1)
EndFunc ;==>ProcessExists2
