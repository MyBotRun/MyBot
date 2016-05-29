; #FUNCTION# ====================================================================================================================
; Name ..........: CheckBaseQuick
; Description ...: Performs a quick check of base; requestCC, DonateCC, Train if required, collect resources, and pick up healed heroes.
;                : Used for prep before take a break & Personal Break exit, or during long trophy drops
; Syntax ........: CheckBasepQuick()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (2015-12)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CheckBaseQuick()

	If IsMainPage() Then ; check for main page

		If $Debugsetlog = 1 Then Setlog("CheckBaseQuick now...", $COLOR_RED)

		RequestCC() ; fill CC
		If _Sleep($iDelayRunBot1) Then Return
		checkMainScreen(False) ; required here due to many possible exits
		If $Restart = True Then Return

		DonateCC() ; donate troops
		If _Sleep($iDelayRunBot1) Then Return
		checkMainScreen(False) ; required here due to many possible function exits
		If $Restart = True Then Return

		CheckOverviewFullArmy(True) ; Check if army needs to be trained due donations
		If Not ($FullArmy) And $bTrainEnabled = True Then
			Train()
			If $Restart = True Then Return
		EndIf

		Collect() ; Empty Collectors
		If _Sleep($iDelayRunBot1) Then Return

	Else
		If $Debugsetlog = 1 Then Setlog("Not on main page, CheckBaseQuick skipped", $COLOR_RED)
	EndIf

EndFunc   ;==>CheckBaseQuick
