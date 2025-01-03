; #FUNCTION# ====================================================================================================================
; Name ..........: LocateHeroHall
; Description ...:
; Syntax ........: LocateHeroHall
; Parameters ....:
; Return values .: None
; Author ........: ProMac(07/2015)
; Modified ......: Moebius14(11/2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateHeroHall($bCollect = True)
	; reset position
	$g_aiHeroHallPos[0] = -1
	$g_aiHeroHallPos[1] = -1
	$g_aiHeroHallPos[2] = -2

	If $g_iTownHallLevel < 7 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Hero Hall, so skip locating.", $COLOR_DEBUG)
		Return
	EndIf

	; auto locate
	ImgLocateHeroHall()

	SetLog("Hero Hall: (" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & "), Level : " & $g_aiHeroHallPos[2], $COLOR_DEBUG)

	If $g_aiHeroHallPos[1] = "" Or $g_aiHeroHallPos[1] = -1 Then _LocateHeroHall($bCollect) ; manual locate
EndFunc   ;==>LocateHeroHall

Func _LocateHeroHall($bCollect = True)
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	SetLog("Locating Hero Hall", $COLOR_INFO)

	WinGetAndroidHandle()
	checkMainScreen()
	If $bCollect Then Collect(False)

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_HeroHall_01", "Click OK then click on your Hero Hall") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_HeroHall_02", "Locate Hero Hall"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClearScreen()
			Local $aPos = FindPos()
			$g_aiHeroHallPos[0] = Int($aPos[0])
			$g_aiHeroHallPos[1] = Int($aPos[1])
			If isInsideDiamond($g_aiHeroHallPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Hero Hall Location Not Valid!" & @CRLF
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
						SetLog(" Operator Error - Bad Hero Hall Location.", $COLOR_ERROR)
						ClearScreen()
						Return False
				EndSelect
			EndIf
		Else
			SetLog("Locate Hero Hall Cancelled", $COLOR_INFO)
			ClearScreen()
			Return
		EndIf
		Local $sHeroHallInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If $sHeroHallInfo[0] > 1 Or $sHeroHallInfo[0] = "" Then
			If StringInStr($sHeroHallInfo[1], "Hero") = 0 Then
				Local $sLocMsg = ($sHeroHallInfo[0] = "" ? "Nothing" : $sHeroHallInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Hero Hall?, It was a " & $sLocMsg & @CRLF
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
						SetLog("Ok, you really think that's a Hero Hall?" & @CRLF & "I don't care anymore, go ahead with it!", $COLOR_ERROR)
						ClearScreen()
						ExitLoop
				EndSelect
			Else
				$g_aiHeroHallPos[2] = $sHeroHallInfo[2]
			EndIf
		Else
			SetLog(" Operator Error - Bad Hero Hall Location: " & "(" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & ")", $COLOR_ERROR)
			$g_aiHeroHallPos[0] = -1
			$g_aiHeroHallPos[1] = -1
			$g_aiHeroHallPos[2] = -1
			ClearScreen()
			Return False
		EndIf
		SetLog("Locate Hero Hall Success: " & "(" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & "), Level : " & $g_aiHeroHallPos[2], $COLOR_SUCCESS)
		ExitLoop
	WEnd
	ClearScreen()

EndFunc   ;==>_LocateHeroHall

; Image Search for Hero Hall
Func ImgLocateHeroHall()
	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\HeroHall\"

	Local $sSearchArea = "FV"
	Local $avHeroHall = findMultiple($sImgDir, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", True)

	If Not IsArray($avHeroHall) Or UBound($avHeroHall, $UBOUND_ROWS) <= 0 Then
		SetLog("Couldn't find Hero Hall on main village", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("HeroHall", False)
		Return False
	EndIf

	Local $avHeroHallRes, $aiHeroHallCoords

	; active/inactive Hero Hall have different images
	; loop thro the detected images
	For $i = 0 To UBound($avHeroHall, $UBOUND_ROWS) - 1
		$avHeroHallRes = $avHeroHall[$i]
		SetLog("Hero Hall Search find : " & $avHeroHallRes[0])
		$aiHeroHallCoords = decodeSingleCoord($avHeroHallRes[1])
	Next

	If IsArray($aiHeroHallCoords) And UBound($aiHeroHallCoords, $UBOUND_ROWS) > 1 Then
		$g_aiHeroHallPos[0] = $aiHeroHallCoords[0] + 6
		$g_aiHeroHallPos[1] = $aiHeroHallCoords[1] + 12

		BuildingClick($g_aiHeroHallPos[0], $g_aiHeroHallPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		Local $sHeroHallInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If StringInStr($sHeroHallInfo[1], "Hero") Then
			$g_aiHeroHallPos[2] = $sHeroHallInfo[2]
		EndIf
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		ClearScreen()
		Return True
	EndIf

	Return False
EndFunc   ;==>ImgLocateHeroHall
