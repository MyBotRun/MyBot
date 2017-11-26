; #Variables# ====================================================================================================================
; Name ..........: Image Search Directories
; Description ...: Gobal Strings holding Path to Images used for Image Search
; Syntax ........: $g_sImgxxx = @ScriptDir & "\imgxml\xxx\"
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_sImgImgLocButtons = @ScriptDir & "\imgxml\imglocbuttons"

#Region Obstacles
Global Const $g_sImgPersonalBreak = @ScriptDir & "\imgxml\other\break*"
Global Const $g_sImgAnotherDevice = @ScriptDir & "\imgxml\other\device*"
Global Const $g_sImgCocStopped = @ScriptDir & "\imgxml\other\CocStopped*"
Global Const $g_sImgCocReconnecting = @ScriptDir & "\imgxml\other\CocReconnecting*"
Global Const $g_sImgAppRateNever = @ScriptDir & "\imgxml\other\RateNever*"
Global Const $g_sImgGfxError = @ScriptDir & "\imgxml\other\GfxError*"
; Lollipop images
Global Const $g_sImgAnotherDeviceLollipop = @ScriptDir & "\imgxml\other\LollipopDevice*"
Global Const $g_sImgErrorLollipop = @ScriptDir & "\imgxml\other\LollipopError*"
Global Const $g_sImgOutOfSyncLollipop = @ScriptDir & "\imgxml\other\LollipopOos*"
Global Const $g_sImgAppRateNeverLollipop = @ScriptDir & "\imgxml\other\LollipopRateNever*"
#EndRegion

#Region Main Village
Global $g_sImgCollectRessources = @ScriptDir & "\imgxml\Resources\Collect"
Global $g_sImgCollectLootCart = @ScriptDir & "\imgxml\Resources\LootCart\LootCart_0_85.xml"
Global $g_sImgRearm = @ScriptDir & "\imgxml\rearm\"
Global $g_sImgBoat = @ScriptDir & "\imgxml\Boat\BoatNormalVillage_0_89.xml"
Global $g_sImgZoomOutDir = @ScriptDir & "\imgxml\village\NormalVillage"
Global $g_sImgCheckWallDir = @ScriptDir & "\imgxml\Walls"
Global $g_sImgClearTombs = @ScriptDir & "\imgxml\Resources\Tombs"
Global $g_sImgCleanYard = @ScriptDir & "\imgxml\Resources\Obstacles"
Global $g_sImgCleanYardSnow = @ScriptDir & "\imgxml\Obstacles_Snow"
Global $g_sImgGemBox = @ScriptDir & "\imgxml\Resources\GemBox"
#EndRegion

#Region Builder Base
Global $g_sImgCollectRessources = @ScriptDir & "\imgxml\Resources\BuildersBase\Collect"
Global $g_sImgBoatBB = @ScriptDir & "\imgxml\Boat\BoatBuilderBase_0_89.xml"
Global $g_sImgZoomOutDirBB = @ScriptDir & "\imgxml\village\BuilderBase"
Global $g_sImgStartCTBoost = @ScriptDir & "\imgxml\Resources\BuildersBase\ClockTower\ClockTowerAvailable*.xml"
#EndRegion

#Region DonateCC
Global $g_sImgDonateTroops = @ScriptDir & "\imgxml\DonateCC\Troops\"
Global $g_sImgDonateSpells = @ScriptDir & "\imgxml\DonateCC\Spells\"
Global $g_sImgChatDivider = @ScriptDir & "\imgxml\DonateCC\donateccwbl\chatdivider_0_98.xml"
Global $g_sImgChatDividerHidden = @ScriptDir & "\imgxml\DonateCC\donateccwbl\chatdividerhidden_0_98.xml"
#EndRegion

#Region Auto Upgrade Normal Village
 Global $g_sImgAUpgradeObst = @ScriptDir & "\imgxml\Resources\Auto Upgrade\Obstacles"
 Global $g_sImgAUpgradeZero = @ScriptDir & "\imgxml\Resources\Auto Upgrade\Zero"
 Global $g_sImgAUpgradeUpgradeBtn = @ScriptDir & "\imgxml\Resources\Auto Upgrade\UpgradeButton"
 Global $g_sImgAUpgradeRes = @ScriptDir & "\imgxml\Resources\Auto Upgrade\Resources"
#EndRegion

#Region Auto Upgrade Builder Base
Global $g_sImgAutoUpgradeGold = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\Gold"
Global $g_sImgAutoUpgradeElixir = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\Elixir"
Global $g_sImgAutoUpgradeWindow = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\Window"
Global $g_sImgAutoUpgradeNew = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\New"
Global $g_sImgAutoUpgradeNoRes = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\NoResources"
Global $g_sImgAutoUpgradeBtnElixir = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\ButtonUpg\Elixir"
Global $g_sImgAutoUpgradeBtnGold = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\ButtonUpg\Gold"
Global $g_sImgAutoUpgradeBtnDir = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\Upgrade"
Global $g_sImgAutoUpgradeZero = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\NewBuildings\Shop"
Global $g_sImgAutoUpgradeClock = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\NewBuildings\Clock"
Global $g_sImgAutoUpgradeInfo = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\NewBuildings\Slot"
Global $g_sImgAutoUpgradeNewBldgYes = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\NewBuildings\Yes"
Global $g_sImgAutoUpgradeNewBldgNo = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\NewBuildings\No"
#EndRegion

#Region Train
Global $g_sImgTrainTroops = @ScriptDir & "\imgxml\Train\Train_Train\"
Global $g_sImgTrainSpells = @ScriptDir & "\imgxml\Train\Spell_Train\"
#EndRegion

#Region Attack
Global $g_sImgAttackBarDir = @ScriptDir & "\imgxml\AttackBar"
#EndRegion

#Region Search
Global $g_sImgElixirStorage = @ScriptDir & "\imgxml\deadbase\elix\storage\"
Global $g_sImgElixirCollectorFill = @ScriptDir & "\imgxml\deadbase\elix\fill\"
Global $g_sImgElixirCollectorLvl = @ScriptDir & "\imgxml\deadbase\elix\lvl\"
Global $g_sImgWeakBaseBuildingsDir = @ScriptDir & "\imgxml\Buildings"
Global $g_sImgWeakBaseBuildingsEagleDir = @ScriptDir & "\imgxml\Buildings\Eagle"
Global $g_sImgWeakBaseBuildingsInfernoDir = @ScriptDir & "\imgxml\Buildings\Infernos"
Global $g_sImgWeakBaseBuildingsXbowDir = @ScriptDir & "\imgxml\Buildings\Xbow"
Global $g_sImgWeakBaseBuildingsWizTowerSnowDir = @ScriptDir & "\imgxml\Buildings\WTower_Snow"
Global $g_sImgWeakBaseBuildingsWizTowerDir = @ScriptDir & "\imgxml\Buildings\WTower"
Global $g_sImgWeakBaseBuildingsMortarsDir = @ScriptDir & "\imgxml\Buildings\Mortars"
Global $g_sImgWeakBaseBuildingsAirDefenseDir = @ScriptDir & "\imgxml\Buildings\ADefense"
Global $g_sImgSearchDrill = @ScriptDir & "\imgxml\Storages\Drills"
Global $g_sImgSearchDrillLevel = @ScriptDir & "\imgxml\Storages\Drills\Level"
Global $g_sImgEasyBuildings = @ScriptDir & "\imgxml\easybuildings"
#EndRegion