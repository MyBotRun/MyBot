; #FUNCTION# ====================================================================================================================
; Name ..........: OpenBS
; Description ...:
; Syntax ........: OpenBS([$bRestart = False])
; Parameters ....: $bRestart            - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: GkevinOD (2014), Hervidero (2015) (orginal open() fucntion)
; Modified ......: Cosote (Dec 2015), KnowJack (Aug2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
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
	Local $PID, $BSPath, $ErrorResult
	SetLog("Starting BlueStacks and Clash Of Clans", $COLOR_GREEN)

    If Not InitBlueStacks() Then Return

    Local $BSPath = RegRead($HKLM & "\SOFTWARE\BlueStacks\", "InstallDir")  ; Get the installed BS location from the registry
	If $debugsetlog = 1 Then Setlog("$BSPath= " & $BSPath, $COLOR_PURPLE)  ; Debug only
	If @error <> 0 Then
		$BSPath = @ProgramFilesDir & "\BlueStacks\"   ; If not found default to standard program files directory
		Setlog("Default BS Path = " & $BSPath, $COLOR_MAROON)  ; Debug only
		SetError(0, 0, 0)
	EndIf

	$PID = ShellExecute($BSPath & "HD-RunApp.exe", "-p com.supercell.clashofclans -a com.supercell.clashofclans.GameApp")  ;Start BS and CoC with command line
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
	SetLog("Please wait while BS/CoC starts....", $COLOR_GREEN)
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
	WEnd

	If IsArray(ControlGetPos($Title, $AppPaneName, $AppClassInstance)) Then
		SetLog("BlueStacks Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_GREEN)
	    ; Check Android screen size, position windows
		if InitiateLayout() Then Return; can also call this recursively again when screen size is adjusted
		$HWnD = WinGetHandle($Title) ; get BS window Handle
		DisableBS($HWnD, $SC_MINIMIZE)
		;DisableBS($HWnD, $SC_CLOSE) ; don't tamper with close button
		If $bRestart = False Then  ; Then 1st time BS is open
			waitMainScreenMini()
			Zoomout()
			Initiate()
		Else
			WaitMainScreenMini()
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

   Local $hTimer, $iCount = 0, $cmdOutput, $connected_to, $am_ready, $process_killed, $i
   SetLog("Starting " & $Android & " and Clash Of Clans", $COLOR_GREEN)

   If Not InitBlueStacks2() Then Return

   Local $BSPath = RegRead($HKLM & "\SOFTWARE\BlueStacks\", "InstallDir")
   If @error <> 0 Then
	 $BSPath = @ProgramFilesDir & "\BlueStacks\"
	 SetError(0, 0, 0)
   EndIf

   SetLog("Please wait while " & $Android & " and CoC starts...", $COLOR_GREEN)

   If IsArray(ControlGetPos("Bluestacks App Player",  "", "")) Then ; $AndroidAppConfig[1][4]

	  SetLog("Unsupported " & $Android & " Window detected, restart " & $Android & "...", $COLOR_ORANGE)

	  CloseBlueStacks2()
	  If _Sleep(1000) Then Return

   EndIf

   $hTimer = TimerInit()
   While IsArray(ControlGetPos($Title, $AppPaneName, $AppClassInstance)) = False

	  ; check that HD-Frontend.exe process is really there
	  Local $pid = ProcessExists("HD-Frontend.exe")
	  If $pid <= 0 Then
		 $pid = ShellExecute($__BlueStacks_Path & "HD-Frontend.exe", "Android")
		 If _Sleep(1000) Then Return
	  EndIf
	  If $pid > 0 Then $pid = ProcessExists("HD-Frontend.exe")
	  If $pid <= 0 Then
		 CloseBlueStacks2()
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
   WEnd

   ; enable window title so BS2 can be move again
   $HWnd = WinGetHandle($Title)
   Local $lCurStyle = _WinAPI_GetWindowLong($HWnd, $GWL_STYLE)
   ; Enable Title Bar and Border
   $lCurStyle = BitOr($lCurStyle, $WS_CAPTION, $WS_SYSMENU)
   _WinAPI_SetWindowLong($HWnd, $GWL_STYLE, $lCurStyle)
   ;_WinAPI_SetWindowPos($HWnd, 0, 0, 0, 0, 0, BitOr($SWP_NOMOVE, $SWP_NOSIZE, $SWP_FRAMECHANGED)) ; redraw

   If WaitForDeviceBlueStacks2($AndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return

   If IsArray(ControlGetPos($Title, $AppPaneName, $AppClassInstance)) Then
	 SetLog($Android & " Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_GREEN)

     ; Check Android screen size, position windows
     if InitiateLayout() Then Return; can also call OpenDroid4X again when screen size is adjusted

     ; Launch CcC
	 SetLog("Launch Clash of Clans now...", $COLOR_GREEN)
	 $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell am start -W -S -n com.supercell.clashofclans/.GameApp", $process_killed)

     $HWnD = WinGetHandle($Title) ; get BS window Handle
	 DisableBS($HWnD, $SC_MINIMIZE)
	 ;DisableBS($HWnD, $SC_CLOSE) ; don't tamper with close button
	 If $bRestart = False Then
		 waitMainScreenMini()
		 Zoomout()
		 Initiate()
	 Else
		 WaitMainScreenMini()
		 If @error = 1 Then
			 $Restart = True
			 $Is_ClientSyncError = False
			 Return
		 EndIf
		 Zoomout()
	 EndIf
   EndIf

EndFunc   ;==>OpenBlueStacks

Func InitBlueStacksX($bCheckOnly = False)
    Local $i, $aFiles[3] = ["HD-Frontend.exe", "HD-Adb.exe", "HD-Quit.exe"]

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
	   ; update global variables
	   $AndroidAdbPath = $__BlueStacks_Path & "HD-Adb.exe"
	   $AndroidVersion = $__BlueStacks_Version
    EndIf

    Return True

EndFunc

Func InitBlueStacks($bCheckOnly = False)
   Local $bInstalled = InitBlueStacksX($bCheckOnly)
   If $bInstalled And StringInStr($__BlueStacks_Version, "0.8.") <> 1 _
				  And StringInStr($__BlueStacks_Version, "0.9.") <> 1 _
				  And StringInStr($__BlueStacks_Version, "0.10.") <> 1 _
   Then
	  If Not $bCheckOnly Then
		 SetLog("BlueStacks supported version 0.8.x - 0.10.x not found", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIF

   Return $bInstalled
EndFunc

Func InitBlueStacks2($bCheckOnly = False)
   Local $bInstalled = InitBlueStacksX($bCheckOnly)
   If $bInstalled And StringInStr($__BlueStacks_Version, "2.0.") <> 1 Then
	  If Not $bCheckOnly Then
		 SetLog("BlueStacks supported version 2.0 not found", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIF
   Return $bInstalled
EndFunc

Func WaitForDeviceBlueStacks2($WaitInSec, $hTimer = 0)
   Local $cmdOutput, $connected_to, $am_ready, $process_killed, $hMyTimer
	; Wait for Activity Manager
	$hMyTimer = ($hTimer = 0 ? TimerInit() : $hTimer)
	While True
	  ; Test ADB is connected
	  $cmdOutput = LaunchConsole($AndroidAdbPath, "connect " & $AndroidAdbDevice, $process_killed)
	  $connected_to = StringInStr($cmdOutput, "connected to")
	  $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell am idle-maintenance", $process_killed)
	  If $hTimer <> 0 Then _StatusUpdateTime($hTimer)
	  $am_ready = StringInStr($cmdOutput, "Performing idle maintenance")
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

; Called from checkMainScreen
Func RestartBlueStacksCoC()
   Local $RunApp = StringReplace(_WinAPI_GetProcessFileName(WinGetProcess($Title)), "Frontend", "RunApp")
   $HWnD = WinGetHandle($Title)
   If @error <> 0 Then return
   WinActivate($HWnD)  	; ensure bot has window focus
   PureClick(126, $DEFAULT_HEIGHT - 20, 2, 500,"#0126")  ; click on BS home button twice to clear error and go home.
   Run($RunApp & " Android com.supercell.clashofclans com.supercell.clashofclans.GameApp")
   SetLog("Please wait for CoC restart......", $COLOR_BLUE)   ; Let user know we need time...
EndFunc

Func RestartBlueStacks2CoC()
   Local $cmdOutput, $process_killed
   If Not InitBlueStacks2() Then Return False
   $HWnD = WinGetHandle($Title)
   If @error <> 0 Then return
   WinActivate($HWnD)  	; ensure bot has window focus
   WaitForDeviceBlueStacks2(30)
   $cmdOutput = LaunchConsole($AndroidAdbPath, "-s " & $AndroidAdbDevice & " shell am start -W -S -n com.supercell.clashofclans/.GameApp", $process_killed)
   SetLog("Please wait for CoC restart......", $COLOR_BLUE)   ; Let user know we need time...
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

   RebootAndroidSetScreenDefault()

EndFunc


Func RebootBlueStacks2SetScreen()

   ;RebootAndroidSetScreenDefault()

   If Not InitBlueStacks2() Then Return False
   Local $cmdOutput, $process_killed

   ; shell wm density 160
   ; shell wm size 860x672
   ; shell reboot
   ;Run($BSPath & "\HD-Adb.exe Android com.supercell.clashofclans com.supercell.clashofclans.GameApp")

   ; Reset Window Manager size
   $cmdOutput = LaunchConsole($__BlueStacks_Path & "HD-Adb.exe", "-s " & $AndroidAdbDevice & " shell wm size reset", $process_killed)

   ; Set expected dpi
   $cmdOutput = LaunchConsole($__BlueStacks_Path & "HD-Adb.exe", "-s " & $AndroidAdbDevice & " shell wm density 160", $process_killed)

   ; Close Android
   CloseAndroid()
   If _Sleep(1000) Then Return

   ; Set Android screen size and dpi
   SetLog("Set " & $Android & " screen resolution to " & $DEFAULT_WIDTH & " x " & $DEFAULT_HEIGHT, $COLOR_BLUE)
   SetScreenAndroid()

   SetLog("A restart of your computer might be required for the applied changes to take effect.", $COLOR_ORANGE)

   ; Start Android
   OpenAndroid()

   Return True

EndFunc

Func waitMainScreenMini()
	Local $iCount = 0
	Local $hTimer = TimerInit()
	getBSPos() ; Update Android Window Positions
	SetLog("Waiting for Main Screen after BS restart", $COLOR_BLUE)
	For $i = 0 To 60 ;30*2000 = 1 Minutes
		If $debugsetlog = 1 Then Setlog("ChkObstl Loop = " & $i & "ExitLoop = " & $iCount, $COLOR_PURPLE) ; Debug stuck loop
		$iCount += 1
		_CaptureRegion()
		If _CheckPixel($aIsMain, $bNoCapturepixel) = False Then ;Checks for Main Screen
			If _Sleep(1000) Then Return
			If CheckObstacles() Then $i = 0 ;See if there is anything in the way of mainscreen
		Else
			SetLog("CoC main window took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_GREEN)
			Return
		EndIf
		_StatusUpdateTime($hTimer, "Main Screen")
		If ($i > 60) Or ($iCount > 80) Then ExitLoop  ; If CheckObstacles forces reset, limit total time to 6 minute before Force restart BS
	Next
	Return SetError( 1, 0, -1)
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
