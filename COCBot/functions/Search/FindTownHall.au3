; #FUNCTION# ====================================================================================================================
; Name ..........: FindTownHall
; Description ...:
; Syntax ........: FindTownHall([$check = True])
; Parameters ....: $check               - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
#include-once

Func FindTownHall($check = True, $forceCaptureRegion = True)
	Local $THString = ""
	$searchTH = "-"
	$THx=0
	$THy=0;if not check, find     TH Snipe and bully mode, always find				if deadbase enabled, and TH lvl or Outside checked, find          same with ActiveBase

	If $check = True Or _
		 IsSearchModeActive($TS)  Or _
		($isModeActive[$DB] And ($g_abFilterMeetTH[$DB] Or $g_abFilterMeetTHOutsideEnable[$DB])) Or _
		($isModeActive[$LB] And ($g_abFilterMeetTH[$LB] Or $g_abFilterMeetTHOutsideEnable[$LB])) Then

		$searchTH = imgloccheckTownHallADV2(0, 0, $forceCaptureRegion)

		;2nd attempt - NOT NEEDED AHS IMGLOC TRIES 2 TIMES
		;If $searchTH = "-" Then ; retry with autoit search after $iDelayVillageSearch5 seconds
		;	If _Sleep($iDelayGetResources5) Then Return
		;	If $g_iDebugSetlog=1 Then SetLog("2nd attempt to detect the TownHall!", $COLOR_ERROR)
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