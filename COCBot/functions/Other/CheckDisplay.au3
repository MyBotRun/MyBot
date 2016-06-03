
; #FUNCTION# ====================================================================================================================
; Name ..........: CheckDisplay
; Description ...: checks user display with Android Emulator window
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
		ShowDPIHelp($iDPIRatio * 100)
	Else
		If $Debugsetlog = 1 Then SetLog(_PadStringCenter("  Display DPI setting = " & $iDPIRatio & "  ", 53, "+"), $COLOR_BLUE)
		ConsoleWrite('DPI= ' & $iDPIRatio & @CRLF)
		$bDisplayDPI = True ; DPI OK
	EndIf

	Local $hMonitor = _WinAPI_MonitorFromWindow($HWnD) ; Get display handle with Android Emulator window
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
				$bMonitorHeight800orBelow = ($aMonitorData[$i][4] <= 800)
				$sBSDisplaySize = $aMonitorData[$i][3] & "x" & $aMonitorData[$i][4]
				ConsoleWrite("DisplaySizeFound: " & $sBSDisplaySize & @CRLF)
				If ($aMonitorData[$i][3] < $iDisplaySizeMin) Or ($aMonitorData[$i][4] < $iDisplaySizeMin) Then
					SetLog(_PadStringCenter(" Warning!! Display size smaller than recommended = " & $sBSDisplaySize & " ", 53, "+"), $COLOR_RED)
					SetLog(_PadStringCenter(" MBR will attempt to auto adjust Emulator size ", 53, "+"), $COLOR_RED)
					SetLog(_PadStringCenter(" Make sure task bar isn't covering Emulator ", 53, "+"), $COLOR_RED)
					SetLog(_PadStringCenter(" Search MyBot.run forums if any problems ", 53, "+"), $COLOR_RED)
					SetLog(_PadStringCenter(" Click ""Start Bot"" to proceed ", 53, "+"), $COLOR_RED)
					Setlog(" ")
				Else
					ConsoleWrite("Display Check Pass!" & @CRLF)
					If $Debugsetlog = 1 Then SetLog(_PadStringCenter(" Display size= " & $sBSDisplaySize & " ", 50, "+"), $COLOR_Blue)
					ExitLoop
				EndIf
			EndIf
		Next
		If $bDisplayFound = False Then
			SetLog(" Error finding Android Emulator display device size, proceed with caution!", $COLOR_RED)
		EndIf
	Else
		SetLog(" Error finding Android Emulator display device, proceed with caution!", $COLOR_RED)
	EndIf

	Return $bDisplayDPI And $bDisplayFound

EndFunc   ;==>CheckDisplay
Func ShowDPIHelp($currentDPI)
	$text = GetTranslated(640,4,"Your DPI is incorrect. It is set to") & " " & $currentDPI & GetTranslated(640,5,"%. You must set it to 100% for this bot to work.") & @CRLF & _
			GetTranslated(640,6,"When you have changed the DPI to the correct value, reboot your computer and run the bot again.") & @CRLF & _
			GetTranslated(640,7,"You won't be able to use the bot until you make this change.") & @CRLF & @CRLF & _
			GetTranslated(640,8,"Click OK to view instructions on how to change DPI")
	Local $button = MsgBox($MB_OKCANCEL + $MB_ICONWARNING, GetTranslated(640,3,"DPI incorrect"), $text)
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
				MsgBox($MB_OK, GetTranslated(640,9,"Unsupported"), GetTranslated(640,10,"Sorry, your operating system isn't supported by the bot."))
		EndSwitch
	EndIf
	btnStop()
	GUICtrlSetState($btnStart, $GUI_DISABLE)
EndFunc   ;==>ShowDPIHelp

