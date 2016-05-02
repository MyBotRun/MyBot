; #FUNCTION# ====================================================================================================================
; Name ..........: OpenBS
; Description ...:
; Syntax ........: OpenBS([$bRestart = False])
; Parameters ....: $bRestart            - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: GkevinOD (2014), Hervidero (2015) (orginal open() fucntion)
; Modified ......: Cosote (Dec 2015), KnowJack (Aug2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenBS($bRestart = False) ; @deprecated, use OpenAndroid()
   Return OpenAndroid($bRestart)
EndFunc

Func OpenBlueStacks($bRestart = False)

	Local $hTimer, $iCount = 0
	Local $PID, $ErrorResult, $connected_to

	SetLog("Starting BlueStacks and Clash Of Clans", $COLOR_GREEN)

    If Not InitAndroid() Then Return

	$PID = ShellExecute($__BlueStacks_Path & "HD-RunApp.exe", "-p com.supercell.clashofclans -a com.supercell.clashofclans.GameApp")  ;Start BS and CoC with command line
	If _Sleep(1000) Then Return
	$ErrorResult = ControlGetHandle("BlueStacks Error", "", "") ; Check for BS error window handle if it opens
	If $debugsetlog = 1 Then Setlog("$PID= "&$PID & ", $ErrorResult = " &$ErrorResult, $COLOR_PURPLE)
	If $PID = 0 Or $ErrorResult <> 0  Then  ; IF ShellExecute failed or BS opens error window = STOP
		SetLog("Unable to load Clash of Clans, install/reinstall the game.", $COLOR_RED)
		SetLog("Unable to continue........", $COLOR_MAROON)
		btnstop()
		SetError(1, 1, -1)
		Return
	EndIf

	$hTimer = TimerInit()  ; start a timer for tracking BS start up time
	SetLog("Please wait while BS/CoC start....", $COLOR_GREEN)
	WinGetAndroidHandle()
	While IsArray(ControlGetPos($Title, $AppPaneName, $AppClassInstance)) = False
		If _Sleep(1000) Then ExitLoop
		$iCount += 1
		_StatusUpdateTime($hTimer, "BS/CoC Start")
		If $iCount > 240 Then ; if no BS position returned in 4 minutes, BS/PC has major issue so exit
			SetLog("Serious error has occurred, please restart PC and try again", $COLOR_RED)
			SetLog("BlueStacks refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_RED)
			DebugSaveDesktopImage("BSOpenError_") ; Save copy of user desktop for analysis
			SetLog("Unable to continue........", $COLOR_MAROON)
			btnstop()
			SetError(1, 1, -1)
			Return
		EndIf
	    WinGetAndroidHandle()
	WEnd

	If IsArray(ControlGetPos($Title, $AppPaneName, $AppClassInstance)) Then
	    $connected_to = ConnectAndroidAdb(False, 60 * 1000)

		SetLog("BlueStacks Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_GREEN)
		AndroidAdbLaunchShellInstance()

	    ; Check Android screen size, position windows
		If InitiateLayout() Then Return; can also call this recursively again when screen size is adjusted
		DisableBS($HWnD, $SC_MINIMIZE)
		;DisableBS($HWnD, $SC_CLOSE) ; don't tamper with close button
		If $bRestart = False Then  ; Then 1st time BS is open
			waitMainScreenMini()
			If Not $RunState Then Return
			Zoomout()
			If Not $RunState Then Return
			Initiate()
		Else
			WaitMainScreenMini()
			If Not $RunState Then Return
			If @error = 1 Then  ; if error waiting for main screen, set restart flag, clear OOS flag, and hope the rest of code fixes it
				$Restart = True
				$Is_ClientSyncError = False
				SetError(0,0,0)
				Return
			EndIf
			Zoomout()
		EndIf
	EndIf

EndFunc   ;==>OpenBlueStacks

Func OpenBlueStacks2($bRestart = False)

   Local $hTimer, $iCount = 0, $cmdOutput, $process_killed, $i, $connected_to
   SetLog("Starting " & $Android & " and Clash Of Clans", $COLOR_GREEN)

   If Not InitAndroid() Then Return

   SetLog("Please wait while " & $Android & " and CoC start...", $COLOR_GREEN)

   CloseUnsupportedBlueStacks2()

   $hTimer = TimerInit()
   WinGetAndroidHandle()
   While IsArray(ControlGetPos($Title, $AppPaneName, $AppClassInstance)) = False
	  If Not $RunState Then Return
	  ; check that HD-Frontend.exe process is really there
	  Local $pid = ProcessExists("HD-Frontend.exe")
	  If $pid <= 0 Then
		 $pid = ShellExecute($__BlueStacks_Path & "HD-Frontend.exe", GetBlueStacks2ProgramParameter())
		 If _Sleep(1000) Then Return
	  EndIf
	  If $pid > 0 Then $pid = ProcessExists("HD-Frontend.exe")
	  If $pid <= 0 Then
		 CloseAndroid()
		 If _Sleep(1000) Then Return
	  EndIf

	 _StatusUpdateTime($hTimer)
	 If TimerDiff($hTimer) > $AndroidLaunchWaitSec * 1000 Then ; if no BS position returned in 4 minutes, BS/PC has major issue so exit
		 SetLog("Serious error has occurred, please restart PC and try again", $COLOR_RED)
		 SetLog("BlueStacks refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_RED)
		 SetError(1, @extended, False)
		 Return
	 EndIf
	 If _Sleep(500) Then Return
     WinGetAndroidHandle()
   WEnd

   ; enable window title so BS2 can be moved again
   WinGetAndroidHandle()
   Local $lCurStyle = _WinAPI_GetWindowLong($HWnD, $GWL_STYLE)
   ; Enable Title Bar and Border
   $lCurStyle = BitOr($lCurStyle, $WS_CAPTION, $WS_SYSMENU)
   _WinAPI_SetWindowLong($HWnd, $GWL_STYLE, $lCurStyle)
   ;_WinAPI_SetWindowPos($HWnd, 0, 0, 0, 0, 0, BitOr($SWP_NOMOVE, $SWP_NOSIZE, $SWP_FRAMECHANGED)) ; redraw

   $connected_to = ConnectAndroidAdb(False, 60 * 1000)

   ;If WaitForDeviceBlueStacks2($AndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return
   If WaitForAndroidBootCompleted($AndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return
   If Not $RunState Then Return

   If IsArray(ControlGetPos($Title, $AppPaneName, $AppClassInstance)) Then
	 SetLog($Android & " Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_GREEN)
     AndroidAdbLaunchShellInstance()

     ConfigeBlueStacks2WindowManager()
	 If Not $RunState Then Return

     ; Check Android screen size, position windows
     if InitiateLayout() Then Return; can also call OpenDroid4X again when screen size is adjusted

     If Not $RunState Then Return
     ; Launch CcC
	 SetLog("Launch Clash of Clans now...", $COLOR_GREEN)
	 ;$cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell am start -W -S -n com.supercell.clashofclans/.GameApp", $process_killed)

	 RestartAndroidCoC()
	 If Not $RunState Then Return

     $HWnD = WinGetHandle($Title) ; get BS window Handle

     DisableBS($HWnD, $SC_MINIMIZE)
	 ;DisableBS($HWnD, $SC_CLOSE) ; don't tamper with close button
	 If $bRestart = False Then
		 waitMainScreenMini()
		 If Not $RunState Then Return
		 Zoomout()
		 If Not $RunState Then Return
		 Initiate()
	 Else
		 WaitMainScreenMini()
		 If Not $RunState Then Return
		 If @error = 1 Then
			 $Restart = True
			 $Is_ClientSyncError = False
			 Return
		 EndIf
		 Zoomout()
	 EndIf
   EndIf

EndFunc   ;==>OpenBlueStacks

Func InitBlueStacksX($bCheckOnly = False, $bAdjustResolution = False)
    Local $i, $aFiles[3] = ["HD-Frontend.exe", "HD-Adb.exe", "HD-Quit.exe"]
    Local $Values[4][3] = [ _
	  ["Screen Width", $AndroidClientWidth  , $AndroidClientWidth], _
	  ["Screen Height", $AndroidClientHeight, $AndroidClientHeight], _
	  ["Window Width", $AndroidWindowWidth  , $AndroidWindowWidth], _
	  ["Window Height", $AndroidWindowHeight , $AndroidWindowHeight] _
    ]
    Local $bChanged = False

	$__BlueStacks_Version = RegRead($HKLM & "\SOFTWARE\BlueStacks\", "Version")
	$__BlueStacks_Path = RegRead($HKLM & "\SOFTWARE\BlueStacks\", "InstallDir")
	If @error <> 0 Then
		$__BlueStacks_Path = @ProgramFilesDir & "\BlueStacks\"
		SetError(0, 0, 0)
	EndIf

    For $i = 0 To UBound($aFiles) - 1

	  Local $File = $__BlueStacks_Path & $aFiles[$i]
	  If Not FileExists($File) Then
		 If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $Android & ":", $COLOR_RED)
			SetLog($File, $COLOR_RED)
			SetError(1, @extended, False)
		 EndIf
		 Return False
	  EndIf

    Next

    If Not $bCheckOnly Then
	  Local $BootParameter = RegRead($HKLM & "\SOFTWARE\BlueStacks\Guests\Android\", "BootParameters")
	  Local $OEMFeatures
	  Local $aRegExResult = StringRegExp($BootParameter, "OEMFEATURES=(\d+)", $STR_REGEXPARRAYGLOBALMATCH)
	  If Not @error Then
		 ; get last match!
		 $OEMFeatures = $aRegExResult[UBound($aRegExResult) - 1]
		 $AndroidHasSystemBar = BitAND($OEMFeatures, 0x000001) = 0
	  EndIf

	  ; update global variables
	  $AndroidProgramPath = $__BlueStacks_Path & "HD-Frontend.exe"
	  $AndroidAdbPath = FindPreferredAdbPath()
	  If $AndroidAdbPath = "" Then $AndroidAdbPath = $__BlueStacks_Path & "HD-Adb.exe"
	  $AndroidVersion = $__BlueStacks_Version
	  For $i = 0 To 5
		 If RegRead($HKLM & "\SOFTWARE\BlueStacks\Guests\Android\SharedFolder\" & $i & "\", "Name") = "BstSharedFolder" Then
			$AndroidPicturesPath = "/storage/sdcard/windows/BstSharedFolder/"
			$AndroidPicturesHostPath = RegRead($HKLM & "\SOFTWARE\BlueStacks\Guests\Android\SharedFolder\" & $i & "\", "Path")
			ExitLoop
		 EndIf
	  Next

	  SetDebugLog($Android & " OEM Features: " & $OEMFeatures)
	  SetDebugLog($Android & " System Bar is " & ($AndroidHasSystemBar ? "" : "not ") & "available")
	  #cs as of 2016-01-26 CoC release, system bar is transparent and should be closed when bot is running
	  If $bAdjustResolution Then
		 If $AndroidHasSystemBar Then
			;$Values[0][2] = $AndroidAppConfig[$AndroidConfig][5]
			$Values[1][2] = $AndroidAppConfig[$AndroidConfig][6] + $__BlueStacks_SystemBar
			;$Values[2][2] = $AndroidAppConfig[$AndroidConfig][7]
			$Values[3][2] = $AndroidAppConfig[$AndroidConfig][8] + $__BlueStacks_SystemBar
		 Else
			;$Values[0][2] = $AndroidAppConfig[$AndroidConfig][5]
			$Values[1][2] = $AndroidAppConfig[$AndroidConfig][6]
			;$Values[2][2] = $AndroidAppConfig[$AndroidConfig][7]
			$Values[3][2] = $AndroidAppConfig[$AndroidConfig][8]
		 EndIf
	  EndIf
	  $AndroidClientWidth = $Values[0][2]
	  $AndroidClientHeight = $Values[1][2]
	  $AndroidWindowWidth =  $Values[2][2]
	  $AndroidWindowHeight = $Values[3][2]
	  #ce

	  For $i = 0 To UBound($Values) -1
		 If $Values[$i][1] <> $Values[$i][2] Then
			$bChanged = True
			SetDebugLog($Android & " " & $Values[$i][0] & " updated from " & $Values[$i][1] & " to " & $Values[$i][2])
		 EndIf
	  Next

	  WinGetAndroidHandle()
    EndIf

    Return True

EndFunc

Func InitBlueStacks($bCheckOnly = False)
   Local $bInstalled = InitBlueStacksX($bCheckOnly)
   If $bInstalled And StringInStr($__BlueStacks_Version, "0.8.") <> 1 _
				  And StringInStr($__BlueStacks_Version, "0.9.") <> 1 _
				  And StringInStr($__BlueStacks_Version, "0.10.") <> 1 _
				  And StringInStr($__BlueStacks_Version, "0.11.") <> 1 _ ; user reported that version exists - ha ;)
   Then
	  If Not $bCheckOnly Then
		 SetLog("BlueStacks supported version 0.8.x - 0.11.x not found", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIF

   If Not $bCheckOnly Then
	  ; BS 1 always has system bar
	  $AndroidHasSystemBar = True
   EndIF

   Return $bInstalled
EndFunc

Func InitBlueStacks2($bCheckOnly = False)
   Local $bInstalled = InitBlueStacksX($bCheckOnly, True)
   If $bInstalled And StringInStr($__BlueStacks_Version, "2.") <> 1 Then
	  If Not $bCheckOnly Then
		 SetLog("BlueStacks supported version 2 not found", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIF

   If Not $bCheckOnly Then
	  ; nothing special to set yet
   EndIF

   Return $bInstalled
EndFunc

#cs
Func WaitForDeviceBlueStacks2($WaitInSec, $hTimer = 0)
   Local $cmdOutput, $connected_to, $am_ready, $process_killed, $hMyTimer
	; Wait for Activity Manager
	$hMyTimer = ($hTimer = 0 ? TimerInit() : $hTimer)
	While True
	  If Not $RunState Then Return True
	  ; Test ADB is connected
	  $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell am idle-maintenance", $process_killed)
	  If $hTimer <> 0 Then _StatusUpdateTime($hTimer)
	  $connected_to = IsAdbConnected($cmdOutput)
	  $am_ready = StringInStr($cmdOutput, "Performing idle maintenance")
	  If $am_ready Then ExitLoop
	  If TimerDiff($hMyTimer) > $WaitInSec * 1000 Then ; if no device available in 4 minutes, Android/PC has major issue so exit
		 SetLog("Serious error has occurred, please restart PC and try again", $COLOR_RED)
		 SetLog($Android & " refuses to load, waited " & Round(TimerDiff($hMyTimer) / 1000, 2) & " seconds for activity manager", $COLOR_RED)
		 SetError(1, @extended, False)
		 Return True
	  EndIf
	  If _Sleep(1000) Then Return True
    WEnd
	Return False
EndFunc
#ce

; Called from checkMainScreen
Func RestartBlueStacksXCoC()
   If Not $RunState Then Return False
   Local $cmdOutput, $process_killed
   If Not InitAndroid() Then Return False
   $HWnD = WinGetHandle($Title)
   If @error <> 0 Then Return False
   ;WinActivate($HWnD)  	; ensure bot has window focus
   ;WaitForDeviceBlueStacks2(30)
   $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell am start -W -S -n com.supercell.clashofclans/.GameApp", $process_killed)
   SetLog("Please wait for CoC restart......", $COLOR_BLUE)   ; Let user know we need time...
   Return True
EndFunc

Func RestartBlueStacksCoC()
   Return RestartBlueStacksXCoC()
EndFunc

Func RestartBlueStacks2CoC()
   Return RestartBlueStacksXCoC()
EndFunc

Func CheckScreenBlueStacksX($bSetLog = True)
   Local $REGISTRY_KEY_DIRECTORY = $HKLM & "\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0"
   Local $aValues[5][2] = [ _
	  ["FullScreen", 0], _
	  ["GuestHeight", $AndroidClientHeight], _
	  ["GuestWidth", $AndroidClientWidth], _
	  ["WindowHeight", $AndroidClientHeight], _
	  ["WindowWidth", $AndroidClientWidth] _
   ]
   Local $i, $Value, $iErrCnt = 0
   For $i = 0 To UBound($aValues) -1
	  $Value = RegRead($REGISTRY_KEY_DIRECTORY, $aValues[$i][0])
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

Func CheckScreenBlueStacks($bSetLog = True)
   Return CheckScreenBlueStacksX($bSetLog)
EndFunc

Func CheckScreenBlueStacks2($bSetLog = True)
   Return CheckScreenBlueStacksX($bSetLog)
EndFunc

Func SetScreenBlueStacks()
   Local $REGISTRY_KEY_DIRECTORY = $HKLM & "\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0"
   RegWrite($REGISTRY_KEY_DIRECTORY, "FullScreen", "REG_DWORD", "0")
   RegWrite($REGISTRY_KEY_DIRECTORY, "GuestHeight", "REG_DWORD", $AndroidClientHeight)
   RegWrite($REGISTRY_KEY_DIRECTORY, "GuestWidth", "REG_DWORD", $AndroidClientWidth)
   RegWrite($REGISTRY_KEY_DIRECTORY, "WindowHeight", "REG_DWORD", $AndroidClientHeight)
   RegWrite($REGISTRY_KEY_DIRECTORY, "WindowWidth", "REG_DWORD", $AndroidClientWidth)
EndFunc

Func SetScreenBlueStacks2()
   Local $REGISTRY_KEY_DIRECTORY = $HKLM & "\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0"
   RegWrite($REGISTRY_KEY_DIRECTORY, "FullScreen", "REG_DWORD", "0")
   RegWrite($REGISTRY_KEY_DIRECTORY, "GuestHeight", "REG_DWORD", $AndroidClientHeight)
   RegWrite($REGISTRY_KEY_DIRECTORY, "GuestWidth", "REG_DWORD", $AndroidClientWidth)
   RegWrite($REGISTRY_KEY_DIRECTORY, "WindowHeight", "REG_DWORD", $AndroidClientHeight)
   RegWrite($REGISTRY_KEY_DIRECTORY, "WindowWidth", "REG_DWORD", $AndroidClientWidth)
   $REGISTRY_KEY_DIRECTORY = $HKLM & "\SOFTWARE\BlueStacks\Guests\Android\Config"
   ; Enable bottom action bar with Back- and Home-Button (Menu-Button has no function and don't click Full-Screen-Button at the right as you cannot go back - F11 is not working!)
   ; 2015-12-24 cosote Disabled with "0" again because latest version 2.0.2.5623 doesn't support it anymore
   RegWrite($REGISTRY_KEY_DIRECTORY, "FEControlBar", "REG_DWORD", "0")
EndFunc

Func RebootBlueStacksSetScreen()

   Return RebootAndroidSetScreenDefault()

EndFunc

Func ConfigeBlueStacks2WindowManager()
   If Not $RunState Then Return
   Local $cmdOutput, $process_killed
   ; shell wm density 160
   ; shell wm size 860x672
   ; shell reboot

   ; Reset Window Manager size
   $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell wm size reset", $process_killed)

   ; Set expected dpi
   $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell wm density 160", $process_killed)

   ; Set font size to normal
   AndroidSetFontSizeNormal()
EndFunc

Func RebootBlueStacks2SetScreen($bOpenAndroid = True)

   ;RebootAndroidSetScreenDefault()

   If Not InitAndroid() Then Return False

   ConfigeBlueStacks2WindowManager()

   ; Close Android
   CloseAndroid()
   If _Sleep(1000) Then Return False

   SetScreenAndroid()
   If Not $RunState Then Return False

   If $bOpenAndroid Then
	  ; Start Android
	  OpenAndroid(True)
   EndIf

   Return True

EndFunc

Func GetBlueStacksRunningInstance($bStrictCheck = True)
   WinGetAndroidHandle()
   Local $a[2] = [$HWnD, ""]
   Return $a
EndFunc

Func GetBlueStacks2RunningInstance($bStrictCheck = True)
   WinGetAndroidHandle()
   Local $a[2] = [$HWnD, ""]
   If $HWnD <> 0 Then Return $a
   If $bStrictCheck Then Return False
   Local $h = WinGetHandle("Bluestacks App Player", "") ; Need fixing as BS2 Emulator can have that title when configured in registry
   If @error = 0 Then
	  $a[0] = $h
   EndIf
   Return $a
EndFunc

Func GetBlueStacksProgramParameter($bAlternative = False)
   Return "Android"
EndFunc

Func GetBlueStacks2ProgramParameter($bAlternative = False)
   Return "Android"
EndFunc

Func BlueStacksBotStartEvent()
   Return AndroidCloseSystemBar()
EndFunc

Func BlueStacksBotStopEvent()
   Return AndroidOpenSystemBar()
EndFunc

Func BlueStacks2BotStartEvent()
   If $AndroidHasSystemBar Then Return AndroidCloseSystemBar()
   Return False
EndFunc

Func BlueStacks2BotStopEvent()
   If $AndroidHasSystemBar Then Return AndroidOpenSystemBar()
   Return False
EndFunc

Func BlueStacks2AdjustClickCoordinates(ByRef $x, ByRef $y)
   $x = Round(32767.0 / $AndroidClientWidth * $x)
   $y = Round(32767.0 / $AndroidClientHeight * $y)
   ;Local $Num = 32728
   ;$x = Int(($Num * $x) / $AndroidClientWidth)
   ;$y = Int(($Num * $y) / $AndroidClientHeight)
EndFunc

#comments-start
$connect = _GetNetworkConnect()

If $connect Then
    MsgBox(64, "Connections", $connect)
Else
    MsgBox(48, "Warning", "There is no connection")
EndIf

Func _GetNetworkConnect()
    Local Const $NETWORK_ALIVE_LAN = 0x1  ;net card connection
    Local Const $NETWORK_ALIVE_WAN = 0x2  ;RAS (internet) connection
    Local Const $NETWORK_ALIVE_AOL = 0x4  ;AOL

    Local $aRet, $iResult

    $aRet = DllCall("sensapi.dll", "int", "IsNetworkAlive", "int*", 0)

    If BitAND($aRet[1], $NETWORK_ALIVE_LAN) Then $iResult &= "LAN connected" & @LF
    If BitAND($aRet[1], $NETWORK_ALIVE_WAN) Then $iResult &= "WAN connected" & @LF
    If BitAND($aRet[1], $NETWORK_ALIVE_AOL) Then $iResult &= "AOL connected" & @LF

    Return $iResult
EndFunc
#comments-end
