# Dec Hex Bin

A REPL for integer arithmetic, supporting decimal, hexadecimal, and binary.

```
> 2
2       0x2     0b10
> 0x24 + 1
37      0x25    0b100101        '%'
> (1 << 8) - 1
255     0xFF    0b11111111
```

## Operators

All values are represented internally as a `signed long int`.

|Operator|Operation|
|--|--|
|`+`|signed addition|
|`-`|signed subtraction|
|`*`|multiplication|
|`/`|integer division|
|`<<`|left shift|
|`>>`|right shift|
|`^`|exponentiate|

## Building

Requires readline, flex, and bison.
