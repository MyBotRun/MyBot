; #FUNCTION# ====================================================================================================================
; Name ..........: LocatePetHouse
; Description ...:
; Syntax ........: LocatePetHouse()
; Parameters ....:
; Return values .: None
; Author ........: KnowJack (June 2015)
; Modified ......: Sardo 2015-08 GrumpyHog 2021-04
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocatePetHouse($bCollect = True)
	; reset position
	$g_aiPetHousePos[0] = -1
	$g_aiPetHousePos[1] = -1

	If $g_iTownHallLevel < 14 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Pet House, so skip locating.", $COLOR_DEBUG)
		Return
	EndIf

	; auto locate
	ImgLocatePetHouse()

	SetLog("PetHouse: (" & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1] & ")", $COLOR_DEBUG)

	If $g_aiPetHousePos[1] = "" Or $g_aiPetHousePos[1] = -1 Then _LocatePetHouse($bCollect) ; manual locate
EndFunc   ;==>LocatePetHouse

Func _LocatePetHouse($bCollect = True)
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	SetLog("Locating Pet House", $COLOR_INFO)

	WinGetAndroidHandle()
	checkMainScreen()
	If $bCollect Then Collect(False)

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_PetHouse_01", "Click OK then click on your Pet House") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_PetHouse_02", "Locate PetHouse"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClickAway()
			Local $aPos = FindPos()
			$g_aiPetHousePos[0] = Int($aPos[0])
			$g_aiPetHousePos[1] = Int($aPos[1])
			If isInsideDiamond($g_aiPetHousePos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Pet House Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_ERROR)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Pet House Location.", $COLOR_ERROR)
						ClickAway()
						Return False
				EndSelect
			EndIf
		Else
			SetLog("Locate Pet House Cancelled", $COLOR_INFO)
			ClickAway()
			Return
		EndIf
		Local $sPetHouseInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; 860x780
		If $sPetHouseInfo[0] > 1 Or $sPetHouseInfo[0] = "" Then
			If StringInStr($sPetHouseInfo[1], "House") = 0 Then
				Local $sLocMsg = ($sPetHouseInfo[0] = "" ? "Nothing" : $sPetHouseInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Pet House?, It was a " & $sLocMsg & @CRLF
						ContinueLoop
					Case $iSilly = 2
						$sErrorText = "Quit joking, That was " & $sLocMsg & @CRLF
						ContinueLoop
					Case $iSilly = 3
						$sErrorText = "This is not funny, why did you click " & $sLocMsg & "? Please stop!" & @CRLF
						ContinueLoop
					Case $iSilly = 4
						$sErrorText = $sLocMsg & " ?!?!?!" & @CRLF & @CRLF & "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iSilly > 4
						SetLog("Ok, you really think that's a Pet House?" & @CRLF & "I don't care anymore, go ahead with it!", $COLOR_ERROR)
						ClickAway()
						ExitLoop
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad Pet House Location: " & "(" & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1] & ")", $COLOR_ERROR)
			$g_aiPetHousePos[0] = -1
			$g_aiPetHousePos[1] = -1
			ClickAway()
			Return False
		EndIf
		SetLog("Locate Pet House Success: " & "(" & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1] & ")", $COLOR_SUCCESS)
		ExitLoop
	WEnd
	ClickAway()

EndFunc   ;==>_LocatePetHouse

; Image Search for Pet House
Func ImgLocatePetHouse()
	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\PetHouse\"

	Local $sSearchArea = "FV"
	Local $avPetHouse = findMultiple($sImgDir, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", True)

	If Not IsArray($avPetHouse) Or UBound($avPetHouse, $UBOUND_ROWS) <= 0 Then
		SetLog("Couldn't find Pet House on main village", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("PetHouse", False)
		Return False
	EndIf

	Local $avPetHouseRes, $aiPetHouseCoords

	; active/inactive Pet House have different images
	; loop thro the detected images
	For $i = 0 To UBound($avPetHouse, $UBOUND_ROWS) - 1
		$avPetHouseRes = $avPetHouse[$i]
		SetLog("PetHouse Search find : " & $avPetHouseRes[0])
		$aiPetHouseCoords = decodeSingleCoord($avPetHouseRes[1])
	Next

	If IsArray($aiPetHouseCoords) And UBound($aiPetHouseCoords, $UBOUND_ROWS) > 1 Then
		$g_aiPetHousePos[0] = $aiPetHouseCoords[0]
		$g_aiPetHousePos[1] = $aiPetHouseCoords[1]
		Return True
	EndIf

	Return False
EndFunc   ;==>ImgLocatePetHouse
