; #FUNCTION# ====================================================================================================================
; Name ..........: Functions to interact with Android Window
; Description ...: This file contains the detection fucntions for the Emulator and Android version used.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (2015-12)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global Const $g_sAdbScriptsPath = $g_sLibPath & "\adb.scripts" ; ADD script and event files folder
Global $g_aiAndroidAdbClicks[1] = [-1] ; Stores clicks after KeepClicks() called, fired and emptied with ReleaseClicks()
Global $g_aiAndroidAdbStatsTotal[2][2] = [ _
   [0,0], _ ; Total of screencap duration, 0 is count, 1 is sum of durations
   [0,0] _  ; Total of click duration, 0 is count, 1 is sum of durations
]
Global $g_aiAndroidAdbStatsLast[2][12] ; Last 10 durations, 0 is sum of durations, 1 is index to oldest, 2-11 last 10 durations
$g_aiAndroidAdbStatsLast[0][0] = 0 ; screencap sum of durations
$g_aiAndroidAdbStatsLast[0][1] = -1 ; screencap index to oldest
$g_aiAndroidAdbStatsLast[1][0] = 0 ; click sum of durations
$g_aiAndroidAdbStatsLast[1][1] = -1 ; click index to oldest
Global $g_bWinGetAndroidHandleActive = False ; Prevent recursion in WinGetAndroidHandle()
Global $g_bAndroidSuspended = False ; Android window is suspended flag
Global $g_bAndroidQueueReboot = False ; Reboot Android as soon as possible
Global $g_iAndroidSuspendedTimer = 0; Android Suspended Timer

Func InitAndroidConfig($bRestart = False)
	If $bRestart = False Then
	   $g_sAndroidEmulator = $g_avAndroidAppConfig[$g_iAndroidConfig][0]
	   $g_sAndroidInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][1]
	   $Title = $g_avAndroidAppConfig[$g_iAndroidConfig][2]
	EndIf

	$g_sAppClassInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][3] ; Control Class and instance of android rendering
	$g_sAppPaneName = $g_avAndroidAppConfig[$g_iAndroidConfig][4] ; Control name of android rendering TODO check is still required
	$g_iAndroidClientWidth = $g_avAndroidAppConfig[$g_iAndroidConfig][5] ; Expected width of android rendering control
	$g_iAndroidClientHeight = $g_avAndroidAppConfig[$g_iAndroidConfig][6] ; Expected height of android rendering control
	$g_iAndroidWindowWidth = $g_avAndroidAppConfig[$g_iAndroidConfig][7] ; Expected Width of android window
	$g_iAndroidWindowHeight = $g_avAndroidAppConfig[$g_iAndroidConfig][8] ; Expected height of android window
	$g_sAndroidAdbPath = "" ; Path to executable HD-Adb.exe or adb.exe
	$g_sAndroidAdbDevice = $g_avAndroidAppConfig[$g_iAndroidConfig][10] ; full device name ADB connects to
	$g_iAndroidSupportFeature = $g_avAndroidAppConfig[$g_iAndroidConfig][11] ; 0 = Not available, 1 = Available, 2 = Available using ADB (experimental!)
	$g_sAndroidShellPrompt = $g_avAndroidAppConfig[$g_iAndroidConfig][12] ; empty string not available, '# ' for rooted and '$ ' for not rooted android
	$g_sAndroidMouseDevice = $g_avAndroidAppConfig[$g_iAndroidConfig][13] ; empty string not available, can be direct device '/dev/input/event2' or name by getevent -p
	$g_iAndroidEmbedMode = $g_avAndroidAppConfig[$g_iAndroidConfig][14] ; Android Dock Mode: -1 = Not available, 0 = Normal docking, 1 = Simulated docking
	$g_bAndroidAdbScreencap = $g_bAndroidAdbScreencapEnabled = True And BitAND($g_iAndroidSupportFeature, 2) = 2 ; Use Android ADB to capture screenshots in RGBA raw format
	$g_bAndroidAdbClick = $g_bAndroidAdbClickEnabled = True And AndroidAdbClickSupported() ; Enable Android ADB mouse click
	$g_bAndroidAdbInput = $g_bAndroidAdbInputEnabled = True And BitAND($g_iAndroidSupportFeature, 8) = 8 ; Enable Android ADB send text (CC requests)
	$g_bAndroidAdbInstance = $g_bAndroidAdbInstanceEnabled = True And BitAND($g_iAndroidSupportFeature, 16) = 16 ; Enable Android steady ADB shell instance when available
	$g_bAndroidAdbClickDrag = $g_bAndroidAdbClickDragEnabled = True And BitAND($g_iAndroidSupportFeature, 32) = 32 ; Enable Android ADB Click Drag script
	$g_bAndroidEmbed = $g_bAndroidEmbedEnabled = True And $g_iAndroidEmbedMode > -1 ; Enable Android Docking
	$g_bAndroidBackgroundLaunch = $g_bAndroidBackgroundLaunchEnabled = True ; Enabled Android Background launch using Windows Scheduled Task
	$g_bAndroidBackgroundLaunched = False ; True when Android was launched in headless mode without a window
	$g_bUpdateAndroidWindowTitle = False ; If Android has always same title (like LeapDroid) instance name will be added
	; screencap might have disabled backgroundmode
	If $g_bAndroidAdbScreencap And IsDeclared("g_hChkBackground") Then ; CS69 - not sure why this is here?  Globals are loaded first, so the GUI variable g_hChkBackground
		chkBackground()												; is never created before this line of code executed.
	EndIf
EndFunc   ;==>InitAndroidConfig

Func CleanSecureFiles($iAgeInUTCSeconds = 600)
	If $g_sAndroidPicturesHostPath = "" Then Return
	;0x84F11AA80008358DCF4C2144FE66B332A62C9CFC
	Local $aFiles = _FileListToArray($g_sAndroidPicturesHostPath, "*", $FLTA_FILES)
	If @error Then Return
	For $i = 1 To $aFiles[0]
		If StringRegExp($aFiles[$i], "[0-9A-F]{40}") = 1 Then
			Local $aTime = FileGetTime($g_sAndroidPicturesHostPath & $aFiles[$i], $FT_CREATED)
			Local $tTime = _Date_Time_EncodeFileTime($aTime[1], $aTime[2], $aTime[0], $aTime[3], $aTime[4], $aTime[5])
			Local $tLocal = _Date_Time_LocalFileTimeToFileTime($tTime)
			Local $lo = DllStructGetData($tLocal, "Lo")
			Local $hi = DllStructGetData($tLocal, "Hi")
			Local $iCreated = $hi * 0x100000000 + $lo
			$tTime = _Date_Time_EncodeFileTime(@MON, @MDAY, @YEAR, @HOUR, @MIN, @SEC)
			$tLocal = _Date_Time_LocalFileTimeToFileTime($tTime)
			$lo = DllStructGetData($tLocal, "Lo")
			$hi = DllStructGetData($tLocal, "Hi")
			Local $iNow = $hi * 0x100000000 + $lo
			If $iCreated + $iAgeInUTCSeconds * 1000 < $iNow Then
				FileDelete($g_sAndroidPicturesHostPath & $aFiles[$i])
			EndIf
		EndIf
	Next
EndFunc   ;==>CleanSecureFiles

Func GetSecureFilename($Filename)
	If BitAND($AndroidSecureFlags, 1) = 0 Then
		Return $Filename
	EndIf
	Return StringMid(_Crypt_HashData($Filename, $CALG_SHA1), 3)
EndFunc   ;==>GetSecureFilename

; Update Global Android variables based on $g_iAndroidConfig index
; Calls "Update" & $g_sAndroidEmulator & "Config()"
Func UpdateAndroidConfig($instance = Default, $emulator = Default)
	If $emulator <> Default Then
		; Update $g_iAndroidConfig
		For $i = 0 To UBound($g_avAndroidAppConfig) - 1
			If $g_avAndroidAppConfig[$i][0] = $emulator Then
				If $g_iAndroidConfig <> $i Then
					$g_iAndroidConfig = $i
					$g_sAndroidEmulator = $g_avAndroidAppConfig[$g_iAndroidConfig][0]
					SetLog("Android Emulator " & $g_sAndroidEmulator)
				EndIf
				$emulator = Default
				ExitLoop
			EndIf
		Next
	EndIf
	If $emulator <> Default Then SetLog("Unknown Android Emulator " & $emulator, $COLOR_RED)
	If $instance = "" Then $instance = Default
	If $instance = Default Then $instance = $g_avAndroidAppConfig[$g_iAndroidConfig][1]
	SetDebugLog("UpdateAndroidConfig(""" & $instance & """)")

	InitAndroidConfig()
	$g_sAndroidInstance = $instance ; Clone or instance of emulator or "" if not supported/default instance

	; update secure setting
	If BitAND($AndroidSecureFlags, 1) = 1 Then
		$g_sAndroidPicturesHostFolder = ""
	Else
		$g_sAndroidPicturesHostFolder = "mybot.run\"
	EndIf

	; validate install and initialize Android variables
	Local $Result = InitAndroid(False, False)

	SetDebugLog("UpdateAndroidConfig(""" & $instance & """) END")
	Return $Result
EndFunc   ;==>UpdateAndroidConfig

Func UpdateAndroidWindowState()
	; Android specific configurations
	Local $bChanged = Execute("Update" & $g_sAndroidEmulator & "WindowState()")
	If $bChanged = "" And @error <> 0 Then Return False ; Not implemented
	Return $bChanged
EndFunc   ;==>UpdateAndroidWindowState

Func UpdateHWnD($hWin)
	If $hWin = 0 Then
		$HWnD = 0
		$HWnDCtrl = 0
		Return False
	EndIf
	$HWnD = $hWin
	Local $hCtrl = ControlGetHandle($hWin, $g_sAppPaneName, $g_sAppClassInstance)
	If $hCtrl = 0 Then
		$HWnDCtrl = 0
		Return False
	EndIf
	Local $hWinParent = _WinAPI_GetParent($hCtrl)
	If $hWinParent = 0 Then
		$HWnDCtrl = 0
		Return False
	EndIf
	$HWnDCtrl = $hWinParent
	Return True
EndFunc   ;==>UpdateHWnD

Func WinGetAndroidHandle($bInitAndroid = Default, $bTestPid = False)
	If $bInitAndroid = Default Then $bInitAndroid = $g_bInitAndroidActive = False
	If $g_bWinGetAndroidHandleActive = True Then
		Return $HWnD
	EndIf
	$g_bWinGetAndroidHandleActive = True
	Local $currHWnD = $HWnD

	If $HWnD = 0 Or $g_bAndroidBackgroundLaunched = False Then _WinGetAndroidHandle()
	If IsHWnd($HWnD) = 1 Then
		; Android Window found
		Local $aPos = WinGetPos($HWnD)
		If IsArray($aPos) Then
			If _CheckWindowVisibility($HWnD, $aPos) Then
				SetDebugLog("Android Window '" & $Title & "' not visible, moving to position: " & $aPos[0] & ", " & $aPos[1])
				WinMove2($HWnD, "", $aPos[0], $aPos[1])
				$aPos = WinGetPos($HWnD)
			EndIf
		EndIf

		AndroidQueueReboot(False)
		If $currHWnD = 0 Or $currHWnD <> $HWnD Then
			; Restore original Android Window position
			If $g_bAndroidEmbedded = False And IsArray($aPos) = 1 And ($Hide = False Or ($aPos[0] > -30000 Or $aPos[1] > -30000)) Then
				SetDebugLog("Move Android Window '" & $Title & "' to position: " & $AndroidPosX & ", " & $AndroidPosY)
				WinMove2($HWnD, "", $AndroidPosX, $AndroidPosY)
				$aPos[0] = $AndroidPosX
				$aPos[1] = $AndroidPosY
			EndIf
			Local $instance = ($g_sAndroidInstance = "" ? "" : " (" & $g_sAndroidInstance & ")")
			SetLog($g_sAndroidEmulator & $instance & " running in window mode", $COLOR_ACTION)
			If $currHWnD <> 0 And $currHWnD <> $HWnD Then
				$g_bInitAndroid = True
				If $bInitAndroid = True Then InitAndroid(True)
			EndIf
		EndIf
		; update Android Window position
		If $g_bAndroidEmbedded = False And IsArray($aPos) = 1 Then
			Local $posX = $AndroidPosX
			Local $posY = $AndroidPosY
			$AndroidPosX = ($aPos[0] > -30000 ? $aPos[0] : $AndroidPosX)
			$AndroidPosY = ($aPos[1] > -30000 ? $aPos[1] : $AndroidPosY)
			If $posX <> $AndroidPosX Or $posY <> $AndroidPosY Then
				SetDebugLog("Updating Android Window '" & $Title & "' position: " & $AndroidPosX & ", " & $AndroidPosY)
			EndIf
			If $Hide = True And ($aPos[0] > -30000 Or $aPos[1] > -30000) Then
				; rehide Android
				WinMove2($HWnD, "", -32000, -32000)
			EndIf
		EndIf
		$g_bWinGetAndroidHandleActive = False
		Return $HWnD
	EndIf

	If $g_bAndroidBackgroundLaunch = False And $bTestPid = False Then
		; Headless mode support not enabled
		$g_bWinGetAndroidHandleActive = False
		Return $HWnD
	EndIf

	; Now check headless mode
	If $HWnD <> 0 Then
		If $HWnD = ProcessExists2($HWnD) Then
			; Android Headless process found
			;$g_bAndroidBackgroundLaunched = True
		Else
			Local $instance = ($g_sAndroidInstance = "" ? "" : " (" & $g_sAndroidInstance & ")")
			SetDebugLog($g_sAndroidEmulator & $instance & " process with PID = " & $HWnD & " not found")
			UpdateHWnD(0)
		EndIf
	EndIf

	If $HWnD = 0 Then
		If $g_sAndroidProgramPath <> "" Then
			Local $parameter = GetAndroidProgramParameter(False)
			Local $parameter2 = GetAndroidProgramParameter(True)
			Local $pid = ProcessExists2($g_sAndroidProgramPath, $parameter, 0, 0, "Is" & $g_sAndroidEmulator & "CommandLine")
			If $pid = 0 And $parameter <> $parameter2 Then
				; try alternative parameter
				$parameter = $parameter2
				$pid = ProcessExists2($g_sAndroidProgramPath, $parameter, 0, 0, "Is" & $g_sAndroidEmulator & "CommandLine")
			EndIf
			Local $commandLine = $g_sAndroidProgramPath & ($parameter = "" ? "" : " " & $parameter)
			Local $instance = ($g_sAndroidInstance = "" ? "" : " (" & $g_sAndroidInstance & ")")
			If $pid <> 0 Then
				SetDebugLog("Found " & $g_sAndroidEmulator & $instance & " process " & $pid & " ('" & $commandLine & "')")
				If $bTestPid = True Then
					$g_bWinGetAndroidHandleActive = False
					Return $pid
				EndIf
				If $g_bAndroidAdbScreencap = True And $g_bAndroidAdbClick = False And AndroidAdbClickSupported() = True Then
					SetLog("Enabled ADB Click to support background mode", $COLOR_ACTION)
					$g_bAndroidAdbClick = True
				EndIf
				If $g_bAndroidAdbClick = False Or $g_bAndroidAdbScreencap = False Then
					If $g_bAndroidQueueReboot = False Then
						SetLog("Headless Android not supported because", $COLOR_ERROR)
						Local $reason = ""
						If $g_bAndroidAdbClick = False Then $reason &= "ADB Click " & ($g_bAndroidAdbScreencap = False ? "and " : "")
						If $g_bAndroidAdbScreencap = False Then $reason &= "ADB Screencap "
						$reason &= "not available!"
						SetLog($reason, $COLOR_ERROR)
						;$HWnD = 0
						AndroidQueueReboot(True)
					EndIf
					UpdateHWnD($pid)
					If $currHWnD <> 0 And $currHWnD <> $HWnD Then
						$g_bInitAndroid = True
						If $bInitAndroid = True Then InitAndroid(True)
					EndIf
				Else
					SetLog($g_sAndroidEmulator & $instance & " running in headless mode", $COLOR_ACTION)
					UpdateHWnD($pid)
					If $currHWnD <> 0 And $currHWnD <> $HWnD Then
						$g_bInitAndroid = True
						If $bInitAndroid = True Then InitAndroid(True)
					EndIf
					$g_bAndroidBackgroundLaunched = True
				EndIf
				setAndroidPID($pid)
			Else
				SetDebugLog($g_sAndroidEmulator & $instance & " process not found")
			EndIf
		EndIf
	EndIf

	If $HWnD = 0 Then
		$g_bInitAndroid = True
		$g_bAndroidBackgroundLaunched = False
	EndIf

	$g_bWinGetAndroidHandleActive = False
	Return $HWnD

EndFunc   ;==>WinGetAndroidHandle

Func GetAndroidPid()
	Local $h = WinGetAndroidHandle(Default, True)
	If IsHWnd($h) Then Return WinGetProcess($h)
	Return $h
EndFunc   ;==>GetAndroidPid

; Find Android Window defined by $Title in WinTitleMatchMode -1 and updates $HWnD and $Title when found.
; Uses different strategies to find best matching Window.
; Returns Android Window Handle or 0 if Window not found
Func _WinGetAndroidHandle($bFindByTitle = False)
	; Default WinTitleMatchMode should be 3 (exact match)
	Local $hWin = WinGetHandle($HWnD)
	If $hWin > 0 And $hWin = $HWnD Then Return $HWnD
	; Find all controls by title and check which contains the android control (required for Nox)
	Local $i
	Local $t
	Local $ReInitAndroid = $HWnD <> 0
	SetDebugLog("Searching " & $g_sAndroidEmulator & " Window: Title = '" & $Title & "', Class = '" & $g_sAppClassInstance & "', Text = '" & $g_sAppPaneName & "'")
	Local $aWinList
	If $bFindByTitle = True Then
		$aWinList = WinList($Title)
		If $aWinList[0][0] > 0 Then
			For $i = 1 To $aWinList[0][0]
				; early exit if control exists
				$hWin = $aWinList[$i][1]
				$t = $aWinList[$i][0]
				If $Title = $t Then
					Local $hCtrl = ControlGetHandle($hWin, $g_sAppPaneName, $g_sAppClassInstance)
					If $hCtrl <> 0 Then
						SetDebugLog("Found " & $g_sAndroidEmulator & " Window '" & $t & "' (" & $hWin & ") by matching title '" & $Title & "' (#1)")
						UpdateHWnD($hWin)
						$Title = UpdateAndroidWindowTitle($HWnD, $t)
						If $ReInitAndroid = True And $g_bInitAndroid = False Then ; Only initialize Android when not currently running
							$g_bInitAndroid = True ; change window, re-initialize Android config
							InitAndroid()
						EndIf
						AndroidEmbed(False, False)
						setAndroidPID(GetAndroidPid())
						Return $hWin
					EndIf
				EndIf
			Next
		EndIf

		; search for window
		Local $iMode = Opt("WinTitleMatchMode", -1)
		$hWin = WinGetHandle($Title)
		Local $error = @error
		Opt("WinTitleMatchMode", $iMode)
		If $error = 0 Then
			; window found, check title for case insensitive match
			$t = WinGetTitle($hWin)
			If $Title = $t And ControlGetHandle($hWin, $g_sAppPaneName, $g_sAppClassInstance) <> 0 Then
				; all good, update $HWnD and exit
				If $HWnD <> $hWin Then SetDebugLog("Found " & $g_sAndroidEmulator & " Window '" & $t & "' (" & $hWin & ") by matching title '" & $Title & "' (#2)")
				UpdateHWnD($hWin)
				$Title = UpdateAndroidWindowTitle($HWnD, $t)
				If $ReInitAndroid = True And $g_bInitAndroid = False Then ; Only initialize Android when not currently running
					$g_bInitAndroid = True ; change window, re-initialize Android config
					InitAndroid()
				EndIf
				AndroidEmbed(False, False)
				setAndroidPID(GetAndroidPid())
				Return $hWin
			Else
				SetDebugLog($g_sAndroidEmulator & " Window title '" & $t & "' not matching '" & $Title & "' or control")
			EndIf
		EndIf

		; Check for multiple windows
		$iMode = Opt("WinTitleMatchMode", -1)
		$aWinList = WinList($Title)
		Opt("WinTitleMatchMode", $iMode)
		If $aWinList[0][0] = 0 Then
			SetDebugLog($g_sAndroidEmulator & " Window not found")
			If $ReInitAndroid = True Then $g_bInitAndroid = True ; no window anymore, re-initialize Android config
			UpdateHWnD(0)
			AndroidEmbed(False, False)
			Return 0
		EndIf
		SetDebugLog("Found " & $aWinList[0][0] & " possible " & $g_sAndroidEmulator & " windows by title '" & $Title & "':")
		For $i = 1 To $aWinList[0][0]
			SetDebugLog($aWinList[$i][1] & ": " & $aWinList[$i][0])
		Next
		If $g_sAndroidInstance <> "" Then
			; Check for given instance
			For $i = 1 To $aWinList[0][0]
				$t = $aWinList[$i][0]
				$hWin = $aWinList[$i][1]
				If StringRight($t, StringLen($g_sAndroidInstance)) = $g_sAndroidInstance And ControlGetHandle($hWin, $g_sAppPaneName, $g_sAppClassInstance) <> 0 Then
					; looks good, update $HWnD, $Title and exit
					SetDebugLog("Found " & $g_sAndroidEmulator & " Window '" & $t & "' (" & $hWin & ") for instance " & $g_sAndroidInstance)
					UpdateHWnD($hWin)
					$Title = UpdateAndroidWindowTitle($HWnD, $t)
					If $ReInitAndroid = True And $g_bInitAndroid = False Then ; Only initialize Android when not currently running
						$g_bInitAndroid = True ; change window, re-initialize Android config
						InitAndroid()
					EndIf
					AndroidEmbed(False, False)
					setAndroidPID(GetAndroidPid())
					Return $hWin
				EndIf
			Next
		EndIf
	EndIf
	; Check by command line
	If $g_sAndroidProgramPath <> "" Then
		Local $parameter = GetAndroidProgramParameter(False)
		Local $parameter2 = GetAndroidProgramParameter(True)
		Local $pid = ProcessExists2($g_sAndroidProgramPath, $parameter, 0, 0, "Is" & $g_sAndroidEmulator & "CommandLine")
		If $pid = 0 And $parameter <> $parameter2 Then
			; try alternative parameter
			$parameter = $parameter2
			$pid = ProcessExists2($g_sAndroidProgramPath, $parameter, 0, 0, "Is" & $g_sAndroidEmulator & "CommandLine")
		EndIf
		Local $commandLine = $g_sAndroidProgramPath & ($parameter = "" ? "" : " " & $parameter)
		If $pid <> 0 Then
			If IsArray($aWinList) = 0 Then
				Local $aWinList2 = _WinAPI_EnumProcessWindows($pid, True)
				If IsArray($aWinList2) = 1 And $aWinList2[0][0] > 0 Then
					Local $aWinList[$aWinList2[0][0] + 1][2]
					$aWinList[0][0] = $aWinList2[0][0]
					For $i = 1 To $aWinList2[0][0]
						$aWinList[$i][0] = WinGetTitle($aWinList2[$i][0])
						$aWinList[$i][1] = $aWinList2[$i][0]
					Next
				EndIf
			EndIf
			If IsArray($aWinList) = 1 Then
				For $i = 1 To $aWinList[0][0]
					$t = $aWinList[$i][0]
					$hWin = $aWinList[$i][1]
					If $pid = WinGetProcess($hWin) And ControlGetHandle($hWin, $g_sAppPaneName, $g_sAppClassInstance) <> 0 Then
						SetDebugLog("Found " & $g_sAndroidEmulator & " Window '" & $t & "' (" & $hWin & ") by PID " & $pid & " ('" & $commandLine & "')")
						UpdateHWnD($hWin)
						$Title = UpdateAndroidWindowTitle($HWnD, $t)
						If $ReInitAndroid = True And $g_bInitAndroid = False Then ; Only initialize Android when not currently running
							$g_bInitAndroid = True ; change window, re-initialize Android config
							InitAndroid()
						EndIf
						AndroidEmbed(False, False)
						setAndroidPID(GetAndroidPid())
						Return $hWin
					EndIf
				Next
			EndIf
			SetDebugLog($g_sAndroidEmulator & ($g_sAndroidInstance = "" ? "" : " (" & $g_sAndroidInstance & ")") & " Window not found for PID " & $pid)
		EndIf
	EndIf

	SetDebugLog($g_sAndroidEmulator & ($g_sAndroidInstance = "" ? "" : " (" & $g_sAndroidInstance & ")") & " Window not found in list")
	If $ReInitAndroid = True Then $g_bInitAndroid = True ; no window anymore, re-initialize Android config
	UpdateHWnD(0)
	AndroidEmbed(False, False)
	Return 0
EndFunc   ;==>_WinGetAndroidHandle

Func UpdateAndroidWindowTitle($hWin, $t)
	If $g_bUpdateAndroidWindowTitle = True And $g_sAndroidInstance <> "" And StringInStr($t, $g_sAndroidInstance) = 0 Then
		$t &= " (" & $g_sAndroidInstance & ")"
		_WinAPI_SetWindowText($hWin, $t)
	EndIf
	Return $t
EndFunc   ;==>UpdateAndroidWindowTitle

Func AndroidControlAvailable()
	If $g_bAndroidBackgroundLaunched = True Then
		Return 0
	EndIf
	Return IsArray(GetAndroidPos(True))
EndFunc   ;==>AndroidControlAvailable

Func GetAndroidSvcPid()
    Static $iAndroidSvcPid = 0 ; Android Backend Process

	If $iAndroidSvcPid <> 0 And $iAndroidSvcPid = ProcessExists2($iAndroidSvcPid) Then
		Return $iAndroidSvcPid
	EndIf

	SetError(0, 0, 0)
	Local $pid = Execute("Get" & $g_sAndroidEmulator & "SvcPid()")
	If $pid = "" And @error <> 0 Then $pid = GetVBoxAndroidSvcPid() ; Not implemented, use VBox default

	If $pid <> 0 Then
		SetDebugLog("Found " & $g_sAndroidEmulator & " Service PID = " & $pid)
	Else
		SetDebugLog("Cannot find " & $g_sAndroidEmulator & " Service PID", $COLOR_ERROR)
	EndIf
	$iAndroidSvcPid = $pid
	Return $pid
EndFunc   ;==>GetAndroidSvcPid

Func GetVBoxAndroidSvcPid()

	; find vm uuid (it's used as command line parameter)
	Local $aRegExResult = StringRegExp($__VBoxVMinfo, "UUID:\s+(.+)", $STR_REGEXPARRAYMATCH)
	Local $uuid = ""
	If Not @error Then $uuid = $aRegExResult[0]
	If StringLen($uuid) < 32 Then
		SetDebugLog("Cannot find VBox UUID", $COLOR_ERROR)
		Return 0
	EndIf

	; find process PID
	Local $pid = ProcessExists2("", $uuid, 1, 1)
	Return $pid

EndFunc   ;==>GetVBoxAndroidSvcPid

; Checks if Android is running and returns array of window handle and instance name
; $bStrictCheck = False includes "unsupported" ways of launching Android (like BlueStacks2 default launch shortcut)
Func GetAndroidRunningInstance($bStrictCheck = True)
	Local $runningInstance = Execute("Get" & $g_sAndroidEmulator & "RunningInstance(" & $bStrictCheck & ")")
	Local $i
	If $runningInstance = "" And @error <> 0 Then ; Not implemented
		Local $a[2] = [0, ""]
		SetDebugLog("GetAndroidRunningInstance: Try to find """ & $g_sAndroidProgramPath & """")
		Local $pids = ProcessesExist($g_sAndroidProgramPath, "", 1) ; find any process
		If UBound($pids) > 0 Then
			Local $currentInstance = $g_sAndroidInstance
			For $i = 0 To UBound($pids) - 1
				Local $pid = $pids[$i]
				; assume last parameter is instance
				Local $commandLine = ProcessGetCommandLine($pid)
				SetDebugLog("GetAndroidRunningInstance: Found """ & $commandLine & """ by PID=" & $pid)
				Local $lastSpace = StringInStr($commandLine, " ", 0, -1)
				If $lastSpace > 0 Then
					$g_sAndroidInstance = StringStripWS(StringMid($commandLine, $lastSpace + 1), 3)
					; Check that $g_sAndroidInstance default instance is used for ""
					If $g_sAndroidInstance = "" Then $g_sAndroidInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][1]
				EndIf
				; validate
				If WinGetAndroidHandle() <> 0 Then
					SetDebugLog("Running " & $g_sAndroidEmulator & " instance found: """ & $g_sAndroidInstance & """")
					If $a[0] = 0 Or $g_sAndroidInstance = $currentInstance Then
						$a[0] = $HWnD
						$a[1] = $g_sAndroidInstance
						If $g_sAndroidInstance = $currentInstance Then ExitLoop
					EndIf
				Else
					$g_sAndroidInstance = $currentInstance
				EndIf
			Next
		EndIf
		If $a[0] <> 0 Then SetDebugLog("Running " & $g_sAndroidEmulator & " instance is """ & $g_sAndroidInstance & """")
		Return $a
	EndIf
	Return $runningInstance
EndFunc   ;==>GetAndroidRunningInstance

; Detects first running Android Window is present based on $g_avAndroidAppConfig array sequence
Func DetectRunningAndroid()
	SetDebugLog("DetectRunningAndroid()")
	; Find running Android Emulator
	$g_bFoundRunningAndroid = False

	Local $i, $iCurrentConfig = $g_iAndroidConfig
	$g_bSilentSetLog = True
	For $i = 0 To UBound($g_avAndroidAppConfig) - 1
		$g_iAndroidConfig = $i
		$g_bInitAndroid = True
		If UpdateAndroidConfig() = True Then
			; this Android is installed
			Local $aRunning = GetAndroidRunningInstance(False)
			If $aRunning[0] = 0 Then
				; not running
			Else
				; Window is available
				$g_bFoundRunningAndroid = True
				$g_bSilentSetLog = False
				$g_bInitAndroid = True ; init Android again now
				If InitAndroid() = True Then
					SetDebugLog("Found running " & $g_sAndroidEmulator & " " & $g_sAndroidVersion)
				EndIf
				Return
			EndIf
		EndIf
	Next

	; Reset to current config
	$g_bInitAndroid = True
	$g_iAndroidConfig = $iCurrentConfig
	UpdateAndroidConfig()
	$g_bSilentSetLog = False
	SetDebugLog("Found no running Android Emulator")
EndFunc   ;==>DetectRunningAndroid

; Detects first installed Adnroid Emulator installation based on $g_avAndroidAppConfig array sequence
Func DetectInstalledAndroid()
	SetDebugLog("DetectInstalledAndroid()")
	; Find installed Android Emulator

	Local $i, $CurrentConfig = $g_iAndroidConfig
	$g_bSilentSetLog = True
	For $i = 0 To UBound($g_avAndroidAppConfig) - 1
		$g_iAndroidConfig = $i
		$g_bInitAndroid = True
		If UpdateAndroidConfig() Then
			; installed Android found
			$g_bFoundInstalledAndroid = True
			$g_bSilentSetLog = False
			SetDebugLog("Found installed " & $g_sAndroidEmulator & " " & $g_sAndroidVersion)
			Return
		EndIf
	Next

	; Reset to current config
	$g_iAndroidConfig = $CurrentConfig
	$g_bInitAndroid = True
	UpdateAndroidConfig()
	$g_bSilentSetLog = False
	SetDebugLog("Found no installed Android Emulator")
EndFunc   ;==>DetectInstalledAndroid

; Find preferred Adb Path. Priority is MEmu, Droid4X. If non found, empty string is returned.
Func FindPreferredAdbPath()
	Local $adbPath, $i
	For $i = 0 To UBound($g_avAndroidAppConfig) - 1
		$adbPath = Execute("Get" & $g_avAndroidAppConfig[$i][0] & "AdbPath()")
		If $adbPath <> "" Then Return $adbPath
	Next
	Return ""
EndFunc   ;==>FindPreferredAdbPath

Func CompareAndUpdate(ByRef $UpdateWhenDifferent, Const $New)
	Local $bDifferent = $UpdateWhenDifferent <> $New
	If $bDifferent Then	$UpdateWhenDifferent = $New
	Return $bDifferent
EndFunc

Func IncrUpdate(ByRef $i, $ReturnInitial = True)
	Local $i2 = $i
	$i += 1
	If $ReturnInitial Then Return $i2
	Return $i
EndFunc

Func InitAndroid($bCheckOnly = False, $bLogChangesOnly = True)
	If $bCheckOnly = False And $g_bInitAndroid = False Then
		;SetDebugLog("InitAndroid(" & $bCheckOnly & "): " & $g_sAndroidEmulator & " is already initialized");
		Return True
	EndIf
	$g_bInitAndroidActive = True
	Local $aPriorValues = [ _
		  $g_sAndroidEmulator _
		, $g_iAndroidConfig _
		, $g_sAndroidVersion _
		, $g_sAndroidInstance _
		, $Title _
		, $g_sAndroidProgramPath _
		, GetAndroidProgramParameter() _
		, ((IsArray($g_avAndroidProgramFileVersionInfo) ? _ArrayToString($g_avAndroidProgramFileVersionInfo, ",", 1) : "not available")) _
		, $AndroidSecureFlags _
		, $g_sAndroidAdbPath _
		, $g_sAndroidAdbDevice _
		, $g_sAndroidPicturesPath _
		, $g_sAndroidPicturesHostPath _
		, $g_sAndroidPicturesHostFolder _
		, $g_sAndroidMouseDevice _
		, $g_bAndroidAdbScreencap _
		, $g_bAndroidAdbInput _
		, $g_bAndroidAdbClick _
		, $g_bAndroidAdbClickDrag _
		, ($g_bChkBackgroundMode = True ? "enabled" : "disabled") _
		, $g_bNoFocusTampering _
	]
	SetDebugLog("InitAndroid(" & $bCheckOnly & "): " & $g_sAndroidEmulator)
	If Not $bCheckOnly Then
		; Check that $g_sAndroidInstance default instance is used for ""
		If $g_sAndroidInstance = "" Then $g_sAndroidInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][1]
	EndIf
	Local $Result = Execute("Init" & $g_sAndroidEmulator & "(" & $bCheckOnly & ")")
	If $Result = "" And @error <> 0 Then
		; Not implemented
		SetLog("Android support for " & $g_sAndroidEmulator & " is not available", $COLOR_ERROR)
	EndIf
	Local $successful = @error = 0
	If Not $bCheckOnly And $Result Then
		; read Android Program Details
		Local $pAndroidFileVersionInfo
		If _WinAPI_GetFileVersionInfo($g_sAndroidProgramPath, $pAndroidFileVersionInfo) Then
			$g_avAndroidProgramFileVersionInfo = _WinAPI_VerQueryValue($pAndroidFileVersionInfo)
		Else
			$g_avAndroidProgramFileVersionInfo = 0
		EndIf

		Local $i = 0
		Local $sText = ""
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidEmulator) Or $bLogChangesOnly = False Then SetDebugLog("Android: " & $g_sAndroidEmulator)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_iAndroidConfig) Or $bLogChangesOnly = False Then SetDebugLog("Android Config: " & $g_iAndroidConfig)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidVersion) Or $bLogChangesOnly = False Then SetDebugLog("Android Version: " & $g_sAndroidVersion)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidInstance) Or $bLogChangesOnly = False Then SetDebugLog("Android Instance: " & $g_sAndroidInstance)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $Title) Or $bLogChangesOnly = False Then SetDebugLog("Android Window Title: " & $Title)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidProgramPath) Or $bLogChangesOnly = False Then SetDebugLog("Android Program Path: " & $g_sAndroidProgramPath)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], GetAndroidProgramParameter()) Or $bLogChangesOnly = False Then SetDebugLog("Android Program Parameter: " & GetAndroidProgramParameter())
		$sText = ((IsArray($g_avAndroidProgramFileVersionInfo) ? _ArrayToString($g_avAndroidProgramFileVersionInfo, ",", 1) : "not available"))
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $sText) Or $bLogChangesOnly = False Then SetDebugLog("Android Program FileVersionInfo: " & $sText)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $AndroidSecureFlags) Or $bLogChangesOnly = False Then SetDebugLog("Android SecureME setting: " & $AndroidSecureFlags)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidAdbPath) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Path: " & $g_sAndroidAdbPath)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidAdbDevice) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Device: " & $g_sAndroidAdbDevice)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidPicturesPath) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Shared Folder: " & $g_sAndroidPicturesPath)
		; check if share folder exists
		If FileExists($g_sAndroidPicturesHostPath) Then
			If ($g_sAndroidPicturesHostFolder <> "" Or BitAND($AndroidSecureFlags, 1) = 1) Then
				DirCreate($g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder)
			EndIf
		ElseIf $g_sAndroidPicturesHostPath <> "" Then
			SetLog("Shared Folder doesn't exist, please fix:", $COLOR_ERROR)
			SetLog($g_sAndroidPicturesHostPath, $COLOR_ERROR)
		EndIf
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidPicturesHostPath) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Shared Folder on Host: " & $g_sAndroidPicturesHostPath)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidPicturesHostFolder) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Shared SubFolder: " & $g_sAndroidPicturesHostFolder)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidMouseDevice) Or $bLogChangesOnly = False Then SetDebugLog("Android Mouse Device: " & $g_sAndroidMouseDevice)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bAndroidAdbScreencap) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB screencap command enabled: " & $g_bAndroidAdbScreencap)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bAndroidAdbInput) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB input command enabled: " & $g_bAndroidAdbInput)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bAndroidAdbClick) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Mouse Click enabled: " & $g_bAndroidAdbClick)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bAndroidAdbClickDrag) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Click Drag enabled: " & $g_bAndroidAdbClickDrag)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], ($g_bChkBackgroundMode = True ? "enabled" : "disabled")) Or $bLogChangesOnly = False Then SetDebugLog("Bot Background Mode for screen capture: " & ($g_bChkBackgroundMode = True ? "enabled" : "disabled"))
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bNoFocusTampering) Or $bLogChangesOnly = False Then SetDebugLog("No Focus Tampering: " & $g_bNoFocusTampering)
		;$HWnD = WinGetHandle($Title) ;Handle for Android window
		WinGetAndroidHandle() ; Set $HWnD and $Title for Android window
		InitAndroidTimeLag()
		InitAndroidPageError()
		$g_bInitAndroid = Not $successful
	Else
		If $bCheckOnly = False Then $g_bInitAndroid = True
	EndIf
	SetDebugLog("InitAndroid(" & $bCheckOnly & "): " & $g_sAndroidEmulator & " END, initialization successful = " & $successful & ", result = " & $Result)
	$g_bInitAndroidActive = False
	Return $Result
EndFunc   ;==>InitAndroid

Func GetAndroidProgramParameter($bAlternative = False)
	Local $parameter = Execute("Get" & $g_sAndroidEmulator & "ProgramParameter(" & $bAlternative & ")")
	If $parameter = "" And @error <> 0 Then $parameter = "" ; Not implemented
	Return $parameter
EndFunc   ;==>GetAndroidProgramParameter

Func AndroidBotStartEvent()
	; restore Android Window hidden state
	reHide()

	Local $Result = Execute($g_sAndroidEmulator & "BotStartEvent()")
	If $Result = "" And @error <> 0 Then $Result = "" ; Not implemented
	Return $Result
EndFunc   ;==>AndroidBotStartEvent

Func AndroidBotStopEvent()
	Local $Result = Execute($g_sAndroidEmulator & "BotStopEvent()")
	If $Result = "" And @error <> 0 Then $Result = "" ; Not implemented
	Return $Result
EndFunc   ;==>AndroidBotStopEvent

Func OpenAndroid($bRestart = False)
    Static $OpenAndroidActive = 0

	If $OpenAndroidActive >= $g_iOpenAndroidActiveMaxTry Then
		SetLog("Cannot open " & $g_sAndroidEmulator & ", tried " & $OpenAndroidActive & " times...", $COLOR_ERROR)
		btnStop()
		Return False
	EndIf
	$OpenAndroidActive += 1
	If $OpenAndroidActive > 1 Then
		SetDebugLog("Opening " & $g_sAndroidEmulator & " recursively " & $OpenAndroidActive & ". time...")
	EndIf
	Local $Result = _OpenAndroid($bRestart)
	WinGetAndroidHandle()
	$OpenAndroidActive -= 1
	Return $Result
EndFunc   ;==>OpenAndroid

Func _OpenAndroid($bRestart = False)
	ResumeAndroid()

	; list Android devices to ensure ADB Daemon is launched
	Local $hMutex = AquireAdbDaemonMutex(), $process_killed
	LaunchConsole($g_sAndroidAdbPath, "devices", $process_killed)
	ReleaseAdbDaemonMutex($hMutex)

	If Not InitAndroid() Then
		SetLog("Unable to open " & $g_sAndroidEmulator & ($g_sAndroidInstance = "" ? "" : " instance '" & $g_sAndroidInstance & "'"), $COLOR_ERROR)
		SetLog("Please check emulator/installation", $COLOR_ERROR)
		SetLog("Unable to continue........", $COLOR_ERROR)
		btnStop()
		SetError(1, 1, -1)
		Return False
	EndIf

	AndroidAdbTerminateShellInstance()
	If Not $g_bRunState Then Return False

	; Close any existing WerFault windows for this emulator
	WerFaultClose($g_sAndroidProgramPath)

	; Close crashed android when $g_bAndroidBackgroundLaunch = False
	If $g_bAndroidBackgroundLaunch = False And WinGetAndroidHandle(Default, True) <> 0 Or GetAndroidSvcPid() <> 0 Then
		CloseAndroid("_OpenAndroid")
		If _Sleep(1000) Then Return False
	EndIf

	If Not Execute("Open" & $g_sAndroidEmulator & "(" & $bRestart & ")") Then Return False

	; Check Android screen size, position windows
	If Not InitiateLayout() Then Return False ; recursive call to OpenAndroid() possible

	WinGetAndroidHandle(False) ; get window Handle

	If Not $g_bRunState Then Return False
	; Better create a func AndroidCoCStartEvent
	AndroidBotStartEvent()

	If Not $g_bRunState Then Return False
	; Launch CcC
	If Not StartAndroidCoC() Then Return False

	If $bRestart = False Then
		waitMainScreenMini()
		If Not $g_bRunState Then Return False
		Zoomout()
	Else
		WaitMainScreenMini()
		If Not $g_bRunState Then Return False
		If @error = 1 Then
			$g_bRestart = True
			$Is_ClientSyncError = False
			Return False
		EndIf
		Zoomout()
	EndIf

	If Not $g_bRunState Then Return False
	Return True
EndFunc   ;==>_OpenAndroid

Func StartAndroidCoC()
	Return RestartAndroidCoC(False, False)
EndFunc   ;==>StartAndroidCoC

Func RestartAndroidCoC($bInitAndroid = True, $bRestart = True)
	$g_bSkipFirstZoomout = False
	ResumeAndroid()
	If Not $g_bRunState Then Return False

	If $bInitAndroid Then
		If Not InitAndroid() Then Return False
	EndIf

	Local $cmdOutput, $process_killed, $connected_to

	; Test ADB is connected
	;$cmdOutput = LaunchConsole($g_sAndroidAdbPath, "connect " & $g_sAndroidAdbDevice, $process_killed)
	;$connected_to = StringInStr($cmdOutput, "connected to")

	Local $sRestart = ""
	If $bRestart = True Then
		SetLog("Please wait for CoC restart......", $COLOR_INFO) ; Let user know we need time...
		$sRestart = "-S "
	Else
		SetLog("Launch Clash of Clans now...", $COLOR_SUCCESS)
	EndIf
	ConnectAndroidAdb()
	If Not $g_bRunState Then Return False
	;AndroidAdbTerminateShellInstance()
	If Not $g_bRunState Then Return False
	$cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " shell am start " & $sRestart & "-n " & $g_sAndroidGamePackage & "/" & $g_sAndroidGameClass, $process_killed, 30 * 1000) ; removed "-W" option and added timeout (didn't exit sometimes)
	If StringInStr($cmdOutput, "Error:") > 0 And StringInStr($cmdOutput, $g_sAndroidGamePackage) > 0 Then
		SetLog("Unable to load Clash of Clans, install/reinstall the game.", $COLOR_ERROR)
		SetLog("Unable to continue........", $COLOR_WARNING)
		btnStop()
		SetError(1, 1, -1)
		Return False
	EndIf
	If StringInStr($cmdOutput, "Exception") > 0 Then
		; some other strange, unexpected error, restart Android
		If Not RebootAndroid() Then Return False
	EndIf

	If Not IsAdbConnected($cmdOutput) Then
		If Not ConnectAndroidAdb() Then Return False
	EndIf

	If Not $g_bRunState Then Return False
	AndroidAdbLaunchShellInstance()

	Return True
EndFunc   ;==>RestartAndroidCoC

Func CloseAndroid($sSource)
	ResumeAndroid()

	SetLog("Stopping " & $g_sAndroidEmulator & "....", $COLOR_INFO)
	SetDebugLog("CloseAndroid, caller: " & $sSource)

	; Un-dock Android
	AndroidEmbed(False)

	AndroidAdbTerminateShellInstance()

	If Not $g_bRunState Then Return False

	SetLog("Please wait for full " & $g_sAndroidEmulator & " shutdown...", $COLOR_SUCCESS)
	Local $pid = GetAndroidPid()
	If ProcessExists2($pid) Then
		KillProcess($pid, "CloseAndroid")
		If _SleepStatus(1000) Then Return False
	EndIf

	; Call special Android close
	Local $Result = Execute("Close" & $g_sAndroidEmulator & "()")

	If Not $g_bRunState Then Return False
	If ProcessExists($pid) Then
		SetLog("Failed to stop " & $g_sAndroidEmulator, $COLOR_ERROR)
	Else
		SetLog($g_sAndroidEmulator & " stopped successfully", $COLOR_SUCCESS)
	EndIf

	If Not $g_bRunState Then Return False
	RemoveGhostTrayIcons() ; Remove ghost icon if left behind

EndFunc   ;==>CloseAndroid

Func CloseVboxAndroidSvc()
	Local $process_killed
	If Not $g_bRunState Then Return
	; stop virtualbox instance
	LaunchConsole($__VBoxManage_Path, "controlvm " & $g_sAndroidInstance & " poweroff", $process_killed, 30000)
	If _SleepStatus(3000) Then Return
EndFunc   ;==>CloseVboxAndroidSvc

Func CheckAndroidRunning($bQuickCheck = True, $bStartIfRequired = True)
	Local $hWin = $HWnD
	If WinGetAndroidHandle() = 0 Or ($bQuickCheck = False And $g_bAndroidBackgroundLaunched = False And AndroidControlAvailable() = 0) Then
		SetDebugLog($g_sAndroidEmulator & " not running")
		If $bStartIfRequired = True Then
			If $hWin = 0 Then
				OpenAndroid(True)
			Else
				RebootAndroid()
			EndIf
		EndIf
		Return False
	EndIf
	Return True
EndFunc   ;==>CheckAndroidRunning

Func SetScreenAndroid()
	ResumeAndroid()
	If Not $g_bRunState Then Return False
	; Set Android screen size and dpi
	SetLog("Set " & $g_sAndroidEmulator & " screen resolution to " & $g_iAndroidClientWidth & " x " & $g_iAndroidClientHeight, $COLOR_INFO)
	Local $Result = Execute("SetScreen" & $g_sAndroidEmulator & "()")
	If $Result Then
		SetLog("A restart of your computer might be required", $COLOR_ACTION)
		SetLog("for the applied changes to take effect.", $COLOR_ACTION)
	EndIf
	Return $Result
EndFunc   ;==>SetScreenAndroid

Func CloseUnsupportedAndroid()
	ResumeAndroid()
	If Not $g_bRunState Then Return False
	SetError(0, 0, 0)
	Local $Closed = Execute("CloseUnsupported" & $g_sAndroidEmulator & "()")
	If $Closed = "" And @error <> 0 Then Return False ; Not implemented
	Return $Closed
EndFunc   ;==>CloseUnsupportedAndroid

Func RebootAndroidSetScreen()
	ResumeAndroid()
	If Not $g_bRunState Then Return False
	Return Execute("Reboot" & $g_sAndroidEmulator & "SetScreen()")
EndFunc   ;==>RebootAndroidSetScreen

Func IsAdbTCP()
	Return StringInStr($g_sAndroidAdbDevice, ":") > 0
EndFunc   ;==>IsAdbTCP

Func WaitForRunningVMS($WaitInSec = 120, $hTimer = 0)
	ResumeAndroid()
	If Not $g_bRunState Then Return True
	Local $cmdOutput, $connected_to, $running, $process_killed, $hMyTimer
	$hMyTimer = ($hTimer = 0 ? TimerInit() : $hTimer)
	While True
		If Not $g_bRunState Then Return True
		$cmdOutput = LaunchConsole($__VBoxManage_Path, "list runningvms", $process_killed)
		If Not $g_bRunState Then Return True
		$running = StringInStr($cmdOutput, """" & $g_sAndroidInstance & """") > 0
		If $running = True Then ExitLoop
		If $hTimer <> 0 Then _StatusUpdateTime($hTimer)
		_Sleep(3000) ; Sleep 3 Seconds
		If TimerDiff($hMyTimer) > $WaitInSec * 1000 Then ; if no device available in 4 minutes, Android/PC has major issue so exit
			SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
			SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for boot completed", $COLOR_ERROR)
			SetError(1, @extended, False)
			Return True
		EndIf
	WEnd
	Return False
EndFunc   ;==>WaitForRunningVMS

Func WaitForAndroidBootCompleted($WaitInSec = 120, $hTimer = 0)
	ResumeAndroid()
	If Not $g_bRunState Then Return True
	Local $cmdOutput, $connected_to, $booted, $process_killed, $hMyTimer
	; Wait for boot completed
	$hMyTimer = ($hTimer = 0 ? TimerInit() : $hTimer)
	While True
		If Not $g_bRunState Then Return True
		$cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " shell getprop sys.boot_completed", $process_killed)
		If Not $g_bRunState Then Return True
		; Test ADB is connected
		$connected_to = IsAdbConnected($cmdOutput)
		If Not $g_bRunState Then Return True
		If Not $connected_to Then ConnectAndroidAdb(False)
		If Not $g_bRunState Then Return True
		$booted = StringLeft($cmdOutput, 1) = "1"
		If $booted = True Then ExitLoop
		If $hTimer <> 0 Then _StatusUpdateTime($hTimer)
		If _Sleep(3000) Then Return True ; Sleep 3 Seconds
		If TimerDiff($hMyTimer) > $WaitInSec * 1000 Then ; if no device available in 4 minutes, Android/PC has major issue so exit
			SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
			SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for boot completed", $COLOR_ERROR)
			SetError(1, @extended, False)
			Return True
		EndIf
	WEnd
	Return False
EndFunc   ;==>WaitForAndroidBootCompleted

Func IsAdbConnected($cmdOutput = Default)
	ResumeAndroid()
	If $__TEST_ERROR_ADB_DEVICE_NOT_FOUND Then Return False
	Local $process_killed, $connected_to
	If $cmdOutput = Default Then
		If IsAdbTCP() Then
			$cmdOutput = LaunchConsole($g_sAndroidAdbPath, "connect " & $g_sAndroidAdbDevice, $process_killed)
			$connected_to = StringInStr($cmdOutput, "connected to") > 0
			If $connected_to Then
				; also check whoami
				$cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " shell whoami", $process_killed)
				$connected_to = StringInStr($cmdOutput, "device ") = 0 And $process_killed = False
			EndIf
		Else
			$cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " shell whoami", $process_killed)
			$connected_to = StringInStr($cmdOutput, " not ") = 0 And $process_killed = False
		EndIf
	Else
		; $cmdOutput was specified
		$connected_to = StringInStr($cmdOutput, " not ") = 0
	EndIf
	Return $connected_to
EndFunc   ;==>IsAdbConnected

Func AquireAdbDaemonMutex($timout = 30000)
	Local $timer = TimerInit()
	Local $g_hMutex_MyBot = 0
	While $g_hMutex_MyBot = 0 And TimerDiff($timer) < $timout
		$g_hMutex_MyBot = _Singleton("MyBot.run/AdbDaemonLaunch", 1)
		If $g_hMutex_MyBot <> 0 Then ExitLoop
		If _Sleep(250) Then ExitLoop
	WEnd
	Return $g_hMutex_MyBot
EndFunc   ;==>AquireAdbDaemonMutex

Func ReleaseAdbDaemonMutex($hMutex, $ReturnValue = Default)
	_WinAPI_CloseHandle($hMutex)
	If $ReturnValue = Default Then Return
	Return $ReturnValue
EndFunc   ;==>ReleaseAdbDaemonMutex

Func ConnectAndroidAdb($rebootAndroidIfNeccessary = $g_bRunState, $timeout = 15000)
	If $g_sAndroidAdbPath = "" Or FileExists($g_sAndroidAdbPath) = 0 Then
		SetLog($g_sAndroidEmulator & " ADB Path not valid: " & $g_sAndroidAdbPath, $COLOR_ERROR)
		Return False
	EndIf
	ResumeAndroid()

	; check if Android is running
	If $rebootAndroidIfNeccessary = True Then
		WinGetAndroidHandle()
		If AndroidInvalidState() Then
			; Android is not running
			SetDebugLog("ConnectAndroidAdb: Reboot Android as it's not running")
			RebootAndroid()
		EndIf
	EndIf

	Local $hMutex = AquireAdbDaemonMutex()

	Local $process_killed, $cmdOutput
	Local $connected_to = False
	Local $timer = TimerInit()
	Local $timerReInit = $timer
	While TimerDiff($timer) < $timeout ; wait max 15 Seconds before killing ADB daemon
		$connected_to = IsAdbConnected()
		If $connected_to Then Return ReleaseAdbDaemonMutex($hMutex, True) ; all good, adb is connected
		Local $ms = $timeout - TimerDiff($timer)
		If $ms > 3000 Then $ms = 3000
		If _Sleep($ms) Then Return ReleaseAdbDaemonMutex($hMutex, False) ; True ; interrupted and return True not to start any failback logic
		If TimerDiff($timerReInit) >= 10000 Then
			$timerReInit = TimerInit()
			$g_bInitAndroid = True ; Re-Initialize Android as during start running config might have changed
			InitAndroid()
		EndIf
	WEnd

	Switch $g_iAndroidRecoverStrategy
		Case 0
			; not connected... strange, kill any Adb now
			SetDebugLog("Stop ADB daemon!", $COLOR_ERROR)
			LaunchConsole($g_sAndroidAdbPath, "kill-server", $process_killed)
			Local $pids = ProcessesExist($g_sAndroidAdbPath, "", 1)
			For $i = 0 To UBound($pids) - 1
				KillProcess($pids[$i], $g_sAndroidAdbPath)
			Next

			; ok, now try to connect again
			$connected_to = IsAdbConnected()
			ReleaseAdbDaemonMutex($hMutex)

			If Not $connected_to And $g_bRunState = True And $rebootAndroidIfNeccessary = True Then
				; not good, what to do now? Reboot Android...
				SetLog("ADB cannot connect to " & $g_sAndroidEmulator & ", restart emulator now...", $COLOR_ERROR)
				If Not RebootAndroid() Then Return False
				; ok, last try
				$connected_to = ConnectAndroidAdb(False)
				If Not $connected_to Then
					; Let's give up...
					If Not $g_bRunState Then Return False ; True ; interrupted and return True not to start any failback logic
					SetLog("ADB really cannot connect to " & $g_sAndroidEmulator & "!", $COLOR_ERROR)
					SetLog("Please restart bot, emulator and/or PC...", $COLOR_ERROR)
				EndIf
			EndIf
		Case 1
			ReleaseAdbDaemonMutex($hMutex)
			If $rebootAndroidIfNeccessary Then
				SetDebugLog("ConnectAndroidAdb: Reboot Android due to ADB connection problems...", $COLOR_ERROR)
				If Not RebootAndroid() Then Return False
			Else
				SetDebugLog("ConnectAndroidAdb: Reboot Android nor ADB Daemon not allowed", $COLOR_ERROR)
				Return False
			EndIf

			; ok, now try to connect again
			$connected_to = IsAdbConnected()

			If Not $connected_to Then
				; not connected... strange, kill any Adb now
				SetDebugLog("Stop ADB daemon!", $COLOR_ERROR)
				LaunchConsole($g_sAndroidAdbPath, "kill-server", $process_killed)
				Local $pids = ProcessesExist($g_sAndroidAdbPath, "", 1)
				For $i = 0 To UBound($pids) - 1
					KillProcess($pids[$i], $g_sAndroidAdbPath)
				Next

				; ok, last try
				$connected_to = ConnectAndroidAdb(False)
				If Not $connected_to Then
					; Let's give up...
					If Not $g_bRunState Then Return False ; True ; interrupted and return True not to start any failback logic
					SetLog("ADB really cannot connect to " & $g_sAndroidEmulator & "!", $COLOR_ERROR)
					SetLog("Please restart bot, emulator and/or PC...", $COLOR_ERROR)
				EndIf
			EndIf
	EndSwitch

	Return $connected_to ; ADB is connected or not
EndFunc   ;==>ConnectAndroidAdb

Func RebootAndroid($bRestart = True)
	ResumeAndroid()
	If Not $g_bRunState Then Return False

	; Close Android
	If CloseUnsupportedAndroid() Then
		; Unsupport Emulator now closed, screen config is now adjusted
	Else
		; Close Emulator
		CloseAndroid("RebootAndroid")
	EndIf
	If _Sleep(1000) Then Return False

	; Start Android
	Return OpenAndroid($bRestart)
EndFunc   ;==>RebootAndroid

Func RebootAndroidSetScreenDefault()
	ResumeAndroid()
	If Not $g_bRunState Then Return False

	; Set font size to normal
	AndroidSetFontSizeNormal()
	If Not $g_bRunState Then Return False

	; Close Android
	CloseAndroid("RebootAndroidSetScreenDefault")
	If _Sleep(1000) Then Return False

	SetScreenAndroid()
	If Not $g_bRunState Then Return False

	; Start Android
	Return OpenAndroid(True)

EndFunc   ;==>RebootAndroidSetScreenDefault

Func CheckScreenAndroid($ClientWidth, $ClientHeight, $bSetLog = True)
	ResumeAndroid()
	If Not $g_bRunState Then Return True

	AndroidAdbLaunchShellInstance()
	If Not $g_bRunState Then Return True

	Local $AndroidWinPos = WinGetPos($HWnD)
	If IsArray($AndroidWinPos) = 1 Then
		Local $WinWidth = $AndroidWinPos[2]
		Local $WinHeight = $AndroidWinPos[3]
		If $WinWidth <> $g_iAndroidWindowWidth Or $WinHeight <> $g_iAndroidWindowHeight Then
			SetDebugLog("CheckScreenAndroid: Window size " & $WinWidth & " x " & $WinHeight & " <> " & $g_iAndroidWindowWidth & " x " & $g_iAndroidWindowHeight, $COLOR_ERROR)
		Else
			SetDebugLog("CheckScreenAndroid: Window size " & $WinWidth & " x " & $WinHeight)
		EndIf
	EndIf

	Local $ok = ($ClientWidth = $g_iAndroidClientWidth) And ($ClientHeight = $g_iAndroidClientHeight)
	If Not $ok Then
		If $bSetLog Then SetLog("MyBot doesn't work with " & $g_sAndroidEmulator & " screen resolution of " & $ClientWidth & " x " & $ClientHeight & "!", $COLOR_ERROR)
		SetDebugLog("CheckScreenAndroid: " & $ClientWidth & " x " & $ClientHeight & " <> " & $g_iAndroidClientWidth & " x " & $g_iAndroidClientHeight)
		Return False
	EndIf

	; check display font size
	AndroidAdbLaunchShellInstance()
	Local $s_font_scale = AndroidAdbSendShellCommand("settings get system font_scale")
	Local $font_scale = Number($s_font_scale)
	If $font_scale > 0 Then
		SetDebugLog($g_sAndroidEmulator & " font_scale = " & $font_scale)
		If $font_scale <> 1 Then
			SetLog("MyBot doesn't work with Display Font Scale of " & $font_scale, $COLOR_ERROR)
			Return False
		EndIf
	Else
		Switch $g_sAndroidEmulator
			Case "BlueStacks", "BlueStacks2" ; BlueStacks doesn't support it
			Case Else
				SetDebugLog($g_sAndroidEmulator & " Display Font Scale cannot be verified", $COLOR_ERROR)
		EndSwitch
	EndIf

	; check emulator specific setting
	SetError(0, 0, 0)
	$ok = Execute("CheckScreen" & $g_sAndroidEmulator & "(" & $bSetLog & ")")
	If $ok = "" And @error <> 0 Then Return True ; Not implemented
	Return $ok

EndFunc   ;==>CheckScreenAndroid

Func AndroidSetFontSizeNormal()
	ResumeAndroid()
	AndroidAdbLaunchShellInstance($g_bRunState, False)
	SetLog("Set " & $g_sAndroidEmulator & " Display Font Scale to normal", $COLOR_INFO)
	AndroidAdbSendShellCommand("settings put system font_scale 1.0")
EndFunc   ;==>AndroidSetFontSizeNormal

Func AndroidAdbLaunchShellInstance($wasRunState = $g_bRunState, $rebootAndroidIfNeccessary = $g_bRunState)
	If $g_iAndroidAdbPid = 0 Or ProcessExists2($g_iAndroidAdbPid) <> $g_iAndroidAdbPid Then
		Local $SuspendMode = ResumeAndroid()
		InitAndroid()
		Local $s

		; sync android tools to shared folder
		Local $hostFolder = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder
		If FileExists($hostFolder) = 1 Then
			SetDebugLog($hostFolder & " exists")
			Local $aTools[1] = ["sleep"]
			Local $tool
			For $tool In $aTools
				Local $srcFile = $g_sAdbScriptsPath & "\" & $tool
				Local $dstFile = $hostFolder & $tool
				If FileGetTime($srcFile, $FT_MODIFIED, $FT_STRING) <> FileGetTime($dstFile, $FT_MODIFIED, $FT_STRING) Then
					FileCopy($srcFile, $dstFile, $FC_OVERWRITE)
				EndIf
			Next
		EndIf

		If $g_bAndroidAdbInstance = True Then
			If ConnectAndroidAdb($rebootAndroidIfNeccessary) = False Then
				Return SetError(3, 0)
			EndIf
			$g_iAndroidAdbPid = Run($g_sAndroidAdbPath & " -s " & $g_sAndroidAdbDevice & " shell", "", @SW_HIDE, BitOR($STDIN_CHILD, $STDERR_MERGED))
			If $g_iAndroidAdbPid = 0 Or ProcessExists2($g_iAndroidAdbPid) <> $g_iAndroidAdbPid Then
				SetLog($g_sAndroidEmulator & " error launching ADB for background mode, zoom-out, mouse click and input", $COLOR_ERROR)
				$g_bAndroidAdbScreencap = False
				$g_bAndroidAdbClick = False
				$g_bAndroidAdbInput = False
				If BitAND($g_iAndroidSupportFeature, 1) = 0 Then $g_bChkBackgroundMode = False ; disable also background mode the hard way
				SetError(1, 0)
			EndIf
			; increase shell priority
			$s = AndroidAdbSendShellCommand("PS1=" & $g_sAndroidAdbPrompt, Default, $wasRunState, False) ; set prompt to unique string $g_sAndroidAdbPrompt
			#cs 2016-04-08 cosote Replaced by shell.init.script
				Local $renice = "/system/xbin/renice -20 "
				$s = AndroidAdbSendShellCommand($renice & "$$", Default, $wasRunState, False) ; increase shell priority to maximum
				If StringInStr($s, "not found") > 0 Then
				$renice = "renice -- -20 "
				$s = AndroidAdbSendShellCommand($renice & "$$", Default, $wasRunState, False) ; increase shell priority to maximum
				EndIf
				$s &= AndroidAdbSendShellCommand("stop media", Default, $wasRunState, False) ; stop media service as it can consume up to 30% Android CPU
			#ce
			Local $scriptFile = ""
			If $scriptFile = "" And FileExists($g_sAdbScriptsPath & "\shell.init." & $g_sAndroidEmulator & ".script") = 1 Then $scriptFile = "shell.init." & $g_sAndroidEmulator & ".script"
			If $scriptFile = "" Then $scriptFile = "shell.init.script"
			$s &= AndroidAdbSendShellCommandScript($scriptFile, Default, Default, Default, $wasRunState, False)
			Local $error = @error
			SetDebugLog("ADB shell launched, PID = " & $g_iAndroidAdbPid & ": " & $s)
			If $error <> 0 Then
				SuspendAndroid($SuspendMode)
				Return
			EndIf
		EndIf
		; check shared folder
		;If StringInStr($g_sAndroidPicturesPath, "|", $STR_NOCASESENSEBASIC) > 0 Then
		If True Then ; always validate picture patch
			If ConnectAndroidAdb($rebootAndroidIfNeccessary) = False Then
				Return SetError(3, 0)
			EndIf

			Local $pathFound = False
			Local $iMount
			For $iMount = 0 To 9
				$s = AndroidAdbSendShellCommand("mount", Default, $wasRunState, False)
				Local $path = $g_sAndroidPicturesPath
				If StringRight($path, 1) = "/" Then $path = StringLeft($path, StringLen($path) - 1)
				Local $aRegExResult = StringRegExp($s, $path, $STR_REGEXPARRAYMATCH)
				If @error = 0 Then
					; check which path contains dummy file
				Local $dummyFile = StringMid(_Crypt_HashData($g_sBotTitle & _Now(), $CALG_SHA1), 3)
					FileWriteLine($g_sAndroidPicturesHostPath & $dummyFile, _Now())
					For $i = 0 To UBound($aRegExResult) - 1
						$path = $aRegExResult[$i]
						If StringRight($path, 1) <> "/" Then $path &= "/"
						$s = AndroidAdbSendShellCommand("ls " & $path & $dummyFile, Default, $wasRunState, False)
						If StringInStr($s, "No such file or directory") = 0 Then
							$pathFound = True
							$g_sAndroidPicturesPath = $path
							SetDebugLog("Using " & $g_sAndroidPicturesPath & " for Android shared folder")
							ExitLoop
						EndIf
					Next
					; delete dummy FileChangeDir
					FileDelete($g_sAndroidPicturesHostPath & $dummyFile)
				EndIf
				If $pathFound = True Then ExitLoop
				If $iMount = 0 Then
					SetLog("Waiting for shared folder to get mounted...", $COLOR_GREEN)
				Else
					SetDebugLog("Still waiting for shared folder to get mounted...")
				EndIf
				If _Sleep(3000) Then Return
			Next
			If $pathFound = False Then
				SetLog($g_sAndroidEmulator & " cannot use ADB on shared folder, """ & $g_sAndroidPicturesPath & """ not found", $COLOR_ERROR)
			EndIf
		EndIf
		; check mouse device
		If StringLen($g_sAndroidMouseDevice) > 0 And $g_sAndroidMouseDevice = $g_avAndroidAppConfig[$g_iAndroidConfig][13] Then
			If ConnectAndroidAdb($rebootAndroidIfNeccessary) = False Then
				Return SetError(3, 0)
			EndIf
			If StringInStr($g_sAndroidMouseDevice, "/dev/input/event") = 0 Then
				; use getevent to find mouse input device
				$s = AndroidAdbSendShellCommand("getevent -p", Default, $wasRunState, False)
				SetDebugLog($g_sAndroidEmulator & " getevent -p: " & $s)
				Local $aRegExResult = StringRegExp($s, "(\/dev\/input\/event\d+)[\r\n]+.+""" & $g_sAndroidMouseDevice & """((?!\/dev\/input\/event)[\s\S])+ABS", $STR_REGEXPARRAYMATCH)
				If @error = 0 Then
					$g_sAndroidMouseDevice = $aRegExResult[0]
					SetDebugLog("Using " & $g_sAndroidMouseDevice & " for mouse events")
				Else
					$g_bAndroidAdbClick = False
					SetLog($g_sAndroidEmulator & " cannot use ADB for mouse events, """ & $g_sAndroidMouseDevice & """ not found", $COLOR_ERROR)
					SuspendAndroid($SuspendMode)
					Return SetError(2, 1)
				EndIf
			EndIf
			SuspendAndroid($SuspendMode)
			Return SetError(0, 1)
		Else
			SetDebugLog($g_sAndroidEmulator & " ADB use " & $g_sAndroidMouseDevice & " for mouse events")
		EndIf
	EndIf
	SetError(0, 0)
EndFunc   ;==>AndroidAdbLaunchShellInstance

Func AndroidAdbTerminateShellInstance()
	Local $SuspendMode = ResumeAndroid()
	If $g_iAndroidAdbPid <> 0 Then
		StdioClose($g_iAndroidAdbPid)
		If ProcessClose($g_iAndroidAdbPid) = 1 Then
			SetDebugLog("ADB shell terminated, PID = " & $g_iAndroidAdbPid)
		Else
			SetDebugLog("ADB shell not terminated, PID = " & $g_iAndroidAdbPid, $COLOR_ERROR)
		EndIf
		$g_iAndroidAdbPid = 0
	EndIf
	SuspendAndroid($SuspendMode)
EndFunc   ;==>AndroidAdbTerminateShellInstance

Func AndroidAdbSendShellCommand($cmd = Default, $timeout = Default, $wasRunState = Default, $EnsureShellInstance = True)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	Local $Result = _AndroidAdbSendShellCommand($cmd, $timeout, $wasRunState, $EnsureShellInstance)
	$g_bTogglePauseAllowed = $wasAllowed
	Return SetError(@error, @extended, $Result)
EndFunc   ;==>AndroidAdbSendShellCommand

Func _AndroidAdbSendShellCommand($cmd = Default, $timeout = Default, $wasRunState = Default, $EnsureShellInstance = True)
	Local $_SilentSetLog = $g_bSilentSetLog
	If $timeout = Default Then $timeout = 3000 ; default is 3 sec.
	If $wasRunState = Default Then $wasRunState = $g_bRunState
	Local $sentBytes = 0
	Local $SuspendMode = ResumeAndroid()
	SetError(0, 0, 0)
	If $EnsureShellInstance = True Then
		AndroidAdbLaunchShellInstance($wasRunState) ; recursive call in AndroidAdbLaunchShellInstance!
	EndIf
	If @error <> 0 Then Return SetError(@error, 0, "")
	Local $hTimer = TimerInit()
	Local $s = ""
	Local $loopCount = 0
	Local $cleanOutput = True
	If $g_bAndroidAdbInstance = True Then
		; use steady ADB shell
		StdoutRead($g_iAndroidAdbPid) ; clean output
		If $cmd = Default Then
			; nothing to launch
		Else
			If $g_iDebugSetlog = 1 Then
				;$g_bSilentSetLog = True
				SetDebugLog("Send ADB shell command: " & $cmd)
				;$g_bSilentSetLog = $_SilentSetLog
			EndIf
			$sentBytes = StdinWrite($g_iAndroidAdbPid, $cmd & @LF)
		EndIf
		While $timeout > 0 And @error = 0 And StringRight($s, StringLen($g_sAndroidAdbPrompt) + 1) <> @LF & $g_sAndroidAdbPrompt And TimerDiff($hTimer) < $timeout
			Sleep(10)
			$s &= StdoutRead($g_iAndroidAdbPid)
			$loopCount += 1
			If $wasRunState = True And $g_bRunState = False Then ExitLoop ; stop pressed here, exit without error
		WEnd
	Else
		; invoke new single ADB shell command
		$cleanOutput = False
		If $cmd = Default Then
			; nothing to launch
		Else
			Local $process_killed
			If $g_iDebugSetlog = 1 Then
				;$g_bSilentSetLog = True
				SetDebugLog("Execute ADB shell command: " & $cmd)
				;$g_bSilentSetLog = $_SilentSetLog
			EndIf
			$s = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " shell " & $cmd, $process_killed, $timeout)
		EndIf
	EndIf

	If $cleanOutput = True Then
		Local $i = StringInStr($s, @LF)
		If $i > 0 Then $s = StringMid($s, $i) ; remove echo'd command
		If StringRight($s, StringLen($g_sAndroidAdbPrompt) + 1) = @LF & $g_sAndroidAdbPrompt Then $s = StringLeft($s, StringLen($s) - StringLen($g_sAndroidAdbPrompt) - 1) ; remove tailing prompt
		CleanLaunchOutput($s)
		If StringLeft($s, 1) = @LF Then $s = StringMid($s, 2) ; remove starting @LF
	EndIf

	; remove LeapDroid WARNING: linker: libdvm.so has text relocations. This is wasting memory and is a security risk. Please fix.
	Local $sRemove = "WARNING: linker: libdvm.so has text relocations. This is wasting memory and is a security risk. Please fix."
	If StringLen($s) >= StringLen($sRemove) And StringLeft($s, StringLen($sRemove)) = $sRemove Then
		$s = StringMid($s, StringLen($sRemove) + 1)
		If StringLeft($s, 1) = @LF Then $s = StringMid($s, 2) ; remove starting @LF
	EndIf

	If $g_bAndroidAdbInstance = True And $g_iDebugSetlog = 1 And StringLen($s) > 0 Then SetDebugLog("ADB shell command output: " & $s)
	SuspendAndroid($SuspendMode)
	Local $error = (($g_bRunState = False Or TimerDiff($hTimer) < $timeout Or $timeout < 1) ? 0 : 1)
	If $error <> 0 Then SetDebugLog("ADB shell command error " & $error & ": " & $s)
	If $__TEST_ERROR_SLOW_ADB_SHELL_COMMAND_DELAY > 0 Then Sleep($__TEST_ERROR_SLOW_ADB_SHELL_COMMAND_DELAY)
	$g_iAndroidAdbAutoTerminateCount += 1
	If Mod($g_iAndroidAdbAutoTerminateCount, $g_iAndroidAdbAutoTerminate) = 0 And $EnsureShellInstance = True Then
		AndroidAdbTerminateShellInstance()
	EndIf
	Return SetError($error, Int(TimerDiff($hTimer)) & "ms,#" & $loopCount, $s)
EndFunc   ;==>_AndroidAdbSendShellCommand

Func GetBinaryEvent($type, $code, $value)
	Local $h, $hType, $hCode, $hValue
	If IsInt($type) Then
		$hType = StringLeft(Hex(Binary($type)), 4)
	ElseIf IsString($type) Then
		$hType = $type
	EndIf
	If IsInt($code) Then
		$hCode = StringLeft(Hex(Binary($code)), 4)
	ElseIf IsString($code) Then
		$hCode = $code
	EndIf
	If IsInt($value) Then
		$hValue = StringLeft(Hex(Binary($value)), 8)
	ElseIf IsString($value) Then
		$hValue = $value
	EndIf
	#cs
		$hType = "0100"
		$hCode = "4a01"
		$hValue = "01000000"
	#ce
	$h = "0x0000000000000000" & $hType & $hCode & $hValue
	Return Binary($h)
EndFunc   ;==>GetBinaryEvent

Func AndroidAdbSendShellCommandScript($scriptFile, $variablesArray = Default, $combine = Default, $timeout = Default, $wasRunState = $g_bRunState, $EnsureShellInstance = True)
	If $combine = Default Then $combine = False
	If $timeout = Default Then $timeout = 20000 ; default is 20 sec. for scripts
	Local $hostPath = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder
	Local $androidPath = $g_sAndroidPicturesPath & StringReplace($g_sAndroidPicturesHostFolder, "\", "/")

	;If $HwND <> WinGetHandle($HwND) Then Return SetError(2, 0) ; Window gone
	AndroidAdbLaunchShellInstance()
	If @error <> 0 Then Return SetError(3, 0)

	Local $hTimer = TimerInit()
	Local $hFileOpen = FileOpen($g_sAdbScriptsPath & "\" & $scriptFile)
	If $hFileOpen = -1 Then
		SetLog("ADB script file not found: " & $scriptFile, $COLOR_ERROR)
		Return SetError(5, 0)
	EndIf

	Local $script = FileRead($hFileOpen)
	FileClose($hFileOpen)
	Local $scriptModifiedTime = FileGetTime($g_sAdbScriptsPath & "\" & $scriptFile, $FT_MODIFIED, $FT_STRING)

	Local $scriptFileSh = $scriptFile
	$script = StringReplace($script, "{$AndroidMouseDevice}", $g_sAndroidMouseDevice)
	If @extended > 0 Then
		$scriptFileSh &= $g_sAndroidMouseDevice
		If StringInStr($g_sAndroidMouseDevice, "/dev/input/event") = 0 Then
			$g_bAndroidAdbClick = False
			SetLog($g_sAndroidEmulator & " mouse device not configured", $COLOR_ERROR)
			Return SetError(4, 0, 0)
		EndIf
	EndIf

	Local $i, $j, $k, $iAdditional
	; copy additional files required for script
	Local $additionalFilenames[0]
	$i = 1
	While FileExists($g_sAdbScriptsPath & "\" & $scriptFile & "." & $i) = 1
		Local $srcFile = $g_sAdbScriptsPath & "\" & $scriptFile & "." & $i
		Local $secFile = GetSecureFilename($scriptFile & "." & $i)
		Local $dstFile = $hostPath & $secFile
		If FileGetTime($srcFile, $FT_MODIFIED, $FT_STRING) <> FileGetTime($dstFile, $FT_MODIFIED, $FT_STRING) Then
			FileCopy($srcFile, $dstFile, $FC_OVERWRITE)
		EndIf
		$iAdditional = $i
		ReDim $additionalFilenames[$iAdditional]
		$additionalFilenames[$iAdditional - 1] = $secFile
		$script = StringReplace($script, $scriptFile & "." & $i, $secFile)
		$i += 1
	WEnd

	If UBound($variablesArray, 2) = 2 Then
		For $i = 0 To UBound($variablesArray, 1) - 1
			$script = StringReplace($script, $variablesArray[$i][0], $variablesArray[$i][1])
			If @extended > 0 Then
				$scriptFileSh &= "." & $variablesArray[$i][1]
			EndIf
		Next
	EndIf
	$scriptFileSh = StringRegExpReplace($scriptFileSh, '[/\:*?"<>|]', '.')

	$scriptFileSh &= ".sh"
	$scriptFileSh = GetSecureFilename($scriptFileSh)
	$script = StringReplace($script, @CRLF, @LF)

	Local $aCmds = StringSplit($script, @LF)
	Local $hTimer = TimerInit()
	Local $s = ""

	; create sh file in shared folder
	If FileExists($hostPath) = 0 Then
		SetLog($g_sAndroidEmulator & " ADB script file folder doesn't exist:", $COLOR_ERROR)
		SetLog($hostPath, $COLOR_ERROR)
		Return SetError(6, 0)
	EndIf

	SetError(0, 0)
	Local $sDev
	Local $cmds = ""
	Local $dd[1]
	Local $ddCount = -1
	Local $ddFile, $ddHandle
	For $i = 1 To $aCmds[0]
		Local $cmd = $aCmds[$i]
		If StringInStr($cmd, "/dev/input/") = 1 Then
			Local $aElem = StringSplit($cmd, " ")
			$sDev = StringReplace($aElem[1], ":", "")
			If $aElem[0] < 4 Then
				SetDebugLog("ADB script " & $scriptFile & ": ignore line " & $i & ": " & $cmd, $COLOR_ACTION)
			Else
				If IsString($combine) = 1 And $combine = "dd" Then
					; convert getevent into dd send binary data
					$j = UBound($dd)
					ReDim $dd[$j + 1]
					$dd[0] = $sDev
					$dd[$j] = GetBinaryEvent(Dec($aElem[2]), Dec($aElem[3]), Dec($aElem[4]))
					$cmd = ""
				Else
					; convert getevent into sendevent
					$cmd = "sendevent " & $sDev & " " & Dec($aElem[2]) & " " & Dec($aElem[3]) & " " & Dec($aElem[4])
				EndIf
			EndIf
		EndIf

		$cmd = StringStripWS($cmd, 3)

		If $cmd = "#dd send" Then
			$j = UBound($dd) - 1
			If $j > 0 Then
				$iAdditional += 1
				$ddFile = GetSecureFilename($scriptFile & "." & $iAdditional)
				ReDim $additionalFilenames[$iAdditional]
				$additionalFilenames[$iAdditional - 1] = $ddFile
				; create dd file
				$ddHandle = FileOpen($hostPath & $ddFile, BitOR($FO_OVERWRITE, $FO_BINARY))
				$cmd = "dd obs=" & 16 * ($j - 1) & " if=" & $androidPath & $ddFile & " of=" & $dd[0]
				For $k = 1 To $j
					FileWrite($ddHandle, $dd[$k])
				Next
				FileClose($ddHandle)
			EndIf
		EndIf

		$aCmds[$i] = $cmd

		If $combine = True And IsString($combine) = 0 And StringLen($cmd) > 0 Then
			$cmds &= $cmd
			If $i < $aCmds[0] Then $cmds &= ";"
		EndIf
	Next

	Local $loopCount = 0
	If $combine = True And IsString($combine) = 0 And StringLen($cmds) <= 1024 Then
		; invoke commands now
		$s = AndroidAdbSendShellCommand($cmds, $timeout, $wasRunState, $EnsureShellInstance)
		If @error <> 0 Then Return SetError(1, 0, $s)
		Local $a = StringSplit(@extended, "#")
		If $a[0] > 1 Then $loopCount += Number($a[2])
	Else
		; create sh file in shared folder
		If $scriptModifiedTime <> FileGetTime($hostPath & $scriptFileSh, $FT_MODIFIED, $FT_STRING) Then
			FileDelete($hostPath & $scriptFileSh) ; delete existing file as new version is available
		EndIf
		If FileExists($hostPath & $scriptFileSh) = 0 Then
			; create script file
			$script = "#!/bin/sh"
			For $i = 1 To $aCmds[0]
				If ($i = 1 And $aCmds[$i] = $script) Or $aCmds[$i] = "" Then
					ContinueLoop
				EndIf
				$script &= (@LF & $aCmds[$i])
			Next
			; create sh file
			If FileWrite($hostPath & $scriptFileSh, $script) = 1 Then
				If BitAND($AndroidSecureFlags, 3) = 0 Then SetLog("ADB script file created: " & $hostPath & $scriptFileSh)
			Else
				SetLog("ADB cannot create script file: " & $hostPath & $scriptFileSh, $COLOR_ERROR)
				Return SetError(7, 0)
			EndIf
			FileSetTime($hostPath & $scriptFileSh, $scriptModifiedTime, $FT_MODIFIED) ; set modification date of source
		EndIf
		$s = AndroidAdbSendShellCommand("sh """ & $androidPath & $scriptFileSh & """", $timeout, $wasRunState, $EnsureShellInstance)
		If BitAND($AndroidSecureFlags, 2) = 2 Then
			; delete files
			FileDelete($hostPath & $scriptFileSh)
			For $i = 0 To $iAdditional - 1
				FileDelete($hostPath & $additionalFilenames[$i])
			Next
		EndIf
		If @error <> 0 Then
			SetDebugLog("Error executing " & $scriptFileSh & ": " & $s)
			Return SetError(1, 0, $s)
		EndIf
		Local $a = StringSplit(@extended, "#")
		If $a[0] > 1 Then $loopCount += Number($a[2])
	EndIf

	Return SetError(0, Int(TimerDiff($hTimer)) & "ms,#" & $loopCount, $s)
EndFunc   ;==>AndroidAdbSendShellCommandScript

;==================================================================================================================================
; Author ........: UEZ
; Modified.......: progandy, cosote
;===================================================================================================================================
Func __GDIPlus_BitmapCreateFromMemory($dImage, $bHBITMAP = False)
	If Not IsBinary($dImage) Then Return SetError(1, 0, 0)
	Local $aResult = 0
	Local Const $dMemBitmap = Binary($dImage) ;load image saved in variable (memory) and convert it to binary
	Local Const $iLen = BinaryLen($dMemBitmap) ;get binary length of the image
	Local Const $GMEM_MOVEABLE = 0x0002
	$aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", $GMEM_MOVEABLE, "ulong_ptr", $iLen) ;allocates movable memory ($GMEM_MOVEABLE = 0x0002)
	If @error Then Return SetError(4, 0, 0)
	Local Const $hData = $aResult[0]
	$aResult = DllCall("kernel32.dll", "ptr", "GlobalLock", "handle", $hData)
	If @error Then Return SetError(5, 0, 0)
	Local $tMem = DllStructCreate("byte[" & $iLen & "]", $aResult[0]) ;create struct
	DllStructSetData($tMem, 1, $dMemBitmap) ;fill struct with image data
	DllCall("kernel32.dll", "bool", "GlobalUnlock", "handle", $hData) ;decrements the lock count associated with a memory object that was allocated with GMEM_MOVEABLE
	If @error Then Return SetError(6, 0, 0)
	Local Const $hStream = _WinAPI_CreateStreamOnHGlobal($hData) ;creates a stream object that uses an HGLOBAL memory handle to store the stream contents
	If @error Then Return SetError(2, 0, 0)
	Local Const $hBitmap = _GDIPlus_BitmapCreateFromStream($hStream) ;creates a Bitmap object based on an IStream COM interface
	If @error Then Return SetError(3, 0, 0)
	DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $hStream, "ulong_ptr", 8 * (1 + @AutoItX64), "uint", 4, "ushort", 23, "uint", 0, "ptr", 0, "ptr", 0, "str", "") ;release memory from $hStream to avoid memory leak
	If $bHBITMAP Then
		Local Const $hHBmp = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap) ;supports GDI transparent color format
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBmp
	EndIf
	Return $hBitmap
EndFunc   ;==>__GDIPlus_BitmapCreateFromMemory

Func AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $iRetryCount = 0)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	Local $Result = _AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $iRetryCount)
	$g_bTogglePauseAllowed = $wasAllowed
	Return SetError(@error, @extended, $Result)
EndFunc   ;==>AndroidScreencap

Func _AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $iRetryCount = 0)
	Local $startTimer = TimerInit()
	Local $hostPath = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder
	Local $androidPath = $g_sAndroidPicturesPath & StringReplace($g_sAndroidPicturesHostFolder, "\", "/")

	If $hostPath = "" Or $androidPath = "" Then
		If $hostPath = "" Then
			SetLog($g_sAndroidEmulator & " shared folder not configured for host", $COLOR_ERROR)
		Else
			SetLog($g_sAndroidEmulator & " shared folder not configured for Android", $COLOR_ERROR)
		EndIf
		SetLog($g_sAndroidEmulator & " ADB screen capture disabled", $COLOR_ERROR)
		If BitAND($g_iAndroidSupportFeature, 1) = 0 Then $g_bChkBackgroundMode = False ; disable also background mode the hard way
		$g_bAndroidAdbScreencap = False
	EndIf

	;If $HwND <> WinGetHandle($HwND) Then Return SetError(4, 0) ; Window gone
	Local $wasRunState = $g_bRunState
	AndroidAdbLaunchShellInstance($wasRunState)
	If @error <> 0 Then Return SetError(2, 0)

	Local $sBotTitleEx = StringRegExpReplace($g_sBotTitle, '[/:*?"<>|]', '_')
	Local $Filename = $sBotTitleEx & ".rgba"
	If $g_bAndroidAdbScreencapPngEnabled = True Then $Filename = $sBotTitleEx & ".png"
	$Filename = GetSecureFilename($Filename)
	Local $s

	; Create 32 bits-per-pixel device-independent bitmap (DIB)
	Local $tBIV5HDR = 0
	If $g_bAndroidAdbScreencapPngEnabled = False Then
		$tBIV5HDR = DllStructCreate($tagBITMAPV5HEADER)
		DllStructSetData($tBIV5HDR, 'bV5Size', DllStructGetSize($tBIV5HDR))
		DllStructSetData($tBIV5HDR, 'bV5Width', $iWidth)
		DllStructSetData($tBIV5HDR, 'bV5Height', -$iHeight)
		DllStructSetData($tBIV5HDR, 'bV5Planes', 1)
		DllStructSetData($tBIV5HDR, 'bV5BitCount', 32)
		DllStructSetData($tBIV5HDR, 'biCompression', $BI_RGB)
	EndIf
	Local $pBits = 0
	Local $hHBitmap = 0

	If $g_iAndroidAdbScreencapTimer <> 0 And $g_bForceCapture = False And TimerDiff($g_iAndroidAdbScreencapTimer) < $g_iAndroidAdbScreencapTimeout And $g_bRunState = True And $iRetryCount = 0 Then
		If $g_bAndroidAdbScreencapPngEnabled = False Then
			$hHBitmap = _WinAPI_CreateDIBSection(0, $tBIV5HDR, $DIB_RGB_COLORS, $pBits)
			$tBIV5HDR = 0 ; Release the resources used by the structure
			DllCall($g_sLibPath & "\helper_functions.dll", "none:cdecl", "RGBA2BGRA", "ptr", DllStructGetPtr($g_aiAndroidAdbScreencapBuffer), "ptr", $pBits, "int", $iLeft, "int", $iTop, "int", $iWidth, "int", $iHeight, "int", $g_iAndroidAdbScreencapWidth, "int", $g_iAndroidAdbScreencapHeight)
			Return $hHBitmap
		ElseIf $g_hAndroidAdbScreencapBufferPngHandle <> 0 Then
			If $iWidth > $g_iAndroidAdbScreencapWidth - $iLeft Then $iWidth = $g_iAndroidAdbScreencapWidth - $iLeft
			If $iHeight > $g_iAndroidAdbScreencapHeight - $iTop Then $iHeight = $g_iAndroidAdbScreencapHeight - $iTop
			Local $hClone = _GDIPlus_BitmapCloneArea($g_hAndroidAdbScreencapBufferPngHandle, $iLeft, $iTop, $iWidth, $iHeight, $GDIP_PXF32ARGB)
			Return _GDIPlus_BitmapCreateDIBFromBitmap($hClone)
		EndIf
	EndIf

	FileDelete($hostPath & $Filename)
	$s = AndroidAdbSendShellCommand("screencap """ & $androidPath & $Filename & """", $g_iAndroidAdbScreencapWaitAdbTimeout, $wasRunState)
	;$s = AndroidAdbSendShellCommand("screencap """ & $androidPath & $filename & """", -1, $wasRunState)
	If $__TEST_ERROR_SLOW_ADB_SCREENCAP_DELAY > 0 Then Sleep($__TEST_ERROR_SLOW_ADB_SCREENCAP_DELAY)
	Local $shellLogInfo = @extended

	Local $hTimer = TimerInit()
	Local $hFile = 0
	Local $iSize = 0
	Local $iLoopCountFile = 0
	Local $AdbStatsType = 0 ; screencap stats
	Local $iF = 0
	Local $ExpectedFileSize = 1500 ; all blank png is approx 1.5 KByte
	Local $iReadData = 0

	If $g_bAndroidAdbScreencapPngEnabled = False Then
		; default raw RGBA mode

		; Android screencap see:
		; https://android.googlesource.com/platform/frameworks/base/+/jb-release/cmds/screencap/screencap.cpp
		; http://androidsource.top/code/source/system/core/include/system/graphics.h
		; http://androidsource.top/code/source/frameworks/base/include/ui/PixelFormat.h
		Local $tHeader = DllStructCreate("int w;int h;int f")
		Local $iHeaderSize = DllStructGetSize($tHeader)
		Local $iDataSize = DllStructGetSize($g_aiAndroidAdbScreencapBuffer)

		; wait for file (required for Droid4X)
		$ExpectedFileSize = $g_iAndroidClientWidth * $g_iAndroidClientHeight * 4 + $iHeaderSize
		#cs
			While TimerDiff($hTimer) < $g_iAndroidAdbScreencapWaitFileTimeout And FileGetSize($hostPath & $filename) < $ExpectedFileSize ; wait max. 5 seconds
			Sleep(10)
			If $wasRunState = True And $g_bRunState = False Then Return SetError(1, 0)
			$iLoopCountFile += 1
			WEnd
		#ce
		While $iSize < $ExpectedFileSize And TimerDiff($hTimer) < $g_iAndroidAdbScreencapWaitFileTimeout
			If $hFile = 0 Then $hFile = _WinAPI_CreateFile($hostPath & $Filename, 2, 2, 7)
			If $hFile <> 0 Then $iSize = _WinAPI_GetFileSizeEx($hFile)
			If $iSize >= $ExpectedFileSize Then ExitLoop
			Sleep(10)
			If $wasRunState = True And $g_bRunState = False Then
				If $hFile <> 0 Then _WinAPI_CloseHandle($hFile)
				Return SetError(1, 0)
			EndIf
			$iLoopCountFile += 1
		WEnd

		Local $iReadHeader = 0
		$g_iAndroidAdbScreencapWidth = 0
		$g_iAndroidAdbScreencapHeight = 0

		If $hFile <> 0 Then
			If $iSize >= $ExpectedFileSize Then
				$hTimer = TimerInit()
				While $iReadHeader < $iHeaderSize And TimerDiff($hTimer) < $g_iAndroidAdbScreencapWaitFileTimeout
					If _WinAPI_ReadFile($hFile, $tHeader, $iHeaderSize, $iReadHeader) = True And $iReadHeader = $iHeaderSize Then
						ExitLoop
					Else
						SetDebugLog("Error " & _WinAPI_GetLastError() & ", read " & $iReadHeader & " header bytes, file: " & $hostPath & $Filename, $COLOR_ERROR)
						If $iReadHeader > 0 Then _WinAPI_SetFilePointer($hFile, 0)
						Sleep(10)
					EndIf
				WEnd
				$g_iAndroidAdbScreencapWidth = DllStructGetData($tHeader, "w")
				$g_iAndroidAdbScreencapHeight = DllStructGetData($tHeader, "h")
				$iF = DllStructGetData($tHeader, "f")
				$hTimer = TimerInit()
				If $iSize - $iHeaderSize < $iDataSize Then $iDataSize = $iSize - $iHeaderSize
				While $iReadData < $iDataSize And TimerDiff($hTimer) < $g_iAndroidAdbScreencapWaitFileTimeout
					If _WinAPI_ReadFile($hFile, $g_aiAndroidAdbScreencapBuffer, $iDataSize, $iReadData) = True And $iReadData = $iDataSize Then
						ExitLoop
					Else
						SetDebugLog("Error " & _WinAPI_GetLastError() & ", read " & $iReadData & " data bytes, file: " & $hostPath & $Filename, $COLOR_ERROR)
						If $iReadData > 0 Then _WinAPI_SetFilePointer($hFile, $iHeaderSize)
						Sleep(10)
					EndIf
				WEnd

				_WinAPI_CloseHandle($hFile)
				$hHBitmap = _WinAPI_CreateDIBSection(0, $tBIV5HDR, $DIB_RGB_COLORS, $pBits)
				DllCall($g_sLibPath & "\helper_functions.dll", "none:cdecl", "RGBA2BGRA", "ptr", DllStructGetPtr($g_aiAndroidAdbScreencapBuffer), "ptr", $pBits, "int", $iLeft, "int", $iTop, "int", $iWidth, "int", $iHeight, "int", $g_iAndroidAdbScreencapWidth, "int", $g_iAndroidAdbScreencapHeight)
			Else
				_WinAPI_CloseHandle($hFile)
				SetDebugLog("File too small (" & $iSize & " < " & $ExpectedFileSize & "): " & $hostPath & $Filename, $COLOR_ERROR)
			EndIf
		EndIf
		If $hFile = 0 Or $iSize < $ExpectedFileSize Or $iReadHeader < $iHeaderSize Or $iReadData < $iDataSize Then
			If $hFile = 0 Then
				SetLog("File not found: " & $hostPath & $Filename, $COLOR_ERROR)
			Else
				If $iSize <> $ExpectedFileSize Then SetDebugLog("File size " & $iSize & " is not " & $ExpectedFileSize & " for " & $hostPath & $Filename, $COLOR_ERROR)
				SetDebugLog("Captured screen size " & $g_iAndroidAdbScreencapWidth & " x " & $g_iAndroidAdbScreencapHeight, $COLOR_ERROR)
				SetDebugLog("Captured screen bytes read (header/datata): " & $iReadHeader & " / " & $iReadData, $COLOR_ERROR)
			EndIf
			If $iRetryCount < 10 Then
				SetDebugLog("ADB retry screencap in 1000 ms. (restarting ADB session)", $COLOR_ACTION)
				_Sleep(1000)
				AndroidAdbTerminateShellInstance()
				AndroidAdbLaunchShellInstance($wasRunState)
				Return AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $iRetryCount + 1)
			EndIf
			SetLog($g_sAndroidEmulator & " screen not captured using ADB", $COLOR_ERROR)
			If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] < 50 And AndroidControlAvailable() Then
				SetLog($g_sAndroidEmulator & " ADB screen capture disabled", $COLOR_ERROR)
				If BitAND($g_iAndroidSupportFeature, 1) = 0 Then $g_bChkBackgroundMode = False ; disable also background mode the hard way
				$g_bAndroidAdbScreencap = False
			Else
				; reboot Android
				SetLog("Rebooting " & $g_sAndroidEmulator & " due to problems capturing screen", $COLOR_ERROR)
				Local $_NoFocusTampering = $g_bNoFocusTampering
				$g_bNoFocusTampering = True
				RebootAndroid()
				$g_bNoFocusTampering = $_NoFocusTampering
			EndIf
			Return SetError(3, 0)
		EndIf

	Else

		; slower compatible PNG mode for BlueStacks
		If $g_hAndroidAdbScreencapBufferPngHandle <> 0 Then
			_GDIPlus_ImageDispose($g_hAndroidAdbScreencapBufferPngHandle)
			_GDIPlus_BitmapDispose($g_hAndroidAdbScreencapBufferPngHandle) ; dispose old cache
			_WinAPI_DeleteObject($g_hAndroidAdbScreencapBufferPngHandle)
			$g_hAndroidAdbScreencapBufferPngHandle = 0
		EndIf
		Local $hBitmap = 0
		#cs causes open file handles
			While $hBitmap = 0 And TimerDiff($hTimer) < $g_iAndroidAdbScreencapWaitFileTimeout
			;$hBitmap = _GDIPlus_ImageLoadFromFile($hostPath & $filename)
			$hBitmap = _GDIPlus_BitmapCreateFromFile($hostPath & $filename)
			If $hBitmap = 0 Then Sleep(10)
			WEnd
		#ce

		While $iSize < $ExpectedFileSize And TimerDiff($hTimer) < $g_iAndroidAdbScreencapWaitFileTimeout
			If $hFile = 0 Then $hFile = _WinAPI_CreateFile($hostPath & $Filename, 2, 2, 7)
			If $hFile <> 0 Then $iSize = _WinAPI_GetFileSizeEx($hFile)
			If $iSize >= $ExpectedFileSize Then ExitLoop
			Sleep(10)
			If $wasRunState = True And $g_bRunState = False Then Return SetError(1, 0)
			$iLoopCountFile += 1
		WEnd


		Local $hData = _MemGlobalAlloc($iSize, $GMEM_MOVEABLE)
		Local $pData = _MemGlobalLock($hData)
		Local $tData = DllStructCreate('byte[' & $iSize & ']', $pData)

		While $iSize > 0 And $iReadData < $iSize And TimerDiff($hTimer) < $g_iAndroidAdbScreencapWaitFileTimeout
			If _WinAPI_ReadFile($hFile, $tData, $iSize, $iReadData) = True And $iReadData = $iSize Then
				ExitLoop
			Else
				SetDebugLog("Error " & _WinAPI_GetLastError() & ", read " & $iReadData & " data bytes, file: " & $hostPath & $Filename, $COLOR_ERROR)
				If $iReadData > 0 Then _WinAPI_SetFilePointer($hFile, 0)
				Sleep(10)
			EndIf
		WEnd
		_WinAPI_CloseHandle($hFile)
		SetDebugLog($iSize, $COLOR_ERROR)

		Local $testTimer = TimerInit()
		Local $msg = ""
		_MemGlobalUnlock($hData)
		Local $pStream = _WinAPI_CreateStreamOnHGlobal($hData)

		$hBitmap = _GDIPlus_BitmapCreateFromStream($pStream)
		;Local $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
		;Local $iWidth = _GDIPlus_ImageGetWidth($hImage)
		;Local $iHeight = _GDIPlus_ImageGetHeight($hImage)
		_WinAPI_ReleaseStream($pStream)
		$msg &= ", " & Round(TimerDiff($testTimer), 2)
		;_GDIPlus_ImageDispose($hImage)


		;_GDIPlus_BitmapCreateFromMemory
		If $hBitmap = 0 Then
			; problem creating Bitmap
			If $iRetryCount < 10 Then
				SetDebugLog("ADB retry screencap in 1000 ms. (restarting ADB session)", $COLOR_ACTION)
				_Sleep(1000)
				AndroidAdbTerminateShellInstance()
				AndroidAdbLaunchShellInstance($wasRunState)
				Return AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $iRetryCount + 1)
			EndIf
			SetLog($g_sAndroidEmulator & " screen not captured using ADB", $COLOR_ERROR)
			If FileExists($hostPath & $Filename) = 0 Then SetLog("File not found: " & $hostPath & $Filename, $COLOR_ERROR)
			SetLog($g_sAndroidEmulator & " ADB screen capture disabled", $COLOR_ERROR)
			$g_bAndroidAdbScreencap = False
			Return SetError(5, 0)
		Else
			$g_iAndroidAdbScreencapWidth = _GDIPlus_ImageGetWidth($hBitmap)
			$g_iAndroidAdbScreencapHeight = _GDIPlus_ImageGetHeight($hBitmap)
			$msg &= ", " & Round(TimerDiff($testTimer), 2)
			;$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
			If $iWidth > $g_iAndroidAdbScreencapWidth - $iLeft Then $iWidth = $g_iAndroidAdbScreencapWidth - $iLeft
			If $iHeight > $g_iAndroidAdbScreencapHeight - $iTop Then $iHeight = $g_iAndroidAdbScreencapHeight - $iTop
			Local $hClone = _GDIPlus_BitmapCloneArea($hBitmap, $iLeft, $iTop, $iWidth, $iHeight, $GDIP_PXF32ARGB)
			$msg &= ", " & Round(TimerDiff($testTimer), 2)
			If $hClone = 0 Then
				SetDebugLog($g_sAndroidEmulator & " error using " & $g_iAndroidAdbScreencapWidth & "x" & $g_iAndroidAdbScreencapHeight & " on _GDIPlus_BitmapCloneArea(" & $hBitmap & "," & $iLeft & "," & $iTop & "," & $iWidth & "," & $iHeight, $COLOR_ERROR)
				SetLog($g_sAndroidEmulator & " screenshot not available", $COLOR_ERROR)
				SetLog($g_sAndroidEmulator & " ADB screen capture disabled", $COLOR_ERROR)
				$g_bAndroidAdbScreencap = False
				Return SetError(6, 0)
			EndIf
			$g_hAndroidAdbScreencapBufferPngHandle = $hBitmap
			;_GDIPlus_ImageDispose($hBitmap)
			$msg &= ", " & Round(TimerDiff($testTimer), 2)
			$hHBitmap = _GDIPlus_BitmapCreateDIBFromBitmap($hClone)
			;$hHBitmap = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
		EndIf
	EndIf

	If BitAND($AndroidSecureFlags, 2) = 2 Then
		; delete file
		FileDelete($hostPath & $Filename)
	EndIf

	Local $duration = Int(TimerDiff($startTimer))
	; dynamically adjust $g_iAndroidAdbScreencapTimeout to 3 x of current duration ($g_iAndroidAdbScreencapTimeoutDynamic)
	$g_iAndroidAdbScreencapTimeout = ($g_iAndroidAdbScreencapTimeoutDynamic = 0 ? $g_iAndroidAdbScreencapTimeoutMax : $duration * $g_iAndroidAdbScreencapTimeoutDynamic)
	If $g_iAndroidAdbScreencapTimeout < $g_iAndroidAdbScreencapTimeoutMin Then $g_iAndroidAdbScreencapTimeout = $g_iAndroidAdbScreencapTimeoutMin
	If $g_iAndroidAdbScreencapTimeout > $g_iAndroidAdbScreencapTimeoutMax Then $g_iAndroidAdbScreencapTimeout = $g_iAndroidAdbScreencapTimeoutMax
	;SetDebugLog("AndroidScreencap (" & $duration & "ms," & $shellLogInfo & "," & $iLoopCountFile & "): l=" & $iLeft & ",t=" & $iTop & ",w=" & $iWidth & ",h=" & $iHeight & ", " & $filename & ": w=" & $g_iAndroidAdbScreencapWidth & ",h=" & $g_iAndroidAdbScreencapHeight & ",f=" & $iF)

	$g_iAndroidAdbScreencapTimer = TimerInit() ; timeout starts now

	; update total stats
	$g_aiAndroidAdbStatsTotal[$AdbStatsType][0] += 1
	$g_aiAndroidAdbStatsTotal[$AdbStatsType][1] += $duration
	Local $iLastCount = UBound($g_aiAndroidAdbStatsLast, 2) - 2
	; Last 10 screencap durations, 0 is sum of durations, 1 is 0-based index to oldest, 2-11 last 10 durations
	If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] <= $iLastCount Then
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] += $duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][$g_aiAndroidAdbStatsTotal[$AdbStatsType][0] + 1] = $duration
		If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] = $iLastCount Then $g_aiAndroidAdbStatsLast[$AdbStatsType][1] = 0 ; init last index
	Else
		Local $iLastIdx = $g_aiAndroidAdbStatsLast[$AdbStatsType][1] + 2
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] -= $g_aiAndroidAdbStatsLast[$AdbStatsType][$iLastIdx] ; remove last duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] += $duration ; add current duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][$iLastIdx] = $duration ; update current duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][1] = Mod($g_aiAndroidAdbStatsLast[$AdbStatsType][1] + 1, $iLastCount) ; update oldest index
	EndIf
	If $g_aiAndroidAdbStatsLast[$AdbStatsType][1] = 0 Then
		Local $totalAvg = Round($g_aiAndroidAdbStatsTotal[$AdbStatsType][1] / $g_aiAndroidAdbStatsTotal[$AdbStatsType][0])
		Local $lastAvg = Round($g_aiAndroidAdbStatsLast[$AdbStatsType][0] / $iLastCount)
		If $g_iDebugSetlog = 1 Or Mod($g_aiAndroidAdbStatsTotal[$AdbStatsType][0], 100) = 0 Then
			SetDebugLog("AdbScreencap: " & $totalAvg & "/" & $lastAvg & "/" & $duration & " ms (all/" & $iLastCount & "/1)," & $shellLogInfo & "," & $iLoopCountFile & ",l=" & $iLeft & ",t=" & $iTop & ",w=" & $iWidth & ",h=" & $iHeight & ", " & $Filename & ": w=" & $g_iAndroidAdbScreencapWidth & ",h=" & $g_iAndroidAdbScreencapHeight & ",f=" & $iF)
		EndIf
	EndIf

	$tBIV5HDR = 0 ; Release the resources used by the structure
	Return $hHBitmap
EndFunc   ;==>_AndroidScreencap

Func AndroidZoomOut($overWaters = False, $loopCount = 0, $timeout = Default, $wasRunState = $g_bRunState)
	If $overWaters = True Then AndroidAdbScript("OverWaters", Default, $timeout, $wasRunState)
	Return AndroidAdbScript("ZoomOut", Default, $timeout, $wasRunState)
EndFunc   ;==>AndroidZoomOut

Func AndroidAdbScript($scriptTag, $variablesArray = Default, $timeout = Default, $wasRunState = $g_bRunState)
	ResumeAndroid()
	If $g_bAndroidAdbZoomoutEnabled = False Then Return SetError(4, 0)
	;If $HwND <> WinGetHandle($HwND) Then Return SetError(3, 0) ; Window gone
	AndroidAdbLaunchShellInstance($wasRunState)
	If @error <> 0 Then Return SetError(2, 0, 0)
	If StringInStr($g_sAndroidMouseDevice, "/dev/input/event") = 0 Then Return SetError(2, 0, 0)
	Local $scriptFile = ""
	If $scriptFile = "" And FileExists($g_sAdbScriptsPath & "\" & $scriptTag & "." & $g_sAndroidEmulator & ".script") = 1 Then $scriptFile = $scriptTag & "." & $g_sAndroidEmulator & ".script"
	If $scriptFile = "" And FileExists($g_sAdbScriptsPath & "\" & $scriptTag & "." & $g_sAndroidEmulator & ".getevent") = 1 Then $scriptFile = $scriptTag & "." & $g_sAndroidEmulator & ".getevent"
	If $scriptFile = "" And FileExists($g_sAdbScriptsPath & "\" & $scriptTag & ".script") = 1 Then $scriptFile = $scriptTag & ".script"
	If $scriptFile = "" Then $scriptFile = $scriptTag & ".getevent"
	If FileExists($g_sAdbScriptsPath & "\" & $scriptFile) = 0 Then Return SetError(1, 0, 0)
	AndroidAdbSendShellCommandScript($scriptFile, $variablesArray, Default, $timeout, $wasRunState)
	Return SetError(@error, @extended, (@error = 0 ? 1 : 0))
EndFunc   ;==>AndroidAdbScript

Func AndroidClickDrag($x1, $y1, $x2, $y2, $wasRunState = $g_bRunState)
	Execute($g_sAndroidEmulator & "AdjustClickCoordinates($x1,$y1)")
	Execute($g_sAndroidEmulator & "AdjustClickCoordinates($x2,$y2)")
	Local $swipe_coord[4][2] = [["{$x1}", $x1], ["{$y1}", $y1], ["{$x2}", $x2], ["{$y2}", $y2]]
	Return AndroidAdbScript("clickdrag", $swipe_coord, Default, $wasRunState)
EndFunc   ;==>AndroidClickDrag

; Returns True if KeepClicks is active or for $Really = False KeepClicks() was called even though not enabled (poor mans deploy troops detection)
Func IsKeepClicksActive($Really = True)
	If $Really = True Then
		Return $g_bAndroidAdbClick = True And $g_bAndroidAdbClicksEnabled = True And $g_aiAndroidAdbClicks[0] > -1
	EndIf
	Return $g_bAndroidAdbKeepClicksActive
EndFunc   ;==>IsKeepClicksActive

Func KeepClicks()
	$g_bAndroidAdbKeepClicksActive = True
	If $g_bAndroidAdbClick = False Or $g_bAndroidAdbClicksEnabled = False Then Return False
	If $g_aiAndroidAdbClicks[0] = -1 Then $g_aiAndroidAdbClicks[0] = 0
EndFunc   ;==>KeepClicks

Func ReleaseClicks($minClicksToRelease = 0, $ReleaseClicksEnabled = $g_bAndroidAdbClicksEnabled)
	If $g_bAndroidAdbClick = False Or $ReleaseClicksEnabled = False Then
		$g_bAndroidAdbKeepClicksActive = False
		Return False
	EndIf
	If $g_aiAndroidAdbClicks[0] > 0 And $g_bRunState = True Then
		If $g_aiAndroidAdbClicks[0] >= $minClicksToRelease Then
			AndroidClick(-1, -1, $g_aiAndroidAdbClicks[0], 0)
		Else
			Return False
		EndIf
	EndIf
	$g_bAndroidAdbKeepClicksActive = False
	ReDim $g_aiAndroidAdbClicks[1]
	$g_aiAndroidAdbClicks[0] = -1
EndFunc   ;==>ReleaseClicks

Func AndroidAdbClickSupported()
	Return BitAND($g_iAndroidSupportFeature, 4) = 4
EndFunc   ;==>AndroidAdbClickSupported

Func AndroidClick($x, $y, $times = 1, $speed = 0, $checkProblemAffect = True)
	;AndroidSlowClick($x, $y, $times, $speed)
	AndroidFastClick($x, $y, $times, $speed, $checkProblemAffect)
EndFunc   ;==>AndroidClick

Func AndroidSlowClick($x, $y, $times = 1, $speed = 0)
	$x = Int($x)
	$y = Int($y)
	Local $wasRunState = $g_bRunState
	Local $cmd = ""
	Local $i = 0
	$g_iAndroidAdbScreencapTimer = 0 ; invalidate ADB screencap timer/timeout
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
		SetDebugLog("Disabled " & $g_sAndroidEmulator & " ADB mouse click, error " & $error, $COLOR_ERROR)
		$g_bAndroidAdbClick = False
		Return SetError($error, 0)
	EndIf
EndFunc   ;==>AndroidSlowClick

Func AndroidMoveMouseAnywhere()
	Local $_SilentSetLog = $g_bSilentSetLog
	Local $hostPath = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder
	Local $androidPath = $g_sAndroidPicturesPath & StringReplace($g_sAndroidPicturesHostFolder, "\", "/")
	Local $sBotTitleEx = StringRegExpReplace($g_sBotTitle, '[/:*?"<>|]', '_')
	Local $Filename = GetSecureFilename($sBotTitleEx & ".moveaway")
	Local $recordsNum = 4
	Local $iToWrite = $recordsNum * 16
	Local $records = ""

	If FileExists($hostPath & $Filename) = 0 Then
		Local $times = 1
		Local $x = 1 ; $aAway[0]
		Local $y = 40 ; $aAway[1]
		Execute($g_sAndroidEmulator & "AdjustClickCoordinates($x,$y)")
		Local $i = 0
		Local $record = "byte[16];"
		For $i = 1 To $recordsNum * $times
			$records &= $record
		Next

		Local $data = DllStructCreate($records)
		$i = 0
		DllStructSetData($data, 1 + $i * $recordsNum, Binary("0x000000000000000003003500" & StringRight(Hex($x, 4), 2) & StringLeft(Hex($x, 4), 2) & "0000")) ; ABS_MT_POSITION_X
		DllStructSetData($data, 2 + $i * $recordsNum, Binary("0x000000000000000003003600" & StringRight(Hex($y, 4), 2) & StringLeft(Hex($y, 4), 2) & "0000")) ; ABS_MT_POSITION_Y
		DllStructSetData($data, 3 + $i * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
		DllStructSetData($data, 4 + $i * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
		Local $data2 = DllStructCreate("byte[" & DllStructGetSize($data) & "]", DllStructGetPtr($data))

		Local $iWritten = 0
		Local $sleep = ""
		Local $hFileOpen = _WinAPI_CreateFile($hostPath & $Filename, 1, 4)
		If $hFileOpen = 0 Then
			Local $error = _WinAPI_GetLastError()
			Return SetError($error, 0)
		EndIf
		_WinAPI_WriteFile($hFileOpen, DllStructGetPtr($data2), $iToWrite, $iWritten)
		_WinAPI_CloseHandle($hFileOpen)
	EndIf

	$g_bSilentSetLog = True
	AndroidAdbSendShellCommand("dd if=""" & $androidPath & $Filename & """ of=" & $g_sAndroidMouseDevice & " obs=" & $iToWrite & ">/dev/null 2>&1" & $sleep, Default)
	If BitAND($AndroidSecureFlags, 2) = 2 Then
		; delete file
		FileDelete($hostPath & $Filename)
	EndIf
	$g_bSilentSetLog = $_SilentSetLog

EndFunc   ;==>AndroidMoveMouseAnywhere

Func AndroidFastClick($x, $y, $times = 1, $speed = 0, $checkProblemAffect = True, $iRetryCount = 0)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	Local $Result = _AndroidFastClick($x, $y, $times, $speed, $checkProblemAffect, $iRetryCount)
	$g_bTogglePauseAllowed = $wasAllowed
	Return SetError(@error, @extended, $Result)
EndFunc   ;==>AndroidFastClick

Func _AndroidFastClick($x, $y, $times = 1, $speed = 0, $checkProblemAffect = True, $iRetryCount = 0)
	Local $_SilentSetLog = $g_bSilentSetLog
	Local $hDuration = TimerInit()
	If $times < 1 Then Return SetError(0, 0)
	Local $i = 0, $j = 0
	Local $Click = [$x, $y, "down-up"]
	Local $ReleaseClicks = ($x = -1 And $y = -1 And $g_aiAndroidAdbClicks[0] > 0)
	If $ReleaseClicks = False And $g_aiAndroidAdbClicks[0] > -1 Then
		Local $pos = $g_aiAndroidAdbClicks[0]
		$g_aiAndroidAdbClicks[0] = $pos + $times
		ReDim $g_aiAndroidAdbClicks[$g_aiAndroidAdbClicks[0] + 1]
		For $i = 1 To $times
			$g_aiAndroidAdbClicks[$pos + $i] = $Click
		Next
		If $g_iDebugSetlog = 1 Or $g_iDebugClick = 1 Then
			$g_bSilentSetLog = True
			SetDebugLog("Hold back click (" & $x & "/" & $y & " * " & $times & "): queue size = " & $g_aiAndroidAdbClicks[0], $COLOR_ERROR)
			$g_bSilentSetLog = $_SilentSetLog
		EndIf
		Return
	EndIf

	$x = Int($x)
	$y = Int($y)
	Local $wasRunState = $g_bRunState
	Local $hostPath = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder
	Local $androidPath = $g_sAndroidPicturesPath & StringReplace($g_sAndroidPicturesHostFolder, "\", "/")

	If $hostPath = "" Or $androidPath = "" Then
		If $hostPath = "" Then
			SetLog($g_sAndroidEmulator & " shared folder not configured for host", $COLOR_ERROR)
		Else
			SetLog($g_sAndroidEmulator & " shared folder not configured for Android", $COLOR_ERROR)
		EndIf
		SetLog($g_sAndroidEmulator & " shared folder not configured for Android", $COLOR_ERROR)
		$g_bAndroidAdbClick = False
		SetLog("Disabled " & $g_sAndroidEmulator & " ADB fast mouse click", $COLOR_ERROR)
		Return SetError(1, 0)
	EndIf

	AndroidAdbLaunchShellInstance($wasRunState)
	#cs
		If @error <> 0 Then
		Local $error = @error
		;SetDebugLog("Disabled " & $g_sAndroidEmulator & " ADB fast mouse click, error " & $error & " (AndroidAdbLaunchShellInstance)" , $COLOR_ERROR)
		;$g_bAndroidAdbClick = False
		$g_bSilentSetLog = True
		SetDebugLog("Cannot use ADB fast mouse click, error " & $error & " (#Err0001)" , $COLOR_ERROR)
		$g_bSilentSetLog = $_SilentSetLog
		Return SetError($error, 0)
		EndIf
	#ce
	Local $sBotTitleEx = StringRegExpReplace($g_sBotTitle, '[/:*?"<>|]', '_')
	Local $Filename = GetSecureFilename($sBotTitleEx & ".click")
	Local $record = "byte[16];"
	Local $records = ""
	Local $loops = 1
	Local $remaining = 0
	Local $adjustSpeed = 0
	Local $timer = TimerInit()
	If $times > $g_iAndroidAdbClickGroup Then
		$speed = $g_iAndroidAdbClickGroupDelay
		$remaining = Mod($times, $g_iAndroidAdbClickGroup)
		$loops = Int($times / $g_iAndroidAdbClickGroup) + ($remaining > 0 ? 1 : 0)
		$times = $g_iAndroidAdbClickGroup
	Else
		If $ReleaseClicks = False Then $adjustSpeed = $speed
		$speed = 0 ; no need for speed now!
	EndIf
	Local $recordsNum = 10
	Local $recordsClicks = ($times < $g_iAndroidAdbClickGroup ? $times : $g_iAndroidAdbClickGroup)
	For $i = 1 To $recordsNum * $recordsClicks
		$records &= $record
	Next

	If $ReleaseClicks = True Then
		If $g_iDebugSetlog = 1 Or $g_iDebugClick = 1 Then SetDebugLog("Release clicks: queue size = " & $g_aiAndroidAdbClicks[0])
	Else
		Execute($g_sAndroidEmulator & "AdjustClickCoordinates($x,$y)")
	EndIf

	;SetDebugLog("AndroidFastClick(" & $x & "," & $y & "):" & $s)
	Local $data = DllStructCreate($records)
	For $i = 0 To $recordsClicks - 1
		DllStructSetData($data, 1 + $i * $recordsNum, Binary("0x000000000000000001004a0101000000")) ; BTN_TOUCH DOWN
		DllStructSetData($data, 2 + $i * $recordsNum, Binary("0x000000000000000003003a0001000000")) ; ABS_MT_PRESSURE 1
		;DllStructSetData($data, 3 + $i * $recordsNum, Binary("0x000000000000000003003500" & StringRight(Hex($x, 4),2) & StringLeft(Hex($x, 4),2) & "0000")) ; ABS_MT_POSITION_X
		;DllStructSetData($data, 4 + $i * $recordsNum, Binary("0x000000000000000003003600" & StringRight(Hex($y, 4),2) & StringLeft(Hex($y, 4),2) & "0000")) ; ABS_MT_POSITION_Y
		DllStructSetData($data, 5 + $i * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
		DllStructSetData($data, 6 + $i * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
		DllStructSetData($data, 7 + $i * $recordsNum, Binary("0x000000000000000001004a0100000000")) ; BTN_TOUCH UP
		DllStructSetData($data, 8 + $i * $recordsNum, Binary("0x000000000000000003003a0000000000")) ; ABS_MT_PRESSURE 0
		DllStructSetData($data, 9 + $i * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
		DllStructSetData($data, 10 + $i * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
	Next
	;SetDebugLog("AndroidFastClick: $times=" & $times & ", $loops=" & $loops & ", $remaining=" & $remaining)
	Local $AdbStatsType = 1 ; click stats
	Local $data2 = DllStructCreate("byte[" & DllStructGetSize($data) & "]", DllStructGetPtr($data))
	Local $hFileOpen = 0
	Local $iToWrite = DllStructGetSize($data2)
	Local $iWritten = 0
	Local $sleep = ""
	Local $timeSlept = 0
	If $speed > 0 Then
		$sleep = "/system/xbin/sleep " & ($speed / 1000) ; use busy box sleep as it supports milliseconds (if available!)
	EndIf
	For $i = 1 To $loops
		If IsKeepClicksActive(False) = False Then
			If $checkProblemAffect = True Then
				If isProblemAffect(True) Then
					SetDebugLog("VOIDED Click " & $x & "," & $y & "," & $times & "," & $speed, $COLOR_ERROR, "Verdana", "7.5", 0)
					checkMainScreen(False)
					Return ; if need to clear screen do not click
				EndIf
			EndIf
		EndIf
		If $i = $loops And $remaining > 0 Then ; last block with less clicks, create new file
			$iToWrite = (16 * $recordsNum) * $remaining
			$recordsClicks = $remaining
			$hFileOpen = 0
		ElseIf $ReleaseClicks = True Then
			$hFileOpen = 0
		EndIf
		If $hFileOpen = 0 Then
			;$hFileOpen = FileOpen($hostPath & $filename, $FO_BINARY  + $FO_OVERWRITE)
			;FileWrite($hFileOpen, DllStructGetData($data2,1))
			;FileClose($hFileOpen)
			Local $timer = TimerInit()
			While $hFileOpen = 0 And TimerDiff($timer) < 3000
				$hFileOpen = _WinAPI_CreateFile($hostPath & $Filename, 1, 4)
				If $hFileOpen <> 0 Then ExitLoop
				SetDebugLog("Error " & _WinAPI_GetLastError() & " (" & Round(TimerDiff($timer)) & "ms) creating " & $hostPath & $Filename, $COLOR_ERROR)
				Sleep(10)
			WEnd
			If $hFileOpen = 0 Then
				Local $error = _WinAPI_GetLastError()
				SetLog("Error creating " & $hostPath & $Filename, $COLOR_ERROR)
				SetError($error)
				ExitLoop
				#cs
					SetLog("Disabled " & $g_sAndroidEmulator & " ADB fast mouse click due to error " & $error & " (#Err0002)", $COLOR_ERROR)
					$g_bAndroidAdbClick = False
					_WinAPI_CloseHandle($hFileOpen)
					Return SetError($error, 0)
				#ce
			EndIf
			;SetDebugLog("AndroidFastClick: $times=" & $times & ", $loops=" & $loops & ", $remaining=" & $remaining)
			For $j = 0 To $recordsClicks - 1
				Local $BTN_TOUCH_DOWN = True
				Local $BTN_TOUCH_UP = True
				If $ReleaseClicks = True Then
					$Click = $g_aiAndroidAdbClicks[($i - 1) * $recordsNum + $j + 1]
					$x = $Click[0]
					$y = $Click[1]
					Execute($g_sAndroidEmulator & "AdjustClickCoordinates($x,$y)")
					Local $up_down = $Click[2]
					$BTN_TOUCH_DOWN = StringInStr($up_down, "down") > 0
					$BTN_TOUCH_UP = StringInStr($up_down, "up") > 0
				EndIf
				#cs
					DllStructSetData($data, 1 + $i * $recordsNum, Binary("0x000000000000000001004a0101000000")) ; BTN_TOUCH DOWN
					DllStructSetData($data, 2 + $i * $recordsNum, Binary("0x000000000000000003003a0001000000")) ; ABS_MT_PRESSURE 1
					;DllStructSetData($data, 3 + $i * $recordsNum, Binary("0x000000000000000003003500" & StringRight(Hex($x, 4),2) & StringLeft(Hex($x, 4),2) & "0000")) ; ABS_MT_POSITION_X
					;DllStructSetData($data, 4 + $i * $recordsNum, Binary("0x000000000000000003003600" & StringRight(Hex($y, 4),2) & StringLeft(Hex($y, 4),2) & "0000")) ; ABS_MT_POSITION_Y
					DllStructSetData($data, 5 + $i * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
					DllStructSetData($data, 6 + $i * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
					DllStructSetData($data, 7 + $i * $recordsNum, Binary("0x000000000000000001004a0100000000")) ; BTN_TOUCH UP
					DllStructSetData($data, 8 + $i * $recordsNum, Binary("0x000000000000000003003a0000000000")) ; ABS_MT_PRESSURE 0
					DllStructSetData($data, 9 + $i * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
					DllStructSetData($data,10 + $i * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
				#ce
				If $BTN_TOUCH_DOWN Then
					;DllStructSetData($data, 1 + $j * $recordsNum, Binary("0x000000000000000001004a0101000000")) ; BTN_TOUCH DOWN
				Else
					DllStructSetData($data, 1 + $j * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
					DllStructSetData($data, 2 + $j * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
				EndIf
				DllStructSetData($data, 3 + $j * $recordsNum, Binary("0x000000000000000003003500" & StringRight(Hex($x, 4), 2) & StringLeft(Hex($x, 4), 2) & "0000")) ; ABS_MT_POSITION_X
				DllStructSetData($data, 4 + $j * $recordsNum, Binary("0x000000000000000003003600" & StringRight(Hex($y, 4), 2) & StringLeft(Hex($y, 4), 2) & "0000")) ; ABS_MT_POSITION_Y
				If $BTN_TOUCH_UP Then
					;DllStructSetData($data, 6 + $j * $recordsNum, Binary("0x000000000000000001004a0100000000")) ; BTN_TOUCH UP
				Else
					DllStructSetData($data, 7 + $j * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
					DllStructSetData($data, 8 + $j * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
				EndIf
			Next
			_WinAPI_WriteFile($hFileOpen, DllStructGetPtr($data2), $iToWrite, $iWritten)
			If $hFileOpen = 0 Then
				Local $error = _WinAPI_GetLastError()
				SetLog("Error writing " & $hostPath & $Filename, $COLOR_ERROR)
				SetError($error)
				ExitLoop
				#cs
					SetLog("Disabled " & $g_sAndroidEmulator & " ADB fast mouse click due to error " & $error & " (#Err0003)", $COLOR_ERROR)
					$g_bAndroidAdbClick = False
					Return SetError($error, 0)
				#ce
			EndIf
			_WinAPI_CloseHandle($hFileOpen)
		EndIf
		If $loops > 1 Then
			AndroidMoveMouseAnywhere()
		EndIf
		$g_bSilentSetLog = True
		AndroidAdbSendShellCommand("dd if=""" & $androidPath & $Filename & """ of=" & $g_sAndroidMouseDevice & " obs=" & $iToWrite & ">/dev/null 2>&1", Default)
		If BitAND($AndroidSecureFlags, 2) = 2 Then
			; delete file
			FileDelete($hostPath & $Filename)
		EndIf
		$g_bSilentSetLog = $_SilentSetLog
		Local $sleepTimer = TimerInit()
		If $speed > 0 Then
			; speed was overwritten with $g_iAndroidAdbClickGroupDelay
			;AndroidAdbSendShellCommand($sleep)
			Local $sleepTime = $speed - TimerDiff($sleepTimer)
			If $sleepTime > 0 Then _Sleep($sleepTime, False)
		EndIf
		If $adjustSpeed > 0 Then
			; wait remaining time
			Local $wait = Round($adjustSpeed - TimerDiff($timer))
			If $wait > 0 Then
				If $g_iDebugSetlog = 1 Or $g_iDebugClick = 1 Then
					$g_bSilentSetLog = True
					SetDebugLog("AndroidFastClick: Sleep " & $wait & " ms.")
					$g_bSilentSetLog = $_SilentSetLog
				EndIf
				_Sleep($wait, False)
			EndIf
		EndIf
		$timeSlept += TimerDiff($sleepTimer)
		If $g_bRunState = False Then ExitLoop
		If $__TEST_ERROR_SLOW_ADB_CLICK_DELAY > 0 Then Sleep($__TEST_ERROR_SLOW_ADB_CLICK_DELAY)
		;If $speed > 0 Then Sleep($speed)
	Next
	If @error <> 0 Then
		Local $error = @error
		If $iRetryCount < 10 Then
			SetError(0, 0, 0)
			SetDebugLog("ADB retry sending mouse click in 1000 ms. (restarting ADB session)", $COLOR_ACTION)
			_Sleep(1000)
			AndroidAdbTerminateShellInstance()
			AndroidAdbLaunchShellInstance($wasRunState)
			Return AndroidFastClick($x, $y, $times, $speed, $checkProblemAffect, $iRetryCount + 1)
		EndIf
		If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] < 10 Then
			SetLog("Disabled " & $g_sAndroidEmulator & " ADB fast mouse click due to error " & $error & " (#Err0004)", $COLOR_ERROR)
			$g_bAndroidAdbClick = False
		Else
			; reboot Android
			SetLog("Rebooting " & $g_sAndroidEmulator & " due to problems sending mouse click", $COLOR_ERROR)
			Local $_NoFocusTampering = $g_bNoFocusTampering
			$g_bNoFocusTampering = True
			RebootAndroid()
			$g_bNoFocusTampering = $_NoFocusTampering
		EndIf
		Return SetError($error, 0)
	EndIf
	If IsKeepClicksActive(False) = False Then ; Invalidate ADB screencap (not when troops are deployed to speed up clicks)
		$g_iAndroidAdbScreencapTimer = 0 ; invalidate ADB screencap timer/timeout
	EndIf

	; update total stats
	Local $duration = Round((TimerDiff($hDuration) - $timeSlept) / $loops)
	$g_aiAndroidAdbStatsTotal[$AdbStatsType][0] += 1
	$g_aiAndroidAdbStatsTotal[$AdbStatsType][1] += $duration
	Local $iLastCount = UBound($g_aiAndroidAdbStatsLast, 2) - 2
	; Last 10 screencap durations, 0 is sum of durations, 1 is 0-based index to oldest, 2-11 last 10 durations
	If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] <= $iLastCount Then
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] += $duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][$g_aiAndroidAdbStatsTotal[$AdbStatsType][0] + 1] = $duration
		If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] = $iLastCount Then $g_aiAndroidAdbStatsLast[$AdbStatsType][1] = 0 ; init last index
	Else
		Local $iLastIdx = $g_aiAndroidAdbStatsLast[$AdbStatsType][1] + 2
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] -= $g_aiAndroidAdbStatsLast[$AdbStatsType][$iLastIdx] ; remove last duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] += $duration ; add current duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][$iLastIdx] = $duration ; update current duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][1] = Mod($g_aiAndroidAdbStatsLast[$AdbStatsType][1] + 1, $iLastCount) ; update oldest index
	EndIf
	If $g_aiAndroidAdbStatsLast[$AdbStatsType][1] = 0 Then
		Local $totalAvg = Round($g_aiAndroidAdbStatsTotal[$AdbStatsType][1] / $g_aiAndroidAdbStatsTotal[$AdbStatsType][0])
		Local $lastAvg = Round($g_aiAndroidAdbStatsLast[$AdbStatsType][0] / $iLastCount)
		If $g_iDebugSetlog = 1 Or $g_iDebugClick = 1 Or Mod($g_aiAndroidAdbStatsTotal[$AdbStatsType][0], 100) = 0 Then
			SetDebugLog("AndroidFastClick: " & $totalAvg & "/" & $lastAvg & "/" & $duration & " ms (all/" & $iLastCount & "/1), $x=" & $x & ", $y=" & $y & ", $times=" & $times & ", $speed = " & $speed & ", $checkProblemAffect=" & $checkProblemAffect)
		EndIf
	EndIf
EndFunc   ;==>_AndroidFastClick

Func AndroidSendText($sText, $SymbolFix = False, $wasRunState = $g_bRunState)
	AndroidAdbLaunchShellInstance($wasRunState)
	Local $error = @error
	If $error = 0 Then
		; replace space with %s and remove/replace umlaut and non-english characters
		; still ? and * will be treated as file wildcards... might need to be replaced as well
		Local $newText = StringReplace($sText, " ", "%s")
		$newText = StringRegExpReplace($newText, "[^A-Za-z0-9\.,\?""!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]`~]", ".")
		If @extended <> 0 Then
			If $SymbolFix = False Then SetDebugLog("Cannot use ADB to send input text, use Windows method", $COLOR_ERROR)
			Return SetError(10, 0)
		EndIf
		If $SymbolFix = False Then
			If $g_iAndroidAdbInputWordsCharLimit = 0 Then
				AndroidAdbSendShellCommand("input text " & $newText, Default, $wasRunState)
			Else
				; send one character per command
				$newText = StringReplace($newText, "%s", " ")
				Local $words = StringSplit($newText, " ")
				Local $i, $word
				For $i = 1 To $words[0]
					$word = $words[$i]
					While StringLen($word) > 0
						; first send just an empty space
						AndroidAdbSendShellCommand("input text " & StringLeft($word, $g_iAndroidAdbInputWordsCharLimit), Default, $wasRunState)
						$word = StringMid($word, $g_iAndroidAdbInputWordsCharLimit + 1)
					WEnd
					If $i < $words[0] Then AndroidAdbSendShellCommand("input text %s", Default, $wasRunState) ; send space
				Next
			EndIf
		Else
			AndroidAdbSendShellCommand("input text %s", Default, $wasRunState)
		EndIf
		SetError(0, 0)
	Else
		If $SymbolFix = False Then
			SetDebugLog("Disabled " & $g_sAndroidEmulator & " ADB input due to error", $COLOR_ERROR)
			$g_bAndroidAdbInput = False
		EndIf
		Return SetError($error, 0)
	EndIf
EndFunc   ;==>AndroidSendText

Func AndroidSwipeNotWorking($x1, $y1, $x2, $y2, $wasRunState = $g_bRunState) ; This swipe is not working... but might in future with same fixing...
	$x1 = Int($x1)
	$y1 = Int($y1)
	$x2 = Int($x2)
	$y2 = Int($y2)
	If $g_bAndroidAdbClick = False Then
		Return SetError(-1, 0)
	EndIf
	AndroidAdbLaunchShellInstance($wasRunState)
	If @error = 0 Then
		ReleaseClicks()
		ReDim $g_aiAndroidAdbClicks[11]
		$g_aiAndroidAdbClicks[0] = 10
		Local $Click = [$x1, $y1, "down"]
		$g_aiAndroidAdbClicks[1] = $Click
		For $i = 1 To 8
			Local $Click = [$x1 + Int($i * ($x2 - $x1) / 9), $y1 + Int($i * ($y2 - $y1) / 9), ""]
			$g_aiAndroidAdbClicks[$i + 1] = $Click
		Next
		Local $Click = [$x2, $y2, "up"]
		$g_aiAndroidAdbClicks[10] = $Click
		SetDebugLog("AndroidSwipe: " & $x1 & "," & $y1 & "," & $x2 & "," & $y2)
		ReleaseClicks(0, True)
		Return SetError(@error, 0)
	Else
		Local $error = @error
		;SetDebugLog("Disabled " & $g_sAndroidEmulator & " ADB input due to error", $COLOR_ERROR)
		;$g_bAndroidAdbInput = False
		Return SetError($error, 0)
	EndIf
EndFunc   ;==>AndroidSwipeNotWorking

Func AndroidInputSwipe($x1, $y1, $x2, $y2, $wasRunState = $g_bRunState) ; Not used anymore, see AndroidClickDrag
	AndroidAdbLaunchShellInstance($wasRunState)
	If @error = 0 Then
		AndroidAdbSendShellCommand("input swipe " & $x1 & " " & $y1 & " " & $x2 & " " & $y2, Default, $wasRunState)
		SetError(0, 0)
	Else
		Local $error = @error
		SetDebugLog("Disabled " & $g_sAndroidEmulator & " ADB input due to error", $COLOR_ERROR)
		$g_bAndroidAdbInput = False
		Return SetError($error, 0)
	EndIf
EndFunc   ;==>AndroidInputSwipe

Func SuspendAndroid($SuspendMode = True, $bDebugLog = True, $bForceSuspendAndroid = False)
	If $g_bAndroidSuspendedEnabled = False And $bForceSuspendAndroid = False Then Return False
	If $SuspendMode = False Then Return ResumeAndroid($bDebugLog, $bForceSuspendAndroid)
	If $g_bAndroidSuspended = True Then Return True
	Local $pid = GetAndroidSvcPid()
	If $pid = -1 Or $pid = 0 Then $pid = GetAndroidPid()
	If $pid = -1 Or $pid = 0 Then Return False
	$g_bAndroidSuspended = True
	_ProcessSuspendResume($pid, True) ; suspend Android
	$g_iAndroidSuspendedTimer = TimerInit()
	If $bDebugLog = True Then SetDebugLog("Android Suspended")
	Return False
EndFunc   ;==>SuspendAndroid

Func ResumeAndroid($bDebugLog = True, $bForceSuspendAndroid = False)
	If $g_bAndroidSuspendedEnabled = False And $bForceSuspendAndroid = False Then Return False
	If $g_bAndroidSuspended = False Then Return False
	Local $pid = GetAndroidSvcPid()
	If $pid = -1 Or $pid = 0 Then $pid = GetAndroidPid()
	If $pid = -1 Or $pid = 0 Then Return False
	$g_bAndroidSuspended = False
	_ProcessSuspendResume($pid, False) ; resume Android
	$g_aiAndroidTimeLag[3] += TimerDiff($g_iAndroidSuspendedTimer) ; calculate total suspended time
	If $bDebugLog = True Then SetDebugLog("Android Resumed (total time " & Round($g_aiAndroidTimeLag[3]) & " ms)")
	Return True
EndFunc   ;==>ResumeAndroid

Func AndroidCloseSystemBar()
	If AndroidInvalidState() Then Return False
	Local $wasRunState = $g_bRunState
	AndroidAdbLaunchShellInstance($wasRunState)
	If @error <> 0 Then
		SetLog("Cannot close " & $g_sAndroidEmulator & " System Bar", $COLOR_ERROR)
		Return False
	EndIf
	Local $cmdOutput = AndroidAdbSendShellCommand("service call activity 42 s16 com.android.systemui", Default, $wasRunState, False)
	Local $Result = StringLeft($cmdOutput, 6) = "Result"
	SetDebugLog("Closed " & $g_sAndroidEmulator & " System Bar: " & $Result)
	Return $Result
EndFunc   ;==>AndroidCloseSystemBar

Func AndroidOpenSystemBar($bZygote = False)
	If AndroidInvalidState() Then Return False
	Local $wasRunState = $g_bRunState
	AndroidAdbLaunchShellInstance($wasRunState)
	If @error <> 0 Then
		SetLog("Cannot open " & $g_sAndroidEmulator & " System Bar", $COLOR_ERROR)
		Return False
	EndIf
	Local $cmdOutput
	Local $Result
	If $bZygote = True Then
		$cmdOutput = AndroidAdbSendShellCommand("setprop ctl.restart zygote", Default, $wasRunState, False)
		$Result = $cmdOutput = ""
	Else
		$cmdOutput = AndroidAdbSendShellCommand("am startservice -n com.android.systemui/.SystemUIService", Default, $wasRunState, False)
		$Result = StringLeft($cmdOutput, 16) = "Starting service"
		SetDebugLog("Opened " & $g_sAndroidEmulator & " System Bar: " & $Result)
	EndIf
	Return $Result
EndFunc   ;==>AndroidOpenSystemBar

Func RedrawAndroidWindow()
	Local $Result = Execute("Redraw" & $g_sAndroidEmulator & "Window()")
	If $Result = "" And @error <> 0 Then Return ; Not implemented
	Return $Result
EndFunc   ;==>RedrawAndroidWindow

Func AndroidQueueReboot($bQueueReboot = True)
	$g_bAndroidQueueReboot = $bQueueReboot
EndFunc   ;==>AndroidQueueReboot

Func AndroidInvalidState()
	If $HWnD = 0 Then
		SetDebugLog("AndroidInvalidState: No Window Handle", $COLOR_ERROR)
		Return True
	EndIf
	If IsHWnd($HWnD) And WinGetHandle($HWnD, "") = 0 Then
		SetDebugLog("AndroidInvalidState: Window Handle " & $HWnD & " doesn't exist", $COLOR_ERROR)
		Return True
	EndIf
	If IsHWnd($HWnD) = False And IsNumber($HWnD) And $g_bAndroidBackgroundLaunched = False Then
		SetDebugLog("AndroidInvalidState: PID " & $HWnD & " not supported for Headless Mode", $COLOR_ERROR)
		Return True
	EndIf
	If $g_bAndroidBackgroundLaunched = True And ProcessExists2($HWnD) = 0 Then
		SetDebugLog("AndroidInvalidState: PID " & $HWnD & " doesn't exist", $COLOR_ERROR)
		Return True
	EndIf
	; all seems ok
	Return False
EndFunc   ;==>AndroidInvalidState

Func checkAndroidReboot($bRebootAndroid = True)

	If checkAndroidTimeLag($bRebootAndroid) = True _
			Or checkAndroidPageError($bRebootAndroid) = True Then

		; Reboot Android
		Local $_NoFocusTampering = $g_bNoFocusTampering
		$g_bNoFocusTampering = True
		RebootAndroid()
		$g_bNoFocusTampering = $_NoFocusTampering
		Return True

	EndIf

	Return False

EndFunc   ;==>checkAndroidReboot

Func GetAndroidProcessPID($sPackage = $g_sAndroidGamePackage, $bForeground = True)
	; u0_a58    4395  580   1135308 187040 14    -6    0     0     ffffffff 00000000 S com.supercell.clashofclans
	If AndroidInvalidState() Then Return 0
	Local $cmd = "ps -p|grep """ & $g_sAndroidGamePackage & """"
	Local $output = AndroidAdbSendShellCommand($cmd)
	$output = StringStripWS($output, 7)
	Local $aPkgList[0][26] ; adjust to any suffisent size to accommodate
	Local $iCols
	_ArrayAdd($aPkgList, $output, 0, " ", @LF)
	For $i = 1 To UBound($aPkgList)
		$iCols = _ArraySearch($aPkgList, "", 0, 0, 0, 0, 1, $i, True)
		If $iCols > 9 And $aPkgList[$i - 1][$iCols - 1] = $g_sAndroidGamePackage Then
			; process running
			If $bForeground = True And $aPkgList[$i - 1][8] <> "0" Then
				; not foreground
				SetDebugLog("Android process " & $sPackage & " not running in foreground")
				Return 0
			EndIf
			Return Int($aPkgList[$i - 1][1])
		EndIf
	Next
	SetDebugLog("Android process " & $sPackage & " not running")
	Return 0
EndFunc   ;==>GetAndroidProcessPID

Func HideAndroidWindow($bHide = True)
	ResumeAndroid()
	WinGetAndroidHandle() ; updates android position
	WinGetPos($HWnD)
	If @error <> 0 Then Return SetError(0, 0, 0)

	Execute("Hide" & $g_sAndroidEmulator & "Window($bHide)")
	If $bHide = True Then
		WinMove2($HWnD, "", -32000, -32000)
	ElseIf $bHide = False Then
		WinMove2($HWnD, "", $AndroidPosX, $AndroidPosY)
		WinActivate($HWnD)
	EndIf
EndFunc   ;==>HideAndroidWindow

Func AndroidPicturePathAutoConfig($myPictures = Default, $subDir = Default, $bSetLog = Default)
	If $subDir = Default Then $subDir = $g_sAndroidEmulator & " Photo"
	If $bSetLog = Default Then $bSetLog = True
	Local $Result = False
	Local $path
	If $g_bAndroidPicturesPathAutoConfig = True Then
		If $g_sAndroidPicturesHostPath = "" Then
			If $myPictures = Default Then $myPictures = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\", "My Pictures")
			If @error = 0 And FileExists($myPictures) = 1 Then
				If $subDir <> "" Then $subDir = "\" & $subDir
				$path = $myPictures & $subDir
				; add tailing backslash
				If StringRight($path, 1) <> "\" Then $path &= "\"
				If FileExists($path) = 1 Then
					$g_sAndroidPicturesHostPath = $path
					SetGuiLog("Shared folder: '" & $g_sAndroidPicturesHostPath & "' will be added to " & $g_sAndroidEmulator, $COLOR_SUCCESS, $bSetLog)
					$Result = True
				ElseIf DirCreate($path) = 1 Then
					$g_sAndroidPicturesHostPath = $path
					SetGuiLog("Configure " & $g_sAndroidEmulator & " to support shared folder", $COLOR_SUCCESS, $bSetLog)
					SetGuiLog("Folder created: " & $path, $COLOR_SUCCESS, $bSetLog)
					SetGuiLog("This shared folder will be added to " & $g_sAndroidEmulator, $COLOR_SUCCESS, $bSetLog)
					$Result = True
				Else
					SetGuiLog("Cannot configure " & $g_sAndroidEmulator & " shared folder", $COLOR_SUCCESS, $bSetLog)
					SetGuiLog("Cannot create folder: " & $path, $COLOR_ERROR, $bSetLog)
					$g_bAndroidPicturesPathAutoConfig = False
				EndIf
			Else
				SetGuiLog("Cannot configure " & $g_sAndroidEmulator & " shared folder", $COLOR_SUCCESS, $bSetLog)
				SetGuiLog("Cannot find current user 'My Pictures' folder", $COLOR_ERROR, $bSetLog)
				$g_bAndroidPicturesPathAutoConfig = False
			EndIf
		Else
			$path = $g_sAndroidPicturesHostPath
			If FileExists($path) = 1 Then
				; path exists, nothing to do
			ElseIf DirCreate($path) = 1 Then
				SetGuiLog("Shared folder created: " & $path, $COLOR_SUCCESS, $bSetLog)
			Else
				SetGuiLog("Cannot configure " & $g_sAndroidEmulator & " shared folder", $COLOR_SUCCESS, $bSetLog)
				SetGuiLog("Cannot create folder: " & $path, $COLOR_ERROR, $bSetLog)
				$g_bAndroidPicturesPathAutoConfig = False
			EndIf
		EndIf
	EndIf
	Return $Result
EndFunc   ;==>AndroidPicturePathAutoConfig
