; #FUNCTION# ====================================================================================================================
; Name ..........: MBRFunc, debugMBRFunctions
; Description ...: MBRFunc will open or close the MyBot.run.dll, debugMBRFunctions will set the debug levels.
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Didipe (2015)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func MBRFunc($Start = True)
	Switch $Start
		Case True
			$g_hLibMyBot = DllOpen($g_sLibMyBotPath)
			If $g_hLibMyBot = -1 Then
				SetLog($g_sMBRLib & " not found.", $COLOR_ERROR)
				Return False
			EndIf
			SetDebugLog($g_sMBRLib & " opened.")
			; set processing pool size immediately
			setProcessingPoolSize($g_iGlobalThreads)
			setMaxDegreeOfParallelism($g_iThreads)
		Case False
			DllClose($g_hLibMyBot)
			SetDebugLog($g_sMBRLib & " closed.")
	EndSwitch
EndFunc   ;==>MBRFunc

; Private DllCall MyBot.run.dll function call
Func _DllCallMyBot($sFunc, $sType1 = Default, $vParam1 = Default, $sType2 = Default, $vParam2 = Default, $sType3 = Default, $vParam3 = Default, $sType4 = Default, $vParam4 = Default, $sType5 = Default, $vParam5 = Default _
		, $sType6 = Default, $vParam6 = Default, $sType7 = Default, $vParam7 = Default, $sType8 = Default, $vParam8 = Default, $sType9 = Default, $vParam9 = Default, $sType10 = Default, $vParam10 = Default)
	If $sType1 = Default Then Return DllCall($g_hLibMyBot, "str", $sFunc)
	If $sType2 = Default Then Return DllCall($g_hLibMyBot, "str", $sFunc, $sType1, $vParam1)
	If $sType3 = Default Then Return DllCall($g_hLibMyBot, "str", $sFunc, $sType1, $vParam1, $sType2, $vParam2)
	If $sType4 = Default Then Return DllCall($g_hLibMyBot, "str", $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3)
	If $sType5 = Default Then Return DllCall($g_hLibMyBot, "str", $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4)
	If $sType6 = Default Then Return DllCall($g_hLibMyBot, "str", $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5)
	If $sType7 = Default Then Return DllCall($g_hLibMyBot, "str", $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6)
	If $sType8 = Default Then Return DllCall($g_hLibMyBot, "str", $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7)
	If $sType9 = Default Then Return DllCall($g_hLibMyBot, "str", $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8)
	If $sType10 = Default Then Return DllCall($g_hLibMyBot, "str", $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9)
	Return DllCall($g_hLibMyBot, "str", $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10)
EndFunc   ;==>_DllCallMyBot

Func DllCallMyBotIsActive()
	Return $g_bLibMyBotActive
EndFunc   ;==>DllCallMyBotIsActive

; Public DllCall MyBot.run.dll function call
Func DllCallMyBot($sFunc, $sType1 = Default, $vParam1 = Default, $sType2 = Default, $vParam2 = Default, $sType3 = Default, $vParam3 = Default, $sType4 = Default, $vParam4 = Default, $sType5 = Default, $vParam5 = Default _
		, $sType6 = Default, $vParam6 = Default, $sType7 = Default, $vParam7 = Default, $sType8 = Default, $vParam8 = Default, $sType9 = Default, $vParam9 = Default, $sType10 = Default, $vParam10 = Default)
	$g_bLibMyBotActive = True
	Local $aResult
	If $g_bCloudsActive = False And ((BitAND($g_iAndroidSuspendModeFlags, 1) > 0 And ($g_bAttackActive Or $g_bVillageSearchActive)) Or BitAND($g_iAndroidSuspendModeFlags, 2) > 0) Then ; $g_bVillageSearchActive disabled as it would significantly increase re-connection error during search
		Local $sFileOrFolder = Default
		Switch $sFunc
			Case "SearchMultipleTilesBetweenLevels", "FindTile", "SearchTile", "SearchMultipleTilesLevel", "SearchMultipleTiles", "RecheckTile", "DoOCR"
				If StringLeft($vParam2, 1) <> "-" Then
					$sFileOrFolder = $vParam2
					$vParam2 = "-" & _Base64Encode(StringToBinary($vParam2, 4), 1024) ; support umlauts using Base64 UTF-8
				EndIf
		EndSwitch
		If $g_bDebugBetaVersion And $sFileOrFolder <> Default And StringInStr($sFileOrFolder, "\") And FileExists($sFileOrFolder) = 0 Then SetLog("Cannot access path: " & $sFileOrFolder, $COLOR_ERROR)
		; suspend Android now
		Local $bWasSuspended = SuspendAndroid()
		$aResult = _DllCallMyBot($sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10)
		; resume Android again (if it was not already suspended)
		SuspendAndroid($bWasSuspended)
	Else
		$aResult = _DllCallMyBot($sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10)
	EndIf
	$g_bLibMyBotActive = False
	Return $aResult
EndFunc   ;==>DllCallMyBot

Func debugMBRFunctions($iDebugSearchArea = 0, $iDebugRedArea = 0, $iDebugOcr = 0)
	SetDebugLog("debugMBRFunctions: $iDebugSearchArea=" & $iDebugSearchArea & ", $iDebugRedArea=" & $iDebugRedArea & ", $giDebugOcr=" & $iDebugOcr)
	Local $activeHWnD = WinGetHandle("")
	Local $result = DllCall($g_hLibMyBot, "str", "setGlobalVar", "int", $iDebugSearchArea, "int", $iDebugRedArea, "int", $iDebugOcr)
	If @error Then
		_logErrorDLLCall($g_sLibMyBotPath & ", setGlobalVar:", @error)
		Return SetError(@error)
	EndIf
	;dll return 0 on success, -1 on error
	If IsArray($result) Then
		If $g_bDebugSetlog And $result[0] = -1 Then SetLog($g_sMBRLib & " error setting Global vars.", $COLOR_DEBUG)
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
			debugMBRFunctions(0, $g_bDebugRedArea ? 1 : 0, $g_bDebugOcr ? 1 : 0) ; set debug levels
		EndIf
	Else
		SetDebugLog($g_sMBRLib & " not found.", $COLOR_ERROR)
	EndIf
EndFunc   ;==>setAndroidPID

Func SetBotGuiPID($pid = $g_iGuiPID)
	If $g_hLibMyBot = -1 Then Return ; Bot didn't finish launch yet
	SetDebugLog("SetBotGuiPID: $pid=" & $pid)
	Local $result = DllCall($g_hLibMyBot, "str", "SetBotGuiPID", "int", $pid)
	If @error Then
		_logErrorDLLCall($g_sLibMyBotPath & ", SetBotGuiPID:", @error)
		Return SetError(@error)
	EndIf
	;dll return 0 on success, -1 on error
	If IsArray($result) Then
		If $result[0] = "" Then
			SetDebugLog($g_sMBRLib & " error setting Android PID.")
		Else
			SetDebugLog("Bot GUI PID=" & $pid & " initialized: " & $result[0])
			;debugMBRFunctions($g_iDebugSearchArea, $g_iDebugRedArea, $g_iDebugOcr) ; set debug levels
		EndIf
	Else
		SetDebugLog($g_sMBRLib & " not found.", $COLOR_ERROR)
	EndIf
EndFunc   ;==>SetBotGuiPID

Func setVillageOffset($x, $y, $z)
	DllCall($g_hLibMyBot, "str", "setVillageOffset", "int", $x, "int", $y, "float", $z)
	$g_iVILLAGE_OFFSET[0] = $x
	$g_iVILLAGE_OFFSET[1] = $y
	$g_iVILLAGE_OFFSET[2] = $z
EndFunc   ;==>setVillageOffset

Func setMaxDegreeOfParallelism($iMaxDegreeOfParallelism = 0)
	Local $i = Int($iMaxDegreeOfParallelism)
	If $i < 1 Then $i = 0
	SetDebugLog("Threading: Using " & $i & " threads for parallelism")
	If $i < 1 Then $i = -1
	DllCall($g_hLibMyBot, "none", "setMaxDegreeOfParallelism", "int", $i) ;set PARALLELOPTIONS.MaxDegreeOfParallelism for multi-threaded operations
EndFunc   ;==>setMaxDegreeOfParallelism

Func setProcessingPoolSize($iProcessingPoolSize = 0)
	Local $i = Int($iProcessingPoolSize)
	If $i < 1 Then $i = 0
	SetDebugLog("Threading: Using " & $i & " threads shared across all bot instances")
	If $i < 1 Then $i = -1
	DllCall($g_hLibMyBot, "none", "setProcessingPoolSize", "int", $i) ;set ProcessingPoolSize for multi-threaded operations (global number of used threads for ImgLoc for all bot instances)
EndFunc   ;==>setProcessingPoolSize

Func setGcCollectTotalMemoryPreasure($iGcCollectTotalMemoryPreasure = 0)
	DllCall($g_hLibMyBot, "none", "setGcCollectTotalMemoryPreasure", "int", $iGcCollectTotalMemoryPreasure) ;set Heap preasure, when exceeded, calls GC.Collect() in ImageDispose, 0 to disable, 32 * 1024 * 1024 (32MB) good value to keep heap small
EndFunc   ;==>setGcCollectTotalMemoryPreasure

Func ConvertVillagePos(ByRef $x, ByRef $y, $zoomfactor = 0)
	If $g_hLibMyBot = -1 Then Return ; Bot didn't finish launch yet
	Local $result = DllCall($g_hLibMyBot, "str", "ConvertVillagePos", "int", $x, "int", $y, "float", $zoomfactor)
	If IsArray($result) = False Then
		If $g_bDebugSetlog Then SetDebugLog("ConvertVillagePos result error", $COLOR_ERROR)
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
	If IsArray($result) = False Then
		If $g_bDebugSetlog Then SetDebugLog("ConvertToVillagePos result error", $COLOR_ERROR)
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
	If IsArray($result) = False Then
		If $g_bDebugSetlog Then SetDebugLog("ConvertVillagePos result error", $COLOR_ERROR)
		Return ;exit if
	EndIf
	Local $a = StringSplit($result[0], "|")
	If UBound($a) < 3 Then Return
	$x = Int($a[1])
	$y = Int($a[2])
EndFunc   ;==>ConvertFromVillagePos

Func ReduceBotMemory($bDisposeCaptures = True)
	If $bDisposeCaptures = True Then _CaptureDispose()
	If $g_iEmptyWorkingSetBot > 0 Then _WinAPI_EmptyWorkingSet(@AutoItPID) ; Reduce Working Set of Bot
	;DllCall($g_hLibMyBot, "none", "gc") ; run .net garbage collection
EndFunc   ;==>ReduceBotMemory
