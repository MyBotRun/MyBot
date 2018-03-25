; #FUNCTION# ====================================================================================================================
; Name ..........: readConfig.au3
; Description ...: Reads config file and sets variables
; Syntax ........: readConfig()
; Parameters ....: NA
; Return values .: NA
; Author ........:
; Modified ......: CodeSlinger69 (01-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func readConfig($inputfile = $g_sProfileConfigPath) ;Reads config and sets it to the variables
	Static $iReadConfigCount = 0
	If $g_bReadConfigIsActive Then
		SetDebugLog("readConfig(), already running, exit")
		Return
	EndIf
	$g_bReadConfigIsActive = True
	$iReadConfigCount += 1
	SetDebugLog("readConfig(), call number " & $iReadConfigCount)

	; Read the stats files into arrays, will create the files if necessary
	$g_aiWeakBaseStats = readWeakBaseStats()

	ReadProfileConfig()
	If FileExists($g_sProfileBuildingPath) Then ReadBuildingConfig()
	If FileExists($g_sProfileConfigPath) Then ReadRegularConfig()

	$g_bReadConfigIsActive = False
EndFunc   ;==>readConfig

Func ReadProfileConfig($sIniFile = $g_sProfilePath & "\profile.ini")
	If FileExists($sIniFile) = 0 Then Return False
	Local $iValue, $sValue
	; defaultprofile read not required
	;$g_sProfileCurrentName = StringRegExpReplace(IniRead($sIniFile, "general", "defaultprofile", ""), '[/:*?"<>|]', '_')

	$iValue = $g_iGlobalActiveBotsAllowed
	$g_iGlobalActiveBotsAllowed = Int(IniRead($sIniFile, "general", "globalactivebotsallowed", $g_iGlobalActiveBotsAllowed))
	If $g_iGlobalActiveBotsAllowed < 1 Then $g_iGlobalActiveBotsAllowed = 2 ; ensure that multiple bots can run
	If $iValue <> $g_iGlobalActiveBotsAllowed Then
		SetDebugLog("Maximum of " & $iValue & " bots running at same time changed to " & $g_iGlobalActiveBotsAllowed)
	EndIf

	$iValue = $g_iGlobalThreads
	$g_iGlobalThreads = Int(IniRead($sIniFile, "general", "globalthreads", $g_iGlobalThreads))
	If $iValue <> $g_iGlobalThreads Then
		SetDebugLog("Threading: Using " & $g_iGlobalThreads & " threads shared across all bot instances changed to " & $iValue)
	EndIf

	$sValue = IniRead($sIniFile, "general", "adb.path", $g_sAndroidAdbPath)
	If FileExists($sValue) Then $g_sAndroidAdbPath = $sValue

	Return True
EndFunc   ;==>ReadProfileConfig

Func ReadBuildingConfig()
	SetDebugLog("Read Building Config " & $g_sProfileBuildingPath)
	Local $locationsInvalid = False
	Local $buildingVersion = "0.0.0"
	IniReadS($buildingVersion, $g_sProfileBuildingPath, "general", "version", $buildingVersion)
	Local $_ver630 = GetVersionNormalized("6.3.0")
	Local $_ver63u = GetVersionNormalized("6.3.u")
	Local $_ver63u3 = GetVersionNormalized("6.3.u3")
	If $buildingVersion < $_ver630 _
			Or ($buildingVersion >= $_ver63u And $buildingVersion <= $_ver63u3) Then
		SetLog("New MyBot.run version! Re-locate all buildings!", $COLOR_WARNING)
		$locationsInvalid = True
	EndIf

	IniReadS($g_iTownHallLevel, $g_sProfileBuildingPath, "other", "LevelTownHall", 0, "int")

	If $locationsInvalid = False Then
		IniReadS($g_aiTownHallPos[0], $g_sProfileBuildingPath, "other", "xTownHall", -1, "int")
		IniReadS($g_aiTownHallPos[1], $g_sProfileBuildingPath, "other", "yTownHall", -1, "int")

		IniReadS($g_aiClanCastlePos[0], $g_sProfileBuildingPath, "other", "xCCPos", -1, "int")
		IniReadS($g_aiClanCastlePos[1], $g_sProfileBuildingPath, "other", "yCCPos", -1, "int")

		;IniReadS($barrackPos[0][0], $g_sProfileBuildingPath, "other", "xBarrack1", -1, "int")
		;IniReadS($barrackPos[0][1], $g_sProfileBuildingPath, "other", "yBarrack1", -1, "int")

		;IniReadS($barrackPos[1][0], $g_sProfileBuildingPath, "other", "xBarrack2", -1, "int")
		;IniReadS($barrackPos[1][1], $g_sProfileBuildingPath, "other", "yBarrack2", -1, "int")

		;IniReadS($barrackPos[2][0], $g_sProfileBuildingPath, "other", "xBarrack3", -1, "int")
		;IniReadS($barrackPos[2][1], $g_sProfileBuildingPath, "other", "yBarrack3", -1, "int")

		;IniReadS($barrackPos[3][0], $g_sProfileBuildingPath, "other", "xBarrack4", -1, "int")
		;IniReadS($barrackPos[3][1], $g_sProfileBuildingPath, "other", "yBarrack4", -1, "int")

		;IniReadS($SFPos[0], $g_sProfileBuildingPath, "other", "xspellfactory", -1, "int")
		;IniReadS($SFPos[1], $g_sProfileBuildingPath, "other", "yspellfactory", -1, "int")

		;IniReadS($DSFPos[0], $g_sProfileBuildingPath, "other", "xDspellfactory", -1, "int")
		;IniReadS($DSFPos[1], $g_sProfileBuildingPath, "other", "yDspellfactory", -1, "int")

		IniReadS($g_aiKingAltarPos[0], $g_sProfileBuildingPath, "other", "xKingAltarPos", -1, "int")
		IniReadS($g_aiKingAltarPos[1], $g_sProfileBuildingPath, "other", "yKingAltarPos", -1, "int")

		IniReadS($g_aiQueenAltarPos[0], $g_sProfileBuildingPath, "other", "xQueenAltarPos", -1, "int")
		IniReadS($g_aiQueenAltarPos[1], $g_sProfileBuildingPath, "other", "yQueenAltarPos", -1, "int")

		IniReadS($g_aiWardenAltarPos[0], $g_sProfileBuildingPath, "other", "xWardenAltarPos", -1, "int")
		IniReadS($g_aiWardenAltarPos[1], $g_sProfileBuildingPath, "other", "yWardenAltarPos", -1, "int")

		IniReadS($g_aiLaboratoryPos[0], $g_sProfileBuildingPath, "upgrade", "LabPosX", -1, "int")
		IniReadS($g_aiLaboratoryPos[1], $g_sProfileBuildingPath, "upgrade", "LabPosY", -1, "int")
	EndIf

	IniReadS($g_aiLastGoodWallPos[0], $g_sProfileBuildingPath, "upgrade", "xLastGoodWallPos", -1, "int")
	IniReadS($g_aiLastGoodWallPos[1], $g_sProfileBuildingPath, "upgrade", "yLastGoodWallPos", -1, "int")

	IniReadS($g_iTotalCampSpace, $g_sProfileBuildingPath, "other", "totalcamp", 0, "int")

	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1 ; Reads Upgrade building data
		$g_avBuildingUpgrades[$iz][0] = IniRead($g_sProfileBuildingPath, "upgrade", "xupgrade" & $iz, "-1")
		$g_avBuildingUpgrades[$iz][1] = IniRead($g_sProfileBuildingPath, "upgrade", "yupgrade" & $iz, "-1")
		$g_avBuildingUpgrades[$iz][2] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradevalue" & $iz, "-1")
		$g_avBuildingUpgrades[$iz][3] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradetype" & $iz, "")
		$g_avBuildingUpgrades[$iz][4] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradename" & $iz, "")
		$g_avBuildingUpgrades[$iz][5] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradelevel" & $iz, "")
		$g_avBuildingUpgrades[$iz][6] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradetime" & $iz, "")
		$g_avBuildingUpgrades[$iz][7] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradeend" & $iz, "-1")
		$g_abBuildingUpgradeEnable[$iz] = (IniRead($g_sProfileBuildingPath, "upgrade", "upgradechk" & $iz, 0) = "1")
		$g_abUpgradeRepeatEnable[$iz] = (IniRead($g_sProfileBuildingPath, "upgrade", "upgraderepeat" & $iz, 0) = "1")
		$g_aiPicUpgradeStatus[$iz] = IniRead($g_sProfileBuildingPath, "upgrade", "upgradestatusicon" & $iz, $eIcnTroops)

		If $locationsInvalid = True Then
			$g_avBuildingUpgrades[$iz][0] = -1
			$g_avBuildingUpgrades[$iz][1] = -1
			$g_abBuildingUpgradeEnable[$iz] = False
			$g_abUpgradeRepeatEnable[$iz] = False
		EndIf
	Next
EndFunc   ;==>ReadBuildingConfig

Func ReadRegularConfig()
	SetDebugLog("Read Config " & $g_sProfileConfigPath)

	; <><><><> Bot / Debug <><><><>
	ReadConfig_Debug()

	IniReadS($g_iThreads, $g_sProfileConfigPath, "general", "threads", $g_iThreads, "int")
	If $g_iThreads < 0 Then $g_iThreads = 0
	IniReadS($g_iBotDesignFlags, $g_sProfileConfigPath, "general", "botDesignFlags", 0, "int") ; Default for existing profiles is 0, for new is 3

	; Window positions
	IniReadS($g_iFrmBotPosX, $g_sProfileConfigPath, "general", "frmBotPosX", $g_iFrmBotPosX, "int")
	IniReadS($g_iFrmBotPosY, $g_sProfileConfigPath, "general", "frmBotPosY", $g_iFrmBotPosY, "int")
	If $g_iFrmBotPosX < -30000 Or $g_iFrmBotPosY < -30000 Then
		; bot window was minimized, restore default position
		$g_iFrmBotPosX = $g_WIN_POS_DEFAULT
		$g_iFrmBotPosY = $g_WIN_POS_DEFAULT
	EndIf

	IniReadS($g_iAndroidPosX, $g_sProfileConfigPath, "general", "AndroidPosX", $g_iAndroidPosX, "int")
	IniReadS($g_iAndroidPosY, $g_sProfileConfigPath, "general", "AndroidPosY", $g_iAndroidPosY, "int")
	If $g_iAndroidPosX < -30000 Or $g_iAndroidPosY < -30000 Then
		; bot window was minimized, restore default position
		$g_iAndroidPosX = $g_WIN_POS_DEFAULT
		$g_iAndroidPosY = $g_WIN_POS_DEFAULT
	EndIf

	IniReadS($g_iFrmBotDockedPosX, $g_sProfileConfigPath, "general", "frmBotDockedPosX", $g_iFrmBotDockedPosX, "int")
	IniReadS($g_iFrmBotDockedPosY, $g_sProfileConfigPath, "general", "frmBotDockedPosY", $g_iFrmBotDockedPosY, "int")
	If $g_iFrmBotDockedPosX < -30000 Or $g_iFrmBotDockedPosY < -30000 Then
		; bot window was minimized, restore default position
		$g_iFrmBotDockedPosX = $g_WIN_POS_DEFAULT
		$g_iFrmBotDockedPosY = $g_WIN_POS_DEFAULT
	EndIf

	; Redraw mode:  0 = disabled, 1 = Redraw always entire bot window, 2 = Redraw only required bot window area (or entire bot if control not specified)
	IniReadS($g_iRedrawBotWindowMode, $g_sProfileConfigPath, "general", "RedrawBotWindowMode", 2, "int")

	; <><><><> Bot / Android <><><><>
	ReadConfig_Android()
	; <><><><> Log window <><><><>
	ReadConfig_600_1()
	; <><><><> Village / Misc <><><><>
	ReadConfig_600_6()
	; <><><><> Village / Achievements <><><><>
	ReadConfig_600_9()
	; <><><><> Village / Donate - Request <><><><>
	ReadConfig_600_11()
	; <><><><> Village / Donate - Donate <><><><>
	ReadConfig_600_12()
	; <><><><> Village / Donate - Schedule <><><><>
	ReadConfig_600_13()
	; <><><><> Village / Upgrade - Lab <><><><>
	ReadConfig_600_14()
	; <><><><> Village / Upgrade - Heroes <><><><>
	ReadConfig_600_15()
	; <><><><> Village / Upgrade - Buildings <><><><>
	ReadConfig_600_16()
	; <><><><> Village / Upgrade - Auto Upgrade <><><><>
	ReadConfig_auto()
	; <><><><> Village / Upgrade - Walls <><><><>
	ReadConfig_600_17()
	; <><><><> Village / Notify <><><><>
	ReadConfig_600_18()
	; <><><><> Village / Notify <><><><>
	ReadConfig_600_19()
	; <><><> Attack Plan / Train Army / Boost <><><>
	ReadConfig_600_22()
	; <><><><> Attack Plan / Search & Attack / Bully <><><><>
	ReadConfig_600_26()
	; <><><><> Attack Plan / Search & Attack / Options / Search <><><><>
	ReadConfig_600_28()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Search <><><><>
	ReadConfig_600_28_DB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Search <><><><>
	ReadConfig_600_28_LB()
	; <><><><> Attack Plan / Search & Attack / TH Snipe / Search <><><><>
	ReadConfig_600_28_TS()
	; <><><><> Attack Plan / Search & Attack / Options / Attack <><><><>
	ReadConfig_600_29()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack <><><><>
	ReadConfig_600_29_DB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack <><><><>
	ReadConfig_600_29_LB()
	; <><><><> Attack Plan / Search & Attack / TH Snipe / Attack <><><><>
	ReadConfig_600_29_TS()
	; <><><><> Attack Plan / Search & Attack / Options / End Battle <><><><>
	ReadConfig_600_30()
	; <><><><> Attack Plan / Search & Attack / Deadbase / End Battle <><><><>
	ReadConfig_600_30_DB()
	; <><><><> Attack Plan / Search & Attack / Activebase / End Battle <><><><>
	ReadConfig_600_30_LB()
	; <><><><> Attack Plan / Search & Attack / TH Snipe / End Battle <><><><>
	ReadConfig_600_30_TS()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Collectors <><><><>
	ReadConfig_600_31()
	; <><><><> Attack Plan / Search & Attack / Options / Trophy Settings <><><><>
	ReadConfig_600_32()
	; <><><><> Attack Plan / Search & Attack / Drop Order Troops <><><><>
	ReadConfig_600_33()
	; <><><><> Bot / Options <><><><>
	ReadConfig_600_35_1()
	; <><><><> Bot / Profile / Switch Account <><><><>
	ReadConfig_600_35_2()
	; <><><> Attack Plan / Train Army / Troops/Spells <><><>
	; Quick train
	ReadConfig_600_52_1()
	; troop/spell levels and counts
	ReadConfig_600_52_2()
	; <><><> Attack Plan / Train Army / Train Order <><><>
	ReadConfig_600_54()
	; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
	ReadConfig_600_56()
	; <><><> Attack Plan / Train Army / Options <><><>
	ReadConfig_641_1()

	; <><><><> Attack Plan / Strategies <><><><>
	; <<< nothing here >>>

	; <><><><> Bot / Android <><><><>
	; <<< nothing here >>>

	; <><><><> Bot / Debug <><><><>
	; Settings at top of this function for easy access

	; <><><><> Bot / Profiles <><><><>
	; <<< nothing here >>>

	; <><><><> Bot / Stats <><><><>
	; <<< nothing here >>>
EndFunc   ;==>ReadRegularConfig

Func ReadConfig_Debug()
	; Debug settings
	$g_bDebugSetlog = IniRead($g_sProfileConfigPath, "debug", "debugsetlog", 0) = 1 ? True : False
	$g_bDebugAndroid = IniRead($g_sProfileConfigPath, "debug", "debugAndroid", 0) = 1 ? True : False
	$g_bDebugClick = IniRead($g_sProfileConfigPath, "debug", "debugsetclick", 0) = 1 ? True : False
	If $g_bDevMode Then
		Local $bDebugFunc = IniRead($g_sProfileConfigPath, "debug", "debugFunc", 0) = 1 ? True : False
		$g_bDebugFuncTime = $bDebugFunc
		$g_bDebugFuncCall = $bDebugFunc
		$g_bDebugDisableZoomout = IniRead($g_sProfileConfigPath, "debug", "disablezoomout", 0) = 1 ? True : False
		$g_bDebugDisableVillageCentering = IniRead($g_sProfileConfigPath, "debug", "disablevillagecentering", 0) = 1 ? True : False
		$g_bDebugDeadBaseImage = IniRead($g_sProfileConfigPath, "debug", "debugdeadbaseimage", 0) = 1 ? True : False
		$g_bDebugOcr = IniRead($g_sProfileConfigPath, "debug", "debugocr", 0) = 1 ? True : False
		$g_bDebugImageSave = IniRead($g_sProfileConfigPath, "debug", "debugimagesave", 0) = 1 ? True : False
		$g_bDebugBuildingPos = IniRead($g_sProfileConfigPath, "debug", "debugbuildingpos", 0) = 1 ? True : False
		$g_bDebugSetlogTrain = IniRead($g_sProfileConfigPath, "debug", "debugtrain", 0) = 1 ? True : False
		$g_bDebugResourcesOffset = IniRead($g_sProfileConfigPath, "debug", "debugresourcesoffset", 0) = 1 ? True : False
		$g_bDebugContinueSearchElixir = IniRead($g_sProfileConfigPath, "debug", "continuesearchelixirdebug", 0) = 1 ? True : False
		$g_bDebugMilkingIMGmake = IniRead($g_sProfileConfigPath, "debug", "debugMilkingIMGmake", 0) = 1 ? True : False
		$g_bDebugOCRdonate = IniRead($g_sProfileConfigPath, "debug", "debugOCRDonate", 0) = 1 ? True : False
		$g_bDebugAttackCSV = IniRead($g_sProfileConfigPath, "debug", "debugAttackCSV", 0) = 1 ? True : False
		$g_bDebugMakeIMGCSV = IniRead($g_sProfileConfigPath, "debug", "debugmakeimgcsv", 0) = 1 ? True : False
		$g_bDebugSmartZap = BitOR($g_bDebugSmartZap, Int(IniRead($g_sProfileConfigPath, "debug", "DebugSmartZap", 0)))
	EndIf
EndFunc   ;==>ReadConfig_Debug

Func ReadConfig_Android()
	; Android Configuration
	$g_sAndroidGameDistributor = IniRead($g_sProfileConfigPath, "android", "game.distributor", $g_sAndroidGameDistributor)
	$g_sAndroidGamePackage = IniRead($g_sProfileConfigPath, "android", "game.package", $g_sAndroidGamePackage)
	$g_sAndroidGameClass = IniRead($g_sProfileConfigPath, "android", "game.class", $g_sAndroidGameClass)
	$g_sUserGameDistributor = IniRead($g_sProfileConfigPath, "android", "user.distributor", $g_sUserGameDistributor)
	$g_sUserGamePackage = IniRead($g_sProfileConfigPath, "android", "user.package", $g_sUserGamePackage)
	$g_sUserGameClass = IniRead($g_sProfileConfigPath, "android", "user.class", $g_sUserGameClass)
	$g_iAndroidBackgroundMode = Int(IniRead($g_sProfileConfigPath, "android", "backgroundmode", $g_iAndroidBackgroundMode))
	$g_bAndroidCheckTimeLagEnabled = Int(IniRead($g_sProfileConfigPath, "android", "check.time.lag.enabled", ($g_bAndroidCheckTimeLagEnabled ? 1 : 0))) = 1
	$g_iAndroidAdbScreencapTimeoutMin = Int(IniRead($g_sProfileConfigPath, "android", "adb.screencap.timeout.min", $g_iAndroidAdbScreencapTimeoutMin))
	$g_iAndroidAdbScreencapTimeoutMax = Int(IniRead($g_sProfileConfigPath, "android", "adb.screencap.timeout.max", $g_iAndroidAdbScreencapTimeoutMax))
	$g_iAndroidAdbScreencapTimeoutDynamic = Int(IniRead($g_sProfileConfigPath, "android", "adb.screencap.timeout.dynamic", $g_iAndroidAdbScreencapTimeoutDynamic))
	$g_bAndroidAdbInputEnabled = Int(IniRead($g_sProfileConfigPath, "android", "adb.input.enabled", ($g_bAndroidAdbInputEnabled ? 1 : 0))) = 1
	$g_bAndroidAdbClickEnabled = Int(IniRead($g_sProfileConfigPath, "android", "adb.click.enabled", ($g_bAndroidAdbClickEnabled ? 1 : 0))) = 1
	$g_bAndroidAdbClickDragScript = Int(IniRead($g_sProfileConfigPath, "android", "adb.click.drag.script", (BitAND($g_iAndroidSupportFeature, 128) ? 0 : 1))) = 1 ; if bit is 0, enable script
	$g_iAndroidAdbClickGroup = Int(IniRead($g_sProfileConfigPath, "android", "adb.click.group", $g_iAndroidAdbClickGroup))
	$g_bAndroidAdbClicksEnabled = Int(IniRead($g_sProfileConfigPath, "android", "adb.clicks.enabled", ($g_bAndroidAdbClicksEnabled ? 1 : 0))) = 1
	$g_iAndroidAdbClicksTroopDeploySize = Int(IniRead($g_sProfileConfigPath, "android", "adb.clicks.troop.deploy.size", $g_iAndroidAdbClicksTroopDeploySize))
	$g_bNoFocusTampering = Int(IniRead($g_sProfileConfigPath, "android", "no.focus.tampering", ($g_bNoFocusTampering ? 1 : 0))) = 1
	$g_iAndroidShieldColor = Dec(IniRead($g_sProfileConfigPath, "android", "shield.color", Hex($g_iAndroidShieldColor, 6)))
	$g_iAndroidShieldTransparency = Int(IniRead($g_sProfileConfigPath, "android", "shield.transparency", $g_iAndroidShieldTransparency))
	$g_iAndroidActiveColor = Dec(IniRead($g_sProfileConfigPath, "android", "active.color", Hex($g_iAndroidActiveColor, 6)))
	$g_iAndroidActiveTransparency = Int(IniRead($g_sProfileConfigPath, "android", "active.transparency", $g_iAndroidActiveTransparency))
	$g_iAndroidInactiveColor = Dec(IniRead($g_sProfileConfigPath, "android", "inactive.color", Hex($g_iAndroidInactiveColor, 6)))
	$g_iAndroidInactiveTransparency = Int(IniRead($g_sProfileConfigPath, "android", "inactive.transparency", $g_iAndroidInactiveTransparency))
	$g_iAndroidSuspendModeFlags = Int(IniRead($g_sProfileConfigPath, "android", "suspend.mode", $g_iAndroidSuspendModeFlags))
	$g_iAndroidRebootHours = Int(IniRead($g_sProfileConfigPath, "android", "reboot.hours", $g_iAndroidRebootHours))
	$g_bAndroidCloseWithBot = Int(IniRead($g_sProfileConfigPath, "android", "close", $g_bAndroidCloseWithBot ? 1 : 0)) = 1
	$g_iAndroidProcessAffinityMask = Int(IniRead($g_sProfileConfigPath, "android", "process.affinity.mask", $g_iAndroidProcessAffinityMask))

	If $g_bBotLaunchOption_Restart = True Or $g_asCmdLine[0] < 2 Then
		; for now only read when bot crashed and restarted through watchdog or nofify event
		Local $sAndroidEmulator = IniRead($g_sProfileConfigPath, "android", "emulator", "")
		Local $sAndroidInstance = IniRead($g_sProfileConfigPath, "android", "instance", "")
		If $sAndroidEmulator <> "" Then
			#cs Not required yet
				If $g_hFrmBot = 0 Then
				; early readConfig during bot launch: use command line if specified
				If $g_asCmdLine[0] > 1 Then
				If $g_asCmdLine[1] <> $sAndroidEmulator Then
				$sAndroidEmulator = $g_asCmdLine[1]
				SetDebugLog("Override Android Emulator by command line: " & $sAndroidEmulator)
				EndIf
				If $g_asCmdLine[0] > 2 Then
				If $g_asCmdLine[2] <> $sAndroidInstance Then
				$sAndroidInstance = $g_asCmdLine[2]
				SetDebugLog("Override Android Instance by command line: " & $sAndroidInstance)
				EndIf
				EndIf
				EndIf
				EndIf
			#ce

			If $sAndroidEmulator <> $g_sAndroidEmulator Or $sAndroidInstance <> $g_sAndroidInstance Then
				; check if Android Emulator or Instance changed, then invalidate Android Handle
				UpdateHWnD(0)
				UpdateAndroidConfig($sAndroidInstance, $sAndroidEmulator)
			EndIf
		Else
			; flag that detection must run
			$g_bBotLaunchOption_Restart = False
		EndIf
	EndIf

EndFunc   ;==>ReadConfig_Android

Func ReadConfig_600_1()
	; <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	; GUI Settings
	; <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	; <><><><> Log window <><><><>
	IniReadS($g_iCmbLogDividerOption, $g_sProfileConfigPath, "general", "logstyle", 0, "int")
	IniReadS($g_iLogDividerY, $g_sProfileConfigPath, "general", "LogDividerY", 243, "int")
	; <><><><> Bottom panel <><><><>
	IniReadS($g_bChkBackgroundMode, $g_sProfileConfigPath, "general", "Background", True, "Bool")
EndFunc   ;==>ReadConfig_600_1

Func ReadConfig_600_6()
	; <><><><> Village / Misc <><><><>
	IniReadS($g_bChkBotStop, $g_sProfileConfigPath, "general", "BotStop", False, "Bool")
	IniReadS($g_iCmbBotCommand, $g_sProfileConfigPath, "general", "Command", 0, "int")
	IniReadS($g_iCmbBotCond, $g_sProfileConfigPath, "general", "Cond", 0, "int")
	IniReadS($g_iCmbHoursStop, $g_sProfileConfigPath, "general", "Hour", 0, "int")
	IniReadS($g_iTxtRestartGold, $g_sProfileConfigPath, "other", "minrestartgold", 50000, "int")
	IniReadS($g_iTxtRestartElixir, $g_sProfileConfigPath, "other", "minrestartelixir", 50000, "int")
	IniReadS($g_iTxtRestartDark, $g_sProfileConfigPath, "other", "minrestartdark", 500, "int")
	IniReadS($g_bChkTrap, $g_sProfileConfigPath, "other", "chkTrap", True, "Bool")
	IniReadS($g_bChkCollect, $g_sProfileConfigPath, "other", "chkCollect", True, "Bool")
	IniReadS($g_bChkTombstones, $g_sProfileConfigPath, "other", "chkTombstones", True, "Bool")
	IniReadS($g_bChkCleanYard, $g_sProfileConfigPath, "other", "chkCleanYard", False, "Bool")
	IniReadS($g_bChkGemsBox, $g_sProfileConfigPath, "other", "chkGemsBox", False, "Bool")
	IniReadS($g_bChkCollectFreeMagicItems, $g_sProfileConfigPath, "other", "ChkCollectFreeMagicItems", False, "Bool")
	IniReadS($g_bChkTreasuryCollect, $g_sProfileConfigPath, "other", "ChkTreasuryCollect", False, "Bool")
	IniReadS($g_iTxtTreasuryGold, $g_sProfileConfigPath, "other", "minTreasurygold", 0, "int")
	IniReadS($g_iTxtTreasuryElixir, $g_sProfileConfigPath, "other", "minTreasuryelixir", 0, "int")
	IniReadS($g_iTxtTreasuryDark, $g_sProfileConfigPath, "other", "minTreasurydark", 0, "int")

	IniReadS($g_bChkCollectBuilderBase, $g_sProfileConfigPath, "other", "ChkCollectBuildersBase", False, "Bool")
	IniReadS($g_bChkStartClockTowerBoost, $g_sProfileConfigPath, "other", "ChkStartClockTowerBoost", False, "Bool")
	IniReadS($g_bChkCTBoostBlderBz, $g_sProfileConfigPath, "other", "ChkCTBoostBlderBz", False, "Bool")
	IniReadS($g_iChkBBSuggestedUpgrades, $g_sProfileConfigPath, "other", "ChkBBSuggestedUpgrades", $g_iChkBBSuggestedUpgrades, "Int")
	IniReadS($g_iChkBBSuggestedUpgradesIgnoreGold, $g_sProfileConfigPath, "other", "ChkBBSuggestedUpgradesIgnoreGold", $g_iChkBBSuggestedUpgradesIgnoreGold, "Int")
	IniReadS($g_iChkBBSuggestedUpgradesIgnoreElixir, $g_sProfileConfigPath, "other", "ChkBBSuggestedUpgradesIgnoreElixir", $g_iChkBBSuggestedUpgradesIgnoreElixir, "Int")
	IniReadS($g_iChkBBSuggestedUpgradesIgnoreHall, $g_sProfileConfigPath, "other", "ChkBBSuggestedUpgradesIgnoreHall", $g_iChkBBSuggestedUpgradesIgnoreHall, "Int")

	IniReadS($g_iChkPlacingNewBuildings, $g_sProfileConfigPath, "other", "ChkPlacingNewBuildings", $g_iChkPlacingNewBuildings, "Int")

	IniReadS($g_bChkClanGamesAir, $g_sProfileConfigPath, "other", "ChkClanGamesAir", False, "Bool")
	IniReadS($g_bChkClanGamesGround, $g_sProfileConfigPath, "other", "ChkClanGamesGround", False, "Bool")
	IniReadS($g_bChkClanGamesMisc, $g_sProfileConfigPath, "other", "ChkClanGamesMisc", False, "Bool")

	IniReadS($g_bChkClanGamesEnabled, $g_sProfileConfigPath, "other", "ChkClanGamesEnabled", False, "Bool")
	IniReadS($g_bChkClanGamesPurge, $g_sProfileConfigPath, "other", "ChkClanGamesPurge", False, "Bool")
	IniReadS($g_bChkClanGamesStopBeforeReachAndPurge, $g_sProfileConfigPath, "other", "ChkClanGamesStopBeforeReachAndPurge", False, "Bool")
	IniReadS($g_bChkClanGamesDebug, $g_sProfileConfigPath, "other", "ChkClanGamesDebug", False, "Bool")

	IniReadS($g_bChkClanGamesLoot, $g_sProfileConfigPath, "other", "ChkClanGamesLoot", False, "Bool")
	IniReadS($g_bChkClanGamesBattle, $g_sProfileConfigPath, "other", "ChkClanGamesBattle", False, "Bool")
	IniReadS($g_bChkClanGamesDestruction, $g_sProfileConfigPath, "other", "ChkClanGamesDestruction", False, "Bool")
	IniReadS($g_bChkClanGamesAirTroop, $g_sProfileConfigPath, "other", "ChkClanGamesAirTroop", False, "Bool")
	IniReadS($g_bChkClanGamesGroundTroop, $g_sProfileConfigPath, "other", "ChkClanGamesGroundTroop", False, "Bool")
	IniReadS($g_bChkClanGamesMiscellaneous, $g_sProfileConfigPath, "other", "ChkClanGamesMiscellaneous", False, "Bool")
	IniReadS($g_iPurgeMax, $g_sProfileConfigPath, "other", "PurgeMax", 5, "int")
EndFunc   ;==>ReadConfig_600_6

Func ReadConfig_600_9()
	; <><><><> Village / Achievements <><><><>
	IniReadS($g_iUnbrkMode, $g_sProfileConfigPath, "Unbreakable", "chkUnbreakable", 0, "int")
	IniReadS($g_iUnbrkWait, $g_sProfileConfigPath, "Unbreakable", "UnbreakableWait", 5, "int")
	IniReadS($g_iUnbrkMinGold, $g_sProfileConfigPath, "Unbreakable", "minUnBrkgold", 50000, "int")
	IniReadS($g_iUnbrkMaxGold, $g_sProfileConfigPath, "Unbreakable", "maxUnBrkgold", 600000, "int")
	IniReadS($g_iUnbrkMinElixir, $g_sProfileConfigPath, "Unbreakable", "minUnBrkelixir", 50000, "int")
	IniReadS($g_iUnbrkMaxElixir, $g_sProfileConfigPath, "Unbreakable", "maxUnBrkelixir", 600000, "int")
	IniReadS($g_iUnbrkMinDark, $g_sProfileConfigPath, "Unbreakable", "minUnBrkdark", 5000, "int")
	IniReadS($g_iUnbrkMaxDark, $g_sProfileConfigPath, "Unbreakable", "maxUnBrkdark", 10000, "int")
EndFunc   ;==>ReadConfig_600_9

Func ReadConfig_600_11()
	; <><><><> Village / Donate - Request <><><><>
	$g_bRequestTroopsEnable = (IniRead($g_sProfileConfigPath, "planned", "RequestHoursEnable", "0") = "1")
	$g_sRequestTroopsText = IniRead($g_sProfileConfigPath, "donate", "txtRequest", "")
	$g_abRequestCCHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "RequestHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 23
		$g_abRequestCCHours[$i] = ($g_abRequestCCHours[$i] = "1")
	Next
EndFunc   ;==>ReadConfig_600_11

Func ReadConfig_600_12()
	; <><><><> Village / Donate - Donate <><><><>
	IniReadS($g_bChkDonate, $g_sProfileConfigPath, "donate", "Doncheck", True, "Bool")
	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs
		Local $sIniName = ""
		If $i >= $eTroopBarbarian And $i <= $eTroopBowler Then
			$sIniName = StringReplace($g_asTroopNamesPlural[$i], " ", "")
		ElseIf $i = $eCustomA Then
			$sIniName = "CustomA"
		ElseIf $i = $eCustomB Then
			$sIniName = "CustomB"
		ElseIf $i = $eCustomC Then
			$sIniName = "CustomC"
		ElseIf $i = $eCustomD Then
			$sIniName = "CustomD"
		EndIf

		$g_abChkDonateTroop[$i] = (IniRead($g_sProfileConfigPath, "donate", "chkDonate" & $sIniName, "0") = "1")
		$g_abChkDonateAllTroop[$i] = (IniRead($g_sProfileConfigPath, "donate", "chkDonateAll" & $sIniName, "0") = "1")
	Next

	$g_asTxtDonateTroop[$eTroopBarbarian] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateBarbarians", "barbarians|barbarian|barb"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopBarbarian] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistBarbarians", "no barbarians|no barb|barbarian no|barb no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopArcher] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateArchers", "archers|archer|arch"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopArcher] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistArchers", "no archers|no arch|archer no|arch no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopGiant] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateGiants", "giants|giant|any"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopGiant] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistGiants", "no giants|giants no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopGoblin] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateGoblins", "goblins|goblin"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopGoblin] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistGoblins", "no goblins|goblins no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopWallBreaker] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateWallBreakers", "wall breakers|wb"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopWallBreaker] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistWallBreakers", "no wallbreakers|wb no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopBalloon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateBalloons", "balloons|balloon"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopBalloon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistBalloons", "no balloon|balloons no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopWizard] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateWizards", "wizards|wizard|wiz"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopWizard] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistWizards", "no wizards|wizards no|no wizard|wizard no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopHealer] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateHealers", "healer"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopHealer] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistHealers", "no healer|healer no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopDragon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateDragons", "dragon"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopDragon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistDragons", "no dragon|dragon no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopPekka] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonatePekkas", "PEKKA|pekka"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopPekka] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistPekkas", "no PEKKA|pekka no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopBabyDragon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateBabyDragons", "baby dragon|baby"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopBabyDragon] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistBabyDragons", "no baby dragon|baby dragon no|no baby|baby no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopMiner] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateMiners", "miner|mine"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopMiner] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistMiners", "no miner|miner no|no mine|mine no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopMinion] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateMinions", "minions|minion"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopMinion] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistMinions", "no minion|minions no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopHogRider] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateHogRiders", "hogriders|hogs|hog"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopHogRider] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistHogRiders", "no hogriders|hogriders no|no hog|hogs no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopValkyrie] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateValkyries", "valkyries|valkyrie|valk"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopValkyrie] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistValkyries", "no valkyrie|valkyries no|no valk|valk no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopGolem] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateGolems", "golem"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopGolem] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistGolems", "no golem|golem no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopWitch] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateWitches", "witches|witch"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopWitch] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistWitches", "no witches|witches no|no witch|witch no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopLavaHound] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateLavaHounds", "lavahounds|lava|hound"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopLavaHound] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistLavaHounds", "no lavahound|lavahound no|no lava|lava no|nohound|hound no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eTroopBowler] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateBowlers", "bowler|bowl"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eTroopBowler] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistBowlers", "no bowler|bowl no"), "|", @CRLF)

	$g_asTxtDonateTroop[$eCustomA] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomA", "ground support|ground"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eCustomA] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistCustomA", "no ground|ground no|nonly"), "|", @CRLF)

	$g_asTxtDonateTroop[$eCustomB] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomB", "air support|any air"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eCustomB] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistCustomB", "no air|air no|only|just"), "|", @CRLF)

	$g_asTxtDonateTroop[$eCustomC] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomC", "ground support|ground"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eCustomC] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistCustomC", "no ground|ground no|nonly"), "|", @CRLF)

	$g_asTxtDonateTroop[$eCustomD] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomD", "air support|any air"), "|", @CRLF)
	$g_asTxtBlacklistTroop[$eCustomD] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistCustomD", "no air|air no|only|just"), "|", @CRLF)

	For $i = 0 To $eSpellCount - 1
		If $i <> $eSpellClone Then
			Local $sIniName = $g_asSpellNames[$i] & "Spells"
			$g_abChkDonateSpell[$i] = (IniRead($g_sProfileConfigPath, "donate", "chkDonate" & $sIniName, "0") = "1")
			$g_abChkDonateAllSpell[$i] = (IniRead($g_sProfileConfigPath, "donate", "chkDonateAll" & $sIniName, "0") = "1")
		EndIf
	Next

	$g_asTxtDonateSpell[$eSpellLightning] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateLightningSpells", "lightning"), "|", @CRLF)
	$g_asTxtBlacklistSpell[$eSpellLightning] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistLightningSpells", "no lightning|lightning no"), "|", @CRLF)

	$g_asTxtDonateSpell[$eSpellHeal] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateHealSpells", "heal"), "|", @CRLF)
	$g_asTxtBlacklistSpell[$eSpellHeal] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistHealSpells", "no heal|heal no"), "|", @CRLF)

	$g_asTxtDonateSpell[$eSpellRage] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateRageSpells", "rage"), "|", @CRLF)
	$g_asTxtBlacklistSpell[$eSpellRage] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistRageSpells", "no rage|rage no"), "|", @CRLF)

	$g_asTxtDonateSpell[$eSpellJump] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateJumpSpells", "jump"), "|", @CRLF)
	$g_asTxtBlacklistSpell[$eSpellJump] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistJumpSpells", "no jump|jump no"), "|", @CRLF)

	$g_asTxtDonateSpell[$eSpellFreeze] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateFreezeSpells", "freeze"), "|", @CRLF)
	$g_asTxtBlacklistSpell[$eSpellFreeze] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistFreezeSpells", "no freeze|freeze no"), "|", @CRLF)

	$g_asTxtDonateSpell[$eSpellPoison] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonatePoisonSpells", "poison"), "|", @CRLF)
	$g_asTxtBlacklistSpell[$eSpellPoison] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistPoisonSpells", "no poison|poison no"), "|", @CRLF)

	$g_asTxtDonateSpell[$eSpellEarthquake] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateEarthQuakeSpells", "earthquake|quake"), "|", @CRLF)
	$g_asTxtBlacklistSpell[$eSpellEarthquake] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistEarthQuakeSpells", "no earthquake|quake no"), "|", @CRLF)

	$g_asTxtDonateSpell[$eSpellHaste] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateHasteSpells", "haste"), "|", @CRLF)
	$g_asTxtBlacklistSpell[$eSpellHaste] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistHasteSpells", "no haste|haste no"), "|", @CRLF)

	$g_asTxtDonateSpell[$eSpellSkeleton] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtDonateSkeletonSpells", "skeleton"), "|", @CRLF)
	$g_asTxtBlacklistSpell[$eSpellSkeleton] = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklistSkeletonSpells", "no skeleton|skeleton no"), "|", @CRLF)

	$g_aiDonateCustomTrpNumA[0][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomA1", 6))
	$g_aiDonateCustomTrpNumA[1][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomA2", 1))
	$g_aiDonateCustomTrpNumA[2][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomA3", 0))
	$g_aiDonateCustomTrpNumA[0][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomA1", 2))
	$g_aiDonateCustomTrpNumA[1][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomA2", 3))
	$g_aiDonateCustomTrpNumA[2][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomA3", 1))

	$g_aiDonateCustomTrpNumB[0][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomB1", 11))
	$g_aiDonateCustomTrpNumB[1][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomB2", 1))
	$g_aiDonateCustomTrpNumB[2][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomB3", 6))
	$g_aiDonateCustomTrpNumB[0][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomB1", 3))
	$g_aiDonateCustomTrpNumB[1][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomB2", 13))
	$g_aiDonateCustomTrpNumB[2][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomB3", 5))

	$g_aiDonateCustomTrpNumC[0][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomC1", 6))
	$g_aiDonateCustomTrpNumC[1][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomC2", 1))
	$g_aiDonateCustomTrpNumC[2][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomC3", 0))
	$g_aiDonateCustomTrpNumC[0][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomC1", 2))
	$g_aiDonateCustomTrpNumC[1][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomC2", 3))
	$g_aiDonateCustomTrpNumC[2][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomC3", 1))

	$g_aiDonateCustomTrpNumD[0][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomD1", 11))
	$g_aiDonateCustomTrpNumD[1][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomD2", 1))
	$g_aiDonateCustomTrpNumD[2][0] = Int(IniRead($g_sProfileConfigPath, "donate", "cmbDonateCustomD3", 6))
	$g_aiDonateCustomTrpNumD[0][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomD1", 3))
	$g_aiDonateCustomTrpNumD[1][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomD2", 13))
	$g_aiDonateCustomTrpNumD[2][1] = Int(IniRead($g_sProfileConfigPath, "donate", "txtDonateCustomD3", 5))

	$g_bChkExtraAlphabets = (IniRead($g_sProfileConfigPath, "donate", "chkExtraAlphabets", "0") = "1")
	$g_bChkExtraChinese = (IniRead($g_sProfileConfigPath, "donate", "chkExtraChinese", "0") = "1")
	$g_bChkExtraKorean = (IniRead($g_sProfileConfigPath, "donate", "chkExtraKorean", "0") = "1")
	$g_bChkExtraPersian = (IniRead($g_sProfileConfigPath, "donate", "chkExtraPersian", "0") = "1")

	$g_sTxtGeneralBlacklist = StringReplace(IniRead($g_sProfileConfigPath, "donate", "txtBlacklist", "clan war|war|cw"), "|", @CRLF)
EndFunc   ;==>ReadConfig_600_12

Func ReadConfig_600_13()
	; <><><><> Village / Donate - Schedule <><><><>
	$g_bDonateHoursEnable = (IniRead($g_sProfileConfigPath, "planned", "DonateHoursEnable", "0") = "1")
	$g_abDonateHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "DonateHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 23
		$g_abDonateHours[$i] = ($g_abDonateHours[$i] = "1")
	Next
	$g_iCmbDonateFilter = Int(IniRead($g_sProfileConfigPath, "donate", "cmbFilterDonationsCC", 0))
	$g_iDonateSkipNearFullPercent = Int(IniRead($g_sProfileConfigPath, "donate", "SkipDonateNearFulLTroopsPercentual", 90))
	$g_bDonateSkipNearFullEnable = (IniRead($g_sProfileConfigPath, "donate", "SkipDonateNearFulLTroopsEnable", "1") = "1")
EndFunc   ;==>ReadConfig_600_13

Func ReadConfig_600_14()
	IniReadS($g_bAutoLabUpgradeEnable, $g_sProfileBuildingPath, "upgrade", "upgradetroops", False, "Bool")
	IniReadS($g_iCmbLaboratory, $g_sProfileBuildingPath, "upgrade", "upgradetroopname", 0, "int")
	$g_sLabUpgradeTime = IniRead($g_sProfileBuildingPath, "upgrade", "upgradelabtime", "")
EndFunc   ;==>ReadConfig_600_14

Func ReadConfig_600_15()
	; <><><><> Village / Upgrade - Heroes <><><><>
	IniReadS($g_bUpgradeKingEnable, $g_sProfileConfigPath, "upgrade", "UpgradeKing", False, "Bool")
	IniReadS($g_bUpgradeQueenEnable, $g_sProfileConfigPath, "upgrade", "UpgradeQueen", False, "Bool")
	IniReadS($g_bUpgradeWardenEnable, $g_sProfileConfigPath, "upgrade", "UpgradeWarden", False, "Bool")
EndFunc   ;==>ReadConfig_600_15

Func ReadConfig_600_16()
	; <><><><> Village / Upgrade - Buildings <><><><>
	IniReadS($g_iUpgradeMinGold, $g_sProfileConfigPath, "upgrade", "minupgrgold", 100000, "int")
	IniReadS($g_iUpgradeMinElixir, $g_sProfileConfigPath, "upgrade", "minupgrelixir", 100000, "int")
	IniReadS($g_iUpgradeMinDark, $g_sProfileConfigPath, "upgrade", "minupgrdark", 2000, "int")
	; The other building settings are loaded in the ReadBuildingConfig() function
EndFunc   ;==>ReadConfig_600_16

Func ReadConfig_auto()
	; Auto Upgrade
	IniReadS($g_iChkAutoUpgrade, $g_sProfileConfigPath, "Auto Upgrade", "ChkAutoUpgrade", 0, "int")
	For $i = 0 To 12
		IniReadS($g_iChkUpgradesToIgnore[$i], $g_sProfileConfigPath, "Auto Upgrade", "ChkUpgradesToIgnore[" & $i & "]", $g_iChkUpgradesToIgnore[$i], "int")
	Next
	For $i = 0 To 2
		IniReadS($g_iChkResourcesToIgnore[$i], $g_sProfileConfigPath, "Auto Upgrade", "ChkResourcesToIgnore[" & $i & "]", $g_iChkResourcesToIgnore[$i], "int")
	Next
	IniReadS($g_iTxtSmartMinGold, $g_sProfileConfigPath, "Auto Upgrade", "SmartMinGold", 150000, "int")
	IniReadS($g_iTxtSmartMinElixir, $g_sProfileConfigPath, "Auto Upgrade", "SmartMinElixir", 150000, "int")
	IniReadS($g_iTxtSmartMinDark, $g_sProfileConfigPath, "Auto Upgrade", "SmartMinDark", 1500, "int")
EndFunc   ;==>ReadConfig_auto

Func ReadConfig_600_17()
	; <><><><> Village / Upgrade - Walls <><><><>
	IniReadS($g_bAutoUpgradeWallsEnable, $g_sProfileConfigPath, "upgrade", "auto-wall", False, "Bool")
	IniReadS($g_iUpgradeWallMinGold, $g_sProfileConfigPath, "upgrade", "minwallgold", 0, "int")
	IniReadS($g_iUpgradeWallMinElixir, $g_sProfileConfigPath, "upgrade", "minwallelixir", 0, "int")
	IniReadS($g_iUpgradeWallLootType, $g_sProfileConfigPath, "upgrade", "use-storage", 0, "int")
	IniReadS($g_bUpgradeWallSaveBuilder, $g_sProfileConfigPath, "upgrade", "savebldr", False, "Bool")
	IniReadS($g_iCmbUpgradeWallsLevel, $g_sProfileConfigPath, "upgrade", "walllvl", 6, "int")
	For $i = 4 To 12
		IniReadS($g_aiWallsCurrentCount[$i], $g_sProfileConfigPath, "Walls", "Wall" & StringFormat("%02d", $i), 0, "int")
	Next
	IniReadS($g_iWallCost, $g_sProfileConfigPath, "upgrade", "WallCost", 0, "int")
EndFunc   ;==>ReadConfig_600_17

Func ReadConfig_600_18()
	; <><><><> Village / Notify <><><><>
	;PushBullet/Telegram
	IniReadS($g_bNotifyPBEnable, $g_sProfileConfigPath, "notify", "PBEnabled", False, "Bool")
	IniReadS($g_bNotifyTGEnable, $g_sProfileConfigPath, "notify", "TGEnabled", False, "Bool")
	IniReadS($g_sNotifyPBToken, $g_sProfileConfigPath, "notify", "PBToken", "")
	IniReadS($g_sNotifyTGToken, $g_sProfileConfigPath, "notify", "TGToken", "")
	;Remote Control
	IniReadS($g_bNotifyRemoteEnable, $g_sProfileConfigPath, "notify", "PBRemote", False, "Bool")
	IniReadS($g_sNotifyOrigin, $g_sProfileConfigPath, "notify", "Origin", $g_sProfileCurrentName)
	IniReadS($g_bNotifyDeleteAllPushesOnStart, $g_sProfileConfigPath, "notify", "DeleteAllPBPushes", False, "Bool")
	IniReadS($g_bNotifyDeletePushesOlderThan, $g_sProfileConfigPath, "notify", "DeleteOldPBPushes", False, "Bool")
	IniReadS($g_iNotifyDeletePushesOlderThanHours, $g_sProfileConfigPath, "notify", "HoursPushBullet", 4, "int")
	;Alerts
	IniReadS($g_bNotifyAlertMatchFound, $g_sProfileConfigPath, "notify", "AlertPBVMFound", False, "Bool")
	IniReadS($g_bNotifyAlerLastRaidIMG, $g_sProfileConfigPath, "notify", "AlertPBLastRaid", False, "Bool")
	IniReadS($g_bNotifyAlerLastRaidTXT, $g_sProfileConfigPath, "notify", "AlertPBLastRaidTxt", False, "Bool")
	IniReadS($g_bNotifyAlertCampFull, $g_sProfileConfigPath, "notify", "AlertPBCampFull", False, "Bool")
	IniReadS($g_bNotifyAlertUpgradeWalls, $g_sProfileConfigPath, "notify", "AlertPBWallUpgrade", False, "Bool")
	IniReadS($g_bNotifyAlertOutOfSync, $g_sProfileConfigPath, "notify", "AlertPBOOS", False, "Bool")
	IniReadS($g_bNotifyAlertTakeBreak, $g_sProfileConfigPath, "notify", "AlertPBVBreak", False, "Bool")
	IniReadS($g_bNotifyAlertBulderIdle, $g_sProfileConfigPath, "notify", "AlertBuilderIdle", False, "Bool")
	IniReadS($g_bNotifyAlertVillageReport, $g_sProfileConfigPath, "notify", "AlertPBVillage", False, "Bool")
	IniReadS($g_bNotifyAlertLastAttack, $g_sProfileConfigPath, "notify", "AlertPBLastAttack", False, "Bool")
	IniReadS($g_bNotifyAlertAnotherDevice, $g_sProfileConfigPath, "notify", "AlertPBOtherDevice", False, "Bool")
	IniReadS($g_bNotifyAlertMaintenance, $g_sProfileConfigPath, "notify", "AlertPBMaintenance", False, "Bool")
	IniReadS($g_bNotifyAlertBAN, $g_sProfileConfigPath, "notify", "AlertPBBAN", False, "Bool")
	IniReadS($g_bNotifyAlertBOTUpdate, $g_sProfileConfigPath, "notify", "AlertPBUpdate", False, "Bool")
	IniReadS($g_bNotifyAlertSmartWaitTime, $g_sProfileConfigPath, "notify", "AlertSmartWaitTime", False, "Bool")
EndFunc   ;==>ReadConfig_600_18

Func ReadConfig_600_19()
	; <><><><> Village / Notify <><><><>
	;Schedule
	$g_bNotifyScheduleHoursEnable = (IniRead($g_sProfileConfigPath, "notify", "NotifyHoursEnable", "0") = "1")
	$g_abNotifyScheduleHours = StringSplit(IniRead($g_sProfileConfigPath, "notify", "NotifyHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 23
		$g_abNotifyScheduleHours[$i] = ($g_abNotifyScheduleHours[$i] = "1")
	Next
	$g_bNotifyScheduleWeekDaysEnable = (IniRead($g_sProfileConfigPath, "notify", "NotifyWeekDaysEnable", "0") = "1")
	$g_abNotifyScheduleWeekDays = StringSplit(IniRead($g_sProfileConfigPath, "notify", "NotifyWeekDays", "1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 6
		$g_abNotifyScheduleWeekDays[$i] = ($g_abNotifyScheduleWeekDays[$i] = "1")
	Next
EndFunc   ;==>ReadConfig_600_19

Func ReadConfig_600_22()
	; <><><><> Attack Plan / Train Army / Boost <><><><>
	$g_abBoostBarracksHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "BoostBarracksHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 23
		$g_abBoostBarracksHours[$i] = ($g_abBoostBarracksHours[$i] = "1")
	Next
	; Note: These global variables are not stored to the ini file, to prevent automatic boosting (and spending of gems) when the bot is started:
	; $g_iCmbBoostBarracks, $g_iCmbBoostSpellFactory, $g_iCmbBoostBarbarianKing, $g_iCmbBoostArcherQueen, $g_iCmbBoostWarden
EndFunc   ;==>ReadConfig_600_22

Func ReadConfig_600_26()
	; <><><><> Attack Plan / Search & Attack / Bully <><><><>
	IniReadS($g_abAttackTypeEnable[$TB], $g_sProfileConfigPath, "search", "BullyMode", False, "Bool")
	IniReadS($g_iAtkTBEnableCount, $g_sProfileConfigPath, "search", "ATBullyMode", 0, "int")
	IniReadS($g_iAtkTBMaxTHLevel, $g_sProfileConfigPath, "search", "YourTH", 0, "int")
	IniReadS($g_iAtkTBMode, $g_sProfileConfigPath, "search", "THBullyAttackMode", 0, "int")
EndFunc   ;==>ReadConfig_600_26

Func ReadConfig_600_28()
	; <><><><> Attack Plan / Search & Attack / Options / Search <><><><>
	IniReadS($g_bSearchReductionEnable, $g_sProfileConfigPath, "search", "reduction", False, "Bool")
	IniReadS($g_iSearchReductionCount, $g_sProfileConfigPath, "search", "reduceCount", 20, "int")
	IniReadS($g_iSearchReductionGold, $g_sProfileConfigPath, "search", "reduceGold", 2000, "int")
	IniReadS($g_iSearchReductionElixir, $g_sProfileConfigPath, "search", "reduceElixir", 2000, "int")
	IniReadS($g_iSearchReductionGoldPlusElixir, $g_sProfileConfigPath, "search", "reduceGoldPlusElixir", 4000, "int")
	IniReadS($g_iSearchReductionDark, $g_sProfileConfigPath, "search", "reduceDark", 100, "int")
	IniReadS($g_iSearchReductionTrophy, $g_sProfileConfigPath, "search", "reduceTrophy", 2, "int")
	IniReadS($g_iSearchDelayMin, $g_sProfileConfigPath, "other", "VSDelay", 0, "Int")
	IniReadS($g_iSearchDelayMax, $g_sProfileConfigPath, "other", "MaxVSDelay", 4, "Int")
	IniReadS($g_bSearchAttackNowEnable, $g_sProfileConfigPath, "general", "AttackNow", False, "Bool")
	IniReadS($g_iSearchAttackNowDelay, $g_sProfileConfigPath, "general", "attacknowdelay", 3, "int")
	IniReadS($g_bSearchRestartEnable, $g_sProfileConfigPath, "search", "ChkRestartSearchLimit", True, "Bool")
	IniReadS($g_iSearchRestartLimit, $g_sProfileConfigPath, "search", "RestartSearchLimit", 50, "int")
	IniReadS($g_bSearchAlertMe, $g_sProfileConfigPath, "general", "AlertSearch", False, "Bool")
EndFunc   ;==>ReadConfig_600_28

Func ReadConfig_600_28_DB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Search <><><><>
	IniReadS($g_abAttackTypeEnable[$DB], $g_sProfileConfigPath, "search", "DBcheck", True, "Bool")
	; Search - Start Search If
	IniReadS($g_abSearchSearchesEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBSearchSearches", True, "Bool")
	IniReadS($g_aiSearchSearchesMin[$DB], $g_sProfileConfigPath, "search", "DBEnableAfterCount", 1, "int")
	IniReadS($g_aiSearchSearchesMax[$DB], $g_sProfileConfigPath, "search", "DBEnableBeforeCount", 9999, "int")
	IniReadS($g_abSearchTropiesEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBSearchTropies", False, "Bool")
	IniReadS($g_aiSearchTrophiesMin[$DB], $g_sProfileConfigPath, "search", "DBEnableAfterTropies", 100, "int")
	IniReadS($g_aiSearchTrophiesMax[$DB], $g_sProfileConfigPath, "search", "DBEnableBeforeTropies", 6000, "int")
	IniReadS($g_abSearchCampsEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBSearchCamps", False, "Bool")
	IniReadS($g_aiSearchCampsPct[$DB], $g_sProfileConfigPath, "search", "DBEnableAfterArmyCamps", 100, "int")
	Local $temp1, $temp2, $temp3
	IniReadS($temp1, $g_sProfileConfigPath, "attack", "DBKingWait", $eHeroNone)
	IniReadS($temp2, $g_sProfileConfigPath, "attack", "DBQueenWait", $eHeroNone)
	IniReadS($temp3, $g_sProfileConfigPath, "attack", "DBWardenWait", $eHeroNone)
	$g_aiSearchHeroWaitEnable[$DB] = BitOR(Int($temp1 > $eHeroNone ? $eHeroKing : 0), Int($temp2 > $eHeroNone ? $eHeroQueen : 0), Int($temp3 > $eHeroNone ? $eHeroWarden : 0))
	IniReadS($g_aiSearchNotWaitHeroesEnable[$DB], $g_sProfileConfigPath, "attack", "DBNotWaitHeroes", 0, "int")
	$g_iHeroWaitAttackNoBit[$DB][0] = ($temp1 > $eHeroNone) ? 1 : 0
	$g_iHeroWaitAttackNoBit[$DB][1] = ($temp2 > $eHeroNone) ? 1 : 0
	$g_iHeroWaitAttackNoBit[$DB][2] = ($temp3 > $eHeroNone) ? 1 : 0
	IniReadS($g_abSearchSpellsWaitEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBSpellsWait", False, "Bool")
	IniReadS($g_abSearchCastleSpellsWaitEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBCastleSpellWait", False, "Bool")
	IniReadS($g_abSearchCastleTroopsWaitEnable[$DB], $g_sProfileConfigPath, "search", "ChkDBCastleTroopsWait", False, "Bool")
	IniReadS($g_aiSearchCastleSpellsWaitRegular[$DB], $g_sProfileConfigPath, "search", "cmbDBWaitForCastleSpell", 0, "int")
	IniReadS($g_aiSearchCastleSpellsWaitDark[$DB], $g_sProfileConfigPath, "search", "cmbDBWaitForCastleSpell2", 0, "int")
	; Search - Filters
	IniReadS($g_aiFilterMeetGE[$DB], $g_sProfileConfigPath, "search", "DBMeetGE", 1, "int")
	IniReadS($g_aiFilterMinGold[$DB], $g_sProfileConfigPath, "search", "DBsearchGold", 80000, "int")
	IniReadS($g_aiFilterMinElixir[$DB], $g_sProfileConfigPath, "search", "DBsearchElixir", 80000, "int")
	IniReadS($g_aiFilterMinGoldPlusElixir[$DB], $g_sProfileConfigPath, "search", "DBsearchGoldPlusElixir", 160000, "int")
	IniReadS($g_abFilterMeetDEEnable[$DB], $g_sProfileConfigPath, "search", "DBMeetDE", False, "Bool")
	IniReadS($g_aiFilterMeetDEMin[$DB], $g_sProfileConfigPath, "search", "DBsearchDark", 0, "int")
	IniReadS($g_abFilterMeetTrophyEnable[$DB], $g_sProfileConfigPath, "search", "DBMeetTrophy", False, "Bool")
	IniReadS($g_aiFilterMeetTrophyMin[$DB], $g_sProfileConfigPath, "search", "DBsearchTrophy", 0, "int")
	IniReadS($g_aiFilterMeetTrophyMax[$DB], $g_sProfileConfigPath, "search", "DBsearchTrophyMax", 99, "int")
	IniReadS($g_abFilterMeetTH[$DB], $g_sProfileConfigPath, "search", "DBMeetTH", False, "Bool")
	IniReadS($g_aiFilterMeetTHMin[$DB], $g_sProfileConfigPath, "search", "DBTHLevel", 0, "int")
	IniReadS($g_abFilterMeetTHOutsideEnable[$DB], $g_sProfileConfigPath, "search", "DBMeetTHO", False, "Bool")
	IniReadS($g_abFilterMaxMortarEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckMortar", False, "Bool")
	IniReadS($g_abFilterMaxWizTowerEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckWizTower", False, "Bool")
	IniReadS($g_abFilterMaxAirDefenseEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckAirDefense", False, "Bool")
	IniReadS($g_abFilterMaxXBowEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckXBow", False, "Bool")
	IniReadS($g_abFilterMaxInfernoEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckInferno", False, "Bool")
	IniReadS($g_abFilterMaxEagleEnable[$DB], $g_sProfileConfigPath, "search", "DBCheckEagle", False, "Bool")
	IniReadS($g_aiFilterMaxMortarLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakMortar", 5, "int")
	IniReadS($g_aiFilterMaxWizTowerLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakWizTower", 4, "int")
	IniReadS($g_aiFilterMaxAirDefenseLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakAirDefense", 7, "int")
	IniReadS($g_aiFilterMaxXBowLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakXBow", 4, "int")
	IniReadS($g_aiFilterMaxInfernoLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakInferno", 1, "int")
	IniReadS($g_aiFilterMaxEagleLevel[$DB], $g_sProfileConfigPath, "search", "DBWeakEagle", 2, "int")
	IniReadS($g_abFilterMeetOneConditionEnable[$DB], $g_sProfileConfigPath, "search", "DBMeetOne", False, "Bool")
EndFunc   ;==>ReadConfig_600_28_DB

Func ReadConfig_600_28_LB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Search <><><><>
	IniReadS($g_abAttackTypeEnable[$LB], $g_sProfileConfigPath, "search", "ABcheck", False, "Bool")
	; Search - Start Search If
	IniReadS($g_abSearchSearchesEnable[$LB], $g_sProfileConfigPath, "search", "ChkABSearchSearches", False, "Bool")
	IniReadS($g_aiSearchSearchesMin[$LB], $g_sProfileConfigPath, "search", "ABEnableAfterCount", 1, "int")
	IniReadS($g_aiSearchSearchesMax[$LB], $g_sProfileConfigPath, "search", "ABEnableBeforeCount", 9999, "int")
	IniReadS($g_abSearchTropiesEnable[$LB], $g_sProfileConfigPath, "search", "ChkABSearchTropies", False, "Bool")
	IniReadS($g_aiSearchTrophiesMin[$LB], $g_sProfileConfigPath, "search", "ABEnableAfterTropies", 100, "int")
	IniReadS($g_aiSearchTrophiesMax[$LB], $g_sProfileConfigPath, "search", "ABEnableBeforeTropies", 6000, "int")
	IniReadS($g_abSearchCampsEnable[$LB], $g_sProfileConfigPath, "search", "ChkABSearchCamps", False, "Bool")
	IniReadS($g_aiSearchCampsPct[$LB], $g_sProfileConfigPath, "search", "ABEnableAfterArmyCamps", 100, "int")
	Local $temp1, $temp2, $temp3
	IniReadS($temp1, $g_sProfileConfigPath, "attack", "ABKingWait", $eHeroNone)
	IniReadS($temp2, $g_sProfileConfigPath, "attack", "ABQueenWait", $eHeroNone)
	IniReadS($temp3, $g_sProfileConfigPath, "attack", "ABWardenWait", $eHeroNone)
	$g_aiSearchHeroWaitEnable[$LB] = BitOR(Int($temp1 > $eHeroNone ? $eHeroKing : 0), Int($temp2 > $eHeroNone ? $eHeroQueen : 0), Int($temp3 > $eHeroNone ? $eHeroWarden : 0))
	IniReadS($g_aiSearchNotWaitHeroesEnable[$LB], $g_sProfileConfigPath, "attack", "ABNotWaitHeroes", 0, "int")
	$g_iHeroWaitAttackNoBit[$LB][0] = ($temp1 > $eHeroNone) ? 1 : 0
	$g_iHeroWaitAttackNoBit[$LB][1] = ($temp2 > $eHeroNone) ? 1 : 0
	$g_iHeroWaitAttackNoBit[$LB][2] = ($temp3 > $eHeroNone) ? 1 : 0
	IniReadS($g_abSearchSpellsWaitEnable[$LB], $g_sProfileConfigPath, "search", "ChkABSpellsWait", False, "Bool")
	IniReadS($g_abSearchCastleSpellsWaitEnable[$LB], $g_sProfileConfigPath, "search", "ChkABCastleSpellWait", False, "Bool")
	IniReadS($g_abSearchCastleTroopsWaitEnable[$LB], $g_sProfileConfigPath, "search", "ChkABCastleTroopsWait", False, "Bool")
	IniReadS($g_aiSearchCastleSpellsWaitRegular[$LB], $g_sProfileConfigPath, "search", "cmbABWaitForCastleSpell", 0, "int")
	IniReadS($g_aiSearchCastleSpellsWaitDark[$LB], $g_sProfileConfigPath, "search", "cmbABWaitForCastleSpell2", 0, "int")
	; Search - Filters
	IniReadS($g_aiFilterMeetGE[$LB], $g_sProfileConfigPath, "search", "ABMeetGE", 2, "int")
	IniReadS($g_aiFilterMinGold[$LB], $g_sProfileConfigPath, "search", "ABsearchGold", 80000, "int")
	IniReadS($g_aiFilterMinElixir[$LB], $g_sProfileConfigPath, "search", "ABsearchElixir", 80000, "int")
	IniReadS($g_aiFilterMinGoldPlusElixir[$LB], $g_sProfileConfigPath, "search", "ABsearchGoldPlusElixir", 160000, "int")
	IniReadS($g_abFilterMeetDEEnable[$LB], $g_sProfileConfigPath, "search", "ABMeetDE", False, "Bool")
	IniReadS($g_aiFilterMeetDEMin[$LB], $g_sProfileConfigPath, "search", "ABsearchDark", 0, "int")
	IniReadS($g_abFilterMeetTrophyEnable[$LB], $g_sProfileConfigPath, "search", "ABMeetTrophy", False, "Bool")
	IniReadS($g_aiFilterMeetTrophyMin[$LB], $g_sProfileConfigPath, "search", "ABsearchTrophy", 0, "int")
	IniReadS($g_aiFilterMeetTrophyMax[$LB], $g_sProfileConfigPath, "search", "ABsearchTrophyMax", 99, "int")
	IniReadS($g_abFilterMeetTH[$LB], $g_sProfileConfigPath, "search", "ABMeetTH", False, "Bool")
	IniReadS($g_aiFilterMeetTHMin[$LB], $g_sProfileConfigPath, "search", "ABTHLevel", 0, "int")
	IniReadS($g_abFilterMeetTHOutsideEnable[$LB], $g_sProfileConfigPath, "search", "ABMeetTHO", False, "Bool")
	IniReadS($g_abFilterMaxMortarEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckMortar", False, "Bool")
	IniReadS($g_abFilterMaxWizTowerEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckWizTower", False, "Bool")
	IniReadS($g_abFilterMaxAirDefenseEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckAirDefense", False, "Bool")
	IniReadS($g_abFilterMaxXBowEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckXBow", False, "Bool")
	IniReadS($g_abFilterMaxInfernoEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckInferno", False, "Bool")
	IniReadS($g_abFilterMaxEagleEnable[$LB], $g_sProfileConfigPath, "search", "ABCheckEagle", False, "Bool")
	IniReadS($g_aiFilterMaxMortarLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakMortar", 5, "int")
	IniReadS($g_aiFilterMaxWizTowerLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakWizTower", 4, "int")
	IniReadS($g_aiFilterMaxAirDefenseLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakAirDefense", 7, "int")
	IniReadS($g_aiFilterMaxXBowLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakXBow", 4, "int")
	IniReadS($g_aiFilterMaxInfernoLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakInferno", 1, "int")
	IniReadS($g_aiFilterMaxEagleLevel[$LB], $g_sProfileConfigPath, "search", "ABWeakEagle", 2, "int")
	IniReadS($g_abFilterMeetOneConditionEnable[$LB], $g_sProfileConfigPath, "search", "ABMeetOne", False, "Bool")
EndFunc   ;==>ReadConfig_600_28_LB

Func ReadConfig_600_28_TS()
	; <><><><> Attack Plan / Search & Attack / TH Snipe / Search <><><><>
	IniReadS($g_abAttackTypeEnable[$TS], $g_sProfileConfigPath, "search", "TScheck", False, "Bool")
	; Search - Start Search If
	IniReadS($g_abSearchSearchesEnable[$TS], $g_sProfileConfigPath, "search", "ChkTSSearchSearches", False, "Bool")
	IniReadS($g_aiSearchSearchesMin[$TS], $g_sProfileConfigPath, "search", "TSEnableAfterCount", 1, "int")
	IniReadS($g_aiSearchSearchesMax[$TS], $g_sProfileConfigPath, "search", "TSEnableBeforeCount", 9999, "int")
	IniReadS($g_abSearchTropiesEnable[$TS], $g_sProfileConfigPath, "search", "ChkTSSearchTropies", False, "Bool")
	IniReadS($g_aiSearchTrophiesMin[$TS], $g_sProfileConfigPath, "search", "TSEnableAfterTropies", 100, "int")
	IniReadS($g_aiSearchTrophiesMax[$TS], $g_sProfileConfigPath, "search", "TSEnableBeforeTropies", 6000, "int")
	IniReadS($g_abSearchCampsEnable[$TS], $g_sProfileConfigPath, "search", "ChkTSSearchCamps", False, "Bool")
	IniReadS($g_aiSearchCampsPct[$TS], $g_sProfileConfigPath, "search", "TSEnableAfterArmyCamps", 100, "int")
	; Search - Filters
	IniReadS($g_aiFilterMeetGE[$TS], $g_sProfileConfigPath, "search", "TSMeetGE", 1, "int")
	IniReadS($g_aiFilterMinGold[$TS], $g_sProfileConfigPath, "search", "TSsearchGold", 80000, "int")
	IniReadS($g_aiFilterMinElixir[$TS], $g_sProfileConfigPath, "search", "TSsearchElixir", 80000, "int")
	IniReadS($g_aiFilterMinGoldPlusElixir[$TS], $g_sProfileConfigPath, "search", "TSsearchGoldPlusElixir", 160000, "int")
	IniReadS($g_abFilterMeetDEEnable[$TS], $g_sProfileConfigPath, "search", "TSMeetDE", False, "Bool")
	IniReadS($g_aiFilterMeetDEMin[$TS], $g_sProfileConfigPath, "search", "TSsearchDark", 600, "int")
	IniReadS($g_iAtkTSAddTilesWhileTrain, $g_sProfileConfigPath, "search", "SWTtiles", 1, "int")
	IniReadS($g_iAtkTSAddTilesFullTroops, $g_sProfileConfigPath, "search", "THaddTiles", 2, "int")
EndFunc   ;==>ReadConfig_600_28_TS

Func ReadConfig_600_29()
	; <><><><> Attack Plan / Search & Attack / Options / Attack <><><><>
	IniReadS($g_iActivateQueen, $g_sProfileConfigPath, "attack", "ActivateQueen", 0, "int")
	IniReadS($g_iActivateKing, $g_sProfileConfigPath, "attack", "ActivateKing", 0, "int")
	IniReadS($g_iActivateWarden, $g_sProfileConfigPath, "attack", "ActivateWarden", 0, "int")
	IniReadS($g_iDelayActivateQueen, $g_sProfileConfigPath, "attack", "delayActivateQueen", 9000, "int")
	IniReadS($g_iDelayActivateKing, $g_sProfileConfigPath, "attack", "delayActivateKing", 9000, "int")
	IniReadS($g_iDelayActivateWarden, $g_sProfileConfigPath, "attack", "delayActivateWarden", 10000, "int")

	$g_bAttackPlannerEnable = (IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerEnable", "0") = "1")
	$g_bAttackPlannerCloseCoC = (IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerCloseCoC", "0") = "1")
	$g_bAttackPlannerCloseAll = (IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerCloseAll", "0") = "1")
	$g_bAttackPlannerSuspendComputer = (IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerSuspendComputer", "0") = "1")
	$g_bAttackPlannerRandomEnable = (IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerRandom", "0") = "1")
	$g_iAttackPlannerRandomTime = Int(IniRead($g_sProfileConfigPath, "planned", "cmbAttackPlannerRandom", 4))
	$g_bAttackPlannerDayLimit = (IniRead($g_sProfileConfigPath, "planned", "chkAttackPlannerDayLimit", "0") = "1")
	$g_iAttackPlannerDayMin = Int(IniRead($g_sProfileConfigPath, "planned", "cmbAttackPlannerDayMin", 12))
	$g_iAttackPlannerDayMax = Int(IniRead($g_sProfileConfigPath, "planned", "cmbAttackPlannerDayMax", 15))
	$g_abPlannedAttackWeekDays = StringSplit(IniRead($g_sProfileConfigPath, "planned", "attackDays", "1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 6
		$g_abPlannedAttackWeekDays[$i] = ($g_abPlannedAttackWeekDays[$i] = "1")
	Next
	$g_abPlannedattackHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "attackHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 23
		$g_abPlannedattackHours[$i] = ($g_abPlannedattackHours[$i] = "1")
	Next
	$g_bPlannedDropCCHoursEnable = (IniRead($g_sProfileConfigPath, "planned", "DropCCEnable", "0") = "1")
	$g_abPlannedDropCCHours = StringSplit(IniRead($g_sProfileConfigPath, "planned", "DropCCHours", "1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1|1"), "|", $STR_NOCOUNT)
	For $i = 0 To 23
		$g_abPlannedDropCCHours[$i] = ($g_abPlannedDropCCHours[$i] = "1")
	Next
	IniReadS($g_bUseCCBalanced, $g_sProfileConfigPath, "ClanClastle", "BalanceCC", False, "Bool")
	IniReadS($g_iCCDonated, $g_sProfileConfigPath, "ClanClastle", "BalanceCCDonated", 1, "int")
	IniReadS($g_iCCReceived, $g_sProfileConfigPath, "ClanClastle", "BalanceCCReceived", 1, "int")
EndFunc   ;==>ReadConfig_600_29

Func ReadConfig_600_29_DB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack <><><><>
	IniReadS($g_aiAttackAlgorithm[$DB], $g_sProfileConfigPath, "attack", "DBAtkAlgorithm", 0, "int")
	IniReadS($g_aiAttackTroopSelection[$DB], $g_sProfileConfigPath, "attack", "DBSelectTroop", 0, "int")
	Local $temp1, $temp2, $temp3
	IniReadS($temp1, $g_sProfileConfigPath, "attack", "DBKingAtk", $eHeroNone)
	IniReadS($temp2, $g_sProfileConfigPath, "attack", "DBQueenAtk", $eHeroNone)
	IniReadS($temp3, $g_sProfileConfigPath, "attack", "DBWardenAtk", $eHeroNone)
	$g_aiAttackUseHeroes[$DB] = BitOR(Int($temp1), Int($temp2), Int($temp3))
	IniReadS($g_abAttackDropCC[$DB], $g_sProfileConfigPath, "attack", "DBDropCC", False, "Bool")
	IniReadS($g_abAttackUseLightSpell[$DB], $g_sProfileConfigPath, "attack", "DBLightSpell", False, "Bool")
	IniReadS($g_abAttackUseHealSpell[$DB], $g_sProfileConfigPath, "attack", "DBHealSpell", False, "Bool")
	IniReadS($g_abAttackUseRageSpell[$DB], $g_sProfileConfigPath, "attack", "DBRageSpell", False, "Bool")
	IniReadS($g_abAttackUseJumpSpell[$DB], $g_sProfileConfigPath, "attack", "DBJumpSpell", False, "Bool")
	IniReadS($g_abAttackUseFreezeSpell[$DB], $g_sProfileConfigPath, "attack", "DBFreezeSpell", False, "Bool")
	IniReadS($g_abAttackUsePoisonSpell[$DB], $g_sProfileConfigPath, "attack", "DBPoisonSpell", False, "Bool")
	IniReadS($g_abAttackUseEarthquakeSpell[$DB], $g_sProfileConfigPath, "attack", "DBEarthquakeSpell", False, "Bool")
	IniReadS($g_abAttackUseHasteSpell[$DB], $g_sProfileConfigPath, "attack", "DBHasteSpell", False, "Bool")
	IniReadS($g_abAttackUseCloneSpell[$DB], $g_sProfileConfigPath, "attack", "DBCloneSpell", False, "Bool")
	IniReadS($g_abAttackUseSkeletonSpell[$DB], $g_sProfileConfigPath, "attack", "DBSkeletonSpell", False, "Bool")
	IniReadS($g_bTHSnipeBeforeEnable[$DB], $g_sProfileConfigPath, "attack", "THSnipeBeforeDBEnable", False, "Bool")
	IniReadS($g_iTHSnipeBeforeTiles[$DB], $g_sProfileConfigPath, "attack", "THSnipeBeforeDBTiles", 0, "int")
	IniReadS($g_iTHSnipeBeforeScript[$DB], $g_sProfileConfigPath, "attack", "THSnipeBeforeDBScript", "bam")
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Standard <><><><>
	IniReadS($g_aiAttackStdDropOrder[$DB], $g_sProfileConfigPath, "attack", "DBStandardAlgorithm", 0, "int")
	IniReadS($g_aiAttackStdDropSides[$DB], $g_sProfileConfigPath, "attack", "DBDeploy", 3, "int")
	IniReadS($g_aiAttackStdUnitDelay[$DB], $g_sProfileConfigPath, "attack", "DBUnitD", 4, "int")
	IniReadS($g_aiAttackStdWaveDelay[$DB], $g_sProfileConfigPath, "attack", "DBWaveD", 4, "int")
	IniReadS($g_abAttackStdRandomizeDelay[$DB], $g_sProfileConfigPath, "attack", "DBRandomSpeedAtk", True, "Bool")
	IniReadS($g_abAttackStdSmartAttack[$DB], $g_sProfileConfigPath, "attack", "DBSmartAttackRedArea", True, "Bool")
	IniReadS($g_aiAttackStdSmartDeploy[$DB], $g_sProfileConfigPath, "attack", "DBSmartAttackDeploy", 0, "int")
	IniReadS($g_abAttackStdSmartNearCollectors[$DB][0], $g_sProfileConfigPath, "attack", "DBSmartAttackGoldMine", False, "Bool")
	IniReadS($g_abAttackStdSmartNearCollectors[$DB][1], $g_sProfileConfigPath, "attack", "DBSmartAttackElixirCollector", False, "Bool")
	IniReadS($g_abAttackStdSmartNearCollectors[$DB][2], $g_sProfileConfigPath, "attack", "DBSmartAttackDarkElixirDrill", False, "Bool")
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Scripted <><><><>
	IniReadS($g_aiAttackScrRedlineRoutine[$DB], $g_sProfileConfigPath, "attack", "RedlineRoutineDB", $g_aiAttackScrRedlineRoutine[$DB], "Int")
	IniReadS($g_aiAttackScrDroplineEdge[$DB], $g_sProfileConfigPath, "attack", "DroplineEdgeDB", $g_aiAttackScrDroplineEdge[$DB], "Int")
	IniReadS($g_sAttackScrScriptName[$DB], $g_sProfileConfigPath, "attack", "ScriptDB", "Barch four fingers")
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Milking <><><><>
	IniReadS($g_iMilkAttackType, $g_sProfileConfigPath, "MilkingAttack", "MilkAttackType", 0, "int")
	IniReadS($g_aiMilkFarmElixirParam, $g_sProfileConfigPath, "MilkingAttack", "LocateElixirLevel", "-1|-1|-1|-1|-1|-1|2|2|2")
	$g_aiMilkFarmElixirParam = StringSplit($g_aiMilkFarmElixirParam, "|", 2)
	IniReadS($g_bMilkFarmLocateElixir, $g_sProfileConfigPath, "MilkingAttack", "LocateElixir", True, "Bool")
	IniReadS($g_bMilkFarmLocateMine, $g_sProfileConfigPath, "MilkingAttack", "LocateMine", True, "Bool")
	IniReadS($g_bMilkFarmLocateDrill, $g_sProfileConfigPath, "MilkingAttack", "LocateDrill", True, "Bool")
	IniReadS($g_iMilkFarmMineParam, $g_sProfileConfigPath, "MilkingAttack", "MineParam", 5, "int")
	IniReadS($g_iMilkFarmDrillParam, $g_sProfileConfigPath, "MilkingAttack", "DrillParam", 1, "int")
	IniReadS($g_iMilkFarmResMaxTilesFromBorder, $g_sProfileConfigPath, "MilkingAttack", "MaxTiles", 1, "int")
	IniReadS($g_bMilkFarmAttackGoldMines, $g_sProfileConfigPath, "MilkingAttack", "AttackMine", True, "Bool")
	IniReadS($g_bMilkFarmAttackElixirExtractors, $g_sProfileConfigPath, "MilkingAttack", "AttackElixir", True, "Bool")
	IniReadS($g_bMilkFarmAttackDarkDrills, $g_sProfileConfigPath, "MilkingAttack", "AttackDrill", True, "Bool")
	IniReadS($g_iMilkFarmLimitGold, $g_sProfileConfigPath, "MilkingAttack", "LimitGold", 9950000, "int")
	IniReadS($g_iMilkFarmLimitElixir, $g_sProfileConfigPath, "MilkingAttack", "LimitElixir", 9950000, "int")
	IniReadS($g_iMilkFarmLimitDark, $g_sProfileConfigPath, "MilkingAttack", "LimitDark", 200000, "int")
	IniReadS($g_iMilkFarmTroopForWaveMin, $g_sProfileConfigPath, "MilkingAttack", "TroopForWaveMin", 4, "int")
	IniReadS($g_iMilkFarmTroopForWaveMax, $g_sProfileConfigPath, "MilkingAttack", "TroopForWaveMax", 6, "int")
	IniReadS($g_iMilkFarmTroopMaxWaves, $g_sProfileConfigPath, "MilkingAttack", "MaxWaves", 4, "int")
	IniReadS($g_iMilkFarmDelayFromWavesMin, $g_sProfileConfigPath, "MilkingAttack", "DelayBetweenWavesMin", 3000, "int")
	IniReadS($g_iMilkFarmDelayFromWavesMax, $g_sProfileConfigPath, "MilkingAttack", "DelayBetweenWavesMax", 5000, "int")
	IniReadS($g_iMilkingAttackDropGoblinAlgorithm, $g_sProfileConfigPath, "MilkingAttack", "DropRandomPlace", 0, "int")
	IniReadS($g_iMilkingAttackStructureOrder, $g_sProfileConfigPath, "MilkingAttack", "StructureOrder", 1, "int")
	IniReadS($g_bMilkingAttackCheckStructureDestroyedBeforeAttack, $g_sProfileConfigPath, "MilkingAttack", "CheckStructureDestroyedBeforeAttack", False, "Bool")
	IniReadS($g_bMilkingAttackCheckStructureDestroyedAfterAttack, $g_sProfileConfigPath, "MilkingAttack", "CheckStructureDestroyedAfterAttack", False, "Bool")
	IniReadS($g_bMilkAttackAfterTHSnipeEnable, $g_sProfileConfigPath, "MilkingAttack", "MilkAttackAfterTHSnipe", False, "Bool")
	IniReadS($g_iMilkFarmTHMaxTilesFromBorder, $g_sProfileConfigPath, "MilkingAttack", "TownhallTiles", 0, "int")
	IniReadS($g_sMilkFarmAlgorithmTh, $g_sProfileConfigPath, "MilkingAttack", "TownHallAlgorithm", "Bam")
	IniReadS($g_bMilkFarmSnipeEvenIfNoExtractorsFound, $g_sProfileConfigPath, "MilkingAttack", "TownHallHitAnyway", False, "Bool")
	IniReadS($g_bMilkAttackAfterScriptedAtkEnable, $g_sProfileConfigPath, "MilkingAttack", "MilkAttackAfterScriptedAtk", False, "Bool")
	IniReadS($g_sMilkAttackCSVscript, $g_sProfileConfigPath, "MilkingAttack", "MilkAttackCSVscript", "0")
	IniReadS($g_bMilkFarmForceToleranceEnable, $g_sProfileConfigPath, "MilkingAttack", "MilkFarmForceTolerance", False, "Bool")
	IniReadS($g_iMilkFarmForceToleranceNormal, $g_sProfileConfigPath, "MilkingAttack", "MilkFarmForcetolerancenormal", 60, "int")
	IniReadS($g_iMilkFarmForceToleranceBoosted, $g_sProfileConfigPath, "MilkingAttack", "MilkFarmForcetoleranceboosted", 60, "int")
	IniReadS($g_iMilkFarmForceToleranceDestroyed, $g_sProfileConfigPath, "MilkingAttack", "MilkFarmForcetolerancedestroyed", 60, "int")
EndFunc   ;==>ReadConfig_600_29_DB

Func ReadConfig_600_29_LB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack <><><><>
	IniReadS($g_aiAttackAlgorithm[$LB], $g_sProfileConfigPath, "attack", "ABAtkAlgorithm", 0, "int")
	IniReadS($g_aiAttackTroopSelection[$LB], $g_sProfileConfigPath, "attack", "ABSelectTroop", 0, "int")
	Local $temp1, $temp2, $temp3
	IniReadS($temp1, $g_sProfileConfigPath, "attack", "ABKingAtk", $eHeroNone)
	IniReadS($temp2, $g_sProfileConfigPath, "attack", "ABQueenAtk", $eHeroNone)
	IniReadS($temp3, $g_sProfileConfigPath, "attack", "ABWardenAtk", $eHeroNone)
	$g_aiAttackUseHeroes[$LB] = BitOR(Int($temp1), Int($temp2), Int($temp3))
	IniReadS($g_abAttackDropCC[$LB], $g_sProfileConfigPath, "attack", "ABDropCC", False, "Bool")
	IniReadS($g_abAttackUseLightSpell[$LB], $g_sProfileConfigPath, "attack", "ABLightSpell", False, "Bool")
	IniReadS($g_abAttackUseHealSpell[$LB], $g_sProfileConfigPath, "attack", "ABHealSpell", False, "Bool")
	IniReadS($g_abAttackUseRageSpell[$LB], $g_sProfileConfigPath, "attack", "ABRageSpell", False, "Bool")
	IniReadS($g_abAttackUseJumpSpell[$LB], $g_sProfileConfigPath, "attack", "ABJumpSpell", False, "Bool")
	IniReadS($g_abAttackUseFreezeSpell[$LB], $g_sProfileConfigPath, "attack", "ABFreezeSpell", False, "Bool")
	IniReadS($g_abAttackUsePoisonSpell[$LB], $g_sProfileConfigPath, "attack", "ABPoisonSpell", False, "Bool")
	IniReadS($g_abAttackUseEarthquakeSpell[$LB], $g_sProfileConfigPath, "attack", "ABEarthquakeSpell", False, "Bool")
	IniReadS($g_abAttackUseHasteSpell[$LB], $g_sProfileConfigPath, "attack", "ABHasteSpell", False, "Bool")
	IniReadS($g_abAttackUseCloneSpell[$LB], $g_sProfileConfigPath, "attack", "ABCloneSpell", False, "Bool")
	IniReadS($g_abAttackUseSkeletonSpell[$LB], $g_sProfileConfigPath, "attack", "ABSkeletonSpell", False, "Bool")
	IniReadS($g_bTHSnipeBeforeEnable[$LB], $g_sProfileConfigPath, "attack", "THSnipeBeforeLBEnable", False, "Bool")
	IniReadS($g_iTHSnipeBeforeTiles[$LB], $g_sProfileConfigPath, "attack", "THSnipeBeforeLBTiles", 0, "int")
	IniReadS($g_iTHSnipeBeforeScript[$LB], $g_sProfileConfigPath, "attack", "THSnipeBeforeLBScript", "bam")
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack / Standard <><><><>
	IniReadS($g_aiAttackStdDropOrder[$LB], $g_sProfileConfigPath, "attack", "LBStandardAlgorithm", 0, "int")
	IniReadS($g_aiAttackStdDropSides[$LB], $g_sProfileConfigPath, "attack", "ABDeploy", 0, "int")
	IniReadS($g_aiAttackStdUnitDelay[$LB], $g_sProfileConfigPath, "attack", "ABUnitD", 4, "int")
	IniReadS($g_aiAttackStdWaveDelay[$LB], $g_sProfileConfigPath, "attack", "ABWaveD", 4, "int")
	IniReadS($g_abAttackStdRandomizeDelay[$LB], $g_sProfileConfigPath, "attack", "ABRandomSpeedAtk", True, "Bool")
	IniReadS($g_abAttackStdSmartAttack[$LB], $g_sProfileConfigPath, "attack", "ABSmartAttackRedArea", True, "Bool")
	IniReadS($g_aiAttackStdSmartDeploy[$LB], $g_sProfileConfigPath, "attack", "ABSmartAttackDeploy", 1, "int")
	IniReadS($g_abAttackStdSmartNearCollectors[$LB][0], $g_sProfileConfigPath, "attack", "ABSmartAttackGoldMine", False, "Bool")
	IniReadS($g_abAttackStdSmartNearCollectors[$LB][1], $g_sProfileConfigPath, "attack", "ABSmartAttackElixirCollector", False, "Bool")
	IniReadS($g_abAttackStdSmartNearCollectors[$LB][2], $g_sProfileConfigPath, "attack", "ABSmartAttackDarkElixirDrill", False, "Bool")
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack / Scripted <><><><>
	IniReadS($g_aiAttackScrRedlineRoutine[$LB], $g_sProfileConfigPath, "attack", "RedlineRoutineAB", $g_aiAttackScrRedlineRoutine[$LB], "Int")
	IniReadS($g_aiAttackScrDroplineEdge[$LB], $g_sProfileConfigPath, "attack", "DroplineEdgeAB", $g_aiAttackScrDroplineEdge[$LB], "Int")
	IniReadS($g_sAttackScrScriptName[$LB], $g_sProfileConfigPath, "attack", "ScriptAB", "Barch four fingers")
EndFunc   ;==>ReadConfig_600_29_LB

Func ReadConfig_600_29_TS()
	; <><><><> Attack Plan / Search & Attack / TH Snipe / Attack <><><><>
	IniReadS($g_aiAttackTroopSelection[$TS], $g_sProfileConfigPath, "attack", "TSSelectTroop", 0, "int")
	Local $temp1, $temp2, $temp3
	IniReadS($temp1, $g_sProfileConfigPath, "attack", "TSKingAtk", $eHeroNone)
	IniReadS($temp2, $g_sProfileConfigPath, "attack", "TSQueenAtk", $eHeroNone)
	IniReadS($temp3, $g_sProfileConfigPath, "attack", "TSWardenAtk", $eHeroNone)
	$g_aiAttackUseHeroes[$TS] = BitOR(Int($temp1), Int($temp2), Int($temp3))
	IniReadS($g_abAttackDropCC[$TS], $g_sProfileConfigPath, "attack", "TSDropCC", False, "Bool")
	IniReadS($g_abAttackUseHealSpell[$TS], $g_sProfileConfigPath, "attack", "TSHealSpell", False, "Bool")
	IniReadS($g_abAttackUseLightSpell[$TS], $g_sProfileConfigPath, "attack", "TSLightSpell", False, "Bool")
	IniReadS($g_abAttackUseRageSpell[$TS], $g_sProfileConfigPath, "attack", "TSRageSpell", False, "Bool")
	IniReadS($g_abAttackUseJumpSpell[$TS], $g_sProfileConfigPath, "attack", "TSJumpSpell", False, "Bool")
	IniReadS($g_abAttackUseFreezeSpell[$TS], $g_sProfileConfigPath, "attack", "TSFreezeSpell", False, "Bool")
	IniReadS($g_abAttackUsePoisonSpell[$TS], $g_sProfileConfigPath, "attack", "TSPoisonSpell", False, "Bool")
	IniReadS($g_abAttackUseEarthquakeSpell[$TS], $g_sProfileConfigPath, "attack", "TSEarthquakeSpell", False, "Bool")
	IniReadS($g_abAttackUseHasteSpell[$TS], $g_sProfileConfigPath, "attack", "TSHasteSpell", False, "Bool")
	IniReadS($g_sAtkTSType, $g_sProfileConfigPath, "attack", "AttackTHType", "bam")
EndFunc   ;==>ReadConfig_600_29_TS

Func ReadConfig_600_30()
	; <><><><> Attack Plan / Search & Attack / Options / End Battle <><><><>
	$g_bShareAttackEnable = (IniRead($g_sProfileConfigPath, "shareattack", "ShareAttack", "0") = "1")
	$g_iShareMinGold = Int(IniRead($g_sProfileConfigPath, "shareattack", "minGold", 200000))
	$g_iShareMinElixir = Int(IniRead($g_sProfileConfigPath, "shareattack", "minElixir", 200000))
	$g_iShareMinDark = Int(IniRead($g_sProfileConfigPath, "shareattack", "minDark", 100))
	$g_sShareMessage = IniRead($g_sProfileConfigPath, "shareattack", "Message", "Nice|Good|Thanks|Wowwww")
	IniReadS($g_bTakeLootSnapShot, $g_sProfileConfigPath, "attack", "TakeLootSnapShot", False, "Bool")
	IniReadS($g_bScreenshotLootInfo, $g_sProfileConfigPath, "attack", "ScreenshotLootInfo", False, "Bool")
EndFunc   ;==>ReadConfig_600_30

Func ReadConfig_600_30_DB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / End Battle <><><><>
	IniReadS($g_abStopAtkNoLoot1Enable[$DB], $g_sProfileConfigPath, "endbattle", "chkDBTimeStopAtk", True, "Bool")
	IniReadS($g_aiStopAtkNoLoot1Time[$DB], $g_sProfileConfigPath, "endbattle", "txtDBTimeStopAtk", 15, "int")
	IniReadS($g_abStopAtkNoLoot2Enable[$DB], $g_sProfileConfigPath, "endbattle", "chkDBTimeStopAtk2", False, "Bool")
	IniReadS($g_aiStopAtkNoLoot2Time[$DB], $g_sProfileConfigPath, "endbattle", "txtDBTimeStopAtk2", 7, "int")
	IniReadS($g_aiStopAtkNoLoot2MinGold[$DB], $g_sProfileConfigPath, "endbattle", "txtDBMinGoldStopAtk2", 1000, "int")
	IniReadS($g_aiStopAtkNoLoot2MinElixir[$DB], $g_sProfileConfigPath, "endbattle", "txtDBMinElixirStopAtk2", 1000, "int")
	IniReadS($g_aiStopAtkNoLoot2MinDark[$DB], $g_sProfileConfigPath, "endbattle", "txtDBMinDarkElixirStopAtk2", 50, "int")
	IniReadS($g_abStopAtkNoResources[$DB], $g_sProfileConfigPath, "endbattle", "chkDBEndNoResources", False, "Bool")
	IniReadS($g_abStopAtkOneStar[$DB], $g_sProfileConfigPath, "endbattle", "chkDBEndOneStar", False, "Bool")
	IniReadS($g_abStopAtkTwoStars[$DB], $g_sProfileConfigPath, "endbattle", "chkDBEndTwoStars", False, "Bool")
	IniReadS($g_abStopAtkPctHigherEnable[$DB], $g_sProfileConfigPath, "endbattle", "chkDBPercentageHigher", False, "Bool")
	IniReadS($g_aiStopAtkPctHigherAmt[$DB], $g_sProfileConfigPath, "endbattle", "txtDBPercentageHigher", 50, "int")
	IniReadS($g_abStopAtkPctNoChangeEnable[$DB], $g_sProfileConfigPath, "endbattle", "chkDBPercentageChange", False, "Bool")
	IniReadS($g_aiStopAtkPctNoChangeTime[$DB], $g_sProfileConfigPath, "endbattle", "txtDBPercentageChange", 15, "int")
EndFunc   ;==>ReadConfig_600_30_DB

Func ReadConfig_600_30_LB()
	; <><><><> Attack Plan / Search & Attack / Activebase / End Battle <><><><>

	IniReadS($g_abStopAtkNoLoot1Enable[$LB], $g_sProfileConfigPath, "endbattle", "chkABTimeStopAtk", True, "Bool")
	IniReadS($g_aiStopAtkNoLoot1Time[$LB], $g_sProfileConfigPath, "endbattle", "txtABTimeStopAtk", 20, "int")
	IniReadS($g_abStopAtkNoLoot2Enable[$LB], $g_sProfileConfigPath, "endbattle", "chkABTimeStopAtk2", False, "Bool")
	IniReadS($g_aiStopAtkNoLoot2Time[$LB], $g_sProfileConfigPath, "endbattle", "txtABTimeStopAtk2", 7, "int")
	IniReadS($g_aiStopAtkNoLoot2MinGold[$LB], $g_sProfileConfigPath, "endbattle", "txtABMinGoldStopAtk2", 1000, "int")
	IniReadS($g_aiStopAtkNoLoot2MinElixir[$LB], $g_sProfileConfigPath, "endbattle", "txtABMinElixirStopAtk2", 1000, "int")
	IniReadS($g_aiStopAtkNoLoot2MinDark[$LB], $g_sProfileConfigPath, "endbattle", "txtABMinDarkElixirStopAtk2", 50, "int")
	IniReadS($g_abStopAtkNoResources[$LB], $g_sProfileConfigPath, "endbattle", "chkABEndNoResources", False, "Bool")
	IniReadS($g_abStopAtkOneStar[$LB], $g_sProfileConfigPath, "endbattle", "chkABEndOneStar", False, "Bool")
	IniReadS($g_abStopAtkTwoStars[$LB], $g_sProfileConfigPath, "endbattle", "chkABEndTwoStars", False, "Bool")
	IniReadS($g_bDESideEndEnable, $g_sProfileConfigPath, "endbattle", "chkDESideEB", False, "Bool")
	IniReadS($g_iDESideEndMin, $g_sProfileConfigPath, "endbattle", "txtDELowEndMin", 25, "int")
	IniReadS($g_bDESideDisableOther, $g_sProfileConfigPath, "endbattle", "chkDisableOtherEBO", False, "Bool")
	IniReadS($g_bDESideEndBKWeak, $g_sProfileConfigPath, "endbattle", "chkDEEndBk", False, "Bool")
	IniReadS($g_bDESideEndAQWeak, $g_sProfileConfigPath, "endbattle", "chkDEEndAq", False, "Bool")
	IniReadS($g_bDESideEndOneStar, $g_sProfileConfigPath, "endbattle", "chkDEEndOneStar", False, "Bool")
	IniReadS($g_abStopAtkPctHigherEnable[$LB], $g_sProfileConfigPath, "endbattle", "chkABPercentageHigher", False, "Bool")
	IniReadS($g_aiStopAtkPctHigherAmt[$LB], $g_sProfileConfigPath, "endbattle", "txtABPercentageHigher", 50, "int")
	IniReadS($g_abStopAtkPctNoChangeEnable[$LB], $g_sProfileConfigPath, "endbattle", "chkABPercentageChange", False, "Bool")
	IniReadS($g_aiStopAtkPctNoChangeTime[$LB], $g_sProfileConfigPath, "endbattle", "txtABPercentageChange", 15, "int")
EndFunc   ;==>ReadConfig_600_30_LB

Func ReadConfig_600_30_TS()
	; <><><><> Attack Plan / Search & Attack / TH Snipe / End Battle <><><><>
	IniReadS($g_bEndTSCampsEnable, $g_sProfileConfigPath, "search", "ChkTSSearchCamps2", False, "Bool")
	IniReadS($g_iEndTSCampsPct, $g_sProfileConfigPath, "search", "TSEnableAfterArmyCamps2", 100, "int")
EndFunc   ;==>ReadConfig_600_30_TS

Func ReadConfig_600_31()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Collectors <><><><>
	$g_abCollectorLevelEnabled[6] = 0
	For $i = 7 To 12
		IniReadS($g_abCollectorLevelEnabled[$i], $g_sProfileConfigPath, "collectors", "lvl" & $i & "Enabled", True, "Bool")
	Next
	For $i = 6 To 12
		IniReadS($g_aiCollectorLevelFill[$i], $g_sProfileConfigPath, "collectors", "lvl" & $i & "fill", 0, "int")
		If $g_aiCollectorLevelFill[$i] > 1 Then $g_aiCollectorLevelFill[$i] = 1
	Next
	IniReadS($g_bCollectorFilterDisable, $g_sProfileConfigPath, "search", "chkDisableCollectorsFilter", False, "Bool")
	IniReadS($g_iCollectorMatchesMin, $g_sProfileConfigPath, "collectors", "minmatches", $g_iCollectorMatchesMin) ; 1-6 collectors
	If $g_iCollectorMatchesMin < 1 Or $g_iCollectorMatchesMin > 6 Then $g_iCollectorMatchesMin = 3
	IniReadS($g_iCollectorToleranceOffset, $g_sProfileConfigPath, "collectors", "tolerance", 0, "int")
EndFunc   ;==>ReadConfig_600_31

Func ReadConfig_600_32()
	; <><><><> Attack Plan / Search & Attack / Options / Trophy Settings <><><><>
	IniReadS($g_bDropTrophyEnable, $g_sProfileConfigPath, "search", "TrophyRange", False, "Bool")
	IniReadS($g_iDropTrophyMin, $g_sProfileConfigPath, "search", "MinTrophy", 5000, "int")
	IniReadS($g_iDropTrophyMax, $g_sProfileConfigPath, "search", "MaxTrophy", 5000, "int")
	IniReadS($g_bDropTrophyUseHeroes, $g_sProfileConfigPath, "search", "chkTrophyHeroes", False, "Bool")
	IniReadS($g_iDropTrophyHeroesPriority, $g_sProfileConfigPath, "search", "cmbTrophyHeroesPriority", 0, "int")
	IniReadS($g_bDropTrophyAtkDead, $g_sProfileConfigPath, "search", "chkTrophyAtkDead", False, "Bool")
	IniReadS($g_iDropTrophyArmyMinPct, $g_sProfileConfigPath, "search", "DTArmyMin", 70, "int")
EndFunc   ;==>ReadConfig_600_32

Func ReadConfig_600_33()
	; <><><><> Attack Plan / Search & Attack / Drop Order Troops <><><><>
	IniReadS($g_bCustomDropOrderEnable, $g_sProfileConfigPath, "DropOrder", "chkDropOrder", False, "Bool")
	For $p = 0 To UBound($g_aiCmbCustomDropOrder) - 1
		IniReadS($g_aiCmbCustomDropOrder[$p], $g_sProfileConfigPath, "DropOrder", "cmbDropOrder" & $p, -1)
	Next
EndFunc   ;==>ReadConfig_600_33

Func ReadConfig_600_35_1()
	; <><><><> Bot / Options <><><><>
	$g_bDisableSplash = (IniRead($g_sProfileConfigPath, "General", "ChkDisableSplash", "0") = "1")
	$g_bCheckVersion = (IniRead($g_sProfileConfigPath, "General", "ChkVersion", "1") = "1")
	IniReadS($g_bDeleteLogs, $g_sProfileConfigPath, "deletefiles", "DeleteLogs", True, "Bool")
	IniReadS($g_iDeleteLogsDays, $g_sProfileConfigPath, "deletefiles", "DeleteLogsDays", 2, "int")
	IniReadS($g_bDeleteTemp, $g_sProfileConfigPath, "deletefiles", "DeleteTemp", True, "Bool")
	IniReadS($g_iDeleteTempDays, $g_sProfileConfigPath, "deletefiles", "DeleteTempDays", 5, "int")
	IniReadS($g_bDeleteLoots, $g_sProfileConfigPath, "deletefiles", "DeleteLoots", True, "Bool")
	IniReadS($g_iDeleteLootsDays, $g_sProfileConfigPath, "deletefiles", "DeleteLootsDays", 2, "int")
	IniReadS($g_bAutoStart, $g_sProfileConfigPath, "general", "AutoStart", False, "Bool")
	IniReadS($g_iAutoStartDelay, $g_sProfileConfigPath, "general", "AutoStartDelay", 10, "int")
	IniReadS($g_bRestarted, $g_sProfileConfigPath, "general", "Restarted", $g_bRestarted, "int")
	If $g_bBotLaunchOption_Autostart = True Then $g_bRestarted = True
	$g_bCheckGameLanguage = (IniRead($g_sProfileConfigPath, "General", "ChkLanguage", "1") = "1")
	IniReadS($g_bAutoAlignEnable, $g_sProfileConfigPath, "general", "DisposeWindows", False, "Bool")
	IniReadS($g_iAutoAlignPosition, $g_sProfileConfigPath, "general", "DisposeWindowsPos", "EMBED")
	IniReadS($g_iAutoAlignOffsetX, $g_sProfileConfigPath, "other", "WAOffsetX", "")
	IniReadS($g_iAutoAlignOffsetY, $g_sProfileConfigPath, "other", "WAOffsetY", "")
	;$g_bUpdatingWhenMinimized must be always enabled
	;IniReadS($g_bUpdatingWhenMinimized, $g_sProfileConfigPath, "general", "UpdatingWhenMinimized", True, "Bool")
	IniReadS($g_bHideWhenMinimized, $g_sProfileConfigPath, "general", "HideWhenMinimized", False, "Bool")
	$g_bUseRandomClick = (IniRead($g_sProfileConfigPath, "other", "UseRandomClick", "0") = "1")
	$g_bScreenshotPNGFormat = (IniRead($g_sProfileConfigPath, "other", "ScreenshotType", "0") = "1") ;screenshot type: 0 JPG   1 PNG
	$g_bScreenshotHideName = (IniRead($g_sProfileConfigPath, "other", "ScreenshotHideName", "1") = "1")
	IniReadS($g_iAnotherDeviceWaitTime, $g_sProfileConfigPath, "other", "txtTimeWakeUp", 0, "int")
	$g_bForceSinglePBLogoff = (IniRead($g_sProfileConfigPath, "other", "chkSinglePBTForced", "0") = "1")
	$g_iSinglePBForcedLogoffTime = Int(IniRead($g_sProfileConfigPath, "other", "ValueSinglePBTimeForced", 18))
	$g_iSinglePBForcedEarlyExitTime = Int(IniRead($g_sProfileConfigPath, "other", "ValuePBTimeForcedExit", 15))
	$g_bAutoResumeEnable = (IniRead($g_sProfileConfigPath, "other", "ChkAutoResume", "0") = "1")
	$g_iAutoResumeTime = Int(IniRead($g_sProfileConfigPath, "other", "AutoResumeTime", 5))
	IniReadS($g_bDisableNotifications, $g_sProfileConfigPath, "other", "ChkDisableNotifications", False, "Bool")
	$g_bForceClanCastleDetection = (IniRead($g_sProfileConfigPath, "other", "ChkFixClanCastle", "0") = "1")
EndFunc   ;==>ReadConfig_600_35_1

Func ReadConfig_600_35_2()
	; <><><><> Bot / Profile / Switch Account <><><><>
	Local $sSwitchAccFile
	$g_iCmbSwitchAcc = 0
	$g_bChkSwitchAcc = False
	For $g = 1 To 8
		; find group this profile belongs to: no switch profile config is saved in config.ini on purpose!
		$sSwitchAccFile = $g_sProfilePath & "\SwitchAccount.0" & $g & ".ini"
		If FileExists($sSwitchAccFile) = 0 Then ContinueLoop
		Local $sProfile
		Local $bEnabled
		For $i = 1 To Int(IniRead($sSwitchAccFile, "SwitchAccount", "TotalCocAccount", 0)) + 1
			$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "Enable", "") = "1"
			If $bEnabled Then
				$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "AccountNo." & $i, "") = "1"
				If $bEnabled Then
					$sProfile = IniRead($sSwitchAccFile, "SwitchAccount", "ProfileName." & $i, "")
					If $sProfile = $g_sProfileCurrentName Then
						; found current profile
						$g_iCmbSwitchAcc = $g
						ExitLoop
					EndIf
				EndIf
			EndIf
		Next

		If $g_iCmbSwitchAcc Then
			ReadConfig_SwitchAccounts()
			ExitLoop
		EndIf
	Next
EndFunc   ;==>ReadConfig_600_35_2

Func ReadConfig_SwitchAccounts()
	If $g_iCmbSwitchAcc Then
		Local $sSwitchAccFile = $g_sProfilePath & "\SwitchAccount.0" & $g_iCmbSwitchAcc & ".ini"
		$g_bChkSwitchAcc = IniRead($sSwitchAccFile, "SwitchAccount", "Enable", "0") = "1"
		$g_bChkGooglePlay = IniRead($sSwitchAccFile, "SwitchAccount", "GooglePlay", "0") = "1"
		$g_bChkSuperCellID = IniRead($sSwitchAccFile, "SwitchAccount", "SuperCellID", "0") = "1"
		$g_bChkSharedPrefs = IniRead($sSwitchAccFile, "SwitchAccount", "SharedPrefs", "0") = "1"
		$g_bChkSmartSwitch = IniRead($sSwitchAccFile, "SwitchAccount", "SmartSwitch", "0") = "1"
		$g_bDonateLikeCrazy = IniRead($sSwitchAccFile, "SwitchAccount", "DonateLikeCrazy", "0") = "1"
		$g_iTotalAcc = Int(IniRead($sSwitchAccFile, "SwitchAccount", "TotalCocAccount", "-1"))
		$g_iTrainTimeToSkip = Int(IniRead($sSwitchAccFile, "SwitchAccount", "TrainTimeToSkip", "1"))
		For $i = 1 To 8
			$g_abAccountNo[$i - 1] = IniRead($sSwitchAccFile, "SwitchAccount", "AccountNo." & $i, "") = "1"
			$g_asProfileName[$i - 1] = IniRead($sSwitchAccFile, "SwitchAccount", "ProfileName." & $i, "")
			$g_abDonateOnly[$i - 1] = IniRead($sSwitchAccFile, "SwitchAccount", "DonateOnly." & $i, "0") = "1"
		Next
	EndIf
EndFunc   ;==>ReadConfig_SwitchAccounts

Func ReadConfig_600_52_1()
	; <><><><> Attack Plan / Train Army / Troops/Spells <><><><>
	$g_bQuickTrainEnable = (IniRead($g_sProfileConfigPath, "other", "ChkUseQTrain", "0") = "1")
	$g_bQuickTrainArmy[0] = (IniRead($g_sProfileConfigPath, "troop", "QuickTrainArmy1", "0") = "1")
	$g_bQuickTrainArmy[1] = (IniRead($g_sProfileConfigPath, "troop", "QuickTrainArmy2", "0") = "1")
	$g_bQuickTrainArmy[2] = (IniRead($g_sProfileConfigPath, "troop", "QuickTrainArmy3", "0") = "1")
EndFunc   ;==>ReadConfig_600_52_1

Func ReadConfig_600_52_2()
	For $T = 0 To $eTroopCount - 1
		Local $tempTroopCount, $tempTroopLevel
		Switch $T
			Case $eTroopBarbarian
				IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 58, "int")
				IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
			Case $eTroopArcher
				IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 115, "int")
				IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
			Case $eTroopGoblin
				IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 19, "int")
				IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
			Case $eTroopGiant
				IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 4, "int")
				IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
			Case $eTroopWallBreaker
				IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 4, "int")
				IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 1, "int")
			Case Else
				IniReadS($tempTroopCount, $g_sProfileConfigPath, "troop", $g_asTroopShortNames[$T], 0, "int")
				IniReadS($tempTroopLevel, $g_sProfileConfigPath, "LevelTroop", $g_asTroopShortNames[$T], 0, "int")
		EndSwitch
		$g_aiArmyCompTroops[$T] = $tempTroopCount
		$g_aiTrainArmyTroopLevel[$T] = $tempTroopLevel
	Next
	For $S = 0 To $eSpellCount - 1
		IniReadS($g_aiArmyCompSpells[$S], $g_sProfileConfigPath, "Spells", $g_asSpellShortNames[$S], 0, "int")
		IniReadS($g_aiTrainArmySpellLevel[$S], $g_sProfileConfigPath, "LevelSpell", $g_asSpellShortNames[$S], 0, "int")
	Next
	IniReadS($g_iTrainArmyFullTroopPct, $g_sProfileConfigPath, "troop", "fullTroop", 100, "int")
	$g_bTotalCampForced = (IniRead($g_sProfileConfigPath, "other", "ChkTotalCampForced", "1") = "1")
	$g_iTotalCampForcedValue = Int(IniRead($g_sProfileConfigPath, "other", "ValueTotalCampForced", 220))
	$g_bForceBrewSpells = (IniRead($g_sProfileConfigPath, "other", "ChkForceBrewBeforeAttack", "0") = "1")
	IniReadS($g_iTotalSpellValue, $g_sProfileConfigPath, "Spells", "SpellFactory", 0, "int")
	$g_iTotalSpellValue = Int($g_iTotalSpellValue)
EndFunc   ;==>ReadConfig_600_52_2

Func ReadConfig_600_54()
	; <><><><> Attack Plan / Train Army / Train Order <><><><>
	; Troops Order
	IniReadS($g_bCustomTrainOrderEnable, $g_sProfileConfigPath, "troop", "chkTroopOrder", False, "Bool")
	For $z = 0 To UBound($g_aiCmbCustomTrainOrder) - 1
		IniReadS($g_aiCmbCustomTrainOrder[$z], $g_sProfileConfigPath, "troop", "cmbTroopOrder" & $z, -1)
	Next

	; Spells Order
	IniReadS($g_bCustomBrewOrderEnable, $g_sProfileConfigPath, "Spells", "chkSpellOrder", False, "Bool")
	For $z = 0 To UBound($g_aiCmbCustomBrewOrder) - 1
		IniReadS($g_aiCmbCustomBrewOrder[$z], $g_sProfileConfigPath, "Spells", "cmbSpellOrder" & $z, -1)
	Next
EndFunc   ;==>ReadConfig_600_54

Func ReadConfig_600_56()
	; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
	$g_bSmartZapEnable = (IniRead($g_sProfileConfigPath, "SmartZap", "UseSmartZap", "0") = "1")
	$g_bEarthQuakeZap = (IniRead($g_sProfileConfigPath, "SmartZap", "UseEarthQuakeZap", "0") = "1")
	$g_bNoobZap = (IniRead($g_sProfileConfigPath, "SmartZap", "UseNoobZap", "0") = "1")
	$g_bSmartZapDB = (IniRead($g_sProfileConfigPath, "SmartZap", "ZapDBOnly", "1") = "1")
	$g_bSmartZapSaveHeroes = (IniRead($g_sProfileConfigPath, "SmartZap", "THSnipeSaveHeroes", "1") = "1")
	$g_bSmartZapFTW = (IniRead($g_sProfileConfigPath, "SmartZap", "FTW", "0") = "1")
	$g_iSmartZapMinDE = Int(IniRead($g_sProfileConfigPath, "SmartZap", "MinDE", 350))
	$g_iSmartZapExpectedDE = Int(IniRead($g_sProfileConfigPath, "SmartZap", "ExpectedDE", 320))
EndFunc   ;==>ReadConfig_600_56

Func ReadConfig_641_1()
	; <><><><> Attack Plan / Train Army / Options <><><><>
	IniReadS($g_bCloseWhileTrainingEnable, $g_sProfileConfigPath, "other", "chkCloseWaitEnable", True, "Bool")
	IniReadS($g_bCloseWithoutShield, $g_sProfileConfigPath, "other", "chkCloseWaitTrain", False, "Bool")
	IniReadS($g_bCloseEmulator, $g_sProfileConfigPath, "other", "btnCloseWaitStop", False, "Bool")
	IniReadS($g_bSuspendComputer, $g_sProfileConfigPath, "other", "btnCloseWaitSuspendComputer", False, "Bool")
	IniReadS($g_bCloseRandom, $g_sProfileConfigPath, "other", "btnCloseWaitStopRandom", False, "Bool")
	IniReadS($g_bCloseExactTime, $g_sProfileConfigPath, "other", "btnCloseWaitExact", False, "Bool")
	IniReadS($g_bCloseRandomTime, $g_sProfileConfigPath, "other", "btnCloseWaitRandom", True, "Bool")
	IniReadS($g_iCloseRandomTimePercent, $g_sProfileConfigPath, "other", "CloseWaitRdmPercent", 10, "int")
	IniReadS($g_iCloseMinimumTime, $g_sProfileConfigPath, "other", "MinimumTimeToClose", 2, "int")
	IniReadS($g_iTrainClickDelay, $g_sProfileConfigPath, "other", "TrainITDelay", 40, "int")
	IniReadS($g_bTrainAddRandomDelayEnable, $g_sProfileConfigPath, "other", "chkAddIdleTime", $g_bTrainAddRandomDelayEnable, "Bool")
	IniReadS($g_iTrainAddRandomDelayMin, $g_sProfileConfigPath, "other", "txtAddDelayIdlePhaseTimeMin", $g_iTrainAddRandomDelayMin, "Int")
	IniReadS($g_iTrainAddRandomDelayMax, $g_sProfileConfigPath, "other", "txtAddDelayIdlePhaseTimeMax", $g_iTrainAddRandomDelayMax, "Int")
EndFunc   ;==>ReadConfig_641_1

Func IniReadS(ByRef $variable, $PrimaryInputFile, $section, $key, $defaultvalue, $valueType = Default)
	;read from standard config ini file but, if variable $g_sProfileSecondaryInputFileName <>"" (valorized by button read strategy), if exists
	;section->key override values from ini files with values in $g_sProfileSecondaryInputFileName
	Local $defaultvalueTest = "?"
	Local $readValue = IniRead($g_sProfileSecondaryInputFileName, $section, $key, $defaultvalueTest)
	If $readValue = $defaultvalueTest Then
		$readValue = IniRead($PrimaryInputFile, $section, $key, $defaultvalue)
	EndIf
	Switch $valueType
		Case Default
			; no conversion
			$variable = $readValue
		Case "Int"
			; convert to Int
			$variable = Int($readValue)
		Case "Bool"
			; convert to boolean type
			If $readValue = "True" Or $readValue = "1" Then
				$variable = True
			Else
				$variable = False
			EndIf
		Case Else
			; Unsupported type
			$variable = $readValue
	EndSwitch

EndFunc   ;==>IniReadS
