; #FUNCTION# ====================================================================================================================
; Name ..........: iTools AVM implementation
; Description ...: Handles iTools open, close and configuration etc. http://pro.itools.cn/simulate/
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpeniTools($bRestart = False)

	Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdPar

	SetLog("Starting " & $g_sAndroidEmulator & " and Clash Of Clans", $COLOR_SUCCESS)

	Local $launchAndroid = (WinGetAndroidHandle() = 0 ? True : False)
	If $launchAndroid Then
		; Launch iTools
		$cmdPar = GetAndroidProgramParameter()
		$PID = LaunchAndroid($g_sAndroidProgramPath, $cmdPar, $g_sAndroidPath)
		If $PID = 0 Then
			SetError(1, 1, -1)
			Return False
		EndIf
	EndIf

	$hTimer = __TimerInit()

	; Test ADB is connected
	$connected_to = ConnectAndroidAdb(False, 60 * 1000)
	If Not $g_bRunState Then Return False

	; Wait for boot completed
	If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec - __TimerDiff($hTimer) / 1000, $hTimer) Then Return False

	If __TimerDiff($hTimer) >= $g_iAndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
		SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
		SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_ERROR)
		SetError(1, @extended, False)
		Return False
	EndIf

	SetLog($g_sAndroidEmulator & " Loaded, took " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_SUCCESS)

	Return True

EndFunc   ;==>OpeniTools

Func IsiToolsCommandLine($CommandLine)
	SetDebugLog("Check iTools command line instance: " & $CommandLine)
	Local $sInstance = ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance)
	$CommandLine = StringReplace($CommandLine, GetiToolsPath(), "")
	If StringRegExp($CommandLine, "/start " & $sInstance & "\b") = 1 Then Return True
	If StringRegExp($CommandLine, "/restart .*\b" & $sInstance & "\b") = 1 Then Return True
	Return False
EndFunc   ;==>IsiToolsCommandLine

Func GetiToolsProgramParameter($bAlternative = False)
	Local $sInstance = ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance)
	If Not $bAlternative Or $g_sAndroidInstance <> $g_avAndroidAppConfig[$g_iAndroidConfig][1] Then
		; should be launched with these parameter
		Return "/start " & $sInstance
	EndIf
	; default instance gets launched when no parameter was specified (this is the alternative way)
	Return ""
EndFunc   ;==>GetiToolsProgramParameter

Func GetiToolsPath()
	Local $iTools_Path = "" ;RegRead($g_sHKLM & "\SOFTWARE\iTools\iTools VM\", "InstallDir")
	If $iTools_Path <> "" And FileExists($iTools_Path & "\iToolsAVM.exe") = 0 Then
		$iTools_Path = ""
	EndIf
	Local $InstallLocation = ""
	Local $DisplayIcon = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\iToolsAVM\", "DisplayIcon")
	If @error = 0 Then
		Local $iLastBS = StringInStr($DisplayIcon, "\", 0, -1) - 1
		$InstallLocation = StringLeft($DisplayIcon, $iLastBS)
	EndIf
	If $iTools_Path = "" And FileExists($InstallLocation & "\iToolsAVM.exe") = 1 Then
		$iTools_Path = $InstallLocation
	EndIf
	If $iTools_Path = "" And FileExists(@ProgramFilesDir & "\iToolsAVM\iToolsAVM.exe") = 1 Then
		$iTools_Path = @ProgramFilesDir & "\iToolsAVM"
	EndIf
	SetError(0, 0, 0)
	If $iTools_Path <> "" And StringRight($iTools_Path, 1) <> "\" Then $iTools_Path &= "\"
	Return StringReplace($iTools_Path, "\\", "\")
EndFunc   ;==>GetiToolsPath

Func GetiToolsAdbPath()
	Local $adbPath = GetiToolsPath() & "tools\adb.exe"
	If FileExists($adbPath) Then Return $adbPath
	Return ""
EndFunc   ;==>GetiToolsAdbPath

Func InitiTools($bCheckOnly = False)
	Local $process_killed, $aRegExResult, $g_sAndroidAdbDeviceHost, $g_sAndroidAdbDevicePort, $oops = 0
	;Local $iToolsVersion = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\iTools\", "DisplayVersion")
	SetError(0, 0, 0)

	Local $VirtualBox_Path = RegRead($g_sHKLM & "\SOFTWARE\Oracle\VirtualBox\", "InstallDir")
	If @error <> 0 And FileExists(@ProgramFilesDir & "\Oracle\VirtualBox\") Then
		$VirtualBox_Path = @ProgramFilesDir & "\Oracle\VirtualBox\"
		SetError(0, 0, 0)
	EndIf
	$VirtualBox_Path = StringReplace($VirtualBox_Path, "\\", "\")

	Local $iTools_Path = GetiToolsPath()
	Local $iTools_Manage_Path = $VirtualBox_Path & "VBoxManage.exe"

	If FileExists($iTools_Path) = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator, $COLOR_ERROR)
			SetLog("installation directory", $COLOR_ERROR)
			SetError(1, @extended, False)
		Else
			SetDebugLog($g_sAndroidEmulator & ": Cannot find installation directory")
		EndIf
		Return False
	EndIf

	If FileExists($iTools_Path & "iToolsAVM.exe") = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($iTools_Path & "iToolsAVM.exe", $COLOR_ERROR)
		Else
			SetDebugLog($g_sAndroidEmulator & ": Cannot find " & $iTools_Path & "iToolsAVM.exe")
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	Local $sPreferredADB = FindPreferredAdbPath()
	If $sPreferredADB = "" And FileExists($iTools_Path & "tools\adb.exe") = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($iTools_Path & "tools\adb.exe", $COLOR_ERROR)
			SetError(1, @extended, False)
		Else
			SetDebugLog($g_sAndroidEmulator & ": Cannot find " & $iTools_Path & "tools\adb.exe")
		EndIf
		Return False
	EndIf

	If FileExists($iTools_Manage_Path) = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($iTools_Manage_Path, $COLOR_ERROR)
			SetError(1, @extended, False)
		Else
			SetDebugLog($g_sAndroidEmulator & ": Cannot find " & $iTools_Manage_Path)
		EndIf
		Return False
	EndIf

	; Read ADB host and Port
	Local $ops = 0
	If Not $bCheckOnly Then
		InitAndroidConfig(True) ; Restore default config

		If Not GetAndroidVMinfo($__VBoxVMinfo, $iTools_Manage_Path) Then Return False
		; update global variables
		$g_sAndroidProgramPath = $iTools_Path & "iToolsAVM.exe"
		$g_sAndroidAdbPath = $sPreferredADB
		If $g_sAndroidAdbPath = "" Then $g_sAndroidAdbPath = $iTools_Path & "tools\adb.exe"
		$g_sAndroidVersion = ""
		; read Android Program Details
		Local $pAndroidFileVersionInfo
		If _WinAPI_GetFileVersionInfo($g_sAndroidProgramPath, $pAndroidFileVersionInfo) Then
			$g_avAndroidProgramFileVersionInfo = _WinAPI_VerQueryValue($pAndroidFileVersionInfo, "FileVersion")
			If UBound($g_avAndroidProgramFileVersionInfo) > 1 Then $g_sAndroidVersion = $g_avAndroidProgramFileVersionInfo[1][1]
		EndIf
		$__iTools_Path = $iTools_Path
		$g_sAndroidPath = $__iTools_Path
		$__VBoxManage_Path = $iTools_Manage_Path

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

		; get screencap paths: Name: 'picture', Host path: 'C:\Users\Administrator\Pictures\iTools Photo' (machine mapping), writable
		$g_sAndroidPicturesPath = "/mnt/shared/picture/"
		$g_sAndroidSharedFolderName = "picture"
		ConfigureSharedFolder(0) ; something like C:\Users\Administrator\Pictures\iTools Photo\

		; Android Window Title is always "iTools" so add instance name
		$g_bUpdateAndroidWindowTitle = True

	EndIf

	Return SetError($oops, 0, True)

EndFunc   ;==>InitiTools

Func SetScreeniTools()

	If Not $g_bRunState Then Return False
	If Not InitAndroid() Then Return False

	Local $cmdOutput, $process_killed

	; Set width and height
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_graph_mode " & $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight & "-16", $process_killed)

	; Set dpi
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_dpi 160", $process_killed)

	;vboxmanage sharedfolder add droid4x --name picture --hostpath "C:\Users\Administrator\Pictures\Droid4X Photo" --automount
	ConfigureSharedFolder(1, True)
	ConfigureSharedFolder(2, True)

	Return True

EndFunc   ;==>SetScreeniTools

Func RebootiToolsSetScreen()

	Return RebootAndroidSetScreenDefault()

EndFunc   ;==>RebootiToolsSetScreen

Func CloseiTools()

	Return CloseVboxAndroidSvc()

EndFunc   ;==>CloseiTools

Func CheckScreeniTools($bSetLog = True)

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
				SetGuiLog("MyBot doesn't work with " & $g_sAndroidEmulator & " screen configuration!", $COLOR_ERROR, $bSetLog)
			EndIf
			SetGuiLog("Setting of " & $aValues[$i][0] & " is " & $Value & " and will be changed to " & $aValues[$i][1], $COLOR_ERROR, $bSetLog)
			$iErrCnt += 1
		EndIf
	Next

	If $iErrCnt > 0 Then Return False

	; check if shared folder exists
	If ConfigureSharedFolder(1, $bSetLog) Then $iErrCnt += 1

	If $iErrCnt > 0 Then Return False
	Return True

EndFunc   ;==>CheckScreeniTools

Func HideiToolsWindow($bHide = True, $hHWndAfter = Default)
	Return EmbediTools($bHide, $hHWndAfter)
EndFunc   ;==>HideiToolsWindow

Func EmbediTools($bEmbed = Default, $hHWndAfter = Default)

	If $bEmbed = Default Then $bEmbed = $g_bAndroidEmbedded
	If $hHWndAfter = Default Then $hHWndAfter = $HWND_TOPMOST

	; Find QTool Parent Window
	Local $aWin = _WinAPI_EnumProcessWindows(GetAndroidPid(), False)
	Local $i
	Local $hToolbar = 0
	Local $hAddition = []

	For $i = 1 To UBound($aWin) - 1
		Local $h = $aWin[$i][0]
		Local $c = $aWin[$i][1]
		If $c = "CHWindow" Then
			Local $aPos = WinGetPos($h)
			If UBound($aPos) > 2 Then
				If ($aPos[2] = 38 Or $aPos[2] = 21) Then
					; found toolbar
					$hToolbar = $h
				EndIf
				If $aPos[2] = 10 Or $aPos[3] = 10 Then
					; found additional window to hide
					ReDim $hAddition[UBound($hAddition) + 1]
					$hAddition[UBound($hAddition) - 1] = $h
				EndIf
			EndIf
		EndIf
	Next

	If $hToolbar = 0 Then
		SetDebugLog("EmbediTools(" & $bEmbed & "): toolbar Window not found, list of windows:" & $c, Default, True)
		For $i = 1 To UBound($aWin) - 1
			Local $h = $aWin[$i][0]
			Local $c = $aWin[$i][1]
			SetDebugLog("EmbediTools(" & $bEmbed & "): Handle = " & $h & ", Class = " & $c, Default, True)
		Next
	Else
		SetDebugLog("EmbediTools(" & $bEmbed & "): $hToolbar=" & $hToolbar, Default, True)
		If $bEmbed Then WinMove2($hToolbar, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
		_WinAPI_ShowWindow($hToolbar, ($bEmbed ? @SW_HIDE : @SW_SHOWNOACTIVATE))
		If Not $bEmbed Then
			WinMove2($hToolbar, "", -1, -1, -1, -1, $hHWndAfter, 0, False)
			If $hHWndAfter = $HWND_TOPMOST Then WinMove2($hToolbar, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
		EndIf
		For $i = 0 To UBound($hAddition) - 1
			If $bEmbed Then WinMove2($hAddition[$i], "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
			_WinAPI_ShowWindow($hAddition[$i], ($bEmbed ? @SW_HIDE : @SW_SHOWNOACTIVATE))
			If Not $bEmbed Then
				WinMove2($hAddition[$i], "", -1, -1, -1, -1, $hHWndAfter, 0, False)
				If $hHWndAfter = $HWND_TOPMOST Then WinMove2($hAddition[$i], "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
			EndIf
		Next
	EndIf

EndFunc   ;==>EmbediTools
