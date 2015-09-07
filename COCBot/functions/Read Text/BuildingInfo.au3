Func BuildingInfo($iXstart, $iYstart)

	Local $sBldgText, $sBldgLevel, $aString
	Local $aResult[3] = ["", "", ""]

	$sBldgText = getNameBuilding($iXstart, $iYstart) ; Get Unit name and level with OCR
	If $sBldgText = "" Then ; try a 2nd time after a short delay if slow PC
		If _Sleep($iDelayBuildingInfo1) Then Return
		$sBldgText = getNameBuilding($iXstart, $iYstart) ; Get Unit name and level with OCR
	EndIf
	If $debugSetlog = 1 Then Setlog("Read building Name String = " & $sBldgText, $COLOR_PURPLE) ;debug
	If StringInStr($sBldgText, "Tree") Then $sBldgText &= " (FakeLevel 99)"
	If StringInStr($sBldgText, "Mush") Then $sBldgText &= " (FakeLevel 98)"
	If StringInStr($sBldgText, "Trunk") Then $sBldgText &= " (FakeLevel 97)"
	If StringInStr($sBldgText, "Bush") Then $sBldgText &= " (FakeLevel 96)"
	If StringInStr($sBldgText, "Bark") Then $sBldgText &= " (FakeLevel 95)"
	If StringInStr($sBldgText, "Gem") Then $sBldgText &= " (FakeLevel 94)"
	$aString = StringSplit($sBldgText, "(") ; Spilt the name and building level
	If $aString[0] = 2 Then ; If we have name and level then use it
		If $debugSetlog = 1 Then Setlog("1st $aString = " & $aString[0] & ", " & $aString[1] & ", " & $aString[2], $COLOR_PURPLE) ;debug
		If $aString[1] <> "" Then $aResult[1] = $aString[1] ; check for bad read and store name in result[]
		If $aString[2] <> "" Then ; check for bad read of level
			$sBldgLevel = $aString[2] ; store level text
			$aString = StringSplit($sBldgLevel, ")") ;split off the closing parenthesis
			If $aString[0] = 2 Then ; Check If we have "level XX" cleaned up
				If $debugSetlog = 1 Then Setlog("2nd $aString = " & $aString[0] & ", " & $aString[1] & ", " & $aString[2], $COLOR_PURPLE) ;debug
				If $aString[1] <> "" Then $sBldgLevel = $aString[1] ; store "level XX"
			EndIf
			$aString = StringSplit($sBldgLevel, " ") ;split off the level number
			If $aString[0] = 2 Then ; If we have level number then use it
				If $debugSetlog = 1 Then Setlog("3rd $aString = " & $aString[0] & ", " & $aString[1] & ", " & $aString[2], $COLOR_PURPLE) ;debug
				If $aString[2] <> "" Then $aResult[2] = Number($aString[2]) ; store bldg level
			EndIf
		EndIf
	EndIf
	If $aResult[1] <> "" Then $aResult[0] = 1
	If $aResult[2] <> "" Then $aResult[0] += 1
	If $aResult[2] > 90 Then $aResult[2] = ""

	Return $aResult

EndFunc