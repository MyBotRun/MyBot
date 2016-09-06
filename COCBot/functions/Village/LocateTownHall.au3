
; #FUNCTION# ====================================================================================================================
; Name ..........: LocateTownHall
; Description ...: Locates TownHall for Rearm Function
; Syntax ........: LocateTownHall()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: KnowJack (July 2015) Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateTownHall($bLocationOnly = False)

	Local $stext, $MsgBox, $Success, $sLocMsg
	Local $iStupid = 0, $iSilly = 0, $sErrorText = ""

	SetLog("Locating Town Hall ...", $COLOR_BLUE)

    WinGetAndroidHandle()
	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1], True) <> Hex($aTopLeftClient[2], 6) Or _GetPixelColor($aTopRightClient[0], $aTopRightClient[1], True) <> Hex($aTopRightClient[2], 6) Then
		Zoomout()
		Collect()
	EndIf

	While 1
		_ExtMsgBoxSet(1 + 64, 1, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = $sErrorText & @CRLF & GetTranslated(640,49,"Click OK then click on your Town Hall") & @CRLF & @CRLF & _
				GetTranslated(640,26,"Do not move mouse quickly after clicking location") & @CRLF & @CRLF & GetTranslated(640,27,"Make sure the building name is visible for me!") & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslated(640,1,"Ok|Cancel"), GetTranslated(640,50,"Locate TownHall"), $stext, 30, $frmBot)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClickP($aAway, 1, 0, "#0391")
			Local $aPos = FindPos()
			$TownHallPos[0] = $aPos[0]
			$TownHallPos[1] = $aPos[1]
			If _Sleep($iDelayLocateTownHall1) Then Return
			If isInsideDiamond($TownHallPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "TownHall Location not valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_RED)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $TownHallPos[0] & "," & $TownHallPos[1] & ")?" & @CRLF & "Please stop!" & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Townhall Location: " & "(" & $TownHallPos[0] & "," & $TownHallPos[1] & ")", $COLOR_RED)
						$TownHallPos[0] = -1
						$TownHallPos[1] = -1
						ClickP($aAway, 1, 0, "#0392")
						Return False
				EndSelect
			EndIf
			SetLog("Townhall: " & "(" & $TownHallPos[0] & "," & $TownHallPos[1] & ")", $COLOR_GREEN)
		Else
			SetLog("Locate TownHall Cancelled", $COLOR_BLUE)
			ClickP($aAway, 1, 0, "#0393")
			Return
		EndIf
		If $bLocationOnly = False Then
			$Success = GetTownHallLevel() ; Get/Save the users updated TH level
			$iSilly += 1
			If IsArray($Success) Or $Success = False Then
				If $Success = False Then
					$sLocMsg = "Nothing"
				Else
					$sLocMsg = $Success[1]
				EndIf
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not a TownHall?, It was a " & $sLocMsg & @CRLF
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
						SetLog("Quit joking, Click on the TH, or restart bot and try again", $COLOR_RED)
						$TownHallPos[0] = -1
						$TownHallPos[1] = -1
						ClickP($aAway, 1, 0, "#0394")
						Return False
				EndSelect
			Else
				SetLog("Locate TH Success!", $COLOR_RED)
			EndIf
		EndIf
		ExitLoop
	WEnd

	ClickP($aAway, 1, 50, "#0209")

EndFunc   ;==>LocateTownHall
