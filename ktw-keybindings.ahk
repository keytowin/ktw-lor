; key commands specified here map to labels in ktw-hotkeys.ahk
; ex. key command "Tab" triggers the "goNextSection" label

Hotkey, IfWinActive, %gameWinTitle% ; sets context of hotkeys so they only work while the game window is active
Hotkey, Tab, goNextSection
Hotkey, +Tab, goPreviousSection
Hotkey, Up, goUp
Hotkey, Down, goDown
Hotkey, Left, goLeft
Hotkey, Right, goRight
Hotkey, PgUp, scrollUp
Hotkey, PgDn, scrollDown
Hotkey, q, quitApp