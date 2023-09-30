#include <MsgBoxConstants.au3>

#include-once

; #INDEX# =======================================================================================================================
; Title .........: Visa
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: VISA (GPIB & TCP) library for AutoIt.
;                  Functions that allow controlling instruments (e.g. oscilloscopes,
;                  signal generators, spectrum analyzers, power supplies, etc)
;                  that have a GPIB or Ethernet port through the VISA interface
;                  (GPIB, TCP or Serial Interface)
; Author(s) .....: Angel Ezquerra
; Dll ...........: visa32.dll
; ===============================================================================================================================

; ------------------------------------------------------------------------------
;
;                 visa32.dll is in {WINDOWS}\system32)
;                 For GPIB communication a GPIB card (such as a National Instruments
;                 NI PCI-GPIB card or an Agilent 82350B PCI High-Performance GPIB card
; Limitations:    The VISA queries only return the 1st line of the device answer
;                 This is not a problem in most cases, as most devices will always
;                 answer with a single line.
; Notes:
;                 If you are interested in this library you probably already know
;                 what is VISA and GPIB, but here there is a short description
;                 for those that don't know about it:
;
;                 Basically GPIB allows you to control instruments like Power
;                 Supplies, Signal Generators, Oscilloscopes, Signal Generators, etc.
;                 You need to install or connect a GPIB interface card (PCI, PCMCIA
;                 or USB) to your PC and install the corresponding GPIB driver.
;
;                 VISA is a standard API that sits on top of the GPIB driver and
;                 it allows you to use the same programs to control your
;                 instruments regardless of the type of GPIB card that you have
;                 installed in your PC (most cards are made either by National
;                 Instruments(R) or by Agilent/Hewlett-Packard(R)).
;
;                 This library is that it opens AutoIt to a different kind of
;                 automation (instrument automation). Normally you would need to
;                 use some expensive "instrumentation" environment like
;                 Labwindows/CVI (TM), LabView (TM) or Matlab (TM) to automate
;                 instruments but now you can do so with AutoIt.
;                 The only requirement is that you need a VISA compatible GPIB
;                 card (all cards that I know are) and the corresponding VISA
;                 driver must be installed (look for visa32.dll in the
;                 windows\system32 folder).
;
;                 Basically you have 4 main functions:
;                 _viExecCommand - Executes commands and queries through GPIB
;                 _viOpen, _viClose - Open/Close a connection to a GPIB instrument.
;                 _viFindGpib - Find all the instruments in the GPIB bus
;
;                 There are other less important functions, like:
;                 _viGTL - Go to local mode (exeit the "remote control mode")
;                 _viGpibBusReset - Reset the GPIB bus if it is in a bad state
;                 _viSetTimeout - Sets the GPIB Query timeout
;                 _viSetAttribute - Set any VISA attribute
;
;                 There is one known limitation of this library:
;                 - The GPIB queries do not support binary transfer.
;
;                 It is recommended that you try first to execute the _viFindGpib
;                 function (as shown in the example in the _viFindGpib header)
;                 and see if you can find any instruments. You can also have a
;                 look at the examples in the _viExecCommand function description.
;
; ------------------------------------------------------------------------------
; VERSION       DATE       DESCRIPTION
; -------    ----------    -----------------------------------------------------
; v1.0.00    02/01/2005    Initial release
; v1.0.01    02/06/2005    Formatted according to Standard UDF rules
;                          Fixed _viGpibBusReset
;                          Renamed _viFindGpib to _viFindGpib
;                          Removed unnecessary MsgBox calls
;                          More detailed function headers
;                          Added Serial Interface related Attribute/Value Constants
; v1.0.02    02/11/2005    Fixed _viQueryf only executing "*IDN?" queries
;                          Fixed _viQueryf only returning characters up to the first space
;                          Fixed _viQuertf returning only first line of answer
;                          Added _viInterativeControl for interactive VISA control
;                          Added GPIB message termination attributes
; ------------------------------------------------------------------------------

; #VARIABLES# ===================================================================================================================
; The VISA Resource Manager is used by the _viOpen functions (see below)
; This is the only (non constant) Global required by this library
Global $__g_hVISA_DEFAULT_RM = -1
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; NOTE: There are more attribute values. Please refer to the VISA Programmer's Guide
Global Const $VI_SUCCESS = 0 ; (0L)
Global Const $VI_NULL = 0

Global Const $VI_TRUE = 1
Global Const $VI_FALSE = 0

; - VISA GPIB BUS control macros (for __viGpibControlREN, see below) -------------
Global Const $VI_GPIB_REN_DEASSERT = 0
Global Const $VI_GPIB_REN_ASSERT = 1
Global Const $VI_GPIB_REN_DEASSERT_GTL = 2
Global Const $VI_GPIB_REN_ASSERT_ADDRESS = 3
Global Const $VI_GPIB_REN_ASSERT_LLO = 4
Global Const $VI_GPIB_REN_ASSERT_ADDRESS_LLO = 5
Global Const $VI_GPIB_REN_ADDRESS_GTL = 6

; - VISA interface ATTRIBUTE NAMES ----------------------------------------------
; General Attributes
Global Const $VI_ATTR_TMO_VALUE = 0x3FFF001A

; Serial Interface related Attributes
Global Const $VI_ATTR_ASRL_BAUD = 0x3FFF0021
Global Const $VI_ATTR_ASRL_DATA_BITS = 0x3FFF0022
Global Const $VI_ATTR_ASRL_PARITY = 0x3FFF0023
Global Const $VI_ATTR_ASRL_STOP_BITS = 0x3FFF0024
Global Const $VI_ATTR_ASRL_FLOW_CNTRL = 0x3FFF0025

; GPIB message termination attributes
Global Const $VI_ATTR_TERMCHAR = 0x3FFF0018
Global Const $VI_ATTR_TERMCHAR_EN = 0x3FFF0038
Global Const $VI_ATTR_SEND_END_EN = 0x3FFF0016

; - VISA interface ATTRIBUTE VALUES ---------------------------------------------
; * TIMEOUT VALUES:
Global Const $VI_TMO_IMMEDIATE = 0
Global Const $VI_TMO_INFINITE = 0xFFFFFFF

; Serial Interface related Attribute Values
Global Const $VI_ASRL_PAR_NONE = 0
Global Const $VI_ASRL_PAR_ODD = 1
Global Const $VI_ASRL_PAR_EVEN = 2
Global Const $VI_ASRL_PAR_MARK = 3
Global Const $VI_ASRL_PAR_SPACE = 4

Global Const $VI_ASRL_STOP_ONE = 10
Global Const $VI_ASRL_STOP_ONE5 = 15
Global Const $VI_ASRL_STOP_TWO = 20

Global Const $VI_ASRL_FLOW_NONE = 0
Global Const $VI_ASRL_FLOW_XON_XOFF = 1
Global Const $VI_ASRL_FLOW_RTS_CTS = 2
Global Const $VI_ASRL_FLOW_DTR_DSR = 4
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _viClose
; _viExecCommand
; _viFindGpib
; _viGpibBusReset
; _viGTL
; _viInteractiveControl
; _viOpen
; _viSetAttribute
; _viSetTimeout
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __viOpenDefaultRM
; __viPrintf
; __viQueryf
; __viGpibControlREN
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Angel Ezquerra <ezquerra at gmail dot com>
; ===============================================================================================================================
Func _viExecCommand($hSession, $sCommand, $iTimeoutMS = -1, $sMode = @LF)
	If StringInStr($sCommand, "?") = 0 Then
		; The Command is NOT a QUERY
		Return __viPrintf($hSession, $sCommand, $iTimeoutMS, $sMode)
	Else
		; The Command is a QUERY
		Return __viQueryf($hSession, $sCommand, $iTimeoutMS)
	EndIf
EndFunc   ;==>_viExecCommand

; #FUNCTION# ====================================================================================================================
; Author ........: Angel Ezquerra <ezquerra at gmail dot com>
; ===============================================================================================================================
Func _viOpen($sVisa_Address, $sVisa_Secondary_Address = 0)
	Local $hSession = -1 ; The session handle by default is invalid (-1)

	If IsNumber($sVisa_Address) Or StringInStr($sVisa_Address, "::") = 0 Then
		; We passed a number => Create the VISA string:
		$sVisa_Address = "GPIB0::" & $sVisa_Address & "::" & $sVisa_Secondary_Address
	EndIf

	;- Do not open an instrument connection twice
	; TODO

	;- Make sure that there is a Resource Manager open (Note: this will NOT open it twice!)
	__viOpenDefaultRM()

	;- Open the INSTRUMENT CONNECTION
	; errStatus = viOpen (VISA_DEFAULT_RM, "GPIB0::20::0", VI_NULL, VI_NULL, &h_session);
	; signed int viOpen(unsigned long, char*, unsigned long, unsigned long, *unsigned long)
	Local $a_Results
	$a_Results = DllCall("visa32.dll", "long", "viOpen", "long", $__g_hVISA_DEFAULT_RM, "str", $sVisa_Address, "long", $VI_NULL, "long", $VI_NULL, "long*", -1)
	If @error Then Return SetError(@error, @extended, -1)
	Local $iErrStatus = $a_Results[0]
	If $iErrStatus <> 0 Then
		; Could not open VISA instrument/resource
		Return SetError(1, 0, -2)

	EndIf
	; Make sure that the DllCall returned enough values
	If UBound($a_Results) < 6 Then
		Return SetError(1, 0, -3)
	EndIf

	$hSession = $a_Results[5]
	If $hSession <= 0 Then
		; viOpen did not return a valid handle
		Return SetError(1, 0, -4)
	EndIf

	; We have a valid handle for the device
	Return $hSession
EndFunc   ;==>_viOpen

; #FUNCTION# ====================================================================================================================
; Author ........: Angel Ezquerra <ezquerra at gmail dot com>
; ===============================================================================================================================
Func _viClose($hSession)
	;- Close INSTRUMENT Connection
	; viClose(h_session);
	Local $a_Results
	$a_Results = DllCall("visa32.dll", "int", "viClose", "int", $hSession)
	If @error Then Return SetError(@error, @extended, -1)
	Local $iErrStatus = $a_Results[0]
	If $iErrStatus <> 0 Then
		; Could not close VISA instrument/resource
		Return SetError(1, 0, $iErrStatus)
	EndIf

	Return 0
EndFunc   ;==>_viClose

; #FUNCTION# ====================================================================================================================
; Author ........: Angel Ezquerra <ezquerra at gmail dot com>
; ===============================================================================================================================
Func _viFindGpib(ByRef $aDescriptorList, ByRef $aIDNList, $iShow_Search_Results = 0)
	;- Make sure that there is a Resource Manager open (Note: this will NOT open it twice!)
	__viOpenDefaultRM()

	; Create the GPIB instrument list and return the 1st instrument descriptor
	; viStatus viFindRsrc (viSession, char*, *ViFindList, *ViUInt32, char*);
	; errStatus = viFindRsrc (VISA_DEFAULT_RM, "GPIB?*INSTR", &h_current_instr, &num_matches, s_found_instr_descriptor);
	Local $a_Results = DllCall("visa32.dll", "long", "viFindRsrc", _
			"long", $__g_hVISA_DEFAULT_RM, "str", "GPIB?*INSTR", "long*", -1, _
			"int*", -1, "str", "")
	If @error Then Return SetError(@error, @extended, -1)
	Local $iErrStatus = $a_Results[0]
	If $iErrStatus <> 0 Then
		; Could not perform GPIB FIND operation
		Return SetError(1, 0, -2)
	EndIf
	; Make sure that the DllCall returned enough values
	If UBound($a_Results) < 5 Then
		Return SetError(1, 0, -3)
	EndIf

	; Assign the outputs of the DllCall
	Local $h_List_pointer = $a_Results[3] ; The pointer to the list of found instruments
	Local $i_Num_instr = $a_Results[4] ; The number of instruments that were found
	Local $s_First_descriptor = $a_Results[5] ; The descriptor of the first instrument found
	If $i_Num_instr < 1 Then ; No insturments were found
		If $iShow_Search_Results = 1 Then
			MsgBox($MB_SYSTEMMODAL, "GPIB search results", "NO INSTRUMENTS FOUND in the GPIB bus")
		EndIf

		Return $i_Num_instr
	EndIf

	; At least 1 instrument was found
	ReDim $aDescriptorList[$i_Num_instr], $aIDNList[$i_Num_instr]
	$aDescriptorList[0] = $s_First_descriptor
	; Get the IDN of the 1st instrument
	$aIDNList[0] = _viExecCommand($s_First_descriptor, "*IDN?")

	; Get the IDN of all the remaining instruments
	For $n = 1 To $i_Num_instr - 1
		; If more than 1 instrument was found, get the handle of the next instrument
		; and get its IDN

		;- Get the handle and descriptor of the next instrument in the GPIB bus
		; We do this by calling "viFindNext"
		; viFindNext (*ViFindList, char*);
		; viFindNext (h_current_instr,s_found_instr_descriptor);
		$a_Results = DllCall("visa32.dll", "long", "viFindNext", "long", $h_List_pointer, "str", "")
		If @error Then Return SetError(@error, @extended, -1)
		$iErrStatus = $a_Results[0]
		If $iErrStatus <> 0 Then
			; Could not perform GPIB FIND NEXT operation
			Return SetError(1, 0, -2)
		EndIf
		; Make sure that the DllCall returned enough values
		If UBound($a_Results) < 3 Then
			Return SetError(1, 0, -3)
		EndIf
		$aDescriptorList[$n] = $a_Results[2]
		$aIDNList[$n] = _viExecCommand($aDescriptorList[$n], "*IDN?")
	Next

	If $iShow_Search_Results = 1 Then
		; Create the GPIB instrument list and show it in a MsgBox
		Local $s_Search_results = ""
		For $n = 0 To $i_Num_instr - 1
			$s_Search_results = $s_Search_results & $aDescriptorList[$n] & " - " & $aIDNList[$n] & @CR
		Next
		MsgBox($MB_SYSTEMMODAL, "GPIB search results", $s_Search_results)
	EndIf

	Return $i_Num_instr
EndFunc   ;==>_viFindGpib

; #INTERNAL_USE_ONLY# ===========================================================================================================
;
; Description ...: Open the VISA Resource Manager
; Syntax.........: __viOpenDefaultRM ( )
; Parameters ....: None
; Return values .: On Success - The Default Resource Manager Handle (also stored
;                   in the $__g_hVISA_DEFAULT_RM global)
;                   On Failure - Returns -1 if the VISA DLL could not be open
;                                Returns -2 if there was an error opening the
;                                Default Resource Manager
;                                Returns -3 if the returned Resource Manager is
;                                invalid
;                   This function always sets @error to 1 in case of error
; Author ........: Angel Ezquerra <ezquerra at gmail dot com>
; Notes .........: You should not need to directly call this function under
;                   normal use as _viOpen calls it when necessary
;
; ===============================================================================================================================
Func __viOpenDefaultRM()
	Local $h_Visa_rm = $__g_hVISA_DEFAULT_RM
	If $__g_hVISA_DEFAULT_RM < 0 Then
		; Only open the Resource Manager once (i.e. when $__g_hVISA_DEFAULT_RM is still -1)
		$h_Visa_rm = $__g_hVISA_DEFAULT_RM ; Initialize the output result with the default value (-1)

		; errStatus = viOpenDefaultRM (&VISA_DEFAULT_RM);
		; signed int viOpenDefaultRM(*unsigned long)
		Local $a_Results
		$a_Results = DllCall("visa32.dll", "int", "viOpenDefaultRM", "int*", $__g_hVISA_DEFAULT_RM)
		If @error Then Return SetError(@error, @extended, -1)
		Local $iErrStatus = $a_Results[0]
		If $iErrStatus <> 0 Then
			; Could not create VISA Resource Manager
			Return SetError(1, 0, -2)
		EndIf
		; Everything went fine => Set the Resource Manager global
		$__g_hVISA_DEFAULT_RM = $a_Results[1]
		If $__g_hVISA_DEFAULT_RM <= 0 Then
			; There was an error, reset the $__g_hVISA_DEFAULT_RM
			$__g_hVISA_DEFAULT_RM = -1 ; Default value
			SetError(1)
			Return -3
		EndIf
		$h_Visa_rm = $__g_hVISA_DEFAULT_RM
	EndIf

	Return $h_Visa_rm
EndFunc   ;==>__viOpenDefaultRM

; #INTERNAL_USE_ONLY# ===========================================================================================================
;
; Description ...: Send a COMMAND (NOT a QUERY) to an Instrument/Device
; Syntax.........: __viPrintf ( $hSession, $sCommand [, $iTimeout_ms = -1] )
; Parameters ....: $hSession - A VISA descriptor (STRING) OR a VISA session handle (INTEGER)
;                                Look at the _viExecCommand function for more
;                                details
;                   $sCommand - Command/Query to execute.
;                                A query MUST contain a QUESTION MARK (?)
;                                When the command is a QUERY the function will
;                                automatically wait for the instrument's answer
;                                (or until the operation times out)
;                   $iTimeout_ms - The operation timeout in MILISECONDS
;                                This is mostly important for QUERIES only
;                                This is an OPTIONAL PARAMETER.
;                                If it is not specified the last set timeout will
;                                be used. If it was never set before the default
;                                timeout (which depends on the VISA implementation)
;                                will be used. Timeouts can also be set separatelly
;                                with the _viSetTimeout function (see below).
;                                Depending on the bus type (GPIB, TCP, etc) the
;                                timeout might not be set to the exact value that
;                                you request. Instead the closest valid timeout
;                                bigger than the one that you requested will be used.
;                   $sOption - Control the mode in which the VISA viPrintf is called
;                                This is an OPTIONAL PARAMETER
;                                The DEFAULT VALUE is @LF, which means "attach @LF mode".
;                                Some instruments and in particular many GPIB cards
;                                Do not honor the terminator character attribute
;                                In those cases an @LF terminator needs to be added.
;                                As this is the most common case, by default the mode
;                                is set to @LF, which appends @LF to the SCPI command
;                                You can also set this mode to @CR and @CRLF if your card
;                                uses those terminators.
;                                If you do not want to use a terminator, set this parameter
;                                to an empty string ("")
;                                Also, some cards support the execution of a "sprintf" on the
;                                SCPI string prior to sending it through the VISA interface.
;                                For those who do, it is possible, by setting this
;                                parameter to "str" to "protect" the VISa interface from
;                                accidentally applying an escape sequence when a "/" is
;                                found within the VISA command string.
;                                This is normally NOT necessary and should only be set
;                                if your GPIB card or instrument require it.
; Return values .: On Success - Returns ZERO
;                   On Failure - Returns -1 if the VISA DLL could not be open
;                                or a NON ZERO value representing the VISA
;                                error code (see the VISA programmer's guide)
;                   This function always sets @error to 1 in case of error
; Author ........: Angel Ezquerra <ezquerra at gmail dot com>
; Notes .........:
;                   Normally you do not need to use this function,
;                   as _viExecCommand automatically choses between _viPrintf and
;                   __viQueryf depending on the command type.
;
;                   If you need to use it anyway, it is recommended that you do
;                   not use this command for sending QUERIES, only for GPIB
;                   commands that DO NOT RETURN AN ANSWER
;
;                   Also, this is not really a "PRINTF-like" function, as it
;                   does not allow you to pass multiple parameters. This is only
;                   called _viPrintf because it uses the VISA function viPrintf
;
;                   See _viExecCommand for more details
;
; ===============================================================================================================================
Func __viPrintf($hSession, $sCommand, $iTimeout_ms = -1, $sOption = @LF)
	Local $b_Close_session_before_return = 0 ; By default do not close the session at the end
	If IsString($hSession) Then
		; When we pass a string, i.e. a VISA ID (like GPIB::20::0, for instance) instead
		; of a VISA session handler, we will automatically OPEN and CLOSE the instrument
		; session for the user.
		; This is of course slower if you need to do more than one GPIB call but much
		; more convenient for short tests
		$b_Close_session_before_return = 1
		$hSession = _viOpen($hSession)
	EndIf

	;- Set the VISA timeout if necessary
	If $iTimeout_ms >= 0 Then
		_viSetTimeout($hSession, $iTimeout_ms)
	EndIf

	;- Send Command to instrument (using viPrintf VISA function)
	; The syntax of the viPrintf VISA function is:
	; errStatus = viPrintf (h_session, "%s", "*RST");
	; signed int viPrintf (unsigned long, char*, char*);

	; For symmetry with the viQueryf function, and to solve compatibility issues
	; with some instruments, call viPrintf WITHOUT protecting from escape sequences
	; The user MUST thus be careful when passing commands containing the '/' character
	Local $a_Results
	Select
		Case $sOption = "str"
			; Use the "str" mode to pass the SCPI command to the VISA interface
			$a_Results = DllCall("visa32.dll", "int:cdecl", "viPrintf", "int", $hSession, "str", "%s", "str", $sCommand) ; Call viPrintf with escape sequence protection
		Case ($sOption = @CR Or $sOption = @LF Or $sOption = @CRLF)
			; Append the selected terminator to the SCPI command
			$a_Results = DllCall("visa32.dll", "int:cdecl", "viPrintf", "int", $hSession, "str", $sCommand & $sOption)
		Case Else ; In all other cases, ignore the "mode" and do not use any terminator string
			$a_Results = DllCall("visa32.dll", "int:cdecl", "viPrintf", "int", $hSession, "str", $sCommand) ; Call viPrintf without escape sequence protection
	EndSelect

	If @error Then Return SetError(@error, @extended, -1)
	Local $iErrStatus = $a_Results[0]
	If $iErrStatus <> 0 Then
		; Could not send command to VISA instrument/resource
		Return SetError(1, 0, $iErrStatus)
	EndIf

	If $b_Close_session_before_return = 1 Then
		_viClose($hSession)
	EndIf
EndFunc   ;==>__viPrintf

; #INTERNAL_USE_ONLY# ===========================================================================================================
;
; Description ...: Send a QUERY (a Command that returns an answer) to an Instrument/Device
; Syntax.........: __viQueryf ( $hSession, $sQuery [, $iTimeout_ms = -1] )
; Parameters ....: $hSession - A VISA descriptor (STRING) OR a VISA session handle (INTEGER)
;                                Look at the _viExecCommand function for more
;                                details
;                   $sCommand - The query to execute (e.g. "*IDN?").
;                                A query MUST contain a QUESTION MARK (?)
;                                The function willautomatically wait for the
;                                instrument's answer (or until the operation
;                                times out)
;                   $iTimeout_ms - The operation timeout in MILISECONDS
;                                This is mostly important for QUERIES only
;                                This is an OPTIONAL PARAMETER.
;                                If it is not specified the last set timeout will
;                                be used. If it was never set before the default
;                                timeout (which depends on the VISA implementation)
;                                will be used. Timeouts can also be set separatelly
;                                with the _viSetTimeout function (see below)
; Return values .: On Success - Returns a STRING containing the answer of the
;                                instrument to the QUERY
;                   On Failure - Returns -1 if the VISA DLL could not be open
;                                Returns -3 if the VISA DLL returned an unexpected
;                                number of results
;                                or returns a NON ZERO value representing the VISA
;                                error code (see the VISA programmer's guide)
;                   This function always sets @error to 1 in case of error
; Author ........: Angel Ezquerra <ezquerra at gmail dot com>
; Notes .........:
;                   Normally you do not need to use this function,
;                   as _viExecCommand automatically choses between _viPrintf and
;                   __viQueryf depending on the command type.
;
;                   If you need to use it anyway, make sure that you use it for
;                   a command that RETURNS an ANSWER or you will be stuck until
;                   the Timeout expires, which could never happen if the Timeout
;                   is infinite ("INF")!
;
;                   Also, this is not really a "SCANF-like" function, as it
;                   does not allow you to specify the format of the output
;
;                   There are two known limitations of this function:
;                   - The GPIB queries only return the 1st line of the device
;                     answer. This is normally not a problem as most devices
;                     always return a single line answer.
;                   - The GPIB queries do not support binary transfer.
;
;                   See _viExecCommand for more details
;
; ===============================================================================================================================
Func __viQueryf($hSession, $sQuery, $iTimeout_ms = -1)
	Local $b_Close_session_before_return = 0 ; By default do not close the session at the end
	If IsString($hSession) Then
		; When we pass a string, i.e. a VISA ID (like GPIB::20::0, for instance) instead
		; of a VISA session handler, we will automatically OPEN and CLOSE the instrument
		; session for the user.
		; This is of course slower if you need to do more than one GPIB call but much
		; more convenient for short tests
		$b_Close_session_before_return = 1
		$hSession = _viOpen($hSession)
	EndIf

	;- Set the VISA timeout if necessary
	If $iTimeout_ms >= 0 Then
		_viSetTimeout($hSession, $iTimeout_ms)
	EndIf

	;- Send QUERY to instrument and get ANSWER
	; errStatus = viQueryf (h_session, "*IDN?\n", "%s", s_answer);
	; signed int viQueryf (unsigned long, char*, char*, char*);
	;errStatus = viQueryf (h_instr, s_command, "%s", string);
	Local $a_Results, $s_Answer = ""
	$a_Results = DllCall("visa32.dll", "int:cdecl", "viQueryf", "int", $hSession, "str", $sQuery, "str", "%t", "str", $s_Answer)
	If @error Then Return SetError(@error, @extended, -1)
	Local $iErrStatus = $a_Results[0]
	If $iErrStatus <> 0 Then
		; Could not query VISA instrument/resource
		Return SetError(1, 0, $iErrStatus)
	EndIf
	; Make sure that the DllCall returned enough values
	If UBound($a_Results) < 5 Then
		; Call to viQuery did not return the right number of values
		Return SetError(1, 0, -3)
	EndIf
	$s_Answer = $a_Results[4]

	If $b_Close_session_before_return = 1 Then
		_viClose($hSession)
	EndIf

	Return $s_Answer
EndFunc   ;==>__viQueryf

; #FUNCTION# ====================================================================================================================
; Author ........: Angel Ezquerra <ezquerra at gmail dot com>
; ===============================================================================================================================
Func _viSetTimeout($hSession, $iTimeoutMS)
	If String($iTimeoutMS) = "INF" Then
		$iTimeoutMS = $VI_TMO_INFINITE
	EndIf
	Return _viSetAttribute($hSession, $VI_ATTR_TMO_VALUE, $iTimeoutMS)
EndFunc   ;==>_viSetTimeout

; #FUNCTION# ====================================================================================================================
; Author ........: Angel Ezquerra <ezquerra at gmail dot com>
; ===============================================================================================================================
Func _viSetAttribute($hSession, $iAttribute, $iValue)
	Local $b_Close_session_before_return = 0 ; By default do not close the session at the end
	If IsString($hSession) Then
		; When we pass a string, i.e. a VISA ID (like GPIB::20::0, for instance) instead
		; of a VISA session handler, we will automatically OPEN and CLOSE the instrument
		; session for the user.
		; This is of course slower if you need to do more than one GPIB call but much
		; more convenient for short tests
		$b_Close_session_before_return = 1
		$hSession = _viOpen($hSession)
	EndIf

	; errStatus = _viSetAttribute ($hSession, $VI_ATTR_TMO_VALUE, $timeout_value);
	; signed int viGpibControlREN (unsigned long, int, int);
	Local $a_Results
	$a_Results = DllCall("visa32.dll", "int", "viSetAttribute", "int", $hSession, "int", $iAttribute, "int", $iValue)
	If @error Then Return SetError(@error, @extended, -1)
	Local $iErrStatus = $a_Results[0]
	If $iErrStatus <> 0 Then
		; Could not set attribute of VISA instrument/resource
		Return SetError(1, 0, $iErrStatus)
	EndIf

	If $b_Close_session_before_return = 1 Then
		_viClose($hSession)
	EndIf

	Return 0
EndFunc   ;==>_viSetAttribute

; #FUNCTION# ====================================================================================================================
; Author ........: Angel Ezquerra <ezquerra at gmail dot com>
; ===============================================================================================================================
Func _viGTL($hSession)
	Return __viGpibControlREN($hSession, $VI_GPIB_REN_ADDRESS_GTL)
EndFunc   ;==>_viGTL

; #FUNCTION# ====================================================================================================================
; Author ........: Angel Ezquerra <ezquerra at gmail dot com>
; ===============================================================================================================================
Func _viGpibBusReset()
	Return __viGpibControlREN("GPIB0::INTFC", $VI_GPIB_REN_DEASSERT)
EndFunc   ;==>_viGpibBusReset

; #INTERNAL_USE_ONLY# ===========================================================================================================
;
; Description ...: Control the VISA REN bus line
; Syntax.........: __viGpibControlREN ( $hSession, $iMode )
; Parameters ....: $hSession - A VISA descriptor (STRING) OR a VISA session
;                   handle (INTEGER). Look the explanation in _viExecCommand
;                   (you can find it above)
;                   $iMode - The mode into which the REN line of the GPIB bus
;                   will be set.
;                   Modes are defined in the VISA library. Look at the top of
;                   this file for valid modes
; Return values .: On Success - Returns 0
;                   On Failure - Returns -1 if the VISA DLL could not be open
;                                or a NON ZERO value representing the VISA
;                                error code (see the VISA programmer's guide)
;                   This function always sets @error to 1 in case of error
; Author ........: Angel Ezquerra <ezquerra at gmail dot com>
; Notes .........: This function is used by _viGTL and _viGpibBusReset
;
; ===============================================================================================================================
Func __viGpibControlREN($hSession, $iMode)
	Local $b_Close_session_before_return = 0 ; By default do not close the session at the end
	If IsString($hSession) Then
		; When we pass a string, i.e. a VISA ID (like GPIB::20::0, for instance) instead
		; of a VISA session handler, we will automatically OPEN and CLOSE the instrument
		; session for the user.
		; This is of course slower if you need to do more than one GPIB call but much
		; more convenient for short tests
		$b_Close_session_before_return = 1
		$hSession = _viOpen($hSession)
	EndIf

	; errStatus = viGpibControlREN ($hSession, VI_GPIB_REN_ASSERT);
	; signed int viGpibControlREN (unsigned long, int);
	Local $a_Results
	$a_Results = DllCall("visa32.dll", "int", "viGpibControlREN", "int", $hSession, "int", $iMode)
	If @error Then Return SetError(@error, @extended, -1)
	Local $iErrStatus = $a_Results[0]
	If $iErrStatus <> 0 Then
		; Could not send to Local VISA instrument/resource
		Return SetError(1, 0, $iErrStatus)
	EndIf

	If $b_Close_session_before_return = 1 Then
		_viClose($hSession)
	EndIf

	Return 0
EndFunc   ;==>__viGpibControlREN

; #FUNCTION# ====================================================================================================================
; Author ........: Angel Ezquerra <ezquerra at gmail dot com>
; ===============================================================================================================================
Func _viInteractiveControl($sCommand_Save_FilePath = "")
	;- Define variables, set their default values
	Local $s_Vi_id = "FIND" ; "GPIB::1::0" ; Default values
	Local $sCommand = "*IDN?"
	Local $iTimeout_ms = 10000 ; ms
	Local $s_Answer = ""
	Local $aDescriptor_list[1], $aIdn_list[1] ; The results of the GPIB search
	; The variables used to save the commands to a file
	Local $s_Empty_command_list = "#include <Visa.au3>" & @CR & @CR & "Local $s_Answer" & @CR & @CR
	Local $s_New_command = ""
	Local $sCommand_list = $s_Empty_command_list

	;- Loop until the user Cancles the Instrument Device Descriptor request
	While 1
		;- Request the Instrument Descriptor (reuse the previous descriptor)
		$s_Vi_id = InputBox("Instrument Device Descriptor", _
				"- Type the Instrument Device Descriptor (e.g. 'GPIB::1::0' or 'GPIB::1::INSTR')" & _
				@CR & @CR & _
				"- Type FIND to perform a GPIB search" & _
				@CR & @CR & _
				"- Click CANCEL to STOP the VISA interactive tool", $s_Vi_id, "", 500, 250)
		If @error = 1 Then
			; The Cancel button was pushed -> Exit the loop
			ExitLoop
		EndIf
		If $s_Vi_id = "FIND" Then
			; Perform a GPIB search
			$sCommand_list = $sCommand_list & _
					"Local $aDescriptor_list[1], $aIdn_list[1]" & @CR & @CR & _
					"_viFindGpib($aDescriptor_list, $aIdn_list, 1)" & @CR & @CR
			_viFindGpib($aDescriptor_list, $aIdn_list, 1)
			If UBound($aDescriptor_list) >= 1 Then
				; If an instrument was found, use the 1st found instrument as the default
				; for the next query
				$s_Vi_id = $aDescriptor_list[0]
			EndIf
			ContinueLoop
		EndIf

		;- Request the command that must be executed (reuse the previous command)
		$s_Answer = InputBox("SCPI command", "Type the SCPI command", $sCommand)
		If @error = 1 Then
			; The Cancel button was pushed -> Restart the process
			ContinueLoop
		EndIf
		$sCommand = $s_Answer ; We got a valid command

		;- Request the timeout (reuse the previous timout)
		$s_Answer = InputBox("Command Timeout (ms)", _
				"Type the command timeout (in milliseconds)", $iTimeout_ms)
		If @error = 1 Then
			; The Cancel button was pushed -> Restart the process
			ContinueLoop
		EndIf
		$iTimeout_ms = 0 + $s_Answer ; We got a valid timeout

		;- Add the command to the command list
		$s_New_command = '$s_Answer = _viExecCommand("' & $s_Vi_id & '", "' & _
				$sCommand & '", ' & $iTimeout_ms & ')'
		$sCommand_list = $sCommand_list & $s_New_command & @CR

		;- Execute the requested command
		$s_Answer = _viExecCommand($s_Vi_id, $sCommand, $iTimeout_ms)

		If IsString($s_Answer) Then
			;- The command was a query and the instrument answered it
			; Show the query results
			MsgBox($MB_SYSTEMMODAL, "Query results", "[" & $s_Vi_id & "] " & $sCommand & " -> " & $s_Answer)
		ElseIf $s_Answer = 0 Then
			;- The command was not a query but it was exuced successfully
			MsgBox($MB_SYSTEMMODAL, "Command result", "The command:" & @CR & @CR & _
					"         '" & $sCommand & "'" & @CR & @CR & _
					"was SUCCESSFULLY executed on the device: " & @CR & @CR & _
					"         '" & $s_Vi_id & "'")
		ElseIf $s_Answer < 0 Then
			;- There was an error -> Show an error message
			$s_Answer = MsgBox($MB_SYSTEMMODAL, "VISA Error", _
					"There was a VISA error when executing the command:" & @CR & @CR & _
					"'" & $sCommand & "'" & @CR & @CR & "on the Device '" & $s_Vi_id & "'" & _
					@CR & @CR & _
					"Do you want to RESET the GPIB bus before continuing?")
			If $s_Answer = 6 Then ; Yes
				_viGpibBusReset()
				MsgBox($MB_SYSTEMMODAL, "VISA", "The GPIB bus was RESET!")
			EndIf
		EndIf
	WEnd

	If $sCommand_list <> $s_Empty_command_list Then
		; If at least one command was issued we might want to save the file

		If $sCommand_Save_FilePath = "" Then
			; The user did not pass an explicit file name in which to save the commands
			; Ask him if he wants to save the m now
			$s_Answer = MsgBox(64 + 4, "Save commands to AutoIt3 script?", _
					"Do you want to save the commands that you issued into an AutoIt3 script?")
			If $s_Answer = 6 Then ; Yes
				$sCommand_Save_FilePath = FileSaveDialog("Save as...", @ScriptDir, _
						"AutoIt3 scripts (*.au3)", 16, "visa_log.au3")
				If @error Then
					$sCommand_Save_FilePath = ""
				EndIf
			EndIf
		EndIf

		If $sCommand_Save_FilePath <> "" Then
			;- Save the SCPI commands into a file
			If FileExists($sCommand_Save_FilePath) Then
				; Delete the save file if it already exists
				FileDelete($sCommand_Save_FilePath)
			EndIf
			FileWrite($sCommand_Save_FilePath, $sCommand_list)
		EndIf
	EndIf

	Return $sCommand_list ; Return the list of executed commands
EndFunc   ;==>_viInteractiveControl
