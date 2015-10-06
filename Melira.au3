#cs ----------------------------------------------------------------------------

AutoIt Version: 3.3.14.1
Author: AdaptiveAutomaton

Script Function:
Automate Seer + Melira + Kitchen Finks Combo

#ce ----------------------------------------------------------------------------

#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

;Make F9 Exit Program
HotKeySet("{F9}", "_Quit")
Func _Quit()
   DllClose($dll)
   Exit
EndFunc

;Global variables we are going to use
Global $PriorityColor = 15461355
Global $Seer[2]
Global $Finks[2]
Global $PriorityWindow[2]

$dll = DllOpen("user32.dll")
Opt("GUIOnEventMode", 1)

;Create GUI
#Region ### START Koda GUI section ###
$Form2 = GUICreate("Seer + Melira + Kitchen Finks Combo", 369, 320, 317, 190)
$Done = GUICtrlCreateButton("Done Calibrating", 16, 184, 99, 25, $WS_GROUP)
$Nloops = GUICtrlCreateInput("0", 104, 240, 25, 21, BitOR($ES_RIGHT,$ES_AUTOHSCROLL))
$Label2 = GUICtrlCreateLabel("Number of Loops:", 16, 240, 88, 17, $SS_CENTERIMAGE)
$Run = GUICtrlCreateButton("Run Combo", 16, 264, 75, 25, $WS_GROUP)
$Label1 = GUICtrlCreateLabel("To begin make sure Card Animations, Animate Summoning Sickness, and Animate Foils are all set to Off. Then make sure Viscera Seer is in play, Melira, Sylvok Outcast is in play, Kitchen Finks is in play, and the window that displays the stack will not obscure your creatures when there are many abilities on the stack. Follow the steps below and then click the Done Calibrating button when you are finished.", 16, 16, 346, 81)
$Label6 = GUICtrlCreateLabel("Enter the number of loops you would like to run.", 16, 216, 228, 17)
$Label7 = GUICtrlCreateLabel("1. Hover your mouse over Viscera Seer and press 1.", 16, 104, 250, 17)
$Label8 = GUICtrlCreateLabel("2. Hover your mouse over Kitchen Finks and press 2.", 16, 128, 254, 17)
$Label16 = GUICtrlCreateLabel("Pic", 130, 165, 18, 17)
$Label11 = GUICtrlCreateLabel("3. Hover your mouse over a white area in the bottom right corner of the priority box and press 3.", 16, 152, 342, 33)
$Label12 = GUICtrlCreateLabel("Stop this program at any time by hitting F9 on your keyboard.", 16, 296, 349, 17)
$Label13 = GUICtrlCreateLabel("Pic", 266, 104, 18, 17)
$Label14 = GUICtrlCreateLabel("Pic", 270, 128, 18, 17)
$Label15 = GUICtrlCreateLabel("Pic", 131, 165, 18, 17)
GUICtrlSetFont($Label13, 8.5, 500, 4)
GUICtrlSetColor($Label13, 0x0000FF)
GUICtrlSetCursor($Label13, 0)
GUICtrlSetFont($Label14, 8.5, 500, 4)
GUICtrlSetColor($Label14, 0x0000FF)
GUICtrlSetCursor($Label14, 0)
GUICtrlSetFont($Label15, 8.5, 500, 4)
GUICtrlSetColor($Label15, 0x0000FF)
GUICtrlSetCursor($Label15, 0)
GUICtrlSetFont($Label16, 8.5, 500, 4)
GUICtrlSetColor($Label16, 0x0000FF)
GUICtrlSetCursor($Label16, 0)



GUICtrlSetFont($Label12, 8, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;Listen for button clicks on the GUI
GUICtrlSetOnEvent($Done, "DoneCalibrating")
GUICtrlSetOnEvent($Run, "RunCombo")
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")
GUICtrlSetOnEvent($Label13, "OpenPic1m")
GUICtrlSetOnEvent($Label14, "OpenPic2m")
GUICtrlSetOnEvent($Label16, "OpenPic3m")

;Close program function
Func Close()
   Exit
EndFunc

;Loop to run calibration when program starts
$a=0
While $a == 0
   BeginCalibrating()
Wend

;Loop to keep program open after calibration is done
While 1
   Sleep(100)
Wend

;Functions to open example pics
Func OpenPic1m()
   ShellExecute("pic1m.png")
EndFunc

Func OpenPic2m()
   ShellExecute("pic2m.png")
EndFunc

Func OpenPic3m()
   ShellExecute("pic3m.png")
EndFunc

;Function to finish calibrating
Func DoneCalibrating()
   ;Error handling to make sure all calibrations were done. If all calibrations were done stop the calibration loop
   If $Seer[0]=="" Or $Finks[0]=="" Or $PriorityWindow[0]=="" Then
	  MsgBox ($MB_OK, "Error","Error: Not all calibrations were completed.")
   Else
	  ToolTip('')
	  $a = 1
	  DllClose($dll)
   EndIf
EndFunc

;Function to begin calibrating
Func BeginCalibrating()
   If _IsPressed("31", $dll) Then
	  $Seer = MouseGetPos()
	  ToolTip("Position of Viscera Seer Calibrated")
   EndIf

   If _IsPressed("32", $dll) Then
	  $Finks = MouseGetPos()
	  ToolTip("Position of Kitchen Finks Calibrated")
   EndIf

   If _IsPressed("33", $dll) Then
	  $PriorityWindow = MouseGetPos()
	  ToolTip("Position of Priority Box Calibrated")
   EndIf
EndFunc

;Function to check if we have priority
Func PriorityCheck()
   $h = 1
   While $h == 1
	  If PixelGetColor($PriorityWindow[0], $PriorityWindow[1])-$PriorityColor > 0 Then
		 Sleep(100)
	  Else
		 $h=0
	  EndIf
   WEnd
EndFunc

;Function to check if MTGO is lagging and cards are where they should be
Func LagCheck($xLocation1, $yLocation1, $PixeltoCompare1, $xLocation2, $yLocation2, $PixeltoCompare2)
   $g = 1
   While $g == 1
	  If PixelGetColor($xLocation1, $yLocation1) <> $PixeltoCompare1 or PixelGetColor($xLocation2, $yLocation2) <> $PixeltoCompare2 Then
		 Sleep(100)
	  Else
		 $g=0
	  EndIf
   WEnd
EndFunc

;Function to run the combo
Func RunCombo()
   $Loops = GUICtrlRead($Nloops)-1

   ;Error handling to make sure too many loops aren't being run
   If $Loops > 150 Then
	  MsgBox ($MB_OK, "Error","Error: The number of loops must be less than 150.")

   ;Error handling to make sure calibrations have been completed
   ElseIf $Seer[0]=="" Or $Finks[0]=="" Or $PriorityWindow[0]=="" Then
	  MsgBox ($MB_OK, "Error","Error: Not all calibrations were completed.")

   ;First combo loop to get baseline pixel colors for LagCheck function
Else
	  MouseMove($Seer[0], $Seer[1], 0)
	  Sleep(500)
	  $SeerPlayCheck1 = PixelGetColor($Seer[0], $Seer[1])
	  $SeerPlayCheck2 = PixelGetColor($Seer[0]+10, $Seer[1]+10)

	  MouseClick("primary", $Seer[0], $Seer[1], 1, 0)
	  Sleep(500)
	  MouseClick("primary", $Finks[0], $Finks[1], 1, 0)

	  PriorityCheck()

	  Sleep(1500)

	  $FinksGraveCheck1 = PixelGetColor($Finks[0], $Finks[1])
	  $FinksGraveCheck2 = PixelGetColor($Finks[0]+10, $Finks[1]+10)

	  Send("{F2}")
	  PriorityCheck()

	  Sleep(1500)

	  $FinksPersistCheck1 = PixelGetColor($Finks[0], $Finks[1])
	  $FinksPersistCheck2 = PixelGetColor($Finks[0]+10, $Finks[1]+10)

	  Send("{F2}")
	  PriorityCheck()

	  Sleep(500)

	  $FinksPlayCheck1 = PixelGetColor($Finks[0], $Finks[1])
	  $FinksPlayCheck2 = PixelGetColor($Finks[0]+10, $Finks[1]+10)

	  ;Repeating combo loop
	  $i = 0
	  While $i < $Loops

		 Sleep(200)
		 MouseMove($Seer[0], $Seer[1], 0)
		 LagCheck($Seer[0], $Seer[1], $SeerPlayCheck1, $Seer[0]+10, $Seer[1]+10, $SeerPlayCheck2)
		 MouseClick("primary", $Seer[0], $Seer[1], 1, 0)
		 Sleep(400)
		 MouseMove($Finks[0], $Finks[1], 0)
		 LagCheck($Finks[0], $Finks[1], $FinksPlayCheck1, $Finks[0]+10, $Finks[1]+10, $FinksPlayCheck2)
		 MouseClick("primary", $Finks[0], $Finks[1], 1, 0)

		 PriorityCheck()
		 LagCheck($Finks[0], $Finks[1], $FinksGraveCheck1, $Finks[0]+10, $Finks[1]+10, $FinksGraveCheck2)
		 Sleep(200)
		 Send("{F2}")

		 PriorityCheck()
		 LagCheck($Finks[0], $Finks[1], $FinksPersistCheck1, $Finks[0]+10, $Finks[1]+10, $FinksPersistCheck2)
		 Sleep(200)

		 Send("{F2}")
		 PriorityCheck()
		 $i = $i+1
	  Wend
   EndIf
EndFunc

