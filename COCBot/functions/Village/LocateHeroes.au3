#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here


Func LocateKingAltar()
	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo

	SetLog("Locating King Altar...", $COLOR_BLUE)

	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1], True) <> Hex($aTopLeftClient[2], 6) And _GetPixelColor($aTopRightClient[0], $aTopRightClient[1], True) <> Hex($aTopRightClient[2], 6) Then
		Zoomout()
		Collect()
	EndIf

	While 1
		ClickP($aTopLeftClient)
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext =  $sErrorText & @CRLF & "Click OK then click on your King Altar" & @CRLF & @CRLF & _
		"Do not move mouse after clicking location"& @CRLF & @CRLF & "Make sure the building name is visible for me!" & @CRLF
		$MsgBox = _ExtMsgBox(0, "Ok|Cancel", "Locate King Altar", $stext, 15, $frmBot)
		If $MsgBox = 1 Then
			WinActivate($HWnD)
			$KingPos[0] = FindPos()[0]
			$KingPos[1] = FindPos()[1]
			If isInsideDiamond($KingPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "King Altar Location Not Valid!"&@CRLF
						SetLog("Location not valid, try again", $COLOR_RED)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $KingPos[0] & "," & $KingPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!"& @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad King Altar Location: " & "(" & $KingPos[0] & "," & $KingPos[1] & ")", $COLOR_RED)
						ClickP($aTopLeftClient)
						Return False
					Case Else
						SetLog(" Operator Error - Bad King Altar Location: " & "(" & $KingPos[0] & "," & $KingPos[1] & ")", $COLOR_RED)
						$KingPos[0] = -1
						$KingPos[1] = -1
						ClickP($aTopLeftClient)
						Return False
				EndSelect
			EndIf
			SetLog("King Altar: " & "(" & $KingPos[0] & "," & $KingPos[1] & ")", $COLOR_GREEN)
		Else
			SetLog("Locate King Altar Cancelled", $COLOR_BLUE)
			ClickP($aTopLeftClient)
			Return
		EndIf
		$sInfo = BuildingInfo(242, 520)
		If $sInfo[0] > 1 Or $sInfo[0] = "" Then
			If  (StringInStr($sInfo[1], "Barb") = 0) And (StringInStr($sInfo[1], "King") = 0) Then
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
						$sErrorText = $sLocMsg&" ?!?!?!"&@CRLF&@CRLF&"Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!"& @CRLF
						ContinueLoop
					Case $iSilly > 4
						SetLog("Quit joking, Click the King Altar, or restart bot and try again", $COLOR_RED)
						$KingPos[0] = -1
						$KingPos[1] = -1
						ClickP($aTopLeftClient)
						Return False
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad King Altar Location: " & "(" & $KingPos[0] & "," & $KingPos[1] & ")", $COLOR_RED)
			$KingPos[0] = -1
			$KingPos[1] = -1
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
		
	
EndFunc   ;==>LocateKingAltar

Func LocateQueenAltar()
	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo

	SetLog("Locating Queen Altar...", $COLOR_BLUE)

	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1], True) <> Hex($aTopLeftClient[2], 6) And _GetPixelColor($aTopRightClient[0], $aTopRightClient[1], True) <> Hex($aTopRightClient[2], 6) Then
		Zoomout()
		Collect()
	EndIf

	While 1
		ClickP($aTopLeftClient)
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext =  $sErrorText & @CRLF & "Click OK then click on your Queen Altar" & @CRLF & @CRLF & _
		"Do not move mouse after clicking location"& @CRLF & @CRLF & "Make sure the building name is visible for me!" & @CRLF
		$MsgBox = _ExtMsgBox(0, "Ok|Cancel", "Locate Queen Altar", $stext, 15, $frmBot)
		If $MsgBox = 1 Then
			WinActivate($HWnD)
			$QueenPos[0] = FindPos()[0]
			$QueenPos[1] = FindPos()[1]
			If isInsideDiamond($QueenPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Queen Altar Location Not Valid!"&@CRLF
						SetLog("Location not valid, try again", $COLOR_RED)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $QueenPos[0] & "," & $QueenPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!"& @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Queen Altar Location: " & "(" & $QueenPos[0] & "," & $QueenPos[1] & ")", $COLOR_RED)
						ClickP($aTopLeftClient)
						Return False
					Case Else
						SetLog(" Operator Error - Bad Queen Altar Location: " & "(" & $QueenPos[0] & "," & $QueenPos[1] & ")", $COLOR_RED)
						$QueenPos[0] = -1
						$QueenPos[1] = -1
						ClickP($aTopLeftClient)
						Return False
				EndSelect
			EndIf
			SetLog("Queen Altar: " & "(" & $QueenPos[0] & "," & $QueenPos[1] & ")", $COLOR_GREEN)
		Else
			SetLog("Locate Queen Altar Cancelled", $COLOR_BLUE)
			ClickP($aTopLeftClient)
			Return
		EndIf
		$sInfo = BuildingInfo(242, 520)
		If $sInfo[0] > 1 Or $sInfo[0] = "" Then
			If  StringInStr($sInfo[1], "Quee") = 0 Then
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
						$sErrorText = $sLocMsg&" ?!?!?!"&@CRLF&@CRLF&"Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!"& @CRLF
						ContinueLoop
					Case $iSilly > 4
						SetLog("Quit joking, Click the Queen Altar, or restart bot and try again", $COLOR_RED)
						$QueenPos[0] = -1
						$QueenPos[1] = -1
						ClickP($aTopLeftClient)
						Return False
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad Queen Altar Location: " & "(" & $QueenPos[0] & "," & $QueenPos[1] & ")", $COLOR_RED)
			$QueenPos[0] = -1
			$QueenPos[1] = -1
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
	
EndFunc   ;==>LocateQueenAltar