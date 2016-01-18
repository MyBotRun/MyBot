; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), kaganus (August-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
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
Local $aChkDonateControlsSpell[3] = [$chkDonatePoisonSpells, $chkDonateEarthQuakeSpells, $chkDonateHasteSpells]
Local $aChkDonateAllControls[17] = [$chkDonateAllBarbarians, $chkDonateAllArchers, $chkDonateAllGiants, $chkDonateAllGoblins, $chkDonateAllWallBreakers, $chkDonateAllBalloons, $chkDonateAllWizards, $chkDonateAllHealers, $chkDonateAllDragons, $chkDonateAllPekkas, $chkDonateAllMinions, $chkDonateAllHogRiders, $chkDonateAllValkyries, $chkDonateAllGolems, $chkDonateAllWitches, $chkDonateAllLavaHounds, $chkDonateAllCustom]
Local $aChkDonateAllControlsSpell[3] = [$chkDonateAllPoisonSpells, $chkDonateAllEarthQuakeSpells, $chkDonateAllHasteSpells]
Local $aTxtDonateControls[17] = [$txtDonateBarbarians, $txtDonateArchers, $txtDonateGiants, $txtDonateGoblins, $txtDonateWallBreakers, $txtDonateBalloons, $txtDonateWizards, $txtDonateHealers, $txtDonateDragons, $txtDonatePekkas, $txtDonateMinions, $txtDonateHogRiders, $txtDonateValkyries, $txtDonateGolems, $txtDonateWitches, $txtDonateLavaHounds, $txtDonateCustom]
Local $aTxtDonateControlsSpell[3] = [$txtDonatePoisonSpells, $txtDonateEarthQuakeSpells, $txtDonateHasteSpells]
Local $aTxtBlacklistControls[17] = [$txtBlacklistBarbarians, $txtBlacklistArchers, $txtBlacklistGiants, $txtBlacklistGoblins, $txtBlacklistWallBreakers, $txtBlacklistBalloons, $txtBlacklistWizards, $txtBlacklistHealers, $txtBlacklistDragons, $txtBlacklistPekkas, $txtBlacklistMinions, $txtBlacklistHogRiders, $txtBlacklistValkyries, $txtBlacklistGolems, $txtBlacklistWitches, $txtBlacklistLavaHounds,  $txtBlacklistCustom]
Local $aTxtBlacklistControlsSpell[3] = [$txtBlacklistPoisonSpells, $txtBlacklistEarthQuakeSpells, $txtBlacklistHasteSpells]
Local $aLblBtnControls[17] = [$lblBtnBarbarians, $lblBtnArchers, $lblBtnGiants, $lblBtnGoblins, $lblBtnWallBreakers, $lblBtnBalloons, $lblBtnWizards, $lblBtnHealers, $lblBtnDragons, $lblBtnPekkas, $lblBtnMinions, $lblBtnHogRiders, $lblBtnValkyries, $lblBtnGolems, $lblBtnWitches, $lblBtnLavaHounds, $lblBtnCustom]
Local $aLblBtnControlsSpell[3] = [$lblBtnPoisonSpells, $lblBtnEarthQuakeSpells, $lblBtnHasteSpells]

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
#include "GUI\MBR GUI Control Tab AttackCSV.au3"
#include "GUI\MBR GUI Control Tab Advanced.au3"
#include "GUI\MBR GUI Control Tab EndBattle.au3"
#include "GUI\MBR GUI Control Tab Donate.au3"
#include "GUI\MBR GUI Control Tab Misc.au3"
#include "GUI\MBR GUI Control Tab Upgrade.au3"
#include "GUI\MBR GUI Control Tab Notify.au3"
#include "GUI\MBR GUI Control Tab Expert.au3"
#include "GUI\MBR GUI Control Tab Stats.au3"
#include "GUI\MBR GUI Control Collectors.au3"

; Accelerator Key, more responsive than buttons in run-mode
Local $aAccelKeys[1][2] = [["{ESC}", $btnStop]]
GUISetAccelerators($aAccelKeys)

Func GUIControl($hWind, $iMsg, $wParam, $lParam)
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0x0000FFFF)
	Local $hCtrl = $lParam
	#forceref $hWind, $iMsg, $wParam, $lParam
	;If $debugSetlog = 1 Then ConsoleWrite("GUIControl: $hWind=" & $hWind & ", $iMsg=" & $iMsg & ", $wParam=" & $wParam & ", $lParam=" & $lParam & ", $nNotifyCode=" & $nNotifyCode & ", $nID=" & $nID & ", $hCtrl=" & $hCtrl & ", $frmBot=" & $frmBot & @CRLF)

    ; WM_SYSCOMAND msdn: https://msdn.microsoft.com/en-us/library/windows/desktop/ms646360(v=vs.85).aspx

    Switch $iMsg
		Case $WM_NOTIFY ; 78
			Switch $nID
			    Case $tabMain
				    ; Handle RichText controls
					tabMain()
			EndSwitch
		Case $WM_COMMAND ; 273
			CheckRedrawBotWindow()
			Switch $nID
				Case $divider
					MoveDivider()
				Case $GUI_EVENT_CLOSE
					; Clean up resources
					BotClose()
				Case $labelMyBotURL
					ShellExecute("https://MyBot.run/forums") ;open web site when clicking label
				Case $labelForumURL
					ShellExecute("https://MyBot.run/forums/forumdisplay.php?fid=2") ;open web site when clicking label
				Case $btnStop
					btnStop()
				Case $btnPause
					btnPause()
				Case $btnResume
					btnResume()
				Case $btnHide
					btnHide()
				Case $btnResetStats
					btnResetStats()
				Case $btnAttackNowDB
					btnAttackNowDB()
				Case $btnAttackNowLB
					btnAttackNowLB()
				Case $btnAttackNowTS
					btnAttackNowTS()
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
	   Case $WM_SYSCOMMAND ; 274
			Switch $wParam
			    Case $SC_RESTORE ; 0xf120
				    ; set redraw controls flag that require addition redraw if visible
				    $bRedrawBotWindow[2] = True
			    Case $SC_CLOSE ; 0xf060
				    If Not $gui2open Then BotClose()
			EndSwitch
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl

Func BotClose()
   ; Clean up resources
   _GDIPlus_ImageDispose($hBitmap)
   _WinAPI_DeleteObject($hHBitmap)
   _GDIPlus_Shutdown()
   MBRFunc(False) ; close MBRFunctions dll
   _GUICtrlRichEdit_Destroy($txtLog)
   _GUICtrlRichEdit_Destroy($txtAtkLog)
   SaveConfig()
   Exit
EndFunc

Func SetRedrawBotWindow($bEnableRedraw, $bCheckRedrawBotWindow = True, $bForceRedraw = False)
    ; speed up GUI changes by disabling window redraw
	If $bRedrawBotWindow[0] = $bEnableRedraw Then
	   ; nothing to do
	   Return False
    EndIF
	; enable logging to debug GUI redraw
	;SetDebugLog(($bEnableRedraw ? "Enable" : "Disable") & " MyBot Window Redraw")
	_SendMessage($frmBot, $WM_SETREDRAW, $bEnableRedraw, 0)
	$bRedrawBotWindow[0] = $bEnableRedraw
	If $bEnableRedraw Then
	   If $bCheckRedrawBotWindow Then
		  CheckRedrawBotWindow($bForceRedraw)
	   EndIf
    Else
	  ; set dirty redraw flag
	  $bRedrawBotWindow[1] = True
    EndIf
    Return True
EndFunc

Func CheckRedrawBotWindow($bForceRedraw = False)
    ; check if bot window redraw is enabled and required
	If ($bRedrawBotWindow[0] And $bRedrawBotWindow[1]) Or $bForceRedraw Then
	   ; enable logging to debug GUI redraw
	   ;SetDebugLog("Redraw MyBot Window" & ($bForceRedraw ? " (forced)" : "")) ; enable logging to debug GUI redraw
	   ; Redraw bot window
	   _WinAPI_RedrawWindow($frmBot)
	   $bRedrawBotWindow[1] = False
	   $bRedrawBotWindow[2] = False
    Else
	   CheckRedrawControls()
    EndIF
EndFunc

Func CheckRedrawControls() ; ... that require additional redraw is executed like restore from minimized state
    If Not $bRedrawBotWindow[2] Then Return False
	If GUICtrlRead($tabMain, 1) = $tabGeneral Then
	   CheckRedrawBotWindow(True)
	   $bRedrawBotWindow[2] = False
	   Return True
    EndIf
	$bRedrawBotWindow[2] = False
	Return False
EndFunc

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

Func _DonateAllControlsSpell($TroopType, $Set)
	If $Set = True Then
		For $i = 0 To UBound($aLblBtnControlsSpell) - 1
			If $i = $TroopType Then
				GUICtrlSetBkColor($aLblBtnControlsSpell[$i], $COLOR_NAVY)
			Else
				GUICtrlSetBkColor($aLblBtnControlsSpell[$i], $GUI_BKCOLOR_TRANSPARENT)
			EndIf
		Next

		For $i = 0 To UBound($aChkDonateAllControlsSpell) - 1
			If $i <> $TroopType Then
				GUICtrlSetState($aChkDonateAllControlsSpell[$i], $GUI_UNCHECKED)
			EndIf
		Next

		For $i = 0 To UBound($aChkDonateControlsSpell) - 1
			GUICtrlSetState($aChkDonateControlsSpell[$i], $GUI_UNCHECKED)
		Next

		For $i = 0 To UBound($aTxtDonateControlsSpell) - 1
			If BitAND(GUICtrlGetState($aTxtDonateControlsSpell[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($aTxtDonateControlsSpell[$i], $GUI_DISABLE)
		Next

		For $i = 0 To UBound($aTxtBlacklistControlsSpell) - 1
			If BitAND(GUICtrlGetState($aTxtBlacklistControlsSpell[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($aTxtBlacklistControlsSpell[$i], $GUI_DISABLE)
		Next

		If BitAND(GUICtrlGetState($txtBlacklist), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($txtBlacklist, $GUI_DISABLE)
	Else
		GUICtrlSetBkColor($aLblBtnControlsSpell[$TroopType], $GUI_BKCOLOR_TRANSPARENT)

		For $i = 0 To UBound($aTxtDonateControlsSpell) - 1
			If BitAND(GUICtrlGetState($aTxtDonateControlsSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtDonateControlsSpell[$i], $GUI_ENABLE)
		Next

		For $i = 0 To UBound($aTxtBlacklistControlsSpell) - 1
			If BitAND(GUICtrlGetState($aTxtBlacklistControlsSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtBlacklistControlsSpell[$i], $GUI_ENABLE)
		Next

		If BitAND(GUICtrlGetState($txtBlacklist), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($txtBlacklist, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_DonateAllControlsSpell

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

Func _DonateControlsSpell($TroopType)
	For $i = 0 To UBound($aLblBtnControlsSpell) - 1
		If $i = $TroopType Then
			GUICtrlSetBkColor($aLblBtnControlsSpell[$i], $COLOR_GREEN)
		Else
			If GUICtrlGetBkColor($aLblBtnControlsSpell[$i]) = $COLOR_NAVY Then GUICtrlSetBkColor($aLblBtnControlsSpell[$i], $GUI_BKCOLOR_TRANSPARENT)
		EndIf
	Next

	For $i = 0 To UBound($aChkDonateAllControlsSpell) - 1
		GUICtrlSetState($aChkDonateAllControlsSpell[$i], $GUI_UNCHECKED)
	Next

	For $i = 0 To UBound($aTxtDonateControlsSpell) - 1
		If BitAND(GUICtrlGetState($aTxtDonateControlsSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtDonateControlsSpell[$i], $GUI_ENABLE)
	Next

	For $i = 0 To UBound($aTxtBlacklistControlsSpell) - 1
		If BitAND(GUICtrlGetState($aTxtBlacklistControlsSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($aTxtBlacklistControlsSpell[$i], $GUI_ENABLE)
	Next
EndFunc   ;==>_DonateControlsSpell

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
GUIRegisterMsg($WM_NOTIFY, "GUIControl")
;GUISetOnEvent($GUI_EVENT_RESTORE, "tabMain")

;---------------------------------------------------
