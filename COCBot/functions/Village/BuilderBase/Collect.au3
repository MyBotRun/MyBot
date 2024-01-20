; #FUNCTION# ====================================================================================================================
; Name ..........: Collect
; Description ...:
; Syntax ........: CollectBuilderBase()
; Parameters ....:
; Return values .: None
; Author ........: Fliegerfaust (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func CollectBuilderBase($bSwitchToBB = False, $bSwitchToNV = False, $bSetLog = True, $IsOttoVillage = False)

	If Not $g_bChkCollectBuilderBase Then Return
	If Not $g_bRunState Then Return

	If $bSwitchToBB Then
		ClickAway()
		If Not SwitchBetweenBases(True, True) Then Return ; Switching to Builders Base
	EndIf

	If $bSetLog Then
		If $IsOttoVillage Then
			SetLog("Collecting Resources on Otto Village", $COLOR_INFO)
		Else
			SetLog("Collecting Resources on Builders Base", $COLOR_INFO)
		EndIf
	EndIf
	If _Sleep($DELAYCOLLECT2) Then Return

	; Collect function to Parallel Search , will run all pictures inside the directory
	; Setup arrays, including default return values for $return
	Local $sFilename = ""
	Local $aCollectXY, $t

	Local $aResult = multiMatches($g_sImgCollectRessourcesBB, 0, $CocDiamondDCD, $CocDiamondDCD)

	If UBound($aResult) > 1 Then ; we have an array with data of images found
		For $i = 1 To UBound($aResult) - 1  ; loop through array rows
			$sFilename = $aResult[$i][1] ; Filename
			$aCollectXY = $aResult[$i][5] ; Coords
			If IsArray($aCollectXY) Then ; found array of locations
				$t = Random(0, UBound($aCollectXY) - 1, 1) ; SC May 2017 update only need to pick one of each to collect all
				If $g_bDebugSetlog Then SetDebugLog($sFilename & " found, random pick(" & $aCollectXY[$t][0] & "," & $aCollectXY[$t][1] & ")", $COLOR_SUCCESS)
				If IsMainPageBuilderBase() Then Click($aCollectXY[$t][0], $aCollectXY[$t][1], 1, 0, "#0430")
				If _Sleep($DELAYCOLLECT2) Then Return
			EndIf
		Next
	EndIf

	If Not $IsOttoVillage Then CollectElixirCart($bSwitchToBB, $bSwitchToNV)

	If _Sleep($DELAYCOLLECT3) Then Return
	If $bSwitchToNV Then SwitchBetweenBases() ; Switching back to the normal Village
EndFunc   ;==>CollectBuilderBase

Func CollectElixirCart($bSwitchToBB = False, $bSwitchToNV = False)

	If Not $g_bRunState Then Return

	If $bSwitchToBB Then
		ClickAway()
		If Not SwitchBetweenBases(True, True) Then Return ; Switching to Builders Base
	EndIf

	If CheckBBElixirStorageFull(False) Then Return

	SetDebugLog("Collecting Elixir Cart", $COLOR_INFO)
	ClickAway("Left")
	If _Sleep($DELAYCOLLECT2) Then Return

	Local $bRet, $aiElixirCart, $aiCollect

	$aiElixirCart = decodeSingleCoord(FindImageInPlace2("ElixirCart", $g_sImgElixirCart, 470, 90 + $g_iMidOffsetY, 620, 190 + $g_iMidOffsetY))
	If IsArray($aiElixirCart) And UBound($aiElixirCart, 1) = 2 Then
		SetLog("Found Filled Elixir Cart", $COLOR_SUCCESS)
		PureClick($aiElixirCart[0], $aiElixirCart[1] + 16)
		If _Sleep(1000) Then Return
		$bRet = False
		For $i = 0 To 10
			$aiCollect = decodeSingleCoord(FindImageInPlace2("CollectElixirCart", $g_sImgCollectElixirCart, 600, 500 + $g_iMidOffsetY, 700, 540 + $g_iMidOffsetY))
			If IsArray($aiCollect) And UBound($aiCollect, 1) = 2 Then
				$bRet = True
				If _Sleep(2000) Then Return
				ExitLoop
			EndIf
			If _Sleep(250) Then Return
		Next
		If $bRet Then
			SetLog("Collect Elixir Cart!", $COLOR_SUCCESS1)
			PureClickP($aiCollect)
			If _Sleep(3000) Then Return
		Else
			SetLog("Collect Button Not Found", $COLOR_ERROR)
		EndIf
		CloseWindow(20)
	EndIf

EndFunc   ;==>CollectElixirCart
