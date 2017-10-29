; #FUNCTION# ====================================================================================================================
; Name ..........: Imgloc Train System Helper functions
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Trlopes (10-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================




Func imglocOpenTrainWindow()
	;check if chat is open, and close it
	Local $ChatCollapseBtn = isButtonVisible("ChatCollapseBtn", @ScriptDir & "\imgxml\imglocbuttons\chatopen\CollapseChat_0_94.xml", "315,330,350,350")
	If $ChatCollapseBtn <> "" Then ClickP(decodeSingleCoord($ChatCollapseBtn), 1, 300, "ChatCollapseBtn") ; close chat if it is open

	;check if MainScreen in Open
	;If IsScreenOpen("MainScreen",@ScriptDir & "\imgxml\imglocbuttons\mainwindow\","0,0|225,0|225,732|0,732",4) Then
	If imglocMainScreenReady() Then
		Local $OpenTrainBtn = isButtonVisible("OpenTrainBtn", @ScriptDir & "\imgxml\imglocbuttons\mainwindow\OpenTrainWindow_0_94.xml", "15,560,65,610")
		If $OpenTrainBtn <> "" Then ClickP(decodeSingleCoord($OpenTrainBtn), 1, 300, "OpenTrainBtn") ; should open Train Window
	Else
		SetLog("Could Not Open Train Window : ", $COLOR_INFO)
	EndIf

EndFunc   ;==>imglocOpenTrainWindow




Func IsScreenOpen($sScreenName, $sDirectory, $sCocDiamond, $NeededRefs)

	;set Screen Values for multisearch
	If $g_bDebugSetlog Then SetLog("imgloc Searching for : " & $sScreenName & " in " & $sCocDiamond & " using " & $sDirectory, $COLOR_INFO)
	Local $redLines = $sCocDiamond ; search own village overrride redline
	Local $minLevel = 0 ; We only support TH6+
	Local $maxLevel = 1000
	Local $maxReturnPoints = 1 ; only need one match for each image
	Local $returnProps = "objectname,objectpoints"

	Local $bForceCapture = True ; force CaptureScreen

	;aux data
	Local $FoundRefs = 0
	If $g_bDebugSetlog Then SetLog("imgloc MainScreen search Start", $COLOR_DEBUG)
	Local $hTimer = __TimerInit()
	Local $result = findMultiple($sDirectory, $sCocDiamond, $redLines, $minLevel, $maxLevel, $maxReturnPoints, $returnProps, $bForceCapture)
	If IsArray($result) Then ;We got return values
		For $fv = 0 To UBound($result) - 1
			Local $propsValues = $result[$fv]
			If $g_bDebugSetlog Then SetLog("imgloc Found: " & $propsValues[0] & " at " & $propsValues[1], $COLOR_INFO)
			If $propsValues[0] <> "" And $propsValues[1] <> "" Then
				$FoundRefs = $FoundRefs + 1
			EndIf
		Next

	Else
		;thnotfound
		If $g_bDebugSetlog Then SetLog("imgloc Could not find " & $sScreenName & "!", $COLOR_WARNING)
		If $g_bDebugSetlog Then SetLog("imgloc " & $sScreenName & " Calculated  (in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds) :")
		Return False
	EndIf

	If $FoundRefs = $NeededRefs Then
		Return True
	Else
		Return False
	EndIf

EndFunc   ;==>IsScreenOpen





Func isButtonVisible($sBtnName, $sbtnTile, $sBtnPlace)
	;returns string  X,Y or Empty if not found

	If $g_bDebugSetlog Then SetLog("isButtonVisible : looking for " & $sBtnName & " in " & $sBtnPlace & " with " & $sbtnTile, $COLOR_ORANGE)
	Local $result
	Local $RetunrCoords = "" ; empty value to make sure button is found

	$result = FindImageInPlace($sBtnName, $sbtnTile, $sBtnPlace)

	If $result <> "" Then
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog($sBtnName & " is Visible!", $COLOR_ORANGE)
		$RetunrCoords = $result
		Return $RetunrCoords
	Else
		If ($g_bDebugSetlog Or $g_bDebugClick) Then SetLog($sBtnName & " is NOT Visible!", $COLOR_ORANGE)
		If $g_bDebugImageSave Then DebugImageSave("imglocIsMainChatOpenPage")
		Return $RetunrCoords
	EndIf

EndFunc   ;==>isButtonVisible


Func imglocMainScreenReady()
	Local $ChatCollapseBtn = isButtonVisible("ChatCollapseBtn", @ScriptDir & "\imgxml\imglocbuttons\chatopen\CollapseChat_0_94.xml", "315,330,350,350")
	If $ChatCollapseBtn <> "" Then ClickP(decodeSingleCoord($ChatCollapseBtn), 1, 300, "ChatCollapseBtn") ; close chat if it is open
	Local $ObjBtn
	Local $ReturnValue = True
	$ObjBtn = isButtonVisible("AttackBtn", @ScriptDir & "\imgxml\imglocbuttons\mainwindow\Attack_0_95.xml", "10,640,110,715")
	If $ObjBtn = "" Then
		If $g_bDebugSetlog Then SetLog("Main Screen is NOT Visible  : AttackBtn NOT VISIBLE!", $COLOR_ORANGE)
		$ReturnValue = False
		Return False
	EndIf

	$ObjBtn = isButtonVisible("OpenTrainBtn", @ScriptDir & "\imgxml\imglocbuttons\mainwindow\OpenTrainWindow_0_94.xml", "15,560,65,610")
	If $ObjBtn = "" Then
		If $g_bDebugSetlog Then SetLog("Main Screen is NOT Visible  : OpenTrainBtn NOT VISIBLE!", $COLOR_ORANGE)
		$ReturnValue = False
		Return False
	EndIf
	$ObjBtn = isButtonVisible("ExpandChatBtn", @ScriptDir & "\imgxml\imglocbuttons\mainwindow\ExpandChat_0_91.xml", "0,320,40,440")
	If $ObjBtn = "" Then
		If $g_bDebugSetlog Then SetLog("Main Screen is NOT Visible : ExpandChatBtn NOT VISIBLE!", $COLOR_ORANGE)
		$ReturnValue = False
		Return False
	EndIf

	If $ReturnValue Then SetLog("Main Screen is Visible!", $COLOR_ORANGE)
	Return $ReturnValue

EndFunc   ;==>imglocMainScreenReady
