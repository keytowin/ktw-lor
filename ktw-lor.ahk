#SingleInstance Force
#NoEnv
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
#include json.ahk ; from https://github.com/Chunjee/json.ahk

; ---------
; ---------
; Variables
; ---------
; ---------

; defining environment variables
EnvGet, ProgramData, AllUsersProfile

; Window Title used for referencing the game window
global gameWinTitle := "ahk_exe LoR.exe"

; coordinate system variables
global fullscreen := false
global playHeight := 0 ; height of the gameplay window in pixels without title bar, borders, etc.
global playWidth := 0 ; width of the gameplay window in pixels without borders, etc.
global zeroX := 0 ; horizontal center of the play area in pixels
global zeroY := 0 ; vertical center of the play area in pixels
global maxX := 0 ; max horizontal distance from center in pixels
global maxY := 0 ; max vertical distance from center in pixels

; ----
; ----
; main
; ----
; ----

if !WinExist(gameWinTitle)
  launch()

if WinExist(gameWinTitle)
  WinGetPos,,,width,height,%gameWinTitle%

fullscreen := true ; TODO: currently no setting for fullscreen; maybe create a function to check if window is fullscreen

zeroX := width / 2 ; horizontal center of the play area

if (fullscreen)
{
  playHeight := height
  playWidth := width
  
  zeroY := height / 2
}
else
{
  ; TODO: get border/title sizes for playHeight/Width
}

; if playWidth/Height get modified due to windowed mode their respective maxes will be different than the fullscreen maxes
maxX := Floor(playWidth / 2)
maxY := Floor(playHeight / 2)

; importing menu positions from file
FileRead, unparsed, data/lor.json
importedPositions := json.parse(unparsed)

; build all screens
global allScreens := buildAllScreens(importedPositions.screens)

; initializing and setting variables used for tracking/navigating coordinate system
global currentScreenID := importedPositions.startingScreen
global previousScreenID := ""
global currentSectionIndex := 1
global currentPositionIndex := 1

global currentScreen := allScreens[currentScreenID]
global currentPosition := currentScreen[currentSectionIndex][currentPositionIndex]

WinActivate, %gameWinTitle%
MoveMouse()
#include ktw-keybindings.ahk
Exit

; --------
; --------
; End main
; --------
; --------

; hotkeys
#include ktw-hotkeys.ahk

; ---------
; ---------
; Functions
; ---------
; ---------

launch()
{
  global
  local settingsFile := ProgramData . "\Riot Games\Metadata\bacon.live\bacon.live.product_settings.yaml"
  local installationDirectory := ""
  
  Loop, read, %settingsFile%
  {
    if InStr(A_LoopReadLine, "product_install_full_path")
    {
      installationDirectory := SubStr(A_LoopReadLine, 29,-1)
      break
    }
  }
  
  Run, %installationDirectory%\LoR.exe,, UseErrorLevel
  
  ; game window opens, closes and then opens again (for some reason)...and then takes a few seconds to load
  WinWait %gameWinTitle%
  WinWaitClose %gameWinTitle%
  WinWait %gameWinTitle%
  sleep 6000 ; TODO: change this to "wait until the home screen is detected"
}

buildAllScreens(screensArray)
{
  local builtScreens := []
  for screenID, obj in screensArray
  {
    if obj.sections ; only screens have "sections"
    {
      builtScreens[screenID] := []
      for index, paID in obj.sections
      {
        builtScreens[screenID][index] := screensArray[paID].positions
      }
    }
  }
  return builtScreens
}

MoveMouse()
{
  global
  ; xPos = percentage distance from center (0) to maxX (1)
  ; xOff = horizontal offset from center in pixels
  ; positive moves to the right; negative moves to the left
  local xOff := maxX * currentPosition.xPos
  local x := zeroX + xOff

  ; yPos = percentage distance from center (0) to maxY (1)
  ; yOff = vertical offset from center in pixels
  ; positive moves up; negative moves down
  local yOff := maxY * currentPosition.yPos
  local y := zeroY - yOff

  MouseMove x,y
}

updatePosition()
{
  currentPosition := currentScreen[currentSectionIndex][currentPositionIndex]
}

rectanglesFromEndpoint()
{
  local api_enabled := true ; currently no way to check if the endpoint is disabled ; TODO: check if endpoint disabled
  local api_port := 21337 ; currently no way to check if port was changed from default ; TODO: check for port number
  local api_gameclient :=  "http://localhost:" . api_port . "/positional-rectangles"

  if !api_enabled
  {
    MsgBox Please enable Third Party Endpoints
    ExitApp
  }
  return json.parse(httpGet(api_gameclient))
}

^!s:: ; Ctrl + Alt + S
SetTimer, showPosition, 750
return

showPosition:
MouseGetPos, actualX, actualY
ShowxPos := coordXToPos(actualX)
ShowyPos := coordYToPos(actualY)

toolTipString := "actualXxY: " . actualX . "x" . actualY . "`nxPos/yPos: " . ShowxPos . "/" . ShowyPos . "`nzeros: " . zeroX . "x" . zeroY . "`nmaxes: " . maxX . "/" . maxY . "`nScreen: " . currentScreen.screenTitle . "`nScreenID: " . currentScreenID . "`nPreviousScreenID: " . previousScreenID . "`nCurrentSectionIndex: " . currentSectionIndex . "`nCurrentPositionIndex: " . currentPositionIndex . "`nCurrent Position: " . currentPosition.label . " (" . actualX . "," . actualY . ")`n-actionType: " . currentPosition.actionType . "`n-actionParameter: " . currentPosition.actionParameter . "`n-up: " . currentPosition.neighbors.up . "`n-down: " . currentPosition.neighbors.down . "`n-left: " . currentPosition.neighbors.left . "`n-right: " . currentPosition.neighbors.right 
ToolTip, %toolTipString%, 500, 0
return

; ----------------
; Helper Functions
; ----------------

allScreensToClipboard()
{
  global
  local allScreensOutput := ""
  for screenID,sectArray in allScreens
  {
    allScreensOutput .= screenID . "`n"
    for sectID,posArray in sectArray
    {
      allScreensOutput .= " Section[" . sectID . "]`n"
      for posID,posObj in posArray
      {
        allScreensOutput .= "  Position[" . posID . "]`n"
        allScreensOutput .= "   label: " . posObj.label . "`n"
        allScreensOutput .= "   xPos: " . posObj.xPos . "`n"
        allScreensOutput .= "   yPos: " . posObj.yPos . "`n"
        allScreensOutput .= "   actionType: " . posObj.actionType . "`n"
        allScreensOutput .= "   actionParameter: " . posObj.actionParameter . "`n"
        allScreensOutput .= "   neighbors`n"
        for direction,directionTarget in posObj.neighbors
        {
          allScreensOutput .= "      " . direction . ": " . directionTarget . " (Sec-" . sectID . " Pos-" . directionTarget . ")`n"
        }
      }    
    }
  }
  clipboard := allScreensOutput
}

; "coord" is a pixel coordinate on the monitor
; "pos" is a % offset from the overlay center
coordXToPos(xCoord)
{
  global
  return (xCoord - zeroX) / maxX
}

coordYToPos(yCoord)
{
  global
  return (zeroY - yCoord) / maxY
}

posXToCoord(xPos)
{
  global
  return (xPos * maxX) + zeroX
}

posYToCoord(yPos)
{
  global
  return zeroY - (maxY * yPos)
}

; ------------------
; Borrowed Functions
; ------------------

; modified documentation example into a function - https://www.autohotkey.com/docs/commands/URLDownloadToFile.htm#WHR
httpGet(request)
{
  local whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
  whr.Open("GET", request, true)
  whr.Send()
  ; Using 'true' above and the call below allows the script to remain responsive.
  whr.WaitForResponse()
  local version := whr.ResponseText
  return version
}