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
#include <Array.au3>
#include <MsgBoxConstants.au3>

Func BoostSuperTroop($iTroopIndex)
	Local $bBoostedBarrel = False
	If $iTroopIndex < $eBarb Or $iTroopIndex > $eHunt Then
		If $iTroopIndex < $eSuperBarb Or $iTroopIndex > $eSuperHunt Then
			SetLog("BoostSuperTroop(): $iTroopIndex out of boundary (" & $iTroopIndex & ")", $COLOR_ERROR)
			Return False
		Else
			$iTroopIndex = $iTroopIndex - $eSuperBarb
		EndIf
	EndIf

	Local $sTroopName = GetTroopName($iTroopIndex)
	SetLog("Trying to boost " & $sTroopName, $COLOR_INFO)
	ClickAway()
	
	If _Sleep(500) Then Return False

	Local $sSearchArea = GetDiamondFromRect("70,150,250,250")
	Local $avBarrel = findMultiple($g_sImgBoostTroopsBarrel, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", True)

	If Not IsArray($avBarrel) Or UBound($avBarrel, $UBOUND_ROWS) <= 0 Then
		SetLog("Couldn't find super troop barrel on main village", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("BoostSuperTroop", False)
		Return False
	EndIf

	Local $avTempArray, $aiBarrelCoords
	
	; loop thro the detected images
	For $i = 0 To UBound($avBarrel, $UBOUND_ROWS) - 1
		$avTempArray = $avBarrel[$i]
		SetLog("Barrel Search find : " & $avTempArray[0])
		
		; Found boosted barrel : check if it is the troop we want to boost
		If StringInStr($avTempArray[0], "BoostedBarrel", $STR_NOCASESENSE) Then
			$bBoostedBarrel = True
			$aiBarrelCoords = decodeSingleCoord($avTempArray[1])
		ElseIf StringInStr($avTempArray[0], "Ready", $STR_NOCASESENSE) Then
			$aiBarrelCoords = decodeSingleCoord($avTempArray[1])
		EndIf
	Next

	If Not IsArray($aiBarrelCoords) Or UBound($aiBarrelCoords, $UBOUND_ROWS) < 2 Then
		SetLog("Couldn't get proper barrel coordinates", $COLOR_ERROR)
		Return False
	EndIf

	If $bBoostedBarrel Then
		SetLog("Detected a glowing barrel, there are boosted troops!", $COLOR_INFO)
		SetLog("Checking if it is the one we want", $COLOR_INFO)
			
		If (FindBoostedTroop($aiBarrelCoords, $iTroopIndex)) Then
			SetLog("Yes! It is correct")
			ClickAway()
			Return True
		EndIf

		; wrong troop clear screen
		ClickAway()
		If _Sleep(500) Then Return False
	EndIf

	ClickP($aiBarrelCoords)
	If _Sleep(500) Then Return False

	If Not IsWindowOpen($g_sImgSuperTroopsWindow, 10, 200, GetDiamondFromRect("300,150,550,250")) Then
		SetLog("Super troop window did not open, exit", $COLOR_ERROR)
		Return False
	EndIf

    Local $sShortTroopName = $g_asSuperTroopShortNames[$iTroopIndex]
    ; _ArraySearch($aiSuperTroopsWindow,


	Local $asTroopIcon = _FileListToArrayRec($g_sImgBoostTroopsIcons, $sShortTroopName & "*", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_NOSORT, $FLTAR_FULLPATH)
	If IsArray($asTroopIcon) And UBound($asTroopIcon, $UBOUND_ROWS) > 1 Then
		Local $aiTroopIcon = decodeSingleCoord(findImage($sShortTroopName, $asTroopIcon[1], GetDiamondFromRect("130,240,730,520"), 1, True))

		If Not IsArray($aiTroopIcon) Or UBound($aiTroopIcon, $UBOUND_ROWS) < 2 Then
			ClickDrag(428,500,428,260, 200)
			If _Sleep(500) Then Return False
			$aiTroopIcon = decodeSingleCoord(findImage($sShortTroopName, $asTroopIcon[1], GetDiamondFromRect("130,240,730,520"), 1, True))
			If Not IsArray($aiTroopIcon) Or UBound($aiTroopIcon, $UBOUND_ROWS) < 2 Then
				SetLog($sShortTroopName & " not available", $COLOR_ERROR)
				Return False
			EndIf
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

						$g_iBoostSuperTroopIndex = -1
						SetLog("Boosted " & $sTroopName & " successfully!", $COLOR_SUCCESS)
						Return True
					EndIf
				EndIf
			Next
		EndIf
	EndIf

	ClickAway()
	Return False
 EndFunc   ;==>BoostSuperTroop


 Func FindBoostedTroop($aiBarrelCoords, $iTroopIndex)
	Local $iTroop
	Local $sImgClockFaceImages = @ScriptDir & "\imgxml\Main Village\BoostSuperTroop\Clock"

	If Not IsArray($aiBarrelCoords) Or UBound($aiBarrelCoords, $UBOUND_ROWS) < 2 Then
		SetLog("Couldn't get proper barrel coordinates", $COLOR_ERROR)
		Return False
	EndIf

   ; click on bossted barrel
	ClickP($aiBarrelCoords)
	If _Sleep(500) Then Return False

	If Not IsWindowOpen($g_sImgSuperTroopsWindow, 10, 200, GetDiamondFromRect("300,150,550,250")) Then
		SetLog("Super troop window did not open, exit", $COLOR_ERROR)
		Return False
	EndIf

	SetLog("Searching for Super Troop :")

	; search for Super Troop Icon
    Local $sShortTroopName = $g_asSuperTroopShortNames[$iTroopIndex]

	Local $asTroopIcon = _FileListToArrayRec($g_sImgBoostTroopsIcons, $sShortTroopName & "*", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_NOSORT, $FLTAR_FULLPATH)

	If IsArray($asTroopIcon) And UBound($asTroopIcon, $UBOUND_ROWS) > 1 Then
		Local $aiTroopIcon = decodeSingleCoord(findImage($sShortTroopName, $asTroopIcon[1], GetDiamondFromRect("130,240,730,520"), 1, True))

		If Not IsArray($aiTroopIcon) Or UBound($aiTroopIcon, $UBOUND_ROWS) < 2 Then
			ClickDrag(428,550,260,150)
			If _Sleep(500) Then Return False
			$aiTroopIcon = decodeSingleCoord(findImage($sShortTroopName, $asTroopIcon[1], GetDiamondFromRect("130,240,730,520"), 1, True))
			If Not IsArray($aiTroopIcon) Or UBound($aiTroopIcon, $UBOUND_ROWS) < 2 Then
				SetLog($sShortTroopName & " not available", $COLOR_ERROR)
				Return False
			EndIf
		EndIf
	EndIf

	; $aiTroopIcon is x, y coord 
	; calculate bottom left area for clock search
	Local $clock_x = $aiTroopIcon[0];
	Local $clock_y = $aiTroopIcon[1];

	Local $x1 = $clock_x - 100
	Local $y1 = $clock_y
	Local $x2 = $clock_x
	Local $y2 = $clock_y + 90

	Local $sIconSearchArea = string($x1) & "," & string($y1) & "," & string($x2) & "," & string($y2)

	Local $sSearchIcon = GetDiamondFromRect($sIconSearchArea) ; Contains iXStart, $iYStart, $iXEnd, $iYEnd

	; search for a clock face in the Boost window
	Local $avClockFace = findMultiple($sImgClockFaceImages, $sSearchIcon, $sSearchIcon, 0, 1000, 0, "objectname,objectpoints")

	SaveDebugImage("BoostClock", False)

	; no clockface 
	If Not IsArray($avClockFace) Or UBound($avClockFace, $UBOUND_ROWS) <= 0 Then
		Return False
	EndIf

	SetLog("Found a clock!")
	
	Return True
EndFunc
