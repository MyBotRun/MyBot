; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttack
; Description ...: Checks the troops when in battle, checks for type, slot, and quantity.  Saved in $atkTroops[SLOT][TYPE/QUANTITY] variable
; Syntax ........: PrepareAttack($pMatchMode[, $Remaining = False])
; Parameters ....: $pMatchMode          - a pointer value.
;                  $Remaining           - [optional] Flag for when checking remaining troops. Default is False.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func PrepareAttack($pMatchMode, $Remaining = False) ;Assigns troops

	; Attack CSV has debug option to save attack line image, save have png of current $hHBITMAP2
	If  ($pMatchMode = $DB and $g_aiAttackAlgorithm[$DB] = 1) or ($pMatchMode = $LB and  $g_aiAttackAlgorithm[$LB] = 1) Then
		If $g_iDebugMakeIMGCSV = 1 And $Remaining = False And TestCapture() = 0 Then DebugImageSave("clean", False) ; make clean snapshot as well
	EndIf

	Local $troopsnumber = 0
	If $g_iDebugSetlog = 1 Then SetLog("PrepareAttack for " & $pMatchMode & " " & $g_asModeText[$pMatchMode], $COLOR_DEBUG)
	If $Remaining Then
		SetLog("Checking remaining unused troops for: " & $g_asModeText[$pMatchMode], $COLOR_INFO)
	Else
		SetLog("Initiating attack for: " & $g_asModeText[$pMatchMode], $COLOR_ERROR)
	EndIf

	_CaptureRegion2(0, 571 + $g_iBottomOffsetY, 859, 671 + $g_iBottomOffsetY)
	If _Sleep($iDelayPrepareAttack1) Then Return

    ;SuspendAndroid()
	;Local $result = DllCall($g_hLibFunctions, "str", "searchIdentifyTroop", "ptr", $hHBitmap2)
	;If $ichkFixClanCastle= 1 Then $result[0] = FixClanCastle( $result[0])

	For $i = 0 to UBound($atkTroops) -1
		$atkTroops[$i][0] = -1
		$atkTroops[$i][1] = 0
	Next

	Local $Plural = 0
	Local $result = AttackBarCheck($Remaining)
	If $g_iDebugSetlog = 1 Then Setlog("DLL Troopsbar list: " & $result, $COLOR_DEBUG)
	Local $aTroopDataList = StringSplit($result, "|")
	Local $aTemp[12][3]
	If $result <> "" Then
		; example : 0#0#92|1#1#108|2#2#8|22#3#1|20#4#1|21#5#1|26#5#0|23#6#1|24#7#2|25#8#1|29#10#1
		; [0] = Troop Enum Cross Reference [1] = Slot position [2] = Quantities
		For $i = 1 To $aTroopDataList[0]
			Local $troopData = StringSplit($aTroopDataList[$i], "#", $STR_NOCOUNT)
			$aTemp[Number($troopData[1])][0] = $troopData[0]
			$aTemp[Number($troopData[1])][1] = Number($troopData[2])
			$aTemp[Number($troopData[1])][2] = Number($troopData[1])
		Next
	EndIf
	For $i = 0 To UBound($aTemp) - 1
		If $aTemp[$i][0] = "" And $aTemp[$i][1] = "" Then
			$atkTroops[$i][0] = -1
			$atkTroops[$i][1] = 0
		Else
			Local $troopKind = $aTemp[$i][0]
			;If $g_iDebugSetlog=1 Then Setlog("examine troop " &  NameOfTroop($TroopKind) ,$COLOR_DEBUG1)
			If $troopKind < $eKing Then
				;If $g_iDebugSetlog=1 Then Setlog("examine troop " &  NameOfTroop($TroopKind) & " -> normal troop",$COLOR_DEBUG1)
				;normal troop
				If Not IsTroopToBeUsed($pMatchMode, $troopKind) Then
					If $g_iDebugSetlog = 1 Then Setlog("Discard use of troop " & $troopKind &  " " & NameOfTroop($troopKind), $COLOR_ERROR)
					$atkTroops[$i][0] = -1
					$atkTroops[$i][1] = 0
					$troopKind = -1
				Else
					;use troop
					;If $g_iDebugSetlog=1 Then Setlog("for matchmode = " & $pMatchMode & " and troop " & $TroopKind & " " & NameOfTroop($TroopKind) & " USE",$COLOR_DEBUG1)
					;Setlog ("troopsnumber = " & $troopsnumber & "+ " &  Number( $aTemp[$i][1]))
					$atkTroops[$i][0] = $aTemp[$i][0]
					$atkTroops[$i][1] = $aTemp[$i][1]
					$troopsnumber +=  $aTemp[$i][1]
				EndIf

			Else ;king, queen, warden and spells
				;If $g_iDebugSetlog=1 Then Setlog("examine troop " &  NameOfTroop($TroopKind) & " -> special troop",$COLOR_DEBUG1)
				$atkTroops[$i][0] = $troopKind
				If IsSpecialTroopToBeUsed($pMatchMode, $TroopKind) then
					$troopsnumber += 1
					;If $g_iDebugSetlog=1 Then Setlog("for matchmode = " & $pMatchMode & " and troop " & $TroopKind & " " & NameOfTroop($TroopKind) & " USE",$COLOR_DEBUG1)
					;Setlog ("troopsnumber = " & $troopsnumber & "+1")
					$atkTroops[$i][0] = $aTemp[$i][0]
					$atkTroops[$i][1] = $aTemp[$i][1]
					If $atkTroops[$i][0] = $eKing or $atkTroops[$i][0] = $eQueen or $atkTroops[$i][0] = $eWarden then $atkTroops[$i][1] = 1
					$troopKind = $atkTroops[$i][1]
					$troopsnumber +=  1
				Else
					;If $g_iDebugSetlog=1 Then Setlog("for matchmode = " & $pMatchMode & " and troop " & $TroopKind & " " & NameOfTroop($TroopKind) & " DISCARD",$COLOR_DEBUG1)
					If $g_iDebugSetlog = 1 Then Setlog($aTemp[$i][2] & " » Discard use hero/poison " & $troopKind &  " " & NameOfTroop($troopKind), $COLOR_ERROR)
					$troopKind = -1
				EndIf
			EndIf

			$Plural = 0
			If $aTemp[$i][1] > 1 then $Plural = 1
			If $troopKind <> -1 Then SetLog($aTemp[$i][2] & " » " & $atkTroops[$i][1] & " " & NameOfTroop($atkTroops[$i][0], $Plural), $COLOR_SUCCESS)

		EndIf
    Next

    ;ResumeAndroid()

	If $g_iDebugSetlog=1 Then Setlog("troopsnumber  = " & $troopsnumber)
	Return $troopsnumber
EndFunc   ;==>PrepareAttack

Func IsTroopToBeUsed($pMatchMode, $pTroopType)
	If $pMatchMode = $DT Or $pMatchMode = $TB  Then Return True
	If $pMatchMode = $MA Then
		Local $tempArr = $troopsToBeUsed[$g_aiAttackTroopSelection[$DB]]
	Else
		Local $tempArr = $troopsToBeUsed[$g_aiAttackTroopSelection[$pMatchMode]]
	EndIf
	For $x = 0 To UBound($tempArr) - 1
		If $tempArr[$x] = $pTroopType Then
			If $pMatchMode =$MA and $pTroopType = $eGobl Then ;exclude goblins in $MA
				Return False
			Else
				Return True
			EndIf
		EndIf
	Next
	Return False
EndFunc   ;==>IsTroopToBeUsed

Func IsSpecialTroopToBeUsed($pMatchMode, $pTroopType)
    Local $iTempMode = ($pMatchMode = $MA ? $DB : $pMatchMode)

	If $pMatchMode <> $DB and $pMatchMode <> $LB and $pMatchMode <> $TS and $pMatchMode <> $MA Then
		Return True
	Else
		Switch $pTroopType
		    Case $eKing
			   If (BitAND($g_aiAttackUseHeroes[$iTempMode], $eHeroKing) = $eHeroKing) Then Return True
			Case $eQueen
			   If (BitAND($g_aiAttackUseHeroes[$iTempMode], $eHeroQueen) = $eHeroQueen) Then Return True
			Case $eWarden
			   If (BitAND($g_aiAttackUseHeroes[$iTempMode], $eHeroWarden) = $eHeroWarden) Then Return True
			Case $eCastle
			   If $g_abAttackDropCC[$iTempMode] Then Return True
			Case $eLSpell
			   If $g_abAttackUseLightSpell[$iTempMode] Or $ichkSmartZap = 1 Then Return True
			Case $eHSpell
			   If $g_abAttackUseHealSpell[$iTempMode] Then Return True
			Case $eRSpell
				If $g_abAttackUseRageSpell[$iTempMode] Then Return True
			Case $eJSpell
				If $g_abAttackUseJumpSpell[$iTempMode] Then Return True
			Case $eFSpell
				If $g_abAttackUseFreezeSpell[$iTempMode] Then Return True
			Case $ePSpell
				If $g_abAttackUsePoisonSpell[$iTempMode] Then Return True
			Case $eESpell
				If $g_abAttackUseEarthquakeSpell[$iTempMode] = 1 Or $ichkSmartZap = 1 Then Return True
			Case $eHaSpell
				If $g_abAttackUseHasteSpell[$iTempMode] Then Return True
			Case $eCSpell
				If $g_abAttackUseCloneSpell[$iTempMode] Then Return True
			Case $eSkSpell
				If $g_abAttackUseSkeletonSpell[$iTempMode] Then Return True
			Case Else
				Return False
		EndSwitch
		Return False
	EndIf
EndFunc
