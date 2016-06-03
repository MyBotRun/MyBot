; #FUNCTION# ====================================================================================================================
; Name ..........: MakeDropPoints
; Description ...:
; Syntax ........: MakeDropPoints($side, $pointsQty, $addtiles, $versus[, $randomx = 2[, $randomy = 2]])
; Parameters ....: $side                -
;                  $pointsQty           -
;                  $addtiles            -
;                  $versus              -
;                  $randomx             - [optional] an unknown value. Default is 2.
;                  $randomy             - [optional] an unknown value. Default is 2.
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func MakeDropPoints($side, $pointsQty, $addtiles, $versus, $randomx = 2, $randomy = 2)
	debugAttackCSV("make for side " & $side)
	Local $Vector, $Output = ""
	Local $rndx = Random(0, Abs(Int($randomx)), 1)
	Local $rndy = Random(0, Abs(Int($randomy)), 1)
	If $side = "RANDOM" Then
	EndIf
	Switch $side
		Case "TOP-LEFT-DOWN"
			Local $Vector = $PixelTopLeftDOWNDropLine
		Case "TOP-LEFT-UP"
			Local $Vector = $PixelTopLeftUPDropLine
		Case "TOP-RIGHT-DOWN"
			Local $Vector = $PixelTopRightDOWNDropLine
		Case "TOP-RIGHT-UP"
			Local $Vector = $PixelTopRightUPDropLine
		Case "BOTTOM-LEFT-UP"
			Local $Vector = $PixelBottomLeftUPDropLine
		Case "BOTTOM-LEFT-DOWN"
			Local $Vector = $PixelBottomLeftDOWNDropLine
		Case "BOTTOM-RIGHT-UP"
			Local $Vector = $PixelBottomRightUPDropLine
		Case "BOTTOM-RIGHT-DOWN"
			Local $Vector = $PixelBottomRightDOWNDropLine
		Case Else
	EndSwitch
	If Int($pointsQty) > 0 Then
		Local $pointsQtyCleaned = Abs(Int($pointsQty))
	Else
		Local $pointsQtyCleaned = 1
	EndIf
	Local $p = Int(UBound($Vector) / $pointsQtyCleaned)
	If $p = 0 Then $p = 1
	Local $x = 0
	Local $y = 0

	Local $str = ""
	For $i = 0 To UBound($Vector) - 1
		$pixel = $Vector[$i]
		$str &= $pixel[0] & "-" & $pixel[1] & "|"
	Next

	Switch $side & "|" & $versus
		Case "TOP-LEFT-DOWN|INT-EXT", "TOP-LEFT-UP|EXT-INT", "TOP-RIGHT-DOWN|EXT-INT", "TOP-RIGHT-UP|INT-EXT", "BOTTOM-LEFT-DOWN|EXT-INT", "BOTTOM-LEFT-UP|INT-EXT", "BOTTOM-RIGHT-DOWN|INT-EXT", "BOTTOM-RIGHT-UP|EXT-INT"
			;verso da  destra  verso sinistra
			For $i = UBound($Vector) To 1 Step -1
				$pixel = $Vector[$i - 1]
				$x += $pixel[0]
				$y += $pixel[1]
				If Mod(UBound($Vector) - $i + 1, $p) = 0 Then
					For $u = 8 * Abs(Int($addtiles)) To 0 Step -1
						If Int($addtiles) > 0 Then
							Local $l = $u
						Else
							Local $l = -$u
						EndIf
						Switch $side
							Case "TOP-LEFT-UP", "TOP-LEFT-DOWN"
								Local $x1 = Round($x / $p) - $l
								Local $y1 = Round($y / $p) - $l
								Local $x2 = Round($x / $p) - $l - $rndx
								Local $y2 = Round($y / $p) - $l - $rndy
							Case "TOP-RIGHT-UP", "TOP-RIGHT-DOWN"
								Local $x1 = Round($x / $p) + $l
								Local $y1 = Round($y / $p) - $l
								Local $x2 = Round($x / $p) + $l + $rndx
								Local $y2 = Round($y / $p) - $l - $rndy
							Case "BOTTOM-LEFT-UP", "BOTTOM-LEFT-DOWN"
								Local $x1 = Round($x / $p) - $l
								Local $y1 = Round($y / $p) + $l
								Local $x2 = Round($x / $p) - $l - $rndx
								Local $y2 = Round($y / $p) + $l + $rndy
							Case "BOTTOM-RIGHT-UP", "BOTTOM-RIGHT-DOWN"
								Local $x1 = Round($x / $p) + $l
								Local $y1 = Round($y / $p) + $l
								Local $x2 = Round($x / $p) + $l + $rndx
								Local $y2 = Round($y / $p) + $l + $rndy
							Case Else
						EndSwitch
						$pixel = StringSplit($x2 & "-" & $y2, "-", 2)
						If isInsideDiamondRedArea($pixel) Then ExitLoop
					Next
					$pixel = StringSplit($x2 & "-" & $y2, "-", 2)
					$Output &= $pixel[0] & "-" & $pixel[1] & "|"
					$x = 0
					$y = 0
				EndIf
			Next
		Case "TOP-LEFT-DOWN|EXT-INT", "TOP-LEFT-UP|INT-EXT", "TOP-RIGHT-DOWN|INT-EXT", "TOP-RIGHT-UP|EXT-INT", "BOTTOM-LEFT-DOWN|INT-EXT", "BOTTOM-LEFT-UP|EXT-INT", "BOTTOM-RIGHT-DOWN|EXT-INT", "BOTTOM-RIGHT-UP|INT-EXT"
			;verso da sinistra a destra
			For $i = 1 To UBound($Vector)
				$pixel = $Vector[$i - 1]
				$x += $pixel[0]
				$y += $pixel[1]
				If Mod($i, $p) = 0 Then
					For $u = 8 * Abs(Int($addtiles)) To 0 Step -1
						If Int($addtiles) > 0 Then
							Local $l = $u
						Else
							Local $l = -$u
						EndIf
						Switch $side
							Case "TOP-LEFT-UP", "TOP-LEFT-DOWN"
								Local $x1 = Round($x / $p) - $l
								Local $y1 = Round($y / $p) - $l
								Local $x2 = Round($x / $p) - $l - $rndx
								Local $y2 = Round($y / $p) - $l - $rndy
							Case "TOP-RIGHT-UP", "TOP-RIGHT-DOWN"
								Local $x1 = Round($x / $p) + $l
								Local $y1 = Round($y / $p) - $l
								Local $x2 = Round($x / $p) + $l + $rndx
								Local $y2 = Round($y / $p) - $l - $rndy
							Case "BOTTOM-LEFT-UP", "BOTTOM-LEFT-DOWN"
								Local $x1 = Round($x / $p) - $l
								Local $y1 = Round($y / $p) + $l
								Local $x2 = Round($x / $p) - $l - $rndx
								Local $y2 = Round($y / $p) + $l + $rndy
							Case "BOTTOM-RIGHT-UP", "BOTTOM-RIGHT-DOWN"
								Local $x1 = Round($x / $p) + $l
								Local $y1 = Round($y / $p) + $l
								Local $x2 = Round($x / $p) + $l + $rndx
								Local $y2 = Round($y / $p) + $l + $rndy
							Case Else
						EndSwitch
						$pixel = StringSplit($x2 & "-" & $y2, "-", 2)
						If isInsideDiamondRedArea($pixel) Then ExitLoop
					Next
					$pixel = StringSplit($x2 & "-" & $y2, "-", 2)
					$Output &= $pixel[0] & "-" & $pixel[1] & "|"
					$x = 0
					$y = 0
				EndIf
			Next

		Case Else
	EndSwitch

	If StringLen($Output) > 0 Then $Output = StringLeft($Output, StringLen($Output) - 1)
	Return GetListPixel($Output)
EndFunc   ;==>MakeDropPoints
