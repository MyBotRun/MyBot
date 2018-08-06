; #FUNCTION# ====================================================================================================================
; Name ..........: BoostBarracks.au3
; Description ...:
; Syntax ........: BoostBarracks(), BoostSpellFactory()
; Parameters ....:
; Return values .: None
; Author ........: MR.ViPER (9/9/2016)
; Modified ......: MR.ViPER (17/10/2016), Fliegerfaust (21/12/2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func BoostBarracks()
	Return BoostTrainBuilding("Barracks", $g_iCmbBoostBarracks, $g_hCmbBoostBarracks)
EndFunc   ;==>BoostBarracks

Func BoostSpellFactory()
	Return BoostTrainBuilding("Spell Factory", $g_iCmbBoostSpellFactory, $g_hCmbBoostSpellFactory)
EndFunc   ;==>BoostSpellFactory

Func BoostTrainBuilding($sName, $iCmbBoost, $iCmbBoostCtrl)
	Local $boosted = False

	If Not $g_bTrainEnabled Or $iCmbBoost <= 0 Then Return $boosted

	Local $aHours = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
	If Not $g_abBoostBarracksHours[$aHours[0]] Then
		SetLog("Boosting " & $sName & " isn't planned, skipping", $COLOR_INFO)
		Return $boosted
	EndIf

	Local $sIsAre = "are"
	SetLog("Boosting " & $sName, $COLOR_INFO)

	If OpenArmyOverview(True, "BoostTrainBuilding()") Then
		If $sName = "Barracks" Then
			OpenTroopsTab(True, "BoostTrainBuilding()")
		ElseIf $sName = "Spell Factory" Then
			OpenSpellsTab(True, "BoostTrainBuilding()")
			$sIsAre = "is"
		Else
			SetDebugLog("BoostTrainBuilding(): $sName called with a wrong Value.", $COLOR_ERROR)
			ClickP($aAway, 1, 0, "#0161")
			_Sleep($DELAYBOOSTBARRACKS2)
			Return $boosted
		EndIf
		Local $aBoostBtn = findButton("BoostBarrack")
		If IsArray($aBoostBtn) Then
			ClickP($aBoostBtn)
			_Sleep($DELAYBOOSTBARRACKS1)
			Local $aGemWindowBtn = findButton("GEM")
			If IsArray($aGemWindowBtn) Then
				ClickP($aGemWindowBtn)
				_Sleep($DELAYBOOSTBARRACKS2)
				If IsArray(findButton("EnterShop")) Then
					SetLog("Not enough gems to boost " & $sName, $COLOR_ERROR)
				Else
					If $iCmbBoost >= 1 And $iCmbBoost <= 24 Then
						$iCmbBoost -= 1
						_GUICtrlComboBox_SetCurSel($iCmbBoostCtrl, $iCmbBoost)
						SetLog("Remaining " & $sName & " Boosts: " & $iCmbBoost, $COLOR_SUCCESS)
					ElseIf $iCmbBoost = 25 Then
						SetLog("Remain " & $sName & " Boosts: Unlimited", $COLOR_SUCCESS)
					EndIf
					$boosted = True
					; Force to get the Remain Time
					If $sName = "Barracks" Then
						$g_aiTimeTrain[0] = 0 ; reset Troop remaining time
					Else
						$g_aiTimeTrain[1] = 0 ; reset Spells remaining time
					EndIf
				EndIf
			EndIf
		Else
			If IsArray(findButton("BarrackBoosted")) Then
				SetLog($sName & " " & $sIsAre & " already boosted", $COLOR_SUCCESS)
			Else
				SetLog($sName & "boost button not found", $COLOR_ERROR)
			EndIf
		EndIf
	EndIf

	ClickP($aAway, 1, 0, "#0161")
	_Sleep($DELAYBOOSTBARRACKS2)
	Return $boosted
EndFunc   ;==>BoostTrainBuilding

Func BoostEverything()
	; Verifying existent Variables to run this routine
	If AllowBoosting("Everything", $g_iCmbBoostEverything) = False Then Return

	SetLog("Boosting Everything .....", $COLOR_INFO)
	If $g_aiClanCastlePos[0] = "" Or $g_aiClanCastlePos[0] = -1 Then
		LocateClanCastle()
		SaveConfig()
		If _Sleep($DELAYBOOSTBARRACKS2) Then Return
	EndIf

	Return BoostPotion("Everything", "Castle", $g_aiClanCastlePos, $g_iCmbBoostEverything, $g_hCmbBoostEverything) = _NowCalc()
	$g_aiTimeTrain[0] = 0 ; reset Troop remaining time
	$g_aiTimeTrain[1] = 0 ; reset Spells remaining time
	$g_aiTimeTrain[2] = 0 ; reset Heroes remaining time

	If _Sleep($DELAYBOOSTBARRACKS3) Then Return
	checkMainScreen(False) ; Check for errors during function
EndFunc   ;==>BoostEverything
