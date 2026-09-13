; #FUNCTION# ====================================================================================================================
; Name ..........: ClickOkay
; Description ...: checks for window with "Okay" button, and clicks it
; Syntax ........: ClickOkay($FeatureName)
; Parameters ....: $FeatureName         - [optional] String with name of feature calling. Default is "Okay".
; ...............; $bCheckOneTime       - (optional) Boolean flag - only checks for Okay button once
; Return values .: Returns True if button found, if button not found, then returns False and sets @error = 1
; Author ........: MonkeyHunter (2015-12)
;~ ; Modified ......: TFKNazGul (12/11/2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ClickOkay($FeatureName = "Okay", $bCheckOneTime = False)
	Local $i = 0
	Local $aiOkayButton
	If _Sleep($DELAYSPECIALCLICK1) Then Return False ; Wait for Okay button window
	While 1 ; Wait for window with Okay Button
		$aiOkayButton = findButton("Okay", Default, 1, True)
		If Not (IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2) Then $aiOkayButton = FindGreenOkayButton() ; the templates miss the redrawn CoC 18.600 button
		If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
			PureClick($aiOkayButton[0], $aiOkayButton[1], 2, 100, "#0117") ; Click Okay Button
			ExitLoop
		Else
			SetDebugLog("Cannot Find Okay Button", $COLOR_ERROR)
		EndIf
		If $bCheckOneTime Then Return False ; enable external control of loop count or follow on actions, return false if not clicked
		If $i > 5 Then
			SetLog("Can not find button for " & $FeatureName & ", giving up", $COLOR_ERROR)
			SaveFailureImage("OkayButton_" & $FeatureName)
			SetError(1, @extended, False)
			Return
		EndIf
		$i += 1
		If _Sleep($DELAYSPECIALCLICK2) Then Return False ; improve pause button response
	WEnd
	Return True
EndFunc   ;==>ClickOkay

; #FUNCTION# ====================================================================================================================
; Name ..........: FindGreenOkayButton
; Description ...: Locates the big green "Okay" button of a CoC 18.600.5 popup by its colours, wherever the popup is
; Syntax ........: FindGreenOkayButton()
; Return values .: Array [x, y] to click, or 0 when no such button is on screen
; Remarks .......: This file is part of MyBot Copyright 2015-2025
;                  The Okay templates predate the redrawn button, so the "star bonus", "upgrades finished while
;                  you were away" and similar windows were left open. Measured on live captures: the upper half
;                  of the button is a lime gradient (0xD4F480 down to 0xC6EB60, about 150 px wide and 25 px
;                  high), the lower half a darker green (0x6DBC1F), the label white. Popups are centred, so the
;                  scan covers the middle of the screen only, and a run narrower than a button is ignored.
; ===============================================================================================================================
Func FindGreenOkayButton()
	_CaptureRegion()

	Local $iX0 = -1, $iY0 = -1
	For $y = 300 To 700 Step 6
		For $x = 250 To 610 Step 6
			If __IsLimeButton(_GetPixelColor($x, $y, False)) Then
				$iX0 = $x
				$iY0 = $y
				ExitLoop 2
			EndIf
		Next
	Next
	If $iX0 = -1 Then Return 0

	; horizontal run through the first lime pixel
	Local $iXL = $iX0, $iXR = $iX0
	While $iXL > 0 And __IsLimeButton(_GetPixelColor($iXL - 1, $iY0, False))
		$iXL -= 1
	WEnd
	While $iXR < $g_iGAME_WIDTH - 1 And __IsLimeButton(_GetPixelColor($iXR + 1, $iY0, False))
		$iXR += 1
	WEnd
	Local $iWidth = $iXR - $iXL + 1
	If $iWidth < 100 Or $iWidth > 240 Then
		SetDebugLog("FindGreenOkayButton: lime run of " & $iWidth & " px at " & $iXL & "," & $iY0 & " is not a button", $COLOR_DEBUG)
		Return 0
	EndIf
	Local $iXC = Int(($iXL + $iXR) / 2)

	; top edge of the lime band, the label sits about 30 px below it
	Local $iYT = $iY0
	While $iYT > 0 And __IsLimeButton(_GetPixelColor($iXC, $iYT - 1, False))
		$iYT -= 1
	WEnd

	; the white label, sampled across the middle of the button
	Local $iWhite = 0
	For $y = $iYT + 15 To $iYT + 50 Step 2
		For $x = $iXC - 40 To $iXC + 40 Step 3
			Local $sCol = _GetPixelColor($x, $y, False)
			If StringLen($sCol) = 6 And Dec(StringMid($sCol, 1, 2)) > 240 And Dec(StringMid($sCol, 3, 2)) > 240 And Dec(StringMid($sCol, 5, 2)) > 240 Then $iWhite += 1
		Next
	Next
	If $iWhite < 8 Then
		SetDebugLog("FindGreenOkayButton: green band at " & $iXC & "," & $iYT & " carries no label (" & $iWhite & " white samples)", $COLOR_DEBUG)
		Return 0
	EndIf

	Local $aButton[2] = [$iXC, $iYT + 30]
	SetDebugLog("FindGreenOkayButton: button at " & $aButton[0] & "," & $aButton[1] & " (" & $iWidth & " px wide)", $COLOR_DEBUG)
	Return $aButton
EndFunc   ;==>FindGreenOkayButton

; lime gradient of the upper half of the green buttons, 0xD4F480 down to 0xC6EB60
Func __IsLimeButton($sCol)
	If StringLen($sCol) <> 6 Then Return False
	Local $iR = Dec(StringMid($sCol, 1, 2)), $iG = Dec(StringMid($sCol, 3, 2)), $iB = Dec(StringMid($sCol, 5, 2))
	Return ($iG >= 225 And $iR >= 185 And $iR <= 235 And $iB >= 80 And $iB <= 155 And $iG > $iR)
EndFunc   ;==>__IsLimeButton
