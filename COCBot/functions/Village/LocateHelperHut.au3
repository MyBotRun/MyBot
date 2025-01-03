; #FUNCTION# ====================================================================================================================
; Name ..........: LocateHelperHut
; Description ...:
; Syntax ........: LocateHelperHut()
; Parameters ....:
; Return values .: None
; Author ........: Moebius14 (Nov 2024)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateHelperHut($bCollect = True)
	; reset position
	$g_aiHelperHutPos[0] = -1
	$g_aiHelperHutPos[1] = -1

	If $g_iTownHallLevel < 9 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Helper Hut, so skip locating.", $COLOR_DEBUG)
		Return
	EndIf

	; auto locate
	ImgLocateHelperHut()

	SetLog("Helper Hut: (" & $g_aiHelperHutPos[0] & "," & $g_aiHelperHutPos[1] & ")", $COLOR_DEBUG)

	If $g_aiHelperHutPos[1] = "" Or $g_aiHelperHutPos[1] = -1 Then _LocateHelperHut($bCollect) ; manual locate
EndFunc   ;==>LocateHelperHut

Func _LocateHelperHut($bCollect = True)
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	SetLog("Locating Helper Hut", $COLOR_INFO)

	WinGetAndroidHandle()
	checkMainScreen()
	If $bCollect Then Collect(False)

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_HelperHut_01", "Click OK then click on your Helper Hut") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_HelperHut_02", "Locate Helper Hut"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClearScreen()
			Local $aPos = FindPos()
			$g_aiHelperHutPos[0] = Int($aPos[0])
			$g_aiHelperHutPos[1] = Int($aPos[1])
			If isInsideDiamond($g_aiHelperHutPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Helper Hut Location Not Valid!" & @CRLF
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
						SetLog(" Operator Error - Bad Helper Hut Location.", $COLOR_ERROR)
						ClearScreen()
						Return False
				EndSelect
			EndIf
		Else
			SetLog("Locate Helper Hut Cancelled", $COLOR_INFO)
			ClearScreen()
			Return
		EndIf
		Local $sHelperHutInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If $sHelperHutInfo[0] > 1 Or $sHelperHutInfo[0] = "" Then
			If StringInStr($sHelperHutInfo[1], "Helper") = 0 Then
				Local $sLocMsg = ($sHelperHutInfo[0] = "" ? "Nothing" : $sHelperHutInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Helper Hut?, It was a " & $sLocMsg & @CRLF
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
						SetLog("Ok, you really think that's a Helper Hut?" & @CRLF & "I don't care anymore, go ahead with it!", $COLOR_ERROR)
						ClearScreen()
						ExitLoop
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad Helper Hut Location: " & "(" & $g_aiHelperHutPos[0] & "," & $g_aiHelperHutPos[1] & ")", $COLOR_ERROR)
			$g_aiHelperHutPos[0] = -1
			$g_aiHelperHutPos[1] = -1
			ClearScreen()
			Return False
		EndIf
		SetLog("Locate Helper Hut Success: " & "(" & $g_aiHelperHutPos[0] & "," & $g_aiHelperHutPos[1] & ")", $COLOR_SUCCESS)
		ExitLoop
	WEnd
	ClearScreen()

EndFunc   ;==>_LocateHelperHut

; Image Search for Helper Hut
Func ImgLocateHelperHut()
	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\HelperHut\"

	Local $sSearchArea = "FV"
	Local $avHelperHut = findMultiple($sImgDir, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", True)

	If Not IsArray($avHelperHut) Or UBound($avHelperHut, $UBOUND_ROWS) <= 0 Then
		SetLog("Couldn't find Helper Hut on main village", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("HelperHut", False)
		Return False
	EndIf

	Local $avHelperHutRes, $aiHelperHutCoords

	; active/inactive Helper Hut have different images
	; loop thro the detected images
	For $i = 0 To UBound($avHelperHut, $UBOUND_ROWS) - 1
		$avHelperHutRes = $avHelperHut[$i]
		SetLog("Helper Hut Search find : " & $avHelperHutRes[0])
		$aiHelperHutCoords = decodeSingleCoord($avHelperHutRes[1])
	Next

	If IsArray($aiHelperHutCoords) And UBound($aiHelperHutCoords, $UBOUND_ROWS) > 1 Then
		$g_aiHelperHutPos[0] = $aiHelperHutCoords[0]
		$g_aiHelperHutPos[1] = $aiHelperHutCoords[1] + 12
		Return True
	EndIf

	Return False
EndFunc   ;==>ImgLocateHelperHut
