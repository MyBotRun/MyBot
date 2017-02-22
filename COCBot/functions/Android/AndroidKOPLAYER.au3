; #FUNCTION# ====================================================================================================================
; Name ..........: OpenKOPLAYER
; Description ...: Opens new KOPLAYER instance
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (2016-04)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenKOPLAYER($bRestart = False)

   Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdPar

   SetLog("Starting " & $g_sAndroidEmulator & " and Clash Of Clans", $COLOR_GREEN)

   If Not InitAndroid() Then Return

   Local $launchAndroid = (WinGetAndroidHandle() = 0 ? True : False)
   If $launchAndroid Then
	  ; Launch KOPLAYER
	  $cmdPar = GetAndroidProgramParameter() & " -t " & $g_sAndroidInstance
	  SetDebugLog("ShellExecute: " & $g_sAndroidProgramPath & " " & $cmdPar)
	  $PID = ShellExecute($g_sAndroidProgramPath, $cmdPar, $__KOPLAYER_Path)
	  If _Sleep(1000) Then Return
	  If $PID <> 0 Then $PID = ProcessExists($PID)
	  SetDebugLog("$PID= "&$PID)
	  If $PID = 0 Then  ; IF ShellExecute failed
		SetLog("Unable to load " & $g_sAndroidEmulator & ($g_sAndroidInstance = "" ? "" : "(" & $g_sAndroidInstance & ")") & ", please check emulator/installation.", $COLOR_RED)
		SetLog("Unable to continue........", $COLOR_MAROON)
		btnStop()
		SetError(1, 1, -1)
		Return
	 EndIf
   EndIf

   SetLog("Please wait while " & $g_sAndroidEmulator & " and CoC start...", $COLOR_GREEN)
   $hTimer = TimerInit()

   ; Test ADB is connected
   $connected_to = ConnectAndroidAdb(False, 60 * 1000)
   If Not $g_bRunState Then Return

   If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return

	If TimerDiff($hTimer) >= $g_iAndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
	  SetLog("Serious error has occurred, please restart PC and try again", $COLOR_RED)
	  SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_RED)
	  SetError(1, @extended, False)
	  Return
	EndIf

    SetLog($g_sAndroidEmulator & " Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_GREEN)

EndFunc   ;==>OpenKOPLAYER

Func GetKOPLAYERProgramParameter($bAlternative = False)
   If Not $bAlternative Or $g_sAndroidInstance <> $g_avAndroidAppConfig[$g_iAndroidConfig][1] Then
	  ; should be launched with these parameter
	  Return "-n " & ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance)
   EndIf
   ; default instance gets launched as name "default" but vbox instance name is KOPLAYER (this is the alternative way)
   Return "-n default"
EndFunc

Func IsKOPLAYERCommandLine($CommandLine)
   SetDebugLog($CommandLine)
   Local $param1 = GetKOPLAYERProgramParameter()
   Local $param2 = GetKOPLAYERProgramParameter(True)
   If StringInStr($CommandLine, $param1 & " ") > 0 Or StringRight($CommandLine, StringLen($param1)) = $param1 Then Return True
   If StringInStr($CommandLine, $param2 & " ") > 0 Or StringRight($CommandLine, StringLen($param2)) = $param2 Then Return True
   Return False
EndFunc

Func GetKOPLAYERPath()
   Local $KOPLAYER_Path = RegRead($g_sHKLM & "\SOFTWARE\KOPLAYER\SETUP\", "InstallPath")
   If $KOPLAYER_Path = "" Then ; work-a-round
	  $KOPLAYER_Path = @ProgramFilesDir & "\KOPLAYER\"
   Else
	  If StringRight($KOPLAYER_Path, 1) <> "\" Then $KOPLAYER_Path &= "\"
   EndIf
   Return StringReplace($KOPLAYER_Path, "\\", "\")
EndFunc

Func GetKOPLAYERAdbPath()
   Local $adbPath = GetKOPLAYERPath() & "Tools\adb.exe"
   If FileExists($adbPath) Then Return $adbPath
   Return ""
EndFunc

Func InitKOPLAYER($bCheckOnly = False)
   Local $process_killed, $aRegExResult, $g_sAndroidAdbDeviceHost, $g_sAndroidAdbDevicePort, $oops = 0
   Local $KOPLAYERVersion = RegRead($g_sHKLM & "\SOFTWARE\KOPLAYER\SETUP\", "Version")
   SetError(0, 0, 0)
   ; Could also read KOPLAYER paths from environment variables KOPLAYER_Path and KOPLAYERHyperv_Path
   Local $KOPLAYER_Path = GetKOPLAYERPath()
   Local $KOPLAYER_Manage_Path = $KOPLAYER_Path & "vbox\VBoxManage.exe"

   If FileExists($KOPLAYER_Path & "KOPLAYER.exe") = False Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_RED)
		 SetLog($KOPLAYER_Path & "KOPLAYER.exe", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   If FileExists(GetKOPLAYERAdbPath()) = False Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_RED)
		 SetLog($KOPLAYER_Path & "adb.exe", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   If FileExists($KOPLAYER_Manage_Path) = False Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find KOPLAYER-VBoxManage:", $COLOR_RED)
		 SetLog($KOPLAYER_Manage_Path, $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   ; Read ADB host and Port
   If Not $bCheckOnly Then
	  InitAndroidConfig(True) ; Restore default config

	  $__VBoxVMinfo = LaunchConsole($KOPLAYER_Manage_Path, "showvminfo " & $g_sAndroidInstance, $process_killed)
	  ; check if instance is known
	  If StringInStr($__VBoxVMinfo, "Could not find a registered machine named") > 0 Then
		 ; Unknown vm
		 SetLog("Cannot find " & $g_sAndroidEmulator & " instance " & $g_sAndroidInstance, $COLOR_RED)
		 Return False
	  EndIf
	  ; update global variables
	  $g_sAndroidProgramPath = $KOPLAYER_Path & "KOPLAYER.exe"
	  $g_sAndroidAdbPath = FindPreferredAdbPath()
	  If $g_sAndroidAdbPath = "" Then $g_sAndroidAdbPath = GetKOPLAYERAdbPath()
	  $g_sAndroidVersion = $KOPLAYERVersion
	  $__KOPLAYER_Path = $KOPLAYER_Path
	  $__VBoxManage_Path = $KOPLAYER_Manage_Path
	  $aRegExResult = StringRegExp($__VBoxVMinfo, "name = .*host ip = ([^,]*),.*guest port = 5555", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $g_sAndroidAdbDeviceHost = $aRegExResult[0]
		 If $g_sAndroidAdbDeviceHost = "" Then $g_sAndroidAdbDeviceHost = "127.0.0.1"
		 If $g_iDebugSetlog = 1 Then Setlog("Func LaunchConsole: Read $g_sAndroidAdbDeviceHost = " & $g_sAndroidAdbDeviceHost, $COLOR_PURPLE)
	  Else
		 $oops = 1
		 SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Host", $COLOR_RED)
	  EndIF

	  $aRegExResult = StringRegExp($__VBoxVMinfo, "name = .*host port = (\d{3,5}),.*guest port = 5555", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $g_sAndroidAdbDevicePort = $aRegExResult[0]
		 If $g_iDebugSetlog = 1 Then Setlog("Func LaunchConsole: Read $g_sAndroidAdbDevicePort = " & $g_sAndroidAdbDevicePort, $COLOR_PURPLE)
	  Else
		 $oops = 1
		 SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Port", $COLOR_RED)
	  EndIF

	  If $oops = 0 Then
		 $g_sAndroidAdbDevice = $g_sAndroidAdbDeviceHost & ":" & $g_sAndroidAdbDevicePort
	  Else ; use defaults
		 SetLog("Using ADB default device " & $g_sAndroidAdbDevice & " for " & $g_sAndroidEmulator, $COLOR_RED)
	  EndIf

	  ; get screencap paths: Name: 'picture', Host path: 'C:\Users\Administrator\Pictures\KOPLAYER Photo' (machine mapping), writable
	  $g_sAndroidPicturesPath = "/mnt/shared/UserData/"
	  $aRegExResult = StringRegExp($__VBoxVMinfo, "Name: 'UserData', Host path: '(.*)'.*", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $g_sAndroidPicturesHostPath = StringReplace($aRegExResult[0], "/", "\") & "\"
	  Else
		 $g_bAndroidAdbScreencap = False
		 $g_sAndroidPicturesHostPath = ""
		 SetLog($g_sAndroidEmulator & " Background Mode is not available", $COLOR_RED)
	  EndIf

	  $__VBoxGuestProperties = LaunchConsole($__VBoxManage_Path, "guestproperty enumerate " & $g_sAndroidInstance, $process_killed)
   EndIf

   Return True

EndFunc

Func SetScreenKOPLAYER()

   If Not InitAndroid() Then Return False

   Local $cmdOutput, $process_killed

   ; Set width and height
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_graph_mode " & $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight & "-16", $process_killed)
   ; Set dpi
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_dpi 160", $process_killed)

   Return True

EndFunc

Func RebootKOPLAYERSetScreen()

   Return RebootAndroidSetScreenDefault()

EndFunc

Func CloseKOPLAYER()

	Return CloseVboxAndroidSvc()

EndFunc   ;==>CloseKOPLAYER

Func CheckScreenKOPLAYER($bSetLog = True)

   If Not InitAndroid() Then Return False

   Local $aValues[2][2] = [ _
	  ["vbox_dpi", "160"], _
	  ["vbox_graph_mode", $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight & "-16"] _
   ]
   Local $i, $Value, $iErrCnt = 0, $process_killed, $aRegExResult

   For $i = 0 To UBound($aValues) -1
	  $aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: " & $aValues[$i][0] & ", value: (.+), timestamp:", $STR_REGEXPARRAYMATCH)
	  If @error = 0 Then $Value = $aRegExResult[0]
	  If $Value <> $aValues[$i][1] Then
		 If $iErrCnt = 0 Then
			If $bSetLog Then
			   SetLog("MyBot doesn't work with " & $g_sAndroidEmulator & " screen configuration!", $COLOR_RED)
			Else
			   SetDebugLog("MyBot doesn't work with " & $g_sAndroidEmulator & " screen configuration!", $COLOR_RED)
			EndIf
		 EndIf
		 If $bSetLog Then
			SetLog("Setting of " & $aValues[$i][0] & " is " & $Value & " and will be changed to " & $aValues[$i][1], $COLOR_RED)
		 Else
			SetDebugLog("Setting of " & $aValues[$i][0] & " is " & $Value & " and will be changed to " & $aValues[$i][1], $COLOR_RED)
		 EndIf
		 $iErrCnt += 1
	  EndIf
   Next
   If $iErrCnt > 0 Then Return False
   Return True

EndFunc

Func EmbedKOPLAYER($bEmbed = Default)

	If $bEmbed = Default Then $bEmbed = $g_bAndroidEmbedded

	; Find Qt5QWindowToolSaveBits Window
	Local $aWin = _WinAPI_EnumProcessWindows(GetAndroidPid(), False)
	Local $i
	Local $hTool = 0

	For $i = 1 To UBound($aWin) - 1
		Local $h = $aWin[$i][0]
		Local $c = $aWin[$i][1]
		If $c = "Qt5QWindowToolSaveBits" Then
			$hTool = $h
			ExitLoop
		EndIf
	Next

	If $hTool = 0 Then
		SetDebugLog("EmbedKOPLAYER(" & $bEmbed & "): Qt5QWindowToolSaveBits Window not found, list of windows:" & $c, Default, True)
		For $i = 1 To UBound($aWin) - 1
			Local $h = $aWin[$i][0]
			Local $c = $aWin[$i][1]
			SetDebugLog("EmbedKOPLAYER(" & $bEmbed & "): Handle = " & $h & ", Class = " & $c, Default, True)
		Next
	Else
		SetDebugLog("EmbedKOPLAYER(" & $bEmbed & "): $hTool=" & $hTool, Default, True)
		WinMove2($hTool, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
		_WinAPI_ShowWindow($hTool, ($bEmbed ? @SW_HIDE : @SW_SHOWNOACTIVATE))
	EndIf

EndFunc   ;==>EmbedLeapDroid