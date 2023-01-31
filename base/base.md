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

  rule <k> (_:Int ; _:IntList ; E:Exp):Pgm => E </k>

  rule <k> N:Int + M:Int => N +Int M ... </k>

  rule <k> loop( Iter,  E) => E ~> loop(Iter -Int 1, E) ... </k> requires Iter >Int 0
  rule <k> loop(_Iter, _E) => 0                         ... </k> [owise]

  rule <k> _V:Value ~> loop( Iter,  E) => loop(Iter, E) ... </k> requires Iter >Int 0
  rule <k>  V:Value ~> loop(_Iter, _E) => V             ... </k> [owise]

endmodule
```
