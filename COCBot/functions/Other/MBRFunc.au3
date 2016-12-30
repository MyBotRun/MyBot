; #FUNCTION# ====================================================================================================================
; Name ..........: MBRFunc, debugMBRFunctions
; Description ...: MBRFunc will open or close the MBRFunctions.dll, debugMBRFunctions will set the debug levels.
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Didipe (2015)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func MBRFunc($Start = True)
	Switch $Start
		Case True
			$hNtDll = DllOpen("ntdll.dll")
			$hUser32Dll = DllOpen("user32.dll")
			$hFuncLib = DllOpen($pFuncLib)
			$hImgLib = DllOpen($pImgLib)
			If $hFuncLib = -1 Then
				Setlog("MBRfunctions.dll not found.", $COLOR_ERROR)
				Return False
			EndIf
			SetDebugLog("MBRfunctions.dll opened.")
		Case False
			DllClose($hNtDll)
			DllClose($hUser32Dll)
			DllClose($hFuncLib)
			DllClose($hImgLib)
			SetDebugLog("MBRfunctions.dll closed.")
	EndSwitch
EndFunc   ;==>MBRFunc

Func debugMBRFunctions($debugSearchArea = 0, $debugRedArea = 0, $debugOcr = 0)
	SetDebugLog("debugMBRFunctions: $debugSearchArea=" & $debugSearchArea & ", $debugRedArea=" & $debugRedArea & ", $debugOcr=" & $debugOcr)
	Local $activeHWnD = WinGetHandle("")
	Local $result = DllCall($hFuncLib, "str", "setGlobalVar", "int", $debugSearchArea, "int", $debugRedArea, "int", $debugOcr)
	If @error Then
		_logErrorDLLCall($pFuncLib & ", setGlobalVar:", @error)
		Return SetError(@error)
	EndIf
	;dll return 0 on success, -1 on error
	If IsArray($result) Then
		If $debugSetlog = 1 And $result[0] = -1 Then SetLog("MBRfunctions.dll error setting Global vars.", $COLOR_DEBUG)
	Else
		SetDebugLog("MBRfunctions.dll not found.", $COLOR_ERROR)
	EndIf
	WinActivate($activeHWnD) ; restore current active window
EndFunc   ;==>debugMBRFunctions

Func setAndroidPID($pid)
	SetDebugLog("setAndroidPID: $pid=" & $pid)
	Local $result = DllCall($hFuncLib, "str", "setAndroidPID", "int", $pid)
	If @error Then
		_logErrorDLLCall($pFuncLib & ", setAndroidPID:", @error)
		Return SetError(@error)
	EndIf
	;dll return 0 on success, -1 on error
	If IsArray($result) Then
		If $result[0] = "" Then
			SetDebugLog("MBRfunctions.dll error setting Android PID.")
		Else
			SetDebugLog("Android PID=" & $pid & " initialized: " & $result[0])
			debugMBRFunctions($debugSearchArea, $debugRedArea, $debugOcr) ; set debug levels
		EndIf
	Else
		SetDebugLog("MBRfunctions.dll not found.", $COLOR_ERROR)
	EndIf
EndFunc   ;==>setAndroidPID

Func setVillageOffset($x, $y, $z)
	DllCall($hFuncLib, "str", "setVillageOffset", "int", $x, "int", $y, "float", $z)
	DllCall($pImgLib , "str", "setVillageOffset", "int", $x, "int", $y, "float", $z) ;set values in imgloc also
	$VILLAGE_OFFSET[0] = $x
	$VILLAGE_OFFSET[1] = $y
	$VILLAGE_OFFSET[2] = $z
EndFunc   ;==>setVillageOffset

Func setMaxDegreeOfParallelism($iMaxDegreeOfParallelism = -1)
	DllCall($pImgLib , "str", "setMaxDegreeOfParallelism", "int", $iMaxDegreeOfParallelism) ;set PARALLELOPTIONS.MaxDegreeOfParallelism for multi-threaded operations
EndFunc   ;==>setMaxDegreeOfParallelism

Func ConvertVillagePos(ByRef $x, ByRef $y, $zoomfactor = 0)
	Local $result = DllCall($hFuncLib, "str", "ConvertVillagePos", "int", $x, "int", $y, "float", $zoomfactor)
	if Isarray($result) = False  then
	   if $debugsetlog=1 then Setlog("ConvertVillagePos result error", $COLOR_ERROR)
	   Return ;exit if
    EndIf
	Local $a = StringSplit($result[0], "|")
	If UBound($a) < 3 Then Return
	$x = Int($a[1])
	$y = Int($a[2])
EndFunc   ;==>ConvertVillagePos

Func ConvertToVillagePos(ByRef $x, ByRef $y, $zoomfactor = 0)
	Local $result = DllCall($hFuncLib, "str", "ConvertToVillagePos", "int", $x, "int", $y, "float", $zoomfactor)
	if Isarray($result) = False  then
	   if $debugsetlog=1 then Setlog("ConvertToVillagePos result error", $COLOR_ERROR)
	   Return ;exit if
    EndIf
	Local $a = StringSplit($result[0], "|")
	If UBound($a) < 3 Then Return
	$x = Int($a[1])
	$y = Int($a[2])
EndFunc   ;==>ConvertToVillagePos

Func ConvertFromVillagePos(ByRef $x, ByRef $y)
	Local $result = DllCall($hFuncLib, "str", "ConvertFromVillagePos", "int", $x, "int", $y)
	if Isarray($result) = False  then
	   if $debugsetlog=1 then Setlog("ConvertVillagePos result error", $COLOR_ERROR)
	   Return ;exit if
    EndIf
	Local $a = StringSplit($result[0], "|")
	If UBound($a) < 3 Then Return
	$x = Int($a[1])
	$y = Int($a[2])
EndFunc   ;==>ConvertFromVillagePos
