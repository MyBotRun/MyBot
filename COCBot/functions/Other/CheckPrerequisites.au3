; #FUNCTION# ====================================================================================================================
; Name ..........: CheckPrerequisites
; Description ...:
; Syntax ........: CheckPrerequisites()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: Heridero, Zengzeng (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CheckPrerequisites($bSilent = False)
	Local $isAllOK = True
	;Local $isNetFramework4Installed = isNetFramework4Installed()
	Local $isNetFramework4dot5Installed = isNetFramework4dot5Installed()
	Local $isVC2010Installed = isVC2010Installed()
	If ($isNetFramework4dot5Installed = False Or $isVC2010Installed = False) Then
		#cs
			If ($isNetFramework4Installed = False And Not $bSilent) Then
			SetLog("The .Net Framework 4.0 is not installed", $COLOR_ERROR)
			SetLog("Please download here : https://www.microsoft.com/en-US/download/details.aspx?id=17718", $COLOR_ERROR)
			EndIf
		#ce
		If ($isNetFramework4dot5Installed = False And Not $bSilent) Then
			SetLog("The .Net Framework 4.5 is not installed", $COLOR_ERROR)
			SetLog("Please download here : https://www.microsoft.com/en-US/download/details.aspx?id=30653", $COLOR_ERROR)
		EndIf
		If ($isVC2010Installed = False And Not $bSilent) Then
			SetLog("The VC 2010 x86 is not installed", $COLOR_ERROR)
			SetLog("Please download here : https://www.microsoft.com/en-US/download/details.aspx?id=5555", $COLOR_ERROR)
		EndIf
		$isAllOK = False
	EndIf
	If isEveryFileInstalled($bSilent) = False Then $isAllOK = False
	If Not checkAutoitVersion($bSilent) Then $isAllOK = False
	checkIsAdmin($bSilent)

	If @DesktopHeight <= 768 Then
		Opt('WinTitleMatchMode', 4)
		Local $pos = ControlGetPos("classname=Shell_TrayWnd", "", "")
		If Not @error Then
			If $pos[2] > $pos[3] And Int($pos[3]) + 732 > 768 Then
				SetLog("Display: " & @DesktopWidth & "," & @DesktopHeight, $COLOR_ERROR)
				SetLog("Windows TaskBar: " & $pos[2] & "," & $pos[3], $COLOR_ERROR)
				SetLog("Emulator[732] and taskbar[" & $pos[3] & "] doesn't fit on your display!", $COLOR_ERROR)
				SetLog("Please set your Windows taskbar location to Right!", $COLOR_ERROR)
				;$isAllOK = False
			EndIf
		EndIf
		Opt('WinTitleMatchMode', 3)
	EndIf

	If $isAllOK = False And Not $bSilent Then
		GUICtrlSetState($g_hBtnStart, $GUI_DISABLE)
		$g_bRestarted = False
	EndIf

	Return $isAllOK
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
	Local $hDll = DllOpen("msvcp100.dll")
	Local $success = $hDll <> -1
	If $success = False Then Return $success
	DllClose($hDll)
	_WinAPI_FreeLibrary($hDll)
	Return $success
EndFunc   ;==>isVC2010Installed

Func isEveryFileInstalled($bSilent = False)
	Local $bResult = False, $iCount = 0

	; folders and files needed checking
	Local $aCheckFiles = [@ScriptDir & "\COCBot", _
			$g_sLibPath, _
			@ScriptDir & "\Images", _
			@ScriptDir & "\imgxml", _
			$g_sLibPath & "\helper_functions.dll", _
			$g_sLibPath & "\ImageSearchDLL.dll", _
			$g_sLibPath & "\MBRBot.dll", _
			$g_sLibPath & "\MyBot.run.dll", _
			$g_sLibPath & "\sqlite3.dll", _
			$g_sLibPath & "\opencv_core220.dll", _
			$g_sLibPath & "\opencv_imgproc220.dll"]

	For $vElement In $aCheckFiles
		$iCount += FileExists($vElement)
	Next
	; How many .xml files in imgxml folder
	Local $xmls = _FileListToArrayRec(@ScriptDir & "\imgxml\", "*.xml", $FLTAR_FILES + $FLTAR_NOHIDDEN, $FLTAR_RECUR, $FLTAR_NOSORT)
	If IsArray($xmls) Then
		If Number($xmls[0]) < 570 Then SetLog("Verify '\imgxml\' folder, found " & $xmls[0] & " *.xml files.", $COLOR_ERROR)
	EndIf

	If $iCount = UBound($aCheckFiles) Then
		$bResult = True
	ElseIf Not $bSilent Then
		GUICtrlSetState($g_hBtnStart, $GUI_DISABLE)

		Local $sText1 = "", $sText2 = "", $sText3 = "", $MsgBox = 0
		$sText1 = GetTranslatedFileIni("MBR Popups", "CheckPrerequisites_Item_01", "Hey Chief, we are missing some files!")
		$sText2 = GetTranslatedFileIni("MBR Popups", "CheckPrerequisites_Item_02", "Please extract all files and folders and start this program again!")
		$sText3 = GetTranslatedFileIni("MBR Popups", "CheckPrerequisites_Item_03", "Sorry, Start button disabled until fixed!")

		SetLog($sText1, $COLOR_ERROR)
		SetLog($sText2, $COLOR_ERROR)
		SetLog($sText3, $COLOR_ERROR)

		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), $sText1, $sText2, 0)
		GUICtrlSetState($g_hBtnStart, $GUI_DISABLE)
	EndIf
	If @Compiled Then ;if .exe
		If Not StringInStr(@ScriptFullPath, "MyBot.run.exe", 1) Then ; if filename isn't MyBot.run.exe
			If Not $bSilent Then
				Local $sText1, $sText2, $MsgBox
				$sText1 = GetTranslatedFileIni("MBR Popups", "CheckPrerequisites_Item_04", "Hey Chief, file name incorrect!")
				$sText2 = GetTranslatedFileIni("MBR Popups", "CheckPrerequisites_Item_05", 'You have renamed the file "MyBot.run.exe"! Please change it back to MyBot.run.exe and restart the bot!')
				$sText3 = GetTranslatedFileIni("MBR Popups", "CheckPrerequisites_Item_03", "Sorry, Start button disabled until fixed!")

				SetLog($sText1, $COLOR_ERROR)
				SetLog($sText2, $COLOR_ERROR)
				SetLog($sText3, $COLOR_ERROR)

				_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
				$MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), $sText1, $sText2, 0)
				GUICtrlSetState($g_hBtnStart, $GUI_DISABLE)
			EndIf
			$bResult = False
		EndIf
	EndIf
	Return $bResult
EndFunc   ;==>isEveryFileInstalled

Func checkAutoitVersion($bSilent = False)
	If @Compiled = True Then Return 1
	Local $requiredAutoit = "3.3.14.2"
	Local $result = _VersionCompare(@AutoItVersion, $requiredAutoit)
	If $result = 0 Or $result = 1 Then Return 1
	If Not $bSilent Then
		Local $sText1 = "Hey Chief, your AutoIt version is out of date!"
		Local $sText3 = "Click OK to download the latest version of AutoIt."
		Local $sText2 = "The bot requires AutoIt version " & $requiredAutoit & " or above. Your version of AutoIt is " & @AutoItVersion & "." & @CRLF & $sText3 & @CRLF & "After installing the new version, open the bot again."
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		Local $MsgBox = _ExtMsgBox(48, "OK|Cancel", $sText1, $sText2, 0)
		If $MsgBox = 1 Then ShellExecute("https://www.autoitscript.com/site/autoit/downloads/")
	EndIf
	Return 0
EndFunc   ;==>checkAutoitVersion

Func checkIsAdmin($bSilent = False)
	If IsAdmin() Then Return True
	If Not $bSilent Then SetLog("My Bot running without admin privileges", $COLOR_ERROR)
	Return False
EndFunc   ;==>checkIsAdmin

