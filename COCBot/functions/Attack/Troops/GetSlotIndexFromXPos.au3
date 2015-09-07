Func GetSlotIndexFromXPos($xPos)
	For $slot = 0 To 11
		If $xPos < 68 + ($slot * 72) Then
			Return $slot
		EndIf
	Next
EndFunc   ;==>GetSlotIndexFromXPos
