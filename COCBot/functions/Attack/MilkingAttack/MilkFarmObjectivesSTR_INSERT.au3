; #FUNCTION# ====================================================================================================================
; Name ..........: MilkFarmObjectivesSTR_INSERT.au3
; Description ...: Inserts a building into objective string
; Syntax ........: MilkFarmObjectivesSTR_INSERT($type, $level, $coordinate)
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

Func MilkFarmObjectivesSTR_INSERT($type, $level, $coordinate)

	Local $ResourceToInsertQty = 0
	Local $ResourceToInsert = ""
	$ResourceToInsert = $type
	$ResourceToInsert &= "." & $level
	$ResourceToInsert &= "." & $coordinate
	$pixel = StringSplit($coordinate, "-", 2)

	Local $diamondx = $MilkFarmOffsetX + $MilkFarmOffsetXStep * $MilkFarmResMaxTilesFromBorder
	Local $diamondy = $MilkFarmOffsetY + $MilkFarmOffsetYStep * $MilkFarmResMaxTilesFromBorder
	If UBound($pixel) = 2 Then

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
		$pixel[0] += $px[0]
		$pixel[1] += $px[1]

		Local $vector = $PixelTopLeft
		For $i = 0 To UBound($vector) - 1
			Local $pixel2 = $vector[$i]
			If UBound($pixel2) = 2 Then
				If Abs(($pixel[0] - $pixel2[0]) / $diamondx) + Abs(($pixel[1] - $pixel2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixel2[0] & "-" & $pixel2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $DebugSetLog = 1 Then Setlog("MilkFarmObjectivesSTR_INSERT Discard error #3", $color_red)
			EndIf
		Next

		Local $vector = $PixelTopRight
		For $i = 0 To UBound($vector) - 1
			Local $pixel2 = $vector[$i]
			If UBound($pixel2) = 2 Then
				If Abs(($pixel[0] - $pixel2[0]) / $diamondx) + Abs(($pixel[1] - $pixel2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixel2[0] & "-" & $pixel2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $DebugSetLog = 1 Then Setlog("MilkFarmObjectivesSTR_INSERT Discard error #3", $color_red)
			EndIf
		Next

		Local $vector = $PixelBottomLeft
		For $i = 0 To UBound($vector) - 1
			Local $pixel2 = $vector[$i]
			If UBound($pixel2) = 2 Then
				If Abs(($pixel[0] - $pixel2[0]) / $diamondx) + Abs(($pixel[1] - $pixel2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixel2[0] & "-" & $pixel2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $DebugSetLog = 1 Then Setlog("MilkFarmObjectivesSTR_INSERT Discard error #3", $color_red)
			EndIf
		Next

		Local $vector = $PixelBottomRight
		For $i = 0 To UBound($vector) - 1
			Local $pixel2 = $vector[$i]
			If UBound($pixel2) = 2 Then
				If Abs(($pixel[0] - $pixel2[0]) / $diamondx) + Abs(($pixel[1] - $pixel2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixel2[0] & "-" & $pixel2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $DebugSetLog = 1 Then Setlog("MilkFarmObjectivesSTR_INSERT Discard error #3", $color_red)
			EndIf
		Next

		If $ResourceToInsertQty > 0 Then
			If StringLen($MilkFarmObjectivesSTR) > 0 Then $MilkFarmObjectivesSTR &= "|"
			$MilkFarmObjectivesSTR &= $ResourceToInsert
		EndIf
	Else
		If $DebugSetLog = 1 Then Setlog("MilkFarmObjectivesSTR_INSERT Discard error #1 " & $pixel & " " & UBound($pixel), $color_red)
	EndIf

	Return $ResourceToInsertQty
EndFunc   ;==>MilkFarmObjectivesSTR_INSERT
