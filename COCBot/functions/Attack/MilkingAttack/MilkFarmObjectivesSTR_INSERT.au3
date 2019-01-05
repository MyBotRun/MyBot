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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
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
	Local $pixel = StringSplit($coordinate, "-", 2)

	Local $diamondx = $g_iMilkFarmOffsetX + $g_iMilkFarmOffsetXStep * $g_iMilkFarmResMaxTilesFromBorder
	Local $diamondy = $g_iMilkFarmOffsetY + $g_iMilkFarmOffsetYStep * $g_iMilkFarmResMaxTilesFromBorder
	If UBound($pixel) = 2 Then

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
		$pixel[0] += $px[0]
		$pixel[1] += $px[1]

		Local $vector = $g_aiPixelTopLeft
		For $i = 0 To UBound($vector) - 1
			Local $pixel2 = $vector[$i]
			If UBound($pixel2) = 2 Then
				If Abs(($pixel[0] - $pixel2[0]) / $diamondx) + Abs(($pixel[1] - $pixel2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixel2[0] & "-" & $pixel2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("MilkFarmObjectivesSTR_INSERT Discard error #3", $COLOR_ERROR)
			EndIf
		Next

		Local $vector = $g_aiPixelTopRight
		For $i = 0 To UBound($vector) - 1
			Local $pixel2 = $vector[$i]
			If UBound($pixel2) = 2 Then
				If Abs(($pixel[0] - $pixel2[0]) / $diamondx) + Abs(($pixel[1] - $pixel2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixel2[0] & "-" & $pixel2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("MilkFarmObjectivesSTR_INSERT Discard error #3", $COLOR_ERROR)
			EndIf
		Next

		Local $vector = $g_aiPixelBottomLeft
		For $i = 0 To UBound($vector) - 1
			Local $pixel2 = $vector[$i]
			If UBound($pixel2) = 2 Then
				If Abs(($pixel[0] - $pixel2[0]) / $diamondx) + Abs(($pixel[1] - $pixel2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixel2[0] & "-" & $pixel2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("MilkFarmObjectivesSTR_INSERT Discard error #3", $COLOR_ERROR)
			EndIf
		Next

		Local $vector = $g_aiPixelBottomRight
		For $i = 0 To UBound($vector) - 1
			Local $pixel2 = $vector[$i]
			If UBound($pixel2) = 2 Then
				If Abs(($pixel[0] - $pixel2[0]) / $diamondx) + Abs(($pixel[1] - $pixel2[1]) / $diamondy) <= 1 Then ;insidediamond
					$ResourceToInsert &= "." & $pixel2[0] & "-" & $pixel2[1]
					$ResourceToInsertQty += 1
				EndIf
			Else
				If $g_bDebugSetlog Then SetDebugLog("MilkFarmObjectivesSTR_INSERT Discard error #3", $COLOR_ERROR)
			EndIf
		Next

		If $ResourceToInsertQty > 0 Then
			If StringLen($g_sMilkFarmObjectivesSTR) > 0 Then $g_sMilkFarmObjectivesSTR &= "|"
			$g_sMilkFarmObjectivesSTR &= $ResourceToInsert
		EndIf
	Else
		If $g_bDebugSetlog Then SetDebugLog("MilkFarmObjectivesSTR_INSERT Discard error #1 " & $pixel & " " & UBound($pixel), $COLOR_ERROR)
	EndIf

	Return $ResourceToInsertQty
EndFunc   ;==>MilkFarmObjectivesSTR_INSERT
