; #FUNCTION# ====================================================================================================================
; Name ..........: LeadDroid implementation
; Description ...: Handles LeapDroid open, close and configuration etc. http://www.leapdroid.com/
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (2016-07)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenLeapDroid($bRestart = False)

	Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdPar

	SetLog("Starting " & $Android & " and Clash Of Clans", $COLOR_SUCCESS)

	$launchAndroid = WinGetAndroidHandle() = 0
	If $launchAndroid Then
		; Launch LeapDroid
		$cmdPar = GetAndroidProgramParameter()
		SetDebugLog("ShellExecute: " & $AndroidProgramPath & " " & $cmdPar)
		$PID = ShellExecute($AndroidProgramPath, $cmdPar, $__LeapDroid_Path)
		If _Sleep(1000) Then Return False
		If $PID <> 0 Then $PID = ProcessExists($PID)
		SetDebugLog("$PID= " & $PID)
		If $PID = 0 Then ; IF ShellExecute failed
			SetLog("Unable to load " & $Android & ($AndroidInstance = "" ? "" : "(" & $AndroidInstance & ")") & ", please check emulator/installation.", $COLOR_ERROR)
			SetLog("Unable to continue........", $COLOR_WARNING)
			btnStop()
			SetError(1, 1, -1)
			Return False
		EndIf
	EndIf

	SetLog("Please wait while " & $Android & " and CoC start...", $COLOR_SUCCESS)
	$hTimer = TimerInit()

	; Test ADB is connected
	$connected_to = ConnectAndroidAdb(False, 60 * 1000)
	If Not $RunState Then Return False

	; Wair for finishing boot
	If WaitForAndroidBootCompleted($AndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return False

	If TimerDiff($hTimer) >= $AndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
		SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
		SetLog($Android & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_ERROR)
		SetError(1, @extended, False)
		Return False
	EndIf

	SetLog($Android & " Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_SUCCESS)

	Return True

EndFunc   ;==>OpenLeapDroid

Func IsLeapDroidCommandLine($CommandLine)
	SetDebugLog("Check LeapDroid command line instance: " & $CommandLine)
	Local $sInstance = ($AndroidInstance = "" ? $AndroidAppConfig[$AndroidConfig][1] : $AndroidInstance)
	$CommandLine = StringReplace($CommandLine, GetLeapDroidPath(), "")
	If StringRegExp($CommandLine, "-s " & $sInstance & "\b") = 1 Then Return True
	Return False
EndFunc   ;==>IsLeapDroidCommandLine

Func GetLeapDroidProgramParameter($bAlternative = False)
	Local $sInstance = ($AndroidInstance = "" ? $AndroidAppConfig[$AndroidConfig][1] : $AndroidInstance)
	If Not $bAlternative Or $AndroidInstance <> $AndroidAppConfig[$AndroidConfig][1] Then
		; should be launched with these parameter
		Return "-vfiber -novtcheck -w " & $AndroidClientWidth & " -h " & $AndroidClientHeight & " -s " & $sInstance
	EndIf
	; default instance gets launched when no parameter was specified (this is the alternative way)
	Return "-s " & $sInstance
EndFunc   ;==>GetLeapDroidProgramParameter

Func GetLeapDroidPath()
	Local $LeapDroid_Path = RegRead($HKLM & "\SOFTWARE\Leapdroid\Leapdroid VM\", "InstallDir")
	If $LeapDroid_Path <> "" And FileExists($LeapDroid_Path & "\LeapdroidVM.exe") = 0 Then
		$LeapDroid_Path = ""
	EndIf
	; pre 1.5.0
	Local $InstallLocation = RegRead($HKLM & "\SOFTWARE" & $Wow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\LeapdroidVM\", "InstallLocation")
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

Func InitLeapDroid($bCheckOnly = False)
	Local $process_killed, $aRegExResult, $AndroidAdbDeviceHost, $AndroidAdbDevicePort, $oops = 0
	Local $LeapDroidVersion = RegRead($HKLM & "\SOFTWARE" & $Wow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\LeapDroid\", "DisplayVersion")
	SetError(0, 0, 0)
	; Could also read LeapDroid paths from environment variables LeapDroid_Path and LeapDroidHyperv_Path
	Local $LeapDroid_Path = GetLeapDroidPath()
	Local $LeapDroid_Manage_Path = GetLeapDroidPath() & "VBoxManage.exe"

	If FileExists($LeapDroid_Path) = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $Android, $COLOR_ERROR)
			SetLog("installation directory", $COLOR_ERROR)
			SetError(1, @extended, False)
		Else
			SetDebugLog($Android & ": Cannot find installation directory")
		EndIf
		Return False
	EndIf

	If FileExists($LeapDroid_Path & "LeapdroidVM.exe") = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $Android & ":", $COLOR_ERROR)
			SetLog($LeapDroid_Path & "LeapdroidVM.exe", $COLOR_ERROR)
		Else
			SetDebugLog($Android & ": Cannot find " & $LeapDroid_Path & "LeapdroidVM.exe")
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	If FileExists($LeapDroid_Path & "adb.exe") = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $Android & ":", $COLOR_ERROR)
			SetLog($LeapDroid_Path & "adb.exe", $COLOR_ERROR)
			SetError(1, @extended, False)
		Else
			SetDebugLog($Android & ": Cannot find " & $LeapDroid_Path & "adb.exe")
		EndIf
		Return False
	EndIf

	If FileExists($LeapDroid_Manage_Path) = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $Android & ":", $COLOR_ERROR)
			SetLog($LeapDroid_Manage_Path, $COLOR_ERROR)
			SetError(1, @extended, False)
		Else
			SetDebugLog($Android & ": Cannot find " & $LeapDroid_Manage_Path)
		EndIf
		Return False
	EndIf

	; Read ADB host and Port
	Local $ops = 0
	If Not $bCheckOnly Then
		InitAndroidConfig(True) ; Restore default config

		$__VBoxVMinfo = LaunchConsole($LeapDroid_Manage_Path, "showvminfo " & $AndroidInstance, $process_killed)
		; check if instance is known
		If StringInStr($__VBoxVMinfo, "Could not find a registered machine named") > 0 Then
			; Unknown vm
			SetLog("Cannot find " & $Android & " instance " & $AndroidInstance, $COLOR_ERROR)
			Return False
		EndIf
		$__VBoxGuestProperties = LaunchConsole($LeapDroid_Manage_Path, "guestproperty enumerate " & $AndroidInstance, $process_killed)

		; update global variables
		$AndroidProgramPath = $LeapDroid_Path & "LeapdroidVM.exe"
		$AndroidAdbPath = FindPreferredAdbPath()
		If $AndroidAdbPath = "" Then $AndroidAdbPath = $LeapDroid_Path & "adb.exe"
		$AndroidVersion = $LeapDroidVersion
		$__LeapDroid_Path = $LeapDroid_Path
		$__VBoxManage_Path = $LeapDroid_Manage_Path
		; Name: adb_port, value: 5555, timestamp: 1468752611809230200, flags:
		$aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: adb_port, value: (\d{3,5}),", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$AndroidAdbDeviceHost = "127.0.0.1"
			$AndroidAdbDevicePort = $aRegExResult[0]
			If $debugSetlog = 1 Then Setlog("InitLeapDroid: Read $AndroidAdbDevicePort = " & $AndroidAdbDevicePort, $COLOR_DEBUG)
		Else
			$oops = 1
			SetLog("Cannot read " & $Android & "(" & $AndroidInstance & ") ADB Device Port", $COLOR_ERROR)
		EndIf

		If $oops = 0 Then
			; Cannot get to work with tcp, using emulator device
			;$AndroidAdbDevice = $AndroidAdbDeviceHost & ":" & $AndroidAdbDevicePort
			$AndroidAdbDevice = "emulator-" & ($AndroidAdbDevicePort - 1)
		Else ; use defaults
			SetLog("Using ADB default device " & $AndroidAdbDevice & " for " & $Android, $COLOR_ERROR)
		EndIf

		; get screencap paths: Name: 'picture', Host path: 'C:\Users\Administrator\Pictures\LeapDroid Photo' (machine mapping), writable
		$AndroidPicturesPath = "/mnt/shared/yw_shared/"
		$aRegExResult = StringRegExp($__VBoxVMinfo, "Name: 'yw_shared', Host path: '(.*)'.*", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$AndroidPicturesHostPath = $aRegExResult[0] & "\"
		Else
			; new since 1.7.0
			; Name: 'LeapDroidShared', Host path: 'C:\Users\Administrator\AppData\Roaming\Leapdroid\shared' (machine mapping), writable
			$AndroidPicturesPath = "/mnt/shared/LeapDroidShared/"
			$aRegExResult = StringRegExp($__VBoxVMinfo, "Name: 'LeapDroidShared', Host path: '(.*)'.*", $STR_REGEXPARRAYMATCH)
			If Not @error Then
				$AndroidPicturesHostPath = $aRegExResult[0] & "\"
			Else
				$oops = 1
				$AndroidAdbScreencap = False
				$AndroidPicturesHostPath = ""
				SetLog($Android & " Background Mode is not available", $COLOR_ERROR)
			EndIf
		EndIf

		; Android Window Title is always "Leapdroid" so add instance name
		$UpdateAndroidWindowTitle = True

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
	For $f in $files
		$p = StringMid($f, 1, StringInStr($f, "\", 0, -1))
		If FileExists($p) Then
			If FileExists($f) = 0 Then
				; create file
				$h = FileOpen($f, $FO_OVERWRITE)
				If $h = -1 Then
					SetLog("Cannot write " & $Android & " config file:" & @CRLF & $f, $COLOR_ERROR)
					ContinueLoop
				EndIf
				FileWrite($h, "RESOLUTION=" & $GAME_WIDTH & "x" & $GAME_HEIGHT & @CRLF & "DPI=160")
				FileClose($h)
			Else
				; update file
				Local $i
				$h = FileOpen($f, $FO_READ)
				If $h = -1 Then
					SetLog("Cannot read " & $Android & " config file:" & @CRLF & $f, $COLOR_ERROR)
					ContinueLoop
				EndIf
				Local $s = FileRead($h)
				FileClose($h)
				$i = UpdateLeapdroidSettings($s, "RESOLUTION", $GAME_WIDTH & "x" & $GAME_HEIGHT)
				If $i < 1 Then SetDebugLog("Cannot update " & $Android & " screen resolution in file:" & @CRLF & $f, $COLOR_ERROR)
				$i = UpdateLeapdroidSettings($s, "DPI", "160")
				If $i < 1 Then SetDebugLog("Cannot update " & $Android & " screen DPI in file:" & @CRLF & $f, $COLOR_ERROR)
				$h = FileOpen($f, $FO_OVERWRITE)
				If $h = -1 Then
					SetLog("Cannot write " & $Android & " config file:" & @CRLF & $f, $COLOR_ERROR)
					ContinueLoop
				EndIf
				FileWrite($h, $s)
				FileClose($h)
			EndIf
		EndIf
	Next

	#cs
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " resolution_width " & $AndroidClientWidth, $process_killed)
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " resolution_height " & $AndroidClientHeight, $process_killed)
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " is_full_screen 0", $process_killed)
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " is_customed_resolution 1", $process_killed)
	; Set dpi
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " vbox_dpi 160", $process_killed)
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
			["resolution_height", $AndroidClientHeight], _
			["resolution_width", $AndroidClientWidth] _
			]
	Local $i, $Value, $iErrCnt = 0, $process_killed, $aRegExResult

	For $i = 0 To UBound($aValues) - 1
		$aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: " & $aValues[$i][0] & ", value: (.+), timestamp:", $STR_REGEXPARRAYMATCH)
		If @error = 0 Then $Value = $aRegExResult[0]
		If $Value <> $aValues[$i][1] Then
			If $iErrCnt = 0 Then
				If $bSetLog Then
					SetLog("MyBot doesn't work with " & $Android & " screen configuration!", $COLOR_ERROR)
				Else
					SetDebugLog("MyBot doesn't work with " & $Android & " screen configuration!", $COLOR_ERROR)
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

Func EmbedLeapDroid($bEmbed = Default)

	If $bEmbed = Default Then $bEmbed = $AndroidEmbedded

	; Find QTool Parent Window
	Local $aWin = _WinAPI_EnumProcessWindows(GetAndroidPid(), False)
	Local $i
	Local $hQTool = 0

	For $i = 1 To UBound($aWin) - 1
		Local $h = $aWin[$i][0]
		Local $c = $aWin[$i][1]
		If $c = "QTool" Then
			$hQTool = $h
			ExitLoop
		EndIf
	Next

	If $hQTool = 0 Then
		SetDebugLog("EmbedLeapDroid(" & $bEmbed & "): QTool Window not found, list of windows:" & $c, Default, True)
		For $i = 1 To UBound($aWin) - 1
			Local $h = $aWin[$i][0]
			Local $c = $aWin[$i][1]
			SetDebugLog("EmbedLeapDroid(" & $bEmbed & "): Handle = " & $h & ", Class = " & $c, Default, True)
		Next
	Else
		SetDebugLog("EmbedLeapDroid(" & $bEmbed & "): $hQTool=" & $hQTool, Default, True)
		WinMove2($hQTool, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
		_WinAPI_ShowWindow($hQTool, ($bEmbed ? @SW_HIDE : @SW_SHOWNOACTIVATE))
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
