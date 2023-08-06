# 🧠 Brainflip

![Swift 5.9] ![macOS Sonoma] ![Xcode 15]

[Swift 5.9]: https://img.shields.io/badge/Swift-5.9-%23f05138?logo=swift
[macOS Sonoma]: https://img.shields.io/badge/macOS-Sonoma-brightgreen?logo=apple
[Xcode 15]: https://img.shields.io/badge/Xcode-15-%23147efb?logo=Xcode

a human-usable brainf\*\*k interpreter for macOS

 - [Overview](#overview)
 - [License](/License.md)
 - [Features](/Docs/Features.md)
 - [Planned Features](/Docs/Planned.md)
 - [Known Bugs](/Docs/Bugs.md)

## Overview

We've all heard of brainf\*\*k -- you know, that "programming language" where the standard `Hello, World!` program looks like this:

```brainfuck
>++++++++[<+++++++++>-]<.>++++[<+++++++>-]<+.+++++++..+++.>>++++++[<+++++++>-]<+
+.------------.>++++++[<+++++++++>-]<+.<.+++.------.--------.>>>++++[<++++++++>-
]<+.
```

Not very enticing, is it? 🫤

Brainflip attempts (*attempts*) to remedy that.

![Typical Brainflip usage. You gotta admit, it's certainly better than the command line.](/Docs/Images/Demonstration.png)

You're provided with a relatively full-fledged editor to do your ~~evildoings~~ programming with. You can run programs, trim those programs to make them *really* unreadable, step through programs to identify that one stupid instruction that's breaking *literally everything*, and inspect just about every aspect of the interpreter, from the total instructions executed to the exact contents of the array.

Oh, and did I mention it's highly configurable? It's highly configurable. Like, *really* highly configurable. Like, *so* ridiculously configurable it's excessive.

![Brainflip's interpreter settings. You probably shouldn't mess around with some of these.](/Docs/Images/InterpreterSettings.png)

(A somewhat full list of features can be found in [`Features.md`](/Docs/Features.md).)

## Building and Running

First, [download the Xcode 15 beta](https://developer.apple.com/xcode) if you haven't already.

[Clone this repo](https://github.com/kaascevich/Brainflip.git), and open `Brainflip.xcodeproj`. Once Xcode's done with package resolution, hit ⌘R to build and run the project.

## References

I used the [epistle to the implementors](http://brainfuck.org/epistle.html "Hey Siri, define \"epistle\"") as a reference when putting together the interpreter and some of its settings. I don't know who the heck you are, but thanks anyway, Daniel.
