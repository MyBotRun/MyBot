
; #FUNCTION# ====================================================================================================================
; Name ..........: getBuilderCount
; Description ...: updates global builder count variables
; Syntax ........: getBuilderCount([$bSuppressLog = False])
; Parameters ....: $bSuppressLog        - [optional] a boolean value that stops log of builder count. Default is False.
; Return values .: None
; Author ........: MonkeyHunter (06-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getBuilderCount($bSuppressLog = False)

	Local $sBuilderInfo, $aGetBuilders

	If IsMainPage() = True Then   ; check for proper window location

		$sBuilderInfo = getBuilders($aBuildersDigits[0], $aBuildersDigits[1]) ; get builder string with OCR

		If StringInStr($sBuilderInfo, "#") > 0 Then  ; check for valid OCR read
			$aGetBuilders = StringSplit($sBuilderInfo, "#", $STR_NOCOUNT)  ; Split into free and total builder strings
			$iFreeBuilderCount = Int($aGetBuilders[0]) ; update global values
			$iTotalBuilderCount = Int($aGetBuilders[1])
			If $debugSetlog = 1 And $bSuppressLog = False Then Setlog("No. of Free/Total Builders: " & $iFreeBuilderCount & "/" & $iTotalBuilderCount, $COLOR_PURPLE)
			Return True  ; Happy Monkey returns!
		Else
			SetLog("Bad OCR read Free/Total Builders", $COLOR_RED) ; OCR returned unusable value?
			; drop down to error handling code
		EndIf
	Else
		SetLog("Unable to read Builders info at this time", $COLOR_RED)
		; drop down to error handling code
	EndIf
	If $debugSetlog = 1 Or $debugimagesave = 1 Then Debugimagesave("getBuilderCount_")
	If checkObstacles() Then checkMainScreen()  ; trap common error messages
	Return False

EndFunc
