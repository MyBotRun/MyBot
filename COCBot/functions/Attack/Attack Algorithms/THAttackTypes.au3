; #FUNCTION# ==========================================================
; Name ..........: THAttackTypes
; Description ...: This file contens the TH attacks
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: AtoZ (2015)
; Modified ......: Barracoda (July 2015), TheMaster 2015-10
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ================================================================

Func SwitchAttackTHType()
	$THusedKing = 0
	$THusedQueen = 0
;~ 	Switch $icmbAttackTHType
;~ 		Case 0
;~ 			AttackTHSmartBarch()
;~ 		Case 1
;~ 			AttackTHNormal();Good for Masters
;~ 		Case 2
;~ 			AttackTHXtreme();Good for Champ
;~ 		Case 3
;~ 			AttackTHGbarch()
;~ 		Case 4
;~ 			AttackTHCustomized()
;~ 	EndSwitch
	AttackTHParseCSV()
EndFunc   ;==>SwitchAttackTHType


;~ Func AttackTHSmartBarch()

;~ 	Setlog("Sniping TH with SmartBarch", $COLOR_BLUE)

;~ 	; 1st wave 30 secs, total 4 barbs 8 archers, works for totally unprotected TH ___________________________________________________________________________________________
;~ 	SetLog("Attacking TH with 1st wave of BARCH", $COLOR_BLUE)
;~ 	AttackTHGrid($eBarb, Random (4,6,1) , 1, Random( 1500,2000,1), 1) ; deploys 4-6 barbarians to take out traps waits 2 seconds for bombs to go off
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 2, Random (4,6,1), Random( 800,1000,1), 1) ; deploys 8-12 archers
;~ 	If CheckOneStar(25) Then Return ; Checks for one star in 25 second loop delay

;~ 	; 2nd wave 25 secs total 16 barbs, 22 archers, works for TH partially covered by defenses _______________________________________________________________________________
;~ 	SetLog("Attacking TH with 2nd wave of BARCH", $COLOR_BLUE)

;~ 	AttackTHGrid($eBarb, Random (4,5,1), 2, Random( 800,1000,1), 2) ; deploys 8-10 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 2, Random (5,6,1), Random( 800,1000,1), 2) ; deploys 10-12 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, Random (4,5,1), 2, Random( 800,1000,1), 2) ; deploys 8-10 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, Random (4,5,1), 3, Random( 800,1000,1), 2) ; deploys 12-15 archers
;~ 	If CheckOneStar(20) Then Return ; Checks for one star in 20 second loop delay

;~ 	;---3nd wave 17 secs (rather short interval until ALL IN) total 6 giants, 30 barbs, 57 archers ______________________________________________________________________
;~ 	SetLog("Oh Shit! Seems like a trapped TH!", $COLOR_BLUE)
;~ 	AttackTHGrid($eGiant, 2, 1, Random( 1000,1200,1), 1) ; deploys 2 giants for Traps
;~ 	If CheckOneStar() Then Return
;~ 	SpellTHGrid($eHSpell)
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eGiant, Random (5,6,1), 3, Random( 500,600,1), 1) ; deploys 15-18 giants
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eHogs, Random( 5,6,1), 3, Random( 800,1000,1), 2) ;releases 15-18 Hogs
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eWall, 2, 1, Random( 500,600,1), 1) ; deploys 2 wallbreakers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eWall, 2, 1, Random( 500,600,1), 2) ; deploys 2 wallbreakers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eKing) ; deploys king
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eQueen) ; deploys queen
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eHeal, 2, 1, Random( 500,600,1), 0) ; deploys 2 healer
;~ 	If CheckOneStar() Then Return
;~ 	SpellTHGrid($eRSpell)
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eCastle) ; deploys cc
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 3, Random (3,4,1), Random( 500,600,1), 3) ; deploys 9-12 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 3, Random (4,5,1), Random( 500,600,1), 3) ; deploys 12-15 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 3, Random (3,4,1), Random( 500,600,1), 3) ; deploys 9-12 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 3, Random (5,6,1), Random( 500,600,1), 3) ; deploys 15-18 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 4, Random (3,4,1), Random( 500,600,1), 3) ; deploys 12-16 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 4, Random (5,6,1), Random( 500,600,1), 3) ; deploys 20-24 archers
;~ 	If CheckOneStar(15) Then Return ; Checks for one star in 15 second loop delay

;~ 	;---4th wave 20 secs throw in everything ______________________________________________________________________________________________________________________________
;~ 	Setlog("Dammit! ALL IN!", $COLOR_BLUE)
;~ 	AttackTHGrid($eGiant, 3, 10, Random( 500,600,1), 4) ; deploys 30 giants
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 4, 10, Random( 500,600,1), 4) ; deploys 40 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 4, 10, Random( 500,600,1), 4) ; deploys 40 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eGobl, 4, 10, Random( 500,600,1), 4) ; deploys 40 goblins
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eWiza, 2, 10, Random( 500,600,1), 4) ; deploys 20 wizards
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eMini, 2, 10, Random( 500,600,1), 4) ; deploys 20 minions
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 4, 10, Random( 500,600,1), 4) ; deploys 40 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 4, 10, Random( 500,600,1), 4) ; deploys 40 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 4, 10, Random( 500,600,1), 4) ; deploys 40 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 4, 10, Random( 500,600,1), 4) ; deploys 40 archers
;~ 	If CheckOneStar(15) Then Return ; Checks for one star in 15 second loop delay

;~ 	For $i = 1 To 5 ; struck TH by all lightning spells
;~ 		If CheckOneStar() Then Return
;~ 		CastSpell($eLSpell,$THx, $THy) ; on TH directly without offset
;~ 	Next

;~ 	If _Sleep(Random( 500,600,1)) Then Return
;~ 	SetLog("~Finished Attacking, waiting to finish", $COLOR_GREEN)
;~ 	If CheckOneStar(20) Then Return

;~ EndFunc   ;==>AttackTHSmartBarch

;~ Func AttackTHNormal()

;~ 	Setlog("Normal Attacking TH Outside with BAM PULSE!")

;~ 	;---1st wave
;~ 	AttackTHGrid($eBarb, 3, Random(2,3,1), Random( 1500,1900,1), 1) ; deploys 6-9 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 3, Random(2,3,1), Random( 800,1200,1), 1) ; deploys 6-9 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eMini, 3, Random(2,3,1), Random( 800,1000,1), 1) ; deploys 6-9 minions
;~ 	If CheckOneStar(20) Then Return ; Checks for one star in 20 second loop delay

;~ 	;---2nd wave
;~ 	AttackTHGrid($eBarb, 3, Random(2,3,1), Random( 500,600,1), 2) ; deploys 6-9 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 3, Random(2,3,1), Random( 1000,1200,1), 2) ; deploys 6-9 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eMini, 3, Random(2,3,1), Random( 1000,1400,1), 2) ; deploys 6-9 minions
;~ 	If CheckOneStar(20) Then Return ; Checks for one star in 20 second loop delay

;~ 	;---3rd wave 10 secs
;~ 	AttackTHGrid($eBarb, 3, Random(2,3,1), Random( 1000,1400,1), 3) ; deploys 6-9 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eMini, 3, Random(2,3,1), Random( 1000,1400,1), 3) ; deploys 6-9 minions
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 3, Random(2,3,1), Random( 1000,1200,1), 3) ; deploys 6-9 archers
;~ 	If CheckOneStar(20) Then Return ; Checks for one star in 20 second loop delay

;~ 	Setlog("Normal Attacking TH Outside in FULL!")
;~ 	AttackTHGrid($eGiant, 2, 1, Random( 1000,1200,1), 1) ; deploys 2 giants for Traps
;~ 	If CheckOneStar() Then Return
;~ 	SpellTHGrid($eHSpell)
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eGiant, 5, Random(3,4,1), Random( 500,600,1), 1) ;releases 15-20 giants
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eHogs, Random( 5,6,1), 3, Random( 800,1000,1), 2) ;releases 15-18 Hogs
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eWall, 2, 1, Random( 500,600,1), 1) ; deploys 2 wallbreakers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eWall, 2, 1, Random( 500,600,1), 2) ; deploys 2 wallbreakers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eKing) ; deploys king
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eQueen) ; deploys queen
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eHeal, 2, 1, Random( 500,600,1), 0) ; deploys 2 healer
;~ 	If CheckOneStar() Then Return
;~ 	SpellTHGrid($eRSpell)
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eCastle) ; deploys cc
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 5, Random(5,6,1), Random( 1000,1200,1), 4) ;releases 25-30 barbs
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 5,Random(5,6,1), Random( 1000,1200,1), 4) ;releases 25-30 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eMini, 5, 2, Random( 800,1000,1), 4) ;releases 10 minions
;~ 	If CheckOneStar(20) Then Return ; Checks for one star in 20 second loop delay

;~ 	;Final Wave
;~ 	AttackTHGrid($eGiant, 5, 2, Random( 500,600,1), 2) ;releases 10 giants
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eHogs, 5, 2, Random( 1000,1300,1), 2) ;releases 10 Hogs
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 5, 10, Random( 800,1000,1), 4) ;releases 50 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 5, 10, Random( 500,600,1), 4) ;releases 50 barbs
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eMini, 5, 2, Random( 800,1000,1), 4) ;releases 10 minions
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eWiza, 3, 2, Random( 800,1000,1), 1) ;releases 6 wizards
;~ 	If CheckOneStar(20) Then Return ; Checks for one star in 20 second loop delay

;~ 	For $i = 1 To 5 ; struck TH by all lightning spells
;~ 		If CheckOneStar() Then Return
;~ 		CastSpell($eLSpell,$THx, $THy) ; on TH directly without offset
;~ 	Next

;~ 	If _Sleep(Random( 500,600,1)) Then Return
;~ 	SetLog("~Finished Attacking, waiting to finish", $COLOR_GREEN)
;~ 	If CheckOneStar(20) Then Return

;~ EndFunc   ;==>AttackTHNormal

;~ Func AttackTHXtreme()

;~ 	Setlog("Extreme Attacking TH Outside with BAM PULSE!")

;~ 	;---1st wave 15 secs
;~ 	SetLog("Attacking TH with 1st wave of BAM COMBO")
;~ 	AttackTHGrid($eBarb, 5, Random( 1,2,1) , Random( 800,1000,1), 1) ; deploys 5-10 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 5, Random( 1,2,1), Random( 800,1000,1), 1) ; deploys 5-10 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eMini, 5, Random( 1,2,1), Random( 800,1000,1), 1) ; deploys 5-10 minions
;~ 	If CheckOneStar(20) Then Return

;~ 	;---2nd wave 20 secs
;~ 	SetLog("Attacking TH with 2nd wave of BAM COMBO")
;~ 	AttackTHGrid($eBarb, 5, Random( 1,2,1) , Random( 800,1000,1), 1) ; deploys 5-10 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 5, Random( 1,2,1), Random( 800,1000,1), 1) ; deploys 5-10 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eMini, 5, Random( 1,2,1), Random( 800,1000,1), 1) ; deploys 5-10 minions
;~ 	If CheckOneStar(20) Then Return

;~ 	;---3nd wave 10 secs
;~ 	SetLog("Attacking TH with 3rd wave of BAM COMBO")
;~ 	AttackTHGrid($eBarb, 5, Random( 1,2,1) , Random( 800,1000,1), 1) ; deploys 5-10 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 5, Random( 1,2,1), Random( 800,1000,1), 1) ; deploys 5-10 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eMini, 5, Random( 1,2,1), Random( 800,1000,1), 1) ; deploys 5-10 minions
;~ 	If CheckOneStar(20) Then Return

;~ 	;---4th wave
;~ 	Setlog("Extreme Attacking TH Outside in FULL!")
;~ 	SpellTHGrid($eHSpell)
;~ 	AttackTHGrid($eGiant, Random( 5,6,1), 2, Random( 500,600,1), 1) ;releases 10-12 giants
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eGiant, Random( 5,6,1), 2, Random( 800,1000,1), 2) ;releases 10-12 giants
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eHogs, Random( 5,6,1), 3, Random( 800,1000,1), 2) ;releases 15-18 Hogs
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eWall, 2, 1, Random( 500,600,1), 1) ; deploys 2 wallbreakers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eWall, 2, 1, Random( 500,600,1), 2) ; deploys 2 wallbreakers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eKing) ; deploys king
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eQueen) ; deploys queen
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eHeal, 2, 1, Random( 500,600,1), 4) ; deploys 2 healer
;~ 	If CheckOneStar() Then Return
;~ 	SpellTHGrid($eRSpell)
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eCastle) ; deploys cc
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 5, 20, Random( 500,600,1), 4) ;releases 80 barbs
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 5, 20, Random( 500,600,1), 4) ;releases 80 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eMini, 5, 2, Random( 1000,1200,1), 4) ; deploys 10 minions
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eWiza, 3, 2, Random( 800,1000,1), 1) ;releases 6 wizards
;~ 	If CheckOneStar(20) Then Return

;~ 	For $i = 1 To 5 ; struck TH by all lightning spells
;~ 		If CheckOneStar() Then Return
;~ 		CastSpell($eLSpell,$THx, $THy) ; on TH directly without offset
;~ 	Next

;~ 	If _Sleep(Random( 500,600,1)) Then Return
;~ 	SetLog("~Finished Attacking, waiting to finish", $COLOR_GREEN)
;~ 	If CheckOneStar(20) Then Return

;~ EndFunc   ;==>AttackTHXtreme

;~ Func AttackTHGbarch()

;~ 	Setlog("Sending 1st wave of archers.")
;~ 	AttackTHGrid($eArch, 4, 1, Random( 1500,2000,1), 1) ; deploys 4 archers - take out possible bombs
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 3, Random(5, 6, 1), Random( 800,1000,1), 1) ; deploys 15-18 archers
;~ 	If CheckOneStar(30) Then Return


;~ 	Setlog("Sending second wave of archers.")
;~ 	AttackTHGrid($eArch, 4, Random(4, 5, 1), Random( 800,1000,1), 2) ;deploys 16-20 archers
;~ 	If CheckOneStar(30) Then Return


;~ 	Setlog("Still no star - Let's send in more diverse troops!")
;~ 	AttackTHGrid($eGiant, 2, 1, Random( 500,600,1), 1) ;deploys 2 giants in case of spring traps
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eGiant, 2, Random(1, 2, 1), Random( 500,600,1), 2) ;deploys 2-4 giants to take heat
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 3, Random(4, 5, 1), Random( 800,1000,1), 1) ; deploys up to 12-15 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eBarb, 4, Random(4, 5, 1), Random( 500,600,1), 1) ; deploys up to 16-20 barbarians
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 3, 8, Random( 500,600,1), 3) ; deploys 24 archers
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eArch, 4, 7, Random( 800,1000,1), 3) ; deploys 28 archers
;~ 	If CheckOneStar(25) Then Return

;~ 	Setlog("Hope the rest of your troops can finish the job!")
;~ 	SpellTHGrid($eHSpell)
;~     If CheckOneStar() Then Return
;~ 	AttackTHGrid($eGiant, 2, 9, Random( 500,600,1), 3) ;deploys 18 giants
;~ 	If CheckOneStar() Then Return
;~     AttackTHGrid($eHogs, Random( 5,6,1), 3, Random( 800,1000,1), 2) ;releases 15-18 Hogs
;~ 	If CheckOneStar() Then Return
;~     AttackTHGrid($eWall,2,1,Random( 500,600,1),1)    ; deploys 2 wallbreakers
;~     If CheckOneStar() Then Return
;~ 	AttackTHGrid($eWall,2,1,Random( 500,600,1),1)    ; deploys 2 wallbreakers
;~     If CheckOneStar() Then Return
;~     AttackTHGrid($eKing) ; deploys King
;~     If CheckOneStar() Then Return
;~     AttackTHGrid($eQueen) ; deploys Queen
;~     If CheckOneStar() Then Return
;~     AttackTHGrid($eHeal,2,1,Random( 500,600,1),4)    ; deploys 2 healer
;~     If CheckOneStar() Then Return
;~ 	SpellTHGrid($eRSpell)
;~ 	If CheckOneStar() Then Return
;~ 	AttackTHGrid($eCastle) ; deploys CC
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

;~ EndFunc   ;==>AttackTHGbarch

Func AttackTHParseCSV($test = False)
	If $debugsetlog = 1 Then Setlog("AttackTHParseCSV start", $COLOR_PURPLE)
	Local $f, $line, $acommand, $command
	If FileExists($dirTHSnipesAttacks & "\" & $scmbAttackTHType & ".csv") Then
		$f = FileOpen($dirTHSnipesAttacks & "\" & $scmbAttackTHType & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			;Setlog("line content: " & $line)
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), 2)
				;   $eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $ePSpell, $eESpell, $eHaSpell
				Select
					Case $command = "TROOP" Or $command = ""
						;Setlog("<<<<discard line>>>>")
					Case $command = "TEXT"
						If $debugSetLog = 1 Then Setlog(">> SETLOG(""" & $acommand[8] & """)")

						SetLog($acommand[8], $COLOR_BLUE)

					Case StringInStr(StringUpper("-Barb-Arch-Giant-Gobl-Wall-Ball-Wiza-Heal-Drag-Pekk-Mini-Hogs-Valk-Gole-Witc-Lava-"), "-" & $command & "-") > 0
						If $debugSetLog = 1 Then Setlog(">> AttackTHGrid($e" & $command & ", Random (" & Int($acommand[2]) & "," & Int($acommand[3]) & ",1), Random(" & Int($acommand[4]) & "," & Int($acommand[5]) & ",1), Random(" & Int($acommand[6]) & "," & Int($acommand[7]) & ",1) )")

						Local $iNbOfSpots
						If Int($acommand[2]) = Int($acommand[3]) Then
							$iNbOfSpots = Int($acommand[2])
						Else
							$iNbOfSpots = Random(Int($acommand[2]), Int($acommand[3]), 1)
						EndIf

						Local $iAtEachSpot
						If Int($acommand[4]) = Int($acommand[5]) Then
							$iAtEachSpot = Int($acommand[4])
						Else
							$iAtEachSpot = Random(Int($acommand[4]), Int($acommand[5]), 1)
						EndIf

						Local $Sleep
						If Int($acommand[6]) = Int($acommand[7]) Then
							$Sleep = Int($acommand[6])
						Else
							$Sleep = Random(Int($acommand[6]), Int($acommand[7]), 1)
						EndIf

						AttackTHGrid(Eval("e" & $command), $iNbOfSpots, $iAtEachSpot, $Sleep, 0)

					Case $command = "WAIT"
						If $debugSetLog = 1 Then Setlog(">> GoldElixirChangeThSnipes(" & Int($acommand[7]) & ") ")

						If CheckOneStar(Int($acommand[7]) / 2000) Then ExitLoop ; Use seconds not ms , Half of time to check One start and the other halft for check the Resources
						GoldElixirChangeThSnipes(Int($acommand[7]) / 2000) ; Correct the Function GoldElixirChangeThSnipes uses seconds not ms

					Case StringInStr(StringUpper("-King-Queen-Castle-"), "-" & $command & "-") > 0
						If $debugSetLog = 1 Then Setlog(">> AttackTHGrid($e" & $command & ")")

						AttackTHGrid(Eval("e" & $command))

					Case StringInStr(StringUpper("-HSpell-RSpell-"), "-" & $command & "-") > 0
						If $debugSetLog = 1 Then Setlog(">> SpellTHGrid($e" & $command & ")")

						SpellTHGrid(Eval("e" & $command))

					Case StringInStr(StringUpper("-LSpell-"), "-" & $command & "-") > 0
						If $debugSetLog = 1 Then Setlog(">> CastSpell($e" & $command & ",$THx, $THy)")

						CastSpell(Eval("e" & $command), $THx, $THy)

					Case Else
						Setlog("attack row bad, discard: " & $line, $COLOR_RED)
				EndSelect
				If $acommand[8] <> "" And $command <> "TEXT" And $command <> "TROOP" Then
					If $debugSetLog = 1 Then Setlog(">> SETLOG(""" & $acommand[8] & """)")
					SETLOG($acommand[8], $COLOR_BLUE)
				EndIf
			Else
				If StringStripWS($acommand[1], 2) <> "" Then Setlog("attack row error, discard: " & $line, $COLOR_RED)
			EndIf
			If $debugSetLog = 1 Then Setlog(">> CheckOneStar()")
			If CheckOneStar() Then ExitLoop
		WEnd
		FileClose($f)
	Else
		SetLog("Cannot found THSnipe attack file " & $dirTHSnipesAttacks & "\" & $scmbAttackTHType & ".csv", $color_red)
	EndIf

EndFunc   ;==>AttackTHParseCSV

