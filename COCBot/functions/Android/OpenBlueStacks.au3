; #FUNCTION# ====================================================================================================================
; Name ..........: OpenBS
; Description ...:
; Syntax ........: OpenBS([$bRestart = False])
; Parameters ....: $bRestart            - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: GkevinOD (2014), Hervidero (2015) (orginal open() fucntion)
; Modified ......: Cosote (Dec 2015), KnowJack (Aug2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
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

	SetLog("Starting BlueStacks and Clash Of Clans", $COLOR_SUCCESS)

	;$PID = ShellExecute($__BlueStacks_Path & "HD-RunApp.exe", "-p " & $g_sAndroidGamePackage & " -a " & $g_sAndroidGamePackage & $g_sAndroidGameClass)  ;Start BS and CoC with command line
	$PID = ShellExecute($__BlueStacks_Path & "HD-Frontend.exe", "Android")  ;Start BS and CoC with command line
	If _Sleep(1000) Then Return False
	$ErrorResult = ControlGetHandle("BlueStacks Error", "", "") ; Check for BS error window handle if it opens
	If $g_iDebugSetlog = 1 Then Setlog("$PID= "&$PID & ", $ErrorResult = " &$ErrorResult, $COLOR_DEBUG)
	If $PID = 0 Or $ErrorResult <> 0  Then  ; IF ShellExecute failed or BS opens error window = STOP
		SetLog("Unable to load Clash of Clans, install/reinstall the game.", $COLOR_ERROR)
		SetLog("Unable to continue........", $COLOR_WARNING)
		btnstop()
		SetError(1, 1, -1)
		Return False
	EndIf

	SetLog("Please wait while " & $g_sAndroidEmulator & "/CoC start....", $COLOR_SUCCESS)
	WinGetAndroidHandle()
	$hTimer = TimerInit()  ; start a timer for tracking BS start up time
	While IsArray(ControlGetPos($Title, $g_sAppPaneName, $g_sAppClassInstance)) = False
		If _Sleep(3000) Then ExitLoop
		_StatusUpdateTime($hTimer, $g_sAndroidEmulator & "/CoC Start")
		If TimerDiff($hTimer) > $g_iAndroidLaunchWaitSec * 1000 Then ; if no BS position returned in 4 minutes, BS/PC has major issue so exit
			SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
			SetLog("BlueStacks refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_ERROR)
			DebugSaveDesktopImage("BSOpenError_") ; Save copy of user desktop for analysis
			SetLog("Unable to continue........", $COLOR_WARNING)
			btnstop()
			SetError(1, 1, -1)
			Return False
		EndIf
	    WinGetAndroidHandle()
	WEnd

	If IsArray(ControlGetPos($Title, $g_sAppPaneName, $g_sAppClassInstance)) Then
	    $connected_to = ConnectAndroidAdb(False, 3000) ; small time-out as ADB connection must be available now

		SetLog("BlueStacks Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_SUCCESS)

		Return True

	EndIf

	Return False

EndFunc   ;==>OpenBlueStacks

Func OpenBlueStacks2($bRestart = False)

   Local $hTimer, $iCount = 0, $cmdOutput, $process_killed, $i, $connected_to
   SetLog("Starting " & $g_sAndroidEmulator & " and Clash Of Clans", $COLOR_SUCCESS)

   If Not InitAndroid() Then Return False

   SetLog("Please wait while " & $g_sAndroidEmulator & " and CoC start...", $COLOR_SUCCESS)

   CloseUnsupportedBlueStacks2()

   $hTimer = TimerInit()
   WinGetAndroidHandle()
   While IsArray(ControlGetPos($Title, $g_sAppPaneName, $g_sAppClassInstance)) = False
	  If Not $g_bRunState Then Return False
	  ; check that HD-Frontend.exe process is really there
	  Local $pid = ProcessExists2($g_sAndroidProgramPath)
	  If $pid <= 0 Then
		 $pid = ShellExecute($g_sAndroidProgramPath, GetBlueStacks2ProgramParameter())
		 If _Sleep(1000) Then Return False
	  EndIf
	  If $pid > 0 Then $pid = ProcessExists2($g_sAndroidProgramPath)
	  If $pid <= 0 Then
		 CloseAndroid("OpenBlueStacks2")
		 If _Sleep(1000) Then Return False
	  EndIf

	 _StatusUpdateTime($hTimer)
	 If TimerDiff($hTimer) > $g_iAndroidLaunchWaitSec * 1000 Then ; if no BS position returned in 4 minutes, BS/PC has major issue so exit
		 SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
		 SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_ERROR)
		 SetError(1, @extended, False)
		 Return False
	 EndIf
	 If _Sleep(3000) Then Return False
     _StatusUpdateTime($hTimer, $g_sAndroidEmulator & "/CoC Start")
     WinGetAndroidHandle()
   WEnd

   ; enable window title so BS2 can be moved again
   WinGetAndroidHandle()
   Local $lCurStyle = _WinAPI_GetWindowLong($HWnD, $GWL_STYLE)
   ; Enable Title Bar and Border
   $lCurStyle = BitOr($lCurStyle, $WS_CAPTION, $WS_SYSMENU)
   _WinAPI_SetWindowLong($HWnd, $GWL_STYLE, $lCurStyle)
   ;_WinAPI_SetWindowPos($HWnd, 0, 0, 0, 0, 0, BitOr($SWP_NOMOVE, $SWP_NOSIZE, $SWP_FRAMECHANGED)) ; redraw

   If IsArray(ControlGetPos($Title, $g_sAppPaneName, $g_sAppClassInstance)) Then
     $connected_to = ConnectAndroidAdb(False, 3000) ; small time-out as ADB connection must be available now

     ;If WaitForDeviceBlueStacks2($g_iAndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return
     If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return
	 If Not $g_bRunState Then Return False

	 SetLog($g_sAndroidEmulator & " Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_SUCCESS)
     AndroidAdbLaunchShellInstance()

	 If Not $g_bRunState Then Return False
     ConfigBlueStacks2WindowManager()

	 Return True

   EndIf

   Return False

EndFunc   ;==>OpenBlueStacks

Func InitBlueStacksX($bCheckOnly = False, $bAdjustResolution = False, $bLegacyMode = False)

	; more recent BlueStacks 2 version install VirtualBox based "plus" mode by default
	Local $plusMode = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\", "Engine") = "plus" And $bLegacyMode = False
	Local $frontend_exe = "HD-Frontend.exe"
	If $plusMode = True Then $frontend_exe = "HD-Plus-Frontend.exe"

    Local $i, $aFiles[3] = [$frontend_exe, "HD-Adb.exe", "HD-Quit.exe"]
    Local $Values[4][3] = [ _
	  ["Screen Width", $g_iAndroidClientWidth  , $g_iAndroidClientWidth], _
	  ["Screen Height", $g_iAndroidClientHeight, $g_iAndroidClientHeight], _
	  ["Window Width", $g_iAndroidWindowWidth  , $g_iAndroidWindowWidth], _
	  ["Window Height", $g_iAndroidWindowHeight , $g_iAndroidWindowHeight] _
    ]
    Local $bChanged = False

	$__BlueStacks_Version = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\", "Version")
	$__BlueStacks_Path = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\", "InstallDir")
	If @error <> 0 Then
		$__BlueStacks_Path = @ProgramFilesDir & "\BlueStacks\"
		SetError(0, 0, 0)
	EndIf
	$__BlueStacks_Path = StringReplace($__BlueStacks_Path, "\\", "\")

    For $i = 0 To UBound($aFiles) - 1

	  Local $File = $__BlueStacks_Path & $aFiles[$i]
	  If Not FileExists($File) Then
		 If $plusMode And $aFiles[$i] = $frontend_exe Then
			; try legacy mode
			SetDebugLog("Cannot find " & $g_sAndroidEmulator & " file:" & $File, $COLOR_ACTION)
			SetDebugLog("Try legacy mode", $COLOR_ACTION)
			Return InitBlueStacksX($bCheckOnly, $bAdjustResolution, True)
		 EndIf
		 If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($File, $COLOR_ERROR)
			SetError(1, @extended, False)
		 EndIf
		 Return False
	  EndIf

    Next

    If Not $bCheckOnly Then
	  Local $BootParameter = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\Guests\Android\", "BootParameters")
	  Local $OEMFeatures
	  Local $aRegExResult = StringRegExp($BootParameter, "OEMFEATURES=(\d+)", $STR_REGEXPARRAYGLOBALMATCH)
	  If Not @error Then
		 ; get last match!
		 $OEMFeatures = $aRegExResult[UBound($aRegExResult) - 1]
		 $g_bAndroidHasSystemBar = BitAND($OEMFeatures, 0x000001) = 0
	  EndIf

	  ; update global variables
	  $g_sAndroidProgramPath = $__BlueStacks_Path & $frontend_exe
	  $g_sAndroidAdbPath = FindPreferredAdbPath()
	  If $g_sAndroidAdbPath = "" Then $g_sAndroidAdbPath = $__BlueStacks_Path & "HD-Adb.exe"
	  $g_sAndroidVersion = $__BlueStacks_Version
	  For $i = 0 To 5
		 If RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\Guests\Android\SharedFolder\" & $i & "\", "Name") = "BstSharedFolder" Then
			$g_sAndroidPicturesPath = "/storage/sdcard/windows/BstSharedFolder/"
			$g_sAndroidPicturesHostPath = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\Guests\Android\SharedFolder\" & $i & "\", "Path")
			ExitLoop
		 EndIf
	  Next

	  SetDebugLog($g_sAndroidEmulator & " Engine 'Plus'-Mode: " & $plusMode)
	  SetDebugLog($g_sAndroidEmulator & " OEM Features: " & $OEMFeatures)
	  SetDebugLog($g_sAndroidEmulator & " System Bar is " & ($g_bAndroidHasSystemBar ? "" : "not ") & "available")
	  #cs as of 2016-01-26 CoC release, system bar is transparent and should be closed when bot is running
	  If $bAdjustResolution Then
		 If $g_bAndroidHasSystemBar Then
			;$Values[0][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][5]
			$Values[1][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][6] + $__BlueStacks_SystemBar
			;$Values[2][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][7]
			$Values[3][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][8] + $__BlueStacks_SystemBar
		 Else
			;$Values[0][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][5]
			$Values[1][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][6]
			;$Values[2][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][7]
			$Values[3][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][8]
		 EndIf
	  EndIf
	  $g_iAndroidClientWidth = $Values[0][2]
	  $g_iAndroidClientHeight = $Values[1][2]
	  $g_iAndroidWindowWidth =  $Values[2][2]
	  $g_iAndroidWindowHeight = $Values[3][2]
	  #ce

	  For $i = 0 To UBound($Values) -1
		 If $Values[$i][1] <> $Values[$i][2] Then
			$bChanged = True
			SetDebugLog($g_sAndroidEmulator & " " & $Values[$i][0] & " updated from " & $Values[$i][1] & " to " & $Values[$i][2])
		 EndIf
	  Next

	  WinGetAndroidHandle()
    EndIf

    Return True

EndFunc

Func InitBlueStacks($bCheckOnly = False)
   Local $bInstalled = InitBlueStacksX($bCheckOnly)
   If $bInstalled And (GetVersionNormalized($__BlueStacks_Version) < GetVersionNormalized("0.8") Or GetVersionNormalized($__BlueStacks_Version) > GetVersionNormalized("1.x") > 0) Then
	  If Not $bCheckOnly Then
		 SetLog("BlueStacks version is " & $__BlueStacks_Version & " but support version 0.8.x - 1.x not found", $COLOR_ERROR)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIF

   If Not $bCheckOnly Then
	  ; BS 1 always has system bar
	  $g_bAndroidHasSystemBar = True
   EndIF

   Return $bInstalled
EndFunc

Func InitBlueStacks2($bCheckOnly = False)
   Local $bInstalled = InitBlueStacksX($bCheckOnly, True)
   If $bInstalled And StringInStr($__BlueStacks_Version, "2.") <> 1 Then
	  If Not $bCheckOnly Then
		 SetLog("BlueStacks supported version 2 not found", $COLOR_ERROR)
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
	  If Not $g_bRunState Then Return True
	  ; Test ADB is connected
	  $cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " shell am idle-maintenance", $process_killed)
	  If $hTimer <> 0 Then _StatusUpdateTime($hTimer)
	  $connected_to = IsAdbConnected($cmdOutput)
	  $am_ready = StringInStr($cmdOutput, "Performing idle maintenance")
	  If $am_ready Then ExitLoop
	  If TimerDiff($hMyTimer) > $WaitInSec * 1000 Then ; if no device available in 4 minutes, Android/PC has major issue so exit
		 SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
		 SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(TimerDiff($hMyTimer) / 1000, 2) & " seconds for activity manager", $COLOR_ERROR)
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
   If Not $g_bRunState Then Return False
   Local $cmdOutput, $process_killed
   If Not InitAndroid() Then Return False
   If WinGetAndroidHandle() = 0 Then Return False
   $cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " shell am start -W -S -n " & $g_sAndroidGamePackage & "/" & $g_sAndroidGameClass, $process_killed)
   SetLog("Please wait for CoC restart......", $COLOR_INFO)   ; Let user know we need time...
   Return True
EndFunc

Func RestartBlueStacksCoC()
   Return RestartBlueStacksXCoC()
EndFunc

Func RestartBlueStacks2CoC()
   Return RestartBlueStacksXCoC()
EndFunc

Func CheckScreenBlueStacksX($bSetLog = True)
   Local $REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0"
   Local $aValues[5][2] = [ _
	  ["FullScreen", 0], _
	  ["GuestHeight", $g_iAndroidClientHeight], _
	  ["GuestWidth", $g_iAndroidClientWidth], _
	  ["WindowHeight", $g_iAndroidClientHeight], _
	  ["WindowWidth", $g_iAndroidClientWidth] _
   ]
   Local $i, $Value, $iErrCnt = 0
   For $i = 0 To UBound($aValues) -1
	  $Value = RegRead($REGISTRY_KEY_DIRECTORY, $aValues[$i][0])
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

Func CheckScreenBlueStacks($bSetLog = True)
   Return CheckScreenBlueStacksX($bSetLog)
EndFunc

Func CheckScreenBlueStacks2($bSetLog = True)
   Return CheckScreenBlueStacksX($bSetLog)
EndFunc

Func SetScreenBlueStacks()
   Local $REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0"
   RegWrite($REGISTRY_KEY_DIRECTORY, "FullScreen", "REG_DWORD", "0")
   RegWrite($REGISTRY_KEY_DIRECTORY, "GuestHeight", "REG_DWORD", $g_iAndroidClientHeight)
   RegWrite($REGISTRY_KEY_DIRECTORY, "GuestWidth", "REG_DWORD", $g_iAndroidClientWidth)
   RegWrite($REGISTRY_KEY_DIRECTORY, "WindowHeight", "REG_DWORD", $g_iAndroidClientHeight)
   RegWrite($REGISTRY_KEY_DIRECTORY, "WindowWidth", "REG_DWORD", $g_iAndroidClientWidth)
EndFunc

Func SetScreenBlueStacks2()
   Local $REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks\Guests\Android\FrameBuffer\0"
   RegWrite($REGISTRY_KEY_DIRECTORY, "FullScreen", "REG_DWORD", "0")
   RegWrite($REGISTRY_KEY_DIRECTORY, "GuestHeight", "REG_DWORD", $g_iAndroidClientHeight)
   RegWrite($REGISTRY_KEY_DIRECTORY, "GuestWidth", "REG_DWORD", $g_iAndroidClientWidth)
   RegWrite($REGISTRY_KEY_DIRECTORY, "WindowHeight", "REG_DWORD", $g_iAndroidClientHeight)
   RegWrite($REGISTRY_KEY_DIRECTORY, "WindowWidth", "REG_DWORD", $g_iAndroidClientWidth)
   $REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks\Guests\Android\Config"
   ; Enable bottom action bar with Back- and Home-Button (Menu-Button has no function and don't click Full-Screen-Button at the right as you cannot go back - F11 is not working!)
   ; 2015-12-24 cosote Disabled with "0" again because latest version 2.0.2.5623 doesn't support it anymore
   RegWrite($REGISTRY_KEY_DIRECTORY, "FEControlBar", "REG_DWORD", "0")
EndFunc

Func RebootBlueStacksSetScreen()

   Return RebootAndroidSetScreenDefault()

EndFunc

Func ConfigBlueStacks2WindowManager()
   If Not $g_bRunState Then Return
   Local $cmdOutput, $process_killed
   ; shell wm density 160
   ; shell wm size 860x672
   ; shell reboot

   ; Reset Window Manager size
   $cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " shell wm size reset", $process_killed)

   ; Set expected dpi
   $cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " shell wm density 160", $process_killed)

   ; Set font size to normal
   AndroidSetFontSizeNormal()
EndFunc

Func RebootBlueStacks2SetScreen($bOpenAndroid = True)

   ;RebootAndroidSetScreenDefault()

   If Not InitAndroid() Then Return False

   ConfigBlueStacks2WindowManager()

   ; Close Android
   CloseAndroid("RebootBlueStacks2SetScreen")
   If _Sleep(1000) Then Return False

   SetScreenAndroid()
   If Not $g_bRunState Then Return False

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
   Local $WinTitleMatchMode = Opt("WinTitleMatchMode", -3) ; in recent 2.3.x can be also "BlueStacks App Player"
   Local $h = WinGetHandle("Bluestacks App Player", "") ; Need fixing as BS2 Emulator can have that title when configured in registry
   If @error = 0 Then
	  $a[0] = $h
   EndIf
   Opt("WinTitleMatchMode", $WinTitleMatchMode)
   Return $a
EndFunc

Func GetBlueStacksProgramParameter($bAlternative = False)
   Return "Android"
EndFunc

Func GetBlueStacks2ProgramParameter($bAlternative = False)
   Return "Android"
EndFunc

Func BlueStacksBotStartEvent()
   If $g_bAndroidEmbedded = False Then
	   SetDebugLog("Disable " & $g_sAndroidEmulator & " minimize/maximize Window Buttons")
	   DisableBS($HWnD, $SC_MINIMIZE)
	   DisableBS($HWnD, $SC_MAXIMIZE)
   EndIf
   Return AndroidCloseSystemBar()
EndFunc

Func BlueStacksBotStopEvent()
   If $g_bAndroidEmbedded = False Then
	   SetDebugLog("Enable " & $g_sAndroidEmulator & " minimize/maximize Window Buttons")
	   EnableBS($HWnD, $SC_MINIMIZE)
	   EnableBS($HWnD, $SC_MAXIMIZE)
   EndIf
   Return AndroidOpenSystemBar()
EndFunc

Func BlueStacks2BotStartEvent()
   If $g_bAndroidEmbedded = False Then
	   SetDebugLog("Disable " & $g_sAndroidEmulator & " minimize/maximize Window Buttons")
	   DisableBS($HWnD, $SC_MINIMIZE)
	   DisableBS($HWnD, $SC_MAXIMIZE)
   EndIf
   If $g_bAndroidHasSystemBar Then Return AndroidCloseSystemBar()
   Return False
EndFunc

Func BlueStacks2BotStopEvent()
   If $g_bAndroidEmbedded = False Then
	   SetDebugLog("Enable " & $g_sAndroidEmulator & " minimize/maximize Window Buttons")
	   EnableBS($HWnD, $SC_MINIMIZE)
	   EnableBS($HWnD, $SC_MAXIMIZE)
   EndIf
   If $g_bAndroidHasSystemBar Then Return AndroidOpenSystemBar()
   Return False
EndFunc

Func BlueStacksAdjustClickCoordinates(ByRef $x, ByRef $y)
   $x = Round(32767.0 / $g_iAndroidClientWidth * $x)
   $y = Round(32767.0 / $g_iAndroidClientHeight * $y)
EndFunc

Func BlueStacks2AdjustClickCoordinates(ByRef $x, ByRef $y)
   $x = Round(32767.0 / $g_iAndroidClientWidth * $x)
   $y = Round(32767.0 / $g_iAndroidClientHeight * $y)
   ;Local $Num = 32728
   ;$x = Int(($Num * $x) / $g_iAndroidClientWidth)
   ;$y = Int(($Num * $y) / $g_iAndroidClientHeight)
EndFunc

Func DisableBS($HWnD, $iButton)
	Local $hSysMenu = _GUICtrlMenu_GetSystemMenu($HWnD, 0)
	_GUICtrlMenu_RemoveMenu($hSysMenu, $iButton, False)
	_GUICtrlMenu_DrawMenuBar($HWnD)
EndFunc   ;==>DisableBS

Func EnableBS($HWnD, $iButton)
	Local $hSysMenu = _GUICtrlMenu_GetSystemMenu($HWnD, 1)
	_GUICtrlMenu_RemoveMenu($hSysMenu, $iButton, False)
	_GUICtrlMenu_DrawMenuBar($HWnD)
EndFunc   ;==>EnableBS

Func GetBlueStacksSvcPid()

   ; find process PID
   Local $pid = ProcessExists2("HD-Service.exe")
   Return $pid

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
