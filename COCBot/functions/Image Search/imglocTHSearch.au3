; #FUNCTION# ====================================================================================================================
; Name ..........: imglocTHSearch
; Description ...: Searches for the TH in base, and returns; X&Y location, Bldg Level
; Syntax ........: imglocTHSearch([$bReTest = False])
; Parameters ....: $bReTest - [optional] a boolean value. Default is False.
; Return values .: None , sets several global variables
; Author ........: trlopes (Oct 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $aTownHall[4] = [-1, -1, -1, -1] ; [LocX, LocY, BldgLvl, Quantity]

Func imglocTHSearch($bReTest = False, $myVillage = False, $bForceCapture = True)
	;set THSearch Values for multisearch
	;Local $xdirectory = @ScriptDir & "\imgxml\ImgLocTH"
	Local $xdirectory = "imglocth-bundle"
	Local $xdirectoryb = "imglocth2-bundle"
	Local $sCocDiamond = "ECD"
	Local $redLines = ""
	Local $minLevel = 6 ; We only support TH6+
	Local $maxLevel = 100
	Local $maxReturnPoints = 1
	Local $returnProps = "objectname,objectlevel,objectpoints,nearpoints,farpoints,redlinedistance"

	If $myVillage = False Then ; these are only for OPONENT village
		ResetTHsearch() ;see below
	Else
		$redLines = "ECD" ;needed for searching your own village
	EndIf
    


	;aux data
	Local $propsNames = StringSplit($returnProps, ",", $STR_NOCOUNT)
	If $debugsetlog = 1 Then SetLog("imgloc TH search Start", $COLOR_DEBUG)
	Local $numRetry = 2 ; try to find TH twice

	For $retry = 0 To $numRetry
		if $retry > 0 then  $xdirectory = $xdirectoryb
		
		IF $iDetectedImageType = 1 Then ;Snow theme on
			$xdirectory = "snow-" & $xdirectory  
		EndIF
		
		if $retry > 0 and $IMGLOCREDLINE <> "" then ; on retry IMGLOCREDLNE is already populated
			$redLines = $IMGLOCREDLINE
		endif
		
		Local $hTimer = TimerInit()
		Local $result = findMultiple($xdirectory, $sCocDiamond, $redLines, $minLevel, $maxLevel, $maxReturnPoints, $returnProps, $bForceCapture)

		If IsArray($result) Then
			;we got results from multisearch ; lets set $redline in case we need to perform another search
			$redLines = $IMGLOCREDLINE ; that was set by findMultiple if redline argument was ""
			If UBound($result) = 1 Then
				If $debugsetlog = 1 Then SetLog("imgloc Found TH : ", $COLOR_INFO)
				Local $propsValues = $result[0]
				For $pv = 0 To UBound($propsValues) - 1
					If $debugsetlog = 1 Then SetLog("imgloc Found : " & $propsNames[$pv] & " - " & $propsValues[$pv], $COLOR_INFO)
					Switch $propsNames[$pv]
						Case "objectname"
							;nothing to do
							Local $PathFile = $propsValues[$pv]
						Case "objectlevel"
							If $myVillage = False Then
								$IMGLOCTHLEVEL = Number($propsValues[$pv])
								$aTownHall[2] = Number($propsValues[$pv])
								$searchTH = Number($propsValues[$pv])
							Else
								$iTownHallLevel = Number($propsValues[$pv]) ; I think this needs to be decreased
							EndIf
						Case "objectpoints"
							If $propsValues[$pv] = "0" Then
								;there was an error inside imgloc and location is empty or error
								DebugImageSave("imglocTHSearch_NoTHFound_", True)
								ResetTHsearch()
								Return
							EndIf
							If $myVillage = False Then
								$IMGLOCTHLOCATION = decodeSingleCoord($propsValues[$pv]) ;array [x][y]
								$aTownHall[0] = Number($IMGLOCTHLOCATION[0])
								$aTownHall[1] = Number($IMGLOCTHLOCATION[1])
								$THx = Number($IMGLOCTHLOCATION[0]) ; backwards compatibility
								$THy = Number($IMGLOCTHLOCATION[1]) ; backwards compatibility
								$THLocation = 1 ; backwards compatibility

								If $debugImageSave = 1  and $retry > 0 then
									_CaptureRegion()

									; Store a copy of the image handle
									Local $editedImage = $hBitmap
									Local $subDirectory = @ScriptDir & "\Thdetection\"
									DirCreate($subDirectory)

									; Create the timestamp and filename
									Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
									Local $Time = @HOUR & "." & @MIN & "." & @SEC
									Local $fileName = "Thdetection_" & $retry & "_" & $Date & "_" & $Time & ".png"

									; Needed for editing the picture
									Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
									Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED

									addInfoToDebugImage($hGraphic, $hPen, String($PathFile & "_" & $IMGLOCTHLEVEL), $THx, $THy)

									; Save the image and release any memory
									_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & $fileName)
									_GDIPlus_PenDispose($hPen)
									_GDIPlus_GraphicsDispose($hGraphic)
								EndIf
							Else
								$TownHallPos = decodeSingleCoord($propsValues[$pv])
								ConvertFromVillagePos($TownHallPos[0], $TownHallPos[1])
							EndIf
						Case "nearpoints"
							If $myVillage = False Then
								$IMGLOCTHNEAR = $propsValues[$pv]
							EndIf
						Case "farpoints"
							If $myVillage = False Then
								$IMGLOCTHFAR = $propsValues[$pv]
							EndIf
						Case "redlinedistance"
							If $myVillage = False Then
								$IMGLOCTHRDISTANCE = $propsValues[$pv]
							EndIf
					EndSwitch
					If $myVillage = False Then
						$aTownHall[3] = 1 ; found 1 only
					EndIf
				Next
				If $debugsetlog = 1 Then SetLog("imgloc THSearch Calculated  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
			Else
				If $debugsetlog = 1 Then SetLog("imgloc Found Multiple TH : ", $COLOR_INFO)
				If $debugImageSave = 1  Then DebugImageSave("imglocTHSearch_MultiMatched_", True)
				;could be a multi match or another tile for same object. As TH only have 1 tile, this will never happen
				If $debugsetlog = 1 Then SetLog("imgloc THSearch Calculated  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
			EndIf

		Else
			;thnotfound
			If $debugsetlog = 1  and $retry > 0 Then SetLog("imgloc Could not find TH", $COLOR_WARNING)
			If $debugImageSave = 1 and $retry > 0 Then DebugImageSave("imglocTHSearch_NoTHFound_", True)
			If $debugsetlog = 1 and $retry > 0 Then SetLog("imgloc THSearch Calculated  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
		EndIf
		
		If $IMGLOCTHLEVEL > 0 Then
			ExitLoop ; TH was found
		Else
			If $debugImageSave = 1 and $retry > 0 Then DebugImageSave("imglocTHSearch_NoTHFound_", True)
			If $debugsetlog = 1 Then SetLog("imgloc THSearch Notfound, Retry:  " & $retry)
		EndIf
		$retry = $retry + 1
	Next ; retry
EndFunc   ;==>imglocTHSearch

Func ResetTHsearch()
	;something not good happened
	;reset redlines and other globals
	$IMGLOCREDLINE = "" ; Redline data obtained from FindMultiple
	$IMGLOCTHLEVEL = 0 ; Duhhh!!!
	$IMGLOCTHLOCATION = StringSplit(",", ",", $STR_NOCOUNT) ; x,y array
	$IMGLOCTHNEAR = "" ; 5 points 5px from redline Near to TH
	$IMGLOCTHFAR = "" ; 5 points 25px from redline Near to TH
	$IMGLOCTHRDISTANCE = "" ; Reline distace to TH
	;compatibility
	$aTownHall[0] = -1 ; [LocX, LocY, BldgLvl, Quantity]
	$aTownHall[1] = -1 ; [LocX, LocY, BldgLvl, Quantity]
	$aTownHall[2] = -1 ; [LocX, LocY, BldgLvl, Quantity]
	$aTownHall[3] = -1 ; [LocX, LocY, BldgLvl, Quantity]
	$THx = 0 ; backwards compatibility
	$THy = 0 ; backwards compatibility
	$searchTH = "-" ; means not found
	$THLocation = 0 ; means not found
EndFunc   ;==>ResetTHsearch

;backwards compatibility
Func imgloccheckTownHallADV2($limit = 0, $tolerancefix = 0, $captureRegion = True)
	imglocTHSearch(True, False, $captureRegion) ; try 2 times to get TH

	If $IMGLOCTHLEVEL = 0 Then
		Return "-"
	Else
		Return $IMGLOCTHLEVEL
	EndIf

EndFunc   ;==>imgloccheckTownHallADV2
