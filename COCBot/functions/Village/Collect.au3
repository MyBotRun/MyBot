
; #FUNCTION# ====================================================================================================================
; Name ..........: Collect
; Description ...:
; Syntax ........: Collect()
; Parameters ....:
; Return values .: None
; Author ........: Code Gorilla #3
; Modified ......: Sardo 2015-08
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func Collect()
	if $RunState = False Then Return

	ClickP($aAway,1,0,"#0332") ;Click Away

	If $iChkCollect = 0 Then Return

	Local $collx, $colly, $i = 0

	SetLog("Collecting Resources", $COLOR_BLUE)
	If _Sleep($iDelayCollect2) Then Return

	if $listResourceLocation <> "" then
		local $ResourceLocations = StringSplit($listResourceLocation,"|")
		for $i=1 to $ResourceLocations[0]
			if $ResourceLocations[$i] <> "" then
				$pixel = StringSplit($ResourceLocations[$i],";")
				If isInsideDiamondXY($pixel[1],$pixel[2]) Then
					click($pixel[1],$pixel[2],1,0,"#0331")
				Else
					SetLog("Error in Mines/Collector locations found, finding positions again", $COLOR_RED)
					IniDelete($building, "other", "listResource")
					If _Sleep($iDelayCollect2) Then Return
					$listResourceLocation = ""
					BotDetectFirstTime()
					IniWrite($building, "other", "listResource", $listResourceLocation)
					ExitLoop
				EndIf
				If _Sleep($iDelayCollect2) Then Return
			endif
		next
	endif

	While 1
		If _Sleep($iDelayCollect1) Or $RunState = False Then ExitLoop
		_CaptureRegion(0,0,780)
		If _ImageSearch(@ScriptDir & "\images\collect.png", 1, $collx, $colly, 20) Then
			Click($collx, $colly,1,0,"#0330") ;Click collector
			If _Sleep($iDelayCollect1) Then Return
			ClickP($aAway,1,0,"#0329") ;Click Away
		Elseif $i >= 20 Then
			ExitLoop
		EndIf
		$i += 1
	WEnd
	If _Sleep($iDelayCollect3) Then Return
	checkMainScreen(False)  ; check if errors during function
EndFunc   ;==>Collect