; #FUNCTION# ====================================================================================================================
; Name ..........: CheckPrerequisites
; Description ...:
; Syntax ........: CheckPrerequisites()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: Heridero, Zengzeng (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CheckPrerequisites()
	Local $isNetFramework4dot5Installed = isNetFramework4dot5Installed()
	Local $isVC2010Installed = isVC2010Installed()
	If ($isNetFramework4dot5Installed = False Or $isVC2010Installed = False) Then
		If ($isNetFramework4dot5Installed = False) Then
			SetLog("The .Net Framework 4.5 is not installed", $COLOR_RED)
			SetLog("Please download here : https://www.microsoft.com/en-US/download/details.aspx?id=30653", $COLOR_RED)
		EndIf
		If ($isVC2010Installed = False) Then
			SetLog("The VC 2010 x86 is not installed", $COLOR_RED)
			SetLog("Please download here : https://www.microsoft.com/en-US/download/details.aspx?id=5555", $COLOR_RED)
		EndIf

		GUICtrlSetState($btnStart, $GUI_DISABLE)
	EndIf
	If isEveryFileInstalled() = False Then Exit
	If Not checkAutoitVersion() Then Exit
EndFunc   ;==>CheckPrerequisites

Func isNetFramework4Installed()
	Local $z = 0, $sKeyName, $success = False
	Do
		$z += 1
		$sKeyName = RegEnumKey("HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP", $z)
		If StringRegExp($sKeyName, "v4|v4.\d+") Then
			$success = True
		EndIf
	Until $sKeyName = '' Or $success
	Return $success
EndFunc   ;==>isNetFramework4Installed

Func isNetFramework4dot5Installed()
	;https://msdn.microsoft.com/it-it/library/hh925568%28v=vs.110%29.aspx#net_b
	Local $z = 0, $sKeyValue, $success = False
	$sKeyValue = RegRead("HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\", "Release")
	If Number($sKeyValue) >= 378389 Then $success = True
	Return $success
EndFunc   ;==>isNetFramework4dot5Installed

Func isVC2010Installed()
	Local $listRegistry[4] = ["HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\10.0\VC\VCRedist\x86", _
			"HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\10.0\VC\VCRedist\x86", _
			"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\VisualStudio\12.0\VC\Runtimes\x86", _
			"HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\12.0\VC\Runtimes\x86" _
			]

	Local $success = False
	For $reg In $listRegistry
		$sKeyName = RegRead($reg, "Version")
		If $sKeyName <> "" Then
			$success = True
			ExitLoop
		EndIf
	Next

	Return $success
EndFunc   ;==>isVC2010Installed

Func isEveryFileInstalled()
	Local $bResult = False, $iCount = 0

	; folders and files needed checking
	Local $aCheckFiles[9] = [@ScriptDir & "\COCBot", _
			$LibDir, _
			@ScriptDir & "\Images", _
			$pFuncLib, _
			$pImageLib, _
			$pImgLib, _
			$pIconLib, _
			$LibDir & "\opencv_core220.dll", _
			$LibDir & "\opencv_imgproc220.dll"]

	For $vElement In $aCheckFiles
		$iCount += FileExists($vElement)
	Next
	If $iCount = UBound($aCheckFiles) Then
		$bResult = True
	Else
		GUICtrlSetState($btnStart, $GUI_DISABLE)

		Local $sText1, $sText2, $MsgBox
		$sText1 = GetTranslated(640,11,"Hey Chief, we are missing some files!")
		$sText2 = GetTranslated(640,12,"Please extract all files and folders and start this program again!")
		$sText3 = GetTranslated(640,13,"Sorry, Start button disabled until fixed!")

		Setlog($sText1, $COLOR_RED)
		Setlog($sText2, $COLOR_RED)
		Setlog($sText3, $COLOR_RED)

		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$MsgBox = _ExtMsgBox(48, GetTranslated(640,14,"Ok"), $sText1, $sText2, 0, $frmBot)
		GUICtrlSetState($btnStart, $GUI_DISABLE)
		;Exit
	EndIf
	If @Compiled Then;if .exe
		If Not StringInStr(@ScriptFullPath, "MyBot.run.exe", 1) Then; if filename isn't MyBot.run.exe
			Local $sText1, $sText2, $MsgBox
			$sText1 = GetTranslated(640,15,"Hey Chief, file name incorrect!")
			$sText2 = GetTranslated(640,16,'You have renamed the file "MyBot.run.exe"! Please change it back to MyBot.run.exe and restart the bot!')
			$sText3 = GetTranslated(640,13,"Sorry, Start button disabled until fixed!")

			Setlog($sText1, $COLOR_RED)
			Setlog($sText2, $COLOR_RED)
			Setlog($sText3, $COLOR_RED)

			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
			$MsgBox = _ExtMsgBox(48, GetTranslated(640,14,"Ok"), $sText1, $sText2, 0, $frmBot)
			GUICtrlSetState($btnStart, $GUI_DISABLE)
			$bResult = False
		EndIf
	EndIf
	Return $bResult
EndFunc   ;==>isEveryFileInstalled

Func checkAutoitVersion()
	If @Compiled = True Then Return 1
	Local $requiredAutoit = "3.3.14.2"
	Local $result = _VersionCompare(@AutoItVersion, $requiredAutoit)
	If $result = 0 Or $result = 1 Then Return 1
	Local $sText1, $sText2, $MsgBox
	$sText1 = "Hey Chief, your AutoIt version is out of date!"
	$sText3 = "Click OK to download the latest version of AutoIt."
	$sText2 = "The bot requires AutoIt version "&$requiredAutoit&" or above. Your version of AutoIt is "&@AutoItVersion&"." & @CRLF & $sText3 & @CRLF &"After installing the new version, open the bot again."
	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
	$MsgBox = _ExtMsgBox(48, "OK|Cancel", $sText1, $sText2, 0, $frmBot)
	If $MsgBox = 1 Then ShellExecute("https://www.autoitscript.com/site/autoit/downloads/")
	Return 0
EndFunc

