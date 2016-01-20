; #FUNCTION# ====================================================================================================================
; Name ..........: OCR
; Description ...: Gets complete value of gold/Elixir/DarkElixir/Trophy/Gem xxx,xxx
; Author ........: Didipe (2015)
; Modified ......: ProMac (2015), Hervidero (2015-12)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func getNameBuilding($x_start, $y_start); getNameBuilding(242,520) -> Gets complete name and level of the buildings - to use in future features
	Return getOcrAndCapture("coc-build", $x_start, $y_start, 377, 27)
EndFunc   ;==>getNameBuilding

Func getGoldVillageSearch($x_start, $y_start);48, 69 -> Gets complete value of gold xxx,xxx Getresources.au3
	Return getOcrAndCapture("coc-v-g", $x_start, $y_start, 90, 16, True)
EndFunc   ;==>getGoldVillageSearch

Func getElixirVillageSearch($x_start, $y_start) ;48, 69+29 -> Gets complete value of Elixir xxx,xxx Getresources.au3
	Return getOcrAndCapture("coc-v-e", $x_start, $y_start, 90, 16, True)
EndFunc   ;==>getElixirVillageSearch

Func getDarkElixirVillageSearch($x_start, $y_start) ;48, 69+57 or 69+69  -> Gets complete value of Dark Elixir xxx,xxx Getresources.au3
	Return getOcrAndCapture("coc-v-de", $x_start, $y_start, 75, 16, True)
EndFunc   ;==>getDarkElixirVillageSearch

Func getTrophyVillageSearch($x_start, $y_start) ;48, 69+99 or 69+69 -> Gets complete value of Trophies xxx,xxx Getresources.au3
	Return getOcrAndCapture("coc-v-t", $x_start, $y_start, 75, 16, True)
EndFunc   ;==>getTrophyVillageSearch

Func getTrophyMainScreen($x_start, $y_start) ; -> Gets complete value of Gold/Elixir/Dark Elixir/Trophies/Gems xxx,xxx "VillageReport.au3"
	Return getOcrAndCapture("coc-ms", $x_start, $y_start, 50, 16, True)
EndFunc   ;==>getTrophyMainScreen

Func getTrophyLossAttackScreen($x_start, $y_start) ; 48,214 or 48,184 WO/DE -> Gets complete value trophy loss from attack screen
	Return getOcrAndCapture("coc-t-p", $x_start, $y_start, 50, 16, True)
EndFunc   ;==>getTrophyLossAttackScreen

Func getUpgradeResource($x_start, $y_start) ; -> Gets complete value of Gold/Elixir xxx,xxx "UpgradeBuildings.au3" to use in future function
	Return getOcrAndCapture("coc-u-r", $x_start, $y_start, 98, 16, True)
EndFunc   ;==>getUpgradeResource

Func getResourcesMainScreen($x_start, $y_start) ; -> Gets complete value of Gold/Elixir/Dark Elixir/Trophies/Gems xxx,xxx "VillageReport.au3"
	Return getOcrAndCapture("coc-ms", $x_start, $y_start, 100, 16, True)
EndFunc   ;==>getResourcesMainScreen

Func getResourcesLoot($x_start, $y_start) ; -> Gets complete value of Gold/Elixir/Dark Elixir/Trophies xxx,xxx "AttackReport"
	Return getOcrAndCapture("coc-loot", $x_start, $y_start, 107, 22, True)
EndFunc   ;==>getResourcesLoot

Func getResourcesLootDE($x_start, $y_start) ; -> Gets complete value of Gold/Elixir/Dark Elixir/Trophies xxx,xxx "AttackReport"
	Return getOcrAndCapture("coc-loot", $x_start, $y_start, 75, 22, True)
EndFunc   ;==>getResourcesLootDE

Func getResourcesLootT($x_start, $y_start) ; -> Gets complete value of Gold/Elixir/Dark Elixir/Trophies xxx,xxx "AttackReport"
	Return getOcrAndCapture("coc-loot", $x_start, $y_start, 37, 22, True)
EndFunc   ;==>getResourcesLootT

Func getResourcesBonus($x_start, $y_start) ; -> Gets complete value of Gold/Elixir xxx,xxx "AttackReport.au3"
	Return getOcrAndCapture("coc-bonus", $x_start, $y_start, 98, 16, True)
EndFunc   ;==>getResourcesBonus

Func getResourcesBonusPerc($x_start, $y_start) ; -> Gets complete value of Bonus % "AttackReport.au3"
	Return getOcrAndCapture("coc-bonus", $x_start, $y_start, 48, 16, True)
EndFunc   ;==>getResourcesBonusPerc

Func getLabUpgrdResourceWht($x_start, $y_start) ; -> Gets complete value of Elixir/DE xxx,xxx for "laboratory.au3" when white text
	Return getOcrAndCapture("coc-lab-w", $x_start, $y_start, 60, 14, True)
EndFunc   ;==>getLabUpgrdResourceWht

Func getLabUpgrdResourceRed($x_start, $y_start) ; -> Gets complete value of Elixir/DE xxx,xxx for "laboratory.au3" when red text
	Return getOcrAndCapture("coc-lab-r", $x_start, $y_start, 60, 14, True)
EndFunc   ;==>getLabUpgrdResourceRed

Func getChatString($x_start, $y_start, $language) ; -> Get string chat request - Latin Alphabetic - EN "DonateCC.au3"
	Return getOcrAndCapture($language, $x_start, $y_start, 280, 18)
EndFunc   ;==>getChatString

Func getBuilders($x_start, $y_start);  -> Gets Builders number - main screen --> getBuilders(324,23)  coc-profile
	Local $sread_value = getOcrAndCapture("coc-Builders", $x_start, $y_start, 40, 18, True)
	If StringInStr($sread_value, "#") > 0 Then
		Return $sread_value
	Else
		SetLog("Cannot get Free/Total Builders", $COLOR_RED)
		Return ("0#0")
	EndIf
EndFunc   ;==>getBuilders

Func getProfile($x_start, $y_start);  -> Gets Attack Win/Defense Win/Donated/Received values - profile screen --> getProfile(160,268)  troops donation
	Return getOcrAndCapture("coc-profile", $x_start, $y_start, 46, 11, True)
EndFunc   ;==>getProfile

Func getTroopCountSmall($x_start, $y_start);  -> Gets troop amount on Attack Screen for non-selected troop kind
	Return getOcrAndCapture("coc-t-s", $x_start, $y_start, 53, 15, True)
EndFunc   ;==>getTroopCountSmall

Func getTroopCountBig($x_start, $y_start);  -> Gets troop amount on Attack Screen for selected troop kind
	Return getOcrAndCapture("coc-t-b", $x_start, $y_start, 53, 16, True)
EndFunc   ;==>getTroopCountBig

Func getArmyTroopQuantity($x_start, $y_start);  -> Gets troop amount on army camp or new windows
	Return getOcrAndCapture("coc-train-quant", $x_start, $y_start, 45, 12, True)
EndFunc   ;==>getArmyTroopQuantity

Func getArmyTroopKind($x_start, $y_start);  -> Gets kind of troop on army camp or new windows
	Return getOcrAndCapture("coc-train-t-kind", $x_start, $y_start, 59, 11, True)
EndFunc   ;==>getArmyTroopKind

Func getArmyCampCap($x_start, $y_start);  -> Gets army camp capacity --> train.au3
	Return getOcrAndCapture("coc-army", $x_start, $y_start, 66, 14, True)
EndFunc   ;==>getArmyCampCap

Func getCastleDonateCap($x_start, $y_start);  -> Gets army camp capacity --> train.au3
	Return getOcrAndCapture("coc-army", $x_start, $y_start, 30, 14, True)
EndFunc   ;==>getArmyCampCap

Func getBarracksTroopQuantity($x_start, $y_start);  -> Gets quantity of troops in training --> train.au3
	Return getOcrAndCapture("coc-train", $x_start, $y_start, 52, 16, True)
EndFunc   ;==>getBarracksTroopQuantity

Func getAttackDisable($x_start, $y_start);  -> 346, 182 - Gets red text disabled for early warning of Take-A-Break
	Return getOcrAndCapture("coc-dis", $x_start, $y_start, 118, 24, True)
EndFunc   ;==>getAttackDisable

Func getOcrLanguage($x_start, $y_start);  -> Get english language - main screen --> getLanguage(324,6)
	Return getOcrAndCapture("coc-ms-testl", $x_start, $y_start, 43, 11, True)
EndFunc   ;==>getOcrLanguage

Func getOcrSpellDetection($x_start, $y_start);  -> Recognition of the Spells in Armyoverview window
	Return getOcrAndCapture("coc-t-spells", $x_start, $y_start, 50, 30, True)
EndFunc   ;==>getOcrSpellDetection

Func getOcrSpellQuantity($x_start, $y_start);  -> Get the Spells quantity in Armyoverview window
	Return getOcrAndCapture("coc-t-t", $x_start, $y_start, 25, 12, True)
EndFunc   ;==>getOcrSpellQuantity

Func getOcrClanLevel($x_start, $y_start);  -> Get the Spells quantity in Armyoverview window
	Return getOcrAndCapture("coc-clanlevel", $x_start, $y_start, 20, 19, True)
EndFunc   ;==>getOcrClanLevel

Func getOcrSpaceCastleDonate($x_start, $y_start);  -> Get the space of castle request
	Return getOcrAndCapture("coc-totalreq", $x_start, $y_start, 40, 12, True)
EndFunc   ;==>getOcrSpaceCastleDonate

Func getOcrDonationTroopsDetection($x_start, $y_start);  -> Get the space of castle request
	Return getOcrAndCapture("coc-donationtroop", $x_start, $y_start, 30, 15, True)
EndFunc   ;==>getOcrDonationTroopsDetection

Func getOcrOverAllDamage($x_start, $y_start);  -> Get the Overall Damage %
	Return getOcrAndCapture("coc-overalldamage", $x_start, $y_start, 50, 20, True)
EndFunc   ;==>getOcrOverAllDamage

Func getOcrGuardShield($x_start, $y_start);  -> Get the Overall Damage %
	Return getOcrAndCapture("coc-guardshield", $x_start, $y_start, 68, 15)
EndFunc   ;==>getOcrGuardShield


Func getOcrAndCapture($language, $x_start, $y_start, $width, $height, $removeSpace = False)
	Local $hBmp = _CaptureRegion2($x_start, $y_start, $x_start + $width, $y_start + $height)
	Local $result = getOcr($hBmp, $language)
	If ($removeSpace) Then
		$result = StringReplace($result, " ", "")
	EndIf
	_WinAPI_DeleteObject($hBmp)
	Return $result
EndFunc   ;==>getOcrAndCapture

Func getOcr($hBitmap, $language)
	Local $result = DllCall($hFuncLib, "str", "ocr", "ptr", $hBitmap, "str", $language, "int", $debugOcr)
	If IsArray($result) Then
		Return $result[0]
	Else
		Return ""
	EndIf
EndFunc   ;==>getOcr
