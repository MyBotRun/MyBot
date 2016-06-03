; #FUNCTION# ====================================================================================================================
; Name ..........: MakeDropLine
; Description ...:
; Syntax ........: MakeDropLine($searchvect, $startpoint, $endpoint)
; Parameters ....: $searchvect          - array
;                  $startpoint
;                  $endpoint
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func MakeDropLine($searchvect, $startpoint, $endpoint)
	Local $point1 = $startpoint
	Local $ReturnVect
	$ReturnVect = $startpoint[0] & "-" & $startpoint[1]
	Local $t, $f
	$t = 0
	$f = 0
	For $i = $startpoint[0] + 1 To $endpoint[0]
		For $j = $t To UBound($searchvect) - 1
			$pixel = $searchvect[$j]
			If $i < $pixel[0] Then
				Local $h = Line2Points($point1, $pixel, $i)
				If $h > 620 Then $h = 620
				$ReturnVect &= "|" & $i & "-" & $h
				$f = $i
				ExitLoop
			Else
				If $i = $pixel[0] Then
					Local $h = $pixel[1]
					If $h > 620 Then $h = 620
					$ReturnVect &= "|" & $pixel[0] & "-" & $h
					$point1 = $pixel
					$t = $j + 1
					$f = $i
					ExitLoop
				EndIf
			EndIf
		Next
	Next
	For $i = $f + 1 To $endpoint[0]
		Local $h = Line2Points($point1, $endpoint, $i)
		If $h > 620 Then $h = 620
		$ReturnVect &= "|" & $i & "-" & $h
	Next
	Return GetListPixel($ReturnVect)
EndFunc   ;==>MakeDropLine
