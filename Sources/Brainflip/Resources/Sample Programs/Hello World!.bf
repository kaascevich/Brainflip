[This program outputs "Hello World!" and a newline. Its length is 106 active instructions. (It is not the shortest.)]

[These loops are "initial comment loops", a simple way of adding comments to a Brainflip program such that you don't have to worry about any instructions. Any ".", ",", "+", "-", "<" and ">" characters are simply ignored, the "[" and "]" characters just have to be balanced. This loop and the instructions it contains are ignored because the current cell defaults to a value of 0; the 0 value causes this loop to be skipped.]
 
++++++++         Set cell 0 to 8
[
  >++++          Add 4 to cell 1; this always sets it to 4
  [              as the cell will be cleared by the loop
    >++          Add 2 to cell 2
    >+++         Add 3 to cell 3
    >+++         Add 3 to cell 4
    >+           Add 1 to cell 5
    <<<<-        Decrement the loop counter in cell 1
  ]              Loop until cell 1 is zero; 4 iterations
  >+             Add 1 to cell 2
  >+             Add 1 to cell 3
  >-             Subtract 1 from cell 4
  >>+            Add 1 to cell 6
  [<]            Move back to the first zero cell found; this will
                 be cell 1 which was cleared by the previous loop
  <-             Decrement the loop counter in cell 0
]                Loop until cell 0 is zero; 8 iterations

The result of this is:
Cell no :   0   1   2   3   4   5   6
Contents:   0   0  72 104  88  32   8
Pointer :   ^

>>.              Cell 2 has value 72 which is 'H'
>---.            Subtract 3 from cell 3 to get 101 which is 'e'
+++++++..+++.    Likewise for 'llo' from cell 3
>>.              Cell 5 is 32 for the space
<-.              Subtract 1 from cell 4 for 87 to get a 'W'
<.               Cell 3 was set to 'o' from the end of 'Hello'
+++.------.      Cell 3 for 'rl'
--------.        Cell 3 for 'd' too
>>+.             Add 1 to cell 5 to get an exclamation point
>++.             And finally a newline from cell 6
