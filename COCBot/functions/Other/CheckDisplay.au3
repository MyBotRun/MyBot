
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
;

#include <WinAPIGdi.au3>

Func CheckDisplay()

	Local $aPos, $sBSDisplaySize
	Local $bDisplayDPI = False, $bDisplayFound = False
	Local Const $iDisplaySizeMin = 780

	Local $iDPIRatio = GetDPI_Ratio()
	If $iDPIRatio <> 1 Then
		ShowDPIHelp($iDPIRatio * 100)
	Else
		If $g_iDebugSetlog = 1 Then SetLogCentered("  Display DPI setting = " & $iDPIRatio & "  ", "+", $COLOR_INFO)
		ConsoleWrite('DPI= ' & $iDPIRatio & @CRLF)
		$bDisplayDPI = True ; DPI OK
	EndIf

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
					SetLogCentered(" Warning!! Display size smaller than recommended = " & $sBSDisplaySize & " ", "+", $COLOR_ERROR)
					SetLogCentered(" MBR will attempt to auto adjust Emulator size ", "+", $COLOR_ERROR)
					SetLogCentered(" Make sure task bar isn't covering Emulator ", "+", $COLOR_ERROR)
					SetLogCentered(" Search MyBot.run forums if any problems ", "+", $COLOR_ERROR)
					SetLogCentered(" Click ""Start Bot"" to proceed ", "+", $COLOR_ERROR)
					Setlog(" ")
				Else
					ConsoleWrite("Display Check Pass!" & @CRLF)
					If $g_iDebugSetlog = 1 Then SetLogCentered(" Display size= " & $sBSDisplaySize & " ", "+", $COLOR_INFO)
					ExitLoop
				EndIf
			EndIf
		Next
		If $bDisplayFound = False Then
			SetLog(" Error finding Android Emulator display device size, proceed with caution!", $COLOR_ERROR)
		EndIf
	Else
		SetLog(" Error finding Android Emulator display device, proceed with caution!", $COLOR_ERROR)
	EndIf

	Return $bDisplayDPI And $bDisplayFound

EndFunc   ;==>CheckDisplay
Func ShowDPIHelp($currentDPI)
	Local $text = GetTranslatedFileIni("MBR Popups", "Settings_DPI_Error_01", "Your DPI is incorrect. It is set to") & " " & $currentDPI & GetTranslatedFileIni("MBR Popups", "Settings_DPI_Error_02", "%. You must set it to 100% for this bot to work.") & @CRLF & _
			GetTranslatedFileIni("MBR Popups", "Settings_DPI_Error_03", "When you have changed the DPI to the correct value, reboot your computer and run the bot again.") & @CRLF & _
			GetTranslatedFileIni("MBR Popups", "Settings_DPI_Error_04", "You won't be able to use the bot until you make this change.") & @CRLF & @CRLF & _
			GetTranslatedFileIni("MBR Popups", "Settings_DPI_Error_05", "Click OK to view instructions on how to change DPI")
	Local $button = MsgBox($MB_OKCANCEL + $MB_ICONWARNING, GetTranslatedFileIni("MBR Popups", "Settings_DPI_Error_06", "DPI incorrect"), $text)
	If $button = $IDOK Then
		Switch @OSVersion
			Case "WIN_10"
				ShellExecute("https://mybot.run/forums/index.php?/topic/15137-change-dpi-to-100/#comment-141136")
			Case "WIN_8", "WIN_81"
				ShellExecute("https://mybot.run/forums/index.php?/topic/15137-change-dpi-to-100/#comment-141160")
			Case "WIN_7"
				ShellExecute("https://mybot.run/forums/index.php?/topic/15137-change-dpi-to-100/#comment-141159")
			Case "WIN_VISTA"
				ShellExecute("https://mybot.run/forums/index.php?/topic/15137-change-dpi-to-100/#comment-141161")
			Case "WIN_2012"
				ShellExecute("https://mybot.run/forums/index.php?/topic/15137-change-dpi-to-100/#comment-141160")
			Case Else
				MsgBox($MB_OK, GetTranslatedFileIni("MBR Popups", "Settings_DPI_Error_07", "Unsupported"), GetTranslatedFileIni("MBR Popups", "Settings_DPI_Error_08", "Sorry, your operating system isn't supported by the bot."))
		EndSwitch
	EndIf
	btnStop()
	GUICtrlSetState($g_hBtnStart, $GUI_DISABLE)
EndFunc   ;==>ShowDPIHelp

