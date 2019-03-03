#include <GDIPlus.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>


 HotKeySet("{ESC}", "Terminate")
 HotKeySet("{Pause}", "Pause")

Global $PointStartX = 507
Global $PointStartY = 192
Global $Width
Global $Height

Global $Matrix = MatrixGetColor(@ScriptDir & '\palette.bmp')
ReDim $Matrix[$Width][$Height]
PaintMatrix()


Func MatrixGetColor($sImage)

   Local $hImage, $iWidth, $iHeight, $iBitmap, $hBitmap

   _GDIPlus_Startup()
   $hImage = _GDIPlus_ImageLoadFromFile($sImage)
   $Width = _GDIPlus_ImageGetWidth($hImage)
   $Height = _GDIPlus_ImageGetHeight($hImage)
   $iBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
   $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($iBitmap)

   Dim $iMatrix[$Width][$Height]

   For $H = 0 To $Height - 1
      For $W = 0 To $Width - 1
         $iMatrix[$W][$H] = '0x' & Hex(_GDIPlus_BitmapGetPixel($hBitmap, $W, $H), 6)
      Next
   Next

   _GDIPlus_ImageDispose($hImage)
   _WinAPI_DeleteObject($iBitmap)
   _WinAPI_DeleteObject($hBitmap)
   _GDIPlus_Shutdown()

   Return $iMatrix
EndFunc

Func PaintMatrix()

Local $PointCurrentX = $PointStartX, $PointCurrentY = $PointStartY, $UsedColorsCount = 2, $ColorCurrent, $UsedColors[127], $ColorPainted = False

$UsedColors[0]='0xFFFFFF'
$UsedColors[1]='0xF0F0F0'

   For $X = 0 to $Width - 1
	  $ColorPainted = False

	  For $Y = 0 to $Height - 1
	  $ColorPainted = False

	  $ColorCurrent = $Matrix[$X][$Y]

		 For $I = 0 to $UsedColorsCount

			If $ColorCurrent == $UsedColors[$I]	Then
			$ColorPainted = True
			ExitLoop

			EndIf

		 Next



		 If Not $ColorPainted Then
			$UsedColors[$UsedColorsCount] = $ColorCurrent
			$UsedColorsCount += 1

			Tooltip($UsedColorsCount & $ColorCurrent, 500, 500)

			PickColour($ColorCurrent)
			PaintCurrent($ColorCurrent, $X, $Y)

		 EndIf

		  Tooltip($UsedColorsCount & $ColorCurrent, 500, 500)






	  Next
   Next


EndFunc

Func PickColour($iColour)

MouseClick("left", $PointStartX+78, $PointStartY+323, 1, 10)
Sleep(1000)

For $Shade = 0 to 30
$aCoord = PixelSearch($PointStartX+74, $PointStartY+124, $PointStartX+323, $PointStartY+288, $iColour, $Shade)
   If Not @error Then
	  If PixelGetColor($aCoord[0], $aCoord[1]) == PixelGetColor($aCoord[0], ($aCoord[1]+7)) Then ExitLoop
	  EndIf


   Next

If Not @error Then
   MouseClick("left", $aCoord[0]+5, $aCoord[1]+5, 1, 10)
    EndIf
Sleep(600)
Return
EndFunc

Func PaintCurrent($iColour, $CurrentX, $CurrentY)

   For $tempX = 1 to $Width - 1
	  For $tempY = 1 to $Height - 1
		 If $iColour = $Matrix[$tempX][$tempY] Then
		 MouseClick("left", $PointStartX+$tempX ,$PointStartY+$tempY , 1, 1)
		 EndIf
	  Next

   Next


Return
EndFunc

Func Terminate()
    Exit
EndFunc   ;==>Terminate
