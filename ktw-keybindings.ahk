; key commands specified here map to labels in ktw-hotkeys.ahk
; ex. key command "Tab" triggers the "goNextSection" label

activate = Enter
nextSection = Tab
previousSection = +Tab
goUp = Up
goDown = Down
goLeft = Left
goRight = Right
scrollUp = PgUp
scrollDown = PgDn
close = q
toggleCommandsDisplay = F5

Hotkey, IfWinActive, %gameWinTitle% ; sets context of hotkeys so they only work while the game window is active
Hotkey, %activate%, activate
Hotkey, %nextSection%, goNextSection
Hotkey, %previousSection%, goPreviousSection
Hotkey, %goUp%, goUp
Hotkey, %goDown%, goDown
Hotkey, %goLeft%, goLeft
Hotkey, %goRight%, goRight
Hotkey, %scrollUp%, scrollUp
Hotkey, %scrollDown%, scrollDown
Hotkey, %close%, quitApp
Hotkey, %toggleCommandsDisplay%, toggleCommandsDisplay