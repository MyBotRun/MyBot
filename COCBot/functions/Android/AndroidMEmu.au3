; #FUNCTION# ====================================================================================================================
; Name ..........: OpenMEmu
; Description ...: Opens new MEmu instance
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (2015-12)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenMEmu($bRestart = False)

   Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdPar

   SetLog("Starting " & $g_sAndroidEmulator & " and Clash Of Clans", $COLOR_SUCCESS)

   Local $launchAndroid = (WinGetAndroidHandle() = 0 ? True : False)
   If $launchAndroid Then
	  ; Launch MEmu
	  $cmdPar = GetAndroidProgramParameter()
	  SetDebugLog("ShellExecute: " & $g_sAndroidProgramPath & " " & $cmdPar)
	  $PID = ShellExecute($g_sAndroidProgramPath, $cmdPar, $__MEmu_Path)
	  If _Sleep(1000) Then Return False
	  If $PID <> 0 Then $PID = ProcessExists($PID)
	  SetDebugLog("$PID= "&$PID)
	  If $PID = 0 Then  ; IF ShellExecute failed
		SetLog("Unable to load " & $g_sAndroidEmulator & ($g_sAndroidInstance = "" ? "" : "(" & $g_sAndroidInstance & ")") & ", please check emulator/installation.", $COLOR_ERROR)
		SetLog("Unable to continue........", $COLOR_WARNING)
		btnStop()
		SetError(1, 1, -1)
		Return False
	 EndIf
   EndIf

   SetLog("Please wait while " & $g_sAndroidEmulator & " and CoC start...", $COLOR_SUCCESS)
   $hTimer = TimerInit()

   ; Test ADB is connected
   $connected_to = ConnectAndroidAdb(False, 60 * 1000)
   If Not $g_bRunState Then Return False

   ; Wait for device
   ;$cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " wait-for-device", $process_killed, 60 * 1000)
   ;If Not $g_bRunState Then Return

   ; Wair for Activity Manager
   ;If WaitForAmMEmu($g_iAndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return
   If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return False

   ; Wait for UI Control, then CoC can be launched
   ;While Not IsArray(ControlGetPos($Title, $g_sAppPaneName, $g_sAppClassInstance)) And TimerDiff($hTimer) <= $g_iAndroidLaunchWaitSec * 1000
   ;  If _Sleep(500) Then Return
   ;WEnd

	If TimerDiff($hTimer) >= $g_iAndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
	  SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
	  SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_ERROR)
	  SetError(1, @extended, False)
	  Return False
	EndIf

    SetLog($g_sAndroidEmulator & " Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_SUCCESS)

	Return True

EndFunc   ;==>OpenMEmu

Func GetMEmuProgramParameter($bAlternative = False)
   If Not $bAlternative Or $g_sAndroidInstance <> $g_avAndroidAppConfig[$g_iAndroidConfig][1] Then
	  ; should be launched with these parameter
	  Return ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance)
   EndIf
   ; default instance gets launched when no parameter was specified (this is the alternative way)
   Return ""
EndFunc

Func GetMEmuPath()
   Local $MEmu_Path = EnvGet("MEmu_Path") & "\MEmu\" ;RegRead($g_sHKLM & "\SOFTWARE\MEmu\", "InstallDir") ; Doesn't exist (yet)
   If FileExists($MEmu_Path & "MEmu.exe") = 0 Then ; work-a-round
	  Local $InstallLocation = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "InstallLocation")
	  If @error = 0 And FileExists($InstallLocation & "\MEmu\MEmu.exe") = 1 Then
		 $MEmu_Path = $InstallLocation & "\MEmu\"
	  Else
		 Local $DisplayIcon = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "DisplayIcon")
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
   $MEmu_Path = StringReplace($MEmu_Path, "\\", "\")
   Return $MEmu_Path
EndFunc

Func GetMEmuAdbPath()
   Local $adbPath = GetMEmuPath() & "adb.exe"
   If FileExists($adbPath) Then Return $adbPath
   Return ""
EndFunc

Func InitMEmu($bCheckOnly = False)
   Local $process_killed, $aRegExResult, $g_sAndroidAdbDeviceHost, $g_sAndroidAdbDevicePort, $oops = 0
   Local $MEmuVersion = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "DisplayVersion")
   SetError(0, 0, 0)
   ; Could also read MEmu paths from environment variables MEmu_Path and MEmuHyperv_Path
   Local $MEmu_Path = GetMEmuPath()
   Local $MEmu_Manage_Path = EnvGet("MEmuHyperv_Path") & "\MEmuManage.exe"
   If FileExists($MEmu_Manage_Path) = 0 Then
	  $MEmu_Manage_Path = $MEmu_Path & "..\MEmuHyperv\MEmuManage.exe"
   EndIf

   If FileExists($MEmu_Path & "MEmu.exe") = 0 Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
		 SetLog($MEmu_Path & "MEmu.exe", $COLOR_ERROR)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   If FileExists($MEmu_Path & "adb.exe") = 0 Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
		 SetLog($MEmu_Path & "adb.exe", $COLOR_ERROR)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   If FileExists($MEmu_Manage_Path) = 0 Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find MEmu-Hyperv:", $COLOR_ERROR)
		 SetLog($MEmu_Manage_Path, $COLOR_ERROR)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   ; Read ADB host and Port
   If Not $bCheckOnly Then
	  InitAndroidConfig(True) ; Restore default config

	  $__VBoxVMinfo = LaunchConsole($MEmu_Manage_Path, "showvminfo " & $g_sAndroidInstance, $process_killed)
	  ; check if instance is known
	  If StringInStr($__VBoxVMinfo, "Could not find a registered machine named") > 0 Then
		 ; Unknown vm
		 SetLog("Cannot find " & $g_sAndroidEmulator & " instance " & $g_sAndroidInstance, $COLOR_ERROR)
		 Return False
	  EndIf
	  ; update global variables
	  $g_sAndroidProgramPath = $MEmu_Path & "MEmu.exe"
	  $g_sAndroidAdbPath = FindPreferredAdbPath()
	  If $g_sAndroidAdbPath = "" Then $g_sAndroidAdbPath = $MEmu_Path & "adb.exe"
	  $g_sAndroidVersion = $MEmuVersion
	  $__MEmu_Path = $MEmu_Path
	  $__VBoxManage_Path = $MEmu_Manage_Path
	  $aRegExResult = StringRegExp($__VBoxVMinfo, "name = ADB.*host ip = ([^,]+),", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $g_sAndroidAdbDeviceHost = $aRegExResult[0]
		 If $g_iDebugSetlog = 1 Then Setlog("Func LaunchConsole: Read $g_sAndroidAdbDeviceHost = " & $g_sAndroidAdbDeviceHost, $COLOR_DEBUG)
	  Else
		 $oops = 1
		 SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Host", $COLOR_ERROR)
	  EndIF

	  $aRegExResult = StringRegExp($__VBoxVMinfo, "name = ADB.*host port = (\d{3,5}),", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $g_sAndroidAdbDevicePort = $aRegExResult[0]
		 If $g_iDebugSetlog = 1 Then Setlog("Func LaunchConsole: Read $g_sAndroidAdbDevicePort = " & $g_sAndroidAdbDevicePort, $COLOR_DEBUG)
	  Else
		 $oops = 1
		 SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Port", $COLOR_ERROR)
	  EndIF

	  If $oops = 0 Then
		 $g_sAndroidAdbDevice = $g_sAndroidAdbDeviceHost & ":" & $g_sAndroidAdbDevicePort
	  Else ; use defaults
		 SetLog("Using ADB default device " & $g_sAndroidAdbDevice & " for " & $g_sAndroidEmulator, $COLOR_ERROR)
	  EndIf

	  ; get screencap paths: Name: 'picture', Host path: 'C:\Users\Administrator\Pictures\MEmu Photo' (machine mapping), writable
	  $g_sAndroidPicturesPath = "/mnt/shell/emulated/0/Pictures/"
	  $aRegExResult = StringRegExp($__VBoxVMinfo, "Name: 'picture', Host path: '(.*)'.*", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $g_sAndroidPicturesHostPath = $aRegExResult[0] & "\"
	  Else
		 $oops = 1
		 $g_bAndroidAdbScreencap = False
		 $g_sAndroidPicturesHostPath = ""
		 SetLog($g_sAndroidEmulator & " Background Mode is not available", $COLOR_ERROR)
	  EndIf

	  $__VBoxGuestProperties = LaunchConsole($__VBoxManage_Path, "guestproperty enumerate " & $g_sAndroidInstance, $process_killed)

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
	  If Not $g_bRunState Then Return True
	  ; Test ADB is connected
	  $cmdOutput = LaunchConsole($g_sAndroidAdbPath, "connect " & $g_sAndroidAdbDevice, $process_killed)
	  $connected_to = StringInStr($cmdOutput, "connected to")
	  $cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " shell am display-size reset", $process_killed)
	  If $hTimer <> 0 Then _StatusUpdateTime($hTimer)
	  $am_ready = StringLen($cmdOutput) < 4
	  If $am_ready Then ExitLoop
	  If TimerDiff($hMyTimer) > $WaitInSec * 1000 Then ; if no device available in 4 minutes, Android/PC has major issue so exit
		 SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
		 SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for activity manager", $COLOR_ERROR)
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
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " resolution_width " & $g_iAndroidClientWidth, $process_killed)
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " resolution_height " & $g_iAndroidClientHeight, $process_killed)
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " is_full_screen 0", $process_killed)
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " is_customed_resolution 1", $process_killed)
   ; Set dpi
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_dpi 160", $process_killed)

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
	  ["resolution_height", $g_iAndroidClientHeight], _
	  ["resolution_width", $g_iAndroidClientWidth] _
   ]
   Local $i, $Value, $iErrCnt = 0, $process_killed, $aRegExResult

   For $i = 0 To UBound($aValues) -1
	  $aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: " & $aValues[$i][0] & ", value: (.+), timestamp:", $STR_REGEXPARRAYMATCH)
	  If @error = 0 Then $Value = $aRegExResult[0]
	  If $Value <> $aValues[$i][1] Then
		 If $iErrCnt = 0 Then
			If $bSetLog Then
			   SetLog("MyBot doesn't work with " & $g_sAndroidEmulator & " screen configuration!", $COLOR_ERROR)
			Else
			   SetDebugLog("MyBot doesn't work with " & $g_sAndroidEmulator & " screen configuration!", $COLOR_ERROR)
			EndIf
		 EndIf
		 If $bSetLog Then
			SetLog("Setting of " & $aValues[$i][0] & " is " & $Value & " and will be changed to " & $aValues[$i][1], $COLOR_ERROR)
		 Else
			SetDebugLog("Setting of " & $aValues[$i][0] & " is " & $Value & " and will be changed to " & $aValues[$i][1], $COLOR_ERROR)
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
   $Value = LaunchConsole($__VBoxManage_Path, "guestproperty get " & $g_sAndroidInstance & " phone_layout", $process_killed)
   $aRegExResult = StringRegExp($Value, "Value: (.+)", $STR_REGEXPARRAYMATCH)

   If @error = 0 Then
	  $__MEmu_PhoneLayout = $aRegExResult[0]
	  SetDebugLog($g_sAndroidEmulator & " phone_layout is " & $__MEmu_PhoneLayout, $COLOR_ERROR)
   Else
	  SetDebugLog("Cannot read " & $g_sAndroidEmulator & " guestproperty phone_layout!", $COLOR_ERROR)
   EndIF
   SetError(0, 0, 0)

   Return UpdateMEmuWindowState()
EndFunc

Func UpdateMEmuWindowState()
   ; check if MEmu is open and Tool Bar is closed
   ;$HWnD = WinGetHandle($Title)
   WinGetAndroidHandle()
   ControlGetPos($hWnD, $g_sAppPaneName, $g_sAppClassInstance)
   If @error = 1 Then
	  ; Window not found, nothing to do
	  SetError(0, 0, 0)
	  ;Return False
   EndIf

   Local $acw = $g_avAndroidAppConfig[$g_iAndroidConfig][5]
   Local $ach = $g_avAndroidAppConfig[$g_iAndroidConfig][6]
   Local $aww = $g_avAndroidAppConfig[$g_iAndroidConfig][7]
   Local $awh = $g_avAndroidAppConfig[$g_iAndroidConfig][8]
   Local $tbw = $__MEmu_ToolBar_Width

   Local $v = GetVersionNormalized($g_sAndroidVersion)
   For $i = 0 To UBound($__MEmu_Window) - 1
	  Local $v2 = GetVersionNormalized($__MEmu_Window[$i][0])
	  If $v >= $v2 Then
		 SetDebugLog("Using Window sizes of " & $g_sAndroidEmulator & " " & $__MEmu_Window[$i][0])
		 $aww = $__MEmu_Window[$i][1]
		 $awh = $__MEmu_Window[$i][2]
		 $tbw = $__MEmu_Window[$i][3]
		 ExitLoop
	  EndIf
   Next

   Local $bToolBarVisible = True
   Local $i
   Local $Values[4][3] = [ _
	  ["Screen Width", $g_iAndroidClientWidth  , $g_iAndroidClientWidth], _
	  ["Screen Height", $g_iAndroidClientHeight, $g_iAndroidClientHeight], _
	  ["Window Width", $g_iAndroidWindowWidth  , $g_iAndroidWindowWidth], _
	  ["Window Height", $g_iAndroidWindowHeight , $g_iAndroidWindowHeight] _
   ]
   Local $bChanged = False, $ok = False
   Local $toolBarPos = ControlGetPos($Title, "", "Qt5QWindowIcon3")
   If UBound($toolBarPos) = 4 Then
	  ;ConsoleWrite("Qt5QWindowIcon3=" & $toolBarPos[0] & "," & $toolBarPos[1] & "," & $toolBarPos[2] & "," & $toolBarPos[3] & ($isVisible = 1 ? " visible" : " hidden")) ; 863,33,45,732
	  If $toolBarPos[2] = $tbw Then
		 $bToolBarVisible = ControlCommand($Title, "", "Qt5QWindowIcon3", "IsVisible", "") = 1
		 SetDebugLog($g_sAndroidEmulator & " Tool Bar is " & ($bToolBarVisible ? "visible" : "hidden"))
		 $ok = True
	  EndIf
   EndIf
   If Not $ok Then
	  SetDebugLog($g_sAndroidEmulator & " Tool Bar state is undetermined as treated as " & ($bToolBarVisible ? "visible" : "hidden"), $COLOR_ERROR)
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
		 SetDebugLog("Unsupported " & $g_sAndroidEmulator & " guestproperty phone_layout = " & $__MEmu_PhoneLayout, $COLOR_ERROR)
   EndSwitch

   $g_iAndroidClientWidth = $Values[0][2]
   $g_iAndroidClientHeight = $Values[1][2]
   $g_iAndroidWindowWidth =  $Values[2][2]
   $g_iAndroidWindowHeight = $Values[3][2]

   For $i = 0 To UBound($Values) -1
	  If $Values[$i][1] <> $Values[$i][2] Then
		 $bChanged = True
		 SetDebugLog($g_sAndroidEmulator & " " & $Values[$i][0] & " updated from " & $Values[$i][1] & " to " & $Values[$i][2])
	  EndIf
   Next

   Return $bChanged
EndFunc