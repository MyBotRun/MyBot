; #FUNCTION# ====================================================================================================================
; Name ..........: DropOnPixel
; Description ...:
; Syntax ........: DropOnPixel($troop, $listArrPixel, $number[, $slotsPerEdge = 0])
; Parameters ....: $troop               - Troop to deploy
;                  $listArrPixel        - Array of pixel where troop are deploy
;                  $number              - Number of troop to deploy
;                  $slotsPerEdge        - [optional] a string value. Default is 0.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; Strategy :
; While troop left :
;	If number of troop > number of pixel => Search the number of troop to deploy by pixel
;	Else Search the offset to browse the tab of pixel
;	Browse the tab of pixel and send troop

Func DropOnPixel($troop, $listArrPixel, $number, $slotsPerEdge = 0)

	If isProblemAffect(True) Then Return
    If Not IsAttackPage() Then Return

	$nameFunc = "[DropOnPixel]"
	debugRedArea($nameFunc & " IN ")
	debugRedArea("troop : [" & $troop & "] / size arrPixel [" & UBound($listArrPixel) & "] / number [" & $number & "]/ $slotsPerEdge [" & $slotsPerEdge & "] ")
	If ($number = 0 Or UBound($listArrPixel) = 0) Then Return
    KeepClicks()
	If $number = 1 Or $slotsPerEdge = 1 Then ; Drop on a single point per edge => on the middle
		For $i = 0 To UBound($listArrPixel) - 1
			debugRedArea("$listArrPixel $i : [" & $i & "] ")
			Local $arrPixel = $listArrPixel[$i]
			debugRedArea("$arrPixel $UBound($arrPixel) : [" & UBound($arrPixel) & "] ")
			If UBound($arrPixel) > 0 Then
				Local $pixel = $arrPixel[0]
				If $i = int(UBound($arrPixel)/2) And $isHeroesDropped = False Then
					$DeployHeroesPosition[0] = $pixel[0]
					$DeployHeroesPosition[1] = $pixel[1]
					debugRedArea("Heroes : $slotsPerEdge = 1 ")
				EndIf
				If $i = int(UBound($arrPixel)/2) And $isCCDropped = False Then
					$DeployCCPosition[0] = $pixel[0]
					$DeployCCPosition[1] = $pixel[1]
					debugRedArea("CC : $slotsPerEdge = 1 ")
				EndIf
				AttackClick($pixel[0], $pixel[1], $number, $iDelayDropOnPixel2, $iDelayDropOnPixel1, "#0096")
			EndIf
		Next
	ElseIf $slotsPerEdge = 2 Then ; Drop on 2 points per edge
		For $i = 0 To UBound($listArrPixel) - 1
			Local $arrPixel = $listArrPixel[$i]
			If UBound($arrPixel) > 0 Then
				Local $pixel = $arrPixel[0]
				If $i = int(UBound($arrPixel)/2) And $isHeroesDropped = False Then
					$DeployHeroesPosition[0] = $pixel[0]
					$DeployHeroesPosition[1] = $pixel[1]
					debugRedArea("Heroes : $slotsPerEdge = 2 ")
				EndIf
				If $i = int(UBound($arrPixel)/2) And $isCCDropped = False Then
					$DeployCCPosition[0] = $pixel[0]
					$DeployCCPosition[1] = $pixel[1]
					debugRedArea("CC : $slotsPerEdge = 2 ")
				EndIf
				AttackClick($pixel[0], $pixel[1], $number, SetSleep(0), SetSleep(1), "#0097")
			EndIf
		Next
	Else
		For $i = 0 To UBound($listArrPixel) - 1
			debugRedArea("$listArrPixel $i : [" & $i & "] ")
			Local $nbTroopsLeft = $number
			Local $offset = 1
			Local $nbTroopByPixel = 1
			Local $arrPixel = $listArrPixel[$i]
			debugRedArea("UBound($arrPixel) " & UBound($arrPixel) & "$number :"& $number)
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
					If $j >= Round(UBound($arrPixel)/2) and $j <= Round((UBound($arrPixel)/2) + $offset) And $isHeroesDropped = False Then
						$DeployHeroesPosition[0] = $currentPixel[0]
						$DeployHeroesPosition[1] = $currentPixel[1]
						debugRedArea("Heroes : $slotsPerEdge = else ")
						debugRedArea("$offset: " & $offset )
					EndIf
					If $j >= Round(UBound($arrPixel)/2) and $j <= Round((UBound($arrPixel)/2) + $offset)  And $isCCDropped = False Then
						$DeployCCPosition[0] = $currentPixel[0]
						$DeployCCPosition[1] = $currentPixel[1]
						debugRedArea("CC : $slotsPerEdge = else ")
						debugRedArea("$offset: " & $offset )
					EndIf
					AttackClick($currentPixel[0], $currentPixel[1], $nbTroopByPixel, SetSleep(0), 0, "#0098")
					$nbTroopsLeft -= $nbTroopByPixel
				Next
			WEnd
		Next
	EndIf
    ReleaseClicks()
	debugRedArea($nameFunc & " OUT ")
EndFunc   ;==>DropOnPixel

