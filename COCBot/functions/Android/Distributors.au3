; #FUNCTION# ====================================================================================================================
; Name ..........: Distributors
; Description ...: This file contains the detection and get info fucntions for the COC APKs installed
; Syntax ........: None
; Parameters ....:
; Return values .: None
; Author ........: MMHK (11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $NO_COC, $UNKNOWN_COC
Global $aDistributors[19][4]

Func InitializeCOCDistributors() ;initialized in InitializeMBR() after language is detected
	$NO_COC = "<" & GetTranslated(642, 1, "No COC") & ">"
	$UNKNOWN_COC = "<" & GetTranslated(642, 2, "Unknown COC") & ">"

	Dim $aDistributors[19][4] = [ _
		["Google", 				"com.supercell.clashofclans", 					"com.supercell.clashofclans.GameApp",			GetTranslated(642, 11, "Google")], _
		["Kunlun", 				"com.supercell.clashofclans.kunlun", 			"com.supercell.clashofclans.GameAppKunlun",		GetTranslated(642, 12, "Kunlun")], _
		["Qihoo", 				"com.supercell.clashofclans.qihoo", 			"com.supercell.clashofclans.GameAppKunlun",		GetTranslated(642, 13, "Qihoo")], _
		["Baidu", 				"com.supercell.clashofclans.baidu", 			"com.supercell.clashofclans.GameAppKunlun",		GetTranslated(642, 14, "Baidu")], _
		["9game", 				"com.supercell.clashofclans.uc", 				"com.supercell.clashofclans.uc.GameApp",		GetTranslated(642, 15, "9game")], _
		["Wandoujia/Downjoy", 	"com.supercell.clashofclans.wdj", 				"com.supercell.clashofclans.GameAppKunlun",		GetTranslated(642, 16, "Wandoujia/Downjoy")], _
		["Huawei", 				"com.supercell.clashofclans.huawei", 			"com.supercell.clashofclans.GameAppKunlun",		GetTranslated(642, 17, "Huawei")], _
		["OPPO", 				"com.supercell.clashofclans.nearme.gamecenter", "com.supercell.clashofclans.GameAppKunlun",		GetTranslated(642, 18, "OPPO")], _
		["VIVO", 				"com.supercell.clashofclans.vivo", 				"com.supercell.clashofclans.GameAppKunlun",		GetTranslated(642, 19, "VIVO")], _
		["Anzhi", 				"com.supercell.clashofclans.anzhi", 			"com.supercell.clashofclans.GameAppKunlun",		GetTranslated(642, 20, "Anzhi")], _
		["Kaopu", 				"com.supercell.clashofclans.ewan.kaopu", 		"com.supercell.clashofclans.GameAppKunlun",		GetTranslated(642, 21, "Kaopu")], _
		["Lenovo", 				"com.supercell.clashofclans.lenovo", 			"com.supercell.clashofclans.GameAppKunlun",		GetTranslated(642, 22, "Lenovo")], _
		["Guopan", 				"com.supercell.clashofclans.wdj", 				"com.flamingo.sdk.view.WDJSplashActivity",		GetTranslated(642, 23, "Guopan")], _
		["Xiaomi", 				"com.supercell.clashofclans.mi", 				"com.supercell.clashofclans.mi.GameAppXiaomi",	GetTranslated(642, 24, "Xiaomi")], _
		["Haimawan", 			"com.supercell.clashofclans.ewan.hm", 			"cn.ewan.supersdk.activity.SplashActivity",		GetTranslated(642, 25, "Haimawan")], _
		["Leshi", 				"com.supercell.clashofclans.ewan.leshi", 		"cn.ewan.supersdk.activity.SplashActivity",		GetTranslated(642, 26, "Leshi")], _
		["Microvirt", 			"com.supercell.clashofclans.ewan.xyaz", 		"cn.ewan.supersdk.activity.SplashActivity",		GetTranslated(642, 27, "Microvirt")], _
		["Yeshen", 				"com.supercell.clashofclans.ewan.yeshen", 		"cn.ewan.supersdk.activity.SplashActivity",		GetTranslated(642, 28, "Yeshen")], _
		["Aiyouxi", 			"com.supercell.clashofclans.ewan.egame", 		"cn.ewan.supersdk.activity.SplashActivity",		GetTranslated(642, 29, "Aiyouxi")] _
	]
EndFunc

Func GetCOCDistributors()
	Local $sPkgList = StringReplace(_AndroidAdbSendShellCommand("pm list packages clashofclans"), "package:", "")
	If @error <> 0 Or $sPkgList = "" Then Return SetError(1, 0, "") ; ADB error or No COC installed error

	Local $aPkgList = StringSplit($sPkgList, @LF, $STR_ENTIRESPLIT)
	Local $aDList[0]
	Local $bFirstTimeWDJ = True
	Local $iIndex, $wasSilentSetLog

	For $i = 1 To $aPkgList[0]
		$iIndex = _ArraySearch($aDistributors, $aPkgList[$i], 0, 0, 0, 0, 1, 1)
		If @error = 6 Then ; not found
			$wasSilentSetLog = $g_bSilentSetLog
			$g_bSilentSetLog = True
			SetLog("Unrecognized COC Package: " & $aPkgList[$i])
			$g_bSilentSetLog = $wasSilentSetLog
			If $aPkgList[$i] = $g_sUserGamePackage Then _ArrayAdd($aDList, $g_sUserGameDistributor) ;add unknown installed apk info here when matched users ini
		Else
			If $iIndex <> 5 Then
				_ArrayAdd($aDList, $aDistributors[$iIndex][3])
			Else
				If $bFirstTimeWDJ Then ; Speciall treatment for wdj same name package
					_ArrayAdd($aDList, $aDistributors[5][3])
					_ArrayAdd($aDList, $aDistributors[12][3])
					$bFirstTimeWDJ = False
				EndIf
			EndIf
		EndIf
	Next
	If UBound($aDList) = 0 Then Return SetError(2, 0, "") ; All are unrecognized COC packages error
	Return SetError(0, 0, $aDList)
EndFunc

Func GetCOCPackage($sDistributor)
	Local $iIndex = _ArraySearch($aDistributors, $sDistributor, 0, 0, 0, 0, 1, 3)
	If @error = 6 Then ; not found
		Return SetError(1, 0, "")
	Else
		Return SetError(0, 0, $aDistributors[$iIndex][1])
	EndIf
EndFunc

Func GetCOCClass($sDistributor)
	Local $iIndex = _ArraySearch($aDistributors, $sDistributor, 0, 0, 0, 0, 1, 3)
	If @error = 6 Then ; not found
		Return SetError(1, 0, "")
	Else
		Return SetError(0, 0, $aDistributors[$iIndex][2])
	EndIf
EndFunc

Func GetCOCUnTranslated($sDistributor)
	Local $iIndex = _ArraySearch($aDistributors, $sDistributor, 0, 0, 0, 0, 1, 3)
	If @error = 6 Then ; not found
		Return SetError(1, 0, $sDistributor)
	Else
		Return SetError(0, 0, $aDistributors[$iIndex][0])
	EndIf
EndFunc

Func GetCOCTranslated($sDistributor)
	Local $iIndex = _ArraySearch($aDistributors, $sDistributor, 0, 0, 0, 0, 1, 0)
	If @error = 6 Then ; not found
		Return SetError(1, 0, $sDistributor)
	Else
		Return SetError(0, 0, $aDistributors[$iIndex][3])
	EndIf
EndFunc
