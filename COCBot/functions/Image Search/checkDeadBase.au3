; #FUNCTION# ====================================================================================================================
; Name ..........: checkDeadBase
; Description ...: This file Includes the Variables and functions to detection of a DeadBase. Uses imagesearch to see whether a collector
;                  is full or semi-full to indicate that it is a dead base
; Syntax ........: checkDeadBase() , ZombieSearch()
; Parameters ....: None
; Return values .: True if it is, returns false if it is not a dead base
; Author ........:  AtoZ , DinoBot (01-2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func LoadElixirImage()

	Local $x
	Local $path = @ScriptDir & "\images\ELIXIR\"
	Local $useimages
	If $iDetectedImageType = 0 Then;all, exclude snow
		$useimages = "*T*.bmp|*SNOW*.bmp"
	ElseIf $iDetectedImageType = 1 Then;all,exclude normal
		$useimages = "*T*.bmp|*NORM*.bmp"
	Else;all
		$useimages = "*T*.bmp"
	EndIf
	For $t = 0 To $maxElixirLevel
		If Eval("chkLvl" & $t + 6 & "Enabled") <> "1" Or Eval("cmbLvl" & $t + 6 & "Fill") > 2 Then ;If Configure Collectors checkbox not checked OR value of combobox is larger then 2(80%full)
			Assign("ElixirImages" & $t, StringSplit("", ""))
			ContinueLoop
		EndIf
		;assign ElixirImages0... ElixirImages6  an array empty with Elixirimagesx[0]=0
		Assign("ElixirImages" & $t, StringSplit("", ""))
		;put in a temp array the list of files matching condition "*T*.bmp"
		$x = _FileListToArrayRec(@ScriptDir & "\images\ELIXIR\" & $t + 6 & "\", $useimages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		;SetLog("Elixir 100% images lvl "&$t+6&": "&_ArrayToString($x))
		;_ArrayDisplay($x)
		;assign value at ElixirImages0... ElixirImages6 if $x it's not empty
		If UBound($x) Then Assign("ElixirImages" & $t, $x)
		;code to debug in console if need
		For $i = 0 To UBound(Eval("ElixirImages" & $t)) - 1
			ConsoleWrite("$ElixirImages" & $t & "[" & $i & "]:" & Execute("$ElixirImages" & $t & "[" & $i & "]") & @CRLF)
		Next

		;make stats array and put values = 0
;~ 		For $i = 0 To UBound($x) - 1
;~ 			$x[$i] = "0"
;~ 		Next
		If UBound($x) Then Assign("ElixirImagesStat" & $t, $x)

		;read from ini file stats values
		For $i = 1 To UBound(Eval("ElixirImagesStat" & $t)) - 1
			Local $tempvect = Eval("ElixirImagesStat" & $t)
			$tempvect[$i] = IniRead($statChkDeadBase, $t, Execute("$ElixirImages" & $t & "[" & $i & "]"), "0")
			Assign("ElixirImagesStat" & $t, $tempvect)
		Next
	Next
EndFunc   ;==>LoadElixirImage


Func LoadElixirImage75Percent()

	Local $x
	Local $path = @ScriptDir & "\images\ELIXIR75PERCENT\"
	Local $useimages
	If $iDetectedImageType = 0 Then;exclude snow
		$useimages = "*T*.bmp|*SNOW*.bmp"
	ElseIf $iDetectedImageType = 1 Then;exclude normal
		$useimages = "*T*.bmp|*NORM*.bmp"
	Else;include all
		$useimages = "*T*.bmp"
	EndIf
	For $t = 0 To $maxElixirLevel
		If Eval("chkLvl" & $t + 6 & "Enabled") <> "1" Or Eval("cmbLvl" & $t + 6 & "Fill") > 1 Then ;If Configure Collectors checkbox not checked OR value of combobox is larger then 1(60%full)
			Assign("ElixirImages" & $t & "_75percent", StringSplit("", ""))
			ContinueLoop
		EndIf
		;assign ElixirImages0... ElixirImages6  an array empty with Elixirimagesx[0]=0
		Assign("ElixirImages" & $t & "_75percent", StringSplit("", ""))
		;put in a temp array the list of files matching condition "*T*.bmp"
		$x = _FileListToArrayRec(@ScriptDir & "\images\ELIXIR75PERCENT\" & $t + 6 & "\", $useimages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		;SetLog("Elixir 75% images lvl "&$t+6&": "&_ArrayToString($x))
		;assign value at ElixirImages0... ElixirImages6 if $x it's not empty
		If UBound($x) Then Assign("ElixirImages" & $t & "_75percent", $x)
		;code to debug in console if need
		For $i = 0 To UBound(Eval("ElixirImages" & $t & "_75percent")) - 1
			ConsoleWrite("$ElixirImages" & $t & "_75percent" & "[" & $i & "]:" & Execute("$ElixirImages" & $t & "_75percent" & "[" & $i & "]") & @CRLF)
		Next

		;make stats array and put values = 0
;~ 		For $i = 0 To UBound($x) - 1
;~ 			$x[$i] = "0"
;~ 		Next
		If UBound($x) Then Assign("ElixirImagesStat" & $t & "_75percent", $x)

		;read from ini file stats values
		For $i = 1 To UBound(Eval("ElixirImagesStat" & $t & "_75percent")) - 1
			Local $tempvect = Eval("ElixirImagesStat" & $t & "_75percent")
			$tempvect[$i] = IniRead($statChkDeadBase75percent, $t, Execute("$ElixirImages" & $t & "_75percent" & "[" & $i & "]"), "0")
			Assign("ElixirImagesStat" & $t & "_75percent", $tempvect)
		Next
	Next
EndFunc   ;==>LoadElixirImage75Percent


Func LoadElixirImage50Percent()
	Local $x
	Local $path = @ScriptDir & "\images\ELIXIR50PERCENT\"
	Local $useimages
	If $iDetectedImageType = 0 Then;exclude snow
		$useimages = "*T*.bmp|*SNOW*.bmp"
	ElseIf $iDetectedImageType = 1 Then;exclude normal
		$useimages = "*T*.bmp|*NORM*.bmp"
	Else;include all
		$useimages = "*T*.bmp"
	EndIf
	For $t = 0 To $maxElixirLevel
		If Eval("chkLvl" & $t + 6 & "Enabled") <> "1" Or Eval("cmbLvl" & $t + 6 & "Fill") > 0 Then ;If Configure Collectors checkbox not checked OR value of combobox is larger then 0(40%full)
			Assign("ElixirImages" & $t & "_50percent", StringSplit("", "")) ;then skip this folder
			ContinueLoop
		EndIf
		;assign ElixirImages0... ElixirImages6  an array empty with Elixirimagesx[0]=0
		Assign("ElixirImages" & $t & "_50percent", StringSplit("", ""))
		;put in a temp array the list of files matching condition "*T*.bmp"
		$x = _FileListToArrayRec(@ScriptDir & "\images\ELIXIR50PERCENT\" & $t + 6 & "\", $useimages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		;SetLog("Elixir 50% images lvl "&$t+6&": "&_ArrayToString($x))
		;assign value at ElixirImages0... ElixirImages6 if $x it's not empty
		If UBound($x) Then Assign("ElixirImages" & $t & "_50percent", $x)
		;code to debug in console if need
		For $i = 0 To UBound(Eval("ElixirImages" & $t & "_50percent")) - 1
			ConsoleWrite("$ElixirImages" & $t & "_50percent" & "[" & $i & "]:" & Execute("$ElixirImages" & $t & "_50percent" & "[" & $i & "]") & @CRLF)
		Next

		;make stats array and put values = 0
;~ 		For $i = 0 To UBound($x) - 1
;~ 			$x[$i] = "0"
;~ 		Next
		If UBound($x) Then Assign("ElixirImagesStat" & $t & "_50percent", $x)

		;read from ini file stats values
		For $i = 1 To UBound(Eval("ElixirImagesStat" & $t & "_50percent")) - 1
			Local $tempvect = Eval("ElixirImagesStat" & $t & "_50percent")
			$tempvect[$i] = IniRead($statChkDeadBase50percent, $t, Execute("$ElixirImages" & $t & "_50percent" & "[" & $i & "]"), "0")
			Assign("ElixirImagesStat" & $t & "_50percent", $tempvect)
		Next
	Next
EndFunc   ;==>LoadElixirImage50Percent

Func checkDeadBase()

	Return ZombieSearch2() ; just so it compiles

EndFunc   ;==>checkDeadBase

;checkDeadBase Variables:-------------===========================
Global $AdjustTolerance = 0
Global $Tolerance[5][11] = [[55, 55, 55, 80, 70, 70, 75, 80, 0, 75, 65], [55, 55, 55, 80, 80, 70, 75, 80, 0, 75, 65], [55, 55, 55, 80, 80, 70, 75, 80, 0, 75, 65], [55, 55, 55, 80, 80, 60, 75, 75, 0, 75, 60], [55, 55, 55, 80, 80, 70, 75, 80, 0, 75, 65]]
Global $ZC = 0, $ZombieCount = 0;, $E
Global $ZombieFileSets = 3 ;Variant Image to use organized as per Folder
Global $ZSExclude = 0 ;Set to 0 to include Elixir Lvl 6, 1 to include lvl 7 and so on..
Global $Lx[4] = [0, 400, 0, 400]
Global $Ly[4] = [0, 0, 265, 265]
Global $Rx[4] = [460, 860, 400, 860]
Global $Ry[4] = [325, 325, 590, 590]

Global $Area[5][11][4], $IS_x[11][4], $IS_y[11][4], $E[5][11]

;~ $E[0][0] = @ScriptDir & "\images\ELIX1\E6F9.bmp"
;~ $E[0][1] = @ScriptDir & "\images\ELIX1\E7F9.bmp"
;~ $E[0][2] = @ScriptDir & "\images\ELIX1\E8F9.bmp"
;~ $E[0][3] = @ScriptDir & "\images\ELIX1\E9F9.bmp"
;~ $E[0][4] = @ScriptDir & "\images\ELIX1\E10F8.bmp"
;~ $E[0][5] = @ScriptDir & "\images\ELIX1\E10F9.bmp"
;~ $E[0][6] = @ScriptDir & "\images\ELIX1\E11F8.bmp"
;~ $E[0][7] = @ScriptDir & "\images\ELIX1\E11F9.bmp"
;~ $E[0][8] = @ScriptDir & "\images\ELIX1\E12F7.bmp"
;~ $E[0][9] = @ScriptDir & "\images\ELIX1\E12F8.bmp"
;~ $E[0][10] = @ScriptDir & "\images\ELIX1\E12F9.bmp"

;~ $E[1][0] = @ScriptDir & "\images\ELIX2\E6F9.bmp"
;~ $E[1][1] = @ScriptDir & "\images\ELIX2\E7F9.bmp"
;~ $E[1][2] = @ScriptDir & "\images\ELIX2\E8F9.bmp"
;~ $E[1][3] = @ScriptDir & "\images\ELIX2\E9F9.bmp"
;~ $E[1][4] = @ScriptDir & "\images\ELIX2\E10F8.bmp"
;~ $E[1][5] = @ScriptDir & "\images\ELIX2\E10F9.bmp"
;~ $E[1][6] = @ScriptDir & "\images\ELIX2\E11F8.bmp"
;~ $E[1][7] = @ScriptDir & "\images\ELIX2\E11F9.bmp"
;~ $E[1][8] = @ScriptDir & "\images\ELIX2\E12F7.bmp"
;~ $E[1][9] = @ScriptDir & "\images\ELIX2\E12F8.bmp"
;~ $E[1][10] = @ScriptDir & "\images\ELIX2\E12F9.bmp"

;~ $E[2][0] = @ScriptDir & "\images\ELIX3\E6F9.bmp"
;~ $E[2][1] = @ScriptDir & "\images\ELIX3\E7F9.bmp"
;~ $E[2][2] = @ScriptDir & "\images\ELIX3\E8F9.bmp"
;~ $E[2][3] = @ScriptDir & "\images\ELIX3\E9F9.bmp"
;~ $E[2][4] = @ScriptDir & "\images\ELIX3\E10F8.bmp"
;~ $E[2][5] = @ScriptDir & "\images\ELIX3\E10F9.bmp"
;~ $E[2][6] = @ScriptDir & "\images\ELIX3\E11F8.bmp"
;~ $E[2][7] = @ScriptDir & "\images\ELIX3\E11F9.bmp"
;~ $E[2][8] = @ScriptDir & "\images\ELIX3\E12F7.bmp"
;~ $E[2][9] = @ScriptDir & "\images\ELIX3\E12F8.bmp"
;~ $E[2][10] = @ScriptDir & "\images\ELIX3\E12F9.bmp"

;~ $E[3][0] = @ScriptDir & "\images\ELIX4\E6F9.bmp"
;~ $E[3][1] = @ScriptDir & "\images\ELIX4\E7F9.bmp"
;~ $E[3][2] = @ScriptDir & "\images\ELIX4\E8F9.bmp"
;~ $E[3][3] = @ScriptDir & "\images\ELIX4\E9F9.bmp"
;~ $E[3][4] = @ScriptDir & "\images\ELIX4\E10F8.bmp"
;~ $E[3][5] = @ScriptDir & "\images\ELIX4\E10F9.bmp"
;~ $E[3][6] = @ScriptDir & "\images\ELIX4\E11F8.bmp"
;~ $E[3][7] = @ScriptDir & "\images\ELIX4\E11F9.bmp"
;~ $E[3][8] = @ScriptDir & "\images\ELIX4\E12F7.bmp"
;~ $E[3][9] = @ScriptDir & "\images\ELIX4\E12F8.bmp"
;~ $E[3][10] = @ScriptDir & "\images\ELIX4\E12F9.bmp"

#Region ### Check Dead Base Functions ###
;==============================================================================================================
;===Main Function==============================================================================================
;--------------------------------------------------------------------------------------------------------------
;Uses imagesearch to see whether a collector is full or semi-full to indicate that it is a dead base
;Returns True if it is, returns false if it is not a dead base
;--------------------------------------------------------------------------------------------------------------

Func ZombieSearch()
	_CaptureRegion()

;~ 	If $iTownHallLevel >= 9 Then
;~ 		$ZombieFileSets = 4 ;Variant Image to use organized as per Folder
;~ 		$ZSExclude = 3 ;Set to 0 to include Elixir Lvl 6, 1 to include lvl 7 and so on..
;~ 	Else
;~ 		$ZombieFileSets = 3 ;Variant Image to use organized as per Folder
;~ 		$ZSExclude = 0 ;Set to 0 to include Elixir Lvl 6, 1 to include lvl 7 and so on..
;~ 	EndIf

	; If $debugSetlog = 1 Then SetLog("$ZSExclude :" & $ZSExclude, $COLOR_PURPLE)

	$ZombieCount = 0
	$ZC = 0
	For $s = 0 To ($ZombieFileSets - 1) Step 1
		For $p = 10 To 0 + $ZSExclude Step -1
			If FileExists($E[$s][$p]) Then
				$Area[$s][$p][0] = _ImageSearch($E[$s][$p], 1, $IS_x[$p][0], $IS_y[$p][0], $Tolerance[$s][$p] + $AdjustTolerance)
				If $Area[$s][$p][0] > 0 Then
					$ZC = 1
					ExitLoop (2)
				EndIf
			Else
				$Area[$s][$p][0] = 0
			EndIf
		Next
	Next
	$ZombieCount += $ZC
	If $ZombieCount > 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>ZombieSearch
#EndRegion ### Check Dead Base Functions ###

Func ZombieSearch2($limit = 0, $tolerancefix = 0)
	;variable limit: limit number of searches, limit = 0 disable limit search
	;variable tolerance: set a fixed tolerance, tolerance = 0 disable fixed tolerance
	Local $hTimer = TimerInit()
	Local $count = 0
	Local $ElixirLocation
	Local $ElixirLocationx, $ElixirLocationy
	Local $ZombieFound = False

	; calculate max number of files into folders
	Local $Tolerance
	Local $max100 = 0, $max75 = 0, $max50 = 0
	For $i = 0 To $maxElixirLevel
		If Int(Execute("$ElixirImages" & $i & "[0]")) > $max100 Then $max100 = Int(Execute("$ElixirImages" & $i & "[0]"))
	Next
	If $limit > 0 And $max100 > 0 And $limit <= $max100 Then $max100 = $limit

	For $i = 0 To $maxElixirLevel
		If Int(Execute("$ElixirImages" & $i & "_75percent" & "[0]")) > $max75 Then $max75 = Int(Execute("$ElixirImages" & $i & "_75percent" & "[0]"))
	Next
	If $limit > 0 And $max75 > 0 And $limit <= $max75 Then $max75 = $limit

	For $i = 0 To $maxElixirLevel
		If Int(Execute("$ElixirImages" & $i & "_50percent" & "[0]")) > $max50 Then $max50 = Int(Execute("$ElixirImages" & $i & "_50percent" & "[0]"))
	Next
	If $limit > 0 And $max50 > 0 And $limit <= $max50 Then $max50 = $limit

;~ 	ConsoleWrite ("max value =  " & $max &  @CRLF)

	_CaptureRegion(0, 0, $DEFAULT_WIDTH, $DEFAULT_HEIGHT, True)


	;CHECK ELIXIR COLLECTORS 50%

	For $i = 1 To $max50
		For $t = 0 To $maxElixirLevel
			If Int(Execute("$ElixirImages" & $t & "_50percent" & "[0]")) >= $i Then
				$count += 1
				If $tolerancefix > 0 Then
					$Tolerance = $tolerancefix
				Else
					$Tolerance = Number(StringMid(Execute("$ElixirImages" & $t & "_50percent" & "[" & $i & "]"), StringInStr(Execute("$ElixirImages" & $t & "_50percent" & "[" & $i & "]"), "T") + 1, StringInStr(Execute("$ElixirImages" & $t & "_50percent" & "[" & $i & "]"), ".bmp") - StringInStr(Execute("$ElixirImages" & $t & "_50percent" & "[" & $i & "]"), "T") - 1))
				EndIf
				ConsoleWrite("Examine image 50% n." & $i)
				ConsoleWrite(" for ElixirImage " & $t & "_50percent")
				ConsoleWrite(" - image name: " & Execute("$ElixirImages" & $t & "_50percent" & "[" & $i & "]"))
				ConsoleWrite(" - tolerance: <" & StringMid(Execute("$ElixirImages" & $t & "_50percent" & "[" & $i & "]"), StringInStr(Execute("$ElixirImages" & $t & "_50percent" & "[" & $i & "]"), "T") + 1, StringInStr(Execute("$ElixirImages" & $t & "_50percent" & "[" & $i & "]"), ".BMP") - StringInStr(Execute("$ElixirImages" & $t & "[" & $i & "]"), "T") - 1) & ">")
				ConsoleWrite(" - tolerancecalc: " & $Tolerance)
				ConsoleWrite(@CRLF)
				$ElixirLocation = _ImageSearch(@ScriptDir & "\images\ELIXIR50PERCENT\" & $t + 6 & "\" & Execute("$ElixirImages" & $t & "_50percent" & "[" & $i & "]"), 1, $ElixirLocationx, $ElixirLocationy, $Tolerance + ($DevMode = 1 ? Number($toleranceoffset) : 0)) ; Getting Elixir Location
				ConsoleWrite("Imagesearch return: ")
				ConsoleWrite("- ElixirLocation : " & $ElixirLocation)
				ConsoleWrite("- ElixirLocationx : " & $ElixirLocationx)
				ConsoleWrite("- TElixirLocationy : " & $ElixirLocationy)
				ConsoleWrite(@CRLF)

				If $ElixirLocation = 1 Then

					If $debugBuildingPos = 1 Then
						Setlog("#*# ZombieSearch2: ", $COLOR_TEAL)
						Setlog("  - Position (" & $ElixirLocationx & "," & $ElixirLocationy & ")", $COLOR_TEAL)
						Setlog("  - Elixir Collector 50% level " & $t + 6, $COLOR_TEAL)
						Setlog("  - Image Match " & Execute("$ElixirImages" & $t & "_50percent" & "[" & $i & "]"), $COLOR_TEAL)
						Setlog("  - IsInsidediamond: " & isInsideDiamondXY($ElixirLocationx, $ElixirLocationy), $COLOR_TEAL)
						SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
						SetLog("  - Images checked: " & $count, $COLOR_TEAL)
					EndIf
					If isInsideDiamondXY($ElixirLocationx, $ElixirLocationy) = True Then
						;add in stats-----
						Local $tempvect = Eval("ElixirImagesStat" & $t & "_50percent")
						$tempvect[$i] += 1
						Assign("ElixirImagesStat" & $t & "_50percent", $tempvect)
						;------------------
						$ZombieFound = True
						SaveStatChkDeadBase()
						ExitLoop (2)
					Else
						ContinueLoop
					EndIf
				EndIf
			EndIf
		Next
	Next

	;CHECK ELIXIR COLLECTORS 75%
	If $ZombieFound = False Then
		For $i = 1 To $max75
			For $t = 0 To $maxElixirLevel
				If Int(Execute("$ElixirImages" & $t & "_75percent" & "[0]")) >= $i Then
					$count += 1
					If $tolerancefix > 0 Then
						$Tolerance = $tolerancefix
					Else
						$Tolerance = Number(StringMid(Execute("$ElixirImages" & $t & "_75percent" & "[" & $i & "]"), StringInStr(Execute("$ElixirImages" & $t & "_75percent" & "[" & $i & "]"), "T") + 1, StringInStr(Execute("$ElixirImages" & $t & "_75percent" & "[" & $i & "]"), ".bmp") - StringInStr(Execute("$ElixirImages" & $t & "_75percent" & "[" & $i & "]"), "T") - 1))
					EndIf

					ConsoleWrite("Examine image 75% n." & $i)
					ConsoleWrite(" for ElixirImage " & $t & "_75percent")
					ConsoleWrite(" - image name: " & Execute("$ElixirImages" & $t & "_75percent" & "[" & $i & "]"))
					ConsoleWrite(" - tolerance: <" & StringMid(Execute("$ElixirImages" & $t & "_75percent" & "[" & $i & "]"), StringInStr(Execute("$ElixirImages" & $t & "_75percent" & "[" & $i & "]"), "T") + 1, StringInStr(Execute("$ElixirImages" & $t & "_75percent" & "[" & $i & "]"), ".BMP") - StringInStr(Execute("$ElixirImages" & $t & "[" & $i & "]"), "T") - 1) & ">")
					ConsoleWrite(" - tolerancecalc: " & $Tolerance)
					ConsoleWrite(@CRLF)
					$ElixirLocation = _ImageSearch(@ScriptDir & "\images\ELIXIR75PERCENT\" & $t + 6 & "\" & Execute("$ElixirImages" & $t & "_75percent" & "[" & $i & "]"), 1, $ElixirLocationx, $ElixirLocationy, $Tolerance + ($DevMode = 1 ? Number($toleranceoffset) : 0)) ; Getting Elixir Location
					ConsoleWrite("Imagesearch return: ")
					ConsoleWrite("- ElixirLocation : " & $ElixirLocation)
					ConsoleWrite("- ElixirLocationx : " & $ElixirLocationx)
					ConsoleWrite("- TElixirLocationy : " & $ElixirLocationy)
					ConsoleWrite(@CRLF)

					If $ElixirLocation = 1 Then

						If $debugBuildingPos = 1 Then
							Setlog("#*# ZombieSearch2: ", $COLOR_TEAL)
							Setlog("  - Position (" & $ElixirLocationx & "," & $ElixirLocationy & ")", $COLOR_TEAL)
							Setlog("  - Elixir Collector 75% level " & $t + 6, $COLOR_TEAL)
							Setlog("  - Image Match " & Execute("$ElixirImages" & $t & "_75percent" & "[" & $i & "]"), $COLOR_TEAL)
							Setlog("  - IsInsidediamond: " & isInsideDiamondXY($ElixirLocationx, $ElixirLocationy), $COLOR_TEAL)
							SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
							SetLog("  - Images checked: " & $count, $COLOR_TEAL)
						EndIf
						If isInsideDiamondXY($ElixirLocationx, $ElixirLocationy) = True Then
							;add in stats-----
							Local $tempvect = Eval("ElixirImagesStat" & $t & "_75percent")
							$tempvect[$i] += 1
							Assign("ElixirImagesStat" & $t & "_75percent", $tempvect)
							;------------------
							$ZombieFound = True
							SaveStatChkDeadBase()
							ExitLoop (2)
						Else
							ContinueLoop
						EndIf
					EndIf
				EndIf
			Next
		Next
	EndIf


	; CHECK ELIXIR COLLECTORS 100%
	If $ZombieFound = False Then
		For $i = 1 To $max100
			For $t = 0 To $maxElixirLevel
				If Int(Execute("$ElixirImages" & $t & "[0]")) >= $i Then
					$count += 1
					If $tolerancefix > 0 Then
						$Tolerance = $tolerancefix
					Else
						$Tolerance = Number(StringMid(Execute("$ElixirImages" & $t & "[" & $i & "]"), StringInStr(Execute("$ElixirImages" & $t & "[" & $i & "]"), "T") + 1, StringInStr(Execute("$ElixirImages" & $t & "[" & $i & "]"), ".bmp") - StringInStr(Execute("$ElixirImages" & $t & "[" & $i & "]"), "T") - 1))
					EndIf
					ConsoleWrite("Examine image 100% n." & $i)
					ConsoleWrite(" for ElixirImage " & $t)
					ConsoleWrite(" - image name: " & Execute("$ElixirImages" & $t & "[" & $i & "]"))
					ConsoleWrite(" - tolerance: <" & StringMid(Execute("$ElixirImages" & $t & "[" & $i & "]"), StringInStr(Execute("$ElixirImages" & $t & "[" & $i & "]"), "T") + 1, StringInStr(Execute("$ElixirImages" & $t & "[" & $i & "]"), ".BMP") - StringInStr(Execute("$ElixirImages" & $t & "[" & $i & "]"), "T") - 1) & ">")
					ConsoleWrite(" - tolerancecalc: " & $Tolerance)
					ConsoleWrite(@CRLF)
					$ElixirLocation = _ImageSearch(@ScriptDir & "\images\ELIXIR\" & $t + 6 & "\" & Execute("$ElixirImages" & $t & "[" & $i & "]"), 1, $ElixirLocationx, $ElixirLocationy, $Tolerance + ($DevMode = 1 ? Number($toleranceoffset) : 0)) ; Getting Elixir Location
					ConsoleWrite("Imagesearch return: ")
					ConsoleWrite("- ElixirLocation : " & $ElixirLocation)
					ConsoleWrite("- ElixirLocationx : " & $ElixirLocationx)
					ConsoleWrite("- TElixirLocationy : " & $ElixirLocationy)
					ConsoleWrite(@CRLF)

					If $ElixirLocation = 1 Then

						If $debugBuildingPos = 1 Then
							Setlog("#*# ZombieSearch2: ", $COLOR_TEAL)
							Setlog("  - Position (" & $ElixirLocationx & "," & $ElixirLocationy & ")", $COLOR_TEAL)
							Setlog("  - Elixir Collector 100% level " & $t + 6, $COLOR_TEAL)
							Setlog("  - Image Match " & Execute("$ElixirImages" & $t & "[" & $i & "]"), $COLOR_TEAL)
							Setlog("  - IsInsidediamond: " & isInsideDiamondXY($ElixirLocationx, $ElixirLocationy), $COLOR_TEAL)
							SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
							SetLog("  - Images checked: " & $count, $COLOR_TEAL)
						EndIf
						If isInsideDiamondXY($ElixirLocationx, $ElixirLocationy) = True Then
							;add in stats-----
							Local $tempvect = Eval("ElixirImagesStat" & $t)
							$tempvect[$i] += 1
							Assign("ElixirImagesStat" & $t, $tempvect)
							;------------------
							$ZombieFound = True
							SaveStatChkDeadBase()
							ExitLoop (2)
						Else
							ContinueLoop
						EndIf
					EndIf
				EndIf
			Next
		Next
	EndIf

	If $ZombieFound = False Then
		If $debugBuildingPos = 1 Then

			Setlog("#*# ZombieSearch2: NONE ", $COLOR_TEAL)
			SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
			SetLog("  - Images checked: " & $count, $COLOR_TEAL)
			Setlog(" FOUND = " & $ZombieFound, $COLOR_TEAL)
		EndIf
		If $debugBuildingPos = 1 And ($limit <> 0 Or $tolerancefix <> 0) Then Setlog("#*# ZombieSearch2: limit= " & $limit & ", tolerancefix=" & $tolerancefix, $COLOR_TEAL)
		If $debugImageSave = 1 Then DebugImageSave("ZombieSearch2_NoDeadBaseFound_", True)
	    If $debugsetlog=1 then Setlog("Collectors NO match, dead base not found",$color_purple)
		Return False
	Else
		If $debugBuildingPos = 1 Then
			Setlog(" FOUND = " & $ZombieFound, $COLOR_TEAL)
		EndIf
	    If $debugsetlog=1 then Setlog("Collectors match, dead base found",$color_purple)
		Return True
	EndIf



EndFunc   ;==>ZombieSearch2

Func SaveStatChkDeadBase()
	Local $hFile
	$hFile = FileOpen($statChkDeadBase, $FO_UTF16_LE + $FO_OVERWRITE)
	If FileExists($statChkDeadBase) Then
		For $t = 0 To $maxElixirLevel
			For $i = 1 To UBound(Eval("ElixirImages" & $t)) - 1
				IniWrite($statChkDeadBase, $t, Execute("$ElixirImages" & $t & "[" & $i & "]"), Execute("$ElixirImagesStat" & $t & "[" & $i & "]"))
			Next
		Next
	EndIf
	FileClose($hFile)

	$hFile = FileOpen($statChkDeadBase75percent, $FO_UTF16_LE + $FO_OVERWRITE)
	If FileExists($statChkDeadBase75percent) Then
		For $t = 0 To $maxElixirLevel
			For $i = 1 To UBound(Eval("ElixirImages" & $t & "_75percent")) - 1
				IniWrite($statChkDeadBase75percent, $t, Execute("$ElixirImages" & $t & "_75percent" & "[" & $i & "]"), Execute("$ElixirImagesStat" & $t & "_75percent" & "[" & $i & "]"))
			Next
		Next
	EndIf
	FileClose($hFile)

	$hFile = FileOpen($statChkDeadBase50percent, $FO_UTF16_LE + $FO_OVERWRITE)
	If FileExists($statChkDeadBase50percent) Then
		For $t = 0 To $maxElixirLevel
			For $i = 1 To UBound(Eval("ElixirImages" & $t & "_50percent")) - 1
				IniWrite($statChkDeadBase50percent, $t, Execute("$ElixirImages" & $t & "_50percent" & "[" & $i & "]"), Execute("$ElixirImagesStat" & $t & "_50percent" & "[" & $i & "]"))
			Next
		Next
	EndIf
	FileClose($hFile)
EndFunc   ;==>SaveStatChkDeadBase
