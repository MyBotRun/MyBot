; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttack
; Description ...: Checks the troops when in battle, checks for type, slot, and quantity.  Saved in $atkTroops[SLOT][TYPE/QUANTITY] variable
; Syntax ........: PrepareAttack($pMatchMode[, $Remaining = False])
; Parameters ....: $pMatchMode          - a pointer value.
;                  $Remaining           - [optional] Flag for when checking remaining troops. Default is False.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func PrepareAttack($pMatchMode, $Remaining = False) ;Assigns troops
	If $Remaining Then
		SetLog("Checking remaining unused troops for: " & $sModeText[$pMatchMode], $COLOR_BLUE)
	Else
		SetLog("Initiating attack for: " & $sModeText[$pMatchMode], $COLOR_RED)
	EndIf

	_WinAPI_DeleteObject($hBitmapFirst)
	$hBitmapFirst = _CaptureRegion2(0, 571, 859, 671)
	If _Sleep($iDelayPrepareAttack1) Then Return
	Local $result = DllCall($pFuncLib, "str", "searchIdentifyTroop", "ptr", $hBitmapFirst)
	If $debugSetlog = 1 Then Setlog("DLL Troopsbar list: " & $result[0], $COLOR_PURPLE)
	Local $aTroopDataList = StringSplit($result[0], "#")
	Local $aTemp[12][3]
	If $result[0] <> "" Then
		For $i = 1 To $aTroopDataList[0]
			Local $troopData = StringSplit($aTroopDataList[$i], "|", $STR_NOCOUNT)
			Local $xCoord = Number(StringSplit($troopData[1], "-", $STR_NOCOUNT)[0])
			Local $slotIndex = GetSlotIndexFromXPos($xCoord)
			$aTemp[$slotIndex][1] = Number($troopData[2])
			Switch $troopData[0]
				Case "Barbarian"
					$aTemp[$slotIndex][0] = $eBarb
				Case "Archer"
					$aTemp[$slotIndex][0] = $eArch
				Case "Giant"
					$aTemp[$slotIndex][0] = $eGiant
				Case "Goblin"
					$aTemp[$slotIndex][0] = $eGobl
				Case "WallBreaker"
					$aTemp[$slotIndex][0] = $eWall
				Case "Balloon"
					$aTemp[$slotIndex][0] = $eBall
				Case "Wizard"
					$aTemp[$slotIndex][0] = $eWiza
				Case "Healer"
					$aTemp[$slotIndex][0] = $eHeal
				Case "Dragon"
					$aTemp[$slotIndex][0] = $eDrag
				Case "Pekka"
					$aTemp[$slotIndex][0] = $ePekk
				Case "Minion"
					$aTemp[$slotIndex][0] = $eMini
				Case "HogRider"
					$aTemp[$slotIndex][0] = $eHogs
				Case "Valkyrie"
					$aTemp[$slotIndex][0] = $eValk
				Case "Golem"
					$aTemp[$slotIndex][0] = $eGole
				Case "Witch"
					$aTemp[$slotIndex][0] = $eWitc
				Case "LavaHound"
					$aTemp[$slotIndex][0] = $eLava
				Case "King"
					$aTemp[$slotIndex][0] = $eKing
				Case "Queen"
					$aTemp[$slotIndex][0] = $eQueen
				Case "LightSpell"
					$aTemp[$slotIndex][0] = $eLSpell
				Case "HealSpell"
					$aTemp[$slotIndex][0] = $eHSpell
				Case "RageSpell"
					$aTemp[$slotIndex][0] = $eRSpell
				Case "JumpSpell"
					$aTemp[$slotIndex][0] = $eJSpell
				Case "FreezeSpell"
					$aTemp[$slotIndex][0] = $eFSpell
				Case "PoisonSpell"
					$aTemp[$slotIndex][0] = $ePSpell
				Case "EarthquakeSpell"
					$aTemp[$slotIndex][0] = $eESpell
				Case "HasteSpell"
					$aTemp[$slotIndex][0] = $eHaSpell
				Case "Castle"
					$aTemp[$slotIndex][0] = $eCastle
			EndSwitch
		Next
	EndIf
	For $i = 0 To UBound($aTemp) - 1
		If $aTemp[$i][0] = "" And $aTemp[$i][1] = "" Then
			$atkTroops[$i][0] = -1
			$atkTroops[$i][1] = 0
		Else
			$troopKind = $aTemp[$i][0]
			If Not IsTroopToBeUsed($pMatchMode, $troopKind) Then
				$atkTroops[$i][0] = -1
				$troopKind = -1
			Else
				$atkTroops[$i][0] = $troopKind
			EndIf
			If $troopKind = -1 Then
				$atkTroops[$i][1] = 0
			ElseIf ($troopKind = $eKing) Or ($troopKind = $eQueen) Or ($troopKind = $eCastle) Then
				$atkTroops[$i][1] = ""
			Else
				$atkTroops[$i][1] = $aTemp[$i][1]
			EndIf
			If $troopKind <> -1 Then SetLog("-" & NameOfTroop($atkTroops[$i][0]) & " " & $atkTroops[$i][1], $COLOR_GREEN)
		EndIf
	Next
EndFunc   ;==>PrepareAttack

Func IsTroopToBeUsed($pMatchMode, $pTroopType)
	If $pMatchMode = $DT Or $pMatchMode = $TB Or $pMatchMode = $TS Then Return True
	Local $tempArr = $troopsToBeUsed[$iCmbSelectTroop[$pMatchMode]]
	For $x = 0 To UBound($tempArr) - 1
		If $tempArr[$x] = $pTroopType Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>IsTroopToBeUsed
