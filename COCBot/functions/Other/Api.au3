; #FUNCTION# ====================================================================================================================
; Name ..........: MyBot.run Bot API functions
; Description ...: Register Windows Message and provides functions to communicate between bots and manage bot application
; Author ........: cosote (12-2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
;                  Read/write memory: https://www.autoitscript.com/forum/topic/104117-shared-memory-variables-demo/
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $sWatchdogMutex = "MyBot.run/ManageFarm"
Global $tagSTRUCT_BOT_STATE = "struct;hwnd frmBot;hwnd HWnD;boolean RunState;boolean TPaused;endstruct"
Global $tBotState = DllStructCreate($tagSTRUCT_BOT_STATE)
Global $WM_MYBOTRUN_API_1_0 = _WinAPI_RegisterWindowMessage("MyBot.run/API/1.0")
;SetDebugLog("MyBot.run/API/1.0 Message = " & $WM_MYBOTRUN_API_1_0)
Global $WM_MYBOTRUN_STATE_1_0 = _WinAPI_RegisterWindowMessage("MyBot.run/STATE/1.0")
;SetDebugLog("MyBot.run/STATE/1.0 Message = " & $WM_MYBOTRUN_STATE_1_0)
