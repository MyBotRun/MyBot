; #FUNCTION# ====================================================================================================================
; Name ..........: CheckZoomOut
; Description ...:
; Syntax ........: CheckZoomOut()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #12
; Modified ......:
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
;
Func CheckZoomOut()
					 _CaptureRegion(0, 0, 860, 2)
					 If _GetPixelColor(1, 1) <> Hex(0x000000, 6) And _GetPixelColor(850, 1) <> Hex(0x000000, 6) Then
						   SetLog("Not Zoomed Out! Exiting to MainScreen...", $COLOR_RED)
						   checkMainScreen() ;exit battle screen
						   $Restart = True
						   Return False
						Else
						   Return True
						EndIf
EndFunc