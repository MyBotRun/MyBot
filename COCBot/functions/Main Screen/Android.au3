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
Func UpdateAndroidConfig($instance = $AndroidAppConfig[$AndroidConfig][1])
    SetDebugLog("UpdateAndroidConfig(""" & $instance & """)")

	$Android = $AndroidAppConfig[$AndroidConfig][0] ; Emulator used (BS, BS2 or Droid4X)
	$AndroidInstance = $instance ; Clone or instance of emulator or "" if not supported
	$Title = $AndroidAppConfig[$AndroidConfig][2] ; Emulator Window Title
	$AppClassInstance = $AndroidAppConfig[$AndroidConfig][3] ; Control Class and instance of android rendering
	$AppPaneName = $AndroidAppConfig[$AndroidConfig][4] ; Control name of android rendering TODO check is still required
	$AndroidClientWidth = $AndroidAppConfig[$AndroidConfig][5] ; Expected width of android rendering
	$AndroidClientHeight = $AndroidAppConfig[$AndroidConfig][6] ; Expected height of android rendering
	$AndroidWindowWidth = $AndroidAppConfig[$AndroidConfig][7]
	$AndroidWindowHeight = $AndroidAppConfig[$AndroidConfig][8]
	$ClientOffsetY = $AndroidAppConfig[$AndroidConfig][9]
	$AndroidAdbDevice = $AndroidAppConfig[$AndroidConfig][10]
	$AndroidSupportsBackgroundMode = $AndroidAppConfig[$AndroidConfig][11]

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
	  $HWnD = $hWin
	  If $HWnD <> $hWin Then SetDebugLog("Found " & $Android & " Window " & $hWin & " by matching title '" & $Title & "'")
	  Return $hWin
   EndIf

   ; search for window
   Local $iMode
   $iMode = Opt("WinTitleMatchMode", -1)
   Local $hWin = WinGetHandle($Title), $t
   Local $error = @error
   Opt("WinTitleMatchMode", $iMode)
   If $error = 0 Then
	  ; window found, check title for exact match
	  $t = WinGetTitle($hWin)
	  If $Title = $t Then
		 ; all good, update $HWnD and exit
		 If $HWnD <> $hWin Then SetDebugLog("Found " & $Android & " Window " & $hWin & " by matching title '" & $Title & "'")
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
			   $HWnD = $hWin
			   $Title = $t
			   Return $hWin
			EndIf
		 Next
		 SetDebugLog($Android & ($AndroidInstance = "" ? "" : " (" & $AndroidInstance & ")") & " Window not found for PID " & $pid)
	  EndIf
   EndIf

   SetDebugLog($Android & ($AndroidInstance = "" ? "" : " (" & $AndroidInstance & ")") & " Window not found in list")
   $HWnD = 0
   Return 0
EndFunc

; Checks if Android is running
; $bStrictCheck = False includes "unsupported" ways of launching Android
Func AndroidIsRunning($bStrictCheck = True)
   Local $bRunning = Execute($Android & "IsRunning(" & $bStrictCheck & ")")
   If $bRunning = "" And @error <> 0 Then $bRunning = WinGetAndroidHandle() <> 0 ; Not implemented
   Return $bRunning
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
	  If UpdateAndroidConfig() Then
		 ; this Android is installed
		 If AndroidIsRunning(False) Then
			; Window is available
			$FoundRunningAndroid = True
			$SilentSetLog = False
			SetDebugLog("Found running " & $Android & " " & $AndroidVersion)
			Return
		 EndIf
	  EndIf
	Next

    ; Reset to current config
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
    UpdateAndroidConfig()
    $SilentSetLog = False
    SetDebugLog("Found no installed Android Emulator")
EndFunc   ;==>DetectInstalledAndroid

Func InitAndroid($bCheckOnly = False)
    SetDebugLog("InitAndroid(" & $bCheckOnly & ")")
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
	   ;$HWnD = WinGetHandle($Title) ;Handle for Android window
	   WinGetAndroidHandle() ; Set $HWnD and $Title for Android window
    EndIf
    SetDebugLog("InitAndroid(" & $bCheckOnly & ") END")
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
    If Not $RunState Then Return False
	Return Execute("Open" & $Android & "(" & $bRestart & ")")
EndFunc   ;==>OpenAndroid

Func RestartAndroidCoC($bInitAndroid = True)
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
    If Not $RunState Then Return False
	Return Execute("Close" & $Android & "()")
EndFunc   ;==>CloseAndroid

Func SetScreenAndroid()
    If Not $RunState Then Return False
	; Set Android screen size and dpi
	SetLog("Set " & $Android & " screen resolution to " & $AndroidClientWidth & " x " & $AndroidClientHeight, $COLOR_BLUE)
	Local $Result = Execute("SetScreen" & $Android & "()")
	If $Result Then SetLog("A restart of your computer might be required for the applied changes to take effect.", $COLOR_ORANGE)
    Return $Result
EndFunc   ;==>SetScreenAndroid

Func CloseUnsupportedAndroid()
   If Not $RunState Then Return False
   SetError(0, 0, 0)
   Local $Closed = Execute("CloseUnsupported" & $Android & "()")
   If $Closed = "" And @error <> 0 Then Return False ; Not implemented
   Return $Closed
EndFunc

Func RebootAndroidSetScreen()
    If Not $RunState Then Return False
	Return Execute("Reboot" & $Android & "SetScreen()")
EndFunc   ;==>RebootAndroidSetScreen

Func IsAdbTCP()
   Return StringInStr($AndroidAdbDevice, ":") > 0
EndFunc

Func WaitForAndroidBootCompleted($WaitInSec = 120, $hTimer = 0) ; doesn't work yet!!!
   If Not $RunState Then Return True
   Local $cmdOutput, $connected_to, $booted, $process_killed, $hMyTimer
	; Wait for boot completed
	$hMyTimer = ($hTimer = 0 ? TimerInit() : $hTimer)
	While True
	  If Not $RunState Then Return
	  $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell getprop sys.boot_completed", $process_killed)
	  ; Test ADB is connected
	  $connected_to = IsAdbConnected($cmdOutput)
	  If Not $connected_to Then ConnectAndroidAdb()
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
   If Not $RunState Then Return True
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

Func ConnectAndroidAdb($rebootAndroidIfNeccessary = True)

   If Not $RunState Then Return False

   Local $process_killed, $cmdOutput
   Local $connected_to = IsAdbConnected()
   If $connected_to Then Return True ; all good, adb is connected

   ; not connected... strange, kill any Adb now
   Local $pids = ProcessesExist($AndroidAdbPath, "", 1)
   For $i = 0 To UBound($pids) - 1
	  KillProcess($pids[$i], $AndroidAdbPath)
   Next
   ; ok, now try to connect again
   $connected_to = IsAdbConnected()
   If Not $connected_to Then
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
		 _ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		 Local $stxt = @CRLF & "MyBot has experienced a serious error" & @CRLF & @CRLF & _
			"Unable connecting ADB to " & $Android & @CRLF & @CRLF & "Reboot PC and try again," & _
			"and search www.mybot.run forums for more help" & @CRLF
		 Local $MsgBox = _ExtMsgBox(0, "Close MyBot!", "Okay - Must Exit Program", $stxt, 15) ; how patient is the user ;) ?
		 If $MsgBox = 1 Then
			 BotClose()
		 EndIf
		 btnStop()
		 Return False
	  EndIf
   EndIf

   Return True ; ADB is connected
EndFunc

Func RebootAndroid()

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

Func AndroidCloseSystemBar()
   Local $cmdOutput, $process_killed
   $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell service call activity 42 s16 com.android.systemui", $process_killed)
   Local $Result = StringLeft($cmdOutput, 6) = "Result"
   Return $Result
EndFunc

Func AndroidOpenSystemBar()
   Local $cmdOutput, $process_killed
   $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell am startservice -n com.android.systemui/.SystemUIService", $process_killed)
   Local $Result = StringLeft($cmdOutput, 16) = "Starting service"
   Return $Result
EndFunc