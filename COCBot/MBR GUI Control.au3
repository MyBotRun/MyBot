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
Opt("TrayOnEventMode", 1)

#include-once
#include "functions\Other\GUICtrlGetBkColor.au3" ; Included here to use on GUI Control
#include "MBR GUI Control Variables.au3"
#include "MBR GUI Action.au3"

; MBR Actions invoked in MyBot.run.au3
Global Enum $eBotNoAction, $eBotStart, $eBotStop, $eBotSearchMode
Global $BotAction = $eBotNoAction

;Dynamic declaration of Array controls, cannot be on global variables because the GUI has to be created first for these control-id's to be known.
Global $aChkDonateControls[21] = [$chkDonateBarbarians, $chkDonateArchers, $chkDonateGiants, $chkDonateGoblins, $chkDonateWallBreakers, $chkDonateBalloons, $chkDonateWizards, $chkDonateHealers, $chkDonateDragons, $chkDonatePekkas, $chkDonateBabyDragons, $chkDonateMiners, $chkDonateMinions, $chkDonateHogRiders, $chkDonateValkyries, $chkDonateGolems, $chkDonateWitches, $chkDonateLavaHounds, $chkDonateBowlers, $chkDonateCustomA, $chkDonateCustomB]
Global $aChkDonateControlsSpell[4] = [$chkDonatePoisonSpells, $chkDonateEarthQuakeSpells, $chkDonateHasteSpells, $chkDonateSkeletonSpells]
Global $aChkDonateAllControls[21] = [$chkDonateAllBarbarians, $chkDonateAllArchers, $chkDonateAllGiants, $chkDonateAllGoblins, $chkDonateAllWallBreakers, $chkDonateAllBalloons, $chkDonateAllWizards, $chkDonateAllHealers, $chkDonateAllDragons, $chkDonateAllPekkas,  $chkDonateAllBabyDragons,  $chkDonateAllMiners, $chkDonateAllMinions, $chkDonateAllHogRiders, $chkDonateAllValkyries, $chkDonateAllGolems, $chkDonateAllWitches, $chkDonateAllLavaHounds, $chkDonateAllBowlers, $chkDonateAllCustomA, $chkDonateAllCustomB]
Global $aChkDonateAllControlsSpell[4] = [$chkDonateAllPoisonSpells, $chkDonateAllEarthQuakeSpells, $chkDonateAllHasteSpells, $chkDonateAllSkeletonSpells]
Global $aTxtDonateControls[21] = [$txtDonateBarbarians, $txtDonateArchers, $txtDonateGiants, $txtDonateGoblins, $txtDonateWallBreakers, $txtDonateBalloons, $txtDonateWizards, $txtDonateHealers, $txtDonateDragons, $txtDonatePekkas, $txtDonateBabyDragons, $txtDonateMiners, $txtDonateMinions, $txtDonateHogRiders, $txtDonateValkyries, $txtDonateGolems, $txtDonateWitches, $txtDonateLavaHounds, $txtDonateBowlers, $txtDonateCustomA, $txtDonateCustomB]
Global $aTxtDonateControlsSpell[4] = [$txtDonatePoisonSpells, $txtDonateEarthQuakeSpells, $txtDonateHasteSpells, $txtDonateSkeletonSpells]
Global $aTxtBlacklistControls[21] = [$txtBlacklistBarbarians, $txtBlacklistArchers, $txtBlacklistGiants, $txtBlacklistGoblins, $txtBlacklistWallBreakers, $txtBlacklistBalloons, $txtBlacklistWizards, $txtBlacklistHealers, $txtBlacklistDragons, $txtBlacklistPekkas, $txtBlacklistBabyDragons, $txtBlacklistMiners, $txtBlacklistMinions, $txtBlacklistHogRiders, $txtBlacklistValkyries, $txtBlacklistGolems, $txtBlacklistWitches, $txtBlacklistLavaHounds, $txtBlacklistBowlers, $txtBlacklistCustomA, $txtBlacklistCustomB]
Global $aTxtBlacklistControlsSpell[4] = [$txtBlacklistPoisonSpells, $txtBlacklistEarthQuakeSpells, $txtBlacklistHasteSpells, $txtBlacklistSkeletonSpells]
Global $aLblBtnControls[21] = [$lblBtnBarbarians, $lblBtnArchers, $lblBtnGiants, $lblBtnGoblins, $lblBtnWallBreakers, $lblBtnBalloons, $lblBtnWizards, $lblBtnHealers, $lblBtnDragons, $lblBtnPekkas, $lblBtnBabyDragons, $lblBtnMiners, $lblBtnMinions, $lblBtnHogRiders, $lblBtnValkyries, $lblBtnGolems, $lblBtnWitches, $lblBtnLavaHounds, $lblBtnBowlers, $lblBtnCustomA, $lblBtnCustomB]
Global $aLblBtnControlsSpell[4] = [$lblBtnPoisonSpells, $lblBtnEarthQuakeSpells, $lblBtnHasteSpells, $lblBtnSkeletonSpells]

Global $aMainTabItems[7] = [$tabMain, $tabGeneral, $tabVillage, $tabAttack, $tabBot, $tabAboutUs]

Global $aTabControlsVillage[6] = [$hGUI_VILLAGE_TAB, $hGUI_VILLAGE_TAB_ITEM1, $hGUI_VILLAGE_TAB_ITEM2, $hGUI_VILLAGE_TAB_ITEM3, $hGUI_VILLAGE_TAB_ITEM4, $hGUI_VILLAGE_TAB_ITEM5]
Global $aTabControlsDonate[4] = [$hGUI_DONATE_TAB, $hGUI_DONATE_TAB_ITEM1, $hGUI_DONATE_TAB_ITEM2, $hGUI_DONATE_TAB_ITEM3]
Global $aTabControlsUpgrade[5] = [$hGUI_UPGRADE_TAB, $hGUI_UPGRADE_TAB_ITEM1, $hGUI_UPGRADE_TAB_ITEM2, $hGUI_UPGRADE_TAB_ITEM3, $hGUI_UPGRADE_TAB_ITEM4]
Global $aTabControlsNotify[3] = [$hGUI_NOTIFY_TAB, $hGUI_NOTIFY_TAB_ITEM2, $hGUI_NOTIFY_TAB_ITEM4]

Global $aTabControlsAttack[4] = [$hGUI_ATTACK_TAB, $hGUI_ATTACK_TAB_ITEM1, $hGUI_ATTACK_TAB_ITEM2, $hGUI_ATTACK_TAB_ITEM3]
Global $aTabControlsArmy[5] = [$hGUI_ARMY_TAB, $hGUI_ARMY_TAB_ITEM1, $hGUI_ARMY_TAB_ITEM2, $hGUI_ARMY_TAB_ITEM3, $hGUI_ARMY_TAB_ITEM4]
Global $aTabControlsSearch[6] = [$hGUI_SEARCH_TAB, $hGUI_SEARCH_TAB_ITEM1, $hGUI_SEARCH_TAB_ITEM2, $hGUI_SEARCH_TAB_ITEM3, $hGUI_SEARCH_TAB_ITEM4, $hGUI_SEARCH_TAB_ITEM5]
Global $aTabControlsDeadbase[5] = [$hGUI_DEADBASE_TAB, $hGUI_DEADBASE_TAB_ITEM1, $hGUI_DEADBASE_TAB_ITEM2, $hGUI_DEADBASE_TAB_ITEM3, $hGUI_DEADBASE_TAB_ITEM4]
Global $aTabControlsActivebase[4] = [$hGUI_ACTIVEBASE_TAB, $hGUI_ACTIVEBASE_TAB_ITEM1, $hGUI_ACTIVEBASE_TAB_ITEM2, $hGUI_ACTIVEBASE_TAB_ITEM3]
Global $aTabControlsTHSnipe[4] = [$hGUI_THSNIPE_TAB, $hGUI_THSNIPE_TAB_ITEM1, $hGUI_THSNIPE_TAB_ITEM2, $hGUI_THSNIPE_TAB_ITEM3]
Global $aTabControlsAttackOptions[5] = [$hGUI_AttackOption_TAB, $hGUI_AttackOption_TAB_ITEM1, $hGUI_AttackOption_TAB_ITEM2, $hGUI_AttackOption_TAB_ITEM3,  $hGUI_AttackOption_TAB_ITEM4]
Global $aTabControlsStrategies[3] = [$hGUI_STRATEGIES_TAB, $hGUI_STRATEGIES_TAB_ITEM1, $hGUI_STRATEGIES_TAB_ITEM2]

Global $aTabControlsBot[5] = [$hGUI_BOT_TAB, $hGUI_BOT_TAB_ITEM1, $hGUI_BOT_TAB_ITEM2, $hGUI_BOT_TAB_ITEM3, $hGUI_BOT_TAB_ITEM4]
Global $aTabControlsStats[4] = [$hGUI_STATS_TAB, $hGUI_STATS_TAB_ITEM1, $hGUI_STATS_TAB_ITEM2, $hGUI_STATS_TAB_ITEM3]

Global $aAlwaysEnabledControls[12] = [$chkUpdatingWhenMinimized, $chkHideWhenMinimized, $chkDebugClick, $chkDebugSetlog, $chkDebugOcr, $chkDebugImageSave, $chkdebugBuildingPos, $chkdebugTrain, $chkdebugOCRDonate,$btnTestTrain, $btnTestDonateCC, $btnTestAttackBar]

Func AcquireMutex($mutexName, $scope = Default, $timout = Default)
   Local $timer = TimerInit()
   Local $hMutex_MyBot = 0
   If $scope = Default then
	   $scope = @AutoItPID + "/"
   ElseIf $scope <> "" Then
	   $scope += "/"
   EndIf
   If $timout = Default Then $timeout = 30000
   While $hMutex_MyBot = 0 And ($timout = 0 Or TimerDiff($timer) < $timout)
	  $hMutex_MyBot = _Singleton("MyBot.run/" + $scope + $mutexName, 1)
	  If $hMutex_MyBot <> 0 Then ExitLoop
	  If $timout = 0 Then ExitLoop
	  If Sleep($iDelaySleep) Then ExitLoop
   WEnd
   Return $hMutex_MyBot
EndFunc   ;==>AcquireMutex

Func ReleaseMutex($hMutex, $ReturnValue = Default)
   _WinAPI_CloseHandle($hMutex)
   If $ReturnValue = Default Then Return
   Return $ReturnValue
EndFunc   ;==>ReleaseMutex

Func UpdateFrmBotStyle()
	#cs Works but causes bot window not to get activated anymore
	Local $ShowMinimize = $AndroidBackgroundLaunched = True Or $AndroidEmbedded = False Or ($AndroidEmbedded = True And $AndroidAdbScreencap = True And $ichkBackground = 1)
	WindowSystemMenu($frmBot, $SC_MINIMIZE, $ShowMinimize, "Minimize")
	Return
	#ce
	;Local $ShowMinimize = $AndroidBackgroundLaunched = True Or $AndroidEmbedded = False Or ($AndroidEmbedded = True And $AndroidAdbScreencap = True And $ichkBackground = 1)
	Local $ShowMinimize = $AndroidBackgroundLaunched = True Or $AndroidEmbedded = False Or ($AndroidEmbedded = True And $ichkBackground = 1) ; now bot is not really minimized anymore
	Local $lStyle = $WS_MINIMIZEBOX
	Local $lNewStyle = ($ShowMinimize ? $lStyle : 0)
	Local $lCurStyle = _WinAPI_GetWindowLong($frmBot, $GWL_STYLE)
	If BitAND($lCurStyle, $lStyle) <> $lNewStyle Then
		If $ShowMinimize Then
			$lNewStyle = BitOR($lCurStyle, $lStyle)
			SetDebugLog("Show Bot Minimize Button")
		Else
			$lNewStyle = BitAND($lCurStyle, BitNOT($lStyle))
			SetDebugLog("Hide Bot Minimize Button")
		EndIf
		_WinAPI_SetWindowLong($frmBot, $GWL_STYLE, $lNewStyle)
		Return True
	EndIf
	Return False
EndFunc   ;==>UpdateFrmBotStyle

Func IsTab($controlID)
	If _ArraySearch($aMainTabItems, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsVillage, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsDonate, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsUpgrade, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsNotify, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsAttack, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsArmy, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsSearch, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsDeadbase, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsActivebase, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsTHSnipe, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsAttackOptions, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsStrategies, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsBot, $controlID) <> -1 Or _
			_ArraySearch($aTabControlsStats, $controlID) <> -1 Then
		Return True
	EndIf
	Return False
EndFunc   ;==>IsTab

Func IsAlwaysEnabledControl($controlID)
	If _ArraySearch($aAlwaysEnabledControls, $controlID) <> -1 Then
		Return True
	EndIf
	Return False
EndFunc   ;==>IsAlwaysEnabledControl

_GDIPlus_Startup()

Global $Initiate = 0
Global $GUIControl_Disabled = False
Global $ichklanguageFirst = 0
Global $ichklanguage = 1

AtkLogHead()

;~ ------------------------------------------------------
;~ Control Tab Files
;~ ------------------------------------------------------
;~ #include "GUI\InitializeVariables.au3"
#include "GUI\MBR GUI Control Bottom.au3"
#include "GUI\MBR GUI Control Tab General.au3"
#include "GUI\MBR GUI Control Child Army.au3"
#include "GUI\MBR GUI Control Tab Village.au3"
#include "GUI\MBR GUI Control Tab Search.au3"
#include "GUI\MBR GUI Control Child Attack.au3"
#include "GUI\MBR GUI Control Tab EndBattle.au3"
#include "GUI\MBR GUI Control Tab Stats.au3"
#include "GUI\MBR GUI Control Collectors.au3"
#include "GUI\MBR GUI Control Milking.au3"
#include "GUI\MBR GUI Control Attack Standard.au3"
#include "GUI\MBR GUI Control Attack Scripted.au3"
#include "GUI\MBR GUI Control Achievements.au3"
#include "GUI\MBR GUI Control Notify.au3"
#include "GUI\MBR GUI Control Child Upgrade.au3"
#include "GUI\MBR GUI Control Donate.au3"
#include "GUI\MBR GUI Control Bot Options.au3"
#include "GUI\MBR GUI Control Preset.au3"
#include "GUI\MBR GUI Control Child Misc.au3"

; Accelerator Key, more responsive than buttons in run-mode
Local $aAccelKeys[1][2] = [["{ESC}", $btnStop]]
;GUISetAccelerators($aAccelKeys)

Func GUIControl_WM_NCACTIVATE($hWin, $iMsg, $wParam, $lParam)
	If $debugWindowMessages Then SetDebugLog("GUIControl_WM_NCACTIVATE: $hWin=" & $hWin & ", $iMsg=" & Hex($iMsg, 8) & ", $wParam=" & $wParam & ", $lParam=" & $lParam, Default, True)
	Local $iActive = BitAND($wParam, 0x0000FFFF)
	If $hWin = $frmBot Then
		If $AndroidEmbedded And AndroidShieldActiveDelay() = False Then
			If $iActive = 0 Then
				AndroidShield("GUIControl_WM_NCACTIVATE not active", Default, False, 0, False, False)
			Else
				AndroidShield("GUIControl_WM_NCACTIVATE active", Default, False)
			EndIf
		EndIf
		If $iActive = 0 Then
			; bot deactivated
			;SetDebugLog("WM_ACTIVATE: Deactivate Bot", Default, True)
		Else
			If $iHideWhenMinimized = 0 Then BotRestore("GUIControl_WM_NCACTIVATE")
			;SetDebugLog("WM_ACTIVATE: Activate Bot", Default, True)
		EndIf
	EndIf
    Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_NCACTIVATE

Func GUIControl_WM_FOCUS($hWin, $iMsg, $wParam, $lParam)
	If $debugWindowMessages Then SetDebugLog("GUIControl_WM_FOCUS: $hWin=" & $hWin & ", $iMsg=" & Hex($iMsg, 8) & ", $wParam=" & $wParam & ", $lParam=" & $lParam, Default, True)
	Local $iActive = BitAND($wParam, 0x0000FFFF)
	Switch $hWin
		Case $frmBot
			If $AndroidEmbedded And AndroidShieldActiveDelay() = False Then
				AndroidShield("GUIControl_WM_FOCUS", Default, False)
			EndIf
		#cs
		Case $frmBotEmbeddedShield
			If $lParam = $frmBotEmbeddedShieldInput Then
				Local $hInput = GUICtrlGetHandle($frmBotEmbeddedShieldInput)
				If _WinAPI_GetFocus() <> $hInput Then
					;_SendMessage($frmBotEmbeddedShield, $WM_SETFOCUS, 1, $frmBotEmbeddedShieldInput)
					;_WinAPI_SetFocus($hInput)
				EndIf
			EndIf
		#ce
	EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_NCACTIVATE

Func GUIControl_WM_MOUSE($hWin, $iMsg, $wParam, $lParam)
    If $hWin <> $frmBotEmbeddedShield Or $AndroidEmbedded = False Or $AndroidShieldStatus[0] = True Then
        Return $GUI_RUNDEFMSG
    EndIf
	;ConsoleWrite("GUIControl_WM_MOUSE: FORWARD $hWind=" & $hWin & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam & @CRLF)
	Local $hCtrlTarget = $AndroidEmbeddedCtrlTarget[0]
	Local $Result = _WinAPI_PostMessage($hCtrlTarget, $iMsg, $wParam, $lParam)
	;Local $Result = _SendMessage($hCtrlTarget, $iMsg, $wParam, $lParam)

	If $iMSG = $WM_LBUTTONDOWN Then
		If $debugWindowMessages Then SetDebugLog("GUIControl_WM_MOUSE: WM_LBUTTONDOWN $hWind=" & $hWin & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
		If AndroidShieldHasFocus() = False Then
			Local $hInput = GUICtrlGetHandle($frmBotEmbeddedShieldInput)
			_WinAPI_SetFocus($hInput)
			AndroidShield("GUIControl_WM_MOUSE", Default, False, 0, True)
		EndIf
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc

Func GUIControl_WM_COMMAND($hWind, $iMsg, $wParam, $lParam)
	If $debugWindowMessages Then SetDebugLog("GUIControl_WM_COMMAND: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
	;#forceref $hWind, $iMsg, $wParam, $lParam
	If $GUIControl_Disabled = True Then Return $GUI_RUNDEFMSG
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0x0000FFFF)
	Local $hCtrl = $lParam
	;If $__TEST_ERROR = True Then ConsoleWrite("GUIControl: $hWind=" & $hWind & ", $iMsg=" & $iMsg & ", $wParam=" & $wParam & ", $lParam=" & $lParam & ", $nNotifyCode=" & $nNotifyCode & ", $nID=" & $nID & ", $hCtrl=" & $hCtrl & ", $frmBot=" & $frmBot & @CRLF)

	; check shield status
	If $hWind <> $frmBotEmbeddedShield Then
		If AndroidShieldHasFocus() = True Then
			; update shield with inactive state
			AndroidShield("GUIControl_WM_COMMAND", Default, False, 150, False)
		EndIf
	EndIf

	; WM_SYSCOMAND msdn: https://msdn.microsoft.com/en-us/library/windows/desktop/ms646360(v=vs.85).aspx
	CheckRedrawBotWindow()
	Switch $nID
		Case $divider
			MoveDivider()
		Case $GUI_EVENT_CLOSE
			; Clean up resources
			BotClose()
		Case $lblCreditsBckGrnd, $lblUnbreakableHelp
			; Handle open URL clicks when label of link is over another background label
			Local $CursorInfo = GUIGetCursorInfo($frmBot)
			If IsArray($CursorInfo) = 1 Then
				Switch $CursorInfo[4]
					Case $labelMyBotURL, $labelForumURL, $lblUnbreakableLink
						OpenURL_Label($CursorInfo[4])
				EndSwitch
			EndIf
		Case $labelMyBotURL, $labelForumURL, $lblUnbreakableLink
			; Handle open URL when label fires the event normally
			OpenURL_Label($nID)
		Case $lblDonate
			; Donate URL is not in text nor tooltip
			ShellExecute("https://mybot.run/forums/index.php?/donate/make-donation/")
		Case $btnStop
			btnStop()
		Case $btnPause
			btnPause()
		Case $btnResume
			btnResume()
		Case $btnHide
			btnHide()
		Case $btnEmbed
			btnEmbed()
		Case $btnResetStats
			btnResetStats()
		Case $btnAttackNowDB
			btnAttackNowDB()
		Case $btnAttackNowLB
			btnAttackNowLB()
		Case $btnAttackNowTS
			btnAttackNowTS()
		;Case $idMENU_DONATE_SUPPORT
		;	ShellExecute("https://mybot.run/forums/index.php?/donate/make-donation/")
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
			btnVillageStat()
		Case $arrowleft, $arrowright
			btnVillageStat()

		; debug checkboxes and buttons
		Case $chkDebugClick
			chkDebugClick()
		Case $chkDebugSetlog
			chkDebugSetlog()
		Case $chkDebugOcr
			chkDebugOcr()
		Case $chkDebugImageSave
			chkDebugImageSave()
		Case $chkdebugBuildingPos
			chkDebugBuildingPos()
		Case $chkDebugTrain
			chkDebugTrain()
		Case $chkdebugOCRDonate
			chkdebugOCRDonate()
		Case $btnTestTrain
			btnTestTrain()
		Case $btnTestDonateCC
			btnTestDonateCC()
		Case $btnTestAttackBar
			btnTestAttackBar()
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl

Func GUIControl_WM_MOVE($hWind, $iMsg, $wParam, $lParam)
	If $debugWindowMessages Then SetDebugLog("GUIControl_WM_MOVE: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
	If $hWind = $frmBot Then
		If $iUpdatingWhenMinimized = 1 And BotWindowCheck() = False And _WinAPI_IsIconic($frmBot) Then
			; ensure bot is not really minimized (e.g. when you minimize all windows)
			BotMinimize("GUIControl_WM_MOVE")
			Return $GUI_RUNDEFMSG
		EndIf

		; update bot pos variables
		Local $frmBotPos = WinGetPos($frmBot)
		If $AndroidEmbedded = False Then
			$frmBotPosX = ($frmBotPos[0] > -30000 ? $frmBotPos[0] : $frmBotPosX)
			$frmBotPosY = ($frmBotPos[1] > -30000 ? $frmBotPos[1] : $frmBotPosY)
		Else
			$frmBotDockedPosX = ($frmBotPos[0] > -30000 ? $frmBotPos[0] : $frmBotDockedPosX)
			$frmBotDockedPosY = ($frmBotPos[1] > -30000 ? $frmBotPos[1] : $frmBotDockedPosY)
		EndIf
	EndIf

	; required for screen change
	If AndroidEmbedArrangeActive() = False And AndroidEmbedCheck(True) = True Then
		; reposition docked android
		AndroidEmbedCheck()
		; redraw bot also
		_WinAPI_RedrawWindow($frmBotEx, 0, 0, $RDW_INVALIDATE)
		_WinAPI_RedrawWindow($frmBotBottom, 0, 0, $RDW_INVALIDATE)
	EndIf

	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_MOVE

Func GUIControl_WM_SYSCOMMAND($hWind, $iMsg, $wParam, $lParam)
	If $debugWindowMessages Then SetDebugLog("GUIControl_WM_SYSCOMMAND: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
	;If $__TEST_ERROR = True Then SetDebugLog("Bot WM_SYSCOMMAND: " & Hex($wParam, 4))
	If $hWind = $frmBot Then ; Only close Bot when Bot Window sends Close Message
		Switch $wParam
			Case $SC_MINIMIZE
				BotMinimize("GUIControl_WM_SYSCOMMAND")
			Case $SC_RESTORE ; 0xf120
				; set redraw controls flag to check if after restore visibile controls require redraw
				BotRestore("GUIControl_WM_SYSCOMMAND")
			Case $SC_CLOSE ; 0xf060
				BotClose()
		EndSwitch
	EndIf
    Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_SYSCOMMAND

Func GUIControl_WM_NOTIFY($hWind, $iMsg, $wParam, $lParam)
	If $debugWindowMessages Then SetDebugLog("GUIControl_WM_NOTIFY: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0x0000FFFF)
	Local $hCtrl = $lParam

	;If $__TEST_ERROR = True Then ConsoleWrite("GUIControl: $hWind=" & $hWind & ", $iMsg=" & $iMsg & ", $wParam=" & $wParam & ", $lParam=" & $lParam & ", $nNotifyCode=" & $nNotifyCode & ", $nID=" & $nID & ", $hCtrl=" & $hCtrl & ", $frmBot=" & $frmBot & @CRLF)
	;GUIControl_WM_NOTIFY: $hWind=0x0055A084,$iMsg=78,$wParam=0x00000008,$lParam=0x0108BB30
	; WM_SYSCOMAND msdn: https://msdn.microsoft.com/en-us/library/windows/desktop/ms646360(v=vs.85).aspx

	Local $bCheckEmbeddedShield = True

	Switch $nID
		Case $tabMain
			; Handle RichText controls
			tabMain()
		Case $hGUI_VILLAGE_TAB
			tabVillage()
		Case $hGUI_ATTACK_TAB
			tabAttack()
		Case $hGUI_SEARCH_TAB
			tabSEARCH()
		Case $hGUI_DEADBASE_TAB
			tabDeadbase()
		Case $hGUI_ACTIVEBASE_TAB
			tabActivebase()
		Case $hGUI_THSNIPE_TAB
			tabTHSnipe()
		Case $hGUI_BOT_TAB
			tabBot()
		Case Else
			$bCheckEmbeddedShield = False
	EndSwitch

	If $bCheckEmbeddedShield Then
		; check shield status
		If $hWind <> $frmBotEmbeddedShield Then
			If AndroidShieldHasFocus() = True Then
				; update shield with inactive state
				AndroidShield("GUIControl_WM_NOTIFY", Default, False, 150, False)
			EndIf
		EndIf
	EndIf

	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_NOTIFY

Func GUIEvents()
	;@GUI_WinHandle
	Local $GUI_CtrlId = @GUI_CtrlId
	If $FrmBotMinimized And $GUI_CtrlId = $GUI_EVENT_MINIMIZE Then
		; restore
		If $debugWindowMessages Then SetDebugLog("$GUI_EVENT_MINIMIZE changed to $GUI_EVENT_RESTORE", Default, True)
		$GUI_CtrlId = $GUI_EVENT_RESTORE
	EndIf
    Switch $GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			If $debugWindowMessages Then SetDebugLog("$GUI_EVENT_CLOSE", Default, True)
			BotClose()

        Case $GUI_EVENT_MINIMIZE
			If $debugWindowMessages Then SetDebugLog("$GUI_EVENT_MINIMIZE", Default, True)
			BotMinimize("GUIEvents")
			;Return 0

        Case $GUI_EVENT_RESTORE
			If $debugWindowMessages Then SetDebugLog("$GUI_EVENT_RESTORE", Default, True)
			BotRestore("GUIEvents")

		Case Else
			If $debugWindowMessages Then SetDebugLog("$GUI_EVENT: " & @GUI_CtrlId, Default, True)
    EndSwitch
EndFunc   ;==>SpecialEvents

; Open URL in default browser using ShellExecute
; URL is retrieved from label text or an existing ToolTip Control
Func OpenURL_Label($LabelCtrlID)
	Local $url = GUICtrlRead($LabelCtrlID)
	If StringInStr($url, "http") <> 1 Then
		$url = _GUIToolTip_GetText($hToolTip, 0, GUICtrlGetHandle($LabelCtrlID))
	EndIf
	If StringInStr($url, "http") = 1 Then
		SetDebugLog("Open URL: " & $url)
		ShellExecute($url) ;open web site when clicking label
	Else
		SetDebugLog("Cannot open URL for Control ID " & $LabelCtrlID, $COLOR_RED)
	EndIf
EndFunc   ;==>OpenURL_Label

Func BotClose($SaveConfig = Default, $bExit = True)
   If $SaveConfig = Default Then $SaveConfig = $iBotLaunchTime > 0
   ResumeAndroid()
   SetLog("Closing " & $sBotTitle & " ...")
   AndroidEmbed(False) ; detach Android Window
   AndroidShieldDestroy() ; destroy Shield Hooks
   If $RunState = True Then AndroidBotStopEvent() ; signal android that bot is now stoppting
   If $SaveConfig = True Then
      setupProfile()
      SaveConfig()
   EndIf
   AndroidAdbTerminateShellInstance()
   ; Close Mutexes
   If $hMutex_BotTitle <> 0 Then _WinAPI_CloseHandle($hMutex_BotTitle)
   If $hMutex_Profile <> 0 Then _WinAPI_CloseHandle($hMutex_Profile)
   If $hMutex_MyBot <> 0 Then _WinAPI_CloseHandle($hMutex_MyBot)
   ; Clean up resources
   _GDIPlus_ImageDispose($hBitmap)
   _WinAPI_DeleteObject($hHBitmap)
	_WinAPI_DeleteObject($hHBitmap2)
   _GDIPlus_Shutdown()
   MBRFunc(False) ; close MBRFunctions dll
   _GUICtrlRichEdit_Destroy($txtLog)
   _GUICtrlRichEdit_Destroy($txtAtkLog)
   DllCall("comctl32.dll", "int", "ImageList_Destroy", "hwnd", $hImageList)
   If $HWnD <> 0 Then ControlFocus($HWnD, "", $HWnD) ; show bot in taskbar again
   GUIDelete($frmBot)
   If $bExit = True Then Exit
EndFunc   ;==>BotClose

Func BotMinimize($sCaller, $iForceUpdatingWhenMinimized = False)
	Local $hMutex = AcquireMutex("MinimizeRestore")
	SetDebugLog("Minimize bot window, caller: " & $sCaller, Default, True)
	$FrmBotMinimized = True
	If $iUpdatingWhenMinimized = 1 Or $iForceUpdatingWhenMinimized = True Then
		If $iHideWhenMinimized = 1 Then
			WinMove2($frmBot, "", -32000, -32000, -1, -1, 0, $SWP_HIDEWINDOW, False)
			_WinAPI_SetWindowLong($frmBot, $GWL_EXSTYLE, BitOR(_WinAPI_GetWindowLong($frmBot, $GWL_EXSTYLE), $WS_EX_TOOLWINDOW))
		EndIf
		If _WinAPI_IsIconic($frmBot) Then WinSetState($frmBot, "", @SW_RESTORE)
		WinMove2($frmBot, "", -32000, -32000, -1, -1, 0, $SWP_SHOWWINDOW, False)
	Else
		If $iHideWhenMinimized = 1 Then
			WinMove2($frmBot, "", -1, -1, -1, -1, 0, $SWP_HIDEWINDOW, False)
			_WinAPI_SetWindowLong($frmBot, $GWL_EXSTYLE, BitOR(_WinAPI_GetWindowLong($frmBot, $GWL_EXSTYLE), $WS_EX_TOOLWINDOW))
		EndIf
		WinSetState($frmBot, "", @SW_MINIMIZE)
	EndIf
	ReleaseMutex($hMutex)
EndFunc   ;==BotMinimize

Func BotRestore($sCaller)
	Local $hMutex = AcquireMutex("MinimizeRestore")
	$FrmBotMinimized = False
	Local $botPosX = ($AndroidEmbedded = False ? $frmBotPosX : $frmBotDockedPosX)
	Local $botPosY = ($AndroidEmbedded = False ? $frmBotPosY : $frmBotDockedPosY)
	SetDebugLog("Restore bot window to " & $botPosX & ", " & $botPosY & ", caller: " & $sCaller, Default, True)
	Local $iExStyle = _WinAPI_GetWindowLong($frmBot, $GWL_EXSTYLE)
	If BitAND($iExStyle, $WS_EX_TOOLWINDOW) Then
		WinMove2($frmBot, "", -1, -1, -1, -1, 0, $SWP_HIDEWINDOW, False)
		_WinAPI_SetWindowLong($frmBot, $GWL_EXSTYLE, BitAND($iExStyle, BitNOT($WS_EX_TOOLWINDOW)))
	EndIf
	If _WinAPI_IsIconic($frmBot) Then WinSetState($frmBot, "", @SW_RESTORE)
	WinMove2($frmBot, "", $botPosX, $botPosY, -1, -1, $HWND_TOP, $SWP_SHOWWINDOW)
	_WinAPI_SetActiveWindow($frmBot)
	_WinAPI_SetFocus($frmBot)
	ReleaseMutex($hMutex)
EndFunc   ;==BotRestore

; Ensure bot window state (fix minimize not working sometimes)
Func BotWindowCheck()
	If $FrmBotMinimized Then
		Local $aPos = WinGetPos($frmBot)
		If IsArray($aPos) And $aPos[0] > -30000 Or $aPos[0] > -30000 Then
			BotMinimize("BotWindowCheck")
			Return True
		EndIf
	EndIf
	Return False
EndFunc

;---------------------------------------------------
; Tray Item Functions
;---------------------------------------------------
Func tiShow()
	BotRestore("tiShow")
EndFunc   ;==>tiShow

Func tiHide()
	$iHideWhenMinimized = ($iHideWhenMinimized = 1 ? 0 : 1)
	TrayItemSetState($tiHide, ($iHideWhenMinimized = 1 ? $TRAY_CHECKED : $TRAY_UNCHECKED))
	GUICtrlSetState($chkHideWhenMinimized, ($iHideWhenMinimized = 1 ? $GUI_CHECKED : $GUI_UNCHECKED))
	If $FrmBotMinimized = True Then
		If $iHideWhenMinimized = 0 Then
			BotRestore("tiHide")
		Else
			BotMinimize("tiHide")
		EndIf
	EndIf
EndFunc   ;==>tiHide

Func tiAbout()
	Local $sMsg = "Clash of Clans Bot" & @CRLF & @CRLF & _
		"Version: " & $sBotVersion & @CRLF & _
		"Released under the GNU GPLv3 license." & @CRLF & _
		"Visit www.MyBot.run"
	MsgBox(64 + $MB_APPLMODAL + $MB_TOPMOST, $sBotTitle, $sMsg, 0, $frmBot)
EndFunc   ;==>tiAbout

Func tiDonate()
	ShellExecute("https://mybot.run/forums/index.php?/donate/make-donation/")
EndFunc   ;==>tiDonate

Func tiExit()
	BotClose()
EndFunc   ;==>tiExit

; #FUNCTION# ====================================================================================================================
; Name ..........: SetRedrawBotWindow
; Description ...: Enables and disables bot window automatic redraw on GUI changes
; Syntax ........:
; Parameters ....: $bEnableRedraw : Boolean enables/disables
;                  $bCheckRedrawBotWindow : Boolean to check when redraw gets enabled if bot window needs to be redrawn
;                  $bForceRedraw : Boolean to always redraw bot window when redraw is enabled again
; Return values .: Boolean of former redraw state
; Author ........: Cosote (2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Local $bWasRedraw = SetRedrawBotWindow(False)
;                  [...]
;                  SetRedrawBotWindow($bWasRedraw)
; ===============================================================================================================================
Func SetRedrawBotWindow($bEnableRedraw, $bCheckRedrawBotWindow = True, $bForceRedraw = False, $RedrawControlIDs = Default)
	If $RedrawBotWindowMode = 0 Then Return False ; disabled
	If $RedrawBotWindowMode = 1 Then $RedrawControlIDs = Default ; always redraw entire bot window
	; speed up GUI changes by disabling window redraw
	Local $bWasRedraw = $bRedrawBotWindow[0]
	If $bRedrawBotWindow[0] = $bEnableRedraw Then
		; nothing to do
		Return $bWasRedraw
	EndIf
	; enable logging to debug GUI redraw
	;SetDebugLog(($bEnableRedraw ? "Enable" : "Disable") & " MyBot Window Redraw")
	_SendMessage($frmBotEx, $WM_SETREDRAW, $bEnableRedraw, 0)
	$bRedrawBotWindow[0] = $bEnableRedraw
	If $bEnableRedraw Then
		If $bCheckRedrawBotWindow Then
			CheckRedrawBotWindow($bForceRedraw, $RedrawControlIDs)
		EndIf
	Else
		; set dirty redraw flag
		$bRedrawBotWindow[1] = True
	EndIf
	Return $bWasRedraw
EndFunc   ;==>SetRedrawBotWindow


Func SetRedrawBotWindowControls($bEnableRedraw, $RedrawControlIDs)
	Return SetRedrawBotWindow($bEnableRedraw, True, False, $RedrawControlIDs)
EndFunc   ;==>SetRedrawBotWindowControls

Func CheckRedrawBotWindow($bForceRedraw = False, $RedrawControlIDs = Default)
	If $RedrawBotWindowMode = 0 Then Return False ; disabled
	If $RedrawBotWindowMode = 1 Then $RedrawControlIDs = Default ; always redraw entire bot window
	; check if bot window redraw is enabled and required
	If Not $bRedrawBotWindow[0] Then Return False
	If $bRedrawBotWindow[1] Or $bForceRedraw Then
		; enable logging to debug GUI redraw
		$bRedrawBotWindow[1] = False
		$bRedrawBotWindow[2] = False
		; Redraw bot window
		If $RedrawControlIDs = Default Then
			; redraw entire window
			SetDebugLog("Redraw MyBot Window" & ($bForceRedraw ? " (forced)" : "")) ; enable logging to debug GUI redraw
			_WinAPI_RedrawWindow($frmBotEx, 0, 0, $RDW_INVALIDATE)
		Else
			; redraw only specified control(s)
			If IsArray($RedrawControlIDs) Then
				SetDebugLog("Redraw MyBot ControlIds" & ($bForceRedraw ? " (forced)" : "") & ": " & _ArrayToString($RedrawControlIDs, ", "))
				Local $c
				For $c in $RedrawControlIDs
					If ControlRedraw($frmBotEx, $c) = 0 Then
						_WinAPI_RedrawWindow($frmBotEx, 0, 0, $RDW_INVALIDATE)
						ExitLoop
					EndIf
				Next
			Else
				SetDebugLog("Redraw MyBot ControlId" & ($bForceRedraw ? " (forced)" : "") & ": " & $RedrawControlIDs)
				If ControlRedraw($frmBotEx, $RedrawControlIDs) = 0 Then
					_WinAPI_RedrawWindow($frmBotEx, 0, 0, $RDW_INVALIDATE)
				EndIf
			EndIf
		EndIf
		_WinAPI_UpdateWindow($frmBotEx)
		; check if android need redraw as well
		Return True
	Else
		Return CheckRedrawControls()
	EndIf
	Return False
EndFunc   ;==>CheckRedrawBotWindow

Func CheckRedrawControls($ForceCheck = False) ; ... that require additional redraw is executed like restore from minimized state
	If $RedrawBotWindowMode = 0 Then Return False ; disabled
	If Not $bRedrawBotWindow[2] And Not $ForceCheck Then Return False
	If GUICtrlRead($tabMain, 1) = $tabGeneral Then
		Local $a = [$txtLog, $txtAtkLog]
		Return CheckRedrawBotWindow(True, $a)
	EndIf
	$bRedrawBotWindow[2] = False
	Return False
EndFunc   ;==>CheckRedrawControls

; Just redraw the bot window with using any dedicated global variables... Use it only in special cases!
Func RedrawBotWindowNow()
	_WinAPI_RedrawWindow($frmBot, 0, 0, $RDW_INVALIDATE)
	_WinAPI_UpdateWindow($frmBot)
EndFunc   ;==>RedrawBotWindowNow

; Redraw only specified control
Func ControlRedraw($hWin, $ConrolId)
	Local $a = ControlGetPos($hWin, "", $ConrolId)
	If IsArray($a) = 0 Then
		SetDebugLog("ControlRedraw: Invalid ControlId: " & $ConrolId)
		Return 0
	EndIf
	SetDebugLog("Control ID " & $ConrolId & " Pos: " & $a[0] & ", " & $a[1] & ", " & $a[2] & ", " & $a[3], Default, True)
	Local $left = $a[0]
	Local $top = $a[1]
	Local $width = $a[2]
	Local $height = $a[3]
	Local $hCtrl = (IsHWnd($ConrolId) ? $ConrolId : GUICtrlGetHandle($ConrolId))
	Local $hWinParent = _WinAPI_GetParent($hCtrl)
	If $hWinParent <> $frmBot Then
		; compensate parent
		$a = ControlGetPos($hWin, "", $hWinParent)
		If IsArray($a) Then
			;SetDebugLog("Control ID " & $ConrolId & " Parent (" & $hWinParent & ") Pos: " & $a[0] & ", " & $a[1] & ", " & $a[2] & ", " & $a[3], Default, True)
			$left -= $a[0]
			$top -= $a[1]
		EndIf
	EndIf
	Local $tRECT = DllStructCreate($tagRECT)
	Local $groupBorder = 0
	DllStructSetData($tRECT, "Left", $left + $groupBorder)
	DllStructSetData($tRECT, "Top", $top + $groupBorder)
	DllStructSetData($tRECT, "Right", $left + $width - $groupBorder)
	DllStructSetData($tRECT, "Bottom", $top + $height - $groupBorder)
	_WinAPI_RedrawWindow($frmBotEx, $tRECT, 0, $RDW_INVALIDATE)
	Return 1
EndFunc   ;==>ControlRedraw

Func SetTime()
	Local $time = _TicksToTime(Int(TimerDiff($sTimer) + $iTimePassed), $hour, $min, $sec)
	If GUICtrlRead($hGUI_STATS_TAB, 1) = $hGUI_STATS_TAB_ITEM2 Then GUICtrlSetData($lblresultruntime, StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
	If GUICtrlGetState($lblResultGoldNow) <> $GUI_ENABLE + $GUI_SHOW Then GUICtrlSetData($lblResultRuntimeNow, StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
	;If $pEnabled = 1 And $pRemote = 1 And StringFormat("%02i", $sec) = "50" Then _RemoteControl()
	;If $pEnabled = 1 And $ichkDeleteOldPBPushes = 1 And Mod($min + 1, 30) = 0 And $sec = "0" Then _DeleteOldPushes() ; check every 30 min if must to delete old pushbullet messages, increase delay time for anti ban pushbullet
EndFunc   ;==>SetTime

Func tabMain()
	$tabidx = GUICtrlRead($tabMain)
		Select
			Case $tabidx = 0 ; Log
				GUISetState(@SW_HIDE, $hGUI_VILLAGE)
				GUISetState(@SW_HIDE, $hGUI_ATTACK)
				GUISetState(@SW_HIDE, $hGUI_BOT)
				GUISetState(@SW_SHOWNOACTIVATE, $hGUI_LOG)

			Case $tabidx = 1 ; Village
				GUISetState(@SW_HIDE, $hGUI_LOG)
				GUISetState(@SW_HIDE, $hGUI_ATTACK)
				GUISetState(@SW_HIDE, $hGUI_BOT)
				GUISetState(@SW_SHOWNOACTIVATE, $hGUI_VILLAGE)
				tabVillage()

			Case $tabidx = 2 ; Attack
				GUISetState(@SW_HIDE, $hGUI_LOG)
				GUISetState(@SW_HIDE, $hGUI_VILLAGE)
				GUISetState(@SW_HIDE, $hGUI_BOT)
				GUISetState(@SW_SHOWNOACTIVATE, $hGUI_ATTACK)
				tabAttack()

			Case $tabidx = 3 ; Options
				GUISetState(@SW_HIDE, $hGUI_LOG)
				GUISetState(@SW_HIDE, $hGUI_VILLAGE)
				GUISetState(@SW_HIDE, $hGUI_ATTACK)
				GUISetState(@SW_SHOWNOACTIVATE, $hGUI_BOT)
				tabBot()
			Case ELSE
				GUISetState(@SW_HIDE, $hGUI_LOG)
				GUISetState(@SW_HIDE, $hGUI_VILLAGE)
				GUISetState(@SW_HIDE, $hGUI_ATTACK)
				GUISetState(@SW_HIDE, $hGUI_BOT)
		EndSelect

EndFunc   ;==>tabMain

Func tabVillage()
	$tabidx = GUICtrlRead($hGUI_VILLAGE_TAB)
		Select
			Case $tabidx = 1 ; Donate tab
				GUISetState(@SW_HIDE, $hGUI_UPGRADE)
				GUISetState(@SW_SHOWNOACTIVATE, $hGUI_DONATE)
				GUISetState(@SW_HIDE, $hGUI_NOTIFY)
			Case $tabidx = 2 ; NOTIFY tab
				GUISetState(@SW_HIDE, $hGUI_DONATE)
				GUISetState(@SW_SHOWNOACTIVATE, $hGUI_UPGRADE)
				GUISetState(@SW_HIDE, $hGUI_NOTIFY)
			Case $tabidx = 4 ; Upgrade tab
				GUISetState(@SW_HIDE, $hGUI_DONATE)
				GUISetState(@SW_HIDE, $hGUI_UPGRADE)
				GUISetState(@SW_SHOWNOACTIVATE, $hGUI_NOTIFY)
			Case ELSE
				GUISetState(@SW_HIDE, $hGUI_DONATE)
				GUISetState(@SW_HIDE, $hGUI_UPGRADE)
				GUISetState(@SW_HIDE, $hGUI_NOTIFY)
		EndSelect

EndFunc   ;==>tabVillage

Func tabAttack()
		$tabidx = GUICtrlRead($hGUI_ATTACK_TAB)
		Select
			Case $tabidx = 0 ; ARMY tab
				GUISetState(@SW_HIDE, $hGUI_STRATEGIES)
				GUISetState(@SW_SHOWNOACTIVATE, $hGUI_ARMY)
				GUISetState(@SW_HIDE, $hGUI_SEARCH)
			Case $tabidx = 1 ; SEARCH tab
				GUISetState(@SW_HIDE, $hGUI_STRATEGIES)
				GUISetState(@SW_HIDE, $hGUI_ARMY)
				GUISetState(@SW_SHOWNOACTIVATE, $hGUI_SEARCH)
				tabSEARCH()
			Case $tabidx = 2 ; STRATEGIES tab
				GUISetState(@SW_SHOWNOACTIVATE, $hGUI_STRATEGIES)
				GUISetState(@SW_HIDE, $hGUI_ARMY)
				GUISetState(@SW_HIDE, $hGUI_SEARCH)
			EndSelect

EndFunc   ;==>tabAttack

Func tabSEARCH()
		$tabidx = GUICtrlRead($hGUI_SEARCH_TAB)
		$tabdbx = _GUICtrlTab_GetItemRect($hGUI_SEARCH_TAB, 0) ;get array of deadbase Tabitem rectangle coordinates, index 2,3 will be lower right X,Y coordinates (not needed: 0,1 = top left x,y)
		$tababx = _GUICtrlTab_GetItemRect($hGUI_SEARCH_TAB, 1) ;idem for activebase
		$tabtsx = _GUICtrlTab_GetItemRect($hGUI_SEARCH_TAB, 2) ;idem for thsnipe
		$tabblx = _GUICtrlTab_GetItemRect($hGUI_SEARCH_TAB, 3) ;idem for bully

		Select
			Case $tabidx = 0 ; Deadbase tab
				GUISetState(@SW_HIDE, $hGUI_ACTIVEBASE)
				GUISetState(@SW_HIDE, $hGUI_THSNIPE)
				GUISetState(@SW_HIDE, $hGUI_BullyMode)
				GUISetState(@SW_HIDE, $hGUI_AttackOption)

				If GUICtrlRead($DBcheck) = $GUI_CHECKED  Then
					GUISetState(@SW_SHOWNOACTIVATE, $hGUI_DEADBASE)
					GUICtrlSetState($lblDBdisabled, $GUI_HIDE)
				Else
					GUISetState(@SW_HIDE, $hGUI_DEADBASE)
					GUICtrlSetState($lblDBdisabled, $GUI_SHOW)
				EndIf

				GUICtrlSetPos($ABcheck, $tababx[2] - 15, $tababx[3] - 15) ; use x,y coordinate of tabitem rectangle bottom right corner to dynamically reposition the checkbox control (for translated tabnames)
				GUICtrlSetPos($TScheck, $tabtsx[2] - 15, $tabtsx[3] - 15)
				GUICtrlSetPos($Bullycheck, $tabblx[2] - 15, $tabblx[3] - 15)

				GUICtrlSetPos($DBcheck, $tabdbx[2] - 15, $tabdbx[3] - 17)
				tabDeadbase()
			Case $tabidx = 1 ; Activebase tab
				GUISetState(@SW_HIDE, $hGUI_DEADBASE)
				GUISetState(@SW_HIDE, $hGUI_THSNIPE)
				GUISetState(@SW_HIDE, $hGUI_BullyMode)
				GUISetState(@SW_HIDE, $hGUI_AttackOption)

				If GUICtrlRead($ABcheck) = $GUI_CHECKED  Then
					GUISetState(@SW_SHOWNOACTIVATE, $hGUI_ACTIVEBASE)
					GUICtrlSetState($lblABdisabled, $GUI_HIDE)
				Else
					GUISetState(@SW_HIDE, $hGUI_ACTIVEBASE)
					GUICtrlSetState($lblABdisabled, $GUI_SHOW)
				EndIf

				GUICtrlSetPos($DBcheck, $tabdbx[2] - 15, $tabdbx[3] - 15)
				GUICtrlSetPos($TScheck, $tabtsx[2] - 15, $tabtsx[3] - 15)
				GUICtrlSetPos($Bullycheck, $tabblx[2] - 15, $tabblx[3] - 15)

				GUICtrlSetPos($ABcheck, $tababx[2] - 15, $tababx[3] - 17)
				tabActivebase()
			Case $tabidx = 2 ; THSnipe tab
				GUISetState(@SW_HIDE, $hGUI_DEADBASE)
				GUISetState(@SW_HIDE, $hGUI_ACTIVEBASE)
				GUISetState(@SW_HIDE, $hGUI_BullyMode)
				GUISetState(@SW_HIDE, $hGUI_AttackOption)

				If GUICtrlRead($TScheck) = $GUI_CHECKED  Then
					GUISetState(@SW_SHOWNOACTIVATE, $hGUI_THSNIPE)
					GUICtrlSetState($lblTSdisabled, $GUI_HIDE)
				Else
					GUISetState(@SW_HIDE, $hGUI_THSNIPE)
					GUICtrlSetState($lblTSdisabled, $GUI_SHOW)
				EndIf

				GUICtrlSetPos($DBcheck, $tabdbx[2] - 15, $tabdbx[3] - 15)
				GUICtrlSetPos($ABcheck, $tababx[2] - 15, $tababx[3] - 15)
				GUICtrlSetPos($Bullycheck, $tabblx[2] - 15, $tabblx[3] - 15)

				GUICtrlSetPos($TScheck, $tabtsx[2] - 15, $tabtsx[3] - 17)
				tabTHSNIPE()
			Case $tabidx = 3 ; Bully tab
				GUISetState(@SW_HIDE, $hGUI_DEADBASE)
				GUISetState(@SW_HIDE, $hGUI_ACTIVEBASE)
				GUISetState(@SW_HIDE, $hGUI_THSNIPE)
				GUISetState(@SW_HIDE, $hGUI_AttackOption)

				If GUICtrlRead($Bullycheck) = $GUI_CHECKED  Then
					GUISetState(@SW_SHOWNOACTIVATE, $hGUI_BullyMode)
					GUICtrlSetState($lblBullydisabled, $GUI_HIDE)
				Else
					GUISetState(@SW_HIDE, $hGUI_BullyMode)
					GUICtrlSetState($lblBullydisabled, $GUI_SHOW)
				EndIf

				GUICtrlSetPos($DBcheck, $tabdbx[2] - 15, $tabdbx[3] - 15)
				GUICtrlSetPos($ABcheck, $tababx[2] - 15, $tababx[3] - 15)
				GUICtrlSetPos($TScheck, $tabtsx[2] - 15, $tabtsx[3] - 15)

				GUICtrlSetPos($Bullycheck, $tabblx[2] - 15, $tabblx[3] - 17)
				; Bully has no tabs
			Case $tabidx = 4 ; Options
				GUISetState(@SW_HIDE, $hGUI_DEADBASE)
				GUISetState(@SW_HIDE, $hGUI_ACTIVEBASE)
				GUISetState(@SW_HIDE, $hGUI_THSNIPE)
				GUISetState(@SW_HIDE, $hGUI_BullyMode)

				GUISetState(@SW_SHOWNOACTIVATE, $hGUI_AttackOption)

				GUICtrlSetPos($DBcheck, $tabdbx[2] - 15, $tabdbx[3] - 15)
				GUICtrlSetPos($ABcheck, $tababx[2] - 15, $tababx[3] - 15)
				GUICtrlSetPos($TScheck, $tabtsx[2] - 15, $tabtsx[3] - 15)
				GUICtrlSetPos($Bullycheck, $tabblx[2] - 15, $tabblx[3] - 15)
			EndSelect

EndFunc   ;==>tabSEARCH

Func tabBot()
	$tabidx = GUICtrlRead($hGUI_BOT_TAB)
		Select
			Case $tabidx = 0 ; Options tab
				GUISetState(@SW_HIDE, $hGUI_STATS)
			Case $tabidx = 1 ; Options Debug
				GUISetState(@SW_HIDE, $hGUI_STATS)
			Case $tabidx = 2 ; Strategies tab
				GUISetState(@SW_HIDE, $hGUI_STATS)
			Case $tabidx = 3 ; Stats tab
				GUISetState(@SW_SHOWNOACTIVATE, $hGUI_STATS)
		EndSelect
EndFunc   ;==>tabBot

Func tabDeadbase()
	$tabidx = GUICtrlRead($hGUI_DEADBASE_TAB)
		Select
;			Case $tabidx = 0 ; Search tab

			Case $tabidx = 1 ; Attack tab
				cmbDBAlgorithm()

;			Case $tabidx = 2 ; End Battle tab

			Case ELSE
				GUISetState(@SW_HIDE, $hGUI_DEADBASE_ATTACK_STANDARD)
				GUISetState(@SW_HIDE, $hGUI_DEADBASE_ATTACK_SCRIPTED)
				GUISetState(@SW_HIDE, $hGUI_DEADBASE_ATTACK_MILKING)
		EndSelect

EndFunc   ;==>tabDeadbase

Func tabActivebase()
	$tabidx = GUICtrlRead($hGUI_ACTIVEBASE_TAB)
		Select
;			Case $tabidx = 0 ; Search tab

			Case $tabidx = 1 ; Attack tab
				cmbABAlgorithm()

;			Case $tabidx = 2 ; End Battle tab

			Case ELSE
				GUISetState(@SW_HIDE, $hGUI_ACTIVEBASE_ATTACK_STANDARD)
				GUISetState(@SW_HIDE, $hGUI_ACTIVEBASE_ATTACK_SCRIPTED)

		EndSelect

EndFunc   ;==>tabActivebase

Func tabTHSnipe()
	$tabidx = GUICtrlRead($hGUI_THSNIPE_TAB)
		Select
;			Case $tabidx = 0 ; Search tab

			Case $tabidx = 1 ; Attack tab
;				cmbTHAlgorithm()

;			Case $tabidx = 2 ; End Battle tab

			Case ELSE

		EndSelect

EndFunc   ;==>tabTHSnipe

Func dbCheck()
	If $iBotLaunchTime > 0 Then _GUICtrlTab_SetCurFocus($hGUI_SEARCH_TAB, 0) ; activate deadbase tab
	If BitAND(GUICtrlRead($chkDBActivateSearches), GUICtrlRead($chkDBActivateTropies), GUICtrlRead($chkDBActivateCamps), GUICtrlRead($chkDBSpellsWait)) = $GUI_UNCHECKED Then
		GUICtrlSetState($chkDBActivateSearches, $GUI_CHECKED)
		chkDBActivateSearches() ; this includes a call to dbCheckall() -> tabSEARCH()
	Else
		tabSEARCH() ; just call tabSEARCH()
	EndIf
EndFunc

Func dbCheckAll()
		If BitAND(GUICtrlRead($chkDBActivateSearches), GUICtrlRead($chkDBActivateTropies), GUICtrlRead($chkDBActivateCamps), GUICtrlRead($chkDBSpellsWait)) = $GUI_UNCHECKED Then
		GUICtrlSetState($DBcheck, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($DBcheck, $GUI_CHECKED)
	EndIf
	tabSEARCH()
EndFunc

Func abCheck()
	If $iBotLaunchTime > 0 Then _GUICtrlTab_SetCurFocus($hGUI_SEARCH_TAB, 1)
	If BitAND(GUICtrlRead($chkABActivateSearches), GUICtrlRead($chkABActivateTropies), GUICtrlRead($chkABActivateCamps), GUICtrlRead($chkABSpellsWait)) = $GUI_UNCHECKED Then
		GUICtrlSetState($chkABActivateSearches, $GUI_CHECKED)
		chkABActivateSearches() ; this includes a call to abCheckall() -> tabSEARCH()
	Else
		tabSEARCH() ; just call tabSEARCH()
	EndIf
EndFunc

Func abCheckAll()
	If BitAND(GUICtrlRead($chkABActivateSearches), GUICtrlRead($chkABActivateTropies), GUICtrlRead($chkABActivateCamps), GUICtrlRead($chkABSpellsWait)) = $GUI_UNCHECKED Then
		GUICtrlSetState($ABcheck, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($ABcheck, $GUI_CHECKED)
	EndIf
	tabSEARCH()
EndFunc

Func tsCheck()
	If $iBotLaunchTime > 0 Then _GUICtrlTab_SetCurFocus($hGUI_SEARCH_TAB, 2)
	If BitAND(GUICtrlRead($chkTSActivateSearches), GUICtrlRead($chkTSActivateTropies), GUICtrlRead($chkTSActivateCamps)) = $GUI_UNCHECKED Then
		GUICtrlSetState($chkTSActivateSearches, $GUI_CHECKED)
		chkTSActivateSearches() ; this includes a call to tsCheckall() -> tabSEARCH()
	Else
		tabSEARCH() ; just call tabSEARCH()
	EndIf
EndFunc

Func tsCheckAll()
	If BitAND(GUICtrlRead($chkTSActivateSearches), GUICtrlRead($chkTSActivateTropies), GUICtrlRead($chkTSActivateCamps)) = $GUI_UNCHECKED Then
		GUICtrlSetState($TScheck, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($TScheck, $GUI_CHECKED)
	EndIf
	tabSEARCH()
EndFunc

Func bullyCheck()
	If $iBotLaunchTime > 0 Then _GUICtrlTab_SetCurFocus($hGUI_SEARCH_TAB, 3)
	tabSEARCH()
EndFunc


;---------------------------------------------------
; Extra Functions used on GUI Control
;---------------------------------------------------

Func _DonateAllControls($TroopType, $Set)
	Local $bWasRedraw = SetRedrawBotWindow(False)

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

	SetRedrawBotWindowControls($bWasRedraw, $hGUI_DONATE_TAB) ; cannot use tab item here
EndFunc   ;==>_DonateAllControls

Func _DonateAllControlsSpell($TroopType, $Set)
	Local $bWasRedraw = SetRedrawBotWindow(False)

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

	SetRedrawBotWindowControls($bWasRedraw, $hGUI_DONATE_TAB) ; cannot use tab item here
EndFunc   ;==>_DonateAllControlsSpell


Func ImageList_Create()
	$hImageList = DllCall("comctl32.dll", "hwnd", "ImageList_Create", "int", 16, "int", 16, "int", 0x0021, "int", 0, "int", 1)
	$hImageList = $hImageList[0]
	Return $hImageList
EndFunc   ;==>ImageList_Create

Func Bind_ImageList($nCtrl)
	Local $aIconIndex = 0

	$hImageList = ImageList_Create()
	GUICtrlSendMsg($nCtrl, $TCM_SETIMAGELIST, 0, $hImageList)

	$tTcItem = DllStructCreate("uint;dword;dword;ptr;int;int;int")
	DllStructSetData($tTcItem, 1, 0x0002)
	Switch $nCtrl
		Case $tabMain
			; the icons for main tab
			Local $aIconIndex[5] = [$eIcnHourGlass, $eIcnTH11, $eIcnCamp, $eIcnGUI, $eIcnInfo]

		Case $hGUI_VILLAGE_TAB
			; the icons for village tab
			Local $aIconIndex[5] = [$eIcnTH1, $eIcnCC, $eIcnLaboratory, $eIcnAchievements, $eIcnInfo]

		Case $hGUI_ARMY_TAB
			; the icons for army tab
			Local $aIconIndex[4] = [$eIcnBarbarian, $eIcnLightSpell, $eIcnGem, $eIcnOptions]

		Case $hGUI_DONATE_TAB
			 ; the icons for donate tab
			Local $aIconIndex[3] = [$eIcnCCRequest, $eIcnCCDonate, $eIcnHourGlass]

		Case $hGUI_UPGRADE_TAB
			; the icons for upgrade tab
			Local $aIconIndex[4] = [$eIcnLaboratory, $eIcnKingAbility, $eIcnMortar, $eIcnWall]

		Case $hGUI_NOTIFY_TAB
			; the icons for NOTIFY tab
			Local $aIconIndex[2] = [$eIcnPushBullet, $eIcnOptions]

		Case $hGUI_ATTACK_TAB
			; the icons for attack tab
			Local $aIconIndex[3] = [$eIcnCamp, $eIcnMagnifier, $eIcnStrategies]

		Case $hGUI_SEARCH_TAB
			; the icons for SEARCH tab
			Local $aIconIndex[5] = [$eIcnCollector, $eIcnCC, $eIcnTH10, $eIcnTH1, $eIcnOptions]

		Case $hGUI_DEADBASE_TAB
			; the icons for deadbase tab
			Local $aIconIndex[4] = [$eIcnMagnifier, $eIcnCamp, $eIcnSilverStar, $eIcnCollector]

		Case $hGUI_ACTIVEBASE_TAB
			; the icons for activebase tab
			Local $aIconIndex[3] = [$eIcnMagnifier, $eIcnCamp, $eIcnSilverStar]

		Case $hGUI_THSNIPE_TAB
			; the icons for thsnipe tab
			Local $aIconIndex[3] = [$eIcnMagnifier, $eIcnCamp, $eIcnSilverStar]

		Case $hGUI_AttackOption_TAB
			; the icons for Attack Options tab
			Local $aIconIndex[4] = [$eIcnMagnifier, $eIcnCamp, $eIcnSilverStar, $eIcnTrophy]

		Case $hGUI_BOT_TAB
			; the icons for Bot tab
			Local $aIconIndex[4] = [$eIcnOptions, $eIcnProfile, $eIcnProfile, $eIcnGold]

		Case $hGUI_STRATEGIES_TAB
			; the icons for strategies tab
			Local $aIconIndex[2] = [$eIcnReload, $eIcnCopy]

		Case $hGUI_STATS_TAB
			; the icons for stats tab
			Local $aIconIndex[3] = [$eIcnGoldElixir, $eIcnOptions, $eIcnCamp]

		Case Else
			;do nothing
	EndSwitch

	If IsArray($aIconIndex) Then ; if array is filled then $nCtrl was a valid control
		For $i = 0 To UBound($aIconIndex) - 1
			DllStructSetData($tTcItem, 6, $i)
			AddImageToTab($nCtrl, $i, $tTcItem, $pIconLib, $aIconIndex[$i] - 1)
		Next
		$aIconIndex = 0 ; empty array
	EndIf

	$tTcItem = 0 ; empty Stucture

EndFunc   ;==>Bind_ImageList

Func AddImageToTab($nCtrl, $nTabIndex, $nItem, $pIconLib, $nIconID)
	$hIcon = DllStructCreate("int")
	$result = DllCall("shell32.dll", "int", "ExtractIconEx", "str", $pIconLib, "int", $nIconID, "hwnd", 0, "ptr", DllStructGetPtr($hIcon), "int", 1)
	$result = $result[0]
	If $result > 0 Then
		DllCall("comctl32.dll", "int", "ImageList_AddIcon", "hwnd", $hImageList, "hwnd", DllStructGetData($hIcon, 1))
		DllCall("user32.dll", "int", "SendMessage", "hwnd", ControlGetHandle($frmBot, "", $nCtrl), "int", $TCM_SETITEM, "int", $nTabIndex, "ptr", DllStructGetPtr($nItem))
		DllCall("user32.dll", "int", "DestroyIcon", "hwnd", $hIcon)
	EndIf

	$hIcon = 0
EndFunc   ;==>AddImageToTab



Func _GUICtrlListView_SetItemHeightByFont( $hListView, $iHeight )
  ; Get font of ListView control
  ; Copied from _GUICtrlGetFont example by KaFu
  ; See https://www.autoitscript.com/forum/index.php?showtopic=124526
  Local $hDC = _WinAPI_GetDC( $hListView ), $hFont = _SendMessage( $hListView, $WM_GETFONT )
  Local $hObject = _WinAPI_SelectObject( $hDC, $hFont ), $lvLOGFONT = DllStructCreate( $tagLOGFONT )
  _WinAPI_GetObject( $hFont, DllStructGetSize( $lvLOGFONT ), DllStructGetPtr( $lvLOGFONT ) )
  Local $hLVfont = _WinAPI_CreateFontIndirect( $lvLOGFONT ) ; Original ListView font
  _WinAPI_SelectObject( $hDC, $hObject )
  _WinAPI_ReleaseDC( $hListView, $hDC )
  _WinAPI_DeleteObject( $hFont )

  ; Set height of ListView items by applying text font with suitable height
  $hFont = _WinAPI_CreateFont( $iHeight, 0 )
  _WinAPI_SetFont( $hListView, $hFont )
  _WinAPI_DeleteObject( $hFont )

  ; Restore font of Header control
  Local $hHeader = _GUICtrlListView_GetHeader( $hListView )
  If $hHeader Then _WinAPI_SetFont( $hHeader, $hLVfont )

  ; Return original ListView font
  Return $hLVfont
EndFunc

Func _GUICtrlListView_GetHeightToFitRows( $hListView, $iRows )
  ; Get height of Header control
  Local $tRect = _WinAPI_GetClientRect( $hListView )
  Local $hHeader = _GUICtrlListView_GetHeader( $hListView )
  Local $tWindowPos = _GUICtrlHeader_Layout( $hHeader, $tRect )
  Local $iHdrHeight = DllStructGetData( $tWindowPos , "CY" )
  ; Get height of ListView item 0 (item 0 must exist)
  Local $aItemRect = _GUICtrlListView_GetItemRect( $hListView, 0, 0 )
  ; Return height of ListView to fit $iRows items
  ; Including Header height and 8 pixels of additional room
  Return ( $aItemRect[3] - $aItemRect[1] ) * $iRows + $iHdrHeight + 8
EndFunc

Func EnableControls($hWin, $Enable, ByRef $avArr, $bGUIControl_Disabled = True, $i = 0)
	Local $initalCall = $i = 0
    If UBound($avArr, 0) <> 2 Then
        Local $avTmp[1][2] = [[0]]
        $avArr = $avTmp
    EndIf
	If $initalCall And $bGUIControl_Disabled Then
		_SendMessage($hWin, $WM_SETREDRAW, False, 0)
		Local $GUIControl_Disabled_ = $GUIControl_Disabled
		$GUIControl_Disabled = True
	EndIf
	Local $hChild = _WinAPI_GetWindow($hWin, $GW_CHILD)
    While $hChild
		$i += 1
        If $avArr[0][0]+1 > UBound($avArr, 1)-1 Then
			ReDim $avArr[$avArr[0][0]+2][2]
			$avArr[$avArr[0][0]+1][0] = $hChild
			$avArr[$avArr[0][0]+1][1] = BitAND(WinGetState($hChild), 4) > 0
		EndIf
		If $Enable = Default Then
			WinSetState($hChild, "", ($avArr[$i][1] = True ? @SW_ENABLE : @SW_DISABLE))
		Else
			WinSetState($hChild, "", ($Enable ? @SW_ENABLE : @SW_DISABLE))
		EndIf
        $avArr[0][0] += 1
        $i = EnableControls($hChild, $Enable, $avArr, $bGUIControl_Disabled, $i)
        $hChild = _WinAPI_GetWindow($hChild, $GW_HWNDNEXT)
    WEnd

	If $initalCall And $Enable = Default Then $avArr = 0

	If $initalCall And $bGUIControl_Disabled Then
		_SendMessage($hWin, $WM_SETREDRAW, True, 0)
		_WinAPI_RedrawWindow($hWin, 0, 0, $RDW_INVALIDATE)
		$GUIControl_Disabled = $GUIControl_Disabled_
	EndIf

	Return $i
EndFunc
;---------------------------------------------------

;~ Show Default Tab
tabMain()

;---------------------------------------------------
;~ If FileExists($sProfilePath & "\profile.ini") Then
selectProfile() ; Choose the profile
;~ EndIf
If FileExists($config) Or FileExists($building) Then
	readConfig()
	applyConfig()
EndIf
If $devmode = 1 Then
	GUICtrlSetState($chkDebugSetlog, $GUI_SHOW + $GUI_ENABLE)
	GUICtrlSetState($chkDebugOcr, $GUI_SHOW + $GUI_ENABLE)
	GUICtrlSetState($chkDebugImageSave, $GUI_SHOW + $GUI_ENABLE)
	GUICtrlSetState($chkdebugBuildingPos, $GUI_SHOW + $GUI_ENABLE)
	GUICtrlSetState($chkdebugTrain, $GUI_SHOW + $GUI_ENABLE)
	GUICtrlSetState($chkdebugOCRDonate, $GUI_SHOW + $GUI_ENABLE)
EndIf
GUIRegisterMsg($WM_NCACTIVATE, "GUIControl_WM_NCACTIVATE")
GUIRegisterMsg($WM_SETFOCUS, "GUIControl_WM_FOCUS")
GUIRegisterMsg($WM_KILLFOCUS, "GUIControl_WM_FOCUS")
GUIRegisterMsg($WM_MOVE, "GUIControl_WM_MOVE")
GUIRegisterMsg($WM_COMMAND, "GUIControl_WM_COMMAND")
;GUIRegisterMsg($WM_SYSCOMMAND, "GUIControl_WM_SYSCOMMAND")
GUISetOnEvent($GUI_EVENT_CLOSE, "GUIEvents", $frmBot)
GUIRegisterMsg($WM_NOTIFY, "GUIControl_WM_NOTIFY")
For $i = $WM_MOUSEFIRST To $WM_MOUSEHWHEEL
	GUIRegisterMsg($i, "GUIControl_WM_MOUSE")
Next
GUISetOnEvent($GUI_EVENT_MINIMIZE, "GUIEvents", $frmBot)
GUISetOnEvent($GUI_EVENT_RESTORE, "GUIEvents", $frmBot)

;Moved to applyConfig
;chkDBActivateSearches()
;chkABActivateSearches()
;chkTSActivateSearches()
cmbDBAlgorithm()
cmbABAlgorithm()


;---------------------------------------------------
