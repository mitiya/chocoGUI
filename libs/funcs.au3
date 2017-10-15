;funcs.au3
#include-once

#include "csv.au3"
#include <Process.au3>
#include <GuiEdit.au3>
#include <Array.au3>
#include "_log.au3"
#include "cash.au3"


Func _SetNotifi ($str,$LB=3)
	Switch $LB
		Case 1
			GUICtrlSetData ( $LBpkCount, $str)
		Case 2
			GUICtrlSetData ( $LBpkCount2, $str)
		Case 3
			GUICtrlSetData ( $LBpkCount, $str)
			GUICtrlSetData ( $LBpkCount2, $str)
	EndSwitch
EndFunc

Func _runCMDgetOut($_cmd,$consoleOut = true,$IShide = True,$dynOut=false)
	_log("_runCMDgetOut cmd=" & $_cmd)
	Local $delay=100
	local $sOut = '' 
	
	if ($IShide == True) Then
			$hide = @SW_HIDE
		Else
			$hide = @SW_MAXIMIZE 
	EndIf
	
	local $iPID = Run($_cmd, @SystemDir, $hide, $STDERR_CHILD + $STDOUT_CHILD)
	
	While 1
		$stOut = StdoutRead($iPID)
		$sOut &= $stOut
		
		$stOut = StderrRead($iPID)
		$sOut &= $stOut
			
		_ProcessGetName ( $iPID )
		if (@error==1 and $stOut=='') Then ExitLoop
		if $dynOut Then _concoleDynOut(True,$sOut,$Gui)
		Sleep($delay)
		If @error Then ExitLoop
	WEnd
	
	if $dynOut Then _concoleDynOut(True,'',$Gui,$sOut)
	
	if ($consoleOut == true) Then
		GUICtrlSetTip($LBpkCount, $sOut)
		GUICtrlSetTip($LBpkCount2, $sOut)
;~ 		GUICtrlSetData ( $E_consoleOut, $sOut)
		_GUICtrlEdit_AppendText( $E_consoleOut, $sOut)
	EndIf
;~ 	_log($sOut)
	if $dynOut Then _concoleDynOut(False,$sOut,$Gui)
	Return $sOut
EndFunc

Func _getInstalledList($SearchStr="",$fast=False)
	Local $hTimer = TimerInit() 
	if ($fast == True) then 
			Local $_localstr = _runCMDgetOut('choco list -r -l ' & $SearchStr,False)
		Else
			if $SearchStr=="" then $SearchStr="all"
;~ 			Local $_localstr = _runCMDgetOut('cup --noop -r ' & $SearchStr,False,True,True)
			Local $_localstr = _getUpdList()
	EndIf
	
	$_localstr = StringRegExpReplace($_localstr, "(?m)^[^|]*$", "")
	
	local $InstListArr = _CSVSplit($_localstr,"|")	
	
	_log('timer='&TimerDiff($hTimer))
	Return $InstListArr
	
EndFunc

Func _getUpdList()
	
	if $isTap2taped == 0 then 
		local $_updLs = _runCMDgetOut('cup --noop -r all',False,True,True)
		Local $_updLsArr = _CSVSplit($_updLs,"|")
;~ 		_ArrayDisplay($_updLsArr, "$_updLsArr")
		for $i=0 to (UBound($_updLsArr)-1)
			_cash($_updLsArr[$i][0],$updLstrArr,True,$_updLsArr[$i][0] & '|' & $_updLsArr[$i][1] & '|' & $_updLsArr[$i][2] & '|' & $_updLsArr[$i][3])
		Next
;~ 		_ArrayDisplay($updLstrArr, "$updLstrArr")
		return $_updLs
	EndIf
	
	Local $_localstr = _runCMDgetOut('choco list -r -l ',False)
	Local $_LocArr = _CSVSplit($_localstr,"|")
	ReDim $_LocArr[UBound($_LocArr)][4]
;~ 	_ArrayDisplay($_LocArr, "")
	
	for $i=0 to (UBound($_LocArr)-1)
;~ 		_log('i='& $i)
		Local $pkName = $_LocArr[$i][0]
;~ 		_log("$pkName="&$pkName)
	
		Local $_updLstr = _cash($pkName,$updLstrArr)
		
		If ($_updLstr == 0) Then
			$_updLstr = _runCMDgetOut('cup --noop -r ' & $pkName,False)
			Local $tmpArr = StringRegExp ( $_updLstr, "(.*)(\|.*)" , 2)
			$_updLstr = $tmpArr[0]	
			_cash($pkName,$updLstrArr,True,$_updLstr)
		EndIf
;~ 		_log($_updLstr)
		Local $_updLstrArr = StringSplit ( $_updLstr, "|" ,2 )
;~ 		_ArrayDisplay($_updLstrArr, "")
		$_LocArr[$i][2]=$_updLstrArr[2]
		$_LocArr[$i][3]=$_updLstrArr[3]
	Next
;~ 	_ArrayDisplay($_LocArr, "")
	Local $out = _ArrayToCSV($_LocArr, '|')
	_log("_getUpdList out= " & $out)
	Return $out
	
EndFunc

Func _Rclick($h,$index)

	local $fn
	
	if (($h == GUICtrlGetHandle($pkLIst)) or ($h == GUICtrlGetHandle($pkInstaledLIst))) then $fn = "info"
	
	Switch $fn
		Case "info"
			_modal(true,"Working...",$Gui)
			Local $pkName = StringSplit (_GUICtrlListView_GetItemTextString ($h, $index),"|",2)
			If IsArray($pkName) Then 
					$pkName = $pkName[0]
				Else
					$pkName = ""
			EndIf		
			_getPkInfo($pkName)
			_modal(false,"Working...",$Gui)
	EndSwitch
	

EndFunc

Func _goToUrl($url)
	ShellExecute($url)
EndFunc

Func _lvItem_textSearch($hListView,$sText)
	Local $iItemIndex = -1
	For $i = 0 To (_GUICtrlListView_GetItemCount($hListView) - 1)
        If (_GUICtrlListView_GetItemTextString($hListView, $i) == $sText) Then
            $iItemIndex = $i
            ExitLoop
        EndIf
    Next
	return $iItemIndex
EndFunc

Func _toggleElement($element)
	if (GUICtrlRead ( $CB_all ) == $GUI_CHECKED) Then 
			GUICtrlSetState ( $element, $GUI_DISABLE )
		Else
			GUICtrlSetState ( $element, $GUI_ENABLE )
	EndIf		
EndFunc

Func _testButton()
	_ArrayDisplay($onlineSearchArr, "$onlineSearchArr")
EndFunc
			
			