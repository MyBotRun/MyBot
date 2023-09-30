#include-once

; #INDEX# =======================================================================================================================
; Title .........: Timers
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Timers management.
;                  An application uses a timer to schedule an event for a window after a specified time has elapsed.
;                  Each time the specified interval (or time-out value) for a timer elapses, the system notifies the window
;                  associated with the timer. Because a timer's accuracy depends on the system clock rate and how often the
;                  application retrieves messages from the message queue, the time-out value is only approximate.
; Author(s) .....: Gary Frost
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g_aTimers_aTimerIDs[1][3]
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _Timer_Diff
; _Timer_GetIdleTime
; _Timer_GetTimerID
; _Timer_Init
; _Timer_KillAllTimers
; _Timer_KillTimer
; _Timer_SetTimer
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __Timer_QueryPerformanceCounter
; __Timer_QueryPerformanceFrequency
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost, original by Toady
; Modified.......:
; ===============================================================================================================================
Func _Timer_Diff($iTimeStamp)
	Return 1000 * (__Timer_QueryPerformanceCounter() - $iTimeStamp) / __Timer_QueryPerformanceFrequency()
EndFunc   ;==>_Timer_Diff

; #FUNCTION# ====================================================================================================================
; Author ........: PsaltyDS at http://www.autoitscript.com/forum
; Modified.......:
; ===============================================================================================================================
Func _Timer_GetIdleTime()
	; Get ticks at last activity
	Local $tStruct = DllStructCreate("uint;dword");
	DllStructSetData($tStruct, 1, DllStructGetSize($tStruct));
	Local $aResult = DllCall("user32.dll", "bool", "GetLastInputInfo", "struct*", $tStruct)
	If @error Or $aResult[0] = 0 Then Return SetError(@error, @extended, 0)

	; Get current ticks since last restart
	Local $avTicks = DllCall("kernel32.dll", "dword", "GetTickCount")
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, 0)

	; Return time since last activity, in ticks (approx milliseconds)
	Local $iDiff = $avTicks[0] - DllStructGetData($tStruct, 2)
	If $iDiff < 0 Then Return SetExtended(1, $avTicks[0]) ; Rollover of ticks counter has occured
	; Normal return
	Return $iDiff
EndFunc   ;==>_Timer_GetIdleTime

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......:
; ===============================================================================================================================
Func _Timer_GetTimerID($wParam)
	Local $_iTimerID = Dec(Hex($wParam, 8)), $iMax = UBound($__g_aTimers_aTimerIDs) - 1
	For $x = 1 To $iMax
		If $_iTimerID = $__g_aTimers_aTimerIDs[$x][1] Then Return $__g_aTimers_aTimerIDs[$x][0]
	Next
	Return 0
EndFunc   ;==>_Timer_GetTimerID

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost, original by Toady
; Modified.......:
; ===============================================================================================================================
Func _Timer_Init()
	Return __Timer_QueryPerformanceCounter()
EndFunc   ;==>_Timer_Init

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: Squirrely1
; ===============================================================================================================================
Func _Timer_KillAllTimers($hWnd)
	Local $iNumTimers = $__g_aTimers_aTimerIDs[0][0]
	If $iNumTimers = 0 Then Return False
	Local $aResult, $hCallBack = 0
	For $x = $iNumTimers To 1 Step -1
		If IsHWnd($hWnd) Then
			$aResult = DllCall("user32.dll", "bool", "KillTimer", "hwnd", $hWnd, "uint_ptr", $__g_aTimers_aTimerIDs[$x][1])
		Else
			$aResult = DllCall("user32.dll", "bool", "KillTimer", "hwnd", $hWnd, "uint_ptr", $__g_aTimers_aTimerIDs[$x][0])
		EndIf
		If @error Or $aResult[0] = 0 Then Return SetError(@error, @extended, False)
		$hCallBack = $__g_aTimers_aTimerIDs[$x][2]
		If $hCallBack <> 0 Then DllCallbackFree($hCallBack)
		$__g_aTimers_aTimerIDs[0][0] -= 1
	Next
	ReDim $__g_aTimers_aTimerIDs[1][3]
	Return True
EndFunc   ;==>_Timer_KillAllTimers

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: Squirrely1
; ===============================================================================================================================
Func _Timer_KillTimer($hWnd, $iTimerID)
	Local $aResult[1] = [0], $hCallBack = 0, $iUBound = UBound($__g_aTimers_aTimerIDs) - 1
	For $x = 1 To $iUBound
		If $__g_aTimers_aTimerIDs[$x][0] = $iTimerID Then
			If IsHWnd($hWnd) Then
				$aResult = DllCall("user32.dll", "bool", "KillTimer", "hwnd", $hWnd, "uint_ptr", $__g_aTimers_aTimerIDs[$x][1])
			Else
				$aResult = DllCall("user32.dll", "bool", "KillTimer", "hwnd", $hWnd, "uint_ptr", $__g_aTimers_aTimerIDs[$x][0])
			EndIf
			If @error Or $aResult[0] = 0 Then Return SetError(@error, @extended, False)
			$hCallBack = $__g_aTimers_aTimerIDs[$x][2]
			If $hCallBack <> 0 Then DllCallbackFree($hCallBack)
			For $i = $x To $iUBound - 1
				$__g_aTimers_aTimerIDs[$i][0] = $__g_aTimers_aTimerIDs[$i + 1][0]
				$__g_aTimers_aTimerIDs[$i][1] = $__g_aTimers_aTimerIDs[$i + 1][1]
				$__g_aTimers_aTimerIDs[$i][2] = $__g_aTimers_aTimerIDs[$i + 1][2]
			Next
			ReDim $__g_aTimers_aTimerIDs[UBound($__g_aTimers_aTimerIDs - 1)][3]
			$__g_aTimers_aTimerIDs[0][0] -= 1
			ExitLoop
		EndIf
	Next
	Return $aResult[0] <> 0
EndFunc   ;==>_Timer_KillTimer

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Timer_QueryPerformanceCounter
; Description ...: Retrieves the current value of the high-resolution performance counter
; Syntax.........: __Timer_QueryPerformanceCounter ( )
; Parameters ....:
; Return values .: Success - Current performance-counter value, in counts
;                  Failure - -1
; Author ........: Gary Frost
; Modified.......:
; Remarks .......:
; Related .......: __Timer_QueryPerformanceFrequency
; Link ..........: @@MsdnLink@@ QueryPerformanceCounter
; Example .......:
; ===============================================================================================================================
Func __Timer_QueryPerformanceCounter()
	Local $aResult = DllCall("kernel32.dll", "bool", "QueryPerformanceCounter", "int64*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[1])
EndFunc   ;==>__Timer_QueryPerformanceCounter

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Timer_QueryPerformanceFrequency
; Description ...: Retrieves the current value of the high-resolution performance counter
; Syntax.........: __Timer_QueryPerformanceFrequency ( )
; Parameters ....:
; Return values .: Success - Current performance-counter frequency, in counts per second
;                  Failure - 0
; Author ........: Gary Frost
; Modified.......:
; Remarks .......: If the installed hardware does not support a high-resolution performance counter, the return can be zero.
; Related .......: __Timer_QueryPerformanceCounter
; Link ..........: @@MsdnLink@@ QueryPerformanceCounter
; Example .......:
; ===============================================================================================================================
Func __Timer_QueryPerformanceFrequency()
	Local $aResult = DllCall("kernel32.dll", "bool", "QueryPerformanceFrequency", "int64*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[1])
EndFunc   ;==>__Timer_QueryPerformanceFrequency

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: Squirrely1
; ===============================================================================================================================
Func _Timer_SetTimer($hWnd, $iElapse = 250, $sTimerFunc = "", $iTimerID = -1)
	Local $aResult[1] = [0], $pTimerFunc = 0, $hCallBack = 0, $iIndex = $__g_aTimers_aTimerIDs[0][0] + 1
	If $iTimerID = -1 Then ; create a new timer
		ReDim $__g_aTimers_aTimerIDs[$iIndex + 1][3]
		$__g_aTimers_aTimerIDs[0][0] = $iIndex
		$iTimerID = $iIndex + 1000
		For $x = 1 To $iIndex
			If $__g_aTimers_aTimerIDs[$x][0] = $iTimerID Then
				$iTimerID = $iTimerID + 1
				$x = 0
			EndIf
		Next
		If $sTimerFunc <> "" Then ; using callbacks, if $sTimerFunc = "" then using WM_TIMER events
			$hCallBack = DllCallbackRegister($sTimerFunc, "none", "hwnd;uint;uint_ptr;dword")
			If $hCallBack = 0 Then Return SetError(-1, -1, 0)
			$pTimerFunc = DllCallbackGetPtr($hCallBack)
			If $pTimerFunc = 0 Then Return SetError(-1, -1, 0)
		EndIf
		$aResult = DllCall("user32.dll", "uint_ptr", "SetTimer", "hwnd", $hWnd, "uint_ptr", $iTimerID, "uint", $iElapse, "ptr", $pTimerFunc)
		If @error Or $aResult[0] = 0 Then Return SetError(@error, @extended, 0)
		$__g_aTimers_aTimerIDs[$iIndex][0] = $aResult[0] ; integer identifier
		$__g_aTimers_aTimerIDs[$iIndex][1] = $iTimerID ; timer id
		$__g_aTimers_aTimerIDs[$iIndex][2] = $hCallBack ; callback identifier, need this for the Kill Timer
	Else ; reuse timer
		For $x = 1 To $iIndex - 1
			If $__g_aTimers_aTimerIDs[$x][0] = $iTimerID Then
				If IsHWnd($hWnd) Then $iTimerID = $__g_aTimers_aTimerIDs[$x][1]
				$hCallBack = $__g_aTimers_aTimerIDs[$x][2]
				If $hCallBack <> 0 Then ; call back was used to create the timer
					$pTimerFunc = DllCallbackGetPtr($hCallBack)
					If $pTimerFunc = 0 Then Return SetError(-1, -1, 0)
				EndIf
				$aResult = DllCall("user32.dll", "uint_ptr", "SetTimer", "hwnd", $hWnd, "uint_ptr", $iTimerID, "uint", $iElapse, "ptr", $pTimerFunc)
				If @error Or $aResult[0] = 0 Then Return SetError(@error, @extended, 0)
				ExitLoop
			EndIf
		Next
	EndIf
	Return $aResult[0]
EndFunc   ;==>_Timer_SetTimer
