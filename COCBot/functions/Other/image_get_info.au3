#include-once

; #INDEX# =======================================================================================================================
; Title .........: Retrieve images info
; Description ...: Return JPEG, TIFF, BMP, PNG and GIF image common info:
;                  Size, Color Depth, Resolution etc. For TIFF files retrieved
;                  tags information, for JPEG - information from Exif/GPS (if exists).
; Requirement(s).: Autoit 3.3.6.0
; Author(s) .....: Dmitry Yudin (Lazycat)
; Version........: 3.0
; Date...........: 2010-11-13
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__FILE_BEGIN   = 0
Global Const $__FILE_CURRENT = 1
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_ImageGetInfo
;_ImageGetParam
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _ImageGetInfo
; Description ...: Main function
; Syntax.........: _ImageGetInfo($sFile)
; Parameters ....: $sFile       - Image file name
; Return values .: Success      - String with all image information in format:
;                                 ParamName=ParamValue
;                                 Pairs separated by @LF.
;                  Failure      - Set @error:
;                       1 - Can't open image (return empty string)
;                       2 - Parsing was stopped for some reason, information can be partial or incorrect
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ImageGetInfo($sFile)
    Local $sInfo = "", $hFile, $nClr, $error
    Local $nFileSize = FileGetSize($sFile)
    Local $ret = DllCall("kernel32.dll","int","CreateFile", _
                        "str",$sFile, _
                        "int",0x80000000, _
                        "int",0, _
                        "ptr",0, _
                        "int",3, _
                        "int",0x80, _
                        "ptr",0)
    If @error OR ($ret[0] = 0) Then Return SetError(1, 0, "")

    $hFile = $ret[0]
    Local $asIdent[7] = ["0xFFD8", "0x424D", "0x89504E470D0A1A0A", "0x4749463839", "0x4749463837", "0x4949", "0x4D4D"]
    Local $p = _FileReadToStructAtOffset("ubyte[54]", $hFile, 0)
    For $i = 0 To UBound($asIdent) - 1
        If BinaryMid(DllStructGetData($p, 1), 1, BinaryLen($asIdent[$i])) = $asIdent[$i] Then
            Switch $i
                Case 0 ; JPEG
                    $sInfo = _ParseJPEG($hFile, $nFileSize)
                    $error = @error
                Case 1 ; BMP
                    Local $t = DllStructCreate("int;int;short;short;dword;dword;dword;dword", DllStructGetPtr($p) + 18)
                    _Add($sInfo, "Width",  DllStructGetData($t, 1))
                    _Add($sInfo, "Height", DllStructGetData($t, 2))
                    _Add($sInfo, "ColorDepth", DllStructGetData($t, 4))
                    _Add($sInfo, "XResolution", Round(DllStructGetData($t, 7)/39.37))
                    _Add($sInfo, "YResolution", Round(DllStructGetData($t, 8)/39.37))
                    _Add($sInfo, "ResolutionUnit", "Inch")
					$t = 0
                Case 2 ; PNG
                    $sInfo = _ParsePNG($hFile, $nFileSize)
                    $error = @error
                Case 3, 4 ; GIF
                    Local $t = DllStructCreate("short;short;ubyte", DllStructGetPtr($p) + 6)
                    _Add($sInfo, "Width",  DllStructGetData($t, 1))
                    _Add($sInfo, "Height", DllStructGetData($t, 2))
                    $nClr = DllStructGetData($t, 3)
                    _Add($sInfo, "ColorDepth", _IsBitSet($nClr, 0) + _IsBitSet($nClr, 1)*2 + _IsBitSet($nClr, 2)*4 + 1)
					$t = 0
                Case 5, 6 ; TIFF
                     $sInfo = _ParseTIFF($hFile, 0)
            EndSwitch
            Exitloop
        Endif
    Next
    DllCall("kernel32.dll","int","CloseHandle","int", $hFile)
    Return SetError($error, 0, $sInfo)
EndFunc ;==>_ImageGetInfo

; #FUNCTION# ====================================================================================================================
; Name...........: _ImageGetParam
; Description ...: Get param by name from function result
; Syntax.........: _ImageGetParam($sInfo, $sParam)
; Parameters ....: $sFile       - Image file name
;                  $sParam      - Name of parameter (Width, Height etc)
; Return values .: Success      - String with parameter value
;                  Failure      - Empty string and set @error to 1
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ImageGetParam($sInfo, $sParam)
    Local $aParam = StringRegExp($sInfo, "(?m)^" & $sParam & "=(.*)$", 1)
    If IsArray($aParam) Then
        Return $aParam[0]
    Else
        SetError(1, 0, "")
    EndIf
EndFunc ;==>_ImageGetParam


; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ParsePNG
; Description ...: Parsing the PNG file format
; Syntax.........: _ParsePNG($hFile, $nFileSize)
; Parameters ....: $hFile        - Handle to the file
;                  $nFileSize    - Size of open file
; Return values .: Success      - String with all PNG info
;                  Failure      - Empty string and set @error to 2
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......: This function is used internally by _ImageGetInfo function
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _ParsePNG($hFile, $nFileSize)
    Local $sInfo = "", $nBlockSize, $nID = 0, $t
    Local $nBPP, $nCol, $sAlpha = ""
    Local $nXRes, $nYRes
    Local $sKeyword, $nKWLen
    Local $pBlockID = DllStructCreate("ulong;ulong")

    _FileSetPointer($hFile, 8, $__FILE_BEGIN) ; skipping ident
    While $nID <> 0x49454E44 ; IEND
        $pBlockID = _FileReadToStruct($pBlockID, $hFile)
        $nBlockSize = _IntR32(DllStructGetData($pBlockID, 1))
        If $nBlockSize > $nFileSize Then Return SetError(2, 0, $sInfo)
        $nID = _IntR32(DllStructGetData($pBlockID, 2))
        Switch $nID
            Case 0x49484452 ; IHDR
                $t = _FileReadToStruct("align 1;ulong;ulong;byte;byte;byte;byte;byte", $hFile)
                _Add($sInfo, "Width",  _IntR32(DllStructGetData($t, 1)))
                _Add($sInfo, "Height", _IntR32(DllStructGetData($t, 2)))
                $nBPP = DllStructGetData($t, 3)
                $nCol = DllStructGetData($t, 4)
                If $nCol > 3 Then
                    $nCol = $nCol - 4
                    $sAlpha = " + alpha"
                Endif
                If $nCol < 3 Then $nBPP = ($nCol + 1) * $nBPP
                _Add($sInfo, "ColorDepth", $nBPP & $sAlpha)
                _Add($sInfo, "Interlace", DllStructGetData($t, 7))
				$t = 0
            Case 0x70485973 ; pHYs
                $t = _FileReadToStruct("align 1;ulong;ulong;ubyte", $hFile)
                $nXRes = _IntR32(DllStructGetData($t, 1))
                $nYRes = _IntR32(DllStructGetData($t, 2))
                If DllStructGetData($t, 3) = 1 Then
                    $nXRes = Round($nXRes/39.37)
                    $nYRes = Round($nYRes/39.37)
                Endif
                _Add($sInfo, "XResolution", $nXRes)
                _Add($sInfo, "YResolution", $nYRes)
                _Add($sInfo, "ResolutionUnit", "Inch")
				$t = 0
            Case 0x74455874 ; tEXt
                ; length of keyword name limited to 80 symbols
                $t = _FileReadToStruct("char[80]", $hFile)
                $sKeyword = DllStructGetData($t, 1)
                $nKWLen = StringLen($sKeyword) + 1
                ; all beyond 0x00 char is value, set pointer to it's beginning
                _FileSetPointer($hFile, -80 + $nKWLen, $__FILE_CURRENT)
                $t = _FileReadToStruct("char[" & $nBlockSize - $nKWLen & "]", $hFile)
                _Add($sInfo, $sKeyword, DllStructGetData($t, 1))
				$t = 0
            Case 0x74494D45 ; tIME
                $t = _FileReadToStruct("align 1;ushort;ubyte;ubyte;ubyte;ubyte;ubyte", $hFile)
                _Add($sInfo, "DateTime", StringFormat("%4d-%02d-%02d %02d:%02d:%02d", _
                                         DllStructGetData($t, 1), DllStructGetData($t, 2), _
                                         DllStructGetData($t, 3), DllStructGetData($t, 4), _
                                         DllStructGetData($t, 5), DllStructGetData($t, 6)))
			    $t = 0
            Case Else
                _FileSetPointer($hFile, $nBlockSize + 4, $__FILE_CURRENT); skip unsupported segment
                ContinueLoop
        EndSwitch
        _FileSetPointer($hFile, 4, $__FILE_CURRENT) ; reading tag is done, skip CRC32
	 Wend

	 $pBlockID = 0

    Return $sInfo
EndFunc ;==>_ParsePNG

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ParseJPEG
; Description ...: Parsing the JPEG file format
; Syntax.........: _ParseJPEG($hFile, $nFileSize)
; Parameters ....: $hFile        - Handle to the file
;                  $nFileSize    - Size of open file
; Return values .: Success      - String with all JPEG info
;                  Failure      - Empty string and set @error to 2
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......: This function is used internally by _ImageGetInfo function
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _ParseJPEG($hFile, $nFileSize)
    Local $nPos = 2, $nMarker = 0, $sInfo = ""
    Local $nSegSize, $pSegment, $t

    _FileSetPointer($hFile, 2, $__FILE_BEGIN) ; skipping ident
    Local $p = DllStructCreate("align 1;ubyte;ubyte;ushort")
    While ($nMarker <> 0xDA) and ($nPos < $nFileSize)
        $p = _FileReadToStruct($p, $hFile)
        If DllStructGetData($p, 1) = 0xFF Then ; valid segment start
            $nMarker = DllStructGetData($p, 2)
            $nSegSize = _IntR16(DllStructGetData($p, 3))
            $pSegment = _FileReadToStruct("byte[" & $nSegSize - 2 & "]", $hFile)
            Switch $nMarker
                Case 0xC0 To 0xC3, 0xC5 To 0xC7, 0xCB, 0xCD To 0xCF
                    Switch $nMarker
                        Case 0xC2, 0xC6, 0xCA, 0xCE
                            _Add($sInfo, "Progressive", "True")
                        Case 0xC3, 0xC7, 0xCB, 0xCF
                            _Add($sInfo, "Lossless", "True")
                    EndSwitch
                    Switch $nMarker
                        Case 0xC0 To 0xC3, 0xC5 To 0xC7
                            _Add($sInfo, "Compression", "Huffman")
                        Case 0xC9 To 0xCB, 0xCD To 0xCF
                            _Add($sInfo, "Compression", "Arithmetic")
                    EndSwitch
                    Local $t = DllStructCreate("align 1;byte;ushort;ushort", DllStructGetPtr($pSegment))
                    _Add($sInfo, "Width",  _IntR16(DllStructGetData($t, 3)))
                    _Add($sInfo, "Height", _IntR16(DllStructGetData($t, 2)))
					$t = 0
                Case 0xE0 ; JFIF header
                    Local $t = DllStructCreate("byte[5];byte;byte;ubyte;ushort;ushort", DllStructGetPtr($pSegment))
                    _Add($sInfo, "XResolution", _IntR16(DllStructGetData($t, 5)))
                    _Add($sInfo, "YResolution", _IntR16(DllStructGetData($t, 6)))
                    _AddArray($sInfo, "ResolutionUnit", _IntR16(DllStructGetData($t, 4)), "Pixel;Inch;Cm")
					$t = 0
                Case 0xE1 ; EXIF segment
                   ; EXIF is private subset of TIFF tags
                   $sInfo = $sInfo & _ParseTIFF($hFile, $nPos + 10)
                   ; Move pointer to the end of segment
                    _FileSetPointer($hFile, $nPos + $nSegSize + 2, $__FILE_BEGIN)
                Case 0xFE ; Comment segment
                   Local $t = DllStructCreate("char[" & $nSegSize - 2 & "]", DllStructGetPtr($pSegment))
                   _Add($sInfo, "Comment", StringStripWS(DllStructGetData($t, 1), 3))
				   $t = 0
			EndSwitch
			$pSegment = 0
            $nPos= $nPos + $nSegSize + 2
        Else
            Return SetError(2, 0, $sInfo)
        Endif
	Wend

	$p = 0

    Return($sInfo)
EndFunc ;==>_ParseJPEG

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ParseTIFF
; Description ...: General TIFF Parser
; Syntax.........: _ParseTIFF($hFile [, $nTiffHdrOffset = 0])
; Parameters ....: $hFile             - Handle to the file
;                  $nTiffHdrOffset    - Offset of TIFF header (always 0 for TIFF)
; Return values .: Success      - String with all TIFF info
;                  Failure      - Empty string
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......: Parsing the TIFF file format, this function is used internally by _ImageGetInfo function
;                  For tags used information from:
;                  http://www.awaresystems.be/imaging/tiff.html
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _ParseTIFF($hFile, $nTiffHdrOffset = 0)
    Local $pHdr, $nIFDOffset, $pCnt, $nIFDCount, $pTag, $nCnt, $nID, $nEIFDCount
    Local $ByteOrder = 0, $sInfo = ""
    Local $nEIFDOffset, $nSubID

    $pHdr = _FileReadToStructAtOffset("short;short;dword", $hFile, $nTiffHdrOffset)
    If DllStructGetData($pHdr, 1) = 0x4D4D then $ByteOrder = 1
    $nIFDOffset = _IntR32(DllStructGetData($pHdr, 3), $ByteOrder) ; offset of first directory
    $pCnt = _FileReadToStructAtOffset("ushort", $hFile, $nTiffHdrOffset + $nIFDOffset)
    $nIFDCount = _IntR16(DllStructGetData($pCnt, 1), $ByteOrder) ; tags count in directory

    $pTag = DllStructCreate("ushort;ushort;ulong;ulong")

    For $nCnt = 0 To $nIFDCount - 1
        $pTag = _FileReadToStructAtOffset($pTag, $hFile, $nTiffHdrOffset + $nIFDOffset + 2 + $nCnt * 12)
        $nID = _IntR16(DllStructGetData($pTag, 1), $ByteOrder)
        Switch $nID
            Case 0x8769, 0x8825 ; Private IFDs
                $nEIFDOffset = _ReadTag($hFile, $pTag, $nTiffHdrOffset, $ByteOrder)
                $pCnt = _FileReadToStructAtOffset($pCnt, $hFile, $nTiffHdrOffset + $nEIFDOffset)
                $nEIFDCount = _IntR16(DllStructGetData($pCnt, 1), $ByteOrder)
                For $i = 0 To $nEIFDCount - 1
                    $pTag = _FileReadToStructAtOffset($pTag, $hFile, $nTiffHdrOffset + $nEIFDOffset + 2 + $i * 12)
                    $nSubID = _IntR16(DllStructGetData($pTag, 1), $ByteOrder)
                    Switch $nID
                        Case 0x8769 ; Exif
                            _AddExifTag($sInfo, $nSubID, _ReadTag($hFile, $pTag, $nTiffHdrOffset, $ByteOrder))
                        Case 0x8825 ; GPS
                            _AddGpsTag($sInfo, $nSubID, _ReadTag($hFile, $pTag, $nTiffHdrOffset, $ByteOrder))
                    EndSwitch
                Next
            Case 0xA005 ; Interop IFD
            Case 0x014A ; SubIFDs offset (currently unsupported)
            Case 0x0190 ; Global Parameters IFD (currently unsupported)
            Case Else
                _AddTiffTag($sInfo, $nID, _ReadTag($hFile, $pTag, $nTiffHdrOffset, $ByteOrder))
        EndSwitch
    Next

	$pTag = 0

    Return($sInfo)
EndFunc ;==>_ParseTIFF

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ReadTag
; Description ...: Read single TIFF tag
; Syntax.........: _ReadTag($hFile, $pTag, $nHdrOffset, $ByteOrder)
; Parameters ....: $hFile             - Handle to the file
;                  $pTag              - Tag structure
;                  $nHdrOffset        - Offset of TIFF header
;                  $ByteOrder         - Byte order for current tags set
; Return values .: Success      - Value with type, depending of tag type.
;                  Failure      - Empty string and set @error to 1
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......: If tag is not string, and value count > 1, array of all values is returned
;                  Multi-values support is coded only for types, that used somewhere
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _ReadTag($hFile, $pTag, $nHdrOffset, $ByteOrder)
    Local $nType   = _IntR16(DllStructGetData($pTag, 2), $ByteOrder)
    Local $nCount  = _IntR32(DllStructGetData($pTag, 3), $ByteOrder)
    Local $nOffset = _IntR32(DllStructGetData($pTag, 4), $ByteOrder) + $nHdrOffset
    Local $p

    Switch $nType
        Case 2 ; ASCII String
            $p = _FileReadToStructAtOffset("char[" & $nCount & "]", $hFile, $nOffset)
            Return DllStructGetData($p, 1)
        Case 1 ; Byte
            Return BitAND(DllStructGetData($pTag, 4), 0xFF)
        Case 3 ; Short
            If $nCount > 1 Then
                If $nCount > 2 Then
                    $p = _FileReadToStructAtOffset("short[" & $nCount & "]", $hFile, $nOffset)
                Else
                    $p = DllStructCreate("short[2]", DllStructGetPtr($pTag, 4))
                EndIf
                Local $aRet[$nCount]
                For $i = 1 To $nCount
                    $aRet[$i-1] = _IntR16(DllStructGetData($p, 1, $i), $ByteOrder)
			    Next
				$p = 0
                Return $aRet
            Else
                Return _IntR16(BitAND(DllStructGetData($pTag, 4), 0xFFFF), $ByteOrder)
            EndIf
        Case 4 ; Unsigned long
            If $nCount > 1 Then
                $p = _FileReadToStructAtOffset("short[" & $nCount & "]", $hFile, $nOffset)
                Local $aRet[$nCount]
                For $i = 1 To $nCount
                    $aRet[$i-1] = _IntR32(DllStructGetData($p, 1, $i), $ByteOrder)
                Next
                Return $aRet
            Else
                Return _IntR32(DllStructGetData($pTag, 4), $ByteOrder)
            EndIf
        Case 5 ; Rational (unsigned long/long)
            $p = _FileReadToStructAtOffset("ulong;ulong", $hFile, $nOffset)
            Return _IntR32(DllStructGetData($p, 1), $ByteOrder) / _IntR32(DllStructGetData($p, 2), $ByteOrder)
        Case 7 ; Undefined (byte * count)
            $p = _FileReadToStructAtOffset("byte[" & $nCount & "]", $hFile, $nOffset)
            Return DllStructGetData($p, 1)  ;_DllStructArrayAsString($p, 1, $nCount)
        Case 9 ; Signed long
            $p = DllStructCreate("long", DllStructGetPtr($pTag, 4))
			Local $iVal = _IntR32(DllStructGetData($p, 1), $ByteOrder)
			$p = 0
            Return $iVal
        Case 10 ; Rational (signed long/long)
            $p = _FileReadToStructAtOffset("dword;dword", $hFile, $nOffset)
            Return _IntR32(DllStructGetData($p, 1), $ByteOrder) / _IntR32(DllStructGetData($p, 2), $ByteOrder)
        Case Else
            Return SetError(1, 0, "")
    EndSwitch
EndFunc ;==>_ReadTag

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _AddTiffTag
; Description ...: Adds the baseline and extended TIFF tags to output
; Syntax.........: _AddExifTag(ByRef $sInfo, $nID, $vTag)
; Parameters ....: $sInfo   - Information string
;                  $nID     - Tag ID
;                  $vTag    - Tag value
; Return values .: None
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _AddTiffTag(ByRef $sInfo, $nID, $vTag)
    Local $p, $vTemp = ""
    Switch $nID
        ;========================================
        ;============ Baseline tags =============
        ;========================================
        Case 0x00FE
            Select
                Case _IsBitSet($vTag, 0)
                    $vTemp = "Reduced image"
                Case _IsBitSet($vTag, 1)
                    $vTemp = "Page"
                Case _IsBitSet($vTag, 2)
                    $vTemp = "Mask"
            EndSelect
            _Add($sInfo, "NewSubfileType", $vTemp)
        ; 0x00FF    SubfileType (deprecated)
        Case 0x0100
            _Add($sInfo, "Width", $vTag)
        Case 0x0101
            _Add($sInfo, "Height", $vTag)
        Case 0x0102
            If IsArray($vTag) Then
                $vTemp = 0
                For $i = 0 To UBound($vTag) - 1
                    $vTemp += $vTag[$i]
                Next
                _Add($sInfo, "Colordepth", $vTemp)
            Else
                _Add($sInfo, "Colordepth", $vTag)
            EndIf
        Case 0x0103
            Switch $vTag
                Case 32773
                    _Add($sInfo, "Compression", "Packbits")
                Case Else
                    _AddArray($sInfo, "Compression", $vTag, ";No compression;CCITT modified Huffman RLE;CCITT Group 3 fax encoding;" & _
                                                            "CCITT Group 4 fax encoding;LZW;JPEG (old);JPEG;Deflate;JBIG on B/W;JBIG on color","Unknown")
            EndSwitch
        Case 0x0106
            Switch $vTag
                Case 32803
                    _Add($sInfo, "PhotometricInterpretation", "LOGL")
                    $vTemp = "LOGL"
                Case 34892
                    _Add($sInfo, "PhotometricInterpretation", "LOGLUV")
                Case Else
                    _AddArray($sInfo, "PhotometricInterpretation", $vTag, "MINISWHITE;MINISBLACK;RGB;PALETTE;MASK;SEPARATED;YCBCR;CIELAB;ICCLAB;ITULAB")
            EndSwitch
        Case 0x0107
            _AddArray($sInfo, "Threshholding", $vTag, ";BiLevel;Halftone;Error Diffusion")
        Case 0x0108
            _Add($sInfo, "CellWidth", $vTemp)
        Case 0x0109
            _Add($sInfo, "CellLength", $vTemp)
        ; 0x010A    FillOrder
        Case 0x010E
            _Add($sInfo, "ImageDescription", $vTag)
        Case 0x010F
            _Add($sInfo, "Make", $vTag)
        Case 0x0110
            _Add($sInfo, "Model", $vTag)
        ; 0x0111    StripOffsets
        Case 0x0112
            _AddArray($sInfo, "Orientation", $vTag, ";Normal;Mirrored;180°;180° and mirrored;90° left and mirrored;90° right;90° right and mirrored;90° left")
        Case 0x0115
            _Add($sInfo, "SamplesPerPixel", $vTag)
        ; 0x0116    RowsPerStrip
        ; 0x0117    StripByteCounts
        ; 0x0118    MinSampleValue
        ; 0x0119    MaxSampleValue
        Case 0x011A
            _Add($sInfo, "XResolution", $vTag)
        Case 0x011B
            _Add($sInfo, "YResolution", $vTag)
        ; 0x011C    PlanarConfiguration
        ; 0x0120    FreeOffsets
        ; 0x0121    FreeByteCounts
        ; 0x0122    GrayResponseUnit
        ; 0x0123    GrayResponseCurve
        Case 0x0128
            _AddArray($sInfo, "ResolutionUnit", $vTag, ";;Inch;Centimeter")
        Case 0x0131
            _Add($sInfo, "Software", $vTag)
        Case 0x0132
            _Add($sInfo, "DateTime", $vTag)
        Case 0x013B
            _Add($sInfo, "Artist", $vTag)
        Case 0x013C
            _Add($sInfo, "HostComputer", $vTag)
        ; 0x0140    ColorMap
        Case 0x0152
            _AddArray($sInfo, "ExtraSamples", $vTag, ";Associated alpha;Unassociated alpha","Unspecified")
        Case 0x8298
            _Add($sInfo, "Copyright", $vTag)

        ;========================================
        ;============ Extended tags =============
        ;========================================
        Case 0x010D
            _Add($sInfo, "DocumentName", $vTag)
        Case 0x011D
            _Add($sInfo, "PageName", $vTag)
        Case 0x011E
            _Add($sInfo, "XPosition", $vTag)
        Case 0x011F
            _Add($sInfo, "YPosition", $vTag)
        ; 0x0124    T4Options
        ; 0x0125    T6Options
        Case 0x0129
            If IsArray($vTag) Then
                _Add($sInfo, "PageNumber", $vTag[0] & "/" & $vTag[1])
            EndIf
        ; 0x012D    TransferFunction
        ; 0x013D    Predictor
        Case 0x013E
            _Add($sInfo, "WhitePoint", $vTag)
        ; 0x013F    PrimaryChromaticities
        ; 0x0141	HalftoneHints
        ; 0x0142	TileWidth
        ; 0x0143	TileLength
        ; 0x0144	TileOffsets
        ; 0x0145	TileByteCounts
        Case 0x0146
            _Add($sInfo, "BadFaxLines", $vTag)
        Case 0x0147
            _AddArray($sInfo, "CleanFaxData", $vTag, "Clean;Regenerated;Unclean")
        Case 0x0148
            _Add($sInfo, "ConsecutiveBadFaxLines", $vTag)
        Case 0x014C
            _AddArray($sInfo, "InkSet", $vTag, ";CMYK", "No CMYK")
        ; 0x014D    InkNames
        Case 0x014E
            _Add($sInfo, "NumberOfInks", $vTag)
        ; 0x0150	DotRange
        Case 0x0151
            _Add($sInfo, "TargetPrinter", $vTag)
        ; 0x0153	SampleFormat
        ; 0x0154	SMinSampleValue
        ; 0x0155	SMaxSampleValue
        ; 0x0156	TransferRange
        ; 0x0157	ClipPath
        ; 0x0158	XClipPathUnits
        ; 0x0159	YClipPathUnits
        Case 0x015A
            _AddArray($sInfo, "Indexed", $vTag, "Not indexed;Indexed")
        ; 0x015B	JPEGTables
        ; 0x015F	OPIProxy
        Case 0x0191
            _AddArray($sInfo, "ProfileType", $vTag, ";Group 3 fax","Unspecified")
        ; 0x0192	FaxProfile
        ; 0x0193	CodingMethods
        ; 0x0194	VersionYear
        ; 0x0195	ModeNumber
        ; 0x01B1	Decode
        ; 0x01B2	DefaultImageColor
        ; 0x0200	JPEGProc
        ; 0x0201	JPEGInterchangeFormat
        ; 0x0202	JPEGInterchangeFormatLength
        ; 0x0203	JPEGRestartInterval
        ; 0x0205	JPEGLosslessPredictors
        ; 0x0206	JPEGPointTransforms
        ; 0x0207	JPEGQTables
        ; 0x0208	JPEGDCTables
        ; 0x0209	JPEGACTables
        ; 0x0211	YCbCrCoefficients
        ; 0x0212	YCbCrSubSampling
        ; 0x0213	YCbCrPositioning
        ; 0x0214	ReferenceBlackWhite
        ; 0x022F	StripRowCounts
        Case 0x02BC
            _Add($sInfo, "XMP", $vTag)
        ; 0x800D	ImageID
        ; 0x87AC	ImageLayer
    EndSwitch
EndFunc ;==>_AddTiffTag

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _AddExifTag
; Description ...: Adds EXIF private IFD tags to output
; Syntax.........: _AddExifTag(ByRef $sInfo, $nID, $vTag)
; Parameters ....: $sInfo   - Information string
;                  $nID     - Tag ID
;                  $vTag    - Tag value
; Return values .: None
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _AddExifTag(ByRef $sInfo, $nID, $vTag)
    Local $vTemp = ""
    Switch $nID
        Case 0x829A
            _Add($sInfo, "ExposureTime", $vTag)
        Case 0x829D
            _Add($sInfo, "FNumber", $vTag)
        Case 0x8822
            _AddArray($sInfo, "ExposureProgram", $vTag, "Undefined;Manual;Normal;Aperture priority;Shutter priority;Creative;Action;Portrait mode;Landscape mode")
        Case 0x8824
            _Add($sInfo, "SpectralSensitivity", $vTag)
        Case 0x8827
            _Add($sInfo, "ISO", $vTag)
        ; 0x8828    OECF
        Case 0x9000
            _Add($sInfo, "ExifVersion", $vTag)
        Case 0x9003
            _Add($sInfo, "DateTimeOriginal", $vTag)
        Case 0x9004
            _Add($sInfo, "DateTimeDigitized", $vTag)
        Case 0x9101
            Switch BinaryMid($vTag, 1, 1)
                Case 0x34
                    $vTemp = "RGB"
                Case 0x31
                    $vTemp = "YCbCr"
                Case Else
                    $vTemp = "Undefined"
            EndSwitch
            _Add($sInfo, "ComponentsConfiguration", $vTemp)
        Case 0x9102
            _Add($sInfo, "CompressedBitsPerPixel", $vTag)
        Case 0x9201
            _Add($sInfo, "ShutterSpeedValue", $vTag)
        Case 0x9202
            _Add($sInfo, "ApertureValue", $vTag)
        Case 0x9203
            _Add($sInfo, "BrightnessValue", $vTag)
        Case 0x9204
            _Add($sInfo, "ExposureBiasValue", $vTag)
        Case 0x9205
            _Add($sInfo, "MaxApertureValue", $vTag)
        Case 0x9206
            _Add($sInfo, "SubjectDistance", $vTag)
        Case 0x9207
            _AddArray($sInfo, "MeteringMode", $vTag, "Unknown;Average;Center Weighted Average;Spot;MultiSpot;MultiSegment;Partial;Other")
        Case 0x9208
            If $vTag = 255 Then
                _Add($sInfo, "LightSource", "Other")
            Else
                _AddArray($sInfo, "LightSource", $vTag, "Unknown;Daylight;Fluorescent;Tungsten;Flash;;;;;Fine weather;Cloudy weather;Shade;" & _
                                                        "Daylight fluorescent;Day white fluorescent;Cool white fluorescent;White fluorescent;;" & _
                                                        "Standard light A;Standard light B;Standard light C;D55;D65;D75;D50;ISO studio tungsten")
            EndIf
        Case 0x9209
            If _IsBitSet($vTag, 0) Then
                $vTemp = "Fired, "
            Else
                $vTemp = "Not fired, "
            EndIf
            Switch _IsBitSet($vTag, 4) * 2 + _IsBitSet($vTag, 3)
                Case 1
                    $vTemp &= "Forced ON, "
                Case 2
                    $vTemp &= "Forced OFF, "
                Case 3
                    $vTemp &= "Auto, "
            EndSwitch
            If _IsBitSet($vTag, 6) Then $vTemp &= "Red-eye reduction, "
            _Add($sInfo, "Flash", StringTrimRight($vTemp, 2))
        Case 0x920A
            _Add($sInfo, "FocalLength", $vTag)
        Case 0x9214
            If IsArray($vTag) Then
                Switch UBound($vTag)
                    Case 2
                        $vTemp = StringFormat("Point, %d:%d", $vTag[0], $vTag[1])
                    Case 3
                        $vTemp = StringFormat("Circle, Center %d:%d, Diameter %d", $vTag[0], $vTag[1], $vTag[2])
                    Case 4
                        $vTemp = StringFormat("Square, Center %d:%d, Width %d, Height %d", $vTag[0], $vTag[1], $vTag[2], $vTag[3])
                EndSwitch
            EndIf
            _Add($sInfo, "SubjectArea", $vTemp)
        ; 0x927C    MakerNote
        Case 0x9286
            Switch BinaryMid($vTag, 1, 8)
                Case "0x4153434949000000" ; ASCII
                    $vTemp = BinaryToString(BinaryMid($vTag, 9))
                Case "0x554E49434F444500" ; Unicode can be handled in future
                    $vTemp = BinaryMid($vTag, 9)
                Case Else ; JIS not supported
                    $vTemp = BinaryMid($vTag, 9)
            EndSwitch
            _Add($sInfo, "UserComment", $vTemp)
        Case 0x9290
            _Add($sInfo, "SubsecTime", $vTag)
        Case 0x9291
            _Add($sInfo, "SubsecTimeOriginal", $vTag)
        Case 0x9292
            _Add($sInfo, "SubsecTimeDigitized", $vTag)
        ; 0xA000    FlashpixVersion
        Case 0xA001
            _AddArray($sInfo, "ColorSpace", $vTag, ";RGB", "Uncalibrated")
        Case 0xA002
            _Add($sInfo, "PixelXDimension", $vTag)
        Case 0xA003
            _Add($sInfo, "PixelYDimension", $vTag)
        Case 0xA004
            _Add($sInfo, "RelatedSoundFile", $vTag)
        Case 0xA20B
            _Add($sInfo, "FlashEnergy", $vTag)
        ; 0xA20C    SpatialFrequencyResponse
        Case 0xA20E
            _Add($sInfo, "FocalPlaneXResolution", $vTag)
        Case 0xA20F
            _Add($sInfo, "FocalPlaneYResolution", $vTag)
        Case 0xA210
            _AddArray($sInfo, "FocalPlaneResolutionUnit", $vTag, ";;Inch;Centimeter")
        Case 0xA214
            If IsArray($vTag) Then
                _Add($sInfo, "SubjectLocation", $vTag[0] & ":" & $vTag[1])
            EndIf
        Case 0xA215
            _Add($sInfo, "ExposureIndex", $vTag)
        Case 0xA217
            _AddArray($sInfo, "SensingMethod", $vTag, "Undefined;Undefined;OneChipColorArea;TwoChipColorArea;ThreeChipColorArea;ColorSequentialArea;Undefined;Trilinear;ColorSequentialLinear")
        Case 0xA300
            If $vTag = 0x3 Then _Add($sInfo, "FileSource", "DSC")
        Case 0xA301
            If $vTag = 0x1 Then _Add($sInfo, "SceneType", "Directly recorded")
        ; 0xA302    CFAPattern
        Case 0xA401
            _AddArray($sInfo, "CustomRendered", "No;Yes","No")
        Case 0xA402
            _AddArray($sInfo, "ExposureMode", $vTag, "Auto;Manual;Auto bracket")
        Case 0xA403
            _AddArray($sInfo, "WhiteBalance", $vTag, "Auto;Manual")
        Case 0xA404
            _Add($sInfo, "DigitalZoomRatio", $vTag)
        Case 0xA405
            _AddArray($sInfo, "FocalLengthIn35mmFilm", $vTag, "Unknown", $vTag)
        Case 0xA406
            _AddArray($sInfo, "SceneCaptureType", $vTag, "Standard;Landscape;Portrait;Night scene")
        Case 0xA407
            _AddArray($sInfo, "GainControl", $vTag, "None;Low gain up;High gain up;Low gain down;High gain down")
        Case 0xA408
            _AddArray($sInfo, "Contrast", $vTag, "Normal;Soft;Hard")
        Case 0xA409
            _AddArray($sInfo, "Saturation", $vTag, "Normal;Low;High")
        Case 0xA40A
            _AddArray($sInfo, "Sharpness", $vTag, "Normal;Soft;Hard")
        Case 0xA40B
            _Add($sInfo, "DeviceSettingDescription", $vTag) ; binary
        Case 0xA40C
            _AddArray($sInfo, "SubjectDistanceRange", $vTag, "Unknown;Macro;Close view;Distant view")
        Case 0xA420
            _Add($sInfo, "ImageUniqueID", $vTag)
    EndSwitch
EndFunc ;==>_AddExifTag

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _AddGpsTag
; Description ...: Adds GPS private IFD tags to output
; Syntax.........: _AddGpsTag(ByRef $sInfo, $nID, $vTag)
; Parameters ....: $sInfo   - Information string
;                  $nID     - Tag ID
;                  $vTag    - Tag value
; Return values .: None
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _AddGpsTag(ByRef $sInfo, $nID, $vTag)
    Switch $nID
        Case 0x0000
            _Add($sInfo, "GPSVersionID", $vTag)
        Case 0x0001
            _Add($sInfo, "GPSLatitudeRef", $vTag)
        Case 0x0002
            If IsArray($vTag) And (UBound($vTag) = 3) Then
                _Add($sInfo, "GPSLatitude", StringFormat("%f/%f/%f", $vTag[0], $vTag[1], $vTag[2]))
            EndIf
        Case 0x0003
            _Add($sInfo, "GPSLongitudeRef", $vTag)
        Case 0x0004
            If IsArray($vTag) And (UBound($vTag) = 3) Then
                _Add($sInfo, "GPSLongitude", StringFormat("%f/%f/%f", $vTag[0], $vTag[1], $vTag[2]))
            EndIf
        Case 0x0005
            _AddArray($sInfo, "GPSAltitudeRef", $vTag, "Above sea level,Below sea level")
        Case 0x0006
            _Add($sInfo, "GPSAltitude", $vTag)
        Case 0x0007
            If IsArray($vTag) And (UBound($vTag) = 3) Then
                _Add($sInfo, "GPSTimeStamp", StringFormat("UTC %f:%f:%f", $vTag[0], $vTag[1], $vTag[2]))
            EndIf
        Case 0x0008
            _Add($sInfo, "GPSSatellites", $vTag)
        Case 0x0009
            _Add($sInfo, "GPSStatus", $vTag)
        Case 0x000A
            _Add($sInfo, "GPSMeasureMode", $vTag)
        Case 0x000B
            _Add($sInfo, "GPSDOP", $vTag)
        Case 0x000C
            _Add($sInfo, "GPSSpeedRef", $vTag)
        Case 0x000D
            _Add($sInfo, "GPSSpeed", $vTag)
        Case 0x000E
            _Add($sInfo, "GPSTrackRef", $vTag)
        Case 0x000F
            _Add($sInfo, "GPSTrack", $vTag)
        Case 0x0010
            _Add($sInfo, "GPSImgDirectionRef", $vTag)
        Case 0x0011
            _Add($sInfo, "GPSImgDirection", $vTag)
        Case 0x0012
            _Add($sInfo, "GPSMapDatum", $vTag)
        Case 0x0013
            _Add($sInfo, "GPSDestLatitudeRef", $vTag)
        Case 0x0014
            If IsArray($vTag) And (UBound($vTag) = 3) Then
                _Add($sInfo, "GPSDestLatitude", StringFormat("%f/%f/%f", $vTag[0], $vTag[1], $vTag[2]))
            EndIf
        Case 0x0015
            _Add($sInfo, "GPSDestLongitudeRef", $vTag)
        Case 0x0016
            If IsArray($vTag) And (UBound($vTag) = 3) Then
                _Add($sInfo, "GPSDestLongitude", StringFormat("%f/%f/%f", $vTag[0], $vTag[1], $vTag[2]))
            EndIf
        Case 0x0017
            _Add($sInfo, "GPSDestBearingRef", $vTag)
        Case 0x0018
            _Add($sInfo, "GPSDestBearing", $vTag)
        Case 0x0019
            _Add($sInfo, "GPSDestDistanceRef", $vTag)
        Case 0x001A
            _Add($sInfo, "GPSDestDistance", $vTag)
        ; 0x001B	GPSProcessingMethod
        ; 0x001C	GPSAreaInformation
        Case 0x001D
            _Add($sInfo, "GPSDateStamp", $vTag)
        Case 0x001E
            _AddArray($sInfo, "GPSDifferential", $vTag, "No correction;Correction applied")
    EndSwitch
EndFunc ;==>_AddGpsTag

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _AddArray
; Description ...: Wrapper to add value from set
; Syntax.........: _AddArray(ByRef $sInfo, $sField, $vTag, $sValues [, $sDefault = "Undefined"])
; Parameters ....: $sInfo     - Information string
;                  $sField    - Parameter name
;                  $vTag      - Tag value
;                  $sValues   - String with ";" separated values
;                  $sDefault  - Default value string
; Return values .: None
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _AddArray(ByRef $sInfo, $sField, $vTag, $sValues, $sDefault = "Undefined")
    Local $aArray = StringSplit($sValues, ";", 2)
    Switch $vTag
        Case 0 To UBound($aArray) - 1
            If $aArray[$vTag] = "" Then $aArray[$vTag] = $sDefault
            _Add($sInfo, $sField, $aArray[$vTag])
        Case Else
            _Add($sInfo, $sField, $sDefault)
    EndSwitch
EndFunc ;==>_AddArray

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _IsBitSet
; Description ...: Checks if bit in the number is set
; Syntax.........: _IsBitSet($nNum, $nBit)
; Parameters ....: $nNum    - Number
;                  $nBit    - Zero based bit index
; Return values .: True or False
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _IsBitSet($nNum, $nBit)
    Return BitAND(BitShift($nNum, $nBit), 1)
EndFunc ;==>_IsBitSet

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _Add
; Description ...: Shorthand to add string
; Syntax.........: _Add(ByRef $sInfo, $sLabel, $nValue)
; Parameters ....: $sInfo     - Information string
;                  $sField    - Parameter name
;                  $nValue    - Parameter value
; Return values .: None, add pair Param=Value to information string
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _Add(ByRef $sInfo, $sField, $nValue)
    $sInfo = $sInfo & $sField & "=" & $nValue & @LF
EndFunc ;==>_Add

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _IntR32, _IntR16
; Description ...: Change endianness (32 and 16 bit integers)
; Syntax.........: _IntR32($nInt, $nOrder = 1)
;                  _IntR16($nInt, $nOrder = 1)
; Parameters ....: $nInt     - Number
;                  $nOrder   - Byte order
; Return values .: Integer
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......: Convert Intel numbers into Motorola in case $nOrder = 1
;                  Faster then previous implementation
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _IntR32($nInt, $nOrder = 1)
    If not $nOrder Then Return $nInt
    Return BitOR(BitAND(BitShift($nInt,24), 0x000000FF), _
                 BitAND(BitShift($nInt, 8), 0x0000FF00), _
                 BitAND(BitShift($nInt,-8), 0x00FF0000), _
                 BitAND(BitShift($nInt,-24),0xFF000000))
EndFunc ;==>_IntR32

Func _IntR16($nInt, $nOrder = 1)
    If not $nOrder Then Return $nInt
    Return BitOR(BitAND(BitShift($nInt, 8), 0xFF), BitAND(BitShift($nInt, -8), 0xFF00))
EndFunc ;==>_IntR16

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _FileSetPointer
; Description ...: Moves file pointer to given offset
; Syntax.........: _FileSetPointer($hFile, $nOffset, $nStartPosition)
; Parameters ....: $hFile               - Handle to file
;                  $nOffset             - Offset to move
;                  $nStartPosition      - Start position from counting
; Return values .: None
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _FileSetPointer($hFile, $nOffset, $nStartPosition)
    Local $ret = DllCall("kernel32.dll","int","SetFilePointer", _
                        "int",$hFile, _
                        "int",$nOffset, _
                        "ptr",0, _
                        "int",$nStartPosition)
EndFunc ;==>_FileSetPointer

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _FileReadToStruct
; Description ...: Read data to struct given by string or "handle"
; Syntax.........: _FileReadToStruct($vStruct, $hFile)
; Parameters ....: $vStruct    - Structure, given by string or struct "handle"
;                  $hFile      - Handle to file
; Return values .: Structure that filled with data being read
;                  @error is set to 2 in case not all bytes was read
;                  @extended is set to number of bytes read
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......: Reading is done from current file position
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _FileReadToStruct($vStruct, $hFile)
    If not DllStructGetSize($vStruct) Then $vStruct = DllStructCreate($vStruct)
    Local $nLen	= DllStructGetSize($vStruct)
    Local $pRead = DllStructCreate("dword")
	Local $ret = DllCall("kernel32.dll","int","ReadFile", _
                         "int",$hFile, _
                         "ptr",DllStructGetPtr($vStruct), _
                         "int", $nLen, _
                         "ptr",DllStructGetPtr($pRead), _
                         "ptr",0)
    Local $nRead = DllStructGetData($pRead, 1)
    SetExtended($nRead)
    If not ($nRead = $nLen) Then SetError(2)
    Return $vStruct
EndFunc ;==>_FileReadToStruct

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _FileReadToStructAtOffset
; Description ...: Read data to struct given by string or "handle" at given offset
; Syntax.........: _FileReadToStructAtOffset($vStruct, $hFile, $nOffset)
; Parameters ....: $vStruct    - Structure, given by string or struct "handle"
;                  $hFile      - Handle to file
;                  $nOffset    - Offset
; Return values .: Structure that filled with data being read
;                  @error is set to 2 in case not all bytes was read
;                  @extended is set to number of bytes read
; Author ........: Dmitry Yudin (Lazycat)
; Modified.......:
; Remarks .......: Offset is counting from file beginning
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _FileReadToStructAtOffset($vStruct, $hFile, $nOffset)
    _FileSetPointer($hFile, $nOffset, $__FILE_BEGIN)
    Return SetError(@error, @extended, _FileReadToStruct($vStruct, $hFile))
EndFunc ;==>_FileReadToStructAtOffset
