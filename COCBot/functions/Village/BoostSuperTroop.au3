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
	If $iTroopIndex < $eBarb Or $iTroopIndex > $eHunt Or $g_asSuperTroopShortNames[$iTroopIndex] == "" Then
		SetLog("BoostSuperTroop(): $iTroopIndex out of boundary (" & $iTroopIndex & ")", $COLOR_ERROR)
		Return False
	EndIf

	Local $sTroopName = GetTroopName($iTroopIndex)
	SetLog("Trying to boost " & $sTroopName, $COLOR_INFO)
	ClickAway()

	If _Sleep(500) Then Return False

	Local $sSearchArea = GetDiamondFromRect("70,150,250,250")
	Local $avBarrel = findMultiple($g_sImgBoostTroopsBarrel, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", True)

	If Not IsArray($avBarrel) Or UBound($avBarrel, $UBOUND_ROWS) <= 0 Then
		SetLog("Couldn't find super troop barrel on main village", $COLOR_ERROR)
		SetLog("LocateBarrelFail : " &  $g_iLocateBarrelFail)
		$g_iLocateBarrelFail += 1
		Return False
	EndIf

	$g_iLocateBarrelFail = 0

	Local $avTempArray, $aiBarrelCoords

	For $i = 0 To UBound($avBarrel, $UBOUND_ROWS) - 1
		$avTempArray = $avBarrel[$i]
		SetLog("Barrel Search find : " & $avTempArray[0])

		If StringInStr($avTempArray[0], "BoostedBarrel", $STR_NOCASESENSE) Then
			SetLog("Detected a glowing barrel, troop is already boosted!", $COLOR_INFO)

			; First run lets check it is the correct troop
			If $g_iBoostSuperTroopIndex = -1 Then
				SetLog("Lets check if it is the correct troop", $COLOR_INFO)

				$aiBarrelCoords = decodeSingleCoord($avTempArray[1])

				If (FindBoostedTroop($aiBarrelCoords, $iTroopIndex)) Then
					; set $g_iBoostSuperTroopIndex so we don't keep checking everytime we train
					$g_iBoostSuperTroopIndex = $iTroopIndex
					SetLog("Yes! It is correct")
					Return True
				Else
					SetLog("Oh No! Wrong Troop")
					Return False
				EndIf
			Else
				; Boosted Barrel and $g_iBoostSuperTroopIndex is set
				SetLog("Boosted Troop : " & $sTroopName, $COLOR_INFO)
				Return True
			EndIf

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

						$g_iBoostSuperTroopIndex = $iTroopIndex
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

	Local $sBoostDiamond = GetDiamondFromRect("130,240,730,550") ; Contains iXStart, $iYStart, $iXEnd, $iYEnd

	; search for a clock face in the Boost window
	Local $avClockFace = findMultiple($sImgClockFaceImages, $sBoostDiamond, $sBoostDiamond, 0, 1000, 0, "objectname,objectpoints")

	; no clockface lets scroll up and look again
	If Not IsArray($avClockFace) Or UBound($avClockFace, $UBOUND_ROWS) <= 0 Then
		ClickDrag(428,500,428,260, 200)
		If _Sleep(500) Then Return False

		$avClockFace = findMultiple($sImgClockFaceImages, $sBoostDiamond, $sBoostDiamond, 0, 1000, 0, "objectname,objectpoints")
		; no clockface lets scroll up and look again
		If Not IsArray($avClockFace) Or UBound($avClockFace, $UBOUND_ROWS) <= 0 Then
			ClickDrag(428,500,428,260, 200)
			If _Sleep(500) Then Return False

				$avClockFace = findMultiple($sImgClockFaceImages, $sBoostDiamond, $sBoostDiamond, 0, 1000, 0, "objectname,objectpoints")
				; still no clockface
				If Not IsArray($avClockFace) Or UBound($avClockFace, $UBOUND_ROWS) <= 0 Then
					SetLog("Cannot find clock face!")
				Return False
			EndIf
		EndIf
	EndIf

	; only need one clock face
	Local $avTempClockFace = $avClockFace[0]

	; get the x, y coord
	Local $aiClockCoord = StringSplit($avTempClockFace[1], ",", $STR_NOCOUNT)

	;_ArrayDisplay($aiClockFaces, "$aiClockFaces")

	; calculate search area for the troop
	Local $clock_x = $aiClockCoord[0];
	Local $clock_y = $aiClockCoord[1];

	Local $x1 = $clock_x
	Local $y1 = $clock_y - 100
	Local $x2 = $clock_x + 90
	Local $y2 = $clock_y

	Local $sIconSearchArea = string($x1) & "," & string($y1) & "," & string($x2) & "," & string($y2)

	SetLog("Icon Search Area: " & $sIconSearchArea)

	; look for the super troop
    Local $sShortTroopName = $g_asSuperTroopShortNames[$iTroopIndex]

	Local $asTroopIcon = _FileListToArrayRec($g_sImgBoostTroopsIcons, $sShortTroopName & "*", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_NOSORT, $FLTAR_FULLPATH)

	If IsArray($asTroopIcon) And UBound($asTroopIcon, $UBOUND_ROWS) > 1 Then
		; get the coord of the troop
		Local $aiTroopIcon = decodeSingleCoord(findImage($sShortTroopName, $asTroopIcon[1], GetDiamondFromRect($sIconSearchArea), 1, True))

		;_ArrayDisplay($aiTroopIcon, "$aiTroopIcon")

		ClickAway()

		; found troop
		If UBound($aiTroopIcon, $UBOUND_ROWS) > 1 Then
			SetLog("Found troop!")
			Return True
		EndIf
	Else
		SetLog("Boost Troop Icon Missing");
		Return False
	EndIf

	Return False
EndFunc
