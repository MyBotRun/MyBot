; #Variables# ====================================================================================================================
; Name ..........: iDelay Variable
; Description ...: Master file with all program delays
; Syntax ........: $iDelayXXXXXXYYY  : XXXX = function name using the delay, YYY = delay value or position of delay in file
; Author ........: Sardo (Aug 2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;General Delay Times
Global Const $iDelayWaitForPopup = 1500 ; An action was just clicked and waiting for popup

Global Const $iDelayRespond = 5 ; Just to make stop button more Responsive
Global Const $iDelayRunBot1 = 1000
Global Const $iDelayRunBot2 = 800
Global Const $iDelayRunBot3 = 200
Global Const $iDelayRunBot4 = 1500
Global Const $iDelayRunBot5 = 500
Global Const $iDelayRunBot6 = 100
Global Const $iDelayIdle1 = 200
Global Const $iDelayIdle2 = 1500
Global Const $iDelayAttackMain1 = 1000
Global Const $iDelayAttackMain2 = 1500

;algorithmTH
Global Const $iDelayAlgorithmTH1 = 100
Global Const $iDelayAlgorithmTH2 = 1000
Global Const $iDelayAlgorithmTH3 = 200 ;click
Global Const $iDelayAttackTHGrid1 = 500
Global Const $iDelayAttackTHGrid2min = 30
Global Const $iDelayAttackTHGrid2max = 60
Global Const $iDelayAttackTHGrid3min = 40
Global Const $iDelayAttackTHGrid3max = 100
Global Const $iDelayAttackTHGrid4 = 300
Global Const $iDelayAttackTHGrid5 = 100
Global Const $iDelayAttackTHGrid6 = 500
Global Const $iDelayAttackTHNormal1 = 1000
Global Const $iDelayAttackTHXtreme1 = 1000
Global Const $iDelayAttackTHGbarch1 = 1000
Global Const $iDelayALLDropheroes1 = 1000
Global Const $iDelayALLDropheroes2 = 100
Global Const $iDelayCastSpell1 = 10

;algorithm_AllTroops
Global Const $iDelayalgorithm_AllTroops1 = 2000
Global Const $iDelayalgorithm_AllTroops2 = 1000
Global Const $iDelayalgorithm_AllTroops3 = $iDelayWaitForPopup
Global Const $iDelayalgorithm_AllTroops4 = 100
Global Const $iDelayalgorithm_AllTroops5 = 500

;barch
Global Const $iDelayBarch1 = 100
Global Const $iDelayBarch2 = 500
Global Const $iDelayBarch3 = 1000

;AttackReport
Global Const $iDelayAttackReport1 = 500
Global Const $iDelayAttackReport2 = 150

;dropCC
Global Const $iDelaydropCC1 = 500
Global Const $iDelaydropCC2 = 500 ;click

;dropHeroes
Global Const $iDelaydropHeroes1 = 300
Global Const $iDelaydropHeroes2 = 500

;GoldElixirChange
Global Const $iDelayGoldElixirChange1 = 500
Global Const $iDelayGoldElixirChange2 = 1000

;GoldElixirChangeEBO
Global Const $iDelayGoldElixirChangeEBO1 = 500
Global Const $iDelayGoldElixirChangeEBO2 = 1000

;PrepareAttack
Global Const $iDelayPrepareAttack1 = 250

;DropOnPixel
Global Const $iDelayDropOnPixel1 = 50
Global Const $iDelayDropOnPixel2 = 250 ; click


;DropTroop
Global Const $iDelayDropTroop1 = 100
Global Const $iDelayDropTroop2 = 300

;ReturnHome
Global Const $iDelayReturnHomeSurrender = $iDelayWaitForPopup
Global Const $iDelayReturnHome1 = 1000
Global Const $iDelayReturnHome2 = 1500
Global Const $iDelayReturnHome3 = 2500
Global Const $iDelayReturnHome4 = 2000
Global Const $iDelayReturnHome5 = 200

;DropOnEdge
Global Const $iDelayDropOnEdge1 = 100
Global Const $iDelayDropOnEdge2 = 300
Global Const $iDelayDropOnEdge3 = 50
Global Const $iDelayDropOnEdge4 = 250 ; click

;LaunchTroop2
Global Const $iDelayLaunchTroop21 = 100
Global Const $iDelayLaunchTroop22 = 1000
Global Const $iDelayLaunchTroop23 = 300

;OldDropTroop
Global Const $iDelayOldDropTroop1 = 100
Global Const $iDelayOldDropTroop2 = 50

;Unbreakable
Global Const $iDelayUnbreakable1 = 1000
Global Const $iDelayUnbreakable2 = 2000
Global Const $iDelayUnbreakable3 = 3000
Global Const $iDelayUnbreakable4 = 5000
Global Const $iDelayUnbreakable5 = 15000
Global Const $iDelayUnbreakable6 = 30000
Global Const $iDelayUnbreakable7 = 100 ;click
Global Const $iDelayUnbreakable8 = 50 ;click

;checkDarkElix
Global Const $iDelaycheckDarkElix1 = 500
Global Const $iDelaycheckDarkElix2 = 1000

;CheckTombs
Global Const $iDelayCheckTombs1 = 500
Global Const $iDelayCheckTombs2 = 2000

;CheckWall
Global Const $iDelayCheckWall1 = 500
Global Const $iDelayCheckWall2 = 1000
Global Const $iDelayCheckWall3 = 250

;checkMainScreen
Global Const $iDelaycheckMainScreen1 = 1000
Global Const $iDelaycheckMainScreen2 = 20000

;checkObstacles
Global Const $iDelaycheckObstacles1 = 1000
Global Const $iDelaycheckObstacles2 = 2000
Global Const $iDelaycheckObstacles3 = 5000
Global Const $iDelaycheckObstacles4 = 120000 ; 2 minutes
Global Const $iDelaycheckObstacles5 = 500 ; click
Global Const $iDelaycheckObstacles6 = 300000 ; 5 minutes
Global Const $iDelaycheckObstacles7 = 600000 ; 10 minutes
Global Const $iDelaycheckObstacles8 = 900000 ; 15 minutes


;isGemOpen
Global Const $iDelayisGemOpen1 = 350

;waitMainScreen
Global Const $iDelaywaitMainScreen1 = 2000
Global Const $iDelaywaitMainScreen2 = 20000
Global Const $iDelaywaitMainScreen3 = 15000
Global Const $iDelaywaitMainScreen4 = 4000

;ZoomOut
Global Const $iDelayZoomOut1 = 1500
Global Const $iDelayZoomOut2 = 200
Global Const $iDelayZoomOut3 = 1000

;__BlockInputEx_KeyBoardHook_Proc
Global Const $iDelayBlockInput1 = 10

;CheckVersionHTML
Global Const $iDelayCheckVersionHTML1 = 250

;TogglePause
Global Const $iDelayTogglePause1 = 100
Global Const $iDelayTogglePause2 = 250

;TrainClick
Global Const $iDelayTrainClick1 = 3000

;WindowsArrange
Global Const $iDelayWindowsArrange1 = 500

;BuildingInfo
Global Const $iDelayBuildingInfo1 = 1500

;GetResources
Global Const $iDelayGetResources1 = 250
Global Const $iDelayGetResources2 = 500
Global Const $iDelayGetResources3 = 150
Global Const $iDelayGetResources4 = 300
Global Const $iDelayGetResources5 = 2000

;PrepareSearch
Global Const $iDelayPrepareSearch1 = 1000
Global Const $iDelayPrepareSearch2 = 2000
Global Const $iDelayPrepareSearch3 = 500
Global Const $iDelayPrepareSearch4 = 200
Global Const $iDelayPrepareSearch5 = 20000
Global Const $iDelayPrepareSearch6 = 15000
Global Const $iDelayPrepareSearch7 = 50 ; click

;VillageSearch
Global Const $iDelayVillageSearch1 = 1000
Global Const $iDelayVillageSearch2 = 100
Global Const $iDelayVillageSearch3 = 500
Global Const $iDelayVillageSearch4 = 300
Global Const $iDelayVillageSearch5 = 2000

;BarracksStatus
Global Const $iDelayBarracksStatus1 = 50
Global Const $iDelayBarracksStatus2 = 100

;BoostBarracks
Global Const $iDelayBoostBarracks1 = 1000
Global Const $iDelayBoostBarracks2 = 2000
Global Const $iDelayBoostBarracks3 = 500
Global Const $iDelayBoostBarracks4 = 600
Global Const $iDelayBoostBarracks5 = 200

;BoostSpellFactory
Global Const $iDelayBoostSpellFactory1 = 1000
Global Const $iDelayBoostSpellFactory2 = 2000
Global Const $iDelayBoostSpellFactory3 = 500
Global Const $iDelayBoostSpellFactory4 = 600

;BoostHeroes

Global Const $iDelayBoostHeroes1 = 1000
Global Const $iDelayBoostHeroes2 = 2000
Global Const $iDelayBoostHeroes3 = 500
Global Const $iDelayBoostHeroes4 = 600


;BotCommand
Global Const $iDelayBotCommand1 = 500

;BotDetectFirstTime
Global Const $iDelayBotDetectFirstTime1 = 1000
Global Const $iDelayBotDetectFirstTime2 = 50
Global Const $iDelayBotDetectFirstTime3 = 100

;checkArmyCamp
Global Const $iDelaycheckArmyCamp1 = 100
Global Const $iDelaycheckArmyCamp2 = 1000
Global Const $iDelaycheckArmyCamp3 = 2000
Global Const $iDelaycheckArmyCamp4 = 500
Global Const $iDelaycheckArmyCamp5 = 250
Global Const $iDelaycheckArmyCamp6 = 10

;CheckFullArmy
Global Const $iDelayCheckFullArmy1 = 100
Global Const $iDelayCheckFullArmy2 = 200
Global Const $iDelayCheckFullArmy3 = 500

;Collect
Global Const $iDelayCollect1 = 100
Global Const $iDelayCollect2 = 250
Global Const $iDelayCollect3 = 500

;DonateCC
Global Const $iDelayDonateCC1 = 200
Global Const $iDelayDonateCC2 = 250
Global Const $iDelayDonateCC3 = 50 ; click

;DonateTroopType
Global Const $iDelayDonateTroopType1 = 250

;DonateWindow
Global Const $iDelayDonateWindow1 = 250

;DropTrophy
Global Const $iDelayDropTrophy1 = 1000
Global Const $iDelayDropTrophy2 = 2000
Global Const $iDelayDropTrophy3 = 1500
Global Const $iDelayDropTrophy4 = 250

;GetTownHallLevel
Global Const $iDelayGetTownHallLevel1 = 1000
Global Const $iDelayGetTownHallLevel2 = 1500
Global Const $iDelayGetTownHallLevel3 = 200 ; click


;Laboratory
Global Const $iDelayLaboratory1 = 750
Global Const $iDelayLaboratory2 = 200
Global Const $iDelayLaboratory3 = 1000
Global Const $iDelayLaboratory4 = 200 ; click

;LabUpgrade
Global Const $iDelayLabUpgrade1 = 1000
Global Const $iDelayLabUpgrade2 = 200
Global Const $iDelayLabUpgrade3 = 200 ; click

;LocateBarrack
Global Const $iDelayLocateBarrack1 = 1000
Global Const $iDelayLocateBarrack2 = 2000
Global Const $iDelayLocateBarrack3 = 100

;LocateTownHall
Global Const $iDelayLocateTownHall1 = 1000

;CheckUpgrades
Global Const $iDelayCheckUpgrades1 = 1000

;UpgradeValue
Global Const $iDelayUpgradeValue1 = 200
Global Const $iDelayUpgradeValue2 = 800
Global Const $iDelayUpgradeValue3 = 750
Global Const $iDelayUpgradeValue4 = 1000

;DebugImageSave
Global Const $iDelayDebugImageSave1 = 200

;ProfileReport
Global Const $iDelayProfileReport1 = 500
Global Const $iDelayProfileReport2 = 1000
Global Const $iDelayProfileReport3 = 200

;ReportPushBullet
Global Const $iDelayReportPushBullet1 = 500

;PushMsg
Global Const $iDelayPushMsg1 = 500
Global Const $iDelayPushMsg2 = 1000

;ReArm
Global Const $iDelayReArm1 = 500
Global Const $iDelayReArm2 = 1500
Global Const $iDelayReArm3 = 700
Global Const $iDelayReArm4 = 200

;ReplayShare
Global Const $iDelayReplayShare1 = 250
Global Const $iDelayReplayShare2 = 500
Global Const $iDelayReplayShare3 = 1000
Global Const $iDelayReplayShare4 = 2000

;RequestCC
Global Const $iDelayRequestCC1 = 500

;_makerequest
Global Const $iDelaymakerequest1 = 500
Global Const $iDelaymakerequest2 = 1500

;CreateSpell
Global Const $iDelayCreateSpell1 = 600
Global Const $iDelayCreateSpell2 = 1000
Global Const $iDelayCreateSpell3 = 250

;Train
Global Const $iDelayTrain1 = 100
Global Const $iDelayTrain2 = 500
Global Const $iDelayTrain3 = 1000
Global Const $iDelayTrain4 = 200
Global Const $iDelayTrain5 = 250 ; click
Global Const $iDelayTrain6 = 20 ; click
Global Const $iDelayTrain7 = 5 ; Spells Creation

;IsTrainPage
Global Const $iDelayIsTrainPage1 = 100

;UpgradeBuilding
Global Const $iDelayUpgradeBuilding1 = 200
Global Const $iDelayUpgradeBuilding2 = 500
Global Const $iDelayUpgradeBuilding3 = 700

;UpgradeNormal
Global Const $iDelayUpgradeNormal1 = 700
Global Const $iDelayUpgradeNormal2 = 200
Global Const $iDelayUpgradeNormal3 = 750

;UpgradeHero
Global Const $iDelayUpgradeHero1 = 800
Global Const $iDelayUpgradeHero2 = 500
Global Const $iDelayUpgradeHero3 = 1000

;UpgradeWall
Global Const $iDelayUpgradeWall1 = 500

;UpgradeWallGold
Global Const $iDelayUpgradeWallGold1 = 600
Global Const $iDelayUpgradeWallGold2 = 1000
Global Const $iDelayUpgradeWallGold3 = 500

;UpgradeWallElixir
Global Const $iDelayUpgradeWallElixir1 = 600
Global Const $iDelayUpgradeWallElixir2 = 1000
Global Const $iDelayUpgradeWallElixir3 = 500

;VillageReport
Global Const $iDelayVillageReport1 = 500

;DropLSpell
Global Const $iDelayDropLSpell1 = 250

;TrainMoveBtn
Global Const $iDelayTrainMoveBtn1 = 250

; WaitnOpenCoC
Global Const $iDelayWaitnOpenCoC500 = 500
Global Const $iDelayWaitnOpenCoC1000 = 1000
Global Const $iDelayWaitnOpenCoC25000 = 25000

;SWHTSearchLimit
Global Const $iDelaySWHTSearchLimit1 = 200

;SearchLimit
Global Const $iDelaySearchLimit1 = 200
Global Const $iDelaySearchLimit2 = 1000

;ClanLevel
Global Const $iDelayClanLevel1 = 100

;CheckImageType
Global Const $iDelayImageType1 = 100

;SpecialButtonClick = ClickOkay(), ClickRemove()
Global Const $iSpecialClick1 = 200
Global Const $iSpecialClick2 = 100

;AttackCSV
Global Const $iDelayAttackCSV1 = $iDelayVillageSearch5
Global Const $iDelayAttackCSV2 = $iDelayVillageSearch4
Global Const $iDelayAttackCSV3 = 10

;PersonalShield
Global Const $iPersonalShield1 = 1000
Global Const $iPersonalShield2 = 500
Global Const $iPersonalShield3 = 100

;Star bonus
Global Const $iDelayStarBonus100 = 100
Global Const $iDelayStarBonus500 = 500

; Attack Disable
Global Const $iDelayAttackDisable100 = 100
Global Const $iDelayAttackDisable500 = 500
Global Const $iDelayAttackDisable1000 = 1000

;Attack Scheduler
Global Const $iDelayWaitAttack = 120000

