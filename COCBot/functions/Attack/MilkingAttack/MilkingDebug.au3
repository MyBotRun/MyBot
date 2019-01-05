; #FUNCTION# ====================================================================================================================
; Name ..........:Algorithm_MilkingAttack.au3
; Description ...:Attacks a base with the Milking Algorithm
; Syntax ........:Algorithm_MilkingAttack()
; Parameters ....:None
; Return values .:None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================

Func MilkingDebug()
	Local $debugselogLocal = $g_bDebugSetlog
	Local $MilkingExtractorsMatch
	$g_bDebugSetlog = True
	SetLog("1 - Zoom out")
	CheckZoomOut()
	Local $TimeCheckMilkingAttack = __TimerInit()
	SetLog("2 - Detect Elixir Collectors")
	SetLog("  2.1 Detect RedArea")
	MilkingDetectRedArea()
	$g_sMilkFarmObjectivesSTR = ""
;~ 	SetLog("  2.2 Detect Elixir Extractors")
;~ 	$MilkingExtractorsMatch = MilkingDetectElixirExtractors()

	SetLog("  2.2bis detect elixir extractors2")
	$MilkingExtractorsMatch = MilkingDetectElixirExtractors()

	SetLog("  2.3 Detect Mine Extractors")
	$MilkingExtractorsMatch += MilkingDetectMineExtractors()
	SetLog("  2.4 Detect Dark Elixir Extractors")
	Local $TimeCheckMilkingAttackSeconds = Round(__TimerDiff($TimeCheckMilkingAttack) / 1000, 2)
	SetLog("Computing Time Milking Attack : " & $TimeCheckMilkingAttackSeconds & " seconds", $COLOR_INFO)
	$g_bDebugSetlog = $debugselogLocal
	SetLog("Make DebugImage")
	MilkFarmObjectivesDebugImage($g_sMilkFarmObjectivesSTR, 0)

EndFunc   ;==>MilkingDebug



;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Func CheckMilkingBaseTest()

	Local $MilkingElixirImages = _FileListToArray(@ScriptDir & "\images\Milking\Elixir", "*.*")
	If @error = 1 Then
		MsgBox(0, "", "Folder" & @ScriptDir & "\images\Milking\Elixir" & " not Found.")
	EndIf
	If @error = 4 Then
		MsgBox(0, "", "No Files in folder " & @ScriptDir & "\images\Milking\Elixir")
	EndIf
	SetLog("Locate Elixir...")
	; Local $hTimer = __TimerInit()

	_CaptureRegion2()
	_CaptureRegion()
	;$sendHBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($g_hBitmap)

	Local $MilkFarmAtkPixelListSTR = ""
	Local $ElixirVect = StringSplit(GetLocationElixirWithLevel(), "~", 2) ; ["6#527-209" , "6#421-227" , "6#600-264" , "6#299-331" , "6#511-404" , "6#511-453"]
	Local $elixirfounds = UBound($ElixirVect)
	Local $elixirmatch = 0
	Local $elixirdiscard = 0
	For $i = 0 To UBound($ElixirVect) - 1

		;03.02 check isinsidediamond
		Local $temp = StringSplit($ElixirVect[$i], "#", 2) ;TEMP ["2", "404-325"]
		If UBound($temp) = 2 Then

			SetLog("examine elixir vector #" & $i & " placed in " & $ElixirVect[$i], $COLOR_ERROR)
			Local $pixelTemp = StringSplit($ElixirVect[$i], "-", 2)
			$pixelTemp[0] += 0
			$pixelTemp[1] += 10
			Local $arrPixelsCloser = _FindPixelCloser($g_aiPixelRedArea, $pixelTemp, 1)
			SetLog("pixelcloser=" & $arrPixelsCloser & "ubound = " & UBound($arrPixelsCloser))
			For $t = 0 To UBound($arrPixelsCloser) - 1
				Local $temp = $arrPixelsCloser[$t]

				SetLog("$arrPixelsCloser " & $arrPixelsCloser[$t] & " ubound = " & UBound($temp) & " " & $temp[0] & "-" & $temp[1])
			Next

			If UBound($arrPixelsCloser) > 1 Then
;~ 						For $m = 1 To UBound($arrPixelsCloser) - 1 Step 2
;~ 							SetLog( $arrPixelsCloser[$m],$COLOR_DEBUG1)
;~ 							If $m+1 < Ubound($arrPixelsCloser) Then
;~ 								Local $arrTemp3x = $arrPixelsCloser[$m]
;~ 								Local $arrTemp3y = $arrPixelsCloser[$m + 1]
;~ 								SetLog($arrTemp3x & " - " & $arrTemp3y)
;~ 								If (($arrTemp3x-$pixelTemp[0])^2 + ($arrTemp3y - $pixelTemp[1])^2 < ($tmpPixelCloser2x-$pixelTemp[0])^2 + ($tmpPixelCloser2y - $pixelTemp[1])^2) Then
;~ 									$tmpPixelCloser2x = $arrTemp3x
;~ 									$tmpPixelCloser2y= $arrTemp3y
;~ 								EndIf
;~ 							EndIf
;~ 						Next
			EndIf

;~ 					$DistancePixeltoPixCLoser = Sqrt(($tmpPixelCloser2x-$pixelTemp[0])^2 + ($tmpPixelCloser2y - $pixelTemp[1])^2)
;~ 					SetLog("Distance = " & Int($DistancePixeltoPixCLoser) & "; Collector (" & $pixelTemp[0] & "," & $pixelTemp[1] & "); RedLine Pixel Closer (" & $tmpPixelCloser2x & "," & $tmpPixelCloser2y & ")", $COLOR_INFO)


;~ 				If ($tmpPixelCloser2x-$pixelTemp[0]) > 0 Then
;~ 						$tmpPixelCloser2x += 4
;~ 					Else
;~ 						$tmpPixelCloser2x -= 4
;~ 					EndIf
;~ 					If ($tmpPixelCloser2y-$pixelTemp[1]) > 0 Then
;~ 						$tmpPixelCloser2y += 4
;~ 					Else
;~ 						$tmpPixelCloser2y -= 4
;~ 					EndIf
;~ 				Else
;~ 					return -1
;~ 				EndIf

;~ 				Global $tmpPixelCloser2[2]
;~ 				$tmpPixelCloser2[0] = $tmpPixelCloser2x
;~ 				$tmpPixelCloser2[1] = $tmpPixelCloser2y

;~ 				SetLog("Launch point = " & $tmpPixelCloser2[0] & " : " & $tmpPixelCloser2[1])


;~ 				if false then
;~ 						IF Ubound($arrPixelsCloser) >0 Then
;~ 							For $i = 0 to  Ubound($arrPixelsCloser)  -1
;~ 								Local $temp = $arrPixelsCloser[$i]
;~ 								If Ubound($temp)>1 Then
;~ 									For $j= 0 To Ubound($temp) -1
;~ 										SetLog($temp[$j])
;~ 									Next
;~ 								Else
;~ 									SetLog($temp)
;~ 								EndIf
;~ 							Next
;~ 						EndIf
;~ 	;~ 					Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
;~ 	;~  					Setlog ("Elixir # " & $i & " distance = " & $tmpDist )
;~ 	;~ 					If $tmpDist > 0 And $tmpDist < Number($NbPixelmaxExposed) Then
;~ 	;~ 						Local $tmpArrayOfPixel[1]
;~ 	;~ 						$tmpArrayOfPixel[0] = $pixelTemp
;~ 	;~ 						_ArrayAdd($g_aiPixelElixirToAttack, $tmpArrayOfPixel, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
;~ 	;~ 					EndIf
;~ 				EndIf

		Else
			If $g_bDebugSetlog Then SetDebugLog(" - discard #1 no valid point", $COLOR_DEBUG)
			$elixirdiscard += 1
		EndIf
		SetLog("............ next ..........")
	Next
;~ 	If StringLen($MilkFarmAtkPixelListSTR) > 1 Then
;~ 		$MilkFarmAtkPixelListSTR = StringLeft($MilkFarmAtkPixelListSTR, StringLen($MilkFarmAtkPixelListSTR) - 1)
;~ 	EndIf








;~ 		For $i = 0 to ubound($g_aiPixelElixirToAttack)-1
;~ 			Local $pixelTemp = $g_aiPixelElixirToAttack[$i]
;~ 	;		SetLog("$pixelTemp[0] $pixelTemp[1] " & $pixelTemp[0] & " " & $pixelTemp[1])
;~ 			Local $CocSearchArea = string($pixelTemp[0] - 20) & "|" & string($pixelTemp[1] - 20) & "|" & string($pixelTemp[0] + 20) & "|" & string($pixelTemp[1] + 20)
;~ 			Local $CocDiamond = string($pixelTemp[0]) & "," & string($pixelTemp[1] - 20) & "|" & string($pixelTemp[0]-20) & "," & string($pixelTemp[1]) & "|" &  string($pixelTemp[0]) & "," & string($pixelTemp[1] + 20) & "|" & string($pixelTemp[0] + 20) & "," & string($pixelTemp[1])
;~ 	;		SetLog("$CocSearchArea = " & $CocSearchArea & "  $CocDiamond = " & $CocDiamond)
;~ 			For $t = 1 To $newElixADV[0]
;~ 				If FileExists(@ScriptDir & "\images\Milking\Elixir\" & $newElixADV[$t]) Then
;~ 					$res = ""
;~ 					$res = DllCall($g_sLibPath & "\MyBotRunImgLoc.dll", "str", "SearchTile", "handle", $sendHBitmap, "str", @ScriptDir & "\images\Milking\Elixir\" & $newElixADV[$t], "float", $SimilarityMilk , "str", $CocSearchArea, "str", $CocDiamond)
;~ 	;				SetLog("$res = " & $res)
;~ 					If IsArray($res) Then
;~ 	;					SetLog("$res[0] = " & $res[0])
;~ 						If $res[0] = "0" Then
;~ 							$res = ""
;~ 						ElseIf $res[0] = "-1" Then
;~ 							SetLog("DLL Error", $COLOR_ERROR)
;~ 						ElseIf $res[0] = "-2" Then
;~ 							SetLog("Invalid Resolution", $COLOR_ERROR)
;~ 						Else
;~ 							$expRet = StringSplit($res[0], "|", 2)
;~ 							For $j = 1 To UBound($expRet) - 1 Step 2
;~ 								$ElixirLocationx = Int($expRet[$j])
;~ 								$ElixirLocationy = Int($expRet[$j + 1])
;~ 								If isInsideDiamondXY($ElixirLocationx, $ElixirLocationy) Then
;~ 									If $g_bDebugDeadBaseImage = 1 Then
;~ 										$ImageInfo = String("I_" & $t)
;~ 										_GDIPlus_GraphicsDrawRect($hGraphic, $ElixirLocationx - 5, $ElixirLocationy - 5, 10, 10, $hPen)
;~ 										_GDIPlus_GraphicsDrawString($hGraphic, $ImageInfo, $ElixirLocationx , $ElixirLocationy - 30, "Arial", 15)
;~ 									EndIf
;~ 									_ArrayAdd($g_aiPixelNearCollector, $expRet, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
;~ 									Local $batsav = $newElixADV[$t]
;~ 									addstatmilk("Elixir", $batsav)
;~ 									SetLog("file = " & $newElixADV[$t])
;~ 									$ZombieFoundEli += 1
;~ 									SetLog("$ElixirLocationx, $ElixirLocationy = " & $ElixirLocationx & " : " & $ElixirLocationy)
;~ 									If $ZombieFoundEli = 7 Then
;~ 										ExitLoop (3)
;~ 									else
;~ 										ExitLoop (2)
;~ 									EndIf
;~ 								EndIf
;~ 							Next
;~ 						EndIf
;~ 					Else
;~ 						SetLog("$res is not array", $COLOR_ERROR)
;~ 					EndIf
;~ 				EndIf
;~ 			Next
;~ 		Next

;~ 	;		_WinAPI_DeleteObject($g_hBitmap)
;~ 			setlog ("Found " & $ZombieFoundEli & " collectors ready to attack in: " & Round((__TimerDiff($hTimer) / 1000)) & " seconds")
;~ 	SetLog("[" & UBound($g_aiPixelElixirToAttack) & "] Elixir Collectors near red lines")
;~
;~

EndFunc   ;==>CheckMilkingBaseTest

