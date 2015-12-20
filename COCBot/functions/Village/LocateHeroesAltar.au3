
; #FUNCTION# ====================================================================================================================
; Name ..........: LocateQueenAltar & LocateKingAltar
; Description ...:
; Syntax ........: LocateKingAltar() & LocateQueenAltar()
; Parameters ....:
; Return values .: None
; Author ........: ProMac 2015
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================




Func LocateQueenAltar()

	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo

	$RunState = True
	WinActivate($Title)
	checkMainScreen(False)

	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1], True) <> Hex($aTopLeftClient[2], 6) And _GetPixelColor($aTopRightClient[0], $aTopRightClient[1], True) <> Hex($aTopRightClient[2], 6) Then
		Zoomout()
		Collect()
	EndIf

	SetLog("Locating Queen Altar...", $COLOR_BLUE)
	While 1
		ClickP($aTopLeftClient)
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & "Click OK then click on your Queen Altar" & @CRLF & @CRLF & _
				"Do not move mouse after clicking location" & @CRLF & @CRLF & "Make sure the building name is visible for me!" & @CRLF
		$MsgBox = _ExtMsgBox(0, "Ok|Cancel", "Locate Queen Altar", $stext, 15, $frmBot)
		If $MsgBox = 1 Then
			$HWnD = WinGetHandle($Title)
			WinActivate($HWnD)
			$QueenAltarPos[0] = FindPos()[0]
			$QueenAltarPos[1] = FindPos()[1]
			If isInsideDiamond($QueenAltarPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Queen Altar Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_RED)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $QueenAltarPos[0] & "," & $QueenAltarPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Queen Altar Location: " & "(" & $QueenAltarPos[0] & "," & $QueenAltarPos[1] & ")", $COLOR_RED)
						ClickP($aTopLeftClient)
						Return False
					Case Else
						SetLog(" Operator Error - Bad Queen Altar Location: " & "(" & $QueenAltarPos[0] & "," & $QueenAltarPos[1] & ")", $COLOR_RED)
						$QueenAltarPos[0] = -1
						$QueenAltarPos[1] = -1
						ClickP($aTopLeftClient)
						Return False
				EndSelect
			EndIf
			SetLog("Queen Altar: " & "(" & $QueenAltarPos[0] & "," & $QueenAltarPos[1] & ")", $COLOR_GREEN)
		Else
			SetLog("Locate Queen Altar Cancelled", $COLOR_BLUE)
			ClickP($aTopLeftClient)
			Return
		EndIf

		;get Queen info
		$sInfo = BuildingInfo(242, 520+60) ;jp
		If @error Then SetError(0, 0, 0)
		Local $CountGetInfo = 0
		While IsArray($sInfo) = False
			$sInfo = BuildingInfo(242, 520+60) ;jp
			If @error Then SetError(0, 0, 0)
			Sleep(100)
			$CountGetInfo += 1
			If $CountGetInfo = 50 Then Return
		WEnd
		If $debugSetlog = 1 Then SetLog($sInfo[1] & $sInfo[2])
		If @error Then Return SetError(0, 0, 0)

		If $sInfo[0] > 1 Or $sInfo[0] = "" Then
			If @error Then Return SetError(0, 0, 0)

			If StringInStr($sInfo[1], "Quee") = 0 Then
				If $sInfo[0] = "" Then
					$sLocMsg = "Nothing"
				Else
					$sLocMsg = $sInfo[1]
				EndIf
				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Queen Altar?, It was a " & $sLocMsg & @CRLF
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
						SetLog("Quit joking, Click the Queen Altar, or restart bot and try again", $COLOR_RED)
						$QueenAltarPos[0] = -1
						$QueenAltarPos[1] = -1
						ClickP($aTopLeftClient)
						Return False
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad Queen Altar Location: " & "(" & $QueenAltarPos[0] & "," & $QueenAltarPos[1] & ")", $COLOR_RED)
			$QueenAltarPos[0] = -1
			$QueenAltarPos[1] = -1
			ClickP($aTopLeftClient)
			Return False
		EndIf
		ExitLoop
	WEnd

	ClickP($aTopLeftClient, 1, 200, "#0327")
	If _Sleep(1000) Then Return

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = "Now you can remove mouse out of bluestacks, Thanks!!"
	$MsgBox = _ExtMsgBox(48, "OK", "Notice!", $stext, 15, $frmBot)

	IniWrite($building, "other", "xQueenAltarPos", $QueenAltarPos[0])
	IniWrite($building, "other", "yQueenAltarPos", $QueenAltarPos[1])

EndFunc   ;==>LocateQueenAltar



Func LocateKingAltar()

	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo
	$RunState = True
	WinActivate($Title)
	checkMainScreen(False)
	Collect()

	SetLog("Locating King Altar...", $COLOR_BLUE)
	While 1
		ClickP($aTopLeftClient)
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & "Click OK then click on your King Altar" & @CRLF & @CRLF & _
				"Do not move mouse after clicking location" & @CRLF & @CRLF & "Make sure the building name is visible for me!" & @CRLF
		$MsgBox = _ExtMsgBox(0, "Ok|Cancel", "Locate King Altar", $stext, 15, $frmBot)
		If $MsgBox = 1 Then
			$HWnD = WinGetHandle($Title)
			WinActivate($HWnD)
			$KingAltarPos[0] = FindPos()[0]
			$KingAltarPos[1] = FindPos()[1]
			If isInsideDiamond($KingAltarPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "King Altar Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_RED)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $KingAltarPos[0] & "," & $KingAltarPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad King Altar Location: " & "(" & $KingAltarPos[0] & "," & $KingAltarPos[1] & ")", $COLOR_RED)
						ClickP($aTopLeftClient)
						Return False
					Case Else
						SetLog(" Operator Error - Bad King Altar Location: " & "(" & $KingAltarPos[0] & "," & $KingAltarPos[1] & ")", $COLOR_RED)
						$KingAltarPos[0] = -1
						$KingAltarPos[1] = -1
						ClickP($aTopLeftClient)
						Return False
				EndSelect
			EndIf
			SetLog("King Altar: " & "(" & $KingAltarPos[0] & "," & $KingAltarPos[1] & ")", $COLOR_GREEN)
		Else
			SetLog("Locate King Altar Cancelled", $COLOR_BLUE)
			ClickP($aTopLeftClient)
			Return
		EndIf

		;Get King info
		$sInfo = BuildingInfo(242, 520+60) ;jp
		If @error Then SetError(0, 0, 0)
		Local $CountGetInfo = 0
		While IsArray($sInfo) = False
			$sInfo = BuildingInfo(242, 520+60) ;jp
			If @error Then SetError(0, 0, 0)
			Sleep(100)
			$CountGetInfo += 1
			If $CountGetInfo = 50 Then Return
		WEnd
		If $debugSetlog = 1 Then SetLog($sInfo[1] & $sInfo[2])
		If @error Then Return SetError(0, 0, 0)

		If $sInfo[0] > 1 Or $sInfo[0] = "" Then

			If (StringInStr($sInfo[1], "Barb") = 0) And (StringInStr($sInfo[1], "King") = 0) Then
				If $sInfo[0] = "" Then
					$sLocMsg = "Nothing"
				Else
					$sLocMsg = $sInfo[1]
				EndIf
				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the King Altar?, It was a " & $sLocMsg & @CRLF
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
						SetLog("Quit joking, Click the King Altar, or restart bot and try again", $COLOR_RED)
						$KingAltarPos[0] = -1
						$KingAltarPos[1] = -1
						ClickP($aTopLeftClient)
						Return False
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad King Altar Location: " & "(" & $KingAltarPos[0] & "," & $KingAltarPos[1] & ")", $COLOR_RED)
			$KingAltarPos[0] = -1
			$KingAltarPos[1] = -1
			ClickP($aTopLeftClient)
			Return False
		EndIf
		ExitLoop
	WEnd

	ClickP($aTopLeftClient, 1, 200, "#0327")
	If _Sleep(1000) Then Return

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = "Now you can remove mouse out of bluestacks, Thanks!!"
	$MsgBox = _ExtMsgBox(48, "OK", "Notice!", $stext, 15, $frmBot)

	IniWrite($building, "other", "xKingAltarPos", $KingAltarPos[0])
	IniWrite($building, "other", "yKingAltarPos", $KingAltarPos[1])

EndFunc   ;==>LocateKingAltar
