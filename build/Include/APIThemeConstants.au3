#include-once

; #INDEX# =======================================================================================================================
; Title .........: WinAPITheme Constants UDF Library for AutoIt3
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Constants that can be used with UDF library
; Author(s) .....: Yashied, Jpm
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================

; _WinAPI_BeginBufferedPaint()
Global Const $BPBF_COMPATIBLEBITMAP = 0
Global Const $BPBF_DIB = 1
Global Const $BPBF_TOPDOWNDIB = 2
Global Const $BPBF_TOPDOWNMONODIB = 3

Global Const $BPPF_ERASE = 0x01
Global Const $BPPF_NOCLIP = 0x02
Global Const $BPPF_NONCLIENT = 0x04

; _WinAPI_DrawThemeTextEx()
Global Const $DTT_TEXTCOLOR = 0x00000001
Global Const $DTT_BORDERCOLOR = 0x00000002
Global Const $DTT_SHADOWCOLOR = 0x00000004
Global Const $DTT_SHADOWTYPE = 0x00000008
Global Const $DTT_SHADOWOFFSET = 0x00000010
Global Const $DTT_BORDERSIZE = 0x00000020
Global Const $DTT_FONTPROP = 0x00000040
Global Const $DTT_COLORPROP = 0x00000080
Global Const $DTT_STATEID = 0x00000100
Global Const $DTT_CALCRECT = 0x00000200
Global Const $DTT_APPLYOVERLAY = 0x00000400
Global Const $DTT_GLOWSIZE = 0x00000800
Global Const $DTT_CALLBACK = 0x00001000
Global Const $DTT_COMPOSITED = 0x00002000
Global Const $DTT_VALIDBITS = BitOR($DTT_TEXTCOLOR, $DTT_BORDERCOLOR, $DTT_SHADOWCOLOR, $DTT_SHADOWTYPE, $DTT_SHADOWOFFSET, $DTT_BORDERSIZE, $DTT_FONTPROP, $DTT_COLORPROP, $DTT_STATEID, $DTT_CALCRECT, $DTT_APPLYOVERLAY, $DTT_GLOWSIZE, $DTT_COMPOSITED)

Global Const $TST_NONE = 0
Global Const $TST_SINGLE = 1
Global Const $TST_CONTINUOUS = 2

; _WinAPI_GetThemeAppProperties(), _WinAPI_SetThemeAppProperties()
Global Const $STAP_ALLOW_NONCLIENT = 0x01
Global Const $STAP_ALLOW_CONTROLS = 0x02
Global Const $STAP_ALLOW_WEBCONTENT = 0x04

; _WinAPI_GetThemeBitmap()
Global Const $GBF_DIRECT = 0x01
Global Const $GBF_COPY = 0x02
Global Const $GBF_VALIDBITS = BitOR($GBF_DIRECT, $GBF_COPY)

; _WinAPI_GetThemeDocumentationProperty()
Global Const $SZ_THDOCPROP_AUTHOR = 'Author'
Global Const $SZ_THDOCPROP_CANONICALNAME = 'ThemeName'
Global Const $SZ_THDOCPROP_DISPLAYNAME = 'DisplayName'
Global Const $SZ_THDOCPROP_TOOLTIP = 'ToolTip'

; _WinAPI_GetThemePartSize()
Global Const $TS_MIN = 0
Global Const $TS_TRUE = 1
Global Const $TS_DRAW = 2

; _WinAPI_GetThemePropertyOrigin()
Global Const $PO_CLASS = 2
Global Const $PO_GLOBAL = 3
Global Const $PO_NOTFOUND = 4
Global Const $PO_PART = 1
Global Const $PO_STATE = 0

; _WinAPI_*Theme*()
Global Const $TMT_BOOL = 203
Global Const $TMT_COLOR = 204
Global Const $TMT_DIBDATA = 2
Global Const $TMT_DISKSTREAM = 213
Global Const $TMT_ENUM = 200
Global Const $TMT_FILENAME = 206
Global Const $TMT_FONT = 210
Global Const $TMT_GLYPHDIBDATA = 8
Global Const $TMT_HBITMAP = 212
Global Const $TMT_INT = 202
Global Const $TMT_INTLIST = 211
Global Const $TMT_MARGINS = 205
Global Const $TMT_POSITION = 208
Global Const $TMT_RECT = 209
Global Const $TMT_SIZE = 207
Global Const $TMT_STRING = 201

; *Bool
Global Const $TMT_ALWAYSSHOWSIZINGBAR = 2208
Global Const $TMT_AUTOSIZE = 2202
Global Const $TMT_BGFILL = 2205
Global Const $TMT_BORDERONLY = 2203
Global Const $TMT_COMPOSITED = 2204
Global Const $TMT_COMPOSITEDOPAQUE = 2219
Global Const $TMT_DRAWBORDERS = 2214
Global Const $TMT_FLATMENUS = 1001
Global Const $TMT_GLYPHONLY = 2207
Global Const $TMT_GLYPHTRANSPARENT = 2206
Global Const $TMT_INTEGRALSIZING = 2211
Global Const $TMT_LOCALIZEDMIRRORIMAGE = 2220
Global Const $TMT_MIRRORIMAGE = 2209
Global Const $TMT_NOETCHEDEFFECT = 2215
Global Const $TMT_SOURCEGROW = 2212
Global Const $TMT_SOURCESHRINK = 2213
Global Const $TMT_TEXTAPPLYOVERLAY = 2216
Global Const $TMT_TEXTGLOW = 2217
Global Const $TMT_TEXTITALIC = 2218
Global Const $TMT_TRANSPARENT = 2201
Global Const $TMT_UNIFORMSIZING = 2210
Global Const $TMT_USERPICTURE = 5001

; *Color
Global Const $TMT_ACCENTCOLORHINT = 3823
Global Const $TMT_ACTIVEBORDER = 1611
Global Const $TMT_ACTIVECAPTION = 1603
Global Const $TMT_APPWORKSPACE = 1613
Global Const $TMT_BACKGROUND = 1602
Global Const $TMT_BLENDCOLOR = 5003
Global Const $TMT_BODYTEXTCOLOR = 3827
Global Const $TMT_BORDERCOLOR = 3801
Global Const $TMT_BORDERCOLORHINT = 3822
Global Const $TMT_BTNFACE = 1616
Global Const $TMT_BTNHIGHLIGHT = 1621
Global Const $TMT_BTNSHADOW = 1617
Global Const $TMT_BTNTEXT = 1619
Global Const $TMT_BUTTONALTERNATEFACE = 1626
Global Const $TMT_CAPTIONTEXT = 1610
Global Const $TMT_DKSHADOW3D = 1622
Global Const $TMT_EDGEDKSHADOWCOLOR = 3807
Global Const $TMT_EDGEFILLCOLOR = 3808
Global Const $TMT_EDGEHIGHLIGHTCOLOR = 3805
Global Const $TMT_EDGELIGHTCOLOR = 3804
Global Const $TMT_EDGESHADOWCOLOR = 3806
Global Const $TMT_FILLCOLOR = 3802
Global Const $TMT_FILLCOLORHINT = 3821
Global Const $TMT_FROMCOLOR1 = 2001
Global Const $TMT_FROMCOLOR2 = 2002
Global Const $TMT_FROMCOLOR3 = 2003
Global Const $TMT_FROMCOLOR4 = 2004
Global Const $TMT_FROMCOLOR5 = 2005
Global Const $TMT_GLOWCOLOR = 3816
Global Const $TMT_GLYPHTEXTCOLOR = 3819
Global Const $TMT_GLYPHTRANSPARENTCOLOR = 3820
Global Const $TMT_GRADIENTACTIVECAPTION = 1628
Global Const $TMT_GRADIENTCOLOR1 = 3810
Global Const $TMT_GRADIENTCOLOR2 = 3811
Global Const $TMT_GRADIENTCOLOR3 = 3812
Global Const $TMT_GRADIENTCOLOR4 = 3813
Global Const $TMT_GRADIENTCOLOR5 = 3814
Global Const $TMT_GRADIENTINACTIVECAPTION = 1629
Global Const $TMT_GRAYTEXT = 1618
Global Const $TMT_HEADING1TEXTCOLOR = 3825
Global Const $TMT_HEADING2TEXTCOLOR = 3826
Global Const $TMT_HIGHLIGHT = 1614
Global Const $TMT_HIGHLIGHTTEXT = 1615
Global Const $TMT_HOTTRACKING = 1627
Global Const $TMT_INACTIVEBORDER = 1612
Global Const $TMT_INACTIVECAPTION = 1604
Global Const $TMT_INACTIVECAPTIONTEXT = 1620
Global Const $TMT_INFOBK = 1625
Global Const $TMT_INFOTEXT = 1624
Global Const $TMT_LIGHT3D = 1623
Global Const $TMT_MENU = 1605
Global Const $TMT_MENUBAR = 1631
Global Const $TMT_MENUHILIGHT = 1630
Global Const $TMT_MENUTEXT = 1608
Global Const $TMT_SCROLLBAR = 1601
Global Const $TMT_SHADOWCOLOR = 3815
Global Const $TMT_TEXTBORDERCOLOR = 3817
Global Const $TMT_TEXTCOLOR = 3803
Global Const $TMT_TEXTCOLORHINT = 3824
Global Const $TMT_TEXTSHADOWCOLOR = 3818
Global Const $TMT_TRANSPARENTCOLOR = 3809
Global Const $TMT_WINDOW = 1606
Global Const $TMT_WINDOWFRAME = 1607
Global Const $TMT_WINDOWTEXT = 1609

; *Stream
Global Const $TMT_ATLASIMAGE = 8000

; *Enum
Global Const $TMT_BGTYPE = 4001
Global Const $TMT_BORDERTYPE = 4002
Global Const $TMT_CONTENTALIGNMENT = 4006
Global Const $TMT_FILLTYPE = 4003
Global Const $TMT_GLYPHTYPE = 4012
Global Const $TMT_GLYPHFONTSIZINGTYPE = 4014
Global Const $TMT_HALIGN = 4005
Global Const $TMT_ICONEFFECT = 4009
Global Const $TMT_IMAGELAYOUT = 4011
Global Const $TMT_IMAGESELECTTYPE = 4013
Global Const $TMT_OFFSETTYPE = 4008
Global Const $TMT_SIZINGTYPE = 4004
Global Const $TMT_TEXTSHADOWTYPE = 4010
Global Const $TMT_TRUESIZESCALINGTYPE = 4015
Global Const $TMT_VALIGN = 4007

; *Filename
Global Const $TMT_GLYPHIMAGEFILE = 3008
Global Const $TMT_IMAGEFILE = 3001
Global Const $TMT_IMAGEFILE1 = 3002
Global Const $TMT_IMAGEFILE2 = 3003
Global Const $TMT_IMAGEFILE3 = 3004
Global Const $TMT_IMAGEFILE4 = 3005
Global Const $TMT_IMAGEFILE5 = 3006
Global Const $TMT_SCALEDBACKGROUND = 7001

; *Font
Global Const $TMT_BODYFONT = 809
Global Const $TMT_CAPTIONFONT = 801
Global Const $TMT_GLYPHFONT = 2601
Global Const $TMT_HEADING1FONT = 807
Global Const $TMT_HEADING2FONT = 808
Global Const $TMT_ICONTITLEFONT = 806
Global Const $TMT_MENUFONT = 803
Global Const $TMT_MSGBOXFONT = 805
Global Const $TMT_SMALLCAPTIONFONT = 802
Global Const $TMT_STATUSFONT = 804

; *Int
Global Const $TMT_ALPHALEVEL = 2402
Global Const $TMT_ALPHATHRESHOLD = 2415
Global Const $TMT_ANIMATIONDELAY = 2428
Global Const $TMT_ANIMATIONDURATION = 5006
Global Const $TMT_BORDERSIZE = 2403
Global Const $TMT_CHARSET = 403
Global Const $TMT_COLORIZATIONCOLOR = 2431
Global Const $TMT_COLORIZATIONOPACITY = 2432
Global Const $TMT_FRAMESPERSECOND = 2426
Global Const $TMT_FROMHUE1 = 1801
Global Const $TMT_FROMHUE2 = 1802
Global Const $TMT_FROMHUE3 = 1803
Global Const $TMT_FROMHUE4 = 1804
Global Const $TMT_FROMHUE5 = 1805
Global Const $TMT_GLOWINTENSITY = 2429
Global Const $TMT_GLYPHINDEX = 2418
Global Const $TMT_GRADIENTRATIO1 = 2406
Global Const $TMT_GRADIENTRATIO2 = 2407
Global Const $TMT_GRADIENTRATIO3 = 2408
Global Const $TMT_GRADIENTRATIO4 = 2409
Global Const $TMT_GRADIENTRATIO5 = 2410
Global Const $TMT_HEIGHT = 2417
Global Const $TMT_IMAGECOUNT = 2401
Global Const $TMT_MINCOLORDEPTH = 1301
Global Const $TMT_MINDPI1 = 2420
Global Const $TMT_MINDPI2 = 2421
Global Const $TMT_MINDPI3 = 2422
Global Const $TMT_MINDPI4 = 2423
Global Const $TMT_MINDPI5 = 2424
Global Const $TMT_OPACITY = 2430
Global Const $TMT_PIXELSPERFRAME = 2427
Global Const $TMT_PROGRESSCHUNKSIZE = 2411
Global Const $TMT_PROGRESSSPACESIZE = 2412
Global Const $TMT_ROUNDCORNERHEIGHT = 2405
Global Const $TMT_ROUNDCORNERWIDTH = 2404
Global Const $TMT_SATURATION = 2413
Global Const $TMT_TEXTBORDERSIZE = 2414
Global Const $TMT_TEXTGLOWSIZE = 2425
Global Const $TMT_TOCOLOR1 = 2006
Global Const $TMT_TOCOLOR2 = 2007
Global Const $TMT_TOCOLOR3 = 2008
Global Const $TMT_TOCOLOR4 = 2009
Global Const $TMT_TOCOLOR5 = 2010
Global Const $TMT_TOHUE1 = 1806
Global Const $TMT_TOHUE2 = 1807
Global Const $TMT_TOHUE3 = 1808
Global Const $TMT_TOHUE4 = 1809
Global Const $TMT_TOHUE5 = 1810
Global Const $TMT_TRUESIZESTRETCHMARK = 2419
Global Const $TMT_WIDTH = 2416

; *IntList
Global Const $TMT_TRANSITIONDURATIONS = 6000

; *Margins
Global Const $TMT_CAPTIONMARGINS = 3603
Global Const $TMT_CONTENTMARGINS = 3602
Global Const $TMT_SIZINGMARGINS = 3601

; *Position
Global Const $TMT_MINSIZE = 3403
Global Const $TMT_MINSIZE1 = 3404
Global Const $TMT_MINSIZE2 = 3405
Global Const $TMT_MINSIZE3 = 3406
Global Const $TMT_MINSIZE4 = 3407
Global Const $TMT_MINSIZE5 = 3408
Global Const $TMT_NORMALSIZE = 3409
Global Const $TMT_OFFSET = 3401
Global Const $TMT_TEXTSHADOWOFFSET = 3402

; *Rect
Global Const $TMT_ANIMATIONBUTTONRECT = 5005
Global Const $TMT_ATLASRECT = 8002
Global Const $TMT_CUSTOMSPLITRECT = 5004
Global Const $TMT_DEFAULTPANESIZE = 5002

; *Size
Global Const $TMT_CAPTIONBARHEIGHT = 1205
Global Const $TMT_CAPTIONBARWIDTH = 1204
Global Const $TMT_MENUBARHEIGHT = 1209
Global Const $TMT_MENUBARWIDTH = 1208
Global Const $TMT_PADDEDBORDERWIDTH = 1210
Global Const $TMT_SCROLLBARHEIGHT = 1203
Global Const $TMT_SCROLLBARWIDTH = 1202
Global Const $TMT_SIZINGBORDERWIDTH = 1201
Global Const $TMT_SMCAPTIONBARHEIGHT = 1207
Global Const $TMT_SMCAPTIONBARWIDTH = 1206

; *String
Global Const $TMT_ALIAS = 1404
Global Const $TMT_ATLASINPUTIMAGE = 8001
Global Const $TMT_AUTHOR = 604
Global Const $TMT_CLASSICVALUE = 3202
Global Const $TMT_COLORSCHEMES = 401
Global Const $TMT_COMPANY = 603
Global Const $TMT_COPYRIGHT = 605
Global Const $TMT_CSSNAME = 1401
Global Const $TMT_DESCRIPTION = 608
Global Const $TMT_DISPLAYNAME = 601
Global Const $TMT_LASTUPDATED = 1403
Global Const $TMT_SIZES = 402
Global Const $TMT_TEXT = 3201
Global Const $TMT_TOOLTIP = 602
Global Const $TMT_URL = 606
Global Const $TMT_VERSION = 607
Global Const $TMT_XMLNAME = 1402
Global Const $TMT_NAME = 600
; ===============================================================================================================================
