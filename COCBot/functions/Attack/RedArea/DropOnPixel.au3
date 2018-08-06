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
; Modified ......: ProMac (07-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
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

	Local $nameFunc = "[DropOnPixel]"
	debugRedArea($nameFunc & " IN ")
	debugRedArea("troop : [" & $troop & "] / size arrPixel [" & UBound($listArrPixel) & "] / number [" & $number & "]/ $slotsPerEdge [" & $slotsPerEdge & "] ")
	If ($number = 0 Or UBound($listArrPixel) = 0) Then Return
	KeepClicks()

	For $i = 0 To UBound($listArrPixel) - 1
		debugRedArea("$listArrPixel $i : [" & $i & "] ")
		Local $nbTroopsLeft = $number
		Local $offset = 1
		Local $nbTroopByPixel = 1
		Local $arrPixel = $listArrPixel[$i]
		debugRedArea("UBound($arrPixel) " & UBound($arrPixel) & "$number :" & $number)
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
				If $j >= Round(UBound($arrPixel) / 2) And $j <= Round((UBound($arrPixel) / 2) + $offset) And $g_bIsHeroesDropped = False Then
					$g_aiDeployHeroesPosition[0] = $currentPixel[0]
					$g_aiDeployHeroesPosition[1] = $currentPixel[1]
					debugRedArea("Heroes : $slotsPerEdge = else ")
					debugRedArea("$offset: " & $offset)
				EndIf
				If $j >= Round(UBound($arrPixel) / 2) And $j <= Round((UBound($arrPixel) / 2) + $offset) And $g_bIsCCDropped = False Then
					$g_aiDeployCCPosition[0] = $currentPixel[0]
					$g_aiDeployCCPosition[1] = $currentPixel[1]
					debugRedArea("CC : $slotsPerEdge = else ")
					debugRedArea("$offset: " & $offset)
				EndIf
				If Number($currentPixel[1]) > 555 + $g_iBottomOffsetY Then $currentPixel[1] = 555 + $g_iBottomOffsetY
				AttackClick($currentPixel[0], $currentPixel[1], $nbTroopByPixel, SetSleep(0), 0, "#0098")
				$nbTroopsLeft -= $nbTroopByPixel
			Next
		WEnd
	Next

	ReleaseClicks()
	debugRedArea($nameFunc & " OUT ")
EndFunc   ;==>DropOnPixel

