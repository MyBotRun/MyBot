
; #FUNCTION# ====================================================================================================================
; Name ..........: LocateClanCastle
; Description ...: Locates Clan Castle manually (Temporary)
; Syntax ........: LocateClanCastle()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #69
; Modified ......: KnowJack (June 2015) Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateClanCastle()
	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo

	SetLog("Locating Clan Castle...", $COLOR_BLUE)

	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1], True) <> Hex($aTopLeftClient[2], 6) Or _GetPixelColor($aTopRightClient[0], $aTopRightClient[1], True) <> Hex($aTopRightClient[2], 6) Then
		Zoomout()
		Collect()
	EndIf

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslated(640,32,"Click OK then click on your Clan Castle") & @CRLF & @CRLF & _
				GetTranslated(640,26,"Do not move mouse quickly after clicking location") & @CRLF & @CRLF & GetTranslated(640,27,"Make sure the building name is visible for me!") & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslated(640,1,"Ok|Cancel"), GetTranslated(640,33,"Locate Clan Castle"), $stext, 15, $frmBot)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClickP($aAway, 1, 0, "#0373")
			Local $aPos = FindPos()
			$aCCPos[0] = $aPos[0]
			$aCCPos[1] = $aPos[1]
			If isInsideDiamond($aCCPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Clan Castle Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_RED)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $aCCPos[0] & "," & $aCCPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Clan Castle Location: " & "(" & $aCCPos[0] & "," & $aCCPos[1] & ")", $COLOR_RED)
						ClickP($aAway, 1, 0, "#0374")
						Return False
					Case Else
						SetLog(" Operator Error - Bad Clan Castle Location: " & "(" & $aCCPos[0] & "," & $aCCPos[1] & ")", $COLOR_RED)
						$aCCPos[0] = -1
						$aCCPos[1] = -1
						ClickP($aAway, 1, 0, "#0375")
						Return False
				EndSelect
			EndIf
			SetLog("Clan Castle: " & "(" & $aCCPos[0] & "," & $aCCPos[1] & ")", $COLOR_GREEN)
		Else
			SetLog("Locate Clan Castle Cancelled", $COLOR_BLUE)
			ClickP($aAway, 1, 0, "#0376")
			Return
		EndIf
		$sInfo = BuildingInfo(242, 520 + $bottomOffsetY) ; 860x780
		If $sInfo[0] > 1 Or $sInfo[0] = "" Then
			If StringInStr($sInfo[1], "clan") = 0 Then
				If $sInfo[0] = "" Then
					$sLocMsg = "Nothing"
				Else
					$sLocMsg = $sInfo[1]
				EndIf
				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Clan Castle?, It was a " & $sLocMsg & @CRLF
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
						SetLog("Quit joking, Click the Clan Castle, or restart bot and try again", $COLOR_RED)
						$aCCPos[0] = -1
						$aCCPos[1] = -1
						ClickP($aAway, 1, 0, "#0377")
						Return False
				EndSelect
			EndIf
			If $sInfo[2] = "Broken" Then
				SetLog("You did not rebuild your Clan Castle yet.", $COLOR_ORANGE)
			Else
				SetLog("Your Clan Castle is at level: " & $sInfo[2], $COLOR_GREEN)
			EndIf
		Else
			SetLog(" Operator Error - Bad Clan Castle Location: " & "(" & $aCCPos[0] & "," & $aCCPos[1] & ")", $COLOR_RED)
			$aCCPos[0] = -1
			$aCCPos[1] = -1
			ClickP($aAway, 1, 0, "#0378")
			Return False
		EndIf
		ExitLoop
	WEnd

	ClickP($aAway, 1, 200, "#0327")

EndFunc   ;==>LocateClanCastle
