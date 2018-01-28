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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func dropHeroes($x, $y, $KingSlot = -1, $QueenSlot = -1, $WardenSlot = -1) ;Drops for king and queen and Grand Warden
	If $g_bDebugSetlog Then SetDebugLog("dropHeroes KingSlot " & $KingSlot & " QueenSlot " & $QueenSlot & " WardenSlot " & $WardenSlot & " matchmode " & $g_iMatchMode, $COLOR_DEBUG)
	If _Sleep($DELAYDROPHEROES1) Then Return
	Local $bDropKing = False
	Local $bDropQueen = False
	Local $bDropWarden = False

	;Force to check settings of matchmode =$DB if you attack $TS after milkingattack
	Local $MatchMode
	If $g_iMatchMode = $TS And $g_bDuringMilkingAttack = True Then
		$MatchMode = $DB
	Else
		$MatchMode = $g_iMatchMode
	EndIf

	;use hero if  slot (detected ) and ( (matchmode <>DB and <>LB  ) or (check user GUI settings) )
	If $KingSlot <> -1 And (($MatchMode <> $DB And $MatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$MatchMode], $eHeroKing) = $eHeroKing) Then $bDropKing = True
	If $QueenSlot <> -1 And (($MatchMode <> $DB And $MatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$MatchMode], $eHeroQueen) = $eHeroQueen) Then $bDropQueen = True
	If $WardenSlot <> -1 And (($MatchMode <> $DB And $MatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$MatchMode], $eHeroWarden) = $eHeroWarden) Then $bDropWarden = True

	If $g_bDebugSetlog Then SetDebugLog("drop KING = " & $bDropKing, $COLOR_DEBUG)
	If $g_bDebugSetlog Then SetDebugLog("drop QUEEN = " & $bDropQueen, $COLOR_DEBUG)
	If $g_bDebugSetlog Then SetDebugLog("drop WARDEN = " & $bDropWarden, $COLOR_DEBUG)

	If $bDropKing Then
		SetLog("Dropping King", $COLOR_INFO)
		Click(GetXPosOfArmySlot($KingSlot, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0092") ;Select King 860x780
		If _Sleep($DELAYDROPHEROES2) Then Return
		AttackClick($x, $y, 1, 0, 0, "#0093")
		If Not $g_bDropKing Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
			$g_bCheckKingPower = True
		Else
			SetDebugLog("King dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
		EndIf
		$g_bDropKing = True ; Set global flag hero dropped
		If $g_iActivateKing = 1 Or $g_iActivateKing = 2 Then $g_aHeroesTimerActivation[$eHeroBarbarianKing] = __TimerInit() ; initialize fixed activation timer
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf

	If _Sleep($DELAYDROPHEROES1) Then Return

	If $bDropQueen Then
		SetLog("Dropping Queen", $COLOR_INFO)
		Click(GetXPosOfArmySlot($QueenSlot, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0094") ;Select Queen 860x780
		If _Sleep($DELAYDROPHEROES2) Then Return
		AttackClick($x, $y, 1, 0, 0, "#0095")
		If Not $g_bDropQueen Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
			$g_bCheckQueenPower = True
		Else
			SetDebugLog("Queen dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
		EndIf
		$g_bDropQueen = True ; Set global flag hero dropped
		If $g_iActivateQueen = 1 Or $g_iActivateQueen = 2 Then $g_aHeroesTimerActivation[$eHeroArcherQueen] = __TimerInit() ; initialize fixed activation timer
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf

	If _Sleep($DELAYDROPHEROES1) Then Return

	If $bDropWarden Then
		SetLog("Dropping Grand Warden", $COLOR_INFO)
		Click(GetXPosOfArmySlot($WardenSlot, 68), 595 + $g_iBottomOffsetY, 1, 0, "#X998") ;Select Warden 860x780
		If _Sleep($DELAYDROPHEROES2) Then Return
		AttackClick($x, $y, 1, 0, 0, "#x999")
		If Not $g_bDropWarden Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
			$g_bCheckWardenPower = True
		Else
			SetDebugLog("Warden dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
		EndIf
		$g_bDropWarden = True ; Set global flag hero dropped
		If $g_iActivateWarden = 1 Or $g_iActivateWarden = 2 Then $g_aHeroesTimerActivation[$eHeroGrandWarden] = __TimerInit() ; initialize fixed activation timer
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf

EndFunc   ;==>dropHeroes



