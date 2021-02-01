#include-once

#include "Clipboard.au3"
#include "EditConstants.au3"
#include "FileConstants.au3"
#include "RichEditConstants.au3"
#include "SendMessage.au3"
#include "StructureConstants.au3"
#include "UDFGlobalID.au3"

; #INDEX# =======================================================================================================================
; Title .........: Rich Edit
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Programmer-friendly Rich Edit control
; Author(s) .....: GaryFrost, grham, Prog@ndy, KIP, c.haslam
; OLE stuff .....: example from http://www.powerbasic.com/support/pbforums/showpost.php?p=294112&postcount=7
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================

Global $__g_sRTFClassName, $__g_sRTFVersion, $__g_iRTFTwipsPeSpaceUnit = 1440 ; inches
Global $__g_sGRE_CF_RTF, $__g_sGRE_CF_RETEXTOBJ
Global $__g_pGRC_StreamFromFileCallback = DllCallbackRegister("__GCR_StreamFromFileCallback", "dword", "long_ptr;ptr;long;ptr")
Global $__g_pGRC_StreamFromVarCallback = DllCallbackRegister("__GCR_StreamFromVarCallback", "dword", "long_ptr;ptr;long;ptr")
Global $__g_pGRC_StreamToFileCallback = DllCallbackRegister("__GCR_StreamToFileCallback", "dword", "long_ptr;ptr;long;ptr")
Global $__g_pGRC_StreamToVarCallback = DllCallbackRegister("__GCR_StreamToVarCallback", "dword", "long_ptr;ptr;long;ptr")
Global $__g_pGRC_sStreamVar
Global $__g_hRELastWnd
; Functions translated from http://www.powerbasic.com/support/pbforums/showpost.php?p=294112&postcount=7
; by Prog@ndy
Global $__g_tObj_RichComObject = DllStructCreate("ptr pIntf; dword  Refcount")
Global $__g_tCall_RichCom, $__g_pObj_RichCom
Global $__g_hLib_RichCom_OLE32 = DllOpen("OLE32.DLL")
Global $__g_pRichCom_Object_QueryInterface = DllCallbackRegister("__RichCom_Object_QueryInterface", "long", "ptr;dword;dword")
Global $__g_pRichCom_Object_AddRef = DllCallbackRegister("__RichCom_Object_AddRef", "long", "ptr")
Global $__g_pRichCom_Object_Release = DllCallbackRegister("__RichCom_Object_Release", "long", "ptr")
Global $__g_pRichCom_Object_GetNewStorage = DllCallbackRegister("__RichCom_Object_GetNewStorage", "long", "ptr;ptr")
Global $__g_pRichCom_Object_GetInPlaceContext = DllCallbackRegister("__RichCom_Object_GetInPlaceContext", "long", "ptr;dword;dword;dword")
Global $__g_pRichCom_Object_ShowContainerUI = DllCallbackRegister("__RichCom_Object_ShowContainerUI", "long", "ptr;long")
Global $__g_pRichCom_Object_QueryInsertObject = DllCallbackRegister("__RichCom_Object_QueryInsertObject", "long", "ptr;dword;ptr;long")
Global $__g_pRichCom_Object_DeleteObject = DllCallbackRegister("__RichCom_Object_DeleteObject", "long", "ptr;ptr")
Global $__g_pRichCom_Object_QueryAcceptData = DllCallbackRegister("__RichCom_Object_QueryAcceptData", "long", "ptr;ptr;dword;dword;dword;ptr")
Global $__g_pRichCom_Object_ContextSensitiveHelp = DllCallbackRegister("__RichCom_Object_ContextSensitiveHelp", "long", "ptr;long")
Global $__g_pRichCom_Object_GetClipboardData = DllCallbackRegister("__RichCom_Object_GetClipboardData", "long", "ptr;ptr;dword;ptr")
Global $__g_pRichCom_Object_GetDragDropEffect = DllCallbackRegister("__RichCom_Object_GetDragDropEffect", "long", "ptr;dword;dword;dword")
Global $__g_pRichCom_Object_GetContextMenu = DllCallbackRegister("__RichCom_Object_GetContextMenu", "long", "ptr;short;ptr;ptr;ptr")
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__RICHEDITCONSTANT_SB_LINEDOWN = 1
Global Const $__RICHEDITCONSTANT_SB_LINEUP = 0
Global Const $__RICHEDITCONSTANT_SB_PAGEDOWN = 3
Global Const $__RICHEDITCONSTANT_SB_PAGEUP = 2

Global Const $__RICHEDITCONSTANT_WM_COPY = 0x00000301

Global Const $__RICHEDITCONSTANT_WM_SETFONT = 0x0030
Global Const $__RICHEDITCONSTANT_WM_CUT = 0x00000300
Global Const $__RICHEDITCONSTANT_WM_PASTE = 0x00000302
Global Const $__RICHEDITCONSTANT_WM_SETREDRAW = 0x000B

Global Const $__RICHEDITCONSTANT_COLOR_WINDOWTEXT = 8

Global Const $_GCR_S_OK = 0
Global Const $_GCR_E_NOTIMPL = 0x80004001
Global Const $_GCR_E_INVALIDARG = 0x80070057
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GUICtrlRichEdit_AppendText
; _GUICtrlRichEdit_AutoDetectURL
; _GUICtrlRichEdit_CanPaste
; _GUICtrlRichEdit_CanPasteSpecial
; _GUICtrlRichEdit_CanRedo
; _GUICtrlRichEdit_CanUndo
; _GUICtrlRichEdit_ChangeFontSize
; _GUICtrlRichEdit_Copy
; _GUICtrlRichEdit_Create
; _GUICtrlRichEdit_Cut
; _GUICtrlRichEdit_Deselect
; _GUICtrlRichEdit_Destroy
; _GUICtrlRichEdit_EmptyUndoBuffer
; _GUICtrlRichEdit_FindText
; _GUICtrlRichEdit_FindTextInRange
; _GUICtrlRichEdit_GetCharAttributes
; _GUICtrlRichEdit_GetCharBkColor
; _GUICtrlRichEdit_GetCharColor
; _GUICtrlRichEdit_GetCharPosFromXY
; _GUICtrlRichEdit_GetCharPosOfNextWord
; _GUICtrlRichEdit_GetCharPosOfPreviousWord
; _GUICtrlRichEdit_GetCharWordBreakInfo
; _GUICtrlRichEdit_GetBkColor
; _GUICtrlRichEdit_GetText
; _GUICtrlRichEdit_GetTextLength
; _GUICtrlRichEdit_GetZoom
; _GUICtrlRichEdit_GetFirstCharPosOnLine
; _GUICtrlRichEdit_GetFont
; _GUICtrlRichEdit_GetRECT
; _GUICtrlRichEdit_GetLineCount
; _GUICtrlRichEdit_GetLineLength
; _GUICtrlRichEdit_GetLineNumberFromCharPos
; _GUICtrlRichEdit_GetNextRedo
; _GUICtrlRichEdit_GetNextUndo
; _GUICtrlRichEdit_GetNumberOfFirstVisibleLine
; _GUICtrlRichEdit_GetParaAlignment
; _GUICtrlRichEdit_GetParaAttributes
; _GUICtrlRichEdit_GetParaBorder
; _GUICtrlRichEdit_GetParaIndents
; _GUICtrlRichEdit_GetParaNumbering
; _GUICtrlRichEdit_GetParaShading
; _GUICtrlRichEdit_GetParaSpacing
; _GUICtrlRichEdit_GetParaTabStops
; _GUICtrlRichEdit_GetPasswordChar
; _GUICtrlRichEdit_GetScrollPos
; _GUICtrlRichEdit_GetSel
; _GUICtrlRichEdit_GetSelAA
; _GUICtrlRichEdit_GetSelText
; _GUICtrlRichEdit_GetSpaceUnit
; _GUICtrlRichEdit_GetTextInLine
; _GUICtrlRichEdit_GetTextInRange
; _GUICtrlRichEdit_GetVersion
; _GUICtrlRichEdit_GetXYFromCharPos
; _GUICtrlRichEdit_GotoCharPos
; _GUICtrlRichEdit_HideSelection
; _GUICtrlRichEdit_InsertText
; _GUICtrlRichEdit_IsModified
; _GUICtrlRichEdit_IsTextSelected
; _GUICtrlRichEdit_Paste
; _GUICtrlRichEdit_PasteSpecial
; _GUICtrlRichEdit_PauseRedraw
; _GUICtrlRichEdit_Redo
; _GUICtrlRichEdit_ReplaceText
; _GUICtrlRichEdit_ResumeRedraw
; _GUICtrlRichEdit_ScrollLineOrPage
; _GUICtrlRichEdit_ScrollLines
; _GUICtrlRichEdit_ScrollToCaret
; _GUICtrlRichEdit_SetCharAttributes
; _GUICtrlRichEdit_SetCharBkColor
; _GUICtrlRichEdit_SetCharColor
; _GUICtrlRichEdit_SetBkColor
; _GUICtrlRichEdit_SetLimitOnText
; _GUICtrlRichEdit_SetTabStops
; _GUICtrlRichEdit_SetZoom
; _GUICtrlRichEdit_SetEventMask
; _GUICtrlRichEdit_SetFont
; _GUICtrlRichEdit_SetRECT
; _GUICtrlRichEdit_SetModified
; _GUICtrlRichEdit_SetParaAlignment
; _GUICtrlRichEdit_SetParaAttributes
; _GUICtrlRichEdit_SetParaBorder
; _GUICtrlRichEdit_SetParaIndents
; _GUICtrlRichEdit_SetParaNumbering
; _GUICtrlRichEdit_SetParaShading
; _GUICtrlRichEdit_SetParaSpacing
; _GUICtrlRichEdit_SetParaTabStops
; _GUICtrlRichEdit_SetPasswordChar
; _GUICtrlRichEdit_SetReadOnly
; _GUICtrlRichEdit_SetScrollPos
; _GUICtrlRichEdit_SetSel
; _GUICtrlRichEdit_SetSpaceUnit
; _GUICtrlRichEdit_SetText
; _GUICtrlRichEdit_SetUndoLimit
; _GUICtrlRichEdit_StreamFromFile
; _GUICtrlRichEdit_StreamFromVar
; _GUICtrlRichEdit_StreamToFile
; _GUICtrlRichEdit_StreamToVar
; _GUICtrlRichEdit_Undo
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; $tagEDITSTREAM
; $tagBIDIOPTIONS
; $tagCHARFORMAT
; $tagCHARFORMAT2
; $tagCHARRANGE
; $tagFINDTEXT
; $tagFINDTEXTEX
; $tagGETTEXTEX
; $tagGETTEXTLENGTHEX
; $tagPARAFORMAT
; $tagPARAFORMAT2
; $tagSETTEXTEX
; $tagTEXTRANGE
; $tagMSGFILTER
; $tagENLINK
; __GCR_ConvertRomanToNumber
; __GCR_ConvertTwipsToSpaceUnit
; __GCR_GetParaScopeChar
; __GCR_Init
; __GCR_IsNumeric
; __GCR_ParseParaNumberingStyle
; __GCR_SendGetCharFormatMessage
; __GCR_SendGetParaFormatMessage
; __GCR_SetOLECallback
; __GCR_StreamFromFileCallback
; __GCR_StreamFromVarCallback
; __GCR_StreamToFileCallback
; __GCR_StreamToVarCallback
; __RichCom_Object_AddRef
; __RichCom_Object_ContextSensitiveHelp
; __RichCom_Object_DeleteObject
; __RichCom_Object_GetClipboardData
; __RichCom_Object_GetContextMenu
; __RichCom_Object_GetDragDropEffect
; __RichCom_Object_GetInPlaceContext
; __RichCom_Object_GetNewStorage
; __RichCom_Object_QueryAcceptData
; __RichCom_Object_QueryInsertObject
; __RichCom_Object_QueryInterface
; __RichCom_Object_Release
; __RichCom_Object_ShowContainerUI
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagEDITSTREAM
; Description ...: Contains information that an application passes to a rich edit control in a EM_STREAMIN or EM_STREAMOUT message
; Fields ........: dwCookie     - Specifies an application-defined value that the rich edit control passes to the EditStreamCallback callback function specified by the pfnCallback member
;                  dwError      - Indicates the results of the stream-in (read) or stream-out (write) operation
;                  pfnCallback  - Pointer to an EditStreamCallback function
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagEDITSTREAM = "align 4;dword_ptr dwCookie;dword dwError;ptr pfnCallback"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagBIDIOPTIONS
; Description ...: Contains bidirectional information about a rich edit control
; Fields ........: cbSize    - Specifies the size, in bytes, of the structure
;                  wMask     - A set of mask bits that determine which of the wEffects flags will be set to 1 or 0 by the rich edit control. This approach eliminates the need to read the effects flags before changing them.
;                  |Obsolete bits are valid only for the bidirectional version of Rich Edit 1.0.
;                  |  $BOM_DEFPARADIR       - Default paragraph direction—implies alignment (obsolete).
;                  |  $BOM_PLAINTEXT        - Use plain text layout (obsolete).
;                  |  $BOM_NEUTRALOVERRIDE  - Override neutral layout.
;                  |  $BOM_CONTEXTREADING   - Context reading order.
;                  |  $BOM_CONTEXTALIGNMENT - Context alignment.
;                  |  $BOM_LEGACYBIDICLASS  - Treatment of plus, minus, and slash characters in right-to-left (LTR) or bidirectional text.
;                  wEffects  - A set of flags that indicate the desired or current state of the effects flags. Obsolete bits are valid only for the bidirectional version of Rich Edit 1.0.
;                  |Obsolete bits are valid only for the bidirectional version of Rich Edit 1.0.
;                  |  $BOE_RTLDIR           - Default paragraph direction—implies alignment (obsolete).
;                  |  $BOE_PLAINTEXT        - Uses plain text layout (obsolete).
;                  |  $BOE_NEUTRALOVERRIDE  - Overrides neutral layout.
;                  |  $BOE_CONTEXTREADING   - Context reading order.
;                  |  $BOE_CONTEXTALIGNMENT - Context alignment.
;                  |  $BOE_LEGACYBIDICLASS  - Causes the plus and minus characters to be treated as neutral characters with no implied direction. Also causes the slash character to be treated as a common separator.
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagBIDIOPTIONS = "uint cbSize;word wMask;word wEffects"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagCHARFORMAT
; Description ...: Contains information about character formatting in a rich edit control
; Fields ........: cbSize          - Size in bytes of the specified structure
;                  dwMask          - Members containing valid information or attributes to set. This member can be zero, one, or more than one of the following values.
;                  |  $CFM_BOLD      - The $CFE_BOLD value of the dwEffects member is valid.
;                  |  $CFM_CHARSET   - The bCharSet member is valid.
;                  |  $CFM_COLOR     - The crTextColor member and the $CFE_AUTOCOLOR value of the dwEffects member are valid.
;                  |  $CFM_FACE      - The szFaceName member is valid.
;                  |  $CFM_ITALIC    - The $CFE_ITALIC value of the dwEffects member is valid.
;                  |  $CFM_OFFSET    - The yOffset member is valid.
;                  |  $CFM_PROTECTED - The $CFE_PROTECTED value of the dwEffects member is valid.
;                  |  $CFM_SIZE      - The yHeight member is valid.
;                  |  $CFM_STRIKEOUT - The $CFE_STRIKEOUT value of the dwEffects member is valid.
;                  |  $CFM_UNDERLINE - The $CFE_UNDERLINE value of the dwEffects member is valid.
;                  dwEffects       - Character effects. This member can be a combination of the following values.
;                  |  $CFE_AUTOCOLOR - The text color is the return value of GetSysColor(COLOR_WINDOWTEXT).
;                  |  $CFE_BOLD      - Characters are bold.
;                  |  $CFE_DISABLED  - RichEdit 2.0 and later: Characters are displayed with a shadow that is offset by 3/4 point or one pixel, whichever is larger.
;                  |  $CFE_ITALIC    - Characters are italic.
;                  |  $CFE_STRIKEOUT - Characters are struck.
;                  |  $CFE_UNDERLINE - Characters are underlined.
;                  |  $CFE_PROTECTED - Characters are protected; an attempt to modify them will cause an EN_PROTECTED notification message.
;                  yHeight         - Character height, in twips (1/1440 of an inch or 1/20 of a printer's point).
;                  yOffset         - Character offset, in twips, from the baseline. If the value of this member is positive, the character is a superscript; if it is negative, the character is a subscript.
;                  crCharColor     - Text color. This member is ignored if the $CFE_AUTOCOLOR character effect is specified. To generate a COLORREF, use the RGB macro.
;                  bCharSet        - Character set value. The bCharSet member can be one of the values specified for the lfCharSet member of the LOGFONT structure. Rich Edit 3.0 may override this value if it is invalid for the target characters.
;                  bPitchAndFamily - Font family and pitch. This member is the same as the lfPitchAndFamily member of the LOGFONT structure.
;                  szFaceName      - Null-terminated character array specifying the font name.
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCHARFORMAT = "struct;uint cbSize;dword dwMask;dword dwEffects;long yHeight;long yOffset;INT crCharColor;" & _
		"byte bCharSet;byte bPitchAndFamily;wchar szFaceName[32];endstruct"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagCHARFORMAT2
; Description ...: Contains information about character formatting in a rich edit control
; Fields ........: cbSize          - Size in bytes of the specified structure
;                  dwMask          - Members containing valid information or attributes to set. This member can be zero, one, or more than one of the following values.
;                  |  $CFM_BOLD          - The $CFE_BOLD value of the dwEffects member is valid.
;                  |  $CFM_CHARSET       - The bCharSet member is valid.
;                  |  $CFM_COLOR         - The crTextColor member and the $CFE_AUTOCOLOR value of the dwEffects member are valid.
;                  |  $CFM_FACE          - The szFaceName member is valid.
;                  |  $CFM_ITALIC        - The $CFE_ITALIC value of the dwEffects member is valid.
;                  |  $CFM_OFFSET        - The yOffset member is valid.
;                  |  $CFM_PROTECTED     - The $CFE_PROTECTED value of the dwEffects member is valid.
;                  |  $CFM_SIZE          - The yHeight member is valid.
;                  |  $CFM_STRIKEOUT     - The $CFE_STRIKEOUT value of the dwEffects member is valid.
;                  |  $CFM_UNDERLINE     - The $CFE_UNDERLINE value of the dwEffects member is valid.
;                  |Set the following values to indicate the valid structure members.
;                  |  $CFM_ANIMATION     - The bAnimation member is valid.
;                  |  $CFM_BACKCOLOR     - The crBackColor member is valid.
;                  |  $CFM_CHARSET       - The bCharSet member is valid.
;                  |  $CFM_COLOR         - The crTextColor member is valid unless the CFE_AUTOCOLOR flag is set in the dwEffects member.
;                  |  $CFM_FACE          - The szFaceName member is valid.
;                  |  $CFM_KERNING       - The wKerning member is valid.
;                  |  $CFM_LCID          - The lcid member is valid.
;                  |  $CFM_OFFSET        - The yOffset member is valid.
;                  |  $CFM_REVAUTHOR     - The bRevAuthor member is valid.
;                  |  $CFM_SIZE          - The yHeight member is valid.
;                  |  $CFM_SPACING       - The sSpacing member is valid.
;                  |  $CFM_STYLE         - The sStyle member is valid.
;                  |  $CFM_UNDERLINETYPE - The bUnderlineType member is valid.
;                  |  $CFM_WEIGHT        - The wWeight member is valid.
;                  dwEffects       - A set of bit flags that specify character effects. Some of the flags are included only for compatibility with Microsoft Text Object Model (TOM) interfaces; the rich edit control stores the value but does not use it to display text.
;                  |This member can be a combination of the following values.
;                  |  $CFE_ALLCAPS       - Characters are all capital letters. The value does not affect the way the control displays the text. This value applies only to versions earlier than Rich Edit 3.0.
;                  |  $CFE_AUTOBACKCOLOR - The background color is the return value of GetSysColor(COLOR_WINDOW). If this flag is set, crBackColor member is ignored.
;                  |  $CFE_AUTOCOLOR     - The text color is the return value of GetSysColor(COLOR_WINDOWTEXT). If this flag is set, the crTextColor member is ignored.
;                  |  $CFE_BOLD          - Characters are bold.
;                  |  $CFE_DISABLED      - Characters are displayed with a shadow that is offset by 3/4 point or one pixel, whichever is larger.
;                  |  $CFE_EMBOSS        - Characters are embossed. The value does not affect how the control displays the text.
;                  |  $CFE_HIDDEN        - For Rich Edit 3.0 and later, characters are not displayed.
;                  |  $CFE_IMPRINT       - Characters are displayed as imprinted characters. The value does not affect how the control displays the text.
;                  |  $CFE_ITALIC        - Characters are italic.
;                  |  $CFE_LINK          - A rich edit control can send EN_LINK notification messages when it receives mouse messages while the mouse pointer is over text with the CFE_LINK effect.
;                  |  $CFE_OUTLINE       - Characters are displayed as outlined characters. The value does not affect how the control displays the text.
;                  |  $CFE_PROTECTED     - Characters are protected; an attempt to modify them will cause an EN_PROTECTED notification message.
;                  |  $CFE_REVISED       - Characters are marked as revised.
;                  |  $CFE_SHADOW        - Characters are displayed as shadowed characters. The value does not affect how the control displays the text.
;                  |  $CFE_SMALLCAPS     - Characters are in small capital letters. The value does not affect how the control displays the text.
;                  |  $CFE_STRIKEOUT     - Characters are struck out.
;                  |  $CFE_SUBSCRIPT     - Characters are subscript. The CFE_SUPERSCRIPT and CFE_SUBSCRIPT values are mutually exclusive. For both values, the control automatically calculates an offset and a smaller font size. Alternatively, you can use the yHeight and yOffset members to explicitly specify font size and offset for subscript and superscript characters.
;                  |  $CFE_SUPERSCRIPT   - Characters are superscript.
;                  |  $CFE_UNDERLINE     - Characters are underlined.
;                  yHeight         - Character height, in twips (1/1440 of an inch or 1/20 of a printer's point).
;                  yOffset         - Character offset, in twips, from the baseline. If the value of this member is positive, the character is a superscript; if it is negative, the character is a subscript.
;                  crCharColor     - Text color. This member is ignored if the $CFE_AUTOCOLOR character effect is specified. To generate a COLORREF, use the RGB macro.
;                  bCharSet        - Character set value. The bCharSet member can be one of the values specified for the lfCharSet member of the LOGFONT structure. Rich Edit 3.0 may override this value if it is invalid for the target characters.
;                  bPitchAndFamily - Font family and pitch. This member is the same as the lfPitchAndFamily member of the LOGFONT structure.
;                  szFaceName      - Null-terminated character array specifying the font name.
;                  wWeight         - Font weight. This member is the same as the lfWeight member of the LOGFONT structure. To use this member, set the CFM_WEIGHT flag in the dwMask member.
;                  sSpacing        - Horizontal space between letters, in twips. This value has no effect on the text displayed by a rich edit control; it is included for compatibility with Microsoft WindowsText Object Model (TOM) interfaces. To use this member, set the CFM_SPACING flag in the dwMask member.
;                  crBackColor     - Background color. To use this member, set the CFM_BACKCOLOR flag in the dwMask member. This member is ignored if the CFE_AUTOBACKCOLOR character effect is specified. To generate a , use the macro.
;                  lcid            - A 32-bit locale identifier that contains a language identifier in the lower word and a sorting identifier and reserved value in the upper word. This member has no effect on the text displayed by a rich edit control, but spelling and grammar checkers can use it to deal with language-dependent problems. You can use the macro to create an LCID value. To use this member, set the CFM_LCID flag in the dwMask member.
;                  dwReserved      - Reserved; the value must be zero.
;                  sStyle          - Character style handle. This value has no effect on the text displayed by a rich edit control; it is included for compatibility with WindowsTOM interfaces. To use this member, set the CFM_STYLE flag in the dwMask member. For more information see the Text Object Model documentation.
;                  wKerning        - Value of the font size, above which to kern the character (yHeight). This value has no effect on the text displayed by a rich edit control; it is included for compatibility with TOM interfaces. To use this member, set the CFM_KERNING flag in the dwMask member.
;                  bUnderlineType  - Specifies the underline type. To use this member, set the CFM_UNDERLINETYPE flag in the dwMask member. This member can be one of the following values.
;                  |  $CFU_CF1UNDERLINE    - The structure maps CHARFORMAT's bit underline to CHARFORMAT2, (that is, it performs a CHARFORMAT type of underline on this text).
;                  |  $CFU_UNDERLINE       - Solid underlined text.
;                  |  $CFU_UNDERLINEDOTTED - Dotted underlined text. For versions earlier than Rich Edit 3.0, text is displayed with a solid underline.
;                  |  $CFU_UNDERLINEDOUBLE - Double-underlined text. The rich edit control displays the text with a solid underline.
;                  |  $CFU_UNDERLINENONE   - No underline. This is the default.
;                  |  $CFU_UNDERLINEWORD   - Underline words only. The rich edit control displays the text with a solid underline.
;                  bAnimation      - Text animation type. This value has no effect on the text displayed by a rich edit control; it is included for compatibility with TOM interfaces. To use this member, set the CFM_ANIMATION flag in the dwMask member.
;                  bRevAuthor      - An index that identifies the author making a revision. The rich edit control uses different text colors for each different author index. To use this member, set the CFM_REVAUTHOR flag in the dwMask member.
;                  bReserved1      - Reserved; the value must be zero.
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCHARFORMAT2 = $tagCHARFORMAT & ";word wWeight;short sSpacing;INT crBackColor;dword lcid;dword dwReserved;" & _
		"short sStyle;word wKerning;byte bUnderlineType;byte bAnimation;byte bRevAuthor;byte bReserved1"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagCHARRANGE
; Description ...: Specifies a range of characters in a rich edit control
; Fields ........: cpMin     - Character position index immediately preceding the first character in the range.
;                  cpMax     - Character position immediately following the last character in the range.
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCHARRANGE = "struct;long cpMin;long cpMax;endstruct"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagFINDTEXT
; Description ...: Contains information about a search operation in a rich edit control
; Fields ........: cpMin     - Character position index immediately preceding the first character in the range.
;                  cpMax     - Character position immediately following the last character in the range.
;                  lpstrText - Pointer to the null-terminated string used in the find operation.
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagFINDTEXT = $tagCHARRANGE & ";ptr lpstrText"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagFINDTEXTEX
; Description ...: Contains information about text to search for in a rich edit control.
; Fields ........: cpMin       - Character position index immediately preceding the first character in the range to search.
;                  cpMax       - Character position immediately following the last character in the range to search.
;                  lpstrText   - Pointer to the null-terminated string used in the find operation.
;                  cpMinRang - Character position index immediately preceding the first character in the range found.
;                  cpMaxRange - Character position immediately following the last character in the range found.
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagFINDTEXTEX = $tagCHARRANGE & ";ptr lpstrText;long cpMinRang;long cpMaxRange"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagGETTEXTEX
; Description ...: Contains information about an operation to get text from a rich edit control.
; Fields ........: cb            - Count of bytes in the fetched string.
;                  flags         - Value specifying a text operation. This member can be one of the following values.
;                  |  $GT_DEFAULT   - No CR translation.
;                  |  $GT_SELECTION - Retrieves the text for the current selection.
;                  |  $GT_USECRLF   - Indicates that when copying text, each CR should be translated into a CRLF.
;                  codepage      - Code page used in the translation. It is $CP_ACP for ANSI Code Page and 1200 for Unicode.
;                  lpDefaultChar - Points to the character used if a wide character cannot be represented in the specified code page.
;                  |It is used only if the code page is not 1200 (Unicode). If this member is NULL, a system default value is used.
;                  lpUsedDefChar - Points to a flag that indicates whether a default character was used.
;                  |It is used only if the code page is not 1200 (Unicode).
;                  |The flag is set to TRUE if one or more wide characters in the source string cannot be represented in the specified code page.
;                  |Otherwise, the flag is set to FALSE. This member may be NULL.
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagGETTEXTEX = "align 4;dword cb;dword flags;uint codepage;ptr lpDefaultChar;ptr lpbUsedDefChar"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagGETTEXTLENGTHEX
; Description ...: Contains information about how the text length of a rich edit control should be calculated.
; Fields ........: flags    - Value specifying the method to be used in determining the text length. This member can be one or more of the following values (some values are mutually exclusive).
;                  |  $GTL_DEFAULT  - Returns the number of characters. This is the default.
;                  |  $GTL_USECRLF  - Computes the answer by using CR/LFs at the end of paragraphs.
;                  |  $GTL_PRECISE  - Computes a precise answer. This approach could necessitate a conversion and thereby take longer. This flag cannot be used with the GTL_CLOSE flag. E_INVALIDARG will be returned if both are used.
;                  |  $GTL_CLOSE    - Computes an approximate (close) answer. It is obtained quickly and can be used to set the buffer size. This flag cannot be used with the GTL_PRECISE flag. E_INVALIDARG will be returned if both are used.
;                  |  $GTL_NUMCHARS - Returns the number of characters. This flag cannot be used with the GTL_NUMBYTES flag. E_INVALIDARG will be returned if both are used.
;                  |  $GTL_NUMBYTES - Returns the number of bytes. This flag cannot be used with the GTL_NUMCHARS flag. E_INVALIDARG will be returned if both are used.
;                  codepage - Code page used in the translation. It is $CP_ACP for ANSI Code Page and 1200 for Unicode.
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagGETTEXTLENGTHEX = "dword flags;uint codepage"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagPARAFORMAT
; Description ...: Contains information about paragraph formatting attributes in a rich edit control.
; Fields ........: cbSize        - Structure size, in bytes.
;                  dwMask        - Members containing valid information or attributes to set. This parameter can be none or a combination of the following values. If both PFM_STARTINDENT and PFM_OFFSETINDENT are specified, PFM_STARTINDENT takes precedence.
;                  |  $PFM_ALIGNMENT    - The wAlignment member is valid.
;                  |  $PFM_NUMBERING    - The wNumbering member is valid.
;                  |  $PFM_OFFSET       - The dxOffset member is valid.
;                  |  $PFM_OFFSETINDENT - The dxStartIndent member is valid and specifies a relative value.
;                  |  $PFM_RIGHTINDENT  - The dxRightIndent member is valid.
;                  |  $PFM_RTLPARA      - Rich Edit 2.0: The wEffects member is valid
;                  |  $PFM_STARTINDENT  - The dxStartIndent member is valid.
;                  |  $PFM_TABSTOPS     - The cTabStobs and rgxTabStops members are valid.
;                  wNumbering    - Value specifying numbering options. This member can be zero or $PFN_BULLET.
;                  wEffects      - A bit flag that specifies a paragraph effect. It is included only for compatibility with Text Object Model (TOM) interfaces; the rich edit control stores the value but does not use it to display the text. This parameter can be one of the following values.
;                  |  0                 - Displays text using left-to-right reading order. This is the default.
;                  |  $PFE_RLTPARA      - Displays text using right-to-left reading order.
;                  dxStartIndent - Indentation of the first line in the paragraph, in twips.
;                  |If the paragraph formatting is being set and PFM_OFFSETINDENT is specified, this member is treated as a relative value that is added to the starting indentation of each affected paragraph.
;                  dxRightIndent - Size, of the right indentation relative to the right margin, in twips.
;                  dxOffset      - Indentation of the second and subsequent lines of a paragraph relative to the starting indentation, in twips.
;                  |The first line is indented if this member is negative or outdented if this member is positive.
;                  wAlignment    - Value specifying the paragraph alignment. This member can be one of the following values.
;                  |  $PFA_CENTER       - Paragraphs are centered.
;                  |  $PFA_LEFT         - Paragraphs are aligned with the left margin.
;                  |  $PFA_RIGHT        - Paragraphs are aligned with the right margin.
;                  cTabCount     - Number of tab stops.
;                  rgxTabs       - Array of absolute tab stop positions. Each element in the array specifies information about a tab stop. The 24 low-order bits specify the absolute offset, in twips. To use this member, set the PFM_TABSTOPS flag in the dwMask member.
;                  |Rich Edit 2.0: For compatibility with TOM interfaces, you can use the eight high-order bits to store additional information about each tab stop.
;                  |  Bits 24-27 can specify one of the following values to indicate the tab alignment. These bits do not affect the rich edit control display for versions earlier than Rich Edit 3.0.
;                  |    0               - Ordinary tab
;                  |    1               - Center tab
;                  |    2               - Right-aligned tab
;                  |    3               - Decimal tab
;                  |    4               - Word bar tab (vertical bar)
;                  |  Bits 28-31 can specify one of the following values to indicate the type of tab leader. These bits do not affect the rich edit control display.
;                  |    0               - No leader
;                  |    1               - Dotted leader
;                  |    2               - Dashed leader
;                  |    3               - Underlined leader
;                  |    4               - Thick line leader
;                  |    5               - Double line leader
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagPARAFORMAT = "uint cbSize;dword dwMask;word wNumbering;word wEffects;long dxStartIndent;" _
		 & "long dxRightIndent;long dxOffset;word wAlignment;short cTabCount;long rgxTabs[32]"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagPARAFORMAT2
; Description ...: Contains information about paragraph formatting attributes in a rich edit control.
; Fields ........: cbSize        - Structure size, in bytes.
;                  dwMask        - The members of the PARAFORMAT2 structure that contain valid information. The dwMask member can be a combination of the values from two sets of bit flags. One set indicates the structure members that are valid; another set indicates the valid attributes in the wEffects member.
;                  |Set the following values to indicate the valid structure members.
;                  |  $PFM_ALIGNMENT       - The wAlignment member is valid.
;                  |  $PFM_BORDER          - The wBorderSpace, wBorderWidth, and wBorders members are valid.
;                  |  $PFM_LINESPACING     - The dyLineSpacing and bLineSpacingRule members are valid.
;                  |  $PFM_NUMBERING       - The wNumbering member is valid.
;                  |  $PFM_NUMBERINGSTART  - The wNumberingStart member is valid.
;                  |  $PFM_NUMBERINGSTYLE  - The wNumberingStyle member is valid.
;                  |  $PFM_NUMBERINGTAB    - The wNumberingTab member is valid.
;                  |  $PFM_OFFSET          - The dxOffset member is valid.
;                  |  $PFM_OFFSETINDENT    - The dxStartIndent member is valid. If you are setting the indentation, dxStartIndent specifies the amount to indent relative to the current indentation.
;                  |  $PFM_RIGHTINDENT     - The dxRightIndent member is valid.
;                  |  $PFM_SHADING         - The wShadingWeight and wShadingStyle members are valid.
;                  |  $PFM_SPACEAFTER      - The dySpaceAfter member is valid.
;                  |  $PFM_SPACEBEFORE     - The dySpaceBefore member is valid.
;                  |  $PFM_STARTINDENT     - The dxStartIndent member is valid and specifies the indentation from the left margin. If both PFM_STARTINDENT and PFM_OFFSETINDENT are specified, PFM_STARTINDENT takes precedence.
;                  |  $PFM_STYLE           - The sStyle member is valid.
;                  |  $PFM_TABSTOPS        - The cTabCount and rgxTabs members are valid.
;                  |Set the following values to indicate the valid attributes of the wEffects member.
;                  |  $PFM_DONOTHYPHEN     - The PFE_DONOTHYPHEN value is valid.
;                  |  $PFM_KEEP            - The PFE_KEEP value is valid.
;                  |  $PFM_KEEPNEXT        - The PFE_KEEPNEXT value is valid.
;                  |  $PFM_NOLINENUMBER    - The PFE_NOLINENUMBER value is valid.
;                  |  $PFM_NOWIDOWCONTROL  - The PFE_NOWIDOWCONTROL value is valid.
;                  |  $PFM_PAGEBREAKBEFORE - The PFE_PAGEBREAKBEFORE value is valid.
;                  |  $PFM_RTLPARA         - The PFE_RTLPARA value is valid.
;                  |  $PFM_SIDEBYSIDE      - The PFE_SIDEBYSIDE value is valid.
;                  |  $PFM_TABLE           - The PFE_TABLE value is valid.
;                  wNumbering    - Options used for bulleted or numbered paragraphs. To use this member, set the PFM_NUMBERING flag in the dwMask member.
;                  |This member can be one of the following values.
;                  |  zero                 - No paragraph numbering or bullets.
;                  |  $PFN_BULLET          - Insert a bullet at the beginning of each selected paragraph.
;                  |                         Rich Edit versions earlier than version 3.0 do not display paragraph numbers.
;                  |                         However, for compatibility with Microsoft Text Object Model (TOM) interfaces,
;                  |                         wNumbering can specify one of the following values.
;                  |                         (The rich edit control stores the value but does not use it to display the text.)
;                  |  2                    - Uses Arabic numbers (1, 2, 3, ...).
;                  |  3                    - Uses lowercase letters (a, b, c, ...).
;                  |  4                    - Uses uppercase letters (A, B, C, ...).
;                  |  5                    - Uses lowercase Roman numerals (i, ii, iii, ...).
;                  |  6                    - Uses uppercase Roman numerals (I, II, III, ...).
;                  |  7                    - Uses a sequence of characters beginning with the Unicode character specified by the wNumberingStart member.
;                  wEffects      - A set of bit flags that specify paragraph effects. These flags are included only for compatibility with Text Object Model (TOM) interfaces; the rich edit control stores the value but does not use it to display the text.
;                  |This member can be a combination of the following values.
;                  |  $PFE_DONOTHYPHEN     - Disables automatic hyphenation.
;                  |  $PFE_KEEP            - No page break within the paragraph.
;                  |  $PFE_KEEPNEXT        - No page break between this paragraph and the next.
;                  |  $PFE_NOLINENUMBER    - Disables line numbering (in Rich Edit 3.0 only).
;                  |  $PFE_NOWIDOWCONTROL  - Disables widow and orphan control for the selected paragraph.
;                  |  $PFE_PAGEBREAKBEFORE - Inserts a page break before the selected paragraph.
;                  |  $PFE_RTLPARA         - Displays text using right-to-left reading order (in Rich Edit 2.1 and later).
;                  |  $PFE_SIDEBYSIDE      - Displays paragraphs side by side.
;                  |  $PFE_TABLE           - The paragraph is a table row.
;                  dxStartIndent - Indentation of the paragraph's first line, in twips.
;                  |The indentation of subsequent lines depends on the dxOffset member.
;                  |To use the dxStartIndent member, set the $PFM_STARTINDENT or $PFM_OFFSETINDENT flag in the dwMask member.
;                  |If you are setting the indentation, use the $PFM_STARTINDENT flag to specify an absolute indentation from the left margin
;                  |or use the $PFM_OFFSETINDENT flag to specify an indentation relative to the paragraph's current indentation.
;                  |Use either flag to retrieve the current indentation.
;                  dxRightIndent - Indentation of the right side of the paragraph, relative to the right margin, in twips.
;                  |To use this member, set the $PFM_RIGHTINDENT flag in the dwMask member.
;                  dxOffset      - Indentation of the second and subsequent lines, relative to the indentation of the first line, in twips.
;                  |The first line is indented if this member is negative or outdented if this member is positive.
;                  |To use this member, set the $PFM_OFFSET flag in the dwMask member.
;                  wAlignment    - Paragraph alignment. To use this member, set the PFM_ALIGNMENT flag in the dwMask member. This member can be one of the following values.
;                  |  $PFA_LEFT            - Paragraphs are aligned with the left margin.
;                  |  $PFA_RIGHT           - Paragraphs are aligned with the right margin.
;                  |  $PFA_CENTER          - Paragraphs are centered.
;                  |  $PFA_JUSTIFY         - Rich Edit 2.0: Paragraphs are justified.
;                  |                         This value is included for compatibility with TOM interfaces;
;                  |                         rich edit controls earlier than Rich Edit 3.0 display the text aligned with the left margin.
;                  |  $PFA_FULL_INTERWORD  - Paragraphs are justified by expanding the blanks alone.
;                  cTabCount     - Number of tab stops defined in the rgxTabs array.
;                  rgxTabs       - Array of absolute tab stop positions. Each element in the array specifies information about a tab stop. The 24 low-order bits specify the absolute offset, in twips. To use this member, set the PFM_TABSTOPS flag in the dwMask member.
;                  |Rich Edit 2.0: For compatibility with TOM interfaces, you can use the eight high-order bits to store additional information about each tab stop.
;                  |  Bits 24-27 can specify one of the following values to indicate the tab alignment. These bits do not affect the rich edit control display for versions earlier than Rich Edit 3.0.
;                  |    0                  - Ordinary tab
;                  |    1                  - Center tab
;                  |    2                  - Right-aligned tab
;                  |    3                  - Decimal tab
;                  |    4                  - Word bar tab (vertical bar)
;                  |  Bits 28-31 can specify one of the following values to indicate the type of tab leader. These bits do not affect the rich edit control display.
;                  |    0                  - No leader
;                  |    1                  - Dotted leader
;                  |    2                  - Dashed leader
;                  |    3                  - Underlined leader
;                  |    4                  - Thick line leader
;                  |    5                  - Double line leader
;                  dySpaceBefore - Size of the spacing above the paragraph, in twips. To use this member, set the PFM_SPACEBEFORE flag in the dwMask member. The value must be greater than or equal to zero.
;                  dySpaceAfter  - Specifies the size of the spacing below the paragraph, in twips. To use this member, set the PFM_SPACEAFTER flag in the dwMask member. The value must be greater than or equal to zero.
;                  dyLineSpacing - Spacing between lines. For a description of how this value is interpreted, see the bLineSpacingRule member. To use this member, set the PFM_LINESPACING flag in the dwMask member.
;                  sStyle        - Text style. To use this member, set the PFM_STYLE flag in the dwMask member. This member is included only for compatibility with TOM interfaces and Microsoft Word; the rich edit control stores the value but does not use it to display the text.
;                  bLineSpacingRule - Type of line spacing. To use this member, set the PFM_SPACEAFTER flag in the dwMask member. This member can be one of the following values.
;                  |    0                  - Single spacing. The dyLineSpacing member is ignored.
;                  |    1                  - One-and-a-half spacing. The dyLineSpacing member is ignored.
;                  |    2                  - Double spacing. The dyLineSpacing member is ignored.
;                  |    3                  - The dyLineSpacing member specifies the spacingfrom one line to the next, in twips. However, if dyLineSpacing specifies a value that is less than single spacing, the control displays single-spaced text.
;                  |    4                  - The dyLineSpacing member specifies the spacing from one line to the next, in twips. The control uses the exact spacing specified, even if dyLineSpacing specifies a value that is less than single spacing.
;                  |    5                  - The value of dyLineSpacing / 20 is the spacing, in lines, from one line to the next. Thus, setting dyLineSpacing to 20 produces single-spaced text, 40 is double spaced, 60 is triple spaced, and so on.
;                  bOutlineLevel - Reserved; must be zero.
;                  wShadingWeight - Percentage foreground color used in shading. The wShadingStyle member specifies the foreground and background shading colors. A value of 5 indicates a shading color consisting of 5 percent foreground color and 95 percent background color. To use these members, set the PFM_SHADING flag in the dwMask member. This member is included only for compatibility with Word; the rich edit control stores the value but does not use it to display the text.
;                  wShadingStyle - Style and colors used for background shading. Bits 0 to 3 contain the shading style, bits 4 to 7 contain the foreground color index, and bits 8 to 11 contain the background color index. To use this member, set the PFM_SHADING flag in the dwMask member. This member is included only for compatibility with Word; the rich edit control stores the value but does not use it to display the text.
;                  |  The shading style can be one of the following values.
;                  |    0                  - None
;                  |    1                  - Dark horizontal
;                  |    2                  - Dark vertical
;                  |    3                  - Dark down diagonal
;                  |    4                  - Dark up diagonal
;                  |    5                  - Dark grid
;                  |    6                  - Dark trellis
;                  |    7                  - Light horizontal
;                  |    8                  - Light vertical
;                  |    9                  - Light down diagonal
;                  |    10                 - Light up diagonal
;                  |    11                 - Light grid
;                  |    12                 - Light trellis
;                  |  The foreground and background color indexes can be one of the following values.
;                  |    0                  - Black
;                  |    1                  - Blue
;                  |    2                  - Cyan
;                  |    3                  - Green
;                  |    4                  - Magenta
;                  |    5                  - Red
;                  |    6                  - Yellow
;                  |    7                  - White
;                  |    8                  - Dark blue
;                  |    9                  - Dark cyan
;                  |    10                 - Dark green
;                  |    11                 - Dark magenta
;                  |    12                 - Dark red
;                  |    13                 - Dark yellow
;                  |    14                 - Dark gray
;                  |    15                 - Light gray
;                  wNumberingStart - Starting number or Unicode value used for numbered paragraphs. Use this member in conjunction with the wNumbering member. This member is included only for compatibility with TOM interfaces; the rich edit control stores the value but does not use it to display the text or bullets. To use this member, set the PFM_NUMBERINGSTART flag in the dwMask member.
;                  wNumberingStyle - Numbering style used with numbered paragraphs. Use this member in conjunction with the wNumbering member. This member is included only for compatibility with TOM interfaces; the rich edit control stores the value but rich edit versions earlier than 3.0 do not use it to display the text or bullets. To use this member, set the PFM_NUMBERINGSTYLE flag in the dwMask member. This member can be one of the following values.
;                  |    0                  - Follows the number with a right parenthesis.
;                  |    0x100              - Encloses the number in parentheses.
;                  |    0x200              - Follows the number with a period.
;                  |    0x300              - Displays only the number.
;                  |    0x400              - Continues a numbered list without applying the next number or bullet.
;                  |    0x8000             - Starts a new number with wNumberingStart.
;                  wNumberingTab - Minimum space between a paragraph number and the paragraph text, in twips. Use this member in conjunction with the wNumbering member. The wNumberingTab member is included for compatibility with TOM interfaces; previous to Rich Edit 3.0, the rich edit control stores the value but does not use it to display text. To use this member, set the PFM_NUMBERINGTAB flag in the dwMask member.
;                  wBorderSpace - The space between the border and the paragraph text, in twips. The wBorderSpace member is included for compatibility with Word; the rich edit control stores the values but does not use them to display text. To use this member, set the PFM_BORDER flag in the dwMask member.
;                  wBorderWidth - Border width, in twips. To use this member, set the PFM_BORDER flag in the dwMask member.
;                  wBorders - Border location, style, and color. Bits 0 to 7 specify the border locations, bits 8 to 11 specify the border style, and bits 12 to 15 specify the border color index. To use this member, set the PFM_BORDER flag in the dwMask member.
;                  |  Specify the border locations using a combination of the following values in bits 0 to 7.
;                  |    1                  - Left border.
;                  |    2                  - Right border.
;                  |    4                  - Top border.
;                  |    8                  - Bottom border.
;                  |    16                 - Inside borders.
;                  |    32                 - Outside borders.
;                  |    64                 - Autocolor. If this bit is set, the color index in bits 12 to 15 is not used.
;                  |  Specify the border style using one of the following values for bits 8 to 11.
;                  |    0                  - None
;                  |    1                  - 3/4 point
;                  |    2                  - 11/2 point
;                  |    3                  - 21/4 point
;                  |    4                  - 3 point
;                  |    5                  - 41/2 point
;                  |    6                  - 6 point
;                  |    7                  - 3/4 point double
;                  |    8                  - 11/2 point double
;                  |    9                  - 21/4 point double
;                  |    10                 - 3/4 point gray
;                  |    11                 - 3/4 point gray dashed
;                  |  Specify the border color using one of the following values for bits 12 to 15. This value is ignored if the autocolor bit (bit 6) is set.
;                  |    0                  - Black
;                  |    1                  - Blue
;                  |    2                  - Cyan
;                  |    3                  - Green
;                  |    4                  - Magenta
;                  |    5                  - Red
;                  |    6                  - Yellow
;                  |    7                  - White
;                  |    8                  - Dark blue
;                  |    9                  - Dark cyan
;                  |    10                 - Dark green
;                  |    11                 - Dark magenta
;                  |    12                 - Dark red
;                  |    13                 - Dark yellow
;                  |    14                 - Dark gray
;                  |    15                 - Light gray
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagPARAFORMAT2 = $tagPARAFORMAT _
		 & ";long dySpaceBefore;long dySpaceAfter;long dyLineSpacing;short sStyle;byte bLineSpacingRule;" _
		 & "byte bOutlineLevel;word wShadingWeight;word wShadingStyle;word wNumberingStart;word wNumberingStyle;" _
		 & "word wNumberingTab;word wBorderSpace;word wBorderWidth;word wBorders"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagSETTEXTEX
; Description ...: Specifies which code page (if any) to use in setting text, whether the text replaces all the text in the control or just the selection, and whether the undo state is to be preserved.
; Fields ........: flags    - Option flags. It can be any reasonable combination of the following flags.
;                  |  $ST_DEFAULT   - Deletes the undo stack, discards rich-text formatting, replaces all text.
;                  |  $ST_KEEPUNDO  - Keeps the undo stack.
;                  |  $ST_SELECTION - Replaces selection and keeps rich-text formatting.
;                  codepage - Code page used in the translation. It is $CP_ACP for ANSI Code Page and 1200 for Unicode.
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagSETTEXTEX = "dword flags;uint codepage"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagTEXTRANGE
; Description ...: Specifies a range of characters in a rich edit control
; Fields ........: cpMin     - Character position index immediately preceding the first character in the range.
;                  cpMax     - Character position immediately following the last character in the range.
;                  lpstrText - Pointer to buffer that receives the text.
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagTEXTRANGE = $tagCHARRANGE & ";ptr lpstrText"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagMSGFILTER
; Description ...: Contains information about a keyboard or mouse event.
; Fields ........: hWndFrom - Window handle to the control sending a message
;                  IDFrom   - Identifier of the control sending a message
;                  Code     - Notification code
;                  msg       - Keyboard or mouse message identifier.
;                  wParam    - The wParam parameter of the message.
;                  lParam    - The lParam parameter of the message.
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagMSGFILTER = "align 4;" & $tagNMHDR & ";uint msg;wparam wParam;lparam lParam"

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: $tagENLINK
; Description ...: Contains information about an EN_LINK notification message from a rich edit control.
; Fields ........: hWndFrom - Window handle to the control sending a message
;                  IDFrom   - Identifier of the control sending a message
;                  Code     - Notification code
;                  msg       - Keyboard or mouse message identifier.
;                  wParam    - The wParam parameter of the message.
;                  lParam    - The lParam parameter of the message.
;                  cpMin     - Character position index immediately preceding the first character in the range.
;                  cpMax     - Character position immediately following the last character in the range.
; Author ........: Gary Frost (gafrost)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagENLINK = "align 4;" & $tagNMHDR & ";uint msg;wparam wParam;lparam lParam;" & $tagCHARRANGE

; #FUNCTION# ====================================================================================================================
; Authors........: Gary Frost (gafrost (custompcs@charter.net))
; Modified ......: Prog@ndy, Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_AppendText($hWnd, $sText)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Local $iLength = _GUICtrlRichEdit_GetTextLength($hWnd)
	_GUICtrlRichEdit_SetSel($hWnd, $iLength, $iLength) ; go to end of text
	Local $tSetText = DllStructCreate($tagSETTEXTEX)
	DllStructSetData($tSetText, 1, $ST_SELECTION)
	Local $iRet
	If StringLeft($sText, 5) <> "{\rtf" And StringLeft($sText, 5) <> "{urtf" Then
		DllStructSetData($tSetText, 2, $CP_UNICODE)
		$iRet = _SendMessage($hWnd, $EM_SETTEXTEX, $tSetText, $sText, 0, "struct*", "wstr")
	Else
		DllStructSetData($tSetText, 2, $CP_ACP)
		$iRet = _SendMessage($hWnd, $EM_SETTEXTEX, $tSetText, $sText, 0, "struct*", "STR")
	EndIf
	If Not $iRet Then Return SetError(700, 0, False)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_AppendText

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_AutoDetectURL($hWnd, $bState)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not IsBool($bState) Then Return SetError(102, 0, False)

	If _SendMessage($hWnd, $EM_AUTOURLDETECT, $bState) Then Return SetError(700, 0, False)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_AutoDetectURL

; #FUNCTION# ====================================================================================================================
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_CanPaste($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Local $iRet = _SendMessage($hWnd, $EM_CANPASTE, 0, 0)
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlRichEdit_CanPaste

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_CanPasteSpecial($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Return _SendMessage($hWnd, $EM_CANPASTE, $__g_sGRE_CF_RTF, 0) <> 0 _
			And _SendMessage($hWnd, $EM_CANPASTE, $__g_sGRE_CF_RETEXTOBJ, 0) <> 0
EndFunc   ;==>_GUICtrlRichEdit_CanPasteSpecial

; #FUNCTION# ====================================================================================================================
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_CanRedo($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Return _SendMessage($hWnd, $EM_CANREDO, 0, 0) <> 0
EndFunc   ;==>_GUICtrlRichEdit_CanRedo

; #FUNCTION# ====================================================================================================================
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_CanUndo($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Return _SendMessage($hWnd, $EM_CANUNDO, 0, 0) <> 0
EndFunc   ;==>_GUICtrlRichEdit_CanUndo

; #FUNCTION# ====================================================================================================================
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_ChangeFontSize($hWnd, $iIncrement)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not __GCR_IsNumeric($iIncrement) Then SetError(102, 0, False)

	If Not _GUICtrlRichEdit_IsTextSelected($hWnd) Then Return SetError(-1, 0, False)
	Return _SendMessage($hWnd, $EM_SETFONTSIZE, $iIncrement, 0) <> 0
EndFunc   ;==>_GUICtrlRichEdit_ChangeFontSize

; #FUNCTION# ====================================================================================================================
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_Copy($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	_SendMessage($hWnd, $__RICHEDITCONSTANT_WM_COPY, 0, 0)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_Copy

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_Create($hWnd, $sText, $iLeft, $iTop, $iWidth = 150, $iHeight = 150, $iStyle = -1, $iExStyle = -1)
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0) ; Invalid Window handle for _GUICtrlRichEdit_Create 1st parameter
	If Not IsString($sText) Then Return SetError(2, 0, 0) ; 2nd parameter not a string for _GUICtrlRichEdit_Create

	If Not __GCR_IsNumeric($iWidth, ">0,-1") Then Return SetError(105, 0, 0)
	If Not __GCR_IsNumeric($iHeight, ">0,-1") Then Return SetError(106, 0, 0)
	If Not __GCR_IsNumeric($iStyle, ">=0,-1") Then Return SetError(107, 0, 0)
	If Not __GCR_IsNumeric($iExStyle, ">=0,-1") Then Return SetError(108, 0, 0)

	If $iWidth = -1 Then $iWidth = 150
	If $iHeight = -1 Then $iHeight = 150
	If $iStyle = -1 Then $iStyle = BitOR($ES_WANTRETURN, $ES_MULTILINE)

	If BitAND($iStyle, $ES_MULTILINE) <> 0 Then $iStyle = BitOR($iStyle, $ES_WANTRETURN)
	If $iExStyle = -1 Then $iExStyle = 0x200 ;	$DS_FOREGROUND

	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE)
	If BitAND($iStyle, $ES_READONLY) = 0 Then $iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_TABSTOP)

	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)

	__GCR_Init()

	Local $hRichEdit = _WinAPI_CreateWindowEx($iExStyle, $__g_sRTFClassName, "", $iStyle, $iLeft, $iTop, $iWidth, _
			$iHeight, $hWnd, $nCtrlID)
	If $hRichEdit = 0 Then Return SetError(700, 0, False)

	__GCR_SetOLECallback($hRichEdit)
	_SendMessage($hRichEdit, $__RICHEDITCONSTANT_WM_SETFONT, _WinAPI_GetStockObject($DEFAULT_GUI_FONT), True)
	_GUICtrlRichEdit_AppendText($hRichEdit, $sText)
	Return $hRichEdit
EndFunc   ;==>_GUICtrlRichEdit_Create

; #FUNCTION# ====================================================================================================================
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_Cut($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	_SendMessage($hWnd, $__RICHEDITCONSTANT_WM_CUT, 0, 0)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_Cut

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_Deselect($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	_SendMessage($hWnd, $EM_SETSEL, -1, 0)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_Deselect

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(2, 2, False)

	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hRELastWnd) Then
			Local $nCtrlID = _WinAPI_GetDlgCtrlID($hWnd)
			Local $hParent = _WinAPI_GetParent($hWnd)
			$iDestroyed = _WinAPI_DestroyWindow($hWnd)
			Local $iRet = __UDF_FreeGlobalID($hParent, $nCtrlID)
			If Not $iRet Then
				; can check for errors here if needed, for debug
			EndIf
		Else
			; Not Allowed to Destroy Other Applications Control(s)
			Return SetError(1, 1, False)
		EndIf
	Else
		$iDestroyed = GUICtrlDelete($hWnd)
	EndIf
	If $iDestroyed Then $hWnd = 0
	Return $iDestroyed <> 0
EndFunc   ;==>_GUICtrlRichEdit_Destroy

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_EmptyUndoBuffer($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	_SendMessage($hWnd, $EM_EMPTYUNDOBUFFER, 0, 0)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_EmptyUndoBuffer

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......: jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_FindText($hWnd, $sText, $bForward = True, $bMatchCase = False, $bWholeWord = False, $iBehavior = 0)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, -1)
	If $sText = "" Then Return SetError(102, 0, -1)
	If Not IsBool($bForward) Then Return SetError(103, 0, -1)
	If Not IsBool($bMatchCase) Then Return SetError(104, 0, -1)
	If Not IsBool($bWholeWord) Then Return SetError(105, 0, -1)
	If Not __GCR_IsNumeric($iBehavior) Then Return SetError(1061, 0, -1)
	If BitAND($iBehavior, BitNOT(BitOR($FR_MATCHALEFHAMZA, $FR_MATCHDIAC, $FR_MATCHKASHIDA))) <> 0 Then Return SetError(1062, 0, -1)

	Local $iLen = StringLen($sText) + 3
	Local $tText = DllStructCreate("wchar[" & $iLen & "]")
	DllStructSetData($tText, 1, $sText)
	Local $tFindtext = DllStructCreate($tagFINDTEXT)
	Local $aiAnchorActive
	Local $bSel = _GUICtrlRichEdit_IsTextSelected($hWnd)
	If $bSel Then
		$aiAnchorActive = _GUICtrlRichEdit_GetSelAA($hWnd)
	Else
		$aiAnchorActive = _GUICtrlRichEdit_GetSel($hWnd)
	EndIf
	DllStructSetData($tFindtext, 1, $aiAnchorActive[0])
	DllStructSetData($tFindtext, 2, ($bForward ? -1 : 0)) ; to end else to start
	DllStructSetData($tFindtext, 3, DllStructGetPtr($tText))

	Local Const $FR_DOWN = 0x00000001
	Local Const $FR_WHOLEWORD = 0x00000002
	Local Const $FR_MATCHCASE = 0x00000004
	Local $wParam = 0
	If $bForward Then $wParam = $FR_DOWN
	If $bWholeWord Then $wParam = BitOR($wParam, $FR_WHOLEWORD)
	If $bMatchCase Then $wParam = BitOR($wParam, $FR_MATCHCASE)
	$wParam = BitOR($wParam, $iBehavior)
	Return _SendMessage($hWnd, $EM_FINDTEXTW, $wParam, $tFindtext, "wparam", "ptr", "struct*")
EndFunc   ;==>_GUICtrlRichEdit_FindText

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......: jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_FindTextInRange($hWnd, $sText, $iStart = 0, $iEnd = -1, $bMatchCase = False, $bWholeWord = False, $iBehavior = 0)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)
	If $sText = "" Then Return SetError(102, 0, 0)
	If Not __GCR_IsNumeric($iStart, ">=0,-1") Then Return SetError(103, 0, 0)
	If Not __GCR_IsNumeric($iEnd, ">=0,-1") Then Return SetError(104, 0, 0)
	If Not IsBool($bMatchCase) Then Return SetError(105, 0, 0)
	If Not IsBool($bWholeWord) Then Return SetError(106, 0, 0)
	If Not __GCR_IsNumeric($iBehavior) Then Return SetError(1071, 0, 0)
	If BitAND($iBehavior, BitNOT(BitOR($FR_MATCHALEFHAMZA, $FR_MATCHDIAC, $FR_MATCHKASHIDA))) <> 0 Then Return SetError(1072, 0, 0)

	Local $iLen = StringLen($sText) + 3
	Local $tText = DllStructCreate("wchar Text[" & $iLen & "]")
	DllStructSetData($tText, "Text", $sText)
	Local $tFindtext = DllStructCreate($tagFINDTEXTEX)
	DllStructSetData($tFindtext, "cpMin", $iStart)
	DllStructSetData($tFindtext, "cpMax", $iEnd)
	DllStructSetData($tFindtext, "lpstrText", DllStructGetPtr($tText))

	Local Const $FR_DOWN = 0x00000001
	Local Const $FR_WHOLEWORD = 0x00000002
	Local Const $FR_MATCHCASE = 0x00000004
	Local $wParam = 0
	If $iEnd >= $iStart Or $iEnd = -1 Then
		$wParam = $FR_DOWN
	EndIf
	If $bWholeWord Then $wParam = BitOR($wParam, $FR_WHOLEWORD)
	If $bMatchCase Then $wParam = BitOR($wParam, $FR_MATCHCASE)
	$wParam = BitOR($wParam, $iBehavior)
	_SendMessage($hWnd, $EM_FINDTEXTEXW, $wParam, $tFindtext, "iWparam", "ptr", "struct*")
	Local $aRet[2]
	$aRet[0] = DllStructGetData($tFindtext, "cpMinRang")
	$aRet[1] = DllStructGetData($tFindtext, "cpMaxRange")
	Return $aRet
EndFunc   ;==>_GUICtrlRichEdit_FindTextInRange

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......: jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetCharAttributes($hWnd)
	Local Const $aV[17][3] = [ _
			["bo", $CFM_BOLD, $CFE_BOLD], ["di", $CFM_DISABLED, $CFE_DISABLED], _
			["em", $CFM_EMBOSS, $CFE_EMBOSS], ["hi", $CFM_HIDDEN, $CFE_HIDDEN], _
			["im", $CFM_IMPRINT, $CFE_IMPRINT], ["it", $CFM_ITALIC, $CFE_ITALIC], _
			["li", $CFM_LINK, $CFE_LINK], ["ou", $CFM_OUTLINE, $CFE_OUTLINE], _
			["pr", $CFM_PROTECTED, $CFE_PROTECTED], ["re", $CFM_REVISED, $CFE_REVISED], _
			["sh", $CFM_SHADOW, $CFE_SHADOW], ["sm", $CFM_SMALLCAPS, $CFE_SMALLCAPS], _
			["st", $CFM_STRIKEOUT, $CFE_STRIKEOUT], ["sb", $CFM_SUBSCRIPT, $CFE_SUBSCRIPT], _
			["sp", $CFM_SUPERSCRIPT, $CFE_SUPERSCRIPT], ["un", $CFM_UNDERLINE, $CFE_UNDERLINE], _
			["al", $CFM_ALLCAPS, $CFE_ALLCAPS]]

	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")

	Local $bSel = _GUICtrlRichEdit_IsTextSelected($hWnd)
	If Not $bSel Then Return SetError(-1, 0, "")
	Local $tCharFormat = DllStructCreate($tagCHARFORMAT2)
	DllStructSetData($tCharFormat, 1, DllStructGetSize($tCharFormat))
	; $wParam = ($bDefault ? $SCF_DEFAULT : $SCF_SELECTION)	; SCF_DEFAULT doesn't work
	Local $iMask = _SendMessage($hWnd, $EM_GETCHARFORMAT, $SCF_SELECTION, $tCharFormat, 0, "wparam", "struct*")

	Local $iEffects = DllStructGetData($tCharFormat, 3)

	Local $sStatesAndAtts = "", $sState, $bM, $bE
	For $i = 0 To UBound($aV, $UBOUND_ROWS) - 1
		$bM = BitAND($iMask, $aV[$i][1]) = $aV[$i][1]
		$bE = BitAND($iEffects, $aV[$i][2]) = $aV[$i][2]
		If $bSel Then
			If $bM Then
				If $bE Then
					$sState = "+"
				Else
					$sState = "-"
				EndIf
			Else
				$sState = "~"
			EndIf
		Else
			If $bM Then
				$sState = "+"
			Else
				$sState = "-"
			EndIf
		EndIf
		If $sState <> "-" Then $sStatesAndAtts &= $aV[$i][0] & $sState
	Next
	Return $sStatesAndAtts
EndFunc   ;==>_GUICtrlRichEdit_GetCharAttributes

; #FUNCTION# ====================================================================================================================
; Authors........: grham
; Modified ......: Chris Haslam (c.haslam), jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetCharBkColor($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)

	Local $tCharFormat = DllStructCreate($tagCHARFORMAT2)
	DllStructSetData($tCharFormat, 1, DllStructGetSize($tCharFormat))
	__GCR_SendGetCharFormatMessage($hWnd, $tCharFormat)
	Local $iEffects = DllStructGetData($tCharFormat, 3)
	Local $iBkColor
	If BitAND($iEffects, $CFE_AUTOBACKCOLOR) = $CFE_AUTOBACKCOLOR Then
		$iBkColor = _WinAPI_GetSysColor($__RICHEDITCONSTANT_COLOR_WINDOWTEXT)
	Else
		$iBkColor = DllStructGetData($tCharFormat, 12)
	EndIf
	Return SetExtended(BitAND($iEffects, $CFM_BACKCOLOR) <> 0, $iBkColor)
EndFunc   ;==>_GUICtrlRichEdit_GetCharBkColor

; #FUNCTION# ====================================================================================================================
; Authors........: grham
; Modified ......: Chris Haslam (c.haslam), jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetCharColor($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)

	Local $tCharFormat = DllStructCreate($tagCHARFORMAT)
	DllStructSetData($tCharFormat, 1, DllStructGetSize($tCharFormat))
	__GCR_SendGetCharFormatMessage($hWnd, $tCharFormat)
	Local $iEffects = DllStructGetData($tCharFormat, 3)
	Local $iColor
	If BitAND($iEffects, $CFE_AUTOCOLOR) = $CFE_AUTOCOLOR Then
		$iColor = _WinAPI_GetSysColor($__RICHEDITCONSTANT_COLOR_WINDOWTEXT)
	Else
		$iColor = DllStructGetData($tCharFormat, 6)
	EndIf
	Return SetExtended(BitAND($iEffects, $CFM_COLOR) <> 0, $iColor)
EndFunc   ;==>_GUICtrlRichEdit_GetCharColor

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: Prog@ndy, Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetCharPosFromXY($hWnd, $iX, $iY)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)
	If Not __GCR_IsNumeric($iX) Then Return SetError(102, 0, 0)
	If Not __GCR_IsNumeric($iY) Then Return SetError(103, 0, 0)

	Local $aiRect = _GUICtrlRichEdit_GetRECT($hWnd)
	If $iX < $aiRect[0] Or $iX > $aiRect[2] Or $iY < $aiRect[1] Or $iY > $aiRect[3] Then Return -1
	Local $tPointL = DllStructCreate("LONG x; LONG y;")
	DllStructSetData($tPointL, 1, $iX)
	DllStructSetData($tPointL, 2, $iY)
	Local $iRet = _SendMessage($hWnd, $EM_CHARFROMPOS, 0, $tPointL, 0, "wparam", "struct*")
	If Not $iRet Then Return SetError(-1, 0, 0)
	Return $iRet
EndFunc   ;==>_GUICtrlRichEdit_GetCharPosFromXY

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetCharPosOfNextWord($hWnd, $iCpStart)
	; WB_RIGHT, WB_LEFT, WB_RIGHTBREAK, WB_LEFTBREAK and WB_ISDELIMITER don't work properly or at all
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)
	If Not __GCR_IsNumeric($iCpStart) Then Return SetError(102, 0, 0)

	Return _SendMessage($hWnd, $EM_FINDWORDBREAK, $WB_MOVEWORDRIGHT, $iCpStart)
EndFunc   ;==>_GUICtrlRichEdit_GetCharPosOfNextWord

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetCharPosOfPreviousWord($hWnd, $iCpStart)
	; WB_RIGHT, WB_LEFT, WB_RIGHTBREAK, WB_LEFTBREAK and WB_ISDELIMITER don't work properly or at all
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)
	If Not __GCR_IsNumeric($iCpStart) Then Return SetError(102, 0, 0)

	Return _SendMessage($hWnd, $EM_FINDWORDBREAK, $WB_MOVEWORDLEFT, $iCpStart)
EndFunc   ;==>_GUICtrlRichEdit_GetCharPosOfPreviousWord

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetCharWordBreakInfo($hWnd, $iCp)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")
	If Not __GCR_IsNumeric($iCp) Then Return SetError(102, 0, "")

	Local $iRet = _SendMessage($hWnd, $EM_FINDWORDBREAK, $WB_CLASSIFY, $iCp)
	Local $iClass = BitAND($iRet, 0xF0)
	Local $sRet = ""
	If BitAND($iClass, $WBF_BREAKAFTER) Then $sRet &= "c"
	If BitAND($iClass, $WBF_BREAKLINE) Then $sRet &= "d"
	If BitAND($iClass, $WBF_ISWHITE) Then $sRet &= "w"
	$sRet &= ";" & BitAND($iRet, 0xF)
	Return $sRet
EndFunc   ;==>_GUICtrlRichEdit_GetCharWordBreakInfo

; #FUNCTION# ====================================================================================================================
; Authors........: jpm
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetBkColor($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)

	Local $iBkColor = _SendMessage($hWnd, $EM_SETBKGNDCOLOR, False, 0)
	_SendMessage($hWnd, $EM_SETBKGNDCOLOR, False, $iBkColor)
	Return $iBkColor
EndFunc   ;==>_GUICtrlRichEdit_GetBkColor

; #FUNCTION# ====================================================================================================================
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam), jpm, Prog@ndy
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetText($hWnd, $bCrToCrLf = False, $iCodePage = 0, $sReplChar = "")
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")
	If Not IsBool($bCrToCrLf) Then Return SetError(102, 0, "")
	If Not __GCR_IsNumeric($iCodePage) Then Return SetError(103, 0, "")

	Local $iLen = _GUICtrlRichEdit_GetTextLength($hWnd, False, True) + 1
	Local $sUni = ''
	If $iCodePage = $CP_UNICODE Or Not $iCodePage Then $sUni = "w"
	Local $tText = DllStructCreate($sUni & "char[" & $iLen & "]")

	Local $tGetTextEx = DllStructCreate($tagGETTEXTEX)
	DllStructSetData($tGetTextEx, "cb", DllStructGetSize($tText))

	Local $iFlags = 0
	If $bCrToCrLf Then $iFlags = $GT_USECRLF
	DllStructSetData($tGetTextEx, "flags", $iFlags)

	If $iCodePage = 0 Then $iCodePage = $CP_UNICODE
	DllStructSetData($tGetTextEx, "codepage", $iCodePage)

	Local $pUsedDefChar = 0, $pDefaultChar = 0
	If $sReplChar <> "" Then
		Local $tDefaultChar = DllStructCreate("char")
		$pDefaultChar = DllStructGetPtr($tDefaultChar, 1)
		DllStructSetData($tDefaultChar, 1, $sReplChar)
		Local $tUsedDefChar = DllStructCreate("bool")
		$pUsedDefChar = DllStructGetPtr($tUsedDefChar, 1)
	EndIf
	DllStructSetData($tGetTextEx, "lpDefaultChar", $pDefaultChar)
	DllStructSetData($tGetTextEx, "lpbUsedDefChar", $pUsedDefChar)

	Local $iRet = _SendMessage($hWnd, $EM_GETTEXTEX, $tGetTextEx, $tText, 0, "struct*", "struct*")
	If $iRet = 0 Then Return SetError(700, 0, "")
	If $sReplChar <> "" Then SetExtended(DllStructGetData($tUsedDefChar, 1) <> 0)
	Return DllStructGetData($tText, 1)
EndFunc   ;==>_GUICtrlRichEdit_GetText

; #FUNCTION# ====================================================================================================================
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetTextLength($hWnd, $bExact = True, $bChars = False)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)
	If Not IsBool($bExact) Then Return SetError(102, 0, 0)
	If Not IsBool($bChars) Then Return SetError(103, 0, 0)

	Local $tGetTextLen = DllStructCreate($tagGETTEXTLENGTHEX)
	Local $iFlags = BitOR($GTL_USECRLF, ($bExact ? $GTL_PRECISE : $GTL_CLOSE))
	$iFlags = BitOR($iFlags, ($bChars ? $GTL_DEFAULT : $GTL_NUMBYTES))
	DllStructSetData($tGetTextLen, 1, $iFlags)
	DllStructSetData($tGetTextLen, 2, ($bChars ? $CP_ACP : $CP_UNICODE))
	Local $iRet = _SendMessage($hWnd, $EM_GETTEXTLENGTHEX, $tGetTextLen, 0, 0, "struct*")
	Return $iRet
EndFunc   ;==>_GUICtrlRichEdit_GetTextLength

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetZoom($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)

	Local $wParam = 0, $lParam = 0
	Local $aI = _SendMessage($hWnd, $EM_GETZOOM, $wParam, $lParam, -1, "int*", "int*")
	If Not $aI[0] Then Return SetError(700, 0, 0)
	Local $iRet
	If $aI[3] = 0 And $aI[4] = 0 Then ; if a control that has not been zoomed
		$iRet = 100
	Else
		$iRet = $aI[3] / $aI[4] * 100
	EndIf
	Return StringFormat("%.2f", $iRet)
EndFunc   ;==>_GUICtrlRichEdit_GetZoom

; #FUNCTION# ====================================================================================================================
; Authors........: Gary Frost (custompcs at charter dot net)
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetFirstCharPosOnLine($hWnd, $iLine = -1)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)
	If Not __GCR_IsNumeric($iLine, ">0,-1") Then Return SetError(1021, 0, 0)

	If $iLine <> -1 Then $iLine -= 1
	Local $iRet = _SendMessage($hWnd, $EM_LINEINDEX, $iLine)
	If $iRet = -1 Then Return SetError(1022, 0, 0)
	Return $iRet
EndFunc   ;==>_GUICtrlRichEdit_GetFirstCharPosOnLine

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......: jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetFont($hWnd)
	; MSDN does not give a mask (CFM) for bPitchAndFamily so it appears that there is no way of knowing when it is valid => omitted here
	Local $aRet[3] = [0, "", 0]
	;, $iLcid = 1033
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)

	Local $tCharFormat = DllStructCreate($tagCHARFORMAT)
	DllStructSetData($tCharFormat, "cbSize", DllStructGetSize($tCharFormat))

	__GCR_SendGetCharFormatMessage($hWnd, $tCharFormat)

	If BitAND(DllStructGetData($tCharFormat, "dwMask"), $CFM_FACE) = $CFM_FACE Then _
			$aRet[1] = DllStructGetData($tCharFormat, "szFaceName")

	If BitAND(DllStructGetData($tCharFormat, "dwMask"), $CFM_SIZE) = $CFM_SIZE Then _
			$aRet[0] = DllStructGetData($tCharFormat, "yHeight") / 20

	If BitAND(DllStructGetData($tCharFormat, "dwMask"), $CFM_CHARSET) = $CFM_CHARSET Then _
			$aRet[2] = DllStructGetData($tCharFormat, "bCharSet")

	; available if using $tagCHARFORMAT2
	;If BitAND(DllStructGetData($tCharFormat, "dwMask"), $CFM_LCID) = $CFM_LCID Then _
	;$iLcid = DllStructGetData($tCharFormat, 13)

	Return $aRet
EndFunc   ;==>_GUICtrlRichEdit_GetFont

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: Chris Haslam (c.haslam), jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetRECT($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)

	Local $tRECT = DllStructCreate($tagRECT)
	_SendMessage($hWnd, $EM_GETRECT, 0, $tRECT, 0, "wparam", "struct*")
	Local $aiRect[4]
	$aiRect[0] = DllStructGetData($tRECT, "Left")
	$aiRect[1] = DllStructGetData($tRECT, "Top")
	$aiRect[2] = DllStructGetData($tRECT, "Right")
	$aiRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aiRect
EndFunc   ;==>_GUICtrlRichEdit_GetRECT

; #FUNCTION# ====================================================================================================================
; Authors........: Gary Frost (custompcs at charter dot net)
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetLineCount($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)

	Return _SendMessage($hWnd, $EM_GETLINECOUNT)
EndFunc   ;==>_GUICtrlRichEdit_GetLineCount

; #FUNCTION# ====================================================================================================================
; Authors........: Gary Frost (custompcs at charter dot net)
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetLineLength($hWnd, $iLine)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)
	If Not __GCR_IsNumeric($iLine, ">0,-1") Then Return SetError(102, 0, 0)

	Local $iCharPos = _GUICtrlRichEdit_GetFirstCharPosOnLine($hWnd, $iLine)
	Local $iRet = _SendMessage($hWnd, $EM_LINELENGTH, $iCharPos)
	Return $iRet
EndFunc   ;==>_GUICtrlRichEdit_GetLineLength

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetLineNumberFromCharPos($hWnd, $iCharPos)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)
	If Not __GCR_IsNumeric($iCharPos, ">=0") Then Return SetError(102, 0, 0)

	Return _SendMessage($hWnd, $EM_EXLINEFROMCHAR, 0, $iCharPos) + 1
EndFunc   ;==>_GUICtrlRichEdit_GetLineNumberFromCharPos

; #FUNCTION# ====================================================================================================================
; Author ........: Prog@ndy
; Modified.......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetNextRedo($hWnd, $bName = True)
	Local Const $aS[6] = ["Unknown", "Typing", "Delete", "Drag and drop", "Cut", "Paste"]
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")
	If Not IsBool($bName) Then Return SetError(102, 0, "")

	Local $iUid = _SendMessage($hWnd, $EM_GETREDONAME, 0, 0)
	If $bName Then
		Return $aS[$iUid]
	Else
		Return $iUid
	EndIf
EndFunc   ;==>_GUICtrlRichEdit_GetNextRedo

; #FUNCTION# ====================================================================================================================
; Author ........: Prog@ndy
; Modified.......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetNextUndo($hWnd, $bName = True)
	Local Const $aS[6] = ["Unknown", "Typing", "Delete", "Drag and drop", "Cut", "Paste"]
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")
	If Not IsBool($bName) Then Return SetError(102, 0, "")

	Local $iUid = _SendMessage($hWnd, $EM_GETUNDONAME, 0, 0)
	If $bName Then
		Return $aS[$iUid]
	Else
		Return $iUid
	EndIf
EndFunc   ;==>_GUICtrlRichEdit_GetNextUndo

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetNumberOfFirstVisibleLine($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)
	Return _SendMessage($hWnd, $EM_GETFIRSTVISIBLELINE) + 1
EndFunc   ;==>_GUICtrlRichEdit_GetNumberOfFirstVisibleLine

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetParaAlignment($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")

	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, 1, DllStructGetSize($tParaFormat))

	__GCR_SendGetParaFormatMessage($hWnd, $tParaFormat)
	If @error Then Return SetError(@error, 0, "")
	Local $iMask = DllStructGetData($tParaFormat, 2)
	Local $iAlignment = DllStructGetData($tParaFormat, 8)
	Local $sRet = ""
	Switch ($iAlignment)
		Case $PFA_LEFT
			$sRet = "l"
		Case $PFA_CENTER
			$sRet = "c"
		Case $PFA_RIGHT
			$sRet = "r"
		Case $PFA_JUSTIFY
			$sRet = "j"
		Case $PFA_FULL_INTERWORD
			$sRet = "w"
	EndSwitch
	$sRet &= ";" & __GCR_GetParaScopeChar($hWnd, $iMask, $PFM_ALIGNMENT)
	Return $sRet
EndFunc   ;==>_GUICtrlRichEdit_GetParaAlignment

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetParaAttributes($hWnd)
	; dwMask is always BitOR of all PFMs
	Local Enum $eAbbrev = 0, $eEffect, $eInverted
	; MS seems to mean LINENUMBER and WIDOWCONTROL, not NOLINENUMBER and NOWIDOWCONTROL
	Local Const $aV[9][3] = [ _	; abbrev, mask, effect, inverted
			["fpg", $PFE_PAGEBREAKBEFORE, False], _
			["hyp", $PFE_DONOTHYPHEN, True], _
			["kpt", $PFE_KEEP, False], _
			["kpn", $PFE_KEEPNEXT, False], _
			["pwo", $PFE_NOWIDOWCONTROL, False], _
			["r2l", $PFE_RTLPARA, False], _
			["row", $PFE_TABLE, False], _
			["sbs", $PFE_SIDEBYSIDE, False], _
			["sln", $PFE_NOLINENUMBER, False]]
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")

	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, 1, DllStructGetSize($tParaFormat))
	__GCR_SendGetParaFormatMessage($hWnd, $tParaFormat)
	If @error Then Return SetError(@error, 0, "")

	Local $iEffects = DllStructGetData($tParaFormat, "wEffects")

	Local $sStatesAndAtts = "", $sState
	For $i = 0 To UBound($aV, $UBOUND_ROWS) - 1
		$sStatesAndAtts &= $aV[$i][$eAbbrev]
		If BitAND($iEffects, $aV[$i][$eEffect]) = $aV[$i][$eEffect] Then
			$sState = ($aV[$i][$eInverted] ? "-" : "+")
		Else
			$sState = ($aV[$i][$eInverted] ? "+" : "-")
		EndIf
		$sStatesAndAtts &= $sState & ";"
	Next
	$sStatesAndAtts &= (_GUICtrlRichEdit_IsTextSelected($hWnd) ? "f" : "c")
	Return $sStatesAndAtts
EndFunc   ;==>_GUICtrlRichEdit_GetParaAttributes

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetParaBorder($hWnd)
	Local Const $avLocs[6][2] = [["l", 1], ["r", 2], ["t", 4], ["b", 8], ["i", 16], ["o", 32]]
	Local Const $avLS[12] = ["none", .75, 1.5, 2.25, 3, 4.5, 6, ".75d", "1.5d", "2.25d", ".75g", ".75gd"]
	Local Const $sClrs = "blk;blu;cyn;grn;mag;red;yel;whi;dbl;dgn;dmg;drd;dyl;dgy;lgy;"
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")

	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, 1, DllStructGetSize($tParaFormat))
	__GCR_SendGetParaFormatMessage($hWnd, $tParaFormat)
	If @error Then Return SetError(@error, 0, "")

	Local $iMask = DllStructGetData($tParaFormat, 2)
	Local $iSpace = DllStructGetData($tParaFormat, 22)
	;	$iWidth = DllStructGetData($tParaFormat, 23)	; wBorderWidth does not round-trip in Rich Edit 3.0
	Local $iBorders = DllStructGetData($tParaFormat, 24)

	Local $sRet = ""
	For $i = 0 To UBound($avLocs, $UBOUND_ROWS) - 1
		If BitAND($iBorders, $avLocs[$i][1]) Then $sRet &= $avLocs[$i][0]
	Next
	$sRet &= ";"
	$sRet &= $avLS[BitShift(BitAND($iBorders, 0xF00), 8)]
	$sRet &= ";"
	If BitAND($iBorders, 64) Then
		$sRet &= "aut"
	Else
		$sRet &= StringMid($sClrs, BitShift(BitAND($iBorders, 0xF000), 12) * 4 + 1, 3)
	EndIf
	$sRet &= ";"
	$sRet &= __GCR_ConvertTwipsToSpaceUnit($iSpace) & ";" ; & __GCR_ConvertTwipsToSpaceUnit($iWidth) & ";"
	$sRet &= __GCR_GetParaScopeChar($hWnd, $iMask, $PFM_BORDER)
	Return $sRet
EndFunc   ;==>_GUICtrlRichEdit_GetParaBorder

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetParaIndents($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")

	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, 1, DllStructGetSize($tParaFormat))
	DllStructSetData($tParaFormat, "dwMask", BitOR($PFM_STARTINDENT, $PFM_OFFSET))
	__GCR_SendGetParaFormatMessage($hWnd, $tParaFormat)
	If @error Then Return SetError(@error, 0, "")

	Local $iMask = DllStructGetData($tParaFormat, "dwMask")
	Local $iIdxSI = DllStructGetData($tParaFormat, "dxStartIndent") ; absolute
	Local $iIdxOfs = DllStructGetData($tParaFormat, "dxOffset")
	Local $iDxRI = DllStructGetData($tParaFormat, "dxRightIndent")

	Local $iLeft = __GCR_ConvertTwipsToSpaceUnit($iIdxSI + $iIdxOfs)
	Local $iFirstLine = __GCR_ConvertTwipsToSpaceUnit(-$iIdxOfs)
	Local $iRight = __GCR_ConvertTwipsToSpaceUnit($iDxRI)

	Local $iRet = $iLeft & ";" & $iRight & ";" & $iFirstLine & ";" & __GCR_GetParaScopeChar($hWnd, $iMask, $PFM_STARTINDENT)
	Return $iRet
EndFunc   ;==>_GUICtrlRichEdit_GetParaIndents

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetParaNumbering($hWnd)
	Local Const $avRoman[7][2] = [[1000, "m"], [500, "d"], [100, "c"], [50, "l"], [10, "x"], [5, "v"], [1, "i"]]

	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")

	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, 1, DllStructGetSize($tParaFormat))
	DllStructSetData($tParaFormat, 2, BitOR($PFM_NUMBERING, $PFM_NUMBERINGSTART, $PFM_NUMBERINGSTYLE))
	__GCR_SendGetParaFormatMessage($hWnd, $tParaFormat)
	If @error Then Return SetError(@error, 0, "")

	Local $iMask = DllStructGetData($tParaFormat, "dwMask")
	Local $iChar = DllStructGetData($tParaFormat, "wNumbering")
	Local $iStart = DllStructGetData($tParaFormat, "wNumberingStart")
	Local $iStyle = DllStructGetData($tParaFormat, "wNumberingStyle")
	Local $iTab = DllStructGetData($tParaFormat, "wNumberingTab")
	Local $sRet = ""
	Switch $iChar
		Case 0 ; no numbering
			$sRet = ""
		Case 1 ; bullet
			$sRet = "."
		Case 2 ; Arabic
			$sRet = $iStart
		Case 3
			$sRet = Chr(Asc("a") + $iStart - 1)
		Case 4
			$sRet = Chr(Asc("a") + $iStart - 1)
		Case 5, 6 ; lower case Roman
			For $i = 0 To UBound($avRoman, $UBOUND_ROWS) - 2 Step 2
				For $j = $i To $i + 1
					While $iStart >= $avRoman[$j][0]
						$sRet &= $avRoman[$j][1]
						$iStart -= $avRoman[$j][0]
					WEnd
					If $iStart = $avRoman[$j][0] - 1 Then
						$sRet &= $avRoman[$i + 2][1] & $avRoman[$j][1]
						$iStart -= $avRoman[$j][0] - $avRoman[$i + 2][0]
					EndIf
				Next
			Next
			While $iStart > 0
				$sRet &= "i"
				$iStart -= 1
			WEnd
			If $iChar = 6 Then $sRet = StringUpper($sRet)
	EndSwitch
	If $iChar > 1 Then
		Switch $iStyle
			Case 0
				$sRet &= ")"
			Case 0x100
				$sRet = "(" & $sRet & ")"
			Case 0x200
				$sRet &= "."
			Case 0x300 ; display only number
				; do nothing
		EndSwitch
	EndIf
	; set number-to-text spacing based on font at anchor
	Local $aV = _GUICtrlRichEdit_GetFont($hWnd)
	Local $iPoints = $aV[0]
	Local $iQspaces = Round($iTab / ($iPoints * 20), 0)
	For $i = 1 To $iQspaces
		$sRet &= " "
	Next
	$sRet &= ";"
	$sRet &= (($iChar = 5 Or $iChar = 6) ? "Roman;" : ";")
	$sRet &= __GCR_ConvertTwipsToSpaceUnit($iTab) & ";"
	$sRet &= __GCR_GetParaScopeChar($hWnd, $iMask, BitOR($PFM_NUMBERING, $PFM_NUMBERINGSTART, $PFM_NUMBERINGSTYLE))
	Return $sRet
EndFunc   ;==>_GUICtrlRichEdit_GetParaNumbering

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetParaShading($hWnd)
	Local Const $asStyles[13] = ["non", "dhz", "dvt", "ddd", "dud", "dgr", "dtr", "lhz", "lrt", "ldd", "lud", _
			"lgr", "ltr"]
	Local Const $asClrs[16] = ["blk", "blu", "cyn", "grn", "mag", "red", "yel", "whi", "dbl", "dgn", "dmg", _
			"drd", "dyl", "dgy", "lgy"]

	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")

	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, 1, DllStructGetSize($tParaFormat))
	__GCR_SendGetParaFormatMessage($hWnd, $tParaFormat)
	If @error Then Return SetError(@error, 0, "")

	Local $iMask = DllStructGetData($tParaFormat, "dwMask")
	Local $iWeight = DllStructGetData($tParaFormat, "wShadingWeight")
	Local $iS = DllStructGetData($tParaFormat, "wShadingStyle")

	Local $sRet = $iWeight & ";"
	Local $iN = BitAND($iS, 0xF)
	$sRet &= $asStyles[$iN] & ";"
	$iN = BitShift(BitAND($iS, 0xF0), 4)
	$sRet &= $asClrs[$iN] & ";"
	$iN = BitShift(BitAND($iS, 0xF00), 8)
	$sRet &= $asClrs[$iN] & ";"
	$sRet &= __GCR_GetParaScopeChar($hWnd, $iMask, $PFM_SHADING)
	Return $sRet
EndFunc   ;==>_GUICtrlRichEdit_GetParaShading

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetParaSpacing($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")

	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, "cbSize", DllStructGetSize($tParaFormat))
	__GCR_SendGetParaFormatMessage($hWnd, $tParaFormat)
	If @error Then Return SetError(@error, 0, "")
	Local $iInter = DllStructGetData($tParaFormat, "dyLineSpacing")
	Local $iRule = DllStructGetData($tParaFormat, "bLineSpacingRule")
	Local $sRet = ""
	Switch $iRule
		Case 0
			$sRet = "1 line;"
		Case 1
			$sRet = "1.5 lines;"
		Case 2
			$sRet = "2 lines;"
		Case 3, 4
			$sRet = __GCR_ConvertTwipsToSpaceUnit($iInter) & ";"
		Case 5
			$sRet = StringFormat("%.2f", $iInter / 20) & " lines;"
	EndSwitch
	Local $iMask = 0 ; perhaps a BUG (jpm) always 0
	$sRet &= __GCR_GetParaScopeChar($hWnd, $iMask, $PFM_LINESPACING) & ";"

	Local $iBefore = DllStructGetData($tParaFormat, "dySpaceBefore")
	$sRet &= __GCR_ConvertTwipsToSpaceUnit($iBefore) & ";"
	$sRet &= __GCR_GetParaScopeChar($hWnd, $iMask, $PFM_SPACEBEFORE) & ";"

	Local $iAfter = DllStructGetData($tParaFormat, "dySPaceAfter")
	$sRet &= __GCR_ConvertTwipsToSpaceUnit($iAfter) & ";"
	$sRet &= __GCR_GetParaScopeChar($hWnd, $iMask, $PFM_SPACEAFTER)
	Return $sRet
EndFunc   ;==>_GUICtrlRichEdit_GetParaSpacing

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetParaTabStops($hWnd)
	Local Const $asKind[5] = ["l", "c", "r", "d", "b"], $asLeader[6] = [" ", ".", "-", "_", "t", "="]
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")

	Local $tParaFormat = DllStructCreate($tagPARAFORMAT)
	DllStructSetData($tParaFormat, "cbSize", DllStructGetSize($tParaFormat))
	__GCR_SendGetParaFormatMessage($hWnd, $tParaFormat)
	If @error Then Return SetError(@error, 0, "")

	Local $iMask = DllStructGetData($tParaFormat, "dwMask")
	Local $iQtabs = DllStructGetData($tParaFormat, "cTabCount")
	Local $sRet = $iQtabs & ";"
	Local $iN, $iM
	For $i = 1 To $iQtabs
		$iN = DllStructGetData($tParaFormat, "rgxTabs", $i)
		$sRet &= __GCR_ConvertTwipsToSpaceUnit(BitAND($iN, 0xFFFFF))
		$iM = BitAND(BitShift($iN, 24), 0xF)
		$sRet &= $asKind[$iM]
		$iM = BitAND(BitShift($iN, 28), 0xF)
		$sRet &= $asLeader[$iM] & ";"
	Next
	$sRet &= __GCR_GetParaScopeChar($hWnd, $iMask, $PFM_TABSTOPS)
	Return $sRet
EndFunc   ;==>_GUICtrlRichEdit_GetParaTabStops

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetPasswordChar($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)

	Local $n = _SendMessage($hWnd, $EM_GETPASSWORDCHAR)
	Return ($n = 0) ? "" : Chr($n)
EndFunc   ;==>_GUICtrlRichEdit_GetPasswordChar

; #FUNCTION# ====================================================================================================================
; Author ........: unknown
; Modified.......: Chris Haslam (c.haslam), jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetScrollPos($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)

	Local $tPoint = DllStructCreate($tagPOINT)
	_SendMessage($hWnd, $EM_GETSCROLLPOS, 0, $tPoint, 0, "wparam", "struct*")
	Local $aRet[2]
	$aRet[0] = DllStructGetData($tPoint, "x")
	$aRet[1] = DllStructGetData($tPoint, "y")
	Return $aRet
EndFunc   ;==>_GUICtrlRichEdit_GetScrollPos

; #FUNCTION# ====================================================================================================================
; Author ........: Prog@ndy
; Modified.......: Chris Haslam (c.haslam), jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetSel($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)

	Local $tCharRange = DllStructCreate($tagCHARRANGE)
	_SendMessage($hWnd, $EM_EXGETSEL, 0, $tCharRange, 0, "wparam", "struct*")
	Local $aRet[2]
	$aRet[0] = DllStructGetData($tCharRange, 1)
	$aRet[1] = DllStructGetData($tCharRange, 2)
	Return $aRet
EndFunc   ;==>_GUICtrlRichEdit_GetSel

; #FUNCTION# ====================================================================================================================
; Author ........: Prog@ndy
; Modified.......: Chris Haslam (c.haslam), jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetSelAA($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)

	Local $aiLowHigh = _GUICtrlRichEdit_GetSel($hWnd)

	If $aiLowHigh[0] = $aiLowHigh[1] Then Return SetError(-1, 0, 0) ; no text selected

	_SendMessage($hWnd, $EM_SETSEL, -1, 0) ; deselect

	Local $aiNoSel = _GUICtrlRichEdit_GetSel($hWnd)

	Local $aRet[2]
	If $aiLowHigh[0] = $aiNoSel[0] Then ; if active < anchor
		$aRet[0] = $aiLowHigh[1]
		$aRet[1] = $aiLowHigh[0]
	Else
		$aRet = $aiLowHigh
	EndIf
	; restore selection
	_SendMessage($hWnd, $EM_SETSEL, $aiLowHigh[0], $aiLowHigh[1])
	_WinAPI_SetFocus($hWnd) ; need to have the selection updated
	Return $aRet
EndFunc   ;==>_GUICtrlRichEdit_GetSelAA

; #FUNCTION# ====================================================================================================================
; Author ........: Prog@ndy
; Modified.......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetSelText($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not _GUICtrlRichEdit_IsTextSelected($hWnd) Then Return SetError(-1, 0, -1)

	Local $aiLowHigh = _GUICtrlRichEdit_GetSel($hWnd)
	Local $tText = DllStructCreate("wchar[" & $aiLowHigh[1] - $aiLowHigh[0] + 1 & "]")
	_SendMessage($hWnd, $EM_GETSELTEXT, 0, $tText, 0, "wparam", "struct*")
	Return DllStructGetData($tText, 1)
EndFunc   ;==>_GUICtrlRichEdit_GetSelText

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetSpaceUnit()
	Switch $__g_iRTFTwipsPeSpaceUnit
		Case 1440
			Return "in"
		Case 567
			Return "cm"
		Case 56.7
			Return "mm"
		Case 20
			Return "pt"
		Case 1
			Return "tw"
	EndSwitch
EndFunc   ;==>_GUICtrlRichEdit_GetSpaceUnit

; #FUNCTION# ====================================================================================================================
; Authors........: Gary Frost (gafrost (custompcs@charter.net))
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetTextInLine($hWnd, $iLine)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not __GCR_IsNumeric($iLine, ">0,-1") Then Return SetError(1021, 0, False)
	If $iLine > _GUICtrlRichEdit_GetLineCount($hWnd) Then Return SetError(1022, 0, False)

	Local $iLen = _GUICtrlRichEdit_GetLineLength($hWnd, $iLine)
	If $iLen = 0 Then Return ""
	Local $tBuffer = DllStructCreate("short Len;wchar Text[" & $iLen + 2 & "]")
	DllStructSetData($tBuffer, "Len", $iLen + 2)
	If $iLine <> -1 Then $iLine -= 1
	Local $iRet = _SendMessage($hWnd, $EM_GETLINE, $iLine, $tBuffer, 10, "wparam", "struct*")
	If $iRet = 0 Then Return SetError(700, 0, False)
	Local $tString = DllStructCreate("wchar Text[" & $iLen + 1 & "]", DllStructGetPtr($tBuffer))
	Return StringLeft(DllStructGetData($tString, "Text"), $iLen)
EndFunc   ;==>_GUICtrlRichEdit_GetTextInLine

; #FUNCTION# ====================================================================================================================
; Authors........: Gary Frost (gafrost (custompcs@charter.net))
; Modified ......: Prog@ndy, Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetTextInRange($hWnd, $iStart, $iEnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not __GCR_IsNumeric($iStart, ">=0") Then Return SetError(102, 0, False)
	If Not __GCR_IsNumeric($iEnd, ">=0,-1") Then Return SetError(1031, 0, False)
	If Not ($iEnd > $iStart Or $iEnd = -1) Then Return SetError(1032, 0, False)

	Local $iLen = _GUICtrlRichEdit_GetTextLength($hWnd) ; can't use $iEnd - $iStart + 1 because of Unicode
	Local $tText = DllStructCreate("wchar[" & ($iLen + 4) & "]")
	Local $tTextRange = DllStructCreate($tagTEXTRANGE)
	DllStructSetData($tTextRange, 1, $iStart)
	DllStructSetData($tTextRange, 2, $iEnd)
	DllStructSetData($tTextRange, 3, DllStructGetPtr($tText))
	_SendMessage($hWnd, $EM_GETTEXTRANGE, 0, $tTextRange, 0, "wparam", "struct*")
	Return DllStructGetData($tText, 1)
EndFunc   ;==>_GUICtrlRichEdit_GetTextInRange

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetVersion()
	Return $__g_sRTFVersion
EndFunc   ;==>_GUICtrlRichEdit_GetVersion

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......: jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_GetXYFromCharPos($hWnd, $iCharPos)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)
	If Not __GCR_IsNumeric($iCharPos, ">=0") Then Return SetError(1021, 0, 0)
	If $iCharPos > _GUICtrlRichEdit_GetTextLength($hWnd) Then Return SetError(1022, 0, 0)

	Local $tPoint = DllStructCreate($tagPOINT)
	_SendMessage($hWnd, $EM_POSFROMCHAR, $tPoint, $iCharPos, 0, "struct*", "lparam")
	Local $aRet[2]
	$aRet[0] = DllStructGetData($tPoint, "X")
	$aRet[1] = DllStructGetData($tPoint, "Y")
	Return $aRet
EndFunc   ;==>_GUICtrlRichEdit_GetXYFromCharPos

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_GotoCharPos($hWnd, $iCharPos)
	_GUICtrlRichEdit_SetSel($hWnd, $iCharPos, $iCharPos)
	If @error Then Return SetError(@error, 0, False)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_GotoCharPos

; #FUNCTION# ====================================================================================================================
; Author ........: Prog@ndy
; Modified.......: Chris Haslam (c.haslam), jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_HideSelection($hWnd, $bHide = True)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not IsBool($bHide) Then Return SetError(102, 0, False)

	_SendMessage($hWnd, $EM_HIDESELECTION, $bHide, 0)
	_WinAPI_SetFocus($hWnd) ; need to have the selection updated
EndFunc   ;==>_GUICtrlRichEdit_HideSelection

; #FUNCTION# ====================================================================================================================
; Authors........: Gary Frost (gafrost (custompcs@charter.net)
; Modified ......: Prog@ndy, Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_InsertText($hWnd, $sText)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If $sText = "" Then Return SetError(102, 0, False)

	Local $tSetText = DllStructCreate($tagSETTEXTEX)
	DllStructSetData($tSetText, 1, $ST_SELECTION)
	_GUICtrlRichEdit_Deselect($hWnd)
	Local $iRet
	If StringLeft($sText, 5) <> "{\rtf" And StringLeft($sText, 5) <> "{urtf" Then
		DllStructSetData($tSetText, 2, $CP_UNICODE)
		$iRet = _SendMessage($hWnd, $EM_SETTEXTEX, $tSetText, $sText, 0, "struct*", "wstr")
	Else
		DllStructSetData($tSetText, 2, $CP_ACP)
		$iRet = _SendMessage($hWnd, $EM_SETTEXTEX, $tSetText, $sText, 0, "struct*", "STR")
	EndIf
	If Not $iRet Then Return SetError(103, 0, False) ; cannot be set
	Return True
EndFunc   ;==>_GUICtrlRichEdit_InsertText

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_IsModified($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Return _SendMessage($hWnd, $EM_GETMODIFY) <> 0
EndFunc   ;==>_GUICtrlRichEdit_IsModified

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_IsTextSelected($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Local $tCharRange = DllStructCreate($tagCHARRANGE)
	_SendMessage($hWnd, $EM_EXGETSEL, 0, $tCharRange, 0, "wparam", "struct*")
	Return DllStructGetData($tCharRange, 2) <> DllStructGetData($tCharRange, 1)
EndFunc   ;==>_GUICtrlRichEdit_IsTextSelected

; #FUNCTION# ====================================================================================================================
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_Paste($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	_SendMessage($hWnd, $__RICHEDITCONSTANT_WM_PASTE, 0, 0)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_Paste

; #FUNCTION# ====================================================================================================================
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_PasteSpecial($hWnd, $bAndObjects = True)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Local $iN = ($bAndObjects ? $__g_sGRE_CF_RETEXTOBJ : $__g_sGRE_CF_RTF)
	_SendMessage($hWnd, $EM_PASTESPECIAL, $iN, 0)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_PasteSpecial

; #FUNCTION# ====================================================================================================================
; Authors........: unknown
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_PauseRedraw($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	_SendMessage($hWnd, $__RICHEDITCONSTANT_WM_SETREDRAW, False)
EndFunc   ;==>_GUICtrlRichEdit_PauseRedraw

; #FUNCTION# ====================================================================================================================
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_Redo($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Return _SendMessage($hWnd, $EM_REDO, 0, 0) <> 0
EndFunc   ;==>_GUICtrlRichEdit_Redo

; #FUNCTION# ====================================================================================================================
; Authors........: Gary Frost (gafrost)
; Modified ......: Chris Haslam (c.haslam), jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_ReplaceText($hWnd, $sText, $bCanUndo = True)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not IsBool($bCanUndo) Then Return SetError(103, 0, False)
	If Not _GUICtrlRichEdit_IsTextSelected($hWnd) Then Return SetError(-1, 0, False)

	Local $tText = DllStructCreate("wchar Text[" & StringLen($sText) + 1 & "]")
	DllStructSetData($tText, "Text", $sText)
	If _WinAPI_InProcess($hWnd, $__g_hRELastWnd) Then
		_SendMessage($hWnd, $EM_REPLACESEL, $bCanUndo, $tText, 0, "wparam", "struct*")
	Else
		Local $iText = DllStructGetSize($tText)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iText, $tMemMap)
		_MemWrite($tMemMap, $tText)
		_SendMessage($hWnd, $EM_REPLACESEL, $bCanUndo, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	EndIf
	Return True
EndFunc   ;==>_GUICtrlRichEdit_ReplaceText

; #FUNCTION# ====================================================================================================================
; Authors........: unknown
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_ResumeRedraw($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	_SendMessage($hWnd, $__RICHEDITCONSTANT_WM_SETREDRAW, True)
	Return _WinAPI_InvalidateRect($hWnd)
EndFunc   ;==>_GUICtrlRichEdit_ResumeRedraw

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_ScrollLineOrPage($hWnd, $sAction)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, 0)
	If StringLen($sAction) <> 2 Then Return SetError(1021, 0, 0)

	Local $sCh = StringLeft($sAction, 1)
	If Not ($sCh = "l" Or $sCh = "p") Then Return SetError(1022, 0, 0)
	$sCh = StringRight($sAction, 1)
	If Not ($sCh = "d" Or $sCh = "u") Then Return SetError(1023, 0, 0)

	Local $wParam = 0
	Switch $sAction
		Case "ld"
			$wParam = $__RICHEDITCONSTANT_SB_LINEDOWN
		Case "lu"
			$wParam = $__RICHEDITCONSTANT_SB_LINEUP
		Case "pd"
			$wParam = $__RICHEDITCONSTANT_SB_PAGEDOWN
		Case "pu"
			$wParam = $__RICHEDITCONSTANT_SB_PAGEUP
	EndSwitch
	Local $iRet = _SendMessage($hWnd, $EM_SCROLL, $wParam, 0)
	$iRet = BitAND($iRet, 0xFFFF) ; low word
	If BitAND($iRet, 0x8000) <> 0 Then $iRet = BitOR($iRet, 0xFFFF0000) ; extend sign bit
	Return $iRet
EndFunc   ;==>_GUICtrlRichEdit_ScrollLineOrPage

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_ScrollLines($hWnd, $iQlines)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not __GCR_IsNumeric($iQlines) Then SetError(102, 0, False)

	Local $iRet = _SendMessage($hWnd, $EM_LINESCROLL, 0, $iQlines)
	If $iRet = 0 Then Return SetError(700, 0, False)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_ScrollLines

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_ScrollToCaret($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	_SendMessage($hWnd, $EM_SCROLLCARET, 0, 0)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_ScrollToCaret

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......: jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetCharAttributes($hWnd, $sStatesAndEffects, $bWord = False)
	Local Const $aV[17][3] = [ _
			["bo", $CFM_BOLD, $CFE_BOLD], ["di", $CFM_DISABLED, $CFE_DISABLED], _
			["em", $CFM_EMBOSS, $CFE_EMBOSS], ["hi", $CFM_HIDDEN, $CFE_HIDDEN], _
			["im", $CFM_IMPRINT, $CFE_IMPRINT], ["it", $CFM_ITALIC, $CFE_ITALIC], _
			["li", $CFM_LINK, $CFE_LINK], ["ou", $CFM_OUTLINE, $CFE_OUTLINE], _
			["pr", $CFM_PROTECTED, $CFE_PROTECTED], ["re", $CFM_REVISED, $CFE_REVISED], _
			["sh", $CFM_SHADOW, $CFE_SHADOW], ["sm", $CFM_SMALLCAPS, $CFE_SMALLCAPS], _
			["st", $CFM_STRIKEOUT, $CFE_STRIKEOUT], ["sb", $CFM_SUBSCRIPT, $CFE_SUBSCRIPT], _
			["sp", $CFM_SUPERSCRIPT, $CFE_SUPERSCRIPT], ["un", $CFM_UNDERLINE, $CFE_UNDERLINE], _
			["al", $CFM_ALLCAPS, $CFE_ALLCAPS]]

	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not IsBool($bWord) Then Return SetError(103, 0, False)

	Local $iMask = 0, $iEffects = 0, $n, $s
	For $i = 1 To StringLen($sStatesAndEffects) Step 3
		$s = StringMid($sStatesAndEffects, $i + 1, 2)
		$n = -1
		For $j = 0 To UBound($aV) - 1
			If $aV[$j][0] = $s Then
				$n = $j
				ExitLoop
			EndIf
		Next
		If $n = -1 Then Return SetError(1023, $s, False) ; not found
		$iMask = BitOR($iMask, $aV[$n][1])
		$s = StringMid($sStatesAndEffects, $i, 1)
		Switch $s
			Case "+"
				$iEffects = BitOR($iEffects, $aV[$n][2])
			Case "-"
				; do nothing
			Case Else
				Return SetError(1022, $s, False)
		EndSwitch
	Next
	Local $tCharFormat = DllStructCreate($tagCHARFORMAT)
	DllStructSetData($tCharFormat, 1, DllStructGetSize($tCharFormat))
	DllStructSetData($tCharFormat, 2, $iMask)
	DllStructSetData($tCharFormat, 3, $iEffects)
	Local $wParam = ($bWord ? BitOR($SCF_WORD, $SCF_SELECTION) : $SCF_SELECTION)
	Local $iRet = _SendMessage($hWnd, $EM_SETCHARFORMAT, $wParam, $tCharFormat, 0, "wparam", "struct*")
	If Not $iRet Then Return SetError(700, 0, False)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetCharAttributes

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......: jpm, guinness, mLipok
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetCharBkColor($hWnd, $iBkColor = Default)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Local $tCharFormat = DllStructCreate($tagCHARFORMAT2)
	DllStructSetData($tCharFormat, 1, DllStructGetSize($tCharFormat))
	If $iBkColor = Default Then
		DllStructSetData($tCharFormat, 3, $CFE_AUTOBACKCOLOR)
		$iBkColor = 0
	Else
		If BitAND($iBkColor, 0xff000000) Then Return SetError(1022, 0, False)
	EndIf

	DllStructSetData($tCharFormat, 2, $CFM_BACKCOLOR)
	DllStructSetData($tCharFormat, 12, $iBkColor)
	Return _SendMessage($hWnd, $EM_SETCHARFORMAT, $SCF_SELECTION, $tCharFormat, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlRichEdit_SetCharBkColor

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......: Jpm, guinness
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetCharColor($hWnd, $iColor = Default)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Local $tCharFormat = DllStructCreate($tagCHARFORMAT)
	DllStructSetData($tCharFormat, 1, DllStructGetSize($tCharFormat))
	If $iColor = Default Then
		DllStructSetData($tCharFormat, 3, $CFE_AUTOCOLOR)
		$iColor = 0
	Else
		If BitAND($iColor, 0xff000000) Then Return SetError(1022, 0, False)
	EndIf

	DllStructSetData($tCharFormat, 2, $CFM_COLOR)
	DllStructSetData($tCharFormat, 6, $iColor)
	Return _SendMessage($hWnd, $EM_SETCHARFORMAT, $SCF_SELECTION, $tCharFormat, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlRichEdit_SetCharColor

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......: Jpm, guinness
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetBkColor($hWnd, $iBngColor = Default)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Local $bSysColor = False
	If $iBngColor = Default Then
		$bSysColor = True
		$iBngColor = 0
	Else
		If BitAND($iBngColor, 0xff000000) Then Return SetError(1022, 0, False)
	EndIf

	_SendMessage($hWnd, $EM_SETBKGNDCOLOR, $bSysColor, $iBngColor)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetBkColor

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetLimitOnText($hWnd, $iNewLimit)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not __GCR_IsNumeric($iNewLimit, ">=0") Then Return SetError(102, 0, False)

	If $iNewLimit < 65535 Then $iNewLimit = 0 ; default max is 64K
	_SendMessage($hWnd, $EM_EXLIMITTEXT, 0, $iNewLimit)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetLimitOnText

; #FUNCTION# ====================================================================================================================
; Author ........: KIP
; Modified.......: Chris Haslam (c.haslam), guinness
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetTabStops($hWnd, $vTabStops, $bRedraw = True)
	; Should take tabstops in space units (like EM_SETPARAFORMAT PFM_TABSTOPS, but how to convert inches, etc.
	; to dialog units? For now, a kludge based on experimentation
	Local Const $iTwipsPerDU = 18.75
	Local $tTabStops, $tagTabStops = "", $wParam

	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not IsBool($bRedraw) Then Return SetError(103, 0, False)

	If IsString($vTabStops) Then ; Set every tabstop manually
		If $vTabStops = "" Then Return SetError(1023, 0, False)
		Local $aS = StringSplit($vTabStops, ";")
		Local $iNumTabStops = $aS[0]
		For $i = 1 To $iNumTabStops
			If Not __GCR_IsNumeric($aS[$i], ">0") Then Return SetError(1022, 0, False)
			$tagTabStops &= "int;"
		Next
		$tagTabStops = StringTrimRight($tagTabStops, 1)
		$tTabStops = DllStructCreate($tagTabStops)
		For $i = 1 To $iNumTabStops
			DllStructSetData($tTabStops, $i, $aS[$i] * $__g_iRTFTwipsPeSpaceUnit / $iTwipsPerDU)
		Next
		$wParam = $iNumTabStops
	ElseIf IsNumber($vTabStops) Then
		If __GCR_IsNumeric($vTabStops, ">0") Then
			$tTabStops = DllStructCreate("int")
			DllStructSetData($tTabStops, 1, $vTabStops * $__g_iRTFTwipsPeSpaceUnit / $iTwipsPerDU)
			$wParam = 1
		Else
			Return SetError(1024, 9, False)
		EndIf
	Else
		Return SetError(1021, 0, False)
	EndIf
	Local $bResult = _SendMessage($hWnd, $EM_SETTABSTOPS, $wParam, $tTabStops, 0, "wparam", "struct*") <> 0
	If $bRedraw Then _WinAPI_InvalidateRect($hWnd) ; redraw the control
	Return $bResult
EndFunc   ;==>_GUICtrlRichEdit_SetTabStops

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetZoom($hWnd, $iPercent)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not __GCR_IsNumeric($iPercent, ">0") Then Return SetError(1021, 0, False)

	Local $iNumerator, $iDenominator
	Select
		Case Not ($iPercent = 100 Or ($iPercent >= 200 And $iPercent < 6400))
			Return SetError(1022, 0, False)
		Case $iPercent >= 100
			$iNumerator = 10000
			$iDenominator = 10000 / ($iPercent / 100)
		Case Else
			$iNumerator = 10000 * ($iPercent / 100)
			$iDenominator = 10000
	EndSelect
	Return _SendMessage($hWnd, $EM_SETZOOM, $iNumerator, $iDenominator) <> 0
EndFunc   ;==>_GUICtrlRichEdit_SetZoom

; #FUNCTION# ====================================================================================================================
; Authors........: Yoan Roblet (Arcker)
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetEventMask($hWnd, $iEventMask)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not __GCR_IsNumeric($iEventMask) Then Return SetError(102, 0, False)

	_SendMessage($hWnd, $EM_SETEVENTMASK, 0, $iEventMask)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetEventMask

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetFont($hWnd, $iPoints = Default, $sName = Default, $iCharset = Default, $iLcid = Default)
	; MSDN does not give a mask (CFM) for bPitchAndFamily so it appears that it cannot be set => omitted here
	Local $iDwMask = 0

	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not ($iPoints = Default Or __GCR_IsNumeric($iPoints, ">0")) Then Return SetError(102, 0, False)
	If $sName <> Default Then
		Local $aS = StringSplit($sName, " ")
		For $i = 1 To UBound($aS) - 1
			If Not StringIsAlpha($aS[$i]) Then Return SetError(103, 0, False)
		Next
	EndIf
	If Not ($iCharset = Default Or __GCR_IsNumeric($iCharset)) Then Return SetError(104, 0, False)
	If Not ($iLcid = Default Or __GCR_IsNumeric($iLcid)) Then Return SetError(105, 0, False)

	Local $tCharFormat = DllStructCreate($tagCHARFORMAT2)
	DllStructSetData($tCharFormat, 1, DllStructGetSize($tCharFormat))

	If $iPoints <> Default Then
		$iDwMask = $CFM_SIZE
		DllStructSetData($tCharFormat, 4, Int($iPoints * 20))
	EndIf
	If $sName <> Default Then
		If StringLen($sName) > $LF_FACESIZE - 1 Then SetError(-1, 0, False)
		$iDwMask = BitOR($iDwMask, $CFM_FACE)
		DllStructSetData($tCharFormat, 9, $sName)
	EndIf
	If $iCharset <> Default Then
		$iDwMask = BitOR($iDwMask, $CFM_CHARSET)
		DllStructSetData($tCharFormat, 7, $iCharset)
	EndIf
	If $iLcid <> Default Then
		$iDwMask = BitOR($iDwMask, $CFM_LCID)
		DllStructSetData($tCharFormat, 13, $iLcid)
	EndIf
	DllStructSetData($tCharFormat, 2, $iDwMask)

	Local $iRet = _SendMessage($hWnd, $EM_SETCHARFORMAT, $SCF_SELECTION, $tCharFormat, 0, "wparam", "struct*")
	If Not $iRet Then Return SetError(@error + 200, 0, False)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetFont

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......: jpm, guinness
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetRECT($hWnd, $iLeft = Default, $iTop = Default, $iRight = Default, $iBottom = Default, $bRedraw = True)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not ($iLeft = Default Or __GCR_IsNumeric($iLeft, ">0")) Then Return SetError(1021, 0, False)
	If Not ($iTop = Default Or __GCR_IsNumeric($iTop, ">0")) Then Return SetError(1022, 0, False)
	If Not ($iRight = Default Or __GCR_IsNumeric($iRight, ">0")) Then Return SetError(1023, 0, False)
	If Not ($iBottom = Default Or __GCR_IsNumeric($iBottom, ">0")) Then Return SetError(1024, 0, False)

	If @NumParams = 1 Then
		Local $aPos = ControlGetPos($hWnd, "", "")
		$iLeft = 2
		$iTop = 2
		$iRight = $aPos[2]
		$iBottom = $aPos[3]
		_GUICtrlRichEdit_SetRECT($hWnd, $iLeft, $iTop, $iRight, $iBottom)
		Return True
	Else
		Local $aS = _GUICtrlRichEdit_GetRECT($hWnd)
		If $iLeft = Default Then
			$iLeft = $aS[0]
		EndIf
		If $iTop = Default Then
			$iTop = $aS[1]
		EndIf
		If $iRight = Default Then
			$iRight = $aS[2]
		EndIf
		If $iBottom = Default Then
			$iBottom = $aS[3]
		EndIf
		If $iLeft >= $iRight Then Return SetError(1025, 0, False)
		If $iTop >= $iBottom Then Return SetError(1026, 0, False)
		Local $tRECT = DllStructCreate($tagRECT)
		DllStructSetData($tRECT, "Left", Number($iLeft))
		DllStructSetData($tRECT, "Top", Number($iTop))
		DllStructSetData($tRECT, "Right", Number($iRight))
		DllStructSetData($tRECT, "Bottom", Number($iBottom))
		Local $iMsg = ($bRedraw ? $EM_SETRECT : $EM_SETRECTNP)
		_SendMessage($hWnd, $iMsg, 0, $tRECT, 0, "wparam", "struct*")
	EndIf
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetRECT

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetModified($hWnd, $bState = True)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not IsBool($bState) Then Return SetError(102, 0, False)

	_SendMessage($hWnd, $EM_SETMODIFY, $bState)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetModified

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......: guinness
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetParaAlignment($hWnd, $sAlignment)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Local $iAlignment
	Switch $sAlignment
		Case "l"
			$iAlignment = $PFA_LEFT
		Case "c"
			$iAlignment = $PFA_CENTER
		Case "r"
			$iAlignment = $PFA_RIGHT
		Case "j"
			$iAlignment = $PFA_JUSTIFY
		Case "w"
			$iAlignment = $PFA_FULL_INTERWORD
		Case Else
			Return SetError(102, 0, False)
	EndSwitch
	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, 1, DllStructGetSize($tParaFormat))
	DllStructSetData($tParaFormat, 2, $PFM_ALIGNMENT)
	DllStructSetData($tParaFormat, 8, $iAlignment)
	Return _SendMessage($hWnd, $EM_SETPARAFORMAT, 0, $tParaFormat, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlRichEdit_SetParaAlignment

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetParaAttributes($hWnd, $sStatesAndAtts)
	Local Enum $eAbbrev = 0, $eMask, $eEffect, $eInverted
	; MS seems to mean LINENUMBER and WIDOWCONTROL, not NOLINENUMBER and NOWIDOWCONTROL
	Local Const $aV[9][4] = [ _	; abbrev, mask, effect, inverted
			["fpg", $PFM_PAGEBREAKBEFORE, $PFE_PAGEBREAKBEFORE, False], _
			["hyp", $PFM_DONOTHYPHEN, $PFE_DONOTHYPHEN, True], _
			["kpt", $PFM_KEEP, $PFE_KEEP, False], _
			["kpn", $PFM_KEEPNEXT, $PFE_KEEPNEXT, False], _
			["pwo", $PFM_NOWIDOWCONTROL, $PFE_NOWIDOWCONTROL, False], _
			["r2l", $PFM_RTLPARA, $PFE_RTLPARA, False], _
			["row", $PFM_TABLE, $PFE_TABLE, False], _
			["sbs", $PFM_SIDEBYSIDE, $PFE_SIDEBYSIDE, False], _
			["sln", $PFM_NOLINENUMBER, $PFE_NOLINENUMBER, False]]

	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	If Mod(StringLen($sStatesAndAtts) + 1, 5) <> 0 Then Return SetError(1023, 0, False)
	Local $aS = StringSplit($sStatesAndAtts, ";")
	Local $iMask = 0, $iEffects = 0, $s, $n
	For $i = 1 To UBound($aS, $UBOUND_ROWS) - 1
		$s = StringMid($aS[$i], 2)
		$n = -1
		For $j = 0 To UBound($aV, $UBOUND_ROWS) - 1
			If $aV[$j][$eAbbrev] = $s Then
				$n = $j
				ExitLoop
			EndIf
		Next
		If $n = -1 Then Return SetError(1022, $s, False)
		$iMask = BitOR($iMask, $aV[$n][$eMask])
		$s = StringLeft($aS[$i], 1)
		Switch $s
			Case "+"
				If Not $aV[$n][$eInverted] Then ; if normal sense
					$iEffects = BitOR($iEffects, $aV[$n][$eEffect])
				EndIf
			Case "-"
				If $aV[$n][$eInverted] Then ; if inverted sense
					$iEffects = BitOR($iEffects, $aV[$n][$eEffect])
				EndIf
			Case Else
				Return SetError(1021, $s, False)
		EndSwitch
	Next
	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, 1, DllStructGetSize($tParaFormat))
	DllStructSetData($tParaFormat, 2, $iMask)
	DllStructSetData($tParaFormat, 4, $iEffects)
	Return _SendMessage($hWnd, $EM_SETPARAFORMAT, 0, $tParaFormat, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlRichEdit_SetParaAttributes

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetParaBorder($hWnd, $sLocation = Default, $vLineStyle = Default, $sColor = Default, $iSpace = Default)
	; wBorderWidth doesn't appear to work
	Local $iBorders
	;	Local $tOldParaFormat,$iOldLoc, $iOldSpace, $iOldLineStyle, $iOldColor, $iN
	Local Const $avLocs[6][2] = [["l", 1], ["r", 2], ["t", 4], ["b", 8], ["i", 16], ["o", 32]]
	Local Const $avLS[12] = ["none", .75, 1.5, 2.25, 3, 4.5, 6, ".75d", "1.5d", "2.25d", ".75g", ".75gd"]
	Local Const $sClrs = ";blk;blu;cyn;grn;mag;red;yel;whi;dbl;dgn;dmg;drd;dyl;dgy;lgy;aut;"

	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not ($iSpace = Default Or __GCR_IsNumeric($iSpace, ">=0")) Then Return SetError(105, 0, False)
	;	If Not ($iWidth = Default Or __GCR_IsNumeric($iWidth, ">=0")) Then  Return SetError(106, 0, False)	; wBorderWidth does not round-trip

	If $sLocation = "" Then
		$iBorders = 0
		$iSpace = 0
		;		$iWidth = 0
	Else
		If $sLocation = Default Or $vLineStyle = Default Or $sColor = Default Or $iSpace = Default Then
			Local $aS = StringSplit(_GUICtrlRichEdit_GetParaBorder($hWnd), ";")
			If $sLocation = Default Then $sLocation = $aS[1]
			If $vLineStyle = Default Then $vLineStyle = $aS[2]
			If $sColor = Default Then $sColor = $aS[3]
			If $iSpace = Default Then $iSpace = $aS[4]
		EndIf
		Local $iLoc = 0, $n, $s
		For $i = 1 To StringLen($sLocation)
			$s = StringMid($sLocation, $i, 1)
			$n = -1
			For $j = 0 To UBound($avLocs, $UBOUND_ROWS) - 1
				If $avLocs[$j][0] = $s Then
					$n = $j
					ExitLoop
				EndIf
			Next
			If $n = -1 Then Return SetError(102, $s, False)
			$iLoc = BitOR($iLoc, $avLocs[$n][1])
		Next
		$n = -1
		For $i = 0 To UBound($avLS, $UBOUND_ROWS) - 1
			If $vLineStyle = $avLS[$i] Then
				$n = $i
				ExitLoop
			EndIf
		Next
		If $n = -1 Then Return SetError(103, 0, False)
		Local $iLineStyle = $n
		$n = StringInStr($sClrs, ";" & $sColor & ";")
		If $n = 0 Then Return SetError(104, 0, False)
		Local $iColor = Int($n / 4)
		If $iColor = 16 Then ; if autocolor
			$iLoc = BitOR($iLoc, 64)
			$iColor = 0
		EndIf
		$iBorders = $iLoc + BitShift($iLineStyle, -8) + BitShift($iColor, -12)
		;		If $iWidth = Default Then $iWidth = $iOldWidth
	EndIf
	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, "cbSize", DllStructGetSize($tParaFormat))
	DllStructSetData($tParaFormat, "wBorderSpace", $iSpace * $__g_iRTFTwipsPeSpaceUnit)
	;	DllStructGetData($tParaFormat, 23, $iWidth * $__g_iRTFTwipsPeSpaceUnit)
	DllStructSetData($tParaFormat, "wBorders", $iBorders)
	DllStructSetData($tParaFormat, "dwMask", $PFM_BORDER)
	Return _SendMessage($hWnd, $EM_SETPARAFORMAT, 0, $tParaFormat, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlRichEdit_SetParaBorder

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetParaIndents($hWnd, $vLeft = Default, $iRight = Default, $iFirstLine = Default)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not ($vLeft = Default Or __GCR_IsNumeric($vLeft)) Then Return SetError(1021, 0, False)
	If Not ($iRight = Default Or __GCR_IsNumeric($iRight, ">=0")) Then Return SetError(103, 0, False)
	If Not ($iFirstLine = Default Or __GCR_IsNumeric($iFirstLine)) Then Return SetError(104, 0, False)

	Local $s = _GUICtrlRichEdit_GetParaIndents($hWnd)
	Local $aS = StringSplit($s, ";")
	If $vLeft = Default Then $vLeft = $aS[1]
	If $iRight = Default Then $iRight = $aS[2]
	If $iFirstLine = Default Then $iFirstLine = $aS[3]
	If $vLeft < 0 Then Return SetError(1022, 0, False)
	If $vLeft + $iFirstLine < 0 Then Return SetError(200, 0, False)

	If StringInStr("+-", StringLeft($vLeft, 1)) <> 0 Then $vLeft = $aS[1] + $vLeft

	Local $iIdxSI = $vLeft + $iFirstLine
	Local $iIdxOfs = -$iFirstLine

	Local $tParaFormat = DllStructCreate($tagPARAFORMAT)
	DllStructSetData($tParaFormat, 1, DllStructGetSize($tParaFormat))
	DllStructSetData($tParaFormat, "dxStartIndent", $iIdxSI * $__g_iRTFTwipsPeSpaceUnit)
	DllStructSetData($tParaFormat, "dxOffset", $iIdxOfs * $__g_iRTFTwipsPeSpaceUnit)
	DllStructSetData($tParaFormat, "dxRightIndent", $iRight * $__g_iRTFTwipsPeSpaceUnit)
	DllStructSetData($tParaFormat, 2, BitOR($PFM_STARTINDENT, $PFM_OFFSET, $PFM_RIGHTINDENT)) ; absolute
	Local $iRet = _SendMessage($hWnd, $EM_SETPARAFORMAT, 0, $tParaFormat, 0, "wparam", "struct*")
	If Not $iRet Then Return SetError(700, 0, False)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetParaIndents

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetParaNumbering($hWnd, $sStyle, $iTextToNbrSpace = Default, $bForceRoman = False)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not ($iTextToNbrSpace = Default Or __GCR_IsNumeric($iTextToNbrSpace, ">0")) Then Return SetError(103, 0, False)
	If Not IsBool($bForceRoman) Then Return SetError(104, 0, False)

	Local $iPFM, $iWNumbering, $iWnumStart, $iWnumStyle, $iQspaces
	__GCR_ParseParaNumberingStyle($sStyle, $bForceRoman, $iPFM, $iWNumbering, $iWnumStart, $iWnumStyle, $iQspaces)
	If @error Then Return SetError(@error, 0, False)

	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, 1, DllStructGetSize($tParaFormat))
	If BitAND($iPFM, $PFM_NUMBERING) Then DllStructSetData($tParaFormat, 3, $iWNumbering)
	If BitAND($iPFM, $PFM_NUMBERINGSTART) Then DllStructSetData($tParaFormat, 19, $iWnumStart)
	If BitAND($iPFM, $PFM_NUMBERINGSTYLE) Then DllStructSetData($tParaFormat, 20, $iWnumStyle)
	If BitAND($iPFM, $PFM_NUMBERINGTAB) Then
		Local $iTwips
		If $iTextToNbrSpace = Default Then
			; set number-to-text spacing based on font at anchor or onsertion point
			Local $aV = _GUICtrlRichEdit_GetFont($hWnd)
			Local $iPoints = $aV[0]
			$iTwips = $iQspaces * $iPoints * 20
		Else
			$iTwips = $iTextToNbrSpace * $__g_iRTFTwipsPeSpaceUnit
		EndIf
		DllStructSetData($tParaFormat, 21, $iTwips)
	EndIf
	DllStructSetData($tParaFormat, 2, $iPFM)
	Return _SendMessage($hWnd, $EM_SETPARAFORMAT, 0, $tParaFormat, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlRichEdit_SetParaNumbering

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetParaShading($hWnd, $iWeight = Default, $sStyle = Default, $sForeColor = Default, $sBackColor = Default)
	Local $iS = 0 ; perhaps a BUG (jpm) only referenced
	Local Const $sStyles = ";non;dhz;dvt;ddd;dud;dgr;dtr;lhz;lrt;ldd;lud;lgr;ltr;"
	Local Const $sClrs = ";blk;blu;cyn;grn;mag;red;yel;whi;dbl;dgn;dmg;drd;dyl;dgy;lgy;"

	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not ($iWeight = Default Or __GCR_IsNumeric($iWeight, ">=0")) Then Return SetError(1021, 0, False)

	If $iWeight <> Default Or $sStyle <> Default Or $sForeColor <> Default Or $sBackColor <> Default Then
		Local $aS = StringSplit(_GUICtrlRichEdit_GetParaShading($hWnd), ";")
		If $iWeight = Default Then $iWeight = $aS[1]
		If $sStyle = Default Then $sStyle = $aS[2]
		If $sForeColor = Default Then $sForeColor = $aS[3]
		If $sBackColor = Default Then $sBackColor = $aS[4]
		#cs
			$tOldParaFormat = DllStructCreate($tagPARAFORMAT2)
			DllStructSetData($tOldParaFormat, 1, DllStructGetSize($tOldParaFormat))
			_SendMessage($hWnd, $EM_GETPARAFORMAT, 0, DllStructGetPtr($tOldParaFormat))
		#ce
	EndIf
	;	If $iWeight = Default Then
	;		$iWeight = DllStructGetData($tOldParaFormat, 17)
	;	Else
	If $iWeight < 0 Or $iWeight > 100 Then Return SetError(1022, 0, False)
	;	EndIf
	;	If $sStyle = Default Or $sForeColor = Default Or $sBackColor = Default Then
	;		$iS = DllStructGetData($tOldParaFormat, 18)
	;	EndIf
	;	If $sStyle = Default Then
	;		$iStyle = BitAND($iS, 0xF)
	;	Else
	Local $iN = StringInStr($sStyles, ";" & $sStyle & ";")
	If $iN = 0 Then Return SetError(103, 0, False)
	Local $iStyle = Int($iN / 4)
	;	EndIf
	;	If $sForeColor = Default Then
	Local $iFore = BitShift(BitAND($iS, 0xF0), 4)
	;	Else
	$iN = StringInStr($sClrs, ";" & $sForeColor & ";")
	If $iN = 0 Then Return SetError(104, 0, False)
	$iFore = Int($iN / 4)
	;	EndIf
	;	If $sBackColor = Default Then
	;		$iBack = BitShift(BitAND($iS, 0xF00), 8)
	;	Else
	$iN = StringInStr($sClrs, ";" & $sBackColor & ";")
	If $iN = 0 Then Return SetError(105, 0, False)
	Local $iBack = Int($iN / 4)
	;	EndIf
	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, "cbSize", DllStructGetSize($tParaFormat))
	DllStructSetData($tParaFormat, "wShadingWeight", $iWeight)
	$iN = $iStyle + BitShift($iFore, -4) + BitShift($iBack, -8)
	DllStructSetData($tParaFormat, "wShadingStyle", $iN)
	DllStructSetData($tParaFormat, "dwMask", $PFM_SHADING)
	Local $iRet = _SendMessage($hWnd, $EM_SETPARAFORMAT, 0, $tParaFormat, 0, "wparam", "struct*")
	If Not $iRet Then Return SetError(700, 0, False)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetParaShading

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetParaSpacing($hWnd, $vInter = Default, $iBefore = Default, $iAfter = Default)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not ($iBefore = Default Or __GCR_IsNumeric($iBefore, ">=0")) Then Return SetError(103, 0, False)
	If Not ($iAfter = Default Or __GCR_IsNumeric($iAfter, ">=0")) Then Return SetError(104, 0, False)

	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, "cbSize", DllStructGetSize($tParaFormat))
	Local $iMask = 0
	If $vInter <> Default Then
		$vInter = StringStripWS($vInter, $STR_STRIPALL) ; strip all spaces
		Local $iP = StringInStr($vInter, "line", 2) ; case-insensitive, faster
		If $iP <> 0 Then
			$vInter = StringLeft($vInter, $iP - 1)
		EndIf
		If Not __GCR_IsNumeric($vInter, ">=0") Then Return SetError(1021, 0, False)
		Local $iRule, $iLnSp = 0
		If $iP <> 0 Then ; if in lines
			Switch $vInter
				Case 1
					$iRule = 0
				Case 1.5
					$iRule = 1
				Case 2
					$iRule = 2
				Case Else
					If $vInter < 1 Then Return SetError(1022, 0, False)
					$iRule = 5 ; spacing in lines
					$iLnSp = $vInter * 20
			EndSwitch
		Else
			$iRule = 4 ; spacing in twips
			$iLnSp = $vInter * $__g_iRTFTwipsPeSpaceUnit
		EndIf
		$iMask = $PFM_LINESPACING
		DllStructSetData($tParaFormat, "bLineSpacingRule", $iRule)
		If $iLnSp <> 0 Then DllStructSetData($tParaFormat, 13, $iLnSp)
	EndIf
	If $iBefore <> Default Then
		$iMask = BitOR($iMask, $PFM_SPACEBEFORE)
		DllStructSetData($tParaFormat, "dySpaceBefore", $iBefore * $__g_iRTFTwipsPeSpaceUnit)
	EndIf
	If $iAfter <> Default Then
		$iMask = BitOR($iMask, $PFM_SPACEAFTER)
		DllStructSetData($tParaFormat, "dySpaceAfter", $iAfter * $__g_iRTFTwipsPeSpaceUnit)
	EndIf
	If $iMask <> 0 Then
		DllStructSetData($tParaFormat, "dwMask", $iMask)
		Return _SendMessage($hWnd, $EM_SETPARAFORMAT, 0, $tParaFormat, 0, "wparam", "struct*") <> 0
	Else
		Return True
	EndIf
EndFunc   ;==>_GUICtrlRichEdit_SetParaSpacing

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetParaTabStops($hWnd, $sTabStops)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Local $tParaFormat = DllStructCreate($tagPARAFORMAT2)
	DllStructSetData($tParaFormat, "cbSize", DllStructGetSize($tParaFormat))

	If $sTabStops = "" Then
		DllStructSetData($tParaFormat, "cTabCount", 0)
	Else
		Local $asTabs = StringSplit($sTabStops, ";")
		If $asTabs[0] > $MAX_TAB_STOPS Then Return SetError(1021, 0, False)
		Local $asAtab, $i, $s, $iN, $iP
		For $iTab = 1 To $asTabs[0]
			$asAtab = StringSplit($asTabs[$iTab], "") ; split into characters
			$i = 1
			While $i <= $asAtab[0] And StringInStr("01234567890.", $asAtab[$i]) <> 0
				$i += 1
			WEnd
			If $i = 1 Then Return SetError(1021, $iTab, False)
			$s = StringLeft($asTabs[$iTab], $i - 1)
			If Not __GCR_IsNumeric($s, ">=0") Then Return SetError(1021, $iTab, False)
			$iN = $s * $__g_iRTFTwipsPeSpaceUnit
			If $i <= $asAtab[0] Then
				$iP = StringInStr("lcrdb", $asAtab[$i])
				If $iP = 0 Then Return SetError(1022, $iTab, False)
				$iN = BitOR($iN, BitShift($iP - 1, -24))
			EndIf
			$i += 1
			If $i <= $asAtab[0] Then
				$iP = StringInStr(" .-_t=", $asAtab[$i])
				If $iP = 0 Then Return SetError(1023, $iTab, False)
				$iN = BitOR($iN, BitShift($iP - 1, -28))
			EndIf
			DllStructSetData($tParaFormat, "rgxTabs", $iN, $iTab)
		Next
		DllStructSetData($tParaFormat, "cTabCount", $asTabs[0])
	EndIf
	DllStructSetData($tParaFormat, "dwMask", $PFM_TABSTOPS)
	Return _SendMessage($hWnd, $EM_SETPARAFORMAT, 0, $tParaFormat, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlRichEdit_SetParaTabStops

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost
; Modified.......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetPasswordChar($hWnd, $sDisplayChar = "*")
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not IsString($sDisplayChar) Then SetError(102, 0, False)

	If $sDisplayChar = "" Then
		_SendMessage($hWnd, $EM_SETPASSWORDCHAR)
	Else
		_SendMessage($hWnd, $EM_SETPASSWORDCHAR, Asc($sDisplayChar))
	EndIf
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetPasswordChar

; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetReadOnly($hWnd, $bState = True)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not IsBool($bState) Then Return SetError(102, 0, False)

	Local $iRet = _SendMessage($hWnd, $EM_SETREADONLY, $bState)
	If $iRet = 0 Then Return SetError(700, 0, False)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetReadOnly

; #FUNCTION# ====================================================================================================================
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetScrollPos($hWnd, $iX, $iY)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not __GCR_IsNumeric($iX, ">=0") Then Return SetError(102, 0, False)
	If Not __GCR_IsNumeric($iY, ">=0") Then Return SetError(103, 0, False)

	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, 1, $iX)
	DllStructSetData($tPoint, 2, $iY)
	Return _SendMessage($hWnd, $EM_SETSCROLLPOS, 0, $tPoint, 0, "wparam", "struct*") <> 0
EndFunc   ;==>_GUICtrlRichEdit_SetScrollPos

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......: jpm
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetSel($hWnd, $iAnchor, $iActive, $bHideSel = False)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not __GCR_IsNumeric($iAnchor, ">=0,-1") Then Return SetError(102, 0, False)
	If Not __GCR_IsNumeric($iActive, ">=0,-1") Then Return SetError(103, 0, False)
	If Not IsBool($bHideSel) Then Return SetError(104, 0, False)
	_SendMessage($hWnd, $EM_SETSEL, $iAnchor, $iActive)
	If $bHideSel Then _SendMessage($hWnd, $EM_HIDESELECTION, $bHideSel)
	_WinAPI_SetFocus($hWnd) ; need to have the selection updated
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetSel

; #FUNCTION# ====================================================================================================================
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetSpaceUnit($sUnit)
	Switch StringLower($sUnit)
		Case "in"
			$__g_iRTFTwipsPeSpaceUnit = 1440
		Case "cm"
			$__g_iRTFTwipsPeSpaceUnit = 567
		Case "mm"
			$__g_iRTFTwipsPeSpaceUnit = 56.7
		Case "pt"
			$__g_iRTFTwipsPeSpaceUnit = 20
		Case "tw"
			$__g_iRTFTwipsPeSpaceUnit = 1
		Case Else
			Return SetError(1, 0, False)
	EndSwitch
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetSpaceUnit

; #FUNCTION# ====================================================================================================================
; Authors........: Gary Frost (gafrost (custompcs@charter.net))
; Modified ......: Prog@ndy, Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetText($hWnd, $sText)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Local $tSetText = DllStructCreate($tagSETTEXTEX)
	;	DllStructSetData($tSetText, 1, $ST_KEEPUNDO)
	DllStructSetData($tSetText, 1, $ST_DEFAULT)
	DllStructSetData($tSetText, 2, $CP_ACP)
	Local $iRet
	If StringLeft($sText, 5) <> "{\rtf" And StringLeft($sText, 5) <> "{urtf" Then
		DllStructSetData($tSetText, 2, $CP_UNICODE)
		$iRet = _SendMessage($hWnd, $EM_SETTEXTEX, $tSetText, $sText, 0, "struct*", "wstr")
	Else
		$iRet = _SendMessage($hWnd, $EM_SETTEXTEX, $tSetText, $sText, 0, "struct*", "STR")
	EndIf
	If Not $iRet Then Return SetError(700, 0, False)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_SetText

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_SetUndoLimit($hWnd, $iLimit)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	If Not __GCR_IsNumeric($iLimit, ">=0") Then Return SetError(102, 0, False)

	Return _SendMessage($hWnd, $EM_SETUNDOLIMIT, $iLimit) <> 0 Or $iLimit = 0
EndFunc   ;==>_GUICtrlRichEdit_SetUndoLimit

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_StreamFromFile($hWnd, $sFileSpec)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Local $tEditStream = DllStructCreate($tagEDITSTREAM)
	DllStructSetData($tEditStream, "pfnCallback", DllCallbackGetPtr($__g_pGRC_StreamFromFileCallback))
	Local $hFile = FileOpen($sFileSpec, $FO_READ)
	If $hFile = -1 Then Return SetError(1021, 0, False)
	Local $sBuf = FileRead($hFile, 5)
	FileClose($hFile)
	$hFile = FileOpen($sFileSpec, $FO_READ) ; reopen it at the start
	DllStructSetData($tEditStream, "dwCookie", $hFile) ; -> Send handle to CallbackFunc
	Local $wParam = ($sBuf == "{\rtf" Or $sBuf == "{urtf") ? $SF_RTF : $SF_TEXT
	$wParam = BitOR($wParam, $SFF_SELECTION)
	If Not _GUICtrlRichEdit_IsTextSelected($hWnd) Then
		_GUICtrlRichEdit_SetText($hWnd, "")
	EndIf
	Local $iQchs = _SendMessage($hWnd, $EM_STREAMIN, $wParam, $tEditStream, 0, "wparam", "struct*")
	FileClose($hFile)
	Local $iError = DllStructGetData($tEditStream, "dwError")
	If $iError <> 1 Then SetError(700, $iError, False)
	If $iQchs = 0 Then
		If FileGetSize($sFileSpec) = 0 Then Return SetError(1022, 0, False)
		Return SetError(700, $iError, False)
	EndIf
	Return True
EndFunc   ;==>_GUICtrlRichEdit_StreamFromFile

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_StreamFromVar($hWnd, $sVar)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Local $tEditStream = DllStructCreate($tagEDITSTREAM)
	DllStructSetData($tEditStream, "pfnCallback", DllCallbackGetPtr($__g_pGRC_StreamFromVarCallback))
	$__g_pGRC_sStreamVar = $sVar
	Local $s = StringLeft($sVar, 5)
	Local $wParam = ($s == "{\rtf" Or $s == "{urtf") ? $SF_RTF : $SF_TEXT
	$wParam = BitOR($wParam, $SFF_SELECTION)
	If Not _GUICtrlRichEdit_IsTextSelected($hWnd) Then
		_GUICtrlRichEdit_SetText($hWnd, "")
	EndIf
	_SendMessage($hWnd, $EM_STREAMIN, $wParam, $tEditStream, 0, "wparam", "struct*")
	Local $iError = DllStructGetData($tEditStream, "dwError")
	If $iError <> 1 Then Return SetError(700, $iError, False)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_StreamFromVar

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_StreamToFile($hWnd, $sFileSpec, $bIncludeCOM = True, $iOpts = 0, $iCodePage = 0)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)

	Local $wParam
	If StringRight($sFileSpec, 4) = ".rtf" Then
		$wParam = ($bIncludeCOM ? $SF_RTF : $SF_RTFNOOBJS)
	Else
		$wParam = ($bIncludeCOM ? $SF_TEXTIZED : $SF_TEXT)
		If BitAND($iOpts, $SFF_PLAINRTF) Then Return SetError(1041, 0, False)
	EndIf
	; only opts are $SFF_PLAINRTF and $SF_UNICODE
	If BitAND($iOpts, BitNOT(BitOR($SFF_PLAINRTF, $SF_UNICODE))) Then Return SetError(1042, 0, False)
	If BitAND($iOpts, $SF_UNICODE) Then
		If Not BitAND($wParam, $SF_TEXT) Then Return SetError(1043, 0, False)
	EndIf

	If _GUICtrlRichEdit_IsTextSelected($hWnd) Then $wParam = BitOR($wParam, $SFF_SELECTION)

	$wParam = BitOR($wParam, $iOpts)
	If $iCodePage <> 0 Then
		$wParam = BitOR($wParam, $SF_USECODEPAGE, BitShift($iCodePage, -16))
	EndIf
	Local $tEditStream = DllStructCreate($tagEDITSTREAM)
	DllStructSetData($tEditStream, "pfnCallback", DllCallbackGetPtr($__g_pGRC_StreamToFileCallback))
	Local $hFile = FileOpen($sFileSpec, $FO_OVERWRITE)
	If $hFile = -1 Then Return SetError(102, 0, False)

	DllStructSetData($tEditStream, "dwCookie", $hFile) ; -> Send handle to CallbackFunc
	_SendMessage($hWnd, $EM_STREAMOUT, $wParam, $tEditStream, 0, "wparam", "struct*")
	FileClose($hFile)
	Local $iError = DllStructGetData($tEditStream, "dwError")
	If $iError <> 0 Then SetError(700, $iError, False)
	Return True
EndFunc   ;==>_GUICtrlRichEdit_StreamToFile

; #FUNCTION# ====================================================================================================================
; Authors........: Chris Haslam (c.haslam)
; Modified ......:
; ===============================================================================================================================
Func _GUICtrlRichEdit_StreamToVar($hWnd, $bRtf = True, $bIncludeCOM = True, $iOpts = 0, $iCodePage = 0)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, "")

	Local $wParam
	If $bRtf Then
		$wParam = ($bIncludeCOM ? $SF_RTF : $SF_RTFNOOBJS)
	Else
		$wParam = ($bIncludeCOM ? $SF_TEXTIZED : $SF_TEXT)
		If BitAND($iOpts, $SFF_PLAINRTF) Then Return SetError(1041, 0, "")
	EndIf
	; only opts are $SFF_PLAINRTF and $SF_UNICODE
	If BitAND($iOpts, BitNOT(BitOR($SFF_PLAINRTF, $SF_UNICODE))) Then Return SetError(1042, 0, "")
	If BitAND($iOpts, $SF_UNICODE) Then
		If Not BitAND($wParam, $SF_TEXT) Then Return SetError(1043, 0, "")
	EndIf
	If _GUICtrlRichEdit_IsTextSelected($hWnd) Then $wParam = BitOR($wParam, $SFF_SELECTION)

	$wParam = BitOR($wParam, $iOpts)
	If $iCodePage <> 0 Then
		$wParam = BitOR($wParam, $SF_USECODEPAGE, BitShift($iCodePage, -16))
	EndIf

	Local $tEditStream = DllStructCreate($tagEDITSTREAM)
	DllStructSetData($tEditStream, "pfnCallback", DllCallbackGetPtr($__g_pGRC_StreamToVarCallback))

	$__g_pGRC_sStreamVar = ""
	_SendMessage($hWnd, $EM_STREAMOUT, $wParam, $tEditStream, 0, "wparam", "struct*")
	Local $iError = DllStructGetData($tEditStream, "dwError")
	If $iError <> 0 Then SetError(700, $iError, "")
	Return $__g_pGRC_sStreamVar
EndFunc   ;==>_GUICtrlRichEdit_StreamToVar

; #FUNCTION# ====================================================================================================================
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam)
; ===============================================================================================================================
Func _GUICtrlRichEdit_Undo($hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__g_sRTFClassName) Then Return SetError(101, 0, False)
	Return _SendMessage($hWnd, $EM_UNDO, 0, 0) <> 0
EndFunc   ;==>_GUICtrlRichEdit_Undo

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_Init
; Description ...: Sets global variables $__g_sRTFClassName, $__g_sRTFVersion, $__g_sGRE_CF_RTF and $__g_sGRE_CF_RETEXTOBJ
; Syntax.........: __GCR_Init { }
; Parameters ....:
; Return values .:
; Author ........: Prog@ndy
; Modified.......: Chris Haslam (c.haslam)
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GCR_Init()
	Local $ah_GUICtrlRTF_lib = DllCall("kernel32.dll", "ptr", "LoadLibraryW", "wstr", "MSFTEDIT.DLL")
	If $ah_GUICtrlRTF_lib[0] <> 0 Then
		$__g_sRTFClassName = "RichEdit50W"
		$__g_sRTFVersion = 4.1
	Else
		;RICHED20.DLL
		$ah_GUICtrlRTF_lib = DllCall("kernel32.dll", "ptr", "LoadLibraryW", "wstr", "RICHED20.DLL")
		$__g_sRTFVersion = FileGetVersion(@SystemDir & "\riched20.dll", "ProductVersion")
		Switch $__g_sRTFVersion
			Case 3.0
				$__g_sRTFClassName = "RichEdit20W"
			Case 5.0
				$__g_sRTFClassName = "RichEdit50W"
			Case 6.0
				$__g_sRTFClassName = "RichEdit60W"
		EndSwitch
	EndIf
	$__g_sGRE_CF_RTF = _ClipBoard_RegisterFormat("Rich Text Format")
	$__g_sGRE_CF_RETEXTOBJ = _ClipBoard_RegisterFormat("Rich Text Format with Objects")
EndFunc   ;==>__GCR_Init

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_StreamFromFileCallback
; Description ...: Callback function for streaming in from a file
; Syntax.........: __GCR_StreamFromFileCallback ( $hFile, $pBuf, $iBuflen, $pQbytes )
; Parameters ....: $hFile - Handle to the file
;                  $pBuf - pointer to a buffer in the control
;                  $iBuflen - length of this buffer
;                  $pQbytes - pointer to number of bytes set in buffer
; Return values .: More bytes to "return"  - 0
;                  All bytes have been "returned" - 1
; Author ........: Prog@ndy
; Modified.......: Chris Haslam (c.haslam)
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ EditStreamCallback Function
; Example .......:
; ===============================================================================================================================
Func __GCR_StreamFromFileCallback($hFile, $pBuf, $iBuflen, $pQbytes)
	Local $tQbytes = DllStructCreate("long", $pQbytes)
	DllStructSetData($tQbytes, 1, 0)
	Local $tBuf = DllStructCreate("char[" & $iBuflen & "]", $pBuf)
	Local $sBuf = FileRead($hFile, $iBuflen - 1)
	If @error Then Return 1
	DllStructSetData($tBuf, 1, $sBuf)
	DllStructSetData($tQbytes, 1, StringLen($sBuf))
	Return 0
EndFunc   ;==>__GCR_StreamFromFileCallback

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_StreamFromVarCallback
; Description ...: Callback function for streaming in from a variable
; Syntax.........: __GCR_StreamFromVarCallback ( $iCookie, $pBuf, $iBufLen, $pQbytes )
; Parameters ....: $iCookie - not used
;                  $pBuf - pointer to a buffer in the control
;                  $iBuflen - length of this buffer
;                  $pQbytes - pointer to number of bytes set in buffer
; Return values .: More bytes to "return"  - 0
;                  All bytes have been "returned" - 1
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ EditStreamCallback Function
; Example .......:
; ===============================================================================================================================
Func __GCR_StreamFromVarCallback($iCookie, $pBuf, $iBuflen, $pQbytes)
	#forceref $iCookie
	Local $tQbytes = DllStructCreate("long", $pQbytes)
	DllStructSetData($tQbytes, 1, 0)

	Local $tCtl = DllStructCreate("char[" & $iBuflen & "]", $pBuf)
	Local $sCtl = StringLeft($__g_pGRC_sStreamVar, $iBuflen - 1)
	If $sCtl = "" Then Return 1
	DllStructSetData($tCtl, 1, $sCtl)

	Local $iLen = StringLen($sCtl)
	DllStructSetData($tQbytes, 1, $iLen)
	$__g_pGRC_sStreamVar = StringMid($__g_pGRC_sStreamVar, $iLen + 1)
	Return 0
EndFunc   ;==>__GCR_StreamFromVarCallback

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_StreamFToFileCallback
; Description ...: Callback function for streaming out to a file
; Syntax.........: __GCR_StreamToFileCallback ( $hFile, $pBuf, $iBuflen, $pQbytes )
; Parameters ....: $hFile - Handle to the file
;                  $pBuf - pointer to a buffer in the control
;                  $iBuflen - length of this buffer
;                  $pQbytes - pointer to number of bytes set in buffer
; Return values .: 0
; Author ........: Prog@ndy
; Modified.......: Chris Haslam (c.haslam)
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ EditStreamCallback Function
; Example .......:
; ===============================================================================================================================
Func __GCR_StreamToFileCallback($hFile, $pBuf, $iBuflen, $pQbytes)
	Local $tQbytes = DllStructCreate("long", $pQbytes)
	DllStructSetData($tQbytes, 1, 0)
	Local $tBuf = DllStructCreate("char[" & $iBuflen & "]", $pBuf)
	Local $s = DllStructGetData($tBuf, 1)
	FileWrite($hFile, $s)
	DllStructSetData($tQbytes, 1, StringLen($s))
	Return 0
EndFunc   ;==>__GCR_StreamToFileCallback

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_StreamFToVarCallback
; Description ...: Callback function for streaming out to a variable
; Syntax.........: __GCR_StreamToVarCallback ( $iCookie, $pBuf, $iBufLen, $pQbytes )
; Parameters ....: $iCookie - not used
;                  $pBuf - pointer to a buffer in the control
;                  $iBuflen - length of this buffer
;                  $pQbytes - pointer to number of bytes set in buffer
; Return values .: 0
; Author ........: Chris Haslam (c.haslam)
; Modified.......: guinness
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ EditStreamCallback Function
; Example .......:
; ===============================================================================================================================
Func __GCR_StreamToVarCallback($iCookie, $pBuf, $iBuflen, $pQbytes)
	#forceref $iCookie
	Local $tQbytes = DllStructCreate("long", $pQbytes)
	DllStructSetData($tQbytes, 1, 0)
	Local $tBuf = DllStructCreate("char[" & $iBuflen & "]", $pBuf)
	Local $s = DllStructGetData($tBuf, 1)
	$__g_pGRC_sStreamVar &= $s
	Return 0
EndFunc   ;==>__GCR_StreamToVarCallback

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_ConvertTwipsToSpaceUnit
; Description ...: Converts Twips (1/1440 inch) to user space units
; Syntax.........: __GCR_ConvertTwipsToSpaceUnit ( $nIn )
; Parameters ....: $nIn - space in twips
; Return values .: Success - value in space units (inches, cm, mm, points or twips)
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GCR_ConvertTwipsToSpaceUnit($nIn)
	Local $sRet
	Switch $__g_iRTFTwipsPeSpaceUnit
		Case 1440, 567 ; inches, cm
			$sRet = StringFormat("%.2f", $nIn / $__g_iRTFTwipsPeSpaceUnit)
			If $sRet = "-0.00" Then $sRet = "0.00"
		Case 56.7, 72 ; mm, points
			$sRet = StringFormat("%.1f", $nIn / $__g_iRTFTwipsPeSpaceUnit)
			If $sRet = "-0.0" Then $sRet = "0.0"
		Case Else
			$sRet = $nIn
	EndSwitch
	Return $sRet
EndFunc   ;==>__GCR_ConvertTwipsToSpaceUnit

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_IsNumeric
; Description ...: Does a variable contain a numeric value?
; Syntax.........: __GCR_IsNumeric ( $vN )
; Parameters ....: $VN - the variable
;                  $SRange - ">0", ">=0", ">0,-1", ">=0,-1"
; Return values .: Success - True or False
;                  Failure - can't fail
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GCR_IsNumeric($vN, $sRange = "")
	If Not (IsNumber($vN) Or StringIsInt($vN) Or StringIsFloat($vN)) Then Return False
	Switch $sRange
		Case ">0"
			If $vN <= 0 Then Return False
		Case ">=0"
			If $vN < 0 Then Return False
		Case ">0,-1"
			If Not ($vN > 0 Or $vN = -1) Then Return False
		Case ">=0,-1"
			If Not ($vN >= 0 Or $vN = -1) Then Return False
	EndSwitch
	Return True
EndFunc   ;==>__GCR_IsNumeric

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_GetParaScopeChar
; Description ...: Gets the scope to which paragraph format settings apply
; Syntax.........:  __GCR_GetParaScopeChar ( $hWnd, $iMask, $iPFM )
; Parameters ....: $hWnd - handle to control
;                  $iMask - mask returned by _SendMessage
; Return values .: Success - the scope character
;                  Failure - can't fail
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; Remarks .......: Takes advantage of an undocumented feature of EM_GETPARAFORMAT
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GCR_GetParaScopeChar($hWnd, $iMask, $iPFM)
	If Not _GUICtrlRichEdit_IsTextSelected($hWnd) Then
		Return "c"
	ElseIf BitAND($iMask, $iPFM) = $iPFM Then
		Return "a"
	Else
		Return "f"
	EndIf
EndFunc   ;==>__GCR_GetParaScopeChar

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_ParseParaNumberingStyle
; Description ...: For _GUICtrlRichEdit_SetParaNumbering(), parses $vStyle
; Syntax.........: __GCR_ParseParaNumberingStyle ($sIn, $bForceRoman, ByRef $iPFM, ByRef $iWNumbering, ByRef $iWnumStart, ByRef $iWnumStyle, ByRef $iQspaces )
; Parameters ....: $sIn - style string: see _GUICtrlRichEdit_SetParaNumbering()
;                  $bForceRoman - If $vStyle contains numner i, interpret as Roman one else as letter i
;                  $iPFM - BitOR combination of $PFM_ constants (Returned)
;                  $iWNumbering - wNumbering member of PARAFORMAT2 structure
;                  $iWnumStart - wNumbering Start  member of PARAFORMAT2 structure (Returned)
;                  $iWNumStyle - wNumberingStyle  member of PARAFORMAT2 structure  (Returned)
;                  $iQspaces - for wNumberingTab  member of PARAFORMAT2 structure  (Returned)
; Return values .: Success - True
;                  Failure - False and sets @error:
;                  |102 - $sIn is invalid
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; Remarks .......:
; Related .......: GuiCtrlRichEdit_SetParaNumbering()
; Link ..........: @@MsdnLink@@ EM_PARAMFORMAT
; Example .......:
; ===============================================================================================================================
Func __GCR_ParseParaNumberingStyle($sIn, $bForceRoman, ByRef $iPFM, ByRef $iWNumbering, ByRef $iWnumStart, ByRef $iWnumStyle, ByRef $iQspaces)
	Local Const $sRoman = "mdclxviMDCLXVI", $iRpar = 0, $i2par = 0x100, $iPeriod = 0x200, $iNbrOnly = 0x300
	If $sIn = "" Then
		$iWNumbering = 0
		$iPFM = $PFM_NUMBERING
	Else
		Local $s = StringStripWS($sIn, $STR_STRIPTRAILING) ; trialing whitespace
		$iQspaces = StringLen($sIn) - StringLen($s)
		$sIn = $s
		$iPFM = $PFM_NUMBERINGTAB
		If $sIn = "." Then
			$iWNumbering = $PFN_BULLET
			$iPFM = BitOR($iPFM, $PFM_NUMBERING)
		ElseIf $sIn = "=" Then
			$iWnumStyle = 0x400
			$iPFM = BitOR($iPFM, $PFM_NUMBERINGSTYLE)
		Else
			Switch StringRight($sIn, 1)
				Case ")"
					If StringLeft($sIn, 1) = "(" Then
						$iWnumStyle = $i2par
						$sIn = StringTrimLeft($sIn, 1)
					Else
						$iWnumStyle = $iRpar
					EndIf
				Case "."
					$iWnumStyle = $iPeriod
				Case Else ; display only number
					$iWnumStyle = $iNbrOnly
			EndSwitch
			$iPFM = BitOR($iPFM, $PFM_NUMBERINGSTYLE)
			If $iWnumStyle <> 0x300 Then $sIn = StringTrimRight($sIn, 1)
			If StringIsDigit($sIn) Then
				$iWnumStart = Number($sIn)
				$iWNumbering = 2
				$iPFM = BitOR($iPFM, $PFM_NUMBERINGSTART, $PFM_NUMBERING)
			Else
				Local $bMayBeRoman = True
				For $i = 1 To StringLen($sIn)
					If Not StringInStr($sRoman, StringMid($sIn, $i, 1)) Then
						$bMayBeRoman = False
						ExitLoop
					EndIf
				Next
				Local $bIsRoman
				If $bMayBeRoman Then
					$bIsRoman = $bForceRoman
				Else
					$bIsRoman = False
				EndIf
				Switch True
					Case $bIsRoman
						$iWnumStart = __GCR_ConvertRomanToNumber($sIn)
						If $iWnumStart = -1 Then Return SetError(102, 0, False)
						$iWNumbering = (StringIsLower($sIn) ? 5 : 6)
						$iPFM = BitOR($iPFM, $PFM_NUMBERINGSTART, $PFM_NUMBERING)
					Case StringIsAlpha($sIn)
						If StringIsLower($sIn) Then
							$iWNumbering = 3
						Else
							$iWNumbering = 4
							$sIn = StringLower($sIn)
						EndIf
						$iWnumStart = 0
						Local $iN
						For $iP = 1 To StringLen($sIn)
							$iN = Asc(StringMid($sIn, $i))
							If $iN >= Asc("a") And $iN <= Asc("z") Then
								$iWnumStart = $iWnumStart * 26 + ($iN - Asc("a") + 1)
							EndIf
						Next
						$iPFM = BitOR($iPFM, $PFM_NUMBERINGSTART, $PFM_NUMBERING)
					Case Else
						Return SetError(102, 0, False)
				EndSwitch
			EndIf
		EndIf
	EndIf
	Return True
EndFunc   ;==>__GCR_ParseParaNumberingStyle

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_ConvertRomanToNumber
; Description ...: Converts a Roman number to a number
; Syntax.........: __GCR_ConvertRomanToNumber ( $sRnum )
; Parameters ....: $sRnum - string containing Roman number
; Return values .: Success - the (Arabic) number
;                  Failure - -1
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; Remarks .......: Is case-insensitive
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GCR_ConvertRomanToNumber($sRnum)
	Local Enum $e9, $e5, $e4, $e1, $eMult, $eHigher
	Local Const $aV[3][6] = [["cm", "d", "cd", "c", 100, "m"], ["xc", "l", "xl", "x", 10, "mdc"], ["ix", "v", "iv", "i", 1, "mdclx"]]
	$sRnum = StringLower($sRnum)
	Local $i = 1
	While StringMid($sRnum, $i, 1) = "m"
		$i += 1
	WEnd
	Local $iDigit, $iQ1s, $iRet = ($i - 1) * 1000
	For $j = 0 To 2
		$iDigit = 0
		If StringMid($sRnum, $i, 2) = $aV[$j][$e9] Then
			$iDigit = 9
			$i += 2
		ElseIf StringMid($sRnum, $i, 1) = $aV[$j][$e5] Then
			$iDigit = 5
			$i += 1
		ElseIf StringMid($sRnum, $i, 2) = $aV[$j][$e4] Then
			$iDigit = 4
			$i += 2
		ElseIf StringInStr($aV[$j][$eHigher], StringMid($sRnum, $i, 1)) Then
			Return -1
		EndIf
		If $iDigit = 0 Or $iDigit = 5 Then
			$iQ1s = 0
			While StringMid($sRnum, $i, 1) = $aV[$j][$e1]
				$iQ1s += 1
				If $iQ1s > 3 Then Return 0
				$i += 1
			WEnd
			$iDigit += $iQ1s
		EndIf
		$iRet += $iDigit * $aV[$j][$eMult]
	Next
	If $i <= StringLen($sRnum) Then Return -1
	Return $iRet
EndFunc   ;==>__GCR_ConvertRomanToNumber

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_SendGetCharFormatMessage
; Description ...: Gets character format of character just after the anchor point (if text is selected) or after the inserton point
; Syntax.........: __GCR_SendGetCharFormatMessage ( $hWnd, $tCharFormat )
; Parameters ....: $hWnd - handle of control
;                : $tCharFormat - CHARFORMAT or CHARFORMAT2 structure
; Return values .: Success - True
;                  Failure - error of _SendMessage EM_GETCHARFORMAT SCF_SELECTION
; Author ........: Chris Haslam (c.haslam)
; Modified.......:
; Remarks .......: If there is a selection, restores it before returning, with the anchor and actove positions correct,
;                  even if active < anchor
; Related .......:
; Link ..........: @@MsdnLink@@ EM_GETCHARFORMAT
; Example .......:
; ===============================================================================================================================
Func __GCR_SendGetCharFormatMessage($hWnd, $tCharFormat)
	Return _SendMessage($hWnd, $EM_GETCHARFORMAT, $SCF_SELECTION, $tCharFormat, 0, "wparam", "struct*")
EndFunc   ;==>__GCR_SendGetCharFormatMessage

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_SendGetParaFormatMessage
; Description ...: Gets format of (first) selected paragraph or, if no selection, of the paragraph containing the insertion point
; Syntax.........: __GCR_SendGetParaFormatMessage ( $hWnd, $tParaFormat )
; Parameters ....: $hWnd - handle of control
;                : $tParaFormat - PARAFORMAT or PARAFORMAT2 structure
; Return values .: Success - True
;                  Failure - error of _SendMessage EM_PARAFORMAT
; Author ........: Chris Haslam (c.haslam)
; Modified.......: guinness
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ EM_PARAFORMAT
; Example .......:
; ===============================================================================================================================
Func __GCR_SendGetParaFormatMessage($hWnd, $tParaFormat)
	Local $bIsSel = _GUICtrlRichEdit_IsTextSelected($hWnd)
	Local $iInsPt = 0
	If Not $bIsSel Then
		Local $aS = _GUICtrlRichEdit_GetSel($hWnd)
		$iInsPt = $aS[0]
		Local $iN = _GUICtrlRichEdit_GetFirstCharPosOnLine($hWnd)
		_GUICtrlRichEdit_SetSel($hWnd, $iN, $iN + 1, True)
	EndIf

	_SendMessage($hWnd, $EM_GETPARAFORMAT, 0, $tParaFormat, 0, "wparam", "struct*")
	If @error Then Return SetError(@error, @extended, False)

	If Not $bIsSel Then _GUICtrlRichEdit_SetSel($hWnd, $iInsPt, $iInsPt)

	Return True
EndFunc   ;==>__GCR_SendGetParaFormatMessage

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GCR_SetOLECallback
; Description....: Enables OLE-relationed functionality
; Syntax.........: _GUICtrlRichEdit_SetOLECallback ( $hWnd )
; Parameters.....: $hWnd		- Handle to the control
; Return values..: Success - True
;                  Failure - False and set @error:
;                  |101 - $hWnd is not a handle
;                  |700 - internal error
; Authors........: Prog@ndy
; Modified ......: Chris Haslam (c.haslam)
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ EM_SETOLECALLBACK
; Example .......:
; ===============================================================================================================================
Func __GCR_SetOLECallback($hWnd)
	If Not IsHWnd($hWnd) Then Return SetError(101, 0, False)

	;// Initialize the OLE part.
	If Not $__g_pObj_RichCom Then
		$__g_tCall_RichCom = DllStructCreate("ptr[20]");  '(With some extra space for the future)
		DllStructSetData($__g_tCall_RichCom, 1, DllCallbackGetPtr($__g_pRichCom_Object_QueryInterface), 1)
		DllStructSetData($__g_tCall_RichCom, 1, DllCallbackGetPtr($__g_pRichCom_Object_AddRef), 2)
		DllStructSetData($__g_tCall_RichCom, 1, DllCallbackGetPtr($__g_pRichCom_Object_Release), 3)
		DllStructSetData($__g_tCall_RichCom, 1, DllCallbackGetPtr($__g_pRichCom_Object_GetNewStorage), 4)
		DllStructSetData($__g_tCall_RichCom, 1, DllCallbackGetPtr($__g_pRichCom_Object_GetInPlaceContext), 5)
		DllStructSetData($__g_tCall_RichCom, 1, DllCallbackGetPtr($__g_pRichCom_Object_ShowContainerUI), 6)
		DllStructSetData($__g_tCall_RichCom, 1, DllCallbackGetPtr($__g_pRichCom_Object_QueryInsertObject), 7)
		DllStructSetData($__g_tCall_RichCom, 1, DllCallbackGetPtr($__g_pRichCom_Object_DeleteObject), 8)
		DllStructSetData($__g_tCall_RichCom, 1, DllCallbackGetPtr($__g_pRichCom_Object_QueryAcceptData), 9)
		DllStructSetData($__g_tCall_RichCom, 1, DllCallbackGetPtr($__g_pRichCom_Object_ContextSensitiveHelp), 10)
		DllStructSetData($__g_tCall_RichCom, 1, DllCallbackGetPtr($__g_pRichCom_Object_GetClipboardData), 11)
		DllStructSetData($__g_tCall_RichCom, 1, DllCallbackGetPtr($__g_pRichCom_Object_GetDragDropEffect), 12)
		DllStructSetData($__g_tCall_RichCom, 1, DllCallbackGetPtr($__g_pRichCom_Object_GetContextMenu), 13)
		DllStructSetData($__g_tObj_RichComObject, 1, DllStructGetPtr($__g_tCall_RichCom))
		DllStructSetData($__g_tObj_RichComObject, 2, 1)
		$__g_pObj_RichCom = DllStructGetPtr($__g_tObj_RichComObject)
	EndIf
	Local Const $EM_SETOLECALLBACK = 0x400 + 70
	If _SendMessage($hWnd, $EM_SETOLECALLBACK, 0, $__g_pObj_RichCom) = 0 Then Return SetError(700, 0, False)
	Return True
EndFunc   ;==>__GCR_SetOLECallback

; /////////////////////////////////////
; // OLE stuff, don't use yourself..
; /////////////////////////////////////
; // Useless procedure, never called..
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_QueryInterface
; Description ...:
; Syntax.........: __RichCom_Object_QueryInterface ( $pObject, $RiEFIID, $pPvObj )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __RichCom_Object_QueryInterface($pObject, $iREFIID, $pPvObj)
	#forceref $pObject, $iREFIID, $pPvObj
	Return $_GCR_S_OK
EndFunc   ;==>__RichCom_Object_QueryInterface

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_AddRef
; Description ...:
; Syntax.........: __RichCom_Object_AddRef ( $pObject )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __RichCom_Object_AddRef($pObject)
	;Exit Function
	Local $tData = DllStructCreate("ptr;dword", $pObject)
	DllStructSetData($tData, 2, DllStructGetData($tData, 2) + 1)
	Return DllStructGetData($tData, 2)
EndFunc   ;==>__RichCom_Object_AddRef

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_Release
; Description ...:
; Syntax.........: __RichCom_Object_Release ( $pObject )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __RichCom_Object_Release($pObject)
	;Exit Function
	Local $tData = DllStructCreate("ptr;dword", $pObject)
	If DllStructGetData($tData, 2) > 0 Then
		DllStructSetData($tData, 2, DllStructGetData($tData, 2) - 1)
		Return DllStructGetData($tData, 2)
	EndIf
	;If @pObject[1] > 0 Then
	;Decr @pObject[1]
	;Func = @pObject[1]
	;Else
	;pObject = 0
	;End If
EndFunc   ;==>__RichCom_Object_Release

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_GetInPlaceContext
; Description ...:
; Syntax.........: __RichCom_Object_GetInPlaceContext ( $pObject, $pPFrame, $pPDoc, $pFrameInfo )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __RichCom_Object_GetInPlaceContext($pObject, $pPFrame, $pPDoc, $pFrameInfo)
	#forceref $pObject, $pPFrame, $pPDoc, $pFrameInfo
	Return $_GCR_E_NOTIMPL
EndFunc   ;==>__RichCom_Object_GetInPlaceContext

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_ShowContainerUI
; Description ...:
; Syntax.........: __RichCom_Object_ShowContainerUI ( $pObject, $bShow )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __RichCom_Object_ShowContainerUI($pObject, $bShow)
	#forceref $pObject, $bShow
	Return $_GCR_E_NOTIMPL
EndFunc   ;==>__RichCom_Object_ShowContainerUI

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_QueryInsertObject
; Description ...:
; Syntax.........: __RichCom_Object_QueryInsertObject ( $pObject, $pClsid, $tStg, $vCp )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __RichCom_Object_QueryInsertObject($pObject, $pClsid, $tStg, $vCp)
	#forceref $pObject, $pClsid, $tStg, $vCp
	Return $_GCR_S_OK
EndFunc   ;==>__RichCom_Object_QueryInsertObject

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_DeleteObject
; Description ...:
; Syntax.........: __RichCom_Object_DeleteObject ( $pObject, $pOleobj )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __RichCom_Object_DeleteObject($pObject, $pOleobj)
	#forceref $pObject, $pOleobj
	Return $_GCR_E_NOTIMPL
EndFunc   ;==>__RichCom_Object_DeleteObject

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_QueryAcceptData
; Description ...:
; Syntax.........: __RichCom_Object_QueryAcceptData ( $pObject, $pDataobj, $pCfFormat, $vReco, bReally, $hMetaPict )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __RichCom_Object_QueryAcceptData($pObject, $pDataobj, $pCfFormat, $vReco, $bReally, $hMetaPict)
	#forceref $pObject, $pDataobj, $pCfFormat, $vReco, $bReally, $hMetaPict
	Return $_GCR_S_OK
EndFunc   ;==>__RichCom_Object_QueryAcceptData

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_ContextSensitiveHelp
; Description ...:
; Syntax.........: __RichCom_Object_ContextSensitiveHelp ( $pObject, $bEnterMode )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __RichCom_Object_ContextSensitiveHelp($pObject, $bEnterMode)
	#forceref $pObject, $bEnterMode
	Return $_GCR_E_NOTIMPL
EndFunc   ;==>__RichCom_Object_ContextSensitiveHelp

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_GetClipboardData
; Description ...:
; Syntax.........: __RichCom_Object_GetClipboardData ( $pObject, $pChrg, $vReco, $pPdataobj )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __RichCom_Object_GetClipboardData($pObject, $pChrg, $vReco, $pPdataobj)
	#forceref $pObject, $pChrg, $vReco, $pPdataobj
	Return $_GCR_E_NOTIMPL
EndFunc   ;==>__RichCom_Object_GetClipboardData

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_GetDragDropEffect
; Description ...:
; Syntax.........: __RichCom_Object_GetDragDropEffect ( $pObject, $bDrag, $iGrfKeyState, $piEffect )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __RichCom_Object_GetDragDropEffect($pObject, $bDrag, $iGrfKeyState, $piEffect)
	#forceref $pObject, $bDrag, $iGrfKeyState, $piEffect
	Return $_GCR_E_NOTIMPL
EndFunc   ;==>__RichCom_Object_GetDragDropEffect

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_GetContextMenu
; Description ...:
; Syntax.........: __RichCom_Object_GetContextMenu ( $pObject, $iSeltype, $pOleobj, $pChrg, $pHmenu )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __RichCom_Object_GetContextMenu($pObject, $iSeltype, $pOleobj, $pChrg, $pHmenu)
	#forceref $pObject, $iSeltype, $pOleobj, $pChrg, $pHmenu
	Return $_GCR_E_NOTIMPL
EndFunc   ;==>__RichCom_Object_GetContextMenu

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __RichCom_Object_GetNewStorage
; Description ...:
; Syntax.........: __RichCom_Object_GetNewStorage ( $pObject, $pPstg )
; Parameters ....:
; Return values .:
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __RichCom_Object_GetNewStorage($pObject, $pPstg)
	#forceref $pObject
	;If pCall_RichCom_CreateILockBytesOnHGlobal = 0 Or pCall_RichCom_StgCreateDocfileOnILockBytes = 0 Then Exit Function
	Local $aSc = DllCall($__g_hLib_RichCom_OLE32, "dword", "CreateILockBytesOnHGlobal", "hwnd", 0, "int", 1, "ptr*", 0)
	Local $pLockBytes = $aSc[3]
	$aSc = $aSc[0]
	;Call Dword pCall_RichCom_CreateILockBytesOnHGlobal Using _
	;RichCom_CreateILockBytesOnHGlobal( ByVal 0&, ByVal 1&, lpLockBytes ) To sc
	If $aSc Then Return $aSc
	$aSc = DllCall($__g_hLib_RichCom_OLE32, "dword", "StgCreateDocfileOnILockBytes", "ptr", $pLockBytes, "dword", BitOR(0x10, 2, 0x1000), "dword", 0, "ptr*", 0)
	Local $tStg = DllStructCreate("ptr", $pPstg)
	DllStructSetData($tStg, 1, $aSc[4])
	$aSc = $aSc[0]
	;Call Dword pCall_RichCom_StgCreateDocfileOnILockBytes Using _
	;RichCom_StgCreateDocfileOnILockBytes( _
	;@lpLockBytes _
	;, ByVal %STGM_SHARE_EXCLUSIVE Or %STGM_READWRITE Or %STGM_CREATE _
	;, ByVal 0& _
	;, lplpstg _
	;) To sc
	If $aSc Then ; Call IUnknown->Release on $pLockBytes
		Local $tObj = DllStructCreate("ptr", $pLockBytes) ; prepare access to vTable
		Local $tUnknownFuncTable = DllStructCreate("ptr[3]", DllStructGetData($tObj, 1)) ; access IUnknown vTable
		Local $pReleaseFunc = DllStructGetData($tUnknownFuncTable, 3) ; get address of IUnknwon->Release
		DllCallAddress("long", $pReleaseFunc, "ptr", $pLockBytes) ; call release
	EndIf
	;If sc Then Call Dword @@lpLockBytes[2] Using __RichCom_Object_Release( @lpLockBytes )
	Return $aSc
EndFunc   ;==>__RichCom_Object_GetNewStorage
