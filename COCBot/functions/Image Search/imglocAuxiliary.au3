; #FUNCTION# ====================================================================================================================
; Name ..........: Imgloc Aux functions
; Description ...: auxyliary functions used by imgloc
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: Trlopes (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func decodeMultipleCoords($coords, $iDedupX = Default, $iDedupY = Default, $iSorted = Default)
	If $iDedupX = Default Then $iDedupX = -1
	If $iDedupY = Default Then $iDedupY = -1
	If $iSorted = Default Then $iSorted = -1
	;returns array of N coordinates [0=x, 1=y][0=x1, 1=y1]
	Local $retCoords, $c
	Local $pOff = 0
	;	SetDebugLog("**decodeMultipleCoords: " & $coords, $COLOR_DEBUG)
	Local $aCoordsSplit = StringSplit($coords, "|", $STR_NOCOUNT)
	If StringInStr($aCoordsSplit[0], ",") > 0 Then
		Local $retCoords[UBound($aCoordsSplit)]
	Else ;has total count in value
		$pOff = 1
		Local $retCoords[Number($aCoordsSplit[0])]
	EndIf
	Local $iErr = 0
	For $p = 0 To UBound($retCoords) - 1
		$c = decodeSingleCoord($aCoordsSplit[$p + $pOff])
		If UBound($c) > 1 Then
			$retCoords[$p - $iErr] = $c
		Else
			; not a coordinate
			$iErr += 1
		EndIf
	Next
	If $iErr > 0 Then ReDim $retCoords[UBound($retCoords) - $iErr]

	If UBound($retCoords) = 0 Then
		Local $aEmpty[0]
		Return $aEmpty
	EndIf
	If UBound($retCoords) = 1 Or ($iDedupX < 1 And $iDedupY < 1 And $iSorted = -1) Then Return $retCoords ; no dedup, return array

	; dedup coords
	If $iDedupX > 0 Or $iDedupY > 0 Then
		Local $aFinalCoords[1] = [$retCoords[0]]
		Local $c1, $c2, $k, $inX, $inY
		For $i = 1 To UBound($retCoords) - 1
			$c1 = $retCoords[$i]
			$k = UBound($aFinalCoords) - 1
			For $j = 0 To $k
				$c2 = $aFinalCoords[$j]
				$inX = Abs($c1[0] - $c2[0]) < $iDedupX
				$inY = Abs($c1[1] - $c2[1]) < $iDedupY
				If ($iDedupY < 1 And $inX) Or ($iDedupX < 1 And $inY) Or ($inX And $inY) Then
					; duplicate coord
					ContinueLoop 2
				EndIf
			Next
			; add coord
			ReDim $aFinalCoords[$k + 2]
			$aFinalCoords[$k + 1] = $c1
		Next
	Else
		Local $aFinalCoords = $retCoords
	EndIf
	If $iSorted = 0 Or $iSorted = 1 Then
		Local $a[UBound($aFinalCoords)][2], $c1
		For $i = 0 To UBound($aFinalCoords) - 1
			$c1 = $aFinalCoords[$i]
			$a[$i][0] = $c1[0]
			$a[$i][1] = $c1[1]
		Next
		_ArraySort($a, 0, 0, 0, $iSorted)
		For $i = 0 To UBound($a) - 1
			$c1 = $aFinalCoords[$i]
			$c1[0] = $a[$i][0]
			$c1[1] = $a[$i][1]
			$aFinalCoords[$i] = $c1
		Next
	EndIf

	Return $aFinalCoords
EndFunc   ;==>decodeMultipleCoords

Func decodeSingleCoord($coords)
	;returns array with 2 coordinates 0=x, 1=y
	Local $aCoordsSplit = StringSplit($coords, ",", $STR_NOCOUNT)
	If UBound($aCoordsSplit) > 1 Then
		$aCoordsSplit[0] = Int($aCoordsSplit[0])
		$aCoordsSplit[1] = Int($aCoordsSplit[1])
	EndIf
	Return $aCoordsSplit
EndFunc   ;==>decodeSingleCoord

Func RetrieveImglocProperty($key, $property)
	; Get the property
	Local $aValue = DllCall($g_hLibMyBot, "str", "GetProperty", "str", $key, "str", $property)
	If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error) ; check for error with DLL call
	If UBound($aValue) = 0 Then
		Return ""
	EndIf
	Return $aValue[0]
EndFunc   ;==>RetrieveImglocProperty

Func checkImglocError(ByRef $imglocvalue, $funcName, $sTileSource = "", $sImageArea = "")
	;Return true if there is an error in imgloc return string
	If IsArray($imglocvalue) Then ;despite beeing a string, AutoIt receives a array[0]
		If $imglocvalue[0] = "0" Or $imglocvalue[0] = "" Then
			If $g_bDebugSetlog Then SetDebugLog($funcName & " imgloc search returned no results" & ($sImageArea ? " in " & $sImageArea : "") & ($sTileSource ? " for '" & $sTileSource & "' !" : "!"), $COLOR_WARNING)
			Return True
		ElseIf StringLeft($imglocvalue[0], 2) = "-1" Then ;error
			If $g_bDebugSetlog Then SetDebugLog($funcName & " - Imgloc DLL Error: " & $imglocvalue[0], $COLOR_ERROR)
			Return True
		ElseIf StringLeft($imglocvalue[0], 2) = "-2" Then ;critical error
			SetLog($funcName & " - Imgloc DLL Critical Error", $COLOR_RED)
			SetLog(StringMid($imglocvalue[0], 4), $COLOR_RED)
			;BotStop() ; stop bot on critical errors
			; Restart Bot on critical errors
			SetLog("Restart bot in 3 Minutes...", $COLOR_GREEN)
			If _SleepStatus(180000) = False Then
				RestartBot(False, True)
			EndIf
			Return True
		Else
			Return False
		EndIf
	Else
		If $g_bDebugSetlog Then SetDebugLog($funcName & " - Imgloc  Error: Not an Array Result", $COLOR_ERROR)
		Return True
	EndIf
EndFunc   ;==>checkImglocError

Func ClickB($sButtonName, $buttonTileArrayOrPatternOrFullPath = Default, $iDelay = 100)
	Local $aiButton = findButton($sButtonName, $buttonTileArrayOrPatternOrFullPath, 1, True)
	If IsArray($aiButton) And UBound($aiButton) >= 2 Then
		ClickP($aiButton, 1)
		If _Sleep($iDelay) Then Return
		Return True
	EndIf
	Return False
EndFunc   ;==>ClickB

Func ClickButton($sButtonName, $buttonTileArrayOrPatternOrFullPath = Default, $iDelay = 100, $iLoop = 5)
	For $i = 1 To $iLoop
		Local $aiButton = findButton($sButtonName, $buttonTileArrayOrPatternOrFullPath, 1, True)
		If IsArray($aiButton) And UBound($aiButton) >= 2 Then
			ClickP($aiButton, 1)
			If _Sleep($iDelay) Then Return
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>ClickButton

; $sButtonName = search area X1Y1|X1Y2|X2Y2|X2Y1
; $buttonTileArrayOrPatternOrFullPath = image path
; Capture = FV
; Test : findButton($sButtonName, Default,1,1,1,1)
Func findButton($sButtonName, $buttonTileArrayOrPatternOrFullPath = Default, $maxReturnPoints = 1, $bForceCapture = True, $bDebuglog = $g_bDebugSetlog, $bDebugImageSave = $g_bDebugImageSave)

	If $buttonTileArrayOrPatternOrFullPath = Default Then $buttonTileArrayOrPatternOrFullPath = $sButtonName & "*"

	Local $error, $extError
	Local $searchArea = GetButtonDiamond($sButtonName)
	Local $aCoords = "" ; use AutoIt mixed varaible type and initialize array of coordinates to null
	Local $aButtons
	Local $sButtons = ""

	;If $bDebugImageSave Then SaveDebugDiamondImage("findButton", $searchArea)

	; check if file tile is a pattern
	If IsString($buttonTileArrayOrPatternOrFullPath) Then
		$sButtons = $buttonTileArrayOrPatternOrFullPath
		If StringInStr($buttonTileArrayOrPatternOrFullPath, "*") > 0 Then
			Local $aFiles = _FileListToArray($g_sImgImgLocButtons, $sButtons, $FLTA_FILES, True)
			If UBound($aFiles) < 2 Or $aFiles[0] < 1 Then
				Return SetError(1, 1, "No files in " & $g_sImgImgLocButtons) ; Set external error code = 1 for bad input values
			EndIf
			Local $a[0], $j
			$j = 0
			For $i = 1 To $aFiles[0]
				If StringRegExp($aFiles[$i], ".+[.](xml|png|bmp)$") Then
					$j += 1
					ReDim $a[$j]
					$a[$i - 1] = $aFiles[$i]
				EndIf
			Next
			$aButtons = $a
		Else
			Local $a[1] = [$sButtons]
			$aButtons = $a
		EndIf
	ElseIf IsArray($buttonTileArrayOrPatternOrFullPath) Then
		$aButtons = $buttonTileArrayOrPatternOrFullPath
		$sButtons = _ArrayToString($aButtons)
	Else
		Return SetError(1, 2, "Bad Input Values : " & $buttonTileArrayOrPatternOrFullPath) ; Set external error code = 1 for bad input values
	EndIf

	; Check function parameters
	If Not IsString($sButtonName) Or UBound($aButtons) < 1 Then
		Return SetError(1, 3, "Bad Input Values : " & $sButtons) ; Set external error code = 1 for bad input values
	EndIf

	For $buttonTile In $aButtons

		; Check function parameters
		If FileExists($buttonTile) = 0 Then
			Return SetError(1, 4, "Bad Input Values : Button Image NOT FOUND : " & $buttonTile) ; Set external error code = 1 for bad input values
		EndIf

		; Capture the screen for comparison
		; _CaptureRegion2() or similar must be used before
		; Perform the search
		If $bForceCapture Then _CaptureRegion2() ;to have FULL screen image to work with

		If $g_bDebugSetlog Then SetDebugLog(" imgloc searching for: " & $sButtonName & " : " & $buttonTile)

		Local $result = DllCallMyBot("FindTile", "handle", $g_hHBitmap2, "str", $buttonTile, "str", $searchArea, "Int", $maxReturnPoints)
		$error = @error ; Store error values as they reset at next function call
		$extError = @extended
		If $error Then
			_logErrorDLLCall($g_sLibMyBotPath, $error)
			SetDebugLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError)
			Return SetError(2, 1, $extError) ; Set external error code = 2 for DLL error
		EndIf

		If $result[0] <> "" And checkImglocError($result, "imglocFindButton", $buttonTile) = False Then
			If $g_bDebugSetlog Then SetDebugLog($sButtonName & " Button Image Found in: " & $result[0])
			$aCoords = StringSplit($result[0], "|", $STR_NOCOUNT)
			;[0] - total points found
			;[1] -  coordinates
			If $maxReturnPoints = 1 Then
				Return StringSplit($aCoords[1], ",", $STR_NOCOUNT) ; return just X,Y coord
			ElseIf IsArray($aCoords) Then
				Local $aReturnResult[0][2]
				For $i = 1 To UBound($aCoords) - 1
					_ArrayAdd($aReturnResult, $aCoords[$i], 0, ",", @CRLF, $ARRAYFILL_FORCE_NUMBER)
				Next
				Return $aReturnResult ; return 2D array
			EndIf
		EndIf

	Next

	SetDebugLog($sButtonName & " Button Image(s) NOT FOUND : " & $sButtons, $COLOR_ERROR)
	Return $aCoords
EndFunc   ;==>findButton

Func GetButtonDiamond($sButtonName)
	Local $btnDiamond = "FV"
	;$g_iMidOffsetY $g_iBottomOffsetY

	Switch $sButtonName
		Case "ClanGamesStorageFullYes"
			$btnDiamond = GetDiamondFromRect("460,400,615,480")
		Case "ClanGamesCollectRewards"
			$btnDiamond = GetDiamondFromRect("570,470,830,530")
		Case "ClanGamesClaimReward"
			$btnDiamond = GetDiamondFromRect("570,470,830,530")
		Case "UpgradePets"
			$btnDiamond = GetDiamondFromRect("730,530,800,600")
		Case "ReloadButton"
			$btnDiamond = GetDiamondFromRect2(650, 530 + $g_iMidOffsetY, 850, 645 + $g_iMidOffsetY)
		Case "AttackButton" ;Main Window Screen
			$btnDiamond = GetDiamondFromRect2(0, 540 + $g_iBottomOffsetY, 160, 660 + $g_iBottomOffsetY)
		Case "OpenTrainWindow" ;Main Window Screen
			$btnDiamond = "15,560|65,560|65,610|15,610"
		Case "TrashEvent"
			$btnDiamond = GetDiamondFromRect("100,200,840,540")
		Case "EventFailed"
			$btnDiamond = GetDiamondFromRect("230,130,777,560")
		Case "ObjectButtons", "BoostOne", "BoostCT", "Upgrade", "Research", "Treasury", "RemoveObstacle", "CollectLootCart", "Pets", "THWeapon", "MagicItems", "Equipment" ; Full size of object buttons at the bottom
			$btnDiamond = GetDiamondFromRect2(140, 500 + $g_iBottomOffsetY, 720, 590 + $g_iBottomOffsetY)
		Case "GEM", "BOOSTBtn" ; Boost window button (full button size)
			$btnDiamond = GetDiamondFromRect2(340, 370 + $g_iMidOffsetY, 525, 495 + $g_iMidOffsetY)
		Case "EnterShop"
			$btnDiamond = GetDiamondFromRect2(350, 380 + $g_iMidOffsetY, 515, 460 + $g_iMidOffsetY)
		Case "EndBattleSurrender" ;surrender - attackwindow
			$btnDiamond = "12,577|125,577|125,615|12,615"
		Case "ClanChat"
			$btnDiamond = GetDiamondFromRect("10,310,420,370")
		Case "ChatOpenRequestPage" ;mainwindow - chat open
			$btnDiamond = "5,688|65,688|65,615|5,725"
		Case "Profile" ;mainwindow - only visible if chat closed
			$btnDiamond = "172,15|205,15|205,48|172,48"
		Case "DonateWindow" ;mainwindow - only when donate window is visible
			$btnDiamond = "310,0|360,0|360,732|310,732"
		Case "DonateButton" ;mainwindow - only when chat window is visible
			$btnDiamond = "200,85|305,85|305,680|200,680"
		Case "UpDonation" ;mainwindow - only when chat window is visible
			$btnDiamond = "282,85|306,85|306,130|282,130"
		Case "DownDonation" ;mainwindow - only when chat window is visible
			$btnDiamond = "282,635|306,635|306,680|282,680"
		Case "Collect"
			$btnDiamond = "350,450|505,450|505,521|350,521"
		Case "BoostBarrack", "BarrackBoosted"
			$btnDiamond = GetDiamondFromRect2(675, 285 + $g_iMidOffsetY, 770, 330 + $g_iMidOffsetY)
		Case "ArmyTab", "TrainTroopsTab", "BrewSpellsTab", "BuildSiegeMachinesTab", "QuickTrainTab"
			$btnDiamond = GetDiamondFromRect2(75, 110 + $g_iMidOffsetY, 740, 160 + $g_iMidOffsetY)
		Case "WeeklyDeals"
			$btnDiamond = GetDiamondFromRect2(30, 115 + $g_iMidOffsetY, 170, 320 + $g_iMidOffsetY)
		Case "MessagesButton"
			$btnDiamond = GetDiamondFromRect2(0, 0, 90, 170 + $g_iMidOffsetY)
		Case "AttackLogTab", "ShareReplayButton"
			$btnDiamond = GetDiamondFromRect2(280, 80, 600, 160 + $g_iMidOffsetY)
		Case "EndBattle", "Surrender"
			$btnDiamond = GetDiamondFromRect("1,570,140,628")
		Case "Okay", "Cancel"
			$btnDiamond = GetDiamondFromRect("240,250,630,630")
		Case Else
			$btnDiamond = "FV" ; use full image to locate button
	EndSwitch
	Return $btnDiamond
EndFunc   ;==>GetButtonDiamond

Func UpdateImgeTile(ByRef $sImageTile, $AndroidTag = Default)
	Local $iMinimumAndroidVersion = Int($AndroidTag)
	If $iMinimumAndroidVersion > 1 And $g_iAndroidVersionAPI < $iMinimumAndroidVersion Then
		; not required to search anything
		Return False
	EndIf

	If Not IsBool($AndroidTag) Then
		If $iMinimumAndroidVersion > 0 Then
			$AndroidTag = True
		Else
			$AndroidTag = False
		EndIf
	EndIf


	If $AndroidTag Then
		; add [Android Code Name] at the end, see https://en.wikipedia.org/wiki/Android_version_history
		$sImageTile = StringReplace($sImageTile, "[Android]", GetAndroidCodeName())
		If $iMinimumAndroidVersion > 1 And @extended = 0 Then
			SetDebugLog("Android Code Name cannot be added to title: " & $sImageTile, $COLOR_ERROR)
		EndIf
	EndIf

	Return True
EndFunc   ;==>UpdateImgeTile

Func findImage($sImageName, $sImageTile, $sImageArea, $maxReturnPoints = 1, $bForceCapture = True, $AndroidTag = Default)
	If $AndroidTag = Default Then $AndroidTag = True
	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null
	Local $iPattern = StringInStr($sImageTile, "*")
	If Not UpdateImgeTile($sImageTile, $AndroidTag) Then Return $aCoords

	If $iPattern > 0 Then
		Local $dir = ""
		Local $pat = $sImageTile
		Local $iLastBS = StringInStr($sImageTile, "\", 0, -1)
		If $iLastBS > 0 Then
			$dir = StringLeft($sImageTile, $iLastBS)
			$pat = StringMid($sImageTile, $iLastBS + 1)
		EndIf
		Local $files = _FileListToArray($dir, $pat, $FLTA_FILES, True)
		If @error Or UBound($files) < 2 Then
			If $g_bDebugSetlog Then SetDebugLog("findImage files not found : " & $sImageTile, $COLOR_ERROR)
			SetError(1, 0, $aCoords) ; Set external error code = 1 for bad input values
			Return
		EndIf
		For $i = 1 To $files[0]
			$aCoords = findImage($sImageName, $files[$i], $sImageArea, $maxReturnPoints, $bForceCapture)
			If UBound(decodeSingleCoord($aCoords)) > 1 Then Return $aCoords
		Next
		Return $aCoords
	EndIf
	; same has findButton, but allow custom area instead of button area decoding
	; nice for dynamic locations
	Local $error, $extError

	; Check function parameters
	If Not FileExists($sImageTile) Then
		If $g_bDebugSetlog Then SetDebugLog("findImage file not found : " & $sImageTile, $COLOR_ERROR)
		SetError(1, 1, $aCoords) ; Set external error code = 1 for bad input values
		Return
	EndIf

	; Capture the screen for comparison
	; _CaptureRegion2() or similar must be used before
	; Perform the search
	If $bForceCapture Then _CaptureRegion2() ;to have FULL screen image to work with

	Local $result = DllCallMyBot("FindTile", "handle", $g_hHBitmap2, "str", $sImageTile, "str", $sImageArea, "Int", $maxReturnPoints)
	$error = @error ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		If $g_bDebugSetlog Then SetDebugLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError)
		SetError(2, $extError, $aCoords) ; Set external error code = 2 for DLL error
		Return
	EndIf

	If checkImglocError($result, "findImage", $sImageTile, $sImageArea) Then
		If $g_bDebugSetlog And $g_bDebugImageSave Then SaveDebugImage("findImage_" & $sImageName, True)
		Return $aCoords
	EndIf

	If $result[0] <> "" Then ;despite being a string, AutoIt receives a array[0]
		If $g_bDebugSetlog Then SetDebugLog("findImage : " & $sImageName & " Found in: " & $result[0])
		$aCoords = StringSplit($result[0], "|", $STR_NOCOUNT)
		;[0] - total points found
		;[1] -  coordinates
		If $maxReturnPoints = 1 Then
			Return $aCoords[1] ; return just X,Y coord
		Else
			Return $result[0] ; return full string with count and points
		EndIf
	Else
		If $g_bDebugSetlog Then SetDebugLog("findImage : " & $sImageName & " NOT FOUND " & $sImageTile)
		If $g_bDebugSetlog And $g_bDebugImageSave Then SaveDebugImage("findImage_" & $sImageName, True)
		Return $aCoords
	EndIf

EndFunc   ;==>findImage

Func GetDeployableNextTo($sPoints, $distance = 3, $redlineoverride = "")
	Local $result = DllCall($g_hLibMyBot, "str", "GetDeployableNextTo", "str", $sPoints, "int", $distance, "str", $redlineoverride)
	Local $error = @error ; Store error values as they reset at next function call
	Local $extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		If $g_bDebugSetlog Then SetDebugLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError)
		SetError(2, $extError, "") ; Set external error code = 2 for DLL error
		Return ""
	EndIf

	If UBound($result) = 0 Then Return ""
	If $g_bDebugSetlog Then SetDebugLog("GetDeployableNextTo : " & $sPoints & ", dist. = " & $distance & " : " & $result[0], $COLOR_OLIVE)
	Return $result[0]
EndFunc   ;==>GetDeployableNextTo

Func GetOffsetRedline($sArea = "TL", $distance = 3)
	Local $result = DllCall($g_hLibMyBot, "str", "GetOffSetRedline", "str", $sArea, "int", $distance)
	Local $error = @error ; Store error values as they reset at next function call
	Local $extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		If $g_bDebugSetlog Then SetDebugLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError)
		SetError(2, $extError, "") ; Set external error code = 2 for DLL error
		Return ""
	EndIf

	If UBound($result) = 0 Then Return ""
	If $g_bDebugSetlog Then SetDebugLog("GetOffSetRedline : " & $sArea & ", dist. = " & $distance & " : " & $result[0], $COLOR_OLIVE)
	Return $result[0]
EndFunc   ;==>GetOffsetRedline

Func findMultiple($directory, $sCocDiamond, $redLines, $minLevel = 0, $maxLevel = 1000, $maxReturnPoints = 0, $returnProps = "objectname,objectlevel,objectpoints", $bForceCapture = True)
	; same has findButton, but allow custom area instead of button area decoding
	; nice for dinamic locations
	If $g_bDebugSetlog Then
		SetDebugLog("******** findMultiple *** START ***", $COLOR_OLIVE)
		SetDebugLog("findMultiple : directory : " & $directory, $COLOR_OLIVE)
		SetDebugLog("findMultiple : sCocDiamond : " & $sCocDiamond, $COLOR_OLIVE)
		SetDebugLog("findMultiple : redLines : " & $redLines, $COLOR_OLIVE)
		SetDebugLog("findMultiple : minLevel : " & $minLevel, $COLOR_OLIVE)
		SetDebugLog("findMultiple : maxLevel : " & $maxLevel, $COLOR_OLIVE)
		SetDebugLog("findMultiple : maxReturnPoints : " & $maxReturnPoints, $COLOR_OLIVE)
		SetDebugLog("findMultiple : returnProps : " & $returnProps, $COLOR_OLIVE)
		SetDebugLog("******** findMultiple *** START ***", $COLOR_OLIVE)
	EndIf

	Local $error, $extError

	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null
	Local $returnData = StringSplit($returnProps, ",", $STR_NOCOUNT)
	Local $returnLine[UBound($returnData)]
	Local $returnValues[0]


	; Capture the screen for comparison
	; Perform the search
	If $bForceCapture Then _CaptureRegion2() ;to have FULL screen image to work with

	Local $result = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", $sCocDiamond, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	$error = @error ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		If $g_bDebugSetlog Then SetDebugLog(" imgloc DLL Error : " & $error & " --- " & $extError)
		SetError(2, $extError, $aCoords) ; Set external error code = 2 for DLL error
		Return ""
	EndIf

	If checkImglocError($result, "findMultiple", $directory) = True Then
		If $g_bDebugSetlog Then SetDebugLog("findMultiple Returned Error or No values : ", $COLOR_DEBUG)
		If $g_bDebugSetlog Then SetDebugLog("******** findMultiple *** END ***", $COLOR_OLIVE)
		Return ""
	Else
		If $g_bDebugSetlog Then SetDebugLog("findMultiple found : " & $result[0])
	EndIf

	If $result[0] <> "" Then ;despite being a string, AutoIt receives a array[0]
		Local $resultArr = StringSplit($result[0], "|", $STR_NOCOUNT)
		ReDim $returnValues[UBound($resultArr)]
		Local $iErr = 0
		For $rs = 0 To UBound($resultArr) - 1
			For $rD = 0 To UBound($returnData) - 1 ; cycle props
				$returnLine[$rD] = RetrieveImglocProperty($resultArr[$rs], $returnData[$rD])
				If $returnData[$rD] = "objectpoints" Then
					; validate object points
					If StringInStr($returnLine[$rD], ",") = 0 Then
						; no valid coordinate, skip values
						If $g_bDebugSetlog Then SetDebugLog("findMultiple : Invalid objectpoint in result in " & $rD & ": " & $result[0])
						$iErr += 1
						ContinueLoop 2
					EndIf
				EndIf
				If $g_bDebugSetlog Then SetDebugLog("findMultiple : " & $resultArr[$rs] & "->" & $returnData[$rD] & " -> " & $returnLine[$rD])
			Next
			$returnValues[$rs - $iErr] = $returnLine
		Next
		If $iErr Then ReDim $returnValues[UBound($resultArr) - $iErr]

		;;lets check if we should get redlinedata
		If $redLines = "" Then
			$g_sImglocRedline = RetrieveImglocProperty("redline", "") ;global var set in imgltocTHSearch
			If $g_bDebugSetlog Then SetDebugLog("findMultiple : Redline argument is emty, setting global Redlines")
		EndIf
		If $g_bDebugSetlog Then SetDebugLog("******** findMultiple *** END ***", $COLOR_OLIVE)
		Return $returnValues

	Else
		If $g_bDebugSetlog Then SetDebugLog(" ***  findMultiple has no result **** ", $COLOR_OLIVE)
		If $g_bDebugSetlog Then SetDebugLog("******** findMultiple *** END ***", $COLOR_OLIVE)
		Return ""
	EndIf

EndFunc   ;==>findMultiple

;receives "StartX,StartY,EndX,EndY" or "StartX,StartY(Width,Height)" and returns 0 based array
Func GetRectArray($rect, $bLogError = True)
	Local $a = []
	Local $RectValues = StringSplit($rect, ",", $STR_NOCOUNT)
	If UBound($RectValues) = 3 Then
		ReDim $RectValues[4]
		; check for width and height
		$i = StringInStr($RectValues[2], ")")
		If $i = 0 Then
			If $bLogError Then SetDebugLog("GetRectArray : Bad Input Values : " & $rect, $COLOR_ERROR)
			Return SetError(1, 1, $a)
		EndIf
		$RectValues[3] = $RectValues[1] + StringLeft($RectValues[2], $i - 1)
		$i = StringInStr($RectValues[1], "(")
		If $i = 0 Then
			If $bLogError Then SetDebugLog("GetRectArray : Bad Input Values : " & $rect, $COLOR_ERROR)
			Return SetError(1, 2, $a)
		EndIf
		$RectValues[2] = $RectValues[0] + StringMid($RectValues[1], $i + 1)
		$RectValues[1] = StringLeft($RectValues[1], $i - 1)
	EndIf
	If UBound($RectValues) < 4 Then
		If $bLogError Then SetDebugLog("GetRectArray : Bad Input Values : " & $rect, $COLOR_ERROR)
		Return SetError(1, 3, $a)
	EndIf
	Return SetError(0, 0, $RectValues)
EndFunc   ;==>GetRectArray

Func GetDiamondFromRect($rect)
	;receives "StartX,StartY,EndX,EndY" or "StartX,StartY(Width,Height)"
	;returns "StartX,StartY|EndX,StartY|EndX,EndY|StartX,EndY"
	SetError(0)
	Local $returnvalue = "", $i
	Local $RectValues = IsArray($rect) ? $rect : GetRectArray($rect, False)
	Local $error = @error, $extended = @extended
	If UBound($RectValues) < 4 Then
		If $error = 0 Then $error = 1
		SetDebugLog("GetDiamondFromRect : Bad Input Values : " & $rect, $COLOR_ERROR)
		Return SetError($error, $extended, $returnvalue)
	EndIf
	Local $DiamdValues[4]
	Local $X = Number($RectValues[0])
	Local $Y = Number($RectValues[1])
	Local $Ex = Number($RectValues[2])
	Local $Ey = Number($RectValues[3])
	$DiamdValues[0] = $X & "," & $Y
	$DiamdValues[1] = $Ex & "," & $Y
	$DiamdValues[2] = $Ex & "," & $Ey
	$DiamdValues[3] = $X & "," & $Ey
	$returnvalue = $DiamdValues[0] & "|" & $DiamdValues[1] & "|" & $DiamdValues[2] & "|" & $DiamdValues[3]
	Return $returnvalue
EndFunc   ;==>GetDiamondFromRect

Func GetDiamondFromArray($aRectArray)
	;Recieves $aArray[0] = StartX
	;		  $aArray[1] = StartY
	;		  $aArray[2] = EndX
	;		  $aArray[3] = EndY

	If UBound($aRectArray, 1) < 4 Then
		SetDebugLog("GetDiamondFromArray: Bad Input Array!", $COLOR_ERROR)
		Return ""
	EndIf
	Local $iX = Number($aRectArray[0]), $iY = Number($aRectArray[1])
	Local $iEndX = Number($aRectArray[2]), $iEndY = Number($aRectArray[3])

	;If User inputed Width and Height then add start point to get the final End Coordinates
	If $iEndY <= $iY Then $iEndY += $iY
	If $iEndX <= $iX Then $iEndX += $iX

	Local $sReturnDiamond = ""
	$sReturnDiamond = $iX & "," & $iY & "|" & $iEndX & "," & $iY & "|" & $iEndX & "," & $iEndY & "|" & $iX & "," & $iEndY
	Return $sReturnDiamond
EndFunc   ;==>GetDiamondFromArray

Func GetDiamondFromRect2($iX1 = -1, $iY1 = -1, $iX2 = -1, $iY2 = -1)
	If $iX1 = -1 Or $iX2 = -1 Or $iY1 = -1 Or $iY2 = -1 Then
		SetLog("GetDiamondFromRect2: One or more bad input coordinates!", $COLOR_ERROR)
		Return ""
	EndIf

	Local $sReturnDiamond = ""
	$sReturnDiamond = $iX1 & "," & $iY1 & "|" & $iX2 & "," & $iY1 & "|" & $iX2 & "," & $iY2 & "|" & $iX1 & "," & $iY2
	Return $sReturnDiamond
EndFunc   ;==>GetDiamondFromRect2

Func FindImageInPlace($sImageName, $sImageTile, $place, $bForceCaptureRegion = True, $AndroidTag = Default)
	;creates a reduced capture of the place area a finds the image in that area
	;returns string with X,Y of ACTUALL FULL SCREEN coordinates or Empty if not found
	If $g_bDebugSetlog Then SetDebugLog("FindImageInPlace : > " & $sImageName & " - " & $sImageTile & " - " & $place, $COLOR_INFO)
	Local $returnvalue = ""
	Local $aPlaces = GetRectArray($place)
	Local $sImageArea = GetDiamondFromRect($aPlaces)
	If $bForceCaptureRegion = True Then
		$sImageArea = "FV"
		_CaptureRegion2(Number($aPlaces[0]), Number($aPlaces[1]), Number($aPlaces[2]), Number($aPlaces[3]))
	EndIf
	Local $coords = findImage($sImageName, $sImageTile, $sImageArea, 1, False, $AndroidTag) ; reduce capture full image
	Local $aCoords = decodeSingleCoord($coords)
	If UBound($aCoords) < 2 Then
		If $g_bDebugSetlog Then SetDebugLog("FindImageInPlace : " & $sImageName & " NOT Found", $COLOR_INFO)
		Return ""
	EndIf
	If $bForceCaptureRegion Then
		$returnvalue = Number($aCoords[0]) + Number($aPlaces[0]) & "," & Number($aCoords[1]) + Number($aPlaces[1])
	Else
		$returnvalue = Number($aCoords[0]) & "," & Number($aCoords[1])
	EndIf
	If $g_bDebugSetlog Then SetDebugLog("FindImageInPlace : < " & $sImageName & " Found in " & $returnvalue, $COLOR_INFO)
	Return $returnvalue
EndFunc   ;==>FindImageInPlace

; Same as FindImageInPlace but takes individual coords instead of a string
Func FindImageInPlace2($sImageName, $sImageTile, $iX1 = -1, $iY1 = -1, $iX2 = -1, $iY2 = -1, $bForceCaptureRegion = True, $AndroidTag = Default)
	;creates a reduced capture of the place area a finds the image in that area
	;returns string with X,Y of ACTUALL FULL SCREEN coordinates or Empty if not found
	If $g_bDebugSetlog Then SetDebugLog("FindImageInPlace2 : > " & $sImageName & " - " & $sImageTile, $COLOR_INFO)

	If $iX1 = -1 Or $iX2 = -1 Or $iY1 = -1 Or $iY2 = -1 Then
		SetLog("FindImageInPlace2 : One or more bad input coordinates!", $COLOR_ERROR)
		Return ""
	EndIf

	Local $returnvalue = ""
	;Local $aPlaces = GetRectArray($place)
	Local $sImageArea = $iX1 & "," & $iY1 & "|" & $iX2 & "," & $iY1 & "|" & $iX2 & "," & $iY2 & "|" & $iX1 & "," & $iY2
	If $bForceCaptureRegion = True Then
		$sImageArea = "FV"
		_CaptureRegion2(Number($iX1), Number($iY1), Number($iX2), Number($iY2))
	EndIf
	Local $coords = findImage($sImageName, $sImageTile, $sImageArea, 1, False, $AndroidTag) ; reduce capture full image
	Local $aCoords = decodeSingleCoord($coords)
	If UBound($aCoords) < 2 Then
		If $g_bDebugSetlog Then SetDebugLog("FindImageInPlace : " & $sImageName & " NOT Found", $COLOR_INFO)
		Return ""
	EndIf
	If $bForceCaptureRegion Then
		$returnvalue = Number($aCoords[0]) + Number($iX1) & "," & Number($aCoords[1]) + Number($iY1)
	Else
		$returnvalue = Number($aCoords[0]) & "," & Number($aCoords[1])
	EndIf
	If $g_bDebugSetlog Then SetDebugLog("FindImageInPlace : < " & $sImageName & " Found in " & $returnvalue, $COLOR_INFO)

	;	SetLog("FindImageInPlace : < " & $sImageName & " Found in " & $returnvalue, $COLOR_INFO)

	Return $returnvalue
EndFunc   ;==>FindImageInPlace2

Func SearchRedLines($sCocDiamond = $CocDiamondECD)
	If $g_sImglocRedline <> "" Then Return $g_sImglocRedline
	Local $result = DllCallMyBot("SearchRedLines", "handle", $g_hHBitmap2, "str", $sCocDiamond)
	Local $error = @error ; Store error values as they reset at next function call
	Local $extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		If $g_bDebugSetlog Then SetDebugLog(" imgloc DLL Error : " & $error & " --- " & $extError)
		SetError(2, $extError) ; Set external error code = 2 for DLL error
		Return ""
	EndIf
	If checkImglocError($result, "SearchRedLines") = True Then
		If $g_bDebugSetlog Then SetDebugLog("SearchRedLines Returned Error or No values : ", $COLOR_DEBUG)
		If $g_bDebugSetlog Then SetDebugLog("******** SearchRedLines *** END ***", $COLOR_OLIVE)
		Return ""
	Else
		If $g_bDebugSetlog Then SetDebugLog("SearchRedLines found : " & $result[0])
	EndIf
	$g_sImglocRedline = $result[0]
	Return $g_sImglocRedline
EndFunc   ;==>SearchRedLines

Func SearchRedLinesMultipleTimes($sCocDiamond = $CocDiamondECD, $iCount = 5, $iDelay = 300)
	Local $bHBitmap_synced = ($g_hHBitmap = $g_hHBitmap2)
	Local $g_hHBitmap2_old = $g_hHBitmap2
	Local $g_sImglocRedline_old

	; ensure current $g_sImglocRedline has been generated
	SearchRedLines($sCocDiamond)
	; count # of redline points
	Local $iRedlinePoints = [UBound(StringSplit($g_sImglocRedline, "|", $STR_NOCOUNT)), 0]

	SetDebugLog("Initial # of redline points: " & $iRedlinePoints[0])

	; clear $g_hHBitmap2, so it doesn't get deleted
	$g_hHBitmap2 = 0

	Local $iCaptureTime = 0
	Local $iRedlineTime = 0
	Local $aiTotals = [0, 0]
	Local $iBest = 0

	For $i = 1 To $iCount

		$g_sImglocRedline_old = $g_sImglocRedline

		Local $hTimer = __TimerInit()

		; take new screenshot
		ForceCaptureRegion()
		_CaptureRegion2()

		$iCaptureTime = __TimerDiff($hTimer)

		; generate new redline based on new screenshot
		$g_sImglocRedline = "" ; clear current redline
		SearchRedLines($sCocDiamond)

		$iRedlineTime = __TimerDiff($hTimer) - $iCaptureTime

		$aiTotals[0] += $iCaptureTime
		$aiTotals[1] += $iRedlineTime

		; count # of redline points
		$iRedlinePoints[1] = UBound(StringSplit($g_sImglocRedline, "|", $STR_NOCOUNT))

		SetDebugLog($i & ". # of redline points: " & $iRedlinePoints[1])
		SetLog($i & ". # of redline points: " & $iRedlinePoints[1])

		If $iRedlinePoints[1] > $iRedlinePoints[0] Then
			; new picture has more redline points
			$iRedlinePoints[0] = $iRedlinePoints[1]
			$iBest = $i
		Else
			; old picture has more redline points
			$g_sImglocRedline = $g_sImglocRedline_old
		EndIf

		If $i < $iCount Then
			Local $iDelayCompensated = $iDelay - __TimerDiff($hTimer)
			If $iDelayCompensated >= 10 Then Sleep($iDelayCompensated)
		EndIf

	Next

	If $iBest = 0 Then
		SetDebugLog("Using initial redline with " & $iRedlinePoints[0] & " points")
	Else
		SetDebugLog("Using " & $iBest & ". redline with " & $iRedlinePoints[0] & " points (capture/redline avg. time: " & Int($aiTotals[0] / $iCount) & "/" & Int($aiTotals[1] / $iCount) & ")")
	EndIf

	; delete current $g_hHBitmap2
	GdiDeleteHBitmap($g_hHBitmap2)

	; restore previous captured image
	If $bHBitmap_synced Then
		_CaptureRegion2Sync()
	Else
		$g_hHBitmap2 = $g_hHBitmap2_old
	EndIf
	Return $g_sImglocRedline
EndFunc   ;==>SearchRedLinesMultipleTimes

Func Slot($iX, $iY) ; Return Slots for Quantity Reading on Army Window
	If $iY < 455 Then
		Switch $iX ; Troops & Spells Slots
			Case 75 To 139 ; Slot 1
				Return 85

			Case 140 To 202 ; Slot 2
				Return 150

			Case 203 To 266 ; Slot 3
				Return 215

			Case 266 To 328 ; Slot 4
				Return 280

			Case 329 To 390 ; Slot 5
				Return 340

			Case 391 To 454 ; Slot 6
				Return 405

			Case 455 To 517 ; Slot 7
				Return 465

			Case 575 To 639 ; Slot 8
				Return 585 ; Siege Machines slot 1

			Case 640 To 703 ; Slot 9
				Return 655 ; Siege Machines slot 2

			Case 704 To 768 ; Slot 10
				Return 715 ; Siege Machines slot 2
		EndSwitch
	Else ;CC Troops & Spells
		Switch $iX
			Case 75 To 139 ; Slot 1
				Return 85

			Case 140 To 202 ; Slot 2
				Return 150

			Case 203 To 266 ; Slot 3
				Return 215

			Case 266 To 328 ; Slot 4
				Return 280

			Case 329 To 390 ; Slot 5
				Return 340

			Case 450 To 500 ; CC Spell Slot 1
				Return 455
			Case 501 To 524 ; CC Spell Middle ( Happens with Clan Castles with the max. Capacity of 1!)
				Return 505
			Case 525 To 573 ; CC Spell Slot 2
				Return 520
			Case 598 To 660; CC Siege Machines
				Return 610
		EndSwitch
	EndIf
EndFunc   ;==>Slot

Func GetDummyRectangle($sCoords, $ndistance)
	;creates a dummy rectangle to be used by Reduced Image Capture
	Local $aCoords = StringSplit($sCoords, ",", $STR_NOCOUNT)
	Return Number($aCoords[0]) - $ndistance & "," & Number($aCoords[1]) - $ndistance & "," & Number($aCoords[0]) + $ndistance & "," & Number($aCoords[1]) + $ndistance
EndFunc   ;==>GetDummyRectangle

Func ImgLogDebugProps($result)
	If UBound($result) < 1 Then Return False
	Local $resultArr = StringSplit($result[0], "|", $STR_NOCOUNT)
	Local $returnData = StringSplit("objectname,objectlevel,objectpoints", ",", $STR_NOCOUNT)
	For $rs = 0 To UBound($resultArr) - 1
		For $rD = 0 To UBound($returnData) - 1 ; cycle props
			Local $returnLine = RetrieveImglocProperty($resultArr[$rs], $returnData[$rD])
			SetLog("ImgLogDebugProps : " & $resultArr[$rs] & "->" & $returnData[$rD] & " -> " & $returnLine)
		Next
	Next
EndFunc   ;==>ImgLogDebugProps
