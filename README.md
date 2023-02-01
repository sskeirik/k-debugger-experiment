# K Debugger Experiments

This repository contains a very simple PL semantics called _Base_.

Then several extensions of _Base_ are developed to facilitate a language-level debugger being built on top of _Base_.

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

# Installation

## Prerequisites

**Building:** You will need a K installation as well as GNU `make` with the `kompile` and `make` binaries on your `PATH`.  

**Running:** You will need a K installation with the `krun` binary on your `PATH`.

## Building

After installing the build prerequisites, build by running `make`, i.e.,

```
$ make
```

## Running

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
