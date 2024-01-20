; #FUNCTION# ====================================================================================================================
; Name ..........: Custom Drop Troops
; Description ...: This file contains the Sequence that runs all MBR Bot
; Author ........: Kychera (05-2017)
; Modified ......: NguyenAnhHD (12-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func MatchTroopDropName($Num)
	Switch _GUICtrlComboBox_GetCurSel($g_ahCmbDropOrder[$Num])
		Case 0
			Return $eBarb
		Case 1
			Return $eSBarb
		Case 2
			Return $eArch
		Case 3
			Return $eSArch
		Case 4
			Return $eGiant
		Case 5
			Return $eSGiant
		Case 6
			Return $eGobl
		Case 7
			Return $eSGobl
		Case 8
			Return $eWall
		Case 9
			Return $eSWall
		Case 10
			Return $eBall
		Case 11
			Return $eRBall
		Case 12
			Return $eWiza
		Case 13
			Return $eSWiza
		Case 14
			Return $eHeal
		Case 15
			Return $eDrag
		Case 16
			Return $eSDrag
		Case 17
			Return $ePekk
		Case 18
			Return $eBabyD
		Case 19
			Return $eInfernoD
		Case 20
			Return $eMine
		Case 21
			Return $eSMine			
		Case 22
			Return $eEDrag
		Case 23
			Return $eYeti
		Case 24
			Return $eRDrag
		Case 25
			Return $eETitan
		Case 26
			Return $eRootR
		Case 27
			Return $eMini
		Case 28
			Return $eSMini
		Case 29
			Return $eHogs
		Case 30
			Return $eSHogs
		Case 31
			Return $eValk
		Case 32
			Return $eSValk
		Case 33
			Return $eGole
		Case 34
			Return $eWitc
		Case 35
			Return $eSWitc
		Case 36
			Return $eLava
		Case 37
			Return $eIceH
		Case 38
			Return $eBowl
		Case 39
			Return $eSBowl
		Case 40
			Return $eIceG
		Case 41
			Return $eHunt
		Case 42
			Return $eAppWard
		Case 43
			Return "CC"
		Case 44
			Return "HEROES"
	EndSwitch
EndFunc   ;==>MatchTroopDropName

Func MatchSlotsPerEdge($Num)
	; 0 = spread in all deploy points each side , 1 = one deploy point , 2 = 2 deploy points
	Switch _GUICtrlComboBox_GetCurSel($g_ahCmbDropOrder[$Num])
		Case 0 ;$eBarb
			Return 0
		Case 1 ;$eSBarb
			Return 0
		Case 2 ;$eArch
			Return 0
		Case 3 ;$eSArch
			Return 0
		Case 4 ;$eGiant
			Return $g_iSlotsGiants
		Case 5 ;$eSGiant
			Return $g_iSlotsGiants
		Case 6 ;$eGobl
			Return 0
		Case 7 ;$eSGobl
			Return 0
		Case 8 ;$eWall
			Return 1
		Case 9 ;$eSWall
			Return 1
		Case 10 ;$eBall
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 11 ;$eRBall
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 12 ;$eWiza
			Return 0
		Case 13 ;$eSWiza
			Return 0
		Case 14 ;$eHeal
			Return 1
		Case 15 ;$eDrag
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 16 ;$eSDrag
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 17 ;$ePekk
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 1
			Else
				Return 2
			EndIf
		Case 18 ;$eBabyD
			Return 1
		Case 19 ;$eInfernoD
			Return 1
		Case 20 ;$eMine
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 1
			EndIf
		Case 21 ;$eSMine
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 1
			EndIf
		Case 22 ; $eEDrag
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 23 ; $eYeti
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 24 ; $eRDrag
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 25 ; $eETitan
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 26 ; $eRootR
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 27 ;$eMini
			Return 0
		Case 28 ;$eSMini
			Return 0
		Case 29 ;$eHogs
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 1
			Else
				Return 2
			EndIf
		Case 30 ;$eSHogs
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 1
			Else
				Return 2
			EndIf
		Case 31 ;$eValk
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 32 ;$eSValk
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 0
			Else
				Return 2
			EndIf
		Case 33 ;$eGole
			Return 2
		Case 34 ;$eWitc
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 1
			Else
				Return 2
			EndIf
		Case 35 ;$eSWitc
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 5 Then
				Return 1
			Else
				Return 2
			EndIf
		Case 36 ;$eLava
			Return 2
		Case 37 ;$eIceH
			Return 2
		Case 38 ;$eBowl
			Return 0
		Case 39 ;$eSBowl
			Return 0
		Case 40 ;$eIceG
			Return 2
		Case 41 ;$eHunt
			Return 0
		Case 42 ;$eAppWard
			Return 0
		Case 43 ;CC
			Return 1
		Case 44 ;HEROES
			Return 1
	EndSwitch
EndFunc   ;==>MatchSlotsPerEdge

Func MatchSidesDrop($Num)
	Switch _GUICtrlComboBox_GetCurSel($g_ahCmbDropOrder[$Num])
		Case $eBarb To $eAppWard
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 0 Then Return 1
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 1 Then Return 2
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 2 Then Return 3
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 3 Then Return 4
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 4 Then Return 4
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 5 Then Return 1
			If $g_aiAttackStdDropSides[$g_iMatchMode] = 6 Then Return 1
		Case 42
			Return 1 ;CC
		Case 43
			Return 1 ;HEROES
	EndSwitch
EndFunc   ;==>MatchSidesDrop

Func MatchTroopWaveNb($Num)
	Return 1
EndFunc   ;==>MatchTroopWaveNb
