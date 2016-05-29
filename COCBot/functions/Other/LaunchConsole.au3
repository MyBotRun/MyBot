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

Func LaunchConsole($cmd, $param, ByRef $process_killed, $timeout = 10000)

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
   ;#cs
   Local $timeout_sec = Round($timeout / 1000)
   If $timeout > 0 And $timeout_sec = 0 Then $timeout_sec = 1
   ProcessWaitClose($pid, $timeout_sec)
   $data &= StdoutRead($pid)
   $data &= StderrRead($pid)
   CleanLaunchOutput($data)
   ;#ce
   #cs
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
   #ce

   If ProcessExists($pid) Then
	 If ProcessClose($pid) = 1 Then
		If $debugSetlog = 1 Then SetLog("Process killed: " & $cmd, $COLOR_RED)
		$process_killed = True
	 EndIf
   EndIf
   ProcessWaitClose($pid, $timeout_sec)
   StdioClose($pid)
   If $debugSetlog = 1 Then Setlog("Func LaunchConsole Output: " & $data, $COLOR_PURPLE) ; Debug Run Output
   Return $data
EndFunc   ;==>LaunchConsole

; Special version of ProcessExists that checks process based on full process image path AND parameters
; Supports also PID as $ProgramPath parameter
; $CompareMode = 0 Path with parameter is compared (" ", '"' and "'" removed!)
; $CompareMode = 1 Any Command Line containing path and parameter is used
; $SearchMode = 0 Search only for $ProgramPath
; $SearchMode = 1 Search for $ProgramPath and $ProgramParameter
; $CompareParameterFunc is func that returns True or False if parameter is matching, "" not used
Func ProcessExists2($ProgramPath, $ProgramParameter = Default, $CompareMode = Default, $SearchMode = 0, $CompareCommandLineFunc = "", $strComputer = ".")

  If $ProgramParameter = Default Then
	 $ProgramParameter = ""
	 If $CompareMode = Default Then $CompareMode = 1
  EndIf

  If $CompareMode = Default Then
	 $CompareMode = 0
  EndIf

  If IsNumber($ProgramPath) Then Return ProcessExists($ProgramPath) ; Be compatible with ProcessExists

  Local $oWMI=ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2") ; ""
  SetDebugLog("ObjGet(""winmgmts:\\" & $strComputer & "\root\cimv2"")")
  If @error <> 0 Then
	 SetDebugLog("Cannot create ObjGet(""winmgmts:\\" & $strComputer & "\root\cimv2")
	 Return 0
  EndIf

  Local $exe = $ProgramPath
  Local $iLastBS = StringInStr($exe, "\", 0, -1)
  If $iLastBS > 0 Then $exe = StringMid($exe, $iLastBS + 1)
  ; Win32_Process: https://msdn.microsoft.com/en-us/library/windows/desktop/aa394372(v=vs.85).aspx
  Local $commandLine = ($ProgramPath <> "" ? ('"' & $ProgramPath & '"' & ($ProgramParameter = "" ? "" : " " & $ProgramParameter)) : $ProgramParameter)
  Local $commandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($commandLine, ".exe", "" , 1), " ", ""), '"', ""), "'", "")
  Local $query = "Select * from Win32_Process" ; replaced CommandLine with ExecutablePath
  If StringLen($commandLine) > 0 Then
	 $query &= " where "
	 If StringLen($ProgramPath) > 0 Then
		$query &= "ExecutablePath like ""%" & StringReplace($ProgramPath,"\","\\") & "%"""
		If $SearchMode = 1 And StringLen($ProgramParameter) > 0 Then $query &= " And "
     EndIf
     If $SearchMode = 1 And StringLen($ProgramParameter) > 0 Then $query &= "CommandLine like ""%" & StringReplace($ProgramParameter,"\","\\") & "%"""
  EndIf
  SetDebugLog("WMI Query: " & $query)
  ; https://msdn.microsoft.com/en-us/library/aa393866(v=vs.85).aspx
  Local $oProcessColl = $oWMI.ExecQuery($query)
  Local $Process, $PID = 0, $i = 0

  For $Process In $oProcessColl
    SetDebugLog($Process.Handle & " = " & $Process.ExecutablePath & " (" & $Process.CommandLine & ")")
	If $PID = 0 Then
	   Local $processCommandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($Process.CommandLine, ".exe", "" , 1), " ", ""), '"', ""), "'", "")
	   If ($CompareMode = 0 And $commandLineCompare = $processCommandLineCompare) Or _
		  ($CompareMode = 0 And StringRight($commandLineCompare, StringLen($processCommandLineCompare)) = $processCommandLineCompare) Or _
		  ($CompareMode = 0 And $CompareCommandLineFunc <> "" and Execute($CompareCommandLineFunc & "(""" & StringReplace($Process.CommandLine,"""","") & """)") = True) Or _
		   $CompareMode = 1 Then
		 $PID = Number($Process.Handle)
		 ;ExitLoop
	   EndIf
    EndIf
	$i += 1
  Next
  If $PID = 0 Then
	 SetDebugLog("Process by CommandLine not found: " & $ProgramPath & ($ProgramParameter = "" ? "" : ($ProgramPath <> "" ? " " : "") & $ProgramParameter))
  Else
     SetDebugLog("Found Process " & $PID & " by CommandLine: " & $ProgramPath & ($ProgramParameter = "" ? "" : ($ProgramPath <> "" ? " " : "") & $ProgramParameter))
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

  Local $exe = $ProgramPath
  Local $iLastBS = StringInStr($exe, "\", 0, -1)
  If $iLastBS > 0 Then $exe = StringMid($exe, $iLastBS + 1)
  ; Win32_Process: https://msdn.microsoft.com/en-us/library/windows/desktop/aa394372(v=vs.85).aspx
  Local $commandLine = ($ProgramPath <> "" ? ('"' & $ProgramPath & '"' & ($ProgramParameter = "" ? "" : " " & $ProgramParameter)) : $ProgramParameter)
  Local $commandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($commandLine, ".exe", "" , 1), " ", ""), '"', ""), "'", "")
  Local $query = "Select * from Win32_Process where ExecutablePath like ""%" & StringReplace($ProgramPath,"\","\\") & "%""" ; replaced CommandLine with ExecutablePath
  SetDebugLog("WMI Query: " & $query)
  Local $oProcessColl = $oWMI.ExecQuery($query)
  Local $Process, $PID = 0, $i = 0
  Local $PIDs[0]

  For $Process In $oProcessColl
    SetDebugLog($Process.Handle & " = " & $Process.ExecutablePath)
	Local $processCommandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($Process.CommandLine, ".exe", "" , 1), " ", ""), '"', ""), "'", "")
	If ($CompareMode = 0 And $commandLineCompare = $processCommandLineCompare) Or _
	   ($CompareMode = 0 And StringRight($commandLineCompare, StringLen($processCommandLineCompare)) = $processCommandLineCompare) Or _
		$CompareMode = 1 Then
	   ReDim $PIDs[$i + 1]
	   $PIDs[$i] = Number($Process.Handle)
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

Func CleanLaunchOutput(ByRef $output)
   ;$output = StringReplace($output, @LF & @LF, "")
   $output = StringReplace($output,  @CR & @CR, "")
   $output = StringReplace($output,  @CRLF & @CRLF, "")
   If StringRight($output, 1) = @LF Then $output = StringLeft($output, StringLen($output) - 1)
   If StringRight($output, 1) = @CR Then $output = StringLeft($output, StringLen($output) - 1)
EndFunc
