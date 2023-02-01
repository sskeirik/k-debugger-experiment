# K Debugger Experiments

This repository contains a very simple PL semantics called _Base_.

Then several extensions of _Base_ are developed to facilitate/simulate a language-level debugger being built on top of _Base_.

## Experiment Design

Typically, when people run a debugger, they have an interactive command-line REPL or GUI where they can:

-   execute their program for `N` steps and;
-   set breakpoints on lines of code in various files so that execution will pause when a breakpoint line is reached.

To avoid developing a full blown REPL for this simple experiment, we instead let input programs to base have the form:

```
Int ; IntList ; Expression
```

where `Int` is a step count, `IntList` is a breakpoint set (given as a set of line numbers starting from `1`), and `Expression` is the program to be executed.
This design simulates a user entering a step count and/or breakpoint set into a REPL.

**NB:** In this simple PL, since a file cannot recursively load code from another file, we do not need to discriminate locations using filenames --- line numbers are sufficient.

The included semantics in this experiment are:

-   base       - the basic PL semantics without debugger support --- the step count and breakpoint set are ignored
-   base-fv    - extends base with support for counting steps via the _first visit_ strategy
-   base-ra    - extends base with support for counting steps via the _rule application_ strategy
-   base-ra-bp - extends base-ra with support setting breakpoints

## Base Definition

_Base_ is a very simple language where programs have the syntax shown above and with 4 types of expressions:

-   addition expressions, e.g. `3 + 4`
-   integer expressions, e.g. `-2` or `15000`
-   parenthetical expressions (used for associating subexpressions), e.g. `( 1 + 2 )`
-   loop expressions, e.g. to loop 3 times and execute the expression `3 + 4`, one would write: `loop(3, 3 + 4)`

Each kind of expression produces a integer result value:

-   addition expressions produce their summation as a result, e.g. `3 + 4 ~> 7`
-   integer expressions produce themselves as a result, e.g. `5 ~> 5`
-   parenthetical expressions produce the value of their inner expression as a result, e.g. `(3 + 4) ~> 7`
-   loop expressions produce `0` as their result when the loop body is never executed, e.g. `loop(0, 17) ~> 0`;
    otherwise, they produce the result of the last iteration of their body expression as a result, e.g. `loop(3, 3 + 4) ~> 7`

## Installation

### Prerequisites

**Building:** You will need a K installation as well as GNU `make` with the `kompile` and `make` binaries on your `PATH`.  

**Running:** You will need a K installation with the `krun` binary on your `PATH`.

### Building

After installing the build prerequisites, build by running `make`, i.e.,

```
$ make
```

### Running

After installing the run prerequisites, you can a test program in the included semantics `base-x`, by doing the following:

```
$ cd base-x
$ echo "<my-program>" | krun /dev/stdin
```

Or:

```
$ cd base-x
$ vi my-program.base # write your program to a file
$ krun my-program.base
```

It is instructive to experiment with the following as you run your _Base_ programs:

1.  try changing the step counter in your program to see how that affects when the program terminates
2.  try changing the breakpoint set in your program to see how that affects when the program terminates
3.  finally, you can use the `krun` option `--depth N` to set the maximum number of K rules that the interpreter will apply (this counter is separate from the step counter in a _Base_ program) to explore VM internal states

#### Running an Example

To run an included example program in the `/examples` folder, you can do the following:

```
$ cd base-x
$ krun ../examples/<example-name>.base
```

For a more concrete example, you may try:

```
$ cd base-ra-bp
$ krun ../examples/bp-test.base
```
