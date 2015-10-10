; #FUNCTION# ====================================================================================================================
; Name ..........: AttackTHCustomized
; Description ...: This file contens the customized attack algorithm TH
; Syntax ........: AttackTHCustomized ()
; Parameters ....: None
; Return values .: None
; Author ........: ProMac
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015
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

Func AttackTHCustomized()

	Setlog("Sending 1st wave of Troops.")
    ; Put Your Code here

	; EX:
	; AttackTHGrid($eArch, 4, 1, 2000, 1) ; deploys 4 archers - take out possible bombs
	; AttackTHGrid($eArch, 3, Random(5, 6, 1), 1000, 1) ; deploys 15-18 archers   ### Random(from 5, to 6, steps of 1) ####
	; SpellTHGrid($eRSpell)
	; If CheckOneStar (5, true, true) then return

	Setlog("Sending 2nd wave of Troops.")


	Setlog("Sending 3rd wave of Troops.")


	Setlog("Sending 4th wave of Troops.")


EndFunc