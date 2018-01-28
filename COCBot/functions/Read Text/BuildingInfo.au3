; #FUNCTION# ====================================================================================================================
; Name ..........: BuildingInfo
; Description ...:
; Syntax ........: BuildingInfo($iXstart, $iYstart)
; Parameters ....: $iXstart             - an integer value.
;                  $iYstart             - an integer value.
; Return values .: None
; Author ........: KnowJack
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func BuildingInfo($iXstart, $iYstart)

	Local $sBldgText, $sBldgLevel, $aString
	Local $aResult[3] = ["", "", ""]

	$sBldgText = getNameBuilding($iXstart, $iYstart) ; Get Unit name and level with OCR
	If $sBldgText = "" Then ; try a 2nd time after a short delay if slow PC
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		$sBldgText = getNameBuilding($iXstart, $iYstart) ; Get Unit name and level with OCR
	EndIf
	If $g_bDebugSetlog Then SetDebugLog("Read building Name String = " & $sBldgText, $COLOR_DEBUG) ;debug
	If StringInStr($sBldgText, "Cart") Then $sBldgText &= " (FakeLevel 100)"
	If StringInStr($sBldgText, "Tree") Then $sBldgText &= " (FakeLevel 99)"
	If StringInStr($sBldgText, "Mush") Then $sBldgText &= " (FakeLevel 98)"
	If StringInStr($sBldgText, "Trunk") Then $sBldgText &= " (FakeLevel 97)"
	If StringInStr($sBldgText, "Bush") Then $sBldgText &= " (FakeLevel 96)"
	If StringInStr($sBldgText, "Bark") Then $sBldgText &= " (FakeLevel 95)"
	If StringInStr($sBldgText, "Gem") Then $sBldgText &= " (FakeLevel 94)"
	$aString = StringSplit($sBldgText, "(") ; Spilt the name and building level
	If $aString[0] = 2 Then ; If we have name and level then use it
		If $g_bDebugSetlog Then SetDebugLog("1st $aString = " & $aString[0] & ", " & $aString[1] & ", " & $aString[2], $COLOR_DEBUG) ;debug
		If $aString[1] <> "" Then $aResult[1] = StringStripWS($aString[1], 7) ; check for bad read and store name in result[]
		If $aString[2] <> "" Then ; check for bad read of level
			$sBldgLevel = $aString[2] ; store level text
			$aString = StringSplit($sBldgLevel, ")") ;split off the closing parenthesis
			If $aString[0] = 2 Then ; Check If we have "level XX" cleaned up
				If StringInStr($aString[1], "Broken") Then $aString[1] &= " 200" ; Broken Clan Castle (not rebuild yet): add fake level
				If $g_bDebugSetlog Then SetDebugLog("2nd $aString = " & $aString[0] & ", " & $aString[1] & ", " & $aString[2], $COLOR_DEBUG) ;debug
				If $aString[1] <> "" Then $sBldgLevel = $aString[1] ; store "level XX"
			EndIf
			$aString = StringSplit($sBldgLevel, " ") ;split off the level number
			If $aString[0] = 2 Then ; If we have level number then use it
				If $g_bDebugSetlog Then SetDebugLog("3rd $aString = " & $aString[0] & ", " & $aString[1] & ", " & $aString[2], $COLOR_DEBUG) ;debug
				If $aString[2] <> "" Then $aResult[2] = Number($aString[2]) ; store bldg level
			EndIf
		EndIf
	EndIf
	If $aResult[1] <> "" Then $aResult[0] = 1
	If $aResult[2] <> "" Then $aResult[0] += 1
	If $aResult[2] > 90 Then
		If $aResult[2] = 200 Then
			$aResult[2] = "Broken" ; Broken Clan Castle (not rebuild yet): report 'Broken' as Level
		Else
			$aResult[2] = ""
		EndIf
	EndIf

	Return $aResult

EndFunc   ;==>BuildingInfo
