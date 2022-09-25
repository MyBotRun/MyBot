Func LocateBuilderHall()
	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\BuilderHall\"

	If Not isOnBuilderBase(True) Then Return

	ZoomOut()

	If $g_aiBuilderHallPos[0] > 0 And $g_aiBuilderHallPos[1] > 0 Then
		BuildingClickP($g_aiBuilderHallPos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(242, 490 + $g_iBottomOffsetY) ; Get building name and level with OCR
		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "Builder") = True Then ; we found the Clan Castle
				SetLog("Builder Hall located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)

				If $aResult[2] > $g_iBuilderHallLevel Then $g_iBuilderHallLevel = $aResult[2]

				;ChkCraftCapitalGold()
				Return True
			Else
				ClickAway()
				SetLog("Village position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
				SetLog("Stored Builder Hall Position is not valid.", $COLOR_ERROR)
				SetLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				ConvertToVillagePos($g_aiBuilderHallPos[0],$g_aiBuilderHallPos[1])
				SetLog("Real position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
				$g_aiBuilderHallPos[0] = -1
				$g_aiBuilderHallPos[1] = -1
			EndIf
		Else
			ClickAway()
			SetDebugLog("Stored Builder Hall Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiBuilderHallPos[0],$g_aiBuilderHallPos[1])
			SetDebugLog("Real position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
			$g_aiBuilderHallPos[0] = -1
			$g_aiBuilderHallPos[1] = -1
		EndIf
	EndIf

	SetLog("Looking for Builder Hall...", $COLOR_ACTION)

	Local $sCocDiamond = "DCD"
	Local $sRedLines = $sCocDiamond
	Local $iMinLevel = 0
	Local $iMaxLevel = 1000
	Local $iMaxReturnPoints = 1
	Local $sReturnProps = "objectname,objectpoints"
	Local $bForceCapture = True

	; DETECTION IMGLOC
	Local $aResult
	For $j = 0 to 10
		SetLog("ImgLoc Builder Hall loop :" & $j & " zoom factor :" & $g_aVillageSize[1])
		$aResult = findMultiple($sImgDir, $sCocDiamond, $sRedLines, $iMinLevel, $iMaxLevel, $iMaxReturnPoints, $sReturnProps, $bForceCapture)
		If IsArray($aResult) And UBound($aResult) > 0 Then ; we have an array with data of images found
			For $i = 0 To UBound($aResult) - 1
				If _Sleep(50) Then Return ; just in case on PAUSE
				If Not $g_bRunState Then Return ; Stop Button
				SetDebugLog(_ArrayToString($aResult[$i]))
				Local $aTEMP = $aResult[$i]
				Local $sObjectname = String($aTEMP[0])
				SetDebugLog("Image name: " & String($aTEMP[0]), $COLOR_INFO)
				Local $aObjectpoints = $aTEMP[1] ; number of  objects returned
				SetDebugLog("Object points: " & String($aTEMP[1]), $COLOR_INFO)
				If StringInStr($aObjectpoints, "|") Then
					$aObjectpoints = StringReplace($aObjectpoints, "||", "|")
					Local $sString = StringRight($aObjectpoints, 1)
					If $sString = "|" Then $aObjectpoints = StringTrimRight($aObjectpoints, 1)
					Local $tempObbjs = StringSplit($aObjectpoints, "|", $STR_NOCOUNT) ; several detected points
					For $j = 0 To UBound($tempObbjs) - 1
						; Test the coordinates
						Local $tempObbj = StringSplit($tempObbjs[$j], ",", $STR_NOCOUNT) ;  will be a string : 708,360
						If UBound($tempObbj) = 2 Then
							$g_aiBuilderHallPos[0] = Number($tempObbj[0]) ;+ 9
							$g_aiBuilderHallPos[1] = Number($tempObbj[1]) ;+ 15
							SetLog("Builder Hall :" & $g_aiBuilderHallPos[0] & "," & $g_aiBuilderHallPos[1])
							ConvertFromVillagePos($g_aiBuilderHallPos[0],$g_aiBuilderHallPos[1])
							SetLog("Builder Hall VillagePos:" & $g_aiBuilderHallPos[0] & "," & $g_aiBuilderHallPos[1])
							ExitLoop 3
						EndIf
					Next
				Else
					; Test the coordinate
					Local $tempObbj = StringSplit($aObjectpoints, ",", $STR_NOCOUNT) ;  will be a string : 708,360
					If UBound($tempObbj) = 2 Then
						$g_aiBuilderHallPos[0] = Number($tempObbj[0]) ;+ 9
						$g_aiBuilderHallPos[1] = Number($tempObbj[1]) ;+ 15
						SetLog("Builder Hall :" & $g_aiBuilderHallPos[0] & "," & $g_aiBuilderHallPos[1])
						ConvertFromVillagePos($g_aiBuilderHallPos[0],$g_aiBuilderHallPos[1])
						SetLog("Builder Hall VillagePos:" & $g_aiBuilderHallPos[0] & "," & $g_aiBuilderHallPos[1])
						ExitLoop 2
					EndIf
				EndIf
			Next
		EndIf

		If _Sleep(500) Then Return
	Next

	If $g_aiBuilderHallPos[0] > 0 And $g_aiBuilderHallPos[1] > 0 Then
		BuildingClickP($g_aiBuilderHallPos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(242, 490 + $g_iBottomOffsetY) ; Get building name and level with OCR
		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "Builder") = True Then ; we found the Clan Castle
				SetLog("Builder Hall located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)

				If $aResult[2] > $g_iBuilderHallLevel Then $g_iBuilderHallLevel = $aResult[2]

				;ChkCraftCapitalGold()
				Return True
			Else
				ClickAway()
				SetDebugLog("Found Builder Hall Position is not valid.", $COLOR_ERROR)
				SetDebugLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				SetDebugLog("Village position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
				ConvertToVillagePos($g_aiBuilderHallPos[0],$g_aiBuilderHallPos[1])
				SetDebugLog("Real position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
				$g_aiBuilderHallPos[0] = -1
				$g_aiBuilderHallPos[1] = -1

			EndIf
		Else
			ClickAway()
			SetDebugLog("Found Builder Hall Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiBuilderHallPos[0],$g_aiBuilderHallPos[1])
			SetDebugLog("Real position: " & $g_aiBuilderHallPos[0] & ", " & $g_aiBuilderHallPos[1], $COLOR_DEBUG, True)
			$g_aiBuilderHallPos[0] = -1
			$g_aiBuilderHallPos[1] = -1
		EndIf
	EndIf

	SetLog("Can not find Builder Hall.", $COLOR_ERROR)
	Return False
EndFunc   ;==>LocateBuilderHall()