
; #FUNCTION# ====================================================================================================================
; Name ..........: LocateClanCastle
; Description ...: Locates Clan Castle manually (Temporary)
; Syntax ........: LocateClanCastle()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #69
; Modified ......: KnowJack (June 2015) Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateClanCastle()
	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo

	SetLog("Locating Clan Castle...", $COLOR_INFO)

	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1], True) <> Hex($aTopLeftClient[2], 6) Or _GetPixelColor($aTopRightClient[0], $aTopRightClient[1], True) <> Hex($aTopRightClient[2], 6) Then
		Zoomout()
		Collect(False)
	EndIf

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_Clan_Castle_01", "Click OK then click on your Clan Castle") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", "Do not move mouse quickly after clicking location") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", "Make sure the building name is visible for me!") & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Clan_Castle_02", "Locate Clan Castle"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClickP($aAway, 1, 0, "#0373")
			Local $aPos = FindPos()
			$g_aiClanCastlePos[0] = $aPos[0]
			$g_aiClanCastlePos[1] = $aPos[1]
			If isInsideDiamond($g_aiClanCastlePos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Clan Castle Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_ERROR)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Clan Castle Location: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_ERROR)
						ClickP($aAway, 1, 0, "#0374")
						Return False
					Case Else
						SetLog(" Operator Error - Bad Clan Castle Location: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_ERROR)
						$g_aiClanCastlePos[0] = -1
						$g_aiClanCastlePos[1] = -1
						ClickP($aAway, 1, 0, "#0375")
						Return False
				EndSelect
			EndIf
			SetLog("Clan Castle: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_SUCCESS)
		Else
			SetLog("Locate Clan Castle Cancelled", $COLOR_INFO)
			ClickP($aAway, 1, 0, "#0376")
			Return
		EndIf
		$sInfo = BuildingInfo(242, 520 + $g_iBottomOffsetY) ; 860x780
		If IsArray($sInfo) and ($sInfo[0] > 1 Or $sInfo[0] = "") Then
			If StringInStr($sInfo[1], "clan") = 0 Then
				Local $sLocMsg = ($sInfo[0] = "" ? "Nothing" : $sInfo[1])

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
						SetLog("Quit joking, Click the Clan Castle, or restart bot and try again", $COLOR_ERROR)
						$g_aiClanCastlePos[0] = -1
						$g_aiClanCastlePos[1] = -1
						ClickP($aAway, 1, 0, "#0377")
						Return False
				EndSelect
			EndIf
			If $sInfo[2] = "Broken" Then
				SetLog("You did not rebuild your Clan Castle yet.", $COLOR_ACTION)
			Else
				SetLog("Your Clan Castle is at level: " & $sInfo[2], $COLOR_SUCCESS)
			EndIf
		Else
			SetLog(" Operator Error - Bad Clan Castle Location: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_ERROR)
			$g_aiClanCastlePos[0] = -1
			$g_aiClanCastlePos[1] = -1
			ClickP($aAway, 1, 0, "#0378")
			Return False
		EndIf
		ExitLoop
	WEnd

	ClickP($aAway, 1, 200, "#0327")

EndFunc   ;==>LocateClanCastle
