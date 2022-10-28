; #FUNCTION# ====================================================================================================================
; Name ..........: SuggestedUpgrades()
; Description ...: Goes to Builders Island and Upgrades buildings with 'suggested upgrades window'.
; Syntax ........: SuggestedUpgrades()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; coc-armycamp ---> OCR the values on Builder suggested updates
; coc-build ----> building names and levels [ needs some work on 'u' and 'e' ]  BuildingInfo

; Zoomout
; If Suggested Upgrade window is open [IMAGE] -> C:\Users\user\Documents\MDOCOCPROJECT\imgxml\Resources\PicoBuildersBase\SuggestedUpdates\IsSuggestedWindowOpened_0_92.png
; Image folder [GOLD] -> C:\Users\user\Documents\MDOCOCPROJECT\imgxml\Resources\PicoBuildersBase\SuggestedUpdates\Gold_0_89.png
; Image folder [GOLD] -> C:\Users\user\Documents\MDOCOCPROJECT\imgxml\Resources\PicoBuildersBase\SuggestedUpdates\Elixir_0_89.png

; Buider Icon position Blue[i] [Check color] [360, 11, 0x7cbdde, 10]
; Suggested Upgrade window position [Imgloc] [380, 59, 100, 20]
; Zone to search for Gold / Elixir icons and values [445, 100, 90, 85 ]
; Gold offset for OCR [Point] [x,y, length]  ,x = x , y = - 10  , length = 535 - x , Height = y + 7   [17]
; Elixir offset for OCR [Point] [x,y, length]  ,x = x , y = - 10  , length = 535 - x , Height = y + 7 [17]
; Buider Name OCR ::::: BuildingInfo(242, 580)
; Button Upgrade position [275, 670, 300, 30]  -> UpgradeButton_0_89.png
; Button OK position Check Pixel [430, 540, 0x6dbd1d, 10] and CLICK

; Draft
; 01 - Verify if we are on Builder island [Boolean]
; 01.1 - Verify available builder [ OCR - coc-Builders ] [410 , 23 , 40 ]
; 02 - Click on Builder [i] icon [Check color]
; 03 - Verify if the window opened [Boolean]
; 04 - Detect Gold and Exlir icons [Point] by a dynamic Y [ignore list]
; 05 - With the previous positiosn and a offset , proceeds with OCR : [WHITE] OK , [salmon] Not enough resources will return "" [strings] convert to [integer]
; 06 - Make maths , IF the Gold is selected on GUI , if Elixir is Selected on GUI , and the resources values and min to safe [Boolean]
; 07 - Click on he correct ICon on Suggested Upgrades window [Point]
; 08 - Verify buttons to upgrade [Point] - Detect the Builder name [OCR]
; 09 - Verify the button to upgrade window [point]  -> [Boolean] ->[check pixel][imgloc]
; 10 - Builder Base report
; 11 - DONE

; GUI
; Check Box to enable the function
; Ignore Gold , Ignore Elixir
; Ignore building names
; Setlog

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
Func MainSuggestedUpgradeCode($bDebugImage = $g_bDebugImageSave, $bFinishNow = False)

	; If is not selected return
	If $g_iChkBBSuggestedUpgrades = 0 Then Return
	Local $bDebug = $g_bDebugSetlog
	Local $bScreencap = True

	; Check if you are on Builder island
	If isOnBuilderBase(True) Then
		; Will Open the Suggested Window and check if is OK
		If ClickOnBuilder() Then
			SetLog(" - Upg Window Opened successfully", $COLOR_INFO)
			Local $y = 102, $y1 = 132, $step = 28, $x = 400, $x1 = 540
			; Check for 6  Icons on Window
			For $i = 0 To 8
				Local $bSkipGoldCheck = False
				If $g_iChkBBSuggestedUpgradesIgnoreElixir = 0 And $g_aiCurrentLootBB[$eLootElixirBB] > 250 Then
					; Proceeds with Elixir icon detection
					Local $aResult = GetIconPosition($x, $y, $x1, $y1, $g_sImgAutoUpgradeElixir, "Elixir", $bScreencap, $bDebug, $bDebugImage)
					Switch $aResult[2]
						Case "Elixir"
							Click($aResult[0], $aResult[1], 1)
							If _Sleep(2000) Then Return
							If GetUpgradeButton($aResult[2], $bDebug, $bDebugImage) Then
								ExitLoop
							EndIf
							$bSkipGoldCheck = True
						Case "New"
							If $g_iChkPlacingNewBuildings = 1 Then
								SetLog("[" & $i + 1 & "]" & " New Building detected, Placing it...", $COLOR_INFO)
								If NewBuildings($aResult, $bDebugImage) Then
									ExitLoop
								EndIf
								$bSkipGoldCheck = True
							Else
								SetLog("[" & $i + 1 & "]" & " New Building detected, but not enabled...", $COLOR_INFO)
							EndIf
						Case "NoResources"
							SetLog("[" & $i + 1 & "]" & " Not enough Elixir, continuing...", $COLOR_INFO)
							;ExitLoop ; continue as suggested upgrades are not ordered by amount
							$bSkipGoldCheck = True
						Case Else
							SetLog("[" & $i + 1 & "]" & " Unsupport Elixir icon '" & $aResult[2] & "', continuing...", $COLOR_INFO)
					EndSwitch
				EndIf

				If $g_iChkBBSuggestedUpgradesIgnoreGold = 0 And $g_aiCurrentLootBB[$eLootGoldBB] > 250 And Not $bSkipGoldCheck Then
					; Proceeds with Gold coin detection
					Local $aResult = GetIconPosition($x, $y, $x1, $y1, $g_sImgAutoUpgradeGold, "Gold", $bScreencap, $bDebug, $bDebugImage)
					Switch $aResult[2]
						Case "Gold"
							Click($aResult[0], $aResult[1], 1)
							If _Sleep(2000) Then Return
							If GetUpgradeButton($aResult[2], $bDebug, $bDebugImage) Then
								ExitLoop
							EndIf
						Case "New"
							If $g_iChkPlacingNewBuildings = 1 Then
								SetLog("[" & $i + 1 & "]" & " New Building detected, Placing it...", $COLOR_INFO)
								If NewBuildings($aResult, $bDebugImage) Then
									ExitLoop
								EndIf
							Else
								SetLog("[" & $i + 1 & "]" & " New Building detected, but not enabled...", $COLOR_INFO)
							EndIf
						Case "NoResources"
							SetLog("[" & $i + 1 & "]" & " Not enough Gold, continuing...", $COLOR_INFO)
							;ExitLoop ; continue as suggested upgrades are not ordered by amount
						Case Else
							SetLog("[" & $i + 1 & "]" & " Unsupport Gold icon '" & $aResult[2] & "', continuing...", $COLOR_INFO)
					EndSwitch
				EndIf

				$y += $step
				$y1 += $step
			Next
		EndIf
	EndIf
	
	If $bFinishNow Then FinishNow($bDebugImage)
	
	ClickAway()
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

Func GetIconPosition($x, $y, $x1, $y1, $directory, $Name = "Elixir", $Screencap = True, $Debug = False, $bDebugImage = $g_bDebugImageSave)
	; [0] = x position , [1] y postion , [2] Gold, Elixir or New
	Local $aResult[3] = [-1, -1, ""]

	If QuickMIS("BC1", $directory, $x, $y, $x1, $y1, $Screencap, $Debug) Then
		If $bDebugImage Then SaveDebugRectImage("GetIconPosition", $x & "," & $y & "," & $x1 & "," & $y1)
		; Correct positions to Check Green 'New' Building word
		Local $iYoffset = $g_iQuickMISY - 15, $iY1offset = $g_iQuickMISY + 7
		Local $iX = 300, $iX1 = $g_iQuickMISX
		; Store the values
		$aResult[0] = $g_iQuickMISX
		$aResult[1] = $g_iQuickMISY
		$aResult[2] = $Name
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

Func GetUpgradeButton($sUpgButtom = "", $Debug = False, $bDebugImage = $g_bDebugImageSave)

	;Local $aBtnPos = [360, 500, 180, 50] ; x, y, w, h
	Local $aBtnPos = [360, 460, 380, 120] ; x, y, w, h ; support Battke Machine, broken and upgrade

	If $sUpgButtom = "" Then Return

	;If $sUpgButtom = "Elixir" Then $sUpgButtom = $g_sImgAutoUpgradeBtnElixir
	;If $sUpgButtom = "Gold" Then $sUpgButtom = $g_sImgAutoUpgradeBtnGold

	$sUpgButtom = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\ButtonUpg\"

	If $bDebugImage Then SaveDebugRectImage("GetUpgradeButton", "300, 590, 600, 670")
	If QuickMIS("BC1", $g_sImgAutoUpgradeBtnDir, 300, 590, 600, 670, True, $Debug) Then
		Local $aBuildingName = BuildingInfo(245, 490 + $g_iBottomOffsetY)
		
		SetLog("BuildingName 0 : " & $aBuildingName[0])
		
		If $aBuildingName[0] >= 1 Then
			SetLog("Building: " & $aBuildingName[1], $COLOR_INFO)
			; Verify if is Builder Hall and If is to Upgrade
			If StringInStr($aBuildingName[1], "Hall") And $g_iChkBBSuggestedUpgradesIgnoreHall Then
				SetLog("Ups! Builder Hall is not to Upgrade!", $COLOR_ERROR)
				Return False
				#cs
					ElseIf StringInStr($sBuildingName, "Battle") > 0 Then
					; adjust Battle Machine button pos
					$aBtnPos[0] = 590
					$aBtnPos[1] = 530
				#ce
			EndIf
			If StringInStr($aBuildingName[1], "Wall") And $g_iChkBBSuggestedUpgradesIgnoreWall Then
				SetLog("Ups! Wall is not to Upgrade!", $COLOR_ERROR)
				Return False
			EndIf
			Click($g_iQuickMISX, $g_iQuickMISY, 1)
			If _Sleep(1500) Then Return
			If QuickMIS("BC1", $sUpgButtom, $aBtnPos[0], $aBtnPos[1], $aBtnPos[0] + $aBtnPos[2], $aBtnPos[1] + $aBtnPos[3], True, $Debug) Then
				Click($g_iQuickMISX, $g_iQuickMISY, 1)
				If isGemOpen(True) Then
					SetLog("Upgrade stopped due to insufficient loot", $COLOR_ERROR)
					ClickAway()
					If _Sleep(500) Then Return
					ClickAway()
					Return False
				Else
					SetLog($aBuildingName[1] & " Upgrading!", $COLOR_INFO)
					;ClickAway()
					Return True
				EndIf
			Else
				ClickAway()
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
		Local $ClocksCoordinates = decodeMultipleCoords(findImage("AutoUpgradeClock", $g_sImgAutoUpgradeClock & "\*" ,GetDiamondFromRect("20,250,700,625") , 8, $Screencap))

		If $bDebugImage Then SaveDebugRectImage("AutoUpgradeClock", "20,250,700,625")

		If UBound($ClocksCoordinates) > 0 Then
			SetLog("[Clocks]: " & UBound($ClocksCoordinates), $COLOR_DEBUG)
			For $i = 0 To UBound($ClocksCoordinates) - 1
				Local $Coordinates = $ClocksCoordinates[$i]
				SetLog("Clock Found at : " & $Coordinates[0] & ", " & $Coordinates[1])
				
				; Just in Cause
				If UBound($Coordinates) <> 2 Then
					Click(820, 38, 1) ; exit from Shop
					ExitLoop
				EndIf
				
				; Coordinates for Slot & Tile Zone from Clock position
				Local $x = $Coordinates[0], $y = $Coordinates[1]

				Local $aCostArea = $x & "," & $y & "," & $x + 160 & "," & $y + 75
				Local $aTileArea = $x & "," & $y - 165 & "," & $x + 160 & "," & $y

				; Lets see if exist resources
				; look for white zeros					
				Local $aiUpgZero = decodeSingleCoord(findImage("AutoUpgradeZero", $g_sImgAutoUpgradeZero & "\*" ,GetDiamondFromRect($aCostArea) , 1, $Screencap))
				
				If isArray($aiUpgZero) And Ubound($aiUpgZero) = 2 Then
				
					; Lets se if exist or NOT the Yellow Arrow, If Doesnt exist the [i] icon than exist the Yellow arrow , DONE
					Local $aiInfo = decodeSingleCoord(findImage("AutoUpgradeSlot", $g_sImgAutoUpgradeInfo & "\*" ,GetDiamondFromRect($aTileArea) , 1, $Screencap))
					If IsArray($aiInfo) And Ubound($aiInfo) = 2 Then
						SetLog("Failed to locate Arrow Icon : " & $aiInfo[0] & ", " & $aiInfo[1])
						If $bDebugImage Then SaveDebugRectImage("FoundInfo", $aTileArea)
						
						If $i = UBound($ClocksCoordinates) - 1 Then
							If $g_bDebugSetlog Then SetDebugLog("Slot without enough resources![1]", $COLOR_DEBUG)
							Click(820, 38, 1) ; exit from Shop
							ExitLoop
						EndIf
						ContinueLoop						
					Else
					
						; look for wall
						Local $aiWallCoord = decodeSingleCoord(findImage("AutoUpgradeBBwall", $sImgDir ,GetDiamondFromRect($aTileArea) , 1, $Screencap))
						If IsArray($aiWallCoord) And UBound($aiWallCoord) = 2 Then
							SetLog("Found Wall in Building Menu Tile")
							If $bDebugImage Then SaveDebugRectImage("AutoUpgradeBBwall", $aTileArea)
							Click(820, 38, 1) ; exit from Shop
							
							If _Sleep(100) Then Return False
															
							ClickOnBuilder()
							
							If _Sleep(1000) Then Return False
							ExitLoop
						EndIf				
					

						Local $aiPoint[2]
						$aiPoint[0] = $x + 100
						$aiPoint[1] = $y - 50
						
						If $bDebugImage Then SaveDebugPointImage("Tile", $aiPoint)
						
						Click($x + 100, $y - 50, 1)
						If _Sleep(3000) Then Return
						
						Local $aSearchDiamond = GetReduceDiamond(30)
						If $bDebugImage Then SaveDebugDiamondImage("UpgradeNewBldgYesNo", $aSearchDiamond)
						
						; Lets search for the Correct Symbol on field
						Local $aiYesCoord = decodeSingleCoord(findImage("AutoUpgradeNewBldgYes", $g_sImgAutoUpgradeNewBldgYes & "\*", $aSearchDiamond, 1, $Screencap))
						
						If IsArray($aiYesCoord) And UBound($aiYesCoord) = 2 Then
							ClickP($aiYesCoord)
							SetLog("Placed a new Building on Builder Island! [" & $aiYesCoord[0] & "," & $aiYesCoord[1] & "]", $COLOR_INFO)

							If _Sleep(1000) Then Return

							; Lets check if exist the [x] , Some Buildings like Traps when you place one will give other to place automatically!
							Local $aiNoCoord = decodeSingleCoord(findImage("AutoUpgradeNewBldgNo", $g_sImgAutoUpgradeNewBldgNo & "\*", $aSearchDiamond, 1, $Screencap))
							If IsArray($aiNoCoord) And UBound($aiNoCoord) = 2 Then
								SetLog("Found another building!")
								ClickP($aiNoCoord)								
							EndIf
												
							Return True
						Else
							
							For $j = 0 to 9
								Local $aiNoCoord = decodeSingleCoord(findImage("AutoUpgradeNewBldgNo", $g_sImgAutoUpgradeNewBldgNo & "\*", $aSearchDiamond, 1, $Screencap))
								If IsArray($aiNoCoord) And UBound($aiNoCoord) = 2 Then
									ClickP($aiNoCoord)				
									SetLog("Failed to deploy a new building on BB! [" & $aiNoCoord[0] & "," & $aiNoCoord[1] & "]", $COLOR_ERROR)
									$g_BBBuildingPlacementFailed += 1
									SetLog("BuildingPlacementFailed : " & $g_BBBuildingPlacementFailed, $COLOR_ERROR)

									If _Sleep(100) Then Return False
																	
									ClickOnBuilder()
									
									If _Sleep(1000) Then Return False
									ExitLoop 2
								;Else
								;	SetLog("Failed to locate Cancel button [x]!")
								;	
								;	If _Sleep(100) Then Return False
								;									
								;	ClickOnBuilder()
								;	
								;	If _Sleep(1000) Then Return False
								;	ExitLoop 2
								EndIf
								
								SetLog("Failed to locate Cancel button [x] : " & $j)
								
								If _Sleep(100) Then Return
							Next
						EndIf		
					EndIf
				Else
					If $bDebugImage Then SaveDebugRectImage("NoWhiteZeros", $aCostArea)
					If $g_bDebugSetlog Then SetDebugLog("Slot without enough resources![2]", $COLOR_DEBUG)
					If $i = UBound($ClocksCoordinates) - 1 Then Click(820, 38, 1)
				EndIf
			Next
		Else
			SetLog("Slot without enough resources![3]", $COLOR_INFO)
			Click(820, 38, 1) ; exit from Shop
		EndIf
	EndIf

	Return False

EndFunc   ;==>NewBuildings

Func TestBBUp($iLoop = 0, $bFinishNow = False)
	For $i = 0 to $iLoop
		ZoomOut()
		BuilderBaseReport()
		
		OttoBuildingUpgrades(True, $bFinishNow)
		
		BuilderBaseReport()
		
		MainSuggestedUpgradeCode(True, $bFinishNow)
	
		SetLog("Upgrade BB Building : " & $i)
		If _Sleep(100) Then Return
	Next
	
	Return
EndFunc


Func FinishNow($bDebugImage = $g_bDebugImageSave)

	Local $sFshNowDir = @ScriptDir & "\imgxml\Resources\BuildersBase\AutoUpgrade\FinishNow\*"
	Local $sImgBBFshNowWindow =  @ScriptDir & "\imgxml\Windows\BBFshNowWindow*"

	Local $aFshNowSearch = "300,590,600,670"

	Local $aiFshNowBtn = decodeSingleCoord(findImage("AutoUpgradeFshNow", $sFshNowDir, GetDiamondFromRect($aFshNowSearch), 1, True))

	If $bDebugImage Then SaveDebugRectImage("AutoUpgradeFshNow", $aFshNowSearch)

	If IsArray($aiFshNowBtn) And UBound($aiFshNowBtn) = 2 Then
		ClickP($aiFshNowBtn)

		If _Sleep(250) Then Return

		If IsWindowOpen($sImgBBFshNowWindow, 0, 0, GetDiamondFromRect("330,260,510,300")) Then
		;If IsWindowOpen($sImgBBFshNowWindow) Then
			Click(427, 423)
		EndIf
	EndIf
	
	If _Sleep(250) Then Return
	
	Return
EndFunc

Func DragBBVillageIfNeeded()

EndFunc
