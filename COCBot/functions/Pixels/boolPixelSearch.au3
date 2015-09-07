;==============================================================================================================
;===Check Pixels===============================================================================================
;--------------------------------------------------------------------------------------------------------------
;Using _ColorCheck, checks compares multiple pixels and returns true if they all pass _ColorCheck.
;--------------------------------------------------------------------------------------------------------------

Func boolPixelSearch($pixel1, $pixel2, $pixel3, $variation = 10)
	If _ColorCheck(_GetPixelColor($pixel1[0], $pixel1[1]), $pixel1[2], $variation) And _ColorCheck(_GetPixelColor($pixel2[0], $pixel2[1]), $pixel2[2], $variation) And _ColorCheck(_GetPixelColor($pixel3[0], $pixel3[1]), $pixel3[2], $variation) Then Return True
	Return False
EndFunc   ;==>boolPixelSearch