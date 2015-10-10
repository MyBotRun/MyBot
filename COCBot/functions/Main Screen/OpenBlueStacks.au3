; #FUNCTION# ====================================================================================================================
; Name ..........: OpenBS
; Description ...:
; Syntax ........: OpenBS([$bRestart = False])
; Parameters ....: $bRestart            - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: GkevinOD (2014), Hervidero (2015) (orginal open() fucntion)
; Modified ......: KnowJack (Aug2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func OpenBS($bRestart = False)

	Local $hTimer, $iCount = 0
	Local $PID, $BSPath, $ErrorResult
	SetLog("Starting BlueStacks and Clash Of Clans", $COLOR_GREEN)

	Local $BSPath = RegRead("HKLM\SOFTWARE\BlueStacks\", "InstallDir")  ; Get the installed BS location from the registry
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
	While IsArray(ControlGetPos($Title, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")) = False
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

	If IsArray(ControlGetPos($Title, "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")) Then
		SetLog("BlueStacks Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_GREEN)
		$HWnD = WinGetHandle($Title) ; get BS window Handle
		DisableBS($HWnD, $SC_MINIMIZE)
		DisableBS($HWnD, $SC_CLOSE)
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

EndFunc   ;==>OpenBS

Func waitMainScreenMini()
	Local $iCount = 0
	Local $hTimer = TimerInit()
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
