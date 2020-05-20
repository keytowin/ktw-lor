; labels referenced by hotkeys in ktw-keybindings.ahk

activate:
  theType := currentPosition.actionType
  theParameter := currentPosition.actionParameter
  targetScreen := allScreens[theParameter]
  if targetScreen
  {
    Send {Click}
    sleep 50
    currentScreen := targetScreen
    currentScreenID := theParameter
    setupScreen(currentScreenID)
    
    currentSectionIndex := 1
    currentPositionIndex := 1
    updatePosition()
  }
  else
  {
    SoundBeep
  }
  MoveMouse()
  return

goNextSection:
  if currentScreen.MaxIndex() > 1
  {
    currentSectionIndex++
    currentPositionIndex := 1

    ; adjusting currentSectionIndex if necessary
    if currentScreen.MaxIndex() < currentSectionIndex
      currentSectionIndex := currentScreen.MinIndex()
    
    updatePosition()
  }
  else
  {
    SoundBeep
  }
  MoveMouse()
  return

goPreviousSection:
  if currentScreen.MaxIndex() > 1
  {
    currentSectionIndex--
    currentPositionIndex := 1

    ; adjusting currentSectionIndex if necessary    
    if currentScreen.MinIndex() > currentSectionIndex
      currentSectionIndex := currentScreen.MaxIndex()
    
    updatePosition()
  }
  else
  {
    SoundBeep
  }
  MoveMouse()
  return
  

goUp:
  if currentPosition.neighbors.up
  {
    currentPositionIndex := currentPosition.neighbors.up
    updatePosition()
  }
  else
  {
    SoundBeep
  }
  MoveMouse()
  return

goDown:
  if currentPosition.neighbors.down
  {
    currentPositionIndex := currentPosition.neighbors.down
    updatePosition()
  }
  else
  {
    SoundBeep
  }
  MoveMouse()
  return

goLeft:
  if currentPosition.neighbors.left
  {
    currentPositionIndex := currentPosition.neighbors.left
    updatePosition()
  }
  else
  {
    SoundBeep
  }
  MoveMouse()
  return

goRight:
  if currentPosition.neighbors.right
  {
    currentPositionIndex := currentPosition.neighbors.right
    updatePosition()
  }
  else
  {
    SoundBeep
  }
  MoveMouse()
  return

scrollUp:
  Send {WheelUp}
  sleep 50
  return

scrollDown:
  Send {WheelDown}
  sleep 50
  return

quitApp:
  ExitApp
  return

toggleCommandsDisplay:
  commandsDisplayVisible := !commandsDisplayVisible
  Gui, Destroy
  commandDisplayWindowName := "keyboard commands | ktw-lor"
  if (commandsDisplayVisible)
  {
    keyCommandString := toggleCommandsDisplay . " - Hide Keyboard Commands  `n" . close . " - Close ktw-lor `n`n" . nextSection . " - Next section`n" . previousSection . " - Prev section`n" . goUp . " - Move up `n" . goDown . " - Move down `n" . goLeft . " - Move left `n" . goRight . " - Move right `n" . activate . " - Click `n" . scrollUp . " - Scroll up `n" . scrollDown . " - Scroll down `n"
    guiHeight := 150
  }
  else
  {
    keyCommandString := toggleCommandsDisplay . " - Show Keyboard Commands  "
    guiHeight := 10
  }
  Gui, Add, Text, x5 y5 vKeyCommands, %keyCommandString%
  Gui, +AlwaysOnTop
  Gui, Show,x%guiX% y0 h%guiHeight%,%commandDisplayWindowName%
  WinSet, Style, ^0x00C40000, %commandDisplayWindowName%
  WinActivate, %gameWinTitle%
  return