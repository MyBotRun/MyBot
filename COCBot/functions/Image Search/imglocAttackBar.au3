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
Func TestImglocTroopBar()
	$g_bRunState = True
	$g_bDebugSetlog = True
	$g_bDebugOcr = True
	$g_bDebugImageSave = True
	Local $tempSieges = $g_aiCurrentSiegeMachines
	$g_aiCurrentSiegeMachines[$eSiegeWallWrecker] = 1
	$g_aiCurrentSiegeMachines[$eSiegeBattleBlimp] = 1

	SetLog("=========== Imgloc ============")
	PrepareAttack($DB, False , True)
	$g_aiCurrentSiegeMachines = $tempSieges
	$g_bDebugSetlog = False
	$g_bDebugOcr = False
	$g_bDebugImageSave = False
	$g_bRunState = False
EndFunc   ;==>TestImglocTroopBar

Func AttackBarCheck($Remaining = False, $pMatchMode = $DB)

	Local $x = 0, $y = 659, $x1 = 853, $y1 = 698
	Static Local $CheckSlot12 = False
	Static Local $CheckSlotwHero = False

	If Not $Remaining Then
		$CheckSlot12 = False
		$CheckSlotwHero = False
	EndIf

	If $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True )

	; Reset to level one the Spells level
	$g_iLSpellLevel = 1
	$g_iESpellLevel = 1

	; Setup arrays, including default return values for $return
	Local $aResult[1][6], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue
	If Not $g_bRunState Then Return
	; Capture the screen for comparison
	_CaptureRegion2($x, $y, $x1, $y1)

	Local $strinToReturn = "" , $hStarttime = _Timer_Init()
	; Perform the search
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $g_sImgAttackBarDir, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)

	If IsArray($res) Then
		If $res[0] = "0" Or $res[0] = "" Then
			SetLog("Imgloc|AttackBarCheck not found!", $COLOR_RED)
		ElseIf StringLeft($res[0], 2) = "-1" Then
			SetLog("DLL Error: " & $res[0] & ", AttackBarCheck", $COLOR_RED)
		Else
			; Get the keys for the dictionary item.
			Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

			; Redimension the result array to allow for the new entries
			ReDim $aResult[UBound($aKeys)][6]
			Local $iResultAddDup = 0

			; Loop through the array
			For $i = 0 To UBound($aKeys) - 1
				If $g_bRunState = False Then Return
				; Get the property values
				$aResult[$i + $iResultAddDup][0] = RetrieveImglocProperty($aKeys[$i], "objectname")
				; Get the coords property
				$aValue = RetrieveImglocProperty($aKeys[$i], "objectpoints")
				$aCoords = decodeMultipleCoords($aValue, 50) ; dedup coords by x on 50 pixel
				$aCoordsSplit = $aCoords[0]
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
				;;;;;;;; If exist Castle Spell ;;;;;;;
				Local $iMultipleCoords = UBound($aCoords)
				; Check if exist a double Castle Spells but with different levels
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
			Next

			_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i

			If $g_bDebugSetlog Then SetDebugLog("Benchmark Bar Detection: " & StringFormat("%.2f", _Timer_Diff($hStarttime))& "'ms")
			$hStarttime =  _Timer_Init()

			If Not $Remaining Then
				$CheckSlot12 = _ColorCheck(_GetPixelColor(17, 643, True), Hex(0x478AC6, 6), 15) Or _  	 ; Slot Filled / Background Blue / More than 11 Slots
						_ColorCheck(_GetPixelColor(17, 643, True), Hex(0x434343, 6), 10) ; Slot deployed / Gray / More than 11 Slots

				If $g_bDebugSetlog Then
					SetDebugLog(" Slot > 12 _ColorCheck 0x478AC6 at (17," & 643 & "): " & $CheckSlot12, $COLOR_DEBUG) ;Debug
					Local $CheckSlot12Color = _GetPixelColor(17, 643, $g_bCapturePixel)
					SetDebugLog(" Slot > 12 _GetPixelColor(17," & 643 & "): " & $CheckSlot12Color, $COLOR_DEBUG) ;Debug
				EndIf

				For $i = 0 To UBound($aResult) - 1
					If $aResult[$i][0] = "King" Or $aResult[$i][0] = "Queen" Or $aResult[$i][0] = "Warden" Then
						$CheckSlotwHero = True
					EndIf
				Next
			EndIf

			Local $iSlotCompensation = -8
			For $i = 0 To UBound($aResult) - 1
				Local $Slottemp
				If $aResult[$i][1] > 0 Then
					If $g_bDebugSetlog Then SetDebugLog("SLOT : " & $i, $COLOR_DEBUG) ;Debug
					If $g_bDebugSetlog Then SetDebugLog("Detection : " & $aResult[$i][0] & "|x" & $aResult[$i][1] & "|y" & $aResult[$i][2], $COLOR_DEBUG) ;Debug
					$Slottemp = SlotAttack(Number($aResult[$i][1]), $CheckSlot12, $CheckSlotwHero)
					If $g_bRunState = False Then Return ; Stop function
					If _Sleep(20) Then Return ; Pause function
					If UBound($Slottemp) = 2 Then
						If $g_bDebugSetlog Then SetDebugLog("OCR : " & $Slottemp[0] & "|SLOT: " & $Slottemp[1], $COLOR_DEBUG) ;Debug
						If $CheckSlotwHero Then $iSlotCompensation = 10
						If $aResult[$i][0] = "Castle" Or $aResult[$i][0] = "King" Or $aResult[$i][0] = "Queen" Or $aResult[$i][0] = "Warden" Or $aResult[$i][0] = "WallW" Or $aResult[$i][0] = "BattleB" Then
							$aResult[$i][3] = 1
							$aResult[$i][4] = $Slottemp[1]
						Else
							; In case of Spells + Heroes
							; June 2018 Update
							If StringInStr($aResult[$i][0], "Spell") <> 0 And $CheckSlotwHero = True Then
								$Slottemp[0] = $Slottemp[0] + 13
								$iSlotCompensation = -6
							EndIf

							$aResult[$i][3] = Number(getTroopCountBig(Number($Slottemp[0]), 633)) ; For Big Numbers, when the troops is selected
							$aResult[$i][4] = $Slottemp[1]
							If $aResult[$i][3] = "" Or $aResult[$i][3] = 0 Then
								$aResult[$i][3] = Number(getTroopCountSmall(Number($Slottemp[0]), 640)) ; For small Numbers
								$aResult[$i][4] = $Slottemp[1]
							EndIf

							If StringInStr($aResult[$i][0], "ESpell") <> 0 And $g_bSmartZapEnable = True Then
								$aResult[$i][5] = getTroopsSpellsLevel(Number($Slottemp[0]) + $iSlotCompensation, 704)
								If $aResult[$i][5] <> "" Then $g_iESpellLevel = $aResult[$i][5] ; If they aren't empty will store the correct level, or will be level 1 , just in case
								If $g_bDebugSmartZap = True Then SetLog("EarthQuake Detected with level " & $aResult[$i][5], $COLOR_DEBUG)
							EndIf
							If StringInStr($aResult[$i][0], "LSpell") <> 0 And $g_bSmartZapEnable = True Then
								$aResult[$i][5] = getTroopsSpellsLevel(Number($Slottemp[0]) + $iSlotCompensation, 704)
								If $aResult[$i][5] <> "" Then $g_iLSpellLevel = $aResult[$i][5] ; If they aren't empty will store the correct level, or will be level 1 , just in case
								If $g_bDebugSmartZap = True Then SetLog("Lightning Detected with level " & $aResult[$i][5], $COLOR_DEBUG)
							EndIf
						EndIf
					Else
						SetLog("Problem with Attack bar detection!", $COLOR_RED)
						SetLog("Detection : " & $aResult[$i][0] & "|x" & $aResult[$i][1] & "|y" & $aResult[$i][2], $COLOR_DEBUG)
						$aResult[$i][3] = -1
						$aResult[$i][4] = -1
					EndIf
					$strinToReturn &= "|" & TroopIndexLookup($aResult[$i][0]) & "#" & $aResult[$i][4] & "#" & $aResult[$i][3]
				EndIf
			Next
		EndIf
	EndIf


	If $g_bDebugSetlog Then SetDebugLog("Benchmark Bar OCR : " & StringFormat("%.2f", _Timer_Diff($hStarttime))& "'ms")

	If $g_bDebugImageSave Then
		Local $x = 0, $y = 659, $x1 = 853, $y1 = 698
		_CaptureRegion2($x, $y, $x1, $y1)
		Local $subDirectory = $g_sProfileTempDebugPath & "AttackBarDetection"
		DirCreate($subDirectory)
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $filename = String($Date & "_" & $Time & "_.png")
		Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3) ; Create a pencil Color FF0000/RED

		For $i = 0 To UBound($aResult) - 1
			addInfoToDebugImage($hGraphic, $hPenRED, $aResult[$i][0], $aResult[$i][1], $aResult[$i][2])
			;_GDIPlus_GraphicsDrawRect($hGraphic, $aResult[$i][1] - 5, $aResult[$i][2] - 5, 10, 10, $hPenRED)
		Next

		_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $filename)
		_GDIPlus_PenDispose($hPenRED)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_BitmapDispose($editedImage)
	EndIf

	; Drag left & checking extended troops from Slot11+ ONLY if not a smart attack
	If $pMatchMode <= $LB And $CheckSlot12 And UBound($aResult)> 1 And $g_aiAttackAlgorithm[$pMatchMode] <> 3 Then
		SetDebuglog("$strinToReturn 1st page = " & $strinToReturn)
		Local $aLastTroop1stPage[2]
		$aLastTroop1stPage[0] = $aResult[UBound($aResult) - 1][0] ; Name of troop at last slot 1st page
		$aLastTroop1stPage[1] = UBound(_ArrayFindAll($aResult, $aLastTroop1stPage[0])) ; Number of slots this troop appears in 1st page
		SetDebuglog("$sLastTroop1stPage = " & $aLastTroop1stPage[0] & ", appears: " & $aLastTroop1stPage[1])
		DragAttackBar()
		$strinToReturn &= ExtendedAttackBarCheck($aLastTroop1stPage, $Remaining)
		If Not $Remaining Then DragAttackBar($g_iTotalAttackSlot, True) ; return drag
	EndIf

	$strinToReturn = StringTrimLeft($strinToReturn, 1)

	; Will return [0] = Name , [1] = X , [2] = Y , [3] = Quantities , [4] = Slot Number
	; Old style is: "|" & Troopa Number & "#" & Slot Number & "#" & Quantities
	Return $strinToReturn

EndFunc   ;==>AttackBarCheck

Func SlotAttack($PosX, $CheckSlot12, $CheckSlotwHero)

	Local $Slottemp[2] = [0, 0]

	For $i = 0 To 12
		If $PosX >= 32 + ($i * 73) And $PosX < 105 + ($i * 73) Then
			$Slottemp[0] = 37 + ($i * 73)
			$Slottemp[1] = $i
			If $CheckSlot12 = True Then
				$Slottemp[0] -= 13
			ElseIf $CheckSlotwHero = False Then
				$Slottemp[0] += 10
			EndIf
			If $g_bDebugSetlog Then SetDebugLog("Slot: " & $i & " | $x > " & 25 + ($i * 73) & " and $x < " & 98 + ($i * 73))
			If $g_bDebugSetlog Then SetDebugLog("Slot: " & $i & " | $PosX: " & $PosX & " |  OCR x position: " & $Slottemp[0] & " | OCR Slot: " & $Slottemp[1])
			Return $Slottemp
		EndIf
		If $g_bRunState = False Then Return
	Next

	Return $Slottemp

EndFunc   ;==>SlotAttack

Func ExtendedAttackBarCheck($aLastTroop1stPage, $Remaining)

	Local $x = 0, $y = 659, $x1 = 853, $y1 = 698
	Static $CheckSlotwHero2 = False
	; Setup arrays, including default return values for $return
	Local $aResult[1][6], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue
	If Not $g_bRunState Then Return
	; Capture the screen for comparison
	_CaptureRegion2($x, $y, $x1, $y1)

	Local $strinToReturn = ""
	; Perform the search
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $g_sImgAttackBarDir, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)

	If IsArray($res) Then
		If $res[0] = "0" Or $res[0] = "" Then
			SetLog("Imgloc|AttackBarCheck not found!", $COLOR_RED)
		ElseIf StringLeft($res[0], 2) = "-1" Then
			SetLog("DLL Error: " & $res[0] & ", AttackBarCheck", $COLOR_RED)
		Else
			; Get the keys for the dictionary item.
			Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

			; Redimension the result array to allow for the new entries
			ReDim $aResult[UBound($aKeys)][6]
			Local $iResultAddDup = 0

			; Loop through the array
			For $i = 0 To UBound($aKeys) - 1
				If $g_bRunState = False Then Return
				; Get the property values
				$aResult[$i + $iResultAddDup][0] = RetrieveImglocProperty($aKeys[$i], "objectname")
				; Get the coords property
				$aValue = RetrieveImglocProperty($aKeys[$i], "objectpoints")
				$aCoords = decodeMultipleCoords($aValue, 50) ; dedup coords by x on 50 pixel
				$aCoordsSplit = $aCoords[0]
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
				;;;;;;;; If exist Castle Spell ;;;;;;;
				Local $iMultipleCoords = UBound($aCoords)
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
			Next

			_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i

			For $i = 0 To UBound($aResult) - 1
				If $aResult[$i][0] = "King" Or $aResult[$i][0] = "Queen" Or $aResult[$i][0] = "Warden" Then
					$CheckSlotwHero2 = True
				EndIf
			Next

			Local $iSlotExtended = 0
			Static $iFirstExtendedSlot = -1 ; Location of 1st extended troop after drag
			If Not $Remaining Then $iFirstExtendedSlot = -1 ; Reset value for 1st time detecting troop bar

			Local $iFoundLastTroop1stPage
			Local $bStart2ndPage = False
			For $i = 0 To UBound($aResult) - 1
				Local $Slottemp
				If $aResult[$i][1] > 0 Then
					SetDebugLog("SLOT : " & $i, $COLOR_DEBUG) ;Debug
					SetDebugLog("Detection : " & $aResult[$i][0] & "|x" & $aResult[$i][1] & "|y" & $aResult[$i][2], $COLOR_DEBUG) ;Debug

					; Finding where to start the 2nd page
					If $aResult[$i][0] = $aLastTroop1stPage[0] And Not $bStart2ndPage Then
						$iFoundLastTroop1stPage += 1
						SetDebugLog("Found $aLastTroop1stPage[0]: " & $aResult[$i][0] & " x" & $iFoundLastTroop1stPage)
						If $iFoundLastTroop1stPage >= $aLastTroop1stPage[1] Then $bStart2ndPage = True
						ContinueLoop
					EndIf
					If Not $bStart2ndPage Then ContinueLoop

					$Slottemp = SlotAttack(Number($aResult[$i][1]), False, False)
					$Slottemp[0] += 18
					If $iFirstExtendedSlot = -1 Then $iFirstExtendedSlot = $Slottemp[1] ; flag only once
					$iSlotExtended = $Slottemp[1] - $iFirstExtendedSlot + 1

					If $CheckSlotwHero2 And StringInStr($aResult[$i][0], "Spell") = 0 Then $Slottemp[0] -= 14
					If $g_bRunState = False Then Return ; Stop function
					If _Sleep(20) Then Return ; Pause function
					If UBound($Slottemp) = 2 Then
						SetDebugLog("OCR : " & $Slottemp[0] & "|SLOT: " & $Slottemp[1], $COLOR_DEBUG) ;Debug
						If $aResult[$i][0] = "Castle" Or $aResult[$i][0] = "King" Or $aResult[$i][0] = "Queen" Or $aResult[$i][0] = "Warden" Or $aResult[$i][0] = "WallW" Or $aResult[$i][0] = "BattleB" Then
							$aResult[$i][3] = 1
						Else
							$aResult[$i][3] = Number(getTroopCountSmall(Number($Slottemp[0]), 640)) ; For small Numbers
							If $aResult[$i][3] = "" Or $aResult[$i][3] = 0 Then
								$aResult[$i][3] = Number(getTroopCountBig(Number($Slottemp[0]), 633)) ; For Big Numbers , when the troops is selected
							EndIf
						EndIf
						$aResult[$i][4] = ($Slottemp[1] + 11) - $iFirstExtendedSlot
					Else
						Setlog("Problem with Attack bar detection!", $COLOR_RED)
						SetLog("Detection : " & $aResult[$i][0] & "|x" & $aResult[$i][1] & "|y" & $aResult[$i][2], $COLOR_DEBUG)
						$aResult[$i][3] = -1
						$aResult[$i][4] = -1
					EndIf
					$strinToReturn &= "|" & TroopIndexLookup($aResult[$i][0]) & "#" & $aResult[$i][4] & "#" & $aResult[$i][3]
				EndIf
			Next
			If Not $Remaining Then
				$g_iTotalAttackSlot = $iSlotExtended + 10
			EndIf

			SetDebugLog("$iSlotExtended / $g_iTotalAttackSlot: " & $iSlotExtended & "/" & $g_iTotalAttackSlot)

		EndIf
	EndIf

	SetDebugLog("Extended String: " & $strinToReturn)
	Return $strinToReturn

EndFunc   ;==>ExtendedAttackBarCheck

Func DragAttackBar($iTotalSlot = 20, $bBack = False)
	If $g_iTotalAttackSlot > 10 Then $iTotalSlot = $g_iTotalAttackSlot
	Local $bAlreadyDrag = False
	If $bBack = False Then
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
