; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Variables
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: $action_groupe, $group_de_controle
; Return values .: None
; Author ........: Boju(2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;Search
Global $Style_GUI
Global $groupSearchDB=$grpDBFilter&"#"&$cmbDBMeetGE&"#"&$txtDBMinGold&"#"&$picDBMinGold&"#"&$txtDBMinElixir&"#"&$picDBMinElixir&"#"&$txtDBMinGoldPlusElixir&"#"&$picDBMinGPEGold&"#"&$chkDBMeetDE&"#"&$txtDBMinDarkElixir&"#"&$picDBMinDarkElixir&"#"&$chkDBMeetTrophy&"#"&$txtDBMinTrophy&"#"&$picDBMinTrophies&"#"&$chkDBMeetTH&"#"&$cmbDBTH&"#"&$picDBMaxTH10&"#"&$chkDBMeetTHO&"#"&$chkDBWeakBase&"#"&$chkDBMeetOne&"#"&$cmbDBWeakMortar&"#"&$picDBWeakMortar&"#"&$cmbDBWeakWizTower&"#"&$picDBWeakWizTower
Global $groupHerosDB=$picDBHeroesWait&"#"&$txtDBHeroesWait&"#"&$chkDBKingWait&"#"&$chkDBQueenWait&"#"&$chkDBWardenWait&"#"&$IMGchkDBKingWait&"#"&$IMGchkDBQueenWait&"#"&$IMGchkDBWardenWait

Global $groupSearchAB=$grpABFilter&"#"&$cmbABMeetGE&"#"&$txtABMinGold&"#"&$picABMinGold&"#"&$txtABMinElixir&"#"&$picABMinElixir&"#"&$txtABMinGoldPlusElixir&"#"&$picABMinGPEGold&"#"&$chkABMeetDE&"#"&$txtABMinDarkElixir&"#"&$picABMinDarkElixir&"#"&$chkABMeetTrophy&"#"&$txtABMinTrophy&"#"&$picABMinTrophies&"#"&$chkABMeetTH&"#"&$cmbABTH&"#"&$picABMaxTH10&"#"&$chkABMeetTHO&"#"&$chkABWeakBase&"#"&$chkABMeetOne&"#"&$cmbABWeakMortar&"#"&$picABWeakMortar&"#"&$cmbABWeakWizTower&"#"&$picABWeakWizTower
Global $groupHerosAB=$picABHeroesWait&"#"&$txtABHeroesWait&"#"&$chkABKingWait&"#"&$chkABQueenWait&"#"&$chkABWardenWait&"#"&$IMGchkABKingWait&"#"&$IMGchkABQueenWait&"#"&$IMGchkABWardenWait

Global $groupSearchTS=$grpTSFilter&"#"&$cmbTSMeetGE&"#"&$txtTSMinGold&"#"&$picTSMinGold&"#"&$txtTSMinElixir&"#"&$picTSMinElixir&"#"&$txtTSMinGoldPlusElixir&"#"&$picTSMinGPEGold&"#"&$chkTSMeetDE&"#"&$txtTSMinDarkElixir&"#"&$picTSMinDarkElixir&"#"&$lblAddTiles&"#"&$lblAddTiles2&"#"&$lblSWTTiles&"#"&$txtSWTTiles&"#"&$lblTHadd&"#"&$txtTHaddtiles

;Attack
;Global $groupAttackDB=$lblDBTitle&"#"&$lblDBAlgorithm&"#"&$cmbDBAlgorithm&"#"&$lblDBSelectTroop&"#"&$cmbDBSelectTroop&"#"&$lblDBSelectSpecialTroop&"#"&$chkDBKingAttack&"#"&$chkDBQueenAttack&"#"&$chkDBWardenAttack&"#"&$chkDBDropCC&"#"&$chkDBLightSpell&"#"&$chkDBHealSpell&"#"&$chkDBRageSpell&"#"&$chkDBJumpSpell&"#"&$chkDBFreezeSpell&"#"&$chkDBPoisonSpell&"#"&$chkDBEarthquakeSpell&"#"&$chkDBHasteSpell
Global $groupAttackDB=$lblDBAlgorithm&"#"&$cmbDBAlgorithm&"#"&$lblDBSelectTroop&"#"&$cmbDBSelectTroop&"#"&$lblDBSelectSpecialTroop&"#"&$chkDBKingAttack&"#"&$chkDBQueenAttack&"#"&$chkDBWardenAttack&"#"&$chkDBDropCC&"#"&$chkDBLightSpell&"#"&$chkDBHealSpell&"#"&$chkDBRageSpell&"#"&$chkDBJumpSpell&"#"&$chkDBFreezeSpell&"#"&$chkDBPoisonSpell&"#"&$chkDBEarthquakeSpell&"#"&$chkDBHasteSpell
Global $groupAttackDBSpell=$chkDBLightSpell&"#"&$chkDBHealSpell&"#"&$chkDBRageSpell&"#"&$chkDBJumpSpell&"#"&$chkDBFreezeSpell&"#"&$chkDBPoisonSpell&"#"&$chkDBEarthquakeSpell&"#"&$chkDBHasteSpell
Global $groupIMGAttackDB=$IMGchkDBKingAttack&"#"&$IMGchkDBQueenAttack&"#"&$IMGchkDBWardenAttack&"#"&$IMGchkDBDropCC&"#"&$IMGchkDBLightSpell&"#"&$IMGchkDBHealSpell&"#"&$IMGchkDBRageSpell&"#"&$IMGchkDBJumpSpell&"#"&$IMGchkDBFreezeSpell&"#"&$IMGchkDBPoisonSpell&"#"&$IMGchkDBEarthquakeSpell&"#"&$IMGchkDBHasteSpell
Global $groupIMGAttackDBSpell=$IMGchkDBLightSpell&"#"&$IMGchkDBHealSpell&"#"&$IMGchkDBRageSpell&"#"&$IMGchkDBJumpSpell&"#"&$IMGchkDBFreezeSpell&"#"&$IMGchkDBPoisonSpell&"#"&$IMGchkDBEarthquakeSpell&"#"&$IMGchkDBHasteSpell

Global $groupAttackAB=$lblABAlgorithm&"#"&$cmbABAlgorithm&"#"&$lblABSelectTroop&"#"&$cmbABSelectTroop&"#"&$lblABSelectSpecialTroop&"#"&$chkABKingAttack&"#"&$chkABQueenAttack&"#"&$chkABWardenAttack&"#"&$chkABDropCC&"#"&$chkABLightSpell&"#"&$chkABHealSpell&"#"&$chkABRageSpell&"#"&$chkABJumpSpell&"#"&$chkABFreezeSpell&"#"&$chkABPoisonSpell&"#"&$chkABEarthquakeSpell&"#"&$chkABHasteSpell
Global $groupAttackABSpell=$chkABLightSpell&"#"&$chkABHealSpell&"#"&$chkABRageSpell&"#"&$chkABJumpSpell&"#"&$chkABFreezeSpell&"#"&$chkABPoisonSpell&"#"&$chkABEarthquakeSpell&"#"&$chkABHasteSpell
Global $groupIMGAttackAB=$IMGchkABKingAttack&"#"&$IMGchkABQueenAttack&"#"&$IMGchkABWardenAttack&"#"&$IMGchkABDropCC&"#"&$IMGchkABLightSpell&"#"&$IMGchkABHealSpell&"#"&$IMGchkABRageSpell&"#"&$IMGchkABJumpSpell&"#"&$IMGchkABFreezeSpell&"#"&$IMGchkABPoisonSpell&"#"&$IMGchkABEarthquakeSpell&"#"&$IMGchkABHasteSpell
Global $groupIMGAttackABSpell=$IMGchkABLightSpell&"#"&$IMGchkABHealSpell&"#"&$IMGchkABRageSpell&"#"&$IMGchkABJumpSpell&"#"&$IMGchkABFreezeSpell&"#"&$IMGchkABPoisonSpell&"#"&$IMGchkABEarthquakeSpell&"#"&$IMGchkABHasteSpell

Global $groupAttackTS=$grpABAttack&"#"&$lblAttackTHType&"#"&$cmbAttackTHType&"#"&$lblTSSelectTroop&"#"&$cmbTSSelectTroop&"#"&$lblTSSelectSpecialTroop&"#"&$chkTSKingAttack&"#"&$chkTSQueenAttack&"#"&$chkTSWardenAttack&"#"&$chkTSDropCC&"#"&$chkTSLightSpell&"#"&$chkTSHealSpell&"#"&$chkTSRageSpell&"#"&$chkTSJumpSpell&"#"&$chkTSFreezeSpell&"#"&$chkTSPoisonSpell&"#"&$chkTSEarthquakeSpell&"#"&$chkTSHasteSpell
Global $groupAttackTSSpell=$chkTSLightSpell&"#"&$chkTSHealSpell&"#"&$chkTSRageSpell&"#"&$chkTSJumpSpell&"#"&$chkTSFreezeSpell&"#"&$chkTSPoisonSpell&"#"&$chkTSEarthquakeSpell&"#"&$chkTSHasteSpell
Global $groupIMGAttackTS=$IMGchkTSKingAttack&"#"&$IMGchkTSQueenAttack&"#"&$IMGchkTSWardenAttack&"#"&$IMGchkTSDropCC&"#"&$IMGchkTSLightSpell&"#"&$IMGchkTSHealSpell&"#"&$IMGchkTSRageSpell&"#"&$IMGchkTSJumpSpell&"#"&$IMGchkTSFreezeSpell&"#"&$IMGchkTSPoisonSpell&"#"&$IMGchkTSEarthquakeSpell&"#"&$IMGchkTSHasteSpell
Global $groupIMGAttackTSSpell=$IMGchkTSLightSpell&"#"&$IMGchkTSHealSpell&"#"&$IMGchkTSRageSpell&"#"&$IMGchkTSJumpSpell&"#"&$IMGchkTSFreezeSpell&"#"&$IMGchkTSPoisonSpell&"#"&$IMGchkTSEarthquakeSpell&"#"&$IMGchkTSHasteSpell


;Global $groupHerosTS=$chkTSKingWait&"#"&$chkTSQueenWait&"#"&$chkTSWardenWait&"#"&$IMGchkTSKingWait&"#"&$IMGchkTSQueenWait&"#"&$IMGchkTSWardenWait
;End Battle
Global $groupEndBattkeDB=$grpDBEndBattle&"#"&$chkDBTimeStopAtk&"#"&$lblDBTimeStopAtka&"#"&$txtDBTimeStopAtk&"#"&$lblDBTimeStopAtk&"#"&$chkDBTimeStopAtk2&"#"&$chkDBTimeStopAtk2&"#"&$lblDBTimeStopAtk2a&"#"&$txtDBTimeStopAtk2&"#"&$lblDBTimeStopAtk2&"#"&$lblDBMinRerourcesAtk2&"#"&$txtDBMinGoldStopAtk2&"#"&$picDBMinGoldStopAtk2&"#"&$txtDBMinElixirStopAtk2&"#"&$picDBMinElixirStopAtk2&"#"&$txtDBMinDarkElixirStopAtk2&"#"&$picDBMinDarkElixirStopAtk2&"#"&$chkDBEndNoResources&"#"&$chkDBEndOneStar&"#"&$chkDBEndTwoStars
Global $groupEndBattkeAB=$grpABEndBattle&"#"&$chkABTimeStopAtk&"#"&$lblABTimeStopAtka&"#"&$txtABTimeStopAtk&"#"&$lblABTimeStopAtk&"#"&$chkABTimeStopAtk2&"#"&$chkABTimeStopAtk2&"#"&$lblABTimeStopAtk2a&"#"&$txtABTimeStopAtk2&"#"&$lblABTimeStopAtk2&"#"&$lblABMinRerourcesAtk2&"#"&$txtABMinGoldStopAtk2&"#"&$picABMinGoldStopAtk2&"#"&$txtABMinElixirStopAtk2&"#"&$picABMinElixirStopAtk2&"#"&$txtABMinDarkElixirStopAtk2&"#"&$picABMinDarkElixirStopAtk2&"#"&$chkABEndNoResources&"#"&$chkABEndOneStar&"#"&$chkABEndTwoStars
Global $groupEndBattkeTS=$grpTSEndBattle&"#"&$chkTSTimeStopAtk&"#"&$lblTSTimeStopAtka&"#"&$txtTSTimeStopAtk&"#"&$lblTSTimeStopAtk&"#"&$chkTSTimeStopAtk2&"#"&$chkTSTimeStopAtk2&"#"&$lblTSTimeStopAtk2a&"#"&$txtTSTimeStopAtk2&"#"&$lblTSTimeStopAtk2&"#"&$lblTSMinRerourcesAtk2&"#"&$txtTSMinGoldStopAtk2&"#"&$picTSMinGoldStopAtk2&"#"&$txtTSMinElixirStopAtk2&"#"&$picTSMinElixirStopAtk2&"#"&$txtTSMinDarkElixirStopAtk2&"#"&$picTSMinDarkElixirStopAtk2&"#"&$chkTSEndNoResources&"#"&$chkTSEndOneStar&"#"&$chkTSEndTwoStars

Global $groupKingSleeping=$IMGchkDBKingSleepWait&"#"&$IMGchkABKingSleepWait&"#"&$IMGchkKingSleepWait
Global $groupQueenSleeping=$IMGchkDBQueenSleepWait&"#"&$IMGchkABQueenSleepWait&"#"&$IMGchkQueenSleepWait
Global $groupWardenSleeping=$IMGchkDBWardenSleepWait&"#"&$IMGchkABWardenSleepWait&"#"&$IMGchkWardenSleepWait

;Troops Dark
Global $groupTroopsDark=$lblMinion&"#"&$lblHogRiders&"#"&$lblValkyries&"#"&$lblGolems&"#"&$lblWitches&"#"&$lblLavaHounds&"#"&$lblTimesMinions&"#"&$lblTimesHogRiders&"#"&$lblTimesValkyries&"#"&$lblTimesGolems&"#"&$lblTimesWitches&"#"&$lblTimesLavaHounds&"#"&$icnMini&"#"&$icnHogs&"#"&$icnValk&"#"&$icnGole&"#"&$icnWitc&"#"&$icnLava
;Troops 1
Global $groupTroops1=$grpTroops&"#"&$lblBarbarians&"#"&$lblArchers&"#"&$lblGoblins&"#"&$txtNumBarb&"#"&$txtNumArch&"#"&$txtNumGobl&"#"&$icnBarb&"#"&$icnArch&"#"&$icnGobl&"#"&$lblPercentBarbarians&"#"&$lblPercentArchers&"#"&$lblPercentGoblins&"#"&$lblTotalCount&"#"&$lblTotalTroops&"#"&$lblPercentTotal
Global $groupTroopsBarb=$grpTroops&"#"&$lblBarbarians&"#"&$txtNumBarb&"#"&$icnBarb&"#"&$lblPercentBarbarians
Global $groupTroopsArch=$grpTroops&"#"&$lblArchers&"#"&$txtNumArch&"#"&$icnArch&"#"&$lblPercentArchers
Global $groupTroopsGobl=$grpTroops&"#"&$lblGoblins&"#"&$txtNumGobl&"#"&$icnGobl&"#"&$lblPercentGoblins
Global $groupTroopsGiant=$grpOtherTroops&"#"&$lblGiants&"#"&$lblTimesGiants&"#"&$txtNumGiant&"#"&$icnGiant
Global $groupTroopsWall=$grpOtherTroops&"#"&$lblWallBreakers&"#"&$lblTimesWallBreakers&"#"&$txtNumWall&"#"&$icnWall
Global $groupTroopsTot=$lblTotalCount&"#"&$lblTotalTroops&"#"&$lblPercentTotal
;Troops 2
Global $groupTroops2=$grpOtherTroops&"#"&$lblGiants&"#"&$lblWallBreakers&"#"&$lblBalloons&"#"&$lblWizards&"#"&$lblHealers&"#"&$lblDragons&"#"&$lblPekka&"#"&$lblTimesGiants&"#"&$lblTimesWallBreakers&"#"&$lblTimesBalloons&"#"&$lblTimesWizards&"#"&$lblTimesHealers&"#"&$lblTimesDragons&"#"&$lblTimesPekka&"#"&$txtNumGiant&"#"&$txtNumWall&"#"&$txtNumWiza&"#"&$txtNumHeal&"#"&$txtNumBall&"#"&$txtNumDrag&"#"&$txtNumPekk&"#"&$icnGiant&"#"&$icnWall&"#"&$icnWiza&"#"&$icnHeal&"#"&$icnBall&"#"&$icnDrag&"#"&$icnPekk

;Speel Army Training
Global $groupTxtSpeels=$txtNumLightningSpell&"#"&$txtNumHealSpell&"#"&$txtNumRageSpell&"#"&$txtNumJumpSpell&"#"&$txtNumFreezeSpell&"#"&$txtNumPoisonSpell&"#"&$txtNumEarthSpell&"#"&$txtNumHasteSpell
;Speel
Global $groupLightning =$lblLightningIcon&"#"&$lblLightningSpell&"#"&$txtNumLightningSpell&"#"&$lblTimesLightS
Global $groupHeal =$lblHealIcon&"#"&$lblHealSpell&"#"&$txtNumHealSpell&"#"&$lblTimesHealS
Global $groupRage =$lblRageIcon&"#"&$lblRageSpell&"#"&$txtNumRageSpell&"#"&$lblTimesRageS
Global $groupJumpSpell =$lblJumpSpellIcon&"#"&$lblJumpSpell&"#"&$txtNumJumpSpell&"#"&$lblTimesJumpS
Global $groupFreeze =$lblFreezeIcon&"#"&$lblFreezeSpell&"#"&$txtNumFreezeSpell&"#"&$lblFreezeS
;Dark Speel
Global $groupPoison =$lblPoisonIcon&"#"&$lblPoisonSpell&"#"&$txtNumPoisonSpell&"#"&$lblTimesPoisonS
Global $groupEarthquake =$lblEarthquakeIcon&"#"&$lblEarthquakeSpell&"#"&$txtNumEarthSpell&"#"&$lblTimesEarthquakeS
Global $groupHaste =$lblHasteIcon&"#"&$lblHasteSpell&"#"&$txtNumHasteSpell&"#"&$lblTimesHasteS

Global $groupListSpeel=$groupLightning&"#"&$groupHeal&"#"&$groupRage&"#"&$groupJumpSpell&"#"&$groupFreeze&"#"&$groupPoison&"#"&$groupEarthquake&"#"&$groupHaste

;Walls
Global $iNbrOfWallsUpped = 0
Global $itxtWall04ST=0, $itxtWall05ST=0, $itxtWall06ST=0, $itxtWall07ST=0, $itxtWall08ST=0, $itxtWall09ST=0, $itxtWall10ST=0, $itxtWall11ST=0

;TH Level
Global $groupListTHLevels=$THLevels04&"#"&$THLevels05&"#"&$THLevels06&"#"&$THLevels07&"#"&$THLevels08&"#"&$THLevels09&"#"&$THLevels10&"#"&$THLevels11



