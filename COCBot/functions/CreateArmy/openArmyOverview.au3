
; #FUNCTION# ====================================================================================================================
; Name ..........: openArmyOverview
; Description ...: Opens and waits for Army Overiew window and verifes success
; Syntax ........: openArmyOverview()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (2016-01)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func openArmyOverview()

	If IsMainPage() = False Then ; check for main page, avoid random troop drop
		SetLog("Can not open Army Overview window", $COLOR_ERROR)
		SetError(1)
		Return False
	EndIf

	If WaitforPixel(28, 505 + $g_iBottomOffsetY, 30, 507 + $g_iBottomOffsetY, Hex(0xE4A438, 6), 5, 10) Then
		If $g_iDebugSetlogTrain = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_SUCCESS)
		If $iUseRandomClick = 0 then
			Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0293") ; Button Army Overview
		Else
			ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
		EndIF
	EndIf

	If _Sleep($iDelayRunBot6) Then Return ; wait for window to open
	If IsTrainPage() = False Then
		SetError(1)
		Return False ; exit if I'm not in train page
	EndIf
	Return True

EndFunc   ;==>openArmyOverview
