#include-once

; #INDEX# =======================================================================================================================
; Title .........: WinAPIDiag Constants UDF Library for AutoIt3
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Constants that can be used with UDF library
; Author(s) .....: Yashied, Jpm
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================

; _WinAPI_EnumDllProc()
Global Const $SYMOPT_ALLOW_ABSOLUTE_SYMBOLS = 0x00000800
Global Const $SYMOPT_ALLOW_ZERO_ADDRESS = 0x01000000
Global Const $SYMOPT_AUTO_PUBLICS = 0x00010000
Global Const $SYMOPT_CASE_INSENSITIVE = 0x00000001
Global Const $SYMOPT_DEBUG = 0x80000000
Global Const $SYMOPT_DEFERRED_LOADS = 0x00000004
Global Const $SYMOPT_DISABLE_SYMSRV_AUTODETECT = 0x02000000
Global Const $SYMOPT_EXACT_SYMBOLS = 0x00000400
Global Const $SYMOPT_FAIL_CRITICAL_ERRORS = 0x00000200
Global Const $SYMOPT_FAVOR_COMPRESSED = 0x00800000
Global Const $SYMOPT_FLAT_DIRECTORY = 0x00400000
Global Const $SYMOPT_IGNORE_CVREC = 0x00000080
Global Const $SYMOPT_IGNORE_IMAGEDIR = 0x00200000
Global Const $SYMOPT_IGNORE_NT_SYMPATH = 0x00001000
Global Const $SYMOPT_INCLUDE_32BIT_MODULES = 0x00002000
Global Const $SYMOPT_LOAD_ANYTHING = 0x00000040
Global Const $SYMOPT_LOAD_LINES = 0x00000010
Global Const $SYMOPT_NO_CPP = 0x00000008
Global Const $SYMOPT_NO_IMAGE_SEARCH = 0x00020000
Global Const $SYMOPT_NO_PROMPTS = 0x00080000
Global Const $SYMOPT_NO_PUBLICS = 0x00008000
Global Const $SYMOPT_NO_UNQUALIFIED_LOADS = 0x00000100
Global Const $SYMOPT_OVERWRITE = 0x00100000
Global Const $SYMOPT_PUBLICS_ONLY = 0x00004000
Global Const $SYMOPT_SECURE = 0x00040000
Global Const $SYMOPT_UNDNAME = 0x00000002

; _WinAPI_GetErrorMode(), _WinAPI_SetErrorMode()
Global Const $SEM_FAILCRITICALERRORS = 0x0001
Global Const $SEM_NOALIGNMENTFAULTEXCEPT = 0x0004
Global Const $SEM_NOGPFAULTERRORBOX = 0x0002
Global Const $SEM_NOOPENFILEERRORBOX = 0x8000

; _WinAPI_IsNetworkAlive()
Global Const $NETWORK_ALIVE_LAN = 0x01
Global Const $NETWORK_ALIVE_WAN = 0x02
Global Const $NETWORK_ALIVE_AOL = 0x04

; _WinAPI_RegisterApplicationRestart()
Global Const $RESTART_NO_CRASH = 0x01
Global Const $RESTART_NO_HANG = 0x02
Global Const $RESTART_NO_PATCH = 0x04
Global Const $RESTART_NO_REBOOT = 0x08

; _WinAPI_UniqueHardwareID()
Global Const $UHID_MB = 0x00
Global Const $UHID_BIOS = 0x01
Global Const $UHID_CPU = 0x02
Global Const $UHID_HDD = 0x04
Global Const $UHID_All = BitOR($UHID_MB, $UHID_BIOS, $UHID_CPU, $UHID_HDD)
; ===============================================================================================================================
