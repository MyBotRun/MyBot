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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
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

 	Local $diamondx = $MilkFarmOffsetX + $MilkFarmOffsetXStep * $MilkFarmResMaxTilesFromBorder
 	Local $diamondy = $MilkFarmOffsetY + $MilkFarmOffsetYStep * $MilkFarmResMaxTilesFromBorder
 	If UBound($pixelCoord) = 2 Then

		;adjust********************************************************************************************************************
		Switch $type
			Case "gomine"
				Local $px = StringSplit($MilkFarmOffsetMine[$level], "-", 2)
			Case "elixir"
				Local $px = StringSplit($MilkFarmOffsetElixir[$level], "-", 2)
			Case "ddrill"
				Local $px = StringSplit($MilkFarmOffsetDark[$level], "-", 2)
			Case Else
				Local $px = StringSplit("0-0", "-", 2)
		EndSwitch
		$pixelCoord[0] += $px[0]
		$pixelCoord[1] += $px[1]

		Local $vector = $pixelTopLeft
		For $i = 0 To UBound($vector) - 1
			Local $pixelCoord2 = $vector[$i]
			If UBound($pixelCoord2) = 2 Then
				If Abs(($pixelCoord[0] - $pixelCoord2[0]) / $diamondx) + Abs(($pixelCoord[1] - $pixelCoord2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixelCoord2[0] & "-" & $pixelCoord2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $DebugSetLog = 1 Then Setlog("MilkingRedAreaPointsNearStructure Discard error #3", $color_red)
			EndIf
		Next

		Local $vector = $pixelTopRight
		For $i = 0 To UBound($vector) - 1
			Local $pixelCoord2 = $vector[$i]
			If UBound($pixelCoord2) = 2 Then
				If Abs(($pixelCoord[0] - $pixelCoord2[0]) / $diamondx) + Abs(($pixelCoord[1] - $pixelCoord2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixelCoord2[0] & "-" & $pixelCoord2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $DebugSetLog = 1 Then Setlog("MilkingRedAreaPointsNearStructure Discard error #3", $color_red)
			EndIf
		Next

		Local $vector = $pixelBottomLeft
		For $i = 0 To UBound($vector) - 1
			Local $pixelCoord2 = $vector[$i]
			If UBound($pixelCoord2) = 2 Then
				If Abs(($pixelCoord[0] - $pixelCoord2[0]) / $diamondx) + Abs(($pixelCoord[1] - $pixelCoord2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixelCoord2[0] & "-" & $pixelCoord2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $DebugSetLog = 1 Then Setlog("MilkingRedAreaPointsNearStructure Discard error #3", $color_red)
			EndIf
		Next

		Local $vector = $pixelBottomRight
		For $i = 0 To UBound($vector) - 1
			Local $pixelCoord2 = $vector[$i]
			If UBound($pixelCoord2) = 2 Then
				If Abs(($pixelCoord[0] - $pixelCoord2[0]) / $diamondx) + Abs(($pixelCoord[1] - $pixelCoord2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixelCoord2[0] & "-" & $pixelCoord2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $DebugSetLog = 1 Then Setlog("MilkingRedAreaPointsNearStructure Discard error #3", $color_red)
			EndIf
		Next

;~ 		If $ResourceToInsertQty > 0 Then
;~ 			If StringLen($MilkFarmObjectivesSTR) > 0 Then $MilkFarmObjectivesSTR &= "|"
;~ 			$MilkFarmObjectivesSTR &= $ResourceToInsert
;~ 		EndIf
		 If $debugsetlog=1 Then Setlog("$ResourceToInsertQty = " & $ResourceToInsertQty & " value " & $ResourceToInsert,$color_purple)
		 Return $ResourceToInsert
 	Else
 		If $DebugSetLog = 1 Then Setlog("MilkingRedAreaPointsNearStructure Discard error #1 " & $pixelCoord & " " & UBound($pixelCoord), $color_red)
 	EndIf

;~ 	Return $ResourceToInsertQty
EndFunc   ;==>MilkingRedAreaPointsNearStructure
