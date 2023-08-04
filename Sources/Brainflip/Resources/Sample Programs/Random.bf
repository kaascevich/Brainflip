["Random" byte generator using the Rule 30 automaton.]
[Doesn't terminate; you will have to stop it yourself.]
[To get x bytes you need 32*x+4 cells.]
[Daniel B. Cristofani (http://brainfuck.org/)]

>>>++[
 <++++++++[
  <[<++>-]>>[>>]+>>+[
   -[->>+<<<[<[<<]<+>]>[>[>>]]]
   <[>>[-]]>[>[-<<]>[<+<]]+<<
  ]<[>+<-]>>-
 ]<.[-]>>
]
