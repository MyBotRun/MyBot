; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Splash
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mikemikemikecoc (2016)
; Modified ......: cosote (2016-Aug), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; Splash Variables
Global $g_hSplash = 0, $g_hSplashProgress, $g_lSplashStatus, $g_lSplashTitle
Global Const $g_iSplashTotalSteps = 10
Global $g_iSplashCurrentStep = 0
Global $g_hSplashTimer = 0

#include "MBR GUI Control Splash.au3"

#Region Splash

Func CreateSplashScreen()

   Local $sSplashImg = $g_sLogoPath
   Local $hImage, $iX, $iY
   Local $iT = 20 ; Top of logo (additional space)
   Local $iB = 10 ; Bottom of logo (additional space)

   If $ichkDisableSplash = 0 Then

	   Local $hSplashImg = _GDIPlus_BitmapCreateFromFile($sSplashImg)
	   ; Determine dimensions of splash image
	   $iX = _GDIPlus_ImageGetWidth($hSplashImg)
	   $iY = _GDIPlus_ImageGetHeight($hSplashImg)

	   ; Create Splash container
	   $g_hSplash = GUICreate("", $iX, $iY + $iT + $iB + 60, -1, -1, BitOR($WS_POPUP, $WS_BORDER), BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE, $WS_EX_TOOLWINDOW))
	   GUISetBkColor($COLOR_WHITE, $g_hSplash)
	   _GUICtrlCreatePic($hSplashImg, 0, $iT) ; Splash Image
	   $g_lSplashTitle = GUICtrlCreateLabel($g_sBotTitle, 15, $iY + $iT + $iB + 3, $iX - 30, 15, $SS_CENTER) ; Splash Title
	   $g_hSplashProgress = GUICtrlCreateProgress(15, $iY + $iT + $iB + 20, $iX - 30, 10, $PBS_SMOOTH, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE, $WS_EX_TOOLWINDOW)) ; Splash Progress
	   $g_lSplashStatus = GUICtrlCreateLabel("", 15, $iY + $iT + $iB + 38, $iX - 30, 15, $SS_CENTER) ; Splash Title

	   ; Cleanup GDI resources
	   _GDIPlus_BitmapDispose($hSplashImg)

	   ; Show Splash
	   GUISetState(@SW_SHOWNOACTIVATE, $g_hSplash)

	   $g_hSplashTimer = TimerInit()
	EndIf

EndFunc

#EndRegion