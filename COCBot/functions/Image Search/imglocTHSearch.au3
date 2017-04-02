; #FUNCTION# ====================================================================================================================
; Name ..........: imglocTHSearch
; Description ...: Searches for the TH in base, and returns; X&Y location, Bldg Level
; Syntax ........: imglocTHSearch([$bReTest = False])
; Parameters ....: $bReTest - [optional] a boolean value. Default is False.
; Return values .: None , sets several global variables
; Author ........: Trlopes (10-2016)
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $IMGLOCTHLOCATION
Global $IMGLOCTHNEAR
Global $IMGLOCTHFAR
Global $IMGLOCTHRDISTANCE

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
	If $g_iDebugSetlog = 1 Then SetLog("imgloc TH search Start", $COLOR_DEBUG)
	Local $numRetry = 2 ; try to find TH twice

	For $retry = 0 To $numRetry
		If $retry > 0 Then $xdirectory = $xdirectoryb

		If $g_iDetectedImageType = 1 Then ;Snow theme on
			$xdirectory = "snow-" & $xdirectory
		EndIf

		If $retry > 0 And $g_sImglocRedline <> "" Then ; on retry IMGLOCREDLNE is already populated
			$redLines = $g_sImglocRedline
		EndIf

		Local $hTimer = __TimerInit()
		Local $result = findMultiple($xdirectory, $sCocDiamond, $redLines, $minLevel, $maxLevel, $maxReturnPoints, $returnProps, $bForceCapture)

		If IsArray($result) Then
			;we got results from multisearch ; lets set $redline in case we need to perform another search
			$redLines = $g_sImglocRedline ; that was set by findMultiple if redline argument was ""
			If UBound($result) = 1 Then
				If $g_iDebugSetlog = 1 Then SetLog("imgloc Found TH : ", $COLOR_INFO)
				Local $propsValues = $result[0]
				For $pv = 0 To UBound($propsValues) - 1
					If $g_iDebugSetlog = 1 Then SetLog("imgloc Found : " & $propsNames[$pv] & " - " & $propsValues[$pv], $COLOR_INFO)
					Switch $propsNames[$pv]
						Case "objectname"
							;nothing to do
							Local $PathFile = $propsValues[$pv]
						Case "objectlevel"
							If $myVillage = False Then
								$g_iImglocTHLevel = Number($propsValues[$pv])
								$g_aiTownHallDetails[2] = Number($propsValues[$pv])
								$g_iSearchTH = Number($propsValues[$pv])
							Else
								$g_iTownHallLevel = Number($propsValues[$pv]) ; I think $g_iTownHallLevel needs to be decreased
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
								$g_aiTownHallDetails[0] = Number($IMGLOCTHLOCATION[0])
								$g_aiTownHallDetails[1] = Number($IMGLOCTHLOCATION[1])
								$g_iTHx = Number($IMGLOCTHLOCATION[0]) ; backwards compatibility
								$g_iTHy = Number($IMGLOCTHLOCATION[1]) ; backwards compatibility

								If $g_iDebugImageSave = 1 And $retry > 0 Then
									_CaptureRegion()

									; Store a copy of the image handle
									Local $editedImage = $g_hBitmap
									Local $subDirectory = @ScriptDir & "\Thdetection\"
									DirCreate($subDirectory)

									; Create the timestamp and filename
									Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
									Local $Time = @HOUR & "." & @MIN & "." & @SEC
									Local $fileName = "Thdetection_" & $retry & "_" & $Date & "_" & $Time & ".png"

									; Needed for editing the picture
									Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
									Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED

									addInfoToDebugImage($hGraphic, $hPen, String($PathFile & "_" & $g_iImglocTHLevel), $g_iTHx, $g_iTHy)

									; Save the image and release any memory
									_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & $fileName)
									_GDIPlus_PenDispose($hPen)
									_GDIPlus_GraphicsDispose($hGraphic)
								EndIf
							Else
								$g_aiTownHallPos = decodeSingleCoord($propsValues[$pv])
								ConvertFromVillagePos($g_aiTownHallPos[0], $g_aiTownHallPos[1])
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
						$g_aiTownHallDetails[3] = 1 ; found 1 only
					EndIf
				Next
				If $g_iDebugSetlog = 1 Then SetLog("imgloc THSearch Calculated  (in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds) :")
			Else
				If $g_iDebugSetlog = 1 Then SetLog("imgloc Found Multiple TH : ", $COLOR_INFO)
				If $g_iDebugImageSave = 1 Then DebugImageSave("imglocTHSearch_MultiMatched_", True)
				;could be a multi match or another tile for same object. As TH only have 1 tile, $g_iTownHallLevel will never happen
				If $g_iDebugSetlog = 1 Then SetLog("imgloc THSearch Calculated  (in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds) :")
			EndIf

		Else
			;thnotfound
			If $g_iDebugSetlog = 1 And $retry > 0 Then SetLog("imgloc Could not find TH", $COLOR_WARNING)
			If $g_iDebugImageSave = 1 And $retry > 0 Then DebugImageSave("imglocTHSearch_NoTHFound_", True)
			If $g_iDebugSetlog = 1 And $retry > 0 Then SetLog("imgloc THSearch Calculated  (in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds) :")
		EndIf

		If $g_iImglocTHLevel > 0 Then
			ExitLoop ; TH was found
		Else
			If $g_iDebugImageSave = 1 And $retry > 0 Then DebugImageSave("imglocTHSearch_NoTHFound_", True)
			If $g_iDebugSetlog = 1 Then SetLog("imgloc THSearch Notfound, Retry:  " & $retry)
		EndIf
		$retry = $retry + 1
	Next ; retry
EndFunc   ;==>imglocTHSearch

Func ResetTHsearch()
	;something not good happened
	;reset redlines and other globals
	$g_sImglocRedline = "" ; Redline data obtained from FindMultiple
	$g_iImglocTHLevel = 0 ; Duhhh!!!
	$IMGLOCTHLOCATION = StringSplit(",", ",", $STR_NOCOUNT) ; x,y array
	$IMGLOCTHNEAR = "" ; 5 points 5px from redline Near to TH
	$IMGLOCTHFAR = "" ; 5 points 25px from redline Near to TH
	$IMGLOCTHRDISTANCE = "" ; Reline distace to TH
	;compatibility
	$g_aiTownHallDetails[0] = -1 ; [LocX, LocY, BldgLvl, Quantity]
	$g_aiTownHallDetails[1] = -1 ; [LocX, LocY, BldgLvl, Quantity]
	$g_aiTownHallDetails[2] = -1 ; [LocX, LocY, BldgLvl, Quantity]
	$g_aiTownHallDetails[3] = -1 ; [LocX, LocY, BldgLvl, Quantity]
	$g_iTHx = 0 ; backwards compatibility
	$g_iTHy = 0 ; backwards compatibility
	$g_iSearchTH = "-" ; means not found
EndFunc   ;==>ResetTHsearch

;backwards compatibility
Func imgloccheckTownHallADV2($limit = 0, $tolerancefix = 0, $captureRegion = True)
	imglocTHSearch(True, False, $captureRegion) ; try 2 times to get TH

	If $g_iImglocTHLevel = 0 Then
		Return "-"
	Else
		Return $g_iImglocTHLevel
	EndIf

EndFunc   ;==>imgloccheckTownHallADV2
