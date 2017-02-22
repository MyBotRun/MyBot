; #FUNCTION# ====================================================================================================================
; Name ..........: CheckNeedOpenTrain
; Description ...:
; Syntax ........: CheckNeedOpenTrain($TimeBeforeTrain)
; Parameters ....: $TimeBeforeTrain   - Time in second Used to know is train is needed.
; Return values .: True/False
; Author ........: Boju (01-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckNeedOpenTrain($TimeBeforeTrain)
	Local $bToReturn = False
	Local $QuickArmyCamps = 100
	If $g_abSearchCampsEnable[$DB] Then
		If $g_aiSearchCampsPct[$DB] < $QuickArmyCamps Then $QuickArmyCamps = $g_aiSearchCampsPct[$DB]
		If $g_aiSearchCampsPct[$DB] - Int($CurCamp / $TotalCamp * 100) < $QuickArmyCamps Then $QuickArmyCamps = $g_aiSearchCampsPct[$DB] - Int($CurCamp / $TotalCamp * 100)
	EndIf
	If $g_abSearchCampsEnable[$LB] Then
		If $g_aiSearchCampsPct[$LB] < $QuickArmyCamps Then $QuickArmyCamps = $g_aiSearchCampsPct[$LB]
		If $g_aiSearchCampsPct[$LB] - Int($CurCamp / $TotalCamp * 100) < $QuickArmyCamps Then $QuickArmyCamps = $g_aiSearchCampsPct[$LB] - Int($CurCamp / $TotalCamp * 100)
	EndIf
	If $g_abSearchCampsEnable[$TS] Then
		If $g_aiSearchCampsPct[$TS] < $QuickArmyCamps Then $QuickArmyCamps = $g_aiSearchCampsPct[$TS]
		If $g_aiSearchCampsPct[$TS] - Int($CurCamp / $TotalCamp * 100) < $QuickArmyCamps Then $QuickArmyCamps = $g_aiSearchCampsPct[$TS] - Int($CurCamp / $TotalCamp * 100)
	EndIf
	If $aTimeTrain[0] = 0 Or $TimeBeforeTrain >= ($aTimeTrain[0] * 60) * ($QuickArmyCamps / 100) Then $bToReturn = True
	If $g_iDebugSetlogTrain = 1 Then SetLog("Time to train: " & ($aTimeTrain[0] * 60) * ($QuickArmyCamps / 100) & " Waiting time: " & $TimeBeforeTrain, $COLOR_DEBUG)
	Local $iTimeDiffOpen = (($aTimeTrain[0] * 60) * ($QuickArmyCamps / 100)) - $TimeBeforeTrain
	If ($bActiveDonate Or $bDonationEnabled) And $g_bChkDonate Then $bToReturn = True
	If $iTimeDiffOpen > 0 And $bToReturn = False Then
		SetLog("Next open Army Window: " & StringFormat("%02i", Floor(Floor($iTimeDiffOpen / 60) / 60)) & ":" & StringFormat("%02i", Floor(Mod(Floor($iTimeDiffOpen / 60), 60))) & ":" & StringFormat("%02i", Floor(Mod($iTimeDiffOpen, 60))))
	EndIf
	If $bToReturn = False Then ClickP($aAway, 1, 0, "#0332") ;Click Away
	Return $bToReturn
EndFunc   ;==>CheckNeedOpenTrain
