; #FUNCTION# ====================================================================================================================
; Name ..........: QuickMIS
; Description ...: A function to easily use ImgLoc, without headache :P !!!
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: ---
; Remarks .......: This file is part of MyBotRun. Copyright 2017
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

Func QuickMIS($ValueReturned, $directory, $Left = 0, $Top = 0, $Right = $g_iGAME_WIDTH, $Bottom = $g_iGAME_HEIGHT, $bNeedCapture = True, $Debug = False)
	If ($ValueReturned <> "BC1") And ($ValueReturned <> "CX") And ($ValueReturned <> "N1") And ($ValueReturned <> "NX") And ($ValueReturned <> "Q1") And ($ValueReturned <> "QX") Then
		SetLog("Bad parameters during QuickMIS call for MultiSearch...", $COLOR_RED)
		Return
	EndIf

	If $bNeedCapture Then _CaptureRegion2($Left, $Top, $Right, $Bottom)
	Local $Res = DllCall($g_hLibMyBot,"str", "SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)
	If @error Then _logErrorDLLCall($g_sLibImgLocPath, @error)

	If IsArray($Res) Then
		If $Debug Then _ArrayDisplay($Res)
		If $g_bDebugSetlog = 1 Then SetLog("DLL Call succeeded " & $Res[0], $COLOR_PURPLE)

		If $Res[0] = "" Or $Res[0] = "0" Then
			If $g_bDebugSetlog Then SetLog("No Button found")
			Switch $ValueReturned
				Case "BC1"
					Return False
				Case "CX"
					Return -1
				Case "N1"
					Return "none"
				Case "NX"
					Return "none"
				Case "Q1"
					Return 0
				Case "QX"
					Return 0
			EndSwitch

		ElseIf StringInStr($Res[0], "-1") <> 0 Then
			SetLog("DLL Error", $COLOR_RED)

		Else
			Switch $ValueReturned

				Case "BC1" ; coordinates of first/one image found + boolean value

					Local $Result = ""
					Local $KeyValue = StringSplit($Res[0], "|", $STR_NOCOUNT)
					For $i = 0 To UBound($KeyValue) - 1
						Local $DLLRes = DllCall($g_sLibImgLocPath, "str", "GetProperty", "str", $KeyValue[$i], "str", "objectpoints")
						$Result &= $DLLRes[0] & "|"
					Next
					If StringRight($Result, 1) = "|" Then $Result = StringLeft($Result, (StringLen($Result) - 1))
					Local $CoordsInArray = StringSplit($Result, ",", $STR_NOCOUNT)
					$g_iQuickMISX = $CoordsInArray[0]
					$g_iQuickMISY = $CoordsInArray[1]
					Return True

				Case "CX" ; coordinates of each image found - eg: $Array[0] = [X1, Y1] ; $Array[1] = [X2, Y2]

					Local $Result = ""
					Local $KeyValue = StringSplit($Res[0], "|", $STR_NOCOUNT)
					For $i = 0 To UBound($KeyValue) - 1
						Local $DLLRes = DllCall($g_sLibImgLocPath, "str", "GetProperty", "str", $KeyValue[$i], "str", "objectpoints")
						$Result &= $DLLRes[0] & "|"
					Next
					If StringRight($Result, 1) = "|" Then $Result = StringLeft($Result, (StringLen($Result) - 1))
					Local $CoordsInArray = StringSplit($Result, "|", $STR_NOCOUNT)
					Return $CoordsInArray

				Case "N1" ; name of first file found

					Local $MultiImageSearchResult = StringSplit($Res[0], "|")
					Local $FilenameFound = StringSplit($MultiImageSearchResult[1], "_")
					Return $FilenameFound[1]

				Case "NX" ; names of all files found

					Local $AllFilenamesFound = ""
					Local $MultiImageSearchResult = StringSplit($Res[0], "|")
					For $i = 1 To $MultiImageSearchResult[0]
						Local $FilenameFound = StringSplit($MultiImageSearchResult[$i], "_")
						$AllFilenamesFound &= $FilenameFound[1] & "|"
					Next
					If StringRight($AllFilenamesFound, 1) = "|" Then $AllFilenamesFound = StringLeft($AllFilenamesFound, (StringLen($AllFilenamesFound) - 1))
					Return $AllFilenamesFound

				Case "Q1" ; quantity of first/one tiles found

					Local $Result = ""
					Local $KeyValue = StringSplit($Res[0], "|", $STR_NOCOUNT)
					For $i = 0 To UBound($KeyValue) - 1
						Local $DLLRes = DllCall($g_sLibImgLocPath, "str", "GetProperty", "str", $KeyValue[$i], "str", "totalobjects")
						$Result &= $DLLRes[0] & "|"
					Next
					If StringRight($Result, 1) = "|" Then $Result = StringLeft($Result, (StringLen($Result) - 1))
					Local $QuantityInArray = StringSplit($Result, "|", $STR_NOCOUNT)
					Return $QuantityInArray[0]

				Case "QX" ; quantity of files found

					Local $MultiImageSearchResult = StringSplit($Res[0], "|", $STR_NOCOUNT)
					Return UBound($MultiImageSearchResult)

			EndSwitch
		EndIf
	EndIf
EndFunc   ;==>QuickMIS