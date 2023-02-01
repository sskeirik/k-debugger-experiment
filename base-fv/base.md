```k
module BASE-SYNTAX
  import INT-SYNTAX

  syntax BinOpName ::= "+"
  syntax Exp       ::= Exp BinOpName Exp
                     | loop(Int, Exp)
                     | "(" Exp ")"       [bracket]
                     | Int
  syntax Pgm       ::= Int ";" IntList ";" Exp
  syntax IntList   ::= List{Int, ""}
endmodule
```

```k
module BASE
  import BASE-SYNTAX
  import INT
  import SORT-K
  import BOOL
  import K-EQUAL

  syntax Exp     ::= Value
  syntax Value   ::= #i(Int)
  syntax KResult ::= Value

  configuration <k> $PGM:Pgm </k>
                <stepCount> 0 </stepCount>

  rule <k> (Count:Int ; _:IntList ; E:Exp):Pgm => #step() ~> E </k>
       <stepCount> _ => Count </stepCount>
    requires Count >Int 0

  rule <k> #+(#i(N:Int), #i(M:Int)) => N +Int M ... </k>

  rule <k> #loop( Iter,  E) => E ~> #loop(Iter -Int 1, E) ... </k> requires Iter >Int 0
  rule <k> #loop(_Iter, _E) => 0                          ... </k> [owise]

  rule <k> _V:Value ~> #loop( Iter,  E) => #loop(Iter, E) ... </k> requires Iter >Int 0
  rule <k>  V:Value ~> #loop(_Iter, _E) =>  V             ... </k> [owise]

  //////////////////////////////////////

  syntax Bool ::= #enabled() [function]
  // ----------------------------------
  rule [[ #enabled() => Count =/=Int 0 ]]
       <stepCount> Count </stepCount>

  syntax KItem ::= #step()
  // ---------------------
  rule <k> #step() => . ... </k>
       <stepCount> Count => Count -Int 1 </stepCount>

  syntax KItem ::= "#+" "(" Exp "," Exp ")" [seqstrict]
                 | #loop(Int, Exp)

  rule <k> I:Int           => #step() ~> #i(I)       ... </k> requires #enabled()
  rule <k> E1:Exp + E2:Exp => #step() ~> #+(E1, E2)  ... </k> requires #enabled()
  rule <k> loop(I, E)      => #step() ~> #loop(I, E) ... </k> requires #enabled()

endmodule
```
