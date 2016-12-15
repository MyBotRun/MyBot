; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Variables
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: $action_groupe, $group_de_controle
; Return values .: None
; Author ........: Boju(2016)
; Modified ......: MR.ViPER (11-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;Search

;Global $Style_GUI

Global Const $groupSearchDB = $grpDBFilter&"#"&$cmbDBMeetGE&"#"&$txtDBMinGold&"#"&$picDBMinGold&"#"&$txtDBMinElixir&"#"&$picDBMinElixir&"#"&$txtDBMinGoldPlusElixir&"#"&$picDBMinGPEGold&"#"&$chkDBMeetDE&"#"&$txtDBMinDarkElixir&"#"& _
	$picDBMinDarkElixir&"#"&$chkDBMeetTrophy&"#"&$txtDBMinTrophy&"#"&$picDBMinTrophies&"#"&$chkDBMeetTH&"#"&$cmbDBTH&"#"&$picDBMaxTH10&"#"&$chkDBMeetTHO&"#"&$chkDBMeetOne&"#"&$chkMaxMortar[$DB]&"#"&$cmbWeakMortar[$DB]&"#"& _
	$picDBWeakMortar&"#"&$chkMaxWizTower[$DB]&"#"&$cmbWeakWizTower[$DB]&"#"&$picDBWeakWizTower&"#"&$chkMaxXBow[$DB]&"#"&$cmbWeakXBow[$DB]&"#"&$picDBWeakXbow&"#"&$chkMaxInferno[$DB]&"#"&$cmbWeakInferno[$DB]&"#"&$picDBWeakInferno&"#"&$chkMaxEagle[$DB]&"#"&$cmbWeakEagle[$DB]&"#"&$picDBWeakEagle
Global Const $groupHerosDB=$picDBHeroesWait&"#"&$txtDBHeroesWait&"#"&$chkDBKingWait&"#"&$chkDBQueenWait&"#"&$chkDBWardenWait&"#"&$IMGchkDBKingWait&"#"&$IMGchkDBQueenWait&"#"&$IMGchkDBWardenWait

Global Const $groupSearchAB=$grpABFilter&"#"&$cmbABMeetGE&"#"&$txtABMinGold&"#"&$picABMinGold&"#"&$txtABMinElixir&"#"&$picABMinElixir&"#"&$txtABMinGoldPlusElixir&"#"&$picABMinGPEGold&"#"&$chkABMeetDE&"#"&$txtABMinDarkElixir&"#"& _
	$picABMinDarkElixir&"#"&$chkABMeetTrophy&"#"&$txtABMinTrophy&"#"&$picABMinTrophies&"#"&$chkABMeetTH&"#"&$cmbABTH&"#"&$picABMaxTH10&"#"&$chkABMeetTHO&"#"&$chkABMeetOne&"#"&$chkMaxMortar[$LB]&"#"&$cmbWeakMortar[$LB]&"#"& _
	$picABWeakMortar&"#"&$chkMaxWizTower[$LB]&"#"&$cmbWeakWizTower[$LB]&"#"&$picABWeakWizTower&"#"&$chkMaxXBow[$LB]&"#"&$cmbWeakXBow[$LB]&"#"&$picABWeakXbow&"#"&$chkMaxInferno[$LB]&"#"&$cmbWeakInferno[$LB]&"#"&$picABWeakInferno&"#"&$chkMaxEagle[$LB]&"#"&$cmbWeakEagle[$LB]&"#"&$picABWeakEagle
Global Const $groupHerosAB=$picABHeroesWait&"#"&$txtABHeroesWait&"#"&$chkABKingWait&"#"&$chkABQueenWait&"#"&$chkABWardenWait&"#"&$IMGchkABKingWait&"#"&$IMGchkABQueenWait&"#"&$IMGchkABWardenWait

Global Const $groupSpellsDB=$chkDBSpellsWait&"#"&$IMGchkDBLightSpellWait&"#"&$IMGchkDBHealSpellWait&"#"&$IMGchkDBRageSpellWait&"#"&$IMGchkDBJumpSpellWait&"#"&$IMGchkDBFreezeSpellWait&"#"&$IMGchkDBPoisonSpellWait&"#"&$IMGchkDBEarthquakeSpellWait&"#"&$IMGchkDBHasteSpellWait
Global Const $groupSpellsAB=$chkABSpellsWait&"#"&$IMGchkABLightSpellWait&"#"&$IMGchkABHealSpellWait&"#"&$IMGchkABRageSpellWait&"#"&$IMGchkABJumpSpellWait&"#"&$IMGchkABFreezeSpellWait&"#"&$IMGchkABPoisonSpellWait&"#"&$IMGchkABEarthquakeSpellWait&"#"&$IMGchkABHasteSpellWait

Global Const $groupSearchTS=$grpTSFilter&"#"&$cmbTSMeetGE&"#"&$txtTSMinGold&"#"&$picTSMinGold&"#"&$txtTSMinElixir&"#"&$picTSMinElixir&"#"&$txtTSMinGoldPlusElixir&"#"&$picTSMinGPEGold&"#"&$chkTSMeetDE&"#"&$txtTSMinDarkElixir&"#"&$picTSMinDarkElixir&"#"&$lblAddTiles&"#"&$lblAddTiles2&"#"&$lblSWTTiles&"#"&$txtSWTTiles&"#"&$lblTHadd&"#"&$txtTHaddtiles

;Attack
;Global $groupAttackDB=$lblDBTitle&"#"&$lblDBAlgorithm&"#"&$cmbDBAlgorithm&"#"&$lblDBSelectTroop&"#"&$cmbDBSelectTroop&"#"&$lblDBSelectSpecialTroop&"#"&$chkDBKingAttack&"#"&$chkDBQueenAttack&"#"&$chkDBWardenAttack&"#"&$chkDBDropCC&"#"&$chkDBLightSpell&"#"&$chkDBHealSpell&"#"&$chkDBRageSpell&"#"&$chkDBJumpSpell&"#"&$chkDBFreezeSpell&"#"&$chkDBPoisonSpell&"#"&$chkDBEarthquakeSpell&"#"&$chkDBHasteSpell
Global Const $groupAttackDB=$cmbDBAlgorithm&"#"&$cmbDBSelectTroop&"#"&$chkDBKingAttack&"#"&$chkDBQueenAttack&"#"&$chkDBWardenAttack&"#"&$chkDBDropCC&"#"&$chkDBLightSpell&"#"&$chkDBHealSpell&"#"&$chkDBRageSpell&"#"&$chkDBJumpSpell&"#"&$chkDBFreezeSpell&"#"&$chkDBPoisonSpell&"#"&$chkDBEarthquakeSpell&"#"&$chkDBHasteSpell&"#"&$chkDBSkeletonSpell&"#"&$chkDBCloneSpell
Global Const $groupAttackDBSpell=$chkDBLightSpell&"#"&$chkDBHealSpell&"#"&$chkDBRageSpell&"#"&$chkDBJumpSpell&"#"&$chkDBFreezeSpell&"#"&$chkDBPoisonSpell&"#"&$chkDBEarthquakeSpell&"#"&$chkDBHasteSpell&"#"&$chkDBSkeletonSpell&"#"&$chkDBCloneSpell
Global Const $groupIMGAttackDB=$IMGchkDBKingAttack&"#"&$IMGchkDBQueenAttack&"#"&$IMGchkDBWardenAttack&"#"&$IMGchkDBDropCC&"#"&$IMGchkDBLightSpell&"#"&$IMGchkDBHealSpell&"#"&$IMGchkDBRageSpell&"#"&$IMGchkDBJumpSpell&"#"&$IMGchkDBFreezeSpell&"#"&$IMGchkDBPoisonSpell&"#"&$IMGchkDBEarthquakeSpell&"#"&$IMGchkDBHasteSpell
Global Const $groupIMGAttackDBSpell=$IMGchkDBLightSpell&"#"&$IMGchkDBHealSpell&"#"&$IMGchkDBRageSpell&"#"&$IMGchkDBJumpSpell&"#"&$IMGchkDBFreezeSpell&"#"&$IMGchkDBPoisonSpell&"#"&$IMGchkDBEarthquakeSpell&"#"&$IMGchkDBHasteSpell&"#"&$IMGchkDBSkeletonSpell&"#"&$IMGchkDBCloneSpell

Global Const $groupAttackAB=$cmbABAlgorithm&"#"&$cmbABSelectTroop&"#"&$chkABKingAttack&"#"&$chkABQueenAttack&"#"&$chkABWardenAttack&"#"&$chkABDropCC&"#"&$chkABLightSpell&"#"&$chkABHealSpell&"#"&$chkABRageSpell&"#"&$chkABJumpSpell&"#"&$chkABFreezeSpell&"#"&$chkABPoisonSpell&"#"&$chkABEarthquakeSpell&"#"&$chkABHasteSpell&"#"&$chkABSkeletonSpell&"#"&$chkABCloneSpell
Global Const $groupAttackABSpell=$chkABLightSpell&"#"&$chkABHealSpell&"#"&$chkABRageSpell&"#"&$chkABJumpSpell&"#"&$chkABFreezeSpell&"#"&$chkABPoisonSpell&"#"&$chkABEarthquakeSpell&"#"&$chkABHasteSpell&"#"&$chkABSkeletonSpell&"#"&$chkABCloneSpell
Global Const $groupIMGAttackAB=$IMGchkABKingAttack&"#"&$IMGchkABQueenAttack&"#"&$IMGchkABWardenAttack&"#"&$IMGchkABDropCC&"#"&$IMGchkABLightSpell&"#"&$IMGchkABHealSpell&"#"&$IMGchkABRageSpell&"#"&$IMGchkABJumpSpell&"#"&$IMGchkABFreezeSpell&"#"&$IMGchkABPoisonSpell&"#"&$IMGchkABEarthquakeSpell&"#"&$IMGchkABHasteSpell
Global Const $groupIMGAttackABSpell=$IMGchkABLightSpell&"#"&$IMGchkABHealSpell&"#"&$IMGchkABRageSpell&"#"&$IMGchkABJumpSpell&"#"&$IMGchkABFreezeSpell&"#"&$IMGchkABPoisonSpell&"#"&$IMGchkABEarthquakeSpell&"#"&$IMGchkABHasteSpell&"#"&$IMGchkABSkeletonSpell&"#"&$IMGchkABCloneSpell

Global Const $groupAttackTS=$grpABAttack&"#"&$lblAttackTHType&"#"&$cmbAttackTHType&"#"&$lblTSSelectTroop&"#"&$cmbTSSelectTroop&"#"&$lblTSSelectSpecialTroop&"#"&$chkTSKingAttack&"#"&$chkTSQueenAttack&"#"&$chkTSWardenAttack&"#"&$chkTSDropCC&"#"&$chkTSLightSpell&"#"&$chkTSHealSpell&"#"&$chkTSRageSpell&"#"&$chkTSJumpSpell&"#"&$chkTSFreezeSpell&"#"&$chkTSPoisonSpell&"#"&$chkTSEarthquakeSpell&"#"&$chkTSHasteSpell
Global Const $groupAttackTSSpell=$chkTSLightSpell&"#"&$chkTSHealSpell&"#"&$chkTSRageSpell&"#"&$chkTSJumpSpell&"#"&$chkTSFreezeSpell&"#"&$chkTSPoisonSpell&"#"&$chkTSEarthquakeSpell&"#"&$chkTSHasteSpell
Global Const $groupIMGAttackTS=$IMGchkTSKingAttack&"#"&$IMGchkTSQueenAttack&"#"&$IMGchkTSWardenAttack&"#"&$IMGchkTSDropCC&"#"&$IMGchkTSLightSpell&"#"&$IMGchkTSHealSpell&"#"&$IMGchkTSRageSpell&"#"&$IMGchkTSJumpSpell&"#"&$IMGchkTSFreezeSpell&"#"&$IMGchkTSPoisonSpell&"#"&$IMGchkTSEarthquakeSpell&"#"&$IMGchkTSHasteSpell
Global Const $groupIMGAttackTSSpell=$IMGchkTSLightSpell&"#"&$IMGchkTSHealSpell&"#"&$IMGchkTSRageSpell&"#"&$IMGchkTSJumpSpell&"#"&$IMGchkTSFreezeSpell&"#"&$IMGchkTSPoisonSpell&"#"&$IMGchkTSEarthquakeSpell&"#"&$IMGchkTSHasteSpell


;Global $groupHerosTS=$chkTSKingWait&"#"&$chkTSQueenWait&"#"&$chkTSWardenWait&"#"&$IMGchkTSKingWait&"#"&$IMGchkTSQueenWait&"#"&$IMGchkTSWardenWait
;End Battle
Global Const $groupEndBattkeDB=$grpDBEndBattle&"#"&$chkDBTimeStopAtk&"#"&$lblDBTimeStopAtka&"#"&$txtDBTimeStopAtk&"#"&$lblDBTimeStopAtk&"#"&$chkDBTimeStopAtk2&"#"&$chkDBTimeStopAtk2&"#"&$lblDBTimeStopAtk2a&"#"&$txtDBTimeStopAtk2&"#"&$lblDBTimeStopAtk2&"#"&$lblDBMinRerourcesAtk2&"#"&$txtDBMinGoldStopAtk2&"#"&$picDBMinGoldStopAtk2&"#"&$txtDBMinElixirStopAtk2&"#"&$picDBMinElixirStopAtk2&"#"&$txtDBMinDarkElixirStopAtk2&"#"&$picDBMinDarkElixirStopAtk2&"#"&$chkDBEndNoResources&"#"&$chkDBEndOneStar&"#"&$chkDBEndTwoStars
Global Const $groupEndBattkeAB=$grpABEndBattle&"#"&$chkABTimeStopAtk&"#"&$lblABTimeStopAtka&"#"&$txtABTimeStopAtk&"#"&$lblABTimeStopAtk&"#"&$chkABTimeStopAtk2&"#"&$chkABTimeStopAtk2&"#"&$lblABTimeStopAtk2a&"#"&$txtABTimeStopAtk2&"#"&$lblABTimeStopAtk2&"#"&$lblABMinRerourcesAtk2&"#"&$txtABMinGoldStopAtk2&"#"&$picABMinGoldStopAtk2&"#"&$txtABMinElixirStopAtk2&"#"&$picABMinElixirStopAtk2&"#"&$txtABMinDarkElixirStopAtk2&"#"&$picABMinDarkElixirStopAtk2&"#"&$chkABEndNoResources&"#"&$chkABEndOneStar&"#"&$chkABEndTwoStars
;Global $groupEndBattkeTS=$grpTSEndBattle&"#"&$chkTSTimeStopAtk&"#"&$lblTSTimeStopAtka&"#"&$txtTSTimeStopAtk&"#"&$lblTSTimeStopAtk&"#"&$chkTSTimeStopAtk2&"#"&$chkTSTimeStopAtk2&"#"&$lblTSTimeStopAtk2a&"#"&$txtTSTimeStopAtk2&"#"&$lblTSTimeStopAtk2&"#"&$lblTSMinRerourcesAtk2&"#"&$txtTSMinGoldStopAtk2&"#"&$picTSMinGoldStopAtk2&"#"&$txtTSMinElixirStopAtk2&"#"&$picTSMinElixirStopAtk2&"#"&$txtTSMinDarkElixirStopAtk2&"#"&$picTSMinDarkElixirStopAtk2&"#"&$chkTSEndNoResources&"#"&$chkTSEndOneStar&"#"&$chkTSEndTwoStars

Global Const $groupKingSleeping=$IMGchkDBKingSleepWait&"#"&$IMGchkABKingSleepWait&"#"&$IMGchkKingSleepWait
Global Const $groupQueenSleeping=$IMGchkDBQueenSleepWait&"#"&$IMGchkABQueenSleepWait&"#"&$IMGchkQueenSleepWait
Global Const $groupWardenSleeping=$IMGchkDBWardenSleepWait&"#"&$IMGchkABWardenSleepWait&"#"&$IMGchkWardenSleepWait

Global Const $groupCloseWaitTrain=$chkCloseWaitTrain&"#"&$btnCloseWaitStop&"#"&$picCloseWaitTrain&"#"&$btnCloseWaitStopRandom&"#"&$picCloseWaitStop&"#"&$btnCloseWaitExact&"#"&$picCloseWaitExact&"#"&$btnCloseWaitRandom&"#"&$cmbCloseWaitRdmPercent&"#"&$lblCloseWaitRdmPercent

Global Const $grpTrainTroops=$txtNumBarb&"#"&$txtNumArch&"#"&$txtNumGiant&"#"&$txtNumGobl&"#"&$txtNumWall&"#"&$txtNumBall&"#"&$txtNumWiza&"#"&$txtNumHeal&"#"&$txtNumDrag&"#"&$txtNumPekk&"#"&$txtNumBabyD&"#"&$txtNumMine&"#"&$txtNumMini&"#"&$txtNumHogs&"#"&$txtNumValk&"#"&$txtNumGole&"#"&$txtNumWitc&"#"&$txtNumLava&"#"&$txtNumBowl
Global Const $grpCookSpell=$txtNumLSpell&"#"&$txtNumHSpell&"#"&$txtNumRSpell&"#"&$txtNumJSpell&"#"&$txtNumFSpell&"#"&$txtNumCSpell&"#"&$txtNumPSpell&"#"&$txtNumESpell&"#"&$txtNumHaSpell&"#"&$txtNumSkSpell

;Spell
Global Const $groupLightning =$lblLSpellIcon&"#"&$txtNumLSpell&"#"&$txtLevLSpell
Global Const $groupHeal =$lblHSpellIcon&"#"&$txtNumHSpell&"#"&$txtLevHSpell
Global Const $groupRage =$lblRSpellIcon&"#"&$txtNumRSpell&"#"&$txtLevRSpell
Global Const $groupJumpSpell =$lblJSpellIcon&"#"&$txtNumJSpell&"#"&$txtLevJSpell
Global Const $groupFreeze =$lblFSpellIcon&"#"&$txtNumFSpell&"#"&$txtLevFSpell
Global Const $groupClone = $lblCSpellIcon&"#"&$txtNumCSpell&"#"&$txtLevCSpell
;Groups for If Level is '0'
Global Const $groupIcnLightning =$lblLSpellIcon&"#"&$txtLevLSpell
Global Const $groupIcnHeal =$lblHSpellIcon&"#"&$txtLevHSpell
Global Const $groupIcnRage =$lblRSpellIcon&"#"&$txtLevRSpell
Global Const $groupIcnJumpSpell =$lblJSpellIcon&"#"&$txtLevJSpell
Global Const $groupIcnFreeze =$lblFSpellIcon&"#"&$txtLevFSpell
Global Const $groupIcnClone = $lblCSpellIcon&"#"&$txtLevCSpell

;Dark Spell
Global Const $groupPoison =$lblPSpellIcon&"#"&$txtNumPSpell&"#"&$txtLevPSpell
Global Const $groupEarthquake =$lblESpellIcon&"#"&$txtNumESpell&"#"&$txtLevESpell
Global Const $groupHaste =$lblHaSpellIcon&"#"&$txtNumHaSpell&"#"&$txtLevHaSpell
Global Const $groupSkeleton =$lblSeSpellIcon&"#"&$txtNumSkSpell&"#"&$txtLevSkSpell
;Groups for If Level is '0'
Global Const $groupIcnPoison =$lblPSpellIcon&"#"&$txtLevPSpell
Global Const $groupIcnEarthquake =$lblESpellIcon&"#"&$txtLevESpell
Global Const $groupIcnHaste =$lblHaSpellIcon&"#"&$txtLevHaSpell
Global Const $groupIcnSkeleton =$lblSeSpellIcon&"#"&$txtLevSkSpell

Global Const $groupListSpells=$groupLightning&"#"&$groupHeal&"#"&$groupRage&"#"&$groupJumpSpell&"#"&$groupFreeze&"#"&$groupClone&"#"&$groupPoison&"#"&$groupEarthquake&"#"&$groupHaste&"#"&$groupSkeleton

;TH Level
Global Const $groupListTHLevels=$THLevels04&"#"&$THLevels05&"#"&$THLevels06&"#"&$THLevels07&"#"&$THLevels08&"#"&$THLevels09&"#"&$THLevels10&"#"&$THLevels11

;League
Global Const $groupLeague=$UnrankedLeague&"#"&$BronzeLeague&"#"&$SilverLeague&"#"&$GoldLeague &"#"&$CrystalLeague&"#"&$MasterLeague&"#"&$ChampionLeague&"#"&$TitanLeague&"#"&$LegendLeague
