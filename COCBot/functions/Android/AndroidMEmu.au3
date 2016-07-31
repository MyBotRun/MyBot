; #FUNCTION# ====================================================================================================================
; Name ..........: OpenMEmu
; Description ...: Opens new MEmu instance
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (2015-12)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenMEmu($bRestart = False)

   Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdPar

   SetLog("Starting " & $Android & " and Clash Of Clans", $COLOR_GREEN)

   $launchAndroid = WinGetAndroidHandle() = 0
   If $launchAndroid Then
	  ; Launch MEmu
	  $cmdPar = GetAndroidProgramParameter()
	  SetDebugLog("ShellExecute: " & $AndroidProgramPath & " " & $cmdPar)
	  $PID = ShellExecute($AndroidProgramPath, $cmdPar, $__MEmu_Path)
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

   ; Test ADB is connected
   $connected_to = ConnectAndroidAdb(False, 60 * 1000)
   If Not $RunState Then Return False

   ; Wait for device
   ;$cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " wait-for-device", $process_killed, 60 * 1000)
   ;If Not $RunState Then Return

   ; Wair for Activity Manager
   ;If WaitForAmMEmu($AndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return
   If WaitForAndroidBootCompleted($AndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return False

   ; Wait for UI Control, then CoC can be launched
   ;While Not IsArray(ControlGetPos($Title, $AppPaneName, $AppClassInstance)) And TimerDiff($hTimer) <= $AndroidLaunchWaitSec * 1000
   ;  If _Sleep(500) Then Return
   ;WEnd

	If TimerDiff($hTimer) >= $AndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
	  SetLog("Serious error has occurred, please restart PC and try again", $COLOR_RED)
	  SetLog($Android & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_RED)
	  SetError(1, @extended, False)
	  Return False
	EndIf

    SetLog($Android & " Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_GREEN)

	Return True

EndFunc   ;==>OpenMEmu

Func GetMEmuProgramParameter($bAlternative = False)
   If Not $bAlternative Or $AndroidInstance <> $AndroidAppConfig[$AndroidConfig][1] Then
	  ; should be launched with these parameter
	  Return ($AndroidInstance = "" ? $AndroidAppConfig[$AndroidConfig][1] : $AndroidInstance)
   EndIf
   ; default instance gets launched when no parameter was specified (this is the alternative way)
   Return ""
EndFunc

Func GetMEmuPath()
   Local $MEmu_Path = EnvGet("MEmu_Path") & "\MEmu\" ;RegRead($HKLM & "\SOFTWARE\MEmu\", "InstallDir") ; Doesn't exist (yet)
   If FileExists($MEmu_Path & "MEmu.exe") = 0 Then ; work-a-round
	  Local $InstallLocation = RegRead($HKLM & "\SOFTWARE" & $Wow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "InstallLocation")
	  If @error = 0 And FileExists($InstallLocation & "\MEmu\MEmu.exe") = 1 Then
		 $MEmu_Path = $InstallLocation & "\MEmu\"
	  Else
		 Local $DisplayIcon = RegRead($HKLM & "\SOFTWARE" & $Wow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "DisplayIcon")
		 If @error = 0 Then
			Local $iLastBS = StringInStr($DisplayIcon, "\", 0, -1)
			$MEmu_Path = StringLeft($DisplayIcon, $iLastBS)
			If StringLeft($MEmu_Path, 1) = """" Then $MEmu_Path = StringMid($MEmu_Path, 2)
		 Else
			$MEmu_Path = @ProgramFilesDir & "\Microvirt\MEmu\"
			SetError(0, 0, 0)
		 EndIf
	  EndIf
   EndIf
   Return $MEmu_Path
EndFunc

Func GetMEmuAdbPath()
   Local $adbPath = GetMEmuPath() & "adb.exe"
   If FileExists($adbPath) Then Return $adbPath
   Return ""
EndFunc

Func InitMEmu($bCheckOnly = False)
   Local $process_killed, $aRegExResult, $AndroidAdbDeviceHost, $AndroidAdbDevicePort, $oops = 0
   Local $MEmuVersion = RegRead($HKLM & "\SOFTWARE" & $Wow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "DisplayVersion")
   SetError(0, 0, 0)
   ; Could also read MEmu paths from environment variables MEmu_Path and MEmuHyperv_Path
   Local $MEmu_Path = GetMEmuPath()
   Local $MEmu_Manage_Path = EnvGet("MEmuHyperv_Path") & "\MEmuManage.exe"
   If FileExists($MEmu_Manage_Path) = 0 Then
	  $MEmu_Manage_Path = $MEmu_Path & "..\MEmuHyperv\MEmuManage.exe"
   EndIf

   If FileExists($MEmu_Path & "MEmu.exe") = 0 Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find " & $Android & ":", $COLOR_RED)
		 SetLog($MEmu_Path & "MEmu.exe", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   If FileExists($MEmu_Path & "adb.exe") = 0 Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find " & $Android & ":", $COLOR_RED)
		 SetLog($MEmu_Path & "adb.exe", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   If FileExists($MEmu_Manage_Path) = 0 Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find MEmu-Hyperv:", $COLOR_RED)
		 SetLog($MEmu_Manage_Path, $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   ; Read ADB host and Port
   If Not $bCheckOnly Then
	  InitAndroidConfig(True) ; Restore default config

	  $__VBoxVMinfo = LaunchConsole($MEmu_Manage_Path, "showvminfo " & $AndroidInstance, $process_killed)
	  ; check if instance is known
	  If StringInStr($__VBoxVMinfo, "Could not find a registered machine named") > 0 Then
		 ; Unknown vm
		 SetLog("Cannot find " & $Android & " instance " & $AndroidInstance, $COLOR_RED)
		 Return False
	  EndIf
	  ; update global variables
	  $AndroidProgramPath = $MEmu_Path & "MEmu.exe"
	  $AndroidAdbPath = FindPreferredAdbPath()
	  If $AndroidAdbPath = "" Then $AndroidAdbPath = $MEmu_Path & "adb.exe"
	  $AndroidVersion = $MEmuVersion
	  $__MEmu_Path = $MEmu_Path
	  $__VBoxManage_Path = $MEmu_Manage_Path
	  $aRegExResult = StringRegExp($__VBoxVMinfo, "name = ADB.*host ip = ([^,]+),", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $AndroidAdbDeviceHost = $aRegExResult[0]
		 If $debugSetlog = 1 Then Setlog("Func LaunchConsole: Read $AndroidAdbDeviceHost = " & $AndroidAdbDeviceHost, $COLOR_PURPLE)
	  Else
		 $oops = 1
		 SetLog("Cannot read " & $Android & "(" & $AndroidInstance & ") ADB Device Host", $COLOR_RED)
	  EndIF

	  $aRegExResult = StringRegExp($__VBoxVMinfo, "name = ADB.*host port = (\d{3,5}),", $STR_REGEXPARRAYMATCH)
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

	  ; get screencap paths: Name: 'picture', Host path: 'C:\Users\Administrator\Pictures\MEmu Photo' (machine mapping), writable
	  $AndroidPicturesPath = "/mnt/shell/emulated/0/Pictures/"
	  $aRegExResult = StringRegExp($__VBoxVMinfo, "Name: 'picture', Host path: '(.*)'.*", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $AndroidPicturesHostPath = $aRegExResult[0] & "\"
	  Else
		 $oops = 1
		 $AndroidAdbScreencap = False
		 $AndroidPicturesHostPath = ""
		 SetLog($Android & " Background Mode is not available", $COLOR_RED)
	  EndIf

	  $__VBoxGuestProperties = LaunchConsole($__VBoxManage_Path, "guestproperty enumerate " & $AndroidInstance, $process_killed)

	  ; Update Android Screen and Window
	  UpdateMEmuConfig()

   EndIf

   Return SetError($oops, 0, True)

EndFunc

Func WaitForAmMEmu($WaitInSec, $hTimer = 0) ; doesn't work yet!!!
   Local $cmdOutput, $connected_to, $am_ready, $process_killed, $hMyTimer
	; Wait for Activity Manager
	$hMyTimer = ($hTimer = 0 ? TimerInit() : $hTimer)
	While True
	  If Not $RunState Then Return True
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

Func SetScreenMEmu()

   If Not InitAndroid() Then Return False

   Local $cmdOutput, $process_killed

   ; Set width and height
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " resolution_width " & $AndroidClientWidth, $process_killed)
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " resolution_height " & $AndroidClientHeight, $process_killed)
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " is_full_screen 0", $process_killed)
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " is_customed_resolution 1", $process_killed)
   ; Set dpi
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " vbox_dpi 160", $process_killed)

   Return True

EndFunc

Func RebootMEmuSetScreen()

   Return RebootAndroidSetScreenDefault()

EndFunc

Func CloseMEmu()

	Return CloseVboxAndroidSvc()

EndFunc   ;==>CloseMEmu

Func CheckScreenMEmu($bSetLog = True)

   If Not InitAndroid() Then Return False

   Local $aValues[4][2] = [ _
	  ["is_full_screen", "0"], _
	  ["vbox_dpi", "160"], _
	  ["resolution_height", $AndroidClientHeight], _
	  ["resolution_width", $AndroidClientWidth] _
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
   If $iErrCnt > 0 Then Return False
   Return True

EndFunc

Func UpdateMEmuConfig()

   Local $Value, $process_killed, $aRegExResult
   ;MEmu "phone_layout" value="2" -> no system bar
   ;MEmu "phone_layout" value="1" -> right system bar
   ;MEmu "phone_layout" value="0" -> bottom system bar
   $Value = LaunchConsole($__VBoxManage_Path, "guestproperty get " & $AndroidInstance & " phone_layout", $process_killed)
   $aRegExResult = StringRegExp($Value, "Value: (.+)", $STR_REGEXPARRAYMATCH)

   If @error = 0 Then
	  $__MEmu_PhoneLayout = $aRegExResult[0]
	  SetDebugLog($Android & " phone_layout is " & $__MEmu_PhoneLayout, $COLOR_RED)
   Else
	  SetDebugLog("Cannot read " & $Android & " guestproperty phone_layout!", $COLOR_RED)
   EndIF
   SetError(0, 0, 0)

   Return UpdateMEmuWindowState()
EndFunc

Func UpdateMEmuWindowState()
   ; check if MEmu is open and Tool Bar is closed
   ;$HWnD = WinGetHandle($Title)
   WinGetAndroidHandle()
   ControlGetPos($hWnD, $AppPaneName, $AppClassInstance)
   If @error = 1 Then
	  ; Window not found, nothing to do
	  SetError(0, 0, 0)
	  ;Return False
   EndIf

   Local $acw = $AndroidAppConfig[$AndroidConfig][5]
   Local $ach = $AndroidAppConfig[$AndroidConfig][6]
   Local $aww = $AndroidAppConfig[$AndroidConfig][7]
   Local $awh = $AndroidAppConfig[$AndroidConfig][8]
   Local $tbw = $__MEmu_ToolBar_Width

   Local $v = GetVersionNormalized($AndroidVersion)
   For $i = 0 To UBound($__MEmu_Window) - 1
	  Local $v2 = GetVersionNormalized($__MEmu_Window[$i][0])
	  If $v >= $v2 Then
		 SetDebugLog("Using Window sizes of " & $Android & " " & $__MEmu_Window[$i][0])
		 $aww = $__MEmu_Window[$i][1]
		 $awh = $__MEmu_Window[$i][2]
		 $tbw = $__MEmu_Window[$i][3]
		 ExitLoop
	  EndIf
   Next

   Local $bToolBarVisible = True
   Local $i
   Local $Values[4][3] = [ _
	  ["Screen Width", $AndroidClientWidth  , $AndroidClientWidth], _
	  ["Screen Height", $AndroidClientHeight, $AndroidClientHeight], _
	  ["Window Width", $AndroidWindowWidth  , $AndroidWindowWidth], _
	  ["Window Height", $AndroidWindowHeight , $AndroidWindowHeight] _
   ]
   Local $bChanged = False, $ok = False
   Local $toolBarPos = ControlGetPos($Title, "", "Qt5QWindowIcon3")
   If UBound($toolBarPos) = 4 Then
	  ;ConsoleWrite("Qt5QWindowIcon3=" & $toolBarPos[0] & "," & $toolBarPos[1] & "," & $toolBarPos[2] & "," & $toolBarPos[3] & ($isVisible = 1 ? " visible" : " hidden")) ; 863,33,45,732
	  If $toolBarPos[2] = $tbw Then
		 $bToolBarVisible = ControlCommand($Title, "", "Qt5QWindowIcon3", "IsVisible", "") = 1
		 SetDebugLog($Android & " Tool Bar is " & ($bToolBarVisible ? "visible" : "hidden"))
		 $ok = True
	  EndIf
   EndIf
   If Not $ok Then
	  SetDebugLog($Android & " Tool Bar state is undetermined as treated as " & ($bToolBarVisible ? "visible" : "hidden"), $COLOR_RED)
   EndIF

   Local $w = ($bToolBarVisible ? 0 : $tbw)

   Switch $__MEmu_PhoneLayout
	  Case "0" ; Bottom position (default)
		 $Values[0][2] = $acw
		 $Values[1][2] = $ach
		 $Values[2][2] = $aww - $w
		 $Values[3][2] = $awh
	  Case "1" ; Right position
		 $Values[0][2] = $acw + $__MEmu_SystemBar
		 $Values[1][2] = $ach - $__MEmu_SystemBar
		 $Values[2][2] = $aww + $__MEmu_SystemBar - $w
		 $Values[3][2] = $awh - $__MEmu_SystemBar
	  Case "2" ; Hidden
		 $Values[0][2] = $acw
		 $Values[1][2] = $ach - $__MEmu_SystemBar
		 $Values[2][2] = $aww - $w
		 $Values[3][2] = $awh - $__MEmu_SystemBar
	  Case Else ; Unexpected Value
		 SetDebugLog("Unsupported " & $Android & " guestproperty phone_layout = " & $__MEmu_PhoneLayout, $COLOR_RED)
   EndSwitch

   $AndroidClientWidth = $Values[0][2]
   $AndroidClientHeight = $Values[1][2]
   $AndroidWindowWidth =  $Values[2][2]
   $AndroidWindowHeight = $Values[3][2]

   For $i = 0 To UBound($Values) -1
	  If $Values[$i][1] <> $Values[$i][2] Then
		 $bChanged = True
		 SetDebugLog($Android & " " & $Values[$i][0] & " updated from " & $Values[$i][1] & " to " & $Values[$i][2])
	  EndIf
   Next

   Return $bChanged
EndFunc