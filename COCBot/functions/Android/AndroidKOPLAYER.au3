; #FUNCTION# ====================================================================================================================
; Name ..........: OpenKOPLAYER
; Description ...: Opens new KOPLAYER instance
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (04-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenKOPLAYER($bRestart = False)

	Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdPar

	SetLog("Starting " & $g_sAndroidEmulator & " and Clash Of Clans", $COLOR_GREEN)

	If Not InitAndroid() Then Return

	Local $launchAndroid = (WinGetAndroidHandle() = 0 ? True : False)
	If $launchAndroid Then
		; Launch KOPLAYER
		$cmdPar = GetAndroidProgramParameter() & " -t " & $g_sAndroidInstance
		$PID = LaunchAndroid($g_sAndroidProgramPath, $cmdPar, $g_sAndroidPath)
		If $PID = 0 Then
			SetError(1, 1, -1)
			Return False
		EndIf
	EndIf

	$hTimer = __TimerInit()

	; Test ADB is connected
	$connected_to = ConnectAndroidAdb(False, 60 * 1000)
	If Not $g_bRunState Then Return

	If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec - __TimerDiff($hTimer) / 1000, $hTimer) Then Return

	If __TimerDiff($hTimer) >= $g_iAndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
		SetLog("Serious error has occurred, please restart PC and try again", $COLOR_RED)
		SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_RED)
		SetError(1, @extended, False)
		Return
	EndIf

	SetLog($g_sAndroidEmulator & " Loaded, took " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_GREEN)

EndFunc   ;==>OpenKOPLAYER

Func GetKOPLAYERProgramParameter($bAlternative = False)
	Local $bVer2 = (GetVersionNormalized($g_sAndroidVersion) >= GetVersionNormalized("2.0"))
	If $bVer2 Then
		If Not $bAlternative Or $g_sAndroidInstance <> $g_avAndroidAppConfig[$g_iAndroidConfig][1] Then
			; should be launched with these parameter
			Local $s = ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance)
			Local $i = StringInStr($s, "_", 0, -1)
			If $i > 0 Then
				$i = StringMid($s, $i + 1)
			EndIf
			Return "-n " & $i
		EndIf
		; default instance gets launched as name "default" but vbox instance name is KOPLAYER (this is the alternative way)
		Return "-n 0"
	Else
		If Not $bAlternative Or $g_sAndroidInstance <> $g_avAndroidAppConfig[$g_iAndroidConfig][1] Then
			; should be launched with these parameter
			Return "-n " & ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance)
		EndIf
		; default instance gets launched as name "default" but vbox instance name is KOPLAYER (this is the alternative way)
		Return "-n default"
	EndIf
EndFunc   ;==>GetKOPLAYERProgramParameter

Func IsKOPLAYERCommandLine($CommandLine)
	SetDebugLog("IsKOPLAYERCommandLine: " & $CommandLine)
	Local $param1 = GetKOPLAYERProgramParameter()
	Local $param2 = GetKOPLAYERProgramParameter(True)
	If StringInStr($CommandLine, $param1 & " ") > 0 Or StringRight($CommandLine, StringLen($param1)) = $param1 Then Return True
	If StringInStr($CommandLine, $param2 & " ") > 0 Or StringRight($CommandLine, StringLen($param2)) = $param2 Then Return True
	If $g_sAndroidInstance = "KOPLAYER" And StringStripWS($CommandLine, 3) = $g_sAndroidProgramPath Then Return True
	Return False
EndFunc   ;==>IsKOPLAYERCommandLine

Func GetKOPLAYERPath()
	Local $KOPLAYER_Path = RegRead($g_sHKLM & "\SOFTWARE\KOPLAYER\SETUP\", "InstallPath")
	If $KOPLAYER_Path = "" Then ; work-a-round
		$KOPLAYER_Path = @ProgramFilesDir & "\KOPLAYER\"
	Else
		If StringRight($KOPLAYER_Path, 1) <> "\" Then $KOPLAYER_Path &= "\"
	EndIf
	Return StringReplace($KOPLAYER_Path, "\\", "\")
EndFunc   ;==>GetKOPLAYERPath

Func GetKOPLAYERAdbPath()
	Local $adbPath = GetKOPLAYERPath() & "Tools\adb.exe"
	If FileExists($adbPath) Then Return $adbPath
	Return ""
EndFunc   ;==>GetKOPLAYERAdbPath

Func InitKOPLAYER($bCheckOnly = False)
	Local $process_killed, $aRegExResult, $g_sAndroidAdbDeviceHost, $g_sAndroidAdbDevicePort, $oops = 0
	Local $KOPLAYERVersion = RegRead($g_sHKLM & "\SOFTWARE\KOPLAYER\SETUP\", "Version")
	SetError(0, 0, 0)
	; Could also read KOPLAYER paths from environment variables KOPLAYER_Path and KOPLAYERHyperv_Path
	Local $KOPLAYER_Path = GetKOPLAYERPath()
	Local $KOPLAYER_Manage_Path = $KOPLAYER_Path & "vbox\VBoxManage.exe"

	If FileExists($KOPLAYER_Path & "KOPLAYER.exe") = False Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_RED)
			SetLog($KOPLAYER_Path & "KOPLAYER.exe", $COLOR_RED)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	Local $sPreferredADB = FindPreferredAdbPath()
	If $sPreferredADB = "" And FileExists(GetKOPLAYERAdbPath()) = False Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_RED)
			SetLog($KOPLAYER_Path & "adb.exe", $COLOR_RED)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	If FileExists($KOPLAYER_Manage_Path) = False Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find KOPLAYER-VBoxManage:", $COLOR_RED)
			SetLog($KOPLAYER_Manage_Path, $COLOR_RED)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	; Read ADB host and Port
	If Not $bCheckOnly Then
		InitAndroidConfig(True) ; Restore default config

		If Not GetAndroidVMinfo($__VBoxVMinfo, $KOPLAYER_Manage_Path) Then Return False
		; update global variables
		$g_sAndroidProgramPath = $KOPLAYER_Path & "KOPLAYER.exe"
		$g_sAndroidAdbPath = $sPreferredADB
		If $g_sAndroidAdbPath = "" Then $g_sAndroidAdbPath = GetKOPLAYERAdbPath()
		$g_sAndroidVersion = $KOPLAYERVersion
		$__KOPLAYER_Path = $KOPLAYER_Path
		$g_sAndroidPath = $__KOPLAYER_Path
		$__VBoxManage_Path = $KOPLAYER_Manage_Path
		$aRegExResult = StringRegExp($__VBoxVMinfo, "name = .*host ip = ([^,]*),.*guest port = 5555", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidAdbDeviceHost = $aRegExResult[0]
			If $g_sAndroidAdbDeviceHost = "" Then $g_sAndroidAdbDeviceHost = "127.0.0.1"
			If $g_bDebugAndroid Then SetDebugLog("Func LaunchConsole: Read $g_sAndroidAdbDeviceHost = " & $g_sAndroidAdbDeviceHost, $COLOR_PURPLE)
		Else
			$oops = 1
			SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Host", $COLOR_RED)
		EndIf

		$aRegExResult = StringRegExp($__VBoxVMinfo, "name = .*host port = (\d{3,5}),.*guest port = 5555", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidAdbDevicePort = $aRegExResult[0]
			If $g_bDebugAndroid Then SetDebugLog("Func LaunchConsole: Read $g_sAndroidAdbDevicePort = " & $g_sAndroidAdbDevicePort, $COLOR_PURPLE)
		Else
			$oops = 1
			SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Port", $COLOR_RED)
		EndIf

		If $oops = 0 Then
			$g_sAndroidAdbDevice = $g_sAndroidAdbDeviceHost & ":" & $g_sAndroidAdbDevicePort
		Else ; use defaults
			SetLog("Using ADB default device " & $g_sAndroidAdbDevice & " for " & $g_sAndroidEmulator, $COLOR_RED)
		EndIf

		; get screencap paths: Name: 'picture', Host path: 'C:\Users\Administrator\Pictures\KOPLAYER Photo' (machine mapping), writable
		$g_sAndroidPicturesPath = "/mnt/shared/UserData/"
		$g_sAndroidSharedFolderName = "UserData"
		ConfigureSharedFolder(0) ; something like C:\Users\Administrator\AppData\Local\KOPLAYERData\UserData\

	EndIf

	Return True

EndFunc   ;==>InitKOPLAYER

Func GetKOPLAYERBackgroundMode()
	Local $aRegExResult = StringRegExp($__VBoxExtraData, "Key: GUI/RenderMode, Value: (.*)", $STR_REGEXPARRAYMATCH)
	Local $sRenderMode = "Unknown"
	If Not @error Then
		$sRenderMode = $aRegExResult[0]
		Switch $sRenderMode
			Case "DirectX", "DirectXPlus"
				Return $g_iAndroidBackgroundModeDirectX
			Case "Opengl", "OpenglPlus"
				Return $g_iAndroidBackgroundModeOpenGL
			Case Else
				SetLog($g_sAndroidEmulator & " unsupported Render Mode " & $sRenderMode, $COLOR_WARNING)
		EndSwitch
	EndIf
	Return 0
EndFunc   ;==>GetKOPLAYERBackgroundMode

Func SetScreenKOPLAYER()

	If Not InitAndroid() Then Return False

	Local $cmdOutput, $process_killed

	; Set width and height
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_graph_mode " & $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight & "-16", $process_killed)
	; Set dpi
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_dpi 160", $process_killed)
	; Since version 2.0
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "setextradata " & $g_sAndroidInstance & " RenderWindowProp " & $g_iAndroidClientWidth & "*" & $g_iAndroidClientHeight & "*160", $process_killed)

	ConfigureSharedFolder(1, True)
	ConfigureSharedFolder(2, True)

	Return True

EndFunc   ;==>SetScreenKOPLAYER

Func RebootKOPLAYERSetScreen()

	Return RebootAndroidSetScreenDefault()

EndFunc   ;==>RebootKOPLAYERSetScreen

Func CloseKOPLAYER()

	Return CloseVboxAndroidSvc()

EndFunc   ;==>CloseKOPLAYER

Func CheckScreenKOPLAYER($bSetLog = True)

	If Not InitAndroid() Then Return False
	Local $bVer2 = (GetVersionNormalized($g_sAndroidVersion) >= GetVersionNormalized("2.0"))

	Local $aValues[2][2] = [ _
			["vbox_dpi", "160"], _
			["vbox_graph_mode", $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight & "-16"] _
			]
	If $bVer2 Then
		Local $aValues[1][2] = [ _
				["RenderWindowProp", $g_iAndroidClientWidth & "*" & $g_iAndroidClientHeight & "*160"] _
				]
	EndIf
	Local $i, $Value, $iErrCnt = 0, $process_killed, $aRegExResult

	For $i = 0 To UBound($aValues) - 1
		If $bVer2 Then
			$aRegExResult = StringRegExp($__VBoxExtraData, "Key: " & $aValues[$i][0] & ", Value: (.+)", $STR_REGEXPARRAYMATCH)
		Else
			$aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: " & $aValues[$i][0] & ", value: (.+), timestamp:", $STR_REGEXPARRAYMATCH)
		EndIf
		If @error = 0 Then $Value = $aRegExResult[0]
		If $Value <> $aValues[$i][1] Then
			If $iErrCnt = 0 Then
				If $bSetLog Then
					SetLog("MyBot doesn't work with " & $g_sAndroidEmulator & " screen configuration!", $COLOR_RED)
				Else
					SetDebugLog("MyBot doesn't work with " & $g_sAndroidEmulator & " screen configuration!", $COLOR_RED)
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

	; check if shared folder exists
	If ConfigureSharedFolder(1, $bSetLog) Then $iErrCnt += 1

	If $iErrCnt > 0 Then Return False
	Return True

EndFunc   ;==>CheckScreenKOPLAYER

Func HideKOPLAYERWindow($bHide = True, $hHWndAfter = Default)
	Return EmbedKOPLAYER($bHide, $hHWndAfter)
EndFunc   ;==>HideKOPLAYERWindow

Func EmbedKOPLAYER($bEmbed = Default, $hHWndAfter = Default)

	If $bEmbed = Default Then $bEmbed = $g_bAndroidEmbedded
	If $hHWndAfter = Default Then $hHWndAfter = $HWND_TOPMOST

	; Find Qt5QWindowToolSaveBits Window
	Local $aWin = _WinAPI_EnumProcessWindows(GetAndroidPid(), False)
	Local $i
	Local $hToolbar = 0

	For $i = 1 To UBound($aWin) - 1
		Local $h = $aWin[$i][0]
		Local $c = $aWin[$i][1]
		If $c = "Qt5QWindowToolSaveBits" Then
			$hToolbar = $h
			ExitLoop
		EndIf
	Next

	If $hToolbar = 0 Then
		SetDebugLog("EmbedKOPLAYER(" & $bEmbed & "): Qt5QWindowToolSaveBits Window not found, list of windows:" & $c, Default, True)
		For $i = 1 To UBound($aWin) - 1
			Local $h = $aWin[$i][0]
			Local $c = $aWin[$i][1]
			SetDebugLog("EmbedKOPLAYER(" & $bEmbed & "): Handle = " & $h & ", Class = " & $c, Default, True)
		Next
	Else
		SetDebugLog("EmbedKOPLAYER(" & $bEmbed & "): $hToolbar=" & $hToolbar, Default, True)
		If $bEmbed Then WinMove2($hToolbar, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
		_WinAPI_ShowWindow($hToolbar, ($bEmbed ? @SW_HIDE : @SW_SHOWNOACTIVATE))
		If Not $bEmbed Then
			WinMove2($hToolbar, "", -1, -1, -1, -1, $hHWndAfter, 0, False)
			If $hHWndAfter = $HWND_TOPMOST Then WinMove2($hToolbar, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
		EndIf
	EndIf

EndFunc   ;==>EmbedKOPLAYER
