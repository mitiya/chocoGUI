;modalW.au3
#include-once
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <GuiButton.au3>

Global $GUImodal

Func _modal($text,$prntW)
	if ($GUImodal == '') Then
			Local $pPos = WinGetPos ($prntW), $modWidth = 280, $modHeight = 92
			Local $modL = $pPos[0] + Floor(($pPos[2] - $modWidth)/2)
			Local $modT = $pPos[1] + Floor(($pPos[3] - $modHeight)/2)
			
			$GUImodal = GUICreate("modal",$modWidth,$modHeight,$modL,$modT,$WS_POPUPWINDOW,$WS_EX_TOPMOST,$prntW)
			GUICtrlCreateLabel($text,115,38.5,80,15,-1,-1)	
			GUISetState(@SW_DISABLE,$prntW)
			GUISetState(@SW_SHOW,$GUImodal)
		Else
			GUISetState(@SW_ENABLE,$prntW)
			GUIDelete ($GUImodal)
			$GUImodal = ''
	EndIf
EndFunc

;~ Local $modWidth = 280, $modHeight = 92
;~ Global $GUImodal = GUICreate("modal",$modWidth,$modHeight,-1,-1,$WS_POPUPWINDOW,$WS_EX_TOPMOST,$Gui)
;~ Global $GUImodalL =	GUICtrlCreateLabel('',115,38.5,50,15,-1,-1)		

;~ Func _modal($text,$prntW)
;~ 	_log('moadal state '&WinGetState($GUImodal))
;~ 	if (WinGetState($GUImodal)<6) Then
;~ 			Local $pPos = WinGetPos ($prntW)
;~ 			Local $modL = $pPos[0] + Floor(($pPos[2] - $modWidth)/2)
;~ 			Local $modT = $pPos[1] + Floor(($pPos[3] - $modHeight)/2)
;~ 			
;~ 			WinMove($GUImodal, "", $modL, $modT)
;~ 			GUICtrlSetData ( $GUImodalL, $text)
;~ 			GUISetState(@SW_DISABLE,$prntW)
;~ 			GUISetState(@SW_SHOW,$GUImodal)
;~ 		Else
;~ 			GUISetState(@SW_ENABLE,$prntW)
;~ 			GUISetState(@SW_HIDE,$GUImodal)
;~ 	EndIf
;~ EndFunc

