; #FUNCTION# ====================================================================================================================
; Name ..........: Imgloc Aux functions
; Description ...: auxyliary functions used by imgloc
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: Trlopes (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func decodeMultipleCoords($coords)
	;returns array of N coordinates [0=x, 1=y][0=x1, 1=y1]
	Local $retCoords[1] = [""]
	Local $p, $pOff = 0
	If $g_iDebugSetlog = 1 Then SetLog("**decodeMultipleCoords: " & $coords, $COLOR_ORANGE)
	Local $aCoordsSplit = StringSplit($coords, "|", $STR_NOCOUNT)
	If StringInStr($aCoordsSplit[0], ",") > 0 Then
		Local $retCoords[UBound($aCoordsSplit)]
	Else ;has total count in value
		$pOff = 1
		Local $retCoords[Number($aCoordsSplit[0])]
	EndIf
	For $p = 0 To UBound($retCoords) - 1
		$retCoords[$p] = decodeSingleCoord($aCoordsSplit[$p + $pOff])
	Next
	Return $retCoords
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

Func returnImglocProperty($key, $property)
	; Get the property
	Local $aValue = DllCall($g_hLibImgLoc, "str", "GetProperty", "str", $key, "str", $property)
	If checkImglocError($aValue, "returnImglocProperty") = True Then
		Return ""
	EndIf
	Return $aValue[0]
EndFunc   ;==>returnImglocProperty

Func checkImglocError($imglocvalue, $funcName)
	;Return true if there is an error in imgloc return string
	If IsArray($imglocvalue) Then ;despite beeing a string, AutoIt receives a array[0]
		If $imglocvalue[0] = "0" Or $imglocvalue[0] = "" Then
			If $g_iDebugSetlog = 1 Then SetLog($funcName & " imgloc search returned no results!", $COLOR_RED)
			Return True
		ElseIf StringLeft($imglocvalue[0], 2) = "-1" Then ;error
			If $g_iDebugSetlog = 1 Then SetLog($funcName & " - Imgloc DLL Error: " + $imglocvalue[0], $COLOR_RED)
			Return True
		ElseIf StringLeft($imglocvalue[0], 2) = "-2" Then ;critical error
			SetLog($funcName & " - Imgloc DLL Critical Error", $COLOR_RED)
			SetLog(StringMid($imglocvalue[0], 4), $COLOR_RED)
			BotStop() ; stop bot on critical errors
			Return True
		Else
			;If $g_iDebugSetlog Then SetLog($funcName & " imgloc search performed with results!")
			Return False
		EndIf
	Else
		If $g_iDebugSetlog = 1 Then SetLog($funcName & " - Imgloc  Error: Not an Array Result", $COLOR_RED)
		Return True
	EndIf
EndFunc   ;==>checkImglocError

Func findButton($sButtonName, $buttonTileArrayOrPatternOrFullPath = Default, $maxReturnPoints = 1, $bForceCapture = True)

	If $buttonTileArrayOrPatternOrFullPath = Default Then $buttonTileArrayOrPatternOrFullPath = $sButtonName & "*"

	Local $error, $extError
	Local $searchArea = GetButtonDiamond($sButtonName)
	Local $aCoords = "" ; use AutoIt mixed varaible type and initialize array of coordinates to null
	Local $aButtons
	Local $sButtons = ""

	; check if file tile is a pattern
	If IsString($buttonTileArrayOrPatternOrFullPath) Then
		$sButtons = $buttonTileArrayOrPatternOrFullPath
		If StringInStr($buttonTileArrayOrPatternOrFullPath, "*") > 0 Then
			Local $aFiles = _FileListToArray(@ScriptDir & "\imgxml\imglocbuttons", $sButtons, $FLTA_FILES, True)
			If UBound($aFiles) < 2 Or $aFiles[0] < 1 Then
				Return SetError(1, 1, "No files in " & @ScriptDir & "\imgxml\imglocbuttons") ; Set external error code = 1 for bad input values
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

		If $g_iDebugSetlog Then SetLog(" imgloc searching for: " & $sButtonName & " : " & $buttonTile)

		Local $result = DllCall($g_sLibImgLocPath, "str", "FindTile", "handle", $hHBitmap2, "str", $buttonTile, "str", $searchArea, "Int", $maxReturnPoints)
		$error = @error ; Store error values as they reset at next function call
		$extError = @extended
		If $error Then
			_logErrorDLLCall($g_sLibImgLocPath, $error)
			SetDebugLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError)
			Return SetError(2, 1, $extError) ; Set external error code = 2 for DLL error
		EndIf

		If $result[0] <> "" And checkImglocError($result, "imglocFindButton") = False Then
			If $g_iDebugSetlog Then SetLog($sButtonName & " Button Image Found in: " & $result[0])
			$aCoords = StringSplit($result[0], "|", $STR_NOCOUNT)
			;[0] - total points found
			;[1] -  coordinates
			If $maxReturnPoints = 1 Then
				Return StringSplit($aCoords[1], ",", $STR_NOCOUNT) ; return just X,Y coord
			Else
				; @TODO return 2 dimensional array
				Return $result[0] ; return full string with count and points
			EndIf
		EndIf

	Next

	SetDebugLog($sButtonName & " Button Image(s) NOT FOUND : " & $sButtons, $COLOR_ERROR)
	Return $aCoords
EndFunc   ;==>findButton

Func GetButtonDiamond($sButtonName)
	Local $btnDiamond = "FV"

	Switch $sButtonName
		Case "FindMatch" ;Find Match Screen
			$btnDiamond = "133,515|360,515|360,620|133,620"
		Case "CloseFindMatch" ;Find Match Screen
			$btnDiamond = "780,15|830,15|830,60|780,60"
		Case "CloseFindMatch" ;Find Match Screen
			$btnDiamond = "780,15|830,15|830,60|780,60"
		Case "Attack" ;Main Window Screen
			$btnDiamond = "15,620|112,620|112,715|15,715"
		Case "OpenTrainWindow" ;Main Window Screen
			$btnDiamond = "15,560|65,560|65,610|15,610"
		Case "OK"
			$btnDiamond = "440,395|587,395|587,460|440,460"
		Case "CANCEL"
			$btnDiamond = "272,395|420,395|420,460|272,460"
		Case "ReturnHome"
			$btnDiamond = "357,545|502,545|502,607|357,607"
		Case "Next" ; attackpage attackwindow
			$btnDiamond = "697,542|850,542|850,610|697,610"
		Case "ObjectButtons", "BoostOne" ; Full size of object buttons at the bottom
			$btnDiamond = GetDiamondFromRect("200,617(460,83)")
		Case "GEM" ; Boost window button (full button size)
			$btnDiamond = GetDiamondFromRect("359,412(148,66)")
		Case "EnterShop"
			$btnDiamond = GetDiamondFromRect("359,392(148,66)")
		Case "EndBattleSurrender" ;surrender - attackwindow
			$btnDiamond = "12,577|125,577|125,615|12,615"
		Case "ExpandChat" ;mainwindow
			$btnDiamond = "2,330|35,350|35,410|2,430"
		Case "CollapseChat" ;mainwindow
			$btnDiamond = "315,334|350,350|350,410|315,430"
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

		Case Else
			$btnDiamond = "FV" ; use full image to locate button
	EndSwitch
	Return $btnDiamond
EndFunc   ;==>GetButtonDiamond

Func findImage($sImageName, $sImageTile, $sImageArea, $maxReturnPoints = 1, $bForceCapture = True)
	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null
	Local $iPattern = StringInStr($sImageTile, "*")
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
			If $g_iDebugSetlog = 1 Then SetLog("findImage files not found : " & $sImageTile, $COLOR_ERROR)
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
	; nice for dinamic locations
	Local $error, $extError

	; Check function parameters
	If Not FileExists($sImageTile) Then
		If $g_iDebugSetlog = 1 Then SetLog("findImage file not found : " & $sImageTile, $COLOR_ERROR)
		SetError(1, 1, $aCoords) ; Set external error code = 1 for bad input values
		Return
	EndIf

	; Capture the screen for comparison
	; _CaptureRegion2() or similar must be used before
	; Perform the search
	If $bForceCapture Then _CaptureRegion2() ;to have FULL screen image to work with

	If $g_iDebugSetlog Then SetLog("findImage Looking for : " & $sImageName & " : " & $sImageTile & " on " & $sImageArea)

	Local $result = DllCall($g_sLibImgLocPath, "str", "FindTile", "handle", $hHBitmap2, "str", $sImageTile, "str", $sImageArea, "Int", $maxReturnPoints)
	$error = @error ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibImgLocPath, $error)
		If $g_iDebugSetlog Then SetLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError)
		SetError(2, $extError, $aCoords) ; Set external error code = 2 for DLL error
		Return
	EndIf

	If checkImglocError($result, "findImage") = True Then
		If $g_iDebugSetlog = 1 Then SetLog("findImage Returned Error or No values : ", $COLOR_DEBUG)
		If $g_iDebugSetlog = 1 And $g_iDebugImageSave = 1 Then DebugImageSave("findImage_" & $sImageName, True)
		Return $aCoords
	EndIf

	If $result[0] <> "" Then ;despite being a string, AutoIt receives a array[0]
		If $g_iDebugSetlog Then SetLog("findImage : " & $sImageName & " Found in: " & $result[0])
		$aCoords = StringSplit($result[0], "|", $STR_NOCOUNT)
		;[0] - total points found
		;[1] -  coordinates
		If $maxReturnPoints = 1 Then
			Return $aCoords[1] ; return just X,Y coord
		Else
			Return $result[0] ; return full string with count and points
		EndIf
	Else
		If $g_iDebugSetlog = 1 Then SetLog("findImage : " & $sImageName & " NOT FOUND " & $sImageTile)
		If $g_iDebugSetlog = 1 And $g_iDebugImageSave = 1 Then DebugImageSave("findImage_" & $sImageName, True)
		Return $aCoords
	EndIf

EndFunc   ;==>findImage

Func GetDeployableNextTo($sPoints, $distance = 3, $redlineoverride="")
	Local $result = DllCall($g_sLibImgLocPath, "str", "GetDeployableNextTo", "str", $sPoints, "int", $distance, "str" , $redlineoverride)
	Local $error = @error ; Store error values as they reset at next function call
	Local $extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibImgLocPath, $error)
		If $g_iDebugSetlog Then SetLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError)
		SetError(2, $extError, "") ; Set external error code = 2 for DLL error
		Return ""
	EndIf

	If UBound($result) = 0 Then Return ""
	If $g_iDebugSetlog = 1 Then SetLog("GetDeployableNextTo : " & $sPoints & ", dist. = " & $distance & " : " & $result[0], $COLOR_ORANGE)
	Return $result[0]
EndFunc   ;==>GetDeployableNextTo

Func GetOffsetRedline($sArea = "TL", $distance = 3)
	Local $result = DllCall($g_sLibImgLocPath, "str", "GetOffSetRedline", "str", $sArea, "int", $distance)
	Local $error = @error ; Store error values as they reset at next function call
	Local $extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibImgLocPath, $error)
		If $g_iDebugSetlog Then SetLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError)
		SetError(2, $extError, "") ; Set external error code = 2 for DLL error
		Return ""
	EndIf

	If UBound($result) = 0 Then Return ""
	If $g_iDebugSetlog = 1 Then SetLog("GetOffSetRedline : " & $sArea & ", dist. = " & $distance & " : " & $result[0], $COLOR_ORANGE)
	Return $result[0]
EndFunc   ;==>GetOffsetRedline

Func findMultiple($directory, $sCocDiamond, $redLines, $minLevel = 0, $maxLevel = 1000, $maxReturnPoints = 0, $returnProps = "objectname,objectlevel,objectpoints", $bForceCapture = True)
	; same has findButton, but allow custom area instead of button area decoding
	; nice for dinamic locations
	If $g_iDebugSetlog = 1 Then
		SetLog("******** findMultiple *** START ***", $COLOR_ORANGE)
		SetLog("findMultiple : directory : " & $directory, $COLOR_ORANGE)
		SetLog("findMultiple : sCocDiamond : " & $sCocDiamond, $COLOR_ORANGE)
		SetLog("findMultiple : redLines : " & $redLines, $COLOR_ORANGE)
		SetLog("findMultiple : minLevel : " & $minLevel, $COLOR_ORANGE)
		SetLog("findMultiple : maxLevel : " & $maxLevel, $COLOR_ORANGE)
		SetLog("findMultiple : maxReturnPoints : " & $maxReturnPoints, $COLOR_ORANGE)
		SetLog("findMultiple : returnProps : " & $returnProps, $COLOR_ORANGE)
		SetLog("******** findMultiple *** START ***", $COLOR_ORANGE)
	EndIf

	Local $error, $extError

	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null
	Local $returnData = StringSplit($returnProps, ",", $STR_NOCOUNT)
	Local $returnLine[UBound($returnData)]
	Local $returnValues[0]


	; Capture the screen for comparison
	; Perform the search
	If $bForceCapture Then _CaptureRegion2() ;to have FULL screen image to work with

	Local $result = DllCall($g_sLibImgLocPath, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", $sCocDiamond, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	$error = @error ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibImgLocPath, $error)
		If $g_iDebugSetlog = 1 Then SetLog(" imgloc DLL Error : " & $error & " --- " & $extError)
		SetError(2, $extError, $aCoords) ; Set external error code = 2 for DLL error
		Return ""
	EndIf

	;If $g_iDebugSetlog = 1 Then SetLog(" imglocFindMultiple " &  $result[0])
	If checkImglocError($result, "findMultiple") = True Then
		If $g_iDebugSetlog = 1 Then SetLog("findMultiple Returned Error or No values : ", $COLOR_DEBUG)
		If $g_iDebugSetlog = 1 Then SetLog("******** findMultiple *** END ***", $COLOR_ORANGE)
		Return ""
	Else
		If $g_iDebugSetlog = 1 Then SetLog("findMultiple found : " & $result[0])
	EndIf

	If $result[0] <> "" Then ;despite being a string, AutoIt receives a array[0]
		Local $resultArr = StringSplit($result[0], "|", $STR_NOCOUNT)
		ReDim $returnValues[UBound($resultArr)]
		For $rs = 0 To UBound($resultArr) - 1
			For $rD = 0 To UBound($returnData) - 1 ; cycle props
				$returnLine[$rD] = returnImglocProperty($resultArr[$rs], $returnData[$rD])
				If $g_iDebugSetlog = 1 Then SetLog("findMultiple : " & $resultArr[$rs] & "->" & $returnData[$rD] & " -> " & $returnLine[$rD])
			Next
			$returnValues[$rs] = $returnLine
		Next

		;;lets check if we should get redlinedata
		If $redLines = "" Then
			$IMGLOCREDLINE = returnImglocProperty("redline", "") ;global var set in imglocTHSearch
			If $g_iDebugSetlog = 1 Then SetLog("findMultiple : Redline argument is emty, seting global Redlines")
		EndIf
		If $g_iDebugSetlog = 1 Then SetLog("******** findMultiple *** END ***", $COLOR_ORANGE)
		Return $returnValues

	Else
		If $g_iDebugSetlog = 1 Then SetLog(" ***  findMultiple has no result **** ", $COLOR_ORANGE)
		If $g_iDebugSetlog = 1 Then SetLog("******** findMultiple *** END ***", $COLOR_ORANGE)
		Return ""
	EndIf

EndFunc   ;==>findMultiple

Func GetDiamondFromRect($rect)
	;receives "StartX,StartY,EndX,EndY" or "StartX,StartY(Width,Height)"
	;returns "StartX,StartY|EndX,StartY|EndX,EndY|StartX,EndY"
	Local $returnvalue = "", $i
	If $g_iDebugSetlog = 1 Then SetLog("GetDiamondFromRect : > " & $rect, $COLOR_INFO)
	Local $RectValues = StringSplit($rect, ",", $STR_NOCOUNT)
	If UBound($RectValues) = 3 Then
		ReDim $RectValues[4]
		; check for width and height
		$i = StringInStr($RectValues[2], ")")
		If $i = 0 Then
			SetDebugLog("GetDiamondFromRect : Bad Input Values : " & $rect, $COLOR_ERROR)
			Return SetError(1, 1, $returnvalue)
		EndIf
		$RectValues[3] = $RectValues[1] + StringLeft($RectValues[2], $i - 1) - 1
		$i = StringInStr($RectValues[1], "(")
		If $i = 0 Then
			SetDebugLog("GetDiamondFromRect : Bad Input Values : " & $rect, $COLOR_ERROR)
			Return SetError(1, 2, $returnvalue)
		EndIf
		$RectValues[2] = $RectValues[0] + StringMid($RectValues[1], $i + 1) - 1
		$RectValues[1] = StringLeft($RectValues[1], $i - 1)
	EndIf
	If UBound($RectValues) < 4 Then
		SetDebugLog("GetDiamondFromRect : Bad Input Values : " & $rect, $COLOR_ERROR)
		Return SetError(1, 3, $returnvalue)
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
	If $g_iDebugSetlog = 1 Then SetLog("GetDiamondFromRect : < " & $returnvalue, $COLOR_INFO)
	Return $returnvalue
EndFunc   ;==>GetDiamondFromRect

Func FindImageInPlace($sImageName, $sImageTile, $place, $bForceCaptureRegion = True)
	;creates a reduced capture of the place area a finds the image in that area
	;returns string with X,Y of ACTUALL FULL SCREEN coordinates or Empty if not found
	If $g_iDebugSetlog = 1 Then SetLog("FindImageInPlace : > " & $sImageName & " - " & $sImageTile & " - " & $place, $COLOR_INFO)
	Local $returnvalue = ""
	Local $sImageArea = GetDiamondFromRect($place)
	Local $aPlaces = StringSplit($place, ",", $STR_NOCOUNT)
	If $bForceCaptureRegion = True Then
		$sImageArea = "FV"
		_CaptureRegion2(Number($aPlaces[0]), Number($aPlaces[1]), Number($aPlaces[2]), Number($aPlaces[3]))
	EndIf
	Local $coords = findImage($sImageName, $sImageTile, $sImageArea, 1, False) ; reduce capture full image
	Local $aCoords = decodeSingleCoord($coords)
	If UBound($aCoords) < 2 Then
		If $g_iDebugSetlog = 1 Then SetLog("FindImageInPlace : " & $sImageName & " NOT Found", $COLOR_INFO)
		Return ""
	EndIf
	If $bForceCaptureRegion = True Then
		$returnvalue = Number($aCoords[0]) + Number($aPlaces[0]) & "," & Number($aCoords[1]) + Number($aPlaces[1])
	Else
		$returnvalue = Number($aCoords[0]) & "," & Number($aCoords[1])
	EndIf
	If $g_iDebugSetlog = 1 Then SetLog("FindImageInPlace : < " & $sImageName & " Found in " & $returnvalue, $COLOR_INFO)
	Return $returnvalue
EndFunc   ;==>FindImageInPlace

Func SearchRedLines($sCocDiamond = "ECD")
	If $IMGLOCREDLINE <> "" Then Return $IMGLOCREDLINE
	Local $result = DllCall($g_hLibImgLoc, "str", "SearchRedLines", "handle", $hHBITMAP2, "str", $sCocDiamond)
	Local $error = @error ; Store error values as they reset at next function call
	Local $extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibImgLocPath, $error)
		If $g_iDebugSetlog = 1 Then SetLog(" imgloc DLL Error : " & $error & " --- " & $extError)
		SetError(2, $extError) ; Set external error code = 2 for DLL error
		Return ""
	EndIf
	;If $g_iDebugSetlog = 1 Then SetLog(" imglocFindMultiple " &  $result[0])
	If checkImglocError($result, "SearchRedLines") = True Then
		If $g_iDebugSetlog = 1 Then SetLog("SearchRedLines Returned Error or No values : ", $COLOR_DEBUG)
		If $g_iDebugSetlog = 1 Then SetLog("******** SearchRedLines *** END ***", $COLOR_ORANGE)
		Return ""
	Else
		If $g_iDebugSetlog = 1 Then SetLog("SearchRedLines found : " & $result[0])
	EndIf
	$IMGLOCREDLINE = $result[0]
	Return $IMGLOCREDLINE
EndFunc   ;==>SearchRedLines

Func SearchRedLinesMultipleTimes($sCocDiamond = "ECD", $iCount = 3, $iDelay = 300)
	Local $bHBITMAP_synced = ($hHBITMAP = $hHBITMAP2)
	Local $hHBITMAP2_old = $hHBITMAP2
	Local $IMGLOCREDLINE_old

	; ensure current $IMGLOCREDLINE has been generated
	SearchRedLines($sCocDiamond)
	; count # of redline points
	Local $iRedlinePoints = [UBound(StringSplit($IMGLOCREDLINE, "|", $STR_NOCOUNT)), 0]

	SetDebugLog("Initial # of redline points: " & $iRedlinePoints[0])

	; clear $hHBITMAP2, so it doesn't get deleted
	$hHBITMAP2 = 0

	Local $iCaptureTime = 0
	Local $iRedlineTime = 0
	Local $aiTotals = [0, 0]
	Local $iBest = 0

	For $i = 1 To $iCount

		$IMGLOCREDLINE_old = $IMGLOCREDLINE

		Local $hTimer = TimerInit()

		; take new screenshot
		ForceCaptureRegion()
		_CaptureRegion2()

		$iCaptureTime = TimerDiff($hTimer)

		; generate new redline based on new screenshot
		$IMGLOCREDLINE = "" ; clear current redline
		SearchRedLines($sCocDiamond)

		$iRedlineTime = TimerDiff($hTimer) - $iCaptureTime

		$aiTotals[0] += $iCaptureTime
		$aiTotals[1] += $iRedlineTime

		; count # of redline points
		$iRedlinePoints[1] = UBound(StringSplit($IMGLOCREDLINE, "|", $STR_NOCOUNT))

		SetDebugLog($i & ". # of redline points: " & $iRedlinePoints[1])

		If $iRedlinePoints[1] > $iRedlinePoints[0] Then
			; new picture has more redline points
			$iRedlinePoints[0] = $iRedlinePoints[1]
			$iBest = $i
		Else
			; old picture has more redline points
			$IMGLOCREDLINE = $IMGLOCREDLINE_old
		EndIf

		If $i < $iCount Then
			Local $iDelayCompensated = $iDelay - TimerDiff($hTimer)
			If $iDelayCompensated >= 10 Then Sleep($iDelayCompensated)
		EndIf

	Next

	If $iBest = 0 Then
		SetDebugLog("Using initial redline with " & $iRedlinePoints[0] & " points")
	Else
		SetDebugLog("Using " & $iBest & ". redline with " & $iRedlinePoints[0] & " points (capture/redline avg. time: " & Int($aiTotals[0] / $iCount) & "/" & Int($aiTotals[1] / $iCount) & ")")
	EndIf

	; delete current $hHBITMAP2
	_WinAPI_DeleteObject($hHBITMAP2)

	; restore previous captured image
	If $bHBITMAP_synced Then
		_CaptureRegion2Sync()
	Else
		$hHBITMAP2 = $hHBITMAP2_old
	EndIf
	Return $IMGLOCREDLINE
EndFunc

Func decodeTroopEnum($tEnum)
	Switch $tEnum
		Case $eBarb
			Return "Barbarian"
		Case $eArch
			Return "Archer"
		Case $eBall
			Return "Balloon"
		Case $eDrag
			Return "Dragon"
		Case $eGiant
			Return "Giant"
		Case $eGobl
			Return "Goblin"
		Case $eGole
			Return "Golem"
		Case $eHeal
			Return "Healer"
		Case $eHogs
			Return "HogRider"
		Case $eKing
			Return "King"
		Case $eLava
			Return "LavaHound"
		Case $eMini
			Return "Minion"
		Case $ePekk
			Return "Pekka"
		Case $eQueen
			Return "Queen"
		Case $eValk
			Return "Valkyrie"
		Case $eWall
			Return "WallBreaker"
		Case $eWarden
			Return "Warden"
		Case $eWitc
			Return "Witch"
		Case $eWiza
			Return "Wizard"
		Case $eBabyD
			Return "BabyDragon"
		Case $eMine
			Return "Miner"
		Case $eBowl
			Return "Bowler"
		Case $eESpell
			Return "EarthquakeSpell"
		Case $eFSpell
			Return "FreezeSpell"
		Case $eHaSpell
			Return "HasteSpell"
		Case $eHSpell
			Return "HealSpell"
		Case $eJSpell
			Return "JumpSpell"
		Case $eLSpell
			Return "LightningSpell"
		Case $ePSpell
			Return "PoisonSpell"
		Case $eRSpell
			Return "RageSpell"
		Case $eSkSpell
			Return "SkeletonSpell"
		Case $eCSpell
			Return "CloneSpell"
		Case $eCastle
			Return "Castle"
	EndSwitch

EndFunc   ;==>decodeTroopEnum


Func decodeTroopName($sName)

	Switch $sName
		Case "Barbarian"
			Return $eBarb
		Case "Archer"
			Return $eArch
		Case "Balloon"
			Return $eBall
		Case "Dragon"
			Return $eDrag
		Case "Giant"
			Return $eGiant
		Case "Goblin"
			Return $eGobl
		Case "Golem"
			Return $eGole
		Case "Healer"
			Return $eHeal
		Case "HogRider"
			Return $eHogs
		Case "King"
			Return $eKing
		Case "LavaHound"
			Return $eLava
		Case "Minion"
			Return $eMini
		Case "Pekka"
			Return $ePekk
		Case "Queen"
			Return $eQueen
		Case "Valkyrie"
			Return $eValk
		Case "WallBreaker"
			Return $eWall
		Case "Warden"
			Return $eWarden
		Case "Witch"
			Return $eWitc
		Case "Wizard"
			Return $eWiza
		Case "BabyDragon"
			Return $eBabyD
		Case "Miner"
			Return $eMine
		Case "Bowler"
			Return $eBowl
		Case "EarthquakeSpell"
			Return $eESpell
		Case "FreezeSpell"
			Return $eFSpell
		Case "HasteSpell"
			Return $eHaSpell
		Case "HealSpell"
			Return $eHSpell
		Case "JumpSpell"
			Return $eJSpell
		Case "LightningSpell"
			Return $eLSpell
		Case "PoisonSpell"
			Return $ePSpell
		Case "RageSpell"
			Return $eRSpell
		Case "SkeletonSpell"
			Return $eSkSpell
		Case "CloneSpell"
			Return $eCSpell
		Case "Castle"
			Return $eCastle

	EndSwitch

EndFunc   ;==>decodeTroopName


Func GetDummyRectangle($sCoords, $ndistance)
	;creates a dummy rectangle to be used by Reduced Image Capture
	Local $aCoords = StringSplit($sCoords, ",", $STR_NOCOUNT)
	Return Number($aCoords[0]) - $ndistance & "," & Number($aCoords[1]) - $ndistance & "," & Number($aCoords[0]) + $ndistance & "," & Number($aCoords[1]) + $ndistance
EndFunc   ;==>GetDummyRectangle
