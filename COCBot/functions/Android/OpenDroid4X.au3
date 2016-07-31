; #FUNCTION# ====================================================================================================================
; Name ..........: OpenDroid4X
; Description ...: Opens new Droid4X instance
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

Func OpenDroid4X($bRestart = False)

   Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $launchAndroid, $cmdPar

   SetLog("Starting " & $Android & " and Clash Of Clans", $COLOR_GREEN)

   $launchAndroid = WinGetAndroidHandle() = 0
   If $launchAndroid Then
	  ; TODO as Droid4X crashes quite often, check if vm ist not running in background...
	  ; Launch Droid4X
	  $cmdPar = GetAndroidProgramParameter()
	  SetDebugLog("ShellExecute: " & $AndroidProgramPath & " " & $cmdPar)
	  $PID = ShellExecute($AndroidProgramPath, $cmdPar)
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

   ; Test ADB is connected
   $connected_to = ConnectAndroidAdb(False, 60 * 1000)
   If Not $RunState Then Return False

   SetLog("Please wait while " & $Android & " and CoC start...", $COLOR_GREEN)
   $hTimer = TimerInit()
   ; Wait for device
   ;$cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " wait-for-device", $process_killed, 60 * 1000)
   ;If Not $RunState Then Return

   ; Wair for Activity Manager
   If WaitForAndroidBootCompleted($AndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return False

   ; Wait for UI Control, then CoC can be launched
   ;While Not IsArray(ControlGetPos($Title, $AppPaneName, $AppClassInstance)) And TimerDiff($hTimer) <= $AndroidLaunchWaitSec * 1000
   ;  If _Sleep(500) Then Return
   ;WEnd

    If Not $RunState Then Return False
	If TimerDiff($hTimer) >= $AndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
	  SetLog("Serious error has occurred, please restart PC and try again", $COLOR_RED)
	  SetLog($Android & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_RED)
	  SetError(1, @extended, False)
	  Return False
	EndIf

    SetLog($Android & " Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_GREEN)
	Return True

EndFunc   ;==>OpenDroid4X

Func GetDroid4XProgramParameter($bAlternative = False)
   If Not $bAlternative Or $AndroidInstance <> $AndroidAppConfig[$AndroidConfig][1] Then
	  ; should be launched with these parameter
	  Return "-o " & ($AndroidInstance = "" ? $AndroidAppConfig[$AndroidConfig][1] : $AndroidInstance)
   EndIf
   ; default instance gets launched when no parameter was specified (this is the alternative way)
   Return ""
EndFunc

Func GetDroid4XPath()
	Local $droid4xPath = RegRead($HKLM & "\SOFTWARE\Droid4X\", "InstallDir") ; Doesn't exist (yet)
	If @error <> 0 Then ; work-a-round
	   Local $DisplayIcon = RegRead($HKLM & "\SOFTWARE" & $Wow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\Droid4X\", "DisplayIcon")
	   If @error = 0 Then
			Local $iLastBS = StringInStr($DisplayIcon, "\", 0, -1)
			$droid4xPath = StringLeft($DisplayIcon, $iLastBS)
	   EndIf
    EndIf
	If @error <> 0 Then
		$droid4xPath = @ProgramFilesDir & "\Droid4X\"
		SetError(0, 0, 0)
    EndIf
    Return $droid4xPath
EndFunc

Func GetDroid4XAdbPath()
   Local $adbPath = GetDroid4XPath() & "adb.exe"
   If FileExists($adbPath) Then Return $adbPath
   Return ""
EndFunc

Func InitDroid4X($bCheckOnly = False)
    Local $process_killed, $aRegExResult, $VirtualBox_Path, $AndroidAdbDeviceHost, $AndroidAdbDevicePort, $oops = 0

    $__Droid4X_Version = RegRead($HKLM & "\SOFTWARE" & $Wow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\Droid4X\", "DisplayVersion")
	$__Droid4X_Path = GetDroid4XPath()

    $VirtualBox_Path = RegRead($HKLM & "\SOFTWARE\Oracle\VirtualBox\", "InstallDir")
	If @error <> 0 Then
		$VirtualBox_Path = @ProgramFilesDir & "\Oracle\VirtualBox\"
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

   If FileExists($VirtualBox_Path & "VBoxManage.exe") = False Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find VirtualBox:", $COLOR_RED)
		 SetLog($VirtualBox_Path & "VBoxManage.exe", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   ; Read ADB host and Port
   If Not $bCheckOnly Then
	  InitAndroidConfig(True) ; Restore default config

	  $__VBoxManage_Path = $VirtualBox_Path & "VBoxManage.exe"
	  $__VBoxVMinfo = LaunchConsole($__VBoxManage_Path, "showvminfo " & $AndroidInstance, $process_killed)
	  ; check if instance is known
	  If StringInStr($__VBoxVMinfo, "Could not find a registered machine named") > 0 Then
		 ; Unknown vm
		 SetLog("Cannot find " & $Android & " instance " & $AndroidInstance, $COLOR_RED)
		 Return False
	  EndIf
	  $aRegExResult = StringRegExp($__VBoxVMinfo, "ADB_PORT.*host ip = ([^,]+),", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $AndroidAdbDeviceHost = $aRegExResult[0]
		 If $debugSetlog = 1 Then Setlog("Func LaunchConsole: Read $AndroidAdbDeviceHost = " & $AndroidAdbDeviceHost, $COLOR_PURPLE)
	  Else
		 $oops = 1
		 SetLog("Cannot read " & $Android & "(" & $AndroidInstance & ") ADB Device Host", $COLOR_RED)
	  EndIF

	  $aRegExResult = StringRegExp($__VBoxVMinfo, "ADB_PORT.*host port = (\d{3,5}),", $STR_REGEXPARRAYMATCH)
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
	  $AndroidProgramPath = $__Droid4X_Path & "Droid4X.exe"
	  $AndroidAdbPath = FindPreferredAdbPath()
	  If $AndroidAdbPath = "" Then $AndroidAdbPath = $__Droid4X_Path & "adb.exe"
	  $AndroidVersion = $__Droid4X_Version
	  ; Update Window Title if instance has been configured
	  If $AndroidInstance = "" Or StringCompare($AndroidInstance, $AndroidAppConfig[$AndroidConfig][1]) = 0 Then
		 ; Default title, nothing to do
	  Else
		 ; Update title (only if not updated yet)
		 If $Title = $AndroidAppConfig[$AndroidConfig][2] Then
			$Title = StringReplace($AndroidAppConfig[$AndroidConfig][2], "Droid4X", $AndroidInstance)
		 EndIf
	  EndIf

	  ; get screencap paths: Name: 'picture', Host path: 'C:\Users\Administrator\Pictures\MEmu Photo' (machine mapping), writable
	  ; see also: VBoxManage setextradata droid4x VBoxInternal2/SharedFoldersEnableSymlinksCreate/picture 1
	  $AndroidPicturesPath = "/mnt/shared/picture/"
	  $aRegExResult = StringRegExp($__VBoxVMinfo, "Name: 'picture', Host path: '(.*)'.*", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $AndroidPicturesHostPath = $aRegExResult[0] & "\"
	  Else
		 SetLog($Android & " Background Mode is not available", $COLOR_RED)
		 $AndroidPicturesHostPath = ""
		 $AndroidAdbScreencap = False
	  EndIf

	  $__VBoxGuestProperties = LaunchConsole($__VBoxManage_Path, "guestproperty enumerate " & $AndroidInstance, $process_killed)

	  WinGetAndroidHandle()

	  ; Update Android Screen and Window
	  UpdateDroid4XConfig()
   EndIf

   Return True

EndFunc

Func SetScreenDroid4X()
   If Not $RunState Then Return False
   If Not InitAndroid() Then Return False

   Local $cmdOutput, $process_killed

   ; Set width and height
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " vbox_graph_mode " & $AndroidClientWidth & "x" & $AndroidClientHeight & "-16", $process_killed)

   ; Set dpi
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " vbox_dpi 160", $process_killed)

   ;vboxmanage sharedfolder add droid4x --name picture --hostpath "C:\Users\Administrator\Pictures\Droid4X Photo" --automount
   If $ichkBackground = 1 And $AndroidAdbScreencap = False And $AndroidPicturesPathAutoConfig = True And BitAND($AndroidSupportFeature, 2) = 2 and FileExists($AndroidPicturesHostPath) = 1 Then
	  $cmdOutput = LaunchConsole($__VBoxManage_Path, "sharedfolder add " & $AndroidInstance & " --name picture --hostpath """ & $AndroidPicturesHostPath & """  --automount", $process_killed)
   EndIf

   Return True
EndFunc

Func RebootDroid4XSetScreen()

   Return RebootAndroidSetScreenDefault()

EndFunc

Func CheckScreenDroid4X($bSetLog = True)

   If Not InitAndroid() Then Return False

   Local $aValues[2][2] = [ _
	  ["vbox_dpi", "160"], _
	  ["vbox_graph_mode", $AndroidClientWidth & "x" & $AndroidClientHeight & "-16"] _
   ]
   Local $i, $Value, $iErrCnt = 0, $process_killed, $aRegExResult, $properties

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

   ; check if shared folder exists for background mode and mouse events
   If $ichkBackground = 1 And $AndroidAdbScreencap = False And $AndroidPicturesPathAutoConfig = True And BitAND($AndroidSupportFeature, 2) = 2 Then
	  Local $myPictures = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\", "My Pictures")
	  If @error = 0 And FileExists($myPictures) = 1 Then
		 $AndroidPicturesHostPath = $myPictures & "\" & $Android & " Photo"
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
		 SetLog("Cannot find current user 'My Pictures' folder", $COLOR_RED)
		 $AndroidPicturesPathAutoConfig = False
	  EndIf
   EndIf

   Return True

EndFunc

Func UpdateDroid4XConfig()
   Return UpdateDroid4XWindowState()
EndFunc

Func UpdateDroid4XWindowState()
   WinGetAndroidHandle()
   ControlGetPos($hWnD, $AppPaneName, $AppClassInstance)
   If @error = 1 Then
	  ; Window not found, nothing to do
	  SetError(0, 0, 0)
	  Return False
   EndIf

   Local $acw = $AndroidAppConfig[$AndroidConfig][5]
   Local $ach = $AndroidAppConfig[$AndroidConfig][6]
   Local $aww = $AndroidAppConfig[$AndroidConfig][7]
   Local $awh = $AndroidAppConfig[$AndroidConfig][8]

   Local $v = GetVersionNormalized($AndroidVersion)
   For $i = 0 To UBound($__Droid4X_Window) - 1
	  Local $v2 = GetVersionNormalized($__Droid4X_Window[$i][0])
	  If $v >= $v2 Then
		 SetDebugLog("Using Window sizes of " & $Android & " " & $__Droid4X_Window[$i][0])
		 $aww = $__Droid4X_Window[$i][1]
		 $awh = $__Droid4X_Window[$i][2]
		 ExitLoop
	  EndIf
   Next

   Local $i
   Local $Values[4][3] = [ _
	  ["Screen Width", $AndroidClientWidth  , $AndroidClientWidth], _
	  ["Screen Height", $AndroidClientHeight, $AndroidClientHeight], _
	  ["Window Width", $AndroidWindowWidth  , $AndroidWindowWidth], _
	  ["Window Height", $AndroidWindowHeight , $AndroidWindowHeight] _
   ]
   Local $bChanged = False, $ok = False
   $Values[0][2] = $acw
   $Values[1][2] = $ach
   $Values[2][2] = $aww
   $Values[3][2] = $awh

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