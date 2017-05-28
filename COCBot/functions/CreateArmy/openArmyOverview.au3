
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
Func OpenArmyOverview()

	If Not IsMainPage() Then ; check for main page, avoid random troop drop
		SetLog("Cannot open Army Overview window", $COLOR_ERROR)
		SetError(1)
		Return False
	EndIf

	If WaitforPixel(28, 505 + $g_iBottomOffsetY, 30, 507 + $g_iBottomOffsetY, Hex(0xEEB145, 6), 5, 10) Then
		If $g_iDebugSetlogTrain = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_SUCCESS)
		If Not $g_bUseRandomClick Then
			Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0293") ; Button Army Overview
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
