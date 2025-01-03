; #FUNCTION# ====================================================================================================================
; Name ..........: donateCCWBL
; Description ...: This file includes functions to Donate troops
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016-09)
; Modified ......: MR.ViPER (27-12-2016), Moebius14 (2024-03)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;collect donation request users images
Func donateCCWBLUserImageCollect($x, $y)

	Local $imagematch = False

	Local $g_TopDividerSearch = 0
	Local $asDividerResult = decodeSingleCoord(FindImageInPlace2("DCCWBL", $g_sImgChatDivider, $x - 50, $y - 220, $x + 30, $y - 40, True))

	If IsArray($asDividerResult) And UBound($asDividerResult) = 2 Then
		$g_TopDividerSearch = $asDividerResult[1] - 24
		If $g_bDebugImageSave Then SaveDebugImage("donateCCWBLDebugImage")
		If $g_bDebugSetLog Then SetDebugLog("$g_TopDividerSearch = " & $g_TopDividerSearch, $COLOR_DEBUG)
	Else
		If $g_bDebugImageSave Then SaveDebugImage("donateCCWBLDebugImage")
		Return True ; <=== return DONATE
	EndIf

	;if OnlyWhiteList enable check and donate TO COMPLETE
	SetDebugLog("Search into whitelist...", $color_purple)
	Local $xyz = _FileListToArrayRec($g_sProfileDonateCaptureWhitelistPath, "*.png", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
	If UBound($xyz) > 1 Then
		For $i = 1 To UBound($xyz) - 1
			Local $result = FindImageInPlace("DCCWBL", $g_sProfileDonateCaptureWhitelistPath & $xyz[$i], "40," & $g_TopDividerSearch & "," & $x - 30 & "," & $g_TopDividerSearch + 26, True)
			If StringInStr($result, ",") > 0 Then
				If $g_iCmbDonateFilter = 2 Then SetLog("WHITE LIST: image match! " & $xyz[$i], $COLOR_SUCCESS)
				$imagematch = True
				If $g_iCmbDonateFilter = 2 Then Return True ; <=== return DONATE if name found in white list
				ExitLoop
			EndIf
		Next
	EndIf

	;if OnlyBlackList enable check and donate
	SetDebugLog("Search into blacklist...", $color_purple)
	Local $xyz1 = _FileListToArrayRec($g_sProfileDonateCaptureBlacklistPath, "*.png", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
	If UBound($xyz1) > 1 Then
		For $i = 1 To UBound($xyz1) - 1
			Local $result1 = FindImageInPlace("DCCWBL", $g_sProfileDonateCaptureBlacklistPath & $xyz1[$i], "40," & $g_TopDividerSearch & "," & $x - 30 & "," & $g_TopDividerSearch + 26, True)
			If StringInStr($result1, ",") > 0 Then
				If $g_iCmbDonateFilter = 3 Then SetLog("BLACK LIST: image match! " & $xyz1[$i], $COLOR_SUCCESS)
				$imagematch = True
				If $g_iCmbDonateFilter = 3 Then Return False ; <=== return NO DONATE if name found in black list
				ExitLoop
			Else
				SetDebugLog("Image not found", $COLOR_ERROR)
			EndIf
		Next
	EndIf

	If $imagematch = False And $g_iCmbDonateFilter > 0 Then
		SetDebugLog("Search into images to assign...", $color_purple)
		;try to search into images to Assign
		Local $xyzw = _FileListToArrayRec($g_sProfileDonateCapturePath, "*.png", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		If UBound($xyzw) > 1 Then
			For $i = 1 To UBound($xyzw) - 1
				Local $resultxyzw = FindImageInPlace("DCCWBL", $g_sProfileDonateCapturePath & $xyzw[$i], "40," & $g_TopDividerSearch & "," & $x - 30 & "," & $g_TopDividerSearch + 26, True)
				If StringInStr($resultxyzw, ",") > 0 Then
					If $g_iCmbDonateFilter = 1 Or $g_bDebugSetLog Then SetLog("IMAGES TO ASSIGN: image match! " & $xyzw[$i], $COLOR_SUCCESS)
					$imagematch = True
					ExitLoop
				EndIf
			Next
		EndIf

		;save image (search divider chat line to know position of village name)
		If $imagematch = False Then

			SetDebugLog("save image in images to assign...", $color_purple)
			If IsArray($asDividerResult) And UBound($asDividerResult) = 2 Then

				;capture donate request image
				_CaptureRegion2()

				;search chat divider line
				Local $iAllFilesCount = 0

				Local $xfound = Int($asDividerResult[0])
				Local $yfound = Int($asDividerResult[1])
				SetDebugLog("ChatDivider found (" & $xfound & "," & $yfound & ")", $COLOR_SUCCESS)

				; now crop image to have only request village name and put in $hClone
				Local $oBitmap = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
				Local $hClone = _GDIPlus_BitmapCloneArea($oBitmap, 52, $yfound - 18, 100, 14, $GDIP_PXF24RGB)
				;save image
				Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
				Local $Time = @HOUR & "." & @MIN & "." & @SEC
				$iAllFilesCount = _FileListToArrayRec($g_sProfileDonateCapturePath, "*", 1, 0, 0, 0)
				If IsArray($iAllFilesCount) Then
					$iAllFilesCount = $iAllFilesCount[0]
				Else
					$iAllFilesCount = 0
				EndIf
				Local $filename = String("ClanMate--" & $Date & "_" & Number($iAllFilesCount) + 1 & "_98.png")
				_GDIPlus_ImageSaveToFile($hClone, $g_sProfileDonateCapturePath & $filename)
				_GDIPlus_BitmapDispose($hClone)
				_GDIPlus_BitmapDispose($oBitmap)
				If $g_iCmbDonateFilter = 1 Then SetLog("IMAGES TO ASSIGN: stored!", $COLOR_SUCCESS)
				;remove old files into folder images to assign if are older than 2 days
				Deletefiles($g_sProfileDonateCapturePath, "*.png", 2, 0)
			EndIf
		EndIf
	EndIf
	If $g_iCmbDonateFilter <= 1 Then
		Return True ; <=== return DONATE if no white or black list set
	ElseIf $g_iCmbDonateFilter = 3 Then
		Return True ; <=== return DONATE if name not found in black list
	Else
		Return False ; <=== return NO DONATE
	EndIf
EndFunc   ;==>donateCCWBLUserImageCollect
