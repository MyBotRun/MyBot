Func OldDropTroop($troop, $position, $nbperspot)
	SelectDropTroop($troop) ;Select Troop
	If _Sleep($iDelayOldDropTroop1) Then Return
	For $i = 0 To 4
		Click($position[$i][0], $position[$i][1], $nbperspot, 1,"#0110")
		If _Sleep($iDelayOldDropTroop2) Then Return
	Next
EndFunc   ;==>OldDropTroop
