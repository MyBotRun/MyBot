; #Variables# ====================================================================================================================
; Name ..........: Screen Position Variables
; Description ...: Global variables for commonly used X|Y positions, screen check color, and tolerance
; Syntax ........: $aXXXXX[Y]  : XXXX is name of point or item being checked, Y = 2 for position only, or 4 when color/tolerance value included
; Author ........: Code Gorilla #1
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;                                 x    y     color  tolerance
Global $aCenterEnemyVillageClickDrag = [65, 545] ; Scroll village using this location in the water
Global $aCenterHomeVillageClickDrag = [160, 665] ; Scroll village using this location in the water
Global $aIsReloadError[4] = [457, 301 + $midOffsetY, 0x33B5E5, 10] ; Pixel Search Check point For All Reload Button errors, except break ending
;Global $aIsMain[4] = [284, 28, 0x41B1CD, 20] ; Main Screen, Builder Left Eye
Global $aIsMain[4] = [283, 29, 0x4693BD, 20] ; Main Screen, Builder Left Eye :SC_okt

Global $aIsDPI125[4] = [355, 35, 0x399CB8, 15] ; Main Screen, Builder Left Eye, DPI set to 125%
Global $aIsDPI150[4] = [426, 42, 0x348FAA, 15] ; Main Screen, Builder Left Eye, DPI set to 150%
;Global $aIsMainGrayed[4] = [284, 28, 0x215B69, 15] ; Main Screen Grayed, Builder Left Eye
Global $aIsMainGrayed[4] = [284, 29, 0x120808, 15] ; Main Screen Grayed, Builder Left Eye :SC_okt

Global $aTopLeftClient[4] = [1, 1, 0x000000, 0] ; TopLeftClient: Tolerance not needed
Global $aTopMiddleClient[4] = [475, 1, 0x000000, 0] ; TopMiddleClient: Tolerance not needed
Global $aTopRightClient[4] = [850, 1, 0x000000, 0] ; TopRightClient: Tolerance not needed
Global $aBottomRightClient[4] = [850, 675 + $bottomOffsetY, 0x000000, 0] ; BottomRightClient: Tolerance not needed
Global $aIsInactive[4] = [457, 300 + $midOffsetY, 0x33B5E5, 20] ; COC message : 'Anyone there?'
Global $aIsConnectLost[4] = [255, 271 + $midOffsetY, 0x33B5E5, 20] ; COC message : 'Connection Lost' network error or annother device
Global $aIsCheckOOS[4] = [223, 272 + $midOffsetY, 0x33B5E5, 20] ; COC message : 'Connection Lost' network error or annother device
Global $aIsMaintenance[4] = [350, 273 + $midOffsetY, 0x33B5E5, 20] ; COC message : 'Anyone there?'
Global $aReloadButton[4] = [443, 408 + $midOffsetY, 0x282828, 10] ; Reload Coc Button after Out of Sync, 860x780
Global $aAttackButton[2] = [60, 614 + $bottomOffsetY] ; Attack Button, Main Screen
Global $aFindMatchButton[4] = [195, 480 + $bottomOffsetY, 0xF0B028, 10] ; Find Multiplayer Match Button, Attack Screen 860x780 without shield
Global $aFindMatchButton2[4] = [195, 480 + $bottomOffsetY, 0xD84D00, 10] ; Find Multiplayer Match Button, Attack Screen 860x780 with shield
Global $aIsAttackShield[4] = [250, 415 + $midOffsetY, 0xE8E8E0, 10] ; Attack window, white shield verification window
Global $aAway[2] = [1, 40] ; Away click, moved from 1,1 to prevent scroll window from top
Global $aRemoveShldButton[4] = [470, 18, 0xA80408, 10] ; Legacy - Main Screen, Red pixel lower part of Minus sign to remove shield, used to validate latest COC installed
Global $aNoShield[4] = [448, 20, 0x43484B, 15] ; Main Screen, charcoal pixel center of shield when no shield is present
Global $aHaveShield[4] = [455, 19, 0xF0F8FB, 15] ; Main Screen, Silver pixel top center of shield
Global $aHavePerGuard[4] = [455, 19, 0x12120E, 15] ; Main Screen, black pixel in sword outline top center of shield
Global $aShieldInfoButton[4] = [472, 11, 0x6DB0D3, 10] ; Main Screen, Blue pixel upper part of "i"
Global $aIsShieldInfo[4] = [645, 195, 0xE00408, 20] ; Main Screen, Shield Info window, red pixel right of X
Global $aSurrenderButton[4] = [70, 545 + $bottomOffsetY, 0xC00000, 40] ; Surrender Button, Attack Screen
Global $aConfirmSurrender[4] = [500, 415 + $midOffsetY, 0x60AC10, 20] ; Confirm Surrender Button, Attack Screen, green color on button?
Global $aCancelFight[4] = [822, 48, 0xD80408, 20] ; Cancel Fight Scene
Global $aCancelFight2[4] = [830, 59, 0xD80408, 20] ; Cancel Fight Scene 2nd pixel
Global $aEndFightSceneBtn[4] = [429, 519 + $midOffsetY, 0xB8E35F, 20] ; Victory or defeat scene buton = green edge
Global $aEndFightSceneAvl[4] = [241, 196 + $midOffsetY, 0xFFF090, 20] ; Victory or defeat scene left side ribbon = light gold
Global $aReturnHomeButton[4] = [376, 567 + $midOffsetY, 0x60AC10, 20] ; Return Home Button, End Battle Screen
Global $aChatTab[4] = [331, 330 + $midOffsetY, 0xF0951D, 20] ; Chat Window Open, Main Screen
Global $aOpenChat[2] = [19, 349 + $midOffsetY] ; Open Chat Windows, Main Screen
Global $aClanTab[2] = [189, 24] ; Clan Tab, Chat Window, Main Screen
Global $aClanInfo[2] = [282, 55] ; Clan Info Icon
Global $aArmyCampSize[2] = [110, 136 + $midOffsetY] ; Training Window, Overview screen, Current Size/Total Size
Global $aArmySpellSize[2] = [99, 284 + $midOffsetY] ; Training Window Overviewscreen, current number/total capacity
Global $aArmyCCRemainTime[2] = [725, 517 + $midOffsetY] ; Training Window Overviewscreen, Minutes & Seconds remaining till can request again
Global $aIsCampNotFull[4] = [149, 150 + $midOffsetY, 0x761714, 20] ; Training Window, Overview screen Red pixel in Exclamation mark with camp is not full
Global $aIsCampFull[4] = [128, 151 + $midOffsetY, 0xFFFFFF, 10] ; Training Window, Overview screen White pixel in check mark with camp IS full (can not test for Green, as it has trees under it!)
Global $aBarrackFull[4] = [388, 154 + $midOffsetY, 0xE84D50, 20] ; Training Window, Barracks Screen, Red pixel in Exclamation mark with Barrack is full
Global $aBuildersDigits[2] = [324, 21] ; Main Screen, Free/Total Builders
Global $aLanguageCheck1[4] = [326, 8, 0xF9FAF9, 20] ; Main Screen Test Language for word 'Builders'
Global $aLanguageCheck2[4] = [329, 9, 0x060706, 20] ; Main Screen Test Language for word 'Builders'
Global $aLanguageCheck3[4] = [348, 12, 0x040403, 20] ; Main Screen Test Language for word 'Builders'
Global $aLanguageCheck4[4] = [354, 11, 0x090908, 20] ; Main Screen Test Language for word 'Builders'
Global $aTrophies[2] = [72, 85] ; Main Screen, Trophies
Global $aNoCloudsAttack[4] = [25, 606, 0xC00000, 10] ; Attack Screen: No More Clouds
Global $aMessageButton[2] = [38, 143] ; Main Screen, Message Button
Global $aArmyTrainButton[2] = [40, 525 + $bottomOffsetY] ; Main Screen, Army Train Button
Global $aWonOneStar[4] = [714, 538 + $bottomOffsetY, 0xC0C8C0, 20] ; Center of 1st Star for winning attack on enemy
Global $aWonTwoStar[4] = [739, 538 + $bottomOffsetY, 0xC0C8C0, 20] ; Center of 2nd Star for winning attack on enemy
Global $aWonThreeStar[4] = [763, 538 + $bottomOffsetY, 0xC0C8C0, 20] ; Center of 3rd Star for winning attack on enemy
Global $aArmyOverviewTest[4] = [150, 554 + $midOffsetY, 0xBC2BD1, 20] ; Color purple of army overview  bottom left
Global $aCancRequestCCBtn[4] = [340, 250, 0xCC4010, 20] ; Red button Cancel in window request CC
Global $aSendRequestCCBtn[2] = [524, 250] ; Green button Send in window request CC
Global $atxtRequestCCBtn[2] = [430, 140] ; textbox in window request CC
Global $aIsAtkDarkElixirFull[4] = [743, 62 + $midOffsetY, 0x1A0026, 10] ; Attack Screen DE Resource bar is full
Global $aIsDarkElixirFull[4] = [710, 107 + $midOffsetY, 0x1A0026, 10] ; Main Screen DE Resource bar is full
Global $aIsGoldFull[4] = [661, 6 + $midOffsetY, 0xDAB300, 10] ; Main Screen Gold Resource bar is Full
Global $aIsElixirFull[4] = [661, 57 + $midOffsetY, 0xB31AB3, 10] ; Main Screen Elixir Resource bar is Full
Global $aConfirmCoCExit[2] = [515, 410 + $midOffsetY] ; CoC Confirm Exit button (no color for button as it matches grass)
Global $aPerkBtn[4] = [95, 243 + $midOffsetY, 0x7cd8e8, 10] ; Clan Info Page, Perk Button (blue); 800x780
Global $aIsGemWindow1[4] = [573, 256 + $midOffsetY, 0xDD0408, 20] ; Main Screen, pixel left of Red X to close gem window
Global $aIsGemWindow2[4] = [577, 266 + $midOffsetY, 0xBF1218, 20] ; Main Screen, pixel below Red X to close gem window
Global $aIsGemWindow3[4] = [586, 266 + $midOffsetY, 0xBC1218, 20] ; Main Screen, pixel below Red X to close gem window
Global $aIsGemWindow4[4] = [595, 266 + $midOffsetY, 0xBC1218, 20] ; Main Screen, pixel below Red X to close gem window
Global $aLootCartBtn[2] = [430, 640 + $bottomOffsetY] ; Main Screen Loot Cart button
Global $aCleanYard[4] = [418, 587 + $bottomOffsetY, 0xE1debe, 20] ; Main Screen Clean Resources - Trees , Mushrooms etc
Global $aIsTrainPgChk1[4]	  = [812, 97 + $midOffsetY, 0xE0070A, 10]  ; Main Screen, Train page open - Red below X
Global $aIsTrainPgChk2[4]	  = [762, 328 + $midOffsetY, 0xF18439, 10]  ; Main Screen, Train page open - Dark Orange in left arrow
Global $aRtnHomeCloud1[4]	  = [56, 592 + $bottomOffsetY, 0x0A223F, 15]  ; Cloud Screen, during search, blue pixel in left eye
Global $aRtnHomeCloud2[4]	  = [72, 592 + $bottomOffsetY, 0x103F7E, 15]  ; Cloud Screen, during search, blue pixel in right eye
Global $aDetectLang[2]	= [16, 634 + $bottomOffsetY] ; Detect Language, bottom left Attack button must read "Attack"

;Global $aKingHealth          = [ -1, 572 + $bottomOffsetY, 0x4FD404,110] ; Attack Screen, Check King's Health, X coordinate is dynamic, not used from array
;Global $aQueenHealth         = [ -1, 573 + $bottomOffsetY, 0x4FD404,110] ; Attack Screen, Check Queen's Health, X coordinate is dynamic, not used from array

; Check healthy color RGB ( 220,255,19~27) ; the king and queen haves the same Y , but warden is a little lower ...
; King Crown ; background pixel not at green bar
Global $aKingHealth = [-1, 569 + $bottomOffsetY, 0x543e20, 15] ; Attack Screen, Check King's Health, X coordinate is dynamic, not used from array   ;  -> with slot compensation 0xbfb29e
; Queen purple between crown ; background pixel not at green bar
Global $aQueenHealth = [-1, 569 + $bottomOffsetY, 0x4b35b5, 15] ; Attack Screen, Check Queen's Health, X coordinate is dynamic, not used from array  ;  -> with slot compensation 0xe08227
; Warden hair ; background pixel not at green bar
Global $aWardenHealth = [-1, 569 + $bottomOffsetY, 0xd2696c, 15] ; Attack Screen, Check Warden's Health, X coordinate is dynamic, not used from array  ;  -> with slot compensation 0xe08227


;attack report... stars won
Global $aWonOneStarAtkRprt[4] = [325, 180 + $midOffsetY, 0xC8CaC4, 30] ; Center of 1st Star reached attacked village
Global $aWonTwoStarAtkRprt[4] = [398, 180 + $midOffsetY, 0xD0D6D0, 30] ; Center of 2nd Star reached attacked village
Global $aWonThreeStarAtkRprt[4] = [534, 180 + $midOffsetY, 0xC8CAC7, 30] ; Center of 3rd Star reached attacked village

#cs (kaganus) These variables arent used anywhere????
	Global $SomeXCancelBtn[4]    = [819,  55, 0xD80400,     20]
	Global $EndBattleBtn[4]      = [71,  530 + $bottomOffsetY, 0xC00000,     20]
	Global $Attacked[4]          = [235, 209, 0x9E3826,     20]
	Global $AttackedBtn[2]       = [429, 493 + $midOffsetY]
	Global $HasClanMessage[4]    = [ 31, 313 + $midOffsetY, 0xF80B09,     20]
	Global $OpenChatBtn[2]       = [ 10, 334 + $midOffsetY]
	Global $IsClanTabSelected[4] = [204,  20, 0x6F6C4F,     20]
	Global $IsClanMessage[4]     = [ 26, 320, 0xE70400,     20]

	Global $ClanRequestTextArea[2]      = [430, 140]
	Global $ConfirmClanTroopsRequest[2] = [524,228]
	Global $CampFull[4]  	            = [328, 535 + $midOffsetY, 0xD03840,     20]

	;Global $DropTrophiesStartPoint = [34, 310]
#ce
;	pixel color: location information								BS 850MB (Reg GFX), BS 500MB (Med GFX) : location


; Troops Section
; Train Variables stores the Icon Coordinates and Color and Tolerance
; [0] = X axis | [1] = Y axis | [2] = Color | [3] = Tolerance
; Are updated on GetPosition on first train loop or when variable is -1, image detection, prepared for any future event
Global $TrainBarb[4]   = [-1, -1, -1, -1]
Global $TrainArch[4]   = [-1, -1, -1, -1]
Global $TrainGiant[4]  = [-1, -1, -1, -1]
Global $TrainGobl[4]   = [-1, -1, -1, -1]
Global $TrainWall[4]   = [-1, -1, -1, -1]
Global $TrainBall[4]   = [-1, -1, -1, -1]
Global $TrainIceW[4]   = [-1, -1, -1, -1]
Global $TrainWiza[4]   = [-1, -1, -1, -1]
Global $TrainHeal[4]   = [-1, -1, -1, -1]
Global $TrainDrag[4]   = [-1, -1, -1, -1]
Global $TrainPekk[4]   = [-1, -1, -1, -1]
Global $TrainBabyD[4]  = [-1, -1, -1, -1]
Global $TrainMine[4]   = [-1, -1, -1, -1]

; Full Variables checks if The [i] symbol on each Icon on train is gray : Troops not available to train
Global $FullBarb[4]	   = [-1, -1, -1, -1] ;
Global $FullArch[4]    = [-1, -1, -1, -1] ;
Global $FullGiant[4]    = [-1, -1, -1, -1] ;
Global $FullGobl[4]    = [-1, -1, -1, -1] ;
Global $FullWall[4]    = [-1, -1, -1, -1] ;
Global $FullBall[4]	   = [-1, -1, -1, -1] ;
Global $FullIceW[4]    = [-1, -1, -1, -1] ;
Global $FullWiza[4]    = [-1, -1, -1, -1] ;
Global $FullHeal[4]    = [-1, -1, -1, -1] ;
Global $FullDrag[4]    = [-1, -1, -1, -1] ;
Global $FullPekk[4]    = [-1, -1, -1, -1] ;
Global $FullBabyD[4]   = [-1, -1, -1, -1] ;
Global $FullMine[4]    = [-1, -1, -1, -1] ;

Global $TrainMini[4]   = [-1, -1, -1, -1]
Global $TrainHogs[4]   = [-1, -1, -1, -1]
Global $TrainValk[4]   = [-1, -1, -1, -1]
Global $TrainGole[4]   = [-1, -1, -1, -1]
Global $TrainWitc[4]   = [-1, -1, -1, -1]
Global $TrainLava[4]   = [-1, -1, -1, -1]
Global $TrainBowl[4]   = [-1, -1, -1, -1]

Global $FullMini[4]    = [-1, -1, -1, -1] ;
Global $FullHogs[4]    = [-1, -1, -1, -1] ;
Global $FullValk[4]    = [-1, -1, -1, -1] ;
Global $FullGole[4]    = [-1, -1, -1, -1] ;
Global $FullWitc[4]    = [-1, -1, -1, -1] ;
Global $FullLava[4]    = [-1, -1, -1, -1] ;
Global $FullBowl[4]    = [-1, -1, -1, -1] ;

;Spells Section
Global $TrainLSpell[4]  = [-1, -1, -1, -1] ;
Global $TrainRSpell[4]  = [-1, -1, -1, -1] ;
Global $TrainFSpell[4]  = [-1, -1, -1, -1] ;
Global $TrainHSpell[4]  = [-1, -1, -1, -1] ;
Global $TrainJSpell[4]  = [-1, -1, -1, -1] ;
Global $TrainCSpell[4]  = [-1, -1, -1, -1] ;
Global $TrainPSpell[4]  = [-1, -1, -1, -1] ;
Global $TrainESpell[4]  = [-1, -1, -1, -1] ;
Global $TrainHaSpell[4] = [-1, -1, -1, -1] ;
Global $TrainSkSpell[4] = [-1, -1, -1, -1] ;

Global $FullLSpell[4]   = [-1, -1, -1, -1] ;
Global $FullRSpell[4]   = [-1, -1, -1, -1] ;
Global $FullFSpell[4]   = [-1, -1, -1, -1] ;
Global $FullHSpell[4]   = [-1, -1, -1, -1] ;
Global $FullJSpell[4]   = [-1, -1, -1, -1] ;
Global $FullCSpell[4]   = [-1, -1, -1, -1] ;
Global $FullPSpell[4]   = [-1, -1, -1, -1] ;
Global $FullESpell[4]   = [-1, -1, -1, -1] ;
Global $FullHaSpell[4]  = [-1, -1, -1, -1] ;
Global $FullSkSpell[4]  = [-1, -1, -1, -1] ;

Global $GemLSpell[4] = [25, 340 + $midOffsetY, 0x030300, 1]		; These will never be True! I put wrong Coords/Color, Because i have Gem lol
Global $GemRSpell[4] = [25, 340 + $midOffsetY, 0x030300, 1]		; These will never be True! I put wrong Coords/Color, Because i have Gem lol
Global $GemFSpell[4] = [25, 340 + $midOffsetY, 0x030300, 1]		; These will never be True! I put wrong Coords/Color, Because i have Gem lol
Global $GemHSpell[4] = [25, 340 + $midOffsetY, 0x030300, 1]		; These will never be True! I put wrong Coords/Color, Because i have Gem lol
Global $GemJSpell[4] = [25, 340 + $midOffsetY, 0x030300, 1]		; These will never be True! I put wrong Coords/Color, Because i have Gem lol
Global $GemCSpell[4] = [25, 340 + $midOffsetY, 0x030300, 1]		; These will never be True! I put wrong Coords/Color, Because i have Gem lol
Global $GemPSpell[4] = [25, 340 + $midOffsetY, 0x030300, 1]		; These will never be True! I put wrong Coords/Color, Because i have Gem lol
Global $GemESpell[4] = [25, 340 + $midOffsetY, 0x030300, 1]		; These will never be True! I put wrong Coords/Color, Because i have Gem lol
Global $GemHaSpell[4] = [25, 340 + $midOffsetY, 0x030300, 1]		; These will never be True! I put wrong Coords/Color, Because i have Gem lol
Global $GemSkSpell[4] = [25, 340 + $midOffsetY, 0x030300, 1]		; These will never be True! I put wrong Coords/Color, Because i have Gem lol

Global Const $GemBarb[4] = [187, 372 + $midOffsetY, 0xE70A12, 30] ; Pixel location of middle of right side of zero text for troop training, and color when out of Elixir
Global Const $GemArch[4] = [290, 372 + $midOffsetY, 0xE70A12, 30]
Global Const $GemGiant[4] = [392, 372 + $midOffsetY, 0xE70A12, 30]
Global Const $GemGobl[4] = [495, 372 + $midOffsetY, 0xE70A12, 30]
Global Const $GemWall[4] = [597, 372 + $midOffsetY, 0xE70A12, 30]
Global Const $GemBall[4] = [700, 372 + $midOffsetY, 0xE70A12, 30]

Global Const $GemWiza[4] = [346, 478 + $midOffsetY, 0xE70A12, 30]
Global Const $GemHeal[4] = [453, 478 + $midOffsetY, 0xE70A12, 30]
Global Const $GemDrag[4] = [559, 478 + $midOffsetY, 0xE70A12, 30]
Global Const $GemPekk[4] = [666, 478 + $midOffsetY, 0xE70A12, 30]
Global Const $GemBabyD[4] = [597, 478 + $midOffsetY, 0xE70A12, 30]
Global Const $GemMine[4] = [700, 478 + $midOffsetY, 0xE70A12, 30]

Global Const $GemMini[4] = [239, 378 + $midOffsetY, 0xE70A12, 30]
Global Const $GemHogs[4] = [346, 379 + $midOffsetY, 0xE70A12, 30]
Global Const $GemValk[4] = [453, 372 + $midOffsetY, 0xE70A12, 30]
Global Const $GemGole[4] = [559, 378 + $midOffsetY, 0xE70A12, 30]
Global Const $GemWitc[4] = [666, 372 + $midOffsetY, 0xE70A12, 30]


Global Const $GemLava[4] = [239, 482 + $midOffsetY, 0xE70A12, 30]
Global Const $GemBowl[4] = [342, 479 + $midOffsetY, 0xE70A12, 30]

Global $NextBtn[4] = [780, 546 + $bottomOffsetY, 0xD34300, 20] ;  Next Button
; Someone asking troops : Color 0xD0E978 in x = 121

; 1 - Green : available | 2 - Dark gray : request allready made | 3 - Light gray : Castle filled/No Castle
Global $aRequestTroopsAO[6] = [737, 565, 0xa2d44a, 0x808182, 0xb6b6b6, 10] ; Button Request Troops in Army Overview  (x,y,can request, request allready made, army full/no clan, toll)

Global Const $aOpenChatTab[4] = [19, 335 + $midOffsetY, 0xE88D27, 20]
Global Const $aCloseChat[4] = [331, 330 + $midOffsetY, 0xF0951D, 20]  ; duplicate with $aChatTab above, need to rename and fix all code to use one?
Global Const $aChatDonateBtnColors[4][4] = [[0x050505, 0, -4, 30], [0x89CA31, 0, 13, 15], [0x89CA31, 0, 16, 15], [0xFFFFFF, 21, 7, 5]]

;attackreport
Global Const $aAtkRprtDECheck[4] = [459, 372 + $midOffsetY, 0x433350, 20]
Global Const $aAtkRprtTrophyCheck[4] = [327, 189 + $midOffsetY, 0x3B321C, 30]
Global Const $aAtkRprtDECheck2[4] = [678, 418 + $midOffsetY, 0x030000, 30]

;returnhome
Global Const $aRtnHomeCheck1[4] = [363, 548 + $midOffsetY, 0x78C11C, 20]
Global Const $aRtnHomeCheck2[4] = [497, 548 + $midOffsetY, 0x79C326, 20]
;Global Const $aRtnHomeCheck3[4]      = [ 284,  28, 0x41B1CD, 20]

Global Const $aSearchLimit[6] = [19, 565, 104, 580, 0xD9DDCF, 10] ; (kaganus) no idea what this is for

;inattackscreen
Global Const $aIsAttackPage[4] = [70, 548 + $bottomOffsetY, 0xC80000, 20] ; red button "end battle" 860x780

; Bluestacks Menu - replaced with shortcut keys due removal or BS menu bar
;Global Const $aBSBackButton[4] = [ 50, 700 + $bottomOffsetY, 0x000000, 10] ; Bluestacks V0.9. - V0.10. back button
;Global Const $aBSHomeButton[4] = [125, 700 + $bottomOffsetY, 0x000000, 10] ; Bluestacks V0.9. - V0.10. Home button
;Global Const $aBSExitButton[4] = [820, 700 + $bottomOffsetY, 0x000000, 10] ; Bluestacks V0.9. - V0.10. Exit button

;CheckImageType (Normal, Snow, etc)
Global Const $aImageTypeN1[4] = [237, 161, 0xD5A849, 30]; Sand on Forest Edge 'Lane' 860x780
Global Const $aImageTypeN2[4] = [205, 180, 0x86A533, 30]; Grass on Forest Edge 'Lane' 860x780
Global Const $aImageTypeS1[4] = [237, 161, 0xFEFDFD, 30]; Snow on Forest Edge 'Lane' 860x780
Global Const $aImageTypeS2[4] = [205, 180, 0xFEFEFE, 30]; Snow on Forest Edge 'Lane' 860x780


Global Const $ProfileRep01[4] = [600, 260, 0x71769F, 20]; If colorcheck then village have 0 attacks and 0 defenses

Global $xBtnTrain = 89
Global $yBtnTrain = 50
Global $xTrainOffset = 97
Global $yTrainOffset = 101
Global $xTrain = 28
Global $yTrain = 371
Global $TrainBarbRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainGiantRND[4]= [$xTrain + ($xTrainOffset * 1), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainWallRND[4] = [$xTrain + ($xTrainOffset * 2), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 2), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainWizaRND[4] = [$xTrain + ($xTrainOffset * 3), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 3), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainDragRND[4] = [$xTrain + ($xTrainOffset * 4), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 4), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainBabyDRND[4] = [$xTrain + ($xTrainOffset * 5), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 5), $yTrain + $yBtnTrain + $midOffsetY]
$yTrain = $yTrain + $yTrainOffset
Global $TrainArchRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainGoblRND[4] = [$xTrain + ($xTrainOffset * 1), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainBallRND[4] = [$xTrain + ($xTrainOffset * 2), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 2), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainHealRND[4] = [$xTrain + ($xTrainOffset * 3), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 3), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainPekkRND[4] = [$xTrain + ($xTrainOffset * 4), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 4), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainMineRND[4] = [$xTrain + ($xTrainOffset * 5), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 5), $yTrain + $yBtnTrain + $midOffsetY]

Global $xTrain = 445
Global $yTrain = 371
Global $TrainMiniRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainValkRND[4] = [$xTrain + ($xTrainOffset * 1), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainWitcRND[4] = [$xTrain + ($xTrainOffset * 2), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 2), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainBowlRND[4] = [$xTrain + ($xTrainOffset * 3), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 3), $yTrain + $yBtnTrain + $midOffsetY]
$yTrain = $yTrain + $yTrainOffset
Global $TrainHogsRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainGoleRND[4] = [$xTrain + ($xTrainOffset * 1), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainLavaRND[4] = [$xTrain + ($xTrainOffset * 2), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 2), $yTrain + $yBtnTrain + $midOffsetY]

Global $xBtnTrain = 89
Global $yBtnTrain = 50
Global $xTrainOffset = 97
Global $yTrainOffset = 101
Global $xTrain = 28
Global $yTrain = 371
Global $TrainLSpellRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainRSpellRND[4]= [$xTrain + ($xTrainOffset * 1), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainFSpellRND[4] = [$xTrain + ($xTrainOffset * 2), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 2), $yTrain + $yBtnTrain + $midOffsetY]
$yTrain = $yTrain + $yTrainOffset
Global $TrainHSpellRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainJSpellRND[4] = [$xTrain + ($xTrainOffset * 1), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainCSpellRND[4] = [$xTrain + ($xTrainOffset * 2), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 2), $yTrain + $yBtnTrain + $midOffsetY]

Global $xTrain = 331
Global $yTrain = 371
Global $TrainPSpellRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainHaSpellRND[4] = [$xTrain + ($xTrainOffset * 1), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $midOffsetY]
$yTrain = $yTrain + $yTrainOffset
Global $TrainESpellRND[4] = [$xTrain + ($xTrainOffset * 0), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 0), $yTrain + $yBtnTrain + $midOffsetY]
Global $TrainSkSpellRND[4] = [$xTrain + ($xTrainOffset * 1), $yTrain + $midOffsetY, $xTrain + $xBtnTrain + ($xTrainOffset * 1), $yTrain + $yBtnTrain + $midOffsetY]


Global $aArmyTrainButtonRND[4] = [20, 540 + $midOffsetY, 55, 570 + $midOffsetY] ; Main Screen, Army Train Button, RND  Screen 860x732
Global $aAttackButtonRND[4] = [20, 610 + $midOffsetY, 100, 670 + $midOffsetY] ; Attack Button, Main Screen, RND  Screen 860x732
Global $aFindMatchButtonRND[4] = [200, 510 + $midOffsetY, 300, 530 + $midOffsetY] ; Find Multiplayer Match Button, Both Shield or without shield Screen 860x732
Global $NextBtnRND[4] = [710, 530 + $midOffsetY, 830, 570 + $midOffsetY] ;  Next Button
