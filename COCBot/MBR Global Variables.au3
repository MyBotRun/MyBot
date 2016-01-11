; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Global Variables
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <FileConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <GUIEdit.au3>
#include <GUIComboBox.au3>
#include <GuiSlider.au3>
#Include <GuiToolBar.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
;#include <WindowsConstants.au3> ; included on MBR Bot.au3
#include <WinAPIProc.au3>
#include <ScreenCapture.au3>
#include <Array.au3>
#include <Date.au3>
#include <Misc.au3>
#include <File.au3>
#include <TrayConstants.au3>
#include <GUIMenu.au3>
#include <ColorConstants.au3>
#include <GDIPlus.au3>
#include <GuiRichEdit.au3>
#include <INet.au3>
#include <GuiTab.au3>
#include <String.au3>
#include <IE.au3>
#include <Process.au3>

Global Const $DEFAULT_HEIGHT = 780
Global Const $DEFAULT_WIDTH = 860
Global Const $midOffsetY = ($DEFAULT_HEIGHT - 720) / 2
Global Const $bottomOffsetY = $DEFAULT_HEIGHT - 720
Global $bMonitorHeight800orBelow = False

;debugging
Global $debugSearchArea = 0, $debugOcr = 0, $debugRedArea = 0, $debugSetlog = 0, $debugDeadBaseImage = 0, $debugImageSave = 0, $debugWalls = 0, $debugBuildingPos= 0, $debugVillageSearchImages = 0

Global Const $COLOR_ORANGE = 0xFF7700
Global Const $bCapturePixel = True, $bNoCapturePixel = False

Global $Compiled
If @Compiled Then
	$Compiled = @ScriptName & " Executable"
Else
	$Compiled = @ScriptName & " Script"
EndIf

Global $hBitmap; Image for pixel functions
Global $hHBitmap; Handle Image for pixel functions
Global $hBitmapScreenshot; Image for screenshot functions
Global $hHBitmapScreenshot; Handle Image for screenshot functions
;Global $sFile = @ScriptDir & "\Icons\logo.gif"

Global Const $64Bit = StringInStr(@OSArch, "64") > 0
Global Const $HKLM = "HKLM" & ($64Bit ? "64" : "")
Global Const $Wow6432Node = ($64Bit ? "\Wow6432Node" : "")
;   0            |1               |2                          |3                                  |4            |5                  |6                   |7                  |8                   |9             |10               |11
;   $Android     |$AndroidInstance|$Title                     |$AppClassInstance                  |$AppPaneName |$AndroidClientWidth|$AndroidClientHeight|$AndroidWindowWidth|$AndroidWindowHeight|$ClientOffsetY|$AndroidAdbDevice|$AndroidSupportsBackgroundMode
Global $AndroidAppConfig[4][12] = [ _
   ["BlueStacks" ,""              ,"BlueStacks App Player"    ,"[CLASS:BlueStacksApp; INSTANCE:1]","_ctl.Window",$DEFAULT_WIDTH     ,$DEFAULT_HEIGHT     ,$DEFAULT_WIDTH     ,$DEFAULT_HEIGHT     ,0             ,"emulator-5554"  ,True ], _ ; BlueStacks 0.9.x - 0.10.x (set registry to 860x720)
   ["BlueStacks2",""              ,"BlueStacks Android Plugin","[CLASS:BlueStacksApp; INSTANCE:1]","_ctl.Window",$DEFAULT_WIDTH     ,$DEFAULT_HEIGHT - 48,$DEFAULT_WIDTH     ,$DEFAULT_HEIGHT - 48,0             ,"127.0.0.1:5555" ,True ], _ ; BlueStacks 2.x
   ["Droid4X"    ,"droid4x"       ,"Droid4X "                 ,"[CLASS:subWin; INSTANCE:1]"       ,""           ,$DEFAULT_WIDTH     ,$DEFAULT_HEIGHT - 48,$DEFAULT_WIDTH + 10,$DEFAULT_HEIGHT + 50,0             ,"127.0.0.1:26944",False], _ ; Droid4X 0.8.6 Beta
   ["MEmu"       ,""              ,"MEmu "                    ,"[CLASS:subWin; INSTANCE:1]"       ,""           ,$DEFAULT_WIDTH     ,$DEFAULT_HEIGHT - 12,0                  ,0                   ,0             ,"127.0.0.1:21503",False]  _ ; Droid4X 0.8.6 Beta
]

Global $FoundRunningAndroid = False
Global $FoundInstalledAndroid = False

Global $AndroidConfig = 0 ; Default selected Android Config of $AndroidAppConfig array
Global $AndroidVersion ; Identified version of Android Emulator
; Updated in UpdateAndroidConfig() as well
Global $Android = $AndroidAppConfig[$AndroidConfig][0] ; Emulator used (BS, BS2 or Droid4X)
Global $AndroidInstance = $AndroidAppConfig[$AndroidConfig][1] ; Clone or instance of emulator or "" if not supported
Global $Title = $AndroidAppConfig[$AndroidConfig][2] ; Emulator Window Title
Global $AppClassInstance =  $AndroidAppConfig[$AndroidConfig][3] ; Control Class and instance of android rendering
Global $AppPaneName = $AndroidAppConfig[$AndroidConfig][4] ; Control name of android rendering TODO check is still required
Global $AndroidClientWidth = $AndroidAppConfig[$AndroidConfig][5] ; Expected width of android rendering
Global $AndroidClientHeight = $AndroidAppConfig[$AndroidConfig][6] ; Expected height of android rendering
Global $AndroidWindowWidth = $AndroidAppConfig[$AndroidConfig][7]
Global $AndroidWindowHeight = $AndroidAppConfig[$AndroidConfig][8]
Global $ClientOffsetY = $AndroidAppConfig[$AndroidConfig][9]
Global $AndroidAdbPath ; Path to executable HD-Adb.exe or adb.exe
Global $AndroidAdbDevice = $AndroidAppConfig[$AndroidConfig][10]
Global $AndroidSupportsBackgroundMode = $AndroidAppConfig[$AndroidConfig][11]
Global $AndroidLaunchWaitSec = 240 ; Seconds to wait for launching Android Simulator

Global $HWnD ;Handle for Android window

Global $iVillageName
Global $sProfilePath = @ScriptDir & "\Profiles"
Global $sTemplates = @ScriptDir & "\Templates"
Global $aTxtLogInitText[0][6] = [[]]

Global $iMoveMouseOutBS = 0 ; If enabled moves mouse out of Android window when bot is running
Global $DevMode = 1
If FileExists(@ScriptDir & "\EnableMBRDebug.txt") Then $DevMode = 1

; Special Android Emulator variables
Global $__BlueStacks_Version
Global $__BlueStacks_Path
Global $__Droid4X_Version
Global $__Droid4X_Path
Global $__VirtualBox_Path

; Handle Command Line Parameters
If $CmdLine[0] > 0 Then
	$sCurrProfile = $CmdLine[1]
ElseIf FileExists($sProfilePath & "\profile.ini") Then
	Global $sCurrProfile = IniRead($sProfilePath & "\profile.ini", "general", "defaultprofile", "01")
Else
	Global $sCurrProfile = "01"
EndIf

; Change Android type and update variable
If $CmdLine[0] > 1 Then
   Local $i
   For $i = 0 To UBound($AndroidAppConfig) - 1
	  If StringCompare($AndroidAppConfig[$i][0], $CmdLine[2]) = 0 Then
		 $AndroidConfig = $i
		 UpdateAndroidConfig()
         If $AndroidAppConfig[$i][1] <> "" and $CmdLine[0] > 2 Then
			; Update Instance Name
			$AndroidInstance = $CmdLine[3]
		 EndIf
	  EndIF
   Next
EndIf

Global $config = $sProfilePath & "\" & $sCurrProfile & "\config.ini"
Global $statChkTownHall = $sProfilePath & "\" & $sCurrProfile & "\stats_chktownhall.INI"
Global $statChkDeadBase = $sProfilePath & "\" & $sCurrProfile & "\stats_chkelixir.INI"
Global $statChkDeadBase75percent = $sProfilePath & "\" & $sCurrProfile & "\stats_chkelixir75percent.INI"
Global $building = $sProfilePath & "\" & $sCurrProfile & "\building.ini"
Global $dirLogs = $sProfilePath & "\" & $sCurrProfile & "\Logs\"
Global $dirLoots = $sProfilePath & "\" & $sCurrProfile & "\Loots\"
Global $dirTemp = $sProfilePath & "\" & $sCurrProfile & "\Temp\"
Global $LibDir = @ScriptDir & "\lib" ;lib directory contains dll's
Global $pFuncLib = $LibDir & "\MBRFunctions.dll" ; functions library
Global $hFuncLib ; handle to functions library
Global $pIconLib = $LibDir & "\MBRBOT.dll" ; icon library
Global Const $dirTHSnipesAttacks = @ScriptDir&"\THSnipe"

; enumerated Icons 1-based index to IconLib
Global Enum $eIcnArcher = 1, $eIcnDonArcher, $eIcnBalloon, $eIcnDonBalloon, $eIcnBarbarian, $eIcnDonBarbarian, $eIcnKingAbility, $eIcnBuilder, $eIcnCC, $eIcnGUI, $eIcnDark, $eIcnDragon, $eIcnDonDragon, $eIcnDrill, $eIcnElixir, $eIcnCollector, $eIcnFreezeSpell, $eIcnGem, $eIcnGiant, $eIcnDonGiant, _
		$eIcnTrap, $eIcnGoblin, $eIcnDonGoblin, $eIcnGold, $eIcnGolem, $eIcnDonGolem, $eIcnHealer, $eIcnDonHealer, $eIcnHogRider, $eIcnDonHogRider, $eIcnHealSpell, $eIcnInferno, $eIcnJumpSpell, $eIcnLavaHound, $eIcnDonLavaHound, $eIcnLightSpell, $eIcnMinion, $eIcnDonMinion, $eIcnPekka, $eIcnDonPekka, _
		$eIcnQueenAbility, $eIcnRageSpell, $eIcnTroops, $eIcnHourGlass, $eIcnTH1, $eIcnTH10, $eIcnTrophy, $eIcnValkyrie, $eIcnDonValkyrie, $eIcnWall, $eIcnWallBreaker, $eIcnDonWallBreaker, $eIcnWitch, $eIcnDonWitch, $eIcnWizard, $eIcnDonWizard, $eIcnXbow, $eIcnBarrackBoost, $eIcnMine, $eIcnCamp, _
		$eIcnBarrack, $eIcnSpellFactory, $eIcnDonBlacklist, $eIcnSpellFactoryBoost, $eIcnMortar, $eIcnWizTower, $eIcnPayPal, $eIcnPushBullet, $eIcnGreenLight, $eIcnLaboratory, $eIcnRedLight, $eIcnBlank, $eIcnYellowLight, $eIcnDonCustom, $eIcnTombstone, $eIcnSilverStar, $eIcnGoldStar, $eIcnDarkBarrack, _
		$eIcnCollectorLocate, $eIcnDrillLocate, $eIcnMineLocate, $eIcnBarrackLocate, $eIcnDarkBarrackLocate, $eIcnDarkSpellFactoryLocate, $eIcnDarkSpellFactory, $eIcnEarthQuakeSpell, $eIcnHasteSpell, $eIcnPoisonSpell, $eIcnBldgTarget, $eIcnBldgX, $eIcnRecycle, $eIcnHeroes, _
		$eIcnBldgElixir, $eIcnBldgGold, $eIcnMagnifier, $eIcnWallElixir, $eIcnWallGold, $eIcnQueen, $eIcnKing, $eIcnDarkSpellBoost, $eIcnQueenBoostLocate, $eIcnKingBoostLocate, $eIcnKingUpgr, $eIcnQueenUpgr,$eIcnWardenAbility,$eIcnWarden,$eIcnWardenBoostLocate, $eIcnKingBoost, _
		$eIcnQueenBoost, $eIcnWardenBoost, $eIcnWardenUpgr

Global $eIcnDonBlank = $eIcnDonBlacklist
Global $aDonIcons[17] = [$eIcnDonBarbarian, $eIcnDonArcher, $eIcnDonGiant, $eIcnDonGoblin, $eIcnDonWallBreaker, $eIcnDonBalloon, $eIcnDonWizard, $eIcnDonHealer, $eIcnDonDragon, $eIcnDonPekka, $eIcnDonMinion, $eIcnDonHogRider, $eIcnDonValkyrie, $eIcnDonGolem, $eIcnDonWitch, $eIcnDonLavaHound, $eIcnDonBlank]
Global $sLogPath ; `Will create a new log file every time the start button is pressed
Global $sAttackLogPath ; `Will create a new log file every time the start button is pressed
Global $hLogFileHandle
Global $hAttackLogFileHandle
Global $iCmbLog = 0
Global $Restart = False
Global $RunState = False
Global $TakeLootSnapShot = True
Global $ScreenshotLootInfo = False
Global $AlertSearch = True
Global $iChkAttackNow, $iAttackNowDelay, $bBtnAttackNowPressed = False
Global $PushToken = ""

Global Enum $DB, $LB, $TS, $TB, $DT
Global $iModeCount = 2
Global $iMatchMode ; 0 Dead / 1 Live / 2 TH Snipe / 3 TH Bully / 4 Drop Trophy
Global $sModeText[5]
$sModeText[$DB] = "Dead Base"
$sModeText[$LB] = "Live Base"
$sModeText[$TS] = "TH Snipe"
$sModeText[$TB] = "TH Bully"
$sModeText[$DT] = "Drop Trophy"

;PushBullet---------------------------------------------------------------
Global $PBRemoteControlInterval = 60000 ; 60 secs
Global $PBDeleteOldPushesInterval = 1800000 ; 30 mins
Global $iOrigPushB
Global $iLastAttack
Global $iAlertPBVillage
Global $pEnabled
Global $pRemote
Global $pMatchFound
Global $pLastRaidImg
Global $iAlertPBLastRaidTxt
Global $pWallUpgrade
Global $pOOS
Global $pTakeAbreak
Global $pAnotherDevice
Global $sLogFName
Global $sAttackLogFName
Global $AttackFile
Global $RequestScreenshot = 0
Global $iDeleteAllPushes = 0
Global $iDeleteAllPushesNow = False
Global $ichkDeleteOldPushes
Global $icmbHoursPushBullet
Global $chkDeleteAllPushes
Global $ichkAlertPBCampFull
Global $ichkAlertPBCampFullTest = 0
Global $cmbTroopComp ;For Event change on ComboBox Troop Compositions
Global $iCollectCounter = 0 ; Collect counter, when reaches $COLLECTATCOUNT, it will collect
Global $COLLECTATCOUNT = 10 ; Run Collect() after this amount of times before actually collect

;---------------------------------------------------------------------------------------------------
Global $BSpos[2] ; Inside Android window positions relative to the screen, [x,y]
Global $BSrpos[2] ; Inside Android window positions relative to the window, [x,y]
;---------------------------------------------------------------------------------------------------
;Stats
Global $iFreeBuilderCount, $iTotalBuilderCount, $iGemAmount ; builder and gem amounts
Global $iGoldStart, $iElixirStart, $iDarkStart, $iTrophyStart ; stats at the start
Global $iGoldTotal, $iElixirTotal, $iDarkTotal, $iTrophyTotal ; total stats
Global $iGoldCurrent, $iElixirCurrent, $iDarkCurrent, $iTrophyCurrent ; current stats
Global $iGoldLast, $iElixirLast, $iDarkLast, $iTrophyLast ; loot and trophy gain from last raid
Global $iGoldLastBonus, $iElixirLastBonus, $iDarkLastBonus ; bonus loot from last raid
Global $iBonusLast = 0  ; last attack Bonus percentage
Global $iSkippedVillageCount, $iDroppedTrophyCount ; skipped village and dropped trophy counts
Global $iCostGoldWall, $iCostElixirWall, $iCostGoldBuilding, $iCostElixirBuilding, $iCostDElixirHero ; wall, building and hero upgrade costs
Global $iNbrOfWallsUppedGold, $iNbrOfWallsUppedElixir, $iNbrOfBuildingsUppedGold, $iNbrOfBuildingsUppedElixir, $iNbrOfHeroesUpped ; number of wall, building, hero upgrades with gold, elixir, delixir
Global $iSearchCost, $iTrainCostElixir, $iTrainCostDElixir ; search and train troops cost
Global $iNbrOfOoS ; number of Out of Sync occurred
Global $iNbrOfTHSnipeFails, $iNbrOfTHSnipeSuccess ; number of fails and success while TH Sniping
Global $iGoldFromMines, $iElixirFromCollectors, $iDElixirFromDrills ; number of resources gain by collecting mines, collectors, drills
Global $iAttackedVillageCount[$iModeCount + 2] ; number of attack villages for DB, LB, TB, TS
Global $iTotalGoldGain[$iModeCount + 2], $iTotalElixirGain[$iModeCount + 2], $iTotalDarkGain[$iModeCount + 2], $iTotalTrophyGain[$iModeCount + 2] ; total resource gains for DB, LB, TB, TS
Global $iNbrOfDetectedMines[$iModeCount + 2], $iNbrOfDetectedCollectors[$iModeCount + 2], $iNbrOfDetectedDrills[$iModeCount + 2] ; number of mines, collectors, drills detected for DB, LB, TB
Global $lblAttacked[$iModeCount + 2], $lblTotalGoldGain[$iModeCount + 2], $lblTotalElixirGain[$iModeCount + 2], $lblTotalDElixirGain[$iModeCount + 2], $lblTotalTrophyGain[$iModeCount + 2]
Global $lblNbrOfDetectedMines[$iModeCount + 2], $lblNbrOfDetectedCollectors[$iModeCount + 2], $lblNbrOfDetectedDrills[$iModeCount + 2]

;Global $costspell

;Search Settings
Global $bSearchMode = False
Global $Is_ClientSyncError = False ;If true means while searching Client Out Of Sync error occurred.
Global $searchGold, $searchElixir, $searchDark, $searchTrophy, $searchTH ;Resources of bases when searching
Global $SearchGold2 = 0, $SearchElixir2 = 0, $iStuck = 0, $iNext = 0
Global $iCmbSearchMode
Global $iMinGold[$iModeCount], $iMinElixir[$iModeCount], $iMinGoldPlusElixir[$iModeCount], $iMinDark[$iModeCount], $iMinTrophy[$iModeCount], $iMaxTH[$iModeCount], $iEnableAfterCount[$iModeCount], $iCmbWeakMortar[$iModeCount], $iCmbWeakWizTower[$iModeCount] ; Minimum Resources conditions
Global $iAimGold[$iModeCount], $iAimElixir[$iModeCount], $iAimGoldPlusElixir[$iModeCount], $iAimDark[$iModeCount], $iAimTrophy[$iModeCount], $iAimTHtext[$iModeCount] ; Aiming Resource values
Global $iChkSearchReduction
Global $ReduceCount, $ReduceGold, $ReduceElixir, $ReduceGoldPlusElixir, $ReduceDark, $ReduceTrophy ; Reducing values
;Global $chkConditions[7], $ichkMeetOne ;Conditions (meet gold...)
;Global $icmbTH
Global $iChkEnableAfter[$iModeCount], $iCmbMeetGE[$iModeCount], $iChkMeetDE[$iModeCount], $iChkMeetTrophy[$iModeCount], $iChkMeetTH[$iModeCount],$iChkMeetTHO[$iModeCount],  $iChkMeetOne[$iModeCount], $iCmbTH[$iModeCount], $iChkWeakBase[$iModeCount]
Global $chkDBMeetTHO, $chkABMeetTHO, $chkATH
Global $THLocation
Global $THx = 0, $THy = 0
Global $DESLoc
Global $DESLocx = 0
Global $DESLocy = 0
Global $THText[6] ; Text of each Townhall level
$THText[0] = "4-6"
$THText[1] = "7"
$THText[2] = "8"
$THText[3] = "9"
$THText[4] = "10"
$THText[5] = "11"
Global $THImages0,$THImages1,$THImages2,$THImages3,$THImages4, $THImages5
Global $THImagesStat0,$THImagesStat1,$THImagesStat2,$THImagesStat3,$THImagesStat4, $THImagesStat5
Global $SearchCount = 0 ;Number of searches

Global $THaddtiles, $THside, $THi
Global $SearchTHLResult = 0
Global $BullySearchCount = 0
Global $OptBullyMode = 0
Global $OptTrophyMode
Global $chkTrophyMode
Global $ATBullyMode
Global $YourTH
Global $iTHBullyAttackMode
;~ Global $icmbAttackTHType
Global $scmbAttackTHType = "Bam"
Global $txtAttackTHType
Global $iNbOfSpots
Global $iAtEachSpot
Global $Sleep
Global $waveNb
Global $DelayInSec
Global $Log
Global $CheckHeroes
Global $KingSlotTH
Global $QueenSlotTH
; Attack TH snipe
Global $icmbDeployBtmTHType
Global $ichkUseKingTH = 0
Global $ichkUseQueenTH = 0
Global $ichkUseWardenTH = 0
Global $ichkUseClastleTH = 0
Global $ichkUseClastleTH = 0
Global $ichkUseLSpellsTH = 0
Global $ichkUseRSpellsTH = 0
Global $ichkUseHSpellsTH = 0
Global $THusedKing = 0
Global $THusedQueen = 0
Global $THusedWarden = 0


Global $TrainSpecial = 1 ;0=Only trains after atk. Setting is automatic
Global $cBarbarian = 0, $cArcher = 0, $cGoblin = 0, $cGiant = 0, $cWallbreaker = 0, $cWizard = 0, $cBalloon = 0, $cDragon = 0, $cPekka = 0, $cMinion = 0, $cHogs = 0, $cValkyrie = 0, $cGolem = 0, $cWitch = 0, $cLavaHound = 0
;Troop types
Global Enum $eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eMini, $eHogs, $eValk, $eGole, $eWitc, $eLava, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell
;wall
Global $WallCost
Global $WallX = 0, $WallY = 0
Global $Wall[8]
Global $iMaxNbWall = 8

;Attack Settings
; Old coordinates
#cs
Global $TopLeft[5][2] = [[79, 281], [170, 205], [234, 162], [296, 115], [368, 66]]
Global $TopRight[5][2] = [[480, 63], [540, 104], [589, 146], [655, 190], [779, 278]]
Global $BottomLeft[5][2] = [[79, 342], [142, 389], [210, 446], [276, 492], [339, 539]]
Global $BottomRight[5][2] = [[523, 537], [595, 484], [654, 440], [715, 393], [779, 344]]
#ce
; New coordinates by Cru34
Global $TopLeft[5][2] = [[83, 306], [174, 238], [240, 188], [303, 142], [390, 76]]
Global $TopRight[5][2] = [[466, 66], [556, 134], [622, 184], [684, 231], [775, 300]]
Global $BottomLeft[5][2] = [[81, 363], [174, 434], [235, 481], [299, 530], [390, 600]]
Global $BottomRight[5][2] = [[466, 590], [554, 523], [615, 477], [678, 430], [765, 364]]
Global $eThing[1] = [101]
Global $Edges[4] = [$BottomRight, $TopLeft, $BottomLeft, $TopRight]
Global $BarbarianKingAvailable = 0
Global $ArcherQueenAvailable = 0
Global $GrandWardenAvailable = 0

Global $atkTroops[12][2] ;11 Slots of troops -  Name, Amount

Global $fullArmy ;Check for full army or not

Global $iChkDeploySettings[$iModeCount] ;Method of deploy found in attack settings
Global $iChkRedArea[$iModeCount], $iCmbSmartDeploy[$iModeCount], $iChkSmartAttack[$iModeCount][3], $iCmbSelectTroop[$iModeCount]

Global $troopsToBeUsed[11]
Global $useAllTroops[28] = [$eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eMini, $eHogs, $eValk, $eGole, $eWitc, $eLava, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell]
Global $useBarracks[22] = [$eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell]
Global $useBarbs[13] = [$eBarb, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell]
Global $useArchs[13] = [$eArch, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell]
Global $useBarcher[14] = [$eBarb, $eArch, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell]
Global $useBarbGob[14] = [$eBarb, $eGobl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell]
Global $useArchGob[14] = [$eArch, $eGobl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell]
Global $useBarcherGiant[15] = [$eBarb, $eArch, $eGiant, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell]
Global $useBarcherGobGiant[16] = [$eBarb, $eArch, $eGiant, $eGobl, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell]
Global $useBarcherHog[15] = [$eBarb, $eArch, $eHogs, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell]
Global $useBarcherMinion[15] = [$eBarb, $eArch, $eMini, $eKing, $eQueen, $eWarden, $eCastle, $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell]
$troopsToBeUsed[0] = $useAllTroops
$troopsToBeUsed[1] = $useBarracks
$troopsToBeUsed[2] = $useBarbs
$troopsToBeUsed[3] = $useArchs
$troopsToBeUsed[4] = $useBarcher
$troopsToBeUsed[5] = $useBarbGob
$troopsToBeUsed[6] = $useArchGob
$troopsToBeUsed[7] = $useBarcherGiant
$troopsToBeUsed[8] = $useBarcherGobGiant
$troopsToBeUsed[9] = $useBarcherHog
$troopsToBeUsed[10] = $useBarcherMinion

Global $KingAttack[$iModeCount] ;King attack settings
Global $QueenAttack[$iModeCount] ;Queen attack settings
Global $WardenAttack[$iModeCount] ;Grand Garden attack settings
Global $A[4] = [112, 111, 116, 97]

Global $checkKPower = False ; Check for King activate power
Global $checkQPower = False ; Check for Queen activate power
Global $checkWPower = False ; Check for Warden activate power
Global $iActivateKQCondition
Global $iActivateWardenCondition
Global $delayActivateKQ ; = 9000 ;Delay before activating KQ
Global $delayActivateW ; Delay before activating Grand Warden Ability

Global $iDropCC[$iModeCount] ; Use Clan Castle settings
Global $iChkUseCCBalanced ; Use Clan Castle Balanced settings
Global $iCmbCCDonated, $iCmbCCReceived ; Use Clan Castle Balanced ratio settings

Global $THLoc
Global $ichkATH, $iChkLightSpell

Global $King, $Queen, $CC, $Barb, $Arch, $LSpell, $LSpellQ, $Warden
Global $LeftTHx, $RightTHx, $BottomTHy, $TopTHy
Global $AtkTroopTH
Global $GetTHLoc
Global $iUnbreakableMode = 0
Global $iUnbreakableWait, $iUnBrkMinGold, $iUnBrkMinElixir, $iUnBrkMaxGold, $iUnBrkMaxElixir, $iUnBrkMinDark, $iUnBrkMaxDark
Global $OutOfGold = 0 ; Flag for out of gold to search for attack
Global $OutOfElixir = 0 ; Flag for out of elixir to train troops

;Zoom/scroll variables for TH snipe, bottom corner
Global $zoomedin = False, $zCount = 0, $sCount = 0

;Boosts Settings
Global $remainingBoosts = 0 ;  remaining boost to active during session
Global $boostsEnabled = 1 ; is this function enabled

; TownHall Settings
Global $TownHallPos[2] = [-1, -1] ;Position of TownHall
Global $iTownHallLevel = 0 ; Level of user townhall
Global $Y[4] = [46, 116, 120, 116]

;Mics Setting
Global $SFPos[2] = [-1, -1] ;Position of Spell Factory
Global $DSFPos[2] = [-1, -1] ;Position of Dark Spell Factory
Global $KingAltarPos[2] = [-1,-1] ; position Kings Altar
Global $QueenAltarPos[2] = [-1,-1] ; position Queens Altar
Global $WardenAltarPos[2] = [-1,-1] ; position Grand Warden Altar

;Donate Settings
Global $aCCPos[2] = [-1, -1] ;Position of clan castle
Global $LastDonateBtn1 = -1, $LastDonateBtn2 = -1
Global $DonatePixel
Global $iClanLevel
Global $LastBarrackTrainDonatedTroop = 1
Global $LastDarkBarrackTrainDonatedTroop = 1

Global $iChkRequest = 0, $sTxtRequest = ""

Global $ichkDonateAllBarbarians = 0, $ichkDonateBarbarians = 0, $sTxtDonateBarbarians = "", $sTxtBlacklistBarbarians = "", $aDonBarbarians, $aBlkBarbarians
Global $ichkDonateAllArchers = 0, $ichkDonateArchers = 0, $sTxtDonateArchers = "", $sTxtBlacklistArchers = "", $aDonArchers, $aBlkArchers
Global $ichkDonateAllGiants = 0, $ichkDonateGiants = 0, $sTxtDonateGiants = "", $sTxtBlacklistGiants = "", $aDonGiants, $aBlkGiants
Global $ichkDonateAllGoblins = 0, $ichkDonateGoblins = 0, $sTxtDonateGoblins = "", $sTxtBlacklistGoblins = "", $aDonGoblins, $aBlkGoblins
Global $ichkDonateAllWallBreakers = 0, $ichkDonateWallBreakers = 0, $sTxtDonateWallBreakers = "", $sTxtBlacklistWallBreakers = "", $aDonWallBreakers, $aBlkWallBreakers
Global $ichkDonateAllBalloons = 0, $ichkDonateBalloons = 0, $sTxtDonateBalloons = "", $sTxtBlacklistBalloons = "", $aDonBalloons, $aBlkBalloons
Global $ichkDonateAllWizards = 0, $ichkDonateWizards = 0, $sTxtDonateWizards = "", $sTxtBlacklistWizards = "", $aDonWizards, $aBlkWizards
Global $ichkDonateAllHealers = 0, $ichkDonateHealers = 0, $sTxtDonateHealers = "", $sTxtBlacklistHealers = "", $aDonHealers, $aBlkHealers
Global $ichkDonateAllDragons = 0, $ichkDonateDragons = 0, $sTxtDonateDragons = "", $sTxtBlacklistDragons = "", $aDonDragons, $aBlkDragons
Global $ichkDonateAllPekkas = 0, $ichkDonatePekkas = 0, $sTxtDonatePekkas = "", $sTxtBlacklistPekkas = "", $aDonPekkas, $aBlkPekkas
Global $ichkDonateAllMinions = 0, $ichkDonateMinions = 0, $sTxtDonateMinions = "", $sTxtBlacklistMinions = "", $aDonMinions, $aBlkMinions
Global $ichkDonateAllHogRiders = 0, $ichkDonateHogRiders = 0, $sTxtDonateHogRiders = "", $sTxtBlacklistHogRiders = "", $aDonHogRiders, $aBlkHogRiders
Global $ichkDonateAllValkyries = 0, $ichkDonateValkyries = 0, $sTxtDonateValkyries = "", $sTxtBlacklistValkyries = "", $aDonValkyries, $aBlkValkyries
Global $ichkDonateAllGolems = 0, $ichkDonateGolems = 0, $sTxtDonateGolems = "", $sTxtBlacklistGolems = "", $aDonGolems, $aBlkGolems
Global $ichkDonateAllWitches = 0, $ichkDonateWitches = 0, $sTxtDonateWitches = "", $sTxtBlacklistWitches = "", $aDonWitches, $aBlkWitches
Global $ichkDonateAllLavaHounds = 0, $ichkDonateLavaHounds = 0, $sTxtDonateLavaHounds = "", $sTxtBlacklistLavaHounds = "", $aDonLavaHounds, $aBlkLavaHounds
Global $ichkDonateAllCustom = 0, $ichkDonateCustom = 0, $sTxtDonateCustom = "", $sTxtBlacklistCustom = "", $aDonCustom, $aBlkCustom, $varDonateCustom[3][2] ;;; Custom Combination Donate by ChiefM3
Global $sTxtBlacklist = "", $aBlacklist
Global $B[6] = [116, 111, 98, 111, 116, 46]
Global $F[8] = [112, 58, 47, 47, 119, 119, 119, 46]
Global $ichkExtraAlphabets = 0 ; extra alphabets

Global $DonBarb = 0, $DonArch = 0, $DonGiant = 0, $DonGobl = 0, $DonWall = 0, $DonBall = 0, $DonWiza = 0, $DonHeal = 0
Global $DonMini = 0, $DonHogs = 0, $DonValk = 0, $DonGole = 0, $DonWitc = 0, $DonLava = 0, $DonDrag = 0, $DonPekk = 0

;Troop Settings
Global $icmbTroopComp ;Troop Composition
Global $icmbTroopCap ;Troop Capacity
Global $BarbComp = 30, $ArchComp = 60, $GoblComp = 10, $GiantComp = 4, $WallComp = 4, $WizaComp = 0, $MiniComp = 0, $HogsComp = 0
Global $DragComp = 0, $BallComp = 0, $PekkComp = 0, $HealComp = 0, $ValkComp = 0, $GoleComp = 0, $WitcComp = 0, $LavaComp = 0
Global $CurBarb = 0, $CurArch = 0, $CurGiant = 0, $CurGobl = 0, $CurWall = 0, $CurBall = 0, $CurWiza = 0, $CurHeal = 0
Global $CurMini = 0, $CurHogs = 0, $CurValk = 0, $CurGole = 0, $CurWitc = 0, $CurLava = 0, $CurDrag = 0, $CurPekk = 0
Global $T[1] = [97]
Global $ArmyComp

;Spell Settings
Global $LightningSpellComp = 0 , $HealSpellComp = 0 , $RageSpellComp = 0 , $PoisonSpellComp = 0 , $HasteSpellComp = 0
Global $CurLightningSpell = 0  , $CurHealSpell = 0  , $CurRageSpell = 0  , $CurJumpSpell = 0 , $CurFreezeSpell = 0 ,  $CurPoisonSpell = 0  , $CurHasteSpell = 0 , $CurEarthSpell = 0
Global $iTotalCountSpell = 0
Global $TotalSFactory = 0
Global $CurSFactory = 0

Global $barrackPos[4][2] ;Positions of each barracks

Global $barrackTroop[5] ;Barrack troop set
Global $ArmyPos[2] = [-1, -1]

;Other Settings
Global $ichkWalls
Global $icmbWalls
Global $iUseStorage
Global $itxtWallMinGold
Global $itxtWallMinElixir
Global $iVSDelay,$iMaxVSDelay
Global $isldTrainITDelay
Global $ichkTrap, $iChkCollect, $ichkTombstones
Global $iCmbUnitDelay[$iModeCount], $iCmbWaveDelay[$iModeCount], $iChkRandomspeedatk[$iModeCount]
Global $iTimeTroops = 0
Global $iTimeGiant = 120
Global $iTimeWall = 120
Global $iTimeArch = 25
Global $iTimeGoblin = 30
Global $iTimeBarba = 20
Global $iTimeWizard = 480
Global $iChkTrophyHeroes, $iChkTrophyAtkDead
; Old upgrade buildings variables, delete after testing no harm done.
;Global $ichkUpgrade1, $ichkUpgrade2, $ichkUpgrade3, $ichkUpgrade4
;Global $itxtUpgradeX1, $itxtUpgradeY1, $itxtUpgradeX2, $itxtUpgradeY2, $itxtUpgradeX3, $itxtUpgradeY3, $itxtUpgradeX4, $itxtUpgradeY4
;Global $BuildPos1[2]
;Global $BuildPos2[2]
;Global $BuildPos3[2]
;Global $BuildPos4[2]

Global $Walltolerance[7] = [35,35,45,35,45,40,35]

;General Settings
Global $botPos[2] ; Position of bot used for Hide function
Global $frmBotPosX ; Position X of the GUI
Global $frmBotPosY ; Position Y of the GUI
Global $Hide = False ; If hidden or not

Global $ichkBotStop, $icmbBotCommand, $icmbBotCond, $icmbHoursStop
Global $C[6] = [98, 117, 103, 115, 51, 46]
Global $CommandStop = -1
Global $MeetCondStop = False
Global $bTrainEnabled = True
Global $bDonationEnabled = True
Global $UseTimeStop = -1
Global $TimeToStop = -1

Global $itxtMaxTrophy ; Max trophy before drop trophy
Global $itxtdropTrophy ; trophy floor to drop to
Global $ichkAutoStart ; AutoStart mode enabled disabled
Global $ichkAutoStartDelay
Global $restarted
Global $ichkBackground ; Background mode enabled disabled
Global $collectorPos[17][2] ;Positions of each collectors
Global $D[4] = [99, 111, 109, 47]

Global $break = @ScriptDir & "\images\break.bmp"
Global $device = @ScriptDir & "\images\device.bmp"
Global $CocStopped = @ScriptDir & "\images\CocStopped.bmp"
Global $imgDivider = @ScriptDir & "\images\divider.bmp"
Global $iDividerY = 385
Global $G[3] = [104, 116, 116]
Global $resArmy = 0
Global $FirstRun = 1
Global $FirstAttack = 0
Global $CurTrophy = 0
Global $brrNum
Global $sTimer, $iTimePassed, $hour, $min, $sec, $sTimeWakeUp = 120
Global $fulltroop = 100
Global $CurCamp, $TotalCamp = 0
Global $NoLeague
Global $FirstStart = True
Global $TPaused, $BlockInputPause = 0

; Halt/Restart Mode values
Global $itxtRestartGold, $itxtRestartElixir, $itxtRestartDark


;Global $iWBMortar
;Global $iWBWizTower
;Global $iWBXbow
Global $TroopGroup[10][3] = [["Pekk", 9, 25], ["Drag", 8, 20], ["Heal", 7, 14], ["Wiza", 6, 4], ["Ball", 5, 5], ["Giant", 2, 5], ["Wall", 4, 2], ["Gobl", 3, 1], ["Arch", 1, 1], ["Barb", 0, 1]]
Global $TroopName[UBound($TroopGroup, 1)]
Global $TroopNamePosition[UBound($TroopGroup, 1)]
Global $TroopHeight[UBound($TroopGroup, 1)]
Global $TroopGroupDark[6][3] = [["Mini", 0, 2], ["Hogs", 1, 5], ["Valk", 2, 8], ["Gole", 3, 30], ["Witc", 4, 12], ["Lava", 5, 30]]
Global $TroopDarkName[UBound($TroopGroupDark, 1)]
Global $TroopDarkNamePosition[UBound($TroopGroupDark, 1)]
Global $TroopDarkHeight[UBound($TroopGroupDark, 1)]
Global $BarrackStatus[4] = [False, False, False, False]
Global $BarrackFull[4] = [False, False, False, False]
Global $BarrackDarkStatus[2] = [False, False]
Global $BarrackDarkFull[2] = [False, False]
Global $listResourceLocation = ""
Global $isNormalBuild = ""
Global $isDarkBuild = ""
Global $TotalTrainedTroops = 0

For $i = 0 To UBound($TroopGroup, 1) - 1
	$TroopName[$i] = $TroopGroup[$i][0]
	$TroopNamePosition[$i] = $TroopGroup[$i][1]
	$TroopHeight[$i] = $TroopGroup[$i][2]
Next
For $i = 0 To UBound($TroopGroupDark, 1) - 1
	$TroopDarkName[$i] = $TroopGroupDark[$i][0]
	$TroopDarkNamePosition[$i] = $TroopGroupDark[$i][1]
	$TroopDarkHeight[$i] = $TroopGroupDark[$i][2]
Next

;New var to search red area
Global $PixelTopLeft[0]
Global $PixelBottomLeft[0]
Global $PixelTopRight[0]
Global $PixelBottomRight[0]

Global $PixelTopLeftFurther[0]
Global $PixelBottomLeftFurther[0]
Global $PixelTopRightFurther[0]
Global $PixelBottomRightFurther[0]

Global $PixelMine[0]
Global $PixelElixir[0]
Global $PixelDarkElixir[0]
Global $PixelNearCollector[0]

Global $PixelRedArea[0]
Global $PixelRedAreaFurther[0]

Global $hBitmapFirst
Global Enum $eVectorLeftTop, $eVectorRightTop, $eVectorLeftBottom, $eVectorRightBottom


;Debug CLick
Global $debugClick = 0


Global $DESTOLoc = ""

Global $dropAllOnSide = 1

; Info Profile
Global $AttacksWon = 0
Global $DefensesWon = 0
Global $TroopsDonated = 0
Global $TroopsReceived = 0

Global $LootFileName = ""

; End Battle
Global $sTimeStopAtk, $sTimeStopAtk2
Global $ichkTimeStopAtk = 1
Global $ichkTimeStopAtk2 = 7
Global $ichkEndNoResources
Global $ichkTimeStopAtk, $ichkTimeStopAtk2
Global $stxtMinGoldStopAtk2 = 1000, $stxtMinElixirStopAtk2 = 1000, $stxtMinDarkElixirStopAtk2 = 50
Global $ichkEndOneStar = 0, $ichkEndTwoStars = 0

;ImprovedUpgradeBuildingHero
Global $aUpgrades[6][4] = [[-1, -1, -1, ""], [-1, -1, -1, ""], [-1, -1, -1, ""], [-1, -1, -1, ""], [-1, -1, -1, ""], [-1, -1, -1, ""]] ;Store upgrade position x&y, value, and loot type
Global $picUpgradeStatus[6], $ipicUpgradeStatus[6] ;Add indexable array variables for accessing the Upgrades GUI
Global $picUpgradeType[6], $txtUpgradeX[6], $txtUpgradeY[6], $chkbxUpgrade[6], $txtUpgradeValue[6]
Global $ichkbxUpgrade[6], $itxtUpgrMinGold, $itxtUpgrMinElixir, $txtUpgrMinDark, $itxtUpgrMinDark
Global $chkSaveWallBldr, $iSaveWallBldr
Global $pushLastModified = 0


;UpgradeTroops
Global $aLabPos[2] = [-1, -1]
Global $iChkLab, $iCmbLaboratory, $iFirstTimeLab

; Array to hold Laboratory Troop information [LocX of upper left corner of image, LocY of upper left corner of image, PageLocation, Troop "name", Icon # in DLL file]
Global Const $aLabTroops[25][5] = [ _
		[-1, -1, -1, "None", $eIcnBlank], _
		[123, 320 + $midOffsetY, 0, "Barbarian", $eIcnBarbarian], _
		[123, 427 + $midOffsetY, 0, "Archer", $eIcnArcher], _
		[230, 320 + $midOffsetY, 0, "Giant", $eIcnGiant], _
		[230, 427 + $midOffsetY, 0, "Goblin", $eIcnGoblin], _
		[336, 320 + $midOffsetY, 0, "Wall Breaker", $eIcnWallBreaker], _
		[336, 427 + $midOffsetY, 0, "Balloon", $eIcnBalloon], _
		[443, 320 + $midOffsetY, 0, "Wizard", $eIcnWizard], _
		[443, 427 + $midOffsetY, 0, "Healer", $eIcnHealer], _
		[550, 320 + $midOffsetY, 0, "Dragon", $eIcnDragon], _
		[550, 427 + $midOffsetY, 0, "Pekka", $eIcnPekka], _
		[657, 320 + $midOffsetY, 0, "Lightning Spell", $eIcnLightSpell], _
		[657, 427 + $midOffsetY, 0, "Healing Spell", $eIcnHealSpell], _
		[108, 320 + $midOffsetY, 1, "Rage Spell", $eIcnRageSpell], _
		[108, 427 + $midOffsetY, 1, "Jump Spell", $eIcnJumpSpell], _
		[214, 320 + $midOffsetY, 1, "Freeze Spell", $eIcnFreezeSpell], _
		[214, 427 + $midOffsetY, 1, "Poison Spell", $eIcnPoisonSpell], _
		[320, 320 + $midOffsetY, 1, "Earthquake Spell", $eIcnEarthQuakeSpell], _
		[320, 427 + $midOffsetY, 1, "Haste Spell", $eIcnHasteSpell], _
		[427, 320 + $midOffsetY, 1, "Minion", $eIcnMinion], _
		[427, 427 + $midOffsetY, 1, "Hog Rider", $eIcnHogRider], _
		[534, 320 + $midOffsetY, 1, "Valkyrie", $eIcnValkyrie], _
		[534, 427 + $midOffsetY, 1, "Golem", $eIcnGolem], _
		[640, 320 + $midOffsetY, 1, "Witch", $eIcnWitch], _
		[640, 427 + $midOffsetY, 1, "Lava Hound", $eIcnLavaHound]]

Global Const $aSearchCost[11] = _
		[10, _
		50, _
		75, _
		110, _
		170, _
		250, _
		380, _
		580, _
		750, _
		900, _
		1000]

;deletefiles
Global $ichkDeleteLogs = 0
Global $iDeleteLogsDays = 7
Global $ichkDeleteTemp = 0
Global $iDeleteTempDays = 7
Global $ichkDeleteLoots = 0
Global $iDeleteLootsDays = 7

;dispose windows
Global $idisposewindows
Global $icmbDisposeWindowsPos

Global $iWAOffsetX = 0
Global $iWAOffsetY = 0

;Planned hours
Global $iPlannedDonateHours[24]
Global $iPlannedRequestCCHours[24]
Global $iPlannedDropCCHours[24]
Global $iPlannedDonateHoursEnable
Global $iPlannedRequestCCHoursEnable
Global $iPlannedDropCCHoursEnable
Global $iPlannedBoostBarracksEnable
Global $iPlannedBoostBarracksHours[24]

; Share attack
Global $iShareAttack = 0
Global $iShareminGold
Global $iShareminElixir
Global $iSharemindark
Global $sShareMessage
Global $iShareMessageEnable = 0
Global $iShareMessageSearch = 0
Global $iShareAttackNow = 0

Global $dLastShareDateApp = _Date_Time_GetLocalTime()
Global $dLastShareDate = _DateAdd("n", -60, _Date_Time_SystemTimeToDateTimeStr($dLastShareDateApp, 1))

Global $iScreenshotType = 0
Global $ichkScreenshotHideName = 1

Global $ichkTotalCampForced = 0
Global $iValueTotalCampForced = 200

Global $iMakeScreenshotNow = False

Global $lastversion = "" ;latest version from GIT
Global $lastmessage = "" ;message for last version
Global $ichkVersion = 1
Global $oldversmessage = "" ;warning message for old bot

;BarracksStatus
Global $numBarracks = 0
Global $numBarracksAvaiables = 0
Global $numDarkBarracks = 0
Global $numDarkBarracksAvaiables = 0
Global $numFactorySpell = 0
Global $numFactorySpellAvaiables = 0
Global $numFactoryDarkSpell = 0
Global $numFactoryDarkSpellAvaiables = 0

;position of barakcs
Global $btnpos = [[114, 535 + $midOffsetY], [228, 535 + $midOffsetY], [288, 535 + $midOffsetY], [348, 535 + $midOffsetY], [409, 535 + $midOffsetY], [494, 535 + $midOffsetY], [555, 535 + $midOffsetY], [637, 535 + $midOffsetY], [698, 535 + $midOffsetY]]
;barracks and spells avaiables
Global $Trainavailable = [1, 0, 0, 0, 0, 0, 0, 0, 0]

; Attack Report
Global $BonusLeagueG, $BonusLeagueE, $BonusLeagueD, $LeagueShort
Global $League[22][4] = [ _
		["0", "Bronze III", "0", "B3"], ["1000", "Bronze II", "0", "B2"], ["1300", "Bronze I", "0", "B1"], _
		["2600", "Silver III", "0", "S3"], ["3700", "Silver II", "0", "S2"], ["4800", "Silver I", "0", "S1"], _
		["10000", "Gold III", "0", "G3"], ["13500", "Gold II", "0", "G2"], ["15000", "Gold I", "0", "G1"], _
		["40000", "Crystal III", "120", "c3"], ["55000", "Crystal II", "220", "c2"], ["70000", "Crystal I", "320", "c1"], _
		["110000", "Master III", "560", "M3"], ["135000", "Master II", "740", "M2"], ["160000", "Master I", "920", "M1"], _
		["200000", "Champion III", "1220", "C3"], ["225000", "Champion II", "1400", "C2"],["250000", "Champion I", "1580", "C1"], _
		["280000", "Titan III", "1880", "T3"], ["300000", "Titan II", "2060", "T2"],["320000", "Titan I", "2240", "T1"], _
		["340000", "Legend", "2400", "LE"]]

Global $iTaBChkAttack = 0x01
Global $iTaBChkIdle = 0x02 ; Define global variables for Take a Break early detection types

;Building Side (DES/TH) Switch and DESide End Early
Global Enum $eSideBuildingDES, $eSideBuildingTH
Global $BuildingLoc, $BuildingLocX = 0, $BuildingLocY = 0
Global $dropQueen, $dropKing
Global $BuildingEdge, $BuildingToLoc = ""
Global $saveiChkTimeStopAtk, $saveiChkTimeStopAtk2, $saveichkEndOneStar, $saveichkEndTwoStars
Global $DarkLow
Global $DESideEB, $DELowEndMin, $DisableOtherEBO
Global $DEEndAq, $DEEndBk, $DEEndOneStar
Global $SpellDP[2] = [0, 0]; Spell drop point for DE attack

;Snipe While Train
Global $isSnipeWhileTrain = False
Global $SnipeChangedSettings = False
Global $tempSnipeWhileTrain[8] = [0, 0, 0, 0, 0, 0, 0, 0]
Global $iChkSnipeWhileTrain = 0
Global $itxtSearchlimit = 15
Global $itxtminArmyCapacityTHSnipe = 35
Global $itxtSWTtiles = 1

Global $iChkRestartSearchLimit  = 0
Global $iRestartSearchlimit = 15
Global $Is_SearchLimit = False

Global $canRequestCC = True


; Heroes upgrade
Global $ichkUpgradeKing = 0
Global $ichkUpgradeQueen = 0
Global $ichkUpgradeWarden = 0

; Barbarian King/Queen Upgrade Costs = Dark Elixir in xxxK
Global $aKingUpgCost[40] = [10, 12.5, 15, 17.5, 20, 22.5, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 175, 180, 185, 190]
Global $aQueenUpgCost[40] = [40, 22.5, 25, 27.5, 30, 32.5, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 175, 180, 185, 190, 195, 200]
; Grand Warden Upgrade Costs = Elixir in xx.xK
Global $aWardenUpgCost[20] = [6, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.4, 8.8, 9.1, 9.4, 9.6, 9.8, 10]

; OpenCloseCoc
Global $MinorObstacle = False

;Languages
Global Const $dirLanguages = @ScriptDir & "\Languages\"
Global Const $sGUILanguagesINI = "Languages.ini"
Global Const $sGUILanguages = $dirLanguages & $sGUILanguagesINI

Global $sLanguage = "English"
Global Const $sDefaultLanguage = "English"
Global $aLanguage[1][1] ;undimmed language array

;images
Global $iDetectedImageType = 0
Global $iDeadBase75percent = 0
Global $iDeadBase75percentStartLevel = 0
