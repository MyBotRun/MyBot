; #FUNCTION# ====================================================================================================================
; Name ..........: saveConfig.au3
; Description ...: Saves all of the GUI values to the config.ini and building.ini files
; Syntax ........: saveConfig()
; Parameters ....: NA
; Return values .: NA
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func saveConfig() ;Saves the controls settings to the config
	;General Settings--------------------------------------------------------------------------

	Local $hFile = -1
	If $ichkExtraAlphabets = 1 Then $hFile = FileOpen($config, $FO_UTF16_LE + $FO_OVERWRITE)

	Local $frmBotPos = WinGetPos($sBotTitle)

	IniWrite($config, "general", "cmbProfile", _GUICtrlComboBox_GetCurSel($cmbProfile))
	IniWrite($config, "general", "frmBotPosX", $frmBotPos[0])
	IniWrite($config, "general", "frmBotPosY", $frmBotPos[1])
	IniWrite($config, "general", "villageName", GUICtrlRead($txtVillageName))

	IniWrite($config, "general", "logstyle", _GUICtrlComboBox_GetCurSel($cmbLog))
	$DPos = ControlGetPos($frmBot, "", $divider)
	IniWrite($config, "general", "LogDividerY", $DPos[1])

	If GUICtrlRead($chkAutoStart) = $GUI_CHECKED Then
		IniWrite($config, "general", "AutoStart", 1)
	Else
		IniWrite($config, "general", "AutoStart", 0)
	EndIf
	IniWrite($config, "general", "AutoStartDelay", GUICtrlRead($txtAutostartDelay))



	If GUICtrlRead($chkBackground) = $GUI_CHECKED Then
		IniWrite($config, "general", "Background", 1)
	Else
		IniWrite($config, "general", "Background", 0)
	EndIf

	If GUICtrlRead($chkBotStop) = $GUI_CHECKED Then
		IniWrite($config, "general", "BotStop", 1)
	Else
		IniWrite($config, "general", "BotStop", 0)
	EndIf

	If GUICtrlRead($chkDisposeWindows) = $GUI_CHECKED Then
		IniWrite($config, "general", "DisposeWindows", 1)
	Else
		IniWrite($config, "general", "DisposeWindows", 0)
	EndIf
	IniWrite($config, "general", "DisposeWindowsPos", _GUICtrlComboBox_GetCurSel($cmbDisposeWindowsCond))

	IniWrite($config, "general", "Command", _GUICtrlComboBox_GetCurSel($cmbBotCommand))
	IniWrite($config, "general", "Cond", _GUICtrlComboBox_GetCurSel($cmbBotCond))
	IniWrite($config, "general", "Hour", _GUICtrlComboBox_GetCurSel($cmbHoursStop))


	;Search Settings------------------------------------------------------------------------

	IniWrite($config, "search", "SearchMode", _GUICtrlComboBox_GetCurSel($cmbSearchMode))
	If GUICtrlRead($chkAlertSearch) = $GUI_CHECKED Then
		IniWrite($config, "search", "AlertSearch", 1)
	Else
		IniWrite($config, "search", "AlertSearch", 0)
	EndIf

	; deadbase
	If GUICtrlRead($chkDBEnableAfter) = $GUI_CHECKED Then
		IniWrite($config, "search", "DBEnableAfter", 1)
	Else
		IniWrite($config, "search", "DBEnableAfter", 0)
	EndIf

	IniWrite($config, "search", "DBMeetGE", _GUICtrlComboBox_GetCurSel($cmbDBMeetGE))

	If GUICtrlRead($chkDBMeetDE) = $GUI_CHECKED Then
		IniWrite($config, "search", "DBMeetDE", 1)
	Else
		IniWrite($config, "search", "DBMeetDE", 0)
	EndIf

	If GUICtrlRead($chkDBMeetTrophy) = $GUI_CHECKED Then
		IniWrite($config, "search", "DBMeetTrophy", 1)
	Else
		IniWrite($config, "search", "DBMeetTrophy", 0)
	EndIf

	If GUICtrlRead($chkDBMeetTH) = $GUI_CHECKED Then
		IniWrite($config, "search", "DBMeetTH", 1)
	Else
		IniWrite($config, "search", "DBMeetTH", 0)
	EndIf

	If GUICtrlRead($chkDBMeetTHO) = $GUI_CHECKED Then
		IniWrite($config, "search", "DBMeetTHO", 1)
	Else
		IniWrite($config, "search", "DBMeetTHO", 0)
	EndIf

	If GUICtrlRead($chkDBWeakBase) = $GUI_CHECKED Then
		IniWrite($config, "search", "DBWeakBase", 1)
	Else
		IniWrite($config, "search", "DBWeakBase", 0)
	EndIf

	If GUICtrlRead($chkDBMeetOne) = $GUI_CHECKED Then
		IniWrite($config, "search", "DBMeetOne", 1)
	Else
		IniWrite($config, "search", "DBMeetOne", 0)
	EndIf

	IniWrite($config, "search", "DBEnableAfterCount", GUICtrlRead($txtDBEnableAfter))
	IniWrite($config, "search", "DBsearchGold", GUICtrlRead($txtDBMinGold))
	IniWrite($config, "search", "DBsearchElixir", GUICtrlRead($txtDBMinElixir))
	IniWrite($config, "search", "DBsearchGoldPlusElixir", GUICtrlRead($txtDBMinGoldPlusElixir))
	IniWrite($config, "search", "DBsearchDark", GUICtrlRead($txtDBMinDarkElixir))
	IniWrite($config, "search", "DBsearchTrophy", GUICtrlRead($txtDBMinTrophy))
	IniWrite($config, "search", "DBTHLevel", _GUICtrlComboBox_GetCurSel($cmbDBTH))
	IniWrite($config, "search", "DBWeakMortar", _GUICtrlComboBox_GetCurSel($cmbDBWeakMortar))
	IniWrite($config, "search", "DBWeakWizTower", _GUICtrlComboBox_GetCurSel($cmbDBWeakWizTower))

	;any base
	If GUICtrlRead($chkABEnableAfter) = $GUI_CHECKED Then
		IniWrite($config, "search", "ABEnableAfter", 1)
	Else
		IniWrite($config, "search", "ABEnableAfter", 0)
	EndIf

	IniWrite($config, "search", "ABMeetGE", _GUICtrlComboBox_GetCurSel($cmbABMeetGE))

	If GUICtrlRead($chkABMeetDE) = $GUI_CHECKED Then
		IniWrite($config, "search", "ABMeetDE", 1)
	Else
		IniWrite($config, "search", "ABMeetDE", 0)
	EndIf

	If GUICtrlRead($chkABMeetTrophy) = $GUI_CHECKED Then
		IniWrite($config, "search", "ABMeetTrophy", 1)
	Else
		IniWrite($config, "search", "ABMeetTrophy", 0)
	EndIf

	If GUICtrlRead($chkABMeetTH) = $GUI_CHECKED Then
		IniWrite($config, "search", "ABMeetTH", 1)
	Else
		IniWrite($config, "search", "ABMeetTH", 0)
	EndIf

	If GUICtrlRead($chkABMeetTHO) = $GUI_CHECKED Then
		IniWrite($config, "search", "ABMeetTHO", 1)
	Else
		IniWrite($config, "search", "ABMeetTHO", 0)
	EndIf

	If GUICtrlRead($chkABWeakBase) = $GUI_CHECKED Then
		IniWrite($config, "search", "ABWeakBase", 1)
	Else
		IniWrite($config, "search", "ABWeakBase", 0)
	EndIf

	If GUICtrlRead($chkABMeetOne) = $GUI_CHECKED Then
		IniWrite($config, "search", "ABMeetOne", 1)
	Else
		IniWrite($config, "search", "ABMeetOne", 0)
	EndIf

	IniWrite($config, "search", "ABEnableAfterCount", GUICtrlRead($txtABEnableAfter))
	IniWrite($config, "search", "ABsearchGold", GUICtrlRead($txtABMinGold))
	IniWrite($config, "search", "ABsearchElixir", GUICtrlRead($txtABMinElixir))
	IniWrite($config, "search", "ABsearchGoldPlusElixir", GUICtrlRead($txtABMinGoldPlusElixir))
	IniWrite($config, "search", "ABsearchDark", GUICtrlRead($txtABMinDarkElixir))
	IniWrite($config, "search", "ABsearchTrophy", GUICtrlRead($txtABMinTrophy))
	IniWrite($config, "search", "ABTHLevel", _GUICtrlComboBox_GetCurSel($cmbABTH))
	IniWrite($config, "search", "ABWeakMortar", _GUICtrlComboBox_GetCurSel($cmbABWeakMortar))
	IniWrite($config, "search", "ABWeakWizTower", _GUICtrlComboBox_GetCurSel($cmbABWeakWizTower))

	If GUICtrlRead($chkSearchReduction) = $GUI_CHECKED Then
		IniWrite($config, "search", "reduction", 1)
	Else
		IniWrite($config, "search", "reduction", 0)
	EndIf

	IniWrite($config, "search", "reduceCount", GUICtrlRead($txtSearchReduceCount))
	IniWrite($config, "search", "reduceGold", GUICtrlRead($txtSearchReduceGold))
	IniWrite($config, "search", "reduceElixir", GUICtrlRead($txtSearchReduceElixir))
	IniWrite($config, "search", "reduceGoldPlusElixir", GUICtrlRead($txtSearchReduceGoldPlusElixir))
	IniWrite($config, "search", "reduceDark", GUICtrlRead($txtSearchReduceDark))
	IniWrite($config, "search", "reduceTrophy", GUICtrlRead($txtSearchReduceTrophy))

	If GUICtrlRead($ChkRestartSearchLimit) = $GUI_CHECKED Then
		IniWrite($config, "search", "ChkRestartSearchLimit", 1)
	Else
		IniWrite($config, "search", "ChkRestartSearchLimit", 0)
	EndIf
	IniWrite($config, "search", "RestartSearchLimit", GUICtrlRead($TxtRestartSearchlimit))


	;Attack Basic Settings-------------------------------------------------------------------------
	IniWrite($config, "attack", "DBDeploy", _GUICtrlComboBox_GetCurSel($cmbDBDeploy))
	IniWrite($config, "attack", "DBUnitD", _GUICtrlComboBox_GetCurSel($cmbDBUnitDelay))
	IniWrite($config, "attack", "DBWaveD", _GUICtrlComboBox_GetCurSel($cmbDBWaveDelay))
	IniWrite($config, "attack", "DBRandomSpeedAtk", GUICtrlRead($chkDBRandomSpeedAtk))
	IniWrite($config, "attack", "DBSelectTroop", _GUICtrlComboBox_GetCurSel($cmbDBSelectTroop))

	If GUICtrlRead($chkDBSmartAttackRedArea) = $GUI_CHECKED Then
		IniWrite($config, "attack", "DBSmartAttackRedArea", 1)
	Else
		IniWrite($config, "attack", "DBSmartAttackRedArea", 0)
	EndIf

	IniWrite($config, "attack", "DBSmartAttackDeploy", _GUICtrlComboBox_GetCurSel($cmbDBSmartDeploy))

	If GUICtrlRead($chkDBAttackNearGoldMine) = $GUI_CHECKED Then
		IniWrite($config, "attack", "DBSmartAttackGoldMine", 1)
	Else
		IniWrite($config, "attack", "DBSmartAttackGoldMine", 0)
	EndIf

	If GUICtrlRead($chkDBAttackNearElixirCollector) = $GUI_CHECKED Then
		IniWrite($config, "attack", "DBSmartAttackElixirCollector", 1)
	Else
		IniWrite($config, "attack", "DBSmartAttackElixirCollector", 0)
	EndIf

	If GUICtrlRead($chkDBAttackNearDarkElixirDrill) = $GUI_CHECKED Then
		IniWrite($config, "attack", "DBSmartAttackDarkElixirDrill", 1)
	Else
		IniWrite($config, "attack", "DBSmartAttackDarkElixirDrill", 0)
	EndIf

	IniWrite($config, "attack", "ABDeploy", _GUICtrlComboBox_GetCurSel($cmbABDeploy))
	IniWrite($config, "attack", "ABUnitD", _GUICtrlComboBox_GetCurSel($cmbABUnitDelay))
	IniWrite($config, "attack", "ABWaveD", _GUICtrlComboBox_GetCurSel($cmbABWaveDelay))
	IniWrite($config, "attack", "ABRandomSpeedAtk", GUICtrlRead($chkABRandomSpeedAtk))
	IniWrite($config, "attack", "ABSelectTroop", _GUICtrlComboBox_GetCurSel($cmbABSelectTroop))

	If GUICtrlRead($chkABSmartAttackRedArea) = $GUI_CHECKED Then
		IniWrite($config, "attack", "ABSmartAttackRedArea", 1)
	Else
		IniWrite($config, "attack", "ABSmartAttackRedArea", 0)
	EndIf

	IniWrite($config, "attack", "ABSmartAttackDeploy", _GUICtrlComboBox_GetCurSel($cmbABSmartDeploy))

	If GUICtrlRead($chkABAttackNearGoldMine) = $GUI_CHECKED Then
		IniWrite($config, "attack", "ABSmartAttackGoldMine", 1)
	Else
		IniWrite($config, "attack", "ABSmartAttackGoldMine", 0)
	EndIf

	If GUICtrlRead($chkABAttackNearElixirCollector) = $GUI_CHECKED Then
		IniWrite($config, "attack", "ABSmartAttackElixirCollector", 1)
	Else
		IniWrite($config, "attack", "ABSmartAttackElixirCollector", 0)
	EndIf

	If GUICtrlRead($chkABAttackNearDarkElixirDrill) = $GUI_CHECKED Then
		IniWrite($config, "attack", "ABSmartAttackDarkElixirDrill", 1)
	Else
		IniWrite($config, "attack", "ABSmartAttackDarkElixirDrill", 0)
	EndIf

	If GUICtrlRead($chkDBKingAttack) = $GUI_CHECKED Then
		IniWrite($config, "attack", "DBKingAtk", 1)
	Else
		IniWrite($config, "attack", "DBKingAtk", 0)
	EndIf
	If GUICtrlRead($chkABKingAttack) = $GUI_CHECKED Then
		IniWrite($config, "attack", "ABKingAtk", 1)
	Else
		IniWrite($config, "attack", "ABKingAtk", 0)
	EndIf

	If GUICtrlRead($chkDBQueenAttack) = $GUI_CHECKED Then
		IniWrite($config, "attack", "DBQueenAtk", 1)
	Else
		IniWrite($config, "attack", "DBQueenAtk", 0)
	EndIf
	If GUICtrlRead($chkABQueenAttack) = $GUI_CHECKED Then
		IniWrite($config, "attack", "ABQueenAtk", 1)
	Else
		IniWrite($config, "attack", "ABQueenAtk", 0)
	EndIf

	If GUICtrlRead($chkDBDropCC) = $GUI_CHECKED Then
		IniWrite($config, "attack", "DBDropCC", 1)
	Else
		IniWrite($config, "attack", "DBDropCC", 0)
	EndIf

	If GUICtrlRead($chkDBWardenAttack) = $GUI_CHECKED Then
		IniWrite($config, "attack", "DBWardenAtk", 1)
	Else
		IniWrite($config, "attack", "DBWardenAtk", 0)
	EndIf

	If GUICtrlRead($chkABWardenAttack) = $GUI_CHECKED Then
		IniWrite($config, "attack", "ABWardenAtk", 1)
	Else
		IniWrite($config, "attack", "ABWardenAtk", 0)
	EndIf

	If GUICtrlRead($chkABDropCC) = $GUI_CHECKED Then
		IniWrite($config, "attack", "ABDropCC", 1)
	Else
		IniWrite($config, "attack", "ABDropCC", 0)
	EndIf

	If GUICtrlRead($chkUseCCBalanced) = $GUI_CHECKED Then
		IniWrite($config, "attack", "BalanceCC", 1)
	Else
		IniWrite($config, "attack", "BalanceCC", 0)
	EndIf

	IniWrite($config, "attack", "BalanceCCDonated", _GUICtrlComboBox_GetCurSel($cmbCCDonated) + 1)
	IniWrite($config, "attack", "BalanceCCReceived", _GUICtrlComboBox_GetCurSel($cmbCCReceived) + 1)

	If GUICtrlRead($radManAbilities) = $GUI_CHECKED Then
		IniWrite($config, "attack", "ActivateKQ", "Manual")
	ElseIf GUICtrlRead($radAutoAbilities) = $GUI_CHECKED Then
		IniWrite($config, "attack", "ActivateKQ", "Auto")
	EndIf

	If GUICtrlRead($chkUseWardenAbility) = $GUI_CHECKED Then
		IniWrite($config, "attack", "ActivateWarden", 1)
	Else
		IniWrite($config, "attack", "ActivateWarden", 0)
	EndIf

	IniWrite($config, "attack", "delayActivateKQ", GUICtrlRead($txtManAbilities))
	IniWrite($config, "attack", "delayActivateW", GUICtrlRead($txtWardenAbility))

	If GUICtrlRead($chkTakeLootSS) = $GUI_CHECKED Then
		IniWrite($config, "attack", "TakeLootSnapShot", 1)
	Else
		IniWrite($config, "attack", "TakeLootSnapShot", 0)
	EndIf

	If GUICtrlRead($chkScreenshotLootInfo) = $GUI_CHECKED Then
		IniWrite($config, "attack", "ScreenshotLootInfo", 1)
	Else
		IniWrite($config, "attack", "ScreenshotLootInfo", 0)
	EndIf

	;End Battle Settings------------------------------------------------------------------------
	IniWrite($config, "endbattle", "txtTimeStopAtk", GUICtrlRead($txtTimeStopAtk))
	IniWrite($config, "endbattle", "chkTimeStopAtk", GUICtrlRead($chkTimeStopAtk))

	IniWrite($config, "endbattle", "txtTimeStopAtk2", GUICtrlRead($txtTimeStopAtk2))
	IniWrite($config, "endbattle", "chkTimeStopAtk2", GUICtrlRead($chkTimeStopAtk2))

	IniWrite($config, "endbattle", "txtMinGoldStopAtk2", GUICtrlRead($txtMinGoldStopAtk2))
	IniWrite($config, "endbattle", "txtMinElixirStopAtk2", GUICtrlRead($txtMinElixirStopAtk2))
	IniWrite($config, "endbattle", "txtMinDarkElixirStopAtk2", GUICtrlRead($txtMinDarkElixirStopAtk2))

	IniWrite($config, "endbattle", "chkEndOneStar", GUICtrlRead($chkEndOneStar))
	IniWrite($config, "endbattle", "chkEndTwoStars", GUICtrlRead($chkEndTwoStars))

	If GUICtrlRead($chkEndNoResources) = $GUI_CHECKED Then
		IniWrite($config, "endbattle", "chkEndNoResources", 1)
	Else
		IniWrite($config, "endbattle", "chkEndNoResources", 0)
	EndIf


	If GUICtrlRead($chkDESideEB) = $GUI_CHECKED Then
		IniWrite($config, "endbattle", "chkDESideEB", 1)
	Else
		IniWrite($config, "endbattle", "chkDESideEB", 0)
	EndIf
	IniWrite($config, "endbattle", "txtDELowEndMin", GUICtrlRead($txtDELowEndMin))
	If GUICtrlRead($chkDisableOtherEBO) = $GUI_CHECKED Then
		IniWrite($config, "endbattle", "chkDisableOtherEBO", 1)
	Else
		IniWrite($config, "endbattle", "chkDisableOtherEBO", 0)
	EndIf
	If GUICtrlRead($chkDEEndAq) = $GUI_CHECKED Then
		IniWrite($config, "endbattle", "chkDEEndAq", 1)
	Else
		IniWrite($config, "endbattle", "chkDEEndAq", 0)
	EndIf
	If GUICtrlRead($chkDEEndBk) = $GUI_CHECKED Then
		IniWrite($config, "endbattle", "chkDEEndBk", 1)
	Else
		IniWrite($config, "endbattle", "chkDEEndBk", 0)
	EndIf
	If GUICtrlRead($chkDEEndOneStar) = $GUI_CHECKED Then
		IniWrite($config, "endbattle", "chkDEEndOneStar", 1)
	Else
		IniWrite($config, "endbattle", "chkDEEndOneStar", 0)
	EndIf


	;Advanced Settings--------------------------------------------------------------------------
	If GUICtrlRead($chkAttackNow) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "attacknow", 1)
	Else
		IniWrite($config, "advanced", "attacknow", 0)
	EndIf
	IniWrite($config, "advanced", "attacknowdelay", _GUICtrlComboBox_GetCurSel($cmbAttackNowDelay) + 1)

	If GUICtrlRead($chkAttackTH) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "townhall", 1)
	Else
		IniWrite($config, "advanced", "townhall", 0)
	EndIf

	If GUICtrlRead($chkBullyMode) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "BullyMode", 1)
	Else
		IniWrite($config, "advanced", "BullyMode", 0)
	EndIf

	IniWrite($config, "advanced", "ATBullyMode", GUICtrlRead($txtATBullyMode))
	IniWrite($config, "advanced", "YourTH", _GUICtrlComboBox_GetCurSel($cmbYourTH))

	If GUICtrlRead($radUseDBAttack) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "THBullyAttackMode", 0)
	ElseIf GUICtrlRead($radUseLBAttack) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "THBullyAttackMode", 1)
	EndIf

	If GUICtrlRead($chkTrophyMode) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "TrophyMode", 1)
	Else
		IniWrite($config, "advanced", "TrophyMode", 0)
	EndIf

	IniWrite($config, "advanced", "THaddTiles", GUICtrlRead($txtTHaddtiles))
	IniWrite($config, "advanced", "AttackTHType", _GUICtrlComboBox_GetCurSel($cmbAttackTHType))
	$txtAttackTHType = GUICtrlRead($cmbAttackTHType)
	IniWrite($config, "advanced", "AttackTHType", $scmbAttackTHType)

	If GUICtrlRead($chkTSEnableAfter) = $GUI_CHECKED Then
		IniWrite($config, "search", "TSEnableAfter", 1)
	Else
		IniWrite($config, "search", "TSEnableAfter", 0)
	EndIf
	IniWrite($config, "search", "TSMeetGE", _GUICtrlComboBox_GetCurSel($cmbTSMeetGE))
	IniWrite($config, "search", "TSEnableAfterCount", GUICtrlRead($txtTSEnableAfter))
	IniWrite($config, "search", "TSsearchGold", GUICtrlRead($txtTSMinGold))
	IniWrite($config, "search", "TSsearchElixir", GUICtrlRead($txtTSMinElixir))
	IniWrite($config, "search", "TSsearchGoldPlusElixir", GUICtrlRead($txtTSMinGoldPlusElixir))
	IniWrite($config, "search", "TSsearchDark", GUICtrlRead($txtTSMinDarkElixir))

	If GUICtrlRead($chkUseKingTH) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "UseKingTH", 1)
	Else
		IniWrite($config, "advanced", "UseKingTH", 0)
	EndIf

	If GUICtrlRead($chkUseQueenTH) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "UseQueenTH", 1)
	Else
		IniWrite($config, "advanced", "UseQueenTH", 0)
	EndIf

	If GUICtrlRead($chkUseClastleTH) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "UseCastleTH", 1)
	Else
		IniWrite($config, "advanced", "UseCastleTH", 0)
	EndIf

	If GUICtrlRead($chkUseLSpellsTH) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "UseLspellTH", 1)
	Else
		IniWrite($config, "advanced", "UseLspellTH", 0)
	EndIf

	If GUICtrlRead($chkUseRSpellsTH) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "UseRspellTH", 1)
	Else
		IniWrite($config, "advanced", "UseRspellTH", 0)
	EndIf

	If GUICtrlRead($chkUseHSpellsTH) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "UseHspellTH", 1)
	Else
		IniWrite($config, "advanced", "UseHspellTH", 0)
	EndIf


	If GUICtrlRead($chkAlertPBVillage) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "AlertPBVillage", 1)
	Else
		IniWrite($config, "advanced", "AlertPBVillage", 0)
	EndIf

	If GUICtrlRead($chkAlertPBLastRaidTxt) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "AlertPBLastRaidTxt", 1)
	Else
		IniWrite($config, "pushbullet", "AlertPBLastRaidTxt", 0)
	EndIf


	If GUICtrlRead($chkAlertPBLastAttack) = $GUI_CHECKED Then
		IniWrite($config, "advanced", "AlertPBLastAttack", 1)
	Else
		IniWrite($config, "advanced", "AlertPBLastAttack", 0)
	EndIf


	If GUICtrlRead($chkAlertPBCampFull) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "AlertCampFull", 1)
	Else
		IniWrite($config, "pushbullet", "AlertCampFull", 0)
	EndIf
	;	If  GUICtrlRead($chkUnbreakable) = $GUI_CHECKED Then
	;		IniWrite($config, "advanced", "chkUnbreakable", 1)
	;	Else
	;		IniWrite($config, "advanced", "chkUnbreakable", 0)
	;	EndIf
	IniWrite($config, "advanced", "UnbreakableWait", GUICtrlRead($txtUnbreakable))
	IniWrite($config, "advanced", "minUnBrkgold", GUICtrlRead($txtUnBrkMinGold))
	IniWrite($config, "advanced", "minUnBrkelixir", GUICtrlRead($txtUnBrkMinElixir))
	IniWrite($config, "advanced", "minUnBrkdark", GUICtrlRead($txtUnBrkMinDark))

	IniWrite($config, "advanced", "maxUnBrkgold", GUICtrlRead($txtUnBrkMaxGold))
	IniWrite($config, "advanced", "maxUnBrkelixir", GUICtrlRead($txtUnBrkMaxElixir))
	IniWrite($config, "advanced", "maxUnBrkdark", GUICtrlRead($txtUnBrkMaxDark))

	;atk their king
	;attk their queen

	;Donate Settings-------------------------------------------------------------------------
	If GUICtrlRead($chkRequest) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkRequest", 1)
	Else
		IniWrite($config, "donate", "chkRequest", 0)
	EndIf

	IniWrite($config, "donate", "txtRequest", GUICtrlRead($txtRequest))

	If GUICtrlRead($chkDonateBarbarians) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateBarbarians", 1)
	Else
		IniWrite($config, "donate", "chkDonateBarbarians", 0)
	EndIf

	If GUICtrlRead($chkDonateAllBarbarians) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllBarbarians", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllBarbarians", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateBarbarians", StringReplace(GUICtrlRead($txtDonateBarbarians), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistBarbarians", StringReplace(GUICtrlRead($txtBlacklistBarbarians), @CRLF, "|"))

	If GUICtrlRead($chkDonateArchers) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateArchers", 1)
	Else
		IniWrite($config, "donate", "chkDonateArchers", 0)
	EndIf

	If GUICtrlRead($chkDonateAllArchers) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllArchers", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllArchers", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateArchers", StringReplace(GUICtrlRead($txtDonateArchers), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistArchers", StringReplace(GUICtrlRead($txtBlacklistArchers), @CRLF, "|"))

	If GUICtrlRead($chkDonateGiants) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateGiants", 1)
	Else
		IniWrite($config, "donate", "chkDonateGiants", 0)
	EndIf

	If GUICtrlRead($chkDonateAllGiants) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllGiants", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllGiants", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateGiants", StringReplace(GUICtrlRead($txtDonateGiants), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistGiants", StringReplace(GUICtrlRead($txtBlacklistGiants), @CRLF, "|"))

	If GUICtrlRead($chkDonateGoblins) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateGoblins", 1)
	Else
		IniWrite($config, "donate", "chkDonateGoblins", 0)
	EndIf

	If GUICtrlRead($chkDonateAllGoblins) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllGoblins", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllGoblins", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateGoblins", StringReplace(GUICtrlRead($txtDonateGoblins), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistGoblins", StringReplace(GUICtrlRead($txtBlacklistGoblins), @CRLF, "|"))

	If GUICtrlRead($chkDonateWallBreakers) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateWallBreakers", 1)
	Else
		IniWrite($config, "donate", "chkDonateWallBreakers", 0)
	EndIf

	If GUICtrlRead($chkDonateAllWallBreakers) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllWallBreakers", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllWallBreakers", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateWallBreakers", StringReplace(GUICtrlRead($txtDonateWallBreakers), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistWallBreakers", StringReplace(GUICtrlRead($txtBlacklistWallBreakers), @CRLF, "|"))

	If GUICtrlRead($chkDonateBalloons) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateBalloons", 1)
	Else
		IniWrite($config, "donate", "chkDonateBalloons", 0)
	EndIf

	If GUICtrlRead($chkDonateAllBalloons) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllBalloons", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllBalloons", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateBalloons", StringReplace(GUICtrlRead($txtDonateBalloons), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistBalloons", StringReplace(GUICtrlRead($txtBlacklistBalloons), @CRLF, "|"))

	If GUICtrlRead($chkDonateWizards) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateWizards", 1)
	Else
		IniWrite($config, "donate", "chkDonateWizards", 0)
	EndIf

	If GUICtrlRead($chkDonateAllWizards) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllWizards", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllWizards", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateWizards", StringReplace(GUICtrlRead($txtDonateWizards), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistWizards", StringReplace(GUICtrlRead($txtBlacklistWizards), @CRLF, "|"))

	If GUICtrlRead($chkDonateHealers) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateHealers", 1)
	Else
		IniWrite($config, "donate", "chkDonateHealers", 0)
	EndIf

	If GUICtrlRead($chkDonateAllHealers) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllHealers", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllHealers", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateHealers", StringReplace(GUICtrlRead($txtDonateHealers), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistHealers", StringReplace(GUICtrlRead($txtBlacklistHealers), @CRLF, "|"))

	If GUICtrlRead($chkDonateDragons) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateDragons", 1)
	Else
		IniWrite($config, "donate", "chkDonateDragons", 0)
	EndIf

	If GUICtrlRead($chkDonateAllDragons) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllDragons", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllDragons", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateDragons", StringReplace(GUICtrlRead($txtDonateDragons), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistDragons", StringReplace(GUICtrlRead($txtBlacklistDragons), @CRLF, "|"))

	If GUICtrlRead($chkDonatePekkas) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonatePekkas", 1)
	Else
		IniWrite($config, "donate", "chkDonatePekkas", 0)
	EndIf

	If GUICtrlRead($chkDonateAllPekkas) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllPekkas", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllPekkas", 0)
	EndIf

	IniWrite($config, "donate", "txtDonatePekkas", StringReplace(GUICtrlRead($txtDonatePekkas), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistPekkas", StringReplace(GUICtrlRead($txtBlacklistPekkas), @CRLF, "|"))

	If GUICtrlRead($chkDonateMinions) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateMinions", 1)
	Else
		IniWrite($config, "donate", "chkDonateMinions", 0)
	EndIf

	If GUICtrlRead($chkDonateAllMinions) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllMinions", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllMinions", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateMinions", StringReplace(GUICtrlRead($txtDonateMinions), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistMinions", StringReplace(GUICtrlRead($txtBlacklistMinions), @CRLF, "|"))

	If GUICtrlRead($chkDonateHogRiders) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateHogRiders", 1)
	Else
		IniWrite($config, "donate", "chkDonateHogRiders", 0)
	EndIf

	If GUICtrlRead($chkDonateAllHogRiders) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllHogRiders", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllHogRiders", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateHogRiders", StringReplace(GUICtrlRead($txtDonateHogRiders), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistHogRiders", StringReplace(GUICtrlRead($txtBlacklistHogRiders), @CRLF, "|"))

	If GUICtrlRead($chkDonateValkyries) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateValkyries", 1)
	Else
		IniWrite($config, "donate", "chkDonateValkyries", 0)
	EndIf

	If GUICtrlRead($chkDonateAllValkyries) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllValkyries", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllValkyries", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateValkyries", StringReplace(GUICtrlRead($txtDonateValkyries), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistValkyries", StringReplace(GUICtrlRead($txtBlacklistValkyries), @CRLF, "|"))

	If GUICtrlRead($chkDonateGolems) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateGolems", 1)
	Else
		IniWrite($config, "donate", "chkDonateGolems", 0)
	EndIf

	If GUICtrlRead($chkDonateAllGolems) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllGolems", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllGolems", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateGolems", StringReplace(GUICtrlRead($txtDonateGolems), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistGolems", StringReplace(GUICtrlRead($txtBlacklistGolems), @CRLF, "|"))

	If GUICtrlRead($chkDonateWitches) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateWitches", 1)
	Else
		IniWrite($config, "donate", "chkDonateWitches", 0)
	EndIf

	If GUICtrlRead($chkDonateAllWitches) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllWitches", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllWitches", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateWitches", StringReplace(GUICtrlRead($txtDonateWitches), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistWitches", StringReplace(GUICtrlRead($txtBlacklistWitches), @CRLF, "|"))

	If GUICtrlRead($chkDonateLavaHounds) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateLavaHounds", 1)
	Else
		IniWrite($config, "donate", "chkDonateLavaHounds", 0)
	EndIf

	If GUICtrlRead($chkDonateAllLavaHounds) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllLavaHounds", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllLavaHounds", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateLavaHounds", StringReplace(GUICtrlRead($txtDonateLavaHounds), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistLavaHounds", StringReplace(GUICtrlRead($txtBlacklistLavaHounds), @CRLF, "|"))

	If GUICtrlRead($chkDonatePoisonSpells) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonatePoisonSpells", 1)
	Else
		IniWrite($config, "donate", "chkDonatePoisonSpells", 0)
	EndIf

	If GUICtrlRead($chkDonateAllPoisonSpells) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllPoisonSpells", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllPoisonSpells", 0)
	EndIf

	IniWrite($config, "donate", "txtDonatePoisonSpells", StringReplace(GUICtrlRead($txtDonatePoisonSpells), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistPoisonSpells", StringReplace(GUICtrlRead($txtBlacklistPoisonSpells), @CRLF, "|"))

	If GUICtrlRead($chkDonateEarthQuakeSpells) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateEarthQuakeSpells", 1)
	Else
		IniWrite($config, "donate", "chkDonateEarthQuakeSpells", 0)
	EndIf

	If GUICtrlRead($chkDonateAllEarthQuakeSpells) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllEarthQuakeSpells", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllEarthQuakeSpells", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateEarthQuakeSpells", StringReplace(GUICtrlRead($txtDonateEarthQuakeSpells), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistEarthQuakeSpells", StringReplace(GUICtrlRead($txtBlacklistEarthQuakeSpells), @CRLF, "|"))

	If GUICtrlRead($chkDonateHasteSpells) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateHasteSpells", 1)
	Else
		IniWrite($config, "donate", "chkDonateHasteSpells", 0)
	EndIf

	If GUICtrlRead($chkDonateAllHasteSpells) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllHasteSpells", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllHasteSpells", 0)
	EndIf

	IniWrite($config, "donate", "txtDonateHasteSpells", StringReplace(GUICtrlRead($txtDonateHasteSpells), @CRLF, "|"))
	IniWrite($config, "donate", "txtBlacklistHasteSpells", StringReplace(GUICtrlRead($txtBlacklistHasteSpells), @CRLF, "|"))

	;;; Custom Combination Donate by ChiefM3
	If GUICtrlRead($chkDonateCustom) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateCustom", 1)
	Else
		IniWrite($config, "donate", "chkDonateCustom", 0)
	EndIf
	If GUICtrlRead($chkDonateAllCustom) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkDonateAllCustom", 1)
	Else
		IniWrite($config, "donate", "chkDonateAllCustom", 0)
	EndIf
	IniWrite($config, "donate", "txtDonateCustom", StringReplace(GUICtrlRead($txtDonateCustom), @CRLF, "|"))

	IniWrite($config, "donate", "txtBlacklistCustom", StringReplace(GUICtrlRead($txtBlacklistCustom), @CRLF, "|"))

	IniWrite($config, "donate", "cmbDonateCustom1", _GUICtrlComboBox_GetCurSel($cmbDonateCustom1))
	IniWrite($config, "donate", "txtDonateCustom1", GUICtrlRead($txtDonateCustom1))
	IniWrite($config, "donate", "cmbDonateCustom2", _GUICtrlComboBox_GetCurSel($cmbDonateCustom2))
	IniWrite($config, "donate", "txtDonateCustom2", GUICtrlRead($txtDonateCustom2))
	IniWrite($config, "donate", "cmbDonateCustom3", _GUICtrlComboBox_GetCurSel($cmbDonateCustom3))
	IniWrite($config, "donate", "txtDonateCustom3", GUICtrlRead($txtDonateCustom3))
	IniWrite($config, "donate", "txtBlacklist", StringReplace(GUICtrlRead($txtBlacklist), @CRLF, "|"))

	; Extra Alphabets , Cyrillic.
	If GUICtrlRead($chkExtraAlphabets) = $GUI_CHECKED Then
		IniWrite($config, "donate", "chkExtraAlphabets", 1)
	Else
		IniWrite($config, "donate", "chkExtraAlphabets", 0)
	EndIf

	;Troop Settings--------------------------------------------------------------------------
	IniWrite($config, "troop", "TroopComposition", _GUICtrlComboBox_GetCurSel($cmbTroopComp))

	For $i = 0 To UBound($TroopName) - 1
		IniWrite($config, "troop", $TroopName[$i], GUICtrlRead(Eval("txtNum" & $TroopName[$i])))
	Next
	For $i = 0 To UBound($TroopDarkName) - 1
		IniWrite($config, "troop", $TroopDarkName[$i], GUICtrlRead(Eval("txtNum" & $TroopDarkName[$i])))
	Next

	IniWrite($config, "troop", "troop1", _GUICtrlComboBox_GetCurSel($cmbBarrack1))
	IniWrite($config, "troop", "troop2", _GUICtrlComboBox_GetCurSel($cmbBarrack2))
	IniWrite($config, "troop", "troop3", _GUICtrlComboBox_GetCurSel($cmbBarrack3))
	IniWrite($config, "troop", "troop4", _GUICtrlComboBox_GetCurSel($cmbBarrack4))

	IniWrite($config, "troop", "fulltroop", GUICtrlRead($txtFullTroop))
	IniWrite($config, "troop", "TrainITDelay", GUICtrlRead($sldTrainITDelay))

	;barracks boost not saved (no use)

	; Spells Creation  ---------------------------------------------------------------------
	IniWrite($config, "Spells", "LightningSpell", GUICtrlRead($txtNumLightningSpell))
	IniWrite($config, "Spells", "RageSpell", GUICtrlRead($txtNumRageSpell))
	IniWrite($config, "Spells", "HealSpell", GUICtrlRead($txtNumHealSpell))
	IniWrite($config, "Spells", "PoisonSpell", GUICtrlRead($txtNumPoisonSpell))
	IniWrite($config, "Spells", "HasteSpell", GUICtrlRead($txtNumHasteSpell))
	IniWrite($config, "Spells", "SpellFactory", GUICtrlRead($txtTotalCountSpell))

	;Misc Settings--------------------------------------------------------------------------
	If $ichkWalls = 1 Then
		IniWrite($config, "other", "auto-wall", 1)
	Else
		IniWrite($config, "other", "auto-wall", 0)
	EndIf

	If GUICtrlRead($UseGold) = $GUI_CHECKED Then
		IniWrite($config, "other", "use-storage", 0)
	ElseIf GUICtrlRead($UseElixir) = $GUI_CHECKED Then
		IniWrite($config, "other", "use-storage", 1)
	ElseIf GUICtrlRead($UseElixirGold) = $GUI_CHECKED Then
		IniWrite($config, "other", "use-storage", 2)
	EndIf

	If $iSaveWallBldr = 1 Then
		IniWrite($config, "other", "savebldr", 1)
	Else
		IniWrite($config, "other", "savebldr", 0)
	EndIf

	IniWrite($config, "other", "walllvl", _GUICtrlComboBox_GetCurSel($cmbWalls))
	IniWrite($config, "other", "MaxNbWall", GUICtrlRead($sldMaxNbWall))

	IniWrite($config, "other", "minwallgold", GUICtrlRead($txtWallMinGold))
	IniWrite($config, "other", "minwallelixir", GUICtrlRead($txtWallMinElixir))

	IniWrite($config, "other", "minrestartgold", GUICtrlRead($txtRestartGold))
	IniWrite($config, "other", "minrestartelixir", GUICtrlRead($txtRestartElixir))
	IniWrite($config, "other", "minrestartdark", GUICtrlRead($txtRestartDark))


	If GUICtrlRead($chkTrap) = $GUI_CHECKED Then
		IniWrite($config, "other", "chkTrap", 1)
	Else
		IniWrite($config, "other", "chkTrap", 0)
	EndIf
	If GUICtrlRead($chkCollect) = $GUI_CHECKED Then
		IniWrite($config, "other", "chkCollect", 1)
	Else
		IniWrite($config, "other", "chkCollect", 0)
	EndIf
	If GUICtrlRead($chkTombstones) = $GUI_CHECKED Then
		IniWrite($config, "other", "chkTombstones", 1)
	Else
		IniWrite($config, "other", "chkTombstones", 0)
	EndIf
	IniWrite($config, "other", "txtTimeWakeUp", GUICtrlRead($txtTimeWakeUp))
	IniWrite($config, "other", "VSDelay", GUICtrlRead($sldVSDelay))
	IniWrite($config, "other", "MaxVSDelay", GUICtrlRead($sldMaxVSDelay))

	IniWrite($config, "other", "MaxTrophy", GUICtrlRead($txtMaxTrophy))
	IniWrite($config, "other", "MinTrophy", GUICtrlRead($txtdropTrophy))
	If GUICtrlRead($chkTrophyHeroes) = $GUI_CHECKED Then
		IniWrite($config, "other", "chkTrophyHeroes", 1)
	Else
		IniWrite($config, "other", "chkTrophyHeroes", 0)
	EndIf

	If GUICtrlRead($chkTrophyAtkDead) = $GUI_CHECKED Then
		IniWrite($config, "other", "chkTrophyAtkDead", 1)
	Else
		IniWrite($config, "other", "chkTrophyAtkDead", 0)
	EndIf
	IniWrite($config, "other", "DTArmyMin", GUICtrlRead($txtDTArmyMin))

	;laboratory
	If GUICtrlRead($chkLab) = $GUI_CHECKED Then
		IniWrite($config, "upgrade", "upgradetroops", 1)
	Else
		IniWrite($config, "upgrade", "upgradetroops", 0)
	EndIf
	IniWrite($config, "upgrade", "upgradetroopname", _GUICtrlComboBox_GetCurSel($cmbLaboratory))
	IniWrite($building, "upgrade", "LabPosX", $aLabPos[0])
	IniWrite($building, "upgrade", "LabPosY", $aLabPos[1])
	;Heroes upgrade
	If GUICtrlRead($chkUpgradeKing) = $GUI_CHECKED Then
		IniWrite($config, "upgrade", "UpgradeKing", "1")
	Else
		IniWrite($config, "upgrade", "UpgradeKing", "0")
	EndIf

	If GUICtrlRead($chkUpgradeQueen) = $GUI_CHECKED Then
		IniWrite($config, "upgrade", "UpgradeQueen", "1")
	Else
		IniWrite($config, "upgrade", "UpgradeQueen", "0")
	EndIf

	;

	For $iz = 0 To 5 ; Save Upgrades data
		IniWrite($building, "upgrade", "xupgrade" & $iz, $aUpgrades[$iz][0])
		IniWrite($building, "upgrade", "yupgrade" & $iz, $aUpgrades[$iz][1])
		IniWrite($building, "upgrade", "upgradevalue" & $iz, $aUpgrades[$iz][2])
		IniWrite($building, "upgrade", "upgradetype" & $iz, $aUpgrades[$iz][3])
		IniWrite($building, "upgrade", "upgradestatusicon" & $iz, $ipicUpgradeStatus[$iz])
		If GUICtrlRead($chkbxUpgrade[$iz]) = $GUI_CHECKED Then
			IniWrite($building, "upgrade", "upgradechk" & $iz, 1)
		Else
			IniWrite($building, "upgrade", "upgradechk" & $iz, 0)
		EndIf
	Next
	IniWrite($building, "upgrade", "minupgrgold", GUICtrlRead($txtUpgrMinGold))
	IniWrite($building, "upgrade", "minupgrelixir", GUICtrlRead($txtUpgrMinElixir))
	IniWrite($building, "upgrade", "minupgrdark", GUICtrlRead($txtUpgrMinDark))

	IniWrite($building, "other", "xTownHall", $TownHallPos[0])
	IniWrite($building, "other", "yTownHall", $TownHallPos[1])
	IniWrite($building, "other", "LevelTownHall", $iTownHallLevel)

	IniWrite($building, "other", "xCCPos", $aCCPos[0])
	IniWrite($building, "other", "yCCPos", $aCCPos[1])

	IniWrite($building, "other", "xArmy", $ArmyPos[0])
	IniWrite($building, "other", "yArmy", $ArmyPos[1])
	IniWrite($building, "other", "totalcamp", $TotalCamp)

	;IniWrite($building, "other", "barrackNum", $barrackNum)
	;IniWrite($building, "other", "barrackDarkNum", $barrackDarkNum)

	IniWrite($building, "other", "listResource", $listResourceLocation)


	IniWrite($building, "other", "xBarrack1", $barrackPos[0][0])
	IniWrite($building, "other", "yBarrack1", $barrackPos[0][1])

	IniWrite($building, "other", "xBarrack2", $barrackPos[1][0])
	IniWrite($building, "other", "yBarrack2", $barrackPos[1][1])

	IniWrite($building, "other", "xBarrack3", $barrackPos[2][0])
	IniWrite($building, "other", "yBarrack3", $barrackPos[2][1])

	IniWrite($building, "other", "xBarrack4", $barrackPos[3][0])
	IniWrite($building, "other", "yBarrack4", $barrackPos[3][1])


	IniWrite($building, "other", "xspellfactory", $SFPos[0])
	IniWrite($building, "other", "yspellfactory", $SFPos[1])

	IniWrite($building, "other", "xDspellfactory", $DSFPos[0])
	IniWrite($building, "other", "yDspellfactory", $DSFPos[1])

	IniWrite($building, "other", "xKingAltarPos", $KingAltarPos[0])
	IniWrite($building, "other", "yKingAltarPos", $KingAltarPos[1])

	IniWrite($building, "other", "xQueenAltarPos", $QueenAltarPos[0])
	IniWrite($building, "other", "yQueenAltarPos", $QueenAltarPos[1])

	IniWrite($building, "other", "xWardenAltarPos", $WardenAltarPos[0])
	IniWrite($building, "other", "yWardenAltarPos", $WardenAltarPos[1])


	;PushBullet Settings----------------------------------------
	IniWrite($config, "pushbullet", "AccountToken", GUICtrlRead($PushBTokenValue))
	IniWrite($config, "pushbullet", "OrigPushB", GUICtrlRead($txtVillageName))

	If GUICtrlRead($chkAlertPBVillage) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "AlertPBVillage", 1)
	Else
		IniWrite($config, "pushbullet", "AlertPBVillage", 0)
	EndIf

	If GUICtrlRead($chkAlertPBLastAttack) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "AlertPBLastAttack", 1)
	Else
		IniWrite($config, "pushbullet", "AlertPBLastAttack", 0)
	EndIf

	If GUICtrlRead($chkPBenabled) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "PBEnabled", 1)
	Else
		IniWrite($config, "pushbullet", "PBEnabled", 0)
	EndIf

	If GUICtrlRead($chkPBRemote) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "PBRemote", 1)
	Else
		IniWrite($config, "pushbullet", "PBRemote", 0)
	EndIf

	If GUICtrlRead($chkDeleteAllPushes) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "DeleteAllPBPushes", 1)
	Else
		IniWrite($config, "pushbullet", "DeleteAllPBPushes", 0)
	EndIf

	If GUICtrlRead($chkAlertPBVMFound) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "AlertPBVMFound", 1)
	Else
		IniWrite($config, "pushbullet", "AlertPBVMFound", 0)
	EndIf

	If GUICtrlRead($chkAlertPBLastRaid) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "AlertPBLastRaid", 1)
	Else
		IniWrite($config, "pushbullet", "AlertPBLastRaid", 0)
	EndIf

	If GUICtrlRead($chkAlertPBWallUpgrade) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "AlertPBWallUpgrade", 1)
	Else
		IniWrite($config, "pushbullet", "AlertPBWallUpgrade", 0)
	EndIf

	If GUICtrlRead($chkAlertPBOOS) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "AlertPBOOS", 1)
	Else
		IniWrite($config, "pushbullet", "AlertPBOOS", 0)
	EndIf

	If GUICtrlRead($chkAlertPBVBreak) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "AlertPBVBreak", 1)
	Else
		IniWrite($config, "pushbullet", "AlertPBVBreak", 0)
	EndIf

	If GUICtrlRead($chkAlertPBOtherDevice) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "AlertPBOtherDevice", 1)
	Else
		IniWrite($config, "pushbullet", "AlertPBOtherDevice", 0)
	EndIf

	IniWrite($config, "pushbullet", "HoursPushBullet", _GUICtrlComboBox_GetCurSel($cmbHoursPushBullet) + 1)

	If GUICtrlRead($chkDeleteOldPushes) = $GUI_CHECKED Then
		IniWrite($config, "pushbullet", "DeleteOldPushes", 1)
	Else
		IniWrite($config, "pushbullet", "DeleteOldPushes", 0)
	EndIf

	IniWrite($config, "other", "WAOffsetX", GUICtrlRead($txtWAOffsetX))
	IniWrite($config, "other", "WAOffsetY", GUICtrlRead($txtWAOffsetY))


	; delete Files
	If GUICtrlRead($chkDeleteLogs) = $GUI_CHECKED Then
		IniWrite($config, "deletefiles", "DeleteLogs", 1)
	Else
		IniWrite($config, "deletefiles", "DeleteLogs", 0)
	EndIf
	IniWrite($config, "deletefiles", "DeleteLogsDays", GUICtrlRead($txtDeleteLogsDays))

	If GUICtrlRead($chkDeleteTemp) = $GUI_CHECKED Then
		IniWrite($config, "deletefiles", "DeleteTemp", 1)
	Else
		IniWrite($config, "deletefiles", "DeleteTemp", 0)
	EndIf
	IniWrite($config, "deletefiles", "DeleteTempDays", GUICtrlRead($txtDeleteTempDays))

	If GUICtrlRead($chkDeleteLoots) = $GUI_CHECKED Then
		IniWrite($config, "deletefiles", "DeleteLoots", 1)
	Else
		IniWrite($config, "deletefiles", "DeleteLoots", 0)
	EndIf
	IniWrite($config, "deletefiles", "DeleteLootsDays", GUICtrlRead($txtDeleteLootsDays))

	; planned
	If GUICtrlRead($chkRequestCCHours) = $GUI_CHECKED Then
		IniWrite($config, "planned", "RequestHoursEnable", 1)
	Else
		IniWrite($config, "planned", "RequestHoursEnable", 0)
	EndIf
	If GUICtrlRead($chkDonateHours) = $GUI_CHECKED Then
		IniWrite($config, "planned", "DonateHoursEnable", 1)
	Else
		IniWrite($config, "planned", "DonateHoursEnable", 0)
	EndIf
	If GUICtrlRead($chkDropCCHours) = $GUI_CHECKED Then
		IniWrite($config, "planned", "DropCCEnable", 1)
	Else
		IniWrite($config, "planned", "DropCCEnable", 0)
	EndIf

	If GUICtrlRead($chkBoostBarracksHours) = $GUI_CHECKED Then
		IniWrite($config, "planned", "BoostBarracksHoursEnable", 1)
	Else
		IniWrite($config, "planned", "BoostBarracksHoursEnable", 0)
	EndIf

	Local $string = ""
	For $i = 0 To 23
		If GUICtrlRead(Eval("chkDonateHours" & $i)) = $GUI_CHECKED Then
			$string &= "1|"
		Else
			$string &= "0|"
		EndIf
	Next
	IniWrite($config, "planned", "DonateHours", $string)

	Local $string = ""
	For $i = 0 To 23
		If GUICtrlRead(Eval("chkRequestCCHours" & $i)) = $GUI_CHECKED Then
			$string &= "1|"
		Else
			$string &= "0|"
		EndIf
	Next
	IniWrite($config, "planned", "RequestHours", $string)

	Local $string = ""
	For $i = 0 To 23
		If GUICtrlRead(Eval("chkDropCCHours" & $i)) = $GUI_CHECKED Then
			$string &= "1|"
		Else
			$string &= "0|"
		EndIf
	Next
	IniWrite($config, "planned", "DropCCHours", $string)

	Local $string = ""
	For $i = 0 To 23
		If GUICtrlRead(Eval("chkBoostBarracksHours" & $i)) = $GUI_CHECKED Then
			$string &= "1|"
		Else
			$string &= "0|"
		EndIf
	Next
	IniWrite($config, "planned", "BoostBarracksHours", $string)


	;Share Attack Settings----------------------------------------
	IniWrite($config, "shareattack", "minGold", GUICtrlRead($txtShareMinGold))
	IniWrite($config, "shareattack", "minElixir", GUICtrlRead($txtShareMinElixir))
	IniWrite($config, "shareattack", "minDark", GUICtrlRead($txtShareMinDark))
	IniWrite($config, "shareattack", "Message", StringReplace(GUICtrlRead($txtShareMessage), @CRLF, "|"))
	If GUICtrlRead($chkShareAttack) = $GUI_CHECKED Then
		IniWrite($config, "shareattack", "ShareAttack", 1)
	Else
		IniWrite($config, "shareattack", "ShareAttack", 0)
	EndIf




	;screenshot
	If GUICtrlRead($chkScreenshotType) = $GUI_CHECKED Then
		IniWrite($config, "other", "ScreenshotType", 1)
	Else
		IniWrite($config, "other", "ScreenshotType", 0)
	EndIf

	If GUICtrlRead($chkScreenshotHideName) = $GUI_CHECKED Then
		IniWrite($config, "other", "ScreenshotHideName", 1)
	Else
		IniWrite($config, "other", "ScreenshotHideName", 0)
	EndIf


	; debug
	If GUICtrlRead($chkDebugClick) = $GUI_CHECKED Then
		IniWrite($config, "debug", "debugClick", 1)
	Else
		IniWrite($config, "debug", "debugClick", 0)
	EndIf

	If $DevMode = 1 Then
		If GUICtrlRead($chkDebugSetLog) = $GUI_CHECKED Then
			IniWrite($config, "debug", "debugsetlog", 1)
		Else
			IniWrite($config, "debug", "debugsetlog", 0)
		EndIf
		If GUICtrlRead($chkDebugOcr) = $GUI_CHECKED Then
			IniWrite($config, "debug", "debugocr", 1)
		Else
			IniWrite($config, "debug", "debugocr", 0)
		EndIf
		If GUICtrlRead($chkDebugImageSave) = $GUI_CHECKED Then
			IniWrite($config, "debug", "debugimagesave", 1)
		Else
			IniWrite($config, "debug", "debugimagesave", 0)
		EndIf
		If GUICtrlRead($chkdebugBuildingPos) = $GUI_CHECKED Then
			IniWrite($config, "debug", "debugbuildingpos", 1)
		Else
			IniWrite($config, "debug", "debugbuildingpos", 0)
		EndIf
		If GUICtrlRead($chkmakeIMGCSV) = $GUI_CHECKED Then
			IniWrite($config, "debug", "debugmakeimgcsv", 1)
		Else
			IniWrite($config, "debug", "debugmakeimgcsv", 0)
		EndIf
	Else
		IniDelete($config, "debug", "debugocr")
		IniDelete($config, "debug", "debugsetlog")
		IniDelete($config, "debug", "debugimagesave")
		IniDelete($config, "debug", "debugbuildingpos")
	EndIf

	;forced Total Camp values
	If GUICtrlRead($ChkTotalCampForced) = $GUI_CHECKED Then
		IniWrite($config, "other", "ChkTotalCampForced", 1)
	Else
		IniWrite($config, "other", "ChkTotalCampForced", 0)
	EndIf
	IniWrite($config, "other", "ValueTotalCampForced", GUICtrlRead($txtTotalCampForced))


	If GUICtrlRead($ChkLanguage) = $GUI_CHECKED Then
		IniWrite($config, "General", "ChkLanguage", 1)
	Else
		IniWrite($config, "General", "ChkLanguage", 0)
	EndIf

	If GUICtrlRead($chkVersion) = $GUI_CHECKED Then
		IniWrite($config, "General", "ChkVersion", 1)
	Else
		IniWrite($config, "General", "ChkVersion", 0)
	EndIf


	;Snipe While Train
	If GUICtrlRead($chkSnipeWhileTrain) = $GUI_CHECKED Then
		IniWrite($config, "SnipeWhileTrain", "chkSnipeWhileTrain", 1)
	Else
		IniWrite($config, "SnipeWhileTrain", "chkSnipeWhileTrain", 0)
	EndIf
	IniWrite($config, "SnipeWhileTrain", "txtSearchlimit", GUICtrlRead($txtSearchlimit))
	IniWrite($config, "SnipeWhileTrain", "txtminArmyCapacityTHSnipe", GUICtrlRead($txtminArmyCapacityTHSnipe))
	IniWrite($config, "SnipeWhileTrain", "SWTtiles", GUICtrlRead($txtSWTTiles))

	;Multilanguage

	IniWrite($config, "other", "language", $sLanguage)

	If $ichkExtraAlphabets = 1 Then FileClose($config)

	SaveStatChkTownHall() ;call function save stats
	SaveStatChkDeadBase() ;call function save stats

	;AttackCSV
	If GUICtrlRead($chkDBKingAttackCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "DBKingAtk", 1)
	Else
		IniWrite($config, "attackCSV", "DBKingAtk", 0)
	EndIf
	If GUICtrlRead($chkABKingAttackCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ABKingAtk", 1)
	Else
		IniWrite($config, "attackCSV", "ABKingAtk", 0)
	EndIf

	If GUICtrlRead($chkDBQueenAttackCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "DBQueenAtk", 1)
	Else
		IniWrite($config, "attackCSV", "DBQueenAtk", 0)
	EndIf
	If GUICtrlRead($chkABQueenAttackCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ABQueenAtk", 1)
	Else
		IniWrite($config, "attackCSV", "ABQueenAtk", 0)
	EndIf

	If GUICtrlRead($chkDBDropCCCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "DBDropCC", 1)
	Else
		IniWrite($config, "attackCSV", "DBDropCC", 0)
	EndIf

	If GUICtrlRead($chkDBWardenAttackCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "DBWardenAtk", 1)
	Else
		IniWrite($config, "attackCSV", "DBWardenAtk", 0)
	EndIf

	If GUICtrlRead($chkABWardenAttackCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ABWardenAtk", 1)
	Else
		IniWrite($config, "attackCSV", "ABWardenAtk", 0)
	EndIf

	If GUICtrlRead($chkABDropCCCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ABDropCC", 1)
	Else
		IniWrite($config, "attackCSV", "ABDropCC", 0)
	EndIf

	If GUICtrlRead($chkUseCCBalancedCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "BalanceCC", 1)
	Else
		IniWrite($config, "attackCSV", "BalanceCC", 0)
	EndIf



	If GUICtrlRead($chkDBLightSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "DBLightSpell", 1)
	Else
		IniWrite($config, "attackCSV", "DBLightSpell", 0)
	EndIf
	If GUICtrlRead($chkABLightSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ABLightSpell", 1)
	Else
		IniWrite($config, "attackCSV", "ABLightSpell", 0)
	EndIf


	If GUICtrlRead($chkDBHealSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "DBHealSpell", 1)
	Else
		IniWrite($config, "attackCSV", "DBHealSpell", 0)
	EndIf
	If GUICtrlRead($chkABHealSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ABHealSpell", 1)
	Else
		IniWrite($config, "attackCSV", "ABHealSpell", 0)
	EndIf


	If GUICtrlRead($chkDBRageSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "DBRageSpell", 1)
	Else
		IniWrite($config, "attackCSV", "DBRageSpell", 0)
	EndIf
	If GUICtrlRead($chkABRageSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ABRageSpell", 1)
	Else
		IniWrite($config, "attackCSV", "ABRageSpell", 0)
	EndIf

	If GUICtrlRead($chkDBJumpSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "DBJumpSpell", 1)
	Else
		IniWrite($config, "attackCSV", "DBJumpSpell", 0)
	EndIf
	If GUICtrlRead($chkABJumpSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ABJumpSpell", 1)
	Else
		IniWrite($config, "attackCSV", "ABJumpSpell", 0)
	EndIf

	If GUICtrlRead($chkDBFreezeSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "DBFreezeSpell", 1)
	Else
		IniWrite($config, "attackCSV", "DBFreezeSpell", 0)
	EndIf
	If GUICtrlRead($chkABFreezeSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ABFreezeSpell", 1)
	Else
		IniWrite($config, "attackCSV", "ABFreezeSpell", 0)
	EndIf

	If GUICtrlRead($chkDBPoisonSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "DBPoisonSpell", 1)
	Else
		IniWrite($config, "attackCSV", "DBPoisonSpell", 0)
	EndIf
	If GUICtrlRead($chkABPoisonSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ABPoisonSpell", 1)
	Else
		IniWrite($config, "attackCSV", "ABPoisonSpell", 0)
	EndIf

	If GUICtrlRead($chkDBEarthquakeSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "DBEarthquakeSpell", 1)
	Else
		IniWrite($config, "attackCSV", "DBEarthquakeSpell", 0)
	EndIf
	If GUICtrlRead($chkABEarthquakeSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ABEarthquakeSpell", 1)
	Else
		IniWrite($config, "attackCSV", "ABEarthquakeSpell", 0)
	EndIf

	If GUICtrlRead($chkDBHasteSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "DBHasteSpell", 1)
	Else
		IniWrite($config, "attackCSV", "DBHasteSpell", 0)
	EndIf
	If GUICtrlRead($chkABHasteSpellCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ABHasteSpell", 1)
	Else
		IniWrite($config, "attackCSV", "ABHasteSpell", 0)
	EndIf


	IniWrite($config, "attackCSV", "BalanceCCDonated", _GUICtrlComboBox_GetCurSel($cmbCCDonatedCSV) + 1)
	IniWrite($config, "attackCSV", "BalanceCCReceived", _GUICtrlComboBox_GetCurSel($cmbCCReceivedCSV) + 1)

	If GUICtrlRead($radManAbilitiesCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ActivateKQ", "Manual")
	ElseIf GUICtrlRead($radAutoAbilities) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ActivateKQ", "Auto")
	EndIf

	If GUICtrlRead($chkUseWardenAbilityCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "ActivateWarden", 1)
	Else
		IniWrite($config, "attackCSV", "ActivateWarden", 0)
	EndIf

	IniWrite($config, "attackCSV", "delayActivateKQ", GUICtrlRead($txtManAbilitiesCSV))
	IniWrite($config, "attackCSV", "delayActivateW", GUICtrlRead($txtWardenAbilityCSV))


	IniWrite($config, "attackCSV", "ScriptDB", $scmbDBScriptName)

	If GUICtrlRead($chkUseAttackDBCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "EnableScriptDB", 1)
	Else
		IniWrite($config, "attackCSV", "EnableScriptDB", 0)
	EndIf

	IniWrite($config, "attackCSV", "ScriptAB", $scmbABScriptName)

	If GUICtrlRead($chkUseAttackABCSV) = $GUI_CHECKED Then
		IniWrite($config, "attackCSV", "EnableScriptAB", 1)
	Else
		IniWrite($config, "attackCSV", "EnableScriptAB", 0)
	EndIf

	If $hFile <> -1 Then FileClose($hFile)

EndFunc   ;==>saveConfig
