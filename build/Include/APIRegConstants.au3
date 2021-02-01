#include-once

; #INDEX# =======================================================================================================================
; Title .........: WinAPIReg Constants UDF Library for AutoIt3
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Constants that can be used with UDF library
; Author(s) .....: Yashied, Jpm
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================

; _WinAPI_AssocGetPerceivedType()
Global Const $PERCEIVED_TYPE_CUSTOM = -3
Global Const $PERCEIVED_TYPE_UNSPECIFIED = -2
Global Const $PERCEIVED_TYPE_FOLDER = -1
Global Const $PERCEIVED_TYPE_UNKNOWN = 0
Global Const $PERCEIVED_TYPE_TEXT = 1
Global Const $PERCEIVED_TYPE_IMAGE = 2
Global Const $PERCEIVED_TYPE_AUDIO = 3
Global Const $PERCEIVED_TYPE_VIDEO = 4
Global Const $PERCEIVED_TYPE_COMPRESSED = 5
Global Const $PERCEIVED_TYPE_DOCUMENT = 6
Global Const $PERCEIVED_TYPE_SYSTEM = 7
Global Const $PERCEIVED_TYPE_APPLICATION = 8
Global Const $PERCEIVED_TYPE_GAMEMEDIA = 9
Global Const $PERCEIVED_TYPE_CONTACTS = 10

Global Const $PERCEIVEDFLAG_UNDEFINED = 0x0000
Global Const $PERCEIVEDFLAG_SOFTCODED = 0x0001
Global Const $PERCEIVEDFLAG_HARDCODED = 0x0002
Global Const $PERCEIVEDFLAG_NATIVESUPPORT = 0x0004
Global Const $PERCEIVEDFLAG_GDIPLUS = 0x0010
Global Const $PERCEIVEDFLAG_WMSDK = 0x0020
Global Const $PERCEIVEDFLAG_ZIPFOLDER = 0x0040

; _WinAPI_AssocQueryString()
Global Const $ASSOCSTR_COMMAND = 1
Global Const $ASSOCSTR_EXECUTABLE = 2
Global Const $ASSOCSTR_FRIENDLYDOCNAME = 3
Global Const $ASSOCSTR_FRIENDLYAPPNAME = 4
Global Const $ASSOCSTR_NOOPEN = 5
Global Const $ASSOCSTR_SHELLNEWVALUE = 6
Global Const $ASSOCSTR_DDECOMMAND = 7
Global Const $ASSOCSTR_DDEIFEXEC = 8
Global Const $ASSOCSTR_DDEAPPLICATION = 9
Global Const $ASSOCSTR_DDETOPIC = 10
Global Const $ASSOCSTR_INFOTIP = 11
Global Const $ASSOCSTR_QUICKTIP = 12
Global Const $ASSOCSTR_TILEINFO = 13
Global Const $ASSOCSTR_CONTENTTYPE = 14
Global Const $ASSOCSTR_DEFAULTICON = 15
Global Const $ASSOCSTR_SHELLEXTENSION = 16

Global Const $ASSOCF_INIT_NOREMAPCLSID = 0x00000001
Global Const $ASSOCF_INIT_BYEXENAME = 0x00000002
Global Const $ASSOCF_OPEN_BYEXENAME = 0x00000002
Global Const $ASSOCF_INIT_DEFAULTTOSTAR = 0x00000004
Global Const $ASSOCF_INIT_DEFAULTTOFOLDER = 0x00000008
Global Const $ASSOCF_NOUSERSETTINGS = 0x00000010
Global Const $ASSOCF_NOTRUNCATE = 0x00000020
Global Const $ASSOCF_VERIFY = 0x00000040
Global Const $ASSOCF_REMAPRUNDLL = 0x00000080
Global Const $ASSOCF_NOFIXUPS = 0x00000100
Global Const $ASSOCF_IGNOREBASECLASS = 0x00000200
Global Const $ASSOCF_INIT_IGNOREUNKNOWN = 0x00000400

; _WinAPI_Reg...
Global Const $HKEY_CLASSES_ROOT = 0x80000000
Global Const $HKEY_CURRENT_CONFIG = 0x80000005
Global Const $HKEY_CURRENT_USER = 0x80000001
Global Const $HKEY_LOCAL_MACHINE = 0x80000002
Global Const $HKEY_PERFORMANCE_DATA = 0x80000004
Global Const $HKEY_PERFORMANCE_NLSTEXT = 0x80000060
Global Const $HKEY_PERFORMANCE_TEXT = 0x80000050
Global Const $HKEY_USERS = 0x80000003

Global Const $KEY_CREATE_LINK = 0x0020
Global Const $KEY_CREATE_SUB_KEY = 0x0004
Global Const $KEY_ENUMERATE_SUB_KEYS = 0x0008
Global Const $KEY_NOTIFY = 0x0010
Global Const $KEY_QUERY_VALUE = 0x0001
Global Const $KEY_SET_VALUE = 0x0002
Global Const $KEY_WOW64_32KEY = 0x0200
Global Const $KEY_WOW64_64KEY = 0x0100
Global Const $KEY_READ = 0x00020019 ; BitOR($STANDARD_RIGHTS_READ, $KEY_ENUMERATE_SUB_KEYS, $KEY_NOTIFY, $KEY_QUERY_VALUE)
Global Const $KEY_WRITE = 0x0002006 ; BitOR($STANDARD_RIGHTS_WRITE, $KEY_CREATE_SUB_KEY, $KEY_SET_VALUE)
Global Const $KEY_EXECUTE = $KEY_READ
Global Const $KEY_ALL_ACCESS = 0x000f003f ; BitOR($STANDARD_RIGHTS_REQUIRED, $KEY_CREATE_LINK, $KEY_CREATE_SUB_KEY, $KEY_ENUMERATE_SUB_KEYS, $KEY_NOTIFY, $KEY_QUERY_VALUE, $KEY_SET_VALUE)

Global Const $REG_NOTIFY_CHANGE_NAME = 0x01
Global Const $REG_NOTIFY_CHANGE_ATTRIBUTES = 0x02
Global Const $REG_NOTIFY_CHANGE_LAST_SET = 0x04
Global Const $REG_NOTIFY_CHANGE_SECURITY = 0x08

Global Const $REG_OPTION_BACKUP_RESTORE = 0x04
Global Const $REG_OPTION_CREATE_LINK = 0x02
Global Const $REG_OPTION_NON_VOLATILE = 0x00
Global Const $REG_OPTION_VOLATILE = 0x01
; ===============================================================================================================================
