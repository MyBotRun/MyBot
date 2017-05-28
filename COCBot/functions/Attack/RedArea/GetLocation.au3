; #FUNCTION# ====================================================================================================================
; Name ..........: GetLocationMine
; Description ...:
; Syntax ........: GetLocationMine()
; Parameters ....:
; Return values .: String with locations
; Author ........:
; Modified ......: ProMac (04-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetLocationMine()

	Local $directory = @ScriptDir & "\imgxml\Storages\GoldMines"
	Local $txt = "Mines"
	Local $Maxpositions = 7

	; Snow Theme detected
	If $g_iDetectedImageType = 1 Then
		$directory = @ScriptDir & "\imgxml\Storages\Mines_Snow"
		$txt = "SnowMines"
	EndIf

	Local $aResult = returnMultipleMatches($directory, $Maxpositions)
	Local $result = ConvertImgloc2MBR($aResult, $Maxpositions)
	If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocation" & $txt & ": " & $result, $COLOR_DEBUG)
	If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result, $txt)

	Return GetListPixel($result)
EndFunc   ;==>GetLocationMine

Func GetLocationElixir()
	Local $directory = @ScriptDir & "\imgxml\Storages\Collectors"
	Local $txt = "Collectors"
	Local $Maxpositions = 7

	; Snow Theme detected
	If $g_iDetectedImageType = 1 Then
		$directory = @ScriptDir & "\imgxml\Storages\Collectors_Snow"
		$txt = "SnowCollectors"
	EndIf

	Local $aResult = returnMultipleMatches($directory, $Maxpositions)
	Local $result = ConvertImgloc2MBR($aResult, $Maxpositions)
	If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocation" & $txt & ": " & $result, $COLOR_DEBUG)
	If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result, $txt)

	Return GetListPixel($result)
EndFunc   ;==>GetLocationElixir

Func GetLocationDarkElixir()
	;Local $result = DllCall($g_hLibMyBot, "str", "getLocationDarkElixirExtractor", "ptr", $g_hHBitmap2)
	Local $directory = @ScriptDir & "\imgxml\Storages\Drills"
	Local $Maxpositions = 3
	Local $aResult = returnMultipleMatches($directory, $Maxpositions)
	Local $result = ConvertImgloc2MBR($aResult, $Maxpositions)

	If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixir: " & $result, $COLOR_DEBUG)
	If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result, "DarkElixir")

	Return GetListPixel($result)
EndFunc   ;==>GetLocationDarkElixir

Func GetLocationTownHall()
	Local $result = DllCall($g_hLibMyBot, "str", "getLocationTownHall", "ptr", $g_hHBitmap2)
	If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocationTownHall: " & $result[0], $COLOR_DEBUG)
	If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "TownHall")
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationTownHall

Func GetLocationDarkElixirStorageWithLevel()
	Local $result = DllCall($g_hLibMyBot, "str", "getLocationDarkElixirStorageWithLevel", "ptr", $g_hHBitmap2)
	If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixirStorageWithLevel: " & $result[0], $COLOR_DEBUG)
	If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "DarkElixirStorageWithLevel")
	Return $result[0]
EndFunc   ;==>GetLocationDarkElixirStorageWithLevel

Func GetLocationDarkElixirStorage()
	Local $result = DllCall($g_hLibMyBot, "str", "getLocationDarkElixirStorage", "ptr", $g_hHBitmap2)
	If $g_iDebugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixirStorage: " & $result[0], $COLOR_DEBUG)
	If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "DarkElixirStorage")
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationDarkElixirStorage

Func GetLocationElixirWithLevel()
	;NOTE AROUND RETURNED LEVEL:
	; LEV 0 elixir extractors from level 1 to level 4
	; LEV 1 elixir extractors level 5
	; LEV 2 elixir extractors level 6
	; LEV 3 elixir extractors level 7
	; LEV 4 elixir extractors level 8
	; LEV 5 elixir extractors level 9
	; LEV 6 elixir extractors level 10
	; LEV 7 elixir extractors level 11
	; LEV 8 elixir extractors level 12

	If $g_iDetectedImageType = 0 Then
		Local $result = DllCall($g_hLibMyBot, "str", "getLocationElixirExtractorWithLevel", "ptr", $g_hHBitmap2)
		If $g_iDebugBuildingPos = 1 Then Setlog("#*# getLocationElixirExtractorWithLevel: " & $result[0], $COLOR_DEBUG)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "ElixirExtractorWithLevel")
	Else
		Local $result = DllCall($g_hLibMyBot, "str", "getLocationSnowElixirExtractorWithLevel", "ptr", $g_hHBitmap2)
		If $g_iDebugBuildingPos = 1 Then Setlog("#*# getLocationSnowElixirExtractorWithLevel: " & $result[0], $COLOR_DEBUG)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "SnowElixirExtractorWithLevel")
	EndIf
	Return $result[0]
EndFunc   ;==>GetLocationElixirWithLevel

Func GetLocationMineWithLevel()
	;NOTE AROUND RETURNED LEVEL:
	; LEV 0 gold mine from level 1 to level 4
	; LEV 1 gold mine level 5
	; LEV 2 gold mine level 6
	; LEV 3 gold mine level 7
	; LEV 4 gold mine level 8
	; LEV 5 gold mine level 9
	; LEV 6 gold mine level 10
	; LEV 7 gold mine level 11
	; LEV 8 gold mine level 12

	If $g_iDetectedImageType = 0 Then
		Local $result = DllCall($g_hLibMyBot, "str", "getLocationMineExtractorWithLevel", "ptr", $g_hHBitmap2)
		If $g_iDebugBuildingPos = 1 Then Setlog("#*# getLocationMineExtractorWithLevel: " & $result[0], $COLOR_DEBUG)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "MineExtractorWithLevel")

	Else
		Local $result = DllCall($g_hLibMyBot, "str", "getLocationSnowMineExtractorWithLevel", "ptr", $g_hHBitmap2)
		If $g_iDebugBuildingPos = 1 Then Setlog("#*# getLocationSnowMineExtractorWithLevel: " & $result[0], $COLOR_DEBUG)
		If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result[0], "SnowMineExtractorWithLevel")
	EndIf
	Return $result[0]
EndFunc   ;==>GetLocationMineWithLevel

Func GetLocationDarkElixirWithLevel()
	;Local $result = DllCall($g_hLibMyBot, "str", "getLocationDarkElixirExtractorWithLevel", "ptr", $g_hHBitmap2)

	Local $directory = @ScriptDir & "\imgxml\Storages\Drills"
	Local $Maxpositions = 3
	Local $aResult = returnMultipleMatches($directory, $Maxpositions)
	Local $result = ConvertImgloc2MBR($aResult, $Maxpositions, True)
	If $g_iDebugBuildingPos = 1 Then Setlog("#*# getLocationDarkElixirExtractorWithLevel: " & $result, $COLOR_DEBUG)
	If $g_iDebugGetLocation = 1 Then DebugImageGetLocation($result, "DarkElixirExtractorWithLevel")

	Return $result
EndFunc   ;==>GetLocationDarkElixirWithLevel


; #FUNCTION# ====================================================================================================================
; Name ..........: GetLocationBuilding
; Description ...: Finds any buildings in global enum & $g_sBldgNames list, saves property data into $g_oBldgAttackInfo dictionary.
; Syntax ........: GetLocationBuilding($iBuildingType[, $iAttackingTH = 11[, $forceCaptureRegion = True]])
; Parameters ....: $iBuildingType       - an integer value with enum of building to find and retrieve information about from  $g_sBldgNames list
;                  $iAttackingTH        - [optional] an integer value of TH being attacked. Default is 11. Lower TH level reduces # of images by setting MaxLevel
;                  $bforceCaptureRegion  - [optional] a boolean value. Default is True. "False" avoids repetitive capture of same base for multiple finds in row.
; Return values .: None
; Author ........: MonkeyHunter (04-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetLocationBuilding($iBuildingType, $iAttackingTH = 11, $bForceCaptureRegion = True)

	If $g_iDebugSetlog = 1 Then Setlog("Begin GetLocationBuilding: " & $g_sBldgNames[$iBuildingType], $COLOR_DEBUG1)
	Local $hTimer = __TimerInit() ; timer to track image detection time

	; Variables
	Local $TotalBuildings = 0
	Local $minLevel = 0
	Local $statFile = ""
	Local $fullCocAreas = "DCD"
	Local $BuildingXY, $redLines, $bRedLineExists, $aBldgCoord, $sTempCoord, $tmpNumFound
	Local $tempNewLevel, $tempExistingLevel, $sLocCoord, $sNearCoord, $sFarCoord, $directory, $iCountUpdate

	; error proof TH level
	If $iAttackingTH = "-" Then $iAttackingTH = 11

	; Get path to image file
	If _ObjSearch($g_oBldgImages, $iBuildingType & "_" & $g_iDetectedImageType) = True Then ; check if image exists to prevent error when snow images are not avialable for building type
		$directory = _ObjGetValue($g_oBldgImages, $iBuildingType & "_" & $g_iDetectedImageType)
		If @error Then
			_ObjErrMsg("_ObjGetValue $g_oBldgImages " & $g_sBldgNames[$iBuildingType] & ($g_iDetectedImageType = 1 ? "Snow " : " "), @error) ; Log COM error prevented
			SetError(1, 0, -1) ; unknown image, must exit find
			Return
		EndIf
	Else
		$directory = _ObjGetValue($g_oBldgImages, $iBuildingType & "_0") ; fall back to regular non-snow image if needed
		If @error Then
			_ObjErrMsg("_ObjGetValue $g_oBldgImages" & $g_sBldgNames[$iBuildingType], @error) ; Log COM error prevented
			SetError(1, 0, -1) ; unknown image, must exit find
			Return
		EndIf
	EndIf

	; Get max number of buildings available for TH level
	Local $maxReturnPoints = _ObjGetValue($g_oBldgMaxQty, $iBuildingType)[$iAttackingTH - 1]
	If @error Then
		_ObjErrMsg("_ObjGetValue $g_oBldgMaxQty", @error) ; Log COM error prevented
		$maxReturnPoints = 20 ; unknown number of buildings, then set equal to 20 and keep going
	EndIf

	; Get redline data
	If _ObjSearch($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS") = True Then
		If _ObjGetValue($g_oBldgAttackInfo, $eBldgRedLine & "_COUNT") > 50 Then ; if count is less 50, try again to more red line locations
			$redLines = _ObjGetValue($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS")
			If @error Then _ObjErrMsg("_ObjGetValue $g_oBldgAttackInfo redline", @error) ; Log COM error prevented
			If IsString($redLines) And $redLines <> "" And $redLines <> "ECD" Then ; error check for null red line data in dictionary
				$bRedLineExists = True
			Else
				$redLines = ""
				$bRedLineExists = False
			EndIf
		Else ; if less than 25 redline stored, then try again.
			$redLines = ""
			$bRedLineExists = False
		EndIf
	Else
		$redLines = ""
		$bRedLineExists = False
	EndIf

	; get max building level available for TH
	Local $maxLevel = _ObjGetValue($g_oBldgLevels, $iBuildingType)[$iAttackingTH - 1]
	If @error Then
		_ObjErrMsg("_ObjGetValue $g_oBldgLevels", @error) ; Log COM error prevented
		$maxLevel = 20 ; unknown number of building levels, then set equal to 20
	EndIf

	If $bForceCaptureRegion = True Then _CaptureRegion2()

	; Perform the search
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", $fullCocAreas, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	If @error Then _logErrorDLLCall($g_sLibImgLocPath, @error)
	If checkImglocError($res, "SearchMultipleTilesBetweenLevels") = True Then ; check for bad values returned from DLL
		SetError(2, 1, 1) ; set return = 1 when no building found
		Return
	EndIf

	;	Get the redline data
	If $bRedLineExists = False Then ; if already exists, then skip saving again.
		Local $aValue = RetrieveImglocProperty("redline", "")
		If $aValue <> "" Then ; redline exists
			Local $aCoordsSplit = StringSplit($aValue, "|") ; split redlines in x,y, to get count of redline locations
			If $aCoordsSplit[0] > 50 Then ; check that we have enough red line points or keep trying for better data
				$redLines = $aValue
				_ObjPutValue($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS", $redLines) ; add/update value
				If @error Then _ObjErrMsg("_ObjPutValue $g_oBldgAttackInfo", @error)
				Local $redlinesCount = $aCoordsSplit[0] ; assign to variable to avoid constant check for array exists
				_ObjPutValue($g_oBldgAttackInfo, $eBldgRedLine & "_COUNT", $redlinesCount)
				If @error Then _ObjErrMsg("_ObjSetValue $g_oBldgAttackInfo", @error)
			Else
				Setdebuglog("> Not enough red line points to save in building dictionary?", $COLOR_WARNING)
			EndIf
		Else
			Setlog("> DLL Error getting Red Lines in GetLocationBuilding", $COLOR_ERROR)
		EndIf
	EndIf

	; Get rest of data return by DLL
	If $res[0] <> "" Then
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT) ; Spilt each returned key into array
		For $i = 0 To UBound($aKeys) - 1 ; Loop through the array to get all property values
			;SetDebuglog("$aKeys[" & $i & "]: " & $aKeys[$i], $COLOR_DEBUG)  ; key value debug

			; Object level retrieval
			$tempNewLevel = Int(RetrieveImglocProperty($aKeys[$i], "objectlevel"))

			; Munber of objects found retrieval
			$tmpNumFound = Int(RetrieveImglocProperty($aKeys[$i], "totalobjects"))

			; Location string retrieval
			$sTempCoord = RetrieveImglocProperty($aKeys[$i], "objectpoints") ; get location points

			; Check for duplicate locations from DLL when more than 1 location returned?
			If $i = 0 And StringLen($sTempCoord) > 7 Then
				$iCountUpdate = RemoveDupNearby($sTempCoord) ; remove duplicates BYREF, return location count
				If $tmpNumFound <> $iCountUpdate And $iCountUpdate <> "" Then $tmpNumFound = $iCountUpdate
			EndIf

			; check if this building is max level found
			If _ObjSearch($g_oBldgAttackInfo, $iBuildingType & "_MAXLVLFOUND") Then
				$tempExistingLevel = _ObjGetValue($g_oBldgAttackInfo, $iBuildingType & "_MAXLVLFOUND")
			Else
				$tempExistingLevel = 0
			EndIf
			If Int($tempNewLevel) > Int($tempExistingLevel) Then ; save if max level
				_ObjPutValue($g_oBldgAttackInfo, $iBuildingType & "_MAXLVLFOUND", $tempNewLevel)
				If @error Then _ObjErrMsg("_ObjPutValue " & $g_sBldgNames[$iBuildingType] & " _MAXLVLFOUND", @error) ; log errors
				_ObjPutValue($g_oBldgAttackInfo, $iBuildingType & "_NAMEFOUND", $aKeys[$i])
				If @error Then _ObjErrMsg("_ObjPutValue " & $g_sBldgNames[$iBuildingType] & " _NAMEFOUND", @error) ; log errors
			EndIf

			; save all relevant data on every image found using key number to differentiate data, ONLY WHEN more than one image is found!
			If UBound($aKeys) > 1 Then
				_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_LVLFOUND_K" & $i, $tempNewLevel)
				If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _LVLFOUND_K" & $i, @error) ; log errors
				_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_FILENAME_K" & $i, $aKeys[$i])
				If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _FILENAME_K" & $i, @error) ; log errors
				_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_COUNT_K" & $i, $tmpNumFound)
				If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _COUNT_K" & $i, @error) ; log errors
				_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_OBJECTPOINTS_K" & $i, $sTempCoord) ; save string of locations
				If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _OBJECTPOINTS_K" & $i, @error) ; Log errors
			EndIf

			; check if valid objectpoints returned
			If $sTempCoord <> "" Then
				If $sLocCoord = "" Then ; check if 1st set of points
					$sLocCoord = $sTempCoord
					$TotalBuildings = $tmpNumFound
				Else ; if not 1st set, then merge and check for duplicate locations in object points
					$iCountUpdate = AddPoints_RemoveDuplicate($sLocCoord, $sTempCoord, $maxReturnPoints) ; filter results to remove duplicate locations matching same building location, return no more than max allowed
					If $iCountUpdate <> "" Then $TotalBuildings = $iCountUpdate
				EndIf
			Else
				SetDebuglog("> no data in 'objectpoints' request?", $COLOR_WARNING)
			EndIf
		Next
	EndIf

	$aBldgCoord = decodeMultipleCoords($sLocCoord) ; change string into array with location x,y sub-arrays inside each row
	;$aBldgCoord = GetListPixel($sLocCoord, ",", "GetLocationBuilding" & $g_sBldgNames[$iBuildingType]) ; change string into array with debugattackcsv message instead of general log msg?

	If $g_iDebugBuildingPos = 1 Or  $g_iDebugSetlog = 1 Then ; temp debug message to display building location string returned, and convert "_LOCATION" array to string message for comparison
		SetLog("Bldg Loc Coord String: " & $sLocCoord, $COLOR_DEBUG)
		Local $sText
		Select
			Case UBound($aBldgCoord, 1) > 1 And IsArray($aBldgCoord[1]) ; if we have array of arrays, separate and list
				$sText = PixelArrayToString($aBldgCoord, ",")
			Case IsArray($aBldgCoord[0]) ; single row with array
				Local $aPixelb = $aBldgCoord[0]
				$sText = PixelToString($aPixelb, ";")
			Case IsArray($aBldgCoord[0]) = 0
				$sText = PixelToString($aBldgCoord, ":")
			Case Else
				$sText = "Monkey ate bad banana!"
		EndSelect
		Setlog($g_sBldgNames[$iBuildingType] & " $aBldgCoord Array Contents: " & $sText, $COLOR_DEBUG)
	EndIf

	If IsArray($aBldgCoord) Then ; string and array location(s) save to dictionary
		_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_OBJECTPOINTS", $sLocCoord) ; save string of locations
		If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _OBJECTPOINTS", @error) ; Log errors
		_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_LOCATION", $aBldgCoord) ; save array of locations
		If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _LOCATION", @error) ; Log errors
	EndIf

	If $TotalBuildings <> 0 Then ; building count save to dictionary
		_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_COUNT", $TotalBuildings)
		If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _COUNT", @error) ; Log errors
	EndIf
	SetLog("Total " & $g_sBldgNames[$iBuildingType] & " Buildings: " & $TotalBuildings)

	Local $iTime = __TimerDiff($hTimer) * 0.001 ; Image search time saved to dictionary in seconds
	_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_FINDTIME", $iTime)
	If @error Then _ObjErrMsg("_ObjAdd" & $g_sBldgNames[$iBuildingType] & " _FINDTIME", @error) ; Log errors

	If $g_iDebugBuildingPos = 1 Then SetLog("  - Location(s) found in: " & Round($iTime, 2) & " seconds ", $COLOR_DEBUG)

EndFunc   ;==>GetLocationBuilding

Func DebugImageGetLocation($vectorstr, $type, $iBuildingENUM = "")
	setlog("DebugImage .............................")
	setlog("input: " & $vectorstr)
	setlog("type: " & $type)

	Switch $type
		Case "DarkElixirStorageWithLevel", "ElixirExtractorWithLevel", "SnowElixirExtractorWithLevel", "MineExtractorWithLevel", "SnowMineExtractorWithLevel", "DarkElixirExtractorWithLevel"
			Local $vector = StringSplit($vectorstr, "~", 2) ; 8#387-162~8#460-314
			Setlog("-- " & $type)
			For $i = 0 To UBound($vector) - 1
				Setlog($type & " " & $i & " --> " & $vector[$i])
				Local $temp = StringSplit($vector[$i], "#", 2) ;TEMP ["2", "404-325"]
				If UBound($temp) = 2 Then
					Local $pixel = StringSplit($temp[1], "-", 2) ;PIXEL ["404","325"]
					If UBound($pixel) = 2 Then
						If isInsideDiamondRedArea($pixel) Then
							If $g_iDebugSetlog = 1 Then Setlog("coordinate inside village (" & $pixel[0] & "," & $pixel[1] & ")")
							_CaptureRegion($pixel[0] - 30, $pixel[1] - 30, $pixel[0] + 30, $pixel[1] + 30)
							DebugImageSave("DebugImageGetLocation_" & $type & "_", False)
						Else
							If $g_iDebugSetlog = 1 Then Setlog("coordinate out of village (" & $pixel[0] & "," & $pixel[1] & ")")
						EndIf
					EndIf
				EndIf
			Next
		Case "Mine", "SnowMine", "Elixir", "SnowElixir", "DarkElixir", "TownHall", "DarkElixirStorage", "GoldStorage", "ElixirStorage", "Inferno"
			Local $vector = StringSplit($vectorstr, "|", 2)
			Setlog("-- " & $type)
			For $i = 0 To UBound($vector) - 1
				Local $pixel = StringSplit($vector[$i], "-", 2) ;PIXEL ["404","325"]
				If UBound($pixel) = 2 Then
					If isInsideDiamondRedArea($pixel) Then
						If $g_iDebugSetlog = 1 Then Setlog("coordinate inside village (" & $pixel[0] & "," & $pixel[1] & ")")
						_CaptureRegion($pixel[0] - 30, $pixel[1] - 30, $pixel[0] + 30, $pixel[1] + 30)
						DebugImageSave("DebugImageGetLocation_" & $type & "_", False)
					Else
						If $g_iDebugSetlog = 1 Then Setlog("coordinate out of village (" & $pixel[0] & "," & $pixel[1] & ")")
					EndIf
				EndIf
			Next
		Case "GetBuildings"
			If $iBuildingENUM = "" Then
				Setlog("DebugImageGetLocation Parameter error!", $COLOR_ERROR)
				Return
			EndIf
			Local $vector = StringSplit($vectorstr, "|", 2)
			Setlog("-- " & $type)
			For $i = 0 To UBound($vector) - 1
				Local $pixel = StringSplit($vector[$i], ",", 2) ;PIXEL ["404","325"]
				If UBound($pixel) = 2 Then
					If isInsideDiamondRedArea($pixel) Then
						If $g_iDebugSetlog = 1 Then Setlog("coordinate inside village (" & $pixel[0] & "," & $pixel[1] & ")")
						_CaptureRegion($pixel[0] - 30, $pixel[1] - 30, $pixel[0] + 30, $pixel[1] + 30)
						DebugImageSave("DebugImageGetLocation_" & StringStripWS($g_sBldgNames[$iBuildingENUM], $STR_STRIPALL) & "_", False)
					Else
						If $g_iDebugSetlog = 1 Then Setlog("coordinate out of village (" & $pixel[0] & "," & $pixel[1] & ")")
					EndIf
				EndIf
			Next
		Case Else
			setlog("!!!!!!")
	EndSwitch


	setlog("-------------------------------------------")
;~ 						Local $hPen = _GDIPlus_PenCreate(0xFFFFD800, 1)
;~ 						Local $multiplier = 2
;~ 						Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($g_hBitmap)
;~ 						Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
;~ 						_GDIPlus_GraphicsDrawLine($hGraphic, 0, 30, 60, 30, $hPen)
;~ 						_GDIPlus_GraphicsDrawLine($hGraphic, 30, 0, 30, 60, $hPen)
;~ 						_GDIPlus_PenDispose($hPen)
;~ 						_GDIPlus_BrushDispose($hBrush)
;~ 						_GDIPlus_GraphicsDispose($hGraphic)
;~ 						DebugImageSave("debugresourcesoffset_" & $type & "_" & $level & "_" & $filename & "#"  ,  False)
;~ 					EndIf
EndFunc   ;==>DebugImageGetLocation

Func ConvertImgloc2MBR($Array, $Maxpositions, $level = False)

	Local $StringConverted = Null
	Local $Max = 0

	If IsArray($Array) Then
		For $i = 1 To UBound($Array) - 1 ; from 1 cos the 0 is empty
			Local $Coord = $Array[$i][5]
			If IsArray($Coord) Then ; same level with several positions
				For $t = 0 To UBound($Coord) - 1
					If isInsideDiamondXY($Coord[$t][0], $Coord[$t][1]) Then ; just in case
						If $level = True Then $StringConverted &= $Array[$i][2] & "#" & $Coord[$t][0] & "-" & $Coord[$t][1] & "~"
						If $level = False Then $StringConverted &= $Coord[$t][0] & "-" & $Coord[$t][1] & "|"
						$Max += 1
						If $Max = $Maxpositions Then ExitLoop (2)
					EndIf
				Next
			EndIf
		Next
	Else
		Setlog("Error on Imgloc detection Mines|Collectors|Drills", $COLOR_ERROR)
	EndIf

	$StringConverted = StringTrimRight($StringConverted, 1) ; remove the last " |" or "~"
	If $g_iDebugSetlog Then Setlog("$StringConverted: " & $StringConverted)

	Return $StringConverted ; xxx-yyy|xxx-yyy|n.... OR Lv#xxx-yyy~Lv#xxx-yyy

EndFunc   ;==>ConvertImgloc2MBR


