; #FUNCTION# ====================================================================================================================
; Name ..........: AndroidNox
; Description ...: Nox Android functions
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (2016-02)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenNox($bRestart = False)

   Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdPar

   SetLog("Starting " & $Android & " and Clash Of Clans", $COLOR_GREEN)

   $launchAndroid = WinGetAndroidHandle() = 0
   If $launchAndroid Then
	  ; Launch Nox
	  $cmdPar = GetAndroidProgramParameter()
	  SetDebugLog("ShellExecute: " & $AndroidProgramPath & " " & $cmdPar)
	  $PID = ShellExecute($AndroidProgramPath, $cmdPar, $__Nox_Path)
	  If _Sleep(1000) Then Return False
	  If $PID <> 0 Then $PID = ProcessExists($PID)
	  SetDebugLog("$PID= "&$PID)
	  If $PID = 0 Then  ; IF ShellExecute failed
		SetLog("Unable to load " & $Android & ($AndroidInstance = "" ? "" : "(" & $AndroidInstance & ")") & ", please check emulator/installation.", $COLOR_RED)
		SetLog("Unable to continue........", $COLOR_MAROON)
		btnStop()
		SetError(1, 1, -1)
		Return False
	  EndIf
   EndIf

   SetLog("Please wait while " & $Android & " and CoC start...", $COLOR_GREEN)
   $hTimer = TimerInit()

   If WaitForRunningVMS($AndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return False

   ; update ADB port, as that can changes when Nox just started...
   $InitAndroid = True
   InitAndroid()

   ; Test ADB is connected
   $connected_to = ConnectAndroidAdb(False, 60 * 1000)
   If Not $RunState Then Return False

   ; Wair for boot to finish
   If WaitForAndroidBootCompleted($AndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return False

   If TimerDiff($hTimer) >= $AndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
	  SetLog("Serious error has occurred, please restart PC and try again", $COLOR_RED)
	  SetLog($Android & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_RED)
	  SetError(1, @extended, False)
	  Return False
   EndIf

   SetLog($Android & " Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_GREEN)

   Return True

EndFunc   ;==>OpenNox

Func IsNoxCommandLine($CommandLine)
   SetDebugLog($CommandLine)
   $CommandLine = StringReplace($CommandLine, GetNoxRtPath(), "")
   $CommandLine = StringReplace($CommandLine, "Nox.exe", "")
   Local $param1 = StringReplace(GetNoxProgramParameter(), """", "")
   Local $param2 = StringReplace(GetNoxProgramParameter(True), """", "")
   If StringInStr($CommandLine, $param1 & " ") > 0 Or StringRight($CommandLine, StringLen($param1)) = $param1 Then Return True
   If StringInStr($CommandLine, $param2 & " ") > 0 Or StringRight($CommandLine, StringLen($param2)) = $param2 Then Return True
   If StringInStr($CommandLine, "-clone:") = 0 And $param2 = "" Then Return True
   Return False
EndFunc

Func GetNoxProgramParameter($bAlternative = False)
   ; see http://en.bignox.com/blog/?p=354
   Local $customScreen = "-resolution:" & $AndroidClientWidth & "x" & $AndroidClientHeight & " -dpi:160"
   Local $clone = """-clone:" & ($AndroidInstance = "" ? $AndroidAppConfig[$AndroidConfig][1] : $AndroidInstance) & """"
   If $bAlternative = False Then
	  ; should be launched with these parameter
	  Return $customScreen & " " & $clone
   EndIf
   If $AndroidInstance = "" Or $AndroidInstance = $AndroidAppConfig[$AndroidConfig][1] Then Return ""
   ; default instance gets launched when no parameter was specified (this is the alternative way)
   Return $clone
EndFunc

Func GetNoxRtPath()
   Local $path = RegRead($HKLM & "\SOFTWARE\BigNox\VirtualBox\", "InstallDir")
   If @error = 0 Then
	  If StringRight($path, 1) <> "\" Then $path &= "\"
   Else
	  $path = @ProgramFilesDir & "\Bignox\BigNoxVM\RT\"
	  SetError(0, 0, 0)
   EndIf
   Return $path
EndFunc

Func GetNoxPath()
   Local $path = RegRead($HKLM & "\SOFTWARE" & $Wow6432Node & "\DuoDianOnline\SetupInfo\", "InstallPath")
   If @error = 0 Then
	  If StringRight($path, 1) <> "\" Then $path &= "\"
	  $path &= "bin\"
   Else
	  $path = ""
	  SetError(0, 0, 0)
   EndIf
   Return $path
EndFunc

Func GetNoxAdbPath()
   Local $adbPath = GetNoxPath() & "nox_adb.exe"
   If FileExists($adbPath) Then Return $adbPath
   Return ""
EndFunc

Func InitNox($bCheckOnly = False)
   Local $process_killed, $aRegExResult, $AndroidAdbDeviceHost, $AndroidAdbDevicePort, $oops = 0
   Local $Version = RegRead($HKLM & "\SOFTWARE" & $Wow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\Nox\", "DisplayVersion")
   SetError(0, 0, 0)

   Local $Path = GetNoxPath()
   Local $RtPath = GetNoxRtPath()

   Local $NoxFile = $Path & "Nox.exe"
   Local $AdbFile = $Path & "nox_adb.exe"
   Local $VBoxFile = $RtPath & "BigNoxVMMgr.exe"

   Local $Files[3] = [$NoxFile, $AdbFile, $VBoxFile]
   Local $File

   For $File in $Files
	  If FileExists($File) = False Then
		 If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $Android & " file:", $COLOR_RED)
			SetLog($File, $COLOR_RED)
			SetError(1, @extended, False)
		 EndIf
		 Return False
	  EndIf
   Next

   ; Read ADB host and Port
   If Not $bCheckOnly Then
	  InitAndroidConfig(True) ; Restore default config

	  $__VBoxVMinfo = LaunchConsole($VBoxFile, "showvminfo " & $AndroidInstance, $process_killed)
	  ; check if instance is known
	  If StringInStr($__VBoxVMinfo, "Could not find a registered machine named") > 0 Then
		 ; Unknown vm
		 Return False
	  EndIf
	  ; update global variables
	  $AndroidProgramPath = $NoxFile
	  $AndroidAdbPath = FindPreferredAdbPath()
	  If $AndroidAdbPath = "" Then $AndroidAdbPath = GetNoxAdbPath()
	  $AndroidVersion = $Version
	  $__Nox_Path = $Path
	  $__VBoxManage_Path = $VBoxFile
	  $aRegExResult = StringRegExp($__VBoxVMinfo, ".*host ip = ([^,]+), .* guest port = 5555", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $AndroidAdbDeviceHost = $aRegExResult[0]
		 If $debugSetlog = 1 Then Setlog("Func LaunchConsole: Read $AndroidAdbDeviceHost = " & $AndroidAdbDeviceHost, $COLOR_PURPLE)
	  Else
		 $oops = 1
		 SetLog("Cannot read " & $Android & "(" & $AndroidInstance & ") ADB Device Host", $COLOR_RED)
	  EndIF

	  $aRegExResult = StringRegExp($__VBoxVMinfo, "name = .*host port = (\d{3,5}), .* guest port = 5555", $STR_REGEXPARRAYMATCH)
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

	  ;$AndroidPicturesPath = "/mnt/shell/emulated/0/Download/other/"
	  $AndroidPicturesPath = "/mnt/shared/Other/"
	  $aRegExResult = StringRegExp($__VBoxVMinfo, "Name: 'Other', Host path: '(.*)'.*", $STR_REGEXPARRAYGLOBALMATCH)
	  If Not @error Then
		 $AndroidPicturesHostPath = $aRegExResult[UBound($aRegExResult) - 1] & "\"
	  Else
		 $AndroidAdbScreencap = False
		 $AndroidPicturesHostPath = ""
		 SetLog($Android & " Background Mode is not available", $COLOR_RED)
	  EndIf

	  $__VBoxGuestProperties = LaunchConsole($__VBoxManage_Path, "guestproperty enumerate " & $AndroidInstance, $process_killed)

	  ; Update Android Screen and Window
	  ;UpdateNoxConfig()
   EndIf

   Return True

EndFunc

Func SetScreenNox()

   If Not InitAndroid() Then Return False

   Local $cmdOutput, $process_killed

   ; These setting don't stick, so not used and instead using paramter: http://en.bignox.com/blog/?p=354
   ; Set width and height
   ;$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " vbox_graph_mode " & $AndroidClientWidth & "x" & $AndroidClientHeight & "-16", $process_killed)
   ; Set dpi
   ;$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " vbox_dpi 160", $process_killed)

   If $AndroidPicturesPathAutoConfig = True and FileExists($AndroidPicturesHostPath) = 1 Then
	  $cmdOutput = LaunchConsole($__VBoxManage_Path, "sharedfolder add " & $AndroidInstance & " --name Other --hostpath """ & $AndroidPicturesHostPath & """  --automount", $process_killed)
   EndIf

   Return True

EndFunc

Func RebootNoxSetScreen()

   Return RebootAndroidSetScreenDefault()

EndFunc

Func CloseNox()
    If Not $RunState Then Return

	Local $iIndex, $bOops = False, $process_killed
	Local $aServiceList[0] = [] ; ["BstHdAndroidSv", "BstHdLogRotatorSvc", "BstHdUpdaterSvc", "bthserv"]

	SetLog("Stopping Nox...", $COLOR_BLUE)

	$bOops = KillNoxProcess()

    SetLog("Please wait for full Nox shutdown...", $COLOR_GREEN)

	If _Sleep(1000) Then Return ; wait a bit

	For $iIndex = 0 To UBound($aServiceList) - 1
		ServiceStop($aServiceList[$iIndex])
		If @error Then
			$bOops = True
			If $debugsetlog = 1 Then Setlog($aServiceList[$iIndex] & " errored trying to stop", $COLOR_MAROON)
		EndIf
	Next
	If $bOops Then
		If $debugsetlog = 1 Then Setlog("Service Stop issues, stopping Nox 2nd time", $COLOR_MAROON)
		KillNoxProcess()
		If _SleepStatus(5000) Then Return
	EndIf

    ; also stop virtualbox instance
	LaunchConsole($__VBoxManage_Path, "controlvm """ & $AndroidInstance & """ poweroff", $process_killed)
	If _SleepStatus(3000) Then Return

	If $debugsetlog = 1 And $bOops Then
		SetLog("Nox Kill Failed to stop service", $COLOR_RED)
	ElseIf Not $bOops Then
		SetLog("Nox stopped successfully", $COLOR_GREEN)
	EndIf

	RemoveGhostTrayIcons($Title)  ; Remove ghost icon if left behind due forced taskkill

	If $bOops Then
		SetError(1, @extended, -1)
	EndIf

EndFunc   ;==>CloseDroid4X

Func KillNoxProcess()
#cs
	Local $iIndex, $iCount, $bOops = False
	Local $aFileNames[2][2] = [['Nox.exe', 0], ['nox_adb.exe', 0]]

	For $iIndex = 0 To UBound($aFileNames) - 1
	   $iCount = 0
	   While ProcessExists($aFileNames[$iIndex][0]) And $iCount < 3
		 If Not $RunState Then Return False
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
   EndIF

   If _Sleep(5000) Then Return ; Give OS time to work

EndFunc   ;==>KillNoxProcess

Func CheckScreenNox($bSetLog = True)

   If Not InitAndroid() Then Return False

   Local $aValues[2][2] = [ _
	  ["vbox_dpi", "160"], _
	  ["vbox_graph_mode", $AndroidClientWidth & "x" & $AndroidClientHeight & "-16"] _
   ]
   Local $i, $Value, $iErrCnt = 0, $process_killed, $aRegExResult

   For $i = 0 To UBound($aValues) -1
	  $aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: " & $aValues[$i][0] & ", value: (.+), timestamp:", $STR_REGEXPARRAYMATCH)
	  If @error = 0 Then $Value = $aRegExResult[0]
	  If $Value <> $aValues[$i][1] Then
		 If $iErrCnt = 0 Then
			If $bSetLog Then
			   SetLog("MyBot doesn't work with " & $Android & " screen configuration!", $COLOR_RED)
			Else
			   SetDebugLog("MyBot doesn't work with " & $Android & " screen configuration!", $COLOR_RED)
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

   ; check if shared folder exists
   If $AndroidPicturesPathAutoConfig = True Then
	  If $AndroidPicturesHostPath = "" Then
		 Local $path = @MyDocumentsDir
		 If FileExists($path) = 1 Then
			$AndroidPicturesHostPath = $path & "\Nox_share\Other"
			If FileExists($AndroidPicturesHostPath) = 1 Then
			   SetLog("Configure " & $Android & " to support Background Mode", $COLOR_GREEN)
			   SetLog("Folder exists: " & $AndroidPicturesHostPath, $COLOR_GREEN)
			   SetLog("This shared folder will be added to " & $Android, $COLOR_GREEN)
			   Return False
			EndIf
			If DirCreate($AndroidPicturesHostPath) = 1 Then
			   SetLog("Configure " & $Android & " to support Background Mode", $COLOR_GREEN)
			   SetLog("Folder created: " & $AndroidPicturesHostPath, $COLOR_GREEN)
			   SetLog("This shared folder will be added to " & $Android, $COLOR_GREEN)
			   Return False
			Else
			   SetLog("Cannot configure " & $Android & " Background Mode", $COLOR_GREEN)
			   SetLog("Cannot create folder: " & $AndroidPicturesHostPath, $COLOR_RED)
			   $AndroidPicturesPathAutoConfig = False
			EndIf
		 Else
			SetLog("Cannot configure " & $Android & " Background Mode", $COLOR_GREEN)
			SetLog("Cannot find current user 'Documents' folder", $COLOR_RED)
			$AndroidPicturesPathAutoConfig = False
		 EndIf
	  ElseIf FileExists($AndroidPicturesHostPath) = 0 Then
		 If DirCreate($AndroidPicturesHostPath) = 1 Then
			SetLog("Configure " & $Android & " to support ADB", $COLOR_GREEN)
			SetLog("Folder created: " & $AndroidPicturesHostPath, $COLOR_GREEN)
			SetLog("This shared folder will be added to " & $Android, $COLOR_GREEN)
			Return False
		 Else
			SetLog("Cannot configure " & $Android & " Background Mode", $COLOR_GREEN)
			SetLog("Cannot create folder: " & $AndroidPicturesHostPath, $COLOR_RED)
			$AndroidPicturesPathAutoConfig = False
		 EndIf
	  EndIf
   EndIf

   If $iErrCnt > 0 Then Return False
   Return True

EndFunc

Func GetNoxRunningInstance($bStrictCheck = True)
   Local $a[2] = [0, ""]
   SetDebugLog("GetAndroidRunningInstance: Try to find """ & $AndroidProgramPath & """")
   For $pid In ProcessesExist($AndroidProgramPath, "", 1) ; find all process
	  Local $currentInstance = $AndroidInstance
	  ; assume last parameter is instance
	  Local $commandLine = ProcessGetCommandLine($pid)
	  SetDebugLog("GetNoxRunningInstance: Found """ & $commandLine & """ by PID=" & $pid)
	  Local $aRegExResult = StringRegExp($commandLine, ".*""-clone:([^""]+)"".*|.*-clone:([\S]+).*", $STR_REGEXPARRAYMATCH)
	  If @error = 0 Then
		 $AndroidInstance = $aRegExResult[0]
		 If $AndroidInstance = "" Then $AndroidInstance = $aRegExResult[1]
		 SetDebugLog("Running " & $Android & " instance is """ & $AndroidInstance & """")
	  EndIf
	  ; validate
	  If WinGetAndroidHandle() <> 0 Then
		 $a[0] = $HWnD
		 $a[1] = $AndroidInstance
		 Return $a
	  Else
		 $AndroidInstance = $currentInstance
	  EndIf
   Next
   Return $a
EndFunc

Func RedrawNoxWindow()
	Local $aPos = WinGetPos($HWnD)
	;_PostMessage_ClickDrag($aPos[0] + Int($aPos[2] / 2), $aPos[1] + 3, $aPos[0] + Int($aPos[2] / 2), $aPos[1] + 53)
	;_PostMessage_ClickDrag($aPos[0] + Int($aPos[2] / 2), $aPos[1] + 53, $aPos[0] + Int($aPos[2] / 2), $aPos[1] + 3)
	Local $aMousePos = MouseGetPos()
	MouseClickDrag("left", $aPos[0] + Int($aPos[2] / 2), $aPos[1] + 3, $aPos[0] + Int($aPos[2] / 2), $aPos[1] + 53, 0)
	MouseClickDrag("left", $aPos[0] + Int($aPos[2] / 2), $aPos[1] + 53, $aPos[0] + Int($aPos[2] / 2), $aPos[1] + 3, 0)
	MouseMove($aMousePos[0], $aMousePos[1], 0)
	;WinMove2($HWnD, "", $AndroidWinPos[0], $AndroidWinPos[1], $aAndroidWindow[0], $aAndroidWindow[1])
	;ControlMove($HWnD, $AppPaneName, $AppClassInstance, 0, 0, $AndroidClientWidth, $AndroidClientHeight)
	;If _Sleep(500) Then Return False ; Just wait, not really required...
	;$new_BSsize = ControlGetPos($HWnD, $AppPaneName, $AppClassInstance)
	$aPos = WinGetPos($HWnD)
	ControlClick($HWnD, "", "", "left", 1, $aPos[2] - 46, 18)
	If _Sleep(500) Then Return False
	$aPos = WinGetPos($HWnD)
	ControlClick($HWnD, "", "", "left", 1, $aPos[2] - 46, 18)
	;If _Sleep(500) Then Return False
EndFunc