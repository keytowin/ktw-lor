# ktw-lor
KeyToWin-Legends of Runeterra
Attempting to make Legends of Runeterra playable without a mouse

---

## Try it out

### Prerequisites
* MS Windows
* [Install AutoHotKey v1.1](https://www.autohotkey.com/download/ahk-install.exe)
  * Note: [Link above throws Google Safe Browsing false positive](https://www.autohotkey.com/download/safe.htm)
* Clone this repository

---

### Running
1. Download/install all prerequisites
2. Run ktw-lor.ahk

Please [create an issue](https://github.com/keytowin/ktw-lor/issues/new) for any oddness you encounter.

---

### What the script currently does
* Launches LoR (if it's already installed)
* Creates an overlay for the Home screen
  * Does not currently check for the Quests dialog that appears daily when a new quest is added to the list
* Moves the mouse to the "Home" button
* Also see General Commands below

---

## Controls

### General Commands
* arrow keys: Move position
  * will beep if you can't arrow in a particular direction
* Tab: Next section
  * will beep if there is only one section
* Shift+Tab: Previous section
  * will beep if there is only one section
* Space or Enter: Click
* Shift+Space: Right-click
* q: Exit