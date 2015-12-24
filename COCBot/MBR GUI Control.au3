; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), kaganus (August-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Opt("GUIOnEventMode", 1)
Opt("MouseClickDelay", 10)
Opt("MouseClickDownDelay", 10)
Opt("TrayMenuMode", 3)

#include-once
#include "functions\Other\GUICtrlGetBkColor.au3" ; Included here to use on GUI Control

;Dynamic declaration of Array controls, cannot be on global variables because the GUI has to be created first for these control-id's to be known.
Local $aChkDonateControls[17] = [$chkDonateBarbarians, $chkDonateArchers, $chkDonateGiants, $chkDonateGoblins, $chkDonateWallBreakers, $chkDonateBalloons, $chkDonateWizards, $chkDonateHealers, $chkDonateDragons, $chkDonatePekkas, $chkDonateMinions, $chkDonateHogRiders, $chkDonateValkyries, $chkDonateGolems, $chkDonateWitches, $chkDonateLavaHounds, $chkDonateCustom]
Local $aChkDonateAllControls[17] = [$chkDonateAllBarbarians, $chkDonateAllArchers, $chkDonateAllGiants, $chkDonateAllGoblins, $chkDonateAllWallBreakers, $chkDonateAllBalloons, $chkDonateAllWizards, $chkDonateAllHealers, $chkDonateAllDragons, $chkDonateAllPekkas, $chkDonateAllMinions, $chkDonateAllHogRiders, $chkDonateAllValkyries, $chkDonateAllGolems, $chkDonateAllWitches, $chkDonateAllLavaHounds, $chkDonateAllCustom]
Local $aTxtDonateControls[17] = [$txtDonateBarbarians, $txtDonateArchers, $txtDonateGiants, $txtDonateGoblins, $txtDonateWallBreakers, $txtDonateBalloons, $txtDonateWizards, $txtDonateHealers, $txtDonateDragons, $txtDonatePekkas, $txtDonateMinions, $txtDonateHogRiders, $txtDonateValkyries, $txtDonateGolems, $txtDonateWitches, $txtDonateLavaHounds, $txtDonateCustom]
Local $aTxtBlacklistControls[17] = [$txtBlacklistBarbarians, $txtBlacklistArchers, $txtBlacklistGiants, $txtBlacklistGoblins, $txtBlacklistWallBreakers, $txtBlacklistBalloons, $txtBlacklistWizards, $txtBlacklistHealers, $txtBlacklistDragons, $txtBlacklistPekkas, $txtBlacklistMinions, $txtBlacklistHogRiders, $txtBlacklistValkyries, $txtBlacklistGolems, $txtBlacklistWitches, $txtBlacklistLavaHounds, $txtBlacklistCustom]
Local $aLblBtnControls[17] = [$lblBtnBarbarians, $lblBtnArchers, $lblBtnGiants, $lblBtnGoblins, $lblBtnWallBreakers, $lblBtnBalloons, $lblBtnWizards, $lblBtnHealers, $lblBtnDragons, $lblBtnPekkas, $lblBtnMinions, $lblBtnHogRiders, $lblBtnValkyries, $lblBtnGolems, $lblBtnWitches, $lblBtnLavaHounds, $lblBtnCustom]

_GDIPlus_Startup()

Global $Initiate = 0
Global $ichklanguageFirst = 0
Global $ichklanguage = 1

AtkLogHead()

;~ ------------------------------------------------------
;~ Control Tab Files
;~ ------------------------------------------------------
#include "GUI\MBR GUI Control Bottom.au3"
#include "GUI\MBR GUI Control Tab General.au3"
#include "GUI\MBR GUI Control Tab Troops.au3"
#include "GUI\MBR GUI Control Tab Search.au3"
#include "GUI\MBR GUI Control Tab Attack.au3"
#include "GUI\MBR GUI Control Tab Advanced.au3"
#include "GUI\MBR GUI Control Tab EndBattle.au3"
#include "GUI\MBR GUI Control Tab Donate.au3"
#include "GUI\MBR GUI Control Tab Misc.au3"
#include "GUI\MBR GUI Control Tab Upgrade.au3"
#include "GUI\MBR GUI Control Tab Notify.au3"
#include "GUI\MBR GUI Control Tab Expert.au3"
#include "GUI\MBR GUI Control Tab Stats.au3"

Func GUIControl($hWind, $iMsg, $wParam, $lParam)
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0x0000FFFF)
	Local $hCtrl = $lParam
	#forceref $hWind, $iMsg, $wParam, $lParam
	Switch $iMsg
		Case 273
			Switch $nID
				Case $divider
					MoveDivider()
				Case $GUI_EVENT_CLOSE
					; Clean up resources
					_GDIPlus_ImageDispose($hBitmap)
					_WinAPI_DeleteObject($hHBitmap)
					_GDIPlus_Shutdown()
					MBRFunc(False) ; close MBRFunctions dll
					_GUICtrlRichEdit_Destroy($txtLog)
					_GUICtrlRichEdit_Destroy($txtAtkLog)
					SaveConfig()
					Exit
				Case $labelMyBotURL
					ShellExecute("https://MyBot.run/forums") ;open web site when clicking label
				Case $labelForumURL
					ShellExecute("https://MyBot.run/forums/forumdisplay.php?fid=2") ;open web site when clicking label
				Case $btnStop
					If $RunState Then btnStop()
				Case $btnPause
					If $RunState Then btnPause()
				Case $btnResume
					If $RunState Then btnResume()
				Case $btnHide
					If $RunState Then btnHide()
				Case $btnResetStats
					If $RunState Then btnResetStats()
				Case $btnAttackNowDB
					If $RunState Then btnAttackNowDB()
				Case $btnAttackNowLB
					If $RunState Then btnAttackNowLB()
				Case $btnAttackNowTS
					If $RunState Then btnAttackNowTS()
				Case $DonateConfig
					ShellExecute("https://MyBot.run/forums/misc.php?action=mydonations")
				Case $btnDeletePBMessages
					If $RunState Then
						btnDeletePBMessages() ; call with flag when bot is running to execute on _sleep() idle
					Else
						PushMsg("DeleteAllPBMessages") ; call directly when bot is stopped
					EndIf
				Case $btnMakeScreenshot
					If $RunState Then
						; call with flag when bot is running to execute on _sleep() idle
						btnMakeScreenshot()
					Else
						; call directly when bot is stopped
						If $iScreenshotType = 0 Then
							MakeScreenshot($dirTemp, "jpg")
						Else
							MakeScreenshot($dirTemp, "png")
						EndIf
					EndIf
				Case $pic2arrow
					If $RunState Then btnVillageStat()
			EndSwitch
		Case 274
			Switch $wParam
				Case 0xf060
					_GDIPlus_Shutdown()
					_GUICtrlRichEdit_Destroy($txtLog)
					_GUICtrlRichEdit_Destroy($txtAtkLog)
					SaveConfig()
					Exit
			EndSwitch
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl

Func SetTime()
	Local $time = _TicksToTime(Int(TimerDiff($sTimer) + $iTimePassed), $hour, $min, $sec)
	If GUICtrlRead($tabMain, 1) = $tabStats Then GUICtrlSetData($lblresultruntime, StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
	If GUICtrlGetState($lblResultGoldNow) <> $GUI_ENABLE + $GUI_SHOW Then GUICtrlSetData($lblResultRuntimeNow, StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
	;If $pEnabled = 1 And $pRemote = 1 And StringFormat("%02i", $sec) = "50" Then _RemoteControl()
	;If $pEnabled = 1 And $ichkDeleteOldPushes = 1 And Mod($min + 1, 30) = 0 And $sec = "0" Then _DeleteOldPushes() ; check every 30 min if must to delete old pushbullet messages, increase delay time for anti ban pushbullet
EndFunc   ;==>SetTime

Func tabMain()
	If GUICtrlRead($tabMain, 1) = $tabGeneral Then
		If _GUICtrlComboBox_GetCurSel($cmbLog) <> 5 Then ControlShow($frmBot, "", $txtLog)
		If _GUICtrlComboBox_GetCurSel($cmbLog) <> 4 Then ControlShow($frmBot, "", $txtAtkLog)
	Else
		ControlHide($frmBot, "", $txtLog)
		ControlHide($frmBot, "", $txtAtkLog)
	EndIf
EndFunc   ;==>tabMain

;---------------------------------------------------
; Extra Functions used on GUI Control
;---------------------------------------------------

Func _DonateAllControls($TroopType, $Set)
	If $Set = True Then
		For $i = 0 To UBound($aLblBtnControls) - 1
			If $i = $TroopType Then
				GUICtrlSetBkColor($aLblBtnControls[$i], $COLOR_NAVY)
			Else
				GUICtrlSetBkColor($aLblBtnControls[$i], $GUI_BKCOLOR_TRANSPARENT)
			EndIf
		Next

		For $i = 0 To UBound($aChkDonateAllControls) - 1
			If $i <> $TroopType Then
				GUICtrlSetState($aChkDonateAllControls[$i], $GUI_UNCHECKED)
			EndIf
		Next

		For $i = 0 To UBound($aChkDonateControls) - 1
			GUICtrlSetState($aChkDonateControls[$i], $GUI_UNCHECKED)
		Next

		For $i = 0 To UBound($aTxtDonateControls) - 1
			If BitAND(GUICtrlGetState($aTxtDonateControls[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($aTxtDonateControls[$i], $GUI_DISABLE)
		Next

		For $i = 0 To UBound($aTxtBlacklistControls) - 1
			If BitAND(GUICtrlGetState($aTxtBlacklistControls[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($aTxtBlacklistControls[$i], $GUI_DISABLE)
		Next

		If BitAND(GUICtrlGetState($txtBlacklist), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($txtBlacklist, $GUI_DISABLE)
	Else
		GUICtrlSetBkColor($aLblBtnControls[$TroopType], $GUI_BKCOLOR_TRANSPARENT)

		For $i = 0 To UBound($aTxtDonateControls) - 1
			If BitAND(GUICtrlGetState($aTxtDonateControls[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtDonateControls[$i], $GUI_ENABLE)
		Next

		For $i = 0 To UBound($aTxtBlacklistControls) - 1
			If BitAND(GUICtrlGetState($aTxtBlacklistControls[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtBlacklistControls[$i], $GUI_ENABLE)
		Next

		If BitAND(GUICtrlGetState($txtBlacklist), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($txtBlacklist, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_DonateAllControls

Func _DonateControls($TroopType)
	For $i = 0 To UBound($aLblBtnControls) - 1
		If $i = $TroopType Then
			GUICtrlSetBkColor($aLblBtnControls[$i], $COLOR_GREEN)
		Else
			If GUICtrlGetBkColor($aLblBtnControls[$i]) = $COLOR_NAVY Then GUICtrlSetBkColor($aLblBtnControls[$i], $GUI_BKCOLOR_TRANSPARENT)
		EndIf
	Next

	For $i = 0 To UBound($aChkDonateAllControls) - 1
		GUICtrlSetState($aChkDonateAllControls[$i], $GUI_UNCHECKED)
	Next

	For $i = 0 To UBound($aTxtDonateControls) - 1
		If BitAND(GUICtrlGetState($aTxtDonateControls[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtDonateControls[$i], $GUI_ENABLE)
	Next

	For $i = 0 To UBound($aTxtBlacklistControls) - 1
		If BitAND(GUICtrlGetState($aTxtBlacklistControls[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtBlacklistControls[$i], $GUI_ENABLE)
	Next
EndFunc   ;==>_DonateControls

Func _DonateBtn($FirstControl, $LastControl)
	; Hide Controls
	If $LastDonateBtn1 = -1 Then
		For $i = $grpBarbarians To $txtBlacklistBarbarians ; 1st time use: Hide Barbarian controls
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	Else
		For $i = $LastDonateBtn1 To $LastDonateBtn2 ; Hide last used controls on Donate Tab
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf

	$LastDonateBtn1 = $FirstControl
	$LastDonateBtn2 = $LastControl

	;Show Controls
	For $i = $FirstControl To $LastControl ; Show these controls on Donate Tab
		GUICtrlSetState($i, $GUI_SHOW)
	Next
EndFunc   ;==>_DonateBtn

;---------------------------------------------------
;~ If FileExists($sProfilePath & "\profile.ini") Then
	_GUICtrlComboBox_SetCurSel($cmbProfile, Int($sCurrProfile) - 1)
;~ EndIf
If FileExists($config) Or FileExists($building) Then
	readConfig()
	applyConfig()
EndIf
GUIRegisterMsg($WM_COMMAND, "GUIControl")
GUIRegisterMsg($WM_SYSCOMMAND, "GUIControl")
;---------------------------------------------------
