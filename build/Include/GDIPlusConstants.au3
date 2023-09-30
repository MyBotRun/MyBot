#include-once

; #INDEX# =======================================================================================================================
; Title .........: GDIPlus_Constants
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Constants for GDI+
; Author(s) .....: Valik, Gary Frost, UEZ
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
; Pen Dash Cap Types
Global Const $GDIP_DASHCAPFLAT = 0 ; A square cap that squares off both ends of each dash
Global Const $GDIP_DASHCAPROUND = 2 ; A circular cap that rounds off both ends of each dash
Global Const $GDIP_DASHCAPTRIANGLE = 3 ; A triangular cap that points both ends of each dash

; Pen Dash Style Types
Global Const $GDIP_DASHSTYLESOLID = 0 ; A solid line
Global Const $GDIP_DASHSTYLEDASH = 1 ; A dashed line
Global Const $GDIP_DASHSTYLEDOT = 2 ; A dotted line
Global Const $GDIP_DASHSTYLEDASHDOT = 3 ; An alternating dash-dot line
Global Const $GDIP_DASHSTYLEDASHDOTDOT = 4 ; An alternating dash-dot-dot line
Global Const $GDIP_DASHSTYLECUSTOM = 5 ; A a user-defined, custom dashed line

; Encoder Parameter GUIDs
Global Const $GDIP_EPGCHROMINANCETABLE = '{F2E455DC-09B3-4316-8260-676ADA32481C}'
Global Const $GDIP_EPGCOLORDEPTH = '{66087055-AD66-4C7C-9A18-38A2310B8337}'
Global Const $GDIP_EPGCOMPRESSION = '{E09D739D-CCD4-44EE-8EBA-3FBF8BE4FC58}'
Global Const $GDIP_EPGLUMINANCETABLE = '{EDB33BCE-0266-4A77-B904-27216099E717}'
Global Const $GDIP_EPGQUALITY = '{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}'
Global Const $GDIP_EPGRENDERMETHOD = '{6D42C53A-229A-4825-8BB7-5C99E2B9A8B8}'
Global Const $GDIP_EPGSAVEFLAG = '{292266FC-AC40-47BF-8CFC-A85B89A655DE}'
Global Const $GDIP_EPGSCANMETHOD = '{3A4E2661-3109-4E56-8536-42C156E7DCFA}'
Global Const $GDIP_EPGTRANSFORMATION = '{8D0EB2D1-A58E-4EA8-AA14-108074B7B6F9}'
Global Const $GDIP_EPGVERSION = '{24D18C76-814A-41A4-BF53-1C219CCCF797}'

; Encoder Parameter Types
Global Const $GDIP_EPTBYTE = 1 ; 8 bit unsigned integer
Global Const $GDIP_EPTASCII = 2 ; Null terminated character string
Global Const $GDIP_EPTSHORT = 3 ; 16 bit unsigned integer
Global Const $GDIP_EPTLONG = 4 ; 32 bit unsigned integer
Global Const $GDIP_EPTRATIONAL = 5 ; Two longs (numerator, denomintor)
Global Const $GDIP_EPTLONGRANGE = 6 ; Two longs (low, high)
Global Const $GDIP_EPTUNDEFINED = 7 ; Array of bytes of any type
Global Const $GDIP_EPTRATIONALRANGE = 8 ; Two ratationals (low, high)

; GDI Error Codes
Global Const $GDIP_ERROK = 0 ; Method call was successful
Global Const $GDIP_ERRGENERICERROR = 1 ; Generic method call error
Global Const $GDIP_ERRINVALIDPARAMETER = 2 ; One of the arguments passed to the method was not valid
Global Const $GDIP_ERROUTOFMEMORY = 3 ; The operating system is out of memory
Global Const $GDIP_ERROBJECTBUSY = 4 ; One of the arguments in the call is already in use
Global Const $GDIP_ERRINSUFFICIENTBUFFER = 5 ; A buffer is not large enough
Global Const $GDIP_ERRNOTIMPLEMENTED = 6 ; The method is not implemented
Global Const $GDIP_ERRWIN32ERROR = 7 ; The method generated a Microsoft Win32 error
Global Const $GDIP_ERRWRONGSTATE = 8 ; The object is in an invalid state to satisfy the API call
Global Const $GDIP_ERRABORTED = 9 ; The method was aborted
Global Const $GDIP_ERRFILENOTFOUND = 10 ; The specified image file or metafile cannot be found
Global Const $GDIP_ERRVALUEOVERFLOW = 11 ; The method produced a numeric overflow
Global Const $GDIP_ERRACCESSDENIED = 12 ; A write operation is not allowed on the specified file
Global Const $GDIP_ERRUNKNOWNIMAGEFORMAT = 13 ; The specified image file format is not known
Global Const $GDIP_ERRFONTFAMILYNOTFOUND = 14 ; The specified font family cannot be found
Global Const $GDIP_ERRFONTSTYLENOTFOUND = 15 ; The specified style is not available for the specified font
Global Const $GDIP_ERRNOTTRUETYPEFONT = 16 ; The font retrieved is not a TrueType font
Global Const $GDIP_ERRUNSUPPORTEDGDIVERSION = 17 ; The installed GDI+ version is incompatible
Global Const $GDIP_ERRGDIPLUSNOTINITIALIZED = 18 ; The GDI+ API is not in an initialized state
Global Const $GDIP_ERRPROPERTYNOTFOUND = 19 ; The specified property does not exist in the image
Global Const $GDIP_ERRPROPERTYNOTSUPPORTED = 20 ; The specified property is not supported

; Encoder Value Types
Global Const $GDIP_EVTCOMPRESSIONLZW = 2 ; TIFF: LZW compression
Global Const $GDIP_EVTCOMPRESSIONCCITT3 = 3 ; TIFF: CCITT3 compression
Global Const $GDIP_EVTCOMPRESSIONCCITT4 = 4 ; TIFF: CCITT4 compression
Global Const $GDIP_EVTCOMPRESSIONRLE = 5 ; TIFF: RLE compression
Global Const $GDIP_EVTCOMPRESSIONNONE = 6 ; TIFF: No compression
Global Const $GDIP_EVTTRANSFORMROTATE90 = 13 ; JPEG: Lossless 90 degree clockwise rotation
Global Const $GDIP_EVTTRANSFORMROTATE180 = 14 ; JPEG: Lossless 180 degree clockwise rotation
Global Const $GDIP_EVTTRANSFORMROTATE270 = 15 ; JPEG: Lossless 270 degree clockwise rotation
Global Const $GDIP_EVTTRANSFORMFLIPHORIZONTAL = 16 ; JPEG: Lossless horizontal flip
Global Const $GDIP_EVTTRANSFORMFLIPVERTICAL = 17 ; JPEG: Lossless vertical flip
Global Const $GDIP_EVTMULTIFRAME = 18 ; Multiple frame encoding
Global Const $GDIP_EVTLASTFRAME = 19 ; Last frame of a multiple frame image
Global Const $GDIP_EVTFLUSH = 20 ; The encoder object is to be closed
Global Const $GDIP_EVTFRAMEDIMENSIONPAGE = 23 ; TIFF: Page frame dimension

; Image Codec Flags constants
Global Const $GDIP_ICFENCODER = 0x00000001 ; The codec supports encoding (saving)
Global Const $GDIP_ICFDECODER = 0x00000002 ; The codec supports decoding (reading)
Global Const $GDIP_ICFSUPPORTBITMAP = 0x00000004 ; The codec supports raster images (bitmaps)
Global Const $GDIP_ICFSUPPORTVECTOR = 0x00000008 ; The codec supports vector images (metafiles)
Global Const $GDIP_ICFSEEKABLEENCODE = 0x00000010 ; The encoder requires a seekable output stream
Global Const $GDIP_ICFBLOCKINGDECODE = 0x00000020 ; The decoder has blocking behavior during the decoding process
Global Const $GDIP_ICFBUILTIN = 0x00010000 ; The codec is built in to GDI+
Global Const $GDIP_ICFSYSTEM = 0x00020000 ; Not used in GDI+ version 1.0
Global Const $GDIP_ICFUSER = 0x00040000 ; Not used in GDI+ version 1.0

; Image Lock Mode constants
Global Const $GDIP_ILMREAD = 0x0001 ; A portion of the image is locked for reading
Global Const $GDIP_ILMWRITE = 0x0002 ; A portion of the image is locked for writing
Global Const $GDIP_ILMUSERINPUTBUF = 0x0004 ; The buffer is allocated by the user

; LineCap constants
Global Const $GDIP_LINECAPFLAT = 0x00 ; Specifies a flat cap
Global Const $GDIP_LINECAPSQUARE = 0x01 ; Specifies a square cap
Global Const $GDIP_LINECAPROUND = 0x02 ; Specifies a circular cap
Global Const $GDIP_LINECAPTRIANGLE = 0x03 ; Specifies a triangular cap
Global Const $GDIP_LINECAPNOANCHOR = 0x10 ; Specifies that the line ends are not anchored
Global Const $GDIP_LINECAPSQUAREANCHOR = 0x11 ; Specifies that the line ends are anchored with a square
Global Const $GDIP_LINECAPROUNDANCHOR = 0x12 ; Specifies that the line ends are anchored with a circle
Global Const $GDIP_LINECAPDIAMONDANCHOR = 0x13 ; Specifies that the line ends are anchored with a diamond
Global Const $GDIP_LINECAPARROWANCHOR = 0x14 ; Specifies that the line ends are anchored with arrowheads
Global Const $GDIP_LINECAPCUSTOM = 0xFF ; Specifies that the line ends are made from a CustomLineCap

; Pixel Format constants
Global Const $GDIP_PXF01INDEXED = 0x00030101 ; 1 bpp, indexed
Global Const $GDIP_PXF04INDEXED = 0x00030402 ; 4 bpp, indexed
Global Const $GDIP_PXF08INDEXED = 0x00030803 ; 8 bpp, indexed
Global Const $GDIP_PXF16GRAYSCALE = 0x00101004 ; 16 bpp, grayscale
Global Const $GDIP_PXF16RGB555 = 0x00021005 ; 16 bpp; 5 bits for each RGB
Global Const $GDIP_PXF16RGB565 = 0x00021006 ; 16 bpp; 5 bits red, 6 bits green, and 5 bits blue
Global Const $GDIP_PXF16ARGB1555 = 0x00061007 ; 16 bpp; 1 bit for alpha and 5 bits for each RGB component
Global Const $GDIP_PXF24RGB = 0x00021808 ; 24 bpp; 8 bits for each RGB
Global Const $GDIP_PXF32RGB = 0x00022009 ; 32 bpp; 8 bits for each RGB. No alpha.
Global Const $GDIP_PXF32ARGB = 0x0026200A ; 32 bpp; 8 bits for each RGB and alpha
Global Const $GDIP_PXF32PARGB = 0x000E200B ; 32 bpp; 8 bits for each RGB and alpha, pre-mulitiplied
Global Const $GDIP_PXF48RGB = 0x0010300C ; 48 bpp; 16 bits for each RGB
Global Const $GDIP_PXF64ARGB = 0x0034400D ; 64 bpp; 16 bits for each RGB and alpha
Global Const $GDIP_PXF64PARGB = 0x001A400E ; 64 bpp; 16 bits for each RGB and alpha, pre-multiplied

; ImageFormat constants (Globally Unique Identifier (GUID))
Global Const $GDIP_IMAGEFORMAT_UNDEFINED = "{B96B3CA9-0728-11D3-9D7B-0000F81EF32E}" ; Windows GDI+ is unable to determine the format.
Global Const $GDIP_IMAGEFORMAT_MEMORYBMP = "{B96B3CAA-0728-11D3-9D7B-0000F81EF32E}" ; Image was constructed from a memory bitmap.
Global Const $GDIP_IMAGEFORMAT_BMP = "{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}" ; Microsoft Windows Bitmap (BMP) format.
Global Const $GDIP_IMAGEFORMAT_EMF = "{B96B3CAC-0728-11D3-9D7B-0000F81EF32E}" ; Enhanced Metafile (EMF) format.
Global Const $GDIP_IMAGEFORMAT_WMF = "{B96B3CAD-0728-11D3-9D7B-0000F81EF32E}" ; Windows Metafile Format (WMF) format.
Global Const $GDIP_IMAGEFORMAT_JPEG = "{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}" ; Joint Photographic Experts Group (JPEG) format.
Global Const $GDIP_IMAGEFORMAT_PNG = "{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}" ; Portable Network Graphics (PNG) format.
Global Const $GDIP_IMAGEFORMAT_GIF = "{B96B3CB0-0728-11D3-9D7B-0000F81EF32E}" ; Graphics Interchange Format (GIF) format.
Global Const $GDIP_IMAGEFORMAT_TIFF = "{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}" ; Tagged Image File Format (TIFF) format.
Global Const $GDIP_IMAGEFORMAT_EXIF = "{B96B3CB2-0728-11D3-9D7B-0000F81EF32E}" ; Exchangeable Image File (EXIF) format.
Global Const $GDIP_IMAGEFORMAT_ICON = "{B96B3CB5-0728-11D3-9D7B-0000F81EF32E}" ; Microsoft Windows Icon Image (ICO)format.

; ImageType constants
Global Const $GDIP_IMAGETYPE_UNKNOWN = 0
Global Const $GDIP_IMAGETYPE_BITMAP = 1
Global Const $GDIP_IMAGETYPE_METAFILE = 2

; ImageFlags flags constants
Global Const $GDIP_IMAGEFLAGS_NONE = 0x0 ; no format information.
Global Const $GDIP_IMAGEFLAGS_SCALABLE = 0x0001 ; image can be scaled.
Global Const $GDIP_IMAGEFLAGS_HASALPHA = 0x0002 ; pixel data contains alpha values.
Global Const $GDIP_IMAGEFLAGS_HASTRANSLUCENT = 0x0004 ; pixel data has alpha values other than 0 (transparent) and 255 (opaque).
Global Const $GDIP_IMAGEFLAGS_PARTIALLYSCALABLE = 0x0008 ; pixel data is partially scalable with some limitations.
Global Const $GDIP_IMAGEFLAGS_COLORSPACE_RGB = 0x0010 ; image is stored using an RGB color space.
Global Const $GDIP_IMAGEFLAGS_COLORSPACE_CMYK = 0x0020 ; image is stored using a CMYK color space.
Global Const $GDIP_IMAGEFLAGS_COLORSPACE_GRAY = 0x0040 ; image is a grayscale image.
Global Const $GDIP_IMAGEFLAGS_COLORSPACE_YCBCR = 0x0080 ; image is stored using a YCBCR color space.
Global Const $GDIP_IMAGEFLAGS_COLORSPACE_YCCK = 0x0100 ; image is stored using a YCCK color space.
Global Const $GDIP_IMAGEFLAGS_HASREALDPI = 0x1000 ; dots per inch information is stored in the image.
Global Const $GDIP_IMAGEFLAGS_HASREALPIXELSIZE = 0x2000 ; pixel size is stored in the image.
Global Const $GDIP_IMAGEFLAGS_READONLY = 0x00010000 ; pixel data is read-only.
Global Const $GDIP_IMAGEFLAGS_CACHING = 0x00020000 ; pixel data can be cached for faster access.

; Graphic SmoothingMode constants
Global Const $GDIP_SMOOTHINGMODE_INVALID = -1 ; Reserved.
Global Const $GDIP_SMOOTHINGMODE_DEFAULT = 0 ; Specifies that smoothing is not applied.
Global Const $GDIP_SMOOTHINGMODE_HIGHSPEED = 1 ; Specifies that smoothing is not applied.
Global Const $GDIP_SMOOTHINGMODE_HIGHQUALITY = 2 ; Specifies that smoothing is applied using an 8 X 4 box filter.
Global Const $GDIP_SMOOTHINGMODE_NONE = 3 ; Specifies that smoothing is not applied.
Global Const $GDIP_SMOOTHINGMODE_ANTIALIAS8X4 = 4 ; Specifies that smoothing is applied using an 8 X 4 box filter.
Global Const $GDIP_SMOOTHINGMODE_ANTIALIAS = $GDIP_SMOOTHINGMODE_ANTIALIAS8X4 ; Specifies that smoothing is applied using an 8 X 4 box filter.
Global Const $GDIP_SMOOTHINGMODE_ANTIALIAS8X8 = 5 ; Specifies that smoothing is applied using an 8 X 8 box filter.

; Colors luminance
Global Const $GDIP_RLUM = 0.3086
Global Const $GDIP_GLUM = 0.6094
Global Const $GDIP_BLUM = 0.0820

; Interpolation Mode constants
Global Const $GDIP_INTERPOLATIONMODE_INVALID = -1 ; Reserved (used internally)
Global Const $GDIP_INTERPOLATIONMODE_DEFAULT = 0 ; Specifies the default interpolation mode
Global Const $GDIP_INTERPOLATIONMODE_LOWQUALITY = 1 ; Specifies a low-quality mode
Global Const $GDIP_INTERPOLATIONMODE_HIGHQUALITY = 2 ; Specifies a high-quality mode
Global Const $GDIP_INTERPOLATIONMODE_BILINEAR = 3 ; Specifies bilinear interpolation. No prefiltering is done. This mode is not suitable for shrinking an image below 50 percent of its original size.
Global Const $GDIP_INTERPOLATIONMODE_BICUBIC = 4 ; Specifies bicubic interpolation. No prefiltering is done. This mode is not suitable for shrinking an image below 25 percent of its original size
Global Const $GDIP_INTERPOLATIONMODE_NEARESTNEIGHBOR = 5 ; Specifies nearest-neighbor interpolation
Global Const $GDIP_INTERPOLATIONMODE_HIGHQUALITYBILINEAR = 6 ; Specifies high-quality, bilinear interpolation. Prefiltering is performed to ensure high-quality shrinking.
Global Const $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC = 7 ; Specifies high-quality, bicubic interpolation. Prefiltering is performed to ensure high-quality shrinking. This mode produces the highest quality transformed images.

; TextRenderingHint constants
Global Const $GDIP_TEXTRENDERINGHINT_SYSTEMDEFAULT = 0 ; Specifies that a character is drawn using the currently selected system font smoothing mode (also called a rendering hint).
Global Const $GDIP_TEXTRENDERINGHINT_SINGLEBITPERPIXELGRIDFIT = 1 ; Specifies that a character is drawn using its glyph bitmap and hinting to improve character appearance on stems and curvature.
Global Const $GDIP_TEXTRENDERINGHINT_SINGLEBITPERPIXEL = 2 ; Specifies that a character is drawn using its glyph bitmap and no hinting. This results in better performance at the expense of quality.
Global Const $GDIP_TEXTRENDERINGHINT_ANTIALIASGRIDFIT = 3 ; Specifies that a character is drawn using its antialiased glyph bitmap and hinting. This results in much better quality due to antialiasing at a higher performance cost.
Global Const $GDIP_TEXTRENDERINGHINT_ANTIALIAS = 4 ; Specifies that a character is drawn using its antialiased glyph bitmap and no hinting. Stem width differences may be noticeable because hinting is turned off.
Global Const $GDIP_TEXTRENDERINGHINT_CLEARTYPEGRIDFIT = 5 ; Specifies that a character is drawn using its glyph ClearType bitmap and hinting. This type of text rendering cannot be used along with CompositingModeSourceCopy.

; PixelOffsetMode constants
Global Const $GDIP_PIXELOFFSETMODE_INVALID = -1 ; Used internally.
Global Const $GDIP_PIXELOFFSETMODE_DEFAULT = 0 ; Equivalent to $GDIP_PIXELOFFSETMODE_NONE
Global Const $GDIP_PIXELOFFSETMODE_HIGHSPEED = 1 ; Equivalent to $GDIP_PIXELOFFSETMODE_NONE
Global Const $GDIP_PIXELOFFSETMODE_HIGHQUALITY = 2 ; Equivalent to $GDIP_PIXELOFFSETMODE_HALF
Global Const $GDIP_PIXELOFFSETMODE_NONE = 3 ; Indicates that pixel centers have integer coordinates.
Global Const $GDIP_PIXELOFFSETMODE_HALF = 4 ; Indicates that pixel centers have coordinates that are half way between integer values.

; LineJoin constants
Global Const $GDIP_PENSETLINEJOIN_MITER = 0 ; Specifies a mitered join. This produces a sharp corner or a clipped corner, depending on whether the length of the miter exceeds the miter limit.
Global Const $GDIP_PENSETLINEJOIN_BEVEL = 1 ; Specifies a beveled join. This produces a diagonal corner.
Global Const $GDIP_PENSETLINEJOIN_ROUND = 2 ; Specifies a circular join. This produces a smooth, circular arc between the lines.
Global Const $GDIP_PENSETLINEJOIN_MITERCLIPPED = 3 ; Specifies a mitered join. This produces a sharp corner or a beveled corner, depending on whether the length of the miter exceeds the miter limit.

; Fill mode constants
Global Const $GDIP_FillModeAlternate = 0 ;Specifies that areas are filled according to the even-odd parity rule. According to this rule, you can determine
;whether a test point is inside or outside a closed curve as follows: Draw a line from the test point to a point
;that is distant from the curve. If that line crosses the curve an odd number of times, the test point is inside
;the curve; otherwise, the test point is outside the curve.

Global Const $GDIP_FillModeWinding = 1 ;Specifies that areas are filled according to the nonzero winding rule. According to this rule, you can determine
;whether a test point is inside or outside a closed curve as follows: Draw a line from a test point to a point that
;is distant from the curve. Count the number of times the curve crosses the test line from left to right, and count
;the number of times the curve crosses the test line from right to left. If those two numbers are the same, the test
;point is outside the curve; otherwise, the test point is inside the curve.

; Quality constants
Global Const $GDIP_QUALITYMODEINVALID = -1
Global Const $GDIP_QUALITYMODEDEFAULT = 0
Global Const $GDIP_QUALITYMODELOW = 1
Global Const $GDIP_QUALITYMODEHIGH = 2

; Alpha Compositing mode constants
Global Const $GDIP_COMPOSITINGMODESOURCEOVER = 0 ; Specifies that when a color is rendered, it is blended with the background color. The blend is determined by the alpha component of the color being rendered
Global Const $GDIP_COMPOSITINGMODESOURCECOPY = 1 ; Specifies that when a color is rendered, it overwrites the background color. This mode cannot be used along with $TextRenderingHintClearTypeGridFit

; Alpha Compositing quality constants
Global Const $GDIP_COMPOSITINGQUALITYINVALID = $GDIP_QUALITYMODEINVALID ; Invalid quality
Global Const $GDIP_COMPOSITINGQUALITYDEFAULT = $GDIP_QUALITYMODEDEFAULT ; Gamma correction is not applied
Global Const $GDIP_COMPOSITINGQUALITYHIGHSPEED = $GDIP_QUALITYMODELOW ; Gamma correction is not applied. High speed, low quality
Global Const $GDIP_COMPOSITINGQUALITYHIGHQUALITY = $GDIP_QUALITYMODEHIGH ; Gamma correction is applied. Composition of high quality and speed.
Global Const $GDIP_COMPOSITINGQUALITYGAMMACORRECTED = 3 ; Gamma correction is applied
Global Const $GDIP_COMPOSITINGQUALITYASSUMELINEAR = 4 ; Gamma correction is not applied. Linear values are used

; Various hatch styles
Global Const $GDIP_HATCHSTYLE_HORIZONTAL = 0
Global Const $GDIP_HATCHSTYLE_VERTICAL = 1
Global Const $GDIP_HATCHSTYLE_FORWARDDIAGONAL = 2
Global Const $GDIP_HATCHSTYLE_BACKWARDDIAGONAL = 3
Global Const $GDIP_HATCHSTYLE_CROSS = 4
Global Const $GDIP_HATCHSTYLE_DIAGONALCROSS = 5
Global Const $GDIP_HATCHSTYLE_05PERCENT = 6
Global Const $GDIP_HATCHSTYLE_10PERCENT = 7
Global Const $GDIP_HATCHSTYLE_20PERCENT = 8
Global Const $GDIP_HATCHSTYLE_25PERCENT = 9
Global Const $GDIP_HATCHSTYLE_30PERCENT = 10
Global Const $GDIP_HATCHSTYLE_40PERCENT = 11
Global Const $GDIP_HATCHSTYLE_50PERCENT = 12
Global Const $GDIP_HATCHSTYLE_60PERCENT = 13
Global Const $GDIP_HATCHSTYLE_70PERCENT = 14
Global Const $GDIP_HATCHSTYLE_75PERCENT = 15
Global Const $GDIP_HATCHSTYLE_80PERCENT = 16
Global Const $GDIP_HATCHSTYLE_90PERCENT = 17
Global Const $GDIP_HATCHSTYLE_LIGHTDOWNWARDDIAGONAL = 18
Global Const $GDIP_HATCHSTYLE_LIGHTUPWARDDIAGONAL = 19
Global Const $GDIP_HATCHSTYLE_DARKDOWNWARDDIAGONAL = 20
Global Const $GDIP_HATCHSTYLE_DARKUPWARDDIAGONAL = 21
Global Const $GDIP_HATCHSTYLE_WIDEDOWNWARDDIAGONAL = 22
Global Const $GDIP_HATCHSTYLE_WIDEUPWARDDIAGONAL = 23
Global Const $GDIP_HATCHSTYLE_LIGHTVERTICAL = 24
Global Const $GDIP_HATCHSTYLE_LIGHTHORIZONTAL = 25
Global Const $GDIP_HATCHSTYLE_NARROWVERTICAL = 26
Global Const $GDIP_HATCHSTYLE_NARROWHORIZONTAL = 27
Global Const $GDIP_HATCHSTYLE_DARKVERTICAL = 28
Global Const $GDIP_HATCHSTYLE_DARKHORIZONTAL = 29
Global Const $GDIP_HATCHSTYLE_DASHEDDOWNWARDDIAGONAL = 30
Global Const $GDIP_HATCHSTYLE_DASHEDUPWARDDIAGONAL = 31
Global Const $GDIP_HATCHSTYLE_DASHEDHORIZONTAL = 32
Global Const $GDIP_HATCHSTYLE_DASHEDVERTICAL = 33
Global Const $GDIP_HATCHSTYLE_SMALLCONFETTI = 34
Global Const $GDIP_HATCHSTYLE_LARGECONFETTI = 35
Global Const $GDIP_HATCHSTYLE_ZIGZAG = 36
Global Const $GDIP_HATCHSTYLE_WAVE = 37
Global Const $GDIP_HATCHSTYLE_DIAGONALBRICK = 38
Global Const $GDIP_HATCHSTYLE_HORIZONTALBRICK = 39
Global Const $GDIP_HATCHSTYLE_WEAVE = 40
Global Const $GDIP_HATCHSTYLE_PLAID = 41
Global Const $GDIP_HATCHSTYLE_DIVOT = 42
Global Const $GDIP_HATCHSTYLE_DOTTEDGRID = 43
Global Const $GDIP_HATCHSTYLE_DOTTEDDIAMOND = 44
Global Const $GDIP_HATCHSTYLE_SHINGLE = 45
Global Const $GDIP_HATCHSTYLE_TRELLIS = 46
Global Const $GDIP_HATCHSTYLE_SPHERE = 47
Global Const $GDIP_HATCHSTYLE_SMALLGRID = 48
Global Const $GDIP_HATCHSTYLE_SMALLCHECKERBOARD = 49
Global Const $GDIP_HATCHSTYLE_LARGECHECKERBOARD = 50
Global Const $GDIP_HATCHSTYLE_OUTLINEDDIAMOND = 51
Global Const $GDIP_HATCHSTYLE_SOLIDDIAMOND = 52
Global Const $GDIP_HATCHSTYLE_TOTAL = 53
Global Const $GDIP_HATCHSTYLE_LARGEGRID = $GDIP_HATCHSTYLE_CROSS
Global Const $GDIP_HATCHSTYLE_MIN = $GDIP_HATCHSTYLE_HORIZONTAL
Global Const $GDIP_HATCHSTYLE_MAX = $GDIP_HATCHSTYLE_TOTAL - 1

; GDIPlus V1.1 constants
;GDI+ effect GUIDs
Global Const $GDIP_BlurEffectGuid = '{633C80A4-1843-482b-9EF2-BE2834C5FDD4}'
Global Const $GDIP_SharpenEffectGuid = '{63CBF3EE-C526-402c-8F71-62C540BF5142}'
Global Const $GDIP_ColorMatrixEffectGuid = '{718F2615-7933-40e3-A511-5F68FE14DD74}'
Global Const $GDIP_ColorLUTEffectGuid = '{A7CE72A9-0F7F-40d7-B3CC-D0C02D5C3212}'
Global Const $GDIP_BrightnessContrastEffectGuid = '{D3A1DBE1-8EC4-4c17-9F4C-EA97AD1C343D}'
Global Const $GDIP_HueSaturationLightnessEffectGuid = '{8B2DD6C3-EB07-4d87-A5F0-7108E26A9C5F}'
Global Const $GDIP_LevelsEffectGuid = '{99C354EC-2A31-4f3a-8C34-17A803B33A25}'
Global Const $GDIP_TintEffectGuid = '{1077AF00-2848-4441-9489-44AD4C2D7A2C}'
Global Const $GDIP_ColorBalanceEffectGuid = '{537E597D-251E-48da-9664-29CA496B70F8}'
Global Const $GDIP_RedEyeCorrectionEffectGuid = '{74D29D05-69A4-4266-9549-3CC52836B632}'
Global Const $GDIP_ColorCurveEffectGuid = '{DD6A0022-58E4-4a67-9D9B-D48EB881A53D}'

Global Const $GDIP_AdjustExposure = 0 ;[-255..255]
Global Const $GDIP_AdjustDensity = 1 ;[-255..255]
Global Const $GDIP_AdjustContrast = 2 ;[-100..100]
Global Const $GDIP_AdjustHighlight = 3;[-100..100]
Global Const $GDIP_AdjustShadow = 4;[-100..100]
Global Const $GDIP_AdjustMidtone = 5;[-100..100]
Global Const $GDIP_AdjustWhiteSaturation = 6;[0..255]
Global Const $GDIP_AdjustBlackSaturation = 7;[0..255]

Global Const $GDIP_CurveChannelAll = 0
Global Const $GDIP_CurveChannelRed = 1
Global Const $GDIP_CurveChannelGreen = 2
Global Const $GDIP_CurveChannelBlue = 3

;Color format conversion parameters
Global Const $GDIP_PaletteTypeCustom = 0 ;Arbitrary custom palette provided by caller.
Global Const $GDIP_PaletteTypeOptimal = 1 ;Optimal palette generated using a median-cut algorithm.
Global Const $GDIP_PaletteTypeFixedBW = 2 ;Black and white palette.

;Symmetric halftone palettes. Each of these halftone palettes will be a superset of the system palette. E.g. Halftone8 will have it's 8-color on-off primaries and the 16 system colors added. With duplicates removed, that leaves 16 colors.
Global Const $GDIP_PaletteTypeFixedHalftone8 = 3 ;8-color, on-off primaries
Global Const $GDIP_PaletteTypeFixedHalftone27 = 4 ;3 intensity levels of each color
Global Const $GDIP_PaletteTypeFixedHalftone64 = 5 ;4 intensity levels of each color
Global Const $GDIP_PaletteTypeFixedHalftone125 = 6 ;5 intensity levels of each color
Global Const $GDIP_PaletteTypeFixedHalftone216 = 7 ;6 intensity levels of each color

;Assymetric halftone palettes. These are somewhat less useful than the symmetric ones, but are included for completeness. These do not include all of the system colors.
Global Const $GDIP_PaletteTypeFixedHalftone252 = 8 ;6-red, 7-green, 6-blue intensities
Global Const $GDIP_PaletteTypeFixedHalftone256 = 9 ;8-red, 8-green, 4-blue intensities

;PaletteFlags enumeration
Global Const $GDIP_PaletteFlagsHasAlpha = 0x0001
Global Const $GDIP_PaletteFlagsGrayScale = 0x0002
Global Const $GDIP_PaletteFlagsHalftone = 0x0004

;DitherType
Global Const $GDIP_DitherTypeNone = 0
Global Const $GDIP_DitherTypeSolid = 1 ;Solid color - picks the nearest matching color with no attempt to halftone or dither. May be used on an arbitrary palette.

;Ordered dithers and spiral dithers must be used with a fixed palette. NOTE: DitherOrdered4x4 is unique in that it may apply to 16bpp conversions also.
Global Const $GDIP_DitherTypeOrdered4x4 = 2
Global Const $GDIP_DitherTypeOrdered8x8 = 3
Global Const $GDIP_DitherTypeOrdered16x16 = 4
Global Const $GDIP_DitherTypeOrdered91x91 = 5
Global Const $GDIP_DitherTypeSpiral4x4 = 6
Global Const $GDIP_DitherTypeSpiral8x8 = 7
Global Const $GDIP_DitherTypeDualSpiral4x4 = 8
Global Const $GDIP_DitherTypeDualSpiral8x8 = 9

;Error diffusion. May be used with any palette.
Global Const $GDIP_DitherTypeErrorDiffusion = 10
Global Const $GDIP_DitherTypeMax = 10

;HistogramFormat
Global Const $GDIP_HistogramFormatARGB = 0
Global Const $GDIP_HistogramFormatPARGB = 1
Global Const $GDIP_HistogramFormatRGB = 2
Global Const $GDIP_HistogramFormatGray = 3
Global Const $GDIP_HistogramFormatB = 4
Global Const $GDIP_HistogramFormatG = 5
Global Const $GDIP_HistogramFormatR = 6
Global Const $GDIP_HistogramFormatA = 7

;TextRenderingHint constants
Global Const $GDIP_TextRenderingHintSystemDefault = 0
Global Const $GDIP_TextRenderingHintSingleBitPerPixelGridFit = 1
Global Const $GDIP_TextRenderingHintSingleBitPerPixel = 2
Global Const $GDIP_TextRenderingHintAntialiasGridFit = 3
Global Const $GDIP_TextRenderingHintAntialias = 4
Global Const $GDIP_TextRenderingHintClearTypeGridFit = 5

;RotateFlipType constants
Global Const $GDIP_RotateNoneFlipNone = 0
Global Const $GDIP_Rotate90FlipNone = 1
Global Const $GDIP_Rotate180FlipNone = 2
Global Const $GDIP_Rotate270FlipNone = 3
Global Const $GDIP_RotateNoneFlipX = 4
Global Const $GDIP_Rotate90FlipX = 5
Global Const $GDIP_Rotate180FlipX = 6
Global Const $GDIP_Rotate270FlipX = 7
Global Const $GDIP_RotateNoneFlipY = $GDIP_Rotate180FlipX
Global Const $GDIP_Rotate90FlipY = $GDIP_Rotate270FlipX
Global Const $GDIP_Rotate180FlipY = $GDIP_RotateNoneFlipX
Global Const $GDIP_Rotate270FlipY = $GDIP_Rotate90FlipX
Global Const $GDIP_RotateNoneFlipXY = $GDIP_Rotate180FlipNone
Global Const $GDIP_Rotate90FlipXY = $GDIP_Rotate270FlipNone
Global Const $GDIP_Rotate270FlipXY = $GDIP_Rotate90FlipNone
;===============================================================================================================================
