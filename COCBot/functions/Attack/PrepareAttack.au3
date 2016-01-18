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
	If $debugSetlog = 1 Then SetLog("PrepareAttack",$COLOR_PURPLE)
	If $Remaining Then
		SetLog("Checking remaining unused troops for: " & $sModeText[$pMatchMode], $COLOR_BLUE)
	Else
		SetLog("Initiating attack for: " & $sModeText[$pMatchMode], $COLOR_RED)
	EndIf

	_WinAPI_DeleteObject($hBitmapFirst)
	$hBitmapFirst = _CaptureRegion2(0, 571 + $bottomOffsetY, 859, 671 + $bottomOffsetY)
	If _Sleep($iDelayPrepareAttack1) Then Return
	Local $result = DllCall($hFuncLib, "str", "searchIdentifyTroop", "ptr", $hBitmapFirst)
	If $debugSetlog = 1 Then Setlog("DLL Troopsbar list: " & $result[0], $COLOR_PURPLE)
	Local $aTroopDataList = StringSplit($result[0], "|")
	Local $aTemp[12][3]
	If $result[0] <> "" Then
		For $i = 1 To $aTroopDataList[0]
			Local $troopData = StringSplit($aTroopDataList[$i], "#", $STR_NOCOUNT)
			$aTemp[Number($troopData[1])][0] = $troopData[0]
			$aTemp[Number($troopData[1])][1] = Number($troopData[2])
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
			ElseIf ($troopKind = $eKing) Or ($troopKind = $eQueen) Or ($troopKind = $eCastle) Or ($troopKind = $eWarden) Then
				$atkTroops[$i][1] = ""
			Else
				$atkTroops[$i][1] = $aTemp[$i][1]
			EndIf
			If $troopKind <> -1 Then SetLog("-*-" & NameOfTroop($atkTroops[$i][0]) & " " & $atkTroops[$i][1], $COLOR_GREEN)
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
