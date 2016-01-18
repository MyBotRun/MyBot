; #FUNCTION# ====================================================================================================================
; Name ..........: DebugSaveDesktopImage
; Description ...: Saves a .png image of the desktop, used when severe BS errors occur for developer debug
; Syntax ........: DebugSaveDesktopImage()
; Parameters ....:
; Return values .: None
; Author ........: KnowJack (Aug 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func DebugSaveDesktopImage($sName = "Unknown_")
	Local $iDesktopLeft = 0, $iDesktopTop = 0
	Local $iDesktopWidth = @DesktopWidth, $iDesktopHeight = @DesktopHeight
	Local $hDesktopBitmap = _ScreenCapture_Capture("", $iDesktopLeft, $iDesktopTop, $iDesktopWidth, $iDesktopHeight, False)
	SetLog("Saving desktop snapshot in TEMP folder for developer review", $COLOR_BLUE)
	$Date = @MDAY & "." & @MON & "." & @YEAR
	$Time = @HOUR & "." & @MIN & "." & @SEC
	$SaveFileName = $sName & $Date & "_at_" & $Time & ".png"
	_ScreenCapture_SaveImage($dirTempDebug & $SaveFileName, $hDesktopBitmap)
	_WinAPI_DeleteObject($hDesktopBitmap)
EndFunc   ;==>DebugSaveDesktopImage
