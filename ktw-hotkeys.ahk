; labels referenced by hotkeys in ktw-keybindings.ahk

activate:
  theType := currentPosition.actionType  
  theParameter := currentPosition.actionParameter
  
  switch theType
  {
    case "select":
      Send {Click}
      sleep 50
      return
    case "goToPrevious":
      currentScreenID := previousScreenID
      currentSectionIndex := previousSectionIndex
      currentPositionIndex := previousPositionIndex
      previousScreenID := ""
      Send {Click}
      sleep 50
      currentScreen := allScreens[currentScreenID]
      updatePosition()
      MoveMouse()
      return
    case "changeScreen":
      targetScreen := allScreens[theParameter]
      if targetScreen
      {
        previousScreenID := currentScreenID
        previousSectionIndex := currentSectionIndex
        previousPositionIndex := currentPositionIndex
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
    case "rewardCheck":
      Send {Click}
      sleep 2000 ; 1000
      PixelGetColor, topLeftPixel, 0, 0
      ; if screen has a primary nav
      if (topLeftPixel == 0x275676)
      {
        MsgBox no more rewards
        currentScreenID := "rewards"
      }
      else ; if screen is a rewards screen
      {
        ; if (topLeftPixel == 0x1B1931)
        MsgBox getting rewards
        currentScreenID := "rewardGet"
      }
      currentScreen := allScreens[currentScreenID]
      currentSectionIndex := 1
      currentPositionIndex := 1
      updatePosition()
      
      previousScreenID := ""
      
      MoveMouse()
      return
    default:
      MsgBox Error: Screen type %theType% undefined
      ExitApp
      return
  }
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