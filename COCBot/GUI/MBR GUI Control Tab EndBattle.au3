; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkStopAtkDBNoLoot1()
	If GUICtrlRead($g_hChkStopAtkDBNoLoot1) = $GUI_CHECKED Then
		$g_abStopAtkNoLoot1Enable[$DB] = True
		GUICtrlSetState($g_hTxtStopAtkDBNoLoot1, $GUI_ENABLE)
		GUICtrlSetState($g_hLblStopAtkDBNoLoot1b, $GUI_ENABLE)
	Else
		$g_abStopAtkNoLoot1Enable[$DB] = False
		GUICtrlSetState($g_hTxtStopAtkDBNoLoot1, $GUI_DISABLE)
		GUICtrlSetState($g_hLblStopAtkDBNoLoot1b, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkStopAtkDBNoLoot1

Func chkStopAtkDBNoLoot2()
	If GUICtrlRead($g_hChkStopAtkDBNoLoot2) = $GUI_CHECKED Then
		$g_abStopAtkNoLoot2Enable[$DB] = True
		GUICtrlSetState($g_hTxtStopAtkDBNoLoot2, $GUI_ENABLE)
		GUICtrlSetState($g_hLblStopAtkDBNoLoot2b, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtDBMinGoldStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtDBMinElixirStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtDBMinDarkElixirStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hLblDBMinRerourcesAtk2, $GUI_ENABLE)
	Else
		$g_abStopAtkNoLoot2Enable[$DB] = False
		GUICtrlSetState($g_hTxtStopAtkDBNoLoot2, $GUI_DISABLE)
		GUICtrlSetState($g_hLblStopAtkDBNoLoot2b, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtDBMinGoldStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtDBMinElixirStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtDBMinDarkElixirStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDBMinRerourcesAtk2, $GUI_DISABLE)

	EndIf
EndFunc   ;==>chkStopAtkDBNoLoot2

Func chkStopAtkABNoLoot1()
	If GUICtrlRead($g_hChkStopAtkABNoLoot1) = $GUI_CHECKED Then
		$g_abStopAtkNoLoot1Enable[$LB] = True
		GUICtrlSetState($g_hTxtStopAtkABNoLoot1, $GUI_ENABLE)
		GUICtrlSetState($g_hLblABTimeStopAtk, $GUI_ENABLE)
	Else
		$g_abStopAtkNoLoot1Enable[$LB] = False
		GUICtrlSetState($g_hTxtStopAtkABNoLoot1, $GUI_DISABLE)
		GUICtrlSetState($g_hLblABTimeStopAtk, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkStopAtkABNoLoot1

Func chkStopAtkABNoLoot2()
	If GUICtrlRead($g_hChkStopAtkABNoLoot2) = $GUI_CHECKED Then
		$g_abStopAtkNoLoot2Enable[$LB] = True
		GUICtrlSetState($g_hTxtStopAtkABNoLoot2, $GUI_ENABLE)
		GUICtrlSetState($g_hLblABTimeStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtABMinGoldStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtABMinElixirStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtABMinDarkElixirStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hLblABMinRerourcesAtk2, $GUI_ENABLE)
	Else
		$g_abStopAtkNoLoot2Enable[$LB] = False
		GUICtrlSetState($g_hTxtStopAtkABNoLoot2, $GUI_DISABLE)
		GUICtrlSetState($g_hLblABTimeStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtABMinGoldStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtABMinElixirStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtABMinDarkElixirStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hLblABMinRerourcesAtk2, $GUI_DISABLE)

	EndIf
EndFunc   ;==>chkStopAtkABNoLoot2

Func chkDBEndPercentHigher()
	If GUICtrlRead($g_hChkDBEndPercentHigher) = $GUI_CHECKED Then
		$g_abStopAtkPctHigherEnable[$DB] = True
		GUICtrlSetState($g_hTxtDBPercentHigher, $GUI_ENABLE)
		GUICtrlSetState($g_hLblDBPercentHigherSec, $GUI_ENABLE)
	Else
		$g_abStopAtkPctHigherEnable[$DB] = False
		GUICtrlSetState($g_hTxtDBPercentHigher, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDBPercentHigherSec, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDBEndPercentHigher

Func chkDBEndPercentChange()
	If GUICtrlRead($g_hChkDBEndPercentChange) = $GUI_CHECKED Then
		$g_abStopAtkPctNoChangeEnable[$DB] = True
		GUICtrlSetState($g_hTxtDBPercentChange, $GUI_ENABLE)
		GUICtrlSetState($g_hLblDBPercentChangeSec, $GUI_ENABLE)
	Else
		$g_abStopAtkPctNoChangeEnable[$DB] = False
		GUICtrlSetState($g_hTxtDBPercentChange, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDBPercentChangeSec, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkDBEndPercentChange

Func chkABEndPercentHigher()
	If GUICtrlRead($g_hChkABEndPercentHigher) = $GUI_CHECKED Then
		$g_abStopAtkPctHigherEnable[$LB] = True
		GUICtrlSetState($g_hTxtABPercentHigher, $GUI_ENABLE)
		GUICtrlSetState($g_hLblABPercentHigherSec, $GUI_ENABLE)
	Else
		$g_abStopAtkPctHigherEnable[$LB] = False
		GUICtrlSetState($g_hTxtABPercentHigher, $GUI_DISABLE)
		GUICtrlSetState($g_hLblABPercentHigherSec, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkABEndPercentHigher

Func chkABEndPercentChange()
	If GUICtrlRead($g_hChkABEndPercentChange) = $GUI_CHECKED Then
		$g_abStopAtkPctNoChangeEnable[$LB] = True
		GUICtrlSetState($g_hTxtABPercentChange, $GUI_ENABLE)
		GUICtrlSetState($g_hLblABPercentChangeSec, $GUI_ENABLE)
	Else
		$g_abStopAtkPctNoChangeEnable[$LB] = False
		GUICtrlSetState($g_hTxtABPercentChange, $GUI_DISABLE)
		GUICtrlSetState($g_hLblABPercentChangeSec, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkABEndPercentChange

Func chkDESideEB()
	If GUICtrlRead($g_hChkDESideEB) = $GUI_CHECKED Then
		For $i = $g_hTxtDELowEndMin To $g_hLblDEEndAq
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $g_hTxtDELowEndMin To $g_hLblDEEndAq
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkDESideEB


Func chkTSMeetDE()
	_GUICtrlEdit_SetReadOnly($g_hTxtTSMinDarkElixir, GUICtrlRead($g_hChkTSMeetDE) = $GUI_CHECKED ? False : True)
EndFunc   ;==>chkTSMeetDE
#CS
Func chkTSTimeStopAtk()
	If GUICtrlRead($chkTSTimeStopAtk) = $GUI_CHECKED Then
		$g_abStopAtkNoLoot1Enable[$TS] = True
		GUICtrlSetState($txtTSTimeStopAtk, $GUI_ENABLE)
		GUICtrlSetState($lblTSTimeStopAtk, $GUI_ENABLE)
	Else
		$g_abStopAtkNoLoot1Enable[$TS] = False
		GUICtrlSetState($txtTSTimeStopAtk, $GUI_DISABLE)
		GUICtrlSetState($lblTSTimeStopAtk, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTSTimeStopAtk

Func chkTSTimeStopAtk2()
	If GUICtrlRead($chkTSTimeStopAtk2) = $GUI_CHECKED Then
		$g_abStopAtkNoLoot2Enable[$TS] = True
		GUICtrlSetState($txtTSTimeStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($lblTSTimeStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($txtTSMinGoldStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($txtTSMinElixirStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtTSMinDarkElixirStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($lblTSMinRerourcesAtk2, $GUI_ENABLE)
	Else
		$g_abStopAtkNoLoot2Enable[$TS] = False
		GUICtrlSetState($txtTSTimeStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($lblTSTimeStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($txtTSMinGoldStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($txtTSMinElixirStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtTSMinDarkElixirStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($lblTSMinRerourcesAtk2, $GUI_DISABLE)

	EndIf
EndFunc   ;==>chkTSTimeStopAtk2
#CE
Func btnConfigureReplayShare()
;~ 	OpenGUIReplayShare()
EndFunc   ;==>btnConfigureReplayShare

Func chkTakeLootSS()
	GUICtrlSetState($g_hChkScreenshotLootInfo, GUICtrlRead($g_hChkTakeLootSS) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkTakeLootSS

;Apply to switch Attack Standard after THSnipe End ==>
Func chkTSActivateCamps2()
	If GUICtrlRead($g_hChkTSActivateCamps2) = $GUI_CHECKED Then
		GUICtrlSetState($g_hLblTSArmyCamps2, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtTSArmyCamps2, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hLblTSArmyCamps2, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtTSArmyCamps2, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTSActivateCamps2
;==> Apply to switch Attack Standard after THSnipe End
