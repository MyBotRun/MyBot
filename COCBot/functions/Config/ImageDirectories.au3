; #Variables# ====================================================================================================================
; Name ..........: Image Search Directories
; Description ...: Gobal Strings holding Path to Images used for Image Search
; Syntax ........: $g_sImgxxx = @ScriptDir & "\imgxml\xxx\"
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_sImgImgLocButtons = @ScriptDir & "\imgxml\imglocbuttons"

#Region Windows
Global Const $g_sImgGeneralCloseButton = @ScriptDir & "\imgxml\Windows\CloseButton\"
#EndRegion Windows

#Region Obstacles
Global Const $g_sImgChatTabPixel = @ScriptDir & "\imgxml\other\ChatTabPixel*"
Global Const $g_sImgCocStopped = @ScriptDir & "\imgxml\other\CocStopped*"
Global Const $g_sImgCocReconnecting = @ScriptDir & "\imgxml\other\CocReconnecting*"
Global Const $g_sImgGfxError = @ScriptDir & "\imgxml\other\GfxError*"
Global Const $g_sImgMaintenance = @ScriptDir & "\imgxml\other\Maintenance*"
Global Const $g_sImgError = @ScriptDir & "\imgxml\CheckObstacles\Error*"
Global Const $sImgConnectionLost = @ScriptDir & "\imgxml\CheckObstacles\ConnectionLost*"
Global Const $sImgOos = @ScriptDir & "\imgxml\CheckObstacles\Oos*"
Global Const $sImgRateGame = @ScriptDir & "\imgxml\CheckObstacles\RateGame*"
Global Const $sImgNotice = @ScriptDir & "\imgxml\CheckObstacles\Notice*"
Global Const $sImgGPServices = @ScriptDir & "\imgxml\CheckObstacles\GPServices*"
Global Const $sImgDevice = @ScriptDir & "\imgxml\CheckObstacles\device*"
Global Const $sImgReloadBtn = @ScriptDir & "\imgxml\CheckObstacles\reloadbtn*"
Global Const $sImgNeverBtn = @ScriptDir & "\imgxml\CheckObstacles\NeverBtn*"
Global Const $sImgOKBtn = @ScriptDir & "\imgxml\CheckObstacles\OKBtn*"
Global Const $sImgClashOfMagicAdvert = @ScriptDir & "\imgxml\CheckObstacles\ClashOfMagicAdvert*"
Global Const $sImgClashNotResponding = @ScriptDir & "\imgxml\CheckObstacles\NotResp*"
Global Const $g_sImgCOCUpdate = @ScriptDir & "\imgxml\CheckObstacles\COCUpdate*"
Global Const $g_sImgClanCapitalResults = @ScriptDir & "\imgxml\other\CCResults*"
#EndRegion Obstacles

#Region Main Village
Global $sImgIsOnMainVillage = @ScriptDir & "\imgxml\village\Page\MainVillage\"
Global $g_sImgCollectRessources = @ScriptDir & "\imgxml\Resources\Collect"
Global $g_sImgCollectLootCart = @ScriptDir & "\imgxml\Resources\LootCart*"
Global $g_sImgGobBuilder = @ScriptDir & "\imgxml\village\Page\MainVillage\GobBuilder*"
Global $g_sImgBoat = @ScriptDir & "\imgxml\Boat\NormalVillage\"
Global $g_sImgZoomOutDir = @ScriptDir & "\imgxml\village\NormalVillage\"
Global $g_sImgCheckWallDir = @ScriptDir & "\imgxml\Walls"
Global $g_sImgClearTombs = @ScriptDir & "\imgxml\Resources\Tombs"
Global $g_sImgCleanYard = @ScriptDir & "\imgxml\Resources\Obstacles"
Global $g_sImgCleanYardSnow = @ScriptDir & "\imgxml\Obstacles_Snow"
Global $g_sImgGemBox = @ScriptDir & "\imgxml\Resources\GemBox"
Global $g_sImgAchievementsMainScreen = @ScriptDir & "\imgxml\AchievementRewards\MainScreen*"
Global $g_sImgAchievementsMyProfile = @ScriptDir & "\imgxml\AchievementRewards\MyProfile*"
Global $g_sImgAchievementsClaimReward = @ScriptDir & "\imgxml\AchievementRewards\ClaimButton"
Global $g_sImgAchievementsScrollEnd = @ScriptDir & "\imgxml\AchievementRewards\ScrollEnd*"
Global $g_sImgCollectReward = @ScriptDir & "\imgxml\Resources\ClaimReward"
Global $g_sImgGreenButton = @ScriptDir & "\imgxml\DailyChallenge\Button\"
Global $g_sImgTrader = @ScriptDir & "\imgxml\FreeMagicItems\TraderIcon"
Global $g_sImgDailyDiscountWindow = @ScriptDir & "\imgxml\FreeMagicItems\DailyDiscounts*"
Global $g_sImgBuyDealWindow = @ScriptDir & "\imgxml\FreeMagicItems\BuyDeal"
Global Const $g_sImgUpgradeWhiteZero = @ScriptDir & "\imgxml\Main Village\Upgrade\WhiteZero*"
Global Const $g_sImgDonateCC = @ScriptDir & "\imgxml\DonateCC\"
Global Const $g_sImgLabResearch = @ScriptDir & "\imgxml\Research\Laboratory\"
Global $g_sImgElixirDrop = @ScriptDir & "\imgxml\Research\Laboratory\ElixirDrop\"
Global $g_sImgHeroEquipement = @ScriptDir & "\imgxml\Research\Blacksmith\"
Global $g_sImgEquipmentResearch = @ScriptDir & "\imgxml\Research\Blacksmith\Equipment\"
Global $g_sImgEquipmentNew = @ScriptDir & "\imgxml\Research\Blacksmith\New\New*"
Global $g_sImgRedZero = @ScriptDir & "\imgxml\Research\Blacksmith\RedZero\RedZero*"
#EndRegion Main Village

#Region Clan Capital
Global $g_sImgCCMap = @ScriptDir & "\imgxml\Resources\ClanCapital\CCMap\"
Global $g_sImgCCMapName = @ScriptDir & "\imgxml\Resources\ClanCapital\CapitalMap\"
Global $g_sImgCCMenuTriangle = @ScriptDir & "\imgxml\Resources\ClanCapital\CCMap\MenuTriangle\"
Global $g_sImgAirShip = @ScriptDir & "\imgxml\Resources\ClanCapital\CCMap\AirShip\"
Global $g_sImgLock = @ScriptDir & "\imgxml\Resources\ClanCapital\CCMap\Lock\"
Global $g_sImgCCGoldCollect = @ScriptDir & "\imgxml\Resources\ClanCapital\CCMap\CCGold\Collect\"
Global $g_sImgCCGoldCraft = @ScriptDir & "\imgxml\Resources\ClanCapital\CCMap\CCGold\Craft\"
Global $g_sImgActiveForge = @ScriptDir & "\imgxml\Resources\ClanCapital\CCMap\CCGold\ActiveForge\"
Global $g_sImgForgeHouse = @ScriptDir & "\imgxml\Resources\ClanCapital\ForgeHouse\"
Global $g_sImgResourceCC = @ScriptDir & "\imgxml\Resources\ClanCapital\CCMap\BuilderMenu\"
Global $g_sImgCCUpgradeButton = @ScriptDir & "\imgxml\Resources\ClanCapital\CCMap\UpgradeButton\"
Global $g_sImgCCRaid = @ScriptDir & "\imgxml\Resources\ClanCapital\CCMap\Raid\"
Global $g_sImgPrioritizeCC = @ScriptDir & "\imgxml\Resources\ClanCapital\CCMap\BuilderMenu\Prioritize\"
Global $g_sImgDecoration = @ScriptDir & "\imgxml\Resources\ClanCapital\CCMap\BuilderMenu\Decoration\"
#EndRegion Clan Capital

#Region Boost Super Troops
Global $g_sImgBoostTroopsBarrel = @ScriptDir & "\imgxml\SuperTroops\Barrel\"
Global $g_sImgBarrelStopped = @ScriptDir & "\imgxml\SuperTroops\Stopped\"
Global $g_sImgBoostTroopsWindow = @ScriptDir & "\imgxml\SuperTroops\Window\"
Global $g_sImgBoostTroopsIcons = @ScriptDir & "\imgxml\SuperTroops\Troops\"
Global $g_sImgBoostTroopsButtons = @ScriptDir & "\imgxml\SuperTroops\Buttons\"
Global $g_sImgBoostTroopsPotion = @ScriptDir & "\imgxml\SuperTroops\Potions\"
Global $g_sImgBoostTroopsClock = @ScriptDir & "\imgxml\SuperTroops\Clock\"
#EndRegion Boost Super Troops


#Region Builder Base
Global $g_sImgCollectRessourcesBB = @ScriptDir & "\imgxml\Resources\BuildersBase\Collect"
;Global $g_sImgBoatBB = @ScriptDir & "\imgxml\Boat\BoatBuilderBase_0_89.xml"
Global $g_sImgBoatBB = @ScriptDir & "\imgxml\Boat\BuilderBase\"
Global $g_sImgStartCTBoost = @ScriptDir & "\imgxml\Resources\BuildersBase\ClockTower\ClockTowerAvailable*.xml"
Global $g_sImgCleanBBYard = @ScriptDir & "\imgxml\Resources\ObstaclesBB"
Global $g_sImgIsOnBB = @ScriptDir & "\imgxml\village\Page\BuilderBase\"
Global Const $g_sImgMasterBuilderHead = @ScriptDir & "\imgxml\village\Page\BuilderBase\BuilderEye*"
Global $sImgIsOnBuilderBaseEnemyVillage = @ScriptDir & "\imgxml\village\Page\BuilderBaseEnemyVillage\"
Global $g_sImgStarLaboratory = @ScriptDir & "\imgxml\Resources\BuildersBase\StarLaboratory"
Global $g_sImgStarLabElex = @ScriptDir & "\imgxml\Resources\BuildersBase\StarLabElex\StarLabElex*"
Global $g_sImgBBMachReady = @ScriptDir & "\imgxml\Attack\BuilderBase\PrepareAttackBB\BattleMachine"
Global $g_sImgDirBBTroops = @ScriptDir & "\imgxml\Attack\BuilderBase\AttackBB\AttackBar\"
Global $g_sImgBBAttackButton = @ScriptDir & "\imgxml\Attack\BuilderBase\AttackButton\*"
Global $g_sImgElixirCart = @ScriptDir & "\imgxml\Resources\BuildersBase\ElixirCart\ElixCart*"
Global $g_sImgCollectElixirCart = @ScriptDir & "\imgxml\Resources\BuildersBase\ElixirCart\Collect*"
Global $g_sImgFillTrain = @ScriptDir & "\imgxml\Attack\BuilderBase\PrepareAttackBB\TrainTroop\"
Global $g_sImgFillCamp = @ScriptDir & "\imgxml\Attack\BuilderBase\PrepareAttackBB\TrainTroop\Camp\"
Global $sImgTunnel = @ScriptDir & "\imgxml\Resources\BuildersBase\Tunnel\"
; Builder Base Attack
Global $g_sImgBBAttackStart = @ScriptDir & "\imgxml\Attack\BuilderBase\AttackBB\AttackStart\"
Global $g_sImgBBAttackBonus = @ScriptDir & "\imgxml\Attack\BuilderBase\AttackBB\AttackBonus\"
Global $g_sImgBBReturnHome = @ScriptDir & "\imgxml\Attack\BuilderBase\AttackBB\ReturnHome\"
Global $g_sImgBBBattleMachine = @ScriptDir & "\imgxml\Attack\BuilderBase\AttackBB\AttackBar\Machine\"
Global $g_sImgDirMachineAbility = @ScriptDir & "\imgxml\Attack\BuilderBase\AttackBB\AttackBar\MachineAbility\"
Global $g_sImgDirBomberAbility = @ScriptDir & "\imgxml\Attack\BuilderBase\AttackBB\AttackBar\BomberAbility\"
#EndRegion Builder Base

#Region DonateCC
Global $g_sImgDonateTroops = @ScriptDir & "\imgxml\DonateCC\Troops\"
Global $g_sImgDonateSpells = @ScriptDir & "\imgxml\DonateCC\Spells\"
Global $g_sImgDonateSiege = @ScriptDir & "\imgxml\DonateCC\SiegeMachines\"
Global $g_sImgChatDivider = @ScriptDir & "\imgxml\DonateCC\donateccwbl\chatdivider_0_98.xml"
Global $g_sImgChatDividerHidden = @ScriptDir & "\imgxml\DonateCC\donateccwbl\chatdividerhidden_0_98.xml"
Global $g_sImgChatDividerWhite = @ScriptDir & "\imgxml\DonateCC\donateccwbl\chatdividerwhite_0_98.xml"
Global $g_sImgChatIUnterstand = @ScriptDir & "\imgxml\DonateCC\donateccwbl\iunderstand_0_95.xml"
#EndRegion DonateCC

#Region Auto Upgrade Normal Village
Global $g_sImgAUpgradeObst = @ScriptDir & "\imgxml\Resources\Auto Upgrade\Obstacles"
Global $g_sImgAUpgradeZero = @ScriptDir & "\imgxml\Resources\Auto Upgrade\Zero"
Global $g_sImgAUpgradeRes = @ScriptDir & "\imgxml\Resources\Auto Upgrade\Resources"
Global $g_sImgAUpgradeEndBoost = @ScriptDir & "\imgxml\Resources\Auto Upgrade\EndBoost\EndBoost*"
Global $g_sImgAUpgradeEndBoostOKBtn = @ScriptDir & "\imgxml\Resources\Auto Upgrade\EndBoost\EndBoostOKBtn*"
Global $g_sImgResourceIcon = @ScriptDir & "\imgxml\Resources\Auto Upgrade\ResourceIcon\"
Global $g_sImgWallResource = @ScriptDir & "\imgxml\Resources\Auto Upgrade\UpgradeWalls\"
Global $g_sImgUpgradeBtn2Wall = @ScriptDir & "\imgxml\imglocbuttons\Upgrade*"
#EndRegion Auto Upgrade Normal Village

#Region Auto Upgrade Builder Base
Global $g_sImgAutoUpgradeBB = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\Resources"
Global $g_sImgAutoUpgradeNew = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\New"
Global $g_sImgAutoUpgradeNoRes = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\NoResources"
Global $g_sImgAutoUpgradeBtnDir = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\Upgrade"
Global $g_sImgAutoUpgradeZero = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\NewBuildings\Shop"
Global $g_sImgAutoUpgradeClock = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\NewBuildings\Clock"
Global $g_sImgAutoUpgradeInfo = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\NewBuildings\Slot"
Global $g_sImgAutoUpgradeNewBldgYes = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\NewBuildings\Yes"
Global $g_sImgAutoUpgradeNewBldgNo = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\NewBuildings\No"
#EndRegion Auto Upgrade Builder Base

#Region Train
Global $g_sImgTrainTroops = @ScriptDir & "\imgxml\Train\Train_Train\"
Global $g_sImgTrainSpells = @ScriptDir & "\imgxml\Train\Spell_Train\"
Global $g_sImgArmyOverviewSpells = @ScriptDir & "\imgxml\ArmyOverview\Spells" ; @ScriptDir & "\imgxml\ArmySpells"
Global $g_sImgRequestCCButton = @ScriptDir & "\imgxml\ArmyOverview\RequestCC"
Global $g_sImgSendRequestButton = @ScriptDir & "\imgxml\ArmyOverview\RequestCC\SendRequest\SendButton*"
Global $g_sImgArmyOverviewHeroes = @ScriptDir & "\imgxml\ArmyOverview\Heroes"
Global $g_sImgQuickTrain = @ScriptDir & "\imgxml\Train\Quick_Train\*"
Global $g_sImgEditQuickTrain = @ScriptDir & "\imgxml\Train\EditQuickTrain\"
#EndRegion Train

#Region Attack
Global $g_sImgAttackBarDir = @ScriptDir & "\imgxml\AttackBar"
Global $g_sImgSwitchSiegeMachine = @ScriptDir & "\imgxml\SwitchSiegeMachines\"
Global $g_sImgSwitchWardenMode = @ScriptDir & "\imgxml\SwitchWardenMode"
Global $g_sImgIsMultiplayerTab = @ScriptDir & "\imgxml\Attack\Search\MultiplayerTab*"
Global $g_sImgQueenBar = @ScriptDir & "\imgxml\AttackBar\Queen*"
Global $g_sImgKingBar = @ScriptDir & "\imgxml\AttackBar\King*"
Global $g_sImgWardenBar = @ScriptDir & "\imgxml\AttackBar\Warden*"
Global $g_sImgChampionBar = @ScriptDir & "\imgxml\AttackBar\Champion*"
#EndRegion Attack

#Region Search
Global $g_sImgElixirStorage = @ScriptDir & "\imgxml\deadbase\elix\storage\"
Global $g_sImgElixirCollectorFill = @ScriptDir & "\imgxml\deadbase\elix\fill\"
Global $g_sImgElixirCollectorLvl = @ScriptDir & "\imgxml\deadbase\elix\lvl\"
Global $g_sImgWeakBaseBuildingsDir = @ScriptDir & "\imgxml\Buildings"
Global $g_sImgWeakBaseBuildingsEagleDir = @ScriptDir & "\imgxml\Buildings\Eagle"
Global $g_sImgWeakBaseBuildingsScatterDir = @ScriptDir & "\imgxml\Buildings\ScatterShot"
Global $g_sImgWeakBaseBuildingsMonolithDir = @ScriptDir & "\imgxml\Buildings\Monolith"
Global $g_sImgWeakBaseBuildingsInfernoDir = @ScriptDir & "\imgxml\Buildings\Infernos"
Global $g_sImgWeakBaseBuildingsXbowDir = @ScriptDir & "\imgxml\Buildings\Xbow"
Global $g_sImgWeakBaseBuildingsWizTowerSnowDir = @ScriptDir & "\imgxml\Buildings\WTower_Snow"
Global $g_sImgWeakBaseBuildingsWizTowerDir = @ScriptDir & "\imgxml\Buildings\WTower"
Global $g_sImgWeakBaseBuildingsMortarsDir = @ScriptDir & "\imgxml\Buildings\Mortars"
Global $g_sImgWeakBaseBuildingsAirDefenseDir = @ScriptDir & "\imgxml\Buildings\ADefense"
Global $g_sImgSearchDrill = @ScriptDir & "\imgxml\Storages\Drills"
Global $g_sImgSearchDrillLevel = @ScriptDir & "\imgxml\Storages\Drills\Level"
Global $g_sImgEasyBuildings = @ScriptDir & "\imgxml\easybuildings"
Global $g_sImgPrepareLegendLeagueSearch = @ScriptDir & "\imgxml\Attack\Search\LegendLeague"
Global $g_sImgRetrySearchButton = @ScriptDir & "\imgxml\Resources\Clouds\RetryButton*"
#EndRegion Search

#Region SwitchAcc
Global Const $g_sImgGoogleButtonState = @ScriptDir & "\imgxml\SwitchAccounts\GooglePlay\Button State\"
Global Const $g_sImgLoginWithSupercellID = @ScriptDir & "\imgxml\other\LoginWithSupercellID*"
Global Const $g_sImgGoogleSelectAccount = @ScriptDir & "\imgxml\other\GoogleSelectAccount*"
Global Const $g_sImgGoogleSelectEmail = @ScriptDir & "\imgxml\other\GoogleSelectEmail*"
Global Const $g_sImgGoogleAccounts = @ScriptDir & "\imgxml\SwitchAccounts\GooglePlay\GooglePlay*"
Global Const $g_sImgSupercellIDConnected = @ScriptDir & "\imgxml\SwitchAccounts\SupercellID\Connected\SCIDConnected*"
Global Const $g_sImgSupercellIDReload = @ScriptDir & "\imgxml\SwitchAccounts\SupercellID\Reload\SCIDReload*"
Global Const $g_sImgSupercellIDWindows = @ScriptDir & "\imgxml\SwitchAccounts\SupercellID\SCIDWindows*"
Global Const $g_sImgSupercellIDSlots = @ScriptDir & "\imgxml\SwitchAccounts\SupercellID\Slots\SCIDHead*"
#EndRegion SwitchAcc

#Region ClanGames
Global Const $g_sImgCaravan = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Caravan"
Global Const $g_sImgStart = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Start"
Global Const $g_sImgCoolPurge = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Gem"
Global Const $g_sImgTrashPurge = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Trash"
Global Const $g_sImgOkayPurge = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Okay"
Global Const $g_sImgReward = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Reward"
Global Const $g_sImgWindow = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Window"
Global Const $g_sImgBorder = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Border"
Global Const $g_sImgGameComplete = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\GameComplete"
Global Const $g_sImgVersus = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Versus"
#EndRegion ClanGames
