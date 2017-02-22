; #FUNCTION# ====================================================================================================================
; Name ..........: TrainIt
; Description ...: validates and sends click in barrack window to actually train troops
; Syntax ........: TrainIt($iIndex[, $howMuch = 1[, $iSleep = 400]])
; Parameters ....: $iIndex           - index of troop/spell to train from the Global Enum $eBarb, $eArch, ..., $eHaSpell, $eSkSpell
;                  $howMuch          - [optional] how many to train Default is 1.
;                  $iSleep           - [optional] delay value after click. Default is 400.
; Return values .: None
; Author ........:
; Modified ......: KnowJack(July 2015), MonkeyHunter (05-2016), ProMac (01-2017), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: GetTrainPos, GetFullName, GetGemName
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TrainIt($iIndex, $howMuch = 1, $iSleep = 400)
	If $g_iDebugSetlogTrain = 1 Then SetLog("Func TrainIt $iIndex=" & $iIndex & " $howMuch=" & $howMuch & " $iSleep=" & $iSleep, $COLOR_DEBUG)
	Local $bDark = ($iIndex >= $eMini And $iIndex <= $eBowl)

	Local $pos = GetTrainPos($iIndex)
	If IsArray($pos) And $pos[0] <> -1 Then
		If _ColorCheck(_GetPixelColor($pos[0], $pos[1], $g_bCapturePixel), Hex($pos[2], 6), $pos[3]) = True Then
			Local $FullName = GetFullName($iIndex, $pos)
			If IsArray($FullName) Then
				Local $RNDName = GetRNDName($iIndex, $pos)
				If IsArray($RNDName) Then
					TrainClickP($pos, $howMuch, $g_iTrainClickDelay, $FullName, "#0266", $RNDName)
					If _Sleep($iSleep) Then Return False
					If $OutOfElixir = 1 Then
						Setlog("Not enough " & ($bDark ? "Dark " : "") & "Elixir to train position " & GetTroopName($iIndex) & " troops!", $COLOR_ERROR)
						Setlog("Switching to Halt Attack, Stay Online Mode...", $COLOR_ERROR)
						$g_bChkBotStop = True ; set halt attack variable
						$g_iCmbBotCond = 18 ; set stay online
						If Not ($fullarmy = True) Then $g_bRestart = True ;If the army camp is full, If yes then use it to refill storages
						Return ; We are out of Elixir stop training.
					EndIf
					Return True
				Else
					Setlog("TrainIt position " & GetTroopName($iIndex) & " - RNDName did not return array?", $COLOR_ERROR)
				EndIf
			Else
				Setlog("TrainIt " & GetTroopName($iIndex) & " - FullName did not return array?", $COLOR_ERROR)
			EndIf
		Else
			Local $badPixelColor = _GetPixelColor($pos[0], $pos[1], $g_bCapturePixel)
			If $g_iDebugSetlogTrain Then Setlog("Positon X: " & $pos[0] & "| Y : " & $pos[1] & " |Color get: " & $badPixelColor & " | Need: " & $pos[2])
			If StringMid($badPixelColor, 1, 2) = StringMid($badPixelColor, 3, 2) And StringMid($badPixelColor, 1, 2) = StringMid($badPixelColor, 5, 2) Then
				; Pixel is gray, so queue is full -> nothing to inform the user about
				Setlog("Troop " & GetTroopName($iIndex) & " is not available due to full queue", $COLOR_DEBUG)
			Else
				Setlog("Bad pixel check on troop position " & GetTroopName($iIndex), $COLOR_ERROR)
				If $g_iDebugSetlogTrain = 1 Then Setlog("Train Pixel Color: " & $badPixelColor, $COLOR_DEBUG)
			EndIf
		EndIf
	Else
		Setlog("Impossible happened? TrainIt troop position " & GetTroopName($iIndex) & " did not return array", $COLOR_ERROR)
	EndIf
EndFunc   ;==>TrainIt

;
; Support functions to TrainIt that take troop name and generate the proper variable name
;


; This a IMPORTANT function , on first Train loop will update the $Train'troops' Global variables
; Assigning the correct positions slot x and y on Train window , checking if available to train or not present

Func GetTrainPos(Const $iIndex)
	If $g_iDebugSetlogTrain = 1 Then SetLog("Func GetTrainPos $iIndex=" & $iIndex, $COLOR_DEBUG)

	; Get the Image path to search
	If $iIndex >= $eBarb And $iIndex <= $eBowl Then
	   Local $sDirectory = @ScriptDir & "\imgxml\Train\Train_Train\"
	   Local $sFilter = String($g_asTroopShortNames[$iIndex]) & "*"
	   Local $asImageToUse = _FileListToArray($sDirectory, $sFilter, $FLTA_FILES, True)
	   If $g_iDebugSetlogTrain Then setlog("$asImageToUse Troops: " & $asImageToUse[1])
	   Return GetVariable($asImageToUse[1], $iIndex)
    EndIf

	If $iIndex >= $eLSpell And $iIndex <= $eSkSpell Then
	   Local $sDirectory = @ScriptDir & "\imgxml\Train\Spell_Train\"
	   Local $sFilter = String($g_asSpellShortNames[$iIndex - $eLSpell]) & "*"
	   Local $asImageToUse = _FileListToArray($sDirectory, $sFilter, $FLTA_FILES, True)
	   If $g_iDebugSetlogTrain Then setlog("$asImageToUse Spell: " & $asImageToUse[1])
	   Return GetVariable($asImageToUse[1], $iIndex)
    EndIf

	Return 0
EndFunc   ;==>GetTrainPos

; This a IMPORTANT function , on first Train loop will update the $Full'troops' Global variables
; Assigning the correct positions slot of if [i] symbol on Train window , checking if is blue ( available to train) or gray (disable to train)
Func GetFullName(Const $iIndex, Const $pos)
	If $g_iDebugSetlogTrain = 1 Then SetLog("Func GetFullName $iIndex=" & $iIndex, $COLOR_DEBUG)

	If $iIndex >= $eBarb And $iIndex <= $eBowl Then
	   Local $text = ($iIndex >= $eMini ? "Dark" : "Normal")
	   If $g_iDebugSetlogTrain = 1 Then Setlog("Troop Name: " & $g_asTroopNames[$iIndex])
	   Return GetFullNameSlot($pos, $text)
    EndIf

	If $iIndex >= $eLSpell And $iIndex <= $eSkSpell Then
	   Return GetFullNameSlot($pos, "Spell")
    EndIf

    SetLog("Don't know how to find the full name of troop with index " & $iIndex & " yet")
	Local $slotTemp[4] = [-1, -1, -1, -1]
	Return $slotTemp
EndFunc   ;==>GetFullName


Func GetRNDName(Const $iIndex, Const $pos)
	If $g_iDebugSetlogTrain = 1 Then SetLog("Func GetRNDName $iIndex=" & $iIndex, $COLOR_DEBUG)
	Local $aReturn[4]

	If $iIndex <> -1 Then
	  Local $aTempCoord = $pos
	  $aReturn[0] = $aTempCoord[0] - 5
	  $aReturn[1] = $aTempCoord[1] - 5
	  $aReturn[2] = $aTempCoord[0] + 5
	  $aReturn[3] = $aTempCoord[1] + 5
	  Return $aReturn
    EndIf

    SetLog("Don't know how to find the RND name of troop with index " & $iIndex & " yet!", $COLOR_ERROR)
	Return 0
EndFunc   ;==>GetRNDName

; Function to use on GetTrainPos() , proceeds with imgloc on train window
Func GetVariable(Const $ImageToUse, Const $iIndex)
	Local $FinalVariable[4] = [-1, -1, -1, -1]
	; Capture the screen for comparison
	_CaptureRegion2(25, 375, 840, 548)

	Local $res = DllCall($g_hLibImgLoc, "str", "FindTile", "handle", $hHBitmap2, "str", $ImageToUse, "str", "FV", "int", 1)

	If @error Then _logErrorDLLCall($g_sLibImgLocPath, @error)
	If IsArray($res) Then
		If $g_iDebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_ERROR)
		If $res[0] = "0" Then
			; failed to find a train icon on the field
			SetLog("No " & GetTroopName($iIndex) & " Icon found!", $COLOR_ERROR)
		ElseIf $res[0] = "-1" Then
			SetLog("DLL Error", $COLOR_ERROR)
		ElseIf $res[0] = "-2" Then
			SetLog("Invalid Resolution", $COLOR_ERROR)
		Else
			If $g_iDebugSetlogTrain Then Setlog("String: " & $res[0])
			Local $expRet = StringSplit($res[0], "|", $STR_NOCOUNT)
			Local $posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
			Local $ButtonX = 25 + Int($posPoint[0])
			Local $ButtonY = 375 + Int($posPoint[1])
			Local $Colorcheck = "0x" & _GetPixelColor($ButtonX, $ButtonY, $g_bCapturePixel)
			Local $Tolerance = 40
			Local $FinalVariable[4] = [$ButtonX, $ButtonY, $Colorcheck, $Tolerance]
			SetLog(" - " & GetTroopName($iIndex) & " Icon found!", $COLOR_SUCCESS)
			If $g_iDebugSetlogTrain Then SetLog("Found: [" & $ButtonX & "," & $ButtonY & "]", $COLOR_SUCCESS)
			If $g_iDebugSetlogTrain Then SetLog("Color check: " & $Colorcheck, $COLOR_SUCCESS)
			If $g_iDebugSetlogTrain Then SetLog("$Tolerance: " & $Tolerance, $COLOR_SUCCESS)
			Return $FinalVariable
		EndIf
	Else
		SetLog("Don't know how to train the troop with index " & $iIndex & " yet")
	EndIf
	Return $FinalVariable
EndFunc   ;==>GetVariable


; Function to use on GetFullName() , returns slot and correct [i] symbols position on train window
Func GetFullNameSlot(Const $iTrainPos, Const $sTroopType)

	Local $SlotH, $SlotV
	If $g_iDebugSetlogTrain Then Setlog("$iTrainPos[0]: " & $iTrainPos[0])
	If $g_iDebugSetlogTrain Then Setlog("$iTrainPos[1]: " & $iTrainPos[1])
	If $g_iDebugSetlogTrain Then Setlog("$sTroopType" & $sTroopType)

	If $sTroopType = "Spell" Then
		If UBound($iTrainPos) < 2 Then Setlog("Issue on $iTrainPos!!!")
		Switch $iTrainPos[0]
			Case $iTrainPos[0] < 101 ; 1 Column
				$SlotH = 101
			Case $iTrainPos[0] > 105 And $iTrainPos[0] < 199 ; 2 Column
				$SlotH = 199
			Case $iTrainPos[0] > 203 And $iTrainPos[0] < 297 ; 3 Column
				$SlotH = 297
			Case $iTrainPos[0] > 302 And $iTrainPos[0] < 395 ; 4 Column
				$SlotH = 404
			Case $iTrainPos[0] > 400 And $iTrainPos[0] < 498 ; 5 Column
				$SlotH = 502
			Case $iTrainPos[0] > 498 And $iTrainPos[0] < 597 ; 6 Column
				$SlotH = 597
			Case Else
				If _ColorCheck(_GetPixelColor($iTrainPos[0], $iTrainPos[1], True), Hex(0xd3d3cb, 6), 5) Then
					Setlog(" »» This slot is empty!! | Spells", $COLOR_ERROR)
				EndIf
		EndSwitch
		Switch $iTrainPos[1]
			Case $iTrainPos[1] < 445
				$SlotV = 387 ; First ROW
			Case $iTrainPos[1] > 445 And $iTrainPos[1] < 550 ; Second ROW
				$SlotV = 488
		EndSwitch
		Local $ToReturn[4] = [$SlotH, $SlotV, 0x9d9d9d, 20] ; Gray [i] icon
		If $g_iDebugSetlogTrain Then SetLog(" » GetFullNameSlot Spell Icon found!", $COLOR_SUCCESS)
		If $g_iDebugSetlogTrain Then SetLog("Full Train Found: [" & $SlotH & "," & $SlotV & "]", $COLOR_SUCCESS)
		Return $ToReturn
	EndIf

	If $sTroopType = "Normal" Then
		If UBound($iTrainPos) < 2 Then Setlog("Issue on $iTrainPos!!!")
		Switch $iTrainPos[0]
			Case $iTrainPos[0] < 101 ; 1 Column
				$SlotH = 101
			Case $iTrainPos[0] > 105 And $iTrainPos[0] < 199 ; 2 Column
				$SlotH = 199
			Case $iTrainPos[0] > 199 And $iTrainPos[0] < 297 ; 3 Column
				$SlotH = 297
			Case $iTrainPos[0] > 297 And $iTrainPos[0] < 395 ; 4 Column
				$SlotH = 395
			Case $iTrainPos[0] > 395 And $iTrainPos[0] < 494 ; 5 Column
				$SlotH = 494
			Case $iTrainPos[0] > 494 And $iTrainPos[0] < 592 ; 6 Column
				$SlotH = 592
			Case $iTrainPos[0] > 592 And $iTrainPos[0] < 690 ; 7 Column
				$SlotH = 690
			Case Else
				If _ColorCheck(_GetPixelColor($iTrainPos[0], $iTrainPos[1], True), Hex(0xd3d3cb, 6), 5) Then
					Setlog(" »» This slot is empty!! | Normal Troop", $COLOR_ERROR)
				EndIf
		EndSwitch
		Switch $iTrainPos[1]
			Case $iTrainPos[1] < 445
				$SlotV = 387 ; First ROW
			Case $iTrainPos[1] > 445 And $iTrainPos[1] < 550 ; Second ROW
				$SlotV = 488
		EndSwitch
		Local $ToReturn[4] = [$SlotH, $SlotV, 0x9f9f9f, 20] ; Gray [i] icon
		If $g_iDebugSetlogTrain Then SetLog(" » GetFullNameSlot Normal Icon found!", $COLOR_SUCCESS)
		If $g_iDebugSetlogTrain Then SetLog("Full Train Found: [" & $SlotH & "," & $SlotV & "]", $COLOR_SUCCESS)
		Return $ToReturn
	EndIf

	If $sTroopType = "Dark" Then
		If UBound($iTrainPos) < 2 Then Setlog("Issue on $iTrainPos!!!")
		Switch $iTrainPos[0]
			Case $iTrainPos[0] > 440 And $iTrainPos[0] < 517
				$SlotH = 517
			Case $iTrainPos[0] > 517 And $iTrainPos[0] < 615
				$SlotH = 615
			Case $iTrainPos[0] > 615 And $iTrainPos[0] < 714
				$SlotH = 714
			Case $iTrainPos[0] > 714 And $iTrainPos[0] < 812
				$SlotH = 812
			Case Else
				If _ColorCheck(_GetPixelColor($iTrainPos[0], $iTrainPos[1], True), Hex(0xd3d3cb, 6), 5) Then
					Setlog(" »» This slot is empty!! | Dark Troop", $COLOR_ERROR)
				EndIf
		EndSwitch
		Switch $iTrainPos[1]
			Case $iTrainPos[1] < 445
				$SlotV = 397 ; First ROW
			Case $iTrainPos[1] > 445 And $iTrainPos[1] < 550 ; Second ROW
				$SlotV = 498
		EndSwitch
		Local $ToReturn[4] = [$SlotH, $SlotV, 0x9f9f9f, 20] ; Gray [i] icon
		If $g_iDebugSetlogTrain Then SetLog(" » GetFullNameSlot Dark Icon found!", $COLOR_SUCCESS)
		If $g_iDebugSetlogTrain Then SetLog("Full Train Found: [" & $SlotH & "," & $SlotV & "]", $COLOR_SUCCESS)
		Return $ToReturn
	EndIf

EndFunc   ;==>GetFullNameSlot
