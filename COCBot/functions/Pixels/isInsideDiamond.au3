; #FUNCTION# ====================================================================================================================
; Name ..........: isInsideDiamondXY, isInsideDiamond
; Description ...: This function can test if a given coordinate is inside (True) or outside (False) the village grass borders (a diamond shape).
;                  It will also exclude some special area's like the CHAT tab, BUILDER button and GEM shop button.
; Syntax ........: isInsideDiamondXY($Coordx, $Coordy), isInsideDiamond($aCoords)
; Parameters ....: ($Coordx, $CoordY) as coordinates or ($aCoords), an array of (x,y) to test
; Return values .: True or False
; Author ........: Hervidero (2015-may-21)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func isInsideDiamondXY($Coordx, $Coordy)

	Local $aCoords = [$Coordx, $Coordy]
	Return isInsideDiamond($aCoords)

EndFunc   ;==>isInsideDiamondXY

Func isInsideDiamond($aCoords)
	Local $Left = 15, $Right = 835, $Top = 30, $Bottom = 645 ; set the diamond shape 860x780
	Local $aDiamond[2][2] = [[$Left, $Top], [$Right, $Bottom]]
	Local $aMiddle = [($aDiamond[0][0] + $aDiamond[1][0]) / 2, ($aDiamond[0][1] + $aDiamond[1][1]) / 2]
	Local $aSize = [$aMiddle[0] - $aDiamond[0][0], $aMiddle[1] - $aDiamond[0][1]]

	Local $DX = Abs($aCoords[0] - $aMiddle[0])
	Local $DY = Abs($aCoords[1] - $aMiddle[1])

	If ($DX / $aSize[0] + $DY / $aSize[1] <= 1) Then
		If $aCoords[0] < 68 Then ; coordinates where the game will click on the CHAT tab (safe margin)
			;If $debugSetlog = 1 Then SetDebuglog("Coordinate Inside Village, but Exclude CHAT", $COLOR_PURPLE)
			Return False
		ElseIf $aCoords[0] < 412 And $aCoords[1] < 59 Then ; coordinates where the game will click on the BUILDER button (safe margin)
			;If $debugSetlog = 1 Then SetDebuglog("Coordinate Inside Village, but Exclude BUILDER", $COLOR_PURPLE)
			Return False
		ElseIf $aCoords[0] > 692 And $aCoords[1] < 210 Then ; coordinates where the game will click on the GEMS button (safe margin)
			;If $debugSetlog = 1 Then SetDebuglog("Coordinate Inside Village, but Exclude GEMS", $COLOR_PURPLE)
			Return False
		EndIf
		;If $debugSetlog = 1 Then SetDebuglog("Coordinate Inside Village", $COLOR_PURPLE)
		Return True ; Inside Village
	Else
		If $debugSetlog = 1 Then SetDebuglog("Coordinate Outside Village", $COLOR_PURPLE)
		Return False ; Outside Village
	EndIf

EndFunc   ;==>isInsideDiamond
