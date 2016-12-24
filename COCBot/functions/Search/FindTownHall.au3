; #FUNCTION# ====================================================================================================================
; Name ..........: FindTownHall
; Description ...:
; Syntax ........: FindTownHall([$check = True])
; Parameters ....: $check               - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func FindTownHall($check = True, $forceCaptureRegion = True)
	Local $THString = ""
	$searchTH = "-"
	$THx=0
	$THy=0;if not check, find     TH Snipe and bully mode, always find				if deadbase enabled, and TH lvl or Outside checked, find          same with ActiveBase

	If $check = True Or _
		 IsSearchModeActive($TS)  Or _
		($isModeActive[$DB] And (  Number($iChkMeetTH[$DB])>0 Or Number($ichkMeetTHO[$DB])>0)) Or _
		($isModeActive[$LB] And (  Number($iChkMeetTH[$LB])>0 Or Number($ichkMeetTHO[$LB])>0)) Then

		;$searchTH = checkTownHallADV2()
		$searchTH = imgloccheckTownHallADV2(0, 0, $forceCaptureRegion)

		;2nd attempt - NOT NEEDED AHS IMGLOC TRIES 2 TIMES
		;If $searchTH = "-" Then ; retry with autoit search after $iDelayVillageSearch5 seconds
		;	If _Sleep($iDelayGetResources5) Then Return
		;	If $debugsetlog=1 Then SetLog("2nd attempt to detect the TownHall!", $COLOR_ERROR)
		;	$searchTH = THSearch()
		;EndIf

		If $searchTH <> "-"  And SearchTownHallLoc() = False Then
			$THLoc = "In"
		ElseIf $searchTH <> "-" Then
			$THLoc = "Out"
		Else
			$THLoc = $searchTH
			$THx = 0
			$THy = 0
		EndIf
		;EndIf
		Return " [TH]:" & StringFormat("%2s", $searchTH) & ", " & $THLoc
	EndIf
	$THLoc = $searchTH
	$THx = 0
	$THy = 0
	Return ""
EndFunc