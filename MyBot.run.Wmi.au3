; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot Wmi
; Description ...: This file contens the Sequence that runs all MBR Bot
; Author ........: cosote (03-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; AutoIt pragmas
#NoTrayIcon
#RequireAdmin
#AutoIt3Wrapper_UseX64=7n
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/rsln /MI=3
;/SV=0

#AutoIt3Wrapper_Change2CUI=y
#pragma compile(Console, true)
#include "MyBot.run.version.au3"
#pragma compile(ProductName, My Bot Wmi)
#pragma compile(Out, MyBot.run.Wmi.exe) ; Required

; Enforce variable declarations
Opt("MustDeclareVars", 1)

#include <APIErrorsConstants.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <WinAPISys.au3>
#include <WinAPIProc.au3>
#include <ProcessConstants.au3>
#include <ColorConstants.au3>
#include <Date.au3>

Global $g_sWmiTestApi = ""
Global $g_bRunState = True
Global $g_bDebugSetlog = False
Global $g_bDebugAndroid = False
Global $g_iGlobalActiveBotsAllowed = 0 ; Dummy
Global $g_hMutextOrSemaphoreGlobalActiveBots = 0 ; Dummy
Global $g_bBotLaunchOption_NoBotSlot = True
Global $g_hStatusBar = 0 ; Dummy
Global Const $COLOR_ORANGE = 0xFF7700 ; Used for donate GUI buttons
Global Const $COLOR_ERROR = $COLOR_RED ; Error messages
Global Const $COLOR_WARNING = $COLOR_MAROON ; Warning messages
Global Const $COLOR_INFO = $COLOR_BLUE ; Information or Status updates for user
Global Const $COLOR_SUCCESS = 0x006600 ; Dark Green, Action, method, or process completed successfully
Global Const $COLOR_SUCCESS1 = 0x009900 ; Med green, optional success message for users
Global Const $COLOR_DEBUG = $COLOR_PURPLE ; Purple, basic debug color
Global Const $COLOR_DEBUG1 = 0x7a00cc ; Dark Purple, Debug for successful status checks
Global Const $COLOR_DEBUG2 = 0xaa80ff ; lt Purple, secondary debug color
Global Const $COLOR_DEBUGS = $COLOR_MEDGRAY ; Med Grey, debug color for less important but needed supporting data points in multiple messages
Global Const $COLOR_ACTION = 0xFF8000 ; Med Orange, debug color for individual actions, clicks, etc
Global Const $COLOR_ACTION1 = 0xcc80ff ; Light Purple, debug color for pixel/window checks

Func _Sleep($ms, $iSleep = True, $CheckRunState = True)
	Sleep($ms)
EndFunc   ;==>_Sleep

Func SetLog($String, $Color = $COLOR_BLACK, $LogPrefix = "L ")
	;ConsoleWrite($String & @CRLF) ; Always write any log to console
EndFunc   ;==>SetLog

Func SetDebugLog($String, $Color = $COLOR_DEBUG, $LogPrefix = "D ")
	;Return SetLog($String, $Color, $LogPrefix)
EndFunc   ;==>SetDebugLog

#include "COCBot\functions\Config\DelayTimes.au3"
#include "COCBot\functions\Other\Time.au3"
#include "COCBot\functions\Other\LaunchConsole.au3"

Local $g_oWMI = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
Local $query

If $CmdLine[0] = 1 Then
	$query = $CmdLine[1]
Else
	; list all processes
	$query = "Select " & GetWmiSelectFields() & " from Win32_Process"
EndIf

Local $oProcessColl = GetWmiObject().ExecQuery($query, "WQL", 0x20 + 0x10)

OutputWmiData("<Processes>")
For $Process In $oProcessColl
	OutputWmiData("  <Process>")
	For $sField In $g_WmiFields
		OutputWmiData("    <" & $sField & ">" & Execute("$Process." & $sField) & "</" & $sField & ">")
	Next
	OutputWmiData("  </Process>")
Next
OutputWmiData("</Processes>")

If $g_sWmiTestApi <> "" Then
	; test parsing
	Local $aProcesses = WmiOutputToArray($g_sWmiTestApi)
	ConsoleWrite("Found " & UBound($aProcesses) & " processes" & @CRLF)
	For $aProcess In $aProcesses
		ConsoleWrite("Handle : " & $aProcess[0] & @CRLF)
		ConsoleWrite("ExecutablePath : " & $aProcess[1] & @CRLF)
		ConsoleWrite("CommandLine : " & $aProcess[2] & @CRLF)
	Next
EndIf

If $CmdLine[0] <> 1 Then
	ConsoleWrite(@CRLF & "Press enter to exit . . . ")
	While Not ConsoleRead(True)
		Sleep(10)
	WEnd
EndIf

Exit 0

Func OutputWmiData($s)
	If $g_sWmiTestApi <> "" Then
		$g_sWmiTestApi &= $s & @CRLF
		Return
	EndIf
	ConsoleWrite($s & @CRLF)
EndFunc   ;==>OutputWmiData

; Dummy functions
Func _GUICtrlStatusBar_SetText($a, $b)
EndFunc
Func GetTranslated($a, $b, $c)
EndFunc
Func GetTranslatedFileIni($a, $b, $c)
EndFunc
Func _GUICtrlStatusBar_SetTextEx($hWnd, $sText = "", $iPart = 0, $iUFlag = 0)
EndFunc

