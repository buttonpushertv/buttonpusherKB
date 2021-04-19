; ====================
; === INSTRUCTIONS ===
; ====================
; 1. Any lines starting with ; are ignored
; 2. After changing this config file run script file "desktop_switcher.ahk"
; 3. Every line is in the format HOTKEY::ACTION

; === SYMBOLS ===
; !   <- Alt
; +   <- Shift
; ^   <- Ctrl
; #   <- Win
; For more, visit https://autohotkey.com/docs/Hotkeys.htm

; === EXAMPLES ===
; !n::switchDesktopToRight()             <- <Alt> + <N> will switch to the next desktop (to the right of the current one)
; #!space::switchDesktopToRight()        <- <Win> + <Alt> + <Space> will switch to next desktop
; CapsLock & n::switchDesktopToRight()   <- <CapsLock> + <N> will switch to the next desktop (& is necessary when using non-modifier key such as CapsLock)

; ===========================
; === END OF INSTRUCTIONS ===
; ===========================

CapsLock & 1::switchDesktopByNumber(1) ; <-- Switch to Windows Virtual Desktop 1
CapsLock & 2::switchDesktopByNumber(2) ; <-- Switch to Windows Virtual Desktop 2
CapsLock & 3::switchDesktopByNumber(3) ; <-- Switch to Windows Virtual Desktop 3
CapsLock & 4::switchDesktopByNumber(4) ; <-- Switch to Windows Virtual Desktop 4
CapsLock & 5::switchDesktopByNumber(5) ; <-- Switch to Windows Virtual Desktop 5
CapsLock & 6::switchDesktopByNumber(6) ; <-- Switch to Windows Virtual Desktop 6
CapsLock & 7::switchDesktopByNumber(7) ; <-- Switch to Windows Virtual Desktop 7
CapsLock & 8::switchDesktopByNumber(8) ; <-- Switch to Windows Virtual Desktop 8
CapsLock & 9::switchDesktopByNumber(9) ; <-- Switch to Windows Virtual Desktop 9

;CapsLock & Numpad1::MoveCurrentWindowToDesktop(1) ; <-- Move Current/Active Window to Desktop 1
;CapsLock & Numpad2::MoveCurrentWindowToDesktop(2) ; <-- Move Current/Active Window to Desktop 2
;CapsLock & Numpad3::MoveCurrentWindowToDesktop(3) ; <-- Move Current/Active Window to Desktop 3
;CapsLock & Numpad4::MoveCurrentWindowToDesktop(4) ; <-- Move Current/Active Window to Desktop 4
;CapsLock & Numpad5::MoveCurrentWindowToDesktop(5) ; <-- Move Current/Active Window to Desktop 5
;CapsLock & Numpad6::MoveCurrentWindowToDesktop(6) ; <-- Move Current/Active Window to Desktop 6
;CapsLock & Numpad7::MoveCurrentWindowToDesktop(7) ; <-- Move Current/Active Window to Desktop 7
;CapsLock & Numpad8::MoveCurrentWindowToDesktop(8) ; <-- Move Current/Active Window to Desktop 8
;CapsLock & Numpad9::MoveCurrentWindowToDesktop(9) ; <-- Move Current/Active Window to Desktop 9

;CapsLock & =::switchDesktopToRight() ; <-- Switch to the Desktop to the Right - will loop to Desktop 1 when on the Last Desktop
;CapsLock & -::switchDesktopToLeft() ; <-- Switch to the Desktop to the Right - will loop to Last Desktop when on First Desktop
CapsLock & s::switchDesktopToRight() ; <-- Switch to the Desktop to the Right - will loop to Desktop 1 when on the Last Desktop
CapsLock & a::switchDesktopToLeft() ; <-- Switch to the Desktop to the Right - will loop to Last Desktop when on First Desktop
CapsLock & tab::switchDesktopToLastOpened() ; <-- Switch to the Last Used Desktop (prior to the Current Desktop)

CapsLock & c::createVirtualDesktop() ; <-- Create new Virtual Desktop
CapsLock & d::deleteVirtualDesktop() ; <-- Delete Current Desktop - remaining Desktops to the right will move down, in count, by 1

CapsLock & q::MoveCurrentWindowToDesktop(1) ; <-- Move Current/Active Window to Desktop 1
CapsLock & w::MoveCurrentWindowToDesktop(2) ; <-- Move Current/Active Window to Desktop 2
CapsLock & e::MoveCurrentWindowToDesktop(3) ; <-- Move Current/Active Window to Desktop 3
CapsLock & r::MoveCurrentWindowToDesktop(4) ; <-- Move Current/Active Window to Desktop 4
CapsLock & t::MoveCurrentWindowToDesktop(5) ; <-- Move Current/Active Window to Desktop 5
CapsLock & y::MoveCurrentWindowToDesktop(6) ; <-- Move Current/Active Window to Desktop 6
CapsLock & u::MoveCurrentWindowToDesktop(7) ; <-- Move Current/Active Window to Desktop 7
CapsLock & i::MoveCurrentWindowToDesktop(8) ; <-- Move Current/Active Window to Desktop 8
CapsLock & o::MoveCurrentWindowToDesktop(9) ; <-- Move Current/Active Window to Desktop 9

CapsLock & Right::MoveCurrentWindowToRightDesktop() ; <-- Move Current/Active Window to Right Desktop
CapsLock & Left::MoveCurrentWindowToLeftDesktop() ; <-- Move Current/Active Window to Left Desktop

; === INSTRUCTIONS ===
; Below is the alternate key configuration. Delete symbol ; in the beginning of the line to enable.
; Note, that  ^!1  means "Ctrl + Alt + 1" and  ^#1  means "Ctrl + Win + 1"
; === END OF INSTRUCTIONS ===

; ^!1::switchDesktopByNumber(1)
; ^!2::switchDesktopByNumber(2)
; ^!3::switchDesktopByNumber(3)
; ^!4::switchDesktopByNumber(4)
; ^!5::switchDesktopByNumber(5)
; ^!6::switchDesktopByNumber(6)
; ^!7::switchDesktopByNumber(7)
; ^!8::switchDesktopByNumber(8)
; ^!9::switchDesktopByNumber(9)

; ^!Numpad1::switchDesktopByNumber(1)
; ^!Numpad2::switchDesktopByNumber(2)
; ^!Numpad3::switchDesktopByNumber(3)
; ^!Numpad4::switchDesktopByNumber(4)
; ^!Numpad5::switchDesktopByNumber(5)
; ^!Numpad6::switchDesktopByNumber(6)
; ^!Numpad7::switchDesktopByNumber(7)
; ^!Numpad8::switchDesktopByNumber(8)
; ^!Numpad9::switchDesktopByNumber(9)

; ^!n::switchDesktopToRight()
; ^!p::switchDesktopToLeft()
; ^!s::switchDesktopToRight()
; ^!a::switchDesktopToLeft()
; ^!tab::switchDesktopToLastOpened()

; ^!c::createVirtualDesktop()
; ^!d::deleteVirtualDesktop()

; ^#1::MoveCurrentWindowToDesktop(1)
; ^#2::MoveCurrentWindowToDesktop(2)
; ^#3::MoveCurrentWindowToDesktop(3)
; ^#4::MoveCurrentWindowToDesktop(4)
; ^#5::MoveCurrentWindowToDesktop(5)
; ^#6::MoveCurrentWindowToDesktop(6)
; ^#7::MoveCurrentWindowToDesktop(7)
; ^#8::MoveCurrentWindowToDesktop(8)
; ^#9::MoveCurrentWindowToDesktop(9)

; ^#Numpad1::MoveCurrentWindowToDesktop(1)
; ^#Numpad2::MoveCurrentWindowToDesktop(2)
; ^#Numpad3::MoveCurrentWindowToDesktop(3)
; ^#Numpad4::MoveCurrentWindowToDesktop(4)
; ^#Numpad5::MoveCurrentWindowToDesktop(5)
; ^#Numpad6::MoveCurrentWindowToDesktop(6)
; ^#Numpad7::MoveCurrentWindowToDesktop(7)
; ^#Numpad8::MoveCurrentWindowToDesktop(8)
; ^#Numpad9::MoveCurrentWindowToDesktop(9)

; ^#Right::MoveCurrentWindowToRightDesktop()
; ^#Left::MoveCurrentWindowToLeftDesktop()



; === INSTRUCTIONS ===
; Additional alternative shortcut for moving current window to left or right desktop (ctrl+shift+Win+left/right)
; === END OF INSTRUCTIONS ===

; ^#+Right::MoveCurrentWindowToRightDesktop()
; ^#+Left::MoveCurrentWindowToLeftDesktop()
