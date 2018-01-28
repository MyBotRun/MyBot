; #FUNCTION# ====================================================================================================================
; Name ..........: ConvertOCRTime
; Description ...: This function will update the statistics in the GUI.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Boju (11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================

Func ConvertOCRTime($WhereRead, $ToConvert, $bSetLog = True)
	Local $iRemainTimer = 0, $sResultMinutes = "", $aResult
	If $ToConvert <> "" Then
		If StringInStr($ToConvert, "h") > 1 Then
			$aResult = StringSplit($ToConvert, "h", $STR_NOCOUNT)
			; $aResult[0] will be the Hour and the $aResult[1] will be the Minutes with the "m" at end
			$sResultMinutes = StringTrimRight($aResult[1], 1) ; removing the "m"
			$iRemainTimer = (Number($aResult[0]) * 60) + Number($sResultMinutes)
		ElseIf StringInStr($ToConvert, "m") > 1 Then
			$iRemainTimer = Number(StringTrimRight($ToConvert, 1)) ; removing the "m"
		ElseIf StringInStr($ToConvert, "s") > 1 Then
			$iRemainTimer = Number(StringTrimRight($ToConvert, 1)) / 60 ; removing the "s" and convert to minutes
		Else
			If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog($WhereRead & ": Bad OCR string", $COLOR_ERROR)
		EndIf
		If $bSetLog Then SetLog($WhereRead & " time: " & StringFormat("%.2f", $iRemainTimer) & " min", $COLOR_INFO)
	Else
		If Not $g_bFullArmySpells Then
			If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Can not read remaining time for " & $WhereRead, $COLOR_ERROR)
		EndIf
	EndIf
	Return $iRemainTimer
EndFunc   ;==>ConvertOCRTime
