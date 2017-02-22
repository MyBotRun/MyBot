; #FUNCTION# ====================================================================================================================
; Name ..........: AndroidEmbed
; Description ...: This file contains the fucntions to dock Android into Bot window and handle shield.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (2016-07)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_aiAndroidEmbeddedGraphics[0][2] ; Array for GDI objects when drawing on Android Shield

; Return Android window handle containing the Android rendering control
Func GetCurrentAndroidHWnD()
	Local $h = (($g_bAndroidEmbedded = False Or $g_iAndroidEmbedMode = 1) ? $HWnD : $g_hFrmBot)
	Return $h
EndFunc   ;==>GetCurrentAndroidHWnD

; Return the window handle displaying the Android content
Func GetAndroidDisplayHWnD()
	Local $h = (($g_bAndroidEmbedded = False) ? $HWnD : $g_hFrmBot)
	Return $h
EndFunc   ;==>GetAndroidDisplayHWnD

; Syncronized _AndroidEmbed
Func AndroidEmbed($Embed = True, $CallWinGetAndroidHandle = True, $bForceEmbed = False)
	If $g_bAndroidEmbed = False Then Return False
	Local $hMutex = AcquireMutex("AndroidEmbed", Default, 1000)
	If $hMutex <> 0 Then
		Return ReleaseMutex($hMutex, _AndroidEmbed($Embed, $CallWinGetAndroidHandle, $bForceEmbed))
	EndIf
	Return False
EndFunc   ;==>AndroidEmbed

Func _AndroidEmbed($Embed = True, $CallWinGetAndroidHandle = True, $bForceEmbed = False)

	If ($CallWinGetAndroidHandle = False And $HWnD = 0) Or ($CallWinGetAndroidHandle = True And WinGetAndroidHandle() = 0) Then
		SetDebugLog("Android Emulator not launched", $COLOR_ERROR)
		If $g_bAndroidEmbedded = False Then
			; nothing to do
			updateBtnEmbed()
			Return False
		Else
			; detach android
			If $Embed = True Then
				SetDebugLog("Docked Android Window not available, force undock", $COLOR_ERROR)
				$Embed = False
			EndIf
		EndIf
	EndIf
	If $g_bAndroidBackgroundLaunched = True Then
		If $g_bAndroidEmbedded = False Then
			SetDebugLog("Android Emulator launched in background mode", $COLOR_ERROR)
			; nothing to do
			updateBtnEmbed()
			Return False
		Else
			; detach android
			If $Embed = True Then
				SetDebugLog("Android Emulator launched in background mode, force undock", $COLOR_ERROR)
				$Embed = False
			EndIf
		EndIf
	EndIf

	Local $aPos = WinGetPos($HWnD)
	If IsArray($aPos) = 0 Or @error <> 0 Then
		If $g_bAndroidEmbedded = False Then
			SetDebugLog("Android Window not available", $COLOR_ERROR)
			updateBtnEmbed()
			Return False
		Else
			; detach android
			If $Embed = True Then
				SetDebugLog("Android Window not accessible, force undock", $COLOR_ERROR)
				$Embed = False
			EndIf
		EndIf
	EndIf

	Local $hCtrl = ControlGetHandle(GetCurrentAndroidHWnD(), $g_sAppPaneName, $g_sAppClassInstance)
	Local $aPosFrmBotEx, $aPosLog
	Local $hCtrlTarget = $g_aiAndroidEmbeddedCtrlTarget[0]
	Local $hCtrlTargetParent = $g_aiAndroidEmbeddedCtrlTarget[1]
	Local $HWnDParent = $g_aiAndroidEmbeddedCtrlTarget[2]
	Local $HWnD2 = $g_aiAndroidEmbeddedCtrlTarget[3]
	Local $lCurStyle = $g_aiAndroidEmbeddedCtrlTarget[4]
	Local $lCurExStyle = $g_aiAndroidEmbeddedCtrlTarget[5]
	Local $aPosCtl = $g_aiAndroidEmbeddedCtrlTarget[6]
	Local $lCurStyleTarget = $g_aiAndroidEmbeddedCtrlTarget[8]
	Local $hThumbnail = $g_aiAndroidEmbeddedCtrlTarget[9]
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
	Local $HWnD_available = WinGetHandle($HWnD) = $HWnD

	If $Embed = False Then
		; remove embedded Android
		If $g_bAndroidEmbedded = True Then

			SetDebugLog("Undocking Android Control...")

			If _WinAPI_IsIconic($g_hFrmBot) Then BotMinimize("_AndroidEmbed (1)", True)

			If $g_bAndroidShieldEnabled = True Then
				AndroidShield("AndroidEmbed undock", False, $CallWinGetAndroidHandle, 100)
				;_WinAPI_ShowWindow($g_hFrmBotEmbeddedShield, @SW_HIDE)
				;GUISetState(@SW_HIDE, $g_hFrmBotEmbeddedShield)
				GUIDelete($g_hFrmBotEmbeddedShield)
				$g_hFrmBotEmbeddedShield = 0
				If $g_hFrmBotEmbeddedMouse Then
					GUIDelete($g_hFrmBotEmbeddedMouse)
					$g_hFrmBotEmbeddedMouse = 0
				EndIf
				$g_avAndroidShieldStatus[0] = Default
			EndIf

			SetRedrawBotWindow(False, Default, Default, Default, "_AndroidEmbed")

			If $hThumbnail <> 0 Then
				_WinAPI_DwmUnregisterThumbnail($hThumbnail)
				$g_aiAndroidEmbeddedCtrlTarget[9] = 0
			EndIf

			$aPos = $g_aiAndroidEmbeddedCtrlTarget[7]

			$g_hProcShieldInput[3] = True

			If $HWnD_available Then
				Switch $g_iAndroidEmbedMode
					Case 0
						If $targetIsHWnD = False Then
							;ControlMove($hCtrlTarget, "", "", $aPosCtl[0], $aPosCtl[1], $aPosCtl[2], $aPosCtl[3])
							_WinAPI_SetParent($hCtrlTarget, $hCtrlTargetParent)
							_WinAPI_SetWindowLong($hCtrlTarget, $GWL_HWNDPARENT, $hCtrlTargetParent)
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
			EndIf

			; move Android rendering control back to its place
			WinMove(($targetIsHWnD ? $hCtrl : $hCtrlTarget), "", $aPosCtl[0], $aPosCtl[1], $aPosCtl[2], $aPosCtl[3])
			WinMove2(($targetIsHWnD ? $hCtrl : $hCtrlTarget), "", $aPosCtl[0], $aPosCtl[1], $aPosCtl[2], $aPosCtl[3], 0, 0, False)
			If $g_iDebugAndroidEmbedded Then SetDebugLog("Placed Android Control at " & $aPosCtl[0] & "," & $aPosCtl[1])

			ControlHide($g_hGUI_LOG, "", $g_hDivider)
			$aPosFrmBotEx = ControlGetPos($g_hFrmBot, "", $g_hFrmBotEx)
			If UBound($aPosFrmBotEx) < 4 Then
				SetLog("Bot Window not available", $COLOR_ERROR)
				$g_hProcShieldInput[3] = False
				Return False
			EndIf
			ControlMove($g_hFrmBot, "", $g_hFrmBotEx, 0, 0, $aPosFrmBotEx[2], $aPosFrmBotEx[3] - $frmBotAddH)
			ControlMove($g_hFrmBot, "", $g_hFrmBotBottom, 0, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP)
			WinSetTrans($g_hFrmBotBottom, "", 255)
			; restore main tab size (not required ;)
			; restore log size
			$aPosLog = ControlGetPos($g_hFrmBotEx, "", $g_hGUI_LOG)
			ControlMove($g_hFrmBotEx, "", $g_hGUI_LOG, Default, Default, $aPosLog[2], $aPosLog[3] - $frmBotAddH)
			$g_bAndroidEmbedded = False
			WinMove2($g_hFrmBot, "", $frmBotPosX, $frmBotPosY, $g_aFrmBotPosInit[2], $g_aFrmBotPosInit[3], 0, 0, False)
			updateBtnEmbed()

			$g_iLogDividerY -= $frmBotAddH
			$frmBotAddH = 0
			cmbLog()

			SetRedrawBotWindow(True, Default, Default, Default, "_AndroidEmbed")
			If $HWnD_available Then
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
				Execute("Embed" & $g_sAndroidEmulator & "(False)")
				If $g_iAndroidEmbedMode = 1 Then
					; bring android back to front
					WinMove2($HWnD, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3], $HWND_TOPMOST)
					WinMove2($HWnD, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3], $HWND_NOTOPMOST, 0, False)
				EndIf
				getAndroidPos() ; ensure window size is ok
				getBSPos() ; update android screen coord. for clicks etc
			EndIf

			SetDebugLog("Undocked Android Window")

			$g_hProcShieldInput[3] = False

			Return True
		EndIf
		updateBtnEmbed()
		Return False
	EndIf

	If $g_bAndroidEmbedded = True And $bForceEmbed = False Then
		If $HWnD = $HWnD2 Then
			;SetDebugLog("Android Window already embedded", Default, True)
			If $targetIsHWnD = False Then
				; Ensure android is still hidden
				WinMove2($HWnD, "", $aPosCtl[2] + 2, $g_aFrmBotPosInit[5], -1, -1, $HWND_BOTTOM)
			EndIf

			Return False
		EndIf
		SetDebugLog("Docked Android Window gone", $COLOR_ERROR)
		Return _AndroidEmbed(False)
	EndIf

	Local $bAlreadyEmbedded = $g_bAndroidEmbedded = True

	; Embed Android Window
	SetDebugLog("Docking Android Control...")

	If _WinAPI_DwmEnableComposition(True) = 1 Then
		SetDebugLog("Desktop Window Manager available", $COLOR_SUCCESS)
	Else
		SetDebugLog("Desktop Window Manager not available!", $COLOR_ERROR)
		SetDebugLog("Android Shield will be invisible!", $COLOR_ERROR)
	EndIf

	If _WinAPI_IsIconic($g_hFrmBot) Then BotMinimize("_AndroidEmbed (2)", True)
	If _WinAPI_IsIconic($HWnD) Then WinSetState($HWnD, "", @SW_RESTORE)
	getAndroidPos() ; ensure window size is ok
	$aPos = WinGetPos($HWnD) ; Android Window size might has changed
	If IsArray($aPos) = 0 Then
		;SetDebugLog("Android Window not available", $COLOR_ERROR)
		updateBtnEmbed()
		Return False
	EndIf
	If $g_iDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPos[] = " & $aPos[0] & ", " & $aPos[1] & ", " & $aPos[2] & ", " & $aPos[3], Default, True)
	$lCurStyle = _WinAPI_GetWindowLong($HWnD, $GWL_STYLE)
	$lCurExStyle = _WinAPI_GetWindowLong($HWnD, $GWL_EXSTYLE)

	$HWnDParent = _WinAPI_GetParent($HWnD)
	;_WinAPI_SetWindowLong($hCtrl, $GWL_STYLE, BitAND(_WinAPI_GetWindowLong($hCtrl, $GWL_STYLE), BitNOT($WS_EX_NOPARENTNOTIFY)))
	$hCtrlTarget = _WinAPI_GetParent($hCtrl)
	If $hCtrlTarget = 0 Then
		;SetDebugLog("Android Control not available", $COLOR_ERROR)
		updateBtnEmbed()
		Return False
	EndIf
	$lCurStyleTarget = _WinAPI_GetWindowLong($hCtrlTarget, $GWL_STYLE)
	$hCtrlTargetParent = _WinAPI_GetParent($hCtrlTarget)
	If $g_iDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $hCtrl=" & $hCtrl & ", $hCtrlTarget=" & $hCtrlTarget & ", $hCtrlTargetParent=" & $hCtrlTargetParent & ", $HWnD=" & $HWnD, Default, True)

	$targetIsHWnD = $hCtrlTarget = $HWnD
	Local $adjustPosCtrl = False
	If $bAlreadyEmbedded = True Then

		$g_hProcShieldInput[3] = True

	Else

		$aPosCtl = ControlGetPos($HWnD, "", ($targetIsHWnD ? $hCtrl : $hCtrlTarget))
		If IsArray($aPosCtl) = 0 Or @error <> 0 Then
			;SetDebugLog("Android Control not available", $COLOR_ERROR)
			updateBtnEmbed()
			Return False
		EndIf
		If $g_iDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosCtl[] = " & $aPosCtl[0] & ", " & $aPosCtl[1] & ", " & $aPosCtl[2] & ", " & $aPosCtl[3], Default, True)

		If $targetIsHWnD Then
			Local $aPosParentCtl = $aPosCtl
			$hCtrlTargetParent = $hCtrlTarget
		ElseIf $hCtrlTargetParent = $HWnD Then
			Local $aPosParentCtl = $aPosCtl
		Else
			$adjustPosCtrl = True
			Local $aPosParentCtl = ControlGetPos($HWnD, "", $hCtrlTargetParent)
			If $hCtrlTargetParent = 0 Or IsArray($aPosParentCtl) = 0 Or @error <> 0 Then
				SetDebugLog("Android Parent Control not available", $COLOR_ERROR)
				updateBtnEmbed()
				Return False
			EndIf
		EndIf
		If $g_iDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosParentCtl[] = " & $aPosParentCtl[0] & ", " & $aPosParentCtl[1] & ", " & $aPosParentCtl[2] & ", " & $aPosParentCtl[3], Default, True)

		Local $botClientWidth = $g_aFrmBotPosInit[4]
		Local $botClientHeight = $g_aFrmBotPosInit[5]
		$frmBotAddH = $aPosCtl[3] - $botClientHeight
		If $g_iDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $frmBotAddH = " & $frmBotAddH, Default, True)
		If $frmBotAddH < 0 Then $frmBotAddH = 0

		Local $g_hFrmBotWidth = $g_aFrmBotPosInit[2] + $aPosCtl[2] + 2
		Local $g_hFrmBotHeight = $g_aFrmBotPosInit[3] + $frmBotAddH

		$g_hProcShieldInput[3] = True
		$g_bAndroidEmbedded = True

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

		WinMove2($g_hFrmBot, "", $frmBotDockedPosX, $frmBotDockedPosY, -1, -1, 0, 0, False)

		$aPosFrmBotEx = ControlGetPos($g_hFrmBot, "", $g_hFrmBotEx)
		$aPosFrmBotEx[3] = $g_aFrmBotPosInit[6]
		If $g_iDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosFrmBotEx[] = " & $aPosFrmBotEx[0] & ", " & $aPosFrmBotEx[1] & ", " & $aPosFrmBotEx[2] & ", " & $aPosFrmBotEx[3], Default, True)
		WinMove($g_hFrmBotEx, "", $aPosCtl[2] + 2, 0, $aPosFrmBotEx[2], $aPosFrmBotEx[3] + $frmBotAddH)
		WinMove($g_hFrmBotBottom, "", $aPosCtl[2] + 2, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP + $frmBotAddH)
		;WinSetTrans($g_hFrmBotBottom, "", 254)
		;Local $BS1_style = BitOR($WS_OVERLAPPED, $WS_MINIMIZEBOX, $WS_GROUP, $WS_SYSMENU, $WS_DLGFRAME, $WS_BORDER, $WS_CAPTION, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS, $WS_VISIBLE)
		If $g_iAndroidEmbedMode = 0 Then
			WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2], $aPosCtl[3], $HWND_BOTTOM)
		EndIf
		_SendMessage($g_hFrmBot, $WM_SETREDRAW, False, 0) ; disable bot window redraw
		; increase main tab size
		Local $a = ControlGetRelativePos($g_hFrmBotEx, "", $g_hTabMain)
		If UBound($a) > 3 Then
			Local $ctrlResult = WinMove(GUICtrlGetHandle($g_hTabMain), "", $a[0], $a[1], $a[2], $a[3] + $frmBotAddH)
			If $g_iDebugAndroidEmbedded Then SetDebugLog("Move $g_hTabMain Pos: " & $a[0] & ", " & $a[1] & ", " & $a[2] & ", " & $a[3] + $frmBotAddH & ": " & $ctrlResult)
		EndIf
		; increase log size
		$aPosLog = ControlGetPos($g_hFrmBotEx, "", $g_hGUI_LOG)
		If $g_iDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosLog[] = " & $aPosLog[0] & ", " & $aPosLog[1] & ", " & $aPosLog[2] & ", " & $aPosLog[3], Default, True)
		WinMove($g_hGUI_LOG, "", $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, $aPosLog[2], $aPosLog[3] + $frmBotAddH)

		WinMove2($g_hFrmBot, "", $frmBotDockedPosX, $frmBotDockedPosY, $g_hFrmBotWidth, $g_hFrmBotHeight, 0, 0, False)

		$g_aiAndroidEmbeddedCtrlTarget[0] = $hCtrlTarget
		$g_aiAndroidEmbeddedCtrlTarget[1] = $hCtrlTargetParent
		$g_aiAndroidEmbeddedCtrlTarget[2] = $HWnDParent
		$g_aiAndroidEmbeddedCtrlTarget[3] = $HWnD
		$g_aiAndroidEmbeddedCtrlTarget[4] = $lCurStyle
		$g_aiAndroidEmbeddedCtrlTarget[5] = $lCurExStyle
		; convert to relative position
		If $adjustPosCtrl = True Then
			$aPosCtl[0] = $aPosParentCtl[0] - $aPosCtl[0]
			$aPosCtl[1] = $aPosParentCtl[1] - $aPosCtl[1]
		EndIf
		$g_aiAndroidEmbeddedCtrlTarget[6] = $aPosCtl
		$g_aiAndroidEmbeddedCtrlTarget[7] = $aPos
		$g_aiAndroidEmbeddedCtrlTarget[8] = $lCurStyleTarget
	EndIf

	Local $newStyle = AndroidEmbed_GWL_STYLE()
	SetDebugLog("AndroidEmbed_GWL_STYLE=" & Get_GWL_STYLE_Text($newStyle))
	Local $a = AndroidEmbed_HWnD_Position()
	Switch $g_iAndroidEmbedMode
		Case 0
			_WinAPI_SetWindowLong($HWnD, $GWL_EXSTYLE, $WS_EX_MDICHILD)
			_WinAPI_SetWindowLong($HWnD, $GWL_HWNDPARENT, $g_hFrmBot) ; required for BS to solve strange focus switch between bot and BS
			_WinAPI_SetWindowLong($HWnD, $GWL_STYLE, $newStyle)
			_WinAPI_SetParent($HWnD, $g_hFrmBot)
			If $targetIsHWnD = False Then
				_WinAPI_SetWindowLong($hCtrlTarget, $GWL_HWNDPARENT, $g_hFrmBot)
				_WinAPI_SetParent($hCtrlTarget, $g_hFrmBot)
			EndIf
			_WinAPI_SetWindowLong($HWnD, $GWL_STYLE, $newStyle)
			;ControlFocus($g_hFrmBot, "", $g_hFrmBot) ; required for BlueStacks
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
            If $targetIsHWnD = False Then
                WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2], $aPosCtl[3], 0, 0, False)
            EndIf
			; register thumbnail
			If _WinAPI_DwmIsCompositionEnabled() And $hThumbnail = 0 Then
				$hThumbnail = _WinAPI_DwmRegisterThumbnail($g_hFrmBot, $HWnD)
				Local $tSIZE = _WinAPI_DwmQueryThumbnailSourceSize($hThumbnail)
				Local $iWidth = DllStructGetData($tSIZE, 1)
				Local $iHeight = DllStructGetData($tSIZE, 2)
				Local $tDestRect = _WinAPI_CreateRectEx(0, 0, $iWidth, $iHeight)
				Local $tSrcRect = _WinAPI_CreateRectEx(0, 0, $iWidth, $iHeight)
				_WinAPI_DwmUpdateThumbnailProperties($hThumbnail, 1, 0, 255, $tDestRect, $tSrcRect)
				$g_aiAndroidEmbeddedCtrlTarget[9] = $hThumbnail
			EndIf
			WinMove2($HWnD, "", $a[0], $a[1], $aPosCtl[2], $aPosCtl[3], $HWND_BOTTOM, $SWP_SHOWWINDOW, False)
	EndSwitch

	Execute("Embed" & $g_sAndroidEmulator & "(True)")
	updateBtnEmbed()

	$g_iLogDividerY += $frmBotAddH
	cmbLog()

	_WinAPI_EnableWindow($hCtrlTarget, False)
	_WinAPI_EnableWindow($HWnD, False)

	Local $aCheck = WinGetPos($HWnD)
	If IsArray($aCheck) Then
		If $g_iDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: Android Window Pos: " & $aCheck[0] & ", " & $aCheck[1] & ", " & $aCheck[2] & ", " & $aCheck[3], Default, True)
	Else
		SetDebugLog("AndroidEmbed: Android Window not found", $COLOR_ERROR)
	EndIf
	Local $aCheck = ControlGetPos(GetCurrentAndroidHWnD(), $g_sAppPaneName, $g_sAppClassInstance)
	If IsArray($aCheck) Then
		If $g_iDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: Android Control Pos: " & $aCheck[0] & ", " & $aCheck[1] & ", " & $aCheck[2] & ", " & $aCheck[3], Default, True)
	Else
		SetDebugLog("AndroidEmbed: Android Control not found", $COLOR_ERROR)
	EndIf

	getBSPos() ; update android screen coord. for clicks etc

	_SendMessage($g_hFrmBot, $WM_SETREDRAW, True, 0)
	;RedrawBotWindowNow()
	_WinAPI_RedrawWindow($g_hFrmBot, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN + $RDW_ERASE)
	_WinAPI_RedrawWindow($g_hFrmBotBottom, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN + $RDW_ERASE)
	_WinAPI_UpdateWindow($g_hFrmBot)
	_WinAPI_UpdateWindow($g_hFrmBotBottom)
	;update Android Window
	If $g_iAndroidEmbedMode = 0 Then
		WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2], $aPosCtl[3] - 1, $HWND_BOTTOM, 0, False) ; trigger window change (required for iTools and probably others)
		WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2], $aPosCtl[3], $HWND_BOTTOM, 0, False)
	EndIf

	;CheckRedrawControls(True)

	;If $g_hFrmBotMinimized = False And $activeHWnD = $g_hFrmBot Then WinActivate($activeHWnD) ; re-activate bot

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
	If $g_bAndroidEmbedded = True Then
		Local $lCurStyle = $g_aiAndroidEmbeddedCtrlTarget[4]
		Local $newStyle = BitOR($WS_CHILD, BitAND($lCurStyle, BitNOT(BitOR($WS_POPUP, $WS_CAPTION, $WS_SYSMENU, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_BORDER, $WS_THICKFRAME))))
		;Local $newStyle = BitOR($WS_VISIBLE, $WS_CHILD, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS)
		If $g_iAndroidEmbedMode = 1 Then
			$newStyle = BitOR($WS_POPUP, BitAND($newStyle, BitNOT($WS_CHILD)))
		EndIf
		Return $newStyle
	EndIf
	Return ""
EndFunc   ;==>AndroidEmbed_GWL_STYLE

Func AndroidEmbed_HWnD_Position($bForShield = False, $bDetachedShield = Default, $hCtrlTarget = Default, $aPosCtl = Default)
	Local $aPos[2]

	If $bDetachedShield = Default Then
		$bDetachedShield = $g_avAndroidShieldStatus[4]
	EndIf
	If $g_iAndroidEmbedMode = 1 Or ($bForShield = True And $bDetachedShield = True) Then
		Local $tPoint = DllStructCreate("int X;int Y")
		DllStructSetData($tPoint, "X", 0)
		DllStructSetData($tPoint, "Y", 0)
		_WinAPI_ClientToScreen($g_hFrmBot, $tPoint)
		$aPos[0] = DllStructGetData($tPoint, "X")
		$aPos[1] = DllStructGetData($tPoint, "Y")
		$tPoint = 0
	ElseIf $g_iAndroidEmbedMode = 0 And $bForShield = False Then
		If $hCtrlTarget = Default Then
			$hCtrlTarget = $g_aiAndroidEmbeddedCtrlTarget[0]
		EndIf
		If $aPosCtl = Default Then
			$aPosCtl = $g_aiAndroidEmbeddedCtrlTarget[6]
		EndIf
		Local $targetIsHWnD = $hCtrlTarget = $HWnD
		If $targetIsHWnD = False Then
			$aPos[0] = $aPosCtl[2] + 2
			$aPos[1] = $g_aFrmBotPosInit[5]
		Else
			$aPos[0] = 0
			$aPos[1] = 0
		EndIf
	ElseIf $bForShield = True And ($bDetachedShield = False Or $bDetachedShield = Default) Then
		$aPos[0] = 0
		$aPos[1] = 0
	Else
		SetDebugLog("AndroidEmbed_HWnD_Position: Wrong window state:" & @CRLF & _
				"$bForShield=" & $bForShield & @CRLF & _
				"$g_iAndroidEmbedMode=" & $g_iAndroidEmbedMode & @CRLF & _
				"$bDetachedShield=" & $bDetachedShield)
	EndIf

	Return $aPos
EndFunc   ;==>AndroidEmbed_HWnD_Position

; Ensure embedded window stays hidden
Func AndroidEmbedCheck($bTestIfRequired = Default, $bHasFocus = Default, $iAction = 6)

	If $bHasFocus = Default Then $bHasFocus = WinActive($g_hFrmBot) <> 0

	If $bTestIfRequired = Default Then
		$iAction = AndroidEmbedCheck(True, $bHasFocus)
		If $iAction > 0 Then
			Return AndroidEmbedCheck(False, $bHasFocus, $iAction)
		EndIf
	EndIf
	If $g_bAndroidEmbedded = True And AndroidEmbedArrangeActive() = False Then
		Local $hCtrlTarget = $g_aiAndroidEmbeddedCtrlTarget[0]
		Local $aPosCtl = $g_aiAndroidEmbeddedCtrlTarget[6]
		Local $targetIsHWnD = $hCtrlTarget = $HWnD
		Local $aPos = AndroidEmbed_HWnD_Position()
		Local $aPosShield = AndroidEmbed_HWnD_Position(True)
		Local $newStyle = AndroidEmbed_GWL_STYLE()
		Local $bDetachedShield = $g_avAndroidShieldStatus[4]
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
			If $g_bAndroidShieldEnabled = True And $bDetachedShield = True Then
				If BitAND($iAction, 1) > 0 Or BitAND($iAction, 4) > 0 Then
					If BitAND($iAction, 4) > 0 Then
						WinMove2($g_hFrmBotEmbeddedShield, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], ($bHasFocus ? $HWND_TOPMOST : $HWND_NOTOPMOST), 0, False)
						;If $bHasFocus Then WinMove2($g_hFrmBotEmbeddedShield, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], $HWND_NOTOPMOST, 0, False)
						If $g_hFrmBotEmbeddedGraphics Then
							WinMove2($g_hFrmBotEmbeddedGraphics, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], ($bHasFocus ? $HWND_TOPMOST : $HWND_NOTOPMOST), 0, False)
							;If $bHasFocus Then WinMove2($g_hFrmBotEmbeddedGraphics, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], $HWND_NOTOPMOST, False)
						EndIf
					EndIf
					If $bHasFocus = False Then ; Always update z-order, so no "And BitAND($iAction, 1) > 0"
						; update z-order
						;If $g_hFrmBotEmbeddedGraphics Then WinMove2($g_hFrmBotEmbeddedGraphics, "", -1, -1, -1, -1, $g_hFrmBotEmbeddedShield, 0, False)
						WinMove2($g_hFrmBotEmbeddedShield, "", -1, -1, -1, -1, $g_hFrmBot, 0, False)
						WinMove2($g_hFrmBot, "", -1, -1, -1, -1, $g_hFrmBotEmbeddedShield, 0, False)
					EndIf
				EndIf
			EndIf
			Return True
		EndIf

		; test if update is required
		Local $iZorder = 0
		If $g_bAndroidShieldEnabled = True And $bDetachedShield = True And $bHasFocus = False Then
			; check z-order
			If $g_bAndroidShieldEnabled = True Then
				Local $h = _WinAPI_GetWindow($g_hFrmBotEmbeddedShield, $GW_HWNDNEXT)
				If $h <> $g_hFrmBot Then $iZorder = 1
			EndIf
		EndIf

		Local $style = _WinAPI_GetWindowLong($HWnD, $GWL_STYLE)
		If BitAND($style, $WS_DISABLED) > 0 Then $newStyle = BitOR($newStyle, $WS_DISABLED)
		If BitAND($style, $WS_MAXIMIZEBOX) > 0 Then $newStyle = BitOR($newStyle, $WS_MAXIMIZEBOX) ; dirty fix for LeapDroid 1.7.0: It always adds $WS_MAXIMIZEBOX again

		Local $iStyle = (($style <> $newStyle) ? 2 : 0)
		If $iStyle > 0 Then
			SetDebugLog("AndroidEmbedCheck: Android Window GWL_STYLE changed: " & Get_GWL_STYLE_Text($newStyle) & " to " & Get_GWL_STYLE_Text($style), Default, True)
		EndIf
		Local $a1[2] = [$aPos[0], $aPos[1]]
		Local $a2 = $aPos
		Switch $g_iAndroidEmbedMode
			Case 0
				Local $a1 = ControlGetPos($g_hFrmBot, "", $HWnD)
			Case 1
				Local $a1 = WinGetPos($HWnD)
		EndSwitch
		Local $iPos = ((IsArray($a1) And ($a1[0] <> $a2[0] Or $a1[1] <> $a2[1])) ? 4 : 0)
		If $iPos > 0 Then
			SetDebugLog("AndroidEmbedCheck: Android Window Position changed: X: " & $a1[0] & " <> " & $a2[0] & ", Y: " & $a1[1] & " <> " & $a2[1], Default, True)
		EndIf
		If $iPos = 0 And $bDetachedShield = True Then
			$a1 = WinGetPos($g_hFrmBotEmbeddedShield)
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
	Return $g_bAndroidEmbedded
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
	Local $wasDown = $g_bAndroidShieldForceDown
	$g_bAndroidShieldForceDown = $bForceDown
	AndroidShield("AndroidShieldForceDown", Default, True, 0, $AndroidHasFocus)
	Return $wasDown
EndFunc   ;==>AndroidShieldForceDown

Func AndroidShieldForcedDown()
	Return $g_bAndroidShieldForceDown
EndFunc   ;==>AndroidShieldForcedDown

Func AndroidShieldHasFocus()
	Return $g_hProcShieldInput[2] = True
EndFunc   ;==>AndroidShieldHasFocus

Func AndroidShielded()
	Return $g_avAndroidShieldStatus[0] = True
EndFunc   ;==>AndroidShielded

; AndroidShieldActiveDelay return true if shield delay has been set and for $bIsStillWaiting = True also if still awaiting timeout
Func AndroidShieldActiveDelay($bIsStillWaiting = False)
	Return $g_avAndroidShieldDelay[0] <> 0 And $g_avAndroidShieldDelay[1] > 0 And ($bIsStillWaiting = False Or TimerDiff($g_avAndroidShieldDelay[0]) < $g_avAndroidShieldDelay[1])
EndFunc   ;==>AndroidShieldActiveDelay

Func AndroidShieldCheck()
	If AndroidShieldActiveDelay(True) = True Then Return False
	Return AndroidShield("AndroidShieldCheck")
EndFunc   ;==>AndroidShieldCheck

Func AndroidShieldLock($Lock = Default)
	If $Lock = Default Then Return $g_hProcShieldInput[3]
	Local $wasLock = $g_hProcShieldInput[3]
	$g_hProcShieldInput[3] = $Lock
	Return $wasLock
EndFunc   ;==>AndroidShieldLock

; Syncronized _AndroidShield
Func AndroidShield($sCaller, $Enable = Default, $CallWinGetAndroidHandle = True, $iDelay = 0, $AndroidHasFocus = Default, $AndroidUpdateFocus = True)
	If $g_bAndroidShieldEnabled = False Or $g_hProcShieldInput[3] = True Then Return False
	If $iDelay > 0 Then
		Return _AndroidShield($sCaller, $Enable, $CallWinGetAndroidHandle, $iDelay, $AndroidHasFocus, $AndroidUpdateFocus)
	EndIf
	Local $hMutex = AcquireMutex("AndroidShield", Default, 1000)
	;If $g_iDebugAndroidEmbedded Then SetDebugLog("AndroidShield, acquired mutex: " & $hMutex, Default, True)
	If $hMutex <> 0 Then
		Local $Result = _AndroidShield($sCaller, $Enable, $CallWinGetAndroidHandle, $iDelay, $AndroidHasFocus, $AndroidUpdateFocus)
		ReleaseMutex($hMutex)
		;If $g_iDebugAndroidEmbedded Then SetDebugLog("AndroidShield, released mutex: " & $hMutex, Default, True)
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
			If $Enable = Default Then $Enable = $g_avAndroidShieldDelay[2]
			If $AndroidHasFocus = Default Then $AndroidHasFocus = $g_avAndroidShieldDelay[3]
		Else
			If $iDelay = 0 Then
				If $Enable <> Default Then $g_avAndroidShieldDelay[2] = $Enable
				If $AndroidHasFocus <> Default Then $g_avAndroidShieldDelay[3] = $AndroidHasFocus
				Return False
			EndIf
		EndIf
	EndIf

	If $iDelay > 0 Then
		$g_avAndroidShieldDelay[0] = TimerInit()
		$g_avAndroidShieldDelay[1] = $iDelay
		$g_avAndroidShieldDelay[2] = $Enable
		$g_avAndroidShieldDelay[3] = $AndroidHasFocus
		SetDebugLog("ShieldAndroid: Delayed update $iDelay=" & $iDelay & ", $Enable=" & $Enable & ", $AndroidHasFocus=" & $AndroidHasFocus & ", caller: " & $sCaller, Default, True)
		Return False
	EndIf

	$g_avAndroidShieldDelay[0] = 0
	$g_avAndroidShieldDelay[1] = 0
	$g_avAndroidShieldDelay[2] = Default
	$g_avAndroidShieldDelay[3] = Default

	If $Enable = Default Then
		; determin shield status
		$Enable = $g_bRunState And $g_bBotPaused = False
		If $g_bAndroidShieldForceDown Then $Enable = False
	EndIf

	If $AndroidHasFocus = Default Then
		$AndroidHasFocus = AndroidShieldHasFocus() ;_WinAPI_GetFocus() = GUICtrlGetHandle($g_hFrmBotEmbeddedShieldInput)
	Else
		If $AndroidUpdateFocus Then $g_hProcShieldInput[2] = $AndroidHasFocus
	EndIf

	Local $shieldState = "active"
	Local $color = $g_iAndroidShieldColor
	Local $trans = $g_iAndroidShieldTransparency

	If $Enable = False Or $g_bBotPaused = True Then
		If _WinAPI_GetActiveWindow() = $g_hFrmBot And $AndroidHasFocus Then
			; android has focus
			$shieldState = "disabled-focus"
			$color = $g_iAndroidActiveColor
			$trans = $g_iAndroidActiveTransparency
			SetAccelerators(True) ; allow ESC for Android
		Else
			; android without focus
			$shieldState = "disabled-nofocus"
			$color = $g_iAndroidInactiveColor
			$trans = $g_iAndroidInactiveTransparency
			SetAccelerators(False) ; ESC now stopping bot again
		EndIf
	Else
		SetAccelerators(False) ; ESC now stopping bot again
	EndIf

	Local $bNoVisibleShield = $g_bChkBackgroundMode = False
	Local $bDetachedShield = $bNoVisibleShield = False And ($g_bAndroidShieldPreWin8 = True Or $g_iAndroidEmbedMode = 1)

	If $g_bAndroidEmbedded = False Then
		; nothing to do
		Return False
	EndIf
	If $g_bAndroidBackgroundLaunched = True Then
		; nothing to do
		Return False
	EndIf
	If $bForceUpdate = False And $g_avAndroidShieldStatus[0] = $Enable And $g_avAndroidShieldStatus[1] = $color And $g_avAndroidShieldStatus[2] = $trans And $g_avAndroidShieldStatus[3] = $bNoVisibleShield And $g_avAndroidShieldStatus[4] = $bDetachedShield Then
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

	Local $hCtrlTarget = $g_aiAndroidEmbeddedCtrlTarget[0]
	Local $aPosCtl = $g_aiAndroidEmbeddedCtrlTarget[6]
	Local $targetIsHWnD = $hCtrlTarget = $HWnD

	; check if shield must be recreated
	If $g_hFrmBotEmbeddedShield <> 0 And ($g_avAndroidShieldStatus[3] <> $bNoVisibleShield Or $g_avAndroidShieldStatus[4] <> $bDetachedShield) Then
		GUIDelete($g_hFrmBotEmbeddedShield)
		$g_hFrmBotEmbeddedShield = 0
	EndIf

	$g_hProcShieldInput[3] = True
	Local $show_shield = @SW_SHOWNOACTIVATE
	If $Enable <> $g_avAndroidShieldStatus[0] Or $g_hFrmBotEmbeddedShield = 0 Then ;Or $bForceUpdate = True Then
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
			If $g_hFrmBotEmbeddedShield = 0 Then
				$g_hFrmBotEmbeddedShield = GUICreate("", $aPosCtl[2], $aPosCtl[3], 0, 0, BitOR($WS_CHILD, $WS_TABSTOP), BitOR($WS_EX_TOPMOST, ($bNoVisibleShield ? $WS_EX_TRANSPARENT : 0)), $g_hFrmBot) ; Android Shield for mouse
			Else
				WinMove($g_hFrmBotEmbeddedShield, "", 0, 0, $aPosCtl[2], $aPosCtl[3]) ; $HWND_TOPMOST
			EndIf
			WinMove2($hCtrlTarget, "", -1, -1, -1, -1, $HWND_BOTTOM)
		Else
			Local $bHasFocus = WinActive($g_hFrmBot) <> 0
			Local $a = AndroidEmbed_HWnD_Position(True, $bDetachedShield)
			If $g_hFrmBotEmbeddedShield = 0 Then
				$g_hFrmBotEmbeddedShield = GUICreate("", $aPosCtl[2], $aPosCtl[3], $a[0], $a[1], BitOR($WS_POPUP, $WS_TABSTOP), BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE, $WS_EX_TOPMOST, $WS_EX_TRANSPARENT), $g_hFrmBot) ; Android Shield for mouse
				_WinAPI_EnableWindow($g_hFrmBotEmbeddedShield, False)
				$g_hFrmBotEmbeddedMouse = GUICreate("", $aPosCtl[2], $aPosCtl[3], 0, 0, BitOR($WS_CHILD, $WS_TABSTOP), BitOR($WS_EX_TOPMOST, $WS_EX_TRANSPARENT), $g_hFrmBot) ; Android Mouse layer
			EndIf
			WinMove2($g_hFrmBotEmbeddedShield, "", $a[0], $a[1], $aPosCtl[2], $aPosCtl[3], ($bHasFocus ? $HWND_TOPMOST : $HWND_BOTTOM), 0, False) ; $SWP_SHOWWINDOW
			WinMove2($g_hFrmBotEmbeddedMouse, "", 0, 0, $aPosCtl[2], $aPosCtl[3], ($bHasFocus ? $HWND_TOPMOST : $HWND_BOTTOM), 0, False) ; $SWP_SHOWWINDOW
			WinMove2($hCtrlTarget, "", -1, -1, -1, -1, $HWND_BOTTOM)
			SetDebugLog("$g_hFrmBotEmbeddedShield Position: " & $a[0] & ", " & $a[1] & ", " & $aPosCtl[2] & ", " & $aPosCtl[3], Default, True)
		EndIf

	EndIf

	If $bNoVisibleShield = False Then
		WinSetTrans($g_hFrmBotEmbeddedShield, "", $trans)
		GUISetBkColor($color, $g_hFrmBotEmbeddedShield)
	EndIf
	GUISetState($show_shield, $g_hFrmBotEmbeddedShield)
	GUISetState($show_shield, $g_hFrmBotEmbeddedMouse)

	$g_hProcShieldInput[3] = False

	; update shield current status
	$g_avAndroidShieldStatus[0] = $Enable
	$g_avAndroidShieldStatus[1] = $color
	$g_avAndroidShieldStatus[2] = $trans
	$g_avAndroidShieldStatus[3] = $bNoVisibleShield
	$g_avAndroidShieldStatus[4] = $bDetachedShield

	; Add hooks
	AndroidShieldStartup()

	HandleWndProc($shieldState = "disabled-focus")

	SetDebugLog("AndroidShield updated to " & $shieldState & "(handle=" & $g_hFrmBotEmbeddedShield & ", color=" & Hex($color, 6) & "), caller: " & $sCaller, Default, True)

	Return True
EndFunc   ;==>_AndroidShield

Func AndroidGraphicsGdiBegin()
	If $g_bAndroidEmbedded = False Then Return 0

	AndroidGraphicsGdiEnd()

	; shield must be on before creating the gaphics
	Local $wasDown = AndroidShieldForcedDown()
	AndroidShieldForceDown(False)
	AndroidShield("AndroidGraphicsGdiBegin", True, True, 0, False)

	Local $iL = 0
	Local $iT = 0
	Local $iW = $g_iAndroidClientWidth
	Local $iH = $g_iAndroidClientHeight
	Local $iOpacity = 255

	Local $aPosCtl = $g_aiAndroidEmbeddedCtrlTarget[6]
	If IsArray($aPosCtl) = 1 Then
		$iW = $aPosCtl[2]
		$iH = $aPosCtl[3]
	EndIf

	Local $a = [0, 0]
	If $g_hFrmBotEmbeddedGraphics = 0 Then
		Local $bDetachedShield = $g_avAndroidShieldStatus[4]
		If $bDetachedShield = True Then
			Local $a = AndroidEmbed_HWnD_Position(True, $bDetachedShield)
			$iL = $a[0]
			$iT = $a[1]
		EndIf
		$g_hFrmBotEmbeddedGraphics = GUICreate("", $iW, $iH, $iL, $iT, $WS_CHILD, BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE, $WS_EX_LAYERED, $WS_EX_TOPMOST), $g_hFrmBot)
	EndIf
	WinMove2($g_hFrmBotEmbeddedGraphics, "", $iW, $iH, $iL, $iT, $HWND_NOTOPMOST, 0, False)
	GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotEmbeddedGraphics)

	;WinMove2($g_hFrmBotEmbeddedShield, "", $iW, $iH, $iL, $iT, $HWND_TOPMOST, 0, False)
	;WinMove2($g_hFrmBotEmbeddedGraphics, "", $iW, $iH, $iL, $iT, $HWND_TOPMOST, 0, False)

	Local $hDC = _WinAPI_GetDC($g_hFrmBotEmbeddedGraphics)
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

	AndroidShieldForceDown($wasDown)

	Return $hGraphics
EndFunc   ;==>AndroidGraphicsGdiBegin

Func AndroidGraphicsGdiUpdate()
	If $g_bAndroidEmbedded = False Then Return 0
	Local $hMDC = $g_aiAndroidEmbeddedGraphics[0][1]
	Local $hDC = $g_aiAndroidEmbeddedGraphics[2][1]
	Local $pSize = DllStructGetPtr($g_aiAndroidEmbeddedGraphics[4][1])
	Local $pSource = DllStructGetPtr($g_aiAndroidEmbeddedGraphics[5][1])
	Local $pBlend = DllStructGetPtr($g_aiAndroidEmbeddedGraphics[6][1])
	Local $pPoint = DllStructGetPtr($g_aiAndroidEmbeddedGraphics[7][1])
	Local $tPoint = DllStructCreate($tagPOINT, $pPoint)

	Local $bDetachedShield = $g_avAndroidShieldStatus[4]
	Local $a = AndroidEmbed_HWnD_Position(True, $bDetachedShield)
	DllStructSetData($tPoint, "X", $a[0])
	DllStructSetData($tPoint, "Y", $a[1])
	_WinAPI_UpdateLayeredWindow($g_hFrmBotEmbeddedGraphics, $hDC, $pPoint, $pSize, $hMDC, $pSource, 0, $pBlend, $ULW_ALPHA)
EndFunc   ;==>AndroidGraphicsGdiUpdate

Func AndroidGraphicsGdiAddObject($sType, $hHandle)
	If $g_bAndroidEmbedded = False Then Return 0
	Local $i = UBound($g_aiAndroidEmbeddedGraphics)
	ReDim $g_aiAndroidEmbeddedGraphics[$i + 1][2]
	$g_aiAndroidEmbeddedGraphics[$i][0] = $sType
	$g_aiAndroidEmbeddedGraphics[$i][1] = $hHandle
	SetDebugLog("AndroidGraphicsGdiAddObject: " & $sType & " " & $hHandle)
	Return $hHandle
EndFunc   ;==>AndroidGraphicsGdiAddObject

Func AndroidGraphicsGdiEnd($Result = Default, $bClear = True)
	If UBound($g_aiAndroidEmbeddedGraphics) > 0 Then
		Local $i
		For $i = UBound($g_aiAndroidEmbeddedGraphics) - 1 To 0 Step -1
			Local $sType = $g_aiAndroidEmbeddedGraphics[$i][0]
			Local $hHandle = $g_aiAndroidEmbeddedGraphics[$i][1]
			If $hHandle <> 0 Then
				SetDebugLog("AndroidGraphicsGdiEnd: Dispose/release/delete " & $sType & " " & $hHandle)
				Switch $sType
					Case "Pen"
						_GDIPlus_PenDispose($hHandle)
					Case "DllStruct"
						;$g_aiAndroidEmbeddedGraphics[$i][1] = 0 ; still needed for AndroidGraphicsGdiUpdate()
					Case "Graphics"
						_GDIPlus_GraphicsClear($hHandle)
						AndroidGraphicsGdiUpdate()
						_GDIPlus_GraphicsDispose($hHandle)
					Case "hDC"
						_WinAPI_ReleaseDC($g_hFrmBotEmbeddedGraphics, $hHandle)
					Case "hBitmap"
						_WinAPI_DeleteObject($hHandle)
					Case "hMDC"
						_WinAPI_DeleteDC($hHandle)
					Case Else
						SetDebugLog("Unknown GDI Type: " & $sType)
				EndSwitch
			EndIf
		Next
		ReDim $g_aiAndroidEmbeddedGraphics[0][2]
		If $g_hFrmBotEmbeddedGraphics <> 0 Then
			GUIDelete($g_hFrmBotEmbeddedGraphics)
			$g_hFrmBotEmbeddedGraphics = 0
		EndIf
	EndIf

	Return $Result
EndFunc   ;==>AndroidGraphicsGdiEnd
