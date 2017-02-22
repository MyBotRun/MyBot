; #FUNCTION# ====================================================================================================================
; Name ..........: Imgloc Train System Helper functions
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: TRLopes (October 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================




Func imglocOpenTrainWindow()
	;check if chat is open, and close it
	Local $ChatCollapseBtn =  isButtonVisible("ChatCollapseBtn",@ScriptDir & "\imgxml\imglocbuttons\chatopen\CollapseChat_0_94.xml","315,330,350,350")
	If  $ChatCollapseBtn <> "" then ClickP(decodeSingleCoord($ChatCollapseBtn),1,300,"ChatCollapseBtn") ; close chat if it is open

	;check if MainScreen in Open
	;If IsScreenOpen("MainScreen",@ScriptDir & "\imgxml\imglocbuttons\mainwindow\","0,0|225,0|225,732|0,732",4) Then
	If imglocMainScreenReady() Then
		Local $OpenTrainBtn =  isButtonVisible("OpenTrainBtn",@ScriptDir & "\imgxml\imglocbuttons\mainwindow\OpenTrainWindow_0_94.xml","15,560,65,610")
		If $OpenTrainBtn <> "" then ClickP(decodeSingleCoord($openTrainBtn),1,300,"OpenTrainBtn") ; should open Train Window
	Else
		SetLog("Could Not Open Train Window : ", $COLOR_INFO )
	EndIf

EndFunc




Func IsScreenOpen($sScreenName, $sDirectory, $sCocDiamond, $NeededRefs )

	;set Screen Values for multisearch
	If $g_iDebugSetlog = 1 Then SetLog("imgloc Searching for : " & $sScreenName & " in " & $sCocDiamond & " using "&  $sDirectory, $COLOR_INFO)
	Local $redLines = $sCocDiamond ; search own village overrride redline
	Local $minLevel=0   ; We only support TH6+
	Local $maxLevel=1000
	Local $maxReturnPoints = 1 ; only need one match for each image
	Local $returnProps="objectname,objectpoints"

	Local $bForceCapture = True ; force CaptureScreen

	;aux data
	Local $FoundRefs=0
	If $g_iDebugSetlog = 1 Then SetLog("imgloc MainScreen search Start", $COLOR_DEBUG)
	Local $hTimer = TimerInit()
	Local $result = findMultiple($sDirectory ,$sCocDiamond ,$redLines, $minLevel, $maxLevel, $maxReturnPoints , $returnProps, $bForceCapture )
	If IsArray($result) then ;We got return values
		For $fv = 0 to Ubound($result) - 1
		Local $propsValues = $result[$fv]
			If $g_iDebugSetlog = 1 Then SetLog("imgloc Found: " & $propsValues[0] & " at " & $propsValues[1], $COLOR_INFO)
			If $propsValues[0] <> "" And $propsValues[1] <> "" then
				$FoundRefs = $FoundRefs + 1
			EndIf
		Next

	Else
		;thnotfound
		If $g_iDebugSetlog = 1 Then SetLog("imgloc Could not find " & $sScreenName & "!", $COLOR_WARNING)
		If $g_iDebugSetlog = 1 Then SetLog("imgloc " & $sScreenName & " Calculated  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
		Return False
	EndIf

	If $FoundRefs = $NeededRefs then
		Return True
	Else
		Return False
	EndIf

EndFunc





Func isButtonVisible($sBtnName,$sbtnTile,$sBtnPlace)
	;returns string  X,Y or Empty if not found

	If $g_iDebugSetlog = 1 Then SetLog("isButtonVisible : looking for " & $sBtnName & " in " & $sBtnPlace & " with " & $sbtnTile, $COLOR_ORANGE)
	Local $result
	Local $RetunrCoords = "" ; empty value to make sure button is found

	$result = FindImageInPlace($sBtnName,$sbtnTile,$sBtnPlace)

	If $result<>"" Then
		If $g_iDebugSetlog = 1 Or $g_iDebugClick = 1 Then SetLog($sBtnName & " is Visible!", $COLOR_ORANGE)
		$RetunrCoords = $result
		Return $RetunrCoords
	Else
		If ($g_iDebugSetlog = 1 Or $g_iDebugClick = 1) Then SetLog($sBtnName & " is NOT Visible!", $COLOR_ORANGE)
		If $g_iDebugImageSave = 1 Then DebugImageSave("imglocIsMainChatOpenPage")
		Return $RetunrCoords
	EndIF

EndFunc


Func imglocMainScreenReady()
	Local $ChatCollapseBtn =  isButtonVisible("ChatCollapseBtn",@ScriptDir & "\imgxml\imglocbuttons\chatopen\CollapseChat_0_94.xml","315,330,350,350")
	If  $ChatCollapseBtn <> "" then ClickP(decodeSingleCoord($ChatCollapseBtn),1,300,"ChatCollapseBtn") ; close chat if it is open
	Local $ObjBtn
	Local $ReturnValue = True
	 $ObjBtn =  isButtonVisible("AttackBtn",@ScriptDir & "\imgxml\imglocbuttons\mainwindow\Attack_0_95.xml","10,640,110,715")
	If $ObjBtn = "" then
		If $g_iDebugSetlog = 1 Then SetLog("Main Screen is NOT Visible  : AttackBtn NOT VISIBLE!" , $COLOR_ORANGE)
		$ReturnValue = False
		Return False
	EndIf

	$ObjBtn =  isButtonVisible("OpenTrainBtn",@ScriptDir & "\imgxml\imglocbuttons\mainwindow\OpenTrainWindow_0_94.xml","15,560,65,610")
	If $ObjBtn = "" then
		If $g_iDebugSetlog = 1 Then SetLog("Main Screen is NOT Visible  : OpenTrainBtn NOT VISIBLE!" , $COLOR_ORANGE)
		$ReturnValue = False
		Return False
	EndIf
	$ObjBtn =  isButtonVisible("ExpandChatBtn",@ScriptDir & "\imgxml\imglocbuttons\mainwindow\ExpandChat_0_91.xml","0,320,40,440")
	If $ObjBtn = "" then
		If $g_iDebugSetlog = 1 Then SetLog("Main Screen is NOT Visible : ExpandChatBtn NOT VISIBLE!" , $COLOR_ORANGE)
		$ReturnValue = False
		Return False
	EndIf

	if $ReturnValue = True then SetLog("Main Screen is Visible!", $COLOR_ORANGE)
	Return $ReturnValue

EndFunc