```k
module BASE-SYNTAX
  import INT-SYNTAX
  import K-LOCATIONS

  syntax Exp [locations]

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
  import SET

  syntax Exp       ::= Value
  syntax Value     ::= Int
  syntax KResult ::= Value

  configuration <k> $PGM:Pgm </k>
                <stepCount> 0 </stepCount>
                <breakPoints> .Set </breakPoints>
                <enabled> true </enabled>
                <loc> -1 </loc>

  rule <k> (Count:Int ; BPs:IntList ; E:Exp):Pgm => #step() ~> E </k>
       <stepCount> _ => Count </stepCount>
       <breakPoints> _ => IntList2Set(BPs) </breakPoints>
    requires Count >Int 0

  rule <k> N:Int + M:Int => #step() ~> N +Int M ... </k> requires #enabled()

  rule <k> loop( Iter,  E) => #step() ~> E ~> loop(Iter -Int 1, E) ... </k> requires #enabled() andBool Iter >Int 0
  rule <k> loop(_Iter, _E) => #step() ~> 0                         ... </k> requires #enabled() [owise]

  rule <k> _V:Value ~> loop( Iter,  E) => #step() ~> loop(Iter, E) ... </k> requires #enabled() andBool Iter >Int 0
  rule <k>  V:Value ~> loop(_Iter, _E) => #step() ~> V             ... </k> requires #enabled() [owise]

  //////////////////////////////////////

  syntax Bool ::= #enabled() [function]
  // ----------------------------------
  rule [[ #enabled() => Count =/=Int 0 andBool (notBool L in BPs) ]]
       <stepCount> Count </stepCount>
       <breakPoints> BPs </breakPoints>
       <loc> L:Int </loc>

  syntax KItem ::= #step()
  // ---------------------
  rule <k> #step() => . ... </k>
       <stepCount> Count => Count -Int 1 </stepCount>

  //////////////////////////////////////

  syntax Set ::= IntList2Set(IntList) [function, total]
  // --------------------------------------------------
  rule IntList2Set(I IL)     => SetItem(I) |Set IntList2Set(IL)
  rule IntList2Set(.IntList) => .Set

  rule <k> #location(E:Exp, _, StartLine:Int, _, _, _) => E ... </k>
       <loc> _ => StartLine </loc>
endmodule
```
