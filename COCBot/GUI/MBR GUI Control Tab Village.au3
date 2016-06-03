; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func chkTrap()
	If GUICtrlRead($chkTrap) = $GUI_CHECKED Then
		$ichkTrap = 1
		;GUICtrlSetState($btnLocateTownHall, $GUI_SHOW)
	Else
		$ichkTrap = 0
		;GUICtrlSetState($btnLocateTownHall, $GUI_HIDE)
	EndIf
EndFunc   ;==>chkTrap

Func chkRequestCCHours()
	Local $bWasRedraw = SetRedrawBotWindow(False)

	If GUICtrlRead($chkRequestCCHours) = $GUI_CHECKED Then
		GUICtrlSetState($txtRequestCC, $GUI_SHOW + $GUI_ENABLE)
		For $i = $lbRequestCCHours1 To $lbRequestCCHoursPM
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		GUICtrlSetState($txtRequestCC, $GUI_SHOW + $GUI_DISABLE)
		For $i = $lbRequestCCHours1 To $lbRequestCCHoursPM
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf

	SetRedrawBotWindowControls($bWasRedraw, $grpRequestCC)
EndFunc   ;==>chkRequestCCHours


Func chkRequestCCHoursE1()
	If GUICtrlRead($chkRequestCCHoursE1) = $GUI_CHECKED And GUICtrlRead($chkRequestCCHours0) = $GUI_CHECKED Then
		For $i = $chkRequestCCHours0 To $chkRequestCCHours11
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkRequestCCHours0 To $chkRequestCCHours11
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkRequestCCHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkRequestCCHoursE1

Func chkRequestCCHoursE2()
	If GUICtrlRead($chkRequestCCHoursE2) = $GUI_CHECKED And GUICtrlRead($chkRequestCCHours12) = $GUI_CHECKED Then
		For $i = $chkRequestCCHours12 To $chkRequestCCHours23
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkRequestCCHours12 To $chkRequestCCHours23
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkRequestCCHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkRequestCCHoursE2

Func chkDonateHours()
	Local $bWasRedraw = SetRedrawBotWindow(False)
	If GUICtrlRead($chkDonateHours) = $GUI_CHECKED Then
		For $i = $lbDonateHours1 To $lbDonateHoursPM
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $lbDonateHours1 To $lbDonateHoursPM
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
	SetRedrawBotWindowControls($bWasRedraw, $grpDonateCC)
EndFunc   ;==>chkDonateHours

Func chkDonateHoursE1()
	If GUICtrlRead($chkDonateHoursE1) = $GUI_CHECKED And GUICtrlRead($chkDonateHours0) = $GUI_CHECKED Then
		For $i = $chkDonateHours0 To $chkDonateHours11
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkDonateHours0 To $chkDonateHours11
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkDonateHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkDonateHoursE1

Func chkDonateHoursE2()
	If GUICtrlRead($chkDonateHoursE2) = $GUI_CHECKED And GUICtrlRead($chkDonateHours12) = $GUI_CHECKED Then
		For $i = $chkDonateHours12 To $chkDonateHours23
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkDonateHours12 To $chkDonateHours23
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkDonateHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkDonateHoursE2


Func chkDropCCHoursE1()
	If GUICtrlRead($chkDropCCHoursE1) = $GUI_CHECKED And GUICtrlRead($chkDropCCHours0) = $GUI_CHECKED Then
		For $i = $chkDropCCHours0 To $chkDropCCHours11
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkDropCCHours0 To $chkDropCCHours11
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkDropCCHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkDropCCHoursE1

Func chkDropCCHoursE2()
	If GUICtrlRead($chkDropCCHoursE2) = $GUI_CHECKED And GUICtrlRead($chkDropCCHours12) = $GUI_CHECKED Then
		For $i = $chkDropCCHours12 To $chkDropCCHours23
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkDropCCHours12 To $chkDropCCHours23
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkDropCCHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkDropCCHoursE2




