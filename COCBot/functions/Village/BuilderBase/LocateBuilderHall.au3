Func LocateBuilderHall()
	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\BuilderHall\"

	If Not isOnBuilderBase(True) Then Return

	ZoomOut()

	If $g_aiBuilderHallPos[0] > 0 And $g_aiBuilderHallPos[1] > 0 Then
		BuildingClickP($g_aiBuilderHallPos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; Get building name and level with OCR
		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "Builder") = True Then ; we found the Clan Castle
				SetLog("Builder Hall located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)

				If $aResult[2] > $g_iBuilderHallLevel Then $g_iBuilderHallLevel = $aResult[2]
				ClickAway()
				Return True
			Else
				ClickAway()
				SetLog("Village position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
				SetLog("Stored Builder Hall Position is not valid.", $COLOR_ERROR)
				SetLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				ConvertToVillagePos($g_aiBuilderHallPos[0],$g_aiBuilderHallPos[1])
				SetLog("Real position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
				$g_aiBuilderHallPos[0] = -1
				$g_aiBuilderHallPos[1] = -1
			EndIf
		Else
			ClickAway()
			SetDebugLog("Stored Builder Hall Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiBuilderHallPos[0],$g_aiBuilderHallPos[1])
			SetDebugLog("Real position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
			$g_aiBuilderHallPos[0] = -1
			$g_aiBuilderHallPos[1] = -1
		EndIf
	EndIf

	SetLog("Looking for Builder Hall...", $COLOR_ACTION)

	Local $sCocDiamond = $CocDiamondDCD
	Local $sRedLines = $sCocDiamond
	Local $iMinLevel = 0
	Local $iMaxLevel = 1000
	Local $iMaxReturnPoints = 1
	Local $sReturnProps = "objectname,objectpoints"
	Local $bForceCapture = True

	; DETECTION IMGLOC
	Local $aResult
	For $j = 0 to 10
		SetLog("ImgLoc Builder Hall loop :" & $j & " zoom factor :" & $g_aVillageSize[1])
		$aResult = findMultiple($sImgDir, $sCocDiamond, $sRedLines, $iMinLevel, $iMaxLevel, $iMaxReturnPoints, $sReturnProps, $bForceCapture)
		If IsArray($aResult) And UBound($aResult) > 0 Then ; we have an array with data of images found
			For $i = 0 To UBound($aResult) - 1
				If _Sleep(50) Then Return ; just in case on PAUSE
				If Not $g_bRunState Then Return ; Stop Button
				SetDebugLog(_ArrayToString($aResult[$i]))
				Local $aTEMP = $aResult[$i]
				Local $sObjectname = String($aTEMP[0])
				SetDebugLog("Image name: " & String($aTEMP[0]), $COLOR_INFO)
				Local $aObjectpoints = $aTEMP[1] ; number of  objects returned
				SetDebugLog("Object points: " & String($aTEMP[1]), $COLOR_INFO)
				If StringInStr($aObjectpoints, "|") Then
					$aObjectpoints = StringReplace($aObjectpoints, "||", "|")
					Local $sString = StringRight($aObjectpoints, 1)
					If $sString = "|" Then $aObjectpoints = StringTrimRight($aObjectpoints, 1)
					Local $tempObbjs = StringSplit($aObjectpoints, "|", $STR_NOCOUNT) ; several detected points
					For $j = 0 To UBound($tempObbjs) - 1
						; Test the coordinates
						Local $tempObbj = StringSplit($tempObbjs[$j], ",", $STR_NOCOUNT) ;  will be a string : 708,360
						If UBound($tempObbj) = 2 Then
							$g_aiBuilderHallPos[0] = Number($tempObbj[0]) + 9
							$g_aiBuilderHallPos[1] = Number($tempObbj[1]) + 15
							SetLog("Builder Hall :" & $g_aiBuilderHallPos[0] & "," & $g_aiBuilderHallPos[1])
							ConvertFromVillagePos($g_aiBuilderHallPos[0],$g_aiBuilderHallPos[1])
							SetLog("Builder Hall VillagePos:" & $g_aiBuilderHallPos[0] & "," & $g_aiBuilderHallPos[1])
							ExitLoop 3
						EndIf
					Next
				Else
					; Test the coordinate
					Local $tempObbj = StringSplit($aObjectpoints, ",", $STR_NOCOUNT) ;  will be a string : 708,360
					If UBound($tempObbj) = 2 Then
						$g_aiBuilderHallPos[0] = Number($tempObbj[0]) + 9
						$g_aiBuilderHallPos[1] = Number($tempObbj[1]) + 15
						SetLog("Builder Hall :" & $g_aiBuilderHallPos[0] & "," & $g_aiBuilderHallPos[1])
						ConvertFromVillagePos($g_aiBuilderHallPos[0],$g_aiBuilderHallPos[1])
						SetLog("Builder Hall VillagePos:" & $g_aiBuilderHallPos[0] & "," & $g_aiBuilderHallPos[1])
						ExitLoop 2
					EndIf
				EndIf
			Next
		EndIf

		If _Sleep(500) Then Return
	Next

	If $g_aiBuilderHallPos[0] > 0 And $g_aiBuilderHallPos[1] > 0 Then
		BuildingClickP($g_aiBuilderHallPos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(242, 468 + $g_iBottomOffsetY) ; Get building name and level with OCR
		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "Builder") = True Then ; we found the Clan Castle
				SetLog("Builder Hall located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)

				If $aResult[2] > $g_iBuilderHallLevel Then $g_iBuilderHallLevel = $aResult[2]
				;ChkCraftCapitalGold()
				Return True
			Else
				ClickAway()
				SetDebugLog("Found Builder Hall Position is not valid.", $COLOR_ERROR)
				SetDebugLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				SetDebugLog("Village position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
				ConvertToVillagePos($g_aiBuilderHallPos[0],$g_aiBuilderHallPos[1])
				SetDebugLog("Real position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
				$g_aiBuilderHallPos[0] = -1
				$g_aiBuilderHallPos[1] = -1

			EndIf
		Else
			ClickAway()
			SetDebugLog("Found Builder Hall Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiBuilderHallPos[0],$g_aiBuilderHallPos[1])
			SetDebugLog("Real position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
			$g_aiBuilderHallPos[0] = -1
			$g_aiBuilderHallPos[1] = -1
		EndIf
	EndIf

	SetLog("Can not find Builder Hall.", $COLOR_ERROR)
	Return False
EndFunc   ;==>LocateBuilderHall()

Func LocateDoubleCannon($bCollect = False)
	Local $wasRunState = $g_bRunState
	$g_bRunState = True

	AndroidShield("LocateDoubleCannon 1") ; Update shield status due to manual $g_bRunState
	Local $Result = _LocateDoubleCannon($bCollect)

	$g_bRunState = $wasRunState
	AndroidShield("LocateDoubleCannon 2") ; Update shield status due to manual $g_bRunState
	Return $Result
EndFunc   ;==>LocateDoubleCannon

Func _LocateDoubleCannon($bCollect = False)

	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo, $aDoubleCannonLevel=0

	WinGetAndroidHandle()

	Local $bIsOnBuilderBase = isOnBuilderBase(True)
	If $bIsOnBuilderBase Then
		SetLog("You are on Builder Base!")
	Else
		SwitchBetweenBases(False, True)
	EndIf

	ZoomOut()

	SetLog("Saved Coord :" & $g_aiDoubleCannonPos[0] & ", " & $g_aiDoubleCannonPos[1], $COLOR_INFO)

	If $g_aiDoubleCannonPos[0] <> -1 And $g_aiDoubleCannonPos[1] <> -1 Then
		ClickAway()

		If $g_aiDoubleCannonPos[2] = 1 Then
			If Not SwitchToOttoVillage() Then Return False
		EndIf

		If _Sleep($DELAYUPGRADEHERO2) Then Return
		BuildingClickP($g_aiDoubleCannonPos) ;Click DoubleCannon Altar
		If _Sleep($DELAYUPGRADEHERO2) Then Return

		;Get Double Cannon info and Level
		Local $sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)

		If @error Then SetError(0, 0, 0)

		If IsArray($sInfo) Then
			If $g_bDebugSetlog Then SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
			If @error Then Return SetError(0, 0, 0)
			If $sInfo[0] > 1 Or $sInfo[0] = "" Then
				If StringInStr($sInfo[1], "uble") = 0 Then
					SetLog("Bad Double Cannon location", $COLOR_ACTION)
				Else
					If $sInfo[2] <> "" Then
						$aDoubleCannonLevel = Number($sInfo[2]) ; grab level from building info array
						SetLog("Double Cannon level read as: " & $aDoubleCannonLevel, $COLOR_SUCCESS)
						If $aDoubleCannonLevel >= 4 Then ; BOB Control Requirement
							SetLog("Double Cannon is at level needed for BOB Control upgrade!", $COLOR_INFO)
							$g_bDoubleCannonUpgrade = False ; turn Off the Double Cannon upgrade
							GUICtrlSetState($g_hChkDoubleCannonUpgrade, $GUI_UNCHECKED)
						EndIf
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return True
					Else
						SetLog("Double Cannon Level was not found!", $COLOR_INFO)
					EndIf
				EndIf
			Else
				SetLog("Bad Double Cannon OCR", $COLOR_ERROR)
			EndIf
		EndIf
	EndIf

	If $bCollect Then CollectBuilderBase()

	SetLog("Locating Double Cannon", $COLOR_INFO)

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_DoubleCannonVillage_01", "Select Village where is choosen Double Cannon") & @CRLF
	$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Main_Otto", "Main|Otto"), GetTranslatedFileIni("MBR Popups", "Func_Locate_DoubleCannonVillage_02", "Select Village"), $stext, 20)
	If $MsgBox = 1 Then
		WinGetAndroidHandle()
		ClickAway()
		$g_aiDoubleCannonPos[2] = 0
	ElseIf $MsgBox = 2 Then
		WinGetAndroidHandle()
		ClickAway()
		If Not SwitchToOttoVillage() Then Return
		$g_aiDoubleCannonPos[2] = 1
	EndIf

	If $g_aiDoubleCannonPos[2] = -1 Then
		SetLog("Hey, Wake up !", $COLOR_ERROR)
		$g_aiDoubleCannonPos[0] = -1
		$g_aiDoubleCannonPos[1] = -1
		$g_aiDoubleCannonPos[2] = -1
		$g_bDoubleCannonUpgrade = False ; turn Off the Double Cannon upgrade
		GUICtrlSetState($g_hChkDoubleCannonUpgrade, $GUI_UNCHECKED)
		SwitchToBuilderbase()
		Return False
	EndIf

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_DoubleCannon_01", "Click OK then click on Double Cannon") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_DoubleCannon_02", "Locate Double Cannon"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClickAway()
			Local $aPos = FindPos()
			$g_aiDoubleCannonPos[0] = $aPos[0]
			$g_aiDoubleCannonPos[1] = $aPos[1]
			If Not isInsideDiamond($g_aiDoubleCannonPos) Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Double Cannon Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_ERROR)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $g_aiDoubleCannonPos[0] & "," & $g_aiDoubleCannonPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Double Cannon Location: " & "(" & $g_aiDoubleCannonPos[0] & "," & $g_aiDoubleCannonPos[1] & ")", $COLOR_ERROR)
						$g_bDoubleCannonUpgrade = False ; turn Off the Double Cannon upgrade
						GUICtrlSetState($g_hChkDoubleCannonUpgrade, $GUI_UNCHECKED)
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return False
					Case Else
						SetLog(" Operator Error - Bad Double Cannon Location: " & "(" & $g_aiDoubleCannonPos[0] & "," & $g_aiDoubleCannonPos[1] & ")", $COLOR_ERROR)
						$g_aiDoubleCannonPos[0] = -1
						$g_aiDoubleCannonPos[1] = -1
						$g_aiDoubleCannonPos[2] = -1
						$g_bDoubleCannonUpgrade = False ; turn Off the Double Cannon upgrade
						GUICtrlSetState($g_hChkDoubleCannonUpgrade, $GUI_UNCHECKED)
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return False
				EndSelect
			EndIf
			SetLog("Double Cannon: " & "(" & $g_aiDoubleCannonPos[0] & "," & $g_aiDoubleCannonPos[1] & ")", $COLOR_SUCCESS)
			If $g_aiDoubleCannonPos[2] = 0 Then
				SetLog("Double Cannon is in Main Builder Base", $COLOR_SUCCESS)
			Else
				SetLog("Double Cannon is in Otto Village", $COLOR_SUCCESS)
			EndIf
		Else
			$g_bDoubleCannonUpgrade = False ; turn Off the Double Cannon upgrade
			GUICtrlSetState($g_hChkDoubleCannonUpgrade, $GUI_UNCHECKED)
			SetLog("Locate Double Cannon Cancelled", $COLOR_INFO)
			ClickAway()
			If _Sleep(1000) Then Return
			SwitchToBuilderbase()
			Return
		EndIf

		;get Double Cannon info
		$sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY); 860x780
		If @error Then SetError(0, 0, 0)
		Local $CountGetInfo = 0
		While Not IsArray($sInfo)
			$sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY); 860x780
			If @error Then SetError(0, 0, 0)
			Sleep(100)
			$CountGetInfo += 1
			If $CountGetInfo = 50 Then Return
		WEnd
		SetDebugLog($sInfo[1] & $sInfo[2])
		If @error Then Return SetError(0, 0, 0)

		If $sInfo[0] > 1 Or $sInfo[0] = "" Then
			If @error Then Return SetError(0, 0, 0)

			If StringInStr($sInfo[1], "uble") = 0 Then
				Local $sLocMsg = ($sInfo[0] = "" ? "Nothing" : $sInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Double Cannon?, It was a " & $sLocMsg & @CRLF
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
						SetLog("Quit joking, Click the Double Cannon, or restart bot and try again", $COLOR_ERROR)
						$g_aiDoubleCannonPos[0] = -1
						$g_aiDoubleCannonPos[1] = -1
						$g_aiDoubleCannonPos[2] = -1
						$g_bDoubleCannonUpgrade = False ; turn Off the Double Cannon upgrade
						GUICtrlSetState($g_hChkDoubleCannonUpgrade, $GUI_UNCHECKED)
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return False
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad Double Cannon Location: " & "(" & $g_aiDoubleCannonPos[0] & "," & $g_aiDoubleCannonPos[1] & ")", $COLOR_ERROR)
			$g_aiDoubleCannonPos[0] = -1
			$g_aiDoubleCannonPos[1] = -1
			$g_aiDoubleCannonPos[2] = -1
			$g_bDoubleCannonUpgrade = False ; turn Off the Double Cannon upgrade
			GUICtrlSetState($g_hChkDoubleCannonUpgrade, $GUI_UNCHECKED)
			ClickAway()
			If _Sleep(1000) Then Return
			SwitchToBuilderbase()
			Return False
		EndIf
		ExitLoop
	WEnd

	ClickAway()
	If _Sleep(1000) Then Return

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = GetTranslatedFileIni("MBR Popups", "Locate_building_03", "Now you can remove mouse out of Android Emulator, Thanks!!")
	$MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), GetTranslatedFileIni("MBR Popups", "Locate_building_04", "Notice!"), $stext, 15)

	IniWrite($g_sProfileBuildingPath, "other", "DoubleCannonPosX", $g_aiDoubleCannonPos[0])
	IniWrite($g_sProfileBuildingPath, "other", "DoubleCannonPosY", $g_aiDoubleCannonPos[1])
	IniWrite($g_sProfileBuildingPath, "other", "DoubleCannonPosV", $g_aiDoubleCannonPos[2])
	SwitchToBuilderbase()
EndFunc   ;==>_LocateDoubleCannon

Func LocateArcherTower($bCollect = False)
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	AndroidShield("LocateArcherTower 1") ; Update shield status due to manual $g_bRunState
	Local $Result = _LocateArcherTower($bCollect)
	$g_bRunState = $wasRunState
	AndroidShield("LocateArcherTower 2") ; Update shield status due to manual $g_bRunState
	Return $Result
EndFunc   ;==>LocateArcherTower

Func _LocateArcherTower($bCollect = False)

	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo, $iArcherTowerLevel=0

	WinGetAndroidHandle()
	;checkMainScreen(False)

	Local $bIsOnBuilderBase = isOnBuilderBase(True)
	If $bIsOnBuilderBase Then
		SetLog("You are on Builder Base!")
	Else
		SwitchBetweenBases(False, True)
	EndIf

	ZoomOut()

	SetLog("Saved Coord :" & $g_aiArcherTowerPos[0] & ", " & $g_aiArcherTowerPos[1], $COLOR_INFO)

	If $g_aiArcherTowerPos[0] <> -1 And $g_aiArcherTowerPos[1] <> -1 Then
		ClickAway()

		If $g_aiArcherTowerPos[2] = 1 Then
			If Not SwitchToOttoVillage() Then Return False
		EndIf

		If _Sleep($DELAYUPGRADEHERO2) Then Return
		BuildingClickP($g_aiArcherTowerPos) ;Click ArcherTower Altar
		If _Sleep($DELAYUPGRADEHERO2) Then Return

		;Get Archer Tower info and Level
		Local $sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)

		If @error Then SetError(0, 0, 0)

		If IsArray($sInfo) Then
			If $g_bDebugSetlog Then SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
			If @error Then Return SetError(0, 0, 0)
			If $sInfo[0] > 1 Or $sInfo[0] = "" Then
				If StringInStr($sInfo[1], "Archer") = 0 Then
					SetLog("Bad Archer Tower location", $COLOR_ACTION)
				Else
					If $sInfo[2] <> "" Then
						$iArcherTowerLevel = Number($sInfo[2]) ; grab level from building info array
						SetLog("Archer Tower level read as: " & $iArcherTowerLevel, $COLOR_SUCCESS)
						If $iArcherTowerLevel >= 6 Then ; BOB Control Requirement
							SetLog("Archer Tower is at level needed for BOB Control upgrade!", $COLOR_INFO)
							$g_bArcherTowerUpgrade = False ; turn Off the Archer Tower upgrade
							GUICtrlSetState($g_hChkArcherTowerUpgrade, $GUI_UNCHECKED)
						EndIf
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return True
					Else
						SetLog("Archer Tower Level was not found!", $COLOR_INFO)
					EndIf
				EndIf
			Else
				SetLog("Bad Archer Tower OCR", $COLOR_ERROR)
			EndIf
		EndIf
	EndIf

	If $bCollect Then CollectBuilderBase()

	SetLog("Locating Archer Tower", $COLOR_INFO)

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_ArcherTowerVillage_01", "Select Village where is choosen Archer Tower") & @CRLF
	$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Main_Otto", "Main|Otto"), GetTranslatedFileIni("MBR Popups", "Func_Locate_ArcherTowerVillage_02", "Select Village"), $stext, 20)
	If $MsgBox = 1 Then
		WinGetAndroidHandle()
		ClickAway()
		$g_aiArcherTowerPos[2] = 0
	ElseIf $MsgBox = 2 Then
		WinGetAndroidHandle()
		ClickAway()
		If Not SwitchToOttoVillage() Then Return
		$g_aiArcherTowerPos[2] = 1
	EndIf

	If $g_aiArcherTowerPos[2] = -1 Then
		SetLog("Hey, Wake up !", $COLOR_ERROR)
		$g_aiArcherTowerPos[0] = -1
		$g_aiArcherTowerPos[1] = -1
		$g_aiArcherTowerPos[2] = -1
		$g_bArcherTowerUpgrade = False ; turn Off the Double Cannon upgrade
		GUICtrlSetState($g_hChkArcherTowerUpgrade, $GUI_UNCHECKED)
		SwitchToBuilderbase()
		Return False
	EndIf

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_ArcherTower_01", "Click OK then click on Archer Tower") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_ArcherTower_02", "Locate Archer Tower"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClickAway()
			Local $aPos = FindPos()
			$g_aiArcherTowerPos[0] = $aPos[0]
			$g_aiArcherTowerPos[1] = $aPos[1]
			If Not isInsideDiamond($g_aiArcherTowerPos) Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = " Archer Tower Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_ERROR)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $g_aiArcherTowerPos[0] & "," & $g_aiArcherTowerPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad  Archer Tower Location: " & "(" & $g_aiArcherTowerPos[0] & "," & $g_aiArcherTowerPos[1] & ")", $COLOR_ERROR)
						$g_bArcherTowerUpgrade = False ; turn Off the Archer Tower upgrade
						GUICtrlSetState($g_hChkArcherTowerUpgrade, $GUI_UNCHECKED)
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return False
					Case Else
						SetLog(" Operator Error - Bad  Archer Tower Location: " & "(" & $g_aiArcherTowerPos[0] & "," & $g_aiArcherTowerPos[1] & ")", $COLOR_ERROR)
						$g_aiArcherTowerPos[0] = -1
						$g_aiArcherTowerPos[1] = -1
						$g_aiArcherTowerPos[2] = -1
						$g_bArcherTowerUpgrade = False ; turn Off the Archer Tower upgrade
						GUICtrlSetState($g_hChkArcherTowerUpgrade, $GUI_UNCHECKED)
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return False
				EndSelect
			EndIf
			SetLog("Archer Tower: " & "(" & $g_aiArcherTowerPos[0] & "," & $g_aiArcherTowerPos[1] & ")", $COLOR_SUCCESS)
			If $g_aiArcherTowerPos[2] = 0 Then
				SetLog("Archer Tower is in Main Builder Base", $COLOR_SUCCESS)
			Else
				SetLog("Archer Tower is in Otto Village", $COLOR_SUCCESS)
			EndIf
		Else
			$g_bArcherTowerUpgrade = False ; turn Off the Archer Tower upgrade
			GUICtrlSetState($g_hChkArcherTowerUpgrade, $GUI_UNCHECKED)
			SetLog("Locate Archer Tower Cancelled", $COLOR_INFO)
			ClickAway()
			If _Sleep(1000) Then Return
			SwitchToBuilderbase()
			Return
		EndIf

		;get  Archer Tower info
		$sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY); 860x780
		If @error Then SetError(0, 0, 0)
		Local $CountGetInfo = 0
		While Not IsArray($sInfo)
			$sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY); 860x780
			If @error Then SetError(0, 0, 0)
			Sleep(100)
			$CountGetInfo += 1
			If $CountGetInfo = 50 Then Return
		WEnd
		SetDebugLog($sInfo[1] & $sInfo[2])
		If @error Then Return SetError(0, 0, 0)

		If $sInfo[0] > 1 Or $sInfo[0] = "" Then
			If @error Then Return SetError(0, 0, 0)

			If StringInStr($sInfo[1], "Archer") = 0 Then
				Local $sLocMsg = ($sInfo[0] = "" ? "Nothing" : $sInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the  Archer Tower?, It was a " & $sLocMsg & @CRLF
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
						SetLog("Quit joking, Click the  Archer Tower, or restart bot and try again", $COLOR_ERROR)
						$g_aiArcherTowerPos[0] = -1
						$g_aiArcherTowerPos[1] = -1
						$g_aiArcherTowerPos[2] = -1
						$g_bArcherTowerUpgrade = False ; turn Off the Archer Tower upgrade
						GUICtrlSetState($g_hChkArcherTowerUpgrade, $GUI_UNCHECKED)
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return False
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad  Archer Tower Location: " & "(" & $g_aiArcherTowerPos[0] & "," & $g_aiArcherTowerPos[1] & ")", $COLOR_ERROR)
			$g_aiArcherTowerPos[0] = -1
			$g_aiArcherTowerPos[1] = -1
			$g_aiArcherTowerPos[2] = -1
			$g_bArcherTowerUpgrade = False ; turn Off the Archer Tower upgrade
			GUICtrlSetState($g_hChkArcherTowerUpgrade, $GUI_UNCHECKED)
			ClickAway()
			If _Sleep(1000) Then Return
			SwitchToBuilderbase()
			Return False
		EndIf
		ExitLoop
	WEnd

	ClickAway()
	If _Sleep(1000) Then Return

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = GetTranslatedFileIni("MBR Popups", "Locate_building_03", "Now you can remove mouse out of Android Emulator, Thanks!!")
	$MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), GetTranslatedFileIni("MBR Popups", "Locate_building_04", "Notice!"), $stext, 15)

	IniWrite($g_sProfileBuildingPath, "other", "ArcherTowerPosX", $g_aiArcherTowerPos[0])
	IniWrite($g_sProfileBuildingPath, "other", "ArcherTowerPosY", $g_aiArcherTowerPos[1])
	IniWrite($g_sProfileBuildingPath, "other", "ArcherTowerPosV", $g_aiArcherTowerPos[2])
	SwitchToBuilderbase()
EndFunc   ;==>_LocateArcherTower


Func LocateMultiMortar($bCollect = False)
	Local $wasRunState = $g_bRunState
	$g_bRunState = True

	AndroidShield("LocateMultiMortar 1") ; Update shield status due to manual $g_bRunState
	Local $Result = _LocateMultiMortar($bCollect)

	$g_bRunState = $wasRunState
	AndroidShield("LocateMultiMortar 2") ; Update shield status due to manual $g_bRunState
	Return $Result
EndFunc   ;==>LocateMultiMortar

Func _LocateMultiMortar($bCollect = False)

	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo, $aMultiMortarLevel=0

	WinGetAndroidHandle()

	Local $bIsOnBuilderBase = isOnBuilderBase(True)
	If $bIsOnBuilderBase Then
		SetLog("You are on Builder Base!")
	Else
		SwitchBetweenBases(False, True)
	EndIf

	ZoomOut()

	SetLog("Saved Coord :" & $g_aiMultiMortarPos[0] & ", " & $g_aiMultiMortarPos[1], $COLOR_INFO)

	If $g_aiMultiMortarPos[0] <> -1 And $g_aiMultiMortarPos[1] <> -1 Then
		ClickAway()

		If $g_aiMultiMortarPos[2] = 1 Then
			If Not SwitchToOttoVillage() Then Return False
		EndIf

		If _Sleep($DELAYUPGRADEHERO2) Then Return
		BuildingClickP($g_aiMultiMortarPos) ;Click MultiMortar Altar
		If _Sleep($DELAYUPGRADEHERO2) Then Return

		;Get Multi Mortar info and Level
		Local $sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)

		If @error Then SetError(0, 0, 0)

		If IsArray($sInfo) Then
			If $g_bDebugSetlog Then SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
			If @error Then Return SetError(0, 0, 0)
			If $sInfo[0] > 1 Or $sInfo[0] = "" Then
				If StringInStr($sInfo[1], "Multi") = 0 Then
					SetLog("Bad Multi Mortar location", $COLOR_ACTION)
				Else
					If $sInfo[2] <> "" Then
						$aMultiMortarLevel = Number($sInfo[2]) ; grab level from building info array
						SetLog("Multi Mortar level read as: " & $aMultiMortarLevel, $COLOR_SUCCESS)
						If $aMultiMortarLevel >= 8 Then ; BOB Control Requirement
							SetLog("Multi Mortar is at level needed for BOB Control upgrade!", $COLOR_INFO)
							$g_bMultiMortarUpgrade = False ; turn Off the Multi Mortar upgrade
							GUICtrlSetState($g_hChkMultiMortarUpgrade, $GUI_UNCHECKED)
						EndIf
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return True
					Else
						SetLog("Multi Mortar Level was not found!", $COLOR_INFO)
					EndIf
				EndIf
			Else
				SetLog("Bad Multi Mortar OCR", $COLOR_ERROR)
			EndIf
		EndIf
	EndIf

	If $bCollect Then CollectBuilderBase()

	SetLog("Locating Multi Mortar", $COLOR_INFO)

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_MultiMortarVillage_01", "Select Village where is choosen Multi Mortar") & @CRLF
	$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Main_Otto", "Main|Otto"), GetTranslatedFileIni("MBR Popups", "Func_Locate_MultiMortarVillage_02", "Select Village"), $stext, 20)
	If $MsgBox = 1 Then
		WinGetAndroidHandle()
		ClickAway()
		$g_aiMultiMortarPos[2] = 0
	ElseIf $MsgBox = 2 Then
		WinGetAndroidHandle()
		ClickAway()
		If Not SwitchToOttoVillage() Then Return
		$g_aiMultiMortarPos[2] = 1
	EndIf

	If $g_aiMultiMortarPos[2] = -1 Then
		SetLog("Hey, Wake up !", $COLOR_ERROR)
		$g_aiMultiMortarPos[0] = -1
		$g_aiMultiMortarPos[1] = -1
		$g_aiMultiMortarPos[2] = -1
		$g_bMultiMortarUpgrade = False ; turn Off the Double Cannon upgrade
		GUICtrlSetState($g_hChkMultiMortarUpgrade, $GUI_UNCHECKED)
		SwitchToBuilderbase()
		Return False
	EndIf

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_MultiMortar_01", "Click OK then click on Multi Mortar") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_MultiMortar_02", "Locate Multi Mortar"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClickAway()
			Local $aPos = FindPos()
			$g_aiMultiMortarPos[0] = $aPos[0]
			$g_aiMultiMortarPos[1] = $aPos[1]
			If Not isInsideDiamond($g_aiMultiMortarPos) Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Multi Mortar Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_ERROR)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $g_aiMultiMortarPos[0] & "," & $g_aiMultiMortarPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Multi Mortar Location: " & "(" & $g_aiMultiMortarPos[0] & "," & $g_aiMultiMortarPos[1] & ")", $COLOR_ERROR)
						$g_bMultiMortarUpgrade = False ; turn Off the Multi Mortar upgrade
						GUICtrlSetState($g_hChkMultiMortarUpgrade, $GUI_UNCHECKED)
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return False
					Case Else
						SetLog(" Operator Error - Bad Multi Mortar Location: " & "(" & $g_aiMultiMortarPos[0] & "," & $g_aiMultiMortarPos[1] & ")", $COLOR_ERROR)
						$g_aiMultiMortarPos[0] = -1
						$g_aiMultiMortarPos[1] = -1
						$g_aiMultiMortarPos[2] = -1
						$g_bMultiMortarUpgrade = False ; turn Off the Multi Mortar upgrade
						GUICtrlSetState($g_hChkMultiMortarUpgrade, $GUI_UNCHECKED)
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return False
				EndSelect
			EndIf
			SetLog("Multi Mortar: " & "(" & $g_aiMultiMortarPos[0] & "," & $g_aiMultiMortarPos[1] & ")", $COLOR_SUCCESS)
			If $g_aiMultiMortarPos[2] = 0 Then
				SetLog("Multi Mortar is in Main Builder Base", $COLOR_SUCCESS)
			Else
				SetLog("Multi Mortar is in Otto Village", $COLOR_SUCCESS)
			EndIf
		Else
			SetLog("Locate Multi Mortar Cancelled", $COLOR_INFO)
			$g_bMultiMortarUpgrade = False ; turn Off the Multi Mortar upgrade
			GUICtrlSetState($g_hChkMultiMortarUpgrade, $GUI_UNCHECKED)
			ClickAway()
			If _Sleep(1000) Then Return
			SwitchToBuilderbase()
			Return
		EndIf

		;get Multi Mortar info
		$sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY); 860x780
		If @error Then SetError(0, 0, 0)
		Local $CountGetInfo = 0
		While Not IsArray($sInfo)
			$sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY); 860x780
			If @error Then SetError(0, 0, 0)
			Sleep(100)
			$CountGetInfo += 1
			If $CountGetInfo = 50 Then Return
		WEnd
		SetDebugLog($sInfo[1] & $sInfo[2])
		If @error Then Return SetError(0, 0, 0)

		If $sInfo[0] > 1 Or $sInfo[0] = "" Then
			If @error Then Return SetError(0, 0, 0)

			If StringInStr($sInfo[1], "Multi") = 0 Then
				Local $sLocMsg = ($sInfo[0] = "" ? "Nothing" : $sInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Multi Mortar?, It was a " & $sLocMsg & @CRLF
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
						SetLog("Quit joking, Click the Multi Mortar, or restart bot and try again", $COLOR_ERROR)
						$g_aiMultiMortarPos[0] = -1
						$g_aiMultiMortarPos[1] = -1
						$g_aiMultiMortarPos[2] = -1
						$g_bMultiMortarUpgrade = False ; turn Off the Multi Mortar upgrade
						GUICtrlSetState($g_hChkMultiMortarUpgrade, $GUI_UNCHECKED)
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return False
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad Multi Mortar Location: " & "(" & $g_aiMultiMortarPos[0] & "," & $g_aiMultiMortarPos[1] & ")", $COLOR_ERROR)
			$g_aiMultiMortarPos[0] = -1
			$g_aiMultiMortarPos[1] = -1
			$g_aiMultiMortarPos[2] = -1
			$g_bMultiMortarUpgrade = False ; turn Off the Multi Mortar upgrade
			GUICtrlSetState($g_hChkMultiMortarUpgrade, $GUI_UNCHECKED)
			ClickAway()
			If _Sleep(1000) Then Return
			SwitchToBuilderbase()
			Return False
		EndIf
		ExitLoop
	WEnd

	ClickAway()
	If _Sleep(1000) Then Return

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = GetTranslatedFileIni("MBR Popups", "Locate_building_03", "Now you can remove mouse out of Android Emulator, Thanks!!")
	$MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), GetTranslatedFileIni("MBR Popups", "Locate_building_04", "Notice!"), $stext, 15)

	IniWrite($g_sProfileBuildingPath, "other", "MultiMortarPosX", $g_aiMultiMortarPos[0])
	IniWrite($g_sProfileBuildingPath, "other", "MultiMortarPosY", $g_aiMultiMortarPos[1])
	IniWrite($g_sProfileBuildingPath, "other", "MultiMortarPosV", $g_aiMultiMortarPos[2])
	SwitchToBuilderbase()
EndFunc   ;==>_LocateMultiMortar

Func LocateAnyDef($bCollect = False)
	Local $wasRunState = $g_bRunState
	$g_bRunState = True

	AndroidShield("LocateAnyDef 1") ; Update shield status due to manual $g_bRunState
	Local $Result = _LocateAnyDef($bCollect)

	$g_bRunState = $wasRunState
	AndroidShield("LocateAnyDef 2") ; Update shield status due to manual $g_bRunState
	Return $Result
EndFunc   ;==>LocateMultiMortar

Func _LocateAnyDef($bCollect = False)

	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo, $aCannonLevel=0

	WinGetAndroidHandle()

	Local $bIsOnBuilderBase = isOnBuilderBase(True)
	If $bIsOnBuilderBase Then
		SetLog("You are on Builder Base!")
	Else
		SwitchBetweenBases(False, True)
	EndIf

	ZoomOut()

	SetLog("Saved Coord :" & $g_aiAnyDefPos[0] & ", " & $g_aiAnyDefPos[1], $COLOR_INFO)

	If $g_aiAnyDefPos[0] <> -1 And $g_aiAnyDefPos[1] <> -1 Then
		ClickAway()

		If $g_aiAnyDefPos[2] = 1 Then
			If Not SwitchToOttoVillage() Then Return False
		EndIf

		If _Sleep($DELAYUPGRADEHERO2) Then Return
		BuildingClickP($g_aiAnyDefPos) ;Click AnyDef Altar
		If _Sleep($DELAYUPGRADEHERO2) Then Return

		;Get Multi Mortar info and Level
		Local $sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)

		If @error Then SetError(0, 0, 0)

		If IsArray($sInfo) Then
			If $g_bDebugSetlog Then SetDebugLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
			If @error Then Return SetError(0, 0, 0)
			If $sInfo[0] > 1 Or $sInfo[0] = "" Then
				If StringInStr($sInfo[1], "Cann") = 0 Or StringInStr($sInfo[1], "uble") <> 0 Then
					SetLog("Bad Cannon location", $COLOR_ACTION)
				Else
					If $sInfo[2] <> "" Then
						$aCannonLevel = Number($sInfo[2]) ; grab level from building info array
						SetLog("Cannon level read as: " & $aCannonLevel, $COLOR_SUCCESS)
						If $aCannonLevel >= 9 Then ; BOB Control Requirement
							SetLog("Cannon is at level needed for BOB Control upgrade!", $COLOR_INFO)
							$g_bAnyDefUpgrade = False ; turn Off the Multi Mortar upgrade
							GUICtrlSetState($g_hChkAnyDefUpgrade, $GUI_UNCHECKED)
						EndIf
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return True
					Else
						SetLog("Cannon Level was not found!", $COLOR_INFO)
					EndIf
				EndIf
			Else
				SetLog("Bad Cannon OCR", $COLOR_ERROR)
			EndIf
		EndIf
	EndIf

	If $bCollect Then CollectBuilderBase()

	SetLog("Locating Cannon", $COLOR_INFO)

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_AnyDefVillage_01", "Select Village where is choosen Cannon") & @CRLF
	$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Main_Otto", "Main|Otto"), GetTranslatedFileIni("MBR Popups", "Func_Locate_AnyDefVillage_02", "Select Village"), $stext, 20)
	If $MsgBox = 1 Then
		WinGetAndroidHandle()
		ClickAway()
		$g_aiAnyDefPos[2] = 0
	ElseIf $MsgBox = 2 Then
		WinGetAndroidHandle()
		ClickAway()
		If Not SwitchToOttoVillage() Then Return
		$g_aiAnyDefPos[2] = 1
	EndIf

	If $g_aiAnyDefPos[2] = -1 Then
		SetLog("Hey, Wake up !", $COLOR_ERROR)
		$g_aiAnyDefPos[0] = -1
		$g_aiAnyDefPos[1] = -1
		$g_aiAnyDefPos[2] = -1
		$g_bDoubleCannonUpgrade = False ; turn Off the Double Cannon upgrade
		GUICtrlSetState($g_hChkAnyDefUpgrade, $GUI_UNCHECKED)
		SwitchToBuilderbase()
		Return False
	EndIf

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_AnyDef_01", "Click OK then click on Cannon") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_AnyDef_02", "Locate Cannon"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClickAway()
			Local $aPos = FindPos()
			$g_aiAnyDefPos[0] = $aPos[0]
			$g_aiAnyDefPos[1] = $aPos[1]
			If Not isInsideDiamond($g_aiAnyDefPos) Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Cannon Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_ERROR)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $g_aiAnyDefPos[0] & "," & $g_aiAnyDefPos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Cannon Location: " & "(" & $g_aiAnyDefPos[0] & "," & $g_aiAnyDefPos[1] & ")", $COLOR_ERROR)
						$g_bAnyDefUpgrade = False ; turn Off the Cannon upgrade
						GUICtrlSetState($g_hChkAnyDefUpgrade, $GUI_UNCHECKED)
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return False
					Case Else
						SetLog(" Operator Error - Bad Cannon Location: " & "(" & $g_aiAnyDefPos[0] & "," & $g_aiAnyDefPos[1] & ")", $COLOR_ERROR)
						$g_aiAnyDefPos[0] = -1
						$g_aiAnyDefPos[1] = -1
						$g_aiAnyDefPos[2] = -1
						$g_bAnyDefUpgrade = False ; turn Off the Cannon upgrade
						GUICtrlSetState($g_hChkAnyDefUpgrade, $GUI_UNCHECKED)
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return False
				EndSelect
			EndIf
			SetLog("Cannon: " & "(" & $g_aiAnyDefPos[0] & "," & $g_aiAnyDefPos[1] & ")", $COLOR_SUCCESS)
		Else
			SetLog("Locate Cannon Cancelled", $COLOR_INFO)
			$g_bAnyDefUpgrade = False ; turn Off the Cannon upgrade
			GUICtrlSetState($g_hChkAnyDefUpgrade, $GUI_UNCHECKED)
			ClickAway()
			If _Sleep(1000) Then Return
			SwitchToBuilderbase()
			Return
		EndIf

		;get Cannon info
		$sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY); 860x780
		If @error Then SetError(0, 0, 0)
		Local $CountGetInfo = 0
		While Not IsArray($sInfo)
			$sInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY); 860x780
			If @error Then SetError(0, 0, 0)
			Sleep(100)
			$CountGetInfo += 1
			If $CountGetInfo = 50 Then Return
		WEnd
		SetDebugLog($sInfo[1] & $sInfo[2])
		If @error Then Return SetError(0, 0, 0)

		If $sInfo[0] > 1 Or $sInfo[0] = "" Then
			If @error Then Return SetError(0, 0, 0)

			If StringInStr($sInfo[1], "Cann") = 0 Or StringInStr($sInfo[1], "uble") <> 0 Then
				Local $sLocMsg = ($sInfo[0] = "" ? "Nothing" : $sInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Cannon?, It was a " & $sLocMsg & @CRLF
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
						SetLog("Quit joking, Click the Cannon, or restart bot and try again", $COLOR_ERROR)
						$g_aiAnyDefPos[0] = -1
						$g_aiAnyDefPos[1] = -1
						$g_aiAnyDefPos[1] = -1
						$g_bAnyDefUpgrade = False ; turn Off the Cannon upgrade
						GUICtrlSetState($g_hChkAnyDefUpgrade, $GUI_UNCHECKED)
						ClickAway()
						If _Sleep(1000) Then Return
						SwitchToBuilderbase()
						Return False
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad Cannon Location: " & "(" & $g_aiAnyDefPos[0] & "," & $g_aiAnyDefPos[1] & ")", $COLOR_ERROR)
			$g_aiAnyDefPos[0] = -1
			$g_aiAnyDefPos[1] = -1
			$g_aiAnyDefPos[1] = -1
			$g_bAnyDefUpgrade = False ; turn Off the Cannon upgrade
			GUICtrlSetState($g_hChkAnyDefUpgrade, $GUI_UNCHECKED)
			ClickAway()
			If _Sleep(1000) Then Return
			SwitchToBuilderbase()
			Return False
		EndIf
		ExitLoop
	WEnd

	ClickAway()
	If _Sleep(1000) Then Return

	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$stext = GetTranslatedFileIni("MBR Popups", "Locate_building_03", "Now you can remove mouse out of Android Emulator, Thanks!!")
	$MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), GetTranslatedFileIni("MBR Popups", "Locate_building_04", "Notice!"), $stext, 15)

	IniWrite($g_sProfileBuildingPath, "other", "AnyDefPosX", $g_aiAnyDefPos[0])
	IniWrite($g_sProfileBuildingPath, "other", "AnyDefPosY", $g_aiAnyDefPos[1])
	IniWrite($g_sProfileBuildingPath, "other", "AnyDefPosV", $g_aiAnyDefPos[2])
	SwitchToBuilderbase()
EndFunc   ;==>_LocateAnyDef