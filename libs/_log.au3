#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#include <GUIConstantsEx.au3>
#include <ListBoxConstants.au3>

global $ConsolelistOff = 1
global $Consolelist

global $LogFile = @ScriptDir&"\Mainlog.txt"

global $LogWindow = GUICreate('log console', 500, 500)


$Consolelist = GUICtrlCreateList('', 5, 0, 490, 500)



; _log('fdsfgssg')
if not($ConsolelistOff == 1) then
	GUISetState(@SW_SHOW)
endif


Func _log($txt,$_LogFile = $LogFile)
	Local $timeStamp=(@MDAY & '/' & @MON & '/' & @YEAR & '__' & @HOUR & ':' & @MIN & ':' & @SEC & "  ")
;~ 	FileWriteLine($_LogFile, $timeStamp&" : "&$txt)
	GUICtrlSetData($Consolelist, $timeStamp&" : "&$txt)
;~ 	WinActivate ($LogWindow)
	; GUICtrlCreateListViewItem($timeStamp&" | "&$txt, $Consolelist)
	ConsoleWrite($timeStamp&" : "&$txt&@CRLF)
	return $timeStamp&" : "&$txt
EndFunc