```k
module BASE-SYNTAX
  import INT-SYNTAX

  syntax BinOpName ::= "+"
  syntax Exp       ::= Exp BinOpName Exp [seqstrict(1,3)]
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

  syntax Exp       ::= Value
  syntax Value     ::= Int
  syntax KResult ::= Value

  configuration <k> $PGM:Pgm </k>
                <stepCount> 0 </stepCount>

  rule <k> (Count:Int ; _:IntList ; E:Exp):Pgm => #step() ~> E </k>
       <stepCount> _ => Count </stepCount>
    requires Count >Int 0

  rule <k> N:Int + M:Int => #step() ~> N +Int M ... </k> requires #enabled()

  rule <k> loop( Iter,  E) => #step() ~> E ~> loop(Iter -Int 1, E) ... </k> requires #enabled() andBool Iter >Int 0
  rule <k> loop(_Iter, _E) => #step() ~> 0                         ... </k> requires #enabled() [owise]

  rule <k> _V:Value ~> loop( Iter,  E) => #step() ~> loop(Iter, E) ... </k> requires #enabled() andBool Iter >Int 0
  rule <k>  V:Value ~> loop(_Iter, _E) => #step() ~> V             ... </k> requires #enabled() [owise]

  //////////////////////////////////////

  syntax Bool ::= #enabled() [function]
  // ----------------------------------
  rule [[ #enabled() => Count =/=Int 0 ]]
       <stepCount> Count </stepCount>

  syntax KItem ::= #step()
  // ---------------------
  rule <k> #step() => . ... </k>
       <stepCount> Count => Count -Int 1 </stepCount>

endmodule
```
