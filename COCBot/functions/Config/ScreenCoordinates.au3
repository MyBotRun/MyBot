; #Variables# ====================================================================================================================
; Name ..........: Screen Position Variables
; Description ...: Global variables for commonly used X|Y positions, screen check color, and tolerance
; Syntax ........: $aXXXXX[Y]  : XXXX is name of point or item being checked, Y = 2 for position only, or 4 when color/tolerance value included
; Author ........: Code Gorilla #1
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Example .......: No
; ===============================================================================================================================
;                                 x    y     color  tolerance
Global $aIsMain[4]           = [284,  28, 0x41B1CD, 20] ; Main Screen, Builder Left Eye
Global $aIsMainGrayed[4]     = [284,  28, 0x215B69, 15] ; Main Screen Grayed, Builder Left Eye
Global $aTopLeftClient[4]    = [  1,   1, 0x000000,  0] ; TopLeftClient: Tolerance not needed
Global $aTopMiddleClient[4]  = [475,   1, 0x000000,  0] ; TopMiddleClient: Tolerance not needed
Global $aTopRightClient[4]   = [850,   1, 0x000000,  0] ; TopRightClient: Tolerance not needed
Global $aBottomRightClient[4]= [850, 675, 0x000000,  0] ; BottomRightClient: Tolerance not needed
Global $aIsInactive[4]       = [457, 300, 0x33B5E5, 10] ; COC message : 'Anyone there?'
Global $aReloadButton[2]     = [416, 399]               ; Reload Coc Button after Out of Sync
Global $aAttackButton[2]     = [ 60, 614]               ; Attack Button, Main Screen
Global $aFindMatchButton[2]  = [217, 510]               ; Find Multiplayer Match Button, Attack Screen
Global $aAway[2]             = [  1,  40]               ; Away click, moved from 1,1 to prevent scroll window from top
;Global $aBreakShield[4]     = [513, 416, 0x5DAC10, 50] ; Break Shield Button, Attack Screen ;the 0x5DAC10 color value matches open grass use with caution
Global $aSurrenderButton[4]  = [ 70, 545, 0xC10000, 30] ; Surrender Button, Attack Screen
Global $aConfirmSurrender[2] = [512, 394]               ; Confirm Surrender Button, Attack Screen (no color for button as it matches grass)
Global $aCancelFight[4]      = [822,  48, 0xD80408, 20] ; Cancel Fight Scene
Global $aCancelFight2[4]     = [830,  59, 0xD80408, 20] ; Cancel Fight Scene 2nd pixel
Global $aEndFightSceneBtn[4] = [429, 519, 0xB8E35F, 20] ; Victory or defeat scene buton = green edge
Global $aEndFightSceneAvl[4] = [241, 196, 0xFFF090, 20] ; Victory or defeat scene left side ribbon = light gold
Global $aReturnHomeButton[2] = [428, 544]               ; Return Home Button, End Battle Screen
Global $aChatTab[4]          = [331, 330, 0xF0A03B, 20] ; Chat Window Open, Main Screen
Global $aOpenChat[2]         = [ 19, 349]               ; Open Chat Windows, Main Screen
Global $aClanTab[2]          = [189,  24]               ; Clan Tab, Chat Window, Main Screen
Global $aClanInfo[2]         = [282,  55]  				; Clan Info Icon
Global $aArmyCampSize[2]     = [586, 193]               ; Training Window, Overview screen, Current Size/Total Size
Global $aIsCampNotFull[4] 	 = [149, 150, 0x761714, 20] ; Training Window, Overview screen Red pixel in Exclamation mark with camp is not full
Global $aIsCampFull[4]  	 = [151, 154, 0xFFFFFF, 10] ; Training Window, Overview screen White pixel in check mark with camp IS full (can not test for Green, as it has trees under it!)
Global $aBarrackFull[4] 	 = [392, 154, 0xE84D50, 20] ; Training Window, Barracks Screen, Red pixel in Exclamation mark with Barrack is full
Global $aBuildersDigits[2]   = [324,  21]               ; Main Screen, Free/Total Builders
Global $aLanguageCheck1[4]   = [326,   8, 0xF9FAF9, 20] ; Main Screen Test Language for word 'Builders'
Global $aLanguageCheck2[4]   = [329,   9, 0x060706, 20] ; Main Screen Test Language for word 'Builders'
Global $aLanguageCheck3[4]   = [348,  12, 0x040403, 20] ; Main Screen Test Language for word 'Builders'
Global $aLanguageCheck4[4]   = [354,  11, 0x090908, 20] ; Main Screen Test Language for word 'Builders'
Global $aTrophies[2]         = [ 65,  74]               ; Main Screen, Trophies
Global $aNoCloudsAttack[4]   = [774,    1,0x000000, 20] ; Attack Screen: No More Clouds
Global $aMessageButton[2]    = [ 38, 143]               ; Main Screen, Message Button
Global $aArmyTrainButton[2]  = [ 40, 525]               ; Main Screen, Army Train Button
Global $aWonOneStar[4] 		 = [714, 538, 0xC0C8C0, 20] ; Center of 1st Star for winning attack on enemy
Global $aWonTwoStar[4] 		 = [739, 538, 0xC0C8C0, 20] ; Center of 2nd Star for winning attack on enemy
Global $aWonThreeStar[4] 	 = [763, 538, 0xC0C8C0, 20] ; Center of 3rd Star for winning attack on enemy
Global $aArmyOverviewTest[4] = [150, 554, 0xBC2BD1, 20] ; Color purple of army overview  bottom left
Global $aCancRequestCCBtn[4] = [340, 245, 0xCC4010, 20] ; Red button Cancel in window request CC
Global $aSendRequestCCBtn[2] = [524, 245]               ; Green button Send in window request CC
Global $atxtRequestCCBtn[2]  = [430, 140]               ; textbox in window request CC
Global $aIsGoldFull[4]       = [660,  33, 0xD4B100,  6] ; Main Screen Gold Resource bar is Full
Global $aIsElixirFull[4]     = [660,  84, 0xAE1AB3,  6] ; Main Screen Elixir Resource bar is Full
Global $aConfirmCoCExit[2]   = [515, 410] 				  ; CoC Confirm Exit button (no color for button as it matches grass)
;Global $aKingHealth          = [ -1, 572, 0x4FD404,110] ; Attack Screen, Check King's Health, X coordinate is dynamic, not used from array
;Global $aQueenHealth         = [ -1, 573, 0x4FD404,110] ; Attack Screen, Check Queen's Health, X coordinate is dynamic, not used from array

Global $aKingHealth          = [ -1, 572, 0x00b29e, 15] ; Attack Screen, Check King's Health, X coordinate is dynamic, not used from array   ;  -> with slot compensation 0xbfb29e
Global $aQueenHealth         = [ -1, 572, 0x008227, 15] ; Attack Screen, Check Queen's Health, X coordinate is dynamic, not used from array  ;  -> with slot compensation 0xe08227


;attack report... stars won
Global $aWonOneStarAtkRprt[4] 		  = [325, 180, 0xC8CaC4, 30] ; Center of 1st Star reached attacked village
Global $aWonTwoStarAtkRprt[4] 		  = [398, 180, 0xD0D6D0, 30] ; Center of 2nd Star reached attacked village
Global $aWonThreeStarAtkRprt[4] 	  = [534, 180, 0xC8CAC7, 30] ; Center of 3rd Star reached attacked village


Global $SomeXCancelBtn[4]    = [819,  55, 0xD80400,     20]
Global $EndBattleBtn[4]      = [71, 530,  0xC00000,     20]
Global $Attacked[4]          = [235, 209, 0x9E3826,     20]
Global $AttackedBtn[2]       = [429, 493]
Global $HasClanMessage[4]    = [ 31, 313, 0xF80B09,     20]
Global $OpenChatBtn[2]       = [ 10, 334]
Global $IsClanTabSelected[4] = [204, 20, 0x6F6C4F,     20]
Global $IsClanMessage[4]     = [ 26, 320, 0xE70400,     20]

Global $ClanRequestTextArea[2]      = [430, 140]
Global $ConfirmClanTroopsRequest[2] = [524,228]
Global $CampFull[4]  	            = [328, 535, 0xD03840,     20]

Global $DropTrophiesStartPoint = [34, 310]

Global $TrainBarb[4]        = [ 220, 310, 0xFFC721,     40] ;  Done
Global $TrainArch[4]        = [ 301, 310, 0x902C55,     40] ;  Done
Global $TrainGiant[4]       = [ 442, 310, 0xFFCB8A,     40] ;  Done
Global $TrainGobl[4]        = [ 546, 310, 0xA8F468,     40] ;  Done
Global $TrainWall[4]        = [ 646, 310, 0x78D4F0,     40] ;  Done

Global $TrainBall[4]        = [ 220, 459, 0x383831,     20] ;  Done
Global $TrainWiza[4]        = [ 319, 447, 0x000000,     40] ;  Done
Global $TrainHeal[4]        = [ 442, 459, 0xD77E57,     20] ;  Done
Global $TrainDrag[4]        = [ 546, 459, 0xBA1618,     20] ;  Done
Global $TrainPekk[4]        = [ 646, 459, 0x406281,     20] ;  Done

Global $TrainMini[4]        = [ 220, 310, 0x182340,     20] ;  Done
Global $TrainHogs[4]        = [ 301, 310, 0x72D0E8,     20] ;  Done
Global $TrainValk[4]        = [ 442, 310, 0xA64002,     20] ;  Done
Global $TrainGole[4]        = [ 546, 310, 0xDEC3A8,     20] ;  Done
Global $TrainWitc[4]        = [ 646, 324, 0x3D3C65,     20] ;  Fix V4.0.1?

Global $TrainLava[4]        = [ 220, 459, 0x4F4F40,     20] ;  Done

Global $NextBtn[4]          = [ 780, 546, 0xD34300,     20] ;  Next Button
; Someone asking troops : Color 0xD0E978 in x = 121

Global $aRequestTroopsAO[6]	= [705, 290, 0xD2EC80, 0x407D06, 0xD8D8D8, 20] ; Button Request Troops in Army Overview  (x,y,can request, request allready made, army full/no clan, toll)

Global Const $FullBarb[4]   = [ 253, 375, 0x8F8F8F, 45]  ; Location of Elixir check pixel with normal color and Barrack Full color
Global Const $FullArch[4]   = [ 360, 375, 0x8D8D8D, 45]
Global Const $FullGiant[4]  = [ 468, 375, 0x8D8D8D, 45]
Global Const $FullGobl[4]   = [ 574, 375, 0x8F8F8F, 45]
Global Const $FullWall[4]   = [ 680, 375, 0x8F8F8F, 45]

Global Const $FullBall[4]   = [ 253, 482, 0xB5B5B5, 45]
Global Const $FullWiza[4]   = [ 360, 482, 0xB5B5B5, 45]
Global Const $FullHeal[4]   = [ 468, 482, 0xB5B5B5, 45]
Global Const $FullDrag[4]   = [ 574, 482, 0xB5B5B5, 45]
Global Const $FullPekk[4]   = [ 680, 482, 0xB5B5B5, 45]

Global Const $FullMini[4]   = [ 255, 348, 0xFFFFFF, 15] ; 0xC7F8F8 Most locations are only 30 decimal change in blue to gray (Dk blue chest)
Global Const $FullHogs[4]   = [ 364, 355, 0xB2B2B2, 30] ; 0xD07C58 normal (lt brown shoulder)
Global Const $FullValk[4]   = [ 417, 317, 0xB1B1B1, 30] ; 0xFF6E18 normal (lt orange hari curl)
Global Const $FullGole[4]   = [ 562, 339, 0xC9C9C9, 30] ; 0xF07CD0 normal (pink eye)
Global Const $FullWitc[4]   = [ 638, 339, 0xACACAC, 15] ; 0xF83DA4 normal (left pink eye) Need to fix

Global Const $FullLava[4]   = [ 256, 458, 0xB3B3B3, 30] ; 0xFF7000 normal (Orange line above DE drop)

Global Const $GemBarb[4]    = [ 239, 372, 0xE70A12, 30] ; Pixel location of middle of right side of zero text for troop training, and color when out of Elixir
Global Const $GemArch[4]    = [ 346, 372, 0xE70A12, 30]
Global Const $GemGiant[4]   = [ 453, 372, 0xE70A12, 30]
Global Const $GemGobl[4]    = [ 559, 372, 0xE70A12, 30]
Global Const $GemWall[4]    = [ 666, 372, 0xE70A12, 30]

Global Const $GemBall[4]    = [ 239, 372, 0xE70A12, 30]
Global Const $GemWiza[4]    = [ 346, 372, 0xE70A12, 30]
Global Const $GemHeal[4]    = [ 453, 372, 0xE70A12, 30]
Global Const $GemDrag[4]    = [ 559, 372, 0xE70A12, 30]
Global Const $GemPekk[4]    = [ 666, 372, 0xE70A12, 30]

Global Const $GemMini[4]    = [ 239, 378, 0xE70A12, 30]
Global Const $GemHogs[4]    = [ 346, 379, 0xE70A12, 30]
Global Const $GemValk[4]    = [ 453, 372, 0xE70A12, 30]
Global Const $GemGole[4]    = [ 559, 378, 0xE70A12, 30]
Global Const $GemWitc[4]    = [ 666, 372, 0xE70A12, 30]

Global Const $GemLava[4]    = [ 239, 372, 0xE70A12, 30]

Global Const $aCloseChat[4] = [ 331, 330, 0xF0A03B, 20]

;attackreport
Global Const $aAtkRprtDECheck[4]     = [ 459, 372, 0x433350, 20]
Global Const $aAtkRprtTrophyCheck[4] = [ 327, 189, 0x3B321C, 30]
Global Const $aAtkRprtDECheck2[4]    = [ 678, 418, 0x030000, 30]

;returnhome
Global Const $aRtnHomeCheck1[4]      = [ 363, 548, 0x78C11C, 20]
Global Const $aRtnHomeCheck2[4]      = [ 497, 548, 0x79C326, 20]
Global Const $aRtnHomeCheck3[4]      = [ 284,  28, 0x41B1CD, 20]

