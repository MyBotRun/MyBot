#include-once

#include "Date.au3"
#include "InetConstants.au3"
#include "StringConstants.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title .........: Edit Constants
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Functions that assist with Internet.
; Author(s) .....: Larry, Ezzetabi, Jarvis Stubblefield, Wes Wolfe-Wolvereness, Wouter, Walkabout, Florian Fida, guinness
; Dll ...........: wininet.dll, ws2_32.dll
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _GetIP
; _INetExplorerCapable
; _INetGetSource
; _INetMail
; _INetSmtpMail
; _TCPIpToName
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __SmtpTrace
; __SmtpSend
; __TCPIpToName_szStringRead
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: guinness, Mat
; ===============================================================================================================================
Func _GetIP()
	Local Const $GETIP_TIMER = 300000 ; Constant for how many milliseconds between each check. This is 5 minutes.
	Local Static $hTimer = 0 ; Create a static variable to store the timer handle.
	Local Static $sLastIP = 0 ; Create a static variable to store the last IP.

	If __TimerDiff($hTimer) < $GETIP_TIMER And Not $sLastIP Then ; If still in the timer and $sLastIP contains a value.
		Return SetExtended(1, $sLastIP) ; Return the last IP instead and set @extended to 1.
	EndIf

	#cs
		Additional list of possible IP disovery sites by z3r0c00l12.
		http://corz.org/ip
		http://icanhazip.com
		http://ip.appspot.com
		http://ip.eprci.net/text
		http://ip.jsontest.com/
		http://services.packetizer.com/ipaddress/?f=text
		http://whatthehellismyip.com/?ipraw
		http://wtfismyip.com/text
		http://www.networksecuritytoolkit.org/nst/tools/ip.php
		http://www.telize.com/ip
		http://www.trackip.net/ip
	#ce
	Local $aGetIPURL[] = ["http://checkip.dyndns.org", "http://www.myexternalip.com/raw", "http://bot.whatismyipaddress.com"], _
			$aReturn = 0, _
			$sReturn = ""

	For $i = 0 To UBound($aGetIPURL) - 1
		$sReturn = InetRead($aGetIPURL[$i])
		If @error Or $sReturn == "" Then ContinueLoop
		$aReturn = StringRegExp(BinaryToString($sReturn), "((?:\d{1,3}\.){3}\d{1,3})", $STR_REGEXPARRAYGLOBALMATCH) ; [\d\.]{7,15}
		If Not @error Then
			$sReturn = $aReturn[0]
			ExitLoop
		EndIf
		$sReturn = ""
	Next

	$hTimer = __TimerInit() ; Create a new timer handle.
	$sLastIP = $sReturn ; Store this IP.
	If $sReturn == "" Then Return SetError(1, 0, -1)
	Return $sReturn
EndFunc   ;==>_GetIP

; #FUNCTION# ====================================================================================================================
; Author ........: Wes Wolfe-Wolvereness <Weswolf at aol dot com>
; ===============================================================================================================================
Func _INetExplorerCapable($sIEString)
	If StringLen($sIEString) <= 0 Then Return SetError(1, 0, '')
	Local $s_IEReturn
	Local $n_IEChar
	For $i_IECount = 1 To StringLen($sIEString)
		$n_IEChar = '0x' & Hex(Asc(StringMid($sIEString, $i_IECount, 1)), 2)
		If $n_IEChar < 0x21 Or $n_IEChar = 0x25 Or $n_IEChar = 0x2f Or $n_IEChar > 0x7f Then
			$s_IEReturn = $s_IEReturn & '%' & StringRight($n_IEChar, 2)
		Else
			$s_IEReturn = $s_IEReturn & Chr($n_IEChar)
		EndIf
	Next
	Return $s_IEReturn
EndFunc   ;==>_INetExplorerCapable

; #FUNCTION# ====================================================================================================================
; Author ........: Wouter van Kesteren.
; ===============================================================================================================================
Func _INetGetSource($sURL, $bString = True)
	Local $sString = InetRead($sURL, $INET_FORCERELOAD)
	Local $iError = @error, $iExtended = @extended
	If $bString = Default Or $bString Then $sString = BinaryToString($sString)
	Return SetError($iError, $iExtended, $sString)
EndFunc   ;==>_INetGetSource

; #FUNCTION# ====================================================================================================================
; Author ........: Wes Wolfe-Wolvereness <Weswolf at aol dot com>, modified by Emiel Wieldraaijer
; ===============================================================================================================================
Func _INetMail($sMailTo, $sMailSubject, $sMailBody)
	Local $iPrev = Opt("ExpandEnvStrings", 1)
	Local $sVar, $sDflt = RegRead('HKCU\Software\Clients\Mail', "")
	If $sDflt = "Windows Live Mail" Then
		$sVar = RegRead('HKCR\WLMail.Url.Mailto\Shell\open\command', "")
	Else
		$sVar = RegRead('HKCR\mailto\shell\open\command', "")
	EndIf
	Local $iRet = Run(StringReplace($sVar, '%1', _INetExplorerCapable('mailto:' & $sMailTo & '?subject=' & $sMailSubject & '&body=' & $sMailBody)))
	Local $iError = @error, $iExtended = @extended
	Opt("ExpandEnvStrings", $iPrev)
	Return SetError($iError, $iExtended, $iRet)
EndFunc   ;==>_INetMail

; #FUNCTION# ====================================================================================================================
; Author ........: Asimzameer, Walkabout
; Modified.......: Jpm
; ===============================================================================================================================
Func _INetSmtpMail($sSMTPServer, $sFromName, $sFromAddress, $sToAddress, $sSubject = "", $aBody = "", $sEHLO = "", $sFirst = "", $bTrace = 0)
	If $sSMTPServer = "" Or $sFromAddress = "" Or $sToAddress = "" Or $sFromName = "" Or StringLen($sFromName) > 256 Then Return SetError(1, 0, 0)
	If $sEHLO = "" Then $sEHLO = @ComputerName

	If TCPStartup() = 0 Then Return SetError(2, 0, 0)

	Local $s_IPAddress, $i_Count
	If StringRegExp($sSMTPServer, "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$") Then
		$s_IPAddress = $sSMTPServer
	Else
		$s_IPAddress = TCPNameToIP($sSMTPServer)
	EndIf
	If $s_IPAddress = "" Then
		TCPShutdown()
		Return SetError(3, 0, 0)
	EndIf
	Local $vSocket = TCPConnect($s_IPAddress, 25)
	If $vSocket = -1 Then
		TCPShutdown()
		Return SetError(4, 0, 0)
	EndIf

	Local $aSend[6], $aReplyCode[6] ; Return code from SMTP server indicating success
	$aSend[0] = "HELO " & $sEHLO & @CRLF
	If StringLeft($sEHLO, 5) = "EHLO " Then $aSend[0] = $sEHLO & @CRLF
	$aReplyCode[0] = "250"

	$aSend[1] = "MAIL FROM: <" & $sFromAddress & ">" & @CRLF
	$aReplyCode[1] = "250"
	$aSend[2] = "RCPT TO: <" & $sToAddress & ">" & @CRLF
	$aReplyCode[2] = "250"
	$aSend[3] = "DATA" & @CRLF
	$aReplyCode[3] = "354"

	Local $aResult = _Date_Time_GetTimeZoneInformation()
	Local $iBias = -$aResult[1] / 60
	Local $iBiasH = Int($iBias)
	Local $iBiasM = 0
	If $iBiasH <> $iBias Then $iBiasM = Abs($iBias - $iBiasH) * 60
	$iBias = StringFormat(" (%+.2d%.2d)", $iBiasH, $iBiasM)

	$aSend[4] = "From:" & $sFromName & "<" & $sFromAddress & ">" & @CRLF & _
			"To:" & "<" & $sToAddress & ">" & @CRLF & _
			"Subject:" & $sSubject & @CRLF & _
			"Mime-Version: 1.0" & @CRLF & _
			"Date: " & _DateDayOfWeek(@WDAY, 1) & ", " & @MDAY & " " & _DateToMonth(@MON, 1) & " " & @YEAR & " " & @HOUR & ":" & @MIN & ":" & @SEC & $iBias & @CRLF & _
			"Content-Type: text/plain; charset=US-ASCII" & @CRLF & _
			@CRLF
	$aReplyCode[4] = ""

	$aSend[5] = @CRLF & "." & @CRLF
	$aReplyCode[5] = "250"

	; open stmp session
	If __SmtpSend($vSocket, $aSend[0], $aReplyCode[0], $bTrace, "220", $sFirst) Then Return SetError(50, 0, 0)

	; send header
	For $i_Count = 1 To UBound($aSend) - 2
		If __SmtpSend($vSocket, $aSend[$i_Count], $aReplyCode[$i_Count], $bTrace) Then Return SetError(50 + $i_Count, 0, 0)
	Next

	; send body records (a record can be multiline : take care of a subline beginning with a dot should be ..)
	For $i_Count = 0 To UBound($aBody) - 1
		; correct line beginning with a dot
		If StringLeft($aBody[$i_Count], 1) = "." Then $aBody[$i_Count] = "." & $aBody[$i_Count]

		If __SmtpSend($vSocket, $aBody[$i_Count] & @CRLF, "", $bTrace) Then Return SetError(500 + $i_Count, 0, 0)
	Next

	; close the smtp session
	$i_Count = UBound($aSend) - 1
	If __SmtpSend($vSocket, $aSend[$i_Count], $aReplyCode[$i_Count], $bTrace) Then Return SetError(5000, 0, 0)

	TCPCloseSocket($vSocket)
	TCPShutdown()
	Return 1
EndFunc   ;==>_INetSmtpMail

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __SmtpTrace
; Description ...: Used internally within this file, not for general use
; Syntax.........: __SmtpTrace ( $sStr [, $iTimeout = 0] )
; Author ........: Asimzameer, Walkabout
; Modified.......: Jpm
; ===============================================================================================================================
Func __SmtpTrace($sStr, $iTimeout = 0)
	Local $sW_TITLE = "SMTP trace"
	Local $sSmtpTrace = ControlGetText($sW_TITLE, "", "Static1")
	$sStr = StringLeft(StringReplace($sStr, @CRLF, ""), 70)
	$sSmtpTrace &= @HOUR & ":" & @MIN & ":" & @SEC & " " & $sStr & @LF
	If WinExists($sW_TITLE) Then
		ControlSetText($sW_TITLE, "", "Static1", $sSmtpTrace)
	Else
		SplashTextOn($sW_TITLE, $sSmtpTrace, 400, 500, 500, 100, 4 + 16, "", 8)
	EndIf
	If $iTimeout Then Sleep($iTimeout * 1000)
EndFunc   ;==>__SmtpTrace

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __SmtpSend
; Description ...: Used internally within this file, not for general use
; Syntax.........: __SmtpSend ( $vSocket, $sSend, $sReplyCode, $bTrace [, $sIntReply="" [, $sFirst=""]] )
; Author ........: Asimzameer, Walkabout
; Modified.......: Jpm
; ===============================================================================================================================
Func __SmtpSend($vSocket, $sSend, $sReplyCode, $bTrace, $sIntReply = "", $sFirst = "")
	Local $sReceive, $i, $hTimer
	If $bTrace Then __SmtpTrace($sSend)

	If $sIntReply <> "" Then

		; Send special first char to awake smtp server
		If $sFirst <> -1 Then
			If TCPSend($vSocket, $sFirst) = 0 Then
				TCPCloseSocket($vSocket)
				TCPShutdown()
				Return 1; cannot send
			EndIf
		EndIf

		; Check intermediate reply before HELO acceptation
		$sReceive = ""
		$hTimer = __TimerInit()
		While StringLeft($sReceive, StringLen($sIntReply)) <> $sIntReply And __TimerDiff($hTimer) < 45000
			$sReceive = TCPRecv($vSocket, 1000)
			If $bTrace And $sReceive <> "" Then __SmtpTrace("intermediate->" & $sReceive)
		WEnd
	EndIf

	; Send string.
	If TCPSend($vSocket, $sSend) = 0 Then
		TCPCloseSocket($vSocket)
		TCPShutdown()
		Return 1; cannot send
	EndIf

	$hTimer = __TimerInit()

	$sReceive = ""
	While $sReceive = "" And __TimerDiff($hTimer) < 45000
		$i += 1
		$sReceive = TCPRecv($vSocket, 1000)
		If $sReplyCode = "" Then ExitLoop
	WEnd

	If $sReplyCode <> "" Then
		; Check replycode
		If $bTrace Then __SmtpTrace($i & " <- " & $sReceive)

		If StringLeft($sReceive, StringLen($sReplyCode)) <> $sReplyCode Then
			TCPCloseSocket($vSocket)
			TCPShutdown()
			If $bTrace Then __SmtpTrace("<-> " & $sReplyCode, 5)
			Return 2; bad receive code
		EndIf
	EndIf

	Return 0
EndFunc   ;==>__SmtpSend

; #FUNCTION# ====================================================================================================================
; Author ........: Florian Fida
; ===============================================================================================================================
Func _TCPIpToName($sIp, $iOption = Default, $hDll = Default)
	Local $iINADDR_NONE = 0xffffffff, $iAF_INET = 2, $sSeparator = @CR
	If $iOption = Default Then $iOption = 0
	If $hDll = Default Then $hDll = "ws2_32.dll"
	Local $avDllCall = DllCall($hDll, "ulong", "inet_addr", "STR", $sIp)
	If @error Then Return SetError(1, 0, "") ; inet_addr DllCall Failed
	Local $vBinIP = $avDllCall[0]
	If $vBinIP = $iINADDR_NONE Then Return SetError(2, 0, "") ; inet_addr Failed
	$avDllCall = DllCall($hDll, "ptr", "gethostbyaddr", "ptr*", $vBinIP, "int", 4, "int", $iAF_INET)
	If @error Then Return SetError(3, 0, "") ; gethostbyaddr DllCall Failed
	Local $pvHostent = $avDllCall[0]
	If $pvHostent = 0 Then
		$avDllCall = DllCall($hDll, "int", "WSAGetLastError")
		If @error Then Return SetError(5, 0, "") ; gethostbyaddr Failed, WSAGetLastError Failed
		Return SetError(4, $avDllCall[0], "") ; gethostbyaddr Failed, WSAGetLastError = @extended
	EndIf
	Local $tHostent = DllStructCreate("ptr;ptr;short;short;ptr", $pvHostent)
	Local $sHostnames = __TCPIpToName_szStringRead(DllStructGetData($tHostent, 1))
	If @error Then Return SetError(6, 0, $sHostnames) ; strlen/sZStringRead Failed
	If $iOption = 1 Then
		Local $tAliases
		$sHostnames &= $sSeparator
		For $i = 0 To 63 ; up to 64 Aliases
			$tAliases = DllStructCreate("ptr", DllStructGetData($tHostent, 2) + ($i * 4))
			If DllStructGetData($tAliases, 1) = 0 Then ExitLoop ; Null Pointer
			$sHostnames &= __TCPIpToName_szStringRead(DllStructGetData($tAliases, 1))
			If @error Then
				SetError(7) ; Error reading array
				ExitLoop
			EndIf
		Next
		Return StringSplit(StringStripWS($sHostnames, $STR_STRIPTRAILING), @CR)
	Else
		Return $sHostnames
	EndIf
EndFunc   ;==>_TCPIpToName

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __TCPIpToName_szStringRead
; Description ...: Used internally within this file, not for general use
; Syntax.........: __TCPIpToName_szStringRead ( $pStr [, $iLen = -1] )
; Author ........: Florian Fida
; ===============================================================================================================================
Func __TCPIpToName_szStringRead($pStr, $iLen = -1)
	Local $tString
	If $pStr < 1 Then Return "" ; Null Pointer
	If $iLen < 0 Then $iLen = _WinAPI_StringLenA($pStr)
	$tString = DllStructCreate("char[" & $iLen & "]", $pStr)
	If @error Then Return SetError(2, 0, "")
	Return SetExtended($iLen, DllStructGetData($tString, 1))
EndFunc   ;==>__TCPIpToName_szStringRead
