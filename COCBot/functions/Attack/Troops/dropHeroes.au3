; #FUNCTION# ====================================================================================================================
; Name ..........: dropHeroes
; Description ...: Will drop heroes in a specific coordinates, only if slot is not -1,Only drops when option is clicked.
; Syntax ........: dropHeroes($x, $y[, $KingSlot = -1[, $QueenSlot = -1[, $WardenSlot = -1]]])
; Parameters ....: $x                   - an unknown value.
;                  $y                   - an unknown value.
;                  $KingSlot            - [optional] an unknown value. Default is -1.
;                  $QueenSlot           - [optional] an unknown value. Default is -1.
;                  $WardenSlot          - [optional] an unknown value. Default is -1.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func dropHeroes($x, $y, $KingSlot = -1, $QueenSlot = -1, $WardenSlot = -1) ;Drops for king and queen and Grand Warden
	If $g_iDebugSetlog = 1 Then SetLog("dropHeroes KingSlot " & $KingSlot & " QueenSlot " & $QueenSlot & " WardenSlot " & $WardenSlot & " matchmode " & $g_iMatchMode, $COLOR_DEBUG)
	If _Sleep($DELAYDROPHEROES1) Then Return
	$g_bDropKing = False
	$g_bDropQueen = False
	$g_bDropWarden = False

	;Force to check settings of matchmode =$DB if you attack $TS after milkingattack
	Local $MatchMode
	If $g_iMatchMode = $TS And $g_bDuringMilkingAttack = True Then
		$MatchMode = $DB
	Else
		$MatchMode = $g_iMatchMode
	EndIf

	;use hero if  slot (detected ) and ( (matchmode <>DB and <>LB  ) or (check user GUI settings) )
	If $KingSlot <> -1 And (($MatchMode <> $DB And $MatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$MatchMode], $eHeroKing) = $eHeroKing) Then $g_bDropKing = True
	If $QueenSlot <> -1 And (($MatchMode <> $DB And $MatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$MatchMode], $eHeroQueen) = $eHeroQueen) Then $g_bDropQueen = True
	If $WardenSlot <> -1 And (($MatchMode <> $DB And $MatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$MatchMode], $eHeroWarden) = $eHeroWarden) Then $g_bDropWarden = True

	If $g_iDebugSetlog = 1 Then SetLog("drop KING = " & $g_bDropKing, $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 Then SetLog("drop QUEEN = " & $g_bDropQueen, $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 Then SetLog("drop WARDEN = " & $g_bDropWarden, $COLOR_DEBUG)

	If $g_bDropKing Then
		SetLog("Dropping King", $COLOR_INFO)
		Click(GetXPosOfArmySlot($KingSlot, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0092") ;Select King 860x780
		If _Sleep($DELAYDROPHEROES2) Then Return
		Click($x, $y, 1, 0, "#0093")
		$g_bCheckKingPower = True
		If $g_iActivateKQCondition = "Manual" Then $g_aHeroesTimerActivation[$eHeroBarbarianKing] = __TimerInit() ; initialize fixed activation timer
	EndIf

	If _Sleep($DELAYDROPHEROES1) Then Return

	If $g_bDropQueen Then
		SetLog("Dropping Queen", $COLOR_INFO)
		Click(GetXPosOfArmySlot($QueenSlot, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0094") ;Select Queen 860x780
		If _Sleep($DELAYDROPHEROES2) Then Return
		Click($x, $y, 1, 0, "#0095")
		$g_bCheckQueenPower = True
		If $g_iActivateKQCondition = "Manual" Then $g_aHeroesTimerActivation[$eHeroArcherQueen] = __TimerInit() ; initialize fixed activation timer
	EndIf

	If _Sleep($DELAYDROPHEROES1) Then Return

	If $g_bDropWarden Then
		SetLog("Dropping Grand Warden", $COLOR_INFO)
		Click(GetXPosOfArmySlot($WardenSlot, 68), 595 + $g_iBottomOffsetY, 1, 0, "#X998") ;Select Warden 860x780
		If _Sleep($DELAYDROPHEROES2) Then Return
		Click($x, $y, 1, 0, "#x999")
		$g_bCheckWardenPower = True
		If $g_iActivateKQCondition = "Manual" Or $g_bActivateWardenCondition Then
			$g_aHeroesTimerActivation[$eHeroGrandWarden] = __TimerInit() ; initialize fixed activation timer
		EndIf
	EndIf

EndFunc   ;==>dropHeroes



