; #FUNCTION# ====================================================================================================================
; Name ..........: TreasuryCollect
; Description ...:
; Syntax ........: TreasuryCollect()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (09-2016)
; Modified ......: Boju (02-2017), Fliegerfaust(11-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TreasuryCollect()
	SetDebugLog("Begin CollectTreasury:", $COLOR_DEBUG1) ; function trace
	If Not $g_bRunState Then Return ; ensure bot is running

	ClearScreen()
	If _Sleep($DELAYRESPOND) Then Return

	If ($g_aiClanCastlePos[0] = "-1" Or $g_aiClanCastlePos[1] = "-1") Then ;check for valid CC location
		SetLog("Need Clan Castle location for the Treasury, Please locate your Clan Castle.", $COLOR_WARNING)
		LocateClanCastle()
		If ($g_aiClanCastlePos[0] = "-1" Or $g_aiClanCastlePos[1] = "-1") Then ; can not assume CC was located due msgbox timeout and unattended bo, must verify
			SetLog("Treasury skipped, bad Clan Castle location", $COLOR_ERROR)
			If _Sleep($DELAYRESPOND) Then Return
			Return
		EndIf
	EndIf
	ClearScreen()
	If _Sleep($DELAYCOLLECT3) Then Return
	BuildingClick($g_aiClanCastlePos[0], $g_aiClanCastlePos[1], "#0250") ; select CC
	If _Sleep($DELAYTREASURY2) Then Return

	Local $bWindow = False
	Local $aTreasuryButton = findButton("Treasury", Default, 1, True)
	If IsArray($aTreasuryButton) And UBound($aTreasuryButton, 0) = 1 And UBound($aTreasuryButton, 1) = 2 Then
		If IsMainPage() Then ClickP($aTreasuryButton, 1, 120, "#0330")
		If _Sleep($DELAYTREASURY1) Then Return
		$bWindow = __WaitTreasuryWindow()
	Else
		; The template predates the CoC 18.600 button bar: locate the chest by colour. The bar can
		; hold other gold-ish spots (costs, badges), so every candidate is tried, best first, until
		; the treasury window really shows up.
		Local $aCand = FindTreasuryButton()
		If IsArray($aCand) Then
			For $i = 0 To UBound($aCand) - 1
				If $i > 0 Then
					SetDebugLog("Treasury: that button was not the chest, trying candidate " & ($i + 1) & " at " & $aCand[$i][0], $COLOR_DEBUG)
					ClearScreen() ; whatever the wrong button opened
					If _Sleep($DELAYRESPOND) Then Return
					BuildingClick($g_aiClanCastlePos[0], $g_aiClanCastlePos[1], "#0250") ; reselect CC
					If _Sleep($DELAYTREASURY2) Then Return
				EndIf
				Click($aCand[$i][0], $aCand[$i][1], 1, 120, "#0330")
				If _Sleep($DELAYTREASURY1) Then Return
				$bWindow = __WaitTreasuryWindow()
				If $bWindow Then ExitLoop
			Next
		Else
			SetLog("Cannot find the Treasury Button", $COLOR_ERROR)
		EndIf
	EndIf

	If Not $bWindow Then
		SetLog("Treasury window not found!", $COLOR_ERROR)
		SaveFailureImage("TreasuryWindow")
		Return
	EndIf

	Local $bForceCollect = False
	; The three bars end at x 703 (gold y 237, elixir 283, dark elixir 329 on CoC 18.600.5); a full
	; bar is green up to its right end. Each bar wears its own shade (0x34A800, 0x90D838, 0x8CD136),
	; none of them the 0x50BD10 the old fixed colour search wanted, so green dominance is tested.
	_CaptureRegion()
	Local $aiBarY[3] = [237, 283, 329]
	For $i = 0 To 2
		Local $sCol = _GetPixelColor(697, $aiBarY[$i], False)
		If StringLen($sCol) <> 6 Then ContinueLoop
		Local $iR = Dec(StringMid($sCol, 1, 2)), $iG = Dec(StringMid($sCol, 3, 2)), $iB = Dec(StringMid($sCol, 5, 2))
		If $iG >= 140 And $iG > $iR + 30 And $iG > $iB + 60 Then
			$bForceCollect = True
			ExitLoop
		EndIf
	Next
	; Treasury window open: collect when a bar is full, or when a storage is at or under its threshold
	; of Village -> Misc -> Treasury. Say which rule fired, or why nothing was taken.
	Local $bLowGold = Number($g_aiCurrentLoot[$eLootGold]) <= Number($g_iTxtTreasuryGold)
	Local $bLowElixir = Number($g_aiCurrentLoot[$eLootElixir]) <= Number($g_iTxtTreasuryElixir)
	Local $bLowDark = Number($g_aiCurrentLoot[$eLootDarkElixir]) <= Number($g_iTxtTreasuryDark)
	Local $bLowStorage = $g_bChkTreasuryCollect And ($bLowGold Or $bLowElixir Or $bLowDark)
	If $bForceCollect Then
		SetLog("Found full Treasury, collecting loot...", $COLOR_SUCCESS)
	ElseIf $bLowStorage Then
		SetLog("Treasury not full, collecting because " & ($bLowGold ? "gold " & _NumberFormat($g_aiCurrentLoot[$eLootGold]) & " <= " & _NumberFormat($g_iTxtTreasuryGold) : ($bLowElixir ? "elixir " & _NumberFormat($g_aiCurrentLoot[$eLootElixir]) & " <= " & _NumberFormat($g_iTxtTreasuryElixir) : "dark elixir " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir]) & " <= " & _NumberFormat($g_iTxtTreasuryDark))), $COLOR_SUCCESS)
	Else
		SetLog("Treasury not full and storages above the thresholds (G " & _NumberFormat($g_aiCurrentLoot[$eLootGold]) & " > " & _NumberFormat($g_iTxtTreasuryGold) & ", E " & _NumberFormat($g_aiCurrentLoot[$eLootElixir]) & " > " & _NumberFormat($g_iTxtTreasuryElixir) & ", DE " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir]) & " > " & _NumberFormat($g_iTxtTreasuryDark) & "), loot left inside", $COLOR_INFO)
	EndIf

	If $bForceCollect Or $bLowStorage Then
		Local $aCollectButton = findButton("Collect", Default, 1, True)
		If Not (IsArray($aCollectButton) And UBound($aCollectButton, 1) = 2) Then $aCollectButton = FindGreenOkayButton() ; same green button, measured at 365-510 x 458-520
		If IsArray($aCollectButton) And UBound($aCollectButton, 1) = 2 Then
			ClickP($aCollectButton, 1, 130, "#0330")
			If _Sleep($DELAYTREASURY2) Then Return
			If ClickOkay("ConfirmCollectTreasury") Then ; Click Okay to confirm collect treasury loot
				SetLog("Treasury collected successfully.", $COLOR_SUCCESS)
			Else
				SetLog("Cannot Click Okay Button on Treasury Collect screen", $COLOR_ERROR)
				CloseWindow2()
				If _Sleep($DELAYTREASURY3) Then Return
				CloseWindow()
			EndIf
		Else
			SetLog("Treasury: cannot find the Collect button, loot left inside", $COLOR_ERROR)
			SaveFailureImage("TreasuryCollectButton")
			CloseWindow()
		EndIf
	Else
		CloseWindow()
	EndIf

	ClearScreen()
	If _Sleep($DELAYTREASURY4) Then Return
EndFunc   ;==>TreasuryCollect

; #FUNCTION# ====================================================================================================================
; Name ..........: FindTreasuryButton
; Description ...: Locates the Treasury button of the Clan Castle bar by the gold of its chest icon
; Syntax ........: FindTreasuryButton()
; Return values .: Array [[x, y, score], ...] of candidate buttons to click, best first, or 0 when the bar shows no such button
; Remarks .......: This file is part of MyBot Copyright 2015-2025
;                  The bar of CoC 18.600.5 (Info, Upgrade, Request, Reinforce, Clan, Treasury, Sleep...) moves its
;                  buttons with the state of the castle, so the button is found rather than assumed. Measured on a
;                  live capture: the chest icon carries 44 gold samples between y 588 and 622 while every other
;                  button carries none, and the upgrade price printed above the bar sits outside that band.
;                  Gold columns (R>200, G>150, B<90) are grouped into clusters (gaps up to 16 px: the dark lock
;                  splits the chest) 20-90 px wide, scored by their gold plus dark-brown (chest frame) samples, and
;                  all of them are returned so the caller can try the next one when a click opens no treasury.
; ===============================================================================================================================
Func FindTreasuryButton()
	_CaptureRegion()
	Local $aCand[0][3]
	Local $iStart = -1, $iLastGold = -1, $iGold = 0, $iBrown = 0
	For $x = 130 To 736 Step 2
		Local $bGold = False, $iColBrown = 0
		If $x <= 730 Then
			For $y = 586 To 624 Step 2
				Local $sCol = _GetPixelColor($x, $y, False)
				If StringLen($sCol) <> 6 Then ContinueLoop
				Local $iR = Dec(StringMid($sCol, 1, 2)), $iG = Dec(StringMid($sCol, 3, 2)), $iB = Dec(StringMid($sCol, 5, 2))
				If $iR > 200 And $iG > 150 And $iB < 90 Then $bGold = True
				If $iR < 120 And $iG < 90 And $iB < 70 And $iR >= $iG And $iG >= $iB And $iR - $iB >= 15 Then $iColBrown += 1
			Next
		EndIf
		If $bGold Then
			If $iStart = -1 Then
				$iStart = $x
				$iGold = 0
				$iBrown = 0
			EndIf
			$iLastGold = $x
			$iGold += 1
		EndIf
		If $iStart <> -1 Then $iBrown += $iColBrown
		If $iStart <> -1 And ($x - $iLastGold > 16 Or $x > 730) Then ; cluster ends after a 16 px gap or at the end of the bar
			Local $iWidth = $iLastGold - $iStart
			If $iWidth >= 20 And $iWidth <= 90 And $iGold >= 6 Then ; the chest shows 13 gold columns, stray spots 1-3
				ReDim $aCand[UBound($aCand) + 1][3]
				$aCand[UBound($aCand) - 1][0] = Int(($iStart + $iLastGold) / 2)
				$aCand[UBound($aCand) - 1][1] = 605
				$aCand[UBound($aCand) - 1][2] = $iGold + $iBrown
				SetDebugLog("FindTreasuryButton: gold cluster " & $iStart & "-" & $iLastGold & " gold " & $iGold & " brown " & $iBrown, $COLOR_DEBUG)
			Else
				SetDebugLog("FindTreasuryButton: gold cluster " & $iStart & "-" & $iLastGold & " ignored (width " & $iWidth & ", gold " & $iGold & ")", $COLOR_DEBUG)
			EndIf
			$iStart = -1
		EndIf
	Next
	If UBound($aCand) = 0 Then
		SetDebugLog("FindTreasuryButton: no chest icon on the bar", $COLOR_DEBUG)
		Return 0
	EndIf
	If UBound($aCand) > 1 Then _ArraySort($aCand, 1, 0, 0, 2) ; best score first
	SetDebugLog("FindTreasuryButton: chest icon at " & $aCand[0][0] & "," & $aCand[0][1] & " (" & UBound($aCand) & " candidate(s))", $COLOR_DEBUG)
	Return $aCand
EndFunc   ;==>FindTreasuryButton

; After the Treasury button was clicked: lets a "You have received..." clan message pass, then waits
; up to 5 s for the treasury window. True when it is open.
Func __WaitTreasuryWindow()
	If _CheckPixel($aReceivedTroopsTreasury, True) Then ; Found the "You have received" Message on Screen, wait till its gone.
		SetDebugLog("Detected Clan Castle Message Blocking Treasury Window. Waiting until it's gone", $COLOR_INFO)
		_CaptureRegion2()
		While _CheckPixel($aReceivedTroopsTreasury, True)
			If _Sleep($DELAYTRAIN1) Then Return False
		WEnd
	EndIf
	WaitForClanMessage("Treasury")
	Return _WaitForCheckPixel($aTreasuryWindow, $g_bCapturePixel, Default, "Wait treasury window:")
EndFunc   ;==>__WaitTreasuryWindow
