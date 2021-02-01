#include-once

#include "AutoItConstants.au3"
#include "StringConstants.au3"
#include "WordConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Microsoft Word Function Library (MS Word 2003 and later)
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: A collection of functions for accessing and manipulating Microsoft Word documents
; Author(s) .....: Bob Anthony, rewritten by water
; Resources .....: Word 2003 Visual Basic Reference:	http://msdn.microsoft.com/en-us/library/aa272078(v=office.11).aspx
;                  Word 2007 Developer Reference:		http://msdn.microsoft.com/en-us/library/bb244391(v=office.12).aspx
;                  Word 2010 Developer Reference:		http://msdn.microsoft.com/en-us/library/ff841698.aspx
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _Word_Create
; _Word_Quit
; _Word_DocAdd
; _Word_DocAttach
; _Word_DocClose
; _Word_DocExport
; _Word_DocFind
; _Word_DocFindReplace
; _Word_DocGet
; _Word_DocLinkAdd
; _Word_DocLinkGet
; _Word_DocOpen
; _Word_DocPictureAdd
; _Word_DocPrint
; _Word_DocRangeSet
; _Word_DocSave
; _Word_DocSaveAs
; _Word_DocTableRead
; _Word_DocTableWrite
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; __Word_CloseOnQuit
; __Word_COMErrFunc
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_Create($bVisible = Default, $bForceNew = Default)
	Local $oAppl, $bApplCloseOnQuit = False
	If $bVisible = Default Then $bVisible = True
	If $bForceNew = Default Then $bForceNew = False
	If Not $bForceNew Then $oAppl = ObjGet("", "Word.Application")
	If $bForceNew Or @error Then
		$oAppl = ObjCreate("Word.Application")
		If @error Or Not IsObj($oAppl) Then Return SetError(1, @error, 0)
		$bApplCloseOnQuit = True
	EndIf
	__Word_CloseOnQuit($bApplCloseOnQuit)
	$oAppl.Visible = $bVisible
	Return SetError(0, $bApplCloseOnQuit, $oAppl)
EndFunc   ;==>_Word_Create

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_Quit(ByRef $oAppl, $iSaveChanges = Default, $iOriginalFormat = Default, $bForceClose = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If $iSaveChanges = Default Then $iSaveChanges = $WdDoNotSaveChanges
	If $iOriginalFormat = Default Then $iOriginalFormat = $WdWordDocument
	If $bForceClose = Default Then $bForceClose = False
	If Not IsObj($oAppl) Then Return SetError(1, 0, 0)
	If __Word_CloseOnQuit() Or $bForceClose Then
		$oAppl.Quit($iSaveChanges, $iOriginalFormat)
		If @error Then Return SetError(2, @error, 0)
	EndIf
	$oAppl = 0
	__Word_CloseOnQuit(False)
	Return 1
EndFunc   ;==>_Word_Quit

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_DocAdd($oAppl, $iDocumentType = Default, $sDocumentTemplate = Default, $bNewTemplate = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If $iDocumentType = Default Then $iDocumentType = $WdNewBlankDocument
	If $sDocumentTemplate = Default Then $sDocumentTemplate = ""
	If $bNewTemplate = Default Then $bNewTemplate = False
	If Not IsObj($oAppl) Then Return SetError(1, 0, 0)
	If StringStripWS($sDocumentTemplate, $STR_STRIPLEADING + $STR_STRIPTRAILING) <> "" And FileExists($sDocumentTemplate) <> 1 Then Return SetError(2, 0, 0)
	Local $oDoc = $oAppl.Documents.Add($sDocumentTemplate, $bNewTemplate, $iDocumentType)
	If @error Or Not IsObj($oDoc) Then Return SetError(3, @error, 0)
	Return $oDoc
EndFunc   ;==>_Word_DocAdd

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_DocAttach($oAppl, $sString, $sMode = Default, $iCase = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	Local $bFound = False
	If $sMode = Default Then $sMode = "FilePath"
	If $iCase = Default Then $iCase = 0
	If Not IsObj($oAppl) Then Return SetError(1, 0, 0)
	If StringStripWS($sString, $STR_STRIPLEADING + $STR_STRIPTRAILING) = "" Then Return SetError(2, 0, 0)
	If $sMode <> "filepath" And $sMode <> "filename" And $sMode <> "text" Then Return SetError(3, 0, 0)
	For $oDoc In $oAppl.Documents
		Select
			Case $sMode = "filepath" And $oDoc.FullName = $sString
				$bFound = True
			Case $sMode = "filename" And $oDoc.Name = $sString
				$bFound = True
			Case $sMode = "text" And StringInStr($oDoc.Range().Text, $sString, $iCase)
				$bFound = True
		EndSelect
		If $bFound Then ExitLoop
	Next
	If Not $bFound Then Return SetError(4, 0, 0)
	Return $oDoc
EndFunc   ;==>_Word_DocAttach

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_DocClose($oDoc, $iSaveChanges = Default, $iOriginalFormat = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If $iSaveChanges = Default Then $iSaveChanges = $WdDoNotSaveChanges
	If $iOriginalFormat = Default Then $iOriginalFormat = $WdOriginalDocumentFormat
	If Not IsObj($oDoc) Then Return SetError(1, 0, 0)
	$oDoc.Close($iSaveChanges, $iOriginalFormat)
	If @error Then Return SetError(2, @error, 0)
	Return 1
EndFunc   ;==>_Word_DocClose

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified ......:
; ===============================================================================================================================
Func _Word_DocExport($oDoc, $sFileName, $iFormat = Default, $iRange = Default, $iFrom = Default, $iTo = Default, $bOpenAfterExport = Default, $bIncludeProperties = Default, $iCreateBookmarks = Default, $bUseISO19005 = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If Not IsObj($oDoc) Then Return SetError(1, 0, 0)
	If $sFileName = "" Then Return SetError(2, 0, 0)
	If $iFormat = Default Then $iFormat = $WdExportFormatPDF
	If $iRange = Default Then $iRange = $WdExportAllDocument
	If $bOpenAfterExport = Default Then $bOpenAfterExport = False
	If $bIncludeProperties = Default Then $bIncludeProperties = True
	If $bUseISO19005 = Default Then $bUseISO19005 = False
	If $iRange = $WdExportFromTo Then
		$oDoc.ExportAsFixedFormat($sFileName, $iFormat, $bOpenAfterExport, Default, Default, Default, $bIncludeProperties, Default, $iCreateBookmarks, Default, Default, $bUseISO19005) ; Export Range
	Else
		$oDoc.ExportAsFixedFormat($sFileName, $iFormat, $bOpenAfterExport, Default, $iRange, $iFrom, $iTo, Default, $bIncludeProperties, Default, $iCreateBookmarks, Default, Default, $bUseISO19005) ; Export document
	EndIf
	If @error Then Return SetError(3, @error, 0)
	Return 1
EndFunc   ;==>_Word_DocExport

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified ......:
; ===============================================================================================================================
Func _Word_DocFind($oDoc, $sFindText = Default, $vSearchRange = Default, $oFindRange = Default, $bForward = Default, $bMatchCase = Default, $bMatchWholeWord = Default, $bMatchWildcards = Default, $bMatchSoundsLike = Default, $bMatchAllWordForms = Default, $bFormat = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If $sFindText = Default Then $sFindText = ""
	If $vSearchRange = Default Then $vSearchRange = 0
	If $bForward = Default Then $bForward = True
	If $bMatchCase = Default Then $bMatchCase = False
	If $bMatchWholeWord = Default Then $bMatchWholeWord = False
	If $bMatchWildcards = Default Then $bMatchWildcards = False
	If $bMatchSoundsLike = Default Then $bMatchSoundsLike = False
	If $bMatchAllWordForms = Default Then $bMatchAllWordForms = False
	If $bFormat = Default Then $bFormat = False
	If Not IsObj($oDoc) Then Return SetError(1, 0, 0)
	Switch $vSearchRange
		Case -1
			$vSearchRange = $oDoc.Application.Selection.Range
		Case 0
			$vSearchRange = $oDoc.Range()
		Case Else
			If Not IsObj($vSearchRange) Then Return SetError(2, 0, 0)
	EndSwitch
	If $oFindRange = Default Then
		$oFindRange = $vSearchRange.Duplicate()
	Else
		If Not IsObj($oFindRange) Then Return SetError(3, 0, 0)
		If $bForward = True Then
			$oFindRange.Start = $oFindRange.End ; Search forward
			$oFindRange.End = $vSearchRange.End
		Else
			$oFindRange.End = $oFindRange.Start ; Search backward
			$oFindRange.Start = $vSearchRange.Start
		EndIf
	EndIf
	$oFindRange.Find.ClearFormatting()
	$oFindRange.Find.Execute($sFindText, $bMatchCase, $bMatchWholeWord, $bMatchWildcards, $bMatchSoundsLike, _
			$bMatchAllWordForms, $bForward, $WdFindStop, $bFormat)
	If @error Or Not $oFindRange.Find.Found Then Return SetError(4, @error, 0)
	Return $oFindRange
EndFunc   ;==>_Word_DocFind

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_DocFindReplace($oDoc, $sFindText = Default, $sReplaceWith = Default, $iReplace = Default, $vSearchRange = Default, $bMatchCase = Default, $bMatchWholeWord = Default, $bMatchWildcards = Default, $bMatchSoundsLike = Default, $bMatchAllWordForms = Default, $bForward = Default, $iWrap = Default, $bFormat = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If $sFindText = Default Then $sFindText = ""
	If $sReplaceWith = Default Then $sReplaceWith = ""
	If $iReplace = Default Then $iReplace = $WdReplaceAll
	If $vSearchRange = Default Then $vSearchRange = 0
	If $bMatchCase = Default Then $bMatchCase = False
	If $bMatchWholeWord = Default Then $bMatchWholeWord = False
	If $bMatchWildcards = Default Then $bMatchWildcards = False
	If $bMatchSoundsLike = Default Then $bMatchSoundsLike = False
	If $bMatchAllWordForms = Default Then $bMatchAllWordForms = False
	If $bForward = Default Then $bForward = True
	If $iWrap = Default Then $iWrap = $WdFindContinue
	If $bFormat = Default Then $bFormat = False
	If Not IsObj($oDoc) Then Return SetError(1, 0, 0)
	Switch $vSearchRange
		Case -1
			$vSearchRange = $oDoc.Application.Selection.Range
		Case 0
			$vSearchRange = $oDoc.Range()
		Case Else
			If Not IsObj($vSearchRange) Then Return SetError(2, 0, 0)
	EndSwitch
	Local $oFind = $vSearchRange.Find
	$oFind.ClearFormatting()
	$oFind.Replacement.ClearFormatting()
	Local $bReturn = $oFind.Execute($sFindText, $bMatchCase, $bMatchWholeWord, $bMatchWildcards, $bMatchSoundsLike, _
			$bMatchAllWordForms, $bForward, $iWrap, $bFormat, $sReplaceWith, $iReplace)
	If @error Or Not $bReturn Then Return SetError(3, @error, 0)
	Return 1
EndFunc   ;==>_Word_DocFindReplace

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_DocGet($oAppl, $vIndex = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If Not IsObj($oAppl) Then Return SetError(1, 0, 0)
	If $vIndex = Default Then $vIndex = -1
	Local $iCount = $oAppl.Documents.Count
	If @error Then Return SetError(4, @error, 0)
	If IsInt($vIndex) Then
		Local $oDocument
		Select
			Case $vIndex = -1
				Return SetError(0, $iCount, $oAppl.Documents)
			Case $vIndex = 0
				$oDocument = $oAppl.ActiveDocument
				If @error Then Return SetError(3, @error, 0)
				Return SetError(0, $iCount, $oDocument)
			Case $vIndex > 0 And $vIndex <= $iCount
				$oDocument = $oAppl.ActiveDocument
				If @error Then Return SetError(3, @error, 0)
				Return SetError(0, $iCount, $oDocument)
			Case Else
				Return SetError(2, 0, 0)
		EndSelect
	Else
		For $oDoc In $oAppl.Documents
			If $oDoc.Name = $vIndex Then Return SetError(0, $iCount, $oDoc)
		Next
		Return SetError(3, 0, 0)
	EndIf
EndFunc   ;==>_Word_DocGet

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_DocLinkAdd($oDoc, $oAnchor = Default, $sAddress = Default, $sSubAddress = Default, $sScreenTip = Default, $sTextToDisplay = Default, $sTarget = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If Not IsObj($oDoc) Then Return SetError(1, 0, 0)
	If $oAnchor = Default Then $oAnchor = $oDoc.Range()
	If Not IsObj($oAnchor) Then Return SetError(3, 0, 0)
	If $sAddress = Default Then $sAddress = $oDoc.FullName
	$oDoc.Hyperlinks.Add($oAnchor, $sAddress, $sSubAddress, $sScreenTip, $sTextToDisplay, $sTarget)
	If @error Then Return SetError(2, @error, 0)
	Return 1
EndFunc   ;==>_Word_DocLinkAdd

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_DocLinkGet($oDoc, $iIndex = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If Not IsObj($oDoc) Then Return SetError(1, 0, 0)
	If $iIndex <> Default And (Not IsInt($iIndex)) Then Return SetError(2, 0, 0)
	Local $iCount = $oDoc.Hyperlinks.Count
	If @error Then Return SetError(3, @error, 0)
	Select
		Case $iIndex = Default
			Return SetError(0, $iCount, $oDoc.Hyperlinks)
		Case $iIndex > 0 And $iIndex <= $iCount
			Return SetError(0, $iCount, $oDoc.Hyperlinks.Item($iIndex))
		Case Else
			Return SetError(2, 0, 0)
	EndSelect
EndFunc   ;==>_Word_DocLinkGet

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_DocOpen($oAppl, $sFilePath, $bConfirmConversions = Default, $iFormat = Default, $bReadOnly = Default, $bRevert = Default, $bAddToRecentFiles = Default, $sOpenPassword = Default, $sWritePassword = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If $bConfirmConversions = Default Then $bConfirmConversions = False
	If $iFormat = Default Then $iFormat = $WdOpenFormatAuto
	If $bReadOnly = Default Then $bReadOnly = False
	If $bRevert = Default Then $bRevert = False
	If $bAddToRecentFiles = Default Then $bAddToRecentFiles = False
	If $sOpenPassword = Default Then $sOpenPassword = ""
	If $sWritePassword = Default Then $sWritePassword = ""
	If Not IsObj($oAppl) Then Return SetError(1, 0, 0)
	If Not FileExists($sFilePath) Then Return SetError(2, 0, 0)
	If StringInStr($sFilePath, "\") = 0 Then $sFilePath = @ScriptDir & "\" & $sFilePath
	Local $oDoc = $oAppl.Documents.Open($sFilePath, $bConfirmConversions, $bReadOnly, $bAddToRecentFiles, _
			$sOpenPassword, "", $bRevert, $sWritePassword, "", $iFormat)
	If @error Or Not IsObj($oDoc) Then Return SetError(3, @error, 0)
	; If a read-write document was opened read-only then return an error
	If $bReadOnly = False And $oDoc.Readonly = True Then Return SetError(0, 1, $oDoc)
	Return $oDoc
EndFunc   ;==>_Word_DocOpen

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_DocPictureAdd($oDoc, $sFilePath, $bLinkToFile = Default, $bSaveWithDocument = Default, $oRange = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If $bLinkToFile = Default Then $bLinkToFile = False
	; Word docu is wrong. False isn't accepted. But Default is handled like False
	If $bSaveWithDocument = Default Then $bSaveWithDocument = Default
	If $oRange = Default Then $oRange = 0
	If Not IsObj($oDoc) Then Return SetError(1, 0, 0)
	If $oRange <> 0 And Not IsObj($oRange) Then Return SetError(4, 0, 0)
	If Not FileExists($sFilePath) Then Return SetError(2, 0, 0)
	Local $oShape
	If IsObj($oRange) Then
		$oShape = $oDoc.InlineShapes.AddPicture($sFilePath, $bLinkToFile, $bSaveWithDocument, $oRange)
	Else
		$oShape = $oDoc.InlineShapes.AddPicture($sFilePath, $bLinkToFile, $bSaveWithDocument)
	EndIf
	If @error Then Return SetError(3, @error, 0)
	Return $oShape
EndFunc   ;==>_Word_DocPictureAdd

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_DocPrint($oDoc, $bBackground = Default, $iCopies = Default, $iOrientation = Default, $bCollate = Default, $sPrinter = Default, $iRange = Default, $vFrom = Default, $vTo = Default, $sPages = Default, $iPageType = Default, $iItem = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If $bBackground = Default Then $bBackground = False
	If $iCopies = Default Then $iCopies = 1
	If $iOrientation = Default Then $iOrientation = -1
	If $bCollate = Default Then $bCollate = True
	If $sPrinter = Default Then $sPrinter = ""
	If $iRange = Default Then $iRange = $WdPrintAllDocument
	If $vFrom = Default Then $vFrom = ""
	If $vTo = Default Then $vTo = ""
	If $sPages = Default Then $sPages = ""
	If $iPageType = Default Then $iPageType = $WdPrintAllPages
	If $iItem = Default Then $iItem = $WdPrintDocumentContent
	If Not IsObj($oDoc) Then Return SetError(1, 0, 0)
	Local $iDocOrientation, $iError = 0, $iExtended = 0, $sActivePrinter
	; Set orientation
	If $iOrientation <> -1 Then
		$iDocOrientation = $oDoc.PageSetup.Orientation
		If $iDocOrientation <> $iOrientation Then
			$oDoc.PageSetup.Orientation = $iOrientation
			If @error Then Return SetError(2, @error, 0)
		EndIf
	EndIf
	; Set Printer
	If $sPrinter <> "" Then
		$sActivePrinter = $oDoc.Application.ActivePrinter
		$oDoc.Application.ActivePrinter = $sPrinter
		If @error Then
			$iError = 3
			$iExtended = @error
		EndIf
	EndIf
	; Print file
	If $iError = 0 Then
		$oDoc.PrintOut($bBackground, False, $iRange, "", $vFrom, $vTo, $iItem, $iCopies, $sPages, $iPageType, 0, $bCollate)
		If @error Then
			$iError = 4
			$iExtended = @error
		EndIf
	EndIf
	; Reset orientation if changed
	If $iOrientation <> -1 And $iDocOrientation <> $iOrientation Then
		$oDoc.PageSetup.Orientation = $iDocOrientation
	EndIf
	; Reset printer if changed
	If $sActivePrinter Then
		$oDoc.Application.ActivePrinter = $sActivePrinter
	EndIf
	; Return error if happened
	If $iError <> 0 Then Return SetError($iError, $iExtended, 0)
	Return 1
EndFunc   ;==>_Word_DocPrint

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified ......:
; ===============================================================================================================================
Func _Word_DocRangeSet($oDoc, $vRange, $iStartUnit = Default, $iStartCount = Default, $iEndUnit = Default, $iEndCount = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If $iStartUnit = Default Then $iStartUnit = $WdWord
	If $iEndUnit = Default Then $iEndUnit = $WdWord
	If Not IsObj($oDoc) Then Return SetError(1, 0, 0)
	If Not IsObj($vRange) And ($vRange < -2 Or $vRange > 0) Then Return SetError(2, 0, 0)
	If $vRange = -1 Then
		$vRange = $oDoc.Range ; Set range start/end at the start to the document
		$vRange.Collapse($WdCollapseStart)
	ElseIf $vRange = -2 Then
		$vRange = $oDoc.Range ; Set range start/end at the end to the document
		$vRange.Collapse($WdCollapseEnd)
	ElseIf $vRange = 0 Then
		$vRange = $oDoc.Parent.Selection.Range ; Use the current selection as range
	EndIf
	If $iStartUnit = -1 Then
		$vRange.Collapse($WdCollapseStart)
		If @error Then Return SetError(3, @error, 0)
	ElseIf $iStartCount <> Default Then
		$vRange.MoveStart($iStartUnit, $iStartCount)
		If @error Then Return SetError(3, @error, 0)
	EndIf
	If $iEndUnit = -1 Then
		$vRange.Collapse($WdCollapseEnd)
		If @error Then Return SetError(4, @error, 0)
	ElseIf $iEndCount <> Default Then
		$vRange.MoveEnd($iEndUnit, $iEndCount)
		If @error Then Return SetError(4, @error, 0)
	EndIf
	Return $vRange
EndFunc   ;==>_Word_DocRangeSet

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_DocSave($oDoc)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If Not IsObj($oDoc) Then Return SetError(1, 0, 0)
	If Not FileExists($oDoc.FullName) Then Return SetError(2, 0, 0)
	$oDoc.Save()
	If @error Then Return SetError(3, @error, 0)
	Return 1
EndFunc   ;==>_Word_DocSave

; #FUNCTION# ====================================================================================================================
; Author ........: water (based on the Word UDF written by Bob Anthony)
; Modified ......:
; ===============================================================================================================================
Func _Word_DocSaveAs($oDoc, $sFileName = Default, $iFileFormat = Default, $bReadOnlyRecommended = Default, $bAddToRecentFiles = Default, $sPassword = Default, $sWritePassword = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If $sFileName = Default Then $sFileName = ""
	If $iFileFormat = Default Then $iFileFormat = $WdFormatDocument
	If $bReadOnlyRecommended = Default Then $bReadOnlyRecommended = False
	If $bAddToRecentFiles = Default Then $bAddToRecentFiles = 0
	If $sPassword = Default Then $sPassword = ""
	If $sWritePassword = Default Then $sWritePassword = ""
	If Not IsObj($oDoc) Then Return SetError(1, 0, 0)
	$oDoc.SaveAs($sFileName, $iFileFormat, False, $sPassword, $bAddToRecentFiles, $sWritePassword, $bReadOnlyRecommended)
	If @error Then Return SetError(2, @error, 0)
	Return 1
EndFunc   ;==>_Word_DocSaveAs

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified ......:
; ===============================================================================================================================
Func _Word_DocTableRead($oDoc, $vTable, $iIndexBase = Default, $sDelimiter = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If $iIndexBase = Default Then $iIndexBase = 1
	If $sDelimiter = Default Then $sDelimiter = @TAB
	If Not IsObj($oDoc) Then Return SetError(1, 0, "")
	If Not IsObj($vTable) Then
		$vTable = $oDoc.Tables.Item($vTable)
		If @error Then Return SetError(2, @error, "")
	EndIf
	; Temporarly replace tabs and paragraphs in the table
	Local $asSeparators[2][2] = [[@TAB, "   "], [@CR, "|"]], $iTableRows, $iTableColumns, $iUndo = 1, $bFound = False
	$vTable.Range.Find.ClearFormatting
	If @error Then Return SetError(3, @error, "")
	$bFound = $vTable.Range.Find.Execute($asSeparators[0][0], False, False, False, False, False, True, $WdFindStop, False, $asSeparators[0][1], $WdReplaceAll)
	If $bFound Then $iUndo = $iUndo + 1
	$bFound = $vTable.Range.Find.Execute($asSeparators[1][0], False, False, False, False, False, True, $WdFindStop, False, $asSeparators[1][1], $WdReplaceAll)
	If $bFound Then $iUndo = $iUndo + 1
	$iTableRows = $vTable.Rows.Count()
	$iTableColumns = $vTable.Columns.Count()
	Local $asResult[$iTableRows + $iIndexBase][$iTableColumns], $asLines, $asColumns
	Local $oRange = $vTable.ConvertToText($sDelimiter, False)
	If @error Then Return SetError(4, @error, "")
	Local $sData = $oRange.Text
	$oDoc.Undo($iUndo) ; Undo the Find and ConvertToText function so the table remains unchanged in the document
	$asLines = StringSplit($sData, @CR, $STR_NOCOUNT)
	For $iIndex1 = 0 To $iTableRows - 1
		$asColumns = StringSplit($asLines[$iIndex1], $sDelimiter)
		For $iIndex2 = 1 To $asColumns[0]
			$asColumns[$iIndex2] = StringReplace($asColumns[$iIndex2], $asSeparators[0][1], $asSeparators[0][0])
			$asColumns[$iIndex2] = StringReplace($asColumns[$iIndex2], $asSeparators[1][1], $asSeparators[1][0])
			$asResult[$iIndex1 + $iIndexBase][$iIndex2 - 1] = $asColumns[$iIndex2]
		Next
	Next
	If $iIndexBase Then
		$asResult[0][0] = UBound($asResult, $UBOUND_ROWS) - 1
		If UBound($asResult, $UBOUND_COLUMNS) > 1 Then $asResult[0][1] = UBound($asResult, $UBOUND_COLUMNS)
	EndIf
	Return $asResult
EndFunc   ;==>_Word_DocTableRead

; #FUNCTION# ====================================================================================================================
; Author ........: water
; Modified ......:
; ===============================================================================================================================
Func _Word_DocTableWrite($oRange, ByRef $aArray, $iIndexBase = Default, $sDelimiter = Default)
	; Error handler, automatic cleanup at end of function
	Local $oError = ObjEvent("AutoIt.Error", "__Word_COMErrFunc")
	#forceref $oError

	If $iIndexBase = Default Then $iIndexBase = 1
	If $sDelimiter = Default Then $sDelimiter = @TAB
	If Not IsObj($oRange) Then Return SetError(1, 0, 0)
	If Not IsArray($aArray) Or UBound($aArray, $UBOUND_DIMENSIONS) > 2 Then Return SetError(2, 0, 0)
	Local $sData, $iUBound1, $iUBound2, $oTable
	$iUBound1 = UBound($aArray, $UBOUND_ROWS)
	If UBound($aArray, $UBOUND_DIMENSIONS) = 1 Then
		For $iIndex1 = $iIndexBase To $iUBound1 - 1
			$sData = $sData & $aArray[$iIndex1]
			If $iIndex1 <> $iUBound1 Then $sData = $sData & @CRLF
		Next
	Else
		$iUBound2 = UBound($aArray, $UBOUND_COLUMNS)
		For $iIndex1 = $iIndexBase To $iUBound1 - 1
			For $iIndex2 = 0 To $iUBound2 - 1
				$sData = $sData & $aArray[$iIndex1][$iIndex2]
				If $iIndex2 <> $iUBound2 - 1 Then $sData = $sData & $sDelimiter
			Next
			If $iIndex1 <> $iUBound1 - 1 Then $sData = $sData & @CRLF
		Next
	EndIf
	$oRange.Text = $sData
	If @error Then Return SetError(3, @error, 0)
	$oTable = $oRange.ConvertToTable($sDelimiter)
	If @error Then Return SetError(4, @error, 0)
	Return $oTable
EndFunc   ;==>_Word_DocTableWrite

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Word_CloseOnQuit
; Description ...: Sets or returns the state used to determine if the Word application can be closed by _Word_Quit.
; Syntax.........: __Word_CloseOnQuit ( [$bNewState = Default] )
; Parameters ....: $bNewState - True if the Word application was started by function _Word_Create
; Return values .: Success - Current state. Can be either True (Word will be closed by _Word_Quit) or
;                  +False (Word will not be closed by _Word_Quit)
; Author ........: Valik
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Word_CloseOnQuit($bNewState = Default)
	Static $bState = False
	If IsBool($bNewState) Then $bState = $bNewState
	Return $bState
EndFunc   ;==>__Word_CloseOnQuit

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Word_COMErrFunc
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
Func __Word_COMErrFunc()
	; Do nothing special, just check @error after suspect functions.
EndFunc   ;==>__Word_COMErrFunc
