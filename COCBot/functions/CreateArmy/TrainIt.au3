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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: GetTrainPos, GetFullName, GetGemName
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TrainIt($iIndex, $iQuantity = 1, $iSleep = 400)
	If $g_bDebugSetLogTrain Then SetLog("Func TrainIt $iIndex=" & $iIndex & " $howMuch=" & $iQuantity & " $iSleep=" & $iSleep, $COLOR_DEBUG)

	For $i = 1 To 5 ; Do

		Local $aTrainPos = GetTrainPos($iIndex)
		If IsArray($aTrainPos) And $aTrainPos[0] <> -1 Then
			$g_bAllBarracksUpgd = False
			If _ColorCheck(_GetPixelColor($aTrainPos[0], $aTrainPos[1], $g_bCapturePixel), Hex($aTrainPos[2], 6), $aTrainPos[3]) Then
				TrainClickP($aTrainPos, $iQuantity, $g_iTrainClickDelay, "#0266")
				If _Sleep($iSleep) Then Return
				Return True
			Else
				ForceCaptureRegion()
				Local $sBadPixelColor = _GetPixelColor($aTrainPos[0], $aTrainPos[1], $g_bCapturePixel)
				If $g_bDebugSetLogTrain Then SetLog("Positon X: " & $aTrainPos[0] & "| Y : " & $aTrainPos[1] & " |Color get: " & $sBadPixelColor & " | Need: " & $aTrainPos[2])
				If StringMid($sBadPixelColor, 1, 2) = StringMid($sBadPixelColor, 3, 2) And StringMid($sBadPixelColor, 1, 2) = StringMid($sBadPixelColor, 5, 2) Then
					; Pixel is gray, so queue is full -> nothing to inform the user about
					SetLog("Troop " & GetTroopName($iIndex) & " is not available due to full queue", $COLOR_DEBUG)
				Else
					If Mod($i, 2) = 0 Then ; executed on $i = 2 or 4
						If $g_bDebugSetLogTrain Then SaveDebugImage("BadPixelCheck_" & GetTroopName($iIndex))
						SetLog("Bad pixel check on troop position " & GetTroopName($iIndex), $COLOR_ERROR)
						If $g_bDebugSetLogTrain Then SetLog("Train Pixel Color: " & $sBadPixelColor, $COLOR_DEBUG)
					EndIf
				EndIf
			EndIf
		Else
			If UBound($aTrainPos) > 0 And $aTrainPos[0] = -1 Then
				If $i < 5 Then
					ForceCaptureRegion()
				Else
					If $g_bDebugSetLogTrain Then SaveDebugImage("TroopIconNotFound_" & GetTroopName($iIndex))
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
	If $g_bDebugSetLogTrain Then SetLog("GetTrainPos($iIndex=" & $iIndex & ")", $COLOR_DEBUG)

	; Get the Image path to search
	If ($iIndex >= $eBarb And $iIndex <= $eFurn) Then
		Local $sFilter = String($g_asTroopShortNames[$iIndex]) & "*"
		Local $asImageToUse = _FileListToArray($g_sImgTrainTroops, $sFilter, $FLTA_FILES, True)
		If Not @error Then
			If $g_bDebugSetLogTrain Then SetLog("$asImageToUse Troops: " & _ArrayToString($asImageToUse, "|"))
			Return GetVariable($asImageToUse, $iIndex)
		Else
			Return 0
		EndIf
	EndIf

	If $iIndex >= $eLSpell And $iIndex <= $eOgSpell Then
		Local $sFilter = String($g_asSpellShortNames[$iIndex - $eLSpell]) & "*"
		Local $asImageToUse = _FileListToArray($g_sImgTrainSpells, $sFilter, $FLTA_FILES, True)
		If Not @error Then
			If $g_bDebugSetLogTrain Then SetLog("$asImageToUse Spell: " & $asImageToUse[1])
			Return GetVariable($asImageToUse, $iIndex)
		Else
			Return 0
		EndIf
	EndIf

	If $iIndex >= $eWallW And $iIndex <= $eTroopL Then
		Local $sFilter = String($g_asSiegeMachineShortNames[$iIndex - $eWallW]) & "*"
		Local $asImageToUse = _FileListToArray($g_sImgTrainSieges, $sFilter, $FLTA_FILES, True)
		If Not @error Then
			If $g_bDebugSetLogTrain Then SetLog("$asImageToUse Spell: " & $asImageToUse[1])
			Return GetVariable($asImageToUse, $iIndex)
		Else
			Return 0
		EndIf
	EndIf

	Return 0
EndFunc   ;==>GetTrainPos

Func GetVariable(Const $asImageToUse, Const $iIndex)
	Local $aTrainPos[5] = [-1, -1, -1, -1, $eBarb]
	; Capture the screen for comparison
	_CaptureRegion2(20, 478 + $g_iBottomOffsetY, 848, 650 + $g_iBottomOffsetY)

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
				If $g_bDebugSetLogTrain Then SetLog("String: " & $asResult[0])
				Local $aResult = StringSplit($asResult[0], "|", $STR_NOCOUNT)
				If UBound($aResult) > 1 Then
					Local $aCoordinates = StringSplit($aResult[1], ",", $STR_NOCOUNT)
					If UBound($aCoordinates) > 1 Then
						Local $iButtonX = 20 + Int($aCoordinates[0] - 5)
						Local $iButtonY = 478 + $g_iBottomOffsetY + Int($aCoordinates[1] + 10)
						Local $sColorToCheck = "0x" & _GetPixelColor($iButtonX, $iButtonY, $g_bCapturePixel)
						Local $iTolerance = 40
						Local $aTrainPos[5] = [$iButtonX, $iButtonY, $sColorToCheck, $iTolerance, $eBarb]
						If $g_bDebugSetLogTrain Then SetLog("Found: [" & $iButtonX & "," & $iButtonY & "]", $COLOR_SUCCESS)
						If $g_bDebugSetLogTrain Then SetLog("$sColorToCheck: " & $sColorToCheck, $COLOR_SUCCESS)
						If $g_bDebugSetLogTrain Then SetLog("$iTolerance: " & $iTolerance, $COLOR_SUCCESS)
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
