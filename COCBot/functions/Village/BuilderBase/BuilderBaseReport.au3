; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseReport()
; Description ...: Make Resources report of Builders Base
; Syntax ........: BuilderBaseReport()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BuilderBaseReport($bBypass = False, $bSetLog = True)
	PureClickP($aAway, 1, 0, "#0319") ;Click Away
	If _Sleep($DELAYVILLAGEREPORT1) Then Return

	Switch $bBypass
		Case False
			If $bSetLog Then SetLog("Builder Base Report", $COLOR_INFO)
		Case True
			If $bSetLog Then SetLog("Updating Builder Base Resource Values", $COLOR_INFO)
		Case Else
			If $bSetLog Then SetLog("Builder Base Village Report Error, You have been a BAD programmer!", $COLOR_ERROR)
	EndSwitch

	If Not $bSetLog Then SetLog("Builder Base Village Report", $COLOR_INFO)

	getBuilderCount($bSetLog, True) ; update builder data
	If _Sleep($DELAYRESPOND) Then Return

	$g_aiCurrentLootBB[$eLootTrophyBB] = getTrophyMainScreen(67, 84)
	$g_aiCurrentLootBB[$eLootGoldBB] = getResourcesMainScreen(705, 23)
	$g_aiCurrentLootBB[$eLootElixirBB] = getResourcesMainScreen(705, 72)
	If $bSetLog Then SetLog(" [G]: " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB]) & " [E]: " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB]) & "[T]: " & _NumberFormat($g_aiCurrentLootBB[$eLootTrophyBB]), $COLOR_SUCCESS)

	If Not $bBypass Then ; update stats
		UpdateStats()
	EndIf
EndFunc   ;==>BuilderBaseReport




