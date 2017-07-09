; #Variables# ====================================================================================================================
; Name ..........: Screen Position Variables
; Description ...: Global variables for commonly used X|Y positions, screen check color, and tolerance
; Syntax ........: $aXXXXX[Y]  : XXXX is name of point or item being checked, Y = 2 for position only, or 4 when color/tolerance value included
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;                                 x    y     color  tolerance
Global $aCenterEnemyVillageClickDrag = [65, 545] ; Scroll village using this location in the water
Global $aCenterHomeVillageClickDrag = [160, 665] ; Scroll village using this location in the water
Global $aIsReloadError[4] = [457, 301 + $g_iMidOffsetY, 0x33B5E5, 10] ; Pixel Search Check point For All Reload Button errors, except break ending
;Global $aIsMain[4] = [284, 28, 0x41B1CD, 20] ; Main Screen, Builder Left Eye
Global $aIsMain[4] = [284, 29, 0x1C4466, 20] ; Main Screen, Builder Left Eye :SC_okt

Global $aIsDPI125[4] = [355, 35, 0x399CB8, 15] ; Main Screen, Builder Left Eye, DPI set to 125%
Global $aIsDPI150[4] = [426, 42, 0x348FAA, 15] ; Main Screen, Builder Left Eye, DPI set to 150%
;Global $aIsMainGrayed[4] = [284, 28, 0x215B69, 15] ; Main Screen Grayed, Builder Left Eye
Global $aIsMainGrayed[4] = [284, 29, 0x0B1B29, 15] ; Main Screen Grayed, Builder Left Eye :SC_okt
Global $aIsOnBuilderIsland[4] = [838, 18, 0xffff46, 10] ; Check the Gold Coin from resources , is a square not round

Global $aTopLeftClient[4] = [1, 1, 0x000000, 0] ; TopLeftClient: Tolerance not needed
Global $aTopMiddleClient[4] = [475, 1, 0x000000, 0] ; TopMiddleClient: Tolerance not needed
Global $aTopRightClient[4] = [850, 1, 0x000000, 0] ; TopRightClient: Tolerance not needed
Global $aBottomRightClient[4] = [850, 675 + $g_iBottomOffsetY, 0x000000, 0] ; BottomRightClient: Tolerance not needed
Global $aIsInactive[4] = [457, 300 + $g_iMidOffsetY, 0x33B5E5, 20] ; COC message : 'Anyone there?'
Global $aIsConnectLost[4] = [255, 271 + $g_iMidOffsetY, 0x33B5E5, 20] ; COC message : 'Connection Lost' network error or annother device
Global $aIsCheckOOS[4] = [223, 272 + $g_iMidOffsetY, 0x33B5E5, 20] ; COC message : 'Connection Lost' network error or annother device
Global $aIsMaintenance[4] = [350, 273 + $g_iMidOffsetY, 0x33B5E5, 20] ; COC message : 'Anyone there?'
Global $aReloadButton[4] = [443, 408 + $g_iMidOffsetY, 0x282828, 10] ; Reload Coc Button after Out of Sync, 860x780
Global $aAttackButton[2] = [60, 614 + $g_iBottomOffsetY] ; Attack Button, Main Screen
Global $aFindMatchButton[4] = [195, 480 + $g_iBottomOffsetY, 0xFFBF43, 10] ; Find Multiplayer Match Button, Attack Screen 860x780 without shield
Global $aFindMatchButton2[4] = [195, 480 + $g_iBottomOffsetY, 0xE75D0D, 10] ; Find Multiplayer Match Button, Attack Screen 860x780 with shield
Global $aIsAttackShield[4] = [250, 415 + $g_iMidOffsetY, 0xE8E8E0, 10] ; Attack window, white shield verification window
Global $aAway[2] = [1, 40] ; Away click, moved from 1,1 to prevent scroll window from top
;Global $aRemoveShldButton[4] = [470, 18, 0xA80408, 10] ; Legacy - Main Screen, Red pixel lower part of Minus sign to remove shield, used to validate latest COC installed
Global $aNoShield[4] = [448, 20, 0x43484B, 15] ; Main Screen, charcoal pixel center of shield when no shield is present
Global $aHaveShield[4] = [455, 19, 0xF0F8FB, 15] ; Main Screen, Silver pixel top center of shield
Global $aHavePerGuard[4] = [455, 19, 0x10100D, 15] ; Main Screen, black pixel in sword outline top center of shield
Global $aShieldInfoButton[4] = [431, 10, 0x75BDE4, 15] ; Main Screen, Blue pixel upper part of "i"
Global $aIsShieldInfo[4] = [645, 195, 0xED1115, 20] ; Main Screen, Shield Info window, red pixel right of X
Global $aSurrenderButton[4] = [70, 545 + $g_iBottomOffsetY, 0xC00000, 40] ; Surrender Button, Attack Screen
Global $aConfirmSurrender[4] = [500, 415 + $g_iMidOffsetY, 0x60AC10, 20] ; Confirm Surrender Button, Attack Screen, green color on button?
Global $aCancelFight[4] = [822, 48, 0xD80408, 20] ; Cancel Fight Scene
Global $aCancelFight2[4] = [830, 59, 0xD80408, 20] ; Cancel Fight Scene 2nd pixel
Global $aEndFightSceneBtn[4] = [429, 519 + $g_iMidOffsetY, 0xB8E35F, 20] ; Victory or defeat scene buton = green edge
Global $aEndFightSceneAvl[4] = [241, 196 + $g_iMidOffsetY, 0xFFF090, 20] ; Victory or defeat scene left side ribbon = light gold
Global $aReturnHomeButton[4] = [376, 567 + $g_iMidOffsetY, 0x60AC10, 20] ; Return Home Button, End Battle Screen
Global $aChatTab[4] = [331, 325 + $g_iMidOffsetY, 0xF0951D, 20] ; Chat Window Open, Main Screen
Global $aChatTab2[4] = [331, 330 + $g_iMidOffsetY, 0xF0951D, 20] ; Chat Window Open, Main Screen
Global $aChatTab3[4] = [331, 335 + $g_iMidOffsetY, 0xF0951D, 20] ; Chat Window Open, Main Screen
Global $aOpenChat[2] = [19, 349 + $g_iMidOffsetY] ; Open Chat Windows, Main Screen
Global $aClanTab[2] = [189, 24] ; Clan Tab, Chat Window, Main Screen
Global $aClanInfo[2] = [282, 55] ; Clan Info Icon
Global $aArmyCampSize[2] = [110, 136 + $g_iMidOffsetY] ; Training Window, Overview screen, Current Size/Total Size
Global $aArmySpellSize[2] = [99, 284 + $g_iMidOffsetY] ; Training Window Overviewscreen, current number/total capacity
Global $g_aArmyCCSpellSize[2] = [527, 438 + $g_iMidOffsetY] ; Training Window, Overview Screen, Current CC Spell number/total cc spell capacity
Global $aArmyCCRemainTime[2] = [725, 517 + $g_iMidOffsetY] ; Training Window Overviewscreen, Minutes & Seconds remaining till can request again
Global $aIsCampNotFull[4] = [149, 150 + $g_iMidOffsetY, 0x761714, 20] ; Training Window, Overview screen Red pixel in Exclamation mark with camp is not full
Global $aIsCampFull[4] = [128, 151 + $g_iMidOffsetY, 0xFFFFFF, 10] ; Training Window, Overview screen White pixel in check mark with camp IS full (can not test for Green, as it has trees under it!)
Global $aBarrackFull[4] = [388, 154 + $g_iMidOffsetY, 0xE84D50, 20] ; Training Window, Barracks Screen, Red pixel in Exclamation mark with Barrack is full
Global $aBuildersDigits[2] = [324, 21] ; Main Screen, Free/Total Builders
Global $aBuildersDigitsBuilderBase[2] = [414, 21] ; Main Screen on Builders Base Free/Total Builders
Global $aLanguageCheck1[4] = [326, 8, 0xF9FAF9, 20] ; Main Screen Test Language for word 'Builders'
Global $aLanguageCheck2[4] = [329, 9, 0x060706, 20] ; Main Screen Test Language for word 'Builders'
Global $aLanguageCheck3[4] = [348, 12, 0x040403, 20] ; Main Screen Test Language for word 'Builders'
Global $aLanguageCheck4[4] = [354, 11, 0x090908, 20] ; Main Screen Test Language for word 'Builders'
Global $aTrophies[2] = [69, 84] ; Main Screen, Trophies
Global $aNoCloudsAttack[4] = [25, 606, 0xCD0D0D, 15] ; Attack Screen: No More Clouds
Global $aMessageButton[2] = [38, 143] ; Main Screen, Message Button
Global $aArmyTrainButton[2] = [40, 525 + $g_iBottomOffsetY] ; Main Screen, Army Train Button
Global $aWonOneStar[4] = [714, 538 + $g_iBottomOffsetY, 0xC0C8C0, 20] ; Center of 1st Star for winning attack on enemy
Global $aWonTwoStar[4] = [739, 538 + $g_iBottomOffsetY, 0xC0C8C0, 20] ; Center of 2nd Star for winning attack on enemy
Global $aWonThreeStar[4] = [763, 538 + $g_iBottomOffsetY, 0xC0C8C0, 20] ; Center of 3rd Star for winning attack on enemy
Global $aArmyOverviewTest[4] = [150, 554 + $g_iMidOffsetY, 0xBC2BD1, 20] ; Color purple of army overview  bottom left
Global $aCancRequestCCBtn[4] = [340, 250, 0xCC4010, 20] ; Red button Cancel in window request CC
Global $aSendRequestCCBtn[2] = [524, 250] ; Green button Send in window request CC
Global $atxtRequestCCBtn[2] = [430, 140] ; textbox in window request CC
Global $aIsAtkDarkElixirFull[4] = [743, 62 + $g_iMidOffsetY, 0x270D33, 10] ; Attack Screen DE Resource bar is full
Global $aIsDarkElixirFull[4] = [710, 107 + $g_iMidOffsetY, 0x270D33, 10] ; Main Screen DE Resource bar is full
Global $aIsGoldFull[4] = [661, 5 + $g_iMidOffsetY, 0xE7C00D, 10] ; Main Screen Gold Resource bar is Full
Global $aIsElixirFull[4] = [661, 57 + $g_iMidOffsetY, 0xC027C0, 10] ; Main Screen Elixir Resource bar is Full
Global $aConfirmCoCExit[2] = [515, 410 + $g_iMidOffsetY] ; CoC Confirm Exit button (no color for button as it matches grass)
Global $aPerkBtn[4] = [95, 243 + $g_iMidOffsetY, 0x7cd8e8, 10] ; Clan Info Page, Perk Button (blue); 800x780
Global $aIsGemWindow1[4] = [573, 256 + $g_iMidOffsetY, 0xEB1316, 20] ; Main Screen, pixel left of Red X to close gem window
Global $aIsGemWindow2[4] = [577, 266 + $g_iMidOffsetY, 0xCC2025, 20] ; Main Screen, pixel below Red X to close gem window
Global $aIsGemWindow3[4] = [586, 266 + $g_iMidOffsetY, 0xCC2025, 20] ; Main Screen, pixel below Red X to close gem window
Global $aIsGemWindow4[4] = [595, 266 + $g_iMidOffsetY, 0xCC2025, 20] ; Main Screen, pixel below Red X to close gem window
Global $aLootCartBtn[2] = [430, 640 + $g_iBottomOffsetY] ; Main Screen Loot Cart button
Global $aCleanYard[4] = [418, 587 + $g_iBottomOffsetY, 0xE1DEBE, 20] ; Main Screen Clean Resources - Trees , Mushrooms etc
Global $aIsTrainPgChk1[4] = [813, 80 + $g_iMidOffsetY, 0xFF8D95, 10] ; Main Screen, Train page open - left upper corner of x button
Global $aIsTrainPgChk2[4] = [762, 328 + $g_iMidOffsetY, 0xF18439, 10] ; Main Screen, Train page open - Dark Orange in left arrow
Global $aRtnHomeCloud1[4] = [56, 592 + $g_iBottomOffsetY, 0x0A223F, 15] ; Cloud Screen, during search, blue pixel in left eye
Global $aRtnHomeCloud2[4] = [72, 592 + $g_iBottomOffsetY, 0x103F7E, 15] ; Cloud Screen, during search, blue pixel in right eye
Global $aDetectLang[2] = [16, 634 + $g_iBottomOffsetY] ; Detect Language, bottom left Attack button must read "Attack"
Global $aGreenArrowTrainTroops[2] = [389, 125]
Global $aGreenArrowBrewSpells[2] = [585, 125]
Global $g_aShopWindowOpen[4] = [804, 54, 0xC00508, 15] ; Red pixel in lower right corner of RED X to close shop window
Global $aTreasuryWindow[4] = [689, 172 + $g_iMidOffsetY, 0xFF8D95, 20] ; Redish pixel above X to close treasury window
Global $aAttackForTreasury[4] = [88, 619 + $g_iMidOffsetY, 0xF0EBE8, 5] ; Red pixel below X to close treasury window
Global $aAtkHasDarkElixir[4]  = [ 31, 144, 0x282020, 10] ; Attack Page, Check for DE icon
Global $aVillageHasDarkElixir[4] = [837, 134, 0x3D2D3D, 10] ; Main Page, Base has dark elixir storage

;Global $aKingHealth          = [ -1, 572 + $g_iBottomOffsetY, 0x4FD404,110] ; Attack Screen, Check King's Health, X coordinate is dynamic, not used from array
;Global $aQueenHealth         = [ -1, 573 + $g_iBottomOffsetY, 0x4FD404,110] ; Attack Screen, Check Queen's Health, X coordinate is dynamic, not used from array

; Check healthy color RGB ( 220,255,19~27) ; the king and queen haves the same Y , but warden is a little lower ...
; King Crown ; background pixel not at green bar
Global $aKingHealth = [-1, 569 + $g_iBottomOffsetY, 0x00D500, 15] ; Attack Screen, Check King's Health, X coordinate is dynamic, not used from array   ;  -> with slot compensation 0xbfb29e
; Queen purple between crown ; background pixel not at green bar
Global $aQueenHealth = [-1, 569 + $g_iBottomOffsetY, 0x00D500, 15] ; Attack Screen, Check Queen's Health, X coordinate is dynamic, not used from array  ;  -> with slot compensation 0xe08227
; Warden hair ; background pixel not at green bar
Global $aWardenHealth = [-1, 569 + $g_iBottomOffsetY, 0x00D500, 15] ; Attack Screen, Check Warden's Health, X coordinate is dynamic, not used from array  ;  -> with slot compensation 0xe08227


;attack report... stars won
Global $aWonOneStarAtkRprt[4] = [325, 180 + $g_iMidOffsetY, 0xC8CaC4, 30] ; Center of 1st Star reached attacked village
Global $aWonTwoStarAtkRprt[4] = [398, 180 + $g_iMidOffsetY, 0xD0D6D0, 30] ; Center of 2nd Star reached attacked village
Global $aWonThreeStarAtkRprt[4] = [534, 180 + $g_iMidOffsetY, 0xC8CAC7, 30] ; Center of 3rd Star reached attacked village
;	pixel color: location information								BS 850MB (Reg GFX), BS 500MB (Med GFX) : location

Global $NextBtn[4] = [780, 546 + $g_iBottomOffsetY, 0xD34300, 20] ;  Next Button
; Someone asking troops : Color 0xD0E978 in x = 121

; 1 - Green : available | 2 - Dark gray : request already made | 3 - Light gray : Castle filled/No Castle
Global $aRequestTroopsAO[6] = [737, 565, 0xAEE056, 0x818181, 0xC2C2C2, 15] ; Button Request Troops in Army Overview  (x,y,can request, request already made, army full/no clan)

Global Const $aOpenChatTab[4] = [19, 335 + $g_iMidOffsetY, 0xE88D27, 20]
Global Const $aCloseChat[4] = [331, 330 + $g_iMidOffsetY, 0xF0951D, 20] ; duplicate with $aChatTab above, need to rename and fix all code to use one?
Global Const $aChatDonateBtnColors[4][4] = [[0x050505, 0, -4, 30], [0x89CA31, 0, 13, 15], [0x89CA31, 0, 16, 15], [0xFFFFFF, 21, 7, 5]]

;attackreport
Global Const $aAtkRprtDECheck[4] = [459, 372 + $g_iMidOffsetY, 0x433350, 20]
Global Const $aAtkRprtTrophyCheck[4] = [327, 189 + $g_iMidOffsetY, 0x3B321C, 30]
Global Const $aAtkRprtDECheck2[4] = [678, 418 + $g_iMidOffsetY, 0x030000, 30]

;returnhome
Global Const $aRtnHomeCheck1[4] = [363, 548 + $g_iMidOffsetY, 0x78C11C, 20]
Global Const $aRtnHomeCheck2[4] = [497, 548 + $g_iMidOffsetY, 0x79C326, 20]
;Global Const $aRtnHomeCheck3[4]      = [ 284,  28, 0x41B1CD, 20]

Global Const $aSearchLimit[6] = [19, 565, 104, 580, 0xD9DDCF, 10] ; (kaganus) no idea what this is for

; Builder Base
Global Const $aConfirmBoost[4] = [431, 438, 0xD9F57B, 10]

;inattackscreen
Global Const $aIsAttackPage[4] = [70, 548 + $g_iBottomOffsetY, 0xC80000, 20] ; red button "end battle" 860x780

; Bluestacks Menu - replaced with shortcut keys due removal or BS menu bar
;Global Const $aBSBackButton[4] = [ 50, 700 + $g_iBottomOffsetY, 0x000000, 10] ; Bluestacks V0.9. - V0.10. back button
;Global Const $aBSHomeButton[4] = [125, 700 + $g_iBottomOffsetY, 0x000000, 10] ; Bluestacks V0.9. - V0.10. Home button
;Global Const $aBSExitButton[4] = [820, 700 + $g_iBottomOffsetY, 0x000000, 10] ; Bluestacks V0.9. - V0.10. Exit button

;CheckImageType (Normal, Snow, etc)
Global Const $aImageTypeN1[4] = [237, 161, 0xD5A849, 30] ; Sand on Forest Edge 'Lane' 860x780
Global Const $aImageTypeN2[4] = [205, 180, 0x86A533, 30] ; Grass on Forest Edge 'Lane' 860x780
Global Const $aImageTypeS1[4] = [237, 161, 0xFEFDFD, 30] ; Snow on Forest Edge 'Lane' 860x780
Global Const $aImageTypeS2[4] = [205, 180, 0xFEFEFE, 30] ; Snow on Forest Edge 'Lane' 860x780


Global Const $ProfileRep01[4] = [600, 260, 0x71769F, 20] ; If colorcheck then village have 0 attacks and 0 defenses

Global $aArmyTrainButtonRND[4] = [20, 540 + $g_iMidOffsetY, 55, 570 + $g_iMidOffsetY] ; Main Screen, Army Train Button, RND  Screen 860x732
Global $aAttackButtonRND[4] = [20, 610 + $g_iMidOffsetY, 100, 670 + $g_iMidOffsetY] ; Attack Button, Main Screen, RND  Screen 860x732
Global $aFindMatchButtonRND[4] = [200, 510 + $g_iMidOffsetY, 300, 530 + $g_iMidOffsetY] ; Find Multiplayer Match Button, Both Shield or without shield Screen 860x732
Global $NextBtnRND[4] = [710, 530 + $g_iMidOffsetY, 830, 570 + $g_iMidOffsetY] ;  Next Button



;<><><><> TRAIN <><><><>

;-----> Troops <-----
Global $aTrainBarb[5]  = [64, 354 + $g_iMidOffsetY, 0xE0AB38, 40, False]  ; FFB620, FFB620
Global $aTrainArch[5]  = [77, 482 + $g_iMidOffsetY, 0xB82A64, 40, False]  ; 882857, 882852
Global $aTrainGiant[5] = [192, 387 + $g_iMidOffsetY, 0xF7AD78, 40, False] ; FFCE94, FFCE94
Global $aTrainGobl[5]  = [178, 487 + $g_iMidOffsetY, 0xB0DB6E, 40, False] ; A9F36A, A9F36B
Global $aTrainWall[5]  = [282, 385 + $g_iMidOffsetY, 0x000000, 40, False] ; 7B6E8F, 786C8A
Global $aTrainBall[5]  = [249, 469 + $g_iMidOffsetY, 0x64242C, 40, False] ; 781C10, 7C1C10
Global $aTrainWiza[5]  = [384, 384 + $g_iMidOffsetY, 0xF8D0B8, 40, False] ; E19179, E3937C
Global $aTrainHeal[5]  = [396, 500 + $g_iMidOffsetY, 0xF8EEE8, 40, False] ; D67244, D67244
Global $aTrainDrag[5]  = [435, 354 + $g_iMidOffsetY, 0xFDF8F6, 40, False] ; 473254, 493153
Global $aTrainPekk[5]  = [465, 493 + $g_iMidOffsetY, 0x0E0811, 40, False] ; 385470, 395671
Global $aTrainBabyD[5] = [578, 385 + $g_iMidOffsetY, 0x080000, 40, False] ; 88D464, 88D461, middle of snout
Global $aTrainMine[5]  = [568, 452 + $g_iMidOffsetY, 0x989C98, 40, False] ; 1A1815, 1B1814, right eye brow under hat
Global $aTrainMini[5] = [489, 375 + $g_iMidOffsetY, 0x7ACFF0, 40, False] ; Dark blue botton of horn
Global $aTrainHogs[5] = [500, 467 + $g_iMidOffsetY, 0xB87867, 40, False] ; 3A2620, 3B2720, brown above right ear
Global $aTrainValk[5] = [619, 398 + $g_iMidOffsetY, 0xD03E04, 40, False] ; FF6E18, FF6D18, orange right hair curl above eye
Global $aTrainGole[5] = [583, 498 + $g_iMidOffsetY, 0x534E48, 40, False] ; E1C8AD, E3C8AC, top of head
Global $aTrainWitc[5] = [696, 353 + $g_iMidOffsetY, 0x636AE5, 40, False] ; 403C68, 403D68, middle of purple hood
Global $aTrainLava[5] = [687, 475 + $g_iMidOffsetY, 0x210D00, 40, False] ; 4C4C3C, 4B4C3C, center of brown nose
Global $aTrainBowl[5] = [777, 356 + $g_iMidOffsetY, 0x8884F0, 40, False] ; 6060E7, 6060E5 ,purple on cheek

Global $aFullBarb[4] = [100, 423 + $g_iMidOffsetY, 0x6D6D6D, 20] ; Location of Elixir check pixel with normal color and Barrack Full color
Global $aFullArch[4] = [100, 529 + $g_iMidOffsetY, 0x8A8A8A, 20]
Global $aFullGiant[4] = [199, 422 + $g_iMidOffsetY, 0x676767, 20]
Global $aFullGobl[4] = [199, 523 + $g_iMidOffsetY, 0x666666, 20]
Global $aFullWall[4] = [297, 429 + $g_iMidOffsetY, 0x8D8D8D, 20]
Global $aFullBall[4] = [296, 531 + $g_iMidOffsetY, 0x898989, 20]
Global $aFullWiza[4] = [397, 421 + $g_iMidOffsetY, 0x676767, 20]
Global $aFullHeal[4]  = [398, 523 + $g_iMidOffsetY, 0x676767, 20]
Global $aFullDrag[4]  = [496, 421 + $g_iMidOffsetY, 0x676767, 20]
Global $aFullPekk[4]  = [493, 526 + $g_iMidOffsetY, 0x7D7D7D, 20]
Global $aFullBabyD[4] = [590, 423 + $g_iMidOffsetY, 0x696969, 20] ; B1B1B1, B1B1B1, reg color: 88D464
Global $aFullMine[4] = [594, 523 + $g_iMidOffsetY, 0x686868, 20] ; AEAEAE, ADADAD, reg color: 84BF5E
Global $aFullMini[4] = [456, 356 + $g_iMidOffsetY, 0x4D4D4D, 20] ; 0xC7F8F8 Most locations are only 30 decimal change in blue to gray (Dk blue chest)
Global $aFullHogs[4] = [488, 512 + $g_iMidOffsetY, 0xA4A4A4, 20] ; 0xD07C58 normal (lt brown shoulder)
Global $aFullValk[4] = [578, 370 + $g_iMidOffsetY, 0x8C8C8C, 20] ; 0xFF6E18 normal (lt orange hari curl)
Global $aFullGole[4] = [597, 509 + $g_iMidOffsetY, 0x3A3A3A, 20] ; 0xF07CD0 normal (pink eye)
Global $aFullWitc[4] = [671, 387 + $g_iMidOffsetY, 0x8D8D8D, 20] ; 0xF83DA4 normal (left pink eye) Need to fix
Global $aFullLava[4] = [721, 488 + $g_iMidOffsetY, 0x808080, 20] ; 0xFF7000 normal (Orange line above DE drop)
Global $aFullBowl[4] = [777, 407 + $g_iMidOffsetY, 0x727272, 20] ; 0x6060E8 normal (purple in cheek)

;-----> Spells <-----
Global $aTrainLSpell[5] = [ 70, 405 + $g_iMidOffsetY, 0x0A47EE, 40, False]
Global $aTrainHSpell[5] = [ 70, 505 + $g_iMidOffsetY, 0xDAAF48, 40, False]
Global $aTrainRSpell[5] = [170, 405 + $g_iMidOffsetY, 0x501886, 45, False]
Global $aTrainJSpell[5] = [170, 505 + $g_iMidOffsetY, 0x4CCC08, 40, False]
Global $aTrainFSpell[5] = [270, 405 + $g_iMidOffsetY, 0x29ADD0, 40, False]
Global $aTrainCSpell[5] = [270, 505 + $g_iMidOffsetY, 0x20DDD8, 40, False]
Global $aTrainPSpell[5] = [375, 405 + $g_iMidOffsetY, 0xF88010, 40, False]
Global $aTrainESpell[5] = [375, 505 + $g_iMidOffsetY, 0xBF8B58, 40, False]
Global $aTrainHaSpell[5] = [469, 409 + $g_iMidOffsetY, 0xf267a7, 40, False]
Global $aTrainSkSpell[5] = [475, 505 + $g_iMidOffsetY, 0xE01800, 40, False]

Global $aFullLSpell[4] = [74, 392 + $g_iMidOffsetY, 0x515151, 40]
Global $aFullHSpell[4] = [70, 505 + $g_iMidOffsetY, 0xB1B1B1, 40]
Global $aFullRSpell[4] = [186, 405 + $g_iMidOffsetY, 0x696969, 40]
Global $aFullJSpell[4] = [170, 495 + $g_iMidOffsetY, 0xABABAB, 40]
Global $aFullFSpell[4] = [266, 395 + $g_iMidOffsetY, 0x929292, 40]
Global $aFullCSpell[4] = [269, 502 + $g_iMidOffsetY, 0xA4A4A4, 40]
Global $aFullPSpell[4] = [375, 410 + $g_iMidOffsetY, 0x929292, 40]
Global $aFullESpell[4] = [370, 510 + $g_iMidOffsetY, 0x858585, 40]
Global $aFullHaSpell[4] = [470, 410 + $g_iMidOffsetY, 0x929292, 40]
Global $aFullSkSpell[4] = [475, 510 + $g_iMidOffsetY, 0x4A4A4A, 40]

Global $aTrainArmy[$eArmyCount] = [$aTrainBarb, $aTrainArch, $aTrainGiant, $aTrainGobl, $aTrainWall, $aTrainBall, $aTrainWiza, $aTrainHeal, $aTrainDrag, $aTrainPekk, $aTrainBabyD, $aTrainMine, _
								   $aTrainMini, $aTrainHogs, $aTrainValk, $aTrainGole, $aTrainWitc, $aTrainLava, $aTrainBowl, 0, 0, 0, 0, $aTrainLSpell, $aTrainHSpell, $aTrainRSpell, $aTrainJSpell, $aTrainFSpell, $aTrainCSpell, _
								   $aTrainPSpell, $aTrainESpell, $aTrainHaSpell, $aTrainSkSpell]

Global $aFullArmy[$eArmyCount] = [$aFullBarb, $aFullArch, $aFullGiant, $aFullGobl, $aFullWall, $aFullBall, $aFullWiza, $aFullHeal, $aFullDrag, $aFullPekk, $aFullBabyD, $aFullMine, _
								  $aFullMini, $aFullHogs, $aFullValk, $aFullGole, $aFullWitc, $aFullLava, $aFullBowl, 0, 0, 0, 0, $aFullLSpell, $aFullHSpell, $aFullRSpell, $aFullJSpell, $aFullFSpell, $aFullCSpell, _
								  $aFullPSpell, $aFullESpell, $aFullHaSpell, $aFullSkSpell]

								   ;Zeroes are Spaceholders for non trainable Objects like Warden


;----> Random Train Click Positions <-----
Global $xBtnTrain = 89
Global $yBtnTrain = 50
Global $xTrainOffset = 97
Global $yTrainOffset = 101
Global $xTrain = 28
Global $yTrain = 371
Global $aTrainBarbRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainGiantRND[4]= [$xTrain + ($xTrainOffset * 1), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainWallRND[4] = [$xTrain + ($xTrainOffset * 2), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 2), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainWizaRND[4] = [$xTrain + ($xTrainOffset * 3), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 3), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainDragRND[4] = [$xTrain + ($xTrainOffset * 4), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 4), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainBabyDRND[4] = [$xTrain + ($xTrainOffset * 5), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 5), $yTrain + $yBtnTrain + $g_iMidOffsetY]
$yTrain = $yTrain + $yTrainOffset
Global $aTrainArchRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainGoblRND[4] = [$xTrain + ($xTrainOffset * 1), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainBallRND[4] = [$xTrain + ($xTrainOffset * 2), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 2), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainHealRND[4] = [$xTrain + ($xTrainOffset * 3), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 3), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainPekkRND[4] = [$xTrain + ($xTrainOffset * 4), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 4), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainMineRND[4] = [$xTrain + ($xTrainOffset * 5), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 5), $yTrain + $yBtnTrain + $g_iMidOffsetY]

Global $xTrain = 445
Global $yTrain = 371
Global $aTrainMiniRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainValkRND[4] = [$xTrain + ($xTrainOffset * 1), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainWitcRND[4] = [$xTrain + ($xTrainOffset * 2), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 2), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainBowlRND[4] = [$xTrain + ($xTrainOffset * 3), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 3), $yTrain + $yBtnTrain + $g_iMidOffsetY]
$yTrain = $yTrain + $yTrainOffset
Global $aTrainHogsRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainGoleRND[4] = [$xTrain + ($xTrainOffset * 1), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainLavaRND[4] = [$xTrain + ($xTrainOffset * 2), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 2), $yTrain + $yBtnTrain + $g_iMidOffsetY]

Global $xBtnTrain = 89
Global $yBtnTrain = 50
Global $xTrainOffset = 97
Global $yTrainOffset = 101
Global $xTrain = 28
Global $yTrain = 371
Global $aTrainLSpellRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainRSpellRND[4]=  [$xTrain + ($xTrainOffset * 1), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainFSpellRND[4] = [$xTrain + ($xTrainOffset * 2), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 2), $yTrain + $yBtnTrain + $g_iMidOffsetY]
$yTrain = $yTrain + $yTrainOffset
Global $aTrainHSpellRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainJSpellRND[4] = [$xTrain + ($xTrainOffset * 1), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainCSpellRND[4] = [$xTrain + ($xTrainOffset * 2), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 2), $yTrain + $yBtnTrain + $g_iMidOffsetY]

Global $xTrain = 331
Global $yTrain = 371
Global $aTrainPSpellRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainHaSpellRND[4] = [$xTrain + ($xTrainOffset * 1), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $g_iMidOffsetY]
$yTrain = $yTrain + $yTrainOffset
Global $aTrainESpellRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $g_iMidOffsetY]
Global $aTrainSkSpellRND[4] = [$xTrain + ($xTrainOffset * 1), $yTrain + $g_iMidOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $g_iMidOffsetY]


Global $aTrainArmyRND[$eArmyCount] = [$aTrainBarbRND, $aTrainArchRND, $aTrainGiantRND, $aTrainGoblRND, $aTrainWallRND, $aTrainBallRND, $aTrainWizaRND, $aTrainHealRND, $aTrainDragRND, $aTrainPekkRND, $aTrainBabyDRND, $aTrainMineRND, _
									  $aTrainMiniRND, $aTrainHogsRND, $aTrainValkRND, $aTrainGoleRND, $aTrainWitcRND, $aTrainLavaRND, $aTrainBowlRND, 0, 0, 0, 0, $aTrainLSpellRND, $aTrainHSpellRND, $aTrainRSpellRND, $aTrainJSpell, _
								      $aTrainFSpellRND, $aTrainCSpellRND, $aTrainPSpellRND, $aTrainESpellRND, $aTrainHaSpellRND, $aTrainSkSpellRND]