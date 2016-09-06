; #FUNCTION# ====================================================================================================================
; Name ..........: checkTownhallAdv2
; Description ...: This file Includes the Variables and functions to detection the level of a TH
; Syntax ........: checkTownhallAdv2()
; Parameters ....: None
; Return values .: $THx, $THy
; Author ........: Sardo
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func LoadTHImage()
	; Load variables array $THimages0 - $THImages4
	; $THImagesX[0]= numbers of n files
	; $THImagesX[1..n] = name of file 1..n
	Local $x
	Local $path = @ScriptDir & "\images\TH\"
	Local $useImages
	If $iDetectedImageType = 0 Then ;all files, exlude snow
		$useImages = "*T*X*Y*.bmp|*SNOW*.bmp"
	ElseIf $iDetectedImageType = 1 Then ;all files, exclude normal
		$useImages = "*T*X*Y*.bmp|*NORM*.bmp"
	Else;all files
		$useImages = "*T*X*Y*.bmp"
	EndIf
	For $t = 0 To 5
		;assign THImages0... THImages4  an array empty with THimagesx[0]=0
		Assign("THImages" & $t, StringSplit("", ""))
		;put in a temp array the list of files matching condition "*T*.bmp"
		$x = _FileListToArrayRec($path & $THText[$t] & "\", $useImages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		;_ArrayDisplay($x)
		;assign value at THimages0... THImages4 if $x it's not empty
		If UBound($x) Then Assign("THImages" & $t, $x)

		;code to debug in console if need
		For $i = 0 To UBound(Eval("THImages" & $t)) - 1
			ConsoleWrite("THImages_" & $t + 6 & "[" & $i & "]:" & Execute("$THImages" & $t & "[" & $i & "]") & @CRLF)
		Next

		;make stats array and put values = 0
		For $i = 0 To UBound($x) - 1
			$x[$i] = "0"
		Next

		If UBound($x) Then Assign("THImagesStat" & $t, $x)

		;read from ini file stats values
		For $i = 1 To UBound(Eval("THImagesStat" & $t)) - 1
			Local $tempvect = Eval("THImagesStat" & $t)
			$tempvect[$i] = IniRead($statChkTownHall, $THText[$t], Execute("$THImages" & $t & "[" & $i & "]"), "0")
			Assign("THImagesStat" & $t, $tempvect)
			;SetLog ( "-$THImagesStat"& $t &"[" & $i & "] = " & Execute("$THImages"& $t &"[" & $i & "]") & " - " &  Execute("$THImagesStat"& $t &"[" & $i & "]") )
		Next

	Next
EndFunc   ;==>LoadTHImage

Func checkTownHallADV2($limit = 0, $tolerancefix = 0, $captureRegion = True)
	;variable limit: limit number of searches, limit = 0 disable limit search
	;variable tolearnce: set a fixed tolearnce, tolerance = 0 disable fixed tolerance
	Local $hTimer = TimerInit()
	Local $count = 0


	; calculate max number of files into folders
	Local $max = 0, $tolerance
	For $i = 0 To UBound($THText) - 1
		If Int(Execute("$THImages" & $i & "[0]")) > $max Then $max = Int(Execute("$THImages" & $i & "[0]"))
	Next
	If $limit > 0 And $max > 0 And $limit <= $max Then $max = $limit

;~ 	ConsoleWrite ("max value =  " & $max &  @CRLF)
	Local $found = False
	For $i = 1 To $max
		If $captureRegion Then _CaptureRegion()
		;For $t = 0 To UBound($THText) - 1		  ; check from th6 to th11
		For $t = UBound($THText) - 1 To 0 Step -1 ; check from th11 to th6
			If Int(Execute("$THImages" & $t & "[0]")) >= $i Then
				$count += 1
				If $tolerancefix > 0 Then
					$tolerance = $tolerancefix
				Else
					$tolerance = Number(StringMid(Execute("$THImages" & $t & "[" & $i & "]"), StringInStr(Execute("$THImages" & $t & "[" & $i & "]"), "T") + 1, StringInStr(Execute("$THImages" & $t & "[" & $i & "]"), ".bmp") - StringInStr(Execute("$THImages" & $t & "[" & $i & "]"), "T") - 1))
				EndIf
				$THLocation = _ImageSearch(@ScriptDir & "\images\TH\" & $THText[$t] & "\" & Execute("$THImages" & $t & "[" & $i & "]"), 1, $THx, $THy, $tolerance) ; Getting TH Location
				$THx += Int(StringMid(Execute("$THImages" & $t & "[" & $i & "]"), StringInStr(Execute("$THImages" & $t & "[" & $i & "]"), "X") + 1, StringInStr(Execute("$THImages" & $t & "[" & $i & "]"), "Y") - StringInStr(Execute("$THImages" & $t & "[" & $i & "]"), "X") - 1))
				$THy += Int(StringMid(Execute("$THImages" & $t & "[" & $i & "]"), StringInStr(Execute("$THImages" & $t & "[" & $i & "]"), "Y") + 1, StringInStr(Execute("$THImages" & $t & "[" & $i & "]"), ".BMP") - StringInStr(Execute("$THImages" & $t & "[" & $i & "]"), "Y") - 1))
				If $THLocation = 1 Then
					If $debugBuildingPos = 1 Then
						Setlog("#*# checkTownhallADV2: ", $COLOR_TEAL)
						Setlog("  - Position (" & $THx & "," & $THy & ")", $COLOR_TEAL)
						Setlog("  - TownHall detected level " & $THText[$t], $COLOR_TEAL)
						Setlog("  - Image Match " & Execute("$THImages" & $t & "[" & $i & "]"), $COLOR_TEAL)
						Setlog("  - IsInsidediamond: " & isInsideDiamondXY($THx, $THy), $COLOR_TEAL)
						SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
						SetLog("  - Images checked: " & $count, $COLOR_TEAL)
					EndIf
					If isInsideDiamondXY($THx, $THy) = True Then
						;add in stats-----
						Local $tempvect = Eval("THImagesStat" & $t)
						$tempvect[$i] += 1
						Assign("THImagesStat" & $t, $tempvect)
						;------------------
						$found = True
						$ImageInfo = String("TH" & $THText[$t] & "-" & $i)
						SaveStatChkTownHall()
						If $debugImageSave = 1 Then CaptureTHwithInfo($THx, $THy, $ImageInfo)
						Return $THText[$t]
					Else
						ContinueLoop
					EndIf
				EndIf
			EndIf
			If $found Then ExitLoop ;if found = true exit from second for...
		Next
	Next


	ConsoleWrite("THLOCATION = <" & $THLocation & ">")
	If $THLocation = 0 Then
		If $debugBuildingPos = 1 Then
			Setlog("#*# checkTownhallADV2: NONE ", $COLOR_TEAL)
			SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
			SetLog("  - Images checked: " & $count, $COLOR_TEAL)
		EndIf
		If $debugBuildingPos = 1 And ($limit <> 0 Or $tolerancefix <> 0) Then Setlog("#*# checkTownhallADV2: limit= " & $limit & ", tolerancefix=" & $tolerancefix, $COLOR_TEAL)
		If $debugImageSave = 1 Then DebugImageSave("checkTownhallADV2_NoTHFound_", False)
	EndIf

	Return "-"

EndFunc   ;==>checkTownHallADV2

Func SaveStatChkTownHall()
	Local $hFile = FileOpen($statChkTownHall, $FO_UTF16_LE + $FO_OVERWRITE)
	If FileExists($statChkTownHall) Then
		For $t = 0 To 5
			For $i = 1 To UBound(Eval("THImages" & $t)) - 1
				IniWrite($statChkTownHall, $THText[$t], Execute("$THImages" & $t & "[" & $i & "]"), Execute("$THImagesStat" & $t & "[" & $i & "]"))
			Next
		Next
	EndIf
	FileClose($hFile)
EndFunc   ;==>SaveStatChkTownHall

Func CaptureTHwithInfo($THx, $THy, $ImageInfo)
	Local $EditedImage
	_CaptureRegion()

	$EditedImage = $hBitmap

	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($EditedImage)
	Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ;create a pencil Color FF0000/RED

	_GDIPlus_GraphicsDrawRect($hGraphic, $THx - 5, $THy - 5, 10, 10, $hPen)
	_GDIPlus_GraphicsDrawString($hGraphic, $ImageInfo, 401, 63, "Arial", 15)

	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $filename = String("THDetected_" & $Date & "_" & $Time & "_" & $ImageInfo & ".png")

	If $debugBuildingPos = 1 And $debugsetlog = 1 Then Setlog(" _GDIPlus_ImageSaveToFile", $COLOR_PURPLE)
	Local $savefolder = $dirTempDebug & "THDetected_" & "\"
	DirCreate($savefolder)
	_GDIPlus_ImageSaveToFile($EditedImage, $savefolder & $filename)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_GraphicsDispose($hGraphic)

EndFunc   ;==>CaptureTHwithInfo

