;cash.au3

#include <Array.au3>
#include <Date.au3>

Global $pkInfoArr[0][3]
Global $onlineSearchArr[0][3]

Func _cash($name,ByRef $cashArr,$add=false,$val='')	
	If ($add==false) Then
			If Not(IsArray($cashArr)) Then Return 0
			Local $iIndex = _ArraySearch($cashArr, $name, 0, 0, 1)
			if ($iIndex == -1) Then Return 0
			Local $cashTineDiff = _DateDiff ( 'n', $cashArr[$iIndex][2], _NowCalc())
			if $cashTineDiff > 10 Then
				_ArrayDelete($cashArr, $iIndex)
				Return 0
			EndIf
			_log('from cash')
			Return $cashArr[$iIndex][1]
		Else
;~ 			_log('val='&$val)
			Local $iIndex = _ArraySearch($cashArr, $name, 0, 0, 1)
			if ($iIndex > -1) Then 
				_ArrayDelete($cashArr, $iIndex)
			EndIf
			Local $sFill = $name&"|""|"&_NowCalc()
			$iIndex = _ArrayAdd($cashArr, $sFill)
			$cashArr[$iIndex][1] = $val
	EndIf
EndFunc

;~ _cahshPkInfo('test1',$pkInfoArr,true,'info 1')
;~ _ArrayDisplay($pkInfoArr, "$pkInfoArr")