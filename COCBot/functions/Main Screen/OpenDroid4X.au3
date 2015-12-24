; #FUNCTION# ====================================================================================================================
; Name ..........: OpenDroid4X
; Description ...: Opens new Droid4X instance
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (2015-12)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenDroid4X($bRestart = False)

	Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdExe, $cmdPar

	SetLog("Starting " & $Android & " and Clash Of Clans", $COLOR_GREEN)

	If Not InitDroid4X() Then Return

   $cmdExe = $__Droid4X_Path & "Droid4X.exe"
   $cmdPar = ($AndroidInstance = "" ? "" : "-o " & $AndroidInstance)
   If ProcessExists2($cmdExe & ($cmdPar = "" ? "" : " " & $cmdPar)) = 0 Then
	  ; Launch Droid4X
	  SetDebugLog("ShellExecute: " & $cmdExe & " " & $cmdPar)
	  $PID = ShellExecute($cmdExe, $cmdPar)
	  If _Sleep(1000) Then Return
	  If $PID <> 0 Then $PID = ProcessExists($PID)
	  SetDebugLog("$PID= "&$PID)
	  If $PID = 0 Then  ; IF ShellExecute failed
		SetLog("Unable to load " & $Android & ($AndroidInstance = "" ? "" : "(" & $AndroidInstance & ")") & ", please check emulator/installation.", $COLOR_RED)
		SetLog("Unable to continue........", $COLOR_MAROON)
		btnStop()
		SetError(1, 1, -1)
		Return
	  EndIf
   EndIf

   ; Test ADB is connected
   $cmdOutput = LaunchConsole($__Droid4X_Path & "adb.exe", "connect " & $AndroidAdbDevice, $process_killed)
   $connected_to = StringInStr($cmdOutput, "connected to")

   SetLog("Please wait while " & $Android & " and CoC starts...", $COLOR_GREEN)
   $hTimer = TimerInit()
   ; Wait for device
   $cmdOutput = LaunchConsole($__Droid4X_Path & "adb.exe", "-s " & $AndroidAdbDevice & " wait-for-device", $process_killed, 60 * 1000)
   If Not $RunState Then Return

   ; Wair for Activity Manager
   If WaitForAmDroid4X($AndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return

   ; Wait for UI Control, then CoC can be launched
   ;While Not IsArray(ControlGetPos($Title, $AppPaneName, $AppClassInstance)) And TimerDiff($hTimer) <= $AndroidLaunchWaitSec * 1000
   ;  If _Sleep(500) Then Return
   ;WEnd

	If TimerDiff($hTimer) >= $AndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
	  SetLog("Serious error has occurred, please restart PC and try again", $COLOR_RED)
	  SetLog($Android & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_RED)
	  SetError(1, @extended, False)
	  Return
	EndIf

    SetLog($Android & " Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_GREEN)

    ; Check Android screen size, position windows
    if InitiateLayout() Then Return; can also call OpenDroid4X again when screen size is adjusted

	; Launch CcC
	SetLog("Launch Clash of Clans now...", $COLOR_GREEN)
    LaunchConsole($__Droid4X_Path & "adb.exe", "-s " & $AndroidAdbDevice & " shell am start -S -n com.supercell.clashofclans/.GameApp", $process_killed, 30 * 1000) ; removed "-W" option and added timeout (didn't exit sometimes)

   $HWnD = WinGetHandle($Title) ; get window Handle
   ;DisableBS($HWnD, $SC_MINIMIZE)
   ;DisableBS($HWnD, $SC_CLOSE)
   If $bRestart = False Then
	  waitMainScreenMini()
	  If Not $RunState Then Return
	  Zoomout()
	  If Not $RunState Then Return
	  Initiate()
	  If Not $RunState Then Return
   Else
	  WaitMainScreenMini()
	  If Not $RunState Then Return
	  If @error = 1 Then
		  $Restart = True
		  $Is_ClientSyncError = False
		  Return
	  EndIf
	  Zoomout()
	  If Not $RunState Then Return
   EndIf

EndFunc   ;==>OpenDroid4X

Func InitDroid4X($bCheckOnly = False)
    Local $process_killed, $vmInfo, $aRegExResult, $AndroidAdbDeviceHost, $AndroidAdbDevicePort, $oops = 0

    $__Droid4X_Version = RegRead($HKLM & "\SOFTWARE" & $Wow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\Droid4X\", "DisplayVersion")
	$__Droid4X_Path = RegRead($HKLM & "\SOFTWARE\Droid4X\", "InstallDir") ; Doesn't exist (yet)
	If @error <> 0 Then ; work-a-round
	   Local $DisplayIcon = RegRead($HKLM & "\SOFTWARE" & $Wow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\Droid4X\", "DisplayIcon")
	   If @error = 0 Then
			Local $iLastBS = StringInStr($DisplayIcon, "\", 0, -1)
			$__Droid4X_Path = StringLeft($DisplayIcon, $iLastBS)
	   EndIf
    EndIf
	If @error <> 0 Then
		$__Droid4X_Path = @ProgramFilesDir & "\Droid4X\"
		SetError(0, 0, 0)
    EndIf

    $__VirtualBox_Path = RegRead($HKLM & "\SOFTWARE\Oracle\VirtualBox\", "InstallDir")
	If @error <> 0 Then
		$__VirtualBox_Path = @ProgramFilesDir & "\Oracle\VirtualBox\"
		SetError(0, 0, 0)
    EndIf

   If FileExists($__Droid4X_Path & "Droid4X.exe") = False Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find " & $Android & ":", $COLOR_RED)
		 SetLog($__Droid4X_Path & "Droid4X.exe", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   If FileExists($__Droid4X_Path & "adb.exe") = False Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find " & $Android & ":", $COLOR_RED)
		 SetLog($__Droid4X_Path & "adb.exe", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   If FileExists($__VirtualBox_Path & "VBoxManage.exe") = False Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find VirtualBox:", $COLOR_RED)
		 SetLog($__VirtualBox_Path & "VBoxManage.exe", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   ; Read ADB host and Port
   If Not $bCheckOnly Then
	  $vmInfo = LaunchConsole($__VirtualBox_Path & "VBoxManage.exe", "showvminfo " & $AndroidInstance, $process_killed)
	  $aRegExResult = StringRegExp($vmInfo, "ADB_PORT.*host ip = ([^,]+),", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $AndroidAdbDeviceHost = $aRegExResult[0]
		 If $debugSetlog = 1 Then Setlog("Func LaunchConsole: Read $AndroidAdbDeviceHost = " & $AndroidAdbDeviceHost, $COLOR_PURPLE)
	  Else
		 $oops = 1
		 SetLog("Cannot read " & $Android & "(" & $AndroidInstance & ") ADB Device Host", $COLOR_RED)
	  EndIF

	  $aRegExResult = StringRegExp($vmInfo, "ADB_PORT.*host port = (\d{3,5}),", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $AndroidAdbDevicePort = $aRegExResult[0]
		 If $debugSetlog = 1 Then Setlog("Func LaunchConsole: Read $AndroidAdbDevicePort = " & $AndroidAdbDevicePort, $COLOR_PURPLE)
	  Else
		 $oops = 1
		 SetLog("Cannot read " & $Android & "(" & $AndroidInstance & ") ADB Device Port", $COLOR_RED)
	  EndIF

	  If $oops = 0 Then
		 $AndroidAdbDevice = $AndroidAdbDeviceHost & ":" & $AndroidAdbDevicePort
	  Else ; use defaults
		 SetLog("Using ADB default device " & $AndroidAdbDevice & " for " & $Android, $COLOR_RED)
	  EndIf
	  ; update global variables
	  $AndroidAdbPath = $__Droid4X_Path & "adb.exe"
	  $AndroidVersion = $__Droid4X_Version
   EndIf

   Return True

EndFunc

Func WaitForAmDroid4X($WaitInSec, $hTimer = 0) ; doesn't work yet!!!
   Local $cmdOutput, $connected_to, $am_ready, $process_killed, $hMyTimer
	; Wait for Activity Manager
	$hMyTimer = ($hTimer = 0 ? TimerInit() : $hTimer)
	While True
	  ; Test ADB is connected
	  $cmdOutput = LaunchConsole($AndroidAdbPath, "connect " & $AndroidAdbDevice, $process_killed)
	  $connected_to = StringInStr($cmdOutput, "connected to")
	  $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell am display-size reset", $process_killed)
	  If $hTimer <> 0 Then _StatusUpdateTime($hTimer)
	  $am_ready = StringLen($cmdOutput) < 4
	  If $am_ready Then ExitLoop
	  If TimerDiff($hMyTimer) > $WaitInSec * 1000 Then ; if no device available in 4 minutes, Android/PC has major issue so exit
		 SetLog("Serious error has occurred, please restart PC and try again", $COLOR_RED)
		 SetLog($Android & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for activity manager", $COLOR_RED)
		 SetError(1, @extended, False)
		 Return True
	  EndIf
	  If _Sleep(1000) Then Return True
    WEnd
	Return False
EndFunc

Func RestartDroid4XCoC()

   If Not InitDroid4X() Then Return False

   Local $cmdOutput, $process_killed, $connected_to
   WinActivate($HWnD)  	; ensure bot has window focus

   ; Test ADB is connected
   ;$cmdOutput = LaunchConsole($__Droid4X_Path & "adb.exe", "connect " & $AndroidAdbDevice, $process_killed)
   ;$connected_to = StringInStr($cmdOutput, "connected to")

   SetLog("Please wait for CoC restart......", $COLOR_BLUE)   ; Let user know we need time...
   LaunchConsole($__Droid4X_Path & "adb.exe", "-s " & $AndroidAdbDevice & " shell am start -S -n com.supercell.clashofclans/.GameApp", $process_killed, 30 * 1000) ; removed "-W" option and added timeout (didn't exit sometimes)

   Return True
EndFunc

Func SetScreenDroid4X()

   If Not InitDroid4X() Then Return False

   Local $cmdOutput, $process_killed

   ; Set width and height
   $cmdOutput = LaunchConsole($__VirtualBox_Path & "VBoxManage.exe", "guestproperty set " & $AndroidInstance & " vbox_graph_mode " & $AndroidClientWidth & "x" & $AndroidClientHeight & "-16", $process_killed)

   ; Set dpi
   $cmdOutput = LaunchConsole($__VirtualBox_Path & "VBoxManage.exe", "guestproperty set " & $AndroidInstance & " vbox_dpi 160", $process_killed)

   Return True

EndFunc

Func RebootDroid4XSetScreen()

   RebootAndroidSetScreenDefault()

EndFunc