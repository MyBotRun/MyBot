; #FUNCTION# ====================================================================================================================
; Name ..........: MilkingRedAreaPointsNearStructure.au3
; Description ...:
; Syntax ........: MilkingRedAreaPointsNearStructure($type, $level, $coordinate)
; Parameters ....: $type-building type
;				   $level-level of building
;				   $coordinate-location of building
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func MilkingRedAreaPointsNearStructure($type, $level, $coordinate)



	Local $ResourceToInsertQty = 0
	Local $ResourceToInsert = ""
;~ 	$ResourceToInsert = $type
;~ 	$ResourceToInsert &= "." & $level
;~ 	$ResourceToInsert &= "." & $coordinate
	Local $pixelCoord = StringSplit($coordinate, "-", 2)

	Local $diamondx = $g_iMilkFarmOffsetX + $g_iMilkFarmOffsetXStep * $g_iMilkFarmResMaxTilesFromBorder
	Local $diamondy = $g_iMilkFarmOffsetY + $g_iMilkFarmOffsetYStep * $g_iMilkFarmResMaxTilesFromBorder
	If UBound($pixelCoord) = 2 Then

		;adjust********************************************************************************************************************
		Switch $type
			Case "gomine"
				Local $px = StringSplit($g_asMilkFarmOffsetMine[$level], "-", 2)
			Case "elixir"
				Local $px = StringSplit($g_asMilkFarmOffsetElixir[$level], "-", 2)
			Case "ddrill"
				Local $px = StringSplit($g_asMilkFarmOffsetDark[$level], "-", 2)
			Case Else
				Local $px = StringSplit("0-0", "-", 2)
		EndSwitch
		$pixelCoord[0] += $px[0]
		$pixelCoord[1] += $px[1]

		Local $vector = $g_aiPixelTopLeft
		For $i = 0 To UBound($vector) - 1
			Local $pixelCoord2 = $vector[$i]
			If UBound($pixelCoord2) = 2 Then
				If Abs(($pixelCoord[0] - $pixelCoord2[0]) / $diamondx) + Abs(($pixelCoord[1] - $pixelCoord2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixelCoord2[0] & "-" & $pixelCoord2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("MilkingRedAreaPointsNearStructure Discard error #3", $COLOR_ERROR)
			EndIf
		Next

		Local $vector = $g_aiPixelTopRight
		For $i = 0 To UBound($vector) - 1
			Local $pixelCoord2 = $vector[$i]
			If UBound($pixelCoord2) = 2 Then
				If Abs(($pixelCoord[0] - $pixelCoord2[0]) / $diamondx) + Abs(($pixelCoord[1] - $pixelCoord2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixelCoord2[0] & "-" & $pixelCoord2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("MilkingRedAreaPointsNearStructure Discard error #3", $COLOR_ERROR)
			EndIf
		Next

		Local $vector = $g_aiPixelBottomLeft
		For $i = 0 To UBound($vector) - 1
			Local $pixelCoord2 = $vector[$i]
			If UBound($pixelCoord2) = 2 Then
				If Abs(($pixelCoord[0] - $pixelCoord2[0]) / $diamondx) + Abs(($pixelCoord[1] - $pixelCoord2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixelCoord2[0] & "-" & $pixelCoord2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("MilkingRedAreaPointsNearStructure Discard error #3", $COLOR_ERROR)
			EndIf
		Next

		Local $vector = $g_aiPixelBottomRight
		For $i = 0 To UBound($vector) - 1
			Local $pixelCoord2 = $vector[$i]
			If UBound($pixelCoord2) = 2 Then
				If Abs(($pixelCoord[0] - $pixelCoord2[0]) / $diamondx) + Abs(($pixelCoord[1] - $pixelCoord2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixelCoord2[0] & "-" & $pixelCoord2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("MilkingRedAreaPointsNearStructure Discard error #3", $COLOR_ERROR)
			EndIf
		Next

;~ 		If $ResourceToInsertQty > 0 Then
;~ 			If StringLen($g_sMilkFarmObjectivesSTR) > 0 Then $g_sMilkFarmObjectivesSTR &= "|"
;~ 			$g_sMilkFarmObjectivesSTR &= $ResourceToInsert
;~ 		EndIf
		If $g_bDebugSetlog Then SetDebugLog("$ResourceToInsertQty = " & $ResourceToInsertQty & " value " & $ResourceToInsert, $COLOR_DEBUG)
		Return $ResourceToInsert
	Else
		If $g_bDebugSetlog Then SetDebugLog("MilkingRedAreaPointsNearStructure Discard error #1 " & $pixelCoord & " " & UBound($pixelCoord), $COLOR_ERROR)
	EndIf

;~ 	Return $ResourceToInsertQty
EndFunc   ;==>MilkingRedAreaPointsNearStructure
