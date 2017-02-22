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





Func imglocTestQuickTrain($quickTrainOption=0)
	Local $currentRunState = $g_bRunState
	$g_bRunState = true
	QuickTrain(1,True,True)
	$g_bRunState = $currentRunState
EndFunc



Func QuickTrain($quickTrainOption, $bOpenAndClose = True,$forceDebug=false)
	if $g_iDebugImageSave = true then
		$forceDebug = true
	endif
	if $forceDebug = true then SetLog("QUICKTRAINDEBUG : START" , $COLOR_RED)
	SetLog("Starting Quick Train", $COLOR_INFO )
	Local $retry = 5 ;#times it retries to find buttons
	If $bOpenAndClose = True Then
		imglocOpenTrainWindow()
		If _Sleep($g_iQuickTrainButtonRetryDelay) Then Return
	EndIf
	Local $optBtn
	Local $QuickTrainTabArea =  "645,110,760,140"
	Local $QuickTrainTabBtn
	Local $CheckTabBtn

	For $rt=0 to $retry
		if $forceDebug = true then SetLog("QUICKTRAINDEBUG : Finding QuickTrainTabBtn Retry: " & $rt , $COLOR_RED)
		$QuickTrainTabBtn  =  isButtonVisible("QuickTrainTabBtn",@ScriptDir & "\imgxml\newtrainwindow\QuickTrain_0_0_93.xml",$QuickTrainTabArea)
		If $QuickTrainTabBtn <> "" then
			if $forceDebug = true then SetLog("QUICKTRAINDEBUG : QuickTrainTabBtn  FOUND Retry: " & $rt & " Clicking Button in: " & $QuickTrainTabBtn, $COLOR_RED)
			ClickP(decodeSingleCoord($QuickTrainTabBtn),1,300,"QuickTrainTabBtn") ; should switch to Quick Train Tab
		Else
			if $forceDebug = true then SetLog("QUICKTRAINDEBUG : QuickTrainTabBtn  NOT FOUND Retry: " & $rt , $COLOR_RED)
		EndIf
		If _Sleep($g_iQuickTrainButtonRetryDelay) Then Return ;forcing sleep to make next button available
		If  $QuickTrainTabBtn <> "" then ExitLoop
		If $forceDebug = true and $rt = $retry then DebugImageSave("QUICKTRAINDEBUG" , True)
	Next

	For $rt=0 to $retry
		;now check tab area to see if tab color is white now (tab opened)
		if $forceDebug = true then SetLog("QUICKTRAINDEBUG : Finding CheckTabBtn Retry: " & $rt , $COLOR_RED)
		$CheckTabBtn  =  isButtonVisible("CheckTabBtn",@ScriptDir & "\imgxml\newtrainwindow\CheckTab_0_0_97.xml",$QuickTrainTabArea) ;check same region for White Area when tab selected
		If _Sleep($g_iQuickTrainButtonRetryDelay) Then Return
		If $CheckTabBtn <> "" then
			if $forceDebug = true then SetLog("QUICKTRAINDEBUG : CheckTabBtn FOUND Retry: " & $rt  & " in " & $CheckTabBtn, $COLOR_RED)
			ExitLoop
		else
			if $forceDebug = true then SetLog("QUICKTRAINDEBUG : CheckTabBtn NOT FOUND Retry: " & $rt , $COLOR_RED)
		EndIf
		if $forceDebug = true and $rt = $retry then DebugImageSave("QUICKTRAINDEBUG" , True)
	Next
	If $CheckTabBtn = "" Then ; not found, tab is not selected
		SetLog("COULD NOT FIND QUICK TRAIN TAB " , $COLOR_RED)
		If $bOpenAndClose = True Then ClickP($aAway, 1, 0, "#0000") ;Click Away
		if $forceDebug = true then SetLog("QUICKTRAINDEBUG : END" , $COLOR_RED)
		Return
	EndIf

	if $forceDebug = true then SetLog("QUICKTRAINDEBUG : ALL BUTONS FOUND, CHECKING SELECTED OPTION " & $quickTrainOption , $COLOR_RED)
	Local $selBtn="", $region = ""
	$optBtn = ""
	Switch $quickTrainOption
		Case 0 ; Previous Army
			$region = "715,195,835,255"
			$optBtn  = isButtonVisible("Previous Army",@ScriptDir & "\imgxml\newtrainwindow\TrainPrevious_0_0_92.xml",$region)
			$selBtn	= "Previous Army"
		Case 1 ; Army 1
			$region = "725,335,840,375"
			$optBtn  = isButtonVisible("Army1",@ScriptDir & "\imgxml\newtrainwindow\TrainArmy_0_0_92.xml",$region)
			$selBtn	= "Army1"
		Case 2 ; Army 2
			$region = "725,455,840,495"
			$optBtn  = isButtonVisible("Army2",@ScriptDir & "\imgxml\newtrainwindow\TrainArmy_0_0_92.xml",$region)
			$selBtn	= "Army2"
		Case 3 ; Army 3
			$region = "725,570,840,615"
			$optBtn  = isButtonVisible("Army3",@ScriptDir & "\imgxml\newtrainwindow\TrainArmy_0_0_92.xml",$region)
			$selBtn	= "Army3"
	EndSwitch

	if $optBtn <> "" then
		if $forceDebug = true then SetLog("QUICKTRAINDEBUG : " & $selBtn & " FOUND , Clicking at " & $optBtn , $COLOR_RED)
		ClickP(decodeSingleCoord($optBtn),1,300, $selBtn ) ;
	else
		if $forceDebug = true then SetLog("QUICKTRAINDEBUG : COULD NOT FIND :" & $selBtn  , $COLOR_RED)
		if $forceDebug = true then DebugImageSave("QUICKTRAINDEBUG" , True)
		if $forceDebug = true then SetLog("QUICKTRAINDEBUG : END" , $COLOR_RED)
	endif

	SetLog("Quick Train Finished", $COLOR_INFO )
	If $bOpenAndClose = True Then ClickP($aAway, 1, 0, "#0000") ;Click Away
EndFunc



Func imglocTrainIfAvailable($nTroopEnum,$iQuantity, $imglocFoundArray)
	Local $sTroopName = decodeTroopEnum($nTroopEnum)
	If $g_iDebugSetlog = 1 Then SetLog($sTroopName & " / " & $nTroopEnum & " training if available!", $COLOR_DEBUG)
	Local $aLineValue
	For $iFA = 0 to ubound($imglocFoundArray) -1
		$aLineValue = $imglocFoundArray[$iFA] ; this should be an array of objectname,objectpoints,filename
		If $aLineValue[0] = $sTroopName Then ; found troop/spell to click
			If $g_iDebugSetlog = 1 Then SetLog($sTroopName & " / " & $nTroopEnum & " found. Checking availability!", $COLOR_DEBUG)
			;lets recheck if button is still available for clicking
			Local $tmpRectArea = GetDummyRectangle($aLineValue[1],20) ; get diamond from coords string using 20px distance
			Local $tmpTileName = $aLineValue[2] ; holds file path needed to recheck if still available for click
			Local $troopBtn =  isButtonVisible($aLineValue[1],$tmpTileName,$tmpRectArea)
			If $troopBtn <> "" then ClickP(decodeSingleCoord($troopBtn),$iQuantity,300,"$aLineValue[1]") ; should click $iQuantity of times

		EndIf
	Next
EndFunc


Func imglocFindAvailableToTrain($sTrainType)
    ;accepts "regular,dark,spells"
	;returns array with all found objects
	Local $sCocDiamond = "15,360|840,365|840,585|15,585" ; diamond of troops / spells in train window
	Local $redLines = $sCocDiamond ; search own village overrride redline
	Local $minLevel=0   ; We only support TH6+
	Local $maxLevel=1000
	Local $maxReturnPoints = 1 ; only need one match for each image
	Local $returnProps="objectname,objectpoints,filepath"
	Local $sDirectory = @ScriptDir & "\imgxml\newtrainwindow\" & $sTrainType & "\"
	If $g_iDebugSetlog = 1 Then SetLog("imgloc Searching Regular Troops :  in " & $sCocDiamond & " using "&  $sDirectory, $COLOR_INFO)
	Local $bForceCapture = True ; force CaptureScreen
	;aux data
	If $g_iDebugSetlog = 1 Then SetLog("imgloc train search : " & $sTrainType, $COLOR_DEBUG)
	Local $hTimer = TimerInit()
	Local $result = findMultiple($sDirectory ,$sCocDiamond ,$redLines, $minLevel, $maxLevel, $maxReturnPoints , $returnProps, $bForceCapture )
	Return $result

EndFunc