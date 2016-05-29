; #FUNCTION# ====================================================================================================================
; Name ..........: CheckWall()
; Description ...: This file Includes the detection of Walls for Upgrade
; Syntax ........:
; Parameters ....: None
; Return values .:
; Author ........: Didipe
; Modified ......: ProMac (oct 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func CheckWall()
	;$icmbWalls = _GUICtrlComboBox_GetCurSel($cmbWalls)

	If _Sleep(500) Then Return
	Local $listLvlMask[5] = [2.3, 2.95, 5, 8, -1] ; Mask levels, added value from center of base, largest mask (3) is tested first, -1 is entire village.
	Local $NameLvlMask[5] = ["Core of Base", "Center of Base", "Middle of Base", "Most of Base", "All of Base"] ; Mask Names for easier understanding
	Local $levelWall = $icmbWalls + 4
	Local $listPixel[0]
	;$Walltolerance = Number(GUICtrlRead($sldToleranceWall)) * 5


	For $i = 0 To UBound($listLvlMask) - 1
		_CaptureRegion2()
		SetLog("Searching for Wall(s) level: " & $levelWall & ". Using Mask: " & $NameLvlMask[$i], $COLOR_GREEN)
		Local $result = DllCall($hFuncLib, "str", "findWall", "ptr", $hHBitmap2, "double", $listLvlMask[$i], "int", $levelWall, "double", $Walltolerance[$icmbWalls], "int", $iMaxNbWall, "int", $debugWalls)
		ClickP($aAway, 1, 0, "#0505") ; to prevent bot 'Anyone there ?'
		If Not $result[0] = "" And UBound($result) > 0 Then
			Local $listPixelTemp = GetListPixel($result[0])
			_ArrayAdd($listPixel, $listPixelTemp)
			If (UBound($listPixel) >= $iMaxNbWall) Then
				ExitLoop
			EndIf
		Else
			ContinueLoop
		EndIf
	Next

	If (UBound($listPixel) = 0) Then
		SetLog("No wall(s) level: " & $levelWall & " found.", $COLOR_RED)
	Else
		SetLog("Found: " & UBound($listPixel) & " possible Wall position(s).", $COLOR_GREEN)
		SetLog("Checking if found positions are a Wall and of desired level.", $COLOR_GREEN)
		For $i = 0 To UBound($listPixel) - 1
			;try click
			Local $pixel = $listPixel[$i]
			Local $xCompensation = 6
			Local $yCompensation = 4
			For $j = 0 To 1 ; try compensation
				GemClick($pixel[0] + $xCompensation, $pixel[1] + $yCompensation)
				If _Sleep(500) Then Return
				$aResult = BuildingInfo(245, 520 + $bottomOffsetY) ; Get Unit name and level with OCR 860x780
				If $aResult[0] = 2 Then ; We found a valid building name
					If StringInStr($aResult[1], "wall") = True And Number($aResult[2]) = ($icmbWalls + 4) Then ; we found a wall
						Setlog("Position No: " & $i + 1 & " is a Wall Level: " & $icmbWalls + 4 & ".")
						Return True
					Else
						If $debugSetlog Then
							ClickP($aAway, 1, 0, "#0931") ;Click Away
							Setlog("Position No: " & $i + 1 & " is not a Wall Level: " & $icmbWalls + 4 & ". It was: " & $aResult[1] & ", " & $aResult[2] & " at: (" & $pixel[0] + $xCompensation & "," & $pixel[1] + $yCompensation & ").", $COLOR_PURPLE) ;debug
						Else
							ClickP($aAway, 1, 0, "#0932") ;Click Away
							Setlog("Position No: " & $i + 1 & " is not a Wall Level: " & $icmbWalls + 4 & ".", $COLOR_RED)
						EndIf
					EndIf
				Else
					ClickP($aAway, 1, 0, "#0933") ;Click Away
					$xCompensation = 4
					$yCompensation = 7
				EndIf
			Next
		Next
	EndIf
	Return False

EndFunc   ;==>CheckWall


