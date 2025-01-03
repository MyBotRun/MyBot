; #FUNCTION# ====================================================================================================================
; Name ..........: dropHeroes
; Description ...: Will drop heroes in a specific coordinates, only if slot is not -1,Only drops when option is clicked.
; Syntax ........: dropHeroes($x, $y, $iKingSlot = -1, $iQueenSlot = -1, $iPrinceSlot = -1, $iWardenSlot = -1, $iChampionSlot = -1)
; Parameters ....: $x                   - an unknown value.
;                  $y                   - an unknown value.
;                  $KingSlot            - [optional] an unknown value. Default is -1.
;                  $QueenSlot           - [optional] an unknown value. Default is -1.
;                  $WardenSlot          - [optional] an unknown value. Default is -1.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func dropHeroes($iX, $iY, $iKingSlotNumber = -1, $iQueenSlotNumber = -1, $iPrinceSlotNumber = -1, $iWardenSlotNumber = -1, $iChampionSlotNumber = -1) ;Drops for All Heroes
	If $g_bDebugSetLog Then SetDebugLog("dropHeroes $iKingSlotNumber " & $iKingSlotNumber & " $iQueenSlotNumber " & $iQueenSlotNumber & " $iPrinceSlotNumber " & $iPrinceSlotNumber & " $iWardenSlotNumber " & $iWardenSlotNumber & " $iChampionSlotNumber " & $iChampionSlotNumber & " matchmode " & $g_iMatchMode, $COLOR_DEBUG)
	If _Sleep($DELAYDROPHEROES1) Then Return
	Local $bDropKing = False
	Local $bDropQueen = False
	Local $bDropPrince = False
	Local $bDropWarden = False
	Local $bDropChampion = False

	;use hero if  slot (detected ) and ( ($g_iMatchMode <>DB and <>LB  ) or (check user GUI settings) )
	If $iKingSlotNumber <> -1 And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroKing) = $eHeroKing) Then $bDropKing = True
	If $iQueenSlotNumber <> -1 And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroQueen) = $eHeroQueen) Then $bDropQueen = True
	If $iPrinceSlotNumber <> -1 And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroPrince) = $eHeroPrince) Then $bDropPrince = True
	If $iWardenSlotNumber <> -1 And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroWarden) = $eHeroWarden) Then $bDropWarden = True
	If $iChampionSlotNumber <> -1 And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroChampion) = $eHeroChampion) Then $bDropChampion = True

	For $i = 0 To UBound($g_aiCmbCustomHeroOrder) - 1
		Switch $g_aiCmbCustomHeroOrder[$i]
			Case 0
				If $g_bDebugSetLog Then SetDebugLog("drop KING = " & $bDropKing, $COLOR_DEBUG)
				KingDrop($iX, $iY, $iKingSlotNumber, $bDropKing)
			Case 1
				If $g_bDebugSetLog Then SetDebugLog("drop QUEEN = " & $bDropQueen, $COLOR_DEBUG)
				QueenDrop($iX, $iY, $iQueenSlotNumber, $bDropQueen)
			Case 2
				If $g_bDebugSetLog Then SetDebugLog("drop PRINCE = " & $bDropPrince, $COLOR_DEBUG)
				PrinceDrop($iX, $iY, $iPrinceSlotNumber, $bDropPrince)
			Case 3
				If $g_bDebugSetLog Then SetDebugLog("drop WARDEN = " & $bDropWarden, $COLOR_DEBUG)
				WardenDrop($iX, $iY, $iWardenSlotNumber, $bDropWarden)
			Case 4
				If $g_bDebugSetLog Then SetDebugLog("drop CHAMPION = " & $bDropChampion, $COLOR_DEBUG)
				ChampionDrop($iX, $iY, $iChampionSlotNumber, $bDropChampion)
		EndSwitch
	Next

EndFunc   ;==>dropHeroes

Func KingDrop($iX, $iY, $iKingSlotNumber = -1, $bDropKing = False)
	If $bDropKing Then
		SetLog("Dropping King at " & $iX & ", " & $iY, $COLOR_INFO)
		SelectDropTroop($iKingSlotNumber, 1, Default, False)
		If _Sleep($DELAYDROPHEROES2) Then Return
		AttackClick($iX, $iY, 1, 50, 0, "#0093")
		If Not $g_bDropKing Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
			$g_bCheckKingPower = True
		Else
			SetDebugLog("King dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
		EndIf
		$g_bDropKing = True ; Set global flag hero dropped
		$g_aHeroesTimerActivation[$eHeroBarbarianKing] = __TimerInit() ; initialize fixed activation timer
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf
	If _Sleep($DELAYDROPHEROES1) Then Return
EndFunc   ;==>KingDrop

Func QueenDrop($iX, $iY, $iQueenSlotNumber = -1, $bDropQueen = False)
	If $bDropQueen Then
		SetLog("Dropping Queen at " & $iX & ", " & $iY, $COLOR_INFO)
		SelectDropTroop($iQueenSlotNumber, 1, Default, False)
		If _Sleep($DELAYDROPHEROES2) Then Return
		AttackClick($iX, $iY, 1, 50, 0, "#0095")
		If Not $g_bDropQueen Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
			$g_bCheckQueenPower = True
		Else
			SetDebugLog("Queen dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
		EndIf
		$g_bDropQueen = True ; Set global flag hero dropped
		$g_aHeroesTimerActivation[$eHeroArcherQueen] = __TimerInit() ; initialize fixed activation timer
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf
	If _Sleep($DELAYDROPHEROES1) Then Return
EndFunc   ;==>QueenDrop

Func PrinceDrop($iX, $iY, $iPrinceSlotNumber = 1, $bDropPrince = False)
	If $bDropPrince Then
		SetLog("Dropping Prince at " & $iX & ", " & $iY, $COLOR_INFO)
		SelectDropTroop($iPrinceSlotNumber, 1, Default, False)
		If _Sleep($DELAYDROPHEROES2) Then Return
		AttackClick($iX, $iY, 1, 50, 0, "#0095")
		If Not $g_bDropPrince Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
			$g_bCheckPrincePower = True
		Else
			SetDebugLog("Prince dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
		EndIf
		$g_bDropPrince = True ; Set global flag hero dropped
		$g_aHeroesTimerActivation[$eHeroMinionPrince] = __TimerInit() ; initialize fixed activation timer
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf
	If _Sleep($DELAYDROPHEROES1) Then Return
EndFunc   ;==>PrinceDrop

Func WardenDrop($iX, $iY, $iWardenSlotNumber = -1, $bDropWarden = False)
	If $bDropWarden Then
		SetLog("Dropping Grand Warden at " & $iX & ", " & $iY, $COLOR_INFO)
		SelectDropTroop($iWardenSlotNumber, 1, Default, False)
		If _Sleep($DELAYDROPHEROES2) Then Return
		AttackClick($iX, $iY, 1, 50, 0, "#x999")
		If Not $g_bDropWarden Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
			$g_bCheckWardenPower = True
		Else
			SetDebugLog("Warden dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
		EndIf
		$g_bDropWarden = True ; Set global flag hero dropped
		$g_aHeroesTimerActivation[$eHeroGrandWarden] = __TimerInit() ; initialize fixed activation timer
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf
	If _Sleep($DELAYDROPHEROES1) Then Return
EndFunc   ;==>WardenDrop

Func ChampionDrop($iX, $iY, $iChampionSlotNumber = -1, $bDropChampion = False)
	If $bDropChampion Then
		SetLog("Dropping Royal Champion at " & $iX & ", " & $iY, $COLOR_INFO)
		SelectDropTroop($iChampionSlotNumber, 1, Default, False)
		If _Sleep($DELAYDROPHEROES2) Then Return
		AttackClick($iX, $iY, 1, 50, 0, "#x999")
		If Not $g_bDropChampion Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
			$g_bCheckChampionPower = True
		Else
			SetDebugLog("Royal Champion dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
		EndIf
		$g_bDropChampion = True ; Set global flag hero dropped
		$g_aHeroesTimerActivation[$eHeroRoyalChampion] = __TimerInit() ; initialize fixed activation timer
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf
	If _Sleep($DELAYDROPHEROES1) Then Return
EndFunc   ;==>ChampionDrop



