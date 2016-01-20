
; #FUNCTION# ====================================================================================================================
; Name ..........: CheckDisplay
; Description ...: checks user display with BS window
; Syntax ........: CheckDisplay()
; Parameters ....: None
; Return values .: Returns True if both DPI and display are above minimum requirement, returns False otherwise.
; Author ........: MonkeyHunter (12-2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: None
; Link ..........: https://www.autoitscript.com/forum/topic/154885-autoit-and-dpi-awareness/, https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;

#include <WinAPIGdi.au3>

Func CheckDisplay()

	Local $aPos, $sBSDisplaySize
	Local $bDisplayDPI = False, $bDisplayFound = False
	Local Const $iDisplaySizeMin = 780

	Local $iDPIRatio = GetDPI_Ratio()
	If $iDPIRatio <> 1 Then
		SetLog(_PadStringCenter(" ERROR!! Display DPI setting INCORRECT = " & $iDPIRatio, 53, "+"), $COLOR_RED)
		SetLog(_PadStringCenter(" Set DPI to 1 or 100% for proper operation ", "+"), $COLOR_RED)
		SetLog(_PadStringCenter(" If you need help, search Google with these keywords", 53, "+"), $COLOR_RED)
		SetLog(_PadStringCenter(" windows # set dpi, replace # with your OS # ", 53, "+"), $COLOR_RED)
		SetLog(_PadStringCenter(" Bot start button disabled till fixed", 53, "+"), $COLOR_RED)
		Setlog(" ")
		GUICtrlSetState($btnStart, $GUI_DISABLE)
	Else
		If $Debugsetlog = 1 Then SetLog(_PadStringCenter("  Display DPI setting = " & $iDPIRatio & "  ", 53, "+"), $COLOR_BLUE)
		ConsoleWrite('DPI= ' & $iDPIRatio & @CRLF)
		$bDisplayDPI = True ; DPI OK
	EndIf

	Local $hMonitor = _WinAPI_MonitorFromWindow($HWnD) ; Get display handle with BS window
	ConsoleWrite('Handle: ' & $hMonitor & @CRLF) ; debug handle data

	Local $aMonitorData = _WinAPI_EnumDisplayMonitors() ; Get data for all displays in system
	If IsArray($aMonitorData) Then ; process 2d array DStruct into usable array
		ReDim $aMonitorData[$aMonitorData[0][0] + 1][5]
		For $i = 1 To $aMonitorData[0][0]
			$aPos = _WinAPI_GetPosFromRect($aMonitorData[$i][1])
			For $j = 0 To 3
				$aMonitorData[$i][$j + 1] = $aPos[$j]
			Next
		Next

		ConsoleWrite('NumberDisplays: ' & $aMonitorData[0][0] & @CRLF) ; display debug data

		For $i = 1 To $aMonitorData[0][0] ; search system display data for display with BS window on it and check size
			ConsoleWrite('DisplayHandle: ' & $aMonitorData[$i][0] & ', DisplayX: ' & $aMonitorData[$i][3] & ', DisplayY: ' & $aMonitorData[$i][4] & @CRLF)
			If $aMonitorData[$i][0] = $hMonitor Then ; find display with BS
				$bDisplayFound = True
				$bMonitorHeight800orBelow = ( $aMonitorData[$i][4] <= 800 )
				$sBSDisplaySize = $aMonitorData[$i][3] & "x" & $aMonitorData[$i][4]
				ConsoleWrite("DisplaySizeFound: " & $sBSDisplaySize & @CRLF)
				If ($aMonitorData[$i][3] < $iDisplaySizeMin) Or ($aMonitorData[$i][4] < $iDisplaySizeMin) Then
					SetLog(_PadStringCenter(" Warning!! Display size smaller than recommended = " & $sBSDisplaySize & " ", 53, "+"), $COLOR_RED)
					SetLog(_PadStringCenter(" Remove Hide BS system bar or Full Screen App now ", 53, "+"), $COLOR_RED)
					SetLog(_PadStringCenter(" MBR will attempt auto adjust BS size ", 53, "+"), $COLOR_RED)
					SetLog(_PadStringCenter(" Close all BS process and restart may be required ", 53, "+"), $COLOR_RED)
					SetLog(_PadStringCenter(" Search MyBot.run forums if any problems ", 53, "+"), $COLOR_RED)
					Setlog(" ")
				Else
					ConsoleWrite("Display Check Pass!" & @CRLF)
					If $Debugsetlog = 1 Then SetLog(_PadStringCenter(" Display size= " & $sBSDisplaySize & " ", 50, "+"), $COLOR_Blue)
					ExitLoop
				EndIf
			EndIf
		Next
		If $bDisplayFound = False Then
			SetLog(" Error finding BS display device size, proceed with caution!", $COLOR_RED)
		EndIf
	Else
		SetLog(" Error finding BS display device, proceed with caution!", $COLOR_RED)
	EndIf

	Return $bDisplayDPI And $bDisplayFound

EndFunc   ;==>CheckDisplay
;

