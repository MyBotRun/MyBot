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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
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
			Local $Vector = $g_aiPixelTopLeftDOWNDropLine
		Case "TOP-LEFT-UP"
			Local $Vector = $g_aiPixelTopLeftUPDropLine
		Case "TOP-RIGHT-DOWN"
			Local $Vector = $g_aiPixelTopRightDOWNDropLine
		Case "TOP-RIGHT-UP"
			Local $Vector = $g_aiPixelTopRightUPDropLine
		Case "BOTTOM-LEFT-UP"
			Local $Vector = $g_aiPixelBottomLeftUPDropLine
		Case "BOTTOM-LEFT-DOWN"
			Local $Vector = $g_aiPixelBottomLeftDOWNDropLine
		Case "BOTTOM-RIGHT-UP"
			Local $Vector = $g_aiPixelBottomRightUPDropLine
		Case "BOTTOM-RIGHT-DOWN"
			Local $Vector = $g_aiPixelBottomRightDOWNDropLine
		Case Else
	EndSwitch
	If $versus = "IGNORE" Then $versus = "EXT-INT" ; error proof use input if misuse targeted MAKE command
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
		Local $pixel = $Vector[$i]
		$str &= $pixel[0] & "-" & $pixel[1] & "|"
	Next

	Switch $side & "|" & $versus
		Case "TOP-LEFT-DOWN|INT-EXT", "TOP-LEFT-UP|EXT-INT", "TOP-RIGHT-DOWN|EXT-INT", "TOP-RIGHT-UP|INT-EXT", "BOTTOM-LEFT-DOWN|EXT-INT", "BOTTOM-LEFT-UP|INT-EXT", "BOTTOM-RIGHT-DOWN|INT-EXT", "BOTTOM-RIGHT-UP|EXT-INT"
			;From right to left
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
			;From left to right
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


; #FUNCTION# ====================================================================================================================
; Name ..........: MakeTargetDropPoints
; Description ...:
; Syntax ........: MakeTargetDropPoints($side, $pointsQty, $addtiles, $building)
; Parameters ....: $side                - a string, target side string ($sidex)
;                  $pointsQty           - a integer Drop point count can be 1 or 5 value only ($value3)
;                  $addtiles            - a integer, Ignore if $pointsqty = 5, only used when dropping in sigle point ($value4)
;                  $building            - a enum value, building target for drop points ($value8)
; Return values .: PointQty =1: single x,y array
;					  : 			 =5: Array with 5 x,y points
; @error values  : 1 = Bad defense name
;					  : 2 = dictionary value for defense missing
;					  : 3 = dictionary value of defense was not array
; 					  : 4 = strange programming error?
; Author ........: MonkeyHunter (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func MakeTargetDropPoints($side, $pointsQty, $addtiles, $building)
	;MakeTargetDropPoints(Eval($sidex), $value3,   $value4,   $value8))

	debugAttackCSV("make for side " & $side & ", target: " & $building)

	Local $Vector, $Output = ""
	Local $x, $y
	Local $sLoc, $aLocation, $pixel[2], $BuildingEnum, $result, $array

	Switch $building ; translate CSV building name into building enum
		Case "TOWNHALL"
			$BuildingEnum = $eBldgTownHall
		Case "EAGLE"
			$BuildingEnum = $eBldgEagle
		Case "INFERNO"
			$BuildingEnum = $eBldgInferno
		Case "XBOW"
			$BuildingEnum = $eBldgXBow
		Case "WIZTOWER"
			$BuildingEnum = $eBldgWizTower
		Case "MORTAR"
			$BuildingEnum = $eBldgMortar
		Case "AIRDEFENSE"
			$BuildingEnum = $eBldgAirDefense
		Case "EX-WALL"
			$BuildingEnum = $eExternalWall
		Case "IN-WALL"
			$BuildingEnum = $eInternalWall
		Case "SCATTER"
			$BuildingEnum = $eBldgScatter
		Case Else
			SetLog("Defense name not understood", $COLOR_ERROR) ; impossible error as value is checked earlier
			SetError(1, 0, "")
			Return
	EndSwitch

	Local $aBuildingLoc = _ObjGetValue($g_oBldgAttackInfo, $BuildingEnum & "_LOCATION")

	If @error Then
		_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$BuildingEnum] & " _LOCATION", @error) ; Log errors
		SetError(2, 0, "")
		Return
	EndIf

	If IsArray($aBuildingLoc) Then
		If UBound($aBuildingLoc, 1) > 1 And IsArray($aBuildingLoc[1]) Then ; cycle thru all building locations
			For $p = 0 To UBound($aBuildingLoc) - 1
				$array = $aBuildingLoc[$p] ; pull sub-array from inside location array
				$result = IsPointOnSide($array, $side) ; Determine if target building on side specified
				If @error Then ; not normal
					Return SetError(4, 0, "")
				EndIf
				If $result = True Then
					$aLocation = $aBuildingLoc[$p] ; 1st building location found is used
					ExitLoop
				EndIf
			Next
			If $aLocation = "" Then
				; error check?
				SetLog("Building location not found on side, random pick", $COLOR_ERROR)
				If IsArray($aBuildingLoc[0]) Then $aLocation = $aBuildingLoc[0]
			EndIf
		Else ; use only building found even if not on user chosen side?
			$aLocation = $aBuildingLoc[0]
		EndIf
	Else
		SetLog($g_sBldgNames[$BuildingEnum] & " _LOCATION not an array", $COLOR_ERROR)
		Return SetError(3, 0, "")
	EndIf

	Switch Int($pointsQty) ; Create vector
		Case 1 ; drop point here is single point on side specified
			$x += $aLocation[0]
			$y += $aLocation[1]
			; use ADDTILES * 8 pixels per tile to add offset to vector location
			For $u = 8 * Abs(Int($addtiles)) To 0 Step -1 ; count down to zero pixels till find valid drop point
				If Int($addtiles) > 0 Then ; adjust for positive or negative ADDTILES value
					Local $l = $u
				Else
					Local $l = -$u
				EndIf
				Switch $side
					Case "TOP-LEFT-UP", "TOP-LEFT-DOWN"
						$pixel[0] = $x - $l
						$pixel[1] = $y - $l
					Case "TOP-RIGHT-UP", "TOP-RIGHT-DOWN"
						$pixel[0] = $x + $l
						$pixel[1] = $y - $l
					Case "BOTTOM-LEFT-UP", "BOTTOM-LEFT-DOWN"
						$pixel[0] = $x - $l
						$pixel[1] = $y + $l
					Case "BOTTOM-RIGHT-UP", "BOTTOM-RIGHT-DOWN"
						$pixel[0] = $x + $l
						$pixel[1] = $y + $l
					Case Else
						SetLog("Silly code monkey 'MAKE' TargetDropPoints mistake", $COLOR_ERROR)
						SetError(5, 0, "")
						Return
				EndSwitch
				If isInsideDiamondRedArea($pixel) Then ExitLoop
			Next
			If Not isInsideDiamondRedArea($pixel) Then SetDebugLog("MakeTargetDropPoints() ADDTILES error!")
			$sLoc = $pixel[0] & "-" & $pixel[1] ; make string for modified building location
			SetLog("Target drop point for " &  $g_sBldgNames[$BuildingEnum] & " (adding " & $addtiles & " tiles): " & $sLoc)
			Return GetListPixel($sLoc, "-", "MakeTargetDropPoints TARGET") ; return ADDTILES modified location array
		Case 5
			$sLoc = $aLocation[0] & "|" & $aLocation[1] ; make string for bldg location
			$Output = GetDeployableNextTo($sLoc, 10, $g_oBldgAttackInfo.item($eBldgRedLine & "_OBJECTPOINTS")) ; Get 5 near points, 10 pixels outisde red line for drop
			Return GetListPixel($Output, ",", "MakeTargetDropPoints NEARPOINTS") ;imgloc DLL calls return comma separated values
		Case Else
			; impossible?
			SetLog("Strange MakeTargetDropPoint Error", $COLOR_ERROR)
			Return SetError(6, 0, "")
	EndSwitch

EndFunc   ;==>MakeTargetDropPoints

