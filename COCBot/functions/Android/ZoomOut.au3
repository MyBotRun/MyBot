; #FUNCTION# ====================================================================================================================
; Name ..........: ZoomOut
; Description ...: Tries to zoom out of the screen until the borders, located at the top of the game (usually black), is located.
; Syntax ........: ZoomOut()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: KnowJack (07-2015), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
Func ZoomOut() ;Zooms out
	Local $hTimer = TimerInit()
	$g_aiSearchZoomOutCounter[0] = 0
	$g_aiSearchZoomOutCounter[1] = 1
	ResumeAndroid()
	WinGetAndroidHandle()
	getBSPos() ; Update $g_hAndroidWindow and Android Window Positions
	If Not $g_bRunState Then
		SetDebugLog("Exit ZoomOut, bot not running")
		SetDebugLog("ZoomOut Completed(in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
		Return
	EndIf
	Local $Result
	If ($g_iAndroidZoomoutMode = 0 Or $g_iAndroidZoomoutMode = 3) And ($g_bAndroidEmbedded = False Or $g_iAndroidEmbedMode = 1) Then
		; default zoomout
		$Result = Execute("ZoomOut" & $g_sAndroidEmulator & "()")
		If $Result = "" And @error <> 0 Then
			; Not implemented or other error
			$Result = AndroidOnlyZoomOut()
		EndIf
		$g_bSkipFirstZoomout = True
		SetDebugLog("ZoomOut Completed(in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
		Return $Result
	EndIf

	; Android embedded, only use Android zoomout
	$Result = AndroidOnlyZoomOut()
	$g_bSkipFirstZoomout = True
	SetDebugLog("ZoomOut Completed(in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	Return $Result
EndFunc   ;==>ZoomOut

Func ZoomOutBlueStacks() ;Zooms out
	; ctrl click is best and most stable for BlueStacks
	Return ZoomOutCtrlClick(False, False, False, 250)
	;Return DefaultZoomOut("{DOWN}", 0)
	; ZoomOutCtrlClick doesn't cause moving buildings, but uses global Ctrl-Key and has taking focus problems
	;Return ZoomOutCtrlClick(False, False, False)
EndFunc   ;==>ZoomOutBlueStacks

Func ZoomOutBlueStacks2()
	If $__BlueStacks2Version_2_5_or_later = False Then
		; ctrl click is best and most stable for BlueStacks, but not working after 2.5.55.6279 version
		Return ZoomOutCtrlClick(False, False, False, 250)
	Else
		; newer BlueStacks versions don't work with Ctrl-Click, so fall back to original arrow key
		Return DefaultZoomOut("{DOWN}", 0, ($g_iAndroidZoomoutMode <> 3))
	EndIf
	;Return DefaultZoomOut("{DOWN}", 0)
	; ZoomOutCtrlClick doesn't cause moving buildings, but uses global Ctrl-Key and has taking focus problems
	;Return ZoomOutCtrlClick(False, False, False)
EndFunc   ;==>ZoomOutBlueStacks2

Func ZoomOutBlueStacks5()
	; newer BlueStacks versions don't work with Ctrl-Click, so fall back to original arrow key
	Return DefaultZoomOut("{DOWN}", 0, ($g_iAndroidZoomoutMode <> 3))
EndFunc   ;==>ZoomOutBlueStacks5

Func ZoomOutMEmu()
	;ClickP($aAway) ; activate window first with Click Away (when not clicked zoom might not work)
	Return DefaultZoomOut("{F3}", 0, ($g_iAndroidZoomoutMode <> 3))
EndFunc   ;==>ZoomOutMEmu

Func ZoomOutNox()
	Return ZoomOutCtrlWheelScroll(True, True, True, ($g_iAndroidZoomoutMode <> 3), Default, -5, 250)
	;Return DefaultZoomOut("{CTRLDOWN}{DOWN}{CTRLUP}", 0)
EndFunc   ;==>ZoomOutNox

Func DefaultZoomOut($ZoomOutKey = "{DOWN}", $tryCtrlWheelScrollAfterCycles = 40, $bAndroidZoomOut = True) ;Zooms out
	Local $sFunc = "DefaultZoomOut"
	Local $result0, $result1, $i = 0
	Local $exitCount = 80
	Local $delayCount = 20
	ForceCaptureRegion()
	Local $aPicture = SearchZoomOut($aCenterHomeVillageClickDrag, True, "", True)

	If StringInStr($aPicture[0], "zoomou") = 0 Then
		If $g_bDebugSetlog Then
			SetDebugLog("Zooming Out (" & $sFunc & ")", $COLOR_INFO)
		Else
			SetLog("Zooming Out", $COLOR_INFO)
		EndIf
		If _Sleep($DELAYZOOMOUT1) Then Return True
		If $bAndroidZoomOut Then
			AndroidZoomOut(0, Default, ($g_iAndroidZoomoutMode <> 2)) ; use new ADB zoom-out
			ForceCaptureRegion()
			$aPicture = SearchZoomOut($aCenterHomeVillageClickDrag, True, "", True)
		EndIf
		Local $tryCtrlWheelScroll = False
		While StringInStr($aPicture[0], "zoomou") = 0 And Not $tryCtrlWheelScroll
			If Not $g_bRunState Then
				SetDebugLog("Exit ZoomOut, bot not running")
				Return
			EndIf
			AndroidShield("DefaultZoomOut") ; Update shield status
			If $bAndroidZoomOut Then
				AndroidZoomOut($i, Default, ($g_iAndroidZoomoutMode <> 2)) ; use new ADB zoom-out
				If @error <> 0 Then $bAndroidZoomOut = False
			EndIf
			If Not $bAndroidZoomOut Then
				; original windows based zoom-out
				If $g_bDebugSetlog Then SetDebugLog("Index = " & $i, $COLOR_DEBUG) ; Index=2X loop count if success, will be increment by 1 if controlsend fail
				If _Sleep($DELAYZOOMOUT2) Then Return True
				If $g_bChkBackgroundMode = False And $g_bNoFocusTampering = False Then
					$result0 = ControlFocus($g_hAndroidWindow, "", "")
				Else
					$result0 = 1
				EndIf
				$result1 = ControlSend($g_hAndroidWindow, "", "", $ZoomOutKey)
				If $g_bDebugSetlog Then SetDebugLog("ControlFocus Result = " & $result0 & ", ControlSend Result = " & $result1 & "|" & "@error= " & @error, $COLOR_DEBUG)
				If $result1 = 1 Then
					$i += 1
				Else
					SetLog("Warning ControlSend $Result = " & $result1, $COLOR_DEBUG)
				EndIf
			EndIf

			If $i > $delayCount Then
				If _Sleep($DELAYZOOMOUT3) Then Return True
			EndIf
			If $tryCtrlWheelScrollAfterCycles > 0 And $i > $tryCtrlWheelScrollAfterCycles Then $tryCtrlWheelScroll = True
			If $i > $exitCount Then Return
			If $g_bRunState = False Then ExitLoop
			If IsProblemAffect(True) Then  ; added to catch errors during Zoomout
				SetLog($g_sAndroidEmulator & " Error window detected", $COLOR_ERROR)
				If checkObstacles() = True Then SetLog("Error window cleared, continue Zoom out", $COLOR_INFO)  ; call to clear normal errors
			EndIf
			$i += 1  ; add one to index value to prevent endless loop if controlsend fails
			ForceCaptureRegion()
			$aPicture = SearchZoomOut($aCenterHomeVillageClickDrag, True, "", True)
		WEnd
		If $tryCtrlWheelScroll Then
			SetLog($g_sAndroidEmulator & " zoom-out with key " & $ZoomOutKey & " didn't work, try now Ctrl+MouseWheel...", $COLOR_INFO)
			Return ZoomOutCtrlWheelScroll(False, False, False, False)
		EndIf
		Return True
	EndIf
	Return False
EndFunc   ;==>DefaultZoomOut

;Func ZoomOutCtrlWheelScroll($CenterMouseWhileZooming = True, $GlobalMouseWheel = True, $AlwaysControlFocus = False, $AndroidZoomOut = True, $WheelRotation = -5, $WheelRotationCount = 1)
Func ZoomOutCtrlWheelScroll($CenterMouseWhileZooming = True, $GlobalMouseWheel = True, $AlwaysControlFocus = False, $AndroidZoomOut = True, $hWin = Default, $ScrollSteps = -5, $ClickDelay = 250)
	Local $sFunc = "ZoomOutCtrlWheelScroll"
	;AutoItSetOption ( "SendKeyDownDelay", 3000)
	Local $exitCount = 80
	Local $delayCount = 20
	Local $Result[4], $i = 0, $j
	Local $ZoomActions[4] = ["ControlFocus", "Ctrl Down", "Mouse Wheel Scroll Down", "Ctrl Up"]
	If $hWin = Default Then $hWin = ($g_bAndroidEmbedded = False ? $g_hAndroidWindow : $g_aiAndroidEmbeddedCtrlTarget[1])
	ForceCaptureRegion()
	Local $aPicture = SearchZoomOut($aCenterHomeVillageClickDrag, True, "", True)

	If StringInStr($aPicture[0], "zoomou") = 0 Then

		If $g_bDebugSetlog Then
			SetDebugLog("Zooming Out (" & $sFunc & ")", $COLOR_INFO)
		Else
			SetLog("Zooming Out", $COLOR_INFO)
		EndIf

		AndroidShield("ZoomOutCtrlWheelScroll") ; Update shield status
		If _Sleep($DELAYZOOMOUT1) Then Return True
		If $AndroidZoomOut Then
			AndroidZoomOut(0, Default, ($g_iAndroidZoomoutMode <> 2)) ; use new ADB zoom-out
			ForceCaptureRegion()
			$aPicture = SearchZoomOut($aCenterHomeVillageClickDrag, True, "", True)
		EndIf
		Local $aMousePos = MouseGetPos()

		While StringInStr($aPicture[0], "zoomou") = 0
			If Not $g_bRunState Then
				SetDebugLog("Exit ZoomOut, bot not running")
				Return
			EndIf
			If $AndroidZoomOut Then
				AndroidZoomOut($i, Default, ($g_iAndroidZoomoutMode <> 2)) ; use new ADB zoom-out
				If @error <> 0 Then $AndroidZoomOut = False
			EndIf
			If Not $AndroidZoomOut Then
				; original windows based zoom-out
				If $g_bDebugSetlog Then SetDebugLog("Index = " & $i, $COLOR_DEBUG) ; Index=2X loop count if success, will be increment by 1 if controlsend fail
				If _Sleep($DELAYZOOMOUT2) Then ExitLoop
				If ($g_bChkBackgroundMode = False And $g_bNoFocusTampering = False) Or $AlwaysControlFocus Then
					$Result[0] = ControlFocus($hWin, "", "")
				Else
					$Result[0] = 1
				EndIf

				$Result[1] = ControlSend($hWin, "", "", "{CTRLDOWN}")
				If $CenterMouseWhileZooming Then MouseMove($g_aiBSpos[0] + Int($g_iDEFAULT_WIDTH / 2), $g_aiBSpos[1] + Int($g_iDEFAULT_HEIGHT / 2), 0)
				If $GlobalMouseWheel Then
					$Result[2] = MouseWheel(($ScrollSteps < 0 ? "down" : "up"), Abs($ScrollSteps)) ; can't find $MOUSE_WHEEL_DOWN constant, couldn't include AutoItConstants.au3 either
				Else
					Local $WM_WHEELMOUSE = 0x020A, $MK_CONTROL = 0x0008
					;Local $wParam = BitOR(BitShift($WheelRotation, -16), BitAND($MK_CONTROL, 0xFFFF)) ; HiWord = -120 WheelScrollDown, LoWord = $MK_CONTROL
					Local $wParam = BitOR($ScrollSteps * 0x10000, BitAND($MK_CONTROL, 0xFFFF)) ; HiWord = -120 WheelScrollDown, LoWord = $MK_CONTROL
					Local $lParam = BitOR(($g_aiBSpos[1] + Int($g_iDEFAULT_HEIGHT / 2)) * 0x10000, BitAND(($g_aiBSpos[0] + Int($g_iDEFAULT_WIDTH / 2)), 0xFFFF)) ; ; HiWord = y-coordinate, LoWord = x-coordinate
					;For $k = 1 To $WheelRotationCount
					_WinAPI_PostMessage($hWin, $WM_WHEELMOUSE, $wParam, $lParam)
					;Next
					$Result[2] = (@error = 0 ? 1 : 0)
				EndIf
				If _Sleep($ClickDelay) Then ExitLoop
				$Result[3] = ControlSend($hWin, "", "", "{CTRLUP}{SPACE}")

				If $g_bDebugSetlog Then SetDebugLog("ControlFocus Result = " & $Result[0] & _
						", " & $ZoomActions[1] & " = " & $Result[1] & _
						", " & $ZoomActions[2] & " = " & $Result[2] & _
						", " & $ZoomActions[3] & " = " & $Result[3] & _
						" | " & "@error= " & @error, $COLOR_DEBUG)
				For $j = 1 To 3
					If $Result[$j] = 1 Then
						$i += 1
						ExitLoop
					EndIf
				Next
				For $j = 1 To 3
					If $Result[$j] = 0 Then
						SetLog("Warning " & $ZoomActions[$j] & " = " & $Result[1], $COLOR_DEBUG)
					EndIf
				Next
			EndIf

			If $i > $delayCount Then
				If _Sleep($DELAYZOOMOUT3) Then ExitLoop
			EndIf
			If $i > $exitCount Then ExitLoop
			If $g_bRunState = False Then ExitLoop
			If IsProblemAffect(True) Then  ; added to catch errors during Zoomout
				SetLog($g_sAndroidEmulator & " Error window detected", $COLOR_ERROR)
				If checkObstacles() = True Then SetLog("Error window cleared, continue Zoom out", $COLOR_INFO)  ; call to clear normal errors
			EndIf
			$i += 1  ; add one to index value to prevent endless loop if controlsend fails
			ForceCaptureRegion()
			$aPicture = SearchZoomOut($aCenterHomeVillageClickDrag, True, "", True)
		WEnd

		If $CenterMouseWhileZooming And $AndroidZoomOut = False Then MouseMove($aMousePos[0], $aMousePos[1], 0)
		Return True

	EndIf
	Return False
EndFunc   ;==>ZoomOutCtrlWheelScroll

Func ZoomOutCtrlClick($CenterMouseWhileZooming = False, $AlwaysControlFocus = False, $AndroidZoomOut = True, $ClickDelay = 250)
	Local $sFunc = "ZoomOutCtrlClick"
	;AutoItSetOption ( "SendKeyDownDelay", 3000)
	Local $exitCount = 80
	Local $delayCount = 20
	Local $Result[4], $i, $j
	Local $SendCtrlUp = False
	Local $ZoomActions[4] = ["ControlFocus", "Ctrl Down", "Click", "Ctrl Up"]
	ForceCaptureRegion()
	Local $aPicture = SearchZoomOut($aCenterHomeVillageClickDrag, True, "", True)

	If StringInStr($aPicture[0], "zoomou") = 0 Then

		If $g_bDebugSetlog Then
			SetDebugLog("Zooming Out (" & $sFunc & ")", $COLOR_INFO)
		Else
			SetLog("Zooming Out", $COLOR_INFO)
		EndIf

		AndroidShield("ZoomOutCtrlClick") ; Update shield status

		If _Sleep($DELAYZOOMOUT1) Then Return True
		Local $aMousePos = MouseGetPos()

		$i = 0
		While StringInStr($aPicture[0], "zoomou") = 0
			If Not $g_bRunState Then
				SetDebugLog("Exit ZoomOut, bot not running")
				Return
			EndIf
			If $AndroidZoomOut Then
				AndroidZoomOut($i, Default, ($g_iAndroidZoomoutMode <> 2)) ; use new ADB zoom-out
				If @error <> 0 Then $AndroidZoomOut = False
			EndIf
			If Not $AndroidZoomOut Then
				; original windows based zoom-out
				If $g_bDebugSetlog Then SetDebugLog("Index = " & $i, $COLOR_DEBUG) ; Index=2X loop count if success, will be increment by 1 if controlsend fail
				If _Sleep($DELAYZOOMOUT2) Then ExitLoop
				If ($g_bChkBackgroundMode = False And $g_bNoFocusTampering = False) Or $AlwaysControlFocus Then
					$Result[0] = ControlFocus($g_hAndroidWindow, "", "")
				Else
					$Result[0] = 1
				EndIf

				$Result[1] = ControlSend($g_hAndroidWindow, "", "", "{CTRLDOWN}")
				$SendCtrlUp = True
				If $CenterMouseWhileZooming Then MouseMove($g_aiBSpos[0] + Int($g_iDEFAULT_WIDTH / 2), $g_aiBSpos[1] + Int($g_iDEFAULT_HEIGHT / 2), 0)
				$Result[2] = _ControlClick(Int($g_iDEFAULT_WIDTH / 2), 600)
				If _Sleep($ClickDelay) Then ExitLoop
				$Result[3] = ControlSend($g_hAndroidWindow, "", "", "{CTRLUP}{SPACE}")
				$SendCtrlUp = False

				If $g_bDebugSetlog Then SetDebugLog("ControlFocus Result = " & $Result[0] & _
						", " & $ZoomActions[1] & " = " & $Result[1] & _
						", " & $ZoomActions[2] & " = " & $Result[2] & _
						", " & $ZoomActions[3] & " = " & $Result[3] & _
						" | " & "@error= " & @error, $COLOR_DEBUG)
				For $j = 1 To 3
					If $Result[$j] = 1 Then
						ExitLoop
					EndIf
				Next
				For $j = 1 To 3
					If $Result[$j] = 0 Then
						SetLog("Warning " & $ZoomActions[$j] & " = " & $Result[1], $COLOR_DEBUG)
					EndIf
				Next
			EndIf

			If $i > $delayCount Then
				If _Sleep($DELAYZOOMOUT3) Then ExitLoop
			EndIf
			If $i > $exitCount Then ExitLoop
			If $g_bRunState = False Then ExitLoop
			If IsProblemAffect(True) Then  ; added to catch errors during Zoomout
				SetLog($g_sAndroidEmulator & " Error window detected", $COLOR_RED)
				If checkObstacles() = True Then SetLog("Error window cleared, continue Zoom out", $COLOR_BLUE)  ; call to clear normal errors
			EndIf
			$i += 1  ; add one to index value to prevent endless loop if controlsend fails
			ForceCaptureRegion()
			$aPicture = SearchZoomOut($aCenterHomeVillageClickDrag, True, "", True)
		WEnd

		If $SendCtrlUp Then ControlSend($g_hAndroidWindow, "", "", "{CTRLUP}{SPACE}")

		If $CenterMouseWhileZooming Then MouseMove($aMousePos[0], $aMousePos[1], 0)

		Return True
	EndIf
	Return False
EndFunc   ;==>ZoomOutCtrlClick

Func AndroidOnlyZoomOut() ;Zooms out
	Local $sFunc = "AndroidOnlyZoomOut"
	Local $i = 0
	Local $exitCount = 80
	ForceCaptureRegion()
	Local $aPicture = SearchZoomOut($aCenterHomeVillageClickDrag, True, "", True)

	If StringInStr($aPicture[0], "zoomout") = 0 Then

		If $g_bDebugSetlog Then
			SetDebugLog("Zooming Out (" & $sFunc & ")", $COLOR_INFO)
		Else
			SetLog("Zooming Out", $COLOR_INFO)
		EndIf
		If _Sleep(50) Then Return
		AndroidZoomOut(0, Default, ($g_iAndroidZoomoutMode <> 2)) ; use new ADB zoom-out
		ForceCaptureRegion()
		$aPicture = SearchZoomOut($aCenterHomeVillageClickDrag, True, "", True)
		While StringInStr($aPicture[0], "zoomout") = 0
			If Not $g_bRunState Then
				SetDebugLog("Exit ZoomOut, bot not running")
				Return
			EndIf
			If _Sleep(50) Then Return
			AndroidShield("AndroidOnlyZoomOut") ; Update shield status
			AndroidZoomOut($i, Default, ($g_iAndroidZoomoutMode <> 2)) ; use new ADB zoom-out
			If $i > $exitCount Then Return
			If Not $g_bRunState Then ExitLoop
			If IsProblemAffect(True) Then  ; added to catch errors during Zoomout
				SetLog($g_sAndroidEmulator & " Error window detected", $COLOR_ERROR)
				If checkObstacles() Then SetLog("Error window cleared, continue Zoom out", $COLOR_INFO)  ; call to clear normal errors
			EndIf
			$i += 1  ; add one to index value to prevent endless loop if controlsend fails
			ForceCaptureRegion()
			$aPicture = SearchZoomOut($aCenterHomeVillageClickDrag, True, "", True)
		WEnd
		Return True
	EndIf
	Return False
EndFunc   ;==>AndroidOnlyZoomOut


; Local $aVillageResult = SearchZoomOut(False, True, $sSource, False)

; SearchZoomOut returns always an Array.
; If village can be measured and villages size < 500 pixel then it returns in idx 0 a String starting with "zoomout:" and tries to center base
; Return Array:
; 0 = Empty string if village cannot be measured (e.g. window blocks village or not zoomed out)
; 1 = Current Village X Offset (after centering village)
; 2 = Current Village Y Offset (after centering village)
; 3 = Difference of previous Village X Offset and current (after centering village)
; 4 = Difference of previous Village Y Offset and current (after centering village)
Func SearchZoomOut($CenterVillageBoolOrScrollPos = $aCenterHomeVillageClickDrag, $UpdateMyVillage = True, $sSource = "", $CaptureRegion = True, $DebugLog = $g_bDebugSetlog)
	FuncEnter(SearchZoomOut)
	If $sSource <> "" Then $sSource = " (" & $sSource & ")"
	Local $bCenterVillage = $CenterVillageBoolOrScrollPos
	If $bCenterVillage = Default Or $g_bDebugDisableVillageCentering Then $bCenterVillage = (Not $g_bDebugDisableVillageCentering)
	Local $aScrollPos[2] = [0, 0]
	If UBound($CenterVillageBoolOrScrollPos) >= 2 Then
		$aScrollPos[0] = $CenterVillageBoolOrScrollPos[0]
		$aScrollPos[1] = $CenterVillageBoolOrScrollPos[1]
		$bCenterVillage = (Not $g_bDebugDisableVillageCentering)
	EndIf

	; Setup arrays, including default return values for $return
	Local $x, $y, $z, $stone[2], $tree[2]
	Local $villageSize = 0

	If $CaptureRegion Then _CaptureRegion2()

	Local $aResult = ["", 0, 0, 0, 0] ; expected dummy value

	Local $village
	If $g_aiSearchZoomOutCounter[0] = 5 Then SetLog("Try secondary village measuring...", $COLOR_INFO)
	If $g_aiSearchZoomOutCounter[0] < 5 Then
		$village = GetVillageSize($DebugLog, "stone", "tree")
	Else
		; try secondary images
		$village = GetVillageSize($DebugLog, "2stone", "2tree")
	EndIf

	; compare other stone measures
	;GetVillageSize(True, "stoneBlueStacks2A")
	;GetVillageSize(True, "stoneiTools")

	If $g_aiSearchZoomOutCounter[0] > 0 Then
		If _Sleep(1000) Then Return $aResult
	EndIf

	#cs
			$aResult[0] = $c ; village size
			$aResult[1] = $z ; zoom
			$aResult[2] = $x ; offset x
			$aResult[3] = $y ; offset y
			$aResult[4] = $stone[0] ; x center of stone found
			$aResult[5] = $stone[1] ; y center of stone found
			$aResult[6] = $stone[5] ; stone image file name
			$aResult[7] = $tree[0] ; x center of tree found
			$aResult[8] = $tree[1] ; y center of tree found
			$aResult[9] = $tree[5] ; tree image file name
	#ce

	Local $iRefSize = 0
	Local $iMinSize = 0
	Local $iMaxSize = 0

	If IsArray($village) = 1 Then
		$villageSize = $village[0]
		$z = $village[1]
		$x = $village[2]
		$y = $village[3]
		$stone[0] = $village[4]
		$stone[1] = $village[5]
		$tree[0] = $village[7]
		$tree[1] = $village[8]
		$iRefSize = $village[10]

		If $iRefSize > 0 Then
			$iMinSize = Round($iRefSize * 0.9)
			$iMaxSize = Round($iRefSize * 1.1)

			If $DebugLog Then SetDeBugLog("Ref : " & $iRefSize & ", Min : " & $iMinSize & ", Max : " & $iMaxSize, $COLOR_INFO)
		EndIf

		If ($villageSize > $iMinSize And $villageSize < $iMaxSize) Or $g_bDebugDisableZoomout Then

			$aResult[0] = "zoomout:" & $village[6]
			$aResult[1] = $x
			$aResult[2] = $y

			If $bCenterVillage And ($x <> 0 Or $y <> 0) And ($UpdateMyVillage = False Or $x <> $g_iVILLAGE_OFFSET[0] Or $y <> $g_iVILLAGE_OFFSET[1]) And Not $g_bOnBuilderBaseEnemyVillage Then
				If $DebugLog Then SetDebugLog("Center Village" & $sSource & " by: " & $x & ", " & $y)
				If IsCoordSafe($stone[0], $stone[1]) Then
					$aScrollPos[0] = $stone[0]
					$aScrollPos[1] = $stone[1]
				ElseIf IsCoordSafe($tree[0], $tree[1]) Then
					$aScrollPos[0] = $tree[0]
					$aScrollPos[1] = $tree[1]
				Else
					$aScrollPos[0] = $aCenterHomeVillageClickDrag[0]
					$aScrollPos[1] = $aCenterHomeVillageClickDrag[1]
				EndIf
				If $g_bDebugImageSave Then SaveDebugPointImage("SearchZoomOut", $aScrollPos)
				ClickAway()
				ClickDrag($aScrollPos[0], $aScrollPos[1], $aScrollPos[0] - $x, $aScrollPos[1] - $y)
				If _Sleep(250) Then Return $aResult
				Local $aResult2 = SearchZoomOut(False, $UpdateMyVillage, "SearchZoomOut:" & $sSource, True, $DebugLog)
				; update difference in offset
				$aResult2[3] = $aResult2[1] - $aResult[1]
				$aResult2[4] = $aResult2[2] - $aResult[2]
				If $DebugLog Then SetDebugLog("Centered Village Offset" & $sSource & ": " & $aResult2[1] & ", " & $aResult2[2] & ", change: " & $aResult2[3] & ", " & $aResult2[4])
				Return $aResult2
			EndIf

			If $UpdateMyVillage Then
				If $x <> $g_iVILLAGE_OFFSET[0] Or $y <> $g_iVILLAGE_OFFSET[1] Or $z <> $g_iVILLAGE_OFFSET[2] Then
					If $DebugLog Then SetDebugLog("Village Offset" & $sSource & " updated to " & $x & ", " & $y & ", " & $z)
				EndIf
				setVillageOffset($x, $y, $z)
				ConvertInternalExternArea() ; generate correct internal/external diamond measures
			EndIf
		Else ; found one fixed point - center using that then force another zoomout
			If $g_bOnBuilderBaseEnemyVillage And $g_aiSearchZoomOutCounter[0] = 0 Then
				If $DebugLog Then SetDebugLog("Builder Base Enemy Village First Zoom - no centering")
			Else
				If $stone[0] = 0 And $tree[0] > 0 Then
					If $DebugLog Then SetDeBugLog("Centering using tree", $COLOR_INFO)
					CenterVillage($tree[0], $tree[1], $x, $y)
				ElseIf $tree[0] = 0 And $stone[0] > 0 Then
					If $DebugLog Then SetDeBugLog("Centering using stone", $COLOR_INFO)
					CenterVillage($stone[0], $stone[1], $x, $y)
				EndIf
			EndIf
		EndIf
	EndIf

	If $UpdateMyVillage Then
		If $aResult[0] = "" Then
			If $g_aiSearchZoomOutCounter[0] > 10 Then
				$g_aiSearchZoomOutCounter[0] = 0
				Static $iCallCount = 0
				$iCallCount += 1
				If $iCallCount <= 2 Then
					;CloseCoC(True)
					SetLog("Restart CoC to reset zoom" & $sSource & "...", $COLOR_INFO)
					PoliteCloseCoC("Zoomout" & $sSource)
					If _Sleep(1000) Then Return $aResult
					CloseCoC() ; ensure CoC is gone
					OpenCoC()
					waitMainScreen()
				Else
					SetLog("Restart Android to reset zoom" & $sSource & "...", $COLOR_INFO)
					$iCallCount = 0
					RebootAndroid()
					If _Sleep(1000) Then Return $aResult
					waitMainScreen()
				EndIf
				Return SearchZoomOut($CenterVillageBoolOrScrollPos, $UpdateMyVillage, "SearchZoomOut:" & $sSource, True, $DebugLog)
			Else
				$g_aiSearchZoomOutCounter[0] += 1
			EndIf
		Else
			If Not $g_bDebugDisableZoomout And $villageSize > 480 Then
				If Not $g_bSkipFirstZoomout Then
					; force additional zoom-out
					$aResult[0] = ""
				ElseIf $g_aiSearchZoomOutCounter[1] > 0 And $g_aiSearchZoomOutCounter[0] > 0 Then
					; force additional zoom-out
					$g_aiSearchZoomOutCounter[1] -= 1
					$aResult[0] = ""
				EndIf
			EndIf
		EndIf
		$g_bSkipFirstZoomout = True
	EndIf

	Return $aResult
EndFunc   ;==>SearchZoomOut
