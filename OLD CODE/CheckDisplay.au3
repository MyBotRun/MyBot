; #FUNCTION# ====================================================================================================================
; Name ..........: CheckDisplay
; Description ...: checks user display with Android Emulator window
; Syntax ........: CheckDisplay()
; Parameters ....: None
; Return values .: Returns True if both DPI and display are above minimum requirement, returns False otherwise.
; Author ........: MonkeyHunter (12-2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: None
; Link ..........: https://www.autoitscript.com/forum/topic/154885-autoit-and-dpi-awareness/, https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include <WinAPIGdi.au3>

Func CheckDisplay()

	Local $aPos, $sBSDisplaySize
	Local $bDisplayDPI = False, $bDisplayFound = False
	Local Const $iDisplaySizeMin = 780

	Local $iDPIRatio = GetDPI_Ratio()

	If $g_bDebugSetlog Then SetLogCentered("  Display DPI setting = " & $iDPIRatio & "  ", "+", $COLOR_INFO)
	ConsoleWrite('DPI= ' & $iDPIRatio & @CRLF)
	$bDisplayDPI = True ; DPI OK

	Local $hMonitor = _WinAPI_MonitorFromWindow($g_hAndroidWindow) ; Get display handle with Android Emulator window
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

		For $i = 1 To $aMonitorData[0][0] ; search system display data for display with Android Emulator window on it and check size
			ConsoleWrite('DisplayHandle: ' & $aMonitorData[$i][0] & ', DisplayX: ' & $aMonitorData[$i][3] & ', DisplayY: ' & $aMonitorData[$i][4] & @CRLF)
			If $aMonitorData[$i][0] = $hMonitor Then ; find display with Android Emulator
				$bDisplayFound = True
				$sBSDisplaySize = $aMonitorData[$i][3] & "x" & $aMonitorData[$i][4]
				ConsoleWrite("DisplaySizeFound: " & $sBSDisplaySize & @CRLF)
				If ($aMonitorData[$i][3] < $iDisplaySizeMin) Or ($aMonitorData[$i][4] < $iDisplaySizeMin) Then
					SetLogCentered(" Warning! Display size smaller than recommended = " & $sBSDisplaySize & " ", "+", $COLOR_ERROR)
					SetLogCentered(" MBR will attempt to auto adjust Emulator size ", "+", $COLOR_ERROR)
					SetLogCentered(" Make sure task bar isn't covering Emulator ", "+", $COLOR_ERROR)
					SetLogCentered(" Search MyBot.run forums if any problems ", "+", $COLOR_ERROR)
					SetLogCentered(" Click ""Start Bot"" to proceed ", "+", $COLOR_ERROR)
					SetLog(" ")
				Else
					ConsoleWrite("Display Check Pass!" & @CRLF)
					If $g_bDebugSetlog Then SetLogCentered(" Display size= " & $sBSDisplaySize & " ", "+", $COLOR_INFO)
					ExitLoop
				EndIf
			EndIf
		Next
		If Not $bDisplayFound Then
			SetLog(" Error finding Android Emulator display device size, proceed with caution!", $COLOR_ERROR)
		EndIf
	Else
		SetLog(" Error finding Android Emulator display device, proceed with caution!", $COLOR_ERROR)
	EndIf

	Return $bDisplayDPI And $bDisplayFound

EndFunc   ;==>CheckDisplay
