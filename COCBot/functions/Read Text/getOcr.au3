; #FUNCTION# ====================================================================================================================
; Name ..........: OCR
; Description ...: Gets complete value of gold/Elixir/DarkElixir/Trophy/Gem xxx,xxx
; Author ........: Didipe (2015)
; Modified ......: ProMac (2015), Hervidero (2015-12), MMHK (2016-12), MR.ViPER (2017-4), Moebius14 (2023-06)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getOresValues($x_start, $y_start, $bNeedCapture = True) ;  -> Get least upgradetime on builder menu
	Return getOcrAndCapture("coc-ores", $x_start, $y_start, 160, 16, $bNeedCapture)
EndFunc   ;==>getBuilderLeastUpgradeTime

Func getNameBuilding($x_start, $y_start) ; getNameBuilding(242,520) -> Gets complete name and level of the buildings, bottom of screen
	Return getOcrAndCapture("coc-build", $x_start, $y_start, 420, 27)
EndFunc   ;==>getNameBuilding

Func getGoldVillageSearch($x_start, $y_start) ;48, 69 -> Gets complete value of gold xxx,xxx while searching, top left, Getresources.au3
	Return getOcrAndCapture("coc-v-g", $x_start, $y_start, 90, 16, True)
EndFunc   ;==>getGoldVillageSearch

Func getRemainTrainTimer($x_start, $y_start, $bNeedCapture = True) ;
	Return getOcrAndCapture("coc-RemainTrain", $x_start, $y_start, 70, 16, True, False, $bNeedCapture)
EndFunc   ;==>getRemainTrainTimer

Func getElixirVillageSearch($x_start, $y_start) ;48, 69+29 -> Gets complete value of Elixir xxx,xxx, top left,  Getresources.au3
	Return getOcrAndCapture("coc-v-e", $x_start, $y_start, 90, 16, True)
EndFunc   ;==>getElixirVillageSearch

Func getDarkElixirVillageSearch($x_start, $y_start) ;48, 69+57 or 69+69  -> Gets complete value of Dark Elixir xxx,xxx, top left,  Getresources.au3
	Return getOcrAndCapture("coc-v-de", $x_start, $y_start, 75, 18, True)
EndFunc   ;==>getDarkElixirVillageSearch

Func getTrophyVillageSearch($x_start, $y_start) ;48, 69+99 or 69+69 -> Gets complete value of Trophies xxx,xxx , top left, Getresources.au3
	Return getOcrAndCapture("coc-v-t", $x_start, $y_start, 75, 18, True)
EndFunc   ;==>getTrophyVillageSearch

Func getTrophyMainScreen($x_start, $y_start) ; -> Gets trophy value, top left of main screen "VillageReport.au3"
	Return getOcrAndCapture("coc-ms", $x_start, $y_start, 50, 16, True)
EndFunc   ;==>getTrophyMainScreen

Func getTrophyLossAttackScreen($x_start, $y_start) ; 48,214 or 48,184 WO/DE -> Gets red number of trophy loss from attack screen, top left
	Return getOcrAndCapture("coc-t-p", $x_start, $y_start, 50, 16, True)
EndFunc   ;==>getTrophyLossAttackScreen

Func getResourcesMainScreen($x_start, $y_start) ; -> Gets complete value of Gold/Elixir/Dark Elixir/Trophies/Gems xxx,xxx "VillageReport.au3"
	Return getOcrAndCapture("coc-ms", $x_start, $y_start, 110, 16, True)
EndFunc   ;==>getResourcesMainScreen

Func getResourcesLoot($x_start, $y_start) ; -> Gets complete value of Gold/Elixir after attack xxx,xxx "AttackReport"
	Return getOcrAndCapture("coc-loot", $x_start, $y_start, 160, 22, True)
EndFunc   ;==>getResourcesLoot

Func getResourcesLootDE($x_start, $y_start) ; -> Gets complete value of Dark Elixir after attack xxx,xxx "AttackReport"
	Return getOcrAndCapture("coc-loot", $x_start, $y_start, 85, 22, True)
EndFunc   ;==>getResourcesLootDE

Func getResourcesLootT($x_start, $y_start) ; -> Gets complete value of Trophies after attack. xxx,xxx "AttackReport"
	Return getOcrAndCapture("coc-loot", $x_start, $y_start, 37, 22, True)
EndFunc   ;==>getResourcesLootT

Func getResourcesBonus($x_start, $y_start) ; -> Gets complete value of Gold/Elixir bonus loot in "AttackReport.au3"
	Return getOcrAndCapture("coc-bonus", $x_start, $y_start, 98, 20, True)
EndFunc   ;==>getResourcesBonus

Func getCostsUpgrade($x_start, $y_start) ; -> Gets complete value of Gold/Elixir bonus loot in "AttackReport.au3"
	Return getOcrAndCapture("coc-CostsUpgrades", $x_start, $y_start, 120, 18, True)
EndFunc   ;==>getCostsUpgrade

Func getCostsUpgradeRed($x_start, $y_start) ; -> Gets complete value of Gold/Elixir xxx,xxx , RED text on green upgrade button."UpgradeBuildings.au3"
	Return getOcrAndCapture("coc-u-r", $x_start, $y_start, 120, 18, True)
EndFunc   ;==>getCostsUpgradeRed

Func getResourcesBonusPerc($x_start, $y_start) ; -> Gets complete value of Bonus % in "AttackReport.au3"
	Return getOcrAndCapture("coc-bonus", $x_start, $y_start, 48, 16, True)
EndFunc   ;==>getResourcesBonusPerc

Func getLabUpgrdResourceWht($x_start, $y_start) ; -> Gets complete value of Elixir/DE on the troop buttons, xxx,xxx for "laboratory.au3" and "starlaboratory.au3" when white text
	Return getOcrAndCapture("coc-lab-w", $x_start, $y_start, 85, 14, True)
EndFunc   ;==>getLabUpgrdResourceWht

Func getLabUpgrdResourceWhtNew($x_start, $y_start) ; -> Gets complete value of Elixir/DE on the troop buttons, xxx,xxx for "laboratory.au3" and "starlaboratory.au3" when white text
	Return getOcrAndCapture("coc-lab-wNew", $x_start, $y_start, 86, 14, True)
EndFunc   ;==>getLabUpgrdResourceWhtNew

Func getLabUpgrdResourceRed($x_start, $y_start) ; -> Gets complete value of Elixir/DE on the troop buttons,  xxx,xxx for "laboratory.au3" when red text
	Return getOcrAndCapture("coc-lab-r", $x_start, $y_start, 86, 14, True)
EndFunc   ;==>getLabUpgrdResourceRed

Func getStarLabUpgrdResourceRed($x_start, $y_start) ; -> Gets complete value of Elixir on the troop buttons,  xxx,xxx for "starlaboratory.au3" when red text
	Return getOcrAndCapture("coc-starlab-r", $x_start, $y_start, 85, 14, True)
EndFunc   ;==>getStarLabUpgrdResourceRed

Func getBldgUpgradeTime($x_start, $y_start) ; -> Gets complete remain building upgrade time
	Return getOcrAndCapture("coc-uptime", $x_start, $y_start, 105, 18, True) ; "12d 19h"
EndFunc   ;==>getBldgUpgradeTime

Func getLabUpgradeTime($x_start, $y_start) ; -> Gets complete remain lab upgrade time V3 for Dec2022 update
	Return getOcrAndCapture("coc-uptime2", $x_start, $y_start, 100, 24, True) ; 95 is required to upgrades
EndFunc   ;==>getLabUpgradeTime

Func getLabUpgradeTime2($x_start, $y_start) ; -> Gets complete remain lab upgrade time V3 for Dec2022 update
	Return getOcrAndCapture("coc-uptime", $x_start, $y_start, 90, 18, True) ; 90 is required to upgrades > 10 days
EndFunc   ;==>getLabUpgradeTime2

Func getPetUpgradeTime($x_start, $y_start) ; -> Gets complete remain lab upgrade time V4 for Jun2023 update
	Return getOcrAndCapture("coc-uptime2", $x_start, $y_start, 215, 24, True)
EndFunc   ;==>getPetUpgradeTime

Func getHeroUpgradeTime($x_start, $y_start) ; -> Gets complete upgrade time for heroes 595, 490 + $g_iMidOffsetY
	Return getOcrAndCapture("coc-uptime", $x_start, $y_start, 105, 18, True) ; 85 is required to days & hours for hero ; COC 15.352.22
EndFunc   ;==>getHeroUpgradeTime

Func getChatString($x_start, $y_start, $language) ; -> Get string chat request - Latin Alphabetic - EN "DonateCC.au3"
	Return getOcrAndCapture($language, $x_start, $y_start, 325, 16)
EndFunc   ;==>getChatString

Func getBuilders($x_start, $y_start) ;  -> Gets Builders number - main screen --> getBuilders(324,23)  coc-profile
	Return getOcrAndCapture("coc-Builders", $x_start, $y_start, 40, 18, True)
EndFunc   ;==>getBuilders

Func getProfile($x_start, $y_start) ;  -> Gets Attack Win/Defense Win/Donated/Received values - profile screen --> getProfile(160,268)  troops donation
	Return getOcrAndCapture("coc-profile", $x_start, $y_start, 55, 13, True)
EndFunc   ;==>getProfile

Func getTroopCountSmall($x_start, $y_start, $bNeedNewCapture = Default) ;  -> Gets troop amount on Attack Screen for non-selected troop kind
	Return getOcrAndCapture("coc-t-s", $x_start, $y_start, 57, 16, True, Default, $bNeedNewCapture)
EndFunc   ;==>getTroopCountSmall

Func getTroopCountBig($x_start, $y_start, $bNeedNewCapture = Default) ;  -> Gets troop amount on Attack Screen for selected troop kind
	Return getOcrAndCapture("coc-t-b", $x_start, $y_start, 55, 17, True, Default, $bNeedNewCapture)
EndFunc   ;==>getTroopCountBig

Func getTroopsSpellsLevel($x_start, $y_start, $bDebugImageSave = $g_bDebugImageSave) ;  -> Gets spell level on Attack Screen for selected spell kind (could be used for troops too)
	Local $Result = getOcrAndCapture("coc-spellslevel", $x_start, $y_start, 20, 14, True)
	If $bDebugImageSave Then
		Local $sArea = $x_start & "," & $y_start & "," & $x_start + 20 & "," & $y_start + 14
		SaveDebugRectImage("SpellsOCR" & $Result, $sArea)
	EndIf
	Return $Result
EndFunc   ;==>getTroopsSpellsLevel

Func getPetsLevel($x_start, $y_start, $bDebugImageSave = $g_bDebugImageSave) ;  -> Gets Pets level.
	Local $Result = StringReplace(getOcrAndCapture("coc-petslevel", $x_start, $y_start, 20, 16, True), "b", "")
	If $bDebugImageSave Then
		Local $sArea = $x_start & "," & $y_start & "," & $x_start + 20 & "," & $y_start + 16
		SaveDebugRectImage("PetsOCR" & $Result, $sArea)
	EndIf
	Return $Result
EndFunc   ;==>getPetsLevel

Func getSiegeLevel($x_start, $y_start, $bDebugImageSave = $g_bDebugImageSave) ;  -> Gets Siege level on Attack Screen
	Local $Result = getOcrAndCapture("coc-siegelevel", $x_start, $y_start, 20, 14, True)
	If $bDebugImageSave Then
		Local $sArea = $x_start & "," & $y_start & "," & $x_start + 20 & "," & $y_start + 14
		SaveDebugRectImage("SiegeOCR" & $Result, $sArea)
	EndIf
	Return $Result
EndFunc   ;==>getSiegeLevel

Func getArmyCampCap($x_start, $y_start, $bNeedCapture = True) ;  -> Gets army camp capacity --> train.au3, and used to read CC request time remaining
	Return getOcrAndCapture("coc-camps", $x_start, $y_start, 82, 16, True, False, $bNeedCapture)
EndFunc   ;==>getArmyCampCap

Func getSiegeCampCap($x_start, $y_start, $bNeedCapture = True) ;  -> Gets army camp capacity --> train.au3, and used to read CC request time remaining
	Return getOcrAndCapture("coc-camps", $x_start, $y_start, 40, 16, True, False, $bNeedCapture)
EndFunc   ;==>getSiegeCampCap

Func getCCSiegeCampCap($x_start, $y_start, $bNeedCapture = True) ;  -> Gets army camp capacity --> train.au3, and used to read CC request time remaining
	Return getOcrAndCapture("coc-camps", $x_start, $y_start, 28, 16, True, False, $bNeedCapture)
EndFunc   ;==>getCCSiegeCampCap

Func getCastleDonateCap($x_start, $y_start) ;  -> Gets clan castle capacity,  --> donatecc.au3
	Return getOcrAndCapture("coc-army", $x_start, $y_start, 30, 14, True)
EndFunc   ;==>getCastleDonateCap

Func getOcrLanguage($x_start, $y_start) ;  -> Get english language - main screen - "Attack" text on attack button
	Return getOcrAndCapture("coc-ms-testl", $x_start, $y_start, 93, 16, True)
EndFunc   ;==>getOcrLanguage

Func getOcrSpaceCastleDonate($x_start, $y_start) ;  -> Get the number of troops donated/capacity from a request
	Return getOcrAndCapture("coc-totalreq", $x_start, $y_start, 49, 14, True)
EndFunc   ;==>getOcrSpaceCastleDonate

Func getOcrOverAllDamage($x_start, $y_start) ;  -> Get the Overall Damage %
	Return getOcrAndCapture("coc-overalldamage", $x_start, $y_start, 50, 20, True)
EndFunc   ;==>getOcrOverAllDamage

Func getOcrGuardShield($x_start, $y_start) ;  -> Get the guard/shield time left, middle top of the screen
	Return getOcrAndCapture("coc-guardshield", $x_start, $y_start, 68, 15)
EndFunc   ;==>getOcrGuardShield

Func getCCBuildingName($x_start, $y_start) ;  -> Get BuildingName on builder menu
	Local $BuildingName = "", $Count = 1
	Local $Name = getOcrAndCapture("coc-ccbuildermenu-name", $x_start, $y_start, 200, 18, False)
	If StringRegExp($Name, "x\d{1,}") Then
		Local $aCount = StringRegExp($Name, "\d{1,}", 1) ;check if we found count of building
		If IsArray($aCount) Then $Count = $aCount[0]
	EndIf

	If StringLeft($Name, 2) = "l " Then
		$BuildingName = StringTrimLeft($Name, 2) ;remove first "l" because sometimes buildermenu border captured as "l"
	Else
		$BuildingName = $Name
	EndIf

	If StringRegExp($BuildingName, "x\d{1,}") Then
		Local $aReplace = StringRegExp($BuildingName, "( x\d{1,})", 1)
		Local $TmpBuildingName = StringReplace($BuildingName, $aReplace[0], "")
		$BuildingName = StringStripWS($TmpBuildingName, $STR_STRIPTRAILING)
	EndIf

	Local $aResult[2]
	$aResult[0] = $BuildingName
	$aResult[1] = Number($Count)
	Return $aResult
EndFunc   ;==>getCCBuildingName

Func getCCBuildingNameSuggested($x_start, $y_start) ;  -> Get BuildingName on builder menu
	Local $BuildingName = "", $Count = 1
	Local $Name = getOcrAndCapture("coc-ccbuildermenu-name", $x_start, $y_start, 200, 18, False)
	If StringRegExp($Name, "x\d{1,}") Then
		Local $aCount = StringRegExp($Name, "\d{1,}", 1) ;check if we found count of building
		If IsArray($aCount) Then $Count = $aCount[0]
	EndIf

	If StringLeft($Name, 2) = "l " Then
		$BuildingName = StringTrimLeft($Name, 2) ;remove first "l" because sometimes buildermenu border captured as "l"
	Else
		$BuildingName = $Name
	EndIf

	If StringRegExp($BuildingName, "x\d{1,}") Then
		Local $aReplace = StringRegExp($BuildingName, "(x\d{1,})", 1)
		Local $TmpBuildingName = StringReplace($BuildingName, $aReplace[0], "")
		$BuildingName = StringStripWS($TmpBuildingName, $STR_STRIPTRAILING)
	EndIf

	If StringRight($BuildingName, 2) = " l" Then
		$BuildingName = StringTrimRight($BuildingName, 2) ;remove "l" at the end in some cases
	EndIf

	Local $aResult[2]
	$aResult[0] = $BuildingName
	$aResult[1] = Number($Count)
	Return $aResult
EndFunc   ;==>getCCBuildingNameSuggested

Func getCCBuildingNameBlue($x_start, $y_start) ;  -> Get BuildingName on builder menu
	Local $BuildingName = "", $Count = 1
	Local $Name = getOcrAndCapture("coc-ccbuildermenu-nameblue", $x_start, $y_start, 200, 18, False)
	If StringRegExp($Name, "x\d{1,}") Then
		Local $aCount = StringRegExp($Name, "\d{1,}", 1) ;check if we found count of building
		If IsArray($aCount) Then $Count = $aCount[0]
	EndIf

	If StringLeft($Name, 2) = "l " Then
		$BuildingName = StringTrimLeft($Name, 2) ;remove first "l" because sometimes buildermenu border captured as "l"
	Else
		$BuildingName = $Name
	EndIf

	If StringRegExp($BuildingName, "x\d{1,}") Then
		Local $aReplace = StringRegExp($BuildingName, "( x\d{1,})", 1)
		Local $TmpBuildingName = StringReplace($BuildingName, $aReplace[0], "")
		$BuildingName = StringStripWS($TmpBuildingName, $STR_STRIPTRAILING)
	EndIf

	If StringRight($BuildingName, 2) = " l" Then
		$BuildingName = StringTrimRight($BuildingName, 2) ;remove "l" at the end in some cases
	EndIf

	Local $aResult[2]
	$aResult[0] = $BuildingName
	$aResult[1] = Number($Count)
	Return $aResult
EndFunc   ;==>getCCBuildingNameBlue

Func getOcrReloadMessage($x_start, $y_start, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default)
	Local $Result = getOcrAndCapture("coc-reloadmsg", $x_start, $y_start, 116, 19, True)
	Local $String = ""
	If $sLogText = Default Then
		$String = "getOcrReloadMessage: " & $Result
	Else
		$String = $sLogText & " " & $Result
	EndIf
	If $g_bDebugSetlog Then ; if enabled generate debug log message
		SetDebugLog($String, $LogTextColor, $bSilentSetLog)
	ElseIf $Result <> "" Then ;
		SetDebugLog($String, $LogTextColor, True) ; if result found, add to log file
	EndIf
	Return $Result
EndFunc   ;==>getOcrReloadMessage

Func getOcrMaintenanceTime($x_start, $y_start, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default)
	;  -> Get the Text with time till maintenance is over from reload msg(171, 375)
	Local $Result = getOcrAndCapture("coc-maintenance", $x_start, $y_start, 200, 18, True)
	Local $String = ""
	If $sLogText = Default Then
		$String = "getOcrMaintenanceTime: " & $Result
	Else
		$String = $sLogText & " " & $Result
	EndIf
	If $g_bDebugSetlog Then ; if enabled generate debug log message
		SetDebugLog($String, $LogTextColor, $bSilentSetLog)
	ElseIf $Result <> "" Then ;
		SetDebugLog($String, $LogTextColor, True) ; if result found, add to log file
	EndIf
	Return $Result
EndFunc   ;==>getOcrMaintenanceTime

Func getOcrTimeGameTime($x_start, $y_start) ;  -> Get the guard/shield time left, middle top of the screen
	Return getOcrAndCapture("coc-clangames", $x_start, $y_start, 130, 26, True)
EndFunc   ;==>getOcrTimeGameTime

Func getOcrYourScore($x_start, $y_start) ; -> Gets CheckValuesCost on Train Window
	Return getOcrAndCapture("coc-events", $x_start, $y_start, 110, 16, True)
EndFunc   ;==>getOcrYourScore

Func getOcrEventTime($x_start, $y_start) ; -> Gets CheckValuesCost on Train Window
	Return getOcrAndCapture("coc-events", $x_start, $y_start, 35, 16, True)
EndFunc   ;==>getOcrEventTime

Func getOcrRateCoc($x_start, $y_start, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default)
	;  -> Get the Text with time till maintenance is over from reload msg(228, 402)
	Local $Result = getOcrAndCapture("coc-ratecoc", $x_start, $y_start, 42, 28, True)
	Local $String = ""
	If $sLogText = Default Then
		$String = "getOcrRateCoc: " & $Result
	Else
		$String = $sLogText & " " & $Result
	EndIf
	If $g_bDebugSetlog Then ; if enabled generate debug log message
		SetDebugLog($String, $LogTextColor, $bSilentSetLog)
	ElseIf $Result <> "" Then ;
		SetDebugLog($String, $LogTextColor, True) ; if result found, add to log file
	EndIf
	Return $Result
EndFunc   ;==>getOcrRateCoc

Func getRemainTLaboratory($x_start, $y_start) ; read actual time remaining in Lab for current upgrade (336,260), changed CoC v9.24 282,277
	Return getOcrAndCapture("coc-RemainLaboratory", $x_start, $y_start, 260, 28, True)
EndFunc   ;==>getRemainTLaboratory

Func getRemainTLaboratory2($x_start, $y_start) ; read actual time remaining in Lab for current upgrade (336,260), changed CoC v9.24 282,277
	Return getOcrAndCapture("coc-RemainLaboratory2", $x_start, $y_start, 260, 26, True)
EndFunc   ;==>getRemainTLaboratory2

Func getRemainTLaboratoryGob($x_start, $y_start) ; read actual time remaining in Lab for current upgrade (336,260), changed CoC v9.24 282,277
	Return getOcrAndCapture("coc-RemainLabGob", $x_start, $y_start, 130, 18, True)
EndFunc   ;==>getRemainTLaboratoryGob

Func getRemainTHero($x_start, $y_start, $bNeedCapture = True) ; Get time remaining for hero to be ready for attack from train window, BK:443,504 AQ:504,504 GW:565:504
	Return getOcrAndCapture("coc-remainhero", $x_start, $y_start, 55, 12, True, False, $bNeedCapture)
EndFunc   ;==>getRemainTHero

Func getRequestRemainTime($x_start, $y_start, $bNeedCapture = True) ; Get Remain Time To request Troops
	Return StringReplace(getOcrAndCapture("coc-CCremainTime", $x_start, $y_start, 30, 10, False, False, $bNeedCapture), "b", "")
EndFunc   ;==>getRequestRemainTime

Func getCloudTextShort($x_start, $y_start, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default)
	; Get 3 characters of yellow text in center of attack search window during extended cloud waiting (388,378)
	; Full text length is 316 pixels, some is covered by chat window when open
	Local $Result = getOcrAndCapture("coc-cloudsearch", $x_start, $y_start, 51, 27)
	If $g_bDebugSetlog And $sLogText <> Default And IsString($sLogText) Then ; if enabled generate debug log message
		Local $String = $sLogText & $Result
		SetDebugLog($String, $LogTextColor, $bSilentSetLog)
	EndIf
	Return $Result
EndFunc   ;==>getCloudTextShort

Func getCloudFailShort($x_start, $y_start, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default)
	; Get 6 characters of pink text in center of attack search window during failed attack search (271, 381)
	; Full text length is 318 pixels, on checking for 1st 6 characters
	Local $Result = getOcrAndCapture("coc-cloudfail", $x_start, $y_start, 72, 24)
	If $g_bDebugSetlog And $sLogText <> Default And IsString($sLogText) Then ; if enabled generate debug log message
		Local $String = $sLogText & $Result
		SetDebugLog($String, $LogTextColor, $bSilentSetLog)
	EndIf
	Return $Result
EndFunc   ;==>getCloudFailShort

Func getBarracksNewTroopQuantity($x_start, $y_start, $bNeedCapture = True) ;  -> Gets quantity of troops in army Window
	Return getOcrAndCapture("coc-newarmy", $x_start, $y_start, 45, 18, True, False, $bNeedCapture)
EndFunc   ;==>getBarracksNewTroopQuantity

Func getArmyCapacityOnTrainTroops($x_start, $y_start) ;  -> Gets quantity of troops in army Window
	Return getOcrAndCapture("coc-NewCapacity", $x_start, $y_start, 67, 14, True)
EndFunc   ;==>getArmyCapacityOnTrainTroops

Func getQueueTroopsQuantity($x_start, $y_start) ;  -> Gets quantity of troops in Queue in Train Tab
	Return StringReplace(getOcrAndCapture("coc-qqtroop", $x_start, $y_start, 40, 13, True), "b", "")
EndFunc   ;==>getQueueTroopsQuantity

Func getQuickTroopsQuantity($x_start, $y_start) ;  -> Gets quantity of troops in Queue in Train Tab
	Return StringReplace(getOcrAndCapture("coc-qqtroop", $x_start, $y_start, 35, 13, True), "b", "")
EndFunc   ;==>getQueueTroopsQuantity

Func getChatStringChinese($x_start, $y_start) ; -> Get string chat request - Chinese - "DonateCC.au3"
	Local $bUseOcrImgLoc = True
	Return getOcrAndCapture("chinese-bundle", $x_start, $y_start, 160, 14, Default, $bUseOcrImgLoc)
EndFunc   ;==>getChatStringChinese

Func getChatStringKorean($x_start, $y_start) ; -> Get string chat request - Korean - "DonateCC.au3"
	Local $bUseOcrImgLoc = True
	Return getOcrAndCapture("korean-bundle", $x_start, $y_start, 160, 14, Default, $bUseOcrImgLoc)
EndFunc   ;==>getChatStringKorean

Func getChatStringPersian($x_start, $y_start, $bConvert = True) ; -> Get string chat request - Persian - "DonateCC.au3"
	Local $bUseOcrImgLoc = True
	Local $OCRString = getOcrAndCapture("persian-bundle", $x_start, $y_start, 240, 20, Default, $bUseOcrImgLoc, True)
	If $bConvert = True Then
		$OCRString = StringReverse($OCRString)
		$OCRString = StringReplace($OCRString, "A", "ا")
		$OCRString = StringReplace($OCRString, "B", "ب")
		$OCRString = StringReplace($OCRString, "C", "چ")
		$OCRString = StringReplace($OCRString, "D", "د")
		$OCRString = StringReplace($OCRString, "F", "ف")
		$OCRString = StringReplace($OCRString, "G", "گ")
		$OCRString = StringReplace($OCRString, "J", "ج")
		$OCRString = StringReplace($OCRString, "H", "ه")
		$OCRString = StringReplace($OCRString, "R", "ر")
		$OCRString = StringReplace($OCRString, "K", "ک")
		$OCRString = StringReplace($OCRString, "K", "ل")
		$OCRString = StringReplace($OCRString, "M", "م")
		$OCRString = StringReplace($OCRString, "N", "ن")
		$OCRString = StringReplace($OCRString, "P", "پ")
		$OCRString = StringReplace($OCRString, "S", "س")
		$OCRString = StringReplace($OCRString, "T", "ت")
		$OCRString = StringReplace($OCRString, "V", "و")
		$OCRString = StringReplace($OCRString, "Y", "ی")
		$OCRString = StringReplace($OCRString, "L", "ل")
		$OCRString = StringReplace($OCRString, "Z", "ز")
		$OCRString = StringReplace($OCRString, "X", "خ")
		$OCRString = StringReplace($OCRString, "Q", "ق")
		$OCRString = StringReplace($OCRString, ",", ",")
		$OCRString = StringReplace($OCRString, "0", " ")
		$OCRString = StringReplace($OCRString, "1", ".")
		$OCRString = StringReplace($OCRString, "22", "ع")
		$OCRString = StringReplace($OCRString, "44", "ش")
		$OCRString = StringReplace($OCRString, "55", "ح")
		$OCRString = StringReplace($OCRString, "66", "ض")
		$OCRString = StringReplace($OCRString, "77", "ط")
		$OCRString = StringReplace($OCRString, "88", "لا")
		$OCRString = StringReplace($OCRString, "99", "ث")
		$OCRString = StringStripWS($OCRString, 1 + 2)
	EndIf
	Return $OCRString
EndFunc   ;==>getChatStringPersian

Func OcrForceCaptureRegion($bForce = Default)
	If $bForce = Default Then Return $g_bOcrForceCaptureRegion
	Local $wasForce = $g_bOcrForceCaptureRegion
	$g_bOcrForceCaptureRegion = $bForce
	Return $wasForce
EndFunc   ;==>OcrForceCaptureRegion

Func getOcrAndCapture($language, $x_start, $y_start, $width, $height, $removeSpace = Default, $bImgLoc = Default, $bForceCaptureRegion = Default)
	If $removeSpace = Default Then $removeSpace = False
	If $bImgLoc = Default Then $bImgLoc = False
	If $bForceCaptureRegion = Default Then $bForceCaptureRegion = $g_bOcrForceCaptureRegion
	Static $_hHBitmap = 0
	If $bForceCaptureRegion = True Then
		_CaptureRegion2($x_start, $y_start, $x_start + $width, $y_start + $height)
	Else
		$_hHBitmap = GetHHBitmapArea($g_hHBitmap2, $x_start, $y_start, $x_start + $width, $y_start + $height)
	EndIf
	Local $Result
	If $bImgLoc Then
		If $_hHBitmap <> 0 Then
			$Result = getOcrImgLoc($_hHBitmap, $language)
		Else
			$Result = getOcrImgLoc($g_hHBitmap2, $language)
		EndIf
	Else
		If $_hHBitmap <> 0 Then
			$Result = getOcr($_hHBitmap, $language)
		Else
			$Result = getOcr($g_hHBitmap2, $language)
		EndIf
	EndIf
	If $_hHBitmap <> 0 Then
		GdiDeleteHBitmap($_hHBitmap)
	EndIf
	$_hHBitmap = 0
	If ($removeSpace) Then
		$Result = StringReplace($Result, " ", "")
	Else
		$Result = StringStripWS($Result, BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING, $STR_STRIPSPACES))
	EndIf
	Return $Result
EndFunc   ;==>getOcrAndCapture

Func getOcr(ByRef Const $_hHBitmap, $language)
	Local $Result = DllCallMyBot("ocr", "ptr", $_hHBitmap, "str", $language, "int", $g_bDebugOcr ? 1 : 0)
	If IsArray($Result) Then
		Return $Result[0]
	Else
		Return ""
	EndIf
EndFunc   ;==>getOcr

Func getOcrImgLoc(ByRef Const $_hHBitmap, $sLanguage)
	Local $Result = DllCallMyBot("DoOCR", "handle", $_hHBitmap, "str", $sLanguage)

	Local $error = @error ; Store error values as they reset at next function call
	Local $extError = @extended
	If $error Then
		_logErrorDLLCall($g_hLibMyBot, $error)
		SetDebugLog(" imgloc DLL Error : " & $error & " --- " & $extError)
		Return SetError(2, $extError, "") ; Set external error code = 2 for DLL error
	EndIf
	If $g_bDebugImageSave Then SaveDebugImage($sLanguage, False)

	If IsArray($Result) Then
		Return $Result[0]
	Else
		Return ""
	EndIf
EndFunc   ;==>getOcrImgLoc
