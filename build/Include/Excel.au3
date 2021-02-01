#include-once
#include <Array.au3>
#include <ExcelConstants.au3>

; #INDEX# =======================================================================================================================
; Title .........: Microsoft Excel Function Library
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: A collection of functions for accessing and manipulating Microsoft Excel files
; Author(s) .....: SEO (Locodarwin), DaLiMan, Stanley Lim, MikeOsdx, MRDev, big_daddy, PsaltyDS, litlmike, water, spiff59, golfinhu, bowmore, GMX, Andreu, danwilli
; Resources .....:
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _Excel_Open
; _Excel_Close
; _Excel_BookAttach
; _Excel_BookClose
; _Excel_BookList
; _Excel_BookNew
; _Excel_BookOpen
; _Excel_BookOpenText
; _Excel_BookSave
; _Excel_BookSaveAs
; _Excel_ColumnToLetter
; _Excel_ColumnToNumber
; _Excel_ConvertFormula
; _Excel_Export
; _Excel_FilterGet
; _Excel_FilterSet
; _Excel_PictureAdd
; _Excel_Print
; _Excel_RangeCopyPaste
; _Excel_RangeDelete
; _Excel_RangeFind
; _Excel_RangeInsert
; _Excel_RangeLinkAddRemove
; _Excel_RangeRead
; _Excel_RangeReplace
; _Excel_RangeSort
; _Excel_RangeValidate
; _Excel_RangeWrite
; _Excel_SheetAdd
; _Excel_SheetCopyMove
; _Excel_SheetDelete
; _Excel_SheetList
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; __Excel_CloseOnQuit
; __Excel_COMErrFunc
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified ......:
; ===============================================================================================================================
Func _Excel_Open($bVisible = Default, $bDisplayAlerts = Default, $bScreenUpdating = Default, $bInteractive = Default, $bForceNew = Default)
	Local $oExcel, $bApplCloseOnQuit = False
	If $bVisible = Default Then $bVisible = True
	If $bDisplayAlerts = Default Then $bDisplayAlerts = False
	If $bScreenUpdating = Default Then $bScreenUpdating = True
	If $bInteractive = Default Then $bInteractive = True
	If $bForceNew = Default Then $bForceNew = False
	If Not $bForceNew Then $oExcel = ObjGet("", "Excel.Application")
	If $bForceNew Or @error Then
		$oExcel = ObjCreate("Excel.Application")
		If @error Or Not IsObj($oExcel) Then Return SetError(1, @error, 0)
		$bApplCloseOnQuit = True
	EndIf
	__Excel_CloseOnQuit($oExcel, $bApplCloseOnQuit)
	$oExcel.Visible = $bVisible
	$oExcel.DisplayAlerts = $bDisplayAlerts
	$oExcel.ScreenUpdating = $bScreenUpdating
	$oExcel.Interactive = $bInteractive
	Return SetError(0, $bApplCloseOnQuit, $oExcel)
EndFunc   ;==>_Excel_Open

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified ......:
; ===============================================================================================================================
Func _Excel_Close(ByRef $oExcel, $bSaveChanges = Default, $bForceClose = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If $bSaveChanges = Default Then $bSaveChanges = True
	If $bForceClose = Default Then $bForceClose = False
	If Not IsObj($oExcel) Or ObjName($oExcel, 1) <> "_Application" Then Return SetError(1, 0, 0)
	If $bSaveChanges Then
		For $oWorkbook In $oExcel.Workbooks
			If Not $oWorkbook.Saved Then
				$oWorkbook.Save()
				If @error Then Return SetError(3, @error, 0)
			EndIf
		Next
	EndIf
	If __Excel_CloseOnQuit($oExcel) Or $bForceClose Then
		$oExcel.Quit()
		If @error Then Return SetError(2, @error, 0)
		__Excel_CloseOnQuit($oExcel, False)
		$oExcel = 0
	EndIf
	Return 1
EndFunc   ;==>_Excel_Close

; #FUNCTION# ====================================================================================================================
; Author ........: Bob Anthony (big_daddy)
; Modified.......: water
; ===============================================================================================================================
Func _Excel_BookAttach($sString, $sMode = Default, $oInstance = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	Local $oWorkbook, $iCount = 0, $sCLSID_Workbook = "{00020819-0000-0000-C000-000000000046}" ; Microsoft.Office.Interop.Excel.WorkbookClass
	If $sMode = Default Then $sMode = "FilePath"
	While True
		$oWorkbook = ObjGet("", $sCLSID_Workbook, $iCount + 1)
		If @error Then Return SetError(1, @error, 0)
		If $oInstance <> Default And $oInstance <> $oWorkbook.Parent Then ContinueLoop
		Switch $sMode
			Case "filename"
				If $oWorkbook.Name = $sString Then Return $oWorkbook
			Case "filepath"
				If $oWorkbook.FullName = $sString Then Return $oWorkbook
			Case "title"
				If $oWorkbook.Application.Caption = $sString Then Return $oWorkbook
			Case Else
				Return SetError(2, 0, 0)
		EndSwitch
		$iCount += 1
	WEnd
EndFunc   ;==>_Excel_BookAttach

; #FUNCTION# ====================================================================================================================
; Author ........: SEO <locodarwin at yahoo dot com>
; Modified.......: big_daddy, litlmike, water
; ===============================================================================================================================
Func _Excel_BookClose(ByRef $oWorkbook, $bSave = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If $bSave = Default Then $bSave = True
	If $bSave And Not $oWorkbook.Saved Then
		$oWorkbook.Save()
		If @error Then Return SetError(2, @error, 0)
	EndIf
	$oWorkbook.Close()
	If @error Then Return SetError(3, @error, 0)
	$oWorkbook = 0
	Return 1
EndFunc   ;==>_Excel_BookClose

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified.......:
; ===============================================================================================================================
Func _Excel_BookList($oExcel = Default)
	Local $aBooks[1][3], $iIndex = 0
	If IsObj($oExcel) Then
		If ObjName($oExcel, 1) <> "_Application" Then Return SetError(1, 0, 0)
		Local $iTemp = $oExcel.Workbooks.Count
		ReDim $aBooks[$iTemp][3]
		For $iIndex = 0 To $iTemp - 1
			$aBooks[$iIndex][0] = $oExcel.Workbooks($iIndex + 1)
			$aBooks[$iIndex][1] = $oExcel.Workbooks($iIndex + 1).Name
			$aBooks[$iIndex][2] = $oExcel.Workbooks($iIndex + 1).Path
		Next
	Else
		If $oExcel <> Default Then Return SetError(1, 0, 0)
		Local $oWorkbook, $sCLSID_Workbook = "{00020819-0000-0000-C000-000000000046}"
		While True
			$oWorkbook = ObjGet("", $sCLSID_Workbook, $iIndex + 1)
			If @error Then ExitLoop
			ReDim $aBooks[$iIndex + 1][3]
			$aBooks[$iIndex][0] = $oWorkbook
			$aBooks[$iIndex][1] = $oWorkbook.Name
			$aBooks[$iIndex][2] = $oWorkbook.Path
			$iIndex += 1
		WEnd
	EndIf
	Return $aBooks
EndFunc   ;==>_Excel_BookList

; #FUNCTION# ====================================================================================================================
; Author ........: SEO <locodarwin at yahoo dot com>
; Modified.......: litlmike, water
; ===============================================================================================================================
Func _Excel_BookNew($oExcel, $iSheets = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oExcel) Or ObjName($oExcel, 1) <> "_Application" Then Return SetError(1, 0, 0)
	With $oExcel
		If $iSheets <> Default Then
			If $iSheets < 1 Or $iSheets > 255 Then Return SetError(4, 0, 0)
			Local $iSheetsBackup = .SheetsInNewWorkbook
			.SheetsInNewWorkbook = $iSheets
			If @error Then Return SetError(2, @error, 0)
		EndIf
		Local $oWorkbook = .Workbooks.Add()
		If @error Then
			Local $iError = @error
			If $iSheets <> Default Then .SheetsInNewWorkbook = $iSheetsBackup
			Return SetError(3, $iError, 0)
		EndIf
		If $iSheets <> Default Then .SheetsInNewWorkbook = $iSheetsBackup
	EndWith
	Return $oWorkbook
EndFunc   ;==>_Excel_BookNew

; #FUNCTION# ====================================================================================================================
; Author ........: SEO <locodarwin at yahoo dot com>
; Modified.......: litlmike, water, GMK, willichan
; ===============================================================================================================================
Func _Excel_BookOpen($oExcel, $sFilePath, $bReadOnly = Default, $bVisible = Default, $sPassword = Default, $sWritePassword = Default, $bUpdateLinks = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oExcel) Or ObjName($oExcel, 1) <> "_Application" Then Return SetError(1, @error, 0)
	If Not FileExists($sFilePath) Then Return SetError(2, 0, 0)
	If $bReadOnly = Default Then $bReadOnly = False
	If $bVisible = Default Then $bVisible = True
	Local $oWorkbook = $oExcel.Workbooks.Open($sFilePath, $bUpdateLinks, $bReadOnly, Default, $sPassword, $sWritePassword)
	If @error Then Return SetError(3, @error, 0)
	$oExcel.Windows($oWorkbook.Name).Visible = $bVisible
	; If a read-write workbook was opened read-only then set @extended = 1
	If $bReadOnly = False And $oWorkbook.Readonly = True Then Return SetError(0, 1, $oWorkbook)
	Return $oWorkbook
EndFunc   ;==>_Excel_BookOpen

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified.......:
; ===============================================================================================================================
Func _Excel_BookOpenText($oExcel, $sFilePath, $iStartRow = Default, $iDataType = Default, $sTextQualifier = Default, $bConsecutiveDelimiter = Default, $sDelimiter = Default, $aFieldInfo = Default, $sDecimalSeparator = Default, $sThousandsSeparator = Default, $bTrailingMinusNumbers = Default, $iOrigin = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	Local $bTab = False, $bSemicolon = False, $bComma = False, $bSpace = False, $aDelimiter[1], $bOther = False, $sOtherChar
	If Not IsObj($oExcel) Or ObjName($oExcel, 1) <> "_Application" Then Return SetError(1, @error, 0)
	If Not FileExists($sFilePath) Then Return SetError(2, 0, 0)
	If $iStartRow = Default Then $iStartRow = 1
	If $sTextQualifier = Default Then $sTextQualifier = $xlTextQualifierDoubleQuote
	If $bConsecutiveDelimiter = Default Then $bConsecutiveDelimiter = False
	If $sDelimiter = Default Then $sDelimiter = ","
	If $bTrailingMinusNumbers = Default Then $bTrailingMinusNumbers = True
	If StringInStr($sDelimiter, @TAB) > 0 Then $bTab = True
	If StringInStr($sDelimiter, ";") > 0 Then $bSemicolon = True
	If StringInStr($sDelimiter, ",") > 0 Then $bComma = True
	If StringInStr($sDelimiter, " ") > 0 Then $bSpace = True
	$aDelimiter = StringRegExp($sDelimiter, "[^;, " & @TAB & "]", 1)
	If Not @error Then
		$sOtherChar = $aDelimiter[0]
		$bOther = True
	EndIf
	$oExcel.Workbooks.OpenText($sFilePath, $iOrigin, $iStartRow, $iDataType, $sTextQualifier, $bConsecutiveDelimiter, _
			$bTab, $bSemicolon, $bComma, $bSpace, $bOther, $sOtherChar, $aFieldInfo, Default, $sDecimalSeparator, $sThousandsSeparator, _
			$bTrailingMinusNumbers, False)
	If @error Then Return SetError(3, @error, 0)
	Return $oExcel.ActiveWorkbook ; Method OpenText doesn't return the Workbook object
EndFunc   ;==>_Excel_BookOpenText

; #FUNCTION# ====================================================================================================================
; Author ........: SEO <locodarwin at yahoo dot com>
; Modified.......: litlmike, water
; ===============================================================================================================================
Func _Excel_BookSave($oWorkbook)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If Not $oWorkbook.Saved Then
		$oWorkbook.Save()
		If @error Then Return SetError(2, @error, 0)
		Return SetError(0, 1, 1)
	EndIf
	Return 1
EndFunc   ;==>_Excel_BookSave

; #FUNCTION# ====================================================================================================================
; Author ........: SEO <locodarwin at yahoo dot com>
; Modified.......: litlmike, water
; ===============================================================================================================================
Func _Excel_BookSaveAs($oWorkbook, $sFilePath, $iFormat = Default, $bOverWrite = Default, $sPassword = Default, $sWritePassword = Default, $bReadOnlyRecommended = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If $iFormat = Default Then
		$iFormat = $xlWorkbookDefault
	Else
		If Not IsNumber($iFormat) Then Return SetError(2, 0, 0)
	EndIf
	If $bOverWrite = Default Then $bOverWrite = False
	If $bReadOnlyRecommended = Default Then $bReadOnlyRecommended = False
	If FileExists($sFilePath) Then
		If Not $bOverWrite Then Return SetError(3, 0, 0)
		Local $iResult = FileDelete($sFilePath)
		If $iResult = 0 Then Return SetError(4, 0, 0)
	EndIf
	$oWorkbook.SaveAs($sFilePath, $iFormat, $sPassword, $sWritePassword, $bReadOnlyRecommended)
	If @error Then Return SetError(5, @error, 0)
	Return 1
EndFunc   ;==>_Excel_BookSaveAs

; #FUNCTION# ====================================================================================================================
; Name ..........: _Excel_ColumnToLetter
; Description ...: Converts the column number to letter(s).
; Syntax ........: _ExcelColumnToLetter($iColumn)
; Parameters ....: $iColumn - The column number which you want to turn into letter(s)
; Return values .: Success - Returns the column letter(s)
;                  Failure - Returns "" and sets @Error:
; Author(s):       Spiff59
; Modified ......:
; ===============================================================================================================================
Func _Excel_ColumnToLetter($iColumn)
	If Not StringRegExp($iColumn, "^[0-9]+$") Then Return SetError(1, 0, "")
	Local $sLetters, $iTemp
	While $iColumn
		$iTemp = Mod($iColumn, 26)
		If $iTemp = 0 Then $iTemp = 26
		$sLetters = Chr($iTemp + 64) & $sLetters
		$iColumn = ($iColumn - $iTemp) / 26
	WEnd
	Return $sLetters
EndFunc   ;==>_Excel_ColumnToLetter

; #FUNCTION# ====================================================================================================================
; Author ........: Golfinhu
; Modified ......:
; ===============================================================================================================================
Func _Excel_ColumnToNumber($sColumn)
	$sColumn = StringUpper($sColumn)
	If Not StringRegExp($sColumn, "^[A-Z]+$") Then Return SetError(1, 0, 0)
	Local $sLetters = StringSplit($sColumn, "")
	Local $iNumber = 0
	Local $iLen = StringLen($sColumn)
	For $i = 1 To $sLetters[0]
		$iNumber += 26 ^ ($iLen - $i) * (Asc($sLetters[$i]) - 64)
	Next
	Return $iNumber
EndFunc   ;==>_Excel_ColumnToNumber

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified ......:
; ===============================================================================================================================
Func _Excel_ConvertFormula($oExcel, $sFormula, $iFromStyle, $iToStyle = Default, $iToAbsolute = Default, $vRelativeTo = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oExcel) Or ObjName($oExcel, 1) <> "_Application" Then Return SetError(1, 0, "")
	If $vRelativeTo <> Default Then
		If Not IsObj($vRelativeTo) Then $vRelativeTo = $oExcel.Range($vRelativeTo)
		If @error Or Not IsObj($vRelativeTo) Then Return SetError(2, 0, "")
	EndIf
	Local $sConverted = $oExcel.ConvertFormula($sFormula, $iFromStyle, $iToStyle, $iToAbsolute, $vRelativeTo)
	Return $sConverted
EndFunc   ;==>_Excel_ConvertFormula

; #FUNCTION# ====================================================================================================
; Author ........: water
; Modified ......:
; ===============================================================================================================
Func _Excel_Export($oExcel, $vObject, $sFileName, $iType = Default, $iQuality = Default, $bIncludeProperties = Default, $iFrom = Default, $iTo = Default, $bOpenAfterPublish = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oExcel) Or ObjName($oExcel, 1) <> "_Application" Then Return SetError(1, 0, 0)
	If Not IsObj($vObject) Then $vObject = $oExcel.Range($vObject)
	If @error Or Not IsObj($vObject) Then Return SetError(2, @error, 0)
	If $sFileName = "" Then Return SetError(3, 0, 0)
	If $iType = Default Then $iType = $xlTypePDF
	If $iQuality = Default Then $iQuality = $xlQualityStandard
	If $bIncludeProperties = Default Then $bIncludeProperties = True
	If $bOpenAfterPublish = Default Then $bOpenAfterPublish = False
	$vObject.ExportAsFixedFormat($iType, $sFileName, $iQuality, $bIncludeProperties, Default, $iFrom, $iTo, $bOpenAfterPublish)
	If @error Then Return SetError(4, @error, 0)
	Return $vObject
EndFunc   ;==>_Excel_Export

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified.......:
; ===============================================================================================================================
Func _Excel_FilterGet($oWorkbook, $vWorksheet = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If Not IsObj($vWorksheet) Then
		If $vWorksheet = Default Then
			$vWorksheet = $oWorkbook.ActiveSheet
		Else
			$vWorksheet = $oWorkbook.WorkSheets.Item($vWorksheet)
		EndIf
		If @error Or Not IsObj($vWorksheet) Then Return SetError(2, @error, 0)
	ElseIf ObjName($vWorksheet, 1) <> "_Worksheet" Then
		Return SetError(2, @error, 0)
	EndIf
	Local $iIndex = 0, $iRecords, $iItems = $vWorksheet.AutoFilter.Filters.Count
	If $iItems > 0 Then
		Local $aFilters[$iItems][7]
		For $oFilter In $vWorksheet.AutoFilter.Filters
			$aFilters[$iIndex][0] = $oFilter.On
			$aFilters[$iIndex][1] = $oFilter.Count
			$aFilters[$iIndex][2] = $oFilter.Criteria1
			If IsArray($oFilter.Criteria1) Then $aFilters[$iIndex][2] = _ArrayToString($aFilters[$iIndex][2])
			$aFilters[$iIndex][3] = $oFilter.Criteria2
			If IsArray($oFilter.Criteria2) Then $aFilters[$iIndex][3] = _ArrayToString($aFilters[$iIndex][3])
			$aFilters[$iIndex][4] = $oFilter.Operator
			$aFilters[$iIndex][5] = $oFilter.Parent.Range
			$iRecords = 0
			For $oArea In $oFilter.Parent.Range.SpecialCells($xlCellTypeVisible).Areas
				$iRecords = $iRecords + $oArea.Rows.Count
			Next
			$aFilters[$iIndex][6] = $iRecords
			$iIndex = $iIndex + 1
		Next
		Return $aFilters
	Else
		Return SetError(3, 0, "")
	EndIf
EndFunc   ;==>_Excel_FilterGet

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified.......:
; ===============================================================================================================================
Func _Excel_FilterSet($oWorkbook, $vWorksheet, $vRange, $iField, $sCriteria1 = Default, $iOperator = Default, $sCriteria2 = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If Not IsObj($vWorksheet) Then
		If $vWorksheet = Default Then
			$vWorksheet = $oWorkbook.ActiveSheet
		Else
			$vWorksheet = $oWorkbook.WorkSheets.Item($vWorksheet)
		EndIf
		If @error Or Not IsObj($vWorksheet) Then Return SetError(2, @error, 0)
	ElseIf ObjName($vWorksheet, 1) <> "_Worksheet" Then
		Return SetError(2, @error, 0)
	EndIf
	If $vRange = Default Then
		$vRange = $vWorksheet.Usedrange
	ElseIf Not IsObj($vRange) Then
		$vRange = $vWorksheet.Range($vRange)
		If @error Or Not IsObj($vRange) Then Return SetError(3, @error, 0)
	EndIf
	If $iField <> 0 Then ; Set a new filter
		$vRange.AutoFilter($iField, $sCriteria1, $iOperator, $sCriteria2)
		If @error Then Return SetError(4, @error, 0)
		; If no filters remain then AutoFiltermode is set off
		If $vWorksheet.Filtermode = False Then $vWorksheet.AutoFilterMode = False
	Else ; remove all filters
		$vWorksheet.AutoFilterMode = False
	EndIf
	Return 1
EndFunc   ;==>_Excel_FilterSet

; #FUNCTION# ====================================================================================================================
; Author ........: DanWilli
; Modified.......: water
; ===============================================================================================================================
Func _Excel_PictureAdd($oWorkbook, $vWorksheet, $sFile, $vRangeOrLeft, $iTop = Default, $iWidth = Default, $iHeight = Default, $bKeepRatio = True)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	Local $oReturn, $iPosLeft, $iPosTop
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If Not FileExists($sFile) Then Return SetError(5, 0, 0)
	If Not IsObj($vWorksheet) Then
		If $vWorksheet = Default Then
			$vWorksheet = $oWorkbook.ActiveSheet
		Else
			$vWorksheet = $oWorkbook.WorkSheets.Item($vWorksheet)
		EndIf
		If @error Or Not IsObj($vWorksheet) Then Return SetError(2, @error, 0)
	ElseIf ObjName($vWorksheet, 1) <> "_Worksheet" Then
		Return SetError(2, @error, 0)
	EndIf
	If IsNumber($vRangeOrLeft) Then
		$iPosLeft = $vRangeOrLeft
		$iPosTop = $iTop
	Else
		If Not IsObj($vRangeOrLeft) Then
			$vRangeOrLeft = $vWorksheet.Range($vRangeOrLeft)
			If @error Or Not IsObj($vRangeOrLeft) Then Return SetError(3, @error, 0)
		EndIf
		$iPosLeft = $vRangeOrLeft.Left
		$iPosTop = $vRangeOrLeft.Top
	EndIf
	If IsNumber($vRangeOrLeft) Or ($vRangeOrLeft.Columns.Count = 1 And $vRangeOrLeft.Rows.Count = 1) Then
		If $iWidth = Default And $iHeight = Default Then
			$oReturn = $vWorksheet.Shapes.AddPicture($sFile, -1, -1, $iPosLeft, $iPosTop, 0, 0)
			If @error Then Return SetError(4, @error, 0)
			$oReturn.Scalewidth(1, -1, 0)
			$oReturn.Scaleheight(1, -1, 0)
		ElseIf $iWidth = Default Then
			$oReturn = $vWorksheet.Shapes.AddPicture($sFile, -1, -1, $iPosLeft, $iPosTop, 0, 0)
			If @error Then Return SetError(4, @error, 0)
			$oReturn.Visible = 0
			$oReturn.Scalewidth(1, -1, 0)
			$oReturn.Scaleheight(1, -1, 0)
			$oReturn.Scalewidth($iHeight / $oReturn.Height, -1, 0)
			$oReturn.Scaleheight($iHeight / $oReturn.Height, -1, 0)
			$oReturn.Visible = 1
		ElseIf $iHeight = Default Then
			$oReturn = $vWorksheet.Shapes.AddPicture($sFile, -1, -1, $iPosLeft, $iPosTop, 0, 0)
			If @error Then Return SetError(4, @error, 0)
			$oReturn.Visible = 0
			$oReturn.Scalewidth(1, -1, 0)
			$oReturn.Scaleheight(1, -1, 0)
			$oReturn.Scaleheight($iWidth / $oReturn.Width, -1, 0)
			$oReturn.Scalewidth($iWidth / $oReturn.Width, -1, 0)
			$oReturn.Visible = 1
		Else
			$oReturn = $vWorksheet.Shapes.AddPicture($sFile, -1, -1, $iPosLeft, $iPosTop, $iWidth, $iHeight)
			If @error Then Return SetError(4, @error, 0)
		EndIf
	Else
		If $bKeepRatio = True Then
			$oReturn = $vWorksheet.Shapes.AddPicture($sFile, -1, -1, $iPosLeft, $iPosTop, 0, 0)
			If @error Then Return SetError(4, @error, 0)
			$oReturn.Visible = 0
			$oReturn.Scalewidth(1, -1, 0)
			$oReturn.Scaleheight(1, -1, 0)
			Local $iRw = $vRangeOrLeft.Width / $oReturn.Width
			Local $iRh = $vRangeOrLeft.Height / $oReturn.Height
			If $iRw < $iRh Then
				$oReturn.Scaleheight($iRw, -1, 0)
				$oReturn.Scalewidth($iRw, -1, 0)
			Else
				$oReturn.Scaleheight($iRh, -1, 0)
				$oReturn.Scalewidth($iRh, -1, 0)
			EndIf
			$oReturn.Visible = 1
		Else
			$oReturn = $vWorksheet.Shapes.AddPicture($sFile, -1, -1, $iPosLeft, $iPosTop, $vRangeOrLeft.Width, $vRangeOrLeft.Height)
			If @error Then Return SetError(4, @error, 0)
		EndIf
	EndIf
	Return $oReturn
EndFunc   ;==>_Excel_PictureAdd

; #FUNCTION# ====================================================================================================
; Author ........: water
; Modified ......:
; ===============================================================================================================
Func _Excel_Print($oExcel, $vObject, $iCopies = Default, $sPrinter = Default, $bPreview = Default, $iFrom = Default, $iTo = Default, $bPrintToFile = Default, $bCollate = Default, $sPrToFileName = "")
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oExcel) Or ObjName($oExcel, 1) <> "_Application" Then Return SetError(1, 0, 0)
	If IsString($vObject) Then $vObject = $oExcel.Range($vObject)
	If @error Or Not IsObj($vObject) Then Return SetError(2, @error, 0)
	$vObject.PrintOut($iFrom, $iTo, $iCopies, $bPreview, $sPrinter, $bPrintToFile, $bCollate, $sPrToFileName)
	If @error Then Return SetError(3, @error, 0)
	Return $vObject
EndFunc   ;==>_Excel_Print

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified.......:
; ===============================================================================================================================
Func _Excel_RangeCopyPaste($oWorksheet, $vSourceRange, $vTargetRange = Default, $bCut = Default, $iPaste = Default, $iOperation = Default, $bSkipBlanks = Default, $bTranspose = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorksheet) Or ObjName($oWorksheet, 1) <> "_Worksheet" Then Return SetError(1, 0, 0)
	If $bCut = Default Then $bCut = False
	If $vSourceRange = Default And $vTargetRange = Default Then Return SetError(7, 0, 0)
	If Not IsObj($vSourceRange) And $vSourceRange <> Default Then
		$vSourceRange = $oWorksheet.Range($vSourceRange)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	If Not IsObj($vTargetRange) And $vTargetRange <> Default Then
		$vTargetRange = $oWorksheet.Range($vTargetRange)
		If @error Then Return SetError(3, @error, 0)
	EndIf
	If $vSourceRange = Default Then ; Paste from the clipboard
		If $bSkipBlanks = Default Then $bSkipBlanks = False
		If $bTranspose = Default Then $bTranspose = False
		$vTargetRange.PasteSpecial($iPaste, $iOperation, $bSkipBlanks, $bTranspose)
		If @error Then Return SetError(4, @error, 0)
	Else
		If $bCut Then
			$vSourceRange.Cut($vTargetRange)
			If @error Then Return SetError(5, @error, 0)
		Else
			$vSourceRange.Copy($vTargetRange)
			If @error Then Return SetError(6, @error, 0)
		EndIf
	EndIf
	If $vTargetRange <> Default Then
		Return $vTargetRange
	Else
		Return 1
	EndIf
EndFunc   ;==>_Excel_RangeCopyPaste

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified.......:
; ===============================================================================================================================
Func _Excel_RangeDelete($oWorksheet, $vRange, $iShift = Default, $iEntireRowCol = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorksheet) Or ObjName($oWorksheet, 1) <> "_Worksheet" Then Return SetError(1, 0, 0)
	If Not IsObj($vRange) Then
		$vRange = $oWorksheet.Range($vRange)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	If $iEntireRowCol = 1 Then
		$vRange.EntireRow.Delete($iShift)
	ElseIf $iEntireRowCol = 2 Then
		$vRange.EntireColumn.Delete($iShift)
	Else
		$vRange.Delete($iShift)
	EndIf
	If @error Then Return SetError(3, @error, 0)
	Return 1
EndFunc   ;==>_Excel_RangeDelete

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified.......:
; ===============================================================================================================================
Func _Excel_RangeFind($oWorkbook, $sSearch, $vRange = Default, $iLookIn = Default, $iLookAt = Default, $bMatchcase = Default)
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If StringStripWS($sSearch, 3) = "" Then Return SetError(2, 0, 0)
	If $iLookIn = Default Then $iLookIn = $xlValues
	If $iLookAt = Default Then $iLookAt = $xlPart
	If $bMatchcase = Default Then $bMatchcase = False
	Local $oMatch, $sFirst = "", $bSearchWorkbook = False, $oSheet
	If $vRange = Default Then
		$bSearchWorkbook = True
		$oSheet = $oWorkbook.Sheets(1)
		$vRange = $oSheet.UsedRange
	ElseIf IsString($vRange) Then
		$vRange = $oWorkbook.Activesheet.Range($vRange)
		If @error Then Return SetError(3, @error, 0)
	EndIf
	Local $aResult[100][6], $iIndex = 0, $iIndexSheets = 1
	While 1
		$oMatch = $vRange.Find($sSearch, Default, $iLookIn, $iLookAt, Default, Default, $bMatchcase)
		If @error Then Return SetError(4, @error, 0)
		If IsObj($oMatch) Then
			$sFirst = $oMatch.Address
			While 1
				$aResult[$iIndex][0] = $oMatch.Worksheet.Name
				$aResult[$iIndex][1] = $oMatch.Name.Name
				$aResult[$iIndex][2] = $oMatch.Address
				$aResult[$iIndex][3] = $oMatch.Value
				$aResult[$iIndex][4] = $oMatch.Formula
				$aResult[$iIndex][5] = $oMatch.Comment.Text
				$iIndex = $iIndex + 1
				If Mod($iIndex, 100) = 0 Then ReDim $aResult[UBound($aResult, 1) + 100][6]
				$oMatch = $vRange.Findnext($oMatch)
				If Not IsObj($oMatch) Or $sFirst = $oMatch.Address Then ExitLoop
			WEnd
		EndIf
		If Not $bSearchWorkbook Then ExitLoop
		$iIndexSheets = $iIndexSheets + 1
		$sFirst = ""
		$oSheet = $oWorkbook.Sheets($iIndexSheets)
		If @error Then ExitLoop
		$vRange = $oSheet.UsedRange
	WEnd
	ReDim $aResult[$iIndex][6]
	Return $aResult
EndFunc   ;==>_Excel_RangeFind

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified.......:
; ===============================================================================================================================
Func _Excel_RangeInsert($oWorksheet, $vRange, $iShift = Default, $iCopyOrigin = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorksheet) Or ObjName($oWorksheet, 1) <> "_Worksheet" Then Return SetError(1, 0, 0)
	If Not IsObj($vRange) Then
		$vRange = $oWorksheet.Range($vRange)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	$vRange.Insert($iShift, $iCopyOrigin)
	If @error Then Return SetError(3, @error, 0)
	Return $vRange
EndFunc   ;==>_Excel_RangeInsert

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified ......: Added parameter $sTextToDisplay
; ===============================================================================================================================
Func _Excel_RangeLinkAddRemove($oWorkbook, $vWorksheet, $vRange, $sAddress, $sSubAddress = Default, $sScreenTip = Default, $sTextToDisplay = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	Local $oLink
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If Not IsObj($vWorksheet) Then
		If $vWorksheet = Default Then
			$vWorksheet = $oWorkbook.ActiveSheet
		Else
			$vWorksheet = $oWorkbook.WorkSheets.Item($vWorksheet)
		EndIf
		If @error Or Not IsObj($vWorksheet) Then Return SetError(2, @error, 0)
	ElseIf ObjName($vWorksheet, 1) <> "_Worksheet" Then
		Return SetError(2, @error, 0)
	EndIf
	If Not IsObj($vRange) Then
		$vRange = $vWorksheet.Range($vRange)
		If @error Or Not IsObj($vRange) Then Return SetError(3, @error, 0)
	EndIf
	If $sAddress = "" Then
		$vRange.Hyperlinks.Delete()
		If @error Then Return SetError(4, @error, 0)
		Return 1
	Else
		$oLink = $vWorksheet.Hyperlinks.Add($vRange, $sAddress, $sSubAddress, $sScreenTip, $sTextToDisplay)
		If @error Then Return SetError(4, @error, 0)
		Return $oLink
	EndIf

EndFunc   ;==>_Excel_RangeLinkAddRemove

; #FUNCTION# ====================================================================================================================
; Author ........: SEO <locodarwin at yahoo dot com>
; Modified.......: litlmike, water, GMK
; ===============================================================================================================================
Func _Excel_RangeRead($oWorkbook, $vWorksheet = Default, $vRange = Default, $iReturn = Default, $bForceFunc = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If Not IsObj($vWorksheet) Then
		If $vWorksheet = Default Then
			$vWorksheet = $oWorkbook.ActiveSheet
		Else
			$vWorksheet = $oWorkbook.WorkSheets.Item($vWorksheet)
		EndIf
		If @error Or Not IsObj($vWorksheet) Then Return SetError(2, @error, 0)
	ElseIf ObjName($vWorksheet, 1) <> "_Worksheet" Then
		Return SetError(2, @error, 0)
	EndIf
	If $vRange = Default Then
		$vRange = $vWorksheet.Usedrange
	ElseIf Not IsObj($vRange) Then
		$vRange = $vWorksheet.Range($vRange)
		If @error Or Not IsObj($vRange) Then Return SetError(3, @error, 0)
	EndIf
	If $iReturn = Default Then
		$iReturn = 1
	ElseIf $iReturn < 1 Or $iReturn > 4 Then
		Return SetError(4, 0, 0)
	EndIf
	If $bForceFunc = Default Then $bForceFunc = False
	Local $vResult, $iCellCount = $vRange.Columns.Count * $vRange.Rows.Count
	If $iReturn = 3 And $iCellCount > 1 Then Return SetError(8, @error, 0)
	; The max number of elements in an AutoIt array is limited to 2^24 = 16,777,216
	If $iCellCount > 16777216 Then Return SetError(6, 0, 0)
	; Transpose has an undocumented limit on the number of cells or rows it can transpose. This limit increases with the Excel version
	; Limits:
	;   Excel 97   - 5461 cells
	;   Excel 2000 - 5461 cells
	;   Excel 2003 - ?
	;   Excel 2007 - 65535 cells
	;   Excel 2010 - ?
	;   Excel 2013 - ?
	If $iCellCount > 65535 Then $bForceFunc = True
	If $bForceFunc Then
		Switch $iReturn
			Case 1
				$vResult = $vRange.Value
			Case 2
				$vResult = $vRange.Formula
			Case 3
				$vResult = $vRange.Text
			Case Else
				$vResult = $vRange.Value2
		EndSwitch
		If @error Then Return SetError(7, @error, 0)
		If $iCellCount > 1 Then _ArrayTranspose($vResult)
	Else
		Local $oExcel = $oWorkbook.Parent
		Switch $iReturn
			Case 1
				$vResult = $oExcel.Transpose($vRange.Value)
			Case 2
				$vResult = $oExcel.Transpose($vRange.Formula)
			Case 3
				$vResult = $oExcel.Transpose($vRange.Text)
			Case Else
				$vResult = $oExcel.Transpose($vRange.Value2)
		EndSwitch
		If @error Then Return SetError(5, @error, 0)
	EndIf
	Return $vResult
EndFunc   ;==>_Excel_RangeRead

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified.......:
; ===============================================================================================================================
Func _Excel_RangeReplace($oWorkbook, $vWorksheet, $vRange, $sSearch, $sReplace, $iLookAt = Default, $bMatchcase = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If Not IsObj($vWorksheet) Then
		If $vWorksheet = Default Then
			$vWorksheet = $oWorkbook.ActiveSheet
		Else
			$vWorksheet = $oWorkbook.WorkSheets.Item($vWorksheet)
		EndIf
		If @error Or Not IsObj($vWorksheet) Then Return SetError(2, @error, 0)
	ElseIf ObjName($vWorksheet, 1) <> "_Worksheet" Then
		Return SetError(2, @error, 0)
	EndIf
	If StringStripWS($sSearch, 3) = "" Then Return SetError(3, 0, 0)
	If $vRange = Default Then
		$vRange = $vWorksheet.Usedrange
	ElseIf Not IsObj($vRange) Then
		$vRange = $vWorksheet.Range($vRange)
		If @error Or Not IsObj($vRange) Then Return SetError(4, @error, 0)
	EndIf
	If $iLookAt = Default Then $iLookAt = $xlPart
	If $bMatchcase = Default Then $bMatchcase = False
	Local $bReplace
	$bReplace = $vRange.Replace($sSearch, $sReplace, $iLookAt, Default, $bMatchcase)
	If @error Then Return SetError(5, @error, 0)
	Return SetError(0, $bReplace, $vRange)
EndFunc   ;==>_Excel_RangeReplace

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified.......:
; ===============================================================================================================================
Func _Excel_RangeSort($oWorkbook, $vWorksheet, $vRange, $vKey1, $iOrder1 = Default, $iSortText = Default, $iHeader = Default, _
		$bMatchcase = Default, $iOrientation = Default, $vKey2 = Default, $iOrder2 = Default, $vKey3 = Default, $iOrder3 = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If Not IsObj($vWorksheet) Then
		If $vWorksheet = Default Then
			$vWorksheet = $oWorkbook.ActiveSheet
		Else
			$vWorksheet = $oWorkbook.WorkSheets.Item($vWorksheet)
		EndIf
		If @error Or Not IsObj($vWorksheet) Then Return SetError(2, @error, 0)
	ElseIf ObjName($vWorksheet, 1) <> "_Worksheet" Then
		Return SetError(2, @error, 0)
	EndIf
	If $vRange = Default Then
		$vRange = $vWorksheet.Usedrange
	ElseIf Not IsObj($vRange) Then
		$vRange = $vWorksheet.Range($vRange)
		If @error Or Not IsObj($vRange) Then Return SetError(3, @error, 0)
	EndIf
	$vKey1 = $vWorksheet.Range($vKey1)
	If @error Or Not IsObj($vKey1) Then Return SetError(4, @error, 0)
	If $vKey2 <> Default Then
		$vKey2 = $vWorksheet.Range($vKey2)
		If @error Or Not IsObj($vKey2) Then Return SetError(5, @error, 0)
	EndIf
	If $vKey3 <> Default Then
		$vKey3 = $vWorksheet.Range($vKey3)
		If @error Or Not IsObj($vKey3) Then Return SetError(6, @error, 0)
	EndIf
	If $iHeader = Default Then $iHeader = $xlNo
	If $bMatchcase = Default Then $bMatchcase = False
	If $iOrientation = Default Then $iOrientation = $xlSortColumns
	If $iOrder1 = Default Then $iOrder1 = $xlAscending
	If $iSortText = Default Then $iSortText = $xlSortNormal
	If $iOrder2 = Default Then $iOrder2 = $xlAscending
	If $iOrder3 = Default Then $iOrder3 = $xlAscending
	If Int($oWorkbook.Parent.Version) < 112 Then ; Use Sort method for Excel 2003 and older
		$vRange.Sort($vKey1, $iOrder1, $vKey2, Default, $iOrder2, $vKey3, $iOrder3, $iHeader, Default, $bMatchcase, $iOrientation, Default, $iSortText, $iSortText, $iSortText)
	Else
		; http://www.autoitscript.com/forum/topic/136672-excel-multiple-column-sort/?hl=%2Bexcel+%2Bsort+%2Bcolumns#entry956163
		; http://msdn.microsoft.com/en-us/library/ff839572(v=office.14).aspx
		$vWorksheet.Sort.SortFields.Clear
		$vWorksheet.Sort.SortFields.Add($vKey1, $xlSortOnValues, $iOrder1)
		If $vKey2 <> Default Then $vWorksheet.Sort.SortFields.Add($vKey2, $xlSortOnValues, $iOrder2)
		If $vKey3 <> Default Then $vWorksheet.Sort.SortFields.Add($vKey3, $xlSortOnValues, $iOrder3)
		$vWorksheet.Sort.SetRange($vRange)
		$vWorksheet.Sort.Header = $iHeader
		$vWorksheet.Sort.MatchCase = $bMatchcase
		$vWorksheet.Sort.Orientation = $iOrientation
		$vWorksheet.Sort.Apply
	EndIf
	If @error Then Return SetError(7, @error, 0)
	Return $vRange
EndFunc   ;==>_Excel_RangeSort

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified.......:
; ===============================================================================================================================
Func _Excel_RangeValidate($oWorkbook, $vWorksheet, $vRange, $iType, $sFormula1, $iOperator = Default, $sFormula2 = Default, $bIgnoreBlank = Default, $iAlertStyle = Default, $sErrorMessage = Default, $sInputMessage = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If Not IsObj($vWorksheet) Then
		If $vWorksheet = Default Then
			$vWorksheet = $oWorkbook.ActiveSheet
		Else
			$vWorksheet = $oWorkbook.WorkSheets.Item($vWorksheet)
		EndIf
		If @error Or Not IsObj($vWorksheet) Then Return SetError(2, @error, 0)
	ElseIf ObjName($vWorksheet, 1) <> "_Worksheet" Then
		Return SetError(2, @error, 0)
	EndIf
	If $vRange = Default Then
		$vRange = $vWorksheet.Usedrange
	ElseIf Not IsObj($vRange) Then
		$vRange = $vWorksheet.Range($vRange)
		If @error Or Not IsObj($vRange) Then Return SetError(3, @error, 0)
	EndIf
	If $bIgnoreBlank = Default Then $bIgnoreBlank = True
	If $iAlertStyle = Default Then $iAlertStyle = $xlValidAlertStop
	$vRange.Validation.Delete() ; delete existing validation before adding a new one
	$vRange.Validation.Add($iType, $iAlertStyle, $iOperator, $sFormula1, $sFormula2)
	If @error Then Return SetError(4, @error, 0)
	$vRange.Validation.IgnoreBlank = $bIgnoreBlank
	If $sInputMessage <> Default Then
		$vRange.Validation.InputMessage = $sInputMessage
		$vRange.Validation.ShowInput = True
	EndIf
	If $sErrorMessage <> Default Then
		$vRange.Validation.ErrorMessage = $sErrorMessage
		$vRange.Validation.ShowError = True
	EndIf
	Return $vRange
EndFunc   ;==>_Excel_RangeValidate

; #FUNCTION# ====================================================================================================================
; Author ........: SEO <locodarwin at yahoo dot com>
; Modified.......: litlmike, PsaltyDS, Golfinhu, water
; ===============================================================================================================================
Func _Excel_RangeWrite($oWorkbook, $vWorksheet, $vValue, $vRange = Default, $bValue = Default, $bForceFunc = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If Not IsObj($vWorksheet) Then
		If $vWorksheet = Default Then
			$vWorksheet = $oWorkbook.ActiveSheet
		Else
			$vWorksheet = $oWorkbook.WorkSheets.Item($vWorksheet)
		EndIf
		If @error Or Not IsObj($vWorksheet) Then Return SetError(2, @error, 0)
	ElseIf ObjName($vWorksheet, 1) <> "_Worksheet" Then
		Return SetError(2, @error, 0)
	EndIf
	If $vRange = Default Then $vRange = "A1"
	If $bValue = Default Then $bValue = True
	If $bForceFunc = Default Then $bForceFunc = False
	If Not IsObj($vRange) Then
		$vRange = $vWorksheet.Range($vRange)
		If @error Or Not IsObj($vRange) Then Return SetError(3, @error, 0)
	EndIf
	If Not IsArray($vValue) Then
		If $bValue Then
			$vRange.Value = $vValue
		Else
			$vRange.Formula = $vValue
		EndIf
		If @error Then Return SetError(4, @error, 0)
	Else
		If $vRange.Columns.Count = 1 And $vRange.Rows.Count = 1 Then
			If UBound($vValue, 0) = 1 Then
				$vRange = $vRange.Resize(UBound($vValue, 1), 1)
			Else
				$vRange = $vRange.Resize(UBound($vValue, 1), UBound($vValue, 2))
			EndIf
		EndIf
		; ==========================
		; Transpose has an undocument limit on the number of cells or rows it can transpose. This limit increases with the Excel version
		; Limits:
		;   Excel 97   - 5461 cells
		;   Excel 2000 - 5461 cells
		;   Excel 2003 - ?
		;   Excel 2007 - 65536 rows ?
		;   Excel 2010 - ?
		; Example: If $oExcel.Version = 14 And $vRange.Columns.Count * $vRange.Rows.Count > 1000000 Then $bForceFunc = True
		If $bForceFunc Then
			_ArrayTranspose($vValue)
			If $bValue Then
				$vRange.Value = $vValue
			Else
				$vRange.Formula = $vValue
			EndIf
			If @error Then Return SetError(5, @error, 0)
		Else
			Local $oExcel = $oWorkbook.Parent
			If $bValue Then
				$vRange.Value = $oExcel.Transpose($vValue)
			Else
				$vRange.Formula = $oExcel.Transpose($vValue)
			EndIf
			If @error Then Return SetError(6, @error, 0)
		EndIf
	EndIf
	Return $vRange
EndFunc   ;==>_Excel_RangeWrite

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified.......:
; ===============================================================================================================================
Func _Excel_SheetAdd($oWorkbook, $vSheet = Default, $bBefore = Default, $iCount = Default, $sName = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	Local $bInsertAtEnd = False, $iStartSheet, $oBefore = Default, $oAfter = Default
	If $iCount = Default Then $iCount = 1
	If $iCount > 255 Then Return SetError(6, 0, 0)
	If $bBefore = Default Then $bBefore = True
	If $vSheet = Default Then
		$vSheet = $oWorkbook.ActiveSheet
	ElseIf Not IsObj($vSheet) Then
		If $vSheet = -1 Then
			$vSheet = $oWorkbook.WorkSheets.Item($oWorkbook.WorkSheets.Count)
		Else
			$vSheet = $oWorkbook.WorkSheets.Item($vSheet)
		EndIf
		If @error Then Return SetError(2, @error, 0)
		If $vSheet.Index = $oWorkbook.WorkSheets.Count And $bBefore = False Then $bInsertAtEnd = True
	EndIf
	If $sName <> Default Then
		Local $aName = StringSplit($sName, "|")
		SetError(0) ; Reset @error if the separator was not found
		If $aName[1] <> "" Then ; Name provided
			For $iIndex1 = 1 To $aName[0]
				For $iIndex2 = 1 To $oWorkbook.WorkSheets.Count
					If $oWorkbook.WorkSheets($iIndex2).Name = $aName[$iIndex1] Then Return SetError(3, $iIndex1, 0)
				Next
			Next
		Else
			$sName = Default ; No name provided
		EndIf
	EndIf
	If $bBefore Then
		$oBefore = $vSheet
	Else
		$oAfter = $vSheet
	EndIf
	Local $oSheet = $oWorkbook.WorkSheets.Add($oBefore, $oAfter, $iCount)
	If @error Then Return SetError(4, @error, 0)
	If $sName <> Default Then
		; If sheets are added after the last sheet then the returned sheet is the rightmost, else it is the leftmost
		If $bInsertAtEnd = True Then
			$iStartSheet = $oSheet.Index - $iCount + 1
		Else
			$iStartSheet = $oSheet.Index
		EndIf
		$iIndex2 = 1
		For $iSheet = $iStartSheet To $iStartSheet + $iCount - 1
			If $aName[$iIndex2] <> "" Then $oWorkbook.WorkSheets($iSheet).Name = $aName[$iIndex2]
			If @error Then Return SetError(5, @error, 0)
			$iIndex2 += 1
			If $iIndex2 > $aName[0] Then ExitLoop
		Next
	EndIf
	Return $oSheet
EndFunc   ;==>_Excel_SheetAdd

; #FUNCTION# ====================================================================================================================
; Author ........: SEO <locodarwin at yahoo dot com>
; Modified.......: litlmike, water
; ===============================================================================================================================
Func _Excel_SheetCopyMove($oSourceBook, $vSourceSheet = Default, $oTargetBook = Default, $vTargetSheet = Default, $bBefore = Default, $bCopy = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	Local $vBefore = Default, $vAfter = Default
	If Not IsObj($oSourceBook) Or ObjName($oSourceBook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	If $vSourceSheet = Default Then $vSourceSheet = $oSourceBook.ActiveSheet
	If $oTargetBook = Default Then $oTargetBook = $oSourceBook
	If Not IsObj($oTargetBook) Or ObjName($oTargetBook, 1) <> "_Workbook" Then Return SetError(2, 0, 0)
	If $vTargetSheet = Default Then $vTargetSheet = 1
	If $bBefore = Default Then $bBefore = True
	If $bCopy = Default Then $bCopy = True
	If Not IsObj($vSourceSheet) Then
		$vSourceSheet = $oSourceBook.Sheets($vSourceSheet)
		If @error Or Not IsObj($vSourceSheet) Then SetError(3, @error, 0)
	EndIf
	If Not IsObj($vTargetSheet) Then
		$vTargetSheet = $oTargetBook.Sheets($vTargetSheet)
		If @error Or Not IsObj($vTargetSheet) Then SetError(4, @error, 0)
	EndIf
	If $bBefore Then
		$vBefore = $vTargetSheet
	Else
		$vAfter = $vTargetSheet
	EndIf
	If $bCopy Then
		$vSourceSheet.Copy($vBefore, $vAfter)
	Else
		$vSourceSheet.Move($vBefore, $vAfter)
	EndIf
	If @error Then Return SetError(5, 0, 0)
	If $bBefore Then
		Return $oTargetBook.Sheets($vTargetSheet.Index - 1)
	Else
		Return $oTargetBook.Sheets($vTargetSheet.Index + 1)
	EndIf
EndFunc   ;==>_Excel_SheetCopyMove

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified.......:
; ===============================================================================================================================
Func _Excel_SheetDelete($oWorkbook, $vSheet = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Excel_COMErrFunc")
	#forceref $oError
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	Local $oSheet
	If $vSheet = Default Then
		$oSheet = $oWorkbook.ActiveSheet
	ElseIf Not IsObj($vSheet) Then
		$oSheet = $oWorkbook.WorkSheets.Item($vSheet)
	Else
		$oSheet = $vSheet
	EndIf
	If @error Then Return SetError(2, @error, 0)
	$oSheet.Delete()
	If @error Then Return SetError(3, @error, 0)
	Return 1
EndFunc   ;==>_Excel_SheetDelete

; #FUNCTION# ====================================================================================================================
; Author ........: SEO <locodarwin at yahoo dot com>
; Modified.......: litlmike, water
; ===============================================================================================================================
Func _Excel_SheetList($oWorkbook)
	If Not IsObj($oWorkbook) Or ObjName($oWorkbook, 1) <> "_Workbook" Then Return SetError(1, 0, 0)
	Local $iSheetCount = $oWorkbook.Sheets.Count
	Local $aSheets[$iSheetCount][2]
	For $iIndex = 0 To $iSheetCount - 1
		$aSheets[$iIndex][0] = $oWorkbook.Sheets($iIndex + 1).Name
		$aSheets[$iIndex][1] = $oWorkbook.Sheets($iIndex + 1)
	Next
	Return $aSheets
EndFunc   ;==>_Excel_SheetList

; #INTERNAL_USE_ONLY#============================================================================================================
; Author ........: Valik
; Modified ......: water
; ===============================================================================================================================
Func __Excel_CloseOnQuit($oExcel, $bNewState = Default)
	Static $bState[101] = [0]
	If $bNewState = True Then ; Add new Excel instance to the table. Will be closed on _Excel_Close
		For $i = 1 To $bState[0]
			If Not IsObj($bState[$i]) Or $bState[$i] = $oExcel Then ; Empty cell found or instance already stored
				$bState[$i] = $oExcel
				Return True
			EndIf
		Next
		$bState[0] = $bState[0] + 1 ; No empty cell found and instance not already in table. Create a new entry at the end of the table
		$bState[$bState[0]] = $oExcel
		Return True
	Else
		For $i = 1 To $bState[0]
			If $bState[$i] = $oExcel Then ; Excel instance found
				If $bNewState = False Then ; Remove Excel instance from table (set value to zero)
					$bState[$i] = 0
					Return False
				Else
					Return True ; Excel instance found. Will be closed on _Excel_Close
				EndIf
			EndIf
		Next
	EndIf
	Return False ; Excel instance not found. Will not be closed by _Excel_Close
EndFunc   ;==>__Excel_CloseOnQuit

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Excel_COMErrFunc
; Description ...: Dummy function for silently handling COM errors.
; Syntax.........:
; Parameters ....:
; Return values .:
;
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Excel_COMErrFunc()
	; Do nothing special, just check @error after suspect functions.
EndFunc   ;==>__Excel_COMErrFunc
