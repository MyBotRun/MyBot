; #FUNCTION# ====================================================================================================================
; Name ..........: isInsideDiamondRedArea
; Description ...:
; Syntax ........: isInsideDiamondRedArea($aCoords)
; Parameters ....: $aCoords             - an array
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func isInsideDiamondRedArea($aCoords)
	Local $Left = $InternalArea[0][0] - 30, $Right = $InternalArea[1][0] + 30, $Top = $InternalArea[2][1] - 25, $Bottom = $InternalArea[3][1] + 20 ; set the diamond shape 860x780
	Local $aDiamond[2][2] = [[$Left, $Top], [$Right, $Bottom]]
	Local $aMiddle = [($aDiamond[0][0] + $aDiamond[1][0]) / 2, ($aDiamond[0][1] + $aDiamond[1][1]) / 2]
	Local $aSize = [$aMiddle[0] - $aDiamond[0][0], $aMiddle[1] - $aDiamond[0][1]]

	Local $DX = Abs($aCoords[0] - $aMiddle[0])
	Local $DY = Abs($aCoords[1] - $aMiddle[1])

	If ($DX / $aSize[0] + $DY / $aSize[1] <= 1) Then
		Return True ; Inside Village
	Else
		Return False ; Outside Village
	EndIf
EndFunc   ;==>isInsideDiamondRedArea
