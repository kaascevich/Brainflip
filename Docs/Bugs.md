# 🐞 Known Bugs

- [ ] Program menu refreshes like mad when running a program
- [ ] Turning on toolbar button shapes turns the run button blue (????)
- [ ] Array popover test fails — it might be a bug in SwiftUI
- [ ] Editing inspector fields is allowed (although it resets upon losing focus)

## Squashed
- [x] Highlighting the current instruction is nonfunctional
- [x] Epilepsy warning needed when running large programs
- [x] Many views don't update when they should
- [x] Settings button doesn't appear in alert for array underflow
- [x] Progress bar sometimes gets initialized with an out-of-bounds value
- [x] App crash after selecting all and typing
- [x] App shortcut is completely broken (naturally)
- [x] Tests stall while building
- [x] Trim and Clear All are enabled with locked files
- [x] Unit tests just... fail before even starting? (UI tests are fine, though...)
  - Turns out it was an Xcode bug of some sort.
