; #FUNCTION# ====================================================================================================================
; Name ..........: MBRFunc, debugMBRFunctions
; Description ...: MBRFunc will open or close the MyBot.run.dll, debugMBRFunctions will set the debug levels.
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Didipe (2015)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func MBRFunc($Start = True)
	Switch $Start
		Case True
			$g_hLibNTDLL = DllOpen("ntdll.dll")
			$g_hLibUser32DLL = DllOpen("user32.dll")
			$g_hLibMyBot = DllOpen($g_sLibMyBotPath)
			;$g_hLibImgLoc = DllOpen($g_sLibImgLocPath)
			$g_hLibImgLoc = $g_hLibMyBot
			If $g_hLibMyBot = -1 Then
				Setlog($g_sMBRLib & " not found.", $COLOR_ERROR)
				Return False
			EndIf
			SetDebugLog($g_sMBRLib & " opened.")
		Case False
			DllClose($g_hLibNTDLL)
			DllClose($g_hLibUser32DLL)
			DllClose($g_hLibMyBot)
			;DllClose($g_hLibImgLoc)
			SetDebugLog($g_sMBRLib & " closed.")
	EndSwitch
EndFunc   ;==>MBRFunc

Func debugMBRFunctions($g_iDebugSearchArea = 0, $g_iDebugRedArea = 0, $g_iDebugOcr = 0)
	SetDebugLog("debugMBRFunctions: $g_iDebugSearchArea=" & $g_iDebugSearchArea & ", $g_iDebugRedArea=" & $g_iDebugRedArea & ", $g_iDebugOcr=" & $g_iDebugOcr)
	Local $activeHWnD = WinGetHandle("")
	Local $result = DllCall($g_hLibMyBot, "str", "setGlobalVar", "int", $g_iDebugSearchArea, "int", $g_iDebugRedArea, "int", $g_iDebugOcr)
	If @error Then
		_logErrorDLLCall($g_sLibMyBotPath & ", setGlobalVar:", @error)
		Return SetError(@error)
	EndIf
	;dll return 0 on success, -1 on error
	If IsArray($result) Then
		If $g_iDebugSetlog = 1 And $result[0] = -1 Then SetLog($g_sMBRLib & " error setting Global vars.", $COLOR_DEBUG)
	Else
		SetDebugLog($g_sMBRLib & " not found.", $COLOR_ERROR)
	EndIf
	WinActivate($activeHWnD) ; restore current active window
EndFunc   ;==>debugMBRFunctions

Func setAndroidPID($pid = GetAndroidPid())
	If $g_hLibMyBot = -1 Then Return ; Bot didn't finish launch yet
	SetDebugLog("setAndroidPID: $pid=" & $pid)
	Local $result = DllCall($g_hLibMyBot, "str", "setAndroidPID", "int", $pid)
	If @error Then
		_logErrorDLLCall($g_sLibMyBotPath & ", setAndroidPID:", @error)
		Return SetError(@error)
	EndIf
	;dll return 0 on success, -1 on error
	If IsArray($result) Then
		If $result[0] = "" Then
			SetDebugLog($g_sMBRLib & " error setting Android PID.")
		Else
			SetDebugLog("Android PID=" & $pid & " initialized: " & $result[0])
			debugMBRFunctions($g_iDebugSearchArea, $g_iDebugRedArea, $g_iDebugOcr) ; set debug levels
		EndIf
	Else
		SetDebugLog($g_sMBRLib & " not found.", $COLOR_ERROR)
	EndIf
EndFunc   ;==>setAndroidPID

Func setVillageOffset($x, $y, $z)
	DllCall($g_hLibMyBot, "str", "setVillageOffset", "int", $x, "int", $y, "float", $z)
	DllCall($g_hLibImgLoc, "str", "setVillageOffset", "int", $x, "int", $y, "float", $z) ;set values in imgloc also
	$g_iVILLAGE_OFFSET[0] = $x
	$g_iVILLAGE_OFFSET[1] = $y
	$g_iVILLAGE_OFFSET[2] = $z
EndFunc   ;==>setVillageOffset

Func setMaxDegreeOfParallelism($iMaxDegreeOfParallelism = -1)
	DllCall($g_hLibImgLoc, "none", "setMaxDegreeOfParallelism", "int", $iMaxDegreeOfParallelism) ;set PARALLELOPTIONS.MaxDegreeOfParallelism for multi-threaded operations
EndFunc   ;==>setMaxDegreeOfParallelism

Func setGcCollectTotalMemoryPreasure($iGcCollectTotalMemoryPreasure = 0)
	DllCall($g_hLibImgLoc, "none", "setGcCollectTotalMemoryPreasure", "int", $iGcCollectTotalMemoryPreasure) ;set Heap preasure, when exceeded, calls GC.Collect() in ImageDispose, 0 to disable, 32 * 1024 * 1024 (32MB) good value to keep heap small
EndFunc   ;==>setGcCollectTotalMemoryPreasure

Func ConvertVillagePos(ByRef $x, ByRef $y, $zoomfactor = 0)
	If $g_hLibMyBot = -1 Then Return ; Bot didn't finish launch yet
	Local $result = DllCall($g_hLibMyBot, "str", "ConvertVillagePos", "int", $x, "int", $y, "float", $zoomfactor)
	if Isarray($result) = False  then
	   if $g_iDebugSetlog=1 then Setlog("ConvertVillagePos result error", $COLOR_ERROR)
	   Return ;exit if
    EndIf
	Local $a = StringSplit($result[0], "|")
	If UBound($a) < 3 Then Return
	$x = Int($a[1])
	$y = Int($a[2])
EndFunc   ;==>ConvertVillagePos

Func ConvertToVillagePos(ByRef $x, ByRef $y, $zoomfactor = 0)
	If $g_hLibMyBot = -1 Then Return ; Bot didn't finish launch yet
	Local $result = DllCall($g_hLibMyBot, "str", "ConvertToVillagePos", "int", $x, "int", $y, "float", $zoomfactor)
	if Isarray($result) = False  then
	   if $g_iDebugSetlog=1 then Setlog("ConvertToVillagePos result error", $COLOR_ERROR)
	   Return ;exit if
    EndIf
	Local $a = StringSplit($result[0], "|")
	If UBound($a) < 3 Then Return
	$x = Int($a[1])
	$y = Int($a[2])
EndFunc   ;==>ConvertToVillagePos

Func ConvertFromVillagePos(ByRef $x, ByRef $y)
	If $g_hLibMyBot = -1 Then Return ; Bot didn't finish launch yet
	Local $result = DllCall($g_hLibMyBot, "str", "ConvertFromVillagePos", "int", $x, "int", $y)
	if Isarray($result) = False  then
	   if $g_iDebugSetlog=1 then Setlog("ConvertVillagePos result error", $COLOR_ERROR)
	   Return ;exit if
    EndIf
	Local $a = StringSplit($result[0], "|")
	If UBound($a) < 3 Then Return
	$x = Int($a[1])
	$y = Int($a[2])
EndFunc   ;==>ConvertFromVillagePos

Func ReduceBotMemory($bDisposeCaptures = True)
	If $bDisposeCaptures = True Then _CaptureDispose()
	IF $g_iEmptyWorkingSetBot > 0 Then _WinAPI_EmptyWorkingSet(@AutoItPID) ; Reduce Working Set of Bot
	;DllCall($g_hLibImgLoc, "none", "gc") ; run .net garbage collection
EndFunc   ;==>ReduceBotMemory