; #FUNCTION# ====================================================================================================================
; Name ..........: IsWindowOpen()
; Description ...: Checks a image x times until it is found on screen
; Author ........: Fliegerfaust (06/2019)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Returns True or False
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================
Global $g_avWindowCoordinates[2] = [-1, -1]

Func IsWindowOpen($sImagePath, $iLoopCount = 1, $iDelay = 200, $sSearchArea = "FV")
	Local $aFiles = _FileListToArrayRec($sImagePath)
	Local $aWindow, $avResetCoords[2] = [-1, -1]
	$g_avWindowCoordinates = $avResetCoords

	If IsArray($aFiles) And $aFiles[0] > 1 Then
		For $i = 0 To $iLoopCount
			$aWindow = findMultiple($sImagePath, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", True)
			If IsArray($aWindow) And UBound($aWindow, 1) > 0 Then
				Local $aTempArray = $aWindow[0]
				$g_avWindowCoordinates = decodeSingleCoord($aTempArray[1])
				Return True
			EndIf
			If _Sleep($iDelay) Then Return False
		Next
	Else
		For $i = 0 To $iLoopCount
			$aWindow = decodeSingleCoord(findImage("IsWindow", $sImagePath, $sSearchArea, 1, True, Default))
			If IsArray($aWindow) And UBound($aWindow, 1) = 2 Then
				$g_avWindowCoordinates = $aWindow
				Return True
			EndIf
			If _Sleep($iDelay) Then Return False
		Next
	EndIf

	Return False
EndFunc