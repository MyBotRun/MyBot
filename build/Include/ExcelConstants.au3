#include-once

; #INDEX# =======================================================================================================================
; Title .........: ExcelConstants
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Constants to be included in an AutoIt script when using the Excel UDF.
; Author(s) .....: water
; Resources .....: Excel 2010 Enumerations: http://msdn.microsoft.com/en-us/library/ff838815(v=office.14).aspx
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; XlAutoFilterOperator Enumeration. Specifies the operator to use to associate two criteria applied by a filter.
; See: http://msdn.microsoft.com/en-us/library/ff839625(v=office.14).aspx
Global Const $xlAnd = 1 ; Logical AND of Criteria1 and Criteria2
Global Const $xlBottom10Items = 4 ; Lowest-valued items displayed (number of items specified in Criteria1)
Global Const $xlBottom10Percent = 6 ; Lowest-valued items displayed (percentage specified in Criteria1)
Global Const $xlFilterCellColor = 8 ; Color of the cell
Global Const $xlFilterDynamic = 11 ; Dynamic filter
Global Const $xlFilterFontColor = 9 ; Color of the font
Global Const $xlFilterIcon = 10 ; Filter icon
Global Const $xlFilterValues = 7 ; Filter values
Global Const $xlOr = 2 ; Logical OR of Criteria1 or Criteria2
Global Const $xlTop10Items = 3 ; Highest-valued items displayed (number of items specified in Criteria1)
Global Const $xlTop10Percent = 5 ; Highest-valued items displayed (percentage specified in Criteria1)

; Constants Enumeration. This enumeration groups together constants used with various Excel methods.
; See: http://msdn.microsoft.com/en-us/library/ff197824(v=office.14).aspx
Global Const $xlCenter = -4108 ; Center
Global Const $xlLeft = -4131 ; Left
Global Const $xlRight = -4152 ; Right

; XlCalculation Enumeration. Specifies the calculation mode.
; See: http://msdn.microsoft.com/en-us/library/ff835845(v=office.14).aspx
Global Const $xlCalculationAutomatic = -4105 ; Excel controls recalculation
Global Const $xlCalculationManual = -4135 ; Calculation is done when the user requests it
Global Const $xlCalculationSemiautomatic = 2 ; Excel controls recalculation but ignores changes in tables

; XlCellType Enumeration. Specifies the type of cells.
; See: http://msdn.microsoft.com/en-us/library/ff836534(v=office.14).aspx
Global Const $xlCellTypeAllFormatConditions = -4172 ; Cells of any format
Global Const $xlCellTypeAllValidation = -4174 ; Cells having validation criteria
Global Const $xlCellTypeBlanks = 4 ; Empty cells
Global Const $xlCellTypeComments = -4144 ; Cells containing notes
Global Const $xlCellTypeConstants = 2 ; Cells containing constants
Global Const $xlCellTypeFormulas = -4123 ; Cells containing formulas
Global Const $xlCellTypeLastCell = 11 ; The last cell in the used range
Global Const $xlCellTypeSameFormatConditions = -4173 ; Cells having the same format
Global Const $xlCellTypeSameValidation = -4175 ; Cells having the same validation criteria
Global Const $xlCellTypeVisible = 12 ; All visible cells

; XlColumnDataType Enumeration. Specifies how a column is to be parsed.
; See: http://msdn.microsoft.com/en-us/library/ff193030(v=office.14).aspx
Global Const $xlDMYFormat = 4 ; DMY date format
Global Const $xlDYMFormat = 7 ; DYM date format
Global Const $xlEMDFormat = 10 ; EMD date format
Global Const $xlGeneralFormat = 1 ; General
Global Const $xlMDYFormat = 3 ; MDY date format
Global Const $xlMYDFormat = 6 ; MYD date format
Global Const $xlSkipColumn = 9 ; Column is not parsed
Global Const $xlTextFormat = 2 ; Text
Global Const $xlYDMFormat = 8 ; YDM date format
Global Const $xlYMDFormat = 5 ; YMD date format

; XlDeleteShiftDirection Enumeration. Specifies how to shift cells to replace deleted cells.
; See: http://msdn.microsoft.com/en-us/library/ff841140(v=office.14).aspx
Global Const $xlShiftToLeft = -4159 ; Cells are shifted to the left
Global Const $xlShiftUp = -4162 ; Cells are shifted up

; XlDVAlertStyle Enumeration. Specifies the icon used in message boxes displayed during validation.
; See: http://msdn.microsoft.com/en-us/library/ff841223(v=office.14).aspx
Global Const $xlValidAlertInformation = 3 ; Information icon
Global Const $xlValidAlertStop = 1 ; Stop icon
Global Const $xlValidAlertWarning = 2 ; Warning icon

; XlDVType Enumeration. Specifies the type of validation test to be performed in conjunction with values.
; See: http://msdn.microsoft.com/en-us/library/ff840715(v=office.14).aspx
Global Const $xlValidateCustom = 7 ; Data is validated using an arbitrary formula
Global Const $xlValidateDate = 4 ; Date values
Global Const $xlValidateDecimal = 2 ; Numeric values
Global Const $xlValidateInputOnly = 0 ; Validate only when user changes the value
Global Const $xlValidateList = 3 ; Value must be present in a specified list
Global Const $xlValidateTextLength = 6 ; Length of text
Global Const $xlValidateTime = 5 ; Time values
Global Const $xlValidateWholeNumber = 1 ; Whole numeric values

; XlDynamicFilterCriteria Enumeration. Specifies the filter criterion.
; See: http://msdn.microsoft.com/en-us/library/ff840134(v=office.14).aspx
Global Const $xlFilterAboveAverage = 33 ; Filter all above-average values
Global Const $xlFilterAllDatesInPeriodApril = 24 ; Filter all dates in April
Global Const $xlFilterAllDatesInPeriodAugust = 28 ; Filter all dates in August
Global Const $xlFilterAllDatesInPeriodDecember = 32 ; Filter all dates in December
Global Const $xlFilterAllDatesInPeriodFebruray = 22 ; Filter all dates in February
Global Const $xlFilterAllDatesInPeriodJanuary = 21 ; Filter all dates in January
Global Const $xlFilterAllDatesInPeriodJuly = 27 ; Filter all dates in July
Global Const $xlFilterAllDatesInPeriodJune = 26 ; Filter all dates in June
Global Const $xlFilterAllDatesInPeriodMarch = 23 ; Filter all dates in March
Global Const $xlFilterAllDatesInPeriodMay = 25 ; Filter all dates in May
Global Const $xlFilterAllDatesInPeriodNovember = 31 ; Filter all dates in November
Global Const $xlFilterAllDatesInPeriodOctober = 30 ; Filter all dates in October
Global Const $xlFilterAllDatesInPeriodQuarter1 = 17 ; Filter all dates in Quarter1
Global Const $xlFilterAllDatesInPeriodQuarter2 = 18 ; Filter all dates in Quarter2
Global Const $xlFilterAllDatesInPeriodQuarter3 = 19 ; Filter all dates in Quarter3
Global Const $xlFilterAllDatesInPeriodQuarter4 = 20 ; Filter all dates in Quarter4
Global Const $xlFilterAllDatesInPeriodSeptember = 29 ; Filter all dates in September
Global Const $xlFilterBelowAverage = 34 ; Filter all below-average values
Global Const $xlFilterLastMonth = 8 ; Filter all values related to last month
Global Const $xlFilterLastQuarter = 11 ; Filter all values related to last quarter
Global Const $xlFilterLastWeek = 5 ; Filter all values related to last week
Global Const $xlFilterLastYear = 14 ; Filter all values related to last year
Global Const $xlFilterNextMonth = 9 ; Filter all values related to next month
Global Const $xlFilterNextQuarter = 12 ; Filter all values related to next quarter
Global Const $xlFilterNextWeek = 6 ; Filter all values related to next week
Global Const $xlFilterNextYear = 15 ; Filter all values related to next year
Global Const $xlFilterThisMonth = 7 ; Filter all values related to the current month
Global Const $xlFilterThisQuarter = 10 ; Filter all values related to the current quarter
Global Const $xlFilterThisWeek = 4 ; Filter all values related to the current week
Global Const $xlFilterThisYear = 13 ; Filter all values related to the current year
Global Const $xlFilterToday = 1 ; Filter all values related to the current date
Global Const $xlFilterTomorrow = 3 ; Filter all values related to tomorrow
Global Const $xlFilterYearToDate = 16 ; Filter all values from today until a year ago
Global Const $xlFilterYesterday = 2 ; Filter all values related to yesterday

; XlFileFormat Enumeration. Specifies the file format when saving the worksheet.
; See: http://msdn.microsoft.com/en-us/library/ff198017(v=office.14).aspx
Global Const $xlAddIn = 18 ; Microsoft Excel 97-2003 Add-In
Global Const $xlAddIn8 = 18 ; Microsoft Excel 97-2003 Add-In
Global Const $xlCSV = 6 ; CSV
Global Const $xlCSVMac = 22 ; Macintosh CSV
Global Const $xlCSVMSDOS = 24 ; MSDOS CSV
Global Const $xlCSVWindows = 23 ; Windows CSV
Global Const $xlCurrentPlatformText = -4158 ; Current Platform Text
Global Const $xlDBF2 = 7 ; DBF2
Global Const $xlDBF3 = 8 ; DBF3
Global Const $xlDBF4 = 11 ; DBF4
Global Const $xlDIF = 9 ; DIF
Global Const $xlExcel12 = 50 ; Excel12 (Excel Binary Workbook in 2007 with or without macro’s, .xlsb)
Global Const $xlExcel2 = 16 ; Excel2
Global Const $xlExcel2FarEast = 27 ; Excel2 FarEast
Global Const $xlExcel3 = 29 ; Excel3
Global Const $xlExcel4 = 33 ; Excel4
Global Const $xlExcel4Workbook = 35 ; Excel4 Workbook
Global Const $xlExcel5 = 39 ; Excel5
Global Const $xlExcel7 = 39 ; Excel7
Global Const $xlExcel8 = 56 ; Excel8 (97-2003 format in Excel 2007, .xls)
Global Const $xlExcel9795 = 43 ; Excel9795
Global Const $xlHtml = 44 ; HTML format
Global Const $xlIntlAddIn = 26 ; International Add-In
Global Const $xlIntlMacro = 25 ; International Macro
Global Const $xlOpenDocumentSpreadsheet = 60 ; OpenDocument Spreadsheet
Global Const $xlOpenXMLAddIn = 55 ; Open XML Add-In
Global Const $xlOpenXMLTemplate = 54 ; Open XML Template
Global Const $xlOpenXMLTemplateMacroEnabled = 53 ; Open XML Template Macro Enabled
Global Const $xlOpenXMLWorkbook = 51 ; Open XML Workbook (without macro’s in 2007, .xlsx)
Global Const $xlOpenXMLWorkbookMacroEnabled = 52 ; Open XML Workbook Macro Enabled (with or without macro’s in 2007, .xlsm)
Global Const $xlSYLK = 2 ; SYLK
Global Const $xlTemplate = 17 ; Template
Global Const $xlTemplate8 = 17 ; Template 8
Global Const $xlTextMac = 19;  Macintosh Text
Global Const $xlTextMSDOS = 21 ; MSDOS Text
Global Const $xlTextPrinter = 36 ; Printer Text
Global Const $xlTextWindows = 20 ; Windows Text
Global Const $xlUnicodeText = 42 ; Unicode Text
Global Const $xlWebArchive = 45 ; Web Archive
Global Const $xlWJ2WD1 = 14 ; WJ2WD1
Global Const $xlWJ3 = 40 ; WJ3
Global Const $xlWJ3FJ3 = 41 ; WJ3FJ3
Global Const $xlWK1 = 5 ; WK1
Global Const $xlWK1ALL = 31 ; WK1ALL
Global Const $xlWK1FMT = 30 ; WK1FMT
Global Const $xlWK3 = 15 ; WK3
Global Const $xlWK3FM3 = 32 ; WK3FM3
Global Const $xlWK4 = 38; WK4
Global Const $xlWKS = 4 ; Worksheet
Global Const $xlWorkbookDefault = 51 ; Workbook default (.xls for < Excel 2007, .xlsx for > Excel 2007)
Global Const $xlWorkbookNormal = -4143 ; Workbook normal
Global Const $xlWorks2FarEast = 28 ; Works2 FarEast
Global Const $xlWQ1 = 34 ; WQ1
Global Const $xlXMLSpreadsheet = 46 ; XML Spreadsheet

; XlFindLookIn Enumeration. Specifies the type of data to search.
; See: http://msdn.microsoft.com/en-us/library/ff822180(v=office.14).aspx
Global Const $xlComments = -4144 ; Comments
Global Const $xlFormulas = -4123 ; Formulas
Global Const $xlValues = -4163 ; Values

; XlFixedFormatQuality Enumeration. Specifies the quality of speadsheets saved in different fixed formats.
; See: http://msdn.microsoft.com/en-us/library/ff838396(v=office.14).aspx
Global Const $xlQualityMinimum = 1 ; Minimum quality
Global Const $xlQualityStandard = 0 ; Standard quality

; XlFixedFormatType Enumeration. Specifies the type of file format.
; See: http://msdn.microsoft.com/en-us/library/ff195006(v=office.14).aspx
Global Const $xlTypePDF = 0 ; "PDF" — Portable Document Format file (.pdf)
Global Const $xlTypeXPS = 1 ; "XPS" — XPS Document (.xps)

; XlFormatConditionOperator Enumeration. Specifies the operator to use to compare a formula against the value in a cell or, for xlBetween and xlNotBetween, to compare two formulas.
; See: http://msdn.microsoft.com/en-us/library/ff840923(v=office.14).aspx
Global Const $xlBetween = 1 ; Between. Can be used only if two formulas are provided
Global Const $xlEqual = 3 ; Equal
Global Const $xlGreater = 5 ; Greater than
Global Const $xlGreaterEqual = 7 ; Greater than or equal to
Global Const $xlLess = 6 ; Less than
Global Const $xlLessEqual = 8 ; Less than or equal to
Global Const $xlNotBetween = 2 ; Not between. Can be used only if two formulas are provided
Global Const $xlNotEqual = 4 ; Not equal

; XlInsertFormatOrigin Enumeration: Specifies from where to copy the format for inserted rows.
; See: http://msdn.microsoft.com/en-us/library/ff195129(v=office.14).aspx
Global Const $xlFormatFromLeftOrAbove = 0 ; Copy the format from cells above and/or to the left
Global Const $xlFormatFromRightOrBelow = 1 ; Copy the format from cells below and/or to the right

; XlInsertShiftDirection Enumeration. Specifies the direction in which to shift cells during an insertion.
; See: http://msdn.microsoft.com/en-us/library/ff837618(v=office.14).aspx
Global Const $xlShiftDown = -4121 ; Shift cells down
Global Const $xlShiftToRight = -4161 ; Shift cells to the right

; XlLookAt Enumeration. Specifies whether a match is made against the whole of the search text or any part of the search text.
; See: http://msdn.microsoft.com/en-us/library/ff823160(v=office.14).aspx
Global Const $xlPart = 2 ; Match against any part of the search text
Global Const $xlWhole = 1 ; Match against the whole of the search text

; XlPasteSpecialOperation Enumeration. Specifies how numeric data will be calculated with the destinations cells in the worksheet
; See: http://msdn.microsoft.com/en-us/library/ff838010(v=office.14).aspx
Global Const $xlPasteSpecialOperationAdd = 2 ; Copied data will be added with the value in the destination cell
Global Const $xlPasteSpecialOperationDivide = 5 ; Copied data will be divided with the value in the destination cell
Global Const $xlPasteSpecialOperationMultiply = 4 ; Copied data will be multiplied with the value in the destination cell
Global Const $xlPasteSpecialOperationNone = -4142 ; No calculation will be done in the paste operation
Global Const $xlPasteSpecialOperationSubtract = 3 ; Copied data will be subtracted with the value in the destination cell

; XlPasteType Enumeration. Specifies the part of the range to be pasted.
; See: http://msdn.microsoft.com/en-us/library/ff837425(v=office.14).aspx
Global Const $xlPasteAll = -4104 ; Everything will be pasted
Global Const $xlPasteAllExceptBorders = 7 ; Everything except borders will be pasted
Global Const $xlPasteAllMergingConditionalFormats = 14 ; Everything will be pasted and conditional formats will be merged
Global Const $xlPasteAllUsingSourceTheme = 13 ; Everything will be pasted using the source theme
Global Const $xlPasteColumnWidths = 8 ; Copied column width is pasted
Global Const $xlPasteComments = -4144 ; Comments are pasted
Global Const $xlPasteFormats = -4122 ; Copied source format is pasted
Global Const $xlPasteFormulas = -4123 ; Formulas are pasted
Global Const $xlPasteFormulasAndNumberFormats = 11 ; Formulas and Number formats are pasted
Global Const $xlPasteValidation = 6 ; Validations are pasted
Global Const $xlPasteValues = -4163 ; Values are pasted
Global Const $xlPasteValuesAndNumberFormats = 12 ; Values and Number formats are pasted

; XlPlatform Enumeration. Specifies the platform on which a text file originated.
; See: http://msdn.microsoft.com/en-us/library/ff197617(v=office.14).aspx
Global Const $xlMacintosh = 1 ; Macintosh
Global Const $xlMSDOS = 3 ; MS-DOS
Global Const $xlWindows = 2 ; Microsoft Windows

; XlReferenceStyle Enumeration. Specifies the reference style.
; See: http://msdn.microsoft.com/en-us/library/ff821207(v=office.14).aspx
Global Const $xlA1 = 1 ; Default. Use xlA1 to return an A1-style reference
Global Const $xlR1C1 = -4150 ; Use xlR1C1 to return an R1C1-style reference

; XlReferenceType Enumeration. Specifies cell reference style when a formula is being converted.
; See: http://msdn.microsoft.com/en-us/library/ff837117(v=office.14).aspx
Global Const $xlAbsolute = 1 ; Convert to absolute row and column style
Global Const $xlAbsRowRelColumn = 2 ; Convert to absolute row and relative column style
Global Const $xlRelative = 4 ; Convert to relative row and column style
Global Const $xlRelRowAbsColumn = 3 ; Convert to relative row and absolute column style

; xlSheetVisibility Enumeration. Specifies whether the object is visible.
; See: http://msdn.microsoft.com/en-us/library/ff821673(v=office.14).aspx
Global Const $xlSheetHidden = 0 ; Hides the worksheet which the user can unhide via menu
Global Const $xlSheetVeryHidden = 2 ; Hides the object so that the only way for you to make it visible again is by setting this property to True (the user cannot make the object visible)
Global Const $xlSheetVisible = -1 ; Displays the sheet

; XlSortDataOption Enumeration. Specifies how to sort text.
; See: http://msdn.microsoft.com/en-us/library/ff821069(v=office.14).aspx
Global Const $xlSortNormal = 0 ; Sorts numeric and text data separately
Global Const $xlSortTextAsNumbers = 1 ; Treat text as numeric data for the sort

; XlSortOrder Enumeration. Specifies the sort order for the specified field or range.
; See: http://msdn.microsoft.com/en-us/library/ff834316(v=office.14).aspx
Global Const $xlAscending = 1 ; Sorts the specified field in ascending order
Global Const $xlDescending = 2 ; Sorts the specified field in descending order

; XlSortOn Enumeration. Specifies the parameter on which the data should be sorted.
; See: http://msdn.microsoft.com/en-us/library/ff839572(v=office.14).aspx
Global Const $xlSortOnCellColor = 1 ; Cell color
Global Const $xlSortOnFontColor = 2 ; Font color
Global Const $xlSortOnIcon = 3 ; Icon
Global Const $xlSortOnValues = 0 ; Values

; XlSortOrientation Enumeration. Specifies the sort orientation.
; See: http://msdn.microsoft.com/en-us/library/ff839607(v=office.14).aspx
Global Const $xlSortColumns = 1 ; Sorts by column
Global Const $xlSortRows = 2 ; Sorts by row. This is the default value

; XlTextParsingType Enumeration. Specifies the column format for the data in the text file that you are importing into a query table.
; See: http://msdn.microsoft.com/en-us/library/ff822876(v=office.14).aspx
Global Const $xlDelimited = 1 ; Default. Indicates that the file is delimited by delimiter characters
Global Const $xlFixedWidth = 2 ; Indicates that the data in the file is arranged in columns of fixed widths

; XlTextQualifier Enumeration. Specifies the delimiter to use to specify text.
; See: http://msdn.microsoft.com/en-us/library/ff838376(v=office.14).aspx
Global Const $xlTextQualifierDoubleQuote = 1 ; Double quotation mark (")
Global Const $xlTextQualifierNone = -4142 ; No delimiter
Global Const $xlTextQualifierSingleQuote = 2 ; Single quotation mark (')

; XlYesNoGuess Enumeration. Specifies whether or not the first row contains headers.
; See: http://msdn.microsoft.com/en-us/library/ff838812(v=office.14).aspx
Global Const $xlGuess = 0 ; Excel determines whether there is a header, and where it is, if there is one
Global Const $xlNo = 2 ; Default. The entire range should be sorted
Global Const $xlYes = 1 ; The entire range should not be sorted
; ===============================================================================================================================
