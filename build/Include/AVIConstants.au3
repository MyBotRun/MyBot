#include-once

; #INDEX# =======================================================================================================================
; Title .........: AVI_Constants
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Constants for <a href="../appendix/GUIStyles.htm#Avi">GUI control AVI styles</a>.
; Author(s) .....: Valik
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; Styles
Global Const $ACS_CENTER = 1
Global Const $ACS_TRANSPARENT = 2
Global Const $ACS_AUTOPLAY = 4
Global Const $ACS_TIMER = 8
Global Const $ACS_NONTRANSPARENT = 16

; Control default styles
Global Const $GUI_SS_DEFAULT_AVI = $ACS_TRANSPARENT

; Messages
Global Const $__AVICONSTANT_WM_USER = 0x400
Global Const $ACM_OPENA = $__AVICONSTANT_WM_USER + 100
Global Const $ACM_PLAY = $__AVICONSTANT_WM_USER + 101
Global Const $ACM_STOP = $__AVICONSTANT_WM_USER + 102
Global Const $ACM_ISPLAYING = $__AVICONSTANT_WM_USER + 104
Global Const $ACM_OPENW = $__AVICONSTANT_WM_USER + 103

; Notifications
Global Const $ACN_START = 0x00000001 ; Notifies the control's parent that the AVI has started playing
Global Const $ACN_STOP = 0x00000002 ; Notifies the control's parent that the AVI has stopped playing
; ===============================================================================================================================
