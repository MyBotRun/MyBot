; #FUNCTION# ====================================================================================================================
; Name ..........: TrainIt
; Description ...: validates and sends click in barrack window to actually train troops
; Syntax ........: TrainIt($iIndex[, $howMuch = 1[, $iSleep = 400]])
; Parameters ....: $iIndex           - index of troop/spell to train from the Global Enum $eBarb, $eArch, ..., $eHaSpell, $eSkSpell
;                  $howMuch          - [optional] how many to train Default is 1.
;                  $iSleep           - [optional] delay value after click. Default is 400.
; Return values .: None
; Author ........:
; Modified ......: KnowJack(07-2015), MonkeyHunter (05-2016), ProMac (01-2018), CodeSlinger69 (01-2018), Moebius14 (06-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: GetTrainPos, GetFullName, GetGemName
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TrainIt($iIndex, $iQuantity = 1, $iSleep = 400)
	If $g_bDebugSetlogTrain Then SetLog("Func TrainIt $iIndex=" & $iIndex & " $howMuch=" & $iQuantity & " $iSleep=" & $iSleep, $COLOR_DEBUG)
	Local $bDark = ($iIndex >= $eMini And $iIndex <= $eAppWard)

	For $i = 1 To 5 ; Do

		Local $aTrainPos = GetTrainPos($iIndex)
		If IsArray($aTrainPos) And $aTrainPos[0] <> -1 Then
			$g_bAllBarracksUpgd = False
			If _ColorCheck(_GetPixelColor($aTrainPos[0], $aTrainPos[1], $g_bCapturePixel), Hex($aTrainPos[2], 6), $aTrainPos[3]) Then
				Local $FullName = GetFullName($iIndex, $aTrainPos)
				If IsArray($FullName) Then
					Local $RNDName = GetRNDName($iIndex, $aTrainPos)
					If IsArray($RNDName) Then
						TrainClickP($aTrainPos, $iQuantity, $g_iTrainClickDelay, $FullName, "#0266", $RNDName)
						If _Sleep($iSleep) Then Return
						If $g_bOutOfElixir Then
							SetLog("Not enough " & ($bDark ? "Dark " : "") & "Elixir to train position " & GetTroopName($iIndex) & " troops!", $COLOR_ERROR)
							SetLog("Switching to Halt Attack, Stay Online Mode", $COLOR_ERROR)
							If Not $g_bFullArmy Then $g_bRestart = True ;If the army camp is full, If yes then use it to refill storages
							Return ; We are out of Elixir stop training.
						EndIf
						Return True
					Else
						SetLog("TrainIt position " & GetTroopName($iIndex) & " - RNDName did not return array?", $COLOR_ERROR)
						Return False
					EndIf
				Else
					SetLog("TrainIt " & GetTroopName($iIndex) & " - FullName did not return array?", $COLOR_ERROR)
					Return False
				EndIf
			Else
				ForceCaptureRegion()
				Local $sBadPixelColor = _GetPixelColor($aTrainPos[0], $aTrainPos[1], $g_bCapturePixel)
				If $g_bDebugSetlogTrain Then SetLog("Positon X: " & $aTrainPos[0] & "| Y : " & $aTrainPos[1] & " |Color get: " & $sBadPixelColor & " | Need: " & $aTrainPos[2])
				If StringMid($sBadPixelColor, 1, 2) = StringMid($sBadPixelColor, 3, 2) And StringMid($sBadPixelColor, 1, 2) = StringMid($sBadPixelColor, 5, 2) Then
					; Pixel is gray, so queue is full -> nothing to inform the user about
					SetLog("Troop " & GetTroopName($iIndex) & " is not available due to full queue", $COLOR_DEBUG)
				Else
					If Mod($i, 2) = 0 Then ; executed on $i = 2 or 4
						If $g_bDebugSetlogTrain Then SaveDebugImage("BadPixelCheck_" & GetTroopName($iIndex))
						SetLog("Bad pixel check on troop position " & GetTroopName($iIndex), $COLOR_ERROR)
						If $g_bDebugSetlogTrain Then SetLog("Train Pixel Color: " & $sBadPixelColor, $COLOR_DEBUG)
					EndIf
				EndIf
			EndIf
		Else
			If UBound($aTrainPos) > 0 And $aTrainPos[0] = -1 Then
				If $i < 5 Then
					ForceCaptureRegion()
				Else
					If $g_bDebugSetlogTrain Then SaveDebugImage("TroopIconNotFound_" & GetTroopName($iIndex))
					SetLog("TrainIt troop position " & GetTroopName($iIndex) & " did not find icon", $COLOR_ERROR)
					If $i = 5 Then
						SetLog("Seems all your barracks are upgrading!", $COLOR_ERROR)
						$g_bAllBarracksUpgd = True
					EndIf
				EndIf
			Else
				SetLog("Impossible happened? TrainIt troop position " & GetTroopName($iIndex) & " did not return array", $COLOR_ERROR)
			EndIf
		EndIf

	Next ; Until $iErrors = 0
EndFunc   ;==>TrainIt

Func GetTrainPos(Const $iIndex)
	If $g_bDebugSetlogTrain Then SetLog("GetTrainPos($iIndex=" & $iIndex & ")", $COLOR_DEBUG)

	; Get the Image path to search
	If ($iIndex >= $eBarb And $iIndex <= $eAppWard) Then
		Local $sFilter = String($g_asTroopShortNames[$iIndex]) & "*"
		Local $asImageToUse = _FileListToArray($g_sImgTrainTroops, $sFilter, $FLTA_FILES, True)
		If Not @error Then
			If $g_bDebugSetlogTrain Then SetLog("$asImageToUse Troops: " & _ArrayToString($asImageToUse, "|"))
			Return GetVariable($asImageToUse, $iIndex)
		Else
			Return 0
		EndIf
	EndIf

	If $iIndex >= $eLSpell And $iIndex <= $eOgSpell Then
		Local $sFilter = String($g_asSpellShortNames[$iIndex - $eLSpell]) & "*"
		Local $asImageToUse = _FileListToArray($g_sImgTrainSpells, $sFilter, $FLTA_FILES, True)
		If Not @error Then
			If $g_bDebugSetlogTrain Then SetLog("$asImageToUse Spell: " & $asImageToUse[1])
			Return GetVariable($asImageToUse, $iIndex)
		Else
			Return 0
		EndIf
	EndIf

	Return 0
EndFunc   ;==>GetTrainPos

Func GetFullName(Const $iIndex, Const $aTrainPos)
	If $g_bDebugSetlogTrain Then SetLog("GetFullName($iIndex=" & $iIndex & ")", $COLOR_DEBUG)

	If $iIndex >= $eBarb And $iIndex <= $eAppWard Then
		Local $sTroopType = ($iIndex >= $eMini ? "Dark" : "Normal")
		Return GetFullNameSlot($aTrainPos, $sTroopType, $iIndex)
	EndIf

	If $iIndex >= $eLSpell And $iIndex <= $eOgSpell Then
		Return GetFullNameSlot($aTrainPos, "Spell")
	EndIf

	SetLog("Don't know how to find the full name of troop with index " & $iIndex & " yet")

	Local $aTempSlot[4] = [-1, -1, -1, -1]

	Return $aTempSlot
EndFunc   ;==>GetFullName

Func GetRNDName(Const $iIndex, Const $aTrainPos)
	If $g_bDebugSetlogTrain Then SetLog("GetRNDName($iIndex=" & $iIndex & ")", $COLOR_DEBUG)
	Local $aTrainPosRND[4]

	If $iIndex <> -1 Then
		Local $aTempCoord = $aTrainPos
		$aTrainPosRND[0] = $aTempCoord[0] - 5
		$aTrainPosRND[1] = $aTempCoord[1] - 5
		$aTrainPosRND[2] = $aTempCoord[0] + 5
		$aTrainPosRND[3] = $aTempCoord[1] + 5
		Return $aTrainPosRND
	EndIf

	SetLog("Don't know how to find the RND name of troop with index " & $iIndex & " yet!", $COLOR_ERROR)
	Return 0
EndFunc   ;==>GetRNDName

Func GetVariable(Const $asImageToUse, Const $iIndex)
	Local $aTrainPos[5] = [-1, -1, -1, -1, $eBarb]
	; Capture the screen for comparison
	_CaptureRegion2(35, 345 + $g_iMidOffsetY, 835, 538 + $g_iMidOffsetY)

	Local $iError = ""
	For $i = 1 To $asImageToUse[0]

		Local $asResult = DllCallMyBot("FindTile", "handle", $g_hHBitmap2, "str", $asImageToUse[$i], "str", "FV", "int", 1)

		If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error)

		If IsArray($asResult) Then
			If $asResult[0] = "0" Then
				$iError = 0
			ElseIf $asResult[0] = "-1" Then
				$iError = -1
			ElseIf $asResult[0] = "-2" Then
				$iError = -2
			Else
				If $g_bDebugSetlogTrain Then SetLog("String: " & $asResult[0])
				Local $aResult = StringSplit($asResult[0], "|", $STR_NOCOUNT)
				If UBound($aResult) > 1 Then
					Local $aCoordinates = StringSplit($aResult[1], ",", $STR_NOCOUNT)
					If UBound($aCoordinates) > 1 Then
						Local $iButtonX = 25 + Int($aCoordinates[0])
						Local $iButtonY = 375 + Int($aCoordinates[1])
						Local $sColorToCheck = "0x" & _GetPixelColor($iButtonX, $iButtonY, $g_bCapturePixel)
						Local $iTolerance = 40
						Local $aTrainPos[5] = [$iButtonX, $iButtonY, $sColorToCheck, $iTolerance, $eBarb]
						If $g_bDebugSetlogTrain Then SetLog("Found: [" & $iButtonX & "," & $iButtonY & "]", $COLOR_SUCCESS)
						If $g_bDebugSetlogTrain Then SetLog("$sColorToCheck: " & $sColorToCheck, $COLOR_SUCCESS)
						If $g_bDebugSetlogTrain Then SetLog("$iTolerance: " & $iTolerance, $COLOR_SUCCESS)
						Return $aTrainPos
					Else
						SetLog("Don't know how to train the troop with index " & $iIndex & " yet.")
					EndIf
				Else
					SetLog("Don't know how to train the troop with index " & $iIndex & " yet")
				EndIf
			EndIf
		Else
			SetLog("Don't know how to train the troop with index " & $iIndex & " yet")
		EndIf
	Next

	If $iError = 0 Then
		SetLog("No " & GetTroopName($iIndex) & " Icon found!", $COLOR_ERROR)
	ElseIf $iError = -1 Then
		SetLog("TrainIt.au3 GetVariable(): ImgLoc DLL Error Occured!", $COLOR_ERROR)
	ElseIf $iError = -2 Then
		SetLog("TrainIt.au3 GetVariable(): Wrong Resolution used for ImgLoc Search!", $COLOR_ERROR)
	EndIf

	Return $aTrainPos
EndFunc   ;==>GetVariable

; Function to use on GetFullName() , returns slot and correct [i] symbols position on train window
Func GetFullNameSlot(Const $iTrainPos, Const $sTroopType, $iTroop = $eBarb)

	Local $iSlotH, $iSlotV

	If $sTroopType = "Spell" Then
		Switch $iTrainPos[0]
			Case 78 To 162 ; 1 Column
				$iSlotH = 144
			Case 163 To 246     ; 2 Column
				$iSlotH = 229
			Case 247 To 331     ; 3 Column
				$iSlotH = 313
			Case 332 To 419     ; 4 Column
				$iSlotH = 398
			Case 420 To 507     ; 5 Column
				$iSlotH = 489
			Case 508 To 592     ; 6 Column
				$iSlotH = 574
			Case 593 To 677     ; 7 Column
				$iSlotH = 658
			Case Else
				If _ColorCheck(_GetPixelColor($iTrainPos[0], $iTrainPos[1], True), Hex(0xD3D3CB, 6), 5) Then
					SetLog("GetFullNameSlot(): It seems that there is no Slot for an Spell on: " & $iTrainPos[0] & "," & $iTrainPos[1] & "!", $COLOR_ERROR)
				EndIf
		EndSwitch

		Switch $iTrainPos[1]
			Case 375 To 460
				$iSlotV = 387 ; First ROW
			Case 465 To 545 ; Second ROW
				$iSlotV = 475
		EndSwitch

		Local $aSlot[4] = [$iSlotH, $iSlotV, 0xBABABA, 20] ; Gray [i] icon
		If $g_bDebugSetlogTrain Then SetLog("GetFullNameSlot(): Spell Icon found on: " & $iSlotH & "," & $iSlotV, $COLOR_DEBUG)
		Return $aSlot
	EndIf

	If $sTroopType = "Normal" Then

		If $iTroop > $g_iNextPageTroop Then ; Normal Troops in second page
			If $g_iNextPageTroop > $eMine Then ; Classic position
				Switch $iTrainPos[0]
					Case 98 To 178 ; 1 Column
						$iSlotH = 162
					Case 182 To 262 ; 2 Column
						$iSlotH = 246
					Case 270 To 350 ; 3 Column
						$iSlotH = 330
					Case Else
						If _ColorCheck(_GetPixelColor($iTrainPos[0], $iTrainPos[1], True), Hex(0xD3D3CB, 6), 5) Then
							SetLog("GetFullNameSlot(): It seems that there is no Slot for an Elixir Troop on: " & $iTrainPos[0] & "," & $iTrainPos[1] & "!", $COLOR_ERROR)
						EndIf
				EndSwitch
			Else
				If $iTroop >= $eEDrag Or $iTroop <= $eRootR Then ; Case Moved 4 slots or more at first page And $iTroop = Edrag Or Yeti
					Switch $iTrainPos[0]
						Case 91 To 171 ; 1 Column
							$iSlotH = 155
						Case 177 To 257 ; 2 Column
							$iSlotH = 241
						Case 262 To 342 ; 3 Column
							$iSlotH = 326
						Case 346 To 426 ; 4 Column
							$iSlotH = 410
						Case 432 To 512 ; 5 Column
							$iSlotH = 496
						Case Else
							If _ColorCheck(_GetPixelColor($iTrainPos[0], $iTrainPos[1], True), Hex(0xD3D3CB, 6), 5) Then
								SetLog("GetFullNameSlot(): It seems that there is no Slot for an Elixir Troop on: " & $iTrainPos[0] & "," & $iTrainPos[1] & "!", $COLOR_ERROR)
							EndIf
					EndSwitch
				Else ; Case Moved 4 slots or more at first page And $iTroop <> Edrag Or Yeti
					Switch $iTrainPos[0]
						Case 98 To 178 ; 1 Column
							$iSlotH = 162
						Case 182 To 262 ; 2 Column
							$iSlotH = 246
						Case 266 To 346 ; 3 Column
							$iSlotH = 331
						Case 350 To 430 ; 4 Column
							$iSlotH = 415
						Case Else
							If _ColorCheck(_GetPixelColor($iTrainPos[0], $iTrainPos[1], True), Hex(0xD3D3CB, 6), 5) Then
								SetLog("GetFullNameSlot(): It seems that there is no Slot for an Elixir Troop on: " & $iTrainPos[0] & "," & $iTrainPos[1] & "!", $COLOR_ERROR)
							EndIf
					EndSwitch
				EndIf
			EndIf
		Else ; First Page
			Switch $iTrainPos[0]
				Case 78 To 160 ; 1 Column
					$iSlotH = 143
				Case 164 To 245 ; 2 Column
					$iSlotH = 228
				Case 248 To 328 ; 3 Column
					$iSlotH = 312
				Case 334 To 414 ; 4 Column
					$iSlotH = 397
				Case 417 To 498 ; 5 Column
					$iSlotH = 481
				Case 502 To 583 ; 6 Column
					$iSlotH = 565
				Case 585 To 667 ; 7 Column
					$iSlotH = 650
				Case 670 To 752 ; 8 Column
					$iSlotH = 734
				Case Else
					If _ColorCheck(_GetPixelColor($iTrainPos[0], $iTrainPos[1], True), Hex(0xD3D3CB, 6), 5) Then
						SetLog("GetFullNameSlot(): It seems that there is no Slot for an Elixir Troop on: " & $iTrainPos[0] & "," & $iTrainPos[1] & "!", $COLOR_ERROR)
					EndIf
			EndSwitch
		EndIf

		Switch $iTrainPos[1]
			Case 375 To 460
				$iSlotV = 387 ; First ROW
			Case 465 To 545 ; Second ROW
				$iSlotV = 475
		EndSwitch

		Local $aSlot[4] = [$iSlotH, $iSlotV, 0xBABABA, 20] ; Gray [i] icon
		If $g_bDebugSetlogTrain Then SetLog("GetFullNameSlot(): Elixir Troop Icon found on: " & $iSlotH & "," & $iSlotV, $COLOR_DEBUG)

		Return $aSlot
	EndIf

	If $sTroopType = "Dark" Then
		Switch $g_iNextPageTroop
			Case $eETitan, $eRDrag ; No Move And Moved 1 slot
				Switch $iTrainPos[0]
					Case 182 To 262 ; When 2 Dark Super Troops
						$iSlotH = 246
					Case 268 To 349
						$iSlotH = 333
					Case 354 To 434
						$iSlotH = 418
					Case 438 To 518
						$iSlotH = 502
					Case 522 To 604
						$iSlotH = 586
					Case 608 To 688
						$iSlotH = 671
					Case 697 To 774
						$iSlotH = 755
					Case Else
						If _ColorCheck(_GetPixelColor($iTrainPos[0], $iTrainPos[1], True), Hex(0xD3D3CB, 6), 5) Then
							SetLog("GetFullNameSlot(): It seems that there is no Slot for a Dark Elixir Troop on: " & $iTrainPos[0] & "," & $iTrainPos[1] & "!", $COLOR_ERROR)
						EndIf
				EndSwitch
			Case $eYeti, $eEDrag ; Moved 2 or 3 slots
				Switch $iTrainPos[0]
					Case 186 To 266
						$iSlotH = 250
					Case 271 To 351
						$iSlotH = 335
					Case 356 To 436
						$iSlotH = 419
					Case 440 To 520
						$iSlotH = 504
					Case 525 To 605
						$iSlotH = 588
					Case 609 To 689
						$iSlotH = 673
					Case 694 To 773
						$iSlotH = 758
					Case Else
						If _ColorCheck(_GetPixelColor($iTrainPos[0], $iTrainPos[1], True), Hex(0xD3D3CB, 6), 5) Then
							SetLog("GetFullNameSlot(): It seems that there is no Slot for a Dark Elixir Troop on: " & $iTrainPos[0] & "," & $iTrainPos[1] & "!", $COLOR_ERROR)
						EndIf
				EndSwitch
			Case $eMine, $eSMine, $eBabyD ; Moved 4 or 5 slots
				Switch $iTrainPos[0]
					Case 268 To 349
						$iSlotH = 333
					Case 354 To 434
						$iSlotH = 418
					Case 438 To 518
						$iSlotH = 502
					Case 522 To 604
						$iSlotH = 586
					Case 608 To 688
						$iSlotH = 671
					Case 697 To 774
						$iSlotH = 755
					Case Else
						If _ColorCheck(_GetPixelColor($iTrainPos[0], $iTrainPos[1], True), Hex(0xD3D3CB, 6), 5) Then
							SetLog("GetFullNameSlot(): It seems that there is no Slot for a Dark Elixir Troop on: " & $iTrainPos[0] & "," & $iTrainPos[1] & "!", $COLOR_ERROR)
						EndIf
				EndSwitch
			Case $ePekk ; Moved 6 slots
				Switch $iTrainPos[0]
					Case 354 To 434
						$iSlotH = 418
					Case 438 To 518
						$iSlotH = 502
					Case 522 To 604
						$iSlotH = 586
					Case 608 To 688
						$iSlotH = 671
					Case 697 To 774
						$iSlotH = 755
					Case Else
						If _ColorCheck(_GetPixelColor($iTrainPos[0], $iTrainPos[1], True), Hex(0xD3D3CB, 6), 5) Then
							SetLog("GetFullNameSlot(): It seems that there is no Slot for a Dark Elixir Troop on: " & $iTrainPos[0] & "," & $iTrainPos[1] & "!", $COLOR_ERROR)
						EndIf
				EndSwitch
		EndSwitch

		Switch $iTrainPos[1]
			Case 375 To 460
				$iSlotV = 387 ; First ROW
			Case 465 To 545 ; Second ROW
				$iSlotV = 475
		EndSwitch

		Local $aSlot[4] = [$iSlotH, $iSlotV, 0xBABABA, 20] ; Gray [i] icon
		If $g_bDebugSetlogTrain Then SetLog("GetFullNameSlot(): Dark Elixir Troop Icon found on: " & $iSlotH & "," & $iSlotV, $COLOR_DEBUG)
		Return $aSlot
	EndIf

EndFunc   ;==>GetFullNameSlot
