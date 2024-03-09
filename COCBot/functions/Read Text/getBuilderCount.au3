; #FUNCTION# ====================================================================================================================
; Name ..........: getBuilderCount
; Description ...: updates global builder count variables
; Syntax ........: getBuilderCount([$bSuppressLog = False], [$bBuilderBase = False])
; Parameters ....: $bSuppressLog        - [optional] a boolean value that stops log of builder count. Default is False.
; Parameters ....: $bBuilderBase        - [optional] Set to True if you want to get Builder Count on Builder Base. Default is False -> Read Normal Village Count
; Return values .: None
; Author ........: MonkeyHunter (06-2016)
; Modified ......: Fliegerfaust (06-2017), Moebius14 (07-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getBuilderCount($bSuppressLog = False, $bBuilderBase = False)

	Local $sBuilderInfo, $aGetBuilders, $bIsMainPage = False

	If Not $bBuilderBase Then
		$bIsMainPage = IsMainPage()
	Else
		$bIsMainPage = IsMainPageBuilderBase()
	EndIf

	If $bIsMainPage Then ; check for proper window location

		If Not $bBuilderBase Then
			Local $ExtraBuilderCount = 0
			If UBound(decodeSingleCoord(FindImageInPlace2("GobBuilder", $g_sImgGobBuilder, 360, 0, 450, 60, True))) > 1 Then $ExtraBuilderCount = 1
			$sBuilderInfo = getBuilders($aBuildersDigits[0], $aBuildersDigits[1]) ; get builder string with OCR
		Else
			Local $asSearchResult = decodeSingleCoord(FindImageInPlace2("MasterBuilderHead", $g_sImgMasterBuilderHead, 445, 0, 500, 54, True))
			If IsArray($asSearchResult) And UBound($asSearchResult) = 2 Then
				$sBuilderInfo = getBuilders($asSearchResult[0] + 24, $aBuildersDigitsBuilderBase[1]) ; get builder base builder string with OCR
			Else
				SetLog("Cannot find Master Builder Head", $COLOR_ERROR)
				If $g_bDebugImageSave Then SaveDebugImage("MasterBuilderHead") ; Debug Only
			EndIf
		EndIf
		If StringInStr($sBuilderInfo, "#") > 0 Then ; check for valid OCR read
			$aGetBuilders = StringSplit($sBuilderInfo, "#", $STR_NOCOUNT) ; Split into free and total builder strings
			If Not $bBuilderBase Then
				$g_iFreeBuilderCount = Int($aGetBuilders[0] - $ExtraBuilderCount) ; update global values
				If $g_iTestFreeBuilderCount <> -1 Then $g_iFreeBuilderCount = $g_iTestFreeBuilderCount ; used for test cases
				$g_iTotalBuilderCount = Int($aGetBuilders[1] - $ExtraBuilderCount)
				If $g_bDebugSetlog And Not $bSuppressLog Then SetLog("No. of Free/Total Builders: " & $g_iFreeBuilderCount & "/" & $g_iTotalBuilderCount, $COLOR_DEBUG)
			Else
				$g_iFreeBuilderCountBB = Int($aGetBuilders[0]) ; update global values
				$g_iTotalBuilderCountBB = Int($aGetBuilders[1])
				If $g_bDebugSetlog And Not $bSuppressLog Then SetLog("No. of Free/Total Builders: " & $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB, $COLOR_DEBUG)
			EndIf
			$g_iGfxErrorCount = 0
			Return True ; Happy Monkey returns!
		Else
			SetLog("Bad OCR read Free/Total Builders", $COLOR_ERROR) ; OCR returned unusable value?
			$g_iGfxErrorCount += 1
			If $g_iGfxErrorCount > $g_iGfxErrorMax Then 
				SetLog("gfxError occured, set to Reboot Android Instance", $COLOR_INFO)
				$g_bGfxError = True
				CheckAndroidReboot()
			EndIf
			; drop down to error handling code
		EndIf
	Else
		SetLog("Unable to read Builders info at this time", $COLOR_ERROR)
		; drop down to error handling code
	EndIf
	If $g_bDebugSetlog Or $g_bDebugImageSave Then SaveDebugImage("getBuilderCount_")
	If checkObstacles() Then checkMainScreen() ; trap common error messages
	Return False

EndFunc   ;==>getBuilderCount
