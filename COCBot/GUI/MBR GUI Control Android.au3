; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Android
; Description ...: This file Includes all functions to current GUI
; Syntax ........: None
; Parameters ....:
; Return values .: None
; Author ........: MMHK (11-2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func LoadCOCDistributorsComboBox()
	Local $sDistributors = $g_sNO_COC
	Local $aDistributorsData = GetCOCDistributors()

	If @error = 2 Then
		$sDistributors = $g_sUNKNOWN_COC
	ElseIf IsArray($aDistributorsData) Then
		$sDistributors = _ArrayToString($aDistributorsData, "|")
	EndIf

	GUICtrlSetData($g_hCmbCOCDistributors, "", "")
	GUICtrlSetData($g_hCmbCOCDistributors, $sDistributors)
EndFunc   ;==>LoadCOCDistributorsComboBox

Func SetCurSelCmbCOCDistributors()
	Local $sIniDistributor
	Local $iIndex
	If _GUICtrlComboBox_GetCount($g_hCmbCOCDistributors) = 1 Then ; when no/unknown/one coc installed
		_GUICtrlComboBox_SetCurSel($g_hCmbCOCDistributors, 0)
		GUICtrlSetState($g_hCmbCOCDistributors, $GUI_DISABLE)
	Else
		$sIniDistributor = GetCOCTranslated($g_sAndroidGameDistributor)
		$iIndex = _GUICtrlComboBox_FindStringExact($g_hCmbCOCDistributors, $sIniDistributor)
		If $iIndex = -1 Then ; not found on combo
			_GUICtrlComboBox_SetCurSel($g_hCmbCOCDistributors, 0)
		Else
			_GUICtrlComboBox_SetCurSel($g_hCmbCOCDistributors, $iIndex)
		EndIf
		GUICtrlSetState($g_hCmbCOCDistributors, $GUI_ENABLE)
	EndIf
EndFunc   ;==>SetCurSelCmbCOCDistributors

Func cmbCOCDistributors()
	Local $sDistributor
	_GUICtrlComboBox_GetLBText($g_hCmbCOCDistributors, _GUICtrlComboBox_GetCurSel($g_hCmbCOCDistributors), $sDistributor)

	If $sDistributor = $g_sUserGameDistributor Then ; ini user option
		$g_sAndroidGameDistributor = $g_sUserGameDistributor
		$g_sAndroidGamePackage = $g_sUserGamePackage
		$g_sAndroidGameClass = $g_sUserGameClass
	Else
		GetCOCUnTranslated($sDistributor)
		If Not @error Then ; not no/unknown
			$g_sAndroidGameDistributor = GetCOCUnTranslated($sDistributor)
			$g_sAndroidGamePackage = GetCOCPackage($sDistributor)
			$g_sAndroidGameClass = GetCOCClass($sDistributor)
		EndIf ; else existing one (no emulator bot startup compatible), if wrong ini info either kept or replaced by cursel when saveconfig, not fall back to google
	EndIf
EndFunc   ;==>cmbCOCDistributors

Func DistributorsUpdateGUI()
	LoadCOCDistributorsComboBox()
	SetCurSelCmbCOCDistributors()
EndFunc   ;==>DistributorsUpdateGUI

Func AndroidSuspendFlagsToIndex($iFlags)
	Local $idx = 0
	If BitAND($iFlags, 2) > 0 Then
		$idx = 2
	ElseIf BitAND($iFlags, 1) > 0 Then
		$idx = 1
	EndIf
	If $idx > 0 And BitAND($iFlags, 4) > 0 Then $idx += 2
	Return $idx
EndFunc   ;==>AndroidSuspendFlagsToIndex

Func AndroidSuspendIndexToFlags($idx)
	Local $iFlags = 0
	Switch $idx
		Case 1
			$iFlags = 1
		Case 2
			$iFlags = 2
		Case 3
			$iFlags = 1 + 4
		Case 4
			$iFlags = 2 + 4
	EndSwitch
	Return $iFlags
EndFunc   ;==>AndroidSuspendIndexToFlags

Func cmbSuspendAndroid()
	$g_iAndroidSuspendModeFlags = AndroidSuspendIndexToFlags(_GUICtrlComboBox_GetCurSel($g_hCmbSuspendAndroid))
EndFunc   ;==>cmbSuspendAndroid

Func cmbAndroidBackgroundMode()
	$g_iAndroidBackgroundMode = _GUICtrlComboBox_GetCurSel($g_hCmbAndroidBackgroundMode)
	UpdateAndroidBackgroundMode()
EndFunc   ;==>cmbAndroidBackgroundMode

Func EnableShowTouchs()
	AndroidAdbSendShellCommand("content insert --uri content://settings/system --bind name:s:show_touches --bind value:i:1")
	SetDebugLog("EnableShowTouchs ON")
EndFunc   ;==>EnableShowTouchs

Func DisableShowTouchs()
	AndroidAdbSendShellCommand("content insert --uri content://settings/system --bind name:s:show_touches --bind value:i:0")
	SetDebugLog("EnableShowTouchs OFF")
EndFunc   ;==>DisableShowTouchs

Func sldAdditionalClickDelay($bSetControls = False)
	If $bSetControls Then
		GUICtrlSetData($g_hSldAdditionalClickDelay, Int($g_iAndroidControlClickAdditionalDelay / 2))
		GUICtrlSetData($g_hLblAdditionalClickDelay, $g_iAndroidControlClickAdditionalDelay & " ms")
	Else
		Local $iValue = GUICtrlRead($g_hSldAdditionalClickDelay) * 2
		If $iValue <> $g_iAndroidControlClickAdditionalDelay Then
			$g_iAndroidControlClickAdditionalDelay = $iValue
			GUICtrlSetData($g_hLblAdditionalClickDelay, $g_iAndroidControlClickAdditionalDelay & " ms")
		EndIf
	EndIf
	Opt("MouseClickDelay", GetClickUpDelay()) ;Default: 10 milliseconds
	Opt("MouseClickDownDelay", GetClickDownDelay()) ;Default: 5 milliseconds
EndFunc   ;==>sldAdditionalClickDelay

Func cmbAndroidEmulator()
	getAllEmulatorsInstances()
	Local $Emulator = GUICtrlRead($g_hCmbAndroidEmulator)
	If MsgBox($MB_YESNO, "Emulator Selection", $Emulator & ", Is correct?" & @CRLF & "Any mistake and your profile will be not useful!" & @CRLF & "If 'yes' and your instance is OK, is necessary " & @CRLF & "REBOOT the 'bot'.", 10) = $IDYES Then
		SetLog("Emulator " & $Emulator & " Selected. Please select an Instance.")
		$g_sAndroidEmulator = $Emulator
		$g_sAndroidInstance = GUICtrlRead($g_hCmbAndroidInstance)
		BtnSaveprofile()
	Else
		_GUICtrlComboBox_SelectString($g_hCmbAndroidEmulator, $g_sAndroidEmulator)
		getAllEmulatorsInstances()
	EndIf
EndFunc   ;==>cmbAndroidEmulator

Func cmbAndroidInstance()
	Local $Instance = GUICtrlRead($g_hCmbAndroidInstance)
	If MsgBox($MB_YESNO, "Instance Selection", $Instance & ", Is correct?" & @CRLF & "If 'yes' is necessary REBOOT the 'bot'.", 10) = $IDYES Then
		SetLog("Instance " & $Instance & " Selected.")
		$g_sAndroidInstance = $Instance
		BtnSaveprofile()
	Else
		getAllEmulatorsInstances()
	EndIf
EndFunc   ;==>cmbAndroidInstance

Func getAllEmulators()

	; Initial Var with all emulators , will populate the ComboBox UI
	Local $sEmulatorString = ""

	; Reset content , Emulator ComboBox var
	GUICtrlSetData($g_hCmbAndroidEmulator, '')

	; Bluestacks :
	$__BlueStacks_Version = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\", "Version")
	If Not @error Then
		If GetVersionNormalized($__BlueStacks_Version) < GetVersionNormalized("0.10") Then $sEmulatorString &= "BlueStacks|"
		If GetVersionNormalized($__BlueStacks_Version) > GetVersionNormalized("1.0") Then $sEmulatorString &= "BlueStacks2|"
	EndIf

	; Nox :
	Local $NoxEmulator = GetNoxPath()
	If FileExists($NoxEmulator) Then $sEmulatorString &= "Nox|"

	; Memu :
	Local $MEmuEmulator = GetMEmuPath()
	If FileExists($MEmuEmulator) Then $sEmulatorString &= "MEmu|"

	; iTools
	Local $iToolsEmulator = GetiToolsPath()
	If FileExists($iToolsEmulator) Then $sEmulatorString &= "iTools|"

	Local $sResult = StringRight($sEmulatorString, 1)
	If $sResult == "|" Then $sEmulatorString = StringTrimRight($sEmulatorString, 1)
	If $sEmulatorString <> "" Then
		Setlog("All Emulator found in your machine: " & $sEmulatorString)
	Else
		Setlog("No Emulator found in your machine")
		Return
	EndIf

	GUICtrlSetData($g_hCmbAndroidEmulator, $sEmulatorString)

	; $g_sAndroidEmulator Cosote Var to store the Emulator
	_GUICtrlComboBox_SelectString($g_hCmbAndroidEmulator, $g_sAndroidEmulator)

	; Lets get all Instances
	getAllEmulatorsInstances()
EndFunc   ;==>getAllEmulators

Func getAllEmulatorsInstances()

	; Reset content, Instance ComboBox var
	GUICtrlSetData($g_hCmbAndroidInstance, '')

	; Get all Instances from SELECTED EMULATOR - $g_hCmbAndroidEmulator is the Emulator ComboBox
	Local $Emulator = GUICtrlRead($g_hCmbAndroidEmulator)
	Local $sEmulatorPath = 0

	Switch $Emulator
		Case "BlueStacks"
			GUICtrlSetData($g_hCmbAndroidInstance, "Android", "Android")
			Return
		Case "BlueStacks2"
			Local $VMsBlueStacks = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\", "DataDir")
			$sEmulatorPath = $VMsBlueStacks ; C:\ProgramData\BlueStacks\Engine
		Case "Nox"
			$sEmulatorPath = GetNoxPath() & "\BignoxVMS"  ; C:\Program Files\Nox\bin\BignoxVMS
		Case "MEmu"
			$sEmulatorPath = GetMEmuPath() & "\MemuHyperv VMs"  ; C:\Program Files\Microvirt\MEmu\MemuHyperv VMs
		Case "iTools"
			$sEmulatorPath = GetiToolsPath() & "\Repos\VMs"  ; C:\Program Files (x86)\ThinkSky\iToolsAVM\Repos\VMs
	EndSwitch

	; Just in case
	$sEmulatorPath = StringReplace($sEmulatorPath, "\\", "\")

	; BS Multi Instance
	Local $sBlueStacksFolder = ""
	If $Emulator = "BlueStacks2" Then $sBlueStacksFolder = "Android"

	; Getting all VM Folders
	Local $aEmulatorFolders = _FileListToArray($sEmulatorPath, $sBlueStacksFolder & "*", $FLTA_FOLDERS)
	If @error = 1 Then
		Setlog($Emulator & " -- Path was invalid. " & $sEmulatorPath)
		Return
	EndIf
	If @error = 4 Then
		Setlog($Emulator & " -- No file(s) were found. " & $sEmulatorPath)
		Return
	EndIf

	; Removing the [0] -> $aArray[0] = Number of Files\Folders returned
	_ArrayDelete($aEmulatorFolders, 0)

	; Populating the Instance ComboBox var
	GUICtrlSetData($g_hCmbAndroidInstance, _ArrayToString($aEmulatorFolders))

	If $Emulator == $g_sAndroidEmulator Then
		_GUICtrlComboBox_SelectString($g_hCmbAndroidInstance, $g_sAndroidInstance)
	Else
		_GUICtrlComboBox_SetCurSel($g_hCmbAndroidInstance, 0)
	EndIf
EndFunc   ;==>getAllEmulatorsInstances