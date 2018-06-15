; #FUNCTION# ====================================================================================================================
; Name ..........: Imgloc Aux functions
; Description ...: auxyliary functions used by imgloc
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: Trlopes (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func decodeMultipleCoords($coords, $iDedupX = -1, $iDedupY = -1, $iSorted = -1)
	;returns array of N coordinates [0=x, 1=y][0=x1, 1=y1]
	Local $retCoords
	Local $aEmpty[1] = [""]
	Local $p, $pOff = 0
	;	SetDebugLog("**decodeMultipleCoords: " & $coords, $COLOR_DEBUG)
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

	If UBound($retCoords) = 0 Then Return $aEmpty
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
		Local $a[UBound($aFinalCoords)][2]
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

Func checkImglocError(ByRef $imglocvalue, $funcName, $sTileSource = "")
	;Return true if there is an error in imgloc return string
	If IsArray($imglocvalue) Then ;despite beeing a string, AutoIt receives a array[0]
		If $imglocvalue[0] = "0" Or $imglocvalue[0] = "" Then
			If $g_bDebugSetlog Then SetDebugLog($funcName & " imgloc search returned no results" & ($sTileSource ? " for '" & $sTileSource & "' !" : "!"), $COLOR_WARNING)
			Return True
		ElseIf StringLeft($imglocvalue[0], 2) = "-1" Then ;error
			If $g_bDebugSetlog Then SetDebugLog($funcName & " - Imgloc DLL Error: " + $imglocvalue[0], $COLOR_ERROR)
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
		Case "ObjectButtons", "BoostOne", "BoostCT" ; Full size of object buttons at the bottom
			$btnDiamond = GetDiamondFromRect("200,617(460,83)")
		Case "GEM", "BOOSTBtn" ; Boost window button (full button size)
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
		Case "Treasury"
			$btnDiamond = "125,610|740,610|740,715|125,715"
		Case "Collect"
			$btnDiamond = "350,450|505,450|505,521|350,521"
		Case "BoostBarrack", "BarrackBoosted"
			$btnDiamond = GetDiamondFromRect("630,280,850,360")
		Case "ArmyTab", "TrainTroopsTab", "BrewSpellsTab", "BuildSiegeMachinesTab", "QuickTrainTab"
			$btnDiamond = GetDiamondFromRect("18,100,800,150")
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
	; nice for dinamic locations
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

	If checkImglocError($result, "findImage", $sImageTile) = True Then
		If $g_bDebugSetlog And $g_bDebugImageSave Then DebugImageSave("findImage_" & $sImageName, True)
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
		If $g_bDebugSetlog And $g_bDebugImageSave Then DebugImageSave("findImage_" & $sImageName, True)
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
	If $g_bDebugSetlog Then SetDebugLog("GetDeployableNextTo : " & $sPoints & ", dist. = " & $distance & " : " & $result[0], $COLOR_ORANGE)
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
	If $g_bDebugSetlog Then SetDebugLog("GetOffSetRedline : " & $sArea & ", dist. = " & $distance & " : " & $result[0], $COLOR_ORANGE)
	Return $result[0]
EndFunc   ;==>GetOffsetRedline

Func findMultiple($directory, $sCocDiamond, $redLines, $minLevel = 0, $maxLevel = 1000, $maxReturnPoints = 0, $returnProps = "objectname,objectlevel,objectpoints", $bForceCapture = True)
	; same has findButton, but allow custom area instead of button area decoding
	; nice for dinamic locations
	If $g_bDebugSetlog Then
		SetDebugLog("******** findMultiple *** START ***", $COLOR_ORANGE)
		SetDebugLog("findMultiple : directory : " & $directory, $COLOR_ORANGE)
		SetDebugLog("findMultiple : sCocDiamond : " & $sCocDiamond, $COLOR_ORANGE)
		SetDebugLog("findMultiple : redLines : " & $redLines, $COLOR_ORANGE)
		SetDebugLog("findMultiple : minLevel : " & $minLevel, $COLOR_ORANGE)
		SetDebugLog("findMultiple : maxLevel : " & $maxLevel, $COLOR_ORANGE)
		SetDebugLog("findMultiple : maxReturnPoints : " & $maxReturnPoints, $COLOR_ORANGE)
		SetDebugLog("findMultiple : returnProps : " & $returnProps, $COLOR_ORANGE)
		SetDebugLog("******** findMultiple *** START ***", $COLOR_ORANGE)
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
		If $g_bDebugSetlog Then SetDebugLog("******** findMultiple *** END ***", $COLOR_ORANGE)
		Return ""
	Else
		If $g_bDebugSetlog Then SetDebugLog("findMultiple found : " & $result[0])
	EndIf

	If $result[0] <> "" Then ;despite being a string, AutoIt receives a array[0]
		Local $resultArr = StringSplit($result[0], "|", $STR_NOCOUNT)
		ReDim $returnValues[UBound($resultArr)]
		For $rs = 0 To UBound($resultArr) - 1
			For $rD = 0 To UBound($returnData) - 1 ; cycle props
				$returnLine[$rD] = RetrieveImglocProperty($resultArr[$rs], $returnData[$rD])
				If $g_bDebugSetlog Then SetDebugLog("findMultiple : " & $resultArr[$rs] & "->" & $returnData[$rD] & " -> " & $returnLine[$rD])
			Next
			$returnValues[$rs] = $returnLine
		Next

		;;lets check if we should get redlinedata
		If $redLines = "" Then
			$g_sImglocRedline = RetrieveImglocProperty("redline", "") ;global var set in imglocTHSearch
			If $g_bDebugSetlog Then SetDebugLog("findMultiple : Redline argument is emty, seting global Redlines")
		EndIf
		If $g_bDebugSetlog Then SetDebugLog("******** findMultiple *** END ***", $COLOR_ORANGE)
		Return $returnValues

	Else
		If $g_bDebugSetlog Then SetDebugLog(" ***  findMultiple has no result **** ", $COLOR_ORANGE)
		If $g_bDebugSetlog Then SetDebugLog("******** findMultiple *** END ***", $COLOR_ORANGE)
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

Func SearchRedLines($sCocDiamond = "ECD")
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
		If $g_bDebugSetlog Then SetDebugLog("******** SearchRedLines *** END ***", $COLOR_ORANGE)
		Return ""
	Else
		If $g_bDebugSetlog Then SetDebugLog("SearchRedLines found : " & $result[0])
	EndIf
	$g_sImglocRedline = $result[0]
	Return $g_sImglocRedline
EndFunc   ;==>SearchRedLines

Func SearchRedLinesMultipleTimes($sCocDiamond = "ECD", $iCount = 3, $iDelay = 300)
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
		Case $eEDrag
			Return "ElectroDragon"
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
		Case "ElectroDragon"
			Return $eEDrag
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

Func Slot($iX, $iY) ; Return Slots for Quantity Reading on Army Window
	If $iY < 490 Then
		Switch $iX ; Troops & Spells Slots
			Case 0 To 94 ; Slot 1
				If $iY < 315 Then Return 35 ; Troops
				If $iY > 315 Then Return 40 ; Spells

			Case 95 To 170 ; Slot 2
				If $iY < 315 Then Return 111 ; Troops
				If $iY > 315 Then Return 120 ; Spell

			Case 171 To 243 ; Slot 3
				If $iY < 315 Then Return 184 ; Troops
				If $iY > 315 Then Return 195 ; Spell

			Case 244 To 307 ; Slot 4
				If $iY < 315 Then Return 255 ; Troops
				If $iY > 315 Then Return 272 ; Spell

			Case 308 To 392 ; Slot 5
				If $iY < 315 Then Return 330 ; Troops
				If $iY > 315 Then Return 341 ; Spell

			Case 393 To 464 ; Slot 6
				If $iY < 315 Then Return 403 ; Troops
				If $iY > 315 Then Return 415 ; Spell

			Case 465 To 537 ; Slot 7
				If $iY < 315 Then Return 477 ; Troops
				If $iY > 315 Then Return 485 ; Spell
			Case 538 To 610 ; Slot 8
				Return 551 ; Troops

			Case 611 To 682 ; Slot 9
				If $iY < 315 Then Return 625 ; Troops
				If $iY > 315 Then Return 619 ; Heroes

			Case 683 To 752 ; Slot 10
				If $iY < 315 Then Return 694 ; Troops
				If $iY > 315 Then Return 691 ; Heroes

			Case 753 To 825 ; Slot 11
				Return 764 ; Troops

		EndSwitch
	Else ;CC Troops & Spells
		Switch $iX
			Case 0 To 94 ; CC Troops Slot 1
				Return 35

			Case 95 To 170 ; CC Troops Slot 2
				Return 111

			Case 171 To 243 ; CC Troops Slot 3
				Return 184

			Case 244 To 307 ; CC Troops Slot 4
				Return 255

			Case 308 To 392 ; CC Troops Slot 5
				Return 330

			Case 393 To 464 ; CC Troops Slot 6
				Return 403

			Case 510 To 580 ; CC Spell Slot 1
				Return 533
			Case 581 To 599 ; CC Spell Middle ( Happens with Clan Castles with the max. Capacity of 1!)
				Return 578
			Case 600 To 660 ; CC Spell Slot 2
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
