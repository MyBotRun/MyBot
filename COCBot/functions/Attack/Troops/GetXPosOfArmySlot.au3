; #FUNCTION# ====================================================================================================================
; Name ..........: GetXPosOfArmySlot
; Description ...:
; Syntax ........: GetXPosOfArmySlot($slotNumber, $xOffsetFor11Slot)
; Parameters ....: $slotNumber          - a string value.
;                  $xOffsetFor11Slot    - an unknown value.
; Return values .: None
; Author ........:
; Modified ......: Promac(12-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetXPosOfArmySlot($slotNumber, $xOffsetFor11Slot)

	If $slotNumber < 0 Or $slotNumber + 1 > UBound($g_avAttackTroops) Then
		; invalid slot
		Return 0
	EndIf

	; use x-cord from $g_avAttackTroops
	Return $g_avAttackTroops[$slotNumber][2]

	#cs
	Local $CheckSlot12, $SlotPixelColorTemp, $SlotPixelColor1

	$xOffsetFor11Slot -= 8

	Local $SlotComp = ($slotNumber = 7 ? 1 : 0)

	If $slotNumber = $g_iKingSlot Or $slotNumber = $g_iQueenSlot Or $slotNumber = $g_iWardenSlot Then $xOffsetFor11Slot += 8

	If $g_bDraggedAttackBar Then Return $xOffsetFor11Slot + $SlotComp + ($slotNumber * 72) + 14 ; Slot11+

	; check Dark color on slot 0 to verify if exists > 11 slots
	; $SlotPixelColor = _ColorCheck(_GetPixelColor(17, 580 + $g_iBottomOffsetY, True), Hex(0x07202A, 6), 20)
	$CheckSlot12 = _ColorCheck(_GetPixelColor(17, 643, True), Hex(0x478AC6, 6), 15) Or _  	 ; Slot Filled / Background Blue / More than 11 Slots
			_ColorCheck(_GetPixelColor(17, 643, True), Hex(0x434343, 6), 10) ; Slot deployed / Gray / More than 11 Slots


	If $g_bDebugSetlog Then
		SetDebugLog(" Slot 0  _ColorCheck 0x478AC6 at (17," & 643 & "): " & $CheckSlot12, $COLOR_DEBUG) ;Debug
		$SlotPixelColorTemp = _GetPixelColor(17, 643, $g_bCapturePixel)
		SetDebugLog(" Slot 0  _GetPixelColo(17," & 643 & "): " & $SlotPixelColorTemp, $COLOR_DEBUG) ;Debug
	EndIf

	If Not $CheckSlot12 Then
		Return $xOffsetFor11Slot + $SlotComp + ($slotNumber * 72)
	Else
		Return $xOffsetFor11Slot + $SlotComp + ($slotNumber * 72) - 13
	EndIf
	#ce
EndFunc   ;==>GetXPosOfArmySlot
