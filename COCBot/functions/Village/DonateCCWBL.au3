; #FUNCTION# ====================================================================================================================
; Name ..........: donateCCWBL
; Description ...: This file includes functions to Donate troops
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016-09)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;collect donation request users images
Func donateCCWBLUserImageCollect($x,$y)

   Local $imagematch = False

	;capture donate request image
	_CaptureRegion(0 , $y -  90, $x -30,$y)
	If $debugImageSave= 1 Then DebugImageSave("donateCCWBLUserImageCollect_",  False, "png",  True)

   ;if OnlyWhiteList enable check and donate TO COMPLETE
   If $debugsetlog=1 then Setlog("Search into whitelist...",$color_purple)
	  Local $xyz
	  $xyz = _FileListToArrayRec($donateimagefoldercaptureWhiteList, "*.png", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
	  if ubound($xyz)>1 then
		 For $i = 1 to ubound($xyz) -1
			Local $result = DllCall($hImgLib, "str", "FindTile", "handle", $hHBitmap, "str", $donateimagefoldercaptureWhiteList & $xyz[$i], "str", "FV", "int", 1)
			If @error Then _logErrorDLLCall($pImgLib, @error)
			If IsArray($result) Then
			   If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $result[0], $COLOR_ERROR)
			   If $result[0] = "0" Or $result[0] = "" Then
				  If $debugsetlog=1 Then SetLog("Image not found", $COLOR_ERROR)
			   ElseIf StringLeft($result[0], 2) = "-1" Then
				  SetLog("DLL Error: " & $result[0], $COLOR_ERROR)
			   Else
				  $expRet = StringSplit($result[0], "|", $STR_NOCOUNT)
				  $posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
				  $xfound = Int($posPoint[0])
				  $yfound = Int($posPoint[1])
				  IF $icmbFilterDonationsCC = 2 then Setlog("WHITE LIST: image match! " & $xyz[$i], $COLOR_SUCCESS)
				  $imagematch = True
				  If $icmbFilterDonationsCC = 2 Then return True ; <=== return DONATE if name found in white list
				  Exitloop
			   EndIf
			EndIf
		 Next
	  EndIf


   ;if OnlyBlackList enable check and donate
   If $debugsetlog=1 then Setlog("Search into blacklist...",$color_purple)
	  Local $xyz1
	  $xyz1 = _FileListToArrayRec($donateimagefoldercaptureBlackList, "*.png", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
	  if ubound($xyz1)>1 then
		 For $i = 1 to ubound($xyz1) -1
			Local $result1 = DllCall($hImgLib, "str", "FindTile", "handle", $hHBitmap, "str", $donateimagefoldercaptureBlackList & $xyz1[$i], "str", "FV", "int", 1)
			If @error Then _logErrorDLLCall($pImgLib, @error)
			If IsArray($result1) Then
			   If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $result1[0], $COLOR_ERROR)
			   If $result1[0] = "0" Or $result1[0] = "" Then
				  If $debugsetlog=1 Then SetLog("Image not found", $COLOR_ERROR)
			   ElseIf StringLeft($result1[0], 2) = "-1" Then
				  SetLog("DLL Error: " & $result1[0], $COLOR_ERROR)
			   Else
				  $expRet = StringSplit($result1[0], "|", $STR_NOCOUNT)
				  $posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
				  $xfound = Int($posPoint[0])
				  $yfound = Int($posPoint[1])
				  If $icmbFilterDonationsCC = 3 Then Setlog("BLACK LIST: image match! " & $xyz1[$i], $COLOR_SUCCESS)
				  $imagematch = True
				  If $icmbFilterDonationsCC = 3 Then return False ; <=== return NO DONATE if name found in black list
				  Exitloop
			   EndIf
			EndIf
		 Next
	  EndIf


   if $imagematch = False and $icmbFilterDonationsCC >0 Then
	  If $debugsetlog=1 then Setlog("Search into images to assign...",$color_purple)
	  ;try to search into images to Assign
	  Local $xyzw
	  $xyzw = _FileListToArrayRec($donateimagefoldercapture, "*.png", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
	  if ubound($xyzw)>1 then
		 For $i = 1 to ubound($xyzw) -1
			Local $resultxyzw = DllCall($hImgLib, "str", "FindTile", "handle", $hHBitmap, "str", $donateimagefoldercapture & $xyzw[$i], "str", "FV", "int", 1)
			If @error Then _logErrorDLLCall($pImgLib, @error)
			If IsArray($resultxyzw) Then
			   If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $resultxyzw[0], $COLOR_ERROR)
			   If $resultxyzw[0] = "0" Or $resultxyzw[0] = "" Then
				  If $debugsetlog=1 Then SetLog("Image not found", $COLOR_ERROR)
			   ElseIf StringLeft($resultxyzw[0], 2) = "-1" Then
				  SetLog("DLL Error: " & $resultxyzw[0], $COLOR_ERROR)
			   Else
				  $expRet = StringSplit($resultxyzw[0], "|", $STR_NOCOUNT)
				  $posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
				  $xfound = Int($posPoint[0])
				  $yfound = Int($posPoint[1])
				  If $icmbFilterDonationsCC = 1 Then Setlog("IMAGES TO ASSIGN: image match! " & $xyzw[$i], $COLOR_SUCCESS)
				  $imagematch = True
				  Exitloop
			   EndIf
			EndIf
		 Next
	  EndIf

	  ;save image (search divider chat line to know position of village name)
	  If $imagematch = False Then
	    If $debugsetlog=1 then Setlog("save image in images to assign...",$color_purple)

		 ;search chat divider line
		 Local $founddivider
		 Local $xfound
		 Local $yfound
		 Local $chat_divider = @ScriptDir & "\imgxml\donateccwbl\chatdivider_0_98.xml"
		 Local $chat_divider_hidden = @ScriptDir & "\imgxml\donateccwbl\chatdividerhidden_0_98.xml"
		 Local $res = DllCall($hImgLib, "str", "FindTile", "handle", $hHBitmap, "str", $chat_divider, "str", "FV", "int", 1)
		 If @error Then _logErrorDLLCall($pImgLib, @error)
		 If IsArray($res) Then
			If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_ERROR)
			If $res[0] = "0" Or $res[0] = "" Then
			   ;SetLog("No Chat divider found, try to found hidden chat divider", $COLOR_ERROR)
			   ;search chat divider hidden
			   Local $reshidden = DllCall($hImgLib, "str", "FindTile", "handle", $hHBitmap, "str", $chat_divider_hidden, "str", "FV", "int", 1)
			   If @error Then _logErrorDLLCall($pImgLib, @error)
			   If IsArray($reshidden) Then
				  If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $reshidden[0], $COLOR_ERROR)
				  If $reshidden[0] = "0" Or $reshidden[0] = "" Then
					 If $debugsetlog= 1 Then SetLog("No Chat divider hidden found", $COLOR_ERROR)
				  ElseIf StringLeft($reshidden[0], 2) = "-1" Then
					 SetLog("DLL Error: " & $reshidden[0], $COLOR_ERROR)
				  Else
					 $expRet = StringSplit($reshidden[0], "|", $STR_NOCOUNT)
					 $posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
					 $xfound = Int($posPoint[0])
					 $yfound = Int($posPoint[1])
					 If $debugsetlog= 1 Then SetLog("ChatDivider hidden found (" & $xfound & "," & $yfound & ")", $COLOR_SUCCESS)
					 ; now crop image to have only request village name and put in $hClone
					 $hClone = _GDIPlus_BitmapCloneArea($hBitmap, 31 , $yfound + 14, 100, 11, $GDIP_PXF24RGB)
					 ;save image
					 Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
					 Local $Time = @HOUR & "." & @MIN & "." & @SEC
					 Local $filename = String("ClanMate_" & $Date & "_" & $Time &  "#.png")
					 _GDIPlus_ImageSaveToFile($hClone, $donateimagefoldercapture &  $filename)
					 If $icmbFilterDonationsCC = 1 Then Setlog("Clan Mate image Stored: " & $filename , $COLOR_SUCCESS)
					 _GDIPlus_ImageDispose($hClone)
				  EndIF
			   EndIf
			ElseIf StringLeft($res[0], 2) = "-1" Then
			   SetLog("DLL Error: " & $res[0], $COLOR_ERROR)
			Else
			   $expRet = StringSplit($res[0], "|", $STR_NOCOUNT)
			   $posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
			   $xfound = Int($posPoint[0])
			   $yfound = Int($posPoint[1])
			   If $DebugSetlog = 1 Then SetLog("ChatDivider found (" & $xfound & "," & $yfound & ")", $COLOR_SUCCESS)
			   ; now crop image to have only request village name and put in $hClone
			   $hClone = _GDIPlus_BitmapCloneArea($hBitmap, 31 , $yfound + 14, 100, 11, $GDIP_PXF24RGB)
			   ;save image
			   Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			   Local $Time = @HOUR & "." & @MIN & "." & @SEC
			   Local $filename = String("ClanMate--" & $Date & "-" & $Time &  "_0_0_98.png")
			   _GDIPlus_ImageSaveToFile($hClone, $donateimagefoldercapture &  $filename)
			   _GDIPlus_ImageDispose($hClone)
			   If $icmbFilterDonationsCC = 1 Then Setlog("IMAGES TO ASSIGN: stored!", $COLOR_SUCCESS)
			   ;remove old files into folder images to assign if are older than 2 days
			   Deletefiles($donateimagefoldercapture, "*.png", 2,  0)
			EndIf
		 EndIf
	  EndIf
   EndIf
   if $icmbFilterDonationsCC <=1 Then
	  return True ; <=== return DONATE if no white or black list set
   ElseIf $icmbFilterDonationsCC = 3 Then
	  return True ; <=== return DONATE if name not found in black list
   Else
	  return False; <=== return NO DONATE
   EndIf
EndFunc
