; #FUNCTION# ====================================================================================================================
; Name ..........: profileFunctions.au3
; Description ...: Functions for the new profile system
; Author ........: LunaEclipse(February, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================

Func setupProfileComboBox()
	; Array to store Profile names to add to ComboBox
	Local $profileString = ""
	Local $aProfiles = _FileListToArray($g_sProfilePath, "*", $FLTA_FOLDERS)
	If @error Then
		; No folders for profiles so lets set the combo box to a generic entry
		$profileString = "<No Profiles>"
	Else
		; Lets create a new array without the first entry which is a count for populating the combo box
		Local $aProfileList[$aProfiles[0]]
		For $i = 1 To $aProfiles[0]
			$aProfileList[$i - 1] = $aProfiles[$i]
		Next

		; Convert the array into a string
		$profileString = _ArrayToString($aProfileList, "|")
	EndIf

	; Clear the combo box current data in case profiles were deleted
	GUICtrlSetData($g_hCmbProfile, "", "")
	; Set the new data of available profiles
	GUICtrlSetData($g_hCmbProfile, $profileString, "<No Profiles>")
EndFunc   ;==>setupProfileComboBox

Func renameProfile()
	Local $originalPath = $g_sProfilePath & "\" & GUICtrlRead($g_hCmbProfile)
	Local $newPath = $g_sProfilePath & "\" & $g_sProfileCurrentName
	If FileExists($originalPath) Then
		; Close the logs to ensure all files can be deleted.
	   If $g_hLogFile <> 0 Then
		  FileClose($g_hLogFile)
		  $g_hLogFile = 0
	   EndIf

	   If $g_hAttackLogFile <> 0 Then
		  FileClose($g_hAttackLogFile)
		  $g_hAttackLogFile = 0
	   EndIf

		; Remove the directory and all files and sub folders.
		DirMove($originalPath, $newPath, $FC_NOOVERWRITE)
	EndIf
EndFunc   ;==>renameProfile

Func deleteProfile()
	Local $sProfile = GUICtrlRead($g_hCmbProfile)
	Local $deletePath = $g_sProfilePath & "\" & $sProfile
	If FileExists($deletePath) Then
		If $sProfile = $g_sProfileCurrentName Then
			; Close the logs to ensure all files can be deleted.
			 If $g_hLogFile <> 0 Then
				FileClose($g_hLogFile)
				$g_hLogFile = 0
			 EndIf

			 If $g_hAttackLogFile <> 0 Then
				FileClose($g_hAttackLogFile)
				$g_hAttackLogFile = 0
			 EndIf
		EndIf
		; Remove the directory and all files and sub folders.
		DirRemove($deletePath, $DIR_REMOVE)
	EndIf
EndFunc   ;==>deleteProfile

Func createProfile($bCreateNew = False)

	If $bCreateNew = True Then
		; create new profile (recursive call from setupProfile() and selectProfile() !!!)
		setupProfileComboBox()
		setupProfile()
		saveConfig()
		; applyConfig()
		setupProfileComboBox()
		selectProfile()
		Return
	EndIf

	; create the profile directory if it doesn't already exist.
	DirCreate($g_sProfilePath & "\" & $g_sProfileCurrentName)

	; If the Profiles file does not exist create it.
	If Not FileExists($g_sProfilePath & "\profile.ini") Then
		Local $hFile = FileOpen($g_sProfilePath & "\profile.ini", $FO_APPEND + $FO_CREATEPATH)
		FileWriteLine($hFile, "[general]")
		FileClose($hFile)
	EndIf

	; Set the current profile as the default profile.
	IniWrite($g_sProfilePath & "\profile.ini", "general", "defaultprofile", $g_sProfileCurrentName)
	SetupProfileFolder()
	; Create the profiles sub-folders
	DirCreate($g_sProfileLogsPath)
	DirCreate($g_sProfileLootsPath)
	DirCreate($g_sProfileTempPath)
	DirCreate($g_sProfileTempDebugPath)
	DirCreate($g_sProfileDonateCapturePath)
	DirCreate($g_sProfileDonateCaptureWhitelistPath)
	DirCreate($g_sProfileDonateCaptureBlacklistPath)

	If FileExists($g_sProfileConfigPath) = 0 Then SetLog("New Profile '" & $g_sProfileCurrentName & "' created")
EndFunc   ;==>createProfile

Func setupProfile()
	If GUICtrlRead($g_hCmbProfile) = "<No Profiles>" Then
		; Set profile name to the text box value if no profiles are found.
		$g_sProfileCurrentName = StringRegExpReplace(GUICtrlRead($g_hTxtVillageName), '[/:*?"<>|]', '_')
	Else
		$g_sProfileCurrentName = GUICtrlRead($g_hCmbProfile)
	EndIf

	; Create the profile if needed, this also sets the variables if the profile exists.
	createProfile()
	; Set the profile name on the village info group.
	GUICtrlSetData($g_hGrpVillage, GetTranslated(603, 32, "Village") & ": " & $g_sProfileCurrentName)
	GUICtrlSetData($g_hTxtNotifyOrigin, $g_sProfileCurrentName)
EndFunc   ;==>setupProfile

Func selectProfile()
	If _GUICtrlComboBox_FindStringExact($g_hCmbProfile, String($g_sProfileCurrentName)) <> -1 Then
		_GUICtrlComboBox_SelectString($g_hCmbProfile, String($g_sProfileCurrentName))
	Else
		Local $comboBoxArray = _GUICtrlComboBox_GetListArray($g_hCmbProfile)
		$g_sProfileCurrentName = $comboBoxArray[1]

		; Create the profile if needed, this also sets the variables if the profile exists.
		createProfile()
		readConfig()
		applyConfig()

		_GUICtrlComboBox_SetCurSel($g_hCmbProfile, 0)
	EndIf

	; Set the profile name on the village info group.
	GUICtrlSetData($g_hGrpVillage, GetTranslated(603, 32, "Village") & ": " & $g_sProfileCurrentName)
	GUICtrlSetData($g_hTxtNotifyOrigin, $g_sProfileCurrentName)
EndFunc   ;==>selectProfile
