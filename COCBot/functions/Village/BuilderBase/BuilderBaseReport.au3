; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseReport()
; Description ...: Make Resources report of Builders Base
; Syntax ........: BuilderBaseReport()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BuilderBaseReport($bBypass = False, $bSetLog = True)
	ClickAway()
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
	If $bSetLog Then SetLog(" [G]: " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB]) & " [E]: " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB]) & " [T]: " & _NumberFormat($g_aiCurrentLootBB[$eLootTrophyBB]), $COLOR_SUCCESS)

	PicBBTrophies()

	If Not $bBypass Then ; update stats
		UpdateStats()
	EndIf
	
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
EndFunc   ;==>BuilderBaseReport

Func PicBBTrophies()
	_GUI_Value_STATE("HIDE", $g_aGroupBBLeague)
	If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[41][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueDiamond], $GUI_SHOW)
		GUICtrlSetState($g_hLblBBLeague1, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague2, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague3, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[38][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueRuby], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[40][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[39][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[38][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[35][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueEmerald], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[37][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[36][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[35][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[32][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeaguePlatinum], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[34][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[33][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[32][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[29][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueTitanium], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[31][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[30][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[29][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[26][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueSteel], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[28][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[27][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[26][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[23][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueIron], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[25][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[24][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[23][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[20][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueBrass], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[22][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[21][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[20][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[15][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueCopper], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[19][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[18][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[17][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[16][1]) Then
			GUICtrlSetState($g_hLblBBLeague4, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[15][1]) Then
			GUICtrlSetState($g_hLblBBLeague5, $GUI_SHOW)
		EndIf
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[10][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueStone], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[14][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[13][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[12][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[11][1]) Then
			GUICtrlSetState($g_hLblBBLeague4, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[10][1]) Then
			GUICtrlSetState($g_hLblBBLeague5, $GUI_SHOW)
		EndIf
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[5][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueClay], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[9][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[8][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[7][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[6][1]) Then
			GUICtrlSetState($g_hLblBBLeague4, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[5][1]) Then
			GUICtrlSetState($g_hLblBBLeague5, $GUI_SHOW)
		EndIf
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[0][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueWood], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[4][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[3][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[2][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[1][1]) Then
			GUICtrlSetState($g_hLblBBLeague4, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[0][1]) Then
			GUICtrlSetState($g_hLblBBLeague5, $GUI_SHOW)
		EndIf
	Else
		GUICtrlSetState($g_ahPicBBLeague[$eBBLeagueUnranked], $GUI_SHOW)
		GUICtrlSetState($g_hLblBBLeague1, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague2, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague3, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	EndIf
EndFunc   ;==>PicCCTrophies




