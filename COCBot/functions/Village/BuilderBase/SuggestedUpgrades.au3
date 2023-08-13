; #FUNCTION# ====================================================================================================================
; Name ..........: SuggestedUpgrades()
; Description ...: Goes to Builders Island and Upgrades buildings with 'suggested upgrades window'.
; Syntax ........: SuggestedUpgrades()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (05-2017)
; Modified ......: Moebius14 (08-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2023
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func chkActivateBBSuggestedUpgrades()
	; CheckBox Enable Suggested Upgrades [Update values][Update GUI State]
	If GUICtrlRead($g_hChkBBSuggestedUpgrades) = $GUI_CHECKED Then
		$g_iChkBBSuggestedUpgrades = 1
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreGold, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreElixir, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreHall, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreWall, $GUI_ENABLE)
		GUICtrlSetState($g_hChkPlacingNewBuildings, $GUI_ENABLE)
	Else
		$g_iChkBBSuggestedUpgrades = 0
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreGold, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreElixir, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreHall, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreWall, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_hChkPlacingNewBuildings, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	EndIf
EndFunc   ;==>chkActivateBBSuggestedUpgrades

Func chkActivateBBSuggestedUpgradesGold()
	; if disabled, why continue?
	If $g_iChkBBSuggestedUpgrades = 0 Then Return
	; Ignore Upgrade Building with Gold [Update values]
	$g_iChkBBSuggestedUpgradesIgnoreGold = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreGold) = $GUI_CHECKED) ? 1 : 0
	; If Gold is Selected Than we can disable the Builder Hall [is gold] and Wall almost [is Gold]
	If $g_iChkBBSuggestedUpgradesIgnoreGold = 0 Then
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreElixir, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreHall, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreWall, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreElixir, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreHall, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreWall, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	EndIf
	; Ignore Upgrade Builder Hall [Update values]
	$g_iChkBBSuggestedUpgradesIgnoreHall = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreHall) = $GUI_CHECKED) ? 1 : 0
	; Update Elixir value
	$g_iChkBBSuggestedUpgradesIgnoreElixir = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreElixir) = $GUI_CHECKED) ? 1 : 0
	; Ignore Wall
	$g_iChkBBSuggestedUpgradesIgnoreWall = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreWall) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>chkActivateBBSuggestedUpgradesGold

Func chkActivateBBSuggestedUpgradesElixir()
	; if disabled, why continue?
	If $g_iChkBBSuggestedUpgrades = 0 Then Return
	; Ignore Upgrade Building with Elixir [Update values]
	$g_iChkBBSuggestedUpgradesIgnoreElixir = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreElixir) = $GUI_CHECKED) ? 1 : 0
	If $g_iChkBBSuggestedUpgradesIgnoreElixir = 0 Then
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreGold, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreGold, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	EndIf
	; Update Gold value
	$g_iChkBBSuggestedUpgradesIgnoreGold = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreGold) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>chkActivateBBSuggestedUpgradesElixir

Func chkPlacingNewBuildings()
	$g_iChkPlacingNewBuildings = (GUICtrlRead($g_hChkPlacingNewBuildings) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>chkPlacingNewBuildings

; MAIN CODE
Func MainSuggestedUpgradeCode($bDebugImage = $g_bDebugImageSave)

	; If is not selected return
	If $g_iChkBBSuggestedUpgrades = 0 Then Return
	Local $bDebug = $g_bDebugSetlog
	Local $bScreencap = True

	; Master Builder is not available return
	If $g_iFreeBuilderCountBB = 0 Then
		SetLog("No Master Builder available for suggested upgrades !", $COLOR_INFO)
		Return
	EndIf

	; Check if you are on Builder island
	If isOnBuilderBase(True) Then

		While 1

		; Will Open the Suggested Window and check if is OK
			If ClickOnBuilder() Then
				SetLog("Upgrade Window Opened successfully", $COLOR_INFO)
				Local $y = 102, $x = 400, $x1 = 540, $bRet = False
				; Proceeds with icon detection
				Local $aLine = QuickMIS("CNX", $g_sImgAutoUpgradeBB, $x, $y, $x1, 340 + $g_iMidOffsetY)
				_ArraySort($aLine, 0, 0, 0, 2);sort by Y coord
				; Proceeds with icon detection
				If IsArray($aLine) And UBound($aLine) > 0 Then
					For $i = 0 To UBound($aLine) - 1
						Local $g_WallDetected = False
						Local $aResult = GetIconPosition($x, $aLine[$i][2] - 10, $x1, $aLine[$i][2] + 10, $g_sImgAutoUpgradeBB, $bScreencap, $bDebug, $bDebugImage)
						If IsArray($aResult) And UBound($aResult) > 0 Then
							Switch $aResult[2]
								Case "Gold"
									If Not $g_iChkBBSuggestedUpgradesIgnoreGold And $g_aiCurrentLootBB[$eLootGoldBB] > 250 Then
										Click($aResult[0], $aResult[1], 1)
										If _Sleep(2000) Then Return
										If IsWallDetected() Then $g_WallDetected = True
										If GetUpgradeButton($aResult[2], $bDebug, $bDebugImage, $g_WallDetected) Then
											If $g_WallDetected Then
												ExitLoop
											Else
												$g_iFreeBuilderCountBB -= 1
												If $g_iFreeBuilderCountBB = 0 Then
													ExitLoop 2
												Else
													ExitLoop
												EndIf
											EndIf
										EndIf
									EndIf
								Case "Elixir"
									If Not $g_iChkBBSuggestedUpgradesIgnoreElixir And $g_aiCurrentLootBB[$eLootElixirBB] > 250 Then
										Click($aResult[0], $aResult[1], 1)
										If _Sleep(2000) Then Return
										If IsWallDetected() Then $g_WallDetected = True
										If GetUpgradeButton($aResult[2], $bDebug, $bDebugImage, $g_WallDetected, True) Then
											If $g_WallDetected Then
												ExitLoop
											Else
												$g_iFreeBuilderCountBB -= 1
												If $g_iFreeBuilderCountBB = 0 Then
													ExitLoop 2
												Else
													ExitLoop
												EndIf
											EndIf
										EndIf
									EndIf
								Case "New"
									If $g_iChkPlacingNewBuildings = 1 Then
										SetLog("[" & $i + 1 & "]" & " New Building detected, Placing it...", $COLOR_INFO)
										If NewBuildings($aResult, $bDebugImage) Then
											$g_iFreeBuilderCountBB -= 1
											If $g_iFreeBuilderCountBB = 0 Then
												ExitLoop 2
											Else
												ExitLoop
											EndIf
										EndIf
									Else
										SetLog("[" & $i + 1 & "]" & " New Building detected, but not enabled...", $COLOR_INFO)
									EndIf
								Case "NoResources"
									SetLog("[" & $i + 1 & "]" & " Not enough Resource, continuing...", $COLOR_INFO)
								Case Else
									SetLog("[" & $i + 1 & "]" & " Unsupported icon, continuing...", $COLOR_INFO)
							EndSwitch
						EndIf
						If $i = UBound($aLine) - 1 Then $bRet = True
					Next
				Else
					ExitLoop
				EndIf
			Else
				ExitLoop
			EndIf

			If _Sleep(1500) Then Return
			ClickAway("Left")
			If _Sleep(1500) Then Return
			If Not $g_bRunState Then Return
			If $bRet Then ExitLoop

		WEnd

		If _Sleep(1500) Then Return
		ClickAway("Left")
		If _Sleep(500) Then Return
		If Not $g_bRunState Then Return
	EndIf

	If QuickMIS("BC1", $sImgTunnel, 0, 190 + $g_iMidOffsetY, $g_iGAME_WIDTH, $g_iGAME_HEIGHT) Then
		SetLog("Back To Main Builder Base", $COLOR_INFO)
		If $g_iQuickMISName = "TunnelOO" Then
			Click($g_iQuickMISX - Random(25, 70, 1), $g_iQuickMISY + Random(0, 30, 1))
		Else
			Click($g_iQuickMISX - Random(30, 50, 1), $g_iQuickMISY + Random(10, 40, 1))
		EndIf
	EndIf

	If _Sleep(2000) Then Return

	Zoomout()
EndFunc   ;==>MainSuggestedUpgradeCode

; This fucntion will Open the Suggested Window and check if is OK
Func ClickOnBuilder()

	; Master Builder Check pixel [i] icon
	Local Const $aMasterBuilder[4] = [360, 11, 0x7cbdde, 10]
	; Debug Stuff
	Local $sDebugText = ""
	Local Const $Debug = False
	Local Const $Screencap = True

	; Master Builder is not available return
	If $g_iFreeBuilderCountBB = 0 Then SetLog("No Master Builder available! [" & $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB & "]", $COLOR_INFO)

	; Master Builder available
	If $g_iFreeBuilderCountBB > 0 Then
		; Check the Color and click
		If _CheckPixel($aMasterBuilder, True) Then
			; Click on Builder
			Click($aMasterBuilder[0], $aMasterBuilder[1], 1)
			If _Sleep(2000) Then Return
			; Let's verify if the Suggested Window open
			If QuickMIS("BC1", $g_sImgAutoUpgradeWindow, 330, 85, 550, 145, $Screencap, $Debug) Then
				Return True
			Else
				$sDebugText = "Window didn't opened"
			EndIf
		Else
			$sDebugText = "BB Pixel problem"
		EndIf
	EndIf
	If $sDebugText <> "" Then SetLog("Problem on Suggested Upg Window: [" & $sDebugText & "]", $COLOR_ERROR)
	Return False
EndFunc   ;==>ClickOnBuilder

Func GetIconPosition($x, $y, $x1, $y1, $directory, $Screencap = True, $Debug = False, $bDebugImage = $g_bDebugImageSave)
	; [0] = x position , [1] y postion , [2] Gold, Elixir or New
	Local $aResult[3] = [-1, -1, ""]

	If QuickMIS("BC1", $directory, $x, $y, $x1, $y1, $Screencap, $Debug) Then
		If $bDebugImage Then SaveDebugRectImage("GetIconPosition", $x & "," & $y & "," & $x1 & "," & $y1)
		; Correct positions to Check Green 'New' Building word
		Local $iYoffset = $g_iQuickMISY - 15, $iY1offset = $g_iQuickMISY + 7
		Local $iX = 285, $iX1 = $g_iQuickMISX
		; Store the values
		$aResult[0] = $g_iQuickMISX
		$aResult[1] = $g_iQuickMISY
		$aResult[2] = $g_iQuickMISName
		; The pink/salmon color on zeros
		If QuickMIS("BC1", $g_sImgAutoUpgradeNoRes, $aResult[0], $iYoffset, $aResult[0] + 100, $iY1offset, True, $Debug) Then
			; Store new values
			$aResult[2] = "NoResources"
			Return $aResult
		EndIf
		; Proceeds with 'New' detection
		If QuickMIS("BC1", $g_sImgAutoUpgradeNew, $iX, $iYoffset, $iX1, $iY1offset, True, $Debug) Then
			; Store new values
			$aResult[0] = $g_iQuickMISX + 35
			$aResult[1] = $g_iQuickMISY
			$aResult[2] = "New"
		EndIf
	EndIf

	Return $aResult
EndFunc   ;==>GetIconPosition

Func IsWallDetected()
	Local $aBuildingName = BuildingInfo(245, 490 + $g_iBottomOffsetY)
	If StringInStr($aBuildingName[1], "Wall") And Not $g_iChkBBSuggestedUpgradesIgnoreWall Then Return True
	Return False
EndFunc

Func GetUpgradeButton($sUpgButton = "", $Debug = False, $bDebugImage = $g_bDebugImageSave, $bWallUpgrade = False, $ElixForced = False)
	Local $sIconBarDiamond = GetDiamondFromRect2(140, 531 + $g_iBottomOffsetY, 720, 611 + $g_iBottomOffsetY)
	Local $sUpgradeButtonDiamond = GetDiamondFromRect2(350, 460 + $g_iMidOffsetY, 750, 570 + $g_iMidOffsetY)

	If $sUpgButton = "" Then Return

	$sUpgButton = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\ButtonUpg\*"

	If $bDebugImage Then SaveDebugDiamondImage("GetUpgradeButton", $sIconBarDiamond)

	; search icon bar for 'upgrade' icon
	Local $aUpgradeIcon = decodeSingleCoord(findImage("GetUpgradeButon", $g_sImgAutoUpgradeBtnDir & "\*", $sIconBarDiamond, 1, True))
	If IsArray($aUpgradeIcon) And UBound($aUpgradeIcon) = 2 Then
		Local $aBuildingName = BuildingInfo(245, 490 + $g_iBottomOffsetY) ; read building text
		SetDebugLog("BuildingName 0 : " & $aBuildingName[0])
		If $aBuildingName[0] >= 1 Then
			SetLog("Building: " & $aBuildingName[1], $COLOR_INFO)
			; Verify if is Builder Hall and If is to Upgrade
			If StringInStr($aBuildingName[1], "Hall") And $g_iChkBBSuggestedUpgradesIgnoreHall Then
				SetLog("Ups! Builder Hall is not to Upgrade!", $COLOR_ERROR)
				Return False
			EndIf
			If StringInStr($aBuildingName[1], "Wall") And $g_iChkBBSuggestedUpgradesIgnoreWall Then
				SetLog("Ups! Wall is not to Upgrade!", $COLOR_ERROR)
				Return False
			EndIf

			;Wall Double Button Case
			If $bWallUpgrade Then
				If WaitforPixel($aUpgradeIcon[0], $aUpgradeIcon[1] - 60, $aUpgradeIcon[0] + 30, $aUpgradeIcon[1] - 40, "FF887F", 20, 2) Or $ElixForced Then ; Red On Gold Or Was Elix in Menu
					If UBound(decodeSingleCoord(FindImageInPlace2("UpgradeButton2", $g_sImgUpgradeBtn2Wall, $aUpgradeIcon[0] + 65, $aUpgradeIcon[1] - 44, _
					$aUpgradeIcon[0] + 140, $aUpgradeIcon[1] - 10, True))) > 1 Then	$aUpgradeIcon[0] += 94
				EndIf
			EndIf

			ClickP($aUpgradeIcon)
			
			; wait for Upgrade Window to open
			If _Sleep(1500) Then Return

			; missing check for Upgrade Window

			If $bDebugImage Then SaveDebugDiamondImage("GetUpgradeButton", $sUpgradeButtonDiamond)
			
			; search for 'resources' upgrade button
			Local $aUpgradeButton = decodeSingleCoord(findImage("GetUpgradeButon", $sUpgButton, $sUpgradeButtonDiamond, 1, True))
			If IsArray($aUpgradeButton) And UBound($aUpgradeButton) = 2 Then

				ClickP($aUpgradeButton)

				If isGemOpen(True) Then
					SetLog("Upgrade stopped due to insufficient loot", $COLOR_ERROR)
					CloseWindow() ; GEM Window
					CloseWindow() ; upgrade Window
					
					Return False
				Else
					SetLog($aBuildingName[1] & " Upgrading!", $COLOR_INFO)
					Return True
				EndIf
			Else
				CloseWindow()
				SetLog("Not enough Resources to Upgrade " & $aBuildingName[1] & " !", $COLOR_ERROR)
			EndIf

		EndIf
	EndIf

	Return False
EndFunc   ;==>GetUpgradeButton

Func NewBuildings($aResult, $bDebugImage = $g_bDebugImageSave)

	Local $sImgDir = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\NewBuildings\Buildings\*"
	Local $Screencap = True, $Debug = False

	If $g_BBBuildingPlacementFailed > 5 Then
		$g_BBBuildingPlacementFailed = 0
		$g_BBVillageDrag += 1
		If $g_BBVillageDrag > 3 Then $g_BBVillageDrag = 0
		; write to config?
	EndIf

	If $g_BBVillageDrag > 0 Then
		If $g_BBVillageDrag = 1 Then ClickDrag(300,85,250,85) ; drag left
		If $g_BBVillageDrag = 2 Then ClickDrag(300,85,350,85) ; drag right
		If $g_BBVillageDrag = 3 Then ClickDrag(300,85,300,135) ; drag down

		If Not ClickOnBuilder() Then Return False
	EndIf

	If UBound($aResult) = 3 And $aResult[2] = "New" Then

		; The $g_iQuickMISX and $g_iQuickMISY haves the coordinates compansation from 'New' | GetIconPosition()
		Click($aResult[0], $aResult[1], 1)
		If _Sleep(3000) Then Return

		; If exist Clocks
		Local $sSearchDiamond =  GetDiamondFromRect2(16, 220 + $g_iMidOffsetY, 700, 595 + $g_iMidOffsetY)
		Local $ClocksCoordinates = QuickMIS("CNX", $g_sImgAutoUpgradeClock, 16, 220 + $g_iMidOffsetY, 700, 595 + $g_iMidOffsetY)

		If $bDebugImage Then SaveDebugDiamondImage("AutoUpgradeClock", $sSearchDiamond)

		If IsArray($ClocksCoordinates) And UBound($ClocksCoordinates) > 0 Then
			SetLog("[Clocks]: " & UBound($ClocksCoordinates), $COLOR_DEBUG)
			For $i = 0 To UBound($ClocksCoordinates) - 1
				SetLog("Clock " & $i + 1 & " Found at : " & $ClocksCoordinates[$i][1] & ", " & $ClocksCoordinates[$i][2])

				; Just in Case
				If $ClocksCoordinates[$i][1] = "" Or $ClocksCoordinates[$i][2] = "" Then
					CloseWindow()
					ExitLoop
				EndIf

				; Coordinates for Slot & Tile Zone from Clock position
				Local $aCostArea = $ClocksCoordinates[$i][1] & "," & $ClocksCoordinates[$i][2] & "," & $ClocksCoordinates[$i][1] + 160 & "," & $ClocksCoordinates[$i][2] + 75
				Local $aTileArea = $ClocksCoordinates[$i][1] + 120 & "," & $ClocksCoordinates[$i][2] - 177 & "," & $ClocksCoordinates[$i][1] + 160 & "," & $ClocksCoordinates[$i][2] - 127

				; Lets see if exist resources
				; look for white zeros
				If QuickMIS("BC1", $g_sImgAutoUpgradeZero, $ClocksCoordinates[$i][1], $ClocksCoordinates[$i][2], $ClocksCoordinates[$i][1] + 160, $ClocksCoordinates[$i][2] + 75) Then

					; Lets se if exist or NOT the Yellow Arrow, If Doesnt exist the [i] icon than exist the Yellow arrow , DONE
					Local $InfoButton = False
					If QuickMIS("BC1", $g_sImgAutoUpgradeInfo, $ClocksCoordinates[$i][1] + 120, $ClocksCoordinates[$i][2] - 177, $ClocksCoordinates[$i][1] + 160, $ClocksCoordinates[$i][2] - 127) Then	$InfoButton = True

					If $InfoButton Then
						SetLog("Failed to locate Arrow, looking next...")
						If $bDebugImage Then SaveDebugRectImage("FoundInfo", $aTileArea)
						
						If $i = UBound($ClocksCoordinates) - 1 Then
							If $g_bDebugSetlog Then SetDebugLog("Slot without enough resources![1]", $COLOR_DEBUG)
							CloseWindow()
							ExitLoop
						EndIf
						ContinueLoop
					Else

						; look for wall
						If QuickMIS("BC1", $sImgDir, $ClocksCoordinates[$i][1] + 120, $ClocksCoordinates[$i][2] - 177, $ClocksCoordinates[$i][1] + 160, $ClocksCoordinates[$i][2] - 127) Then
							SetLog("Found Wall in Building Menu Tile")
							If $bDebugImage Then SaveDebugRectImage("AutoUpgradeBBwall", $aTileArea)
							CloseWindow()

							If _Sleep(100) Then Return False

							ClickOnBuilder()

							If _Sleep(1000) Then Return False
							ExitLoop
						EndIf

						Local $aiPoint[2]
						$aiPoint[0] = $ClocksCoordinates[$i][1] + 120
						$aiPoint[1] = $ClocksCoordinates[$i][2] - 77

						If $bDebugImage Then SaveDebugPointImage("Tile", $aiPoint)

						Click($ClocksCoordinates[$i][1] + 70, $ClocksCoordinates[$i][2] - 50, 1)
						If _Sleep(3000) Then Return

						Local $aSearchDiamond = GetReduceDiamond(30)
						If $bDebugImage Then SaveDebugDiamondImage("UpgradeNewBldgYesNo", $aSearchDiamond)

						; Lets search for the Correct Symbol on field
						If QuickMIS("BC1", $g_sImgAutoUpgradeNewBldgYes, $aSearchDiamond) Then
							Click($g_iQuickMISX, $g_iQuickMISY)
							SetLog("Placed a new Building on Builder Base!", $COLOR_INFO)

							If _Sleep(1000) Then Return

							; Lets check if exist the [x] , Some Buildings like Traps when you place one will give other to place automatically!
							If QuickMIS("BC1", $g_sImgAutoUpgradeNewBldgNo, $aSearchDiamond) Then
								SetLog("Found another building!")
								Click($g_iQuickMISX, $g_iQuickMISY)
							EndIf

							Return True
						Else

							For $j = 0 to 9
								If QuickMIS("BC1", $g_sImgAutoUpgradeNewBldgNo, $aSearchDiamond) Then
									Click($g_iQuickMISX, $g_iQuickMISY)
									SetLog("Failed to deploy a new building on BB! [" & $g_iQuickMISX & "," & $g_iQuickMISY & "]", $COLOR_ERROR)
									$g_BBBuildingPlacementFailed += 1
									SetLog("BuildingPlacementFailed : " & $g_BBBuildingPlacementFailed, $COLOR_ERROR)

									If _Sleep(100) Then Return False

									ClickOnBuilder()

									If _Sleep(1000) Then Return False
									ExitLoop 2
								EndIf

								SetLog("Failed to locate Cancel button [x] : " & $j)

								If _Sleep(100) Then Return
							Next
						EndIf
					EndIf
				Else
					If $bDebugImage Then SaveDebugRectImage("NoWhiteZeros", $aCostArea)
					If $g_bDebugSetlog Then SetDebugLog("Slot without enough resources![2]", $COLOR_DEBUG)
					If $i = UBound($ClocksCoordinates) - 1 Then CloseWindow()
				EndIf
			Next
		Else
			SetLog("Slot without enough resources![3]", $COLOR_INFO)
			CloseWindow()
		EndIf
	EndIf

	SetLog("Failed to place new building")
	If _Sleep(1000) Then Return
	Return False

EndFunc   ;==>NewBuildings