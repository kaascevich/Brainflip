# Features

## ⚙️ Configurable Settings

### 🤖 Interpreter
- [x] Changing the behavior on end-of-input
- [x] Customizing the array size
- [x] Altering the intiial pointer location
- [x] Choosing between 1-, 2-, 4-, 8-, 16-, or 32-bit cells
- [x] Break instructions (#)

### ✍️ Editor
- [x] Syntax highlighting (off by default 'cause it's slow)
- [x] Custom font size
- [x] Highlighting the current instruction
- [x] Viewing the program size for the same reason as the timer

### 🔍 Inspector
- [x] Updating modules in real time
- [x] Customizing modules, namely:
  - [x] Current instruction
  - [x] Current instruction location
  - [x] Total instructions executed
  - [x] Pointer location
  - [x] Cell contents
  - [x] Cell contents (ASCII)
  - [x] Current input
  - [x] Current input index
  - [x] Array
  - [x] Pointer movement instructions
  - [x] Cell manipulation instructions
  - [x] Control flow instructions
  - [x] I/O instructions
  - [x] Break instructions
  
### 📤 Exporting
- [x] Exporting BF programs to C source, with support for customizing:
  - [x] Indentation
  - [x] The pointer name
  - [x] The array name
  - [x] The positions of `++` and `--`
  - [x] Whether to include `!= 0` in `while` statements
  - [x] New lines before `{`
  - [x] Including `void` within the declaration for `main()`
  - [x] Extreme whitespace customization

### Other
- [x] A timer, so you know exactly how inefficient a programmer you are
- [x] Sending notifications when something happens
- [x] Sound effects when something happens

## Other Features
- [x] An App Shortcut, so you can ~~inflict your pain~~ run BF programs *anywhere*!
- [x] Semi-comprehensive help
- [x] An extended ASCII chart (extended 'cause it's actually Unicode)
- [x] Copy and paste buttons
- [x] Viewing the array in a friendly interface
- [x] A Quick Look extension, because there's no denying how helpful syntax highlighting is with brainf\*\*k
