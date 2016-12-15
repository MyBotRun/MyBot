
; #FUNCTION# ====================================================================================================================
; Name ..........: Collect
; Description ...:
; Syntax ........: Collect()
; Parameters ....:
; Return values .: None
; Author ........: Code Gorilla #3
; Modified ......: Sardo 2015-08, KnowJack(Aug 2015), kaganus (August 2015), ProMac (04-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Collect()
	If $iChkCollect <> 1 Then Return
	If $RunState = False Then Return

	ClickP($aAway, 1, 0, "#0332") ;Click Away

	StartGainCost()
	checkAttackDisable($iTaBChkIdle) ; Early Take-A-Break detection

	SetLog("Collecting Resources", $COLOR_INFO)
	If _Sleep($iDelayCollect2) Then Return

	; Collect function to Parallel Search , will run all pictures inside the directory
	Local $directory = @ScriptDir & "\imgxml\Resources\Collect"
	; Setup arrays, including default return values for $return
	Local $Filename = ""
	Local $CollectXY

	Local $aResult = returnMultipleMatchesOwnVillage($directory)
	If UBound($aResult) > 1 Then
		For $i = 1 To UBound($aResult) - 1
			$Filename = $aResult[$i][1] ; Filename
			$CollectXY = $aResult[$i][5] ; Coords
			If IsMainPage() Then
				If IsArray($CollectXY) Then
					For $t = 0 To UBound($CollectXY) - 1 ; each filename can have several positions
						If isInsideDiamondXY($CollectXY[$t][0], $CollectXY[$t][1]) Then
							If $DebugSetLog = 1 Then SetLog($Filename & " found (" & $CollectXY[$t][0] & "," & $CollectXY[$t][1] & ")", $COLOR_SUCCESS)
							If $iUseRandomClick = 0 then
								Click($CollectXY[$t][0], $CollectXY[$t][1], 1, 0, "#0430")
								If _Sleep($iDelayCollect2) Then Return
							Else
								ClickZone($CollectXY[$t][0], $CollectXY[$t][1], 5, "#0430")
								_Sleep(Random($iDelayCollect2, $iDelayCollect2 * 4, 1))
							EndIF
						EndIf
					Next
				EndIf
			EndIf
		Next
	EndIf

	If _Sleep($iDelayCollect3) Then Return
	checkMainScreen(False) ; check if errors during function
		; Loot Cart Collect Function

		Setlog("Searching for a Loot Cart..", $COLOR_INFO)

		Local $LootCart = @ScriptDir & "\imgxml\Resources\LootCart\loot_cart_0_85.xml"
		Local $LootCartX, $LootCartY

		$ToleranceImgLoc = 0.850
		Local $fullCocAreas = "ECD"
		Local $MaxReturnPoints = 1

		_CaptureRegion2()
		Local $res = DllCall($hImgLib, "str", "FindTile", "handle", $hHBitmap2, "str", $LootCart, "str", $fullCocAreas, "Int", $MaxReturnPoints)
		If @error Then _logErrorDLLCall($pImgLib, @error)
		If IsArray($res) Then
			If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_ERROR)
			If $res[0] = "0" Or $res[0] = "" Then
				SetLog("No Loot Cart found, Yard is clean!", $COLOR_SUCCESS)
			ElseIf StringLeft($res[0], 2) = "-1" Then
				SetLog("DLL Error: " & $res[0], $COLOR_ERROR)
			Else
				$expRet = StringSplit($res[0], "|", $STR_NOCOUNT)
				;$expret contains 2 positions; 0 is the total objects; 1 is the point in X,Y format
				$posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
				$LootCartX = Int($posPoint[0])
				$LootCartY = Int($posPoint[1])
				If isInsideDiamondXY($LootCartX, $LootCartY) Then
					If $DebugSetlog Then SetLog("LootCart found (" & $LootCartX & "," & $LootCartY & ")", $COLOR_SUCCESS)
					If IsMainPage() Then Click($LootCartX, $LootCartY, 1, 0, "#0330")
					If _Sleep($iDelayCollect1) Then Return

					;Get LootCart info confirming the name
					Local $sInfo = BuildingInfo(242, 520 + $bottomOffsetY); 860x780
					If @error Then SetError(0, 0, 0)
					Local $CountGetInfo = 0
					While IsArray($sInfo) = False
						$sInfo = BuildingInfo(242, 520 + $bottomOffsetY); 860x780
						If @error Then SetError(0, 0, 0)
						If _Sleep($iDelayCollect1) Then Return
						$CountGetInfo += 1
						If $CountGetInfo >= 5 Then Return
					WEnd
					If $DebugSetlog Then SetLog(_ArrayToString($sInfo, " "), $COLOR_DEBUG)
					If @error Then Return SetError(0, 0, 0)
					If $sInfo[0] > 1 Or $sInfo[0] = "" Then
						If StringInStr($sInfo[1], "Loot") = 0 Then
							If $DebugSetlog Then SetLog("Bad Loot Cart location", $COLOR_ACTION)
						Else
							If IsMainPage() Then Click($aLootCartBtn[0], $aLootCartBtn[1], 1, 0, "#0331") ;Click loot cart button
						EndIf
					EndIf
				Else
					Setlog("Loot Cart not removed, please do manually!", $COLOR_WARNING)
				EndIf
			EndIf
		EndIf

	EndGainCost("Collect")
 EndFunc   ;==>Collect
