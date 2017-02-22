; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot Watchdog
; Description ...: This file contens the Sequence that runs all MBR Bot
; Author ........: cosote (12-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#NoTrayIcon
#RequireAdmin
#AutoIt3Wrapper_UseX64=7n
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/rsln
#AutoIt3Wrapper_Change2CUI=y
#pragma compile(Console, true)
#pragma compile(Icon, "Images\MyBot.ico")
#pragma compile(FileDescription, Clash of Clans Bot - A Free Clash of Clans bot - https://mybot.run)
#pragma compile(ProductName, My Bot Watchdog)
#pragma compile(ProductVersion, 7.0)
#pragma compile(FileVersion, 7.0)
#pragma compile(LegalCopyright, © https://mybot.run)
#pragma compile(Out, MyBot.run.Watchdog.exe) ; Required

;#include <WindowsConstants.au3>
;#include <WinAPI.au3>
#include <WinAPIProc.au3>
#include <WinAPISys.au3>
#include <Misc.au3>
#include <ColorConstants.au3>
#include <Date.au3>
#include <Array.au3>

Global $hNtDll = DllOpen("ntdll.dll")

Global Const $COLOR_ERROR = $COLOR_RED ; Error messages
Global Const $COLOR_WARNING = $COLOR_MAROON ; Warning messages
Global Const $COLOR_INFO = $COLOR_BLUE ; Information or Status updates for user
Global Const $COLOR_SUCCESS = 0x006600 ; Dark Green, Action, method, or process completed successfully
Global Const $COLOR_DEBUG = $COLOR_PURPLE ; Purple, basic debug color

; Global Variables
Global $frmBot = 0 ; Dummy form for messages
Global $hMutex_BotTitle = 0 ; Mutex handle for this instance
Global $hStarted = 0 ; Timer handle watchdog started
Global $bCloseWhenAllBotsUnregistered = True ; Automatically close watchdog when all bots closed
Global $iTimeoutBroadcast = 15000 ; Milliseconds of sending broadcast messages to bots
Global $iTimeoutCheckBot = 5000 ; Milliseconds bots are checked if restart required
Global $iTimeoutRestartBot = 120000 ; Milliseconds un-responsive bot is launched again
Global $iTimeoutAutoClose = 60000 ; Milliseconds watchdog automatically closed when no bot available, -1 = disabled
Global $hTimeoutAutoClose = 0 ; Timer Handle for $iTimeoutAutoClose

Global $hStruct_SleepMicro = DllStructCreate("int64 time;")
Global $pStruct_SleepMicro = DllStructGetPtr($hStruct_SleepMicro)
Global $iDelaySleep = 500
Global $g_iDebugSetlog = 0

Func SetLog($String, $Color = $COLOR_BLACK, $LogPrefix = "L ")
	Local $log = $LogPrefix & TimeDebug() & $String
	ConsoleWrite($log & @CRLF) ; Always write any log to console
EndFunc   ;==>SetLog

Func SetDebugLog($String, $Color = $COLOR_DEBUG, $LogPrefix = "D ")
	Return SetLog($String, $Color, $LogPrefix)
EndFunc   ;==>SetDebugLog

Func _Sleep($ms, $iSleep = True, $CheckRunState = True)
	_SleepMilli($ms)
EndFunc   ;==>_Sleep

Func _SleepMicro($iMicroSec)
	;Local $hStruct_SleepMicro = DllStructCreate("int64 time;")
	;Local $pStruct_SleepMicro = DllStructGetPtr($hStruct_SleepMicro)
    DllStructSetData($hStruct_SleepMicro, "time", $iMicroSec * -10)
    DllCall($hNtDll, "dword", "ZwDelayExecution", "int", 0, "ptr", $pStruct_SleepMicro)
	;$hStruct_SleepMicro = 0
EndFunc   ;==>_SleepMicro

Func _SleepMilli($iMilliSec)
	_SleepMicro(Int($iMilliSec * 1000))
EndFunc   ;==>_SleepMilli

If @AutoItX64 = 1 Then
	MsgBox(0, "", "Don't Run/Compile the Script as (x64)! try to Run/Compile the Script as (x86) to get the bot to work." & @CRLF & _
			"If this message still appears, try to re-install AutoIt.")
	Exit
EndIf

If Not FileExists(@ScriptDir & "\License.txt") Then
	$license = InetGet("http://www.gnu.org/licenses/gpl-3.0.txt", @ScriptDir & "\License.txt")
EndIf

$sBotVersion = "v7.0" ;~ Don't add more here, but below. Version can't be longer than vX.y.z because it it also use on Checkversion()
$sBotTitle = "My Bot Watchdog " & $sBotVersion & " " ;~ Don't use any non file name supported characters like \ / : * ? " < > |

Opt("WinTitleMatchMode", 3) ; Window Title exact match mode

#include "COCBot\functions\Other\Api.au3"
#include "COCBot\functions\Other\ApiHost.au3"
#include "COCBot\functions\Other\Synchronization.au3"
#include "COCBot\functions\Other\LaunchConsole.au3"
#include "COCBot\functions\Other\Time.au3"

$hMutex_BotTitle = _Singleton($sWatchdogMutex, 1)
If $hMutex_BotTitle = 0 Then
	;MsgBox($MB_OK + $MB_ICONINFORMATION, $sBotTitle, "My Bot Watchdog is already running.")
	Exit
EndIf

; create dummy form for Window Messsaging
$frmBot = GUICreate($sBotTitle, 32, 32)
$hStarted = TimerInit() ; Timer handle watchdog started
$hTimeoutAutoClose = $hStarted

Local $iExitCode = 0
While 1
	SetDebugLog("Broadcast query bot state, registered bots: " & UBound(GetManagedMyBotDetails()))
	_WinAPI_BroadcastSystemMessage($WM_MYBOTRUN_API_1_0, 0, $frmBot, $BSF_POSTMESSAGE + $BSF_IGNORECURRENTTASK, $BSM_APPLICATIONS)

	Local $hLoopTimer = TimerInit()
	Local $hCheckTimer = TimerInit()
	While TimerDiff($hLoopTimer) < $iTimeoutBroadcast
		_Sleep($iDelaySleep)
		If TimerDiff($hCheckTimer) >= $iTimeoutCheckBot Then
			; check if bot not responding anymore and restart if so
			CheckManagedMyBot($iTimeoutRestartBot)
			$hCheckTimer = TimerInit()
		EndIf
	WEnd

	; log active bots
	SetDebugLog("Active bots: " & GetActiveMyBotCount($iTimeoutBroadcast + 3000))

	; automatically close watchdog when no bot available
	If $iTimeoutAutoClose > -1 And TimerDiff($hTimeoutAutoClose) > $iTimeoutAutoClose Then
		If UBound(GetManagedMyBotDetails()) = 0 Then
			SetLog("Closing " & $sBotTitle & "as no running bot found")
			$iExitCode = 1
		EndIf
		$hTimeoutAutoClose = TimerInit() ; timeout starts again
	EndIf

WEnd

DllClose("ntdll.dll")
Exit($iExitCode)
