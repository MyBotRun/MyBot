
; #FUNCTION# ====================================================================================================================
; Name ..........: LocateClanCastle
; Description ...: Locates Clan Castle manually (Temporary)
; Syntax ........: LocateClanCastle()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: KnowJack (06/2015) Sardo (08/2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateClanCastle($bCollect = True)
	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo

	SetLog("Locating Clan Castle", $COLOR_INFO)

	WinGetAndroidHandle()
	checkMainScreen()
	If $bCollect Then Collect(False)

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_Clan_Castle_01", "Click OK then click on your Clan Castle") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", "Do not move mouse quickly after clicking location") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", "Make sure the building name is visible for me!") & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Clan_Castle_02", "Locate Clan Castle"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClearScreen()
			Local $aPos = FindPos()
			$g_aiClanCastlePos[0] = $aPos[0]
			$g_aiClanCastlePos[1] = $aPos[1]
			If Not isInsideDiamond($g_aiClanCastlePos) Then
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
						ClearScreen()
						Return False
					Case Else
						SetLog(" Operator Error - Bad Clan Castle Location: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_ERROR)
						$g_aiClanCastlePos[0] = -1
						$g_aiClanCastlePos[1] = -1
						ClearScreen()
						Return False
				EndSelect
			EndIf
			SetLog("Clan Castle: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_SUCCESS)
		Else
			SetLog("Locate Clan Castle Cancelled", $COLOR_INFO)
			ClearScreen()
			Return
		EndIf
		$sInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY) ; 860x780
		If IsArray($sInfo) And ($sInfo[0] > 1 Or $sInfo[0] = "") Then
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
						ClearScreen()
						Return False
				EndSelect
			EndIf
			If $sInfo[2] = "Broken" Then
				SetLog("You did not rebuild your Clan Castle yet", $COLOR_ACTION)
			Else
				SetLog("Your Clan Castle is at level: " & $sInfo[2], $COLOR_SUCCESS)
				Switch $sInfo[2]
					Case 1
						$g_aiClanCastleTroopsCap = 10
						$g_aiClanCastleSpellsCap = 0
					Case 2
						$g_aiClanCastleTroopsCap = 15
						$g_aiClanCastleSpellsCap = 0
					Case 3
						$g_aiClanCastleTroopsCap = 20
						$g_aiClanCastleSpellsCap = 0
					Case 4
						$g_aiClanCastleTroopsCap = 25
						$g_aiClanCastleSpellsCap = 1
					Case 5
						$g_aiClanCastleTroopsCap = 30
						$g_aiClanCastleSpellsCap = 1
					Case 6
						$g_aiClanCastleTroopsCap = 35
						$g_aiClanCastleSpellsCap = 1
					Case 7
						$g_aiClanCastleTroopsCap = 35
						$g_aiClanCastleSpellsCap = 2
					Case 8
						$g_aiClanCastleTroopsCap = 40
						$g_aiClanCastleSpellsCap = 2
					Case 9
						$g_aiClanCastleTroopsCap = 45
						$g_aiClanCastleSpellsCap = 2
					Case 10
						$g_aiClanCastleTroopsCap = 45
						$g_aiClanCastleSpellsCap = 3
					Case 11, 12
						$g_aiClanCastleTroopsCap = 50
						$g_aiClanCastleSpellsCap = 3
					Case 13
						$g_aiClanCastleTroopsCap = 55
						$g_aiClanCastleSpellsCap = 3
				EndSwitch
			EndIf
		Else
			SetLog(" Operator Error - Bad Clan Castle Location: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_ERROR)
			$g_aiClanCastlePos[0] = -1
			$g_aiClanCastlePos[1] = -1
			ClearScreen()
			Return False
		EndIf
		ExitLoop
	WEnd

	ClearScreen()
EndFunc   ;==>LocateClanCastle
