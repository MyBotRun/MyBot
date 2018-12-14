; #FUNCTION# ====================================================================================================================
; Name ..........: searchTroopBar
; Description ...: Searches for the Troops and Spels in Troop Attack Bar
; Syntax ........: searchTroopBar($directory, $maxReturnPoints = 1, $TroopBarSlots)
; Parameters ....: $directory - tile location to perform search , $maxReturnPoints ( max number of coords returned ,   $TroopBarSlots array to hold return values
; Return values .: $TroopBarSlots
; Author ........: Trlopes (06-2016)
; Modified ......: ProMac (12-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func AttackBarCheck($bRemaining = False, $pMatchMode = $DB, $bDebug = False)

	Local $iX1 = 0, $iY1 = 635, $iX2 = 835, $iY2 = 698
	Static Local $bCheckSlot12 = False

	If Not $bRemaining Then $bCheckSlot12 = False

	If $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True)

	; Reset to level one the Spells level
	$g_iLSpellLevel = 1
	$g_iESpellLevel = 1

	; Setup arrays, including default return values for $return
	Local $aResult[1][6], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue, $sName, $aSlotAmountX[0][2]

	If Not $g_bRunState Then Return

	; Capture the screen for comparison
	_CaptureRegion2($iX1, $iY1, $iX2, $iY2)

	Local $sFinalResult = "", $iAttackbarStart = __TimerInit()

	; Perform the search
	Local $sAttBarRes = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $g_sImgAttackBarDir, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)

	If IsArray($sAttBarRes) Then
		If $sAttBarRes[0] = "0" Or $sAttBarRes[0] = "" Then
			SetLog("AttackBarCheck Error: Nothing found", $COLOR_ERROR)
		ElseIf StringLeft($sAttBarRes[0], 2) = "-1" Then
			SetLog("DLL Error: " & $sAttBarRes[0] & ", AttackBarCheck", $COLOR_ERROR)
		Else
			; Get the keys for the dictionary item.
			Local $aKeys = StringSplit($sAttBarRes[0], "|", $STR_NOCOUNT)

			; Redimension the result array to allow for the new entries
			ReDim $aResult[UBound($aKeys)][6]
			Local $iResultAddDup = 0

			; Loop through the array
			For $i = 0 To UBound($aKeys) - 1
				If Not $g_bRunState Then Return
				; Get the property values
				$sName = RetrieveImglocProperty($aKeys[$i], "objectname")
				; Get the coords property
				$aValue = RetrieveImglocProperty($aKeys[$i], "objectpoints")
				$aCoords = decodeMultipleCoords($aValue, 50) ; dedup coords by x on 50 pixel
				If StringRegExp($sName, "(AmountX)", 0) Then
					For $j = 0 To UBound($aCoords) - 1
						$aCoordsSplit = $aCoords[$j]
						_ArrayAdd($aSlotAmountX, $aCoordsSplit[0] & "|" & $aCoordsSplit[1], 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					Next
				Else

					$aResult[$i + $iResultAddDup][0] = $sName
					$aCoordsSplit = $aCoords[0]
					If StringRegExp($sName, "(King)|(Warden)|(Queen)", 0) Then
						_ArrayAdd($aSlotAmountX, $aCoordsSplit[0] & "|" & $aCoordsSplit[1], 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					EndIf
					If UBound($aCoordsSplit) = 2 Then
						; Store the coords into a two dimensional array
						$aCoordArray[0][0] = $aCoordsSplit[0] ; X coord.
						$aCoordArray[0][1] = $aCoordsSplit[1] ; Y coord.
					Else
						$aCoordArray[0][0] = -1
						$aCoordArray[0][1] = -1
					EndIf
					If $g_bDebugSetlog Then SetDebugLog($aResult[$i + $iResultAddDup][0] & " | $aCoordArray: " & $aCoordArray[0][0] & "-" & $aCoordArray[0][1])
					; Store the coords array as a sub-array
					$aResult[$i + $iResultAddDup][1] = Number($aCoordArray[0][0])
					$aResult[$i + $iResultAddDup][2] = Number($aCoordArray[0][1])
					;If a Clan Castle Spell exists
					Local $iMultipleCoords = UBound($aCoords)
					; Check if two Clan Castle Spells exist with different levels
					If $iMultipleCoords > 1 And StringInStr($aResult[$i + $iResultAddDup][0], "Spell") <> 0 Then
						If $g_bDebugSetlog Then SetDebugLog($aResult[$i + $iResultAddDup][0] & " detected " & $iMultipleCoords & " times!")
						For $j = 1 To $iMultipleCoords - 1
							Local $aCoordsSplit2 = $aCoords[$j]
							If UBound($aCoordsSplit2) = 2 Then
								; add slot
								$iResultAddDup += 1
								ReDim $aResult[UBound($aKeys) + $iResultAddDup][6]
								$aResult[$i + $iResultAddDup][0] = $aResult[$i + $iResultAddDup - 1][0] ; same objectname
								$aResult[$i + $iResultAddDup][1] = $aCoordsSplit2[0]
								$aResult[$i + $iResultAddDup][2] = $aCoordsSplit2[1]
								If $g_bDebugSetlog Then SetDebugLog($aResult[$i + $iResultAddDup][0] & " | $aCoordArray: " & $aResult[$i + $iResultAddDup][1] & "-" & $aResult[$i + $iResultAddDup][2])
							Else
								; don't invalidate anything
								;$aCoordArray[0][0] = -1
								;$aCoordArray[0][1] = -1
							EndIf
						Next
					EndIf
				EndIf
			Next

			_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i
			_ArraySort($aSlotAmountX)

			If $g_bDebugSetlog Then SetDebugLog("Attackbar detection completed in " & StringFormat("%.2f", _Timer_Diff($iAttackbarStart)) & " ms")
			$iAttackbarStart = __TimerInit()

			If Not $bRemaining And _CheckPixel($a12OrMoreSlots, True) Then $bCheckSlot12 = True

			Local $iSPellLevelOCR = -8
			For $i = 0 To UBound($aResult) - 1
				Local $aTempSlot
				If $aResult[$i][1] > 0 Then
					If $g_bDebugSetlog Then SetDebugLog("SLOT : " & $i, $COLOR_DEBUG) ;Debug
					If $g_bDebugSetlog Then SetDebugLog("Detection : " & $aResult[$i][0] & "|x" & $aResult[$i][1] & "|y" & $aResult[$i][2], $COLOR_DEBUG) ;Debug
					$aTempSlot = SlotAttack(Number($aResult[$i][1]), $aSlotAmountX)
					;
					If $g_bRunState = False Then Return ; Stop function
					If _Sleep(20) Then Return ; Pause function
					If UBound($aTempSlot) = 3 Then
						If $g_bDebugSetlog Then SetDebugLog("OCR : " & $aTempSlot[0] & "|SLOT: " & $aTempSlot[2], $COLOR_DEBUG) ;Debug
						If $aResult[$i][0] = "Castle" Or $aResult[$i][0] = "King" Or $aResult[$i][0] = "Queen" Or $aResult[$i][0] = "Warden" Or $aResult[$i][0] = "WallW" Or $aResult[$i][0] = "BattleB" Or $aResult[$i][0] = "StoneS" Then
							$aResult[$i][3] = 1
							$aResult[$i][4] = $aTempSlot[2]
						Else
							$aResult[$i][3] = Number(getTroopCountBig(Number($aTempSlot[0] + $iX1), Number($aTempSlot[1] + $iY1) - 2)) ; For big numbers when the troop is selected
							$aResult[$i][4] = $aTempSlot[2]
							If $aResult[$i][3] = "" Or $aResult[$i][3] = 0 Then
								$aResult[$i][3] = Number(getTroopCountSmall(Number($aTempSlot[0] + $iX1), Number($aTempSlot[1] + $iY1))) ; For small numbers when the troop isn't selected
								$aResult[$i][4] = $aTempSlot[2]
							EndIf

							If StringInStr($aResult[$i][0], "ESpell") <> 0 And $g_bSmartZapEnable Then
								$aResult[$i][5] = getTroopsSpellsLevel(Number($aTempSlot[0] + $iX1) + $iSPellLevelOCR, 704)
								If $aResult[$i][5] <> "" Then $g_iESpellLevel = $aResult[$i][5] ; If they aren't empty will store the correct level, or will be level 1 , just in case
								If $g_bDebugSmartZap Then SetLog("Earthquake Spell detected with level: " & $aResult[$i][5], $COLOR_DEBUG)
							EndIf
							If StringInStr($aResult[$i][0], "LSpell") <> 0 And $g_bSmartZapEnable Then
								$aResult[$i][5] = getTroopsSpellsLevel(Number($aTempSlot[0] + $iX1) + $iSPellLevelOCR, 704)
								If $aResult[$i][5] <> "" Then $g_iLSpellLevel = $aResult[$i][5] ; If they aren't empty will store the correct level, or will be level 1 , just in case
								If $g_bDebugSmartZap Then SetLog("Lightning Spell detected with level: " & $aResult[$i][5], $COLOR_DEBUG)
							EndIf
						EndIf
					Else
						SetLog("Error while detecting Attackbar", $COLOR_ERROR)
						SetLog("Detection: " & $aResult[$i][0] & "|X:" & $aResult[$i][1] & "|Y:" & $aResult[$i][2], $COLOR_DEBUG)
						$aResult[$i][3] = -1
						$aResult[$i][4] = -1
					EndIf
					$sFinalResult &= "|" & TroopIndexLookup($aResult[$i][0]) & "#" & $aResult[$i][4] & "#" & $aResult[$i][3] & "#" & $aResult[$i][1] ; Name#Index#Amount#x-coord
				EndIf
			Next
		EndIf
	EndIf


	If $g_bDebugSetlog Then SetDebugLog("Attackbar OCR completed in " & StringFormat("%.2f", __TimerDiff($iAttackbarStart)) & " ms")

	If $bDebug Then
		Local $iX1 = 0, $iY1 = 635, $iX2 = 853, $iY2 = 698
		_CaptureRegion2($iX1, $iY1, $iX2, $iY2)

		Local $sSubDir = $g_sProfileTempDebugPath & "AttackBarDetection"

		DirCreate($sSubDir)

		Local $sDate = @YEAR & "-" & @MON & "-" & @MDAY, $sTime = @HOUR & "." & @MIN & "." & @SEC
		Local $sDebugImageName = String($sDate & "_" & $sTime & "_.png")
		Local $hEditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hEditedImage)
		Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3)

		For $i = 0 To UBound($aResult) - 1
			addInfoToDebugImage($hGraphic, $hPenRED, $aResult[$i][0], $aResult[$i][1], $aResult[$i][2])
		Next

		_GDIPlus_ImageSaveToFile($hEditedImage, $sSubDir & "\" & $sDebugImageName)
		_GDIPlus_PenDispose($hPenRED)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_BitmapDispose($hEditedImage)
	EndIf

	; Drag left & checking extended troops from Slot11+ ONLY if not a smart attack
	If ($pMatchMode <= $LB And $bCheckSlot12 And UBound($aResult) > 1 And $g_aiAttackAlgorithm[$pMatchMode] <> 3) Or $bDebug Then
		SetDebuglog("$sFinalResult 1st page = " & $sFinalResult)
		Local $aLastTroop1stPage[2]
		$aLastTroop1stPage[0] = $aResult[UBound($aResult) - 1][0] ; Name of troop at last slot 1st page
		$aLastTroop1stPage[1] = UBound(_ArrayFindAll($aResult, $aLastTroop1stPage[0])) ; Number of slots this troop appears in 1st page
		SetDebuglog("$sLastTroop1stPage = " & $aLastTroop1stPage[0] & ", appears: " & $aLastTroop1stPage[1])
		DragAttackBar()
		$sFinalResult &= ExtendedAttackBarCheck($aLastTroop1stPage, $bRemaining)
		If Not $bRemaining Then DragAttackBar($g_iTotalAttackSlot, True) ; return drag
	EndIf

	$sFinalResult = StringTrimLeft($sFinalResult, 1)

	Return $sFinalResult

EndFunc   ;==>AttackBarCheck

Func SlotAttack($iPosX, $aSlots)
	Local $aTempSlot[3] = [0, 0, 0]
	Local $iClosest = SearchNearest($aSlots, $iPosX)
	Local $bLast = False
	If $iClosest = _ArrayMaxIndex($aSlots, 0) And $aSlots[$iClosest][0] >= ($g_iGAME_WIDTH - 60) Then $bLast = True

	If $iClosest >= 0 And $iClosest < UBound($aSlots) Then
		$aTempSlot[0] = $bLast ? $g_iGAME_WIDTH - 53 : $aSlots[$iClosest][0] - 15 ; X Coord | Last Item to get OCRd needs to be compensated because it could happen that the Capture Rectangle gets out of boundary and image gets not usable
		$aTempSlot[1] = $aSlots[$iClosest][1] - 7 ; Y Coord
		$aTempSlot[2] = $iClosest
	EndIf

	Return $aTempSlot
EndFunc   ;==>SlotAttack

Func SearchNearest($aArray, $iNumber)
	Local $iVal, $iValOld = _ArrayMax($aArray), $iReturn
	For $i = 0 To UBound($aArray) - 1
		$iVal = Abs($aArray[$i][0] - $iNumber)
		If $iValOld >= $iVal Then
			$iValOld = $iVal
			$iReturn = $i
		EndIf
	Next
	Return $iReturn
EndFunc   ;==>SearchNearest

Func ExtendedAttackBarCheck($aLastTroop1stPage, $bRemaining)

	Local $iX1 = 0, $iY1 = 635, $iX2 = 835, $iY2 = 698
	Static $bCheckSlotwHero2 = False

	; Setup arrays, including default return values for $return
	Local $aResult[1][6], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue, $sName, $aSlotAmountX[0][2]
	If Not $g_bRunState Then Return

	; Capture the screen for comparison
	_CaptureRegion2($iX1, $iY1, $iX2, $iY2)

	Local $sFinalResult = ""
	; Perform the search
	Local $sAttBarRes = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $g_sImgAttackBarDir, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)
	If IsArray($sAttBarRes) Then
		If $sAttBarRes[0] = "0" Or $sAttBarRes[0] = "" Then
			SetLog("Imgloc|AttackBarCheck not found!", $COLOR_ERROR)
		ElseIf StringLeft($sAttBarRes[0], 2) = "-1" Then
			SetLog("DLL Error: " & $sAttBarRes[0] & ", AttackBarCheck", $COLOR_RED)
		Else
			; Get the keys for the dictionary item.
			Local $aKeys = StringSplit($sAttBarRes[0], "|", $STR_NOCOUNT)

			; Redimension the result array to allow for the new entries
			ReDim $aResult[UBound($aKeys)][6]
			Local $iResultAddDup = 0

			; Loop through the array
			For $i = 0 To UBound($aKeys) - 1
				If Not $g_bRunState Then Return
				; Get the property values
				$sName = RetrieveImglocProperty($aKeys[$i], "objectname")
				; Get the coords property
				$aValue = RetrieveImglocProperty($aKeys[$i], "objectpoints")
				$aCoords = decodeMultipleCoords($aValue, 50) ; dedup coords by x on 50 pixel

				If StringRegExp($sName, "(AmountX)", 0) Then
					For $j = 0 To UBound($aCoords) - 1
						$aCoordsSplit = $aCoords[$j]
						_ArrayAdd($aSlotAmountX, $aCoordsSplit[0] & "|" & $aCoordsSplit[1], 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					Next
				Else
					$aResult[$i + $iResultAddDup][0] = $sName
					$aCoordsSplit = $aCoords[0]
					If StringRegExp($sName, "(King)|(Warden)|(Queen)", 0) Then _ArrayAdd($aSlotAmountX, $aCoordsSplit[0] & "|" & $aCoordsSplit[1], 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					If UBound($aCoordsSplit) = 2 Then
						; Store the coords into a two dimensional array
						$aCoordArray[0][0] = $aCoordsSplit[0] ; X coord.
						$aCoordArray[0][1] = $aCoordsSplit[1] ; Y coord.
					Else
						$aCoordArray[0][0] = -1
						$aCoordArray[0][1] = -1
					EndIf
					If $g_bDebugSetlog Then SetDebugLog($aResult[$i + $iResultAddDup][0] & " | $aCoordArray: " & $aCoordArray[0][0] & "-" & $aCoordArray[0][1])
					; Store the coords array as a sub-array
					$aResult[$i + $iResultAddDup][1] = Number($aCoordArray[0][0])
					$aResult[$i + $iResultAddDup][2] = Number($aCoordArray[0][1])
					;If a Clan Castle Spell exists
					Local $iMultipleCoords = UBound($aCoords)
					; Check if two Clan Castle Spells exist with different levels
					If $iMultipleCoords > 1 And StringInStr($aResult[$i + $iResultAddDup][0], "Spell") <> 0 Then
						If $g_bDebugSetlog Then SetDebugLog($aResult[$i + $iResultAddDup][0] & " detected " & $iMultipleCoords & " times!")
						For $j = 1 To $iMultipleCoords - 1
							Local $aCoordsSplit2 = $aCoords[$j]
							If UBound($aCoordsSplit2) = 2 Then
								; add slot
								$iResultAddDup += 1
								ReDim $aResult[UBound($aKeys) + $iResultAddDup][6]
								$aResult[$i + $iResultAddDup][0] = $aResult[$i + $iResultAddDup - 1][0] ; same objectname
								$aResult[$i + $iResultAddDup][1] = $aCoordsSplit2[0]
								$aResult[$i + $iResultAddDup][2] = $aCoordsSplit2[1]
								If $g_bDebugSetlog Then SetDebugLog($aResult[$i + $iResultAddDup][0] & " | $aCoordArray: " & $aResult[$i + $iResultAddDup][1] & "-" & $aResult[$i + $iResultAddDup][2])
							Else
								; don't invalidate anything
								;$aCoordArray[0][0] = -1
								;$aCoordArray[0][1] = -1
							EndIf
						Next
					EndIf
				EndIf
			Next

			_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i
			_ArraySort($aSlotAmountX)

			Local $iSlotExtended = 0
			Static $iFirstExtendedSlot = -1 ; Location of 1st extended troop after drag
			If Not $bRemaining Then
				$iFirstExtendedSlot = -1 ; Reset value for 1st time detecting troop bar
			EndIf

			Local $iFoundLastTroop1stPage
			Local $bStart2ndPage = False
			For $i = 0 To UBound($aResult) - 1
				Local $aTempSlot
				If $aResult[$i][1] > 0 Then
					SetDebugLog("Slot : " & $i, $COLOR_DEBUG) ;Debug
					SetDebugLog("Detection : " & $aResult[$i][0] & "|x" & $aResult[$i][1] & "|y" & $aResult[$i][2], $COLOR_DEBUG) ;Debug

					; Finding where to start the 2nd page
					If $aResult[$i][0] = $aLastTroop1stPage[0] And Not $bStart2ndPage Then
						$iFoundLastTroop1stPage += 1
						SetDebugLog("Found $aLastTroop1stPage[0]: " & $aResult[$i][0] & " x" & $iFoundLastTroop1stPage)
						If $iFoundLastTroop1stPage >= $aLastTroop1stPage[1] Then $bStart2ndPage = True
						ContinueLoop
					EndIf
					If Not $bStart2ndPage Then ContinueLoop

					$aTempSlot = SlotAttack(Number($aResult[$i][1]), $aSlotAmountX)
					If $iFirstExtendedSlot = -1 Then $iFirstExtendedSlot = $aTempSlot[2] ; flag only once
					$iSlotExtended = $aTempSlot[2] - $iFirstExtendedSlot + 1
					If Not $g_bRunState Then Return ; Stop function
					If _Sleep(20) Then Return ; Pause function
					If UBound($aTempSlot) = 3 Then
						SetDebugLog("OCR : " & $aTempSlot[0] & "|SLOT: " & $aTempSlot[2], $COLOR_DEBUG) ;Debug
						If $aResult[$i][0] = "Castle" Or $aResult[$i][0] = "King" Or $aResult[$i][0] = "Queen" Or $aResult[$i][0] = "Warden" Or $aResult[$i][0] = "WallW" Or $aResult[$i][0] = "BattleB" Or $aResult[$i][0] = "StoneS" Then
							$aResult[$i][3] = 1
						Else
							$aResult[$i][3] = Number(getTroopCountSmall(Number($aTempSlot[0] + $iX1), Number($aTempSlot[1] + $iY1))) ; For small Numbers
							If $aResult[$i][3] = "" Or $aResult[$i][3] = 0 Then
								$aResult[$i][3] = Number(getTroopCountBig(Number($aTempSlot[0] + $iX1), Number($aTempSlot[1] + $iY1) - 4)) ; For Big Numbers , when the troops is selected
							EndIf
						EndIf
						$aResult[$i][4] = ($aTempSlot[2] + 11) - $iFirstExtendedSlot
					Else
						Setlog("Problem with Attack bar detection!", $COLOR_ERROR)
						SetLog("Detection : " & $aResult[$i][0] & "|x" & $aResult[$i][1] & "|y" & $aResult[$i][2], $COLOR_DEBUG)
						$aResult[$i][3] = -1
						$aResult[$i][4] = -1
					EndIf
					$sFinalResult &= "|" & TroopIndexLookup($aResult[$i][0]) & "#" & $aResult[$i][4] & "#" & $aResult[$i][3] & "#" & $aResult[$i][1]
				EndIf
			Next
			If Not $bRemaining Then
				$g_iTotalAttackSlot = $iSlotExtended + 10
			EndIf

			SetDebugLog("$iSlotExtended / $g_iTotalAttackSlot: " & $iSlotExtended & "/" & $g_iTotalAttackSlot)

		EndIf
	EndIf

	SetDebugLog("Extended $sFinalResult: " & $sFinalResult)
	Return $sFinalResult

EndFunc   ;==>ExtendedAttackBarCheck

Func DragAttackBar($iTotalSlot = 20, $bBack = False)
	If $g_iTotalAttackSlot > 10 Then $iTotalSlot = $g_iTotalAttackSlot
	Local $bAlreadyDrag = False

	If Not $bBack Then
		SetDebugLog("Dragging attack troop bar to 2nd page. Distance = " & $iTotalSlot - 9 & " slots")
		ClickDrag(25 + 73 * ($iTotalSlot - 9), 660, 25, 660, 1000)
		If _Sleep(1000 + $iTotalSlot * 25) Then Return
		$bAlreadyDrag = True
	Else
		SetDebugLog("Dragging attack troop bar back to 1st page. Distance = " & $iTotalSlot - 9 & " slots")
		ClickDrag(25, 660, 25 + 73 * ($iTotalSlot - 9), 660, 1000)
		If _Sleep(800 + $iTotalSlot * 25) Then Return
		$bAlreadyDrag = False
	EndIf

	$g_bDraggedAttackBar = $bAlreadyDrag
	$g_iCSVLastTroopPositionDropTroopFromINI = -1 ; after drag attack bar, need to clear last troop selected
	Return $bAlreadyDrag
EndFunc   ;==>DragAttackBar
