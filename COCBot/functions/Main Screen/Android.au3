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
   Local $hWin = WinGetHandle($Title)
   If $hWin <> 0 Then
	  ; early exit
	  If $HWnD <> $hWin Then SetDebugLog("Found " & $Android & " Window " & $hWin & " by matching title '" & $Title & "'")
	  If $HWnD <> 0 And $HWnD <> $hWin Then $InitAndroid = True ; change window, re-initialize Android config
	  $HWnD = $hWin
	  Return $hWin
   EndIf

   ; search for window
   Local $iMode
   $iMode = Opt("WinTitleMatchMode", -1)
   Local $hWin = WinGetHandle($Title), $t
   Local $error = @error
   Opt("WinTitleMatchMode", $iMode)
   If $error = 0 Then
	  ; window found, check title for case insensitive match
	  $t = WinGetTitle($hWin)
	  If $Title = $t Then
		 ; all good, update $HWnD and exit
		 If $HWnD <> $hWin Then SetDebugLog("Found " & $Android & " Window " & $hWin & " by matching title '" & $Title & "'")
		 If $HWnD <> 0 And $HWnD <> $hWin Then $InitAndroid = True ; change window, re-initialize Android config
		 $HWnD = $hWin
		 Return $hWin
	  Else
		 SetDebugLog($Android & " Window title '" & $t & "' not matching '" & $Title & "'")
	  EndIf
   EndIf

   ; Check for multiple windows
   $iMode = Opt("WinTitleMatchMode", -1)
   Local $aWinList = WinList($Title), $i
   Opt("WinTitleMatchMode", $iMode)
   If $aWinList[0][0] = 0 Then
	  SetDebugLog($Android & " Window not found")
	  If $HWnD <> 0 Then $InitAndroid = True ; no window anymore, re-initialize Android config
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
		 If StringRight($t, StringLen($AndroidInstance)) = $AndroidInstance Then
			; looks good, update $HWnD, $Title and exit
			SetDebugLog("Found " & $Android & " Window " & $hWin & ", title '" & $t & "' for instance " & $AndroidInstance)
			If $HWnD <> 0 And $HWnD <> $hWin Then $InitAndroid = True ; change window, re-initialize Android config
			$HWnD = $hWin
			$Title = $t
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
			If $pid = WinGetProcess($hWin) Then
			   SetDebugLog("Found " & $Android & " Window " & $hWin & ", title '" & $t & "' by PID " & $pid & " ('" & $commandLine & "')")
			   If $HWnD <> 0 And $HWnD <> $hWin Then $InitAndroid = True ; change window, re-initialize Android config
			   $HWnD = $hWin
			   $Title = $t
			   Return $hWin
			EndIf
		 Next
		 SetDebugLog($Android & ($AndroidInstance = "" ? "" : " (" & $AndroidInstance & ")") & " Window not found for PID " & $pid)
	  EndIf
   EndIf

   SetDebugLog($Android & ($AndroidInstance = "" ? "" : " (" & $AndroidInstance & ")") & " Window not found in list")
   If $HWnD <> 0 Then $InitAndroid = True ; no window anymore, re-initialize Android config
   $HWnD = 0
   Return 0
EndFunc

; Checks if Android is running and return instance name
; $bStrictCheck = False includes "unsupported" ways of launching Android (like BlueStacks2 default launch shortcut)
Func GetAndroidRunningInstance($bStrictCheck = True)
   Local $runningInstance = Execute("Get" & $Android & "RunningInstance(" & $bStrictCheck & ")")
   If $runningInstance = "" And @error <> 0 Then ; Not implemented
	  SetDebugLog("GetAndroidRunningInstance: Try to find """ & $AndroidProgramPath & """")
	  Local $pid = ProcessExists2($AndroidProgramPath, "", 1) ; find any process
	  If $pid <> 0 Then
		 Local $currentInstance = $AndroidInstance
		 ; assume last parameter is instance
		 Local $commandLine = ProcessGetCommandLine($pid)
		 SetDebugLog("GetAndroidRunningInstance: Found """ & $commandLine & """ by PID=" & $pid)
		 Local $lastSpace = StringInStr($commandLine, " ", 0, -1)
		 If $lastSpace > 0 Then
			$AndroidInstance = StringMid($commandLine, $lastSpace + 1)
			SetDebugLog("Running " & $Android & " instance is """ & $AndroidInstance & """")
		 EndIf
		 ; validate
		 If WinGetAndroidHandle() <> 0 Then
			Return $AndroidInstance
		 EndIf
		 $AndroidInstance = $currentInstance
	  EndIf
	  Return False
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
		 If GetAndroidRunningInstance(False) = False Then
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
   AndroidAdbTerminateShellInstance()
   $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell am start -S -n com.supercell.clashofclans/.GameApp", $process_killed, 30 * 1000) ; removed "-W" option and added timeout (didn't exit sometimes)
   If Not $RunState Then Return
   If StringInStr($cmdOutput, "Error:") > 0 and StringInStr($cmdOutput, "com.supercell.clashofclans") > 0 Then
	  SetLog("Unable to load Clash of Clans, install/reinstall the game.", $COLOR_RED)
	  SetLog("Unable to continue........", $COLOR_MAROON)
	  btnStop()
	  SetError(1, 1, -1)
	  Return False
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
	If $Result Then SetLog("A restart of your computer might be required for the applied changes to take effect.", $COLOR_ORANGE)
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

Func WaitForAndroidBootCompleted($WaitInSec = 120, $hTimer = 0) ; doesn't work yet!!!
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
	  If Not $connected_to Then ConnectAndroidAdb(False)
	  If Not $RunState Then Return True
	  $booted = StringLeft($cmdOutput, 1) = "1"
	  If $booted Then ExitLoop
	  If $hTimer <> 0 Then _StatusUpdateTime($hTimer)
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
		 $connected_to = StringInStr($cmdOutput, "device not found") = 0
	  EndIf
   Else
	  ; $cmdOutput was specified
	  $connected_to = StringInStr($cmdOutput, "device not found") = 0
   EndIf
   Return $connected_to
EndFunc

Func ConnectAndroidAdb($rebootAndroidIfNeccessary = $RunState)
   ResumeAndroid()

   Local $process_killed, $cmdOutput
   Local $connected_to = IsAdbConnected()
   If $connected_to Then Return True ; all good, adb is connected

   ; not connected... strange, kill any Adb now
   SetLog("Stop ADB daemon!", $COLOR_RED)
   LaunchConsole($AndroidAdbPath, "kill-server", $process_killed)
   Local $pids = ProcessesExist($AndroidAdbPath, "", 1)
   For $i = 0 To UBound($pids) - 1
	  KillProcess($pids[$i], $AndroidAdbPath)
   Next
   ; ok, now try to connect again
   $connected_to = IsAdbConnected()
   If Not $connected_to And $RunState = True And $rebootAndroidIfNeccessary = True Then
	  ; not good, what to do now? Reboot Android...
	  SetLog("ADB cannot connect to " & $Android & ", restart emulator now...", $COLOR_RED)
	  If Not RebootAndroid() Then Return False
      ; ok, last try
	  $connected_to = IsAdbConnected()
	  If Not $connected_to Then
		 ; Let's give up...
		 If Not $RunState Then Return False
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

Func RebootAndroid()
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
	OpenAndroid()

	Return True
EndFunc   ;==>RebootAndroid

Func RebootAndroidSetScreenDefault()
    ResumeAndroid()
    If Not $RunState Then Return False

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

   Local $ok = ($ClientWidth = $AndroidClientWidth) And ($ClientHeight = $AndroidClientHeight)
   If Not $ok Then
	  If $bSetLog Then SetLog("MyBot doesn't work with " & $Android & " screen resolution of " & $ClientWidth & " x " & $ClientHeight & "!", $COLOR_RED)
	  SetDebugLog("CheckScreenAndroid: " & $ClientWidth & " x " & $ClientHeight & " <> " & $AndroidClientWidth & " x " & $AndroidClientHeight)
	  Return False
   EndIf

   ; check emulator specific setting
   SetError(0, 0, 0)
   $ok = Execute("CheckScreen" & $Android & "(" & $bSetLog & ")")
   If $ok = "" And @error <> 0 Then Return True ; Not implemented
   Return $ok

EndFunc

Func AndroidAdbLaunchShellInstance($wasRunState = $RunState)
   If $AndroidAdbPid = 0 Or ProcessExists($AndroidAdbPid) <> $AndroidAdbPid Then
	  Local $SuspendMode = ResumeAndroid()
	  ConnectAndroidAdb()
	  $AndroidAdbPid = Run($AndroidAdbPath & " -s " & $AndroidAdbDevice & " shell", "", @SW_HIDE, BitOR($STDIN_CHILD, $STDERR_MERGED))
	  If $AndroidAdbPid = 0 Or ProcessExists($AndroidAdbPid) <> $AndroidAdbPid Then
		 SetLog($Android & " error launching ADB for background mode, zoom-out, mouse click and input", $COLOR_RED)
		 $AndroidAdbScreencap = False
		 $AndroidAdbClick = False
		 $AndroidAdbInput = False
		 If BitAND($AndroidSupportFeature, 2) = 2 Then $ichkBackground = 0 ; disable also background mode the hard way
		 SetError(1, 0)
	  EndIf
	  ; increase shell priority
	  Local $s = AndroidAdbSendShellCommand("renice -20 $$", Default, $wasRunState)
	  Local $error = @error
	  SetDebugLog("ADB shell launched, PID = " & $AndroidAdbPid & ": " & $s)
	  If $error <> 0 Then
		 SuspendAndroid($SuspendMode)
		 Return
	  EndIf
	  ; check mouse device
	  If StringLen($AndroidMouseDevice) > 0 Then
		 If StringInStr($AndroidMouseDevice, "/dev/input/event") = 0 Then
			; use getevent to find mouse input device
			$s = AndroidAdbSendShellCommand("getevent -p", Default, $wasRunState)
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

Func AndroidAdbSendShellCommand($cmd = Default, $timeout = Default, $wasRunState = $RunState)
   If $timeout = Default Then $timeout = 3000 ; default is 3 sec.
   Local $hTimer = TimerInit()
   Local $sentBytes = 0
   Local $SuspendMode = ResumeAndroid()
   SetError(0, 0, 0)
   If $cmd = Default Then
	  ; nothing to launch
   Else
	  SetDebugLog("Send ADB shell command: " & $cmd)
	  $sentBytes = StdinWrite($AndroidAdbPid, $cmd & @LF)
   EndIf
   Local $s = ""
   Local $loopCount = 0
   While @error = 0 And StringRight($s, StringLen($AndroidShellPrompt)) <> $AndroidShellPrompt And TimerDiff($hTimer) < $timeout
	  Sleep(10)
	  $s &= StdoutRead($AndroidAdbPid)
	  $loopCount += 1
	  If $wasRunState = True And $RunState = False Then ExitLoop ; stop pressed here, exit without error
   WEnd
   SuspendAndroid($SuspendMode)
   Local $error = (($RunState = False Or TimerDiff($hTimer) < $timeout) ? 0 : 1)
   If $error <> 0 Then SetDebugLog("ADB shell command error " & $error & ": " & $s)
   If $__TEST_ERROR_SLOW_ADB_SHELL_COMMAND_DELAY > 0 Then Sleep($__TEST_ERROR_SLOW_ADB_SHELL_COMMAND_DELAY)
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

Func AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $bRetry = True)
   Local $hostPath = $AndroidPicturesHostPath & $AndroidPicturesHostFolder
   Local $androidPath = $AndroidPicturesPath & StringReplace($AndroidPicturesHostFolder, "\", "/")

   If $HwND <> WinGetHandle($HwND) Then Return SetError(4, 0) ; Window gone
   Local $wasRunState = $RunState
   AndroidAdbLaunchShellInstance($wasRunState)
   If @error <> 0 Then Return SetError(2, 0)

   Local $filename = $sBotTitle & ".rgba"
   Local $s

   ; Create 32 bits-per-pixel device-independent bitmap (DIB)
   Local $tBIV5HDR = DllStructCreate($tagBITMAPV5HEADER)
   DllStructSetData($tBIV5HDR, 'bV5Size', DllStructGetSize($tBIV5HDR))
   DllStructSetData($tBIV5HDR, 'bV5Width', $iWidth)
   DllStructSetData($tBIV5HDR, 'bV5Height', -$iHeight)
   DllStructSetData($tBIV5HDR, 'bV5Planes', 1)
   DllStructSetData($tBIV5HDR, 'bV5BitCount', 32)
   DllStructSetData($tBIV5HDR, 'biCompression', $BI_RGB)

   Local $pBits
   Local $hHBitmap = _WinAPI_CreateDIBSection(0, $tBIV5HDR, $DIB_RGB_COLORS, $pBits)

   If $AndroidAdbScreencapTimer <> 0 And $ForceCapture = False And TimerDiff($AndroidAdbScreencapTimer) < $AndroidAdbScreencapTimeout And $RunState = True And $bRetry = True Then
	  DLLCall($LibDir & "\helper_functions.dll", "none:cdecl", "RGBA2BGRA", "ptr", DllStructGetPtr($AndroidAdbScreencapBuffer), "ptr", $pBits, "int", $iLeft, "int", $iTop, "int", $iWidth, "int", $iHeight, "int", $AndroidAdbScreencapWidth, "int", $AndroidAdbScreencapHeight)
	  Return $hHBitmap
   EndIf

   FileDelete($hostPath & $filename)

   $AndroidAdbScreencapTimer = TimerInit()
   $s = AndroidAdbSendShellCommand("screencap """ & $androidPath & $filename & """", 5000, $wasRunState)
   If $__TEST_ERROR_SLOW_ADB_SCREENCAP_DELAY > 0 Then Sleep($__TEST_ERROR_SLOW_ADB_SCREENCAP_DELAY)
   Local $shellLogInfo = @extended

   ; Android screencap see:
   ; https://android.googlesource.com/platform/frameworks/base/+/jb-release/cmds/screencap/screencap.cpp
   ; http://androidsource.top/code/source/system/core/include/system/graphics.h
   ; http://androidsource.top/code/source/frameworks/base/include/ui/PixelFormat.h
   Local $tHeader = DllStructCreate("int w;int h;int f")
   Local $iHeaderSize = DllStructGetSize($tHeader)
   Local $iDataSize = DllStructGetSize($AndroidAdbScreencapBuffer)

   ; wait for file (required for Droid4X)
   Local $iLoopCountFile = 0
   Local $hTimer = TimerInit()
   While TimerDiff($hTimer) < 5000 And FileGetSize($hostPath & $filename) < $AndroidClientWidth * $AndroidClientHeight * 4 + $iHeaderSize ; wait max. 5 seconds
	  Sleep(10)
	  If $wasRunState = True And $RunState = False Then Return SetError(1, 0)
	  $iLoopCountFile += 1
   WEnd

   Local $hFile = _WinAPI_CreateFile($hostPath & $filename, 2, 2)
   If $hFile = 0 Then
	  If $bRetry = True Then
		 AndroidAdbTerminateShellInstance()
		 AndroidAdbLaunchShellInstance($wasRunState)
		 SetDebugLog($Android & " ADB restarted", $COLOR_RED)
		 Return AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, False)
	  EndIf
	  SetLog($Android & " screen not captured using ADB", $COLOR_RED)
	  SetLog($Android & " ADB screen capture disabled", $COLOR_RED)
	  If BitAND($AndroidSupportFeature, 2) = 2 Then $ichkBackground = 0 ; disable also background mode the hard way
	  $AndroidAdbScreencap = False
	  Return SetError(3, 0)
   EndIf
   Local $iSize = _WinAPI_GetFileSizeEx($hFile)
   If $iSize - $iHeaderSize < $iDataSize Then $iDataSize = $iSize - $iHeaderSize
   Local $iRead
   _WinAPI_ReadFile($hFile, $tHeader, $iHeaderSize, $iRead)
   $AndroidAdbScreencapWidth = DllStructGetData($tHeader, "w")
   $AndroidAdbScreencapHeight = DllStructGetData($tHeader, "h")
   Local $iF = DllStructGetData($tHeader, "f")

   _WinAPI_ReadFile($hFile, $AndroidAdbScreencapBuffer, $iDataSize, $iRead)
   _WinAPI_CloseHandle($hFile)

   DLLCall($LibDir & "\helper_functions.dll", "none:cdecl", "RGBA2BGRA", "ptr", DllStructGetPtr($AndroidAdbScreencapBuffer), "ptr", $pBits, "int", $iLeft, "int", $iTop, "int", $iWidth, "int", $iHeight, "int", $AndroidAdbScreencapWidth, "int", $AndroidAdbScreencapHeight)

   Local $duration = Int(TimerDiff($AndroidAdbScreencapTimer))
   ; dynamically adjust $AndroidAdbScreencapTimeout to 3 x of current duration ($AndroidAdbScreencapTimeoutDynamic)
   $AndroidAdbScreencapTimeout = ($AndroidAdbScreencapTimeoutDynamic = 0 ? $AndroidAdbScreencapTimeoutMax : $duration * $AndroidAdbScreencapTimeoutDynamic)
   If $AndroidAdbScreencapTimeout < $AndroidAdbScreencapTimeoutMin Then $AndroidAdbScreencapTimeout = $AndroidAdbScreencapTimeoutMin
   If $AndroidAdbScreencapTimeout > $AndroidAdbScreencapTimeoutMax Then $AndroidAdbScreencapTimeout = $AndroidAdbScreencapTimeoutMax
   SetDebugLog("AndroidScreencap (" & $duration & "ms," & $shellLogInfo & "," & $iLoopCountFile & "): l=" & $iLeft & ",t=" & $iTop & ",w=" & $iWidth & ",h=" & $iHeight & ", " & $filename & ": w=" & $AndroidAdbScreencapWidth & ",h=" & $AndroidAdbScreencapHeight & ",f=" & $iF)
   $AndroidAdbScreencapTimer = TimerInit() ; timeout starts now

   Return $hHBitmap
EndFunc

Func AndroidZoomOut($loopCount = 0, $timeout = Default, $wasRunState = $RunState)
   ResumeAndroid()
   If $HwND <> WinGetHandle($HwND) Then Return SetError(3, 0) ; Window gone
   AndroidAdbLaunchShellInstance($wasRunState)
   If @error <> 0 Then Return SetError(2, 0)

   If StringInStr($AndroidMouseDevice, "/dev/input/event") = 0 Then Return SetError(2, 0, 0)

   Local $scriptFile = ""
   #cs
   If $scriptFile = "" And FileExists($AdbScriptsDir & "\ZoomOut." & $loopCount & ".getevent") = 1 Then $scriptFile = "ZoomOut." & $loopCount & ".getevent"
   If $scriptFile = "" And FileExists($AdbScriptsDir & "\ZoomOut." & Mod($loopCount, 5) & ".getevent") = 1 Then $scriptFile = "ZoomOut." & Mod($loopCount, 5) & ".getevent"
   #ce
   If $scriptFile = "" And FileExists($AdbScriptsDir & "\ZoomOut." & $Android & ".getevent") = 1 Then $scriptFile = "ZoomOut." & $Android & ".getevent"
   If $scriptFile = "" Then $scriptFile = "ZoomOut.getevent"
   If FileExists($AdbScriptsDir & "\" & $scriptFile) = 0 Then SetError(1, 0, 0)
   AndroidAdbSendShellCommandScript($scriptFile, True, $timeout, $wasRunState)
   Return SetError(@error, @extended, (@error = 0 ? 1 : -@error))
EndFunc

#cs
Global $AndroidAdbDdPid = 0
Func AndroidAdbSendDd($of, $data, $wasRunState = $RunState)
   Local $sentBytes = 0
   If $AndroidAdbDdPid = 0 Or ProcessExists($AndroidAdbDdPid) <> $AndroidAdbDdPid Then
	  ConnectAndroidAdb()
	  $AndroidAdbDdPid = Run($AndroidAdbPath & " -s " & $AndroidAdbDevice & " shell", "", @SW_HIDE, BitOR($STDIN_CHILD, $STDERR_MERGED))
	  If $AndroidAdbDdPid = 0 Or ProcessExists($AndroidAdbDdPid) <> $AndroidAdbDdPid Then
		 SetLog($Android & " error launching ADB for dd output " & $of)
		 SetError(1, 0)
	  EndIf
	  ; empty stdout
	  Local $s = AndroidAdbSendShellCommand(Default, Default, $wasRunState)
	  If @error <> 0 Then Return
	  SetDebugLog("ADB shell launched, PID = " & $AndroidAdbDDPid & ": " & $s)
	  ; launch dd
	  $sentBytes = StdinWrite($AndroidAdbDdPid, "dd of=" & $of & " count=160 >/dev/null 2>&1" & @LF)
	  Sleep(500)
	  StdoutRead($AndroidAdbDdPid)
   EndIf
   $sentBytes = StdinWrite($AndroidAdbDdPid, $data)
   SetDebugLog("Send " & $sentBytes & " bytes to " & $of)
   SetError(0, 0)
EndFunc
#ce

Func IsKeepClicksActive()
   Return $AndroidAdbClick = True And $AndroidAdbClicks = True And $AndroidAdbClicks[0] > -1
EndFunc

Func KeepClicks()
   If $AndroidAdbClick = False Or $AndroidAdbClicksEnabled = False Then Return False
   If $AndroidAdbClicks[0] = -1 Then $AndroidAdbClicks[0] = 0
EndFunc

Func ReleaseClicks()
   If $AndroidAdbClick = False Or $AndroidAdbClicksEnabled = False Then Return False
   If $AndroidAdbClicks[0] > 0 Then AndroidClick(-1, -1, $AndroidAdbClicks[0], 0)
   ReDim $AndroidAdbClicks[1]
   $AndroidAdbClicks[0] = -1
EndFunc

Func AndroidClick($x, $y, $times = 1, $speed = 0)
   ;AndroidSlowClick($x, $y, $times, $speed)
   AndroidFastClick($x, $y, $times, $speed)
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
		 SetLog("Error creating " & $hostPath & $filename, $COLOR_RED)
		 SetDebugLog("Disabled " & $Android & " ADB fast mouse click due to error " & $error, $COLOR_RED)
		 $AndroidAdbClick = False
		 _WinAPI_CloseHandle($hFileOpen)
		 Return SetError($error, 0)
	  EndIf
	  _WinAPI_WriteFile($hFileOpen, DllStructGetPtr($data2), $iToWrite, $iWritten)
	  If $hFileOpen = 0 Then
		 Local $error = _WinAPI_GetLastError()
		 SetLog("Error writing " & $hostPath & $filename, $COLOR_RED)
		 SetDebugLog("Disabled " & $Android & " ADB fast mouse click due to error " & $error, $COLOR_RED)
		 $AndroidAdbClick = False
		 _WinAPI_CloseHandle($hFileOpen)
		 Return SetError($error, 0)
	  EndIf
	  _WinAPI_CloseHandle($hFileOpen)
   EndIf

   AndroidAdbSendShellCommand("dd if=""" & $androidPath & $sBotTitle & ".moveaway"" of=" & $AndroidMouseDevice & " obs=" & $iToWrite & ">/dev/null 2>&1" & $sleep, Default)

EndFunc

Func AndroidFastClick($x, $y, $times = 1, $speed = 0, $bRetry = True)
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
	  SetDebugLog("Hold back click (" & $x & "/" & $y & " * " & $times & "): queue size = " & $AndroidAdbClicks[0], $COLOR_RED)
	  Return
   EndIf

   $x = Int($x)
   $y = Int($y)
   $AndroidAdbScreencapTimer = 0 ; invalidate ADB screencap timer/timeout
   Local $wasRunState = $RunState
   Local $hostPath = $AndroidPicturesHostPath & $AndroidPicturesHostFolder
   Local $androidPath = $AndroidPicturesPath & StringReplace($AndroidPicturesHostFolder, "\", "/")
   AndroidAdbLaunchShellInstance($wasRunState)
   If @error <> 0 Then
	  Local $error = @error
	  SetDebugLog("Disabled " & $Android & " ADB fast mouse click, error " & $error & " (AndroidAdbLaunchShellInstance)" , $COLOR_RED)
	  $AndroidAdbClick = False
	  Return SetError($error, 0)
   EndIf
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
	  $adjustSpeed = $speed
	  $speed = 0 ; no need for speed now!
   EndIf
   Local $recordsNum = 8
   Local $recordsClicks = ($times < $AndroidAdbClickGroup ? $times : $AndroidAdbClickGroup)
   For $i = 1 To $recordsNum * $recordsClicks
	  $records &= $record
   Next

   If $ReleaseClicks = True Then
	  SetDebugLog("Release clicks: queue size = " & $AndroidAdbClicks[0])
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
   Local $data2 = DllStructCreate("byte[" & DllStructGetSize($data) & "]", DllStructGetPtr($data))
   Local $hFileOpen = -1
   Local $iToWrite = DllStructGetSize($data2)
   Local $iWritten = 0
   Local $sleep = ""
   If $speed > 0 Then
	  $sleep = "/system/xbin/sleep " & ($speed / 1000) ; use busy box sleep as it supports milliseconds (if available!)
   EndIf
   For $i = 1 to $loops
	  If $i = $loops And $remaining > 0 Then ; last block with less clicks, create new file
		 $iToWrite = (16 * $recordsNum) * $remaining
		 $recordsClicks = $remaining
		 $hFileOpen = -1
	  ElseIf $ReleaseClicks = True Then
		 $hFileOpen = -1
	  EndIf
	  If $hFileOpen = -1 Then
		 ;$hFileOpen = FileOpen($hostPath & $filename, $FO_BINARY  + $FO_OVERWRITE)
		 ;FileWrite($hFileOpen, DllStructGetData($data2,1))
		 ;FileClose($hFileOpen)
		 $hFileOpen = _WinAPI_CreateFile($hostPath & $filename, 1, 4)
		 If $hFileOpen = 0 Then
			Local $error = _WinAPI_GetLastError()
			SetLog("Error creating " & $hostPath & $filename, $COLOR_RED)
			SetDebugLog("Disabled " & $Android & " ADB fast mouse click due to error " & $error, $COLOR_RED)
			$AndroidAdbClick = False
			_WinAPI_CloseHandle($hFileOpen)
			Return SetError($error, 0)
		 EndIf
		 SetDebugLog("AndroidFastClick: $times=" & $times & ", $loops=" & $loops & ", $remaining=" & $remaining)
		 For $j = 0 To $recordsClicks - 1
			If $ReleaseClicks = True Then
			   $Click = $AndroidAdbClicks[($i - 1) * $recordsNum + $j + 1]
			   $x = $Click[0]
			   $y = $Click[1]
			EndIf
			DllStructSetData($data, 2 + $j * $recordsNum, Binary("0x000000000000000003003500" & StringRight(Hex($x, 4),2) & StringLeft(Hex($x, 4),2) & "0000")) ; ABS_MT_POSITION_X
			DllStructSetData($data, 3 + $j * $recordsNum, Binary("0x000000000000000003003600" & StringRight(Hex($y, 4),2) & StringLeft(Hex($y, 4),2) & "0000")) ; ABS_MT_POSITION_Y
		 Next
		 _WinAPI_WriteFile($hFileOpen, DllStructGetPtr($data2), $iToWrite, $iWritten)
		 If $hFileOpen = 0 Then
			Local $error = _WinAPI_GetLastError()
			SetLog("Error writing " & $hostPath & $filename, $COLOR_RED)
			SetDebugLog("Disabled " & $Android & " ADB fast mouse click due to error " & $error, $COLOR_RED)
			$AndroidAdbClick = False
			_WinAPI_CloseHandle($hFileOpen)
			Return SetError($error, 0)
		 EndIf
		 _WinAPI_CloseHandle($hFileOpen)
	  EndIf
	  If $loops > 1 Then
		 AndroidMoveMouseAnywhere()
	  EndIf
	  AndroidAdbSendShellCommand("dd if=""" & $androidPath & $filename & """ of=" & $AndroidMouseDevice & " obs=" & $iToWrite & ">/dev/null 2>&1", Default)
	  If $speed > 0 Then
		 ; speed was overwritten with $AndroidAdbClickGroupDelay
		 Local $sleepTimer = TimerInit()
		 AndroidAdbSendShellCommand($sleep)
		 Local $sleepTime = $speed - TimerDiff($sleepTimer)
		 If $sleepTime > 0 Then Sleep($sleepTime)
	  EndIf
	  If $adjustSpeed > 0 Then
		 ; wait remaining time
		 Local $wait = $adjustSpeed - TimerDiff($timer)
		 If $wait > 0 Then _Sleep($wait, False)
	  EndIf
	  If $RunState = False Then ExitLoop
	  If $__TEST_ERROR_SLOW_ADB_CLICK_DELAY > 0 Then Sleep($__TEST_ERROR_SLOW_ADB_CLICK_DELAY)
	  ;If $speed > 0 Then Sleep($speed)
   Next
   If @error <> 0 Then
	  If $bRetry = True Then
		 SetError(0, 0, 0)
		 SetDebugLog("ADB retry sending mouse click", $COLOR_ORANGE)
		 Return AndroidFastClick($x, $y, $times, $speed, False)
	  EndIF
	  Local $error = @error
	  SetDebugLog("Disabled " & $Android & " ADB fast mouse click due to error " & $error & " (AndroidFastClick)", $COLOR_RED)
	  $AndroidAdbClick = False
	  Return SetError($error, 0)
   EndIf
EndFunc

#cs Test text...
Local $sText = "qq coisa"
Local $newText = StringReplace($sText, " ", "%s")
$newText = StringRegExpReplace($newText, "[^A-Za-z0-9\.,\?""!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]`~]", ".")
If @extended  <> 0 Then
   ConsoleWrite("Not working: " & $newText)
Else
   ConsoleWrite("Good: " & $newText)
EndIf
#ce
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
   Local $pid = WinGetProcess($HWnD)
   If $pid = -1 Then Return False
   $AndroidSuspended = True
   _ProcessSuspendResume2($pid, True) ; suspend Android
   If $bDebugLog = True Then SetDebugLog("Android Suspended")
   Return False
EndFunc

Func ResumeAndroid($bDebugLog = True)
   If $AndroidSuspendedEnabled = False Then Return False
   If $AndroidSuspended = False Then Return False
   Local $pid = WinGetProcess($HWnD)
   If $pid = -1 Then Return False
   $AndroidSuspended = False
   _ProcessSuspendResume2($pid, False) ; resume Android
   If $bDebugLog = True Then SetDebugLog("Android Resumed")
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