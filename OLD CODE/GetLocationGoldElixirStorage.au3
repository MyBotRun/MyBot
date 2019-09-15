; Functions replaced by GetLocationBuilding

Func GetLocationGoldStorage()

	Local $hTimer = __TimerInit()

	; Variables
	Local $directory = @ScriptDir & "\imgxml\Storages\Gold"
	Local $TempVectStr
	Local $TotalStorages = 0
	Local $TotalObjects = 0
	Local $GoldStorageXY
	Local $maxReturnPoints = 4
	Local $redLines = ""
	Local $minLevel = 0
	Local $maxLevel = 12
	Local $statFile = ""
	If $g_bDebugSetlog Then SetDebugLog("Started the function | GetLocationGoldStorage")

	; Performing the search
	Local $aResult = returnMultipleMatches($directory, $maxReturnPoints, $redLines, $statFile, $minLevel, $maxLevel)
	; Take the results and fill the variable $TempVectStr
	If UBound($aResult) > 1 Then
		For $i = 1 To UBound($aResult) - 1
			Local $Filename = $aResult[$i][1] ; Filename
			$TotalObjects = $aResult[$i][4] ; Total of Objects from the same FileName
			$GoldStorageXY = $aResult[$i][5] ; Coords
			If IsArray($GoldStorageXY) And $TotalObjects > 0 Then
				For $t = 0 To UBound($GoldStorageXY) - 1 ; each filename can have several positions
					If $g_bDebugSetlog Then SetDebugLog($Filename & " found (" & $GoldStorageXY[$t][0] & "," & $GoldStorageXY[$t][1] & ")", $COLOR_SUCCESS)
					$TempVectStr &= $GoldStorageXY[$t][0] & "-" & $GoldStorageXY[$t][1] & "|"
					$TotalStorages += 1
					If $TotalStorages >= 4 Then ExitLoop (2)
				Next
			EndIf
		Next
	EndIf

	If $g_bDebugSetlog Then SetDebugLog("  - Calculated  in: " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_DEBUG)

	If StringLen($TempVectStr) > 0 Then
		$TempVectStr = StringLeft($TempVectStr, StringLen($TempVectStr) - 1)
		If $g_bDebugGetLocation Then DebugImageGetLocation($TempVectStr, "GoldStorage")
		Local $InputVect = GetListPixel($TempVectStr)
		SetLog("Total Gold Storages :" & $TotalStorages)
		Return $InputVect
	Else
		Return 0
	EndIf

EndFunc   ;==>GetLocationGoldStorage

Func GetLocationElixirStorage()

	Local $hTimer = __TimerInit()
	; Variables
	Local $directory = @ScriptDir & "\imgxml\Storages\Elixir"
	Local $TempVectStr
	Local $TotalStorages = 0
	Local $TotalObjects = 0
	Local $ElixirStorageXY
	Local $maxReturnPoints = 4
	Local $redLines = ""
	Local $minLevel = 0
	Local $maxLevel = 12
	Local $statFile = ""
	If $g_bDebugSetlog Then SetDebugLog("Started the function | GetLocationElixirStorage")

	; Performing the search
	Local $aResult = returnMultipleMatches($directory, $maxReturnPoints, $redLines, $statFile, $minLevel, $maxLevel)
	; Take the results and fill the variable $TempVectStr
	If UBound($aResult) > 1 Then
		For $i = 1 To UBound($aResult) - 1
			Local $Filename = $aResult[$i][1] ; Filename
			$TotalObjects = $aResult[$i][4] ; Total of Objects from the same FileName
			$ElixirStorageXY = $aResult[$i][5] ; Coords
			If IsArray($ElixirStorageXY) And $TotalObjects > 0 Then
				For $t = 0 To UBound($ElixirStorageXY) - 1 ; each filename can have several positions
					If $g_bDebugSetlog Then SetDebugLog($Filename & " found (" & $ElixirStorageXY[$t][0] & "," & $ElixirStorageXY[$t][1] & ")", $COLOR_SUCCESS)
					$TempVectStr &= $ElixirStorageXY[$t][0] & "-" & $ElixirStorageXY[$t][1] & "|"
					$TotalStorages += 1
					If $TotalStorages >= 4 Then ExitLoop (2)
				Next
			EndIf
		Next
	EndIf

	If $g_bDebugSetlog Then SetDebugLog("  - Calculated  in: " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_DEBUG)

	If StringLen($TempVectStr) > 0 Then
		$TempVectStr = StringLeft($TempVectStr, StringLen($TempVectStr) - 1)
		Local $InputVect = GetListPixel($TempVectStr)
		SetLog("Total Elixirr Storages :" & $TotalStorages)
		If $g_bDebugGetLocation Then DebugImageGetLocation($TempVectStr, "ElixirStorage")
		Return $InputVect
	Else
		Return 0
	EndIf

EndFunc   ;==>GetLocationElixirStorage