
; Param : 	$troop : Troop to deploy
;			$arrPixel : Array of pixel where troop are deploy
;			$number : Number of troop to deploy
; Strategy :
; While troop left :
;	If number of troop > number of pixel => Search the number of troop to deploy by pixel
;	Else Search the offset to browse the tab of pixel
;	Browse the tab of pixel and send troop
Func DropOnPixel($troop, $listArrPixel, $number, $slotsPerEdge = 0)

	$nameFunc = "[DropOnPixel]"
	debugRedArea($nameFunc & " IN ")
	debugRedArea("troop : [" & $troop & "] / size arrPixel [" & UBound($listArrPixel) & "] / number [" & $number & "]/ $slotsPerEdge [" & $slotsPerEdge & "] ")
	If ($number = 0 Or UBound($listArrPixel) = 0) Then Return
	If $number = 1 Or $slotsPerEdge = 1 Then ; Drop on a single point per edge => on the middle
		For $i = 0 To UBound($listArrPixel) - 1
			debugRedArea("$listArrPixel $i : [" & $i & "] ")
			Local $arrPixel = $listArrPixel[$i]
			debugRedArea("$arrPixel $UBound($arrPixel) : [" & UBound($arrPixel) & "] ")
			If UBound($arrPixel) > 0 Then
				Local $pixel = $arrPixel[0]
				Click($pixel[0], $pixel[1], $number, $iDelayDropOnPixel2,"#0096")
			EndIf
			If _Sleep($iDelayDropOnPixel1) Then Return
		Next
	ElseIf $slotsPerEdge = 2 Then ; Drop on 2 points per edge
		For $i = 0 To UBound($listArrPixel) - 1
			Local $arrPixel = $listArrPixel[$i]
			If UBound($arrPixel) > 0 Then
				Local $pixel = $arrPixel[0]
				Click($pixel[0], $pixel[1], $number,0,"#0097")
				If _Sleep(SetSleep(0)) Then Return
			EndIf
			If _Sleep(SetSleep(1)) Then Return
		Next
	Else
		For $i = 0 To UBound($listArrPixel) - 1
			debugRedArea("$listArrPixel $i : [" & $i & "] ")
			Local $nbTroopsLeft = $number
			Local $offset = 1
			Local $nbTroopByPixel = 1
			Local $arrPixel = $listArrPixel[$i]
			;	SetLog("UBound($edge) " & UBound($arrPixel) & "$number :"& $number , $COLOR_GREEN)
			While ($nbTroopsLeft > 0)
				If (UBound($arrPixel) = 0) Then
					ExitLoop
				EndIf
				If (UBound($arrPixel) > $nbTroopsLeft) Then
					$offset = UBound($arrPixel) / $nbTroopsLeft
				Else
					$nbTroopByPixel = Floor($number / UBound($arrPixel))
				EndIf
				If ($offset < 1) Then
					$offset = 1
				EndIf
				If ($nbTroopByPixel < 1) Then
					$nbTroopByPixel = 1
				EndIf
				For $j = 0 To UBound($arrPixel) - 1 Step $offset
					Local $index = Round($j)
					If ($index > UBound($arrPixel) - 1) Then
						$index = UBound($arrPixel) - 1
					EndIf
					Local $currentPixel = $arrPixel[Floor($index)]
					Click($currentPixel[0], $currentPixel[1], $nbTroopByPixel,0,"#0098")
					$nbTroopsLeft -= $nbTroopByPixel


					If _Sleep(SetSleep(0)) Then Return
				Next
			WEnd
		Next
	EndIf
	debugRedArea($nameFunc & " OUT ")
EndFunc   ;==>DropOnPixel

