; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttack
; Description ...: Checks the troops when in battle, checks for type, slot, and quantity.  Saved in $atkTroops[SLOT][TYPE/QUANTITY] variable
; Syntax ........: PrepareAttack($pMatchMode[, $Remaining = False])
; Parameters ....: $pMatchMode          - a pointer value.
;                  $Remaining           - [optional] Flag for when checking remaining troops. Default is False.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func PrepareAttack($pMatchMode, $Remaining = False) ;Assigns troops

	; Attack CSV has debug option to save attack line image, save have png of current $hHBITMAP2
	If  ($pMatchMode = $DB and $iAtkAlgorithm[$DB] = 1) or ($pMatchMode = $LB and  $iAtkAlgorithm[$LB] = 1) Then
		If $makeIMGCSV = 1 And $Remaining = False And TestCapture() = 0 Then DebugImageSave("clean", False) ; make clean snapshot as well
	EndIf

	Local $troopsnumber = 0
	If $debugSetlog = 1 Then SetLog("PrepareAttack for " & $pMatchMode & " " & $sModeText[$pMatchMode], $COLOR_DEBUG)
	If $Remaining Then
		SetLog("Checking remaining unused troops for: " & $sModeText[$pMatchMode], $COLOR_INFO)
	Else
		SetLog("Initiating attack for: " & $sModeText[$pMatchMode], $COLOR_ERROR)
	EndIf

	_CaptureRegion2(0, 571 + $bottomOffsetY, 859, 671 + $bottomOffsetY)
	If _Sleep($iDelayPrepareAttack1) Then Return

    ;SuspendAndroid()
	;Local $result = DllCall($hFuncLib, "str", "searchIdentifyTroop", "ptr", $hHBitmap2)
	;If $ichkFixClanCastle= 1 Then $result[0] = FixClanCastle( $result[0])

	Local $Plural = 0
	Local $result = AttackBarCheck()
	If $debugSetlog = 1 Then Setlog("DLL Troopsbar list: " & $result, $COLOR_DEBUG)
	Local $aTroopDataList = StringSplit($result, "|")
	Local $aTemp[12][3]
	If $result <> "" Then
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
			$troopKind = $aTemp[$i][0]
			;If $debugsetlog=1 Then Setlog("examine troop " &  NameOfTroop($TroopKind) ,$COLOR_DEBUG1)
			If $troopKind <$eKing Then
				;If $debugsetlog=1 Then Setlog("examine troop " &  NameOfTroop($TroopKind) & " -> normal troop",$COLOR_DEBUG1)
				;normal troop
				If Not IsTroopToBeUsed($pMatchMode, $troopKind) Then
					If $debugSetlog = 1 Then Setlog("Discard use of troop " & $troopKind &  " " & NameOfTroop($troopKind), $COLOR_ERROR)
					$atkTroops[$i][0] = -1
					$troopKind = -1
				Else
					;use troop
					;If $debugSetlog=1 Then Setlog("for matchmode = " & $pMatchMode & " and troop " & $TroopKind & " " & NameOfTroop($TroopKind) & " USE",$COLOR_DEBUG1)
					;Setlog ("troopsnumber = " & $troopsnumber & "+ " &  Number( $aTemp[$i][1]))
					$atkTroops[$i][0] = $aTemp[$i][0]
					$atkTroops[$i][1] = $aTemp[$i][1]
					$troopKind = $aTemp[$i][1]
					$troopsnumber +=  $aTemp[$i][1]
				EndIf

			Else ;king, queen, warden and spells
				;If $debugsetlog=1 Then Setlog("examine troop " &  NameOfTroop($TroopKind) & " -> special troop",$COLOR_DEBUG1)
				$atkTroops[$i][0] = $troopKind
				If IsSpecialTroopToBeUsed($pMatchMode, $TroopKind) then
					$troopsnumber += 1
					;If $debugSetlog=1 Then Setlog("for matchmode = " & $pMatchMode & " and troop " & $TroopKind & " " & NameOfTroop($TroopKind) & " USE",$COLOR_DEBUG1)
					;Setlog ("troopsnumber = " & $troopsnumber & "+1")
					$atkTroops[$i][0] = $aTemp[$i][0]
					$troopKind = $aTemp[$i][1]
					$troopsnumber +=  1
				Else
					;If $debugSetlog=1 Then Setlog("for matchmode = " & $pMatchMode & " and troop " & $TroopKind & " " & NameOfTroop($TroopKind) & " DISCARD",$COLOR_DEBUG1)
					If $debugSetlog = 1 Then Setlog("Discard use hero/poison " & $troopKind &  " " & NameOfTroop($troopKind), $COLOR_ERROR)
					$troopKind = -1
				EndIf
			EndIf

			$Plural = 0
			If $aTemp[$i][1] > 1 then $Plural = 1
			If $troopKind <> -1 Then SetLog($aTemp[$i][2] & " » " & $aTemp[$i][1] & " " & NameOfTroop($atkTroops[$i][0], $Plural), $COLOR_SUCCESS)
		EndIf
    Next

    ;ResumeAndroid()

	If $debugSetLog=1 Then Setlog("troopsnumber  = " & $troopsnumber)
	Return $troopsnumber
EndFunc   ;==>PrepareAttack

Func IsTroopToBeUsed($pMatchMode, $pTroopType)
	If $pMatchMode = $DT Or $pMatchMode = $TB  Then Return True
	If $pMatchMode = $MA Then
		Local $tempArr = $troopsToBeUsed[$iCmbSelectTroop[$DB]]
	Else
		Local $tempArr = $troopsToBeUsed[$iCmbSelectTroop[$pMatchMode]]
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
	If $pmatchMode <> $DB and $pmatchMode <> $LB and $pmatchMode <> $TS and $pmatchMode <> $MA Then
		Return True
	Else
		Switch $pTroopType
			Case $eKing
				Switch $pmatchMode
					Case $DB
						 If BitAND($iHeroAttack[$DB], $HERO_KING) = $HERO_KING Then Return True
					Case $LB
						 If BitAND($iHeroAttack[$LB], $HERO_KING) = $HERO_KING Then Return True
					Case $TS
						 If BitAND($iHeroAttack[$TS], $HERO_KING) = $HERO_KING Then Return True
					Case $MA
						 If BitAND($iHeroAttack[$DB], $HERO_KING) = $HERO_KING Then Return True
				EndSwitch
			Case $eQueen
				Switch $pmatchMode
					Case $DB
						 If BitAND($iHeroAttack[$DB], $HERO_QUEEN) = $HERO_QUEEN Then Return True
					Case $LB
						 If BitAND($iHeroAttack[$LB], $HERO_QUEEN) = $HERO_QUEEN Then Return True
					Case $TS
						 If BitAND($iHeroAttack[$TS], $HERO_QUEEN) = $HERO_QUEEN Then Return True
					Case $MA
						 If BitAND($iHeroAttack[$DB], $HERO_QUEEN) = $HERO_QUEEN Then Return True
				EndSwitch
			case $eWarden
				Switch $pmatchMode
					Case $DB
						 If BitAND($iHeroAttack[$DB], $HERO_WARDEN) = $HERO_WARDEN Then Return True
					Case $LB
						 If BitAND($iHeroAttack[$LB], $HERO_WARDEN) = $HERO_WARDEN Then Return True
					Case $TS
						 If BitAND($iHeroAttack[$TS], $HERO_WARDEN) = $HERO_WARDEN Then Return True
					Case $MA
						 If BitAND($iHeroAttack[$DB], $HERO_WARDEN) = $HERO_WARDEN Then Return True
				EndSwitch
			Case $eCastle
				Switch $pmatchMode
					Case $DB
						 If $iDropCC[$DB] = 1 Then Return True
					Case $LB
						 If $iDropCC[$LB] = 1 Then Return True
					Case $TS
						 If $iDropCC[$TS] = 1 Then Return True
					Case $MA
						 If $iDropCC[$DB] = 1 Then Return True
				EndSwitch
			Case  $eLSpell
				Switch $pmatchMode
					Case $DB
						 If $ichkLightSpell[$DB] = 1 Or $ichkSmartZap = 1 Then Return True
					Case $LB
						 If $ichkLightSpell[$LB] = 1 Or $ichkSmartZap = 1 Then Return True
					Case $TS
						 If $ichkLightSpell[$TS] = 1 Or $ichkSmartZap = 1 Then Return True
					Case $MA
						 If $ichkLightSpell[$DB] = 1 Or $ichkSmartZap = 1 Then Return True
				EndSwitch
			Case  $eHSpell
				Switch $pmatchMode
					Case $DB
						 If $ichkHealSpell[$DB] = 1 Then Return True
					Case $LB
						 If $ichkHealSpell[$LB] = 1 Then Return True
					Case $TS
						 If $ichkHealSpell[$TS] = 1 Then Return True
					Case $MA
						 If $ichkHealSpell[$DB] = 1 Then Return True
				EndSwitch
			Case  $eRSpell
				Switch $pmatchMode
					Case $DB
						 If $ichkRageSpell[$DB] = 1 Then Return True
					Case $LB
						 If $ichkRageSpell[$LB] = 1 Then Return True
					Case $TS
						 If $ichkRageSpell[$TS] = 1 Then Return True
					Case $MA
						 If $ichkRageSpell[$DB] = 1 Then Return True
				EndSwitch
			Case  $eJSpell
				Switch $pmatchMode
					Case $DB
						 If $ichkJumpSpell[$DB] = 1 Then Return True
					Case $LB
						 If $ichkJumpSpell[$LB] = 1 Then Return True
					Case $TS
						 If $ichkJumpSpell[$TS] = 1 Then Return True
					Case $MA
						 If $ichkJumpSpell[$DB] = 1 Then Return True
				EndSwitch
			Case  $eFSpell
				Switch $pmatchMode
					Case $DB
						 If $ichkFreezeSpell[$DB] = 1 Then Return True
					Case $LB
						 If $ichkFreezeSpell[$LB] = 1 Then Return True
					Case $TS
						 If $ichkFreezeSpell[$TS] = 1 Then Return True
					Case $MA
						 If $ichkFreezeSpell[$DB] = 1 Then Return True
				EndSwitch
			Case  $ePSpell
				Switch $pmatchMode
					Case $DB
						 If $ichkPoisonSpell[$DB]  = 1 Then Return True
					Case $LB
						 If $ichkPoisonSpell[$LB] = 1 Then Return True
					Case $TS
						 If $ichkPoisonSpell[$TS] = 1 Then Return True
					Case $MA
						 If $ichkPoisonSpell[$DB] = 1 Then Return True
				EndSwitch
			Case  $eESpell
				Switch $pmatchMode
					Case $DB
						 If $ichkEarthquakeSpell[$DB] = 1 Then Return True
					Case $LB
						 If $ichkEarthquakeSpell[$LB] = 1 Then Return True
					Case $TS
						 If $ichkEarthquakeSpell[$TS] = 1 Then Return True
					Case $MA
						 If $ichkEarthquakeSpell[$DB] = 1 Then Return True
				EndSwitch
			Case  $eHaSpell
				Switch $pmatchMode
					Case $DB
						 If $ichkHasteSpell[$DB] = 1 Then Return True
					Case $LB
						 If $ichkHasteSpell[$LB] = 1 Then Return True
					Case $TS
						 If $ichkHasteSpell[$TS] = 1 Then Return True
					Case $MA
						 If $ichkHasteSpell[$DB] = 1 Then Return True
				EndSwitch
			Case $eCSpell
				Switch $pmatchMode
					Case $DB
						 If $ichkCloneSpell[$DB] = 1 Then Return True
					Case $LB
						 If $ichkCloneSpell[$LB] = 1 Then Return True
					Case $TS
						 If $ichkCloneSpell[$TS] = 1 Then Return True
					Case $MA
						 If $ichkCloneSpell[$DB] = 1 Then Return True
				EndSwitch
			Case  $eSkSpell
				Switch $pmatchMode
					Case $DB
						 If $ichkSkeletonSpell[$DB] = 1 Then Return True
					Case $LB
						 If $ichkSkeletonSpell[$LB] = 1 Then Return True
					Case $TS
						 If $ichkSkeletonSpell[$TS] = 1 Then Return True
					Case $MA
						 If $ichkSkeletonSpell[$DB] = 1 Then Return True
				EndSwitch
			Case Else
				Return False
		EndSwitch
		Return False
	EndIf
EndFunc
