; #FUNCTION# ====================================================================================================================
; Name ..........: OpenDroid4X
; Description ...: Opens new Droid4X instance
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (12-2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenDroid4X($bRestart = False)

	Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $launchAndroid, $cmdPar

	SetLog("Starting " & $g_sAndroidEmulator & " and Clash Of Clans", $COLOR_SUCCESS)

	$launchAndroid = WinGetAndroidHandle() = 0
	If $launchAndroid Then
		; TODO as Droid4X crashes quite often, check if vm ist not running in background...
		; Launch Droid4X
		$cmdPar = GetAndroidProgramParameter()
		$PID = LaunchAndroid($g_sAndroidProgramPath, $cmdPar, $g_sAndroidPath)
		If $PID = 0 Then
			SetError(1, 1, -1)
			Return False
		EndIf
	EndIf

	; Test ADB is connected
	$connected_to = ConnectAndroidAdb(False, 60 * 1000)
	If Not $g_bRunState Then Return False

	SetLog("Please wait while " & $g_sAndroidEmulator & " and CoC start...", $COLOR_SUCCESS)
	$hTimer = __TimerInit()
	; Wait for device
	;$cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " wait-for-device", $process_killed, 60 * 1000)
	;If Not $g_bRunState Then Return

	; Wair for Activity Manager
	If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec - __TimerDiff($hTimer) / 1000, $hTimer) Then Return False

	; Wait for UI Control, then CoC can be launched
	;While Not IsArray(ControlGetPos($g_sAndroidTitle, $g_sAppPaneName, $g_sAppClassInstance)) And __TimerDiff($hTimer) <= $g_iAndroidLaunchWaitSec * 1000
	;  If _Sleep(500) Then Return
	;WEnd

	If Not $g_bRunState Then Return False
	If __TimerDiff($hTimer) >= $g_iAndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
		SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
		SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_ERROR)
		SetError(1, @extended, False)
		Return False
	EndIf

	SetLog($g_sAndroidEmulator & " Loaded, took " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_SUCCESS)
	Return True

EndFunc   ;==>OpenDroid4X

Func GetDroid4XProgramParameter($bAlternative = False)
	If Not $bAlternative Or $g_sAndroidInstance <> $g_avAndroidAppConfig[$g_iAndroidConfig][1] Then
		; should be launched with these parameter
		Return "-o " & ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance)
	EndIf
	; default instance gets launched when no parameter was specified (this is the alternative way)
	Return ""
EndFunc   ;==>GetDroid4XProgramParameter

Func GetDroid4XPath()
	Local $droid4xPath = RegRead($g_sHKLM & "\SOFTWARE\Droid4X\", "InstallDir") ; Doesn't exist (yet)
	If @error <> 0 Then ; work-a-round
		Local $DisplayIcon = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\Droid4X\", "DisplayIcon")
		If @error = 0 Then
			Local $iLastBS = StringInStr($DisplayIcon, "\", 0, -1)
			$droid4xPath = StringLeft($DisplayIcon, $iLastBS)
		EndIf
	EndIf
	If @error <> 0 Then
		$droid4xPath = @ProgramFilesDir & "\Droid4X\"
		SetError(0, 0, 0)
	EndIf
	Return StringReplace($droid4xPath, "\\", "\")
EndFunc   ;==>GetDroid4XPath

Func GetDroid4XAdbPath()
	Local $adbPath = GetDroid4XPath() & "adb.exe"
	If FileExists($adbPath) Then Return $adbPath
	Return ""
EndFunc   ;==>GetDroid4XAdbPath

Func GetDroid4XBackgroundMode()
	; Only OpenGL is supported up to version 0.10.6 Beta
	Return $g_iAndroidBackgroundModeOpenGL
EndFunc   ;==>GetDroid4XBackgroundMode

Func InitDroid4X($bCheckOnly = False)
	Local $process_killed, $aRegExResult, $VirtualBox_Path, $g_sAndroidAdbDeviceHost, $g_sAndroidAdbDevicePort, $oops = 0

	$__Droid4X_Version = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\Droid4X\", "DisplayVersion")
	$__Droid4X_Path = GetDroid4XPath()

	$VirtualBox_Path = RegRead($g_sHKLM & "\SOFTWARE\Oracle\VirtualBox\", "InstallDir")
	If @error <> 0 Then
		$VirtualBox_Path = @ProgramFilesDir & "\Oracle\VirtualBox\"
		SetError(0, 0, 0)
	EndIf
	$VirtualBox_Path = StringReplace($VirtualBox_Path, "\\", "\")

	If FileExists($__Droid4X_Path & "Droid4X.exe") = False Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($__Droid4X_Path & "Droid4X.exe", $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	Local $sPreferredADB = FindPreferredAdbPath()
	If $sPreferredADB = "" And FileExists($__Droid4X_Path & "adb.exe") = False Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($__Droid4X_Path & "adb.exe", $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	If FileExists($VirtualBox_Path & "VBoxManage.exe") = False Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find VirtualBox:", $COLOR_ERROR)
			SetLog($VirtualBox_Path & "VBoxManage.exe", $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	; Read ADB host and Port
	If Not $bCheckOnly Then
		InitAndroidConfig(True) ; Restore default config

		$__VBoxManage_Path = $VirtualBox_Path & "VBoxManage.exe"
		If Not GetAndroidVMinfo($__VBoxVMinfo, $__VBoxManage_Path) Then Return False
		$aRegExResult = StringRegExp($__VBoxVMinfo, "ADB_PORT.*host ip = ([^,]+),", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidAdbDeviceHost = $aRegExResult[0]
			If $g_bDebugAndroid Then SetDebugLog("Func LaunchConsole: Read $g_sAndroidAdbDeviceHost = " & $g_sAndroidAdbDeviceHost, $COLOR_DEBUG)
		Else
			$oops = 1
			SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Host", $COLOR_ERROR)
		EndIf

		$aRegExResult = StringRegExp($__VBoxVMinfo, "ADB_PORT.*host port = (\d{3,5}),", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidAdbDevicePort = $aRegExResult[0]
			If $g_bDebugAndroid Then SetDebugLog("Func LaunchConsole: Read $g_sAndroidAdbDevicePort = " & $g_sAndroidAdbDevicePort, $COLOR_DEBUG)
		Else
			$oops = 1
			SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Port", $COLOR_ERROR)
		EndIf

		If $oops = 0 Then
			$g_sAndroidAdbDevice = $g_sAndroidAdbDeviceHost & ":" & $g_sAndroidAdbDevicePort
		Else ; use defaults
			SetLog("Using ADB default device " & $g_sAndroidAdbDevice & " for " & $g_sAndroidEmulator, $COLOR_ERROR)
		EndIf
		; update global variables
		$g_sAndroidProgramPath = $__Droid4X_Path & "Droid4X.exe"
		$g_sAndroidPath = $__Droid4X_Path
		$g_sAndroidAdbPath = $sPreferredADB
		If $g_sAndroidAdbPath = "" Then $g_sAndroidAdbPath = $__Droid4X_Path & "adb.exe"
		$g_sAndroidVersion = $__Droid4X_Version
		; Update Window Title if instance has been configured
		If $g_sAndroidInstance = "" Or StringCompare($g_sAndroidInstance, $g_avAndroidAppConfig[$g_iAndroidConfig][1]) = 0 Then
			; Default title, nothing to do
		Else
			; Update title (only if not updated yet)
			If $g_sAndroidTitle = $g_avAndroidAppConfig[$g_iAndroidConfig][2] Then
				$g_sAndroidTitle = StringReplace($g_avAndroidAppConfig[$g_iAndroidConfig][2], "Droid4X", $g_sAndroidInstance)
			EndIf
		EndIf

		; get screencap paths: Name: 'picture', Host path: 'C:\Users\Administrator\Pictures\MEmu Photo' (machine mapping), writable
		; see also: VBoxManage setextradata droid4x VBoxInternal2/SharedFoldersEnableSymlinksCreate/picture 1
		$g_sAndroidPicturesPath = "/mnt/shared/picture/"
		$aRegExResult = StringRegExp($__VBoxVMinfo, "Name: 'picture', Host path: '(.*)'.*", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidPicturesHostPath = $aRegExResult[0] & "\"
			$g_bAndroidSharedFolderAvailable = True
		Else
			SetLog($g_sAndroidEmulator & " Background Mode is not available", $COLOR_ERROR)
			$g_sAndroidPicturesHostPath = ""
			$g_bAndroidAdbScreencap = False
			$g_bAndroidSharedFolderAvailable = False
		EndIf

		WinGetAndroidHandle()

		; Update Android Screen and Window
		UpdateDroid4XConfig()
	EndIf

	Return True

EndFunc   ;==>InitDroid4X

Func SetScreenDroid4X()
	If Not $g_bRunState Then Return False
	If Not InitAndroid() Then Return False

	Local $cmdOutput, $process_killed

	; Set width and height
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_graph_mode " & $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight & "-16", $process_killed)

	; Set dpi
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_dpi 160", $process_killed)

	;vboxmanage sharedfolder add droid4x --name picture --hostpath "C:\Users\Administrator\Pictures\Droid4X Photo" --automount
	AndroidPicturePathAutoConfig() ; ensure $g_sAndroidPicturesHostPath is set and exists
	If $g_bAndroidSharedFolderAvailable = False And $g_bAndroidPicturesPathAutoConfig = True And FileExists($g_sAndroidPicturesHostPath) = 1 Then
		; remove tailing backslash
		Local $path = $g_sAndroidPicturesHostPath
		If StringRight($path, 1) = "\" Then $path = StringLeft($path, StringLen($path) - 1)
		$cmdOutput = LaunchConsole($__VBoxManage_Path, "sharedfolder add " & $g_sAndroidInstance & " --name picture --hostpath """ & $path & """  --automount", $process_killed)
	EndIf

	Return True
EndFunc   ;==>SetScreenDroid4X

Func RebootDroid4XSetScreen()

	Return RebootAndroidSetScreenDefault()

EndFunc   ;==>RebootDroid4XSetScreen

Func CheckScreenDroid4X($bSetLog = True)

	If Not InitAndroid() Then Return False

	Local $aValues[2][2] = [ _
			["vbox_dpi", "160"], _
			["vbox_graph_mode", $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight & "-16"] _
			]
	Local $i, $Value, $iErrCnt = 0, $process_killed, $aRegExResult, $properties

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

	; check if shared folder exists
	If AndroidPicturePathAutoConfig(Default, Default, $bSetLog) Then $iErrCnt += 1

	Return True

EndFunc   ;==>CheckScreenDroid4X

Func UpdateDroid4XConfig()
	Return UpdateDroid4XWindowState()
EndFunc   ;==>UpdateDroid4XConfig

Func UpdateDroid4XWindowState()
	WinGetAndroidHandle()
	ControlGetPos($g_hAndroidWindow, $g_sAppPaneName, $g_sAppClassInstance)
	If @error = 1 Then
		; Window not found, nothing to do
		SetError(0, 0, 0)
		Return False
	EndIf

	Local $acw = $g_avAndroidAppConfig[$g_iAndroidConfig][5]
	Local $ach = $g_avAndroidAppConfig[$g_iAndroidConfig][6]
	Local $aww = $g_avAndroidAppConfig[$g_iAndroidConfig][7]
	Local $awh = $g_avAndroidAppConfig[$g_iAndroidConfig][8]

	Local $v = GetVersionNormalized($g_sAndroidVersion)
	For $i = 0 To UBound($__Droid4X_Window) - 1
		Local $v2 = GetVersionNormalized($__Droid4X_Window[$i][0])
		If $v >= $v2 Then
			SetDebugLog("Using Window sizes of " & $g_sAndroidEmulator & " " & $__Droid4X_Window[$i][0])
			$aww = $__Droid4X_Window[$i][1]
			$awh = $__Droid4X_Window[$i][2]
			ExitLoop
		EndIf
	Next

	Local $i
	Local $Values[4][3] = [ _
			["Screen Width", $g_iAndroidClientWidth, $g_iAndroidClientWidth], _
			["Screen Height", $g_iAndroidClientHeight, $g_iAndroidClientHeight], _
			["Window Width", $g_iAndroidWindowWidth, $g_iAndroidWindowWidth], _
			["Window Height", $g_iAndroidWindowHeight, $g_iAndroidWindowHeight] _
			]
	Local $bChanged = False, $ok = False
	$Values[0][2] = $acw
	$Values[1][2] = $ach
	$Values[2][2] = $aww
	$Values[3][2] = $awh

	$g_iAndroidClientWidth = $Values[0][2]
	$g_iAndroidClientHeight = $Values[1][2]
	$g_iAndroidWindowWidth = $Values[2][2]
	$g_iAndroidWindowHeight = $Values[3][2]

	For $i = 0 To UBound($Values) - 1
		If $Values[$i][1] <> $Values[$i][2] Then
			$bChanged = True
			SetDebugLog($g_sAndroidEmulator & " " & $Values[$i][0] & " updated from " & $Values[$i][1] & " to " & $Values[$i][2])
		EndIf
	Next

	Return $bChanged
EndFunc   ;==>UpdateDroid4XWindowState

Func CloseDroid4X()
	Return CloseVboxAndroidSvc()
EndFunc   ;==>CloseDroid4X
