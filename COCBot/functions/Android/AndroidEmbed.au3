; #FUNCTION# ====================================================================================================================
; Name ..........: AndroidEmbed
; Description ...: This file contains the fucntions to dock Android into Bot window and handle shield.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (2016-07)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_hProcShieldInput[5] = [0, 0, False, False, 0]
Global $aAndroidEmbeddedGraphics[0][2]

; Return Android window handle containing the Android rendering control
Func GetCurrentAndroidHWnD()
	Local $h = (($AndroidEmbedded = False Or $AndroidEmbedMode = 1) ? $HWnD : $frmBot)
	Return $h
EndFunc   ;==>GetCurrentAndroidHWnD

; Syncronized _AndroidEmbed
Func AndroidEmbed($Embed = True, $CallWinGetAndroidHandle = True, $bForceEmbed = False)
	If $AndroidEmbed = False Then Return False
	Local $hMutex = AcquireMutex("AndroidEmbed", Default, 1000)
	If $hMutex <> 0 Then
		Return ReleaseMutex($hMutex, _AndroidEmbed($Embed, $CallWinGetAndroidHandle, $bForceEmbed))
	EndIf
	Return False
EndFunc   ;==>AndroidEmbed

Func _AndroidEmbed($Embed = True, $CallWinGetAndroidHandle = True, $bForceEmbed = False)

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

	Local $hCtrl = ControlGetHandle(GetCurrentAndroidHWnD(), $AppPaneName, $AppClassInstance)
	Local $aPosFrmBotEx, $aPosLog
	Local $hCtrlTarget = $AndroidEmbeddedCtrlTarget[0]
	Local $hCtrlTargetParent = $AndroidEmbeddedCtrlTarget[1]
	Local $HWnDParent = $AndroidEmbeddedCtrlTarget[2]
	Local $HWnD2 = $AndroidEmbeddedCtrlTarget[3]
	Local $lCurStyle = $AndroidEmbeddedCtrlTarget[4]
	Local $lCurExStyle = $AndroidEmbeddedCtrlTarget[5]
	Local $aPosCtl = $AndroidEmbeddedCtrlTarget[6]
	Local $lCurStyleTarget = $AndroidEmbeddedCtrlTarget[8]
	Local $hThumbnail = $AndroidEmbeddedCtrlTarget[9]
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

			SetDebugLog("Undocking Android Control...")

			If _WinAPI_IsIconic($frmBot) Then BotMinimize("_AndroidEmbed (1)", True)

			If $AndroidShieldEnabled = True Then
				AndroidShield("AndroidEmbed undock", False, $CallWinGetAndroidHandle, 100)
				;_WinAPI_ShowWindow($frmBotEmbeddedShield, @SW_HIDE)
				;GUISetState(@SW_HIDE, $frmBotEmbeddedShield)
				GUIDelete($frmBotEmbeddedShield)
				$frmBotEmbeddedShield = 0
				If $frmBotEmbeddedMouse Then
					GUIDelete($frmBotEmbeddedMouse)
					$frmBotEmbeddedMouse = 0
				EndIf
				$AndroidShieldStatus[0] = Default
			EndIf

			SetRedrawBotWindow(False)

			If $hThumbnail <> 0 Then
				_WinAPI_DwmUnregisterThumbnail($hThumbnail)
				$AndroidEmbeddedCtrlTarget[9] = 0
			EndIf

			$aPos = $AndroidEmbeddedCtrlTarget[7]

			$g_hProcShieldInput[3] = True

			Switch $AndroidEmbedMode
				Case 0
					If $targetIsHWnD = False Then
						;ControlMove($hCtrlTarget, "", "", $aPosCtl[0], $aPosCtl[1], $aPosCtl[2], $aPosCtl[3])
						_WinAPI_SetParent($hCtrlTarget, $hCtrlTargetParent)
						;_WinAPI_SetWindowLong($hCtrlTarget, $GWL_HWNDPARENT, $hCtrlTargetParent)
					EndIf
					;_WinAPI_SetWindowLong($HWnd, $GWL_STYLE, BitOR(_WinAPI_GetWindowLong($HWnD, $GWL_STYLE), $WS_MINIMIZE)) ; ensures that Android Window shows up in taskbar
					_WinAPI_SetWindowLong($HWnD, $GWL_EXSTYLE, $lCurExStyle)
					_WinAPI_SetParent($HWnD, $HWnDParent)
					_WinAPI_SetWindowLong($HWnD, $GWL_HWNDPARENT, $HWnDParent) ; required for BS to solve strange focus switch between bot and BS
					_WinAPI_SetWindowLong($HWnD, $GWL_STYLE, $lCurStyle)
					WinMove($HWnD, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3] - 1) ; this fixes strange manual mouse clicks off in BS after undock
					WinMove2($HWnD, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
				Case 1
					_WinAPI_SetWindowLong($HWnD, $GWL_EXSTYLE, $lCurExStyle)
					_WinAPI_SetWindowLong($HWnD, $GWL_STYLE, $lCurStyle)
					WinMove($HWnD, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3] - 1) ; force redraw this way (required for LeapDroid)
					WinMove($HWnD, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3]) ; force redraw this way (required for LeapDroid)
			EndSwitch
			; move Android rendering control back to its place
			WinMove(($targetIsHWnD ? $hCtrl : $hCtrlTarget), "", $aPosCtl[0], $aPosCtl[1], $aPosCtl[2], $aPosCtl[3])
			WinMove2(($targetIsHWnD ? $hCtrl : $hCtrlTarget), "", $aPosCtl[0], $aPosCtl[1], $aPosCtl[2], $aPosCtl[3], 0, 0, False)

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

			$iDividerY -= $frmBotAddH
			$frmBotAddH = 0
			cmbLog()

			SetRedrawBotWindow(True)
			; Ensure android window shows up in taskbar again
			_SendMessage($HWnD, $WM_SETREDRAW, False, 0)
			;WinSetState($HWnD, "", @SW_HIDE)
			_WinAPI_ShowWindow($HWnD, @SW_HIDE)
			_WinAPI_SetWindowLong($HWnD, $GWL_EXSTYLE, BitOR($lCurExStyle, $WS_EX_APPWINDOW))
			;WinSetState($HWnD, "", @SW_SHOW)
			_WinAPI_ShowWindow($HWnD, @SW_SHOWNOACTIVATE)
			_SendMessage($HWnD, $WM_SETREDRAW, True, 0)
			_WinAPI_UpdateWindow($HWnD)
			_WinAPI_SetWindowLong($HWnD, $GWL_EXSTYLE, $lCurExStyle)

			_WinAPI_EnableWindow($HWnD, True)
			_WinAPI_EnableWindow($hCtrlTarget, True)

			; move Android rendering control back to its place
			WinMove2(($targetIsHWnD ? $hCtrl : $hCtrlTarget), "", $aPosCtl[0], $aPosCtl[1], $aPosCtl[2], $aPosCtl[3], 0, 0, False)
			getAndroidPos() ; ensure window size is ok
			getBSPos() ; update android screen coord. for clicks etc

			Execute("Embed" & $Android & "(False)")
			If $AndroidEmbedMode = 1 Then
				; bring android back to front
				WinMove2($HWnD, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3], $HWND_TOPMOST)
				WinMove2($HWnD, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3], $HWND_NOTOPMOST, 0, False)
			EndIf

			SetDebugLog("Undocked Android Window")

			$g_hProcShieldInput[3] = False

			Return True
		EndIf
		updateBtnEmbed()
		Return False
	EndIf

	If $AndroidEmbedded = True And $bForceEmbed = False Then
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

	Local $bAlreadyEmbedded = $AndroidEmbedded = True

	; Embed Android Window
	SetDebugLog("Docking Android Control...")

	If _WinAPI_DwmEnableComposition(True) = 1 Then
		SetDebugLog("Desktop Window Manager available", $COLOR_GREEN)
	Else
		SetDebugLog("Desktop Window Manager not available!", $COLOR_RED)
		SetDebugLog("Android Shield will be invisible!", $COLOR_RED)
	EndIf

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
	;_WinAPI_SetWindowLong($hCtrl, $GWL_STYLE, BitAND(_WinAPI_GetWindowLong($hCtrl, $GWL_STYLE), BitNOT($WS_EX_NOPARENTNOTIFY)))
	$hCtrlTarget = _WinAPI_GetParent($hCtrl)
	$lCurStyleTarget = _WinAPI_GetWindowLong($hCtrlTarget, $GWL_STYLE)

	$targetIsHWnD = $hCtrlTarget = $HWnD
	If $bAlreadyEmbedded = True Then

		$g_hProcShieldInput[3] = True

	Else

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

		WinMove2($frmBot, "", $frmBotDockedPosX, $frmBotDockedPosY, -1, -1, 0, 0, False)

		_SendMessage($frmBot, $WM_SETREDRAW, False, 0)

		;Local $BS1_style = BitOR($WS_OVERLAPPED, $WS_MINIMIZEBOX, $WS_GROUP, $WS_SYSMENU, $WS_DLGFRAME, $WS_BORDER, $WS_CAPTION, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS, $WS_VISIBLE)
		If $AndroidEmbedMode = 0 Then
			WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2], $aPosCtl[3], $HWND_BOTTOM)
		EndIf
		$aPosFrmBotEx = ControlGetPos($frmBot, "", $frmBotEx)
		$aPosFrmBotEx[3] = $frmBotPosInit[6]
		If $debugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosFrmBotEx[] = " & $aPosFrmBotEx[0] & ", " & $aPosFrmBotEx[1] & ", " & $aPosFrmBotEx[2] & ", " & $aPosFrmBotEx[3], Default, True)
		WinMove($frmBotEx, "", $aPosCtl[2] + 2, 0, $aPosFrmBotEx[2], $aPosFrmBotEx[3] + $frmBotAddH)
		WinMove($frmBotBottom, "", $aPosCtl[2] + 2, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP + $frmBotAddH)
		WinSetTrans($frmBotBottom, "", 254)

		$aPosLog = ControlGetPos($frmBotEx, "", $hGUI_LOG)
		If $debugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosLog[] = " & $aPosLog[0] & ", " & $aPosLog[1] & ", " & $aPosLog[2] & ", " & $aPosLog[3], Default, True)
		WinMove($hGUI_LOG, "", $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, $aPosLog[2], $aPosLog[3] + $frmBotAddH)

		WinMove2($frmBot, "", $frmBotDockedPosX, $frmBotDockedPosY, $frmBotWidth, $frmBotHeight, 0, 0, False)

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
	EndIf

	Local $newStyle = AndroidEmbed_GWL_STYLE()
	SetDebugLog("AndroidEmbed_GWL_STYLE=" & Get_GWL_STYLE_Text($newStyle))
	Local $a = AndroidEmbed_HWnD_Position()
	Switch $AndroidEmbedMode
		Case 0
			_WinAPI_SetWindowLong($HWnD, $GWL_EXSTYLE, $WS_EX_MDICHILD)
			_WinAPI_SetWindowLong($HWnD, $GWL_HWNDPARENT, $frmBot) ; required for BS to solve strange focus switch between bot and BS
			_WinAPI_SetWindowLong($HWnD, $GWL_STYLE, $newStyle)
			_WinAPI_SetParent($HWnD, $frmBot)
			If $targetIsHWnD = False Then
				_WinAPI_SetParent($hCtrlTarget, $frmBot)
				;_WinAPI_SetWindowLong($hCtrlTarget, $GWL_HWNDPARENT, $frmBot)
			EndIf
			_WinAPI_SetWindowLong($HWnD, $GWL_STYLE, $newStyle)
			;ControlFocus($frmBot, "", $frmBot) ; required for BlueStacks
			WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2], $aPosCtl[3] - 1, $HWND_BOTTOM, 0, False) ; trigger window change (required for BS in Windows 7)
			WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2], $aPosCtl[3], $HWND_BOTTOM, 0, False)
			If $targetIsHWnD = False Then
				WinMove2($HWnD, "", $a[0], $a[1], -1, -1, $HWND_BOTTOM, 0, False)
			EndIf
		Case 1
			_WinAPI_SetWindowLong($HWnD, $GWL_STYLE, $newStyle)
			; Hide android window in taskbar
			WinMove2($HWnD, "", -1, -1, -1, -1, 0, $SWP_HIDEWINDOW, False)
			_WinAPI_ShowWindow($HWnD, @SW_HIDE)
			_WinAPI_SetWindowLong($HWnD, $GWL_EXSTYLE, BitOR(_WinAPI_GetWindowLong($HWnD, $GWL_EXSTYLE), $WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE))
			_WinAPI_ShowWindow($HWnD, @SW_SHOWNOACTIVATE)
			_SendMessage($HWnD, $WM_SETREDRAW, True, 0)
			_WinAPI_UpdateWindow($HWnD)
			_WinAPI_SetWindowLong($HWnD, $GWL_EXSTYLE, BitOR(_WinAPI_GetWindowLong($HWnD, $GWL_EXSTYLE), $WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE))

			WinMove($HWnD, "", $a[0], $a[1], $aPosCtl[2], $aPosCtl[3] - 1) ; force redraw this way (required for LeapDroid)
			WinMove($HWnD, "", $a[0], $a[1], $aPosCtl[2], $aPosCtl[3]) ; force redraw this way (required for LeapDroid)
			; register thumbnail
			If _WinAPI_DwmIsCompositionEnabled() And $hThumbnail = 0 Then
				$hThumbnail = _WinAPI_DwmRegisterThumbnail($frmBot, $HWnD)
				Local $tSIZE = _WinAPI_DwmQueryThumbnailSourceSize($hThumbnail)
				Local $iWidth = DllStructGetData($tSIZE, 1)
				Local $iHeight = DllStructGetData($tSIZE, 2)
				Local $tDestRect = _WinAPI_CreateRectEx(0, 0, $iWidth, $iHeight)
				Local $tSrcRect = _WinAPI_CreateRectEx(0, 0, $iWidth, $iHeight)
				_WinAPI_DwmUpdateThumbnailProperties($hThumbnail, 1, 0, 255, $tDestRect, $tSrcRect)
				$AndroidEmbeddedCtrlTarget[9] = $hThumbnail
			EndIf
			WinMove2($HWnD, "", $a[0], $a[1], $aPosCtl[2], $aPosCtl[3], $HWND_BOTTOM, $SWP_SHOWWINDOW, False)
	EndSwitch

	Execute("Embed" & $Android & "(True)")
	updateBtnEmbed()

	$iDividerY += $frmBotAddH
	cmbLog()

	_WinAPI_EnableWindow($hCtrlTarget, False)
	_WinAPI_EnableWindow($HWnD, False)

	Local $aCheck = WinGetPos($HWnD)
	If IsArray($aCheck) Then
		If $debugAndroidEmbedded Then SetDebugLog("AndroidEmbed: Android Window Pos: " & $aCheck[0] & ", " & $aCheck[1] & ", " & $aCheck[2] & ", " & $aCheck[3], Default, True)
	Else
		SetDebugLog("AndroidEmbed: Android Window not found", $COLOR_RED)
	EndIf
	Local $aCheck = ControlGetPos(GetCurrentAndroidHWnD(), $AppPaneName, $AppClassInstance)
	If IsArray($aCheck) Then
		If $debugAndroidEmbedded Then SetDebugLog("AndroidEmbed: Android Control Pos: " & $aCheck[0] & ", " & $aCheck[1] & ", " & $aCheck[2] & ", " & $aCheck[3], Default, True)
	Else
		SetDebugLog("AndroidEmbed: Android Control not found", $COLOR_RED)
	EndIf

	getBSPos() ; update android screen coord. for clicks etc

	_SendMessage($frmBot, $WM_SETREDRAW, True, 0)
	;RedrawBotWindowNow()
	_WinAPI_RedrawWindow($frmBot, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN + $RDW_ERASE)
	_WinAPI_RedrawWindow($frmBotBottom, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN + $RDW_ERASE)
	_WinAPI_UpdateWindow($frmBot)
	_WinAPI_UpdateWindow($frmBotBottom)
	;CheckRedrawControls(True)

	;If $FrmBotMinimized = False And $activeHWnD = $frmBot Then WinActivate($activeHWnD) ; re-activate bot

	SetDebugLog("Android Window docked")

	$g_hProcShieldInput[3] = False
	$g_hProcShieldInput[4] = 0

	AndroidShield("AndroidEmbed dock", Default, $CallWinGetAndroidHandle, 100)

	Return True
EndFunc   ;==>_AndroidEmbed

Func Get_GWL_STYLE_Text($iGWL_STYLE)
	Local $s = ""
	Local $a[20][2] = [[$WS_MAXIMIZEBOX, "$WS_MAXIMIZEBOX"] _
			, [$WS_MINIMIZEBOX, "$WS_MINIMIZEBOX"] _
			, [$WS_TABSTOP, "$WS_TABSTOP"] _
			, [$WS_GROUP, "$WS_GROUP"] _
			, [$WS_SIZEBOX, "$WS_SIZEBOX"] _
			, [$WS_SYSMENU, "$WS_SYSMENU"] _
			, [$WS_HSCROLL, "$WS_HSCROLL"] _
			, [$WS_VSCROLL, "$WS_VSCROLL"] _
			, [$WS_DLGFRAME, "$WS_DLGFRAME"] _
			, [$WS_BORDER, "$WS_BORDER"] _
			, [$WS_CAPTION, "$WS_CAPTION"] _
			, [$WS_MAXIMIZE, "$WS_MAXIMIZE"] _
			, [$WS_CLIPCHILDREN, "$WS_CLIPCHILDREN"] _
			, [$WS_CLIPSIBLINGS, "$WS_CLIPSIBLINGS"] _
			, [$WS_DISABLED, "$WS_DISABLED"] _
			, [$WS_VISIBLE, "$WS_VISIBLE"] _
			, [$WS_MINIMIZE, "$WS_MINIMIZE"] _
			, [$WS_CHILD, "$WS_CHILD"] _
			, [$WS_POPUP, "$WS_POPUP"] _
			, [$WS_POPUPWINDOW, "$WS_POPUPWINDOW"] _
			]
	Local $i
	For $i = 0 To UBound($a) - 1
		If BitAND($iGWL_STYLE, $a[$i][0]) > 0 Then
			If $s <> "" Then $s &= ", "
			$s &= $a[$i][1]
			$iGWL_STYLE -= $a[$i][0]
		EndIf
	Next
	If $iGWL_STYLE > 0 Then
		If $s <> "" Then $s &= ","
		$s &= Hex($iGWL_STYLE, 8)
	EndIf

	Return $s
EndFunc   ;==>Get_GWL_STYLE_Text

Func AndroidEmbed_GWL_STYLE()
	If $AndroidEmbedded = True Then
		Local $lCurStyle = $AndroidEmbeddedCtrlTarget[4]
		Local $newStyle = BitOR($WS_CHILD, BitAND($lCurStyle, BitNOT(BitOR($WS_POPUP, $WS_CAPTION, $WS_SYSMENU, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_BORDER, $WS_THICKFRAME))))
		;Local $newStyle = BitOR($WS_VISIBLE, $WS_CHILD, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS)
		If $AndroidEmbedMode = 1 Then
			$newStyle = BitOR($WS_POPUP, BitAND($newStyle, BitNOT($WS_CHILD)))
		EndIf
		Return $newStyle
	EndIf
	Return ""
EndFunc   ;==>AndroidEmbed_GWL_STYLE

Func AndroidEmbed_HWnD_Position($bForShield = False, $bDetachedShield = Default, $hCtrlTarget = Default, $aPosCtl = Default)
	Local $aPos[2]

	If $bDetachedShield = Default Then
		$bDetachedShield = $AndroidShieldStatus[4]
	EndIf
	If $AndroidEmbedMode = 1 Or ($bForShield = True And $bDetachedShield = True) Then
		Local $tPoint = DllStructCreate("int X;int Y")
		DllStructSetData($tPoint, "X", 0)
		DllStructSetData($tPoint, "Y", 0)
		_WinAPI_ClientToScreen($frmBot, $tPoint)
		$aPos[0] = DllStructGetData($tPoint, "X")
		$aPos[1] = DllStructGetData($tPoint, "Y")
	ElseIf $AndroidEmbedMode = 0 And $bForShield = False Then
		If $hCtrlTarget = Default Then
			$hCtrlTarget = $AndroidEmbeddedCtrlTarget[0]
		EndIf
		If $aPosCtl = Default Then
			$aPosCtl = $AndroidEmbeddedCtrlTarget[6]
		EndIf
		Local $targetIsHWnD = $hCtrlTarget = $HWnD
		If $targetIsHWnD = False Then
			$aPos[0] = $aPosCtl[2] + 2
			$aPos[1] = $frmBotPosInit[5]
		Else
			$aPos[0] = 0
			$aPos[1] = 0
		EndIf
	ElseIf $bForShield = True And $bDetachedShield = False Then
		$aPos[0] = 0
		$aPos[1] = 0
	Else
		SetDebugLog("AndroidEmbed_HWnD_Position: Wrong window state:" & @CRLF & _
				"$bForShield=" & $bForShield & @CRLF & _
				"$AndroidEmbedMode=" & $AndroidEmbedMode & @CRLF & _
				"$bDetachedShield=" & $bDetachedShield)
	EndIf

	Return $aPos
EndFunc   ;==>AndroidEmbed_HWnD_Position

; Ensure embedded window stays hidden
Func AndroidEmbedCheck($bTestIfRequired = Default, $bHasFocus = Default, $iAction = 6)

	If $bHasFocus = Default Then $bHasFocus = WinActive($frmBot) <> 0

	If $bTestIfRequired = Default Then
		$iAction = AndroidEmbedCheck(True, $bHasFocus)
		If $iAction > 0 Then
			Return AndroidEmbedCheck(False, $bHasFocus, $iAction)
		EndIf
	EndIf
	If $AndroidEmbedded = True And AndroidEmbedArrangeActive() = False Then
		Local $hCtrlTarget = $AndroidEmbeddedCtrlTarget[0]
		Local $aPosCtl = $AndroidEmbeddedCtrlTarget[6]
		Local $targetIsHWnD = $hCtrlTarget = $HWnD
		Local $aPos = AndroidEmbed_HWnD_Position()
		Local $aPosShield = AndroidEmbed_HWnD_Position(True)
		Local $newStyle = AndroidEmbed_GWL_STYLE()
		Local $bDetachedShield = $AndroidShieldStatus[4]
		If $bTestIfRequired = False Then
			SetDebugLog("AndroidEmbedCheck: $iAction=" & $iAction, Default, True)
			;If BitAND($iAction, 2) > 0 Then _WinAPI_SetWindowLong($HWnD, $GWL_STYLE, $newStyle)
			If BitAND($iAction, 2) > 0 Then
				; bad... need to dock again
				AndroidEmbedArrangeActive(True)
				_WinAPI_SetWindowLong($HWnD, $GWL_STYLE, $newStyle)
				AndroidEmbed(True, False, True)
			EndIf
			If BitAND($iAction, 1) Or BitAND($iAction, 4) > 0 Then
				; Ensure android is still hidden
				WinMove2($HWnD, "", $aPos[0], $aPos[1], -1, -1, $HWND_BOTTOM, 0, True)
			EndIf
			; Ensure shield is still at its right place
			If $AndroidShieldEnabled = True And $bDetachedShield = True Then
				If BitAND($iAction, 1) > 0 Or BitAND($iAction, 4) > 0 Then
					If BitAND($iAction, 4) > 0 Then
						WinMove2($frmBotEmbeddedShield, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], ($bHasFocus ? $HWND_TOPMOST : $HWND_NOTOPMOST), 0, False)
						;If $bHasFocus Then WinMove2($frmBotEmbeddedShield, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], $HWND_NOTOPMOST, 0, False)
						If $frmBotEmbeddedGarphics Then
							WinMove2($frmBotEmbeddedGarphics, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], ($bHasFocus ? $HWND_TOPMOST : $HWND_NOTOPMOST), 0, False)
							;If $bHasFocus Then WinMove2($frmBotEmbeddedGarphics, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], $HWND_NOTOPMOST, False)
						EndIf
					EndIf
					If $bHasFocus = False Then ; Always update z-order, so no "And BitAND($iAction, 1) > 0"
						; update z-order
						;If $frmBotEmbeddedGarphics Then WinMove2($frmBotEmbeddedGarphics, "", -1, -1, -1, -1, $frmBotEmbeddedShield, 0, False)
						WinMove2($frmBotEmbeddedShield, "", -1, -1, -1, -1, $frmBot, 0, False)
						WinMove2($frmBot, "", -1, -1, -1, -1, $frmBotEmbeddedShield, 0, False)
					EndIf
				EndIf
			EndIf
			Return True
		EndIf

		; test if update is required
		Local $iZorder = 0
		If $AndroidShieldEnabled = True And $bDetachedShield = True And $bHasFocus = False Then
			; check z-order
			If $AndroidShieldEnabled = True Then
				Local $h = _WinAPI_GetWindow($frmBotEmbeddedShield, $GW_HWNDNEXT)
				If $h <> $frmBot Then $iZorder = 1
			EndIf
		EndIf

		Local $style = _WinAPI_GetWindowLong($HWnD, $GWL_STYLE)
		If BitAND($style, $WS_DISABLED) > 0 Then $newStyle = BitOR($newStyle, $WS_DISABLED)
		Local $iStyle = (($style <> $newStyle) ? 2 : 0)
		If $iStyle > 0 Then
			SetDebugLog("AndroidEmbedCheck: Android Window GWL_STYLE changed: " & Get_GWL_STYLE_Text($newStyle) & " to " & Get_GWL_STYLE_Text($style), Default, True)
		EndIf
		Local $a1[2] = [$aPos[0], $aPos[1]]
		Local $a2 = $aPos
		Switch $AndroidEmbedMode
			Case 0
				Local $a1 = ControlGetPos($frmBot, "", $HWnD)
			Case 1
				Local $a1 = WinGetPos($HWnD)
		EndSwitch
		Local $iPos = ((IsArray($a1) And ($a1[0] <> $a2[0] Or $a1[1] <> $a2[1])) ? 4 : 0)
		If $iPos > 0 Then
			SetDebugLog("AndroidEmbedCheck: Android Window Position changed: X: " & $a1[0] & " <> " & $a2[0] & ", Y: " & $a1[1] & " <> " & $a2[1], Default, True)
		EndIf
		If $iPos = 0 And $bDetachedShield = True Then
			$a1 = WinGetPos($frmBotEmbeddedShield)
			$a2 = $aPosShield
			$iPos = ((IsArray($a1) And ($a1[0] <> $a2[0] Or $a1[1] <> $a2[1])) ? 4 : 0)
			If $iPos > 0 Then
				SetDebugLog("AndroidEmbedCheck: Android Shield Position changed: X: " & $a1[0] & " <> " & $a2[0] & ", Y: " & $a1[1] & " <> " & $a2[1], Default, True)
			EndIf
		EndIf

		Return BitOR($iZorder, $iStyle, $iPos)
	EndIf
	Return 0
EndFunc   ;==>AndroidEmbedCheck

Func AndroidEmbedded()
	Return $AndroidEmbedded
EndFunc   ;==>AndroidEmbedded

Func AndroidEmbedArrangeActive($bActive = Default)
	If $bActive = Default Then Return $g_hProcShieldInput[3]
	Local $bWasActive = $g_hProcShieldInput[3]
	$g_hProcShieldInput[3] = $bActive
	Return $bWasActive
EndFunc   ;==>AndroidEmbedArrangeActive

; Called when bot GUI initialize done
Func AndroidShieldStartup()
	_OnAutoItErrorRegister() ; Register custom crash handler
EndFunc   ;==>AndroidShieldStartup

; Called when bot closes
Func AndroidShieldDestroy()
	_OnAutoItErrorUnRegister() ; UnRegister custom crash handler
EndFunc   ;==>AndroidShieldDestroy

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
	Return $g_hProcShieldInput[2] = True
EndFunc   ;==>AndroidShieldHasFocus

Func AndroidShielded()
	Return $AndroidShieldStatus[0] = True
EndFunc   ;==>AndroidShielded

; AndroidShieldActiveDelay return true if shield delay has been set and for $bIsStillWaiting = True also if still awaiting timeout
Func AndroidShieldActiveDelay($bIsStillWaiting = False)
	Return $AndroidShieldDelay[0] <> 0 And $AndroidShieldDelay[1] > 0 And ($bIsStillWaiting = False Or TimerDiff($AndroidShieldDelay[0]) < $AndroidShieldDelay[1])
EndFunc   ;==>AndroidShieldActiveDelay

Func AndroidShieldCheck()
	If AndroidShieldActiveDelay(True) = True Then Return False
	Return AndroidShield("AndroidShieldCheck")
EndFunc   ;==>AndroidShieldCheck

; Syncronized _AndroidShield
Func AndroidShield($sCaller, $Enable = Default, $CallWinGetAndroidHandle = True, $iDelay = 0, $AndroidHasFocus = Default, $AndroidUpdateFocus = True)
	If $AndroidShieldEnabled = False Or $g_hProcShieldInput[3] = True Then Return False
	If $iDelay > 0 Then
		Return _AndroidShield($sCaller, $Enable, $CallWinGetAndroidHandle, $iDelay, $AndroidHasFocus, $AndroidUpdateFocus)
	EndIf
	Local $hMutex = AcquireMutex("AndroidShield", Default, 1000)
	;If $debugAndroidEmbedded Then SetDebugLog("AndroidShield, acquired mutex: " & $hMutex, Default, True)
	If $hMutex <> 0 Then
		Local $Result = _AndroidShield($sCaller, $Enable, $CallWinGetAndroidHandle, $iDelay, $AndroidHasFocus, $AndroidUpdateFocus)
		ReleaseMutex($hMutex)
		;If $debugAndroidEmbedded Then SetDebugLog("AndroidShield, released mutex: " & $hMutex, Default, True)
		Return $Result
	Else
		SetDebugLog("AndroidShield, failed acquire mutex, caller: " & $sCaller, Default, True)
	EndIf
	Return False
EndFunc   ;==>AndroidShield

Func _AndroidShield($sCaller, $Enable = Default, $CallWinGetAndroidHandle = True, $iDelay = 0, $AndroidHasFocus = Default, $AndroidUpdateFocus = True)

	Local $bForceUpdate = False

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
		SetDebugLog("ShieldAndroid: Delayed update $iDelay=" & $iDelay & ", $Enable=" & $Enable & ", $AndroidHasFocus=" & $AndroidHasFocus & ", caller: " & $sCaller, Default, True)
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
			SetAccelerators(True) ; allow ESC for Android
		Else
			; android without focus
			$shieldState = "disabled-nofocus"
			$color = $AndroidInactiveColor
			$trans = $AndroidInactiveTransparency
			SetAccelerators(False) ; ESC now stopping bot again
		EndIf
	Else
		SetAccelerators(False) ; ESC now stopping bot again
	EndIf

	Local $bNoVisibleShield = $ichkBackground = 0
	Local $bDetachedShield = $bNoVisibleShield = False And ($AndroidShieldPreWin8 = True Or $AndroidEmbedMode = 1)

	If $AndroidEmbedded = False Then
		; nothing to do
		Return False
	EndIf
	If $AndroidBackgroundLaunched = True Then
		; nothing to do
		Return False
	EndIf
	If $bForceUpdate = False And $AndroidShieldStatus[0] = $Enable And $AndroidShieldStatus[1] = $color And $AndroidShieldStatus[2] = $trans And $AndroidShieldStatus[3] = $bNoVisibleShield And $AndroidShieldStatus[4] = $bDetachedShield Then
		; nothing to do
		Return False
	EndIf
	If ($CallWinGetAndroidHandle = False And $HWnD = 0) Or ($CallWinGetAndroidHandle = True And WinGetAndroidHandle() = 0) Then
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

	; check if shield must be recreated
	If $frmBotEmbeddedShield <> 0 And ($AndroidShieldStatus[3] <> $bNoVisibleShield Or $AndroidShieldStatus[4] <> $bDetachedShield) Then
		GUIDelete($frmBotEmbeddedShield)
		$frmBotEmbeddedShield = 0
	EndIf

	$g_hProcShieldInput[3] = True
	Local $show_shield = @SW_SHOWNOACTIVATE
	If $Enable <> $AndroidShieldStatus[0] Or $frmBotEmbeddedShield = 0 Then ;Or $bForceUpdate = True Then
		If $Enable = True Then
			SetDebugLog("Shield Android Control (" & $aPosCtl[2] & "x" & $aPosCtl[3] & ")", Default, True)
			; Remove hooks as not not needed when shielded
			;AndroidShieldHook(False)
		Else
			SetDebugLog("Unshield Android Control", Default, True)
			; Add hooks to forward messages to android
			;AndroidShieldHook(True)
		EndIf

		If $bDetachedShield = False Then
			If $frmBotEmbeddedShield = 0 Then
				$frmBotEmbeddedShield = GUICreate("", $aPosCtl[2], $aPosCtl[3], 0, 0, BitOR($WS_CHILD, $WS_TABSTOP), BitOR($WS_EX_TOPMOST, ($bNoVisibleShield ? $WS_EX_TRANSPARENT : 0)), $frmBot) ; Android Shield for mouse
			Else
				WinMove($frmBotEmbeddedShield, "", 0, 0, $aPosCtl[2], $aPosCtl[3]) ; $HWND_TOPMOST
			EndIf
			WinMove2($hCtrlTarget, "", -1, -1, -1, -1, $HWND_BOTTOM)
		Else
			Local $bHasFocus = WinActive($frmBot) <> 0
			Local $a = AndroidEmbed_HWnD_Position(True, $bDetachedShield)
			If $frmBotEmbeddedShield = 0 Then
				$frmBotEmbeddedShield = GUICreate("", $aPosCtl[2], $aPosCtl[3], $a[0], $a[1], BitOR($WS_POPUP, $WS_TABSTOP), BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE, $WS_EX_TOPMOST, $WS_EX_TRANSPARENT), $frmBot) ; Android Shield for mouse
				_WinAPI_EnableWindow($frmBotEmbeddedShield, False)
				$frmBotEmbeddedMouse = GUICreate("", $aPosCtl[2], $aPosCtl[3], 0, 0, BitOR($WS_CHILD, $WS_TABSTOP), BitOR($WS_EX_TOPMOST, $WS_EX_TRANSPARENT), $frmBot) ; Android Mouse layer
			EndIf
			WinMove2($frmBotEmbeddedShield, "", $a[0], $a[1], $aPosCtl[2], $aPosCtl[3], ($bHasFocus ? $HWND_TOPMOST : $HWND_BOTTOM), 0, False) ; $SWP_SHOWWINDOW
			WinMove2($frmBotEmbeddedMouse, "", 0, 0, $aPosCtl[2], $aPosCtl[3], ($bHasFocus ? $HWND_TOPMOST : $HWND_BOTTOM), 0, False) ; $SWP_SHOWWINDOW
			WinMove2($hCtrlTarget, "", -1, -1, -1, -1, $HWND_BOTTOM)
			SetDebugLog("$frmBotEmbeddedShield Position: " & $a[0] & ", " & $a[1] & ", " & $aPosCtl[2] & ", " & $aPosCtl[3], Default, True)
		EndIf

	EndIf

	If $bNoVisibleShield = False Then
		WinSetTrans($frmBotEmbeddedShield, "", $trans)
		GUISetBkColor($color, $frmBotEmbeddedShield)
	EndIf
	GUISetState($show_shield, $frmBotEmbeddedShield)
	GUISetState($show_shield, $frmBotEmbeddedMouse)

	$g_hProcShieldInput[3] = False

	; update shield current status
	$AndroidShieldStatus[0] = $Enable
	$AndroidShieldStatus[1] = $color
	$AndroidShieldStatus[2] = $trans
	$AndroidShieldStatus[3] = $bNoVisibleShield
	$AndroidShieldStatus[4] = $bDetachedShield

	; Add hooks
	AndroidShieldStartup()

	SetDebugLog("AndroidShield updated to " & $shieldState & "(handle=" & $frmBotEmbeddedShield & ", color=" & Hex($color, 6) & "), caller: " & $sCaller, Default, True)

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

	Local $a[2] = [0, 0]
	If $AndroidEmbedded = True Then
		If $frmBotEmbeddedGarphics = 0 Then
			Local $bDetachedShield = $AndroidShieldStatus[4]
			If $bDetachedShield = False Then
				$frmBotEmbeddedGarphics = GUICreate("", $iW, $iH, 0, 0, $WS_CHILD, BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE, $WS_EX_LAYERED, $WS_EX_TOPMOST), $frmBot)
			Else
				Local $a = AndroidEmbed_HWnD_Position(True, $bDetachedShield)
				$frmBotEmbeddedGarphics = GUICreate("", $iW, $iH, $a[0], $a[1], $WS_POPUP, BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE, $WS_EX_LAYERED, $WS_EX_TOPMOST), $frmBot)
			EndIf
		EndIf
		GUISetState(@SW_SHOWNOACTIVATE, $frmBotEmbeddedGarphics)
	EndIf

	Local $hDC = _WinAPI_GetDC($frmBotEmbeddedGarphics)
	Local $hMDC = AndroidGraphicsGdiAddObject("hMDC", _WinAPI_CreateCompatibleDC($hDC)) ; idx = 0
	Local $hBitmap = AndroidGraphicsGdiAddObject("hBitmap", _WinAPI_CreateCompatibleBitmap($hDC, $iW, $iH)) ; idx = 1
	_WinAPI_SelectObject($hMDC, $hBitmap)
	AndroidGraphicsGdiAddObject("hDC", $hDC) ; idx = 2
	Local $hGraphics = AndroidGraphicsGdiAddObject("Graphics", _GDIPlus_GraphicsCreateFromHDC($hMDC)) ; idx = 3

	_GDIPlus_GraphicsSetSmoothingMode($hGraphics, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
	_GDIPlus_GraphicsClear($hGraphics)

	Local $tSIZE = DllStructCreate($tagSIZE)
	AndroidGraphicsGdiAddObject("DllStruct", $tSIZE) ; idx = 4
	Local $pSize = DllStructGetPtr($tSIZE)
	DllStructSetData($tSIZE, "X", $iW)
	DllStructSetData($tSIZE, "Y", $iH)
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
	DllStructSetData($tPoint, "X", $a[0])
	DllStructSetData($tPoint, "Y", $a[1])
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
	Local $tPoint = DllStructCreate($tagPOINT, $pPoint)

	Local $bDetachedShield = $AndroidShieldStatus[4]
	Local $a = AndroidEmbed_HWnD_Position(True, $bDetachedShield)
	DllStructSetData($tPoint, "X", $a[0])
	DllStructSetData($tPoint, "Y", $a[1])
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
		GUIDelete($frmBotEmbeddedGarphics)
		$frmBotEmbeddedGarphics = 0
	EndIf

	Return $Result
EndFunc   ;==>AndroidGraphicsGdiEnd
