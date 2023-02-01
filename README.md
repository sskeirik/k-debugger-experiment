# K Debugger Experiments

This repository contains a very simple PL semantics called Base.

Then several extensions of Base are developed to facilitate a language-level debugger being built on top of Base.

Input programs to base have the form:

```
Int ; IntList ; Expression
```

where `Int` is a step count, `IntList` is a breakpoint set, and `Expression` is the program to be executed.

The included semantics are:

-   base       - the basic PL semantics without debugger support --- the step count and breakpoint set are ignored
-   base-fv    - extends base with support for counting steps via the _first visit_ strategy
-   base-ra    - extends base with support for counting steps via the _rule application_ strategy
-   base-ra-bp - extends base-ra with support setting breakpoints
