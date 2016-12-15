; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Android
; Description ...: This file Includes all functions to current GUI
; Syntax ........: None
; Parameters ....:
; Return values .: None
; Author ........: MMHK (11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func LoadCOCDistributorsComboBox()
	Local $sDistributors = $NO_COC
	Local $aDistributorsData = GetCOCDistributors()

	If @error = 2 Then
		$sDistributors = $UNKNOWN_COC
	ElseIf IsArray($aDistributorsData) Then
		$sDistributors = _ArrayToString($aDistributorsData, "|")
	EndIf

	GUICtrlSetData($cmbCOCdistributors, "", "")
	GUICtrlSetData($cmbCOCdistributors, $sDistributors)
EndFunc   ;==>LoadCOCdistributorsComboBox

Func SetCurSelCmbCOCDistributors()
	Local $sIniDistributor
	Local $iIndex
	If _GUICtrlComboBox_GetCount($cmbCOCdistributors) = 1 Then ; when no/unknown/one coc installed
		_GUICtrlComboBox_SetCurSel($cmbCOCdistributors, 0)
		GUICtrlSetState($cmbCOCdistributors, $GUI_DISABLE)
	Else
		$sIniDistributor = GetCOCTranslated($AndroidGameDistributor)
		$iIndex = _GUICtrlComboBox_FindStringExact($cmbCOCdistributors, $sIniDistributor)
		If $iIndex = -1 Then ; not found on combo
			_GUICtrlComboBox_SetCurSel($cmbCOCdistributors, 0)
		Else
			_GUICtrlComboBox_SetCurSel($cmbCOCdistributors, $iIndex)
		EndIf
		GUICtrlSetState($cmbCOCdistributors, $GUI_ENABLE)
	EndIf
EndFunc   ;==>setCurSelCmbCOCDistributors

Func cmbCOCDistributors()
	Local $sDistributor
    _GUICtrlComboBox_GetLBText($cmbCOCdistributors, _GUICtrlComboBox_GetCurSel($cmbCOCdistributors), $sDistributor)

	If $sDistributor = $UserGameDistributor Then ; ini user option
		$AndroidGameDistributor = $UserGameDistributor
		$AndroidGamePackage = $UserGamePackage
		$AndroidGameClass = $UserGameClass
	Else
		GetCOCUnTranslated($sDistributor)
		If Not @error Then ; not no/unknown
			$AndroidGameDistributor = GetCOCUnTranslated($sDistributor)
			$AndroidGamePackage = GetCOCPackage($sDistributor)
			$AndroidGameClass = GetCOCClass($sDistributor)
		EndIf ; else existing one (no emulator bot startup compatible), if wrong ini info either kept or replaced by cursel when saveconfig, not fall back to google
	EndIf
EndFunc   ;==>cmbCOCDistributors

Func DistributorsBotStopEvent()
	LoadCOCDistributorsComboBox()
	SetCurSelCmbCOCDistributors()
EndFunc   ;==>DistributorsBotStopEvent
