Global Const $tagCWPRETSTRUCT = "LRESULT lResult;LPARAM  lParam;WPARAM  wParam;UINT message;HWND hwnd"
Global $g_hProcShieldInput[5] = [0, 0, False, False, 0]
Global $aAndroidEmbeddedGraphics[0][2]

; Syncronized _AndroidEmbed
Func AndroidEmbed($Embed = True, $CallWinGetAndroidHandle = True)
	If $AndroidEmbed = False Then Return False
	Local $hMutex = AcquireMutex("AndroidEmbed", Default, 1000)
	If $hMutex <> 0 Then
		Return ReleaseMutex($hMutex, _AndroidEmbed($Embed, $CallWinGetAndroidHandle))
	EndIf
	Return False
EndFunc   ;==>AndroidEmbed

Func _AndroidEmbed($Embed = True, $CallWinGetAndroidHandle = True)

	If ($CallWinGetAndroidHandle = False And $HWnD = 0) Or ($CallWinGetAndroidHandle = True And WinGetAndroidHandle() = 0) Then
		SetDebugLog("Android Emulator not launched", $COLOR_RED)
		If $AndroidEmbedded = False Then
			; nothing to do
			updateBtnEmbed()
			Return False
		Else
			; detach android
			If $Embed = True Then
				SetDebugLog("Docked Android Window not available, force undock", $COLOR_RED)
				$Embed = False
			EndIf
		EndIf
	EndIf
	If $AndroidBackgroundLaunched = True Then
		If $AndroidEmbedded = False Then
			SetDebugLog("Android Emulator launched in background mode", $COLOR_RED)
			; nothing to do
			updateBtnEmbed()
			Return False
		Else
			; detach android
			If $Embed = True Then
				SetDebugLog("Android Emulator launched in background mode, force undock", $COLOR_RED)
				$Embed = False
			EndIf
		EndIf
	EndIf

	Local $aPos = WinGetPos($HWnD)
	If IsArray($aPos) = 0 Or @error <> 0 Then
		If $AndroidEmbedded = False Then
			SetDebugLog("Android Window not available", $COLOR_RED)
			updateBtnEmbed()
			Return False
		Else
			; detach android
			If $Embed = True Then
				SetDebugLog("Android Window not accessible, force undock", $COLOR_RED)
				$Embed = False
			EndIf
		EndIf
	EndIf

	Local $hCtrl, $aPosFrmBotEx, $aPosLog
	Local $hCtrlTarget = $AndroidEmbeddedCtrlTarget[0]
	Local $hCtrlTargetParent = $AndroidEmbeddedCtrlTarget[1]
	Local $HWnDParent = $AndroidEmbeddedCtrlTarget[2]
	Local $HWnD2 = $AndroidEmbeddedCtrlTarget[3]
	Local $lCurStyle = $AndroidEmbeddedCtrlTarget[4]
	Local $lCurExStyle = $AndroidEmbeddedCtrlTarget[5]
	Local $aPosCtl = $AndroidEmbeddedCtrlTarget[6]
	Local $lCurStyleTarget = $AndroidEmbeddedCtrlTarget[8]
	Local $targetIsHWnD = $hCtrlTarget = $HWnD

	#cs
		Local $HWND_MESSAGE = HWnd(-3)
		Local $WM_CHANGEUISTATE = 0x127
		Local $WM_UPDATEUISTATE = 0x128
		Local $UIS_SET = 0x1
		Local $UIS_INITIALIZE = 0x3
		Local $UISF_ACTIVE = 0x4
		Local $WM_STATE_WPARAM = BitOR($UISF_ACTIVE * 0x10000,$UIS_SET)
	#ce

	Local $activeHWnD = WinGetHandle("")

	If $Embed = False Then
		; remove embedded Android
		If $AndroidEmbedded = True Then

			If _WinAPI_IsIconic($frmBot) Then BotMinimize("_AndroidEmbed (1)", True)

			AndroidShield("AndroidEmbed undock", False, $CallWinGetAndroidHandle)

			SetRedrawBotWindow(False)

			$aPos = $AndroidEmbeddedCtrlTarget[7]

			$g_hProcShieldInput[3] = True

			If $targetIsHWnD = False Then
				ControlMove($hCtrlTarget, "", "", $aPosCtl[0], $aPosCtl[1], $aPosCtl[2], $aPosCtl[3])
			EndIf
			WinMove2($HWnD, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
			If $targetIsHWnD = False Then
				_WinAPI_SetParent($hCtrlTarget, $hCtrlTargetParent)
				;_WinAPI_SetWindowLong($hCtrlTarget, $GWL_HWNDPARENT, $hCtrlTargetParent)
			EndIf

			;_WinAPI_SetWindowLong($HWnd, $GWL_STYLE, BitOR(_WinAPI_GetWindowLong($HWnD, $GWL_STYLE), $WS_MINIMIZE)) ; ensures that Android Window shows up in taskbar
			_WinAPI_SetWindowLong($HWnD, $GWL_EXSTYLE, $lCurExStyle)
			_WinAPI_SetParent($HWnD, $HWnDParent)
			_WinAPI_SetWindowLong($HWnD, $GWL_HWNDPARENT, $HWnDParent) ; required for BS to solve strange focus switch between bot and BS
			_WinAPI_SetWindowLong($HWnD, $GWL_STYLE, $lCurStyle)
			_WinAPI_EnableWindow($HWnD, True)
			_WinAPI_EnableWindow($hCtrlTarget, True)
			;WinSetState($HWnD, "", @SW_SHOW) ; ensures that Android Window shows up in taskbar

			getAndroidPos() ; ensure window size is ok

			ControlHide($hGUI_LOG, "", $divider)
			$aPosFrmBotEx = ControlGetPos($frmBot, "", $frmBotEx)
			ControlMove($frmBot, "", $frmBotEx, 0, 0, $aPosFrmBotEx[2], $aPosFrmBotEx[3] - $frmBotAddH)
			ControlMove($frmBot, "", $frmBotBottom, 0, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP)
			WinSetTrans($frmBotBottom, "", 255)
			$aPosLog = ControlGetPos($frmBotEx, "", $hGUI_LOG)
			ControlMove($frmBotEx, "", $hGUI_LOG, Default, Default, $aPosLog[2], $aPosLog[3] - $frmBotAddH)
			$AndroidEmbedded = False
			WinMove2($frmBot, "", $frmBotPosX, $frmBotPosY, $frmBotPosInit[2], $frmBotPosInit[3], 0, 0, False)
			updateBtnEmbed()
			SetDebugLog("Undocked Android Window", Default, True)

			$iDividerY -= $frmBotAddH
			$frmBotAddH = 0
			cmbLog()

			SetRedrawBotWindow(True)
			; Ensure android window shows up in taskbar again
			_SendMessage($HWnD, $WM_SETREDRAW, False, 0)
			WinSetState($HWnD, "", @SW_HIDE)
			_WinAPI_SetWindowLong($HWnD, $GWL_EXSTYLE, BitOR($lCurExStyle, $WS_EX_APPWINDOW))
			_WinAPI_RedrawWindow($HWnD, 0, 0, $RDW_INVALIDATE)
			WinSetState($HWnD, "", @SW_SHOW)
			_SendMessage($HWnD, $WM_SETREDRAW, True, 0)
			_WinAPI_UpdateWindow($HWnD)

			getBSPos() ; update android screen coord. for clicks etc

			$g_hProcShieldInput[3] = False

			Return True
		EndIf
		updateBtnEmbed()
		Return False
	EndIf

	If $AndroidEmbedded = True Then
		If $HWnD = $HWnD2 Then
			;SetDebugLog("Android Window already embedded", Default, True)
			If $targetIsHWnD = False Then
				; Ensure android is still hidden
				WinMove2($HWnD, "", $aPosCtl[2] + 2, $frmBotPosInit[5], -1, -1, $HWND_BOTTOM)
			EndIf

			Return False
		EndIf
		SetDebugLog("Docked Android Window gone", $COLOR_RED)
		AndroidEmbed(False)
		Return AndroidEmbed(True)
	EndIf

	; Embed Android Window
	SetDebugLog("Docking Android Control...")

	If _WinAPI_IsIconic($frmBot) Then BotMinimize("_AndroidEmbed (2)", True)
	If _WinAPI_IsIconic($HWnD) Then WinSetState($HWnD, "", @SW_RESTORE)
	getAndroidPos() ; ensure window size is ok
	$aPos = WinGetPos($HWnD) ; Android Window size might has changed
	If IsArray($aPos) = 0 Then
		;SetDebugLog("Android Window not available", $COLOR_RED)
		updateBtnEmbed()
		Return False
	EndIf
	If $debugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPos[] = " & $aPos[0] & ", " & $aPos[1] & ", " & $aPos[2] & ", " & $aPos[3], Default, True)
	$lCurStyle = _WinAPI_GetWindowLong($HWnD, $GWL_STYLE)
	$lCurExStyle = _WinAPI_GetWindowLong($HWnD, $GWL_EXSTYLE)
	$HWnDParent = _WinAPI_GetParent($HWnD)
	$hCtrl = ControlGetHandle($HWnD, $AppPaneName, $AppClassInstance)
	$hCtrlTarget = _WinAPI_GetParent($hCtrl)
	$lCurStyleTarget = _WinAPI_GetWindowLong($hCtrlTarget, $GWL_STYLE)

	$targetIsHWnD = $hCtrlTarget = $HWnD

	$aPosCtl = ControlGetPos($HWnD, "", ($targetIsHWnD ? $hCtrl : $hCtrlTarget))
	If $hCtrlTarget = 0 Or IsArray($aPosCtl) = 0 Or @error <> 0 Then
		;SetDebugLog("Android Control not available", $COLOR_RED)
		updateBtnEmbed()
		Return False
	EndIf
	If $debugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosCtl[] = " & $aPosCtl[0] & ", " & $aPosCtl[1] & ", " & $aPosCtl[2] & ", " & $aPosCtl[3], Default, True)

	$hCtrlTargetParent = _WinAPI_GetParent($hCtrlTarget)
	If $targetIsHWnD Then
		Local $aPosParentCtl = $aPosCtl
		$hCtrlTargetParent = $hCtrlTarget
	Else
		Local $aPosParentCtl = ControlGetPos($HWnD, "", $hCtrlTargetParent)
		If $hCtrlTargetParent = 0 Or IsArray($aPosParentCtl) = 0 Or @error <> 0 Then
			SetDebugLog("Android Parent Control not available", $COLOR_RED)
			updateBtnEmbed()
			Return False
		EndIf
	EndIf
	If $debugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosParentCtl[] = " & $aPosParentCtl[0] & ", " & $aPosParentCtl[1] & ", " & $aPosParentCtl[2] & ", " & $aPosParentCtl[3], Default, True)

	Local $botClientWidth = $frmBotPosInit[4]
	Local $botClientHeight = $frmBotPosInit[5]
	$frmBotAddH = $aPosCtl[3] - $botClientHeight
	If $debugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $frmBotAddH = " & $frmBotAddH, Default, True)
	If $frmBotAddH < 0 Then $frmBotAddH = 0

	Local $frmBotWidth = $frmBotPosInit[2] + $aPosCtl[2] + 2
	Local $frmBotHeight = $frmBotPosInit[3] + $frmBotAddH

	$g_hProcShieldInput[3] = True

	_SendMessage($frmBot, $WM_SETREDRAW, False, 0)

	;Local $BS1_style = BitOR($WS_OVERLAPPED, $WS_MINIMIZEBOX, $WS_GROUP, $WS_SYSMENU, $WS_DLGFRAME, $WS_BORDER, $WS_CAPTION, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS, $WS_VISIBLE)

	WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2], $aPosCtl[3], $HWND_BOTTOM)
	$aPosFrmBotEx = ControlGetPos($frmBot, "", $frmBotEx)
	$aPosFrmBotEx[3] = $frmBotPosInit[6]
	If $debugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosFrmBotEx[] = " & $aPosFrmBotEx[0] & ", " & $aPosFrmBotEx[1] & ", " & $aPosFrmBotEx[2] & ", " & $aPosFrmBotEx[3], Default, True)
	WinMove($frmBotEx, "", $aPosCtl[2] + 2, 0, $aPosFrmBotEx[2], $aPosFrmBotEx[3] + $frmBotAddH)
	WinMove($frmBotBottom, "", $aPosCtl[2] + 2, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP + $frmBotAddH)
	WinSetTrans($frmBotBottom, "", 254)

	$aPosLog = ControlGetPos($frmBotEx, "", $hGUI_LOG)
	If $debugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosLog[] = " & $aPosLog[0] & ", " & $aPosLog[1] & ", " & $aPosLog[2] & ", " & $aPosLog[3], Default, True)
	WinMove($hGUI_LOG, "", $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, $aPosLog[2], $aPosLog[3] + $frmBotAddH)

	$AndroidEmbedded = True
	If $frmBotDockedPosX = -1 And $frmBotDockedPosY = -1 Then
		; determine x position based on bot / android arrangement
		If $frmBotPosX < $AndroidPosX Then
			$frmBotDockedPosX = $frmBotPosX
			$frmBotDockedPosY = $frmBotPosY
		Else
			$frmBotDockedPosX = $AndroidPosX
			$frmBotDockedPosY = $AndroidPosY
		EndIf
	EndIf
	WinMove2($frmBot, "", $frmBotDockedPosX, $frmBotDockedPosY, $frmBotWidth, $frmBotHeight, 0, 0, False)

	_WinAPI_SetWindowLong($HWnD, $GWL_EXSTYLE, $WS_EX_MDICHILD)
	_WinAPI_SetWindowLong($HWnD, $GWL_HWNDPARENT, $frmBot) ; required for BS to solve strange focus switch between bot and BS
	_WinAPI_SetParent($HWnD, $frmBot)
	Local $newStyle = BitOR($WS_CHILD, BitAND($lCurStyle, BitNOT(BitOR($WS_POPUP, $WS_CAPTION, $WS_SYSMENU))))
	_WinAPI_SetWindowLong($HWnD, $GWL_STYLE, $newStyle)
	If $targetIsHWnD = False Then
		_WinAPI_SetParent($hCtrlTarget, $frmBot)
		;_WinAPI_SetWindowLong($hCtrlTarget, $GWL_HWNDPARENT, $frmBot)
	EndIf
	_WinAPI_SetWindowLong($HWnD, $GWL_STYLE, $newStyle)

	;ControlFocus($frmBot, "", $frmBot) ; required for BlueStacks

	WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2], $aPosCtl[3], $HWND_BOTTOM)

	If $targetIsHWnD = False Then
		WinMove2($HWnD, "", $aPosCtl[2] + 2, $botClientHeight, -1, -1, $HWND_BOTTOM)
	EndIf

	$AndroidEmbeddedCtrlTarget[0] = $hCtrlTarget
	$AndroidEmbeddedCtrlTarget[1] = $hCtrlTargetParent
	$AndroidEmbeddedCtrlTarget[2] = $HWnDParent
	$AndroidEmbeddedCtrlTarget[3] = $HWnD
	$AndroidEmbeddedCtrlTarget[4] = $lCurStyle
	$AndroidEmbeddedCtrlTarget[5] = $lCurExStyle
	; convert to relative position
	$aPosCtl[0] = $aPosParentCtl[0] - $aPosCtl[0]
	$aPosCtl[1] = $aPosParentCtl[1] - $aPosCtl[1]
	$AndroidEmbeddedCtrlTarget[6] = $aPosCtl
	$AndroidEmbeddedCtrlTarget[7] = $aPos
	$AndroidEmbeddedCtrlTarget[8] = $lCurStyleTarget

	updateBtnEmbed()
	SetDebugLog("Android Window docked", Default, True)

	$iDividerY += $frmBotAddH
	cmbLog()

	_SendMessage($frmBot, $WM_SETREDRAW, True, 0)
	;RedrawBotWindowNow()
	_WinAPI_RedrawWindow($frmBot, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN + $RDW_ERASE)
	_WinAPI_RedrawWindow($frmBotBottom, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN + $RDW_ERASE)
	_WinAPI_UpdateWindow($frmBot)
	_WinAPI_UpdateWindow($frmBotBottom)
	;CheckRedrawControls(True)

	If $FrmBotMinimized = False And $activeHWnD = $frmBot Then WinActivate($activeHWnD) ; re-activate bot

	getBSPos() ; update android screen coord. for clicks etc

	If $targetIsHWnD = False Then
		_WinAPI_EnableWindow($hCtrlTarget, False)
	EndIf
	_WinAPI_EnableWindow($HWnD, False)

	$g_hProcShieldInput[3] = False
	$g_hProcShieldInput[4] = 0

	AndroidShield("AndroidEmbed dock", Default, $CallWinGetAndroidHandle)

	Return True
EndFunc   ;==>_AndroidEmbed


; Ensure embedded window stays hidden
Func AndroidEmbedCheck($bTestIfRequired = False)
	If $AndroidEmbedded = True And AndroidEmbedArrangeActive() = False Then
		Local $hCtrlTarget = $AndroidEmbeddedCtrlTarget[0]
		Local $lCurStyle = $AndroidEmbeddedCtrlTarget[4]
		Local $aPosCtl = $AndroidEmbeddedCtrlTarget[6]
		Local $targetIsHWnD = $hCtrlTarget = $HWnD

		Local $newStyle = BitOR($WS_CHILD, BitAND($lCurStyle, BitNOT(BitOR($WS_POPUP, $WS_CAPTION, $WS_SYSMENU))))
		If $bTestIfRequired = False Then
			_WinAPI_SetWindowLong($HWnD, $GWL_STYLE, $newStyle)
			If $targetIsHWnD = False Then
				; Ensure android is still hidden
				WinMove2($HWnD, "", $aPosCtl[2] + 2, $frmBotPosInit[5], -1, -1, $HWND_BOTTOM, 0, False)
			Else
				; Ensure android is still at right place
				WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2], $aPosCtl[3], $HWND_BOTTOM, 0, False)
			EndIf
			Return True
		EndIf

		; test if required
		Local $style = _WinAPI_GetWindowLong($HWnD, $GWL_STYLE)
		Local $moved = False
		If $targetIsHWnD = False Then
			Local $a = ControlGetPos($frmBot, "", $HWnD)
			$moved = $a[0] <> $aPosCtl[2] + 2 Or $a[1] <> $frmBotPosInit[5]
		Else
			Local $a = ControlGetPos($frmBot, "", $hCtrlTarget)
			$moved = $a[0] <> 0 Or $a[1] <> 0
		EndIf
		Return $style <> $newStyle Or $moved
	EndIf
	Return False
EndFunc   ;==>AndroidEmbedCheck

Func AndroidEmbedded()
	Return $AndroidEmbedded
EndFunc   ;==>AndroidEmbedded

; AndroidShieldActiveDelay return true if shield delay has been set and for $bIsStillWaiting = True also if still awaiting timeout
Func AndroidShieldActiveDelay($bIsStillWaiting = False)
	Return $AndroidShieldDelay[0] <> 0 And $AndroidShieldDelay[1] > 0 And ($bIsStillWaiting = False Or TimerDiff($AndroidShieldDelay[0]) < $AndroidShieldDelay[1])
EndFunc   ;==>AndroidShieldActiveDelay

Func AndroidEmbedArrangeActive()
	Return $g_hProcShieldInput[3]
EndFunc   ;==>AndroidEmbedArrangeActive

Func AndroidShieldCheck()
	If AndroidShieldActiveDelay(True) = True Then Return False
	Return AndroidShield("AndroidShieldCheck")
EndFunc   ;==>AndroidShieldCheck

Func ShieldInputProc($hWin, $iMsg, $wParam, $lParam)
	;ConsoleWrite("ShieldInputProc: ENTER $hWin=" & $hWin & ", $iMsg=" & Hex($iMsg) & ", $wParam=" & $wParam & ", $lParam=" & $lParam & @CRLF)
	If $AndroidEmbedded = False Or $AndroidShieldStatus[0] = True Then
		;ConsoleWrite("ShieldInputProc: EXIT $hWin=" & $hWin & ", $iMsg=" & Hex($iMsg) & ", $wParam=" & $wParam & ", $lParam=" & $lParam & @CRLF)
		Return _WinAPI_CallWindowProc($g_hProcShieldInput[1], $hWin, $iMsg, $wParam, $lParam)
	EndIf
	Switch $iMsg
		Case $WM_KEYDOWN, $WM_KEYUP, $WM_SYSKEYDOWN, $WM_SYSKEYUP, $WM_MOUSEWHEEL ; $WM_KEYFIRST To $WM_KEYLAST
			If $debugAndroidEmbedded Then SetDebugLog("ShieldInputProc: FORWARD $hWin=" & $hWin & ", $iMsg=" & Hex($iMsg) & ", $wParam=" & $wParam & ", $lParam=" & $lParam, Default, True)
			Local $hCtrlTarget = $AndroidEmbeddedCtrlTarget[0]
			Local $Result = 0
			$g_hProcShieldInput[4] = $wParam
			If $iMsg = $WM_KEYUP And $wParam = 27 Then
				; send ESC as ADB back
				Local $wasSilentSetLog = $SilentSetLog
				$SilentSetLog = True
				AndroidBackButton(False)
				$SilentSetLog = $wasSilentSetLog
				;_WinAPI_SetFocus(GUICtrlGetHandle($frmBotEmbeddedShieldInput))
				If $debugAndroidEmbedded Then AndroidShield("ShieldInputProc WM_SETFOCUS", Default, False, 0, True)
				;AndroidShield(Default, False, 10, AndroidShieldHasFocus())
			Else
				$Result = _WinAPI_PostMessage($hCtrlTarget, $iMsg, $wParam, $lParam)
				$Result = _WinAPI_CallWindowProc($g_hProcShieldInput[1], $hWin, $iMsg, $wParam, $lParam)
				_GUICtrlEdit_SetText($hWin, "")
			EndIf
			Return $Result
		Case $WM_SETFOCUS
			If $debugAndroidEmbedded Then SetDebugLog("ShieldInputProc: WM_SETFOCUS $hWin=" & $hWin & ", $iMsg=" & Hex($iMsg) & ", $wParam=" & $wParam & ", $lParam=" & $lParam, Default, True)
			AndroidShield("ShieldInputProc WM_SETFOCUS", Default, False, 0, True)
		Case $WM_KILLFOCUS
			If $debugAndroidEmbedded Then SetDebugLog("ShieldInputProc: KILLFOCUS $hWin=" & $hWin & ", $iMsg=" & Hex($iMsg) & ", $wParam=" & $wParam & ", $lParam=" & $lParam, Default, True)
			;Local $bFocus = $iMsg = $WM_SETFOCUS
			If $g_hProcShieldInput[4] <> 27 Then
				$g_hProcShieldInput[4] = 0
				If $debugAndroidEmbedded Then AndroidShield("ShieldInputProc KILLFOCUS", Default, False, 50, AndroidShieldHasFocus())
			EndIf
		Case Else
			If $debugAndroidEmbedded Then SetDebugLog("ShieldInputProc: SKIP $hWin=" & $hWin & ", $iMsg=" & Hex($iMsg, 8) & ", $wParam=" & Hex($wParam, 8) & ", $lParam=" & Hex($lParam, 8), Default, True)
	EndSwitch
	;ConsoleWrite("ShieldInputProc: SKIP $hWin=" & $hWin & ", $iMsg=" & Hex($iMsg) & ", $wParam=" & $wParam & ", $lParam=" & $lParam & @CRLF)
	Return _WinAPI_CallWindowProc($g_hProcShieldInput[1], $hWin, $iMsg, $wParam, $lParam)
EndFunc   ;==>ShieldInputProc

; Called when bot GUI initialize done
Func AndroidShieldStartup()
	AndroidShieldHook(True)
	_OnAutoItErrorRegister() ; Register custom crash handler
EndFunc   ;==>AndroidShieldStartup

; Called when bot closes
Func AndroidShieldDestroy()
	_OnAutoItErrorUnRegister() ; UnRegister custom crash handler
	AndroidShieldHook(False)
EndFunc   ;==>AndroidShieldDestroy

Func AndroidShieldHook($bInstallHooks = True)
	If $AndroidShieldEnabled = False Then Return False
	Local $Result = False

	If $bInstallHooks = True Then
		If $g_hProcShieldInput[1] = 0 Then
			If $g_hProcShieldInput[0] = 0 Then $g_hProcShieldInput[0] = DllCallbackRegister("ShieldInputProc", "ptr", "hwnd;uint;long;ptr")
			$g_hProcShieldInput[1] = _WinAPI_SetWindowLong(ControlGetHandle($frmBotEmbeddedShield, "", $frmBotEmbeddedShieldInput), $GWL_WNDPROC, DllCallbackGetPtr($g_hProcShieldInput[0]))
			$Result = True
		EndIf
	Else
		If $g_hProcShieldInput[1] <> 0 Then
			_WinAPI_SetWindowLong(ControlGetHandle($frmBotEmbeddedShield, "", $frmBotEmbeddedShieldInput), $GWL_WNDPROC, $g_hProcShieldInput[1])
			$g_hProcShieldInput[1] = 0
			$Result = True
		EndIf
	EndIf

	Return $Result
EndFunc   ;==>AndroidShieldHook

Func AndroidShieldForceDown($bForceDown = True, $AndroidHasFocus = False)
	Local $wasDown = $AndroidShieldForceDown
	$AndroidShieldForceDown = $bForceDown
	AndroidShield("AndroidShieldForceDown", Default, True, 0, $AndroidHasFocus)
	Return $wasDown
EndFunc   ;==>AndroidShieldForceDown

Func AndroidShieldForcedDown()
	Return $AndroidShieldForceDown
EndFunc   ;==>AndroidShieldForcedDown

Func AndroidShieldHasFocus()
	Return $g_hProcShieldInput[2]
EndFunc   ;==>AndroidShieldHasFocus

Func AndroidShielded()
	Return $AndroidShieldStatus[0]
EndFunc   ;==>AndroidShielded

; Syncronized _AndroidShield
Func AndroidShield($sCaller, $Enable = Default, $CallWinGetAndroidHandle = True, $iDelay = 0, $AndroidHasFocus = Default, $AndroidUpdateFocus = True)
	If $g_hProcShieldInput[3] = True Then Return False
	Local $hMutex = AcquireMutex("AndroidShield", Default, 1000)
	If $hMutex <> 0 Then
		Return ReleaseMutex($hMutex, _AndroidShield($sCaller, $Enable, $CallWinGetAndroidHandle, $iDelay, $AndroidHasFocus, $AndroidUpdateFocus))
	EndIf
	Return False
EndFunc   ;==>AndroidShield

Func _AndroidShield($sCaller, $Enable = Default, $CallWinGetAndroidHandle = True, $iDelay = 0, $AndroidHasFocus = Default, $AndroidUpdateFocus = True)

	If AndroidShieldActiveDelay() Then
		If AndroidShieldActiveDelay(True) = False Then
			If $Enable = Default Then $Enable = $AndroidShieldDelay[2]
			If $AndroidHasFocus = Default Then $AndroidHasFocus = $AndroidShieldDelay[3]
		Else
			If $iDelay = 0 Then
				If $Enable <> Default Then $AndroidShieldDelay[2] = $Enable
				If $AndroidHasFocus <> Default Then $AndroidShieldDelay[3] = $AndroidHasFocus
				Return False
			EndIf
		EndIf
	EndIf

	If $iDelay > 0 Then
		$AndroidShieldDelay[0] = TimerInit()
		$AndroidShieldDelay[1] = $iDelay
		$AndroidShieldDelay[2] = $Enable
		$AndroidShieldDelay[3] = $AndroidHasFocus
		Return False
	EndIf

	$AndroidShieldDelay[0] = 0
	$AndroidShieldDelay[1] = 0
	$AndroidShieldDelay[2] = Default
	$AndroidShieldDelay[3] = Default

	If $Enable = Default Then
		; determin shield status
		$Enable = $RunState And $TPaused = False
		If $AndroidShieldForceDown Then $Enable = False
	EndIf

	If $AndroidHasFocus = Default Then
		$AndroidHasFocus = AndroidShieldHasFocus() ;_WinAPI_GetFocus() = GUICtrlGetHandle($frmBotEmbeddedShieldInput)
	Else
		If $AndroidUpdateFocus Then $g_hProcShieldInput[2] = $AndroidHasFocus
	EndIf

	Local $shieldState = "active"
	Local $color = $AndroidShieldColor
	Local $trans = $AndroidShieldTransparency

	If $Enable = False Or $TPaused = True Then
		If _WinAPI_GetActiveWindow() = $frmBot And $AndroidHasFocus Then
			; android has focus
			$shieldState = "disabled-focus"
			$color = $AndroidActiveColor
			$trans = $AndroidActiveTransparency
			;$g_hProcShieldInput[2] = True
		Else
			; android without focus
			$shieldState = "disabled-nofocus"
			$color = $AndroidInactiveColor
			$trans = $AndroidInactiveTransparency
		EndIf
	EndIf

	If $AndroidShieldStatus[0] = $Enable And $AndroidShieldStatus[1] = $color And $AndroidShieldStatus[2] = $trans Then
		; nothing to do
		Return False
	EndIf

	If $AndroidEmbedded = False Then
		; nothing to do
		Return False
	EndIf
	If ($CallWinGetAndroidHandle = False And $HWnD = 0) Or ($CallWinGetAndroidHandle = True And WinGetAndroidHandle() = 0) Then
		; nothing to do
		Return False
	EndIf
	If $AndroidBackgroundLaunched = True Then
		; nothing to do
		Return False
	EndIf

	Local $aPos = WinGetPos($HWnD)
	If IsArray($aPos) = 0 Or @error <> 0 Then
		; nothing to do
		Return False
	EndIf

	Local $hCtrlTarget = $AndroidEmbeddedCtrlTarget[0]
	Local $aPosCtl = $AndroidEmbeddedCtrlTarget[6]
	Local $targetIsHWnD = $hCtrlTarget = $HWnD

	If $AndroidShieldEnabled = True Then

		If $Enable <> $AndroidShieldStatus[0] Then
			If $Enable = True Then
				SetDebugLog("Shield Android Control (" & $aPosCtl[2] & "x" & $aPosCtl[3] & ")", Default, True)
				; Remove hooks as not not needed when shielded
				;AndroidShieldHook(False)
			Else
				SetDebugLog("Unshield Android Control", Default, True)
				; Add hooks to forward messages to android
				;AndroidShieldHook(True)
			EndIf

			WinMove2($hCtrlTarget, "", -1, -1, -1, -1, $HWND_BOTTOM)
			WinMove($frmBotEmbeddedShield, "", 0, 0, $aPosCtl[2], $aPosCtl[3]) ; $HWND_TOPMOST

			If $targetIsHWnD = False Then
				_WinAPI_EnableWindow($hCtrlTarget, False)
			EndIf
			_WinAPI_EnableWindow($HWnD, False)
		EndIf

		; only play with overlay when screencapture background mode is on
		If $AndroidShieldPreWin8 = False Then
			WinSetTrans($frmBotEmbeddedShield, "", $trans)
			GUISetBkColor($color, $frmBotEmbeddedShield)
		EndIf
		GUISetState(@SW_SHOWNOACTIVATE, $frmBotEmbeddedShield)

	Else
		If $targetIsHWnD = False Then
			_WinAPI_EnableWindow($hCtrlTarget, Not $Enable)
		EndIf
		_WinAPI_EnableWindow($HWnD, Not $Enable)
	EndIf

	; update shield current status
	$AndroidShieldStatus[0] = $Enable
	$AndroidShieldStatus[1] = $color
	$AndroidShieldStatus[2] = $trans

	; Add hooks
	AndroidShieldStartup()

	SetDebugLog("AndroidShield updated to " & $shieldState & ", caller: " & $sCaller, Default, True)

	Return True
EndFunc   ;==>_AndroidShield

Func AndroidGraphicsGdiBegin()
	AndroidGraphicsGdiEnd()

	Local $iW = $AndroidClientWidth
	Local $iH = $AndroidClientHeight
	Local $iOpacity = 255

	Local $aPosCtl = $AndroidEmbeddedCtrlTarget[6]
	If IsArray($aPosCtl) = 1 Then
		$iW = $aPosCtl[2]
		$iH = $aPosCtl[3]
	EndIf

	If $AndroidEmbedded = True Then
		GUISetState(@SW_SHOWNOACTIVATE, $frmBotEmbeddedGarphics)
		WinMove($frmBotEmbeddedGarphics, "", 0, 0, $iW, $iH) ; $HWND_TOPMOST
	EndIf

	Local $hDC = _WinAPI_GetDC($frmBot)
	Local $hMDC = AndroidGraphicsGdiAddObject("hMDC", _WinAPI_CreateCompatibleDC($hDC)) ; idx = 0
	Local $hBitmap = AndroidGraphicsGdiAddObject("hBitmap", _WinAPI_CreateCompatibleBitmap($hDC, $iW, $iH)) ; idx = 1
	_WinAPI_SelectObject($hMDC, $hBitmap)
	AndroidGraphicsGdiAddObject("hDC", $hDC) ; idx = 2
	Local $hGraphics = AndroidGraphicsGdiAddObject("Graphics", _GDIPlus_GraphicsCreateFromHDC($hMDC)) ; idx = 3

	_GDIPlus_GraphicsSetSmoothingMode($hGraphics, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
	_GDIPlus_GraphicsClear($hGraphics)

	Local $tSize = DllStructCreate($tagSIZE)
	AndroidGraphicsGdiAddObject("DllStruct", $tSize) ; idx = 4
	Local $pSize = DllStructGetPtr($tSize)
	DllStructSetData($tSize, "X", $iW)
	DllStructSetData($tSize, "Y", $iH)
	Local $tSource = DllStructCreate($tagPOINT)
	AndroidGraphicsGdiAddObject("DllStruct", $tSource) ; idx = 5
	Local $pSource = DllStructGetPtr($tSource)
	Local $tBlend = DllStructCreate($tagBLENDFUNCTION)
	AndroidGraphicsGdiAddObject("DllStruct", $tBlend) ; idx = 6
	Local $pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", $iOpacity)
	DllStructSetData($tBlend, "Format", 1)
	Local $tPoint = DllStructCreate($tagPOINT)
	AndroidGraphicsGdiAddObject("DllStruct", $tPoint) ; idx = 7
	Local $pPoint = DllStructGetPtr($tPoint)
	DllStructSetData($tPoint, "X", 0)
	DllStructSetData($tPoint, "Y", 0)
	AndroidGraphicsGdiUpdate()
	SetDebugLog("AndroidGraphicsGdiBegin: Graphics " & $hGraphics)
	Return $hGraphics
EndFunc   ;==>AndroidGraphicsGdiBegin

Func AndroidGraphicsGdiUpdate()
	Local $hMDC = $aAndroidEmbeddedGraphics[0][1]
	Local $hDC = $aAndroidEmbeddedGraphics[2][1]
	Local $pSize = DllStructGetPtr($aAndroidEmbeddedGraphics[4][1])
	Local $pSource = DllStructGetPtr($aAndroidEmbeddedGraphics[5][1])
	Local $pBlend = DllStructGetPtr($aAndroidEmbeddedGraphics[6][1])
	Local $pPoint = DllStructGetPtr($aAndroidEmbeddedGraphics[7][1])
	_WinAPI_UpdateLayeredWindow($frmBotEmbeddedGarphics, $hDC, $pPoint, $pSize, $hMDC, $pSource, 0, $pBlend, $ULW_ALPHA)
EndFunc   ;==>AndroidGraphicsGdiUpdate

Func AndroidGraphicsGdiAddObject($sType, $hHandle)
	Local $i = UBound($aAndroidEmbeddedGraphics)
	ReDim $aAndroidEmbeddedGraphics[$i + 1][2]
	$aAndroidEmbeddedGraphics[$i][0] = $sType
	$aAndroidEmbeddedGraphics[$i][1] = $hHandle
	SetDebugLog("AndroidGraphicsGdiAddObject: " & $sType & " " & $hHandle)
	Return $hHandle
EndFunc   ;==>AndroidGraphicsGdiAddObject

Func AndroidGraphicsGdiEnd($Result = Default, $bClear = True)
	If UBound($aAndroidEmbeddedGraphics) > 0 Then
		Local $i
		For $i = UBound($aAndroidEmbeddedGraphics) - 1 To 0 Step -1
			Local $sType = $aAndroidEmbeddedGraphics[$i][0]
			Local $hHandle = $aAndroidEmbeddedGraphics[$i][1]
			SetDebugLog("AndroidGraphicsGdiEnd: Dispose/release/delete " & $sType & " " & $hHandle)
			Switch $sType
				Case "Pen"
					_GDIPlus_PenDispose($hHandle)
				Case "DllStruct"
					;$aAndroidEmbeddedGraphics[$i][1] = 0 ; still needed for AndroidGraphicsGdiUpdate()
				Case "Graphics"
					_GDIPlus_GraphicsClear($hHandle)
					AndroidGraphicsGdiUpdate()
					_GDIPlus_GraphicsDispose($hHandle)
				Case "hDC"
					_WinAPI_ReleaseDC($frmBotEmbeddedGarphics, $hHandle)
				Case "hBitmap"
					_WinAPI_DeleteObject($hHandle)
				Case "hMDC"
					_WinAPI_DeleteDC($hHandle)
				Case Else
					SetDebugLog("Unknown GDI Type: " & $sType)
			EndSwitch
		Next
		ReDim $aAndroidEmbeddedGraphics[0][2]
		GUISetState(@SW_HIDE, $frmBotEmbeddedGarphics)
	EndIf

	Return $Result
EndFunc   ;==>AndroidGraphicsGdiEnd
