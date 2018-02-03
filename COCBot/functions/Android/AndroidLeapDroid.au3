; #FUNCTION# ====================================================================================================================
; Name ..........: LeadDroid implementation
; Description ...: Handles LeapDroid open, close and configuration etc. http://www.leapdroid.com/
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (07-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenLeapDroid($bRestart = False)

	Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdPar

	SetLog("Starting " & $g_sAndroidEmulator & " and Clash Of Clans", $COLOR_SUCCESS)

	Local $launchAndroid = (WinGetAndroidHandle() = 0 ? True : False)
	If $launchAndroid Then
		; Launch LeapDroid
		$cmdPar = GetAndroidProgramParameter()
		$PID = LaunchAndroid($g_sAndroidProgramPath, $cmdPar, $g_sAndroidPath)
		If $PID = 0 Then
			SetError(1, 1, -1)
			Return False
		EndIf
	EndIf

	SetLog("Please wait while " & $g_sAndroidEmulator & " and CoC start...", $COLOR_SUCCESS)
	$hTimer = __TimerInit()

	; Test ADB is connected
	$connected_to = ConnectAndroidAdb(False, 60 * 1000)
	If Not $g_bRunState Then Return False

	; Wair for finishing boot
	If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec - __TimerDiff($hTimer) / 1000, $hTimer) Then Return False

	If __TimerDiff($hTimer) >= $g_iAndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
		SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
		SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_ERROR)
		SetError(1, @extended, False)
		Return False
	EndIf

	SetLog($g_sAndroidEmulator & " Loaded, took " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_SUCCESS)

	Return True

EndFunc   ;==>OpenLeapDroid

Func IsLeapDroidCommandLine($CommandLine)
	SetDebugLog("Check LeapDroid command line instance: " & $CommandLine)
	Local $sInstance = ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance)
	$CommandLine = StringReplace($CommandLine, GetLeapDroidPath(), "")
	If StringRegExp($CommandLine, "-s " & $sInstance & "\b") = 1 Then Return True
	Return False
EndFunc   ;==>IsLeapDroidCommandLine

Func GetLeapDroidProgramParameter($bAlternative = False)
	Local $sInstance = ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance)
	If Not $bAlternative Or $g_sAndroidInstance <> $g_avAndroidAppConfig[$g_iAndroidConfig][1] Then
		; should be launched with these parameter
		Return "-vfiber -novtcheck -w " & $g_iAndroidClientWidth & " -h " & $g_iAndroidClientHeight & " -s " & $sInstance
	EndIf
	; default instance gets launched when no parameter was specified (this is the alternative way)
	Return "-s " & $sInstance
EndFunc   ;==>GetLeapDroidProgramParameter

Func GetLeapDroidPath()
	Local $LeapDroid_Path = RegRead($g_sHKLM & "\SOFTWARE\Leapdroid\Leapdroid VM\", "InstallDir")
	If $LeapDroid_Path <> "" And FileExists($LeapDroid_Path & "\LeapdroidVM.exe") = 0 Then
		$LeapDroid_Path = ""
	EndIf
	; pre 1.5.0
	Local $InstallLocation = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\LeapdroidVM\", "InstallLocation")
	If $LeapDroid_Path = "" And FileExists($InstallLocation & "\leapdroidvm.ini") = 1 Then ; read path from ini
		$LeapDroid_Path = IniRead($InstallLocation & "\leapdroidvm.ini", "main", "install_path", "")
		If FileExists($LeapDroid_Path & "\LeapdroidVM.exe") = 0 Then
			$LeapDroid_Path = ""
		EndIf
	EndIf
	If $LeapDroid_Path = "" And FileExists($InstallLocation & "\LeapdroidVM.exe") = 1 Then
		$LeapDroid_Path = $InstallLocation
	EndIf
	If $LeapDroid_Path = "" And FileExists(@ProgramFilesDir & "\Leapdroid\VM\LeapdroidVM.exe") = 1 Then
		$LeapDroid_Path = @ProgramFilesDir & "\Leapdroid\VM"
	EndIf
	SetError(0, 0, 0)
	If $LeapDroid_Path <> "" And StringRight($LeapDroid_Path, 1) <> "\" Then $LeapDroid_Path &= "\"
	Return StringReplace($LeapDroid_Path, "\\", "\")
EndFunc   ;==>GetLeapDroidPath

Func GetLeapDroidAdbPath()
	Local $adbPath = GetLeapDroidPath() & "adb.exe"
	If FileExists($adbPath) Then Return $adbPath
	Return ""
EndFunc   ;==>GetLeapDroidAdbPath

Func GetLeapDroidBackgroundMode()
	; Only OpenGL is supported up to version 3.1.2.5

	Local $files[2] = [@MyDocumentsDir & "\Leapdroid\Leapdroid Emulator\leapdroid.settings", GetLeapDroidPath() & "Leapdroid Emulator\leapdroid.settings"]
	Local $f, $p, $h

	; Set width and height
	For $f In $files
		$p = StringMid($f, 1, StringInStr($f, "\", 0, -1))
		If FileExists($p) Then
			If FileExists($f) Then
				Local $sSettings = FileRead($f)
				Local $aRegExResult = StringRegExp($sSettings, "RENDERER=(\d+)", $STR_REGEXPARRAYMATCH)
				If Not @error Then
					Local $graphics_render_mode = $aRegExResult[0]
					Switch $graphics_render_mode
						Case "1"
							Return $g_iAndroidBackgroundModeDirectX
						Case Else
							Return $g_iAndroidBackgroundModeOpenGL
					EndSwitch
				EndIf
				ExitLoop
			EndIf
		EndIf
	Next

	Return $g_iAndroidBackgroundModeOpenGL
EndFunc   ;==>GetLeapDroidBackgroundMode

Func InitLeapDroid($bCheckOnly = False)
	Local $process_killed, $aRegExResult, $g_sAndroidAdbDeviceHost, $g_sAndroidAdbDevicePort, $oops = 0
	Local $LeapDroidVersion = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\LeapDroid\", "DisplayVersion")
	SetError(0, 0, 0)
	; Could also read LeapDroid paths from environment variables LeapDroid_Path and LeapDroidHyperv_Path
	Local $LeapDroid_Path = GetLeapDroidPath()
	Local $LeapDroid_Manage_Path = GetLeapDroidPath() & "VBoxManage.exe"

	If FileExists($LeapDroid_Path) = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator, $COLOR_ERROR)
			SetLog("installation directory", $COLOR_ERROR)
			SetError(1, @extended, False)
		Else
			SetDebugLog($g_sAndroidEmulator & ": Cannot find installation directory")
		EndIf
		Return False
	EndIf

	If FileExists($LeapDroid_Path & "LeapdroidVM.exe") = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($LeapDroid_Path & "LeapdroidVM.exe", $COLOR_ERROR)
		Else
			SetDebugLog($g_sAndroidEmulator & ": Cannot find " & $LeapDroid_Path & "LeapdroidVM.exe")
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	Local $sPreferredADB = FindPreferredAdbPath()
	If $sPreferredADB = "" And FileExists($LeapDroid_Path & "adb.exe") = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($LeapDroid_Path & "adb.exe", $COLOR_ERROR)
			SetError(1, @extended, False)
		Else
			SetDebugLog($g_sAndroidEmulator & ": Cannot find " & $LeapDroid_Path & "adb.exe")
		EndIf
		Return False
	EndIf

	If FileExists($LeapDroid_Manage_Path) = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($LeapDroid_Manage_Path, $COLOR_ERROR)
			SetError(1, @extended, False)
		Else
			SetDebugLog($g_sAndroidEmulator & ": Cannot find " & $LeapDroid_Manage_Path)
		EndIf
		Return False
	EndIf

	; Read ADB host and Port
	Local $ops = 0
	If Not $bCheckOnly Then
		InitAndroidConfig(True) ; Restore default config

		If Not GetAndroidVMinfo($__VBoxVMinfo, $LeapDroid_Manage_Path) Then Return False
		$__VBoxGuestProperties = LaunchConsole($LeapDroid_Manage_Path, "guestproperty enumerate " & $g_sAndroidInstance, $process_killed)

		; update global variables
		$g_sAndroidProgramPath = $LeapDroid_Path & "LeapdroidVM.exe"
		$g_sAndroidAdbPath = $sPreferredADB
		If $g_sAndroidAdbPath = "" Then $g_sAndroidAdbPath = $LeapDroid_Path & "adb.exe"
		$g_sAndroidVersion = $LeapDroidVersion
		$__LeapDroid_Path = $LeapDroid_Path
		$g_sAndroidPath = $__LeapDroid_Path
		$__VBoxManage_Path = $LeapDroid_Manage_Path
		; Name: adb_port, value: 5555, timestamp: 1468752611809230200, flags:
		$aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: adb_port, value: (\d{3,5}),", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidAdbDeviceHost = "127.0.0.1"
			$g_sAndroidAdbDevicePort = $aRegExResult[0]
			If $g_bDebugAndroid Then SetDebugLog("InitLeapDroid: Read $g_sAndroidAdbDevicePort = " & $g_sAndroidAdbDevicePort, $COLOR_DEBUG)
		Else
			$oops = 1
			SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Port", $COLOR_ERROR)
		EndIf

		If $oops = 0 Then
			; Cannot get to work with tcp, using emulator device
			;$g_sAndroidAdbDevice = $g_sAndroidAdbDeviceHost & ":" & $g_sAndroidAdbDevicePort
			$g_sAndroidAdbDevice = "emulator-" & ($g_sAndroidAdbDevicePort - 1)
		Else ; use defaults
			SetLog("Using ADB default device " & $g_sAndroidAdbDevice & " for " & $g_sAndroidEmulator, $COLOR_ERROR)
		EndIf

		; get screencap paths: Name: 'picture', Host path: 'C:\Users\Administrator\Pictures\LeapDroid Photo' (machine mapping), writable
		$g_sAndroidPicturesPath = "/mnt/shared/yw_shared/"
		$aRegExResult = StringRegExp($__VBoxVMinfo, "Name: 'yw_shared', Host path: '(.*)'.*", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidPicturesHostPath = $aRegExResult[0] & "\"
		Else
			; new since 1.7.0
			; Name: 'LeapDroidShared', Host path: 'C:\Users\Administrator\AppData\Roaming\Leapdroid\shared' (machine mapping), writable
			$g_sAndroidPicturesPath = "/mnt/shared/LeapDroidShared/"
			$aRegExResult = StringRegExp($__VBoxVMinfo, "Name: 'LeapDroidShared', Host path: '(.*)'.*", $STR_REGEXPARRAYMATCH)
			If Not @error Then
				$g_sAndroidPicturesHostPath = $aRegExResult[0] & "\"
			Else
				$oops = 1
				$g_bAndroidAdbScreencap = False
				$g_sAndroidPicturesHostPath = ""
				SetLog($g_sAndroidEmulator & " Background Mode is not available", $COLOR_ERROR)
			EndIf
		EndIf

		; Android Window Title is always "Leapdroid" so add instance name
		$g_bUpdateAndroidWindowTitle = True

	EndIf

	Return SetError($oops, 0, True)

EndFunc   ;==>InitLeapDroid

Func UpdateLeapdroidSettings(ByRef $fileContent, $param, $value)

	$fileContent = StringRegExpReplace($fileContent, "^(" & $param & "=.*)", $param & "=" & $value)
	Return @extended

EndFunc   ;==>UpdateLeapdroidSettings

Func SetScreenLeapDroid()

	If Not InitAndroid() Then Return False

	Local $cmdOutput, $process_killed

	; 1.3.0 - 1.5.0 uses command line parameters -w and -Hex
	; 1.6.1 uses leapdroid.settings file in @MyDocumentsDir & "\Leapdroid\Leapdroid Emulator"
	; 1.7.0 uses leapdroid.settings file in GetLeapDroidPath() & "Leapdroid Emulator"

	Local $files[2] = [@MyDocumentsDir & "\Leapdroid\Leapdroid Emulator\leapdroid.settings", GetLeapDroidPath() & "Leapdroid Emulator\leapdroid.settings"]
	Local $f, $p, $h

	; Set width and height
	For $f In $files
		$p = StringMid($f, 1, StringInStr($f, "\", 0, -1))
		If FileExists($p) Then
			If FileExists($f) = 0 Then
				; create file
				$h = FileOpen($f, $FO_OVERWRITE)
				If $h = -1 Then
					SetLog("Cannot write " & $g_sAndroidEmulator & " config file:" & @CRLF & $f, $COLOR_ERROR)
					ContinueLoop
				EndIf
				FileWrite($h, "RESOLUTION=" & $g_iGAME_WIDTH & "x" & $g_iGAME_HEIGHT & @CRLF & "DPI=160")
				FileClose($h)
			Else
				; update file
				Local $i
				$h = FileOpen($f, $FO_READ)
				If $h = -1 Then
					SetLog("Cannot read " & $g_sAndroidEmulator & " config file:" & @CRLF & $f, $COLOR_ERROR)
					ContinueLoop
				EndIf
				Local $s = FileRead($h)
				FileClose($h)
				$i = UpdateLeapdroidSettings($s, "RESOLUTION", $g_iGAME_WIDTH & "x" & $g_iGAME_HEIGHT)
				If $i < 1 Then SetDebugLog("Cannot update " & $g_sAndroidEmulator & " screen resolution in file:" & @CRLF & $f, $COLOR_ERROR)
				$i = UpdateLeapdroidSettings($s, "DPI", "160")
				If $i < 1 Then SetDebugLog("Cannot update " & $g_sAndroidEmulator & " screen DPI in file:" & @CRLF & $f, $COLOR_ERROR)
				$h = FileOpen($f, $FO_OVERWRITE)
				If $h = -1 Then
					SetLog("Cannot write " & $g_sAndroidEmulator & " config file:" & @CRLF & $f, $COLOR_ERROR)
					ContinueLoop
				EndIf
				FileWrite($h, $s)
				FileClose($h)
			EndIf
		EndIf
	Next

	#cs
		$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " resolution_width " & $g_iAndroidClientWidth, $process_killed)
		$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " resolution_height " & $g_iAndroidClientHeight, $process_killed)
		$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " is_full_screen 0", $process_killed)
		$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " is_customed_resolution 1", $process_killed)
		; Set dpi
		$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_dpi 160", $process_killed)
	#ce
	Return True

EndFunc   ;==>SetScreenLeapDroid

Func RebootLeapDroidSetScreen()

	Return RebootAndroidSetScreenDefault()

EndFunc   ;==>RebootLeapDroidSetScreen

Func CloseLeapDroid()

	Return CloseVboxAndroidSvc()

EndFunc   ;==>CloseLeapDroid

Func CheckScreenLeapDroid($bSetLog = True)

	If Not InitAndroid() Then Return False

	#cs
		Local $aValues[4][2] = [ _
		["is_full_screen", "0"], _
		["vbox_dpi", "160"], _
		["resolution_height", $g_iAndroidClientHeight], _
		["resolution_width", $g_iAndroidClientWidth] _
		]
		Local $i, $Value, $iErrCnt = 0, $process_killed, $aRegExResult

		For $i = 0 To UBound($aValues) - 1
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
	#ce
	Return True

EndFunc   ;==>CheckScreenLeapDroid

Func HideLeapDroidWindow($bHide = True, $hHWndAfter = Default)
	Return EmbedLeapDroid($bHide, $hHWndAfter)
EndFunc   ;==>HideLeapDroidWindow

Func EmbedLeapDroid($bEmbed = Default, $hHWndAfter = Default)

	If $bEmbed = Default Then $bEmbed = $g_bAndroidEmbedded
	If $hHWndAfter = Default Then $hHWndAfter = $HWND_TOPMOST

	; Find QTool Parent Window
	Local $aWin = _WinAPI_EnumProcessWindows(GetAndroidPid(), False)
	Local $i
	Local $hToolbar = 0

	For $i = 1 To UBound($aWin) - 1
		Local $h = $aWin[$i][0]
		Local $c = $aWin[$i][1]
		If $c = "QTool" Then
			$hToolbar = $h
			ExitLoop
		EndIf
	Next

	If $hToolbar = 0 Then
		SetDebugLog("EmbedLeapDroid(" & $bEmbed & "): QTool Window not found, list of windows:" & $c, Default, True)
		For $i = 1 To UBound($aWin) - 1
			Local $h = $aWin[$i][0]
			Local $c = $aWin[$i][1]
			SetDebugLog("EmbedLeapDroid(" & $bEmbed & "): Handle = " & $h & ", Class = " & $c, Default, True)
		Next
	Else
		SetDebugLog("EmbedLeapDroid(" & $bEmbed & "): $hToolbar=" & $hToolbar, Default, True)
		If $bEmbed Then WinMove2($hToolbar, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
		_WinAPI_ShowWindow($hToolbar, ($bEmbed ? @SW_HIDE : @SW_SHOWNOACTIVATE))
		If Not $bEmbed Then
			WinMove2($hToolbar, "", -1, -1, -1, -1, $hHWndAfter, 0, False)
			If $hHWndAfter = $HWND_TOPMOST Then WinMove2($hToolbar, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
		EndIf
	EndIf

EndFunc   ;==>EmbedLeapDroid

Func LeapDroidBotStartEvent()
	; it's required to close the system bar as Android System messages are otherwise some pixels more top and bot doesn't detect correctly
	Return AndroidCloseSystemBar()
EndFunc   ;==>LeapDroidBotStartEvent

Func LeapDroidBotStopEvent()
	;Zygote restart causes CoC restart :( that's why it not used and normal opensysbar started to crash in 1.8.0 in Dec 2016... so disabled for now
	;Return AndroidOpenSystemBar(True)
EndFunc   ;==>LeapDroidBotStopEvent
