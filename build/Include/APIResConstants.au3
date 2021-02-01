#include-once

; #INDEX# =======================================================================================================================
; Title .........: WinAPIRes Constants UDF Library for AutoIt3
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Constants that can be used with UDF library
; Author(s) .....: Yashied, Jpm
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================

; _WinAPI_FindResource(), _WinAPI_FindResourceEx(), _WinAPI_UpdateResource()
Global Const $RT_ACCELERATOR = 9
Global Const $RT_ANICURSOR = 21
Global Const $RT_ANIICON = 22
Global Const $RT_BITMAP = 2
Global Const $RT_CURSOR = 1
Global Const $RT_DIALOG = 5
Global Const $RT_DLGINCLUDE = 17
Global Const $RT_FONT = 8
Global Const $RT_FONTDIR = 7
Global Const $RT_GROUP_CURSOR = 12
Global Const $RT_GROUP_ICON = 14
Global Const $RT_HTML = 23
Global Const $RT_ICON = 3
Global Const $RT_MANIFEST = 24
Global Const $RT_MENU = 4
Global Const $RT_MESSAGETABLE = 11
Global Const $RT_PLUGPLAY = 19
Global Const $RT_RCDATA = 10
Global Const $RT_STRING = 6
Global Const $RT_VERSION = 16
Global Const $RT_VXD = 20

; _WinAPI_GetFileVersionInfo()
Global Const $FILE_VER_GET_LOCALISED = 0x01
Global Const $FILE_VER_GET_NEUTRAL = 0x02
Global Const $FILE_VER_GET_PREFETCHED = 0x04

; _WinAPI_SetSystemCursor()
Global Const $OCR_NORMAL = 32512
Global Const $OCR_IBEAM = 32513
Global Const $OCR_WAIT = 32514
Global Const $OCR_CROSS = 32515
Global Const $OCR_UP = 32516
Global Const $OCR_SIZE = 32640
Global Const $OCR_ICON = 32641
Global Const $OCR_SIZENWSE = 32642
Global Const $OCR_SIZENESW = 32643
Global Const $OCR_SIZEWE = 32644
Global Const $OCR_SIZENS = 32645
Global Const $OCR_SIZEALL = 32646
Global Const $OCR_ICOCUR = 32647
Global Const $OCR_NO = 32648
Global Const $OCR_HAND = 32649
Global Const $OCR_APPSTARTING = 32650
Global Const $OCR_HELP = 32651

; _WinAPI_VerQueryRoot()
Global Const $VS_FF_DEBUG = 0x00000001
Global Const $VS_FF_INFOINFERRED = 0x00000010
Global Const $VS_FF_PATCHED = 0x00000004
Global Const $VS_FF_PRERELEASE = 0x00000002
Global Const $VS_FF_PRIVATEBUILD = 0x00000008
Global Const $VS_FF_SPECIALBUILD = 0x00000020

Global Const $VOS_DOS = 0x00010000
Global Const $VOS_NT = 0x00040000
Global Const $VOS__WINDOWS16 = 0x00000001
Global Const $VOS__WINDOWS32 = 0x00000004
Global Const $VOS_OS216 = 0x00020000
Global Const $VOS_OS232 = 0x00030000
Global Const $VOS__PM16 = 0x00000002
Global Const $VOS__PM32 = 0x00000003
Global Const $VOS_UNKNOWN = 0x00000000

Global Const $VOS_DOS_WINDOWS16 = 0x00010001
Global Const $VOS_DOS_WINDOWS32 = 0x00010004
Global Const $VOS_NT_WINDOWS32 = 0x00040004
Global Const $VOS_OS216_PM16 = 0x00020002
Global Const $VOS_OS232_PM32 = 0x00030003

Global Const $VFT_APP = 0x00000001
Global Const $VFT_DLL = 0x00000002
Global Const $VFT_DRV = 0x00000003
Global Const $VFT_FONT = 0x00000004
Global Const $VFT_STATIC_LIB = 0x00000007
Global Const $VFT_UNKNOWN = 0x00000000
Global Const $VFT_VXD = 0x00000005

Global Const $VFT2_DRV_COMM = 0x0000000A
Global Const $VFT2_DRV_DISPLAY = 0x00000004
Global Const $VFT2_DRV_INSTALLABLE = 0x00000008
Global Const $VFT2_DRV_KEYBOARD = 0x00000002
Global Const $VFT2_DRV_LANGUAGE = 0x00000003
Global Const $VFT2_DRV_MOUSE = 0x00000005
Global Const $VFT2_DRV_NETWORK = 0x00000006
Global Const $VFT2_DRV_PRINTER = 0x00000001
Global Const $VFT2_DRV_SOUND = 0x00000009
Global Const $VFT2_DRV_SYSTEM = 0x00000007
Global Const $VFT2_DRV_VERSIONED_PRINTER = 0x0000000C
Global Const $VFT2_UNKNOWN = 0x00000000

Global Const $VFT2_FONT_RASTER = 0x00000001
Global Const $VFT2_FONT_TRUETYPE = 0x00000003
Global Const $VFT2_FONT_VECTOR = 0x00000002
; Global Const $VFT2_UNKNOWN = 0x00000000
; ===============================================================================================================================
