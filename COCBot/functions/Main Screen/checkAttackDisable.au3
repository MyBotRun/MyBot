
; #FUNCTION# ====================================================================================================================
; Name ..........: checkAttackDisable
; Description ...:
; Syntax ........: checkAttackDisable($iSource, [$Result = getAttackDisable(X,Y])
; Parameters ....: $Result              - [optional] previous saved string from OCR read. Default is getAttackDisable(346, 182) or getAttackDisable(180,167)
;					    $iSource				 - integer, 1 = called during search process (preparesearch/villagesearch)
;																	2 = called during time when not trying to attack (all other idle times have different message)
; Return values .: None
; Author ........: KnowJack (Aug 2015)
; Modified ......: TheMaster (2015), MonkeyHunter (2015-12/2016-1), Hervidero (2015-12),
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func checkAttackDisable($iSource, $Result = "")
	Local $i = 0

	If $bDisableBreakCheck = True Then Return  ; check Disable break flag, added to prevent recursion for CheckBaseQuick

	Switch $iSource
		Case $iTaBChkAttack  ; look at location 346, 182 for "disable", "for" or "after" if checked early enough
			While $Result = "" Or (StringLen($Result) < 3)
				$i += 1
				If _Sleep(100) Then Return
				$Result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak if not found due slow PC
				If $i >= 3 Then ExitLoop
			WEnd
			If $debugSetlog = 1 Then Setlog("Attack Personal Break OCR result = " & $Result, $COLOR_PURPLE)
			If $Result <> "" Then ; fast test to see if have Take-A-Break
				If StringInStr($Result, "disable") <> 0 Or StringInStr($Result, "for") <> 0 Or StringInStr($Result, "after") <> 0 Or StringInStr($Result, "have") <> 0 Then ; verify we have right text strings, 'after' added for Personal Break
					Setlog("Attacking disabled, Personal Break detected...", $COLOR_RED)
					If _CheckPixel($aSurrenderButton, $bCapturePixel) Then ; village search requires end battle 1s, so check for surrender/endbattle button
						ReturnHome(False, False) ;If End battle is available
					Else
						CloseCoC()
					EndIf
				Else
					If $debugSetlog = 1 Then Setlog("wrong text string", $COLOR_PURPLE)
					Return ; exit function, wrong string found
				EndIf
			Else
				Return ; exit function, take a break text not found
			EndIf
		Case $iTaBChkIdle ; look at location 180, 167 for the have "been" online too long message, and the "after" Personal Break message
			If $Result = "" Then getAttackDisable(180, 156 + $midOffsetY) ; change to 180, 186 for 860x780
			If _Sleep(500) Then Return ; short wait to not delay to much
			If $Result = "" Or (StringLen($Result) < 3) Then $Result = getAttackDisable(180, 156 + $midOffsetY) ; Grab Ocr for "Have Been" 2nd time if not found due slow PC
			If $debugSetlog = 1 Then Setlog("Personal Break OCR result = " & $Result, $COLOR_PURPLE)
			If $Result <> "" Then ; fast test to see if have Take-A-Break
				If StringInStr($Result, "been") <> 0 Or StringInStr($Result, "after") <> 0 Or StringInStr($Result, "have") <> 0 Then ; verify we have right text string, 'after' added for Personal Break
					Setlog("Online too long, Personal Break detected....", $COLOR_RED)
					checkMainScreen()
				Else
					If $debugSetlog = 1 Then Setlog("wrong text string", $COLOR_PURPLE)
					Return ; exit function, wrong string found
				EndIf
			Else
				Return ; exit function, take a break text not found
			EndIf
		Case Else
			Setlog("Misformed $sSource parameter, silly programmer made a mistake!", $COLOR_PURPLE)
			Return False
	EndSwitch

	Setlog("Prepare base before Personal Break..", $COLOR_BLUE)
	$bDisableBreakCheck = True ; Set flag to stop checking for attackdisable messages, stop recursion
	CheckBaseQuick() ; check and restock base before exit.
	$bDisableBreakCheck = False ; reset break check flag to normal

	$Is_ClientSyncError = False  ; reset OOS fast restart flag
	$Is_SearchLimit = False  ; reset search limit flag
	$Restart = True ; Set flag to restart the process at the bot main code when it returns

	Setlog("Time for break, exit now..", $COLOR_BLUE)

	; Find and wait for the confirmation of exit "okay" button
	Local $i = 0 ; Reset Loop counter
	While 1
		checkObstacles()
		;PureClickP($aBSBackButton, 1, 0, "#0116") ; Hit BS Back button for the confirm exit dialog to appear, add 60 to location for 860x780
		BS1BackButton()
		If _Sleep(1000) Then Return ; wait for window to open
		If ClickOkay("ExitCoCokay", True) = True Then ExitLoop ; Confirm okay to exit
		If $i > 10 Then
			Setlog("Can not find Okay button to exit CoC, Forcefully Closing CoC", $COLOR_RED)
			if $debugImageSave= 1 Then  DebugImageSave("CheckAttackDisableFailedButtonCheck_")
			CloseCoC()
			ExitLoop
		EndIf
		$i += 1
	WEnd

	If _Sleep(1000) Then Return ; short wait for CoC to exit
	PushMsg("TakeBreak")

	; CoC is closed >>
	WaitnOpenCoC(20000, True) ; close CoC for 20 seconds to ensure server logoff, True=call checkmainscreen to clean up if needed

EndFunc   ;==>checkAttackDisable

