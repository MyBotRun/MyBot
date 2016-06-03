
; #FUNCTION# ====================================================================================================================
; Name ..........: LocateSpellFactory
; Description ...: Locates Spell Factory manually
; Syntax ........: LocateSpellFactory()
; Parameters ....:
; Return values .: None
; Author ........: saviart
; Modified ......: KnowJack (June 2015) Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateSpellFactory()
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	SetLog("Locating Spell Factory...", $COLOR_BLUE)

	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1], True) <> Hex($aTopLeftClient[2], 6) Or _GetPixelColor($aTopRightClient[0], $aTopRightClient[1], True) <> Hex($aTopRightClient[2], 6) Then
		Zoomout()
		Collect()
	EndIf

	While 1
		ClickP($aAway, 1, 0, "#0385")
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslated(640,45,"Click OK then click on your Spell Factory") & @CRLF & @CRLF & _
				GetTranslated(640,26,"Do not move mouse quickly after clicking location") & @CRLF & @CRLF & GetTranslated(640,27,"Make sure the building name is visible for me!") & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslated(640,1,"Ok|Cancel"), GetTranslated(640,46,"Locate Spell Factory"), $stext, 15, $frmBot)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			WinActivate($HWnD)
			Local $aPos = FindPos()
			$SFPos[0] = $aPos[0]
			$SFPos[1] = $aPos[1]
			If isInsideDiamond($SFPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Spell Factory Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_RED)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $SFPos[0] & "," & $SFPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Spell Factory Location: " & "(" & $SFPos[0] & "," & $SFPos[1] & ")", $COLOR_RED)
						ClickP($aAway, 1, 0, "#0386")
						Return False
					Case Else
						SetLog(" Operator Error - Bad Spell Factory Location: " & "(" & $SFPos[0] & "," & $SFPos[1] & ")", $COLOR_RED)
						$SFPos[0] = -1
						$SFPos[1] = -1
						ClickP($aAway, 1, 0, "#0387")
						Return False
				EndSelect
			EndIf
			$sSpellInfo = BuildingInfo(242, 520 + $bottomOffsetY); 860x780
			If $sSpellInfo[0] > 1 Or $sSpellInfo[0] = "" Then
				If StringInStr($sSpellInfo[1], "Spell") = 0 Then
					If $sSpellInfo[0] = "" Then
						$sLocMsg = "Nothing"
					Else
						$sLocMsg = $sSpellInfo[1]
					EndIf
					$iSilly += 1
					Select
						Case $iSilly = 1
							$sErrorText = "Wait, That is not the Spell Factory, It was a " & $sLocMsg & @CRLF
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
							SetLog("Quit joking, Click the Army Camp, or restart bot and try again", $COLOR_RED)
							$SFPos[0] = -1
							$SFPos[1] = -1
							ClickP($aAway, 1, 0, "#0388")
							Return False
					EndSelect
				EndIf
			Else
				SetLog(" Operator Error - Bad Spell Factory Location: " & "(" & $SFPos[0] & "," & $SFPos[1] & ")", $COLOR_RED)
				$SFPos[0] = -1
				$SFPos[1] = -1
				ClickP($aAway, 1, 0, "#0389")
				Return False
			EndIf
			SetLog("Locate Spell Factory Success: " & "(" & $SFPos[0] & "," & $SFPos[1] & ")", $COLOR_GREEN)
		Else
			SetLog("Locate Spell Factory Cancelled", $COLOR_BLUE)
			ClickP($aAway, 1, 0, "#0390")
			Return
		EndIf
		ExitLoop
	WEnd

	ClickP($aAway, 2, 200, "#0208")

EndFunc   ;==>LocateSpellFactory



Func LocateDarkSpellFactory()
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	SetLog("Locating Dark Spell Factory...", $COLOR_BLUE)

	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1], True) <> Hex($aTopLeftClient[2], 6) And _GetPixelColor($aTopRightClient[0], $aTopRightClient[1], True) <> Hex($aTopRightClient[2], 6) Then
		Zoomout()
		Collect()
	EndIf

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslated(640,48,"Click OK then click on your Dark Spell Factory") & @CRLF & @CRLF & _
				GetTranslated(640,26,"Do not move mouse quickly after clicking location") & @CRLF & @CRLF & GetTranslated(640,27,"Make sure the building name is visible for me!") & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslated(640,1,"Ok|Cancel"), GetTranslated(640,47,"Locate Dark Spell Factory"), $stext, 15, $frmBot)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			WinActivate($HWnD)
			ClickP($aAway, 1, 0, "#0385")
			Local $aPos = FindPos()
			$DSFPos[0] = $aPos[0]
			$DSFPos[1] = $aPos[1]
			If isInsideDiamond($DSFPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Dark Spell Factory Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_RED)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $DSFPos[0] & "," & $DSFPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Dark Spell Factory Location: " & "(" & $DSFPos[0] & "," & $DSFPos[1] & ")", $COLOR_RED)
						ClickP($aAway, 1, 0, "#0386")
						Return False
					Case Else
						SetLog(" Operator Error - Bad Dark Spell Factory Location: " & "(" & $DSFPos[0] & "," & $DSFPos[1] & ")", $COLOR_RED)
						$DSFPos[0] = -1
						$DSFPos[1] = -1
						ClickP($aAway, 1, 0, "#0387")
						Return False
				EndSelect
			EndIf
			$sSpellInfo = BuildingInfo(242, 520 + $bottomOffsetY); 860x780
			If $sSpellInfo[0] > 1 Or $sSpellInfo[0] = "" Then
				If StringInStr($sSpellInfo[1], "Spell") = 0 Then
					If $sSpellInfo[0] = "" Then
						$sLocMsg = "Nothing"
					Else
						$sLocMsg = $sSpellInfo[1]
					EndIf
					$iSilly += 1
					Select
						Case $iSilly = 1
							$sErrorText = "Wait, That is not the Dark Spell Factory, It was a " & $sLocMsg & @CRLF
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
							SetLog("Quit joking, Click the Army Camp, or restart bot and try again", $COLOR_RED)
							$DSFPos[0] = -1
							$DSFPos[1] = -1
							ClickP($aAway, 1, 0, "#0388")
							Return False
					EndSelect
				EndIf
			Else
				SetLog(" Operator Error - Bad Spell Factory Location: " & "(" & $DSFPos[0] & "," & $DSFPos[1] & ")", $COLOR_RED)
				$DSFPos[0] = -1
				$DSFPos[1] = -1
				ClickP($aAway, 1, 0, "#0389")
				Return False
			EndIf
			SetLog("Locate Dark Spell Factory Success: " & "(" & $DSFPos[0] & "," & $DSFPos[1] & ")", $COLOR_GREEN)
		Else
			SetLog("Locate Dark Spell Factory Cancelled", $COLOR_BLUE)
			ClickP($aAway, 1, 0, "#0390")
			Return
		EndIf
		ExitLoop
	WEnd

	ClickP($aAway, 2, 200, "#0208")

EndFunc   ;==>LocateDarkSpellFactory
