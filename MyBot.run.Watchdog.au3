; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot Watchdog
; Description ...: This file contens the Sequence that runs all MBR Bot
; Author ........: cosote (12-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
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
;#pragma compile(Console, true)
#include "MyBot.run.version.au3"
#pragma compile(ProductName, My Bot Watchdog)
#pragma compile(Out, MyBot.run.Watchdog.exe) ; Required

; Enforce variable declarations
Opt("MustDeclareVars", 1)

#include <APIErrorsConstants.au3>
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
Global Const $g_sLibPath = @ScriptDir & "\lib" ;lib directory contains dll's
Global Const $g_sLibIconPath = $g_sLibPath & "\MBRBOT.dll" ; icon library
Global Enum $eIcnArcher = 1, $eIcnDonArcher, $eIcnBalloon, $eIcnDonBalloon, $eIcnBarbarian, $eIcnDonBarbarian, $eBtnTest, $eIcnBuilder, $eIcnCC, $eIcnGUI
Global $g_WatchDogLogStatusBar = False
Global $g_WatchOnlyClientPID = Default
Global $g_bRunState = True
Global $g_hFrmBot = 0 ; Dummy form for messages
Global $g_iGlobalActiveBotsAllowed = 0 ; Dummy
Global $g_hMutextOrSemaphoreGlobalActiveBots = 0 ; Dummy
Global $g_hStatusBar = 0 ; Dummy
Global $hMutex_BotTitle = 0 ; Mutex handle for this instance
Global $hStarted = 0 ; Timer handle watchdog started
Global $bCloseWhenAllBotsUnregistered = True ; Automatically close watchdog when all bots closed
Global $iTimeoutBroadcast = 15000 ; Milliseconds of sending broadcast messages to bots
Global $iTimeoutCheckBot = 5000 ; Milliseconds bots are checked if restart required
Global $iTimeoutRestartBot = 180000 ; Milliseconds un-responsive bot is launched again
Global $iTimeoutAutoClose = 60000 ; Milliseconds watchdog automatically closed when no bot available, -1 = disabled
Global $hTimeoutAutoClose = 0 ; Timer Handle for $iTimeoutAutoClose
Global $g_bBotLaunchOption_NoBotSlot = True
Global $g_iDebugWindowMessages = 0

Global $hStruct_SleepMicro = DllStructCreate("int64 time;")
Global $pStruct_SleepMicro = DllStructGetPtr($hStruct_SleepMicro)
Global $DELAYSLEEP = 500
Global $g_bDebugSetlog = False
Global $g_bDebugAndroid = False
Global $g_asCmdLine = [0]

; used by API
Global Enum $eLootGold, $eLootElixir, $eLootDarkElixir, $eLootTrophy, $eLootCount
Global $g_aiCurrentLoot[$eLootCount] = [0, 0, 0, 0] ; current stats
Global $g_iStatsTotalGain[$eLootCount] = [0, 0, 0, 0]
Global $g_iStatsLastAttack[$eLootCount] = [0, 0, 0, 0]
Global $g_iStatsBonusLast[$eLootCount] = [0, 0, 0, 0]

; Dummy functions
Func _GUICtrlStatusBar_SetText($a, $b)
EndFunc   ;==>_GUICtrlStatusBar_SetText
Func _GUICtrlStatusBar_SetTextEx($a, $b)
EndFunc   ;==>_GUICtrlStatusBar_SetTextEx
Func GetTranslated($a, $b, $c)
EndFunc   ;==>GetTranslated
Func GetTranslatedFileIni($a, $b, $c)
EndFunc   ;==>GetTranslatedFileIni

Func SetLog($String, $Color = $COLOR_BLACK, $LogPrefix = "L ")
	Local $log = $LogPrefix & TimeDebug() & $String
	_ConsoleWrite($log & @CRLF) ; Always write any log to console
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

Func UpdateManagedMyBot($aBotDetails)
	Return True
EndFunc   ;==>UpdateManagedMyBot

Global $g_sBotTitle = "My Bot Watchdog " & $g_sBotVersion ;~ Don't use any non file name supported characters like \ / : * ? " < > |

Opt("WinTitleMatchMode", 3) ; Window Title exact match mode

#include "COCBot\functions\Other\Api.au3"
#include "COCBot\functions\Other\ApiHost.au3"
#include "COCBot\functions\Other\LaunchConsole.au3"
#include "COCBot\functions\Other\Time.au3"

; Handle Command Line Launch Options and fill $g_asCmdLine
If $CmdLine[0] > 0 Then
	For $i = 1 To $CmdLine[0]
		Switch $CmdLine[$i]
			Case "/console", "/c", "-console", "-c"
				_WinAPI_AllocConsole()
				_WinAPI_SetConsoleIcon($g_sLibIconPath, $eIcnGUI)
			Case Else
				$g_asCmdLine[0] += 1
				ReDim $g_asCmdLine[$g_asCmdLine[0] + 1]
				$g_asCmdLine[$g_asCmdLine[0]] = $CmdLine[$i]
		EndSwitch
	Next
EndIf

; Update Console Window (if it exists)
DllCall("kernel32.dll", "bool", "SetConsoleTitle", "str", "Console " & $g_sBotTitle)

$hMutex_BotTitle = CreateMutex($sWatchdogMutex)
If $hMutex_BotTitle = 0 Then
	;MsgBox($MB_OK + $MB_ICONINFORMATION, $sBotTitle, "My Bot Watchdog is already running.")
	SetLog($g_sBotTitle & " is already running")
	Exit 2
EndIf

; create dummy form for Window Messsaging
$g_hFrmBot = GUICreate($g_sBotTitle, 32, 32)
$hStarted = __TimerInit() ; Timer handle watchdog started
$hTimeoutAutoClose = $hStarted

Local $iExitCode = 0
Local $iActiveBots = 0
While 1
	$iActiveBots = UBound(GetManagedMyBotDetails())
	SetDebugLog("Broadcast query bot state, registered bots: " & $iActiveBots)
	_WinAPI_BroadcastSystemMessage($WM_MYBOTRUN_API, 0x0100 + $iActiveBots, $g_hFrmBot, $BSF_POSTMESSAGE + $BSF_IGNORECURRENTTASK, $BSM_APPLICATIONS)

	Local $hLoopTimer = __TimerInit()
	Local $hCheckTimer = __TimerInit()
	While __TimerDiff($hLoopTimer) < $iTimeoutBroadcast
		_Sleep($DELAYSLEEP)
		If __TimerDiff($hCheckTimer) >= $iTimeoutCheckBot Then
			; check if bot not responding anymore and restart if so
			CheckManagedMyBot($iTimeoutRestartBot)
			$hCheckTimer = __TimerInit()
		EndIf
	WEnd

	; log active bots
	$iActiveBots = GetActiveMyBotCount($iTimeoutBroadcast * 2)
	SetDebugLog("Active bots: " & $iActiveBots)

	; automatically close watchdog when no bot available
	If $iTimeoutAutoClose > -1 And __TimerDiff($hTimeoutAutoClose) > $iTimeoutAutoClose Then
		If UBound(GetManagedMyBotDetails()) = 0 Then
			SetLog("Closing " & $g_sBotTitle & " as no running bot found")
			$iExitCode = 1
			ExitLoop
		EndIf
		$hTimeoutAutoClose = __TimerInit() ; timeout starts again
	EndIf

WEnd

ReleaseMutex($hMutex_BotTitle)
DllClose("ntdll.dll")
Exit ($iExitCode)

; Reference function so stripper is not removing it
UpdateManagedMyBot(True)
