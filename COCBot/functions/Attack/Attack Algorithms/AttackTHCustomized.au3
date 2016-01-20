; #FUNCTION# ====================================================================================================================
; Name ..........: AttackTHCustomized
; Description ...: This file contens the customized attack algorithm TH
; Syntax ........: AttackTHCustomized ()
; Parameters ....: None
; Return values .: None
; Author ........: ProMac
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

	; CheckOneStar($DelayInSec = 0, $Log = True, $CheckHeroes = True) will verify the starts and the power of Heroes)
	; $DelayInSec : number of seconds to delay
	; $Log : display townhall is destroyed or not in log
	; $CheckHeroes : check for heroes health or not
	; ######   AttackTHGrid($troopKind, $iNbOfSpots, $iAtEachSpot, $Sleep, $waveNb) #######
		; $troopKind options : $eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eMini,
		;					   $eHogs, $eValk, $eGole, $eWitc, $eLav , $eQueen* , $eKing* , $eCastle
		; $iNbOfSpots   	 : number of spots to deploy troops
		; $iAtEachSpot		 : quantity of troops for each $spots
		; $Sleep 			 : time to deploy next troop in ms ( 1000 will be 1 second )
		; $waveNb 			 : wave number 1-4  ; 0 means only
	;  Example : AttackTHGrid ($eBarb, 2, 3, 2000, 1) ; deploy 6 barbarians (2 x 3) , wait 2 seconds ,
	;							this is first wave of 3
	; SpellTHGrid($S) = $S Options : $eLSpell , $eRSpell , $eHSpell

;~ Func AttackTHCustomized()

;~ 	Setlog("Sending 1st wave of Archers/Barbarians.")
;~ 	AttackTHGrid($eBarb, 4, 1, Random(1500,2000,1), 1) ; deploys 4 barbarians - take out possible bombs
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 6, 1, Random(800,1000,1), 1) ; deploys 6 archers
;~ 	AttackTHGrid($eMini, 2, 2, Random(800,1000,1), 1) ; deploys 4 minion

;~ 	; if Gold/Elixr are changing ( any troop attacking the TH will change the G+E ) the bot wait max 15x3 seconds , prevent waste more troops..
;~ 	; If not changing will continue to next wave of troops ..
;~     GoldElixirChangeThSnipes(20)
;~ 	If CheckOneStar() then return

;~ 	Setlog("Still no star - Let's send in more diverse troops!")
;~ 	AttackTHGrid($eGiant, 4, 2, Random( 100,200,1), 2) ;deploys 8 giants to take heat
;~ 	AttackTHGrid($eWall, 2, 5, Random( 50,100,1), 1) ;deploys 10 wallbreakers to break walls if we have
;~ 	If CheckOneStar() Then Return
;~ 	SpellTHGrid($eRSpell)
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 3, Random(4, 5, 1), Random( 800,1000,1), 1) ; deploys up to 12-15 barbarians
;~ 	If CheckOneStar(30) Then Return
;~ 	AttackTHGrid($eArch, 3, 8, Random( 500,600,1), 3) ; deploys 24 archers

;~ 	GoldElixirChangeThSnipes(15)
;~ 	If CheckOneStar() Then Return

;~ 	Setlog("Hope the rest of your troops can finish the job!")
;~ 	SpellTHGrid($eHSpell)
;~ 	AttackTHGrid($eKing) ; deploys King
;~     If CheckOneStar() Then Return
;~     AttackTHGrid($eQueen) ; deploys Queen

;~ 	GoldElixirChangeThSnipes(15)
;~     If CheckOneStar() Then Return

;~ 	AttackTHGrid($eGiant, 2, 9, Random( 500,600,1), 3) ;deploys 18 giants
;~ 	If CheckOneStar() Then Return
;~     AttackTHGrid($eHogs, Random( 5,6,1), 3, Random( 800,1000,1), 2) ;releases 15-18 Hogs
;~ 	If CheckOneStar() Then Return
;~     AttackTHGrid($eWall,2,1,Random( 500,600,1),1)    ; deploys 2 wallbreakers
;~     If CheckOneStar() Then Return
;~ 	AttackTHGrid($eWall,2,1,Random( 500,600,1),1)    ; deploys 2 wallbreakers
;~     If CheckOneStar() Then Return
;~     AttackTHGrid($eHeal,2,1,Random( 500,600,1),4)    ; deploys 2 healer
;~     If CheckOneStar() Then Return
;~ 	AttackTHGrid($eCastle) ; deploys CC

;~ 	GoldElixirChangeThSnipes(15)
;~     If CheckOneStar() Then Return

;~ 	AttackTHGrid($eBarb, 4, 8, Random( 500,600,1), 2) ; deploys up to 32 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 3, 13, Random( 500,600,1), 4) ;deploys up to 39 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 3, 11, Random( 500,600,1), 2) ; deploys up to 33 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 2, 20, Random( 500,600,1), 4) ;deploys up to 40 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 4, 9, Random( 500,600,1), 2) ; deploys up to 36 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 2, 20, Random( 500,600,1), 4) ;deploys up to 40 archers
;~ 	If CheckOneStar() Then Return
;~     AttackTHGrid($eBarb, 4, 9, Random( 500,600,1), 2) ; deploys up to 36 barbarians
;~     If CheckOneStar() Then Return
;~     AttackTHGrid($eArch, 2, 20, Random( 500,600,1), 4) ;deploys up to 40 archers
;~     If CheckOneStar(25) Then Return

;~ 	For $i = 1 To 5 ; struck TH by all lightning spells
;~ 		If CheckOneStar() Then Return
;~ 		CastSpell($eLSpell,$THx, $THy) ; on TH directly without offset
;~ 	Next

;~ 	SetLog("All Giants, Barbs, and Archers should be deployed, in addition to Heroes & CC (if options are selected). Other troops are not meant to be deployed in this algorithm.", $COLOR_GREEN)
;~ 	If _Sleep(Random( 500,600,1)) Then Return
;~ 	SetLog("~Finished Attacking, waiting to finish", $COLOR_GREEN)
;~ 	If CheckOneStar(20) Then Return


;~ EndFunc