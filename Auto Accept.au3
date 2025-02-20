#include <GUIConstantsEx.au3>
#include <Color.au3>
#include <WinAPI.au3>

Global $iniFile = @ScriptDir & "\CS2-AutoAcceptConfig.ini"
Global $coordString = IniRead($iniFile, "Settings", "Coordinates", "1052, 659, 1745, 816")
Global $coords = StringSplit($coordString, ",")

GUICreate("CS 2 Auto-Accept", 300, 150)
GUICtrlCreateLabel("Coordinates", 10, 10)
Global $inputCoords = GUICtrlCreateInput($coordString, 10, 30, 280, 20)
$continuousCheckbox = GUICtrlCreateCheckbox("Continuous", 10, 60, 100, 20)
$saveButton = GUICtrlCreateButton("Save", 10, 90, 80, 30)
$closeButton = GUICtrlCreateButton("Close", 200, 90, 80, 30)

GUISetState(@SW_SHOW)
AdlibRegister("StartAutoAccept", 500)

While 1
    $msg = GUIGetMsg()

    Select
        Case $msg = $GUI_EVENT_CLOSE
            Exit
        Case $msg = $saveButton
            $coordString = GUICtrlRead($inputCoords)
            IniWrite($iniFile, "Settings", "Coordinates", $coordString)
        Case $msg = $closeButton
            Exit
    EndSelect
WEnd

Func StartAutoAccept()
    $coordString = GUICtrlRead($inputCoords)
    $coords = StringSplit($coordString, ",")

    Local $searchColor = 0x36B752
    Local $colorVariance = 10
    Local $colorFound = PixelSearch($coords[1], $coords[2], $coords[3], $coords[4], $searchColor, $colorVariance)

    If Not @error Then
        MouseMove($colorFound[0], $colorFound[1], 0)
        MouseClick("left", $colorFound[0], $colorFound[1], 1, 0)

        If GUICtrlRead($continuousCheckbox) = $GUI_UNCHECKED Then
            Exit
        EndIf
    EndIf
EndFunc
