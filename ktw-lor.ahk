#SingleInstance Force
#NoEnv
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
#include json.ahk ; from https://github.com/Chunjee/json.ahk

; ---------
; ---------
; VARIABLES
; ---------
; ---------

; Window Title used for referencing the game window
global gameWinTitle := "ahk_exe LoR.exe"

; ----
; ----
; MAIN
; ----
; ----

obj := rectanglesFromEndpoint()

testString := obj.PlayerName . " | " . obj.OpponentName . " | " . obj.GameState . " | " . obj.Screen.ScreenWidth . " | " . obj.Screen.ScreenHeight . " | " . obj.Rectangles[1].CardID . " | " . obj.Rectangles[1].CardCode . " | " . obj.Rectangles[1].TopLeftX . " | " . obj.Rectangles[1].TopLeftY . " | " . obj.Rectangles[1].Width . " | " . obj.Rectangles[1].Height . " | " . obj.Rectangles[1].LocalPlayer . " | " . obj.Rectangles.MaxIndex()
  
MsgBox %testString%

; ---------
; ---------
; FUNCTIONS
; ---------
; ---------

; rectanglesFromEndpoint() queries the Game Client API for positions
; returns obj with
; obj.PlayerName
; obj.OpponentName
; obj.GameState
; obj.Screen.ScreenWidth
; obj.Screen.ScreenHeight
; obj.Rectangles[n].CardID
; obj.Rectangles[n].CardCode
; obj.Rectangles[n].TopLeftX - 0 is left
; obj.Rectangles[n].TopLeftY - 0 is down
; obj.Rectangles[n].Width
; obj.Rectangles[n].Height
; obj.Rectangles[n].LocalPlayer

rectanglesFromEndpoint()
{
  local api_enabled := true ; currently no way to check if the endpoint is disabled
  local api_port := 21337 ; currently no way to check if port was changed from default
  local api_gameclient :=  "http://localhost:" . api_port . "/positional-rectangles"

  if !api_enabled
  {
    MsgBox Please enable Third Party Endpoints
    ExitApp
  }

  return json.parse(httpGet(api_gameclient))
}

; modified documentatoin example into a function - https://www.autohotkey.com/docs/commands/URLDownloadToFile.htm#WHR
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