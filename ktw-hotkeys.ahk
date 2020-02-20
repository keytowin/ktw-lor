; labels referenced by hotkeys in ktw-keybindings.ahk

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