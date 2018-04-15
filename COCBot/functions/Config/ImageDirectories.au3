; #Variables# ====================================================================================================================
; Name ..........: Image Search Directories
; Description ...: Gobal Strings holding Path to Images used for Image Search
; Syntax ........: $g_sImgxxx = @ScriptDir & "\imgxml\xxx\"
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_sImgImgLocButtons = @ScriptDir & "\imgxml\imglocbuttons"

#Region Obstacles
Global Const $g_sImgAnyoneThere = @ScriptDir & "\imgxml\other\AnyoneThere[[Android]]*"
Global Const $g_sImgPersonalBreak = @ScriptDir & "\imgxml\other\break*"
Global Const $g_sImgAnotherDevice = @ScriptDir & "\imgxml\other\Device[[Android]]*"
Global Const $g_sImgCocStopped = @ScriptDir & "\imgxml\other\CocStopped*"
Global Const $g_sImgCocReconnecting = @ScriptDir & "\imgxml\other\CocReconnecting*"
Global Const $g_sImgAppRateNever = @ScriptDir & "\imgxml\other\RateNever[[Android]]*"
Global Const $g_sImgGfxError = @ScriptDir & "\imgxml\other\GfxError*"
Global Const $g_sImgError = @ScriptDir & "\imgxml\other\Error[[Android]]*"
Global Const $g_sImgOutOfSync = @ScriptDir & "\imgxml\other\Oos[[Android]]*"
#EndRegion

#Region Main Village
Global $g_sImgCollectRessources = @ScriptDir & "\imgxml\Resources\Collect"
Global $g_sImgCollectLootCart = @ScriptDir & "\imgxml\Resources\LootCart\LootCart_0_85.xml"
Global $g_sImgRearm = @ScriptDir & "\imgxml\rearm\"
Global $g_sImgBoat = @ScriptDir & "\imgxml\Boat\BoatNormalVillage_0_89.xml"
Global $g_sImgZoomOutDir = @ScriptDir & "\imgxml\village\NormalVillage\"
Global $g_sImgCheckWallDir = @ScriptDir & "\imgxml\Walls"
Global $g_sImgClearTombs = @ScriptDir & "\imgxml\Resources\Tombs"
Global $g_sImgCleanYard = @ScriptDir & "\imgxml\Resources\Obstacles"
Global $g_sImgCleanYardSnow = @ScriptDir & "\imgxml\Obstacles_Snow"
Global $g_sImgGemBox = @ScriptDir & "\imgxml\Resources\GemBox"
Global $g_sImgCollectReward = @ScriptDir & "\imgxml\Resources\ClaimReward"
Global $g_sImgTrader = @ScriptDir & "\imgxml\FreeMagicItems\TraderIcon"
Global $g_sImgDailyDiscountWindow = @ScriptDir & "\imgxml\FreeMagicItems\DailyDiscount"
Global $g_sImgBuyDealWindow = @ScriptDir & "\imgxml\FreeMagicItems\BuyDeal"
#EndRegion

#Region Builder Base
Global $g_sImgCollectRessourcesBB = @ScriptDir & "\imgxml\Resources\BuildersBase\Collect"
Global $g_sImgBoatBB = @ScriptDir & "\imgxml\Boat\BoatBuilderBase_0_89.xml"
Global $g_sImgZoomOutDirBB = @ScriptDir & "\imgxml\village\BuilderBase\"
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
Global $g_sImgArmyOverviewSpells = @ScriptDir & "\imgxml\ArmyOverview\Spells" ; @ScriptDir & "\imgxml\ArmySpells"
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

#Region SwitchAcc
Global Const $g_sImgLoginWithSupercellID = @ScriptDir & "\imgxml\other\LoginWithSupercellID*"
Global Const $g_sImgGoogleSelectAccount = @ScriptDir & "\imgxml\other\GoogleSelectAccount*"
Global Const $g_sImgGoogleSelectEmail = @ScriptDir & "\imgxml\other\GoogleSelectEmail*"
#EndRegion

#Region ClanGames
Global Const $g_sImgCaravan =		@ScriptDir & "\imgxml\Resources\Clan Games Images\MainLoop\Caravan"
Global Const $g_sImgStart = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\MainLoop\Start"
Global Const $g_sImgPurge = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\MainLoop\Purge"
Global Const $g_sImgCoolPurge = 	@ScriptDir & "\imgxml\Resources\Clan Games Images\MainLoop\Gem"
Global Const $g_sImgTrashPurge = 	@ScriptDir & "\imgxml\Resources\Clan Games Images\MainLoop\Trash"
Global Const $g_sImgOkayPurge = 	@ScriptDir & "\imgxml\Resources\Clan Games Images\MainLoop\Okay"
Global Const $g_sImgReward = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\MainLoop\Reward"
Global Const $g_sImageBuilerGames = @ScriptDir & "\imgxml\Resources\Clan Games Images\MainLoop\BuilderGames"

Global Const $g_sImgGold = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Loot Challenges\Gold Challenge"
Global Const $g_sImgElixir = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Loot Challenges\Elixir Challenge"
Global Const $g_sImgDark = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Loot Challenges\Dark Elixir Challenge\"
Global Const $g_sImgGoldG = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Loot Challenges\Gold Grab"
Global Const $g_sImgElixirE = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Loot Challenges\Elixir Embezzlement"
Global Const $g_sImgDarkEH = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Loot Challenges\Dark Elixir Heist"

Global Const $g_sImgStar = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Battle Challenges\Star Collector"
Global Const $g_sImgLordD =			@ScriptDir & "\imgxml\Resources\Clan Games Images\Battle Challenges\Lord of Destruction"
Global Const $g_sImgPileVict =		@ScriptDir & "\imgxml\Resources\Clan Games Images\Battle Challenges\Pile Of Victories"		; = as Winning Streak	[\Confirm_WinningStreak]
Global Const $g_sImgHunt3 =			@ScriptDir & "\imgxml\Resources\Clan Games Images\Battle Challenges\Hunt for Three Stars"
Global Const $g_sImgWStreak =		@ScriptDir & "\imgxml\Resources\Clan Games Images\Battle Challenges\Winning Streak"  		; = as Pile Of Victories[\Confirm_WinningStreak]
Global Const $g_sImgWStreakC =		@ScriptDir & "\imgxml\Resources\Clan Games Images\Battle Challenges\Confirm_WinningStreak"  ; CONFIRM , Windows Title after click
Global Const $g_sImgSlayingT =		@ScriptDir & "\imgxml\Resources\Clan Games Images\Battle Challenges\Slaying The Titans"
Global Const $g_sImgNoMagicZone =	@ScriptDir & "\imgxml\Resources\Clan Games Images\Battle Challenges\No-Magic Zone"
Global Const $g_sImgNoHeroics =		@ScriptDir & "\imgxml\Resources\Clan Games Images\Battle Challenges\No Heroics Allowed"
Global Const $g_sImgAttUp 	=		@ScriptDir & "\imgxml\Resources\Clan Games Images\Battle Challenges\Attack Up"

Global Const $g_sImgCannon = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Cannon Carnage"
Global Const $g_sImgArcherT = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Archer Tower Assault"
Global Const $g_sImgMortar = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Mortar Mauling"
Global Const $g_sImgAirDef = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Destroy Air Defenses"
Global Const $g_sImgWizard = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Wizard Tower Warfare" ; 2 Images for regular Theme and Winter Theme
Global Const $g_sImgAirS = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Destroy Air Sweepers"
Global Const $g_sImgTesla = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Destroy Tesla Towers"
Global Const $g_sImgBombT = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Destroy Bomb Towers"
Global Const $g_sImgXBow = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Destroy X-Bows"
Global Const $g_sImgInferno = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Destroy Inferno Towers"
Global Const $g_sImgEagle = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Eagle Artillery Elimination"
Global Const $g_sImgCCC = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Clan Castle Charge"
Global Const $g_sImgGoldRaid = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Gold Storage Raid"
Global Const $g_sImgElixirR = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Elixir Storage Raid"
Global Const $g_sImgDESRaid = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Dark Elixir Storage Raid"
Global Const $g_sImgGoldMM = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Gold Mine Mayhem"
Global Const $g_sImgElixirPE = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Elixir Pump Elimination"
Global Const $g_sImgDarkEP = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Dark Elixir Plumbers"
Global Const $g_sImgLab = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Laboratory Strike"
Global Const $g_sImgSFact = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Spell Factory Sabotage"   ; NEEDS A PICTURE
Global Const $g_sImgDSFact = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Dark Spell Factory Sabotage"
Global Const $g_sImgBBAltar = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Destroy Barbarian King Altars"
Global Const $g_sImgAQAltar = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Destroy Archer Queen Altars"
Global Const $g_sImgGWAltar = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Destroy Grand Warden Altars"
Global Const $g_sImgHeroHunt =		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Hero Level Hunter"
Global Const $g_sImgKingHunt =		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\King Level Hunter"
Global Const $g_sImgQueenHunt =		@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Queen Level Hunter"
Global Const $g_sImgWardenHunt =	@ScriptDir & "\imgxml\Resources\Clan Games Images\Destruction Challenges\Warden Level Hunter"

Global Const $g_sImgValk = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Valk"
Global Const $g_sImgArch = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Arch"
Global Const $g_sImgBarb = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Barb"
Global Const $g_sImgBowl = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Bowl"
Global Const $g_sImgGiant = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Giant"
Global Const $g_sImgGobl = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Gobl"
Global Const $g_sImgGole = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Gole"
Global Const $g_sImgHeal = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Heal"
Global Const $g_sImgHogs = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Hogs"
Global Const $g_sImgMine = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Mine"
Global Const $g_sImgPekka = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Pekka"
Global Const $g_sImgWall = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Wall"
Global Const $g_sImgWitch = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Witch"
Global Const $g_sImgWiza = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Ground Troop Challenges\Wiza"

Global Const $g_sImgBabyD = 		@ScriptDir & "\imgxml\Resources\Clan Games Images\Air Troop Challenges\BabyD"
Global Const $g_sImgBall = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Air Troop Challenges\Ball"
Global Const $g_sImgDrag = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Air Troop Challenges\Drag"
Global Const $g_sImgLava = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Air Troop Challenges\Lava"
Global Const $g_sImgMini = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Air Troop Challenges\Mini"

Global Const $g_sImgGard = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Miscellaneous Challenges\Gardening Exercise"
Global Const $g_sImgDonS = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Miscellaneous Challenges\Donate Spells"
Global Const $g_sImgDonH = 			@ScriptDir & "\imgxml\Resources\Clan Games Images\Miscellaneous Challenges\Helping Hand"


#EndRegion