# Swift S-expression Calculator

<a href="https://developer.apple.com/swift/">
   <img src="https://img.shields.io/badge/Swift-5.3-orange.svg?style=flat" alt="Swift 5.3">
</a>
  

Command line program written in Swift that acts as a simple calculator: it takes a single argument as an expression and prints out the integer result of evaluating it.

## Expression syntax

The syntax resembles S-expressions but the rules are simplified. An expression can be in one of two forms:

### Integers

An integer is just a sequence of base 10 digits. For example:

    123

### Function calls

A function call takes the following form:

    (FUNCTION EXPR EXPR)

A function call is always delimited by parenthesis `(` and `)`.

The `FUNCTION` is one of `add` or `multiply`.

The `EXPR` can be any arbitrary expression, i.e. it can be further function
calls or integer expressions.

Exactly one space is used to separate each term.

For example:

    (add 123 456)

    (multiply (add 1 2) 3)

## Runing the program

The program can be built using the command:
   
    swift build -c release

And its `SwiftCalculator` executable will be located inside the `.build/release/` folder.

