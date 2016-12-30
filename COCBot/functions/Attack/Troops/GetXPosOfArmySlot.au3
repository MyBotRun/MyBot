; #FUNCTION# ====================================================================================================================
; Name ..........: GetXPosOfArmySlot
; Description ...:
; Syntax ........: GetXPosOfArmySlot($slotNumber, $xOffsetFor11Slot)
; Parameters ....: $slotNumber          - a string value.
;                  $xOffsetFor11Slot    - an unknown value.
; Return values .: None
; Author ........:
; Modified ......: Promac 12-2016
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetXPosOfArmySlot($slotNumber, $xOffsetFor11Slot)

	Local $CheckSlot12, $SlotPixelColorTemp, $SlotPixelColor1

	$xOffsetFor11Slot -= 8

	Switch $slotNumber
		Case 7
			$SlotComp = 1
		Case Else
			$SlotComp = 0
	EndSwitch

	If $slotNumber = $King Or $slotNumber = $Queen Or $slotNumber = $Warden Then $xOffsetFor11Slot += 8

	; check Dark color on slot 0 to verify if exists > 11 slots
	; $SlotPixelColor = _ColorCheck(_GetPixelColor(17, 580 + $bottomOffsetY, True), Hex(0x07202A, 6), 20)
	$CheckSlot12 = _ColorCheck(_GetPixelColor(17, 643, True), Hex(0x478AC6, 6), 15) Or _  	; Slot Filled / Background Blue / More than 11 Slots
					_ColorCheck(_GetPixelColor(17, 643, True), Hex(0x434343, 6), 10)   		; Slot deployed / Gray / More than 11 Slots


	If $debugSetlog = 1 Then
		Setlog(" Slot 0  _ColorCheck 0x478AC6 at (17," & 643 & "): " & $CheckSlot12, $COLOR_DEBUG) ;Debug
		$SlotPixelColorTemp = _GetPixelColor(17, 643, $bCapturePixel)
		Setlog(" Slot 0  _GetPixelColo(17," & 643 & "): " & $SlotPixelColorTemp, $COLOR_DEBUG) ;Debug
	EndIf

	If $CheckSlot12 = False Then
		Return $xOffsetFor11Slot + $SlotComp + ($slotNumber * 72)
	Else
		Return $xOffsetFor11Slot + $SlotComp + ($slotNumber * 72) - 13
	EndIf

EndFunc   ;==>GetXPosOfArmySlot