; #FUNCTION# ====================================================================================================================
; Name ..........: saveConfig.au3
; Description ...: Saves all of the GUI values to the config.ini and building.ini files
; Syntax ........: saveConfig()
; Parameters ....: NA
; Return values .: NA
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func saveConfig()
   Static $iSaveConfigCount = 0
   $iSaveConfigCount += 1
   SetDebugLog("saveConfig(), call number " & $iSaveConfigCount)

   ; Write the stats arrays to the stat files
   saveWeakBaseStats()

   SaveBuildingConfig()
   SaveRegularConfig()
EndFunc

Func SaveBuildingConfig()
   SetDebugLog("Save Building Config " & $g_sProfileBuildingPath)

   IniWriteS($g_sProfileBuildingPath, "general", "version", GetVersionNormalized($g_sBotVersion))

   ;Upgrades

   IniWriteS($g_sProfileBuildingPath, "upgrade", "LabPosX", $aLabPos[0])
   IniWriteS($g_sProfileBuildingPath, "upgrade", "LabPosY", $aLabPos[1])

   IniWriteS($g_sProfileBuildingPath, "other", "xTownHall", $TownHallPos[0])
   IniWriteS($g_sProfileBuildingPath, "other", "yTownHall", $TownHallPos[1])
   IniWriteS($g_sProfileBuildingPath, "other", "LevelTownHall", $iTownHallLevel)

   IniWriteS($g_sProfileBuildingPath, "other", "xCCPos", $aCCPos[0])
   IniWriteS($g_sProfileBuildingPath, "other", "yCCPos", $aCCPos[1])

   IniWriteS($g_sProfileBuildingPath, "other", "totalcamp", $TotalCamp)

   ;IniWriteS($g_sProfileBuildingPath, "other", "xspellfactory", $SFPos[0])
   ;IniWriteS($g_sProfileBuildingPath, "other", "yspellfactory", $SFPos[1])

   ;IniWriteS($g_sProfileBuildingPath, "other", "xDspellfactory", $DSFPos[0])
   ;IniWriteS($g_sProfileBuildingPath, "other", "yDspellfactory", $DSFPos[1])

   IniWriteS($g_sProfileBuildingPath, "other", "xKingAltarPos", $KingAltarPos[0])
   IniWriteS($g_sProfileBuildingPath, "other", "yKingAltarPos", $KingAltarPos[1])

   IniWriteS($g_sProfileBuildingPath, "other", "xQueenAltarPos", $QueenAltarPos[0])
   IniWriteS($g_sProfileBuildingPath, "other", "yQueenAltarPos", $QueenAltarPos[1])

   IniWriteS($g_sProfileBuildingPath, "other", "xWardenAltarPos", $WardenAltarPos[0])
   IniWriteS($g_sProfileBuildingPath, "other", "yWardenAltarPos", $WardenAltarPos[1])
EndFunc

Func SaveRegularConfig()
   SetDebugLog("Save Config " & $g_sProfileConfigPath)

   ; Open config file again, if we need to use extended languages/characters
   Local $hFile = -1
   If $g_bChkExtraAlphabets Or $g_bChkExtraChinese Or $g_bChkExtraKorean Then $hFile = FileOpen($g_sProfileConfigPath, $FO_UTF16_LE + $FO_OVERWRITE)

   ; General information
   IniWriteS($g_sProfileConfigPath, "general", "version", GetVersionNormalized($g_sBotVersion))

   IniWriteS($g_sProfileConfigPath, "general", "threads", $g_iThreads)

   ; Window positions
   IniWriteS($g_sProfileConfigPath, "general", "cmbProfile", _GUICtrlComboBox_GetCurSel($g_hCmbProfile))
   IniWriteS($g_sProfileConfigPath, "general", "frmBotPosX", $frmBotPosX)
   IniWriteS($g_sProfileConfigPath, "general", "frmBotPosY", $frmBotPosY)
   ; read now android position again, as it might have changed
   If $HWnD <> 0 Then WinGetAndroidHandle()
   IniWriteS($g_sProfileConfigPath, "general", "AndroidPosX", $AndroidPosX)
   IniWriteS($g_sProfileConfigPath, "general", "AndroidPosY", $AndroidPosY)
   IniWriteS($g_sProfileConfigPath, "general", "frmBotDockedPosX", $frmBotDockedPosX)
   IniWriteS($g_sProfileConfigPath, "general", "frmBotDockedPosY", $frmBotDockedPosY)

   ; Redraw mode
   IniWriteS($g_sProfileConfigPath, "general", "RedrawBotWindowMode", $g_iRedrawBotWindowMode)

   ; <><><> Attack Plan / Train Army / Options <><><>
	SaveConfig_Android()
	; <><><><> Log window <><><><>
	SaveConfig_600_1()
	; <><><><> Village / Misc <><><><>
	SaveConfig_600_6()
	; <><><><> Village / Achievements <><><><>
	SaveConfig_600_9()
	; <><><><> Village / Donate - Request <><><><>
	SaveConfig_600_11()
	; <><><><> Village / Donate - Donate <><><><>
	SaveConfig_600_12()
	; <><><><> Village / Donate - Schedule <><><><>
	SaveConfig_600_13()
	; <><><><> Village / Upgrade - Lab <><><><>
	SaveConfig_600_14()
	; <><><><> Village / Upgrade - Heroes <><><><>
	SaveConfig_600_15()
	; <><><><> Village / Upgrade - Buildings <><><><>
	SaveConfig_600_16()
	; <><><><> Village / Upgrade - Walls <><><><>
	SaveConfig_600_17()
	; <><><><> Village / Notify <><><><>
	SaveConfig_600_18()
	; <><><><> Village / Notify <><><><>
	SaveConfig_600_19()
	; <><><> Attack Plan / Train Army / Boost <><><>
	SaveConfig_600_22()
	; <><><><> Attack Plan / Search & Attack / Bully <><><><>
	SaveConfig_600_26()
	; <><><><> Attack Plan / Search & Attack / Options / Search <><><><>
	SaveConfig_600_28()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Search <><><><>
	SaveConfig_600_28_DB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Search <><><><>
	SaveConfig_600_28_LB()
	; <><><><> Attack Plan / Search & Attack / TH Snipe / Search <><><><>
	SaveConfig_600_28_TS()
	; <><><><> Attack Plan / Search & Attack / Options / Attack <><><><>
	SaveConfig_600_29()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack <><><><>
	SaveConfig_600_29_DB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack <><><><>
	SaveConfig_600_29_LB()
	; <><><><> Attack Plan / Search & Attack / TH Snipe / Attack <><><><>
	SaveConfig_600_29_TS()
	; <><><><> Attack Plan / Search & Attack / Options / End Battle <><><><>
	SaveConfig_600_30()
	; <><><><> Attack Plan / Search & Attack / Deadbase / End Battle <><><><>
	SaveConfig_600_30_DB()
	; <><><><> Attack Plan / Search & Attack / Activebase / End Battle <><><><>
	SaveConfig_600_30_LB()
	; <><><><> Attack Plan / Search & Attack / TH Snipe / End Battle <><><><>
	SaveConfig_600_30_TS()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Collectors <><><><>
	SaveConfig_600_31()
	; <><><><> Attack Plan / Search & Attack / Options / Trophy Settings <><><><>
	SaveConfig_600_32()
	; <><><><> Bot / Options <><><><>
	SaveConfig_600_35()
	; <><><> Attack Plan / Train Army / Troops/Spells <><><>
	; Quick train
	SaveConfig_600_52_1()
	; troop/spell levels and counts
	SaveConfig_600_52_2()
	; <><><> Attack Plan / Train Army / Train Order <><><>
	SaveConfig_600_54()
	; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
	SaveConfig_600_56()
	; <><><> Attack Plan / Train Army / Options <><><>
	SaveConfig_641_1()
	; <><><><> Bot / Debug <><><><>
	SaveConfig_Debug()

   ; <><><><> Attack Plan / Strategies <><><><>
   ; <<< nothing here >>>

   ; <><><><> Bot / Profiles <><><><>
   ; <<< nothing here >>>

   ; <><><><> Bot / Stats <><><><>
   ; <<< nothing here >>>

	If $hFile <> -1 Then FileClose($hFile)

EndFunc

Func SaveConfig_Android()
	; <><><><> Bot / Android <><><><>
	ApplyConfig_Android("Save")
	IniWriteS($g_sProfileConfigPath, "android", "game.distributor", $g_sAndroidGameDistributor)
	IniWriteS($g_sProfileConfigPath, "android", "game.package", $g_sAndroidGamePackage)
	IniWriteS($g_sProfileConfigPath, "android", "game.class", $g_sAndroidGameClass)
	IniWriteS($g_sProfileConfigPath, "android", "user.distributor", $g_sUserGameDistributor)
	IniWriteS($g_sProfileConfigPath, "android", "user.package", $g_sUserGamePackage)
	IniWriteS($g_sProfileConfigPath, "android", "user.class", $g_sUserGameClass)
	IniWriteS($g_sProfileConfigPath, "android", "check.time.lag.enabled", ($g_bAndroidCheckTimeLagEnabled ? "1" : "0"))
	IniWriteS($g_sProfileConfigPath, "android", "adb.screencap.timeout.min", $g_iAndroidAdbScreencapTimeoutMin)
	IniWriteS($g_sProfileConfigPath, "android", "adb.screencap.timeout.max", $g_iAndroidAdbScreencapTimeoutMax)
	IniWriteS($g_sProfileConfigPath, "android", "adb.screencap.timeout.dynamic", $g_iAndroidAdbScreencapTimeoutDynamic)
	IniWriteS($g_sProfileConfigPath, "android", "adb.input.enabled", ($g_bAndroidAdbInputEnabled ? "1" : "0"))
	IniWriteS($g_sProfileConfigPath, "android", "adb.click.enabled", ($g_bAndroidAdbClickEnabled ? "1" : "0"))
	IniWriteS($g_sProfileConfigPath, "android", "adb.click.group", $g_iAndroidAdbClickGroup)
	IniWriteS($g_sProfileConfigPath, "android", "adb.clicks.enabled", ($g_bAndroidAdbClicksEnabled ? "1" : "0"))
	IniWriteS($g_sProfileConfigPath, "android", "adb.clicks.troop.deploy.size", $g_iAndroidAdbClicksTroopDeploySize)
	IniWriteS($g_sProfileConfigPath, "android", "no.focus.tampering", ($g_bNoFocusTampering ? "1" : "0"))
	IniWriteS($g_sProfileConfigPath, "android", "shield.color", Hex($g_iAndroidShieldColor, 6))
	IniWriteS($g_sProfileConfigPath, "android", "shield.transparency", $g_iAndroidShieldTransparency)
	IniWriteS($g_sProfileConfigPath, "android", "active.color", Hex($g_iAndroidActiveColor, 6))
	IniWriteS($g_sProfileConfigPath, "android", "active.transparency", $g_iAndroidActiveTransparency)
	IniWriteS($g_sProfileConfigPath, "android", "inactive.color", Hex($g_iAndroidInactiveColor, 6))
	IniWriteS($g_sProfileConfigPath, "android", "inactive.transparency", $g_iAndroidInactiveTransparency)
	IniWriteS($g_sProfileConfigPath, "android", "emulator", $g_sAndroidEmulator)
	IniWriteS($g_sProfileConfigPath, "android", "instance", $g_sAndroidInstance)
EndFunc

Func SaveConfig_Debug()
	; Debug
	ApplyConfig_Debug("Save")
	; <><><><> Bot / Debug <><><><>
	If $g_bDevMode = True Then
		IniWriteS($g_sProfileConfigPath, "debug", "debugsetlog", $g_iDebugSetlog)
		IniWriteS($g_sProfileConfigPath, "debug", "debugsetclick", $g_iDebugClick)
		IniWriteS($g_sProfileConfigPath, "debug", "disablezoomout", $g_iDebugDisableZoomout)
		IniWriteS($g_sProfileConfigPath, "debug", "disablevillagecentering", $g_iDebugDisableVillageCentering)
		IniWriteS($g_sProfileConfigPath, "debug", "debugdeadbaseimage", $g_iDebugDeadBaseImage)
		IniWriteS($g_sProfileConfigPath, "debug", "debugocr", $g_iDebugOcr)
		IniWriteS($g_sProfileConfigPath, "debug", "debugimagesave", $g_iDebugImageSave)
		IniWriteS($g_sProfileConfigPath, "debug", "debugbuildingpos", $g_iDebugBuildingPos)
		IniWriteS($g_sProfileConfigPath, "debug", "debugtrain", $g_iDebugSetlogTrain)
		IniWriteS($g_sProfileConfigPath, "debug", "debugresourcesoffset", $g_iDebugResourcesOffset)
		IniWriteS($g_sProfileConfigPath, "debug", "continuesearchelixirdebug", $g_iDebugContinueSearchElixir)
		IniWriteS($g_sProfileConfigPath, "debug", "debugMilkingIMGmake", $g_iDebugMilkingIMGmake)
		IniWriteS($g_sProfileConfigPath, "debug", "debugOCRDonate", $g_iDebugOCRdonate)
		IniWriteS($g_sProfileConfigPath, "debug", "debugAttackCSV", $g_iDebugAttackCSV)
		IniWriteS($g_sProfileConfigPath, "debug", "debugmakeimgcsv", $g_iDebugMakeIMGCSV)
	Else
		IniDelete($g_sProfileConfigPath, "debug", "debugsetlog")
		IniDelete($g_sProfileConfigPath, "debug", "debugsetclick")
		IniDelete($g_sProfileConfigPath, "debug", "disablezoomout")
		IniDelete($g_sProfileConfigPath, "debug", "disablevillagecentering")
		IniDelete($g_sProfileConfigPath, "debug", "debugdeadbaseimage")
		IniDelete($g_sProfileConfigPath, "debug", "debugocr")
		IniDelete($g_sProfileConfigPath, "debug", "debugimagesave")
		IniDelete($g_sProfileConfigPath, "debug", "debugbuildingpos")
		IniDelete($g_sProfileConfigPath, "debug", "debugtrain")
		IniDelete($g_sProfileConfigPath, "debug", "debugresourcesoffset")
		IniDelete($g_sProfileConfigPath, "debug", "continuesearchelixirdebug")
		IniDelete($g_sProfileConfigPath, "debug", "debugMilkingIMGmake")
		IniDelete($g_sProfileConfigPath, "debug", "debugOCRDonate")
		IniDelete($g_sProfileConfigPath, "debug", "debugAttackCSV")
		IniDelete($g_sProfileConfigPath, "debug", "debugmakeimgcsv")
	EndIf
EndFunc

Func SaveConfig_600_1()
	; <><><><> Village / Misc <><><><>
	ApplyConfig_600_1("Save")
	; <><><><> Log window <><><><>
	IniWriteS($g_sProfileConfigPath, "general", "logstyle", $g_iCmbLogDividerOption)
	IniWriteS($g_sProfileConfigPath, "general", "LogDividerY", $g_iLogDividerY)
	; <><><><> Bottom panel <><><><>
	IniWriteS($g_sProfileConfigPath, "general", "Background", $g_bChkBackgroundMode ? 1 : 0)
EndFunc

Func SaveConfig_600_6()
	; <><><><> Village / Misc <><><><>
	ApplyConfig_600_6("Save")
	IniWriteS($g_sProfileConfigPath, "general", "BotStop", $g_bChkBotStop ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "general", "Command", $g_iCmbBotCommand)
	IniWriteS($g_sProfileConfigPath, "general", "Cond", $g_iCmbBotCond)
	IniWriteS($g_sProfileConfigPath, "general", "Hour", $g_iCmbHoursStop)
	IniWriteS($g_sProfileConfigPath, "other", "minrestartgold", $g_iTxtRestartGold)
	IniWriteS($g_sProfileConfigPath, "other", "minrestartelixir", $g_iTxtRestartElixir)
	IniWriteS($g_sProfileConfigPath, "other", "minrestartdark", $g_iTxtRestartDark)
	IniWriteS($g_sProfileConfigPath, "other", "chkTrap", $g_bChkTrap ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "other", "chkCollect", $g_bChkCollect ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "other", "chkTombstones", $g_bChkTombstones ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "other", "chkCleanYard", $g_bChkCleanYard ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "other", "chkGemsBox", $g_bChkGemsBox ? 1 : 0)
EndFunc

Func SaveConfig_600_9()
	; <><><><> Village / Achievements <><><><>
	ApplyConfig_600_9("Save")
	IniWriteS($g_sProfileConfigPath, "Unbreakable", "chkUnbreakable", $g_iUnbrkMode)
	IniWriteS($g_sProfileConfigPath, "Unbreakable", "UnbreakableWait", $g_iUnbrkWait)
	IniWriteS($g_sProfileConfigPath, "Unbreakable", "minUnBrkgold", $g_iUnbrkMinGold)
	IniWriteS($g_sProfileConfigPath, "Unbreakable", "minUnBrkelixir", $g_iUnbrkMinElixir)
	IniWriteS($g_sProfileConfigPath, "Unbreakable", "minUnBrkdark", $g_iUnbrkMinDark)
	IniWriteS($g_sProfileConfigPath, "Unbreakable", "maxUnBrkgold", $g_iUnbrkMaxGold)
	IniWriteS($g_sProfileConfigPath, "Unbreakable", "maxUnBrkelixir", $g_iUnbrkMaxElixir)
	IniWriteS($g_sProfileConfigPath, "Unbreakable", "maxUnBrkdark", $g_iUnbrkMaxDark)
EndFunc

Func SaveConfig_600_11()
	ApplyConfig_600_11("Save")
	; <><><><> Village / Donate - Request <><><><>
	IniWriteS($g_sProfileConfigPath, "planned", "RequestHoursEnable", $g_bRequestTroopsEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "donate", "txtRequest", $g_sRequestTroopsText)
	Local $string = ""
	For $i = 0 To 23
		$string &= ($g_abRequestCCHours[$i] ? "1" : "0") & "|"
	Next
	IniWriteS($g_sProfileConfigPath, "planned", "RequestHours", $string)
EndFunc

Func SaveConfig_600_12()
	; <><><><> Village / Donate - Donate <><><><>
	ApplyConfig_600_12("Save")
	IniWriteS($g_sProfileConfigPath, "donate", "Doncheck", $g_bChkDonate ? 1 : 0)
	For $i = 0 To $eTroopCount-1 + $g_iCustomDonateConfigs
		Local $sIniName = ""
		If $i >= $eTroopBarbarian And $i <= $eTroopBowler Then
		   $sIniName = StringReplace($g_asTroopNamesPlural[$i], " ", "")
	    ElseIf $i = $eCustomA Then
		   $sIniName = "CustomA"
	    ElseIf $i = $eCustomB Then
		   $sIniName = "CustomB"
	    EndIf

	    IniWriteS($g_sProfileConfigPath, "donate", "chkDonate" & $sIniName, $g_abChkDonateTroop[$i] ? 1 : 0)
		IniWriteS($g_sProfileConfigPath, "donate", "chkDonateAll" & $sIniName, $g_abChkDonateAllTroop[$i] ? 1 : 0)
		IniWriteS($g_sProfileConfigPath, "donate", "txtDonate" & $sIniName, StringReplace($g_asTxtDonateTroop[$i], @CRLF, "|"))
		IniWriteS($g_sProfileConfigPath, "donate", "txtBlacklist" & $sIniName, StringReplace($g_asTxtBlacklistTroop[$i], @CRLF, "|"))
   Next

   For $i = 0 To $eSpellCount - 1
		If $i <> $eSpellClone Then
			Local $sIniName = $g_asSpellNames[$i] & "Spells"
			IniWriteS($g_sProfileConfigPath, "donate", "chkDonate" & $sIniName, $g_abChkDonateSpell[$i] ? 1 : 0)
			IniWriteS($g_sProfileConfigPath, "donate", "chkDonateAll" & $sIniName, $g_abChkDonateAllSpell[$i] ? 1 : 0)
			IniWriteS($g_sProfileConfigPath, "donate", "txtDonate" & $sIniName, StringReplace($g_asTxtDonateSpell[$i], @CRLF, "|"))
			IniWriteS($g_sProfileConfigPath, "donate", "txtBlacklist" & $sIniName, StringReplace($g_asTxtBlacklistSpell[$i], @CRLF, "|"))
		EndIf
	Next

    For $i = 0 To 2
	   IniWriteS($g_sProfileConfigPath, "donate", "cmbDonateCustomA" & $i+1, $g_aiDonateCustomTrpNumA[$i][0])
	   IniWriteS($g_sProfileConfigPath, "donate", "txtDonateCustomA" & $i+1, $g_aiDonateCustomTrpNumA[$i][1])
	   IniWriteS($g_sProfileConfigPath, "donate", "cmbDonateCustomB" & $i+1, $g_aiDonateCustomTrpNumB[$i][0])
	   IniWriteS($g_sProfileConfigPath, "donate", "txtDonateCustomB" & $i+1, $g_aiDonateCustomTrpNumB[$i][1])
    Next

	IniWriteS($g_sProfileConfigPath, "donate", "chkExtraAlphabets", $g_bChkExtraAlphabets ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "donate", "chkExtraChinese", $g_bChkExtraChinese ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "donate", "chkExtraKorean", $g_bChkExtraKorean ? 1 : 0)

	IniWriteS($g_sProfileConfigPath, "donate", "txtBlacklist", StringReplace($g_sTxtGeneralBlacklist, @CRLF, "|"))
EndFunc

Func SaveConfig_600_13()
	; <><><><> Village / Donate - Schedule <><><><>
	ApplyConfig_600_13("Save")
	IniWriteS($g_sProfileConfigPath, "planned", "DonateHoursEnable", $g_bDonateHoursEnable ? 1 : 0)
	Local $string = ""
	For $i = 0 To 23
		$string &= ($g_abDonateHours[$i] ? "1" : "0") & "|"
	Next
	IniWriteS($g_sProfileConfigPath, "planned", "DonateHours", $string)
	IniWriteS($g_sProfileConfigPath, "donate", "cmbFilterDonationsCC", $g_iCmbDonateFilter)
	IniWriteS($g_sProfileConfigPath, "donate", "SkipDonateNearFulLTroopsEnable", $g_bDonateSkipNearFullEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "donate", "SkipDonateNearFulLTroopsPercentual", $g_iDonateSkipNearFullPercent)
EndFunc

Func SaveConfig_600_14()
	; <><><><> Village / Upgrade - Lab <><><><>
	ApplyConfig_600_14("Save")
	IniWriteS($g_sProfileBuildingPath, "upgrade", "upgradetroops", $g_bAutoLabUpgradeEnable ? 1 : 0)
	IniWriteS($g_sProfileBuildingPath, "upgrade", "upgradetroopname", $g_iCmbLaboratory)
	IniWrite($g_sProfileBuildingPath, "upgrade", "upgradelabtime", $sLabUpgradeTime)
EndFunc

Func SaveConfig_600_15()
	; <><><><> Village / Upgrade - Heroes <><><><>
	ApplyConfig_600_15("Save")
	IniWriteS($g_sProfileConfigPath, "upgrade", "UpgradeKing", $g_bUpgradeKingEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "upgrade", "UpgradeQueen", $g_bUpgradeQueenEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "upgrade", "UpgradeWarden", $g_bUpgradeWardenEnable ? 1 : 0)
EndFunc

Func SaveConfig_600_16()
	; <><><><> Village / Upgrade - Buildings <><><><>
	ApplyConfig_600_16("Save")
	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		IniWrite($g_sProfileBuildingPath, "upgrade", "xupgrade" & $iz, $g_avBuildingUpgrades[$iz][0])
		IniWrite($g_sProfileBuildingPath, "upgrade", "yupgrade" & $iz, $g_avBuildingUpgrades[$iz][1])
		IniWrite($g_sProfileBuildingPath, "upgrade", "upgradevalue" & $iz, $g_avBuildingUpgrades[$iz][2])
		IniWrite($g_sProfileBuildingPath, "upgrade", "upgradetype" & $iz, $g_avBuildingUpgrades[$iz][3])
		IniWrite($g_sProfileBuildingPath, "upgrade", "upgradename" & $iz, $g_avBuildingUpgrades[$iz][4])
		IniWrite($g_sProfileBuildingPath, "upgrade", "upgradelevel" & $iz, $g_avBuildingUpgrades[$iz][5])
		IniWrite($g_sProfileBuildingPath, "upgrade", "upgradetime" & $iz, $g_avBuildingUpgrades[$iz][6])
		IniWrite($g_sProfileBuildingPath, "upgrade", "upgradeend" & $iz, $g_avBuildingUpgrades[$iz][7])
		IniWrite($g_sProfileBuildingPath, "upgrade", "upgradechk" & $iz, $g_abBuildingUpgradeEnable[$iz] ? 1 : 0)
		IniWrite($g_sProfileBuildingPath, "upgrade", "upgraderepeat" & $iz, $g_abUpgradeRepeatEnable[$iz] ? 1 : 0)
		IniWrite($g_sProfileBuildingPath, "upgrade", "upgradestatusicon" & $iz, $g_aiPicUpgradeStatus[$iz])
	Next
	IniWriteS($g_sProfileConfigPath, "upgrade", "minupgrgold", $g_iUpgradeMinGold)
	IniWriteS($g_sProfileConfigPath, "upgrade", "minupgrelixir", $g_iUpgradeMinElixir)
	IniWriteS($g_sProfileConfigPath, "upgrade", "minupgrdark", $g_iUpgradeMinDark)
EndFunc

Func SaveConfig_600_17()
	; <><><><> Village / Upgrade - Walls <><><><>
	ApplyConfig_600_17("Save")
	IniWriteS($g_sProfileConfigPath, "upgrade", "auto-wall", $g_bAutoUpgradeWallsEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "upgrade", "minwallgold", $g_iUpgradeWallMinGold)
	IniWriteS($g_sProfileConfigPath, "upgrade", "minwallelixir", $g_iUpgradeWallMinElixir)
	IniWriteS($g_sProfileConfigPath, "upgrade", "use-storage", $g_iUpgradeWallLootType)
	IniWriteS($g_sProfileConfigPath, "upgrade", "savebldr", $g_bUpgradeWallSaveBuilder ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "upgrade", "walllvl", $g_iCmbUpgradeWallsLevel)
	For $i = 4 To 12
	  IniWriteS($g_sProfileConfigPath, "Walls", "Wall" & StringFormat("%02d", $i), $g_aiWallsCurrentCount[$i])
    Next
	IniWriteS($g_sProfileConfigPath, "upgrade", "WallCost", $g_iWallCost)
EndFunc

Func SaveConfig_600_18()
	; <><><><> Village / Notify <><><><>
	ApplyConfig_600_18("Save")
	; PushBullet / Telegram
	IniWriteS($g_sProfileConfigPath, "notify", "PBEnabled", $g_bNotifyPBEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "TGEnabled", $g_bNotifyTGEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "PBToken", $g_sNotifyPBToken)
	IniWriteS($g_sProfileConfigPath, "notify", "TGToken", $g_sNotifyTGToken)
	;Remote Control
	IniWriteS($g_sProfileConfigPath, "notify", "PBRemote", $g_bNotifyRemoteEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "DeleteAllPBPushes", $g_bNotifyDeleteAllPushesOnStart ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "DeleteOldPBPushes", $g_bNotifyDeletePushesOlderThan ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "HoursPushBullet", $g_iNotifyDeletePushesOlderThanHours)
	IniWriteS($g_sProfileConfigPath, "notify", "Origin", $g_sNotifyOrigin)
	;Alerts
	IniWriteS($g_sProfileConfigPath, "notify", "AlertPBVMFound", $g_bNotifyAlertMatchFound ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "AlertPBLastRaid", $g_bNotifyAlerLastRaidIMG ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "AlertPBWallUpgrade", $g_bNotifyAlertUpgradeWalls ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "AlertPBOOS", $g_bNotifyAlertOutOfSync ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "AlertPBVBreak", $g_bNotifyAlertTakeBreak ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "AlertPBOtherDevice", $g_bNotifyAlertAnotherDevice ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "AlertPBLastRaidTxt", $g_bNotifyAlerLastRaidTXT ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "AlertPBCampFull", $g_bNotifyAlertCampFull ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "AlertPBVillage", $g_bNotifyAlertVillageReport ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "AlertPBLastAttack", $g_bNotifyAlertLastAttack ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "AlertBuilderIdle", $g_bNotifyAlertBulderIdle ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "AlertPBMaintenance", $g_bNotifyAlertMaintenance ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "AlertPBBAN", $g_bNotifyAlertBAN ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "notify", "AlertPBUpdate", $g_bNotifyAlertBOTUpdate ? 1 : 0)
EndFunc

Func SaveConfig_600_19()
	; <><><><> Village / Notify <><><><>
	ApplyConfig_600_19("Save")
	IniWrite($g_sProfileConfigPath, "notify", "NotifyHoursEnable", $g_bNotifyScheduleHoursEnable ? 1 : 0)
	Local $string = ""
	For $i = 0 To 23
		$string &= ($g_abNotifyScheduleHours[$i] ? "1" : "0") & "|"
	Next
	IniWrite($g_sProfileConfigPath, "notify", "NotifyHours", $string)
	IniWrite($g_sProfileConfigPath, "notify", "NotifyWeekDaysEnable", $g_bNotifyScheduleWeekDaysEnable ? 1 : 0)
	Local $string = ""
	For $i = 0 To 6
		$string &= ($g_abNotifyScheduleWeekDays[$i] ? "1" : "0") & "|"
	Next
	IniWrite($g_sProfileConfigPath, "notify", "NotifyWeekDays", $string)
EndFunc

Func SaveConfig_600_22()
	; <><><> Attack Plan / Train Army / Boost <><><>
	ApplyConfig_600_22("Save")
	; Boost settings are not saved to ini, by design, to prevent automatic gem spending
	Local $string = ""
	For $i = 0 To 23
		$string &= ($g_abBoostBarracksHours[$i] ? "1" : "0") & "|"
	Next
	IniWriteS($g_sProfileConfigPath, "planned", "BoostBarracksHours", $string)
EndFunc

Func SaveConfig_600_26()
	; <><><><> Attack Plan / Search & Attack / Bully <><><><>
	ApplyConfig_600_26("Save")
	IniWriteS($g_sProfileConfigPath, "search", "BullyMode", $g_abAttackTypeEnable[$TB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ATBullyMode", $g_iAtkTBEnableCount)
	IniWriteS($g_sProfileConfigPath, "search", "YourTH", $g_iAtkTBMaxTHLevel)
	IniWriteS($g_sProfileConfigPath, "search", "THBullyAttackMode", $g_iAtkTBMode)
EndFunc

Func SaveConfig_600_28()
	; <><><><> Attack Plan / Search & Attack / Options / Search <><><><>
	ApplyConfig_600_28("Save")
	IniWriteS($g_sProfileConfigPath, "search", "reduction", $g_bSearchReductionEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "reduceCount", $g_iSearchReductionCount)
	IniWriteS($g_sProfileConfigPath, "search", "reduceGold", $g_iSearchReductionGold)
	IniWriteS($g_sProfileConfigPath, "search", "reduceElixir", $g_iSearchReductionElixir)
	IniWriteS($g_sProfileConfigPath, "search", "reduceGoldPlusElixir", $g_iSearchReductionGoldPlusElixir)
	IniWriteS($g_sProfileConfigPath, "search", "reduceDark", $g_iSearchReductionDark)
	IniWriteS($g_sProfileConfigPath, "search", "reduceTrophy", $g_iSearchReductionTrophy)
	IniWriteS($g_sProfileConfigPath, "other", "VSDelay", $g_iSearchDelayMin)
	IniWriteS($g_sProfileConfigPath, "other", "MaxVSDelay", $g_iSearchDelayMax)
	IniWriteS($g_sProfileConfigPath, "general", "attacknow", $g_bSearchAttackNowEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "general", "attacknowdelay", $g_iSearchAttackNowDelay)
	IniWriteS($g_sProfileConfigPath, "search", "ChkRestartSearchLimit", $g_bSearchRestartEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "RestartSearchLimit", $g_iSearchRestartLimit)
	IniWriteS($g_sProfileConfigPath, "general", "AlertSearch", $g_bSearchAlertMe ? 1 : 0)
EndFunc

Func SaveConfig_600_28_DB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Search <><><><>
	ApplyConfig_600_28_DB("Save")
	IniWriteS($g_sProfileConfigPath, "search", "DBcheck", $g_abAttackTypeEnable[$DB] ? 1 : 0)
	; Search - Start Search If
	IniWriteS($g_sProfileConfigPath, "search", "ChkDBSearchSearches", $g_abSearchSearchesEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "DBEnableAfterCount", $g_aiSearchSearchesMin[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBEnableBeforeCount", $g_aiSearchSearchesMax[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "ChkDBSearchTropies", $g_abSearchTropiesEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "DBEnableAfterTropies", $g_aiSearchTrophiesMin[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBEnableBeforeTropies", $g_aiSearchTrophiesMax[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "ChkDBSearchCamps", $g_abSearchCampsEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "DBEnableAfterArmyCamps", $g_aiSearchCampsPct[$DB])
	IniWriteS($g_sProfileConfigPath, "attack", "DBKingWait", $iHeroWaitAttackNoBit[$DB][0])
	IniWriteS($g_sProfileConfigPath, "attack", "DBQueenWait", $iHeroWaitAttackNoBit[$DB][1])
	IniWriteS($g_sProfileConfigPath, "attack", "DBWardenWait", $iHeroWaitAttackNoBit[$DB][2])
	IniWriteS($g_sProfileConfigPath, "search", "ChkDBSpellsWait", $g_abSearchSpellsWaitEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ChkDBCastleSpellWait", $g_abSearchCastleSpellsWaitEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "cmbDBWaitForCastleSpell", $g_aiSearchCastleSpellsWaitRegular[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "cmbDBWaitForCastleSpell2", $g_aiSearchCastleSpellsWaitDark[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "ChkDBCastleTroopsWait", $g_abSearchCastleTroopsWaitEnable[$DB] ? 1 : 0)
	; Search - Filters
	IniWriteS($g_sProfileConfigPath, "search", "DBMeetGE", $g_aiFilterMeetGE[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBsearchGold", $g_aiFilterMinGold[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBsearchElixir", $g_aiFilterMinElixir[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBsearchGoldPlusElixir", $g_aiFilterMinGoldPlusElixir[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBMeetDE", $g_abFilterMeetDEEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "DBsearchDark", $g_aiFilterMeetDEMin[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBMeetTrophy", $g_abFilterMeetTrophyEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "DBsearchTrophy", $g_aiFilterMeetTrophyMin[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBMeetTH", $g_abFilterMeetTH[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "DBTHLevel", $g_aiFilterMeetTHMin[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBMeetTHO", $g_abFilterMeetTHOutsideEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "DBCheckMortar", $g_abFilterMaxMortarEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "DBCheckWizTower", $g_abFilterMaxWizTowerEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "DBCheckAirDefense", $g_abFilterMaxAirDefenseEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "DBCheckXBow", $g_abFilterMaxXBowEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "DBCheckInferno", $g_abFilterMaxInfernoEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "DBCheckEagle", $g_abFilterMaxEagleEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "DBWeakMortar", $g_aiFilterMaxMortarLevel[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBWeakWizTower", $g_aiFilterMaxWizTowerLevel[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBWeakAirDefense", $g_aiFilterMaxAirDefenseLevel[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBWeakXBow", $g_aiFilterMaxXBowLevel[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBWeakInferno", $g_aiFilterMaxInfernoLevel[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBWeakEagle", $g_aiFilterMaxEagleLevel[$DB])
	IniWriteS($g_sProfileConfigPath, "search", "DBMeetOne", $g_abFilterMeetOneConditionEnable[$DB] ? 1 : 0)
EndFunc

Func SaveConfig_600_28_LB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Search <><><><>
	ApplyConfig_600_28_LB("Save")
	IniWriteS($g_sProfileConfigPath, "search", "ABcheck", $g_abAttackTypeEnable[$LB] ? 1 : 0)
	; Search - Start Search If
	IniWriteS($g_sProfileConfigPath, "search", "ChkABSearchSearches", $g_abSearchSearchesEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ABEnableAfterCount", $g_aiSearchSearchesMin[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABEnableBeforeCount", $g_aiSearchSearchesMax[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ChkABSearchTropies", $g_abSearchTropiesEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ABEnableAfterTropies", $g_aiSearchTrophiesMin[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABEnableBeforeTropies", $g_aiSearchTrophiesMax[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ChkABSearchCamps", $g_abSearchCampsEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ABEnableAfterArmyCamps", $g_aiSearchCampsPct[$LB])
	IniWriteS($g_sProfileConfigPath, "attack", "ABKingWait", $iHeroWaitAttackNoBit[$LB][0])
	IniWriteS($g_sProfileConfigPath, "attack", "ABQueenWait", $iHeroWaitAttackNoBit[$LB][1])
	IniWriteS($g_sProfileConfigPath, "attack", "ABWardenWait", $iHeroWaitAttackNoBit[$LB][2])
	IniWriteS($g_sProfileConfigPath, "search", "ChkABSpellsWait", $g_abSearchSpellsWaitEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ChkABCastleSpellWait", $g_abSearchCastleSpellsWaitEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "cmbABWaitForCastleSpell", $g_aiSearchCastleSpellsWaitRegular[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "cmbABWaitForCastleSpell2", $g_aiSearchCastleSpellsWaitDark[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ChkABCastleTroopsWait", $g_abSearchCastleTroopsWaitEnable[$LB] ? 1 : 0)
	; Search - Filters
	IniWriteS($g_sProfileConfigPath, "search", "ABMeetGE", $g_aiFilterMeetGE[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABsearchGold", $g_aiFilterMinGold[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABsearchElixir", $g_aiFilterMinElixir[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABsearchGoldPlusElixir", $g_aiFilterMinGoldPlusElixir[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABMeetDE", $g_abFilterMeetDEEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ABsearchDark", $g_aiFilterMeetDEMin[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABMeetTrophy", $g_abFilterMeetTrophyEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ABsearchTrophy", $g_aiFilterMeetTrophyMin[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABMeetTH", $g_abFilterMeetTH[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ABTHLevel", $g_aiFilterMeetTHMin[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABMeetTHO", $g_abFilterMeetTHOutsideEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ABCheckMortar", $g_abFilterMaxMortarEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ABCheckWizTower", $g_abFilterMaxWizTowerEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ABCheckAirDefense", $g_abFilterMaxAirDefenseEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ABCheckXBow", $g_abFilterMaxXBowEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ABCheckInferno", $g_abFilterMaxInfernoEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ABCheckEagle", $g_abFilterMaxEagleEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "ABWeakMortar", $g_aiFilterMaxMortarLevel[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABWeakWizTower", $g_aiFilterMaxWizTowerLevel[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABWeakAirDefense", $g_aiFilterMaxAirDefenseLevel[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABWeakXBow", $g_aiFilterMaxXBowLevel[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABWeakInferno", $g_aiFilterMaxInfernoLevel[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABWeakEagle", $g_aiFilterMaxEagleLevel[$LB])
	IniWriteS($g_sProfileConfigPath, "search", "ABMeetOne", $g_abFilterMeetOneConditionEnable[$LB] ? 1 : 0)
EndFunc

Func SaveConfig_600_28_TS()
	; <><><><> Attack Plan / Search & Attack / TH Snipe / Search <><><><>
	ApplyConfig_600_28_TS("Save")
	IniWriteS($g_sProfileConfigPath, "search", "TScheck", $g_abAttackTypeEnable[$TS] ? 1 : 0)
	; Search - Start Search If
	IniWriteS($g_sProfileConfigPath, "search", "ChkTSSearchSearches", $g_abSearchSearchesEnable[$TS] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "TSEnableAfterCount", $g_aiSearchSearchesMin[$TS])
	IniWriteS($g_sProfileConfigPath, "search", "TSEnableBeforeCount", $g_aiSearchSearchesMax[$TS])
	IniWriteS($g_sProfileConfigPath, "search", "ChkTSSearchTropies", $g_abSearchTropiesEnable[$TS] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "TSEnableAfterTropies", $g_aiSearchTrophiesMin[$TS])
	IniWriteS($g_sProfileConfigPath, "search", "TSEnableBeforeTropies", $g_aiSearchTrophiesMax[$TS])
	IniWriteS($g_sProfileConfigPath, "search", "ChkTSSearchCamps", $g_abSearchCampsEnable[$TS] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "TSEnableAfterArmyCamps", $g_aiSearchCampsPct[$TS])
	; Search - Filters
	IniWriteS($g_sProfileConfigPath, "search", "TSMeetGE", $g_aiFilterMeetGE[$TS])
	IniWriteS($g_sProfileConfigPath, "search", "TSsearchGold", $g_aiFilterMinGold[$TS])
	IniWriteS($g_sProfileConfigPath, "search", "TSsearchElixir", $g_aiFilterMinElixir[$TS])
	IniWriteS($g_sProfileConfigPath, "search", "TSsearchGoldPlusElixir", $g_aiFilterMinGoldPlusElixir[$TS])
	IniWriteS($g_sProfileConfigPath, "search", "TSMeetDE", $g_abFilterMeetDEEnable[$TS] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "TSsearchDark", $g_aiFilterMeetDEMin[$TS])
	IniWriteS($g_sProfileConfigPath, "search", "SWTtiles", $g_iAtkTSAddTilesWhileTrain)
	IniWriteS($g_sProfileConfigPath, "search", "THaddTiles", $g_iAtkTSAddTilesFullTroops)
EndFunc

Func SaveConfig_600_29()
	; <><><><> Attack Plan / Search & Attack / Options / Attack <><><><>
	ApplyConfig_600_29("Save")
	IniWriteS($g_sProfileConfigPath, "attack", "ActivateKQ", $iActivateKQCondition)
	IniWriteS($g_sProfileConfigPath, "attack", "delayActivateKQ", $delayActivateKQ)
	IniWriteS($g_sProfileConfigPath, "attack", "ActivateWarden", $iActivateWardenCondition)
	IniWriteS($g_sProfileConfigPath, "attack", "delayActivateW", $g_hTxtWardenAbility)
	IniWriteS($g_sProfileConfigPath, "planned", "chkAttackPlannerEnable", $ichkAttackPlannerEnable)
	IniWriteS($g_sProfileConfigPath, "planned", "chkAttackPlannerCloseCoC", $ichkAttackPlannerCloseCoC)
	IniWriteS($g_sProfileConfigPath, "planned", "chkAttackPlannerCloseAll", $ichkAttackPlannerCloseAll)
	IniWriteS($g_sProfileConfigPath, "planned", "chkAttackPlannerRandom", $ichkAttackPlannerRandom)
	IniWriteS($g_sProfileConfigPath, "planned", "cmbAttackPlannerRandom", $icmbAttackPlannerRandom)
	IniWriteS($g_sProfileConfigPath, "planned", "chkAttackPlannerDayLimit", $ichkAttackPlannerDayLimit)
	IniWriteS($g_sProfileConfigPath, "planned", "cmbAttackPlannerDayMin", $icmbAttackPlannerDayMin)
	IniWriteS($g_sProfileConfigPath, "planned", "cmbAttackPlannerDayMax", $icmbAttackPlannerDayMax)
	Local $string = ""
	For $i = 0 To 6
		$string &= $iPlannedAttackWeekDays[$i] & "|"
	Next
	IniWriteS($g_sProfileConfigPath, "planned", "attackDays", $string)
	Local $string = ""
	For $i = 0 To 23
		$string &= $iPlannedattackHours[$i] & "|"
	Next
	IniWriteS($g_sProfileConfigPath, "planned", "attackHours", $string)
	IniWriteS($g_sProfileConfigPath, "planned", "DropCCEnable", $iPlannedDropCCHoursEnable)
	IniWriteS($g_sProfileConfigPath, "ClanClastle", "BalanceCC", $iChkUseCCBalanced)
	IniWriteS($g_sProfileConfigPath, "ClanClastle", "BalanceCCDonated", $iCmbCCDonated)
	IniWriteS($g_sProfileConfigPath, "ClanClastle", "BalanceCCReceived", $iCmbCCReceived)
	Local $string = ""
	For $i = 0 To 23
		$string &= $iPlannedDropCCHours[$i] & "|"
	Next
	IniWriteS($g_sProfileConfigPath, "planned", "DropCCHours", $string)
EndFunc

Func SaveConfig_600_29_DB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack <><><><>
	ApplyConfig_600_29_DB("Save")
	IniWriteS($g_sProfileConfigPath, "attack", "DBAtkAlgorithm", $g_aiAttackAlgorithm[$DB])
	IniWriteS($g_sProfileConfigPath, "attack", "DBSelectTroop", $g_aiAttackTroopSelection[$DB])
	IniWriteS($g_sProfileConfigPath, "attack", "DBKingAtk", BitAND($g_aiAttackUseHeroes[$DB], $eHeroKing))
	IniWriteS($g_sProfileConfigPath, "attack", "DBQueenAtk", BitAND($g_aiAttackUseHeroes[$DB], $eHeroQueen))
	IniWriteS($g_sProfileConfigPath, "attack", "DBWardenAtk", BitAND($g_aiAttackUseHeroes[$DB], $eHeroWarden))
	IniWriteS($g_sProfileConfigPath, "attack", "DBDropCC", $g_abAttackDropCC[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBLightSpell", $g_abAttackUseLightSpell[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBHealSpell", $g_abAttackUseHealSpell[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBRageSpell", $g_abAttackUseRageSpell[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBJumpSpell", $g_abAttackUseJumpSpell[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBFreezeSpell", $g_abAttackUseFreezeSpell[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBPoisonSpell", $g_abAttackUsePoisonSpell[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBEarthquakeSpell", $g_abAttackUseEarthquakeSpell[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBHasteSpell", $g_abAttackUseHasteSpell[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBCloneSpell", $g_abAttackUseCloneSpell[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBSkeletonSpell", $g_abAttackUseSkeletonSpell[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "THSnipeBeforeDBEnable", $g_bTHSnipeBeforeEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "THSnipeBeforeDBTiles", $g_iTHSnipeBeforeTiles[$DB])
	IniWriteS($g_sProfileConfigPath, "attack", "THSnipeBeforeDBScript", $g_iTHSnipeBeforeScript[$DB])

	SaveConfig_600_29_DB_Standard()

	SaveConfig_600_29_DB_Scripted()

	SaveConfig_600_29_DB_Milking()

EndFunc

Func SaveConfig_600_29_DB_Standard()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Standard <><><><>
	ApplyConfig_600_29_DB_Standard("Save")
	IniWriteS($g_sProfileConfigPath, "attack", "DBStandardAlgorithm", $g_aiAttackStdDropOrder[$DB])
	IniWriteS($g_sProfileConfigPath, "attack", "DBDeploy", $g_aiAttackStdDropSides[$DB])
	IniWriteS($g_sProfileConfigPath, "attack", "DBUnitD", $g_aiAttackStdUnitDelay[$DB])
	IniWriteS($g_sProfileConfigPath, "attack", "DBWaveD", $g_aiAttackStdWaveDelay[$DB])
	IniWriteS($g_sProfileConfigPath, "attack", "DBRandomSpeedAtk", $g_abAttackStdRandomizeDelay[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBSmartAttackRedArea", $g_abAttackStdSmartAttack[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBSmartAttackDeploy", $g_aiAttackStdSmartDeploy[$DB])
	IniWriteS($g_sProfileConfigPath, "attack", "DBSmartAttackGoldMine", $g_abAttackStdSmartNearCollectors[$DB][0] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBSmartAttackElixirCollector", $g_abAttackStdSmartNearCollectors[$DB][1] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "DBSmartAttackDarkElixirDrill", $g_abAttackStdSmartNearCollectors[$DB][2] ? 1 : 0)
EndFunc

Func SaveConfig_600_29_DB_Scripted()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Scripted <><><><>
	ApplyConfig_600_29_DB_Scripted("Save")
	IniWriteS($g_sProfileConfigPath, "attack", "RedlineRoutineDB", $g_aiAttackScrRedlineRoutine[$DB])
	IniWriteS($g_sProfileConfigPath, "attack", "DroplineEdgeDB", $g_aiAttackScrDroplineEdge[$DB])
	IniWriteS($g_sProfileConfigPath, "attack", "ScriptDB", $g_sAttackScrScriptName[$DB])
EndFunc

Func SaveConfig_600_29_DB_Milking()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Milking <><><><>
	ApplyConfig_600_29_DB_Milking("Save")
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "MilkAttackType", $g_iMilkAttackType)
	; A. Structures
	Local $string = ""
	For $i = 0 To 8
		$string &= $g_aiMilkFarmElixirParam[$i] & "|"
	Next
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "LocateElixirLevel", $string)
	; B. Conditions
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "LocateElixir", $g_bMilkFarmLocateElixir ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "LocateMine", $g_bMilkFarmLocateMine ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "MineParam", $g_iMilkFarmMineParam)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "LocateDrill", $g_bMilkFarmLocateDrill ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "DrillParam", $g_iMilkFarmDrillParam)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "MaxTiles", $g_iMilkFarmResMaxTilesFromBorder)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "AttackElixir", $g_bMilkFarmAttackElixirExtractors ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "AttackMine", $g_bMilkFarmAttackGoldMines ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "AttackDrill", $g_bMilkFarmAttackDarkDrills ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "LimitGold", $g_iMilkFarmLimitGold)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "LimitElixir", $g_iMilkFarmLimitElixir)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "LimitDark", $g_iMilkFarmLimitDark)
	; C. Attack
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "TroopForWaveMin", $g_iMilkFarmTroopForWaveMin)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "TroopForWaveMax", $g_iMilkFarmTroopForWaveMax)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "MaxWaves", $g_iMilkFarmTroopMaxWaves)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "DelayBetweenWavesMin", $g_iMilkFarmDelayFromWavesMin)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "DelayBetweenWavesMax", $g_iMilkFarmDelayFromWavesMax)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "DropRandomPlace", $g_iMilkingAttackDropGoblinAlgorithm)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "StructureOrder", $g_iMilkingAttackStructureOrder)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "CheckStructureDestroyedBeforeAttack", $g_bMilkingAttackCheckStructureDestroyedBeforeAttack ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "CheckStructureDestroyedAfterAttack", $g_bMilkingAttackCheckStructureDestroyedAfterAttack ? 1 : 0)
	; D. After Milking
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "MilkAttackAfterTHSnipe", $g_bMilkAttackAfterTHSnipeEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "TownhallTiles", $g_iMilkFarmTHMaxTilesFromBorder)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "TownHallAlgorithm", $g_sMilkFarmAlgorithmTh)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "TownHallHitAnyway", $g_bMilkFarmSnipeEvenIfNoExtractorsFound ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "MilkAttackAfterScriptedAtk", $g_bMilkAttackAfterScriptedAtkEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "MilkAttackCSVscript", $g_sMilkAttackCSVscript)
	; Advanced
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "MilkFarmForceTolerance", $g_bMilkFarmForceToleranceEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "MilkFarmForcetolerancenormal", $g_iMilkFarmForceToleranceNormal)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "MilkFarmForcetoleranceboosted", $g_iMilkFarmForceToleranceBoosted)
	IniWriteS($g_sProfileConfigPath, "MilkingAttack", "MilkFarmForcetolerancedestroyed", $g_iMilkFarmForceToleranceDestroyed)
EndFunc

Func SaveConfig_600_29_LB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack <><><><>
	ApplyConfig_600_29_LB("Save")
	IniWriteS($g_sProfileConfigPath, "attack", "ABAtkAlgorithm", $g_aiAttackAlgorithm[$LB])
	IniWriteS($g_sProfileConfigPath, "attack", "ABSelectTroop", $g_aiAttackTroopSelection[$LB])
	IniWriteS($g_sProfileConfigPath, "attack", "ABKingAtk", BitAND($g_aiAttackUseHeroes[$LB], $eHeroKing))
	IniWriteS($g_sProfileConfigPath, "attack", "ABQueenAtk", BitAND($g_aiAttackUseHeroes[$LB], $eHeroQueen))
	IniWriteS($g_sProfileConfigPath, "attack", "ABWardenAtk", BitAND($g_aiAttackUseHeroes[$LB], $eHeroWarden))
	IniWriteS($g_sProfileConfigPath, "attack", "ABDropCC", $g_abAttackDropCC[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABLightSpell", $g_abAttackUseLightSpell[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABHealSpell", $g_abAttackUseHealSpell[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABRageSpell", $g_abAttackUseRageSpell[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABJumpSpell", $g_abAttackUseJumpSpell[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABFreezeSpell", $g_abAttackUseFreezeSpell[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABCloneSpell", $g_abAttackUseCloneSpell[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABPoisonSpell", $g_abAttackUsePoisonSpell[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABEarthquakeSpell", $g_abAttackUseEarthquakeSpell[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABHasteSpell", $g_abAttackUseHasteSpell[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABSkeletonSpell", $g_abAttackUseSkeletonSpell[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "THSnipeBeforeLBEnable", $g_bTHSnipeBeforeEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "THSnipeBeforeLBTiles", $g_iTHSnipeBeforeTiles[$LB])
	IniWriteS($g_sProfileConfigPath, "attack", "THSnipeBeforeLBScript", $g_iTHSnipeBeforeScript[$LB])

	SaveConfig_600_29_LB_Standard()

	SaveConfig_600_29_LB_Scripted()

EndFunc

Func SaveConfig_600_29_LB_Standard()
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack / Standard <><><><>
	ApplyConfig_600_29_LB_Standard("Save")
	IniWriteS($g_sProfileConfigPath, "attack", "LBStandardAlgorithm", $g_aiAttackStdDropOrder[$LB])
	IniWriteS($g_sProfileConfigPath, "attack", "ABDeploy", $g_aiAttackStdDropSides[$LB])
	IniWriteS($g_sProfileConfigPath, "attack", "ABUnitD", $g_aiAttackStdUnitDelay[$LB])
	IniWriteS($g_sProfileConfigPath, "attack", "ABWaveD", $g_aiAttackStdWaveDelay[$LB])
	IniWriteS($g_sProfileConfigPath, "attack", "ABRandomSpeedAtk", $g_abAttackStdRandomizeDelay[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABSmartAttackRedArea", $g_abAttackStdSmartAttack[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABSmartAttackDeploy", $g_aiAttackStdSmartDeploy[$LB])
	IniWriteS($g_sProfileConfigPath, "attack", "ABSmartAttackGoldMine", $g_abAttackStdSmartNearCollectors[$LB][0] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABSmartAttackElixirCollector", $g_abAttackStdSmartNearCollectors[$LB][1] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "ABSmartAttackDarkElixirDrill", $g_abAttackStdSmartNearCollectors[$LB][2] ? 1 : 0)
EndFunc

Func SaveConfig_600_29_LB_Scripted()
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack / Scripted <><><><>
	ApplyConfig_600_29_LB_Scripted("Save")
	IniWriteS($g_sProfileConfigPath, "attack", "RedlineRoutineAB", $g_aiAttackScrRedlineRoutine[$LB])
	IniWriteS($g_sProfileConfigPath, "attack", "DroplineEdgeAB", $g_aiAttackScrDroplineEdge[$LB])
	IniWriteS($g_sProfileConfigPath, "attack", "ScriptAB", $g_sAttackScrScriptName[$LB])
EndFunc

Func SaveConfig_600_29_TS()
	; <><><><> Attack Plan / Search & Attack / TH Snipe / Attack <><><><>
	ApplyConfig_600_29_TS("Save")
	IniWriteS($g_sProfileConfigPath, "attack", "TSSelectTroop", $g_aiAttackTroopSelection[$TS])
	IniWriteS($g_sProfileConfigPath, "attack", "TSKingAtk", BitAND($g_aiAttackUseHeroes[$TS], $eHeroKing))
	IniWriteS($g_sProfileConfigPath, "attack", "TSQueenAtk", BitAND($g_aiAttackUseHeroes[$TS], $eHeroQueen))
	IniWriteS($g_sProfileConfigPath, "attack", "TSWardenAtk", BitAND($g_aiAttackUseHeroes[$TS], $eHeroWarden))
	IniWriteS($g_sProfileConfigPath, "attack", "TSDropCC", $g_abAttackDropCC[$TS] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "TSLightSpell", $g_abAttackUseLightSpell[$TS] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "TSHealSpell", $g_abAttackUseHealSpell[$TS] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "TSRageSpell", $g_abAttackUseRageSpell[$TS] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "TSJumpSpell", $g_abAttackUseJumpSpell[$TS] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "TSFreezeSpell", $g_abAttackUseFreezeSpell[$TS] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "TSPoisonSpell", $g_abAttackUsePoisonSpell[$TS] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "TSEarthquakeSpell", $g_abAttackUseEarthquakeSpell[$TS] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "TSHasteSpell", $g_abAttackUseHasteSpell[$TS] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "attack", "AttackTHType", $g_sAtkTSType)
EndFunc

Func SaveConfig_600_30()
	; <><><><> Attack Plan / Search & Attack / Options / End Battle <><><><>
	ApplyConfig_600_30("Save")
	IniWriteS($g_sProfileConfigPath, "shareattack", "ShareAttack", $iShareAttack)
	IniWriteS($g_sProfileConfigPath, "shareattack", "minGold", $iShareminGold)
	IniWriteS($g_sProfileConfigPath, "shareattack", "minElixir", $iShareminElixir)
	IniWriteS($g_sProfileConfigPath, "shareattack", "minDark", $iShareminDark)
	IniWriteS($g_sProfileConfigPath, "shareattack", "Message", StringReplace($sShareMessage, @CRLF, "|"))
	IniWriteS($g_sProfileConfigPath, "attack", "TakeLootSnapShot", $TakeLootSnapShot)
	IniWriteS($g_sProfileConfigPath, "attack", "ScreenshotLootInfo", $ScreenshotLootInfo)
EndFunc

Func SaveConfig_600_30_DB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / End Battle <><><><>
	ApplyConfig_600_30_DB("Save")
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkDBTimeStopAtk", $g_abStopAtkNoLoot1Enable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtDBTimeStopAtk", $g_aiStopAtkNoLoot1Time[$DB])
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkDBTimeStopAtk2", $g_abStopAtkNoLoot2Enable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtDBTimeStopAtk2", $g_aiStopAtkNoLoot2Time[$DB])
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtDBMinGoldStopAtk2", $g_aiStopAtkNoLoot2MinGold[$DB])
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtDBMinElixirStopAtk2", $g_aiStopAtkNoLoot2MinElixir[$DB])
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtDBMinDarkElixirStopAtk2", $g_aiStopAtkNoLoot2MinDark[$DB])
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkDBEndNoResources", $g_abStopAtkNoResources[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkDBEndOneStar", $g_abStopAtkOneStar[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkDBEndTwoStars", $g_abStopAtkTwoStars[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkDBPercentageHigher", $g_abStopAtkPctHigherEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtDBPercentageHigher", $g_aiStopAtkPctHigherAmt[$DB])
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkDBPercentageChange", $g_abStopAtkPctNoChangeEnable[$DB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtDBPercentageChange", $g_aiStopAtkPctNoChangeTime[$DB])
EndFunc

Func SaveConfig_600_30_LB()
	; <><><><> Attack Plan / Search & Attack / Activebase / End Battle <><><><>
	ApplyConfig_600_30_LB("Save")
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkABTimeStopAtk", $g_abStopAtkNoLoot1Enable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtABTimeStopAtk", $g_aiStopAtkNoLoot1Time[$LB])
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkABTimeStopAtk2", $g_abStopAtkNoLoot2Enable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtABTimeStopAtk2", $g_aiStopAtkNoLoot2Time[$LB])
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtABMinGoldStopAtk2", $g_aiStopAtkNoLoot2MinGold[$LB])
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtABMinElixirStopAtk2", $g_aiStopAtkNoLoot2MinElixir[$LB])
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtABMinDarkElixirStopAtk2", $g_aiStopAtkNoLoot2MinDark[$LB])
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkABEndNoResources", $g_abStopAtkNoResources[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkABEndOneStar", $g_abStopAtkOneStar[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkABEndTwoStars", $g_abStopAtkTwoStars[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkDESideEB", $g_bDESideEndEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtDELowEndMin", $g_iDESideEndMin)
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkDisableOtherEBO", $g_bDESideDisableOther ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkDEEndAq", $g_bDESideEndAQWeak ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkDEEndBk", $g_bDESideEndBKWeak ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkDEEndOneStar", $g_bDESideEndOneStar ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkABPercentageHigher", $g_abStopAtkPctHigherEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtABPercentageHigher", $g_aiStopAtkPctHigherAmt[$LB])
	IniWriteS($g_sProfileConfigPath, "endbattle", "chkABPercentageChange", $g_abStopAtkPctNoChangeEnable[$LB] ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "endbattle", "txtABPercentageChange", $g_aiStopAtkPctNoChangeTime[$LB])
EndFunc

Func SaveConfig_600_30_TS()
	; <><><><> Attack Plan / Search & Attack / TH Snipe / End Battle <><><><>
	ApplyConfig_600_30_TS("Save")
	IniWriteS($g_sProfileConfigPath, "search", "ChkTSSearchCamps2", $g_bEndTSCampsEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "search", "TSEnableAfterArmyCamps2", $g_iEndTSCampsPct)
EndFunc

Func SaveConfig_600_31()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Collectors <><><><>
	ApplyConfig_600_31("Save")
	For $i = 6 To 12
		IniWriteS($g_sProfileConfigPath, "collectors", "lvl" & $i & "Enabled", $g_abCollectorLevelEnabled[$i] ? 1 : 0)
		IniWriteS($g_sProfileConfigPath, "collectors", "lvl" & $i & "fill", $g_aiCollectorLevelFill[$i])
	Next
	IniWriteS($g_sProfileConfigPath, "search", "chkDisableCollectorsFilter", $g_bCollectorFilterDisable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "collectors", "minmatches", $g_iCollectorMatchesMin)
	IniWriteS($g_sProfileConfigPath, "collectors", "tolerance", $g_iCollectorToleranceOffset)
EndFunc

Func SaveConfig_600_32()
	; <><><><> Attack Plan / Search & Attack / Options / Trophy Settings <><><><>
	ApplyConfig_600_32("Save")
	IniWriteS($g_sProfileConfigPath, "search", "TrophyRange", $iChkTrophyRange)
	IniWriteS($g_sProfileConfigPath, "search", "MaxTrophy", $itxtMaxTrophy)
	IniWriteS($g_sProfileConfigPath, "search", "MinTrophy", $itxtdropTrophy)
	IniWriteS($g_sProfileConfigPath, "search", "chkTrophyHeroes", $iChkTrophyHeroes)
	IniWriteS($g_sProfileConfigPath, "search", "cmbTrophyHeroesPriority", $iCmbTrophyHeroesPriority)
	IniWriteS($g_sProfileConfigPath, "search", "chkTrophyAtkDead", $iChkTrophyAtkDead)
	IniWriteS($g_sProfileConfigPath, "search", "DTArmyMin", $itxtDTArmyMin)
EndFunc

Func SaveConfig_600_35()
	; <><><><> Bot / Options <><><><>
	ApplyConfig_600_35("Save")
	IniWriteS($g_sProfileConfigPath, "other", "language", $sLanguage)
	IniWriteS($g_sProfileConfigPath, "General", "ChkDisableSplash", $ichkDisableSplash)
	IniWriteS($g_sProfileConfigPath, "General", "ChkVersion", $ichkVersion)
	IniWriteS($g_sProfileConfigPath, "deletefiles", "DeleteLogs", $ichkDeleteLogs)
	IniWriteS($g_sProfileConfigPath, "deletefiles", "DeleteLogsDays", $iDeleteLogsDays)
	IniWriteS($g_sProfileConfigPath, "deletefiles", "DeleteTemp", $ichkDeleteTemp)
	IniWriteS($g_sProfileConfigPath, "deletefiles", "DeleteTempDays", $iDeleteTempDays)
	IniWriteS($g_sProfileConfigPath, "deletefiles", "DeleteLoots", $ichkDeleteLoots)
	IniWriteS($g_sProfileConfigPath, "deletefiles", "DeleteLootsDays", $iDeleteLootsDays)
	IniWriteS($g_sProfileConfigPath, "general", "AutoStart", $ichkAutoStart)
	IniWriteS($g_sProfileConfigPath, "general", "AutoStartDelay", $ichkAutoStartDelay)
	IniWriteS($g_sProfileConfigPath, "General", "ChkLanguage", $ichkLanguage)
	IniWriteS($g_sProfileConfigPath, "general", "DisposeWindows", $iDisposeWindows)
	IniWriteS($g_sProfileConfigPath, "general", "DisposeWindowsPos", $icmbDisposeWindowsPos)
	IniWriteS($g_sProfileConfigPath, "other", "WAOffsetX", $iWAOffsetX)
	IniWriteS($g_sProfileConfigPath, "other", "WAOffsetY", $iWAOffsetY)
	IniWriteS($g_sProfileConfigPath, "general", "UpdatingWhenMinimized", $iUpdatingWhenMinimized)
	IniWriteS($g_sProfileConfigPath, "general", "HideWhenMinimized", $iHideWhenMinimized)

	IniWriteS($g_sProfileConfigPath, "other", "UseRandomClick", $iUseRandomClick)
	IniWriteS($g_sProfileConfigPath, "other", "ScreenshotType", $iScreenshotType)
	IniWriteS($g_sProfileConfigPath, "other", "ScreenshotHideName", $ichkScreenshotHideName)
	IniWriteS($g_sProfileConfigPath, "other", "txtTimeWakeUp", $sTimeWakeUp)
	IniWriteS($g_sProfileConfigPath, "other", "chkSinglePBTForced", $ichkSinglePBTForced)
	IniWriteS($g_sProfileConfigPath, "other", "ValueSinglePBTimeForced", $iValueSinglePBTimeForced)
	IniWriteS($g_sProfileConfigPath, "other", "ValuePBTimeForcedExit", $iValuePBTimeForcedExit)
	IniWriteS($g_sProfileConfigPath, "other", "ChkAutoResume", $iChkAutoResume)
	IniWriteS($g_sProfileConfigPath, "other", "AutoResumeTime", $iAutoResumeTime)
	IniWriteS($g_sProfileConfigPath, "other", "ChkFixClanCastle", $ichkFixClanCastle)
EndFunc

Func SaveConfig_600_52_1()
	; <><><> Attack Plan / Train Army / Troops/Spells <><><>
	ApplyConfig_600_52_1("Save")
	IniWriteS($g_sProfileConfigPath, "other", "ChkUseQTrain", $g_bQuickTrainEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "troop", "QuickTrainArmyNum", $g_iQuickTrainArmyNum)
EndFunc

Func SaveConfig_600_52_2()
	; troop/spell levels and counts
	ApplyConfig_600_52_2("Save")
	For $T = 0 To $eTroopCount - 1
		IniWriteS($g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], $g_aiArmyCompTroops[$T])
		IniWriteS($g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], $g_aiTrainArmyTroopLevel[$T])
	Next
	For $S = 0 To $eSpellCount - 1
		IniWriteS($g_sProfileConfigPath, "Spells", $g_asSpellShortNames[$S], $g_aiArmyCompSpells[$S])
		IniWriteS($g_sProfileConfigPath, "LevelSpell", $g_asSpellShortNames[$S], $g_aiTrainArmySpellLevel[$S])
	Next
	; full & forced Total Camp values
	IniWriteS($g_sProfileConfigPath, "troop", "fulltroop", $g_iTrainArmyFullTroopPct)
	IniWriteS($g_sProfileConfigPath, "other", "ChkTotalCampForced", $g_bTotalCampForced ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "other", "ValueTotalCampForced", $g_iTotalCampForcedValue)
	; spell capacity and forced flag
	IniWriteS($g_sProfileConfigPath, "Spells", "SpellFactory", $g_iTotalSpellValue)
	IniWriteS($g_sProfileConfigPath, "other", "ChkForceBrewBeforeAttack", $g_bForceBrewSpells ? 1 : 0)
EndFunc

Func SaveConfig_600_54()
	; <><><> Attack Plan / Train Army / Train Order <><><>
	ApplyConfig_600_54("Save")
	IniWriteS($g_sProfileConfigPath, "troop", "chkTroopOrder", $g_bCustomTrainOrderEnable ? 1 : 0)
	For $z = 0 To UBound($g_aiCmbCustomTrainOrder) -1
		IniWriteS($g_sProfileConfigPath, "troop", "cmbTroopOrder" & $z, $g_aiCmbCustomTrainOrder[$z])
	Next
EndFunc

Func SaveConfig_600_56()
	; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
	ApplyConfig_600_56("Save")
	IniWrite($g_sProfileConfigPath, "SmartZap", "UseSmartZap", $ichkSmartZap)
	IniWrite($g_sProfileConfigPath, "SmartZap", "UseEarthQuakeZap", $ichkEarthQuakeZap)
	IniWrite($g_sProfileConfigPath, "SmartZap", "UseNoobZap", $ichkNoobZap)
	IniWrite($g_sProfileConfigPath, "SmartZap", "ZapDBOnly", $ichkSmartZapDB)
	IniWrite($g_sProfileConfigPath, "SmartZap", "THSnipeSaveHeroes", $ichkSmartZapSaveHeroes)
	IniWrite($g_sProfileConfigPath, "SmartZap", "MinDE", $itxtMinDE)
	IniWrite($g_sProfileConfigPath, "SmartZap", "ExpectedDE", $itxtExpectedDE)
	IniWrite($g_sProfileConfigPath, "SmartZap", "DebugSmartZap", $DebugSmartZap)
EndFunc

Func SaveConfig_641_1()
	; <><><> Attack Plan / Train Army / Options <><><>
	ApplyConfig_641_1("Save")
	; Training idle time
	IniWriteS($g_sProfileConfigPath, "other", "chkCloseWaitEnable", $g_bCloseWhileTrainingEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "other", "chkCloseWaitTrain", $g_bCloseWithoutShield ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "other", "btnCloseWaitStop", $g_bCloseEmulator ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "other", "btnCloseWaitStopRandom", $g_bCloseRandom ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "other", "btnCloseWaitExact", $g_bCloseExactTime ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "other", "btnCloseWaitRandom", $g_bCloseRandomTime ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "other", "CloseWaitRdmPercent", $g_iCloseRandomTimePercent)
	IniWriteS($g_sProfileConfigPath, "other", "MinimumTimeToClose", $g_iCloseMinimumTime)
	; Train click timing
	IniWriteS($g_sProfileConfigPath, "other", "TrainITDelay", $g_iTrainClickDelay)
	; Training add random delay
	IniWriteS($g_sProfileConfigPath, "other", "chkAddIdleTime", $g_bTrainAddRandomDelayEnable ? 1 : 0)
	IniWriteS($g_sProfileConfigPath, "other", "txtAddDelayIdlePhaseTimeMin", $g_iTrainAddRandomDelayMin)
	IniWriteS($g_sProfileConfigPath, "other", "txtAddDelayIdlePhaseTimeMax", $g_iTrainAddRandomDelayMax)
EndFunc

Func IniWriteS($filename, $section, $key, $value)
	;save in standard config files and also save settings in strategy ini file (save strategy button valorize variable $g_sProfileSecondaryOutputFileName )
	Local $s = $section
	Local $k = $key
	IniWrite($filename, $section, $key, $value)
	If $g_sProfileSecondaryOutputFileName <> "" Then
		If $s = "search" Or $s = "attack" Or $s = "troop" Or $s = "spells" Or $s = "milkingattack" Or $s = "endbattle" or $s = "collectors" or ($s = "general" And $k = "version") Then
			IniWrite($g_sProfileSecondaryOutputFileName, $section, $key, $value)
		EndIf
	EndIf
EndFunc   ;==>IniWriteS
