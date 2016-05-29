; #FUNCTION# ====================================================================================================================
; Name ..........: LocateLab
; Description ...:
; Syntax ........: LocateLab()
; Parameters ....:
; Return values .: None
; Author ........: KnowJack (June 2015)
; Modified ......: Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateLab()
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	SetLog("Locating Laboratory...", $COLOR_BLUE)

	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1], True) <> Hex($aTopLeftClient[2], 6) Or _GetPixelColor($aTopRightClient[0], $aTopRightClient[1], True) <> Hex($aTopRightClient[2], 6) Then
		Zoomout()
		Collect()
	EndIf

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = $sErrorText & @CRLF & GetTranslated(640,43,"Click OK then click on your Laboratory building") & @CRLF & @CRLF & _
				GetTranslated(640,26,"Do not move mouse quickly after clicking location") & @CRLF & @CRLF & GetTranslated(640,27,"Make sure the building name is visible for me!") & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslated(640,1,"Ok|Cancel"), GetTranslated(640,44,"Locate Laboratory"), $stext, 15, $frmBot)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			WinActivate($HWnD)
			ClickP($aAway, 1, 0, "#0379")
			Local $aPos = FindPos()
			$aLabPos[0] = Int($aPos[0])
			$aLabPos[1] = Int($aPos[1])
			If isInsideDiamond($aLabPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Laboratory Location Not Valid!" & @CRLF
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
						SetLog(" Operator Error - Bad Laboratory Location: " & "(" & $SFPos[0] & "," & $SFPos[1] & ")", $COLOR_RED)
						ClickP($aAway, 1, 0, "#0380")
						Return False
					Case Else
						SetLog(" Operator Error - Bad Laboratory Location: " & "(" & $SFPos[0] & "," & $SFPos[1] & ")", $COLOR_RED)
						$aLabPos[0] = -1
						$aLabPos[1] = -1
						ClickP($aAway, 1, 0, "#0381")
						Return False
				EndSelect
			EndIf
		Else
			SetLog("Locate Laboratory Cancelled", $COLOR_BLUE)
			ClickP($aAway, 1, 0, "#0382")
			Return
		EndIf
		$sLabInfo = BuildingInfo(242, 520 + $bottomOffsetY); 860x780
		If $sLabInfo[0] > 1 Or $sLabInfo[0] = "" Then
			If StringInStr($sLabInfo[1], "Lab") = 0 Then
				If $sLabInfo[0] = "" Then
					$sLocMsg = "Nothing"
				Else
					$sLocMsg = $sLabInfo[1]
				EndIf
				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the laboratory?, It was a " & $sLocMsg & @CRLF
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
						$aLabPos[0] = -1
						$aLabPos[1] = -1
						ClickP($aAway, 1, 0, "#0383")
						Return False
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad Laboratory Location: " & "(" & $aLabPos[0] & "," & $aLabPos[1] & ")", $COLOR_RED)
			$aLabPos[0] = -1
			$aLabPos[1] = -1
			ClickP($aAway, 1, 0, "#0384")
			Return False
		EndIf
		SetLog("Locate Laboratory Success: " & "(" & $aLabPos[0] & "," & $aLabPos[1] & ")", $COLOR_GREEN)
		ExitLoop
	WEnd
	Clickp($aAway, 2, 0, "#0207")

EndFunc   ;==>LocateLab
