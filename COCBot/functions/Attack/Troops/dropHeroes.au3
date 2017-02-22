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
	If _Sleep($iDelaydropHeroes1) Then Return
	$dropKing = False
	$dropQueen = False
	$dropWarden = False



   ;Force to check settings of matchmode =$DB if you attack $TS after milkingattack
   Local $MatchMode
   If $g_iMatchMode = $TS and $duringMilkingAttack = 1 Then
	  $MatchMode = $DB
   Else
	  $MatchMode = $g_iMatchMode
   EndIf

   ;use hero if  slot (detected ) and ( (matchmode <>DB and <>LB  ) or (check user GUI settings) )
   If $KingSlot <> -1 And (($MatchMode <> $DB And $MatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$MatchMode], $eHeroKing) = $eHeroKing) Then $dropKing = True
   If $QueenSlot <> -1 And (($MatchMode <> $DB And $MatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$MatchMode], $eHeroQueen) = $eHeroQueen) Then $dropQueen = True
   If $WardenSlot <> -1 And (($MatchMode <> $DB And $MatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$MatchMode], $eHeroWarden) = $eHeroWarden) Then $dropWarden = True

	If $g_iDebugSetlog = 1 Then SetLog("drop KING = " & $dropKing, $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 Then SetLog("drop QUEEN = " & $dropQueen, $COLOR_DEBUG)
	If $g_iDebugSetlog = 1 Then SetLog("drop WARDEN = " & $dropWarden, $COLOR_DEBUG)

	If $dropKing Then
		SetLog("Dropping King", $COLOR_INFO)
		Click(GetXPosOfArmySlot($KingSlot, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0092") ;Select King 860x780
		If _Sleep($iDelaydropHeroes2) Then Return
		Click($x, $y, 1, 0, "#0093")
		$checkKPower = True
	EndIf

	If _Sleep($iDelaydropHeroes1) Then Return

	If $dropQueen Then
		SetLog("Dropping Queen", $COLOR_INFO)
		Click(GetXPosOfArmySlot($QueenSlot, 68), 595 + $g_iBottomOffsetY, 1, 0, "#0094") ;Select Queen 860x780
		If _Sleep($iDelaydropHeroes2) Then Return
		Click($x, $y, 1, 0, "#0095")
		$checkQPower = True
	EndIf

	If _Sleep($iDelaydropHeroes1) Then Return

	If $dropWarden Then
		SetLog("Dropping Grand Warden", $COLOR_INFO)
		Click(GetXPosOfArmySlot($WardenSlot, 68), 595 + $g_iBottomOffsetY, 1, 0, "#X998") ;Select Warden 860x780
		If _Sleep($iDelaydropHeroes2) Then Return
		Click($x, $y, 1, 0, "#x999")
		$checkWPower = True
	EndIf

EndFunc   ;==>dropHeroes



