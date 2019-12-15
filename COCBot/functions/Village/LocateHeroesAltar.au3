; #FUNCTION# ====================================================================================================================
; Name ..........: LocateQueenAltar & LocateKingAltar & LocateWardenAltar
; Description ...:
; Syntax ........: LocateKingAltar() & LocateQueenAltar() &  LocateWardenAltar()
; Parameters ....:
; Return values .: None
; Author ........: ProMac(07/2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateQueenAltar($bCollect = True)
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	AndroidShield("LocateQueenAltar 1") ; Update shield status due to manual $g_bRunState
	Local $Result = _LocateQueenAltar($bCollect)
	$g_bRunState = $wasRunState
	AndroidShield("LocateQueenAltar 2") ; Update shield status due to manual $g_bRunState
	Return $Result
EndFunc   ;==>LocateQueenAltar

Func _LocateQueenAltar($bCollect = True)

	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo

	WinGetAndroidHandle()
	checkMainScreen(False)
	If $bCollect Then Collect(False)

	SetLog("Locating Queen Altar", $COLOR_INFO)
	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_Queen_Altar_01", "Click OK then click on your Queen Altar") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Queen_Altar_02", "Locate Queen Altar"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClickP($aAway)
			Local $aPos = FindPos()
			$g_aiQueenAltarPos[0] = $aPos[0]
			$g_aiQueenAltarPos[1] = $aPos[1]
			If Not isInsideDiamond($g_aiQueenAltarPos) Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Queen Altar Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_ERROR)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $g_aiQueenAltarPos[0] & "," & $g_aiQueenAltarPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Queen Altar Location: " & "(" & $g_aiQueenAltarPos[0] & "," & $g_aiQueenAltarPos[1] & ")", $COLOR_ERROR)
						ClickP($aAway)
						Return False
					Case Else
						SetLog(" Operator Error - Bad Queen Altar Location: " & "(" & $g_aiQueenAltarPos[0] & "," & $g_aiQueenAltarPos[1] & ")", $COLOR_ERROR)
						$g_aiQueenAltarPos[0] = -1
						$g_aiQueenAltarPos[1] = -1
						ClickP($aAway)
						Return False
				EndSelect
			EndIf
			SetLog("Queen Altar: " & "(" & $g_aiQueenAltarPos[0] & "," & $g_aiQueenAltarPos[1] & ")", $COLOR_SUCCESS)
		Else
			SetLog("Locate Queen Altar Cancelled", $COLOR_INFO)
			ClickP($aAway)
			Return
		EndIf

		;get Queen info
		$sInfo = BuildingInfo(242, 490 + $g_iBottomOffsetY); 860x780
		If @error Then SetError(0, 0, 0)
		Local $CountGetInfo = 0
		While Not IsArray($sInfo)
			$sInfo = BuildingInfo(242, 490 + $g_iBottomOffsetY); 860x780
			If @error Then SetError(0, 0, 0)
			Sleep(100)
			$CountGetInfo += 1
			If $CountGetInfo = 50 Then Return
		WEnd
		If $g_bDebugSetlog Then SetDebugLog($sInfo[1] & $sInfo[2])
		If @error Then Return SetError(0, 0, 0)

		If $sInfo[0] > 1 Or $sInfo[0] = "" Then
			If @error Then Return SetError(0, 0, 0)

			If StringInStr($sInfo[1], "Quee") = 0 Then
				Local $sLocMsg = ($sInfo[0] = "" ? "Nothing" : $sInfo[1])

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
						SetLog("Quit joking, Click the Queen Altar, or restart bot and try again", $COLOR_ERROR)
						$g_aiQueenAltarPos[0] = -1
						$g_aiQueenAltarPos[1] = -1
						ClickP($aAway)
						Return False
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad Queen Altar Location: " & "(" & $g_aiQueenAltarPos[0] & "," & $g_aiQueenAltarPos[1] & ")", $COLOR_ERROR)
			$g_aiQueenAltarPos[0] = -1
			$g_aiQueenAltarPos[1] = -1
			ClickP($aAway)
			Return False
		EndIf
		ExitLoop
	WEnd

	ClickP($aAway, 1, 200, "#0327")
	If _Sleep(1000) Then Return

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = GetTranslatedFileIni("MBR Popups", "Locate_building_03", "Now you can remove mouse out of Android Emulator, Thanks!!")
	$MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), GetTranslatedFileIni("MBR Popups", "Locate_building_04", "Notice!"), $stext, 15)

	IniWrite($g_sProfileBuildingPath, "other", "xQueenAltarPos", $g_aiQueenAltarPos[0])
	IniWrite($g_sProfileBuildingPath, "other", "yQueenAltarPos", $g_aiQueenAltarPos[1])
EndFunc   ;==>_LocateQueenAltar

Func LocateKingAltar($bCollect = True)
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	AndroidShield("LocateKingAltar 1") ; Update shield status due to manual $g_bRunState
	Local $Result = _LocateKingAltar($bCollect)
	$g_bRunState = $wasRunState
	AndroidShield("LocateKingAltar 2") ; Update shield status due to manual $g_bRunState
	Return $Result
EndFunc   ;==>LocateKingAltar

Func _LocateKingAltar($bCollect = True)

	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo

	WinGetAndroidHandle()
	checkMainScreen(False)
	If $bCollect Then Collect(False)

	SetLog("Locating King Altar", $COLOR_INFO)
	While 1
		ClickP($aAway)
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_King_Altar_01", "Click OK then click on your King Altar") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", "Do not move mouse quickly after clicking location") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", "Make sure the building name is visible for me!") & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_King_Altar_02", "Locate King Altar"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			Local $aPos = FindPos()
			$g_aiKingAltarPos[0] = $aPos[0]
			$g_aiKingAltarPos[1] = $aPos[1]
			If Not isInsideDiamond($g_aiKingAltarPos) Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "King Altar Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_ERROR)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $g_aiKingAltarPos[0] & "," & $g_aiKingAltarPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad King Altar Location: " & "(" & $g_aiKingAltarPos[0] & "," & $g_aiKingAltarPos[1] & ")", $COLOR_ERROR)
						ClickP($aAway)
						Return False
					Case Else
						SetLog(" Operator Error - Bad King Altar Location: " & "(" & $g_aiKingAltarPos[0] & "," & $g_aiKingAltarPos[1] & ")", $COLOR_ERROR)
						$g_aiKingAltarPos[0] = -1
						$g_aiKingAltarPos[1] = -1
						ClickP($aAway)
						Return False
				EndSelect
			EndIf
			SetLog("King Altar: " & "(" & $g_aiKingAltarPos[0] & "," & $g_aiKingAltarPos[1] & ")", $COLOR_SUCCESS)
		Else
			SetLog("Locate King Altar Cancelled", $COLOR_INFO)
			ClickP($aAway)
			Return
		EndIf

		;Get King info
		$sInfo = BuildingInfo(242, 490 + $g_iBottomOffsetY); 860x780
		If @error Then SetError(0, 0, 0)
		Local $CountGetInfo = 0
		While Not IsArray($sInfo)
			$sInfo = BuildingInfo(242, 490 + $g_iBottomOffsetY); 860x780
			If @error Then SetError(0, 0, 0)
			Sleep(100)
			$CountGetInfo += 1
			If $CountGetInfo = 50 Then Return
		WEnd
		If $g_bDebugSetlog Then SetDebugLog($sInfo[1] & $sInfo[2])
		If @error Then Return SetError(0, 0, 0)

		If $sInfo[0] > 1 Or $sInfo[0] = "" Then

			If (StringInStr($sInfo[1], "Barb") = 0) And (StringInStr($sInfo[1], "King") = 0) Then
				Local $sLocMsg = ($sInfo[0] = "" ? "Nothing" : $sInfo[1])

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
						SetLog("Quit joking, Click the King Altar, or restart bot and try again", $COLOR_ERROR)
						$g_aiKingAltarPos[0] = -1
						$g_aiKingAltarPos[1] = -1
						ClickP($aAway)
						Return False
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad King Altar Location: " & "(" & $g_aiKingAltarPos[0] & "," & $g_aiKingAltarPos[1] & ")", $COLOR_ERROR)
			$g_aiKingAltarPos[0] = -1
			$g_aiKingAltarPos[1] = -1
			ClickP($aAway)
			Return False
		EndIf
		ExitLoop
	WEnd

	ClickP($aAway, 1, 200, "#0327")
	If _Sleep(1000) Then Return

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = GetTranslatedFileIni("MBR Popups", "Locate_building_03", "Now you can remove mouse out of Android Emulator, Thanks!!")
	$MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), GetTranslatedFileIni("MBR Popups", "Locate_building_04", "Notice!"), $stext, 15)

	IniWrite($g_sProfileBuildingPath, "other", "xKingAltarPos", $g_aiKingAltarPos[0])
	IniWrite($g_sProfileBuildingPath, "other", "yKingAltarPos", $g_aiKingAltarPos[1])
EndFunc   ;==>_LocateKingAltar

Func LocateWardenAltar($bCollect = True)
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	AndroidShield("LocateWardenAltar 1") ; Update shield status due to manual $g_bRunState
	Local $Result = _LocateWardenAltar($bCollect)
	$g_bRunState = $wasRunState
	AndroidShield("LocateWardenAltar 2") ; Update shield status due to manual $g_bRunState
	Return $Result
EndFunc   ;==>LocateWardenAltar

Func _LocateWardenAltar($bCollect = True)
	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo

	If Number($g_iTownHallLevel) < 11 Then
		SetLog("Grand Warden requires TH11! Stop locating Altar", $COLOR_ERROR)
		Return
	EndIf

	WinGetAndroidHandle()
	checkMainScreen(False)
	If $bCollect Then Collect(False)

	SetLog("Locating Grand Warden Altar", $COLOR_INFO)
	While 1
		ClickP($aAway)
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_Warden_Altar_01", "Click OK then click on your Grand Warden Altar") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", "Do not move mouse quickly after clicking location") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", "Make sure the building name is visible for me!") & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Warden_Altar_02", "Locate Grand Warden Altar"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			Local $aPos = FindPos()
			$g_aiWardenAltarPos[0] = $aPos[0]
			$g_aiWardenAltarPos[1] = $aPos[1]
			If Not isInsideDiamond($g_aiWardenAltarPos) Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Grand Warden Altar Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_ERROR)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $g_aiWardenAltarPos[0] & "," & $g_aiWardenAltarPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Grand Warden Altar Location: " & "(" & $g_aiWardenAltarPos[0] & "," & $g_aiWardenAltarPos[1] & ")", $COLOR_ERROR)
						ClickP($aAway)
						Return False
					Case Else
						SetLog(" Operator Error - Bad Grand Warden Altar Location: " & "(" & $g_aiWardenAltarPos[0] & "," & $g_aiWardenAltarPos[1] & ")", $COLOR_ERROR)
						$g_aiWardenAltarPos[0] = -1
						$g_aiWardenAltarPos[1] = -1
						ClickP($aAway)
						Return False
				EndSelect
			EndIf
			SetLog("Grand Warden Altar: " & "(" & $g_aiWardenAltarPos[0] & "," & $g_aiWardenAltarPos[1] & ")", $COLOR_SUCCESS)
		Else
			SetLog("Locate Grand Warden Altar Cancelled", $COLOR_INFO)
			ClickP($aAway)
			Return
		EndIf

		;get GrandWarden info
		$sInfo = BuildingInfo(242, 490 + $g_iBottomOffsetY) ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< need to work
		If @error Then SetError(0, 0, 0)
		Local $CountGetInfo = 0
		While Not IsArray($sInfo)
			$sInfo = BuildingInfo(242, 490 + $g_iBottomOffsetY)
			If @error Then SetError(0, 0, 0)
			Sleep(100)
			$CountGetInfo += 1
			If $CountGetInfo = 50 Then Return
		WEnd
		If $g_bDebugSetlog Then SetDebugLog($sInfo[1] & $sInfo[2])
		If @error Then Return SetError(0, 0, 0)

		If $sInfo[0] > 1 Or $sInfo[0] = "" Then
			If @error Then Return SetError(0, 0, 0)

			If StringInStr($sInfo[1], "Warden") = 0 Then
				Local $sLocMsg = ($sInfo[0] = "" ? "Nothing" : $sInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Grand Warden Altar?, It was a " & $sLocMsg & @CRLF
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
						SetLog("Quit joking, Click the Grand Warden Altar, or restart bot and try again", $COLOR_ERROR)
						$g_aiWardenAltarPos[0] = -1
						$g_aiWardenAltarPos[1] = -1
						ClickP($aAway)
						Return False
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad Grand Warden Altar Location: " & "(" & $g_aiWardenAltarPos[0] & "," & $g_aiWardenAltarPos[1] & ")", $COLOR_ERROR)
			$g_aiWardenAltarPos[0] = -1
			$g_aiWardenAltarPos[1] = -1
			ClickP($aAway)
			Return False
		EndIf
		ExitLoop
	WEnd

	ClickP($aAway, 1, 200, "#0327")
	If _Sleep(1000) Then Return

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = GetTranslatedFileIni("MBR Popups", "Locate_building_03", "Now you can remove mouse out of Android Emulator, Thanks!!")
	$MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), GetTranslatedFileIni("MBR Popups", "Locate_building_04", "Notice!"), $stext, 15)

	IniWrite($g_sProfileBuildingPath, "other", "xWardenAltarPos", $g_aiWardenAltarPos[0])
	IniWrite($g_sProfileBuildingPath, "other", "yWardenAltarPos", $g_aiWardenAltarPos[1])
EndFunc   ;==>_LocateWardenAltar

Func LocateChampionAltar($bCollect = True)
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	AndroidShield("LocateChampionAltar 1") ; Update shield status due to manual $g_bRunState
	Local $Result = _LocateChampionAltar($bCollect)
	$g_bRunState = $wasRunState
	AndroidShield("LocateChampionAltar 2") ; Update shield status due to manual $g_bRunState
	Return $Result
EndFunc   ;==>LocateChampionAltar

Func _LocateChampionAltar($bCollect = True)
	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo

	If Number($g_iTownHallLevel) <= 12 Then
		SetLog("Royal Champion requires TH13! Stop locating Altar", $COLOR_ERROR)
		Return
	EndIf

	WinGetAndroidHandle()
	checkMainScreen(False)
	If $bCollect Then Collect(False)

	SetLog("Locating Royal Champion Altar", $COLOR_INFO)
	While 1
		ClickP($aAway)
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_Champion_Altar_01", "Click OK then click on your Royal Champion Altar") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", "Do not move mouse quickly after clicking location") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", "Make sure the building name is visible for me!") & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Champion_Altar_02", "Locate Royal Champion Altar"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			Local $aPos = FindPos()
			$g_aiChampionAltarPos[0] = $aPos[0]
			$g_aiChampionAltarPos[1] = $aPos[1]
			If Not isInsideDiamond($g_aiChampionAltarPos) Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Royal Champion Altar Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_ERROR)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $g_aiChampionAltarPos[0] & "," & $g_aiChampionAltarPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Royal Champion Altar Location: " & "(" & $g_aiChampionAltarPos[0] & "," & $g_aiChampionAltarPos[1] & ")", $COLOR_ERROR)
						ClickP($aAway)
						Return False
					Case Else
						SetLog(" Operator Error - Bad Royal Champion Altar Location: " & "(" & $g_aiChampionAltarPos[0] & "," & $g_aiChampionAltarPos[1] & ")", $COLOR_ERROR)
						$g_aiChampionAltarPos[0] = -1
						$g_aiChampionAltarPos[1] = -1
						ClickP($aAway)
						Return False
				EndSelect
			EndIf
			SetLog("Royal Champion Altar: " & "(" & $g_aiChampionAltarPos[0] & "," & $g_aiChampionAltarPos[1] & ")", $COLOR_SUCCESS)
		Else
			SetLog("Locate Royal Champion Altar Cancelled", $COLOR_INFO)
			ClickP($aAway)
			Return
		EndIf

		;get RoyalChampion info
		$sInfo = BuildingInfo(242, 490 + $g_iBottomOffsetY) ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< need to work
		If @error Then SetError(0, 0, 0)
		Local $CountGetInfo = 0
		While Not IsArray($sInfo)
			$sInfo = BuildingInfo(242, 490 + $g_iBottomOffsetY)
			If @error Then SetError(0, 0, 0)
			Sleep(100)
			$CountGetInfo += 1
			If $CountGetInfo = 50 Then Return
		WEnd
		If $g_bDebugSetlog Then SetDebugLog($sInfo[1] & $sInfo[2])
		If @error Then Return SetError(0, 0, 0)

		If $sInfo[0] > 1 Or $sInfo[0] = "" Then
			If @error Then Return SetError(0, 0, 0)

			If StringInStr($sInfo[1], "Champion") = 0 Then
				Local $sLocMsg = ($sInfo[0] = "" ? "Nothing" : $sInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Royal Champion Altar?, It was a " & $sLocMsg & @CRLF
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
						SetLog("Quit joking, Click the Royal Champion Altar, or restart bot and try again", $COLOR_ERROR)
						$g_aiChampionAltarPos[0] = -1
						$g_aiChampionAltarPos[1] = -1
						ClickP($aAway)
						Return False
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad Royal Champion Altar Location: " & "(" & $g_aiChampionAltarPos[0] & "," & $g_aiChampionAltarPos[1] & ")", $COLOR_ERROR)
			$g_aiChampionAltarPos[0] = -1
			$g_aiChampionAltarPos[1] = -1
			ClickP($aAway)
			Return False
		EndIf
		ExitLoop
	WEnd

	ClickP($aAway, 1, 200, "#0327")
	If _Sleep(1000) Then Return

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = GetTranslatedFileIni("MBR Popups", "Locate_building_03", "Now you can remove mouse out of Android Emulator, Thanks!!")
	$MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), GetTranslatedFileIni("MBR Popups", "Locate_building_04", "Notice!"), $stext, 15)

	IniWrite($g_sProfileBuildingPath, "other", "xChampionAltarPos", $g_aiChampionAltarPos[0])
	IniWrite($g_sProfileBuildingPath, "other", "yChampionAltarPos", $g_aiChampionAltarPos[1])
EndFunc   ;==>_LocateChampionAltar
