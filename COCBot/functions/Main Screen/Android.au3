; #FUNCTION# ====================================================================================================================
; Name ..........: Functions to interact with Android Window
; Description ...: This file contains the detection fucntions for the Emulator and Android version used.
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

; Update Global Android variables based on $AndroidConfig index
; Calls "Update" & $Android & "Config()"
Func UpdateAndroidConfig($instance = Default)
    If $instance = "" Then $instance = Default
    If $instance = Default Then $instance = $AndroidAppConfig[$AndroidConfig][1]
    SetDebugLog("UpdateAndroidConfig(""" & $instance & """)")

    InitAndroidConfig()
	$AndroidInstance = $instance ; Clone or instance of emulator or "" if not supported/default instance

	; validate install and initialize Android variables
    Local $Result = InitAndroid()
    SetDebugLog("UpdateAndroidConfig(""" & $instance & """) END")
    Return $Result
EndFunc   ;==>UpdateAndroidConfig

Func UpdateAndroidWindowState()
   ; Android specific configurations
   Local $bChanged = Execute("Update" & $Android & "WindowState()")
   If $bChanged = "" And @error <> 0 Then Return False ; Not implemented
   Return $bChanged
EndFunc

; Find Android Window defined by $Title in WinTitleMatchMode -1 and updates $HWnD and $Title when found.
; Uses different strategies to find best matching Window.
; Returns Android Window Handle or 0 if Window not found
Func WinGetAndroidHandle()
   ; Default WinTitleMatchMode should be 3 (exact match)
   Local $hWin = WinGetHandle($HWnD)
   If $hWin > 0 And $hWin = $HWnD Then Return $HWnD
   ; Find all controls by title and check which contains the android control (required for Nox)
   Local $i
   Local $t
   Local $ReInitAndroid = $HWnD <> 0
   SetDebugLog("Searching " & $Android & " Window: Title = '" & $Title & "', Class = '" & $AppClassInstance & "', Text = '" & $AppPaneName & "'")
   Local $aWinList = WinList($Title)
   If $aWinList[0][0] > 0 Then
	  For $i = 1 To $aWinList[0][0]
		 ; early exit if control exists
		 $hWin = $aWinList[$i][1]
		 $t = $aWinList[$i][0]
		 If $Title = $t Then
			Local $hCtrl = ControlGetHandle($hWin, $AppPaneName, $AppClassInstance)
			If $hCtrl <> 0 Then
			   SetDebugLog("Found " & $Android & " Window '" & $t & "' (" & $hWin & ") by matching title '" & $Title & "' (#1)")
			   $HWnD = $hWin
			   $Title = $t
			   If $ReInitAndroid = True And $InitAndroid = False Then ; Only initialize Android when not currently running
				  $InitAndroid = True ; change window, re-initialize Android config
				  InitAndroid()
			   EndIf
			   Return $hWin
			EndIf
		 EndIf
	  Next
   EndIf

   ; search for window
   Local $iMode
   $iMode = Opt("WinTitleMatchMode", -1)
   Local $hWin = WinGetHandle($Title)
   Local $error = @error
   Opt("WinTitleMatchMode", $iMode)
   If $error = 0 Then
	  ; window found, check title for case insensitive match
	  $t = WinGetTitle($hWin)
	  If $Title = $t And ControlGetHandle($hWin, $AppPaneName, $AppClassInstance) <> 0 Then
		 ; all good, update $HWnD and exit
		 If $HWnD <> $hWin Then SetDebugLog("Found " & $Android & " Window '" & $t & "' (" & $hWin & ") by matching title '" & $Title & "' (#2)")
		 $HWnD = $hWin
		 $Title = $t
		 If $ReInitAndroid = True And $InitAndroid = False Then ; Only initialize Android when not currently running
			$InitAndroid = True ; change window, re-initialize Android config
			InitAndroid()
		 EndIf
		 Return $hWin
	  Else
		 SetDebugLog($Android & " Window title '" & $t & "' not matching '" & $Title & "' or control")
	  EndIf
   EndIf

   ; Check for multiple windows
   $iMode = Opt("WinTitleMatchMode", -1)
   $aWinList = WinList($Title)
   Opt("WinTitleMatchMode", $iMode)
   If $aWinList[0][0] = 0 Then
	  SetDebugLog($Android & " Window not found")
	  If $ReInitAndroid = True Then $InitAndroid = True ; no window anymore, re-initialize Android config
	  $HWnD = 0
	  Return 0
   EndIF
   SetDebugLog("Found " & $aWinList[0][0] & " possible " & $Android & " windows by title '" & $Title & "':")
   For $i = 1 To $aWinList[0][0]
	  SetDebugLog($aWinList[$i][1] & ": " & $aWinList[$i][0])
   Next
   If $AndroidInstance <> "" Then
	  ; Check for given instance
	  For $i = 1 To $aWinList[0][0]
		 $t = $aWinList[$i][0]
		 $hWin = $aWinList[$i][1]
		 If StringRight($t, StringLen($AndroidInstance)) = $AndroidInstance And ControlGetHandle($hWin, $AppPaneName, $AppClassInstance) <> 0 Then
			; looks good, update $HWnD, $Title and exit
			SetDebugLog("Found " & $Android & " Window '" & $t & "' (" & $hWin & ") for instance " & $AndroidInstance)
			$HWnD = $hWin
			$Title = $t
			If $ReInitAndroid = True And $InitAndroid = False Then ; Only initialize Android when not currently running
			   $InitAndroid = True ; change window, re-initialize Android config
			   InitAndroid()
			EndIf
			Return $hWin
		 EndIf
	  Next
   EndIf
   ; Check by command line
   If $AndroidProgramPath <> "" Then
	  Local $parameter = GetAndroidProgramParameter(False)
	  Local $parameter2 = GetAndroidProgramParameter(True)
	  Local $pid = ProcessExists2($AndroidProgramPath, $parameter)
	  If $pid = 0 And $parameter <> $parameter2 Then
		 ; try alternative parameter
		 $parameter = $parameter2
		 $pid = ProcessExists2($AndroidProgramPath, $parameter)
	  EndIf
	  Local $commandLine = $AndroidProgramPath & ($parameter = "" ? "" : " " & $parameter)
	  If $pid <> 0 Then
		 For $i = 1 To $aWinList[0][0]
			$t = $aWinList[$i][0]
			$hWin = $aWinList[$i][1]
			If $pid = WinGetProcess($hWin) And ControlGetHandle($hWin, $AppPaneName, $AppClassInstance) <> 0 Then
			   SetDebugLog("Found " & $Android & " Window '" & $t & "' (" & $hWin & ") by PID " & $pid & " ('" & $commandLine & "')")
			   $HWnD = $hWin
			   $Title = $t
			   If $ReInitAndroid = True And $InitAndroid = False Then ; Only initialize Android when not currently running
				  $InitAndroid = True ; change window, re-initialize Android config
				  InitAndroid()
			   EndIf
			   Return $hWin
			EndIf
		 Next
		 SetDebugLog($Android & ($AndroidInstance = "" ? "" : " (" & $AndroidInstance & ")") & " Window not found for PID " & $pid)
	  EndIf
   EndIf

   SetDebugLog($Android & ($AndroidInstance = "" ? "" : " (" & $AndroidInstance & ")") & " Window not found in list")
   If $ReInitAndroid = True Then $InitAndroid = True ; no window anymore, re-initialize Android config
   $HWnD = 0
   Return 0
EndFunc

Func GetAndroidSvcPid()
   If $AndroidSvcPid <> 0 And $AndroidSvcPid = ProcessExists($AndroidSvcPid) Then
	  Return $AndroidSvcPid
   EndIf

   SetError(0, 0, 0)
   Local $pid = Execute("Get" & $Android & "SvcPid()")
   If $pid = "" And @error <> 0 Then $pid = GetVBoxAndroidSvcPid() ; Not implemented, use VBox default

   If $pid <> 0 Then
	  SetDebugLog("Found " & $Android & " Service PID = " & $pid)
   Else
	  SetDebugLog("Cannot find " & $Android & " Service PID", $COLOR_RED)
   EndIf
   $AndroidSvcPid = $pid
   Return $pid
EndFunc

Func GetVBoxAndroidSvcPid()

   ; find vm uuid (it's used as command line parameter)
   Local $aRegExResult = StringRegExp($__VBoxVMinfo, "UUID:\s+(.+)", $STR_REGEXPARRAYMATCH)
   Local $uuid = ""
   If Not @error Then $uuid = $aRegExResult[0]
   If StringLen($uuid) < 32 Then
	  SetDebugLog("Cannot find VBox UUID", $COLOR_RED)
	  Return 0
   EndIf

   ; find process PID
   Local $pid = ProcessExists2("", $uuid, 1, 1)
   Return $pid

EndFunc

; Checks if Android is running and returns array of window handle and instance name
; $bStrictCheck = False includes "unsupported" ways of launching Android (like BlueStacks2 default launch shortcut)
Func GetAndroidRunningInstance($bStrictCheck = True)
   Local $runningInstance = Execute("Get" & $Android & "RunningInstance(" & $bStrictCheck & ")")
   If $runningInstance = "" And @error <> 0 Then ; Not implemented
	  Local $a[2] = [0, ""]
	  SetDebugLog("GetAndroidRunningInstance: Try to find """ & $AndroidProgramPath & """")
	  Local $pid = ProcessExists2($AndroidProgramPath, "", 1) ; find any process
	  If $pid <> 0 Then
		 Local $currentInstance = $AndroidInstance
		 ; assume last parameter is instance
		 Local $commandLine = ProcessGetCommandLine($pid)
		 SetDebugLog("GetAndroidRunningInstance: Found """ & $commandLine & """ by PID=" & $pid)
		 Local $lastSpace = StringInStr($commandLine, " ", 0, -1)
		 If $lastSpace > 0 Then
			$AndroidInstance = StringStripWS(StringMid($commandLine, $lastSpace + 1), 3)
			; Check that $AndroidInstance default instance is used for ""
			If $AndroidInstance = "" Then $AndroidInstance = $AndroidAppConfig[$AndroidConfig][1]
			SetDebugLog("Running " & $Android & " instance is """ & $AndroidInstance & """")
		 EndIf
		 ; validate
		 If WinGetAndroidHandle() <> 0 Then
			$a[0] = $HWnD
			$a[1] = $AndroidInstance
		 Else
			$AndroidInstance = $currentInstance
		 EndIf
	  EndIf
	  Return $a
   EndIf
   Return $runningInstance
EndFunc

; Detects first running Android Window is present based on $AndroidAppConfig array sequence
Func DetectRunningAndroid()
    SetDebugLog("DetectRunningAndroid()")
	; Find running Android Emulator
    $FoundRunningAndroid = False

	Local $i, $CurrentConfig = $AndroidConfig
    $SilentSetLog = True
	For $i = 0 To UBound($AndroidAppConfig) - 1
	  $AndroidConfig = $i
	  $InitAndroid = True
	  If UpdateAndroidConfig() = True Then
		 ; this Android is installed
		 Local $aRunning = GetAndroidRunningInstance(False)
		 If $aRunning[0] = 0 Then
			; not running
		 Else
			; Window is available
			$FoundRunningAndroid = True
			$SilentSetLog = False
			$InitAndroid = True ; init Android again now
			If InitAndroid() = True Then
			   SetDebugLog("Found running " & $Android & " " & $AndroidVersion)
			EndIf
			Return
		 EndIf
	  EndIf
	Next

    ; Reset to current config
    $InitAndroid = True
	$AndroidConfig = $CurrentConfig
    UpdateAndroidConfig()
    $SilentSetLog = False
    SetDebugLog("Found no running Android Emulator")
EndFunc   ;==>DetectRunningAndroid

; Detects first installed Adnroid Emulator installation based on $AndroidAppConfig array sequence
Func DetectInstalledAndroid()
    SetDebugLog("DetectInstalledAndroid()")
	; Find installed Android Emulator

	Local $i, $CurrentConfig = $AndroidConfig
    $SilentSetLog = True
	For $i = 0 To UBound($AndroidAppConfig) - 1
	    $AndroidConfig = $i
		$InitAndroid = True
		If UpdateAndroidConfig() Then
		    ; installed Android found
			$FoundInstalledAndroid = True
			$SilentSetLog = False
			SetDebugLog("Found installed " & $Android & " " & $AndroidVersion)
			Return
		EndIf
	Next

    ; Reset to current config
	$AndroidConfig = $CurrentConfig
	$InitAndroid = True
    UpdateAndroidConfig()
    $SilentSetLog = False
    SetDebugLog("Found no installed Android Emulator")
EndFunc   ;==>DetectInstalledAndroid

; Find preferred Adb Path. Priority is MEmu, Droid4X. If non found, empty string is returned.
Func FindPreferredAdbPath()
   Local $adbPath
   $adbPath = Execute("GetMEmuAdbPath()")
   If $adbPath <> "" Then Return $adbPath
   $adbPath = Execute("GetNoxAdbPath()")
   If $adbPath <> "" Then Return $adbPath
   $adbPath = Execute("GetDroid4XAdbPath()")
   If $adbPath <> "" Then Return $adbPath
   Return ""
EndFunc

Func InitAndroid($bCheckOnly = False)
    If $bCheckOnly = False And $InitAndroid = False Then
	   SetDebugLog("InitAndroid(" & $bCheckOnly & "): " & $Android & " is already initialized")
	   Return True
    EndIF
    SetDebugLog("InitAndroid(" & $bCheckOnly & "): " & $Android)
	If Not $bCheckOnly Then
	   ; Check that $AndroidInstance default instance is used for ""
	   If $AndroidInstance = "" Then $AndroidInstance = $AndroidAppConfig[$AndroidConfig][1]
    EndIf
   	Local $Result = Execute("Init" & $Android & "(" & $bCheckOnly & ")")
	If Not $bCheckOnly And $Result Then
	   SetDebugLog("Android: " & $Android)
	   SetDebugLog("Android Config: " & $AndroidConfig)
	   SetDebugLog("Android Version: " & $AndroidVersion)
	   SetDebugLog("Android Instance: " & $AndroidInstance)
	   SetDebugLog("Android Window Title: " & $Title)
	   SetDebugLog("Android Program Path: " & $AndroidProgramPath)
	   SetDebugLog("Android Program Parameter: " & GetAndroidProgramParameter())
	   SetDebugLog("Android ADB Path: " & $AndroidAdbPath)
	   SetDebugLog("Android ADB Device: " & $AndroidAdbDevice)
	   SetDebugLog("Android ADB Shared Folder: " & $AndroidPicturesPath)
	   ; add $AndroidPicturesHostFolder to $AndroidPicturesHostPath
	   If FileExists($AndroidPicturesHostPath) Then
		 DirCreate($AndroidPicturesHostPath & $AndroidPicturesHostFolder)
	   EndIf
	   SetDebugLog("Android ADB Shared Folder on Host: " & $AndroidPicturesHostPath)
	   SetDebugLog("Android ADB Shared SubFolder: " & $AndroidPicturesHostFolder)
	   SetDebugLog("Android Mouse Device: " & $AndroidMouseDevice)
	   SetDebugLog("Android ADB screencap command enabled: " & $AndroidAdbScreencap)
	   SetDebugLog("Android ADB input command enabled: " & $AndroidAdbInput)
	   SetDebugLog("Android ADB Mouse Click enabled: " & $AndroidAdbClick)
	   ;$HWnD = WinGetHandle($Title) ;Handle for Android window
	   WinGetAndroidHandle() ; Set $HWnD and $Title for Android window
	   InitAndroidTimeLag()
    EndIf
    SetDebugLog("InitAndroid(" & $bCheckOnly & "): " & $Android & " END")
	$InitAndroid = False
	Return $Result
EndFunc   ;==>InitAndroid

Func GetAndroidProgramParameter($bAlternative = False)
   Local $Parameter = Execute("Get" & $Android & "ProgramParameter(" & $bAlternative & ")")
   If $Parameter = "" And @error <> 0 Then $Parameter = "" ; Not implemented
   Return $Parameter
EndFunc

Func AndroidBotStartEvent()
   Local $Result = Execute($Android & "BotStartEvent()")
   If $Result = "" And @error <> 0 Then $Result = "" ; Not implemented
   Return $Result
EndFunc

Func AndroidBotStopEvent()
   Local $Result = Execute($Android & "BotStopEvent()")
   If $Result = "" And @error <> 0 Then $Result = "" ; Not implemented
   Return $Result
EndFunc

Func OpenAndroid($bRestart = False)
    ResumeAndroid()
    AndroidAdbTerminateShellInstance()
    If Not $RunState Then Return False
	Return Execute("Open" & $Android & "(" & $bRestart & ")")
EndFunc   ;==>OpenAndroid

Func RestartAndroidCoC($bInitAndroid = True)
   ResumeAndroid()
   If Not $RunState Then Return False
   ;Return Execute("Restart" & $Android & "CoC()")
   If $bInitAndroid Then
	  If Not InitAndroid() Then Return False
   EndIf

   Local $cmdOutput, $process_killed, $connected_to
   ;WinActivate($HWnD)  	; ensure bot has window focus

   ; Test ADB is connected
   ;$cmdOutput = LaunchConsole($AndroidAdbPath, "connect " & $AndroidAdbDevice, $process_killed)
   ;$connected_to = StringInStr($cmdOutput, "connected to")

   SetLog("Please wait for CoC restart......", $COLOR_BLUE)   ; Let user know we need time...
   ;AndroidAdbTerminateShellInstance()
   ;AndroidAdbLaunchShellInstance()
   ConnectAndroidAdb()
   $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell am start -S -n " & $AndroidGamePackage & "/" & $AndroidGameClass, $process_killed, 30 * 1000) ; removed "-W" option and added timeout (didn't exit sometimes)
   If Not $RunState Then Return
   If StringInStr($cmdOutput, "Error:") > 0 and StringInStr($cmdOutput, $AndroidGamePackage) > 0 Then
	  SetLog("Unable to load Clash of Clans, install/reinstall the game.", $COLOR_RED)
	  SetLog("Unable to continue........", $COLOR_MAROON)
	  btnStop()
	  SetError(1, 1, -1)
	  Return False
   EndIf

   ; increase priority of game
   Local $renice = "/system/xbin/renice -20 "
   $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell " & $renice & "$(pidof " & $AndroidGamePackage & ")", $process_killed, 30 * 1000)
   If StringInStr($cmdOutput, "not found") > 0 Then
	  $renice = "renice -- -20 "
	  $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell " & $renice & "$(pidof " & $AndroidGamePackage & ")", $process_killed, 30 * 1000)
   EndIf

   If Not IsAdbConnected($cmdOutput) Then
	  If Not ConnectAndroidAdb() Then Return False
   EndIf

   Return True
EndFunc   ;==>RestartAndroidCoC

Func CloseAndroid()
    ResumeAndroid()

    AndroidAdbTerminateShellInstance()

    If Not $RunState Then Return False
	Return Execute("Close" & $Android & "()")
EndFunc   ;==>CloseAndroid

Func SetScreenAndroid()
    ResumeAndroid()
    If Not $RunState Then Return False
	; Set Android screen size and dpi
	SetLog("Set " & $Android & " screen resolution to " & $AndroidClientWidth & " x " & $AndroidClientHeight, $COLOR_BLUE)
	Local $Result = Execute("SetScreen" & $Android & "()")
	If $Result Then
	   SetLog("A restart of your computer might be required", $COLOR_ORANGE)
	   SetLog("for the applied changes to take effect.", $COLOR_ORANGE)
    EndIf
    Return $Result
EndFunc   ;==>SetScreenAndroid

Func CloseUnsupportedAndroid()
   ResumeAndroid()
   If Not $RunState Then Return False
   SetError(0, 0, 0)
   Local $Closed = Execute("CloseUnsupported" & $Android & "()")
   If $Closed = "" And @error <> 0 Then Return False ; Not implemented
   Return $Closed
EndFunc

Func RebootAndroidSetScreen()
    ResumeAndroid()
    If Not $RunState Then Return False
	Return Execute("Reboot" & $Android & "SetScreen()")
EndFunc   ;==>RebootAndroidSetScreen

Func IsAdbTCP()
   Return StringInStr($AndroidAdbDevice, ":") > 0
EndFunc

Func WaitForRunningVMS($WaitInSec = 120, $hTimer = 0)
   ResumeAndroid()
   If Not $RunState Then Return True
   Local $cmdOutput, $connected_to, $running, $process_killed, $hMyTimer
   $hMyTimer = ($hTimer = 0 ? TimerInit() : $hTimer)
   While True
	  If Not $RunState Then Return
	  $cmdOutput = LaunchConsole($__VBoxManage_Path, "list runningvms", $process_killed)
	  If Not $RunState Then Return True
	  $running = StringInStr($cmdOutput, """" & $AndroidInstance & """") > 0
	  If $running = True Then ExitLoop
	  If $hTimer <> 0 Then _StatusUpdateTime($hTimer)
	  _Sleep(3000) ; Sleep 3 Seconds
	  If TimerDiff($hMyTimer) > $WaitInSec * 1000 Then ; if no device available in 4 minutes, Android/PC has major issue so exit
		 SetLog("Serious error has occurred, please restart PC and try again", $COLOR_RED)
		 SetLog($Android & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for boot completed", $COLOR_RED)
		 SetError(1, @extended, False)
		 Return True
	  EndIf
   WEnd
   Return False
EndFunc

Func WaitForAndroidBootCompleted($WaitInSec = 120, $hTimer = 0)
   ResumeAndroid()
   If Not $RunState Then Return True
   Local $cmdOutput, $connected_to, $booted, $process_killed, $hMyTimer
	; Wait for boot completed
	$hMyTimer = ($hTimer = 0 ? TimerInit() : $hTimer)
	While True
	  If Not $RunState Then Return
	  $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell getprop sys.boot_completed", $process_killed)
	  ; Test ADB is connected
	  $connected_to = IsAdbConnected($cmdOutput)
	  If Not $RunState Then Return True
	  If Not $connected_to Then ConnectAndroidAdb(False)
	  If Not $RunState Then Return True
	  $booted = StringLeft($cmdOutput, 1) = "1"
	  If $booted = True Then ExitLoop
	  If $hTimer <> 0 Then _StatusUpdateTime($hTimer)
	  _Sleep(3000) ; Sleep 3 Seconds
	  If TimerDiff($hMyTimer) > $WaitInSec * 1000 Then ; if no device available in 4 minutes, Android/PC has major issue so exit
		 SetLog("Serious error has occurred, please restart PC and try again", $COLOR_RED)
		 SetLog($Android & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for boot completed", $COLOR_RED)
		 SetError(1, @extended, False)
		 Return True
	  EndIf
    WEnd
	Return False
EndFunc

Func IsAdbConnected($cmdOutput = Default)
   ResumeAndroid()
   If $__TEST_ERROR_ADB_DEVICE_NOT_FOUND Then Return False
   Local $process_killed, $connected_to
   If $cmdOutput = Default Then
	  if IsAdbTCP() Then
		 $cmdOutput = LaunchConsole($AndroidAdbPath, "connect " & $AndroidAdbDevice, $process_killed)
		 $connected_to = StringInStr($cmdOutput, "connected to") > 0
	  Else
		 $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell whoami", $process_killed)
		 $connected_to = StringInStr($cmdOutput, " not ") = 0
	  EndIf
   Else
	  ; $cmdOutput was specified
	  $connected_to = StringInStr($cmdOutput, " not ") = 0
   EndIf
   Return $connected_to
EndFunc

Func AquireAdbDaemonMutex($timout = 30000)
   Local $timer = TimerInit()
   Local $hMutex_MyBot = 0
   While $hMutex_MyBot = 0 And TimerDiff($timer) < $timout
	  $hMutex_MyBot = _Singleton("MyBot.run/AdbDaemonLaunch", 1)
	  If $hMutex_MyBot <> 0 Then ExitLoop
	  If _Sleep(250) Then ExitLoop
   WEnd
   Return $hMutex_MyBot
EndFunc

Func ReleaseAdbDaemonMutex($hMutex, $ReturnValue = Default)
   _WinAPI_CloseHandle($hMutex)
   If $ReturnValue = Default Then Return
   Return $ReturnValue
EndFunc

Func ConnectAndroidAdb($rebootAndroidIfNeccessary = $RunState, $timeout = 15000)
   ResumeAndroid()

   Local $hMutex = AquireAdbDaemonMutex()

   Local $process_killed, $cmdOutput
   Local $connected_to = False
   Local $timer = TimerInit()
   While TimerDiff($timer) < $timeout ; wait max 15 Seconds before killing ADB daemon
	  $connected_to = IsAdbConnected()
	  If $connected_to Then Return ReleaseAdbDaemonMutex($hMutex, True) ; all good, adb is connected
	  If _Sleep(3000) Then Return ReleaseAdbDaemonMutex($hMutex, False) ; True ; interrupted and return True not to start any failback logic
   WEnd
   ; not connected... strange, kill any Adb now
   SetDebugLog("Stop ADB daemon!", $COLOR_RED)
   LaunchConsole($AndroidAdbPath, "kill-server", $process_killed)
   Local $pids = ProcessesExist($AndroidAdbPath, "", 1)
   For $i = 0 To UBound($pids) - 1
	  KillProcess($pids[$i], $AndroidAdbPath)
   Next
   ; ok, now try to connect again
   $connected_to = IsAdbConnected()
   ReleaseAdbDaemonMutex($hMutex)

   If Not $connected_to And $RunState = True And $rebootAndroidIfNeccessary = True Then
	  ; not good, what to do now? Reboot Android...
	  SetLog("ADB cannot connect to " & $Android & ", restart emulator now...", $COLOR_RED)
	  If Not RebootAndroid() Then Return False
      ; ok, last try
	  $connected_to = ConnectAndroidAdb(False)
	  If Not $connected_to Then
		 ; Let's give up...
		 If Not $RunState Then Return False ; True ; interrupted and return True not to start any failback logic
		 SetLog("ADB really cannot connect to " & $Android & "!", $COLOR_RED)
		 SetLog("Please restart bot, emulator and/or PC...", $COLOR_RED)
		 #cs
		 _ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		 Local $stxt = @CRLF & "MyBot has experienced a serious error" & @CRLF & @CRLF & _
			"Unable connecting ADB to " & $Android & @CRLF & @CRLF & "Reboot PC and try again," & _
			"and search www.mybot.run forums for more help" & @CRLF
		 Local $MsgBox = _ExtMsgBox(0, "Close MyBot!", "Okay - Must Exit Program", $stxt, 15) ; how patient is the user ;) ?
		 If $MsgBox = 1 Then
			 BotClose()
		 EndIf
		 btnStop()
		 #ce
		 Return False
	  EndIf
   EndIf

   Return True ; ADB is connected
EndFunc

Func RebootAndroid($bRestart = True)
    ResumeAndroid()
    If Not $RunState Then Return False

	; Close Android
	If CloseUnsupportedAndroid() Then
	   ; Unsupport Emulator now closed, screen config is now adjusted
    Else
	   ; Close Emulator
	  CloseAndroid()
    EndIf
	If _Sleep(1000) Then Return False

	; Start Android
	OpenAndroid($bRestart)

    ; Better create a func AndroidCoCStartEvent
	AndroidBotStartEvent()

	Return True
EndFunc   ;==>RebootAndroid

Func RebootAndroidSetScreenDefault()
    ResumeAndroid()
    If Not $RunState Then Return False

    ; Set font size to normal
    AndroidSetFontSizeNormal()

	; Close Android
	CloseAndroid()
	If _Sleep(1000) Then Return False

	SetScreenAndroid()

	; Start Android
	OpenAndroid()

	Return True

EndFunc   ;==>RebootAndroidSetScreenDefault

Func CheckScreenAndroid($ClientWidth, $ClientHeight, $bSetLog = True)
   ResumeAndroid()
   If Not $RunState Then Return True

   AndroidAdbLaunchShellInstance()
   If Not $RunState Then Return True

   Local $ok = ($ClientWidth = $AndroidClientWidth) And ($ClientHeight = $AndroidClientHeight)
   If Not $ok Then
	  If $bSetLog Then SetLog("MyBot doesn't work with " & $Android & " screen resolution of " & $ClientWidth & " x " & $ClientHeight & "!", $COLOR_RED)
	  SetDebugLog("CheckScreenAndroid: " & $ClientWidth & " x " & $ClientHeight & " <> " & $AndroidClientWidth & " x " & $AndroidClientHeight)
	  Return False
   EndIf

   ; check display font size
   AndroidAdbLaunchShellInstance()
   Local $s_font_scale = AndroidAdbSendShellCommand("settings get system font_scale")
   Local $font_scale = Number($s_font_scale)
   If $font_scale > 0 Then
	  SetDebugLog($Android & " font_scale = " & $font_scale)
	  If $font_scale <> 1 Then
		 SetLog("MyBot doesn't work with Display Font Scale of " & $font_scale, $COLOR_RED)
		 Return False
	  EndIf
   Else
	  Switch $Android
	  Case "BlueStacks", "BlueStacks2" ; BlueStacks doesn't support it
	  Case Else
		 SetLog($Android & " Display Font Scale cannot be verified", $COLOR_RED)
	  EndSwitch
   EndIf

   ; check emulator specific setting
   SetError(0, 0, 0)
   $ok = Execute("CheckScreen" & $Android & "(" & $bSetLog & ")")
   If $ok = "" And @error <> 0 Then Return True ; Not implemented
   Return $ok

EndFunc

Func AndroidSetFontSizeNormal()
   ResumeAndroid()
   AndroidAdbLaunchShellInstance()
   AndroidAdbSendShellCommand("settings put system font_scale 1.0")
EndFunc

Func AndroidAdbLaunchShellInstance($wasRunState = $RunState)
   If $AndroidAdbPid = 0 Or ProcessExists($AndroidAdbPid) <> $AndroidAdbPid Then
	  Local $SuspendMode = ResumeAndroid()
	  InitAndroid()
	  Local $s
	  If $AndroidAdbInstance = True Then
		 ConnectAndroidAdb()
		 $AndroidAdbPid = Run($AndroidAdbPath & " -s " & $AndroidAdbDevice & " shell", "", @SW_HIDE, BitOR($STDIN_CHILD, $STDERR_MERGED))
		 If $AndroidAdbPid = 0 Or ProcessExists($AndroidAdbPid) <> $AndroidAdbPid Then
			SetLog($Android & " error launching ADB for background mode, zoom-out, mouse click and input", $COLOR_RED)
			$AndroidAdbScreencap = False
			$AndroidAdbClick = False
			$AndroidAdbInput = False
			If BitAND($AndroidSupportFeature, 1) = 0 Then $ichkBackground = 0 ; disable also background mode the hard way
			SetError(1, 0)
		 EndIf
		 ; increase shell priority
		 $s = AndroidAdbSendShellCommand("PS1=" & $AndroidAdbPrompt, Default, $wasRunState, False) ; set prompt to unique string $AndroidAdbPrompt
		 Local $renice = "/system/xbin/renice -20 "
		 $s = AndroidAdbSendShellCommand($renice & "$$", Default, $wasRunState, False) ; increase shell priority to maximum
		 If StringInStr($s, "not found") > 0 Then
			$renice = "renice -- -20 "
			$s = AndroidAdbSendShellCommand($renice & "$$", Default, $wasRunState, False) ; increase shell priority to maximum
		 EndIf
		 $s &= AndroidAdbSendShellCommand("stop media", Default, $wasRunState, False) ; stop media service as it can consume up to 30% Android CPU
		 Local $error = @error
		 SetDebugLog("ADB shell launched, PID = " & $AndroidAdbPid & ": " & $s)
		 If $error <> 0 Then
			SuspendAndroid($SuspendMode)
			Return
		 EndIf

	  EndIf
	  ; check mouse device
	  If StringLen($AndroidMouseDevice) > 0 And $AndroidMouseDevice = $AndroidAppConfig[$AndroidConfig][13] Then
		 If StringInStr($AndroidMouseDevice, "/dev/input/event") = 0 Then
			; use getevent to find mouse input device
			$s = AndroidAdbSendShellCommand("getevent -p", Default, $wasRunState, False)
			SetDebugLog($Android & " getevent -p: " & $s)
			Local $aRegExResult = StringRegExp($s, "(\/dev\/input\/event\d+)[\r\n]+.+""" & $AndroidMouseDevice & """", $STR_REGEXPARRAYMATCH)
			If @error = 0 Then
			   $AndroidMouseDevice = $aRegExResult[0]
			   SetDebugLog("Using " & $AndroidMouseDevice & " for mouse events")
			Else
			   $AndroidAdbClick = False
			   SetLog($Android & " cannot use ADB for mouse events, """ & $AndroidMouseDevice & """ not found", $COLOR_RED)
			   SuspendAndroid($SuspendMode)
			   Return SetError(2, 1)
			EndIf
		 Else
			SetDebugLog($Android & " ADB use " & $AndroidMouseDevice & " for mouse events")
		 EndIf
	  EndIf
	  SuspendAndroid($SuspendMode)
	  Return SetError(0, 1)
   EndIf
   SetError(0, 0)
EndFunc

Func AndroidAdbTerminateShellInstance()
   Local $SuspendMode = ResumeAndroid()
   If $AndroidAdbPid <> 0 Then
	  If ProcessClose($AndroidAdbPid) = 1 Then
		 SetDebugLog("ADB shell terminated, PID = " & $AndroidAdbPid)
	  Else
		 SetDebugLog("ADB shell not terminated, PID = " & $AndroidAdbPid, $COLOR_RED)
	  EndIf
	  $AndroidAdbPid = 0
   EndIf
   SuspendAndroid($SuspendMode)
EndFunc

Func AndroidAdbSendShellCommand($cmd = Default, $timeout = Default, $wasRunState = $RunState, $EnsureShellInstance = True)
   Local $_SilentSetLog = $SilentSetLog
   If $timeout = Default Then $timeout = 3000 ; default is 3 sec.
   Local $hTimer = TimerInit()
   Local $sentBytes = 0
   Local $SuspendMode = ResumeAndroid()
   SetError(0, 0, 0)
   If $EnsureShellInstance = True Then
	  AndroidAdbLaunchShellInstance($wasRunState) ; recursive call in AndroidAdbLaunchShellInstance!
   EndIf
   If @error <> 0 Then Return SetError(@error, 0, "")
   Local $s = ""
   Local $loopCount = 0
   Local $cleanOutput = True
   If $AndroidAdbInstance = True Then
	  ; use steady ADB shell
	  StdoutRead($AndroidAdbPid) ; clean output
	  If $cmd = Default Then
		 ; nothing to launch
	  Else
		 If $debugSetlog = 1 Then
			$SilentSetLog = True
			SetDebugLog("Send ADB shell command: " & $cmd)
			$SilentSetLog = $_SilentSetLog
		 EndIf
		 $sentBytes = StdinWrite($AndroidAdbPid, $cmd & @LF)
	  EndIf
	  While $timeout > 0 And @error = 0 And StringRight($s, StringLen($AndroidAdbPrompt) + 1) <> @LF & $AndroidAdbPrompt And TimerDiff($hTimer) < $timeout
		 Sleep(10)
		 $s &= StdoutRead($AndroidAdbPid)
		 $loopCount += 1
		 If $wasRunState = True And $RunState = False Then ExitLoop ; stop pressed here, exit without error
	  WEnd
   Else
	  ; invoke new single ADB shell command
	  $cleanOutput = False
	  If $cmd = Default Then
		 ; nothing to launch
	  Else
		 Local $process_killed
		 If $debugSetlog = 1 Then
			$SilentSetLog = True
			SetDebugLog("Execute ADB shell command: " & $cmd)
			$SilentSetLog = $_SilentSetLog
		 EndIf
		 $s = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell " & $cmd, $process_killed, $timeout)
	  EndIf
   EndIf

   If $cleanOutput = True Then
	  Local $i = StringInStr($s, @LF)
	  If $i > 0 Then $s = StringMid($s, $i) ; remove echo'd command
	  If StringRight($s, StringLen($AndroidAdbPrompt) + 1) = @LF & $AndroidAdbPrompt Then $s = StringLeft($s, StringLen($s) - StringLen($AndroidAdbPrompt) - 1) ; remove tailing prompt
	  CleanLaunchOutput($s)
	  If StringLeft($s, 1) = @LF Then $s = StringMid($s, 2) ; remove starting @LF
   EndIf
   ;SetDebugLog("ADB shell command output: " & $s)
   SuspendAndroid($SuspendMode)
   Local $error = (($RunState = False Or TimerDiff($hTimer) < $timeout Or $timeout < 1) ? 0 : 1)
   If $error <> 0 Then SetDebugLog("ADB shell command error " & $error & ": " & $s)
   If $__TEST_ERROR_SLOW_ADB_SHELL_COMMAND_DELAY > 0 Then Sleep($__TEST_ERROR_SLOW_ADB_SHELL_COMMAND_DELAY)
   $AndroidAdbAutoTerminateCount += 1
   If Mod($AndroidAdbAutoTerminateCount, $AndroidAdbAutoTerminate) = 0 And $EnsureShellInstance = True Then
	  AndroidAdbTerminateShellInstance()
   EndIF
   Return SetError($error, Int(TimerDiff($hTimer)) & "ms,#" & $loopCount, $s)
EndFunc

Func AndroidAdbSendShellCommandScript($scriptFile, $combine = true, $timeout = Default, $wasRunState = $RunState)
   If $timeout = Default Then $timeout = 10000 ; default is 10 sec. for scripts
   Local $hostPath = $AndroidPicturesHostPath & $AndroidPicturesHostFolder
   Local $androidPath = $AndroidPicturesPath & StringReplace($AndroidPicturesHostFolder, "\", "/")

   If $HwND <> WinGetHandle($HwND) Then Return SetError(2, 0) ; Window gone
   AndroidAdbLaunchShellInstance()
   If @error <> 0 Then Return SetError(3, 0)

   If StringInStr($AndroidMouseDevice, "/dev/input/event") = 0 Then
	  $AndroidAdbClick = False
	  SetLog($Android & " mouse device not configured", $COLOR_RED)
	  Return SetError(4, 0, 0)
   EndIf

   Local $hTimer = TimerInit()
   Local $hFileOpen = FileOpen($AdbScriptsDir & "\" & $scriptFile)
   If $hFileOpen = -1 Then
	  SetLog("ADB script file not found: " & $scriptFile, $COLOR_RED)
	  Return SetError(5, 0)
   EndIf

   Local $script = FileRead($hFileOpen)
   FileClose($hFileOpen)
   Local $scriptModifiedTime = FileGetTime($AdbScriptsDir & "\" & $scriptFile, $FT_MODIFIED, $FT_STRING)

   Local $scriptFileSh = $scriptFile & ".sh"
   $script = StringReplace($script, "{$AndroidMouseDevice}", $AndroidMouseDevice)
   If @extended > 0 Then
	  $scriptFileSh = $scriptFile & StringReplace($AndroidMouseDevice, "/", ".") & ".sh"
   EndIf
   $script = StringReplace($script, @CRLF, @LF)

   Local $aCmds = StringSplit($script, @LF)
   Local $i
   Local $hTimer = TimerInit()
   Local $s = ""

   SetError(0, 0)
   Local $cmds = ""
   For $i = 1 to $aCmds[0]
	  Local $cmd = $aCmds[$i]
	  If StringInStr($cmd, "/dev/input/") = 1 Then
		 ; convert getevent into sendevent
		 Local $aElem = StringSplit($cmd, " ")
		 If $aElem[0] < 4 Then
			SetDebugLog("ADB script " & $scriptFile & ": ignore line " & $i & ": " & $cmd, $COLOR_ORANGE)
		 Else
			$cmd = "sendevent " & StringReplace($aElem[1], ":", "") & " " & Dec($aElem[2]) & " " & Dec($aElem[3]) & " " & Dec($aElem[4])
		 EndIf
		 $aCmds[$i] = $cmd
	  EndIf
	  $cmd = StringStripWS($aCmds[$i], 3)
	  If $combine = True And StringLen($cmd) > 0 Then
		 $cmds &= $cmd
		 if $i < $aCmds[0] Then $cmds &= ";"
	  EndIf
   Next

   Local $loopCount = 0
   If StringLen($cmds) <= 1024 Then
	  ; invoke commands now
	  $s = AndroidAdbSendShellCommand($cmds, $timeout, $wasRunState)
	  If @error <> 0 Then Return SetError(1, 0, $s)
	  Local $a = StringSplit(@extended, "#")
	  If $a[0] > 1 Then $loopCount += Number($a[2])
   Else
	  ; create sh file in shared folder
	  If FileExists($hostPath) = 0 Then
		 SetLog($Android & " ADB script file folder doesn't exist:", $COLOR_RED)
		 SetLog($hostPath, $COLOR_RED)
		 Return SetError(6, 0)
	  EndIf
	  If $scriptModifiedTime <> FileGetTime($hostPath & $scriptFileSh, $FT_MODIFIED, $FT_STRING) Then
		 FileDelete($hostPath & $scriptFileSh) ; delete existing file as new version is available
	  EndIf
	  If FileExists($hostPath & $scriptFileSh) = 0 Then
		 ; create script file
		 $script = "#!/bin/sh"
		 For $i = 1 to $aCmds[0]
			If $i = 1 And $aCmds[$i] = $cmds  Then
			   $script = ""
			Else
			   $script &= @LF
			EndIf
			$script &= $aCmds[$i]
		 Next
		 ; create sh file
		 If FileWrite($hostPath & $scriptFileSh, $script) = 1 Then
			SetLog("ADB script file created: " & $hostPath & $scriptFileSh)
		 Else
			SetLog("ADB cannot create script file: " & $hostPath & $scriptFileSh, $COLOR_RED)
			Return SetError(7, 0)
		 EndIf
		 FileSetTime($hostPath & $scriptFileSh, $scriptModifiedTime, $FT_MODIFIED) ; set modification date of source
	  EndIf
	  $s = AndroidAdbSendShellCommand("sh """ & $androidPath & $scriptFileSh & """", $timeout, $wasRunState)
	  If @error <> 0 Then
		 SetDebugLog("Error executing " & $scriptFileSh & ": " & $s)
		 Return SetError(1, 0, $s)
	  EndIf
	  Local $a = StringSplit(@extended, "#")
	  If $a[0] > 1 Then $loopCount += Number($a[2])
   EndIf

   Return SetError(0, Int(TimerDiff($hTimer)) & "ms,#" & $loopCount, $s)
EndFunc

;==================================================================================================================================
; Author ........: UEZ
; Modified.......: progandy, cosote
;===================================================================================================================================
Func __GDIPlus_BitmapCreateFromMemory($dImage, $bHBITMAP = False)
	If Not IsBinary($dImage) Then Return SetError(1, 0, 0)
	Local $aResult = 0
	Local Const $dMemBitmap = Binary($dImage) ;load image saved in variable (memory) and convert it to binary
	Local Const $iLen = BinaryLen($dMemBitmap) ;get binary length of the image
	Local Const $GMEM_MOVEABLE = 0x0002
	$aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", $GMEM_MOVEABLE, "ulong_ptr", $iLen) ;allocates movable memory ($GMEM_MOVEABLE = 0x0002)
	If @error Then Return SetError(4, 0, 0)
	Local Const $hData = $aResult[0]
	$aResult = DllCall("kernel32.dll", "ptr", "GlobalLock", "handle", $hData)
	If @error Then Return SetError(5, 0, 0)
	Local $tMem = DllStructCreate("byte[" & $iLen & "]", $aResult[0]) ;create struct
	DllStructSetData($tMem, 1, $dMemBitmap) ;fill struct with image data
	DllCall("kernel32.dll", "bool", "GlobalUnlock", "handle", $hData) ;decrements the lock count associated with a memory object that was allocated with GMEM_MOVEABLE
	If @error Then Return SetError(6, 0, 0)
	Local Const $hStream = _WinAPI_CreateStreamOnHGlobal($hData) ;creates a stream object that uses an HGLOBAL memory handle to store the stream contents
	If @error Then Return SetError(2, 0, 0)
	Local Const $hBitmap = _GDIPlus_BitmapCreateFromStream($hStream) ;creates a Bitmap object based on an IStream COM interface
	If @error Then Return SetError(3, 0, 0)
	DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $hStream, "ulong_ptr", 8 * (1 + @AutoItX64), "uint", 4, "ushort", 23, "uint", 0, "ptr", 0, "ptr", 0, "str", "") ;release memory from $hStream to avoid memory leak
	If $bHBITMAP Then
		Local Const $hHBmp = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap) ;supports GDI transparent color format
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBmp
	EndIf
	Return $hBitmap
EndFunc   ;==>_GDIPlus_BitmapCreateFromMemory

Func AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $iRetryCount = 0)
   Local $startTimer = TimerInit()
   Local $hostPath = $AndroidPicturesHostPath & $AndroidPicturesHostFolder
   Local $androidPath = $AndroidPicturesPath & StringReplace($AndroidPicturesHostFolder, "\", "/")

   If $HwND <> WinGetHandle($HwND) Then Return SetError(4, 0) ; Window gone
   Local $wasRunState = $RunState
   AndroidAdbLaunchShellInstance($wasRunState)
   If @error <> 0 Then Return SetError(2, 0)

   Local $filename = $sBotTitle & ".rgba"
   If $AndroidAdbScreencapPngEnabled = True Then $filename = $sBotTitle & ".png"
   Local $s

   ; Create 32 bits-per-pixel device-independent bitmap (DIB)
   Local $tBIV5HDR = 0
   If $AndroidAdbScreencapPngEnabled = False Then
	  $tBIV5HDR = DllStructCreate($tagBITMAPV5HEADER)
	  DllStructSetData($tBIV5HDR, 'bV5Size', DllStructGetSize($tBIV5HDR))
	  DllStructSetData($tBIV5HDR, 'bV5Width', $iWidth)
	  DllStructSetData($tBIV5HDR, 'bV5Height', -$iHeight)
	  DllStructSetData($tBIV5HDR, 'bV5Planes', 1)
	  DllStructSetData($tBIV5HDR, 'bV5BitCount', 32)
	  DllStructSetData($tBIV5HDR, 'biCompression', $BI_RGB)
   EndIf
   Local $pBits = 0
   Local $hHBitmap = 0

   If $AndroidAdbScreencapTimer <> 0 And $ForceCapture = False And TimerDiff($AndroidAdbScreencapTimer) < $AndroidAdbScreencapTimeout And $RunState = True And $iRetryCount = 0 Then
	  If $AndroidAdbScreencapPngEnabled = False Then
		 $hHBitmap = _WinAPI_CreateDIBSection(0, $tBIV5HDR, $DIB_RGB_COLORS, $pBits)
		 $tBIV5HDR = 0 ; Release the resources used by the structure
		 DLLCall($LibDir & "\helper_functions.dll", "none:cdecl", "RGBA2BGRA", "ptr", DllStructGetPtr($AndroidAdbScreencapBuffer), "ptr", $pBits, "int", $iLeft, "int", $iTop, "int", $iWidth, "int", $iHeight, "int", $AndroidAdbScreencapWidth, "int", $AndroidAdbScreencapHeight)
		 Return $hHBitmap
	  ElseIf $AndroidAdbScreencapBufferPngHandle <> 0 Then
		 If $iWidth > $AndroidAdbScreencapWidth - $iLeft Then $iWidth = $AndroidAdbScreencapWidth - $iLeft
		 If $iHeight > $AndroidAdbScreencapHeight - $iTop Then $iHeight = $AndroidAdbScreencapHeight - $iTop
		 Local $hClone = _GDIPlus_BitmapCloneArea($AndroidAdbScreencapBufferPngHandle, $iLeft, $iTop, $iWidth, $iHeight, $GDIP_PXF32ARGB)
		 Return _GDIPlus_BitmapCreateDIBFromBitmap($hClone)
	  EndIf
   EndIf

   FileDelete($hostPath & $filename)
   $s = AndroidAdbSendShellCommand("screencap """ & $androidPath & $filename & """", $AndroidAdbScreencapWaitAdbTimeout, $wasRunState)
   ;$s = AndroidAdbSendShellCommand("screencap """ & $androidPath & $filename & """", -1, $wasRunState)
   If $__TEST_ERROR_SLOW_ADB_SCREENCAP_DELAY > 0 Then Sleep($__TEST_ERROR_SLOW_ADB_SCREENCAP_DELAY)
   Local $shellLogInfo = @extended

   Local $hTimer = TimerInit()
   Local $hFile = 0
   Local $iSize = 0
   Local $iLoopCountFile = 0
   Local $AdbStatsType = 0 ; screencap stats
   Local $iF = 0
   Local $ExpectedFileSize = 1500 ; all blank png is approx 1.5 KByte
   Local $iReadData = 0

   If $AndroidAdbScreencapPngEnabled = False Then
	  ; default raw RGBA mode

	  ; Android screencap see:
	  ; https://android.googlesource.com/platform/frameworks/base/+/jb-release/cmds/screencap/screencap.cpp
	  ; http://androidsource.top/code/source/system/core/include/system/graphics.h
	  ; http://androidsource.top/code/source/frameworks/base/include/ui/PixelFormat.h
	  Local $tHeader = DllStructCreate("int w;int h;int f")
	  Local $iHeaderSize = DllStructGetSize($tHeader)
	  Local $iDataSize = DllStructGetSize($AndroidAdbScreencapBuffer)

	  ; wait for file (required for Droid4X)
	  $ExpectedFileSize = $AndroidClientWidth * $AndroidClientHeight * 4 + $iHeaderSize
	  #cs
	  While TimerDiff($hTimer) < $AndroidAdbScreencapWaitFileTimeout And FileGetSize($hostPath & $filename) < $ExpectedFileSize ; wait max. 5 seconds
		 Sleep(10)
		 If $wasRunState = True And $RunState = False Then Return SetError(1, 0)
		 $iLoopCountFile += 1
	  WEnd
	  #ce

	  While $iSize < $ExpectedFileSize And TimerDiff($hTimer) < $AndroidAdbScreencapWaitFileTimeout
		 If $hFile = 0 Then $hFile = _WinAPI_CreateFile($hostPath & $filename, 2, 2)
		 If $hFile <> 0 Then $iSize = _WinAPI_GetFileSizeEx($hFile)
		 If $iSize >= $ExpectedFileSize Then ExitLoop
		 Sleep(10)
		 If $wasRunState = True And $RunState = False Then Return SetError(1, 0)
		 $iLoopCountFile += 1
	  WEnd

	  Local $iReadHeader = 0
	  $AndroidAdbScreencapWidth = 0
	  $AndroidAdbScreencapHeight = 0

	  If $hFile <> 0 Then
		 If $iSize >= $ExpectedFileSize Then
			$hTimer = TimerInit()
			While $iReadHeader < $iHeaderSize And TimerDiff($hTimer) < $AndroidAdbScreencapWaitFileTimeout
			   If _WinAPI_ReadFile($hFile, $tHeader, $iHeaderSize, $iReadHeader) = True And $iReadHeader = $iHeaderSize Then
				  ExitLoop
			   Else
				  SetDebugLog("Error " & _WinAPI_GetLastError() & ", read " & $iReadHeader & " header bytes, file: " & $hostPath & $filename, $COLOR_RED)
				  If $iReadHeader > 0 Then _WinAPI_SetFilePointer($hFile, 0)
				  Sleep(10)
			   EndIf
			WEnd
			$AndroidAdbScreencapWidth = DllStructGetData($tHeader, "w")
			$AndroidAdbScreencapHeight = DllStructGetData($tHeader, "h")
			$iF = DllStructGetData($tHeader, "f")
			$hTimer = TimerInit()
			If $iSize - $iHeaderSize < $iDataSize Then $iDataSize = $iSize - $iHeaderSize
			While $iReadData < $iDataSize And TimerDiff($hTimer) < $AndroidAdbScreencapWaitFileTimeout
			   If _WinAPI_ReadFile($hFile, $AndroidAdbScreencapBuffer, $iDataSize, $iReadData) = True And $iReadData = $iDataSize Then
				  ExitLoop
			   Else
				  SetDebugLog("Error " & _WinAPI_GetLastError() & ", read " & $iReadData & " data bytes, file: " & $hostPath & $filename, $COLOR_RED)
				  If $iReadData > 0 Then _WinAPI_SetFilePointer($hFile, $iHeaderSize)
				  Sleep(10)
			   EndIf
			WEnd

			_WinAPI_CloseHandle($hFile)
			$hHBitmap = _WinAPI_CreateDIBSection(0, $tBIV5HDR, $DIB_RGB_COLORS, $pBits)
			DLLCall($LibDir & "\helper_functions.dll", "none:cdecl", "RGBA2BGRA", "ptr", DllStructGetPtr($AndroidAdbScreencapBuffer), "ptr", $pBits, "int", $iLeft, "int", $iTop, "int", $iWidth, "int", $iHeight, "int", $AndroidAdbScreencapWidth, "int", $AndroidAdbScreencapHeight)
		 Else
			SetDebugLog("File too small (" & $iSize & " < " & $ExpectedFileSize & "): " & $hostPath & $filename, $COLOR_RED)
			_WinAPI_CloseHandle($hFile)
		 EndIf
	  EndIf
	  If $hFile = 0 Or $iSize < $ExpectedFileSize Or $iReadHeader < $iHeaderSize Or $iReadData < $iDataSize Then
		 If $hFile = 0 Then
			SetLog("File not found: " & $hostPath & $filename, $COLOR_RED)
		 Else
			If $iSize <> $ExpectedFileSize Then SetDebugLog("File size " & $iSize & " is not " & $ExpectedFileSize & " for " & $hostPath & $filename, $COLOR_RED)
			SetDebugLog("Captured screen size " & $AndroidAdbScreencapWidth & " x " & $AndroidAdbScreencapHeight, $COLOR_RED)
			SetDebugLog("Captured screen bytes read (header/datata): " & $iReadHeader & " / " & $iReadData, $COLOR_RED)
		 EndIf
		 If $iRetryCount < 10 Then
			SetDebugLog("ADB retry screencap in 1000 ms. (restarting ADB session)", $COLOR_ORANGE)
			_Sleep(1000)
			AndroidAdbTerminateShellInstance()
			AndroidAdbLaunchShellInstance($wasRunState)
			Return AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $iRetryCount + 1)
		 EndIf
		 SetLog($Android & " screen not captured using ADB", $COLOR_RED)
		 If $AndroidAdbStatsTotal[$AdbStatsType][0] < 50 Then
			SetLog($Android & " ADB screen capture disabled", $COLOR_RED)
			If BitAND($AndroidSupportFeature, 1) = 0 Then $ichkBackground = 0 ; disable also background mode the hard way
			$AndroidAdbScreencap = False
		 Else
			; reboot Android
			SetLog("Rebooting " & $Android & " due to problems capturing screen", $COLOR_RED)
			Local $_NoFocusTampering = $NoFocusTampering
			$NoFocusTampering = True
			RebootAndroid()
			$NoFocusTampering = $_NoFocusTampering
		 EndIf
		 Return SetError(3, 0)
	  EndIf

   Else

	  ; slower compatible PNG mode for BlueStacks
	  If $AndroidAdbScreencapBufferPngHandle <> 0 Then
		 _GDIPlus_ImageDispose($AndroidAdbScreencapBufferPngHandle)
		 _GDIPlus_BitmapDispose($AndroidAdbScreencapBufferPngHandle) ; dispose old cache
		 _WinAPI_DeleteObject($AndroidAdbScreencapBufferPngHandle)
		 $AndroidAdbScreencapBufferPngHandle = 0
	  EndIf
	  Local $hBitmap = 0
	  #cs causes open file handles
	  While $hBitmap = 0 And TimerDiff($hTimer) < $AndroidAdbScreencapWaitFileTimeout
		 ;$hBitmap = _GDIPlus_ImageLoadFromFile($hostPath & $filename)
		 $hBitmap = _GDIPlus_BitmapCreateFromFile($hostPath & $filename)
		 If $hBitmap = 0 Then Sleep(10)
	  WEnd
	  #ce

	  While $iSize < $ExpectedFileSize And TimerDiff($hTimer) < $AndroidAdbScreencapWaitFileTimeout
		 If $hFile = 0 Then $hFile = _WinAPI_CreateFile($hostPath & $filename, 2, 2)
		 If $hFile <> 0 Then $iSize = _WinAPI_GetFileSizeEx($hFile)
		 If $iSize >= $ExpectedFileSize Then ExitLoop
		 Sleep(10)
		 If $wasRunState = True And $RunState = False Then Return SetError(1, 0)
		 $iLoopCountFile += 1
	  WEnd


		 Local $hData = _MemGlobalAlloc($iSize, $GMEM_MOVEABLE)
		 Local $pData = _MemGlobalLock($hData)
		 Local $tData = DllStructCreate('byte[' & $iSize & ']', $pData)

	  While $iSize > 0 And $iReadData < $iSize And TimerDiff($hTimer) < $AndroidAdbScreencapWaitFileTimeout
		 If _WinAPI_ReadFile($hFile, $tData, $iSize, $iReadData) = True And $iReadData = $iSize Then
			ExitLoop
		 Else
			SetDebugLog("Error " & _WinAPI_GetLastError() & ", read " & $iReadData & " data bytes, file: " & $hostPath & $filename, $COLOR_RED)
			If $iReadData > 0 Then _WinAPI_SetFilePointer($hFile, 0)
			Sleep(10)
		 EndIf
	  WEnd
	  _WinAPI_CloseHandle($hFile)
	  SetDebugLog($iSize, $COLOR_RED)

Local $testTimer = TimerInit()
Local $msg = ""
		 _MemGlobalUnlock($hData)
		 Local $pStream = _WinAPI_CreateStreamOnHGlobal($hData)

		 $hBitmap = _GDIPlus_BitmapCreateFromStream($pStream)
		 ;Local $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
		 ;Local $iWidth = _GDIPlus_ImageGetWidth($hImage)
		 ;Local $iHeight = _GDIPlus_ImageGetHeight($hImage)
		 _WinAPI_ReleaseStream($pStream)
$msg &= ", " & Round(TimerDiff($testTimer), 2)
		 ;_GDIPlus_ImageDispose($hImage)


	  ;_GDIPlus_BitmapCreateFromMemory
	  If $hBitmap = 0 Then
		 ; problem creating Bitmap
		 If $iRetryCount < 10 Then
			SetDebugLog("ADB retry screencap in 1000 ms. (restarting ADB session)", $COLOR_ORANGE)
			_Sleep(1000)
			AndroidAdbTerminateShellInstance()
			AndroidAdbLaunchShellInstance($wasRunState)
			Return AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $iRetryCount + 1)
		 EndIf
		 SetLog($Android & " screen not captured using ADB", $COLOR_RED)
		 If FileExists($hostPath & $filename) = 0 Then SetLog("File not found: " & $hostPath & $filename, $COLOR_RED)
		 SetLog($Android & " ADB screen capture disabled", $COLOR_RED)
		 $AndroidAdbScreencap = False
		 Return SetError(5, 0)
	  Else
		 $AndroidAdbScreencapWidth = _GDIPlus_ImageGetWidth($hBitmap)
		 $AndroidAdbScreencapHeight = _GDIPlus_ImageGetHeight($hBitmap)
$msg &= ", " & Round(TimerDiff($testTimer), 2)
		 ;$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
		 If $iWidth > $AndroidAdbScreencapWidth - $iLeft Then $iWidth = $AndroidAdbScreencapWidth - $iLeft
		 If $iHeight > $AndroidAdbScreencapHeight - $iTop Then $iHeight = $AndroidAdbScreencapHeight - $iTop
		 Local $hClone = _GDIPlus_BitmapCloneArea($hBitmap, $iLeft, $iTop, $iWidth, $iHeight, $GDIP_PXF32ARGB)
$msg &= ", " & Round(TimerDiff($testTimer), 2)
		 If $hClone = 0 Then
			SetDebugLog($Android & " error using " & $AndroidAdbScreencapWidth & "x" & $AndroidAdbScreencapHeight & " on _GDIPlus_BitmapCloneArea(" & $hBitmap & "," & $iLeft & "," & $iTop & "," & $iWidth & "," & $iHeight, $COLOR_RED)
			SetLog($Android & " screenshot not available", $COLOR_RED)
			SetLog($Android & " ADB screen capture disabled", $COLOR_RED)
			$AndroidAdbScreencap = False
			Return SetError(6, 0)
		 EndIf
		 $AndroidAdbScreencapBufferPngHandle = $hBitmap
		 ;_GDIPlus_ImageDispose($hBitmap)
$msg &= ", " & Round(TimerDiff($testTimer), 2)
		 $hHBitmap = _GDIPlus_BitmapCreateDIBFromBitmap($hClone)
		 ;$hHBitmap = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
	  EndIf
   EndIf

   Local $duration = Int(TimerDiff($startTimer))
   ; dynamically adjust $AndroidAdbScreencapTimeout to 3 x of current duration ($AndroidAdbScreencapTimeoutDynamic)
   $AndroidAdbScreencapTimeout = ($AndroidAdbScreencapTimeoutDynamic = 0 ? $AndroidAdbScreencapTimeoutMax : $duration * $AndroidAdbScreencapTimeoutDynamic)
   If $AndroidAdbScreencapTimeout < $AndroidAdbScreencapTimeoutMin Then $AndroidAdbScreencapTimeout = $AndroidAdbScreencapTimeoutMin
   If $AndroidAdbScreencapTimeout > $AndroidAdbScreencapTimeoutMax Then $AndroidAdbScreencapTimeout = $AndroidAdbScreencapTimeoutMax
   ;SetDebugLog("AndroidScreencap (" & $duration & "ms," & $shellLogInfo & "," & $iLoopCountFile & "): l=" & $iLeft & ",t=" & $iTop & ",w=" & $iWidth & ",h=" & $iHeight & ", " & $filename & ": w=" & $AndroidAdbScreencapWidth & ",h=" & $AndroidAdbScreencapHeight & ",f=" & $iF)

   $AndroidAdbScreencapTimer = TimerInit() ; timeout starts now

   ; update total stats
   $AndroidAdbStatsTotal[$AdbStatsType][0] += 1
   $AndroidAdbStatsTotal[$AdbStatsType][1] += $duration
   Local $iLastCount = UBound($AndroidAdbStatsLast, 2) - 2
   ; Last 10 screencap durations, 0 is sum of durations, 1 is 0-based index to oldest, 2-11 last 10 durations
   If $AndroidAdbStatsTotal[$AdbStatsType][0] <= $iLastCount Then
	  $AndroidAdbStatsLast[$AdbStatsType][0] += $duration
	  $AndroidAdbStatsLast[$AdbStatsType][$AndroidAdbStatsTotal[$AdbStatsType][0] + 1] = $duration
	  If $AndroidAdbStatsTotal[$AdbStatsType][0] = $iLastCount Then $AndroidAdbStatsLast[$AdbStatsType][1] = 0 ; init last index
   Else
	  Local $iLastIdx = $AndroidAdbStatsLast[$AdbStatsType][1] + 2
	  $AndroidAdbStatsLast[$AdbStatsType][0] -= $AndroidAdbStatsLast[$AdbStatsType][$iLastIdx] ; remove last duration
	  $AndroidAdbStatsLast[$AdbStatsType][0] += $duration ; add current duration
	  $AndroidAdbStatsLast[$AdbStatsType][$iLastIdx] = $duration ; update current duration
	  $AndroidAdbStatsLast[$AdbStatsType][1] = Mod($AndroidAdbStatsLast[$AdbStatsType][1] + 1, $iLastCount) ; update oldest index
   EndIf
   If $AndroidAdbStatsLast[$AdbStatsType][1] = 0 Then
	  Local $totalAvg = Round($AndroidAdbStatsTotal[$AdbStatsType][1] / $AndroidAdbStatsTotal[$AdbStatsType][0])
	  Local $lastAvg = Round($AndroidAdbStatsLast[$AdbStatsType][0] / $iLastCount)
	  If $debugSetlog = 1 Or Mod($AndroidAdbStatsTotal[$AdbStatsType][0], 100) = 0 Then
		 SetDebugLog("AdbScreencap: " & $totalAvg & "/" & $lastAvg & "/" & $duration & " ms (all/" & $iLastCount & "/1)," & $shellLogInfo & "," & $iLoopCountFile & ",l=" & $iLeft & ",t=" & $iTop & ",w=" & $iWidth & ",h=" & $iHeight & ", " & $filename & ": w=" & $AndroidAdbScreencapWidth & ",h=" & $AndroidAdbScreencapHeight & ",f=" & $iF)
	  EndIf
   EndIf
   $ScreenshotTime = $duration ; set current screenshot duration
   $tBIV5HDR = 0 ; Release the resources used by the structure
   Return $hHBitmap
EndFunc

Func AndroidZoomOut($loopCount = 0, $timeout = Default, $wasRunState = $RunState)
   ResumeAndroid()
   If $AndroidAdbZoomoutEnabled = False Then Return SetError(4, 0)
   If $HwND <> WinGetHandle($HwND) Then Return SetError(3, 0) ; Window gone
   AndroidAdbLaunchShellInstance($wasRunState)
   If @error <> 0 Then Return SetError(2, 0)

   If StringInStr($AndroidMouseDevice, "/dev/input/event") = 0 Then Return SetError(2, 0, 0)

   Local $scriptFile = ""
   If $scriptFile = "" And FileExists($AdbScriptsDir & "\ZoomOut." & $Android & ".getevent") = 1 Then $scriptFile = "ZoomOut." & $Android & ".getevent"
   If $scriptFile = "" Then $scriptFile = "ZoomOut.getevent"
   If FileExists($AdbScriptsDir & "\" & $scriptFile) = 0 Then SetError(1, 0, 0)
   AndroidAdbSendShellCommandScript($scriptFile, True, $timeout, $wasRunState)
   Return SetError(@error, @extended, (@error = 0 ? 1 : -@error))
EndFunc

; Returns True if KeepClicks is active or for $Really = False KeepClicks() was called even though not enabled (poor mans deploy troops detection)
Func IsKeepClicksActive($Really = True)
   If $Really = True Then
	  Return $AndroidAdbClick = True And $AndroidAdbClicks = True And $AndroidAdbClicks[0] > -1
   EndIf
   Return $AndroidAdbKeepClicksActive
EndFunc

Func KeepClicks()
   $AndroidAdbKeepClicksActive = True
   If $AndroidAdbClick = False Or $AndroidAdbClicksEnabled = False Then Return False
   If $AndroidAdbClicks[0] = -1 Then $AndroidAdbClicks[0] = 0
EndFunc

Func ReleaseClicks($minClicksToRelease = 0)
   If $AndroidAdbClick = False Or $AndroidAdbClicksEnabled = False Then
	  $AndroidAdbKeepClicksActive = False
	  Return False
   EndIf
   If $AndroidAdbClicks[0] > 0 And $RunState = True Then
	  If $AndroidAdbClicks[0] >= $minClicksToRelease Then
		 AndroidClick(-1, -1, $AndroidAdbClicks[0], 0)
	  Else
		 Return False
	  EndIf
   EndIf
   $AndroidAdbKeepClicksActive = False
   ReDim $AndroidAdbClicks[1]
   $AndroidAdbClicks[0] = -1
EndFunc

Func AndroidClick($x, $y, $times = 1, $speed = 0, $checkProblemAffect = True)
   ;AndroidSlowClick($x, $y, $times, $speed)
   AndroidFastClick($x, $y, $times, $speed, $checkProblemAffect)
EndFunc

Func AndroidSlowClick($x, $y, $times = 1, $speed = 0)
   $x = Int($x)
   $y = Int($y)
   Local $wasRunState = $RunState
   Local $cmd = ""
   Local $i = 0
   $AndroidAdbScreencapTimer = 0 ; invalidate ADB screencap timer/timeout
   AndroidAdbLaunchShellInstance($wasRunState)
   If @error = 0 Then
	  For $i = 1 To $times
		 $cmd &= "input tap " & $x & " " & $y & ";"
	  Next
	  Local $timer = TimerInit()
	  AndroidAdbSendShellCommand($cmd, Default, $wasRunState)
	  Local $wait = $speed - TimerDiff($timer)
	  If $wait > 0 Then _Sleep($wait, False)
   Else
	  Local $error = @error
	  SetDebugLog("Disabled " & $Android & " ADB mouse click, error " & $error, $COLOR_RED)
	  $AndroidAdbClick = False
	  Return SetError($error, 0)
   EndIf
EndFunc

Func AndroidMoveMouseAnywhere()
   Local $_SilentSetLog = $SilentSetLog
   Local $hostPath = $AndroidPicturesHostPath & $AndroidPicturesHostFolder
   Local $androidPath = $AndroidPicturesPath & StringReplace($AndroidPicturesHostFolder, "\", "/")
   Local $filename = $sBotTitle & ".moveaway"
   Local $recordsNum = 4
   Local $iToWrite = $recordsNum * 16
   Local $records = ""

   If FileExists($hostPath & $filename) = 0 Then
	  Local $times = 1
	  Local $x = 1 ; $aAway[0]
	  Local $y = 40 ; $aAway[1]
	  Execute($Android & "AdjustClickCoordinates($x,$y)")
	  Local $i = 0
	  Local $record = "byte[16];"
	  For $i = 1 To $recordsNum * $times
		 $records &= $record
	  Next

	  Local $data = DllStructCreate($records)
	  $i = 0
	  DllStructSetData($data, 1 + $i * $recordsNum, Binary("0x000000000000000003003500" & StringRight(Hex($x, 4),2) & StringLeft(Hex($x, 4),2) & "0000")) ; ABS_MT_POSITION_X
	  DllStructSetData($data, 2 + $i * $recordsNum, Binary("0x000000000000000003003600" & StringRight(Hex($y, 4),2) & StringLeft(Hex($y, 4),2) & "0000")) ; ABS_MT_POSITION_Y
	  DllStructSetData($data, 3 + $i * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
	  DllStructSetData($data, 4 + $i * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
	  Local $data2 = DllStructCreate("byte[" & DllStructGetSize($data) & "]", DllStructGetPtr($data))

	  Local $iWritten = 0
	  Local $sleep = ""
	  Local $hFileOpen = _WinAPI_CreateFile($hostPath & $filename, 1, 4)
	  If $hFileOpen = 0 Then
		 Local $error = _WinAPI_GetLastError()
		 Return SetError($error, 0)
	  EndIf
	  _WinAPI_WriteFile($hFileOpen, DllStructGetPtr($data2), $iToWrite, $iWritten)
	  _WinAPI_CloseHandle($hFileOpen)
   EndIf

   $SilentSetLog = True
   AndroidAdbSendShellCommand("dd if=""" & $androidPath & $sBotTitle & ".moveaway"" of=" & $AndroidMouseDevice & " obs=" & $iToWrite & ">/dev/null 2>&1" & $sleep, Default)
   $SilentSetLog = $_SilentSetLog

EndFunc

Func AndroidFastClick($x, $y, $times = 1, $speed = 0, $checkProblemAffect = True, $iRetryCount = 0)
   Local $_SilentSetLog = $SilentSetLog
   Local $hDuration = TimerInit()
   If $times < 1 Then Return SetError(0, 0)
   Local $i = 0, $j = 0
   Local $ReleaseClicks = ($x = -1 And $y = -1 And $AndroidAdbClicks[0] > 0)
   If $ReleaseClicks = False And $AndroidAdbClicks[0] > -1 Then
	  Local $pos = $AndroidAdbClicks[0]
	  $AndroidAdbClicks[0] = $pos + $times
	  ReDim $AndroidAdbClicks[$AndroidAdbClicks[0] + 1]
	  For $i = 1 To $times
		 Local $Click = [$x, $y]
		 $AndroidAdbClicks[$pos + $i] = $Click
	  Next
	  If $debugSetlog = 1 Or $debugClick = 1 Then
		 $SilentSetLog = True
		 SetDebugLog("Hold back click (" & $x & "/" & $y & " * " & $times & "): queue size = " & $AndroidAdbClicks[0], $COLOR_RED)
		 $SilentSetLog = $_SilentSetLog
	  EndIf
	  Return
   EndIf

   $x = Int($x)
   $y = Int($y)
   Local $wasRunState = $RunState
   Local $hostPath = $AndroidPicturesHostPath & $AndroidPicturesHostFolder
   Local $androidPath = $AndroidPicturesPath & StringReplace($AndroidPicturesHostFolder, "\", "/")
   AndroidAdbLaunchShellInstance($wasRunState)
   #cs
   If @error <> 0 Then
	  Local $error = @error
	  ;SetDebugLog("Disabled " & $Android & " ADB fast mouse click, error " & $error & " (AndroidAdbLaunchShellInstance)" , $COLOR_RED)
	  ;$AndroidAdbClick = False
	  $SilentSetLog = True
	  SetDebugLog("Cannot use ADB fast mouse click, error " & $error & " (#Err0001)" , $COLOR_RED)
	  $SilentSetLog = $_SilentSetLog
	  Return SetError($error, 0)
   EndIf
   #ce
   Local $filename = $sBotTitle & ".click"
   Local $record = "byte[16];"
   Local $records = ""
   Local $loops = 1
   Local $remaining = 0
   Local $adjustSpeed = 0
   Local $timer = TimerInit()
   If $times > $AndroidAdbClickGroup Then
	  $speed = $AndroidAdbClickGroupDelay
	  $remaining = Mod($times, $AndroidAdbClickGroup)
	  $loops = Int($times / $AndroidAdbClickGroup) + ($remaining > 0 ? 1 : 0)
	  $times = $AndroidAdbClickGroup
   Else
	  If $ReleaseClicks = False Then $adjustSpeed = $speed
	  $speed = 0 ; no need for speed now!
   EndIf
   Local $recordsNum = 8
   Local $recordsClicks = ($times < $AndroidAdbClickGroup ? $times : $AndroidAdbClickGroup)
   For $i = 1 To $recordsNum * $recordsClicks
	  $records &= $record
   Next

   If $ReleaseClicks = True Then
	  If $debugSetlog = 1 Or $debugClick = 1 Then SetDebugLog("Release clicks: queue size = " & $AndroidAdbClicks[0])
   Else
	  Execute($Android & "AdjustClickCoordinates($x,$y)")
   EndIf

   ;SetDebugLog("AndroidFastClick(" & $x & "," & $y & "):" & $s)
   Local $data = DllStructCreate($records)
   For $i = 0 To $recordsClicks - 1
	  DllStructSetData($data, 1 + $i * $recordsNum, Binary("0x000000000000000001004a0101000000")) ; BTN_TOUCH DOWN
	  ;DllStructSetData($data, 2 + $i * $recordsNum, Binary("0x000000000000000003003500" & StringRight(Hex($x, 4),2) & StringLeft(Hex($x, 4),2) & "0000")) ; ABS_MT_POSITION_X
	  ;DllStructSetData($data, 3 + $i * $recordsNum, Binary("0x000000000000000003003600" & StringRight(Hex($y, 4),2) & StringLeft(Hex($y, 4),2) & "0000")) ; ABS_MT_POSITION_Y
	  DllStructSetData($data, 4 + $i * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
	  DllStructSetData($data, 5 + $i * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
	  DllStructSetData($data, 6 + $i * $recordsNum, Binary("0x000000000000000001004a0100000000")) ; BTN_TOUCH UP
	  DllStructSetData($data, 7 + $i * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
	  DllStructSetData($data, 8 + $i * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
	  ;DllStructSetData($data, 4 + $i * $recordsNum, Binary("0x000000000000000003003a0001000000")) ; ABS_MT_PRESSURE
	  ;DllStructSetData($data, 8 + $i * $recordsNum, Binary("0x000000000000000003003a0000000000")) ; ABS_MT_PRESSURE
   Next
   ;SetDebugLog("AndroidFastClick: $times=" & $times & ", $loops=" & $loops & ", $remaining=" & $remaining)
   Local $AdbStatsType = 1 ; click stats
   Local $data2 = DllStructCreate("byte[" & DllStructGetSize($data) & "]", DllStructGetPtr($data))
   Local $hFileOpen = 0
   Local $iToWrite = DllStructGetSize($data2)
   Local $iWritten = 0
   Local $sleep = ""
   If $speed > 0 Then
	  $sleep = "/system/xbin/sleep " & ($speed / 1000) ; use busy box sleep as it supports milliseconds (if available!)
   EndIf
   For $i = 1 to $loops
	  If IsKeepClicksActive(False) = False Then
		 If $checkProblemAffect = True Then
			If isProblemAffect(True) Then
			   SetDebugLog("VOIDED Click " & $x & "," & $y & "," & $times & "," & $speed, $COLOR_RED, "Verdana", "7.5", 0)
			   checkMainScreen(False)
			   Return ; if need to clear screen do not click
			EndIf
		 EndIf
	  EndIf
	  If $i = $loops And $remaining > 0 Then ; last block with less clicks, create new file
		 $iToWrite = (16 * $recordsNum) * $remaining
		 $recordsClicks = $remaining
		 $hFileOpen = 0
	  ElseIf $ReleaseClicks = True Then
		 $hFileOpen = 0
	  EndIf
	  If $hFileOpen = 0 Then
		 ;$hFileOpen = FileOpen($hostPath & $filename, $FO_BINARY  + $FO_OVERWRITE)
		 ;FileWrite($hFileOpen, DllStructGetData($data2,1))
		 ;FileClose($hFileOpen)
		 Local $timer = TimerInit()
		 While $hFileOpen = 0 And TimerDiff($timer) < 3000
			$hFileOpen = _WinAPI_CreateFile($hostPath & $filename, 1, 4)
			If $hFileOpen <> 0 Then ExitLoop
			SetDebugLog("Error " & _WinAPI_GetLastError() & " (" & Round(TimerDiff($timer)) & "ms) creating " & $hostPath & $filename, $COLOR_RED)
			Sleep(10)
		 WEnd
		 If $hFileOpen = 0 Then
			Local $error = _WinAPI_GetLastError()
			SetLog("Error creating " & $hostPath & $filename, $COLOR_RED)
			SetError($error)
			ExitLoop
			#cs
			SetLog("Disabled " & $Android & " ADB fast mouse click due to error " & $error & " (#Err0002)", $COLOR_RED)
			$AndroidAdbClick = False
			_WinAPI_CloseHandle($hFileOpen)
			Return SetError($error, 0)
			#ce
		 EndIf
		 ;SetDebugLog("AndroidFastClick: $times=" & $times & ", $loops=" & $loops & ", $remaining=" & $remaining)
		 For $j = 0 To $recordsClicks - 1
			If $ReleaseClicks = True Then
			   $Click = $AndroidAdbClicks[($i - 1) * $recordsNum + $j + 1]
			   $x = $Click[0]
			   $y = $Click[1]
			   Execute($Android & "AdjustClickCoordinates($x,$y)")
			EndIf
			DllStructSetData($data, 2 + $j * $recordsNum, Binary("0x000000000000000003003500" & StringRight(Hex($x, 4),2) & StringLeft(Hex($x, 4),2) & "0000")) ; ABS_MT_POSITION_X
			DllStructSetData($data, 3 + $j * $recordsNum, Binary("0x000000000000000003003600" & StringRight(Hex($y, 4),2) & StringLeft(Hex($y, 4),2) & "0000")) ; ABS_MT_POSITION_Y
		 Next
		 _WinAPI_WriteFile($hFileOpen, DllStructGetPtr($data2), $iToWrite, $iWritten)
		 If $hFileOpen = 0 Then
			Local $error = _WinAPI_GetLastError()
			SetLog("Error writing " & $hostPath & $filename, $COLOR_RED)
			SetError($error)
			ExitLoop
			#cs
			SetLog("Disabled " & $Android & " ADB fast mouse click due to error " & $error & " (#Err0003)", $COLOR_RED)
			$AndroidAdbClick = False
			Return SetError($error, 0)
			#ce
		 EndIf
		 _WinAPI_CloseHandle($hFileOpen)
	  EndIf
	  If $loops > 1 Then
		 AndroidMoveMouseAnywhere()
	  EndIf
	  $SilentSetLog = True
	  AndroidAdbSendShellCommand("dd if=""" & $androidPath & $filename & """ of=" & $AndroidMouseDevice & " obs=" & $iToWrite & ">/dev/null 2>&1", Default)
	  $SilentSetLog = $_SilentSetLog
	  If $speed > 0 Then
		 ; speed was overwritten with $AndroidAdbClickGroupDelay
		 Local $sleepTimer = TimerInit()
		 AndroidAdbSendShellCommand($sleep)
		 Local $sleepTime = $speed - TimerDiff($sleepTimer)
		 If $sleepTime > 0 Then _Sleep($sleepTime, False)
	  EndIf
	  If $adjustSpeed > 0 Then
		 ; wait remaining time
		 Local $wait = Round($adjustSpeed - TimerDiff($timer))
		 If $wait > 0 Then
			If $debugSetlog = 1 Or $debugClick = 1 Then
			   $SilentSetLog = True
			   SetDebugLog("AndroidFastClick: Sleep " & $wait & " ms.")
			   $SilentSetLog = $_SilentSetLog
			EndIf
			_Sleep($wait, False)
		 EndIf
	  EndIf
	  If $RunState = False Then ExitLoop
	  If $__TEST_ERROR_SLOW_ADB_CLICK_DELAY > 0 Then Sleep($__TEST_ERROR_SLOW_ADB_CLICK_DELAY)
	  ;If $speed > 0 Then Sleep($speed)
   Next
   If @error <> 0 Then
	  Local $error = @error
	  If $iRetryCount < 10 Then
		 SetError(0, 0, 0)
		 SetDebugLog("ADB retry sending mouse click in 1000 ms. (restarting ADB session)", $COLOR_ORANGE)
		 _Sleep(1000)
		 AndroidAdbTerminateShellInstance()
		 AndroidAdbLaunchShellInstance($wasRunState)
		 Return AndroidFastClick($x, $y, $times, $speed, $checkProblemAffect, $iRetryCount + 1)
	  EndIF
	  If $AndroidAdbStatsTotal[$AdbStatsType][0] < 10 Then
		 SetLog("Disabled " & $Android & " ADB fast mouse click due to error " & $error & " (#Err0004)", $COLOR_RED)
		 $AndroidAdbClick = False
	  Else
		 ; reboot Android
		 SetLog("Rebooting " & $Android & " due to problems sending mouse click", $COLOR_RED)
		 Local $_NoFocusTampering = $NoFocusTampering
		 $NoFocusTampering = True
		 RebootAndroid()
		 $NoFocusTampering = $_NoFocusTampering
	  EndIf
	  Return SetError($error, 0)
   EndIf
   If IsKeepClicksActive(False) = False Then ; Invalidate ADB screencap (not when troops are deployed to speed up clicks)
	  $AndroidAdbScreencapTimer = 0 ; invalidate ADB screencap timer/timeout
   EndIf

   ; update total stats
   Local $duration = Round(TimerDiff($hDuration))
   $AndroidAdbStatsTotal[$AdbStatsType][0] += 1
   $AndroidAdbStatsTotal[$AdbStatsType][1] += $duration
   Local $iLastCount = UBound($AndroidAdbStatsLast, 2) - 2
   ; Last 10 screencap durations, 0 is sum of durations, 1 is 0-based index to oldest, 2-11 last 10 durations
   If $AndroidAdbStatsTotal[$AdbStatsType][0] <= $iLastCount Then
	  $AndroidAdbStatsLast[$AdbStatsType][0] += $duration
	  $AndroidAdbStatsLast[$AdbStatsType][$AndroidAdbStatsTotal[$AdbStatsType][0] + 1] = $duration
	  If $AndroidAdbStatsTotal[$AdbStatsType][0] = $iLastCount Then $AndroidAdbStatsLast[$AdbStatsType][1] = 0 ; init last index
   Else
	  Local $iLastIdx = $AndroidAdbStatsLast[$AdbStatsType][1] + 2
	  $AndroidAdbStatsLast[$AdbStatsType][0] -= $AndroidAdbStatsLast[$AdbStatsType][$iLastIdx] ; remove last duration
	  $AndroidAdbStatsLast[$AdbStatsType][0] += $duration ; add current duration
	  $AndroidAdbStatsLast[$AdbStatsType][$iLastIdx] = $duration ; update current duration
	  $AndroidAdbStatsLast[$AdbStatsType][1] = Mod($AndroidAdbStatsLast[$AdbStatsType][1] + 1, $iLastCount) ; update oldest index
   EndIf
   If $AndroidAdbStatsLast[$AdbStatsType][1] = 0 Then
	  Local $totalAvg = Round($AndroidAdbStatsTotal[$AdbStatsType][1] / $AndroidAdbStatsTotal[$AdbStatsType][0])
	  Local $lastAvg = Round($AndroidAdbStatsLast[$AdbStatsType][0] / $iLastCount)
	  If $debugSetlog = 1 Or $debugClick = 1 Or Mod($AndroidAdbStatsTotal[$AdbStatsType][0], 100) = 0 Then
		 SetDebugLog("AndroidFastClick: " & $totalAvg & "/" & $lastAvg & "/" & $duration & " ms (all/" & $iLastCount & "/1), $x=" & $x & ", $y=" & $y & ", $times=" & $times & ", $speed = " & $speed & ", $checkProblemAffect=" & $checkProblemAffect)
	  EndIf
   EndIf
EndFunc

Func AndroidSendText($sText, $wasRunState = $RunState)
   AndroidAdbLaunchShellInstance($wasRunState)
   Local $error = @error
   If $error = 0 Then
	  ; replace space with %s and remove/replace umlaut and non-english characters
	  ; still ? and * will be treated as file wildcards... might need to be replaced as well
	  Local $newText = StringReplace($sText, " ", "%s")
	  $newText = StringRegExpReplace($newText, "[^A-Za-z0-9\.,\?""!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]`~]", ".")
	  If @extended  <> 0 Then
		 SetDebugLog("Cannot use ADB to send input text, use Windows method", $COLOR_RED)
		 Return SetError(10, 0)
	  EndIF
	  AndroidAdbSendShellCommand("input text """ & $newText & """", Default, $wasRunState)
	  SetError(0, 0)
   Else
	  SetDebugLog("Disabled " & $Android & " ADB input due to error", $COLOR_RED)
	  $AndroidAdbInput = False
	  Return SetError($error, 0)
   EndIf
EndFunc

Func AndroidSwipe($x1, $y1, $x2, $y2, $wasRunState = $RunState)
   AndroidAdbLaunchShellInstance($wasRunState)
   If @error = 0 Then
	  AndroidAdbSendShellCommand("input swipe " & $x1 & " " & $y1 & " " & $x2 & " " & $y2, Default, $wasRunState)
	  SetError(0, 0)
   Else
	  Local $error = @error
	  SetDebugLog("Disabled " & $Android & " ADB input due to error", $COLOR_RED)
	  $AndroidAdbInput = False
	  Return SetError($error, 0)
   EndIf
EndFunc

Func SuspendAndroid($SuspendMode = True, $bDebugLog = True)
   If $AndroidSuspendedEnabled = False Then Return False
   If $SuspendMode = False Then Return ResumeAndroid($bDebugLog)
   If $AndroidSuspended = True Then Return True
   Local $pid = GetAndroidSvcPid()
   If $pid = -1 Or $pid = 0 Then $pid = WinGetProcess($HWnD)
   If $pid = -1 Or $pid = 0 Then Return False
   $AndroidSuspended = True
   _ProcessSuspendResume($pid, True) ; suspend Android
   $AndroidSuspendedTimer = TimerInit()
   If $bDebugLog = True Then SetDebugLog("Android Suspended")
   Return False
EndFunc

Func ResumeAndroid($bDebugLog = True)
   If $AndroidSuspendedEnabled = False Then Return False
   If $AndroidSuspended = False Then Return False
   Local $pid = GetAndroidSvcPid()
   If $pid = -1 Or $pid = 0 Then $pid = WinGetProcess($HWnD)
   If $pid = -1 Or $pid = 0 Then Return False
   $AndroidSuspended = False
   _ProcessSuspendResume($pid, False) ; resume Android
   $AndroidTimeLag[3] += TimerDiff($AndroidSuspendedTimer) ; calculate total suspended time
   If $bDebugLog = True Then SetDebugLog("Android Resumed (total time " & Round($AndroidTimeLag[3]) & " ms)")
   Return True
EndFunc

Func AndroidCloseSystemBar()
   Local $wasRunState = $RunState
   AndroidAdbLaunchShellInstance($wasRunState)
   If @error <> 0 Then
	  SetLog("Cannot close " & $Android & " System Bar", $COLOR_RED)
	  Return False
   EndIf
   Local $cmdOutput = AndroidAdbSendShellCommand("service call activity 42 s16 com.android.systemui", Default, $wasRunState)
   Local $Result = StringLeft($cmdOutput, 6) = "Result"
   Return $Result
EndFunc

Func AndroidOpenSystemBar()
   Local $wasRunState = $RunState
   AndroidAdbLaunchShellInstance($wasRunState)
   If @error <> 0 Then
	  SetLog("Cannot open " & $Android & " System Bar", $COLOR_RED)
	  Return False
   EndIf
   Local $cmdOutput = AndroidAdbSendShellCommand("am startservice -n com.android.systemui/.SystemUIService", Default, $wasRunState)
   Local $Result = StringLeft($cmdOutput, 16) = "Starting service"
   Return $Result
EndFunc


Func RedrawAndroidWindow()
   Local $Result = Execute("Redraw" & $Android & "Window()")
   If $Result = "" And @error <> 0 Then Return ; Not implemented
   Return $Result
EndFunc