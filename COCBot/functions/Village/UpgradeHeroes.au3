; #FUNCTION# ====================================================================================================================
;
; ===============================================================================================================================
Func UpgradeHeroes()
	If $ichkUpgradeKing = 0 And $ichkUpgradeQueen = 0 Then Return
	
	SetLog("Upgrade Heroes", $COLOR_BLUE)
	
	Local $aGetBuilders = StringSplit(getBuilders($aBuildersDigits[0], $aBuildersDigits[1]), "#", $STR_NOCOUNT)
		$FreeBuilder = $aGetBuilders[0]
		$TotalBuilders = $aGetBuilders[1]
		Setlog("No. of Free/Total Builders: " & $FreeBuilder & "/" & $TotalBuilders, $COLOR_GREEN)

	If $FreeBuilder < 1 + $iSaveWallBldr Then
	   SetLog("Not Enough Builder", $COLOR_RED)
	   Return
	EndIf
	
	If $LabNeedsDE = 1 Then
	   SetLog("Lab Needs DE", $COLOR_RED)
	   Return
	EndIf
	
	
	
;upgradequeen
	If $ichkUpgradeQueen = 1 Then	

		SetLog("Upgrade Queen")
		Click($QueenPos[0], $QueenPos[1]) ;Click Queen Altar
		If _Sleep(500) Then Return
		
		
		$sInfo = BuildingInfo(250, 520)
		If $sInfo[0] > 1 Or $sInfo[0] = "" Then
			If  StringInStr($sInfo[1], "Quee") = 0 Then
				SetLog("Bad AQ location", $COLOR_ORANGE)	
				return
			EndIf
		EndIf
		
		If _Sleep(500) Then Return
		_CaptureRegion()
		If _Sleep(200) Then Return
		If _ColorCheck(_GetPixelColor(605, 570), Hex(0xD8EC71, 6), 20) Then ; Finds Heal button
			QueenUpgrade()
		ElseIf _ColorCheck(_GetPixelColor(595, 570), Hex(0xE70A12, 6), 20) Then ; Red numbers
			SetLog("Not Enough DE for AQ", $COLOR_ORANGE)
			If _Sleep(1000) Then Return
			ClickP($aTopLeftClient,1,0,"#0121") ; click away
			If _Sleep(500) Then Return
		Else
			If _ColorCheck(_GetPixelColor(554, 570), Hex(0xC8EE6A, 6), 20) Then ; Green color
				SetLog("Queen is Upgrading", $COLOR_ORANGE)
				If _Sleep(1000) Then Return
				ClickP($aTopLeftClient,1,0,"#0121") ; click away
				If _Sleep(500) Then Return
			Else
				Click(604, 592) ;Click Upgrade Button
				If _Sleep(2000) Then Return
				Click(578, 512) ;Click Confirm Button
				If _Sleep(500) Then Return
				_CaptureRegion()
				If _ColorCheck(_GetPixelColor(743, 152), Hex(0xE51016, 6), 20) Then ;red arrow
					SetLog("Queen At Max Level", $COLOR_RED)
					ClickP($aTopLeftClient,1,0,"#0121") ; click away				
					GUICtrlSetState($chkUpgradeQueen, $GUI_UNCHECKED)
					If _Sleep(500) Then Return
				Else
					SetLog("Queen Upgraded", $COLOR_BLUE)
					ClickP($aTopLeftClient,1,0,"#0121") ; click away
					If _Sleep(500) Then Return
				EndIf
			EndIf
		EndIf

		If _Sleep(1000) Then Return
		ClickP($aTopLeftClient,1,0,"#0121") ; click away
		If _Sleep(500) Then Return
	EndIf



	Local $aGetBuilders = StringSplit(getBuilders($aBuildersDigits[0], $aBuildersDigits[1]), "#", $STR_NOCOUNT)
		$FreeBuilder = $aGetBuilders[0]
		$TotalBuilders = $aGetBuilders[1]

	If $FreeBuilder < 1 + $iSaveWallBldr Then
		SetLog("Not Enough Builder", $COLOR_RED)
		Return
	EndIf


;upgradeking
	If $ichkUpgradeKing = 1 Then

		SetLog("Upgrade King")
		Click($KingPos[0], $KingPos[1]) ;Click King Altar
		If _Sleep(500) Then Return
		
		$sInfo = BuildingInfo(250, 520)
		If $sInfo[0] > 1 Or $sInfo[0] = "" Then
			If  (StringInStr($sInfo[1], "Barb") = 0) And (StringInStr($sInfo[1], "King") = 0) Then
				SetLog("Bad BK location", $COLOR_ORANGE)	
				return
			EndIf
		EndIf
		
		If _Sleep(500) Then Return
		_CaptureRegion()
		If _Sleep(200) Then Return
		If _ColorCheck(_GetPixelColor(605, 570), Hex(0xD8EC71, 6), 20) Then ; Finds Heal button
			KingUpgrade()
		ElseIf _ColorCheck(_GetPixelColor(595, 570), Hex(0xE70A12, 6), 20) Then ; Red numbers
			SetLog("Not Enough DE for BK", $COLOR_ORANGE)
			If _Sleep(1000) Then Return
			ClickP($aTopLeftClient,1,0,"#0121") ; click away
			If _Sleep(500) Then Return
		Else
			If _ColorCheck(_GetPixelColor(554, 570), Hex(0xC8EE6A, 6), 20) Then ; Green color
				SetLog("King is Upgrading", $COLOR_ORANGE)
			    If _Sleep(1000) Then Return
				ClickP($aTopLeftClient,1,0,"#0121") ; click away
				If _Sleep(500) Then Return
			Else
				Click(604, 592) ;Click Upgrade Button
				If _Sleep(2000) Then Return
				Click(578, 512) ;Click Confirm Button
				If _Sleep(500) Then Return
				_CaptureRegion()
				If _ColorCheck(_GetPixelColor(743, 152), Hex(0xE51016, 6), 20) Then ;red arrow
					SetLog("King At Max Level", $COLOR_RED)
					ClickP($aTopLeftClient,1,0,"#0121") ; click away
					GUICtrlSetState($chkUpgradeKing, $GUI_UNCHECKED)
					If _Sleep(500) Then Return
				Else
					SetLog("King Upgraded", $COLOR_BLUE)
					ClickP($aTopLeftClient,1,0,"#0121") ; click away
					If _Sleep(500) Then Return
				EndIf
			EndIf
		EndIf

	 	ClickP($aTopLeftClient,1,0,"#0121") ; click away
	EndIf
EndFunc

Func KingUpgrade()
	_CaptureRegion()
	If _ColorCheck(_GetPixelColor(501, 570), Hex(0xE70A12, 6), 20) Then ; Red numbers
		SetLog("Not Enough DE for BK", $COLOR_ORANGE)
		If _Sleep(1000) Then Return
		ClickP($aTopLeftClient,1,0,"#0121") ; click away
		If _Sleep(500) Then Return
	Else
		Click(504, 592) ;Click Upgrade Button
		If _Sleep(2000) Then Return
		Click(578, 512) ;Click Confirm Button
		If _Sleep(500) Then Return
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor(743, 152), Hex(0xE51016, 6), 20) Then ;red arrow
			SetLog("King At Max Level", $COLOR_RED)
			ClickP($aTopLeftClient,1,0,"#0121") ; click away
			GUICtrlSetState($chkUpgradeKing, $GUI_UNCHECKED)
			If _Sleep(500) Then Return
		Else
			SetLog("King Upgraded", $COLOR_BLUE)
			If _Sleep(1000) Then Return
			ClickP($aTopLeftClient,1,0,"#0121") ; click away
			If _Sleep(500) Then Return
		EndIf
	EndIf
EndFunc

Func QueenUpgrade()
	_CaptureRegion()
	If _ColorCheck(_GetPixelColor(501, 570), Hex(0xE70A12, 6), 20) Then ; Red numbers
		SetLog("Not Enough DE for AQ", $COLOR_ORANGE)
		If _Sleep(1000) Then Return
		ClickP($aTopLeftClient,1,0,"#0121") ; click away
		If _Sleep(500) Then Return
	Else
		Click(504, 592) ;Click Upgrade Button
		If _Sleep(2000) Then Return
		Click(578, 512) ;Click Confirm Button
		If _Sleep(500) Then Return
			_CaptureRegion()
		If _ColorCheck(_GetPixelColor(743, 152), Hex(0xE51016, 6), 20) Then ;red arrow
			SetLog("Queen At Max Level", $COLOR_RED)

			ClickP($aTopLeftClient,1,0,"#0121") ; click away
			GUICtrlSetState($chkUpgradeQueen, $GUI_UNCHECKED)
			If _Sleep(500) Then Return
		Else
			SetLog("Queen Upgraded", $COLOR_BLUE)
			If _Sleep(1000) Then Return
			ClickP($aTopLeftClient,1,0,"#0121") ; click away
			If _Sleep(500) Then Return
		EndIf
	EndIf
EndFunc