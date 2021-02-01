#include-once

; #INDEX# =======================================================================================================================
; Title .........: API Constants UDF Library for AutoIt3
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Constants that can be used with UDF library
; Author(s) .....: Yashied, Jpm
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================

Global Const $HGDI_ERROR = Ptr(-1)
Global Const $INVALID_HANDLE_VALUE = Ptr(-1)
Global Const $CLR_INVALID = -1

; Stock Object Constants
Global Const $NULL_BRUSH = 5 ; Null brush (equivalent to HOLLOW_BRUSH)
Global Const $NULL_PEN = 8 ; NULL pen. The null pen draws nothing
Global Const $BLACK_BRUSH = 4 ; Black brush
Global Const $DKGRAY_BRUSH = 3 ; Dark gray brush
Global Const $DC_BRUSH = 18 ; Solid color brush. The default color is white
Global Const $GRAY_BRUSH = 2 ; Gray brush
Global Const $HOLLOW_BRUSH = $NULL_BRUSH ; Hollow brush (equivalent to NULL_BRUSH)
Global Const $LTGRAY_BRUSH = 1 ; Light gray brush
Global Const $WHITE_BRUSH = 0 ; White brush
Global Const $BLACK_PEN = 7 ; Black pen
Global Const $DC_PEN = 19 ; Solid pen color. The default color is white
Global Const $WHITE_PEN = 6 ; White pen
Global Const $ANSI_FIXED_FONT = 11 ; Windows fixed-pitch (monospace) system font
Global Const $ANSI_VAR_FONT = 12 ; Windows variable-pitch (proportional space) system font
Global Const $DEVICE_DEFAULT_FONT = 14 ; Windows Device-dependent font
Global Const $DEFAULT_GUI_FONT = 17 ; Default font for user interface objects such as menus and dialog boxes
Global Const $OEM_FIXED_FONT = 10 ; Original equipment manufacturer (OEM) dependent fixed-pitch (monospace) font
Global Const $SYSTEM_FONT = 13 ; System font. By default, the system uses the system font to draw menus, dialog box controls, and text
Global Const $SYSTEM_FIXED_FONT = 16 ; Fixed-pitch (monospace) system font. This stock object is provided only for compatibility with 16-bit Windows versions earlier than 3.0
Global Const $DEFAULT_PALETTE = 15 ; Default palette. This palette consists of the static colors in the system palette

; conversion type
Global Const $MB_PRECOMPOSED = 0x01
Global Const $MB_COMPOSITE = 0x02
Global Const $MB_USEGLYPHCHARS = 0x04

; translucency flags
Global Const $ULW_ALPHA = 0x02
Global Const $ULW_COLORKEY = 0x01
Global Const $ULW_OPAQUE = 0x04

Global Const $ULW_EX_NORESIZE = 0x08

; Window Hooks
Global Const $WH_CALLWNDPROC = 4
Global Const $WH_CALLWNDPROCRET = 12
Global Const $WH_CBT = 5
Global Const $WH_DEBUG = 9
Global Const $WH_FOREGROUNDIDLE = 11
Global Const $WH_GETMESSAGE = 3
Global Const $WH_JOURNALPLAYBACK = 1
Global Const $WH_JOURNALRECORD = 0
Global Const $WH_KEYBOARD = 2
Global Const $WH_KEYBOARD_LL = 13
Global Const $WH_MOUSE = 7
Global Const $WH_MOUSE_LL = 14
Global Const $WH_MSGFILTER = -1
Global Const $WH_SHELL = 10
Global Const $WH_SYSMSGFILTER = 6

; Window Placement
Global Const $WPF_ASYNCWINDOWPLACEMENT = 0x04
Global Const $WPF_RESTORETOMAXIMIZED = 0x02
Global Const $WPF_SETMINPOSITION = 0x01

; flags for $tagKBDLLHOOKSTRUCT
Global Const $KF_EXTENDED = 0x0100
Global Const $KF_ALTDOWN = 0x2000
Global Const $KF_UP = 0x8000
Global Const $LLKHF_EXTENDED = BitShift($KF_EXTENDED, 8)
Global Const $LLKHF_INJECTED = 0x10
Global Const $LLKHF_ALTDOWN = BitShift($KF_ALTDOWN, 8)
Global Const $LLKHF_UP = BitShift($KF_UP, 8)

; flags for $tagOPENFILENAME
Global Const $OFN_ALLOWMULTISELECT = 0x00000200
Global Const $OFN_CREATEPROMPT = 0x00002000
Global Const $OFN_DONTADDTORECENT = 0x02000000
Global Const $OFN_ENABLEHOOK = 0x00000020
Global Const $OFN_ENABLEINCLUDENOTIFY = 0x00400000
Global Const $OFN_ENABLESIZING = 0x00800000
Global Const $OFN_ENABLETEMPLATE = 0x00000040
Global Const $OFN_ENABLETEMPLATEHANDLE = 0x00000080
Global Const $OFN_EXPLORER = 0x00080000
Global Const $OFN_EXTENSIONDIFFERENT = 0x00000400
Global Const $OFN_FILEMUSTEXIST = 0x00001000
Global Const $OFN_FORCESHOWHIDDEN = 0x10000000
Global Const $OFN_HIDEREADONLY = 0x00000004
Global Const $OFN_LONGNAMES = 0x00200000
Global Const $OFN_NOCHANGEDIR = 0x00000008
Global Const $OFN_NODEREFERENCELINKS = 0x00100000
Global Const $OFN_NOLONGNAMES = 0x00040000
Global Const $OFN_NONETWORKBUTTON = 0x00020000
Global Const $OFN_NOREADONLYRETURN = 0x00008000
Global Const $OFN_NOTESTFILECREATE = 0x00010000
Global Const $OFN_NOVALIDATE = 0x00000100
Global Const $OFN_OVERWRITEPROMPT = 0x00000002
Global Const $OFN_PATHMUSTEXIST = 0x00000800
Global Const $OFN_READONLY = 0x00000001
Global Const $OFN_SHAREAWARE = 0x00004000
Global Const $OFN_SHOWHELP = 0x00000010
Global Const $OFN_EX_NOPLACESBAR = 0x00000001

; GetTextMetrics flags
Global Const $TMPF_FIXED_PITCH = 0x01
Global Const $TMPF_VECTOR = 0x02
Global Const $TMPF_TRUETYPE = 0x04
Global Const $TMPF_DEVICE = 0x08

; DuplicateHandle options
Global Const $DUPLICATE_CLOSE_SOURCE = 0x00000001
Global Const $DUPLICATE_SAME_ACCESS = 0x00000002

; DrawIconEx Constants
Global Const $DI_MASK = 0x0001
Global Const $DI_IMAGE = 0x0002
Global Const $DI_NORMAL = 0x0003
Global Const $DI_COMPAT = 0x0004
Global Const $DI_DEFAULTSIZE = 0x0008
Global Const $DI_NOMIRROR = 0x0010

; EnumDisplayDevice Constants
Global Const $DISPLAY_DEVICE_ATTACHED_TO_DESKTOP = 0x00000001
Global Const $DISPLAY_DEVICE_MULTI_DRIVER = 0x00000002
Global Const $DISPLAY_DEVICE_PRIMARY_DEVICE = 0x00000004
Global Const $DISPLAY_DEVICE_MIRRORING_DRIVER = 0x00000008
Global Const $DISPLAY_DEVICE_VGA_COMPATIBLE = 0x00000010
Global Const $DISPLAY_DEVICE_REMOVABLE = 0x00000020
Global Const $DISPLAY_DEVICE_DISCONNECT = 0x02000000
Global Const $DISPLAY_DEVICE_REMOTE = 0x04000000
Global Const $DISPLAY_DEVICE_MODESPRUNED = 0x08000000

; FlashWindowEx Constants
Global Const $FLASHW_CAPTION = 0x00000001
Global Const $FLASHW_TRAY = 0x00000002
Global Const $FLASHW_TIMER = 0x00000004
Global Const $FLASHW_TIMERNOFG = 0x0000000C

; FormatMessage Constants
Global Const $FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00000100
Global Const $FORMAT_MESSAGE_IGNORE_INSERTS = 0x00000200
Global Const $FORMAT_MESSAGE_FROM_STRING = 0x00000400
Global Const $FORMAT_MESSAGE_FROM_HMODULE = 0x00000800
Global Const $FORMAT_MESSAGE_FROM_SYSTEM = 0x00001000
Global Const $FORMAT_MESSAGE_ARGUMENT_ARRAY = 0x00002000

; GetWindows Constants
Global Const $GW_HWNDFIRST = 0
Global Const $GW_HWNDLAST = 1
Global Const $GW_HWNDNEXT = 2
Global Const $GW_HWNDPREV = 3
Global Const $GW_OWNER = 4
Global Const $GW_CHILD = 5
Global Const $GW_ENABLEDPOPUP = 6

; GetWindowLong Constants
Global Const $GWL_WNDPROC = 0xFFFFFFFC
Global Const $GWL_HINSTANCE = 0xFFFFFFFA
Global Const $GWL_HWNDPARENT = 0xFFFFFFF8
Global Const $GWL_ID = 0xFFFFFFF4
Global Const $GWL_STYLE = 0xFFFFFFF0
Global Const $GWL_EXSTYLE = 0xFFFFFFEC
Global Const $GWL_USERDATA = 0xFFFFFFEB

; Standard Icon Index Constants
Global Const $STD_CUT = 0
Global Const $STD_COPY = 1
Global Const $STD_PASTE = 2
Global Const $STD_UNDO = 3
Global Const $STD_REDOW = 4
Global Const $STD_DELETE = 5
Global Const $STD_FILENEW = 6
Global Const $STD_FILEOPEN = 7
Global Const $STD_FILESAVE = 8
Global Const $STD_PRINTPRE = 9
Global Const $STD_PROPERTIES = 10
Global Const $STD_HELP = 11
Global Const $STD_FIND = 12
Global Const $STD_REPLACE = 13
Global Const $STD_PRINT = 14

; Image Type Constants
Global Const $IMAGE_BITMAP = 0
Global Const $IMAGE_ICON = 1
Global Const $IMAGE_CURSOR = 2
Global Const $IMAGE_ENHMETAFILE = 3

; Keyboard Constants
; Changes how keys are processed
Global Const $KB_SENDSPECIAL = 0 ; Special characters indicate key presses (default)
Global Const $KB_SENDRAW = 1 ; Keys are sent raw

; Sets the state of the Caps Lock key
Global Const $KB_CAPSOFF = 0 ; Caps Lock is off
Global Const $KB_CAPSON = 1 ; Caps Lock is on

; LoadLibraryEx Constants
Global Const $DONT_RESOLVE_DLL_REFERENCES = 0x01
Global Const $LOAD_LIBRARY_AS_DATAFILE = 0x02
Global Const $LOAD_WITH_ALTERED_SEARCH_PATH = 0x08
Global Const $LOAD_IGNORE_CODE_AUTHZ_LEVEL = 0x00000010
Global Const $LOAD_LIBRARY_AS_DATAFILE_EXCLUSIVE = 0x00000040
Global Const $LOAD_LIBRARY_AS_IMAGE_RESOURCE = 0x00000020
Global Const $LOAD_LIBRARY_SEARCH_APPLICATION_DIR = 0x00000200
Global Const $LOAD_LIBRARY_SEARCH_DEFAULT_DIRS = 0x00001000
Global Const $LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR = 0x00000100
Global Const $LOAD_LIBRARY_SEARCH_SYSTEM32 = 0x00000800
Global Const $LOAD_LIBRARY_SEARCH_USER_DIRS = 0x00000400

; Common HRESULT errors
Global Const $S_OK = 0x00000000
Global Const $E_ABORT = 0x80004004
Global Const $E_ACCESSDENIED = 0x80070005
Global Const $E_FAIL = 0x80004005
Global Const $E_HANDLE = 0x80070006
Global Const $E_INVALIDARG = 0x80070057
Global Const $E_NOINTERFACE = 0x80004002
Global Const $E_NOTIMPL = 0x80004001
Global Const $E_OUTOFMEMORY = 0x8007000E
Global Const $E_POINTER = 0x80004003
Global Const $E_UNEXPECTED = 0x8000FFFF

; DEVMODE structure
; in APIGdiConstants.au3

; _WinAPI_LoadImage(), _WinAPI_CopyImage()
Global Const $LR_DEFAULTCOLOR = 0x0000
Global Const $LR_MONOCHROME = 0x0001
Global Const $LR_COLOR = 0x0002
Global Const $LR_COPYRETURNORG = 0x0004
Global Const $LR_COPYDELETEORG = 0x0008
Global Const $LR_LOADFROMFILE = 0x0010
Global Const $LR_LOADTRANSPARENT = 0x0020
Global Const $LR_DEFAULTSIZE = 0x0040
Global Const $LR_VGACOLOR = 0x0080
Global Const $LR_LOADMAP3DCOLORS = 0x1000
Global Const $LR_CREATEDIBSECTION = 0x2000
Global Const $LR_COPYFROMRESOURCE = 0x4000
Global Const $LR_SHARED = 0x8000

; _WinAPI_LoadImage()
Global Const $OBM_TRTYPE = 32732
Global Const $OBM_LFARROWI = 32734
Global Const $OBM_RGARROWI = 32735
Global Const $OBM_DNARROWI = 32736
Global Const $OBM_UPARROWI = 32737
Global Const $OBM_COMBO = 32738
Global Const $OBM_MNARROW = 32739
Global Const $OBM_LFARROWD = 32740
Global Const $OBM_RGARROWD = 32741
Global Const $OBM_DNARROWD = 32742
Global Const $OBM_UPARROWD = 32743
Global Const $OBM_RESTORED = 32744
Global Const $OBM_ZOOMD = 32745
Global Const $OBM_REDUCED = 32746
Global Const $OBM_RESTORE = 32747
Global Const $OBM_ZOOM = 32748
Global Const $OBM_REDUCE = 32749
Global Const $OBM_LFARROW = 32750
Global Const $OBM_RGARROW = 32751
Global Const $OBM_DNARROW = 32752
Global Const $OBM_UPARROW = 32753
Global Const $OBM_CLOSE = 32754
Global Const $OBM_OLD_RESTORE = 32755
Global Const $OBM_OLD_ZOOM = 32756
Global Const $OBM_OLD_REDUCE = 32757
Global Const $OBM_BTNCORNERS = 32758
Global Const $OBM_CHECKBOXES = 32759
Global Const $OBM_CHECK = 32760
Global Const $OBM_BTSIZE = 32761
Global Const $OBM_OLD_LFARROW = 32762
Global Const $OBM_OLD_RGARROW = 32763
Global Const $OBM_OLD_DNARROW = 32764
Global Const $OBM_OLD_UPARROW = 32765
Global Const $OBM_SIZE = 32766
Global Const $OBM_OLD_CLOSE = 32767

Global Const $OIC_SAMPLE = 32512
Global Const $OIC_HAND = 32513
Global Const $OIC_QUES = 32514
Global Const $OIC_BANG = 32515
Global Const $OIC_NOTE = 32516
Global Const $OIC_WINLOGO = 32517
Global Const $OIC_WARNING = $OIC_BANG
Global Const $OIC_ERROR = $OIC_HAND
Global Const $OIC_INFORMATION = $OIC_NOTE
; ===============================================================================================================================
