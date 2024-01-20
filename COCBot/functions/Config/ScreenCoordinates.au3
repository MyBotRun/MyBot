; #Variables# ====================================================================================================================
; Name ..........: Screen Position Variables
; Description ...: Global variables for commonly used X|Y positions, screen check color, and tolerance
; Syntax ........: $aXXXXX[Y]  : XXXX is name of point or item being checked, Y = 2 for position only, or 4 when color/tolerance value included
; Author ........:
; Modified ......: Moebius (09/2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; 	   $aiSomeVar = [StartX, StartY, EndX, EndY]
;Global $aiClickAwayRegionLeft = [225, 10, 255, 30]
;Global $aiClickAwayRegionRight = [605, 10, 645, 30]
;Let's tighten these up to avoid clicking on shields.
Global $aiClickAwayRegionLeft = [235, 10, 245, 30]
Global $aiClickAwayRegionRight = [640, 10, 650, 30]

Global $aiClickAwayRegionLeft2 = [75, 88, 145, 98]
Global $aiClickAwayRegionRight2 = [760, 176, 835, 185]

Global $aCenterEnemyVillageClickDrag = [65, 545] ; Scroll village using this location in the water
Global $aCenterHomeVillageClickDrag = [430, 650] ; Scroll village using this location in the water
Global $aIsMain[4] = [378, 10, 0x7ABDE3, 15] ; Main Screen, Builder Info Icon / October 2023 -37103
Global $aIsMainGrayed[4] = [378, 10, 0x3D5F72, 15] ; Main Screen, Builder Info Icon grayed
Global $aIsBuilderBaseGrayed[4] = [369, 9, 0x3F5F6F, 15] ; Builder Base, Builder Info Icon grayed
Global $aIsOnBuilderBase[4] = [838, 18, 0xffff45, 10] ; Check the Gold Coin from resources , is a square not round
Global $aAttackButton[2] = [60, 614 + $g_iBottomOffsetY] ; Attack Button, Main Screen
Global $aFindMatchButton[4] = [470, 20 + $g_iBottomOffsetY, 0xD8A420, 10] ; Find Multiplayer Match Button, Attack Screen 860x780 without shield
Global $aIsAttackShield[4] = [250, 415 + $g_iMidOffsetY, 0xE8E8E0, 10] ; Attack window, white shield verification window
Global $aAway[2] = [175, 10] ; Away click, moved from 1,1 to prevent scroll window from top, moved from 0,10 to 175,32 to prevent structure click or 175,10 to just fix MEmu 2.x opening and closing toolbar
Global $aAway2[2] = [235, 10] ; Second Away Position for Windows like Donate Window where at $aAway is a button
Global $aNoShield[4] = [524, 18, 0x494C4D, 15] ; Main Screen, charcoal pixel center of shield when no shield is present / BS5.10 March 2023
Global $aHaveShield[4] = [523, 19, 0xEBF7FB, 15] ; Main Screen, Silver pixel top center of shield
Global $aHavePerGuard[4] = [523, 19, 0x7E4CDB, 15] ; Main Screen, Purple Pixel Top of Shield
Global $aShieldInfoButton[4] = [515, 10, 0x7ABDE3, 15] ; Main Screen, Blue pixel upper part of "i"
Global $aIsShieldInfo[4] = [675, 155, 0xFF8D95, 20] ; Main Screen, Shield Info window, red pixel right of X
Global $aSurrenderButton[4] = [70, 545 + $g_iBottomOffsetY, 0xCE0D0E, 40] ; Surrender Button, Attack Screen (End Battle August 2023)
Global $aConfirmSurrender[4] = [535, 435 + $g_iMidOffsetY, 0x6DBC1F, 30] ; Confirm Surrender Button, Attack Screen, green color on button?
Global $aCancelFight[4] = [822, 48, 0xD80408, 20] ; Cancel Fight Scene
Global $aCancelFight2[4] = [830, 59, 0xD80408, 20] ; Cancel Fight Scene 2nd pixel
Global $aEndFightSceneBtn[4] = [429, 529 + $g_iMidOffsetY, 0xE1F989, 20] ; Victory or defeat scene button = green top of button
Global $aEndFightSceneAvl[4] = [241, 196 + $g_iMidOffsetY, 0xFFF098, 20] ; Victory or defeat scene left side ribbon = light gold
Global $aEndFightSceneReportGold = $aEndFightSceneAvl ; Missing... TripleM ???
Global $aReturnHomeButton[4] = [430, 566 + $g_iMidOffsetY, 0x6CBB1F, 15] ; Return Home Button, End Battle Screen
Global $aChatTab[4] = [388, 280 + $g_iMidOffsetY, 0xFFAA22, 20] ; Chat Window Open, Main Screen
Global $aChatTab2[4] = [388, 290 + $g_iMidOffsetY, 0xFDA32B, 20] ; Chat Window Open, Main Screen
Global $aChatTab3[4] = [388, 335 + $g_iMidOffsetY, 0xCB5517, 20] ; Chat Window Open, Main Screen
Global $aOpenChat[2] = [19, 309 + $g_iMidOffsetY] ; Open Chat Windows, Main Screen
Global $aClanTab[2] = [189, 24] ; Clan Tab, Chat Window, Main Screen
Global $aClanInfo[2] = [282, 55] ; Clan Info Icon
Global $aArmyCampSize[2] = [153, 168 + $g_iMidOffsetY] ; Training Window, Overview screen, Current Size/Total Size
Global $aSiegeMachineSize[2] = [707, 168 + $g_iMidOffsetY] ; Training Window, Overview screen, Current Number/Total Number
Global $aArmySpellSize[2] = [143, 296 + $g_iMidOffsetY] ; Training Window Overviewscreen, current number/total capacity
Global $g_aArmyCCSpellSize[2] = [465, 428 + $g_iMidOffsetY] ; Training Window, Overview Screen, Current CC Spell number/total cc spell capacity
Global $aArmyCCRemainTime[2] = [730, 526 + $g_iMidOffsetY] ; Training Window Overviewscreen, Minutes & Seconds remaining till can request again
Global $aIsCampFull[4] = [82, 177 + $g_iMidOffsetY, 0xFFFFFF, 10] ; Training Window, Overview screen White pixel in check mark with camp IS full
Global $aBuildersDigits[2] = [424, 21] ; Main Screen, Free/Total Builders
Global $aBuildersDigitsBuilderBase[2] = [0, 21] ; Main Screen on Builders Base Free/Total Builders
Global $aTrophies[2] = [69, 84] ; Main Screen, Trophies
Global $aNoCloudsAttack[4] = [25, 606, 0xCD0D0D, 15] ; Attack Screen: No More Clouds
Global $aArmyTrainButton[2] = [40, 525 + $g_iBottomOffsetY] ; Main Screen, Army Train Button
Global $aWonOneStar[4] = [714, 538 + $g_iBottomOffsetY, 0xC0C8C0, 20] ; Center of 1st Star for winning attack on enemy
Global $aWonTwoStar[4] = [739, 538 + $g_iBottomOffsetY, 0xC0C8C0, 20] ; Center of 2nd Star for winning attack on enemy
Global $aWonThreeStar[4] = [763, 538 + $g_iBottomOffsetY, 0xC0C8C0, 20] ; Center of 3rd Star for winning attack on enemy
Global $aIsAtkDarkElixirFull[4] = [743, 62 + $g_iMidOffsetY, 0x270D33, 10] ; Attack Screen DE Resource bar is full
Global $aIsDarkElixirFull[4] = [707, 102 + $g_iMidOffsetY, 0x270D33, 10] ; Main Screen DE Resource bar is full
Global $aIsGoldFull[4] = [657, 2 + $g_iMidOffsetY, 0xE7C00D, 10] ; Main Screen Gold Resource bar is Full
Global $aIsElixirFull[4] = [657, 52 + $g_iMidOffsetY, 0xC027C0, 10] ; Main Screen Elixir Resource bar is Full
Global $aPerkBtn[4] = [95, 243 + $g_iMidOffsetY, 0x7CD8E8, 10] ; Clan Info Page, Perk Button (blue); 800x780
Global $aIsGemWindow1[4] = [608, 240 + $g_iMidOffsetY, 0xEB1617, 20] ; Main Screen, pixel left of Red X to close gem window
Global $aIsGemWindow2[4] = [610, 246 + $g_iMidOffsetY, 0xCD161A, 20] ; Main Screen, pixel below Red X to close gem window
Global $aIsGemWindow3[4] = [625, 246 + $g_iMidOffsetY, 0xCE1519, 20] ; Main Screen, pixel below Red X to close gem window
Global $aIsGemWindow4[4] = [640, 246 + $g_iMidOffsetY, 0xCD151C, 20] ; Main Screen, pixel below Red X to close gem window
Global $aIsTrainPgChk1[4] = [760, 120 + $g_iMidOffsetY, 0xFF8D95, 10] ; Main Screen, Train page open - left upper corner of x button. Updated 16.0.4
Global $aRtnHomeCloud1[4] = [56, 592 + $g_iBottomOffsetY, 0x0A223F, 15] ; Cloud Screen, during search, blue pixel in left eye
Global $aRtnHomeCloud2[4] = [72, 592 + $g_iBottomOffsetY, 0x103F7E, 15] ; Cloud Screen, during search, blue pixel in right eye
Global $aDetectLang[2] = [16, 634 + $g_iBottomOffsetY] ; Detect Language, bottom left Attack button must read "Attack"
Global $aGreenArrowTrainTroops[2] = [325, 122 + $g_iMidOffsetY]
Global $aGreenArrowBrewSpells[2] = [460, 122 + $g_iMidOffsetY]
Global $aGreenArrowTrainSiegeMachines[2] = [595, 122 + $g_iMidOffsetY]
Global $g_aShopWindowOpen[4] = [804, 54, 0xC00508, 15] ; Red pixel in lower right corner of RED X to close shop window
Global $aTreasuryWindow[4] = [695, 138 + $g_iMidOffsetY, 0xFF8D95, 20] ; Redish pixel above X to close treasury window
Global $aAttackForTreasury[4] = [88, 619 + $g_iMidOffsetY, 0xF0EBE8, 5] ; Red pixel below X to close treasury window
Global $aAtkHasDarkElixir[4] = [31, 121 + $g_iMidOffsetY, 0x282020, 10]  ; Attack Page, Check for DE icon ; New 23 August offset
Global $aVillageHasDarkElixir[4] = [837, 134, 0x3D2D3D, 10] ; Main Page, Base has dark elixir storage

Global $aCheckTopProfile[4] = [130, 350 + $g_iMidOffsetY, 0x6B7899, 5]
Global $aCheckTopProfile2[4] = [160, 455 + $g_iMidOffsetY, 0x4E4D79, 5]

Global $aIsTabOpen[4] = [0, 145 + $g_iMidOffsetY, 0xECECE5, 25] ;Check if specific Tab is opened, X Coordinate is a dummy

Global $aReceivedTroops[4] = [185, 235 + $g_iMidOffsetY, 0xFFFFFF, 20] ; Y of You have received blabla from xx!
Global $aReceivedTroopsOCR[4] = [400, 178 + $g_iMidOffsetY, 0xFFFFFF, 20] ; Y of You have received blabla from xx!
Global $aReceivedSieges[4] = [650, 235 + $g_iMidOffsetY, 0xFFFFFF, 20] ; Y of You have received blabla from xx!
Global $aReceivedTroopsDoubleOCR[4] = [400, 170 + $g_iMidOffsetY, 0xFFFFFF, 20] ; Y of You have received blabla from xx!
Global $aReceivedTroopsDouble[4] = [380, 220 + $g_iMidOffsetY, 0xFFFFFF, 20] ; Y of You have received blabla from xx!
Global $aReceivedTroopsTab[4] = [207, 140 + $g_iMidOffsetY, 0xFFFFFF, 20] ; Y of You have received blabla from xx!
Global $aReceivedTroopsTreasury[4] = [660, 140 + $g_iMidOffsetY, 0xFFFFFF, 20] ; Y of You have received blabla from xx!
Global $aReceivedTroopsWeeklyDeals[4] = [175, 195 + $g_iMidOffsetY, 0xFFFFFF, 20] ; Y of You have received blabla from xx!

; King Health Bar, check at the middle of the bar, index - 10 is x-offset added to middle of health bar
Global $aKingHealth = [-1, 569 + $g_iBottomOffsetY, 0x00D500, 15, 10]
; Queen Health Bar, check at the middle of the bar, index - 5 is x-offset added to middle of health bar
Global $aQueenHealth = [-1, 569 + $g_iBottomOffsetY, 0x00D500, 15, 5]
; Warden Health Bar, check at the middle of the bar, index - 10 is x-offset added to middle of health bar
Global $aWardenHealth = [-1, 567 + $g_iBottomOffsetY, 0x00D500, 15, 10]
; Champion Health Bar, check at the middle of the bar, index - 2 is x-offset added to middle of health bar
Global $aChampionHealth = [-1, 566 + $g_iBottomOffsetY, 0x00D500, 15, 2]

; attack report... stars won
Global $aWonOneStarAtkRprt[4] = [325, 180 + $g_iMidOffsetY, 0xC8CaC4, 30] ; Center of 1st Star reached attacked village
Global $aWonTwoStarAtkRprt[4] = [398, 180 + $g_iMidOffsetY, 0xD0D6D0, 30] ; Center of 2nd Star reached attacked village
Global $aWonThreeStarAtkRprt[4] = [534, 180 + $g_iMidOffsetY, 0xC8CAC7, 30] ; Center of 3rd Star reached attacked village
; pixel color: location information								BS 850MB (Reg GFX), BS 500MB (Med GFX) : location

Global $NextBtn[4] = [720, 536 + $g_iBottomOffsetY, 0xE5510D, 20] ;  Next Button
Global $a12OrMoreSlots[4] = [20, 579 + $g_iBottomOffsetY, 0x86DEFC, 25] ; Attackbar Check if 12+ Slots exist / BS5
Global $a12OrMoreSlots2[4] = [20, 580 + $g_iBottomOffsetY, 0xFF4040, 25] ; Attackbar Check if 12+ Slots exist SuperTroops / BS5
Global $aDoubRowAttackBar[4] = [68, 486, 0xFC5D64, 20]
Global $aTroopIsDeployed[4] = [0, 0, 0x404040, 20] ; Attackbar Remain Check X and Y are Dummies
Global Const $aIsAttackPage[4] = [50, 548 + $g_iBottomOffsetY, 0xD10D0E, 20] ; red button "end battle" - left portion

; 1 - Dark Gray : Castle filled/No Castle | 2 - Light Green : Available or Already made | 3 - White : Available or Castle filled/No Castle
Global $aRequestTroopsAO[6] = [714, 538 + $g_iMidOffsetY, 0x919191, 0x6DB630, 0xFFFFFF, 25] ; Button Request Troops in Army Overview  (x,y, Gray - Full/No Castle, Green - Available or Already, White - Available or Full)

;attackreport
Global Const $aAtkRprtDECheck[4] = [459, 372 + $g_iMidOffsetY, 0x2F1F37, 20] ; August 23 update
Global Const $aAtkRprtTrophyCheck[4] = [327, 189 + $g_iMidOffsetY, 0x514224, 30] ; August 23 update
Global Const $aAtkRprtDECheck2[4] = [686, 415 + $g_iMidOffsetY, 0x302440, 30] ; August 23 update

;returnhome
Global Const $aRtnHomeCheck1[4] = [363, 548 + $g_iMidOffsetY, 0x78C11C, 20]
Global Const $aRtnHomeCheck2[4] = [497, 548 + $g_iMidOffsetY, 0x79C326, 20]

Global Const $aProfileReport[4] = [594, 456 + $g_iMidOffsetY, 0x4E4D79, 20] ; Dark Purple of Profile Page when no Attacks were made

Global $aArmyTrainButtonRND[4] = [20, 540 + $g_iMidOffsetY, 55, 570 + $g_iMidOffsetY] ; Main Screen, Army Train Button, RND  Screen 860x732
Global $aAttackButtonRND[4] = [20, 610 + $g_iMidOffsetY, 100, 670 + $g_iMidOffsetY] ; Attack Button, Main Screen, RND  Screen 860x732
Global $aFindMatchButtonRND[4] = [200, 510 + $g_iMidOffsetY, 300, 530 + $g_iMidOffsetY] ; Find Multiplayer Match Button, Both Shield or without shield Screen 860x732
Global $NextBtnRND[4] = [710, 530 + $g_iMidOffsetY, 830, 570 + $g_iMidOffsetY] ;  Next Button

;Switch Account
Global $aLoginWithSupercellID[4] = [280, 640 + $g_iMidOffsetY, 0xDCF684, 20] ; Upper green button section "Log in with Supercell ID" 0xB1E25A
Global $aLoginWithSupercellID2[4] = [266, 653 + $g_iMidOffsetY, 0xFFFFFF, 10]  ; White Font "Log in with Supercell ID"
Global $aButtonSetting[4] = [824, 555 + $g_iMidOffsetY, 0xFFFFFF, 10] ; Setting button, Main Screen
Global $aIsSettingPage[4] = [778, 65 + $g_iMidOffsetY, 0xFF9095, 10] ; Main Screen, Setting page open - left upper corner of x button

;Google Play
Global $aListAccount[4] = [635, 230 + $g_iMidOffsetY, 0xFFFFFF, 20] ; Accounts list google, White
Global $aButtonVillageLoad[4] = [515, 411 + $g_iMidOffsetY, 0x6EBD1F, 20] ; Load button, Green
Global $aTextBox[4] = [320, 160 + $g_iMidOffsetY, 0xFFFFFF, 10] ; Text box, White
Global $aButtonVillageOkay[4] = [500, 170 + $g_iMidOffsetY, 0x81CA2D, 20] ; Okay button, Green

;SuperCell ID
Global $aButtonConnectedSCID[4] = [640, 160 + $g_iMidOffsetY, 0x2D89FD, 20] ; Setting screen, Supercell ID Connected button (Blue Part)
Global $aCloseTabSCID[4] = [831, 57] ; Button Close Supercell ID tab

;Train
Global $aButtonEditArmy[4] = [700, 495 + $g_iMidOffsetY, 0xD0F078, 25]
Global $aButtonRemoveTroopsOK1[4] = [723, 509 + $g_iMidOffsetY, 0xDAF582, 20]
Global $aButtonRemoveTroopsOK2[4] = [530, 435 + $g_iMidOffsetY, 0x6DBC1F, 20]

;Change Language To English
Global $aButtonLanguage[4] = [265, 381 + $g_iMidOffsetY, 0xDDF685, 20]
Global $aListLanguage[4] = [95, 85 + $g_iMidOffsetY, 0xFFFFFF, 10]
Global $aEnglishLanguage[4] = [420, 145 + $g_iMidOffsetY, 0xD7D5C7, 20]
Global $aLanguageOkay[4] = [533, 435 + $g_iMidOffsetY, 0x6DBC1F, 20]

;Personal Challenges
Global Const $aPersonalChallengeOpenButton1[4] = [149, 631 + $g_iBottomOffsetY, 0xB7D0E4, 20] ; Personal Challenge Button
Global Const $aPersonalChallengeOpenButton2[4] = [149, 631 + $g_iBottomOffsetY, 0xFDE575, 20] ; Personal Challenge Button with Gold Pass
Global Const $aPersonalChallengeOpenButton3[4] = [164, 606 + $g_iBottomOffsetY, 0xFF1819, 20] ; Personal Challenge Button with red symbol
Global Const $aPersonalChallengeCloseButton[4] = [827, 100 + $g_iMidOffsetY, 0xEE1F23, 20] ; Personal Challenge Window Close Button - Jun23 Update
Global Const $aPersonalChallengeRewardsAvail[4] = [450, 61 + $g_iMidOffsetY, 0xFD0B0C, 20] ; Personal Challenge - Red symbol showing available rewards - Jun23 Update
Global Const $aPersonalChallengeRewardsTab[4] = [385, 105 + $g_iMidOffsetY, 0x698293, 20] ; Personal Challenge - Rewards tab unchecked with Gold Pass - Jun23 Update
Global Const $aPersonalChallengePerksTab[4] = [545, 105 + $g_iMidOffsetY, 0xA9D0EC, 20] ; Personal Challenge - Perks tab Checked - Jun23 Update
Global Const $aPersonalChallengeLeftEdge[4] = [30, 385 + $g_iMidOffsetY, 0x29231F, 20] ; Personal Challenge Window - Rewards tab - Black left edge
Global Const $aPersonalChallengeCancelBtn[4] = [288, 391 + $g_iMidOffsetY, 0xFDC875, 20] ; Personal Challenge Window - Cancel button at Storage Full msg
Global Const $aPersonalChallengeOkBtn[4] = [500, 391 + $g_iMidOffsetY, 0xDFF887, 20] ; Personal Challenge Window - Okay button at Storage Full msg

;BB Attack 2.0
Global $aBBGoldEnd[4] = [632, 400 + $g_iMidOffsetY, 0xFEFE4F, 20] ; Gold At the end Of BB attack
Global $aOkayButton[2] = [430, 540 + $g_iMidOffsetY]    ; Return Home after BB attack
Global $aOkayButtonRND[4] = [372, 530 + $g_iMidOffsetY, 484, 565 + $g_iMidOffsetY]    ; Okay button after BB attack, RND
