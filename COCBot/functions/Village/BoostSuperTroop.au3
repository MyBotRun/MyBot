; #FUNCTION# ====================================================================================================================
; Name ..........: Boost a troop to super troop
; Description ...:
; Syntax ........: BoostSuperTroop($iTroopIndex)
; Parameters ....:
; Return values .: True if boosted, False if not
; Author ........: Fliegerfaust (04/2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BoostSuperTroop($iTroopIndex)
	If $iTroopIndex < $eBarb Or $iTroopIndex > $eIceG Or $g_asSuperTroopShortNames[$iTroopIndex] == "" Then
		SetLog("BoostSuperTroop(): $iTroopIndex out of boundary (" & $iTroopIndex & ")", $COLOR_ERROR)
		Return False
	EndIf

	Local $sTroopName = GetTroopName($iTroopIndex)
	SetLog("Trying to boost " & $sTroopName, $COLOR_INFO)
	ClickP($aAway, 1, 0, "#0332")     ;Click Away

	Local $sSearchArea = GetDiamondFromRect("80,80,250,250")
	Local $avBarrel = findMultiple($g_sImgBoostTroopsBarrel, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", True)

	If Not IsArray($avBarrel) Or UBound($avBarrel, $UBOUND_ROWS) <= 0 Then
		SetLog("Couldn't find super troop barrel on main village", $COLOR_ERROR)
		Return False
	EndIf

	Local $avTempArray, $aiBarrelCoords
	For $i = 0 To UBound($avBarrel, $UBOUND_ROWS) - 1
		$avTempArray = $avBarrel[$i]
		If StringInStr($avTempArray[0], "BoostedBarrel", $STR_NOCASESENSE) Then
			SetLog("Detected a glowing barrel, troop is already boosted!", $COLOR_INFO)
			Return False
		ElseIf StringInStr($avTempArray[0], "Ready", $STR_NOCASESENSE) Then
			$aiBarrelCoords = decodeSingleCoord($avTempArray[1])
		EndIf
	Next

	If Not IsArray($aiBarrelCoords) Or UBound($aiBarrelCoords, $UBOUND_ROWS) < 2 Then
		SetLog("Couldn't get proper barrel coordinates", $COLOR_ERROR)
		Return False
	EndIf

	ClickP($aiBarrelCoords)
	If _Sleep(500) Then Return False

	If Not IsWindowOpen($g_sImgSuperTroopsWindow, 10, 200, GetDiamondFromRect("300,150,550,250")) Then
		SetLog("Super troop window did not open, exit", $COLOR_ERROR)
		Return False
	EndIf

	Local $sShortTroopName = $g_asSuperTroopShortNames[$iTroopIndex]
	Local $asTroopIcon = _FileListToArrayRec($g_sImgBoostTroopsIcons, $sShortTroopName & "*", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_NOSORT, $FLTAR_FULLPATH)
	If IsArray($asTroopIcon) And UBound($asTroopIcon, $UBOUND_ROWS) > 1 Then
		Local $aiTroopIcon = decodeSingleCoord(findImage($sShortTroopName, $asTroopIcon[1], GetDiamondFromRect("130,240,730,520"), 1, True))
		If Not IsArray($aiTroopIcon) Or UBound($aiTroopIcon, $UBOUND_ROWS) < 2 Then
			SetLog($sShortTroopName & " not available", $COLOR_ERROR)
			Return False
		EndIf

		ClickP($aiTroopIcon)
		If _Sleep(300) Then Return False

		$sSearchArea = GetDiamondFromRect("400,500,750,610")
		Local $avBoostButton = findMultiple($g_sImgBoostTroopsButtons, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", True)
		If IsArray($avBoostButton) And UBound($avBoostButton, $UBOUND_ROWS) > 0 Then
			For $i = 0 To UBound($avBoostButton, $UBOUND_ROWS) - 1
				$avTempArray = $avBoostButton[$i]
				If StringInStr($avTempArray[0], "Unavailable", $STR_NOCASESENSE) Then
					SetLog("Couldn't boost " & $sTroopName & "! Boost button is not available", $COLOR_ERROR)
					Return False
				Else
					Local $aiBoostButton = decodeSingleCoord($avTempArray[1])
					ClickP($aiBoostButton)
					If _Sleep(800) Then Return False

					Local $aiConfirmBoost = decodeSingleCoord(findImage("ConfirmBoost", $g_sImgBoostTroopsButtons & "Confirm*", GetDiamondFromRect("230,250,630,530"), 1, True))
					If IsArray($aiConfirmBoost) And UBound($aiConfirmBoost) = 2 Then
						ClickP($aiConfirmBoost)
						If _Sleep(500) Then Return False

						If isGemOpen(True) Then
							SetDebugLog("Not enough DE for boosting super troop", $COLOR_DEBUG)
							Return False
						EndIf

						SetLog("Boosted " & $sTroopName & " successfully!", $COLOR_SUCCESS)
						Return True
					EndIf
				EndIf
			Next
		EndIf
	EndIf

	ClickP($aAway)
	Return False
EndFunc   ;==>BoostSuperTroop
