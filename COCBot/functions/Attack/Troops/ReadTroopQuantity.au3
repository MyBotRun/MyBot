;
; #FUNCTION# ====================================================================================================================
; Name ..........: ReadTroopQuantity
; Description ...: Read the quantity for a given troop
; Syntax ........: ReadTroopQuantity($Troop)
; Parameters ....: $Troop               - an unknown value.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ReadTroopQuantity($Troop, $CheckSelectedSlot = False, $bNeedNewCapture = True)
	Local $iAmount
	Switch $CheckSelectedSlot
		Case False
			$iAmount = getTroopCountSmall(GetXPosOfArmySlot($Troop, 47), 640)
			If $iAmount = "" Then
				$iAmount = getTroopCountBig(GetXPosOfArmySlot($Troop, 47), 633)
			EndIf
		Case Else
			Local $rGetXPosOfArmySlot = GetXPosOfArmySlot($Troop, 47)
			Local $isTheSlotSelected = IsSlotSelected($Troop, $bNeedNewCapture)
			If Not $isTheSlotSelected Then
				$iAmount = Number(getTroopCountSmall($rGetXPosOfArmySlot, 640))
			Else
				$iAmount = Number(getTroopCountBig($rGetXPosOfArmySlot, 633))
			EndIf
	EndSwitch
	Return Number($iAmount)
EndFunc   ;==>ReadTroopQuantity

Func UpdateTroopQuantity($sTroop, $bNeedNewCapture = Default)
	If Not $bNeedNewCapture Then $bNeedNewCapture = True
	If $bNeedNewCapture Then
		_CaptureRegion2()
	EndIf

	; Get the integer index of the troop name specified
	Local $troopName = $sTroop
	Local $iTroopIndex = TroopIndexLookup($troopName)
	If $iTroopIndex = -1 Then
		SetLog("'UpdateTroopQuantity' troop name '" & $troopName & "' is unrecognized.")
		Return
	EndIf

	Local $troopPosition = -1
	For $i = 0 To UBound($g_avAttackTroops) - 1
		If $g_avAttackTroops[$i][0] = $iTroopIndex Then
			$troopPosition = $i
			ExitLoop
		EndIf
	Next

	If Not $g_bRunState Then Return
	If $troopPosition <> -1 Then
		Local $iQuantity = ReadTroopQuantity($troopPosition, True, Not $bNeedNewCapture)
		$g_avAttackTroops[$troopPosition][1] = $iQuantity
	EndIf
	Return $troopPosition ; Return Troop Position in the Array, will be the slot of Troop in Attack bar
EndFunc   ;==>UpdateTroopQuantity

Func IsSlotSelected($iSlotIndex, $bNeedNewCapture = Default)
	; $iSlotIndex Starts from 0
	If Not $bNeedNewCapture Then $bNeedNewCapture = True
	If $bNeedNewCapture Then
		ForceCaptureRegion()
		_CaptureRegion()
	EndIf
	Local $iOffset = 73
	Local $iStartX = 75
	Local $iY = 724
	If $bNeedNewCapture Then
		Return _ColorCheck( _
				_GetPixelColor($iStartX + ($iOffset * $iSlotIndex), $iY, False), _ ; capture color #1
				Hex(0xFFFFFF, 6), _ ; compare to Color #2 from screencode
				20)
	Else
		Return _ColorCheck( _
				Hex(_GDIPlus_BitmapGetPixel(_GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2), ($iStartX + ($iOffset * $iSlotIndex)), $iY), 6), _ ; Get pixel color
				Hex(0xFFFFFF, 6), _ ; compare to Color #2 from screencode
				20)
	EndIf
EndFunc   ;==>IsSlotSelected
