; #FUNCTION# ====================================================================================================================
; Name ..........: OpenArmyOverview
; Description ...: Opens and waits for Army Overiew window and verifes success
; Syntax ........: OpenArmyOverview()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (01-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func OpenArmyOverview($bCheckMain = True)

	If $bCheckMain Then
		If Not IsMainPage() Then ; check for main page, avoid random troop drop
			SetLog("Cannot open Army Overview window", $COLOR_ERROR)
			SetError(1)
			Return False
		EndIf
	EndIf

	If WaitforPixel(28, 505 + $g_iBottomOffsetY, 30, 507 + $g_iBottomOffsetY, Hex(0xEEB145, 6), 5, 10) Then
		If $g_bDebugSetlogTrain Then SetLog("Click $aArmyTrainButton", $COLOR_SUCCESS)
		If Not $g_bUseRandomClick Then
			ClickP($aArmyTrainButton, 1, 0, "#0293") ; Button Army Overview
		Else
			ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
		EndIf
	EndIf

	If _Sleep($DELAYRUNBOT6) Then Return ; wait for window to open
	If Not IsTrainPage() Then
		SetError(1)
		Return False ; exit if I'm not in train page
	EndIf
	Return True

EndFunc   ;==>openArmyOverview

Func OpenArmyTab($bSetLog = True)
	Return OpenTrainTab("Army Tab", $aArmyTab, $bSetLog)
EndFunc

Func OpenTroopsTab($bSetLog = True)
	Return OpenTrainTab("Troops Tab", $aTroopsTab, $bSetLog)
EndFunc

Func OpenSpellsTab($bSetLog = True)
	Return OpenTrainTab("Spells Tab", $aSpellsTab, $bSetLog)
EndFunc

Func OpenQuickTrainTab($bSetLog = True)
	Return OpenTrainTab("Quick Train Tab", $aQuickTrainTab, $bSetLog)
EndFunc

Func OpenTrainTab($sTab, $aPixelToCheck, $bSetLog = True)

	If Not IsTrainPage() Then
		SetLog("Error in OpenTrainTab: Cannot find the Army Overview Window", $COLOR_ERROR)
		SetError(1)
		Return False
	EndIf

	If Not _CheckPixel($aPixelToCheck, True) Then
		If $bSetLog Then SetLog("Open " & $sTab)
		ClickP($aPixelToCheck)
		If Not _WaitForCheckPixel($aPixelToCheck, True) Then
			SetLog("Error in OpenTrainTab: Cannot open " & $sTab & ". Pixel to check did not appear", $COLOR_ERROR)
			SetError(1)
			Return False
		EndIf
		Return True
	Else
		; Already on Tab we want :)
		Return True
	EndIf

EndFunc
