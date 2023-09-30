#include-once

; #INDEX# =======================================================================================================================
; Title .........: WordConstants
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Constants to be included in an AutoIt script when using the Word UDF.
; Author(s) .....: water
; Resources .....: Word 2007 Enumerations:  http://msdn.microsoft.com/en-us/library/ee426857%28v=office.12%29
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; WdBreakType Enumeration. Specifies type of break.
; See: http://msdn.microsoft.com/en-us/library/bb213704%28v=office.12%29
Global Const $WdColumnBreak = 8 ; Column break at the insertion point
Global Const $WdLineBreak = 6 ; Line break
Global Const $WdLineBreakClearLeft = 9 ; Line break
Global Const $WdLineBreakClearRight = 10 ; Line break
Global Const $WdPageBreak = 7 ; Page break at the insertion point
Global Const $WdSectionBreakContinuous = 3 ; New section without a corresponding page break
Global Const $WdSectionBreakEvenPage = 4 ; Section break with the next section beginning on the next even-numbered page. If the section break falls on an even-numbered page, Word leaves the next odd-numbered page blank
Global Const $WdSectionBreakNextPage = 2 ; Section break on next page
Global Const $WdSectionBreakOddPage = 5 ; Section break with the next section beginning on the next odd-numbered page. If the section break falls on an odd-numbered page, Word leaves the next even-numbered page blank
Global Const $WdTextWrappingBreak = 11 ; Ends the current line and forces the text to continue below a picture, table, or other item. The text continues on the next blank line that does not contain a table aligned with the left or right margin

; MsoDocProperties Enumeration. Specifies the data type for a document property.
; See: http://msdn.microsoft.com/en-us/library/aa432509(v=office.12)
Global Const $msoPropertyTypeBoolean = 2 ; Boolean value
Global Const $msoPropertyTypeDate = 3 ; Date value
Global Const $msoPropertyTypeFloat = 5 ; Floating point value
Global Const $msoPropertyTypeNumber = 1 ; Integer value
Global Const $msoPropertyTypeString = 4 ; String value

; WdCollapseDirection Enumeration. Specifies the direction in which to collapse a range or selection.
; See: http://msdn.microsoft.com/en-us/library/bb237551%28v=office.12%29
Global Const $WdCollapseEnd = 0 ; Collapse the range to the ending point
Global Const $WdCollapseStart = 1 ; Collapse the range to the starting point

; WdExportFormat Enumeration. Specifies format to use for exporting a document.
; See: http://msdn.microsoft.com/en-us/library/bb243311%28v=office.12%29.aspx
Global Const $WdExportFormatPDF = 17 ; Export document into PDF format
Global Const $WdExportFormatXPS = 18 ; Export document into XML Paper Specification (XPS) format

; WdExportRange Enumeration. Specifies how much of the document to export.
; See: http://msdn.microsoft.com/en-us/library/bb243314%28v=office.12%29.aspx
Global Const $WdExportAllDocument = 0 ; Exports the entire document
Global Const $WdExportCurrentPage = 2 ; Exports the current page
Global Const $WdExportFromTo = 3 ; Exports the contents of a range using the starting and ending positions
Global Const $WdExportSelection = 1 ; Exports the contents of the current selection

; WdFindWrap Enumeration. Specifies wrap behavior if a selection or range is specified for a find operation and the search text isn't found in the selection or range.
; See: http://msdn.microsoft.com/en-us/library/bb213734%28v=office.12%29
Global Const $WdFindAsk = 2 ; After searching the selection or range, Microsoft Word displays a message asking whether to search the remainder of the document
Global Const $WdFindContinue = 1 ; The find operation continues if the beginning or end of the search range is reached
Global Const $WdFindStop = 0 ; The find operation ends if the beginning or end of the search range is reached

; WdNewDocumentType Enumeration. Specifies the type of new document to create.
; See: http://msdn.microsoft.com/en-us/library/bb237823%28v=office.12%29.aspx
Global Const $WdNewBlankDocument = 0 ; Blank document
Global Const $WdNewEmailMessage = 2 ; E-mail message
Global Const $WdNewFrameset = 3 ; Frameset
Global Const $WdNewWebPage = 1 ; Web page
Global Const $WdNewXMLDocument = 4 ; XML document

; WdOpenFormat Enumeration. Specifies the format to use when opening a document.
; See: http://msdn.microsoft.com/en-us/library/bb237872%28v=office.12%29
Global Const $WdOpenFormatAllWord = 6 ; A Microsoft Office Word format that is backward compatible with earlier versions of Word
Global Const $WdOpenFormatAuto = 0 ; The existing format
Global Const $WdOpenFormatDocument = 1 ; Word format
Global Const $WdOpenFormatEncodedText = 5 ; Encoded text format
Global Const $WdOpenFormatRTF = 3 ; Rich text format (RTF)
Global Const $WdOpenFormatTemplate = 2 ; As a Word template
Global Const $WdOpenFormatText = 4 ; Unencoded text format
Global Const $WdOpenFormatUnicodeText = 5 ; Unicode text format
Global Const $WdOpenFormatWebPages = 7 ; HTML format
Global Const $WdOpenFormatXML = 8 ; XML format
Global Const $WdOpenFormatAllWordTemplates = 13 ; Word template format
Global Const $WdOpenFormatDocument97 = 1 ; Microsoft Word 97 document format
Global Const $WdOpenFormatTemplate97 = 2 ; Word 97 template format
Global Const $WdOpenFormatXMLDocument = 9 ; XML document format
Global Const $WdOpenFormatXMLDocumentMacroEnabled = 10 ; XML document format with macros enabled
Global Const $WdOpenFormatXMLTemplate = 11 ; XML template format
Global Const $WdOpenFormatXMLTemplateMacroEnabled = 12 ; XML template format with macros enabled

; WdOrientation Enumeration. Specifies a page layout orientation.
; See: http://msdn.microsoft.com/en-us/library/bb237879%28v=office.12%29.aspx
Global Const $WdOrientLandscape = 1 ; Landscape orientation
Global Const $WdOrientPortrait = 0 ; Portrait orientation

; WdOriginalFormat Enumeration. Specifies the document format. This enumeration is commonly used when saving a document.
; See: http://msdn.microsoft.com/en-us/library/bb237886%28v=office.12%29.aspx
Global Const $WdOriginalDocumentFormat = 1 ; Original document format
Global Const $WdPromptUser = 2 ; Prompt user to select a document format
Global Const $WdWordDocument = 0 ; Microsoft Word document format

; WdPrintOutItem Enumeration. Specifies the item to print.
; See: http://msdn.microsoft.com/en-us/library/bb237945%28v=office.12%29
Global Const $WdPrintAutoTextEntries = 4 ; Autotext entries in the current document
Global Const $WdPrintComments = 2 ; Comments in the current document
Global Const $WdPrintDocumentContent = 0 ; Current document content
Global Const $WdPrintDocumentWithMarkup = 7 ; Current document content including markup
Global Const $WdPrintEnvelope = 6 ; An envelope
Global Const $WdPrintKeyAssignments = 5 ; Key assignments in the current document
Global Const $WdPrintMarkup = 2 ; Markup in the current document
Global Const $WdPrintProperties = 1 ; Properties in the current document
Global Const $WdPrintStyles = 3 ; Styles in the current document

; WdPrintOutPages Enumeration. Specifies the type of pages to print.
; See: http://msdn.microsoft.com/en-us/library/bb237950%28v=office.12%29
Global Const $WdPrintAllPages = 0 ; All pages
Global Const $WdPrintEvenPagesOnly = 2 ; Even-numbered pages only
Global Const $WdPrintOddPagesOnly = 1 ; Odd-numbered pages only

; WdPrintOutRange Enumeration. Specifies a range to print.
; See: http://msdn.microsoft.com/en-us/library/bb237956%28v=office.12%29
Global Const $WdPrintAllDocument = 0 ; The entire document
Global Const $WdPrintCurrentPage = 2 ; The current page
Global Const $WdPrintFromTo = 3 ; A specified range
Global Const $WdPrintRangeOfPages = 4 ; A specified range of pages
Global Const $WdPrintSelection = 1 ; The current selection

; WdReplace Enumeration. Specifies the number of replacements to be made when find and replace is used.
; See: http://msdn.microsoft.com/en-us/library/bb238124%28v=office.12%29.aspx
Global Const $WdReplaceAll = 2 ; Replace all occurrences
Global Const $WdReplaceNone = 0 ; Replace no occurrences
Global Const $WdReplaceOne = 1 ; Replace the first occurrence encountered

; WdSaveFormat Enumeration. Specifies the format to use when saving a document.
; See: http://msdn.microsoft.com/en-us/library/bb238158%28v=office.12%29
Global Const $WdFormatDocument = 0 ; Microsoft Office Word format
Global Const $WdFormatDOSText = 4 ; Microsoft DOS text format
Global Const $WdFormatDOSTextLineBreaks = 5 ; Microsoft DOS text with line breaks preserved
Global Const $WdFormatEncodedText = 7 ; Encoded text format
Global Const $WdFormatFilteredHTML = 10 ; Filtered HTML format
Global Const $WdFormatHTML = 8 ; Standard HTML format
Global Const $WdFormatRTF = 6 ; Rich text format (RTF)
Global Const $WdFormatTemplate = 1 ; Word template format
Global Const $WdFormatText = 2 ; Microsoft Windows text format
Global Const $WdFormatTextLineBreaks = 3 ; Windows text format with line breaks preserved
Global Const $WdFormatUnicodeText = 7 ; Unicode text format
Global Const $WdFormatWebArchive = 9 ; Web archive format
Global Const $WdFormatXML = 11 ; Extensible Markup Language (XML) format
Global Const $WdFormatDocument97 = 0 ; Microsoft Word 97 document format
Global Const $WdFormatDocumentDefault = 16; Word default document file format. For Microsoft Office Word 2007, this is the DOCX format
Global Const $WdFormatPDF = 17 ; PDF format
Global Const $WdFormatTemplate97 = 1 ; Word 97 template format
Global Const $WdFormatXMLDocument = 12 ; XML document format
Global Const $WdFormatXMLDocumentMacroEnabled = 13 ; XML document format with macros enabled
Global Const $WdFormatXMLTemplate = 14 ; XML template format
Global Const $WdFormatXMLTemplateMacroEnabled = 15 ; XML template format with macros enabled
Global Const $WdFormatXPS = 18 ; XPS format

; WdSaveOptions Enumeration. Specifies how pending changes should be handled.
; See: http://msdn.microsoft.com/en-us/library/bb238160%28v=office.12%29.aspx
Global Const $WdDoNotSaveChanges = 0 ; Do not save pending changes
Global Const $WdPromptToSaveChanges = -2 ; Prompt the user to save pending changes
Global Const $WdSaveChanges = -1 ; Save pending changes automatically without prompting the user

; WdUnits Enumeration. Specifies a unit of measure to use.
; See: http://msdn.microsoft.com/en-us/library/bb214015%28v=office.12%29.aspx
Global Const $WdCell = 12 ; A cell
Global Const $WdCharacter = 1 ; A character
Global Const $WdCharacterFormatting = 13 ; Character formatting
Global Const $WdColumn = 9 ; A column
Global Const $WdItem = 16 ; The selected item
Global Const $WdLine = 5 ; A line
Global Const $WdParagraph = 4 ; A paragraph
Global Const $WdParagraphFormatting = 14 ; Paragraph formatting
Global Const $WdRow = 10 ; A row
Global Const $WdScreen = 7 ; The screen dimensions
Global Const $WdSection = 8 ; A section
Global Const $WdSentence = 3 ; A sentence
Global Const $WdStory = 6 ; A story
Global Const $WdTable = 15 ; A table
Global Const $WdWindow = 11 ; A window
Global Const $WdWord = 2 ; A word
; ===============================================================================================================================
